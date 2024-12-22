--大型数据库复习代码



-- declare
--  type cursor_test is ref cursor
--  return emp%rowtype;
--  c1 cursor_test;
--  emp_row emp%rowtype;
-- begin
--  open c1 for select * from emp;
--  loop
--   fetch c1 into emp_row;
--   exit when c1%notfound;
--   dbms_output.put_line('sal:'||emp_row.sal);
--   end loop;
-- end;

-- begin
--   for emp_row in (select * from emp)
--   loop
--     dbms_output.put_line('sal:'||emp_row(1));--不可以这样
--   end loop;
-- end; 

-- declare
--  sql_stmt varchar2(200):='create table test1 as select * from emp';
-- begin
--     execute immediate sql_stmt;
-- if sql%found then
--   dbms_output.put_line(sql%rowcount);
-- end if;
-- end;

--@E:/桌面/test.sql;

--写个动态sql授权
-- declare
-- sql_stmt varchar2(200);
-- sql_drop varchar2(200);
-- sql_grant varchar2(200);
-- begin
--   for row_n in (select * from stud)
--   loop
--     sql_drop:='drop user b'||row_n.sno;
--     execute immediate sql_drop;
--     sql_stmt:='create user b'||row_n.sno||' identified by '||row_n.sno;
--     execute immediate sql_stmt;
--     sql_grant:='grant connect,resource to b'||row_n.sno;
--     execute immediate sql_grant;
--   end loop;
-- end;


--select * from stud where sno='8210222517';

--过程
create or replace procedure test_proc(v_sno in varchar2,v_find out boolean)
is
num number;
begin
  select count(*) into num from stud where sno=v_sno;
  if num>0 then
  v_find:=true;
  else
  v_find:=false;
  end if;
end test_proc;

declare
v_find boolean;
begin
  test_proc('8210222517',v_find);
  if v_find then
  dbms_output.put_line('yes');
  else
  dbms_output.put_line('no');
  end if;
  end;


--函数
create or replace function test_func(v_sno in varchar2)
return number
is
num number;
begin
  select count(*) into num from stud where sno=v_sno;
  return num;
  end;

declare
num number;
begin
  num:=test_func('8210222517');
  if num>0 then
  dbms_output.put_line('yes');
  else
  dbms_output.put_line('no');
  end if;
  end;


--触发器
drop table v_stud;
create table v_stud(
    id number,
    c_time date,
    opration varchar2(20)
);

create or replace trigger test_trig 
after insert or delete or update on stud
for each row
begin
  if inserting then
  insert into v_stud values(seq_test.nextval,sysdate,'insert');
  end if;
  if deleting then
  insert into v_stud values(seq_test.nextval,sysdate,'delete');
  end if;
  if updating then
  insert into v_stud values(seq_test.nextval,sysdate,'update');
  end if;
  end test_trig;

--序列
create sequence seq_test
start with 1
increment by 1;


--同义词
create public synonym a for stud;


--delete会被rollback


--表空间
create tablespace test_tablespace
datafile 'E:/test.dbf'
size 10m
extent management local uniform size 256k;

alter tablespace test_tablespace add datafile 'E:/test1.dbf' size 10m;

alter tablespace test_tablespace drop datafile 'E:/test1.dbf';

--在表空间创建表
create table test_tablespace_test(
    id number,
    name varchar2(20)
) tablespace test_tablespace;

--写入一些数据

begin
  for i in 1..10000
  loop
    insert into test_tablespace_test values(i,'test');
  end loop;
  end;

--修改表名称
alter table sapce_table rename to space_table;





--配置文件
create user hhy identified by hhy;

create profile test_profile limit
failed_login_attempts 3
password_lock_time 1/24/60;

alter user hhy profile test_profile;


-- --数据库导出
-- create directory test_dir as 'E:/桌面';

-- grant read,write on directory test_dir to scott;


--在命令行执行
--不能有分号windows系统
exp scott/tiger file=E:/桌面/test.dmp tables=emp,dept

--把scott的表删除了再导入
imp scott/tiger file=E:/桌面/test.dmp tables=emp,dept

--手工介质恢复的方法
--之前建立了一个表空间和数据文件
--是先在另一个目录下保存然后再手动拷贝到当前目录

--查询最高工资的员工
select * from emp where sal=(select max(sal) from emp);