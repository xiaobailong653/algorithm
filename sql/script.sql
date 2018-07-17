最近正好有点时间，就整理了一下牛客网上的数据库SQL实战中的题，里面的每一道题我都亲自编写并运行了一下，有的题可能不止一个解，并且有些做了备注与分析。希望能给学习数据库的同学有所帮助。


## 1、查找最晚入职员工的所有信息

### 表结构说明

    CREATE TABLE `employees` (
    `emp_no` int(11) NOT NULL,
    `birth_date` date NOT NULL,
    `first_name` varchar(14) NOT NULL,
    `last_name` varchar(16) NOT NULL,
    `gender` char(1) NOT NULL,
    `hire_date` date NOT NULL,
    PRIMARY KEY (`emp_no`));

### 脚本 1

    select * 
    from employees 
    order by hire_date desc limit 1;

 **运行时间：***17ms*
 **占用内存：***3320k*
 **解题思路：***这个是解题思路*

### 脚本 2

    select *
    from employees 
    where hire_date = (select max(hire_date) from employees);

**运行时间：***25ms*
**占用内存：***3300k*


## 2、查找入职员工时间排名倒数第三的员工所有信息

### 表结构说明

    CREATE TABLE `employees` (
    `emp_no` int(11) NOT NULL,
    `birth_date` date NOT NULL,
    `first_name` varchar(14) NOT NULL,
    `last_name` varchar(16) NOT NULL,
    `gender` char(1) NOT NULL,
    `hire_date` date NOT NULL,
    PRIMARY KEY (`emp_no`));

### 脚本 1

    select * 
    from employees 
    order by hire_date desc limit 2,1;

**运行时间：***31ms*
**占用内存：***4332k*

### 脚本 2

    select * 
    from employees 
    where hire_date = (select hire_date from employees order by hire_date desc limit 2,1);

**运行时间：***18ms*
**占用内存：***3284k*


## 3、查找各个部门当前(to_date='9999-01-01')领导当前薪水详情以及其对应部门编号dept_no

### 表结构说明

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

### 脚本 1

    select s.*,d.dept_no 
    from salaries s, dept_manager d 
    where s.to_date='9999-01-01' 
    and d.to_date='9999-01-01' 
    and s.emp_no = d.emp_no;

**运行时间：***24ms*
**占用内存：***3304k*


## 4、查找所有已经分配部门的员工的last_name和first_name

### 表结构说明

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

### 脚本 1

    select e.last_name, e.first_name, d.dept_no 
    from dept_emp d 
    inner join employees e 
    on e.emp_no=d.emp_no;

**运行时间：***19ms*
**占用内存：***3284k*


# 5、查找所有员工的last_name和first_name以及对应部门编号dept_no，也包括展示没有分配具体部门的员工

### 表结构说明

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

### 脚本 1

    select e.last_name, e.first_name, d.dept_no 
    from employees e 
    left join dept_emp d 
    on e.emp_no=d.emp_no;

**运行时间：***19ms*
**占用内存：***3284k*


# 6、查找所有员工入职时候的薪水情况，给出emp_no以及salary， 并按照emp_no进行逆序

### 表结构说明

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

### 脚本 1

    select s.emp_no, s.salary 
    from salaries s, employees e 
    where s.emp_no=e.emp_no 
    and s.from_date = e.hire_date 
    order by s.emp_no desc;

**运行时间：***29ms*
**占用内存：***3284k*

### 脚本 2

    select s.emp_no, s.salary 
    from salaries s 
    inner join employees e 
    on s.emp_no=e.emp_no 
    and s.from_date = e.hire_date 
    order by s.emp_no desc;

**运行时间：***29ms*
**占用内存：***3304k*

### 脚本 3

    select emp_no, salary 
    from salaries 
    group by emp_no 
    having min(from_date) 
    order by emp_no desc;

**运行时间：***22ms*
**占用内存：***3436k*


## 7、查找薪水涨幅超过15次的员工号emp_no以及其对应的涨幅次数t

### 表结构说明

    CREATE TABLE `salaries` (
    `emp_no` int(11) NOT NULL,
    `salary` int(11) NOT NULL,
    `from_date` date NOT NULL,
    `to_date` date NOT NULL,
    PRIMARY KEY (`emp_no`,`from_date`));

### 脚本 1

    select emp_no, count(emp_no) as t 
    from salaries 
    group by emp_no having t > 15;

**运行时间：***32ms*
**占用内存：***4180k*

### 脚本 2

    select emp_no, count(distinct salary) as t 
    from salaries group by emp_no having t > 15;

**运行时间：***26ms*
**占用内存：***3416k*

### 脚本 3

    select e.emp_no, count(e.emp_no) as t 
    from (select emp_no, salary 
          from salaries group by emp_no,salary) e 
    group by e.emp_no having t > 15;

**运行时间：***27ms*
**占用内存：***3308k*


## 8、找出所有员工当前(to_date='9999-01-01')具体的薪水salary情况，对于相同的薪水只显示一次,并按照逆序显示

### 表结构说明

    CREATE TABLE `salaries` (
    `emp_no` int(11) NOT NULL,
    `salary` int(11) NOT NULL,
    `from_date` date NOT NULL,
    `to_date` date NOT NULL,
    PRIMARY KEY (`emp_no`,`from_date`));

### 脚本 1

    select distinct salary 
    from salaries 
    where to_date='9999-01-01' 
    order by salary desc;

**运行时间：***15ms*
**占用内存：***3552k*

### 脚本 2

    select salary 
    from salaries 
    where to_date='9999-01-01' 
    group by salary 
    order by salary desc;

**运行时间：***29ms*
**占用内存：***3424k* 
**备注：***大家可以参考一下这个网址（https://www.jianshu.com/p/34800d06f63d）关于distinct和group by的效率分析*

## 9、获取所有部门当前manager的当前薪水情况，给出dept_no, emp_no以及salary，当前表示to_date='9999-01-01'

### 表结构说明

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

### 脚本 1

    select m.dept_no, m.emp_no, s.salary 
    from dept_manager m, salaries s 
    where m.to_date='9999-01-01' 
    and s.to_date='9999-01-01' 
    and m.emp_no = s.emp_no;

**运行时间：***19ms*
**占用内存：***3320k* 

### 脚本 2

    select m.dept_no, m.emp_no, s.salary 
    from dept_manager m 
    inner join salaries s on m.to_date='9999-01-01' and s.to_date='9999-01-01' and m.emp_no = s.emp_no;

**运行时间：***20ms*
**占用内存：***3428k*


## 10、获取所有非manager的员工emp_no

### 表结构说明

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

### 脚本 1

    select emp_no 
    from employees 
    where emp_no not in (select emp_no from dept_manager);

**运行时间：***24ms*
**占用内存：***3428k*

### 脚本 2

    select e.emp_no 
    from employees e 
    left join dept_manager m on e.emp_no = m.emp_no 
    where m.emp_no is null;

**运行时间：***14ms*
**占用内存：***3420k*

### 脚本 3

    select emp_no 
    from employees 
    except select emp_no from dept_manager;

**运行时间：***26ms*
**占用内存：***3428k*

### 脚本 4

    select e.emp_no 
    from employees e 
    where not exists (select emp_no 
                      from dept_manager m 
                  where m.emp_no = e.emp_no);

**运行时间：***19ms*
**占用内存：***3192k*

**备注：***看运行时间可以看出，join > exists > in > except*


## 11、获取所有员工当前的manager，如果当前的manager是自己的话结果不显示，当前表示to_date='9999-01-01'。结果第一列给出当前员工的emp_no,第二列给出其manager对应的manager_no。

### 表结构说明

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

### 脚本 1

    select e.emp_no, m.emp_no as manager_no 
    from dept_emp e 
    inner join dept_manager m on m.dept_no = e.dept_no and m.to_date='9999-01-01' and e.emp_no <> m.emp_no;

**运行时间：***25ms*
**占用内存：***4440k*

### 脚本 2

    select e.emp_no, m.emp_no as manager_no 
    from dept_emp e 
    left join dept_manager m on m.dept_no = e.dept_no 
    where m.to_date='9999-01-01' 
    and m.emp_no != e.emp_no;

**运行时间：***28ms*
**占用内存：***3432k*


## 12、获取所有部门中当前员工薪水最高的相关信息，给出dept_no, emp_no以及其对应的salary, 当前表示to_date='9999-01-01'

### 表结构说明

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

### 脚本 1

    select e.dept_no, s.emp_no, s.salary 
    from salaries s 
    inner join dept_emp e on e.emp_no = s.emp_no 
    where e.to_date='9999-01-01' 
    group by e.dept_no having max(s.salary);

**运行时间：***28ms*
**占用内存：***3432k*

### 脚本 2

    select e.dept_no, s.emp_no, s.salary 
    from salaries s 
    left join dept_emp e on e.emp_no = s.emp_no 
    where e.to_date='9999-01-01' 
    group by e.dept_no having max(s.salary);

**运行时间：***24ms*
**占用内存：***3300k*

### 脚本 3

    select e.dept_no, s.emp_no, max(s.salary) 
    from salaries s 
    left join dept_emp e on e.emp_no = s.emp_no 
    where e.to_date='9999-01-01' 
    group by e.dept_no;

**运行时间：***20ms*
**占用内存：***3336k*


## 13、从titles表获取按照title进行分组，每组个数大于等于2，给出title以及对应的数目t。

### 表结构说明

    CREATE TABLE IF NOT EXISTS "titles" (
    `emp_no` int(11) NOT NULL,
    `title` varchar(50) NOT NULL,
    `from_date` date NOT NULL,
    `to_date` date DEFAULT NULL);

### 脚本 1

    select title, count(title) as t 
    from titles 
    group by title having t >= 2;

**运行时间：***20ms*
**占用内存：***3320k*


## 14、从titles表获取按照title进行分组，每组个数大于等于2，给出title以及对应的数目t。 注意对于重复的emp_no进行忽略。

### 表结构说明

    CREATE TABLE IF NOT EXISTS "titles" (
    `emp_no` int(11) NOT NULL,
    `title` varchar(50) NOT NULL,
    `from_date` date NOT NULL,
    `to_date` date DEFAULT NULL);

### 脚本 1

    select title, count(distinct emp_no) as t 
    from titles 
    group by title having t >= 2;

**运行时间：***24ms*
**占用内存：***3428k*

### 脚本 2

    select title, count(*) as t 
    from (select distinct emp_no, title from titles) 
    group by title having t >= 2;

**运行时间：***32ms*
**占用内存：***3420k*


## 15、查找employees表所有emp_no为奇数，且last_name不为Mary的员工信息，并按照hire_date逆序排列

### 表结构说明

    CREATE TABLE `employees` (
    `emp_no` int(11) NOT NULL,
    `birth_date` date NOT NULL,
    `first_name` varchar(14) NOT NULL,
    `last_name` varchar(16) NOT NULL,
    `gender` char(1) NOT NULL,
    `hire_date` date NOT NULL,
    PRIMARY KEY (`emp_no`));

### 脚本 1

    select * 
    from employees 
    where last_name != 'Mary' 
    and emp_no % 2 = 1 
    order by hire_date desc;

**运行时间：***28ms*
**占用内存：***3404k*


## 16、统计出当前各个title类型对应的员工当前薪水对应的平均工资。结果给出title以及平均工资avg。

### 表结构说明

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

### 脚本 1

    select t.title, avg(s.salary) 
    from salaries s 
    inner join titles t on s.emp_no = t.emp_no and s.to_date='9999-01-01' and t.to_date='9999-01-01' 
    group by t.title;

**运行时间：***30ms*
**占用内存：***3224k*

### 脚本 2

    select t.title, avg(s.salary) 
    from salaries s 
    inner join titles t on s.emp_no = t.emp_no 
    where s.to_date='9999-01-01' and t.to_date='9999-01-01' 
    group by t.title;

**运行时间：***24ms*
**占用内存：***3296k*



## 17、获取当前（to_date='9999-01-01'）薪水第二多的员工的emp_no以及其对应的薪水salary

### 表结构说明

    CREATE TABLE `salaries` (
    `emp_no` int(11) NOT NULL,
    `salary` int(11) NOT NULL,
    `from_date` date NOT NULL,
    `to_date` date NOT NULL,
    PRIMARY KEY (`emp_no`,`from_date`));

### 脚本 1

    select emp_no, salary 
    from salaries 
    where to_date='9999-01-01' 
    and salary = (select distinct salary from salaries order by salary desc limit 1,1);

**运行时间：***25ms*
**占用内存：***3548k*


## 18、查找当前薪水(to_date='9999-01-01')排名第二多的员工编号emp_no、薪水salary、last_name以及first_name，不准使用order by

### 表结构说明

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

### 脚本 1

    select e.emp_no, max(s.salary), e.last_name, e.first_name 
    from salaries s 
    left join employees e on s.emp_no = e.emp_no 
    where s.to_date='9999-01-01' 
    and salary < (select max(salary) from salaries where to_date='9999-01-01');

**运行时间：***27ms*
**占用内存：***3420k*

### 脚本 2

    select e.emp_no, max(s.salary), e.last_name, e.first_name 
    from salaries s, employees e 
    where s.emp_no = e.emp_no 
    and s.to_date='9999-01-01' 
    and salary < (select max(salary) from salaries where to_date='9999-01-01');

**运行时间：***16ms*
**占用内存：***3416k*

### 脚本 3

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

**运行时间：***15ms*
**占用内存：***3420k*

### 脚本 4

    select e.emp_no, salary, last_name, first_name
    from employees as e inner join salaries as s on e.emp_no = s.emp_no
    where s.to_date='9999-01-01'
    and salary = (select max(salary) 
                  from salaries 
                  where to_date='9999-01-01' 
                  and salary < (select max(salary) from salaries  where to_date='9999-01-01'));

**运行时间：***22ms*
**占用内存：***3292k*

### 脚本 5

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

**运行时间：***19ms*
**占用内存：***3320k*


## 19、查找所有员工的last_name和first_name以及对应的dept_name，也包括暂时没有分配部门的员工

### 表结构说明

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

### 脚本 1

    select e.last_name, e.first_name, d.dept_name 
    from employees e 
    left join dept_emp de on de.emp_no = e.emp_no 
    left join departments d on d.dept_no = de.dept_no;

**运行时间：***27ms*
**占用内存：***3320k*

### 脚本 2

    select e.last_name, e.first_name, tmp.dept_name
    from employees e
    left join (select d.dept_name, de.emp_no
        from dept_emp de
        left join departments d
        on d.dept_no = de.dept_no) tmp
    on tmp.emp_no = e.emp_no;

**运行时间：***23ms*
**占用内存：***3684k*


## 20、查找员工编号emp_no为10001其自入职以来的薪水salary涨幅值growth

### 表结构说明

    CREATE TABLE `salaries` (
    `emp_no` int(11) NOT NULL,
    `salary` int(11) NOT NULL,
    `from_date` date NOT NULL,
    `to_date` date NOT NULL,
    PRIMARY KEY (`emp_no`,`from_date`));

### 脚本 1

    select (max(salary) - min(salary)) as growth
    from salaries
    where emp_no=10001;

**运行时间：***18ms*
**占用内存：***3320k*

### 脚本 2

    select (
        (select salary from salaries where emp_no=10001 order by to_date desc limit 1) - 
        (select salary from salaries where emp_no=10001 order by to_date asc limit 1)
    ) as growth

**运行时间：***23ms*
**占用内存：***3448k*


## 21、查找所有员工自入职以来的薪水涨幅情况，给出员工编号emp_no以及其对应的薪水涨幅growth，并按照growth进行升序

### 表结构说明

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

### 脚本 1

    select current.emp_no, (current.salary - start.salary) as growth 
    from (
        select e1.emp_no, s1.salary 
        from employees e1 
        left join salaries s1 on e1.emp_no = s1.emp_no 
        where s1.to_date = '9999-01-01'
    ) as current
    inner join (
        select e2.emp_no, s2.salary 
        from employees e2 
        left join salaries s2 on e2.emp_no = s2.emp_no 
        where e2.hire_date = s2.from_date
    ) as start on start.emp_no = current.emp_no
    order by growth;

**运行时间：***25ms*
**占用内存：***3304k*

### 脚本 2

    select current.emp_no, (current.salary - start.salary) as growth
    from (
        select e2.emp_no, s2.salary 
        from employees e2 
        left join salaries s2 on e2.emp_no = s2.emp_no 
        where e2.hire_date = s2.from_date
    ) as start
    inner join (
        select emp_no, salary 
        from salaries 
        where to_date = '9999-01-01'
    ) as current
    on start.emp_no = current.emp_no
    order by growth;

**运行时间：***21ms*
**占用内存：***3260k*

### 脚本 3

    SELECT sCurrent.emp_no, (sCurrent.salary-sStart.salary) AS growth
    FROM 
    (SELECT s.emp_no, s.salary 
     FROM employees e, salaries s 
     WHERE e.emp_no = s.emp_no 
     AND s.to_date = '9999-01-01') AS sCurrent,
    (SELECT s.emp_no, s.salary 
     FROM employees e, salaries s 
     WHERE e.emp_no = s.emp_no 
     AND s.from_date = e.hire_date) AS sStart
    WHERE sCurrent.emp_no = sStart.emp_no
    ORDER BY growth

**运行时间：***21ms*
**占用内存：***3312k*

### 脚本 4

    SELECT sCurrent.emp_no, (sCurrent.salary-sStart.salary) AS growth
    FROM 
    (SELECT s.emp_no, s.salary 
     FROM employees e, salaries s 
     WHERE e.emp_no = s.emp_no 
     AND s.from_date = e.hire_date) AS sStart,
    (SELECT emp_no, salary 
     FROM salaries 
     WHERE to_date = '9999-01-01') AS sCurrent
    WHERE sCurrent.emp_no = sStart.emp_no
    ORDER BY growth

**运行时间：***21ms*
**占用内存：***3308k*


## 22、统计各个部门对应员工涨幅的次数总和，给出部门编码dept_no、部门名称dept_name以及次数sum

### 表结构说明

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

    CREATE TABLE `salaries` (
    `emp_no` int(11) NOT NULL,
    `salary` int(11) NOT NULL,
    `from_date` date NOT NULL,
    `to_date` date NOT NULL,
    PRIMARY KEY (`emp_no`,`from_date`));

### 脚本 1

    select de.dept_no, d.dept_name, count(s.salary) as sum
    from dept_emp de
    left join salaries s on de.emp_no = s.emp_no
    left join departments d on de.dept_no = d.dept_no
    group by de.dept_no;

**运行时间：***14ms*
**占用内存：***3420k*

### 脚本 2

    select de.dept_no, d.dept_name, count(s.salary) as sum
    from dept_emp de, salaries s, departments d
    where de.emp_no = s.emp_no
    and de.dept_no = d.dept_no
    group by de.dept_no;

**运行时间：***14ms*
**占用内存：***3420k*


## 23、对所有员工的当前(to_date='9999-01-01')薪水按照salary进行按照1-N的排名，相同salary并列且按照emp_no升序排列

### 表结构说明

    CREATE TABLE `salaries` (
    `emp_no` int(11) NOT NULL,
    `salary` int(11) NOT NULL,
    `from_date` date NOT NULL,
    `to_date` date NOT NULL,
    PRIMARY KEY (`emp_no`,`from_date`));

### 脚本 1

    select s1.emp_no, s1.salary, count(distinct s2.salary) as rank
    from salaries s1, salaries s2
    where s1.to_date='9999-01-01'
    and s2.to_date='9999-01-01'
    and s1.salary <= s2.salary
    group by s1.emp_no
    order by s1.salary desc, s2.emp_no asc;

**运行时间：***15ms*
**占用内存：***3556k*


## 24、获取所有非manager员工当前的薪水情况，给出dept_no、emp_no以及salary ，当前表示to_date='9999-01-01'

### 表结构说明

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

### 脚本 1

    select de.dept_no, e.emp_no, s.salary
    from employees e
    inner join salaries s on e.emp_no = s.emp_no and s.to_date = '9999-01-01'
    inner join dept_emp de on de.emp_no = e.emp_no
    left join dept_manager dm on e.emp_no = dm.emp_no
    where dm.dept_no is null;

**运行时间：***23ms*
**占用内存：***3300k*

### 脚本 2

    select de.dept_no, ee.emp_no, s.salary
    from (select e.emp_no
          from employees e 
          left join dept_manager dm on dm.emp_no = e.emp_no 
          where dm.dept_no is null) as ee
    inner join salaries s on ee.emp_no = s.emp_no and s.to_date = '9999-01-01'
    inner join dept_emp de on ee.emp_no = de.emp_no;

**运行时间：***15ms*
**占用内存：***3424k*


## 25、获取员工其当前的薪水比其manager当前薪水还高的相关信息，当前表示to_date='9999-01-01',结果第一列给出员工的emp_no，第二列给出其manager的manager_no，第三列给出该员工当前的薪水emp_salary,第四列给该员工对应的manager当前的薪水manager_salary

### 表结构说明

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

    CREATE TABLE `salaries` (
    `emp_no` int(11) NOT NULL,
    `salary` int(11) NOT NULL,
    `from_date` date NOT NULL,
    `to_date` date NOT NULL,
    PRIMARY KEY (`emp_no`,`from_date`));

### 脚本 1

    select de.emp_no as emp_no, dm.emp_no as manager_no, de.salary as emp_salary, dm.salary as manager_salary
    from (select e.dept_no, e.emp_no, s.salary 
          from dept_emp e
          inner join salaries s on e.emp_no = s.emp_no and s.to_date='9999-01-01') as de
    inner join (select m.dept_no, m.emp_no, s.salary from dept_manager m
                inner join salaries s on m.emp_no = s.emp_no and s.to_date='9999-01-01')
                as dm on de.dept_no = dm.dept_no
    where emp_salary > manager_salary and de.dept_no = dm.dept_no;

**运行时间：***19ms*
**占用内存：***3304k*


## 26、汇总各个部门当前员工的title类型的分配数目，结果给出部门编号dept_no、dept_name、其当前员工所有的title以及该类型title对应的数目count

### 表结构说明

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

    CREATE TABLE IF NOT EXISTS `titles` (
    `emp_no` int(11) NOT NULL,
    `title` varchar(50) NOT NULL,
    `from_date` date NOT NULL,
    `to_date` date DEFAULT NULL);

### 脚本 1

    select d.dept_no, d.dept_name, t.title, count(*) as count
    from titles t
    inner join dept_emp e on e.emp_no = t.emp_no and e.to_date='9999-01-01' and t.to_date='9999-01-01'
    inner join departments d on e.dept_no = d.dept_no
    group by d.dept_no, t.title;

**运行时间：***26ms*
**占用内存：***3292k*


## 27、给出每个员工每年薪水涨幅超过5000的员工编号emp_no、薪水变更开始日期from_date以及薪水涨幅值salary_growth，并按照salary_growth逆序排列。
**提示：***在sqlite中获取datetime时间对应的年份函数为strftime('%Y', to_date)*

### 表结构说明

    CREATE TABLE `salaries` (
    `emp_no` int(11) NOT NULL,
    `salary` int(11) NOT NULL,
    `from_date` date NOT NULL,
    `to_date` date NOT NULL,
    PRIMARY KEY (`emp_no`,`from_date`));

### 脚本 1

    select s2.emp_no, s2.from_date, (s2.salary - s1.salary) as salary_growth
    from salaries s1, salaries s2
    where s1.emp_no = s2.emp_no
    and salary_growth > 5000
    and (strftime('%Y', s2.from_date) - strftime('%Y', s1.from_date) = 1 or
         strftime('%Y', s2.to_date) - strftime('%Y', s1.to_date) = 1)
    order by salary_growth desc;

**运行时间：***23ms*
**占用内存：***3416k*

### 脚本 2

    select s2.emp_no, s2.from_date, (s2.salary - s1.salary) as salary_growth
    from salaries s1
    inner join salaries s2 on s1.emp_no = s2.emp_no
    and (strftime('%Y', s2.from_date) - strftime('%Y', s1.from_date) = 1 or
         strftime('%Y', s2.to_date) - strftime('%Y', s1.to_date) = 1)
    where salary_growth > 5000
    order by salary_growth desc;

**运行时间：***20ms*
**占用内存：***3300k*


## 28、查找描述信息中包括robot的电影对应的分类名称以及电影数目，而且还需要该分类对应电影数量>=5部

### 表结构说明

    CREATE TABLE IF NOT EXISTS film (
    film_id smallint(5)  NOT NULL DEFAULT '0',
    title varchar(255) NOT NULL,
    description text,
    PRIMARY KEY (film_id));

    CREATE TABLE category  (
    category_id  tinyint(3)  NOT NULL ,
    name  varchar(25) NOT NULL, `last_update` timestamp,
    PRIMARY KEY ( category_id ));

    CREATE TABLE film_category  (
    film_id  smallint(5)  NOT NULL,
    category_id  tinyint(3)  NOT NULL, `last_update` timestamp);

### 脚本 1

    select c.name, count(f.film_id) as count
    from film f, film_category fc, category c,
    (select category_id from film_category group by category_id having count(category_id) >= 5) as cc
    where f.description like "%robot%"
    and f.film_id = fc.film_id
    and fc.category_id = c.category_id
    and c.category_id = cc.category_id

**运行时间：***27ms*
**占用内存：***3556k*


## 29、使用join查询方式找出没有分类的电影id以及名称

### 表结构说明

    CREATE TABLE IF NOT EXISTS film (
    film_id smallint(5)  NOT NULL DEFAULT '0',
    title varchar(255) NOT NULL,
    description text,
    PRIMARY KEY (film_id));

    CREATE TABLE category  (
    category_id  tinyint(3)  NOT NULL ,
    name  varchar(25) NOT NULL, `last_update` timestamp,
    PRIMARY KEY ( category_id ));

    CREATE TABLE film_category  (
    film_id  smallint(5)  NOT NULL,
    category_id  tinyint(3)  NOT NULL, `last_update` timestamp);

### 脚本 1

    select f.film_id, f.title
    from film f
    left join film_category fc on fc.film_id = f.film_id
    where fc.category_id is null;

**运行时间：***25ms*
**占用内存：***3556k*


## 30、使用子查询的方式找出属于Action分类的所有电影对应的title,description

### 表结构说明

    CREATE TABLE IF NOT EXISTS film (
    film_id smallint(5)  NOT NULL DEFAULT '0',
    title varchar(255) NOT NULL,
    description text,
    PRIMARY KEY (film_id));

    CREATE TABLE category  (
    category_id  tinyint(3)  NOT NULL ,
    name  varchar(25) NOT NULL, `last_update` timestamp,
    PRIMARY KEY ( category_id ));

    CREATE TABLE film_category  (
    film_id  smallint(5)  NOT NULL,
    category_id  tinyint(3)  NOT NULL, `last_update` timestamp);

### 脚本 1

    select title, description
    from film
    where film_id in 
    (select film_id 
     from film_category 
     where category_id in 
     (select category_id from category where name="Action")
    );

**运行时间：***25ms*
**占用内存：***3432k*

### 脚本 2

    select title, description
    from film
    where film_id in 
    (select fc.film_id 
     from film_category fc 
     inner join category c 
     on c.category_id = fc.category_id 
     and c.name="Action");

**运行时间：***27ms*
**占用内存：***3552k*

### 脚本 3 
*使用非子查询的方式找出属于Action分类的所有电影对应的title,description*

    select f.title, f.description
    from film f
    left join film_category fc on fc.film_id = f.film_id
    left join category c on c.category_id = fc.category_id
    where c.name = "Action";

**运行时间：***28ms*
**占用内存：***3448k*


## 31、获取select * from employees对应的执行计划

### 脚本 1

    explain select * from employees;

**运行时间：***19ms*
**占用内存：***3300k*


## 32、将employees表的所有员工的last_name和first_name拼接起来作为Name，中间以一个空格区分

### 表结构说明

    CREATE TABLE `employees` ( 
    `emp_no` int(11) NOT NULL,
    `birth_date` date NOT NULL,
    `first_name` varchar(14) NOT NULL,
    `last_name` varchar(16) NOT NULL,
    `gender` char(1) NOT NULL,
    `hire_date` date NOT NULL,
    PRIMARY KEY (`emp_no`));

### 脚本 1
*sqlite3*

    SELECT last_name||' '||first_name AS Name FROM employees

**运行时间：***19ms*
**占用内存：***3300k*

### 脚本 2
*mysql、oracle、sql server*

    SELECT concat(last_name, " ", first_name) AS Name FROM employees


## 33、创建一个actor表，包含如下列信息

### 表结构说明

    列表          类型          是否为NULL         含义
    actor_id    smallint(5)     not null        主键id
    first_name  varchar(45)     not null        名字
    last_name   varchar(45)     not null        姓氏
    last_update timestamp       not null        最后更新时间，默认是系统的当前时间

### 脚本 1

    CREATE TABLE `actor` ( 
    `actor_id` smallint(5) NOT NULL,
    `first_name` varchar(45) NOT NULL,
    `last_name` varchar(45) NOT NULL,
    `last_update` timestamp NOT NULL default (datetime('now','localtime')),
    PRIMARY KEY (`actor_id`)
    );

**运行时间：***19ms*
**占用内存：***3292k*


## 34、对于表actor批量插入如下数据

### 表结构说明

    CREATE TABLE IF NOT EXISTS actor (
    actor_id smallint(5) NOT NULL PRIMARY KEY,
    first_name varchar(45) NOT NULL,
    last_name varchar(45) NOT NULL,
    last_update timestamp NOT NULL DEFAULT (datetime('now','localtime')))

### 数据

    actor_id    first_name  last_name   last_update
        1           PENELOPE    GUINESS     2006-02-15 12:34:33
        2           NICK        WAHLBERG    2006-02-15 12:34:33


### 脚本 1

    insert into actor values(1, 'PENELOPE', 'GUINESS', '2006-02-15 12:34:33'),(2, 'NICK', 'WAHLBERG', '2006-02-15 12:34:33');

**运行时间：***19ms*
**占用内存：***3420k*


## 35、对于表actor批量插入如下数据,如果数据已经存在，请忽略，不使用replace操作

### 表结构说明

    CREATE TABLE IF NOT EXISTS actor (
    actor_id smallint(5) NOT NULL PRIMARY KEY,
    first_name varchar(45) NOT NULL,
    last_name varchar(45) NOT NULL,
    last_update timestamp NOT NULL DEFAULT (datetime('now','localtime')))

### 数据

    actor_id    first_name  last_name   last_update
    '3'         'ED'        'CHASE'     '2006-02-15 12:34:33'


### 脚本 1

    insert or ignore into actor values(3, 'ED', 'CHASE', '2006-02-15 12:34:33');

**运行时间：***23ms*
**占用内存：***4332k*


## 36、对于表actor批量插入如下数据,如果数据已经存在，请忽略，不使用replace操作

### 表结构说明

    CREATE TABLE IF NOT EXISTS actor (
    actor_id smallint(5) NOT NULL PRIMARY KEY,
    first_name varchar(45) NOT NULL,
    last_name varchar(45) NOT NULL,
    last_update timestamp NOT NULL DEFAULT (datetime('now','localtime')))

### 数据

    actor_id    first_name  last_name   last_update
    '3'         'ED'        'CHASE'     '2006-02-15 12:34:33'


### 脚本 1

    insert or ignore into actor values(3, 'ED', 'CHASE', '2006-02-15 12:34:33');

**运行时间：***23ms*
**占用内存：***4332k*


## 37、创建一个actor_name表，将actor表中的所有first_name以及last_name导入改表。

### 对于如下表actor，其对应的数据为:

    actor_id    first_name  last_name   last_update
    1               PENELOPE    GUINESS     2006-02-15 12:34:33
    2               NICK        WAHLBERG    2006-02-15 12:34:33

### actor_name表结构如下：

    列表          类型          是否为NULL         含义
    first_name  varchar(45)     not null        名字
    last_name   varchar(45)     not null        姓氏

### 脚本 1

    create table actor_name as select first_name, last_name from actor;

**运行时间：***24ms*
**占用内存：***3424k*

### 脚本 2

    create table actor_name(
    first_name varchar(45) NOT NULL,
    last_name varchar(45) NOT NULL
    );
    insert into actor_name select first_name, last_name from actor;

**运行时间：***18ms*
**占用内存：***3292k*


## 38、针对如下表actor结构创建索引,对first_name创建唯一索引uniq_idx_firstname，对last_name创建普通索引idx_lastname

### 表结构说明

    CREATE TABLE IF NOT EXISTS actor (
    actor_id smallint(5) NOT NULL PRIMARY KEY,
    first_name varchar(45) NOT NULL,
    last_name varchar(45) NOT NULL,
    last_update timestamp NOT NULL DEFAULT (datetime('now','localtime')))

### 脚本 1

    create unique index uniq_idx_firstname on actor(first_name);
    create index idx_lastname on actor(last_name);

**运行时间：***24ms*
**占用内存：***3208k*


## 39、针对actor表创建视图actor_name_view，只包含first_name以及last_name两列，并对这两列重新命名，first_name为first_name_v，last_name修改为last_name_v

### 表结构说明

    CREATE TABLE IF NOT EXISTS actor (
    actor_id smallint(5) NOT NULL PRIMARY KEY,
    first_name varchar(45) NOT NULL,
    last_name varchar(45) NOT NULL,
    last_update timestamp NOT NULL DEFAULT (datetime('now','localtime')))

### 脚本 1

    create view actor_name_view as select first_name as first_name_v, last_name as last_name_v from actor;

**运行时间：***20ms*
**占用内存：***3296k*

### 脚本 2

    create view actor_name_view(first_name_v, last_name_v) as select first_name, last_name from actor;

**运行时间：***21ms*
**占用内存：***3428k*


## 40、针对salaries表emp_no字段创建索引idx_emp_no，查询emp_no为10005, 使用强制索引。

### 表结构说明

    CREATE TABLE `salaries` (
    `emp_no` int(11) NOT NULL,
    `salary` int(11) NOT NULL,
    `from_date` date NOT NULL,
    `to_date` date NOT NULL,
    PRIMARY KEY (`emp_no`,`from_date`));
    create index idx_emp_no on salaries(emp_no);

### 脚本 1
*sqlite3*

    select * from salaries indexed by idx_emp_no where emp_no = 10005;

**运行时间：***29ms*
**占用内存：***3428k*
**参考：***http://www.runoob.com/sqlite/sqlite-indexed-by.html*

### 脚本 2
*mysql、oracle、sql*

    select * from salaries force index idx_emp_no where emp_no = 10005

**运行时间：***21ms*
**占用内存：***3428k*
**参考：***http://www.jb51.net/article/49807.htm*


## 41、存在actor表，现在在last_update后面新增加一列名字为create_date, 类型为datetime, NOT NULL，默认值为'0000-00-00 00:00:00'

### 表结构说明

    CREATE TABLE IF NOT EXISTS actor (
    actor_id smallint(5) NOT NULL PRIMARY KEY,
    first_name varchar(45) NOT NULL,
    last_name varchar(45) NOT NULL,
    last_update timestamp NOT NULL DEFAULT (datetime('now','localtime')));

### 脚本 1

    alter table actor add create_date datetime NOT NULL default '0000-00-00 00:00:00';

**运行时间：***24ms*
**占用内存：***3312k*


## 42、构造一个触发器audit_log，在向employees_test表中插入一条数据的时候，触发插入相关的数据到audit中。

### 表结构说明

    CREATE TABLE employees_test(
    ID INT PRIMARY KEY NOT NULL,
    NAME TEXT NOT NULL,
    AGE INT NOT NULL,
    ADDRESS CHAR(50),
    SALARY REAL
    );

    CREATE TABLE audit(
    EMP_no INT NOT NULL,
    NAME TEXT NOT NULL
    );

### 脚本 1

    create trigger audit_log after insert on employees_test
    begin
        insert into audit values(new.id, new.name);
    end;

**运行时间：***22ms*
**占用内存：***3436k*


## 43、删除emp_no重复的记录，只保留最小的id对应的记录。

### 表结构说明

    CREATE TABLE IF NOT EXISTS titles_test (
    id int(11) not null primary key,
    emp_no int(11) NOT NULL,
    title varchar(50) NOT NULL,
    from_date date NOT NULL,
    to_date date DEFAULT NULL);

    insert into titles_test values ('1', '10001', 'Senior Engineer', '1986-06-26', '9999-01-01'),
    ('2', '10002', 'Staff', '1996-08-03', '9999-01-01'),
    ('3', '10003', 'Senior Engineer', '1995-12-03', '9999-01-01'),
    ('4', '10004', 'Senior Engineer', '1995-12-03', '9999-01-01'),
    ('5', '10001', 'Senior Engineer', '1986-06-26', '9999-01-01'),
    ('6', '10002', 'Staff', '1996-08-03', '9999-01-01'),
    ('7', '10003', 'Senior Engineer', '1995-12-03', '9999-01-01');

### 脚本 1

    delete from titles_test where id not in (select min(id) from titles_test group by emp_no);

**运行时间：***20ms*
**占用内存：***3320k*

### 脚本 2

    delete from titles_test 
    where id in (
        select a.id 
        from titles_test a, titles_test b 
        where a.emp_no = b.emp_no
        and a.id > b.id);

**运行时间：***22ms*
**占用内存：***3552k*


## 44、将所有to_date为9999-01-01的全部更新为NULL,且 from_date更新为2001-01-01。

### 表结构说明

    CREATE TABLE IF NOT EXISTS titles_test (
    id int(11) not null primary key,
    emp_no int(11) NOT NULL,
    title varchar(50) NOT NULL,
    from_date date NOT NULL,
    to_date date DEFAULT NULL);

    insert into titles_test values ('1', '10001', 'Senior Engineer', '1986-06-26', '9999-01-01'),
    ('2', '10002', 'Staff', '1996-08-03', '9999-01-01'),
    ('3', '10003', 'Senior Engineer', '1995-12-03', '9999-01-01'),
    ('4', '10004', 'Senior Engineer', '1995-12-03', '9999-01-01'),
    ('5', '10001', 'Senior Engineer', '1986-06-26', '9999-01-01'),
    ('6', '10002', 'Staff', '1996-08-03', '9999-01-01'),
    ('7', '10003', 'Senior Engineer', '1995-12-03', '9999-01-01');

### 脚本 1

    update titles_test set to_date = null, from_date='2001-01-01' where to_date='9999-01-01';

**运行时间：***22ms*
**占用内存：***3328k*


## 45、将id=5以及emp_no=10001的行数据替换成id=5以及emp_no=10005,其他数据保持不变，使用replace实现。

### 表结构说明

    CREATE TABLE IF NOT EXISTS titles_test (
    id int(11) not null primary key,
    emp_no int(11) NOT NULL,
    title varchar(50) NOT NULL,
    from_date date NOT NULL,
    to_date date DEFAULT NULL);

    insert into titles_test values ('1', '10001', 'Senior Engineer', '1986-06-26', '9999-01-01'),
    ('2', '10002', 'Staff', '1996-08-03', '9999-01-01'),
    ('3', '10003', 'Senior Engineer', '1995-12-03', '9999-01-01'),
    ('4', '10004', 'Senior Engineer', '1995-12-03', '9999-01-01'),
    ('5', '10001', 'Senior Engineer', '1986-06-26', '9999-01-01'),
    ('6', '10002', 'Staff', '1996-08-03', '9999-01-01'),
    ('7', '10003', 'Senior Engineer', '1995-12-03', '9999-01-01');

### 脚本 1

    replace into titles_test values('5', '10005', 'Senior Engineer', '1986-06-26', '9999-01-01');

**运行时间：***23ms*
**占用内存：***3330k*


### 脚本 2

    update titles_test set emp_no = replace(emp_no, 10001, 10005) where emp_no = 10001;

**运行时间：***21ms*
**占用内存：***3304k*


## 45、将titles_test表名修改为titles_2017。

### 表结构说明

    CREATE TABLE IF NOT EXISTS titles_test (
    id int(11) not null primary key,
    emp_no int(11) NOT NULL,
    title varchar(50) NOT NULL,
    from_date date NOT NULL,
    to_date date DEFAULT NULL);

    insert into titles_test values ('1', '10001', 'Senior Engineer', '1986-06-26', '9999-01-01'),
    ('2', '10002', 'Staff', '1996-08-03', '9999-01-01'),
    ('3', '10003', 'Senior Engineer', '1995-12-03', '9999-01-01'),
    ('4', '10004', 'Senior Engineer', '1995-12-03', '9999-01-01'),
    ('5', '10001', 'Senior Engineer', '1986-06-26', '9999-01-01'),
    ('6', '10002', 'Staff', '1996-08-03', '9999-01-01'),
    ('7', '10003', 'Senior Engineer', '1995-12-03', '9999-01-01');

### 脚本 1

    alter table titles_test rename to titles_2017;

**运行时间：***18ms*
**占用内存：***3192k*


### 脚本 2
*mysql、oracle、sql*

    rename table titles_test to titles_2017;

**运行时间：***21ms*
**占用内存：***3304k*


## 45、在audit表上创建外键约束，其emp_no对应employees_test表的主键id。

### 表结构说明

    CREATE TABLE employees_test(
    ID INT PRIMARY KEY NOT NULL,
    NAME TEXT NOT NULL,
    AGE INT NOT NULL,
    ADDRESS CHAR(50),
    SALARY REAL
    );

    CREATE TABLE audit(
    EMP_no INT NOT NULL,
    create_date datetime NOT NULL
    );

### 脚本 1

    DROP TABLE audit;
    CREATE TABLE audit(
        EMP_no INT NOT NULL,
        create_date datetime NOT NULL,
        FOREIGN KEY(EMP_no) REFERENCES employees_test(ID));

**运行时间：***20ms*
**占用内存：***3568k*


## 46、如何获取emp_v和employees有相同的数据？

### 表结构说明

    create view emp_v as select * from employees where emp_no >10005;

    CREATE TABLE `employees` (
    `emp_no` int(11) NOT NULL,
    `birth_date` date NOT NULL,
    `first_name` varchar(14) NOT NULL,
    `last_name` varchar(16) NOT NULL,
    `gender` char(1) NOT NULL,
    `hire_date` date NOT NULL,
    PRIMARY KEY (`emp_no`));

### 脚本 1

    select em.* from employees em, emp_v ev where em.emp_no = ev.emp_no;

**运行时间：***18ms*
**占用内存：***3312k*

### 脚本 2

    select * from employees intersect select * from emp_v;

**运行时间：***23ms*
**占用内存：***3552k*


### 脚本 3

    select * from emp_v;

**运行时间：***22ms*
**占用内存：***3300k*


## 47、将所有获取奖金的员工当前的薪水增加10%。

### 表结构说明

    create table emp_bonus(
    `emp_no` int not null,
    `recevied` datetime not null,
    `btype` smallint not null);

    CREATE TABLE `salaries` (
    `emp_no` int(11) NOT NULL,
    `salary` int(11) NOT NULL,
    `from_date` date NOT NULL,
    `to_date` date NOT NULL, PRIMARY KEY (`emp_no`,`from_date`));

### 脚本 1

    update salaries set salary = salary * 1.1 where emp_no in (select emp_no from emp_bonus);

**运行时间：***24ms*
**占用内存：***3412k*



## 48、针对库中的所有表生成select count(*)对应的SQL语句

### 表结构说明

    CREATE TABLE `employees` (
    `emp_no` int(11) NOT NULL,
    `birth_date` date NOT NULL,
    `first_name` varchar(14) NOT NULL,
    `last_name` varchar(16) NOT NULL,
    `gender` char(1) NOT NULL,
    `hire_date` date NOT NULL,
    PRIMARY KEY (`emp_no`));

    create table emp_bonus(
    `emp_no` int not null,
    `recevied` datetime not null,
    `btype` smallint not null);

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

    CREATE TABLE `salaries` (
    `emp_no` int(11) NOT NULL,
    `salary` int(11) NOT NULL,
    `from_date` date NOT NULL,
    `to_date` date NOT NULL,
    PRIMARY KEY (`emp_no`,`from_date`));

### 脚本 1

    select "select count(*) from "||name||";" as cnts 
    from sqlite_master
    where type='table'

**运行时间：***23ms*
**占用内存：***3420k*


## 49、将employees表中的所有员工的last_name和first_name通过(')连接起来

### 表结构说明

    CREATE TABLE `employees` (
    `emp_no` int(11) NOT NULL,
    `birth_date` date NOT NULL,
    `first_name` varchar(14) NOT NULL,
    `last_name` varchar(16) NOT NULL,
    `gender` char(1) NOT NULL,
    `hire_date` date NOT NULL,
    PRIMARY KEY (`emp_no`));

### 脚本 1

    select last_name||"'"||first_name from employees;

**运行时间：***25ms*
**占用内存：***3320k*


## 49、将employees表中的所有员工的last_name和first_name通过(')连接起来

### 表结构说明

    CREATE TABLE `employees` (
    `emp_no` int(11) NOT NULL,
    `birth_date` date NOT NULL,
    `first_name` varchar(14) NOT NULL,
    `last_name` varchar(16) NOT NULL,
    `gender` char(1) NOT NULL,
    `hire_date` date NOT NULL,
    PRIMARY KEY (`emp_no`));

### 脚本 1

    select last_name||"'"||first_name from employees;

**运行时间：***25ms*
**占用内存：***3320k*

### 脚本 2

    select concat(last_name, "'", first_name) from employees;

**运行时间：***25ms*
**占用内存：***3320k*


## 50、查找字符串'10,A,B' 中逗号','出现的次数cnt。

### 脚本 1

    select (length('10,A,B') - length(replace('10,A,B', ',', ''))) / length(',') as cnt;

**运行时间：***19ms*
**占用内存：***3292k*


## 51、获取Employees中的first_name，查询按照first_name最后两个字母，按照升序进行排列

### 表结构说明

    CREATE TABLE `employees` (
    `emp_no` int(11) NOT NULL,
    `birth_date` date NOT NULL,
    `first_name` varchar(14) NOT NULL,
    `last_name` varchar(16) NOT NULL,
    `gender` char(1) NOT NULL,
    `hire_date` date NOT NULL,
    PRIMARY KEY (`emp_no`));

### 脚本 1

    select first_name from employees order by substr(first_name, -2)

**运行时间：***14ms*
**占用内存：***3296k*

### 脚本 2

    select first_name from employees order by substr(first_name, length(first_name) - 1)

**运行时间：***15ms*
**占用内存：***3296k*


## 52、按照dept_no进行汇总，属于同一个部门的emp_no按照逗号进行连接，结果给出dept_no以及连接出的结果employees

### 表结构说明

    CREATE TABLE `dept_emp` (
    `emp_no` int(11) NOT NULL,
    `dept_no` char(4) NOT NULL,
    `from_date` date NOT NULL,
    `to_date` date NOT NULL,
    PRIMARY KEY (`emp_no`,`dept_no`));

### 脚本 1

    select dept_no, group_concat(emp_no) as employees from dept_emp group by dept_no;

**运行时间：***14ms*
**占用内存：***3308k*


## 53、查找排除当前最大、最小salary之后的员工的平均工资avg_salary。

### 表结构说明

    CREATE TABLE `salaries` ( 
    `emp_no` int(11) NOT NULL,
    `salary` int(11) NOT NULL,
    `from_date` date NOT NULL,
    `to_date` date NOT NULL,
    PRIMARY KEY (`emp_no`,`from_date`));

### 脚本 1

    select avg(salary) as avg_salary
    from salaries 
    where to_date='9999-01-01' 
    and salary not in (select min(salary) from salaries)
    and salary not in (select max(salary) from salaries);

**运行时间：***21ms*
**占用内存：***3408k*
**备注：***这个居然通过了，应该是下面的那个带有日期的才是正确的*

### 脚本 2

    select avg(salary) as avg_salary
    from salaries 
    where to_date='9999-01-01' 
    and salary not in (select min(salary) from salaries where to_date='9999-01-01')
    and salary not in (select max(salary) from salaries where to_date='9999-01-01');

**运行时间：***21ms*
**占用内存：***3408k*
**备注：***这个居然没有通过*

## 54、分页查询employees表，每5行一页，返回第2页的数据

### 表结构说明

    CREATE TABLE `employees` (
    `emp_no` int(11) NOT NULL,
    `birth_date` date NOT NULL,
    `first_name` varchar(14) NOT NULL,
    `last_name` varchar(16) NOT NULL,
    `gender` char(1) NOT NULL,
    `hire_date` date NOT NULL,
    PRIMARY KEY (`emp_no`));

### 脚本 1

    select * from employees limit(2-1)*5, 5;

**运行时间：***15ms*
**占用内存：***3292k*


## 55、获取所有员工的emp_no、部门编号dept_no以及对应的bonus类型btype和recevied，没有分配具体的员工不显示

### 表结构说明

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

    create table emp_bonus(
    `emp_no` int not null,
    `recevied` datetime not null,
    `btype` smallint not null);

### 脚本 1

    select e.emp_no, de.dept_no, b.btype, b.recevied
    from employees e
    inner join dept_emp de on de.emp_no = e.emp_no
    left join emp_bonus as b on b.emp_no  = e.emp_no;
    

**运行时间：***28ms*
**占用内存：***3404k*

### 脚本 2

    select de.emp_no, de.dept_no, b.btype, b.recevied
    from dept_emp de
    left join emp_bonus as b on b.emp_no  = de.emp_no;
    

**运行时间：***20ms*
**占用内存：***3424k*


## 56、使用含有关键字exists查找未分配具体部门的员工的所有信息

### 表结构说明

    CREATE TABLE `employees` (
    `emp_no` int(11) NOT NULL,
    `birth_date` date NOT NULL,
    `first_name` varchar(14) NOT NULL,
    `last_name` varchar(16) NOT NULL,
    `gender` char(1) NOT NULL,
    `hire_date` date NOT NULL,
    PRIMARY KEY (`emp_no`));

    CREATE TABLE `dept_emp` (
    `emp_no` int(11) NOT NULL,
    `dept_no` char(4) NOT NULL,
    `from_date` date NOT NULL,
    `to_date` date NOT NULL,
    PRIMARY KEY (`emp_no`,`dept_no`));

### 脚本 1

    select *
    from employees e
    where not exists (select emp_no from dept_emp de where e.emp_no=de.emp_no);
    
    

**运行时间：***20ms*
**占用内存：***3300k*


## 57、获取employees中的行数据，且这些行也存在于emp_v中。注意不能使用intersect关键字

### 表结构说明

    create view emp_v as select * from employees where emp_no >10005;

    CREATE TABLE `employees` (
    `emp_no` int(11) NOT NULL,
    `birth_date` date NOT NULL,
    `first_name` varchar(14) NOT NULL,
    `last_name` varchar(16) NOT NULL,
    `gender` char(1) NOT NULL,
    `hire_date` date NOT NULL,
    PRIMARY KEY (`emp_no`));

### 脚本 1

    select e.* from employees e, emp_v ev where ev.emp_no = e.emp_no;

**运行时间：***22ms*
**占用内存：***3288k*


## 58、给出emp_no、first_name、last_name、奖金类型btype、对应的当前薪水情况salary以及奖金金额bonus
*bonus类型btype为1其奖金为薪水salary的10%，btype为2其奖金为薪水的20%，其他类型均为薪水的30%。 当前薪水表示to_date='9999-01-01'*

### 表结构说明

    CREATE TABLE `employees` (
    `emp_no` int(11) NOT NULL,
    `birth_date` date NOT NULL,
    `first_name` varchar(14) NOT NULL,
    `last_name` varchar(16) NOT NULL,
    `gender` char(1) NOT NULL,
    `hire_date` date NOT NULL,
    PRIMARY KEY (`emp_no`));

    CREATE TABLE `dept_emp` (
    `emp_no` int(11) NOT NULL,
    `dept_no` char(4) NOT NULL,
    `from_date` date NOT NULL,
    `to_date` date NOT NULL,
    PRIMARY KEY (`emp_no`,`dept_no`));

    create table emp_bonus(
    emp_no int not null,
    recevied datetime not null,
    btype smallint not null);

    CREATE TABLE `salaries` (
    `emp_no` int(11) NOT NULL,
    `salary` int(11) NOT NULL,
    `from_date` date NOT NULL,
    `to_date` date NOT NULL, PRIMARY KEY (`emp_no`,`from_date`));

### 脚本 1

    select e.emp_no, e.first_name, e.last_name, b.btype, s.salary, (
        case b.btype
        when 1 then s.salary * 0.1
        when 2 then s.salary * 0.2
        else s.salary * 0.3 end) as bonus
    from employees e
    inner join salaries s on s.emp_no = e.emp_no and s.to_date='9999-01-01'
    inner join emp_bonus b on b.emp_no = e.emp_no;


**运行时间：***28ms*
**占用内存：***3300k*


## 59、按照salary的累计和running_total，其中running_total为前两个员工的salary累计和，其他以此类推

### 表结构说明

    CREATE TABLE `salaries` ( `emp_no` int(11) NOT NULL,
    `salary` int(11) NOT NULL,
    `from_date` date NOT NULL,
    `to_date` date NOT NULL,
    PRIMARY KEY (`emp_no`,`from_date`));

### 脚本 1

    select s1.emp_no, s1.salary, (
        select sum(s2.salary) 
        from salaries s2
        where s2.emp_no <= s1.emp_no 
        and s2.to_date='9999-01-01'
        ) as running_total 
    from salaries as s1
    where s1.to_date='9999-01-01'
    order by s1.emp_no;

**运行时间：***25ms*
**占用内存：***3296k*

### 脚本 2

    select s.emp_no,s.salary,(
        select sum(salary) 
        from salaries 
        where rowid<=s.rowid 
        and to_date ="9999-01-01") as running_total 
    from salaries s where s.to_date ="9999-01-01"

**运行时间：***25ms*
**占用内存：***3424k*


## 60、对于employees表中，在对first_name进行排名后，选出奇数排名对应的first_name

### 表结构说明

    CREATE TABLE `employees` (
    `emp_no` int(11) NOT NULL,
    `birth_date` date NOT NULL,
    `first_name` varchar(14) NOT NULL,
    `last_name` varchar(16) NOT NULL,
    `gender` char(1) NOT NULL,
    `hire_date` date NOT NULL,
    PRIMARY KEY (`emp_no`));

### 脚本 1

    select e1.first_name
    from (
        select e2.first_name,(
            select count(*) 
            from employees as e3
            where e3.first_name <= e2.first_name) as rowid
        from employees as e2) as e1
    where e1.rowid % 2 = 1;

**运行时间：***21ms*
**占用内存：***3196k*

### 脚本 2

    select e1.first_name
    from employees e1
    where (select count(*) 
           from employees e2
           where e1.first_name <= e2.first_name) % 2 = 1;

**运行时间：***20ms*
**占用内存：***3292k*
