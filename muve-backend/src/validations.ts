export interface CadastroInput {
  nome?: unknown;
  email?: unknown;
  senha?: unknown;
  tipoPessoa?: unknown;
  cpf?: unknown;
  cnpj?: unknown;
  razaoSocial?: unknown;
  tipoConta?: unknown;
}

export function validarCadastro({
  nome,
  email,
  senha,
  tipoPessoa,
  cpf,
  cnpj,
  razaoSocial,
  tipoConta,
}: CadastroInput): string | null {
  if (!nome || !email || !senha) {
    return "nome, email e senha são obrigatórios";
  }

  if (!tipoConta || !["ARTISTA", "CONTRATANTE"].includes(tipoConta as string)) {
    return "tipoConta deve ser ARTISTA ou CONTRATANTE";
  }

  if (!tipoPessoa || !["PF", "PJ"].includes(tipoPessoa as string)) {
    return 'tipoPessoa deve ser "PF" ou "PJ"';
  }

  if (tipoPessoa === "PF" && !cpf) {
    return "CPF é obrigatório para PF";
  }

  if (tipoPessoa === "PJ" && (!cnpj || !razaoSocial)) {
    return "CNPJ e razão social são obrigatórios para PJ";
  }

  return null;
}

export function validarDataEvento(
  data: string,
  agora: Date = new Date(),
): string | null {
  const dataRegex = /^\d{2}\/\d{2}\/\d{4}$/;
  if (!dataRegex.test(data)) {
    return "Data deve estar no formato DD/MM/AAAA";
  }

  const [diaStr, mesStr, anoStr] = data.split("/");
  const dia = Number(diaStr);
  const mes = Number(mesStr);
  const ano = Number(anoStr);
  const jsDate = new Date(ano, mes - 1, dia);

  if (
    jsDate.getFullYear() !== ano ||
    jsDate.getMonth() !== mes - 1 ||
    jsDate.getDate() !== dia
  ) {
    return "Data inválida";
  }

  const hoje = new Date(agora.getTime());
  hoje.setHours(0, 0, 0, 0);
  jsDate.setHours(0, 0, 0, 0);

  if (jsDate < hoje) {
    return "Data do evento não pode ser no passado";
  }

  return null;
}

export function validarHoraEvento(hora: string): string | null {
  const horaRegex = /^\d{2}:\d{2}$/;
  if (!horaRegex.test(hora)) {
    return "Hora deve estar no formato HH:MM (24h)";
  }

  const [hStr, mStr] = hora.split(":");
  const h = Number(hStr);
  const m = Number(mStr);

  if (
    Number.isNaN(h) ||
    Number.isNaN(m) ||
    h < 0 ||
    h > 23 ||
    m < 0 ||
    m > 59
  ) {
    return "Hora inválida";
  }

  return null;
}
