CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category_id INT REFERENCES categories(category_id) ON DELETE SET NULL,
    price NUMERIC(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0
);

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    city VARCHAR(50),
    join_date DATE DEFAULT CURRENT_DATE
);


CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id) ON DELETE CASCADE,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount NUMERIC(12,2) DEFAULT 0.00,
    status VARCHAR(30) DEFAULT 'Pending'
);

CREATE TABLE order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INT REFERENCES products(product_id) ON DELETE RESTRICT,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10,2) NOT NULL
);

--Phần 1: ALIAS & Aggregate Functions (2 điểm)
SELECT 
    product_name AS "Tên SP",
    price AS "Đơn giá",
    (price * 1.1) AS "Giá VAT"
FROM products;

--Đếm tổng số khách hàng hiện có theo từng thành phố (Sắp xếp giảm dần theo số lượng).

SELECT 
    city AS "Thành phố",
    COUNT(customer_id) AS "Số lượng khách hàng"
FROM customers
GROUP BY city
ORDER BY COUNT(customer_id) DESC;
--Tính giá cao nhất, thấp nhất và trung bình của các sản phẩm có trong kho.
SELECT 
    MAX(price) AS "Giá cao nhất",
    MIN(price) AS "Giá thấp nhất",
    ROUND(AVG(price), 2) AS "Giá trung bình"
FROM products;

--Thống kê số lượng đơn hàng theo từng trạng thái (Status).
SELECT 
    MAX(price) AS "Giá cao nhất",
    MIN(price) AS "Giá thấp nhất",
    ROUND(AVG(price), 2) AS "Giá trung bình"
FROM products;

