-- запросы с вебинара

CREATE TABLE user_cog2
SELECT user_id,  DATE_FORMAT(MIN(o_date),"%y%m") AS cog -- min_od
  FROM orders_20190822 
  GROUP BY user_id;

SELECT u.cog,DATE_FORMAT((o.o_date),"%y%m"), SUM(price) s
  FROM orders_20190822 o 
  JOIN user_cog2 u
  ON o.user_id = u.user_id
GROUP BY u.cog,DATE_FORMAT((o.o_date),"%y%m");

CREATE TABLE t
SELECT id_u, tel AS cont
  FROM users
  UNION ALL 
SELECT id_u, email
  FROM users;

SELECT t.id_u,MIN(t2.id_u)
  FROM t join t AS t2
  ON t.cont = t2.cont
  GROUP BY t.id_u;

SELECT COUNT(DISTINCT user_id)
  FROM orders.orders_ 
      WHERE year(o_date) = 2017 AND MONTH(o_date) = 6 
  AND user_id IN
(
SELECT user_id 
  FROM orders.orders_ 
      WHERE date(o_date) < date('2017-06-01') -- TIMESTAMPDIFF(DAY,o_date,date('2017-06-01')) < 0
      GROUP BY user_id  
  HAVING COUNT(id_o) >= 3);

USE orders;
-- таблица заказов до 05.17
CREATE TABLE orders_before_0517
  SELECT * 
  FROM orders.orders_
  WHERE date(o_date) < date('2017-05-01')
-- ТО до 0517
SELECT SUM(price)
    FROM orders.orders_before_0517

SELECT user_id, AVG(price) s_price, 
       CEIL((30 / ((TIMESTAMPDIFF(DAY, MIN(o_date), MAX(o_date))) / (COUNT(id_o) - 1))) * AVG(price))
    FROM (
          SELECT user_id, price, o_date, id_o
           FROM orders.orders_before_0517
            GROUP BY user_id
            HAVING COUNT(id_o) >= 3 AND MAX(date(o_date)) > date('2017-04-01')
          ) t

SELECT user_id,  
       CEIL( (30 * s) / days ) s_per_month       
    FROM
    (
SELECT user_id, CEIL(AVG(price)) a, SUM(price) s, TIMESTAMPDIFF(DAY, MIN(o_date), MAX(o_date)) days, COUNT(id_o) c,MAX(o_date) max_date
           FROM orders.orders_before_0517
            GROUP BY user_id
            HAVING c >= 3 AND max_date > date('2017-04-01') AND days > 5
            ORDER BY days 
  ) t
GROUP BY user_id
ORDER BY s_per_month DESC

-- табличка для первой группы
SELECT user_id, CEIL(AVG(price)) a, 
                SUM(price) s, 
                TIMESTAMPDIFF(DAY, MIN(o_date), MAX(o_date)) days, 
                30/TIMESTAMPDIFF(DAY, MIN(o_date),MAX(o_date))/(COUNT(id_o)-1) a_d, 
                COUNT(id_o) c,
                MAX(o_date) max_date,
                CEIL(30/TIMESTAMPDIFF(DAY, MIN(o_date),MAX(o_date))/(COUNT(id_o)-1)* AVG(price)) sum_per_month
           FROM orders.orders_before_0517
            GROUP BY user_id
            HAVING c >= 3 AND max_date > date('2017-04-01') AND days > 5
            ORDER BY sum_per_month DESC