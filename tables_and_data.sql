ALTER SESSION SET NLS_DATE_FORMAT = 'MM/DD/YYYY';
-- Drop tables --

DROP TABLE lds_account cascade constraints;

DROP TABLE lds_Placement cascade constraints;

DROP TABLE lds_consultant cascade constraints;

DROP TABLE lds_Contractor cascade constraints;

DROP TABLE lds_job_role cascade constraints;

DROP TABLE lds_skill cascade constraints;

DROP TABLE lds_skill_contractor cascade constraints;

DROP TABLE lds_previous_roles cascade constraints;

DROP TABLE lds_skill_job cascade constraints;
--------------------------------------------------------------
-- Table Creation --

-- Each entity on the model is represented by a table that needs to be created within the Database.
-- Within SQL new tables are created using the CREATE TABLE command.
-- When a table is created its name and its attributes are defined.
-- The values of which are derived from those specified on the model.
-- Certain constraints are sometimes also specified, such as identification of primary keys.

-- Create a Database table to represent the "lds_account" entity.
CREATE TABLE lds_account(
    account_id    INTEGER NOT NULL,
    acc_name    VARCHAR(15) NOT NULL,
    acc_postcode    VARCHAR(10) NOT NULL,
    acc_registered DATE ,
    turnover INTEGER,
    no_of_employees INTEGER,
    global_influence VARCHAR(10),
    fk1_consultant_id    INTEGER NOT NULL,
    -- Specify the PRIMARY KEY constraint for table "lds_account".
    -- This indicates which attribute(s) uniquely identify each row of data.
    CONSTRAINT    pk_lds_account PRIMARY KEY (account_id)
);

-- Create a Database table to represent the "lds_Placement" entity.
CREATE TABLE lds_Placement(
    placement_id    INTEGER NOT NULL,
    plt_short_desc    VARCHAR(25),
    plt_required_start_date    DATE,
    plt_estimated_end_date    DATE,
    ptl_actual_start_date    DATE,
    plt_actual_end_date    DATE,
    plt_renewal_no    INTEGER,
    plt_to_permanent    VARCHAR(1),
    feedback_value    INTEGER,
    actual_salary    INTEGER NOT NULL,
    fk1_account_id    INTEGER NOT NULL,
    fk2_contractor_id    INTEGER NOT NULL,
    fk3_job_role_id    INTEGER NOT NULL,
    -- Specify the PRIMARY KEY constraint for table "lds_Placement".
    -- This indicates which attribute(s) uniquely identify each row of data.
    CONSTRAINT    pk_lds_Placement PRIMARY KEY (placement_id)
);

-- Create a Database table to represent the "lds_consultant" entity.
CREATE TABLE lds_consultant(
    consultant_id    INTEGER NOT NULL,
    cst_name    VARCHAR(15),
    start_date    DATE,
    leave_date      DATE, 
    location VARCHAR(30),
    specialist_area VARCHAR(30), 
    -- Specify the PRIMARY KEY constraint for table "lds_consultant".
    -- This indicates which attribute(s) uniquely identify each row of data.
    CONSTRAINT    pk_lds_consultant PRIMARY KEY (consultant_id)
);

-- Create a Database table to represent the "lds_skill" entity.
CREATE TABLE lds_skill(
    skill_id    INTEGER NOT NULL,
    skill_desc    VARCHAR(25) NOT NULL,
    skill_added DATE NOT NULL,
    -- Specify the PRIMARY KEY constraint for table "lds_skill".
    -- This indicates which attribute(s) uniquely identify each row of data.
    CONSTRAINT    pk_lds_skill PRIMARY KEY (skill_id)
);

-- Create a Database table to represent the "lds_previous_roles" entity.
CREATE TABLE lds_previous_roles(
    role_id    INTEGER NOT NULL,
    job_role_name    VARCHAR(25),
    short_desc    VARCHAR(20) NOT NULL,
    start_date    DATE NOT NULL,
    end_date    DATE,
    fk1_contractor_id    INTEGER NOT NULL,
    -- Specify the PRIMARY KEY constraint for table "lds_previous_roles".
    -- This indicates which attribute(s) uniquely identify each row of data.
    CONSTRAINT    pk_lds_previous_roles PRIMARY KEY (role_id)
);

-- Create a Database table to represent the "lds_contractor" entity.
CREATE TABLE lds_contractor(
	contractor_id	INTEGER NOT NULL,
	con_name	VARCHAR(30),
	con_postcode	VARCHAR(20),
	highest_qual	INTEGER,
	con_registered	DATE,
	-- Specify the PRIMARY KEY constraint for table "lds_contractor".
	-- This indicates which attribute(s) uniquely identify each row of data.
	CONSTRAINT	pk_lds_contractor PRIMARY KEY (contractor_id)
);

-- Create a Database table to represent the "lds_job_role" entity.
CREATE TABLE lds_job_role(
	job_role_id	INTEGER NOT NULL,
	job_role_desc	VARCHAR(30) NOT NULL,
	max_sal	INTEGER,
	min_sal	INTEGER,
	recommended_sal	INTEGER,
	-- Specify the PRIMARY KEY constraint for table "lds_job_role".
	-- This indicates which attribute(s) uniquely identify each row of data.
	CONSTRAINT	pk_lds_job_role PRIMARY KEY (job_role_id)
);


CREATE TABLE lds_skill_contractor(
	skill_id	INTEGER NOT NULL,
	contractor_id	INTEGER NOT NULL,
        date_refreshed DATE,
        contractor_role_preference INTEGER,
	PRIMARY KEY (skill_id,contractor_id),
	FOREIGN KEY(skill_id) REFERENCES lds_skill(skill_id),
	FOREIGN KEY(contractor_id) REFERENCES lds_contractor(contractor_id) 
);


CREATE TABLE lds_skill_job(
	skill_id	INTEGER NOT NULL,
	job_role_id	INTEGER NOT NULL,
	PRIMARY KEY (skill_id,job_role_id),
	FOREIGN KEY(skill_id) REFERENCES lds_skill(skill_id) ,
	FOREIGN KEY(job_role_id) REFERENCES lds_job_role(job_role_id) 
);


ALTER TABLE lds_Placement ADD CONSTRAINT fk1_Plt_act FOREIGN KEY(fk1_account_id) REFERENCES lds_account(account_id) ;

-- Alter table to add new constraints required to implement the "is_assigned_to" relationship

-- This constraint ensures that the foreign key of table "lds_Placement"
-- correctly references the primary key of table "lds_Contractor"

ALTER TABLE lds_Placement ADD CONSTRAINT fk2_Plt_to_ctr FOREIGN KEY(fk2_contractor_id) REFERENCES lds_Contractor(contractor_id);

-- Alter table to add new constraints required to implement the "works_with" relationship

-- This constraint ensures that the foreign key of table "lds_account"
-- correctly references the primary key of table "lds_consultant"

ALTER TABLE lds_account ADD CONSTRAINT fk1_acc_con FOREIGN KEY(fk1_consultant_id) REFERENCES lds_consultant(consultant_id) ;

-- Alter table to add new constraints required to implement the "is_for" relationship

-- This constraint ensures that the foreign key of table "lds_Placement"
-- correctly references the primary key of table "lds_job_role"

ALTER TABLE lds_Placement ADD CONSTRAINT fk3_pct_job FOREIGN KEY(fk3_job_role_id) REFERENCES lds_job_role(job_role_id) ;

-- Alter table to add new constraints required to implement the "has" relationship

-- This constraint ensures that the foreign key of table "lds_previous_roles"
-- correctly references the primary key of table "lds_Contractor"

ALTER TABLE lds_previous_roles ADD CONSTRAINT fk1_role_con FOREIGN KEY(fk1_contractor_id) REFERENCES lds_Contractor

(contractor_id) ;

--------------------------------------------------------------
-- Leeds PlaceIT setup script and test data insert
-- JC July 2017

-- Database creation Script

-- Auto-Generated by QSEE-SuperLite (c) 2001-2004 QSEE-Technologies Ltd.

-- Verbose generation: ON

-- note: spaces within table/column names have been replaced by underscores (_)

-- Target DB: SQL2

-- Entity Model :Entity Relationship Diagram

--------------------------------------------------------------


--------------------------------------------------------------
-- add data in this order --


-- lds_consultant 
-- lds_account 
-- lds_skill 
-- lds_job_role 
-- lds_Contractor 
-- lds_previous_roles 
-- lds_Placement 
-- lds_skill_job
-- lds_skill_contractor

INSERT INTO lds_consultant VALUES(1, 'Adam Ascroft', '6/22/2013','', 'Manchester', 'Databases');
INSERT INTO lds_consultant VALUES(2, 'Bert Barch', '6/22/2014','','Manchester', 'Databases');
INSERT INTO lds_consultant VALUES(3, 'Cassie Calum', '6/22/2010','','Leeds', 'Project Management');
INSERT INTO lds_consultant VALUES(4, 'David David', '6/22/2010','','Leeds', 'Databases');
INSERT INTO lds_consultant VALUES(5, 'Ellis Engles', '6/22/2012','','Salford', 'Project Management');
INSERT INTO lds_consultant VALUES(6, 'Flick First', '6/22/2013','','Salford', 'Databases');
INSERT INTO lds_consultant VALUES(7, 'George Gill', '6/22/2012','','Harrogate', 'Development');
INSERT INTO lds_consultant VALUES(8, 'Henry Hoo', '6/22/2012','','Harrogate', 'Databases');
INSERT INTO lds_consultant VALUES(9, 'Issy Ingle', '6/22/2012','','Leeds', 'Development');
INSERT INTO lds_consultant VALUES(10, 'Joe James', '6/22/2013','','Leeds', 'Databases');
INSERT INTO lds_consultant VALUES(11, 'Keith Khan', '6/22/2015','','Leeds', 'Databases');

INSERT INTO lds_account VALUES (10, 'ACompany1', 'LS 6 121', '7/23/2013', 1000000, 100, 'High', 1);
INSERT INTO lds_account VALUES (11, 'ACompany2', 'LS 6 122', '7/23/2013', 10000, 50, 'Low', 1);
INSERT INTO lds_account VALUES (12, 'ACompany3', 'LS 6 123', '7/23/2013', 30000, 76, 'Low', 1);
INSERT INTO lds_account VALUES (13, 'ACompany4', 'LS 6 124', '7/23/2013', 100000, 100, 'Medium', 1);
INSERT INTO lds_account VALUES (14, 'ACompany5', 'LS 6 125', '7/23/2013', 20000, 10, 'Low', 1);
INSERT INTO lds_account VALUES (15, 'ACompany6', 'LS 6 126', '7/23/2013', 9000000, 500, 'High', 1);

INSERT INTO lds_account VALUES (20, 'BCompany1', 'LS 7 121', '8/20/2014', 1000000, 100, 'High', 2);
INSERT INTO lds_account VALUES (21, 'BCompany2', 'LS 7 122', '8/20/2014', 9000000, 100, 'High', 2);
INSERT INTO lds_account VALUES (22, 'BCompany3', 'LS 7 123', '8/20/2014', 10000, 10, 'Low', 2);
INSERT INTO lds_account VALUES (23, 'BCompany4', 'LS 7 124', '8/20/2014', 10000, 10, 'Low', 2);
INSERT INTO lds_account VALUES (24, 'BCompany5', 'LS 7 125', '8/20/2014', 10000000, 700, 'High', 2);
INSERT INTO lds_account VALUES (25, 'BCompany6', 'LS 7 126', '8/20/2014', 5000000, 500, 'High', 2);

INSERT INTO lds_account VALUES (30, 'CCompany1', 'LS 8 121', '1/01/2013', 100000, 60, 'Medium', 3);
INSERT INTO lds_account VALUES (31, 'CCompany2', 'LS 8 122', '1/01/2013', 200000, 76, 'Medium', 3);
INSERT INTO lds_account VALUES (32, 'CCompany3', 'LS 8 123', '1/01/2013', 300000, 34, 'Medium', 3);
INSERT INTO lds_account VALUES (33, 'CCompany4', 'LS 8 124', '1/01/2013', 100000, 40, 'Medium', 3);
INSERT INTO lds_account VALUES (34, 'CCompany5', 'LS 8 125', '1/01/2013', 100000, 80, 'Medium', 3);
INSERT INTO lds_account VALUES (35, 'CCompany6', 'LS 8 126', '1/01/2013', 100000, 100, 'Medium', 3);

INSERT INTO lds_account VALUES (40, 'DCompany1', 'LS 9 121', '3/03/2013',100000, 60, 'Medium', 4);
INSERT INTO lds_account VALUES (41, 'DCompany2', 'LS 9 122', '3/03/2013', 100000, 100, 'Medium', 4);
INSERT INTO lds_account VALUES (42, 'DCompany3', 'LS 9 123', '3/03/2013', 100000, 100, 'Medium', 4);
INSERT INTO lds_account VALUES (43, 'DCompany4', 'LS 9 124', '3/03/2013', 100000, 100, 'Medium', 4);
INSERT INTO lds_account VALUES (44, 'DCompany5', 'LS 9 125', '3/03/2013', 100000, 100, 'Medium', 4);
INSERT INTO lds_account VALUES (45, 'DCompany6', 'LS 9 126', '3/03/2013', 100000, 100, 'Medium', 4);
INSERT INTO lds_account VALUES (50, 'DCompany11', 'LS 9 121','3/03/2013', 100000, 100, 'Medium', 4);
INSERT INTO lds_account VALUES (51, 'DCompany21', 'LS 9 122','3/03/2013', 100000, 100, 'Medium', 4);
INSERT INTO lds_account VALUES (52, 'DCompany31', 'LS 9 123','3/03/2013', 100000, 100, 'Medium', 4);
INSERT INTO lds_account VALUES (53, 'DCompany41', 'LS 9 124','3/03/2013', 100000, 100, 'Medium', 4);
INSERT INTO lds_account VALUES (54, 'DCompany51', 'LS 9 125','3/03/2013', 100000, 100, 'Medium', 4);
INSERT INTO lds_account VALUES (55, 'DCompany61', 'LS 9 126','3/03/2013', 100000, 100, 'Medium', 4);

INSERT INTO lds_account VALUES (60, 'ECompany1', 'LS 6 121', '4/04/2014', 10000, 10, 'Low', 5);
INSERT INTO lds_account VALUES (61, 'ECompany2', 'LS 6 122', '4/04/2014', 20000, 30, 'Low', 5);
INSERT INTO lds_account VALUES (62, 'ECompany3', 'LS 6 123', '4/04/2014', 10000, 10, 'Low', 5);
INSERT INTO lds_account VALUES (63, 'ECompany4', 'LS 6 124', '4/04/2014', 20000, 10, 'Low', 5);
INSERT INTO lds_account VALUES (64, 'ECompany5', 'LS 6 125', '4/04/2014', 3000, 1, 'Low', 5);
INSERT INTO lds_account VALUES (65, 'ECompany6', 'LS 6 126', '4/04/2014', 10000, 10, 'Low', 5);

INSERT INTO lds_account VALUES (70, 'FCompany1', 'LS 7 121', '5/05/2015', 1000000, 710, 'High', 6);
INSERT INTO lds_account VALUES (71, 'FCompany2', 'LS 7 122', '5/05/2015', 1000000, 910, 'High', 6);
INSERT INTO lds_account VALUES (72, 'FCompany3', 'LS 7 123', '5/05/2015', 1000000, 1000, 'High', 6);
INSERT INTO lds_account VALUES (73, 'FCompany4', 'LS 7 124', '5/05/2015', 10000, 10, 'Low', 6);
INSERT INTO lds_account VALUES (74, 'FCompany5', 'LS 7 125', '5/05/2015', 10000, 10, 'Low', 6);
INSERT INTO lds_account VALUES (75, 'FCompany6', 'LS 7 126', '5/05/2015', 10000, 10, 'Low', 6);

INSERT INTO lds_account VALUES (80, 'GCompany1', 'LS 8 121', '', 1000000, 710, 'High', 7);
INSERT INTO lds_account VALUES (81, 'GCompany2', 'LS 8 122', '', 1000000, 710, 'High', 7);
INSERT INTO lds_account VALUES (82, 'GCompany3', 'LS 8 123', '', 100000, 710, 'Medium', 7);
INSERT INTO lds_account VALUES (83, 'GCompany4', 'LS 8 124', '', 100000, 710, 'Medium', 7);
INSERT INTO lds_account VALUES (84, 'GCompany5', 'LS 8 125', '', 100000, 710, 'Medium', 7);
INSERT INTO lds_account VALUES (85, 'GCompany6', 'LS 8 126', '', 1000000, 710, 'High', 7);

INSERT INTO lds_account VALUES (90, 'HCompany1', 'LS 9 121', '6/06/2015', 8000000, 900, 'High', 8);
INSERT INTO lds_account VALUES (91, 'HCompany2', 'LS 9 122', '6/06/2015', 80000, 90, 'Low', 8);
INSERT INTO lds_account VALUES (92, 'HCompany3', 'LS 9 123', '6/06/2015', 80000, 20, 'Low', 8);
INSERT INTO lds_account VALUES (93, 'HCompany4', 'LS 9 124', '6/06/2015', 80000, 10, 'Low', 8);
INSERT INTO lds_account VALUES (94, 'HCompany5', 'LS 9 125', '6/06/2015', 70000, 9, 'Low', 8);
INSERT INTO lds_account VALUES (95, 'HCompany6', 'LS 9 126', '6/06/2015', 80000, 9, 'Low', 8);
INSERT INTO lds_account VALUES (96, 'HCompany11', 'LS 9 121','6/06/2015', 50000, 5,'Low', 8);
INSERT INTO lds_account VALUES (97, 'HCompany21', 'LS 9 122','6/06/2015', 80000, 10, 'Low', 8);
INSERT INTO lds_account VALUES (98, 'HCompany31', 'LS 9 123','6/06/2015', 80000, 10, 'Low', 8);
INSERT INTO lds_account VALUES (99, 'HCompany41', 'LS 9 124','6/06/2015', 70000, 10, 'Low', 8);
INSERT INTO lds_account VALUES (100, 'HCompany51', 'LS 9 125', '6/06/2015', 50000, 3, 'Low', 8);
INSERT INTO lds_account VALUES (101, 'HCompany61', 'LS 9 126', '6/06/2015', 60000, 9, 'Low', 8);

INSERT INTO lds_account VALUES (901, 'HCompany1', 'LS 9 121', '6/06/2015', '', '','',9);
INSERT INTO lds_account VALUES (911, 'HCompany2', 'LS 9 122', '6/06/2015', '', '','',9);
INSERT INTO lds_account VALUES (921, 'HCompany3', 'LS 9 123', '6/06/2015', '', '','',9);
INSERT INTO lds_account VALUES (931, 'HCompany4', 'LS 9 124', '6/06/2015', '', '','',9);
INSERT INTO lds_account VALUES (941, 'HCompany5', 'LS 9 125', '6/06/2015', '', '','',9);
INSERT INTO lds_account VALUES (951, 'HCompany6', 'LS 9 126', '6/06/2015', '', '','',9);
INSERT INTO lds_account VALUES (961, 'HCompany11', 'LS 9 121','6/06/2015', '', '','',9);
INSERT INTO lds_account VALUES (971, 'HCompany21', 'LS 9 122','6/06/2015', '', '','',9);
INSERT INTO lds_account VALUES (981, 'HCompany31', 'LS 9 123','6/06/2015', '', '','',9);
INSERT INTO lds_account VALUES (991, 'HCompany41', 'LS 9 124','6/06/2015', '', '','',9);
INSERT INTO lds_account VALUES (1001, 'HCompany51', 'LS 9 125', '6/06/2015', '', '','',9);
INSERT INTO lds_account VALUES (1011, 'HCompany61', 'LS 9 126', '6/06/2015', '', '','',9);


INSERT INTO lds_skill VALUES (1, 'BASIC SQL', '01/01/2010');
INSERT INTO lds_skill VALUES (2, 'INTERMEDIATE SQL', '01/01/2010');
INSERT INTO lds_skill VALUES (3, 'ADVANCED SQL', '01/01/2010');
INSERT INTO lds_skill VALUES (4, 'Data Modelling', '01/01/2010');
INSERT INTO lds_skill VALUES (5, 'Data Analysis', '01/01/2010');
INSERT INTO lds_skill VALUES (6, 'PLSQL', '01/01/2010');
INSERT INTO lds_skill VALUES (7, 'Big Data', '01/01/2010');
INSERT INTO lds_skill VALUES (8, 'star schema modelling', '01/01/2010');
INSERT INTO lds_skill VALUES (9, 'NoSQL', '01/01/2010');
INSERT INTO lds_skill VALUES (10, 'OLAP', '01/01/2010');
INSERT INTO lds_skill VALUES (11, 'ETL', '01/01/2010');
INSERT INTO lds_skill VALUES (12, 'Requirements analysis', '01/01/2010');
INSERT INTO lds_skill VALUES (13, 'Batch SQL', '01/01/2010');
INSERT INTO lds_skill VALUES (14, 'Oracle Apex', '01/01/2010');
INSERT INTO lds_skill VALUES (15, 'MySQL', '01/01/2010');
INSERT INTO lds_skill VALUES (16, 'PHP', '01/01/2010');
INSERT INTO lds_skill VALUES (17, 'Performance Tuning', '01/01/2010');
INSERT INTO lds_skill VALUES (18, 'Project management', '01/01/2010');
INSERT INTO lds_skill VALUES (19, 'Testing', '01/01/2010');
INSERT INTO lds_skill VALUES (20, 'Data Visualisation', '01/01/2010');


INSERT INTO lds_job_role VALUES(1, 'Data Analyst', 50000,20000, 35000);
INSERT INTO lds_job_role VALUES(2, 'System Analyst', 50000,20000, 35000);
INSERT INTO lds_job_role VALUES(3, 'Data Consultant', 50000,20000, 35000);
INSERT INTO lds_job_role VALUES(4, 'Db programmer', 50000,20000, 35000);
INSERT INTO lds_job_role VALUES(5, 'Traninee BI', 40000,15000, 25000);
INSERT INTO lds_job_role VALUES(6, 'Report Analyst', 40000,15000, 25000);
INSERT INTO lds_job_role VALUES(7, 'Project Manager', 900000,20000, 50000);

INSERT INTO lds_contractor VALUES(10, 'Liam Love', 'LS6 981', 6, '01/01/2010');
INSERT INTO lds_contractor VALUES(11, 'Mandy More', 'LS6 982',6, '01/01/2010');
INSERT INTO lds_contractor VALUES(12, 'Neil Noel', 'LS6 983', 6, '01/01/2011');
INSERT INTO lds_contractor VALUES(13, 'Ollie Over', 'LS6 984', 7, '01/01/2011');
INSERT INTO lds_contractor VALUES(14, 'Petra Pot', 'LS6 981', 6, '01/01/2011');
INSERT INTO lds_contractor VALUES(15, 'Queen Que', 'LS6 982', 7, '01/01/2012');
INSERT INTO lds_contractor VALUES(16, 'Rich Roberts', 'LS6 982', 6, '01/01/2010');
INSERT INTO lds_contractor VALUES(17, 'Steph Son', 'LS7 981', 7, '01/01/2011');
INSERT INTO lds_contractor VALUES(18, 'Tim Tiny', 'LS7 981', 4, '01/01/2012');
INSERT INTO lds_contractor VALUES(19, 'Ullah Upworth', 'LS7 981', 4, '01/02/2012');
INSERT INTO lds_contractor VALUES(20, 'Vera vale', 'LS7 981', 4, '01/02/2012');
INSERT INTO lds_contractor VALUES(21, 'Wesley Walsh', 'LS7 981', 4, '01/01/2010');
INSERT INTO lds_contractor VALUES(22, 'Xio Xem', 'LS7 981', 6, '01/01/2011');
INSERT INTO lds_contractor VALUES(23, 'Yvonne Yelts', 'LS7 981', 7, '01/01/2012');
INSERT INTO lds_contractor VALUES(24, 'Zed Zebra', 'LS7 981',6, '01/02/2012');
INSERT INTO lds_contractor VALUES(30, 'Liam Land', 'LS8 981', 6, '01/02/2012');
INSERT INTO lds_contractor VALUES(31, 'Mandy Mand', 'LS8 982', 6, '01/02/2012');
INSERT INTO lds_contractor VALUES(32, 'Neil Nand', 'LS8 983', 6, '01/03/2012');
INSERT INTO lds_contractor VALUES(33, 'Ollie Onder', 'LS8 984', 6, '01/01/2010');
INSERT INTO lds_contractor VALUES(34, 'Petra Pand', 'LS8 981', 7, '01/01/2011');
INSERT INTO lds_contractor VALUES(35, 'Queen Quand', 'LS8 982', 7, '01/01/2012');
INSERT INTO lds_contractor VALUES(36, 'Rich Rand', 'LS6 982', 6, '01/02/2012');
INSERT INTO lds_contractor VALUES(37, 'Steph Sand', 'LS 981', 6, '01/03/2012');
INSERT INTO lds_contractor VALUES(38, 'Tim Tand', 'LS9 981',6, '01/01/2010');
INSERT INTO lds_contractor VALUES(39, 'Ullah Upand', 'LS9 981', 4, '01/01/2011');
INSERT INTO lds_contractor VALUES(40, 'Vera vand', 'LS9 981', 6, '01/01/2012');
INSERT INTO lds_contractor VALUES(41, 'Wesley Waand', 'LS9 981', 6, '01/02/2012');
INSERT INTO lds_contractor VALUES(42, 'Xio Xem', 'LS9 981', 6, '01/03/2012');
INSERT INTO lds_contractor VALUES(43, 'Yvonne Yand', 'LS9 981', 6, '01/03/2012');
INSERT INTO lds_contractor VALUES(44, 'Zed Zand', 'LS9 981', 6, '01/03/2012');
INSERT INTO lds_contractor VALUES(50, 'Liam Love', 'LS12 985', 6, '01/01/2010');
INSERT INTO lds_contractor VALUES(51, 'Mandy More', 'LS12 982', 6, '01/01/2011');
INSERT INTO lds_contractor VALUES(52, 'Neil Noel', 'LS12 983', 6, '01/01/2012');
INSERT INTO lds_contractor VALUES(53, 'Ollie Over', 'LS12 984', 7, '01/02/2012');
INSERT INTO lds_contractor VALUES(54, 'Petra Pot', 'LS12 981', 4, '01/03/2012');
INSERT INTO lds_contractor VALUES(55, 'Queen Que', 'LS12 982', 6, '01/03/2012');
INSERT INTO lds_contractor VALUES(56, 'Rich Roberts', 'LS12 982', 6, '01/01/2010');
INSERT INTO lds_contractor VALUES(57, 'Steph Son', 'LS14 981', 7, '01/01/2011');
INSERT INTO lds_contractor VALUES(58, 'Tim Tiny', 'LS14 981', 4, '01/01/2012');
INSERT INTO lds_contractor VALUES(59, 'Ullah Upworth', 'LS14 981', 4, '01/02/2012');
INSERT INTO lds_contractor VALUES(60, 'Vera vale', 'LS14 981', 4, '01/03/2012');
INSERT INTO lds_contractor VALUES(61, 'Wesley Walsh', 'LS14 981', 4, '01/01/2010');
INSERT INTO lds_contractor VALUES(62, 'Xio Xem', 'LS14 981', 6, '01/01/2011');
INSERT INTO lds_contractor VALUES(63, 'Yvonne Yelts', 'LS14 981', 6, '01/01/2012');
INSERT INTO lds_contractor VALUES(64, 'Zed Zebra', 'LS14 981', 6, '01/02/2012');


-- lds_previous_roles 
INSERT INTO lds_previous_roles VALUES (1, 'DBA at Asda', 'DBA', '01/01/2000', '01/01/2002', 10);
INSERT INTO lds_previous_roles VALUES (2, 'Head DBA at Asda', 'DBA', '01/01/2002', '01/01/2014', 10);
INSERT INTO lds_previous_roles VALUES (3, 'Student', 'Student', '01/01/2012', '01/01/2015', 11);
INSERT INTO lds_previous_roles VALUES (4, 'Programmer for accenture', 'Developer', '01/01/2000', '01/01/2002', 12);
INSERT INTO lds_previous_roles VALUES (5, 'Programmer for venturer', 'Developer', '01/01/2002', '01/01/2004', 12);
INSERT INTO lds_previous_roles VALUES (6, 'Programmer for WH', 'Developer', '01/01/2004', '01/01/2015', 12);
INSERT INTO lds_previous_roles VALUES (7, 'PM at NHS', 'project manager', '01/01/2000', '01/01/2002', 13);
INSERT INTO lds_previous_roles VALUES (8, 'Chief Operating Officer', 'Management', '01/01/2002', '01/01/2014', 13);
INSERT INTO lds_previous_roles VALUES (9, 'Student', 'Student', '01/01/2012', '01/01/2015', 14);
INSERT INTO lds_previous_roles VALUES (10, 'Developer for accenture', 'Developer', '01/01/2000', '01/01/2002', 15);
INSERT INTO lds_previous_roles VALUES (11, 'Developer for venturer', 'Developer', '01/01/2002', '01/01/2004', 15);
INSERT INTO lds_previous_roles VALUES (12, 'Developer for WH', 'Developer', '01/01/2004', '01/01/2015', 15);

DROP sequence lds_plc_seq;
Create sequence lds_plc_seq MINVALUE 1 MAXVALUE 9999999 INCREMENT BY 1 START WITH 1;

-- lds_Placement 
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'DBA at Asda', '01/01/2010', '01/03/2010', '01/01/2010', '01/03/2010', 1, 'N', '5', 30000, 10, 10, 3);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'DBA at Asda', '01/03/2010', '01/06/2010', '01/03/2010', '01/06/2010', 2, 'N', '4',   33000, 10, 10, 3);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'DBA at Asda', '01/06/2010', '01/09/2010', '01/06/2010', '01/09/2010', 3, 'N', '5',  33000, 10, 10, 3);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'DBA at Asda', '01/09/2010', '01/12/2010', '01/09/2010', '01/12/2010', 4, 'N', '5',  33000, 10, 10, 3);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'DBA at Asda', '01/01/2011', '01/03/2011', '01/01/2011', '01/03/2011', 1, 'N', '5',  33000, 10, 10, 3);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'DBA at Asda', '01/03/2011', '01/06/2011', '01/03/2011', '01/06/2011', 2, 'N', '2',  33000, 10, 10, 3);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'DBA at Asda', '01/06/2011', '01/09/2011', '01/06/2011', '01/09/2011', 3, 'N', '5',  33000, 10, 10, 3);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'DBA at Asda', '01/09/2011', '01/12/2011', '01/09/2011', '01/12/2011', 4, 'N', '4', 33000, 10, 10, 3);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'DBA at Asda', '01/01/2012', '01/03/2012', '01/01/2012', '01/03/2012', 1, 'N', '5', 33000, 10, 10, 3);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'DBA at Asda', '01/03/2012', '01/06/2012', '01/03/2012', '01/06/2012', 2, 'N', '4',  33000, 10, 10, 3);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'DBA at Asda', '01/06/2012', '01/09/2012', '01/06/2012', '01/09/2012', 3, 'N', '5',  33000, 10, 10, 3);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'DBA at Asda', '01/09/2012', '01/12/2012', '01/09/2012', '01/12/2012', 4, 'N', '4',  33000, 10, 10, 3);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'DBA at Asda', '01/01/2013', '01/03/2013', '01/01/2013', '01/03/2013', 1, 'N', '4',  33000, 10, 10, 3);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'DBA at Asda', '01/03/2013', '01/06/2013', '01/03/2013', '01/06/2013', 2, 'N', '5', 30100,  10, 10, 3);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'DBA at Asda', '01/06/2013', '01/09/2013', '01/06/2013', '01/09/2013', 3, 'N', '4', 33000, 10, 10, 3);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'DBA at Asda', '01/09/2013', '01/12/2013', '01/09/2013', '01/12/2013', 4, 'N', '5',   33000, 10, 10, 3);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'DBA at Asda', '01/01/2014', '01/03/2014', '01/01/2014', '01/03/2014', 1, 'N', '4',  33000, 10, 10, 3);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'DBA at Asda', '01/03/2014', '01/06/2014', '01/03/2014', '01/06/2014', 2, 'N', '5',  33000, 10, 10, 3);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'DBA at Asda', '01/06/2014', '01/09/2014', '01/06/2014', '01/09/2014', 3, 'N', '4', 33000, 10, 10, 3);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'DBA at Asda', '01/09/2014', '01/12/2014', '01/09/2014', '01/12/2014', 4, 'N', '4',  33000, 10, 10, 3);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'DBA at Asda', '01/01/2015', '01/03/2015', '01/01/2015', '01/03/2015', 1, 'N', '5',  33000,10, 10, 3);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'DBA at Asda', '01/03/2015', '01/06/2015', '01/03/2015', '01/06/2015', 2, 'N', '2',  33000,10, 10, 3);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'DBA at Asda', '01/06/2015', '01/09/2015', '01/06/2015', '01/09/2015', 3, 'N', '4', 33000, 10, 10, 3);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'DBA at Asda', '01/09/2015', '01/12/2015', '01/09/2015', '01/12/2015', 4, 'N', '5',  33000, 10, 10, 3);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'DBA at Asda', '01/01/2010', '01/03/2010', '01/01/2010', '01/03/2010', 1, 'N', '4',  33000, 10, 10, 3);

INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'systems analyst', '01/03/2010', '01/06/2010', '01/03/2010', '01/06/2010', 2, 'N', '5', 33000, 20, 11, 2);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'systems analyst', '01/06/2010', '01/09/2010', '01/06/2010', '01/09/2010', 3, 'N', '5', 33000, 20, 11, 2);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'systems analyst', '01/09/2010', '01/12/2010', '01/09/2010', '01/12/2010', 4, 'N', '4', 33000, 20, 11, 2);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'systems analyst', '01/01/2011', '01/03/2011', '01/01/2011', '01/03/2011', 1, 'N', '4' ,33000, 20, 11, 2);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'systems analyst', '01/03/2011', '01/06/2011', '01/03/2011', '01/06/2011', 2, 'N', '5', 33000, 20, 11, 2);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'systems analyst', '01/06/2011', '01/09/2011', '01/06/2011', '01/09/2011', 3, 'N', '4' ,40000, 20, 11, 2);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'systems analyst', '01/09/2011', '01/12/2011', '01/09/2011', '01/12/2011', 4, 'N', '5',  33000, 20, 11, 2);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'systems analyst', '01/01/2012', '01/03/2012', '01/01/2012', '01/03/2012', 1, 'N', '4', 40000, 20, 11, 2);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'systems analyst', '01/03/2012', '01/06/2012', '01/03/2012', '01/06/2012', 2, 'N', '4', 40000, 20, 11, 2);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'systems analyst', '01/06/2012', '01/09/2012', '01/06/2012', '01/09/2012', 3, 'N', '4', 40000,20, 11, 2);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'systems analyst', '01/09/2012', '01/12/2012', '01/09/2012', '01/12/2012', 4, 'N', '5',  33000, 20, 11, 2);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'systems analyst', '01/01/2013', '01/03/2013', '01/01/2013', '01/03/2013', 1, 'N', '4' ,40000, 20, 11, 2);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'systems analyst', '01/03/2013', '01/06/2013', '01/03/2013', '01/06/2013', 2, 'N', '2', 40000,  20, 11, 2);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'systems analyst', '01/06/2013', '01/09/2013', '01/06/2013', '01/09/2013', 3, 'N', '4', 40000,  20, 11, 2);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'systems analyst', '01/09/2013', '01/12/2013', '01/09/2013', '01/12/2013', 4, 'N', '5',  33000, 20, 11, 2);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'systems analyst', '01/01/2014', '01/03/2014', '01/01/2014', '01/03/2014', 1, 'N', '4', 40000, 20, 11, 2);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'systems analyst', '01/03/2014', '01/06/2014', '01/03/2014', '01/06/2014', 2, 'N', '4' ,40000, 20, 11, 2);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'systems analyst', '01/06/2014', '01/09/2014', '01/06/2014', '01/09/2014', 3, 'N', '4', 40000, 20, 11, 2);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'systems analyst', '01/09/2014', '01/12/2014', '01/09/2014', '01/12/2014', 4, 'N', '5',  33000, 20, 11, 2);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'systems analyst', '01/01/2015', '01/03/2015', '01/01/2015', '01/03/2015', 1, 'N', '4', 40000, 20, 11, 2);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'systems analyst', '01/03/2015', '01/06/2015', '01/03/2015', '01/06/2015', 2, 'N', '5',  33000, 20, 11, 2);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'systems analyst', '01/06/2015', '01/09/2015', '01/06/2015', '01/09/2015', 3, 'N', '4', 40000, 20, 11, 2);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'systems analyst', '01/09/2015', '01/12/2015', '01/09/2015', '01/12/2015', 4, 'N', '4', 40000, 20, 11, 2);

INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'data analyst', '01/01/2010', '01/03/2010', '01/01/2010', '01/03/2010', 1, 'N', '5',   33000,30, 12, 1);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'data analyst', '01/03/2010', '01/06/2010', '01/03/2010', '01/06/2010', 2, 'N', '4' , 33000, 30, 12, 1);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'data analyst', '01/06/2010', '01/09/2010', '01/06/2010', '01/09/2010', 3, 'N', '5',  33000, 30, 12, 1);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'data analyst', '01/09/2010', '01/12/2010', '01/09/2010', '01/12/2010', 4, 'N', '5',  33000, 30, 12, 1);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'data analyst', '01/01/2011', '01/03/2011', '01/01/2011', '01/03/2011', 1, 'N', '5',  33000, 30, 12, 1);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'data analyst', '01/03/2011', '01/06/2011', '01/03/2011', '01/06/2011', 2, 'N', '5',  33000, 30, 12, 1);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'data analyst', '01/06/2011', '01/09/2011', '01/06/2011', '01/09/2011', 3, 'N', '5',  33000, 30, 12, 1);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'data analyst', '01/09/2011', '01/12/2011', '01/09/2011', '01/12/2011', 4, 'N', '4' , 33000, 30, 12, 1);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'data analyst', '01/01/2012', '01/03/2012', '01/01/2012', '01/03/2012', 1, 'N', '5',  33000, 30, 12, 1);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'data analyst', '01/03/2012', '01/06/2012', '01/03/2012', '01/06/2012', 2, 'N', '5',  33000, 30, 12, 1);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'data analyst', '01/06/2012', '01/09/2012', '01/06/2012', '01/09/2012', 3, 'N', '4' , 33000, 30, 12, 1);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'data analyst', '01/09/2012', '01/12/2012', '01/09/2012', '01/12/2012', 4, 'N', '5',  33000, 30, 12, 1);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'data analyst', '01/01/2013', '01/03/2013', '01/01/2013', '01/03/2013', 1, 'N', '5',  33000, 30, 12, 1);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'data analyst', '01/03/2013', '01/06/2013', '01/03/2013', '01/06/2013', 2, 'N', '2',  33000, 30, 12, 1);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'data analyst', '01/06/2013', '01/09/2013', '01/06/2013', '01/09/2013', 3, 'N', '4' , 33000, 30, 12, 1);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'data analyst', '01/09/2013', '01/12/2013', '01/09/2013', '01/12/2013', 4, 'N', '5',  33000, 30, 12, 1);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'data analyst', '01/01/2014', '01/03/2014', '01/01/2014', '01/03/2014', 1, 'N', '4' , 33000, 30, 12, 1);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'data analyst', '01/03/2014', '01/06/2014', '01/03/2014', '01/06/2014', 2, 'N', '4' , 33000, 30, 12, 1);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'data analyst', '01/06/2014', '01/09/2014', '01/06/2014', '01/09/2014', 3, 'N', '5',  33000, 30, 12, 1);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'data analyst', '01/09/2014', '01/12/2014', '01/09/2014', '01/12/2014', 4, 'N', '4' , 33000,30, 12, 1);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'data analyst', '01/01/2015', '01/03/2015', '01/01/2015', '01/03/2015', 1, 'N', '4' , 33000, 30, 12, 1);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'data analyst', '01/03/2015', '01/06/2015', '01/03/2015', '01/06/2015', 2, 'N', '5',  33000, 30, 12, 1);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'data analyst', '01/06/2015', '01/09/2015', '01/06/2015', '01/09/2015', 3, 'N', '4' , 33000, 30, 12, 1);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'data analyst', '01/09/2015', '01/12/2015', '01/09/2015', '01/12/2015', 4, 'N', '4' , 33000, 30, 12, 1);

INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'developer', '01/01/2010', '01/03/2010', '01/01/2010', '01/03/2010', 1, 'N', '5', 33000, 40,16, 4);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'developer', '01/03/2010', '01/06/2010', '01/03/2010', '01/06/2010', 2, 'N', '4', 33000, 40,16, 4);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'developer', '01/06/2010', '01/09/2010', '01/06/2010', '01/09/2010', 3, 'N', '5',  33000, 40, 16, 4);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'developer', '01/09/2010', '01/12/2010', '01/09/2010', '01/12/2010', 4, 'N', '4', 33000, 40,16, 4);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'developer', '01/01/2011', '01/03/2011', '01/01/2011', '01/03/2011', 1, 'N', '4',  33000, 40,16, 4);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'developer', '01/03/2011', '01/06/2011', '01/03/2011', '01/06/2011', 2, 'N', '4',  33000, 40, 16, 4);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'developer', '01/06/2011', '01/09/2011', '01/06/2011', '01/09/2011', 3, 'N', '5',  33000, 40, 16, 4);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'developer', '01/09/2011', '01/12/2011', '01/09/2011', '01/12/2011', 4, 'N', '4', 33000, 40,16, 4);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'developer', '01/01/2012', '01/03/2012', '01/01/2012', '01/03/2012', 1, 'N', '4', 33000, 40,16, 4);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'developer', '01/03/2012', '01/06/2012', '01/03/2012', '01/06/2012', 2, 'N', '4', 33000, 40, 16, 4);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'developer', '01/06/2012', '01/09/2012', '01/06/2012', '01/09/2012', 3, 'N', '5',  33000, 40, 16, 4);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'developer', '01/09/2012', '01/12/2012', '01/09/2012', '01/12/2012', 4, 'N', '4',  33000, 40, 16, 4);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'developer', '01/01/2013', '01/03/2013', '01/01/2013', '01/03/2013', 1, 'N', '4',  33000, 40, 16, 4);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'developer', '01/03/2013', '01/06/2013', '01/03/2013', '01/06/2013', 2, 'N', '5',  33000, 40, 16, 4);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'developer', '01/06/2013', '01/09/2013', '01/06/2013', '01/09/2013', 3, 'N', '4', 33000, 40, 16, 4);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'developer', '01/09/2013', '01/12/2013', '01/09/2013', '01/12/2013', 4, 'N', '4',  33000, 40, 16, 4);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'developer', '01/01/2014', '01/03/2014', '01/01/2014', '01/03/2014', 1, 'N', '4', 33000, 40, 16, 4);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'developer', '01/03/2014', '01/06/2014', '01/03/2014', '01/06/2014', 2, 'N', '5',  33000, 40, 16, 4);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'developer', '01/06/2014', '01/09/2014', '01/06/2014', '01/09/2014', 3, 'N', '4',  33000, 40, 16, 4);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'developer', '01/09/2014', '01/12/2014', '01/09/2014', '01/12/2014', 4, 'N', '4',  33000, 40,16, 4);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'developer', '01/01/2015', '01/03/2015', '01/01/2015', '01/03/2015', 1, 'N', '5',  33000, 40, 16, 4);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'developer', '01/03/2015', '01/06/2015', '01/03/2015', '01/06/2015', 2, 'N', '4', 33000, 40, 16, 4);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'developer', '01/06/2015', '01/09/2015', '01/06/2015', '01/09/2015', 3, 'N', '5',  33000, 40, 16, 4);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'developer', '01/09/2015', '01/12/2015', '01/09/2015', '01/12/2015', 4, 'N', '4', 33000, 40,16, 4);

INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'BI Analyst', '01/01/2010', '01/03/2010', '01/01/2010', '01/03/2010', 1, 'N',  '4', 33000, 41,21, 5);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'BI Analyst', '01/03/2010', '01/06/2010', '01/03/2010', '01/06/2010', 2, 'N',  '4', 33000, 41,21, 5);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'BI Analyst', '01/06/2010', '01/09/2010', '01/06/2010', '01/09/2010', 3, 'N', '5',  33000, 41,21, 5);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'BI Analyst', '01/09/2010', '01/12/2010', '01/09/2010', '01/12/2010', 4, 'N',  '4', 33000, 41,21, 5);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'BI Analyst', '01/01/2011', '01/03/2011', '01/01/2011', '01/03/2011', 1, 'N',  '4', 33000, 41,21, 5);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'BI Analyst', '01/03/2011', '01/06/2011', '01/03/2011', '01/06/2011', 2, 'N',  '4', 33000, 41,21, 5);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'BI Analyst', '01/06/2011', '01/09/2011', '01/06/2011', '01/09/2011', 3, 'N', '5',   33000, 41,21, 5);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'BI Analyst', '01/09/2011', '01/12/2011', '01/09/2011', '01/12/2011', 4, 'N',  '4', 33000, 41, 21, 5);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'BI Analyst', '01/01/2012', '01/03/2012', '01/01/2012', '01/03/2012', 1, 'N',  '4', 33000, 41, 21, 5);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'BI Analyst', '01/03/2012', '01/06/2012', '01/03/2012', '01/06/2012', 2, 'N',  '4', 33000, 41, 21, 5);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'BI Analyst', '01/06/2012', '01/09/2012', '01/06/2012', '01/09/2012', 3, 'N',  '4', 33000, 41, 21, 5);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'BI Analyst', '01/09/2012', '01/12/2012', '01/09/2012', '01/12/2012', 4, 'N',  '4', 33000, 41, 21, 5);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'BI Analyst', '01/01/2013', '01/03/2013', '01/01/2013', '01/03/2013', 1, 'N', '5',  33000, 41, 21, 5);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'BI Analyst', '01/03/2013', '01/06/2013', '01/03/2013', '01/06/2013', 2, 'N', '2',  33000, 41, 21, 5);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'BI Analyst', '01/06/2013', '01/09/2013', '01/06/2013', '01/09/2013', 3, 'N',  '4', 33000, 41, 21, 5);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'BI Analyst', '01/09/2013', '01/12/2013', '01/09/2013', '01/12/2013', 4, 'N',  '4', 33000, 41, 21, 5);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'BI Analyst', '01/01/2014', '01/03/2014', '01/01/2014', '01/03/2014', 1, 'N', '5',  33000, 41, 21, 5);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'BI Analyst', '01/03/2014', '01/06/2014', '01/03/2014', '01/06/2014', 2, 'N',  '4', 33000, 41, 21, 5);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'BI Analyst', '01/06/2014', '01/09/2014', '01/06/2014', '01/09/2014', 3, 'N',  '4', 33000, 41, 21, 5);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'BI Analyst', '01/09/2014', '01/12/2014', '01/09/2014', '01/12/2014', 4, 'N', '5',  33000, 41, 21, 5);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'BI Analyst', '01/01/2015', '01/03/2015', '01/01/2015', '01/03/2015', 1, 'N',  '4', 33000, 41, 21, 5);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'BI Analyst', '01/03/2015', '01/06/2015', '01/03/2015', '01/06/2015', 2, 'N',  '4', 33000, 41, 21, 5);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'BI Analyst', '01/06/2015', '01/09/2015', '01/06/2015', '01/09/2015', 3, 'N', '5',  33000, 41, 21, 5);
INSERT INTO lds_placement VALUES (lds_plc_seq.nextval, 'BI Analyst', '01/09/2015', '01/12/2015', '01/09/2015', '01/12/2015', 4, 'N', '5',  33000, 41, 21, 5);

INSERT INTO lds_skill_job VALUES(1, 2);
INSERT INTO lds_skill_job VALUES(1, 4);
INSERT INTO lds_skill_job VALUES(1, 5);
INSERT INTO lds_skill_job VALUES(1, 3);
INSERT INTO lds_skill_job VALUES(1, 1);

INSERT INTO lds_skill_job VALUES(2, 3);
INSERT INTO lds_skill_job VALUES(2, 4);
INSERT INTO lds_skill_job VALUES(2, 5);
INSERT INTO lds_skill_job VALUES(3, 1);
INSERT INTO lds_skill_job VALUES(3, 3);

INSERT INTO lds_skill_job VALUES(3, 4);
INSERT INTO lds_skill_job VALUES(3, 5);
INSERT INTO lds_skill_job VALUES(4, 6);
INSERT INTO lds_skill_job VALUES(4, 1);
INSERT INTO lds_skill_job VALUES(4, 2);

INSERT INTO lds_skill_job VALUES(5, 3);
INSERT INTO lds_skill_job VALUES(5, 5);
INSERT INTO lds_skill_job VALUES(5, 6);
INSERT INTO lds_skill_job VALUES(5, 4);
INSERT INTO lds_skill_job VALUES(5, 7);
INSERT INTO lds_skill_job VALUES(6, 2);
INSERT INTO lds_skill_job VALUES(6, 4);
INSERT INTO lds_skill_job VALUES(6, 5);
INSERT INTO lds_skill_job VALUES(7, 3);
INSERT INTO lds_skill_job VALUES(7, 1);
INSERT INTO lds_skill_job VALUES(8, 2);
INSERT INTO lds_skill_job VALUES(8, 4);
INSERT INTO lds_skill_job VALUES(8, 5);
INSERT INTO lds_skill_job VALUES(9, 3);
INSERT INTO lds_skill_job VALUES(9, 1);
INSERT INTO lds_skill_job VALUES(9, 2);
INSERT INTO lds_skill_job VALUES(9, 4);
INSERT INTO lds_skill_job VALUES(10, 5);
INSERT INTO lds_skill_job VALUES(10, 3);
INSERT INTO lds_skill_job VALUES(11, 1);
INSERT INTO lds_skill_job VALUES(12, 2);
INSERT INTO lds_skill_job VALUES(12, 4);
INSERT INTO lds_skill_job VALUES(12, 5);
INSERT INTO lds_skill_job VALUES(12, 3);
INSERT INTO lds_skill_job VALUES(13, 1);
INSERT INTO lds_skill_job VALUES(13, 2);
INSERT INTO lds_skill_job VALUES(13, 4);
INSERT INTO lds_skill_job VALUES(14, 5);
INSERT INTO lds_skill_job VALUES(14, 3);
INSERT INTO lds_skill_job VALUES(14, 1);
INSERT INTO lds_skill_job VALUES(14, 2);
INSERT INTO lds_skill_job VALUES(15, 4);
INSERT INTO lds_skill_job VALUES(15, 5);
INSERT INTO lds_skill_job VALUES(15, 3);
INSERT INTO lds_skill_job VALUES(16, 1);
INSERT INTO lds_skill_job VALUES(16, 2);
INSERT INTO lds_skill_job VALUES(16, 4);
INSERT INTO lds_skill_job VALUES(17, 5);
INSERT INTO lds_skill_job VALUES(17, 3);
INSERT INTO lds_skill_job VALUES(17, 1);
INSERT INTO lds_skill_job VALUES(18, 6);
INSERT INTO lds_skill_job VALUES(18, 4);
INSERT INTO lds_skill_job VALUES(18, 5);
INSERT INTO lds_skill_job VALUES(19, 3);
INSERT INTO lds_skill_job VALUES(19, 6);
INSERT INTO lds_skill_job VALUES(19, 2);
INSERT INTO lds_skill_job VALUES(19, 4);
INSERT INTO lds_skill_job VALUES(20, 5);
INSERT INTO lds_skill_job VALUES(20, 6);
INSERT INTO lds_skill_job VALUES(20, 1);
INSERT INTO lds_skill_job VALUES(20, 2);

-- lds_skill_contractor

INSERT INTO lds_skill_contractor VALUES(	1	, 10	,'07/11/2017',	1	);
INSERT INTO lds_skill_contractor VALUES(	2	, 10	,'07/11/2017',	1	);
INSERT INTO lds_skill_contractor VALUES(	3	, 11	,'07/11/2017',	1	);
INSERT INTO lds_skill_contractor VALUES(	4	, 11	,'07/11/2017',	1	);
INSERT INTO lds_skill_contractor VALUES(	5	, 10	,'07/11/2017',	1	);
INSERT INTO lds_skill_contractor VALUES(	6	, 10	,'07/11/2017',	1	);
INSERT INTO lds_skill_contractor VALUES(	7	, 12	,'07/11/2017',	1	);
INSERT INTO lds_skill_contractor VALUES(	8	, 12	,'07/11/2017',	1	);
INSERT INTO lds_skill_contractor VALUES(	9	, 10	,'07/11/2017',	1	);
INSERT INTO lds_skill_contractor VALUES(	10	, 10	, '07/11/2017',	1	);
INSERT INTO lds_skill_contractor VALUES(	11	, 16	, '07/11/2017',	1	);
INSERT INTO lds_skill_contractor VALUES(	12	, 16	, '07/11/2017',	1	);
INSERT INTO lds_skill_contractor VALUES(	13	, 16	, '07/11/2017',	1	);
INSERT INTO lds_skill_contractor VALUES(	14	, 21	, '07/11/2017',	1	);
INSERT INTO lds_skill_contractor VALUES(	15	, 21	, '07/11/2017',	1	);
INSERT INTO lds_skill_contractor VALUES(	16	, 21	, '07/11/2017',	1	);
INSERT INTO lds_skill_contractor VALUES(	17	, 10	, '07/11/2017',	1	);
INSERT INTO lds_skill_contractor VALUES(	18	, 10	, '07/11/2017',	1	);
INSERT INTO lds_skill_contractor VALUES(	19	, 10	, '07/11/2017',	1	);
INSERT INTO lds_skill_contractor VALUES(	20	, 10	, '07/11/2017',	1	);
INSERT INTO lds_skill_contractor VALUES(	1	, 11	, '07/11/2017',  2	);
INSERT INTO lds_skill_contractor VALUES(	2	, 11	, '07/11/2017',  2	);
INSERT INTO lds_skill_contractor VALUES(	5	, 11	, '07/11/2017',  2	);
INSERT INTO lds_skill_contractor VALUES(	6	, 11	, '07/11/2017',  2	);
INSERT INTO lds_skill_contractor VALUES(	7	, 11	, '07/11/2017',  2	);
INSERT INTO lds_skill_contractor VALUES(	8	, 11	, '07/11/2017',  2	);
INSERT INTO lds_skill_contractor VALUES(	9	, 11	, '07/11/2017',  2	);
INSERT INTO lds_skill_contractor VALUES(	10	, 11	, '07/11/2017',  2	);
INSERT INTO lds_skill_contractor VALUES(	11	, 11	, '07/11/2017',  2	);
INSERT INTO lds_skill_contractor VALUES(	12	, 11	, '07/11/2017',  2	);
INSERT INTO lds_skill_contractor VALUES(	13	, 11	, '07/11/2017',  2	);
INSERT INTO lds_skill_contractor VALUES(	14	, 11	, '07/11/2017',  2	);
INSERT INTO lds_skill_contractor VALUES(	15	, 11	, '07/11/2017',  2	);
INSERT INTO lds_skill_contractor VALUES(	16	, 11	, '07/11/2017',  2	);
INSERT INTO lds_skill_contractor VALUES(	17	, 11	, '07/11/2017',  2	);
INSERT INTO lds_skill_contractor VALUES(	18	, 11	, '07/11/2017',  2	);
INSERT INTO lds_skill_contractor VALUES(	19	, 11	, '07/11/2017',  2	);
INSERT INTO lds_skill_contractor VALUES(	20	, 11	, '07/11/2017',  2	);
INSERT INTO lds_skill_contractor VALUES(	1	, 12	, '07/11/2017',	3	);
INSERT INTO lds_skill_contractor VALUES(	2	, 12	, '07/11/2017',	3	);
INSERT INTO lds_skill_contractor VALUES(	3	, 12	, '07/11/2017',	3	);
INSERT INTO lds_skill_contractor VALUES(	4	, 12	, '07/11/2017',	3	);
INSERT INTO lds_skill_contractor VALUES(	5	, 12	, '07/11/2017',	3	);
INSERT INTO lds_skill_contractor VALUES(	6	, 12	, '07/11/2017',	3	);
INSERT INTO lds_skill_contractor VALUES(	9	, 12	, '07/11/2017',	3	);
INSERT INTO lds_skill_contractor VALUES(	10	, 12	, '07/11/2017',	3	);
INSERT INTO lds_skill_contractor VALUES(	11	, 12	, '07/11/2017',	3	);
INSERT INTO lds_skill_contractor VALUES(	12	, 12	, '07/11/2017',	3	);
INSERT INTO lds_skill_contractor VALUES(	13	, 12	, '07/11/2017',	3	);
INSERT INTO lds_skill_contractor VALUES(	14	, 12	, '07/11/2017',	3	);
INSERT INTO lds_skill_contractor VALUES(	15	, 12	, '07/11/2017',	3	);
INSERT INTO lds_skill_contractor VALUES(	16	, 12	, '07/11/2017',	3	);
INSERT INTO lds_skill_contractor VALUES(	17	, 12	, '07/11/2017',	3	);
INSERT INTO lds_skill_contractor VALUES(	18	, 12	, '07/11/2017',	3	);
INSERT INTO lds_skill_contractor VALUES(	19	, 12	, '07/11/2017',	3	);
