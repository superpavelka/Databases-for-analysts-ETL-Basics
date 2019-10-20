/*SELECT SUM(t.price)
  FROM orders.orders_ t
JOIN 
  (
SELECT user_id, MIN(id_o) AS min_id -- SUM(price) s
  FROM orders.orders_
WHERE YEAR(o_date) = 2016 AND YEAR(o_date) = 2017
GROUP BY user_id ) tt
  ON t.id_o = tt.min_id

  UNION ALL   

SELECT SUM(price)
  FROM orders.orders_ 
  WHERE year(o_date) = 2016 AND MONTH(o_date) = 1



SELECT SUM(t.price)
  FROM orders.orders_ t
JOIN (
SELECT user_id, o_date, MIN(id_o) AS min_id 
  FROM orders.orders_
  WHERE YEAR(o_date) = 2016 OR YEAR(o_date) = 2017
  GROUP BY user_id ) tt
  ON t.user_id = tt.user_id AND (YEAR(t.o_date)=2016 AND MONTH(t.o_date) = 1)
                            AND (YEAR(tt.o_date)=2016 AND MONTH(tt.o_date) = 2)*/

SELECT SUM(price)
  FROM orders.orders_ o
  JOIN (
SELECT user_id, date_
  FROM (
 SELECT user_id, MIN(o_date) AS date_
  FROM orders.orders_
  GROUP BY user_id) t
  WHERE YEAR(t.date_) = 2016 AND MONTH(t.date_) = 2) tt
  ON (o.user_id = tt.user_id)
  WHERE YEAR(o_date) = 2017 AND MONTH(o_date) = 12

/*DELIMITER //
CREATE PROCEDURE mypro ()
SET @count := 1;
WHILE @count > 13 DO 
    SELECT SUM(price)
      FROM orders.orders_ o
      JOIN (
    SELECT user_id, date_
      FROM (
     SELECT user_id, MIN(o_date) AS date_
      FROM orders.orders_
      GROUP BY user_id) t
      WHERE YEAR(t.date_) = 2017 AND MONTH(t.date_) = 1) tt
      ON (o.user_id = tt.user_id)
      WHERE YEAR(o_date) = 2017 AND MONTH(o_date) = @count; 
      SET @count := @count + 1;
    END WHILE;
END//
mypro()*/
