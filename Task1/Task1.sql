SELECT COUNT(*)
FROM orders.orders_

SELECT COUNT(*), COUNT(DISTINCT id_o), COUNT(DISTINCT user_id)
FROM orders.orders_

SELECT DISTINCT YEAR(o_date), MONTH(o_date)
  FROM orders.orders_

SELECT YEAR(o_date), MONTH(o_date), SUM(price), COUNT(DISTINCT id_o), COUNT(DISTINCT user_id)
 FROM orders.orders_
 GROUP BY YEAR(o_date), MONTH(o_date)

SELECT COUNT(DISTINCT user_id) 
FROM orders.orders_
WHERE user_id IN 
  (
  SELECT DISTINCT user_id
   FROM orders.orders_
   WHERE YEAR(o_date) = 2016)
   AND user_id NOT IN 
  (
  SELECT DISTINCT user_id
   FROM orders.orders_
   WHERE YEAR(o_date) = 2017)
 

SELECT DISTINCT user_id
FROM orders.orders_
WHERE YEAR(o_date) = 2016

SELECT DISTINCT user_id
FROM orders.orders_
WHERE YEAR(o_date) = 2017

SELECT COUNT(DISTINCT user_id)
 FROM orders.orders_
 WHERE YEAR(o_date) = 2016 

SELECT COUNT(DISTINCT user_id)
 FROM orders.orders_
 WHERE YEAR(o_date) = 2017 

SELECT DISTINCT user_id, COUNT(DISTINCT id_o)
  FROM orders.orders_
  GROUP BY user_id 



SELECT WEEKDAY(o_date), SUM(price) AS S FROM orders.orders_ GROUP BY WEEKDAY(o_date) ORDER BY S DESC;