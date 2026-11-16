--- Consulta 8: painel por jogador (gasto total e horas jogadas), inclusive quem nao comprou nada.
--- Duas CTEs calculam os totais separadamente; COALESCE troca NULL por zero.
--- Tecnicas: CTE (WITH), LEFT JOIN, COALESCE, ORDER BY DESC.
WITH gasto AS (
    SELECT c.id_usuario, SUM(i.preco_pago_centavos) AS total_centavos
      FROM compra c
      INNER JOIN item_compra i ON i.id_compra = c.id_compra
     WHERE c.status = 'concluida'
     GROUP BY c.id_usuario
),
tempo AS (
    SELECT id_usuario, SUM(minutos_jogados) AS minutos, COUNT(*) AS jogos
      FROM biblioteca
     GROUP BY id_usuario
)
SELECT u.nome_usuario,
       COALESCE(t.jogos, 0)                    AS jogos_na_biblioteca,
       COALESCE(g.total_centavos, 0) / 100.0   AS gasto_reais,
       ROUND(COALESCE(t.minutos, 0) / 60.0, 1) AS horas_jogadas
FROM usuario u
LEFT JOIN gasto g ON g.id_usuario = u.id_usuario
LEFT JOIN tempo t ON t.id_usuario = u.id_usuario
ORDER BY gasto_reais DESC, u.nome_usuario ASC;
