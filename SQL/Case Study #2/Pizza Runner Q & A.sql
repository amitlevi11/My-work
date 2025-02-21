

-- 1. How many pizzas were ordered?
SELECT COUNT(*) AS total_pizzas_ordered
FROM customer_orders;



-- 2. How many unique customer orders were made?
SELECT COUNT(DISTINCT order_id) AS unique_customer_orders
FROM customer_orders;



-- 3. How many successful orders were delivered by each runner?
SELECT runner_id,
       COUNT(*) AS successful_orders
FROM runner_orders
WHERE cancellation IS NULL OR cancellation IN ('', 'null')
GROUP BY runner_id;


-- 4. How many of each type of pizza was delivered?
SELECT pn.pizza_name,
       COUNT(*) AS delivered_count
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
JOIN runner_orders ro ON ro.order_id = co.order_id
WHERE ro.cancellation IS NULL OR ro.cancellation IN ('', 'null')
GROUP BY pn.pizza_name;



-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT co.customer_id,
       pn.pizza_name,
       COUNT(*) AS order_count
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
GROUP BY co.customer_id, pn.pizza_name;



-- 6. What was the maximum number of pizzas delivered in a single order?
SELECT MAX(num_pizzas) AS max_pizzas
FROM (
  SELECT order_id, COUNT(*) AS num_pizzas 
  FROM customer_orders 
  GROUP BY order_id
) AS sub;



-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT co.customer_id,
       SUM(CASE 
             WHEN (co.exclusions IS NULL OR co.exclusions IN ('', 'null'))
              AND (co.extras IS NULL OR co.extras IN ('', 'null'))
             THEN 1 ELSE 0 
           END) AS no_change,
       SUM(CASE 
             WHEN NOT ((co.exclusions IS NULL OR co.exclusions IN ('', 'null'))
                   AND (co.extras IS NULL OR co.extras IN ('', 'null')))
             THEN 1 ELSE 0 
           END) AS with_change
FROM customer_orders co
JOIN runner_orders ro ON ro.order_id = co.order_id
WHERE ro.cancellation IS NULL OR ro.cancellation IN ('', 'null')
GROUP BY co.customer_id;



-- 8. How many pizzas were delivered that had both exclusions and extras?
SELECT COUNT(*) AS delivered_with_both_changes
FROM customer_orders co
JOIN runner_orders ro ON ro.order_id = co.order_id
WHERE (ro.cancellation IS NULL OR ro.cancellation IN ('', 'null'))
  AND (co.exclusions IS NOT NULL AND co.exclusions NOT IN ('', 'null'))
  AND (co.extras IS NOT NULL AND co.extras NOT IN ('', 'null'));



-- 9. What was the total volume of pizzas ordered for each hour of the day?
SELECT EXTRACT(HOUR FROM order_time) AS order_hour,
       COUNT(*) AS volume
FROM customer_orders
GROUP BY EXTRACT(HOUR FROM order_time)
ORDER BY order_hour;



-- 10. What was the volume of orders for each day of the week?
SELECT TO_CHAR(order_time, 'Day') AS order_day,
       COUNT(*) AS volume
FROM customer_orders
GROUP BY TO_CHAR(order_time, 'Day')
ORDER BY order_day;
