--- Consulta 3: receita confirmada por mes e por metodo de pagamento.
--- Mostra so combinacoes (mes, metodo) que somaram mais de R$ 20,00.
--- Tecnicas: INNER JOIN, SUM/MIN/MAX/COUNT, GROUP BY com 2 colunas, HAVING, ORDER BY ASC e DESC.
SELECT strftime('%Y-%m', p.data_pagamento)  AS mes,
       p.metodo,
       COUNT(*)                             AS qtd_pagamentos,
       SUM(p.valor_centavos)  / 100.0       AS total_reais,
       MIN(p.valor_centavos)  / 100.0       AS menor_reais,
       MAX(p.valor_centavos)  / 100.0       AS maior_reais
FROM pagamento p
INNER JOIN compra c ON c.id_compra = p.id_compra
WHERE p.status = 'confirmado'
GROUP BY mes, p.metodo
HAVING SUM(p.valor_centavos) > 2000
ORDER BY mes ASC, total_reais DESC;
