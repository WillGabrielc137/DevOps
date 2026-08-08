from desconto import obterDescontoCupom

def calcular_total(itens, desconto_percentual = 0, cupom = None):
    if not 0 <= desconto_percentual <= 100:
        raise ValueError("O desconto precisa estar entre 0 e 100.")

    subtotal = sum(
        preco_unitario * quantidade
        for preco_unitario, quantidade in itens
    )

    descontoTotal = desconto_percentual + obterDescontoCupom(cupom)  
    descontoTotal = min(descontoTotal, 100)
     
    desconto = subtotal * (descontoTotal / 100)
    total = subtotal - desconto

    return round(total, 2)


