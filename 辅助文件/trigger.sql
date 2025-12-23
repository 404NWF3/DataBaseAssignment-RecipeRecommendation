CREATE OR REPLACE TRIGGER encrypt_user_password
BEFORE INSERT OR UPDATE ON USERS
FOR EACH ROW
BEGIN
    IF INSERTING OR :OLD.password_hash IS NULL OR :NEW.password_hash <> :OLD.password_hash THEN
        :NEW.password_hash := RAWTOHEX(
            DBMS_CRYPTO.HASH(
                src => UTL_RAW.CAST_TO_RAW(:NEW.password_hash),
                typ => DBMS_CRYPTO.HASH_SH256
            )
        );
    END IF;
END;