---------------------------------------------TASK1---------------------------------------------------
-- CREATE SCHEMA supply_chain;
-- SET search_path TO supply_chain, public;

--------------------------------------------Create table-------------------------------------------------

-- create table shipment_raw (
--     shipment_id VARCHAR(20),
--     supplier_id VARCHAR(20),
--     country VARCHAR(50),
--     product_type VARCHAR(50),
--     monthly_demand_tons INT,
--     shipment_volume_tons INT,
--     route_risk_score DECIMAL(5,2),
--     historical_delay_days INT,
--     fuel_price_usd DECIMAL(10,2),
--     political_risk_index DECIMAL(5,2),
--     port_congestion_index DECIMAL(5,2),
--     inventory_days INT,
--     supplier_reliability DECIMAL(4,2),
--     alternative_supplier_count INT,
--     transit_time_days INT,
--     delay_probability DECIMAL(4,2),
--     current_delay_days INT,
--     freight_cost_usd DECIMAL(12,2),
--     revenue_impact_usd DECIMAL(12,2),
--     disruption_event INT
-- );

----------------------------------------Total_Records-----------------------------------------------
-- select count(*) as Total_Records from shipment_raw


-----------------------------------------Total_Columns-------------------------------------------------
--select count(*) from information_schema.columns where table_schema='supply_chain' and table_name='shipment_raw'


-----------------------------------------Null_Values--------------------------------------------------
-- select
-- count(*) filter(where shipment_id is null) as shipment_id_null,
-- count(*) filter(where supplier_id is null) as supplier_id_null,
-- count(*) filter(where country is null) as country_null,
-- count(*) filter(where product_type is null) as product_type_null,
-- count(*) filter(where monthly_demand_tons is null) as monthly_demand_tons_null,
-- count(*) filter(where shipment_volume_tons is null) as shipment_volume_tons_null,
-- count(*) filter(where route_risk_score is null) as route_risk_score_null,
-- count(*) filter(where historical_delay_days is null) as historical_delay_days_null,
-- count(*) filter(where fuel_price_usd is null) as fuel_price_usd_null,
-- count(*) filter(where political_risk_index is null) as political_risk_index_null,
-- count(*) filter(where port_congestion_index is null) as port_congestion_index_null,
-- count(*) filter(where inventory_days is null) as inventory_days_null,
-- count(*) filter(where supplier_reliability is null) as supplier_reliability_null,
-- count(*) filter(where alternative_supplier_count is null) as alternative_supplier_count_null,
-- count(*) filter(where transit_time_days is null) as transit_time_days_null,
-- count(*) filter(where delay_probability is null) as delay_probability_null,
-- count(*) filter(where current_delay_days is null) as current_delay_days_null,
-- count(*) filter(where freight_cost_usd is null) as freight_cost_usd_null,
-- count(*) filter(where revenue_impact_usd is null) as revenue_impact_usd_null,
-- count(*) filter(where disruption_event is null) as disruption_event_null
-- from shipment_raw;

--------------------------------------Duplicate_shipment_id--------------------------------------------
-- select shipment_id,count(*) from shipment_raw group by shipment_id having count(*)>1;

--------------------------------------Duplicate_supplier_id--------------------------------------------
-- select supplier_id,count(*) from shipment_raw group by supplier_id having count(*)>1;


-------------------------------------Invalid_values----------------------------------------------------
-- select
-- count(*) filter(where monthly_demand_tons<=0) as invalid_monthly_demand_tons,
-- count(*) filter(where shipment_volume_tons<=0) as invalid_shipment_volume_tons,
-- count(*) filter(where route_risk_score<0 or route_risk_score>100) as invalid_route_risk_score,
-- count(*) filter(where historical_delay_days<0) as invalid_historical_delay_days,
-- count(*) filter(where fuel_price_usd<0) as invalid_fuel_price_usd,
-- count(*) filter(where political_risk_index<0 or political_risk_index>100) as invalid_political_risk_index,
-- count(*) filter(where port_congestion_index<0 or port_congestion_index>100) as invalid_port_congestion_index,
-- count(*) filter(where inventory_days<0) as invalid_inventory_days,
-- count(*) filter(where supplier_reliability<0 or supplier_reliability>1) as invalid_supplier_reliability,
-- count(*) filter(where alternative_supplier_count<0) as invalid_alternative_supplier_count,
-- count(*) filter(where transit_time_days<0) as invalid_transit_time_days,
-- count(*) filter(where delay_probability<0 or delay_probability>1) as invalid_delay_probability,
-- count(*) filter(where current_delay_days<0) as invalid_current_delay_days,
-- count(*) filter(where freight_cost_usd<0) as invalid_freight_cost_usd,
-- count(*) filter(where revenue_impact_usd<0) as invalid_revenue_impact_usd
-- from shipment_raw;

----------------------------------Negative_values--------------------------------------------------
-- select
-- count(*) filter(where monthly_demand_tons<0) as negative_monthly_demand_tons,
-- count(*) filter(where shipment_volume_tons<0) as negative_shipment_volume_tons,
-- count(*) filter(where route_risk_score<0) as negative_route_risk_score,
-- count(*) filter(where historical_delay_days<0) as negative_historical_delay_days,
-- count(*) filter(where fuel_price_usd<0) as negative_fuel_price_usd,
-- count(*) filter(where political_risk_index<0) as negative_political_risk_index,
-- count(*) filter(where port_congestion_index<0) as negative_port_congestion_index,
-- count(*) filter(where inventory_days<0) as negative_inventory_days,
-- count(*) filter(where supplier_reliability<0) as negative_supplier_reliability,
-- count(*) filter(where alternative_supplier_count<0) as negative_alternative_supplier_count,
-- count(*) filter(where transit_time_days<0) as negative_transit_time_days,
-- count(*) filter(where delay_probability<0) as negative_delay_probability,
-- count(*) filter(where current_delay_days<0) as negative_current_delay_days,
-- count(*) filter(where freight_cost_usd<0) as negative_freight_cost_usd,
-- count(*) filter(where revenue_impact_usd<0) as negative_revenue_impact_usd
-- from shipment_raw;

--------------------------------------------TASK2-------------------------------------------------------


---------------------------------------Suppliers_table------------------------------------------------
-- create table suppliers(
-- supplier_id varchar(20) primary key,
-- country varchar(50) not null,
-- supplier_reliability decimal(4,2)
-- );


------------------------------------------Product_table------------------------------------------------
-- create table products(
-- product_id serial primary key,
-- product_type varchar(50) unique not null
-- );


------------------------------------------Shipments_table------------------------------------------------
-- create table shipments(
-- shipment_id varchar(20) primary key,
-- supplier_id varchar(20) not null references suppliers(supplier_id),
-- product_id int not null references products(product_id),
-- monthly_demand_tons int,
-- shipment_volume_tons int check(shipment_volume_tons>0),
-- historical_delay_days int,
-- fuel_price_usd decimal(10,2),
-- transit_time_days int,
-- freight_cost_usd decimal(12,2) check(freight_cost_usd>=0),
-- revenue_impact_usd decimal(12,2) check(revenue_impact_usd>=0),
-- disruption_event int
-- );


------------------------------------------Customer_risk_table---------------------------------------------
-- create table shipment_risk(
-- shipment_id varchar(20) primary key references shipments(shipment_id),
-- route_risk_score decimal(5,2),
-- political_risk_index decimal(5,2),
-- port_congestion_index decimal(5,2),
-- delay_probability decimal(4,2) check(delay_probability between 0 and 1),
-- current_delay_days int check(current_delay_days>=0)
-- );


--------------------------------------------Inventory_days----------------------------------------------
-- create table inventory(
-- shipment_id varchar(20) primary key references shipments(shipment_id),
-- inventory_days int check(inventory_days>=0),
-- alternative_supplier_count int
-- );







-----------------------------------------------------comments-------------------------------------------
-- The raw shipment table contains supplier, product, shipment, risk and inventory
-- information together, which causes data redundancy and update anomalies.
-- To follow 3NF, the data is divided into separate related tables based on their
-- entities. Suppliers, products, shipments, shipment risks and inventory are
-- stored independently and connected using primary and foreign keys.
-- This reduces duplicate data, improves data consistency and makes the database
-- easier to maintain.

---------------------------------------------TASK3-----------------------------------------------------


--------------------------------------------------create------------------------------------------------
-- create table test(
-- id int primary key,
-- name varchar(50)
-- );

----------------------------------------------------alter--------------------------------------------
-- alter table test
-- add column city varchar(50);

-------------------------------------------------drop------------------------------------------------------
-- drop table test

-------------------------------------------------truncate-----------------------------------------------
-- truncate table test


------------------------------------------------insert---------------------------------------------------
-- insert into suppliers(supplier_id,country,supplier_reliability)
-- select distinct supplier_id,country,supplier_reliability
-- from shipment_raw on conflict(supplier_id) do nothing;


-- insert into products(product_type)
-- select distinct product_type
-- from shipment_raw
-- on conflict(product_type) do nothing;



-- insert into shipments(
-- shipment_id,supplier_id,product_id,monthly_demand_tons,shipment_volume_tons,
-- historical_delay_days,fuel_price_usd,transit_time_days,freight_cost_usd,
-- revenue_impact_usd,disruption_event
-- )
-- select shipment_raw.shipment_id,shipment_raw.supplier_id,products.product_id,
-- shipment_raw.monthly_demand_tons,shipment_raw.shipment_volume_tons,
-- shipment_raw.historical_delay_days,shipment_raw.fuel_price_usd,
-- shipment_raw.transit_time_days,shipment_raw.freight_cost_usd,
-- shipment_raw.revenue_impact_usd,shipment_raw.disruption_event
-- from shipment_raw
-- join products on shipment_raw.product_type=products.product_type
-- where shipment_raw.revenue_impact_usd>=0
-- on conflict(shipment_id) do nothing;


-- insert into shipment_risk(
-- shipment_id,route_risk_score,political_risk_index,port_congestion_index,
-- delay_probability,current_delay_days
-- )
-- select shipment_raw.shipment_id,shipment_raw.route_risk_score,
-- shipment_raw.political_risk_index,shipment_raw.port_congestion_index,
-- shipment_raw.delay_probability,shipment_raw.current_delay_days
-- from shipment_raw
-- join shipments on shipment_raw.shipment_id=shipments.shipment_id
-- where shipment_raw.delay_probability between 0 and 1
-- and shipment_raw.current_delay_days>=0
-- on conflict(shipment_id) do nothing;


-- insert into inventory(shipment_id,inventory_days,alternative_supplier_count)
-- select shipment_raw.shipment_id,shipment_raw.inventory_days,
-- shipment_raw.alternative_supplier_count
-- from shipment_raw
-- join shipments on shipment_raw.shipment_id=shipments.shipment_id
-- where shipment_raw.inventory_days>=0
-- on conflict(shipment_id) do nothing;


-------------------------------------------add_column---------------------------------------------------
-- alter table shipments
-- add column shipment_status varchar(30);

-------------------------------------------Update------------------------------------------------------
-- update shipments
-- set shipment_status='Delayed'
-- from shipment_risk
-- where shipments.shipment_id=shipment_risk.shipment_id
-- and shipment_risk.current_delay_days>0;

-- update shipments
-- set freight_cost_usd=freight_cost_usd*1.10
-- where freight_cost_usd is not null;

-- insert into suppliers(supplier_id,country,supplier_reliability)
-- values('TEST001','India',0.90);
-- delete from suppliers where supplier_id='TEST001';

----------------------------------------------Begin_commmit----------------------------------------------
-- begin;
-- update shipments
-- set freight_cost_usd=freight_cost_usd+1000
-- where shipment_id='SHP0001';
-- commit;


-----------------------------------------------begin_rollback---------------------------------------------
-- begin;

-- update shipments
-- set freight_cost_usd=5
-- where shipment_id='SHP0001';

-- rollback;

