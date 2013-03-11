/* Q1: Write a trigger that makes new students named 'Friendly' automatically like everyone else in their grade. That is, after the trigger runs, we should have ('Friendly', A) in the Likes table for every other Highschooler A in the same grade as 'Friendly'.*/
create trigger R1
before insert on Highschooler
for each row
when  New.name="Friendly"
begin
  insert into Likes 
  select New.ID,ID from Highschooler where grade = New.grade ;
end;

/* Q2: Write one or more triggers to manage the grade attribute of new Highschoolers. If the inserted tuple has a value less than 9 or greater than 12, change the value to NULL. On the other hand, if the inserted tuple has a null value for grade, change it to 9.*/
create trigger R2
after insert on Highschooler
for each row
when  (New.grade is null)
begin
  update Highschooler set grade=9 where ID=New.ID;
end;
|
create trigger R1
after insert on Highschooler
for each row
when  (New.grade <9 or New.grade >12)
begin
  update Highschooler set grade=null where ID=New.ID;
end;

/* Q3: Write a trigger that automatically deletes students when they graduate, i.e., when their grade is updated to exceed 12.*/
create trigger R1
after update on Highschooler
for each row
begin
  delete from Highschooler where grade >12;
end;
