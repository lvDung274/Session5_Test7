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
-- Phần 2 : JOINs & GROUP BY (2 điểm)
--(Inner Join): Hiển thị 10 đơn hàng gần nhất gồm: Mã đơn, Tên khách hàng, Email và Tổng giá trị đơn hàng.
SELECT 
    o.order_id AS "Mã đơn",
    c.customer_name AS "Tên khách hàng",
    c.email AS "Email",
    o.total_amount AS "Tổng giá trị đơn hàng"
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_date DESC
LIMIT 10;

--(Left Join): Liệt kê tất cả danh mục (Categories) và số lượng sản phẩm thuộc danh mục đó (Kể cả danh mục chưa có sản phẩm).
SELECT 
    cat.category_name AS "Tên danh mục",
    COUNT(p.product_id) AS "Số lượng sản phẩm"
FROM categories cat
LEFT JOIN products p ON cat.category_id = p.category_id
GROUP BY cat.category_id, cat.category_name;

--(Group By & Having): Tìm các khách hàng đã đặt từ 3 đơn hàng trở lên và có tổng chi tiêu (total_amount) > 5.000.000 VNĐ.

SELECT 
    c.customer_id,
    c.customer_name AS "Tên khách hàng",
    COUNT(o.order_id) AS "Số lượng đơn đã đặt",
    SUM(o.total_amount) AS "Tổng chi tiêu"
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) >= 3 AND SUM(o.total_amount) > 5000000;

--Thống kê tổng doanh thu theo từng tên danh mục sản phẩm (Nối 4 bảng: Categories, Products, Order_Items, Orders).

SELECT 
    cat.category_name AS "Tên danh mục",
    SUM(oi.quantity * oi.unit_price) AS "Tổng doanh thu"
FROM categories cat
INNER JOIN products p ON cat.category_id = p.category_id
INNER JOIN order_items oi ON p.product_id = oi.product_id
INNER JOIN orders o ON oi.order_id = o.order_id
GROUP BY cat.category_id, cat.category_name
ORDER BY "Tổng doanh thu" DESC;


