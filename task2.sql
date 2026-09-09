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
