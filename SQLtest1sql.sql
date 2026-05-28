CREATE PROCEDURE procedura2 @mail nvarchar(255), @course_id int AS
BEGIN
IF (select * from users_user where email=@mail) is NULL
	INSERT INTO users_user (email) values (@mail)
declare @userid int;
set @userid = (select [user_id] from users_user where email=@mail);

IF (select is_active from course where @course_id=course_id)=1 and
(SELECT max_group_capacity,g.group_id,count(distinct [user_id]) as l_ucz from [group] g join course_enrollment ce on ce.group_id=g.group_id 
where course_id=@course_id group by g.group_id, max_group_capacity having count(distinct [user_id])<max_group_capacity) is not null
BEGIN
INSERT INTO course_enrollment ([user_id], discount_type, discount_value) values (@userid, @typ,@znizka)
declare @typ varchar(100);
declare @znizka money;
declare @liczba int;
set @liczba = (select count([user_id]) as liczba from course_enrollment group by [user_id])

INSERT INTO course_enrollment ([user_id], discount_type, discount_value) values (@userid, case when @liczba=0 then 'bezwarunkowy'
when @liczba =1 then 'stały'
when @liczba>1 then 'lojalnościowy'
else NULL
end,
case 
when @liczba=0 then 100
when @liczba =1 then 0.05
when @liczba>1 then 0.01*@liczba+0.05
else 0
end);
end
	
END