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

/* For Part G */
DROP PROCEDURE IF EXISTS UpdateMidterm //
CREATE PROCEDURE UpdateMidterm(In password VARCHAR(20), In s_ssn INT, IN new INT)
    IF NOT EXISTS (SELECT * from Passwords WHERE CurPasswords like password) THEN
        SELECT 'Update Failed!' as 'Output';
    ELSEIF NOT EXISTS (SELECT * from Rawscores WHERE SSN = s_ssn) THEN
        SELECT 'Update Failed!' as 'Output';
    ELSE
        UPDATE Rawscores
        Set Midterm = new
        WHERE SSN = s_ssn;
        SELECT 'Update Successful!' as 'Output';
    END IF;
//

