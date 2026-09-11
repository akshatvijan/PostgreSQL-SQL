-- export
copy (
select *
from vw_critical_shipments
)
to 'C:\Users\Public\critical_shipments.csv'
with csv header;

copy (
select *
from vw_supplier_performance
)
to 'C:\Users\Public\supplier_summary.csv'
with csv header;

--import
create table critical_shipments_staging(
shipment_id varchar(20),
supplier_id varchar(20),
country varchar(50),
product_type varchar(50),
route_risk_score decimal(5,2),
political_risk_index decimal(5,2),
port_congestion_index decimal(5,2),
delay_probability decimal(4,2),
current_delay_days int,
inventory_days int
);

copy critical_shipments_staging
from 'C:\Users\Public\critical_shipments.csv'
with csv header;

create table supplier_summary_staging(
supplier_id varchar(20),
country varchar(50),
count bigint,
total_shipment_volume bigint,
avg_delay decimal(10,2),
avg_reliability decimal(10,2),
totol_freight_cost_usd decimal(12,2),
total_revenue_impact_usd decimal(12,2)
);

copy supplier_summary_staging
from 'C:\Users\Public\supplier_summary.csv'
with csv header;

-- count rows
select count(*)
from supplier_summary_staging;
select count(*)
from critical_shipments_staging;

-- count columns
select count(*)
from information_schema.columns
where table_name='critical_shipments_staging';

select count(*)
from information_schema.columns
where table_name='supplier_summary_staging';

--consistency
select *
from critical_shipments_staging
where route_risk_score<6
or delay_probability<0.5
or current_delay_days<3
or inventory_days>10;

--backup for data base in terminal
--"C:\Program Files\PostgreSQL\18\bin\pg_dump.exe" -U postgres -F c -d SupplyChainRiskDB -f "C:\Users\Public\SupplyChainRiskDB_full.backup"

--Schema-only Backup
--"C:\Program Files\PostgreSQL\18\bin\pg_dump.exe" -U postgres -d SupplyChainRiskDB --schema-only -f "C:\Users\Public\SupplyChainRiskDB_schema.sql"

--Data-only Backup
--"C:\Program Files\PostgreSQL\18\bin\pg_dump.exe" -U postgres -d SupplyChainRiskDB --data-only -f "C:\Users\Public\SupplyChainRiskDB_data.sql"

-- Restore database.
create database "SupplyChainRiskDB_Restore";
--"C:\Program Files\PostgreSQL\18\bin\pg_restore.exe" -U postgres -d SupplyChainRiskDB_Restore "C:\Users\Public\SupplyChainRiskDB_full.backup"

--craeting roles
create role supply_chain_admin;
create role supply_chain_analyst;
create role supply_chain_viewer;


grant all privileges on database "SupplyChainRiskDB" to supply_chain_admin;

grant select,insert,update
on all tables in schema public
to supply_chain_analyst;

grant select
on all tables in schema supply_chain
to supply_chain_viewer;


revoke update
on all tables in schema supply_chain
from supply_chain_analyst;

grant update
on all tables in schema supply_chain
to supply_chain_analyst;