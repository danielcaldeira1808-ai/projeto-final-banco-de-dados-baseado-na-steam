--- Consulta 9 (TRANSACAO - altera o banco: ativar DLCs guardadas (R5).
--- Passo 1: ana_silva (id 1) recebe o jogo base Moonlit Tactics (id 3); a DLC dela estava guardada.
--- Passo 2: SAVEPOINT + UPDATE de ensaio, conferido e DESFEITO com ROLLBACK TO.
--- Passo 3: o mesmo UPDATE e refeito e efetivado com COMMIT.
--- BEGIN, SAVEPOINT, ROLLBACK TO, COMMIT, subconsulta EXISTS, IFNULL.
BEGIN;

INSERT INTO biblioteca (id_usuario, id_jogo, origem) VALUES (1, 3, 'compra');

SAVEPOINT ensaio_ativacao;
UPDATE item_compra
   SET status_dlc = 'ativada'
 WHERE status_dlc = 'guardada'
   AND EXISTS (SELECT 1 FROM compra c
                 JOIN dlc d ON d.id_dlc = item_compra.id_dlc
                 JOIN biblioteca b ON b.id_usuario = c.id_usuario AND b.id_jogo = d.id_jogo_base
                WHERE c.id_compra = item_compra.id_compra);
-- conferencia do ensaio (esperado: 0 guardadas)
SELECT IFNULL(SUM(status_dlc = 'guardada'), 0) AS guardadas_apos_ensaio FROM item_compra WHERE id_dlc IS NOT NULL;
ROLLBACK TO ensaio_ativacao;
-- apos o ROLLBACK TO (esperado: 1 guardada de novo)
SELECT IFNULL(SUM(status_dlc = 'guardada'), 0) AS guardadas_apos_rollback FROM item_compra WHERE id_dlc IS NOT NULL;

UPDATE item_compra
   SET status_dlc = 'ativada'
 WHERE status_dlc = 'guardada'
   AND EXISTS (SELECT 1 FROM compra c
                 JOIN dlc d ON d.id_dlc = item_compra.id_dlc
                 JOIN biblioteca b ON b.id_usuario = c.id_usuario AND b.id_jogo = d.id_jogo_base
                WHERE c.id_compra = item_compra.id_compra);
COMMIT;
-- resultado final (esperado: 0 guardadas)
SELECT IFNULL(SUM(status_dlc = 'guardada'), 0) AS guardadas_final FROM item_compra WHERE id_dlc IS NOT NULL;
