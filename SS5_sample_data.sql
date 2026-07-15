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
--Phần5: SQL Logic & Clean Code (2 điểm)
--Viết truy vấn cập nhật lại total_amount trong bảng orders dựa trên tổng tiền từ bảng order_items tương ứng.
UPDATE orders o
SET total_amount = sub.calculated_total
FROM (
    SELECT order_id, SUM(quantity * unit_price) AS calculated_total
    FROM order_items
    GROUP BY order_id
) sub
WHERE o.order_id = sub.order_id;

--Tạo một View tên là vw_customer_summary hiển thị: Tên khách hàng, Tổng số đơn đã mua, Tổng số tiền đã chi tiêu.
CREATE OR REPLACE VIEW vw_customer_summary AS
SELECT 
    c.customer_name AS "Tên khách hàng",
    COUNT(o.order_id) AS "Tổng số đơn đã mua",
    COALESCE(SUM(o.total_amount), 0) AS "Tổng số tiền đã chi tiêu"
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

--Viết truy vấn tìm thành phố có doanh thu cao nhất trong năm 2026.
SELECT 
    c.city AS "Thành phố",
    SUM(o.total_amount) AS "Tổng doanh thu năm 2026"
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_date >= '2026-01-01' AND o.order_date <= '2026-12-31 23:59:59'
GROUP BY c.city
ORDER BY "Tổng doanh thu năm 2026" DESC
LIMIT 1;


