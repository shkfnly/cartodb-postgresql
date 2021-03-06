set client_min_messages to ERROR;
\set VERBOSITY terse
CREATE TABLE big(a int);
-- Try the legacy interface
-- See https://github.com/CartoDB/cartodb-postgresql/issues/13
CREATE TRIGGER test_quota BEFORE UPDATE OR INSERT ON big
      EXECUTE PROCEDURE CDB_CheckQuota(1, 1, 'public');
INSERT INTO big VALUES (1); -- allowed, check runs before
INSERT INTO big VALUES (1); -- disallowed, quota exceeds before
SELECT CDB_SetUserQuotaInBytes(0);
SELECT CDB_CartodbfyTable('big');
INSERT INTO big SELECT generate_series(1,1024);
SELECT CDB_SetUserQuotaInBytes(8);
INSERT INTO big VALUES (1);
SELECT CDB_SetUserQuotaInBytes(0);
INSERT INTO big VALUES (1);
DROP TABLE big;
set client_min_messages to NOTICE;
DROP FUNCTION _CDB_UserQuotaInBytes();
