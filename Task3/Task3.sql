-- все пользователи Vip
SELECT COUNT(user_id), SUM(s)
  FROM
(
SELECT user_id,r,f,m,s,
  CASE WHEN (r = 3 AND f =3 AND m = 3) OR (r = 2 AND f =3 AND m = 3) THEN "Vip"
       WHEN r = 1 THEN "Lost"
  ELSE "Regular" END AS user_group
  FROM
(
SELECT user_id,SUM(price) s,
  CASE WHEN TIMESTAMPDIFF(DAY,MAX(o_date),date('2017-12-31')) > 60 THEN "1"
       WHEN TIMESTAMPDIFF(DAY,MAX(o_date),date('2017-12-31')) <= 60 AND TIMESTAMPDIFF(DAY,o_date,date('2017-12-31')) > 30 THEN "2"
  ELSE "3" END AS r,
  CASE WHEN COUNT(*) <= 1 THEN "1"
       WHEN COUNT(*) > 1 AND COUNT(*) <= 4 THEN "2"
  ELSE "3" END AS f,
  CASE WHEN SUM(price) < 5000 THEN "1"
       WHEN SUM(price) >= 5000 AND SUM(price) < 15000 THEN "2"
  ELSE "3" END AS m
  FROM orders.orders_
  GROUP BY user_id
) t_rfm
GROUP BY user_id) t_groups
  WHERE user_group = "Vip"

-- все пользователи Lost
SELECT COUNT(user_id), SUM(s)
  FROM
(
SELECT user_id,r,f,m,s,
  CASE WHEN (r = 3 AND f =3 AND m = 3) OR (r = 2 AND f =3 AND m = 3) THEN "Vip"
       WHEN r = 1 THEN "Lost"
  ELSE "Regular" END AS user_group
  FROM
(
SELECT user_id,SUM(price) s,
  CASE WHEN TIMESTAMPDIFF(DAY,MAX(o_date),date('2017-12-31')) > 60 THEN "1"
       WHEN TIMESTAMPDIFF(DAY,MAX(o_date),date('2017-12-31')) <= 60 AND TIMESTAMPDIFF(DAY,o_date,date('2017-12-31')) > 30 THEN "2"
  ELSE "3" END AS r,
  CASE WHEN COUNT(*) <= 1 THEN "1"
       WHEN COUNT(*) > 1 AND COUNT(*) <= 4 THEN "2"
  ELSE "3" END AS f,
  CASE WHEN SUM(price) < 5000 THEN "1"
       WHEN SUM(price) >= 5000 AND SUM(price) < 15000 THEN "2"
  ELSE "3" END AS m
  FROM orders.orders_
  GROUP BY user_id
) t_rfm
GROUP BY user_id) t_groups
  WHERE user_group = "Lost"

-- все пользователи Regular
SELECT COUNT(user_id), SUM(s)
  FROM
(
SELECT user_id,r,f,m,s,
  CASE WHEN (r = 3 AND f =3 AND m = 3) OR (r = 2 AND f =3 AND m = 3) THEN "Vip"
       WHEN r = 1 THEN "Lost"
  ELSE "Regular" END AS user_group
  FROM
(
SELECT user_id,SUM(price) s,
  CASE WHEN TIMESTAMPDIFF(DAY,MAX(o_date),date('2017-12-31')) > 60 THEN "1"
       WHEN TIMESTAMPDIFF(DAY,MAX(o_date),date('2017-12-31')) <= 60 AND TIMESTAMPDIFF(DAY,o_date,date('2017-12-31')) > 30 THEN "2"
  ELSE "3" END AS r,
  CASE WHEN COUNT(*) <= 1 THEN "1"
       WHEN COUNT(*) > 1 AND COUNT(*) <= 4 THEN "2"
  ELSE "3" END AS f,
  CASE WHEN SUM(price) < 5000 THEN "1"
       WHEN SUM(price) >= 5000 AND SUM(price) < 15000 THEN "2"
  ELSE "3" END AS m
  FROM orders.orders_
  GROUP BY user_id
) t_rfm
GROUP BY user_id) t_groups
  WHERE user_group = "Regular"

-- все пользователи
SELECT COUNT(DISTINCT user_id)
  FROM orders.orders_
-- вся прибыль
SELECT SUM(price)
 FROM orders.orders_


