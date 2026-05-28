alter table users_user add phone_number varchar(25);
alter table users_user drop column age;
alter table course add constraint czek check (date_start<date_end);
