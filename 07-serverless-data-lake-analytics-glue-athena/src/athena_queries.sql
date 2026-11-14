-- Query 1: Daily Revenue by Store Location
SELECT 
    store_id, 
    date_trunc('day', transaction_time) AS sale_day,
    COUNT(transaction_id) AS total_orders,
    ROUND(SUM(amount), 2) AS total_sales
FROM "saa_p7_retail_db"."curated_sales"
GROUP BY store_id, date_trunc('day', transaction_time)
ORDER BY total_sales DESC;

-- Query 2: High Value Transactions
SELECT transaction_id, customer_id, amount, payment_method
FROM "saa_p7_retail_db"."curated_sales"
WHERE amount > 500.00
ORDER BY amount DESC;
