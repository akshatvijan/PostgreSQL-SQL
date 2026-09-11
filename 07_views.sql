-------------------------------TASK7--------------------------------------

create or replace view vw_supplier_performance 
as
select s.supplier_id,s.country,count(sh.shipment_id),
sum(sh.shipment_volume_tons) as total_shipment_volume,
round(avg(sh.historical_delay_days),2) as avg_delay,
round(avg(s.supplier_reliability),2) as avg_reliability,
sum(sh.freight_cost_usd) as totol_freight_cost_usd,
sum(sh.revenue_impact_usd) as total_revenue_impact_usd
from suppliers s join shipments sh on s.supplier_id=sh.supplier_id
group by s.supplier_id,s.country;

select * from vw_supplier_performance;


create or replace view vw_shipment_risk
as
select 
ship.shipment_id,
sup.supplier_id,
sup.country,
prod.product_type,
risk.route_risk_score,
risk.political_risk_index,
risk.port_congestion_index,
risk.delay_probability,        
risk.current_delay_days,
i.inventory_days
from shipments ship 
join suppliers sup on sup.supplier_id=ship.supplier_id 
join products prod on prod.product_id=ship.product_id
join shipment_risk risk on risk.shipment_id=ship.shipment_id
join inventory i on i.shipment_id=ship.shipment_id

select * from vw_shipment_risk

drop view if exists vw_critical_shipments;

create view vw_critical_shipments as
select *
from vw_shipment_risk
where route_risk_score>=6
and delay_probability>=0.5
and current_delay_days>=3
and inventory_days<=10;




--Highest Route Risk
select 
shipment_id,
supplier_id,
country,product_type,
route_risk_score
from vw_shipment_risk
order by route_risk_score desc;

--Highest Political Risk
select 
shipment_id,
supplier_id,
country,
product_type,
political_risk_index
from vw_shipment_risk
order by political_risk_index desc;

--Highest Port Congestion
select 
shipment_id,
supplier_id,
country,
product_type,
port_congestion_index
from vw_shipment_risk
order by port_congestion_index desc;

--Highest Delay Probability
select 
shipment_id,
supplier_id,
country,
product_type,
delay_probability
from vw_shipment_risk
order by delay_probability desc;

--Highest Current Delay with Lowest Inventory
select 
shipment_id,
supplier_id,
country,
product_type,
current_delay_days,
inventory_days
from vw_shipment_risk
order by current_delay_days desc,inventory_days asc;










