--1. Revenue by Gender
--Business Question: Revenue by gender.
SELECT "Gender", 
       SUM("Purchase Amount (USD)") AS total_revenue
FROM customer
GROUP BY "Gender";

--2. Discount & Spending
--Business Question: Find discount users whose purchase is at or above overall average.
SELECT *
FROM customer
WHERE "Discount Applied" = 'Yes'
AND "Purchase Amount (USD)" >= (SELECT AVG("Purchase Amount (USD)") FROM customer);


--3. Product Rating
--Business Question: Top five items by average review rating.
SELECT "Item Purchased", 
       AVG("Review Rating") AS avg_rating
FROM customer
GROUP BY "Item Purchased"
ORDER BY avg_rating DESC
LIMIT 5;


--4. Shipping Analysis
--Business Question: Compare average purchase amount for Standard and Express.
SELECT "Shipping Type", 
       AVG("Purchase Amount (USD)") AS avg_purchase_amount
FROM customer
WHERE "Shipping Type" IN ('Standard', 'Express')
GROUP BY "Shipping Type";


--5. Subscription Analysis
--Business Question: Compare customer count, average spend, and total revenue by status.
SELECT "Subscription Status", 
       COUNT("Customer ID") AS customer_count, 
       AVG("Purchase Amount (USD)") AS avg_spend, 
       SUM("Purchase Amount (USD)") AS total_revenue
FROM customer
GROUP BY "Subscription Status";

--6. Discount Dependency
--Business Question: Top five items by percentage of records with discounts applied.
SELECT "Item Purchased",
       ROUND(100.0 * COUNT(CASE WHEN "Discount Applied" = 'Yes' THEN 1 END) / COUNT(*), 2) AS discount_percentage
FROM customer
GROUP BY "Item Purchased"
ORDER BY discount_percentage DESC
LIMIT 5;

--7. Customer Segmentation
--Business Question: Classify New, Returning, and Loyal using Previous Purchases.
SELECT "Customer ID", 
       "Previous Purchases",
       CASE 
           WHEN "Previous Purchases" = 0 THEN 'New'
           WHEN "Previous Purchases" BETWEEN 1 AND 14 THEN 'Returning'
           ELSE 'Loyal'
       END AS customer_segment
FROM customer;

--8. Product Popularity
--Business Question: Top three purchased items within each category using ROW_NUMBER().
WITH ranked_products AS (
    SELECT "Category", 
           "Item Purchased", 
           COUNT(*) AS purchase_count,
           ROW_NUMBER() OVER(PARTITION BY "Category" ORDER BY COUNT(*) DESC) AS rank
    FROM customer
    GROUP BY "Category", "Item Purchased"
)
SELECT "Category", 
       "Item Purchased", 
       purchase_count
FROM ranked_products
WHERE rank <= 3;

--9. Repeat Buyer Analysis
--Business Question: Subscription status among customers with more than five previous purchases.
SELECT "Subscription Status", 
       COUNT(*) AS customer_count
FROM customer
WHERE "Previous Purchases" > 5
GROUP BY "Subscription Status";

--10. Age Group Revenue
--Business Question: SUM(purchase_amount) grouped by age_group.
SELECT 
    CASE 
        WHEN "Age" < 31 THEN 'young_Adult'
        WHEN "Age" BETWEEN 31 AND 44 THEN 'Adult'
        WHEN "Age" BETWEEN 45 AND 57 THEN 'Middle_aged'
        ELSE 'Senior'
    END AS age_group,
    SUM("Purchase Amount (USD)") AS total_revenue
FROM customer
GROUP BY 1;
