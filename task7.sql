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

create view vw_critical_shipments as
select *
from vw_shipment_risk
where route_risk_score>=7
and delay_probability>=0.7
and current_delay_days>=5
and inventory_days<=7;


-- avg_delay
select * from vw_supplier_performance where avg_delay>5

--route_risk_score
select * from vw_shipment_risk where route_risk_score>7

--political_risk_index
select * from vw_shipment_risk where political_risk_index>7;

--total_revenue_impact
select * from vw_supplier_performance where total_revenue_impact>1000000;

--inventory_days
select * from vw_shipment_risk where inventory_days<7;










