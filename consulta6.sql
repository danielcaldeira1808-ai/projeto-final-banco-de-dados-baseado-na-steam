--- Consulta 6: usuarios que possuem jogos dos generos 'Estrategia' ou 'Terror'.
--- A lista de jogos desses generos vem de uma SUBCONSULTA com IN.
--- Tecnicas: subconsulta com IN (aninhada), INNER JOIN, ORDER BY ASC.
SELECT u.nome_usuario,
       j.titulo,
       ROUND(b.minutos_jogados / 60.0, 1) AS horas_jogadas
FROM biblioteca b
INNER JOIN usuario u ON u.id_usuario = b.id_usuario
INNER JOIN jogo j    ON j.id_jogo = b.id_jogo
WHERE b.id_jogo IN (SELECT jgt.id_jogo
                      FROM jogo_genero_tag jgt
                     WHERE jgt.id_genero_tag IN (SELECT id_genero_tag FROM genero_tag
                                                  WHERE nome IN ('Estrategia', 'Terror')))
ORDER BY j.titulo ASC, u.nome_usuario ASC;
