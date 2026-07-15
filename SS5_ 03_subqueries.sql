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
--Phần 3: Subqueries (2 điểm)
--Tìm thông tin sản phẩm có giá cao hơn giá trung bình của tất cả sản phẩm trong hệ thống.
SELECT 
    product_id, 
    product_name, 
    price
FROM products
WHERE price > (SELECT AVG(price) 
    FROM products
);

--Tìm các khách hàng chưa từng phát sinh bất kỳ đơn hàng nào (Sử dụng NOT EXISTS).

SELECT 
    customer_id, 
    customer_name, 
    email, 
    city
FROM customers c
WHERE NOT EXISTS (
    SELECT 1 
    FROM orders o 
    WHERE o.customer_id = c.customer_id
);
--Liệt kê các sản phẩm có giá cao hơn giá trung bình của chính danh mục mà sản phẩm đó thuộc về (Correlated Subquery).
SELECT 
    p.product_id, 
    p.product_name, 
    p.category_id, 
    p.price
FROM products p
WHERE p.price > (SELECT AVG(sub.price)
    FROM products sub
    WHERE sub.category_id = p.category_id
);
--Tìm khách hàng đã thực hiện đơn hàng có giá trị lớn nhất trong toàn bộ hệ thống.
SELECT 
    c.customer_id, 
    c.customer_name, 
    c.email,
    o.order_id,
    o.total_amount AS "Giá trị đơn hàng lớn nhất"
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.total_amount = (
    -- Subquery: Tìm mức total_amount lớn nhất trong bảng orders
    SELECT MAX(total_amount) 
    FROM orders
);

