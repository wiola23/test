CREATE UNIQUE INDEX usersid ON users_user([user_id]); --tego nie trzeba, bo się automatycznie tworzy
CREATE INDEX usercourse on course_enrollment([user_id]);
CREATE UNIQUE INDEX uniquemail on users_user(email);
CREATE INDEX daty on course(date_start, date_end);
CREATE CLUSTERED INDEX zgrupowanyce on course_enrollment([user_id], group_id);
CREATE INDEX imnaz on users_user(first_name, last_name);