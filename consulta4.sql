--- Consulta 4: percentual de avaliacoes que recomendam cada jogo.
--- So jogos com pelo menos 2 avaliacoes. NULLIF evita divisao por zero.
--- INNER JOIN, COUNT/SUM, NULLIF, GROUP BY com 2 colunas, HAVING, ORDER BY DESC.
SELECT j.id_jogo,
       j.titulo,
       COUNT(a.id_avaliacao)                                            AS total_avaliacoes,
       SUM(a.recomenda)                                                 AS recomendacoes,
       ROUND(100.0 * SUM(a.recomenda) / NULLIF(COUNT(a.id_avaliacao), 0), 1) AS pct_recomendam
FROM jogo j INNER JOIN avaliacao a ON a.id_jogo = j.id_jogo GROUP BY j.id_jogo, j.titulo HAVING COUNT(a.id_avaliacao) >= 2 
ORDER BY pct_recomendam DESC, total_avaliacoes DESC;
