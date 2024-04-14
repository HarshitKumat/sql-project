create database project;
use project;
alter table customerinfo
modify bankdoj date;

select * from activecustomer;
select * from bank_churn;
select * from creditcard;
select * from customerinfo;
select * from exitcustomer;
select * from gender;
select * from geography;

# 2. Identify the top 5 customers with the highest Estimated Salary in the last quarter of the year. (SQL)

select surname, estimatedsalary as Highest_Estimated_Salary
from customerinfo
where month(bankdoj) in ( 10, 11, 12)
order by estimatedsalary desc
limit 5
;

#3.	Calculate the average number of products used by customers who have a credit card. (SQL)

select avg(numofproducts) as average_number_of_product
from bank_churn 
where hascrcard = 1;

# 5. Compare the average credit score of customers who have exited and those who remain. (SQL)

select exited, avg(creditscore) as average_credit_score
from bank_churn
group by exited;

#6 Which gender has a higher average estimated salary, and how does it relate to the number of active accounts? (SQL)

select g.GenderCategory, round(avg(c.estimatedsalary), 2) as average_estimated_salary
from customerinfo c join gender g on c.genderid = g.genderid 
join bank_churn b on c.customerid = b.customerid
where b.isactivemember = 1
group by g.GenderCategory;

#7 Segment the customers based on their credit score and identify the segment with the highest exit rate. (SQL)

select 
case 
when CreditScore >= 800 then "Excellent"
when CreditScore between 740 and 799 then "Very Good"
when CreditScore between 670 and 739 then "Good"
when CreditScore between 580 and 669 then "Fair"
when CreditScore between 300 and 579 then "Poor"
else "Unknown" end as CreditScoreSegment,
count(Exited) as Count_of_Exited
from bank_churn
where exited = 1
group by CreditScoreSegment
order by Count_of_Exited desc
limit 1;

-- 8. Find out which geographic region has the highest number of active customers with a tenure greater than 5 years. (SQL)

select g.GeographyLocation, count(b.customerid) as Number_of_active_customers
from bank_churn b join customerinfo c on b.customerid = c.customerid
join geography g on c.geographyid = g.geographyid
where b.isactivemember = 1 and b.tenure > 5
group by g.geographylocation
order by Number_of_active_customers desc
limit 1;

#11.Examine the trend of customers joining over time and identify any seasonal patterns (yearly or monthly). Prepare the data through SQL and then visualize it.

select year(bankdoj) as year, month(bankdoj) as month, count(*) as joined_customer
from customerinfo 
group by year, month
order by year, month
;

#15.Using SQL, write a query to find out the gender-wise average income of males and females in each geography id. Also, rank the gender according to the average value. (SQL)

select c.geographyid, g.gendercategory, round(avg(c.estimatedsalary), 2) as average_income,
rank() over(partition by c.geographyid order by round(avg(c.estimatedsalary), 2) desc) as rnk
from customerinfo c join gender g on c.genderid = g.genderid
group by c.geographyid, g.gendercategory;


#16. Using SQL, write a query to find out the average tenure of the 
-- people who have exited in each age bracket (18-30, 30-50, 50+).

select 
case when c.age > 50 then "50+"
when c.age between 30 and 50 then "30-50"
else "18-29" end as age_bracket,
avg(b.tenure) as average_tenure
from customerinfo c join bank_churn b on c.customerid = b.customerid
where b.exited = 1 
group by  age_bracket;

-- 21. Rank the Locations as per the number of people who have churned
--  the bank and average balance of the customer.

select g.geographylocation, count(b.customerid) as Number_of_churn_people,
round(avg(b.balance), 2) as average_balance_of_customer,
rank() over(order by count(b.customerid) desc) as rnk
from bank_churn b join customerinfo c on b.customerid = c.customerid
join geography g on c.geographyid = g.geographyid
where b.exited = 1
group by g.geographylocation ;


-- 22. As we can see that the “CustomerInfo” table has the CustomerID and Surname, 
-- -- now if we have to join it with a table where the primary key is also a combination of CustomerID and Surname, come up with a column where the format is “CustomerID_Surname". 

SELECT 
CONCAT(c1.CustomerID, '_', c2.Surname) AS CustomerID_Surname
FROM customerinfo c1
JOIN 
   customerinfo c2 ON c1.CustomerID = c2.CustomerID AND c1.Surname = c2.Surname;

-- 23. Without using “Join”, can we get the “ExitCategory” from ExitCustomers table to Bank_Churn table? If yes do this using SQL.

select b.*, e.ExitCategory  from bank_churn b, exitcustomer e 
where b.exited = e.exitid;

#24.Write the query to get the customer IDs, their last name, and 
-- whether they are active or not for the customers whose surname ends with “on”.

select b.customerid, c.surname as last_name, a.activecategory 
from customerinfo c join bank_churn b on c.customerid = b.customerid
join activecustomer a on b.isactivemember = a.activeid
where c.surname like "%on";

-- 9. Utilize SQL queries to segment customers based on demographics and account details.
select case
when age between 18 and 30 then "18-30"
when age between 31 and 40 then "31-40"
when age between 41 and 50 then "41-51"
else "50+" end as age_group,
count(customerid) account_balance from customerinfo
group by age_group;
