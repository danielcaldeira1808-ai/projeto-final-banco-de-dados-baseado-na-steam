--- Consulta 10 (TRANSACOES - alteram o banco; rode em uma COPIA): publicar nova versao e notificar os donos (R17).
--- Transacao 1 (ENSAIO): insere a versao 1.2.0 de 'Pixel Quest' (id 1) e os avisos; confere e DESFAZ TUDO com ROLLBACK.
--- Transacao 2 (REAL): repete o processo e efetiva com COMMIT; um SAVEPOINT isola a etapa dos avisos.
--- BEGIN, SAVEPOINT, RELEASE, ROLLBACK, COMMIT, INSERT ... SELECT, COUNT, IFNULL.

-- Transacao 1 desfeito 
BEGIN;
INSERT INTO versao (id_jogo, numero_versao, notas) VALUES (1, '1.2.0', 'Novas fases e correcoes');
SAVEPOINT avisos;
INSERT INTO notificacao (id_usuario, id_versao)
SELECT b.id_usuario, (SELECT MAX(id_versao) FROM versao WHERE id_jogo = 1)
  FROM biblioteca b WHERE b.id_jogo = 1;
-- dentro do ensaio (esperado: 2 avisos)
SELECT COUNT(*) AS avisos_no_ensaio FROM notificacao
 WHERE id_versao = (SELECT MAX(id_versao) FROM versao WHERE id_jogo = 1);
ROLLBACK;
-- apos o ROLLBACK (esperado: versao 1.2.0 nao existe mais -> 0)
SELECT COUNT(*) AS versoes_1_2_0_apos_rollback FROM versao WHERE id_jogo = 1 AND numero_versao = '1.2.0';

-- Transacao 2 efetivada 
BEGIN;
INSERT INTO versao (id_jogo, numero_versao, notas) VALUES (1, '1.2.0', 'Novas fases e correcoes');
SAVEPOINT avisos;
INSERT INTO notificacao (id_usuario, id_versao)
SELECT b.id_usuario, (SELECT MAX(id_versao) FROM versao WHERE id_jogo = 1)
  FROM biblioteca b WHERE b.id_jogo = 1;
RELEASE avisos;
COMMIT;
-- resultado final (esperado: 2 avisos gravados)
SELECT IFNULL(COUNT(*), 0) AS avisos_gravados FROM notificacao
 WHERE id_versao = (SELECT MAX(id_versao) FROM versao WHERE id_jogo = 1);
