DELIMITER //


/* Part C */
DROP PROCEDURE IF EXISTS AllRawScores //
CREATE PROCEDURE AllRawScores(IN password VARCHAR(20))
    IF NOT EXISTS (SELECT * from Passwords WHERE CurPasswords like password) THEN
        SELECT 'ERROR: Invalid Password' as 'Error Message';
    ELSE
        SELECT *
        FROM Rawscores
        WHERE SSN != 0001 and SSN != 0002
        ORDER BY Section ASC, LName ASC, FName ASC;
    END IF;
//


