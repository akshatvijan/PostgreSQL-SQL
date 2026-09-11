------------------------TASK4--------------------------------------

-----------------------------supplier_and_shipment------------------

select c1.*,c2.* from shipments c1
join suppliers c2 on c1.supplier_id=c2.supplier_id;

-------------------------------Product_Performance-------------------------------------
select c1.*,c2.* from shipments c1
join products c2 on c1.product_id=c2.product_id;


----------------------------------Critical_Shipment_Report---------------------------------------
select c1.*,c2.* from shipments c1
join shipment_risk c2 on c1.shipment_id=c2.shipment_id;



----------------------supplier_products_shipments____________________________
select suppliers.supplier_id,suppliers.country,products.product_id,products.product_type,shipments.shipment_id,shipments.monthly_demand_tons
from shipments join suppliers on shipments.supplier_id=suppliers.supplier_id
join products on products.product_id=shipments.product_id




------------------------Left_join__________________________________
select c1.*,c2.* from shipments c1
left join suppliers c2 
on c1.supplier_id=c2.supplier_id


---------------------right_join________________________________________
select c1.*,c2.* from shipments c1
right join suppliers c2 
on c1.supplier_id=c2.supplier_id





------------------------full-outer_join____________________________________
select c1.*,c2.*
from shipments c1
full outer join products c2
on c1.product_id=c2.product_id;


------------------------------------cross_join-----------------------------
select c1.*,c2.*
from shipments c1
cross join products c2;