CUPONS_PERCENTUAIS = {
    "DEVOPS10":10,
    "CUPOMBOASVINDAS":5
}

def obterDescontoCupom(cupom):
    if cupom is None:
        return 0

    codigo = cupom.strip().upper()

    if codigo not in CUPONS_PERCENTUAIS:
        raise ValueError("Cupom inválido!")

    return CUPONS_PERCENTUAIS[codigo]

