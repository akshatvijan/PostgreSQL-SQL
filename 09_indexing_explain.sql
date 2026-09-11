
-------------------------------TASK9--------------------------------------
-- with out indexing joins
explain
select c1.*,c2.* 
from shipments c1
join suppliers c2 
on c1.supplier_id=c2.supplier_id;

explain analyze
select c1.*,c2.* 
from shipments c1
join suppliers c2 
on c1.supplier_id=c2.supplier_id;

-- creating index on supplier_id
create index index_supplier_id
on shipments(supplier_id)

explain
select c1.*,c2.* 
from shipments c1
join suppliers c2 
on c1.supplier_id=c2.supplier_id;

explain analyze
select c1.*,c2.* 
from shipments c1
join suppliers c2 
on c1.supplier_id=c2.supplier_id;




-- product performance join
explain
select c1.*,c2.* 
from shipments c1
join products c2 
on c1.product_id=c2.product_id;

explain analyze
select c1.*,c2.* 
from shipments c1
join products c2 
on c1.product_id=c2.product_id;

-- creating index on product_id
create index index_product_id
on shipments(product_id)

explain
select c1.*,c2.* 
from shipments c1
join products c2 
on c1.product_id=c2.product_id;

explain analyze
select c1.*,c2.* 
from shipments c1
join products c2 
on c1.product_id=c2.product_id;


-- current delay filtering
explain
select shipment_id 
from shipment_risk 
where current_delay_days > 
(
    select avg(current_delay_days) 
    from shipment_risk
);

explain analyze
select shipment_id 
from shipment_risk 
where current_delay_days > 
(
    select avg(current_delay_days) 
    from shipment_risk
);

-- craeting index
create index index_cuurent_deley_days
on shipment_risk(current_delay_days)

explain
select shipment_id 
from shipment_risk 
where current_delay_days > 
(
    select avg(current_delay_days) 
    from shipment_risk
);

explain analyze
select shipment_id 
from shipment_risk 
where current_delay_days > 
(
    select avg(current_delay_days) 
    from shipment_risk
);


-- group by country to find avg historical_delay_days
explain
select country,avg(historical_delay_days) 
from shipment_raw
group by country;

explain analyze
select country,avg(historical_delay_days) 
from shipment_raw
group by country;

--creating index
create index country_index
on shipment_raw(country)

explain
select country,avg(historical_delay_days) 
from shipment_raw
group by country;

explain analyze
select country,avg(historical_delay_days) 
from shipment_raw
group by country;

-- order by route_risk_score in decending order
explain
select
shipment_id,
route_risk_score,
political_risk_index,
port_congestion_index,
delay_probability,
current_delay_days
from shipment_risk
order by route_risk_score desc;

explain analyze
select
shipment_id,
route_risk_score,
political_risk_index,
port_congestion_index,
delay_probability,
current_delay_days
from shipment_risk
order by route_risk_score desc;

--create index
create index index_route_risk_score
on shipment_risk(route_risk_score)

explain
select
shipment_id,
route_risk_score,
political_risk_index,
port_congestion_index,
delay_probability,
current_delay_days
from shipment_risk
order by route_risk_score desc;

explain analyze
select
shipment_id,
route_risk_score,
political_risk_index,
port_congestion_index,
delay_probability,
current_delay_days
from shipment_risk
order by route_risk_score desc;






