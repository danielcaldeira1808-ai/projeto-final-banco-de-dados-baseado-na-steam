--- Consulta 1: faturamento, repasse e ticket medio por desenvolvedor.
--- Considera apenas itens de JOGO de compras 'concluida'. Mostra so quem faturou algo.
--- INNER JOIN com 4 tabelas, COUNT/SUM/AVG, GROUP BY com 2 colunas, HAVING, ORDER BY DESC.
SELECT d.id_desenvolvedor,
       d.nome                                   AS desenvolvedor,
       COUNT(*)                                 AS itens_vendidos,
       SUM(i.preco_pago_centavos)  / 100.0      AS faturamento_reais,
       SUM(i.repasse_desenvolvedor_centavos) / 100.0 AS repasse_reais,
       ROUND(AVG(i.preco_pago_centavos) / 100.0, 2)  AS ticket_medio_reais
FROM desenvolvedor d
INNER JOIN jogo j         ON j.id_desenvolvedor = d.id_desenvolvedor
INNER JOIN item_compra i  ON i.id_jogo = j.id_jogo
INNER JOIN compra c       ON c.id_compra = i.id_compra
WHERE c.status = 'concluida'
GROUP BY d.id_desenvolvedor, d.nome
HAVING SUM(i.preco_pago_centavos) > 0
ORDER BY faturamento_reais DESC;
