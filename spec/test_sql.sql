CREATE DATABASE good_database;
use good_database;
create table table_a (a int, b int);
create table `table b` (a int, b int);
insert into table_a VALUES (1,2);
insert into `table b` VALUES (2,2);
  
  
CREATE DATABASE other_good_database;
use other_good_database;
create table table_a (a int, b int);
create table `table b` (a int, b int);
create table `table c` (a int, b int);

insert into `table_a` VALUES(2,2);
insert into `table b` VALUES (4,4);