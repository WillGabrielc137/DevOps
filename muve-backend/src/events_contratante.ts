// src/events_contratante.ts
import { Router } from "express";
import { PrismaClient } from "@prisma/client";
import { validarDataEvento, validarHoraEvento } from "./validations";

const router = Router();
const prisma = new PrismaClient();

// GET – listar eventos
router.get("/", async (_req, res) => {
  try {
    const eventos = await prisma.evento.findMany({
      orderBy: { id: "desc" },
    });
    res.json(eventos);
  } catch (e) {
    console.error(e);
    res
      .status(500)
      .json({ success: false, message: "Erro ao listar eventos" });
  }
});

// POST – criar evento
router.post("/", async (req, res) => {
  try {
    const { titulo, descricao, local, data, hora, categoria } = req.body ?? {};

    // obrigatórios
    if (!titulo || !hora || !local || !data) {
      return res.status(400).json({
        success: false,
        message: "Título, Data, Hora e Local são obrigatórios",
      });
    }

    const dataStr = String(data).trim();
    const horaStr = String(hora).trim();

    const errors = [
      validarDataEvento(dataStr),
      validarHoraEvento(horaStr),
    ].filter((error): error is string => error !== null);

    if (errors.length > 0) {
      return res.status(400).json({
        success: false,
        message: errors.join(" | "),
      });
    }

    const evento = await prisma.evento.create({
      data: {
        titulo,
        descricao,
        local,
        data: dataStr, // continua String no banco, mas agora validada
        hora: horaStr,
        categoria,
      },
    });

    res.status(201).json(evento);
  } catch (e) {
    console.error(e);
    res
      .status(500)
      .json({ success: false, message: "Erro ao criar evento" });
  }
});

// DELETE – excluir evento
router.delete("/:id", async (req, res) => {
  try {
    const id = Number(req.params.id);
    await prisma.evento.delete({ where: { id } });
    res.json({ success: true });
  } catch (e) {
    console.error(e);
    res
      .status(500)
      .json({ success: false, message: "Erro ao excluir evento" });
  }
});

export default router;
