--- Consulta 7: desenvolvedores que possuem pelo menos um jogo com DLC ja vendida.
--- A existencia e testada por uma SUBCONSULTA CORRELACIONADA com EXISTS.
--- EXISTS, COUNT em subconsulta escalar correlacionada, ORDER BY ASC.
SELECT d.nome AS desenvolvedor,
       (SELECT COUNT(*) FROM jogo j WHERE j.id_desenvolvedor = d.id_desenvolvedor) AS qtd_jogos
FROM desenvolvedor d
WHERE EXISTS (SELECT 1
                FROM jogo j
                INNER JOIN dlc       ON dlc.id_jogo_base = j.id_jogo
                INNER JOIN item_compra i ON i.id_dlc = dlc.id_dlc
               WHERE j.id_desenvolvedor = d.id_desenvolvedor)
ORDER BY d.nome ASC;
