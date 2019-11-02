-- orders только с первым по дате заказом
USE orders
CREATE TABLE orders_min_date
SELECT id_o,user_id,price,MIN(o_date) min_date
  FROM orders.orders_
  GROUP BY user_id
-- basket  только с последним по дате вставки заказом
USE orders
CREATE TABLE o_in_b_max_ins_date
SELECT ORDER_ID,MAX(DATE_INSERT) max_date
  FROM orders.basket16
  GROUP BY ORDER_ID
-- сджойнил user16-17 и orders только с первым заказом
SELECT u.u_id u_id,u.DATE_REGISTER date_reg,o.user_id,o.id_o id_o, o.min_date o_date
  FROM orders.user16 u
  JOIN orders.orders_min_date o
  WHERE u.u_id = o.user_id 
-- пытаюсь сджойнить с баскетом
SELECT u_id, date_reg, id_o, o_date,max_date
  FROM
  (
SELECT u.u_id u_id,u.DATE_REGISTER date_reg,o.user_id,o.id_o id_o, o.min_date o_date
  FROM orders.user16 u
  JOIN orders.orders_min_date o
  WHERE u.u_id = o.user_id )t
  JOIN orders.o_in_b_max_ins_date tt
  WHERE t.id_o = tt.ORDER_ID


-- корзина с минимальной датой вставки по заказу
USE orders
CREATE TABLE b_min_d
SELECT ORDER_ID, MIN(DATE_INSERT) min_d
  FROM basket16  
  GROUP BY ORDER_ID
-- корзина с максимальной датой вставки по заказу
USE orders
CREATE TABLE b_max_d
SELECT ORDER_ID, MAX(DATE_INSERT) max_d
  FROM basket16  
  GROUP BY ORDER_ID

-- среднее время между минимальной и максимальной датой вставки по заказу
SELECT AVG(dt) avg_dt
  FROM
  (
SELECT ORDER_ID, MAX(DATE_INSERT) - MIN(DATE_INSERT) dt
  FROM basket16  
  GROUP BY ORDER_ID
  ) t

SELECT user_id,MIN(o_date)
  FROM orders.orders_
  WHERE id_o NOT IN 
  (
  SELECT user_id FROM
  (
  SELECT user_id,MIN(id_o) 
  FROM orders.orders_
  GROUP BY user_id
  ) t

  ) GROUP BY user_id

SELECT COUNT(user_id)
  FROM(
 SELECT user_id,MIN(o_date)
  FROM orders.orders_
  WHERE id_o NOT IN (
  SELECT user_id FROM
  (
  SELECT user_id,MIN(id_o) 
  FROM orders.orders_
  GROUP BY user_id
  ) t
  ) 
  GROUP BY user_id) tt

SELECT COUNT(user_id)
  FROM
  (
SELECT first.user_id, DATEDIFF(second.second_date,first.first_date) days_diff
  FROM (SELECT o.user_id, MIN(o.o_date) AS second_date
  FROM orders.orders_ o
  LEFT JOIN (SELECT o1.user_id, MIN(o1.o_date) AS first_date
  FROM orders.orders_ o1
  GROUP BY o1.user_id) f
  ON o.user_id = f.user_id AND o.o_date = f.first_date
  WHERE f.user_id IS NULL AND f.first_date IS NULL
  GROUP BY o.user_id) second
  INNER JOIN (SELECT o1.user_id, MIN(o1.o_date) AS first_date
  FROM orders.orders_ o1
  GROUP BY o1.user_id) first
  ON first.user_id = second.user_id 
  ) t
  WHERE days_diff = 11