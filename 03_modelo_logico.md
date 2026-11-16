# 3. Modelo Lógico — Esquema Relacional (Atividade 03)
PK sublinhada em **negrito**; FK com `→`. Cada FK tem a ação referencial do script DDL (as FKs compostas para BIBLIOTECA usam RESTRICT).

USUARIO (**id_usuario**, nome_usuario, email, data_nascimento, data_cadastro, status_conta)

DESENVOLVEDOR (**id_desenvolvedor**, nome, email_contato, status_aprovacao, taxa_plataforma_pct)

GENERO_TAG (**id_genero_tag**, nome, tipo)

JOGO (**id_jogo**, id_desenvolvedor→DESENVOLVEDOR, titulo, descricao, preco_centavos, classificacao_indicativa, status_aprovacao, data_publicacao)

PROMOCAO (**id_promocao**, nome, desconto_pct, data_inicio, data_fim)

JOGO_GENERO_TAG (**id_jogo→JOGO, id_genero_tag→GENERO_TAG**)

PROMOCAO_JOGO (**id_promocao→PROMOCAO, id_jogo→JOGO**)

VERSAO (**id_versao**, id_jogo→JOGO, numero_versao, data_lancamento, notas)

DLC (**id_dlc**, id_jogo_base→JOGO, titulo, preco_centavos)

CONQUISTA (**id_conquista**, id_jogo→JOGO, nome, descricao)

BIBLIOTECA (**id_biblioteca**, id_usuario→USUARIO, id_jogo→JOGO, data_aquisicao, origem, minutos_jogados, finalizado) — chave alternativa UNIQUE(id_usuario, id_jogo)

AVALIACAO (**id_avaliacao**, (id_usuario, id_jogo)→BIBLIOTECA, recomenda, texto, data_criacao, data_edicao) — UNIQUE(id_usuario, id_jogo)

CONQUISTA_USUARIO (**id_usuario, id_conquista**, id_jogo, data_desbloqueio) — FK (id_usuario, id_jogo)→BIBLIOTECA e FK (id_conquista, id_jogo)→CONQUISTA

AMIZADE (**id_solicitante→USUARIO, id_destinatario→USUARIO**, status, data_solicitacao)

NOTIFICACAO (**id_notificacao**, id_usuario→USUARIO, id_versao→VERSAO, data_envio, lida)

COMPRA (**id_compra**, id_usuario→USUARIO, data_compra, status, valor_total_centavos)

ITEM_COMPRA (**id_item_compra**, id_compra→COMPRA, id_jogo→JOGO (nulo), id_dlc→DLC (nulo), id_promocao→PROMOCAO (nulo), preco_pago_centavos, repasse_desenvolvedor_centavos, status_dlc)

PAGAMENTO (**id_pagamento**, id_compra→COMPRA, operadora, metodo, valor_centavos, status, codigo_transacao, data_pagamento, data_confirmacao)

REEMBOLSO (**id_reembolso**, id_item_compra→ITEM_COMPRA, data_pedido, motivo, status)

## Transformações usadas
- **N:N viram tabela associativa:** classifica → JOGO_GENERO_TAG; aplica-se a → PROMOCAO_JOGO; possui → BIBLIOTECA; avalia → AVALIACAO; desbloqueia → CONQUISTA_USUARIO; é amigo de → AMIZADE (**autorrelacionamento**: duas FKs para USUARIO).
- **1:N:** a PK do lado 1 vira FK no lado N (JOGO→VERSAO, COMPRA→ITEM_COMPRA, etc.).
- **Atributos do relacionamento** ficaram na tabela associativa (ex.: minutos_jogados em BIBLIOTECA).
- Sem atributos multivalorados nem entidades fracas.

## Formas normais
- **1FN:** todos os atributos são atômicos; gêneros/tags (multivalorados) estão em tabela própria.
- **2FN:** nas tabelas de PK composta (JOGO_GENERO_TAG, PROMOCAO_JOGO, CONQUISTA_USUARIO, AMIZADE) os atributos dependem da chave inteira.
- **3FN:** não há dependência entre atributos não-chave. Exceção consciente: `id_jogo` em CONQUISTA_USUARIO é redundante com CONQUISTA, mantido para formar a FK composta que garante R11.
