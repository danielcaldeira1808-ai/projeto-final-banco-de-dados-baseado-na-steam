-- testes_violacao.sql | cada comando abaixo VIOLA de proposito uma regra; o banco deve recusar todos.
-- Execute um por vez (com PRAGMA foreign_keys = ON) e registre a mensagem de erro.
PRAGMA foreign_keys = ON;

-- T01 [Integridade referencial / R1] jogo apontando para desenvolvedor inexistente
INSERT INTO jogo (id_desenvolvedor, titulo, preco_centavos) VALUES (99, 'Jogo Fantasma', 1000);

-- T02 [CHECK / R10] preco negativo
INSERT INTO jogo (id_desenvolvedor, titulo, preco_centavos) VALUES (1, 'Jogo Barato Demais', -100);

-- T03 [UNIQUE] e-mail repetido
INSERT INTO usuario (nome_usuario, email, data_nascimento) VALUES ('ana_clone', 'ana@example.com', '2000-01-01');

-- T04 [UNIQUE / R3] o mesmo jogo duas vezes na biblioteca
INSERT INTO biblioteca (id_usuario, id_jogo) VALUES (1, 1);

-- T05 [FK composta / R6] avaliar um jogo que o usuario nao possui (diego_souza nao tem Moonlit Tactics)
INSERT INTO avaliacao (id_usuario, id_jogo, recomenda) VALUES (5, 3, 1);

-- T06 [CHECK / R12] amizade de um usuario consigo mesmo
INSERT INTO amizade (id_solicitante, id_destinatario) VALUES (2, 2);

-- T07 [CHECK / R9] promocao com data final anterior a inicial
INSERT INTO promocao (nome, desconto_pct, data_inicio, data_fim) VALUES ('Promo Invalida', 20, '2026-12-10 00:00:00', '2026-12-01 00:00:00');

-- T08 [Trigger R4] concluir compra sem pagamento confirmado (compra 8 esta com pagamento pendente)
UPDATE compra SET status = 'concluida' WHERE id_compra = 8;

-- T09 [Trigger R8] reembolso de jogo finalizado / com 2 horas ou mais (item 6 = Shadow Crypt da marina_lopes)
INSERT INTO reembolso (id_item_compra, data_pedido, motivo) VALUES (6, '2026-11-05 10:00:00', 'Quero meu dinheiro');

-- T10 [Trigger R8] reembolso fora do prazo de 14 dias (item 1, comprado em 2026-10-05)
INSERT INTO reembolso (id_item_compra, data_pedido, motivo) VALUES (1, '2026-11-15 10:00:00', 'Fora do prazo');

-- T11 [RESTRICT / historico] excluir desenvolvedor que possui jogos
DELETE FROM desenvolvedor WHERE id_desenvolvedor = 1;

-- T12 [CHECK] item de compra que e jogo E DLC ao mesmo tempo
INSERT INTO item_compra (id_compra, id_jogo, id_dlc, preco_pago_centavos, repasse_desenvolvedor_centavos) VALUES (8, 1, 1, 100, 70);

-- T13 [RESTRICT / decisao 12] remover da biblioteca um jogo que o usuario ja avaliou e com conquistas (ana_silva, Pixel Quest)
DELETE FROM biblioteca WHERE id_usuario = 1 AND id_jogo = 1;
