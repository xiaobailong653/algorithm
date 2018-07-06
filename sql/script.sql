/*
查找最晚入职员工的所有信息
CREATE TABLE `employees` (
`emp_no` int(11) NOT NULL,
`birth_date` date NOT NULL,
`first_name` varchar(14) NOT NULL,
`last_name` varchar(16) NOT NULL,
`gender` char(1) NOT NULL,
`hire_date` date NOT NULL,
PRIMARY KEY (`emp_no`));
*/
select * from employees order by hire_date desc limit 1;
# 运行时间：17ms
# 占用内存：3320k

select * from employees where hire_date = (select max(hire_date) from employees);
# 运行时间：25ms
# 占用内存：3300k

/*
查找入职员工时间排名倒数第三的员工所有信息
CREATE TABLE `employees` (
`emp_no` int(11) NOT NULL,
`birth_date` date NOT NULL,
`first_name` varchar(14) NOT NULL,
`last_name` varchar(16) NOT NULL,
`gender` char(1) NOT NULL,
`hire_date` date NOT NULL,
PRIMARY KEY (`emp_no`));
*/
select * from employees order by hire_date desc limit 2,1;

# 运行时间：31ms
# 占用内存：4332k

select * from employees where hire_date = (select hire_date from employees order by hire_date desc limit 2,1);
# 运行时间：18ms
# 占用内存：3284k


/*
查找各个部门当前(to_date='9999-01-01')领导当前薪水详情以及其对应部门编号dept_no
CREATE TABLE `dept_manager` (
`dept_no` char(4) NOT NULL,
`emp_no` int(11) NOT NULL,
`from_date` date NOT NULL,
`to_date` date NOT NULL,
PRIMARY KEY (`emp_no`,`dept_no`));
CREATE TABLE `salaries` (
`emp_no` int(11) NOT NULL,
`salary` int(11) NOT NULL,
`from_date` date NOT NULL,
`to_date` date NOT NULL,
PRIMARY KEY (`emp_no`,`from_date`));
*/

select s.*,d.dept_no from salaries s, dept_manager d where s.to_date='9999-01-01' and d.to_date='9999-01-01' and s.emp_no = d.emp_no;

/*
运行时间：24ms

占用内存：3304k
*/


/*
查找所有已经分配部门的员工的last_name和first_name
CREATE TABLE `dept_emp` (
`emp_no` int(11) NOT NULL,
`dept_no` char(4) NOT NULL,
`from_date` date NOT NULL,
`to_date` date NOT NULL,
PRIMARY KEY (`emp_no`,`dept_no`));
CREATE TABLE `employees` (
`emp_no` int(11) NOT NULL,
`birth_date` date NOT NULL,
`first_name` varchar(14) NOT NULL,
`last_name` varchar(16) NOT NULL,
`gender` char(1) NOT NULL,
`hire_date` date NOT NULL,
PRIMARY KEY (`emp_no`));
*/

select e.last_name, e.first_name, d.dept_no from dept_emp d inner join employees e on e.emp_no=d.emp_no;

/*
运行时间：19ms

占用内存：3284k
*/


/*
查找所有员工的last_name和first_name以及对应部门编号dept_no，也包括展示没有分配具体部门的员工
CREATE TABLE `dept_emp` (
`emp_no` int(11) NOT NULL,
`dept_no` char(4) NOT NULL,
`from_date` date NOT NULL,
`to_date` date NOT NULL,
PRIMARY KEY (`emp_no`,`dept_no`));
CREATE TABLE `employees` (
`emp_no` int(11) NOT NULL,
`birth_date` date NOT NULL,
`first_name` varchar(14) NOT NULL,
`last_name` varchar(16) NOT NULL,
`gender` char(1) NOT NULL,
`hire_date` date NOT NULL,
PRIMARY KEY (`emp_no`));
*/

select e.last_name, e.first_name, d.dept_no from employees e left join dept_emp d on e.emp_no=d.emp_no;

/*
运行时间：19ms

占用内存：3284k
*/


/*
查找所有员工入职时候的薪水情况，给出emp_no以及salary， 并按照emp_no进行逆序
CREATE TABLE `employees` (
`emp_no` int(11) NOT NULL,
`birth_date` date NOT NULL,
`first_name` varchar(14) NOT NULL,
`last_name` varchar(16) NOT NULL,
`gender` char(1) NOT NULL,
`hire_date` date NOT NULL,
PRIMARY KEY (`emp_no`));
CREATE TABLE `salaries` (
`emp_no` int(11) NOT NULL,
`salary` int(11) NOT NULL,
`from_date` date NOT NULL,
`to_date` date NOT NULL,
PRIMARY KEY (`emp_no`,`from_date`));
*/
select s.emp_no, s.salary from salaries s, employees e where s.emp_no=e.emp_no and s.from_date = e.hire_date order by s.emp_no desc;
/*
运行时间：29ms

占用内存：3428k
*/

select s.emp_no, s.salary from salaries s inner join employees e on s.emp_no=e.emp_no and s.from_date = e.hire_date order by s.emp_no desc;

/*
运行时间：29ms

占用内存：3304k
*/
select emp_no, salary from salaries group by emp_no having min(from_date) order by emp_no desc;

/*
运行时间：22ms

占用内存：3436k
*/

/*
查找薪水涨幅超过15次的员工号emp_no以及其对应的涨幅次数t
CREATE TABLE `salaries` (
`emp_no` int(11) NOT NULL,
`salary` int(11) NOT NULL,
`from_date` date NOT NULL,
`to_date` date NOT NULL,
PRIMARY KEY (`emp_no`,`from_date`));
*/
select emp_no, count(emp_no) as t from salaries group by emp_no having t > 15;


/*
运行时间：32ms

占用内存：4180k
*/

select emp_no, count(distinct salary) as t from salaries group by emp_no having t > 15;
/*
运行时间：26ms

占用内存：3416k
*/

select e.emp_no, count(e.emp_no) as t from (select emp_no, salary from salaries group by emp_no,salary) e group by e.emp_no having t > 15;
/*
运行时间：27ms

占用内存：3308k
*/



/*
找出所有员工当前(to_date='9999-01-01')具体的薪水salary情况，对于相同的薪水只显示一次,并按照逆序显示
CREATE TABLE `salaries` (
`emp_no` int(11) NOT NULL,
`salary` int(11) NOT NULL,
`from_date` date NOT NULL,
`to_date` date NOT NULL,
PRIMARY KEY (`emp_no`,`from_date`));
*/
select distinct salary from salaries where to_date='9999-01-01' order by salary desc;


/*
运行时间：15ms

占用内存：3552k
*/

select salary from salaries where to_date='9999-01-01' group by salary order by salary desc;
/*
运行时间：29ms

占用内存：3424k
*/

/*
1、数据量非常巨大时候，比如1000万中有300W不重复数据，这时候的distinct的效率略好于group by；
2、对于相对重复量较小的数据量比如1000万中1万的不重复量，用groupby的性能会远优于distnct。
3、简书上的一篇博客说的不错，大家可以穿送过去看一看https://www.jianshu.com/p/34800d06f63d 
*/

/*
获取所有部门当前manager的当前薪水情况，给出dept_no, emp_no以及salary，当前表示to_date='9999-01-01'
CREATE TABLE `dept_manager` (
`dept_no` char(4) NOT NULL,
`emp_no` int(11) NOT NULL,
`from_date` date NOT NULL,
`to_date` date NOT NULL,
PRIMARY KEY (`emp_no`,`dept_no`));
CREATE TABLE `salaries` (
`emp_no` int(11) NOT NULL,
`salary` int(11) NOT NULL,
`from_date` date NOT NULL,
`to_date` date NOT NULL,
PRIMARY KEY (`emp_no`,`from_date`));
*/
select m.dept_no, m.emp_no, s.salary from dept_manager m, salaries s where m.to_date='9999-01-01' and s.to_date='9999-01-01' and m.emp_no = s.emp_no;


/*
运行时间：19ms

占用内存：3320k
*/

select m.dept_no, m.emp_no, s.salary from dept_manager m inner join salaries s on m.to_date='9999-01-01' and s.to_date='9999-01-01' and m.emp_no = s.emp_no;
/*
运行时间：20ms

占用内存：3428k
*/


/*
获取所有非manager的员工emp_no
CREATE TABLE `dept_manager` (
`dept_no` char(4) NOT NULL,
`emp_no` int(11) NOT NULL,
`from_date` date NOT NULL,
`to_date` date NOT NULL,
PRIMARY KEY (`emp_no`,`dept_no`));
CREATE TABLE `employees` (
`emp_no` int(11) NOT NULL,
`birth_date` date NOT NULL,
`first_name` varchar(14) NOT NULL,
`last_name` varchar(16) NOT NULL,
`gender` char(1) NOT NULL,
`hire_date` date NOT NULL,
PRIMARY KEY (`emp_no`));
*/
select emp_no from employees where emp_no not in (select emp_no from dept_manager);


/*
运行时间：24ms

占用内存：3428k
*/

select e.emp_no from employees e left join dept_manager m on e.emp_no = m.emp_no where m.emp_no is null;
/*
运行时间：14ms

占用内存：3420k
*/

select emp_no from employees except select emp_no from dept_manager;

/*
运行时间：26ms

占用内存：3428k
*/

select e.emp_no from employees e where not exists (select emp_no from dept_manager m where m.emp_no = e.emp_no);

/*
运行时间：19ms

占用内存：3192k
*/

/*
看运行时间可以看出，join > exists > in > except
*/


/*
获取所有员工当前的manager，如果当前的manager是自己的话结果不显示，当前表示to_date='9999-01-01'。
结果第一列给出当前员工的emp_no,第二列给出其manager对应的manager_no。
CREATE TABLE `dept_emp` (
`emp_no` int(11) NOT NULL,
`dept_no` char(4) NOT NULL,
`from_date` date NOT NULL,
`to_date` date NOT NULL,
PRIMARY KEY (`emp_no`,`dept_no`));
CREATE TABLE `dept_manager` (
`dept_no` char(4) NOT NULL,
`emp_no` int(11) NOT NULL,
`from_date` date NOT NULL,
`to_date` date NOT NULL,
PRIMARY KEY (`emp_no`,`dept_no`));
*/
select e.emp_no, m.emp_no as manager_no from dept_emp e inner join dept_manager m on m.dept_no = e.dept_no and m.to_date='9999-01-01' and e.emp_no <> m.emp_no;

/*
运行时间：25ms

占用内存：4440k
*/

select e.emp_no, m.emp_no as manager_no from dept_emp e left join dept_manager m on m.dept_no = e.dept_no where m.to_date='9999-01-01' and m.emp_no != e.emp_no;

/*
运行时间：28ms

占用内存：3432k
*/


/*
获取所有部门中当前员工薪水最高的相关信息，给出dept_no, emp_no以及其对应的salary, 当前表示to_date='9999-01-01'
CREATE TABLE `dept_emp` (
`emp_no` int(11) NOT NULL,
`dept_no` char(4) NOT NULL,
`from_date` date NOT NULL,
`to_date` date NOT NULL,
PRIMARY KEY (`emp_no`,`dept_no`));
CREATE TABLE `salaries` (
`emp_no` int(11) NOT NULL,
`salary` int(11) NOT NULL,
`from_date` date NOT NULL,
`to_date` date NOT NULL,
PRIMARY KEY (`emp_no`,`from_date`));
*/
select e.dept_no, s.emp_no, s.salary from salaries s inner join dept_emp e on e.emp_no = s.emp_no where e.to_date='9999-01-01' group by e.dept_no having max(s.salary);

/*
运行时间：28ms

占用内存：3432k
*/

select e.dept_no, s.emp_no, s.salary from salaries s left join dept_emp e on e.emp_no = s.emp_no where e.to_date='9999-01-01' group by e.dept_no having max(s.salary);
/*
运行时间：24ms

占用内存：3300k
*/

select e.dept_no, s.emp_no, max(s.salary) from salaries s left join dept_emp e on e.emp_no = s.emp_no where e.to_date='9999-01-01' group by e.dept_no;
/*
运行时间：20ms

占用内存：3336k
*/

/*
从titles表获取按照title进行分组，每组个数大于等于2，给出title以及对应的数目t。
CREATE TABLE IF NOT EXISTS "titles" (
`emp_no` int(11) NOT NULL,
`title` varchar(50) NOT NULL,
`from_date` date NOT NULL,
`to_date` date DEFAULT NULL);
*/
select title, count(title) as t from titles group by title having t >= 2;

/*
运行时间：20ms

占用内存：3320k
*/


/*
从titles表获取按照title进行分组，每组个数大于等于2，给出title以及对应的数目t。
注意对于重复的emp_no进行忽略。
CREATE TABLE IF NOT EXISTS "titles" (
`emp_no` int(11) NOT NULL,
`title` varchar(50) NOT NULL,
`from_date` date NOT NULL,
`to_date` date DEFAULT NULL);
*/
select title, count(distinct emp_no) as t from titles group by title having t >= 2;

/*
运行时间：24ms

占用内存：3428k
*/

select title, count(*) as t from (select distinct emp_no, title from titles) group by title having t >= 2;

/*
运行时间：32ms

占用内存：3420k
*/


/*
查找employees表所有emp_no为奇数，且last_name不为Mary的员工信息，并按照hire_date逆序排列
CREATE TABLE `employees` (
`emp_no` int(11) NOT NULL,
`birth_date` date NOT NULL,
`first_name` varchar(14) NOT NULL,
`last_name` varchar(16) NOT NULL,
`gender` char(1) NOT NULL,
`hire_date` date NOT NULL,
PRIMARY KEY (`emp_no`));
*/
select * from employees where last_name != 'Mary' and emp_no % 2 = 1 order by hire_date desc;

/*
运行时间：28ms

占用内存：3404k
*/


/*
统计出当前各个title类型对应的员工当前薪水对应的平均工资。结果给出title以及平均工资avg。
CREATE TABLE `salaries` (
`emp_no` int(11) NOT NULL,
`salary` int(11) NOT NULL,
`from_date` date NOT NULL,
`to_date` date NOT NULL,
PRIMARY KEY (`emp_no`,`from_date`));
CREATE TABLE IF NOT EXISTS "titles" (
`emp_no` int(11) NOT NULL,
`title` varchar(50) NOT NULL,
`from_date` date NOT NULL,
`to_date` date DEFAULT NULL);
*/
select t.title, avg(s.salary) from salaries s inner join titles t on s.emp_no = t.emp_no and s.to_date='9999-01-01' and t.to_date='9999-01-01' group by t.title;

/*
运行时间：30ms

占用内存：3224k
*/

select t.title, avg(s.salary) from salaries s inner join titles t on s.emp_no = t.emp_no where s.to_date='9999-01-01' and t.to_date='9999-01-01' group by t.title;

/*
运行时间：24ms

占用内存：3296k
*/


/*
获取当前（to_date='9999-01-01'）薪水第二多的员工的emp_no以及其对应的薪水salary
CREATE TABLE `salaries` (
`emp_no` int(11) NOT NULL,
`salary` int(11) NOT NULL,
`from_date` date NOT NULL,
`to_date` date NOT NULL,
PRIMARY KEY (`emp_no`,`from_date`));

*/
select emp_no, salary from salaries where to_date='9999-01-01' and salary = (select distinct salary from salaries order by salary desc limit 1,1);

/*
运行时间：25ms

占用内存：3548k
*/


/*
查找当前薪水(to_date='9999-01-01')排名第二多的员工编号emp_no、薪水salary、last_name以及first_name，不准使用order by
CREATE TABLE `employees` (
`emp_no` int(11) NOT NULL,
`birth_date` date NOT NULL,
`first_name` varchar(14) NOT NULL,
`last_name` varchar(16) NOT NULL,
`gender` char(1) NOT NULL,
`hire_date` date NOT NULL,
PRIMARY KEY (`emp_no`));
CREATE TABLE `salaries` (
`emp_no` int(11) NOT NULL,
`salary` int(11) NOT NULL,
`from_date` date NOT NULL,
`to_date` date NOT NULL,
PRIMARY KEY (`emp_no`,`from_date`));

*/
select e.emp_no, max(s.salary), e.last_name, e.first_name from salaries s left join employees e on s.emp_no = e.emp_no where s.to_date='9999-01-01' and salary < (select max(salary) from salaries where to_date='9999-01-01');

/*
运行时间：27ms

占用内存：3420k
*/


select e.emp_no, max(s.salary), e.last_name, e.first_name from salaries s, employees e where s.emp_no = e.emp_no and s.to_date='9999-01-01' and salary < (select max(salary) from salaries where to_date='9999-01-01');

/*
运行时间：16ms

占用内存：3416k
*/


select e.emp_no, s.salary, e.last_name, e.first_name 
from salaries s inner join employees e on s.emp_no = e.emp_no 
where s.to_date='9999-01-01' 
and salary = (
    select max(salary) 
    from salaries 
    where to_date='9999-01-01' 
    and salary < (
        select max(salary) 
        from salaries 
        where to_date='9999-01-01')
    );

/*
运行时间：15ms

占用内存：3420k
*/


select e.emp_no, salary, last_name, first_name
from employees as e inner join salaries as s on e.emp_no = s.emp_no
where s.to_date='9999-01-01'
and salary = 
(select max(salary) from salaries where to_date='9999-01-01' and salary < (select max(salary) from salaries  where to_date='9999-01-01'));

/*
运行时间：22ms

占用内存：3292k
*/


select e.emp_no, s.salary, e.last_name, e.first_name 
from salaries s, employees e 
where s.to_date='9999-01-01' 
and s.emp_no = e.emp_no
and salary = (
    select max(salary) 
    from salaries 
    where to_date='9999-01-01' 
    and salary < (
        select max(salary) 
        from salaries 
        where to_date='9999-01-01')
    );

/*
运行时间：19ms

占用内存：3320k
*/


/*
查找所有员工的last_name和first_name以及对应的dept_name，也包括暂时没有分配部门的员工
CREATE TABLE `departments` (
`dept_no` char(4) NOT NULL,
`dept_name` varchar(40) NOT NULL,
PRIMARY KEY (`dept_no`));
CREATE TABLE `dept_emp` (
`emp_no` int(11) NOT NULL,
`dept_no` char(4) NOT NULL,
`from_date` date NOT NULL,
`to_date` date NOT NULL,
PRIMARY KEY (`emp_no`,`dept_no`));
CREATE TABLE `employees` (
`emp_no` int(11) NOT NULL,
`birth_date` date NOT NULL,
`first_name` varchar(14) NOT NULL,
`last_name` varchar(16) NOT NULL,
`gender` char(1) NOT NULL,
`hire_date` date NOT NULL,
PRIMARY KEY (`emp_no`));

*/
select e.last_name, e.first_name, d.dept_name 
from employees e 
left join dept_emp de on de.emp_no = e.emp_no 
left join departments d on d.dept_no = de.dept_no;

/*
运行时间：27ms

占用内存：3320k
*/


select e.last_name, e.first_name, tmp.dept_name
from employees e
left join (select d.dept_name, de.emp_no
    from dept_emp de
    left join departments d
    on d.dept_no = de.dept_no) tmp
on tmp.emp_no = e.emp_no;

/*
运行时间：23ms

占用内存：3684k
*/

/*
查找员工编号emp_no为10001其自入职以来的薪水salary涨幅值growth
CREATE TABLE `salaries` (
`emp_no` int(11) NOT NULL,
`salary` int(11) NOT NULL,
`from_date` date NOT NULL,
`to_date` date NOT NULL,
PRIMARY KEY (`emp_no`,`from_date`));
*/
select (max(salary) - min(salary)) as growth
from salaries
where emp_no=10001;

/*
运行时间：18ms

占用内存：3320k
*/


select (
    (select salary from salaries where emp_no=10001 order by to_date desc limit 1) - 
    (select salary from salaries where emp_no=10001 order by to_date asc limit 1)
) as growth

/*
运行时间：23ms

占用内存：3448k
*/


/*
查找所有员工自入职以来的薪水涨幅情况，给出员工编号emp_no以及其对应的薪水涨幅growth，并按照growth进行升序
CREATE TABLE `employees` (
`emp_no` int(11) NOT NULL,
`birth_date` date NOT NULL,
`first_name` varchar(14) NOT NULL,
`last_name` varchar(16) NOT NULL,
`gender` char(1) NOT NULL,
`hire_date` date NOT NULL,
PRIMARY KEY (`emp_no`));
CREATE TABLE `salaries` (
`emp_no` int(11) NOT NULL,
`salary` int(11) NOT NULL,
`from_date` date NOT NULL,
`to_date` date NOT NULL,
PRIMARY KEY (`emp_no`,`from_date`));
*/
select current.emp_no, (current.salary - start.salary) as growth 
from (
    select e1.emp_no, s1.salary from employees e1 left join salaries s1 on e1.emp_no = s1.emp_no where s1.to_date = '9999-01-01'
) as current
inner join (
    select e2.emp_no, s2.salary from employees e2 left join salaries s2 on e2.emp_no = s2.emp_no where e2.hire_date = s2.from_date
) as start on start.emp_no = current.emp_no
order by growth;


/*
运行时间：25ms

占用内存：3304k
*/

select current.emp_no, (current.salary - start.salary) as growth
from (
    select e2.emp_no, s2.salary from employees e2 left join salaries s2 on e2.emp_no = s2.emp_no where e2.hire_date = s2.from_date
) as start
inner join (
    select emp_no, salary from salaries where to_date = '9999-01-01'
) as current
on start.emp_no = current.emp_no
order by growth;

/*
运行时间：21ms

占用内存：3260k
*/

SELECT sCurrent.emp_no, (sCurrent.salary-sStart.salary) AS growth
FROM (SELECT s.emp_no, s.salary FROM employees e, salaries s WHERE e.emp_no = s.emp_no AND s.to_date = '9999-01-01') AS sCurrent,
(SELECT s.emp_no, s.salary FROM employees e, salaries s WHERE e.emp_no = s.emp_no AND s.from_date = e.hire_date) AS sStart
WHERE sCurrent.emp_no = sStart.emp_no
ORDER BY growth

/*
运行时间：21ms

占用内存：3312k
*/

SELECT sCurrent.emp_no, (sCurrent.salary-sStart.salary) AS growth
FROM (SELECT s.emp_no, s.salary FROM employees e, salaries s WHERE e.emp_no = s.emp_no AND s.from_date = e.hire_date) AS sStart,
(SELECT emp_no, salary FROM salaries WHERE to_date = '9999-01-01') AS sCurrent
WHERE sCurrent.emp_no = sStart.emp_no
ORDER BY growth

/*
运行时间：21ms

占用内存：3308k
*/