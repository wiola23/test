create database edu_courses;

use edu_courses;

create table course (
course_id int NOT NULL IDENTITY(1,1), 
course_name nvarchar(100), 
base_price money,
planned_groups_amount int default 1,
date_start date,
date_end  date,
is_active bit default 1,
CONSTRAINT course_PK PRIMARY KEY (course_id)
)

create table [group](
group_id int IDENTITY(1,1),
group_type nvarchar(25) default 'zajęciowa',
course_id int,
max_group_capacity int,
CONSTRAINT FK_course FOREIGN KEY (course_id) references course(course_id),
CONSTRAINT PK_group PRIMARY KEY (group_id)
)

create table group_timetables(
group_id int,
room nvarchar(100),
datetime_start datetime,
datetime_end datetime,
CONSTRAINT FK_group FOREIGN KEY (group_id) references [group](group_id)
)


create table users_user (
[user_id] int IDENTITY(1,1),
email nvarchar(255),
first_name nvarchar(200),
last_name nvarchar(200),
is_active bit,
age int,
CONSTRAINT PK_USERS_USER PRIMARY KEY ([user_id])
)

create table course_enrollment (
[user_id] int,
group_id int,
enrollment_date datetime,
total_cost money,
discount_type varchar(100) default 'bezwarunkowy',
discount_value money,
is_completed bit default 0,
is_dropped bit default 0,
CONSTRAINT FK_user FOREIGN KEY ([user_id]) references users_user([user_id]),
CONSTRAINT FK_group2 FOREIGN KEY (group_id) references [group](group_id)
)


