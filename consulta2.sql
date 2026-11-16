--- Consulta 2: vendas de TODOS os jogos, inclusive os que nunca foram vendidos.
--- Jogos sem venda aparecem com 0 unidades e a legenda 'sem vendas'.
--- LEFT JOIN com 3 tabelas, COALESCE (trata NULL), CASE, GROUP BY com 2 colunas, ORDER BY ASC.
SELECT j.id_jogo,
       j.titulo,
       COUNT(c.id_compra)                                   AS unidades_vendidas,
       COALESCE(SUM(CASE WHEN c.id_compra IS NOT NULL THEN i.preco_pago_centavos END), 0) / 100.0      AS receita_reais,
       CASE WHEN COUNT(c.id_compra) = 0 THEN 'sem vendas' ELSE 'com vendas' END AS situacao
FROM jogo j
LEFT JOIN item_compra i ON i.id_jogo = j.id_jogo
LEFT JOIN compra c      ON c.id_compra = i.id_compra AND c.status = 'concluida'
GROUP BY j.id_jogo, j.titulo
ORDER BY j.titulo ASC;
