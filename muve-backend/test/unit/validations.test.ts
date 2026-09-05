import assert from "node:assert/strict";
import { test } from "node:test";

import {
  validarCadastro,
  validarDataEvento,
  validarHoraEvento,
} from "../../src/validations";

const cadastroBase = {
  nome: "Ana",
  email: "ana@example.com",
  senha: "segredo",
};

test("valida os campos e tipos do cadastro na ordem da API", () => {
  assert.equal(
    validarCadastro({}),
    "nome, email e senha são obrigatórios",
  );
  assert.equal(
    validarCadastro({ ...cadastroBase, tipoConta: "OUTRO", tipoPessoa: "PF" }),
    "tipoConta deve ser ARTISTA ou CONTRATANTE",
  );
  assert.equal(
    validarCadastro({
      ...cadastroBase,
      tipoConta: "ARTISTA",
      tipoPessoa: "OUTRO",
    }),
    'tipoPessoa deve ser "PF" ou "PJ"',
  );
});

test("aplica as regras específicas de cadastro PF e PJ", () => {
  assert.equal(
    validarCadastro({
      ...cadastroBase,
      tipoConta: "ARTISTA",
      tipoPessoa: "PF",
    }),
    "CPF é obrigatório para PF",
  );
  assert.equal(
    validarCadastro({
      ...cadastroBase,
      tipoConta: "ARTISTA",
      tipoPessoa: "PF",
      cpf: "12345678900",
    }),
    null,
  );
  assert.equal(
    validarCadastro({
      ...cadastroBase,
      tipoConta: "CONTRATANTE",
      tipoPessoa: "PJ",
      cnpj: "12345678000100",
    }),
    "CNPJ e razão social são obrigatórios para PJ",
  );
  assert.equal(
    validarCadastro({
      ...cadastroBase,
      tipoConta: "CONTRATANTE",
      tipoPessoa: "PJ",
      cnpj: "12345678000100",
      razaoSocial: "Ana Produções",
    }),
    null,
  );
});

test("valida formato, calendário e passado com relógio fixo", () => {
  const agora = new Date(2026, 8, 4, 21, 15);

  assert.equal(validarDataEvento("04/09/2026", agora), null);
  assert.equal(
    validarDataEvento("03/09/2026", agora),
    "Data do evento não pode ser no passado",
  );
  assert.equal(validarDataEvento("31/02/2027", agora), "Data inválida");
  assert.equal(
    validarDataEvento("2027-09-04", agora),
    "Data deve estar no formato DD/MM/AAAA",
  );
});

test("valida hora no formato de 24 horas", () => {
  assert.equal(validarHoraEvento("00:00"), null);
  assert.equal(validarHoraEvento("23:59"), null);
  assert.equal(validarHoraEvento("24:00"), "Hora inválida");
  assert.equal(validarHoraEvento("12:60"), "Hora inválida");
  assert.equal(
    validarHoraEvento("9:00"),
    "Hora deve estar no formato HH:MM (24h)",
  );
});
