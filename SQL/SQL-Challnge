-- 1️⃣ What is the total amount each customer spent at the restaurant?
SELECT sales.customer_id, SUM(menu.price) AS total_amount_spent
FROM sales
JOIN menu ON sales.product_id = menu.product_id
GROUP BY sales.customer_id
ORDER BY total_amount_spent DESC;

-- 2️⃣ How many days has each customer visited the restaurant?
SELECT customer_id, COUNT(DISTINCT order_date) AS visit_days
FROM sales
GROUP BY customer_id
ORDER BY visit_days DESC;

-- 3️⃣ What was the first item from the menu purchased by each customer?
WITH first_purchase AS (
    SELECT customer_id, product_id, order_date,
           RANK() OVER (PARTITION BY customer_id ORDER BY order_date) AS purchase_rank
    FROM sales
)
SELECT first_purchase.customer_id, menu.product_name
FROM first_purchase
JOIN menu ON first_purchase.product_id = menu.product_id
WHERE purchase_rank = 1;

-- 4️⃣ What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT menu.product_name, COUNT(sales.product_id) AS times_purchased
FROM sales
JOIN menu ON sales.product_id = menu.product_id
GROUP BY menu.product_name
ORDER BY times_purchased DESC
LIMIT 1;

-- 5️⃣ Which item was the most popular for each customer?
WITH customer_popularity AS (
    SELECT sales.customer_id, menu.product_name, COUNT(sales.product_id) AS purchase_count,
           RANK() OVER (PARTITION BY sales.customer_id ORDER BY COUNT(sales.product_id) DESC) AS rank_order
    FROM sales
    JOIN menu ON sales.product_id = menu.product_id
    GROUP BY sales.customer_id, menu.product_name
)
SELECT customer_id, product_name
FROM customer_popularity
WHERE rank_order = 1;

-- 6️⃣ Which item was purchased first by the customer after they became a member?
WITH first_after_membership AS (
    SELECT sales.customer_id, menu.product_name, sales.order_date,
           RANK() OVER (PARTITION BY sales.customer_id ORDER BY sales.order_date) AS rank_order
    FROM sales
    JOIN members ON sales.customer_id = members.customer_id
    JOIN menu ON sales.product_id = menu.product_id
    WHERE sales.order_date >= members.join_date
)
SELECT customer_id, product_name
FROM first_after_membership
WHERE rank_order = 1;

-- 7️⃣ Which item was purchased just before the customer became a member?
WITH last_before_membership AS (
    SELECT sales.customer_id, menu.product_name, sales.order_date,
           RANK() OVER (PARTITION BY sales.customer_id ORDER BY sales.order_date DESC) AS rank_order
    FROM sales
    JOIN members ON sales.customer_id = members.customer_id
    JOIN menu ON sales.product_id = menu.product_id
    WHERE sales.order_date < members.join_date
)
SELECT customer_id, product_name
FROM last_before_membership
WHERE rank_order = 1;

-- 8️⃣ What is the total items and amount spent for each member before they became a member?
SELECT sales.customer_id, COUNT(*) AS num_of_items, SUM(menu.price) AS total_price
FROM sales
LEFT JOIN members ON sales.customer_id = members.customer_id
LEFT JOIN menu ON sales.product_id = menu.product_id
WHERE sales.order_date < members.join_date
GROUP BY sales.customer_id;

-- 9️⃣ If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT sales.customer_id, 
       SUM(menu.price * 
           CASE 
               WHEN sales.product_id = 1 THEN 20  -- Sushi gets 2x points
               ELSE 10  -- All other items get 10 points per $1 spent
           END) AS total_points
FROM sales
LEFT JOIN menu ON sales.product_id = menu.product_id
GROUP BY sales.customer_id;

-- 🔟 In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
WITH points_calculation AS (
    SELECT sales.customer_id, sales.order_date, menu.price, members.join_date,
           CASE 
               WHEN sales.product_id = 1 THEN 20  -- Sushi gets 2x points
               ELSE 10  -- All other items get 10 points per $1 spent
           END AS base_points,
           CASE 
               WHEN sales.order_date BETWEEN members.join_date AND DATE_ADD(members.join_date, INTERVAL 6 DAY) THEN 2
               ELSE 1
           END AS multiplier
    FROM sales
    LEFT JOIN menu ON sales.product_id = menu.product_id
    LEFT JOIN members ON sales.customer_id = members.customer_id
)
SELECT customer_id, SUM(price * base_points * multiplier) AS total_points
FROM points_calculation
WHERE order_date <= '2021-01-31'
GROUP BY customer_id;
