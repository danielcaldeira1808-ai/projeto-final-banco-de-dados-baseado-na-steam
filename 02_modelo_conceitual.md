# 2. Modelo Conceitual (MER, notação de Chen) — guia para desenhar no Visual Paradigm

Desenhe: **retângulo = entidade**, **elipse = atributo** (identificador sublinhado), **losango = relacionamento**, com cardinalidade (mín,máx) em cada lado.

## 2.1 Entidades, atributos e identificadores (13)
| Entidade | Atributos (identificador em **negrito**) |
|---|---|
| USUARIO | **id_usuario**, nome_usuario, email, data_nascimento, data_cadastro, status_conta |
| DESENVOLVEDOR | **id_desenvolvedor**, nome, email_contato, status_aprovacao, taxa_plataforma_pct |
| JOGO | **id_jogo**, titulo, descricao, preco_centavos, classificacao_indicativa, status_aprovacao, data_publicacao |
| GENERO_TAG | **id_genero_tag**, nome, tipo (genero/tag) |
| VERSAO | **id_versao**, numero_versao, data_lancamento, notas |
| DLC | **id_dlc**, titulo, preco_centavos |
| CONQUISTA | **id_conquista**, nome, descricao |
| PROMOCAO | **id_promocao**, nome, desconto_pct, data_inicio, data_fim |
| COMPRA | **id_compra**, data_compra, status, valor_total_centavos |
| ITEM_COMPRA | **id_item_compra**, preco_pago_centavos, repasse_desenvolvedor_centavos, status_dlc |
| PAGAMENTO | **id_pagamento**, operadora, metodo, valor_centavos, status, codigo_transacao, data_pagamento, data_confirmacao |
| REEMBOLSO | **id_reembolso**, data_pedido, motivo, status |
| NOTIFICACAO | **id_notificacao**, data_envio, lida |

## 2.2 Relacionamentos e cardinalidades
| Relacionamento | Entidades (mín,máx) | Atributos do relacionamento | Justificativa |
|---|---|---|---|
| **publica** | DESENVOLVEDOR (0,N) — JOGO (1,1) | — | R1: todo jogo tem um desenvolvedor |
| **classifica** | JOGO (1,N) — GENERO_TAG (0,N) | — | R2: ao menos um gênero/tag; N:N |
| **possui** (biblioteca) | USUARIO (0,N) — JOGO (0,N) | data_aquisicao, origem (compra/teste), minutos_jogados, finalizado | R3: N:N, cada par uma vez |
| **avalia** | USUARIO (0,N) — JOGO (0,N) | recomenda, texto, data_criacao, data_edicao | R6 e R7: só quem possui; uma por jogo |
| **desbloqueia** | USUARIO (0,N) — CONQUISTA (0,N) | data_desbloqueio | R11 |
| **é amigo de** (autorrelacionamento) | USUARIO (0,N) — USUARIO (0,N) | status (pendente/aceita/recusada), data_solicitacao | R12: papéis solicitante e destinatário |
| **tem versão** | JOGO (0,N) — VERSAO (1,1) | — | R17 |
| **tem DLC** | JOGO (0,N) — DLC (1,1) | — | R5: DLC depende do jogo base |
| **tem conquista** | JOGO (0,N) — CONQUISTA (1,1) | — | conquista pertence a um jogo |
| **aplica-se a** | PROMOCAO (1,N) — JOGO (0,N) | — | R9; N:N |
| **realiza** | USUARIO (0,N) — COMPRA (1,1) | — | |
| **contém** | COMPRA (1,N) — ITEM_COMPRA (1,1) | — | |
| **refere-se a (jogo)** | ITEM_COMPRA (0,1) — JOGO (0,N) | — | o item é um jogo **ou** uma DLC |
| **refere-se a (dlc)** | ITEM_COMPRA (0,1) — DLC (0,N) | — | exclusivo com o anterior |
| **com promoção** | ITEM_COMPRA (0,1) — PROMOCAO (0,N) | — | R9 |
| **é paga por** | COMPRA (0,N) — PAGAMENTO (1,1) | — | R4 |
| **gera** | ITEM_COMPRA (0,N) — REEMBOLSO (1,1) | — | R8 |
| **recebe** | USUARIO (0,N) — NOTIFICACAO (1,1) | — | R17 |
| **gera aviso** | VERSAO (0,N) — NOTIFICACAO (1,1) | — | R17 |


