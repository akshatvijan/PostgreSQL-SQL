-- Find shipments whose freight cost is above the overall average.
select * from shipments 
where freight_cost_usd > (select avg(freight_cost_usd) from shipments);

-- Find shipments whose current delay is above the overall average.
select shipment_id from shipment_risk 
where current_delay_days > (select avg(current_delay_days) from shipment_risk);

-- Find suppliers whose reliability is below the overall average.
select * from suppliers 
where supplier_reliability < (select avg(supplier_reliability) from suppliers);

-- Find countries whose average route risk is above the global average.
select country from shipment_raw 
group by country
having avg(route_risk_score) > (select avg(route_risk_score) from shipment_raw);

-- Find shipments with the maximum revenue impact.
select * from shipments where revenue_impact_usd=(select max(revenue_impact_usd) from shipments);

-- Find the second-highest freight cost.
select max(freight_cost_usd) from shipments where freight_cost_usd<(select max(freight_cost_usd) from shipments);

-- Find shipments whose revenue impact is higher than their country's average.
select * from shipment_raw s
where revenue_impact_usd > (
select avg(revenue_impact_usd)
from shipment_raw
where country=s.country
);

-- Find shipments whose freight cost is higher than their product's average.
select * from shipment_raw s where freight_cost_usd > (select avg(freight_cost_usd) from shipment_raw where product_type=s.product_type);
-- Find the highest-risk shipment for each country.
select * from shipment_raw s where route_risk_score=(select max(route_risk_score) from shipment_raw where country=s.country);

-- Find suppliers whose average delay is greater than the overall average delay.
select supplier_id,avg(historical_delay_days)
from shipment_raw
group by supplier_id
having avg(historical_delay_days)>(
select avg(historical_delay_days)
from shipment_raw
);

--Convert numeric values into appropriate decimal precision
select cast (freight_cost_usd as DECIMAL(10,2)) from shipments;

--Calculate percentages
select cast(
sum(case when disruption_event=1 then 1 else 0 end)*100.0/count(*)
as decimal(5,2)
) from shipment_raw;


--Convert calculated values into integers/decimals
select cast(avg(historical_delay_days) as decimal(10,2))
from shipments;

--Format risk-related calculations
select cast(avg(route_risk_score) as decimal(5,2))
from shipment_risk;