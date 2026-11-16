-- script_ddl.sql  Plataforma de jogos online
-- Bancos de Dados e Aplicacoes (UFSC)  
-- Convencoes: dinheiro em centavos (INTEGER), datas em TEXT ISO 8601 (AAAA-MM-DD HH:MM:SS)
-- Booleanos como INTEGER 0/1.

PRAGMA foreign_keys = ON;


-- tabelas-raiz 

CREATE TABLE usuario (
    id_usuario      INTEGER PRIMARY KEY,
    nome_usuario    TEXT    NOT NULL UNIQUE,                 -- VARCHAR(40)
    email           TEXT    NOT NULL UNIQUE,                 -- VARCHAR(120)
    data_nascimento TEXT    NOT NULL,                        -- AAAA-MM-DD (R19)
    data_cadastro   TEXT    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status_conta    TEXT    NOT NULL DEFAULT 'ativa'
                    CHECK (status_conta IN ('ativa','inativa'))
);

CREATE TABLE desenvolvedor (
    id_desenvolvedor    INTEGER PRIMARY KEY,
    nome                TEXT    NOT NULL UNIQUE,             -- VARCHAR(80)
    email_contato       TEXT    NOT NULL UNIQUE,
    status_aprovacao    TEXT    NOT NULL DEFAULT 'pendente'
                        CHECK (status_aprovacao IN ('pendente','aprovado','rejeitado')),
    taxa_plataforma_pct INTEGER NOT NULL DEFAULT 30          -- R18
                        CHECK (taxa_plataforma_pct BETWEEN 0 AND 100)
);

CREATE TABLE genero_tag (
    id_genero_tag INTEGER PRIMARY KEY,
    nome          TEXT NOT NULL UNIQUE,
    tipo          TEXT NOT NULL CHECK (tipo IN ('genero','tag'))   -- R2
);


-- jogo e promocao

CREATE TABLE jogo (
    id_jogo                 INTEGER PRIMARY KEY,
    id_desenvolvedor        INTEGER NOT NULL
                            REFERENCES desenvolvedor(id_desenvolvedor)
                            ON DELETE RESTRICT ON UPDATE CASCADE,         -- R1
    titulo                  TEXT    NOT NULL,                             -- VARCHAR(120)
    descricao               TEXT,
    preco_centavos          INTEGER NOT NULL DEFAULT 0
                            CHECK (preco_centavos >= 0),                  -- R10 (gratis = 0)
    classificacao_indicativa INTEGER NOT NULL DEFAULT 0
                            CHECK (classificacao_indicativa IN (0,10,12,14,16,18)),  -- R19
    status_aprovacao        TEXT    NOT NULL DEFAULT 'pendente'
                            CHECK (status_aprovacao IN ('pendente','aprovado','rejeitado')),  -- R1
    data_publicacao         TEXT,
    UNIQUE (id_desenvolvedor, titulo)
);

CREATE TABLE promocao (
    id_promocao  INTEGER PRIMARY KEY,
    nome         TEXT    NOT NULL,
    desconto_pct INTEGER NOT NULL CHECK (desconto_pct BETWEEN 1 AND 100),  -- R9 (ate 100% de desconto)
    data_inicio  TEXT    NOT NULL,
    data_fim     TEXT    NOT NULL,
    CHECK (data_fim > data_inicio)                                         -- R9
);


--dependentes de jogo

CREATE TABLE jogo_genero_tag (                                -- N:N jogo x genero/tag
    id_jogo       INTEGER NOT NULL REFERENCES jogo(id_jogo)
                  ON DELETE CASCADE ON UPDATE CASCADE,
    id_genero_tag INTEGER NOT NULL REFERENCES genero_tag(id_genero_tag)
                  ON DELETE RESTRICT ON UPDATE CASCADE,
    PRIMARY KEY (id_jogo, id_genero_tag)
);

CREATE TABLE promocao_jogo (                                  -- N:N promocao x jogo
    id_promocao INTEGER NOT NULL REFERENCES promocao(id_promocao)
                ON DELETE CASCADE ON UPDATE CASCADE,
    id_jogo     INTEGER NOT NULL REFERENCES jogo(id_jogo)
                ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (id_promocao, id_jogo)
);

CREATE TABLE versao (
    id_versao       INTEGER PRIMARY KEY,
    id_jogo         INTEGER NOT NULL REFERENCES jogo(id_jogo)
                    ON DELETE CASCADE ON UPDATE CASCADE,
    numero_versao   TEXT    NOT NULL,                         -- ex.: 1.1.0
    data_lancamento TEXT    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    notas           TEXT,
    UNIQUE (id_jogo, numero_versao)
);

CREATE TABLE dlc (
    id_dlc         INTEGER PRIMARY KEY,
    id_jogo_base   INTEGER NOT NULL REFERENCES jogo(id_jogo)
                   ON DELETE CASCADE ON UPDATE CASCADE,       -- R5
    titulo         TEXT    NOT NULL,
    preco_centavos INTEGER NOT NULL CHECK (preco_centavos >= 0),
    UNIQUE (id_jogo_base, titulo)
);

CREATE TABLE conquista (
    id_conquista INTEGER PRIMARY KEY,
    id_jogo      INTEGER NOT NULL REFERENCES jogo(id_jogo)
                 ON DELETE CASCADE ON UPDATE CASCADE,
    nome         TEXT    NOT NULL,
    descricao    TEXT,
    UNIQUE (id_jogo, nome),
    UNIQUE (id_conquista, id_jogo)        -- necessario para a FK composta de conquista_usuario
);

 --biblioteca e comunidade

CREATE TABLE biblioteca (
    id_biblioteca   INTEGER PRIMARY KEY,
    id_usuario      INTEGER NOT NULL REFERENCES usuario(id_usuario)
                    ON DELETE CASCADE ON UPDATE CASCADE,
    id_jogo         INTEGER NOT NULL REFERENCES jogo(id_jogo)
                    ON DELETE RESTRICT ON UPDATE CASCADE,
    data_aquisicao  TEXT    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    origem          TEXT    NOT NULL DEFAULT 'compra'
                    CHECK (origem IN ('compra','teste')),     -- R6 (tester)
    minutos_jogados INTEGER NOT NULL DEFAULT 0 CHECK (minutos_jogados >= 0),
    finalizado      INTEGER NOT NULL DEFAULT 0 CHECK (finalizado IN (0,1)),
    UNIQUE (id_usuario, id_jogo)          -- R3: o mesmo jogo uma unica vez (e alvo das FKs compostas)
);

CREATE TABLE avaliacao (
    id_avaliacao  INTEGER PRIMARY KEY,
    id_usuario    INTEGER NOT NULL,
    id_jogo       INTEGER NOT NULL,
    recomenda     INTEGER NOT NULL CHECK (recomenda IN (0,1)),
    texto         TEXT,
    data_criacao  TEXT    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_edicao   TEXT,                                       -- R7: pode editar
    UNIQUE (id_usuario, id_jogo),                             -- R7: no maximo uma por jogo
    FOREIGN KEY (id_usuario, id_jogo)                         -- R6: so quem tem o jogo
        REFERENCES biblioteca(id_usuario, id_jogo)
        ON DELETE RESTRICT ON UPDATE CASCADE      -- decisao 12: avaliacao nao some ao sair da biblioteca
);

CREATE TABLE conquista_usuario (
    id_usuario       INTEGER NOT NULL,
    id_conquista     INTEGER NOT NULL,
    id_jogo          INTEGER NOT NULL,
    data_desbloqueio TEXT    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_usuario, id_conquista),
    FOREIGN KEY (id_conquista, id_jogo)                       -- a conquista pertence a esse jogo
        REFERENCES conquista(id_conquista, id_jogo)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_usuario, id_jogo)                         -- R11: so quem possui o jogo
        REFERENCES biblioteca(id_usuario, id_jogo)
        ON DELETE RESTRICT ON UPDATE CASCADE      -- decisao 12: conquistas nao se perdem
);

CREATE TABLE amizade (
    id_solicitante   INTEGER NOT NULL REFERENCES usuario(id_usuario)
                     ON DELETE CASCADE ON UPDATE CASCADE,
    id_destinatario  INTEGER NOT NULL REFERENCES usuario(id_usuario)
                     ON DELETE CASCADE ON UPDATE CASCADE,
    status           TEXT    NOT NULL DEFAULT 'pendente'
                     CHECK (status IN ('pendente','aceita','recusada')),   -- R12: aceite
    data_solicitacao TEXT    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_solicitante, id_destinatario),
    CHECK (id_solicitante <> id_destinatario)                 -- R12: nao pode ser amigo de si mesmo
);
-- impede o par repetido em sentido inverso (1->2 e 2->1)
CREATE UNIQUE INDEX ux_amizade_par
    ON amizade (MIN(id_solicitante, id_destinatario), MAX(id_solicitante, id_destinatario));

CREATE TABLE notificacao (                                    -- R17
    id_notificacao INTEGER PRIMARY KEY,
    id_usuario     INTEGER NOT NULL REFERENCES usuario(id_usuario)
                   ON DELETE CASCADE ON UPDATE CASCADE,
    id_versao      INTEGER NOT NULL REFERENCES versao(id_versao)
                   ON DELETE CASCADE ON UPDATE CASCADE,
    data_envio     TEXT    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    lida           INTEGER NOT NULL DEFAULT 0 CHECK (lida IN (0,1)),
    UNIQUE (id_usuario, id_versao)
);


--compras (historico financeiro: RESTRICT)

CREATE TABLE compra (
    id_compra            INTEGER PRIMARY KEY,
    id_usuario           INTEGER NOT NULL REFERENCES usuario(id_usuario)
                         ON DELETE RESTRICT ON UPDATE CASCADE,
    data_compra          TEXT    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status               TEXT    NOT NULL DEFAULT 'pendente'
                         CHECK (status IN ('pendente','concluida','cancelada')),   -- R4
    valor_total_centavos INTEGER NOT NULL DEFAULT 0 CHECK (valor_total_centavos >= 0)
);

CREATE TABLE item_compra (
    id_item_compra INTEGER PRIMARY KEY,
    id_compra      INTEGER NOT NULL REFERENCES compra(id_compra)
                   ON DELETE CASCADE ON UPDATE CASCADE,
    id_jogo        INTEGER REFERENCES jogo(id_jogo)
                   ON DELETE RESTRICT ON UPDATE CASCADE,
    id_dlc         INTEGER REFERENCES dlc(id_dlc)
                   ON DELETE RESTRICT ON UPDATE CASCADE,
    id_promocao    INTEGER REFERENCES promocao(id_promocao)
                   ON DELETE SET NULL ON UPDATE CASCADE,
    preco_pago_centavos INTEGER NOT NULL CHECK (preco_pago_centavos >= 0),   -- preco congelado
    repasse_desenvolvedor_centavos INTEGER NOT NULL
                   CHECK (repasse_desenvolvedor_centavos >= 0),              -- R18
    status_dlc     TEXT CHECK (status_dlc IN ('guardada','ativada')),        -- R5
    CHECK ((id_jogo IS NOT NULL) + (id_dlc IS NOT NULL) = 1),     -- item e jogo OU dlc
    CHECK (status_dlc IS NULL OR id_dlc IS NOT NULL)              -- status so existe para DLC
);

CREATE TABLE pagamento (
    id_pagamento      INTEGER PRIMARY KEY,
    id_compra         INTEGER NOT NULL REFERENCES compra(id_compra)
                      ON DELETE RESTRICT ON UPDATE CASCADE,
    operadora         TEXT    NOT NULL
                      CHECK (operadora IN ('PagSeguro','PayPal','Mercado Pago')),  -- decisao 7
    metodo            TEXT    NOT NULL CHECK (metodo IN ('pix','credito','debito','boleto')),
    valor_centavos    INTEGER NOT NULL CHECK (valor_centavos > 0),
    status            TEXT    NOT NULL DEFAULT 'pendente'
                      CHECK (status IN ('pendente','confirmado','recusado')),
    codigo_transacao  TEXT    NOT NULL UNIQUE,
    data_pagamento    TEXT    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_confirmacao  TEXT
);

CREATE TABLE reembolso (
    id_reembolso   INTEGER PRIMARY KEY,
    id_item_compra INTEGER NOT NULL REFERENCES item_compra(id_item_compra)
                   ON DELETE RESTRICT ON UPDATE CASCADE,
    data_pedido    TEXT    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    motivo         TEXT,
    status         TEXT    NOT NULL DEFAULT 'pendente'
                   CHECK (status IN ('pendente','aprovado','negado'))
);

-- INDICES nas FKs mais consultadas

CREATE INDEX ix_jogo_dev       ON jogo(id_desenvolvedor);
CREATE INDEX ix_item_compra    ON item_compra(id_compra);
CREATE INDEX ix_item_jogo      ON item_compra(id_jogo);
CREATE INDEX ix_compra_usuario ON compra(id_usuario);
CREATE INDEX ix_pagamento_comp ON pagamento(id_compra);


-- TRIGGERS (apenas 2: regras que CHECK/FK nao alcancam, por causa do mesmo problema de envolver 2 tabelas)

-- R4: a compra so e concluida apos a confirmacao do pagamento
CREATE TRIGGER trg_r4_compra_so_com_pagamento
BEFORE UPDATE OF status ON compra
WHEN NEW.status = 'concluida' AND OLD.status <> 'concluida'
BEGIN
    SELECT RAISE(ABORT, 'R4: compra so pode ser concluida com pagamento confirmado')
    WHERE NOT EXISTS (SELECT 1 FROM pagamento
                      WHERE id_compra = NEW.id_compra AND status = 'confirmado');
END;

-- R8: reembolso ate 14 dias da compra, com menos de 2 h de jogo e jogo nao finalizado
CREATE TRIGGER trg_r8_reembolso_regras
BEFORE INSERT ON reembolso
BEGIN
    SELECT RAISE(ABORT, 'R8: prazo de 14 dias excedido')
    WHERE (SELECT julianday(NEW.data_pedido) - julianday(c.data_compra)
             FROM item_compra i JOIN compra c ON c.id_compra = i.id_compra
            WHERE i.id_item_compra = NEW.id_item_compra) > 14;

    SELECT RAISE(ABORT, 'R8: jogo com 2 horas ou mais de jogo, ou ja finalizado')
    WHERE EXISTS (SELECT 1
                    FROM item_compra i
                    JOIN compra c     ON c.id_compra = i.id_compra
                    JOIN biblioteca b ON b.id_usuario = c.id_usuario AND b.id_jogo = i.id_jogo
                   WHERE i.id_item_compra = NEW.id_item_compra
                     AND (b.minutos_jogados >= 120 OR b.finalizado = 1));
END;
