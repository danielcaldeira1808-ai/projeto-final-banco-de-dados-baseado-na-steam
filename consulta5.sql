--- Consulta 5: jogos aprovados e pagos com preco acima da media dos jogos pagos.
--- A media e calculada por uma SUBCONSULTA ESCALAR (devolve um unico valor).
--- Tecnicas: subconsulta escalar com AVG, ORDER BY DESC.
SELECT j.titulo,
       j.preco_centavos / 100.0 AS preco_reais,
       ROUND(j.preco_centavos / 100.0
             - (SELECT AVG(preco_centavos) FROM jogo
                 WHERE status_aprovacao = 'aprovado' AND preco_centavos > 0) / 100.0, 2) AS acima_da_media_reais
FROM jogo j
WHERE j.status_aprovacao = 'aprovado'
  AND j.preco_centavos > (SELECT AVG(preco_centavos) FROM jogo
                           WHERE status_aprovacao = 'aprovado' AND preco_centavos > 0)
ORDER BY acima_da_media_reais DESC;
