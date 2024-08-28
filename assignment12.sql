-- 1.  Table A: Customers
-- 2.  Table B: Orders
-- 3.  Table A_B: Order_Customer
-- 4.  Table C: Pizzas
-- 5.  Table B_C: Order_Items

-- Q1: Create Database Schema
-- Q2: Create your database based on your design in MySQL
CREATE DATABASE IF NOT EXISTS PizzaRus;

USE PizzaRus;

SET FOREIGN_KEY_CHECKS=0; 
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Order_Customer;
DROP TABLE IF EXISTS Pizzas;
DROP TABLE IF EXISTS Order_Items;
SET FOREIGN_KEY_CHECKS=1;

CREATE TABLE Customers (
	c_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(255) NOT NULL,
    phone_number VARCHAR(255) NOT NULL
);

CREATE TABLE Orders (
	order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_time DATETIME NOT NULL
);

CREATE TABLE Order_Customer (
	order_customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(c_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

CREATE TABLE Pizzas (
	pizza_id INT AUTO_INCREMENT PRIMARY KEY,
    pizza_name VARCHAR(255) NOT NULL,
    price DECIMAL(5, 2) NOT NULL
);

CREATE TABLE Order_Items (
	order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    pizza_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (pizza_id) REFERENCES Pizzas(pizza_id)
);

-- Q3: Populate your database with three orders
INSERT INTO Pizzas(pizza_name, price) VALUES
('Pepperoni & Cheese', 7.99),
('Vegetarian', 9.99),
('Meat Lovers', 14.99),
('Hawaiian', 12.99);

INSERT INTO Customers(customer_name, phone_number) VALUES
('Trevor Page', '226-555-4982'),
('John Doe', '555-555-9498');

INSERT INTO Orders(order_time) VALUES
('2023-09-10 09:47:00'),
('2023-09-10 13:20:00'),
('2023-09-10 09:47:00'),
('2023-10-10 10:37:00');

INSERT INTO Order_Customer(customer_id, order_id) VALUES 
(1, 1),
(2, 2),
(1, 3),
(2, 4);

INSERT INTO Order_Items(order_id, pizza_id, quantity) VALUES
(1, 1, 1),
(1, 3, 1),
(2, 2, 1),
(2, 3, 2),
(3, 3, 1),
(3, 4, 1),
(4, 2, 3),
(4, 4, 1);

-- Q4: How much has each customer spent?
SELECT Customers.customer_name, Customers.phone_number, SUM(Pizzas.price * Order_Items.quantity) as total_spent
FROM Customers
JOIN Order_Customer ON Customers.c_id = Order_Customer.customer_id  
JOIN Orders ON Order_Customer.order_id = Orders.order_id 
JOIN Order_Items ON Orders.order_id = Order_Items.order_id
JOIN Pizzas ON Pizzas.pizza_id = Order_Items.pizza_id
GROUP BY Customers.c_id, Customers.customer_name, Customers.phone_number;


-- Q5: Modify the query from Q4 to separate the orders not just by customer, but also by date so they can see how much each customer is ordering on which date.

SELECT Customers.customer_name, Customers.phone_number, DATE(Orders.order_time) as order_date, SUM(Pizzas.price * Order_Items.quantity) as total_spent
FROM Customers
JOIN Order_Customer ON Customers.c_id = Order_Customer.customer_id  
JOIN Orders ON Order_Customer.order_id = Orders.order_id 
JOIN Order_Items ON Orders.order_id = Order_Items.order_id
JOIN Pizzas ON Pizzas.pizza_id = Order_Items.pizza_id
GROUP BY Customers.c_id, DATE(Orders.order_time);
