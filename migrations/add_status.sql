alter table staging.user_order_log add status varchar(8);
alter table mart.f_sales add status varchar(8) default 'shipped';