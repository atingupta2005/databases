CREATE TABLE `users` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `email` VARCHAR(255) UNIQUE,
    `email_verified_at` TIMESTAMP NULL,
    `password` VARCHAR(255),
    `photo` VARCHAR(255),
    `role` ENUM('admin', 'user') DEFAULT 'user',
    `provider` VARCHAR(255),
    `provider_id` VARCHAR(255),
    `status` ENUM('active', 'inactive') DEFAULT 'active',
    `remember_token` VARCHAR(100),
    `created_at` TIMESTAMP NULL,
    `updated_at` TIMESTAMP NULL
);

CREATE TABLE `password_resets` (
    `email` VARCHAR(255),
    `token` VARCHAR(255),
    `created_at` TIMESTAMP NULL
);

CREATE TABLE `failed_jobs` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `connection` TEXT,
    `queue` TEXT,
    `payload` LONGTEXT,
    `exception` LONGTEXT,
    `failed_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE `brands` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `title` VARCHAR(255),
    `slug` VARCHAR(255) UNIQUE,
    `status` ENUM('active', 'inactive') DEFAULT 'active',
    `created_at` TIMESTAMP NULL,
    `updated_at` TIMESTAMP NULL
);

CREATE TABLE `banners` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `title` VARCHAR(255),
    `slug` VARCHAR(255) UNIQUE,
    `photo` VARCHAR(255),
    `description` TEXT,
    `status` ENUM('active', 'inactive') DEFAULT 'inactive',
    `created_at` TIMESTAMP NULL,
    `updated_at` TIMESTAMP NULL
);

CREATE TABLE `categories` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `title` VARCHAR(255),
    `slug` VARCHAR(255) UNIQUE,
    `summary` TEXT,
    `photo` VARCHAR(255),
    `is_parent` TINYINT(1) DEFAULT 1,
    `parent_id` BIGINT UNSIGNED,
    `added_by` BIGINT UNSIGNED,
    `status` ENUM('active', 'inactive') DEFAULT 'inactive',
    `created_at` TIMESTAMP NULL,
    `updated_at` TIMESTAMP NULL,
    FOREIGN KEY (`parent_id`) REFERENCES `categories`(`id`) ON DELETE SET NULL,
    FOREIGN KEY (`added_by`) REFERENCES `users`(`id`) ON DELETE SET NULL
);

CREATE TABLE `products` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `title` VARCHAR(255),
    `slug` VARCHAR(255) UNIQUE,
    `summary` TEXT,
    `description` LONGTEXT,
    `photo` TEXT,
    `stock` INT DEFAULT 1,
    `size` VARCHAR(255) DEFAULT 'M',
    `condition` ENUM('default', 'new', 'hot') DEFAULT 'default',
    `status` ENUM('active', 'inactive') DEFAULT 'inactive',
    `price` FLOAT,
    `discount` FLOAT,
    `is_featured` TINYINT(1) DEFAULT 0,
    `cat_id` BIGINT UNSIGNED,
    `child_cat_id` BIGINT UNSIGNED,
    `brand_id` BIGINT UNSIGNED,
    `created_at` TIMESTAMP NULL,
    `updated_at` TIMESTAMP NULL,
    FOREIGN KEY (`cat_id`) REFERENCES `categories`(`id`) ON DELETE SET NULL,
    FOREIGN KEY (`child_cat_id`) REFERENCES `categories`(`id`) ON DELETE SET NULL,
    FOREIGN KEY (`brand_id`) REFERENCES `brands`(`id`) ON DELETE SET NULL
);

CREATE TABLE `post_categories` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `title` VARCHAR(255),
    `slug` VARCHAR(255) UNIQUE,
    `status` ENUM('active', 'inactive') DEFAULT 'active',
    `created_at` TIMESTAMP NULL,
    `updated_at` TIMESTAMP NULL
);

CREATE TABLE `post_tags` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `title` VARCHAR(255),
    `slug` VARCHAR(255) UNIQUE,
    `status` ENUM('active', 'inactive') DEFAULT 'active',
    `created_at` TIMESTAMP NULL,
    `updated_at` TIMESTAMP NULL
);

CREATE TABLE `posts` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `title` VARCHAR(255),
    `slug` VARCHAR(255) UNIQUE,
    `summary` TEXT,
    `description` LONGTEXT,
    `quote` TEXT,
    `photo` VARCHAR(255),
    `tags` VARCHAR(255),
    `post_cat_id` BIGINT UNSIGNED,
    `post_tag_id` BIGINT UNSIGNED,
    `added_by` BIGINT UNSIGNED,
    `status` ENUM('active', 'inactive') DEFAULT 'active',
    `created_at` TIMESTAMP NULL,
    `updated_at` TIMESTAMP NULL,
    FOREIGN KEY (`post_cat_id`) REFERENCES `post_categories`(`id`) ON DELETE SET NULL,
    FOREIGN KEY (`post_tag_id`) REFERENCES `post_tags`(`id`) ON DELETE SET NULL,
    FOREIGN KEY (`added_by`) REFERENCES `users`(`id`) ON DELETE SET NULL
);

CREATE TABLE `messages` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255),
    `subject` TEXT,
    `email` VARCHAR(255),
    `photo` VARCHAR(255),
    `phone` VARCHAR(255),
    `message` LONGTEXT,
    `read_at` TIMESTAMP NULL,
    `created_at` TIMESTAMP NULL,
    `updated_at` TIMESTAMP NULL
);

CREATE TABLE `shippings` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `type` VARCHAR(255),
    `price` DECIMAL(10,2),
    `status` ENUM('active', 'inactive') DEFAULT 'active',
    `created_at` TIMESTAMP NULL,
    `updated_at` TIMESTAMP NULL
);

CREATE TABLE `orders` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `order_number` VARCHAR(255) UNIQUE,
    `user_id` BIGINT UNSIGNED,
    `sub_total` FLOAT,
    `shipping_id` BIGINT UNSIGNED,
    `coupon` FLOAT,
    `total_amount` FLOAT,
    `quantity` INT,
    `payment_method` ENUM('cod', 'paypal') DEFAULT 'cod',
    `payment_status` ENUM('paid', 'unpaid') DEFAULT 'unpaid',
    `status` ENUM('new', 'process', 'delivered', 'cancel') DEFAULT 'new',
    `first_name` VARCHAR(255),
    `last_name` VARCHAR(255),
    `email` VARCHAR(255),
    `phone` VARCHAR(255),
    `country` VARCHAR(255),
    `post_code` VARCHAR(255),
    `address1` TEXT,
    `address2` TEXT,
    `created_at` TIMESTAMP NULL,
    `updated_at` TIMESTAMP NULL,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL,
    FOREIGN KEY (`shipping_id`) REFERENCES `shippings`(`id`) ON DELETE SET NULL
);

CREATE TABLE `carts` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `product_id` BIGINT UNSIGNED,
    `order_id` BIGINT UNSIGNED,
    `user_id` BIGINT UNSIGNED,
    `price` FLOAT,
    `status` ENUM('new', 'progress', 'delivered', 'cancel') DEFAULT 'new',
    `quantity` INT,
    `amount` FLOAT,
    `created_at` TIMESTAMP NULL,
    `updated_at` TIMESTAMP NULL,
    FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`order_id`) REFERENCES `orders`(`id`) ON DELETE SET NULL
);

CREATE TABLE `notifications` (
    `id` BINARY(16) PRIMARY KEY,
    `type` VARCHAR(255),
    `notifiable_id` BIGINT UNSIGNED,
    `notifiable_type` VARCHAR(255),
    `data` TEXT,
    `read_at` TIMESTAMP NULL,
    `created_at` TIMESTAMP NULL,
    `updated_at` TIMESTAMP NULL
);

CREATE TABLE `coupons` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(255) UNIQUE,
    `type` ENUM('fixed', 'percent') DEFAULT 'fixed',
    `value` DECIMAL(20,2),
    `status` ENUM('active', 'inactive') DEFAULT 'inactive',
    `created_at` TIMESTAMP NULL,
    `updated_at` TIMESTAMP NULL
);

CREATE TABLE `wishlists` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `product_id` BIGINT UNSIGNED,
    `cart_id` BIGINT UNSIGNED,
    `user_id` BIGINT UNSIGNED,
    `price` FLOAT,
    `quantity` INT,
    `amount` FLOAT,
    `created_at` TIMESTAMP NULL,
    `updated_at` TIMESTAMP NULL,
    FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL,
    FOREIGN KEY (`cart_id`) REFERENCES `carts`(`id`) ON DELETE SET NULL
);

CREATE TABLE `product_reviews` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `user_id` BIGINT UNSIGNED,
    `product_id` BIGINT UNSIGNED,
    `rate` TINYINT DEFAULT 0,
    `review` TEXT,
    `status` ENUM('active', 'inactive') DEFAULT 'active',
    `created_at` TIMESTAMP NULL,
    `updated_at` TIMESTAMP NULL,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL,
    FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE SET NULL
);

CREATE TABLE `post_comments` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `user_id` BIGINT UNSIGNED,
    `post_id` BIGINT UNSIGNED,
    `comment` TEXT,
    `status` ENUM('active', 'inactive') DEFAULT 'active',
    `replied_comment` TEXT,
    `parent_id` BIGINT UNSIGNED,
    `created_at` TIMESTAMP NULL,
    `updated_at` TIMESTAMP NULL,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL,
    FOREIGN KEY (`post_id`) REFERENCES `posts`(`id`) ON DELETE SET NULL,
    FOREIGN KEY (`parent_id`) REFERENCES `post_comments`(`id`) ON DELETE SET NULL
);

CREATE TABLE `settings` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `description` LONGTEXT,
    `short_des` TEXT,
    `logo` VARCHAR(255),
    `photo` VARCHAR(255),
    `address` VARCHAR(255),
    `phone` VARCHAR(255),
    `email` VARCHAR(255),
    `created_at` TIMESTAMP NULL,
    `updated_at` TIMESTAMP NULL
);

CREATE TABLE `jobs` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `queue` VARCHAR(255),
    `payload` LONGTEXT,
    `attempts` TINYINT UNSIGNED,
    `reserved_at` INT UNSIGNED,
    `available_at` INT UNSIGNED,
    `created_at` INT UNSIGNED
);
