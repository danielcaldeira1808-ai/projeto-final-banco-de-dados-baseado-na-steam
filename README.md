# Plataforma de jogos online — Projeto Final de Banco de dados e aplicação (UFSC)

Banco de dados relacional (SQLite) de uma plataforma de distribuição e comunidade de jogos, nos moldes da Steam (não defini nome).

| Arquivo/pasta | Conteúdo |
|---|---|
| `modelagem/01_requisitos.md` | Levantamento e análise de requisitos (Parte 2, tarefa 1) |
| `modelagem/02_modelo_conceitual.md` + `modelagem/mer.png` | MER em notação de Chen (tarefa 2) |
| `modelagem/03_modelo_logico.md` | Esquema relacional e normalização até 3FN (tarefa 3) |
| `modelagem/04_projeto_fisico.md` | Decisões do projeto físico (tarefa 4) |
| `script_ddl.sql` / `script_dml.sql` | Criação das tabelas e dados de teste |
| `meu_cenario.db` | Banco SQLite criado e populado |
| `testes_violacao.sql` / `resultado_testes.txt` | Testes de integridade e evidências |
| `consultas/consulta1.sql … consulta10.sql` | 10 consultas SQL (Parte 3) |
| `tools/gerar_dml.py` | Gera o DML e o `.db` (Python) |
| `DECISOES.md` | Decisões de projeto e justificativas |
| `apresentacao/` | slides |
| `links.txt` | URLs externas usadas |

Como recriar o banco: `python tools/gerar_dml.py`
