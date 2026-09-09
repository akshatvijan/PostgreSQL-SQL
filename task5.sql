-- maximum_shipment_vol

select supplier_id,sum(
shipment_volume_tons
)as max_vol from shipments 
group by supplier_id
order by max_vol desc
limit 1;

--highest revenue impac
select supplier_id,sum(revenue_impact_usd)
from shipments group by supplier_id
order by sum(revenue_impact_usd) desc
limit 1;

--highest revenue impac

select supplier_id,avg(historical_delay_days)
from shipments group by supplier_id
order by avg(historical_delay_days) desc
limit 1;

--below-average reliability

select * from suppliers 
where supplier_reliability < (select avg(supplier_reliability) from suppliers);

--suppliers have more than 5 shipments

select supplier_id,count(*) from shipments
group by supplier_id 
having count(*)>5;

--country has the highest average route risk

select country,avg(route_risk_score) from shipment_raw
group by country order by avg(route_risk_score) desc
limit 1;

--country has the highest political risk

select country,avg(political_risk_index) from shipment_raw
group by country order by avg(political_risk_index) desc
limit 1;

--country has the highest total revenue impact
select country,sum(revenue_impact_usd) from shipment_raw
group by country order by sum(revenue_impact_usd) desc
limit 1;

--average shipment delay by country
select country,avg(historical_delay_days) from shipment_raw
group by country ;

-- product has the highest total demand

select product_type,sum(monthly_demand_tons) from shipment_raw
group by product_type order by sum(monthly_demand_tons) desc limit 1;


-- product has the highest average freight cost
select product_type,avg(freight_cost_usd) from shipment_raw
group by product_type order by avg(freight_cost_usd) desc limit 1;

--product has the highest number of disruptions
select product_type,sum(disruption_event) from shipment_raw
group by product_type order by sum(disruption_event) desc limit 1;

--percentage of shipments experienced a disruption


select round(sum(case when disruption_event=1 then 1 else 0 end )*100/
count(*),2) from shipment_raw;

--total revenue impact
select sum(revenue_impact_usd) from shipment_raw;

--average shipment delay
select avg(historical_delay_days) from shipment_raw;




