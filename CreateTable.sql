-- =============================================
-- 菜谱推荐网站数据库初始化脚本 (PostgreSQL - Optimized)
-- 基于 实体与关系.md 设计
-- =============================================

-- 1. 清理旧表 (注意删除顺序，先删子表)
DROP TABLE IF EXISTS recipe_tags CASCADE;
DROP TABLE IF EXISTS tags CASCADE;
DROP TABLE IF EXISTS follows CASCADE;
DROP TABLE IF EXISTS user_behavior_logs CASCADE;
DROP TABLE IF EXISTS review_tags CASCADE; -- New
DROP TABLE IF EXISTS reviews CASCADE;
DROP TABLE IF EXISTS collection_items CASCADE;
DROP TABLE IF EXISTS collections CASCADE;
DROP TABLE IF EXISTS user_preferences CASCADE;
DROP TABLE IF EXISTS nutrition CASCADE;
DROP TABLE IF EXISTS steps CASCADE;
DROP TABLE IF EXISTS recipe_ingredients CASCADE;
DROP TABLE IF EXISTS ingredient_aliases CASCADE; -- New
DROP TABLE IF EXISTS ingredients CASCADE;
DROP TABLE IF EXISTS recipe_stats CASCADE; -- New
DROP TABLE IF EXISTS recipes CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- 清理自定义类型
DROP TYPE IF EXISTS recipe_status_type CASCADE;
DROP TYPE IF EXISTS difficulty_type CASCADE;

-- =============================================
-- 一、 核心内容域 (Content Domain)
-- =============================================

-- 定义枚举类型
CREATE TYPE recipe_status_type AS ENUM ('draft', 'published', 'banned');
CREATE TYPE difficulty_type AS ENUM ('Easy', 'Medium', 'Hard');

-- 1. Users (用户表)
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    avatar_url VARCHAR(255),
    bio TEXT,
    level VARCHAR(50) DEFAULT 'Kitchen Novice',
    points INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Categories (分类树)
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    parent_id INT REFERENCES categories(category_id)
);
CREATE INDEX idx_categories_parent ON categories(parent_id);

-- 3. Recipes (菜谱主表 - 移除高频更新字段，添加全文检索)
CREATE TABLE recipes (
    recipe_id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    cover_image_url VARCHAR(255),
    video_url VARCHAR(255),
    status recipe_status_type DEFAULT 'published', -- 使用枚举
    difficulty difficulty_type, -- 使用枚举
    cooking_time INT,
    preparation_time INT,
    servings VARCHAR(50),
    rating_avg DECIMAL(3, 2) DEFAULT 0.0,
    author_id INT REFERENCES users(user_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    search_vector TSVECTOR -- 全文检索向量
);
CREATE INDEX idx_recipes_author ON recipes(author_id);
CREATE INDEX idx_recipes_search ON recipes USING GIN(search_vector);

-- 3.1 Recipe_Stats (高频更新计数器分离)
CREATE TABLE recipe_stats (
    recipe_id INT PRIMARY KEY REFERENCES recipes(recipe_id) ON DELETE CASCADE,
    view_count INT DEFAULT 0,
    like_count INT DEFAULT 0
);

-- 4. Ingredients (食材库 - 移除非原子字段 alias)
CREATE TABLE ingredients (
    ingredient_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    category_id INT REFERENCES categories(category_id),
    image_url VARCHAR(255)
);
CREATE INDEX idx_ingredients_category ON ingredients(category_id);

-- 4.1 Ingredient_Aliases (食材别名表 - 1NF优化)
CREATE TABLE ingredient_aliases (
    alias_id SERIAL PRIMARY KEY,
    ingredient_id INT REFERENCES ingredients(ingredient_id) ON DELETE CASCADE,
    alias_name VARCHAR(50) NOT NULL
);
CREATE INDEX idx_ingredient_aliases_name ON ingredient_aliases(alias_name);

-- 5. Recipe_Ingredients (菜谱-食材关联)
CREATE TABLE recipe_ingredients (
    id SERIAL PRIMARY KEY,
    recipe_id INT REFERENCES recipes(recipe_id) ON DELETE CASCADE,
    ingredient_id INT REFERENCES ingredients(ingredient_id),
    quantity DECIMAL(10, 2),
    unit VARCHAR(20),
    remark VARCHAR(50),
    is_main BOOLEAN DEFAULT FALSE
);
CREATE INDEX idx_recipe_ingredients_recipe ON recipe_ingredients(recipe_id);
CREATE INDEX idx_recipe_ingredients_ingredient ON recipe_ingredients(ingredient_id);

-- 6. Steps (烹饪步骤)
CREATE TABLE steps (
    step_id SERIAL PRIMARY KEY,
    recipe_id INT REFERENCES recipes(recipe_id) ON DELETE CASCADE,
    step_number INT NOT NULL,
    description TEXT NOT NULL,
    image_url VARCHAR(255),
    timer_seconds INT
);
CREATE INDEX idx_steps_recipe ON steps(recipe_id);

-- 7. Nutrition (营养成分)
CREATE TABLE nutrition (
    recipe_id INT PRIMARY KEY REFERENCES recipes(recipe_id) ON DELETE CASCADE,
    calories DECIMAL(10, 2),
    protein DECIMAL(10, 2),
    fat DECIMAL(10, 2),
    carbohydrates DECIMAL(10, 2),
    sodium DECIMAL(10, 2)
);

-- =============================================
-- 二、 用户域 (User Domain)
-- =============================================

-- 8. User_Preferences (用户偏好 - 添加GIN索引)
CREATE TABLE user_preferences (
    user_id INT PRIMARY KEY REFERENCES users(user_id) ON DELETE CASCADE,
    dietary_type JSONB, -- e.g. ["vegan", "keto"]
    allergies INT[], -- 存储 ingredient_id 的数组
    disliked_ingredients INT[], -- 存储 ingredient_id 的数组
    spicy_tolerance INT CHECK (spicy_tolerance BETWEEN 0 AND 5)
);
CREATE INDEX idx_prefs_dietary ON user_preferences USING GIN(dietary_type);
CREATE INDEX idx_prefs_allergies ON user_preferences USING GIN(allergies);
CREATE INDEX idx_prefs_disliked ON user_preferences USING GIN(disliked_ingredients);

-- =============================================
-- 三、 交互与推荐域 (Interaction & RecSys Domain)
-- =============================================

-- 9. Collections (收藏夹)
CREATE TABLE collections (
    collection_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    is_public BOOLEAN DEFAULT TRUE
);
CREATE INDEX idx_collections_user ON collections(user_id);

-- 10. Collection_Items (收藏夹内容)
CREATE TABLE collection_items (
    collection_id INT REFERENCES collections(collection_id) ON DELETE CASCADE,
    recipe_id INT REFERENCES recipes(recipe_id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (collection_id, recipe_id)
);

-- 11. Reviews (评价 - 移除 tags 字段)
CREATE TABLE reviews (
    review_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    recipe_id INT REFERENCES recipes(recipe_id) ON DELETE CASCADE,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    content TEXT,
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_reviews_user ON reviews(user_id);
CREATE INDEX idx_reviews_recipe ON reviews(recipe_id);

-- 11.1 Review_Tags (评价标签 - 1NF优化)
CREATE TABLE review_tags (
    review_tag_id SERIAL PRIMARY KEY,
    review_id INT REFERENCES reviews(review_id) ON DELETE CASCADE,
    tag_name VARCHAR(50) NOT NULL
);
CREATE INDEX idx_review_tags_review ON review_tags(review_id);

-- 12. User_Behavior_Logs (行为日志)
CREATE TABLE user_behavior_logs (
    log_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    recipe_id INT REFERENCES recipes(recipe_id),
    action_type VARCHAR(20), -- view, share, print, add_to_cart, search
    duration INT, -- seconds
    search_keyword VARCHAR(255),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_logs_user ON user_behavior_logs(user_id);
CREATE INDEX idx_logs_recipe ON user_behavior_logs(recipe_id);
CREATE INDEX idx_logs_time ON user_behavior_logs(timestamp);

-- 13. Follows (社交关系)
CREATE TABLE follows (
    follower_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    followed_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (follower_id, followed_id)
);

-- =============================================
-- 四、 元数据与分类域 (Metadata Domain)
-- =============================================

-- 14. Tags (标签库)
CREATE TABLE tags (
    tag_id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

-- 15. Recipe_Tags (菜谱-标签关联)
CREATE TABLE recipe_tags (
    recipe_id INT REFERENCES recipes(recipe_id) ON DELETE CASCADE,
    tag_id INT REFERENCES tags(tag_id) ON DELETE CASCADE,
    PRIMARY KEY (recipe_id, tag_id)
);


-- =============================================
-- 插入测试数据 (Sample Data)
-- =============================================

-- Users
INSERT INTO users (username, email, password_hash, bio, level) VALUES
('ChefGordon', 'gordon@example.com', 'hash123', 'Michelin Star Chef', 'Michelin Chef'),
('HomeCookAlice', 'alice@example.com', 'hash456', 'Loves baking', 'Kitchen Novice'),
('SpicyLover', 'spicy@example.com', 'hash789', 'No spice no life', 'Advanced Cook');

-- Categories
INSERT INTO categories (name, parent_id) VALUES
('中餐', NULL),
('西餐', NULL),
('川菜', 1),
('粤菜', 1),
('烘焙', 2);

-- Ingredients (Removed alias)
INSERT INTO ingredients (name, category_id) VALUES
('鸡胸肉', 1),
('花生', 1),
('干辣椒', 1),
('鸡蛋', 1),
('面粉', 5);

-- Ingredient Aliases (New)
INSERT INTO ingredient_aliases (ingredient_id, alias_name) VALUES
(1, 'chicken breast'), (1, '鸡肉'),
(2, 'peanut'), (2, '土豆'),
(3, 'dried chili'), (3, 'chili'),
(4, 'egg'), (4, '鸡子'),
(5, 'flour');

-- Recipes (Removed counts, used ENUMs)
INSERT INTO recipes (title, description, difficulty, cooking_time, preparation_time, servings, author_id) VALUES
('宫保鸡丁', '经典川菜，麻辣鲜香', 'Medium', 20, 15, '2人份', 1),
('戚风蛋糕', '松软可口的基础蛋糕', 'Hard', 60, 30, '6寸', 2);

-- Recipe Stats (New)
INSERT INTO recipe_stats (recipe_id, view_count, like_count) VALUES
(1, 0, 0),
(2, 0, 0);

-- Recipe_Ingredients
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, remark, is_main) VALUES
(1, 1, 300, 'g', '切丁', TRUE),
(1, 2, 50, 'g', '去皮', FALSE),
(1, 3, 10, 'g', '剪段', FALSE),
(2, 4, 3, '个', '蛋黄蛋白分离', TRUE),
(2, 5, 100, 'g', '过筛', TRUE);

-- Steps
INSERT INTO steps (recipe_id, step_number, description, timer_seconds) VALUES
(1, 1, '鸡胸肉切丁，加入淀粉腌制', 600),
(1, 2, '热锅凉油，放入干辣椒爆香', 30),
(1, 3, '加入鸡丁滑炒至变色', 180),
(2, 1, '打发蛋白至硬性发泡', 300),
(2, 2, '混合蛋黄糊和蛋白霜', 120);

-- Nutrition
INSERT INTO nutrition (recipe_id, calories, protein, fat, carbohydrates, sodium) VALUES
(1, 450, 35, 20, 15, 800),
(2, 300, 8, 15, 40, 100);

-- Tags
INSERT INTO tags (name) VALUES ('川菜'), ('下饭菜'), ('甜点'), ('下午茶');

-- Recipe_Tags
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES
(1, 1), (1, 2),
(2, 3), (2, 4);

-- User_Preferences
INSERT INTO user_preferences (user_id, dietary_type, allergies, spicy_tolerance) VALUES
(2, '["low-carb"]', ARRAY[2], 1);

-- Collections
INSERT INTO collections (user_id, name) VALUES (2, '周末烘焙计划');

-- Collection_Items
INSERT INTO collection_items (collection_id, recipe_id) VALUES (1, 2);

-- Reviews (Removed tags)
INSERT INTO reviews (user_id, recipe_id, rating, content) VALUES
(2, 1, 5, '虽然有点辣，但是很好吃！'),
(3, 1, 4, '不够辣，下次多放点辣椒');

-- Review Tags (New)
INSERT INTO review_tags (review_id, tag_name) VALUES
(1, '味道赞'), (1, '做法简单'),
(2, '不够辣');

-- Follows
INSERT INTO follows (follower_id, followed_id) VALUES (2, 1);
