/* Delete the tables if they already exist */
drop table if exists Highschooler;
drop table if exists Friend;
drop table if exists Likes;

/* Create the schema for our tables */
create table Highschooler(ID int, name text, grade int);
create table Friend(ID1 int, ID2 int);
create table Likes(ID1 int, ID2 int);

/* Populate the tables with our data */
insert into Highschooler values (1510, 'Jordan', 9);
insert into Highschooler values (1689, 'Gabriel', 9);
insert into Highschooler values (1381, 'Tiffany', 9);
insert into Highschooler values (1709, 'Cassandra', 9);
insert into Highschooler values (1101, 'Haley', 10);
insert into Highschooler values (1782, 'Andrew', 10);
insert into Highschooler values (1468, 'Kris', 10);
insert into Highschooler values (1641, 'Brittany', 10);
insert into Highschooler values (1247, 'Alexis', 11);
insert into Highschooler values (1316, 'Austin', 11);
insert into Highschooler values (1911, 'Gabriel', 11);
insert into Highschooler values (1501, 'Jessica', 11);
insert into Highschooler values (1304, 'Jordan', 12);
insert into Highschooler values (1025, 'John', 12);
insert into Highschooler values (1934, 'Kyle', 12);
insert into Highschooler values (1661, 'Logan', 12);

insert into Friend values (1510, 1381);
insert into Friend values (1510, 1689);
insert into Friend values (1689, 1709);
insert into Friend values (1381, 1247);
insert into Friend values (1709, 1247);
insert into Friend values (1689, 1782);
insert into Friend values (1782, 1468);
insert into Friend values (1782, 1316);
insert into Friend values (1782, 1304);
insert into Friend values (1468, 1101);
insert into Friend values (1468, 1641);
insert into Friend values (1101, 1641);
insert into Friend values (1247, 1911);
insert into Friend values (1247, 1501);
insert into Friend values (1911, 1501);
insert into Friend values (1501, 1934);
insert into Friend values (1316, 1934);
insert into Friend values (1934, 1304);
insert into Friend values (1304, 1661);
insert into Friend values (1661, 1025);
insert into Friend select ID2, ID1 from Friend;

insert into Likes values(1689, 1709);
insert into Likes values(1709, 1689);
insert into Likes values(1782, 1709);
insert into Likes values(1911, 1247);
insert into Likes values(1247, 1468);
insert into Likes values(1641, 1468);
insert into Likes values(1316, 1304);
insert into Likes values(1501, 1934);
insert into Likes values(1934, 1501);
insert into Likes values(1025, 1101);

-- Q1: It's time for the seniors to graduate. Remove all 12th graders from Highschooler.
delete
from Highschooler
where grade = 12;

-- Q2: If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple.
delete from Likes
where ID2 in (select ID2 from Friend where Likes.ID1 = ID1) and
      ID2 not in (select L.ID1 from Likes L where Likes.ID1 = L.ID2);

-- Q3: For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself.
insert into Friend
select distinct F1.ID1, F2.ID2
from Friend F1, Friend F2
where F1.ID2 = F2.ID1 and F1.ID1<>F2.ID2 and F1.ID1 not in (select F3.ID1 from Friend F3 where F3.ID2=F2.ID2);

-- Q1: Find the names of all students who are friends with someone named Gabriel. 
select name
from Highschooler
where ID in (select ID1 from Friend where ID2 in (select H1.ID from Highschooler H1 where name = 'Gabriel'))
      or ID in (select ID2 from Friend where ID1 in (select H2.ID from Highschooler H2 where name = 'Gabriel'));

-- Q2: For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like.
select H1.name, H1.grade, H2.name, H2.grade
from Highschooler H1, Highschooler H2
where H1.ID in (select ID1 from LIkes)
      and H2.ID in (select ID2 from LIkes where ID1=H1.ID)
      and H1.grade-H2.grade >= 2;

select H1.name, H1.grade, H2.name, H2.grade
from Highschooler H1, Highschooler H2, LIkes
where H1.ID = ID1
      and H2.ID = ID2
      and H1.grade-H2.grade >= 2;

-- Q3: For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order. 
select distinct H1.name, H1.grade, H2.name, H2.grade
from Highschooler H1, Highschooler H2
where H1.ID in (select L1.ID1 from Likes L1 where L1.ID2= H2.ID)
      and H2.ID in (select L2.ID1 from Likes L2 where L2.ID2=H1.ID)
	  and H1.name < H2.name; -- trick: use compare to avoid duplicate

-- Q4: Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade. 
select name, grade
from Highschooler
where ID not in (select ID1 from Highschooler H1, Highschooler H2, Friend
                 where H1.ID=Friend.ID1 and H2.ID=Friend.ID2 and H1.grade<>H2.grade)
                 order by grade, name;

-- Q5: Find the name and grade of all students who are liked by more than one other student. 
select distinct name, grade
from Highschooler
where ID in (select ID2 from Likes
		     group by ID2 having count(ID2) > 1);
