-------------------------------TASK8--------------------------------------


---------------------------------------------risk_classification_function-------------------

create or replace function risk_classification(
route_risk decimal,
delay_probability decimal,
current_delay int,
inventory_days int
)
returns varchar
as
$$
begin

if route_risk>=8
and delay_probability>=0.8
and current_delay>=10
and inventory_days<=5
then
return 'CRITICAL';

elsif route_risk>=7
and delay_probability>=0.6
and current_delay>=5
then
return 'HIGH';

elsif route_risk>=5
or delay_probability>=0.4
or current_delay>=3
then
return 'MEDIUM';

else
return 'LOW';

end if;

end
$$
language plpgsql;

select
shipment_id,
route_risk_score,
delay_probability,
current_delay_days,
inventory_days,
risk_classification(
route_risk_score,
delay_probability,
current_delay_days,
inventory_days
) as risk_classification
from vw_shipment_risk;


-----------------------------------------------Freight Risk Score----------------------------------------------------
create or replace function freight_risk_score(
shipment_vol decimal,
fuel_price decimal,
route_risk decimal
)
returns decimal
as 
$$
begin
return shipment_vol*fuel_price*route_risk;

end
$$
language plpgsql

select 
shipment_volume_tons,
fuel_price_usd,
route_risk_score ,
freight_risk_score(
shipment_volume_tons,
fuel_price_usd,
route_risk_score
) as freight_risk_score
from shipment_raw;



---------------------------------procedure_to_update_shipment_status----------------------------------------------------
create or replace procedure update_risk_classification(p_shipment_id varchar)
language plpgsql
as
$$
begin
update shipments set shipment_status=risk_classification(
(select route_risk_score from shipment_risk where shipment_id=p_shipment_id),
(select delay_probability from shipment_risk where shipment_id=p_shipment_id),
(select current_delay_days from shipment_risk where shipment_id=p_shipment_id),
(select inventory_days from inventory where shipment_id=p_shipment_id)

) 
where shipment_id=p_shipment_id;
end
$$;

call update_risk_classification('SHP0001');





-----------------------------------audit_table-----------------------------------------------------------------

create table shipment_audit(
shipment_id varchar(20),
old_value varchar(50),
new_value varchar(50),
operation varchar(50),
change_at timestamp default current_timestamp 
)


create or replace function update_shipment_information()
returns trigger
as 
$$
begin

if old.shipment_status is distinct from new.shipment_status
then
insert into shipment_audit(shipment_id,old_value,new_value,operation)
values(old.shipment_id,old.shipment_status,new.shipment_status,'Shipment status updated');
end if;

if old.freight_cost_usd is distinct from new.freight_cost_usd
then
insert into shipment_audit(shipment_id,old_value,new_value,operation)
values(old.shipment_id,old.freight_cost_usd::varchar,new.freight_cost_usd::varchar,'Freight cost updated');
end if;

if old.revenue_impact_usd is distinct from new.revenue_impact_usd
then
insert into shipment_audit(shipment_id,old_value,new_value,operation)
values(old.shipment_id,old.revenue_impact_usd::varchar,new.revenue_impact_usd::varchar,'Revenue impact updated');
end if;

if old.shipment_volume_tons is distinct from new.shipment_volume_tons
then
insert into shipment_audit(shipment_id,old_value,new_value,operation)
values(old.shipment_id,old.shipment_volume_tons::varchar,new.shipment_volume_tons::varchar,'Shipment volume updated');
end if;

if old.monthly_demand_tons is distinct from new.monthly_demand_tons
then
insert into shipment_audit(shipment_id,old_value,new_value,operation)
values(old.shipment_id,old.monthly_demand_tons::varchar,new.monthly_demand_tons::varchar,'Monthly demand updated');
end if;

return new;
end
$$
language plpgsql;


create trigger trigger_update_shipment_information
after update
on shipments
for each row
execute function update_shipment_information();


update shipments
set shipment_status='VERY HIGH',
freight_cost_usd=freight_cost_usd+500,
revenue_impact_usd=revenue_impact_usd+1000,
shipment_volume_tons=shipment_volume_tons+100,
monthly_demand_tons=monthly_demand_tons+200
where shipment_id='SHP0001';


select * from shipment_audit;



-----------------------------------validation_trigger-----------------------------------------------------------------

create or replace function validate_shipment()
returns trigger
as
$$
begin

if new.shipment_volume_tons<0
then
raise exception 'Shipment volume cannot be negative';
end if;

if new.freight_cost_usd<0
then
raise exception 'Freight cost cannot be negative';
end if;

return new;

end
$$
language plpgsql;


create trigger trigger_validate_shipment
before insert or update
on shipments
for each row
execute function validate_shipment();




insert into shipments(shipment_id,supplier_id,product_id,shipment_volume_tons,freight_cost_usd)
values('TEST001','SUP001',1,-100,5000);
