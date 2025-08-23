use data_analysis;

-- ---------------------------------- DATA CLEANING --------------------------------------------------

-- select * from netflix;
-- select * from netflix order by title;
-- drop table netflix;

-- create table netflix(
-- show_id varchar(10) primary key,
-- type varchar(10),
-- title nvarchar(200),
-- director varchar(250),
-- cast varchar(1000),
-- country varchar(150),
-- date_added varchar(20),
-- release_year int,
-- rating varchar(10),
-- duration varchar(10),
-- listed_in varchar(100),
-- description varchar(500)
-- );
	
-- select * from netflix where show_id='s5023';

-- select show_id, count(*) from netflix  group by show_id having count(*)>1;
-- select title, count(*) from netflix  group by title having count(*)>1;

-- identifying duplicates on the basis of title and type 
-- with cte as(
-- select *,
-- row_number() over (partition by title,type order by title) as rn
-- from netflix
-- )
-- select count(*) from cte where rn=1;

-- new table for listed_in,director, country, duration columns
-- with recursive cte as (
-- 	select show_id,
--     trim(substring_index(director,',',1)) as director,
--     substring(director,length(substring_index(director,',',1))+2) as rest
--     from netflix
--     
--     union all
--     select show_id,
--     trim(substring_index(rest,',',1)),
--     substring(rest,length(substring_index(rest,',',1))+2)
--     from cte 
--     where rest <> ''

-- )

-- select show_id, director from cte where director <> '';



-- creating a stored procedure to
-- make separate tables for  netflix_director, netflix_cast, netflix_country, netflix_genre

-- delimiter $$
-- create procedure split_netflix_columns()
-- begin
-- -- drop tables if exist
-- drop table if exists netflix_director;
-- drop table if exists netflix_cast;
-- drop table if exists netflix_country;
-- drop table if exists netflix_genre; 

-- -- create tables
-- -- 1. netflix_director 
-- create table netflix_director as 
-- 	with recursive cte as (
-- 		select show_id,
--         trim(substring_index(director,',',1)) as director,
--         substring(director,length(substring_index(director,',',1))+2) as rest
--         from netflix
--     union all
-- 		select show_id,
--         trim(substring_index(rest,',',1)),
--         substring(rest,length(substring_index(rest,',',1))+2)
-- 		from cte 
--         where rest <> ''
-- 	)
-- 	select show_id, director from cte where director <> '';
--     
-- -- 2. netflix_cast
-- create table netflix_cast as 
-- 	with recursive cte as (
-- 		select show_id,
--         trim(substring_index(cast,',',1)) as cast,
--         substring(cast, length(substring_index(cast,',',1))+2) as rest
--         from netflix
--         union all
--         select show_id,
--         trim(substring_index(rest,',',1)),
--         substring(rest, length(substring_index(rest,',',1))+2)
--         from cte 
--         where cast <> ''
--     ) 
--     select show_id, cast from cte where cast <> '';
--     
-- -- 3. netflix_country
-- create table netflix_country as 
-- 	with recursive cte as (
-- 		select show_id,
--         trim(substring_index(country,',',1)) as country,
--         substring(country,length(substring_index(country,',',1))+2) as rest
--         from netflix
--         union all
--         select show_id,
--         trim(substring_index(rest,',',1)),
--         substring(rest, length(substring_index(rest,',',1))+2)
--         from cte
--         where rest <> ''    
--     )
--     select show_id, country from cte where country <> '';
--     
-- -- 4. netflix_genre
-- create table netflix_genre as 
-- 	with recursive cte as (
-- 		select show_id,
--         trim(substring_index(listed_in,',',1)) as genre,
--         substring(listed_in,length(substring_index(listed_in,',',1))+2) as rest
--         from netflix
--         union all
--         select show_id,
--         trim(substring_index(rest,',',1)),
--         substring(rest, length(substring_index(rest,',',1))+2)
--         from cte 
--         where rest <> ''    
--     )
--     select show_id,genre from cte where genre <> '';
-- end
-- $$
-- delimiter ;

-- call split_netflix_columns();

-- data type conversion for date added; 
-- CREATE TABLE final_netflix (
--   show_id VARCHAR(20),
--   type VARCHAR(20),
--   title VARCHAR(255),
--   date_added DATE,
--   release_year INT,
--   rating VARCHAR(20),
--   duration VARCHAR(50),
--   description TEXT
-- );
--  with cte as (
-- 	select *,
-- 	row_number() over (partition by title, type order by show_id) as rn
--     from netflix
-- )
-- select show_id,type,title,cast(date_added as date) as date_added, release_year,rating,
-- case when duration is null then rating else duration end as duration , description
-- from cte;

-- CREATE TABLE final_netflix AS
-- SELECT show_id,
--        type,
--        title,
--        STR_TO_DATE(date_added, '%M %e, %Y') AS date_added,
--        release_year,
--        rating,
--        CASE 
--          WHEN duration IS NULL THEN rating 
--          ELSE duration 
--        END AS duration,
--        description
-- FROM (
--     SELECT *,
--            ROW_NUMBER() OVER (PARTITION BY title, type ORDER BY show_id) AS rn
--     FROM netflix
-- ) AS cte

-- select * from final_netflix;

-- populate null values in country based on director
-- insert into netflix_country
-- select show_id, s.country
-- from netflix n
-- join (
-- select c.country, d.director
-- from netflix_country c
-- join netflix_director d
-- on c.show_id = d.show_id
-- group by d.director, c.country
-- ) s
-- on n.director=s.director
-- where n.country is null


-- duration column
-- select * from netflix where duration is null; 


-- ---------------------------------- DATA ANALYSIS --------------------------------------------------

-- 1. FOR EACH DIRECTOR COUNT THE NO OF MOVIES AND TV SHOWS CREATED BY THEM IN SEPARATE COLUMNS
-- FOR DIRECTORS WHO HAVE CREATED TV SHOWS AND MOVIES BOTH

-- select nd.director,
-- count(case when type='Movie' then fn.show_id end) as movie,
-- count(case when type='TV Show' then fn.show_id end) as tv_shows
-- from netflix_director nd 
-- join final_netflix fn on nd.show_id = fn.show_id
-- group by nd.director
-- having count(distinct fn.type) > 1

-- which country has highest no of comedy movies
-- select c.country, count(distinct case when g.genre='Comedies' and fn.type='Movie' then fn.show_id end) as no_of_cmovies 
-- from netflix_genre g
-- join final_netflix fn
-- on g.show_id = fn.show_id
-- join netflix_country c
-- on fn.show_id = c.show_id
-- group by c.country
-- order by no_of_cmovies desc;
-- or 
-- much btter and efficient  ->
-- select c.country, count(distinct fn.show_id) as no_of_cmovies 
-- from netflix_genre g
-- join final_netflix fn
-- on g.show_id = fn.show_id
-- join netflix_country c
-- on fn.show_id = c.show_id
-- where  g.genre='Comedies' and fn.type='Movie' 
-- group by c.country
-- order by no_of_cmovies desc;

-- 3 for each year (as per date added to netflix), which director has maximum no of movies released
-- with cte as (
-- select year(fn.date_added) as date_year, nd.director ,count(fn.show_id) as no_of_movies 
-- from final_netflix fn
-- join netflix_director nd 
-- on fn.show_id = nd.show_id 
-- where type='Movie' 
-- group by nd.director, year(fn.date_added)
-- )
-- ,cte2 as (
-- select *,
-- row_number() over (partition by date_year order by no_of_movies desc) as rn
-- from cte
-- )
-- select * from cte2 where rn=1;


-- what is the average duration of movies in each genre 
-- select ng.genre, round(avg(duration)) as average_duration
-- from final_netflix fn
-- join netflix_genre ng
-- on fn.show_id = ng.show_id
-- where fn.type='Movie'
-- group by ng.genre

-- select * from final_netflix

-- 5 find the list of directors who have created horror and comedy movies both 
-- display the director names along with the number of comedy and horror movies directed by them
-- Comedies and Horror Movies 
-- select nd.director, 
-- count( case when ng.genre = 'Comedies' then ng.show_id end ) as Comedy,
-- count( case when ng.genre = 'Horror Movies' then ng.show_id end ) as Horror
-- from final_netflix fn
-- join netflix_genre ng
-- on fn.show_id = ng.show_id
-- join netflix_director nd
-- on fn.show_id = nd.show_id
-- where fn.type = 'Movie' and ng.genre in ('Comedies','Horror Movies')
-- group by nd.director
-- having count(distinct ng.genre)=2






 




