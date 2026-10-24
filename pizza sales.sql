SELECT @@VERSION;
create database pizzadb;
use pizzadb;
select * from pizza_sales;

--filter the data based on M sized pizza--
/*filter the data based on M sized pizza*/

select * from pizza_sales where pizza_size='M';

--total orders
select count(distinct order_id)from pizza_sales;

--total revenue
select sum(total_price)as total_revenue from pizza_sales;

--total sales
select sum(quantity)as total_sales from pizza_sales;

--average order(here avg column is not there so we used divide)
select sum(total_price)/count(distinct order_id)as average_order from pizza_sales;

--average pizza sold per order
select sum(quantity)/count(distinct order_id)as average_order from pizza_sales;

--cast()--converts one datatype to another
select cast(sum(total_price)/
count(distinct order_id)as 
decimal(10,2))
as average_order from pizza_sales;

--converting int into float
select cast(sum(quantity)as decimal
(10,2))/cast(count(distinct order_id)
as decimal(10,2))as average_order from pizza_sales;

--to get only two values after point
select cast(cast(sum(quantity)as decimal
(10,2))/cast(count(distinct order_id)
as decimal(10,2))as decimal(10,2))as average_order from pizza_sales;

--daily trends on orders
select datename(dw,order_date)as order_day,
count(distinct order_id)as total_orders 
from pizza_sales group by datename(dw,order_date)order by total_orders desc;

--monthly trends on orders(you can also give month)
select datename(m,order_date)as order_month,
count(distinct order_id)as total_orders 
from pizza_sales group by datename(m,order_date)order by total_orders desc;

--find the quantity sold in each category
select pizza_category,sum(quantity)as total_sales
from pizza_sales group by pizza_category order by total_sales desc; 

--find the revenue in each category
select pizza_category,sum(total_price)as total_revenue
from pizza_sales group by pizza_category order by total_revenue desc; 

--hourly orders
select datepart(hour,order_time)as order_hour,
count(distinct order_id)as total_orders from pizza_sales 
group by datepart(hour,order_time)order by total_orders desc;

--total pizza sold by pizza name
select pizza_name,sum(quantity)as total_sales
from pizza_sales group by pizza_name order by total_sales desc; 

--total revenue by size
select pizza_size,sum(total_price)as total_revenue
from pizza_sales group by pizza_size order by total_revenue desc; 

--top 3 months based on orders(in ssms limit doesnt work so we use top 3)
select top 3 datename(month,order_date)as order_month,
count(distinct order_id)as total_orders from pizza_sales
group by datename(month,order_date)order by total_orders desc;

--top 3 months based on revenue
select top 3 datename(month,order_date)as order_month,
sum(total_price)as total_revenue from pizza_sales
group by datename(month,order_date)order by total_revenue desc;

--task
--bottom 3 months based on orders
select top 3 datename(month,order_date)as order_month,
count(distinct order_id)as total_orders from pizza_sales
group by datename(month,order_date)order by total_orders asc;

--top 5 pizza names based on sales
select top 5 pizza_name,sum(quantity)as total_sales
from pizza_sales group by pizza_name order by total_sales desc; 

--top 5 pizza names based on revenue
select top 5 pizza_name,sum(total_price)as total_revenue
from pizza_sales group by pizza_name order by total_revenue desc; 

--total orders by pizza size
select pizza_size,count(distinct order_id)as total_orders from pizza_sales
group by pizza_size order by total_orders desc;

--top 5 best selling pizza by orders
select top 5 pizza_name,count(distinct order_id)as total_sales
from pizza_sales group by pizza_name order by total_sales desc; 

--date related query
--extract year
select year(order_date)as order_year from pizza_sales;--(temporary)

--to make permanent column
alter table pizza_sales 
add order_year int;

select*from pizza_sales;

--update
update pizza_sales set
order_year=year(order_date);

alter table pizza_sales
drop column order_yearr;--i just added one column so that i used this to delete 

--extract month,monthname,day,dayname,year
select order_date,
year(order_date)as order_year,
month(order_date)as month_number,
datename(month,order_date)as month_name,
day(order_date)as day_number,
datename(dw,order_date)as day_name
from pizza_sales;



--Pizza sales – Window functions task 
--1. Find the average total price of all pizzas and display it along with every pizza record.
select pizza_name,total_price,
avg(total_price)over()as overall_avg_price
from pizza_sales;

--2. Find the total sales revenue and display it along with every pizza record.
select pizza_name,total_price,
sum(total_price)over()as overall_sum_price
from pizza_sales;

--3. Find the maximum unit price among all pizzas and display it along with every pizza record.
select pizza_name,unit_price,
max(unit_price)over()as overall_max_price
from pizza_sales;

--4. Find the average total price for each pizza category and display it for every pizza.
select pizza_category,pizza_name,total_price,
avg(total_price)over(partition by pizza_category)as overall_avg_price
from pizza_sales;

--5. Find the total revenue for each pizza category and display it for every pizza.
select pizza_category,pizza_name,total_price,
sum(total_price)over(partition by pizza_category)as overall_sum_price
from pizza_sales;
	
--6. Find the number of pizza records for each pizza size and display it for every pizza.
select pizza_size,pizza_name,
count(pizza_id)over(partition by pizza_size)as overall_pizza
from pizza_sales;

--7. Assign a unique row number to every pizza based on total price from highest to lowest.
select pizza_name,total_price,
row_number()over(order by total_price desc)as
unique_num from pizza_sales;


--8. Rank all pizzas based on total price from highest to lowest.
select pizza_name,total_price,
rank()over(order by total_price desc)as
rank_num from pizza_sales;


--9. Assign a dense rank to all pizzas based on total price from highest to lowest.
select pizza_name,total_price,
dense_rank()over(order by total_price desc)as
dense_num from pizza_sales;


--10. Rank pizzas based on total price within each pizza category. 
select pizza_category,pizza_name,total_price,
rank()over(partition by pizza_category order by total_price desc)
as rank_pizza from pizza_sales;


--11. Find the highest-priced pizza in each pizza category.
select pizza_name,pizza_category,total_price
from(select pizza_name,pizza_category,total_price,
dense_rank() over(partition by pizza_category order by total_price desc) as dept_rank
from pizza_sales) as rank_table where dept_rank=1;


--12. Find the top 2 highest-priced pizzas from each pizza category. 
select pizza_name,pizza_category,total_price
from(select pizza_name,pizza_category,total_price,
rank() over(partition by pizza_category order by total_price desc) as dept_rank
from pizza_sales) as rank_table where dept_rank<=2;


--13. Display each pizza's total price along with the previous pizza's total price. 
select pizza_name,total_price,
lag(total_price) over(order by pizza_id desc) as previous_total_price
from pizza_sales;

--14. Find the difference between the current pizza's total price and the previous pizza's total price.
select pizza_name,total_price,
lag(total_price,2) over(order by pizza_id) as previous_total_price,
total_price-lag(total_price) over(order by pizza_id) as total_price_diff
from pizza_sales;

--15. Display each pizza's unit price along with the previous pizza's unit price.
select pizza_name,unit_price,
lag(unit_price) over(order by pizza_id desc) as previous_unit_price
from pizza_sales;


--16. Display each pizza's total price along with the next pizza's total price. 
select pizza_name,total_price,
lead(total_price) over(order by pizza_id) as next_total_price
from pizza_sales;


--17. Find the difference between the current pizza's total price and the next pizza's total price.
select pizza_name,total_price,
lead(total_price,2) over(order by pizza_id) as next_total_price,
total_price-lead(total_price) over(order by pizza_id) as total_price_diff
from pizza_sales;


--18. Display each pizza's unit price along with the next pizza's unit price. 
select pizza_name,unit_price,
lead(unit_price) over(order by pizza_id) as next_unit_price
from pizza_sales;


--19. Create a pizza_type column using pizza_category: 
--a. Classic → Regular 
--b. Veggie → Vegetarian 
--c. Chicken → Non-Vegetarian
--d. Supreme → Special
select pizza_name,pizza_category,
case pizza_category
when 'Classic' then 'Regular'
when 'Veggie' then 'Vegetarian'
when 'Chicken' then 'Non-vegetarian'
when 'Supreme' then 'Special'
end as pizza_cat from pizza_sales;

--20. Categorize pizzas based on unit_price: 
--a. Below 15 → Budget  
--b. 15–20 → Standard 
--c. Above 20 → Premium 
select pizza_name,unit_price,
case 
when unit_price<15 then 'Budget'
when unit_price<=20 then 'Standard'
when unit_price>20 then 'Premium'
end as pizza_unit_price
from pizza_sales;