-- script_dml.sql | dados de teste coerentes para todas as tabelas
-- Gerado por tools/gerar_dml.py (valores calculados: desconto e repasse).
PRAGMA foreign_keys = ON;

-- usuario
INSERT INTO usuario (id_usuario, nome_usuario, email, data_nascimento, data_cadastro) VALUES (1, 'ana_silva', 'ana@example.com', '1998-04-12', '2026-01-10 09:00:00');
INSERT INTO usuario (id_usuario, nome_usuario, email, data_nascimento, data_cadastro) VALUES (2, 'bruno_costa', 'bruno@example.com', '2001-09-30', '2026-02-14 18:30:00');
INSERT INTO usuario (id_usuario, nome_usuario, email, data_nascimento, data_cadastro) VALUES (3, 'marina_lopes', 'marina@example.com', '1995-01-20', '2026-03-03 12:00:00');
INSERT INTO usuario (id_usuario, nome_usuario, email, data_nascimento, data_cadastro) VALUES (4, 'carlos_teen', 'carlos@example.com', '2010-06-15', '2026-05-21 15:45:00');
INSERT INTO usuario (id_usuario, nome_usuario, email, data_nascimento, data_cadastro) VALUES (5, 'diego_souza', 'diego@example.com', '2003-11-03', '2026-09-30 20:10:00');

-- desenvolvedor
INSERT INTO desenvolvedor (id_desenvolvedor, nome, email_contato, status_aprovacao, taxa_plataforma_pct) VALUES (1, 'Pixel Forge', 'contato@pixelforge.example.com', 'aprovado', 30);
INSERT INTO desenvolvedor (id_desenvolvedor, nome, email_contato, status_aprovacao, taxa_plataforma_pct) VALUES (2, 'Moonlit Games', 'contato@moonlit.example.com', 'aprovado', 20);
INSERT INTO desenvolvedor (id_desenvolvedor, nome, email_contato, status_aprovacao, taxa_plataforma_pct) VALUES (3, 'Indie Sparks', 'contato@indiesparks.example.com', 'pendente', 30);

-- genero_tag
INSERT INTO genero_tag (id_genero_tag, nome, tipo) VALUES (1, 'Acao', 'genero');
INSERT INTO genero_tag (id_genero_tag, nome, tipo) VALUES (2, 'Aventura', 'genero');
INSERT INTO genero_tag (id_genero_tag, nome, tipo) VALUES (3, 'Estrategia', 'genero');
INSERT INTO genero_tag (id_genero_tag, nome, tipo) VALUES (4, 'Terror', 'genero');
INSERT INTO genero_tag (id_genero_tag, nome, tipo) VALUES (5, 'co-op', 'tag');
INSERT INTO genero_tag (id_genero_tag, nome, tipo) VALUES (6, 'pixel art', 'tag');
INSERT INTO genero_tag (id_genero_tag, nome, tipo) VALUES (7, 'roguelike', 'tag');

-- jogo
INSERT INTO jogo (id_jogo, id_desenvolvedor, titulo, descricao, preco_centavos, classificacao_indicativa, status_aprovacao, data_publicacao) VALUES (1, 1, 'Pixel Quest', 'Aventura em pixel art para jogar em dupla', 5990, 10, 'aprovado', '2026-03-10 10:00:00');
INSERT INTO jogo (id_jogo, id_desenvolvedor, titulo, descricao, preco_centavos, classificacao_indicativa, status_aprovacao, data_publicacao) VALUES (2, 1, 'Neon Drift', 'Corrida arcade futurista', 2990, 0, 'aprovado', '2026-05-02 10:00:00');
INSERT INTO jogo (id_jogo, id_desenvolvedor, titulo, descricao, preco_centavos, classificacao_indicativa, status_aprovacao, data_publicacao) VALUES (3, 2, 'Moonlit Tactics', 'Estrategia por turnos', 9990, 12, 'aprovado', '2026-06-20 10:00:00');
INSERT INTO jogo (id_jogo, id_desenvolvedor, titulo, descricao, preco_centavos, classificacao_indicativa, status_aprovacao, data_publicacao) VALUES (4, 2, 'Shadow Crypt', 'Terror e acao em masmorras', 14990, 18, 'aprovado', '2026-08-15 10:00:00');
INSERT INTO jogo (id_jogo, id_desenvolvedor, titulo, descricao, preco_centavos, classificacao_indicativa, status_aprovacao, data_publicacao) VALUES (5, 3, 'Spark Runner', 'Jogo gratuito aguardando aprovacao', 0, 0, 'pendente', NULL);

-- promocao
INSERT INTO promocao (id_promocao, nome, desconto_pct, data_inicio, data_fim) VALUES (1, 'Semana Indie', 30, '2026-10-01 00:00:00', '2026-10-31 23:59:59');
INSERT INTO promocao (id_promocao, nome, desconto_pct, data_inicio, data_fim) VALUES (2, 'Black Friday 2026', 50, '2026-11-20 00:00:00', '2026-11-30 23:59:59');

-- jogo_genero_tag
INSERT INTO jogo_genero_tag (id_jogo, id_genero_tag) VALUES (1, 2);
INSERT INTO jogo_genero_tag (id_jogo, id_genero_tag) VALUES (1, 6);
INSERT INTO jogo_genero_tag (id_jogo, id_genero_tag) VALUES (1, 5);
INSERT INTO jogo_genero_tag (id_jogo, id_genero_tag) VALUES (2, 1);
INSERT INTO jogo_genero_tag (id_jogo, id_genero_tag) VALUES (2, 6);
INSERT INTO jogo_genero_tag (id_jogo, id_genero_tag) VALUES (3, 3);
INSERT INTO jogo_genero_tag (id_jogo, id_genero_tag) VALUES (3, 5);
INSERT INTO jogo_genero_tag (id_jogo, id_genero_tag) VALUES (4, 4);
INSERT INTO jogo_genero_tag (id_jogo, id_genero_tag) VALUES (4, 1);
INSERT INTO jogo_genero_tag (id_jogo, id_genero_tag) VALUES (4, 7);
INSERT INTO jogo_genero_tag (id_jogo, id_genero_tag) VALUES (5, 2);
INSERT INTO jogo_genero_tag (id_jogo, id_genero_tag) VALUES (5, 6);

-- promocao_jogo
INSERT INTO promocao_jogo (id_promocao, id_jogo) VALUES (1, 1);
INSERT INTO promocao_jogo (id_promocao, id_jogo) VALUES (1, 2);
INSERT INTO promocao_jogo (id_promocao, id_jogo) VALUES (1, 3);
INSERT INTO promocao_jogo (id_promocao, id_jogo) VALUES (2, 1);
INSERT INTO promocao_jogo (id_promocao, id_jogo) VALUES (2, 3);
INSERT INTO promocao_jogo (id_promocao, id_jogo) VALUES (2, 4);

-- versao
INSERT INTO versao (id_versao, id_jogo, numero_versao, data_lancamento, notas) VALUES (1, 1, '1.0.0', '2026-03-10 10:00:00', 'Lancamento');
INSERT INTO versao (id_versao, id_jogo, numero_versao, data_lancamento, notas) VALUES (2, 1, '1.1.0', '2026-07-01 10:00:00', 'Novo modo cooperativo');
INSERT INTO versao (id_versao, id_jogo, numero_versao, data_lancamento, notas) VALUES (3, 3, '1.0.0', '2026-06-20 10:00:00', 'Lancamento');
INSERT INTO versao (id_versao, id_jogo, numero_versao, data_lancamento, notas) VALUES (4, 4, '1.0.0', '2026-08-15 10:00:00', 'Lancamento');
INSERT INTO versao (id_versao, id_jogo, numero_versao, data_lancamento, notas) VALUES (5, 4, '1.1.0', '2026-11-14 10:00:00', 'Correcoes e nova masmorra');
INSERT INTO versao (id_versao, id_jogo, numero_versao, data_lancamento, notas) VALUES (6, 2, '1.0.0', '2026-05-02 10:00:00', 'Lancamento');

-- dlc
INSERT INTO dlc (id_dlc, id_jogo_base, titulo, preco_centavos) VALUES (1, 1, 'Ice Caves', 1990);
INSERT INTO dlc (id_dlc, id_jogo_base, titulo, preco_centavos) VALUES (2, 3, 'Fronteira', 2990);
INSERT INTO dlc (id_dlc, id_jogo_base, titulo, preco_centavos) VALUES (3, 4, 'Catacumbas', 3990);

-- conquista
INSERT INTO conquista (id_conquista, id_jogo, nome, descricao) VALUES (1, 1, 'Primeiros passos', 'Termine a fase 1');
INSERT INTO conquista (id_conquista, id_jogo, nome, descricao) VALUES (2, 1, 'Mestre das cavernas', 'Explore todas as cavernas');
INSERT INTO conquista (id_conquista, id_jogo, nome, descricao) VALUES (3, 3, 'Estrategista', 'Vença 10 partidas');
INSERT INTO conquista (id_conquista, id_jogo, nome, descricao) VALUES (4, 4, 'Sobrevivente', 'Termine sem morrer');

-- compra
INSERT INTO compra (id_compra, id_usuario, data_compra, status, valor_total_centavos) VALUES (1, 1, '2026-10-05 10:00:00', 'pendente', 6286);
INSERT INTO compra (id_compra, id_usuario, data_compra, status, valor_total_centavos) VALUES (2, 2, '2026-10-12 14:20:00', 'pendente', 6993);
INSERT INTO compra (id_compra, id_usuario, data_compra, status, valor_total_centavos) VALUES (3, 3, '2026-10-20 19:05:00', 'pendente', 12980);
INSERT INTO compra (id_compra, id_usuario, data_compra, status, valor_total_centavos) VALUES (4, 3, '2026-11-02 21:40:00', 'pendente', 14990);
INSERT INTO compra (id_compra, id_usuario, data_compra, status, valor_total_centavos) VALUES (5, 2, '2026-11-05 16:00:00', 'pendente', 18980);
INSERT INTO compra (id_compra, id_usuario, data_compra, status, valor_total_centavos) VALUES (6, 1, '2026-11-08 11:30:00', 'pendente', 2990);
INSERT INTO compra (id_compra, id_usuario, data_compra, status, valor_total_centavos) VALUES (7, 5, '2026-11-10 09:15:00', 'pendente', 5990);
INSERT INTO compra (id_compra, id_usuario, data_compra, status, valor_total_centavos) VALUES (8, 2, '2026-11-12 22:00:00', 'pendente', 5990);

-- item_compra
INSERT INTO item_compra (id_item_compra, id_compra, id_jogo, id_dlc, id_promocao, preco_pago_centavos, repasse_desenvolvedor_centavos, status_dlc) VALUES (1, 1, 1, NULL, 1, 4193, 2935, NULL);
INSERT INTO item_compra (id_item_compra, id_compra, id_jogo, id_dlc, id_promocao, preco_pago_centavos, repasse_desenvolvedor_centavos, status_dlc) VALUES (2, 1, 2, NULL, 1, 2093, 1465, NULL);
INSERT INTO item_compra (id_item_compra, id_compra, id_jogo, id_dlc, id_promocao, preco_pago_centavos, repasse_desenvolvedor_centavos, status_dlc) VALUES (3, 2, 3, NULL, 1, 6993, 5594, NULL);
INSERT INTO item_compra (id_item_compra, id_compra, id_jogo, id_dlc, id_promocao, preco_pago_centavos, repasse_desenvolvedor_centavos, status_dlc) VALUES (4, 3, 3, NULL, NULL, 9990, 7992, NULL);
INSERT INTO item_compra (id_item_compra, id_compra, id_jogo, id_dlc, id_promocao, preco_pago_centavos, repasse_desenvolvedor_centavos, status_dlc) VALUES (5, 3, NULL, 2, NULL, 2990, 2392, 'ativada');
INSERT INTO item_compra (id_item_compra, id_compra, id_jogo, id_dlc, id_promocao, preco_pago_centavos, repasse_desenvolvedor_centavos, status_dlc) VALUES (6, 4, 4, NULL, NULL, 14990, 11992, NULL);
INSERT INTO item_compra (id_item_compra, id_compra, id_jogo, id_dlc, id_promocao, preco_pago_centavos, repasse_desenvolvedor_centavos, status_dlc) VALUES (7, 5, 4, NULL, NULL, 14990, 11992, NULL);
INSERT INTO item_compra (id_item_compra, id_compra, id_jogo, id_dlc, id_promocao, preco_pago_centavos, repasse_desenvolvedor_centavos, status_dlc) VALUES (8, 5, NULL, 3, NULL, 3990, 3192, 'ativada');
INSERT INTO item_compra (id_item_compra, id_compra, id_jogo, id_dlc, id_promocao, preco_pago_centavos, repasse_desenvolvedor_centavos, status_dlc) VALUES (9, 6, NULL, 2, NULL, 2990, 2392, 'guardada');
INSERT INTO item_compra (id_item_compra, id_compra, id_jogo, id_dlc, id_promocao, preco_pago_centavos, repasse_desenvolvedor_centavos, status_dlc) VALUES (10, 7, 1, NULL, NULL, 5990, 4193, NULL);
INSERT INTO item_compra (id_item_compra, id_compra, id_jogo, id_dlc, id_promocao, preco_pago_centavos, repasse_desenvolvedor_centavos, status_dlc) VALUES (11, 8, 1, NULL, NULL, 5990, 4193, NULL);

-- pagamento
INSERT INTO pagamento (id_pagamento, id_compra, operadora, metodo, valor_centavos, status, codigo_transacao, data_pagamento, data_confirmacao) VALUES (1, 1, 'PagSeguro', 'pix', 6286, 'confirmado', 'TX-00001', '2026-10-05 10:00:00', '2026-10-05 10:05:00');
INSERT INTO pagamento (id_pagamento, id_compra, operadora, metodo, valor_centavos, status, codigo_transacao, data_pagamento, data_confirmacao) VALUES (2, 2, 'PayPal', 'credito', 6993, 'confirmado', 'TX-00002', '2026-10-12 14:20:00', '2026-10-12 10:05:00');
INSERT INTO pagamento (id_pagamento, id_compra, operadora, metodo, valor_centavos, status, codigo_transacao, data_pagamento, data_confirmacao) VALUES (3, 3, 'Mercado Pago', 'pix', 12980, 'confirmado', 'TX-00003', '2026-10-20 19:05:00', '2026-10-20 10:05:00');
INSERT INTO pagamento (id_pagamento, id_compra, operadora, metodo, valor_centavos, status, codigo_transacao, data_pagamento, data_confirmacao) VALUES (4, 4, 'PagSeguro', 'debito', 14990, 'confirmado', 'TX-00004', '2026-11-02 21:40:00', '2026-11-02 10:05:00');
INSERT INTO pagamento (id_pagamento, id_compra, operadora, metodo, valor_centavos, status, codigo_transacao, data_pagamento, data_confirmacao) VALUES (5, 5, 'PayPal', 'credito', 18980, 'confirmado', 'TX-00005', '2026-11-05 16:00:00', '2026-11-05 10:05:00');
INSERT INTO pagamento (id_pagamento, id_compra, operadora, metodo, valor_centavos, status, codigo_transacao, data_pagamento, data_confirmacao) VALUES (6, 6, 'PagSeguro', 'pix', 2990, 'confirmado', 'TX-00006', '2026-11-08 11:30:00', '2026-11-08 10:05:00');
INSERT INTO pagamento (id_pagamento, id_compra, operadora, metodo, valor_centavos, status, codigo_transacao, data_pagamento, data_confirmacao) VALUES (7, 7, 'Mercado Pago', 'debito', 5990, 'confirmado', 'TX-00007', '2026-11-10 09:15:00', '2026-11-10 10:05:00');
INSERT INTO pagamento (id_pagamento, id_compra, operadora, metodo, valor_centavos, status, codigo_transacao, data_pagamento, data_confirmacao) VALUES (8, 8, 'PayPal', 'credito', 5990, 'pendente', 'TX-00008', '2026-11-12 22:00:00', NULL);

-- compras com pagamento confirmado passam a 'concluida' (R4)
UPDATE compra SET status = 'concluida' WHERE id_compra = 1;  -- dispara o trigger R4
UPDATE compra SET status = 'concluida' WHERE id_compra = 2;  -- dispara o trigger R4
UPDATE compra SET status = 'concluida' WHERE id_compra = 3;  -- dispara o trigger R4
UPDATE compra SET status = 'concluida' WHERE id_compra = 4;  -- dispara o trigger R4
UPDATE compra SET status = 'concluida' WHERE id_compra = 5;  -- dispara o trigger R4
UPDATE compra SET status = 'concluida' WHERE id_compra = 6;  -- dispara o trigger R4
UPDATE compra SET status = 'concluida' WHERE id_compra = 7;  -- dispara o trigger R4

-- biblioteca
INSERT INTO biblioteca (id_biblioteca, id_usuario, id_jogo, data_aquisicao, origem, minutos_jogados, finalizado) VALUES (1, 1, 1, '2026-10-05 10:10:00', 'compra', 300, 0);
INSERT INTO biblioteca (id_biblioteca, id_usuario, id_jogo, data_aquisicao, origem, minutos_jogados, finalizado) VALUES (2, 1, 2, '2026-10-05 10:10:00', 'compra', 90, 0);
INSERT INTO biblioteca (id_biblioteca, id_usuario, id_jogo, data_aquisicao, origem, minutos_jogados, finalizado) VALUES (3, 2, 3, '2026-10-12 14:30:00', 'compra', 1500, 0);
INSERT INTO biblioteca (id_biblioteca, id_usuario, id_jogo, data_aquisicao, origem, minutos_jogados, finalizado) VALUES (4, 3, 3, '2026-10-20 19:10:00', 'compra', 600, 0);
INSERT INTO biblioteca (id_biblioteca, id_usuario, id_jogo, data_aquisicao, origem, minutos_jogados, finalizado) VALUES (5, 3, 4, '2026-11-02 21:45:00', 'compra', 120, 1);
INSERT INTO biblioteca (id_biblioteca, id_usuario, id_jogo, data_aquisicao, origem, minutos_jogados, finalizado) VALUES (6, 2, 4, '2026-11-05 16:10:00', 'compra', 600, 0);
INSERT INTO biblioteca (id_biblioteca, id_usuario, id_jogo, data_aquisicao, origem, minutos_jogados, finalizado) VALUES (7, 5, 1, '2026-11-10 09:20:00', 'compra', 45, 0);
INSERT INTO biblioteca (id_biblioteca, id_usuario, id_jogo, data_aquisicao, origem, minutos_jogados, finalizado) VALUES (8, 4, 2, '2026-06-01 10:00:00', 'teste', 30, 0);

-- avaliacao
INSERT INTO avaliacao (id_avaliacao, id_usuario, id_jogo, recomenda, texto) VALUES (1, 1, 1, 1, 'Otimo para jogar em dupla');
INSERT INTO avaliacao (id_avaliacao, id_usuario, id_jogo, recomenda, texto) VALUES (2, 1, 2, 0, 'Curto demais');
INSERT INTO avaliacao (id_avaliacao, id_usuario, id_jogo, recomenda, texto) VALUES (3, 2, 3, 1, 'Estrategia profunda');
INSERT INTO avaliacao (id_avaliacao, id_usuario, id_jogo, recomenda, texto) VALUES (4, 3, 3, 1, 'Viciante');
INSERT INTO avaliacao (id_avaliacao, id_usuario, id_jogo, recomenda, texto) VALUES (5, 3, 4, 0, 'Muito dificil');
INSERT INTO avaliacao (id_avaliacao, id_usuario, id_jogo, recomenda, texto) VALUES (6, 2, 4, 1, 'Atmosfera incrivel');
INSERT INTO avaliacao (id_avaliacao, id_usuario, id_jogo, recomenda, texto) VALUES (7, 4, 2, 1, 'Testei e gostei');

-- conquista_usuario
INSERT INTO conquista_usuario (id_usuario, id_conquista, id_jogo) VALUES (1, 1, 1);
INSERT INTO conquista_usuario (id_usuario, id_conquista, id_jogo) VALUES (1, 2, 1);
INSERT INTO conquista_usuario (id_usuario, id_conquista, id_jogo) VALUES (5, 1, 1);
INSERT INTO conquista_usuario (id_usuario, id_conquista, id_jogo) VALUES (2, 3, 3);
INSERT INTO conquista_usuario (id_usuario, id_conquista, id_jogo) VALUES (3, 3, 3);
INSERT INTO conquista_usuario (id_usuario, id_conquista, id_jogo) VALUES (3, 4, 4);

-- amizade
INSERT INTO amizade (id_solicitante, id_destinatario, status) VALUES (1, 2, 'aceita');
INSERT INTO amizade (id_solicitante, id_destinatario, status) VALUES (2, 3, 'aceita');
INSERT INTO amizade (id_solicitante, id_destinatario, status) VALUES (1, 3, 'pendente');
INSERT INTO amizade (id_solicitante, id_destinatario, status) VALUES (5, 1, 'recusada');

-- notificacao
INSERT INTO notificacao (id_usuario, id_versao, lida) VALUES (2, 5, 0);
INSERT INTO notificacao (id_usuario, id_versao, lida) VALUES (3, 5, 1);

-- reembolso
INSERT INTO reembolso (id_item_compra, data_pedido, motivo, status) VALUES (10, '2026-11-12 10:00:00', 'Nao gostei do jogo', 'aprovado');
INSERT INTO reembolso (id_item_compra, data_pedido, motivo, status) VALUES (2, '2026-10-10 12:00:00', 'Esperava um jogo mais longo', 'pendente');
