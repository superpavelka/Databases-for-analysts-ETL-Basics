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
-- “ќ до 0517
SELECT SUM(price)
    FROM orders.orders_before_0517

-- табличка дл€ первой группы
SELECT user_id, CEIL(AVG(price)) a, 
                SUM(price) s, 
                TIMESTAMPDIFF(DAY, MIN(o_date), MAX(o_date)) days, 
                30/TIMESTAMPDIFF(DAY, MIN(o_date),MAX(o_date))/(COUNT(id_o)-1) a_d, 
                COUNT(id_o) c,
                MAX(o_date) max_date,
                30 * CEIL(30/TIMESTAMPDIFF(DAY, MIN(o_date),MAX(o_date))/(COUNT(id_o)-1)* AVG(price)) sum_per_month
           FROM orders.orders_before_0517
            GROUP BY user_id
            HAVING c >= 3 AND max_date > date('2017-04-01') AND days > 3
            ORDER BY sum_per_month DESC

-- сумма пользователей 1 группы за мес€ц
SELECT SUM(t.sum_per_month)
  FROM
  (
  SELECT user_id, CEIL(AVG(price)) a, 
                SUM(price) s, 
                TIMESTAMPDIFF(DAY, MIN(o_date), MAX(o_date)) days, 
                30/TIMESTAMPDIFF(DAY, MIN(o_date),MAX(o_date))/(COUNT(id_o)-1) a_d, 
                COUNT(id_o) c,
                MAX(o_date) max_date,
                30 * CEIL(30/TIMESTAMPDIFF(DAY, MIN(o_date),MAX(o_date))/(COUNT(id_o)-1)* AVG(price)) sum_per_month
           FROM orders.orders_before_0517
            GROUP BY user_id
            HAVING c >= 3 AND max_date > date('2017-04-01') AND days > 5
  ) t
-- табличка дл€ второй группы
SELECT user_id, CEIL(AVG(price)) a, 
                SUM(price) s, 
                TIMESTAMPDIFF(DAY, MIN(o_date), MAX(o_date)) days, 
                30/TIMESTAMPDIFF(DAY, MIN(o_date),MAX(o_date))/(COUNT(id_o)-1) a_d, 
                COUNT(id_o) c,
                MAX(o_date) max_date,
                30 * CEIL(30/TIMESTAMPDIFF(DAY, MIN(o_date),MAX(o_date))/(COUNT(id_o)-1)* AVG(price)) sum_per_month
           FROM orders.orders_before_0517
            GROUP BY user_id
            HAVING c >= 3 AND max_date < date('2017-04-01') AND days > 3
            ORDER BY sum_per_month DESC
-- сумма пользователей 2 группы за мес€ц + lost
SELECT SUM(t.sum_per_month)
  FROM
  (
  SELECT user_id, CEIL(AVG(price)) a, 
                SUM(price) s, 
                TIMESTAMPDIFF(DAY, MIN(o_date), MAX(o_date)) days, 
                30/TIMESTAMPDIFF(DAY, MIN(o_date),MAX(o_date))/(COUNT(id_o)-1) a_d, 
                COUNT(id_o) c,
                MAX(o_date) max_date,
                30 * CEIL(30/TIMESTAMPDIFF(DAY, MIN(o_date),MAX(o_date))/(COUNT(id_o)-1)* AVG(price)) sum_per_month
           FROM orders.orders_before_0517
            GROUP BY user_id
            HAVING c >= 3 AND max_date <= date('2017-04-01') AND max_date > date('2017-02-01') AND days > 5
  ) t



SELECT user_id, CEIL(AVG(price)) a, 
                SUM(price) s, 
                TIMESTAMPDIFF(DAY, MIN(o_date), MAX(o_date)) days, 
                30/TIMESTAMPDIFF(DAY, MIN(o_date),MAX(o_date))/(COUNT(id_o)-1) a_d, 
                COUNT(id_o) c,
                MAX(o_date) max_date,
                30 * CEIL(30/TIMESTAMPDIFF(DAY, MIN(o_date),MAX(o_date))/(COUNT(id_o)-1)* AVG(price)) sum_per_month
           FROM orders.orders_before_0517
            GROUP BY user_id
            HAVING c = 2 AND max_date > date('2017-04-01') 
            ORDER BY sum_per_month DESC

-- количество пользователей купивших в 3 мес€це первый раз и купивших в 4 мес€це второй раз
SELECT COUNT(user_id)
    FROM
    (
      SELECT user_id, COUNT(id_o) c,
             MAX(o_date) max_date,
             MIN(o_date) min_date
        FROM orders.orders_before_0517
        GROUP BY user_id
            HAVING c = 2 AND max_date >= date('2017-04-01') AND min_date >= date('2017-03-01') AND min_date < date('2017-04-01')
    ) t
-- количество пользователей купивших во 2 мес€це первый раз и не купивших более
SELECT COUNT(user_id)
    FROM
    (
      SELECT user_id,o_date, COUNT(id_o) c
        FROM orders.orders_before_0517
        GROUP BY user_id
            HAVING c = 1  AND date(o_date) > date('2017-02-01') AND date(o_date) < date('2017-03-01')
    ) t

-- количество пользователей купивших в 3 мес€це первый раз и купивших до 5 мес€ца еще 2 раза
SELECT COUNT(user_id)
    FROM
    (
      SELECT user_id, COUNT(id_o) c,
             MAX(o_date) max_date,
             MIN(o_date) min_date
        FROM orders.orders_before_0517
        GROUP BY user_id
            HAVING c = 3 AND max_date >= date('2017-04-01') AND min_date >= date('2017-03-01') AND min_date < date('2017-04-01')
    ) t

  -- количество пользователей купивших со 2 мес€ца по 3 два раза и не купивших более
SELECT COUNT(user_id)
    FROM
    (
      SELECT user_id, COUNT(id_o) c,
             MAX(o_date) max_date,
             MIN(o_date) min_date
        FROM orders.orders_before_0517
        GROUP BY user_id
            HAVING c = 2 AND max_date > date('2017-02-01') AND min_date > date('2017-02-01') 
                         AND max_date < date('2017-03-01') AND min_date < date('2017-03-01')
    ) t

-- количество и сумма чека пользователей купивших в 4 мес€це 1 раз

    SELECT COUNT(user_id) c_u, SUM(s) s_s
    FROM
      (
      SELECT o_date,user_id,
             COUNT(id_o) c, SUM(price) s
        FROM orders.orders_before_0517
        GROUP BY user_id
            HAVING c = 1 AND date(o_date) >= date('2017-04-01') 
       ) t

  -- количество и сумма чека пользователей купивших в 4 мес€це 2 раза

    SELECT COUNT(user_id) c_u, SUM(s) s_s
    FROM
      (
      SELECT MIN(o_date) min_date,
             MAX(o_date) max_date,  
              user_id,
             COUNT(id_o) c, SUM(price) s
        FROM orders.orders_before_0517
        GROUP BY user_id
            HAVING c = 2 AND min_date >= date('2017-04-01') AND max_date >= date('2017-04-01')
       ) t

-- —умма за 5 мес€ц 17 года
SELECT SUM(price)
  FROM orders.orders_
  WHERE date(o_date) >= date('2017-05-01') AND date(o_date) < date('2017-06-01')
