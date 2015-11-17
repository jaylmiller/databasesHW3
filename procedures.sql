use cs41515_jmill220_db;

DELIMITER //

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
        SELECT CONCAT(FName, ' ',LName), (HW1/hw1total), (HW2a/hw2atotal), (HW2b/hw2btotal), (Midterm/midtermtotal), (HW3/hw3total), (FExam/fexamtotal)
        INTO student_name, hw1p, hw2ap, hw2bp, midtermp, hw3p, fexamp
        FROM Rawscores 
        WHERE SSN=student_ssn;
        SET cumavg = hw1p*hw1weight+hw2ap*hw2aweight+hw2bp*hw2bweight+midtermp*midtermweight+hw3p*hw3weight+fexamp*fexamweight;
        SELECT CONCAT('The cumulative average for ', student_name, ' is ', cumavg); 
    END IF;    
END;
