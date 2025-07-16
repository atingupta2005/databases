-- Sample data for users table
INSERT INTO users (name, email, password, photo, role, status, created_at, updated_at) VALUES 
('John Doe', 'john@example.com', 'hashed_password', NULL, 'admin', 'active', NOW(), NOW()),
('Jane Doe', 'jane@example.com', 'hashed_password', NULL, 'user', 'active', NOW(), NOW());

-- Sample data for password_resets table
INSERT INTO password_resets (email, token, created_at) VALUES 
('john@example.com', 'reset_token_1', NOW()),
('jane@example.com', 'reset_token_2', NOW());

-- Sample data for brands table
INSERT INTO brands (title, slug, status, created_at, updated_at) VALUES 
('Brand A', 'brand-a', 'active', NOW(), NOW()),
('Brand B', 'brand-b', 'active', NOW(), NOW());

-- Sample data for banners table
INSERT INTO banners (title, slug, photo, description, status, created_at, updated_at) VALUES 
('Banner 1', 'banner-1', 'banner1.jpg', 'Banner 1 Description', 'active', NOW(), NOW()),
('Banner 2', 'banner-2', 'banner2.jpg', 'Banner 2 Description', 'inactive', NOW(), NOW());

-- Sample data for categories table
INSERT INTO categories (title, slug, summary, photo, is_parent, parent_id, added_by, status, created_at, updated_at) VALUES 
('Category A', 'category-a', 'Category A Summary', 'cat_a.jpg', 1, NULL, 1, 'active', NOW(), NOW()),
('Category B', 'category-b', 'Category B Summary', 'cat_b.jpg', 1, NULL, 1, 'active', NOW(), NOW());

-- Sample data for products table
INSERT INTO products (title, slug, summary, description, photo, stock, size, `condition`, status, price, discount, is_featured, cat_id, child_cat_id, brand_id, created_at, updated_at) VALUES 
('Product A', 'product-a', 'Product A Summary', 'Product A Description', 'product_a.jpg', 10, 'M', 'default', 'inactive', 100.00, 10.00, 1, 1, NULL, 1, NOW(), NOW()),
('Product B', 'product-b', 'Product B Summary', 'Product B Description', 'product_b.jpg', 20, 'L', 'new', 'active', 150.00, NULL, 0, 1, NULL, 2, NOW(), NOW());

-- Sample data for post_categories table
INSERT INTO post_categories (title, slug, status, created_at, updated_at) VALUES 
('Category X', 'category-x', 'active', NOW(), NOW()),
('Category Y', 'category-y', 'active', NOW(), NOW());

-- Sample data for post_tags table
INSERT INTO post_tags (title, slug, status, created_at, updated_at) VALUES 
('Tag 1', 'tag-1', 'active', NOW(), NOW()),
('Tag 2', 'tag-2', 'active', NOW(), NOW());

-- Sample data for posts table
INSERT INTO posts (title, slug, summary, description, quote, photo, tags, post_cat_id, post_tag_id, added_by, status, created_at, updated_at) VALUES 
('Post A', 'post-a', 'Post A Summary', 'Post A Description', 'Post A Quote', 'post_a.jpg', 'tag-1,tag-2', 1, 1, 1, 'active', NOW(), NOW()),
('Post B', 'post-b', 'Post B Summary', 'Post B Description', 'Post B Quote', 'post_b.jpg', 'tag-2', 2, 2, 1, 'active', NOW(), NOW());

-- Sample data for messages table
INSERT INTO messages (name, subject, email, photo, phone, message, read_at, created_at, updated_at) VALUES 
('Sender A', 'Subject A', 'sender_a@example.com', NULL, '1234567890', 'Message A', NULL, NOW(), NOW()),
('Sender B', 'Subject B', 'sender_b@example.com', NULL, '0987654321', 'Message B', NULL, NOW(), NOW());

-- Sample data for shippings table
INSERT INTO shippings (type, price, status, created_at, updated_at) VALUES 
('Shipping A', 10.00, 'active', NOW(), NOW()),
('Shipping B', 20.00, 'inactive', NOW(), NOW());

-- Sample data for orders table
INSERT INTO orders (order_number, user_id, sub_total, shipping_id, coupon, total_amount, quantity, payment_method, payment_status, status, first_name, last_name, email, phone, country, post_code, address1, address2, created_at, updated_at) VALUES 
('ORD001', 1, 200.00, 1, 0.00, 200.00, 2, 'cod', 'unpaid', 'new', 'John', 'Doe', 'john@example.com', '1234567890', 'Country A', '12345', 'Address Line 1', NULL, NOW(), NOW()),
('ORD002', 2, 150.00, 2, 0.00, 150.00, 1, 'paypal', 'paid', 'process', 'Jane', 'Doe', 'jane@example.com', '0987654321', 'Country B', '54321', 'Address Line 2', NULL, NOW(), NOW());

-- Sample data for carts table
INSERT INTO carts (product_id, order_id, user_id, price, status, quantity, amount, created_at, updated_at) VALUES 
(1, NULL, 1, 100.00, 'new', 1, 100.00, NOW(), NOW()),
(2, NULL, 2, 150.00, 'progress', 1, 150.00, NOW(), NOW());

-- Sample data for coupons table
INSERT INTO coupons (code, type, value, status, created_at, updated_at) VALUES 
('COUPON001', 'fixed', 20.00, 'active', NOW(), NOW()),
('COUPON002', 'percent', 10.00, 'inactive', NOW(), NOW());

-- Sample data for wishlists table
INSERT INTO wishlists (product_id, cart_id, user_id, price, quantity, amount, created_at, updated_at) VALUES 
(1, NULL, 1, 100.00, 1, 100.00, NOW(), NOW()),
(2, NULL, 2, 150.00, 1, 150.00, NOW(), NOW());

-- Sample data for product_reviews table
INSERT INTO product_reviews (user_id, product_id, rate, review, status, created_at, updated_at) VALUES 
(1, 1, 4, 'Product A Review', 'active', NOW(), NOW()),
(2, 2, 5, 'Product B Review', 'active', NOW(), NOW());

-- Sample data for post_comments table
INSERT INTO post_comments (user_id, post_id, comment, status, replied_comment, parent_id, created_at, updated_at) VALUES 
(1, 1, 'Comment A on Post A', 'active', NULL, NULL, NOW(), NOW()),
(2, 2, 'Comment B on Post B', 'active', NULL, NULL, NOW(), NOW());

-- Sample data for settings table
INSERT INTO settings (description, short_des, logo, photo, address, phone, email, created_at, updated_at) VALUES 
('Description of the site', 'Short description', 'logo.jpg', 'photo.jpg', 'Site Address', '1234567890', 'info@example.com', NOW(), NOW());

-- Sample data for jobs table
INSERT INTO jobs (queue, payload, attempts, reserved_at, available_at, created_at) VALUES 
('queue1', 'payload1', 0, NULL, NOW(), NOW()),
('queue2', 'payload2', 1, NULL, NOW(), NOW());
