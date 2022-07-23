truncate table mart.f_customer_retention;

with b as (
select 
	f.customer_id,
    c.week_of_year period_id,
    count(f.id) orders_cnt 
from 
    mart.f_sales f
left join 
    mart.d_calendar c on f.date_id = c.date_id
group by 
    c.week_of_year, f.customer_id
),
d as (
select 
	count(distinct case when b.orders_cnt = 1 then a.customer_id end) new_customers_count,
	count(distinct case when b.orders_cnt > 1 then a.customer_id end) returning_customers_count,
	count(distinct case when a.status='refunded' then a.customer_id end) refunded_customer_count,
	'weekly' period_name,
	c.week_of_year period_id,
	a.item_id item_id,
	sum(case when b.orders_cnt = 1 then a.payment_amount  end) new_customers_revenue,
	sum(case when b.orders_cnt > 1 then a.payment_amount  end) returning_customers_revenue,
	count(case when a.status='refunded' then a.id end) customers_refunded 
from 
    mart.f_sales a
left join 
    mart.d_calendar c on a.date_id = c.date_id
left join 
    b on a.customer_id = b.customer_id and c.week_of_year = b.period_id
group by 
    c.week_of_year, item_id
)
insert into mart.f_customer_retention (new_customers_count, returning_customers_count, refunded_customer_count, period_name, period_id, item_id, new_customers_revenue,returning_customers_revenue,customers_refunded)
select new_customers_count, returning_customers_count, refunded_customer_count, period_name, period_id, item_id, new_customers_revenue,returning_customers_revenue,customers_refunded from d;