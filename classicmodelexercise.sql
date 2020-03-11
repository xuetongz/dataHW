# Sigle entity
#1
SELECT *
FROM offices
ORDER BY country, state, city;
#2
SELECT COUNT(employeeNumber)
FROM employees;
#3
SELECT SUM(amount)
FROM payments;
#4
SELECT * 
FROM productlines
WHERE productLine LIKE "%Cars%";
#5
SELECT SUM(amount)
FROM payments
WHERE paymentDate = "2004-10-28";
#6
SELECT *
FROM Payments
WHERE amount > 100000;
#7
SELECT ProductName,productline
FROM products
GROUP BY productName,productLine;
#8
SELECT productLine,COUNT(productname)
FROM products
GROUP BY productLine;
#9
SELECT MIN(amount)
from payments;
SELECT *
FROM Payments
WHERE amount = (SELECT MIN(amount) 
                from payments);
#10
SELECT *
FROM payments
WHERE amount > (SELECT AVG(amount)
                FROM payments);
#11 What is the average percentage markup of the MSRP on buyPrice
SELECT productCODE, productName, round((MSRP-buyPrice)/buyprice*100,2) markup
FROM products;

#12
SELECT count(DISTINCT productCode)
FROM products;

#13
SELECT DISTINCT CustomerName, CITY
FROM customers
WHERE salesRepEmployeeNumber IS NULL;

#14
SELECT CONCAT(firstName," ", LastName)
FROM Employees
WHERE jobTitle like "%VP%" or jobTitle like "%Manager%";

#15
SELECT orderNumber, sum(priceEach*quantityOrdered) as total
FROM orderdetails
GROUP BY orderNumber
HAVING  total > 5000;

# One to many relationship
#1
SELECT c.customerName, concat(e.firstName," ", e.lastname)
FROM customers c,employees e
WHERE c.salesRepEmployeeNumber = e.employeeNumber;

#2
SELECT sum(amount)
FROM payments p, customers c
WHERE p.customerNumber = c.customerNumber and c.customerName = 'Atelier Graphique';

#3
SELECT paymentDate, sum(amount)
FROM payments
GROUP BY paymentDate;

#4 
Select distinct p.productCode, p.productName
from products p left join orderdetails o
on p.productCode = o.productCode and o.productCode is null;

#5 List the amount paid by each customer.
select customerNumber, sum(amount) as total
from payments
group by customerNumber;

#6 How many orders have been placed by Herkku Gifts
select o.customerNumber, count(o.orderNumber) as orderCount
from orders o join customers c on o.customerNumber = c.customerNumber
group by o.customerNumber;

#7 Who are the employees in Boston?
select concat(e.firstName, e.lastName) as name
from employees e,offices o 
where e.officeCode = o.officeCode and o.city = 'Boston';

#8 Report those payments greater than $100,000. Sort the report so the customer who made the highest payment appears first.

select p1.customerNumber,p1.checkNumber,p1.paymentDate,p1.amount
from payments p1 left join (select customerNumber, sum(amount) as totalPay
			  from payments
              group by customerNumber) p2 on p1.customerNumber = p2.customerNumber
where p1.amount > 100000
order by p2.totalpay;

#9 List the value of 'On Hold' orders
select o.orderNumber, o.status, sum(od.quantityOrdered * od.priceEach) value
from orders o join orderdetails od
where o.orderNumber = od.orderNumber and o.status = 'On Hold'
group by o.orderNumber;

#10 Report the number of orders 'On Hold' for each customer.
select c.customerNumber, c.customerName, count(o.orderNumber)
from customers c left join orders o on c.customerNumber = o.customerNumber  and o.status = 'On Hold'
group by c.customerNumber;

# Many to many relationship
#1 List products sold by order date.
select od.productCode, o.orderDate
from orders o, orderdetails od where o.orderNumber = od.orderNumber
order by o.orderdate;

#2 List the order dates in descending order for orders for the 1940 Ford Pickup Truck
select o.orderDate
from orders o, orderdetails od, products p
where o.orderNumber = od.orderNumber  and od.productCode = p.productCode and p.productName = '1940 Ford Pickup Truck'
order by o.orderDate DESC;

#3 List the names of customers and their corresponding order number where a particular 
#order from that customer has a value greater than $25,000?
select c.customerName, o.orderNumber
from orders o, orderdetails od, customers c
where o.orderNumber = od.orderNumber and o.customerNumber = c.customerNumber
group by c.customerNumber, o.orderNumber
having sum( od.priceEach * od.quantityOrdered)> 25000;

#4*** Are there any products that appear on all orders?


#5 List the names of products sold at less than 80% of the MSRP.
select distinct productName
from orderdetails od, products p
where od.productCode = p.productCode AND od.priceEach < 0.8*p.MSRP;

#6 Reports those products that have been sold with a markup of 100% or more (i.e.,  the priceEach is at least twice the buyPrice)
select distinct productName
from orderdetails od, products p
where od.productCode = p.productCode AND od.priceEach >= 2*p.buyPrice ;

#7 List the products ordered on a Monday.
select od.productCode
from orders o, orderdetails od
where o.orderNumber = od.orderNumber and dayofweek(o.orderDate) =2;

#8 What is the quantity on hand for products listed on 'On Hold' orders?
select  od.productcode,od.quantityOrdered
from orders o, orderdetails od
where o.orderNumber = od.orderNumber and o.status = 'On Hold';

#Regular expressions
#1. Find products containing the name 'Ford'
select productName
from products
where productName like '%Ford%';

#2. List products ending in 'ship'.
select productName
from products
where productName like '%ship';

#3. Report the number of customers in Denmark, Norway, and Sweden.
select country, count(customerNumber)
from customers
where country in ('Denmark','Norway','Sweden')
group by country;

#4. What are the products with a product code in the range S700_1000 to S700_1499?
select productName, productCode
from products
where productCode between 'S700_1000' and 'S700_1499';

#5. Which customers have a digit in their name?
select customerName
from customers
where customerName regexp '[0-9]';

#6. List the names of employees called Dianne or Diane.
select concat(lastName,' ',firstName)
from employees
where firstname in ('Dianne','Diane') or lastname in ('Dianne','Diane');

#7. List the products containing ship or boat in their product name.
select productName
from products
where productName like '%ship%' or productName like 'boat';

#8. List the products with a product code beginning with S700.
select *
from products
where productCode like 'S700%';

#9. List the names of employees called Larry or Barry.
select concat(firstname, ' ',lastname) as name 
from employees
where firstname like 'Larry' or firstname like 'Barry';

#10. List the names of employees with non-alphabetic characters in their names.
select concat(firstname, ' ',lastname) as name 
from employees
where firstname regexp '[^a-z]' or lastname regexp '[^a-z]';

#11. List the vendors whose name ends in Diecast
select Name
from vendors
where Name like '%Diecast';

#General queries
#1. Who is at the top of the organization (i.e.,  reports to no one).
select *
from employees
where reportsTo is Null;

#2. Who reports to William Patterson?
select e1.*
from employees e1,employees e2 
where e1.reportsTo = e2.EmployeeNumber and e2.firstName ='William' and e2.lastName = 'Patterson';

#3. List all the products purchased by Herkku Gifts.
select distinct od.productCode, p.productName
from orders as o, orderdetails as od, customers as c, products as p
where o.orderNumber = od.orderNumber and o.customerNumber = c.customerNumber and od.productCode = p.productCode and c.customerName = 'Herkku Gifts';

#4. Compute the commission for each sales representative, assuming the commission is 5% of the value of an order. Sort by employee last name and first name.
select e.employeeNumber, concat(e.firstName,' ', e.lastName) as Name, 0.05*sum(od.quantityOrdered*od.priceEach) as commission
from orders o, orderdetails od, customers c, employees e
where o.orderNumber = od.orderNumber and o.customerNumber = c.customerNumber and c.salesRepEmployeeNumber = e.employeeNumber
group by e.employeeNumber;

#5. What is the difference in days between the most recent and oldest order date in the Orders file?
select datediff(recent, oldest)
from
(select min(orderDate) as oldest, max(orderDate) as recent
from orders) as temp;

#6. Compute the average time between order date and ship date for each customer ordered by the largest difference.
select avg(datediff(shippedDate, orderDate)) as avg_diff
from orders
order by diff;

#7. What is the value of orders shipped in August 2004? (Hint).
select sum(od.quantityOrdered*od.priceEach)
from orders as o, orderdetails as od 
where o.ordernumber = od.ordernumber and month(shippedDate) = 8 and year(shippedDate) = 2004;

#8. Compute the total value ordered, total amount paid, and their difference for each customer for orders 
#   placed in 2004 and payments received in 2004 (Hint; Create views for the total paid and total ordered).
CREATE OR REPLACE  VIEW  totalOrdered2004 AS
	SELECT o.customerNumber, sum(od.priceEach * od.quantityOrdered) as totalOrdered
    FROM orders o, orderdetails od
	WHERE o.orderNumber = od.orderNumber AND YEAR(orderDate) = 2004
    GROUP BY o.customerNumber;
    
CREATE VIEW totalPayed2004 AS
	SELECT customerNumber, sum(amount) as totalPayed
    FROM Payments
    WHERE YEAR(paymentDate) = 2004
    GROUP BY customerNumber;
    
SELECT o.customerNumber, o.totalOrdered - p.totalPayed as diff
FROM totalOrdered2004 o, totalPayed2004 p
WHERE o.customerNumber = p.customerNumber;

#9 List the employees who report to those employees who report to Diane Murphy. Use the CONCAT function to combine 
# the employee's first name and last name into a single field for reporting.

SELECT concat(firstName, ' ', lastName)
FROM Employees
WHERE reportsto in
(SELECT e1.employeeNumber
FROM employees e1, employees e2
WHERE e1.reportsTo = e2.employeeNumber AND e2.firstName = 'Diane' AND e2.lastName = 'Murphy');

#10. What is the percentage value of each product in inventory sorted by the highest percentage first (Hint: Create a view first).

#11. Write a function to convert miles per gallon to liters per 100 kilometers.
DELIMITER $$
CREATE FUNCTION convert_mpg( 
	mpg DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
	DECLARE lp100km DECIMAL(10,2);
    SET lp100km = 100 * 3.785411784/1.609344/mpg;
    RETURN(lp100km);
END $$
DELIMITER ;

#12.Write a procedure to increase the price of a specified product category by a given percentage. You will need to create a product 
#table with appropriate data to test your procedure. Alternatively, load the ClassicModels database on your personal machine so you 
#have complete access. You have to change the DELIMITER prior to creating the procedure.
DELIMITER $$
CREATE PROCEDURE Increase_price(
IN category VARCHAR(255)
IN perct Decimal(10,2)
)
BEGIN
UPDATE products
SET MSRP = (1 + prect) * MSRP
WHERE productLine = category
END
DELIMITER ;

#14. What is the ratio the value of payments made to orders received for each month of 2004. 
# (i.e., divide the value of payments made by the orders received)?
WITH payment2004 AS(
SELECT MONTH(paymentDate) mon, SUM(amount) Payment_sum
FROM payments
WHERE YEAR(paymentDate) = 2004
GROUP BY MONTH(paymentDate)),
order_value2004 AS(
SELECT MONTH(o.orderDate) mon, SUM(PriceEach * QuantityOrdered) order_sum
FROM orders o, orderdetails od
WHERE o.orderNumber = od.orderNumber AND YEAR(o.orderDate) = 2004 
GROUP BY MONTH(o.orderDate))
SELECT o.mon, payment_sum/order_sum as ratio
FROM payment2004 p, order_value2004 o
WHERE p.mon = o.mon
ORDER BY o.mon;

#15. What is the difference in the amount received for each month of 2004 compared to 2003?
CREATE OR REPLACE VIEW payments2003
AS
SELECT MONTH(paymentDate) AS mon, SUM(amount) AS payment_sum
FROM payments
WHERE YEAR(paymentDate) = 2003
GROUP BY MONTH(paymentDate);

CREATE OR REPLACE VIEW payments2004
AS
SELECT MONTH(paymentDate) AS mon, SUM(amount) AS payment_sum
FROM payments
WHERE YEAR(paymentDate) = 2004
GROUP BY MONTH(paymentDate);

SELECT temp1.mon, temp2.payment_sum - temp1.payment_sum diff
FROM payments2003 AS temp1,payments2004 AS temp2
WHERE temp1.mon = temp2.mon
ORDER BY temp1.mon;

#16 Write a procedure to report the amount ordered in a specific month and year for customers containing a specified character string in their name.
DELIMITER $$
CREATE PROCEDURE monthlyOrder(
IN mon INT,
IN y  INT,
IN name_string Varchar(255),
OUT total_amount INT
)
BEGIN
	SELECT sun(od.quantityOrdered)
    INTO total_amount
    FROM customers c, orders o, orderdetails od
    WHERE c.customerNumber = o.customerNumber AND o.orderNumber = od.orderNumber 
    AND c.customerName = name_string AND Year(o.orderDate) = y AND MONTH(o.orderdate) = mon;
 END$$  
 DELIMITER ;

#17 Write a procedure to change the credit limit of all customers in a specified country by a specified percentage.
DELIMITER $$
CREATE PROCEDURE change_limit(
	IN thecountry VARCHAR(25),
    IN percentage DECIMAL(10,2)
    )
BEGIN
	UPDATE customers
    SET creditLimit = percentage *creditlimit
    WHERE country = thecountry;
END
DELIMITER ;

#18 Basket of goods analysis: A common retail analytics task is to analyze each basket or order to learn what products are often
# purchased together. Report the names of products that appear in the same order ten or more times.
with order_pairs as (
    select concat(t1.productCode,',', t2.productCode) as items, t1.orderNumber
    from 
    (select distinct productCode, orderNumber
    from orderDetails) as t1
    join
    (select distinct productCode, orderNumber
    from orderDetails) as t2
    ON 
    (
    t1.orderNumber = t2.orderNumber AND
    t1.productCode != t2.productCode AND
    t1.productCode < t2.productCode
    )
    )

    SELECT items, count(*) as frequency
    FROM order_pairs
    GROUP by items
    HAVING count(*) > 10
    ORDER BY frequency DESC;

#19 ABC reporting: Compute the revenue generated by each customer based on their orders. Also, show each customer's revenue as
# a percentage of total revenue. Sort by customer name.
With total_revenue AS (SELECT SUM(priceEach*quantityOrdered) as total
                      FROM orderdetails),
customer_revenue AS (SELECT o.customerNumber, SUM(priceEach*quantityOrdered) as c_total
                  FROM orders o join orderdetails od on o.orderNumber = od.orderNumber
                  GROUP BY o. customerNumber)
SELECT customerName, c.c_total as customerRevenue, c.c_total/ total
FROM customer_revenue c,total_revenue t,customers
WHERE customers.customerNumber = c.customerNumber
ORDER BY customerName;




#20. Compute the profit generated by each customer based on their orders. 
#Also, show each customer's profit as a percentage of total profit. Sort by profit descending.

SELECT o.customerNumber, sum((od.priceEach - p.buyPrice)*od.quantityOrdered) as profit
FROM Orders o, Orderdetails od, products p
WHERE o.orderNumber = od.orderNumber AND od.productCode = p.productCode
GROUP BY o.customerNumber;




#21. Compute the revenue generated by each sales representative based on the orders from the customers they serve.

SELECT c.salesRepEmployeeNumber, SUM(od.priceEach * od.quantityOrdered) as revenue
FROM customers c, orders o, orderdetails od
WHERE c.customerNumber = o.customerNumber AND o.orderNumber = od.orderNumber
GROUP BY c.SalesRepEmployeeNumber;

#22. Compute the profit generated by each sales representative based on the orders from the customers they serve. Sort by profit generated descending.

SELECT c.salesRepEmployeeNumber, SUM((od.priceEach-p.buyprice) * od.quantityOrdered) as profit
FROM customers c, orders o, orderdetails od, products p
WHERE c.customerNumber = o.customerNumber AND o.orderNumber = od.orderNumber AND p.productCode = od.productCode
GROUP BY c.SalesRepEmployeeNumber
ORDER BY profit DESC;

#23. Compute the revenue generated by each product, sorted by product name.
SELECT p.productname, SUM(od.priceEach * od.quantityOrdered) as revenue
FROM orderDetails od, products p
WHERE p.productCode = p.productCode
GROUP BY p.productCode
ORDER BY p.productName;
#24. Compute the profit generated by each product line, sorted by profit descending.
SELECT p.productLine, SUM((od.priceEach-p.buyprice) * od.quantityOrdered) as profit
FROM  orderdetails od, products p
WHERE  p.productCode = od.productCode
GROUP BY p.productLine
ORDER BY profit DESC;

#25 Same as Last Year (SALY) analysis: Compute the ratio for each product of sales for 2003 versus 2004.
With sales2003 AS(
SELECT productCode, SUM(priceEach* quantityOrdered) as sales
FROM orderdetails od join orders o on od.orderNumber = o.orderNumber
WHERE YEAR(o.orderDate) = 2003
GROUP BY productCode),
sales2004 AS(
SELECT productCode, SUM(priceEach* quantityOrdered) as sales
FROM orderdetails od join orders o on od.orderNumber = o.orderNumber
WHERE YEAR(o.orderDate) = 2004
GROUP BY productCode)
SELECT productName, s3.sales/s4.sales as sales_ratio
FROM products p LEFT JOIN sales2003 s3 on p.productCode = s3.productCode
LEFT JOIN sales2004 s4 on p.productCode = s4.productCode;


#26 Compute the ratio of payments for each customer for 2003 versus 2004.
WITH payment2003 AS(
SELECT customerNumber, sum(amount) as pay
FROM Payments
WHERE YEAR(paymentDate) = 2003
GROUP BY customerNumber 
),
payment2004 AS(
SELECT customerNumber, sum(amount) as pay
FROM Payments
WHERE YEAR(paymentDate) = 2004
GROUP BY customerNumber)
SELECT c.customerName, p3.pay/p4.pay as pay_ratio
FROM payment2003 p3 join payment2004 p4 on p3.customerNumber = p4.customerNumber
     join customers c on p3.customerNumber = c.customerNumber;

#27 Find the products sold in 2003 but not 2004.
SELECT distinct p.productName
FROM orders o, orderDetails od, products p
WHERE o.orderNumber = od.orderNumber AND od.productCode = p.productCode 
AND YEAR(o.orderdate) = 2003 AND od.productCode not in (SELECT od.productCode
														FROM orders o, orderdetails od
                                                        WHERE o.orderNumber = od.orderNumber AND YEAR(o.orderdate) = 2004);
#28 Find the customers without payments in 2003.
SELECT customerName
FROM customers 
WHERE customerNumber NOT IN (SELECT customerNumber
							FROM payments
                            WHERE YEAR(paymentDate) = 2003);
#Correlated subqueries
#1 Who reports to Mary Patterson?
SELECT concat(firstName, lastName) as name
FROM employees
WHERE reportsTO = (SELECT employeeNumber FROM employees where firstName = 'Mary' AND lastName = 'Patterson');

#2 Which payments in any month and year are more than twice the average for that month and year 
#(i.e. compare all payments in Oct 2004 with the average payment for Oct 2004)? 
#Order the results by the date of the payment. You will need to use the date functions.
SELECT *
FROM payments p1
WHERE p1.amount > 2*(SELECT AVG(p2.amount) 
				   FROM payments p2
                   WHERE year(p2.paymentDate) = year(p1.paymentDate) and month(p2.paymentDate) = month(p1.paymentDate));
                   


#3 Report for each product, the percentage value of its stock on hand as a percentage of the stock on hand for
# product line to which it belongs. Order the report by product line and percentage value within product line descending. 
# Show percentages with two decimal places.
SELECT p.productName, p.productLine, ROUND(quantityInstock/temp.stock_sum ,2) AS percentage
FROM products p JOIN (SELECT productline, SUM(quantityInStock) AS stock_sum
					  FROM products p1
                      GROUP BY productLine ) temp
ON p.productline = temp.productLine
ORDER BY p.productLine, percentage DESC;




#4 For orders containing more than two products, report those products that constitute more than 50% of the value of the order.
SELECT *
FROM orderdetails od
WHERE orderNumber  in (SELECT ordernumber FROM orderdetails GROUP BY ordernumber HAVING count(*)>2)
AND priceEach* quantityOrdered > 0.5* ( SELECT sum(priceEach*quantityOrdered) FROM orderdetails od2 where od2.orderNumber = od.orderNumber);



















