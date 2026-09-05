import assert from "node:assert/strict";
import { spawn, type ChildProcessWithoutNullStreams } from "node:child_process";
import { once } from "node:events";
import { createServer } from "node:net";
import path from "node:path";
import { setTimeout as delay } from "node:timers/promises";
import test, { after, before } from "node:test";
import { PrismaClient } from "@prisma/client";

const backendRoot = path.resolve(__dirname, "../..");
const testDatabaseUrl = process.env.TEST_DATABASE_URL;

function requireSafeTestDatabaseUrl(value: string | undefined): string {
  assert.ok(
    value,
    "TEST_DATABASE_URL é obrigatória para os testes de integração",
  );

  const databaseName = decodeURIComponent(new URL(value).pathname.slice(1));
  assert.match(
    databaseName,
    /(test|ci)/i,
    "TEST_DATABASE_URL deve apontar para um banco identificado como teste",
  );

  return value;
}

const safeDatabaseUrl = requireSafeTestDatabaseUrl(testDatabaseUrl);
const prisma = new PrismaClient({
  datasources: { db: { url: safeDatabaseUrl } },
});

let apiProcess: ChildProcessWithoutNullStreams;
let apiBaseUrl: string;
let apiOutput = "";

async function reservePort(): Promise<number> {
  const server = createServer();
  server.listen(0, "127.0.0.1");
  await once(server, "listening");

  const address = server.address();
  assert.ok(address && typeof address !== "string");
  const { port } = address;

  server.close();
  await once(server, "close");
  return port;
}

async function waitForApi(): Promise<void> {
  for (let attempt = 0; attempt < 50; attempt += 1) {
    if (apiProcess.exitCode !== null) {
      throw new Error(`A API encerrou antes de iniciar:\n${apiOutput}`);
    }

    try {
      const response = await fetch(`${apiBaseUrl}/health`);
      if (response.ok) return;
    } catch {
      // A inicialização do ts-node e do Prisma pode levar alguns instantes.
    }

    await delay(100);
  }

  throw new Error(`A API não ficou disponível a tempo:\n${apiOutput}`);
}

async function requestJson(
  route: string,
  init: RequestInit = {},
): Promise<{ response: Response; body: any }> {
  const response = await fetch(`${apiBaseUrl}${route}`, {
    ...init,
    headers: {
      ...(init.body ? { "Content-Type": "application/json" } : {}),
      ...init.headers,
    },
  });
  const body = await response.json();
  return { response, body };
}

function futureDate(): string {
  const value = new Date();
  value.setUTCDate(value.getUTCDate() + 7);
  const day = String(value.getUTCDate()).padStart(2, "0");
  const month = String(value.getUTCMonth() + 1).padStart(2, "0");
  return `${day}/${month}/${value.getUTCFullYear()}`;
}

before(async () => {
  await prisma.evento.deleteMany();
  await prisma.usuario.deleteMany();

  const port = await reservePort();
  apiBaseUrl = `http://127.0.0.1:${port}`;
  apiProcess = spawn(
    process.execPath,
    ["--require", "ts-node/register", "src/index.ts"],
    {
      cwd: backendRoot,
      env: {
        ...process.env,
        DATABASE_URL: safeDatabaseUrl,
        PORT: String(port),
      },
      stdio: ["pipe", "pipe", "pipe"],
    },
  );

  apiProcess.stdout.on("data", (chunk) => {
    apiOutput += chunk.toString();
  });
  apiProcess.stderr.on("data", (chunk) => {
    apiOutput += chunk.toString();
  });

  await waitForApi();
});

after(async () => {
  await prisma.evento.deleteMany();
  await prisma.usuario.deleteMany();
  await prisma.$disconnect();

  if (apiProcess && apiProcess.exitCode === null) {
    apiProcess.kill("SIGTERM");
    await Promise.race([once(apiProcess, "exit"), delay(3000)]);
    if (apiProcess.exitCode === null) apiProcess.kill("SIGKILL");
  }
});

test("cadastra, persiste e autentica um artista sem expor a senha", async () => {
  const email = "artista.integracao@muve.test";
  const password = "senha-segura-123";

  const registration = await requestJson("/auth/register", {
    method: "POST",
    body: JSON.stringify({
      nome: "Artista Integração",
      email,
      senha: password,
      tipoPessoa: "PF",
      tipoConta: "ARTISTA",
      cpf: "12345678901",
    }),
  });

  assert.equal(registration.response.status, 201);
  assert.equal(registration.body.success, true);
  assert.equal(registration.body.user.email, email);
  assert.equal(registration.body.user.tipoConta, "ARTISTA");
  assert.equal("senha" in registration.body.user, false);

  const login = await requestJson("/auth/login", {
    method: "POST",
    body: JSON.stringify({ email, senha: password }),
  });

  assert.equal(login.response.status, 200);
  assert.equal(login.body.success, true);
  assert.equal(login.body.user.email, email);
  assert.equal("senha" in login.body.user, false);

  const users = await requestJson("/auth/usuarios?tipoConta=ARTISTA");
  assert.equal(users.response.status, 200);
  assert.equal(users.body.length, 1);
  assert.equal(users.body[0].email, email);
  assert.equal("senha" in users.body[0], false);
});

test("cria, lista e exclui um evento persistido", async () => {
  const creation = await requestJson("/eventos", {
    method: "POST",
    body: JSON.stringify({
      titulo: "Festival de Integração",
      descricao: "Evento criado pela suíte de integração",
      local: "Palco de Testes",
      data: ` ${futureDate()} `,
      hora: " 19:30 ",
      categoria: "MPB",
    }),
  });

  assert.equal(creation.response.status, 201);
  assert.equal(creation.body.titulo, "Festival de Integração");
  assert.equal(creation.body.hora, "19:30");

  const listing = await requestJson("/eventos");
  assert.equal(listing.response.status, 200);
  assert.equal(listing.body.length, 1);
  assert.equal(listing.body[0].id, creation.body.id);

  const deletion = await requestJson(`/eventos/${creation.body.id}`, {
    method: "DELETE",
  });
  assert.equal(deletion.response.status, 200);
  assert.deepEqual(deletion.body, { success: true });

  const emptyListing = await requestJson("/eventos");
  assert.equal(emptyListing.response.status, 200);
  assert.deepEqual(emptyListing.body, []);
});
