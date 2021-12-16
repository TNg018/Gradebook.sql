/* 
* Intro to Databases 
* Gradebook program in sql
* MySQL Workbench
*/

CREATE DATABASE Gradebook;
USE Gradebook;
CREATE USER GradebookUser IDENTIFIED BY "password";
GRANT ALL PRIVILEGES ON Gradebook TO 'GradebookUser';
FLUSH PRIVILEGES;

DROP USER GradebookUser;
DROP DATABASE Gradebook;

CREATE TABLE CATALOG(
	Cno CHAR(10) NOT NULL, 
    Ctitle VARCHAR(20) NOT NULL, 
    primary key (Cno));

CREATE TABLE STUDENT(
	Sid char(9) NOT NULL, 
    Fname varchar(15) NOT NULL, 
    Minit char, 
    Lname varchar(15) NOT NULL, 
    primary key (Sid) );

CREATE TABLE COURSES(
	Term varchar(15) NOT NULL, 
    Sec_no varchar(10) NOT NULL, 
    Cno CHAR(10) NOT NULL, 
    A INT, 
    B INT, 
    C INT, 
    D INT, 
    primary key (Term, Sec_no) );

CREATE TABLE ENROLLS(
	Sid char(9) NOT NULL,
    Term varchar(15) NOT NULL, 
    Sec_no varchar(10) NOT NULL, 
    primary key (Sid, Term, Sec_no) );

SHOW FULL COLUMNS FROM COURSES;
SHOW FULL COLUMNS FROM ENROLLS;

SELECT * FROM COURSES;
SELECT * FROM ENROLLS;
SELECT * FROM STUDENT;
SELECT * FROM CATALOG;

DROP TABLE CATALOG;
DROP TABLE STUDENT;
DROP TABLE COURSES;
DROP TABLE ENROLLS;

INSERT INTO CATALOG values('CSCI130','Programming 1');
INSERT INTO CATALOG values('CSCI230','Programming 2');
INSERT INTO CATALOG values('CSCI360','Database Management');

INSERT INTO STUDENT values('123456789','Tom', 'P','Brady');
INSERT INTO STUDENT values('333445555','Jerry', 'A', 'Seinfeld');
INSERT INTO STUDENT values('999999999','Doug','C', 'Heffernan');

INSERT INTO COURSES values('Fall 2016',1,'CSCI130',90,80,70,60);
INSERT INTO COURSES values('Spr 2017',1,'CSCI230',90,80,70,60);
INSERT INTO COURSES values('Spr 2017',2,'CSCI360',90,80,70,60);

INSERT INTO ENROLLS values('123456789','Fall 2016',1);
INSERT INTO ENROLLS values('123456789','Spr 2017',1);
INSERT INTO ENROLLS values('333445555','Fall 2016',1);
INSERT INTO ENROLLS values('333445555','Spr 2017',1);
INSERT INTO ENROLLS values('333445555','Spr 2017',2);

ALTER TABLE COURSES ADD CONSTRAINT coursescatalogcnofk
foreign key (Cno) references CATALOG(Cno); 

CREATE INDEX indexid ON COURSES(Sec_no);

ALTER TABLE ENROLLS ADD CONSTRAINT enrollscoursessecnofk
foreign key(Sec_no) references COURSES(Sec_no);

ALTER TABLE ENROLLS ADD CONSTRAINT enrollstudentsidfk
foreign key(Sid) references STUDENT(Sid);

ALTER TABLE ENROLLS ADD CONSTRAINT enrollscoursestermfk
foreign key (Term) references COURSES(Term);

SELECT Fname, Minit, Lname
FROM STUDENT as S, ENROLLS as E, COURSES as C, CATALOG as CA
WHERE S.Sid = E.Sid AND C.Term='Spr 2017' AND CA.Ctitle='Database Management' AND E.Sec_no=C.Sec_no AND C.Cno=CA.Cno;

SELECT COUNT(*) AS no_students 
FROM STUDENT;

SELECT Lname 
FROM STUDENT 
WHERE Lname LIKE '%fe%';

SELECT Sid 
FROM ENROLLS as E, COURSES as C
WHERE E.Sec_no=C.Sec_no AND Cno='CSCI130'
UNION 
SELECT Sid 
FROM ENROLLS as E, COURSES as C
WHERE E.Sec_no=C.Sec_no AND Cno='CSCI230';

SELECT Fname, Minit, Lname
FROM STUDENT 
WHERE Sid NOT IN (
	SELECT Sid 
    FROM ENROLLS);
    