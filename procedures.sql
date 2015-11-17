/*
Trevor Aron
Jay Miller
CHANGE THE FOLLOWING TO THE NAME OF YOUR DB 
use cs41515_jmill220_db; 
*/

DELIMITER //

/* Part A */
DROP PROCEDURE IF EXISTS ShowRawScores //
CREATE PROCEDURE ShowRawScores(IN student_ssn INT)
BEGIN
    IF student_ssn=0001 THEN
        SELECT 'Invalid SSN' AS 'Error Message';
    ELSEIF student_ssn=0002 THEN
        SELECT 'Invalid SSN' AS 'Error Message';
    ELSEIF NOT EXISTS(SELECT * FROM Rawscores WHERE SSN=student_ssn) THEN
        SELECT 'Invalid SSN' AS 'Error Message';
    ELSE
        SELECT *
        FROM Rawscores
        WHERE SSN=student_ssn;    
    END IF;
END;
//

/* Part B */
DROP PROCEDURE IF EXISTS ShowPercentages //
CREATE PROCEDURE ShowPercentages(IN student_ssn INT)
BEGIN
    DECLARE hw1total, hw1weight, hw2atotal, hw2aweight, hw2btotal, hw2bweight, midtermtotal, 
            midtermweight, hw3total, hw3weight, fexamtotal, fexamweight,
            hw1p, hw2ap, hw2bp, midtermp, hw3p, fexamp, cumavg FLOAT;
    DECLARE student_name VARCHAR(20);
    
    DECLARE gettotals CURSOR FOR
        SELECT HW1, HW2a, HW2b, Midterm, HW3, FExam
        FROM Rawscores
        WHERE SSN=0001;

    DECLARE getweights CURSOR FOR
        SELECT HW1, HW2a, HW2b, Midterm, HW3, FExam
        FROM Rawscores
        WHERE SSN=0002;

    OPEN gettotals;
    FETCH gettotals INTO hw1total, hw2atotal, hw2btotal, midtermtotal, hw3total, fexamtotal;
    CLOSE gettotals;

    OPEN getweights;
    FETCH getweights INTO hw1weight, hw2aweight, hw2bweight, midtermweight, hw3weight, fexamweight;
    CLOSE getweights;

    IF student_ssn=0001 THEN
        SELECT 'Invalid SSN' AS 'Error Message';
    ELSEIF student_ssn=0002 THEN
        SELECT 'Invalid SSN' AS 'Error Message';
    ELSEIF NOT EXISTS(SELECT * FROM Rawscores WHERE SSN=student_ssn) THEN
        SELECT 'Invalid SSN' AS 'Error Message';
    ELSE
        SELECT CONCAT(FName, ' ',LName), (100.0 * HW1/hw1total), (100.0 * HW2a/hw2atotal), (100.0 * HW2b/hw2btotal), (100.0 * Midterm/midtermtotal), (100.0 * HW3/hw3total), (100.0 * FExam/fexamtotal)
        INTO student_name, hw1p, hw2ap, hw2bp, midtermp, hw3p, fexamp
        FROM Rawscores 
        WHERE SSN=student_ssn;
        SELECT CONCAT(FName, ' ',LName) as Name, (100.0 * HW1/hw1total) as HW1_PERCENT, (100.0 * HW2a/hw2atotal) as HW2a_PERCENT, (100.0 * HW2b/hw2btotal) as HW2b_PERCENT, (100.0 * Midterm/midtermtotal) as MIDTERM_PERCENT, (100.0 * HW3/hw3total) as HW3_PERCENT, (100.0 * FExam/fexamtotal) as FEXAM_PERCENT
        FROM Rawscores 
        WHERE SSN=student_ssn;
        SET cumavg = hw1p*hw1weight+hw2ap*hw2aweight+hw2bp*hw2bweight+midtermp*midtermweight+hw3p*hw3weight+fexamp*fexamweight;
        SELECT CONCAT('The cumulative average for ', student_name, ' is ', cumavg) as Message; 
    END IF;    
END;
//

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

/* Part D */
DROP PROCEDURE IF EXISTS AllPercentages //
CREATE PROCEDURE AllPercentages(IN password VARCHAR(20))
IF NOT EXISTS (SELECT * from Passwords WHERE CurPasswords like password) THEN
    SELECT 'ERROR: Invalid Password' as 'Error Message';
ELSE
BEGIN
    DECLARE hw1total, hw1weight, hw2atotal, hw2aweight, hw2btotal, hw2bweight, midtermtotal, 
            midtermweight, hw3total, hw3weight, fexamtotal, fexamweight,
            hw1p, hw2ap, hw2bp, midtermp, hw3p, fexamp, cumavg FLOAT;
    DECLARE student_name VARCHAR(20);
    
    DECLARE gettotals CURSOR FOR
        SELECT HW1, HW2a, HW2b, Midterm, HW3, FExam
        FROM Rawscores
        WHERE SSN=0001;

    DECLARE getweights CURSOR FOR
        SELECT HW1, HW2a, HW2b, Midterm, HW3, FExam
        FROM Rawscores
        WHERE SSN=0002;

    OPEN gettotals;
    FETCH gettotals INTO hw1total, hw2atotal, hw2btotal, midtermtotal, hw3total, fexamtotal;
    CLOSE gettotals;

    OPEN getweights;
    FETCH getweights INTO hw1weight, hw2aweight, hw2bweight, midtermweight, hw3weight, fexamweight;
    CLOSE getweights;
    SELECT SSN, LName, FName, Section, (100.0 * HW1/hw1total) as HW1_Percent, (100.0 * HW2a/hw2atotal) as HW2a_PERCENT, (100.0 * HW2b/hw2btotal) as HW2b_PERCENT, (100.0 * Midterm/midtermtotal) as MIDTERM_PERCENT, (100.0 * HW3/hw3total) as HW3_PERCENT, (100.0 * FExam/fexamtotal) as FExam_PERCENT, hw1weight * (100.0 * HW1/hw1total)+ hw2aweight*(100.0 * HW2a/hw2atotal)+ hw2bweight * (100.0 * HW2b/hw2btotal)+ midtermweight*(100.0 * Midterm/midtermtotal)+ (100.0 * HW3/hw3total)*hw3weight + fexamweight*(100.0 * FExam/fexamtotal) as Weighted_Average
    FROM Rawscores 
    WHERE SSN != 0001 and SSN != 0002
    GROUP BY Section DESC, Weighted_Average DESC;
END;
END IF;
//

/* Part F */
DROP PROCEDURE IF EXISTS UpdateScores //
CREATE PROCEDURE UpdateScores(In password VARCHAR(20), In student_ssn INT, IN assignment VARCHAR(20), In new_score FLOAT)
BEGIN
    IF NOT EXISTS (SELECT * from Passwords WHERE CurPasswords like password) THEN
        SELECT 'Invalid password' as 'Error Message';
    ELSEIF student_ssn=0001 THEN
        SELECT 'Invalid SSN' AS 'Error Message';
    ELSEIF student_ssn=0002 THEN
        SELECT 'Invalid SSN' AS 'Error Message';
    ELSEIF NOT EXISTS(SELECT * FROM Rawscores WHERE SSN=student_ssn) THEN
        SELECT 'Invalid SSN' AS 'Error Message';
    ELSEIF assignment like 'HW1' THEN
        SELECT * FROM Rawscores WHERE SSN = student_ssn;
        UPDATE Rawscores
        SET HW1 = new_score
        WHERE SSN = student_ssn;
        SELECT * FROM Rawscores WHERE SSN = student_ssn;
    ELSEIF assignment like 'HW2a' THEN
        SELECT * FROM Rawscores WHERE SSN = student_ssn;
        UPDATE Rawscores
        SET HW2a = new_score
        WHERE SSN = student_ssn;
        SELECT * FROM Rawscores WHERE SSN = student_ssn;
    ELSEIF assignment like 'HW2b' THEN
        SELECT * FROM Rawscores WHERE SSN = student_ssn;
        UPDATE Rawscores
        SET HW2b = new_score
        WHERE SSN = student_ssn;
        SELECT * FROM Rawscores WHERE SSN = student_ssn;
    ELSEIF assignment like 'Midterm' THEN
        SELECT * FROM Rawscores WHERE SSN = student_ssn;
        UPDATE Rawscores
        SET Midterm = new_score
        WHERE SSN = student_ssn;
        SELECT * FROM Rawscores WHERE SSN = student_ssn;
    ELSEIF assignment like 'HW3' THEN
        SELECT * FROM Rawscores WHERE SSN = student_ssn;
        UPDATE Rawscores
        SET HW3 = new_score
        WHERE SSN = student_ssn;
        SELECT * FROM Rawscores WHERE SSN = student_ssn;
    ELSEIF assignment like 'FExam' THEN
        SELECT * FROM Rawscores WHERE SSN = student_ssn;
        UPDATE Rawscores
        SET HW3 = new_score
        WHERE SSN = student_ssn;
        SELECT * FROM Rawscores WHERE SSN = student_ssn;
    ELSE
        SELECT 'Invalid Assignment' AS 'Error Message';
    END IF;
END;
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
