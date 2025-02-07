CREATE TABLE CONSUMER
(
	Consumer_id INT NOT NULL IDENTITY,
	Email VARCHAR(150) NOT NULL,
	Login_password VARCHAR(30) NOT NULL,
	Fname VARCHAR(50) NOT NULL,
	Lname VARCHAR(50) NOT NULL,
	Country VARCHAR(50) NOT NULL,
	City VARCHAR(50) NOT NULL,
	Birth_date DATE,
	Gender CHAR(1) NOT NULL,
	PRIMARY KEY (Consumer_id),
	UNIQUE (Email)
	
);

CREATE TABLE COMMUNITY 
(
	Community_id INT NOT NULL IDENTITY,
	Community_name VARCHAR(50) NOT NULL,
	Community_subject VARCHAR(50) NOT NULL,
	Creater_id INT NOT NULL,
	PRIMARY KEY (Community_id),
	FOREIGN KEY (Creater_id) REFERENCES CONSUMER (Consumer_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE POST 
(
	Post_id INT NOT NULL IDENTITY,
	Post_time DATE NOT NULL,
	Content VARCHAR(450) NOT NULL, 
	Shared_comm_id INT,
	Sender_cons_id INT NOT NULL,
	PRIMARY KEY (Post_id),
	FOREIGN KEY (Shared_comm_id) REFERENCES COMMUNITY (Community_id), 
	FOREIGN KEY (Sender_cons_id) REFERENCES CONSUMER (Consumer_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE COMMENT 
(
	Comment_id INT NOT NULL IDENTITY,
	Content VARCHAR(250) NOT NULL,
	Comment_time DATE NOT NULL,
	Post_id INT NOT NULL, 
	Sender_cons_id INT NOT NULL,
	PRIMARY KEY (Comment_id),
	FOREIGN KEY (Post_id) REFERENCES POST (Post_id) ON DELETE CASCADE,
	FOREIGN KEY (Sender_cons_id) REFERENCES CONSUMER (Consumer_id)  ON UPDATE CASCADE
);

CREATE TABLE SKILL
(
	Skill_name VARCHAR(75) NOT NULL,
	PRIMARY KEY (Skill_name),
);

CREATE TABLE COMPANY
(
	Company_id INT NOT NULL IDENTITY,
	Company_name VARCHAR(100) NOT NULL, 
	Country VARCHAR(50) NOT NULL,
	City VARCHAR(50) NOT NULL,
	Company_industry VARCHAR(50) NOT NULL, 
	Creater_id INT NOT NULL,
	PRIMARY KEY (Company_id),
	UNIQUE (Company_name),
	FOREIGN KEY (Creater_id) REFERENCES CONSUMER (Consumer_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE UNIVERSITY
(
	Uni_id INT NOT NULL IDENTITY,
	Uni_name VARCHAR(100) NOT NULL,
	Country VARCHAR(50) NOT NULL,
	City VARCHAR(50) NOT NULL, 
	Company_id INT,
	PRIMARY KEY (Uni_id),
	UNIQUE (Uni_name),
	FOREIGN KEY (Company_id) REFERENCES COMPANY (Company_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DEPT_PASSWORD
(
	Password_id INT NOT NULL IDENTITY,
	Dept_ins_pwd VARCHAR(30) NOT NULL,
	Dept_stu_pwd VARCHAR(30) NOT NULL,
	PRIMARY KEY (Password_id),
	UNIQUE (Dept_ins_pwd), 
	UNIQUE (Dept_stu_pwd) 
);

CREATE TABLE COURSE_PASSWORD
(
	Password_id INT NOT NULL IDENTITY,
	Course_ins_pwd VARCHAR(30) NOT NULL, 
	Course_stu_pwd VARCHAR(30) NOT NULL,
	PRIMARY KEY (Password_id),
	UNIQUE (Course_ins_pwd),
	UNIQUE (Course_stu_pwd) 
);

CREATE TABLE DEPARTMENT 
(
	Dept_id INT NOT NULL IDENTITY,
	Dept_name VARCHAR(100) NOT NULL,
	Uni_id INT NOT NULL,
	Dept_pwd_id INT,
	PRIMARY KEY (Dept_id),
	UNIQUE (Dept_name, Uni_id),
	UNIQUE (Dept_pwd_id),
	FOREIGN KEY (Uni_id) REFERENCES UNIVERSITY (Uni_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Dept_pwd_id) REFERENCES DEPT_PASSWORD (Password_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE STUDENT
(
	Consumer_id INT NOT NULL, 
	Dept_id INT NOT NULL,
    PRIMARY KEY (Consumer_id),
	FOREIGN KEY (Consumer_id) REFERENCES CONSUMER (Consumer_id)  ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Dept_id) REFERENCES DEPARTMENT (Dept_id) 

);

CREATE TABLE INSTRUCTOR
(
	Consumer_id INT NOT NULL,
	Ins_rank VARCHAR(50) NOT NULL, 
	Dept_�d INT NOT NULL,
	PRIMARY KEY (Consumer_id),
	FOREIGN KEY (Consumer_id) REFERENCES CONSUMER (Consumer_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Dept_id) REFERENCES DEPARTMENT (Dept_id) 

);

CREATE TABLE COURSE
(
	Course_id INT NOT NULL IDENTITY,
	Course_name VARCHAR(50) NOT NULL,
	Course_year INT NOT NULL,
	Course_sem CHAR NOT NULL, 
	Skill_acquisition VARCHAR(75) NOT NULL,
	Dept_id INT NOT NULL, 
	Course_pwd_id INT, 
	Given_by INT,
	PRIMARY KEY (Course_id),
	UNIQUE (Course_name, Course_year, Course_sem, Dept_id),
	UNIQUE (Course_pwd_id),
	FOREIGN KEY (Dept_id) REFERENCES DEPARTMENT (Dept_id) ,
	FOREIGN KEY (Course_pwd_id) REFERENCES COURSE_PASSWORD (Password_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Given_by) REFERENCES INSTRUCTOR (Consumer_id) ON DELETE SET NULL ON UPDATE CASCADE

);

CREATE TABLE ASSIGNMENT
(
	Course_id INT NOT NULL,
	Assignment_name VARCHAR(75) NOT NULL,
	Assn_start_date DATE NOT NULL,
	Assn_end_date DATE NOT NULL, 
	Content VARCHAR(8000) NOT NULL, 
	Shared_by INT NOT NULL,
	PRIMARY KEY (Course_id, Assignment_name),
	FOREIGN KEY (Course_id) REFERENCES COURSE (Course_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Shared_by) REFERENCES INSTRUCTOR (Consumer_id) 

);

CREATE TABLE SUBMISSION
(
	Submission_id INT NOT NULL IDENTITY, 
	Submission_name VARCHAR(75) NOT NULL, 
	Sub_date DATE NOT NULL,
	Content VARCHAR(8000) NOT NULL, 
	Grade INT NOT NULL, 
	Course_id INT NOT NULL,
	Assignment_name VARCHAR(75) NOT NULL, 
	Added_by INT NOT NULL, 
	PRIMARY KEY (Submission_id),
	UNIQUE  (Course_id, Assignment_name, Added_by),
	FOREIGN KEY (Course_id, Assignment_name) REFERENCES ASSIGNMENT (Course_id, Assignment_name),
	FOREIGN KEY (Added_by) REFERENCES STUDENT (Consumer_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE SUBMISSION_POST
(
	Post_id INT NOT NULL,
	Submission_id INT NOT NULL,
	PRIMARY KEY (Post_id),
	FOREIGN KEY (Post_id) REFERENCES POST (Post_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Submission_id) REFERENCES SUBMISSION (Submission_id) 

);

CREATE TABLE GETS_EDUCATION
(
	Consumer_id INT NOT NULL,
	Company_id INT NOT NULL, 
	Edu_start_date DATE NOT NULL,
	Edu_end_date DATE, 
	Dept_name VARCHAR(100) NOT NULL,
	PRIMARY KEY (Consumer_id, Company_id),
	FOREIGN KEY (Consumer_id) REFERENCES CONSUMER (Consumer_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Company_id) REFERENCES COMPANY (Company_id) 

);

CREATE TABLE WORKS_FOR
(
	Consumer_id INT NOT NULL, 
	Company_id INT NOT NULL,
	Work_start_date DATE NOT NULL,
	Work_end_date DATE, 
	Position VARCHAR(50) NOT NULL,
	PRIMARY KEY (Consumer_id, Company_id),
	FOREIGN KEY (Consumer_id) REFERENCES CONSUMER (Consumer_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Company_id) REFERENCES COMPANY (Company_id)

);

CREATE TABLE CONSUMER_SKILL
(
	Consumer_id INT NOT NULL,
	Skill_name VARCHAR(75) NOT NULL,
	PRIMARY KEY (Consumer_id, Skill_name),
	FOREIGN KEY (Consumer_id) REFERENCES CONSUMER (Consumer_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Skill_name) REFERENCES SKILL (Skill_name) ON DELETE CASCADE ON UPDATE CASCADE

);

CREATE TABLE CONSUMER_SKILL_ENDORSE
(
	Endorsed_consumer INT NOT NULL, 
	Endorsed_by INT NOT NULL, 
	Skill_name VARCHAR(75) NOT NULL,
	PRIMARY KEY (Endorsed_consumer, Endorsed_by, Skill_name),
	FOREIGN KEY (Endorsed_consumer,Skill_name) REFERENCES CONSUMER_SKILL (Consumer_id,Skill_name) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Endorsed_by) REFERENCES CONSUMER (Consumer_id) 

);

CREATE TABLE CONSUMER_MESSAGE
(
	Message_id INT NOT NULL IDENTITY, 
	Sender_consumer INT NOT NULL,
	Receiver_consumer INT NOT NULL,
	Send_date DATE NOT NULL, 
	Content VARCHAR(250) NOT NULL,
	PRIMARY KEY (Message_id),
	FOREIGN KEY (Sender_consumer) REFERENCES CONSUMER (Consumer_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Receiver_consumer) REFERENCES CONSUMER (Consumer_id) 

);

CREATE TABLE COMMUNITY_MEMBER
(
	Community_id INT NOT NULL,
	Member_id INT NOT NULL,
	PRIMARY KEY (Community_id, Member_id),
	FOREIGN KEY (Community_id) REFERENCES COMMUNITY (Community_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Member_id) REFERENCES CONSUMER (Consumer_id) 

);

CREATE TABLE CONSUMER_COMMENT_LIKE
(
	Consumer_id INT NOT NULL,
	Comment_id INT NOT NULL,
	PRIMARY KEY (Consumer_id, Comment_id),
	FOREIGN KEY (Consumer_id) REFERENCES CONSUMER (Consumer_id),
	FOREIGN KEY (Comment_id) REFERENCES COMMENT (Comment_id) ON DELETE CASCADE ON UPDATE CASCADE

);

CREATE TABLE CONSUMER_POST_LIKE
(
	Consumer_id INT NOT NULL, 
	Post_id INT NOT NULL,
	PRIMARY KEY (Consumer_id, Post_id),
	FOREIGN KEY (Consumer_id) REFERENCES CONSUMER (Consumer_id),
	FOREIGN KEY (Post_id) REFERENCES POST (Post_id) ON DELETE CASCADE ON UPDATE CASCADE

);

CREATE TABLE STUDENT_COURSE
(
	Student_id INT NOT NULL,
	Course_id INT NOT NULL,
	Grade INT DEFAULT 0,
	PRIMARY KEY (Student_id, Course_id),
	FOREIGN KEY (Student_id) REFERENCES STUDENT (Consumer_id),
	FOREIGN KEY (Course_id) REFERENCES COURSE (Course_id) ON DELETE CASCADE ON UPDATE CASCADE

);

CREATE TABLE CONSUMER_COURSE
(
	Consumer_id INT NOT NULL,
	Course_name VARCHAR(50),
	PRIMARY KEY (Consumer_id, Course_name),
	FOREIGN KEY (Consumer_id) REFERENCES CONSUMER (Consumer_id) ON DELETE CASCADE ON UPDATE CASCADE

);

CREATE TABLE CONSUMER_LANGUAGE
(
	Consumer_id INT NOT NULL, 
	Language_name VARCHAR(50) NOT NULL,
	PRIMARY KEY (Consumer_id, Language_name),
	FOREIGN KEY (Consumer_id) REFERENCES CONSUMER (Consumer_id) ON DELETE CASCADE ON UPDATE CASCADE

);