Hospital management:

Create table patients(
pid int not null,
name varchar(20),
insurance varchar(20),
date_admitted date,
date_checkedout date,
primary key(pid,date_admitted)
);
Create table tests(
testid int not null,
testname varchar(20),
primary key(testid)
);


Create table testlogs(
testid int not null,
pid int,
date_admitted date,
drid int,
tdate date,
ttime varchar(40),
result varchar(20),
primary key(testid,pid,date_admitted,drid),
foreign key(testid) references test(testid) on delete set null,
foreign key(pid,date_admitted) references patient(pid,date_admitted) on delete set null
);

Create table doctors(
drid int not null,
name varchar(20),
specialization varchar(30),
primary key(drid)
);

Create table drpatients(
pid int,
drid int,
primary key(pid,drid),
foreign key(pid) references patient(pid) on delete set null,
foreign key(drid)references doctor(drid) on delete set null
);

INSERT INTO patients values (1001, 'John Doe', 'HealthCare Inc.', '01-feb-23', '09-feb-23');
INSERT INTO patients values (1001, 'John Doe', 'HealthCare Inc.', '08-feb-23', '09-feb-23');
INSERT INTO patients values(1002, 'Jane Smith', 'MediCare Corp.', '02-feb-23', '09-feb-23');
INSERT INTO patients values(1003, 'Bob Johnson', 'Well Insurance', '04-feb-23','07-feb-23');
INSERT INTO patients values(1004, 'Alice Brown', 'HealthGLtd.', '01-feb-23', '09-feb-23');
INSERT INTO patients values(1005, 'Charlie Wilson', 'Med Insurance', '01-feb-23','04-feb-23');
INSERT INTO patients values(1002, 'Jane Smith', 'MediCare Corp.', '05-feb-23', '09-feb-23');
INSERT INTO patients values(1005, 'Charlie Wilson', 'Med Insurance', '09-feb-23','14-feb-23');


INSERT INTO doctors VALUES(101, 'Dr. Smith', 'Cardiologist');
INSERT INTO doctors VALUES(102, 'Dr. Johnson', 'Orthopedic Surgeon');
INSERT INTO doctors VALUES(103, 'Dr. Davis', 'Neurologist');
INSERT INTO doctors VALUES(104, 'Dr. White', 'Pediatrician');
INSERT INTO doctors VALUES(105, 'Dr. Miller', 'Dermatologist');
INSERT INTO doctors VALUES(106,'Dr. Joshi','Gynacologist');


INSERT INTO drpatients VALUES (1001, 101);
INSERT INTO drpatients VALUES (1002, 103);
INSERT INTO drpatients VALUES (1003, 102);
INSERT INTO drpatients VALUES (1005, 104);
INSERT INTO drpatients VALUES (1003, 105);
INSERT INTO drpatients VALUES (1002, 102);
INSERT INTO drpatients VALUES (1003, 101);
INSERT INTO drpatients VALUES (1002, 101);



INSERT INTO tests VALUES(test_id, test_name); 
INSERT INTO tests VALUES(501, 'Blood Test');
INSERT INTO tests VALUES(502, 'MRI Scan');
INSERT INTO tests VALUES(503, 'X-Ray');
INSERT INTO tests VALUES(504, 'ECG');
INSERT INTO tests VALUES(505, 'Urinalysis');

INSERT INTO testlogs VALUES(501, 1001, 101, '01-feb-23', 'Normal', '10:30 AM');
INSERT INTO testlogs VALUES(502, 1002, 103, '01-feb-23', 'Abnormal', '02:45 PM');
INSERT INTO testlogs VALUES(503, 1003, 102, '01-feb-23', 'Normal', '09:00 AM');
INSERT INTO testlogs VALUES(504, 1004, 105, '01-feb-23', 'Abnormal', '11:15 AM');
INSERT INTO testlogs VALUES(505, 1005, 104, '01-feb-23', 'Normal', '03:20 PM');
INSERT INTO testlogs VALUES(504, 1004, 101, '01-feb-23', 'Abnormal', '11:19 AM');

INSERT INTO testlogs VALUES(503, 1001, 106, '01-feb-23', 'Normal', '09:00 AM');
INSERT INTO testlogs VALUES(503, 1004, 106, '01-feb-23', 'Normal', '09:00 AM');



a)List the patientid,name who were admitted more than twice in the year 2012.
  select distinct(pid),name
  from patients 
  where pid in(select p.pid
                from patients p where extract(year    		from date_admitted)='2023'
		group by p.pid
		having count(p.pid)>=2);

b)List the patientid,name who were admitted and also undergone test on same dat of admission.
  select distinct(p.pid),p.name
  from patients p,testlogs t
  where p.date_admitted=t.tdate;

c)List testid that has been performed highest number of times.
   select testid
   from testlogs
   group by testid
   having count(testid)>=ALL( select        						count(t.testid) 
                                           from testlogs t
                                           grou by(t.testid)
                                         );

d)List the names of doctors who treat all patients that Dr.Joshi treats.

SELECT DISTINCT d.name,d.drid
FROM doctors d
JOIN drpatients dr ON d.drid = dr.drid
WHERE NOT EXISTS (
    SELECT dp2.pid
    FROM drpatients dp2
    WHERE dp2.drid = (SELECT drid FROM doctors WHERE name = 'Dr. Johnson')
    AND pid NOT IN (SELECT pid FROM drpatients WHERE drid = d.drid)
) AND d.name != 'Dr. Johnson';
