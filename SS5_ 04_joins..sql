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
--Phần4:Set Operators - UNION/INTERSECT/EXCEPT (2 điểm)
--(UNION): Gộp danh sách Email của khách hàng và Email của các nhà cung cấp (giả sử có bảng suppliers) để làm danh sách gửi tin NewsLetter.
SELECT email AS "Newsletter Email", 'Khách hàng' AS "Đối tượng"
FROM customers
UNION
SELECT email AS "Newsletter Email", 'Nhà cung cấp' AS "Đối tượng"
FROM suppliers;

--(INTERSECT): Tìm danh sách customer_id vừa mua sản phẩm thuộc danh mục 'Electronics' vừa mua sản phẩm thuộc danh mục 'Books'.

-- Tập hợp 1: Khách hàng đã mua các sản phẩm thuộc nhóm 'Electronics'
SELECT o.customer_id
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
INNER JOIN categories cat ON p.category_id = cat.category_id
WHERE cat.category_name = 'Electronics'
INTERSECT
SELECT o.customer_id
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
INNER JOIN categories cat ON p.category_id = cat.category_id
WHERE cat.category_name = 'Books';
