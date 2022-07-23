create table mart.f_customer_retention (
	new_customers_count int4, 
	returning_customers_count int4, 
	refunded_customer_count int4, 
	period_name varchar(10), 
	period_id int4, 
	item_id int4, 
	new_customers_revenue numeric(10, 2),
	returning_customers_revenue numeric(10, 2),
	customers_refunded int4
);