create database projects;
use projects;


select * from churn;
select * from customers;
select * from subscriptions;
select * from transactions;

select FirstName, LastName from customers;
-- retrive all cust from North America region
select * from customers where Region="North America";

select count(*) as total_customers from customers;

select count(*) as active_customers from customers where status="Active";

select count(*) as afterJan from customers where JoinDate>'01-01-2021';

select count(*) from customers where Region="Europe" and status="Active";

-- select count(*) as 2022pe from customers where JoinDate between '01-01-2022' and '31-12-2022';

select count(*) as 2022pe from customers where JoinDate like "%2022";

select concat(Firstname," ",Lastname) as Name from customers where Email='john.doe@example.com';

select * from customers where FirstName="Oscar" and LastName="Wright";

select * from subscriptions s join customers c on c.CustomerID=s.CustomerID where FirstName="Oscar" and LastName="Wright";

-- cal the avg amt of all transnactions
select avg(Amount) as Average from transactions;

-- retrive all trans where trans amt greater that 100
select count(*)  from transactions where Amount>100;

-- retrive all trans with customerId 10
select count(*)  from transactions where CustomerID=10;

-- Retrive all trans with firt and last , transId ,amonut

select c.FirstName, c.LastName,TransactionID,Amount from customers c join transactions t on c.CustomerID=t.CustomerID ;

-- retrive most recent trans
select * from transactions order by TransactionDate desc limit 5;

alter table transactions modify TransactionDate date;

select customerId , JoinDate from customers where str_to_date(JoinDate,"%d-%m-%y")  is null;

-- retrive reason for leaving customer
select distinct Reason as r from churn;

select Reason,count(*) as left_cust from churn group by Reason;

-- retirve customer details along with subscription
select c.CustomerID,c.FirstName,c.LastName,s.SubscriptionID,s.PlanType
from customers c 
join subscriptions s 
on c.CustomerID=s.CustomerID;

select PlanType, count(CustomerID) as count from subscriptions
group by PlanType;


-- Active cust along with Annual subscrption
select count(c.CustomerID),s.plantype
from customers c 
join subscriptions s 
on c.CustomerID=s.CustomerID
where s.PlanType="Annual" and c.Status="Active";

-- retrive leaving customer from company 
select count(CustomerID) from churn;
select count(CustomerID) from customers;

SELECT (SELECT COUNT(CustomerID) FROM churn) / (SELECT COUNT(CustomerID) FROM customers) * 100 AS churn_percentage;


-- You can disable safe mode for the current session 
SET SQL_SAFE_UPDATES = 0;

UPDATE customers
SET JoinDate = STR_TO_DATE(JoinDate, '%d-%m-%Y')
WHERE JoinDate like '%-%-%';

UPDATE transactions
SET TransactionDate = STR_TO_DATE(TransactionDate, '%d-%m-%Y')
WHERE TransactionDate like '%-%-%';

UPDATE subscriptions
SET EndDate = STR_TO_DATE(EndDate, '%d-%m-%Y')
WHERE EndDate like '%-%-%';


use projects;

-- retirve last 5 transtions 
select * from  transactions order by TransactionDate desc limit 5 ;


-- list the customer who not churn (left) the platform
select count(customerID) from customers
where customerId not in (select customerId from churn);

-- find customers and thier total spend
select customers.customerId,firstname ,lastname , sum(transactions.amount) as total_amount from customers
join transactions
on customers.customerID = transactions.customerID
group by customers.customerID,firstname,lastname;


-- find subcription that's eaxpiring 2022

select count(*) from subscriptions where year(enddate)=2022;

-- find all trans which are of type not renewal
select count(*) from transactions;

select count(*) from transactions where transactionType <>"Renewal";

-- which first customer joined us
select min(str_to_date(JoinDate,'%d-%m-%Y')) as ealy_join from customers ;

-- find the sub that ended in jan 2023
SELECT COUNT(*)
FROM subscriptions
WHERE endDate BETWEEN '2023-01-01' AND '2023-01-31';

-- find who not made ay tranctions
select count(customerID) as No_transactions from customers 
where customerId  not in (select customerId from transactions);

-- find the no of customers without subscription
select count(customerID) as without_sub from customers 
where customerId  not in (select customerId from subscriptions);

-- avg trnas_a mt for each customer

select customers.customerId,avg(amount) as average from transactions
join customers on customers.customerId = transactions.customerId
group by customers.customerId order by average;

-- find out top 3 regoings with most of the customer
select count(customerId) as c_count,region from customers
group by region
order by c_count desc
limit 3;

-- find total no of customers with multiple subscriptions

select customerId,count(customerId) as cnt from subscriptions
group by customerId
having cnt>1;

-- find the no of trans made in last 6 months

SELECT COUNT(transactionId) AS trans_count
FROM transactions
WHERE transactiondate >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

-- identify customer count who churned after having an annual plan
select count(c.customerId) as cnt from churn c
join subscriptions s on s.customerId= c.customerId
where s.planType="Annual";

-- find total revenue by region 
select c.region,sum(t.amount) as revenue from  customers c
join transactions t on t.customerId=c.customerId
group by c.region
order by revenue desc;

-- calculate revenue from active and inActive Customer
select sum(t.amount) as revenue from customers c
join transactions t on t.customerId=c.customerId
where c.status = "Active";

select sum(t.amount) as revenue from customers c
join transactions t on t.customerId=c.customerId
where c.status = "InActive";

-- find 5 longest serving customers 
select customerId,FirstName,lastname from customers
order by str_to_date(joinDate,"%d-%m-%y") asc
limit 3;

