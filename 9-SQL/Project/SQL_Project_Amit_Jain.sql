/*
Question 1. Write a query to display customer full name with their title (Mr/Ms), 
both first name and last name are in upper case, customer email id, 
customer creation date and display customer’s category after applying below 
categorization rules: 
1) IF customer creation date Year <2005 Then Category A 
2) IF customer creation date Year >=2005 and <2011 Then Category B 
3) IF customer creation date Year>= 2011 Then Category C 
*/

select -- as per requirement, converting first name and lasy name into upper case
concat(case oc.CUSTOMER_GENDER 
			when  'M' then 'Mr. '  
			when 'F' then 'Mrs. ' end,upper(oc.CUSTOMER_FNAME),' ',upper(oc.CUSTOMER_LNAME)) as 'Full_Name', 
	oc.CUSTOMER_EMAIL,
	CUSTOMER_CREATION_DATE , 
	case when extract(year from CUSTOMER_CREATION_DATE) < 2005 then 'Category A'
	when extract(year from CUSTOMER_CREATION_DATE) >=2005 and extract(year from CUSTOMER_CREATION_DATE ) < 2011 then 'Category B'
	when extract(year from CUSTOMER_CREATION_DATE) >=2011 then 'Category C ' 
	end as customer_category
from online_customer oc


/*
Question  #2. Write a query to display the following information for the products, which have not been sold: 
product_id, product_desc, product_quantity_avail, product_price, inventory values 
(product_quantity_avail*product_price), New_Price after applying discount as per below criteria. 
Sort the output with respect to decreasing value of Inventory_Value. 
1) IF Product Price > 20,000 then apply 20% discount 
2) IF Product Price > 10,000 then apply 15% discount 
3) IF Product Price =< 10,000 then apply 10% discoun
*/

select p.PRODUCT_ID , 
		p.PRODUCT_DESC , 
		p.PRODUCT_QUANTITY_AVAIL,
		p.PRODUCT_PRICE , 
		(p.PRODUCT_QUANTITY_AVAIL*PRODUCT_PRICE) as 'INVENTORY_VALUE', 
		PRODUCT_PRICE - (case when p.PRODUCT_PRICE > 20000 then 0.2
						when p.PRODUCT_PRICE > 10000 then 0.15
						when p.PRODUCT_PRICE <= 10000 then 0.1 end ) * PRODUCT_PRICE as NEW_PRICE
from product p
where not exists (select 1 
				from order_items oi 
				where oi.PRODUCT_ID =p.PRODUCT_ID)	
order by p.PRODUCT_QUANTITY_AVAIL*PRODUCT_PRICE  desc


/*
 Question #3. Write a query to display Product_class_code, Product_class_description, Count of Product type in  each product 
class, Inventory Value (p.product_quantity_avail*p.product_price). Information should be  displayed for only those product_class_code which have more than 1,00,000 
Inventory Value. Sort the output with respect to decreasing value of Inventory_Value. 
# NOTE: TABLES to be used - PRODUCT_CLASS, PRODUCT_CLASS_CODE]
*/

select pc.PRODUCT_CLASS_CODE , 
pc.PRODUCT_CLASS_DESC , 
count(product_id) 'PRODUCT_COUNT',
sum(p.PRODUCT_QUANTITY_AVAIL * p.PRODUCT_PRICE) as 'INVENTORY_VALUE'
from product_class pc 
join product p on (p.PRODUCT_CLASS_CODE=pc.PRODUCT_CLASS_CODE)
group by pc.PRODUCT_CLASS_DESC
having sum(p.PRODUCT_QUANTITY_AVAIL * p.PRODUCT_PRICE ) > 100000
order by sum(p.PRODUCT_QUANTITY_AVAIL * p.PRODUCT_PRICE)  desc;


/*
 Question 4. Write a query to display customer_id, full name, customer_email, 
customer_phone and country of customers who have cancelled all the orders placed by them 
 (USE SUB-QUERY)[NOTE: TABLES to be used - ONLINE_CUSTOMER, ADDRESSS, ORDER_HEADER]
*/

select  oc.CUSTOMER_ID ,
concat(oc.CUSTOMER_FNAME ,' ',oc.CUSTOMER_LNAME ) as full_name,
oc.CUSTOMER_EMAIL ,
oc.CUSTOMER_PHONE ,
a.COUNTRY 
from online_customer oc 
join address a on (a.ADDRESS_ID  = oc.ADDRESS_ID)
where oc.CUSTOMER_ID  in (select oh.CUSTOMER_ID  
							from order_header oh  
							where oh.ORDER_STATUS='Cancelled') -- this condition to check Customer's order has been cancelled
and not exists (select oh.CUSTOMER_ID  
							from order_header oh  
							where oh.ORDER_STATUS<>'Cancelled'
							and oc.CUSTOMER_ID = oh.CUSTOMER_ID ) 
							-- this condition to check Customer, whose order status is different from cancelled

/*
Question 5. Write a query to display Shipper name, City to which it is catering, 
num of customer catered by the shipper in the city and number of consignments delivered to that 
city for Shipper DHL [NOTE: TABLES to be used - SHIPPER,ONLINE_CUSTOMER, ADDRESSS, ORDER_ITEMS]
*/


select s.SHIPPER_NAME  , 
a.CITY , 
-- Number of customers catered by the shipper in the city, take distinct count of customer, as same customer can order multiple times
count(distinct oh.CUSTOMER_ID) as customer_counts,
-- One order can contain mutiple Products to deliver and consider each Product type as one single Consignment
count(oh.ORDER_ID) consignments_count 
from SHIPPER s
join order_header oh on (oh.SHIPPER_ID = s.SHIPPER_ID)
join online_customer oc on (oc.CUSTOMER_ID = oh.CUSTOMER_ID )
join address a on (a.ADDRESS_ID=oc.ADDRESS_ID)
where s.SHIPPER_NAME ='DHL'
group by s.SHIPPER_ID , s.SHIPPER_NAME  , a.CITY 


/*
#6. Write a query to display product_id, product_desc, product_quantity_avail, quantity sold, quantity 
available and 
 show inventory Status of products as below as per below condition: 
 a. For Electronics and Computer categories, if sales till date is Zero then show 
 'No Sales in past, give discount to reduce inventory', if inventory quantity is less than 10% of 
quantity sold, 
 show 'Low inventory, need to add inventory', if inventory quantity is less than 50% of quantity 
sold, 
 show 'Medium inventory, need to add some inventory', if inventory quantity is more or equal to 
50% of quantity sold, 
 show 'Sufficient inventory' 
 b. For Mobiles and Watches categories, if sales till date is Zero then show 
 'No Sales in past, give discount to reduce inventory', if inventory quantity is less than 20% of 
quantity sold, 
show 'Low inventory, need to add inventory', if inventory quantity is less than 60% of quantity 
sold, 
show 'Medium inventory, need to add some inventory', if inventory quantity is more or equal to 
60% of quantity sold, 
show 'Sufficient inventory'
c. Rest of the categories, if sales till date is Zero then show 
'No Sales in past, give discount to reduce inventory', if inventory quantity is less than 30% of 
quantity sold,

 show 'Low inventory, need to add inventory', if inventory quantity is less than 70% of quantity 
sold, 
 show 'Medium inventory, need to add some inventory', if inventory quantity is more or equal to 
70% of quantity sold, 
show 'Sufficient inventory' 
(USE SUB-QUERY) 
[NOTE: TABLES to be used - PRODUCT, PRODUCT_CLASS, ORDER_HEADER]
*/



select p.PRODUCT_ID ,
p.PRODUCT_DESC ,
p.PRODUCT_QUANTITY_AVAIL,
ps.QUANTITY_SOLD, 
case when pc.PRODUCT_CLASS_DESC in ('Electronics','Computer') then 
		case when ps.QUANTITY_SOLD = 0 or ps.product_id is null then 'No Sales in past, give discount to reduce inventory'
			when p.PRODUCT_QUANTITY_AVAIL <  (ps.QUANTITY_SOLD - ps.QUANTITY_SOLD*0.5) then 'Medium inventory, need to add some inventory'
			when p.PRODUCT_QUANTITY_AVAIL <  (ps.QUANTITY_SOLD - ps.QUANTITY_SOLD*0.1) then 'Low inventory, need to add inventory'
		else 'Sufficient inventory' end 
when pc.PRODUCT_CLASS_DESC in ('Mobiles','Watches') then 
		case when ps.QUANTITY_SOLD = 0 or ps.product_id is null then 'No Sales in past, give discount to reduce inventory'
			when p.PRODUCT_QUANTITY_AVAIL <  (ps.QUANTITY_SOLD - ps.QUANTITY_SOLD*0.6) then 'Medium inventory, need to add some inventory'
			when p.PRODUCT_QUANTITY_AVAIL <  (ps.QUANTITY_SOLD - ps.QUANTITY_SOLD*0.2) then 'Low inventory, need to add inventory'
		else 'Sufficient inventory' end
else 
	case when ps.QUANTITY_SOLD = 0 or ps.product_id is null then 'No Sales in past, give discount to reduce inventory'
			when p.PRODUCT_QUANTITY_AVAIL <  (ps.QUANTITY_SOLD - ps.QUANTITY_SOLD*0.7) then 'Medium inventory, need to add some inventory'
			when p.PRODUCT_QUANTITY_AVAIL <  (ps.QUANTITY_SOLD - ps.QUANTITY_SOLD*0.3) then 'Low inventory, need to add inventory'
	else 'Sufficient inventory' end
end as inventory_status
from product p 
left outer join (select sum(PRODUCT_QUANTITY) QUANTITY_SOLD , PRODUCT_ID 
				from order_items
				group by PRODUCT_ID ) as ps 
		on (p.PRODUCT_ID = ps.PRODUCT_ID )
join product_class pc on (pc.PRODUCT_CLASS_CODE= p.PRODUCT_CLASS_CODE )


/*
Question 7. Write a query to display order_id and volume of the biggest order (in terms of volume) that can fit 
in carton id 10 
 [NOTE: TABLES to be used - CARTON, ORDER_ITEMS, PRODUCT]
  */
  
select oi.ORDER_ID , 
sum(p.LEN * p.WIDTH * p.HEIGHT * oi.PRODUCT_QUANTITY)  volume_of_the_biggest_order
from order_items oi 
join product p on (oi.PRODUCT_ID=p.PRODUCT_ID)
group by oi.ORDER_ID
having sum(p.LEN * p.WIDTH * p.HEIGHT * oi.PRODUCT_QUANTITY) < ( select c.LEN * c.WIDTH * c.HEIGHT  carton_volume
																 from carton c 
																 where CARTON_ID =10)
order by sum(p.LEN * p.WIDTH * p.HEIGHT * oi.PRODUCT_QUANTITY) desc
limit 1


/*
#Question 8. Write a query to display customer id, customer full name, total quantity and total value 
(quantity*price) shipped 
where mode of payment is Cash and customer last name starts with 'G' 
[NOTE: TABLES to be used - ONLINE_CUSTOMER, ORDER_ITEMS, PRODUCT, 
ORDER_HEADER]
*/

select oc.CUSTOMER_ID , 
concat(oc.CUSTOMER_FNAME ,' ',oc.CUSTOMER_LNAME ) as full_name,
sum(oi.PRODUCT_QUANTITY),
sum(oi.PRODUCT_QUANTITY*p.PRODUCT_PRICE )
from online_customer oc 
join order_header oh on (oh.CUSTOMER_ID = oc.CUSTOMER_ID)
join order_items oi  on (oh.ORDER_ID =oi.ORDER_ID )
join product p on (p.PRODUCT_ID = oi.PRODUCT_ID )
where CUSTOMER_LNAME like 'G%'
and oh.PAYMENT_MODE ='Cash'
group by oc.CUSTOMER_ID ,  oc.CUSTOMER_FNAME, oc.CUSTOMER_LNAME



/*#Question 9. Write a query to display product_id, product_desc and total quantity of products 
 which are sold together with product id 201 and are not shipped to city Bangalore and New Delhi. 
 Display the output in descending order with respect to tot_qty. 
 (USE SUB-QUERY) 
 [NOTE: TABLES to be used - order_items, product,order_head, online_customer, address]
 */
 
select oi2.PRODUCT_ID, p.PRODUCT_DESC ,  sum(oi2.PRODUCT_QUANTITY ) total_quantity_of_products
from order_items oi2
join product p on (p.PRODUCT_ID = oi2.PRODUCT_ID)
join order_header oh on (oh.ORDER_ID =oi2.ORDER_ID ) 
join online_customer oc on (oc.CUSTOMER_ID = oh.CUSTOMER_ID )
join address a on (a.ADDRESS_ID = oc.ADDRESS_ID )
-- check if product is included with orders, which have 201 product_id
where exists (  select 1 
			 from order_items oi 
			 where oi.PRODUCT_ID =201
			 and oi.ORDER_ID = oi2.ORDER_ID) 
and oi2.PRODUCT_ID <>201  -- exclude same product id as 201
-- and oh.ORDER_STATUS ='Shipped'
and a.CITY not in ('New Delhi','Bangalore')
group by oi2.PRODUCT_ID , p.PRODUCT_DESC 
order by sum(oi2.PRODUCT_QUANTITY ) desc

 
/*
Question: 10 Write a query to display the order_id,customer_id and customer fullname 
as total quantity of products shipped for order ids which are even 
and shipped to address where pincode is not starting with "5" 
[NOTE: TABLES to be used - online_customer,Order_header, order_items,address] 
*/

select oh.order_id , 
oc.CUSTOMER_ID , 
concat(oc.CUSTOMER_FNAME ,' ',oc.CUSTOMER_LNAME ) as full_name,
sum(oi.PRODUCT_QUANTITY) as total_quantity_of_products_shipped
from online_customer oc
join address a on (a.ADDRESS_ID = oc.ADDRESS_ID)
join order_header oh on (oh.CUSTOMER_ID = oc.CUSTOMER_ID)
join order_items oi on (oh.ORDER_ID = oi.ORDER_ID)
where a.PINCODE not like '5%'  -- condition to check PinCode not starting with 5
and oh.ORDER_ID %2 = 0  -- condition to check if order id is EVEN
and oh.ORDER_STATUS ='Shipped' -- condition to check if order has been shipped
group by oh.order_id , 
oc.CUSTOMER_ID , 
concat(oc.CUSTOMER_FNAME ,' ',oc.CUSTOMER_LNAME ) 

