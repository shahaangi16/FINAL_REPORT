use sales;

-- Customers Table
CREATE TABLE customerss(
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
    signup_date DATE
);

-- Products Table
CREATE TABLE pproductss(
    product_id INT PRIMARY KEY ,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

-- Orders Table
CREATE TABLE orderss(
    order_ids INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customerss(customer_id)
);

-- Order Items Table
CREATE TABLE order_itemss(
    order_item_id INT PRIMARY KEY ,
    order_ids INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_ids) REFERENCES orderss(order_ids),
    FOREIGN KEY (product_id) REFERENCES pproductss(product_id)
);

-- Customers
INSERT INTO customerss(customer_id,name, email, city, signup_date)VALUES
(123,'Alice Smith', 'alice@example.com', 'New York', '2024-01-15'),
(456,'Bob Johnson', 'bob@example.com', 'Los Angeles', '2024-02-20'),
(789,'Carol Lee', 'carol@example.com', 'Chicago', '2024-03-18'),
(213,'David Kim', 'david@example.com', 'Houston', '2024-04-05'),
(324,'Eva Brown', 'eva@example.com', 'Phoenix', '2024-05-10');

-- Products
INSERT INTO pproductss( product_id,name, category, price)VALUES
(140,'Laptop', 'Electronics', 1200.00),
(141,'Smartphone', 'Electronics', 800.00),
(142,'Headphones', 'Accessories', 150.00),
(143,'Monitor', 'Electronics', 300.00),
(144,'Keyboard', 'Accessories', 70.00);

-- Orders
INSERT INTO orderss(order_ids,customer_id, order_date, total_amount)VALUES
(130,1, '2024-05-20', 1350.00),
(131,2, '2024-05-22', 800.00),
(132,1, '2024-06-01', 1270.00),
(133,3, '2024-06-03', 370.00),
(134,4, '2024-06-10', 300.00);

-- Order Items
INSERT INTO order_itemss(order_item_id,order_ids, product_id, quantity, price)VALUES
(201,130, 140, 1, 1200.00),  -- Alice, Laptop
(202,131, 144, 1, 150.00),   -- Alice, Headphones
(203,130, 143, 3, 800.00),   -- Bob, Smartphone
(204,134, 140, 1, 800.00),   -- Alice, Smartphone
(205,133, 142, 2, 70.00),    -- Alice, 2 Keyboards
(206,132, 141, 4, 300.00),   -- Carol, Monitor
(207,131, 143, 1, 70.00),    -- Carol, Headphones
(208,130, 144, 1, 300.00);   -- David, Monitor

select * from order_itemss;
select * from orderss;

# TOTAL SALES PER MONTH
select
	DATE_FORMAT(order_date, '%Y-%m') as month,
    sum(total_amount) as total_sales
from orderss
group by month
order by month;

# TOP 3 CUSTOMERS BY TOTAL SPENT
select
	c.name,
    sum(o.total_amount) as total_spent
from customerss c
join orderss o on c.customer_id = o.customer_id
group by c.customer_id
order by total_spent desc
limit 3;

# best selling product ( by unit sold)
select
	p.name,
    sum(oi.quantity) as units_sold
from pproductss p 
join order_itemss oi on p.product_id =oi.product_id
group by p.product_id
order by units_sold desc
limit 4;

#sales by city
select
	c.city,
    sum(o.total_amount) as city_sales
from customerss c
join orderss o on c.customer_id = o.customer_id
group by c.city
order by city_sales desc;

# find the top 3 selling product per category (by unit sold),inclusing ties
select
	category,
    name as product_name,
    total_units_sold,
    rank_in_category
from(
  select
    p.category,
    p.name,
    sum(oi.quantity) AS total_units_sold,
    rank() over(partition by p.category order by sum(oi.quantity) desc) as rank_in_category
  from pproductss p
  join order_itemss oi on p.product_id = oi.product_id
  group by p.category, p.name
) ranked
where rank_in_category <=3
order by category, rank_in_category;







