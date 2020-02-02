-- ЗАДАНИЕ по теме “Операторы, фильтрация, сортировка и ограничение”
-- Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
-- Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10". Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.
-- В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако, нулевые запасы должны выводиться в конце, после всех записей.
-- (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий ('may', 'august')
-- (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.


DROP DATABASE IF EXISTS Shop;
CREATE DATABASE Shop;
USE Shop;

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');


--  ЗАДАНИЕ 1(первая часть): Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR 
 
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(255),
  updated_at VARCHAR(255)
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-01-04'),
  ('Наталья', '1984-01-11'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '2014-03-14');

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  description TEXT COMMENT 'Описание',
  price DECIMAL (11,2) COMMENT 'Цена',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id)
) COMMENT = 'Товарные позиции';

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1),
  ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12700.00, 1),
  ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 4780.00, 1),
  ('AMD FX-8320', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = 'Заказы';

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
  id SERIAL PRIMARY KEY,
  order_id INT UNSIGNED,
  product_id INT UNSIGNED,
  total INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных товарных позиций',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Состав заказа';

DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  product_id INT UNSIGNED,
  discount FLOAT UNSIGNED COMMENT 'Величина скидки от 0.0 до 1.0',
  started_at DATETIME,
  finished_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id),
  KEY index_of_product_id(product_id)
) COMMENT = 'Скидки';

DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Склады';

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) COMMENT = 'Запасы на складе';


 INSERT INTO storehouses_products 
 (storehouse_id, product_id, value) 
 VALUES
  ('1', '1', '40'),
  ('1', '2', '5'),
  ('1', '3', '5'),
  ('1', '4', '0'),
  ('1', '5', '0'),
  ('1', '6', '20'),
  ('1', '7', '23');
 

-- ЗАДАНИЕ 1: В таблице users поля created_at и updated_at оказались незаполненными. 
-- Заполните их текущими датой и временем (в формате "20.10.2017 8:10").

update shop.users  
set  
 created_at = substring(DATE_FORMAT(now(), '%d.%m.%Y %H:%i'), 1, 16),
 updated_at = substring(DATE_FORMAT(now(), '%d.%m.%Y %H:%i'), 1, 16)
;

-- ЗАДАНИЕ 2: Необходимо преобразовать поля created_at, updated_at таблицы users к типу DATETIME, сохранив введеные ранее значения.
-- Я создала два новых столбца с типом DATETIME, заполнила их, предварительно преобразовав строку в дату.
-- Затем удалила столбцы с типом VARCHAR и переименовала новые столбцы. 
-- В результате получились столбцы с типом DATETIME, значения сохранились, имена столбцов тоже сохранились.


ALTER TABLE shop.users ADD COLUMN created_at1 DATETIME DEFAULT NULL;
ALTER TABLE shop.users ADD COLUMN updated_at1 DATETIME DEFAULT NULL;

update shop.users  
set  
 created_at1 = STR_TO_DATE(created_at, '%d.%m.%Y  %H:%i'),
 updated_at1 = STR_TO_DATE(updated_at, '%d.%m.%Y  %H:%i')
;

ALTER TABLE shop.users drop COLUMN created_at;
ALTER TABLE shop.users drop COLUMN updated_at;

ALTER TABLE shop.users rename COLUMN created_at1 to created_at;
ALTER TABLE shop.users rename COLUMN updated_at1 to updated_at;


-- ЗАДАНИЕ 3: В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 
-- 0, если товар закончился и выше нуля, если на складе имеются запасы. 
-- Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. 
-- Однако, нулевые запасы должны выводиться в конце, после всех записей.

select 
* 
from storehouses_products
order by 
value = 0,
value
;

-- ЗАДАНИЕ 4: Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. 
-- Месяцы заданы в виде списка английских названий ('may', 'august')

select * from users 
where monthname(birthday_at) = 'may' or monthname(birthday_at) = 'august';


-- ЗАДАНИЕ 5: Из таблицы catalogs извлекаются записи при помощи запроса. 
-- SELECT * FROM catalogs WHERE id IN (5, 1, 2); 
-- Отсортируйте записи в порядке, заданном в списке IN


SELECT * FROM catalogs WHERE id IN (5, 1, 2)
order by
id=2, id=1, id=5
;


-- ЗАДАНИЕ по теме “Агрегация данных”
-- Подсчитайте средний возраст пользователей в таблице users
-- Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
-- Следует учесть, что необходимы дни недели текущего года, а не года рождения.
-- (по желанию) Подсчитайте произведение чисел в столбце таблицы

-- ЗАДАНИЕ 1: Подсчитайте средний возраст пользователей в таблице users

SELECT
  round(sum(TIMESTAMPDIFF(YEAR, birthday_at, NOW()))/count(id), 1) AS middle_age
FROM
  users;


-- ЗАДАНИЕ 2: Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
-- Следует учесть, что необходимы дни недели текущего года, а не года рождения.
 
select 
count(*) as Total,
dayname(concat(year(now()), DATE_FORMAT(birthday_at, '-%m-%d'))) as Year_Now
from
  users
 group by year_now;
 
-- ЗАДАНИЕ 3: Подсчитайте произведение чисел в столбце таблицы 

--  Пример с полем value (где есть значения = 0) - я предполагаю, что значений меньше нуля нет
SELECT 
case 
when exists(select * from storehouses_products where value=0) 
then 0
when not exists(select * from storehouses_products where value=0)
then EXP(SUM(LN(abs(value)))) 
end 
as value_pr FROM storehouses_products;

-- Пример с полем id (где нет значений = 0) - опять же предполагаю, что значений меньше нуля нет, 
-- если они могут быть в столбце, то запрос усложняется еще одной проверкой с подсчетом количества отрицательных значений
-- и, в зависимости от этого количества произведение или отрицательное или положительное. 
SELECT 
case 
when exists(select * from storehouses_products where id=0) 
then 0
when not exists(select * from storehouses_products where id=0)
then EXP(SUM(LN(abs(id)))) 
end 
as value_pr FROM storehouses_products;


