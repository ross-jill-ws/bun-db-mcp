--  Sample employee database (Simplified version with 1000 employees)
--  SQLite3 compatible version
--  See changelog table for details
--  Copyright (C) 2007,2008, MySQL AB
--
--  Original data created by Fusheng Wang and Carlo Zaniolo
--  http://www.cs.aau.dk/TimeCenter/software.htm
--  http://www.cs.aau.dk/TimeCenter/Data/employeeTemporalDataSet.zip
--
--  Current schema by Giuseppe Maxia
--  Data conversion from XML to relational by Patrick Crews
--
-- This work is licensed under the
-- Creative Commons Attribution-Share Alike 3.0 Unported License.
-- To view a copy of this license, visit
-- http://creativecommons.org/licenses/by-sa/3.0/ or send a letter to
-- Creative Commons, 171 Second Street, Suite 300, San Francisco,
-- California, 94105, USA.
--
--  DISCLAIMER
--  To the best of our knowledge, this data is fabricated, and
--  it does not correspond to real people.
--  Any similarity to existing people is purely coincidental.
--
--  NOTE: This is a simplified version containing only 1000 randomly
--  selected employees and their related records.
--

-- Disable foreign key checks during initial load
PRAGMA foreign_keys = OFF;

SELECT 'CREATING DATABASE STRUCTURE' as INFO;

-- Drop tables in correct order (respecting foreign key dependencies)
DROP TABLE IF EXISTS dept_emp;
DROP TABLE IF EXISTS dept_manager;
DROP TABLE IF EXISTS titles;
DROP TABLE IF EXISTS salaries;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

CREATE TABLE employees (
    emp_no      INT             NOT NULL,
    birth_date  DATE            NOT NULL,
    first_name  VARCHAR(14)     NOT NULL,
    last_name   VARCHAR(16)     NOT NULL,
    gender      TEXT            NOT NULL CHECK(gender IN ('M','F')),
    hire_date   DATE            NOT NULL,
    PRIMARY KEY (emp_no)
);

CREATE TABLE departments (
    dept_no     CHAR(4)         NOT NULL,
    dept_name   VARCHAR(40)     NOT NULL,
    PRIMARY KEY (dept_no),
    UNIQUE (dept_name)
);

CREATE TABLE dept_manager (
   emp_no       INT             NOT NULL,
   dept_no      CHAR(4)         NOT NULL,
   from_date    DATE            NOT NULL,
   to_date      DATE            NOT NULL,
   FOREIGN KEY (emp_no)  REFERENCES employees (emp_no)    ON DELETE CASCADE,
   FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
   PRIMARY KEY (emp_no,dept_no)
);

CREATE TABLE dept_emp (
    emp_no      INT             NOT NULL,
    dept_no     CHAR(4)         NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no)  REFERENCES employees   (emp_no)  ON DELETE CASCADE,
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,dept_no)
);

CREATE TABLE titles (
    emp_no      INT             NOT NULL,
    title       VARCHAR(50)     NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,title, from_date)
)
;

CREATE TABLE salaries (
    emp_no      INT             NOT NULL,
    salary      INT             NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no, from_date)
)
;

DROP VIEW IF EXISTS dept_emp_latest_date;
CREATE VIEW dept_emp_latest_date AS
    SELECT emp_no, MAX(from_date) AS from_date, MAX(to_date) AS to_date
    FROM dept_emp
    GROUP BY emp_no;

-- shows only the current department for each employee
DROP VIEW IF EXISTS current_dept_emp;
CREATE VIEW current_dept_emp AS
    SELECT l.emp_no, dept_no, l.from_date, l.to_date
    FROM dept_emp d
        INNER JOIN dept_emp_latest_date l
        ON d.emp_no=l.emp_no AND d.from_date=l.from_date AND l.to_date = d.to_date;

SELECT 'LOADING departments' as INFO;
INSERT INTO `departments` VALUES ('d001','Marketing'),
('d002','Finance'),
('d003','Human Resources'),
('d004','Production'),
('d005','Development'),
('d006','Quality Management'),
('d007','Sales'),
('d008','Research'),
('d009','Customer Service');



SELECT 'LOADING employees' as INFO;
INSERT INTO `employees` VALUES (10001,'1953-09-02','Georgi','Facello','M','1986-06-26'),
(10213,'1964-05-24','Jackson','Kakkad','M','1992-11-06'),
(10300,'1960-07-12','Tadahiko','Ulupinar','F','1991-05-17'),
(10604,'1957-04-24','Susanna','Brizzi','M','1990-04-07'),
(10887,'1953-01-16','Lunjin','DeMori','M','1989-03-16'),
(11131,'1964-02-18','Weiye','Zambonelli','M','1993-07-07'),
(11345,'1964-08-11','Youngkon','Maierhofer','M','1985-03-30'),
(11403,'1962-12-12','Baocai','Soicher','M','1989-08-03'),
(11702,'1956-01-22','Radhia','Kriebel','F','1988-09-18'),
(11859,'1959-07-31','Ipke','Muhlberg','M','1988-03-01');


INSERT INTO `employees` VALUES (12908,'1957-04-27','Tse','Mitsuhashi','F','1988-09-23'),
(13092,'1962-07-03','Kersti','Bergere','F','1992-07-17'),
(13408,'1954-12-27','Sreekrishna','Lagarias','M','1986-04-26'),
(13771,'1962-08-14','Franziska','Yavatkar','F','1990-05-21'),
(14102,'1955-05-11','Feixiong','Jording','F','1985-04-29'),
(14884,'1957-05-08','Mariusz','Reeker','F','1989-06-08'),
(15070,'1960-06-01','Mani','Delgrossi','F','1994-11-10'),
(15323,'1958-08-08','Luerbio','Genin','M','1988-04-02'),
(16020,'1963-05-26','Wuxu','Chiola','M','1990-01-04'),
(16431,'1960-06-19','Jinxi','Valette','M','1985-06-19');


INSERT INTO `employees` VALUES (16634,'1956-08-20','Parviz','Peroz','F','1986-11-11'),
(17170,'1960-03-15','Brewster','Birdsall','M','1987-06-05'),
(17418,'1960-09-12','Hsiangchu','Biros','M','1986-08-02'),
(17738,'1961-07-13','Teunis','Marquardt','M','1990-04-21'),
(18047,'1954-09-10','Dinah','Fortenbacher','F','1994-01-25'),
(19041,'1957-05-29','Billur','Facello','F','1992-08-03'),
(20163,'1957-10-23','Arvind','Wossner','M','1991-03-04'),
(20212,'1962-12-30','Rance','Serra','M','1991-12-20'),
(20241,'1962-07-21','Kankanahalli','Gilg','F','1991-05-12'),
(20685,'1957-03-21','Bingning','Rissanen','M','1989-10-23');


INSERT INTO `employees` VALUES (20877,'1956-06-02','Adib','Itschner','M','1993-08-04'),
(21029,'1959-06-26','Basil','Yurek','F','1995-04-29'),
(22407,'1957-04-17','Magdalena','Glinert','F','1996-01-20'),
(22806,'1964-06-10','Shuzo','Ressouche','M','1986-05-04'),
(22996,'1956-08-08','Kagan','Pluym','M','1989-09-22'),
(23113,'1960-01-15','Martine','Takanami','M','1990-09-12'),
(23463,'1960-08-26','Minghong','Wendorf','F','1996-08-01'),
(23561,'1955-08-14','Jingling','Zizka','M','1985-03-31'),
(23913,'1960-08-26','Yongdong','Steinauer','M','1985-07-20'),
(24139,'1963-06-17','Hugo','Bade','M','1996-10-18');


INSERT INTO `employees` VALUES (24210,'1959-05-15','Zhongwei','Ozeki','M','1988-01-08'),
(24471,'1952-05-10','Shaibal','Usdin','F','1996-01-02'),
(25048,'1958-06-08','Nirmal','Leivant','F','1988-08-01'),
(25136,'1959-05-12','Boalin','Worfolk','F','1993-02-26'),
(25177,'1962-05-19','Yurij','Marrevee','F','1990-01-17'),
(25218,'1958-03-08','Weiru','Zastre','M','1998-05-20'),
(25623,'1954-09-30','Berthier','Falby','M','1996-02-06'),
(26269,'1961-02-19','Mario','Ranft','F','1989-09-17'),
(26470,'1952-07-30','Toshimi','Danley','M','1988-07-13'),
(26664,'1962-12-06','Khalil','Spelt','M','1996-12-27');


INSERT INTO `employees` VALUES (26830,'1963-11-21','Vidya','Baek','M','1985-12-19'),
(27113,'1962-02-15','Kerryn','Picci','M','1993-12-01'),
(27945,'1957-11-23','Fumiyo','Mansanne','F','1986-01-12'),
(28822,'1957-11-14','Shigehiro','Covnot','M','1989-12-17'),
(28890,'1953-04-30','Lijie','Puoti','M','1987-05-20'),
(29240,'1956-06-08','Perry','Ranai','F','1992-11-04'),
(29409,'1961-08-10','Marjo','Schmezko','M','1987-12-22'),
(30058,'1956-01-08','Lucien','Meszaros','M','1990-12-18'),
(30303,'1955-01-12','Hyuckchul','Melter','F','1997-02-08'),
(30837,'1961-06-21','Xiaoheng','Templeman','M','1987-08-15');


INSERT INTO `employees` VALUES (30899,'1955-04-19','Dannz','Keirsey','M','1988-12-08'),
(30917,'1962-08-01','Theirry','Nooteboom','F','1988-06-09'),
(31093,'1957-04-01','Vishu','Lieberherr','F','1989-08-20'),
(31107,'1962-10-13','Fai','Facello','M','1994-07-11'),
(31533,'1954-06-11','Trygve','Albarhamtoshy','M','1988-12-21'),
(31931,'1952-06-07','Alenka','Leppanen','F','1985-09-02'),
(32781,'1958-09-20','Alair','Waterhouse','M','1991-07-02'),
(32884,'1956-08-02','Taizo','Pauthner','M','1996-01-13'),
(33115,'1952-09-26','Padma','Peyn','M','1988-11-28'),
(33272,'1955-11-23','Sanjit','Rotem','F','1989-09-02');


INSERT INTO `employees` VALUES (33864,'1956-05-27','Eric','Pusterhofer','M','1990-07-29'),
(34026,'1952-05-24','Uinam','Bugrara','F','1989-01-21'),
(34113,'1956-08-20','Feixiong','Cronau','M','1988-08-10'),
(34230,'1961-10-12','Otmar','Ghazalie','M','1986-05-31'),
(34703,'1952-05-17','Geoff','Azumi','M','1989-01-09'),
(36290,'1959-06-13','Howell','Potthoff','M','1988-04-23'),
(36329,'1963-06-08','Zhenhua','Talmor','M','1992-04-26'),
(36364,'1960-10-22','Adil','Gimbel','M','1997-11-27'),
(36523,'1964-01-18','Tadahiro','Schrooten','F','1994-05-28'),
(36634,'1961-10-09','Masoud','Compeau','M','1989-12-27');


INSERT INTO `employees` VALUES (36937,'1956-07-30','Kellyn','Apsitis','M','1995-12-03'),
(37060,'1952-10-11','Somnath','Morrey','M','1985-06-10'),
(37308,'1952-05-10','Iara','Beerel','M','1993-10-13'),
(38107,'1958-02-17','Nahla','Puppe','M','1986-03-04'),
(38402,'1959-08-26','Yuqun','Boguraev','M','1986-01-08'),
(38419,'1963-04-21','Shahar','Geffroy','M','1985-09-19'),
(38588,'1962-02-17','Krister','Knightly','F','1995-12-24'),
(39328,'1959-12-13','DeForest','Itschner','M','1986-01-12'),
(39423,'1953-02-17','Tiina','Przulj','F','1995-10-13'),
(39822,'1958-08-31','Bingning','Fujisawa','M','1986-07-12');


INSERT INTO `employees` VALUES (39972,'1960-10-10','Yongqiao','Zeleznik','M','1988-09-08'),
(40370,'1962-04-29','Ioana','Dulli','M','1988-07-03'),
(40663,'1963-04-26','Kristine','Delgrande','F','1990-11-20'),
(40742,'1960-06-15','Boguslaw','Hertweck','F','1989-08-08'),
(40867,'1955-05-09','Bikash','Suri','M','1993-01-18'),
(41268,'1959-01-03','Arfst','Poehlman','F','1990-08-22'),
(41579,'1961-03-25','Zito','Siochi','F','1993-10-03'),
(41779,'1958-12-31','Lubomir','Hellwagner','M','1987-01-29'),
(41960,'1955-11-22','Make','Pavlopoulou','M','1994-04-22'),
(42646,'1958-03-04','Genki','Coombs','M','1989-04-03');


INSERT INTO `employees` VALUES (43307,'1952-02-18','Mart','Feinberg','M','1992-07-07'),
(43569,'1962-09-02','Kiyokazu','Randt','F','1988-03-07'),
(43675,'1954-01-08','Weiwu','DasSarma','F','1993-01-18'),
(44259,'1962-05-29','Khun','Schwaller','M','1988-11-30'),
(44702,'1962-11-06','Sariel','Isaak','F','1986-06-16'),
(45338,'1958-01-30','Angel','Kropp','M','1991-12-07'),
(45632,'1957-11-25','Faiza','Masand','F','1991-02-20'),
(45873,'1963-11-14','Shan','Azulay','F','1993-07-07'),
(45883,'1955-04-08','JoAnna','Maccarone','M','1986-08-31'),
(45925,'1954-01-13','Hitomi','Yetim','M','1989-07-12');


INSERT INTO `employees` VALUES (45976,'1955-01-19','Tianruo','Trystram','M','1989-03-25'),
(46067,'1962-06-02','Pascal','Deverell','M','1985-10-24'),
(46154,'1956-04-06','Heekeun','Baezner','M','1994-01-05'),
(46288,'1964-01-13','Naftali','Genther','M','1992-06-07'),
(46397,'1964-01-29','Larisa','Varman','M','1987-07-20'),
(46467,'1962-12-31','Anestis','Randt','M','1991-02-08'),
(46601,'1958-08-20','Stamatina','Azevdeo','F','1986-06-21'),
(46687,'1957-05-15','Xiaopeng','Bauknecht','F','1987-07-12'),
(47150,'1964-01-29','Ute','Figueira','M','1991-02-25'),
(47221,'1959-02-05','Eric','Setiz','M','1985-03-07');


INSERT INTO `employees` VALUES (47319,'1959-11-20','Tuval','Chartres','F','1987-03-21'),
(47436,'1954-08-03','Aria','Biran','M','1995-08-14'),
(47440,'1953-12-09','Martijn','Panwar','F','1989-11-12'),
(48034,'1953-01-24','Odinaldo','Cronau','M','1989-05-19'),
(48183,'1955-08-05','Gil','Minakawa','F','1990-10-18'),
(48410,'1956-11-09','Macha','Saoudi','M','1994-12-14'),
(48841,'1954-09-10','Krisda','Busillo','F','1988-04-07'),
(49232,'1962-10-20','Yishai','Luiz','F','1985-12-25'),
(49356,'1961-03-04','Shem','Angot','M','1990-01-02'),
(49450,'1959-12-25','Premal','Quaggetto','M','1986-10-15');


INSERT INTO `employees` VALUES (49524,'1954-04-06','Saniya','Brender','M','1985-03-11'),
(49845,'1964-11-03','Alois','Percebois','M','1988-11-01'),
(50624,'1964-12-28','Hirochika','Rassart','M','1986-08-26'),
(51292,'1964-02-20','Charmane','Ermel','F','1989-01-26'),
(51314,'1962-09-21','Manton','Ranum','M','1986-07-04'),
(51403,'1963-03-11','Mahmut','Suri','M','1986-07-09'),
(51834,'1956-03-02','Maja','Rahier','F','1987-04-06'),
(52002,'1954-10-17','Parviz','Stamatiou','F','1986-05-22'),
(52109,'1962-03-06','Basant','Ariola','M','1985-04-09'),
(52175,'1955-07-12','Oldrich','Cronan','M','1986-01-10');


INSERT INTO `employees` VALUES (52246,'1959-11-26','Xiaoqiang','Zirintsis','M','1989-04-06'),
(52566,'1954-06-25','Kristine','Botman','M','1989-12-27'),
(52943,'1953-11-18','Jeane','Luga','M','1995-04-10'),
(52983,'1958-06-15','Mary','Litzkow','F','1985-11-23'),
(54013,'1956-04-21','Arie','Crelier','M','1989-12-21'),
(54458,'1961-01-27','Yonghoan','Quadeer','F','1985-06-22'),
(54660,'1957-01-09','Takushi','Birnbaum','F','1994-03-20'),
(54886,'1962-02-20','Bernice','Murthy','M','1990-12-12'),
(54908,'1956-04-14','Apostol','Ritcey','M','1988-04-05'),
(55437,'1960-11-11','Ugo','Zeleznik','F','1987-03-04');


INSERT INTO `employees` VALUES (55581,'1960-06-15','Junichi','Kaiser','M','1993-11-08'),
(56169,'1952-10-15','Jeanne','Zlotek','F','1986-09-03'),
(57385,'1963-10-22','Kiam','Gomatam','M','1991-03-24'),
(57663,'1962-01-04','Brigham','Rajala','F','1990-01-13'),
(57838,'1960-07-28','Constantijn','Keirsey','M','1997-11-18'),
(57882,'1954-05-09','Marsal','Bressoud','M','1988-12-28'),
(58391,'1955-07-25','Ayonca','Gyimothy','M','1990-07-12'),
(58626,'1954-09-14','Moss','Reghbati','M','1989-04-04'),
(58787,'1954-02-07','Kristina','Erie','M','1988-07-17'),
(58869,'1954-11-06','Nahid','Eugenio','M','1993-06-17');


INSERT INTO `employees` VALUES (58897,'1953-08-26','Kirk','Suermann','F','1989-12-09'),
(58962,'1962-01-29','Alassane','Herbst','M','1986-07-07'),
(59124,'1960-12-11','Nitsan','Bouloucos','F','1986-04-24'),
(59454,'1961-12-12','Ortrud','Braunschweig','F','1989-06-07'),
(60708,'1959-06-14','Ayakannu','Gustavson','M','1992-04-19'),
(60820,'1961-11-02','Siddarth','Lally','F','1989-08-15'),
(61333,'1960-04-23','LiMin','Lanzelotte','F','1986-11-03'),
(61600,'1954-01-05','Kazuhisa','Schicker','M','1990-10-24'),
(61613,'1958-01-14','Radhika','Nivat','M','1988-02-06'),
(62027,'1962-08-10','Marie','Kruskal','M','1995-12-18');


INSERT INTO `employees` VALUES (62278,'1959-07-29','Saeed','Parfitt','F','1991-03-21'),
(62419,'1962-02-04','Vasilii','Rikino','M','1986-04-07'),
(62620,'1962-09-01','Olivera','Rindone','M','1987-01-12'),
(62695,'1952-07-20','Guangming','Jenevein','F','1988-01-07'),
(62705,'1962-01-01','Sangeeta','Maraist','M','1996-09-10'),
(62954,'1962-10-26','Janche','Vural','F','1987-07-12'),
(63426,'1958-06-02','Baruch','Seuren','F','1986-06-29'),
(63588,'1952-07-04','Pintsang','Curless','F','1988-07-23'),
(63737,'1952-03-25','Baoqiu','Narahara','F','1986-10-19'),
(63786,'1964-08-23','IEEE','Scharstein','M','1986-01-18');


INSERT INTO `employees` VALUES (63836,'1952-10-26','Hitofumi','Petersohn','M','1986-08-09'),
(63894,'1955-06-21','Nikolaos','Bakhtari','F','1995-08-18'),
(64310,'1953-05-18','Khatoun','Kossowski','M','1985-02-17'),
(64841,'1958-03-26','Stafford','Vecchi','M','1986-02-14'),
(65333,'1964-06-08','Danil','Anick','F','1988-11-21'),
(65790,'1960-01-08','Hatsukazu','Aloisi','F','1986-02-20'),
(65883,'1965-01-07','Patricia','Pepe','M','1991-04-19'),
(66118,'1954-12-04','Yongmao','Fontet','M','1995-12-02'),
(66674,'1960-09-15','Rosalyn','Thorelli','M','1988-03-05'),
(66675,'1956-03-09','Ottavia','Birdsall','F','1989-09-23');


INSERT INTO `employees` VALUES (66835,'1960-05-16','Giao','Ramamoorthy','M','1989-12-11'),
(67289,'1959-01-20','Zdislav','Serra','F','1985-07-03'),
(67488,'1963-06-26','Fabrizio','Lortz','F','1989-09-18'),
(68370,'1953-05-11','Jianhui','Willoner','M','1994-11-21'),
(68486,'1962-04-10','Shay','Antonisse','M','1994-10-16'),
(68651,'1961-11-18','Gonzalo','Jahnichen','M','1998-04-12'),
(68655,'1959-12-06','Hidefumi','Zaccaria','M','1997-09-04'),
(69487,'1953-05-01','Sashi','Erdi','M','1991-06-23'),
(69815,'1959-08-22','Gererd','Eickenmeyer','F','1995-05-14'),
(69974,'1962-01-07','Gregory','Toyoshima','M','1996-05-03');


INSERT INTO `employees` VALUES (70049,'1954-03-11','Dipankar','Domenig','M','1988-05-31'),
(70059,'1953-07-12','Valeri','Tiemann','M','1986-09-26'),
(70176,'1958-12-09','Mart','Pileggi','M','1992-08-19'),
(70473,'1959-07-08','Hein','Ventosa','F','1986-09-26'),
(70518,'1964-03-02','Itzchak','Breugel','F','1995-08-10'),
(70632,'1961-07-23','Ulf','Hagimont','F','1988-12-05'),
(70777,'1954-01-11','JiYoung','Riefers','F','1997-01-25'),
(71587,'1964-02-08','Chenyi','Dichev','M','1988-08-15'),
(72103,'1964-12-30','Duke','Solovay','M','1985-08-10'),
(72682,'1957-04-05','Yucai','Ranon','M','1988-03-04');


INSERT INTO `employees` VALUES (72856,'1962-12-03','Parto','Chiola','M','1988-06-27'),
(73259,'1959-04-19','Jinya','Bail','F','1986-02-19'),
(73442,'1959-04-29','Olivera','Mahnke','M','1988-11-24'),
(73468,'1959-08-22','Krassimir','Furudate','F','1990-01-10'),
(73627,'1964-08-11','Rimli','Chiodo','M','1985-10-02'),
(73663,'1957-08-04','Domenick','Camurati','M','1992-09-29'),
(75198,'1964-08-30','Naraig','Krybus','F','1991-08-14'),
(75340,'1953-11-09','Sanjit','Katalagarianos','M','1986-05-18'),
(75445,'1964-02-13','Slavian','Orlowski','F','1988-11-02'),
(75935,'1957-06-27','Willard','Schmiedel','F','1995-11-24');


INSERT INTO `employees` VALUES (76177,'1954-04-17','Kerryn','Sommen','M','1985-09-12'),
(76190,'1962-08-15','Peternela','Hennebert','M','1987-11-09'),
(76207,'1957-11-10','Babette','Poujol','F','1988-09-12'),
(76366,'1962-05-06','Tonia','Coorg','F','1992-11-07'),
(76736,'1956-12-28','Juichirou','Perl','M','1995-12-26'),
(76819,'1964-10-31','Shaz','Desikan','M','1989-03-14'),
(76914,'1958-03-17','Utz','Hoogerwoord','F','1985-07-06'),
(77315,'1964-05-23','Christ','Irland','M','1986-04-05'),
(78588,'1960-05-27','Jasminko','Ghelli','M','1986-08-06'),
(78618,'1954-08-29','Teiji','Peres','M','1988-03-19');


INSERT INTO `employees` VALUES (78689,'1959-09-09','Larisa','Gerlach','M','1991-11-19'),
(79370,'1954-09-15','Aleksander','Veccia','M','1989-07-10'),
(79446,'1953-10-13','Filipe','Pettis','F','1988-05-10'),
(79909,'1954-06-14','Thodoros','Kamble','F','1996-07-23'),
(80408,'1962-01-25','Shakhar','Granlund','F','1990-11-29'),
(81146,'1964-11-25','Mohan','Luders','M','1985-08-27'),
(81570,'1963-09-09','Luise','Potthoff','F','1986-10-11'),
(81783,'1964-06-11','Jahangir','Wuwongse','F','1989-01-14'),
(82526,'1961-01-13','Raimond','Barinka','M','1985-06-18'),
(82548,'1960-11-17','Siddarth','Vecchio','M','1986-04-23');


INSERT INTO `employees` VALUES (83159,'1957-01-08','Jianwen','Kulisch','M','1995-05-07'),
(83207,'1964-06-22','Odoardo','Erni','M','1990-08-21'),
(83496,'1964-11-22','Adel','Zambonelli','M','1995-12-31'),
(84573,'1962-01-08','Mabo','Velasco','M','1988-01-11'),
(84906,'1964-02-26','Greger','Danecki','F','1985-07-05'),
(85579,'1959-02-26','Thanasis','Litzler','M','1993-06-08'),
(85835,'1952-03-28','Pantung','Gyorkos','M','1985-10-25'),
(86321,'1953-03-01','Shiv','Vasanthakumar','M','1988-05-25'),
(87256,'1962-06-18','Jovan','Gulik','M','1988-10-19'),
(87370,'1958-06-18','Zijian','Ullian','M','1988-09-24');


INSERT INTO `employees` VALUES (87644,'1954-06-02','Sachem','Waeselynck','F','1992-04-19'),
(87907,'1961-01-23','Marsha','Kalsbeek','M','1991-07-09'),
(88114,'1958-11-13','Sasan','Ghandeharizadeh','M','1996-03-23'),
(88148,'1958-05-08','Youngkon','Reeken','F','1991-09-12'),
(88223,'1960-01-04','Oscal','Pepe','M','1985-04-30'),
(89079,'1959-11-11','Maria','Anily','F','1987-03-15'),
(89549,'1956-05-11','Atilio','Yemenis','F','1999-02-06'),
(89747,'1957-05-01','Hidefumi','Ramsay','F','1989-05-08'),
(89893,'1956-12-11','Zhonghui','Baby','F','1986-12-05'),
(90114,'1960-09-10','Tru','Kroon','M','1998-12-22');


INSERT INTO `employees` VALUES (90132,'1954-06-02','Holgard','Mandell','M','1993-06-03'),
(90133,'1960-06-08','Amalendu','Rijsenbrij','M','1991-07-27'),
(90212,'1958-04-28','JiYoung','Rahimi','F','1986-06-10'),
(90726,'1956-11-30','Debatosh','Oxenboll','F','1998-01-08'),
(90930,'1963-06-27','Aloys','Vieri','F','1989-01-20'),
(91031,'1956-11-28','Pasqua','Krone','M','1994-09-03'),
(91159,'1952-08-20','Fusako','Boyle','F','1989-01-17'),
(91500,'1954-07-04','Bogdan','Kriebel','F','1986-02-05'),
(91517,'1952-12-18','Serif','Hofstetter','M','1986-04-20'),
(92069,'1952-05-10','Chenye','Leaver','M','1989-06-04');


INSERT INTO `employees` VALUES (92344,'1953-01-21','Paloma','Hanabata','M','1988-12-19'),
(92541,'1961-09-29','Yifei','Swiss','F','1985-05-28'),
(92705,'1963-12-11','Gunilla','Pintelas','M','1987-01-04'),
(92921,'1962-03-29','Eran','Luck','F','1987-06-04'),
(93036,'1957-03-20','Ottavia','Boissier','M','1987-03-24'),
(93445,'1954-01-15','Shahaf','Imataki','F','1986-06-06'),
(93466,'1954-01-02','Sasan','Schwaller','F','1991-01-20'),
(93708,'1958-08-16','Gou','Colorni','F','1986-08-29'),
(93877,'1955-03-21','Foong','Ghelli','F','1989-11-06'),
(94319,'1956-02-02','Yifei','Chelton','M','1996-12-01');


INSERT INTO `employees` VALUES (94699,'1964-11-28','Gaurav','Monarch','M','1992-11-24'),
(94716,'1959-01-06','Suzette','Matzel','F','1985-07-29'),
(95198,'1959-07-16','Kellie','Iisaka','M','1990-11-06'),
(95278,'1952-07-03','Roselyn','Seghrouchni','F','1987-10-30'),
(95670,'1955-06-29','Shaleah','Krybus','F','1988-10-03'),
(95861,'1959-02-26','Lobel','Ernst','F','1998-11-23'),
(96318,'1953-07-24','Berhard','Andreotta','M','1985-10-23'),
(96531,'1957-05-09','Anyuan','Solovay','M','1992-11-04'),
(96575,'1964-02-22','Sajjad','Meszaros','F','1985-12-07'),
(96992,'1962-04-20','Kensyu','Stenning','M','1992-05-19');


INSERT INTO `employees` VALUES (97195,'1955-06-14','Guther','Karunanithi','F','1987-12-08'),
(97224,'1960-02-04','Giap','Polupanov','F','1985-06-17'),
(97970,'1954-07-28','Shmuel','Papadias','F','1993-10-01'),
(98968,'1959-09-20','Pohua','Demizu','F','1986-01-22'),
(99121,'1962-08-16','Honesty','Przulj','F','1987-05-27'),
(99726,'1960-06-02','Duangkaew','Lupu','F','1986-05-11'),
(99731,'1964-01-20','Sakthirel','Akazan','F','1985-07-10'),
(101129,'1960-04-19','Nikolaus','Heering','M','1988-09-05'),
(101241,'1961-01-16','Paddy','Orlowski','F','1992-05-11'),
(101787,'1955-03-21','Shunichi','Muhling','M','1988-07-28');


INSERT INTO `employees` VALUES (101851,'1964-01-31','Karlis','Knightly','F','1991-06-26'),
(102216,'1962-08-12','Byong','Biran','M','1992-09-01'),
(102347,'1954-09-08','Remzi','Vural','M','1991-08-03'),
(102827,'1958-07-15','Xiaobin','Chaudhury','F','1994-07-18'),
(103621,'1954-05-30','Yuqun','Vidya','M','1987-06-06'),
(103666,'1963-07-27','Sariel','Penz','M','1995-07-26'),
(104037,'1959-05-25','Maia','Streit','F','1987-11-16'),
(104080,'1956-09-03','Niteen','Kadhim','F','1988-10-07'),
(104402,'1955-07-18','Gonzalo','Molenaar','M','1987-09-27'),
(105153,'1953-10-03','Gurbir','Staudhammer','F','1989-01-07');


INSERT INTO `employees` VALUES (105279,'1962-03-13','Lihong','Baca','M','1992-08-03'),
(105337,'1959-12-22','Wojceich','Wuwongse','M','1990-11-19'),
(106201,'1956-05-02','Mabo','Felder','M','1987-04-21'),
(106660,'1956-07-27','Suvo','Gimbel','F','1989-05-11'),
(107072,'1958-06-10','Uma','Genin','M','1989-07-07'),
(107426,'1960-07-17','Tesuro','Streit','F','1996-01-15'),
(108348,'1962-05-07','Xiaobin','Serot','M','1986-12-27'),
(108909,'1952-11-02','Isamu','Levergood','M','1992-11-15'),
(109562,'1963-07-05','Sudhanshu','Swiss','M','1994-07-01'),
(109657,'1962-06-25','Uma','Asmuth','F','1987-06-16');


INSERT INTO `employees` VALUES (109725,'1960-07-08','Stabislas','Jansch','F','1990-07-18'),
(109830,'1956-01-03','Ramzi','Krupka','M','1997-05-07'),
(109935,'1957-05-03','Berna','Cherinka','F','1990-07-11'),
(200144,'1956-06-05','Venkatesan','Muchinsky','F','1991-01-02'),
(200398,'1963-02-01','Elzbieta','Cmelik','M','1991-08-02'),
(200424,'1953-02-07','Sugwoo','Stroustrup','F','1990-09-25'),
(200555,'1962-05-22','Hairong','Kusakari','F','1992-07-15'),
(200790,'1954-05-12','Chenxi','Carrere','F','1992-01-21'),
(200945,'1961-07-29','Kousuke','Range','M','1987-07-28'),
(201231,'1953-04-18','Chenyi','Flexer','M','1987-05-17');


INSERT INTO `employees` VALUES (201749,'1956-02-04','Val','Standera','M','1988-04-07'),
(201916,'1955-03-06','Salvador','Prampolini','M','1992-03-30'),
(203279,'1956-06-01','Tomoyuki','Iisaka','M','1993-12-19'),
(203690,'1955-12-21','Zeljko','Soloway','M','1994-06-07'),
(203957,'1953-12-09','Kyoichi','Ouhyoung','M','1997-05-02'),
(204224,'1956-02-07','Youngkon','Camarinopoulos','M','1988-04-03'),
(204262,'1961-09-27','Gou','Erie','F','1992-07-09'),
(204377,'1954-09-08','Shai','Auyong','M','1997-01-17'),
(204498,'1958-11-01','Haldon','Veccia','F','1985-04-25'),
(204609,'1952-07-20','Aamer','Peris','M','1989-03-25');


INSERT INTO `employees` VALUES (205437,'1956-02-27','Baziley','Kermarrec','F','1996-08-05'),
(206699,'1962-01-12','Leen','Navazio','F','1995-04-25'),
(206719,'1954-05-29','Heping','Docker','M','1989-06-12'),
(207066,'1962-06-15','Gro','Covnot','F','1988-08-18'),
(207354,'1959-11-17','Susanne','Parascandalo','M','1991-08-11'),
(208416,'1953-02-04','Kendra','Braunschweig','M','1988-03-18'),
(208916,'1963-12-27','Bedrich','Uludag','M','1993-08-23'),
(209818,'1958-09-17','Barton','Radivojevic','M','1990-05-27'),
(210116,'1952-05-16','Marlo','Bolsens','M','1987-02-04'),
(210172,'1952-04-23','Pantung','Haddadi','F','1987-05-11');


INSERT INTO `employees` VALUES (210406,'1957-03-25','Lucien','Geffroy','M','1991-04-01'),
(210591,'1954-07-06','Herbert','Hashii','M','1991-10-16'),
(210613,'1964-09-15','Saeko','Pramanik','M','1997-06-06'),
(210946,'1958-03-26','Gregory','Lambe','F','1987-10-19'),
(211019,'1958-05-23','Danco','Marshall','F','1986-12-25'),
(211187,'1959-09-26','Chrisa','Taneja','F','1990-01-03'),
(211453,'1961-06-26','Byong','Dahlbom','F','1991-05-09'),
(211730,'1960-06-08','Xuedong','Suermann','M','1990-04-27'),
(212017,'1959-08-31','Alain','Zaccaria','F','1987-09-01'),
(212041,'1952-04-14','Zvonko','Figueira','M','1990-09-15');


INSERT INTO `employees` VALUES (212148,'1962-10-20','Deborah','Ranum','M','1992-01-15'),
(212297,'1962-05-29','Jiang','Coullard','M','1991-04-23'),
(212862,'1959-06-01','Murthy','Karcich','M','1989-01-24'),
(213423,'1964-04-17','Gil','Gajiwala','F','1992-03-06'),
(214113,'1955-01-27','Shawna','Openshaw','F','1995-09-16'),
(214252,'1955-02-13','Katsuo','Granlund','M','1985-08-29'),
(214605,'1953-08-20','Mario','Rosenbaum','M','1988-05-18'),
(214711,'1960-09-01','Munenori','Lenart','F','1990-09-22'),
(214963,'1961-03-06','Aksel','Niizuma','M','1989-03-11'),
(215016,'1954-09-08','Uinam','Sullins','M','1987-06-03');


INSERT INTO `employees` VALUES (215117,'1961-05-15','Shay','Pollacia','M','1993-12-27'),
(215433,'1963-02-15','Sachin','Asser','F','1992-03-29'),
(215550,'1957-03-06','Lein','Bresenham','F','1988-11-23'),
(215601,'1952-06-14','Xiaobin','Doering','F','1989-05-30'),
(216156,'1959-04-28','Lucian','Poujol','M','1988-03-01'),
(216595,'1963-03-30','Spyrose','Jeong','F','1994-09-11'),
(216852,'1962-06-21','Demos','Biros','M','1992-04-22'),
(217002,'1952-07-21','Dipayan','Ginesta','M','1991-08-14'),
(217532,'1957-12-23','Duri','Schahn','F','1991-03-01'),
(217752,'1952-05-10','Boaz','Ballarin','M','1990-06-05');


INSERT INTO `employees` VALUES (217782,'1958-07-15','Jaques','Menhoudj','F','1992-06-02'),
(217783,'1960-04-15','Kiyomitsu','Fargier','F','1997-01-22'),
(217840,'1961-04-20','Bangqing','Antonisse','M','1986-08-24'),
(218301,'1958-08-26','Satyanarayana','Cangellaris','M','1989-09-28'),
(219242,'1964-12-11','Kaijung','Gewali','F','1997-02-13'),
(219244,'1952-12-28','Zhiguo','Vecchi','F','1992-04-22'),
(219301,'1961-03-06','Shahab','Seuren','M','1988-09-10'),
(219460,'1957-06-25','Geoffry','Shimshoni','F','1988-01-02'),
(219998,'1952-03-26','Lijia','Lindqvist','F','1990-10-18'),
(220007,'1955-09-08','Maren','Molenkamp','F','1985-12-06');


INSERT INTO `employees` VALUES (220063,'1964-10-09','Muzhong','McConalogue','M','1997-10-14'),
(220622,'1953-04-02','Tsuneo','Bernardinello','M','1985-08-30'),
(220844,'1958-06-15','Yongqiao','Leijenhorst','F','1987-01-27'),
(221223,'1954-03-23','Mariangiola','Vandervoorde','F','1986-08-24'),
(221336,'1963-02-27','Behnaam','Giaccio','M','1993-02-28'),
(221957,'1963-11-01','Sumant','Kohling','M','1991-07-04'),
(222025,'1952-11-19','Xumin','Norsworthy','F','1992-08-19'),
(222357,'1958-10-16','Maya','Khalid','M','1991-03-11'),
(222429,'1957-09-30','Erez','Pargas','F','1992-01-15'),
(222918,'1964-04-12','Fen','Schwabacher','M','1987-01-08');


INSERT INTO `employees` VALUES (223063,'1955-01-31','Kiyotoshi','Braunschweig','F','1996-04-22'),
(223114,'1961-07-05','Ishfaq','Massonet','M','1987-11-01'),
(223290,'1960-05-14','Pohua','Baar','F','1996-01-04'),
(223906,'1964-10-28','Dhritiman','Samarati','F','1996-07-21'),
(224094,'1956-01-28','Akeel','Msuda','M','1994-06-08'),
(224758,'1953-04-14','Subhash','Ratnakar','F','1996-12-10'),
(224996,'1953-08-12','Shan','Awdeh','M','1996-03-07'),
(225042,'1961-03-11','Yunming','Msuda','M','1991-11-14'),
(225116,'1953-01-23','Josyula','Uhrig','F','1986-04-08'),
(225178,'1958-11-02','Kazunori','Slobodova','F','1986-08-18');


INSERT INTO `employees` VALUES (225409,'1956-04-09','Turgut','Mersereau','M','1986-10-15'),
(225436,'1960-05-08','Shichao','Ozeki','M','1986-09-12'),
(225517,'1958-01-31','Renny','Zolotykh','M','1985-08-15'),
(225734,'1961-12-14','Muzhong','Milicic','M','1990-11-10'),
(225974,'1962-08-26','Yucel','Legleitner','M','1985-05-29'),
(226262,'1958-01-11','Irena','Avouris','M','1990-11-24'),
(226516,'1961-08-09','Yakichi','Xiaoshan','M','1985-02-12'),
(227299,'1955-10-22','Kellyn','Millington','M','1988-06-18'),
(227376,'1963-10-02','Breannda','Ariola','F','1989-11-24'),
(227537,'1963-05-25','Karoline','Boudaillier','F','1991-07-17');


INSERT INTO `employees` VALUES (227761,'1956-01-06','Valdiodio','Collette','F','1995-12-11'),
(227830,'1953-10-03','Deborah','Matzat','F','1991-09-15'),
(227894,'1952-12-06','Lijia','Kulisch','F','1987-12-20'),
(228005,'1952-09-15','Mitsuyuki','Gulik','F','1992-08-26'),
(228051,'1954-08-29','Yuguang','Viele','M','1988-12-18'),
(228327,'1960-05-13','Mingdong','Farrel','F','1987-11-07'),
(228344,'1963-05-18','Heekeun','Swab','M','1999-03-25'),
(228369,'1962-03-12','Aamer','Lemarechal','F','1993-12-28'),
(228686,'1953-10-21','Teunis','Wendorf','M','1992-05-18'),
(229063,'1956-10-04','Nathan','Setia','F','1991-07-31');


INSERT INTO `employees` VALUES (229279,'1963-08-03','Toong','Cannata','M','1998-05-08'),
(229600,'1959-12-12','JoAnne','Linares','M','1987-08-28'),
(229623,'1958-08-19','Shen','Puoti','M','1990-04-29'),
(229949,'1954-07-04','Alois','Matzov','F','1988-04-27'),
(230087,'1956-06-24','Leandro','Bierbaum','F','1989-03-08'),
(230099,'1961-03-09','Maia','Fadgyas','F','1989-06-16'),
(230343,'1956-10-30','Tetsushi','Mitzlaff','M','1996-03-09'),
(230627,'1964-10-27','Chenxi','Alblas','F','1986-01-29'),
(230801,'1952-10-20','Giao','Engberts','M','1988-10-22'),
(230946,'1952-06-15','Tamiya','Taubenfeld','M','1988-05-18');


INSERT INTO `employees` VALUES (231240,'1964-06-28','Salvador','Kitai','F','1997-08-06'),
(231635,'1953-11-17','Billie','Kalafatis','M','1985-03-21'),
(231783,'1955-02-13','Tomokazu','Radwan','M','1989-02-21'),
(231789,'1960-05-05','Heather','Androutsos','F','1987-01-18'),
(232238,'1952-11-27','Piyawadee','Fiutem','M','1985-11-15'),
(232305,'1962-04-20','Sanjeeva','Clouatre','M','1992-09-04'),
(232347,'1962-11-23','Vojin','Birjandi','M','1985-07-07'),
(233523,'1954-01-25','Shaowen','Lorcy','M','1985-03-11'),
(234321,'1964-11-08','Lene','Horswill','M','1996-08-03'),
(235427,'1955-04-22','Lucian','Isaak','F','1991-03-29');


INSERT INTO `employees` VALUES (235867,'1963-08-15','Naraig','Parfitt','M','1987-05-27'),
(236372,'1956-06-16','Arlette','Lund','F','1987-12-19'),
(236692,'1963-01-16','JoAnne','Furudate','F','1991-03-15'),
(236927,'1960-06-12','Ayonca','Pillow','M','1995-09-17'),
(237316,'1955-05-22','Mona','Walstra','F','1992-07-08'),
(237728,'1952-04-08','Fox','Butterworth','M','1992-10-07'),
(238067,'1959-05-19','Freyja','Naudin','M','1988-05-20'),
(238379,'1961-06-01','Lidong','Hedayat','M','1989-02-02'),
(238632,'1957-02-09','Leon','Baba','F','1986-07-22'),
(238661,'1963-02-02','Eben','Rissanen','M','1989-08-27');


INSERT INTO `employees` VALUES (238678,'1957-04-26','Angel','Dulli','F','1991-10-10'),
(238726,'1953-08-09','Yefim','Marrevee','F','1994-08-08'),
(238849,'1962-11-05','Snehasis','Pargas','M','1996-03-03'),
(238924,'1963-08-02','Eckart','Pena','M','1989-06-14'),
(238942,'1959-04-12','Stella','Conti','M','1990-07-19'),
(239017,'1963-07-28','Ronnie','Androutsos','F','1991-12-02'),
(239018,'1962-04-13','Kendra','Rosen','F','1987-10-14'),
(239156,'1961-04-15','Heejo','Nivat','M','1992-09-06'),
(239234,'1963-09-22','Isaac','Beidas','F','1987-01-26'),
(239243,'1955-02-05','Neven','Leuchs','F','1995-09-12');


INSERT INTO `employees` VALUES (239859,'1955-12-18','Adam','Keirsey','F','1986-09-18'),
(239869,'1960-09-15','Mark','Savasere','F','1992-11-04'),
(239949,'1962-08-21','Zhiwei','Aamodt','F','1990-11-26'),
(239990,'1962-01-08','Danil','Kulisch','F','1992-09-01'),
(240051,'1961-09-01','Kaijung','Androutsos','M','1985-05-25'),
(240349,'1963-06-11','Maja','Greenaway','M','1998-01-07'),
(240692,'1959-04-23','Tru','Ranze','M','1986-02-08'),
(241277,'1958-01-14','Rosalie','Luke','M','1995-11-19'),
(241506,'1964-07-04','Ute','Lunt','M','1987-09-18'),
(241576,'1957-11-26','LiMin','Nannarelli','M','1990-09-06');


INSERT INTO `employees` VALUES (242014,'1955-11-12','Conor','Wilharm','F','1985-03-07'),
(242432,'1961-08-01','Kristine','Esteva','F','1985-10-29'),
(242634,'1959-07-08','Mamdouh','Marzano','M','1995-08-13'),
(242711,'1959-08-12','Nigel','Jiang','M','1992-01-04'),
(242764,'1963-09-24','Jasminko','Cesareni','F','1996-06-11'),
(243072,'1964-03-23','Sungwon','Wielonsky','M','1991-10-24'),
(243329,'1953-11-17','Arco','Sluis','F','1990-02-25'),
(243794,'1960-04-26','Serge','Straney','M','1989-11-25'),
(243944,'1957-06-25','Masanao','Merel','M','1987-09-11'),
(244170,'1955-10-08','Ult','Gente','F','1989-12-20');


INSERT INTO `employees` VALUES (244809,'1964-09-24','Adil','Tsunoo','F','1996-11-28'),
(244820,'1965-01-15','Shigenori','Hertweck','F','1987-04-13'),
(244941,'1963-03-22','Mircea','Halloran','F','1990-03-17'),
(245036,'1961-06-12','Arlette','Gadepally','F','1990-03-21'),
(245367,'1962-11-06','Shaibal','Erdmenger','M','1990-09-16'),
(245660,'1955-02-04','Petter','Chiola','M','1989-02-06'),
(245714,'1960-12-12','Vatsa','Montresor','M','1987-02-23'),
(245810,'1956-07-01','Eran','Kitai','F','1986-03-08'),
(245828,'1960-02-27','King','Lalonde','M','1997-09-26'),
(245862,'1963-08-20','Hidde','Mitzlaff','M','1986-12-02');


INSERT INTO `employees` VALUES (245978,'1955-07-22','Mabo','Khalid','F','1993-06-24'),
(246013,'1958-02-13','Moie','Goldhammer','F','1987-10-28'),
(246044,'1956-11-25','Sudharsan','Cannane','F','1992-10-09'),
(246214,'1964-09-01','Hilary','Terkki','M','1996-08-04'),
(246317,'1962-02-07','Adly','Olano','M','1995-12-26'),
(246597,'1959-03-18','Kristen','Ducloy','M','1996-01-09'),
(247697,'1954-08-15','Tesuro','VanScheik','M','1989-07-16'),
(248201,'1964-12-07','Zhilian','Worfolk','F','1991-04-01'),
(248265,'1952-03-24','Alain','Hegner','M','1997-12-14'),
(248348,'1959-05-11','Randi','Wilfing','M','1988-10-28');


INSERT INTO `employees` VALUES (248761,'1954-02-25','Marin','Lores','M','1994-06-13'),
(249051,'1964-05-31','Quingbo','Talmor','F','1993-03-13'),
(249391,'1956-09-09','Tesuya','Chappelet','M','1988-06-14'),
(249528,'1954-11-24','Bader','Spataro','F','1988-05-23'),
(249779,'1959-05-06','Breannda','Matzel','M','1990-01-16'),
(250401,'1962-09-25','Keung','Bonifati','F','1992-12-14'),
(250645,'1952-06-27','Munenori','Eugenio','M','1989-07-28'),
(250986,'1963-11-26','Ioana','Vakili','M','1989-02-25'),
(251025,'1956-09-13','Noritoshi','Guenter','F','1996-05-29'),
(251085,'1955-03-09','Ronnie','Vecchio','M','1987-09-14');


INSERT INTO `employees` VALUES (251291,'1952-02-12','Uma','Monarch','F','1986-06-19'),
(251698,'1958-09-13','Mitsuyuki','Vidal','M','1994-07-15'),
(252679,'1956-09-27','Val','Juneja','M','1985-09-21'),
(252995,'1958-01-07','Shushma','Keustermans','M','1997-11-19'),
(253139,'1962-09-18','Lucian','Hennings','F','1991-04-12'),
(253685,'1962-05-01','Xiahua','Kroft','M','1995-07-20'),
(253785,'1955-03-05','Eckart','Smailagic','M','1987-02-16'),
(253854,'1956-08-15','Weidon','Gronowski','F','1987-11-07'),
(254240,'1961-06-29','Heejo','Swen','M','1995-12-18'),
(254984,'1963-12-26','Constantine','Gluchowski','M','1987-05-16');


INSERT INTO `employees` VALUES (255294,'1955-11-18','Martial','Llado','M','1994-09-03'),
(255536,'1953-05-28','Kerryn','Kragelund','F','1991-12-10'),
(255874,'1960-02-23','Randi','Poujol','F','1987-12-25'),
(256447,'1959-07-03','Huican','Hitomi','F','1989-07-30'),
(256505,'1957-06-07','Shooichi','Qiwen','M','1992-06-30'),
(256535,'1954-10-21','Yechiam','Danecki','F','1987-12-15'),
(256936,'1952-04-25','Maha','Redmiles','F','1986-10-02'),
(256982,'1964-01-10','Lijie','Baez','F','1985-08-25'),
(257260,'1959-06-11','Hairong','Malinowski','F','1994-04-24'),
(257431,'1963-10-17','Premsyl','Cyne','F','1991-05-12');


INSERT INTO `employees` VALUES (257760,'1959-03-13','Bernd','Templeman','F','1987-07-21'),
(258092,'1961-10-17','Juyoung','Walston','M','1992-10-28'),
(258451,'1955-02-09','Nahla','Menhardt','M','1986-01-28'),
(258582,'1956-07-16','Luisa','Gronowski','M','1985-09-01'),
(259273,'1965-01-22','Xiahua','Gomatam','F','1989-12-01'),
(259293,'1957-12-27','Jongsuk','Fontan','F','1996-12-23'),
(259407,'1958-09-04','Odinaldo','Zaccaria','M','1986-10-14'),
(259983,'1956-02-24','Magdalena','Biros','M','1987-01-21'),
(260083,'1965-01-16','Kwok','Journel','F','1995-11-07'),
(260287,'1956-07-05','Salvador','Herath','F','1985-11-05');


INSERT INTO `employees` VALUES (260516,'1952-07-10','Hidekazu','Byoun','M','1985-08-31'),
(260734,'1953-07-27','Eckart','Leuchs','F','1993-03-14'),
(261201,'1958-11-20','Berry','Trachtenberg','M','1986-03-08'),
(261253,'1963-09-08','Adin','Kriebel','M','1991-11-16'),
(261592,'1955-08-28','Takushi','Kolinko','M','1996-01-28'),
(262130,'1964-02-27','Wuxu','Dengi','F','1987-11-11'),
(262725,'1955-03-26','Miyeon','Schiettecatte','M','1986-07-24'),
(262898,'1953-10-30','Susuma','Shihab','M','1985-08-30'),
(263049,'1961-10-30','Sreekrishna','Demos','M','1990-06-26'),
(263405,'1954-02-06','Marsja','Munos','M','1990-10-19');


INSERT INTO `employees` VALUES (263531,'1958-02-23','Morrie','Verhoeff','M','1994-02-23'),
(264395,'1957-12-24','Shaleah','Merlo','M','1989-10-31'),
(264433,'1957-03-24','Krisda','Papsdorf','M','1996-05-21'),
(264558,'1959-03-07','Narain','Fordan','F','1986-07-24'),
(264698,'1964-06-29','Nakhoon','McFarlan','F','1989-08-03'),
(264873,'1960-10-07','Shigeichiro','Highland','F','1987-09-16'),
(264957,'1956-04-28','Vugranam','Kowalchuk','F','1989-08-03'),
(265364,'1953-03-23','Cristinel','Stavenow','M','1992-08-15'),
(265414,'1956-01-24','Leucio','Murrill','M','1993-05-01'),
(265743,'1956-02-15','Khatoun','Lunn','M','1988-06-29');


INSERT INTO `employees` VALUES (265844,'1958-09-08','Shooichi','Zschoche','M','1989-01-26'),
(265997,'1955-03-10','Shen','Otillio','M','1991-09-26'),
(266331,'1961-10-26','Aron','Unni','F','1985-11-17'),
(266792,'1960-12-30','Sachar','Pelc','F','1994-11-07'),
(267595,'1954-08-27','Sanjeeva','Redmiles','F','1986-05-02'),
(268302,'1960-04-25','Chandrasekaran','Maliniak','F','1991-11-05'),
(268680,'1958-10-09','Selwyn','Ashish','M','1990-01-14'),
(268927,'1964-07-31','Ortrud','Parveen','M','1990-07-12'),
(268956,'1964-12-05','Heeju','Kugler','F','1992-10-13'),
(268965,'1952-05-06','Kiyomitsu','Attimonelli','M','1988-07-12');


INSERT INTO `employees` VALUES (269464,'1955-12-12','Toshimo','Bressoud','M','1989-08-30'),
(269927,'1956-11-02','Henk','Atchley','M','1991-05-29'),
(269993,'1954-07-09','Taizo','Comte','F','1988-12-20'),
(270041,'1955-11-11','Stafford','Emmerich','M','1990-07-19'),
(270377,'1964-07-23','Tiina','Baby','F','1999-08-29'),
(270989,'1960-12-23','Shaz','Remmers','M','1993-08-07'),
(271337,'1955-09-11','Amabile','Vecchi','M','1989-04-21'),
(271603,'1952-09-23','Szabolcs','Carrere','F','1987-12-17'),
(272079,'1958-09-15','Jaihie','Restivo','M','1996-09-20'),
(272238,'1961-12-30','Ramzi','Kadhim','F','1994-09-28');


INSERT INTO `employees` VALUES (272888,'1962-01-20','Baoqiu','Lamma','M','1989-11-19'),
(273095,'1952-04-27','Souichi','dAstous','F','1994-08-20'),
(273215,'1961-11-27','Satyanarayana','Azuma','M','1985-07-13'),
(273405,'1963-05-29','Yuriy','Nyanchama','M','1988-08-17'),
(273453,'1960-11-05','Marsha','Hoogerwoord','F','1991-09-12'),
(273593,'1953-03-30','Ranga','Tyugu','F','1985-09-02'),
(274036,'1954-11-03','Hongzue','Butner','F','1998-09-08'),
(274136,'1959-04-07','Otilia','Markovitch','M','1996-08-16'),
(274270,'1963-02-08','Ung','Walstra','M','1990-05-27'),
(274725,'1954-05-29','Aral','Molenkamp','F','1990-05-29');


INSERT INTO `employees` VALUES (274855,'1964-06-22','Xiadong','Pardalos','M','1985-08-20'),
(275711,'1954-07-14','Foong','Minakawa','M','1992-01-04'),
(276056,'1954-03-26','Piyawadee','Frezza','M','1988-10-18'),
(276204,'1964-12-12','Khosrow','Ishibashi','F','1986-07-13'),
(276344,'1953-01-20','Mana','Vieri','M','1986-01-26'),
(276448,'1952-04-19','Berna','Capobianchi','M','1996-01-23'),
(276923,'1959-05-17','Paddy','Shigei','M','1994-03-16'),
(277230,'1960-03-11','Elgin','Ramsak','M','1995-08-28'),
(277479,'1962-10-05','Paloma','Llado','M','1985-10-04'),
(277868,'1963-02-09','Zdislav','Ghazalie','M','1985-10-16');


INSERT INTO `employees` VALUES (277937,'1952-11-29','Subir','Biros','M','1986-12-26'),
(278168,'1954-04-05','Weicheng','Horswill','M','1988-06-06'),
(278325,'1957-01-06','Lubomir','Engberts','F','1988-03-29'),
(278365,'1960-01-22','Uno','Braccini','F','1985-05-30'),
(278411,'1957-09-25','Elrique','Heydon','M','1988-05-25'),
(278604,'1958-05-13','Cordelia','Alpin','F','1994-04-17'),
(278879,'1961-02-17','Navin','Luce','F','1995-12-10'),
(279744,'1953-09-10','Hein','Werthner','M','1991-02-23'),
(280203,'1961-05-09','Eckart','Yurov','F','1991-12-04'),
(280307,'1961-03-02','Srinidhi','Pietrzykowski','F','1988-12-29');


INSERT INTO `employees` VALUES (280920,'1963-08-01','Sailaja','Vecchio','M','1989-11-16'),
(281215,'1952-11-13','Edwin','Bednarek','M','1990-11-13'),
(282010,'1955-02-08','Ingmar','Dalphin','F','1989-06-15'),
(282407,'1964-08-09','Radhika','Tsukune','M','1987-12-18'),
(282957,'1963-07-01','Zdislav','Rahimi','M','1994-09-08'),
(283297,'1957-09-28','Vishv','Hmelo','M','1985-06-24'),
(283456,'1957-12-28','Radoslaw','Dulli','M','1987-05-21'),
(284077,'1954-03-17','Sahrah','Wilharm','F','1989-06-14'),
(284398,'1960-11-24','Jiann','Kumaresan','M','1992-02-04'),
(284426,'1958-11-03','Zhaofang','Lueh','F','1990-11-18');


INSERT INTO `employees` VALUES (285405,'1963-05-14','Claude','Brendel','F','1995-10-14'),
(285729,'1964-09-18','Mana','Kambil','F','1986-08-19'),
(286006,'1962-02-27','Masoud','Vanwelkenhuysen','F','1985-08-16'),
(286240,'1962-02-26','Mabo','Demian','M','1989-06-08'),
(287571,'1964-07-01','Kristin','Stenning','M','1986-07-09'),
(287914,'1963-09-01','Reuven','Chiola','M','1986-09-27'),
(288184,'1957-04-07','Seongbin','Vigier','F','1986-11-01'),
(289181,'1957-02-24','Spyrose','Lipner','M','1987-02-12'),
(289576,'1959-09-16','Anneli','Vural','M','1990-01-21'),
(289652,'1962-12-07','Niteen','Lorie','F','1988-05-10');


INSERT INTO `employees` VALUES (289766,'1957-09-21','Maja','Jarecki','F','1998-11-21'),
(289866,'1956-11-25','Pintsang','Granlund','M','1989-12-16'),
(290282,'1962-11-08','Bangqing','Bardell','F','1989-05-19'),
(290932,'1963-12-03','Kiam','Deville','M','1988-01-26'),
(291158,'1956-02-20','Xuedong','Broder','M','1997-02-22'),
(291253,'1959-04-09','Salvador','Rassart','M','1987-10-11'),
(293383,'1962-12-08','Toshimori','Percebois','M','1987-01-16'),
(293448,'1964-12-18','Bedir','Daescu','M','1987-02-10'),
(293551,'1961-08-12','Bader','Danner','F','1986-04-18'),
(293714,'1954-04-26','Gudjon','Cmelik','M','1994-03-28');


INSERT INTO `employees` VALUES (294057,'1964-10-01','Saeed','Kropp','F','1986-12-12'),
(294261,'1962-08-11','Uli','Emiris','M','1987-07-10'),
(295573,'1952-12-15','Macha','Ramsay','F','1985-10-11'),
(295755,'1963-01-20','Tonny','Kakkar','F','1989-04-02'),
(296014,'1955-07-01','Yuriy','Bach','F','1998-09-16'),
(296500,'1959-06-24','Martins','Lieberherr','F','1991-12-25'),
(296744,'1963-07-16','Beshir','Gulik','M','1985-08-21'),
(297742,'1952-12-04','Mari','Hofstetter','M','1985-12-06'),
(298437,'1960-12-13','Demin','Attimonelli','F','1990-01-26'),
(298667,'1956-05-17','Rosalyn','Rothe','M','1998-10-20');


INSERT INTO `employees` VALUES (298675,'1954-08-06','Xiaopeng','Tomescu','F','1990-09-29'),
(298735,'1952-02-02','Mamdouh','Gischer','M','1986-07-24'),
(298747,'1953-12-25','Weijing','Gihr','F','1989-05-23'),
(298757,'1958-08-19','Yuguang','Brlek','F','1988-06-28'),
(298919,'1963-08-05','Shay','Pettey','F','1985-02-20'),
(299167,'1956-10-03','Rafols','Neimat','M','1988-09-09'),
(299210,'1956-05-25','Georgi','Boreale','F','1993-07-10'),
(299271,'1957-02-14','Divine','Heystek','F','1989-04-13'),
(299403,'1956-10-30','Lenore','Scharstein','F','1996-10-16'),
(299405,'1954-01-11','Werner','Acton','M','1988-07-19');


INSERT INTO `employees` VALUES (299850,'1953-09-25','Ranan','Spieker','M','1988-03-09'),
(400054,'1955-02-23','Kazuhisa','Backhouse','M','1995-02-08'),
(400538,'1958-07-13','Elgin','Pena','M','1997-07-29'),
(400763,'1954-11-29','Elvis','Eterovic','M','1990-04-05'),
(400796,'1965-01-10','Bodo','Halevi','F','1993-11-20'),
(401085,'1953-10-07','Weiye','Brobst','M','1987-05-18'),
(401291,'1956-05-03','Moni','Tempesti','M','1987-11-02'),
(401704,'1954-09-01','Alair','Sooriamurthi','M','1991-05-22'),
(401929,'1955-11-21','Yolla','Ramras','F','1985-03-02'),
(402392,'1958-02-02','Diederik','Maccarone','M','1995-03-21');


INSERT INTO `employees` VALUES (403849,'1959-08-08','Licheng','Botman','M','1988-07-10'),
(404174,'1960-11-16','Masamitsu','Heyers','F','1995-07-31'),
(404441,'1958-12-06','Karlis','Usdin','F','1992-10-01'),
(404669,'1953-06-15','Breannda','Soicher','F','1994-09-18'),
(406556,'1955-11-23','Remmert','Peot','M','1987-11-20'),
(407401,'1964-05-20','George','Makrucki','M','1986-04-02'),
(407481,'1952-05-26','Kshitij','Bellmore','F','1991-01-12'),
(407937,'1955-07-05','Sungwon','Akaboshi','M','1992-03-21'),
(408371,'1952-07-12','Felicidad','Nishimukai','M','1986-11-13'),
(408886,'1954-12-05','Boguslaw','Erni','F','1985-11-19');


INSERT INTO `employees` VALUES (409162,'1954-02-02','Nevio','Narwekar','M','1988-07-22'),
(409376,'1953-09-24','Petter','Morrey','M','1997-12-13'),
(409509,'1960-02-14','Ziya','Raczkowsky','M','1988-03-01'),
(409522,'1953-11-07','Gadiel','Cheshire','F','1985-04-26'),
(409928,'1958-03-18','Guoxiang','Horswill','F','1993-05-20'),
(410062,'1952-12-27','Lucien','Syang','M','1991-01-24'),
(410236,'1953-01-23','Guther','Fujisaki','M','1988-01-05'),
(410301,'1955-04-19','Atilio','Hofstetter','F','1993-12-21'),
(410949,'1960-11-29','Nirmal','Lieblein','F','1991-11-04'),
(411006,'1961-11-27','Saeko','Conte','M','1987-02-15');


INSERT INTO `employees` VALUES (411065,'1960-02-22','Udaiprakash','Blokdijk','M','1991-05-11'),
(411670,'1955-08-25','Falguni','Emiris','F','1992-12-04'),
(411880,'1960-08-12','Roddy','Cairo','M','1997-07-08'),
(411954,'1959-07-01','Olivera','Schach','F','1996-07-27'),
(411998,'1954-10-06','Shiv','Molenaar','M','1993-09-09'),
(412876,'1961-06-19','Godehard','Conta','F','1992-01-02'),
(413034,'1960-12-07','Stabislas','Barvinok','M','1988-11-30'),
(413054,'1963-09-02','Panayotis','Haldar','M','1997-12-16'),
(413061,'1959-03-16','Aram','Kuhnemann','M','1985-04-04'),
(413215,'1962-07-08','Ronghao','Molberg','F','1985-06-20');


INSERT INTO `employees` VALUES (413392,'1954-12-04','Xiadong','Henders','M','1990-04-27'),
(413675,'1964-05-02','Bernt','Litecky','F','1987-03-22'),
(413880,'1959-09-07','Takushi','Azevdeo','M','1988-10-23'),
(414068,'1957-09-25','Zhiwei','Hennings','M','1987-12-05'),
(414091,'1965-01-17','Wuxu','Kuhnemann','M','1985-11-18'),
(414156,'1957-03-02','Samphel','Fabrizio','M','1990-09-22'),
(414922,'1965-01-20','Prasadram','Piazza','M','1987-06-05'),
(415340,'1958-06-08','Pohua','Erdmenger','F','1991-08-03'),
(415511,'1963-12-26','Kristine','Hiltgen','M','1986-06-11'),
(415796,'1955-08-13','Rance','Foote','F','1988-02-16');


INSERT INTO `employees` VALUES (415832,'1961-02-25','Arnd','Gammage','M','1992-07-01'),
(416009,'1959-05-13','Oldrich','Staylopatis','F','1988-05-04'),
(416137,'1956-05-18','Sanjai','Pagter','M','1996-02-16'),
(416636,'1956-12-02','Roded','Lorho','M','1993-03-24'),
(417262,'1957-12-09','Adib','Neimat','M','1987-06-20'),
(417486,'1955-04-07','Sakthirel','Cusworth','M','1987-01-10'),
(417525,'1964-01-31','Arch','Attimonelli','M','1988-02-11'),
(417812,'1960-01-08','Lene','Broomell','M','1988-07-08'),
(417961,'1954-10-27','Junichi','Lienhardt','F','1986-07-28'),
(418171,'1955-09-06','Aiichiro','Angelopoulos','F','1992-08-08');


INSERT INTO `employees` VALUES (419663,'1954-03-15','Vatsa','Ananiadou','M','1991-02-25'),
(419770,'1955-03-16','Tadahiro','Weedman','M','1988-04-11'),
(419925,'1960-01-02','Ziya','Parascandalo','M','1991-02-11'),
(420207,'1959-08-24','Neelam','Pappas','M','1992-04-05'),
(420252,'1962-12-05','Shunichi','Bridgland','F','1985-07-15'),
(420410,'1963-04-04','Lansing','Krone','F','1990-04-04'),
(420997,'1953-01-17','Maik','Gill','M','1985-07-30'),
(421163,'1960-10-02','Nimmagadda','Kambil','M','1989-11-27'),
(421184,'1953-04-26','Maia','Demizu','F','1990-08-20'),
(421309,'1961-10-25','King','Stanger','M','1988-02-16');


INSERT INTO `employees` VALUES (421547,'1952-02-02','Rasiah','Sudkamp','M','1988-04-30'),
(421753,'1963-01-03','Giordano','Moffat','M','1986-01-04'),
(421822,'1954-09-09','Mario','Rodham','M','1988-04-14'),
(422051,'1956-07-17','Mark','Baaz','F','1988-10-20'),
(422053,'1957-01-23','Arto','Tsunoo','M','1990-07-24'),
(422871,'1962-03-15','Nalini','Collette','M','1991-08-11'),
(422875,'1960-09-23','Saddek','Itzigehl','F','1989-01-30'),
(423062,'1964-11-19','Arnd','Hockney','M','1987-01-11'),
(423711,'1962-02-21','Claudi','Haumacher','M','1988-06-27'),
(424207,'1952-11-27','Geoffry','Poulakidas','F','1994-05-15');


INSERT INTO `employees` VALUES (424569,'1965-01-14','Danco','Luff','F','1986-06-13'),
(424598,'1963-10-21','Abdelaziz','Lorcy','M','1993-04-15'),
(424692,'1960-02-14','Sadun','Peres','M','1992-09-07'),
(424806,'1962-06-11','Masaru','Barriga','M','1989-06-27'),
(425308,'1964-06-17','Shietung','Shiratori','M','1986-12-15'),
(425361,'1964-06-16','Shrikanth','Junot','M','1988-07-24'),
(425779,'1953-05-06','Rasiah','Bahk','M','1994-06-06'),
(425970,'1960-01-23','Mitchel','Soicher','M','1996-10-07'),
(426100,'1953-02-17','Zhenbing','Itzigehl','M','1988-01-22'),
(426483,'1960-07-14','Sachem','Gammage','M','1992-10-19');


INSERT INTO `employees` VALUES (427267,'1956-08-07','Mohit','Joslin','M','1989-12-26'),
(427502,'1964-09-29','Bouchung','Kohling','F','1990-01-20'),
(427812,'1961-05-11','Yuguang','Marakhovsky','F','1994-02-02'),
(427918,'1952-05-30','Billie','Llado','M','1985-10-13'),
(428296,'1963-05-24','Masaru','Larfeldt','F','1997-08-15'),
(428342,'1963-07-12','Nirmal','Nooteboom','M','1992-09-17'),
(428479,'1956-12-31','Ronghao','Foong','M','1995-12-26'),
(428505,'1955-04-23','Niranjan','Giveon','M','1990-09-30'),
(428595,'1960-07-03','Cullen','Schade','M','1990-01-31'),
(428772,'1962-01-31','Masako','Eugenio','M','1995-08-15');


INSERT INTO `employees` VALUES (429487,'1954-03-03','Reuven','Waymire','M','1992-01-20'),
(429666,'1960-12-02','Luisa','Giveon','M','1989-02-22'),
(429675,'1962-11-27','Duro','Undy','M','1988-05-05'),
(429710,'1963-10-14','Hyuckchul','Nyanchama','F','1986-11-15'),
(430218,'1964-09-07','Horward','Hagimont','M','1995-09-23'),
(430595,'1954-11-16','Izaskun','Tanemo','M','1994-07-24'),
(430823,'1963-09-15','Ramalingam','Keustermans','M','1985-07-09'),
(430861,'1963-02-01','Baocai','Covnot','M','1993-08-13'),
(430908,'1961-09-23','Kwee','Waeselynck','M','1990-06-23'),
(431599,'1952-11-24','Xiaoshan','Pettit','M','1986-05-22');


INSERT INTO `employees` VALUES (431625,'1963-11-05','Kazuhisa','Iivonen','M','1998-12-17'),
(431732,'1961-12-13','Uriel','Honglei','F','1990-12-05'),
(431795,'1959-08-19','Cristinel','Hartvigsen','M','1990-09-02'),
(431831,'1960-05-14','Randy','Ciolek','F','1989-08-05'),
(432011,'1956-06-29','Perla','Neimat','M','1986-04-19'),
(432089,'1965-01-17','Irena','Gulla','M','1989-12-30'),
(432304,'1963-11-03','Dannz','Worfolk','M','1987-11-08'),
(432591,'1963-08-31','Supot','Werthner','F','1988-01-29'),
(433763,'1961-08-03','Insup','Reutenauer','M','1986-11-24'),
(434095,'1963-04-24','Hatsukazu','Haumacher','F','1992-01-17');


INSERT INTO `employees` VALUES (434948,'1958-08-17','Zdislav','Gill','M','1987-08-31'),
(435178,'1957-09-28','Yongqiao','Hasenauer','F','1989-06-15'),
(435490,'1959-04-23','Zhensheng','Covnot','M','1994-01-29'),
(435942,'1961-05-15','Oscar','Portugali','F','1998-10-04'),
(436169,'1964-01-15','Angus','Gopalakrishnan','F','1988-10-31'),
(436175,'1955-05-07','Martien','Pouyioutas','F','1989-12-03'),
(436326,'1960-04-21','Armond','Dahlbom','F','1993-06-15'),
(436684,'1955-03-07','Alejandra','Molenkamp','M','1988-03-28'),
(437693,'1961-12-16','Ramalingam','Schlenzig','F','1985-08-13'),
(437857,'1963-06-24','Christoper','Ventosa','M','1995-02-23');


INSERT INTO `employees` VALUES (437869,'1957-05-21','Marc','McAffer','M','1993-12-15'),
(438019,'1962-10-15','Arne','Molenkamp','M','1994-01-17'),
(438369,'1955-07-09','Khedija','Jenevein','M','1992-11-20'),
(438435,'1961-08-12','Yishay','Plavsic','F','1987-12-19'),
(438531,'1957-07-24','Duke','Morton','M','1990-01-20'),
(438707,'1952-04-11','Valeri','Albarhamtoshy','M','1996-08-05'),
(438745,'1963-01-04','Shietung','Shokrollahi','M','1987-08-29'),
(439293,'1961-12-29','Juichirou','Chelton','F','1986-08-11'),
(439463,'1955-12-24','Holgard','Luke','F','1990-02-02'),
(439537,'1958-09-27','Jinya','Merel','M','1988-12-12');


INSERT INTO `employees` VALUES (439693,'1961-08-27','Jeong','Kusalik','F','1986-03-20'),
(440249,'1956-01-22','Munehiko','Kavanagh','F','1990-03-08'),
(440546,'1953-03-04','Takushi','Selvestrel','F','1993-03-20'),
(440846,'1962-03-14','Boutros','Ghalwash','F','1988-02-18'),
(441011,'1958-05-09','Perry','Murtha','M','1986-05-24'),
(441307,'1964-08-04','Tooru','Pettis','M','1985-08-11'),
(441907,'1961-04-29','Carrsten','Colorni','M','1988-04-06'),
(442038,'1962-07-06','Tristan','Biran','M','1985-07-20'),
(442184,'1961-04-14','Renee','Tchuente','M','1990-05-19'),
(442333,'1959-11-07','Shounak','Heuter','M','1989-02-12');


INSERT INTO `employees` VALUES (442526,'1963-08-01','Shmuel','Schneeberger','F','1987-07-24'),
(443533,'1954-09-07','Xuedong','Garnick','F','1992-03-11'),
(443582,'1952-07-23','Katsuo','Ernst','F','1991-05-02'),
(443617,'1953-10-10','Hercules','Molberg','M','1986-12-07'),
(443703,'1957-01-03','Mircea','Plesums','M','1985-11-13'),
(443763,'1953-10-23','Erzsebet','Pluym','F','1990-05-21'),
(443787,'1963-08-23','Sugwoo','Orlowski','M','1986-04-01'),
(444254,'1958-04-24','JoAnne','Pollock','F','1988-09-21'),
(444831,'1953-04-16','Fay','Businaro','F','1989-07-24'),
(445023,'1952-12-12','Tadahiro','Dredge','M','1988-07-21');


INSERT INTO `employees` VALUES (445368,'1954-03-20','Bouchung','Noriega','F','1991-03-19'),
(445708,'1958-05-21','Kristen','Pesch','F','1987-07-20'),
(446075,'1956-06-06','Xinyu','Waleschkowski','F','1986-06-07'),
(446124,'1957-03-02','Mingzeng','Rouquie','M','1986-05-05'),
(446345,'1958-01-11','Josyula','Muhling','M','1993-06-19'),
(446396,'1954-03-30','Sadegh','Masada','M','1990-04-13'),
(446552,'1961-02-13','Zhenbing','Burnard','M','1985-02-06'),
(446653,'1962-05-14','Jasminko','Brodie','M','1989-07-13'),
(446753,'1961-06-21','Cristinel','Wallrath','F','1995-10-10'),
(447555,'1964-06-28','Gritta','Msuda','F','1989-09-26');


INSERT INTO `employees` VALUES (447791,'1954-11-15','Huei','Pluym','F','1985-11-21'),
(447950,'1960-11-29','Thanasis','Debuse','M','1988-08-18'),
(447951,'1956-04-10','Francoise','Itschner','M','1988-10-30'),
(448061,'1964-12-01','Conal','Aamodt','F','1985-05-22'),
(448100,'1964-12-08','Baziley','Foote','F','1990-06-23'),
(448258,'1954-12-03','Fatemeh','Rusterholz','F','1988-10-29'),
(448503,'1961-05-23','Christ','Schiettecatte','M','1988-12-29'),
(448842,'1956-01-06','Nevin','DeMori','F','1987-07-14'),
(449084,'1963-10-25','Kolar','Kandlur','F','1985-06-25'),
(449160,'1960-02-08','Erzsebet','Braunmuhl','M','1993-08-07');


INSERT INTO `employees` VALUES (449585,'1957-04-20','Goetz','Rodiger','M','1989-06-09'),
(449950,'1952-03-17','Shen','Rissland','M','1986-04-16'),
(450050,'1956-05-25','Hironobu','Range','M','1989-12-30'),
(450443,'1963-08-13','Yannis','Eugenio','F','1988-04-08'),
(450960,'1962-07-02','Nechama','Zizka','M','1987-10-21'),
(452346,'1953-04-22','Denny','Zielinski','F','1993-10-07'),
(452944,'1958-03-14','Supot','Calkin','M','1995-02-12'),
(453467,'1960-09-02','Shai','Gini','F','1989-05-22'),
(453835,'1956-01-12','Tomofumi','Pollacia','M','1989-06-13'),
(453910,'1958-07-10','Herb','Baba','M','1994-06-03');


INSERT INTO `employees` VALUES (454044,'1961-04-25','Leah','Veccia','M','1991-10-02'),
(454104,'1954-02-24','Karoline','Aloisi','F','1994-09-06'),
(454472,'1964-01-14','Alejandro','Imataki','M','1990-11-21'),
(454591,'1962-03-29','Yinlin','Kornatzky','M','1986-07-01'),
(454592,'1953-03-19','Jixiang','Malinowski','M','1990-07-03'),
(454774,'1954-09-01','Niranjan','Bugrara','M','1986-11-01'),
(455131,'1957-03-24','Miquel','Munch','M','1992-06-27'),
(455592,'1961-10-04','Bojan','Servieres','F','1991-04-18'),
(455801,'1954-07-25','Suzette','Paludetto','M','1985-11-19'),
(455948,'1952-10-23','Xinglin','Guardalben','M','1993-01-18');


INSERT INTO `employees` VALUES (456107,'1962-10-03','Padma','Ouhyoung','F','1991-05-27'),
(456131,'1961-07-10','Marsja','Borstler','F','1994-06-09'),
(456146,'1955-06-16','Giap','Stemann','M','1995-02-01'),
(456688,'1954-03-22','Petter','Apsitis','F','1986-11-30'),
(456982,'1965-01-07','Shounak','Dratva','F','1989-01-05'),
(457307,'1958-07-14','Irene','Servieres','M','1988-09-30'),
(457337,'1965-01-31','Xumin','Beidas','F','1995-04-27'),
(457781,'1960-08-20','Utz','Carrera','F','1992-05-30'),
(457792,'1956-06-29','Vishv','Billawala','F','1989-08-09'),
(458720,'1957-06-03','Mingdong','Simmen','F','1986-02-16');


INSERT INTO `employees` VALUES (458866,'1963-05-26','Gal','Rehfuss','F','1992-09-02'),
(459134,'1956-04-02','Anwar','Grabner','M','1990-03-18'),
(459172,'1965-01-19','Val','Rissanen','F','1986-05-13'),
(459670,'1957-10-23','Ohad','Bazelow','M','1985-11-13'),
(459744,'1959-01-18','Krisda','Morrin','M','1990-02-05'),
(461268,'1963-02-27','Hisao','Anily','F','1990-07-31'),
(461329,'1959-05-23','Bodo','Shiratori','F','1988-08-22'),
(461716,'1963-02-16','Sakthirel','Birrer','M','1991-02-05'),
(462367,'1961-03-14','Mart','Servieres','M','1998-11-24'),
(462427,'1963-05-14','Sailaja','Akaboshi','F','1988-01-16');


INSERT INTO `employees` VALUES (463321,'1962-12-15','Yishai','Millington','M','1991-11-08'),
(463614,'1958-06-18','Danny','Joslin','M','1989-10-19'),
(464625,'1963-06-29','Temple','Ranta','M','1992-08-06'),
(464927,'1954-02-19','Mahendra','Heydon','M','1989-06-05'),
(464955,'1964-08-05','Honglan','Nyrup','M','1994-04-08'),
(465205,'1962-12-04','Michaela','Barinka','M','1987-05-12'),
(465245,'1954-05-17','Giap','Roccetti','M','1985-03-07'),
(465854,'1958-06-12','Shigeaki','Bottner','F','1992-04-27'),
(466137,'1952-12-06','Elgin','Slobodova','F','1992-04-13'),
(466147,'1959-04-16','Kenroku','Coorg','M','1987-05-18');


INSERT INTO `employees` VALUES (466154,'1964-10-17','Shawna','Kakkad','F','1986-02-05'),
(466176,'1960-02-10','Arunachalam','Conry','M','1986-11-11'),
(466224,'1962-10-23','Jaihie','Bugrara','M','1992-09-23'),
(466440,'1952-03-11','Gill','Morton','M','1987-05-16'),
(466771,'1954-10-29','Luigi','Perez','M','1994-03-10'),
(467051,'1964-09-14','Satoru','Ghemri','M','1991-07-20'),
(467114,'1958-10-02','Marlo','Uehara','M','1991-01-04'),
(467978,'1957-02-05','Cheong','Besselaar','M','1987-11-03'),
(468108,'1963-12-04','Stabislas','Pargaonkar','M','1993-02-18'),
(469541,'1959-09-13','Rance','Huxford','F','1993-11-08');


INSERT INTO `employees` VALUES (469772,'1957-08-12','Beshir','Limongiello','M','1994-09-06'),
(470221,'1959-10-01','Marco','Baaz','F','1997-02-21'),
(470837,'1958-06-11','Maria','Staylopatis','F','1996-02-26'),
(471334,'1963-12-10','Erzsebet','Dusink','F','1995-05-11'),
(471535,'1964-06-30','Arlette','Lindenbaum','F','1997-11-27'),
(471787,'1962-06-16','Shuji','Schlenzig','M','1988-08-20'),
(472062,'1957-07-08','Filipp','Herbst','F','1992-09-02'),
(472563,'1957-04-07','Reinhard','Raney','F','1989-03-09'),
(473287,'1953-09-25','Odysseas','Bednarek','M','1986-06-18'),
(473521,'1954-10-05','Malu','Katalagarianos','F','1987-10-26');


INSERT INTO `employees` VALUES (473954,'1955-12-20','Kristin','Bugrara','F','1986-11-19'),
(474064,'1953-11-16','Jeanne','Rathonyi','F','1985-10-06'),
(475036,'1956-03-05','Hidde','Matzke','F','1991-11-17'),
(475725,'1953-03-12','Bokyung','Khalid','F','1987-08-15'),
(476629,'1956-03-02','Minghong','Hertweck','F','1986-02-04'),
(477293,'1963-01-07','Vojin','Mahmud','M','1987-06-16'),
(477384,'1962-07-29','Olivera','Terlouw','F','1987-03-07'),
(478034,'1959-08-08','Boguslaw','Koprowski','F','1988-03-20'),
(478331,'1954-11-26','Shuky','Soicher','M','1990-05-29'),
(478439,'1965-01-15','Yuichiro','Bale','M','1994-12-25');


INSERT INTO `employees` VALUES (478442,'1964-09-12','Jianwen','Hebert','M','1992-04-05'),
(478460,'1964-05-03','Ioana','Monarch','F','1986-11-16'),
(479267,'1956-02-12','Leif','Moffat','F','1991-05-07'),
(479287,'1954-07-31','Emran','Berztiss','M','1988-03-29'),
(479747,'1960-07-01','Kazuhiko','Akazan','M','1991-06-26'),
(480010,'1954-12-08','Marke','Pashtan','F','1992-04-23'),
(480016,'1960-11-09','Shahar','Solovay','F','1985-12-09'),
(480019,'1956-06-15','Masoud','Waschkowski','M','1985-06-07'),
(480923,'1963-06-06','Ferdinand','Sundgren','M','1987-07-01'),
(481107,'1960-04-17','Sanjay','Keohane','M','1985-11-15');


INSERT INTO `employees` VALUES (481113,'1957-12-07','Wanqing','Parveen','M','1988-01-14'),
(481144,'1954-06-01','Pramod','Honglei','F','1986-12-26'),
(481503,'1961-03-13','Jiann','Lamba','M','1992-08-23'),
(481851,'1958-05-01','Mohit','Gire','F','1990-10-24'),
(482133,'1954-02-18','Tremaine','Chartres','M','1989-08-27'),
(482158,'1955-02-19','Arlette','Lipner','M','1989-10-27'),
(482279,'1961-12-09','Theron','Rodham','F','1994-03-03'),
(482347,'1959-04-11','Arvin','Mawatari','F','1992-12-24'),
(482555,'1954-12-03','Hyuncheol','Mansanne','F','1985-11-30'),
(482689,'1958-02-24','Margo','Segond','M','1989-11-04');


INSERT INTO `employees` VALUES (482722,'1963-03-08','Odinaldo','Vernadat','F','1986-08-18'),
(482765,'1952-11-14','Hailing','Nitsche','M','1986-11-20'),
(482786,'1958-04-14','Ottavia','Leuchs','M','1985-03-24'),
(483081,'1956-02-20','Lene','Birge','F','1988-09-15'),
(483171,'1960-12-26','Shunichi','Siochi','F','1988-11-14'),
(483399,'1960-08-24','Chaitali','Wixon','M','1986-09-13'),
(483624,'1964-09-29','Bernardo','Mersereau','F','1986-03-23'),
(483791,'1955-09-23','Divine','Felder','F','1990-09-16'),
(484242,'1953-07-09','Shawna','Lunt','F','1989-07-22'),
(484451,'1964-04-12','Evgueni','Iivonen','F','1989-12-18');


INSERT INTO `employees` VALUES (484460,'1958-11-23','Fayez','Shumilov','F','1988-12-26'),
(484778,'1954-10-21','Jeanne','Bugaenko','F','1995-04-08'),
(484889,'1962-10-01','Gay','Dichev','M','1986-08-02'),
(485483,'1961-12-29','Brendon','Alblas','M','1993-11-29'),
(485682,'1963-11-11','Alejandro','Candan','M','1995-04-04'),
(485905,'1958-11-09','Fumiko','Dymetman','M','1988-11-11'),
(486022,'1957-09-23','Xinyu','Zaccaria','M','1988-09-12'),
(486306,'1955-08-10','DAIDA','Peyn','M','1994-11-19'),
(487218,'1960-12-08','Khoa','Lorcy','M','1986-11-07'),
(487252,'1963-03-22','Patricio','McAffer','F','1988-02-27');


INSERT INTO `employees` VALUES (487925,'1958-04-12','Zvonko','Picht','M','1994-08-31'),
(488231,'1963-02-03','Iara','Luga','F','1995-02-24'),
(488385,'1956-01-08','Ulf','Serra','F','1988-05-27'),
(488504,'1958-10-02','Boaz','Smailagic','M','1998-05-12'),
(488538,'1959-11-25','Jackson','Pargaonkar','F','1994-06-27'),
(488774,'1953-09-26','Kamakshi','Plumb','F','1994-05-14'),
(488997,'1964-03-01','Leaf','Schueller','M','1987-09-10'),
(489215,'1953-11-10','Conrado','Ritcey','F','1986-07-02'),
(489339,'1962-03-25','Ebru','Esposito','F','1988-05-23'),
(489378,'1956-07-29','Yakkov','Hiraishi','M','1985-11-15');


INSERT INTO `employees` VALUES (489404,'1962-09-13','Hauke','Swist','M','1993-07-09'),
(489514,'1957-03-07','Nevin','Sinitsyn','M','1988-08-15'),
(489658,'1961-01-22','Van','Gide','M','1985-09-23'),
(490024,'1960-12-10','Margareta','Melton','F','1991-11-28'),
(490025,'1956-06-25','Aluzio','Lung','F','1986-03-07'),
(490095,'1959-08-18','Holgard','Siprelle','F','1992-03-28'),
(490155,'1953-01-01','Kenroku','Tchuente','F','1985-06-07'),
(490390,'1957-12-12','Kwun','Pillow','F','1988-01-01'),
(490647,'1959-01-25','Ziya','Pauthner','F','1992-02-09'),
(490747,'1964-11-18','Shahid','Irland','F','1993-05-10');


INSERT INTO `employees` VALUES (491048,'1953-01-22','Rimon','Karnin','M','1992-06-14'),
(491358,'1963-07-10','Pragnesh','Heystek','F','1992-10-31'),
(491370,'1961-06-18','Niranjan','Schwaller','F','1985-02-02'),
(491978,'1955-02-03','Limsoon','Makinen','F','1985-04-25'),
(492217,'1965-01-16','Heekeun','Verhaegen','M','1991-05-23'),
(492566,'1954-09-11','Susuma','DasSarma','F','1987-04-24'),
(493013,'1953-11-25','Aamer','Nishimukai','M','1991-01-22'),
(493516,'1958-05-22','Nevio','Cannata','F','1985-04-02'),
(494052,'1964-08-22','Kwangsub','Versino','M','1994-05-26'),
(494230,'1960-06-01','Zito','Greenaway','F','1987-07-26');


INSERT INTO `employees` VALUES (494294,'1956-05-18','Kwan','Jeansoulin','F','1990-04-08'),
(495066,'1952-02-02','Barry','Merel','M','1991-07-30'),
(495146,'1956-06-22','Huican','Matzat','M','1988-11-05'),
(495658,'1953-11-30','Herbert','Dichev','F','1995-01-03'),
(495879,'1954-11-28','Aimee','Imataki','F','1989-12-30'),
(496317,'1954-10-10','Ranga','Shokrollahi','M','1989-01-20'),
(496685,'1953-02-23','Valeska','Bonifati','F','1991-04-11'),
(496687,'1956-05-26','Sanjiv','Motley','F','1985-08-16'),
(497341,'1957-03-08','Junichi','Pietrzykowski','M','1987-09-07'),
(497434,'1952-02-21','Shounak','Kalloufi','F','1985-11-21');


INSERT INTO `employees` VALUES (498101,'1957-09-21','Luisa','Fandrianto','F','1988-03-24'),
(498351,'1961-01-17','Barry','Merli','F','1988-06-19'),
(498404,'1963-05-14','Salvador','Plesums','F','1989-03-10'),
(498649,'1953-03-29','Sahrah','Camurati','M','1998-05-23'),
(498741,'1956-04-28','Hercules','Demri','M','1985-12-21'),
(499367,'1962-01-08','Makato','Farris','F','1990-03-30'),
(499762,'1952-08-24','Subhankar','Munawer','M','1985-07-06');



SELECT 'LOADING dept_emp' as INFO;
INSERT INTO `dept_emp` VALUES (10001,'d005','1986-06-26','9999-01-01'),
(10213,'d009','1994-10-06','9999-01-01'),
(10300,'d004','1991-05-17','9999-01-01'),
(10604,'d004','2002-07-29','9999-01-01'),
(10604,'d005','1990-04-07','2002-07-29'),
(10887,'d005','1989-03-17','9999-01-01'),
(11131,'d004','1999-07-14','1999-08-01'),
(11345,'d005','1998-11-25','9999-01-01'),
(11403,'d002','1989-08-03','1993-12-01'),
(11702,'d005','1988-09-18','1995-09-14');


INSERT INTO `dept_emp` VALUES (11859,'d007','1998-07-28','9999-01-01'),
(12908,'d003','1988-09-23','9999-01-01'),
(13092,'d001','1994-05-16','9999-01-01'),
(13408,'d004','1995-07-25','9999-01-01'),
(13771,'d009','1990-05-21','9999-01-01'),
(14102,'d004','1989-04-03','1991-02-21'),
(14884,'d005','1989-06-08','9999-01-01'),
(15070,'d009','1995-08-28','2000-07-16'),
(15323,'d005','1995-06-21','9999-01-01'),
(15323,'d008','1988-04-02','1995-06-21');


INSERT INTO `dept_emp` VALUES (16020,'d001','1990-01-04','9999-01-01'),
(16431,'d008','1985-06-19','9999-01-01'),
(16634,'d009','1990-01-18','9999-01-01'),
(17170,'d007','1988-12-03','9999-01-01'),
(17418,'d005','1997-08-13','9999-01-01'),
(17738,'d004','1990-04-21','1997-12-12'),
(17738,'d006','1997-12-12','9999-01-01'),
(18047,'d005','1994-01-25','2001-09-08'),
(19041,'d008','1998-09-28','2002-03-25'),
(20163,'d007','1991-03-04','9999-01-01');


INSERT INTO `dept_emp` VALUES (20212,'d003','1997-12-27','9999-01-01'),
(20241,'d004','1991-05-12','9999-01-01'),
(20685,'d005','1989-10-23','2000-01-30'),
(20877,'d005','1993-08-04','9999-01-01'),
(21029,'d004','1998-05-25','9999-01-01'),
(22407,'d007','1996-01-20','1998-03-22'),
(22806,'d004','1990-07-06','1993-09-08'),
(22996,'d004','1998-11-22','9999-01-01'),
(23113,'d001','1991-04-06','9999-01-01'),
(23463,'d002','1998-04-02','9999-01-01');


INSERT INTO `dept_emp` VALUES (23561,'d004','1992-02-25','9999-01-01'),
(23913,'d004','1985-07-20','1991-02-15'),
(23913,'d009','1991-02-15','9999-01-01'),
(24139,'d003','1997-08-13','9999-01-01'),
(24210,'d002','1988-01-08','9999-01-01'),
(24471,'d009','1996-01-02','9999-01-01'),
(25048,'d009','1988-08-01','9999-01-01'),
(25136,'d002','1993-02-26','1996-06-04'),
(25177,'d007','1990-12-10','9999-01-01'),
(25218,'d005','1998-06-10','1998-08-13');


INSERT INTO `dept_emp` VALUES (25218,'d008','1998-08-13','9999-01-01'),
(25623,'d003','1996-02-06','9999-01-01'),
(26269,'d005','1989-09-17','9999-01-01'),
(26470,'d004','1988-07-13','9999-01-01'),
(26664,'d004','1996-12-27','2002-05-16'),
(26830,'d004','1988-01-23','9999-01-01'),
(26830,'d006','1985-12-19','1988-01-23'),
(27113,'d005','1993-12-01','2001-07-20'),
(27113,'d008','2001-07-20','9999-01-01'),
(28822,'d005','1989-12-17','9999-01-01');


INSERT INTO `dept_emp` VALUES (28890,'d005','1987-05-20','9999-01-01'),
(29240,'d004','1992-11-04','9999-01-01'),
(29409,'d005','1990-11-29','9999-01-01'),
(30058,'d003','1994-03-26','9999-01-01'),
(30303,'d005','1997-02-08','9999-01-01'),
(30837,'d005','1991-08-27','9999-01-01'),
(30899,'d007','1989-08-23','9999-01-01'),
(30917,'d004','1995-07-06','9999-01-01'),
(31093,'d004','1989-08-20','9999-01-01'),
(31107,'d007','1996-02-03','9999-01-01');


INSERT INTO `dept_emp` VALUES (31533,'d007','1988-12-21','9999-01-01'),
(31931,'d002','1985-09-02','9999-01-01'),
(32565,'d005','1988-05-25','1990-05-16'),
(32781,'d004','1999-05-17','9999-01-01'),
(32884,'d006','1997-01-05','9999-01-01'),
(33115,'d005','1988-11-28','9999-01-01'),
(33272,'d005','1989-09-02','9999-01-01'),
(33864,'d007','1998-04-15','9999-01-01'),
(34026,'d005','1989-01-21','1990-09-26'),
(34113,'d005','1988-08-10','1996-06-13');


INSERT INTO `dept_emp` VALUES (34230,'d007','1993-06-02','2001-02-22'),
(34703,'d004','1989-01-09','9999-01-01'),
(36290,'d004','1988-04-23','1995-01-12'),
(36290,'d006','1995-01-12','9999-01-01'),
(36329,'d005','1995-04-08','9999-01-01'),
(36329,'d008','1992-04-26','1995-04-08'),
(36364,'d009','1997-11-27','9999-01-01'),
(36523,'d006','1997-10-17','9999-01-01'),
(36634,'d002','1992-08-26','9999-01-01'),
(36937,'d003','1998-09-08','9999-01-01');


INSERT INTO `dept_emp` VALUES (37060,'d008','1985-06-10','9999-01-01'),
(37308,'d007','1993-10-13','9999-01-01'),
(38107,'d007','1986-03-04','1989-09-04'),
(38107,'d009','1989-09-04','9999-01-01'),
(38402,'d005','1999-12-03','9999-01-01'),
(38419,'d007','1985-09-19','9999-01-01'),
(38588,'d004','1997-03-12','9999-01-01'),
(38588,'d008','1995-12-24','1997-03-12'),
(39328,'d004','1998-05-22','9999-01-01'),
(39423,'d004','1995-10-13','9999-01-01');


INSERT INTO `dept_emp` VALUES (39822,'d005','1988-04-18','9999-01-01'),
(39822,'d006','1986-07-12','1988-04-18'),
(39972,'d004','1988-09-08','9999-01-01'),
(40370,'d004','1988-08-12','9999-01-01'),
(40370,'d005','1988-07-03','1988-08-12'),
(40663,'d004','1996-10-22','9999-01-01'),
(40742,'d002','1998-06-17','2000-05-13'),
(40867,'d003','1993-01-18','9999-01-01'),
(41268,'d005','1998-08-22','9999-01-01'),
(41579,'d005','1999-07-14','9999-01-01');


INSERT INTO `dept_emp` VALUES (41779,'d005','1995-10-13','9999-01-01'),
(41960,'d007','1994-04-22','9999-01-01'),
(42646,'d005','1989-04-03','1990-02-28'),
(43307,'d004','1992-07-07','9999-01-01'),
(43569,'d004','1996-10-12','9999-01-01'),
(43675,'d004','1993-01-18','9999-01-01'),
(44259,'d002','1996-07-08','9999-01-01'),
(44702,'d001','1996-08-06','9999-01-01'),
(44702,'d007','1988-01-28','1996-08-06'),
(45338,'d004','1991-12-07','9999-01-01');


INSERT INTO `dept_emp` VALUES (45632,'d004','1993-09-23','9999-01-01'),
(45873,'d007','1993-07-07','1996-01-27'),
(45873,'d009','1996-01-27','9999-01-01'),
(45925,'d005','1997-03-01','2000-08-21'),
(45976,'d007','1989-03-25','2002-07-30'),
(46067,'d005','1989-11-19','9999-01-01'),
(46154,'d004','1994-01-05','1996-01-24'),
(46154,'d006','1996-01-24','9999-01-01'),
(46288,'d007','1992-06-07','9999-01-01'),
(46397,'d004','1999-10-31','9999-01-01');


INSERT INTO `dept_emp` VALUES (46397,'d005','1998-06-27','1999-10-31'),
(46467,'d002','1991-02-08','1993-06-16'),
(46601,'d007','1998-09-13','9999-01-01'),
(46687,'d005','1990-08-30','9999-01-01'),
(47150,'d004','1991-02-25','9999-01-01'),
(47221,'d004','1987-02-13','9999-01-01'),
(47319,'d002','1987-03-21','1988-04-08'),
(47319,'d007','1988-04-08','1991-07-03'),
(47436,'d005','1996-09-13','9999-01-01'),
(47440,'d009','1989-11-12','1993-04-15');


INSERT INTO `dept_emp` VALUES (48034,'d005','1989-05-19','9999-01-01'),
(48183,'d001','1997-09-19','9999-01-01'),
(48410,'d007','1997-03-26','9999-01-01'),
(48841,'d005','1998-12-06','9999-01-01'),
(49232,'d007','1985-12-25','9999-01-01'),
(49356,'d007','1996-10-06','9999-01-01'),
(49450,'d004','2000-12-14','9999-01-01'),
(49450,'d005','1998-05-17','2000-12-14'),
(49524,'d007','1998-08-20','9999-01-01'),
(49845,'d007','1989-11-13','9999-01-01');


INSERT INTO `dept_emp` VALUES (50624,'d005','1988-12-14','9999-01-01'),
(51292,'d002','1998-10-03','9999-01-01'),
(51292,'d003','1994-09-10','1998-10-03'),
(51314,'d009','1991-10-02','9999-01-01'),
(51403,'d003','1997-02-16','2000-09-21'),
(51834,'d006','1997-09-04','9999-01-01'),
(52002,'d006','1990-03-05','9999-01-01'),
(52109,'d007','1985-04-09','9999-01-01'),
(52175,'d004','1993-04-21','1996-11-28'),
(52175,'d006','1996-11-28','9999-01-01');


INSERT INTO `dept_emp` VALUES (52246,'d005','1989-04-06','9999-01-01'),
(52566,'d005','1998-05-29','9999-01-01'),
(52943,'d004','1999-09-03','9999-01-01'),
(52983,'d004','1985-11-23','9999-01-01'),
(54013,'d003','1994-07-21','9999-01-01'),
(54458,'d007','1999-03-31','9999-01-01'),
(54660,'d002','1994-03-20','9999-01-01'),
(54886,'d004','1996-10-03','1999-10-01'),
(54908,'d005','1988-04-05','1996-07-10'),
(55125,'d002','1992-11-30','1995-04-14');


INSERT INTO `dept_emp` VALUES (55437,'d004','1987-03-04','9999-01-01'),
(55581,'d002','1993-11-08','9999-01-01'),
(56169,'d004','1997-01-28','9999-01-01'),
(57385,'d001','1995-05-20','2001-07-12'),
(57385,'d009','2001-07-12','9999-01-01'),
(57663,'d004','1990-01-13','9999-01-01'),
(57838,'d001','1999-02-14','9999-01-01'),
(57882,'d001','1988-12-28','9999-01-01'),
(58391,'d009','1997-09-17','9999-01-01'),
(58626,'d002','1999-02-10','1999-12-03');


INSERT INTO `dept_emp` VALUES (58626,'d003','1999-12-03','9999-01-01'),
(58787,'d005','1998-06-10','9999-01-01'),
(58869,'d005','1993-06-17','9999-01-01'),
(58897,'d001','1989-12-09','9999-01-01'),
(58962,'d005','1998-06-30','9999-01-01'),
(59124,'d005','1992-12-31','2002-04-30'),
(59454,'d004','1994-05-12','9999-01-01'),
(60708,'d005','2000-01-24','9999-01-01'),
(60820,'d002','1989-08-15','1995-06-26'),
(60820,'d007','1995-06-26','1996-08-03');


INSERT INTO `dept_emp` VALUES (61333,'d001','1986-11-03','9999-01-01'),
(61600,'d004','1998-07-10','2000-04-11'),
(61600,'d009','2000-04-11','9999-01-01'),
(61613,'d007','1990-01-23','9999-01-01'),
(62027,'d001','1995-12-18','9999-01-01'),
(62278,'d005','1994-09-21','9999-01-01'),
(62419,'d007','1990-07-22','1999-09-03'),
(62620,'d003','1995-08-12','2000-04-14'),
(62695,'d007','1988-01-07','9999-01-01'),
(62705,'d004','1996-09-10','2002-06-24');


INSERT INTO `dept_emp` VALUES (62705,'d006','2002-06-24','9999-01-01'),
(62954,'d008','1987-07-12','9999-01-01'),
(63426,'d004','1986-06-29','9999-01-01'),
(63588,'d007','1988-09-20','9999-01-01'),
(63737,'d005','1995-03-21','1998-09-02'),
(63786,'d003','1986-01-18','9999-01-01'),
(63894,'d005','1998-06-24','2000-09-14'),
(64310,'d004','1992-08-13','9999-01-01'),
(64841,'d007','1986-02-14','1995-10-30'),
(65333,'d004','1988-11-21','9999-01-01');


INSERT INTO `dept_emp` VALUES (65790,'d005','1991-02-12','9999-01-01'),
(65883,'d007','1991-04-19','9999-01-01'),
(66118,'d005','1997-08-16','1999-11-17'),
(66674,'d007','1988-03-05','9999-01-01'),
(66675,'d002','1994-05-12','9999-01-01'),
(66835,'d005','1998-05-21','9999-01-01'),
(67289,'d005','1999-01-02','9999-01-01'),
(67488,'d003','1989-09-18','1996-05-02'),
(68370,'d007','1994-11-21','9999-01-01'),
(68486,'d007','1994-10-16','9999-01-01');


INSERT INTO `dept_emp` VALUES (68651,'d008','1998-04-12','9999-01-01'),
(68655,'d001','2001-07-12','2001-12-21'),
(68655,'d003','1997-09-04','2001-07-12'),
(69487,'d004','1998-06-14','9999-01-01'),
(69815,'d005','1995-05-14','9999-01-01'),
(69974,'d005','1998-09-22','9999-01-01'),
(70049,'d005','1988-05-31','9999-01-01'),
(70059,'d007','1986-09-26','9999-01-01'),
(70176,'d005','1992-08-19','9999-01-01'),
(70473,'d004','1998-01-23','1998-08-18');


INSERT INTO `dept_emp` VALUES (70473,'d009','1998-08-18','9999-01-01'),
(70518,'d004','1995-08-10','9999-01-01'),
(70632,'d005','1988-12-05','9999-01-01'),
(70777,'d003','1997-01-25','9999-01-01'),
(71587,'d007','1993-05-27','9999-01-01'),
(72103,'d008','1985-08-10','9999-01-01'),
(72682,'d004','1988-03-04','9999-01-01'),
(72856,'d004','1988-06-27','9999-01-01'),
(73259,'d004','1986-02-19','9999-01-01'),
(73442,'d005','1989-01-01','9999-01-01');


INSERT INTO `dept_emp` VALUES (73468,'d004','1990-01-10','1990-12-12'),
(73468,'d009','1990-12-12','9999-01-01'),
(73627,'d007','1988-01-09','1999-10-21'),
(73663,'d007','1996-06-03','9999-01-01'),
(75198,'d005','1992-09-21','1993-04-26'),
(75198,'d008','1993-04-26','1996-11-16'),
(75340,'d003','1986-05-18','1993-07-11'),
(75445,'d003','1988-11-02','1996-07-10'),
(75935,'d005','1995-11-24','9999-01-01'),
(76177,'d005','1993-08-28','9999-01-01');


INSERT INTO `dept_emp` VALUES (76190,'d005','1993-09-08','9999-01-01'),
(76207,'d004','1997-11-15','9999-01-01'),
(76366,'d005','1992-11-07','2000-02-06'),
(76366,'d008','2000-02-06','9999-01-01'),
(76736,'d007','1997-05-26','1998-06-21'),
(76819,'d005','1989-03-14','9999-01-01'),
(76914,'d005','1985-07-06','9999-01-01'),
(77315,'d006','1986-04-05','9999-01-01'),
(77697,'d007','1993-08-23','1993-09-10'),
(78588,'d005','1986-08-06','9999-01-01');


INSERT INTO `dept_emp` VALUES (78618,'d004','1988-03-19','9999-01-01'),
(78689,'d004','1999-01-02','9999-01-01'),
(79370,'d004','1993-09-04','1994-02-26'),
(79370,'d006','1994-02-26','9999-01-01'),
(79446,'d004','1988-05-10','9999-01-01'),
(79909,'d005','1996-07-23','2000-11-22'),
(80408,'d004','1998-02-09','9999-01-01'),
(81146,'d003','1992-11-06','9999-01-01'),
(81570,'d006','1987-01-21','9999-01-01'),
(82526,'d004','1985-06-18','9999-01-01');


INSERT INTO `dept_emp` VALUES (82548,'d007','1994-10-22','9999-01-01'),
(83159,'d008','1998-08-19','9999-01-01'),
(83207,'d007','1990-08-21','9999-01-01'),
(83496,'d005','1995-12-31','1996-05-22'),
(84573,'d005','1989-01-29','9999-01-01'),
(84906,'d007','1999-06-24','2001-07-27'),
(85579,'d007','1994-02-27','9999-01-01'),
(85835,'d004','1987-10-08','9999-01-01'),
(86321,'d005','1994-04-14','9999-01-01'),
(87256,'d007','1988-10-19','9999-01-01');


INSERT INTO `dept_emp` VALUES (87370,'d003','1996-04-20','9999-01-01'),
(87644,'d005','1992-06-09','1997-04-02'),
(87907,'d004','1998-04-01','1998-12-21'),
(87907,'d009','1998-12-21','1999-07-26'),
(88114,'d005','1996-03-23','2001-10-11'),
(88148,'d002','1991-09-12','9999-01-01'),
(88223,'d004','1996-01-19','9999-01-01'),
(89079,'d006','1987-03-15','1989-06-04'),
(89549,'d007','1999-02-16','9999-01-01'),
(89747,'d005','1997-05-22','9999-01-01');


INSERT INTO `dept_emp` VALUES (89893,'d006','1986-12-05','9999-01-01'),
(90114,'d001','2001-10-19','9999-01-01'),
(90114,'d003','1999-10-07','2001-10-19'),
(90132,'d007','1995-12-14','9999-01-01'),
(90133,'d002','1998-04-02','2000-09-10'),
(90133,'d003','2000-09-10','9999-01-01'),
(90212,'d007','1986-06-10','1987-11-12'),
(90726,'d005','1998-01-08','9999-01-01'),
(90930,'d001','1989-01-20','9999-01-01'),
(91031,'d004','1994-09-03','9999-01-01');


INSERT INTO `dept_emp` VALUES (91159,'d004','1998-03-30','9999-01-01'),
(91500,'d005','1997-04-13','9999-01-01'),
(91517,'d007','1991-04-30','2001-01-06'),
(91517,'d009','2001-01-06','9999-01-01'),
(92069,'d004','1989-06-04','1994-11-05'),
(92344,'d004','1988-12-19','9999-01-01'),
(92541,'d005','1995-10-16','9999-01-01'),
(92705,'d004','1991-10-10','9999-01-01'),
(92921,'d004','1987-06-04','9999-01-01'),
(93036,'d001','1987-03-24','9999-01-01');


INSERT INTO `dept_emp` VALUES (93445,'d002','1986-06-06','9999-01-01'),
(93466,'d001','1998-09-23','9999-01-01'),
(93708,'d001','1997-07-24','9999-01-01'),
(93877,'d007','1989-11-06','9999-01-01'),
(94319,'d007','1998-03-13','9999-01-01'),
(94699,'d006','1998-07-06','1999-11-09'),
(94716,'d007','1985-07-29','9999-01-01'),
(95198,'d005','1990-11-06','9999-01-01'),
(95278,'d005','1990-02-14','9999-01-01'),
(95670,'d007','1998-06-03','9999-01-01');


INSERT INTO `dept_emp` VALUES (95861,'d003','1999-06-18','9999-01-01'),
(96318,'d001','1985-10-23','9999-01-01'),
(96531,'d005','1992-11-04','9999-01-01'),
(96575,'d007','1987-12-02','9999-01-01'),
(96992,'d004','1992-05-19','9999-01-01'),
(97195,'d008','1997-06-04','1998-05-15'),
(97224,'d005','1985-06-17','9999-01-01'),
(97970,'d005','1993-10-01','9999-01-01'),
(98968,'d004','1988-08-14','1991-08-25'),
(99121,'d002','1990-11-10','9999-01-01');


INSERT INTO `dept_emp` VALUES (99726,'d001','1999-11-27','9999-01-01'),
(99726,'d007','1997-03-07','1999-11-27'),
(100258,'d002','1994-03-21','9999-01-01'),
(101129,'d008','1999-05-04','9999-01-01'),
(101241,'d004','1992-05-11','9999-01-01'),
(101787,'d004','1988-07-28','9999-01-01'),
(101851,'d004','1991-06-26','2001-04-08'),
(102216,'d005','1997-10-27','9999-01-01'),
(102347,'d005','1991-08-03','9999-01-01'),
(102827,'d006','1996-10-23','9999-01-01');


INSERT INTO `dept_emp` VALUES (103621,'d007','1997-10-06','2000-09-16'),
(103621,'d009','2000-09-16','9999-01-01'),
(103666,'d005','1995-07-26','9999-01-01'),
(104037,'d006','1987-11-16','9999-01-01'),
(104080,'d007','1988-10-07','9999-01-01'),
(104402,'d007','1995-06-15','9999-01-01'),
(105153,'d005','1997-12-19','9999-01-01'),
(105279,'d006','1992-08-03','9999-01-01'),
(105337,'d007','1995-06-29','9999-01-01'),
(106201,'d007','1997-04-22','9999-01-01');


INSERT INTO `dept_emp` VALUES (106660,'d004','1989-05-11','9999-01-01'),
(107072,'d008','1989-07-07','9999-01-01'),
(107426,'d004','1998-09-28','9999-01-01'),
(108348,'d004','1990-03-16','9999-01-01'),
(108909,'d004','1999-07-05','9999-01-01'),
(109562,'d008','1996-05-22','9999-01-01'),
(109657,'d004','1987-06-16','9999-01-01'),
(109725,'d004','1990-07-18','9999-01-01'),
(109830,'d005','1997-05-07','9999-01-01'),
(109935,'d005','1994-04-17','9999-01-01');


INSERT INTO `dept_emp` VALUES (200144,'d004','1991-01-02','9999-01-01'),
(200398,'d008','1991-08-02','9999-01-01'),
(200424,'d004','1991-09-08','9999-01-01'),
(200555,'d004','1992-07-15','9999-01-01'),
(200790,'d001','1992-01-21','9999-01-01'),
(200945,'d004','1989-11-05','2002-02-23'),
(201231,'d004','1987-05-17','1991-07-22'),
(201749,'d005','1988-04-07','9999-01-01'),
(201916,'d004','1992-03-30','9999-01-01'),
(203279,'d004','1998-01-05','9999-01-01');


INSERT INTO `dept_emp` VALUES (203279,'d008','1995-01-21','1998-01-05'),
(203690,'d007','1998-09-19','9999-01-01'),
(203957,'d005','1997-07-08','9999-01-01'),
(204224,'d005','1988-04-03','9999-01-01'),
(204262,'d009','1994-04-18','9999-01-01'),
(204377,'d003','1997-01-17','9999-01-01'),
(204498,'d005','1985-04-25','9999-01-01'),
(204609,'d005','1989-03-25','9999-01-01'),
(205437,'d009','1996-08-05','1998-06-14'),
(206699,'d005','1995-06-16','9999-01-01');


INSERT INTO `dept_emp` VALUES (206719,'d007','1989-06-12','9999-01-01'),
(207066,'d005','1988-08-18','9999-01-01'),
(208416,'d005','1993-11-17','2001-01-31'),
(208916,'d008','1993-08-23','2000-05-25'),
(209818,'d005','1995-07-13','9999-01-01'),
(210116,'d004','1987-02-04','9999-01-01'),
(210172,'d007','1999-11-25','2000-07-19'),
(210406,'d005','1991-04-01','9999-01-01'),
(210591,'d004','1993-11-18','9999-01-01'),
(210613,'d005','1998-02-27','9999-01-01');


INSERT INTO `dept_emp` VALUES (210946,'d005','1999-01-25','9999-01-01'),
(211019,'d007','1987-06-30','1996-03-23'),
(211187,'d004','1991-01-19','9999-01-01'),
(211453,'d004','1991-05-09','1992-03-08'),
(211453,'d006','1992-03-08','9999-01-01'),
(211730,'d007','1990-04-27','1995-12-15'),
(211730,'d009','1995-12-15','9999-01-01'),
(212017,'d002','1987-09-01','9999-01-01'),
(212041,'d005','1990-09-15','1993-07-01'),
(212148,'d007','1992-01-15','9999-01-01');


INSERT INTO `dept_emp` VALUES (212276,'d002','1992-10-04','9999-01-01'),
(212297,'d004','1997-04-30','9999-01-01'),
(212862,'d009','1989-01-24','9999-01-01'),
(213423,'d006','1997-02-04','9999-01-01'),
(214113,'d005','1995-09-16','9999-01-01'),
(214252,'d007','1985-08-29','9999-01-01'),
(214605,'d004','1988-05-18','9999-01-01'),
(214711,'d007','1990-09-22','9999-01-01'),
(214963,'d004','1989-03-11','9999-01-01'),
(215016,'d004','1999-10-17','9999-01-01');


INSERT INTO `dept_emp` VALUES (215117,'d009','1994-06-03','9999-01-01'),
(215433,'d005','1992-03-29','9999-01-01'),
(215550,'d007','1988-11-23','1988-12-04'),
(215601,'d009','1998-06-13','9999-01-01'),
(216156,'d002','1988-03-01','9999-01-01'),
(216595,'d005','1999-03-24','9999-01-01'),
(216852,'d002','1992-04-22','9999-01-01'),
(217002,'d004','1992-09-07','9999-01-01'),
(217532,'d007','1999-05-21','9999-01-01'),
(217752,'d004','1990-06-05','1992-06-05');


INSERT INTO `dept_emp` VALUES (217752,'d006','1992-06-05','9999-01-01'),
(217782,'d004','1997-01-04','9999-01-01'),
(217782,'d005','1992-06-02','1997-01-04'),
(217783,'d005','1997-01-22','9999-01-01'),
(217840,'d004','1986-08-24','9999-01-01'),
(218301,'d005','1989-09-28','9999-01-01'),
(219242,'d004','1997-02-13','1997-11-11'),
(219244,'d007','1992-04-22','9999-01-01'),
(219301,'d004','1988-11-01','9999-01-01'),
(219460,'d004','1990-11-25','9999-01-01');


INSERT INTO `dept_emp` VALUES (219460,'d005','1990-01-11','1990-11-25'),
(219998,'d007','1990-10-18','9999-01-01'),
(220007,'d005','1985-12-06','9999-01-01'),
(220063,'d003','1997-10-17','9999-01-01'),
(220622,'d005','1985-08-30','9999-01-01'),
(220844,'d007','1987-01-27','9999-01-01'),
(221223,'d007','1986-08-24','1995-07-20'),
(221336,'d004','2000-11-15','9999-01-01'),
(221336,'d005','1993-02-28','2000-11-15'),
(221957,'d004','1991-07-04','9999-01-01');


INSERT INTO `dept_emp` VALUES (222025,'d004','1992-08-19','1997-08-09'),
(222357,'d007','1997-10-28','2000-08-11'),
(222429,'d005','1994-12-30','9999-01-01'),
(222918,'d009','1987-01-08','9999-01-01'),
(223063,'d005','1996-04-22','9999-01-01'),
(223114,'d007','1999-10-09','9999-01-01'),
(223290,'d006','1998-09-03','9999-01-01'),
(223906,'d007','1996-11-24','9999-01-01'),
(224094,'d004','1994-06-08','9999-01-01'),
(224758,'d004','1996-12-10','2001-08-19');


INSERT INTO `dept_emp` VALUES (225042,'d005','1998-07-26','9999-01-01'),
(225116,'d005','1994-12-01','9999-01-01'),
(225178,'d008','1986-08-18','1992-07-19'),
(225409,'d002','1991-04-27','9999-01-01'),
(225436,'d001','1990-09-03','9999-01-01'),
(225517,'d005','1995-01-18','1999-09-02'),
(225734,'d003','1990-11-10','1992-06-20'),
(225974,'d009','1987-09-25','9999-01-01'),
(226262,'d004','1990-11-24','9999-01-01'),
(226516,'d004','1987-01-05','9999-01-01');


INSERT INTO `dept_emp` VALUES (227299,'d005','1988-06-18','9999-01-01'),
(227376,'d001','1993-08-05','1997-04-06'),
(227537,'d001','1993-02-27','9999-01-01'),
(227761,'d005','1998-06-14','9999-01-01'),
(227830,'d004','1991-09-15','9999-01-01'),
(227894,'d004','1989-06-10','9999-01-01'),
(228005,'d004','1992-08-29','1993-12-29'),
(228005,'d009','1993-12-29','1995-05-07'),
(228051,'d004','1995-11-12','9999-01-01'),
(228051,'d005','1988-12-18','1995-11-12');


INSERT INTO `dept_emp` VALUES (228327,'d001','1989-10-22','9999-01-01'),
(228344,'d005','1999-07-01','2000-09-04'),
(228369,'d005','1998-05-17','9999-01-01'),
(228686,'d006','1998-09-22','9999-01-01'),
(229063,'d004','1991-07-31','9999-01-01'),
(229279,'d004','2001-09-15','9999-01-01'),
(229279,'d008','1998-05-08','2001-09-15'),
(229600,'d003','1987-08-28','2002-03-23'),
(229623,'d006','1998-10-14','9999-01-01'),
(229949,'d002','1994-06-27','9999-01-01');


INSERT INTO `dept_emp` VALUES (230087,'d005','1994-02-18','9999-01-01'),
(230099,'d007','1992-09-24','9999-01-01'),
(230343,'d008','1998-07-28','2002-07-26'),
(230627,'d007','1986-01-29','9999-01-01'),
(230801,'d007','1988-10-22','9999-01-01'),
(230946,'d001','1988-05-18','9999-01-01'),
(231240,'d005','1999-01-18','9999-01-01'),
(231635,'d004','1998-07-19','9999-01-01'),
(231635,'d005','1985-03-21','1998-07-19'),
(231783,'d007','1993-06-07','9999-01-01');


INSERT INTO `dept_emp` VALUES (231789,'d006','1987-01-18','9999-01-01'),
(232238,'d005','1987-10-31','1994-08-09'),
(232305,'d004','1992-09-04','9999-01-01'),
(232347,'d004','1996-03-03','9999-01-01'),
(233523,'d001','1985-03-11','9999-01-01'),
(234320,'d008','1998-03-06','1999-04-03'),
(234321,'d002','1996-08-03','2000-07-26'),
(235427,'d006','1991-03-29','2000-01-02'),
(235867,'d009','1991-06-30','1997-06-25'),
(236372,'d004','1990-05-06','9999-01-01');


INSERT INTO `dept_emp` VALUES (236692,'d008','1996-03-04','9999-01-01'),
(236927,'d007','1996-10-07','2001-08-22'),
(237316,'d002','1992-07-08','2000-01-04'),
(237316,'d007','2000-01-04','9999-01-01'),
(237728,'d002','1992-10-07','1995-03-13'),
(238067,'d004','1988-05-20','1997-07-12'),
(238379,'d005','1994-12-03','9999-01-01'),
(238632,'d007','1992-11-21','2002-04-01'),
(238661,'d009','1997-04-02','1998-06-18'),
(238678,'d001','1991-10-10','1996-10-10');


INSERT INTO `dept_emp` VALUES (238678,'d009','1996-10-10','9999-01-01'),
(238726,'d009','1995-05-28','9999-01-01'),
(238849,'d004','2001-05-03','9999-01-01'),
(238849,'d005','1999-11-23','2001-05-03'),
(238924,'d001','1989-06-14','1997-10-09'),
(238942,'d005','1996-03-28','9999-01-01'),
(239017,'d005','1991-12-02','9999-01-01'),
(239018,'d006','1999-06-08','9999-01-01'),
(239156,'d002','1999-09-06','9999-01-01'),
(239234,'d007','1987-01-26','9999-01-01');


INSERT INTO `dept_emp` VALUES (239243,'d004','1995-09-12','9999-01-01'),
(239859,'d007','1988-10-24','1990-03-30'),
(239859,'d009','1990-03-30','1990-09-11'),
(239869,'d003','1996-06-02','9999-01-01'),
(239949,'d005','1990-11-26','9999-01-01'),
(239990,'d006','1992-09-01','9999-01-01'),
(240051,'d002','1985-05-25','2000-11-16'),
(240349,'d002','1999-06-22','9999-01-01'),
(240692,'d001','1998-08-07','1999-10-13'),
(241277,'d004','1995-11-19','9999-01-01');


INSERT INTO `dept_emp` VALUES (241506,'d008','1987-09-18','9999-01-01'),
(241576,'d004','1990-09-06','9999-01-01'),
(242014,'d004','1985-03-07','9999-01-01'),
(242432,'d008','1985-10-29','9999-01-01'),
(242711,'d005','1992-01-04','9999-01-01'),
(242764,'d005','1998-11-09','9999-01-01'),
(243072,'d005','1991-10-24','2000-09-10'),
(243072,'d008','2000-09-10','9999-01-01'),
(243329,'d004','1992-03-07','2001-09-07'),
(243794,'d004','1989-11-25','1997-01-26');


INSERT INTO `dept_emp` VALUES (243944,'d005','1987-09-11','9999-01-01'),
(244170,'d007','1989-12-20','1995-05-18'),
(244809,'d007','1998-12-06','9999-01-01'),
(244820,'d005','1987-04-13','9999-01-01'),
(244941,'d005','1990-03-17','9999-01-01'),
(245036,'d004','1990-03-21','9999-01-01'),
(245367,'d007','1993-10-27','9999-01-01'),
(245660,'d008','1989-02-06','9999-01-01'),
(245714,'d007','1987-02-23','9999-01-01'),
(245810,'d003','1986-03-08','9999-01-01');


INSERT INTO `dept_emp` VALUES (245828,'d007','1997-09-26','9999-01-01'),
(245862,'d004','1998-06-19','9999-01-01'),
(245978,'d003','1993-06-24','9999-01-01'),
(246013,'d007','1987-10-28','9999-01-01'),
(246044,'d006','1992-10-09','9999-01-01'),
(246214,'d004','1997-05-22','9999-01-01'),
(246317,'d007','1995-12-26','9999-01-01'),
(246597,'d004','1996-01-09','9999-01-01'),
(247697,'d005','1992-11-27','1995-11-11'),
(248201,'d003','1991-04-01','9999-01-01');


INSERT INTO `dept_emp` VALUES (248265,'d005','1999-09-22','2001-02-15'),
(248348,'d006','1988-10-28','9999-01-01'),
(248761,'d006','1994-06-13','9999-01-01'),
(249051,'d003','1993-03-13','9999-01-01'),
(249391,'d003','1998-02-12','9999-01-01'),
(249528,'d005','1988-05-23','9999-01-01'),
(249779,'d004','1990-01-16','9999-01-01'),
(250401,'d007','1992-12-14','1997-01-23'),
(250645,'d007','1989-07-28','9999-01-01'),
(250986,'d004','1989-02-25','9999-01-01');


INSERT INTO `dept_emp` VALUES (251025,'d004','1996-05-29','9999-01-01'),
(251085,'d005','1987-09-14','9999-01-01'),
(251291,'d003','1986-06-19','2001-03-01'),
(251698,'d004','1995-04-13','9999-01-01'),
(252679,'d005','1985-09-21','9999-01-01'),
(252995,'d004','2001-12-05','9999-01-01'),
(252995,'d005','1999-01-18','2001-12-05'),
(253139,'d004','1997-06-24','9999-01-01'),
(253685,'d004','1999-03-19','9999-01-01'),
(253785,'d007','1987-02-16','9999-01-01');


INSERT INTO `dept_emp` VALUES (253854,'d002','1992-06-21','2001-10-29'),
(254240,'d004','1995-12-18','9999-01-01'),
(254984,'d004','1993-01-13','9999-01-01'),
(255294,'d009','1998-02-26','9999-01-01'),
(255536,'d002','1991-12-10','9999-01-01'),
(255874,'d004','1994-06-25','9999-01-01'),
(256365,'d005','1990-01-21','1996-09-20'),
(256447,'d007','1989-07-30','1996-07-09'),
(256447,'d009','1996-07-09','9999-01-01'),
(256505,'d009','1999-05-14','2001-05-25');


INSERT INTO `dept_emp` VALUES (256535,'d009','1987-12-15','9999-01-01'),
(256936,'d004','1986-10-02','9999-01-01'),
(256982,'d007','1988-06-18','9999-01-01'),
(257260,'d005','1998-07-04','9999-01-01'),
(257431,'d004','1992-12-06','1995-04-16'),
(257760,'d002','1987-07-21','1989-12-15'),
(258092,'d005','1999-08-23','9999-01-01'),
(258451,'d001','1990-02-09','9999-01-01'),
(258582,'d007','1995-04-03','9999-01-01'),
(259273,'d004','1989-12-01','9999-01-01');


INSERT INTO `dept_emp` VALUES (259293,'d003','1996-12-23','9999-01-01'),
(259407,'d001','1986-10-14','9999-01-01'),
(259983,'d003','1988-08-15','9999-01-01'),
(260083,'d003','1997-12-22','1999-02-27'),
(260516,'d004','1985-10-13','9999-01-01'),
(260516,'d005','1985-08-31','1985-10-13'),
(260734,'d006','1993-03-14','9999-01-01'),
(261201,'d004','1986-03-08','9999-01-01'),
(261253,'d004','1994-10-06','2000-05-07'),
(261253,'d006','2000-05-07','9999-01-01');


INSERT INTO `dept_emp` VALUES (261592,'d005','1996-01-28','9999-01-01'),
(262130,'d006','1995-08-02','9999-01-01'),
(262725,'d005','1986-07-24','9999-01-01'),
(262898,'d004','1996-07-18','1997-03-29'),
(263049,'d001','1990-06-26','2001-06-11'),
(263405,'d005','1990-10-19','1998-12-15'),
(263531,'d007','1994-02-23','9999-01-01'),
(264395,'d005','1990-01-01','9999-01-01'),
(264433,'d005','1998-08-22','2001-09-20'),
(264558,'d009','1986-07-24','9999-01-01');


INSERT INTO `dept_emp` VALUES (264698,'d001','1994-06-28','9999-01-01'),
(264873,'d007','1987-09-16','9999-01-01'),
(264957,'d004','1995-10-07','1995-11-22'),
(265364,'d006','1994-05-04','1995-08-15'),
(265414,'d009','1993-05-01','9999-01-01'),
(265743,'d002','1988-06-29','1996-05-10'),
(265743,'d003','1996-05-10','9999-01-01'),
(265844,'d005','1990-11-10','9999-01-01'),
(265997,'d005','1992-03-11','1993-08-26'),
(265997,'d006','1991-09-26','1992-03-11');


INSERT INTO `dept_emp` VALUES (266331,'d004','1985-11-17','1992-01-21'),
(266792,'d004','1997-07-04','2001-06-03'),
(266792,'d009','2001-06-03','9999-01-01'),
(267595,'d005','1993-11-09','1998-02-01'),
(268302,'d005','1991-11-05','9999-01-01'),
(268680,'d007','1996-07-18','2002-06-15'),
(268680,'d009','2002-06-15','9999-01-01'),
(268927,'d006','1999-05-25','9999-01-01'),
(268956,'d004','1992-10-13','9999-01-01'),
(268965,'d001','1988-07-12','9999-01-01');


INSERT INTO `dept_emp` VALUES (269464,'d004','1998-08-23','9999-01-01'),
(269927,'d005','1991-05-29','9999-01-01'),
(269993,'d007','1995-11-15','1996-12-28'),
(270041,'d004','1990-07-19','1990-09-16'),
(270041,'d009','1990-09-16','1992-04-28'),
(270377,'d005','1999-12-05','9999-01-01'),
(270989,'d005','2002-03-23','9999-01-01'),
(270989,'d009','1999-11-23','2002-03-23'),
(271337,'d006','1989-04-21','9999-01-01'),
(271603,'d003','1996-05-12','9999-01-01');


INSERT INTO `dept_emp` VALUES (272079,'d006','1996-09-20','9999-01-01'),
(272238,'d005','1997-06-11','9999-01-01'),
(272888,'d003','1989-11-19','9999-01-01'),
(273095,'d002','1994-08-20','9999-01-01'),
(273215,'d007','1985-07-13','1993-02-23'),
(273405,'d004','1993-10-04','9999-01-01'),
(273453,'d004','1992-04-13','9999-01-01'),
(273593,'d004','1989-09-12','9999-01-01'),
(274036,'d004','1998-09-08','9999-01-01'),
(274136,'d005','1998-06-03','9999-01-01');


INSERT INTO `dept_emp` VALUES (274270,'d005','1990-11-18','9999-01-01'),
(274725,'d004','1998-11-05','2001-07-29'),
(274855,'d007','1985-08-20','2000-10-26'),
(275711,'d008','1992-01-04','2001-04-02'),
(276056,'d004','1993-11-27','9999-01-01'),
(276204,'d003','1996-09-10','9999-01-01'),
(276344,'d005','1999-10-25','9999-01-01'),
(276344,'d006','1998-04-24','1999-10-25'),
(276448,'d001','1996-01-23','1997-11-19'),
(276923,'d005','1994-03-16','9999-01-01');


INSERT INTO `dept_emp` VALUES (277230,'d002','1999-09-20','9999-01-01'),
(277479,'d005','1997-04-17','9999-01-01'),
(277868,'d005','1985-10-16','9999-01-01'),
(278168,'d004','1988-06-06','9999-01-01'),
(278325,'d004','1999-07-29','9999-01-01'),
(278365,'d004','2001-06-17','9999-01-01'),
(278365,'d009','1985-05-30','2001-06-17'),
(278407,'d004','1986-01-21','9999-01-01'),
(278411,'d004','1997-12-08','9999-01-01'),
(278604,'d009','1995-07-05','1999-06-03');


INSERT INTO `dept_emp` VALUES (278879,'d006','1998-12-28','9999-01-01'),
(279744,'d004','1996-02-29','9999-01-01'),
(280203,'d004','1991-12-04','9999-01-01'),
(280307,'d004','1999-06-08','9999-01-01'),
(280307,'d005','1994-08-01','1999-06-08'),
(280920,'d005','1995-05-21','9999-01-01'),
(281215,'d009','1998-10-28','9999-01-01'),
(282010,'d007','1993-06-15','9999-01-01'),
(282407,'d004','1995-06-13','9999-01-01'),
(282957,'d005','1994-09-08','9999-01-01');


INSERT INTO `dept_emp` VALUES (283297,'d007','1985-06-24','9999-01-01'),
(283456,'d003','1987-05-21','9999-01-01'),
(284077,'d002','1989-06-14','9999-01-01'),
(284398,'d005','1992-02-04','2000-11-10'),
(284426,'d005','1990-11-18','9999-01-01'),
(285405,'d004','1998-01-03','9999-01-01'),
(285729,'d004','1986-08-19','1986-09-25'),
(285729,'d006','1986-09-25','9999-01-01'),
(286006,'d007','1998-03-13','9999-01-01'),
(286240,'d005','1990-06-09','9999-01-01');


INSERT INTO `dept_emp` VALUES (287571,'d007','1986-07-09','9999-01-01'),
(287914,'d005','1986-09-27','9999-01-01'),
(288184,'d006','1994-11-19','9999-01-01'),
(289181,'d006','1987-02-12','9999-01-01'),
(289576,'d005','1990-01-21','1993-09-29'),
(289576,'d008','1993-09-29','2001-08-09'),
(289652,'d008','1988-05-10','1993-04-16'),
(289766,'d007','1999-12-24','9999-01-01'),
(289866,'d005','1999-04-21','9999-01-01'),
(290282,'d004','1995-08-27','9999-01-01');


INSERT INTO `dept_emp` VALUES (290932,'d005','1988-01-26','9999-01-01'),
(291158,'d005','1999-10-07','9999-01-01'),
(291253,'d007','1987-10-11','1992-05-19'),
(293383,'d004','1987-01-16','1988-01-02'),
(293448,'d005','1987-02-10','1999-08-30'),
(293551,'d005','1986-04-18','1994-01-20'),
(293714,'d004','1994-03-28','9999-01-01'),
(294057,'d007','1997-10-24','9999-01-01'),
(294261,'d005','1991-05-04','9999-01-01'),
(295755,'d004','1989-04-02','9999-01-01');


INSERT INTO `dept_emp` VALUES (296014,'d004','1999-04-14','2000-08-26'),
(296500,'d005','1993-02-03','9999-01-01'),
(296744,'d006','1985-08-21','1993-06-13'),
(297742,'d006','1987-05-30','1989-01-15'),
(298437,'d001','1991-06-05','9999-01-01'),
(298667,'d008','1998-10-20','2001-08-30'),
(298675,'d005','1994-09-02','9999-01-01'),
(298735,'d004','1999-01-07','2000-05-03'),
(298735,'d009','1998-10-25','1999-01-07'),
(298747,'d004','1989-10-21','9999-01-01');


INSERT INTO `dept_emp` VALUES (298757,'d003','1988-06-28','9999-01-01'),
(298919,'d004','1994-10-02','9999-01-01'),
(298919,'d005','1985-02-20','1994-10-02'),
(299167,'d007','1994-12-24','9999-01-01'),
(299210,'d002','1996-10-22','9999-01-01'),
(299271,'d007','1989-04-13','9999-01-01'),
(299403,'d003','1998-09-19','9999-01-01'),
(299405,'d001','1997-04-20','9999-01-01'),
(299850,'d004','1994-06-02','9999-01-01'),
(400054,'d005','2000-10-23','9999-01-01');


INSERT INTO `dept_emp` VALUES (400054,'d009','1999-10-02','2000-10-23'),
(400444,'d005','1992-02-15','9999-01-01'),
(400538,'d009','1997-07-29','1999-10-09'),
(400763,'d005','1997-08-12','9999-01-01'),
(400796,'d005','1996-05-30','9999-01-01'),
(401085,'d005','1987-05-18','9999-01-01'),
(401291,'d004','1987-11-02','9999-01-01'),
(401704,'d005','1991-05-22','9999-01-01'),
(401929,'d007','1985-03-02','9999-01-01'),
(402392,'d003','1995-03-21','9999-01-01');


INSERT INTO `dept_emp` VALUES (403849,'d005','1990-06-21','1993-10-13'),
(404174,'d005','1995-07-31','1999-02-09'),
(404441,'d004','1994-10-04','9999-01-01'),
(404669,'d002','1995-03-02','1998-06-11'),
(406556,'d003','1993-11-09','9999-01-01'),
(407401,'d004','1999-01-14','9999-01-01'),
(407481,'d007','1991-07-19','9999-01-01'),
(407937,'d004','2000-01-19','9999-01-01'),
(407937,'d008','1999-01-13','2000-01-19'),
(408371,'d008','1986-11-13','9999-01-01');


INSERT INTO `dept_emp` VALUES (408886,'d009','1985-11-19','9999-01-01'),
(409162,'d007','1988-07-22','9999-01-01'),
(409376,'d005','1997-12-13','2000-01-13'),
(409509,'d007','1988-03-01','9999-01-01'),
(409522,'d005','1992-05-10','9999-01-01'),
(409928,'d007','1993-05-20','2000-07-26'),
(410062,'d004','1991-01-24','9999-01-01'),
(410236,'d005','1988-01-05','1999-01-06'),
(410301,'d007','1993-12-21','9999-01-01'),
(410949,'d002','1992-02-06','1997-10-30');


INSERT INTO `dept_emp` VALUES (411006,'d008','1987-02-15','9999-01-01'),
(411065,'d005','1998-07-17','1999-02-23'),
(411065,'d008','1999-02-23','9999-01-01'),
(411670,'d008','1992-12-04','9999-01-01'),
(411880,'d004','1997-10-30','9999-01-01'),
(411880,'d005','1997-07-08','1997-10-30'),
(411954,'d006','1996-07-27','9999-01-01'),
(411998,'d001','1993-09-09','9999-01-01'),
(412876,'d005','1992-01-02','9999-01-01'),
(413034,'d005','1988-11-30','9999-01-01');


INSERT INTO `dept_emp` VALUES (413054,'d007','1997-12-16','9999-01-01'),
(413061,'d006','1993-10-17','9999-01-01'),
(413392,'d005','1990-04-27','9999-01-01'),
(413675,'d007','1997-06-22','1999-04-06'),
(413880,'d004','1994-02-22','9999-01-01'),
(414068,'d005','1995-07-04','9999-01-01'),
(414091,'d005','1997-08-19','9999-01-01'),
(414156,'d004','1998-12-04','9999-01-01'),
(414922,'d004','1987-06-05','1997-11-04'),
(415340,'d005','1991-08-03','9999-01-01');


INSERT INTO `dept_emp` VALUES (415511,'d002','1986-06-11','9999-01-01'),
(415796,'d006','1988-02-16','9999-01-01'),
(415832,'d008','1998-10-12','9999-01-01'),
(416009,'d001','1988-05-04','9999-01-01'),
(416137,'d008','1999-07-16','9999-01-01'),
(416636,'d006','1995-02-01','9999-01-01'),
(417262,'d001','1987-06-20','2000-02-11'),
(417262,'d009','2000-02-11','9999-01-01'),
(417486,'d004','1987-01-10','9999-01-01'),
(417525,'d001','1988-02-11','1994-07-22');


INSERT INTO `dept_emp` VALUES (417812,'d008','1998-04-23','9999-01-01'),
(417961,'d004','1986-07-28','9999-01-01'),
(418171,'d005','1993-01-13','9999-01-01'),
(419663,'d006','1992-04-24','9999-01-01'),
(419770,'d005','1988-04-11','9999-01-01'),
(419925,'d005','1996-09-22','9999-01-01'),
(420207,'d004','1992-04-05','9999-01-01'),
(420252,'d004','1985-07-15','9999-01-01'),
(420410,'d003','1993-11-03','2000-03-02'),
(420997,'d005','1985-07-30','9999-01-01');


INSERT INTO `dept_emp` VALUES (421163,'d007','1995-06-02','9999-01-01'),
(421184,'d004','1993-10-03','2000-01-30'),
(421309,'d007','1988-02-16','9999-01-01'),
(421547,'d005','1997-01-26','2000-12-03'),
(421753,'d005','1986-01-04','9999-01-01'),
(421822,'d005','1993-08-22','9999-01-01'),
(422051,'d007','1988-10-20','9999-01-01'),
(422053,'d005','1990-07-24','9999-01-01'),
(422478,'d002','1991-08-28','1997-08-21'),
(422871,'d004','1991-08-11','1996-04-27');


INSERT INTO `dept_emp` VALUES (422875,'d005','1989-01-30','9999-01-01'),
(423062,'d001','1995-10-31','9999-01-01'),
(423711,'d009','1996-05-05','2002-03-01'),
(424207,'d007','1994-05-28','1998-02-02'),
(424207,'d009','1998-02-02','9999-01-01'),
(424569,'d005','1997-10-30','9999-01-01'),
(424598,'d004','1993-04-15','9999-01-01'),
(424692,'d004','1992-09-07','1993-04-13'),
(424806,'d002','1989-06-27','9999-01-01'),
(425308,'d005','1986-12-15','9999-01-01');


INSERT INTO `dept_emp` VALUES (425361,'d007','1994-06-30','9999-01-01'),
(425779,'d004','1994-06-06','1995-03-25'),
(425779,'d009','1995-03-25','9999-01-01'),
(425970,'d004','1996-10-07','2000-06-07'),
(425970,'d009','2000-06-07','9999-01-01'),
(426100,'d004','1996-05-13','1996-06-29'),
(426100,'d006','1996-06-29','1996-07-18'),
(426483,'d001','2001-09-07','9999-01-01'),
(426483,'d007','1997-07-28','2001-09-07'),
(427267,'d005','1999-12-04','9999-01-01');


INSERT INTO `dept_emp` VALUES (427502,'d009','1999-02-11','9999-01-01'),
(427812,'d007','1999-08-15','9999-01-01'),
(427918,'d005','1985-10-13','9999-01-01'),
(428296,'d008','1997-08-15','9999-01-01'),
(428342,'d007','1992-09-17','9999-01-01'),
(428479,'d001','1999-03-31','9999-01-01'),
(428505,'d003','1990-09-30','9999-01-01'),
(428595,'d001','1990-01-31','9999-01-01'),
(428772,'d004','1995-11-24','1995-12-26'),
(428772,'d009','1995-12-26','1996-01-08');


INSERT INTO `dept_emp` VALUES (429487,'d004','1997-06-28','2001-07-24'),
(429487,'d009','2001-07-24','9999-01-01'),
(429666,'d006','1994-06-19','9999-01-01'),
(429675,'d005','1998-10-31','9999-01-01'),
(429710,'d005','1990-01-05','9999-01-01'),
(430218,'d002','1995-09-23','9999-01-01'),
(430595,'d008','1994-07-24','1999-02-15'),
(430823,'d009','1993-07-01','9999-01-01'),
(430908,'d005','1990-06-23','1992-12-13'),
(431599,'d005','1987-10-22','9999-01-01');


INSERT INTO `dept_emp` VALUES (431625,'d004','1999-06-30','2001-07-09'),
(431625,'d009','2001-07-09','9999-01-01'),
(431732,'d005','1996-05-24','9999-01-01'),
(431732,'d006','1990-12-05','1996-05-24'),
(431795,'d005','2000-01-19','2002-06-02'),
(431831,'d005','1996-02-27','9999-01-01'),
(432011,'d005','1986-04-19','9999-01-01'),
(432089,'d006','1989-12-30','2002-01-11'),
(432304,'d004','1991-06-01','9999-01-01'),
(432591,'d005','1988-01-29','9999-01-01');


INSERT INTO `dept_emp` VALUES (433763,'d004','1991-11-18','9999-01-01'),
(433763,'d006','1987-09-22','1991-11-18'),
(434095,'d005','1994-01-20','1997-10-14'),
(434948,'d008','1987-08-31','9999-01-01'),
(435178,'d003','1996-07-12','9999-01-01'),
(435490,'d005','1999-04-05','9999-01-01'),
(435942,'d007','1999-12-20','9999-01-01'),
(436169,'d005','1988-10-31','9999-01-01'),
(436175,'d005','1989-12-03','9999-01-01'),
(436326,'d003','1993-06-15','1994-01-10');


INSERT INTO `dept_emp` VALUES (436684,'d004','1988-03-28','9999-01-01'),
(437693,'d004','1988-08-23','9999-01-01'),
(437857,'d007','1995-02-23','9999-01-01'),
(437869,'d007','1993-12-15','9999-01-01'),
(438019,'d003','1996-08-23','1997-06-06'),
(438369,'d005','1992-11-20','9999-01-01'),
(438435,'d005','1987-12-19','9999-01-01'),
(438531,'d004','1996-06-29','1997-03-28'),
(438707,'d007','1997-09-16','9999-01-01'),
(438745,'d005','1987-08-29','9999-01-01');


INSERT INTO `dept_emp` VALUES (439293,'d004','1986-08-11','9999-01-01'),
(439463,'d004','1990-02-02','9999-01-01'),
(439537,'d004','1988-12-12','9999-01-01'),
(439693,'d004','1986-03-20','9999-01-01'),
(440249,'d005','1992-08-28','1996-11-10'),
(440546,'d005','1999-12-01','9999-01-01'),
(440846,'d002','1997-10-02','9999-01-01'),
(441011,'d007','1995-03-04','9999-01-01'),
(441307,'d001','1990-08-15','9999-01-01'),
(441907,'d005','1992-03-18','9999-01-01');


INSERT INTO `dept_emp` VALUES (442038,'d005','1985-07-20','9999-01-01'),
(442184,'d007','1993-11-08','9999-01-01'),
(442333,'d006','1989-02-12','9999-01-01'),
(442526,'d005','1987-08-30','9999-01-01'),
(443533,'d006','1992-03-11','9999-01-01'),
(443582,'d001','1993-01-29','9999-01-01'),
(443617,'d001','1986-12-07','9999-01-01'),
(443703,'d005','1985-11-13','9999-01-01'),
(443763,'d005','1997-01-31','1997-07-10'),
(443787,'d004','1986-04-01','1991-12-04');


INSERT INTO `dept_emp` VALUES (444254,'d002','1988-09-21','1995-01-31'),
(444254,'d007','1995-01-31','1998-09-17'),
(444519,'d009','1997-02-17','9999-01-01'),
(444831,'d002','1996-09-03','9999-01-01'),
(445023,'d007','1988-07-21','9999-01-01'),
(445368,'d007','1991-03-19','1992-09-29'),
(445708,'d002','1987-07-20','1989-09-15'),
(446075,'d007','1997-08-28','9999-01-01'),
(446124,'d009','1986-05-05','1993-05-30'),
(446345,'d007','1993-06-19','9999-01-01');


INSERT INTO `dept_emp` VALUES (446396,'d006','1990-04-13','1997-08-24'),
(446552,'d009','1985-02-06','9999-01-01'),
(446653,'d004','1992-09-04','9999-01-01'),
(446753,'d005','1996-07-27','1999-03-30'),
(446753,'d008','1999-03-30','9999-01-01'),
(447555,'d004','1989-09-26','9999-01-01'),
(447791,'d008','1996-04-29','9999-01-01'),
(447950,'d006','1988-08-18','9999-01-01'),
(447951,'d009','1988-10-30','9999-01-01'),
(448061,'d002','1985-05-22','1988-09-01');


INSERT INTO `dept_emp` VALUES (448100,'d004','1990-06-23','2001-03-20'),
(448100,'d009','2001-03-20','9999-01-01'),
(448258,'d009','1994-10-04','9999-01-01'),
(448842,'d009','1995-12-22','9999-01-01'),
(449084,'d004','1985-06-25','9999-01-01'),
(449160,'d004','1997-12-09','9999-01-01'),
(449585,'d008','1989-09-17','9999-01-01'),
(449950,'d006','1986-04-16','9999-01-01'),
(450050,'d004','1999-07-24','9999-01-01'),
(450050,'d005','1989-12-30','1999-07-24');


INSERT INTO `dept_emp` VALUES (450443,'d005','1988-04-08','1995-12-23'),
(450960,'d005','1987-10-21','9999-01-01'),
(452346,'d005','1998-06-15','9999-01-01'),
(452944,'d003','1995-09-26','2000-12-14'),
(453467,'d008','1993-01-24','9999-01-01'),
(453835,'d007','1990-08-25','9999-01-01'),
(453910,'d004','1998-10-29','9999-01-01'),
(454044,'d004','1991-10-02','9999-01-01'),
(454104,'d005','1994-09-06','1998-01-28'),
(454472,'d008','1991-05-04','9999-01-01');


INSERT INTO `dept_emp` VALUES (454591,'d003','1986-07-01','9999-01-01'),
(454592,'d007','1990-07-03','9999-01-01'),
(454774,'d004','1986-11-01','9999-01-01'),
(455131,'d002','1995-03-18','9999-01-01'),
(455592,'d006','1991-04-18','9999-01-01'),
(455801,'d005','1985-11-19','9999-01-01'),
(455948,'d003','1993-01-18','9999-01-01'),
(456107,'d008','1991-05-27','9999-01-01'),
(456131,'d008','1994-06-09','9999-01-01'),
(456146,'d007','1999-12-02','9999-01-01');


INSERT INTO `dept_emp` VALUES (456688,'d004','1991-02-27','1999-09-13'),
(456688,'d006','1999-09-13','9999-01-01'),
(456982,'d005','1989-01-05','9999-01-01'),
(457307,'d006','1988-09-30','9999-01-01'),
(457337,'d006','1995-04-27','9999-01-01'),
(457781,'d002','1992-05-30','1999-06-12'),
(457792,'d004','1989-08-09','1996-09-01'),
(457792,'d006','1996-09-01','9999-01-01'),
(458720,'d005','1994-04-23','1999-05-03'),
(458866,'d004','1996-04-16','9999-01-01');


INSERT INTO `dept_emp` VALUES (458866,'d005','1992-09-02','1996-04-16'),
(459134,'d004','1996-12-31','2002-05-04'),
(459134,'d009','2002-05-04','9999-01-01'),
(459172,'d005','1993-11-20','9999-01-01'),
(459670,'d007','1985-11-13','9999-01-01'),
(459744,'d003','1991-02-27','9999-01-01'),
(461268,'d007','1991-10-12','9999-01-01'),
(461329,'d002','1998-01-12','9999-01-01'),
(461716,'d004','1996-09-02','9999-01-01'),
(462367,'d006','1998-11-24','9999-01-01');


INSERT INTO `dept_emp` VALUES (462427,'d007','1991-07-09','9999-01-01'),
(463321,'d009','1994-05-27','9999-01-01'),
(463614,'d009','1989-10-19','9999-01-01'),
(464625,'d002','1992-08-06','9999-01-01'),
(464927,'d005','1989-06-05','1998-12-11'),
(464955,'d002','1994-04-08','1995-04-13'),
(465205,'d004','1987-05-12','9999-01-01'),
(465245,'d009','1985-03-07','1994-12-18'),
(465854,'d004','1999-09-14','9999-01-01'),
(466137,'d004','1998-11-07','9999-01-01');


INSERT INTO `dept_emp` VALUES (466147,'d007','1989-12-09','9999-01-01'),
(466176,'d004','1986-11-11','1997-04-06'),
(466176,'d006','1997-04-06','9999-01-01'),
(466224,'d004','1992-09-23','1993-05-14'),
(466440,'d008','1987-05-16','9999-01-01'),
(466555,'d005','1989-02-17','9999-01-01'),
(466771,'d006','1998-08-14','9999-01-01'),
(467051,'d001','1991-07-20','1995-02-07'),
(467114,'d005','1994-05-30','9999-01-01'),
(467978,'d009','1992-10-03','1995-02-24');


INSERT INTO `dept_emp` VALUES (468108,'d006','1993-02-18','9999-01-01'),
(469541,'d005','1995-11-03','9999-01-01'),
(469772,'d005','1994-09-06','9999-01-01'),
(470221,'d002','1997-02-21','1998-08-01'),
(470221,'d003','1998-08-01','9999-01-01'),
(470837,'d004','1996-03-02','9999-01-01'),
(471334,'d004','1995-05-11','2000-11-07'),
(471535,'d005','1997-11-27','1999-11-11'),
(471787,'d004','1988-08-20','9999-01-01'),
(472062,'d009','1992-09-02','1999-07-21');


INSERT INTO `dept_emp` VALUES (472563,'d004','1990-10-09','9999-01-01'),
(473287,'d005','1990-05-07','9999-01-01'),
(473521,'d007','1987-10-26','9999-01-01'),
(473954,'d007','1998-09-19','1999-04-29'),
(473954,'d009','1999-04-29','9999-01-01'),
(474064,'d005','1985-10-06','1991-05-11'),
(475036,'d004','1999-11-21','9999-01-01'),
(475725,'d003','1994-05-02','9999-01-01'),
(476629,'d008','1992-09-27','1993-08-21'),
(477293,'d004','2001-03-04','9999-01-01');


INSERT INTO `dept_emp` VALUES (477293,'d005','1987-06-16','2001-03-04'),
(477384,'d006','1987-03-07','9999-01-01'),
(478034,'d008','1992-09-01','9999-01-01'),
(478331,'d005','1996-06-06','2000-07-13'),
(478439,'d005','1997-11-04','9999-01-01'),
(478442,'d004','1997-03-10','9999-01-01'),
(478460,'d007','1986-11-16','1999-12-08'),
(479267,'d005','1994-11-23','9999-01-01'),
(479287,'d004','1992-09-19','9999-01-01'),
(479747,'d004','1991-06-26','1991-07-12');


INSERT INTO `dept_emp` VALUES (480010,'d005','1998-11-07','2000-03-23'),
(480016,'d005','1986-09-04','1988-03-02'),
(480019,'d005','1996-08-22','2000-07-24'),
(480923,'d005','1987-07-01','1989-06-06'),
(481107,'d002','1992-04-15','9999-01-01'),
(481113,'d004','1988-01-14','9999-01-01'),
(481144,'d008','1994-05-16','9999-01-01'),
(481503,'d009','1992-08-23','9999-01-01'),
(481851,'d004','1994-03-19','1995-12-09'),
(482133,'d004','1994-08-10','9999-01-01');


INSERT INTO `dept_emp` VALUES (482158,'d004','1989-10-27','2000-10-20'),
(482279,'d008','1998-07-08','9999-01-01'),
(482347,'d004','1998-09-28','2002-02-07'),
(482347,'d009','2002-02-07','9999-01-01'),
(482555,'d007','1985-11-30','9999-01-01'),
(482689,'d003','1999-07-03','9999-01-01'),
(482722,'d004','1990-12-17','1995-01-18'),
(482722,'d008','1989-04-29','1990-12-17'),
(482765,'d004','1996-01-04','2000-03-21'),
(482786,'d007','1985-03-24','1996-05-04');


INSERT INTO `dept_emp` VALUES (483081,'d004','1991-06-19','9999-01-01'),
(483081,'d005','1988-09-15','1991-06-19'),
(483171,'d004','1994-07-11','1995-08-15'),
(483171,'d008','1988-11-14','1994-07-11'),
(483399,'d007','1997-05-11','1999-05-29'),
(483624,'d003','1986-03-23','9999-01-01'),
(484242,'d005','1989-07-22','9999-01-01'),
(484451,'d001','1994-01-04','9999-01-01'),
(484460,'d006','1992-11-29','9999-01-01'),
(484778,'d005','1997-02-23','1999-08-25');


INSERT INTO `dept_emp` VALUES (484889,'d007','1986-08-02','1987-04-24'),
(485483,'d005','1996-07-20','2002-01-02'),
(485682,'d008','1997-03-20','9999-01-01'),
(485905,'d005','1988-11-11','9999-01-01'),
(486022,'d004','1988-09-12','9999-01-01'),
(486306,'d007','1994-11-19','9999-01-01'),
(487218,'d008','1986-11-07','9999-01-01'),
(487252,'d005','1988-02-27','9999-01-01'),
(487925,'d005','1994-08-31','9999-01-01'),
(488231,'d002','1995-02-24','9999-01-01');


INSERT INTO `dept_emp` VALUES (488385,'d009','1991-11-30','1993-03-26'),
(488504,'d008','1998-05-12','9999-01-01'),
(488538,'d006','1996-05-16','9999-01-01'),
(488588,'d003','1992-08-10','1994-11-14'),
(488774,'d005','1997-10-10','9999-01-01'),
(488997,'d005','1987-09-10','9999-01-01'),
(489215,'d005','1999-08-28','9999-01-01'),
(489339,'d005','1989-11-10','9999-01-01'),
(489378,'d004','1985-11-15','9999-01-01'),
(489404,'d005','1997-12-03','9999-01-01');


INSERT INTO `dept_emp` VALUES (489514,'d004','1988-08-15','9999-01-01'),
(489658,'d009','1985-09-23','1998-01-22'),
(490024,'d004','1991-11-28','9999-01-01'),
(490025,'d005','1986-03-07','9999-01-01'),
(490095,'d001','1999-06-12','9999-01-01'),
(490155,'d005','1989-04-25','1991-08-23'),
(490390,'d004','1996-12-28','9999-01-01'),
(490390,'d006','1988-01-01','1996-12-28'),
(490647,'d004','1992-02-09','9999-01-01'),
(490747,'d008','1998-11-18','9999-01-01');


INSERT INTO `dept_emp` VALUES (491048,'d008','1992-06-14','9999-01-01'),
(491358,'d005','1992-10-31','1996-03-17'),
(491370,'d009','1994-01-26','9999-01-01'),
(491978,'d008','1990-02-19','9999-01-01'),
(492217,'d005','1991-09-28','9999-01-01'),
(492566,'d006','1988-01-09','9999-01-01'),
(493013,'d005','1996-02-01','9999-01-01'),
(493516,'d004','1985-04-02','9999-01-01'),
(494052,'d002','1994-05-26','9999-01-01'),
(494230,'d007','1987-07-26','9999-01-01');


INSERT INTO `dept_emp` VALUES (494294,'d007','1990-04-08','1992-04-09'),
(495066,'d005','1998-01-12','9999-01-01'),
(495146,'d002','1988-11-05','9999-01-01'),
(495658,'d005','1998-09-28','2000-03-04'),
(495879,'d004','1989-12-30','9999-01-01'),
(496317,'d009','1997-11-28','9999-01-01'),
(496685,'d007','1991-04-11','9999-01-01'),
(496687,'d009','1999-02-13','9999-01-01'),
(497341,'d001','1989-03-03','9999-01-01'),
(497434,'d009','1986-07-16','9999-01-01');


INSERT INTO `dept_emp` VALUES (498101,'d007','1998-12-16','9999-01-01'),
(498351,'d005','1997-12-04','9999-01-01'),
(498404,'d005','1998-04-28','9999-01-01'),
(498649,'d004','1998-05-23','2000-01-13'),
(498741,'d005','1985-12-21','9999-01-01'),
(499367,'d006','1993-02-17','9999-01-01'),
(499762,'d009','1985-07-06','9999-01-01');



SELECT 'LOADING dept_manager' as INFO;
-- No dept_manager records for selected employees

SELECT 'LOADING titles' as INFO;
INSERT INTO `titles` VALUES (10001,'Senior Engineer','1986-06-26','9999-01-01'),
(10213,'Staff','1994-10-06','9999-01-01'),
(10300,'Engineer','1991-05-17','1996-05-16'),
(10300,'Senior Engineer','1996-05-16','9999-01-01'),
(10604,'Engineer','1990-04-07','1997-04-07'),
(10604,'Senior Engineer','1997-04-07','9999-01-01'),
(10887,'Senior Engineer','1989-03-17','9999-01-01'),
(11131,'Technique Leader','1999-07-14','1999-08-01'),
(11345,'Engineer','1998-11-25','9999-01-01'),
(11403,'Senior Staff','1989-08-03','1993-12-01');


INSERT INTO `titles` VALUES (11702,'Engineer','1988-09-18','1995-09-14'),
(11859,'Staff','1998-07-28','9999-01-01'),
(12908,'Senior Staff','1996-09-23','9999-01-01'),
(12908,'Staff','1988-09-23','1996-09-23'),
(13092,'Staff','1994-05-16','9999-01-01'),
(13408,'Engineer','1995-07-25','2000-07-24'),
(13408,'Senior Engineer','2000-07-24','9999-01-01'),
(13771,'Senior Staff','1995-05-21','9999-01-01'),
(13771,'Staff','1990-05-21','1995-05-21'),
(14102,'Engineer','1989-04-03','1991-02-21');


INSERT INTO `titles` VALUES (14884,'Engineer','1989-06-08','1996-06-08'),
(14884,'Senior Engineer','1996-06-08','9999-01-01'),
(15070,'Staff','1995-08-28','2000-07-16'),
(15323,'Senior Staff','1994-04-02','9999-01-01'),
(15323,'Staff','1988-04-02','1994-04-02'),
(16020,'Senior Staff','1990-01-04','9999-01-01'),
(16431,'Senior Staff','1991-06-19','9999-01-01'),
(16431,'Staff','1985-06-19','1991-06-19'),
(16634,'Senior Staff','1997-01-18','9999-01-01'),
(16634,'Staff','1990-01-18','1997-01-18');


INSERT INTO `titles` VALUES (17170,'Senior Staff','1988-12-03','9999-01-01'),
(17418,'Assistant Engineer','1997-08-13','9999-01-01'),
(17738,'Engineer','1990-04-21','1997-04-21'),
(17738,'Senior Engineer','1997-04-21','9999-01-01'),
(18047,'Engineer','1994-01-25','2001-01-25'),
(18047,'Senior Engineer','2001-01-25','2001-09-08'),
(19041,'Senior Staff','1998-09-28','2002-03-25'),
(20163,'Senior Staff','1999-03-04','9999-01-01'),
(20163,'Staff','1991-03-04','1999-03-04'),
(20212,'Staff','1997-12-27','9999-01-01');


INSERT INTO `titles` VALUES (20241,'Senior Engineer','1991-05-12','9999-01-01'),
(20685,'Technique Leader','1989-10-23','2000-01-30'),
(20877,'Assistant Engineer','1993-08-04','2001-08-04'),
(20877,'Engineer','2001-08-04','9999-01-01'),
(21029,'Senior Engineer','1998-05-25','9999-01-01'),
(22407,'Senior Staff','1996-01-20','1998-03-22'),
(22806,'Engineer','1990-07-06','1993-09-08'),
(22996,'Assistant Engineer','1998-11-22','9999-01-01'),
(23113,'Senior Staff','1998-04-06','9999-01-01'),
(23113,'Staff','1991-04-06','1998-04-06');


INSERT INTO `titles` VALUES (23463,'Senior Staff','1998-04-02','9999-01-01'),
(23561,'Assistant Engineer','1992-02-25','1997-02-24'),
(23561,'Engineer','1997-02-24','2002-02-24'),
(23561,'Senior Engineer','2002-02-24','9999-01-01'),
(23913,'Senior Engineer','1985-07-20','9999-01-01'),
(24139,'Senior Staff','1997-08-13','9999-01-01'),
(24210,'Senior Staff','1997-01-07','9999-01-01'),
(24210,'Staff','1988-01-08','1997-01-07'),
(24471,'Senior Staff','2002-01-01','9999-01-01'),
(24471,'Staff','1996-01-02','2002-01-01');


INSERT INTO `titles` VALUES (24711,'Senior Staff','2001-05-25','9999-01-01'),
(25048,'Senior Staff','1995-08-02','9999-01-01'),
(25048,'Staff','1988-08-01','1995-08-02'),
(25136,'Staff','1993-02-26','1996-06-04'),
(25177,'Senior Staff','1990-12-10','9999-01-01'),
(25218,'Senior Engineer','1998-06-10','9999-01-01'),
(25623,'Staff','1996-02-06','9999-01-01'),
(26269,'Technique Leader','1989-09-17','9999-01-01'),
(26470,'Engineer','1988-07-13','1996-07-13'),
(26470,'Senior Engineer','1996-07-13','9999-01-01');


INSERT INTO `titles` VALUES (26664,'Engineer','1996-12-27','2001-12-27'),
(26664,'Senior Engineer','2001-12-27','2002-05-16'),
(26830,'Engineer','1985-12-19','1991-12-19'),
(26830,'Senior Engineer','1991-12-19','9999-01-01'),
(27113,'Technique Leader','1993-12-01','9999-01-01'),
(28822,'Engineer','1989-12-17','1994-12-17'),
(28822,'Senior Engineer','1994-12-17','9999-01-01'),
(28890,'Senior Engineer','1987-05-20','9999-01-01'),
(29240,'Engineer','1992-11-04','2000-11-04'),
(29240,'Senior Engineer','2000-11-04','9999-01-01');


INSERT INTO `titles` VALUES (29409,'Engineer','1990-11-29','1995-11-29'),
(29409,'Senior Engineer','1995-11-29','9999-01-01'),
(30058,'Senior Staff','2000-03-25','9999-01-01'),
(30058,'Staff','1994-03-26','2000-03-25'),
(30303,'Engineer','1997-02-08','9999-01-01'),
(30837,'Senior Engineer','1991-08-27','9999-01-01'),
(30899,'Senior Staff','1997-08-23','9999-01-01'),
(30899,'Staff','1989-08-23','1997-08-23'),
(30917,'Engineer','1995-07-06','2000-07-05'),
(30917,'Senior Engineer','2000-07-05','9999-01-01');


INSERT INTO `titles` VALUES (31093,'Engineer','1989-08-20','1998-08-20'),
(31093,'Senior Engineer','1998-08-20','9999-01-01'),
(31107,'Senior Staff','2001-02-02','9999-01-01'),
(31107,'Staff','1996-02-03','2001-02-02'),
(31533,'Senior Staff','1995-12-22','9999-01-01'),
(31533,'Staff','1988-12-21','1995-12-22'),
(31931,'Senior Staff','1985-09-02','9999-01-01'),
(32781,'Engineer','1999-05-17','9999-01-01'),
(32884,'Engineer','1997-01-05','9999-01-01'),
(33115,'Assistant Engineer','1988-11-28','1994-11-28');


INSERT INTO `titles` VALUES (33115,'Engineer','1994-11-28','2000-11-27'),
(33115,'Senior Engineer','2000-11-27','9999-01-01'),
(33272,'Engineer','1989-09-02','1996-09-02'),
(33272,'Senior Engineer','1996-09-02','9999-01-01'),
(33864,'Staff','1998-04-15','9999-01-01'),
(34026,'Engineer','1989-01-21','1990-09-26'),
(34113,'Engineer','1988-08-10','1996-06-13'),
(34230,'Senior Staff','1998-06-02','2001-02-22'),
(34230,'Staff','1993-06-02','1998-06-02'),
(34703,'Engineer','1989-01-09','1996-01-10');


INSERT INTO `titles` VALUES (34703,'Senior Engineer','1996-01-10','9999-01-01'),
(36290,'Engineer','1988-04-23','1997-04-23'),
(36290,'Senior Engineer','1997-04-23','9999-01-01'),
(36329,'Senior Staff','2001-04-26','9999-01-01'),
(36329,'Staff','1992-04-26','2001-04-26'),
(36364,'Staff','1997-11-27','9999-01-01'),
(36523,'Engineer','1997-10-17','9999-01-01'),
(36634,'Senior Staff','1997-08-26','9999-01-01'),
(36634,'Staff','1992-08-26','1997-08-26'),
(36937,'Staff','1998-09-08','9999-01-01');


INSERT INTO `titles` VALUES (37060,'Senior Staff','1994-06-10','9999-01-01'),
(37060,'Staff','1985-06-10','1994-06-10'),
(37308,'Senior Staff','1993-10-13','9999-01-01'),
(38107,'Senior Staff','1991-03-04','9999-01-01'),
(38107,'Staff','1986-03-04','1991-03-04'),
(38402,'Engineer','1999-12-03','9999-01-01'),
(38419,'Senior Staff','1985-09-19','9999-01-01'),
(38588,'Staff','1995-12-24','9999-01-01'),
(39328,'Technique Leader','1998-05-22','9999-01-01'),
(39346,'Technique Leader','1994-02-13','9999-01-01');


INSERT INTO `titles` VALUES (39423,'Senior Engineer','1995-10-13','9999-01-01'),
(39822,'Senior Engineer','1986-07-12','9999-01-01'),
(39972,'Technique Leader','1988-09-08','9999-01-01'),
(40370,'Engineer','1988-07-03','1995-07-04'),
(40370,'Senior Engineer','1995-07-04','9999-01-01'),
(40663,'Engineer','1996-10-22','9999-01-01'),
(40742,'Staff','1998-06-17','2000-05-13'),
(40867,'Senior Staff','2001-01-18','9999-01-01'),
(40867,'Staff','1993-01-18','2001-01-18'),
(41268,'Engineer','1998-08-22','9999-01-01');


INSERT INTO `titles` VALUES (41579,'Technique Leader','1999-07-14','9999-01-01'),
(41779,'Senior Engineer','1995-10-13','9999-01-01'),
(41960,'Staff','1994-04-22','9999-01-01'),
(42646,'Technique Leader','1989-04-03','1990-02-28'),
(43307,'Engineer','1992-07-07','2000-07-07'),
(43307,'Senior Engineer','2000-07-07','9999-01-01'),
(43569,'Engineer','1996-10-12','9999-01-01'),
(43675,'Engineer','1993-01-18','2002-01-18'),
(43675,'Senior Engineer','2002-01-18','9999-01-01'),
(44259,'Staff','1996-07-08','9999-01-01');


INSERT INTO `titles` VALUES (44702,'Senior Staff','1994-01-27','9999-01-01'),
(44702,'Staff','1988-01-28','1994-01-27'),
(45338,'Engineer','1991-12-07','1997-12-06'),
(45338,'Senior Engineer','1997-12-06','9999-01-01'),
(45632,'Assistant Engineer','1993-09-23','9999-01-01'),
(45873,'Senior Staff','1993-07-07','9999-01-01'),
(45925,'Engineer','1997-03-01','2000-08-21'),
(45976,'Senior Staff','1994-03-25','2002-07-30'),
(45976,'Staff','1989-03-25','1994-03-25'),
(46067,'Engineer','1989-11-19','1998-11-19');


INSERT INTO `titles` VALUES (46067,'Senior Engineer','1998-11-19','9999-01-01'),
(46154,'Engineer','1994-01-05','2001-01-05'),
(46154,'Senior Engineer','2001-01-05','9999-01-01'),
(46288,'Senior Staff','1999-06-08','9999-01-01'),
(46288,'Staff','1992-06-07','1999-06-08'),
(46397,'Engineer','1998-06-27','9999-01-01'),
(46467,'Staff','1991-02-08','1993-06-16'),
(46601,'Staff','1998-09-13','9999-01-01'),
(46687,'Engineer','1990-08-30','1997-08-30'),
(46687,'Senior Engineer','1997-08-30','9999-01-01');


INSERT INTO `titles` VALUES (47150,'Senior Engineer','1991-02-25','9999-01-01'),
(47221,'Senior Engineer','1987-02-13','9999-01-01'),
(47319,'Staff','1987-03-21','1991-07-03'),
(47436,'Engineer','1996-09-13','2001-09-13'),
(47436,'Senior Engineer','2001-09-13','9999-01-01'),
(47440,'Staff','1989-11-12','1993-04-15'),
(48034,'Engineer','1989-05-19','1994-05-19'),
(48034,'Senior Engineer','1994-05-19','9999-01-01'),
(48183,'Staff','1997-09-19','9999-01-01'),
(48410,'Staff','1997-03-26','9999-01-01');


INSERT INTO `titles` VALUES (48841,'Engineer','1998-12-06','9999-01-01'),
(49232,'Senior Staff','1990-12-25','9999-01-01'),
(49232,'Staff','1985-12-25','1990-12-25'),
(49356,'Senior Staff','2001-10-06','9999-01-01'),
(49356,'Staff','1996-10-06','2001-10-06'),
(49450,'Engineer','1998-05-17','9999-01-01'),
(49524,'Staff','1998-08-20','9999-01-01'),
(49845,'Senior Staff','1997-11-13','9999-01-01'),
(49845,'Staff','1989-11-13','1997-11-13'),
(50624,'Engineer','1988-12-14','1995-12-15');


INSERT INTO `titles` VALUES (50624,'Senior Engineer','1995-12-15','9999-01-01'),
(51292,'Staff','1994-09-10','9999-01-01'),
(51314,'Senior Staff','1996-10-01','9999-01-01'),
(51314,'Staff','1991-10-02','1996-10-01'),
(51403,'Senior Staff','1997-02-16','2000-09-21'),
(51834,'Assistant Engineer','1997-09-04','9999-01-01'),
(52002,'Engineer','1990-03-05','1999-03-05'),
(52002,'Senior Engineer','1999-03-05','9999-01-01'),
(52109,'Senior Staff','1990-04-09','9999-01-01'),
(52109,'Staff','1985-04-09','1990-04-09');


INSERT INTO `titles` VALUES (52175,'Engineer','1993-04-21','1998-04-21'),
(52175,'Senior Engineer','1998-04-21','9999-01-01'),
(52246,'Engineer','1989-04-06','1997-04-05'),
(52246,'Senior Engineer','1997-04-05','9999-01-01'),
(52566,'Engineer','1998-05-29','9999-01-01'),
(52943,'Engineer','1999-09-03','9999-01-01'),
(52983,'Assistant Engineer','1985-11-23','1994-11-23'),
(52983,'Engineer','1994-11-23','9999-01-01'),
(53984,'Engineer','1994-08-31','2001-08-31'),
(54013,'Senior Staff','2002-07-21','9999-01-01');


INSERT INTO `titles` VALUES (54013,'Staff','1994-07-21','2002-07-21'),
(54458,'Senior Staff','1999-03-31','9999-01-01'),
(54660,'Senior Staff','1999-03-20','9999-01-01'),
(54660,'Staff','1994-03-20','1999-03-20'),
(54886,'Assistant Engineer','1996-10-03','1999-10-01'),
(54908,'Engineer','1988-04-05','1996-04-04'),
(54908,'Senior Engineer','1996-04-04','1996-07-10'),
(55437,'Technique Leader','1987-03-04','9999-01-01'),
(55581,'Senior Staff','1999-11-08','9999-01-01'),
(55581,'Staff','1993-11-08','1999-11-08');


INSERT INTO `titles` VALUES (56169,'Senior Engineer','1997-01-28','9999-01-01'),
(57385,'Staff','1995-05-20','9999-01-01'),
(57663,'Engineer','1990-01-13','1997-01-13'),
(57663,'Senior Engineer','1997-01-13','9999-01-01'),
(57838,'Staff','1999-02-14','9999-01-01'),
(57882,'Senior Staff','1997-12-28','9999-01-01'),
(57882,'Staff','1988-12-28','1997-12-28'),
(58391,'Senior Staff','1997-09-17','9999-01-01'),
(58626,'Senior Staff','1999-02-10','9999-01-01'),
(58787,'Engineer','1998-06-10','9999-01-01');


INSERT INTO `titles` VALUES (58869,'Engineer','1993-06-17','2002-06-17'),
(58869,'Senior Engineer','2002-06-17','9999-01-01'),
(58897,'Senior Staff','1995-12-09','9999-01-01'),
(58897,'Staff','1989-12-09','1995-12-09'),
(58962,'Engineer','1998-06-30','9999-01-01'),
(59124,'Senior Engineer','1992-12-31','2002-04-30'),
(59454,'Engineer','1994-05-12','1999-05-12'),
(59454,'Senior Engineer','1999-05-12','9999-01-01'),
(60708,'Senior Engineer','2000-01-24','9999-01-01'),
(60820,'Senior Staff','1989-08-15','1996-08-03');


INSERT INTO `titles` VALUES (61333,'Senior Staff','1993-11-03','9999-01-01'),
(61333,'Staff','1986-11-03','1993-11-03'),
(61600,'Engineer','1998-07-10','9999-01-01'),
(61613,'Senior Staff','1999-01-23','9999-01-01'),
(61613,'Staff','1990-01-23','1999-01-23'),
(62027,'Senior Staff','1995-12-18','9999-01-01'),
(62278,'Engineer','1994-09-21','9999-01-01'),
(62419,'Senior Staff','1999-07-22','1999-09-03'),
(62419,'Staff','1990-07-22','1999-07-22'),
(62620,'Staff','1995-08-12','2000-04-14');


INSERT INTO `titles` VALUES (62695,'Senior Staff','1996-01-07','9999-01-01'),
(62695,'Staff','1988-01-07','1996-01-07'),
(62705,'Senior Engineer','1996-09-10','9999-01-01'),
(62954,'Senior Staff','1995-07-12','9999-01-01'),
(62954,'Staff','1987-07-12','1995-07-12'),
(63426,'Engineer','1986-06-29','1995-06-29'),
(63426,'Senior Engineer','1995-06-29','9999-01-01'),
(63588,'Senior Staff','1988-09-20','9999-01-01'),
(63737,'Engineer','1995-03-21','1998-09-02'),
(63786,'Senior Staff','1995-01-18','9999-01-01');


INSERT INTO `titles` VALUES (63786,'Staff','1986-01-18','1995-01-18'),
(63894,'Senior Engineer','1998-06-24','2000-09-14'),
(64310,'Engineer','1992-08-13','1999-08-14'),
(64310,'Senior Engineer','1999-08-14','9999-01-01'),
(64841,'Senior Staff','1992-02-14','1995-10-30'),
(64841,'Staff','1986-02-14','1992-02-14'),
(65333,'Senior Engineer','1988-11-21','9999-01-01'),
(65790,'Engineer','1991-02-12','1998-02-12'),
(65790,'Senior Engineer','1998-02-12','9999-01-01'),
(65883,'Senior Staff','1996-04-18','9999-01-01');


INSERT INTO `titles` VALUES (65883,'Staff','1991-04-19','1996-04-18'),
(66118,'Assistant Engineer','1997-08-16','1999-11-17'),
(66674,'Senior Staff','1994-03-05','9999-01-01'),
(66674,'Staff','1988-03-05','1994-03-05'),
(66675,'Senior Staff','1994-05-12','9999-01-01'),
(66835,'Engineer','1998-05-21','9999-01-01'),
(67289,'Technique Leader','1999-01-02','9999-01-01'),
(67488,'Senior Staff','1989-09-18','1996-05-02'),
(68370,'Senior Staff','1999-11-21','9999-01-01'),
(68370,'Staff','1994-11-21','1999-11-21');


INSERT INTO `titles` VALUES (68486,'Staff','1994-10-16','9999-01-01'),
(68617,'Senior Engineer','2000-07-13','9999-01-01'),
(68651,'Staff','1998-04-12','9999-01-01'),
(68655,'Staff','1997-09-04','2001-12-21'),
(69487,'Engineer','1998-06-14','9999-01-01'),
(69815,'Engineer','1995-05-14','9999-01-01'),
(69974,'Engineer','1998-09-22','9999-01-01'),
(70049,'Engineer','1988-05-31','1994-05-31'),
(70049,'Senior Engineer','1994-05-31','9999-01-01'),
(70059,'Senior Staff','1991-09-26','9999-01-01');


INSERT INTO `titles` VALUES (70059,'Staff','1986-09-26','1991-09-26'),
(70176,'Engineer','1992-08-19','1998-08-19'),
(70176,'Senior Engineer','1998-08-19','9999-01-01'),
(70473,'Senior Engineer','1998-01-23','9999-01-01'),
(70518,'Engineer','1995-08-10','2000-08-09'),
(70518,'Senior Engineer','2000-08-09','9999-01-01'),
(70632,'Engineer','1988-12-05','1993-12-05'),
(70632,'Senior Engineer','1993-12-05','9999-01-01'),
(70777,'Senior Staff','1997-01-25','9999-01-01'),
(71587,'Senior Staff','2001-05-27','9999-01-01');


INSERT INTO `titles` VALUES (71587,'Staff','1993-05-27','2001-05-27'),
(72103,'Senior Staff','1993-08-10','9999-01-01'),
(72103,'Staff','1985-08-10','1993-08-10'),
(72682,'Engineer','1988-03-04','1994-03-04'),
(72682,'Senior Engineer','1994-03-04','9999-01-01'),
(72856,'Engineer','1988-06-27','1994-06-27'),
(72856,'Senior Engineer','1994-06-27','9999-01-01'),
(73259,'Engineer','1986-02-19','1994-02-19'),
(73259,'Senior Engineer','1994-02-19','9999-01-01'),
(73442,'Assistant Engineer','1989-01-01','1998-01-01');


INSERT INTO `titles` VALUES (73442,'Engineer','1998-01-01','9999-01-01'),
(73468,'Senior Engineer','1990-01-10','9999-01-01'),
(73627,'Senior Staff','1993-01-08','1999-10-21'),
(73627,'Staff','1988-01-09','1993-01-08'),
(73663,'Senior Staff','1996-06-03','9999-01-01'),
(75198,'Engineer','1992-09-21','1996-11-16'),
(75340,'Senior Staff','1992-05-17','1993-07-11'),
(75340,'Staff','1986-05-18','1992-05-17'),
(75445,'Staff','1988-11-02','1996-07-10'),
(75935,'Engineer','1995-11-24','9999-01-01');


INSERT INTO `titles` VALUES (76177,'Technique Leader','1993-08-28','9999-01-01'),
(76190,'Engineer','1993-09-08','2000-09-08'),
(76190,'Senior Engineer','2000-09-08','9999-01-01'),
(76207,'Engineer','1997-11-15','9999-01-01'),
(76366,'Engineer','1992-11-07','1997-11-07'),
(76366,'Senior Engineer','1997-11-07','9999-01-01'),
(76736,'Staff','1997-05-26','1998-06-21'),
(76819,'Engineer','1989-03-14','1995-03-14'),
(76819,'Senior Engineer','1995-03-14','9999-01-01'),
(76914,'Engineer','1985-07-06','1991-07-06');


INSERT INTO `titles` VALUES (76914,'Senior Engineer','1991-07-06','9999-01-01'),
(77315,'Engineer','1986-04-05','1992-04-04'),
(77315,'Senior Engineer','1992-04-04','9999-01-01'),
(78588,'Senior Engineer','1986-08-06','9999-01-01'),
(78618,'Assistant Engineer','1988-03-19','1996-03-19'),
(78618,'Engineer','1996-03-19','9999-01-01'),
(78689,'Engineer','1999-01-02','9999-01-01'),
(79370,'Engineer','1993-09-04','9999-01-01'),
(79446,'Technique Leader','1988-05-10','9999-01-01'),
(79909,'Engineer','1996-07-23','2000-11-22');


INSERT INTO `titles` VALUES (80408,'Technique Leader','1998-02-09','9999-01-01'),
(81146,'Senior Staff','2001-11-06','9999-01-01'),
(81146,'Staff','1992-11-06','2001-11-06'),
(81570,'Engineer','1987-01-21','1993-01-20'),
(81570,'Senior Engineer','1993-01-20','9999-01-01'),
(82526,'Technique Leader','1985-06-18','9999-01-01'),
(82548,'Senior Staff','2001-10-21','9999-01-01'),
(82548,'Staff','1994-10-22','2001-10-21'),
(83159,'Staff','1998-08-19','9999-01-01'),
(83207,'Senior Staff','1995-08-21','9999-01-01');


INSERT INTO `titles` VALUES (83207,'Staff','1990-08-21','1995-08-21'),
(83258,'Engineer','1998-09-23','9999-01-01'),
(83496,'Senior Engineer','1995-12-31','1996-05-22'),
(84573,'Senior Engineer','1989-01-29','9999-01-01'),
(84906,'Staff','1999-06-24','2001-07-27'),
(85579,'Senior Staff','2001-02-27','9999-01-01'),
(85579,'Staff','1994-02-27','2001-02-27'),
(85835,'Engineer','1987-10-08','1996-10-07'),
(85835,'Senior Engineer','1996-10-07','9999-01-01'),
(86321,'Engineer','1994-04-14','9999-01-01');


INSERT INTO `titles` VALUES (87256,'Senior Staff','1993-10-19','9999-01-01'),
(87256,'Staff','1988-10-19','1993-10-19'),
(87370,'Staff','1996-04-20','9999-01-01'),
(87644,'Assistant Engineer','1992-06-09','1997-04-02'),
(87907,'Engineer','1998-04-01','1999-07-26'),
(88114,'Assistant Engineer','1996-03-23','2001-10-11'),
(88148,'Senior Staff','1999-09-12','9999-01-01'),
(88148,'Staff','1991-09-12','1999-09-12'),
(88223,'Engineer','1996-01-19','2002-01-18'),
(88223,'Senior Engineer','2002-01-18','9999-01-01');


INSERT INTO `titles` VALUES (89079,'Engineer','1987-03-15','1989-06-04'),
(89549,'Staff','1999-02-16','9999-01-01'),
(89747,'Engineer','1997-05-22','9999-01-01'),
(89893,'Engineer','1986-12-05','1993-12-05'),
(89893,'Senior Engineer','1993-12-05','9999-01-01'),
(90114,'Senior Staff','1999-10-07','9999-01-01'),
(90132,'Senior Staff','2000-12-13','9999-01-01'),
(90132,'Staff','1995-12-14','2000-12-13'),
(90133,'Staff','1998-04-02','9999-01-01'),
(90212,'Staff','1986-06-10','1987-11-12');


INSERT INTO `titles` VALUES (90726,'Senior Engineer','1998-01-08','9999-01-01'),
(90930,'Senior Staff','1995-01-20','9999-01-01'),
(90930,'Staff','1989-01-20','1995-01-20'),
(91031,'Engineer','1994-09-03','9999-01-01'),
(91159,'Engineer','1998-03-30','9999-01-01'),
(91500,'Engineer','1997-04-13','9999-01-01'),
(91517,'Senior Staff','1997-04-29','9999-01-01'),
(91517,'Staff','1991-04-30','1997-04-29'),
(92069,'Engineer','1989-06-04','1994-11-05'),
(92344,'Senior Engineer','1988-12-19','9999-01-01');


INSERT INTO `titles` VALUES (92541,'Engineer','1995-10-16','2001-10-15'),
(92541,'Senior Engineer','2001-10-15','9999-01-01'),
(92705,'Engineer','1991-10-10','2000-10-09'),
(92705,'Senior Engineer','2000-10-09','9999-01-01'),
(92921,'Senior Engineer','1987-06-04','9999-01-01'),
(93036,'Senior Staff','1993-03-23','9999-01-01'),
(93036,'Staff','1987-03-24','1993-03-23'),
(93445,'Senior Staff','1995-06-06','9999-01-01'),
(93445,'Staff','1986-06-06','1995-06-06'),
(93466,'Staff','1998-09-23','9999-01-01');


INSERT INTO `titles` VALUES (93708,'Staff','1997-07-24','9999-01-01'),
(93877,'Senior Staff','1997-11-06','9999-01-01'),
(93877,'Staff','1989-11-06','1997-11-06'),
(94319,'Staff','1998-03-13','9999-01-01'),
(94699,'Senior Engineer','1998-07-06','1999-11-09'),
(94716,'Senior Staff','1992-07-29','9999-01-01'),
(94716,'Staff','1985-07-29','1992-07-29'),
(95198,'Senior Engineer','1990-11-06','9999-01-01'),
(95278,'Senior Engineer','1990-02-14','9999-01-01'),
(95670,'Staff','1998-06-03','9999-01-01');


INSERT INTO `titles` VALUES (95861,'Staff','1999-06-18','9999-01-01'),
(96318,'Senior Staff','1990-10-23','9999-01-01'),
(96318,'Staff','1985-10-23','1990-10-23'),
(96531,'Technique Leader','1992-11-04','9999-01-01'),
(96575,'Senior Staff','1993-12-01','9999-01-01'),
(96575,'Staff','1987-12-02','1993-12-01'),
(96992,'Engineer','1992-05-19','1998-05-19'),
(96992,'Senior Engineer','1998-05-19','9999-01-01'),
(97195,'Senior Staff','1997-06-04','1998-05-15'),
(97224,'Engineer','1985-06-17','1993-06-17');


INSERT INTO `titles` VALUES (97224,'Senior Engineer','1993-06-17','9999-01-01'),
(97869,'Senior Staff','1995-03-31','9999-01-01'),
(97970,'Senior Engineer','1993-10-01','9999-01-01'),
(98968,'Engineer','1988-08-14','1991-08-25'),
(99121,'Senior Staff','1996-11-09','9999-01-01'),
(99121,'Staff','1990-11-10','1996-11-09'),
(99726,'Staff','1997-03-07','9999-01-01'),
(101129,'Staff','1999-05-04','9999-01-01'),
(101241,'Engineer','1992-05-11','1997-05-11'),
(101241,'Senior Engineer','1997-05-11','9999-01-01');


INSERT INTO `titles` VALUES (101787,'Engineer','1988-07-28','1993-07-28'),
(101787,'Senior Engineer','1993-07-28','9999-01-01'),
(101851,'Assistant Engineer','1991-06-26','1999-06-26'),
(101851,'Engineer','1999-06-26','2001-04-08'),
(102216,'Technique Leader','1997-10-27','9999-01-01'),
(102347,'Senior Engineer','1991-08-03','9999-01-01'),
(102827,'Assistant Engineer','1996-10-23','9999-01-01'),
(103621,'Staff','1997-10-06','9999-01-01'),
(103666,'Engineer','1995-07-26','2000-07-25'),
(103666,'Senior Engineer','2000-07-25','9999-01-01');


INSERT INTO `titles` VALUES (104037,'Assistant Engineer','1987-11-16','1994-11-16'),
(104037,'Engineer','1994-11-16','2001-11-16'),
(104037,'Senior Engineer','2001-11-16','9999-01-01'),
(104080,'Senior Staff','1996-10-07','9999-01-01'),
(104080,'Staff','1988-10-07','1996-10-07'),
(104402,'Staff','1995-06-15','9999-01-01'),
(105153,'Engineer','1997-12-19','9999-01-01'),
(105279,'Engineer','1992-08-03','1997-08-03'),
(105279,'Senior Engineer','1997-08-03','9999-01-01'),
(105337,'Senior Staff','2001-06-28','9999-01-01');


INSERT INTO `titles` VALUES (105337,'Staff','1995-06-29','2001-06-28'),
(106201,'Senior Staff','1997-04-22','9999-01-01'),
(106660,'Technique Leader','1989-05-11','9999-01-01'),
(107072,'Senior Staff','1996-07-07','9999-01-01'),
(107072,'Staff','1989-07-07','1996-07-07'),
(107426,'Engineer','1998-09-28','9999-01-01'),
(108348,'Assistant Engineer','1990-03-16','1996-03-15'),
(108348,'Engineer','1996-03-15','2002-03-15'),
(108348,'Senior Engineer','2002-03-15','9999-01-01'),
(108909,'Engineer','1999-07-05','9999-01-01');


INSERT INTO `titles` VALUES (109562,'Staff','1996-05-22','9999-01-01'),
(109657,'Senior Engineer','1987-06-16','9999-01-01'),
(109725,'Engineer','1990-07-18','1995-07-18'),
(109725,'Senior Engineer','1995-07-18','9999-01-01'),
(109830,'Engineer','1997-05-07','2002-05-07'),
(109830,'Senior Engineer','2002-05-07','9999-01-01'),
(109935,'Assistant Engineer','1994-04-17','2000-04-16'),
(109935,'Engineer','2000-04-16','9999-01-01'),
(200144,'Engineer','1991-01-02','2000-01-02'),
(200144,'Senior Engineer','2000-01-02','9999-01-01');


INSERT INTO `titles` VALUES (200398,'Senior Staff','1999-08-02','9999-01-01'),
(200398,'Staff','1991-08-02','1999-08-02'),
(200424,'Engineer','1991-09-08','2000-09-07'),
(200424,'Senior Engineer','2000-09-07','9999-01-01'),
(200555,'Assistant Engineer','1992-07-15','1997-07-15'),
(200555,'Engineer','1997-07-15','2002-07-15'),
(200555,'Senior Engineer','2002-07-15','9999-01-01'),
(200790,'Senior Staff','1999-01-21','9999-01-01'),
(200790,'Staff','1992-01-21','1999-01-21'),
(200945,'Engineer','1989-11-05','1997-11-05');


INSERT INTO `titles` VALUES (200945,'Senior Engineer','1997-11-05','2002-02-23'),
(201231,'Engineer','1987-05-17','1991-07-22'),
(201749,'Senior Engineer','1988-04-07','9999-01-01'),
(201916,'Engineer','1992-03-30','2001-03-30'),
(201916,'Senior Engineer','2001-03-30','9999-01-01'),
(202250,'Staff','1990-09-18','1997-09-18'),
(203279,'Staff','1995-01-21','9999-01-01'),
(203690,'Staff','1998-09-19','9999-01-01'),
(203957,'Engineer','1997-07-08','9999-01-01'),
(204224,'Assistant Engineer','1988-04-03','1993-04-03');


INSERT INTO `titles` VALUES (204224,'Engineer','1993-04-03','1998-04-03'),
(204224,'Senior Engineer','1998-04-03','9999-01-01'),
(204262,'Staff','1994-04-18','9999-01-01'),
(204377,'Staff','1997-01-17','9999-01-01'),
(204498,'Senior Engineer','1985-04-25','9999-01-01'),
(204609,'Engineer','1989-03-25','1994-03-25'),
(204609,'Senior Engineer','1994-03-25','9999-01-01'),
(205437,'Staff','1996-08-05','1998-06-14'),
(206699,'Technique Leader','1995-06-16','9999-01-01'),
(206719,'Senior Staff','1997-06-12','9999-01-01');


INSERT INTO `titles` VALUES (206719,'Staff','1989-06-12','1997-06-12'),
(207066,'Technique Leader','1988-08-18','9999-01-01'),
(208416,'Engineer','1993-11-17','1998-11-17'),
(208416,'Senior Engineer','1998-11-17','2001-01-31'),
(208916,'Staff','1993-08-23','2000-05-25'),
(209818,'Engineer','1995-07-13','2000-07-12'),
(209818,'Senior Engineer','2000-07-12','9999-01-01'),
(210116,'Engineer','1987-02-04','1995-02-04'),
(210116,'Senior Engineer','1995-02-04','9999-01-01'),
(210172,'Staff','1999-11-25','2000-07-19');


INSERT INTO `titles` VALUES (210406,'Assistant Engineer','1991-04-01','1997-03-31'),
(210406,'Engineer','1997-03-31','9999-01-01'),
(210591,'Engineer','1993-11-18','1999-11-18'),
(210591,'Senior Engineer','1999-11-18','9999-01-01'),
(210613,'Engineer','1998-02-27','9999-01-01'),
(210946,'Engineer','1999-01-25','9999-01-01'),
(211019,'Senior Staff','1992-06-29','1996-03-23'),
(211019,'Staff','1987-06-30','1992-06-29'),
(211187,'Engineer','1991-01-19','1999-01-19'),
(211187,'Senior Engineer','1999-01-19','9999-01-01');


INSERT INTO `titles` VALUES (211453,'Engineer','1991-05-09','1997-05-08'),
(211453,'Senior Engineer','1997-05-08','9999-01-01'),
(211730,'Senior Staff','1995-04-27','9999-01-01'),
(211730,'Staff','1990-04-27','1995-04-27'),
(212017,'Senior Staff','1992-08-31','9999-01-01'),
(212017,'Staff','1987-09-01','1992-08-31'),
(212041,'Technique Leader','1990-09-15','1993-07-01'),
(212148,'Senior Staff','1992-01-15','9999-01-01'),
(212297,'Engineer','1997-04-30','9999-01-01'),
(212862,'Senior Staff','1996-01-25','9999-01-01');


INSERT INTO `titles` VALUES (212862,'Staff','1989-01-24','1996-01-25'),
(213423,'Technique Leader','1997-02-04','9999-01-01'),
(214113,'Senior Engineer','1995-09-16','9999-01-01'),
(214252,'Senior Staff','1990-08-29','9999-01-01'),
(214252,'Staff','1985-08-29','1990-08-29'),
(214605,'Engineer','1988-05-18','1996-05-18'),
(214605,'Senior Engineer','1996-05-18','9999-01-01'),
(214711,'Senior Staff','1998-09-22','9999-01-01'),
(214711,'Staff','1990-09-22','1998-09-22'),
(214963,'Engineer','1989-03-11','1997-03-11');


INSERT INTO `titles` VALUES (214963,'Senior Engineer','1997-03-11','9999-01-01'),
(215016,'Senior Engineer','1999-10-17','9999-01-01'),
(215117,'Senior Staff','1994-06-03','9999-01-01'),
(215433,'Engineer','1992-03-29','1999-03-30'),
(215433,'Senior Engineer','1999-03-30','9999-01-01'),
(215550,'Staff','1988-11-23','1988-12-04'),
(215601,'Senior Staff','1998-06-13','9999-01-01'),
(216156,'Senior Staff','1997-03-01','9999-01-01'),
(216156,'Staff','1988-03-01','1997-03-01'),
(216595,'Technique Leader','1999-03-24','9999-01-01');


INSERT INTO `titles` VALUES (216637,'Engineer','1994-10-02','2001-10-02'),
(216852,'Senior Staff','2000-04-22','9999-01-01'),
(216852,'Staff','1992-04-22','2000-04-22'),
(217002,'Engineer','1992-09-07','1999-09-08'),
(217002,'Senior Engineer','1999-09-08','9999-01-01'),
(217532,'Senior Staff','1999-05-21','9999-01-01'),
(217752,'Technique Leader','1990-06-05','9999-01-01'),
(217782,'Technique Leader','1992-06-02','9999-01-01'),
(217783,'Engineer','1997-01-22','9999-01-01'),
(217840,'Engineer','1986-08-24','1995-08-24');


INSERT INTO `titles` VALUES (217840,'Senior Engineer','1995-08-24','9999-01-01'),
(218301,'Senior Engineer','1989-09-28','9999-01-01'),
(219242,'Engineer','1997-02-13','1997-11-11'),
(219244,'Senior Staff','1997-04-22','9999-01-01'),
(219244,'Staff','1992-04-22','1997-04-22'),
(219301,'Engineer','1988-11-01','1996-11-01'),
(219301,'Senior Engineer','1996-11-01','9999-01-01'),
(219460,'Engineer','1990-01-11','1997-01-11'),
(219460,'Senior Engineer','1997-01-11','9999-01-01'),
(219998,'Senior Staff','1999-10-18','9999-01-01');


INSERT INTO `titles` VALUES (219998,'Staff','1990-10-18','1999-10-18'),
(220007,'Engineer','1985-12-06','1990-12-06'),
(220007,'Senior Engineer','1990-12-06','9999-01-01'),
(220063,'Staff','1997-10-17','9999-01-01'),
(220622,'Technique Leader','1985-08-30','9999-01-01'),
(220844,'Senior Staff','1992-01-27','9999-01-01'),
(220844,'Staff','1987-01-27','1992-01-27'),
(221223,'Senior Staff','1991-08-24','1995-07-20'),
(221223,'Staff','1986-08-24','1991-08-24'),
(221336,'Engineer','1993-02-28','2000-02-29');


INSERT INTO `titles` VALUES (221336,'Senior Engineer','2000-02-29','9999-01-01'),
(221957,'Engineer','1991-07-04','1999-07-04'),
(221957,'Senior Engineer','1999-07-04','9999-01-01'),
(222025,'Senior Engineer','1992-08-19','1997-08-09'),
(222357,'Staff','1997-10-28','2000-08-11'),
(222429,'Engineer','1994-12-30','2000-12-29'),
(222429,'Senior Engineer','2000-12-29','9999-01-01'),
(222918,'Senior Staff','1994-01-08','9999-01-01'),
(222918,'Staff','1987-01-08','1994-01-08'),
(223063,'Senior Engineer','1996-04-22','9999-01-01');


INSERT INTO `titles` VALUES (223114,'Senior Staff','1999-10-09','9999-01-01'),
(223290,'Engineer','1998-09-03','9999-01-01'),
(223906,'Staff','1996-11-24','9999-01-01'),
(224094,'Engineer','1994-06-08','2000-06-07'),
(224094,'Senior Engineer','2000-06-07','9999-01-01'),
(224758,'Engineer','1996-12-10','2001-08-19'),
(225042,'Engineer','1998-07-26','9999-01-01'),
(225116,'Engineer','1994-12-01','9999-01-01'),
(225178,'Senior Staff','1986-08-18','1992-07-19'),
(225409,'Senior Staff','1999-04-27','9999-01-01');


INSERT INTO `titles` VALUES (225409,'Staff','1991-04-27','1999-04-27'),
(225436,'Senior Staff','1998-09-03','9999-01-01'),
(225436,'Staff','1990-09-03','1998-09-03'),
(225517,'Senior Engineer','1995-01-18','1999-09-02'),
(225734,'Staff','1990-11-10','1992-06-20'),
(225974,'Senior Staff','1996-09-24','9999-01-01'),
(225974,'Staff','1987-09-25','1996-09-24'),
(226262,'Senior Engineer','1990-11-24','9999-01-01'),
(226516,'Engineer','1987-01-05','1994-01-05'),
(226516,'Senior Engineer','1994-01-05','9999-01-01');


INSERT INTO `titles` VALUES (227299,'Senior Engineer','1988-06-18','9999-01-01'),
(227376,'Staff','1993-08-05','1997-04-06'),
(227537,'Senior Staff','1999-02-27','9999-01-01'),
(227537,'Staff','1993-02-27','1999-02-27'),
(227761,'Engineer','1998-06-14','9999-01-01'),
(227830,'Engineer','1991-09-15','1998-09-15'),
(227830,'Senior Engineer','1998-09-15','9999-01-01'),
(227894,'Assistant Engineer','1989-06-10','1998-06-10'),
(227894,'Engineer','1998-06-10','9999-01-01'),
(228005,'Engineer','1992-08-29','1995-05-07');


INSERT INTO `titles` VALUES (228051,'Technique Leader','1988-12-18','9999-01-01'),
(228327,'Senior Staff','1996-10-22','9999-01-01'),
(228327,'Staff','1989-10-22','1996-10-22'),
(228344,'Engineer','1999-07-01','2000-09-04'),
(228369,'Engineer','1998-05-17','9999-01-01'),
(228686,'Senior Engineer','1998-09-22','9999-01-01'),
(229063,'Engineer','1991-07-31','1999-07-31'),
(229063,'Senior Engineer','1999-07-31','9999-01-01'),
(229279,'Staff','1998-05-08','9999-01-01'),
(229600,'Senior Staff','1994-08-28','2002-03-23');


INSERT INTO `titles` VALUES (229600,'Staff','1987-08-28','1994-08-28'),
(229623,'Engineer','1998-10-14','9999-01-01'),
(229949,'Senior Staff','1994-06-27','9999-01-01'),
(230087,'Engineer','1994-02-18','2000-02-18'),
(230087,'Senior Engineer','2000-02-18','9999-01-01'),
(230099,'Senior Staff','2000-09-24','9999-01-01'),
(230099,'Staff','1992-09-24','2000-09-24'),
(230343,'Staff','1998-07-28','2002-07-26'),
(230627,'Senior Staff','1992-01-29','9999-01-01'),
(230627,'Staff','1986-01-29','1992-01-29');


INSERT INTO `titles` VALUES (230801,'Senior Staff','1995-10-23','9999-01-01'),
(230801,'Staff','1988-10-22','1995-10-23'),
(230946,'Senior Staff','1996-05-18','9999-01-01'),
(230946,'Staff','1988-05-18','1996-05-18'),
(231075,'Engineer','1988-02-05','1994-02-04'),
(231240,'Engineer','1999-01-18','9999-01-01'),
(231635,'Technique Leader','1985-03-21','9999-01-01'),
(231783,'Senior Staff','1998-06-07','9999-01-01'),
(231783,'Staff','1993-06-07','1998-06-07'),
(231789,'Senior Engineer','1987-01-18','9999-01-01');


INSERT INTO `titles` VALUES (232238,'Engineer','1987-10-31','1994-08-09'),
(232305,'Engineer','1992-09-04','2001-09-04'),
(232305,'Senior Engineer','2001-09-04','9999-01-01'),
(232347,'Senior Engineer','1996-03-03','9999-01-01'),
(233523,'Senior Staff','1990-03-11','9999-01-01'),
(233523,'Staff','1985-03-11','1990-03-11'),
(234321,'Staff','1996-08-03','2000-07-26'),
(235427,'Engineer','1991-03-29','1999-03-29'),
(235427,'Senior Engineer','1999-03-29','2000-01-02'),
(235867,'Staff','1991-06-30','1997-06-25');


INSERT INTO `titles` VALUES (236372,'Engineer','1990-05-06','1996-05-05'),
(236372,'Senior Engineer','1996-05-05','9999-01-01'),
(236692,'Staff','1996-03-04','9999-01-01'),
(236927,'Staff','1996-10-07','2001-08-22'),
(237316,'Senior Staff','1998-07-08','9999-01-01'),
(237316,'Staff','1992-07-08','1998-07-08'),
(237728,'Staff','1992-10-07','1995-03-13'),
(238067,'Engineer','1988-05-20','1993-05-20'),
(238067,'Senior Engineer','1993-05-20','1997-07-12'),
(238379,'Engineer','1994-12-03','9999-01-01');


INSERT INTO `titles` VALUES (238632,'Senior Staff','1998-11-21','2002-04-01'),
(238632,'Staff','1992-11-21','1998-11-21'),
(238661,'Staff','1997-04-02','1998-06-18'),
(238678,'Senior Staff','1998-10-10','9999-01-01'),
(238678,'Staff','1991-10-10','1998-10-10'),
(238726,'Staff','1995-05-28','9999-01-01'),
(238849,'Senior Engineer','1999-11-23','9999-01-01'),
(238924,'Staff','1989-06-14','1997-10-09'),
(238942,'Engineer','1996-03-28','9999-01-01'),
(239017,'Engineer','1991-12-02','1996-12-01');


INSERT INTO `titles` VALUES (239017,'Senior Engineer','1996-12-01','9999-01-01'),
(239018,'Technique Leader','1999-06-08','9999-01-01'),
(239156,'Staff','1999-09-06','9999-01-01'),
(239234,'Senior Staff','1992-01-26','9999-01-01'),
(239234,'Staff','1987-01-26','1992-01-26'),
(239243,'Engineer','1995-09-12','9999-01-01'),
(239859,'Senior Staff','1988-10-24','1990-09-11'),
(239869,'Staff','1996-06-02','9999-01-01'),
(239949,'Engineer','1990-11-26','1998-11-26'),
(239949,'Senior Engineer','1998-11-26','9999-01-01');


INSERT INTO `titles` VALUES (239990,'Technique Leader','1992-09-01','9999-01-01'),
(240051,'Senior Staff','1991-05-25','2000-11-16'),
(240051,'Staff','1985-05-25','1991-05-25'),
(240349,'Senior Staff','1999-06-22','9999-01-01'),
(240692,'Staff','1998-08-07','1999-10-13'),
(241277,'Engineer','1995-11-19','2001-11-18'),
(241277,'Senior Engineer','2001-11-18','9999-01-01'),
(241506,'Senior Staff','1994-09-18','9999-01-01'),
(241506,'Staff','1987-09-18','1994-09-18'),
(241576,'Engineer','1990-09-06','1996-09-05');


INSERT INTO `titles` VALUES (241576,'Senior Engineer','1996-09-05','9999-01-01'),
(242014,'Engineer','1985-03-07','1994-03-07'),
(242014,'Senior Engineer','1994-03-07','9999-01-01'),
(242432,'Senior Staff','1992-10-29','9999-01-01'),
(242432,'Staff','1985-10-29','1992-10-29'),
(242711,'Engineer','1992-01-04','1997-01-03'),
(242711,'Senior Engineer','1997-01-03','9999-01-01'),
(242764,'Engineer','1998-11-09','9999-01-01'),
(243072,'Engineer','1991-10-24','1997-10-23'),
(243072,'Senior Engineer','1997-10-23','9999-01-01');


INSERT INTO `titles` VALUES (243329,'Engineer','1992-03-07','1999-03-08'),
(243329,'Senior Engineer','1999-03-08','2001-09-07'),
(243794,'Engineer','1989-11-25','1995-11-25'),
(243794,'Senior Engineer','1995-11-25','1997-01-26'),
(243944,'Engineer','1987-09-11','1992-09-10'),
(243944,'Senior Engineer','1992-09-10','9999-01-01'),
(244170,'Staff','1989-12-20','1995-05-18'),
(244809,'Staff','1998-12-06','9999-01-01'),
(244820,'Engineer','1987-04-13','1994-04-13'),
(244820,'Senior Engineer','1994-04-13','9999-01-01');


INSERT INTO `titles` VALUES (244941,'Technique Leader','1990-03-17','9999-01-01'),
(245036,'Senior Engineer','1990-03-21','9999-01-01'),
(245367,'Senior Staff','1998-10-26','9999-01-01'),
(245367,'Staff','1993-10-27','1998-10-26'),
(245518,'Senior Engineer','2001-01-17','9999-01-01'),
(245660,'Senior Staff','1998-02-06','9999-01-01'),
(245660,'Staff','1989-02-06','1998-02-06'),
(245714,'Senior Staff','1993-02-22','9999-01-01'),
(245714,'Staff','1987-02-23','1993-02-22'),
(245810,'Senior Staff','1986-03-08','9999-01-01');


INSERT INTO `titles` VALUES (245828,'Staff','1997-09-26','9999-01-01'),
(245862,'Engineer','1998-06-19','9999-01-01'),
(245978,'Senior Staff','2002-06-24','9999-01-01'),
(245978,'Staff','1993-06-24','2002-06-24'),
(246013,'Senior Staff','1993-10-27','9999-01-01'),
(246013,'Staff','1987-10-28','1993-10-27'),
(246044,'Technique Leader','1992-10-09','9999-01-01'),
(246214,'Engineer','1997-05-22','9999-01-01'),
(246317,'Staff','1995-12-26','9999-01-01'),
(246597,'Engineer','1996-01-09','9999-01-01');


INSERT INTO `titles` VALUES (247697,'Engineer','1992-11-27','1995-11-11'),
(248201,'Senior Staff','1998-04-01','9999-01-01'),
(248201,'Staff','1991-04-01','1998-04-01'),
(248265,'Engineer','1999-09-22','2001-02-15'),
(248348,'Engineer','1988-10-28','1996-10-27'),
(248348,'Senior Engineer','1996-10-27','9999-01-01'),
(248761,'Engineer','1994-06-13','2001-06-13'),
(248761,'Senior Engineer','2001-06-13','9999-01-01'),
(249051,'Senior Staff','1998-03-13','9999-01-01'),
(249051,'Staff','1993-03-13','1998-03-13');


INSERT INTO `titles` VALUES (249391,'Senior Staff','1998-02-12','9999-01-01'),
(249528,'Senior Engineer','1988-05-23','9999-01-01'),
(249779,'Senior Engineer','1990-01-16','9999-01-01'),
(250401,'Senior Staff','1992-12-14','1997-01-23'),
(250645,'Senior Staff','1996-07-28','9999-01-01'),
(250645,'Staff','1989-07-28','1996-07-28'),
(250986,'Engineer','1989-02-25','1997-02-25'),
(250986,'Senior Engineer','1997-02-25','9999-01-01'),
(251025,'Engineer','1996-05-29','9999-01-01'),
(251085,'Engineer','1987-09-14','1993-09-13');


INSERT INTO `titles` VALUES (251085,'Senior Engineer','1993-09-13','9999-01-01'),
(251291,'Senior Staff','1986-06-19','2001-03-01'),
(251698,'Engineer','1995-04-13','2002-04-13'),
(251698,'Senior Engineer','2002-04-13','9999-01-01'),
(252679,'Engineer','1985-09-21','1991-09-21'),
(252679,'Senior Engineer','1991-09-21','9999-01-01'),
(252995,'Engineer','1999-01-18','9999-01-01'),
(253139,'Engineer','1997-06-24','9999-01-01'),
(253685,'Senior Engineer','1999-03-19','9999-01-01'),
(253785,'Senior Staff','1987-02-16','9999-01-01');


INSERT INTO `titles` VALUES (253854,'Senior Staff','1992-06-21','2001-10-29'),
(254240,'Engineer','1995-12-18','9999-01-01'),
(254984,'Engineer','1993-01-13','2001-01-13'),
(254984,'Senior Engineer','2001-01-13','9999-01-01'),
(255294,'Staff','1998-02-26','9999-01-01'),
(255536,'Senior Staff','1998-12-10','9999-01-01'),
(255536,'Staff','1991-12-10','1998-12-10'),
(255874,'Technique Leader','1994-06-25','9999-01-01'),
(256447,'Senior Staff','1989-07-30','9999-01-01'),
(256505,'Staff','1999-05-14','2001-05-25');


INSERT INTO `titles` VALUES (256535,'Senior Staff','1994-12-15','9999-01-01'),
(256535,'Staff','1987-12-15','1994-12-15'),
(256936,'Engineer','1986-10-02','1992-10-01'),
(256936,'Senior Engineer','1992-10-01','9999-01-01'),
(256982,'Senior Staff','1993-06-18','9999-01-01'),
(256982,'Staff','1988-06-18','1993-06-18'),
(257260,'Engineer','1998-07-04','9999-01-01'),
(257431,'Assistant Engineer','1992-12-06','1995-04-16'),
(257760,'Senior Staff','1987-07-21','1989-12-15'),
(258092,'Assistant Engineer','1999-08-23','9999-01-01');


INSERT INTO `titles` VALUES (258451,'Senior Staff','1990-02-09','9999-01-01'),
(258582,'Senior Staff','2001-04-02','9999-01-01'),
(258582,'Staff','1995-04-03','2001-04-02'),
(259273,'Senior Engineer','1989-12-01','9999-01-01'),
(259293,'Senior Staff','1996-12-23','9999-01-01'),
(259407,'Senior Staff','1986-10-14','9999-01-01'),
(259922,'Engineer','1992-03-04','1997-03-04'),
(259983,'Senior Staff','1996-08-15','9999-01-01'),
(259983,'Staff','1988-08-15','1996-08-15'),
(260083,'Staff','1997-12-22','1999-02-27');


INSERT INTO `titles` VALUES (260516,'Engineer','1985-08-31','1994-08-31'),
(260516,'Senior Engineer','1994-08-31','9999-01-01'),
(260734,'Assistant Engineer','1993-03-14','1998-03-14'),
(260734,'Engineer','1998-03-14','9999-01-01'),
(261201,'Engineer','1986-03-08','1993-03-08'),
(261201,'Senior Engineer','1993-03-08','9999-01-01'),
(261253,'Engineer','1994-10-06','1999-10-06'),
(261253,'Senior Engineer','1999-10-06','9999-01-01'),
(261592,'Assistant Engineer','1996-01-28','9999-01-01'),
(262130,'Engineer','1995-08-02','2000-08-01');


INSERT INTO `titles` VALUES (262130,'Senior Engineer','2000-08-01','9999-01-01'),
(262725,'Engineer','1986-07-24','1995-07-24'),
(262725,'Senior Engineer','1995-07-24','9999-01-01'),
(262898,'Engineer','1996-07-18','1997-03-29'),
(263049,'Senior Staff','1996-06-25','2001-06-11'),
(263049,'Staff','1990-06-26','1996-06-25'),
(263405,'Engineer','1990-10-19','1998-10-19'),
(263405,'Senior Engineer','1998-10-19','1998-12-15'),
(263531,'Senior Staff','2001-02-23','9999-01-01'),
(263531,'Staff','1994-02-23','2001-02-23');


INSERT INTO `titles` VALUES (264395,'Assistant Engineer','1990-01-01','1996-01-01'),
(264395,'Engineer','1996-01-01','2001-12-31'),
(264395,'Senior Engineer','2001-12-31','9999-01-01'),
(264433,'Engineer','1998-08-22','2001-09-20'),
(264558,'Senior Staff','1992-07-23','9999-01-01'),
(264558,'Staff','1986-07-24','1992-07-23'),
(264698,'Senior Staff','1994-06-28','9999-01-01'),
(264873,'Senior Staff','1996-09-15','9999-01-01'),
(264873,'Staff','1987-09-16','1996-09-15'),
(264957,'Engineer','1995-10-07','1995-11-22');


INSERT INTO `titles` VALUES (265364,'Engineer','1994-05-04','1995-08-15'),
(265414,'Senior Staff','2001-05-01','9999-01-01'),
(265414,'Staff','1993-05-01','2001-05-01'),
(265743,'Senior Staff','1993-06-29','9999-01-01'),
(265743,'Staff','1988-06-29','1993-06-29'),
(265844,'Senior Engineer','1990-11-10','9999-01-01'),
(265997,'Engineer','1991-09-26','1993-08-26'),
(266331,'Senior Engineer','1985-11-17','1992-01-21'),
(266792,'Engineer','1997-07-04','2002-07-04'),
(266792,'Senior Engineer','2002-07-04','9999-01-01');


INSERT INTO `titles` VALUES (267595,'Engineer','1993-11-09','1998-02-01'),
(268302,'Engineer','1991-11-05','1996-11-04'),
(268302,'Senior Engineer','1996-11-04','9999-01-01'),
(268680,'Staff','1996-07-18','9999-01-01'),
(268927,'Senior Engineer','1999-05-25','9999-01-01'),
(268956,'Engineer','1992-10-13','1997-10-13'),
(268956,'Senior Engineer','1997-10-13','9999-01-01'),
(268965,'Senior Staff','1988-07-12','9999-01-01'),
(269464,'Engineer','1998-08-23','9999-01-01'),
(269927,'Engineer','1991-05-29','1999-05-29');


INSERT INTO `titles` VALUES (269927,'Senior Engineer','1999-05-29','9999-01-01'),
(269993,'Staff','1995-11-15','1996-12-28'),
(270041,'Engineer','1990-07-19','1992-04-28'),
(270377,'Assistant Engineer','1999-12-05','9999-01-01'),
(270989,'Staff','1999-11-23','9999-01-01'),
(271337,'Engineer','1989-04-21','1997-04-21'),
(271337,'Senior Engineer','1997-04-21','9999-01-01'),
(271603,'Senior Staff','2002-05-12','9999-01-01'),
(271603,'Staff','1996-05-12','2002-05-12'),
(272079,'Assistant Engineer','1996-09-20','9999-01-01');


INSERT INTO `titles` VALUES (272238,'Engineer','1997-06-11','9999-01-01'),
(272888,'Senior Staff','1996-11-19','9999-01-01'),
(272888,'Staff','1989-11-19','1996-11-19'),
(273095,'Senior Staff','1999-08-20','9999-01-01'),
(273095,'Staff','1994-08-20','1999-08-20'),
(273215,'Senior Staff','1985-07-13','1993-02-23'),
(273405,'Engineer','1993-10-04','2000-10-04'),
(273405,'Senior Engineer','2000-10-04','9999-01-01'),
(273453,'Engineer','1992-04-13','1999-04-14'),
(273453,'Senior Engineer','1999-04-14','9999-01-01');


INSERT INTO `titles` VALUES (273593,'Senior Engineer','1989-09-12','9999-01-01'),
(274036,'Senior Engineer','1998-09-08','9999-01-01'),
(274136,'Engineer','1998-06-03','9999-01-01'),
(274270,'Engineer','1990-11-18','1998-11-18'),
(274270,'Senior Engineer','1998-11-18','9999-01-01'),
(274285,'Senior Staff','2001-04-25','9999-01-01'),
(274725,'Engineer','1998-11-05','2001-07-29'),
(274855,'Senior Staff','1993-08-20','2000-10-26'),
(274855,'Staff','1985-08-20','1993-08-20'),
(275711,'Senior Staff','1998-01-03','2001-04-02');


INSERT INTO `titles` VALUES (275711,'Staff','1992-01-04','1998-01-03'),
(276056,'Engineer','1993-11-27','2001-11-27'),
(276056,'Senior Engineer','2001-11-27','9999-01-01'),
(276204,'Staff','1996-09-10','9999-01-01'),
(276344,'Assistant Engineer','1998-04-24','9999-01-01'),
(276448,'Staff','1996-01-23','1997-11-19'),
(276923,'Engineer','1994-03-16','1999-03-16'),
(276923,'Senior Engineer','1999-03-16','9999-01-01'),
(277230,'Staff','1999-09-20','9999-01-01'),
(277479,'Senior Engineer','1997-04-17','9999-01-01');


INSERT INTO `titles` VALUES (277868,'Engineer','1985-10-16','1991-10-16'),
(277868,'Senior Engineer','1991-10-16','9999-01-01'),
(278168,'Senior Engineer','1988-06-06','9999-01-01'),
(278325,'Senior Engineer','1999-07-29','9999-01-01'),
(278365,'Senior Staff','1991-05-30','9999-01-01'),
(278365,'Staff','1985-05-30','1991-05-30'),
(278411,'Engineer','1997-12-08','9999-01-01'),
(278604,'Staff','1995-07-05','1999-06-03'),
(278879,'Engineer','1998-12-28','9999-01-01'),
(279744,'Engineer','1996-02-29','9999-01-01');


INSERT INTO `titles` VALUES (280203,'Engineer','1991-12-04','1998-12-04'),
(280203,'Senior Engineer','1998-12-04','9999-01-01'),
(280307,'Engineer','1994-08-01','1999-08-01'),
(280307,'Senior Engineer','1999-08-01','9999-01-01'),
(280920,'Engineer','1995-05-21','2001-05-20'),
(280920,'Senior Engineer','2001-05-20','9999-01-01'),
(281215,'Senior Staff','1998-10-28','9999-01-01'),
(282010,'Senior Staff','1999-06-15','9999-01-01'),
(282010,'Staff','1993-06-15','1999-06-15'),
(282407,'Assistant Engineer','1995-06-13','9999-01-01');


INSERT INTO `titles` VALUES (282957,'Engineer','1994-09-08','2000-09-07'),
(282957,'Senior Engineer','2000-09-07','9999-01-01'),
(283297,'Senior Staff','1994-06-24','9999-01-01'),
(283297,'Staff','1985-06-24','1994-06-24'),
(283456,'Senior Staff','1993-05-20','9999-01-01'),
(283456,'Staff','1987-05-21','1993-05-20'),
(284077,'Senior Staff','1995-06-14','9999-01-01'),
(284077,'Staff','1989-06-14','1995-06-14'),
(284398,'Technique Leader','1992-02-04','2000-11-10'),
(284426,'Senior Engineer','1990-11-18','9999-01-01');


INSERT INTO `titles` VALUES (285405,'Engineer','1998-01-03','9999-01-01'),
(285729,'Engineer','1986-08-19','1991-08-19'),
(285729,'Senior Engineer','1991-08-19','9999-01-01'),
(286006,'Senior Staff','1998-03-13','9999-01-01'),
(286240,'Engineer','1990-06-09','1995-06-09'),
(286240,'Senior Engineer','1995-06-09','9999-01-01'),
(287571,'Senior Staff','1994-07-09','9999-01-01'),
(287571,'Staff','1986-07-09','1994-07-09'),
(287914,'Technique Leader','1986-09-27','9999-01-01'),
(288184,'Engineer','1994-11-19','2000-11-18');


INSERT INTO `titles` VALUES (288184,'Senior Engineer','2000-11-18','9999-01-01'),
(288733,'Senior Staff','1992-05-03','9999-01-01'),
(289181,'Senior Engineer','1987-02-12','9999-01-01'),
(289576,'Engineer','1990-01-21','1997-01-21'),
(289576,'Senior Engineer','1997-01-21','2001-08-09'),
(289652,'Staff','1988-05-10','1993-04-16'),
(289766,'Staff','1999-12-24','9999-01-01'),
(289866,'Engineer','1999-04-21','9999-01-01'),
(290282,'Engineer','1995-08-27','2001-08-26'),
(290282,'Senior Engineer','2001-08-26','9999-01-01');


INSERT INTO `titles` VALUES (290932,'Engineer','1988-01-26','1993-01-25'),
(290932,'Senior Engineer','1993-01-25','9999-01-01'),
(291158,'Senior Engineer','1999-10-07','9999-01-01'),
(291253,'Staff','1987-10-11','1992-05-19'),
(293383,'Engineer','1987-01-16','1988-01-02'),
(293448,'Engineer','1987-02-10','1993-02-09'),
(293448,'Senior Engineer','1993-02-09','1999-08-30'),
(293551,'Assistant Engineer','1986-04-18','1991-04-18'),
(293551,'Engineer','1991-04-18','1994-01-20'),
(293714,'Engineer','1994-03-28','1999-03-28');


INSERT INTO `titles` VALUES (293714,'Senior Engineer','1999-03-28','9999-01-01'),
(294057,'Staff','1997-10-24','9999-01-01'),
(294261,'Engineer','1991-05-04','2000-05-03'),
(294261,'Senior Engineer','2000-05-03','9999-01-01'),
(295755,'Engineer','1989-04-02','1998-04-02'),
(295755,'Senior Engineer','1998-04-02','9999-01-01'),
(296014,'Assistant Engineer','1999-04-14','2000-08-26'),
(296500,'Senior Engineer','1993-02-03','9999-01-01'),
(296744,'Engineer','1985-08-21','1992-08-21'),
(296744,'Senior Engineer','1992-08-21','1993-06-13');


INSERT INTO `titles` VALUES (297742,'Senior Engineer','1987-05-30','1989-01-15'),
(298437,'Senior Staff','1991-06-05','9999-01-01'),
(298667,'Staff','1998-10-20','2001-08-30'),
(298675,'Engineer','1994-09-02','9999-01-01'),
(298735,'Staff','1998-10-25','2000-05-03'),
(298747,'Engineer','1989-10-21','1994-10-21'),
(298747,'Senior Engineer','1994-10-21','9999-01-01'),
(298757,'Senior Staff','1988-06-28','9999-01-01'),
(298919,'Engineer','1985-02-20','1991-02-20'),
(298919,'Senior Engineer','1991-02-20','9999-01-01');


INSERT INTO `titles` VALUES (299167,'Senior Staff','1999-12-24','9999-01-01'),
(299167,'Staff','1994-12-24','1999-12-24'),
(299210,'Staff','1996-10-22','9999-01-01'),
(299271,'Senior Staff','1995-04-13','9999-01-01'),
(299271,'Staff','1989-04-13','1995-04-13'),
(299403,'Staff','1998-09-19','9999-01-01'),
(299405,'Staff','1997-04-20','9999-01-01'),
(299850,'Engineer','1994-06-02','2001-06-02'),
(299850,'Senior Engineer','2001-06-02','9999-01-01'),
(400054,'Senior Staff','1999-10-02','9999-01-01');


INSERT INTO `titles` VALUES (400538,'Staff','1997-07-29','1999-10-09'),
(400763,'Senior Engineer','1997-08-12','9999-01-01'),
(400796,'Engineer','1996-05-30','9999-01-01'),
(401085,'Engineer','1987-05-18','1994-05-18'),
(401085,'Senior Engineer','1994-05-18','9999-01-01'),
(401291,'Engineer','1987-11-02','1993-11-01'),
(401291,'Senior Engineer','1993-11-01','9999-01-01'),
(401704,'Engineer','1991-05-22','1999-05-22'),
(401704,'Senior Engineer','1999-05-22','9999-01-01'),
(401929,'Senior Staff','1992-03-02','9999-01-01');


INSERT INTO `titles` VALUES (401929,'Staff','1985-03-02','1992-03-02'),
(402392,'Senior Staff','2000-03-20','9999-01-01'),
(402392,'Staff','1995-03-21','2000-03-20'),
(403112,'Staff','1985-12-09','1994-12-09'),
(403849,'Engineer','1990-06-21','1993-10-13'),
(404174,'Assistant Engineer','1995-07-31','1999-02-09'),
(404441,'Engineer','1994-10-04','9999-01-01'),
(404669,'Staff','1995-03-02','1998-06-11'),
(406556,'Senior Staff','2000-11-09','9999-01-01'),
(406556,'Staff','1993-11-09','2000-11-09');


INSERT INTO `titles` VALUES (407401,'Senior Engineer','1999-01-14','9999-01-01'),
(407481,'Senior Staff','2000-07-18','9999-01-01'),
(407481,'Staff','1991-07-19','2000-07-18'),
(407937,'Senior Staff','1999-01-13','9999-01-01'),
(408371,'Senior Staff','1991-11-13','9999-01-01'),
(408371,'Staff','1986-11-13','1991-11-13'),
(408886,'Senior Staff','1991-11-19','9999-01-01'),
(408886,'Staff','1985-11-19','1991-11-19'),
(409162,'Senior Staff','1997-07-22','9999-01-01'),
(409162,'Staff','1988-07-22','1997-07-22');


INSERT INTO `titles` VALUES (409376,'Engineer','1997-12-13','2000-01-13'),
(409509,'Senior Staff','1988-03-01','9999-01-01'),
(409522,'Assistant Engineer','1992-05-10','2001-05-10'),
(409522,'Engineer','2001-05-10','9999-01-01'),
(409928,'Staff','1993-05-20','2000-07-26'),
(410062,'Senior Engineer','1991-01-24','9999-01-01'),
(410236,'Engineer','1988-01-05','1994-01-04'),
(410236,'Senior Engineer','1994-01-04','1999-01-06'),
(410301,'Senior Staff','2000-12-21','9999-01-01'),
(410301,'Staff','1993-12-21','2000-12-21');


INSERT INTO `titles` VALUES (410949,'Staff','1992-02-06','1997-10-30'),
(411006,'Senior Staff','1993-02-14','9999-01-01'),
(411006,'Staff','1987-02-15','1993-02-14'),
(411065,'Senior Engineer','1998-07-17','9999-01-01'),
(411670,'Senior Staff','1998-12-04','9999-01-01'),
(411670,'Staff','1992-12-04','1998-12-04'),
(411880,'Engineer','1997-07-08','9999-01-01'),
(411954,'Assistant Engineer','1996-07-27','2001-07-27'),
(411954,'Engineer','2001-07-27','9999-01-01'),
(411998,'Senior Staff','1998-09-09','9999-01-01');


INSERT INTO `titles` VALUES (411998,'Staff','1993-09-09','1998-09-09'),
(412876,'Engineer','1992-01-02','1997-01-01'),
(412876,'Senior Engineer','1997-01-01','9999-01-01'),
(413034,'Technique Leader','1988-11-30','9999-01-01'),
(413054,'Staff','1997-12-16','9999-01-01'),
(413061,'Senior Engineer','1993-10-17','9999-01-01'),
(413392,'Technique Leader','1990-04-27','9999-01-01'),
(413675,'Staff','1997-06-22','1999-04-06'),
(413880,'Senior Engineer','1994-02-22','9999-01-01'),
(414068,'Assistant Engineer','1995-07-04','2000-07-03');


INSERT INTO `titles` VALUES (414068,'Engineer','2000-07-03','9999-01-01'),
(414091,'Engineer','1997-08-19','9999-01-01'),
(414156,'Engineer','1998-12-04','9999-01-01'),
(414922,'Engineer','1987-06-05','1992-06-04'),
(414922,'Senior Engineer','1992-06-04','1997-11-04'),
(415340,'Engineer','1991-08-03','1996-08-02'),
(415340,'Senior Engineer','1996-08-02','9999-01-01'),
(415511,'Senior Staff','1986-06-11','9999-01-01'),
(415796,'Senior Engineer','1988-02-16','9999-01-01'),
(415832,'Staff','1998-10-12','9999-01-01');


INSERT INTO `titles` VALUES (416009,'Senior Staff','1994-05-04','9999-01-01'),
(416009,'Staff','1988-05-04','1994-05-04'),
(416137,'Senior Staff','1999-07-16','9999-01-01'),
(416636,'Technique Leader','1995-02-01','9999-01-01'),
(417262,'Senior Staff','1987-06-20','9999-01-01'),
(417486,'Technique Leader','1987-01-10','9999-01-01'),
(417525,'Senior Staff','1994-02-10','1994-07-22'),
(417525,'Staff','1988-02-11','1994-02-10'),
(417539,'Engineer','1996-05-20','9999-01-01'),
(417812,'Staff','1998-04-23','9999-01-01');


INSERT INTO `titles` VALUES (417961,'Engineer','1986-07-28','1991-07-28'),
(417961,'Senior Engineer','1991-07-28','9999-01-01'),
(418171,'Engineer','1993-01-13','1999-01-13'),
(418171,'Senior Engineer','1999-01-13','9999-01-01'),
(419663,'Technique Leader','1992-04-24','9999-01-01'),
(419770,'Engineer','1988-04-11','1994-04-11'),
(419770,'Senior Engineer','1994-04-11','9999-01-01'),
(419925,'Engineer','1996-09-22','9999-01-01'),
(420207,'Assistant Engineer','1992-04-05','1999-04-06'),
(420207,'Engineer','1999-04-06','9999-01-01');


INSERT INTO `titles` VALUES (420252,'Technique Leader','1985-07-15','9999-01-01'),
(420410,'Staff','1993-11-03','2000-03-02'),
(420997,'Technique Leader','1985-07-30','9999-01-01'),
(421163,'Senior Staff','2002-06-02','9999-01-01'),
(421163,'Staff','1995-06-02','2002-06-02'),
(421184,'Assistant Engineer','1993-10-03','1998-10-03'),
(421184,'Engineer','1998-10-03','2000-01-30'),
(421309,'Senior Staff','1995-02-16','9999-01-01'),
(421309,'Staff','1988-02-16','1995-02-16'),
(421547,'Technique Leader','1997-01-26','2000-12-03');


INSERT INTO `titles` VALUES (421753,'Technique Leader','1986-01-04','9999-01-01'),
(421822,'Engineer','1993-08-22','9999-01-01'),
(422051,'Senior Staff','1997-10-20','9999-01-01'),
(422051,'Staff','1988-10-20','1997-10-20'),
(422053,'Senior Engineer','1990-07-24','9999-01-01'),
(422871,'Senior Engineer','1991-08-11','1996-04-27'),
(422875,'Assistant Engineer','1989-01-30','1996-01-31'),
(422875,'Engineer','1996-01-31','9999-01-01'),
(423062,'Staff','1995-10-31','9999-01-01'),
(423711,'Staff','1996-05-05','2002-03-01');


INSERT INTO `titles` VALUES (424207,'Senior Staff','1999-05-28','9999-01-01'),
(424207,'Staff','1994-05-28','1999-05-28'),
(424569,'Engineer','1997-10-30','9999-01-01'),
(424598,'Assistant Engineer','1993-04-15','2002-04-15'),
(424598,'Engineer','2002-04-15','9999-01-01'),
(424692,'Senior Engineer','1992-09-07','1993-04-13'),
(424806,'Senior Staff','1995-06-27','9999-01-01'),
(424806,'Staff','1989-06-27','1995-06-27'),
(425308,'Engineer','1986-12-15','1993-12-15'),
(425308,'Senior Engineer','1993-12-15','9999-01-01');


INSERT INTO `titles` VALUES (425361,'Senior Staff','2000-06-29','9999-01-01'),
(425361,'Staff','1994-06-30','2000-06-29'),
(425779,'Senior Engineer','1994-06-06','9999-01-01'),
(425970,'Technique Leader','1996-10-07','9999-01-01'),
(426100,'Engineer','1996-05-13','1996-07-18'),
(426483,'Staff','1997-07-28','9999-01-01'),
(427267,'Engineer','1999-12-04','9999-01-01'),
(427502,'Staff','1999-02-11','9999-01-01'),
(427812,'Staff','1999-08-15','9999-01-01'),
(427918,'Assistant Engineer','1985-10-13','1990-10-13');


INSERT INTO `titles` VALUES (427918,'Engineer','1990-10-13','1995-10-13'),
(427918,'Senior Engineer','1995-10-13','9999-01-01'),
(428296,'Staff','1997-08-15','9999-01-01'),
(428342,'Senior Staff','1997-09-17','9999-01-01'),
(428342,'Staff','1992-09-17','1997-09-17'),
(428479,'Staff','1999-03-31','9999-01-01'),
(428505,'Senior Staff','1997-09-30','9999-01-01'),
(428505,'Staff','1990-09-30','1997-09-30'),
(428595,'Senior Staff','1999-01-31','9999-01-01'),
(428595,'Staff','1990-01-31','1999-01-31');


INSERT INTO `titles` VALUES (428772,'Senior Engineer','1995-11-24','1996-01-08'),
(429487,'Senior Engineer','1997-06-28','9999-01-01'),
(429666,'Senior Engineer','1994-06-19','9999-01-01'),
(429675,'Technique Leader','1998-10-31','9999-01-01'),
(429710,'Engineer','1990-01-05','1999-01-05'),
(429710,'Senior Engineer','1999-01-05','9999-01-01'),
(430218,'Staff','1995-09-23','9999-01-01'),
(430595,'Staff','1994-07-24','1999-02-15'),
(430823,'Senior Staff','1998-07-01','9999-01-01'),
(430823,'Staff','1993-07-01','1998-07-01');


INSERT INTO `titles` VALUES (430908,'Engineer','1990-06-23','1992-12-13'),
(431599,'Senior Engineer','1987-10-22','9999-01-01'),
(431625,'Engineer','1999-06-30','9999-01-01'),
(431732,'Assistant Engineer','1990-12-05','1995-12-05'),
(431732,'Engineer','1995-12-05','2000-12-04'),
(431732,'Senior Engineer','2000-12-04','9999-01-01'),
(431795,'Engineer','2000-01-19','2002-06-02'),
(431831,'Engineer','1996-02-27','9999-01-01'),
(431956,'Engineer','1986-05-05','1991-05-05'),
(432011,'Engineer','1986-04-19','1994-04-19');


INSERT INTO `titles` VALUES (432011,'Senior Engineer','1994-04-19','9999-01-01'),
(432089,'Senior Engineer','1989-12-30','2002-01-11'),
(432304,'Engineer','1991-06-01','1996-05-31'),
(432304,'Senior Engineer','1996-05-31','9999-01-01'),
(432591,'Engineer','1988-01-29','1996-01-29'),
(432591,'Senior Engineer','1996-01-29','9999-01-01'),
(433763,'Engineer','1987-09-22','1996-09-21'),
(433763,'Senior Engineer','1996-09-21','9999-01-01'),
(434095,'Engineer','1994-01-20','1997-10-14'),
(434948,'Senior Staff','1996-08-30','9999-01-01');


INSERT INTO `titles` VALUES (434948,'Staff','1987-08-31','1996-08-30'),
(435178,'Staff','1996-07-12','9999-01-01'),
(435490,'Engineer','1999-04-05','9999-01-01'),
(435942,'Staff','1999-12-20','9999-01-01'),
(436169,'Engineer','1988-10-31','1996-10-31'),
(436169,'Senior Engineer','1996-10-31','9999-01-01'),
(436175,'Engineer','1989-12-03','1994-12-03'),
(436175,'Senior Engineer','1994-12-03','9999-01-01'),
(436326,'Staff','1993-06-15','1994-01-10'),
(436684,'Engineer','1988-03-28','1993-03-28');


INSERT INTO `titles` VALUES (436684,'Senior Engineer','1993-03-28','9999-01-01'),
(437693,'Engineer','1988-08-23','1996-08-23'),
(437693,'Senior Engineer','1996-08-23','9999-01-01'),
(437857,'Senior Staff','2002-02-23','9999-01-01'),
(437857,'Staff','1995-02-23','2002-02-23'),
(437869,'Senior Staff','2001-12-15','9999-01-01'),
(437869,'Staff','1993-12-15','2001-12-15'),
(438019,'Staff','1996-08-23','1997-06-06'),
(438369,'Engineer','1992-11-20','2001-11-20'),
(438369,'Senior Engineer','2001-11-20','9999-01-01');


INSERT INTO `titles` VALUES (438435,'Engineer','1987-12-19','1994-12-19'),
(438435,'Senior Engineer','1994-12-19','9999-01-01'),
(438531,'Engineer','1996-06-29','1997-03-28'),
(438707,'Staff','1997-09-16','9999-01-01'),
(438745,'Technique Leader','1987-08-29','9999-01-01'),
(439293,'Engineer','1986-08-11','1991-08-11'),
(439293,'Senior Engineer','1991-08-11','9999-01-01'),
(439463,'Senior Engineer','1990-02-02','9999-01-01'),
(439537,'Senior Engineer','1988-12-12','9999-01-01'),
(439693,'Engineer','1986-03-20','1995-03-20');


INSERT INTO `titles` VALUES (439693,'Senior Engineer','1995-03-20','9999-01-01'),
(440249,'Engineer','1992-08-28','1996-11-10'),
(440546,'Assistant Engineer','1999-12-01','9999-01-01'),
(440846,'Staff','1997-10-02','9999-01-01'),
(441011,'Staff','1995-03-04','9999-01-01'),
(441307,'Senior Staff','1995-08-15','9999-01-01'),
(441307,'Staff','1990-08-15','1995-08-15'),
(441907,'Engineer','1992-03-18','1998-03-18'),
(441907,'Senior Engineer','1998-03-18','9999-01-01'),
(442038,'Engineer','1985-07-20','1993-07-20');


INSERT INTO `titles` VALUES (442038,'Senior Engineer','1993-07-20','9999-01-01'),
(442184,'Senior Staff','1999-11-08','9999-01-01'),
(442184,'Staff','1993-11-08','1999-11-08'),
(442333,'Senior Engineer','1989-02-12','9999-01-01'),
(442526,'Engineer','1987-08-30','1995-08-30'),
(442526,'Senior Engineer','1995-08-30','9999-01-01'),
(443533,'Senior Engineer','1992-03-11','9999-01-01'),
(443582,'Senior Staff','1993-01-29','9999-01-01'),
(443617,'Senior Staff','1991-12-07','9999-01-01'),
(443617,'Staff','1986-12-07','1991-12-07');


INSERT INTO `titles` VALUES (443703,'Technique Leader','1985-11-13','9999-01-01'),
(443763,'Engineer','1997-01-31','1997-07-10'),
(443787,'Assistant Engineer','1986-04-01','1991-12-04'),
(444254,'Senior Staff','1995-09-22','1998-09-17'),
(444254,'Staff','1988-09-21','1995-09-22'),
(444831,'Staff','1996-09-03','9999-01-01'),
(445023,'Senior Staff','1995-07-22','9999-01-01'),
(445023,'Staff','1988-07-21','1995-07-22'),
(445368,'Staff','1991-03-19','1992-09-29'),
(445708,'Staff','1987-07-20','1989-09-15');


INSERT INTO `titles` VALUES (446075,'Staff','1997-08-28','9999-01-01'),
(446124,'Senior Staff','1993-05-05','1993-05-30'),
(446124,'Staff','1986-05-05','1993-05-05'),
(446345,'Senior Staff','1993-06-19','9999-01-01'),
(446396,'Engineer','1990-04-13','1996-04-12'),
(446396,'Senior Engineer','1996-04-12','1997-08-24'),
(446552,'Senior Staff','1993-02-06','9999-01-01'),
(446552,'Staff','1985-02-06','1993-02-06'),
(446653,'Engineer','1992-09-04','2000-09-04'),
(446653,'Senior Engineer','2000-09-04','9999-01-01');


INSERT INTO `titles` VALUES (446753,'Engineer','1996-07-27','2001-07-27'),
(446753,'Senior Engineer','2001-07-27','9999-01-01'),
(447555,'Engineer','1989-09-26','1998-09-26'),
(447555,'Senior Engineer','1998-09-26','9999-01-01'),
(447791,'Staff','1996-04-29','9999-01-01'),
(447950,'Engineer','1988-08-18','1997-08-18'),
(447950,'Senior Engineer','1997-08-18','9999-01-01'),
(447951,'Senior Staff','1997-10-29','9999-01-01'),
(447951,'Staff','1988-10-30','1997-10-29'),
(448061,'Staff','1985-05-22','1988-09-01');


INSERT INTO `titles` VALUES (448100,'Engineer','1990-06-23','1996-06-22'),
(448100,'Senior Engineer','1996-06-22','9999-01-01'),
(448258,'Staff','1994-10-04','9999-01-01'),
(448842,'Senior Staff','1995-12-22','9999-01-01'),
(449084,'Engineer','1985-06-25','1991-06-25'),
(449084,'Senior Engineer','1991-06-25','9999-01-01'),
(449160,'Engineer','1997-12-09','9999-01-01'),
(449585,'Senior Staff','1994-09-17','9999-01-01'),
(449585,'Staff','1989-09-17','1994-09-17'),
(449950,'Assistant Engineer','1986-04-16','1995-04-16');


INSERT INTO `titles` VALUES (449950,'Engineer','1995-04-16','9999-01-01'),
(450050,'Senior Engineer','1989-12-30','9999-01-01'),
(450443,'Engineer','1988-04-08','1995-12-23'),
(450960,'Engineer','1987-10-21','1994-10-21'),
(450960,'Senior Engineer','1994-10-21','9999-01-01'),
(452346,'Engineer','1998-06-15','9999-01-01'),
(452944,'Staff','1995-09-26','2000-12-14'),
(453467,'Senior Staff','1999-01-24','9999-01-01'),
(453467,'Staff','1993-01-24','1999-01-24'),
(453835,'Senior Staff','1996-08-24','9999-01-01');


INSERT INTO `titles` VALUES (453835,'Staff','1990-08-25','1996-08-24'),
(453910,'Technique Leader','1998-10-29','9999-01-01'),
(454044,'Engineer','1991-10-02','1998-10-02'),
(454044,'Senior Engineer','1998-10-02','9999-01-01'),
(454104,'Engineer','1994-09-06','1998-01-28'),
(454472,'Senior Staff','1997-05-03','9999-01-01'),
(454472,'Staff','1991-05-04','1997-05-03'),
(454591,'Senior Staff','1993-07-01','9999-01-01'),
(454591,'Staff','1986-07-01','1993-07-01'),
(454592,'Senior Staff','1997-07-03','9999-01-01');


INSERT INTO `titles` VALUES (454592,'Staff','1990-07-03','1997-07-03'),
(454774,'Engineer','1986-11-01','1993-11-01'),
(454774,'Senior Engineer','1993-11-01','9999-01-01'),
(455131,'Senior Staff','2001-03-17','9999-01-01'),
(455131,'Staff','1995-03-18','2001-03-17'),
(455592,'Engineer','1991-04-18','1996-04-17'),
(455592,'Senior Engineer','1996-04-17','9999-01-01'),
(455801,'Engineer','1985-11-19','1990-11-19'),
(455801,'Senior Engineer','1990-11-19','9999-01-01'),
(455948,'Senior Staff','2000-01-19','9999-01-01');


INSERT INTO `titles` VALUES (455948,'Staff','1993-01-18','2000-01-19'),
(456107,'Senior Staff','1991-05-27','9999-01-01'),
(456131,'Staff','1994-06-09','9999-01-01'),
(456146,'Staff','1999-12-02','9999-01-01'),
(456688,'Engineer','1991-02-27','1999-02-27'),
(456688,'Senior Engineer','1999-02-27','9999-01-01'),
(456982,'Engineer','1989-01-05','1997-01-05'),
(456982,'Senior Engineer','1997-01-05','9999-01-01'),
(457307,'Engineer','1988-09-30','1995-10-01'),
(457307,'Senior Engineer','1995-10-01','9999-01-01');


INSERT INTO `titles` VALUES (457337,'Technique Leader','1995-04-27','9999-01-01'),
(457781,'Senior Staff','1998-05-30','1999-06-12'),
(457781,'Staff','1992-05-30','1998-05-30'),
(457792,'Engineer','1989-08-09','1997-08-09'),
(457792,'Senior Engineer','1997-08-09','9999-01-01'),
(458720,'Engineer','1994-04-23','1999-05-03'),
(458866,'Engineer','1992-09-02','1998-09-02'),
(458866,'Senior Engineer','1998-09-02','9999-01-01'),
(459134,'Engineer','1996-12-31','9999-01-01'),
(459172,'Assistant Engineer','1993-11-20','1999-11-20');


INSERT INTO `titles` VALUES (459172,'Engineer','1999-11-20','9999-01-01'),
(459670,'Senior Staff','1994-11-13','9999-01-01'),
(459670,'Staff','1985-11-13','1994-11-13'),
(459744,'Senior Staff','1997-02-26','9999-01-01'),
(459744,'Staff','1991-02-27','1997-02-26'),
(460698,'Senior Staff','1998-08-26','9999-01-01'),
(461268,'Senior Staff','1999-10-12','9999-01-01'),
(461268,'Staff','1991-10-12','1999-10-12'),
(461329,'Senior Staff','1998-01-12','9999-01-01'),
(461716,'Engineer','1996-09-02','9999-01-01');


INSERT INTO `titles` VALUES (462367,'Engineer','1998-11-24','9999-01-01'),
(462427,'Senior Staff','1996-07-08','9999-01-01'),
(462427,'Staff','1991-07-09','1996-07-08'),
(463321,'Senior Staff','2002-05-27','9999-01-01'),
(463321,'Staff','1994-05-27','2002-05-27'),
(463614,'Senior Staff','1996-10-19','9999-01-01'),
(463614,'Staff','1989-10-19','1996-10-19'),
(464625,'Senior Staff','2000-08-06','9999-01-01'),
(464625,'Staff','1992-08-06','2000-08-06'),
(464927,'Senior Engineer','1989-06-05','1998-12-11');


INSERT INTO `titles` VALUES (464955,'Staff','1994-04-08','1995-04-13'),
(465205,'Engineer','1987-05-12','1994-05-12'),
(465205,'Senior Engineer','1994-05-12','9999-01-01'),
(465245,'Senior Staff','1992-03-07','1994-12-18'),
(465245,'Staff','1985-03-07','1992-03-07'),
(465854,'Engineer','1999-09-14','9999-01-01'),
(466137,'Assistant Engineer','1998-11-07','9999-01-01'),
(466147,'Senior Staff','1995-12-09','9999-01-01'),
(466147,'Staff','1989-12-09','1995-12-09'),
(466176,'Engineer','1986-11-11','1994-11-11');


INSERT INTO `titles` VALUES (466176,'Senior Engineer','1994-11-11','9999-01-01'),
(466224,'Engineer','1992-09-23','1993-05-14'),
(466440,'Senior Staff','1994-05-16','9999-01-01'),
(466440,'Staff','1987-05-16','1994-05-16'),
(466771,'Engineer','1998-08-14','9999-01-01'),
(467051,'Staff','1991-07-20','1995-02-07'),
(467114,'Engineer','1994-05-30','9999-01-01'),
(467978,'Staff','1992-10-03','1995-02-24'),
(468108,'Senior Engineer','1993-02-18','9999-01-01'),
(469541,'Engineer','1995-11-03','9999-01-01');


INSERT INTO `titles` VALUES (469772,'Engineer','1994-09-06','2000-09-05'),
(469772,'Senior Engineer','2000-09-05','9999-01-01'),
(470221,'Staff','1997-02-21','9999-01-01'),
(470837,'Engineer','1996-03-02','2001-03-02'),
(470837,'Senior Engineer','2001-03-02','9999-01-01'),
(471334,'Assistant Engineer','1995-05-11','2000-11-07'),
(471535,'Engineer','1997-11-27','1999-11-11'),
(471787,'Assistant Engineer','1988-08-20','1994-08-20'),
(471787,'Engineer','1994-08-20','2000-08-19'),
(471787,'Senior Engineer','2000-08-19','9999-01-01');


INSERT INTO `titles` VALUES (472062,'Senior Staff','1992-09-02','1999-07-21'),
(472563,'Technique Leader','1990-10-09','9999-01-01'),
(473287,'Engineer','1990-05-07','1996-05-06'),
(473287,'Senior Engineer','1996-05-06','9999-01-01'),
(473521,'Senior Staff','1994-10-26','9999-01-01'),
(473521,'Staff','1987-10-26','1994-10-26'),
(473954,'Senior Staff','1998-09-19','9999-01-01'),
(474064,'Senior Engineer','1985-10-06','1991-05-11'),
(475036,'Engineer','1999-11-21','9999-01-01'),
(475109,'Senior Staff','1997-04-11','9999-01-01');


INSERT INTO `titles` VALUES (475725,'Senior Staff','2001-05-02','9999-01-01'),
(475725,'Staff','1994-05-02','2001-05-02'),
(476629,'Staff','1992-09-27','1993-08-21'),
(477293,'Engineer','1987-06-16','1995-06-16'),
(477293,'Senior Engineer','1995-06-16','9999-01-01'),
(477384,'Technique Leader','1987-03-07','9999-01-01'),
(478034,'Senior Staff','1997-09-01','9999-01-01'),
(478034,'Staff','1992-09-01','1997-09-01'),
(478331,'Engineer','1996-06-06','2000-07-13'),
(478439,'Technique Leader','1997-11-04','9999-01-01');


INSERT INTO `titles` VALUES (478442,'Engineer','1997-03-10','2002-03-10'),
(478442,'Senior Engineer','2002-03-10','9999-01-01'),
(478460,'Senior Staff','1991-11-16','1999-12-08'),
(478460,'Staff','1986-11-16','1991-11-16'),
(479267,'Technique Leader','1994-11-23','9999-01-01'),
(479287,'Engineer','1992-09-19','1999-09-20'),
(479287,'Senior Engineer','1999-09-20','9999-01-01'),
(479747,'Engineer','1991-06-26','1991-07-12'),
(480010,'Senior Engineer','1998-11-07','2000-03-23'),
(480016,'Assistant Engineer','1986-09-04','1988-03-02');


INSERT INTO `titles` VALUES (480019,'Senior Engineer','1996-08-22','2000-07-24'),
(480923,'Technique Leader','1987-07-01','1989-06-06'),
(481107,'Senior Staff','1998-04-15','9999-01-01'),
(481107,'Staff','1992-04-15','1998-04-15'),
(481113,'Engineer','1988-01-14','1997-01-13'),
(481113,'Senior Engineer','1997-01-13','9999-01-01'),
(481144,'Senior Staff','2001-05-16','9999-01-01'),
(481144,'Staff','1994-05-16','2001-05-16'),
(481503,'Senior Staff','2000-08-23','9999-01-01'),
(481503,'Staff','1992-08-23','2000-08-23');


INSERT INTO `titles` VALUES (481851,'Technique Leader','1994-03-19','1995-12-09'),
(482133,'Engineer','1994-08-10','2001-08-10'),
(482133,'Senior Engineer','2001-08-10','9999-01-01'),
(482158,'Technique Leader','1989-10-27','2000-10-20'),
(482279,'Staff','1998-07-08','9999-01-01'),
(482347,'Engineer','1998-09-28','9999-01-01'),
(482555,'Senior Staff','1993-11-30','9999-01-01'),
(482555,'Staff','1985-11-30','1993-11-30'),
(482689,'Staff','1999-07-03','9999-01-01'),
(482722,'Senior Staff','1994-04-29','1995-01-18');


INSERT INTO `titles` VALUES (482722,'Staff','1989-04-29','1994-04-29'),
(482765,'Senior Engineer','1996-01-04','2000-03-21'),
(482786,'Senior Staff','1994-03-24','1996-05-04'),
(482786,'Staff','1985-03-24','1994-03-24'),
(483081,'Engineer','1988-09-15','1993-09-15'),
(483081,'Senior Engineer','1993-09-15','9999-01-01'),
(483171,'Senior Staff','1988-11-14','1995-08-15'),
(483399,'Senior Staff','1997-05-11','1999-05-29'),
(483624,'Senior Staff','1995-03-23','9999-01-01'),
(483624,'Staff','1986-03-23','1995-03-23');


INSERT INTO `titles` VALUES (484242,'Engineer','1989-07-22','1997-07-22'),
(484242,'Senior Engineer','1997-07-22','9999-01-01'),
(484451,'Senior Staff','2002-01-04','9999-01-01'),
(484451,'Staff','1994-01-04','2002-01-04'),
(484460,'Engineer','1992-11-29','2001-11-29'),
(484460,'Senior Engineer','2001-11-29','9999-01-01'),
(484778,'Engineer','1997-02-23','1999-08-25'),
(484889,'Staff','1986-08-02','1987-04-24'),
(485483,'Engineer','1996-07-20','2002-01-02'),
(485682,'Senior Staff','2002-03-20','9999-01-01');


INSERT INTO `titles` VALUES (485682,'Staff','1997-03-20','2002-03-20'),
(485905,'Assistant Engineer','1988-11-11','1994-11-11'),
(485905,'Engineer','1994-11-11','2000-11-10'),
(485905,'Senior Engineer','2000-11-10','9999-01-01'),
(486022,'Engineer','1988-09-12','1994-09-12'),
(486022,'Senior Engineer','1994-09-12','9999-01-01'),
(486306,'Staff','1994-11-19','9999-01-01'),
(487218,'Senior Staff','1991-11-07','9999-01-01'),
(487218,'Staff','1986-11-07','1991-11-07'),
(487252,'Engineer','1988-02-27','1997-02-26');


INSERT INTO `titles` VALUES (487252,'Senior Engineer','1997-02-26','9999-01-01'),
(487925,'Senior Engineer','1994-08-31','9999-01-01'),
(488231,'Staff','1995-02-24','9999-01-01'),
(488385,'Staff','1991-11-30','1993-03-26'),
(488504,'Staff','1998-05-12','9999-01-01'),
(488538,'Technique Leader','1996-05-16','9999-01-01'),
(488774,'Senior Engineer','1997-10-10','9999-01-01'),
(488997,'Engineer','1987-09-10','1996-09-09'),
(488997,'Senior Engineer','1996-09-09','9999-01-01'),
(489215,'Engineer','1999-08-28','9999-01-01');


INSERT INTO `titles` VALUES (489339,'Engineer','1989-11-10','1995-11-10'),
(489339,'Senior Engineer','1995-11-10','9999-01-01'),
(489378,'Assistant Engineer','1985-11-15','1992-11-15'),
(489378,'Engineer','1992-11-15','1999-11-16'),
(489378,'Senior Engineer','1999-11-16','9999-01-01'),
(489404,'Engineer','1997-12-03','9999-01-01'),
(489488,'Senior Engineer','1998-12-31','9999-01-01'),
(489514,'Senior Engineer','1988-08-15','9999-01-01'),
(489658,'Senior Staff','1992-09-23','1998-01-22'),
(489658,'Staff','1985-09-23','1992-09-23');


INSERT INTO `titles` VALUES (490024,'Technique Leader','1991-11-28','9999-01-01'),
(490025,'Engineer','1986-03-07','1991-03-07'),
(490025,'Senior Engineer','1991-03-07','9999-01-01'),
(490095,'Staff','1999-06-12','9999-01-01'),
(490155,'Engineer','1989-04-25','1991-08-23'),
(490390,'Senior Engineer','1988-01-01','9999-01-01'),
(490647,'Engineer','1992-02-09','1999-02-09'),
(490647,'Senior Engineer','1999-02-09','9999-01-01'),
(490747,'Staff','1998-11-18','9999-01-01'),
(491048,'Senior Staff','1992-06-14','9999-01-01');


INSERT INTO `titles` VALUES (491358,'Senior Engineer','1992-10-31','1996-03-17'),
(491370,'Senior Staff','2000-01-26','9999-01-01'),
(491370,'Staff','1994-01-26','2000-01-26'),
(491978,'Senior Staff','1997-02-19','9999-01-01'),
(491978,'Staff','1990-02-19','1997-02-19'),
(492217,'Senior Engineer','1991-09-28','9999-01-01'),
(492566,'Engineer','1988-01-09','1996-01-09'),
(492566,'Senior Engineer','1996-01-09','9999-01-01'),
(493013,'Engineer','1996-02-01','9999-01-01'),
(493516,'Engineer','1985-04-02','1994-04-02');


INSERT INTO `titles` VALUES (493516,'Senior Engineer','1994-04-02','9999-01-01'),
(494052,'Senior Staff','1994-05-26','9999-01-01'),
(494230,'Senior Staff','1994-07-26','9999-01-01'),
(494230,'Staff','1987-07-26','1994-07-26'),
(494294,'Senior Staff','1990-04-08','1992-04-09'),
(495066,'Engineer','1998-01-12','9999-01-01'),
(495146,'Senior Staff','1993-11-05','9999-01-01'),
(495146,'Staff','1988-11-05','1993-11-05'),
(495658,'Engineer','1998-09-28','2000-03-04'),
(495879,'Technique Leader','1989-12-30','9999-01-01');


INSERT INTO `titles` VALUES (496317,'Staff','1997-11-28','9999-01-01'),
(496685,'Senior Staff','1996-04-10','9999-01-01'),
(496685,'Staff','1991-04-11','1996-04-10'),
(496687,'Staff','1999-02-13','9999-01-01'),
(497341,'Senior Staff','1997-03-03','9999-01-01'),
(497341,'Staff','1989-03-03','1997-03-03'),
(497434,'Senior Staff','1986-07-16','9999-01-01'),
(498101,'Staff','1998-12-16','9999-01-01'),
(498351,'Senior Engineer','1997-12-04','9999-01-01'),
(498404,'Engineer','1998-04-28','9999-01-01');


INSERT INTO `titles` VALUES (498649,'Engineer','1998-05-23','2000-01-13'),
(498741,'Engineer','1985-12-21','1994-12-21'),
(498741,'Senior Engineer','1994-12-21','9999-01-01'),
(499367,'Senior Engineer','1993-02-17','9999-01-01'),
(499762,'Senior Staff','1993-07-06','9999-01-01'),
(499762,'Staff','1985-07-06','1993-07-06');



SELECT 'LOADING salaries' as INFO;
INSERT INTO `salaries` VALUES (10001,60117,'1986-06-26','1987-06-26'),
(10213,40000,'1994-10-06','1995-10-06'),
(10213,39636,'1995-10-06','1996-10-05'),
(10213,42190,'1996-10-05','1997-10-05'),
(10213,45748,'1997-10-05','1998-10-05'),
(10213,46693,'1998-10-05','1999-10-05'),
(10213,47824,'1999-10-05','2000-10-04'),
(10213,48846,'2000-10-04','2001-10-04'),
(10213,50786,'2001-10-04','9999-01-01'),
(10300,72504,'1991-05-17','1992-05-16');


INSERT INTO `salaries` VALUES (10300,76773,'1992-05-16','1993-05-16'),
(10300,78564,'1993-05-16','1994-05-16'),
(10300,82747,'1994-05-16','1995-05-16'),
(10300,85224,'1995-05-16','1996-05-15'),
(10300,85824,'1996-05-15','1997-05-15'),
(10300,88549,'1997-05-15','1998-05-15'),
(10300,88337,'1998-05-15','1999-05-15'),
(10300,92227,'1999-05-15','2000-05-14'),
(10300,96395,'2000-05-14','2001-05-14'),
(10300,97640,'2001-05-14','2002-05-14');


INSERT INTO `salaries` VALUES (10300,101239,'2002-05-14','9999-01-01'),
(10604,50849,'1990-04-07','1991-04-06'),
(10604,53262,'1991-04-06','1992-04-06'),
(10604,57054,'1992-04-06','1993-04-06'),
(10604,59387,'1993-04-06','1994-04-06'),
(10604,61585,'1994-04-06','1995-04-06'),
(10604,64601,'1995-04-06','1996-04-04'),
(10604,64404,'1996-04-04','1997-04-04'),
(10604,68043,'1997-04-04','1998-04-04'),
(10604,69279,'1998-04-04','1999-04-05');


INSERT INTO `salaries` VALUES (10604,70081,'1999-04-05','2000-04-04'),
(10604,73065,'2000-04-04','2001-04-04'),
(10604,76669,'2001-04-04','2002-04-03'),
(10604,79707,'2002-04-03','9999-01-01'),
(10887,69570,'1989-03-17','1990-03-17'),
(10887,72682,'1990-03-17','1991-03-17'),
(10887,73792,'1991-03-17','1992-03-16'),
(10887,75459,'1992-03-16','1993-03-16'),
(10887,77010,'1993-03-16','1994-03-16'),
(10887,78306,'1994-03-16','1995-03-16');


INSERT INTO `salaries` VALUES (10887,82234,'1995-03-16','1996-03-15'),
(10887,85308,'1996-03-15','1997-03-15'),
(10887,85484,'1997-03-15','1998-03-15'),
(10887,88665,'1998-03-15','1999-03-15'),
(10887,91884,'1999-03-15','2000-03-14'),
(10887,95714,'2000-03-14','2001-03-14'),
(10887,97929,'2001-03-14','2002-03-14'),
(10887,101291,'2002-03-14','9999-01-01'),
(11131,60792,'1999-07-14','1999-08-01'),
(11345,61656,'1998-11-25','1999-11-25');


INSERT INTO `salaries` VALUES (11345,61362,'1999-11-25','2000-11-24'),
(11345,62116,'2000-11-24','2001-11-24'),
(11345,65421,'2001-11-24','9999-01-01'),
(11403,87912,'1989-08-03','1990-08-03'),
(11403,90230,'1990-08-03','1991-08-03'),
(11403,92444,'1991-08-03','1992-08-02'),
(11403,92263,'1992-08-02','1993-08-02'),
(11403,95309,'1993-08-02','1993-12-01'),
(11702,94495,'1988-09-18','1989-09-18'),
(11702,98784,'1989-09-18','1990-09-18');


INSERT INTO `salaries` VALUES (11702,102194,'1990-09-18','1991-09-18'),
(11702,106398,'1991-09-18','1992-09-17'),
(11702,108210,'1992-09-17','1993-09-17'),
(11702,109127,'1993-09-17','1994-09-17'),
(11702,111291,'1994-09-17','1995-09-14'),
(11859,79630,'1998-07-28','1999-07-28'),
(11859,80987,'1999-07-28','2000-07-27'),
(11859,83974,'2000-07-27','2001-07-27'),
(11859,85201,'2001-07-27','2002-07-27'),
(11859,88523,'2002-07-27','9999-01-01');


INSERT INTO `salaries` VALUES (12908,53631,'1988-09-23','1989-09-23'),
(12908,54563,'1989-09-23','1990-09-23'),
(12908,58567,'1990-09-23','1991-09-23'),
(12908,61571,'1991-09-23','1992-09-22'),
(12908,64429,'1992-09-22','1993-09-22'),
(12908,66427,'1993-09-22','1994-09-22'),
(12908,67139,'1994-09-22','1995-09-22'),
(12908,67498,'1995-09-22','1996-09-21'),
(12908,68529,'1996-09-21','1997-09-21'),
(12908,69361,'1997-09-21','1998-09-21');


INSERT INTO `salaries` VALUES (12908,70434,'1998-09-21','1999-09-21'),
(12908,73755,'1999-09-21','2000-09-20'),
(12908,74222,'2000-09-20','2001-09-20'),
(12908,75061,'2001-09-20','9999-01-01'),
(13092,74477,'1994-05-16','1995-05-16'),
(13092,78875,'1995-05-16','1996-05-15'),
(13092,78924,'1996-05-15','1997-05-15'),
(13092,80122,'1997-05-15','1998-05-15'),
(13092,79753,'1998-05-15','1999-05-15'),
(13092,82000,'1999-05-15','2000-05-14');


INSERT INTO `salaries` VALUES (13092,82334,'2000-05-14','2001-05-14'),
(13092,83201,'2001-05-14','2002-05-14'),
(13092,86691,'2002-05-14','9999-01-01'),
(13408,52479,'1995-07-25','1996-07-24'),
(13408,55567,'1996-07-24','1997-07-24'),
(13408,56229,'1997-07-24','1998-07-24'),
(13408,57749,'1998-07-24','1999-07-24'),
(13408,60675,'1999-07-24','2000-07-23'),
(13408,64001,'2000-07-23','2001-07-23'),
(13408,64495,'2001-07-23','2002-07-23');


INSERT INTO `salaries` VALUES (13408,67204,'2002-07-23','9999-01-01'),
(13771,40000,'1990-05-21','1991-05-21'),
(13771,40586,'1991-05-21','1992-05-20'),
(13771,44384,'1992-05-20','1993-05-20'),
(13771,44637,'1993-05-20','1994-05-20'),
(13771,46607,'1994-05-20','1995-05-20'),
(13771,46730,'1995-05-20','1996-05-19'),
(13771,46862,'1996-05-19','1997-05-19'),
(13771,48144,'1997-05-19','1998-05-19'),
(13771,49563,'1998-05-19','1999-05-19');


INSERT INTO `salaries` VALUES (13771,51715,'1999-05-19','2000-05-18'),
(13771,52997,'2000-05-18','2001-05-18'),
(13771,56490,'2001-05-18','2002-05-18'),
(13771,59895,'2002-05-18','9999-01-01'),
(14102,48200,'1989-04-03','1990-04-03'),
(14102,48150,'1990-04-03','1991-02-21'),
(14884,58695,'1989-06-08','1990-06-08'),
(14884,63056,'1990-06-08','1991-06-08'),
(14884,66661,'1991-06-08','1992-06-07'),
(14884,66994,'1992-06-07','1993-06-07');


INSERT INTO `salaries` VALUES (14884,68294,'1993-06-07','1994-06-07'),
(14884,68297,'1994-06-07','1995-06-07'),
(14884,68299,'1995-06-07','1996-06-06'),
(14884,69580,'1996-06-06','1997-06-06'),
(14884,69659,'1997-06-06','1998-06-06'),
(14884,72076,'1998-06-06','1999-06-06'),
(14884,76236,'1999-06-06','2000-06-05'),
(14884,77724,'2000-06-05','2001-06-05'),
(14884,78828,'2001-06-05','2002-06-05'),
(14884,78737,'2002-06-05','9999-01-01');


INSERT INTO `salaries` VALUES (15070,40000,'1995-08-28','1996-08-27'),
(15070,41208,'1996-08-27','1997-08-27'),
(15070,44306,'1997-08-27','1998-08-27'),
(15070,43867,'1998-08-27','1999-08-27'),
(15070,47098,'1999-08-27','2000-07-16'),
(15323,77202,'1988-04-02','1989-04-02'),
(15323,80736,'1989-04-02','1990-04-02'),
(15323,81735,'1990-04-02','1991-04-02'),
(15323,85940,'1991-04-02','1992-04-01'),
(15323,90376,'1992-04-01','1993-04-01');


INSERT INTO `salaries` VALUES (15323,93011,'1993-04-01','1994-04-01'),
(15323,96052,'1994-04-01','1995-04-01'),
(15323,96899,'1995-04-01','1996-03-31'),
(15323,99429,'1996-03-31','1997-03-31'),
(15323,101586,'1997-03-31','1998-03-31'),
(15323,103648,'1998-03-31','1999-03-31'),
(15323,107818,'1999-03-31','2000-03-30'),
(15323,110664,'2000-03-30','2001-03-30'),
(15323,115163,'2001-03-30','2002-03-30'),
(15323,115716,'2002-03-30','9999-01-01');


INSERT INTO `salaries` VALUES (16020,70308,'1990-01-04','1991-01-04'),
(16020,71524,'1991-01-04','1992-01-04'),
(16020,72038,'1992-01-04','1993-01-03'),
(16020,72658,'1993-01-03','1994-01-03'),
(16020,74185,'1994-01-03','1995-01-03'),
(16020,77230,'1995-01-03','1996-01-03'),
(16020,81305,'1996-01-03','1997-01-02'),
(16020,81925,'1997-01-02','1998-01-02'),
(16020,82895,'1998-01-02','1999-01-02'),
(16020,86082,'1999-01-02','2000-01-02');


INSERT INTO `salaries` VALUES (16020,87575,'2000-01-02','2001-01-01'),
(16020,89760,'2001-01-01','2002-01-01'),
(16020,93410,'2002-01-01','9999-01-01'),
(16431,65222,'1985-06-19','1986-06-19'),
(16431,66508,'1986-06-19','1987-06-19'),
(16431,70998,'1987-06-19','1988-06-18'),
(16431,71938,'1988-06-18','1989-06-18'),
(16431,74549,'1989-06-18','1990-06-18'),
(16431,78885,'1990-06-18','1991-06-18'),
(16431,82741,'1991-06-18','1992-06-17');


INSERT INTO `salaries` VALUES (16431,85650,'1992-06-17','1993-06-17'),
(16431,88430,'1993-06-17','1994-06-17'),
(16431,90680,'1994-06-17','1995-06-17'),
(16431,90234,'1995-06-17','1996-06-16'),
(16431,94713,'1996-06-16','1997-06-16'),
(16431,94498,'1997-06-16','1998-06-16'),
(16431,96555,'1998-06-16','1999-06-16'),
(16431,97512,'1999-06-16','2000-06-15'),
(16431,99290,'2000-06-15','2001-06-15'),
(16431,103171,'2001-06-15','2002-06-15');


INSERT INTO `salaries` VALUES (16431,103512,'2002-06-15','9999-01-01'),
(16634,40000,'1990-01-18','1991-01-18'),
(16634,41560,'1991-01-18','1992-01-18'),
(16634,42138,'1992-01-18','1993-01-17'),
(16634,42488,'1993-01-17','1994-01-17'),
(16634,45190,'1994-01-17','1995-01-17'),
(16634,48716,'1995-01-17','1996-01-17'),
(16634,49104,'1996-01-17','1997-01-16'),
(16634,51581,'1997-01-16','1998-01-16'),
(16634,52023,'1998-01-16','1999-01-16');


INSERT INTO `salaries` VALUES (16634,52588,'1999-01-16','2000-01-16'),
(16634,54629,'2000-01-16','2001-01-15'),
(16634,58364,'2001-01-15','2002-01-15'),
(16634,61720,'2002-01-15','9999-01-01'),
(17170,77057,'1988-12-03','1989-12-03'),
(17170,78086,'1989-12-03','1990-12-03'),
(17170,81074,'1990-12-03','1991-12-03'),
(17170,85354,'1991-12-03','1992-12-02'),
(17170,86434,'1992-12-02','1993-12-02'),
(17170,89628,'1993-12-02','1994-12-02');


INSERT INTO `salaries` VALUES (17170,93218,'1994-12-02','1995-12-02'),
(17170,97197,'1995-12-02','1996-12-01'),
(17170,97012,'1996-12-01','1997-12-01'),
(17170,99439,'1997-12-01','1998-12-01'),
(17170,101819,'1998-12-01','1999-12-01'),
(17170,103132,'1999-12-01','2000-11-30'),
(17170,103423,'2000-11-30','2001-11-30'),
(17170,105918,'2001-11-30','9999-01-01'),
(17418,57135,'1997-08-13','1998-08-13'),
(17418,61060,'1998-08-13','1999-08-13');


INSERT INTO `salaries` VALUES (17418,64089,'1999-08-13','2000-08-12'),
(17418,65693,'2000-08-12','2001-08-12'),
(17418,69401,'2001-08-12','9999-01-01'),
(17738,53934,'1990-04-21','1991-04-21'),
(17738,58105,'1991-04-21','1992-04-20'),
(17738,59755,'1992-04-20','1993-04-20'),
(17738,62751,'1993-04-20','1994-04-20'),
(17738,63412,'1994-04-20','1995-04-20'),
(17738,65773,'1995-04-20','1996-04-19'),
(17738,66786,'1996-04-19','1997-04-19');


INSERT INTO `salaries` VALUES (17738,66886,'1997-04-19','1998-04-19'),
(17738,69069,'1998-04-19','1999-04-19'),
(17738,69900,'1999-04-19','2000-04-18'),
(17738,71576,'2000-04-18','2001-04-18'),
(17738,74466,'2001-04-18','2002-04-18'),
(17738,74270,'2002-04-18','9999-01-01'),
(18047,40000,'1994-01-25','1995-01-25'),
(18047,41768,'1995-01-25','1996-01-25'),
(18047,42080,'1996-01-25','1997-01-24'),
(18047,44115,'1997-01-24','1998-01-24');


INSERT INTO `salaries` VALUES (18047,44160,'1998-01-24','1999-01-24'),
(18047,44666,'1999-01-24','2000-01-24'),
(18047,48892,'2000-01-24','2001-01-23'),
(18047,50714,'2001-01-23','2001-09-08'),
(19041,64061,'1998-09-28','1999-09-28'),
(19041,66941,'1999-09-28','2000-09-27'),
(19041,66813,'2000-09-27','2001-09-27'),
(19041,70506,'2001-09-27','2002-03-25'),
(20163,81799,'1991-03-04','1992-03-03'),
(20163,85024,'1992-03-03','1993-03-03');


INSERT INTO `salaries` VALUES (20163,89408,'1993-03-03','1994-03-03'),
(20163,91140,'1994-03-03','1995-03-03'),
(20163,94044,'1995-03-03','1996-03-02'),
(20163,97326,'1996-03-02','1997-03-02'),
(20163,100206,'1997-03-02','1998-03-02'),
(20163,101497,'1998-03-02','1999-03-02'),
(20163,105130,'1999-03-02','2000-03-01'),
(20163,108560,'2000-03-01','2001-03-01'),
(20163,112138,'2001-03-01','2002-03-01'),
(20163,112511,'2002-03-01','9999-01-01');


INSERT INTO `salaries` VALUES (20212,40000,'1997-12-27','1998-12-27'),
(20212,40120,'1998-12-27','1999-12-27'),
(20212,40907,'1999-12-27','2000-12-26'),
(20212,42032,'2000-12-26','2001-12-26'),
(20212,44609,'2001-12-26','9999-01-01'),
(20241,48166,'1991-05-12','1992-05-11'),
(20241,50406,'1992-05-11','1993-05-11'),
(20241,52225,'1993-05-11','1994-05-11'),
(20241,56458,'1994-05-11','1995-05-11'),
(20241,60038,'1995-05-11','1996-05-10');


INSERT INTO `salaries` VALUES (20241,60929,'1996-05-10','1997-05-10'),
(20241,61686,'1997-05-10','1998-05-10'),
(20241,64689,'1998-05-10','1999-05-10'),
(20241,66896,'1999-05-10','2000-05-09'),
(20241,67488,'2000-05-09','2001-05-09'),
(20241,67205,'2001-05-09','2002-05-09'),
(20241,70942,'2002-05-09','9999-01-01'),
(20685,40000,'1989-10-23','1990-10-23'),
(20685,41273,'1990-10-23','1991-10-23'),
(20685,42911,'1991-10-23','1992-10-22');


INSERT INTO `salaries` VALUES (20685,43109,'1992-10-22','1993-10-22'),
(20685,43178,'1993-10-22','1994-10-22'),
(20685,42903,'1994-10-22','1995-10-22'),
(20685,45843,'1995-10-22','1996-10-21'),
(20685,45364,'1996-10-21','1997-10-21'),
(20685,46538,'1997-10-21','1998-10-21'),
(20685,46756,'1998-10-21','1999-10-21'),
(20685,49245,'1999-10-21','2000-01-30'),
(20877,56847,'1993-08-04','1994-08-04'),
(20877,58907,'1994-08-04','1995-08-04');


INSERT INTO `salaries` VALUES (20877,63018,'1995-08-04','1996-08-03'),
(20877,66517,'1996-08-03','1997-08-03'),
(20877,66858,'1997-08-03','1998-08-03'),
(20877,69486,'1998-08-03','1999-08-03'),
(20877,72288,'1999-08-03','2000-08-02'),
(20877,73258,'2000-08-02','2001-08-02'),
(20877,74725,'2001-08-02','9999-01-01'),
(21029,45988,'1998-05-25','1999-05-25'),
(21029,48428,'1999-05-25','2000-05-24'),
(21029,52639,'2000-05-24','2001-05-24');


INSERT INTO `salaries` VALUES (21029,52297,'2001-05-24','2002-05-24'),
(21029,56524,'2002-05-24','9999-01-01'),
(22407,101165,'1996-01-20','1997-01-19'),
(22407,104433,'1997-01-19','1998-01-19'),
(22407,106375,'1998-01-19','1998-03-22'),
(22806,40000,'1990-07-06','1991-07-06'),
(22806,41122,'1991-07-06','1992-07-05'),
(22806,43337,'1992-07-05','1993-07-05'),
(22806,46329,'1993-07-05','1993-09-08'),
(22996,45763,'1998-11-22','1999-11-22');


INSERT INTO `salaries` VALUES (22996,48848,'1999-11-22','2000-11-21'),
(22996,49671,'2000-11-21','2001-11-21'),
(22996,50868,'2001-11-21','9999-01-01'),
(23113,59457,'1991-04-06','1992-04-05'),
(23113,60213,'1992-04-05','1993-04-05'),
(23113,61181,'1993-04-05','1994-04-05'),
(23113,62430,'1994-04-05','1995-04-05'),
(23113,64541,'1995-04-05','1996-04-04'),
(23113,68071,'1996-04-04','1997-04-04'),
(23113,72212,'1997-04-04','1998-04-04');


INSERT INTO `salaries` VALUES (23113,74667,'1998-04-04','1999-04-04'),
(23113,74387,'1999-04-04','2000-04-03'),
(23113,73949,'2000-04-03','2001-04-03'),
(23113,76128,'2001-04-03','2002-04-03'),
(23113,75814,'2002-04-03','9999-01-01'),
(23463,71975,'1998-04-02','1999-04-02'),
(23463,75733,'1999-04-02','2000-04-01'),
(23463,75629,'2000-04-01','2001-04-01'),
(23463,79872,'2001-04-01','2002-04-01'),
(23463,80351,'2002-04-01','9999-01-01');


INSERT INTO `salaries` VALUES (23561,48337,'1992-02-25','1993-02-24'),
(23561,49491,'1993-02-24','1994-02-24'),
(23561,50757,'1994-02-24','1995-02-24'),
(23561,53081,'1995-02-24','1996-02-24'),
(23561,56338,'1996-02-24','1997-02-23'),
(23561,59301,'1997-02-23','1998-02-23'),
(23561,59973,'1998-02-23','1999-02-23'),
(23561,61809,'1999-02-23','2000-02-23'),
(23561,62243,'2000-02-23','2001-02-22'),
(23561,65865,'2001-02-22','2002-02-22');


INSERT INTO `salaries` VALUES (23561,70039,'2002-02-22','9999-01-01'),
(23913,40000,'1985-07-20','1986-07-20'),
(23913,43368,'1986-07-20','1987-07-20'),
(23913,46137,'1987-07-20','1988-07-19'),
(23913,47358,'1988-07-19','1989-07-19'),
(23913,49748,'1989-07-19','1990-07-19'),
(23913,52861,'1990-07-19','1991-07-19'),
(23913,55297,'1991-07-19','1992-07-18'),
(23913,59109,'1992-07-18','1993-07-18'),
(23913,60577,'1993-07-18','1994-07-18');


INSERT INTO `salaries` VALUES (23913,63640,'1994-07-18','1995-07-18'),
(23913,63505,'1995-07-18','1996-07-17'),
(23913,66934,'1996-07-17','1997-07-17'),
(23913,71062,'1997-07-17','1998-07-17'),
(23913,71722,'1998-07-17','1999-07-17'),
(23913,74163,'1999-07-17','2000-07-16'),
(23913,74143,'2000-07-16','2001-07-16'),
(23913,74774,'2001-07-16','2002-07-16'),
(23913,74710,'2002-07-16','9999-01-01'),
(24139,40000,'1997-08-13','1998-08-13');


INSERT INTO `salaries` VALUES (24139,42498,'1998-08-13','1999-08-13'),
(24139,42390,'1999-08-13','2000-08-12'),
(24139,44344,'2000-08-12','2001-08-12'),
(24139,48070,'2001-08-12','9999-01-01'),
(24210,84343,'1988-01-08','1989-01-07'),
(24210,88762,'1989-01-07','1990-01-07'),
(24210,91755,'1990-01-07','1991-01-07'),
(24210,95401,'1991-01-07','1992-01-07'),
(24210,99102,'1992-01-07','1993-01-06'),
(24210,100564,'1993-01-06','1994-01-06');


INSERT INTO `salaries` VALUES (24210,101722,'1994-01-06','1995-01-06'),
(24210,104394,'1995-01-06','1996-01-06'),
(24210,106079,'1996-01-06','1997-01-05'),
(24210,109197,'1997-01-05','1998-01-05'),
(24210,112484,'1998-01-05','1999-01-05'),
(24210,116729,'1999-01-05','2000-01-05'),
(24210,118102,'2000-01-05','2001-01-04'),
(24210,118173,'2001-01-04','2002-01-04'),
(24210,121520,'2002-01-04','9999-01-01'),
(24471,51103,'1996-01-02','1997-01-01');


INSERT INTO `salaries` VALUES (24471,55421,'1997-01-01','1998-01-01'),
(24471,56752,'1998-01-01','1999-01-01'),
(24471,59730,'1999-01-01','2000-01-01'),
(24471,62599,'2000-01-01','2000-12-31'),
(24471,66937,'2000-12-31','2001-12-31'),
(24471,70188,'2001-12-31','9999-01-01'),
(25048,40000,'1988-08-01','1989-08-01'),
(25048,40534,'1989-08-01','1990-08-01'),
(25048,42915,'1990-08-01','1991-08-01'),
(25048,42693,'1991-08-01','1992-07-31');


INSERT INTO `salaries` VALUES (25048,46270,'1992-07-31','1993-07-31'),
(25048,47230,'1993-07-31','1994-07-31'),
(25048,50439,'1994-07-31','1995-07-31'),
(25048,52153,'1995-07-31','1996-07-30'),
(25048,52864,'1996-07-30','1997-07-30'),
(25048,53360,'1997-07-30','1998-07-30'),
(25048,57619,'1998-07-30','1999-07-30'),
(25048,60817,'1999-07-30','2000-07-29'),
(25048,63034,'2000-07-29','2001-07-29'),
(25048,64130,'2001-07-29','2002-07-29');


INSERT INTO `salaries` VALUES (25048,68526,'2002-07-29','9999-01-01'),
(25136,72930,'1993-02-26','1994-02-26'),
(25136,76570,'1994-02-26','1995-02-26'),
(25136,77629,'1995-02-26','1996-02-26'),
(25136,80130,'1996-02-26','1996-06-04'),
(25177,60495,'1990-12-10','1991-12-10'),
(25177,61561,'1991-12-10','1992-12-09'),
(25177,65558,'1992-12-09','1993-12-09'),
(25177,65441,'1993-12-09','1994-12-09'),
(25177,69814,'1994-12-09','1995-12-09');


INSERT INTO `salaries` VALUES (25177,69628,'1995-12-09','1996-12-08'),
(25177,72718,'1996-12-08','1997-12-08'),
(25177,73484,'1997-12-08','1998-12-08'),
(25177,75935,'1998-12-08','1999-12-08'),
(25177,78860,'1999-12-08','2000-12-07'),
(25177,81648,'2000-12-07','2001-12-07'),
(25177,84304,'2001-12-07','9999-01-01'),
(25218,45132,'1998-06-10','1999-06-10'),
(25218,44769,'1999-06-10','2000-06-09'),
(25218,45044,'2000-06-09','2001-06-09');


INSERT INTO `salaries` VALUES (25218,46482,'2001-06-09','2002-06-09'),
(25218,48004,'2002-06-09','9999-01-01'),
(25623,40000,'1996-02-06','1997-02-05'),
(25623,40869,'1997-02-05','1998-02-05'),
(25623,44289,'1998-02-05','1999-02-05'),
(25623,46308,'1999-02-05','2000-02-05'),
(25623,47574,'2000-02-05','2001-02-04'),
(25623,51202,'2001-02-04','2002-02-04'),
(25623,53137,'2002-02-04','9999-01-01'),
(26269,40000,'1989-09-17','1990-09-17');


INSERT INTO `salaries` VALUES (26269,42888,'1990-09-17','1991-09-17'),
(26269,45328,'1991-09-17','1992-09-16'),
(26269,45388,'1992-09-16','1993-09-16'),
(26269,49405,'1993-09-16','1994-09-16'),
(26269,49239,'1994-09-16','1995-09-16'),
(26269,51940,'1995-09-16','1996-09-15'),
(26269,55800,'1996-09-15','1997-09-15'),
(26269,56677,'1997-09-15','1998-09-15'),
(26269,60634,'1998-09-15','1999-09-15'),
(26269,62482,'1999-09-15','2000-09-14');


INSERT INTO `salaries` VALUES (26269,64271,'2000-09-14','2001-09-14'),
(26269,65962,'2001-09-14','9999-01-01'),
(26470,40000,'1988-07-13','1989-07-13'),
(26470,40260,'1989-07-13','1990-07-13'),
(26470,44422,'1990-07-13','1991-07-13'),
(26470,48333,'1991-07-13','1992-07-12'),
(26470,51265,'1992-07-12','1993-07-12'),
(26470,53158,'1993-07-12','1994-07-12'),
(26470,54738,'1994-07-12','1995-07-12'),
(26470,56989,'1995-07-12','1996-07-11');


INSERT INTO `salaries` VALUES (26470,60607,'1996-07-11','1997-07-11'),
(26470,62685,'1997-07-11','1998-07-11'),
(26470,63833,'1998-07-11','1999-07-11'),
(26470,65586,'1999-07-11','2000-07-10'),
(26470,65581,'2000-07-10','2001-07-10'),
(26470,66982,'2001-07-10','2002-07-10'),
(26470,68037,'2002-07-10','9999-01-01'),
(26664,42132,'1996-12-27','1997-12-27'),
(26664,44475,'1997-12-27','1998-12-27'),
(26664,47536,'1998-12-27','1999-12-27');


INSERT INTO `salaries` VALUES (26664,51528,'1999-12-27','2000-12-26'),
(26664,53335,'2000-12-26','2001-12-26'),
(26664,57564,'2001-12-26','2002-05-16'),
(26830,40000,'1985-12-19','1986-12-19'),
(26830,40454,'1986-12-19','1987-12-19'),
(26830,42832,'1987-12-19','1988-12-18'),
(26830,45669,'1988-12-18','1989-12-18'),
(26830,47344,'1989-12-18','1990-12-18'),
(26830,46986,'1990-12-18','1991-12-18'),
(26830,47058,'1991-12-18','1992-12-17');


INSERT INTO `salaries` VALUES (26830,47065,'1992-12-17','1993-12-17'),
(26830,51146,'1993-12-17','1994-12-17'),
(26830,54157,'1994-12-17','1995-12-17'),
(26830,56949,'1995-12-17','1996-12-16'),
(26830,58803,'1996-12-16','1997-12-16'),
(26830,58484,'1997-12-16','1998-12-16'),
(26830,60886,'1998-12-16','1999-12-16'),
(26830,63170,'1999-12-16','2000-12-15'),
(26830,64297,'2000-12-15','2001-12-15'),
(26830,66294,'2001-12-15','9999-01-01');


INSERT INTO `salaries` VALUES (27113,40951,'1993-12-01','1994-12-01'),
(27113,44575,'1994-12-01','1995-12-01'),
(27113,46946,'1995-12-01','1996-11-30'),
(27113,49315,'1996-11-30','1997-11-30'),
(27113,51016,'1997-11-30','1998-11-30'),
(27113,52644,'1998-11-30','1999-11-30'),
(27113,55955,'1999-11-30','2000-11-29'),
(27113,55932,'2000-11-29','2001-11-29'),
(27113,55729,'2001-11-29','9999-01-01'),
(28822,67858,'1989-12-17','1990-12-17');


INSERT INTO `salaries` VALUES (28822,69442,'1990-12-17','1991-12-17'),
(28822,69070,'1991-12-17','1992-12-16'),
(28822,71648,'1992-12-16','1993-12-16'),
(28822,73359,'1993-12-16','1994-12-16'),
(28822,77613,'1994-12-16','1995-12-16'),
(28822,78693,'1995-12-16','1996-12-15'),
(28822,81908,'1996-12-15','1997-12-15'),
(28822,81897,'1997-12-15','1998-12-15'),
(28822,85356,'1998-12-15','1999-12-15'),
(28822,86202,'1999-12-15','2000-12-14');


INSERT INTO `salaries` VALUES (28822,89231,'2000-12-14','2001-12-14'),
(28822,89031,'2001-12-14','9999-01-01'),
(28890,40000,'1987-05-20','1988-05-19'),
(28890,42410,'1988-05-19','1989-05-19'),
(28890,42658,'1989-05-19','1990-05-19'),
(28890,46334,'1990-05-19','1991-05-19'),
(28890,49632,'1991-05-19','1992-05-18'),
(28890,50506,'1992-05-18','1993-05-18'),
(28890,53587,'1993-05-18','1994-05-18'),
(28890,55927,'1994-05-18','1995-05-18');


INSERT INTO `salaries` VALUES (28890,56457,'1995-05-18','1996-05-17'),
(28890,57773,'1996-05-17','1997-05-17'),
(28890,59166,'1997-05-17','1998-05-17'),
(28890,62064,'1998-05-17','1999-05-17'),
(28890,66239,'1999-05-17','2000-05-16'),
(28890,65950,'2000-05-16','2001-05-16'),
(28890,66277,'2001-05-16','2002-05-16'),
(28890,68359,'2002-05-16','9999-01-01'),
(29240,57189,'1992-11-04','1993-11-04'),
(29240,58282,'1993-11-04','1994-11-04');


INSERT INTO `salaries` VALUES (29240,58430,'1994-11-04','1995-11-04'),
(29240,57979,'1995-11-04','1996-11-03'),
(29240,60783,'1996-11-03','1997-11-03'),
(29240,62429,'1997-11-03','1998-11-03'),
(29240,64694,'1998-11-03','1999-11-03'),
(29240,64942,'1999-11-03','2000-11-02'),
(29240,66637,'2000-11-02','2001-11-02'),
(29240,67295,'2001-11-02','9999-01-01'),
(29409,43224,'1990-11-29','1991-11-29'),
(29409,43488,'1991-11-29','1992-11-28');


INSERT INTO `salaries` VALUES (29409,43572,'1992-11-28','1993-11-28'),
(29409,47855,'1993-11-28','1994-11-28'),
(29409,47821,'1994-11-28','1995-11-28'),
(29409,49195,'1995-11-28','1996-11-27'),
(29409,49179,'1996-11-27','1997-11-27'),
(29409,50687,'1997-11-27','1998-11-27'),
(29409,54214,'1998-11-27','1999-11-27'),
(29409,57430,'1999-11-27','2000-11-26'),
(29409,59655,'2000-11-26','2001-11-26'),
(29409,62182,'2001-11-26','9999-01-01');


INSERT INTO `salaries` VALUES (30058,40000,'1994-03-26','1995-03-26'),
(30058,41130,'1995-03-26','1996-03-25'),
(30058,42162,'1996-03-25','1997-03-25'),
(30058,43719,'1997-03-25','1998-03-25'),
(30058,48107,'1998-03-25','1999-03-25'),
(30058,49495,'1999-03-25','2000-03-24'),
(30058,53044,'2000-03-24','2001-03-24'),
(30058,54562,'2001-03-24','2002-03-24'),
(30058,56556,'2002-03-24','9999-01-01'),
(30303,44574,'1997-02-08','1998-02-08');


INSERT INTO `salaries` VALUES (30303,48091,'1998-02-08','1999-02-08'),
(30303,50010,'1999-02-08','2000-02-08'),
(30303,53963,'2000-02-08','2001-02-07'),
(30303,57715,'2001-02-07','2002-02-07'),
(30303,59031,'2002-02-07','9999-01-01'),
(30837,40000,'1991-08-27','1992-08-26'),
(30837,41757,'1992-08-26','1993-08-26'),
(30837,45092,'1993-08-26','1994-08-26'),
(30837,45650,'1994-08-26','1995-08-26'),
(30837,47479,'1995-08-26','1996-08-25');


INSERT INTO `salaries` VALUES (30837,50593,'1996-08-25','1997-08-25'),
(30837,53145,'1997-08-25','1998-08-25'),
(30837,56535,'1998-08-25','1999-08-25'),
(30837,59776,'1999-08-25','2000-08-24'),
(30837,62146,'2000-08-24','2001-08-24'),
(30837,63082,'2001-08-24','9999-01-01'),
(30899,50645,'1989-08-23','1990-08-23'),
(30899,50714,'1990-08-23','1991-08-23'),
(30899,55097,'1991-08-23','1992-08-22'),
(30899,57846,'1992-08-22','1993-08-22');


INSERT INTO `salaries` VALUES (30899,59378,'1993-08-22','1994-08-22'),
(30899,63318,'1994-08-22','1995-08-22'),
(30899,63375,'1995-08-22','1996-08-21'),
(30899,63259,'1996-08-21','1997-08-21'),
(30899,64595,'1997-08-21','1998-08-21'),
(30899,65111,'1998-08-21','1999-08-21'),
(30899,67535,'1999-08-21','2000-08-20'),
(30899,69796,'2000-08-20','2001-08-20'),
(30899,69699,'2001-08-20','9999-01-01'),
(30917,45307,'1995-07-06','1996-07-05');


INSERT INTO `salaries` VALUES (30917,49018,'1996-07-05','1997-07-05'),
(30917,53512,'1997-07-05','1998-07-05'),
(30917,54583,'1998-07-05','1999-07-05'),
(30917,55286,'1999-07-05','2000-07-04'),
(30917,56874,'2000-07-04','2001-07-04'),
(30917,58384,'2001-07-04','2002-07-04'),
(30917,59880,'2002-07-04','9999-01-01'),
(31093,59318,'1989-08-20','1990-08-20'),
(31093,62501,'1990-08-20','1991-08-20'),
(31093,62755,'1991-08-20','1992-08-19');


INSERT INTO `salaries` VALUES (31093,63908,'1992-08-19','1993-08-19'),
(31093,66939,'1993-08-19','1994-08-19'),
(31093,69297,'1994-08-19','1995-08-19'),
(31093,71240,'1995-08-19','1996-08-18'),
(31093,73158,'1996-08-18','1997-08-18'),
(31093,72835,'1997-08-18','1998-08-18'),
(31093,73061,'1998-08-18','1999-08-18'),
(31093,73553,'1999-08-18','2000-08-17'),
(31093,77549,'2000-08-17','2001-08-17'),
(31093,79774,'2001-08-17','9999-01-01');


INSERT INTO `salaries` VALUES (31107,53759,'1996-02-03','1997-02-02'),
(31107,57173,'1997-02-02','1998-02-02'),
(31107,60341,'1998-02-02','1999-02-02'),
(31107,64289,'1999-02-02','2000-02-02'),
(31107,64005,'2000-02-02','2001-02-01'),
(31107,66232,'2001-02-01','2002-02-01'),
(31107,70546,'2002-02-01','9999-01-01'),
(31533,68960,'1988-12-21','1989-12-21'),
(31533,70999,'1989-12-21','1990-12-21'),
(31533,72519,'1990-12-21','1991-12-21');


INSERT INTO `salaries` VALUES (31533,72350,'1991-12-21','1992-12-20'),
(31533,72317,'1992-12-20','1993-12-20'),
(31533,76365,'1993-12-20','1994-12-20'),
(31533,79541,'1994-12-20','1995-12-20'),
(31533,83407,'1995-12-20','1996-12-19'),
(31533,86629,'1996-12-19','1997-12-19'),
(31533,90779,'1997-12-19','1998-12-19'),
(31533,93280,'1998-12-19','1999-12-19'),
(31533,97041,'1999-12-19','2000-12-18'),
(31533,99900,'2000-12-18','2001-12-18');


INSERT INTO `salaries` VALUES (31533,99801,'2001-12-18','9999-01-01'),
(31931,57226,'1985-09-02','1986-09-02'),
(31931,59678,'1986-09-02','1987-09-02'),
(31931,59674,'1987-09-02','1988-09-01'),
(31931,61491,'1988-09-01','1989-09-01'),
(31931,61567,'1989-09-01','1990-09-01'),
(31931,62403,'1990-09-01','1991-09-01'),
(31931,65043,'1991-09-01','1992-08-31'),
(31931,67843,'1992-08-31','1993-08-31'),
(31931,71046,'1993-08-31','1994-08-31');


INSERT INTO `salaries` VALUES (31931,73174,'1994-08-31','1995-08-31'),
(31931,75092,'1995-08-31','1996-08-30'),
(31931,78413,'1996-08-30','1997-08-30'),
(31931,81415,'1997-08-30','1998-08-30'),
(31931,82869,'1998-08-30','1999-08-30'),
(31931,86451,'1999-08-30','2000-08-29'),
(31931,87551,'2000-08-29','2001-08-29'),
(31931,90651,'2001-08-29','9999-01-01'),
(32781,42753,'1999-05-17','2000-05-16'),
(32781,43849,'2000-05-16','2001-05-16');


INSERT INTO `salaries` VALUES (32781,47450,'2001-05-16','2002-05-16'),
(32781,48196,'2002-05-16','9999-01-01'),
(32884,40000,'1997-01-05','1998-01-05'),
(32884,43956,'1998-01-05','1999-01-05'),
(32884,44811,'1999-01-05','2000-01-05'),
(32884,45634,'2000-01-05','2001-01-04'),
(32884,49164,'2001-01-04','2002-01-04'),
(32884,50870,'2002-01-04','9999-01-01'),
(33115,44843,'1988-11-28','1989-11-28'),
(33115,46738,'1989-11-28','1990-11-28');


INSERT INTO `salaries` VALUES (33115,49737,'1990-11-28','1991-11-28'),
(33115,49271,'1991-11-28','1992-11-27'),
(33115,49591,'1992-11-27','1993-11-27'),
(33115,49891,'1993-11-27','1994-11-27'),
(33115,49628,'1994-11-27','1995-11-27'),
(33115,49859,'1995-11-27','1996-11-26'),
(33115,50794,'1996-11-26','1997-11-26'),
(33115,52241,'1997-11-26','1998-11-26'),
(33115,52989,'1998-11-26','1999-11-26'),
(33115,53581,'1999-11-26','2000-11-25');


INSERT INTO `salaries` VALUES (33115,57144,'2000-11-25','2001-11-25'),
(33115,59909,'2001-11-25','9999-01-01'),
(33272,59647,'1989-09-02','1990-09-02'),
(33272,63898,'1990-09-02','1991-09-02'),
(33272,65831,'1991-09-02','1992-09-01'),
(33272,66422,'1992-09-01','1993-09-01'),
(33272,67571,'1993-09-01','1994-09-01'),
(33272,71520,'1994-09-01','1995-09-01'),
(33272,73996,'1995-09-01','1996-08-31'),
(33272,76950,'1996-08-31','1997-08-31');


INSERT INTO `salaries` VALUES (33272,80489,'1997-08-31','1998-08-31'),
(33272,80345,'1998-08-31','1999-08-31'),
(33272,84588,'1999-08-31','2000-08-30'),
(33272,85314,'2000-08-30','2001-08-30'),
(33272,88851,'2001-08-30','9999-01-01'),
(33864,47981,'1998-04-15','1999-04-15'),
(33864,52012,'1999-04-15','2000-04-14'),
(33864,53455,'2000-04-14','2001-04-14'),
(33864,57485,'2001-04-14','2002-04-14'),
(33864,60621,'2002-04-14','9999-01-01');


INSERT INTO `salaries` VALUES (34026,44899,'1989-01-21','1990-01-21'),
(34026,47964,'1990-01-21','1990-09-26'),
(34113,50816,'1988-08-10','1989-08-10'),
(34113,51983,'1989-08-10','1990-08-10'),
(34113,54408,'1990-08-10','1991-08-10'),
(34113,57003,'1991-08-10','1992-08-09'),
(34113,59308,'1992-08-09','1993-08-09'),
(34113,62164,'1993-08-09','1994-08-09'),
(34113,62884,'1994-08-09','1995-08-09'),
(34113,63019,'1995-08-09','1996-06-13');


INSERT INTO `salaries` VALUES (34230,53639,'1993-06-02','1994-06-02'),
(34230,54826,'1994-06-02','1995-06-02'),
(34230,54964,'1995-06-02','1996-06-01'),
(34230,55160,'1996-06-01','1997-06-01'),
(34230,56290,'1997-06-01','1998-06-01'),
(34230,56726,'1998-06-01','1999-06-01'),
(34230,56993,'1999-06-01','2000-05-31'),
(34230,60969,'2000-05-31','2001-02-22'),
(34703,55874,'1989-01-09','1990-01-09'),
(34703,57467,'1990-01-09','1991-01-09');


INSERT INTO `salaries` VALUES (34703,61608,'1991-01-09','1992-01-09'),
(34703,63968,'1992-01-09','1993-01-08'),
(34703,65756,'1993-01-08','1994-01-08'),
(34703,65384,'1994-01-08','1995-01-08'),
(34703,66309,'1995-01-08','1996-01-08'),
(34703,68908,'1996-01-08','1997-01-07'),
(34703,71602,'1997-01-07','1998-01-07'),
(34703,74620,'1998-01-07','1999-01-07'),
(34703,76990,'1999-01-07','2000-01-07'),
(34703,79862,'2000-01-07','2001-01-06');


INSERT INTO `salaries` VALUES (34703,79983,'2001-01-06','2002-01-06'),
(34703,82890,'2002-01-06','9999-01-01'),
(36290,40000,'1988-04-23','1989-04-23'),
(36290,44409,'1989-04-23','1990-04-23'),
(36290,47372,'1990-04-23','1991-04-23'),
(36290,50255,'1991-04-23','1992-04-22'),
(36290,50672,'1992-04-22','1993-04-22'),
(36290,53321,'1993-04-22','1994-04-22'),
(36290,55858,'1994-04-22','1995-04-22'),
(36290,59374,'1995-04-22','1996-04-21');


INSERT INTO `salaries` VALUES (36290,60883,'1996-04-21','1997-04-21'),
(36290,65365,'1997-04-21','1998-04-21'),
(36290,69370,'1998-04-21','1999-04-21'),
(36290,70419,'1999-04-21','2000-04-20'),
(36290,72268,'2000-04-20','2001-04-20'),
(36290,75008,'2001-04-20','2002-04-20'),
(36290,75888,'2002-04-20','9999-01-01'),
(36329,53723,'1992-04-26','1993-04-26'),
(36329,53463,'1993-04-26','1994-04-26'),
(36329,56851,'1994-04-26','1995-04-26');


INSERT INTO `salaries` VALUES (36329,57512,'1995-04-26','1996-04-25'),
(36329,61732,'1996-04-25','1997-04-25'),
(36329,62736,'1997-04-25','1998-04-25'),
(36329,64413,'1998-04-25','1999-04-25'),
(36329,66699,'1999-04-25','2000-04-24'),
(36329,69904,'2000-04-24','2001-04-24'),
(36329,72497,'2001-04-24','2002-04-24'),
(36329,76132,'2002-04-24','9999-01-01'),
(36364,40000,'1997-11-27','1998-11-27'),
(36364,40894,'1998-11-27','1999-11-27');


INSERT INTO `salaries` VALUES (36364,40476,'1999-11-27','2000-11-26'),
(36364,44050,'2000-11-26','2001-11-26'),
(36364,44645,'2001-11-26','9999-01-01'),
(36523,40000,'1997-10-17','1998-10-17'),
(36523,41719,'1998-10-17','1999-10-17'),
(36523,42745,'1999-10-17','2000-10-16'),
(36523,44417,'2000-10-16','2001-10-16'),
(36523,46543,'2001-10-16','9999-01-01'),
(36634,49850,'1992-08-26','1993-08-26'),
(36634,52376,'1993-08-26','1994-08-26');


INSERT INTO `salaries` VALUES (36634,54785,'1994-08-26','1995-08-26'),
(36634,54832,'1995-08-26','1996-08-25'),
(36634,58520,'1996-08-25','1997-08-25'),
(36634,59569,'1997-08-25','1998-08-25'),
(36634,61560,'1998-08-25','1999-08-25'),
(36634,64715,'1999-08-25','2000-08-24'),
(36634,64429,'2000-08-24','2001-08-24'),
(36634,64149,'2001-08-24','9999-01-01'),
(36937,40000,'1998-09-08','1999-09-08'),
(36937,42745,'1999-09-08','2000-09-07');


INSERT INTO `salaries` VALUES (36937,42780,'2000-09-07','2001-09-07'),
(36937,46656,'2001-09-07','9999-01-01'),
(37060,43123,'1985-06-10','1986-06-10'),
(37060,43436,'1986-06-10','1987-06-10'),
(37060,46548,'1987-06-10','1988-06-09'),
(37060,48538,'1988-06-09','1989-06-09'),
(37060,48410,'1989-06-09','1990-06-09'),
(37060,51050,'1990-06-09','1991-06-09'),
(37060,53438,'1991-06-09','1992-06-08'),
(37060,57189,'1992-06-08','1993-06-08');


INSERT INTO `salaries` VALUES (37060,57745,'1993-06-08','1994-06-08'),
(37060,61811,'1994-06-08','1995-06-08'),
(37060,65875,'1995-06-08','1996-06-07'),
(37060,66707,'1996-06-07','1997-06-07'),
(37060,69290,'1997-06-07','1998-06-07'),
(37060,69950,'1998-06-07','1999-06-07'),
(37060,72347,'1999-06-07','2000-06-06'),
(37060,72640,'2000-06-06','2001-06-06'),
(37060,74059,'2001-06-06','2002-06-06'),
(37060,74008,'2002-06-06','9999-01-01');


INSERT INTO `salaries` VALUES (37308,62491,'1993-10-13','1994-10-13'),
(37308,66906,'1994-10-13','1995-10-13'),
(37308,71262,'1995-10-13','1996-10-12'),
(37308,75301,'1996-10-12','1997-10-12'),
(37308,76419,'1997-10-12','1998-10-12'),
(37308,80200,'1998-10-12','1999-10-12'),
(37308,84644,'1999-10-12','2000-10-11'),
(37308,88967,'2000-10-11','2001-10-11'),
(37308,92944,'2001-10-11','9999-01-01'),
(38107,68973,'1986-03-04','1987-03-04');


INSERT INTO `salaries` VALUES (38107,69997,'1987-03-04','1988-03-03'),
(38107,71590,'1988-03-03','1989-03-03'),
(38107,75354,'1989-03-03','1990-03-03'),
(38107,79102,'1990-03-03','1991-03-03'),
(38107,81675,'1991-03-03','1992-03-02'),
(38107,84018,'1992-03-02','1993-03-02'),
(38107,88104,'1993-03-02','1994-03-02'),
(38107,89691,'1994-03-02','1995-03-02'),
(38107,93407,'1995-03-02','1996-03-01'),
(38107,97158,'1996-03-01','1997-03-01');


INSERT INTO `salaries` VALUES (38107,97582,'1997-03-01','1998-03-01'),
(38107,98631,'1998-03-01','1999-03-01'),
(38107,100777,'1999-03-01','2000-02-29'),
(38107,101040,'2000-02-29','2001-02-28'),
(38107,104996,'2001-02-28','2002-02-28'),
(38107,107635,'2002-02-28','9999-01-01'),
(38402,85956,'1999-12-03','2000-12-02'),
(38402,88767,'2000-12-02','2001-12-02'),
(38402,88442,'2001-12-02','9999-01-01'),
(38419,78182,'1985-09-19','1986-09-19');


INSERT INTO `salaries` VALUES (38419,78593,'1986-09-19','1987-09-19'),
(38419,81881,'1987-09-19','1988-09-18'),
(38419,84304,'1988-09-18','1989-09-18'),
(38419,84463,'1989-09-18','1990-09-18'),
(38419,84042,'1990-09-18','1991-09-18'),
(38419,88199,'1991-09-18','1992-09-17'),
(38419,91867,'1992-09-17','1993-09-17'),
(38419,93894,'1993-09-17','1994-09-17'),
(38419,93704,'1994-09-17','1995-09-17'),
(38419,94848,'1995-09-17','1996-09-16');


INSERT INTO `salaries` VALUES (38419,95142,'1996-09-16','1997-09-16'),
(38419,96414,'1997-09-16','1998-09-16'),
(38419,98977,'1998-09-16','1999-09-16'),
(38419,101146,'1999-09-16','2000-09-15'),
(38419,103160,'2000-09-15','2001-09-15'),
(38419,105393,'2001-09-15','9999-01-01'),
(38588,40000,'1995-12-24','1996-12-23'),
(38588,43430,'1996-12-23','1997-12-23'),
(38588,43519,'1997-12-23','1998-12-23'),
(38588,45706,'1998-12-23','1999-12-23');


INSERT INTO `salaries` VALUES (38588,48571,'1999-12-23','2000-12-22'),
(38588,50223,'2000-12-22','2001-12-22'),
(38588,50590,'2001-12-22','9999-01-01'),
(39328,40000,'1998-05-22','1999-05-22'),
(39328,42320,'1999-05-22','2000-05-21'),
(39328,43597,'2000-05-21','2001-05-21'),
(39328,45138,'2001-05-21','2002-05-21'),
(39328,48812,'2002-05-21','9999-01-01'),
(39423,40000,'1995-10-13','1996-10-12'),
(39423,40065,'1996-10-12','1997-10-12');


INSERT INTO `salaries` VALUES (39423,42060,'1997-10-12','1998-10-12'),
(39423,44754,'1998-10-12','1999-10-12'),
(39423,47540,'1999-10-12','2000-10-11'),
(39423,50586,'2000-10-11','2001-10-11'),
(39423,51451,'2001-10-11','9999-01-01'),
(39822,40000,'1986-07-12','1987-07-12'),
(39822,41035,'1987-07-12','1988-07-11'),
(39822,45495,'1988-07-11','1989-07-11'),
(39822,45071,'1989-07-11','1990-07-11'),
(39822,45389,'1990-07-11','1991-07-11');


INSERT INTO `salaries` VALUES (39822,47855,'1991-07-11','1992-07-10'),
(39822,50261,'1992-07-10','1993-07-10'),
(39822,51273,'1993-07-10','1994-07-10'),
(39822,53427,'1994-07-10','1995-07-10'),
(39822,56021,'1995-07-10','1996-07-09'),
(39822,56904,'1996-07-09','1997-07-09'),
(39822,59753,'1997-07-09','1998-07-09'),
(39822,62182,'1998-07-09','1999-07-09'),
(39822,65699,'1999-07-09','2000-07-08'),
(39822,68342,'2000-07-08','2001-07-08');


INSERT INTO `salaries` VALUES (39822,72666,'2001-07-08','2002-07-08'),
(39822,77079,'2002-07-08','9999-01-01'),
(39972,40000,'1988-09-08','1989-09-08'),
(39972,41493,'1989-09-08','1990-09-08'),
(39972,41460,'1990-09-08','1991-09-08'),
(39972,43792,'1991-09-08','1992-09-07'),
(39972,48226,'1992-09-07','1993-09-07'),
(39972,51788,'1993-09-07','1994-09-07'),
(39972,52083,'1994-09-07','1995-09-07'),
(39972,53207,'1995-09-07','1996-09-06');


INSERT INTO `salaries` VALUES (39972,56248,'1996-09-06','1997-09-06'),
(39972,56313,'1997-09-06','1998-09-06'),
(39972,60277,'1998-09-06','1999-09-06'),
(39972,63093,'1999-09-06','2000-09-05'),
(39972,67550,'2000-09-05','2001-09-05'),
(39972,70229,'2001-09-05','9999-01-01'),
(40370,51907,'1988-07-03','1989-07-03'),
(40370,54783,'1989-07-03','1990-07-03'),
(40370,55831,'1990-07-03','1991-07-03'),
(40370,55744,'1991-07-03','1992-07-02');


INSERT INTO `salaries` VALUES (40370,57299,'1992-07-02','1993-07-02'),
(40370,60231,'1993-07-02','1994-07-02'),
(40370,60109,'1994-07-02','1995-07-02'),
(40370,60136,'1995-07-02','1996-07-01'),
(40370,60273,'1996-07-01','1997-07-01'),
(40370,59790,'1997-07-01','1998-07-01'),
(40370,61017,'1998-07-01','1999-07-01'),
(40370,61746,'1999-07-01','2000-06-30'),
(40370,63543,'2000-06-30','2001-06-30'),
(40370,63331,'2001-06-30','2002-06-30');


INSERT INTO `salaries` VALUES (40370,65809,'2002-06-30','9999-01-01'),
(40663,49738,'1996-10-22','1997-10-22'),
(40663,53957,'1997-10-22','1998-10-22'),
(40663,55219,'1998-10-22','1999-10-22'),
(40663,59684,'1999-10-22','2000-10-21'),
(40663,61508,'2000-10-21','2001-10-21'),
(40663,63399,'2001-10-21','9999-01-01'),
(40742,60510,'1998-06-17','1999-06-17'),
(40742,61759,'1999-06-17','2000-05-13'),
(40867,40000,'1993-01-18','1994-01-18');


INSERT INTO `salaries` VALUES (40867,43419,'1994-01-18','1995-01-18'),
(40867,43945,'1995-01-18','1996-01-18'),
(40867,46294,'1996-01-18','1997-01-17'),
(40867,48293,'1997-01-17','1998-01-17'),
(40867,52119,'1998-01-17','1999-01-17'),
(40867,52519,'1999-01-17','2000-01-17'),
(40867,52088,'2000-01-17','2001-01-16'),
(40867,55008,'2001-01-16','2002-01-16'),
(40867,58477,'2002-01-16','9999-01-01'),
(41268,44709,'1998-08-22','1999-08-22');


INSERT INTO `salaries` VALUES (41268,46970,'1999-08-22','2000-08-21'),
(41268,49357,'2000-08-21','2001-08-21'),
(41268,51840,'2001-08-21','9999-01-01'),
(41579,40000,'1999-07-14','2000-07-13'),
(41579,39908,'2000-07-13','2001-07-13'),
(41579,41693,'2001-07-13','2002-07-13'),
(41579,44211,'2002-07-13','9999-01-01'),
(41779,44385,'1995-10-13','1996-10-12'),
(41779,45585,'1996-10-12','1997-10-12'),
(41779,49626,'1997-10-12','1998-10-12');


INSERT INTO `salaries` VALUES (41779,54086,'1998-10-12','1999-10-12'),
(41779,57059,'1999-10-12','2000-10-11'),
(41779,61127,'2000-10-11','2001-10-11'),
(41779,61404,'2001-10-11','9999-01-01'),
(41960,83654,'1994-04-22','1995-04-22'),
(41960,87915,'1995-04-22','1996-04-21'),
(41960,92297,'1996-04-21','1997-04-21'),
(41960,95508,'1997-04-21','1998-04-21'),
(41960,99530,'1998-04-21','1999-04-21'),
(41960,100761,'1999-04-21','2000-04-20');


INSERT INTO `salaries` VALUES (41960,104165,'2000-04-20','2001-04-20'),
(41960,105230,'2001-04-20','2002-04-20'),
(41960,105154,'2002-04-20','9999-01-01'),
(42646,61360,'1989-04-03','1990-02-28'),
(43307,40000,'1992-07-07','1993-07-07'),
(43307,43651,'1993-07-07','1994-07-07'),
(43307,44306,'1994-07-07','1995-07-07'),
(43307,44096,'1995-07-07','1996-07-06'),
(43307,46894,'1996-07-06','1997-07-06'),
(43307,50082,'1997-07-06','1998-07-06');


INSERT INTO `salaries` VALUES (43307,53923,'1998-07-06','1999-07-06'),
(43307,55676,'1999-07-06','2000-07-05'),
(43307,56141,'2000-07-05','2001-07-05'),
(43307,58777,'2001-07-05','2002-07-05'),
(43307,58420,'2002-07-05','9999-01-01'),
(43569,70759,'1996-10-12','1997-10-12'),
(43569,73742,'1997-10-12','1998-10-12'),
(43569,76977,'1998-10-12','1999-10-12'),
(43569,77277,'1999-10-12','2000-10-11'),
(43569,77572,'2000-10-11','2001-10-11');


INSERT INTO `salaries` VALUES (43569,79297,'2001-10-11','9999-01-01'),
(43675,69829,'1993-01-18','1994-01-18'),
(43675,70334,'1994-01-18','1995-01-18'),
(43675,73146,'1995-01-18','1996-01-18'),
(43675,73232,'1996-01-18','1997-01-17'),
(43675,73797,'1997-01-17','1998-01-17'),
(43675,77941,'1998-01-17','1999-01-17'),
(43675,82038,'1999-01-17','2000-01-17'),
(43675,83255,'2000-01-17','2001-01-16'),
(43675,83755,'2001-01-16','2002-01-16');


INSERT INTO `salaries` VALUES (43675,84179,'2002-01-16','9999-01-01'),
(44259,40000,'1996-07-08','1997-07-08'),
(44259,44464,'1997-07-08','1998-07-08'),
(44259,46923,'1998-07-08','1999-07-08'),
(44259,48999,'1999-07-08','2000-07-07'),
(44259,51027,'2000-07-07','2001-07-07'),
(44259,54442,'2001-07-07','2002-07-07'),
(44259,58719,'2002-07-07','9999-01-01'),
(44702,54796,'1988-01-28','1989-01-27'),
(44702,56475,'1989-01-27','1990-01-27');


INSERT INTO `salaries` VALUES (44702,59183,'1990-01-27','1991-01-27'),
(44702,62093,'1991-01-27','1992-01-27'),
(44702,63853,'1992-01-27','1993-01-26'),
(44702,64168,'1993-01-26','1994-01-26'),
(44702,67927,'1994-01-26','1995-01-26'),
(44702,71420,'1995-01-26','1996-01-26'),
(44702,75752,'1996-01-26','1997-01-25'),
(44702,80193,'1997-01-25','1998-01-25'),
(44702,80874,'1998-01-25','1999-01-25'),
(44702,83498,'1999-01-25','2000-01-25');


INSERT INTO `salaries` VALUES (44702,85380,'2000-01-25','2001-01-24'),
(44702,85960,'2001-01-24','2002-01-24'),
(44702,86377,'2002-01-24','9999-01-01'),
(45338,40000,'1991-12-07','1992-12-06'),
(45338,41259,'1992-12-06','1993-12-06'),
(45338,41061,'1993-12-06','1994-12-06'),
(45338,44570,'1994-12-06','1995-12-06'),
(45338,48195,'1995-12-06','1996-12-05'),
(45338,50543,'1996-12-05','1997-12-05'),
(45338,50069,'1997-12-05','1998-12-05');


INSERT INTO `salaries` VALUES (45338,53431,'1998-12-05','1999-12-05'),
(45338,55111,'1999-12-05','2000-12-04'),
(45338,58958,'2000-12-04','2001-12-04'),
(45338,60068,'2001-12-04','9999-01-01'),
(45632,40000,'1993-09-23','1994-09-23'),
(45632,44041,'1994-09-23','1995-09-23'),
(45632,47594,'1995-09-23','1996-09-22'),
(45632,50226,'1996-09-22','1997-09-22'),
(45632,53169,'1997-09-22','1998-09-22'),
(45632,55621,'1998-09-22','1999-09-22');


INSERT INTO `salaries` VALUES (45632,56569,'1999-09-22','2000-09-21'),
(45632,60405,'2000-09-21','2001-09-21'),
(45632,63923,'2001-09-21','9999-01-01'),
(45873,56710,'1993-07-07','1994-07-07'),
(45873,59374,'1994-07-07','1995-07-07'),
(45873,61192,'1995-07-07','1996-07-06'),
(45873,61460,'1996-07-06','1997-07-06'),
(45873,61367,'1997-07-06','1998-07-06'),
(45873,63131,'1998-07-06','1999-07-06'),
(45873,65723,'1999-07-06','2000-07-05');


INSERT INTO `salaries` VALUES (45873,69158,'2000-07-05','2001-07-05'),
(45873,72370,'2001-07-05','2002-07-05'),
(45873,72546,'2002-07-05','9999-01-01'),
(45925,40000,'1997-03-01','1998-03-01'),
(45925,42468,'1998-03-01','1999-03-01'),
(45925,46177,'1999-03-01','2000-02-29'),
(45925,47599,'2000-02-29','2000-08-21'),
(45976,78466,'1989-03-25','1990-03-25'),
(45976,82505,'1990-03-25','1991-03-25'),
(45976,86424,'1991-03-25','1992-03-24');


INSERT INTO `salaries` VALUES (45976,90149,'1992-03-24','1993-03-24'),
(45976,90946,'1993-03-24','1994-03-24'),
(45976,90654,'1994-03-24','1995-03-24'),
(45976,90837,'1995-03-24','1996-03-23'),
(45976,95275,'1996-03-23','1997-03-23'),
(45976,95068,'1997-03-23','1998-03-23'),
(45976,95276,'1998-03-23','1999-03-23'),
(45976,98026,'1999-03-23','2000-03-22'),
(45976,98813,'2000-03-22','2001-03-22'),
(45976,101136,'2001-03-22','2002-03-22');


INSERT INTO `salaries` VALUES (45976,101469,'2002-03-22','2002-07-30'),
(46067,40000,'1989-11-19','1990-11-19'),
(46067,41424,'1990-11-19','1991-11-19'),
(46067,41370,'1991-11-19','1992-11-18'),
(46067,42360,'1992-11-18','1993-11-18'),
(46067,42931,'1993-11-18','1994-11-18'),
(46067,46732,'1994-11-18','1995-11-18'),
(46067,50531,'1995-11-18','1996-11-17'),
(46067,53076,'1996-11-17','1997-11-17'),
(46067,54699,'1997-11-17','1998-11-17');


INSERT INTO `salaries` VALUES (46067,56705,'1998-11-17','1999-11-17'),
(46067,57736,'1999-11-17','2000-11-16'),
(46067,61956,'2000-11-16','2001-11-16'),
(46067,64879,'2001-11-16','9999-01-01'),
(46154,40000,'1994-01-05','1995-01-05'),
(46154,41352,'1995-01-05','1996-01-05'),
(46154,41422,'1996-01-05','1997-01-04'),
(46154,44628,'1997-01-04','1998-01-04'),
(46154,46556,'1998-01-04','1999-01-04'),
(46154,47844,'1999-01-04','2000-01-04');


INSERT INTO `salaries` VALUES (46154,51122,'2000-01-04','2001-01-03'),
(46154,53084,'2001-01-03','2002-01-03'),
(46154,54397,'2002-01-03','9999-01-01'),
(46288,57202,'1992-06-07','1993-06-07'),
(46288,59395,'1993-06-07','1994-06-07'),
(46288,60717,'1994-06-07','1995-06-07'),
(46288,62042,'1995-06-07','1996-06-06'),
(46288,64517,'1996-06-06','1997-06-06'),
(46288,67773,'1997-06-06','1998-06-06'),
(46288,68704,'1998-06-06','1999-06-06');


INSERT INTO `salaries` VALUES (46288,70360,'1999-06-06','2000-06-05'),
(46288,71007,'2000-06-05','2001-06-05'),
(46288,72479,'2001-06-05','2002-06-05'),
(46288,75437,'2002-06-05','9999-01-01'),
(46397,44277,'1998-06-27','1999-06-27'),
(46397,44118,'1999-06-27','2000-06-26'),
(46397,45894,'2000-06-26','2001-06-26'),
(46397,48918,'2001-06-26','2002-06-26'),
(46397,52246,'2002-06-26','9999-01-01'),
(46467,60004,'1991-02-08','1992-02-08');


INSERT INTO `salaries` VALUES (46467,62658,'1992-02-08','1993-02-07'),
(46467,65600,'1993-02-07','1993-06-16'),
(46601,54267,'1998-09-13','1999-09-13'),
(46601,57774,'1999-09-13','2000-09-12'),
(46601,58828,'2000-09-12','2001-09-12'),
(46601,62500,'2001-09-12','9999-01-01'),
(46687,59867,'1990-08-30','1991-08-30'),
(46687,63299,'1991-08-30','1992-08-29'),
(46687,64847,'1992-08-29','1993-08-29'),
(46687,68900,'1993-08-29','1994-08-29');


INSERT INTO `salaries` VALUES (46687,71313,'1994-08-29','1995-08-29'),
(46687,73027,'1995-08-29','1996-08-28'),
(46687,76034,'1996-08-28','1997-08-28'),
(46687,76920,'1997-08-28','1998-08-28'),
(46687,77670,'1998-08-28','1999-08-28'),
(46687,77567,'1999-08-28','2000-08-27'),
(46687,79134,'2000-08-27','2001-08-27'),
(46687,80759,'2001-08-27','9999-01-01'),
(47150,40000,'1991-02-25','1992-02-25'),
(47150,43419,'1992-02-25','1993-02-24');


INSERT INTO `salaries` VALUES (47150,47282,'1993-02-24','1994-02-24'),
(47150,49591,'1994-02-24','1995-02-24'),
(47150,50819,'1995-02-24','1996-02-24'),
(47150,50345,'1996-02-24','1997-02-23'),
(47150,54353,'1997-02-23','1998-02-23'),
(47150,56886,'1998-02-23','1999-02-23'),
(47150,58171,'1999-02-23','2000-02-23'),
(47150,60014,'2000-02-23','2001-02-22'),
(47150,60708,'2001-02-22','2002-02-22'),
(47150,60475,'2002-02-22','9999-01-01');


INSERT INTO `salaries` VALUES (47221,40000,'1987-02-13','1988-02-13'),
(47221,42594,'1988-02-13','1989-02-12'),
(47221,43911,'1989-02-12','1990-02-12'),
(47221,45794,'1990-02-12','1991-02-12'),
(47221,47322,'1991-02-12','1992-02-12'),
(47221,47529,'1992-02-12','1993-02-11'),
(47221,51995,'1993-02-11','1994-02-11'),
(47221,55900,'1994-02-11','1995-02-11'),
(47221,55479,'1995-02-11','1996-02-11'),
(47221,59099,'1996-02-11','1997-02-10');


INSERT INTO `salaries` VALUES (47221,62659,'1997-02-10','1998-02-10'),
(47221,66525,'1998-02-10','1999-02-10'),
(47221,67800,'1999-02-10','2000-02-10'),
(47221,72138,'2000-02-10','2001-02-09'),
(47221,75609,'2001-02-09','2002-02-09'),
(47221,78241,'2002-02-09','9999-01-01'),
(47319,65839,'1987-03-21','1988-03-20'),
(47319,69964,'1988-03-20','1989-03-20'),
(47319,72737,'1989-03-20','1990-03-20'),
(47319,75620,'1990-03-20','1991-03-20');


INSERT INTO `salaries` VALUES (47319,77718,'1991-03-20','1991-07-03'),
(47436,40000,'1996-09-13','1997-09-13'),
(47436,40121,'1997-09-13','1998-09-13'),
(47436,41726,'1998-09-13','1999-09-13'),
(47436,41609,'1999-09-13','2000-09-12'),
(47436,43411,'2000-09-12','2001-09-12'),
(47436,47138,'2001-09-12','9999-01-01'),
(47440,40000,'1989-11-12','1990-11-12'),
(47440,43457,'1990-11-12','1991-11-12'),
(47440,43093,'1991-11-12','1992-11-11');


INSERT INTO `salaries` VALUES (47440,44473,'1992-11-11','1993-04-15'),
(48034,42133,'1989-05-19','1990-05-19'),
(48034,42405,'1990-05-19','1991-05-19'),
(48034,44446,'1991-05-19','1992-05-18'),
(48034,47544,'1992-05-18','1993-05-18'),
(48034,47264,'1993-05-18','1994-05-18'),
(48034,50477,'1994-05-18','1995-05-18'),
(48034,50229,'1995-05-18','1996-05-17'),
(48034,54175,'1996-05-17','1997-05-17'),
(48034,54062,'1997-05-17','1998-05-17');


INSERT INTO `salaries` VALUES (48034,56856,'1998-05-17','1999-05-17'),
(48034,61147,'1999-05-17','2000-05-16'),
(48034,61745,'2000-05-16','2001-05-16'),
(48034,62399,'2001-05-16','2002-05-16'),
(48034,64470,'2002-05-16','9999-01-01'),
(48183,59806,'1997-09-19','1998-09-19'),
(48183,61554,'1998-09-19','1999-09-19'),
(48183,63003,'1999-09-19','2000-09-18'),
(48183,65211,'2000-09-18','2001-09-18'),
(48183,64846,'2001-09-18','9999-01-01');


INSERT INTO `salaries` VALUES (48410,67808,'1997-03-26','1998-03-26'),
(48410,71836,'1998-03-26','1999-03-26'),
(48410,73197,'1999-03-26','2000-03-25'),
(48410,77518,'2000-03-25','2001-03-25'),
(48410,80334,'2001-03-25','2002-03-25'),
(48410,80356,'2002-03-25','9999-01-01'),
(48841,55440,'1998-12-06','1999-12-06'),
(48841,55226,'1999-12-06','2000-12-05'),
(48841,58092,'2000-12-05','2001-12-05'),
(48841,57649,'2001-12-05','9999-01-01');


INSERT INTO `salaries` VALUES (49232,105529,'1985-12-25','1986-12-25'),
(49232,107913,'1986-12-25','1987-12-25'),
(49232,108435,'1987-12-25','1988-12-24'),
(49232,108929,'1988-12-24','1989-12-24'),
(49232,109021,'1989-12-24','1990-12-24'),
(49232,108751,'1990-12-24','1991-12-24'),
(49232,111970,'1991-12-24','1992-12-23'),
(49232,113112,'1992-12-23','1993-12-23'),
(49232,116443,'1993-12-23','1994-12-23'),
(49232,119919,'1994-12-23','1995-12-23');


INSERT INTO `salaries` VALUES (49232,123687,'1995-12-23','1996-12-22'),
(49232,125013,'1996-12-22','1997-12-22'),
(49232,129191,'1997-12-22','1998-12-22'),
(49232,133382,'1998-12-22','1999-12-22'),
(49232,135390,'1999-12-22','2000-12-21'),
(49232,138547,'2000-12-21','2001-12-21'),
(49232,141399,'2001-12-21','9999-01-01'),
(49356,79550,'1996-10-06','1997-10-06'),
(49356,82188,'1997-10-06','1998-10-06'),
(49356,83466,'1998-10-06','1999-10-06');


INSERT INTO `salaries` VALUES (49356,85465,'1999-10-06','2000-10-05'),
(49356,85778,'2000-10-05','2001-10-05'),
(49356,90219,'2001-10-05','9999-01-01'),
(49450,40000,'1998-05-17','1999-05-17'),
(49450,39847,'1999-05-17','2000-05-16'),
(49450,40678,'2000-05-16','2001-05-16'),
(49450,41257,'2001-05-16','2002-05-16'),
(49450,45449,'2002-05-16','9999-01-01'),
(49524,80839,'1998-08-20','1999-08-20'),
(49524,81413,'1999-08-20','2000-08-19');


INSERT INTO `salaries` VALUES (49524,82920,'2000-08-19','2001-08-19'),
(49524,83687,'2001-08-19','9999-01-01'),
(49845,76798,'1989-11-13','1990-11-13'),
(49845,80582,'1990-11-13','1991-11-13'),
(49845,82791,'1991-11-13','1992-11-12'),
(49845,86118,'1992-11-12','1993-11-12'),
(49845,88437,'1993-11-12','1994-11-12'),
(49845,88298,'1994-11-12','1995-11-12'),
(49845,88465,'1995-11-12','1996-11-11'),
(49845,89541,'1996-11-11','1997-11-11');


INSERT INTO `salaries` VALUES (49845,89774,'1997-11-11','1998-11-11'),
(49845,90933,'1998-11-11','1999-11-11'),
(49845,93543,'1999-11-11','2000-11-10'),
(49845,97351,'2000-11-10','2001-11-10'),
(49845,100123,'2001-11-10','9999-01-01'),
(50624,48363,'1988-12-14','1989-12-14'),
(50624,52296,'1989-12-14','1990-12-14'),
(50624,53471,'1990-12-14','1991-12-14'),
(50624,53683,'1991-12-14','1992-12-13'),
(50624,56098,'1992-12-13','1993-12-13');


INSERT INTO `salaries` VALUES (50624,57013,'1993-12-13','1994-12-13'),
(50624,59490,'1994-12-13','1995-12-13'),
(50624,63763,'1995-12-13','1996-12-12'),
(50624,67955,'1996-12-12','1997-12-12'),
(50624,68088,'1997-12-12','1998-12-12'),
(50624,70571,'1998-12-12','1999-12-12'),
(50624,75027,'1999-12-12','2000-12-11'),
(50624,74538,'2000-12-11','2001-12-11'),
(50624,77594,'2001-12-11','9999-01-01'),
(51292,40000,'1994-09-10','1995-09-10');


INSERT INTO `salaries` VALUES (51292,39992,'1995-09-10','1996-09-09'),
(51292,40502,'1996-09-09','1997-09-09'),
(51292,42118,'1997-09-09','1998-09-09'),
(51292,42960,'1998-09-09','1999-09-09'),
(51292,44202,'1999-09-09','2000-09-08'),
(51292,44160,'2000-09-08','2001-09-08'),
(51292,47364,'2001-09-08','9999-01-01'),
(51314,53893,'1991-10-02','1992-10-01'),
(51314,55141,'1992-10-01','1993-10-01'),
(51314,54980,'1993-10-01','1994-10-01');


INSERT INTO `salaries` VALUES (51314,58899,'1994-10-01','1995-10-01'),
(51314,60585,'1995-10-01','1996-09-30'),
(51314,62169,'1996-09-30','1997-09-30'),
(51314,65200,'1997-09-30','1998-09-30'),
(51314,65496,'1998-09-30','1999-09-30'),
(51314,67631,'1999-09-30','2000-09-29'),
(51314,67847,'2000-09-29','2001-09-29'),
(51314,68713,'2001-09-29','9999-01-01'),
(51403,40000,'1997-02-16','1998-02-16'),
(51403,41094,'1998-02-16','1999-02-16');


INSERT INTO `salaries` VALUES (51403,42003,'1999-02-16','2000-02-16'),
(51403,44106,'2000-02-16','2000-09-21'),
(51834,56935,'1997-09-04','1998-09-04'),
(51834,59015,'1998-09-04','1999-09-04'),
(51834,61292,'1999-09-04','2000-09-03'),
(51834,63694,'2000-09-03','2001-09-03'),
(51834,63964,'2001-09-03','9999-01-01'),
(52002,51639,'1990-03-05','1991-03-05'),
(52002,54840,'1991-03-05','1992-03-04'),
(52002,55128,'1992-03-04','1993-03-04');


INSERT INTO `salaries` VALUES (52002,55220,'1993-03-04','1994-03-04'),
(52002,59293,'1994-03-04','1995-03-04'),
(52002,59704,'1995-03-04','1996-03-03'),
(52002,62222,'1996-03-03','1997-03-03'),
(52002,66435,'1997-03-03','1998-03-03'),
(52002,70269,'1998-03-03','1999-03-03'),
(52002,72111,'1999-03-03','2000-03-02'),
(52002,76168,'2000-03-02','2001-03-02'),
(52002,78140,'2001-03-02','2002-03-02'),
(52002,80125,'2002-03-02','9999-01-01');


INSERT INTO `salaries` VALUES (52109,61976,'1985-04-09','1986-04-09'),
(52109,62566,'1986-04-09','1987-04-09'),
(52109,65207,'1987-04-09','1988-04-08'),
(52109,67310,'1988-04-08','1989-04-08'),
(52109,68298,'1989-04-08','1990-04-08'),
(52109,72286,'1990-04-08','1991-04-08'),
(52109,71875,'1991-04-08','1992-04-07'),
(52109,72488,'1992-04-07','1993-04-07'),
(52109,75713,'1993-04-07','1994-04-07'),
(52109,76865,'1994-04-07','1995-04-07');


INSERT INTO `salaries` VALUES (52109,79003,'1995-04-07','1996-04-05'),
(52109,81416,'1996-04-05','1997-04-05'),
(52109,83968,'1997-04-05','1998-04-06'),
(52109,83740,'1998-04-06','1999-04-06'),
(52109,85013,'1999-04-06','2000-04-05'),
(52109,87610,'2000-04-05','2001-04-05'),
(52109,89298,'2001-04-05','2002-04-04'),
(52109,92258,'2002-04-04','9999-01-01'),
(52175,53314,'1993-04-21','1994-04-21'),
(52175,53223,'1994-04-21','1995-04-21');


INSERT INTO `salaries` VALUES (52175,55196,'1995-04-21','1996-04-20'),
(52175,56704,'1996-04-20','1997-04-20'),
(52175,59208,'1997-04-20','1998-04-20'),
(52175,59637,'1998-04-20','1999-04-20'),
(52175,63743,'1999-04-20','2000-04-19'),
(52175,64224,'2000-04-19','2001-04-19'),
(52175,68317,'2001-04-19','2002-04-19'),
(52175,72722,'2002-04-19','9999-01-01'),
(52246,62071,'1989-04-06','1990-04-06'),
(52246,65272,'1990-04-06','1991-04-05');


INSERT INTO `salaries` VALUES (52246,67512,'1991-04-05','1992-04-04'),
(52246,69372,'1992-04-04','1993-04-05'),
(52246,73198,'1993-04-05','1994-04-05'),
(52246,76473,'1994-04-05','1995-04-05'),
(52246,76478,'1995-04-05','1996-04-03'),
(52246,77450,'1996-04-03','1997-04-03'),
(52246,77158,'1997-04-03','1998-04-03'),
(52246,80942,'1998-04-03','1999-04-03'),
(52246,85249,'1999-04-03','2000-04-03'),
(52246,88536,'2000-04-03','2001-04-03');


INSERT INTO `salaries` VALUES (52246,88204,'2001-04-03','2002-04-02'),
(52246,87748,'2002-04-02','9999-01-01'),
(52566,41675,'1998-05-29','1999-05-29'),
(52566,45354,'1999-05-29','2000-05-28'),
(52566,47744,'2000-05-28','2001-05-28'),
(52566,51586,'2001-05-28','2002-05-28'),
(52566,54483,'2002-05-28','9999-01-01'),
(52943,72427,'1999-09-03','2000-09-02'),
(52943,76657,'2000-09-02','2001-09-02'),
(52943,81047,'2001-09-02','9999-01-01');


INSERT INTO `salaries` VALUES (52983,55845,'1985-11-23','1986-11-23'),
(52983,58031,'1986-11-23','1987-11-23'),
(52983,57966,'1987-11-23','1988-11-22'),
(52983,60651,'1988-11-22','1989-11-22'),
(52983,60478,'1989-11-22','1990-11-22'),
(52983,62403,'1990-11-22','1991-11-22'),
(52983,63439,'1991-11-22','1992-11-21'),
(52983,64197,'1992-11-21','1993-11-21'),
(52983,67968,'1993-11-21','1994-11-21'),
(52983,72126,'1994-11-21','1995-11-21');


INSERT INTO `salaries` VALUES (52983,73670,'1995-11-21','1996-11-20'),
(52983,77200,'1996-11-20','1997-11-20'),
(52983,77164,'1997-11-20','1998-11-20'),
(52983,79992,'1998-11-20','1999-11-20'),
(52983,83807,'1999-11-20','2000-11-19'),
(52983,84634,'2000-11-19','2001-11-19'),
(52983,88704,'2001-11-19','9999-01-01'),
(54013,61242,'1994-07-21','1995-07-21'),
(54013,61958,'1995-07-21','1996-07-20'),
(54013,63647,'1996-07-20','1997-07-20');


INSERT INTO `salaries` VALUES (54013,66762,'1997-07-20','1998-07-20'),
(54013,67967,'1998-07-20','1999-07-20'),
(54013,70522,'1999-07-20','2000-07-19'),
(54013,74981,'2000-07-19','2001-07-19'),
(54013,75763,'2001-07-19','2002-07-19'),
(54013,78602,'2002-07-19','9999-01-01'),
(54458,72007,'1999-03-31','2000-03-30'),
(54458,72961,'2000-03-30','2001-03-30'),
(54458,75348,'2001-03-30','2002-03-30'),
(54458,75648,'2002-03-30','9999-01-01');


INSERT INTO `salaries` VALUES (54660,68248,'1994-03-20','1995-03-20'),
(54660,69297,'1995-03-20','1996-03-19'),
(54660,70865,'1996-03-19','1997-03-19'),
(54660,71751,'1997-03-19','1998-03-19'),
(54660,72732,'1998-03-19','1999-03-19'),
(54660,74506,'1999-03-19','2000-03-18'),
(54660,75432,'2000-03-18','2001-03-18'),
(54660,76803,'2001-03-18','2002-03-18'),
(54660,80899,'2002-03-18','9999-01-01'),
(54886,40000,'1996-10-03','1997-10-03');


INSERT INTO `salaries` VALUES (54886,44051,'1997-10-03','1998-10-03'),
(54886,45654,'1998-10-03','1999-10-01'),
(54908,40000,'1988-04-05','1989-04-05'),
(54908,39718,'1989-04-05','1990-04-05'),
(54908,41009,'1990-04-05','1991-04-04'),
(54908,43275,'1991-04-04','1992-04-03'),
(54908,42880,'1992-04-03','1993-04-03'),
(54908,42781,'1993-04-03','1994-04-04'),
(54908,44893,'1994-04-04','1995-04-04'),
(54908,48857,'1995-04-04','1996-04-02');


INSERT INTO `salaries` VALUES (54908,49335,'1996-04-02','1996-07-10'),
(55437,62157,'1987-03-04','1988-03-03'),
(55437,63024,'1988-03-03','1989-03-03'),
(55437,66580,'1989-03-03','1990-03-03'),
(55437,67474,'1990-03-03','1991-03-03'),
(55437,67446,'1991-03-03','1992-03-02'),
(55437,71462,'1992-03-02','1993-03-02'),
(55437,71824,'1993-03-02','1994-03-02'),
(55437,74467,'1994-03-02','1995-03-02'),
(55437,74563,'1995-03-02','1996-03-01');


INSERT INTO `salaries` VALUES (55437,76445,'1996-03-01','1997-03-01'),
(55437,79681,'1997-03-01','1998-03-01'),
(55437,80922,'1998-03-01','1999-03-01'),
(55437,82295,'1999-03-01','2000-02-29'),
(55437,81987,'2000-02-29','2001-02-28'),
(55437,85329,'2001-02-28','2002-02-28'),
(55437,87374,'2002-02-28','9999-01-01'),
(55581,58128,'1993-11-08','1994-11-08'),
(55581,61963,'1994-11-08','1995-11-08'),
(55581,64812,'1995-11-08','1996-11-07');


INSERT INTO `salaries` VALUES (55581,68401,'1996-11-07','1997-11-07'),
(55581,69733,'1997-11-07','1998-11-07'),
(55581,72718,'1998-11-07','1999-11-07'),
(55581,74743,'1999-11-07','2000-11-06'),
(55581,75092,'2000-11-06','2001-11-06'),
(55581,77013,'2001-11-06','9999-01-01'),
(56169,50798,'1997-01-28','1998-01-28'),
(56169,52998,'1998-01-28','1999-01-28'),
(56169,55142,'1999-01-28','2000-01-28'),
(56169,57615,'2000-01-28','2001-01-27');


INSERT INTO `salaries` VALUES (56169,57720,'2001-01-27','2002-01-27'),
(56169,57987,'2002-01-27','9999-01-01'),
(57385,40000,'1995-05-20','1996-05-19'),
(57385,39776,'1996-05-19','1997-05-19'),
(57385,39542,'1997-05-19','1998-05-19'),
(57385,39127,'1998-05-19','1999-05-19'),
(57385,43380,'1999-05-19','2000-05-18'),
(57385,44733,'2000-05-18','2001-05-18'),
(57385,45195,'2001-05-18','2002-05-18'),
(57385,44869,'2002-05-18','9999-01-01');


INSERT INTO `salaries` VALUES (57663,40000,'1990-01-13','1991-01-13'),
(57663,42464,'1991-01-13','1992-01-13'),
(57663,46388,'1992-01-13','1993-01-12'),
(57663,49620,'1993-01-12','1994-01-12'),
(57663,50586,'1994-01-12','1995-01-12'),
(57663,51170,'1995-01-12','1996-01-12'),
(57663,54994,'1996-01-12','1997-01-11'),
(57663,54506,'1997-01-11','1998-01-11'),
(57663,58909,'1998-01-11','1999-01-11'),
(57663,62892,'1999-01-11','2000-01-11');


INSERT INTO `salaries` VALUES (57663,63469,'2000-01-11','2001-01-10'),
(57663,63567,'2001-01-10','2002-01-10'),
(57663,67486,'2002-01-10','9999-01-01'),
(57838,56625,'1999-02-14','2000-02-14'),
(57838,56712,'2000-02-14','2001-02-13'),
(57838,58417,'2001-02-13','2002-02-13'),
(57838,61089,'2002-02-13','9999-01-01'),
(57882,62113,'1988-12-28','1989-12-28'),
(57882,65474,'1989-12-28','1990-12-28'),
(57882,68728,'1990-12-28','1991-12-28');


INSERT INTO `salaries` VALUES (57882,69170,'1991-12-28','1992-12-27'),
(57882,69858,'1992-12-27','1993-12-27'),
(57882,73103,'1993-12-27','1994-12-27'),
(57882,73363,'1994-12-27','1995-12-27'),
(57882,77637,'1995-12-27','1996-12-26'),
(57882,77889,'1996-12-26','1997-12-26'),
(57882,78514,'1997-12-26','1998-12-26'),
(57882,78548,'1998-12-26','1999-12-26'),
(57882,81699,'1999-12-26','2000-12-25'),
(57882,84405,'2000-12-25','2001-12-25');


INSERT INTO `salaries` VALUES (57882,87187,'2001-12-25','9999-01-01'),
(58391,40000,'1997-09-17','1998-09-17'),
(58391,41141,'1998-09-17','1999-09-17'),
(58391,45522,'1999-09-17','2000-09-16'),
(58391,48482,'2000-09-16','2001-09-16'),
(58391,51212,'2001-09-16','9999-01-01'),
(58626,58325,'1999-02-10','2000-02-10'),
(58626,59977,'2000-02-10','2001-02-09'),
(58626,61053,'2001-02-09','2002-02-09'),
(58626,63496,'2002-02-09','9999-01-01');


INSERT INTO `salaries` VALUES (58787,40000,'1998-06-10','1999-06-10'),
(58787,39739,'1999-06-10','2000-06-09'),
(58787,43035,'2000-06-09','2001-06-09'),
(58787,43627,'2001-06-09','2002-06-09'),
(58787,43898,'2002-06-09','9999-01-01'),
(58869,40000,'1993-06-17','1994-06-17'),
(58869,42134,'1994-06-17','1995-06-17'),
(58869,42681,'1995-06-17','1996-06-16'),
(58869,45790,'1996-06-16','1997-06-16'),
(58869,49171,'1997-06-16','1998-06-16');


INSERT INTO `salaries` VALUES (58869,50314,'1998-06-16','1999-06-16'),
(58869,50446,'1999-06-16','2000-06-15'),
(58869,53697,'2000-06-15','2001-06-15'),
(58869,56264,'2001-06-15','2002-06-15'),
(58869,58230,'2002-06-15','9999-01-01'),
(58897,57670,'1989-12-09','1990-12-09'),
(58897,57676,'1990-12-09','1991-12-09'),
(58897,58179,'1991-12-09','1992-12-08'),
(58897,60349,'1992-12-08','1993-12-08'),
(58897,62888,'1993-12-08','1994-12-08');


INSERT INTO `salaries` VALUES (58897,63692,'1994-12-08','1995-12-08'),
(58897,66351,'1995-12-08','1996-12-07'),
(58897,70118,'1996-12-07','1997-12-07'),
(58897,71546,'1997-12-07','1998-12-07'),
(58897,75350,'1998-12-07','1999-12-07'),
(58897,74859,'1999-12-07','2000-12-06'),
(58897,74907,'2000-12-06','2001-12-06'),
(58897,78557,'2001-12-06','9999-01-01'),
(58962,46421,'1998-06-30','1999-06-30'),
(58962,49113,'1999-06-30','2000-06-29');


INSERT INTO `salaries` VALUES (58962,50025,'2000-06-29','2001-06-29'),
(58962,49707,'2001-06-29','2002-06-29'),
(58962,53287,'2002-06-29','9999-01-01'),
(59124,40000,'1992-12-31','1993-12-31'),
(59124,40632,'1993-12-31','1994-12-31'),
(59124,41129,'1994-12-31','1995-12-31'),
(59124,42649,'1995-12-31','1996-12-30'),
(59124,42831,'1996-12-30','1997-12-30'),
(59124,44802,'1997-12-30','1998-12-30'),
(59124,45867,'1998-12-30','1999-12-30');


INSERT INTO `salaries` VALUES (59124,49252,'1999-12-30','2000-12-29'),
(59124,52802,'2000-12-29','2001-12-29'),
(59124,54842,'2001-12-29','2002-04-30'),
(59454,64346,'1994-05-12','1995-05-12'),
(59454,64660,'1995-05-12','1996-05-11'),
(59454,66605,'1996-05-11','1997-05-11'),
(59454,66671,'1997-05-11','1998-05-11'),
(59454,68873,'1998-05-11','1999-05-11'),
(59454,70599,'1999-05-11','2000-05-10'),
(59454,72397,'2000-05-10','2001-05-10');


INSERT INTO `salaries` VALUES (59454,76844,'2001-05-10','2002-05-10'),
(59454,76836,'2002-05-10','9999-01-01'),
(60708,56589,'2000-01-24','2001-01-23'),
(60708,58517,'2001-01-23','2002-01-23'),
(60708,61945,'2002-01-23','9999-01-01'),
(60820,42128,'1989-08-15','1990-08-15'),
(60820,42401,'1990-08-15','1991-08-15'),
(60820,46024,'1991-08-15','1992-08-14'),
(60820,48667,'1992-08-14','1993-08-14'),
(60820,48589,'1993-08-14','1994-08-14');


INSERT INTO `salaries` VALUES (60820,51503,'1994-08-14','1995-08-14'),
(60820,53488,'1995-08-14','1996-08-03'),
(61333,46244,'1986-11-03','1987-11-03'),
(61333,46322,'1987-11-03','1988-11-02'),
(61333,48719,'1988-11-02','1989-11-02'),
(61333,53075,'1989-11-02','1990-11-02'),
(61333,57288,'1990-11-02','1991-11-02'),
(61333,58400,'1991-11-02','1992-11-01'),
(61333,60977,'1992-11-01','1993-11-01'),
(61333,60568,'1993-11-01','1994-11-01');


INSERT INTO `salaries` VALUES (61333,61296,'1994-11-01','1995-11-01'),
(61333,61975,'1995-11-01','1996-10-31'),
(61333,62280,'1996-10-31','1997-10-31'),
(61333,64332,'1997-10-31','1998-10-31'),
(61333,64218,'1998-10-31','1999-10-31'),
(61333,63876,'1999-10-31','2000-10-30'),
(61333,65455,'2000-10-30','2001-10-30'),
(61333,67632,'2001-10-30','9999-01-01'),
(61600,51728,'1998-07-10','1999-07-10'),
(61600,54598,'1999-07-10','2000-07-09');


INSERT INTO `salaries` VALUES (61600,55911,'2000-07-09','2001-07-09'),
(61600,57788,'2001-07-09','2002-07-09'),
(61600,58101,'2002-07-09','9999-01-01'),
(61613,59882,'1990-01-23','1991-01-23'),
(61613,60698,'1991-01-23','1992-01-23'),
(61613,60335,'1992-01-23','1993-01-22'),
(61613,63246,'1993-01-22','1994-01-22'),
(61613,66195,'1994-01-22','1995-01-22'),
(61613,69287,'1995-01-22','1996-01-22'),
(61613,72229,'1996-01-22','1997-01-21');


INSERT INTO `salaries` VALUES (61613,72640,'1997-01-21','1998-01-21'),
(61613,75583,'1998-01-21','1999-01-21'),
(61613,77600,'1999-01-21','2000-01-21'),
(61613,77191,'2000-01-21','2001-01-20'),
(61613,80375,'2001-01-20','2002-01-20'),
(61613,82738,'2002-01-20','9999-01-01'),
(62027,68494,'1995-12-18','1996-12-17'),
(62027,70283,'1996-12-17','1997-12-17'),
(62027,73747,'1997-12-17','1998-12-17'),
(62027,77918,'1998-12-17','1999-12-17');


INSERT INTO `salaries` VALUES (62027,77472,'1999-12-17','2000-12-16'),
(62027,77463,'2000-12-16','2001-12-16'),
(62027,77502,'2001-12-16','9999-01-01'),
(62278,78335,'1994-09-21','1995-09-21'),
(62278,80692,'1995-09-21','1996-09-20'),
(62278,82617,'1996-09-20','1997-09-20'),
(62278,82709,'1997-09-20','1998-09-20'),
(62278,86094,'1998-09-20','1999-09-20'),
(62278,88719,'1999-09-20','2000-09-19'),
(62278,92429,'2000-09-19','2001-09-19');


INSERT INTO `salaries` VALUES (62278,95572,'2001-09-19','9999-01-01'),
(62419,77040,'1990-07-22','1991-07-22'),
(62419,77622,'1991-07-22','1992-07-21'),
(62419,78266,'1992-07-21','1993-07-21'),
(62419,82717,'1993-07-21','1994-07-21'),
(62419,86556,'1994-07-21','1995-07-21'),
(62419,87017,'1995-07-21','1996-07-20'),
(62419,89672,'1996-07-20','1997-07-20'),
(62419,92739,'1997-07-20','1998-07-20'),
(62419,94882,'1998-07-20','1999-07-20');


INSERT INTO `salaries` VALUES (62419,95028,'1999-07-20','1999-09-03'),
(62620,40000,'1995-08-12','1996-08-11'),
(62620,39992,'1996-08-11','1997-08-11'),
(62620,40328,'1997-08-11','1998-08-11'),
(62620,40535,'1998-08-11','1999-08-11'),
(62620,42723,'1999-08-11','2000-04-14'),
(62695,96321,'1988-01-07','1989-01-06'),
(62695,98693,'1989-01-06','1990-01-06'),
(62695,99922,'1990-01-06','1991-01-06'),
(62695,99931,'1991-01-06','1992-01-06');


INSERT INTO `salaries` VALUES (62695,104243,'1992-01-06','1993-01-05'),
(62695,104361,'1993-01-05','1994-01-05'),
(62695,107327,'1994-01-05','1995-01-05'),
(62695,110438,'1995-01-05','1996-01-05'),
(62695,110877,'1996-01-05','1997-01-04'),
(62695,112360,'1997-01-04','1998-01-04'),
(62695,114840,'1998-01-04','1999-01-04'),
(62695,114475,'1999-01-04','2000-01-04'),
(62695,117891,'2000-01-04','2001-01-03'),
(62695,121396,'2001-01-03','2002-01-03');


INSERT INTO `salaries` VALUES (62695,123167,'2002-01-03','9999-01-01'),
(62705,48588,'1996-09-10','1997-09-10'),
(62705,51461,'1997-09-10','1998-09-10'),
(62705,51402,'1998-09-10','1999-09-10'),
(62705,54139,'1999-09-10','2000-09-09'),
(62705,55091,'2000-09-09','2001-09-09'),
(62705,57619,'2001-09-09','9999-01-01'),
(62954,41774,'1987-07-12','1988-07-11'),
(62954,41329,'1988-07-11','1989-07-11'),
(62954,45729,'1989-07-11','1990-07-11');


INSERT INTO `salaries` VALUES (62954,45999,'1990-07-11','1991-07-11'),
(62954,46687,'1991-07-11','1992-07-10'),
(62954,51168,'1992-07-10','1993-07-10'),
(62954,55070,'1993-07-10','1994-07-10'),
(62954,55844,'1994-07-10','1995-07-10'),
(62954,55700,'1995-07-10','1996-07-09'),
(62954,59382,'1996-07-09','1997-07-09'),
(62954,62816,'1997-07-09','1998-07-09'),
(62954,63157,'1998-07-09','1999-07-09'),
(62954,63051,'1999-07-09','2000-07-08');


INSERT INTO `salaries` VALUES (62954,67269,'2000-07-08','2001-07-08'),
(62954,71658,'2001-07-08','2002-07-08'),
(62954,71747,'2002-07-08','9999-01-01'),
(63426,53423,'1986-06-29','1987-06-29'),
(63426,55269,'1987-06-29','1988-06-28'),
(63426,56641,'1988-06-28','1989-06-28'),
(63426,56479,'1989-06-28','1990-06-28'),
(63426,60558,'1990-06-28','1991-06-28'),
(63426,62613,'1991-06-28','1992-06-27'),
(63426,63892,'1992-06-27','1993-06-27');


INSERT INTO `salaries` VALUES (63426,65057,'1993-06-27','1994-06-27'),
(63426,69073,'1994-06-27','1995-06-27'),
(63426,69651,'1995-06-27','1996-06-26'),
(63426,74012,'1996-06-26','1997-06-26'),
(63426,76168,'1997-06-26','1998-06-26'),
(63426,78351,'1998-06-26','1999-06-26'),
(63426,79051,'1999-06-26','2000-06-25'),
(63426,80858,'2000-06-25','2001-06-25'),
(63426,80819,'2001-06-25','2002-06-25'),
(63426,81622,'2002-06-25','9999-01-01');


INSERT INTO `salaries` VALUES (63588,87462,'1988-09-20','1989-09-20'),
(63588,89989,'1989-09-20','1990-09-20'),
(63588,89790,'1990-09-20','1991-09-20'),
(63588,90114,'1991-09-20','1992-09-19'),
(63588,89933,'1992-09-19','1993-09-19'),
(63588,90217,'1993-09-19','1994-09-19'),
(63588,90805,'1994-09-19','1995-09-19'),
(63588,93776,'1995-09-19','1996-09-18'),
(63588,95927,'1996-09-18','1997-09-18'),
(63588,98334,'1997-09-18','1998-09-18');


INSERT INTO `salaries` VALUES (63588,98636,'1998-09-18','1999-09-18'),
(63588,101199,'1999-09-18','2000-09-17'),
(63588,102326,'2000-09-17','2001-09-17'),
(63588,103557,'2001-09-17','9999-01-01'),
(63737,40508,'1995-03-21','1996-03-20'),
(63737,41034,'1996-03-20','1997-03-20'),
(63737,44887,'1997-03-20','1998-03-20'),
(63737,45153,'1998-03-20','1998-09-02'),
(63786,40000,'1986-01-18','1987-01-18'),
(63786,44168,'1987-01-18','1988-01-18');


INSERT INTO `salaries` VALUES (63786,44918,'1988-01-18','1989-01-17'),
(63786,48445,'1989-01-17','1990-01-17'),
(63786,48818,'1990-01-17','1991-01-17'),
(63786,52339,'1991-01-17','1992-01-17'),
(63786,52049,'1992-01-17','1993-01-16'),
(63786,54987,'1993-01-16','1994-01-16'),
(63786,59380,'1994-01-16','1995-01-16'),
(63786,60121,'1995-01-16','1996-01-16'),
(63786,60976,'1996-01-16','1997-01-15'),
(63786,64381,'1997-01-15','1998-01-15');


INSERT INTO `salaries` VALUES (63786,65919,'1998-01-15','1999-01-15'),
(63786,67408,'1999-01-15','2000-01-15'),
(63786,71791,'2000-01-15','2001-01-14'),
(63786,72992,'2001-01-14','2002-01-14'),
(63786,76606,'2002-01-14','9999-01-01'),
(63894,53174,'1998-06-24','1999-06-24'),
(63894,56785,'1999-06-24','2000-06-23'),
(63894,60691,'2000-06-23','2000-09-14'),
(64310,40000,'1992-08-13','1993-08-13'),
(64310,40316,'1993-08-13','1994-08-13');


INSERT INTO `salaries` VALUES (64310,40405,'1994-08-13','1995-08-13'),
(64310,43565,'1995-08-13','1996-08-12'),
(64310,45841,'1996-08-12','1997-08-12'),
(64310,47356,'1997-08-12','1998-08-12'),
(64310,47455,'1998-08-12','1999-08-12'),
(64310,48438,'1999-08-12','2000-08-11'),
(64310,49406,'2000-08-11','2001-08-11'),
(64310,50709,'2001-08-11','9999-01-01'),
(64841,62485,'1986-02-14','1987-02-14'),
(64841,63531,'1987-02-14','1988-02-14');


INSERT INTO `salaries` VALUES (64841,67296,'1988-02-14','1989-02-13'),
(64841,68641,'1989-02-13','1990-02-13'),
(64841,69059,'1990-02-13','1991-02-13'),
(64841,72120,'1991-02-13','1992-02-13'),
(64841,73891,'1992-02-13','1993-02-12'),
(64841,78119,'1993-02-12','1994-02-12'),
(64841,82216,'1994-02-12','1995-02-12'),
(64841,85010,'1995-02-12','1995-10-30'),
(65333,58370,'1988-11-21','1989-11-21'),
(65333,62428,'1989-11-21','1990-11-21');


INSERT INTO `salaries` VALUES (65333,64654,'1990-11-21','1991-11-21'),
(65333,68040,'1991-11-21','1992-11-20'),
(65333,71973,'1992-11-20','1993-11-20'),
(65333,72279,'1993-11-20','1994-11-20'),
(65333,73867,'1994-11-20','1995-11-20'),
(65333,74857,'1995-11-20','1996-11-19'),
(65333,75460,'1996-11-19','1997-11-19'),
(65333,75398,'1997-11-19','1998-11-19'),
(65333,76367,'1998-11-19','1999-11-19'),
(65333,80560,'1999-11-19','2000-11-18');


INSERT INTO `salaries` VALUES (65333,83474,'2000-11-18','2001-11-18'),
(65333,86066,'2001-11-18','9999-01-01'),
(65790,40000,'1991-02-12','1992-02-12'),
(65790,41660,'1992-02-12','1993-02-11'),
(65790,41351,'1993-02-11','1994-02-11'),
(65790,41367,'1994-02-11','1995-02-11'),
(65790,44757,'1995-02-11','1996-02-11'),
(65790,45730,'1996-02-11','1997-02-10'),
(65790,46669,'1997-02-10','1998-02-10'),
(65790,46601,'1998-02-10','1999-02-10');


INSERT INTO `salaries` VALUES (65790,50980,'1999-02-10','2000-02-10'),
(65790,52927,'2000-02-10','2001-02-09'),
(65790,57129,'2001-02-09','2002-02-09'),
(65790,61185,'2002-02-09','9999-01-01'),
(65883,93721,'1991-04-19','1992-04-18'),
(65883,94038,'1992-04-18','1993-04-18'),
(65883,97038,'1993-04-18','1994-04-18'),
(65883,96887,'1994-04-18','1995-04-18'),
(65883,99379,'1995-04-18','1996-04-17'),
(65883,103768,'1996-04-17','1997-04-17');


INSERT INTO `salaries` VALUES (65883,105526,'1997-04-17','1998-04-17'),
(65883,106411,'1998-04-17','1999-04-17'),
(65883,107504,'1999-04-17','2000-04-16'),
(65883,110637,'2000-04-16','2001-04-16'),
(65883,110238,'2001-04-16','2002-04-16'),
(65883,112973,'2002-04-16','9999-01-01'),
(66118,63670,'1997-08-16','1998-08-16'),
(66118,66552,'1998-08-16','1999-08-16'),
(66118,66262,'1999-08-16','1999-11-17'),
(66674,51961,'1988-03-05','1989-03-05');


INSERT INTO `salaries` VALUES (66674,52320,'1989-03-05','1990-03-05'),
(66674,52468,'1990-03-05','1991-03-05'),
(66674,53182,'1991-03-05','1992-03-04'),
(66674,56369,'1992-03-04','1993-03-04'),
(66674,58907,'1993-03-04','1994-03-04'),
(66674,61733,'1994-03-04','1995-03-04'),
(66674,65147,'1995-03-04','1996-03-03'),
(66674,67541,'1996-03-03','1997-03-03'),
(66674,69204,'1997-03-03','1998-03-03'),
(66674,69221,'1998-03-03','1999-03-03');


INSERT INTO `salaries` VALUES (66674,71475,'1999-03-03','2000-03-02'),
(66674,74945,'2000-03-02','2001-03-02'),
(66674,76229,'2001-03-02','2002-03-02'),
(66674,77384,'2002-03-02','9999-01-01'),
(66675,70447,'1994-05-12','1995-05-12'),
(66675,71115,'1995-05-12','1996-05-11'),
(66675,74982,'1996-05-11','1997-05-11'),
(66675,77049,'1997-05-11','1998-05-11'),
(66675,79411,'1998-05-11','1999-05-11'),
(66675,83195,'1999-05-11','2000-05-10');


INSERT INTO `salaries` VALUES (66675,83687,'2000-05-10','2001-05-10'),
(66675,86350,'2001-05-10','2002-05-10'),
(66675,90413,'2002-05-10','9999-01-01'),
(66835,61723,'1998-05-21','1999-05-21'),
(66835,62621,'1999-05-21','2000-05-20'),
(66835,64117,'2000-05-20','2001-05-20'),
(66835,67234,'2001-05-20','2002-05-20'),
(66835,71535,'2002-05-20','9999-01-01'),
(67289,40000,'1999-01-02','2000-01-02'),
(67289,41906,'2000-01-02','2001-01-01');


INSERT INTO `salaries` VALUES (67289,45846,'2001-01-01','2002-01-01'),
(67289,48949,'2002-01-01','9999-01-01'),
(67488,40000,'1989-09-18','1990-09-18'),
(67488,40018,'1990-09-18','1991-09-18'),
(67488,42061,'1991-09-18','1992-09-17'),
(67488,46018,'1992-09-17','1993-09-17'),
(67488,49306,'1993-09-17','1994-09-17'),
(67488,51065,'1994-09-17','1995-09-17'),
(67488,51411,'1995-09-17','1996-05-02'),
(68370,76304,'1994-11-21','1995-11-21');


INSERT INTO `salaries` VALUES (68370,77227,'1995-11-21','1996-11-20'),
(68370,79050,'1996-11-20','1997-11-20'),
(68370,80405,'1997-11-20','1998-11-20'),
(68370,82308,'1998-11-20','1999-11-20'),
(68370,82053,'1999-11-20','2000-11-19'),
(68370,85428,'2000-11-19','2001-11-19'),
(68370,88891,'2001-11-19','9999-01-01'),
(68486,84564,'1994-10-16','1995-10-16'),
(68486,88810,'1995-10-16','1996-10-15'),
(68486,89901,'1996-10-15','1997-10-15');


INSERT INTO `salaries` VALUES (68486,92764,'1997-10-15','1998-10-15'),
(68486,93437,'1998-10-15','1999-10-15'),
(68486,94230,'1999-10-15','2000-10-14'),
(68486,95473,'2000-10-14','2001-10-14'),
(68486,95983,'2001-10-14','9999-01-01'),
(68651,43502,'1998-04-12','1999-04-12'),
(68651,47925,'1999-04-12','2000-04-11'),
(68651,49830,'2000-04-11','2001-04-11'),
(68651,54281,'2001-04-11','2002-04-11'),
(68651,57244,'2002-04-11','9999-01-01');


INSERT INTO `salaries` VALUES (68655,40000,'1997-09-04','1998-09-04'),
(68655,39808,'1998-09-04','1999-09-04'),
(68655,43682,'1999-09-04','2000-09-03'),
(68655,43827,'2000-09-03','2001-09-03'),
(68655,44102,'2001-09-03','2001-12-21'),
(69487,48211,'1998-06-14','1999-06-14'),
(69487,52486,'1999-06-14','2000-06-13'),
(69487,53316,'2000-06-13','2001-06-13'),
(69487,53521,'2001-06-13','2002-06-13'),
(69487,54902,'2002-06-13','9999-01-01');


INSERT INTO `salaries` VALUES (69815,40000,'1995-05-14','1996-05-13'),
(69815,39722,'1996-05-13','1997-05-13'),
(69815,43331,'1997-05-13','1998-05-13'),
(69815,46748,'1998-05-13','1999-05-13'),
(69815,46561,'1999-05-13','2000-05-12'),
(69815,48912,'2000-05-12','2001-05-12'),
(69815,52373,'2001-05-12','2002-05-12'),
(69815,52428,'2002-05-12','9999-01-01'),
(69974,43626,'1998-09-22','1999-09-22'),
(69974,44882,'1999-09-22','2000-09-21');


INSERT INTO `salaries` VALUES (69974,47103,'2000-09-21','2001-09-21'),
(69974,47627,'2001-09-21','9999-01-01'),
(70049,69502,'1988-05-31','1989-05-31'),
(70049,73833,'1989-05-31','1990-05-31'),
(70049,76514,'1990-05-31','1991-05-31'),
(70049,79278,'1991-05-31','1992-05-30'),
(70049,83155,'1992-05-30','1993-05-30'),
(70049,84122,'1993-05-30','1994-05-30'),
(70049,88227,'1994-05-30','1995-05-30'),
(70049,92640,'1995-05-30','1996-05-29');


INSERT INTO `salaries` VALUES (70049,92417,'1996-05-29','1997-05-29'),
(70049,96173,'1997-05-29','1998-05-29'),
(70049,96363,'1998-05-29','1999-05-29'),
(70049,96346,'1999-05-29','2000-05-28'),
(70049,98039,'2000-05-28','2001-05-28'),
(70049,98326,'2001-05-28','2002-05-28'),
(70049,101765,'2002-05-28','9999-01-01'),
(70059,53435,'1986-09-26','1987-09-26'),
(70059,57296,'1987-09-26','1988-09-25'),
(70059,60385,'1988-09-25','1989-09-25');


INSERT INTO `salaries` VALUES (70059,60293,'1989-09-25','1990-09-25'),
(70059,63679,'1990-09-25','1991-09-25'),
(70059,64695,'1991-09-25','1992-09-24'),
(70059,64904,'1992-09-24','1993-09-24'),
(70059,66111,'1993-09-24','1994-09-24'),
(70059,65792,'1994-09-24','1995-09-24'),
(70059,67592,'1995-09-24','1996-09-23'),
(70059,69285,'1996-09-23','1997-09-23'),
(70059,69533,'1997-09-23','1998-09-23'),
(70059,70498,'1998-09-23','1999-09-23');


INSERT INTO `salaries` VALUES (70059,71906,'1999-09-23','2000-09-22'),
(70059,73086,'2000-09-22','2001-09-22'),
(70059,76081,'2001-09-22','9999-01-01'),
(70176,43362,'1992-08-19','1993-08-19'),
(70176,47243,'1993-08-19','1994-08-19'),
(70176,50769,'1994-08-19','1995-08-19'),
(70176,53464,'1995-08-19','1996-08-18'),
(70176,57694,'1996-08-18','1997-08-18'),
(70176,58428,'1997-08-18','1998-08-18'),
(70176,62724,'1998-08-18','1999-08-18');


INSERT INTO `salaries` VALUES (70176,65018,'1999-08-18','2000-08-17'),
(70176,66044,'2000-08-17','2001-08-17'),
(70176,68170,'2001-08-17','9999-01-01'),
(70473,54505,'1998-01-23','1999-01-23'),
(70473,56521,'1999-01-23','2000-01-23'),
(70473,60609,'2000-01-23','2001-01-22'),
(70473,62171,'2001-01-22','2002-01-22'),
(70473,62553,'2002-01-22','9999-01-01'),
(70518,55515,'1995-08-10','1996-08-09'),
(70518,58581,'1996-08-09','1997-08-09');


INSERT INTO `salaries` VALUES (70518,61201,'1997-08-09','1998-08-09'),
(70518,64061,'1998-08-09','1999-08-09'),
(70518,66689,'1999-08-09','2000-08-08'),
(70518,67029,'2000-08-08','2001-08-08'),
(70518,69736,'2001-08-08','9999-01-01'),
(70632,43384,'1988-12-05','1989-12-05'),
(70632,45441,'1989-12-05','1990-12-05'),
(70632,47318,'1990-12-05','1991-12-05'),
(70632,51156,'1991-12-05','1992-12-04'),
(70632,50989,'1992-12-04','1993-12-04');


INSERT INTO `salaries` VALUES (70632,51513,'1993-12-04','1994-12-04'),
(70632,51804,'1994-12-04','1995-12-04'),
(70632,53605,'1995-12-04','1996-12-03'),
(70632,54246,'1996-12-03','1997-12-03'),
(70632,57676,'1997-12-03','1998-12-03'),
(70632,59024,'1998-12-03','1999-12-03'),
(70632,58732,'1999-12-03','2000-12-02'),
(70632,60209,'2000-12-02','2001-12-02'),
(70632,63909,'2001-12-02','9999-01-01'),
(70777,40481,'1997-01-25','1998-01-25');


INSERT INTO `salaries` VALUES (70777,40273,'1998-01-25','1999-01-25'),
(70777,42694,'1999-01-25','2000-01-25'),
(70777,44637,'2000-01-25','2001-01-24'),
(70777,47135,'2001-01-24','2002-01-24'),
(70777,49951,'2002-01-24','9999-01-01'),
(71587,61682,'1993-05-27','1994-05-27'),
(71587,66132,'1994-05-27','1995-05-27'),
(71587,66457,'1995-05-27','1996-05-26'),
(71587,69260,'1996-05-26','1997-05-26'),
(71587,71413,'1997-05-26','1998-05-26');


INSERT INTO `salaries` VALUES (71587,71788,'1998-05-26','1999-05-26'),
(71587,72103,'1999-05-26','2000-05-25'),
(71587,71756,'2000-05-25','2001-05-25'),
(71587,71447,'2001-05-25','2002-05-25'),
(71587,71952,'2002-05-25','9999-01-01'),
(72103,47250,'1985-08-10','1986-08-10'),
(72103,51498,'1986-08-10','1987-08-10'),
(72103,53765,'1987-08-10','1988-08-09'),
(72103,56853,'1988-08-09','1989-08-09'),
(72103,58559,'1989-08-09','1990-08-09');


INSERT INTO `salaries` VALUES (72103,59520,'1990-08-09','1991-08-09'),
(72103,63642,'1991-08-09','1992-08-08'),
(72103,64390,'1992-08-08','1993-08-08'),
(72103,66658,'1993-08-08','1994-08-08'),
(72103,70974,'1994-08-08','1995-08-08'),
(72103,70615,'1995-08-08','1996-08-07'),
(72103,71308,'1996-08-07','1997-08-07'),
(72103,74736,'1997-08-07','1998-08-07'),
(72103,79225,'1998-08-07','1999-08-07'),
(72103,81445,'1999-08-07','2000-08-06');


INSERT INTO `salaries` VALUES (72103,82399,'2000-08-06','2001-08-06'),
(72103,85755,'2001-08-06','9999-01-01'),
(72682,76887,'1988-03-04','1989-03-04'),
(72682,77455,'1989-03-04','1990-03-04'),
(72682,78789,'1990-03-04','1991-03-04'),
(72682,83024,'1991-03-04','1992-03-03'),
(72682,83815,'1992-03-03','1993-03-03'),
(72682,84035,'1993-03-03','1994-03-03'),
(72682,86528,'1994-03-03','1995-03-03'),
(72682,90731,'1995-03-03','1996-03-02');


INSERT INTO `salaries` VALUES (72682,90987,'1996-03-02','1997-03-02'),
(72682,93759,'1997-03-02','1998-03-02'),
(72682,93999,'1998-03-02','1999-03-02'),
(72682,96754,'1999-03-02','2000-03-01'),
(72682,96554,'2000-03-01','2001-03-01'),
(72682,100464,'2001-03-01','2002-03-01'),
(72682,101824,'2002-03-01','9999-01-01'),
(72856,40000,'1988-06-27','1989-06-27'),
(72856,41359,'1989-06-27','1990-06-27'),
(72856,44844,'1990-06-27','1991-06-27');


INSERT INTO `salaries` VALUES (72856,44695,'1991-06-27','1992-06-26'),
(72856,46033,'1992-06-26','1993-06-26'),
(72856,46464,'1993-06-26','1994-06-26'),
(72856,48610,'1994-06-26','1995-06-26'),
(72856,50246,'1995-06-26','1996-06-25'),
(72856,51134,'1996-06-25','1997-06-25'),
(72856,52573,'1997-06-25','1998-06-25'),
(72856,55915,'1998-06-25','1999-06-25'),
(72856,55541,'1999-06-25','2000-06-24'),
(72856,59331,'2000-06-24','2001-06-24');


INSERT INTO `salaries` VALUES (72856,59136,'2001-06-24','2002-06-24'),
(72856,59164,'2002-06-24','9999-01-01'),
(73259,40000,'1986-02-19','1987-02-19'),
(73259,39799,'1987-02-19','1988-02-19'),
(73259,41964,'1988-02-19','1989-02-18'),
(73259,41643,'1989-02-18','1990-02-18'),
(73259,43426,'1990-02-18','1991-02-18'),
(73259,45102,'1991-02-18','1992-02-18'),
(73259,49428,'1992-02-18','1993-02-17'),
(73259,50613,'1993-02-17','1994-02-17');


INSERT INTO `salaries` VALUES (73259,53837,'1994-02-17','1995-02-17'),
(73259,56979,'1995-02-17','1996-02-17'),
(73259,58720,'1996-02-17','1997-02-16'),
(73259,60100,'1997-02-16','1998-02-16'),
(73259,61157,'1998-02-16','1999-02-16'),
(73259,63995,'1999-02-16','2000-02-16'),
(73259,65582,'2000-02-16','2001-02-15'),
(73259,68370,'2001-02-15','2002-02-15'),
(73259,69784,'2002-02-15','9999-01-01'),
(73442,71561,'1989-01-01','1990-01-01');


INSERT INTO `salaries` VALUES (73442,74761,'1990-01-01','1991-01-01'),
(73442,75411,'1991-01-01','1992-01-01'),
(73442,78125,'1992-01-01','1992-12-31'),
(73442,80821,'1992-12-31','1993-12-31'),
(73442,83913,'1993-12-31','1994-12-31'),
(73442,85113,'1994-12-31','1995-12-31'),
(73442,87210,'1995-12-31','1996-12-30'),
(73442,89931,'1996-12-30','1997-12-30'),
(73442,92273,'1997-12-30','1998-12-30'),
(73442,95151,'1998-12-30','1999-12-30');


INSERT INTO `salaries` VALUES (73442,96832,'1999-12-30','2000-12-29'),
(73442,99967,'2000-12-29','2001-12-29'),
(73442,100445,'2001-12-29','9999-01-01'),
(73468,63188,'1990-01-10','1991-01-10'),
(73468,65922,'1991-01-10','1992-01-10'),
(73468,65617,'1992-01-10','1993-01-09'),
(73468,68970,'1993-01-09','1994-01-09'),
(73468,71195,'1994-01-09','1995-01-09'),
(73468,74036,'1995-01-09','1996-01-09'),
(73468,75906,'1996-01-09','1997-01-08');


INSERT INTO `salaries` VALUES (73468,75620,'1997-01-08','1998-01-08'),
(73468,79478,'1998-01-08','1999-01-08'),
(73468,82256,'1999-01-08','2000-01-08'),
(73468,82615,'2000-01-08','2001-01-07'),
(73468,83535,'2001-01-07','2002-01-07'),
(73468,84689,'2002-01-07','9999-01-01'),
(73627,53347,'1988-01-09','1989-01-08'),
(73627,57693,'1989-01-08','1990-01-08'),
(73627,57330,'1990-01-08','1991-01-08'),
(73627,58628,'1991-01-08','1992-01-08');


INSERT INTO `salaries` VALUES (73627,61432,'1992-01-08','1993-01-07'),
(73627,65871,'1993-01-07','1994-01-07'),
(73627,66790,'1994-01-07','1995-01-07'),
(73627,70252,'1995-01-07','1996-01-07'),
(73627,72692,'1996-01-07','1997-01-06'),
(73627,76265,'1997-01-06','1998-01-06'),
(73627,80543,'1998-01-06','1999-01-06'),
(73627,84930,'1999-01-06','1999-10-21'),
(73663,54968,'1996-06-03','1997-06-03'),
(73663,57422,'1997-06-03','1998-06-03');


INSERT INTO `salaries` VALUES (73663,59621,'1998-06-03','1999-06-03'),
(73663,63490,'1999-06-03','2000-06-02'),
(73663,63450,'2000-06-02','2001-06-02'),
(73663,65967,'2001-06-02','2002-06-02'),
(73663,67867,'2002-06-02','9999-01-01'),
(75198,40000,'1992-09-21','1993-09-21'),
(75198,41842,'1993-09-21','1994-09-21'),
(75198,44917,'1994-09-21','1995-09-21'),
(75198,44488,'1995-09-21','1996-09-20'),
(75198,46216,'1996-09-20','1996-11-16');


INSERT INTO `salaries` VALUES (75340,40000,'1986-05-18','1987-05-18'),
(75340,42819,'1987-05-18','1988-05-17'),
(75340,45824,'1988-05-17','1989-05-17'),
(75340,49783,'1989-05-17','1990-05-17'),
(75340,53720,'1990-05-17','1991-05-17'),
(75340,54767,'1991-05-17','1992-05-16'),
(75340,54927,'1992-05-16','1993-05-16'),
(75340,54795,'1993-05-16','1993-07-11'),
(75445,68795,'1988-11-02','1989-11-02'),
(75445,72082,'1989-11-02','1990-11-02');


INSERT INTO `salaries` VALUES (75445,75387,'1990-11-02','1991-11-02'),
(75445,76569,'1991-11-02','1992-11-01'),
(75445,77324,'1992-11-01','1993-11-01'),
(75445,80412,'1993-11-01','1994-11-01'),
(75445,80397,'1994-11-01','1995-11-01'),
(75445,83089,'1995-11-01','1996-07-10'),
(75935,40000,'1995-11-24','1996-11-23'),
(75935,40465,'1996-11-23','1997-11-23'),
(75935,40679,'1997-11-23','1998-11-23'),
(75935,42769,'1998-11-23','1999-11-23');


INSERT INTO `salaries` VALUES (75935,47017,'1999-11-23','2000-11-22'),
(75935,47473,'2000-11-22','2001-11-22'),
(75935,48988,'2001-11-22','9999-01-01'),
(76177,40000,'1993-08-28','1994-08-28'),
(76177,40692,'1994-08-28','1995-08-28'),
(76177,44834,'1995-08-28','1996-08-27'),
(76177,49107,'1996-08-27','1997-08-27'),
(76177,49641,'1997-08-27','1998-08-27'),
(76177,51277,'1998-08-27','1999-08-27'),
(76177,53256,'1999-08-27','2000-08-26');


INSERT INTO `salaries` VALUES (76177,57097,'2000-08-26','2001-08-26'),
(76177,57156,'2001-08-26','9999-01-01'),
(76190,41089,'1993-09-08','1994-09-08'),
(76190,42022,'1994-09-08','1995-09-08'),
(76190,43610,'1995-09-08','1996-09-07'),
(76190,46627,'1996-09-07','1997-09-07'),
(76190,46298,'1997-09-07','1998-09-07'),
(76190,50654,'1998-09-07','1999-09-07'),
(76190,52215,'1999-09-07','2000-09-06'),
(76190,52973,'2000-09-06','2001-09-06');


INSERT INTO `salaries` VALUES (76190,56945,'2001-09-06','9999-01-01'),
(76207,40000,'1997-11-15','1998-11-15'),
(76207,44411,'1998-11-15','1999-11-15'),
(76207,44871,'1999-11-15','2000-11-14'),
(76207,46705,'2000-11-14','2001-11-14'),
(76207,46520,'2001-11-14','9999-01-01'),
(76366,43595,'1992-11-07','1993-11-07'),
(76366,43363,'1993-11-07','1994-11-07'),
(76366,43075,'1994-11-07','1995-11-07'),
(76366,47289,'1995-11-07','1996-11-06');


INSERT INTO `salaries` VALUES (76366,50572,'1996-11-06','1997-11-06'),
(76366,53652,'1997-11-06','1998-11-06'),
(76366,56733,'1998-11-06','1999-11-06'),
(76366,58948,'1999-11-06','2000-11-05'),
(76366,58462,'2000-11-05','2001-11-05'),
(76366,61672,'2001-11-05','9999-01-01'),
(76736,85244,'1997-05-26','1998-05-26'),
(76736,87516,'1998-05-26','1998-06-21'),
(76819,55018,'1989-03-14','1990-03-14'),
(76819,55547,'1990-03-14','1991-03-14');


INSERT INTO `salaries` VALUES (76819,55979,'1991-03-14','1992-03-13'),
(76819,59000,'1992-03-13','1993-03-13'),
(76819,62771,'1993-03-13','1994-03-13'),
(76819,66219,'1994-03-13','1995-03-13'),
(76819,66866,'1995-03-13','1996-03-12'),
(76819,67002,'1996-03-12','1997-03-12'),
(76819,67775,'1997-03-12','1998-03-12'),
(76819,71048,'1998-03-12','1999-03-12'),
(76819,73535,'1999-03-12','2000-03-11'),
(76819,75277,'2000-03-11','2001-03-11');


INSERT INTO `salaries` VALUES (76819,78220,'2001-03-11','2002-03-11'),
(76819,79610,'2002-03-11','9999-01-01'),
(76914,46890,'1985-07-06','1986-07-06'),
(76914,48452,'1986-07-06','1987-07-06'),
(76914,52071,'1987-07-06','1988-07-05'),
(76914,55227,'1988-07-05','1989-07-05'),
(76914,57072,'1989-07-05','1990-07-05'),
(76914,58438,'1990-07-05','1991-07-05'),
(76914,61026,'1991-07-05','1992-07-04'),
(76914,63517,'1992-07-04','1993-07-04');


INSERT INTO `salaries` VALUES (76914,65741,'1993-07-04','1994-07-04'),
(76914,66565,'1994-07-04','1995-07-04'),
(76914,69702,'1995-07-04','1996-07-03'),
(76914,70668,'1996-07-03','1997-07-03'),
(76914,70812,'1997-07-03','1998-07-03'),
(76914,70411,'1998-07-03','1999-07-03'),
(76914,72711,'1999-07-03','2000-07-02'),
(76914,72503,'2000-07-02','2001-07-02'),
(76914,75455,'2001-07-02','2002-07-02'),
(76914,78510,'2002-07-02','9999-01-01');


INSERT INTO `salaries` VALUES (77315,40000,'1986-04-05','1987-04-05'),
(77315,41304,'1987-04-05','1988-04-04'),
(77315,45177,'1988-04-04','1989-04-04'),
(77315,45989,'1989-04-04','1990-04-04'),
(77315,46961,'1990-04-04','1991-04-04'),
(77315,48850,'1991-04-04','1992-04-03'),
(77315,49876,'1992-04-03','1993-04-03'),
(77315,50342,'1993-04-03','1994-04-03'),
(77315,50348,'1994-04-03','1995-04-03'),
(77315,53443,'1995-04-03','1996-04-02');


INSERT INTO `salaries` VALUES (77315,57793,'1996-04-02','1997-04-02'),
(77315,58862,'1997-04-02','1998-04-02'),
(77315,60213,'1998-04-02','1999-04-02'),
(77315,60719,'1999-04-02','2000-04-01'),
(77315,62172,'2000-04-01','2001-04-01'),
(77315,61820,'2001-04-01','2002-04-01'),
(77315,65377,'2002-04-01','9999-01-01'),
(78588,40000,'1986-08-06','1987-08-06'),
(78588,39833,'1987-08-06','1988-08-05'),
(78588,40579,'1988-08-05','1989-08-05');


INSERT INTO `salaries` VALUES (78588,40183,'1989-08-05','1990-08-05'),
(78588,42942,'1990-08-05','1991-08-05'),
(78588,46116,'1991-08-05','1992-08-04'),
(78588,46020,'1992-08-04','1993-08-04'),
(78588,48287,'1993-08-04','1994-08-04'),
(78588,47900,'1994-08-04','1995-08-04'),
(78588,48202,'1995-08-04','1996-08-03'),
(78588,51252,'1996-08-03','1997-08-03'),
(78588,51729,'1997-08-03','1998-08-03'),
(78588,51709,'1998-08-03','1999-08-03');


INSERT INTO `salaries` VALUES (78588,51776,'1999-08-03','2000-08-02'),
(78588,55585,'2000-08-02','2001-08-02'),
(78588,55654,'2001-08-02','9999-01-01'),
(78618,40000,'1988-03-19','1989-03-19'),
(78618,41320,'1989-03-19','1990-03-19'),
(78618,44689,'1990-03-19','1991-03-19'),
(78618,44640,'1991-03-19','1992-03-18'),
(78618,44413,'1992-03-18','1993-03-18'),
(78618,45386,'1993-03-18','1994-03-18'),
(78618,45568,'1994-03-18','1995-03-18');


INSERT INTO `salaries` VALUES (78618,46479,'1995-03-18','1996-03-17'),
(78618,50093,'1996-03-17','1997-03-17'),
(78618,49670,'1997-03-17','1998-03-17'),
(78618,53635,'1998-03-17','1999-03-17'),
(78618,53594,'1999-03-17','2000-03-16'),
(78618,53423,'2000-03-16','2001-03-16'),
(78618,56704,'2001-03-16','2002-03-16'),
(78618,60630,'2002-03-16','9999-01-01'),
(78689,47996,'1999-01-02','2000-01-02'),
(78689,52261,'2000-01-02','2001-01-01');


INSERT INTO `salaries` VALUES (78689,52022,'2001-01-01','2002-01-01'),
(78689,54163,'2002-01-01','9999-01-01'),
(79370,40000,'1993-09-04','1994-09-04'),
(79370,42612,'1994-09-04','1995-09-04'),
(79370,43978,'1995-09-04','1996-09-03'),
(79370,43974,'1996-09-03','1997-09-03'),
(79370,47780,'1997-09-03','1998-09-03'),
(79370,48636,'1998-09-03','1999-09-03'),
(79370,48803,'1999-09-03','2000-09-02'),
(79370,51714,'2000-09-02','2001-09-02');


INSERT INTO `salaries` VALUES (79370,55457,'2001-09-02','9999-01-01'),
(79446,47898,'1988-05-10','1989-05-10'),
(79446,48543,'1989-05-10','1990-05-10'),
(79446,48203,'1990-05-10','1991-05-10'),
(79446,50275,'1991-05-10','1992-05-09'),
(79446,50124,'1992-05-09','1993-05-09'),
(79446,51471,'1993-05-09','1994-05-09'),
(79446,54000,'1994-05-09','1995-05-09'),
(79446,54062,'1995-05-09','1996-05-08'),
(79446,55391,'1996-05-08','1997-05-08');


INSERT INTO `salaries` VALUES (79446,55157,'1997-05-08','1998-05-08'),
(79446,57737,'1998-05-08','1999-05-08'),
(79446,60731,'1999-05-08','2000-05-07'),
(79446,60545,'2000-05-07','2001-05-07'),
(79446,60514,'2001-05-07','2002-05-07'),
(79446,64852,'2002-05-07','9999-01-01'),
(79909,40000,'1996-07-23','1997-07-23'),
(79909,42063,'1997-07-23','1998-07-23'),
(79909,43707,'1998-07-23','1999-07-23'),
(79909,45004,'1999-07-23','2000-07-22');


INSERT INTO `salaries` VALUES (79909,47392,'2000-07-22','2000-11-22'),
(80408,40000,'1998-02-09','1999-02-09'),
(80408,44254,'1999-02-09','2000-02-09'),
(80408,48754,'2000-02-09','2001-02-08'),
(80408,48752,'2001-02-08','2002-02-08'),
(80408,48550,'2002-02-08','9999-01-01'),
(81146,40000,'1992-11-06','1993-11-06'),
(81146,40294,'1993-11-06','1994-11-06'),
(81146,40997,'1994-11-06','1995-11-06'),
(81146,43113,'1995-11-06','1996-11-05');


INSERT INTO `salaries` VALUES (81146,45146,'1996-11-05','1997-11-05'),
(81146,49099,'1997-11-05','1998-11-05'),
(81146,49746,'1998-11-05','1999-11-05'),
(81146,54182,'1999-11-05','2000-11-04'),
(81146,56958,'2000-11-04','2001-11-04'),
(81146,59371,'2001-11-04','9999-01-01'),
(81570,40000,'1987-01-21','1988-01-21'),
(81570,42322,'1988-01-21','1989-01-20'),
(81570,43602,'1989-01-20','1990-01-20'),
(81570,47924,'1990-01-20','1991-01-20');


INSERT INTO `salaries` VALUES (81570,50526,'1991-01-20','1992-01-20'),
(81570,50152,'1992-01-20','1993-01-19'),
(81570,50954,'1993-01-19','1994-01-19'),
(81570,54428,'1994-01-19','1995-01-19'),
(81570,58183,'1995-01-19','1996-01-19'),
(81570,58607,'1996-01-19','1997-01-18'),
(81570,59000,'1997-01-18','1998-01-18'),
(81570,62776,'1998-01-18','1999-01-18'),
(81570,65607,'1999-01-18','2000-01-18'),
(81570,66864,'2000-01-18','2001-01-17');


INSERT INTO `salaries` VALUES (81570,68386,'2001-01-17','2002-01-17'),
(81570,68656,'2002-01-17','9999-01-01'),
(82526,66657,'1985-06-18','1986-06-18'),
(82526,70663,'1986-06-18','1987-06-18'),
(82526,71408,'1987-06-18','1988-06-17'),
(82526,75527,'1988-06-17','1989-06-17'),
(82526,78349,'1989-06-17','1990-06-17'),
(82526,81273,'1990-06-17','1991-06-17'),
(82526,81422,'1991-06-17','1992-06-16'),
(82526,81114,'1992-06-16','1993-06-16');


INSERT INTO `salaries` VALUES (82526,84690,'1993-06-16','1994-06-16'),
(82526,88423,'1994-06-16','1995-06-16'),
(82526,92061,'1995-06-16','1996-06-15'),
(82526,96532,'1996-06-15','1997-06-15'),
(82526,96289,'1997-06-15','1998-06-15'),
(82526,97050,'1998-06-15','1999-06-15'),
(82526,98946,'1999-06-15','2000-06-14'),
(82526,99255,'2000-06-14','2001-06-14'),
(82526,99184,'2001-06-14','2002-06-14'),
(82526,103046,'2002-06-14','9999-01-01');


INSERT INTO `salaries` VALUES (82548,67887,'1994-10-22','1995-10-22'),
(82548,68181,'1995-10-22','1996-10-21'),
(82548,70256,'1996-10-21','1997-10-21'),
(82548,73643,'1997-10-21','1998-10-21'),
(82548,75254,'1998-10-21','1999-10-21'),
(82548,77269,'1999-10-21','2000-10-20'),
(82548,79705,'2000-10-20','2001-10-20'),
(82548,80581,'2001-10-20','9999-01-01'),
(83159,44134,'1998-08-19','1999-08-19'),
(83159,47018,'1999-08-19','2000-08-18');


INSERT INTO `salaries` VALUES (83159,49775,'2000-08-18','2001-08-18'),
(83159,49393,'2001-08-18','9999-01-01'),
(83207,82640,'1990-08-21','1991-08-21'),
(83207,82146,'1991-08-21','1992-08-20'),
(83207,84198,'1992-08-20','1993-08-20'),
(83207,87641,'1993-08-20','1994-08-20'),
(83207,88147,'1994-08-20','1995-08-20'),
(83207,89271,'1995-08-20','1996-08-19'),
(83207,89731,'1996-08-19','1997-08-19'),
(83207,93016,'1997-08-19','1998-08-19');


INSERT INTO `salaries` VALUES (83207,97347,'1998-08-19','1999-08-19'),
(83207,98307,'1999-08-19','2000-08-18'),
(83207,101175,'2000-08-18','2001-08-18'),
(83207,104251,'2001-08-18','9999-01-01'),
(83496,43073,'1995-12-31','1996-05-22'),
(84573,40000,'1989-01-29','1990-01-29'),
(84573,40566,'1990-01-29','1991-01-29'),
(84573,43068,'1991-01-29','1992-01-29'),
(84573,44243,'1992-01-29','1993-01-28'),
(84573,44270,'1993-01-28','1994-01-28');


INSERT INTO `salaries` VALUES (84573,47236,'1994-01-28','1995-01-28'),
(84573,50695,'1995-01-28','1996-01-28'),
(84573,51827,'1996-01-28','1997-01-27'),
(84573,55029,'1997-01-27','1998-01-27'),
(84573,57847,'1998-01-27','1999-01-27'),
(84573,57904,'1999-01-27','2000-01-27'),
(84573,57974,'2000-01-27','2001-01-26'),
(84573,58303,'2001-01-26','2002-01-26'),
(84573,62169,'2002-01-26','9999-01-01'),
(84906,93176,'1999-06-24','2000-06-23');


INSERT INTO `salaries` VALUES (84906,96783,'2000-06-23','2001-06-23'),
(84906,100639,'2001-06-23','2001-07-27'),
(85579,79765,'1994-02-27','1995-02-27'),
(85579,81898,'1995-02-27','1996-02-27'),
(85579,85243,'1996-02-27','1997-02-26'),
(85579,86256,'1997-02-26','1998-02-26'),
(85579,89380,'1998-02-26','1999-02-26'),
(85579,90871,'1999-02-26','2000-02-26'),
(85579,91313,'2000-02-26','2001-02-25'),
(85579,94715,'2001-02-25','2002-02-25');


INSERT INTO `salaries` VALUES (85579,95240,'2002-02-25','9999-01-01'),
(85835,40000,'1987-10-08','1988-10-07'),
(85835,40579,'1988-10-07','1989-10-07'),
(85835,43097,'1989-10-07','1990-10-07'),
(85835,46269,'1990-10-07','1991-10-07'),
(85835,50196,'1991-10-07','1992-10-06'),
(85835,51473,'1992-10-06','1993-10-06'),
(85835,55012,'1993-10-06','1994-10-06'),
(85835,58105,'1994-10-06','1995-10-06'),
(85835,60785,'1995-10-06','1996-10-05');


INSERT INTO `salaries` VALUES (85835,60651,'1996-10-05','1997-10-05'),
(85835,63030,'1997-10-05','1998-10-05'),
(85835,62992,'1998-10-05','1999-10-05'),
(85835,63162,'1999-10-05','2000-10-04'),
(85835,63022,'2000-10-04','2001-10-04'),
(85835,66509,'2001-10-04','9999-01-01'),
(86321,40000,'1994-04-14','1995-04-14'),
(86321,41868,'1995-04-14','1996-04-13'),
(86321,46084,'1996-04-13','1997-04-13'),
(86321,47754,'1997-04-13','1998-04-13');


INSERT INTO `salaries` VALUES (86321,47854,'1998-04-13','1999-04-13'),
(86321,47597,'1999-04-13','2000-04-12'),
(86321,49048,'2000-04-12','2001-04-12'),
(86321,48607,'2001-04-12','2002-04-12'),
(86321,48977,'2002-04-12','9999-01-01'),
(87256,72144,'1988-10-19','1989-10-19'),
(87256,76558,'1989-10-19','1990-10-19'),
(87256,79945,'1990-10-19','1991-10-19'),
(87256,81908,'1991-10-19','1992-10-18'),
(87256,82908,'1992-10-18','1993-10-18');


INSERT INTO `salaries` VALUES (87256,82605,'1993-10-18','1994-10-18'),
(87256,85809,'1994-10-18','1995-10-18'),
(87256,86220,'1995-10-18','1996-10-17'),
(87256,88177,'1996-10-17','1997-10-17'),
(87256,92003,'1997-10-17','1998-10-17'),
(87256,95368,'1998-10-17','1999-10-17'),
(87256,99495,'1999-10-17','2000-10-16'),
(87256,101799,'2000-10-16','2001-10-16'),
(87256,105472,'2001-10-16','9999-01-01'),
(87370,40000,'1996-04-20','1997-04-20');


INSERT INTO `salaries` VALUES (87370,41512,'1997-04-20','1998-04-20'),
(87370,45234,'1998-04-20','1999-04-20'),
(87370,46465,'1999-04-20','2000-04-19'),
(87370,48428,'2000-04-19','2001-04-19'),
(87370,49294,'2001-04-19','2002-04-19'),
(87370,49025,'2002-04-19','9999-01-01'),
(87644,67860,'1992-06-09','1993-06-09'),
(87644,68716,'1993-06-09','1994-06-09'),
(87644,71120,'1994-06-09','1995-06-09'),
(87644,75354,'1995-06-09','1996-06-08');


INSERT INTO `salaries` VALUES (87644,76099,'1996-06-08','1997-04-02'),
(87907,50073,'1998-04-01','1999-04-01'),
(87907,50143,'1999-04-01','1999-07-26'),
(88114,40000,'1996-03-23','1997-03-23'),
(88114,44163,'1997-03-23','1998-03-23'),
(88114,46726,'1998-03-23','1999-03-23'),
(88114,48901,'1999-03-23','2000-03-22'),
(88114,51108,'2000-03-22','2001-03-22'),
(88114,51803,'2001-03-22','2001-10-11'),
(88148,49661,'1991-09-12','1992-09-11');


INSERT INTO `salaries` VALUES (88148,53666,'1992-09-11','1993-09-11'),
(88148,55416,'1993-09-11','1994-09-11'),
(88148,57540,'1994-09-11','1995-09-11'),
(88148,59961,'1995-09-11','1996-09-10'),
(88148,63378,'1996-09-10','1997-09-10'),
(88148,65320,'1997-09-10','1998-09-10'),
(88148,65033,'1998-09-10','1999-09-10'),
(88148,64882,'1999-09-10','2000-09-09'),
(88148,69277,'2000-09-09','2001-09-09'),
(88148,72489,'2001-09-09','9999-01-01');


INSERT INTO `salaries` VALUES (88223,40000,'1996-01-19','1997-01-18'),
(88223,43616,'1997-01-18','1998-01-18'),
(88223,46594,'1998-01-18','1999-01-18'),
(88223,49168,'1999-01-18','2000-01-18'),
(88223,50624,'2000-01-18','2001-01-17'),
(88223,54286,'2001-01-17','2002-01-17'),
(88223,58331,'2002-01-17','9999-01-01'),
(89079,48287,'1987-03-15','1988-03-14'),
(89079,49439,'1988-03-14','1989-03-14'),
(89079,51968,'1989-03-14','1989-06-04');


INSERT INTO `salaries` VALUES (89549,66394,'1999-02-16','2000-02-16'),
(89549,65980,'2000-02-16','2001-02-15'),
(89549,66990,'2001-02-15','2002-02-15'),
(89549,70848,'2002-02-15','9999-01-01'),
(89747,40000,'1997-05-22','1998-05-22'),
(89747,43783,'1998-05-22','1999-05-22'),
(89747,45314,'1999-05-22','2000-05-21'),
(89747,48271,'2000-05-21','2001-05-21'),
(89747,51631,'2001-05-21','2002-05-21'),
(89747,55364,'2002-05-21','9999-01-01');


INSERT INTO `salaries` VALUES (89893,40000,'1986-12-05','1987-12-05'),
(89893,42018,'1987-12-05','1988-12-04'),
(89893,45308,'1988-12-04','1989-12-04'),
(89893,47155,'1989-12-04','1990-12-04'),
(89893,51587,'1990-12-04','1991-12-04'),
(89893,52907,'1991-12-04','1992-12-03'),
(89893,53546,'1992-12-03','1993-12-03'),
(89893,56488,'1993-12-03','1994-12-03'),
(89893,57343,'1994-12-03','1995-12-03'),
(89893,61384,'1995-12-03','1996-12-02');


INSERT INTO `salaries` VALUES (89893,62751,'1996-12-02','1997-12-02'),
(89893,65137,'1997-12-02','1998-12-02'),
(89893,69459,'1998-12-02','1999-12-02'),
(89893,72666,'1999-12-02','2000-12-01'),
(89893,76750,'2000-12-01','2001-12-01'),
(89893,79428,'2001-12-01','9999-01-01'),
(90114,40000,'1999-10-07','2000-10-06'),
(90114,42131,'2000-10-06','2001-10-06'),
(90114,43719,'2001-10-06','9999-01-01'),
(90132,46484,'1995-12-14','1996-12-13');


INSERT INTO `salaries` VALUES (90132,49265,'1996-12-13','1997-12-13'),
(90132,49684,'1997-12-13','1998-12-13'),
(90132,51053,'1998-12-13','1999-12-13'),
(90132,51348,'1999-12-13','2000-12-12'),
(90132,50878,'2000-12-12','2001-12-12'),
(90132,52881,'2001-12-12','9999-01-01'),
(90133,47259,'1998-04-02','1999-04-02'),
(90133,47194,'1999-04-02','2000-04-01'),
(90133,47813,'2000-04-01','2001-04-01'),
(90133,48484,'2001-04-01','2002-04-01');


INSERT INTO `salaries` VALUES (90133,49059,'2002-04-01','9999-01-01'),
(90212,71887,'1986-06-10','1987-06-10'),
(90212,71446,'1987-06-10','1987-11-12'),
(90726,46968,'1998-01-08','1999-01-08'),
(90726,47161,'1999-01-08','2000-01-08'),
(90726,49982,'2000-01-08','2001-01-07'),
(90726,52548,'2001-01-07','2002-01-07'),
(90726,55742,'2002-01-07','9999-01-01'),
(90930,75727,'1989-01-20','1990-01-20'),
(90930,78952,'1990-01-20','1991-01-20');


INSERT INTO `salaries` VALUES (90930,79363,'1991-01-20','1992-01-20'),
(90930,80258,'1992-01-20','1993-01-19'),
(90930,80176,'1993-01-19','1994-01-19'),
(90930,79740,'1994-01-19','1995-01-19'),
(90930,82573,'1995-01-19','1996-01-19'),
(90930,83103,'1996-01-19','1997-01-18'),
(90930,86834,'1997-01-18','1998-01-18'),
(90930,87049,'1998-01-18','1999-01-18'),
(90930,90011,'1999-01-18','2000-01-18'),
(90930,93992,'2000-01-18','2001-01-17');


INSERT INTO `salaries` VALUES (90930,97370,'2001-01-17','2002-01-17'),
(90930,97122,'2002-01-17','9999-01-01'),
(91031,52670,'1994-09-03','1995-09-03'),
(91031,52848,'1995-09-03','1996-09-02'),
(91031,53160,'1996-09-02','1997-09-02'),
(91031,53635,'1997-09-02','1998-09-02'),
(91031,57827,'1998-09-02','1999-09-02'),
(91031,58662,'1999-09-02','2000-09-01'),
(91031,62020,'2000-09-01','2001-09-01'),
(91031,64098,'2001-09-01','9999-01-01');


INSERT INTO `salaries` VALUES (91159,48351,'1998-03-30','1999-03-30'),
(91159,52148,'1999-03-30','2000-03-29'),
(91159,52303,'2000-03-29','2001-03-29'),
(91159,56494,'2001-03-29','2002-03-29'),
(91159,59032,'2002-03-29','9999-01-01'),
(91500,42243,'1997-04-13','1998-04-13'),
(91500,42299,'1998-04-13','1999-04-13'),
(91500,46410,'1999-04-13','2000-04-12'),
(91500,50388,'2000-04-12','2001-04-12'),
(91500,50236,'2001-04-12','2002-04-12');


INSERT INTO `salaries` VALUES (91500,52819,'2002-04-12','9999-01-01'),
(91517,81869,'1991-04-30','1992-04-29'),
(91517,84132,'1992-04-29','1993-04-29'),
(91517,84638,'1993-04-29','1994-04-29'),
(91517,87615,'1994-04-29','1995-04-29'),
(91517,91560,'1995-04-29','1996-04-28'),
(91517,94369,'1996-04-28','1997-04-28'),
(91517,98336,'1997-04-28','1998-04-28'),
(91517,99053,'1998-04-28','1999-04-28'),
(91517,100926,'1999-04-28','2000-04-27');


INSERT INTO `salaries` VALUES (91517,102511,'2000-04-27','2001-04-27'),
(91517,102307,'2001-04-27','2002-04-27'),
(91517,104246,'2002-04-27','9999-01-01'),
(92069,54388,'1989-06-04','1990-06-04'),
(92069,58460,'1990-06-04','1991-06-04'),
(92069,59970,'1991-06-04','1992-06-03'),
(92069,61544,'1992-06-03','1993-06-03'),
(92069,61706,'1993-06-03','1994-06-03'),
(92069,63060,'1994-06-03','1994-11-05'),
(92344,40000,'1988-12-19','1989-12-19');


INSERT INTO `salaries` VALUES (92344,42252,'1989-12-19','1990-12-19'),
(92344,44051,'1990-12-19','1991-12-19'),
(92344,44812,'1991-12-19','1992-12-18'),
(92344,48114,'1992-12-18','1993-12-18'),
(92344,48299,'1993-12-18','1994-12-18'),
(92344,49401,'1994-12-18','1995-12-18'),
(92344,51127,'1995-12-18','1996-12-17'),
(92344,55353,'1996-12-17','1997-12-17'),
(92344,57422,'1997-12-17','1998-12-17'),
(92344,57178,'1998-12-17','1999-12-17');


INSERT INTO `salaries` VALUES (92344,60425,'1999-12-17','2000-12-16'),
(92344,63372,'2000-12-16','2001-12-16'),
(92344,63013,'2001-12-16','9999-01-01'),
(92541,40000,'1995-10-16','1996-10-15'),
(92541,44143,'1996-10-15','1997-10-15'),
(92541,45553,'1997-10-15','1998-10-15'),
(92541,45542,'1998-10-15','1999-10-15'),
(92541,49213,'1999-10-15','2000-10-14'),
(92541,50178,'2000-10-14','2001-10-14'),
(92541,51193,'2001-10-14','9999-01-01');


INSERT INTO `salaries` VALUES (92705,50510,'1991-10-10','1992-10-09'),
(92705,54373,'1992-10-09','1993-10-09'),
(92705,57304,'1993-10-09','1994-10-09'),
(92705,59863,'1994-10-09','1995-10-09'),
(92705,61112,'1995-10-09','1996-10-08'),
(92705,61221,'1996-10-08','1997-10-08'),
(92705,64645,'1997-10-08','1998-10-08'),
(92705,68837,'1998-10-08','1999-10-08'),
(92705,72103,'1999-10-08','2000-10-07'),
(92705,74790,'2000-10-07','2001-10-07');


INSERT INTO `salaries` VALUES (92705,76609,'2001-10-07','9999-01-01'),
(92921,41800,'1987-06-04','1988-06-03'),
(92921,42061,'1988-06-03','1989-06-03'),
(92921,42159,'1989-06-03','1990-06-03'),
(92921,41677,'1990-06-03','1991-06-03'),
(92921,44277,'1991-06-03','1992-06-02'),
(92921,44044,'1992-06-02','1993-06-02'),
(92921,47729,'1993-06-02','1994-06-02'),
(92921,47627,'1994-06-02','1995-06-02'),
(92921,50030,'1995-06-02','1996-06-01');


INSERT INTO `salaries` VALUES (92921,51312,'1996-06-01','1997-06-01'),
(92921,54448,'1997-06-01','1998-06-01'),
(92921,57005,'1998-06-01','1999-06-01'),
(92921,59902,'1999-06-01','2000-05-31'),
(92921,61564,'2000-05-31','2001-05-31'),
(92921,64720,'2001-05-31','2002-05-31'),
(92921,68227,'2002-05-31','9999-01-01'),
(93036,45928,'1987-03-24','1988-03-23'),
(93036,48965,'1988-03-23','1989-03-23'),
(93036,52868,'1989-03-23','1990-03-23');


INSERT INTO `salaries` VALUES (93036,55732,'1990-03-23','1991-03-23'),
(93036,57401,'1991-03-23','1992-03-22'),
(93036,58106,'1992-03-22','1993-03-22'),
(93036,60175,'1993-03-22','1994-03-22'),
(93036,61590,'1994-03-22','1995-03-22'),
(93036,63436,'1995-03-22','1996-03-21'),
(93036,63928,'1996-03-21','1997-03-21'),
(93036,64034,'1997-03-21','1998-03-21'),
(93036,63725,'1998-03-21','1999-03-21'),
(93036,67397,'1999-03-21','2000-03-20');


INSERT INTO `salaries` VALUES (93036,69528,'2000-03-20','2001-03-20'),
(93036,69518,'2001-03-20','2002-03-20'),
(93036,72130,'2002-03-20','9999-01-01'),
(93445,40000,'1986-06-06','1987-06-06'),
(93445,44409,'1987-06-06','1988-06-05'),
(93445,45284,'1988-06-05','1989-06-05'),
(93445,47250,'1989-06-05','1990-06-05'),
(93445,51213,'1990-06-05','1991-06-05'),
(93445,54267,'1991-06-05','1992-06-04'),
(93445,55889,'1992-06-04','1993-06-04');


INSERT INTO `salaries` VALUES (93445,57360,'1993-06-04','1994-06-04'),
(93445,59737,'1994-06-04','1995-06-04'),
(93445,62046,'1995-06-04','1996-06-03'),
(93445,62306,'1996-06-03','1997-06-03'),
(93445,64214,'1997-06-03','1998-06-03'),
(93445,67380,'1998-06-03','1999-06-03'),
(93445,69499,'1999-06-03','2000-06-02'),
(93445,73823,'2000-06-02','2001-06-02'),
(93445,75895,'2001-06-02','2002-06-02'),
(93445,78006,'2002-06-02','9999-01-01');


INSERT INTO `salaries` VALUES (93466,40998,'1998-09-23','1999-09-23'),
(93466,41027,'1999-09-23','2000-09-22'),
(93466,44348,'2000-09-22','2001-09-22'),
(93466,44989,'2001-09-22','9999-01-01'),
(93708,43858,'1997-07-24','1998-07-24'),
(93708,46218,'1998-07-24','1999-07-24'),
(93708,50009,'1999-07-24','2000-07-23'),
(93708,52635,'2000-07-23','2001-07-23'),
(93708,54836,'2001-07-23','2002-07-23'),
(93708,56999,'2002-07-23','9999-01-01');


INSERT INTO `salaries` VALUES (93877,88021,'1989-11-06','1990-11-06'),
(93877,91325,'1990-11-06','1991-11-06'),
(93877,94771,'1991-11-06','1992-11-05'),
(93877,97721,'1992-11-05','1993-11-05'),
(93877,101424,'1993-11-05','1994-11-05'),
(93877,103000,'1994-11-05','1995-11-05'),
(93877,104824,'1995-11-05','1996-11-04'),
(93877,106618,'1996-11-04','1997-11-04'),
(93877,109729,'1997-11-04','1998-11-04'),
(93877,111715,'1998-11-04','1999-11-04');


INSERT INTO `salaries` VALUES (93877,114506,'1999-11-04','2000-11-03'),
(93877,117825,'2000-11-03','2001-11-03'),
(93877,119009,'2001-11-03','9999-01-01'),
(94319,97645,'1998-03-13','1999-03-13'),
(94319,100211,'1999-03-13','2000-03-12'),
(94319,100584,'2000-03-12','2001-03-12'),
(94319,102249,'2001-03-12','2002-03-12'),
(94319,104488,'2002-03-12','9999-01-01'),
(94699,41341,'1998-07-06','1999-07-06'),
(94699,45591,'1999-07-06','1999-11-09');


INSERT INTO `salaries` VALUES (94716,69133,'1985-07-29','1986-07-29'),
(94716,70147,'1986-07-29','1987-07-29'),
(94716,70057,'1987-07-29','1988-07-28'),
(94716,73469,'1988-07-28','1989-07-28'),
(94716,75677,'1989-07-28','1990-07-28'),
(94716,78423,'1990-07-28','1991-07-28'),
(94716,79989,'1991-07-28','1992-07-27'),
(94716,81514,'1992-07-27','1993-07-27'),
(94716,82293,'1993-07-27','1994-07-27'),
(94716,83060,'1994-07-27','1995-07-27');


INSERT INTO `salaries` VALUES (94716,85763,'1995-07-27','1996-07-26'),
(94716,86707,'1996-07-26','1997-07-26'),
(94716,89171,'1997-07-26','1998-07-26'),
(94716,91836,'1998-07-26','1999-07-26'),
(94716,94960,'1999-07-26','2000-07-25'),
(94716,98754,'2000-07-25','2001-07-25'),
(94716,102820,'2001-07-25','2002-07-25'),
(94716,104638,'2002-07-25','9999-01-01'),
(95198,40000,'1990-11-06','1991-11-06'),
(95198,39863,'1991-11-06','1992-11-05');


INSERT INTO `salaries` VALUES (95198,40727,'1992-11-05','1993-11-05'),
(95198,40563,'1993-11-05','1994-11-05'),
(95198,44763,'1994-11-05','1995-11-05'),
(95198,45324,'1995-11-05','1996-11-04'),
(95198,45171,'1996-11-04','1997-11-04'),
(95198,49286,'1997-11-04','1998-11-04'),
(95198,49164,'1998-11-04','1999-11-04'),
(95198,50874,'1999-11-04','2000-11-03'),
(95198,55238,'2000-11-03','2001-11-03'),
(95198,58396,'2001-11-03','9999-01-01');


INSERT INTO `salaries` VALUES (95278,40000,'1990-02-14','1991-02-14'),
(95278,41694,'1991-02-14','1992-02-14'),
(95278,43856,'1992-02-14','1993-02-13'),
(95278,46891,'1993-02-13','1994-02-13'),
(95278,50576,'1994-02-13','1995-02-13'),
(95278,52253,'1995-02-13','1996-02-13'),
(95278,54512,'1996-02-13','1997-02-12'),
(95278,54243,'1997-02-12','1998-02-12'),
(95278,56637,'1998-02-12','1999-02-12'),
(95278,58673,'1999-02-12','2000-02-12');


INSERT INTO `salaries` VALUES (95278,61502,'2000-02-12','2001-02-11'),
(95278,63362,'2001-02-11','2002-02-11'),
(95278,67647,'2002-02-11','9999-01-01'),
(95670,59473,'1998-06-03','1999-06-03'),
(95670,61609,'1999-06-03','2000-06-02'),
(95670,64797,'2000-06-02','2001-06-02'),
(95670,68440,'2001-06-02','2002-06-02'),
(95670,71948,'2002-06-02','9999-01-01'),
(95861,40002,'1999-06-18','2000-06-17'),
(95861,42370,'2000-06-17','2001-06-17');


INSERT INTO `salaries` VALUES (95861,41959,'2001-06-17','2002-06-17'),
(95861,44156,'2002-06-17','9999-01-01'),
(96318,41305,'1985-10-23','1986-10-23'),
(96318,42023,'1986-10-23','1987-10-23'),
(96318,45161,'1987-10-23','1988-10-22'),
(96318,48674,'1988-10-22','1989-10-22'),
(96318,49390,'1989-10-22','1990-10-22'),
(96318,51538,'1990-10-22','1991-10-22'),
(96318,52026,'1991-10-22','1992-10-21'),
(96318,52866,'1992-10-21','1993-10-21');


INSERT INTO `salaries` VALUES (96318,52664,'1993-10-21','1994-10-21'),
(96318,54910,'1994-10-21','1995-10-21'),
(96318,55571,'1995-10-21','1996-10-20'),
(96318,56353,'1996-10-20','1997-10-20'),
(96318,60767,'1997-10-20','1998-10-20'),
(96318,63154,'1998-10-20','1999-10-20'),
(96318,66841,'1999-10-20','2000-10-19'),
(96318,70404,'2000-10-19','2001-10-19'),
(96318,72961,'2001-10-19','9999-01-01'),
(96531,43463,'1992-11-04','1993-11-04');


INSERT INTO `salaries` VALUES (96531,46883,'1993-11-04','1994-11-04'),
(96531,49140,'1994-11-04','1995-11-04'),
(96531,49068,'1995-11-04','1996-11-03'),
(96531,53533,'1996-11-03','1997-11-03'),
(96531,55748,'1997-11-03','1998-11-03'),
(96531,58462,'1998-11-03','1999-11-03'),
(96531,60388,'1999-11-03','2000-11-02'),
(96531,63927,'2000-11-02','2001-11-02'),
(96531,66368,'2001-11-02','9999-01-01'),
(96575,67444,'1987-12-02','1988-12-01');


INSERT INTO `salaries` VALUES (96575,68164,'1988-12-01','1989-12-01'),
(96575,72025,'1989-12-01','1990-12-01'),
(96575,75744,'1990-12-01','1991-12-01'),
(96575,76667,'1991-12-01','1992-11-30'),
(96575,79933,'1992-11-30','1993-11-30'),
(96575,80630,'1993-11-30','1994-11-30'),
(96575,81507,'1994-11-30','1995-11-30'),
(96575,84132,'1995-11-30','1996-11-29'),
(96575,85802,'1996-11-29','1997-11-29'),
(96575,87815,'1997-11-29','1998-11-29');


INSERT INTO `salaries` VALUES (96575,90251,'1998-11-29','1999-11-29'),
(96575,93513,'1999-11-29','2000-11-28'),
(96575,97072,'2000-11-28','2001-11-28'),
(96575,99216,'2001-11-28','9999-01-01'),
(96992,53142,'1992-05-19','1993-05-19'),
(96992,54471,'1993-05-19','1994-05-19'),
(96992,56978,'1994-05-19','1995-05-19'),
(96992,59889,'1995-05-19','1996-05-18'),
(96992,60893,'1996-05-18','1997-05-18'),
(96992,64351,'1997-05-18','1998-05-18');


INSERT INTO `salaries` VALUES (96992,64632,'1998-05-18','1999-05-18'),
(96992,64750,'1999-05-18','2000-05-17'),
(96992,66522,'2000-05-17','2001-05-17'),
(96992,70595,'2001-05-17','2002-05-17'),
(96992,74778,'2002-05-17','9999-01-01'),
(97195,52872,'1997-06-04','1998-05-15'),
(97224,57091,'1985-06-17','1986-06-17'),
(97224,57782,'1986-06-17','1987-06-17'),
(97224,58470,'1987-06-17','1988-06-16'),
(97224,59848,'1988-06-16','1989-06-16');


INSERT INTO `salaries` VALUES (97224,64117,'1989-06-16','1990-06-16'),
(97224,65850,'1990-06-16','1991-06-16'),
(97224,68982,'1991-06-16','1992-06-15'),
(97224,72807,'1992-06-15','1993-06-15'),
(97224,72789,'1993-06-15','1994-06-15'),
(97224,76312,'1994-06-15','1995-06-15'),
(97224,79726,'1995-06-15','1996-06-14'),
(97224,81591,'1996-06-14','1997-06-14'),
(97224,84906,'1997-06-14','1998-06-14'),
(97224,88675,'1998-06-14','1999-06-14');


INSERT INTO `salaries` VALUES (97224,88741,'1999-06-14','2000-06-13'),
(97224,89258,'2000-06-13','2001-06-13'),
(97224,93448,'2001-06-13','2002-06-13'),
(97224,96767,'2002-06-13','9999-01-01'),
(97970,67969,'1993-10-01','1994-10-01'),
(97970,71729,'1994-10-01','1995-10-01'),
(97970,72766,'1995-10-01','1996-09-30'),
(97970,77154,'1996-09-30','1997-09-30'),
(97970,76681,'1997-09-30','1998-09-30'),
(97970,81117,'1998-09-30','1999-09-30');


INSERT INTO `salaries` VALUES (97970,81772,'1999-09-30','2000-09-29'),
(97970,81418,'2000-09-29','2001-09-29'),
(97970,83643,'2001-09-29','9999-01-01'),
(98968,52479,'1988-08-14','1989-08-14'),
(98968,56164,'1989-08-14','1990-08-14'),
(98968,59913,'1990-08-14','1991-08-14'),
(98968,62648,'1991-08-14','1991-08-25'),
(99121,61339,'1990-11-10','1991-11-10'),
(99121,61759,'1991-11-10','1992-11-09'),
(99121,65491,'1992-11-09','1993-11-09');


INSERT INTO `salaries` VALUES (99121,66093,'1993-11-09','1994-11-09'),
(99121,66706,'1994-11-09','1995-11-09'),
(99121,69478,'1995-11-09','1996-11-08'),
(99121,72413,'1996-11-08','1997-11-08'),
(99121,72805,'1997-11-08','1998-11-08'),
(99121,72724,'1998-11-08','1999-11-08'),
(99121,73388,'1999-11-08','2000-11-07'),
(99121,75526,'2000-11-07','2001-11-07'),
(99121,76682,'2001-11-07','9999-01-01'),
(99726,65064,'1997-03-07','1998-03-07');


INSERT INTO `salaries` VALUES (99726,67706,'1998-03-07','1999-03-07'),
(99726,68334,'1999-03-07','2000-03-06'),
(99726,68236,'2000-03-06','2001-03-06'),
(99726,69673,'2001-03-06','2002-03-06'),
(99726,74133,'2002-03-06','9999-01-01'),
(101129,52429,'1999-05-04','2000-05-03'),
(101129,55886,'2000-05-03','2001-05-03'),
(101129,57531,'2001-05-03','2002-05-03'),
(101129,61854,'2002-05-03','9999-01-01'),
(101241,48969,'1992-05-11','1993-05-11');


INSERT INTO `salaries` VALUES (101241,52357,'1993-05-11','1994-05-11'),
(101241,52429,'1994-05-11','1995-05-11'),
(101241,55906,'1995-05-11','1996-05-10'),
(101241,57045,'1996-05-10','1997-05-10'),
(101241,58232,'1997-05-10','1998-05-10'),
(101241,60971,'1998-05-10','1999-05-10'),
(101241,61798,'1999-05-10','2000-05-09'),
(101241,62833,'2000-05-09','2001-05-09'),
(101241,65291,'2001-05-09','2002-05-09'),
(101241,66832,'2002-05-09','9999-01-01');


INSERT INTO `salaries` VALUES (101787,48195,'1988-07-28','1989-07-28'),
(101787,50509,'1989-07-28','1990-07-28'),
(101787,51994,'1990-07-28','1991-07-28'),
(101787,53642,'1991-07-28','1992-07-27'),
(101787,57913,'1992-07-27','1993-07-27'),
(101787,57871,'1993-07-27','1994-07-27'),
(101787,60739,'1994-07-27','1995-07-27'),
(101787,65146,'1995-07-27','1996-07-26'),
(101787,67203,'1996-07-26','1997-07-26'),
(101787,70760,'1997-07-26','1998-07-26');


INSERT INTO `salaries` VALUES (101787,74630,'1998-07-26','1999-07-26'),
(101787,77454,'1999-07-26','2000-07-25'),
(101787,78738,'2000-07-25','2001-07-25'),
(101787,80811,'2001-07-25','2002-07-25'),
(101787,82569,'2002-07-25','9999-01-01'),
(101851,40000,'1991-06-26','1992-06-25'),
(101851,43629,'1992-06-25','1993-06-25'),
(101851,43588,'1993-06-25','1994-06-25'),
(101851,47075,'1994-06-25','1995-06-25'),
(101851,48974,'1995-06-25','1996-06-24');


INSERT INTO `salaries` VALUES (101851,50692,'1996-06-24','1997-06-24'),
(101851,52122,'1997-06-24','1998-06-24'),
(101851,53832,'1998-06-24','1999-06-24'),
(101851,55159,'1999-06-24','2000-06-23'),
(101851,57563,'2000-06-23','2001-04-08'),
(102216,54257,'1997-10-27','1998-10-27'),
(102216,55022,'1998-10-27','1999-10-27'),
(102216,55038,'1999-10-27','2000-10-26'),
(102216,55214,'2000-10-26','2001-10-26'),
(102216,59366,'2001-10-26','9999-01-01');


INSERT INTO `salaries` VALUES (102347,44921,'1991-08-03','1992-08-02'),
(102347,48426,'1992-08-02','1993-08-02'),
(102347,50479,'1993-08-02','1994-08-02'),
(102347,50462,'1994-08-02','1995-08-02'),
(102347,51977,'1995-08-02','1996-08-01'),
(102347,53050,'1996-08-01','1997-08-01'),
(102347,54088,'1997-08-01','1998-08-01'),
(102347,55615,'1998-08-01','1999-08-01'),
(102347,55636,'1999-08-01','2000-07-31'),
(102347,55751,'2000-07-31','2001-07-31');


INSERT INTO `salaries` VALUES (102347,55755,'2001-07-31','2002-07-31'),
(102347,55700,'2002-07-31','9999-01-01'),
(102827,40000,'1996-10-23','1997-10-23'),
(102827,43624,'1997-10-23','1998-10-23'),
(102827,46541,'1998-10-23','1999-10-23'),
(102827,50775,'1999-10-23','2000-10-22'),
(102827,53385,'2000-10-22','2001-10-22'),
(102827,57623,'2001-10-22','9999-01-01'),
(103621,45719,'1997-10-06','1998-10-06'),
(103621,49599,'1998-10-06','1999-10-06');


INSERT INTO `salaries` VALUES (103621,52019,'1999-10-06','2000-10-05'),
(103621,55046,'2000-10-05','2001-10-05'),
(103621,57015,'2001-10-05','9999-01-01'),
(103666,40000,'1995-07-26','1996-07-25'),
(103666,41349,'1996-07-25','1997-07-25'),
(103666,41430,'1997-07-25','1998-07-25'),
(103666,41942,'1998-07-25','1999-07-25'),
(103666,41491,'1999-07-25','2000-07-24'),
(103666,42948,'2000-07-24','2001-07-24'),
(103666,46570,'2001-07-24','2002-07-24');


INSERT INTO `salaries` VALUES (103666,50949,'2002-07-24','9999-01-01'),
(104037,52667,'1987-11-16','1988-11-15'),
(104037,55935,'1988-11-15','1989-11-15'),
(104037,57428,'1989-11-15','1990-11-15'),
(104037,58268,'1990-11-15','1991-11-15'),
(104037,62700,'1991-11-15','1992-11-14'),
(104037,65307,'1992-11-14','1993-11-14'),
(104037,68418,'1993-11-14','1994-11-14'),
(104037,69838,'1994-11-14','1995-11-14'),
(104037,72497,'1995-11-14','1996-11-13');


INSERT INTO `salaries` VALUES (104037,76612,'1996-11-13','1997-11-13'),
(104037,76725,'1997-11-13','1998-11-13'),
(104037,78488,'1998-11-13','1999-11-13'),
(104037,81921,'1999-11-13','2000-11-12'),
(104037,85855,'2000-11-12','2001-11-12'),
(104037,87037,'2001-11-12','9999-01-01'),
(104080,92360,'1988-10-07','1989-10-07'),
(104080,96718,'1989-10-07','1990-10-07'),
(104080,98202,'1990-10-07','1991-10-07'),
(104080,102656,'1991-10-07','1992-10-06');


INSERT INTO `salaries` VALUES (104080,105345,'1992-10-06','1993-10-06'),
(104080,108982,'1993-10-06','1994-10-06'),
(104080,110457,'1994-10-06','1995-10-06'),
(104080,113569,'1995-10-06','1996-10-05'),
(104080,117115,'1996-10-05','1997-10-05'),
(104080,121456,'1997-10-05','1998-10-05'),
(104080,125386,'1998-10-05','1999-10-05'),
(104080,129008,'1999-10-05','2000-10-04'),
(104080,129584,'2000-10-04','2001-10-04'),
(104080,131502,'2001-10-04','9999-01-01');


INSERT INTO `salaries` VALUES (104402,74547,'1995-06-15','1996-06-14'),
(104402,75060,'1996-06-14','1997-06-14'),
(104402,75344,'1997-06-14','1998-06-14'),
(104402,77219,'1998-06-14','1999-06-14'),
(104402,77357,'1999-06-14','2000-06-13'),
(104402,80782,'2000-06-13','2001-06-13'),
(104402,83772,'2001-06-13','2002-06-13'),
(104402,86113,'2002-06-13','9999-01-01'),
(105153,53865,'1997-12-19','1998-12-19'),
(105153,56066,'1998-12-19','1999-12-19');


INSERT INTO `salaries` VALUES (105153,57874,'1999-12-19','2000-12-18'),
(105153,58356,'2000-12-18','2001-12-18'),
(105153,61012,'2001-12-18','9999-01-01'),
(105279,42395,'1992-08-03','1993-08-03'),
(105279,44071,'1993-08-03','1994-08-03'),
(105279,47663,'1994-08-03','1995-08-03'),
(105279,49586,'1995-08-03','1996-08-02'),
(105279,52767,'1996-08-02','1997-08-02'),
(105279,54631,'1997-08-02','1998-08-02'),
(105279,56948,'1998-08-02','1999-08-02');


INSERT INTO `salaries` VALUES (105279,60691,'1999-08-02','2000-08-01'),
(105279,61563,'2000-08-01','2001-08-01'),
(105279,64671,'2001-08-01','2002-08-01'),
(105279,64992,'2002-08-01','9999-01-01'),
(105337,80751,'1995-06-29','1996-06-28'),
(105337,82684,'1996-06-28','1997-06-28'),
(105337,86666,'1997-06-28','1998-06-28'),
(105337,90959,'1998-06-28','1999-06-28'),
(105337,91422,'1999-06-28','2000-06-27'),
(105337,93739,'2000-06-27','2001-06-27');


INSERT INTO `salaries` VALUES (105337,94795,'2001-06-27','2002-06-27'),
(105337,95406,'2002-06-27','9999-01-01'),
(106201,119925,'1997-04-22','1998-04-22'),
(106201,123238,'1998-04-22','1999-04-22'),
(106201,123750,'1999-04-22','2000-04-21'),
(106201,125403,'2000-04-21','2001-04-21'),
(106201,128483,'2001-04-21','2002-04-21'),
(106201,130035,'2002-04-21','9999-01-01'),
(106660,40000,'1989-05-11','1990-05-11'),
(106660,41467,'1990-05-11','1991-05-11');


INSERT INTO `salaries` VALUES (106660,42981,'1991-05-11','1992-05-10'),
(106660,42964,'1992-05-10','1993-05-10'),
(106660,43344,'1993-05-10','1994-05-10'),
(106660,46878,'1994-05-10','1995-05-10'),
(106660,47982,'1995-05-10','1996-05-09'),
(106660,49238,'1996-05-09','1997-05-09'),
(106660,49945,'1997-05-09','1998-05-09'),
(106660,54361,'1998-05-09','1999-05-09'),
(106660,54188,'1999-05-09','2000-05-08'),
(106660,57446,'2000-05-08','2001-05-08');


INSERT INTO `salaries` VALUES (106660,60793,'2001-05-08','2002-05-08'),
(106660,60556,'2002-05-08','9999-01-01'),
(107072,49598,'1989-07-07','1990-07-07'),
(107072,51131,'1990-07-07','1991-07-07'),
(107072,52956,'1991-07-07','1992-07-06'),
(107072,57376,'1992-07-06','1993-07-06'),
(107072,60587,'1993-07-06','1994-07-06'),
(107072,63984,'1994-07-06','1995-07-06'),
(107072,64258,'1995-07-06','1996-07-05'),
(107072,64305,'1996-07-05','1997-07-05');


INSERT INTO `salaries` VALUES (107072,63868,'1997-07-05','1998-07-05'),
(107072,67035,'1998-07-05','1999-07-05'),
(107072,70011,'1999-07-05','2000-07-04'),
(107072,73546,'2000-07-04','2001-07-04'),
(107072,77196,'2001-07-04','2002-07-04'),
(107072,80538,'2002-07-04','9999-01-01'),
(107426,58619,'1998-09-28','1999-09-28'),
(107426,61051,'1999-09-28','2000-09-27'),
(107426,62981,'2000-09-27','2001-09-27'),
(107426,64319,'2001-09-27','9999-01-01');


INSERT INTO `salaries` VALUES (108348,47323,'1990-03-16','1991-03-16'),
(108348,49546,'1991-03-16','1992-03-15'),
(108348,53822,'1992-03-15','1993-03-15'),
(108348,54851,'1993-03-15','1994-03-15'),
(108348,56600,'1994-03-15','1995-03-15'),
(108348,58159,'1995-03-15','1996-03-14'),
(108348,58949,'1996-03-14','1997-03-14'),
(108348,61339,'1997-03-14','1998-03-14'),
(108348,61464,'1998-03-14','1999-03-14'),
(108348,63793,'1999-03-14','2000-03-13');


INSERT INTO `salaries` VALUES (108348,66559,'2000-03-13','2001-03-13'),
(108348,70579,'2001-03-13','2002-03-13'),
(108348,73841,'2002-03-13','9999-01-01'),
(108909,40000,'1999-07-05','2000-07-04'),
(108909,44061,'2000-07-04','2001-07-04'),
(108909,43818,'2001-07-04','2002-07-04'),
(108909,44636,'2002-07-04','9999-01-01'),
(109562,54521,'1996-05-22','1997-05-22'),
(109562,57638,'1997-05-22','1998-05-22'),
(109562,58601,'1998-05-22','1999-05-22');


INSERT INTO `salaries` VALUES (109562,58457,'1999-05-22','2000-05-21'),
(109562,60572,'2000-05-21','2001-05-21'),
(109562,64218,'2001-05-21','2002-05-21'),
(109562,68212,'2002-05-21','9999-01-01'),
(109657,40000,'1987-06-16','1988-06-15'),
(109657,42777,'1988-06-15','1989-06-15'),
(109657,43988,'1989-06-15','1990-06-15'),
(109657,46688,'1990-06-15','1991-06-15'),
(109657,50425,'1991-06-15','1992-06-14'),
(109657,52003,'1992-06-14','1993-06-14');


INSERT INTO `salaries` VALUES (109657,56365,'1993-06-14','1994-06-14'),
(109657,56526,'1994-06-14','1995-06-14'),
(109657,59238,'1995-06-14','1996-06-13'),
(109657,61791,'1996-06-13','1997-06-13'),
(109657,63334,'1997-06-13','1998-06-13'),
(109657,64267,'1998-06-13','1999-06-13'),
(109657,64357,'1999-06-13','2000-06-12'),
(109657,68195,'2000-06-12','2001-06-12'),
(109657,68607,'2001-06-12','2002-06-12'),
(109657,72255,'2002-06-12','9999-01-01');


INSERT INTO `salaries` VALUES (109725,42481,'1990-07-18','1991-07-18'),
(109725,43235,'1991-07-18','1992-07-17'),
(109725,46673,'1992-07-17','1993-07-17'),
(109725,49059,'1993-07-17','1994-07-17'),
(109725,49494,'1994-07-17','1995-07-17'),
(109725,49184,'1995-07-17','1996-07-16'),
(109725,49876,'1996-07-16','1997-07-16'),
(109725,51876,'1997-07-16','1998-07-16'),
(109725,55969,'1998-07-16','1999-07-16'),
(109725,55629,'1999-07-16','2000-07-15');


INSERT INTO `salaries` VALUES (109725,57478,'2000-07-15','2001-07-15'),
(109725,61720,'2001-07-15','2002-07-15'),
(109725,62566,'2002-07-15','9999-01-01'),
(109830,40000,'1997-05-07','1998-05-07'),
(109830,43980,'1998-05-07','1999-05-07'),
(109830,46851,'1999-05-07','2000-05-06'),
(109830,50518,'2000-05-06','2001-05-06'),
(109830,53004,'2001-05-06','2002-05-06'),
(109830,54209,'2002-05-06','9999-01-01'),
(109935,40000,'1994-04-17','1995-04-17');


INSERT INTO `salaries` VALUES (109935,41960,'1995-04-17','1996-04-16'),
(109935,44777,'1996-04-16','1997-04-16'),
(109935,48853,'1997-04-16','1998-04-16'),
(109935,52445,'1998-04-16','1999-04-16'),
(109935,56123,'1999-04-16','2000-04-15'),
(109935,58374,'2000-04-15','2001-04-15'),
(109935,62125,'2001-04-15','2002-04-15'),
(109935,65426,'2002-04-15','9999-01-01'),
(200144,45022,'1991-01-02','1992-01-02'),
(200144,48055,'1992-01-02','1993-01-01');


INSERT INTO `salaries` VALUES (200144,51984,'1993-01-01','1994-01-01'),
(200144,54550,'1994-01-01','1995-01-01'),
(200144,56527,'1995-01-01','1996-01-01'),
(200144,57128,'1996-01-01','1996-12-31'),
(200144,60744,'1996-12-31','1997-12-31'),
(200144,60378,'1997-12-31','1998-12-31'),
(200144,63219,'1998-12-31','1999-12-31'),
(200144,65081,'1999-12-31','2000-12-30'),
(200144,66221,'2000-12-30','2001-12-30'),
(200144,68389,'2001-12-30','9999-01-01');


INSERT INTO `salaries` VALUES (200398,63255,'1991-08-02','1992-08-01'),
(200398,64484,'1992-08-01','1993-08-01'),
(200398,65241,'1993-08-01','1994-08-01'),
(200398,65905,'1994-08-01','1995-08-01'),
(200398,66262,'1995-08-01','1996-07-31'),
(200398,66849,'1996-07-31','1997-07-31'),
(200398,70964,'1997-07-31','1998-07-31'),
(200398,72858,'1998-07-31','1999-07-31'),
(200398,76259,'1999-07-31','2000-07-30'),
(200398,79489,'2000-07-30','2001-07-30');


INSERT INTO `salaries` VALUES (200398,82455,'2001-07-30','2002-07-30'),
(200398,82148,'2002-07-30','9999-01-01'),
(200424,40000,'1991-09-08','1992-09-07'),
(200424,42474,'1992-09-07','1993-09-07'),
(200424,43286,'1993-09-07','1994-09-07'),
(200424,44170,'1994-09-07','1995-09-07'),
(200424,45311,'1995-09-07','1996-09-06'),
(200424,49642,'1996-09-06','1997-09-06'),
(200424,49563,'1997-09-06','1998-09-06'),
(200424,49595,'1998-09-06','1999-09-06');


INSERT INTO `salaries` VALUES (200424,51575,'1999-09-06','2000-09-05'),
(200424,52611,'2000-09-05','2001-09-05'),
(200424,52595,'2001-09-05','9999-01-01'),
(200555,48505,'1992-07-15','1993-07-15'),
(200555,48076,'1993-07-15','1994-07-15'),
(200555,52481,'1994-07-15','1995-07-15'),
(200555,52828,'1995-07-15','1996-07-14'),
(200555,54416,'1996-07-14','1997-07-14'),
(200555,57649,'1997-07-14','1998-07-14'),
(200555,57324,'1998-07-14','1999-07-14');


INSERT INTO `salaries` VALUES (200555,57385,'1999-07-14','2000-07-13'),
(200555,59719,'2000-07-13','2001-07-13'),
(200555,62251,'2001-07-13','2002-07-13'),
(200555,63311,'2002-07-13','9999-01-01'),
(200790,71704,'1992-01-21','1993-01-20'),
(200790,74601,'1993-01-20','1994-01-20'),
(200790,77461,'1994-01-20','1995-01-20'),
(200790,77849,'1995-01-20','1996-01-20'),
(200790,81893,'1996-01-20','1997-01-19'),
(200790,84895,'1997-01-19','1998-01-19');


INSERT INTO `salaries` VALUES (200790,88835,'1998-01-19','1999-01-19'),
(200790,90463,'1999-01-19','2000-01-19'),
(200790,91976,'2000-01-19','2001-01-18'),
(200790,91575,'2001-01-18','2002-01-18'),
(200790,95360,'2002-01-18','9999-01-01'),
(200945,60421,'1989-11-05','1990-11-05'),
(200945,63853,'1990-11-05','1991-11-05'),
(200945,67245,'1991-11-05','1992-11-04'),
(200945,67753,'1992-11-04','1993-11-04'),
(200945,68283,'1993-11-04','1994-11-04');


INSERT INTO `salaries` VALUES (200945,72132,'1994-11-04','1995-11-04'),
(200945,76067,'1995-11-04','1996-11-03'),
(200945,75948,'1996-11-03','1997-11-03'),
(200945,79711,'1997-11-03','1998-11-03'),
(200945,79980,'1998-11-03','1999-11-03'),
(200945,82571,'1999-11-03','2000-11-02'),
(200945,83075,'2000-11-02','2001-11-02'),
(200945,85694,'2001-11-02','2002-02-23'),
(201231,40000,'1987-05-17','1988-05-16'),
(201231,43640,'1988-05-16','1989-05-16');


INSERT INTO `salaries` VALUES (201231,44301,'1989-05-16','1990-05-16'),
(201231,46768,'1990-05-16','1991-05-16'),
(201231,47014,'1991-05-16','1991-07-22'),
(201749,57140,'1988-04-07','1989-04-07'),
(201749,61446,'1989-04-07','1990-04-07'),
(201749,63095,'1990-04-07','1991-04-06'),
(201749,62678,'1991-04-06','1992-04-06'),
(201749,66752,'1992-04-06','1993-04-06'),
(201749,66717,'1993-04-06','1994-04-06'),
(201749,68962,'1994-04-06','1995-04-06');


INSERT INTO `salaries` VALUES (201749,68856,'1995-04-06','1996-04-04'),
(201749,69344,'1996-04-04','1997-04-04'),
(201749,68918,'1997-04-04','1998-04-04'),
(201749,70286,'1998-04-04','1999-04-05'),
(201749,72239,'1999-04-05','2000-04-04'),
(201749,71836,'2000-04-04','2001-04-04'),
(201749,74843,'2001-04-04','2002-04-03'),
(201749,76727,'2002-04-03','9999-01-01'),
(201916,40000,'1992-03-30','1993-03-30'),
(201916,41348,'1993-03-30','1994-03-30');


INSERT INTO `salaries` VALUES (201916,42283,'1994-03-30','1995-03-30'),
(201916,42314,'1995-03-30','1996-03-29'),
(201916,44657,'1996-03-29','1997-03-29'),
(201916,48821,'1997-03-29','1998-03-29'),
(201916,48720,'1998-03-29','1999-03-29'),
(201916,50044,'1999-03-29','2000-03-28'),
(201916,52221,'2000-03-28','2001-03-28'),
(201916,55116,'2001-03-28','2002-03-28'),
(201916,55432,'2002-03-28','9999-01-01'),
(203279,50219,'1995-01-21','1996-01-21');


INSERT INTO `salaries` VALUES (203279,51394,'1996-01-21','1997-01-20'),
(203279,55148,'1997-01-20','1998-01-20'),
(203279,58407,'1998-01-20','1999-01-20'),
(203279,61183,'1999-01-20','2000-01-20'),
(203279,62359,'2000-01-20','2001-01-19'),
(203279,61909,'2001-01-19','2002-01-19'),
(203279,63625,'2002-01-19','9999-01-01'),
(203690,60940,'1998-09-19','1999-09-19'),
(203690,64684,'1999-09-19','2000-09-18'),
(203690,65918,'2000-09-18','2001-09-18');


INSERT INTO `salaries` VALUES (203690,68797,'2001-09-18','9999-01-01'),
(203957,47906,'1997-07-08','1998-07-08'),
(203957,49380,'1998-07-08','1999-07-08'),
(203957,53849,'1999-07-08','2000-07-07'),
(203957,54638,'2000-07-07','2001-07-07'),
(203957,54771,'2001-07-07','2002-07-07'),
(203957,56878,'2002-07-07','9999-01-01'),
(204224,40000,'1988-04-03','1989-04-03'),
(204224,41441,'1989-04-03','1990-04-03'),
(204224,42552,'1990-04-03','1991-04-03');


INSERT INTO `salaries` VALUES (204224,46627,'1991-04-03','1992-04-02'),
(204224,50287,'1992-04-02','1993-04-02'),
(204224,52443,'1993-04-02','1994-04-02'),
(204224,54963,'1994-04-02','1995-04-02'),
(204224,58314,'1995-04-02','1996-04-01'),
(204224,58948,'1996-04-01','1997-04-01'),
(204224,61930,'1997-04-01','1998-04-01'),
(204224,64576,'1998-04-01','1999-04-01'),
(204224,69017,'1999-04-01','2000-03-31'),
(204224,72793,'2000-03-31','2001-03-31');


INSERT INTO `salaries` VALUES (204224,74831,'2001-03-31','2002-03-31'),
(204224,76278,'2002-03-31','9999-01-01'),
(204262,40000,'1994-04-18','1995-04-18'),
(204262,44365,'1995-04-18','1996-04-17'),
(204262,44707,'1996-04-17','1997-04-17'),
(204262,48128,'1997-04-17','1998-04-17'),
(204262,50165,'1998-04-17','1999-04-17'),
(204262,51956,'1999-04-17','2000-04-16'),
(204262,55727,'2000-04-16','2001-04-16'),
(204262,58291,'2001-04-16','2002-04-16');


INSERT INTO `salaries` VALUES (204262,62751,'2002-04-16','9999-01-01'),
(204377,49707,'1997-01-17','1998-01-17'),
(204377,52686,'1998-01-17','1999-01-17'),
(204377,55331,'1999-01-17','2000-01-17'),
(204377,55821,'2000-01-17','2001-01-16'),
(204377,56835,'2001-01-16','2002-01-16'),
(204377,60057,'2002-01-16','9999-01-01'),
(204498,61021,'1985-04-25','1986-04-25'),
(204498,60612,'1986-04-25','1987-04-25'),
(204498,61703,'1987-04-25','1988-04-24');


INSERT INTO `salaries` VALUES (204498,65746,'1988-04-24','1989-04-24'),
(204498,65626,'1989-04-24','1990-04-24'),
(204498,69516,'1990-04-24','1991-04-24'),
(204498,71321,'1991-04-24','1992-04-23'),
(204498,71778,'1992-04-23','1993-04-23'),
(204498,73616,'1993-04-23','1994-04-23'),
(204498,76989,'1994-04-23','1995-04-23'),
(204498,77331,'1995-04-23','1996-04-22'),
(204498,81168,'1996-04-22','1997-04-22'),
(204498,85122,'1997-04-22','1998-04-22');


INSERT INTO `salaries` VALUES (204498,89458,'1998-04-22','1999-04-22'),
(204498,91745,'1999-04-22','2000-04-21'),
(204498,95388,'2000-04-21','2001-04-21'),
(204498,98008,'2001-04-21','2002-04-21'),
(204498,100199,'2002-04-21','9999-01-01'),
(204609,40000,'1989-03-25','1990-03-25'),
(204609,42743,'1990-03-25','1991-03-25'),
(204609,45009,'1991-03-25','1992-03-24'),
(204609,46543,'1992-03-24','1993-03-24'),
(204609,50814,'1993-03-24','1994-03-24');


INSERT INTO `salaries` VALUES (204609,54728,'1994-03-24','1995-03-24'),
(204609,57917,'1995-03-24','1996-03-23'),
(204609,61740,'1996-03-23','1997-03-23'),
(204609,63970,'1997-03-23','1998-03-23'),
(204609,63696,'1998-03-23','1999-03-23'),
(204609,66261,'1999-03-23','2000-03-22'),
(204609,70509,'2000-03-22','2001-03-22'),
(204609,74582,'2001-03-22','2002-03-22'),
(204609,74834,'2002-03-22','9999-01-01'),
(205437,43604,'1996-08-05','1997-08-05');


INSERT INTO `salaries` VALUES (205437,46557,'1997-08-05','1998-06-14'),
(206699,40000,'1995-06-16','1996-06-15'),
(206699,43536,'1996-06-15','1997-06-15'),
(206699,44177,'1997-06-15','1998-06-15'),
(206699,44777,'1998-06-15','1999-06-15'),
(206699,47656,'1999-06-15','2000-06-14'),
(206699,51515,'2000-06-14','2001-06-14'),
(206699,53003,'2001-06-14','2002-06-14'),
(206699,55335,'2002-06-14','9999-01-01'),
(206719,82626,'1989-06-12','1990-06-12');


INSERT INTO `salaries` VALUES (206719,83172,'1990-06-12','1991-06-12'),
(206719,85657,'1991-06-12','1992-06-11'),
(206719,88085,'1992-06-11','1993-06-11'),
(206719,88591,'1993-06-11','1994-06-11'),
(206719,89678,'1994-06-11','1995-06-11'),
(206719,89419,'1995-06-11','1996-06-10'),
(206719,89685,'1996-06-10','1997-06-10'),
(206719,90622,'1997-06-10','1998-06-10'),
(206719,94900,'1998-06-10','1999-06-10'),
(206719,95962,'1999-06-10','2000-06-09');


INSERT INTO `salaries` VALUES (206719,97868,'2000-06-09','2001-06-09'),
(206719,99837,'2001-06-09','2002-06-09'),
(206719,103621,'2002-06-09','9999-01-01'),
(207066,66611,'1988-08-18','1989-08-18'),
(207066,69710,'1989-08-18','1990-08-18'),
(207066,72217,'1990-08-18','1991-08-18'),
(207066,74438,'1991-08-18','1992-08-17'),
(207066,76085,'1992-08-17','1993-08-17'),
(207066,75964,'1993-08-17','1994-08-17'),
(207066,77582,'1994-08-17','1995-08-17');


INSERT INTO `salaries` VALUES (207066,79816,'1995-08-17','1996-08-16'),
(207066,84258,'1996-08-16','1997-08-16'),
(207066,85643,'1997-08-16','1998-08-16'),
(207066,87190,'1998-08-16','1999-08-16'),
(207066,90291,'1999-08-16','2000-08-15'),
(207066,92768,'2000-08-15','2001-08-15'),
(207066,95553,'2001-08-15','9999-01-01'),
(208416,63099,'1993-11-17','1994-11-17'),
(208416,63252,'1994-11-17','1995-11-17'),
(208416,66074,'1995-11-17','1996-11-16');


INSERT INTO `salaries` VALUES (208416,65846,'1996-11-16','1997-11-16'),
(208416,66206,'1997-11-16','1998-11-16'),
(208416,66973,'1998-11-16','1999-11-16'),
(208416,66687,'1999-11-16','2000-11-15'),
(208416,70771,'2000-11-15','2001-01-31'),
(208916,44544,'1993-08-23','1994-08-23'),
(208916,44844,'1994-08-23','1995-08-23'),
(208916,44437,'1995-08-23','1996-08-22'),
(208916,44638,'1996-08-22','1997-08-22'),
(208916,44404,'1997-08-22','1998-08-22');


INSERT INTO `salaries` VALUES (208916,47901,'1998-08-22','1999-08-22'),
(208916,51215,'1999-08-22','2000-05-25'),
(209818,41076,'1995-07-13','1996-07-12'),
(209818,41261,'1996-07-12','1997-07-12'),
(209818,45704,'1997-07-12','1998-07-12'),
(209818,47273,'1998-07-12','1999-07-12'),
(209818,48303,'1999-07-12','2000-07-11'),
(209818,50084,'2000-07-11','2001-07-11'),
(209818,54265,'2001-07-11','2002-07-11'),
(209818,56134,'2002-07-11','9999-01-01');


INSERT INTO `salaries` VALUES (210116,57904,'1987-02-04','1988-02-04'),
(210116,61749,'1988-02-04','1989-02-03'),
(210116,61956,'1989-02-03','1990-02-03'),
(210116,62891,'1990-02-03','1991-02-03'),
(210116,67054,'1991-02-03','1992-02-03'),
(210116,69022,'1992-02-03','1993-02-02'),
(210116,69746,'1993-02-02','1994-02-02'),
(210116,72183,'1994-02-02','1995-02-02'),
(210116,72944,'1995-02-02','1996-02-02'),
(210116,74506,'1996-02-02','1997-02-01');


INSERT INTO `salaries` VALUES (210116,77103,'1997-02-01','1998-02-01'),
(210116,78372,'1998-02-01','1999-02-01'),
(210116,80041,'1999-02-01','2000-02-01'),
(210116,82171,'2000-02-01','2001-01-31'),
(210116,86598,'2001-01-31','2002-01-31'),
(210116,88305,'2002-01-31','9999-01-01'),
(210172,45322,'1999-11-25','2000-07-19'),
(210406,59358,'1991-04-01','1992-03-31'),
(210406,63034,'1992-03-31','1993-03-31'),
(210406,62696,'1993-03-31','1994-03-31');


INSERT INTO `salaries` VALUES (210406,64565,'1994-03-31','1995-03-31'),
(210406,64734,'1995-03-31','1996-03-30'),
(210406,65919,'1996-03-30','1997-03-30'),
(210406,67408,'1997-03-30','1998-03-30'),
(210406,69557,'1998-03-30','1999-03-30'),
(210406,73885,'1999-03-30','2000-03-29'),
(210406,74193,'2000-03-29','2001-03-29'),
(210406,76453,'2001-03-29','2002-03-29'),
(210406,76915,'2002-03-29','9999-01-01'),
(210591,40000,'1993-11-18','1994-11-18');


INSERT INTO `salaries` VALUES (210591,43803,'1994-11-18','1995-11-18'),
(210591,46565,'1995-11-18','1996-11-17'),
(210591,49648,'1996-11-17','1997-11-17'),
(210591,51929,'1997-11-17','1998-11-17'),
(210591,53063,'1998-11-17','1999-11-17'),
(210591,54039,'1999-11-17','2000-11-16'),
(210591,58107,'2000-11-16','2001-11-16'),
(210591,60489,'2001-11-16','9999-01-01'),
(210613,40000,'1998-02-27','1999-02-27'),
(210613,41872,'1999-02-27','2000-02-27');


INSERT INTO `salaries` VALUES (210613,42602,'2000-02-27','2001-02-26'),
(210613,44365,'2001-02-26','2002-02-26'),
(210613,44411,'2002-02-26','9999-01-01'),
(210946,68587,'1999-01-25','2000-01-25'),
(210946,70073,'2000-01-25','2001-01-24'),
(210946,73316,'2001-01-24','2002-01-24'),
(210946,75463,'2002-01-24','9999-01-01'),
(211019,61388,'1987-06-30','1988-06-29'),
(211019,61445,'1988-06-29','1989-06-29'),
(211019,64281,'1989-06-29','1990-06-29');


INSERT INTO `salaries` VALUES (211019,64221,'1990-06-29','1991-06-29'),
(211019,65902,'1991-06-29','1992-06-28'),
(211019,69700,'1992-06-28','1993-06-28'),
(211019,70046,'1993-06-28','1994-06-28'),
(211019,71935,'1994-06-28','1995-06-28'),
(211019,71743,'1995-06-28','1996-03-23'),
(211187,40000,'1991-01-19','1992-01-19'),
(211187,40362,'1992-01-19','1993-01-18'),
(211187,44521,'1993-01-18','1994-01-18'),
(211187,44321,'1994-01-18','1995-01-18');


INSERT INTO `salaries` VALUES (211187,45352,'1995-01-18','1996-01-18'),
(211187,48705,'1996-01-18','1997-01-17'),
(211187,51574,'1997-01-17','1998-01-17'),
(211187,52458,'1998-01-17','1999-01-17'),
(211187,52949,'1999-01-17','2000-01-17'),
(211187,53066,'2000-01-17','2001-01-16'),
(211187,53834,'2001-01-16','2002-01-16'),
(211187,56472,'2002-01-16','9999-01-01'),
(211453,57826,'1991-05-09','1992-05-08'),
(211453,60979,'1992-05-08','1993-05-08');


INSERT INTO `salaries` VALUES (211453,61296,'1993-05-08','1994-05-08'),
(211453,65751,'1994-05-08','1995-05-08'),
(211453,66839,'1995-05-08','1996-05-07'),
(211453,67079,'1996-05-07','1997-05-07'),
(211453,67089,'1997-05-07','1998-05-07'),
(211453,67368,'1998-05-07','1999-05-07'),
(211453,69087,'1999-05-07','2000-05-06'),
(211453,72538,'2000-05-06','2001-05-06'),
(211453,74987,'2001-05-06','2002-05-06'),
(211453,75648,'2002-05-06','9999-01-01');


INSERT INTO `salaries` VALUES (211730,66590,'1990-04-27','1991-04-27'),
(211730,69819,'1991-04-27','1992-04-26'),
(211730,71628,'1992-04-26','1993-04-26'),
(211730,74974,'1993-04-26','1994-04-26'),
(211730,74901,'1994-04-26','1995-04-26'),
(211730,76085,'1995-04-26','1996-04-25'),
(211730,79326,'1996-04-25','1997-04-25'),
(211730,81989,'1997-04-25','1998-04-25'),
(211730,83556,'1998-04-25','1999-04-25'),
(211730,86270,'1999-04-25','2000-04-24');


INSERT INTO `salaries` VALUES (211730,87340,'2000-04-24','2001-04-24'),
(211730,89152,'2001-04-24','2002-04-24'),
(211730,89340,'2002-04-24','9999-01-01'),
(212017,59815,'1987-09-01','1988-08-31'),
(212017,64043,'1988-08-31','1989-08-31'),
(212017,68335,'1989-08-31','1990-08-31'),
(212017,70314,'1990-08-31','1991-08-31'),
(212017,69818,'1991-08-31','1992-08-30'),
(212017,70515,'1992-08-30','1993-08-30'),
(212017,70861,'1993-08-30','1994-08-30');


INSERT INTO `salaries` VALUES (212017,74652,'1994-08-30','1995-08-30'),
(212017,76901,'1995-08-30','1996-08-29'),
(212017,77564,'1996-08-29','1997-08-29'),
(212017,78389,'1997-08-29','1998-08-29'),
(212017,80084,'1998-08-29','1999-08-29'),
(212017,83117,'1999-08-29','2000-08-28'),
(212017,86290,'2000-08-28','2001-08-28'),
(212017,87835,'2001-08-28','9999-01-01'),
(212041,63593,'1990-09-15','1991-09-15'),
(212041,65673,'1991-09-15','1992-09-14');


INSERT INTO `salaries` VALUES (212041,68999,'1992-09-14','1993-07-01'),
(212148,77377,'1992-01-15','1993-01-14'),
(212148,79513,'1993-01-14','1994-01-14'),
(212148,83898,'1994-01-14','1995-01-14'),
(212148,87755,'1995-01-14','1996-01-14'),
(212148,92061,'1996-01-14','1997-01-13'),
(212148,92434,'1997-01-13','1998-01-13'),
(212148,92659,'1998-01-13','1999-01-13'),
(212148,94419,'1999-01-13','2000-01-13'),
(212148,98746,'2000-01-13','2001-01-12');


INSERT INTO `salaries` VALUES (212148,99864,'2001-01-12','2002-01-12'),
(212148,100404,'2002-01-12','9999-01-01'),
(212297,46521,'1997-04-30','1998-04-30'),
(212297,49797,'1998-04-30','1999-04-30'),
(212297,53039,'1999-04-30','2000-04-29'),
(212297,54422,'2000-04-29','2001-04-29'),
(212297,58877,'2001-04-29','2002-04-29'),
(212297,62932,'2002-04-29','9999-01-01'),
(212862,40000,'1989-01-24','1990-01-24'),
(212862,40016,'1990-01-24','1991-01-24');


INSERT INTO `salaries` VALUES (212862,40546,'1991-01-24','1992-01-24'),
(212862,42614,'1992-01-24','1993-01-23'),
(212862,42495,'1993-01-23','1994-01-23'),
(212862,45698,'1994-01-23','1995-01-23'),
(212862,46531,'1995-01-23','1996-01-23'),
(212862,49719,'1996-01-23','1997-01-22'),
(212862,52570,'1997-01-22','1998-01-22'),
(212862,56003,'1998-01-22','1999-01-22'),
(212862,55831,'1999-01-22','2000-01-22'),
(212862,57624,'2000-01-22','2001-01-21');


INSERT INTO `salaries` VALUES (212862,57793,'2001-01-21','2002-01-21'),
(212862,58864,'2002-01-21','9999-01-01'),
(213423,59814,'1997-02-04','1998-02-04'),
(213423,63014,'1998-02-04','1999-02-04'),
(213423,66306,'1999-02-04','2000-02-04'),
(213423,69846,'2000-02-04','2001-02-03'),
(213423,71469,'2001-02-03','2002-02-03'),
(213423,72096,'2002-02-03','9999-01-01'),
(214113,54071,'1995-09-16','1996-09-15'),
(214113,57675,'1996-09-15','1997-09-15');


INSERT INTO `salaries` VALUES (214113,62061,'1997-09-15','1998-09-15'),
(214113,65023,'1998-09-15','1999-09-15'),
(214113,67845,'1999-09-15','2000-09-14'),
(214113,67466,'2000-09-14','2001-09-14'),
(214113,68154,'2001-09-14','9999-01-01'),
(214252,66474,'1985-08-29','1986-08-29'),
(214252,68286,'1986-08-29','1987-08-29'),
(214252,71483,'1987-08-29','1988-08-28'),
(214252,75177,'1988-08-28','1989-08-28'),
(214252,76881,'1989-08-28','1990-08-28');


INSERT INTO `salaries` VALUES (214252,77039,'1990-08-28','1991-08-28'),
(214252,80209,'1991-08-28','1992-08-27'),
(214252,81030,'1992-08-27','1993-08-27'),
(214252,83305,'1993-08-27','1994-08-27'),
(214252,87786,'1994-08-27','1995-08-27'),
(214252,87793,'1995-08-27','1996-08-26'),
(214252,91522,'1996-08-26','1997-08-26'),
(214252,92460,'1997-08-26','1998-08-26'),
(214252,93972,'1998-08-26','1999-08-26'),
(214252,93845,'1999-08-26','2000-08-25');


INSERT INTO `salaries` VALUES (214252,98200,'2000-08-25','2001-08-25'),
(214252,98150,'2001-08-25','9999-01-01'),
(214605,40000,'1988-05-18','1989-05-18'),
(214605,41829,'1989-05-18','1990-05-18'),
(214605,43586,'1990-05-18','1991-05-18'),
(214605,45545,'1991-05-18','1992-05-17'),
(214605,48380,'1992-05-17','1993-05-17'),
(214605,48740,'1993-05-17','1994-05-17'),
(214605,51098,'1994-05-17','1995-05-17'),
(214605,52245,'1995-05-17','1996-05-16');


INSERT INTO `salaries` VALUES (214605,54609,'1996-05-16','1997-05-16'),
(214605,58111,'1997-05-16','1998-05-16'),
(214605,58428,'1998-05-16','1999-05-16'),
(214605,61723,'1999-05-16','2000-05-15'),
(214605,64923,'2000-05-15','2001-05-15'),
(214605,66780,'2001-05-15','2002-05-15'),
(214605,67080,'2002-05-15','9999-01-01'),
(214711,87580,'1990-09-22','1991-09-22'),
(214711,91693,'1991-09-22','1992-09-21'),
(214711,93881,'1992-09-21','1993-09-21');


INSERT INTO `salaries` VALUES (214711,97940,'1993-09-21','1994-09-21'),
(214711,99631,'1994-09-21','1995-09-21'),
(214711,103532,'1995-09-21','1996-09-20'),
(214711,107778,'1996-09-20','1997-09-20'),
(214711,110100,'1997-09-20','1998-09-20'),
(214711,113159,'1998-09-20','1999-09-20'),
(214711,116009,'1999-09-20','2000-09-19'),
(214711,117303,'2000-09-19','2001-09-19'),
(214711,118218,'2001-09-19','9999-01-01'),
(214963,53340,'1989-03-11','1990-03-11');


INSERT INTO `salaries` VALUES (214963,56790,'1990-03-11','1991-03-11'),
(214963,59715,'1991-03-11','1992-03-10'),
(214963,61028,'1992-03-10','1993-03-10'),
(214963,65095,'1993-03-10','1994-03-10'),
(214963,68565,'1994-03-10','1995-03-10'),
(214963,71843,'1995-03-10','1996-03-09'),
(214963,73720,'1996-03-09','1997-03-09'),
(214963,76434,'1997-03-09','1998-03-09'),
(214963,80147,'1998-03-09','1999-03-09'),
(214963,83183,'1999-03-09','2000-03-08');


INSERT INTO `salaries` VALUES (214963,83815,'2000-03-08','2001-03-08'),
(214963,88185,'2001-03-08','2002-03-08'),
(214963,91057,'2002-03-08','9999-01-01'),
(215016,40000,'1999-10-17','2000-10-16'),
(215016,44014,'2000-10-16','2001-10-16'),
(215016,48320,'2001-10-16','9999-01-01'),
(215117,40000,'1994-06-03','1995-06-03'),
(215117,41019,'1995-06-03','1996-06-02'),
(215117,43193,'1996-06-02','1997-06-02'),
(215117,42783,'1997-06-02','1998-06-02');


INSERT INTO `salaries` VALUES (215117,45585,'1998-06-02','1999-06-02'),
(215117,46318,'1999-06-02','2000-06-01'),
(215117,50197,'2000-06-01','2001-06-01'),
(215117,52854,'2001-06-01','2002-06-01'),
(215117,55788,'2002-06-01','9999-01-01'),
(215433,64654,'1992-03-29','1993-03-29'),
(215433,67572,'1993-03-29','1994-03-29'),
(215433,68273,'1994-03-29','1995-03-29'),
(215433,72248,'1995-03-29','1996-03-28'),
(215433,72420,'1996-03-28','1997-03-28');


INSERT INTO `salaries` VALUES (215433,75848,'1997-03-28','1998-03-28'),
(215433,80048,'1998-03-28','1999-03-28'),
(215433,82942,'1999-03-28','2000-03-27'),
(215433,84117,'2000-03-27','2001-03-27'),
(215433,87079,'2001-03-27','2002-03-27'),
(215433,88735,'2002-03-27','9999-01-01'),
(215550,65688,'1988-11-23','1988-12-04'),
(215601,40000,'1998-06-13','1999-06-13'),
(215601,41298,'1999-06-13','2000-06-12'),
(215601,44333,'2000-06-12','2001-06-12');


INSERT INTO `salaries` VALUES (215601,48526,'2001-06-12','2002-06-12'),
(215601,51835,'2002-06-12','9999-01-01'),
(216156,83251,'1988-03-01','1989-03-01'),
(216156,82902,'1989-03-01','1990-03-01'),
(216156,87190,'1990-03-01','1991-03-01'),
(216156,87851,'1991-03-01','1992-02-29'),
(216156,88204,'1992-02-29','1993-02-28'),
(216156,91770,'1993-02-28','1994-02-28'),
(216156,91905,'1994-02-28','1995-02-28'),
(216156,95482,'1995-02-28','1996-02-28');


INSERT INTO `salaries` VALUES (216156,96947,'1996-02-28','1997-02-27'),
(216156,97791,'1997-02-27','1998-02-27'),
(216156,99164,'1998-02-27','1999-02-27'),
(216156,99680,'1999-02-27','2000-02-27'),
(216156,102097,'2000-02-27','2001-02-26'),
(216156,102912,'2001-02-26','2002-02-26'),
(216156,103751,'2002-02-26','9999-01-01'),
(216595,66621,'1999-03-24','2000-03-23'),
(216595,68274,'2000-03-23','2001-03-23'),
(216595,71960,'2001-03-23','2002-03-23');


INSERT INTO `salaries` VALUES (216595,71992,'2002-03-23','9999-01-01'),
(216852,56039,'1992-04-22','1993-04-22'),
(216852,59317,'1993-04-22','1994-04-22'),
(216852,59782,'1994-04-22','1995-04-22'),
(216852,62886,'1995-04-22','1996-04-21'),
(216852,62951,'1996-04-21','1997-04-21'),
(216852,67211,'1997-04-21','1998-04-21'),
(216852,70171,'1998-04-21','1999-04-21'),
(216852,73335,'1999-04-21','2000-04-20'),
(216852,73493,'2000-04-20','2001-04-20');


INSERT INTO `salaries` VALUES (216852,73539,'2001-04-20','2002-04-20'),
(216852,73423,'2002-04-20','9999-01-01'),
(217002,41878,'1992-09-07','1993-09-07'),
(217002,41846,'1993-09-07','1994-09-07'),
(217002,44577,'1994-09-07','1995-09-07'),
(217002,47224,'1995-09-07','1996-09-06'),
(217002,49879,'1996-09-06','1997-09-06'),
(217002,52209,'1997-09-06','1998-09-06'),
(217002,54941,'1998-09-06','1999-09-06'),
(217002,57389,'1999-09-06','2000-09-05');


INSERT INTO `salaries` VALUES (217002,58950,'2000-09-05','2001-09-05'),
(217002,62852,'2001-09-05','9999-01-01'),
(217532,67841,'1999-05-21','2000-05-20'),
(217532,68787,'2000-05-20','2001-05-20'),
(217532,72435,'2001-05-20','2002-05-20'),
(217532,73838,'2002-05-20','9999-01-01'),
(217752,45529,'1990-06-05','1991-06-05'),
(217752,49898,'1991-06-05','1992-06-04'),
(217752,51817,'1992-06-04','1993-06-04'),
(217752,55836,'1993-06-04','1994-06-04');


INSERT INTO `salaries` VALUES (217752,57461,'1994-06-04','1995-06-04'),
(217752,60903,'1995-06-04','1996-06-03'),
(217752,63250,'1996-06-03','1997-06-03'),
(217752,66808,'1997-06-03','1998-06-03'),
(217752,67482,'1998-06-03','1999-06-03'),
(217752,69039,'1999-06-03','2000-06-02'),
(217752,72696,'2000-06-02','2001-06-02'),
(217752,73936,'2001-06-02','2002-06-02'),
(217752,75328,'2002-06-02','9999-01-01'),
(217782,40000,'1992-06-02','1993-06-02');


INSERT INTO `salaries` VALUES (217782,43577,'1993-06-02','1994-06-02'),
(217782,46440,'1994-06-02','1995-06-02'),
(217782,46742,'1995-06-02','1996-06-01'),
(217782,50317,'1996-06-01','1997-06-01'),
(217782,51348,'1997-06-01','1998-06-01'),
(217782,53705,'1998-06-01','1999-06-01'),
(217782,57729,'1999-06-01','2000-05-31'),
(217782,59158,'2000-05-31','2001-05-31'),
(217782,63047,'2001-05-31','2002-05-31'),
(217782,65981,'2002-05-31','9999-01-01');


INSERT INTO `salaries` VALUES (217783,43217,'1997-01-22','1998-01-22'),
(217783,45340,'1998-01-22','1999-01-22'),
(217783,49291,'1999-01-22','2000-01-22'),
(217783,50929,'2000-01-22','2001-01-21'),
(217783,52160,'2001-01-21','2002-01-21'),
(217783,55178,'2002-01-21','9999-01-01'),
(217840,40000,'1986-08-24','1987-08-24'),
(217840,43479,'1987-08-24','1988-08-23'),
(217840,43824,'1988-08-23','1989-08-23'),
(217840,47801,'1989-08-23','1990-08-23');


INSERT INTO `salaries` VALUES (217840,48205,'1990-08-23','1991-08-23'),
(217840,49697,'1991-08-23','1992-08-22'),
(217840,49929,'1992-08-22','1993-08-22'),
(217840,52760,'1993-08-22','1994-08-22'),
(217840,54081,'1994-08-22','1995-08-22'),
(217840,54940,'1995-08-22','1996-08-21'),
(217840,55048,'1996-08-21','1997-08-21'),
(217840,58060,'1997-08-21','1998-08-21'),
(217840,61260,'1998-08-21','1999-08-21'),
(217840,64405,'1999-08-21','2000-08-20');


INSERT INTO `salaries` VALUES (217840,67789,'2000-08-20','2001-08-20'),
(217840,70442,'2001-08-20','9999-01-01'),
(218301,40097,'1989-09-28','1990-09-28'),
(218301,41350,'1990-09-28','1991-09-28'),
(218301,43301,'1991-09-28','1992-09-27'),
(218301,46135,'1992-09-27','1993-09-27'),
(218301,45845,'1993-09-27','1994-09-27'),
(218301,49682,'1994-09-27','1995-09-27'),
(218301,53808,'1995-09-27','1996-09-26'),
(218301,57641,'1996-09-26','1997-09-26');


INSERT INTO `salaries` VALUES (218301,59451,'1997-09-26','1998-09-26'),
(218301,62923,'1998-09-26','1999-09-26'),
(218301,63739,'1999-09-26','2000-09-25'),
(218301,64832,'2000-09-25','2001-09-25'),
(218301,65833,'2001-09-25','9999-01-01'),
(219242,45911,'1997-02-13','1997-11-11'),
(219244,74221,'1992-04-22','1993-04-22'),
(219244,74179,'1993-04-22','1994-04-22'),
(219244,75219,'1994-04-22','1995-04-22'),
(219244,78822,'1995-04-22','1996-04-21');


INSERT INTO `salaries` VALUES (219244,79941,'1996-04-21','1997-04-21'),
(219244,83610,'1997-04-21','1998-04-21'),
(219244,84908,'1998-04-21','1999-04-21'),
(219244,87701,'1999-04-21','2000-04-20'),
(219244,87371,'2000-04-20','2001-04-20'),
(219244,90621,'2001-04-20','2002-04-20'),
(219244,94969,'2002-04-20','9999-01-01'),
(219301,40000,'1988-11-01','1989-11-01'),
(219301,44405,'1989-11-01','1990-11-01'),
(219301,48305,'1990-11-01','1991-11-01');


INSERT INTO `salaries` VALUES (219301,50577,'1991-11-01','1992-10-31'),
(219301,52068,'1992-10-31','1993-10-31'),
(219301,56203,'1993-10-31','1994-10-31'),
(219301,60120,'1994-10-31','1995-10-31'),
(219301,63781,'1995-10-31','1996-10-30'),
(219301,64393,'1996-10-30','1997-10-30'),
(219301,67022,'1997-10-30','1998-10-30'),
(219301,68518,'1998-10-30','1999-10-30'),
(219301,68527,'1999-10-30','2000-10-29'),
(219301,72005,'2000-10-29','2001-10-29');


INSERT INTO `salaries` VALUES (219301,73203,'2001-10-29','9999-01-01'),
(219460,40000,'1990-01-11','1991-01-11'),
(219460,43874,'1991-01-11','1992-01-11'),
(219460,48258,'1992-01-11','1993-01-10'),
(219460,52600,'1993-01-10','1994-01-10'),
(219460,57051,'1994-01-10','1995-01-10'),
(219460,56840,'1995-01-10','1996-01-10'),
(219460,57181,'1996-01-10','1997-01-09'),
(219460,57266,'1997-01-09','1998-01-09'),
(219460,57595,'1998-01-09','1999-01-09');


INSERT INTO `salaries` VALUES (219460,61111,'1999-01-09','2000-01-09'),
(219460,62171,'2000-01-09','2001-01-08'),
(219460,65326,'2001-01-08','2002-01-08'),
(219460,67404,'2002-01-08','9999-01-01'),
(219998,75386,'1990-10-18','1991-10-18'),
(219998,78200,'1991-10-18','1992-10-17'),
(219998,81107,'1992-10-17','1993-10-17'),
(219998,82469,'1993-10-17','1994-10-17'),
(219998,84366,'1994-10-17','1995-10-17'),
(219998,86806,'1995-10-17','1996-10-16');


INSERT INTO `salaries` VALUES (219998,87878,'1996-10-16','1997-10-16'),
(219998,88722,'1997-10-16','1998-10-16'),
(219998,88405,'1998-10-16','1999-10-16'),
(219998,89588,'1999-10-16','2000-10-15'),
(219998,91804,'2000-10-15','2001-10-15'),
(219998,92163,'2001-10-15','9999-01-01'),
(220007,47413,'1985-12-06','1986-12-06'),
(220007,47601,'1986-12-06','1987-12-06'),
(220007,51987,'1987-12-06','1988-12-05'),
(220007,52308,'1988-12-05','1989-12-05');


INSERT INTO `salaries` VALUES (220007,54724,'1989-12-05','1990-12-05'),
(220007,55675,'1990-12-05','1991-12-05'),
(220007,56014,'1991-12-05','1992-12-04'),
(220007,57551,'1992-12-04','1993-12-04'),
(220007,61420,'1993-12-04','1994-12-04'),
(220007,64305,'1994-12-04','1995-12-04'),
(220007,68199,'1995-12-04','1996-12-03'),
(220007,70015,'1996-12-03','1997-12-03'),
(220007,70405,'1997-12-03','1998-12-03'),
(220007,74781,'1998-12-03','1999-12-03');


INSERT INTO `salaries` VALUES (220007,76213,'1999-12-03','2000-12-02'),
(220007,78659,'2000-12-02','2001-12-02'),
(220007,82823,'2001-12-02','9999-01-01'),
(220063,40000,'1997-10-17','1998-10-17'),
(220063,43886,'1998-10-17','1999-10-17'),
(220063,45755,'1999-10-17','2000-10-16'),
(220063,48440,'2000-10-16','2001-10-16'),
(220063,52029,'2001-10-16','9999-01-01'),
(220622,40000,'1985-08-30','1986-08-30'),
(220622,43118,'1986-08-30','1987-08-30');


INSERT INTO `salaries` VALUES (220622,43438,'1987-08-30','1988-08-29'),
(220622,45569,'1988-08-29','1989-08-29'),
(220622,46018,'1989-08-29','1990-08-29'),
(220622,45832,'1990-08-29','1991-08-29'),
(220622,49211,'1991-08-29','1992-08-28'),
(220622,51841,'1992-08-28','1993-08-28'),
(220622,54150,'1993-08-28','1994-08-28'),
(220622,58189,'1994-08-28','1995-08-28'),
(220622,59389,'1995-08-28','1996-08-27'),
(220622,63152,'1996-08-27','1997-08-27');


INSERT INTO `salaries` VALUES (220622,63868,'1997-08-27','1998-08-27'),
(220622,64013,'1998-08-27','1999-08-27'),
(220622,65020,'1999-08-27','2000-08-26'),
(220622,68621,'2000-08-26','2001-08-26'),
(220622,69161,'2001-08-26','9999-01-01'),
(220844,86612,'1987-01-27','1988-01-27'),
(220844,89722,'1988-01-27','1989-01-26'),
(220844,90182,'1989-01-26','1990-01-26'),
(220844,93590,'1990-01-26','1991-01-26'),
(220844,94652,'1991-01-26','1992-01-26');


INSERT INTO `salaries` VALUES (220844,94557,'1992-01-26','1993-01-25'),
(220844,97242,'1993-01-25','1994-01-25'),
(220844,100223,'1994-01-25','1995-01-25'),
(220844,100452,'1995-01-25','1996-01-25'),
(220844,103085,'1996-01-25','1997-01-24'),
(220844,104510,'1997-01-24','1998-01-24'),
(220844,104463,'1998-01-24','1999-01-24'),
(220844,104644,'1999-01-24','2000-01-24'),
(220844,105570,'2000-01-24','2001-01-23'),
(220844,109282,'2001-01-23','2002-01-23');


INSERT INTO `salaries` VALUES (220844,113647,'2002-01-23','9999-01-01'),
(221223,68667,'1986-08-24','1987-08-24'),
(221223,69597,'1987-08-24','1988-08-23'),
(221223,72752,'1988-08-23','1989-08-23'),
(221223,76823,'1989-08-23','1990-08-23'),
(221223,80814,'1990-08-23','1991-08-23'),
(221223,82357,'1991-08-23','1992-08-22'),
(221223,85464,'1992-08-22','1993-08-22'),
(221223,86148,'1993-08-22','1994-08-22'),
(221223,88587,'1994-08-22','1995-07-20');


INSERT INTO `salaries` VALUES (221336,44573,'1993-02-28','1994-02-28'),
(221336,45208,'1994-02-28','1995-02-28'),
(221336,47889,'1995-02-28','1996-02-28'),
(221336,49126,'1996-02-28','1997-02-27'),
(221336,49676,'1997-02-27','1998-02-27'),
(221336,54136,'1998-02-27','1999-02-27'),
(221336,58433,'1999-02-27','2000-02-27'),
(221336,59321,'2000-02-27','2001-02-26'),
(221336,59906,'2001-02-26','2002-02-26'),
(221336,63625,'2002-02-26','9999-01-01');


INSERT INTO `salaries` VALUES (221957,40000,'1991-07-04','1992-07-03'),
(221957,44063,'1992-07-03','1993-07-03'),
(221957,48322,'1993-07-03','1994-07-03'),
(221957,52500,'1994-07-03','1995-07-03'),
(221957,54635,'1995-07-03','1996-07-02'),
(221957,54804,'1996-07-02','1997-07-02'),
(221957,58173,'1997-07-02','1998-07-02'),
(221957,58238,'1998-07-02','1999-07-02'),
(221957,61111,'1999-07-02','2000-07-01'),
(221957,63276,'2000-07-01','2001-07-01');


INSERT INTO `salaries` VALUES (221957,65184,'2001-07-01','2002-07-01'),
(221957,67554,'2002-07-01','9999-01-01'),
(222025,43581,'1992-08-19','1993-08-19'),
(222025,48037,'1993-08-19','1994-08-19'),
(222025,48417,'1994-08-19','1995-08-19'),
(222025,51082,'1995-08-19','1996-08-18'),
(222025,55370,'1996-08-18','1997-08-09'),
(222357,63614,'1997-10-28','1998-10-28'),
(222357,66650,'1998-10-28','1999-10-28'),
(222357,70574,'1999-10-28','2000-08-11');


INSERT INTO `salaries` VALUES (222429,40000,'1994-12-30','1995-12-30'),
(222429,41019,'1995-12-30','1996-12-29'),
(222429,44453,'1996-12-29','1997-12-29'),
(222429,45704,'1997-12-29','1998-12-29'),
(222429,45677,'1998-12-29','1999-12-29'),
(222429,45336,'1999-12-29','2000-12-28'),
(222429,48730,'2000-12-28','2001-12-28'),
(222429,50471,'2001-12-28','9999-01-01'),
(222918,79312,'1987-01-08','1988-01-08'),
(222918,82073,'1988-01-08','1989-01-07');


INSERT INTO `salaries` VALUES (222918,86504,'1989-01-07','1990-01-07'),
(222918,87379,'1990-01-07','1991-01-07'),
(222918,89659,'1991-01-07','1992-01-07'),
(222918,90198,'1992-01-07','1993-01-06'),
(222918,94308,'1993-01-06','1994-01-06'),
(222918,96940,'1994-01-06','1995-01-06'),
(222918,101439,'1995-01-06','1996-01-06'),
(222918,101234,'1996-01-06','1997-01-05'),
(222918,105181,'1997-01-05','1998-01-05'),
(222918,104951,'1998-01-05','1999-01-05');


INSERT INTO `salaries` VALUES (222918,106524,'1999-01-05','2000-01-05'),
(222918,109306,'2000-01-05','2001-01-04'),
(222918,112103,'2001-01-04','2002-01-04'),
(222918,116485,'2002-01-04','9999-01-01'),
(223063,69650,'1996-04-22','1997-04-22'),
(223063,71581,'1997-04-22','1998-04-22'),
(223063,74587,'1998-04-22','1999-04-22'),
(223063,77787,'1999-04-22','2000-04-21'),
(223063,81908,'2000-04-21','2001-04-21'),
(223063,84330,'2001-04-21','2002-04-21');


INSERT INTO `salaries` VALUES (223063,88239,'2002-04-21','9999-01-01'),
(223114,52149,'1999-10-09','2000-10-08'),
(223114,54784,'2000-10-08','2001-10-08'),
(223114,58982,'2001-10-08','9999-01-01'),
(223290,40000,'1998-09-03','1999-09-03'),
(223290,41230,'1999-09-03','2000-09-02'),
(223290,41053,'2000-09-02','2001-09-02'),
(223290,41032,'2001-09-02','9999-01-01'),
(223906,72361,'1996-11-24','1997-11-24'),
(223906,72660,'1997-11-24','1998-11-24');


INSERT INTO `salaries` VALUES (223906,75255,'1998-11-24','1999-11-24'),
(223906,76486,'1999-11-24','2000-11-23'),
(223906,77876,'2000-11-23','2001-11-23'),
(223906,77798,'2001-11-23','9999-01-01'),
(224094,58170,'1994-06-08','1995-06-08'),
(224094,60561,'1995-06-08','1996-06-07'),
(224094,60389,'1996-06-07','1997-06-07'),
(224094,63804,'1997-06-07','1998-06-07'),
(224094,67116,'1998-06-07','1999-06-07'),
(224094,71016,'1999-06-07','2000-06-06');


INSERT INTO `salaries` VALUES (224094,70896,'2000-06-06','2001-06-06'),
(224094,74029,'2001-06-06','2002-06-06'),
(224094,76108,'2002-06-06','9999-01-01'),
(224758,40000,'1996-12-10','1997-12-10'),
(224758,44177,'1997-12-10','1998-12-10'),
(224758,46736,'1998-12-10','1999-12-10'),
(224758,46672,'1999-12-10','2000-12-09'),
(224758,48755,'2000-12-09','2001-08-19'),
(225042,59362,'1998-07-26','1999-07-26'),
(225042,63694,'1999-07-26','2000-07-25');


INSERT INTO `salaries` VALUES (225042,64937,'2000-07-25','2001-07-25'),
(225042,67422,'2001-07-25','2002-07-25'),
(225042,69617,'2002-07-25','9999-01-01'),
(225116,75291,'1994-12-01','1995-12-01'),
(225116,75289,'1995-12-01','1996-11-30'),
(225116,78966,'1996-11-30','1997-11-30'),
(225116,80696,'1997-11-30','1998-11-30'),
(225116,84599,'1998-11-30','1999-11-30'),
(225116,86690,'1999-11-30','2000-11-29'),
(225116,87657,'2000-11-29','2001-11-29');


INSERT INTO `salaries` VALUES (225116,88893,'2001-11-29','9999-01-01'),
(225178,40000,'1986-08-18','1987-08-18'),
(225178,42490,'1987-08-18','1988-08-17'),
(225178,43938,'1988-08-17','1989-08-17'),
(225178,46970,'1989-08-17','1990-08-17'),
(225178,48363,'1990-08-17','1991-08-17'),
(225178,52298,'1991-08-17','1992-07-19'),
(225409,79098,'1991-04-27','1992-04-26'),
(225409,81827,'1992-04-26','1993-04-26'),
(225409,82636,'1993-04-26','1994-04-26');


INSERT INTO `salaries` VALUES (225409,85116,'1994-04-26','1995-04-26'),
(225409,86315,'1995-04-26','1996-04-25'),
(225409,87291,'1996-04-25','1997-04-25'),
(225409,90707,'1997-04-25','1998-04-25'),
(225409,93731,'1998-04-25','1999-04-25'),
(225409,94138,'1999-04-25','2000-04-24'),
(225409,97360,'2000-04-24','2001-04-24'),
(225409,101061,'2001-04-24','2002-04-24'),
(225409,101109,'2002-04-24','9999-01-01'),
(225436,56957,'1990-09-03','1991-09-03');


INSERT INTO `salaries` VALUES (225436,60761,'1991-09-03','1992-09-02'),
(225436,60636,'1992-09-02','1993-09-02'),
(225436,64114,'1993-09-02','1994-09-02'),
(225436,65600,'1994-09-02','1995-09-02'),
(225436,69498,'1995-09-02','1996-09-01'),
(225436,70828,'1996-09-01','1997-09-01'),
(225436,71906,'1997-09-01','1998-09-01'),
(225436,76026,'1998-09-01','1999-09-01'),
(225436,79090,'1999-09-01','2000-08-31'),
(225436,81380,'2000-08-31','2001-08-31');


INSERT INTO `salaries` VALUES (225436,81594,'2001-08-31','9999-01-01'),
(225517,56031,'1995-01-18','1996-01-18'),
(225517,56946,'1996-01-18','1997-01-17'),
(225517,60388,'1997-01-17','1998-01-17'),
(225517,61677,'1998-01-17','1999-01-17'),
(225517,65882,'1999-01-17','1999-09-02'),
(225734,42691,'1990-11-10','1991-11-10'),
(225734,42812,'1991-11-10','1992-06-20'),
(225974,48122,'1987-09-25','1988-09-24'),
(225974,50194,'1988-09-24','1989-09-24');


INSERT INTO `salaries` VALUES (225974,52427,'1989-09-24','1990-09-24'),
(225974,52273,'1990-09-24','1991-09-24'),
(225974,56285,'1991-09-24','1992-09-23'),
(225974,57233,'1992-09-23','1993-09-23'),
(225974,59222,'1993-09-23','1994-09-23'),
(225974,61989,'1994-09-23','1995-09-23'),
(225974,62976,'1995-09-23','1996-09-22'),
(225974,64458,'1996-09-22','1997-09-22'),
(225974,67454,'1997-09-22','1998-09-22'),
(225974,68206,'1998-09-22','1999-09-22');


INSERT INTO `salaries` VALUES (225974,70575,'1999-09-22','2000-09-21'),
(225974,72050,'2000-09-21','2001-09-21'),
(225974,76258,'2001-09-21','9999-01-01'),
(226262,43832,'1990-11-24','1991-11-24'),
(226262,47314,'1991-11-24','1992-11-23'),
(226262,50137,'1992-11-23','1993-11-23'),
(226262,52513,'1993-11-23','1994-11-23'),
(226262,54160,'1994-11-23','1995-11-23'),
(226262,56677,'1995-11-23','1996-11-22'),
(226262,58577,'1996-11-22','1997-11-22');


INSERT INTO `salaries` VALUES (226262,62426,'1997-11-22','1998-11-22'),
(226262,66306,'1998-11-22','1999-11-22'),
(226262,67596,'1999-11-22','2000-11-21'),
(226262,70601,'2000-11-21','2001-11-21'),
(226262,70741,'2001-11-21','9999-01-01'),
(226516,53326,'1987-01-05','1988-01-05'),
(226516,53140,'1988-01-05','1989-01-04'),
(226516,57403,'1989-01-04','1990-01-04'),
(226516,59138,'1990-01-04','1991-01-04'),
(226516,59071,'1991-01-04','1992-01-04');


INSERT INTO `salaries` VALUES (226516,60791,'1992-01-04','1993-01-03'),
(226516,65001,'1993-01-03','1994-01-03'),
(226516,69351,'1994-01-03','1995-01-03'),
(226516,70533,'1995-01-03','1996-01-03'),
(226516,70191,'1996-01-03','1997-01-02'),
(226516,72788,'1997-01-02','1998-01-02'),
(226516,72503,'1998-01-02','1999-01-02'),
(226516,75399,'1999-01-02','2000-01-02'),
(226516,77751,'2000-01-02','2001-01-01'),
(226516,79937,'2001-01-01','2002-01-01');


INSERT INTO `salaries` VALUES (226516,79838,'2002-01-01','9999-01-01'),
(227299,40000,'1988-06-18','1989-06-18'),
(227299,41253,'1989-06-18','1990-06-18'),
(227299,44904,'1990-06-18','1991-06-18'),
(227299,47106,'1991-06-18','1992-06-17'),
(227299,50547,'1992-06-17','1993-06-17'),
(227299,54621,'1993-06-17','1994-06-17'),
(227299,57090,'1994-06-17','1995-06-17'),
(227299,61373,'1995-06-17','1996-06-16'),
(227299,61240,'1996-06-16','1997-06-16');


INSERT INTO `salaries` VALUES (227299,61221,'1997-06-16','1998-06-16'),
(227299,60785,'1998-06-16','1999-06-16'),
(227299,60725,'1999-06-16','2000-06-15'),
(227299,63132,'2000-06-15','2001-06-15'),
(227299,63830,'2001-06-15','2002-06-15'),
(227299,65864,'2002-06-15','9999-01-01'),
(227376,65986,'1993-08-05','1994-08-05'),
(227376,68154,'1994-08-05','1995-08-05'),
(227376,70652,'1995-08-05','1996-08-04'),
(227376,73077,'1996-08-04','1997-04-06');


INSERT INTO `salaries` VALUES (227537,40000,'1993-02-27','1994-02-27'),
(227537,43051,'1994-02-27','1995-02-27'),
(227537,44710,'1995-02-27','1996-02-27'),
(227537,46887,'1996-02-27','1997-02-26'),
(227537,50343,'1997-02-26','1998-02-26'),
(227537,50656,'1998-02-26','1999-02-26'),
(227537,50707,'1999-02-26','2000-02-26'),
(227537,52548,'2000-02-26','2001-02-25'),
(227537,54293,'2001-02-25','2002-02-25'),
(227537,54026,'2002-02-25','9999-01-01');


INSERT INTO `salaries` VALUES (227761,48184,'1998-06-14','1999-06-14'),
(227761,49472,'1999-06-14','2000-06-13'),
(227761,53095,'2000-06-13','2001-06-13'),
(227761,56734,'2001-06-13','2002-06-13'),
(227761,59357,'2002-06-13','9999-01-01'),
(227830,40000,'1991-09-15','1992-09-14'),
(227830,43459,'1992-09-14','1993-09-14'),
(227830,43499,'1993-09-14','1994-09-14'),
(227830,47123,'1994-09-14','1995-09-14'),
(227830,49978,'1995-09-14','1996-09-13');


INSERT INTO `salaries` VALUES (227830,49967,'1996-09-13','1997-09-13'),
(227830,54024,'1997-09-13','1998-09-13'),
(227830,56916,'1998-09-13','1999-09-13'),
(227830,60211,'1999-09-13','2000-09-12'),
(227830,64706,'2000-09-12','2001-09-12'),
(227830,65038,'2001-09-12','9999-01-01'),
(227894,71601,'1989-06-10','1990-06-10'),
(227894,72148,'1990-06-10','1991-06-10'),
(227894,71813,'1991-06-10','1992-06-09'),
(227894,71541,'1992-06-09','1993-06-09');


INSERT INTO `salaries` VALUES (227894,74848,'1993-06-09','1994-06-09'),
(227894,74729,'1994-06-09','1995-06-09'),
(227894,77764,'1995-06-09','1996-06-08'),
(227894,78194,'1996-06-08','1997-06-08'),
(227894,78054,'1997-06-08','1998-06-08'),
(227894,79443,'1998-06-08','1999-06-08'),
(227894,82218,'1999-06-08','2000-06-07'),
(227894,82331,'2000-06-07','2001-06-07'),
(227894,83824,'2001-06-07','2002-06-07'),
(227894,87548,'2002-06-07','9999-01-01');


INSERT INTO `salaries` VALUES (228005,40699,'1992-08-29','1993-08-29'),
(228005,41606,'1993-08-29','1994-08-29'),
(228005,42129,'1994-08-29','1995-05-07'),
(228051,51525,'1988-12-18','1989-12-18'),
(228051,51372,'1989-12-18','1990-12-18'),
(228051,53126,'1990-12-18','1991-12-18'),
(228051,55547,'1991-12-18','1992-12-17'),
(228051,57959,'1992-12-17','1993-12-17'),
(228051,57516,'1993-12-17','1994-12-17'),
(228051,61289,'1994-12-17','1995-12-17');


INSERT INTO `salaries` VALUES (228051,61020,'1995-12-17','1996-12-16'),
(228051,62082,'1996-12-16','1997-12-16'),
(228051,65470,'1997-12-16','1998-12-16'),
(228051,67563,'1998-12-16','1999-12-16'),
(228051,71561,'1999-12-16','2000-12-15'),
(228051,75061,'2000-12-15','2001-12-15'),
(228051,76789,'2001-12-15','9999-01-01'),
(228327,43309,'1989-10-22','1990-10-22'),
(228327,45980,'1990-10-22','1991-10-22'),
(228327,49649,'1991-10-22','1992-10-21');


INSERT INTO `salaries` VALUES (228327,52471,'1992-10-21','1993-10-21'),
(228327,55836,'1993-10-21','1994-10-21'),
(228327,59022,'1994-10-21','1995-10-21'),
(228327,59009,'1995-10-21','1996-10-20'),
(228327,59498,'1996-10-20','1997-10-20'),
(228327,61259,'1997-10-20','1998-10-20'),
(228327,63687,'1998-10-20','1999-10-20'),
(228327,65167,'1999-10-20','2000-10-19'),
(228327,66415,'2000-10-19','2001-10-19'),
(228327,70636,'2001-10-19','9999-01-01');


INSERT INTO `salaries` VALUES (228344,43190,'1999-07-01','2000-06-30'),
(228344,42853,'2000-06-30','2000-09-04'),
(228369,46030,'1998-05-17','1999-05-17'),
(228369,45541,'1999-05-17','2000-05-16'),
(228369,48528,'2000-05-16','2001-05-16'),
(228369,52822,'2001-05-16','2002-05-16'),
(228369,53212,'2002-05-16','9999-01-01'),
(228686,40000,'1998-09-22','1999-09-22'),
(228686,44317,'1999-09-22','2000-09-21'),
(228686,46620,'2000-09-21','2001-09-21');


INSERT INTO `salaries` VALUES (228686,47788,'2001-09-21','9999-01-01'),
(229063,41112,'1991-07-31','1992-07-30'),
(229063,45338,'1992-07-30','1993-07-30'),
(229063,48937,'1993-07-30','1994-07-30'),
(229063,50566,'1994-07-30','1995-07-30'),
(229063,53636,'1995-07-30','1996-07-29'),
(229063,55781,'1996-07-29','1997-07-29'),
(229063,55379,'1997-07-29','1998-07-29'),
(229063,56161,'1998-07-29','1999-07-29'),
(229063,60448,'1999-07-29','2000-07-28');


INSERT INTO `salaries` VALUES (229063,60847,'2000-07-28','2001-07-28'),
(229063,64585,'2001-07-28','2002-07-28'),
(229063,67150,'2002-07-28','9999-01-01'),
(229279,47734,'1998-05-08','1999-05-08'),
(229279,50859,'1999-05-08','2000-05-07'),
(229279,52202,'2000-05-07','2001-05-07'),
(229279,56039,'2001-05-07','2002-05-07'),
(229279,56214,'2002-05-07','9999-01-01'),
(229600,40000,'1987-08-28','1988-08-27'),
(229600,43586,'1988-08-27','1989-08-27');


INSERT INTO `salaries` VALUES (229600,46294,'1989-08-27','1990-08-27'),
(229600,46791,'1990-08-27','1991-08-27'),
(229600,47197,'1991-08-27','1992-08-26'),
(229600,47032,'1992-08-26','1993-08-26'),
(229600,48288,'1993-08-26','1994-08-26'),
(229600,49816,'1994-08-26','1995-08-26'),
(229600,50275,'1995-08-26','1996-08-25'),
(229600,52145,'1996-08-25','1997-08-25'),
(229600,55804,'1997-08-25','1998-08-25'),
(229600,59519,'1998-08-25','1999-08-25');


INSERT INTO `salaries` VALUES (229600,61104,'1999-08-25','2000-08-24'),
(229600,63688,'2000-08-24','2001-08-24'),
(229600,66172,'2001-08-24','2002-03-23'),
(229623,59409,'1998-10-14','1999-10-14'),
(229623,58936,'1999-10-14','2000-10-13'),
(229623,63017,'2000-10-13','2001-10-13'),
(229623,66471,'2001-10-13','9999-01-01'),
(229949,50008,'1994-06-27','1995-06-27'),
(229949,54457,'1995-06-27','1996-06-26'),
(229949,54925,'1996-06-26','1997-06-26');


INSERT INTO `salaries` VALUES (229949,54626,'1997-06-26','1998-06-26'),
(229949,58358,'1998-06-26','1999-06-26'),
(229949,59400,'1999-06-26','2000-06-25'),
(229949,62530,'2000-06-25','2001-06-25'),
(229949,62720,'2001-06-25','2002-06-25'),
(229949,63210,'2002-06-25','9999-01-01'),
(230087,40000,'1994-02-18','1995-02-18'),
(230087,43795,'1995-02-18','1996-02-18'),
(230087,43365,'1996-02-18','1997-02-17'),
(230087,47711,'1997-02-17','1998-02-17');


INSERT INTO `salaries` VALUES (230087,49140,'1998-02-17','1999-02-17'),
(230087,49968,'1999-02-17','2000-02-17'),
(230087,50915,'2000-02-17','2001-02-16'),
(230087,50798,'2001-02-16','2002-02-16'),
(230087,51842,'2002-02-16','9999-01-01'),
(230099,40000,'1992-09-24','1993-09-24'),
(230099,41740,'1993-09-24','1994-09-24'),
(230099,45772,'1994-09-24','1995-09-24'),
(230099,49924,'1995-09-24','1996-09-23'),
(230099,51355,'1996-09-23','1997-09-23');


INSERT INTO `salaries` VALUES (230099,54860,'1997-09-23','1998-09-23'),
(230099,59135,'1998-09-23','1999-09-23'),
(230099,59134,'1999-09-23','2000-09-22'),
(230099,61420,'2000-09-22','2001-09-22'),
(230099,63892,'2001-09-22','9999-01-01'),
(230343,40000,'1998-07-28','1999-07-28'),
(230343,41163,'1999-07-28','2000-07-27'),
(230343,44741,'2000-07-27','2001-07-27'),
(230343,46675,'2001-07-27','2002-07-26'),
(230627,58513,'1986-01-29','1987-01-29');


INSERT INTO `salaries` VALUES (230627,58474,'1987-01-29','1988-01-29'),
(230627,62054,'1988-01-29','1989-01-28'),
(230627,63633,'1989-01-28','1990-01-28'),
(230627,63209,'1990-01-28','1991-01-28'),
(230627,65369,'1991-01-28','1992-01-28'),
(230627,66772,'1992-01-28','1993-01-27'),
(230627,66523,'1993-01-27','1994-01-27'),
(230627,67077,'1994-01-27','1995-01-27'),
(230627,69850,'1995-01-27','1996-01-27'),
(230627,71122,'1996-01-27','1997-01-26');


INSERT INTO `salaries` VALUES (230627,70892,'1997-01-26','1998-01-26'),
(230627,74133,'1998-01-26','1999-01-26'),
(230627,78200,'1999-01-26','2000-01-26'),
(230627,78175,'2000-01-26','2001-01-25'),
(230627,79984,'2001-01-25','2002-01-25'),
(230627,83397,'2002-01-25','9999-01-01'),
(230801,102623,'1988-10-22','1989-10-22'),
(230801,106298,'1989-10-22','1990-10-22'),
(230801,109439,'1990-10-22','1991-10-22'),
(230801,112149,'1991-10-22','1992-10-21');


INSERT INTO `salaries` VALUES (230801,113552,'1992-10-21','1993-10-21'),
(230801,113696,'1993-10-21','1994-10-21'),
(230801,117929,'1994-10-21','1995-10-21'),
(230801,122217,'1995-10-21','1996-10-20'),
(230801,125208,'1996-10-20','1997-10-20'),
(230801,126023,'1997-10-20','1998-10-20'),
(230801,128507,'1998-10-20','1999-10-20'),
(230801,129467,'1999-10-20','2000-10-19'),
(230801,133920,'2000-10-19','2001-10-19'),
(230801,134898,'2001-10-19','9999-01-01');


INSERT INTO `salaries` VALUES (230946,49028,'1988-05-18','1989-05-18'),
(230946,52230,'1989-05-18','1990-05-18'),
(230946,56633,'1990-05-18','1991-05-18'),
(230946,57628,'1991-05-18','1992-05-17'),
(230946,60178,'1992-05-17','1993-05-17'),
(230946,60961,'1993-05-17','1994-05-17'),
(230946,63102,'1994-05-17','1995-05-17'),
(230946,66677,'1995-05-17','1996-05-16'),
(230946,67707,'1996-05-16','1997-05-16'),
(230946,70932,'1997-05-16','1998-05-16');


INSERT INTO `salaries` VALUES (230946,71232,'1998-05-16','1999-05-16'),
(230946,75723,'1999-05-16','2000-05-15'),
(230946,77013,'2000-05-15','2001-05-15'),
(230946,79594,'2001-05-15','2002-05-15'),
(230946,80255,'2002-05-15','9999-01-01'),
(231240,40000,'1999-01-18','2000-01-18'),
(231240,43304,'2000-01-18','2001-01-17'),
(231240,47354,'2001-01-17','2002-01-17'),
(231240,48248,'2002-01-17','9999-01-01'),
(231635,40000,'1985-03-21','1986-03-21');


INSERT INTO `salaries` VALUES (231635,42971,'1986-03-21','1987-03-21'),
(231635,46595,'1987-03-21','1988-03-20'),
(231635,46704,'1988-03-20','1989-03-20'),
(231635,50421,'1989-03-20','1990-03-20'),
(231635,51144,'1990-03-20','1991-03-20'),
(231635,54639,'1991-03-20','1992-03-19'),
(231635,56257,'1992-03-19','1993-03-19'),
(231635,57352,'1993-03-19','1994-03-19'),
(231635,59197,'1994-03-19','1995-03-19'),
(231635,63523,'1995-03-19','1996-03-18');


INSERT INTO `salaries` VALUES (231635,64027,'1996-03-18','1997-03-18'),
(231635,65927,'1997-03-18','1998-03-18'),
(231635,66424,'1998-03-18','1999-03-18'),
(231635,69840,'1999-03-18','2000-03-17'),
(231635,71958,'2000-03-17','2001-03-17'),
(231635,73119,'2001-03-17','2002-03-17'),
(231635,77072,'2002-03-17','9999-01-01'),
(231783,63844,'1993-06-07','1994-06-07'),
(231783,67621,'1994-06-07','1995-06-07'),
(231783,71762,'1995-06-07','1996-06-06');


INSERT INTO `salaries` VALUES (231783,71553,'1996-06-06','1997-06-06'),
(231783,72994,'1997-06-06','1998-06-06'),
(231783,76094,'1998-06-06','1999-06-06'),
(231783,79021,'1999-06-06','2000-06-05'),
(231783,80093,'2000-06-05','2001-06-05'),
(231783,79755,'2001-06-05','2002-06-05'),
(231783,83906,'2002-06-05','9999-01-01'),
(231789,62502,'1987-01-18','1988-01-18'),
(231789,64357,'1988-01-18','1989-01-17'),
(231789,66003,'1989-01-17','1990-01-17');


INSERT INTO `salaries` VALUES (231789,67293,'1990-01-17','1991-01-17'),
(231789,68660,'1991-01-17','1992-01-17'),
(231789,72018,'1992-01-17','1993-01-16'),
(231789,71588,'1993-01-16','1994-01-16'),
(231789,73014,'1994-01-16','1995-01-16'),
(231789,77457,'1995-01-16','1996-01-16'),
(231789,81878,'1996-01-16','1997-01-15'),
(231789,83195,'1997-01-15','1998-01-15'),
(231789,85127,'1998-01-15','1999-01-15'),
(231789,86523,'1999-01-15','2000-01-15');


INSERT INTO `salaries` VALUES (231789,87908,'2000-01-15','2001-01-14'),
(231789,90331,'2001-01-14','2002-01-14'),
(231789,90123,'2002-01-14','9999-01-01'),
(232238,40000,'1987-10-31','1988-10-30'),
(232238,40048,'1988-10-30','1989-10-30'),
(232238,43233,'1989-10-30','1990-10-30'),
(232238,43042,'1990-10-30','1991-10-30'),
(232238,45123,'1991-10-30','1992-10-29'),
(232238,46003,'1992-10-29','1993-10-29'),
(232238,48356,'1993-10-29','1994-08-09');


INSERT INTO `salaries` VALUES (232305,43957,'1992-09-04','1993-09-04'),
(232305,45901,'1993-09-04','1994-09-04'),
(232305,50216,'1994-09-04','1995-09-04'),
(232305,53232,'1995-09-04','1996-09-03'),
(232305,55617,'1996-09-03','1997-09-03'),
(232305,57966,'1997-09-03','1998-09-03'),
(232305,58700,'1998-09-03','1999-09-03'),
(232305,60824,'1999-09-03','2000-09-02'),
(232305,64785,'2000-09-02','2001-09-02'),
(232305,64660,'2001-09-02','9999-01-01');


INSERT INTO `salaries` VALUES (232347,40000,'1996-03-03','1997-03-03'),
(232347,43566,'1997-03-03','1998-03-03'),
(232347,46183,'1998-03-03','1999-03-03'),
(232347,48132,'1999-03-03','2000-03-02'),
(232347,51094,'2000-03-02','2001-03-02'),
(232347,52362,'2001-03-02','2002-03-02'),
(232347,53086,'2002-03-02','9999-01-01'),
(233523,80750,'1985-03-11','1986-03-11'),
(233523,80888,'1986-03-11','1987-03-11'),
(233523,81747,'1987-03-11','1988-03-10');


INSERT INTO `salaries` VALUES (233523,83475,'1988-03-10','1989-03-10'),
(233523,83363,'1989-03-10','1990-03-10'),
(233523,83963,'1990-03-10','1991-03-10'),
(233523,87646,'1991-03-10','1992-03-09'),
(233523,87253,'1992-03-09','1993-03-09'),
(233523,91216,'1993-03-09','1994-03-09'),
(233523,91235,'1994-03-09','1995-03-09'),
(233523,92485,'1995-03-09','1996-03-08'),
(233523,93110,'1996-03-08','1997-03-08'),
(233523,94737,'1997-03-08','1998-03-08');


INSERT INTO `salaries` VALUES (233523,96273,'1998-03-08','1999-03-08'),
(233523,98877,'1999-03-08','2000-03-07'),
(233523,100433,'2000-03-07','2001-03-07'),
(233523,101982,'2001-03-07','2002-03-07'),
(233523,103430,'2002-03-07','9999-01-01'),
(234321,73612,'1996-08-03','1997-08-03'),
(234321,75515,'1997-08-03','1998-08-03'),
(234321,79153,'1998-08-03','1999-08-03'),
(234321,79545,'1999-08-03','2000-07-26'),
(235427,40991,'1991-03-29','1992-03-28');


INSERT INTO `salaries` VALUES (235427,44471,'1992-03-28','1993-03-28'),
(235427,46525,'1993-03-28','1994-03-28'),
(235427,48314,'1994-03-28','1995-03-28'),
(235427,51270,'1995-03-28','1996-03-27'),
(235427,53178,'1996-03-27','1997-03-27'),
(235427,56868,'1997-03-27','1998-03-27'),
(235427,58219,'1998-03-27','1999-03-27'),
(235427,57780,'1999-03-27','2000-01-02'),
(235867,69741,'1991-06-30','1992-06-29'),
(235867,70531,'1992-06-29','1993-06-29');


INSERT INTO `salaries` VALUES (235867,70975,'1993-06-29','1994-06-29'),
(235867,73781,'1994-06-29','1995-06-29'),
(235867,74317,'1995-06-29','1996-06-28'),
(235867,77826,'1996-06-28','1997-06-25'),
(236372,40000,'1990-05-06','1991-05-06'),
(236372,42219,'1991-05-06','1992-05-05'),
(236372,44580,'1992-05-05','1993-05-05'),
(236372,47048,'1993-05-05','1994-05-05'),
(236372,46773,'1994-05-05','1995-05-05'),
(236372,47574,'1995-05-05','1996-05-04');


INSERT INTO `salaries` VALUES (236372,50339,'1996-05-04','1997-05-04'),
(236372,53274,'1997-05-04','1998-05-04'),
(236372,55390,'1998-05-04','1999-05-04'),
(236372,57629,'1999-05-04','2000-05-03'),
(236372,57735,'2000-05-03','2001-05-03'),
(236372,57811,'2001-05-03','2002-05-03'),
(236372,62240,'2002-05-03','9999-01-01'),
(236692,51576,'1996-03-04','1997-03-04'),
(236692,52134,'1997-03-04','1998-03-04'),
(236692,54794,'1998-03-04','1999-03-04');


INSERT INTO `salaries` VALUES (236692,55244,'1999-03-04','2000-03-03'),
(236692,57614,'2000-03-03','2001-03-03'),
(236692,60405,'2001-03-03','2002-03-03'),
(236692,64222,'2002-03-03','9999-01-01'),
(236927,72754,'1996-10-07','1997-10-07'),
(236927,76063,'1997-10-07','1998-10-07'),
(236927,76484,'1998-10-07','1999-10-07'),
(236927,79947,'1999-10-07','2000-10-06'),
(236927,80215,'2000-10-06','2001-08-22'),
(237316,56913,'1992-07-08','1993-07-08');


INSERT INTO `salaries` VALUES (237316,59755,'1993-07-08','1994-07-08'),
(237316,63334,'1994-07-08','1995-07-08'),
(237316,65245,'1995-07-08','1996-07-07'),
(237316,67729,'1996-07-07','1997-07-07'),
(237316,68429,'1997-07-07','1998-07-07'),
(237316,69413,'1998-07-07','1999-07-07'),
(237316,69942,'1999-07-07','2000-07-06'),
(237316,70623,'2000-07-06','2001-07-06'),
(237316,73950,'2001-07-06','2002-07-06'),
(237316,74030,'2002-07-06','9999-01-01');


INSERT INTO `salaries` VALUES (237728,81752,'1992-10-07','1993-10-07'),
(237728,85081,'1993-10-07','1994-10-07'),
(237728,87055,'1994-10-07','1995-03-13'),
(238067,50238,'1988-05-20','1989-05-20'),
(238067,52425,'1989-05-20','1990-05-20'),
(238067,54918,'1990-05-20','1991-05-20'),
(238067,56248,'1991-05-20','1992-05-19'),
(238067,57495,'1992-05-19','1993-05-19'),
(238067,59602,'1993-05-19','1994-05-19'),
(238067,60149,'1994-05-19','1995-05-19');


INSERT INTO `salaries` VALUES (238067,62987,'1995-05-19','1996-05-18'),
(238067,63859,'1996-05-18','1997-05-18'),
(238067,64890,'1997-05-18','1997-07-12'),
(238379,41387,'1994-12-03','1995-12-03'),
(238379,41213,'1995-12-03','1996-12-02'),
(238379,45404,'1996-12-02','1997-12-02'),
(238379,48266,'1997-12-02','1998-12-02'),
(238379,48727,'1998-12-02','1999-12-02'),
(238379,50893,'1999-12-02','2000-12-01'),
(238379,53489,'2000-12-01','2001-12-01');


INSERT INTO `salaries` VALUES (238379,57614,'2001-12-01','9999-01-01'),
(238632,87125,'1992-11-21','1993-11-21'),
(238632,87934,'1993-11-21','1994-11-21'),
(238632,88369,'1994-11-21','1995-11-21'),
(238632,90347,'1995-11-21','1996-11-20'),
(238632,90297,'1996-11-20','1997-11-20'),
(238632,90417,'1997-11-20','1998-11-20'),
(238632,91759,'1998-11-20','1999-11-20'),
(238632,95370,'1999-11-20','2000-11-19'),
(238632,97401,'2000-11-19','2001-11-19');


INSERT INTO `salaries` VALUES (238632,98879,'2001-11-19','2002-04-01'),
(238661,57646,'1997-04-02','1998-04-02'),
(238661,57273,'1998-04-02','1998-06-18'),
(238678,63204,'1991-10-10','1992-10-09'),
(238678,66748,'1992-10-09','1993-10-09'),
(238678,70948,'1993-10-09','1994-10-09'),
(238678,73329,'1994-10-09','1995-10-09'),
(238678,73359,'1995-10-09','1996-10-08'),
(238678,77480,'1996-10-08','1997-10-08'),
(238678,78927,'1997-10-08','1998-10-08');


INSERT INTO `salaries` VALUES (238678,82513,'1998-10-08','1999-10-08'),
(238678,84972,'1999-10-08','2000-10-07'),
(238678,86806,'2000-10-07','2001-10-07'),
(238678,87310,'2001-10-07','9999-01-01'),
(238726,40000,'1995-05-28','1996-05-27'),
(238726,43741,'1996-05-27','1997-05-27'),
(238726,44930,'1997-05-27','1998-05-27'),
(238726,47122,'1998-05-27','1999-05-27'),
(238726,49167,'1999-05-27','2000-05-26'),
(238726,51917,'2000-05-26','2001-05-26');


INSERT INTO `salaries` VALUES (238726,52869,'2001-05-26','2002-05-26'),
(238726,54198,'2002-05-26','9999-01-01'),
(238849,40000,'1999-11-23','2000-11-22'),
(238849,42649,'2000-11-22','2001-11-22'),
(238849,45454,'2001-11-22','9999-01-01'),
(238924,59777,'1989-06-14','1990-06-14'),
(238924,62399,'1990-06-14','1991-06-14'),
(238924,66494,'1991-06-14','1992-06-13'),
(238924,66143,'1992-06-13','1993-06-13'),
(238924,66303,'1993-06-13','1994-06-13');


INSERT INTO `salaries` VALUES (238924,66627,'1994-06-13','1995-06-13'),
(238924,70723,'1995-06-13','1996-06-12'),
(238924,72781,'1996-06-12','1997-06-12'),
(238924,72686,'1997-06-12','1997-10-09'),
(238942,58236,'1996-03-28','1997-03-28'),
(238942,60396,'1997-03-28','1998-03-28'),
(238942,63792,'1998-03-28','1999-03-28'),
(238942,67881,'1999-03-28','2000-03-27'),
(238942,68816,'2000-03-27','2001-03-27'),
(238942,68905,'2001-03-27','2002-03-27');


INSERT INTO `salaries` VALUES (238942,72434,'2002-03-27','9999-01-01'),
(239017,41849,'1991-12-02','1992-12-01'),
(239017,46115,'1992-12-01','1993-12-01'),
(239017,48095,'1993-12-01','1994-12-01'),
(239017,48933,'1994-12-01','1995-12-01'),
(239017,53205,'1995-12-01','1996-11-30'),
(239017,52858,'1996-11-30','1997-11-30'),
(239017,56204,'1997-11-30','1998-11-30'),
(239017,58862,'1998-11-30','1999-11-30'),
(239017,62320,'1999-11-30','2000-11-29');


INSERT INTO `salaries` VALUES (239017,66012,'2000-11-29','2001-11-29'),
(239017,68762,'2001-11-29','9999-01-01'),
(239018,41535,'1999-06-08','2000-06-07'),
(239018,45766,'2000-06-07','2001-06-07'),
(239018,46129,'2001-06-07','2002-06-07'),
(239018,49893,'2002-06-07','9999-01-01'),
(239156,55789,'1999-09-06','2000-09-05'),
(239156,56395,'2000-09-05','2001-09-05'),
(239156,57979,'2001-09-05','9999-01-01'),
(239234,51024,'1987-01-26','1988-01-26');


INSERT INTO `salaries` VALUES (239234,53215,'1988-01-26','1989-01-25'),
(239234,57371,'1989-01-25','1990-01-25'),
(239234,59671,'1990-01-25','1991-01-25'),
(239234,64065,'1991-01-25','1992-01-25'),
(239234,65255,'1992-01-25','1993-01-24'),
(239234,67147,'1993-01-24','1994-01-24'),
(239234,69052,'1994-01-24','1995-01-24'),
(239234,72424,'1995-01-24','1996-01-24'),
(239234,71941,'1996-01-24','1997-01-23'),
(239234,75918,'1997-01-23','1998-01-23');


INSERT INTO `salaries` VALUES (239234,80317,'1998-01-23','1999-01-23'),
(239234,80874,'1999-01-23','2000-01-23'),
(239234,82325,'2000-01-23','2001-01-22'),
(239234,84313,'2001-01-22','2002-01-22'),
(239234,84807,'2002-01-22','9999-01-01'),
(239243,62560,'1995-09-12','1996-09-11'),
(239243,63483,'1996-09-11','1997-09-11'),
(239243,64532,'1997-09-11','1998-09-11'),
(239243,65194,'1998-09-11','1999-09-11'),
(239243,65577,'1999-09-11','2000-09-10');


INSERT INTO `salaries` VALUES (239243,69082,'2000-09-10','2001-09-10'),
(239243,68690,'2001-09-10','9999-01-01'),
(239859,75225,'1988-10-24','1989-10-24'),
(239859,77037,'1989-10-24','1990-09-11'),
(239869,41698,'1996-06-02','1997-06-02'),
(239869,44806,'1997-06-02','1998-06-02'),
(239869,49085,'1998-06-02','1999-06-02'),
(239869,49441,'1999-06-02','2000-06-01'),
(239869,49602,'2000-06-01','2001-06-01'),
(239869,53266,'2001-06-01','2002-06-01');


INSERT INTO `salaries` VALUES (239869,56387,'2002-06-01','9999-01-01'),
(239949,49293,'1990-11-26','1991-11-26'),
(239949,50796,'1991-11-26','1992-11-25'),
(239949,53049,'1992-11-25','1993-11-25'),
(239949,53853,'1993-11-25','1994-11-25'),
(239949,56476,'1994-11-25','1995-11-25'),
(239949,60130,'1995-11-25','1996-11-24'),
(239949,64093,'1996-11-24','1997-11-24'),
(239949,64243,'1997-11-24','1998-11-24'),
(239949,65230,'1998-11-24','1999-11-24');


INSERT INTO `salaries` VALUES (239949,67110,'1999-11-24','2000-11-23'),
(239949,67133,'2000-11-23','2001-11-23'),
(239949,66892,'2001-11-23','9999-01-01'),
(239990,74832,'1992-09-01','1993-09-01'),
(239990,75544,'1993-09-01','1994-09-01'),
(239990,79280,'1994-09-01','1995-09-01'),
(239990,80249,'1995-09-01','1996-08-31'),
(239990,82725,'1996-08-31','1997-08-31'),
(239990,85084,'1997-08-31','1998-08-31'),
(239990,88607,'1998-08-31','1999-08-31');


INSERT INTO `salaries` VALUES (239990,91658,'1999-08-31','2000-08-30'),
(239990,94907,'2000-08-30','2001-08-30'),
(239990,95189,'2001-08-30','9999-01-01'),
(240051,40000,'1985-05-25','1986-05-25'),
(240051,43272,'1986-05-25','1987-05-25'),
(240051,43776,'1987-05-25','1988-05-24'),
(240051,47421,'1988-05-24','1989-05-24'),
(240051,47799,'1989-05-24','1990-05-24'),
(240051,50517,'1990-05-24','1991-05-24'),
(240051,50749,'1991-05-24','1992-05-23');


INSERT INTO `salaries` VALUES (240051,53956,'1992-05-23','1993-05-23'),
(240051,54848,'1993-05-23','1994-05-23'),
(240051,54484,'1994-05-23','1995-05-23'),
(240051,56693,'1995-05-23','1996-05-22'),
(240051,59253,'1996-05-22','1997-05-22'),
(240051,59205,'1997-05-22','1998-05-22'),
(240051,63158,'1998-05-22','1999-05-22'),
(240051,65818,'1999-05-22','2000-05-21'),
(240051,67451,'2000-05-21','2000-11-16'),
(240349,53973,'1999-06-22','2000-06-21');


INSERT INTO `salaries` VALUES (240349,53840,'2000-06-21','2001-06-21'),
(240349,57343,'2001-06-21','2002-06-21'),
(240349,61027,'2002-06-21','9999-01-01'),
(240692,68011,'1998-08-07','1999-08-07'),
(240692,70726,'1999-08-07','1999-10-13'),
(241277,47793,'1995-11-19','1996-11-18'),
(241277,52144,'1996-11-18','1997-11-18'),
(241277,54562,'1997-11-18','1998-11-18'),
(241277,54514,'1998-11-18','1999-11-18'),
(241277,55625,'1999-11-18','2000-11-17');


INSERT INTO `salaries` VALUES (241277,57487,'2000-11-17','2001-11-17'),
(241277,61513,'2001-11-17','9999-01-01'),
(241506,50900,'1987-09-18','1988-09-17'),
(241506,52999,'1988-09-17','1989-09-17'),
(241506,53628,'1989-09-17','1990-09-17'),
(241506,55767,'1990-09-17','1991-09-17'),
(241506,56224,'1991-09-17','1992-09-16'),
(241506,60466,'1992-09-16','1993-09-16'),
(241506,60110,'1993-09-16','1994-09-16'),
(241506,61644,'1994-09-16','1995-09-16');


INSERT INTO `salaries` VALUES (241506,64749,'1995-09-16','1996-09-15'),
(241506,64573,'1996-09-15','1997-09-15'),
(241506,66213,'1997-09-15','1998-09-15'),
(241506,65945,'1998-09-15','1999-09-15'),
(241506,69741,'1999-09-15','2000-09-14'),
(241506,71798,'2000-09-14','2001-09-14'),
(241506,74803,'2001-09-14','9999-01-01'),
(241576,58598,'1990-09-06','1991-09-06'),
(241576,59877,'1991-09-06','1992-09-05'),
(241576,61234,'1992-09-05','1993-09-05');


INSERT INTO `salaries` VALUES (241576,64311,'1993-09-05','1994-09-05'),
(241576,65402,'1994-09-05','1995-09-05'),
(241576,69161,'1995-09-05','1996-09-04'),
(241576,69699,'1996-09-04','1997-09-04'),
(241576,70007,'1997-09-04','1998-09-04'),
(241576,70520,'1998-09-04','1999-09-04'),
(241576,74496,'1999-09-04','2000-09-03'),
(241576,74446,'2000-09-03','2001-09-03'),
(241576,77411,'2001-09-03','9999-01-01'),
(242014,40000,'1985-03-07','1986-03-07');


INSERT INTO `salaries` VALUES (242014,41585,'1986-03-07','1987-03-07'),
(242014,41711,'1987-03-07','1988-03-06'),
(242014,45489,'1988-03-06','1989-03-06'),
(242014,47054,'1989-03-06','1990-03-06'),
(242014,48403,'1990-03-06','1991-03-06'),
(242014,51468,'1991-03-06','1992-03-05'),
(242014,54530,'1992-03-05','1993-03-05'),
(242014,58220,'1993-03-05','1994-03-05'),
(242014,59707,'1994-03-05','1995-03-05'),
(242014,61914,'1995-03-05','1996-03-04');


INSERT INTO `salaries` VALUES (242014,61427,'1996-03-04','1997-03-04'),
(242014,63505,'1997-03-04','1998-03-04'),
(242014,64134,'1998-03-04','1999-03-04'),
(242014,66521,'1999-03-04','2000-03-03'),
(242014,70788,'2000-03-03','2001-03-03'),
(242014,70566,'2001-03-03','2002-03-03'),
(242014,74695,'2002-03-03','9999-01-01'),
(242432,66714,'1985-10-29','1986-10-29'),
(242432,66814,'1986-10-29','1987-10-29'),
(242432,68961,'1987-10-29','1988-10-28');


INSERT INTO `salaries` VALUES (242432,71818,'1988-10-28','1989-10-28'),
(242432,74676,'1989-10-28','1990-10-28'),
(242432,75288,'1990-10-28','1991-10-28'),
(242432,77795,'1991-10-28','1992-10-27'),
(242432,78029,'1992-10-27','1993-10-27'),
(242432,81681,'1993-10-27','1994-10-27'),
(242432,81933,'1994-10-27','1995-10-27'),
(242432,85099,'1995-10-27','1996-10-26'),
(242432,88375,'1996-10-26','1997-10-26'),
(242432,88158,'1997-10-26','1998-10-26');


INSERT INTO `salaries` VALUES (242432,89288,'1998-10-26','1999-10-26'),
(242432,89221,'1999-10-26','2000-10-25'),
(242432,92389,'2000-10-25','2001-10-25'),
(242432,92926,'2001-10-25','9999-01-01'),
(242711,71079,'1992-01-04','1993-01-03'),
(242711,70837,'1993-01-03','1994-01-03'),
(242711,73259,'1994-01-03','1995-01-03'),
(242711,72976,'1995-01-03','1996-01-03'),
(242711,77341,'1996-01-03','1997-01-02'),
(242711,78239,'1997-01-02','1998-01-02');


INSERT INTO `salaries` VALUES (242711,80661,'1998-01-02','1999-01-02'),
(242711,81708,'1999-01-02','2000-01-02'),
(242711,81263,'2000-01-02','2001-01-01'),
(242711,83121,'2001-01-01','2002-01-01'),
(242711,83884,'2002-01-01','9999-01-01'),
(242764,43629,'1998-11-09','1999-11-09'),
(242764,47602,'1999-11-09','2000-11-08'),
(242764,51170,'2000-11-08','2001-11-08'),
(242764,54294,'2001-11-08','9999-01-01'),
(243072,56072,'1991-10-24','1992-10-23');


INSERT INTO `salaries` VALUES (243072,59193,'1992-10-23','1993-10-23'),
(243072,62396,'1993-10-23','1994-10-23'),
(243072,65109,'1994-10-23','1995-10-23'),
(243072,67757,'1995-10-23','1996-10-22'),
(243072,69262,'1996-10-22','1997-10-22'),
(243072,70847,'1997-10-22','1998-10-22'),
(243072,71950,'1998-10-22','1999-10-22'),
(243072,72402,'1999-10-22','2000-10-21'),
(243072,72153,'2000-10-21','2001-10-21'),
(243072,75410,'2001-10-21','9999-01-01');


INSERT INTO `salaries` VALUES (243329,52002,'1992-03-07','1993-03-07'),
(243329,52370,'1993-03-07','1994-03-07'),
(243329,52774,'1994-03-07','1995-03-07'),
(243329,52860,'1995-03-07','1996-03-06'),
(243329,54643,'1996-03-06','1997-03-06'),
(243329,58263,'1997-03-06','1998-03-06'),
(243329,62033,'1998-03-06','1999-03-06'),
(243329,63043,'1999-03-06','2000-03-05'),
(243329,63599,'2000-03-05','2001-03-05'),
(243329,66042,'2001-03-05','2001-09-07');


INSERT INTO `salaries` VALUES (243794,44401,'1989-11-25','1990-11-25'),
(243794,48601,'1990-11-25','1991-11-25'),
(243794,51078,'1991-11-25','1992-11-24'),
(243794,55300,'1992-11-24','1993-11-24'),
(243794,55293,'1993-11-24','1994-11-24'),
(243794,55855,'1994-11-24','1995-11-24'),
(243794,57731,'1995-11-24','1996-11-23'),
(243794,58734,'1996-11-23','1997-01-26'),
(243944,40000,'1987-09-11','1988-09-10'),
(243944,41294,'1988-09-10','1989-09-10');


INSERT INTO `salaries` VALUES (243944,45206,'1989-09-10','1990-09-10'),
(243944,49638,'1990-09-10','1991-09-10'),
(243944,49772,'1991-09-10','1992-09-09'),
(243944,52445,'1992-09-09','1993-09-09'),
(243944,53079,'1993-09-09','1994-09-09'),
(243944,54035,'1994-09-09','1995-09-09'),
(243944,57558,'1995-09-09','1996-09-08'),
(243944,59791,'1996-09-08','1997-09-08'),
(243944,60455,'1997-09-08','1998-09-08'),
(243944,61419,'1998-09-08','1999-09-08');


INSERT INTO `salaries` VALUES (243944,65024,'1999-09-08','2000-09-07'),
(243944,68259,'2000-09-07','2001-09-07'),
(243944,72571,'2001-09-07','9999-01-01'),
(244170,74094,'1989-12-20','1990-12-20'),
(244170,74156,'1990-12-20','1991-12-20'),
(244170,77113,'1991-12-20','1992-12-19'),
(244170,78733,'1992-12-19','1993-12-19'),
(244170,79181,'1993-12-19','1994-12-19'),
(244170,80601,'1994-12-19','1995-05-18'),
(244809,95417,'1998-12-06','1999-12-06');


INSERT INTO `salaries` VALUES (244809,96097,'1999-12-06','2000-12-05'),
(244809,97065,'2000-12-05','2001-12-05'),
(244809,98133,'2001-12-05','9999-01-01'),
(244820,54013,'1987-04-13','1988-04-12'),
(244820,56341,'1988-04-12','1989-04-12'),
(244820,57128,'1989-04-12','1990-04-12'),
(244820,58487,'1990-04-12','1991-04-12'),
(244820,60416,'1991-04-12','1992-04-11'),
(244820,61645,'1992-04-11','1993-04-11'),
(244820,63803,'1993-04-11','1994-04-11');


INSERT INTO `salaries` VALUES (244820,63476,'1994-04-11','1995-04-11'),
(244820,67847,'1995-04-11','1996-04-10'),
(244820,71571,'1996-04-10','1997-04-10'),
(244820,73499,'1997-04-10','1998-04-10'),
(244820,73201,'1998-04-10','1999-04-10'),
(244820,74547,'1999-04-10','2000-04-09'),
(244820,75507,'2000-04-09','2001-04-09'),
(244820,79025,'2001-04-09','2002-04-09'),
(244820,80360,'2002-04-09','9999-01-01'),
(244941,56163,'1990-03-17','1991-03-17');


INSERT INTO `salaries` VALUES (244941,56430,'1991-03-17','1992-03-16'),
(244941,58875,'1992-03-16','1993-03-16'),
(244941,61849,'1993-03-16','1994-03-16'),
(244941,64460,'1994-03-16','1995-03-16'),
(244941,66934,'1995-03-16','1996-03-15'),
(244941,68855,'1996-03-15','1997-03-15'),
(244941,71447,'1997-03-15','1998-03-15'),
(244941,71385,'1998-03-15','1999-03-15'),
(244941,74412,'1999-03-15','2000-03-14'),
(244941,74982,'2000-03-14','2001-03-14');


INSERT INTO `salaries` VALUES (244941,76757,'2001-03-14','2002-03-14'),
(244941,80542,'2002-03-14','9999-01-01'),
(245036,61771,'1990-03-21','1991-03-21'),
(245036,65822,'1991-03-21','1992-03-20'),
(245036,69419,'1992-03-20','1993-03-20'),
(245036,69434,'1993-03-20','1994-03-20'),
(245036,72446,'1994-03-20','1995-03-20'),
(245036,74333,'1995-03-20','1996-03-19'),
(245036,75450,'1996-03-19','1997-03-19'),
(245036,79713,'1997-03-19','1998-03-19');


INSERT INTO `salaries` VALUES (245036,82962,'1998-03-19','1999-03-19'),
(245036,86761,'1999-03-19','2000-03-18'),
(245036,86893,'2000-03-18','2001-03-18'),
(245036,86604,'2001-03-18','2002-03-18'),
(245036,89008,'2002-03-18','9999-01-01'),
(245367,70717,'1993-10-27','1994-10-27'),
(245367,72606,'1994-10-27','1995-10-27'),
(245367,73812,'1995-10-27','1996-10-26'),
(245367,76649,'1996-10-26','1997-10-26'),
(245367,79285,'1997-10-26','1998-10-25');


INSERT INTO `salaries` VALUES (245367,79371,'1998-10-25','1999-10-26'),
(245367,79849,'1999-10-26','2000-10-25'),
(245367,81963,'2000-10-25','2001-10-25'),
(245367,84036,'2001-10-25','9999-01-01'),
(245660,62897,'1989-02-06','1990-02-06'),
(245660,64305,'1990-02-06','1991-02-06'),
(245660,67083,'1991-02-06','1992-02-06'),
(245660,69221,'1992-02-06','1993-02-05'),
(245660,69300,'1993-02-05','1994-02-05'),
(245660,68960,'1994-02-05','1995-02-05');


INSERT INTO `salaries` VALUES (245660,68758,'1995-02-05','1996-02-05'),
(245660,71247,'1996-02-05','1997-02-04'),
(245660,71116,'1997-02-04','1998-02-04'),
(245660,72997,'1998-02-04','1999-02-04'),
(245660,75783,'1999-02-04','2000-02-04'),
(245660,77741,'2000-02-04','2001-02-03'),
(245660,79028,'2001-02-03','2002-02-03'),
(245660,80667,'2002-02-03','9999-01-01'),
(245714,54759,'1987-02-23','1988-02-23'),
(245714,57190,'1988-02-23','1989-02-22');


INSERT INTO `salaries` VALUES (245714,61486,'1989-02-22','1990-02-22'),
(245714,65500,'1990-02-22','1991-02-22'),
(245714,69699,'1991-02-22','1992-02-22'),
(245714,73878,'1992-02-22','1993-02-21'),
(245714,77980,'1993-02-21','1994-02-21'),
(245714,79008,'1994-02-21','1995-02-21'),
(245714,82409,'1995-02-21','1996-02-21'),
(245714,81926,'1996-02-21','1997-02-20'),
(245714,85341,'1997-02-20','1998-02-20'),
(245714,85713,'1998-02-20','1999-02-20');


INSERT INTO `salaries` VALUES (245714,87397,'1999-02-20','2000-02-20'),
(245714,90207,'2000-02-20','2001-02-19'),
(245714,93436,'2001-02-19','2002-02-19'),
(245714,96416,'2002-02-19','9999-01-01'),
(245810,40000,'1986-03-08','1987-03-08'),
(245810,39804,'1987-03-08','1988-03-07'),
(245810,40817,'1988-03-07','1989-03-07'),
(245810,41348,'1989-03-07','1990-03-07'),
(245810,43997,'1990-03-07','1991-03-07'),
(245810,43729,'1991-03-07','1992-03-06');


INSERT INTO `salaries` VALUES (245810,43588,'1992-03-06','1993-03-06'),
(245810,43406,'1993-03-06','1994-03-06'),
(245810,45662,'1994-03-06','1995-03-06'),
(245810,47176,'1995-03-06','1996-03-05'),
(245810,48084,'1996-03-05','1997-03-05'),
(245810,50249,'1997-03-05','1998-03-05'),
(245810,50335,'1998-03-05','1999-03-05'),
(245810,52847,'1999-03-05','2000-03-04'),
(245810,52663,'2000-03-04','2001-03-04'),
(245810,55345,'2001-03-04','2002-03-04');


INSERT INTO `salaries` VALUES (245810,58189,'2002-03-04','9999-01-01'),
(245828,70781,'1997-09-26','1998-09-26'),
(245828,75081,'1998-09-26','1999-09-26'),
(245828,77070,'1999-09-26','2000-09-25'),
(245828,79531,'2000-09-25','2001-09-25'),
(245828,82908,'2001-09-25','9999-01-01'),
(245862,67900,'1998-06-19','1999-06-19'),
(245862,72186,'1999-06-19','2000-06-18'),
(245862,74731,'2000-06-18','2001-06-18'),
(245862,74349,'2001-06-18','2002-06-18');


INSERT INTO `salaries` VALUES (245862,75703,'2002-06-18','9999-01-01'),
(245978,40000,'1993-06-24','1994-06-24'),
(245978,41792,'1994-06-24','1995-06-24'),
(245978,45837,'1995-06-24','1996-06-23'),
(245978,45839,'1996-06-23','1997-06-23'),
(245978,50168,'1997-06-23','1998-06-23'),
(245978,53585,'1998-06-23','1999-06-23'),
(245978,57643,'1999-06-23','2000-06-22'),
(245978,60118,'2000-06-22','2001-06-22'),
(245978,61525,'2001-06-22','2002-06-22');


INSERT INTO `salaries` VALUES (245978,63318,'2002-06-22','9999-01-01'),
(246013,100771,'1987-10-28','1988-10-27'),
(246013,104659,'1988-10-27','1989-10-27'),
(246013,105923,'1989-10-27','1990-10-27'),
(246013,109484,'1990-10-27','1991-10-27'),
(246013,112377,'1991-10-27','1992-10-26'),
(246013,115290,'1992-10-26','1993-10-26'),
(246013,114790,'1993-10-26','1994-10-26'),
(246013,114427,'1994-10-26','1995-10-26'),
(246013,116276,'1995-10-26','1996-10-25');


INSERT INTO `salaries` VALUES (246013,117061,'1996-10-25','1997-10-25'),
(246013,118427,'1997-10-25','1998-10-25'),
(246013,120001,'1998-10-25','1999-10-25'),
(246013,119555,'1999-10-25','2000-10-24'),
(246013,122112,'2000-10-24','2001-10-24'),
(246013,122916,'2001-10-24','9999-01-01'),
(246044,49858,'1992-10-09','1993-10-09'),
(246044,51665,'1993-10-09','1994-10-09'),
(246044,55920,'1994-10-09','1995-10-09'),
(246044,57017,'1995-10-09','1996-10-08');


INSERT INTO `salaries` VALUES (246044,59984,'1996-10-08','1997-10-08'),
(246044,63375,'1997-10-08','1998-10-08'),
(246044,67314,'1998-10-08','1999-10-08'),
(246044,67370,'1999-10-08','2000-10-07'),
(246044,69974,'2000-10-07','2001-10-07'),
(246044,71915,'2001-10-07','9999-01-01'),
(246214,52829,'1997-05-22','1998-05-22'),
(246214,54727,'1998-05-22','1999-05-22'),
(246214,54331,'1999-05-22','2000-05-21'),
(246214,57848,'2000-05-21','2001-05-21');


INSERT INTO `salaries` VALUES (246214,58239,'2001-05-21','2002-05-21'),
(246214,59884,'2002-05-21','9999-01-01'),
(246317,63701,'1995-12-26','1996-12-25'),
(246317,67453,'1996-12-25','1997-12-25'),
(246317,69076,'1997-12-25','1998-12-25'),
(246317,72701,'1998-12-25','1999-12-25'),
(246317,74932,'1999-12-25','2000-12-24'),
(246317,77685,'2000-12-24','2001-12-24'),
(246317,77762,'2001-12-24','9999-01-01'),
(246597,54591,'1996-01-09','1997-01-08');


INSERT INTO `salaries` VALUES (246597,57629,'1997-01-08','1998-01-08'),
(246597,58088,'1998-01-08','1999-01-08'),
(246597,57914,'1999-01-08','2000-01-08'),
(246597,58338,'2000-01-08','2001-01-07'),
(246597,60485,'2001-01-07','2002-01-07'),
(246597,60989,'2002-01-07','9999-01-01'),
(247697,40000,'1992-11-27','1993-11-27'),
(247697,41961,'1993-11-27','1994-11-27'),
(247697,41770,'1994-11-27','1995-11-11'),
(248201,40000,'1991-04-01','1992-03-31');


INSERT INTO `salaries` VALUES (248201,43300,'1992-03-31','1993-03-31'),
(248201,43077,'1993-03-31','1994-03-31'),
(248201,44212,'1994-03-31','1995-03-31'),
(248201,48198,'1995-03-31','1996-03-30'),
(248201,49369,'1996-03-30','1997-03-30'),
(248201,49409,'1997-03-30','1998-03-30'),
(248201,53521,'1998-03-30','1999-03-30'),
(248201,57556,'1999-03-30','2000-03-29'),
(248201,58939,'2000-03-29','2001-03-29'),
(248201,61588,'2001-03-29','2002-03-29');


INSERT INTO `salaries` VALUES (248201,64199,'2002-03-29','9999-01-01'),
(248265,43835,'1999-09-22','2000-09-21'),
(248265,48019,'2000-09-21','2001-02-15'),
(248348,46660,'1988-10-28','1989-10-28'),
(248348,49940,'1989-10-28','1990-10-28'),
(248348,53642,'1990-10-28','1991-10-27'),
(248348,56377,'1991-10-27','1992-10-26'),
(248348,56677,'1992-10-26','1993-10-27'),
(248348,57745,'1993-10-27','1994-10-27'),
(248348,57733,'1994-10-27','1995-10-27');


INSERT INTO `salaries` VALUES (248348,58402,'1995-10-27','1996-10-26'),
(248348,61352,'1996-10-26','1997-10-26'),
(248348,63766,'1997-10-26','1998-10-25'),
(248348,64151,'1998-10-25','1999-10-26'),
(248348,66410,'1999-10-26','2000-10-25'),
(248348,70827,'2000-10-25','2001-10-25'),
(248348,75115,'2001-10-25','9999-01-01'),
(248761,40000,'1994-06-13','1995-06-13'),
(248761,44147,'1995-06-13','1996-06-12'),
(248761,48220,'1996-06-12','1997-06-12');


INSERT INTO `salaries` VALUES (248761,50682,'1997-06-12','1998-06-12'),
(248761,53295,'1998-06-12','1999-06-12'),
(248761,57213,'1999-06-12','2000-06-11'),
(248761,57879,'2000-06-11','2001-06-11'),
(248761,61032,'2001-06-11','2002-06-11'),
(248761,61311,'2002-06-11','9999-01-01'),
(249051,40000,'1993-03-13','1994-03-13'),
(249051,43180,'1994-03-13','1995-03-13'),
(249051,44640,'1995-03-13','1996-03-12'),
(249051,47873,'1996-03-12','1997-03-12');


INSERT INTO `salaries` VALUES (249051,50987,'1997-03-12','1998-03-12'),
(249051,51705,'1998-03-12','1999-03-12'),
(249051,53812,'1999-03-12','2000-03-11'),
(249051,53691,'2000-03-11','2001-03-11'),
(249051,53605,'2001-03-11','2002-03-11'),
(249051,56845,'2002-03-11','9999-01-01'),
(249391,40000,'1998-02-12','1999-02-12'),
(249391,40776,'1999-02-12','2000-02-12'),
(249391,42072,'2000-02-12','2001-02-11'),
(249391,45012,'2001-02-11','2002-02-11');


INSERT INTO `salaries` VALUES (249391,46028,'2002-02-11','9999-01-01'),
(249528,40000,'1988-05-23','1989-05-23'),
(249528,41646,'1989-05-23','1990-05-23'),
(249528,44721,'1990-05-23','1991-05-23'),
(249528,46395,'1991-05-23','1992-05-22'),
(249528,49581,'1992-05-22','1993-05-22'),
(249528,50998,'1993-05-22','1994-05-22'),
(249528,53665,'1994-05-22','1995-05-22'),
(249528,56871,'1995-05-22','1996-05-21'),
(249528,59378,'1996-05-21','1997-05-21');


INSERT INTO `salaries` VALUES (249528,62284,'1997-05-21','1998-05-21'),
(249528,62192,'1998-05-21','1999-05-21'),
(249528,64139,'1999-05-21','2000-05-20'),
(249528,67341,'2000-05-20','2001-05-20'),
(249528,67534,'2001-05-20','2002-05-20'),
(249528,71915,'2002-05-20','9999-01-01'),
(249779,62224,'1990-01-16','1991-01-16'),
(249779,62130,'1991-01-16','1992-01-16'),
(249779,63006,'1992-01-16','1993-01-15'),
(249779,64824,'1993-01-15','1994-01-15');


INSERT INTO `salaries` VALUES (249779,67734,'1994-01-15','1995-01-15'),
(249779,71038,'1995-01-15','1996-01-15'),
(249779,73591,'1996-01-15','1997-01-14'),
(249779,74854,'1997-01-14','1998-01-14'),
(249779,77661,'1998-01-14','1999-01-14'),
(249779,80125,'1999-01-14','2000-01-14'),
(249779,82826,'2000-01-14','2001-01-13'),
(249779,85675,'2001-01-13','2002-01-13'),
(249779,89946,'2002-01-13','9999-01-01'),
(250401,56998,'1992-12-14','1993-12-14');


INSERT INTO `salaries` VALUES (250401,57102,'1993-12-14','1994-12-14'),
(250401,57943,'1994-12-14','1995-12-14'),
(250401,60504,'1995-12-14','1996-12-13'),
(250401,60435,'1996-12-13','1997-01-23'),
(250645,68876,'1989-07-28','1990-07-28'),
(250645,69187,'1990-07-28','1991-07-28'),
(250645,73214,'1991-07-28','1992-07-27'),
(250645,75142,'1992-07-27','1993-07-27'),
(250645,78924,'1993-07-27','1994-07-27'),
(250645,79790,'1994-07-27','1995-07-27');


INSERT INTO `salaries` VALUES (250645,82706,'1995-07-27','1996-07-26'),
(250645,86213,'1996-07-26','1997-07-26'),
(250645,88184,'1997-07-26','1998-07-26'),
(250645,88671,'1998-07-26','1999-07-26'),
(250645,89161,'1999-07-26','2000-07-25'),
(250645,92216,'2000-07-25','2001-07-25'),
(250645,92220,'2001-07-25','2002-07-25'),
(250645,94684,'2002-07-25','9999-01-01'),
(250986,40000,'1989-02-25','1990-02-25'),
(250986,41132,'1990-02-25','1991-02-25');


INSERT INTO `salaries` VALUES (250986,45086,'1991-02-25','1992-02-25'),
(250986,48263,'1992-02-25','1993-02-24'),
(250986,52026,'1993-02-24','1994-02-24'),
(250986,54221,'1994-02-24','1995-02-24'),
(250986,56882,'1995-02-24','1996-02-24'),
(250986,58575,'1996-02-24','1997-02-23'),
(250986,62629,'1997-02-23','1998-02-23'),
(250986,63743,'1998-02-23','1999-02-23'),
(250986,65548,'1999-02-23','2000-02-23'),
(250986,65353,'2000-02-23','2001-02-22');


INSERT INTO `salaries` VALUES (250986,67551,'2001-02-22','2002-02-22'),
(250986,70984,'2002-02-22','9999-01-01'),
(251025,41778,'1996-05-29','1997-05-29'),
(251025,44988,'1997-05-29','1998-05-29'),
(251025,44878,'1998-05-29','1999-05-29'),
(251025,44983,'1999-05-29','2000-05-28'),
(251025,46026,'2000-05-28','2001-05-28'),
(251025,46031,'2001-05-28','2002-05-28'),
(251025,45902,'2002-05-28','9999-01-01'),
(251085,40000,'1987-09-14','1988-09-13');


INSERT INTO `salaries` VALUES (251085,43855,'1988-09-13','1989-09-13'),
(251085,46461,'1989-09-13','1990-09-13'),
(251085,46273,'1990-09-13','1991-09-13'),
(251085,47860,'1991-09-13','1992-09-12'),
(251085,51044,'1992-09-12','1993-09-12'),
(251085,55184,'1993-09-12','1994-09-12'),
(251085,59303,'1994-09-12','1995-09-12'),
(251085,60092,'1995-09-12','1996-09-11'),
(251085,63715,'1996-09-11','1997-09-11'),
(251085,64516,'1997-09-11','1998-09-11');


INSERT INTO `salaries` VALUES (251085,67749,'1998-09-11','1999-09-11'),
(251085,67256,'1999-09-11','2000-09-10'),
(251085,70885,'2000-09-10','2001-09-10'),
(251085,70524,'2001-09-10','9999-01-01'),
(251291,58538,'1986-06-19','1987-06-19'),
(251291,59744,'1987-06-19','1988-06-18'),
(251291,60162,'1988-06-18','1989-06-18'),
(251291,64625,'1989-06-18','1990-06-18'),
(251291,67437,'1990-06-18','1991-06-18'),
(251291,69984,'1991-06-18','1992-06-17');


INSERT INTO `salaries` VALUES (251291,69815,'1992-06-17','1993-06-17'),
(251291,69331,'1993-06-17','1994-06-17'),
(251291,72782,'1994-06-17','1995-06-17'),
(251291,75671,'1995-06-17','1996-06-16'),
(251291,78847,'1996-06-16','1997-06-16'),
(251291,82779,'1997-06-16','1998-06-16'),
(251291,84762,'1998-06-16','1999-06-16'),
(251291,84959,'1999-06-16','2000-06-15'),
(251291,86492,'2000-06-15','2001-03-01'),
(251698,50244,'1995-04-13','1996-04-12');


INSERT INTO `salaries` VALUES (251698,54631,'1996-04-12','1997-04-12'),
(251698,55198,'1997-04-12','1998-04-12'),
(251698,56229,'1998-04-12','1999-04-12'),
(251698,55791,'1999-04-12','2000-04-11'),
(251698,56270,'2000-04-11','2001-04-11'),
(251698,56737,'2001-04-11','2002-04-11'),
(251698,56847,'2002-04-11','9999-01-01'),
(252679,40000,'1985-09-21','1986-09-21'),
(252679,43929,'1986-09-21','1987-09-21'),
(252679,43711,'1987-09-21','1988-09-20');


INSERT INTO `salaries` VALUES (252679,44256,'1988-09-20','1989-09-20'),
(252679,46240,'1989-09-20','1990-09-20'),
(252679,46308,'1990-09-20','1991-09-20'),
(252679,48507,'1991-09-20','1992-09-19'),
(252679,48747,'1992-09-19','1993-09-19'),
(252679,53170,'1993-09-19','1994-09-19'),
(252679,56730,'1994-09-19','1995-09-19'),
(252679,60174,'1995-09-19','1996-09-18'),
(252679,64361,'1996-09-18','1997-09-18'),
(252679,64558,'1997-09-18','1998-09-18');


INSERT INTO `salaries` VALUES (252679,64925,'1998-09-18','1999-09-18'),
(252679,64784,'1999-09-18','2000-09-17'),
(252679,66470,'2000-09-17','2001-09-17'),
(252679,69874,'2001-09-17','9999-01-01'),
(252995,55140,'1999-01-18','2000-01-18'),
(252995,55799,'2000-01-18','2001-01-17'),
(252995,58448,'2001-01-17','2002-01-17'),
(252995,58511,'2002-01-17','9999-01-01'),
(253139,40000,'1997-06-24','1998-06-24'),
(253139,43296,'1998-06-24','1999-06-24');


INSERT INTO `salaries` VALUES (253139,46517,'1999-06-24','2000-06-23'),
(253139,48868,'2000-06-23','2001-06-23'),
(253139,52438,'2001-06-23','2002-06-23'),
(253139,54005,'2002-06-23','9999-01-01'),
(253685,60664,'1999-03-19','2000-03-18'),
(253685,61719,'2000-03-18','2001-03-18'),
(253685,65218,'2001-03-18','2002-03-18'),
(253685,66776,'2002-03-18','9999-01-01'),
(253785,56646,'1987-02-16','1988-02-16'),
(253785,60910,'1988-02-16','1989-02-15');


INSERT INTO `salaries` VALUES (253785,61117,'1989-02-15','1990-02-15'),
(253785,65481,'1990-02-15','1991-02-15'),
(253785,66393,'1991-02-15','1992-02-15'),
(253785,68805,'1992-02-15','1993-02-14'),
(253785,68630,'1993-02-14','1994-02-14'),
(253785,69958,'1994-02-14','1995-02-14'),
(253785,69709,'1995-02-14','1996-02-14'),
(253785,69645,'1996-02-14','1997-02-13'),
(253785,71940,'1997-02-13','1998-02-13'),
(253785,73385,'1998-02-13','1999-02-13');


INSERT INTO `salaries` VALUES (253785,75595,'1999-02-13','2000-02-13'),
(253785,77433,'2000-02-13','2001-02-12'),
(253785,79648,'2001-02-12','2002-02-12'),
(253785,81716,'2002-02-12','9999-01-01'),
(253854,65647,'1992-06-21','1993-06-21'),
(253854,67867,'1993-06-21','1994-06-21'),
(253854,71532,'1994-06-21','1995-06-21'),
(253854,75091,'1995-06-21','1996-06-20'),
(253854,78509,'1996-06-20','1997-06-20'),
(253854,82986,'1997-06-20','1998-06-20');


INSERT INTO `salaries` VALUES (253854,83436,'1998-06-20','1999-06-20'),
(253854,83410,'1999-06-20','2000-06-19'),
(253854,82951,'2000-06-19','2001-06-19'),
(253854,84095,'2001-06-19','2001-10-29'),
(254240,50707,'1995-12-18','1996-12-17'),
(254240,52262,'1996-12-17','1997-12-17'),
(254240,56705,'1997-12-17','1998-12-17'),
(254240,57346,'1998-12-17','1999-12-17'),
(254240,57172,'1999-12-17','2000-12-16'),
(254240,59454,'2000-12-16','2001-12-16');


INSERT INTO `salaries` VALUES (254240,59260,'2001-12-16','9999-01-01'),
(254984,50682,'1993-01-13','1994-01-13'),
(254984,55161,'1994-01-13','1995-01-13'),
(254984,56415,'1995-01-13','1996-01-13'),
(254984,56032,'1996-01-13','1997-01-12'),
(254984,57580,'1997-01-12','1998-01-12'),
(254984,60011,'1998-01-12','1999-01-12'),
(254984,62176,'1999-01-12','2000-01-12'),
(254984,62685,'2000-01-12','2001-01-11'),
(254984,63882,'2001-01-11','2002-01-11');


INSERT INTO `salaries` VALUES (254984,63872,'2002-01-11','9999-01-01'),
(255294,40000,'1998-02-26','1999-02-26'),
(255294,39836,'1999-02-26','2000-02-26'),
(255294,41358,'2000-02-26','2001-02-25'),
(255294,41091,'2001-02-25','2002-02-25'),
(255294,45590,'2002-02-25','9999-01-01'),
(255536,61745,'1991-12-10','1992-12-09'),
(255536,64453,'1992-12-09','1993-12-09'),
(255536,66752,'1993-12-09','1994-12-09'),
(255536,70183,'1994-12-09','1995-12-09');


INSERT INTO `salaries` VALUES (255536,73102,'1995-12-09','1996-12-08'),
(255536,76393,'1996-12-08','1997-12-08'),
(255536,79041,'1997-12-08','1998-12-08'),
(255536,79396,'1998-12-08','1999-12-08'),
(255536,80969,'1999-12-08','2000-12-07'),
(255536,83935,'2000-12-07','2001-12-07'),
(255536,87222,'2001-12-07','9999-01-01'),
(255874,53049,'1994-06-25','1995-06-25'),
(255874,57036,'1995-06-25','1996-06-24'),
(255874,58282,'1996-06-24','1997-06-24');


INSERT INTO `salaries` VALUES (255874,58945,'1997-06-24','1998-06-24'),
(255874,61555,'1998-06-24','1999-06-24'),
(255874,62947,'1999-06-24','2000-06-23'),
(255874,64929,'2000-06-23','2001-06-23'),
(255874,65722,'2001-06-23','2002-06-23'),
(255874,68010,'2002-06-23','9999-01-01'),
(256447,54863,'1989-07-30','1990-07-30'),
(256447,55738,'1990-07-30','1991-07-30'),
(256447,55799,'1991-07-30','1992-07-29'),
(256447,58660,'1992-07-29','1993-07-29');


INSERT INTO `salaries` VALUES (256447,61549,'1993-07-29','1994-07-29'),
(256447,62740,'1994-07-29','1995-07-29'),
(256447,65587,'1995-07-29','1996-07-28'),
(256447,69208,'1996-07-28','1997-07-28'),
(256447,72543,'1997-07-28','1998-07-28'),
(256447,76035,'1998-07-28','1999-07-28'),
(256447,79726,'1999-07-28','2000-07-27'),
(256447,79591,'2000-07-27','2001-07-27'),
(256447,83852,'2001-07-27','2002-07-27'),
(256447,85349,'2002-07-27','9999-01-01');


INSERT INTO `salaries` VALUES (256505,40000,'1999-05-14','2000-05-13'),
(256505,42742,'2000-05-13','2001-05-13'),
(256505,42991,'2001-05-13','2001-05-25'),
(256535,40000,'1987-12-15','1988-12-14'),
(256535,42248,'1988-12-14','1989-12-14'),
(256535,43688,'1989-12-14','1990-12-14'),
(256535,43983,'1990-12-14','1991-12-14'),
(256535,44787,'1991-12-14','1992-12-13'),
(256535,47791,'1992-12-13','1993-12-13'),
(256535,48693,'1993-12-13','1994-12-13');


INSERT INTO `salaries` VALUES (256535,49736,'1994-12-13','1995-12-13'),
(256535,51102,'1995-12-13','1996-12-12'),
(256535,51066,'1996-12-12','1997-12-12'),
(256535,51855,'1997-12-12','1998-12-12'),
(256535,54753,'1998-12-12','1999-12-12'),
(256535,57885,'1999-12-12','2000-12-11'),
(256535,58821,'2000-12-11','2001-12-11'),
(256535,58550,'2001-12-11','9999-01-01'),
(256936,40000,'1986-10-02','1987-10-02'),
(256936,43926,'1987-10-02','1988-10-01');


INSERT INTO `salaries` VALUES (256936,48101,'1988-10-01','1989-10-01'),
(256936,52333,'1989-10-01','1990-10-01'),
(256936,53736,'1990-10-01','1991-10-01'),
(256936,53941,'1991-10-01','1992-09-30'),
(256936,53897,'1992-09-30','1993-09-30'),
(256936,54693,'1993-09-30','1994-09-30'),
(256936,56517,'1994-09-30','1995-09-30'),
(256936,59153,'1995-09-30','1996-09-29'),
(256936,62869,'1996-09-29','1997-09-29'),
(256936,64752,'1997-09-29','1998-09-29');


INSERT INTO `salaries` VALUES (256936,66678,'1998-09-29','1999-09-29'),
(256936,70942,'1999-09-29','2000-09-28'),
(256936,73502,'2000-09-28','2001-09-28'),
(256936,77817,'2001-09-28','9999-01-01'),
(256982,80168,'1988-06-18','1989-06-18'),
(256982,84620,'1989-06-18','1990-06-18'),
(256982,87653,'1990-06-18','1991-06-18'),
(256982,89010,'1991-06-18','1992-06-17'),
(256982,90668,'1992-06-17','1993-06-17'),
(256982,94962,'1993-06-17','1994-06-17');


INSERT INTO `salaries` VALUES (256982,97633,'1994-06-17','1995-06-17'),
(256982,98450,'1995-06-17','1996-06-16'),
(256982,101848,'1996-06-16','1997-06-16'),
(256982,103258,'1997-06-16','1998-06-16'),
(256982,104784,'1998-06-16','1999-06-16'),
(256982,105160,'1999-06-16','2000-06-15'),
(256982,106603,'2000-06-15','2001-06-15'),
(256982,109688,'2001-06-15','2002-06-15'),
(256982,109355,'2002-06-15','9999-01-01'),
(257260,46936,'1998-07-04','1999-07-04');


INSERT INTO `salaries` VALUES (257260,47998,'1999-07-04','2000-07-03'),
(257260,48130,'2000-07-03','2001-07-03'),
(257260,48443,'2001-07-03','2002-07-03'),
(257260,51853,'2002-07-03','9999-01-01'),
(257431,69841,'1992-12-06','1993-12-06'),
(257431,70619,'1993-12-06','1994-12-06'),
(257431,73329,'1994-12-06','1995-04-16'),
(257760,51872,'1987-07-21','1988-07-20'),
(257760,53134,'1988-07-20','1989-07-20'),
(257760,56000,'1989-07-20','1989-12-15');


INSERT INTO `salaries` VALUES (258092,40000,'1999-08-23','2000-08-22'),
(258092,43387,'2000-08-22','2001-08-22'),
(258092,47025,'2001-08-22','9999-01-01'),
(258451,57052,'1990-02-09','1991-02-09'),
(258451,60116,'1991-02-09','1992-02-09'),
(258451,63421,'1992-02-09','1993-02-08'),
(258451,63233,'1993-02-08','1994-02-08'),
(258451,66174,'1994-02-08','1995-02-08'),
(258451,69144,'1995-02-08','1996-02-08'),
(258451,70999,'1996-02-08','1997-02-07');


INSERT INTO `salaries` VALUES (258451,75011,'1997-02-07','1998-02-07'),
(258451,78613,'1998-02-07','1999-02-07'),
(258451,82398,'1999-02-07','2000-02-07'),
(258451,84750,'2000-02-07','2001-02-06'),
(258451,88462,'2001-02-06','2002-02-06'),
(258451,90934,'2002-02-06','9999-01-01'),
(258582,64307,'1995-04-03','1996-04-01'),
(258582,68222,'1996-04-01','1997-04-01'),
(258582,71462,'1997-04-01','1998-04-01'),
(258582,72265,'1998-04-01','1999-04-01');


INSERT INTO `salaries` VALUES (258582,75011,'1999-04-01','2000-03-31'),
(258582,74672,'2000-03-31','2001-03-31'),
(258582,77193,'2001-03-31','2002-03-31'),
(258582,78978,'2002-03-31','9999-01-01'),
(259273,52325,'1989-12-01','1990-12-01'),
(259273,54484,'1990-12-01','1991-12-01'),
(259273,57867,'1991-12-01','1992-11-30'),
(259273,59053,'1992-11-30','1993-11-30'),
(259273,62906,'1993-11-30','1994-11-30'),
(259273,64733,'1994-11-30','1995-11-30');


INSERT INTO `salaries` VALUES (259273,68742,'1995-11-30','1996-11-29'),
(259273,69738,'1996-11-29','1997-11-29'),
(259273,70825,'1997-11-29','1998-11-29'),
(259273,72042,'1998-11-29','1999-11-29'),
(259273,75949,'1999-11-29','2000-11-28'),
(259273,78605,'2000-11-28','2001-11-28'),
(259273,82578,'2001-11-28','9999-01-01'),
(259293,49366,'1996-12-23','1997-12-23'),
(259293,50669,'1997-12-23','1998-12-23'),
(259293,52919,'1998-12-23','1999-12-23');


INSERT INTO `salaries` VALUES (259293,56094,'1999-12-23','2000-12-22'),
(259293,60498,'2000-12-22','2001-12-22'),
(259293,63444,'2001-12-22','9999-01-01'),
(259407,40000,'1986-10-14','1987-10-14'),
(259407,44354,'1987-10-14','1988-10-13'),
(259407,44301,'1988-10-13','1989-10-13'),
(259407,45531,'1989-10-13','1990-10-13'),
(259407,48855,'1990-10-13','1991-10-13'),
(259407,49890,'1991-10-13','1992-10-12'),
(259407,49745,'1992-10-12','1993-10-12');


INSERT INTO `salaries` VALUES (259407,52630,'1993-10-12','1994-10-12'),
(259407,57105,'1994-10-12','1995-10-12'),
(259407,57949,'1995-10-12','1996-10-11'),
(259407,60924,'1996-10-11','1997-10-11'),
(259407,61630,'1997-10-11','1998-10-11'),
(259407,63472,'1998-10-11','1999-10-11'),
(259407,65694,'1999-10-11','2000-10-10'),
(259407,67862,'2000-10-10','2001-10-10'),
(259407,68231,'2001-10-10','9999-01-01'),
(259983,40000,'1988-08-15','1989-08-15');


INSERT INTO `salaries` VALUES (259983,43529,'1989-08-15','1990-08-15'),
(259983,44096,'1990-08-15','1991-08-15'),
(259983,44153,'1991-08-15','1992-08-14'),
(259983,46904,'1992-08-14','1993-08-14'),
(259983,50992,'1993-08-14','1994-08-14'),
(259983,52296,'1994-08-14','1995-08-14'),
(259983,53379,'1995-08-14','1996-08-13'),
(259983,53057,'1996-08-13','1997-08-13'),
(259983,57176,'1997-08-13','1998-08-13'),
(259983,56687,'1998-08-13','1999-08-13');


INSERT INTO `salaries` VALUES (259983,61135,'1999-08-13','2000-08-12'),
(259983,62753,'2000-08-12','2001-08-12'),
(259983,63904,'2001-08-12','9999-01-01'),
(260083,40000,'1997-12-22','1998-12-22'),
(260083,43478,'1998-12-22','1999-02-27'),
(260516,66474,'1985-08-31','1986-08-31'),
(260516,70240,'1986-08-31','1987-08-31'),
(260516,72568,'1987-08-31','1988-08-30'),
(260516,72794,'1988-08-30','1989-08-30'),
(260516,75217,'1989-08-30','1990-08-30');


INSERT INTO `salaries` VALUES (260516,77090,'1990-08-30','1991-08-30'),
(260516,80066,'1991-08-30','1992-08-29'),
(260516,82374,'1992-08-29','1993-08-29'),
(260516,82569,'1993-08-29','1994-08-29'),
(260516,82634,'1994-08-29','1995-08-29'),
(260516,85361,'1995-08-29','1996-08-28'),
(260516,86231,'1996-08-28','1997-08-28'),
(260516,88025,'1997-08-28','1998-08-28'),
(260516,90644,'1998-08-28','1999-08-28'),
(260516,90435,'1999-08-28','2000-08-27');


INSERT INTO `salaries` VALUES (260516,92037,'2000-08-27','2001-08-27'),
(260516,91565,'2001-08-27','9999-01-01'),
(260734,40000,'1993-03-14','1994-03-14'),
(260734,44207,'1994-03-14','1995-03-14'),
(260734,45719,'1995-03-14','1996-03-13'),
(260734,48676,'1996-03-13','1997-03-13'),
(260734,52024,'1997-03-13','1998-03-13'),
(260734,53908,'1998-03-13','1999-03-13'),
(260734,53652,'1999-03-13','2000-03-12'),
(260734,57765,'2000-03-12','2001-03-12');


INSERT INTO `salaries` VALUES (260734,58389,'2001-03-12','2002-03-12'),
(260734,59016,'2002-03-12','9999-01-01'),
(261201,40000,'1986-03-08','1987-03-08'),
(261201,41550,'1987-03-08','1988-03-07'),
(261201,42379,'1988-03-07','1989-03-07'),
(261201,45200,'1989-03-07','1990-03-07'),
(261201,46714,'1990-03-07','1991-03-07'),
(261201,47992,'1991-03-07','1992-03-06'),
(261201,48724,'1992-03-06','1993-03-06'),
(261201,52999,'1993-03-06','1994-03-06');


INSERT INTO `salaries` VALUES (261201,54781,'1994-03-06','1995-03-06'),
(261201,58790,'1995-03-06','1996-03-05'),
(261201,58331,'1996-03-05','1997-03-05'),
(261201,59889,'1997-03-05','1998-03-05'),
(261201,60244,'1998-03-05','1999-03-05'),
(261201,64373,'1999-03-05','2000-03-04'),
(261201,66146,'2000-03-04','2001-03-04'),
(261201,66845,'2001-03-04','2002-03-04'),
(261201,67488,'2002-03-04','9999-01-01'),
(261253,64743,'1994-10-06','1995-10-06');


INSERT INTO `salaries` VALUES (261253,68064,'1995-10-06','1996-10-05'),
(261253,71089,'1996-10-05','1997-10-05'),
(261253,72113,'1997-10-05','1998-10-05'),
(261253,74164,'1998-10-05','1999-10-05'),
(261253,77820,'1999-10-05','2000-10-04'),
(261253,80843,'2000-10-04','2001-10-04'),
(261253,84885,'2001-10-04','9999-01-01'),
(261592,40000,'1996-01-28','1997-01-27'),
(261592,43727,'1997-01-27','1998-01-27'),
(261592,47128,'1998-01-27','1999-01-27');


INSERT INTO `salaries` VALUES (261592,51410,'1999-01-27','2000-01-27'),
(261592,51957,'2000-01-27','2001-01-26'),
(261592,55314,'2001-01-26','2002-01-26'),
(261592,58052,'2002-01-26','9999-01-01'),
(262130,42489,'1995-08-02','1996-08-01'),
(262130,42221,'1996-08-01','1997-08-01'),
(262130,43221,'1997-08-01','1998-08-01'),
(262130,43452,'1998-08-01','1999-08-01'),
(262130,46615,'1999-08-01','2000-07-31'),
(262130,47956,'2000-07-31','2001-07-31');


INSERT INTO `salaries` VALUES (262130,47942,'2001-07-31','2002-07-31'),
(262130,49814,'2002-07-31','9999-01-01'),
(262725,40026,'1986-07-24','1987-07-24'),
(262725,40974,'1987-07-24','1988-07-23'),
(262725,42984,'1988-07-23','1989-07-23'),
(262725,45927,'1989-07-23','1990-07-23'),
(262725,46234,'1990-07-23','1991-07-23'),
(262725,47245,'1991-07-23','1992-07-22'),
(262725,48414,'1992-07-22','1993-07-22'),
(262725,48479,'1993-07-22','1994-07-22');


INSERT INTO `salaries` VALUES (262725,50813,'1994-07-22','1995-07-22'),
(262725,51453,'1995-07-22','1996-07-21'),
(262725,54357,'1996-07-21','1997-07-21'),
(262725,57764,'1997-07-21','1998-07-21'),
(262725,57855,'1998-07-21','1999-07-21'),
(262725,57635,'1999-07-21','2000-07-20'),
(262725,60637,'2000-07-20','2001-07-20'),
(262725,62716,'2001-07-20','2002-07-20'),
(262725,63165,'2002-07-20','9999-01-01'),
(262898,49826,'1996-07-18','1997-03-29');


INSERT INTO `salaries` VALUES (263049,40000,'1990-06-26','1991-06-26'),
(263049,44037,'1991-06-26','1992-06-25'),
(263049,48409,'1992-06-25','1993-06-25'),
(263049,52836,'1993-06-25','1994-06-25'),
(263049,56044,'1994-06-25','1995-06-25'),
(263049,58292,'1995-06-25','1996-06-24'),
(263049,62770,'1996-06-24','1997-06-24'),
(263049,63615,'1997-06-24','1998-06-24'),
(263049,65765,'1998-06-24','1999-06-24'),
(263049,68347,'1999-06-24','2000-06-23');


INSERT INTO `salaries` VALUES (263049,70254,'2000-06-23','2001-06-11'),
(263405,40000,'1990-10-19','1991-10-19'),
(263405,39674,'1991-10-19','1992-10-18'),
(263405,43722,'1992-10-18','1993-10-18'),
(263405,45828,'1993-10-18','1994-10-18'),
(263405,45899,'1994-10-18','1995-10-18'),
(263405,50014,'1995-10-18','1996-10-17'),
(263405,53892,'1996-10-17','1997-10-17'),
(263405,53704,'1997-10-17','1998-10-17'),
(263405,57875,'1998-10-17','1998-12-15');


INSERT INTO `salaries` VALUES (263531,69279,'1994-02-23','1995-02-23'),
(263531,71163,'1995-02-23','1996-02-23'),
(263531,74989,'1996-02-23','1997-02-22'),
(263531,77458,'1997-02-22','1998-02-22'),
(263531,80549,'1998-02-22','1999-02-22'),
(263531,83537,'1999-02-22','2000-02-22'),
(263531,86721,'2000-02-22','2001-02-21'),
(263531,88985,'2001-02-21','2002-02-21'),
(263531,90140,'2002-02-21','9999-01-01'),
(264395,40077,'1990-01-01','1991-01-01');


INSERT INTO `salaries` VALUES (264395,39960,'1991-01-01','1992-01-01'),
(264395,42745,'1992-01-01','1992-12-31'),
(264395,46070,'1992-12-31','1993-12-31'),
(264395,48703,'1993-12-31','1994-12-31'),
(264395,48471,'1994-12-31','1995-12-31'),
(264395,49283,'1995-12-31','1996-12-30'),
(264395,50182,'1996-12-30','1997-12-30'),
(264395,49832,'1997-12-30','1998-12-30'),
(264395,53326,'1998-12-30','1999-12-30'),
(264395,54110,'1999-12-30','2000-12-29');


INSERT INTO `salaries` VALUES (264395,55112,'2000-12-29','2001-12-29'),
(264395,55677,'2001-12-29','9999-01-01'),
(264433,41714,'1998-08-22','1999-08-22'),
(264433,44632,'1999-08-22','2000-08-21'),
(264433,44987,'2000-08-21','2001-08-21'),
(264433,46780,'2001-08-21','2001-09-20'),
(264558,52767,'1986-07-24','1987-07-24'),
(264558,53655,'1987-07-24','1988-07-23'),
(264558,53431,'1988-07-23','1989-07-23'),
(264558,54805,'1989-07-23','1990-07-23');


INSERT INTO `salaries` VALUES (264558,56802,'1990-07-23','1991-07-23'),
(264558,57361,'1991-07-23','1992-07-22'),
(264558,57390,'1992-07-22','1993-07-22'),
(264558,56998,'1993-07-22','1994-07-22'),
(264558,59239,'1994-07-22','1995-07-22'),
(264558,60083,'1995-07-22','1996-07-21'),
(264558,62659,'1996-07-21','1997-07-21'),
(264558,62164,'1997-07-21','1998-07-21'),
(264558,64796,'1998-07-21','1999-07-21'),
(264558,68797,'1999-07-21','2000-07-20');


INSERT INTO `salaries` VALUES (264558,68655,'2000-07-20','2001-07-20'),
(264558,69674,'2001-07-20','2002-07-20'),
(264558,71598,'2002-07-20','9999-01-01'),
(264698,47216,'1994-06-28','1995-06-28'),
(264698,49101,'1995-06-28','1996-06-27'),
(264698,51028,'1996-06-27','1997-06-27'),
(264698,52324,'1997-06-27','1998-06-27'),
(264698,56320,'1998-06-27','1999-06-27'),
(264698,57498,'1999-06-27','2000-06-26'),
(264698,60967,'2000-06-26','2001-06-26');


INSERT INTO `salaries` VALUES (264698,62452,'2001-06-26','2002-06-26'),
(264698,65425,'2002-06-26','9999-01-01'),
(264873,40000,'1987-09-16','1988-09-15'),
(264873,41131,'1988-09-15','1989-09-15'),
(264873,45471,'1989-09-15','1990-09-15'),
(264873,48921,'1990-09-15','1991-09-15'),
(264873,50663,'1991-09-15','1992-09-14'),
(264873,53763,'1992-09-14','1993-09-14'),
(264873,53592,'1993-09-14','1994-09-14'),
(264873,55143,'1994-09-14','1995-09-14');


INSERT INTO `salaries` VALUES (264873,55862,'1995-09-14','1996-09-13'),
(264873,60134,'1996-09-13','1997-09-13'),
(264873,61585,'1997-09-13','1998-09-13'),
(264873,61718,'1998-09-13','1999-09-13'),
(264873,64028,'1999-09-13','2000-09-12'),
(264873,64368,'2000-09-12','2001-09-12'),
(264873,64818,'2001-09-12','9999-01-01'),
(264957,54502,'1995-10-07','1995-11-22'),
(265364,41663,'1994-05-04','1995-05-04'),
(265364,45698,'1995-05-04','1995-08-15');


INSERT INTO `salaries` VALUES (265414,44770,'1993-05-01','1994-05-01'),
(265414,49204,'1994-05-01','1995-05-01'),
(265414,50679,'1995-05-01','1996-04-30'),
(265414,50624,'1996-04-30','1997-04-30'),
(265414,50833,'1997-04-30','1998-04-30'),
(265414,51463,'1998-04-30','1999-04-30'),
(265414,53563,'1999-04-30','2000-04-29'),
(265414,55508,'2000-04-29','2001-04-29'),
(265414,57185,'2001-04-29','2002-04-29'),
(265414,61374,'2002-04-29','9999-01-01');


INSERT INTO `salaries` VALUES (265743,73566,'1988-06-29','1989-06-29'),
(265743,74944,'1989-06-29','1990-06-29'),
(265743,76754,'1990-06-29','1991-06-29'),
(265743,78937,'1991-06-29','1992-06-28'),
(265743,81166,'1992-06-28','1993-06-28'),
(265743,80899,'1993-06-28','1994-06-28'),
(265743,81993,'1994-06-28','1995-06-28'),
(265743,81749,'1995-06-28','1996-06-27'),
(265743,81870,'1996-06-27','1997-06-27'),
(265743,81908,'1997-06-27','1998-06-27');


INSERT INTO `salaries` VALUES (265743,83767,'1998-06-27','1999-06-27'),
(265743,85491,'1999-06-27','2000-06-26'),
(265743,85159,'2000-06-26','2001-06-26'),
(265743,85660,'2001-06-26','2002-06-26'),
(265743,86599,'2002-06-26','9999-01-01'),
(265844,45267,'1990-11-10','1991-11-10'),
(265844,46996,'1991-11-10','1992-11-09'),
(265844,47114,'1992-11-09','1993-11-09'),
(265844,46811,'1993-11-09','1994-11-09'),
(265844,49006,'1994-11-09','1995-11-09');


INSERT INTO `salaries` VALUES (265844,51365,'1995-11-09','1996-11-08'),
(265844,52270,'1996-11-08','1997-11-08'),
(265844,55857,'1997-11-08','1998-11-08'),
(265844,56467,'1998-11-08','1999-11-08'),
(265844,58346,'1999-11-08','2000-11-07'),
(265844,62187,'2000-11-07','2001-11-07'),
(265844,64377,'2001-11-07','9999-01-01'),
(265997,66184,'1991-09-26','1992-09-25'),
(265997,67910,'1992-09-25','1993-08-26'),
(266331,40000,'1985-11-17','1986-11-17');


INSERT INTO `salaries` VALUES (266331,41317,'1986-11-17','1987-11-17'),
(266331,45729,'1987-11-17','1988-11-16'),
(266331,47869,'1988-11-16','1989-11-16'),
(266331,52302,'1989-11-16','1990-11-16'),
(266331,52196,'1990-11-16','1991-11-16'),
(266331,52557,'1991-11-16','1992-01-21'),
(266792,40000,'1997-07-04','1998-07-04'),
(266792,42474,'1998-07-04','1999-07-04'),
(266792,42293,'1999-07-04','2000-07-03'),
(266792,46553,'2000-07-03','2001-07-03');


INSERT INTO `salaries` VALUES (266792,46367,'2001-07-03','2002-07-03'),
(266792,48573,'2002-07-03','9999-01-01'),
(267595,56794,'1993-11-09','1994-11-09'),
(267595,58228,'1994-11-09','1995-11-09'),
(267595,61761,'1995-11-09','1996-11-08'),
(267595,61369,'1996-11-08','1997-11-08'),
(267595,64307,'1997-11-08','1998-02-01'),
(268302,40000,'1991-11-05','1992-11-04'),
(268302,39942,'1992-11-04','1993-11-04'),
(268302,43454,'1993-11-04','1994-11-04');


INSERT INTO `salaries` VALUES (268302,46447,'1994-11-04','1995-11-04'),
(268302,49867,'1995-11-04','1996-11-03'),
(268302,52988,'1996-11-03','1997-11-03'),
(268302,52856,'1997-11-03','1998-11-03'),
(268302,55290,'1998-11-03','1999-11-03'),
(268302,55355,'1999-11-03','2000-11-02'),
(268302,57158,'2000-11-02','2001-11-02'),
(268302,61654,'2001-11-02','9999-01-01'),
(268680,62922,'1996-07-18','1997-07-18'),
(268680,65153,'1997-07-18','1998-07-18');


INSERT INTO `salaries` VALUES (268680,69633,'1998-07-18','1999-07-18'),
(268680,74074,'1999-07-18','2000-07-17'),
(268680,75451,'2000-07-17','2001-07-17'),
(268680,78808,'2001-07-17','2002-07-17'),
(268680,81166,'2002-07-17','9999-01-01'),
(268927,40000,'1999-05-25','2000-05-24'),
(268927,43419,'2000-05-24','2001-05-24'),
(268927,43424,'2001-05-24','2002-05-24'),
(268927,44310,'2002-05-24','9999-01-01'),
(268956,44378,'1992-10-13','1993-10-13');


INSERT INTO `salaries` VALUES (268956,48399,'1993-10-13','1994-10-13'),
(268956,48897,'1994-10-13','1995-10-13'),
(268956,50311,'1995-10-13','1996-10-12'),
(268956,50552,'1996-10-12','1997-10-12'),
(268956,52349,'1997-10-12','1998-10-12'),
(268956,56439,'1998-10-12','1999-10-12'),
(268956,56526,'1999-10-12','2000-10-11'),
(268956,56392,'2000-10-11','2001-10-11'),
(268956,59278,'2001-10-11','9999-01-01'),
(268965,40000,'1988-07-12','1989-07-12');


INSERT INTO `salaries` VALUES (268965,42956,'1989-07-12','1990-07-12'),
(268965,46456,'1990-07-12','1991-07-12'),
(268965,49598,'1991-07-12','1992-07-11'),
(268965,50161,'1992-07-11','1993-07-11'),
(268965,52335,'1993-07-11','1994-07-11'),
(268965,56587,'1994-07-11','1995-07-11'),
(268965,60676,'1995-07-11','1996-07-10'),
(268965,60329,'1996-07-10','1997-07-10'),
(268965,61329,'1997-07-10','1998-07-10'),
(268965,65347,'1998-07-10','1999-07-10');


INSERT INTO `salaries` VALUES (268965,69112,'1999-07-10','2000-07-09'),
(268965,72904,'2000-07-09','2001-07-09'),
(268965,74056,'2001-07-09','2002-07-09'),
(268965,76917,'2002-07-09','9999-01-01'),
(269464,40000,'1998-08-23','1999-08-23'),
(269464,42992,'1999-08-23','2000-08-22'),
(269464,43087,'2000-08-22','2001-08-22'),
(269464,47442,'2001-08-22','9999-01-01'),
(269927,48142,'1991-05-29','1992-05-28'),
(269927,51796,'1992-05-28','1993-05-28');


INSERT INTO `salaries` VALUES (269927,55472,'1993-05-28','1994-05-28'),
(269927,57066,'1994-05-28','1995-05-28'),
(269927,61478,'1995-05-28','1996-05-27'),
(269927,64828,'1996-05-27','1997-05-27'),
(269927,64857,'1997-05-27','1998-05-27'),
(269927,65038,'1998-05-27','1999-05-27'),
(269927,65305,'1999-05-27','2000-05-26'),
(269927,65680,'2000-05-26','2001-05-26'),
(269927,68510,'2001-05-26','2002-05-26'),
(269927,69326,'2002-05-26','9999-01-01');


INSERT INTO `salaries` VALUES (269993,80883,'1995-11-15','1996-11-14'),
(269993,81487,'1996-11-14','1996-12-28'),
(270041,40239,'1990-07-19','1991-07-19'),
(270041,40834,'1991-07-19','1992-04-28'),
(270377,75992,'1999-12-05','2000-12-04'),
(270377,80443,'2000-12-04','2001-12-04'),
(270377,80245,'2001-12-04','9999-01-01'),
(270989,40000,'1999-11-23','2000-11-22'),
(270989,40507,'2000-11-22','2001-11-22'),
(270989,44321,'2001-11-22','9999-01-01');


INSERT INTO `salaries` VALUES (271337,50652,'1989-04-21','1990-04-21'),
(271337,53677,'1990-04-21','1991-04-21'),
(271337,55911,'1991-04-21','1992-04-20'),
(271337,59516,'1992-04-20','1993-04-20'),
(271337,59912,'1993-04-20','1994-04-20'),
(271337,62853,'1994-04-20','1995-04-20'),
(271337,65086,'1995-04-20','1996-04-19'),
(271337,69045,'1996-04-19','1997-04-19'),
(271337,71267,'1997-04-19','1998-04-19'),
(271337,74467,'1998-04-19','1999-04-19');


INSERT INTO `salaries` VALUES (271337,77118,'1999-04-19','2000-04-18'),
(271337,80130,'2000-04-18','2001-04-18'),
(271337,79890,'2001-04-18','2002-04-18'),
(271337,83803,'2002-04-18','9999-01-01'),
(271603,40000,'1996-05-12','1997-05-12'),
(271603,42149,'1997-05-12','1998-05-12'),
(271603,44793,'1998-05-12','1999-05-12'),
(271603,44658,'1999-05-12','2000-05-11'),
(271603,45735,'2000-05-11','2001-05-11'),
(271603,46277,'2001-05-11','2002-05-11');


INSERT INTO `salaries` VALUES (271603,47264,'2002-05-11','9999-01-01'),
(272079,40000,'1996-09-20','1997-09-20'),
(272079,43223,'1997-09-20','1998-09-20'),
(272079,44917,'1998-09-20','1999-09-20'),
(272079,46820,'1999-09-20','2000-09-19'),
(272079,46587,'2000-09-19','2001-09-19'),
(272079,46921,'2001-09-19','9999-01-01'),
(272238,66671,'1997-06-11','1998-06-11'),
(272238,67907,'1998-06-11','1999-06-11'),
(272238,68447,'1999-06-11','2000-06-10');


INSERT INTO `salaries` VALUES (272238,72840,'2000-06-10','2001-06-10'),
(272238,72481,'2001-06-10','2002-06-10'),
(272238,72886,'2002-06-10','9999-01-01'),
(272888,40000,'1989-11-19','1990-11-19'),
(272888,40342,'1990-11-19','1991-11-19'),
(272888,43343,'1991-11-19','1992-11-18'),
(272888,45262,'1992-11-18','1993-11-18'),
(272888,47083,'1993-11-18','1994-11-18'),
(272888,49659,'1994-11-18','1995-11-18'),
(272888,54034,'1995-11-18','1996-11-17');


INSERT INTO `salaries` VALUES (272888,55100,'1996-11-17','1997-11-17'),
(272888,55023,'1997-11-17','1998-11-17'),
(272888,58436,'1998-11-17','1999-11-17'),
(272888,60888,'1999-11-17','2000-11-16'),
(272888,62845,'2000-11-16','2001-11-16'),
(272888,63479,'2001-11-16','9999-01-01'),
(273095,55030,'1994-08-20','1995-08-20'),
(273095,56941,'1995-08-20','1996-08-19'),
(273095,61177,'1996-08-19','1997-08-19'),
(273095,62298,'1997-08-19','1998-08-19');


INSERT INTO `salaries` VALUES (273095,65396,'1998-08-19','1999-08-19'),
(273095,66635,'1999-08-19','2000-08-18'),
(273095,70438,'2000-08-18','2001-08-18'),
(273095,73359,'2001-08-18','9999-01-01'),
(273215,68933,'1985-07-13','1986-07-13'),
(273215,72361,'1986-07-13','1987-07-13'),
(273215,76136,'1987-07-13','1988-07-12'),
(273215,76367,'1988-07-12','1989-07-12'),
(273215,77360,'1989-07-12','1990-07-12'),
(273215,81375,'1990-07-12','1991-07-12');


INSERT INTO `salaries` VALUES (273215,85153,'1991-07-12','1992-07-11'),
(273215,88337,'1992-07-11','1993-02-23'),
(273405,54871,'1993-10-04','1994-10-04'),
(273405,55309,'1994-10-04','1995-10-04'),
(273405,59729,'1995-10-04','1996-10-03'),
(273405,61138,'1996-10-03','1997-10-03'),
(273405,61155,'1997-10-03','1998-10-03'),
(273405,61898,'1998-10-03','1999-10-03'),
(273405,62061,'1999-10-03','2000-10-02'),
(273405,63931,'2000-10-02','2001-10-02');


INSERT INTO `salaries` VALUES (273405,63775,'2001-10-02','9999-01-01'),
(273453,48298,'1992-04-13','1993-04-13'),
(273453,48219,'1993-04-13','1994-04-13'),
(273453,50066,'1994-04-13','1995-04-13'),
(273453,51126,'1995-04-13','1996-04-12'),
(273453,51099,'1996-04-12','1997-04-12'),
(273453,53047,'1997-04-12','1998-04-12'),
(273453,54297,'1998-04-12','1999-04-12'),
(273453,55346,'1999-04-12','2000-04-11'),
(273453,57558,'2000-04-11','2001-04-11');


INSERT INTO `salaries` VALUES (273453,57785,'2001-04-11','2002-04-11'),
(273453,57995,'2002-04-11','9999-01-01'),
(273593,40000,'1989-09-12','1990-09-12'),
(273593,42482,'1990-09-12','1991-09-12'),
(273593,45605,'1991-09-12','1992-09-11'),
(273593,48695,'1992-09-11','1993-09-11'),
(273593,51246,'1993-09-11','1994-09-11'),
(273593,55112,'1994-09-11','1995-09-11'),
(273593,56955,'1995-09-11','1996-09-10'),
(273593,58534,'1996-09-10','1997-09-10');


INSERT INTO `salaries` VALUES (273593,62288,'1997-09-10','1998-09-10'),
(273593,64245,'1998-09-10','1999-09-10'),
(273593,66049,'1999-09-10','2000-09-09'),
(273593,69455,'2000-09-09','2001-09-09'),
(273593,73556,'2001-09-09','9999-01-01'),
(274036,40000,'1998-09-08','1999-09-08'),
(274036,43797,'1999-09-08','2000-09-07'),
(274036,45394,'2000-09-07','2001-09-07'),
(274036,48837,'2001-09-07','9999-01-01'),
(274136,47216,'1998-06-03','1999-06-03');


INSERT INTO `salaries` VALUES (274136,48690,'1999-06-03','2000-06-02'),
(274136,52099,'2000-06-02','2001-06-02'),
(274136,54561,'2001-06-02','2002-06-02'),
(274136,57137,'2002-06-02','9999-01-01'),
(274270,50144,'1990-11-18','1991-11-18'),
(274270,50839,'1991-11-18','1992-11-17'),
(274270,50911,'1992-11-17','1993-11-17'),
(274270,53914,'1993-11-17','1994-11-17'),
(274270,57249,'1994-11-17','1995-11-17'),
(274270,56903,'1995-11-17','1996-11-16');


INSERT INTO `salaries` VALUES (274270,60087,'1996-11-16','1997-11-16'),
(274270,61537,'1997-11-16','1998-11-16'),
(274270,61571,'1998-11-16','1999-11-16'),
(274270,63492,'1999-11-16','2000-11-15'),
(274270,64143,'2000-11-15','2001-11-15'),
(274270,67660,'2001-11-15','9999-01-01'),
(274725,40000,'1998-11-05','1999-11-05'),
(274725,41852,'1999-11-05','2000-11-04'),
(274725,42438,'2000-11-04','2001-07-29'),
(274855,68936,'1985-08-20','1986-08-20');


INSERT INTO `salaries` VALUES (274855,69366,'1986-08-20','1987-08-20'),
(274855,69924,'1987-08-20','1988-08-19'),
(274855,73478,'1988-08-19','1989-08-19'),
(274855,77281,'1989-08-19','1990-08-19'),
(274855,80416,'1990-08-19','1991-08-19'),
(274855,82763,'1991-08-19','1992-08-18'),
(274855,82283,'1992-08-18','1993-08-18'),
(274855,85128,'1993-08-18','1994-08-18'),
(274855,89072,'1994-08-18','1995-08-18'),
(274855,92864,'1995-08-18','1996-08-17');


INSERT INTO `salaries` VALUES (274855,94616,'1996-08-17','1997-08-17'),
(274855,96239,'1997-08-17','1998-08-17'),
(274855,96919,'1998-08-17','1999-08-17'),
(274855,98500,'1999-08-17','2000-08-16'),
(274855,99214,'2000-08-16','2000-10-26'),
(275711,49466,'1992-01-04','1993-01-03'),
(275711,51565,'1993-01-03','1994-01-03'),
(275711,51531,'1994-01-03','1995-01-03'),
(275711,54192,'1995-01-03','1996-01-03'),
(275711,58475,'1996-01-03','1997-01-02');


INSERT INTO `salaries` VALUES (275711,62113,'1997-01-02','1998-01-02'),
(275711,62402,'1998-01-02','1999-01-02'),
(275711,64775,'1999-01-02','2000-01-02'),
(275711,65824,'2000-01-02','2001-01-01'),
(275711,66569,'2001-01-01','2001-04-02'),
(276056,40000,'1993-11-27','1994-11-27'),
(276056,43174,'1994-11-27','1995-11-27'),
(276056,47536,'1995-11-27','1996-11-26'),
(276056,49717,'1996-11-26','1997-11-26'),
(276056,49631,'1997-11-26','1998-11-26');


INSERT INTO `salaries` VALUES (276056,50931,'1998-11-26','1999-11-26'),
(276056,51893,'1999-11-26','2000-11-25'),
(276056,54467,'2000-11-25','2001-11-25'),
(276056,54317,'2001-11-25','9999-01-01'),
(276204,40000,'1996-09-10','1997-09-10'),
(276204,43074,'1997-09-10','1998-09-10'),
(276204,43760,'1998-09-10','1999-09-10'),
(276204,43728,'1999-09-10','2000-09-09'),
(276204,45698,'2000-09-09','2001-09-09'),
(276204,48333,'2001-09-09','9999-01-01');


INSERT INTO `salaries` VALUES (276344,40000,'1998-04-24','1999-04-24'),
(276344,43324,'1999-04-24','2000-04-23'),
(276344,47473,'2000-04-23','2001-04-23'),
(276344,48089,'2001-04-23','2002-04-23'),
(276344,51978,'2002-04-23','9999-01-01'),
(276448,55554,'1996-01-23','1997-01-22'),
(276448,55316,'1997-01-22','1997-11-19'),
(276923,40000,'1994-03-16','1995-03-16'),
(276923,40580,'1995-03-16','1996-03-15'),
(276923,43242,'1996-03-15','1997-03-15');


INSERT INTO `salaries` VALUES (276923,43705,'1997-03-15','1998-03-15'),
(276923,46641,'1998-03-15','1999-03-15'),
(276923,47718,'1999-03-15','2000-03-14'),
(276923,50417,'2000-03-14','2001-03-14'),
(276923,50543,'2001-03-14','2002-03-14'),
(276923,51379,'2002-03-14','9999-01-01'),
(277230,74351,'1999-09-20','2000-09-19'),
(277230,75394,'2000-09-19','2001-09-19'),
(277230,77436,'2001-09-19','9999-01-01'),
(277479,56889,'1997-04-17','1998-04-17');


INSERT INTO `salaries` VALUES (277479,56642,'1998-04-17','1999-04-17'),
(277479,60708,'1999-04-17','2000-04-16'),
(277479,62434,'2000-04-16','2001-04-16'),
(277479,65815,'2001-04-16','2002-04-16'),
(277479,68620,'2002-04-16','9999-01-01'),
(277868,52152,'1985-10-16','1986-10-16'),
(277868,55477,'1986-10-16','1987-10-16'),
(277868,56233,'1987-10-16','1988-10-15'),
(277868,59619,'1988-10-15','1989-10-15'),
(277868,60187,'1989-10-15','1990-10-15');


INSERT INTO `salaries` VALUES (277868,63047,'1990-10-15','1991-10-15'),
(277868,65446,'1991-10-15','1992-10-14'),
(277868,68632,'1992-10-14','1993-10-14'),
(277868,71340,'1993-10-14','1994-10-14'),
(277868,75452,'1994-10-14','1995-10-14'),
(277868,76712,'1995-10-14','1996-10-13'),
(277868,76649,'1996-10-13','1997-10-13'),
(277868,79624,'1997-10-13','1998-10-13'),
(277868,80971,'1998-10-13','1999-10-13'),
(277868,83141,'1999-10-13','2000-10-12');


INSERT INTO `salaries` VALUES (277868,86608,'2000-10-12','2001-10-12'),
(277868,86504,'2001-10-12','9999-01-01'),
(278168,40000,'1988-06-06','1989-06-06'),
(278168,43900,'1989-06-06','1990-06-06'),
(278168,43651,'1990-06-06','1991-06-06'),
(278168,47888,'1991-06-06','1992-06-05'),
(278168,50661,'1992-06-05','1993-06-05'),
(278168,52779,'1993-06-05','1994-06-05'),
(278168,54355,'1994-06-05','1995-06-05'),
(278168,58738,'1995-06-05','1996-06-04');


INSERT INTO `salaries` VALUES (278168,62052,'1996-06-04','1997-06-04'),
(278168,62144,'1997-06-04','1998-06-04'),
(278168,61680,'1998-06-04','1999-06-04'),
(278168,61635,'1999-06-04','2000-06-03'),
(278168,62619,'2000-06-03','2001-06-03'),
(278168,67050,'2001-06-03','2002-06-03'),
(278168,67223,'2002-06-03','9999-01-01'),
(278325,66049,'1999-07-29','2000-07-28'),
(278325,66597,'2000-07-28','2001-07-28'),
(278325,66250,'2001-07-28','2002-07-28');


INSERT INTO `salaries` VALUES (278325,67163,'2002-07-28','9999-01-01'),
(278365,40000,'1985-05-30','1986-05-30'),
(278365,43311,'1986-05-30','1987-05-30'),
(278365,45845,'1987-05-30','1988-05-29'),
(278365,47542,'1988-05-29','1989-05-29'),
(278365,49309,'1989-05-29','1990-05-29'),
(278365,50426,'1990-05-29','1991-05-29'),
(278365,53094,'1991-05-29','1992-05-28'),
(278365,55068,'1992-05-28','1993-05-28'),
(278365,57067,'1993-05-28','1994-05-28');


INSERT INTO `salaries` VALUES (278365,60479,'1994-05-28','1995-05-28'),
(278365,63387,'1995-05-28','1996-05-27'),
(278365,66870,'1996-05-27','1997-05-27'),
(278365,67124,'1997-05-27','1998-05-27'),
(278365,67626,'1998-05-27','1999-05-27'),
(278365,69827,'1999-05-27','2000-05-26'),
(278365,71785,'2000-05-26','2001-05-26'),
(278365,73328,'2001-05-26','2002-05-26'),
(278365,76345,'2002-05-26','9999-01-01'),
(278411,58505,'1997-12-08','1998-12-08');


INSERT INTO `salaries` VALUES (278411,61992,'1998-12-08','1999-12-08'),
(278411,64805,'1999-12-08','2000-12-07'),
(278411,68509,'2000-12-07','2001-12-07'),
(278411,69429,'2001-12-07','9999-01-01'),
(278604,69438,'1995-07-05','1996-07-04'),
(278604,72882,'1996-07-04','1997-07-04'),
(278604,76401,'1997-07-04','1998-07-04'),
(278604,80516,'1998-07-04','1999-06-03'),
(278879,41871,'1998-12-28','1999-12-28'),
(278879,43137,'1999-12-28','2000-12-27');


INSERT INTO `salaries` VALUES (278879,47112,'2000-12-27','2001-12-27'),
(278879,50335,'2001-12-27','9999-01-01'),
(279744,59780,'1996-02-29','1997-02-28'),
(279744,62507,'1997-02-28','1998-02-28'),
(279744,64318,'1998-02-28','1999-02-28'),
(279744,68328,'1999-02-28','2000-02-28'),
(279744,68798,'2000-02-28','2001-02-27'),
(279744,69378,'2001-02-27','2002-02-27'),
(279744,70484,'2002-02-27','9999-01-01'),
(280203,68276,'1991-12-04','1992-12-03');


INSERT INTO `salaries` VALUES (280203,69187,'1992-12-03','1993-12-03'),
(280203,71876,'1993-12-03','1994-12-03'),
(280203,73046,'1994-12-03','1995-12-03'),
(280203,73816,'1995-12-03','1996-12-02'),
(280203,74594,'1996-12-02','1997-12-02'),
(280203,79067,'1997-12-02','1998-12-02'),
(280203,83500,'1998-12-02','1999-12-02'),
(280203,85212,'1999-12-02','2000-12-01'),
(280203,85988,'2000-12-01','2001-12-01'),
(280203,87654,'2001-12-01','9999-01-01');


INSERT INTO `salaries` VALUES (280307,40000,'1994-08-01','1995-08-01'),
(280307,42362,'1995-08-01','1996-07-31'),
(280307,42357,'1996-07-31','1997-07-31'),
(280307,45804,'1997-07-31','1998-07-31'),
(280307,48008,'1998-07-31','1999-07-31'),
(280307,49584,'1999-07-31','2000-07-30'),
(280307,52695,'2000-07-30','2001-07-30'),
(280307,57092,'2001-07-30','2002-07-30'),
(280307,61045,'2002-07-30','9999-01-01'),
(280920,47591,'1995-05-21','1996-05-20');


INSERT INTO `salaries` VALUES (280920,49558,'1996-05-20','1997-05-20'),
(280920,53774,'1997-05-20','1998-05-20'),
(280920,57737,'1998-05-20','1999-05-20'),
(280920,58439,'1999-05-20','2000-05-19'),
(280920,62692,'2000-05-19','2001-05-19'),
(280920,64058,'2001-05-19','2002-05-19'),
(280920,65025,'2002-05-19','9999-01-01'),
(281215,40000,'1998-10-28','1999-10-28'),
(281215,43663,'1999-10-28','2000-10-27'),
(281215,43847,'2000-10-27','2001-10-27');


INSERT INTO `salaries` VALUES (281215,44551,'2001-10-27','9999-01-01'),
(282010,91057,'1993-06-15','1994-06-15'),
(282010,94897,'1994-06-15','1995-06-15'),
(282010,95389,'1995-06-15','1996-06-14'),
(282010,97513,'1996-06-14','1997-06-14'),
(282010,98606,'1997-06-14','1998-06-14'),
(282010,102920,'1998-06-14','1999-06-14'),
(282010,103411,'1999-06-14','2000-06-13'),
(282010,107452,'2000-06-13','2001-06-13'),
(282010,107640,'2001-06-13','2002-06-13');


INSERT INTO `salaries` VALUES (282010,109844,'2002-06-13','9999-01-01'),
(282407,40000,'1995-06-13','1996-06-12'),
(282407,43735,'1996-06-12','1997-06-12'),
(282407,47191,'1997-06-12','1998-06-12'),
(282407,47841,'1998-06-12','1999-06-12'),
(282407,48584,'1999-06-12','2000-06-11'),
(282407,51572,'2000-06-11','2001-06-11'),
(282407,51195,'2001-06-11','2002-06-11'),
(282407,53335,'2002-06-11','9999-01-01'),
(282957,45893,'1994-09-08','1995-09-08');


INSERT INTO `salaries` VALUES (282957,47728,'1995-09-08','1996-09-07'),
(282957,50662,'1996-09-07','1997-09-07'),
(282957,50840,'1997-09-07','1998-09-07'),
(282957,54429,'1998-09-07','1999-09-07'),
(282957,57589,'1999-09-07','2000-09-06'),
(282957,59681,'2000-09-06','2001-09-06'),
(282957,63117,'2001-09-06','9999-01-01'),
(283297,55043,'1985-06-24','1986-06-24'),
(283297,57402,'1986-06-24','1987-06-24'),
(283297,58214,'1987-06-24','1988-06-23');


INSERT INTO `salaries` VALUES (283297,62667,'1988-06-23','1989-06-23'),
(283297,62453,'1989-06-23','1990-06-23'),
(283297,65596,'1990-06-23','1991-06-23'),
(283297,67228,'1991-06-23','1992-06-22'),
(283297,71265,'1992-06-22','1993-06-22'),
(283297,70868,'1993-06-22','1994-06-22'),
(283297,74727,'1994-06-22','1995-06-22'),
(283297,75460,'1995-06-22','1996-06-21'),
(283297,76534,'1996-06-21','1997-06-21'),
(283297,76264,'1997-06-21','1998-06-21');


INSERT INTO `salaries` VALUES (283297,78105,'1998-06-21','1999-06-21'),
(283297,80937,'1999-06-21','2000-06-20'),
(283297,83695,'2000-06-20','2001-06-20'),
(283297,87451,'2001-06-20','2002-06-20'),
(283297,88193,'2002-06-20','9999-01-01'),
(283456,40000,'1987-05-21','1988-05-20'),
(283456,39669,'1988-05-20','1989-05-20'),
(283456,41853,'1989-05-20','1990-05-20'),
(283456,44063,'1990-05-20','1991-05-20'),
(283456,47832,'1991-05-20','1992-05-19');


INSERT INTO `salaries` VALUES (283456,48887,'1992-05-19','1993-05-19'),
(283456,52432,'1993-05-19','1994-05-19'),
(283456,54205,'1994-05-19','1995-05-19'),
(283456,55838,'1995-05-19','1996-05-18'),
(283456,56201,'1996-05-18','1997-05-18'),
(283456,60302,'1997-05-18','1998-05-18'),
(283456,62021,'1998-05-18','1999-05-18'),
(283456,64777,'1999-05-18','2000-05-17'),
(283456,65453,'2000-05-17','2001-05-17'),
(283456,67806,'2001-05-17','2002-05-17');


INSERT INTO `salaries` VALUES (283456,68537,'2002-05-17','9999-01-01'),
(284077,57962,'1989-06-14','1990-06-14'),
(284077,57624,'1990-06-14','1991-06-14'),
(284077,59605,'1991-06-14','1992-06-13'),
(284077,62820,'1992-06-13','1993-06-13'),
(284077,63412,'1993-06-13','1994-06-13'),
(284077,66298,'1994-06-13','1995-06-13'),
(284077,66553,'1995-06-13','1996-06-12'),
(284077,68946,'1996-06-12','1997-06-12'),
(284077,71089,'1997-06-12','1998-06-12');


INSERT INTO `salaries` VALUES (284077,73134,'1998-06-12','1999-06-12'),
(284077,76910,'1999-06-12','2000-06-11'),
(284077,78119,'2000-06-11','2001-06-11'),
(284077,80491,'2001-06-11','2002-06-11'),
(284077,80597,'2002-06-11','9999-01-01'),
(284398,60867,'1992-02-04','1993-02-03'),
(284398,62831,'1993-02-03','1994-02-03'),
(284398,62549,'1994-02-03','1995-02-03'),
(284398,66830,'1995-02-03','1996-02-03'),
(284398,70165,'1996-02-03','1997-02-02');


INSERT INTO `salaries` VALUES (284398,70303,'1997-02-02','1998-02-02'),
(284398,72135,'1998-02-02','1999-02-02'),
(284398,72816,'1999-02-02','2000-02-02'),
(284398,74516,'2000-02-02','2000-11-10'),
(284426,40348,'1990-11-18','1991-11-18'),
(284426,43368,'1991-11-18','1992-11-17'),
(284426,47398,'1992-11-17','1993-11-17'),
(284426,50009,'1993-11-17','1994-11-17'),
(284426,52853,'1994-11-17','1995-11-17'),
(284426,56474,'1995-11-17','1996-11-16');


INSERT INTO `salaries` VALUES (284426,58732,'1996-11-16','1997-11-16'),
(284426,62648,'1997-11-16','1998-11-16'),
(284426,67086,'1998-11-16','1999-11-16'),
(284426,67502,'1999-11-16','2000-11-15'),
(284426,69264,'2000-11-15','2001-11-15'),
(284426,73763,'2001-11-15','9999-01-01'),
(285405,58296,'1998-01-03','1999-01-03'),
(285405,62262,'1999-01-03','2000-01-03'),
(285405,66507,'2000-01-03','2001-01-02'),
(285405,67337,'2001-01-02','2002-01-02');


INSERT INTO `salaries` VALUES (285405,67897,'2002-01-02','9999-01-01'),
(285729,59425,'1986-08-19','1987-08-19'),
(285729,61264,'1987-08-19','1988-08-18'),
(285729,64020,'1988-08-18','1989-08-18'),
(285729,67350,'1989-08-18','1990-08-18'),
(285729,69542,'1990-08-18','1991-08-18'),
(285729,69990,'1991-08-18','1992-08-17'),
(285729,69755,'1992-08-17','1993-08-17'),
(285729,73725,'1993-08-17','1994-08-17'),
(285729,73917,'1994-08-17','1995-08-17');


INSERT INTO `salaries` VALUES (285729,77660,'1995-08-17','1996-08-16'),
(285729,79340,'1996-08-16','1997-08-16'),
(285729,83267,'1997-08-16','1998-08-16'),
(285729,84887,'1998-08-16','1999-08-16'),
(285729,84927,'1999-08-16','2000-08-15'),
(285729,84594,'2000-08-15','2001-08-15'),
(285729,88453,'2001-08-15','9999-01-01'),
(286006,68742,'1998-03-13','1999-03-13'),
(286006,70006,'1999-03-13','2000-03-12'),
(286006,69991,'2000-03-12','2001-03-12');


INSERT INTO `salaries` VALUES (286006,72463,'2001-03-12','2002-03-12'),
(286006,75925,'2002-03-12','9999-01-01'),
(286240,67277,'1990-06-09','1991-06-09'),
(286240,69117,'1991-06-09','1992-06-08'),
(286240,71474,'1992-06-08','1993-06-08'),
(286240,73452,'1993-06-08','1994-06-08'),
(286240,73092,'1994-06-08','1995-06-08'),
(286240,73993,'1995-06-08','1996-06-07'),
(286240,75275,'1996-06-07','1997-06-07'),
(286240,77068,'1997-06-07','1998-06-07');


INSERT INTO `salaries` VALUES (286240,80617,'1998-06-07','1999-06-07'),
(286240,83811,'1999-06-07','2000-06-06'),
(286240,84827,'2000-06-06','2001-06-06'),
(286240,87227,'2001-06-06','2002-06-06'),
(286240,87443,'2002-06-06','9999-01-01'),
(287571,81994,'1986-07-09','1987-07-09'),
(287571,83837,'1987-07-09','1988-07-08'),
(287571,87636,'1988-07-08','1989-07-08'),
(287571,88584,'1989-07-08','1990-07-08'),
(287571,89924,'1990-07-08','1991-07-08');


INSERT INTO `salaries` VALUES (287571,92144,'1991-07-08','1992-07-07'),
(287571,93469,'1992-07-07','1993-07-07'),
(287571,93011,'1993-07-07','1994-07-07'),
(287571,95268,'1994-07-07','1995-07-07'),
(287571,95832,'1995-07-07','1996-07-06'),
(287571,99672,'1996-07-06','1997-07-06'),
(287571,103935,'1997-07-06','1998-07-06'),
(287571,105893,'1998-07-06','1999-07-06'),
(287571,107242,'1999-07-06','2000-07-05'),
(287571,109961,'2000-07-05','2001-07-05');


INSERT INTO `salaries` VALUES (287571,111446,'2001-07-05','2002-07-05'),
(287571,114236,'2002-07-05','9999-01-01'),
(287914,40000,'1986-09-27','1987-09-27'),
(287914,39951,'1987-09-27','1988-09-26'),
(287914,43482,'1988-09-26','1989-09-26'),
(287914,47282,'1989-09-26','1990-09-26'),
(287914,51425,'1990-09-26','1991-09-26'),
(287914,53794,'1991-09-26','1992-09-25'),
(287914,57690,'1992-09-25','1993-09-25'),
(287914,57555,'1993-09-25','1994-09-25');


INSERT INTO `salaries` VALUES (287914,58219,'1994-09-25','1995-09-25'),
(287914,58149,'1995-09-25','1996-09-24'),
(287914,59426,'1996-09-24','1997-09-24'),
(287914,60735,'1997-09-24','1998-09-24'),
(287914,61748,'1998-09-24','1999-09-24'),
(287914,64957,'1999-09-24','2000-09-23'),
(287914,65286,'2000-09-23','2001-09-23'),
(287914,66844,'2001-09-23','9999-01-01'),
(288184,40000,'1994-11-19','1995-11-19'),
(288184,40837,'1995-11-19','1996-11-18');


INSERT INTO `salaries` VALUES (288184,43098,'1996-11-18','1997-11-18'),
(288184,45766,'1997-11-18','1998-11-18'),
(288184,46289,'1998-11-18','1999-11-18'),
(288184,46114,'1999-11-18','2000-11-17'),
(288184,45968,'2000-11-17','2001-11-17'),
(288184,45514,'2001-11-17','9999-01-01'),
(289181,56421,'1987-02-12','1988-02-12'),
(289181,60036,'1988-02-12','1989-02-11'),
(289181,62705,'1989-02-11','1990-02-11'),
(289181,65116,'1990-02-11','1991-02-11');


INSERT INTO `salaries` VALUES (289181,68563,'1991-02-11','1992-02-11'),
(289181,71882,'1992-02-11','1993-02-10'),
(289181,73774,'1993-02-10','1994-02-10'),
(289181,75882,'1994-02-10','1995-02-10'),
(289181,79903,'1995-02-10','1996-02-10'),
(289181,80383,'1996-02-10','1997-02-09'),
(289181,82132,'1997-02-09','1998-02-09'),
(289181,86092,'1998-02-09','1999-02-09'),
(289181,86558,'1999-02-09','2000-02-09'),
(289181,87072,'2000-02-09','2001-02-08');


INSERT INTO `salaries` VALUES (289181,90643,'2001-02-08','2002-02-08'),
(289181,91455,'2002-02-08','9999-01-01'),
(289576,40000,'1990-01-21','1991-01-21'),
(289576,42490,'1991-01-21','1992-01-21'),
(289576,46922,'1992-01-21','1993-01-20'),
(289576,47796,'1993-01-20','1994-01-20'),
(289576,48950,'1994-01-20','1995-01-20'),
(289576,50736,'1995-01-20','1996-01-20'),
(289576,52896,'1996-01-20','1997-01-19'),
(289576,53084,'1997-01-19','1998-01-19');


INSERT INTO `salaries` VALUES (289576,53465,'1998-01-19','1999-01-19'),
(289576,53449,'1999-01-19','2000-01-19'),
(289576,53837,'2000-01-19','2001-01-18'),
(289576,53590,'2001-01-18','2001-08-09'),
(289652,42509,'1988-05-10','1989-05-10'),
(289652,46396,'1989-05-10','1990-05-10'),
(289652,50787,'1990-05-10','1991-05-10'),
(289652,55196,'1991-05-10','1992-05-09'),
(289652,59487,'1992-05-09','1993-04-16'),
(289766,85598,'1999-12-24','2000-12-23');


INSERT INTO `salaries` VALUES (289766,85143,'2000-12-23','2001-12-23'),
(289766,87943,'2001-12-23','9999-01-01'),
(289866,40000,'1999-04-21','2000-04-20'),
(289866,43875,'2000-04-20','2001-04-20'),
(289866,46651,'2001-04-20','2002-04-20'),
(289866,46818,'2002-04-20','9999-01-01'),
(290282,62218,'1995-08-27','1996-08-26'),
(290282,65994,'1996-08-26','1997-08-26'),
(290282,68646,'1997-08-26','1998-08-26'),
(290282,71618,'1998-08-26','1999-08-26');


INSERT INTO `salaries` VALUES (290282,74498,'1999-08-26','2000-08-25'),
(290282,75244,'2000-08-25','2001-08-25'),
(290282,77344,'2001-08-25','9999-01-01'),
(290932,40000,'1988-01-26','1989-01-25'),
(290932,42345,'1989-01-25','1990-01-25'),
(290932,44179,'1990-01-25','1991-01-25'),
(290932,45663,'1991-01-25','1992-01-25'),
(290932,46148,'1992-01-25','1993-01-24'),
(290932,50166,'1993-01-24','1994-01-24'),
(290932,51397,'1994-01-24','1995-01-24');


INSERT INTO `salaries` VALUES (290932,51813,'1995-01-24','1996-01-24'),
(290932,54131,'1996-01-24','1997-01-23'),
(290932,56206,'1997-01-23','1998-01-23'),
(290932,57575,'1998-01-23','1999-01-23'),
(290932,57353,'1999-01-23','2000-01-23'),
(290932,58650,'2000-01-23','2001-01-22'),
(290932,58947,'2001-01-22','2002-01-22'),
(290932,59411,'2002-01-22','9999-01-01'),
(291158,72729,'1999-10-07','2000-10-06'),
(291158,74023,'2000-10-06','2001-10-06');


INSERT INTO `salaries` VALUES (291158,75219,'2001-10-06','9999-01-01'),
(291253,68870,'1987-10-11','1988-10-10'),
(291253,71068,'1988-10-10','1989-10-10'),
(291253,74849,'1989-10-10','1990-10-10'),
(291253,74887,'1990-10-10','1991-10-10'),
(291253,74480,'1991-10-10','1992-05-19'),
(293383,40963,'1987-01-16','1988-01-02'),
(293448,49067,'1987-02-10','1988-02-10'),
(293448,52517,'1988-02-10','1989-02-09'),
(293448,56448,'1989-02-09','1990-02-09');


INSERT INTO `salaries` VALUES (293448,56198,'1990-02-09','1991-02-09'),
(293448,59163,'1991-02-09','1992-02-09'),
(293448,61089,'1992-02-09','1993-02-08'),
(293448,63975,'1993-02-08','1994-02-08'),
(293448,64730,'1994-02-08','1995-02-08'),
(293448,67744,'1995-02-08','1996-02-08'),
(293448,70842,'1996-02-08','1997-02-07'),
(293448,74198,'1997-02-07','1998-02-07'),
(293448,77271,'1998-02-07','1999-02-07'),
(293448,79261,'1999-02-07','1999-08-30');


INSERT INTO `salaries` VALUES (293551,40000,'1986-04-18','1987-04-18'),
(293551,39712,'1987-04-18','1988-04-17'),
(293551,40383,'1988-04-17','1989-04-17'),
(293551,44379,'1989-04-17','1990-04-17'),
(293551,44706,'1990-04-17','1991-04-17'),
(293551,48214,'1991-04-17','1992-04-16'),
(293551,48263,'1992-04-16','1993-04-16'),
(293551,52471,'1993-04-16','1994-01-20'),
(293714,66330,'1994-03-28','1995-03-28'),
(293714,69174,'1995-03-28','1996-03-27');


INSERT INTO `salaries` VALUES (293714,72336,'1996-03-27','1997-03-27'),
(293714,74158,'1997-03-27','1998-03-27'),
(293714,77763,'1998-03-27','1999-03-27'),
(293714,78044,'1999-03-27','2000-03-26'),
(293714,80197,'2000-03-26','2001-03-26'),
(293714,80871,'2001-03-26','2002-03-26'),
(293714,82866,'2002-03-26','9999-01-01'),
(294057,65209,'1997-10-24','1998-10-24'),
(294057,66063,'1998-10-24','1999-10-24'),
(294057,68365,'1999-10-24','2000-10-23');


INSERT INTO `salaries` VALUES (294057,70067,'2000-10-23','2001-10-23'),
(294057,72604,'2001-10-23','9999-01-01'),
(294261,60270,'1991-05-04','1992-05-03'),
(294261,60400,'1992-05-03','1993-05-03'),
(294261,62150,'1993-05-03','1994-05-03'),
(294261,64471,'1994-05-03','1995-05-03'),
(294261,67625,'1995-05-03','1996-05-02'),
(294261,69435,'1996-05-02','1997-05-02'),
(294261,70106,'1997-05-02','1998-05-02'),
(294261,74334,'1998-05-02','1999-05-02');


INSERT INTO `salaries` VALUES (294261,74511,'1999-05-02','2000-05-01'),
(294261,77010,'2000-05-01','2001-05-01'),
(294261,78054,'2001-05-01','2002-05-01'),
(294261,79041,'2002-05-01','9999-01-01'),
(295755,53128,'1989-04-02','1990-04-02'),
(295755,55010,'1990-04-02','1991-04-02'),
(295755,58099,'1991-04-02','1992-04-01'),
(295755,58327,'1992-04-01','1993-04-01'),
(295755,59557,'1993-04-01','1994-04-01'),
(295755,59088,'1994-04-01','1995-04-01');


INSERT INTO `salaries` VALUES (295755,59740,'1995-04-01','1996-03-31'),
(295755,63640,'1996-03-31','1997-03-31'),
(295755,65486,'1997-03-31','1998-03-31'),
(295755,66043,'1998-03-31','1999-03-31'),
(295755,67599,'1999-03-31','2000-03-30'),
(295755,68847,'2000-03-30','2001-03-30'),
(295755,70693,'2001-03-30','2002-03-30'),
(295755,74710,'2002-03-30','9999-01-01'),
(296014,40000,'1999-04-14','2000-04-13'),
(296014,44133,'2000-04-13','2000-08-26');


INSERT INTO `salaries` VALUES (296500,46521,'1993-02-03','1994-02-03'),
(296500,49502,'1994-02-03','1995-02-03'),
(296500,51115,'1995-02-03','1996-02-03'),
(296500,50968,'1996-02-03','1997-02-02'),
(296500,53504,'1997-02-02','1998-02-02'),
(296500,55126,'1998-02-02','1999-02-02'),
(296500,54934,'1999-02-02','2000-02-02'),
(296500,55874,'2000-02-02','2001-02-01'),
(296500,58157,'2001-02-01','2002-02-01'),
(296500,58839,'2002-02-01','9999-01-01');


INSERT INTO `salaries` VALUES (296744,40000,'1985-08-21','1986-08-21'),
(296744,41136,'1986-08-21','1987-08-21'),
(296744,45061,'1987-08-21','1988-08-20'),
(296744,46944,'1988-08-20','1989-08-20'),
(296744,47265,'1989-08-20','1990-08-20'),
(296744,48838,'1990-08-20','1991-08-20'),
(296744,49887,'1991-08-20','1992-08-19'),
(296744,53574,'1992-08-19','1993-06-13'),
(297742,40000,'1987-05-30','1988-05-29'),
(297742,41049,'1988-05-29','1989-01-15');


INSERT INTO `salaries` VALUES (298437,57804,'1991-06-05','1992-06-04'),
(298437,62062,'1992-06-04','1993-06-04'),
(298437,64132,'1993-06-04','1994-06-04'),
(298437,67581,'1994-06-04','1995-06-04'),
(298437,68060,'1995-06-04','1996-06-03'),
(298437,68426,'1996-06-03','1997-06-03'),
(298437,68980,'1997-06-03','1998-06-03'),
(298437,70073,'1998-06-03','1999-06-03'),
(298437,69815,'1999-06-03','2000-06-02'),
(298437,72016,'2000-06-02','2001-06-02');


INSERT INTO `salaries` VALUES (298437,75526,'2001-06-02','2002-06-02'),
(298437,76265,'2002-06-02','9999-01-01'),
(298667,59042,'1998-10-20','1999-10-20'),
(298667,61739,'1999-10-20','2000-10-19'),
(298667,64586,'2000-10-19','2001-08-30'),
(298675,46427,'1994-09-02','1995-09-02'),
(298675,47949,'1995-09-02','1996-09-01'),
(298675,51465,'1996-09-01','1997-09-01'),
(298675,55737,'1997-09-01','1998-09-01'),
(298675,60094,'1998-09-01','1999-09-01');


INSERT INTO `salaries` VALUES (298675,62961,'1999-09-01','2000-08-31'),
(298675,63825,'2000-08-31','2001-08-31'),
(298675,65761,'2001-08-31','9999-01-01'),
(298735,51168,'1998-10-25','1999-10-25'),
(298735,55323,'1999-10-25','2000-05-03'),
(298747,44348,'1989-10-21','1990-10-21'),
(298747,47610,'1990-10-21','1991-10-21'),
(298747,50250,'1991-10-21','1992-10-20'),
(298747,51470,'1992-10-20','1993-10-20'),
(298747,51200,'1993-10-20','1994-10-20');


INSERT INTO `salaries` VALUES (298747,53656,'1994-10-20','1995-10-20'),
(298747,55957,'1995-10-20','1996-10-19'),
(298747,57088,'1996-10-19','1997-10-19'),
(298747,58084,'1997-10-19','1998-10-19'),
(298747,57830,'1998-10-19','1999-10-19'),
(298747,59810,'1999-10-19','2000-10-18'),
(298747,60572,'2000-10-18','2001-10-18'),
(298747,64049,'2001-10-18','9999-01-01'),
(298757,53831,'1988-06-28','1989-06-28'),
(298757,58010,'1989-06-28','1990-06-28');


INSERT INTO `salaries` VALUES (298757,58423,'1990-06-28','1991-06-28'),
(298757,57974,'1991-06-28','1992-06-27'),
(298757,58353,'1992-06-27','1993-06-27'),
(298757,59496,'1993-06-27','1994-06-27'),
(298757,63423,'1994-06-27','1995-06-27'),
(298757,67841,'1995-06-27','1996-06-26'),
(298757,67803,'1996-06-26','1997-06-26'),
(298757,71173,'1997-06-26','1998-06-26'),
(298757,71958,'1998-06-26','1999-06-26'),
(298757,71705,'1999-06-26','2000-06-25');


INSERT INTO `salaries` VALUES (298757,72766,'2000-06-25','2001-06-25'),
(298757,73769,'2001-06-25','2002-06-25'),
(298757,74920,'2002-06-25','9999-01-01'),
(298919,41430,'1985-02-20','1986-02-20'),
(298919,40981,'1986-02-20','1987-02-20'),
(298919,45381,'1987-02-20','1988-02-20'),
(298919,48489,'1988-02-20','1989-02-19'),
(298919,49246,'1989-02-19','1990-02-19'),
(298919,52148,'1990-02-19','1991-02-19'),
(298919,53921,'1991-02-19','1992-02-19');


INSERT INTO `salaries` VALUES (298919,55914,'1992-02-19','1993-02-18'),
(298919,55901,'1993-02-18','1994-02-18'),
(298919,59502,'1994-02-18','1995-02-18'),
(298919,62289,'1995-02-18','1996-02-18'),
(298919,61914,'1996-02-18','1997-02-17'),
(298919,62403,'1997-02-17','1998-02-17'),
(298919,65934,'1998-02-17','1999-02-17'),
(298919,66097,'1999-02-17','2000-02-17'),
(298919,66043,'2000-02-17','2001-02-16'),
(298919,70449,'2001-02-16','2002-02-16');


INSERT INTO `salaries` VALUES (298919,71573,'2002-02-16','9999-01-01'),
(299167,64431,'1994-12-24','1995-12-24'),
(299167,67093,'1995-12-24','1996-12-23'),
(299167,70056,'1996-12-23','1997-12-23'),
(299167,70237,'1997-12-23','1998-12-23'),
(299167,71318,'1998-12-23','1999-12-23'),
(299167,74917,'1999-12-23','2000-12-22'),
(299167,78087,'2000-12-22','2001-12-22'),
(299167,80599,'2001-12-22','9999-01-01'),
(299210,68163,'1996-10-22','1997-10-22');


INSERT INTO `salaries` VALUES (299210,70447,'1997-10-22','1998-10-22'),
(299210,72884,'1998-10-22','1999-10-22'),
(299210,74732,'1999-10-22','2000-10-21'),
(299210,78768,'2000-10-21','2001-10-21'),
(299210,80158,'2001-10-21','9999-01-01'),
(299271,61628,'1989-04-13','1990-04-13'),
(299271,64779,'1990-04-13','1991-04-13'),
(299271,67104,'1991-04-13','1992-04-12'),
(299271,68870,'1992-04-12','1993-04-12'),
(299271,71926,'1993-04-12','1994-04-12');


INSERT INTO `salaries` VALUES (299271,74218,'1994-04-12','1995-04-12'),
(299271,77826,'1995-04-12','1996-04-11'),
(299271,80001,'1996-04-11','1997-04-11'),
(299271,79778,'1997-04-11','1998-04-11'),
(299271,80184,'1998-04-11','1999-04-11'),
(299271,79834,'1999-04-11','2000-04-10'),
(299271,82987,'2000-04-10','2001-04-10'),
(299271,87148,'2001-04-10','2002-04-10'),
(299271,90802,'2002-04-10','9999-01-01'),
(299403,45173,'1998-09-19','1999-09-19');


INSERT INTO `salaries` VALUES (299403,46087,'1999-09-19','2000-09-18'),
(299403,48360,'2000-09-18','2001-09-18'),
(299403,48103,'2001-09-18','9999-01-01'),
(299405,64219,'1997-04-20','1998-04-20'),
(299405,64154,'1998-04-20','1999-04-20'),
(299405,66653,'1999-04-20','2000-04-19'),
(299405,67566,'2000-04-19','2001-04-19'),
(299405,69379,'2001-04-19','2002-04-19'),
(299405,69504,'2002-04-19','9999-01-01'),
(299850,48804,'1994-06-02','1995-06-02');


INSERT INTO `salaries` VALUES (299850,52533,'1995-06-02','1996-06-01'),
(299850,53393,'1996-06-01','1997-06-01'),
(299850,56400,'1997-06-01','1998-06-01'),
(299850,57449,'1998-06-01','1999-06-01'),
(299850,57496,'1999-06-01','2000-05-31'),
(299850,61537,'2000-05-31','2001-05-31'),
(299850,61385,'2001-05-31','2002-05-31'),
(299850,62240,'2002-05-31','9999-01-01'),
(400054,70221,'1999-10-02','2000-10-01'),
(400054,69849,'2000-10-01','2001-10-01');


INSERT INTO `salaries` VALUES (400054,72763,'2001-10-01','9999-01-01'),
(400538,54147,'1997-07-29','1998-07-29'),
(400538,58513,'1998-07-29','1999-07-29'),
(400538,60734,'1999-07-29','1999-10-09'),
(400763,49485,'1997-08-12','1998-08-12'),
(400763,51777,'1998-08-12','1999-08-12'),
(400763,53698,'1999-08-12','2000-08-11'),
(400763,55978,'2000-08-11','2001-08-11'),
(400763,57096,'2001-08-11','9999-01-01'),
(400796,40000,'1996-05-30','1997-05-30');


INSERT INTO `salaries` VALUES (400796,40645,'1997-05-30','1998-05-30'),
(400796,41443,'1998-05-30','1999-05-30'),
(400796,43472,'1999-05-30','2000-05-29'),
(400796,43577,'2000-05-29','2001-05-29'),
(400796,47622,'2001-05-29','2002-05-29'),
(400796,48514,'2002-05-29','9999-01-01'),
(401085,67158,'1987-05-18','1988-05-17'),
(401085,67021,'1988-05-17','1989-05-17'),
(401085,67440,'1989-05-17','1990-05-17'),
(401085,68105,'1990-05-17','1991-05-17');


INSERT INTO `salaries` VALUES (401085,69692,'1991-05-17','1992-05-16'),
(401085,72357,'1992-05-16','1993-05-16'),
(401085,73813,'1993-05-16','1994-05-16'),
(401085,73366,'1994-05-16','1995-05-16'),
(401085,77099,'1995-05-16','1996-05-15'),
(401085,80892,'1996-05-15','1997-05-15'),
(401085,84090,'1997-05-15','1998-05-15'),
(401085,84078,'1998-05-15','1999-05-15'),
(401085,86299,'1999-05-15','2000-05-14'),
(401085,90457,'2000-05-14','2001-05-14');


INSERT INTO `salaries` VALUES (401085,92900,'2001-05-14','2002-05-14'),
(401085,94461,'2002-05-14','9999-01-01'),
(401291,40000,'1987-11-02','1988-11-01'),
(401291,41031,'1988-11-01','1989-11-01'),
(401291,44551,'1989-11-01','1990-11-01'),
(401291,47687,'1990-11-01','1991-11-01'),
(401291,49943,'1991-11-01','1992-10-31'),
(401291,54426,'1992-10-31','1993-10-31'),
(401291,54053,'1993-10-31','1994-10-31'),
(401291,57982,'1994-10-31','1995-10-31');


INSERT INTO `salaries` VALUES (401291,59906,'1995-10-31','1996-10-30'),
(401291,63487,'1996-10-30','1997-10-30'),
(401291,66287,'1997-10-30','1998-10-30'),
(401291,67380,'1998-10-30','1999-10-30'),
(401291,68120,'1999-10-30','2000-10-29'),
(401291,67898,'2000-10-29','2001-10-29'),
(401291,68371,'2001-10-29','9999-01-01'),
(401704,61763,'1991-05-22','1992-05-21'),
(401704,65246,'1992-05-21','1993-05-21'),
(401704,68781,'1993-05-21','1994-05-21');


INSERT INTO `salaries` VALUES (401704,72393,'1994-05-21','1995-05-21'),
(401704,73818,'1995-05-21','1996-05-20'),
(401704,73945,'1996-05-20','1997-05-20'),
(401704,78373,'1997-05-20','1998-05-20'),
(401704,78421,'1998-05-20','1999-05-20'),
(401704,78868,'1999-05-20','2000-05-19'),
(401704,82245,'2000-05-19','2001-05-19'),
(401704,82143,'2001-05-19','2002-05-19'),
(401704,83660,'2002-05-19','9999-01-01'),
(401929,86230,'1985-03-02','1986-03-02');


INSERT INTO `salaries` VALUES (401929,88748,'1986-03-02','1987-03-02'),
(401929,91336,'1987-03-02','1988-03-01'),
(401929,91580,'1988-03-01','1989-03-01'),
(401929,91307,'1989-03-01','1990-03-01'),
(401929,94808,'1990-03-01','1991-03-01'),
(401929,99232,'1991-03-01','1992-02-29'),
(401929,99116,'1992-02-29','1993-02-28'),
(401929,103076,'1993-02-28','1994-02-28'),
(401929,104329,'1994-02-28','1995-02-28'),
(401929,106447,'1995-02-28','1996-02-28');


INSERT INTO `salaries` VALUES (401929,106813,'1996-02-28','1997-02-27'),
(401929,110178,'1997-02-27','1998-02-27'),
(401929,112765,'1998-02-27','1999-02-27'),
(401929,113881,'1999-02-27','2000-02-27'),
(401929,118003,'2000-02-27','2001-02-26'),
(401929,119876,'2001-02-26','2002-02-26'),
(401929,121488,'2002-02-26','9999-01-01'),
(402392,52823,'1995-03-21','1996-03-20'),
(402392,54369,'1996-03-20','1997-03-20'),
(402392,55362,'1997-03-20','1998-03-20');


INSERT INTO `salaries` VALUES (402392,58553,'1998-03-20','1999-03-20'),
(402392,60109,'1999-03-20','2000-03-19'),
(402392,60538,'2000-03-19','2001-03-19'),
(402392,61026,'2001-03-19','2002-03-19'),
(402392,64970,'2002-03-19','9999-01-01'),
(403849,40000,'1990-06-21','1991-06-21'),
(403849,42467,'1991-06-21','1992-06-20'),
(403849,42174,'1992-06-20','1993-06-20'),
(403849,45922,'1993-06-20','1993-10-13'),
(404174,51420,'1995-07-31','1996-07-30');


INSERT INTO `salaries` VALUES (404174,55801,'1996-07-30','1997-07-30'),
(404174,56485,'1997-07-30','1998-07-30'),
(404174,56633,'1998-07-30','1999-02-09'),
(404441,47821,'1994-10-04','1995-10-04'),
(404441,52135,'1995-10-04','1996-10-03'),
(404441,55233,'1996-10-03','1997-10-03'),
(404441,55137,'1997-10-03','1998-10-03'),
(404441,58997,'1998-10-03','1999-10-03'),
(404441,62619,'1999-10-03','2000-10-02'),
(404441,64673,'2000-10-02','2001-10-02');


INSERT INTO `salaries` VALUES (404441,65368,'2001-10-02','9999-01-01'),
(404669,64931,'1995-03-02','1996-03-01'),
(404669,65336,'1996-03-01','1997-03-01'),
(404669,65326,'1997-03-01','1998-03-01'),
(404669,68651,'1998-03-01','1998-06-11'),
(406556,51208,'1993-11-09','1994-11-09'),
(406556,54433,'1994-11-09','1995-11-09'),
(406556,57263,'1995-11-09','1996-11-08'),
(406556,58276,'1996-11-08','1997-11-08'),
(406556,62447,'1997-11-08','1998-11-08');


INSERT INTO `salaries` VALUES (406556,63256,'1998-11-08','1999-11-08'),
(406556,66286,'1999-11-08','2000-11-07'),
(406556,69586,'2000-11-07','2001-11-07'),
(406556,72195,'2001-11-07','9999-01-01'),
(407401,54389,'1999-01-14','2000-01-14'),
(407401,58530,'2000-01-14','2001-01-13'),
(407401,61099,'2001-01-13','2002-01-13'),
(407401,63692,'2002-01-13','9999-01-01'),
(407481,47482,'1991-07-19','1992-07-18'),
(407481,48785,'1992-07-18','1993-07-18');


INSERT INTO `salaries` VALUES (407481,49656,'1993-07-18','1994-07-18'),
(407481,50277,'1994-07-18','1995-07-18'),
(407481,49983,'1995-07-18','1996-07-17'),
(407481,49524,'1996-07-17','1997-07-17'),
(407481,53874,'1997-07-17','1998-07-17'),
(407481,53674,'1998-07-17','1999-07-17'),
(407481,53745,'1999-07-17','2000-07-16'),
(407481,53315,'2000-07-16','2001-07-16'),
(407481,56136,'2001-07-16','2002-07-16'),
(407481,60371,'2002-07-16','9999-01-01');


INSERT INTO `salaries` VALUES (407937,66138,'1999-01-13','2000-01-13'),
(407937,69904,'2000-01-13','2001-01-12'),
(407937,70390,'2001-01-12','2002-01-12'),
(407937,72876,'2002-01-12','9999-01-01'),
(408371,63980,'1986-11-13','1987-11-13'),
(408371,64383,'1987-11-13','1988-11-12'),
(408371,67910,'1988-11-12','1989-11-12'),
(408371,67741,'1989-11-12','1990-11-12'),
(408371,68088,'1990-11-12','1991-11-12'),
(408371,68673,'1991-11-12','1992-11-11');


INSERT INTO `salaries` VALUES (408371,72426,'1992-11-11','1993-11-11'),
(408371,74546,'1993-11-11','1994-11-11'),
(408371,76971,'1994-11-11','1995-11-11'),
(408371,76905,'1995-11-11','1996-11-10'),
(408371,80472,'1996-11-10','1997-11-10'),
(408371,80878,'1997-11-10','1998-11-10'),
(408371,81540,'1998-11-10','1999-11-10'),
(408371,82841,'1999-11-10','2000-11-09'),
(408371,84139,'2000-11-09','2001-11-09'),
(408371,84455,'2001-11-09','9999-01-01');


INSERT INTO `salaries` VALUES (408886,52637,'1985-11-19','1986-11-19'),
(408886,56517,'1986-11-19','1987-11-19'),
(408886,59316,'1987-11-19','1988-11-18'),
(408886,60261,'1988-11-18','1989-11-18'),
(408886,63913,'1989-11-18','1990-11-18'),
(408886,65842,'1990-11-18','1991-11-18'),
(408886,65524,'1991-11-18','1992-11-17'),
(408886,65670,'1992-11-17','1993-11-17'),
(408886,68245,'1993-11-17','1994-11-17'),
(408886,69797,'1994-11-17','1995-11-17');


INSERT INTO `salaries` VALUES (408886,73380,'1995-11-17','1996-11-16'),
(408886,74757,'1996-11-16','1997-11-16'),
(408886,74560,'1997-11-16','1998-11-16'),
(408886,75041,'1998-11-16','1999-11-16'),
(408886,76903,'1999-11-16','2000-11-15'),
(408886,81183,'2000-11-15','2001-11-15'),
(408886,81043,'2001-11-15','9999-01-01'),
(409162,51830,'1988-07-22','1989-07-22'),
(409162,52461,'1989-07-22','1990-07-22'),
(409162,56690,'1990-07-22','1991-07-22');


INSERT INTO `salaries` VALUES (409162,58317,'1991-07-22','1992-07-21'),
(409162,58519,'1992-07-21','1993-07-21'),
(409162,61295,'1993-07-21','1994-07-21'),
(409162,65011,'1994-07-21','1995-07-21'),
(409162,67392,'1995-07-21','1996-07-20'),
(409162,70256,'1996-07-20','1997-07-20'),
(409162,72242,'1997-07-20','1998-07-20'),
(409162,74399,'1998-07-20','1999-07-20'),
(409162,74190,'1999-07-20','2000-07-19'),
(409162,77651,'2000-07-19','2001-07-19');


INSERT INTO `salaries` VALUES (409162,79710,'2001-07-19','2002-07-19'),
(409162,80572,'2002-07-19','9999-01-01'),
(409376,57001,'1997-12-13','1998-12-13'),
(409376,58423,'1998-12-13','1999-12-13'),
(409376,60005,'1999-12-13','2000-01-13'),
(409509,49098,'1988-03-01','1989-03-01'),
(409509,53196,'1989-03-01','1990-03-01'),
(409509,53110,'1990-03-01','1991-03-01'),
(409509,54517,'1991-03-01','1992-02-29'),
(409509,54809,'1992-02-29','1993-02-28');


INSERT INTO `salaries` VALUES (409509,57868,'1993-02-28','1994-02-28'),
(409509,60564,'1994-02-28','1995-02-28'),
(409509,62848,'1995-02-28','1996-02-28'),
(409509,65364,'1996-02-28','1997-02-27'),
(409509,66768,'1997-02-27','1998-02-27'),
(409509,69659,'1998-02-27','1999-02-27'),
(409509,72415,'1999-02-27','2000-02-27'),
(409509,75732,'2000-02-27','2001-02-26'),
(409509,79054,'2001-02-26','2002-02-26'),
(409509,80003,'2002-02-26','9999-01-01');


INSERT INTO `salaries` VALUES (409522,48092,'1992-05-10','1993-05-10'),
(409522,48610,'1993-05-10','1994-05-10'),
(409522,50619,'1994-05-10','1995-05-10'),
(409522,53262,'1995-05-10','1996-05-09'),
(409522,53891,'1996-05-09','1997-05-09'),
(409522,54743,'1997-05-09','1998-05-09'),
(409522,57782,'1998-05-09','1999-05-09'),
(409522,60997,'1999-05-09','2000-05-08'),
(409522,62909,'2000-05-08','2001-05-08'),
(409522,65659,'2001-05-08','2002-05-08');


INSERT INTO `salaries` VALUES (409522,68272,'2002-05-08','9999-01-01'),
(409928,83335,'1993-05-20','1994-05-20'),
(409928,84068,'1994-05-20','1995-05-20'),
(409928,87618,'1995-05-20','1996-05-19'),
(409928,90736,'1996-05-19','1997-05-19'),
(409928,91369,'1997-05-19','1998-05-19'),
(409928,90945,'1998-05-19','1999-05-19'),
(409928,95280,'1999-05-19','2000-05-18'),
(409928,95147,'2000-05-18','2000-07-26'),
(410062,57105,'1991-01-24','1992-01-24');


INSERT INTO `salaries` VALUES (410062,56913,'1992-01-24','1993-01-23'),
(410062,57277,'1993-01-23','1994-01-23'),
(410062,60424,'1994-01-23','1995-01-23'),
(410062,61490,'1995-01-23','1996-01-23'),
(410062,61919,'1996-01-23','1997-01-22'),
(410062,61559,'1997-01-22','1998-01-22'),
(410062,63408,'1998-01-22','1999-01-22'),
(410062,67215,'1999-01-22','2000-01-22'),
(410062,67052,'2000-01-22','2001-01-21'),
(410062,70256,'2001-01-21','2002-01-21');


INSERT INTO `salaries` VALUES (410062,73293,'2002-01-21','9999-01-01'),
(410236,40000,'1988-01-05','1989-01-04'),
(410236,43860,'1989-01-04','1990-01-04'),
(410236,47184,'1990-01-04','1991-01-04'),
(410236,47801,'1991-01-04','1992-01-04'),
(410236,49509,'1992-01-04','1993-01-03'),
(410236,51548,'1993-01-03','1994-01-03'),
(410236,53149,'1994-01-03','1995-01-03'),
(410236,57258,'1995-01-03','1996-01-03'),
(410236,60717,'1996-01-03','1997-01-02');


INSERT INTO `salaries` VALUES (410236,60264,'1997-01-02','1998-01-02'),
(410236,61068,'1998-01-02','1999-01-02'),
(410236,63239,'1999-01-02','1999-01-06'),
(410301,79890,'1993-12-21','1994-12-21'),
(410301,81347,'1994-12-21','1995-12-21'),
(410301,84935,'1995-12-21','1996-12-20'),
(410301,85534,'1996-12-20','1997-12-20'),
(410301,87706,'1997-12-20','1998-12-20'),
(410301,91304,'1998-12-20','1999-12-20'),
(410301,91138,'1999-12-20','2000-12-19');


INSERT INTO `salaries` VALUES (410301,95256,'2000-12-19','2001-12-19'),
(410301,97585,'2001-12-19','9999-01-01'),
(410949,55327,'1992-02-06','1993-02-05'),
(410949,56459,'1993-02-05','1994-02-05'),
(410949,57172,'1994-02-05','1995-02-05'),
(410949,61519,'1995-02-05','1996-02-05'),
(410949,65941,'1996-02-05','1997-02-04'),
(410949,66431,'1997-02-04','1997-10-30'),
(411006,46947,'1987-02-15','1988-02-15'),
(411006,49450,'1988-02-15','1989-02-14');


INSERT INTO `salaries` VALUES (411006,50456,'1989-02-14','1990-02-14'),
(411006,50427,'1990-02-14','1991-02-14'),
(411006,54185,'1991-02-14','1992-02-14'),
(411006,54169,'1992-02-14','1993-02-13'),
(411006,56480,'1993-02-13','1994-02-13'),
(411006,59536,'1994-02-13','1995-02-13'),
(411006,63701,'1995-02-13','1996-02-13'),
(411006,68153,'1996-02-13','1997-02-12'),
(411006,69172,'1997-02-12','1998-02-12'),
(411006,69368,'1998-02-12','1999-02-12');


INSERT INTO `salaries` VALUES (411006,69067,'1999-02-12','2000-02-12'),
(411006,68935,'2000-02-12','2001-02-11'),
(411006,69277,'2001-02-11','2002-02-11'),
(411006,71958,'2002-02-11','9999-01-01'),
(411065,49125,'1998-07-17','1999-07-17'),
(411065,51601,'1999-07-17','2000-07-16'),
(411065,51984,'2000-07-16','2001-07-16'),
(411065,54392,'2001-07-16','2002-07-16'),
(411065,56290,'2002-07-16','9999-01-01'),
(411670,65014,'1992-12-04','1993-12-04');


INSERT INTO `salaries` VALUES (411670,67103,'1993-12-04','1994-12-04'),
(411670,68804,'1994-12-04','1995-12-04'),
(411670,72629,'1995-12-04','1996-12-03'),
(411670,73677,'1996-12-03','1997-12-03'),
(411670,77648,'1997-12-03','1998-12-03'),
(411670,81756,'1998-12-03','1999-12-03'),
(411670,85924,'1999-12-03','2000-12-02'),
(411670,86476,'2000-12-02','2001-12-02'),
(411670,90637,'2001-12-02','9999-01-01'),
(411880,55403,'1997-07-08','1998-07-08');


INSERT INTO `salaries` VALUES (411880,57782,'1998-07-08','1999-07-08'),
(411880,60366,'1999-07-08','2000-07-07'),
(411880,62695,'2000-07-07','2001-07-07'),
(411880,62551,'2001-07-07','2002-07-07'),
(411880,65508,'2002-07-07','9999-01-01'),
(411954,40000,'1996-07-27','1997-07-27'),
(411954,41516,'1997-07-27','1998-07-27'),
(411954,43907,'1998-07-27','1999-07-27'),
(411954,46019,'1999-07-27','2000-07-26'),
(411954,49315,'2000-07-26','2001-07-26');


INSERT INTO `salaries` VALUES (411954,51434,'2001-07-26','2002-07-26'),
(411954,54271,'2002-07-26','9999-01-01'),
(411998,55416,'1993-09-09','1994-09-09'),
(411998,55025,'1994-09-09','1995-09-09'),
(411998,54586,'1995-09-09','1996-09-08'),
(411998,58051,'1996-09-08','1997-09-08'),
(411998,58784,'1997-09-08','1998-09-08'),
(411998,59169,'1998-09-08','1999-09-08'),
(411998,61855,'1999-09-08','2000-09-07'),
(411998,62785,'2000-09-07','2001-09-07');


INSERT INTO `salaries` VALUES (411998,63682,'2001-09-07','9999-01-01'),
(412876,53237,'1992-01-02','1993-01-01'),
(412876,55694,'1993-01-01','1994-01-01'),
(412876,58750,'1994-01-01','1995-01-01'),
(412876,59741,'1995-01-01','1996-01-01'),
(412876,61994,'1996-01-01','1996-12-31'),
(412876,65101,'1996-12-31','1997-12-31'),
(412876,67017,'1997-12-31','1998-12-31'),
(412876,70781,'1998-12-31','1999-12-31'),
(412876,70684,'1999-12-31','2000-12-30');


INSERT INTO `salaries` VALUES (412876,75077,'2000-12-30','2001-12-30'),
(412876,78873,'2001-12-30','9999-01-01'),
(413034,48179,'1988-11-30','1989-11-30'),
(413034,48368,'1989-11-30','1990-11-30'),
(413034,52521,'1990-11-30','1991-11-30'),
(413034,52721,'1991-11-30','1992-11-29'),
(413034,54293,'1992-11-29','1993-11-29'),
(413034,55028,'1993-11-29','1994-11-29'),
(413034,55633,'1994-11-29','1995-11-29'),
(413034,59949,'1995-11-29','1996-11-28');


INSERT INTO `salaries` VALUES (413034,64282,'1996-11-28','1997-11-28'),
(413034,67770,'1997-11-28','1998-11-28'),
(413034,69295,'1998-11-28','1999-11-28'),
(413034,71860,'1999-11-28','2000-11-27'),
(413034,73525,'2000-11-27','2001-11-27'),
(413034,74230,'2001-11-27','9999-01-01'),
(413054,73466,'1997-12-16','1998-12-16'),
(413054,74985,'1998-12-16','1999-12-16'),
(413054,76642,'1999-12-16','2000-12-15'),
(413054,78451,'2000-12-15','2001-12-15');


INSERT INTO `salaries` VALUES (413054,78954,'2001-12-15','9999-01-01'),
(413061,54279,'1993-10-17','1994-10-17'),
(413061,54298,'1994-10-17','1995-10-17'),
(413061,56301,'1995-10-17','1996-10-16'),
(413061,55851,'1996-10-16','1997-10-16'),
(413061,58317,'1997-10-16','1998-10-16'),
(413061,58932,'1998-10-16','1999-10-16'),
(413061,59867,'1999-10-16','2000-10-15'),
(413061,60900,'2000-10-15','2001-10-15'),
(413061,60719,'2001-10-15','9999-01-01');


INSERT INTO `salaries` VALUES (413392,40000,'1990-04-27','1991-04-27'),
(413392,44405,'1991-04-27','1992-04-26'),
(413392,45050,'1992-04-26','1993-04-26'),
(413392,44771,'1993-04-26','1994-04-26'),
(413392,46211,'1994-04-26','1995-04-26'),
(413392,49152,'1995-04-26','1996-04-25'),
(413392,51155,'1996-04-25','1997-04-25'),
(413392,55416,'1997-04-25','1998-04-25'),
(413392,55854,'1998-04-25','1999-04-25'),
(413392,55921,'1999-04-25','2000-04-24');


INSERT INTO `salaries` VALUES (413392,59474,'2000-04-24','2001-04-24'),
(413392,61486,'2001-04-24','2002-04-24'),
(413392,61747,'2002-04-24','9999-01-01'),
(413675,73972,'1997-06-22','1998-06-22'),
(413675,76334,'1998-06-22','1999-04-06'),
(413880,51406,'1994-02-22','1995-02-22'),
(413880,52964,'1995-02-22','1996-02-22'),
(413880,55660,'1996-02-22','1997-02-21'),
(413880,55515,'1997-02-21','1998-02-21'),
(413880,59997,'1998-02-21','1999-02-21');


INSERT INTO `salaries` VALUES (413880,61045,'1999-02-21','2000-02-21'),
(413880,61919,'2000-02-21','2001-02-20'),
(413880,62529,'2001-02-20','2002-02-20'),
(413880,65058,'2002-02-20','9999-01-01'),
(414068,55567,'1995-07-04','1996-07-03'),
(414068,56816,'1996-07-03','1997-07-03'),
(414068,59823,'1997-07-03','1998-07-03'),
(414068,64098,'1998-07-03','1999-07-03'),
(414068,67166,'1999-07-03','2000-07-02'),
(414068,69391,'2000-07-02','2001-07-02');


INSERT INTO `salaries` VALUES (414068,71288,'2001-07-02','2002-07-02'),
(414068,72667,'2002-07-02','9999-01-01'),
(414091,40000,'1997-08-19','1998-08-19'),
(414091,41756,'1998-08-19','1999-08-19'),
(414091,42216,'1999-08-19','2000-08-18'),
(414091,42407,'2000-08-18','2001-08-18'),
(414091,45304,'2001-08-18','9999-01-01'),
(414156,40000,'1998-12-04','1999-12-04'),
(414156,42563,'1999-12-04','2000-12-03'),
(414156,45259,'2000-12-03','2001-12-03');


INSERT INTO `salaries` VALUES (414156,49640,'2001-12-03','9999-01-01'),
(414922,59975,'1987-06-05','1988-06-04'),
(414922,60394,'1988-06-04','1989-06-04'),
(414922,64312,'1989-06-04','1990-06-04'),
(414922,67858,'1990-06-04','1991-06-04'),
(414922,70768,'1991-06-04','1992-06-03'),
(414922,74007,'1992-06-03','1993-06-03'),
(414922,76700,'1993-06-03','1994-06-03'),
(414922,78772,'1994-06-03','1995-06-03'),
(414922,79187,'1995-06-03','1996-06-02');


INSERT INTO `salaries` VALUES (414922,78984,'1996-06-02','1997-06-02'),
(414922,82100,'1997-06-02','1997-11-04'),
(415340,73522,'1991-08-03','1992-08-02'),
(415340,77142,'1992-08-02','1993-08-02'),
(415340,79637,'1993-08-02','1994-08-02'),
(415340,81400,'1994-08-02','1995-08-02'),
(415340,83611,'1995-08-02','1996-08-01'),
(415340,84256,'1996-08-01','1997-08-01'),
(415340,88575,'1997-08-01','1998-08-01'),
(415340,88130,'1998-08-01','1999-08-01');


INSERT INTO `salaries` VALUES (415340,88724,'1999-08-01','2000-07-31'),
(415340,90978,'2000-07-31','2001-07-31'),
(415340,92734,'2001-07-31','2002-07-31'),
(415340,93039,'2002-07-31','9999-01-01'),
(415511,84995,'1986-06-11','1987-06-11'),
(415511,87260,'1987-06-11','1988-06-10'),
(415511,89101,'1988-06-10','1989-06-10'),
(415511,91809,'1989-06-10','1990-06-10'),
(415511,93117,'1990-06-10','1991-06-10'),
(415511,93015,'1991-06-10','1992-06-09');


INSERT INTO `salaries` VALUES (415511,96143,'1992-06-09','1993-06-09'),
(415511,98821,'1993-06-09','1994-06-09'),
(415511,102242,'1994-06-09','1995-06-09'),
(415511,104618,'1995-06-09','1996-06-08'),
(415511,107433,'1996-06-08','1997-06-08'),
(415511,108692,'1997-06-08','1998-06-08'),
(415511,112839,'1998-06-08','1999-06-08'),
(415511,112364,'1999-06-08','2000-06-07'),
(415511,113026,'2000-06-07','2001-06-07'),
(415511,116975,'2001-06-07','2002-06-07');


INSERT INTO `salaries` VALUES (415511,117351,'2002-06-07','9999-01-01'),
(415796,54890,'1988-02-16','1989-02-15'),
(415796,57372,'1989-02-15','1990-02-15'),
(415796,60594,'1990-02-15','1991-02-15'),
(415796,63750,'1991-02-15','1992-02-15'),
(415796,63388,'1992-02-15','1993-02-14'),
(415796,67450,'1993-02-14','1994-02-14'),
(415796,70759,'1994-02-14','1995-02-14'),
(415796,75142,'1995-02-14','1996-02-14'),
(415796,74929,'1996-02-14','1997-02-13');


INSERT INTO `salaries` VALUES (415796,77646,'1997-02-13','1998-02-13'),
(415796,81230,'1998-02-13','1999-02-13'),
(415796,82500,'1999-02-13','2000-02-13'),
(415796,85450,'2000-02-13','2001-02-12'),
(415796,89121,'2001-02-12','2002-02-12'),
(415796,93257,'2002-02-12','9999-01-01'),
(415832,52258,'1998-10-12','1999-10-12'),
(415832,55524,'1999-10-12','2000-10-11'),
(415832,57698,'2000-10-11','2001-10-11'),
(415832,60949,'2001-10-11','9999-01-01');


INSERT INTO `salaries` VALUES (416009,78642,'1988-05-04','1989-05-04'),
(416009,79258,'1989-05-04','1990-05-04'),
(416009,81990,'1990-05-04','1991-05-04'),
(416009,83877,'1991-05-04','1992-05-03'),
(416009,86647,'1992-05-03','1993-05-03'),
(416009,88815,'1993-05-03','1994-05-03'),
(416009,92028,'1994-05-03','1995-05-03'),
(416009,91898,'1995-05-03','1996-05-02'),
(416009,95285,'1996-05-02','1997-05-02'),
(416009,97531,'1997-05-02','1998-05-02');


INSERT INTO `salaries` VALUES (416009,98093,'1998-05-02','1999-05-02'),
(416009,101853,'1999-05-02','2000-05-01'),
(416009,102155,'2000-05-01','2001-05-01'),
(416009,104647,'2001-05-01','2002-05-01'),
(416009,107257,'2002-05-01','9999-01-01'),
(416137,44443,'1999-07-16','2000-07-15'),
(416137,47158,'2000-07-15','2001-07-15'),
(416137,50849,'2001-07-15','2002-07-15'),
(416137,54362,'2002-07-15','9999-01-01'),
(416636,40000,'1995-02-01','1996-02-01');


INSERT INTO `salaries` VALUES (416636,42341,'1996-02-01','1997-01-31'),
(416636,43759,'1997-01-31','1998-01-31'),
(416636,47952,'1998-01-31','1999-01-31'),
(416636,48478,'1999-01-31','2000-01-31'),
(416636,51667,'2000-01-31','2001-01-30'),
(416636,52331,'2001-01-30','2002-01-30'),
(416636,54655,'2002-01-30','9999-01-01'),
(417262,51399,'1987-06-20','1988-06-19'),
(417262,54884,'1988-06-19','1989-06-19'),
(417262,55225,'1989-06-19','1990-06-19');


INSERT INTO `salaries` VALUES (417262,59527,'1990-06-19','1991-06-19'),
(417262,61851,'1991-06-19','1992-06-18'),
(417262,64625,'1992-06-18','1993-06-18'),
(417262,67791,'1993-06-18','1994-06-18'),
(417262,69183,'1994-06-18','1995-06-18'),
(417262,68692,'1995-06-18','1996-06-17'),
(417262,71242,'1996-06-17','1997-06-17'),
(417262,74620,'1997-06-17','1998-06-17'),
(417262,78572,'1998-06-17','1999-06-17'),
(417262,82250,'1999-06-17','2000-06-16');


INSERT INTO `salaries` VALUES (417262,85067,'2000-06-16','2001-06-16'),
(417262,89212,'2001-06-16','2002-06-16'),
(417262,91280,'2002-06-16','9999-01-01'),
(417486,57188,'1987-01-10','1988-01-10'),
(417486,61036,'1988-01-10','1989-01-09'),
(417486,63069,'1989-01-09','1990-01-09'),
(417486,64314,'1990-01-09','1991-01-09'),
(417486,66998,'1991-01-09','1992-01-09'),
(417486,70296,'1992-01-09','1993-01-08'),
(417486,74345,'1993-01-08','1994-01-08');


INSERT INTO `salaries` VALUES (417486,76529,'1994-01-08','1995-01-08'),
(417486,78085,'1995-01-08','1996-01-08'),
(417486,80109,'1996-01-08','1997-01-07'),
(417486,83755,'1997-01-07','1998-01-07'),
(417486,85638,'1998-01-07','1999-01-07'),
(417486,87110,'1999-01-07','2000-01-07'),
(417486,89524,'2000-01-07','2001-01-06'),
(417486,89137,'2001-01-06','2002-01-06'),
(417486,89711,'2002-01-06','9999-01-01'),
(417525,50049,'1988-02-11','1989-02-10');


INSERT INTO `salaries` VALUES (417525,52493,'1989-02-10','1990-02-10'),
(417525,53467,'1990-02-10','1991-02-10'),
(417525,54942,'1991-02-10','1992-02-10'),
(417525,56055,'1992-02-10','1993-02-09'),
(417525,58983,'1993-02-09','1994-02-09'),
(417525,59365,'1994-02-09','1994-07-22'),
(417812,63985,'1998-04-23','1999-04-23'),
(417812,64186,'1999-04-23','2000-04-22'),
(417812,67670,'2000-04-22','2001-04-22'),
(417812,69241,'2001-04-22','2002-04-22');


INSERT INTO `salaries` VALUES (417812,72062,'2002-04-22','9999-01-01'),
(417961,40000,'1986-07-28','1987-07-28'),
(417961,41817,'1987-07-28','1988-07-27'),
(417961,43654,'1988-07-27','1989-07-27'),
(417961,47051,'1989-07-27','1990-07-27'),
(417961,48132,'1990-07-27','1991-07-27'),
(417961,49568,'1991-07-27','1992-07-26'),
(417961,52434,'1992-07-26','1993-07-26'),
(417961,54884,'1993-07-26','1994-07-26'),
(417961,58715,'1994-07-26','1995-07-26');


INSERT INTO `salaries` VALUES (417961,61276,'1995-07-26','1996-07-25'),
(417961,61783,'1996-07-25','1997-07-25'),
(417961,62759,'1997-07-25','1998-07-25'),
(417961,64404,'1998-07-25','1999-07-25'),
(417961,67856,'1999-07-25','2000-07-24'),
(417961,70404,'2000-07-24','2001-07-24'),
(417961,73416,'2001-07-24','2002-07-24'),
(417961,75729,'2002-07-24','9999-01-01'),
(418171,48994,'1993-01-13','1994-01-13'),
(418171,51388,'1994-01-13','1995-01-13');


INSERT INTO `salaries` VALUES (418171,54302,'1995-01-13','1996-01-13'),
(418171,58801,'1996-01-13','1997-01-12'),
(418171,59061,'1997-01-12','1998-01-12'),
(418171,59486,'1998-01-12','1999-01-12'),
(418171,62229,'1999-01-12','2000-01-12'),
(418171,64929,'2000-01-12','2001-01-11'),
(418171,65508,'2001-01-11','2002-01-11'),
(418171,69404,'2002-01-11','9999-01-01'),
(419663,44072,'1992-04-24','1993-04-24'),
(419663,45481,'1993-04-24','1994-04-24');


INSERT INTO `salaries` VALUES (419663,47593,'1994-04-24','1995-04-24'),
(419663,49954,'1995-04-24','1996-04-23'),
(419663,53360,'1996-04-23','1997-04-23'),
(419663,53958,'1997-04-23','1998-04-23'),
(419663,54793,'1998-04-23','1999-04-23'),
(419663,54940,'1999-04-23','2000-04-22'),
(419663,55705,'2000-04-22','2001-04-22'),
(419663,56874,'2001-04-22','2002-04-22'),
(419663,56582,'2002-04-22','9999-01-01'),
(419770,40000,'1988-04-11','1989-04-11');


INSERT INTO `salaries` VALUES (419770,43648,'1989-04-11','1990-04-11'),
(419770,44576,'1990-04-11','1991-04-11'),
(419770,45880,'1991-04-11','1992-04-10'),
(419770,47065,'1992-04-10','1993-04-10'),
(419770,48816,'1993-04-10','1994-04-10'),
(419770,49286,'1994-04-10','1995-04-10'),
(419770,53716,'1995-04-10','1996-04-09'),
(419770,53684,'1996-04-09','1997-04-09'),
(419770,56663,'1997-04-09','1998-04-09'),
(419770,57650,'1998-04-09','1999-04-09');


INSERT INTO `salaries` VALUES (419770,59059,'1999-04-09','2000-04-08'),
(419770,60828,'2000-04-08','2001-04-08'),
(419770,60663,'2001-04-08','2002-04-08'),
(419770,61136,'2002-04-08','9999-01-01'),
(419925,40000,'1996-09-22','1997-09-22'),
(419925,43987,'1997-09-22','1998-09-22'),
(419925,48378,'1998-09-22','1999-09-22'),
(419925,50940,'1999-09-22','2000-09-21'),
(419925,52335,'2000-09-21','2001-09-21'),
(419925,54811,'2001-09-21','9999-01-01');


INSERT INTO `salaries` VALUES (420207,58018,'1992-04-05','1993-04-05'),
(420207,60109,'1993-04-05','1994-04-05'),
(420207,59752,'1994-04-05','1995-04-05'),
(420207,61835,'1995-04-05','1996-04-04'),
(420207,64347,'1996-04-04','1997-04-04'),
(420207,68521,'1997-04-04','1998-04-04'),
(420207,69966,'1998-04-04','1999-04-04'),
(420207,70064,'1999-04-04','2000-04-03'),
(420207,72586,'2000-04-03','2001-04-03'),
(420207,73941,'2001-04-03','2002-04-03');


INSERT INTO `salaries` VALUES (420207,75976,'2002-04-03','9999-01-01'),
(420252,53039,'1985-07-15','1986-07-15'),
(420252,54741,'1986-07-15','1987-07-15'),
(420252,54859,'1987-07-15','1988-07-14'),
(420252,56941,'1988-07-14','1989-07-14'),
(420252,56524,'1989-07-14','1990-07-14'),
(420252,56980,'1990-07-14','1991-07-14'),
(420252,57368,'1991-07-14','1992-07-13'),
(420252,59709,'1992-07-13','1993-07-13'),
(420252,60259,'1993-07-13','1994-07-13');


INSERT INTO `salaries` VALUES (420252,62273,'1994-07-13','1995-07-13'),
(420252,65751,'1995-07-13','1996-07-12'),
(420252,67423,'1996-07-12','1997-07-12'),
(420252,68877,'1997-07-12','1998-07-12'),
(420252,73255,'1998-07-12','1999-07-12'),
(420252,74053,'1999-07-12','2000-07-11'),
(420252,74059,'2000-07-11','2001-07-11'),
(420252,78069,'2001-07-11','2002-07-11'),
(420252,82039,'2002-07-11','9999-01-01'),
(420410,40000,'1993-11-03','1994-11-03');


INSERT INTO `salaries` VALUES (420410,42540,'1994-11-03','1995-11-03'),
(420410,46754,'1995-11-03','1996-11-02'),
(420410,50338,'1996-11-02','1997-11-02'),
(420410,51438,'1997-11-02','1998-11-02'),
(420410,52060,'1998-11-02','1999-11-02'),
(420410,52643,'1999-11-02','2000-03-02'),
(420997,69789,'1985-07-30','1986-07-30'),
(420997,71645,'1986-07-30','1987-07-30'),
(420997,75557,'1987-07-30','1988-07-29'),
(420997,76229,'1988-07-29','1989-07-29');


INSERT INTO `salaries` VALUES (420997,79705,'1989-07-29','1990-07-29'),
(420997,81384,'1990-07-29','1991-07-29'),
(420997,84680,'1991-07-29','1992-07-28'),
(420997,87004,'1992-07-28','1993-07-28'),
(420997,86923,'1993-07-28','1994-07-28'),
(420997,87115,'1994-07-28','1995-07-28'),
(420997,89614,'1995-07-28','1996-07-27'),
(420997,92686,'1996-07-27','1997-07-27'),
(420997,93362,'1997-07-27','1998-07-27'),
(420997,95542,'1998-07-27','1999-07-27');


INSERT INTO `salaries` VALUES (420997,98117,'1999-07-27','2000-07-26'),
(420997,98787,'2000-07-26','2001-07-26'),
(420997,100146,'2001-07-26','2002-07-26'),
(420997,104542,'2002-07-26','9999-01-01'),
(421163,79777,'1995-06-02','1996-06-01'),
(421163,80434,'1996-06-01','1997-06-01'),
(421163,83737,'1997-06-01','1998-06-01'),
(421163,84532,'1998-06-01','1999-06-01'),
(421163,87708,'1999-06-01','2000-05-31'),
(421163,90129,'2000-05-31','2001-05-31');


INSERT INTO `salaries` VALUES (421163,92658,'2001-05-31','2002-05-31'),
(421163,94426,'2002-05-31','9999-01-01'),
(421184,68897,'1993-10-03','1994-10-03'),
(421184,71814,'1994-10-03','1995-10-03'),
(421184,73351,'1995-10-03','1996-10-02'),
(421184,73570,'1996-10-02','1997-10-02'),
(421184,74095,'1997-10-02','1998-10-02'),
(421184,75592,'1998-10-02','1999-10-02'),
(421184,77353,'1999-10-02','2000-01-30'),
(421309,68762,'1988-02-16','1989-02-15');


INSERT INTO `salaries` VALUES (421309,70869,'1989-02-15','1990-02-15'),
(421309,72106,'1990-02-15','1991-02-15'),
(421309,72656,'1991-02-15','1992-02-15'),
(421309,72715,'1992-02-15','1993-02-14'),
(421309,73962,'1993-02-14','1994-02-14'),
(421309,75106,'1994-02-14','1995-02-14'),
(421309,78802,'1995-02-14','1996-02-14'),
(421309,78485,'1996-02-14','1997-02-13'),
(421309,80605,'1997-02-13','1998-02-13'),
(421309,80408,'1998-02-13','1999-02-13');


INSERT INTO `salaries` VALUES (421309,79915,'1999-02-13','2000-02-13'),
(421309,83887,'2000-02-13','2001-02-12'),
(421309,85227,'2001-02-12','2002-02-12'),
(421309,88209,'2002-02-12','9999-01-01'),
(421547,40000,'1997-01-26','1998-01-26'),
(421547,42083,'1998-01-26','1999-01-26'),
(421547,45608,'1999-01-26','2000-01-26'),
(421547,45659,'2000-01-26','2000-12-03'),
(421753,74364,'1986-01-04','1987-01-04'),
(421753,78533,'1987-01-04','1988-01-04');


INSERT INTO `salaries` VALUES (421753,81698,'1988-01-04','1989-01-03'),
(421753,85446,'1989-01-03','1990-01-03'),
(421753,87303,'1990-01-03','1991-01-03'),
(421753,90866,'1991-01-03','1992-01-03'),
(421753,94884,'1992-01-03','1993-01-02'),
(421753,94557,'1993-01-02','1994-01-02'),
(421753,94349,'1994-01-02','1995-01-02'),
(421753,96699,'1995-01-02','1996-01-02'),
(421753,100257,'1996-01-02','1997-01-01'),
(421753,100224,'1997-01-01','1998-01-01');


INSERT INTO `salaries` VALUES (421753,102683,'1998-01-01','1999-01-01'),
(421753,104897,'1999-01-01','2000-01-01'),
(421753,107038,'2000-01-01','2000-12-31'),
(421753,109772,'2000-12-31','2001-12-31'),
(421753,109686,'2001-12-31','9999-01-01'),
(421822,55356,'1993-08-22','1994-08-22'),
(421822,57260,'1994-08-22','1995-08-22'),
(421822,59889,'1995-08-22','1996-08-21'),
(421822,63786,'1996-08-21','1997-08-21'),
(421822,65362,'1997-08-21','1998-08-21');


INSERT INTO `salaries` VALUES (421822,69080,'1998-08-21','1999-08-21'),
(421822,70474,'1999-08-21','2000-08-20'),
(421822,74820,'2000-08-20','2001-08-20'),
(421822,74623,'2001-08-20','9999-01-01'),
(422051,53766,'1988-10-20','1989-10-20'),
(422051,58264,'1989-10-20','1990-10-20'),
(422051,62251,'1990-10-20','1991-10-20'),
(422051,63125,'1991-10-20','1992-10-19'),
(422051,63066,'1992-10-19','1993-10-19'),
(422051,65692,'1993-10-19','1994-10-19');


INSERT INTO `salaries` VALUES (422051,66855,'1994-10-19','1995-10-19'),
(422051,68447,'1995-10-19','1996-10-18'),
(422051,72673,'1996-10-18','1997-10-18'),
(422051,72820,'1997-10-18','1998-10-18'),
(422051,74180,'1998-10-18','1999-10-18'),
(422051,74214,'1999-10-18','2000-10-17'),
(422051,76677,'2000-10-17','2001-10-17'),
(422051,79162,'2001-10-17','9999-01-01'),
(422053,40000,'1990-07-24','1991-07-24'),
(422053,41485,'1991-07-24','1992-07-23');


INSERT INTO `salaries` VALUES (422053,43120,'1992-07-23','1993-07-23'),
(422053,42682,'1993-07-23','1994-07-23'),
(422053,46614,'1994-07-23','1995-07-23'),
(422053,47701,'1995-07-23','1996-07-22'),
(422053,48957,'1996-07-22','1997-07-22'),
(422053,49452,'1997-07-22','1998-07-22'),
(422053,52797,'1998-07-22','1999-07-22'),
(422053,53930,'1999-07-22','2000-07-21'),
(422053,56300,'2000-07-21','2001-07-21'),
(422053,56044,'2001-07-21','2002-07-21');


INSERT INTO `salaries` VALUES (422053,55838,'2002-07-21','9999-01-01'),
(422871,40000,'1991-08-11','1992-08-10'),
(422871,43106,'1992-08-10','1993-08-10'),
(422871,47305,'1993-08-10','1994-08-10'),
(422871,47815,'1994-08-10','1995-08-10'),
(422871,49969,'1995-08-10','1996-04-27'),
(422875,50331,'1989-01-30','1990-01-30'),
(422875,50119,'1990-01-30','1991-01-30'),
(422875,51959,'1991-01-30','1992-01-30'),
(422875,55181,'1992-01-30','1993-01-29');


INSERT INTO `salaries` VALUES (422875,59298,'1993-01-29','1994-01-29'),
(422875,60514,'1994-01-29','1995-01-29'),
(422875,63356,'1995-01-29','1996-01-29'),
(422875,63711,'1996-01-29','1997-01-28'),
(422875,67118,'1997-01-28','1998-01-28'),
(422875,68489,'1998-01-28','1999-01-28'),
(422875,69793,'1999-01-28','2000-01-28'),
(422875,72657,'2000-01-28','2001-01-27'),
(422875,73933,'2001-01-27','2002-01-27'),
(422875,74329,'2002-01-27','9999-01-01');


INSERT INTO `salaries` VALUES (423062,65844,'1995-10-31','1996-10-30'),
(423062,66522,'1996-10-30','1997-10-30'),
(423062,67590,'1997-10-30','1998-10-30'),
(423062,70469,'1998-10-30','1999-10-30'),
(423062,70976,'1999-10-30','2000-10-29'),
(423062,73261,'2000-10-29','2001-10-29'),
(423062,75839,'2001-10-29','9999-01-01'),
(423711,40000,'1996-05-05','1997-05-05'),
(423711,42822,'1997-05-05','1998-05-05'),
(423711,46547,'1998-05-05','1999-05-05');


INSERT INTO `salaries` VALUES (423711,51005,'1999-05-05','2000-05-04'),
(423711,53761,'2000-05-04','2001-05-04'),
(423711,57725,'2001-05-04','2002-03-01'),
(424207,58824,'1994-05-28','1995-05-28'),
(424207,59510,'1995-05-28','1996-05-27'),
(424207,60969,'1996-05-27','1997-05-27'),
(424207,63910,'1997-05-27','1998-05-27'),
(424207,64851,'1998-05-27','1999-05-27'),
(424207,66087,'1999-05-27','2000-05-26'),
(424207,70511,'2000-05-26','2001-05-26');


INSERT INTO `salaries` VALUES (424207,70669,'2001-05-26','2002-05-26'),
(424207,70396,'2002-05-26','9999-01-01'),
(424569,67193,'1997-10-30','1998-10-30'),
(424569,68835,'1998-10-30','1999-10-30'),
(424569,70756,'1999-10-30','2000-10-29'),
(424569,74739,'2000-10-29','2001-10-29'),
(424569,78400,'2001-10-29','9999-01-01'),
(424598,40000,'1993-04-15','1994-04-15'),
(424598,41584,'1994-04-15','1995-04-15'),
(424598,44530,'1995-04-15','1996-04-14');


INSERT INTO `salaries` VALUES (424598,47702,'1996-04-14','1997-04-14'),
(424598,47351,'1997-04-14','1998-04-14'),
(424598,50972,'1998-04-14','1999-04-14'),
(424598,53588,'1999-04-14','2000-04-13'),
(424598,57726,'2000-04-13','2001-04-13'),
(424598,61603,'2001-04-13','2002-04-13'),
(424598,62123,'2002-04-13','9999-01-01'),
(424692,40000,'1992-09-07','1993-04-13'),
(424806,63357,'1989-06-27','1990-06-27'),
(424806,66294,'1990-06-27','1991-06-27');


INSERT INTO `salaries` VALUES (424806,69158,'1991-06-27','1992-06-26'),
(424806,71370,'1992-06-26','1993-06-26'),
(424806,75556,'1993-06-26','1994-06-26'),
(424806,79325,'1994-06-26','1995-06-26'),
(424806,82233,'1995-06-26','1996-06-25'),
(424806,84318,'1996-06-25','1997-06-25'),
(424806,84306,'1997-06-25','1998-06-25'),
(424806,88377,'1998-06-25','1999-06-25'),
(424806,92072,'1999-06-25','2000-06-24'),
(424806,96285,'2000-06-24','2001-06-24');


INSERT INTO `salaries` VALUES (424806,96672,'2001-06-24','2002-06-24'),
(424806,100531,'2002-06-24','9999-01-01'),
(425308,59056,'1986-12-15','1987-12-15'),
(425308,59005,'1987-12-15','1988-12-14'),
(425308,63375,'1988-12-14','1989-12-14'),
(425308,65030,'1989-12-14','1990-12-14'),
(425308,67683,'1990-12-14','1991-12-14'),
(425308,69967,'1991-12-14','1992-12-13'),
(425308,71892,'1992-12-13','1993-12-13'),
(425308,72050,'1993-12-13','1994-12-13');


INSERT INTO `salaries` VALUES (425308,73735,'1994-12-13','1995-12-13'),
(425308,77658,'1995-12-13','1996-12-12'),
(425308,81395,'1996-12-12','1997-12-12'),
(425308,85614,'1997-12-12','1998-12-12'),
(425308,86362,'1998-12-12','1999-12-12'),
(425308,86888,'1999-12-12','2000-12-11'),
(425308,88258,'2000-12-11','2001-12-11'),
(425308,92086,'2001-12-11','9999-01-01'),
(425361,45697,'1994-06-30','1995-06-30'),
(425361,48955,'1995-06-30','1996-06-29');


INSERT INTO `salaries` VALUES (425361,48974,'1996-06-29','1997-06-29'),
(425361,53171,'1997-06-29','1998-06-29'),
(425361,56724,'1998-06-29','1999-06-29'),
(425361,57324,'1999-06-29','2000-06-28'),
(425361,57219,'2000-06-28','2001-06-28'),
(425361,61144,'2001-06-28','2002-06-28'),
(425361,63106,'2002-06-28','9999-01-01'),
(425779,42917,'1994-06-06','1995-06-06'),
(425779,44634,'1995-06-06','1996-06-05'),
(425779,45379,'1996-06-05','1997-06-05');


INSERT INTO `salaries` VALUES (425779,49644,'1997-06-05','1998-06-05'),
(425779,52328,'1998-06-05','1999-06-05'),
(425779,53411,'1999-06-05','2000-06-04'),
(425779,55156,'2000-06-04','2001-06-04'),
(425779,57835,'2001-06-04','2002-06-04'),
(425779,59161,'2002-06-04','9999-01-01'),
(425970,45137,'1996-10-07','1997-10-07'),
(425970,48151,'1997-10-07','1998-10-07'),
(425970,51180,'1998-10-07','1999-10-07'),
(425970,55002,'1999-10-07','2000-10-06');


INSERT INTO `salaries` VALUES (425970,55017,'2000-10-06','2001-10-06'),
(425970,58004,'2001-10-06','9999-01-01'),
(426100,44578,'1996-05-13','1996-07-18'),
(426483,56973,'1997-07-28','1998-07-28'),
(426483,60048,'1998-07-28','1999-07-28'),
(426483,62030,'1999-07-28','2000-07-27'),
(426483,63089,'2000-07-27','2001-07-27'),
(426483,63181,'2001-07-27','2002-07-27'),
(426483,65458,'2002-07-27','9999-01-01'),
(427267,40000,'1999-12-04','2000-12-03');


INSERT INTO `salaries` VALUES (427267,44256,'2000-12-03','2001-12-03'),
(427267,45852,'2001-12-03','9999-01-01'),
(427502,40000,'1999-02-11','2000-02-11'),
(427502,40113,'2000-02-11','2001-02-10'),
(427502,41134,'2001-02-10','2002-02-10'),
(427502,44880,'2002-02-10','9999-01-01'),
(427812,62131,'1999-08-15','2000-08-14'),
(427812,65470,'2000-08-14','2001-08-14'),
(427812,67153,'2001-08-14','9999-01-01'),
(427918,50244,'1985-10-13','1986-10-13');


INSERT INTO `salaries` VALUES (427918,50917,'1986-10-13','1987-10-13'),
(427918,52217,'1987-10-13','1988-10-12'),
(427918,53109,'1988-10-12','1989-10-12'),
(427918,55866,'1989-10-12','1990-10-12'),
(427918,59304,'1990-10-12','1991-10-12'),
(427918,60664,'1991-10-12','1992-10-11'),
(427918,64795,'1992-10-11','1993-10-11'),
(427918,67568,'1993-10-11','1994-10-11'),
(427918,71388,'1994-10-11','1995-10-11'),
(427918,71061,'1995-10-11','1996-10-10');


INSERT INTO `salaries` VALUES (427918,75181,'1996-10-10','1997-10-10'),
(427918,76053,'1997-10-10','1998-10-10'),
(427918,77498,'1998-10-10','1999-10-10'),
(427918,79267,'1999-10-10','2000-10-09'),
(427918,79910,'2000-10-09','2001-10-09'),
(427918,80603,'2001-10-09','9999-01-01'),
(428296,61574,'1997-08-15','1998-08-15'),
(428296,65525,'1998-08-15','1999-08-15'),
(428296,69260,'1999-08-15','2000-08-14'),
(428296,69119,'2000-08-14','2001-08-14');


INSERT INTO `salaries` VALUES (428296,72214,'2001-08-14','9999-01-01'),
(428342,88908,'1992-09-17','1993-09-17'),
(428342,91902,'1993-09-17','1994-09-17'),
(428342,92158,'1994-09-17','1995-09-17'),
(428342,95872,'1995-09-17','1996-09-16'),
(428342,98232,'1996-09-16','1997-09-16'),
(428342,98277,'1997-09-16','1998-09-16'),
(428342,99044,'1998-09-16','1999-09-16'),
(428342,100226,'1999-09-16','2000-09-15'),
(428342,104614,'2000-09-15','2001-09-15');


INSERT INTO `salaries` VALUES (428342,104710,'2001-09-15','9999-01-01'),
(428479,45266,'1999-03-31','2000-03-30'),
(428479,47638,'2000-03-30','2001-03-30'),
(428479,51445,'2001-03-30','2002-03-30'),
(428479,51957,'2002-03-30','9999-01-01'),
(428505,40000,'1990-09-30','1991-09-30'),
(428505,42429,'1991-09-30','1992-09-29'),
(428505,43954,'1992-09-29','1993-09-29'),
(428505,45459,'1993-09-29','1994-09-29'),
(428505,47597,'1994-09-29','1995-09-29');


INSERT INTO `salaries` VALUES (428505,50006,'1995-09-29','1996-09-28'),
(428505,54434,'1996-09-28','1997-09-28'),
(428505,54110,'1997-09-28','1998-09-28'),
(428505,53798,'1998-09-28','1999-09-28'),
(428505,53627,'1999-09-28','2000-09-27'),
(428505,58069,'2000-09-27','2001-09-27'),
(428505,59500,'2001-09-27','9999-01-01'),
(428595,52423,'1990-01-31','1991-01-31'),
(428595,54902,'1991-01-31','1992-01-31'),
(428595,59045,'1992-01-31','1993-01-30');


INSERT INTO `salaries` VALUES (428595,59546,'1993-01-30','1994-01-30'),
(428595,60405,'1994-01-30','1995-01-30'),
(428595,60018,'1995-01-30','1996-01-30'),
(428595,62965,'1996-01-30','1997-01-29'),
(428595,67132,'1997-01-29','1998-01-29'),
(428595,71096,'1998-01-29','1999-01-29'),
(428595,71548,'1999-01-29','2000-01-29'),
(428595,74705,'2000-01-29','2001-01-28'),
(428595,79137,'2001-01-28','2002-01-28'),
(428595,79360,'2002-01-28','9999-01-01');


INSERT INTO `salaries` VALUES (428772,45194,'1995-11-24','1996-01-08'),
(429487,41052,'1997-06-28','1998-06-28'),
(429487,44060,'1998-06-28','1999-06-28'),
(429487,44841,'1999-06-28','2000-06-27'),
(429487,44927,'2000-06-27','2001-06-27'),
(429487,49191,'2001-06-27','2002-06-27'),
(429487,50611,'2002-06-27','9999-01-01'),
(429666,40000,'1994-06-19','1995-06-19'),
(429666,40125,'1995-06-19','1996-06-18'),
(429666,40463,'1996-06-18','1997-06-18');


INSERT INTO `salaries` VALUES (429666,40604,'1997-06-18','1998-06-18'),
(429666,43522,'1998-06-18','1999-06-18'),
(429666,47517,'1999-06-18','2000-06-17'),
(429666,51965,'2000-06-17','2001-06-17'),
(429666,54458,'2001-06-17','2002-06-17'),
(429666,55575,'2002-06-17','9999-01-01'),
(429675,66024,'1998-10-31','1999-10-31'),
(429675,66535,'1999-10-31','2000-10-30'),
(429675,70985,'2000-10-30','2001-10-30'),
(429675,71424,'2001-10-30','9999-01-01');


INSERT INTO `salaries` VALUES (429710,52465,'1990-01-05','1991-01-05'),
(429710,54875,'1991-01-05','1992-01-05'),
(429710,55025,'1992-01-05','1993-01-04'),
(429710,56427,'1993-01-04','1994-01-04'),
(429710,57197,'1994-01-04','1995-01-04'),
(429710,57787,'1995-01-04','1996-01-04'),
(429710,60788,'1996-01-04','1997-01-03'),
(429710,63131,'1997-01-03','1998-01-03'),
(429710,63377,'1998-01-03','1999-01-03'),
(429710,64723,'1999-01-03','2000-01-03');


INSERT INTO `salaries` VALUES (429710,66685,'2000-01-03','2001-01-02'),
(429710,67076,'2001-01-02','2002-01-02'),
(429710,67828,'2002-01-02','9999-01-01'),
(430218,68600,'1995-09-23','1996-09-22'),
(430218,72719,'1996-09-22','1997-09-22'),
(430218,76839,'1997-09-22','1998-09-22'),
(430218,80629,'1998-09-22','1999-09-22'),
(430218,83594,'1999-09-22','2000-09-21'),
(430218,87153,'2000-09-21','2001-09-21'),
(430218,89033,'2001-09-21','9999-01-01');


INSERT INTO `salaries` VALUES (430595,40000,'1994-07-24','1995-07-24'),
(430595,42065,'1995-07-24','1996-07-23'),
(430595,45293,'1996-07-23','1997-07-23'),
(430595,46040,'1997-07-23','1998-07-23'),
(430595,47945,'1998-07-23','1999-02-15'),
(430823,40000,'1993-07-01','1994-07-01'),
(430823,40592,'1994-07-01','1995-07-01'),
(430823,41014,'1995-07-01','1996-06-30'),
(430823,44046,'1996-06-30','1997-06-30'),
(430823,46378,'1997-06-30','1998-06-30');


INSERT INTO `salaries` VALUES (430823,50289,'1998-06-30','1999-06-30'),
(430823,54466,'1999-06-30','2000-06-29'),
(430823,54539,'2000-06-29','2001-06-29'),
(430823,56796,'2001-06-29','2002-06-29'),
(430823,57706,'2002-06-29','9999-01-01'),
(430908,40000,'1990-06-23','1991-06-23'),
(430908,43316,'1991-06-23','1992-06-22'),
(430908,47265,'1992-06-22','1992-12-13'),
(431599,44756,'1987-10-22','1988-10-21'),
(431599,45782,'1988-10-21','1989-10-21');


INSERT INTO `salaries` VALUES (431599,45770,'1989-10-21','1990-10-21'),
(431599,47946,'1990-10-21','1991-10-21'),
(431599,49382,'1991-10-21','1992-10-20'),
(431599,51992,'1992-10-20','1993-10-20'),
(431599,55803,'1993-10-20','1994-10-20'),
(431599,55501,'1994-10-20','1995-10-20'),
(431599,58329,'1995-10-20','1996-10-19'),
(431599,60165,'1996-10-19','1997-10-19'),
(431599,59851,'1997-10-19','1998-10-19'),
(431599,63410,'1998-10-19','1999-10-19');


INSERT INTO `salaries` VALUES (431599,63485,'1999-10-19','2000-10-18'),
(431599,65286,'2000-10-18','2001-10-18'),
(431599,68345,'2001-10-18','9999-01-01'),
(431625,60297,'1999-06-30','2000-06-29'),
(431625,62315,'2000-06-29','2001-06-29'),
(431625,65906,'2001-06-29','2002-06-29'),
(431625,65920,'2002-06-29','9999-01-01'),
(431732,55029,'1990-12-05','1991-12-05'),
(431732,55794,'1991-12-05','1992-12-04'),
(431732,57260,'1992-12-04','1993-12-04');


INSERT INTO `salaries` VALUES (431732,59199,'1993-12-04','1994-12-04'),
(431732,59483,'1994-12-04','1995-12-04'),
(431732,61190,'1995-12-04','1996-12-03'),
(431732,61910,'1996-12-03','1997-12-03'),
(431732,61573,'1997-12-03','1998-12-03'),
(431732,62413,'1998-12-03','1999-12-03'),
(431732,64313,'1999-12-03','2000-12-02'),
(431732,66642,'2000-12-02','2001-12-02'),
(431732,67602,'2001-12-02','9999-01-01'),
(431795,73096,'2000-01-19','2001-01-18');


INSERT INTO `salaries` VALUES (431795,72742,'2001-01-18','2002-01-18'),
(431795,72516,'2002-01-18','2002-06-02'),
(431831,40000,'1996-02-27','1997-02-26'),
(431831,42871,'1997-02-26','1998-02-26'),
(431831,44207,'1998-02-26','1999-02-26'),
(431831,44360,'1999-02-26','2000-02-26'),
(431831,44505,'2000-02-26','2001-02-25'),
(431831,48342,'2001-02-25','2002-02-25'),
(431831,50466,'2002-02-25','9999-01-01'),
(432011,62239,'1986-04-19','1987-04-19');


INSERT INTO `salaries` VALUES (432011,65410,'1987-04-19','1988-04-18'),
(432011,67032,'1988-04-18','1989-04-18'),
(432011,69602,'1989-04-18','1990-04-18'),
(432011,71337,'1990-04-18','1991-04-18'),
(432011,75370,'1991-04-18','1992-04-17'),
(432011,75904,'1992-04-17','1993-04-17'),
(432011,79550,'1993-04-17','1994-04-17'),
(432011,79194,'1994-04-17','1995-04-17'),
(432011,79597,'1995-04-17','1996-04-16'),
(432011,80301,'1996-04-16','1997-04-16');


INSERT INTO `salaries` VALUES (432011,83662,'1997-04-16','1998-04-16'),
(432011,86795,'1998-04-16','1999-04-16'),
(432011,91021,'1999-04-16','2000-04-15'),
(432011,92550,'2000-04-15','2001-04-15'),
(432011,92867,'2001-04-15','2002-04-15'),
(432011,92889,'2002-04-15','9999-01-01'),
(432089,56890,'1989-12-30','1990-12-30'),
(432089,58401,'1990-12-30','1991-12-30'),
(432089,58013,'1991-12-30','1992-12-29'),
(432089,60321,'1992-12-29','1993-12-29');


INSERT INTO `salaries` VALUES (432089,63525,'1993-12-29','1994-12-29'),
(432089,67539,'1994-12-29','1995-12-29'),
(432089,68049,'1995-12-29','1996-12-28'),
(432089,68063,'1996-12-28','1997-12-28'),
(432089,70956,'1997-12-28','1998-12-28'),
(432089,71180,'1998-12-28','1999-12-28'),
(432089,71783,'1999-12-28','2000-12-27'),
(432089,75207,'2000-12-27','2001-12-27'),
(432089,76954,'2001-12-27','2002-01-11'),
(432304,40000,'1991-06-01','1992-05-31');


INSERT INTO `salaries` VALUES (432304,41238,'1992-05-31','1993-05-31'),
(432304,41439,'1993-05-31','1994-05-31'),
(432304,44383,'1994-05-31','1995-05-31'),
(432304,47197,'1995-05-31','1996-05-30'),
(432304,49108,'1996-05-30','1997-05-30'),
(432304,53396,'1997-05-30','1998-05-30'),
(432304,54523,'1998-05-30','1999-05-30'),
(432304,56871,'1999-05-30','2000-05-29'),
(432304,57002,'2000-05-29','2001-05-29'),
(432304,58004,'2001-05-29','2002-05-29');


INSERT INTO `salaries` VALUES (432304,58023,'2002-05-29','9999-01-01'),
(432591,53202,'1988-01-29','1989-01-28'),
(432591,54412,'1989-01-28','1990-01-28'),
(432591,56072,'1990-01-28','1991-01-28'),
(432591,56585,'1991-01-28','1992-01-28'),
(432591,57822,'1992-01-28','1993-01-27'),
(432591,61068,'1993-01-27','1994-01-27'),
(432591,63567,'1994-01-27','1995-01-27'),
(432591,66390,'1995-01-27','1996-01-27'),
(432591,65983,'1996-01-27','1997-01-26');


INSERT INTO `salaries` VALUES (432591,68036,'1997-01-26','1998-01-26'),
(432591,70932,'1998-01-26','1999-01-26'),
(432591,75234,'1999-01-26','2000-01-26'),
(432591,75118,'2000-01-26','2001-01-25'),
(432591,77467,'2001-01-25','2002-01-25'),
(432591,81535,'2002-01-25','9999-01-01'),
(433763,56404,'1987-09-22','1988-09-21'),
(433763,58087,'1988-09-21','1989-09-21'),
(433763,60727,'1989-09-21','1990-09-21'),
(433763,64745,'1990-09-21','1991-09-21');


INSERT INTO `salaries` VALUES (433763,64798,'1991-09-21','1992-09-20'),
(433763,66696,'1992-09-20','1993-09-20'),
(433763,67727,'1993-09-20','1994-09-20'),
(433763,71008,'1994-09-20','1995-09-20'),
(433763,74553,'1995-09-20','1996-09-19'),
(433763,76471,'1996-09-19','1997-09-19'),
(433763,79675,'1997-09-19','1998-09-19'),
(433763,83825,'1998-09-19','1999-09-19'),
(433763,83726,'1999-09-19','2000-09-18'),
(433763,84506,'2000-09-18','2001-09-18');


INSERT INTO `salaries` VALUES (433763,84534,'2001-09-18','9999-01-01'),
(434095,72104,'1994-01-20','1995-01-20'),
(434095,74199,'1995-01-20','1996-01-20'),
(434095,74826,'1996-01-20','1997-01-19'),
(434095,79278,'1997-01-19','1997-10-14'),
(434948,40000,'1987-08-31','1988-08-30'),
(434948,41855,'1988-08-30','1989-08-30'),
(434948,42965,'1989-08-30','1990-08-30'),
(434948,43124,'1990-08-30','1991-08-30'),
(434948,44761,'1991-08-30','1992-08-29');


INSERT INTO `salaries` VALUES (434948,47826,'1992-08-29','1993-08-29'),
(434948,48228,'1993-08-29','1994-08-29'),
(434948,48279,'1994-08-29','1995-08-29'),
(434948,48061,'1995-08-29','1996-08-28'),
(434948,51562,'1996-08-28','1997-08-28'),
(434948,52957,'1997-08-28','1998-08-28'),
(434948,56233,'1998-08-28','1999-08-28'),
(434948,58751,'1999-08-28','2000-08-27'),
(434948,61135,'2000-08-27','2001-08-27'),
(434948,62101,'2001-08-27','9999-01-01');


INSERT INTO `salaries` VALUES (435178,56432,'1996-07-12','1997-07-12'),
(435178,58419,'1997-07-12','1998-07-12'),
(435178,61586,'1998-07-12','1999-07-12'),
(435178,61239,'1999-07-12','2000-07-11'),
(435178,61108,'2000-07-11','2001-07-11'),
(435178,61221,'2001-07-11','2002-07-11'),
(435178,62489,'2002-07-11','9999-01-01'),
(435490,57242,'1999-04-05','2000-04-04'),
(435490,58879,'2000-04-04','2001-04-04'),
(435490,60762,'2001-04-04','2002-04-03');


INSERT INTO `salaries` VALUES (435490,63477,'2002-04-03','9999-01-01'),
(435942,61319,'1999-12-20','2000-12-19'),
(435942,61255,'2000-12-19','2001-12-19'),
(435942,62685,'2001-12-19','9999-01-01'),
(436169,40000,'1988-10-31','1989-10-31'),
(436169,42167,'1989-10-31','1990-10-31'),
(436169,44568,'1990-10-31','1991-10-31'),
(436169,44827,'1991-10-31','1992-10-30'),
(436169,49017,'1992-10-30','1993-10-30'),
(436169,52316,'1993-10-30','1994-10-30');


INSERT INTO `salaries` VALUES (436169,53879,'1994-10-30','1995-10-30'),
(436169,55823,'1995-10-30','1996-10-29'),
(436169,59831,'1996-10-29','1997-10-29'),
(436169,63472,'1997-10-29','1998-10-29'),
(436169,63128,'1998-10-29','1999-10-29'),
(436169,62631,'1999-10-29','2000-10-28'),
(436169,66062,'2000-10-28','2001-10-28'),
(436169,68166,'2001-10-28','9999-01-01'),
(436175,45994,'1989-12-03','1990-12-03'),
(436175,48557,'1990-12-03','1991-12-03');


INSERT INTO `salaries` VALUES (436175,52251,'1991-12-03','1992-12-02'),
(436175,55761,'1992-12-02','1993-12-02'),
(436175,55310,'1993-12-02','1994-12-02'),
(436175,58558,'1994-12-02','1995-12-02'),
(436175,62757,'1995-12-02','1996-12-01'),
(436175,64577,'1996-12-01','1997-12-01'),
(436175,65648,'1997-12-01','1998-12-01'),
(436175,69388,'1998-12-01','1999-12-01'),
(436175,69424,'1999-12-01','2000-11-30'),
(436175,72466,'2000-11-30','2001-11-30');


INSERT INTO `salaries` VALUES (436175,76232,'2001-11-30','9999-01-01'),
(436326,40000,'1993-06-15','1994-01-10'),
(436684,42992,'1988-03-28','1989-03-28'),
(436684,44608,'1989-03-28','1990-03-28'),
(436684,46695,'1990-03-28','1991-03-28'),
(436684,48453,'1991-03-28','1992-03-27'),
(436684,49164,'1992-03-27','1993-03-27'),
(436684,51651,'1993-03-27','1994-03-27'),
(436684,54563,'1994-03-27','1995-03-27'),
(436684,57723,'1995-03-27','1996-03-26');


INSERT INTO `salaries` VALUES (436684,59539,'1996-03-26','1997-03-26'),
(436684,60357,'1997-03-26','1998-03-26'),
(436684,62037,'1998-03-26','1999-03-26'),
(436684,63903,'1999-03-26','2000-03-25'),
(436684,65173,'2000-03-25','2001-03-25'),
(436684,65397,'2001-03-25','2002-03-25'),
(436684,65914,'2002-03-25','9999-01-01'),
(437693,40000,'1988-08-23','1989-08-23'),
(437693,41618,'1989-08-23','1990-08-23'),
(437693,44437,'1990-08-23','1991-08-23');


INSERT INTO `salaries` VALUES (437693,46240,'1991-08-23','1992-08-22'),
(437693,46349,'1992-08-22','1993-08-22'),
(437693,50164,'1993-08-22','1994-08-22'),
(437693,53468,'1994-08-22','1995-08-22'),
(437693,54299,'1995-08-22','1996-08-21'),
(437693,58280,'1996-08-21','1997-08-21'),
(437693,58232,'1997-08-21','1998-08-21'),
(437693,61355,'1998-08-21','1999-08-21'),
(437693,61831,'1999-08-21','2000-08-20'),
(437693,62086,'2000-08-20','2001-08-20');


INSERT INTO `salaries` VALUES (437693,64314,'2001-08-20','9999-01-01'),
(437857,83364,'1995-02-23','1996-02-23'),
(437857,87059,'1996-02-23','1997-02-22'),
(437857,89916,'1997-02-22','1998-02-22'),
(437857,93346,'1998-02-22','1999-02-22'),
(437857,97489,'1999-02-22','2000-02-22'),
(437857,97795,'2000-02-22','2001-02-21'),
(437857,99091,'2001-02-21','2002-02-21'),
(437857,101110,'2002-02-21','9999-01-01'),
(437869,61967,'1993-12-15','1994-12-15');


INSERT INTO `salaries` VALUES (437869,65970,'1994-12-15','1995-12-15'),
(437869,68190,'1995-12-15','1996-12-14'),
(437869,67963,'1996-12-14','1997-12-14'),
(437869,69858,'1997-12-14','1998-12-14'),
(437869,69675,'1998-12-14','1999-12-14'),
(437869,73016,'1999-12-14','2000-12-13'),
(437869,75758,'2000-12-13','2001-12-13'),
(437869,77543,'2001-12-13','9999-01-01'),
(438019,40000,'1996-08-23','1997-06-06'),
(438369,44689,'1992-11-20','1993-11-20');


INSERT INTO `salaries` VALUES (438369,47178,'1993-11-20','1994-11-20'),
(438369,47554,'1994-11-20','1995-11-20'),
(438369,49549,'1995-11-20','1996-11-19'),
(438369,49555,'1996-11-19','1997-11-19'),
(438369,49985,'1997-11-19','1998-11-19'),
(438369,53706,'1998-11-19','1999-11-19'),
(438369,56432,'1999-11-19','2000-11-18'),
(438369,56305,'2000-11-18','2001-11-18'),
(438369,57482,'2001-11-18','9999-01-01'),
(438435,40000,'1987-12-19','1988-12-18');


INSERT INTO `salaries` VALUES (438435,44059,'1988-12-18','1989-12-18'),
(438435,47297,'1989-12-18','1990-12-18'),
(438435,46851,'1990-12-18','1991-12-18'),
(438435,49185,'1991-12-18','1992-12-17'),
(438435,50408,'1992-12-17','1993-12-17'),
(438435,50156,'1993-12-17','1994-12-17'),
(438435,53413,'1994-12-17','1995-12-17'),
(438435,54938,'1995-12-17','1996-12-16'),
(438435,58035,'1996-12-16','1997-12-16'),
(438435,60381,'1997-12-16','1998-12-16');


INSERT INTO `salaries` VALUES (438435,63281,'1998-12-16','1999-12-16'),
(438435,66224,'1999-12-16','2000-12-15'),
(438435,70454,'2000-12-15','2001-12-15'),
(438435,70226,'2001-12-15','9999-01-01'),
(438531,46998,'1996-06-29','1997-03-28'),
(438707,86806,'1997-09-16','1998-09-16'),
(438707,89631,'1998-09-16','1999-09-16'),
(438707,93580,'1999-09-16','2000-09-15'),
(438707,95944,'2000-09-15','2001-09-15'),
(438707,99397,'2001-09-15','9999-01-01');


INSERT INTO `salaries` VALUES (438745,42040,'1987-08-29','1988-08-28'),
(438745,41702,'1988-08-28','1989-08-28'),
(438745,44134,'1989-08-28','1990-08-28'),
(438745,47060,'1990-08-28','1991-08-28'),
(438745,48413,'1991-08-28','1992-08-27'),
(438745,52732,'1992-08-27','1993-08-27'),
(438745,53606,'1993-08-27','1994-08-27'),
(438745,53210,'1994-08-27','1995-08-27'),
(438745,56529,'1995-08-27','1996-08-26'),
(438745,60022,'1996-08-26','1997-08-26');


INSERT INTO `salaries` VALUES (438745,62743,'1997-08-26','1998-08-26'),
(438745,63204,'1998-08-26','1999-08-26'),
(438745,63110,'1999-08-26','2000-08-25'),
(438745,64698,'2000-08-25','2001-08-25'),
(438745,66819,'2001-08-25','9999-01-01'),
(439293,54031,'1986-08-11','1987-08-11'),
(439293,57249,'1987-08-11','1988-08-10'),
(439293,59259,'1988-08-10','1989-08-10'),
(439293,59426,'1989-08-10','1990-08-10'),
(439293,60034,'1990-08-10','1991-08-10');


INSERT INTO `salaries` VALUES (439293,63747,'1991-08-10','1992-08-09'),
(439293,67704,'1992-08-09','1993-08-09'),
(439293,67833,'1993-08-09','1994-08-09'),
(439293,68810,'1994-08-09','1995-08-09'),
(439293,72635,'1995-08-09','1996-08-08'),
(439293,73159,'1996-08-08','1997-08-08'),
(439293,75937,'1997-08-08','1998-08-08'),
(439293,80431,'1998-08-08','1999-08-08'),
(439293,81831,'1999-08-08','2000-08-07'),
(439293,85415,'2000-08-07','2001-08-07');


INSERT INTO `salaries` VALUES (439293,88845,'2001-08-07','9999-01-01'),
(439463,40000,'1990-02-02','1991-02-02'),
(439463,42794,'1991-02-02','1992-02-02'),
(439463,47283,'1992-02-02','1993-02-01'),
(439463,46994,'1993-02-01','1994-02-01'),
(439463,49175,'1994-02-01','1995-02-01'),
(439463,48837,'1995-02-01','1996-02-01'),
(439463,48602,'1996-02-01','1997-01-31'),
(439463,50940,'1997-01-31','1998-01-31'),
(439463,52344,'1998-01-31','1999-01-31');


INSERT INTO `salaries` VALUES (439463,53844,'1999-01-31','2000-01-31'),
(439463,54571,'2000-01-31','2001-01-30'),
(439463,56444,'2001-01-30','2002-01-30'),
(439463,58399,'2002-01-30','9999-01-01'),
(439537,58093,'1988-12-12','1989-12-12'),
(439537,60499,'1989-12-12','1990-12-12'),
(439537,64051,'1990-12-12','1991-12-12'),
(439537,66294,'1991-12-12','1992-12-11'),
(439537,65973,'1992-12-11','1993-12-11'),
(439537,68403,'1993-12-11','1994-12-11');


INSERT INTO `salaries` VALUES (439537,69625,'1994-12-11','1995-12-11'),
(439537,73588,'1995-12-11','1996-12-10'),
(439537,76878,'1996-12-10','1997-12-10'),
(439537,78727,'1997-12-10','1998-12-10'),
(439537,79413,'1998-12-10','1999-12-10'),
(439537,80209,'1999-12-10','2000-12-09'),
(439537,81174,'2000-12-09','2001-12-09'),
(439537,81620,'2001-12-09','9999-01-01'),
(439693,41201,'1986-03-20','1987-03-20'),
(439693,45357,'1987-03-20','1988-03-19');


INSERT INTO `salaries` VALUES (439693,46208,'1988-03-19','1989-03-19'),
(439693,48594,'1989-03-19','1990-03-19'),
(439693,51283,'1990-03-19','1991-03-19'),
(439693,53015,'1991-03-19','1992-03-18'),
(439693,54681,'1992-03-18','1993-03-18'),
(439693,57845,'1993-03-18','1994-03-18'),
(439693,60302,'1994-03-18','1995-03-18'),
(439693,62619,'1995-03-18','1996-03-17'),
(439693,65895,'1996-03-17','1997-03-17'),
(439693,66386,'1997-03-17','1998-03-17');


INSERT INTO `salaries` VALUES (439693,69164,'1998-03-17','1999-03-17'),
(439693,70974,'1999-03-17','2000-03-16'),
(439693,73894,'2000-03-16','2001-03-16'),
(439693,76741,'2001-03-16','2002-03-16'),
(439693,77861,'2002-03-16','9999-01-01'),
(440249,44111,'1992-08-28','1993-08-28'),
(440249,44825,'1993-08-28','1994-08-28'),
(440249,48280,'1994-08-28','1995-08-28'),
(440249,51637,'1995-08-28','1996-08-27'),
(440249,52717,'1996-08-27','1996-11-10');


INSERT INTO `salaries` VALUES (440546,40634,'1999-12-01','2000-11-30'),
(440546,41421,'2000-11-30','2001-11-30'),
(440546,45921,'2001-11-30','9999-01-01'),
(440846,45530,'1997-10-02','1998-10-02'),
(440846,48432,'1998-10-02','1999-10-02'),
(440846,52883,'1999-10-02','2000-10-01'),
(440846,54232,'2000-10-01','2001-10-01'),
(440846,58241,'2001-10-01','9999-01-01'),
(441011,68622,'1995-03-04','1996-03-03'),
(441011,69367,'1996-03-03','1997-03-03');


INSERT INTO `salaries` VALUES (441011,70469,'1997-03-03','1998-03-03'),
(441011,71140,'1998-03-03','1999-03-03'),
(441011,71778,'1999-03-03','2000-03-02'),
(441011,72197,'2000-03-02','2001-03-02'),
(441011,72191,'2001-03-02','2002-03-02'),
(441011,76241,'2002-03-02','9999-01-01'),
(441307,73785,'1990-08-15','1991-08-15'),
(441307,75114,'1991-08-15','1992-08-14'),
(441307,78925,'1992-08-14','1993-08-14'),
(441307,80748,'1993-08-14','1994-08-14');


INSERT INTO `salaries` VALUES (441307,82976,'1994-08-14','1995-08-14'),
(441307,83478,'1995-08-14','1996-08-13'),
(441307,84427,'1996-08-13','1997-08-13'),
(441307,86908,'1997-08-13','1998-08-13'),
(441307,86537,'1998-08-13','1999-08-13'),
(441307,89505,'1999-08-13','2000-08-12'),
(441307,90853,'2000-08-12','2001-08-12'),
(441307,92152,'2001-08-12','9999-01-01'),
(441907,78162,'1992-03-18','1993-03-18'),
(441907,81029,'1993-03-18','1994-03-18');


INSERT INTO `salaries` VALUES (441907,85048,'1994-03-18','1995-03-18'),
(441907,89193,'1995-03-18','1996-03-17'),
(441907,91270,'1996-03-17','1997-03-17'),
(441907,95424,'1997-03-17','1998-03-17'),
(441907,96517,'1998-03-17','1999-03-17'),
(441907,98384,'1999-03-17','2000-03-16'),
(441907,99311,'2000-03-16','2001-03-16'),
(441907,103636,'2001-03-16','2002-03-16'),
(441907,104371,'2002-03-16','9999-01-01'),
(442038,52499,'1985-07-20','1986-07-20');


INSERT INTO `salaries` VALUES (442038,54543,'1986-07-20','1987-07-20'),
(442038,57182,'1987-07-20','1988-07-19'),
(442038,60640,'1988-07-19','1989-07-19'),
(442038,60701,'1989-07-19','1990-07-19'),
(442038,61832,'1990-07-19','1991-07-19'),
(442038,66305,'1991-07-19','1992-07-18'),
(442038,68401,'1992-07-18','1993-07-18'),
(442038,68598,'1993-07-18','1994-07-18'),
(442038,68148,'1994-07-18','1995-07-18'),
(442038,70012,'1995-07-18','1996-07-17');


INSERT INTO `salaries` VALUES (442038,72558,'1996-07-17','1997-07-17'),
(442038,75988,'1997-07-17','1998-07-17'),
(442038,77648,'1998-07-17','1999-07-17'),
(442038,81005,'1999-07-17','2000-07-16'),
(442038,84345,'2000-07-16','2001-07-16'),
(442038,83912,'2001-07-16','2002-07-16'),
(442038,87057,'2002-07-16','9999-01-01'),
(442184,45890,'1993-11-08','1994-11-08'),
(442184,50292,'1994-11-08','1995-11-08'),
(442184,53725,'1995-11-08','1996-11-07');


INSERT INTO `salaries` VALUES (442184,53384,'1996-11-07','1997-11-07'),
(442184,57186,'1997-11-07','1998-11-07'),
(442184,57731,'1998-11-07','1999-11-07'),
(442184,59080,'1999-11-07','2000-11-06'),
(442184,59968,'2000-11-06','2001-11-06'),
(442184,61231,'2001-11-06','9999-01-01'),
(442333,40000,'1989-02-12','1990-02-12'),
(442333,39563,'1990-02-12','1991-02-12'),
(442333,41465,'1991-02-12','1992-02-12'),
(442333,42089,'1992-02-12','1993-02-11');


INSERT INTO `salaries` VALUES (442333,44535,'1993-02-11','1994-02-11'),
(442333,45802,'1994-02-11','1995-02-11'),
(442333,50253,'1995-02-11','1996-02-11'),
(442333,53296,'1996-02-11','1997-02-10'),
(442333,55388,'1997-02-10','1998-02-10'),
(442333,58260,'1998-02-10','1999-02-10'),
(442333,60259,'1999-02-10','2000-02-10'),
(442333,61506,'2000-02-10','2001-02-09'),
(442333,61498,'2001-02-09','2002-02-09'),
(442333,61812,'2002-02-09','9999-01-01');


INSERT INTO `salaries` VALUES (442526,40000,'1987-08-30','1988-08-29'),
(442526,42501,'1988-08-29','1989-08-29'),
(442526,43247,'1989-08-29','1990-08-29'),
(442526,43503,'1990-08-29','1991-08-29'),
(442526,45696,'1991-08-29','1992-08-28'),
(442526,45651,'1992-08-28','1993-08-28'),
(442526,47625,'1993-08-28','1994-08-28'),
(442526,48259,'1994-08-28','1995-08-28'),
(442526,50417,'1995-08-28','1996-08-27'),
(442526,52142,'1996-08-27','1997-08-27');


INSERT INTO `salaries` VALUES (442526,53350,'1997-08-27','1998-08-27'),
(442526,53903,'1998-08-27','1999-08-27'),
(442526,56110,'1999-08-27','2000-08-26'),
(442526,57017,'2000-08-26','2001-08-26'),
(442526,57513,'2001-08-26','9999-01-01'),
(443533,49339,'1992-03-11','1993-03-11'),
(443533,49910,'1993-03-11','1994-03-11'),
(443533,54011,'1994-03-11','1995-03-11'),
(443533,55176,'1995-03-11','1996-03-10'),
(443533,57594,'1996-03-10','1997-03-10');


INSERT INTO `salaries` VALUES (443533,59284,'1997-03-10','1998-03-10'),
(443533,62824,'1998-03-10','1999-03-10'),
(443533,65281,'1999-03-10','2000-03-09'),
(443533,68336,'2000-03-09','2001-03-09'),
(443533,68459,'2001-03-09','2002-03-09'),
(443533,70595,'2002-03-09','9999-01-01'),
(443582,48733,'1993-01-29','1994-01-29'),
(443582,49386,'1994-01-29','1995-01-29'),
(443582,53414,'1995-01-29','1996-01-29'),
(443582,53382,'1996-01-29','1997-01-28');


INSERT INTO `salaries` VALUES (443582,52911,'1997-01-28','1998-01-28'),
(443582,56656,'1998-01-28','1999-01-28'),
(443582,61143,'1999-01-28','2000-01-28'),
(443582,63831,'2000-01-28','2001-01-27'),
(443582,67009,'2001-01-27','2002-01-27'),
(443582,70290,'2002-01-27','9999-01-01'),
(443617,53259,'1986-12-07','1987-12-07'),
(443617,54223,'1987-12-07','1988-12-06'),
(443617,55783,'1988-12-06','1989-12-06'),
(443617,55488,'1989-12-06','1990-12-06');


INSERT INTO `salaries` VALUES (443617,58239,'1990-12-06','1991-12-06'),
(443617,60548,'1991-12-06','1992-12-05'),
(443617,62077,'1992-12-05','1993-12-05'),
(443617,62956,'1993-12-05','1994-12-05'),
(443617,67299,'1994-12-05','1995-12-05'),
(443617,68680,'1995-12-05','1996-12-04'),
(443617,72668,'1996-12-04','1997-12-04'),
(443617,76093,'1997-12-04','1998-12-04'),
(443617,79413,'1998-12-04','1999-12-04'),
(443617,83889,'1999-12-04','2000-12-03');


INSERT INTO `salaries` VALUES (443617,86666,'2000-12-03','2001-12-03'),
(443617,90669,'2001-12-03','9999-01-01'),
(443703,40000,'1985-11-13','1986-11-13'),
(443703,43489,'1986-11-13','1987-11-13'),
(443703,43278,'1987-11-13','1988-11-12'),
(443703,46862,'1988-11-12','1989-11-12'),
(443703,50799,'1989-11-12','1990-11-12'),
(443703,54230,'1990-11-12','1991-11-12'),
(443703,56083,'1991-11-12','1992-11-11'),
(443703,59130,'1992-11-11','1993-11-11');


INSERT INTO `salaries` VALUES (443703,60368,'1993-11-11','1994-11-11'),
(443703,63983,'1994-11-11','1995-11-11'),
(443703,65874,'1995-11-11','1996-11-10'),
(443703,67251,'1996-11-10','1997-11-10'),
(443703,69874,'1997-11-10','1998-11-10'),
(443703,72151,'1998-11-10','1999-11-10'),
(443703,75126,'1999-11-10','2000-11-09'),
(443703,75340,'2000-11-09','2001-11-09'),
(443703,77209,'2001-11-09','9999-01-01'),
(443763,40000,'1997-01-31','1997-07-10');


INSERT INTO `salaries` VALUES (443787,62519,'1986-04-01','1987-04-01'),
(443787,65035,'1987-04-01','1988-03-31'),
(443787,69208,'1988-03-31','1989-03-31'),
(443787,72808,'1989-03-31','1990-03-31'),
(443787,76878,'1990-03-31','1991-03-31'),
(443787,81187,'1991-03-31','1991-12-04'),
(444254,40000,'1988-09-21','1989-09-21'),
(444254,43371,'1989-09-21','1990-09-21'),
(444254,43418,'1990-09-21','1991-09-21'),
(444254,43543,'1991-09-21','1992-09-20');


INSERT INTO `salaries` VALUES (444254,45803,'1992-09-20','1993-09-20'),
(444254,45794,'1993-09-20','1994-09-20'),
(444254,49179,'1994-09-20','1995-09-20'),
(444254,50583,'1995-09-20','1996-09-19'),
(444254,52869,'1996-09-19','1997-09-19'),
(444254,56616,'1997-09-19','1998-09-17'),
(444831,61763,'1996-09-03','1997-09-03'),
(444831,65248,'1997-09-03','1998-09-03'),
(444831,69297,'1998-09-03','1999-09-03'),
(444831,69625,'1999-09-03','2000-09-02');


INSERT INTO `salaries` VALUES (444831,73627,'2000-09-02','2001-09-02'),
(444831,76782,'2001-09-02','9999-01-01'),
(445023,80716,'1988-07-21','1989-07-21'),
(445023,80791,'1989-07-21','1990-07-21'),
(445023,80750,'1990-07-21','1991-07-21'),
(445023,81025,'1991-07-21','1992-07-20'),
(445023,82094,'1992-07-20','1993-07-20'),
(445023,85294,'1993-07-20','1994-07-20'),
(445023,85086,'1994-07-20','1995-07-20'),
(445023,88403,'1995-07-20','1996-07-19');


INSERT INTO `salaries` VALUES (445023,91161,'1996-07-19','1997-07-19'),
(445023,94887,'1997-07-19','1998-07-19'),
(445023,95820,'1998-07-19','1999-07-19'),
(445023,100077,'1999-07-19','2000-07-18'),
(445023,101870,'2000-07-18','2001-07-18'),
(445023,105775,'2001-07-18','2002-07-18'),
(445023,108425,'2002-07-18','9999-01-01'),
(445368,72475,'1991-03-19','1992-03-18'),
(445368,73692,'1992-03-18','1992-09-29'),
(445708,48725,'1987-07-20','1988-07-19');


INSERT INTO `salaries` VALUES (445708,50934,'1988-07-19','1989-07-19'),
(445708,55168,'1989-07-19','1989-09-15'),
(446075,64504,'1997-08-28','1998-08-28'),
(446075,65729,'1998-08-28','1999-08-28'),
(446075,67315,'1999-08-28','2000-08-27'),
(446075,67006,'2000-08-27','2001-08-27'),
(446075,69542,'2001-08-27','9999-01-01'),
(446124,40000,'1986-05-05','1987-05-05'),
(446124,40617,'1987-05-05','1988-05-04'),
(446124,42322,'1988-05-04','1989-05-04');


INSERT INTO `salaries` VALUES (446124,43038,'1989-05-04','1990-05-04'),
(446124,46693,'1990-05-04','1991-05-04'),
(446124,47643,'1991-05-04','1992-05-03'),
(446124,48331,'1992-05-03','1993-05-03'),
(446124,49747,'1993-05-03','1993-05-30'),
(446345,71524,'1993-06-19','1994-06-19'),
(446345,72361,'1994-06-19','1995-06-19'),
(446345,75257,'1995-06-19','1996-06-18'),
(446345,75937,'1996-06-18','1997-06-18'),
(446345,80010,'1997-06-18','1998-06-18');


INSERT INTO `salaries` VALUES (446345,82934,'1998-06-18','1999-06-18'),
(446345,86962,'1999-06-18','2000-06-17'),
(446345,89113,'2000-06-17','2001-06-17'),
(446345,90071,'2001-06-17','2002-06-17'),
(446345,90640,'2002-06-17','9999-01-01'),
(446396,40000,'1990-04-13','1991-04-13'),
(446396,40195,'1991-04-13','1992-04-12'),
(446396,39996,'1992-04-12','1993-04-12'),
(446396,41460,'1993-04-12','1994-04-12'),
(446396,41746,'1994-04-12','1995-04-12');


INSERT INTO `salaries` VALUES (446396,44005,'1995-04-12','1996-04-11'),
(446396,45770,'1996-04-11','1997-04-11'),
(446396,48239,'1997-04-11','1997-08-24'),
(446552,45053,'1985-02-06','1986-02-06'),
(446552,47987,'1986-02-06','1987-02-06'),
(446552,47501,'1987-02-06','1988-02-06'),
(446552,49801,'1988-02-06','1989-02-05'),
(446552,52624,'1989-02-05','1990-02-05'),
(446552,54906,'1990-02-05','1991-02-05'),
(446552,57191,'1991-02-05','1992-02-05');


INSERT INTO `salaries` VALUES (446552,56718,'1992-02-05','1993-02-04'),
(446552,60706,'1993-02-04','1994-02-04'),
(446552,61486,'1994-02-04','1995-02-04'),
(446552,65090,'1995-02-04','1996-02-04'),
(446552,68530,'1996-02-04','1997-02-03'),
(446552,71297,'1997-02-03','1998-02-03'),
(446552,74357,'1998-02-03','1999-02-03'),
(446552,78607,'1999-02-03','2000-02-03'),
(446552,82545,'2000-02-03','2001-02-02'),
(446552,86440,'2001-02-02','2002-02-02');


INSERT INTO `salaries` VALUES (446552,87337,'2002-02-02','9999-01-01'),
(446653,65615,'1992-09-04','1993-09-04'),
(446653,68234,'1993-09-04','1994-09-04'),
(446653,71631,'1994-09-04','1995-09-04'),
(446653,73870,'1995-09-04','1996-09-03'),
(446653,74553,'1996-09-03','1997-09-03'),
(446653,77317,'1997-09-03','1998-09-03'),
(446653,78845,'1998-09-03','1999-09-03'),
(446653,78772,'1999-09-03','2000-09-02'),
(446653,78837,'2000-09-02','2001-09-02');


INSERT INTO `salaries` VALUES (446653,78542,'2001-09-02','9999-01-01'),
(446753,46876,'1996-07-27','1997-07-27'),
(446753,48975,'1997-07-27','1998-07-27'),
(446753,52672,'1998-07-27','1999-07-27'),
(446753,54733,'1999-07-27','2000-07-26'),
(446753,56249,'2000-07-26','2001-07-26'),
(446753,57136,'2001-07-26','2002-07-26'),
(446753,56689,'2002-07-26','9999-01-01'),
(447555,49708,'1989-09-26','1990-09-26'),
(447555,50294,'1990-09-26','1991-09-26');


INSERT INTO `salaries` VALUES (447555,54435,'1991-09-26','1992-09-25'),
(447555,58366,'1992-09-25','1993-09-25'),
(447555,60890,'1993-09-25','1994-09-25'),
(447555,61195,'1994-09-25','1995-09-25'),
(447555,61336,'1995-09-25','1996-09-24'),
(447555,65192,'1996-09-24','1997-09-24'),
(447555,66073,'1997-09-24','1998-09-24'),
(447555,67538,'1998-09-24','1999-09-24'),
(447555,70356,'1999-09-24','2000-09-23'),
(447555,74089,'2000-09-23','2001-09-23');


INSERT INTO `salaries` VALUES (447555,75301,'2001-09-23','9999-01-01'),
(447791,43953,'1996-04-29','1997-04-29'),
(447791,47287,'1997-04-29','1998-04-29'),
(447791,46788,'1998-04-29','1999-04-29'),
(447791,49673,'1999-04-29','2000-04-28'),
(447791,49658,'2000-04-28','2001-04-28'),
(447791,52619,'2001-04-28','2002-04-28'),
(447791,56509,'2002-04-28','9999-01-01'),
(447950,73904,'1988-08-18','1989-08-18'),
(447950,75825,'1989-08-18','1990-08-18');


INSERT INTO `salaries` VALUES (447950,79232,'1990-08-18','1991-08-18'),
(447950,81890,'1991-08-18','1992-08-17'),
(447950,81964,'1992-08-17','1993-08-17'),
(447950,84362,'1993-08-17','1994-08-17'),
(447950,84608,'1994-08-17','1995-08-17'),
(447950,87000,'1995-08-17','1996-08-16'),
(447950,91066,'1996-08-16','1997-08-16'),
(447950,94175,'1997-08-16','1998-08-16'),
(447950,94437,'1998-08-16','1999-08-16'),
(447950,95688,'1999-08-16','2000-08-15');


INSERT INTO `salaries` VALUES (447950,97077,'2000-08-15','2001-08-15'),
(447950,98173,'2001-08-15','9999-01-01'),
(447951,47268,'1988-10-30','1989-10-29'),
(447951,48643,'1989-10-29','1990-10-29'),
(447951,52007,'1990-10-29','1991-10-29'),
(447951,56176,'1991-10-29','1992-10-28'),
(447951,55706,'1992-10-28','1993-10-29'),
(447951,56569,'1993-10-29','1994-10-29'),
(447951,60075,'1994-10-29','1995-10-29'),
(447951,60614,'1995-10-29','1996-10-27');


INSERT INTO `salaries` VALUES (447951,62274,'1996-10-27','1997-10-27'),
(447951,63704,'1997-10-27','1998-10-27'),
(447951,67724,'1998-10-27','1999-10-28'),
(447951,70787,'1999-10-28','2000-10-27'),
(447951,71009,'2000-10-27','2001-10-27'),
(447951,73338,'2001-10-27','9999-01-01'),
(448061,62788,'1985-05-22','1986-05-22'),
(448061,62910,'1986-05-22','1987-05-22'),
(448061,65177,'1987-05-22','1988-05-21'),
(448061,64684,'1988-05-21','1988-09-01');


INSERT INTO `salaries` VALUES (448100,50196,'1990-06-23','1991-06-23'),
(448100,54060,'1991-06-23','1992-06-22'),
(448100,58536,'1992-06-22','1993-06-22'),
(448100,60934,'1993-06-22','1994-06-22'),
(448100,60935,'1994-06-22','1995-06-22'),
(448100,64668,'1995-06-22','1996-06-21'),
(448100,64350,'1996-06-21','1997-06-21'),
(448100,66064,'1997-06-21','1998-06-21'),
(448100,67387,'1998-06-21','1999-06-21'),
(448100,69300,'1999-06-21','2000-06-20');


INSERT INTO `salaries` VALUES (448100,72215,'2000-06-20','2001-06-20'),
(448100,75766,'2001-06-20','2002-06-20'),
(448100,78542,'2002-06-20','9999-01-01'),
(448258,40000,'1994-10-04','1995-10-04'),
(448258,39895,'1995-10-04','1996-10-03'),
(448258,44090,'1996-10-03','1997-10-03'),
(448258,45732,'1997-10-03','1998-10-03'),
(448258,49574,'1998-10-03','1999-10-03'),
(448258,49785,'1999-10-03','2000-10-02'),
(448258,50393,'2000-10-02','2001-10-02');


INSERT INTO `salaries` VALUES (448258,51358,'2001-10-02','9999-01-01'),
(448842,55085,'1995-12-22','1996-12-21'),
(448842,58841,'1996-12-21','1997-12-21'),
(448842,62473,'1997-12-21','1998-12-21'),
(448842,62070,'1998-12-21','1999-12-21'),
(448842,63554,'1999-12-21','2000-12-20'),
(448842,64317,'2000-12-20','2001-12-20'),
(448842,65742,'2001-12-20','9999-01-01'),
(449084,40000,'1985-06-25','1986-06-25'),
(449084,41109,'1986-06-25','1987-06-25');


INSERT INTO `salaries` VALUES (449084,41491,'1987-06-25','1988-06-24'),
(449084,45071,'1988-06-24','1989-06-24'),
(449084,46456,'1989-06-24','1990-06-24'),
(449084,49490,'1990-06-24','1991-06-24'),
(449084,53798,'1991-06-24','1992-06-23'),
(449084,56190,'1992-06-23','1993-06-23'),
(449084,55843,'1993-06-23','1994-06-23'),
(449084,56722,'1994-06-23','1995-06-23'),
(449084,57929,'1995-06-23','1996-06-22'),
(449084,60299,'1996-06-22','1997-06-22');


INSERT INTO `salaries` VALUES (449084,62727,'1997-06-22','1998-06-22'),
(449084,64508,'1998-06-22','1999-06-22'),
(449084,64711,'1999-06-22','2000-06-21'),
(449084,67405,'2000-06-21','2001-06-21'),
(449084,70835,'2001-06-21','2002-06-21'),
(449084,71654,'2002-06-21','9999-01-01'),
(449160,80105,'1997-12-09','1998-12-09'),
(449160,83042,'1998-12-09','1999-12-09'),
(449160,87443,'1999-12-09','2000-12-08'),
(449160,89295,'2000-12-08','2001-12-08');


INSERT INTO `salaries` VALUES (449160,92888,'2001-12-08','9999-01-01'),
(449585,62217,'1989-09-17','1990-09-17'),
(449585,64566,'1990-09-17','1991-09-17'),
(449585,66582,'1991-09-17','1992-09-16'),
(449585,67022,'1992-09-16','1993-09-16'),
(449585,68648,'1993-09-16','1994-09-16'),
(449585,69284,'1994-09-16','1995-09-16'),
(449585,73052,'1995-09-16','1996-09-15'),
(449585,76672,'1996-09-15','1997-09-15'),
(449585,77044,'1997-09-15','1998-09-15');


INSERT INTO `salaries` VALUES (449585,78291,'1998-09-15','1999-09-15'),
(449585,78797,'1999-09-15','2000-09-14'),
(449585,80732,'2000-09-14','2001-09-14'),
(449585,81789,'2001-09-14','9999-01-01'),
(449950,53795,'1986-04-16','1987-04-16'),
(449950,56007,'1987-04-16','1988-04-15'),
(449950,58412,'1988-04-15','1989-04-15'),
(449950,61277,'1989-04-15','1990-04-15'),
(449950,63334,'1990-04-15','1991-04-15'),
(449950,66966,'1991-04-15','1992-04-14');


INSERT INTO `salaries` VALUES (449950,69132,'1992-04-14','1993-04-14'),
(449950,69709,'1993-04-14','1994-04-14'),
(449950,71303,'1994-04-14','1995-04-14'),
(449950,73679,'1995-04-14','1996-04-13'),
(449950,74098,'1996-04-13','1997-04-13'),
(449950,74268,'1997-04-13','1998-04-13'),
(449950,76126,'1998-04-13','1999-04-13'),
(449950,77752,'1999-04-13','2000-04-12'),
(449950,82241,'2000-04-12','2001-04-12'),
(449950,85867,'2001-04-12','2002-04-12');


INSERT INTO `salaries` VALUES (449950,88750,'2002-04-12','9999-01-01'),
(450050,59539,'1989-12-30','1990-12-30'),
(450050,63126,'1990-12-30','1991-12-30'),
(450050,64369,'1991-12-30','1992-12-29'),
(450050,65693,'1992-12-29','1993-12-29'),
(450050,65350,'1993-12-29','1994-12-29'),
(450050,69588,'1994-12-29','1995-12-29'),
(450050,73310,'1995-12-29','1996-12-28'),
(450050,76918,'1996-12-28','1997-12-28'),
(450050,76531,'1997-12-28','1998-12-28');


INSERT INTO `salaries` VALUES (450050,77556,'1998-12-28','1999-12-28'),
(450050,78234,'1999-12-28','2000-12-27'),
(450050,82500,'2000-12-27','2001-12-27'),
(450050,84631,'2001-12-27','9999-01-01'),
(450443,40000,'1988-04-08','1989-04-08'),
(450443,40505,'1989-04-08','1990-04-08'),
(450443,41303,'1990-04-08','1991-04-08'),
(450443,42887,'1991-04-08','1992-04-07'),
(450443,44753,'1992-04-07','1993-04-07'),
(450443,48087,'1993-04-07','1994-04-07');


INSERT INTO `salaries` VALUES (450443,51833,'1994-04-07','1995-04-07'),
(450443,55872,'1995-04-07','1995-12-23'),
(450960,50400,'1987-10-21','1988-10-20'),
(450960,54102,'1988-10-20','1989-10-20'),
(450960,54583,'1989-10-20','1990-10-20'),
(450960,56645,'1990-10-20','1991-10-20'),
(450960,57202,'1991-10-20','1992-10-19'),
(450960,57059,'1992-10-19','1993-10-19'),
(450960,61435,'1993-10-19','1994-10-19'),
(450960,61432,'1994-10-19','1995-10-19');


INSERT INTO `salaries` VALUES (450960,61110,'1995-10-19','1996-10-18'),
(450960,63871,'1996-10-18','1997-10-18'),
(450960,66607,'1997-10-18','1998-10-18'),
(450960,69678,'1998-10-18','1999-10-18'),
(450960,71834,'1999-10-18','2000-10-17'),
(450960,73253,'2000-10-17','2001-10-17'),
(450960,73280,'2001-10-17','9999-01-01'),
(452346,77822,'1998-06-15','1999-06-15'),
(452346,77602,'1999-06-15','2000-06-14'),
(452346,79813,'2000-06-14','2001-06-14');


INSERT INTO `salaries` VALUES (452346,80103,'2001-06-14','2002-06-14'),
(452346,80305,'2002-06-14','9999-01-01'),
(452944,40000,'1995-09-26','1996-09-25'),
(452944,40926,'1996-09-25','1997-09-25'),
(452944,40964,'1997-09-25','1998-09-25'),
(452944,44556,'1998-09-25','1999-09-25'),
(452944,48137,'1999-09-25','2000-09-24'),
(452944,51880,'2000-09-24','2000-12-14'),
(453467,68946,'1993-01-24','1994-01-24'),
(453467,68488,'1994-01-24','1995-01-24');


INSERT INTO `salaries` VALUES (453467,68663,'1995-01-24','1996-01-24'),
(453467,69593,'1996-01-24','1997-01-23'),
(453467,71334,'1997-01-23','1998-01-23'),
(453467,75341,'1998-01-23','1999-01-23'),
(453467,76728,'1999-01-23','2000-01-23'),
(453467,76416,'2000-01-23','2001-01-22'),
(453467,77660,'2001-01-22','2002-01-22'),
(453467,78267,'2002-01-22','9999-01-01'),
(453835,77678,'1990-08-25','1991-08-25'),
(453835,78214,'1991-08-25','1992-08-24');


INSERT INTO `salaries` VALUES (453835,81431,'1992-08-24','1993-08-24'),
(453835,84230,'1993-08-24','1994-08-24'),
(453835,85096,'1994-08-24','1995-08-24'),
(453835,85474,'1995-08-24','1996-08-23'),
(453835,88902,'1996-08-23','1997-08-23'),
(453835,88472,'1997-08-23','1998-08-23'),
(453835,88575,'1998-08-23','1999-08-23'),
(453835,91225,'1999-08-23','2000-08-22'),
(453835,93726,'2000-08-22','2001-08-22'),
(453835,94136,'2001-08-22','9999-01-01');


INSERT INTO `salaries` VALUES (453910,46801,'1998-10-29','1999-10-29'),
(453910,50279,'1999-10-29','2000-10-28'),
(453910,51397,'2000-10-28','2001-10-28'),
(453910,52807,'2001-10-28','9999-01-01'),
(454044,46038,'1991-10-02','1992-10-01'),
(454044,46563,'1992-10-01','1993-10-01'),
(454044,50009,'1993-10-01','1994-10-01'),
(454044,49877,'1994-10-01','1995-10-01'),
(454044,50724,'1995-10-01','1996-09-30'),
(454044,51629,'1996-09-30','1997-09-30');


INSERT INTO `salaries` VALUES (454044,52571,'1997-09-30','1998-09-30'),
(454044,54612,'1998-09-30','1999-09-30'),
(454044,55605,'1999-09-30','2000-09-29'),
(454044,57572,'2000-09-29','2001-09-29'),
(454044,57073,'2001-09-29','9999-01-01'),
(454104,40000,'1994-09-06','1995-09-06'),
(454104,40577,'1995-09-06','1996-09-05'),
(454104,41513,'1996-09-05','1997-09-05'),
(454104,42392,'1997-09-05','1998-01-28'),
(454472,49748,'1991-05-04','1992-05-03');


INSERT INTO `salaries` VALUES (454472,50847,'1992-05-03','1993-05-03'),
(454472,51682,'1993-05-03','1994-05-03'),
(454472,52799,'1994-05-03','1995-05-03'),
(454472,54129,'1995-05-03','1996-05-02'),
(454472,55689,'1996-05-02','1997-05-02'),
(454472,57650,'1997-05-02','1998-05-02'),
(454472,57839,'1998-05-02','1999-05-02'),
(454472,61729,'1999-05-02','2000-05-01'),
(454472,62093,'2000-05-01','2001-05-01'),
(454472,61917,'2001-05-01','2002-05-01');


INSERT INTO `salaries` VALUES (454472,62730,'2002-05-01','9999-01-01'),
(454591,52369,'1986-07-01','1987-07-01'),
(454591,56646,'1987-07-01','1988-06-30'),
(454591,60390,'1988-06-30','1989-06-30'),
(454591,63971,'1989-06-30','1990-06-30'),
(454591,64127,'1990-06-30','1991-06-30'),
(454591,64419,'1991-06-30','1992-06-29'),
(454591,67128,'1992-06-29','1993-06-29'),
(454591,71619,'1993-06-29','1994-06-29'),
(454591,71921,'1994-06-29','1995-06-29');


INSERT INTO `salaries` VALUES (454591,75489,'1995-06-29','1996-06-28'),
(454591,76818,'1996-06-28','1997-06-28'),
(454591,80325,'1997-06-28','1998-06-28'),
(454591,83298,'1998-06-28','1999-06-28'),
(454591,82941,'1999-06-28','2000-06-27'),
(454591,87294,'2000-06-27','2001-06-27'),
(454591,87260,'2001-06-27','2002-06-27'),
(454591,90511,'2002-06-27','9999-01-01'),
(454592,66196,'1990-07-03','1991-07-03'),
(454592,69426,'1991-07-03','1992-07-02');


INSERT INTO `salaries` VALUES (454592,73024,'1992-07-02','1993-07-02'),
(454592,75392,'1993-07-02','1994-07-02'),
(454592,75390,'1994-07-02','1995-07-02'),
(454592,78736,'1995-07-02','1996-07-01'),
(454592,78512,'1996-07-01','1997-07-01'),
(454592,78494,'1997-07-01','1998-07-01'),
(454592,78911,'1998-07-01','1999-07-01'),
(454592,82853,'1999-07-01','2000-06-30'),
(454592,83382,'2000-06-30','2001-06-30'),
(454592,86470,'2001-06-30','2002-06-30');


INSERT INTO `salaries` VALUES (454592,89318,'2002-06-30','9999-01-01'),
(454774,62352,'1986-11-01','1987-11-01'),
(454774,64907,'1987-11-01','1988-10-31'),
(454774,65016,'1988-10-31','1989-10-31'),
(454774,68899,'1989-10-31','1990-10-31'),
(454774,70059,'1990-10-31','1991-10-31'),
(454774,70338,'1991-10-31','1992-10-30'),
(454774,73335,'1992-10-30','1993-10-30'),
(454774,76362,'1993-10-30','1994-10-30'),
(454774,78334,'1994-10-30','1995-10-30');


INSERT INTO `salaries` VALUES (454774,78208,'1995-10-30','1996-10-29'),
(454774,79050,'1996-10-29','1997-10-29'),
(454774,80845,'1997-10-29','1998-10-29'),
(454774,84648,'1998-10-29','1999-10-29'),
(454774,87749,'1999-10-29','2000-10-28'),
(454774,89304,'2000-10-28','2001-10-28'),
(454774,89191,'2001-10-28','9999-01-01'),
(455131,61996,'1995-03-18','1996-03-17'),
(455131,64496,'1996-03-17','1997-03-17'),
(455131,65667,'1997-03-17','1998-03-17');


INSERT INTO `salaries` VALUES (455131,66192,'1998-03-17','1999-03-17'),
(455131,69448,'1999-03-17','2000-03-16'),
(455131,69218,'2000-03-16','2001-03-16'),
(455131,71416,'2001-03-16','2002-03-16'),
(455131,73483,'2002-03-16','9999-01-01'),
(455592,47141,'1991-04-18','1992-04-17'),
(455592,48210,'1992-04-17','1993-04-17'),
(455592,48063,'1993-04-17','1994-04-17'),
(455592,49931,'1994-04-17','1995-04-17'),
(455592,53793,'1995-04-17','1996-04-16');


INSERT INTO `salaries` VALUES (455592,57269,'1996-04-16','1997-04-16'),
(455592,59990,'1997-04-16','1998-04-16'),
(455592,60251,'1998-04-16','1999-04-16'),
(455592,59987,'1999-04-16','2000-04-15'),
(455592,63422,'2000-04-15','2001-04-15'),
(455592,67559,'2001-04-15','2002-04-15'),
(455592,68061,'2002-04-15','9999-01-01'),
(455801,40000,'1985-11-19','1986-11-19'),
(455801,40642,'1986-11-19','1987-11-19'),
(455801,41360,'1987-11-19','1988-11-18');


INSERT INTO `salaries` VALUES (455801,40887,'1988-11-18','1989-11-18'),
(455801,44673,'1989-11-18','1990-11-18'),
(455801,44303,'1990-11-18','1991-11-18'),
(455801,44070,'1991-11-18','1992-11-17'),
(455801,44541,'1992-11-17','1993-11-17'),
(455801,48473,'1993-11-17','1994-11-17'),
(455801,52034,'1994-11-17','1995-11-17'),
(455801,53710,'1995-11-17','1996-11-16'),
(455801,57318,'1996-11-16','1997-11-16'),
(455801,59454,'1997-11-16','1998-11-16');


INSERT INTO `salaries` VALUES (455801,60206,'1998-11-16','1999-11-16'),
(455801,63544,'1999-11-16','2000-11-15'),
(455801,67393,'2000-11-15','2001-11-15'),
(455801,67951,'2001-11-15','9999-01-01'),
(455948,40000,'1993-01-18','1994-01-18'),
(455948,40378,'1994-01-18','1995-01-18'),
(455948,44065,'1995-01-18','1996-01-18'),
(455948,45885,'1996-01-18','1997-01-17'),
(455948,48969,'1997-01-17','1998-01-17'),
(455948,49801,'1998-01-17','1999-01-17');


INSERT INTO `salaries` VALUES (455948,51577,'1999-01-17','2000-01-17'),
(455948,53697,'2000-01-17','2001-01-16'),
(455948,57088,'2001-01-16','2002-01-16'),
(455948,57976,'2002-01-16','9999-01-01'),
(456107,40000,'1991-05-27','1992-05-26'),
(456107,40492,'1992-05-26','1993-05-26'),
(456107,44687,'1993-05-26','1994-05-26'),
(456107,44676,'1994-05-26','1995-05-26'),
(456107,44342,'1995-05-26','1996-05-25'),
(456107,47142,'1996-05-25','1997-05-25');


INSERT INTO `salaries` VALUES (456107,47345,'1997-05-25','1998-05-25'),
(456107,47389,'1998-05-25','1999-05-25'),
(456107,51365,'1999-05-25','2000-05-24'),
(456107,51960,'2000-05-24','2001-05-24'),
(456107,55314,'2001-05-24','2002-05-24'),
(456107,56480,'2002-05-24','9999-01-01'),
(456131,42848,'1994-06-09','1995-06-09'),
(456131,45709,'1995-06-09','1996-06-08'),
(456131,49794,'1996-06-08','1997-06-08'),
(456131,49909,'1997-06-08','1998-06-08');


INSERT INTO `salaries` VALUES (456131,49482,'1998-06-08','1999-06-08'),
(456131,51795,'1999-06-08','2000-06-07'),
(456131,54286,'2000-06-07','2001-06-07'),
(456131,54012,'2001-06-07','2002-06-07'),
(456131,57028,'2002-06-07','9999-01-01'),
(456146,62646,'1999-12-02','2000-12-01'),
(456146,62355,'2000-12-01','2001-12-01'),
(456146,63140,'2001-12-01','9999-01-01'),
(456688,40000,'1991-02-27','1992-02-27'),
(456688,43623,'1992-02-27','1993-02-26');


INSERT INTO `salaries` VALUES (456688,47047,'1993-02-26','1994-02-26'),
(456688,49253,'1994-02-26','1995-02-26'),
(456688,49063,'1995-02-26','1996-02-26'),
(456688,53426,'1996-02-26','1997-02-25'),
(456688,56020,'1997-02-25','1998-02-25'),
(456688,57492,'1998-02-25','1999-02-25'),
(456688,60953,'1999-02-25','2000-02-25'),
(456688,62541,'2000-02-25','2001-02-24'),
(456688,62888,'2001-02-24','2002-02-24'),
(456688,67114,'2002-02-24','9999-01-01');


INSERT INTO `salaries` VALUES (456982,41631,'1989-01-05','1990-01-05'),
(456982,42033,'1990-01-05','1991-01-05'),
(456982,44135,'1991-01-05','1992-01-05'),
(456982,45419,'1992-01-05','1993-01-04'),
(456982,48644,'1993-01-04','1994-01-04'),
(456982,50772,'1994-01-04','1995-01-04'),
(456982,51699,'1995-01-04','1996-01-04'),
(456982,54698,'1996-01-04','1997-01-03'),
(456982,54977,'1997-01-03','1998-01-03'),
(456982,55994,'1998-01-03','1999-01-03');


INSERT INTO `salaries` VALUES (456982,57778,'1999-01-03','2000-01-03'),
(456982,57456,'2000-01-03','2001-01-02'),
(456982,60346,'2001-01-02','2002-01-02'),
(456982,61108,'2002-01-02','9999-01-01'),
(457307,40000,'1988-09-30','1989-09-30'),
(457307,41496,'1989-09-30','1990-09-30'),
(457307,43897,'1990-09-30','1991-09-30'),
(457307,45321,'1991-09-30','1992-09-29'),
(457307,48760,'1992-09-29','1993-09-29'),
(457307,48407,'1993-09-29','1994-09-29');


INSERT INTO `salaries` VALUES (457307,51409,'1994-09-29','1995-09-29'),
(457307,51880,'1995-09-29','1996-09-28'),
(457307,52528,'1996-09-28','1997-09-28'),
(457307,54661,'1997-09-28','1998-09-28'),
(457307,57520,'1998-09-28','1999-09-28'),
(457307,57722,'1999-09-28','2000-09-27'),
(457307,57259,'2000-09-27','2001-09-27'),
(457307,61675,'2001-09-27','9999-01-01'),
(457337,40000,'1995-04-27','1996-04-26'),
(457337,40427,'1996-04-26','1997-04-26');


INSERT INTO `salaries` VALUES (457337,40403,'1997-04-26','1998-04-26'),
(457337,41129,'1998-04-26','1999-04-26'),
(457337,42985,'1999-04-26','2000-04-25'),
(457337,47417,'2000-04-25','2001-04-25'),
(457337,50082,'2001-04-25','2002-04-25'),
(457337,54264,'2002-04-25','9999-01-01'),
(457781,84841,'1992-05-30','1993-05-30'),
(457781,85672,'1993-05-30','1994-05-30'),
(457781,89373,'1994-05-30','1995-05-30'),
(457781,93557,'1995-05-30','1996-05-29');


INSERT INTO `salaries` VALUES (457781,96118,'1996-05-29','1997-05-29'),
(457781,100155,'1997-05-29','1998-05-29'),
(457781,101513,'1998-05-29','1999-05-29'),
(457781,105342,'1999-05-29','1999-06-12'),
(457792,41435,'1989-08-09','1990-08-09'),
(457792,44202,'1990-08-09','1991-08-09'),
(457792,47733,'1991-08-09','1992-08-08'),
(457792,47805,'1992-08-08','1993-08-08'),
(457792,48612,'1993-08-08','1994-08-08'),
(457792,51517,'1994-08-08','1995-08-08');


INSERT INTO `salaries` VALUES (457792,53332,'1995-08-08','1996-08-07'),
(457792,52915,'1996-08-07','1997-08-07'),
(457792,56099,'1997-08-07','1998-08-07'),
(457792,57647,'1998-08-07','1999-08-07'),
(457792,58654,'1999-08-07','2000-08-06'),
(457792,58211,'2000-08-06','2001-08-06'),
(457792,62368,'2001-08-06','9999-01-01'),
(458720,47013,'1994-04-23','1995-04-23'),
(458720,47488,'1995-04-23','1996-04-22'),
(458720,51867,'1996-04-22','1997-04-22');


INSERT INTO `salaries` VALUES (458720,55759,'1997-04-22','1998-04-22'),
(458720,56905,'1998-04-22','1999-04-22'),
(458720,56919,'1999-04-22','1999-05-03'),
(458866,60839,'1992-09-02','1993-09-02'),
(458866,63759,'1993-09-02','1994-09-02'),
(458866,67984,'1994-09-02','1995-09-02'),
(458866,71242,'1995-09-02','1996-09-01'),
(458866,73186,'1996-09-01','1997-09-01'),
(458866,73095,'1997-09-01','1998-09-01'),
(458866,77154,'1998-09-01','1999-09-01');


INSERT INTO `salaries` VALUES (458866,81201,'1999-09-01','2000-08-31'),
(458866,82864,'2000-08-31','2001-08-31'),
(458866,83898,'2001-08-31','9999-01-01'),
(459134,40000,'1996-12-31','1997-12-31'),
(459134,43625,'1997-12-31','1998-12-31'),
(459134,47982,'1998-12-31','1999-12-31'),
(459134,49184,'1999-12-31','2000-12-30'),
(459134,49889,'2000-12-30','2001-12-30'),
(459134,50450,'2001-12-30','9999-01-01'),
(459172,58787,'1993-11-20','1994-11-20');


INSERT INTO `salaries` VALUES (459172,62894,'1994-11-20','1995-11-20'),
(459172,65191,'1995-11-20','1996-11-19'),
(459172,68298,'1996-11-19','1997-11-19'),
(459172,67978,'1997-11-19','1998-11-19'),
(459172,70192,'1998-11-19','1999-11-19'),
(459172,71012,'1999-11-19','2000-11-18'),
(459172,71443,'2000-11-18','2001-11-18'),
(459172,73985,'2001-11-18','9999-01-01'),
(459670,76181,'1985-11-13','1986-11-13'),
(459670,79008,'1986-11-13','1987-11-13');


INSERT INTO `salaries` VALUES (459670,83011,'1987-11-13','1988-11-12'),
(459670,85656,'1988-11-12','1989-11-12'),
(459670,87030,'1989-11-12','1990-11-12'),
(459670,90791,'1990-11-12','1991-11-12'),
(459670,93850,'1991-11-12','1992-11-11'),
(459670,93888,'1992-11-11','1993-11-11'),
(459670,96569,'1993-11-11','1994-11-11'),
(459670,97205,'1994-11-11','1995-11-11'),
(459670,98946,'1995-11-11','1996-11-10'),
(459670,99264,'1996-11-10','1997-11-10');


INSERT INTO `salaries` VALUES (459670,99722,'1997-11-10','1998-11-10'),
(459670,99425,'1998-11-10','1999-11-10'),
(459670,101581,'1999-11-10','2000-11-09'),
(459670,101940,'2000-11-09','2001-11-09'),
(459670,105576,'2001-11-09','9999-01-01'),
(459744,40000,'1991-02-27','1992-02-27'),
(459744,40357,'1992-02-27','1993-02-26'),
(459744,41459,'1993-02-26','1994-02-26'),
(459744,44006,'1994-02-26','1995-02-26'),
(459744,43823,'1995-02-26','1996-02-26');


INSERT INTO `salaries` VALUES (459744,43828,'1996-02-26','1997-02-25'),
(459744,45020,'1997-02-25','1998-02-25'),
(459744,46610,'1998-02-25','1999-02-25'),
(459744,50886,'1999-02-25','2000-02-25'),
(459744,52422,'2000-02-25','2001-02-24'),
(459744,53109,'2001-02-24','2002-02-24'),
(459744,55194,'2002-02-24','9999-01-01'),
(461268,100259,'1991-10-12','1992-10-11'),
(461268,101034,'1992-10-11','1993-10-11'),
(461268,104194,'1993-10-11','1994-10-11');


INSERT INTO `salaries` VALUES (461268,104037,'1994-10-11','1995-10-11'),
(461268,107299,'1995-10-11','1996-10-10'),
(461268,109384,'1996-10-10','1997-10-10'),
(461268,112021,'1997-10-10','1998-10-10'),
(461268,114898,'1998-10-10','1999-10-10'),
(461268,118703,'1999-10-10','2000-10-09'),
(461268,122463,'2000-10-09','2001-10-09'),
(461268,125794,'2001-10-09','9999-01-01'),
(461329,98329,'1998-01-12','1999-01-12'),
(461329,102627,'1999-01-12','2000-01-12');


INSERT INTO `salaries` VALUES (461329,102475,'2000-01-12','2001-01-11'),
(461329,106240,'2001-01-11','2002-01-11'),
(461329,109111,'2002-01-11','9999-01-01'),
(461716,79589,'1996-09-02','1997-09-02'),
(461716,83522,'1997-09-02','1998-09-02'),
(461716,85067,'1998-09-02','1999-09-02'),
(461716,87285,'1999-09-02','2000-09-01'),
(461716,89687,'2000-09-01','2001-09-01'),
(461716,91170,'2001-09-01','9999-01-01'),
(462367,52142,'1998-11-24','1999-11-24');


INSERT INTO `salaries` VALUES (462367,54820,'1999-11-24','2000-11-23'),
(462367,55088,'2000-11-23','2001-11-23'),
(462367,59023,'2001-11-23','9999-01-01'),
(462427,50528,'1991-07-09','1992-07-08'),
(462427,52700,'1992-07-08','1993-07-08'),
(462427,53588,'1993-07-08','1994-07-08'),
(462427,53221,'1994-07-08','1995-07-08'),
(462427,56333,'1995-07-08','1996-07-07'),
(462427,56855,'1996-07-07','1997-07-07'),
(462427,58829,'1997-07-07','1998-07-07');


INSERT INTO `salaries` VALUES (462427,61588,'1998-07-07','1999-07-07'),
(462427,63913,'1999-07-07','2000-07-06'),
(462427,64896,'2000-07-06','2001-07-06'),
(462427,67138,'2001-07-06','2002-07-06'),
(462427,66675,'2002-07-06','9999-01-01'),
(463321,53626,'1994-05-27','1995-05-27'),
(463321,54904,'1995-05-27','1996-05-26'),
(463321,57207,'1996-05-26','1997-05-26'),
(463321,59256,'1997-05-26','1998-05-26'),
(463321,63682,'1998-05-26','1999-05-26');


INSERT INTO `salaries` VALUES (463321,67852,'1999-05-26','2000-05-25'),
(463321,71363,'2000-05-25','2001-05-25'),
(463321,73943,'2001-05-25','2002-05-25'),
(463321,75744,'2002-05-25','9999-01-01'),
(463614,40000,'1989-10-19','1990-10-19'),
(463614,41093,'1990-10-19','1991-10-19'),
(463614,41493,'1991-10-19','1992-10-18'),
(463614,42269,'1992-10-18','1993-10-18'),
(463614,42419,'1993-10-18','1994-10-18'),
(463614,44381,'1994-10-18','1995-10-18');


INSERT INTO `salaries` VALUES (463614,46257,'1995-10-18','1996-10-17'),
(463614,50462,'1996-10-17','1997-10-17'),
(463614,54778,'1997-10-17','1998-10-17'),
(463614,54981,'1998-10-17','1999-10-17'),
(463614,56232,'1999-10-17','2000-10-16'),
(463614,57667,'2000-10-16','2001-10-16'),
(463614,62147,'2001-10-16','9999-01-01'),
(464625,43217,'1992-08-06','1993-08-06'),
(464625,47009,'1993-08-06','1994-08-06'),
(464625,47333,'1994-08-06','1995-08-06');


INSERT INTO `salaries` VALUES (464625,47190,'1995-08-06','1996-08-05'),
(464625,47580,'1996-08-05','1997-08-05'),
(464625,47969,'1997-08-05','1998-08-05'),
(464625,50045,'1998-08-05','1999-08-05'),
(464625,50263,'1999-08-05','2000-08-04'),
(464625,52115,'2000-08-04','2001-08-04'),
(464625,53492,'2001-08-04','9999-01-01'),
(464927,40136,'1989-06-05','1990-06-05'),
(464927,40446,'1990-06-05','1991-06-05'),
(464927,42775,'1991-06-05','1992-06-04');


INSERT INTO `salaries` VALUES (464927,44430,'1992-06-04','1993-06-04'),
(464927,47379,'1993-06-04','1994-06-04'),
(464927,51391,'1994-06-04','1995-06-04'),
(464927,55177,'1995-06-04','1996-06-03'),
(464927,55851,'1996-06-03','1997-06-03'),
(464927,58046,'1997-06-03','1998-06-03'),
(464927,62531,'1998-06-03','1998-12-11'),
(464955,69582,'1994-04-08','1995-04-08'),
(464955,70413,'1995-04-08','1995-04-13'),
(465205,75077,'1987-05-12','1988-05-11');


INSERT INTO `salaries` VALUES (465205,78812,'1988-05-11','1989-05-11'),
(465205,82514,'1989-05-11','1990-05-11'),
(465205,84357,'1990-05-11','1991-05-11'),
(465205,85718,'1991-05-11','1992-05-10'),
(465205,87613,'1992-05-10','1993-05-10'),
(465205,87747,'1993-05-10','1994-05-10'),
(465205,90909,'1994-05-10','1995-05-10'),
(465205,93695,'1995-05-10','1996-05-09'),
(465205,93743,'1996-05-09','1997-05-09'),
(465205,96810,'1997-05-09','1998-05-09');


INSERT INTO `salaries` VALUES (465205,97150,'1998-05-09','1999-05-09'),
(465205,101128,'1999-05-09','2000-05-08'),
(465205,101368,'2000-05-08','2001-05-08'),
(465205,105863,'2001-05-08','2002-05-08'),
(465205,109963,'2002-05-08','9999-01-01'),
(465245,52611,'1985-03-07','1986-03-07'),
(465245,55033,'1986-03-07','1987-03-07'),
(465245,55015,'1987-03-07','1988-03-06'),
(465245,57632,'1988-03-06','1989-03-06'),
(465245,62051,'1989-03-06','1990-03-06');


INSERT INTO `salaries` VALUES (465245,65898,'1990-03-06','1991-03-06'),
(465245,70253,'1991-03-06','1992-03-05'),
(465245,71873,'1992-03-05','1993-03-05'),
(465245,71606,'1993-03-05','1994-03-05'),
(465245,71712,'1994-03-05','1994-12-18'),
(465854,48212,'1999-09-14','2000-09-13'),
(465854,48239,'2000-09-13','2001-09-13'),
(465854,51029,'2001-09-13','9999-01-01'),
(466137,40354,'1998-11-07','1999-11-07'),
(466137,41344,'1999-11-07','2000-11-06');


INSERT INTO `salaries` VALUES (466137,43294,'2000-11-06','2001-11-06'),
(466137,42902,'2001-11-06','9999-01-01'),
(466147,53104,'1989-12-09','1990-12-09'),
(466147,56466,'1990-12-09','1991-12-09'),
(466147,59552,'1991-12-09','1992-12-08'),
(466147,62975,'1992-12-08','1993-12-08'),
(466147,65979,'1993-12-08','1994-12-08'),
(466147,69524,'1994-12-08','1995-12-08'),
(466147,70033,'1995-12-08','1996-12-07'),
(466147,73164,'1996-12-07','1997-12-07');


INSERT INTO `salaries` VALUES (466147,74082,'1997-12-07','1998-12-07'),
(466147,73860,'1998-12-07','1999-12-07'),
(466147,74082,'1999-12-07','2000-12-06'),
(466147,77069,'2000-12-06','2001-12-06'),
(466147,79165,'2001-12-06','9999-01-01'),
(466176,43584,'1986-11-11','1987-11-11'),
(466176,46868,'1987-11-11','1988-11-10'),
(466176,48998,'1988-11-10','1989-11-10'),
(466176,53011,'1989-11-10','1990-11-10'),
(466176,55609,'1990-11-10','1991-11-10');


INSERT INTO `salaries` VALUES (466176,57528,'1991-11-10','1992-11-09'),
(466176,61385,'1992-11-09','1993-11-09'),
(466176,60942,'1993-11-09','1994-11-09'),
(466176,63283,'1994-11-09','1995-11-09'),
(466176,62795,'1995-11-09','1996-11-08'),
(466176,63353,'1996-11-08','1997-11-08'),
(466176,67036,'1997-11-08','1998-11-08'),
(466176,68335,'1998-11-08','1999-11-08'),
(466176,67913,'1999-11-08','2000-11-07'),
(466176,67776,'2000-11-07','2001-11-07');


INSERT INTO `salaries` VALUES (466176,71318,'2001-11-07','9999-01-01'),
(466224,48915,'1992-09-23','1993-05-14'),
(466440,40000,'1987-05-16','1988-05-15'),
(466440,41863,'1988-05-15','1989-05-15'),
(466440,44245,'1989-05-15','1990-05-15'),
(466440,44795,'1990-05-15','1991-05-15'),
(466440,48105,'1991-05-15','1992-05-14'),
(466440,49329,'1992-05-14','1993-05-14'),
(466440,50512,'1993-05-14','1994-05-14'),
(466440,53774,'1994-05-14','1995-05-14');


INSERT INTO `salaries` VALUES (466440,54607,'1995-05-14','1996-05-13'),
(466440,57108,'1996-05-13','1997-05-13'),
(466440,60601,'1997-05-13','1998-05-13'),
(466440,62174,'1998-05-13','1999-05-13'),
(466440,63924,'1999-05-13','2000-05-12'),
(466440,66239,'2000-05-12','2001-05-12'),
(466440,70042,'2001-05-12','2002-05-12'),
(466440,74088,'2002-05-12','9999-01-01'),
(466771,40000,'1998-08-14','1999-08-14'),
(466771,39807,'1999-08-14','2000-08-13');


INSERT INTO `salaries` VALUES (466771,40032,'2000-08-13','2001-08-13'),
(466771,42638,'2001-08-13','9999-01-01'),
(467051,77183,'1991-07-20','1992-07-19'),
(467051,80664,'1992-07-19','1993-07-19'),
(467051,81080,'1993-07-19','1994-07-19'),
(467051,81776,'1994-07-19','1995-02-07'),
(467114,40000,'1994-05-30','1995-05-30'),
(467114,41685,'1995-05-30','1996-05-29'),
(467114,42958,'1996-05-29','1997-05-29'),
(467114,42529,'1997-05-29','1998-05-29');


INSERT INTO `salaries` VALUES (467114,42925,'1998-05-29','1999-05-29'),
(467114,46334,'1999-05-29','2000-05-28'),
(467114,50621,'2000-05-28','2001-05-28'),
(467114,53371,'2001-05-28','2002-05-28'),
(467114,53254,'2002-05-28','9999-01-01'),
(467978,40735,'1992-10-03','1993-10-03'),
(467978,44144,'1993-10-03','1994-10-03'),
(467978,44297,'1994-10-03','1995-02-24'),
(468108,40000,'1993-02-18','1994-02-18'),
(468108,40436,'1994-02-18','1995-02-18');


INSERT INTO `salaries` VALUES (468108,40474,'1995-02-18','1996-02-18'),
(468108,41273,'1996-02-18','1997-02-17'),
(468108,41021,'1997-02-17','1998-02-17'),
(468108,42590,'1998-02-17','1999-02-17'),
(468108,43102,'1999-02-17','2000-02-17'),
(468108,42877,'2000-02-17','2001-02-16'),
(468108,46597,'2001-02-16','2002-02-16'),
(468108,48739,'2002-02-16','9999-01-01'),
(469541,57698,'1995-11-03','1996-11-02'),
(469541,59402,'1996-11-02','1997-11-02');


INSERT INTO `salaries` VALUES (469541,63609,'1997-11-02','1998-11-02'),
(469541,64979,'1998-11-02','1999-11-02'),
(469541,66706,'1999-11-02','2000-11-01'),
(469541,68909,'2000-11-01','2001-11-01'),
(469541,69332,'2001-11-01','9999-01-01'),
(469772,64530,'1994-09-06','1995-09-06'),
(469772,64838,'1995-09-06','1996-09-05'),
(469772,65084,'1996-09-05','1997-09-05'),
(469772,65252,'1997-09-05','1998-09-05'),
(469772,66129,'1998-09-05','1999-09-05');


INSERT INTO `salaries` VALUES (469772,68062,'1999-09-05','2000-09-04'),
(469772,71709,'2000-09-04','2001-09-04'),
(469772,74109,'2001-09-04','9999-01-01'),
(470221,50127,'1997-02-21','1998-02-21'),
(470221,51101,'1998-02-21','1999-02-21'),
(470221,52711,'1999-02-21','2000-02-21'),
(470221,54604,'2000-02-21','2001-02-20'),
(470221,58401,'2001-02-20','2002-02-20'),
(470221,58859,'2002-02-20','9999-01-01'),
(470837,63806,'1996-03-02','1997-03-02');


INSERT INTO `salaries` VALUES (470837,68263,'1997-03-02','1998-03-02'),
(470837,68604,'1998-03-02','1999-03-02'),
(470837,72406,'1999-03-02','2000-03-01'),
(470837,74135,'2000-03-01','2001-03-01'),
(470837,73678,'2001-03-01','2002-03-01'),
(470837,73329,'2002-03-01','9999-01-01'),
(471334,40000,'1995-05-11','1996-05-10'),
(471334,39942,'1996-05-10','1997-05-10'),
(471334,43703,'1997-05-10','1998-05-10'),
(471334,45234,'1998-05-10','1999-05-10');


INSERT INTO `salaries` VALUES (471334,45791,'1999-05-10','2000-05-09'),
(471334,45420,'2000-05-09','2000-11-07'),
(471535,40000,'1997-11-27','1998-11-27'),
(471535,41327,'1998-11-27','1999-11-11'),
(471787,82409,'1988-08-20','1989-08-20'),
(471787,85312,'1989-08-20','1990-08-20'),
(471787,85590,'1990-08-20','1991-08-20'),
(471787,86657,'1991-08-20','1992-08-19'),
(471787,87672,'1992-08-19','1993-08-19'),
(471787,87937,'1993-08-19','1994-08-19');


INSERT INTO `salaries` VALUES (471787,90032,'1994-08-19','1995-08-19'),
(471787,90147,'1995-08-19','1996-08-18'),
(471787,92787,'1996-08-18','1997-08-18'),
(471787,95109,'1997-08-18','1998-08-18'),
(471787,98256,'1998-08-18','1999-08-18'),
(471787,99269,'1999-08-18','2000-08-17'),
(471787,99212,'2000-08-17','2001-08-17'),
(471787,103430,'2001-08-17','9999-01-01'),
(472062,40000,'1992-09-02','1993-09-02'),
(472062,43203,'1993-09-02','1994-09-02');


INSERT INTO `salaries` VALUES (472062,44717,'1994-09-02','1995-09-02'),
(472062,45382,'1995-09-02','1996-09-01'),
(472062,46327,'1996-09-01','1997-09-01'),
(472062,47574,'1997-09-01','1998-09-01'),
(472062,47924,'1998-09-01','1999-07-21'),
(472563,42967,'1990-10-09','1991-10-09'),
(472563,43935,'1991-10-09','1992-10-08'),
(472563,44796,'1992-10-08','1993-10-08'),
(472563,45782,'1993-10-08','1994-10-08'),
(472563,48878,'1994-10-08','1995-10-08');


INSERT INTO `salaries` VALUES (472563,49839,'1995-10-08','1996-10-07'),
(472563,54308,'1996-10-07','1997-10-07'),
(472563,56433,'1997-10-07','1998-10-07'),
(472563,60005,'1998-10-07','1999-10-07'),
(472563,60900,'1999-10-07','2000-10-06'),
(472563,63222,'2000-10-06','2001-10-06'),
(472563,65204,'2001-10-06','9999-01-01'),
(473287,40000,'1990-05-07','1991-05-07'),
(473287,39637,'1991-05-07','1992-05-06'),
(473287,40222,'1992-05-06','1993-05-06');


INSERT INTO `salaries` VALUES (473287,43593,'1993-05-06','1994-05-06'),
(473287,45956,'1994-05-06','1995-05-06'),
(473287,47324,'1995-05-06','1996-05-05'),
(473287,47254,'1996-05-05','1997-05-05'),
(473287,47504,'1997-05-05','1998-05-05'),
(473287,47640,'1998-05-05','1999-05-05'),
(473287,51073,'1999-05-05','2000-05-04'),
(473287,54282,'2000-05-04','2001-05-04'),
(473287,54458,'2001-05-04','2002-05-04'),
(473287,55837,'2002-05-04','9999-01-01');


INSERT INTO `salaries` VALUES (473521,48978,'1987-10-26','1988-10-25'),
(473521,49555,'1988-10-25','1989-10-25'),
(473521,51339,'1989-10-25','1990-10-25'),
(473521,54700,'1990-10-25','1991-10-25'),
(473521,55968,'1991-10-25','1992-10-24'),
(473521,60235,'1992-10-24','1993-10-24'),
(473521,63168,'1993-10-24','1994-10-24'),
(473521,67316,'1994-10-24','1995-10-24'),
(473521,70647,'1995-10-24','1996-10-23'),
(473521,73773,'1996-10-23','1997-10-23');


INSERT INTO `salaries` VALUES (473521,76841,'1997-10-23','1998-10-23'),
(473521,79590,'1998-10-23','1999-10-23'),
(473521,80876,'1999-10-23','2000-10-22'),
(473521,83018,'2000-10-22','2001-10-22'),
(473521,86810,'2001-10-22','9999-01-01'),
(473954,74152,'1998-09-19','1999-09-19'),
(473954,74051,'1999-09-19','2000-09-18'),
(473954,78316,'2000-09-18','2001-09-18'),
(473954,79280,'2001-09-18','9999-01-01'),
(474064,40000,'1985-10-06','1986-10-06');


INSERT INTO `salaries` VALUES (474064,43625,'1986-10-06','1987-10-06'),
(474064,46127,'1987-10-06','1988-10-05'),
(474064,48120,'1988-10-05','1989-10-05'),
(474064,48884,'1989-10-05','1990-10-05'),
(474064,48523,'1990-10-05','1991-05-11'),
(475036,60940,'1999-11-21','2000-11-20'),
(475036,64997,'2000-11-20','2001-11-20'),
(475036,67141,'2001-11-20','9999-01-01'),
(475725,40000,'1994-05-02','1995-05-02'),
(475725,41218,'1995-05-02','1996-05-01');


INSERT INTO `salaries` VALUES (475725,45001,'1996-05-01','1997-05-01'),
(475725,46235,'1997-05-01','1998-05-01'),
(475725,47141,'1998-05-01','1999-05-01'),
(475725,50094,'1999-05-01','2000-04-30'),
(475725,50999,'2000-04-30','2001-04-30'),
(475725,55336,'2001-04-30','2002-04-30'),
(475725,58998,'2002-04-30','9999-01-01'),
(476629,48959,'1992-09-27','1993-08-21'),
(477293,57591,'1987-06-16','1988-06-15'),
(477293,60621,'1988-06-15','1989-06-15');


INSERT INTO `salaries` VALUES (477293,62323,'1989-06-15','1990-06-15'),
(477293,66198,'1990-06-15','1991-06-15'),
(477293,67091,'1991-06-15','1992-06-14'),
(477293,67070,'1992-06-14','1993-06-14'),
(477293,68787,'1993-06-14','1994-06-14'),
(477293,69000,'1994-06-14','1995-06-14'),
(477293,70857,'1995-06-14','1996-06-13'),
(477293,74078,'1996-06-13','1997-06-13'),
(477293,74462,'1997-06-13','1998-06-13'),
(477293,74968,'1998-06-13','1999-06-13');


INSERT INTO `salaries` VALUES (477293,77652,'1999-06-13','2000-06-12'),
(477293,81847,'2000-06-12','2001-06-12'),
(477293,86023,'2001-06-12','2002-06-12'),
(477293,89261,'2002-06-12','9999-01-01'),
(477384,41482,'1987-03-07','1988-03-06'),
(477384,41834,'1988-03-06','1989-03-06'),
(477384,42132,'1989-03-06','1990-03-06'),
(477384,42416,'1990-03-06','1991-03-06'),
(477384,44462,'1991-03-06','1992-03-05'),
(477384,44453,'1992-03-05','1993-03-05');


INSERT INTO `salaries` VALUES (477384,47700,'1993-03-05','1994-03-05'),
(477384,47667,'1994-03-05','1995-03-05'),
(477384,47951,'1995-03-05','1996-03-04'),
(477384,50003,'1996-03-04','1997-03-04'),
(477384,50364,'1997-03-04','1998-03-04'),
(477384,53121,'1998-03-04','1999-03-04'),
(477384,56211,'1999-03-04','2000-03-03'),
(477384,59102,'2000-03-03','2001-03-03'),
(477384,62059,'2001-03-03','2002-03-03'),
(477384,66322,'2002-03-03','9999-01-01');


INSERT INTO `salaries` VALUES (478034,53788,'1992-09-01','1993-09-01'),
(478034,54717,'1993-09-01','1994-09-01'),
(478034,57882,'1994-09-01','1995-09-01'),
(478034,57896,'1995-09-01','1996-08-31'),
(478034,58390,'1996-08-31','1997-08-31'),
(478034,62195,'1997-08-31','1998-08-31'),
(478034,63874,'1998-08-31','1999-08-31'),
(478034,64165,'1999-08-31','2000-08-30'),
(478034,67793,'2000-08-30','2001-08-30'),
(478034,69730,'2001-08-30','9999-01-01');


INSERT INTO `salaries` VALUES (478331,40000,'1996-06-06','1997-06-06'),
(478331,41053,'1997-06-06','1998-06-06'),
(478331,44350,'1998-06-06','1999-06-06'),
(478331,44774,'1999-06-06','2000-06-05'),
(478331,49114,'2000-06-05','2000-07-13'),
(478439,47250,'1997-11-04','1998-11-04'),
(478439,49365,'1998-11-04','1999-11-04'),
(478439,49295,'1999-11-04','2000-11-03'),
(478439,49799,'2000-11-03','2001-11-03'),
(478439,52928,'2001-11-03','9999-01-01');


INSERT INTO `salaries` VALUES (478442,40000,'1997-03-10','1998-03-10'),
(478442,41118,'1998-03-10','1999-03-10'),
(478442,44158,'1999-03-10','2000-03-09'),
(478442,44499,'2000-03-09','2001-03-09'),
(478442,44057,'2001-03-09','2002-03-09'),
(478442,48302,'2002-03-09','9999-01-01'),
(478460,75788,'1986-11-16','1987-11-16'),
(478460,77067,'1987-11-16','1988-11-15'),
(478460,80128,'1988-11-15','1989-11-15'),
(478460,80522,'1989-11-15','1990-11-15');


INSERT INTO `salaries` VALUES (478460,80181,'1990-11-15','1991-11-15'),
(478460,83678,'1991-11-15','1992-11-14'),
(478460,87223,'1992-11-14','1993-11-14'),
(478460,90919,'1993-11-14','1994-11-14'),
(478460,93010,'1994-11-14','1995-11-14'),
(478460,93395,'1995-11-14','1996-11-13'),
(478460,97635,'1996-11-13','1997-11-13'),
(478460,99080,'1997-11-13','1998-11-13'),
(478460,102834,'1998-11-13','1999-11-13'),
(478460,103588,'1999-11-13','1999-12-08');


INSERT INTO `salaries` VALUES (479267,40000,'1994-11-23','1995-11-23'),
(479267,41316,'1995-11-23','1996-11-22'),
(479267,42143,'1996-11-22','1997-11-22'),
(479267,46365,'1997-11-22','1998-11-22'),
(479267,46003,'1998-11-22','1999-11-22'),
(479267,47142,'1999-11-22','2000-11-21'),
(479267,50163,'2000-11-21','2001-11-21'),
(479267,50696,'2001-11-21','9999-01-01'),
(479287,62977,'1992-09-19','1993-09-19'),
(479287,63477,'1993-09-19','1994-09-19');


INSERT INTO `salaries` VALUES (479287,63268,'1994-09-19','1995-09-19'),
(479287,63467,'1995-09-19','1996-09-18'),
(479287,64669,'1996-09-18','1997-09-18'),
(479287,68338,'1997-09-18','1998-09-18'),
(479287,69375,'1998-09-18','1999-09-18'),
(479287,73432,'1999-09-18','2000-09-17'),
(479287,77299,'2000-09-17','2001-09-17'),
(479287,78259,'2001-09-17','9999-01-01'),
(479747,49706,'1991-06-26','1991-07-12'),
(480010,40000,'1998-11-07','1999-11-07');


INSERT INTO `salaries` VALUES (480010,41152,'1999-11-07','2000-03-23'),
(480016,50873,'1986-09-04','1987-09-04'),
(480016,55316,'1987-09-04','1988-03-02'),
(480019,54669,'1996-08-22','1997-08-22'),
(480019,57728,'1997-08-22','1998-08-22'),
(480019,59224,'1998-08-22','1999-08-22'),
(480019,58891,'1999-08-22','2000-07-24'),
(480923,52544,'1987-07-01','1988-06-30'),
(480923,53345,'1988-06-30','1989-06-06'),
(481107,47925,'1992-04-15','1993-04-15');


INSERT INTO `salaries` VALUES (481107,51597,'1993-04-15','1994-04-15'),
(481107,55979,'1994-04-15','1995-04-15'),
(481107,59261,'1995-04-15','1996-04-14'),
(481107,60199,'1996-04-14','1997-04-14'),
(481107,63543,'1997-04-14','1998-04-14'),
(481107,67125,'1998-04-14','1999-04-14'),
(481107,70287,'1999-04-14','2000-04-13'),
(481107,74358,'2000-04-13','2001-04-13'),
(481107,75895,'2001-04-13','2002-04-13'),
(481107,77185,'2002-04-13','9999-01-01');


INSERT INTO `salaries` VALUES (481113,40000,'1988-01-14','1989-01-13'),
(481113,41072,'1989-01-13','1990-01-13'),
(481113,44122,'1990-01-13','1991-01-13'),
(481113,43967,'1991-01-13','1992-01-13'),
(481113,45199,'1992-01-13','1993-01-12'),
(481113,48506,'1993-01-12','1994-01-12'),
(481113,51114,'1994-01-12','1995-01-12'),
(481113,53368,'1995-01-12','1996-01-12'),
(481113,53917,'1996-01-12','1997-01-11'),
(481113,55171,'1997-01-11','1998-01-11');


INSERT INTO `salaries` VALUES (481113,55271,'1998-01-11','1999-01-11'),
(481113,58322,'1999-01-11','2000-01-11'),
(481113,61290,'2000-01-11','2001-01-10'),
(481113,61239,'2001-01-10','2002-01-10'),
(481113,63161,'2002-01-10','9999-01-01'),
(481144,40000,'1994-05-16','1995-05-16'),
(481144,40590,'1995-05-16','1996-05-15'),
(481144,43832,'1996-05-15','1997-05-15'),
(481144,45848,'1997-05-15','1998-05-15'),
(481144,45495,'1998-05-15','1999-05-15');


INSERT INTO `salaries` VALUES (481144,48996,'1999-05-15','2000-05-14'),
(481144,50384,'2000-05-14','2001-05-14'),
(481144,53551,'2001-05-14','2002-05-14'),
(481144,56443,'2002-05-14','9999-01-01'),
(481503,42768,'1992-08-23','1993-08-23'),
(481503,46146,'1993-08-23','1994-08-23'),
(481503,48207,'1994-08-23','1995-08-23'),
(481503,52302,'1995-08-23','1996-08-22'),
(481503,55703,'1996-08-22','1997-08-22'),
(481503,59719,'1997-08-22','1998-08-22');


INSERT INTO `salaries` VALUES (481503,60556,'1998-08-22','1999-08-22'),
(481503,60232,'1999-08-22','2000-08-21'),
(481503,63205,'2000-08-21','2001-08-21'),
(481503,63642,'2001-08-21','9999-01-01'),
(481851,40000,'1994-03-19','1995-03-19'),
(481851,39772,'1995-03-19','1995-12-09'),
(482133,41461,'1994-08-10','1995-08-10'),
(482133,43246,'1995-08-10','1996-08-09'),
(482133,46151,'1996-08-09','1997-08-09'),
(482133,47422,'1997-08-09','1998-08-09');


INSERT INTO `salaries` VALUES (482133,51170,'1998-08-09','1999-08-09'),
(482133,55111,'1999-08-09','2000-08-08'),
(482133,54967,'2000-08-08','2001-08-08'),
(482133,57014,'2001-08-08','9999-01-01'),
(482158,40000,'1989-10-27','1990-10-27'),
(482158,43745,'1990-10-27','1991-10-27'),
(482158,47357,'1991-10-27','1992-10-25'),
(482158,47855,'1992-10-25','1993-10-26'),
(482158,49501,'1993-10-26','1994-10-26'),
(482158,52546,'1994-10-26','1995-10-26');


INSERT INTO `salaries` VALUES (482158,55992,'1995-10-26','1996-10-25'),
(482158,57304,'1996-10-25','1997-10-25'),
(482158,61204,'1997-10-25','1998-10-25'),
(482158,65021,'1998-10-25','1999-10-25'),
(482158,67946,'1999-10-25','2000-10-20'),
(482279,42214,'1998-07-08','1999-07-08'),
(482279,41986,'1999-07-08','2000-07-07'),
(482279,46100,'2000-07-07','2001-07-07'),
(482279,50226,'2001-07-07','2002-07-07'),
(482279,52621,'2002-07-07','9999-01-01');


INSERT INTO `salaries` VALUES (482347,53665,'1998-09-28','1999-09-28'),
(482347,54181,'1999-09-28','2000-09-27'),
(482347,58456,'2000-09-27','2001-09-27'),
(482347,59529,'2001-09-27','9999-01-01'),
(482555,65796,'1985-11-30','1986-11-30'),
(482555,65835,'1986-11-30','1987-11-30'),
(482555,68900,'1987-11-30','1988-11-29'),
(482555,68501,'1988-11-29','1989-11-29'),
(482555,68794,'1989-11-29','1990-11-29'),
(482555,71740,'1990-11-29','1991-11-29');


INSERT INTO `salaries` VALUES (482555,75855,'1991-11-29','1992-11-28'),
(482555,79326,'1992-11-28','1993-11-28'),
(482555,81555,'1993-11-28','1994-11-28'),
(482555,85042,'1994-11-28','1995-11-28'),
(482555,89259,'1995-11-28','1996-11-27'),
(482555,93063,'1996-11-27','1997-11-27'),
(482555,95842,'1997-11-27','1998-11-27'),
(482555,99724,'1998-11-27','1999-11-27'),
(482555,101303,'1999-11-27','2000-11-26'),
(482555,103619,'2000-11-26','2001-11-26');


INSERT INTO `salaries` VALUES (482555,107505,'2001-11-26','9999-01-01'),
(482689,40000,'1999-07-03','2000-07-02'),
(482689,41716,'2000-07-02','2001-07-02'),
(482689,42261,'2001-07-02','2002-07-02'),
(482689,45704,'2002-07-02','9999-01-01'),
(482722,68467,'1989-04-29','1990-04-29'),
(482722,69708,'1990-04-29','1991-04-29'),
(482722,70183,'1991-04-29','1992-04-28'),
(482722,71925,'1992-04-28','1993-04-28'),
(482722,73245,'1993-04-28','1994-04-28');


INSERT INTO `salaries` VALUES (482722,76784,'1994-04-28','1995-01-18'),
(482765,40000,'1996-01-04','1997-01-03'),
(482765,42569,'1997-01-03','1998-01-03'),
(482765,43750,'1998-01-03','1999-01-03'),
(482765,44067,'1999-01-03','2000-01-03'),
(482765,45490,'2000-01-03','2000-03-21'),
(482786,82336,'1985-03-24','1986-03-24'),
(482786,84344,'1986-03-24','1987-03-24'),
(482786,88800,'1987-03-24','1988-03-23'),
(482786,91273,'1988-03-23','1989-03-23');


INSERT INTO `salaries` VALUES (482786,94291,'1989-03-23','1990-03-23'),
(482786,95516,'1990-03-23','1991-03-23'),
(482786,96106,'1991-03-23','1992-03-22'),
(482786,100070,'1992-03-22','1993-03-22'),
(482786,100109,'1993-03-22','1994-03-22'),
(482786,99653,'1994-03-22','1995-03-22'),
(482786,101592,'1995-03-22','1996-03-21'),
(482786,102721,'1996-03-21','1996-05-04'),
(483081,87513,'1988-09-15','1989-09-15'),
(483081,88712,'1989-09-15','1990-09-15');


INSERT INTO `salaries` VALUES (483081,90948,'1990-09-15','1991-09-15'),
(483081,92237,'1991-09-15','1992-09-14'),
(483081,95390,'1992-09-14','1993-09-14'),
(483081,95816,'1993-09-14','1994-09-14'),
(483081,98802,'1994-09-14','1995-09-14'),
(483081,101095,'1995-09-14','1996-09-13'),
(483081,104794,'1996-09-13','1997-09-13'),
(483081,108397,'1997-09-13','1998-09-13'),
(483081,108531,'1998-09-13','1999-09-13'),
(483081,109330,'1999-09-13','2000-09-12');


INSERT INTO `salaries` VALUES (483081,112969,'2000-09-12','2001-09-12'),
(483081,114159,'2001-09-12','9999-01-01'),
(483171,41467,'1988-11-14','1989-11-14'),
(483171,45831,'1989-11-14','1990-11-14'),
(483171,49699,'1990-11-14','1991-11-14'),
(483171,50866,'1991-11-14','1992-11-13'),
(483171,52189,'1992-11-13','1993-11-13'),
(483171,55864,'1993-11-13','1994-11-13'),
(483171,59188,'1994-11-13','1995-08-15'),
(483399,70798,'1997-05-11','1998-05-11');


INSERT INTO `salaries` VALUES (483399,74975,'1998-05-11','1999-05-11'),
(483399,75945,'1999-05-11','1999-05-29'),
(483624,60157,'1986-03-23','1987-03-23'),
(483624,61756,'1987-03-23','1988-03-22'),
(483624,61873,'1988-03-22','1989-03-22'),
(483624,65951,'1989-03-22','1990-03-22'),
(483624,68291,'1990-03-22','1991-03-22'),
(483624,70807,'1991-03-22','1992-03-21'),
(483624,71753,'1992-03-21','1993-03-21'),
(483624,72924,'1993-03-21','1994-03-21');


INSERT INTO `salaries` VALUES (483624,74602,'1994-03-21','1995-03-21'),
(483624,75194,'1995-03-21','1996-03-20'),
(483624,76891,'1996-03-20','1997-03-20'),
(483624,79116,'1997-03-20','1998-03-20'),
(483624,83154,'1998-03-20','1999-03-20'),
(483624,86070,'1999-03-20','2000-03-19'),
(483624,85872,'2000-03-19','2001-03-19'),
(483624,87328,'2001-03-19','2002-03-19'),
(483624,87241,'2002-03-19','9999-01-01'),
(484242,41134,'1989-07-22','1990-07-22');


INSERT INTO `salaries` VALUES (484242,44965,'1990-07-22','1991-07-22'),
(484242,46599,'1991-07-22','1992-07-21'),
(484242,46139,'1992-07-21','1993-07-21'),
(484242,46433,'1993-07-21','1994-07-21'),
(484242,47763,'1994-07-21','1995-07-21'),
(484242,52060,'1995-07-21','1996-07-20'),
(484242,54863,'1996-07-20','1997-07-20'),
(484242,55035,'1997-07-20','1998-07-20'),
(484242,55442,'1998-07-20','1999-07-20'),
(484242,59629,'1999-07-20','2000-07-19');


INSERT INTO `salaries` VALUES (484242,62041,'2000-07-19','2001-07-19'),
(484242,63306,'2001-07-19','2002-07-19'),
(484242,64401,'2002-07-19','9999-01-01'),
(484451,45590,'1994-01-04','1995-01-04'),
(484451,48581,'1995-01-04','1996-01-04'),
(484451,48428,'1996-01-04','1997-01-03'),
(484451,48607,'1997-01-03','1998-01-03'),
(484451,51325,'1998-01-03','1999-01-03'),
(484451,52168,'1999-01-03','2000-01-03'),
(484451,54334,'2000-01-03','2001-01-02');


INSERT INTO `salaries` VALUES (484451,57812,'2001-01-02','2002-01-02'),
(484451,61241,'2002-01-02','9999-01-01'),
(484460,40000,'1992-11-29','1993-11-29'),
(484460,43166,'1993-11-29','1994-11-29'),
(484460,43677,'1994-11-29','1995-11-29'),
(484460,46043,'1995-11-29','1996-11-28'),
(484460,48494,'1996-11-28','1997-11-28'),
(484460,51908,'1997-11-28','1998-11-28'),
(484460,52966,'1998-11-28','1999-11-28'),
(484460,57299,'1999-11-28','2000-11-27');


INSERT INTO `salaries` VALUES (484460,57569,'2000-11-27','2001-11-27'),
(484460,57652,'2001-11-27','9999-01-01'),
(484778,48783,'1997-02-23','1998-02-23'),
(484778,53030,'1998-02-23','1999-02-23'),
(484778,52926,'1999-02-23','1999-08-25'),
(484889,50546,'1986-08-02','1987-04-24'),
(485483,40000,'1996-07-20','1997-07-20'),
(485483,41914,'1997-07-20','1998-07-20'),
(485483,43884,'1998-07-20','1999-07-20'),
(485483,46562,'1999-07-20','2000-07-19');


INSERT INTO `salaries` VALUES (485483,46610,'2000-07-19','2001-07-19'),
(485483,51015,'2001-07-19','2002-01-02'),
(485682,40000,'1997-03-20','1998-03-20'),
(485682,40750,'1998-03-20','1999-03-20'),
(485682,40296,'1999-03-20','2000-03-19'),
(485682,42727,'2000-03-19','2001-03-19'),
(485682,44635,'2001-03-19','2002-03-19'),
(485682,47525,'2002-03-19','9999-01-01'),
(485905,51270,'1988-11-11','1989-11-11'),
(485905,52728,'1989-11-11','1990-11-11');


INSERT INTO `salaries` VALUES (485905,56837,'1990-11-11','1991-11-11'),
(485905,58236,'1991-11-11','1992-11-10'),
(485905,62577,'1992-11-10','1993-11-10'),
(485905,63884,'1993-11-10','1994-11-10'),
(485905,67444,'1994-11-10','1995-11-10'),
(485905,67078,'1995-11-10','1996-11-09'),
(485905,70375,'1996-11-09','1997-11-09'),
(485905,74698,'1997-11-09','1998-11-09'),
(485905,78301,'1998-11-09','1999-11-09'),
(485905,78543,'1999-11-09','2000-11-08');


INSERT INTO `salaries` VALUES (485905,78155,'2000-11-08','2001-11-08'),
(485905,79035,'2001-11-08','9999-01-01'),
(486022,40000,'1988-09-12','1989-09-12'),
(486022,41953,'1989-09-12','1990-09-12'),
(486022,45408,'1990-09-12','1991-09-12'),
(486022,49890,'1991-09-12','1992-09-11'),
(486022,51160,'1992-09-11','1993-09-11'),
(486022,54136,'1993-09-11','1994-09-11'),
(486022,56998,'1994-09-11','1995-09-11'),
(486022,57226,'1995-09-11','1996-09-10');


INSERT INTO `salaries` VALUES (486022,60125,'1996-09-10','1997-09-10'),
(486022,62910,'1997-09-10','1998-09-10'),
(486022,66020,'1998-09-10','1999-09-10'),
(486022,70305,'1999-09-10','2000-09-09'),
(486022,74194,'2000-09-09','2001-09-09'),
(486022,76591,'2001-09-09','9999-01-01'),
(486306,40578,'1994-11-19','1995-11-19'),
(486306,43887,'1995-11-19','1996-11-18'),
(486306,43995,'1996-11-18','1997-11-18'),
(486306,45480,'1997-11-18','1998-11-18');


INSERT INTO `salaries` VALUES (486306,45058,'1998-11-18','1999-11-18'),
(486306,49496,'1999-11-18','2000-11-17'),
(486306,50826,'2000-11-17','2001-11-17'),
(486306,53623,'2001-11-17','9999-01-01'),
(487218,40000,'1986-11-07','1987-11-07'),
(487218,41925,'1987-11-07','1988-11-06'),
(487218,43991,'1988-11-06','1989-11-06'),
(487218,48276,'1989-11-06','1990-11-06'),
(487218,50863,'1990-11-06','1991-11-06'),
(487218,53682,'1991-11-06','1992-11-05');


INSERT INTO `salaries` VALUES (487218,53437,'1992-11-05','1993-11-05'),
(487218,53615,'1993-11-05','1994-11-05'),
(487218,55677,'1994-11-05','1995-11-05'),
(487218,56130,'1995-11-05','1996-11-04'),
(487218,56598,'1996-11-04','1997-11-04'),
(487218,60131,'1997-11-04','1998-11-04'),
(487218,63335,'1998-11-04','1999-11-04'),
(487218,65802,'1999-11-04','2000-11-03'),
(487218,67173,'2000-11-03','2001-11-03'),
(487218,68697,'2001-11-03','9999-01-01');


INSERT INTO `salaries` VALUES (487252,44254,'1988-02-27','1989-02-26'),
(487252,45672,'1989-02-26','1990-02-26'),
(487252,45658,'1990-02-26','1991-02-26'),
(487252,48652,'1991-02-26','1992-02-26'),
(487252,51833,'1992-02-26','1993-02-25'),
(487252,55727,'1993-02-25','1994-02-25'),
(487252,57797,'1994-02-25','1995-02-25'),
(487252,61713,'1995-02-25','1996-02-25'),
(487252,63973,'1996-02-25','1997-02-24'),
(487252,66265,'1997-02-24','1998-02-24');


INSERT INTO `salaries` VALUES (487252,66376,'1998-02-24','1999-02-24'),
(487252,70019,'1999-02-24','2000-02-24'),
(487252,72101,'2000-02-24','2001-02-23'),
(487252,75311,'2001-02-23','2002-02-23'),
(487252,76515,'2002-02-23','9999-01-01'),
(487925,40000,'1994-08-31','1995-08-31'),
(487925,39995,'1995-08-31','1996-08-30'),
(487925,41220,'1996-08-30','1997-08-30'),
(487925,43817,'1997-08-30','1998-08-30'),
(487925,47587,'1998-08-30','1999-08-30');


INSERT INTO `salaries` VALUES (487925,49478,'1999-08-30','2000-08-29'),
(487925,52946,'2000-08-29','2001-08-29'),
(487925,55333,'2001-08-29','9999-01-01'),
(488231,40105,'1995-02-24','1996-02-24'),
(488231,40098,'1996-02-24','1997-02-23'),
(488231,40200,'1997-02-23','1998-02-23'),
(488231,44366,'1998-02-23','1999-02-23'),
(488231,45484,'1999-02-23','2000-02-23'),
(488231,46353,'2000-02-23','2001-02-22'),
(488231,47347,'2001-02-22','2002-02-22');


INSERT INTO `salaries` VALUES (488231,50769,'2002-02-22','9999-01-01'),
(488385,40000,'1991-11-30','1992-11-29'),
(488385,39727,'1992-11-29','1993-03-26'),
(488504,42637,'1998-05-12','1999-05-12'),
(488504,44678,'1999-05-12','2000-05-11'),
(488504,45665,'2000-05-11','2001-05-11'),
(488504,49311,'2001-05-11','2002-05-11'),
(488504,52804,'2002-05-11','9999-01-01'),
(488538,40000,'1996-05-16','1997-05-16'),
(488538,44007,'1997-05-16','1998-05-16');


INSERT INTO `salaries` VALUES (488538,44107,'1998-05-16','1999-05-16'),
(488538,43772,'1999-05-16','2000-05-15'),
(488538,47636,'2000-05-15','2001-05-15'),
(488538,50254,'2001-05-15','2002-05-15'),
(488538,53798,'2002-05-15','9999-01-01'),
(488774,52202,'1997-10-10','1998-10-10'),
(488774,54324,'1998-10-10','1999-10-10'),
(488774,54561,'1999-10-10','2000-10-09'),
(488774,54975,'2000-10-09','2001-10-09'),
(488774,56996,'2001-10-09','9999-01-01');


INSERT INTO `salaries` VALUES (488997,40793,'1987-09-10','1988-09-09'),
(488997,44131,'1988-09-09','1989-09-09'),
(488997,45801,'1989-09-09','1990-09-09'),
(488997,49700,'1990-09-09','1991-09-09'),
(488997,52851,'1991-09-09','1992-09-08'),
(488997,54795,'1992-09-08','1993-09-08'),
(488997,54928,'1993-09-08','1994-09-08'),
(488997,58150,'1994-09-08','1995-09-08'),
(488997,59862,'1995-09-08','1996-09-07'),
(488997,63500,'1996-09-07','1997-09-07');


INSERT INTO `salaries` VALUES (488997,66529,'1997-09-07','1998-09-07'),
(488997,68067,'1998-09-07','1999-09-07'),
(488997,70868,'1999-09-07','2000-09-06'),
(488997,73746,'2000-09-06','2001-09-06'),
(488997,77693,'2001-09-06','9999-01-01'),
(489215,40000,'1999-08-28','2000-08-27'),
(489215,41619,'2000-08-27','2001-08-27'),
(489215,45909,'2001-08-27','9999-01-01'),
(489339,40000,'1989-11-10','1990-11-10'),
(489339,41375,'1990-11-10','1991-11-10');


INSERT INTO `salaries` VALUES (489339,45860,'1991-11-10','1992-11-09'),
(489339,46805,'1992-11-09','1993-11-09'),
(489339,50603,'1993-11-09','1994-11-09'),
(489339,50948,'1994-11-09','1995-11-09'),
(489339,55198,'1995-11-09','1996-11-08'),
(489339,57645,'1996-11-08','1997-11-08'),
(489339,58621,'1997-11-08','1998-11-08'),
(489339,59088,'1998-11-08','1999-11-08'),
(489339,60296,'1999-11-08','2000-11-07'),
(489339,61504,'2000-11-07','2001-11-07');


INSERT INTO `salaries` VALUES (489339,63057,'2001-11-07','9999-01-01'),
(489378,40000,'1985-11-15','1986-11-15'),
(489378,40267,'1986-11-15','1987-11-15'),
(489378,41158,'1987-11-15','1988-11-14'),
(489378,43167,'1988-11-14','1989-11-14'),
(489378,46235,'1989-11-14','1990-11-14'),
(489378,48936,'1990-11-14','1991-11-14'),
(489378,49129,'1991-11-14','1992-11-13'),
(489378,50244,'1992-11-13','1993-11-13'),
(489378,54574,'1993-11-13','1994-11-13');


INSERT INTO `salaries` VALUES (489378,56178,'1994-11-13','1995-11-13'),
(489378,57025,'1995-11-13','1996-11-12'),
(489378,61150,'1996-11-12','1997-11-12'),
(489378,65287,'1997-11-12','1998-11-12'),
(489378,69671,'1998-11-12','1999-11-12'),
(489378,73137,'1999-11-12','2000-11-11'),
(489378,74185,'2000-11-11','2001-11-11'),
(489378,77673,'2001-11-11','9999-01-01'),
(489404,59882,'1997-12-03','1998-12-03'),
(489404,63458,'1998-12-03','1999-12-03');


INSERT INTO `salaries` VALUES (489404,63876,'1999-12-03','2000-12-02'),
(489404,63860,'2000-12-02','2001-12-02'),
(489404,64129,'2001-12-02','9999-01-01'),
(489514,50916,'1988-08-15','1989-08-15'),
(489514,53623,'1989-08-15','1990-08-15'),
(489514,54758,'1990-08-15','1991-08-15'),
(489514,58476,'1991-08-15','1992-08-14'),
(489514,61506,'1992-08-14','1993-08-14'),
(489514,64761,'1993-08-14','1994-08-14'),
(489514,68066,'1994-08-14','1995-08-14');


INSERT INTO `salaries` VALUES (489514,71704,'1995-08-14','1996-08-13'),
(489514,74407,'1996-08-13','1997-08-13'),
(489514,78599,'1997-08-13','1998-08-13'),
(489514,80518,'1998-08-13','1999-08-13'),
(489514,82785,'1999-08-13','2000-08-12'),
(489514,83902,'2000-08-12','2001-08-12'),
(489514,86103,'2001-08-12','9999-01-01'),
(489658,40000,'1985-09-23','1986-09-23'),
(489658,41014,'1986-09-23','1987-09-23'),
(489658,41594,'1987-09-23','1988-09-22');


INSERT INTO `salaries` VALUES (489658,41136,'1988-09-22','1989-09-22'),
(489658,43014,'1989-09-22','1990-09-22'),
(489658,44468,'1990-09-22','1991-09-22'),
(489658,48141,'1991-09-22','1992-09-21'),
(489658,50295,'1992-09-21','1993-09-21'),
(489658,49863,'1993-09-21','1994-09-21'),
(489658,52515,'1994-09-21','1995-09-21'),
(489658,56159,'1995-09-21','1996-09-20'),
(489658,58938,'1996-09-20','1997-09-20'),
(489658,63176,'1997-09-20','1998-01-22');


INSERT INTO `salaries` VALUES (490024,72159,'1991-11-28','1992-11-27'),
(490024,71881,'1992-11-27','1993-11-27'),
(490024,73615,'1993-11-27','1994-11-27'),
(490024,75924,'1994-11-27','1995-11-27'),
(490024,75998,'1995-11-27','1996-11-26'),
(490024,78214,'1996-11-26','1997-11-26'),
(490024,78906,'1997-11-26','1998-11-26'),
(490024,82105,'1998-11-26','1999-11-26'),
(490024,81742,'1999-11-26','2000-11-25'),
(490024,85071,'2000-11-25','2001-11-25');


INSERT INTO `salaries` VALUES (490024,85602,'2001-11-25','9999-01-01'),
(490025,40000,'1986-03-07','1987-03-07'),
(490025,41550,'1987-03-07','1988-03-06'),
(490025,42766,'1988-03-06','1989-03-06'),
(490025,43838,'1989-03-06','1990-03-06'),
(490025,46913,'1990-03-06','1991-03-06'),
(490025,50268,'1991-03-06','1992-03-05'),
(490025,52493,'1992-03-05','1993-03-05'),
(490025,56433,'1993-03-05','1994-03-05'),
(490025,58908,'1994-03-05','1995-03-05');


INSERT INTO `salaries` VALUES (490025,61356,'1995-03-05','1996-03-04'),
(490025,65759,'1996-03-04','1997-03-04'),
(490025,69567,'1997-03-04','1998-03-04'),
(490025,71604,'1998-03-04','1999-03-04'),
(490025,75845,'1999-03-04','2000-03-03'),
(490025,79527,'2000-03-03','2001-03-03'),
(490025,80935,'2001-03-03','2002-03-03'),
(490025,85146,'2002-03-03','9999-01-01'),
(490095,45775,'1999-06-12','2000-06-11'),
(490095,49873,'2000-06-11','2001-06-11');


INSERT INTO `salaries` VALUES (490095,50110,'2001-06-11','2002-06-11'),
(490095,52721,'2002-06-11','9999-01-01'),
(490155,46385,'1989-04-25','1990-04-25'),
(490155,49902,'1990-04-25','1991-04-25'),
(490155,49433,'1991-04-25','1991-08-23'),
(490390,40000,'1988-01-01','1988-12-31'),
(490390,41556,'1988-12-31','1989-12-31'),
(490390,44004,'1989-12-31','1990-12-31'),
(490390,46778,'1990-12-31','1991-12-31'),
(490390,50363,'1991-12-31','1992-12-30');


INSERT INTO `salaries` VALUES (490390,50916,'1992-12-30','1993-12-30'),
(490390,51377,'1993-12-30','1994-12-30'),
(490390,55081,'1994-12-30','1995-12-30'),
(490390,59390,'1995-12-30','1996-12-29'),
(490390,63089,'1996-12-29','1997-12-29'),
(490390,65668,'1997-12-29','1998-12-29'),
(490390,65508,'1998-12-29','1999-12-29'),
(490390,66038,'1999-12-29','2000-12-28'),
(490390,67176,'2000-12-28','2001-12-28'),
(490390,67489,'2001-12-28','9999-01-01');


INSERT INTO `salaries` VALUES (490647,40000,'1992-02-09','1993-02-08'),
(490647,40186,'1993-02-08','1994-02-08'),
(490647,43805,'1994-02-08','1995-02-08'),
(490647,48273,'1995-02-08','1996-02-08'),
(490647,50015,'1996-02-08','1997-02-07'),
(490647,50929,'1997-02-07','1998-02-07'),
(490647,53948,'1998-02-07','1999-02-07'),
(490647,55358,'1999-02-07','2000-02-07'),
(490647,59628,'2000-02-07','2001-02-06'),
(490647,61647,'2001-02-06','2002-02-06');


INSERT INTO `salaries` VALUES (490647,61583,'2002-02-06','9999-01-01'),
(490747,40000,'1998-11-18','1999-11-18'),
(490747,43736,'1999-11-18','2000-11-17'),
(490747,44633,'2000-11-17','2001-11-17'),
(490747,46282,'2001-11-17','9999-01-01'),
(491048,61134,'1992-06-14','1993-06-14'),
(491048,64341,'1993-06-14','1994-06-14'),
(491048,65642,'1994-06-14','1995-06-14'),
(491048,66357,'1995-06-14','1996-06-13'),
(491048,70622,'1996-06-13','1997-06-13');


INSERT INTO `salaries` VALUES (491048,70215,'1997-06-13','1998-06-13'),
(491048,70267,'1998-06-13','1999-06-13'),
(491048,73891,'1999-06-13','2000-06-12'),
(491048,76356,'2000-06-12','2001-06-12'),
(491048,77681,'2001-06-12','2002-06-12'),
(491048,79217,'2002-06-12','9999-01-01'),
(491358,40000,'1992-10-31','1993-10-31'),
(491358,43504,'1993-10-31','1994-10-31'),
(491358,46884,'1994-10-31','1995-10-31'),
(491358,50781,'1995-10-31','1996-03-17');


INSERT INTO `salaries` VALUES (491370,41753,'1994-01-26','1995-01-26'),
(491370,42720,'1995-01-26','1996-01-26'),
(491370,45538,'1996-01-26','1997-01-25'),
(491370,47502,'1997-01-25','1998-01-25'),
(491370,48117,'1998-01-25','1999-01-25'),
(491370,50588,'1999-01-25','2000-01-25'),
(491370,55027,'2000-01-25','2001-01-24'),
(491370,54706,'2001-01-24','2002-01-24'),
(491370,55686,'2002-01-24','9999-01-01'),
(491978,47072,'1990-02-19','1991-02-19');


INSERT INTO `salaries` VALUES (491978,50419,'1991-02-19','1992-02-19'),
(491978,51123,'1992-02-19','1993-02-18'),
(491978,54301,'1993-02-18','1994-02-18'),
(491978,58330,'1994-02-18','1995-02-18'),
(491978,59117,'1995-02-18','1996-02-18'),
(491978,60123,'1996-02-18','1997-02-17'),
(491978,61932,'1997-02-17','1998-02-17'),
(491978,63813,'1998-02-17','1999-02-17'),
(491978,64842,'1999-02-17','2000-02-17'),
(491978,66158,'2000-02-17','2001-02-16');


INSERT INTO `salaries` VALUES (491978,66487,'2001-02-16','2002-02-16'),
(491978,67781,'2002-02-16','9999-01-01'),
(492217,43116,'1991-09-28','1992-09-27'),
(492217,45987,'1992-09-27','1993-09-27'),
(492217,46859,'1993-09-27','1994-09-27'),
(492217,50838,'1994-09-27','1995-09-27'),
(492217,52629,'1995-09-27','1996-09-26'),
(492217,54672,'1996-09-26','1997-09-26'),
(492217,59142,'1997-09-26','1998-09-26'),
(492217,58935,'1998-09-26','1999-09-26');


INSERT INTO `salaries` VALUES (492217,62723,'1999-09-26','2000-09-25'),
(492217,63812,'2000-09-25','2001-09-25'),
(492217,66701,'2001-09-25','9999-01-01'),
(492566,40000,'1988-01-09','1989-01-08'),
(492566,43658,'1989-01-08','1990-01-08'),
(492566,46020,'1990-01-08','1991-01-08'),
(492566,49856,'1991-01-08','1992-01-08'),
(492566,53110,'1992-01-08','1993-01-07'),
(492566,52640,'1993-01-07','1994-01-07'),
(492566,54248,'1994-01-07','1995-01-07');


INSERT INTO `salaries` VALUES (492566,54858,'1995-01-07','1996-01-07'),
(492566,57201,'1996-01-07','1997-01-06'),
(492566,59412,'1997-01-06','1998-01-06'),
(492566,59012,'1998-01-06','1999-01-06'),
(492566,60015,'1999-01-06','2000-01-06'),
(492566,62889,'2000-01-06','2001-01-05'),
(492566,67364,'2001-01-05','2002-01-05'),
(492566,68050,'2002-01-05','9999-01-01'),
(493013,40000,'1996-02-01','1997-01-31'),
(493013,41241,'1997-01-31','1998-01-31');


INSERT INTO `salaries` VALUES (493013,41924,'1998-01-31','1999-01-31'),
(493013,41850,'1999-01-31','2000-01-31'),
(493013,43612,'2000-01-31','2001-01-30'),
(493013,47342,'2001-01-30','2002-01-30'),
(493013,47009,'2002-01-30','9999-01-01'),
(493516,41747,'1985-04-02','1986-04-02'),
(493516,44674,'1986-04-02','1987-04-02'),
(493516,49147,'1987-04-02','1988-04-01'),
(493516,51922,'1988-04-01','1989-04-01'),
(493516,52061,'1989-04-01','1990-04-01');


INSERT INTO `salaries` VALUES (493516,53296,'1990-04-01','1991-04-01'),
(493516,56738,'1991-04-01','1992-03-31'),
(493516,58635,'1992-03-31','1993-03-31'),
(493516,59568,'1993-03-31','1994-03-31'),
(493516,63732,'1994-03-31','1995-03-31'),
(493516,65475,'1995-03-31','1996-03-30'),
(493516,69012,'1996-03-30','1997-03-30'),
(493516,72172,'1997-03-30','1998-03-30'),
(493516,75509,'1998-03-30','1999-03-30'),
(493516,77034,'1999-03-30','2000-03-29');


INSERT INTO `salaries` VALUES (493516,78048,'2000-03-29','2001-03-29'),
(493516,80709,'2001-03-29','2002-03-29'),
(493516,84341,'2002-03-29','9999-01-01'),
(494052,40000,'1994-05-26','1995-05-26'),
(494052,44020,'1995-05-26','1996-05-25'),
(494052,45377,'1996-05-25','1997-05-25'),
(494052,49306,'1997-05-25','1998-05-25'),
(494052,48947,'1998-05-25','1999-05-25'),
(494052,50074,'1999-05-25','2000-05-24'),
(494052,52356,'2000-05-24','2001-05-24');


INSERT INTO `salaries` VALUES (494052,54075,'2001-05-24','2002-05-24'),
(494052,54568,'2002-05-24','9999-01-01'),
(494230,67278,'1987-07-26','1988-07-25'),
(494230,71092,'1988-07-25','1989-07-25'),
(494230,72620,'1989-07-25','1990-07-25'),
(494230,72422,'1990-07-25','1991-07-25'),
(494230,72617,'1991-07-25','1992-07-24'),
(494230,76276,'1992-07-24','1993-07-24'),
(494230,75890,'1993-07-24','1994-07-24'),
(494230,78958,'1994-07-24','1995-07-24');


INSERT INTO `salaries` VALUES (494230,83252,'1995-07-24','1996-07-23'),
(494230,83859,'1996-07-23','1997-07-23'),
(494230,87241,'1997-07-23','1998-07-23'),
(494230,86889,'1998-07-23','1999-07-23'),
(494230,87820,'1999-07-23','2000-07-22'),
(494230,90528,'2000-07-22','2001-07-22'),
(494230,90597,'2001-07-22','2002-07-22'),
(494230,91188,'2002-07-22','9999-01-01'),
(494294,60822,'1990-04-08','1991-04-08'),
(494294,60913,'1991-04-08','1992-04-07');


INSERT INTO `salaries` VALUES (494294,64667,'1992-04-07','1992-04-09'),
(495066,40000,'1998-01-12','1999-01-12'),
(495066,40641,'1999-01-12','2000-01-12'),
(495066,43519,'2000-01-12','2001-01-11'),
(495066,46523,'2001-01-11','2002-01-11'),
(495066,47789,'2002-01-11','9999-01-01'),
(495146,53228,'1988-11-05','1989-11-05'),
(495146,54009,'1989-11-05','1990-11-05'),
(495146,57658,'1990-11-05','1991-11-05'),
(495146,58967,'1991-11-05','1992-11-04');


INSERT INTO `salaries` VALUES (495146,58629,'1992-11-04','1993-11-04'),
(495146,60890,'1993-11-04','1994-11-04'),
(495146,61628,'1994-11-04','1995-11-04'),
(495146,61423,'1995-11-04','1996-11-03'),
(495146,65275,'1996-11-03','1997-11-03'),
(495146,69334,'1997-11-03','1998-11-03'),
(495146,70650,'1998-11-03','1999-11-03'),
(495146,73592,'1999-11-03','2000-11-02'),
(495146,75910,'2000-11-02','2001-11-02'),
(495146,79146,'2001-11-02','9999-01-01');


INSERT INTO `salaries` VALUES (495658,40000,'1998-09-28','1999-09-28'),
(495658,42108,'1999-09-28','2000-03-04'),
(495879,40000,'1989-12-30','1990-12-30'),
(495879,41055,'1990-12-30','1991-12-30'),
(495879,41691,'1991-12-30','1992-12-29'),
(495879,42044,'1992-12-29','1993-12-29'),
(495879,42598,'1993-12-29','1994-12-29'),
(495879,45691,'1994-12-29','1995-12-29'),
(495879,47457,'1995-12-29','1996-12-28'),
(495879,48863,'1996-12-28','1997-12-28');


INSERT INTO `salaries` VALUES (495879,48853,'1997-12-28','1998-12-28'),
(495879,51915,'1998-12-28','1999-12-28'),
(495879,51849,'1999-12-28','2000-12-27'),
(495879,54102,'2000-12-27','2001-12-27'),
(495879,54384,'2001-12-27','9999-01-01'),
(496317,40000,'1997-11-28','1998-11-28'),
(496317,40305,'1998-11-28','1999-11-28'),
(496317,42909,'1999-11-28','2000-11-27'),
(496317,44797,'2000-11-27','2001-11-27'),
(496317,48188,'2001-11-27','9999-01-01');


INSERT INTO `salaries` VALUES (496685,53409,'1991-04-11','1992-04-10'),
(496685,54609,'1992-04-10','1993-04-10'),
(496685,57810,'1993-04-10','1994-04-10'),
(496685,61377,'1994-04-10','1995-04-10'),
(496685,65573,'1995-04-10','1996-04-09'),
(496685,65371,'1996-04-09','1997-04-09'),
(496685,69065,'1997-04-09','1998-04-09'),
(496685,68925,'1998-04-09','1999-04-09'),
(496685,71572,'1999-04-09','2000-04-08'),
(496685,72158,'2000-04-08','2001-04-08');


INSERT INTO `salaries` VALUES (496685,72902,'2001-04-08','2002-04-08'),
(496685,76946,'2002-04-08','9999-01-01'),
(496687,40000,'1999-02-13','2000-02-13'),
(496687,41793,'2000-02-13','2001-02-12'),
(496687,41895,'2001-02-12','2002-02-12'),
(496687,44328,'2002-02-12','9999-01-01'),
(497341,65680,'1989-03-03','1990-03-03'),
(497341,68587,'1990-03-03','1991-03-03'),
(497341,71768,'1991-03-03','1992-03-02'),
(497341,72687,'1992-03-02','1993-03-02');


INSERT INTO `salaries` VALUES (497341,72804,'1993-03-02','1994-03-02'),
(497341,76102,'1994-03-02','1995-03-02'),
(497341,77284,'1995-03-02','1996-03-01'),
(497341,80838,'1996-03-01','1997-03-01'),
(497341,81916,'1997-03-01','1998-03-01'),
(497341,83486,'1998-03-01','1999-03-01'),
(497341,83179,'1999-03-01','2000-02-29'),
(497341,86937,'2000-02-29','2001-02-28'),
(497341,91286,'2001-02-28','2002-02-28'),
(497341,94330,'2002-02-28','9999-01-01');


INSERT INTO `salaries` VALUES (497434,42366,'1986-07-16','1987-07-16'),
(497434,43213,'1987-07-16','1988-07-15'),
(497434,45415,'1988-07-15','1989-07-15'),
(497434,48585,'1989-07-15','1990-07-15'),
(497434,52302,'1990-07-15','1991-07-15'),
(497434,55851,'1991-07-15','1992-07-14'),
(497434,59723,'1992-07-14','1993-07-14'),
(497434,59850,'1993-07-14','1994-07-14'),
(497434,63189,'1994-07-14','1995-07-14'),
(497434,63071,'1995-07-14','1996-07-13');


INSERT INTO `salaries` VALUES (497434,64928,'1996-07-13','1997-07-13'),
(497434,69249,'1997-07-13','1998-07-13'),
(497434,73482,'1998-07-13','1999-07-13'),
(497434,74607,'1999-07-13','2000-07-12'),
(497434,76873,'2000-07-12','2001-07-12'),
(497434,79098,'2001-07-12','2002-07-12'),
(497434,83246,'2002-07-12','9999-01-01'),
(498101,73795,'1998-12-16','1999-12-16'),
(498101,76013,'1999-12-16','2000-12-15'),
(498101,77064,'2000-12-15','2001-12-15');


INSERT INTO `salaries` VALUES (498101,77536,'2001-12-15','9999-01-01'),
(498351,45297,'1997-12-04','1998-12-04'),
(498351,46490,'1998-12-04','1999-12-04'),
(498351,50786,'1999-12-04','2000-12-03'),
(498351,50485,'2000-12-03','2001-12-03'),
(498351,51966,'2001-12-03','9999-01-01'),
(498404,40000,'1998-04-28','1999-04-28'),
(498404,40308,'1999-04-28','2000-04-27'),
(498404,41332,'2000-04-27','2001-04-27'),
(498404,42391,'2001-04-27','2002-04-27');


INSERT INTO `salaries` VALUES (498404,42877,'2002-04-27','9999-01-01'),
(498649,50180,'1998-05-23','1999-05-23'),
(498649,53633,'1999-05-23','2000-01-13'),
(498741,40000,'1985-12-21','1986-12-21'),
(498741,41067,'1986-12-21','1987-12-21'),
(498741,44918,'1987-12-21','1988-12-20'),
(498741,46491,'1988-12-20','1989-12-20'),
(498741,49352,'1989-12-20','1990-12-20'),
(498741,53562,'1990-12-20','1991-12-20'),
(498741,53820,'1991-12-20','1992-12-19');


INSERT INTO `salaries` VALUES (498741,55101,'1992-12-19','1993-12-19'),
(498741,59253,'1993-12-19','1994-12-19'),
(498741,63536,'1994-12-19','1995-12-19'),
(498741,63248,'1995-12-19','1996-12-18'),
(498741,64162,'1996-12-18','1997-12-18'),
(498741,67737,'1997-12-18','1998-12-18'),
(498741,70355,'1998-12-18','1999-12-18'),
(498741,73235,'1999-12-18','2000-12-17'),
(498741,75624,'2000-12-17','2001-12-17'),
(498741,79391,'2001-12-17','9999-01-01');


INSERT INTO `salaries` VALUES (499367,49581,'1993-02-17','1994-02-16'),
(499367,52253,'1994-02-16','1995-02-16'),
(499367,55207,'1995-02-16','1996-02-16'),
(499367,56797,'1996-02-16','1997-02-15'),
(499367,59809,'1997-02-15','1998-02-15'),
(499367,62070,'1998-02-15','1999-02-15'),
(499367,66568,'1999-02-15','2000-02-15'),
(499367,70699,'2000-02-15','2001-02-14'),
(499367,74133,'2001-02-14','2002-02-14'),
(499367,75263,'2002-02-14','9999-01-01');


INSERT INTO `salaries` VALUES (499762,48458,'1985-07-06','1986-07-06'),
(499762,52929,'1986-07-06','1987-07-06'),
(499762,55175,'1987-07-06','1988-07-05'),
(499762,55913,'1988-07-05','1989-07-05'),
(499762,56999,'1989-07-05','1990-07-05'),
(499762,56878,'1990-07-05','1991-07-05'),
(499762,58034,'1991-07-05','1992-07-04'),
(499762,60491,'1992-07-04','1993-07-04'),
(499762,60713,'1993-07-04','1994-07-04'),
(499762,63259,'1994-07-04','1995-07-04');


INSERT INTO `salaries` VALUES (499762,67588,'1995-07-04','1996-07-03'),
(499762,71419,'1996-07-03','1997-07-03'),
(499762,72671,'1997-07-03','1998-07-03'),
(499762,77130,'1998-07-03','1999-07-03'),
(499762,78853,'1999-07-03','2000-07-02'),
(499762,82042,'2000-07-02','2001-07-02'),
(499762,84377,'2001-07-02','2002-07-02'),
(499762,85497,'2002-07-02','9999-01-01');



-- Re-enable foreign key checks
PRAGMA foreign_keys = ON;