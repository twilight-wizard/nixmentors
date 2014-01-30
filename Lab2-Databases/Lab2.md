<!---
   Copyright 2014 Portland State University

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
--->

Lab 2: Web Services and Databases
=================================

install postgres
----------------

    sudo apt-get install postgresql

Result:
 - psql
 - postgres user
 - service running

Configuring Postgres
--------------------

### Configuration Files

 /etc/postgresql/9.1/main/postgresql.conf
 - Main configuration file
 - Set log level, log location, logging configuration
 - change port number it runs on

 /etc/postgresql/9.1/main/pg_hba.conf
 - Client authentication file
 - Who can connect and from where

#### Exercises

 - Following the guides in the comments of postgresql.conf, change the logging destination
 - Following the guides in the comments of pg_hba.conf, allow your database to accept connections from 131.252.0.0/16. Then connect to it from another host.

### Command line administration

Use psql to get into the postgresql command line interface.

#### help commands
   - \? and \h

#### getting information about your system
   - \dS shows all the possible databases you have access to, including all of the ones that postgres keeps for itself
   - \d <database name> describes what kinds of values are in the database
   - \dfS describes all the functions available to you
   - info functions: http://www.postgresql.org/docs/9.2/static/functions-info.html
   - administrative functions: http://www.postgresql.org/docs/9.2/static/functions-admin.html
   - variables: everything set in your configuration file is available as a variable in psql

#### Try It
   - select * from pg_database;
   - select * from pg_stat_activity;
   - select * from current_database;
   - show all;


SQL
---
   * Note: convention is to use all caps for keywords, especially in programming. When using psql you can be lazy.

### Basic SQL

   - Relational databases use tables to store their information.
   - Tables have columns and rows.
   - Columns have data types, the same way variables in programming languages have data types. Some common data types are varchar(number), which is like string with a max length, integer, and boolean. Postgres has many possible data types.
   - Usually tables have primary keys. This is a column that will have a unique value for every row.

#### Exercises

 - create a database
     create database <databasename>;
   - example database: star_trek
 - create a user
     create user <username>;
 - grant full admin on the database to the user
     grant all privileges on <databasename> to <username>
 - connect as the user
     psql -U <username>
 - change your password
ter role <user> with password '<password>';
 - create a table
   - example table: characters(name varchar(30) primary key, rank varchar(20), position varchar(20), series varchar(50), actor varchar(30), age integer, appears_across_series boolean);
 - look at your table's schema (use \d)
 - select everything in the table (it will be empty)
     select * from <tablename>;
 - insert a character into the table
   - remember to use single quotes!
   - example character: 'William Riker', 'Commander', 'First Officer', 'The Next Generation', 'Jonathan Frakes', 30, true
   - if you're giving every field, in the order you see when you look at the table schema, the syntax is
       insert into <tablename> values(<list of values);
   - if you're only inserting some of the fields, leaving others blank, or inserting in a random order, the syntax is
       insert into <tablename> (<list of fields) values(<list of values in the same order as the fields);
 - select everything from the table again
 - select only names from the table
 - select only ranks or series from the table (what happens if you have multiple characters with the same rank or from the same series?)

#### Advanced SQL

oshi we made Geordi a Lieutenant Commander and Data a Lt. Commander, but aren't they the same rank?

In addition to restricting columns to be a certain data type, you can put other constraints on your columns. 

What we often do is separate these concerns into separate tables. This prevents us from misspelling things, reduces repetition of identical values, and organizes our data into logical modules. We use foreign keys to tell postgres that the data in a particular column is referring to a row of another table.

#### Exercises

   - Option 1: add constraints
       alter table star_trek_characters add constraint rank_constraint check (rank = 'Lt. Commander' OR rank = 'Captain' OR rank = 'Commander' [...]);
   - Option 2: separate values that have order into a different table
     - create the new table with two columns, id (primary key) and rank
     - insert all your ranks with corresponding ids
     - change your characters table to have the rank column use the integer data type with the ranks table as a foreign key
        - best to drop the old column and recreate with new data type and foreign key constraint
            alter table characters drop column rank;
            alter table characters add column rank_id integer references rank(id);

   - Challenge: Experiment with different constraints. Maybe set a minimum age for characters (who needs Wesley anyways).
   - Challenge: Create another refere 


### Backing Up Databases

Star Trek characters are critical to our infrastructure, so they need to be backed up.
The pg_dump command takes all of the stuff stored in a single database and puts it into a file, so you can copy it to other servers (for example). 
Use psql to import the file into a database.
pg_dump only gets the data from one database. It doesn't get things like roles. pg_dumpall can get all the databases in postgres along with any roles. You can use pg_restore to restore from a pg_dumpall.

#### Exercises

 - Back up your database
     pg_dump <databasename> > backup.sql
 - Drop your database
     echo "drop database <databasename> | psql
 - Restore it
     psql <databasename> < backup.sql
 - yay!

Homework: activate your postgres and mysql accounts in crack, create some tables, write a web app that queries them, show krinkle
