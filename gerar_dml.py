"""Gera script_dml.sql e meu_cenario.db a partir do script_ddl.sql.
Os valores de preco pago, repasse e total da compra sao CALCULADOS aqui,
para o DML ficar coerente com as regras R9 (desconto) e R18 (repasse).
"""
import os
import sqlite3

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def q(v):
    """Formata um valor como literal SQL."""
    if v is None:
        return "NULL"
    if isinstance(v, int):
        return str(v)
    return "'" + str(v).replace("'", "''") + "'"


def inserts(tabela, colunas, linhas):
    cols = ", ".join(colunas)
    out = [f"-- {tabela}"]
    for l in linhas:
        out.append(f"INSERT INTO {tabela} ({cols}) VALUES ({', '.join(q(x) for x in l)});")
    return out


sql = ["-- script_dml.sql | dados de teste coerentes para todas as tabelas",
       "-- Gerado por tools/gerar_dml.py (valores calculados: desconto e repasse).",
       "PRAGMA foreign_keys = ON;", ""]

usuarios = [
    (1, "ana_silva", "ana@example.com", "1998-04-12", "2026-01-10 09:00:00"),
    (2, "bruno_costa", "bruno@example.com", "2001-09-30", "2026-02-14 18:30:00"),
    (3, "marina_lopes", "marina@example.com", "1995-01-20", "2026-03-03 12:00:00"),
    (4, "carlos_teen", "carlos@example.com", "2010-06-15", "2026-05-21 15:45:00"),
    (5, "diego_souza", "diego@example.com", "2003-11-03", "2026-09-30 20:10:00"),
]
sql += inserts("usuario", ["id_usuario", "nome_usuario", "email", "data_nascimento", "data_cadastro"], usuarios)

devs = [
    (1, "Pixel Forge", "contato@pixelforge.example.com", "aprovado", 30),
    (2, "Moonlit Games", "contato@moonlit.example.com", "aprovado", 20),
    (3, "Indie Sparks", "contato@indiesparks.example.com", "pendente", 30),
]
sql += [""] + inserts("desenvolvedor", ["id_desenvolvedor", "nome", "email_contato", "status_aprovacao", "taxa_plataforma_pct"], devs)
taxa = {d[0]: d[4] for d in devs}

generos = [(1, "Acao", "genero"), (2, "Aventura", "genero"), (3, "Estrategia", "genero"),
           (4, "Terror", "genero"), (5, "co-op", "tag"), (6, "pixel art", "tag"), (7, "roguelike", "tag")]
sql += [""] + inserts("genero_tag", ["id_genero_tag", "nome", "tipo"], generos)

jogos = [  # id, dev, titulo, descricao, preco, classif, status, data_pub
    (1, 1, "Pixel Quest", "Aventura em pixel art para jogar em dupla", 5990, 10, "aprovado", "2026-03-10 10:00:00"),
    (2, 1, "Neon Drift", "Corrida arcade futurista", 2990, 0, "aprovado", "2026-05-02 10:00:00"),
    (3, 2, "Moonlit Tactics", "Estrategia por turnos", 9990, 12, "aprovado", "2026-06-20 10:00:00"),
    (4, 2, "Shadow Crypt", "Terror e acao em masmorras", 14990, 18, "aprovado", "2026-08-15 10:00:00"),
    (5, 3, "Spark Runner", "Jogo gratuito aguardando aprovacao", 0, 0, "pendente", None),
]
sql += [""] + inserts("jogo", ["id_jogo", "id_desenvolvedor", "titulo", "descricao", "preco_centavos",
                               "classificacao_indicativa", "status_aprovacao", "data_publicacao"], jogos)
preco_jogo = {j[0]: j[4] for j in jogos}
dev_jogo = {j[0]: j[1] for j in jogos}

promos = [(1, "Semana Indie", 30, "2026-10-01 00:00:00", "2026-10-31 23:59:59"),
          (2, "Black Friday 2026", 50, "2026-11-20 00:00:00", "2026-11-30 23:59:59")]
sql += [""] + inserts("promocao", ["id_promocao", "nome", "desconto_pct", "data_inicio", "data_fim"], promos)
desc = {p[0]: p[2] for p in promos}

sql += [""] + inserts("jogo_genero_tag", ["id_jogo", "id_genero_tag"],
                      [(1, 2), (1, 6), (1, 5), (2, 1), (2, 6), (3, 3), (3, 5), (4, 4), (4, 1), (4, 7), (5, 2), (5, 6)])
sql += [""] + inserts("promocao_jogo", ["id_promocao", "id_jogo"],
                      [(1, 1), (1, 2), (1, 3), (2, 1), (2, 3), (2, 4)])

versoes = [
    (1, 1, "1.0.0", "2026-03-10 10:00:00", "Lancamento"),
    (2, 1, "1.1.0", "2026-07-01 10:00:00", "Novo modo cooperativo"),
    (3, 3, "1.0.0", "2026-06-20 10:00:00", "Lancamento"),
    (4, 4, "1.0.0", "2026-08-15 10:00:00", "Lancamento"),
    (5, 4, "1.1.0", "2026-11-14 10:00:00", "Correcoes e nova masmorra"),
    (6, 2, "1.0.0", "2026-05-02 10:00:00", "Lancamento"),
]
sql += [""] + inserts("versao", ["id_versao", "id_jogo", "numero_versao", "data_lancamento", "notas"], versoes)

dlcs = [(1, 1, "Ice Caves", 1990), (2, 3, "Fronteira", 2990), (3, 4, "Catacumbas", 3990)]
sql += [""] + inserts("dlc", ["id_dlc", "id_jogo_base", "titulo", "preco_centavos"], dlcs)
preco_dlc = {d[0]: d[3] for d in dlcs}
base_dlc = {d[0]: d[1] for d in dlcs}

conquistas = [(1, 1, "Primeiros passos", "Termine a fase 1"), (2, 1, "Mestre das cavernas", "Explore todas as cavernas"),
              (3, 3, "Estrategista", "Vença 10 partidas"), (4, 4, "Sobrevivente", "Termine sem morrer")]
sql += [""] + inserts("conquista", ["id_conquista", "id_jogo", "nome", "descricao"], conquistas)

# ---- compras: (id, usuario, data, [(tipo, id, promo)], operadora, metodo, status_pag)
compras = [
    (1, 1, "2026-10-05 10:00:00", [("j", 1, 1), ("j", 2, 1)], "PagSeguro", "pix", "confirmado"),
    (2, 2, "2026-10-12 14:20:00", [("j", 3, 1)], "PayPal", "credito", "confirmado"),
    (3, 3, "2026-10-20 19:05:00", [("j", 3, None), ("d", 2, None)], "Mercado Pago", "pix", "confirmado"),
    (4, 3, "2026-11-02 21:40:00", [("j", 4, None)], "PagSeguro", "debito", "confirmado"),
    (5, 2, "2026-11-05 16:00:00", [("j", 4, None), ("d", 3, None)], "PayPal", "credito", "confirmado"),
    (6, 1, "2026-11-08 11:30:00", [("d", 2, None)], "PagSeguro", "pix", "confirmado"),
    (7, 5, "2026-11-10 09:15:00", [("j", 1, None)], "Mercado Pago", "debito", "confirmado"),
    (8, 2, "2026-11-12 22:00:00", [("j", 1, None)], "PayPal", "credito", "pendente"),
]
donos = {(1, 1), (1, 2), (2, 3), (3, 3), (3, 4), (2, 4), (5, 1)}  # (usuario, jogo) das compras concluidas
sql_c, sql_i, sql_p, sql_u = [], [], [], []
item_id = 0
for cid, uid, data, itens, oper, metodo, stp in compras:
    total = 0
    linhas = []
    for tipo, ident, promo in itens:
        item_id += 1
        base = preco_jogo[ident] if tipo == "j" else preco_dlc[ident]
        pago = round(base * (100 - desc[promo]) / 100) if promo else base
        dev = dev_jogo[ident] if tipo == "j" else dev_jogo[base_dlc[ident]]
        repasse = round(pago * (100 - taxa[dev]) / 100)
        total += pago
        if tipo == "d":
            tem_base = (uid, base_dlc[ident]) in donos
            st = "ativada" if tem_base else "guardada"
        else:
            st = None
        linhas.append((item_id, cid, ident if tipo == "j" else None, ident if tipo == "d" else None,
                       promo, pago, repasse, st))
    sql_c.append((cid, uid, data, "pendente", total))
    sql_i += linhas
    conf = None if stp == "pendente" else data[:10] + " 10:05:00"
    sql_p.append((cid, cid, oper, metodo, total, stp, f"TX-{cid:05d}", data, conf))
    if stp == "confirmado":
        sql_u.append(f"UPDATE compra SET status = 'concluida' WHERE id_compra = {cid};  -- dispara o trigger R4")

sql += [""] + inserts("compra", ["id_compra", "id_usuario", "data_compra", "status", "valor_total_centavos"], sql_c)
sql += [""] + inserts("item_compra", ["id_item_compra", "id_compra", "id_jogo", "id_dlc", "id_promocao",
                                      "preco_pago_centavos", "repasse_desenvolvedor_centavos", "status_dlc"], sql_i)
sql += [""] + inserts("pagamento", ["id_pagamento", "id_compra", "operadora", "metodo", "valor_centavos", "status",
                                    "codigo_transacao", "data_pagamento", "data_confirmacao"], sql_p)
sql += ["", "-- compras com pagamento confirmado passam a 'concluida' (R4)"] + sql_u

biblioteca = [  # id, usuario, jogo, data, origem, minutos, finalizado
    (1, 1, 1, "2026-10-05 10:10:00", "compra", 300, 0),
    (2, 1, 2, "2026-10-05 10:10:00", "compra", 90, 0),
    (3, 2, 3, "2026-10-12 14:30:00", "compra", 1500, 0),
    (4, 3, 3, "2026-10-20 19:10:00", "compra", 600, 0),
    (5, 3, 4, "2026-11-02 21:45:00", "compra", 120, 1),
    (6, 2, 4, "2026-11-05 16:10:00", "compra", 600, 0),
    (7, 5, 1, "2026-11-10 09:20:00", "compra", 45, 0),
    (8, 4, 2, "2026-06-01 10:00:00", "teste", 30, 0),
]
sql += [""] + inserts("biblioteca", ["id_biblioteca", "id_usuario", "id_jogo", "data_aquisicao", "origem",
                                     "minutos_jogados", "finalizado"], biblioteca)

aval = [(1, 1, 1, 1, "Otimo para jogar em dupla"), (2, 1, 2, 0, "Curto demais"), (3, 2, 3, 1, "Estrategia profunda"),
        (4, 3, 3, 1, "Viciante"), (5, 3, 4, 0, "Muito dificil"), (6, 2, 4, 1, "Atmosfera incrivel"),
        (7, 4, 2, 1, "Testei e gostei")]
sql += [""] + inserts("avaliacao", ["id_avaliacao", "id_usuario", "id_jogo", "recomenda", "texto"], aval)

sql += [""] + inserts("conquista_usuario", ["id_usuario", "id_conquista", "id_jogo"],
                      [(1, 1, 1), (1, 2, 1), (5, 1, 1), (2, 3, 3), (3, 3, 3), (3, 4, 4)])
sql += [""] + inserts("amizade", ["id_solicitante", "id_destinatario", "status"],
                      [(1, 2, "aceita"), (2, 3, "aceita"), (1, 3, "pendente"), (5, 1, "recusada")])
sql += [""] + inserts("notificacao", ["id_usuario", "id_versao", "lida"], [(2, 5, 0), (3, 5, 1)])

# reembolsos validos pela R8 (as violacoes ficam em testes_violacao.sql)
sql += [""] + inserts("reembolso", ["id_item_compra", "data_pedido", "motivo", "status"], [
    (10, "2026-11-12 10:00:00", "Nao gostei do jogo", "aprovado"),   # item da compra 7 (Pixel Quest)
    (2, "2026-10-10 12:00:00", "Esperava um jogo mais longo", "pendente"),  # item da compra 1 (Neon Drift)
])

caminho_dml = os.path.join(RAIZ, "script_dml.sql")
with open(caminho_dml, "w", encoding="utf-8") as f:
    f.write("\n".join(sql) + "\n")

# ---- recria o banco
caminho_db = os.path.join(RAIZ, "meu_cenario.db")
if os.path.exists(caminho_db):
    os.remove(caminho_db)
con = sqlite3.connect(caminho_db)
con.execute("PRAGMA foreign_keys = ON")
con.executescript(open(os.path.join(RAIZ, "script_ddl.sql"), encoding="utf-8").read())
con.executescript(open(caminho_dml, encoding="utf-8").read())
con.commit()
print("FK check:", con.execute("PRAGMA foreign_key_check").fetchall())
print("integrity:", con.execute("PRAGMA integrity_check").fetchone())
for (t,) in con.execute("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name").fetchall():
    print(f"{t:18s}", con.execute(f"SELECT COUNT(*) FROM {t}").fetchone()[0])
con.close()
