use data_analysis;
-- CREATE TABLE users (
--     USER_ID INT PRIMARY KEY,
--     USER_NAME VARCHAR(20) NOT NULL,
--     USER_STATUS VARCHAR(20) NOT NULL
-- );

-- CREATE TABLE logins (
--     USER_ID INT,
--     LOGIN_TIMESTAMP DATETIME NOT NULL,
--     SESSION_ID INT PRIMARY KEY,
--     SESSION_SCORE INT,
--     FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID)
-- );

-- -- Users Table
-- INSERT INTO USERS VALUES (1, 'Alice', 'Active');
-- INSERT INTO USERS VALUES (2, 'Bob', 'Inactive');
-- INSERT INTO USERS VALUES (3, 'Charlie', 'Active');
-- INSERT INTO USERS  VALUES (4, 'David', 'Active');
-- INSERT INTO USERS  VALUES (5, 'Eve', 'Inactive');
-- INSERT INTO USERS  VALUES (6, 'Frank', 'Active');
-- INSERT INTO USERS  VALUES (7, 'Grace', 'Inactive');
-- INSERT INTO USERS  VALUES (8, 'Heidi', 'Active');
-- INSERT INTO USERS VALUES (9, 'Ivan', 'Inactive');
-- INSERT INTO USERS VALUES (10, 'Judy', 'Active');

-- -- Logins Table 

-- INSERT INTO LOGINS  VALUES (1, '2023-07-15 09:30:00', 1001, 85);
-- INSERT INTO LOGINS VALUES (2, '2023-07-22 10:00:00', 1002, 90);
-- INSERT INTO LOGINS VALUES (3, '2023-08-10 11:15:00', 1003, 75);
-- INSERT INTO LOGINS VALUES (4, '2023-08-20 14:00:00', 1004, 88);
-- INSERT INTO LOGINS  VALUES (5, '2023-09-05 16:45:00', 1005, 82);

-- INSERT INTO LOGINS  VALUES (6, '2023-10-12 08:30:00', 1006, 77);
-- INSERT INTO LOGINS  VALUES (7, '2023-11-18 09:00:00', 1007, 81);
-- INSERT INTO LOGINS VALUES (8, '2023-12-01 10:30:00', 1008, 84);
-- INSERT INTO LOGINS  VALUES (9, '2023-12-15 13:15:00', 1009, 79);


-- -- 2024 Q1
-- INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (1, '2024-01-10 07:45:00', 1011, 86);
-- INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (2, '2024-01-25 09:30:00', 1012, 89);
-- INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (3, '2024-02-05 11:00:00', 1013, 78);
-- INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (4, '2024-03-01 14:30:00', 1014, 91);
-- INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (5, '2024-03-15 16:00:00', 1015, 83);

-- INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (6, '2024-04-12 08:00:00', 1016, 80);
-- INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (7, '2024-05-18 09:15:00', 1017, 82);
-- INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (8, '2024-05-28 10:45:00', 1018, 87);
-- INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (9, '2024-06-15 13:30:00', 1019, 76);
-- INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (10, '2024-06-25 15:00:00', 1010, 92);
-- INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (10, '2024-06-26 15:45:00', 1020, 93);
-- INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (10, '2024-06-27 15:00:00', 1021, 92);
-- INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (10, '2024-06-28 15:45:00', 1022, 93);
-- INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (1, '2024-01-10 07:45:00', 1101, 86);
-- INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (3, '2024-01-25 09:30:00', 1102, 89);
-- INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (5, '2024-01-15 11:00:00', 1103, 78);
-- INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (2, '2023-11-10 07:45:00', 1201, 82);
-- INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (4, '2023-11-25 09:30:00', 1202, 84);
-- INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (6, '2023-11-15 11:00:00', 1203, 80);

-- select * from users;
-- select *,
-- quarter(login_timestamp) as q
--  from logins
-- order by q
-- ;

-- calculate how many users and how many sessions were at each quarter order by quarter, from newest to oldest 

-- select count(distinct user_id) as users, count(session_id) as sessions,
-- quarter(login_timestamp) as q
--  from logins
--  group by quarter(login_timestamp)
-- order by q ;

-- display user id's that login on jan 2024 and didnot login on nov 2023 
-- select distinct user_id from logins where login_timestamp between '2024-01-01' and '2024-01-31'
-- and user_id not in (
-- select distinct user_id from logins where login_timestamp between '2023-11-01' and '2023-11-30'
-- )

-- prev session count, perc
-- with cte as(
-- select 
-- MAKEDATE(YEAR(MIN(login_timestamp)), 1) 
--     + INTERVAL QUARTER(MIN(login_timestamp))*3 - 3 MONTH AS first_qdate,
-- count(distinct user_id) as users, count(session_id) as sessions,
-- quarter(login_timestamp) as q
--  from logins
--  group by quarter(login_timestamp)
-- )
-- select *,
-- lag(sessions,1) over (order by first_qdate) as prev_session_count,
-- (sessions - (lag(sessions,1) over (order by first_qdate)) )*100/ (lag(sessions,1) over (order by first_qdate)	 ) as perc
-- from cte;

-- display the user that had the highest session score for each day
-- date username score 
-- select date(l.login_timestamp),u.user_name,sum(l.session_score) as score
-- from logins l
-- join users u
-- on l.user_id = u.user_id
-- group by u.user_name, date(l.login_timestamp) 
-- order by date(l.login_timestamp) ;

-- on what dates there were no login at all
WITH RECURSIVE date_series AS (
  SELECT MIN(DATE(login_timestamp)) AS firstt,
         MAX(DATE(login_timestamp)) AS lastt
  FROM logins

  UNION ALL

  SELECT DATE_ADD(firstt, INTERVAL 1 DAY),lastt
  FROM date_series
  WHERE firstt < lastt
)
select firstt from date_series
where firstt not in (select
date(login_timestamp) as firstt
from logins
)



