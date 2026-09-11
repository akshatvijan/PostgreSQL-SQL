set search_path to supply_chain;

select
v.shipment_id as "Shipment ID",
v.supplier_id as "Supplier",
v.country as "Country",
v.product_type as "Product",
s.shipment_volume_tons as "Shipment Volume",
v.route_risk_score as "Route Risk",
v.political_risk_index as "Political Risk",
v.port_congestion_index as "Port Congestion",
sup.supplier_reliability as "Supplier Reliability",
v.inventory_days as "Inventory Days",
s.transit_time_days as "Transit Time",
v.delay_probability as "Delay Probability",
v.current_delay_days as "Current Delay",
s.freight_cost_usd as "Freight Cost",
s.revenue_impact_usd as "Revenue Impact",

risk_classification(
v.route_risk_score,
v.delay_probability,
v.current_delay_days,
v.inventory_days
) as "Risk Classification",

round(
(
(v.route_risk_score/10)*20
+(v.political_risk_index/10)*15
+(v.port_congestion_index/10)*15
+(v.delay_probability*20)
+(least(v.current_delay_days/30,1)*10)
+(greatest(1-sup.supplier_reliability/100,0)*10)
+(greatest(1-v.inventory_days/30,0)*5)
),
2
) as "Supply Chain Risk Score",

case
when v.route_risk_score>=9
and v.delay_probability>=0.8
and v.current_delay_days>=10
then 'critical'

when v.route_risk_score>=8
and v.delay_probability>=0.75
then 'high'

when v.route_risk_score>=7
then 'medium'

else 'low'
end as "Final Risk Level",

(
select avg(s2.freight_cost_usd)
from shipments s2
) as "Average Freight Cost"

from vw_shipment_risk v

inner join shipments s
on v.shipment_id=s.shipment_id

inner join suppliers sup
on v.supplier_id=sup.supplier_id

where v.shipment_id in (
select shipment_id
from vw_critical_shipments
)

order by "Supply Chain Risk Score" desc

limit 20;