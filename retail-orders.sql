use retail_orders;
-- select * from orders;
-- select count(*) from orders;

-- select ship_mode,count(*) from orders group by ship_mode;

-- select order_date from orders;
-- drop table orders;

-- create table orders(
-- order_id int primary key,
-- order_date date,
-- ship_mode varchar(20),
-- segment varchar(20),
-- country varchar(20),
-- city varchar(20),
-- state varchar(20),
-- postal_code int,
-- region varchar(20),
-- category varchar(20),
-- sub_category varchar(20),
-- product_id varchar(50),
-- quantity int,
-- discount decimal(7,2),
-- sale_price decimal(7,2),
-- profit decimal(7,2)
-- )

-- find top 10 highest revenue generating products 
-- select product_id,sum(sale_price) as total_sales from orders group by product_id order by total_sales desc limit 10;

-- find top 5 highest selling products in each region
-- with cte as(
-- select region, product_id, sum(quantity) as q
-- from orders
-- group by region,product_id 
-- order by region,q desc
-- )
-- select * from(
-- select * ,
-- row_number() over (partition by region order by q desc) as rn
-- from cte) A
-- where rn<6;
 
 -- find month over month growth comparison for 2022 and 2023 sales eg: jan 2022 vs jan 2023
-- with cte1 as (
-- select  month(order_date) as m2022,sum(sale_price) as growth2022
--  from orders
--  where year(order_date) = 2022
--  group by month(order_date)
-- ) ,
--  cte2 as (
-- select  month(order_date) as m2023,sum(sale_price) as growth2023
--  from orders
--  where year(order_date) = 2023
--  group by month(order_date)
-- )
-- select cte1.m2022 as order_month, cte1.growth2022, cte2.growth2023
-- from cte1
-- join cte2
-- on cte1.m2022 = cte2.m2023
-- order by cte1.m2022
-- ;
 
-- for each category which month has highest sales; 

-- select category,max(s) as sales from (
-- select date_format(order_date,'%Y-%M') as d,category,sum(sale_price) as s from orders group by date_format(order_date,'%Y-%M'),category
-- ) A
-- group by category;
-- --------------------------------------------
-- with cte as (
-- select category, date_format(order_date,'%Y-%M'), sum(sale_price) as s
-- from orders
-- group by category, date_format(order_date,'%Y-%M')
-- )

-- select * from (select * ,
-- row_number() over (partition by category order by s desc) as rn
-- from cte) A
-- where rn =1;

-- which subcategory has the highest growth by profit in 2023 as compare to 2022
-- with cte1 as(
-- select sum(profit) as s2022,sub_category from orders where year(order_date)=2022 group by sub_category 
-- ),
-- cte2 as (
-- select sum(profit) as s2023,sub_category from orders where year(order_date)=2023 group by sub_category 
-- )
-- select cte1.sub_category, cte1.s2022, cte2.s2023,(cte2.s2023 - cte1.s2022) AS diff
-- from cte1 join cte2 on cte1.sub_category = cte2.sub_category
-- order by diff desc ;


-- select * from orders;
