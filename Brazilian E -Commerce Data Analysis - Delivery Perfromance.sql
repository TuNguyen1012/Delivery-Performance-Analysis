Use [Brazilian _ecommerce]

--- OVER VIEW THE DATASET: ---

Select * from customers_dataset
Select * from orders_dataset
Select * from order_items_dataset 
Select * from order_payments_dataset
Select * from order_reviews_dataset
Select * from products_dataset
Select * from product_category_name_translation
Select * from sellers_dataset
Select * from geolocation_dataset	

--- Total Orders in database ---
select count (order_id) as Total_orders from orders_dataset

--- Total Customers in database ---
select count (distinct customer_unique_id) as Total_customers from customers_dataset

--- Total Sellers in database ---
select count (seller_id) as Total_sellers from sellers_dataset 

--- create a detal time table of purchase ---

drop table if exists time_order_purchase
with time1 as(
	select order_id, order_purchase_timestamp,
	DATEPART(hh, order_purchase_timestamp) as hour_purchase,
	DATEPART(dw, order_purchase_timestamp) as dayofweek_purchase,
	DATENAME(weekday, order_purchase_timestamp) as weekday_purchase, 
	DATEPART(d, order_purchase_timestamp) as day_purchase,
	DATEPART(m, order_purchase_timestamp) as month_purchase,
	DATEPART(yy, order_purchase_timestamp) as year_purchase
	from orders_dataset),
time2 as(
	select *,
	case
		when hour_purchase between 0 and 6 then 'Dawn'
		when hour_purchase between 7 and 12 then 'Morning'
		when hour_purchase between 13 and 18 then 'Afternoon'
		else 'Night'
	end as day_period
	from time1)
select * into time_order_purchase from time2

select * from time_order_purchase

--- Order Values ---

Drop table if exists order_value
with values1 as (
	select o.order_id, sum(i.price) as price, sum(i.freight_value) as freight
	from orders_dataset o
	join order_items_dataset i
	on o.order_id = i.order_id
	where o.order_status NOT IN ('canceled','unavailable')
	group by o.order_id),
values2 as (
	select *, (price + freight) as total from values1)

select * into order_value from values2

select * from order_value

select max(total) as Highest_order_value from order_value
select min(total) as Lowest_order_value from order_value

select round(avg(total),2) as Avegare_total_values from order_value 
select round(sum(total),2) as Total_values from order_value 

--- Order Status ---

drop table if exists order_status
Select order_status, count (order_id) as orders,
CONCAT(round(cast((COUNT(order_id)*100)as float)/cast((SELECT COUNT(order_id) FROM orders_dataset) as float),2), '%')  as Percent_of_status 
into order_status
from orders_dataset
group by order_status
order by orders DESC 

select * from order_status
order by orders DESC

--- Number of Order by Month: ---

Drop table if exists month_order
with ordermonth1 as(
	select t.order_purchase_timestamp, t.year_purchase as year, t.month_purchase as month, count(o.order_id) as count_order
	from orders_dataset o
	join time_order_purchase t
	on o.order_id = t.order_id
	group by t.order_purchase_timestamp,t.year_purchase,t.month_purchase),
ordermonth2 as(
	select year, month, sum(count_order) as number_of_order 
	from ordermonth1 
	group by year, month)
select * into month_order from ordermonth2
order by year,month

select * from month_order 
order by year,month

---Number of order by day of the week---

Drop table if exists all_order_dayoftheweek
select dayofweek_purchase,weekday_purchase, count(order_id) as number_of_order_week
into all_order_dayoftheweek
from time_order_purchase
group by dayofweek_purchase, weekday_purchase
order by dayofweek_purchase, weekday_purchase

select * from all_order_dayoftheweek
order by dayofweek_purchase

Drop table if exists delivered_order_dayoftheweek
select t.dayofweek_purchase,t.weekday_purchase, count(t.order_id) as number_of_order_week
into delivered_order_dayoftheweek
from time_order_purchase t
join orders_dataset o
on t.order_id = o.order_id
where o.order_status = 'delivered'
group by dayofweek_purchase, weekday_purchase
order by dayofweek_purchase, weekday_purchase

select * from delivered_order_dayoftheweek
order by dayofweek_purchase

--- Number of order by time in the day ---

Drop table if exists order_timeperiod
Select day_period, count(order_id) as number_of_order_timeperiod,
case
	when day_period = 'Dawn' then '1'
	when day_period ='Morning' then '2'
	when day_period = 'Afternoon' then '3'
	else '4'
end as norank
into order_timeperiod
from time_order_purchase
group by day_period
order by day_period

select day_period,number_of_order_timeperiod from order_timeperiod
order by norank

--- Number of order by State ---

Drop table if exists order_by_state
Select c.customer_state, count(o.order_id) as number_of_order
into order_by_state
from customers_dataset c
join orders_dataset o
on c.customer_id = o.customer_id
group by c.customer_state
order by number_of_order DESC

Select * from order_by_state
order by number_of_order DESC

--- Number of order by Category ---

Drop table if exists order_by_category
Select pe.product_category_name_english as category, count(i.product_id) as number_of_order
into order_by_category
from order_items_dataset i
join products_dataset p
on i.product_id = p.product_id
join product_category_name_translation pe
on p.product_category_name = pe.product_category_name
group by pe.product_category_name_english
order by number_of_order DESC

select * from order_by_category
order by number_of_order DESC

--- Number of products people usually order ---

Drop table if exists number_of_product
Select order_item_id as number_of_product, count(order_item_id) as product
into number_of_product
from order_items_dataset
group by order_item_id

select * from number_of_product
order by number_of_product

--- Total order value by month , average order value by month ---

Drop table if exists order_value_month
with ordervaluemonth1 as (
	select v.order_id, v.total,
	t.order_purchase_timestamp, t.year_purchase as year, t.month_purchase as month
	from order_value v
	join time_order_purchase t
	on v.order_id = t.order_id)

select year, month, round(sum(total),2) as total_value_by_month,round(avg(cast(total as float)),2) as avg_of_order_value 
into order_value_month
from ordervaluemonth1
group by year, month
order by year, month

select * from order_value_month
order by year, month

--- Total Order value by state ---

Drop table if exists order_value_by_state
with valuestate as (
	select v.order_id, v.total, c.customer_id, c.customer_state as state
	from order_value v
	join orders_dataset o
	on v.order_id = o.order_id
	join customers_dataset c
	on o.customer_id = c.customer_id)

select state, round(sum(total),2) as total_value_by_state
into order_value_by_state
from valuestate
group by state
order by state

select * from order_value_by_state
order by total_value_by_state DESC


--- Number of payment types ---

drop table if exists payment_types
with payment1 as (
	select p.payment_type, p.order_id
	from order_payments_dataset p
	join orders_dataset o
	on p.order_id = o.order_id
	where o.order_status not in ('canceled','unavailable'))

select payment_type, count(order_id) as number_of_payment,
CONCAT(round((cast(100*count(order_id) as float))/(select cast(count(order_id) as float) from payment1),2), '%') as percent_of_order
into payment_types
from payment1
group by payment_type
order by number_of_payment DESC

select * from payment_types
order by number_of_payment DESC

---	Customer Satisfaction Level ---
drop table if exists customer_satisfaction
select review_score, count(order_id) as num_of_score
into customer_satisfaction
from order_reviews_dataset
group by review_score
order by review_score

select * from customer_satisfaction
order by review_score

--- Completed Order days and Average day completed order ---

drop table if exists days_completing_order
select order_id,DATEDIFF(day, order_purchase_timestamp, order_delivered_customer_date)
as days_completing_order
into days_completing_order
from orders_dataset
where order_status = 'delivered' and order_delivered_customer_date is not null

select * from days_completing_order
order by days_completing_order

select round(avg(cast(days_completing_order as float)),2) from days_completing_order

drop table if exists count_days_completing_order
select days_completing_order, count(days_completing_order) as counts
into count_days_completing_order
from days_completing_order
group by days_completing_order
order by days_completing_order

select * from count_days_completing_order
order by days_completing_order

--- Compare Actual Delivery Time vs Estimation Delivery Time  ---

drop table if exists compare_completing_order_time
with interval as(
	select order_id, order_delivered_customer_date, order_estimated_delivery_date,
	datediff(day, order_estimated_delivery_date, order_delivered_customer_date) as interval
	from orders_dataset
	where order_status = 'delivered'and order_delivered_customer_date is not null),
days_completing_order as (
	select *, case
		when interval < 0 or interval = 0 then 'on_time'
		else 'over_time'
		end as classified_time_delivery
	from interval)

select classified_time_delivery, count(order_id) as number_of_orders,
CONCAT(round((cast(count(order_id)*100 as float)/(select cast(count(order_id) as float) from days_completing_order)),2), '%') as percent_of_orders 
into compare_completing_order_time
from days_completing_order
group by classified_time_delivery
order by classified_time_delivery

select * from compare_completing_order_time
order by classified_time_delivery

--- how many delayed days ---

drop table if exists delay_time
with interval3 as(
	select order_id, order_delivered_customer_date, order_estimated_delivery_date,
	datediff(day, order_estimated_delivery_date, order_delivered_customer_date) as interval_3
	from orders_dataset
	where order_status = 'delivered'and order_delivered_customer_date is not null),
delay_days as (
	select *, case
		when interval_3 > 0 and interval_3 < 5  then 'less than 5 days'
		when interval_3 > 5 and interval_3 < 10  then 'under 5 to 10 days'
		when interval_3 > 10 and interval_3 < 30  then 'under 10 to 30 days'
		when interval_3 > 30 and interval_3 < 60  then 'under 30 to 60 days'
		else 'more than 60 days'
		end as delay_days
	from interval3
	where interval_3 > 0)

select * into delay_time from delay_days

select * from delay_time
order by interval_3 DESC

drop table if exists percent_of_delay_order
with count_delay_days as (
	select delay_days, count(delay_days) as count_delay_days from delay_time
	group by delay_days)
select *, 
CONCAT(round((cast(count_delay_days*100 as float)/(select cast(sum(count_delay_days) as float) from count_delay_days)),2), '%') as percent_of_delay
into percent_of_delay_order
from count_delay_days

select * from percent_of_delay_order

--- Delivery time compare to customers review score ----

drop table if exists review_score_delivery
with interval4 as(
	select order_id, order_delivered_customer_date, order_estimated_delivery_date,
	datediff(day, order_estimated_delivery_date, order_delivered_customer_date) as interval_4
	from orders_dataset
	where order_status = 'delivered'and order_delivered_customer_date is not null),
time_delivery as (
	select *, case
		when interval_4 < 0 or interval_4 = 0 then 'on_time'
		else 'over_time'
		end as classified_time_delivery
	from interval4),
review_score_deivery_num as (
	select t.*, r.review_score as review_score
	from time_delivery t
	join order_reviews_dataset r
	on t.order_id = r.order_id)
	
select classified_time_delivery, round(avg(review_score),1) as review_score into review_score_delivery from review_score_deivery_num
group by classified_time_delivery

select * from review_score_delivery


--- Processing Order days and Average day processing order ---

drop table if exists days_proseccing_order
select order_id,DATEDIFF(day, order_approved_at, order_delivered_carrier_date)
as days_proseccing_order
into days_proseccing_order
from orders_dataset
where order_status = 'delivered' and order_approved_at is not null and order_delivered_carrier_date is not null and order_delivered_customer_date is not null

select * from days_proseccing_order
order by days_proseccing_order

drop table if exists count_days_proseccing_order
select days_proseccing_order, count(days_proseccing_order) as counts
into count_days_proseccing_order
from days_proseccing_order
group by days_proseccing_order
order by days_proseccing_order

select * from count_days_proseccing_order
order by days_proseccing_order

select round(avg(cast(days_proseccing_order as float)),2) from days_proseccing_order

--- Compare to the limited time delivered to the carrier ---

drop table if exists compare_processing_order_time
with interval as(
	select i.order_id, i.shipping_limit_date, o.order_delivered_carrier_date,
	datediff(day, i.shipping_limit_date, o.order_delivered_carrier_date) as interval
	from orders_dataset o
	join order_items_dataset i
	on o.order_id = i.order_id
	where order_status = 'delivered'and order_approved_at is not null and order_delivered_carrier_date is not null and order_delivered_customer_date is not null),
processing_on_time as (
	select *, case
		when interval < 0 or interval = 0 then 'on_time'
		else 'over_time'
		end as classified_time_delivery_to_carrier
	from interval)

select classified_time_delivery_to_carrier, count(order_id) as number_of_orders,
CONCAT(round((cast(count(order_id)*100 as float)/(select cast(count(order_id) as float) from processing_on_time)),2), '%') as percent_of_orders 
into compare_processing_order_time
from processing_on_time
group by classified_time_delivery_to_carrier
order by classified_time_delivery_to_carrier

select * from compare_processing_order_time
order by classified_time_delivery_to_carrier

--- Top Sellers delaying prepare orders ----

drop table if exists top_sellers_delay
with interval5 as(
	select distinct i.seller_id, o.order_id, i.shipping_limit_date, o.order_delivered_carrier_date,
	datediff(day, i.shipping_limit_date, o.order_delivered_carrier_date) as interval
	from orders_dataset o
	join order_items_dataset i
	on o.order_id = i.order_id
	join sellers_dataset s
	on i.seller_id = s.seller_id
	where order_status = 'delivered'and order_approved_at is not null and order_delivered_carrier_date is not null and order_delivered_customer_date is not null),
sellers_accuracy as (
	select *, case
		when interval < 0 or interval = 0 then 'on_time'
		else 'over_time'
		end as classified_time_delivery_to_carrier
	from interval5)
select seller_id, count(classified_time_delivery_to_carrier) as num 
into top_sellers_delay
from sellers_accuracy
where classified_time_delivery_to_carrier = 'over_time'
group by seller_id, classified_time_delivery_to_carrier
order by num DESC

select * from top_sellers_delay
order by num DESC

--- Delivery Order days and Average day delivery order ---

drop table if exists days_delivery_order
select order_id,DATEDIFF(day, order_delivered_carrier_date, order_delivered_customer_date)
as days_delivery_order
into days_delivery_order
from orders_dataset
where order_status = 'delivered' and order_approved_at is not null and order_delivered_carrier_date is not null and order_delivered_customer_date is not null

select * from days_delivery_order
order by days_delivery_order

select round(avg(cast(days_delivery_order as float)),2) from days_delivery_order

drop table if exists count_days_delivery_order
select days_delivery_order, count(days_delivery_order) as counts
into count_days_delivery_order
from days_delivery_order
group by days_delivery_order
order by days_delivery_order

select * from count_days_delivery_order
order by days_delivery_order

--- Compare to the estimated time delivered to the customers ---

drop table if exists compare_shipping_order_time
with interval2 as(
	select order_id, order_estimated_delivery_date, order_delivered_customer_date, 
	datediff(day, order_estimated_delivery_date, order_delivered_customer_date) as interval
	from orders_dataset o
	where order_status = 'delivered' and order_approved_at is not null and order_delivered_carrier_date is not null and order_delivered_customer_date is not null),
shipping_on_time as (
	select *, case
		when interval < 0 or interval = 0 then 'on_time'
		else 'over_time'
		end as classified_time_delivery_to_customers
	from interval2)

select classified_time_delivery_to_customers, count(order_id) as number_of_orders,
CONCAT(round((cast(count(order_id)*100 as float)/(select cast(count(order_id) as float) from shipping_on_time)),2), '%') as percent_of_orders 
into compare_shipping_order_time
from shipping_on_time
group by classified_time_delivery_to_customers
order by classified_time_delivery_to_customers

select * from compare_shipping_order_time
order by classified_time_delivery_to_customers

--- delivery by state ---

drop table if exists days_delivery_state
with days_delivery_order as(
	select c.customer_state, DATEDIFF(day, order_delivered_carrier_date, order_delivered_customer_date)
	as days_delivery_order
	from orders_dataset o
	join customers_dataset c
	on o.customer_id = c.customer_id
	where order_status = 'delivered' and order_approved_at is not null and order_delivered_carrier_date is not null and order_delivered_customer_date is not null
	)
select customer_state, avg(days_delivery_order) as avg_days
into days_delivery_state
from days_delivery_order
group by customer_state
order by avg_days

select * from days_delivery_state
order by avg_days




Select * from order_by_state
order by number_of_order DESC