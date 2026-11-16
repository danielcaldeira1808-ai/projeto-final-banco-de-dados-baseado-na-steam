# 4. Projeto Físico (Atividade 04) — SQLite
Script: `script_ddl.sql` (19 tabelas, 2 triggers, `PRAGMA foreign_keys = ON`). Dados: `script_dml.sql`. Banco pronto: `meu_cenario.db`.

## Tipos (afinidades SQLite)
| Tipo lógico | Físico | Exemplo |
|---|---|---|
| Identificadores | `INTEGER PRIMARY KEY` | `id_jogo` |
| Dinheiro | `INTEGER` em **centavos**  | `preco_centavos` |
| Data/hora | `TEXT` ISO 8601 (formato YYYY-MM-DD) | `2026-11-02 21:40:00` |
| Booleano | `INTEGER` 0/1 com CHECK | `finalizado` |
| Texto curto/longo | `TEXT` | `titulo`, `descricao` |

## Ações referenciais (regra de decisão)
- **RESTRICT** onde há histórico a preservar: desenvolvedor→jogo, usuário→compra, compra→pagamento, item→reembolso, jogo→item_compra e **biblioteca→avaliação/conquista_usuario** (decisão 12: remover um jogo da biblioteca exige tratar antes as avaliações e conquistas).
- **CASCADE** na dependência forte: jogo→versão/DLC/conquista, compra→item_compra, usuário→biblioteca/amizade/notificação.
- **SET NULL** apenas em `item_compra.id_promocao` (apagar uma promoção não apaga a venda).

## CHECKS 
preço ≥ 0 (R10) · desconto de 1 a 100 e fim > início (R9) · amizade consigo mesmo (R12) · domínios de status · operadora em lista fixa · item é jogo **ou** DLC.

## Triggers
R4 (compra → concluída exige pagamento confirmado) e R8 (reembolso: 14 dias, < 2 h, não finalizado). São os únicos, porque envolvem outras tabelas.

## Testes de violação
`testes_violacao.sql` (13 comandos) e `resultado_testes.txt` (mensagem real de erro de cada um): 13 de 13 bloqueados.
