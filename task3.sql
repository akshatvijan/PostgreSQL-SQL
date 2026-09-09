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

