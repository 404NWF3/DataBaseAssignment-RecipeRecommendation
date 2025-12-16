-- =============================================
-- 菜谱推荐网站数据库初始化脚本 (SQL Server)
-- 基于 实体与关系.md 设计
-- =============================================

-- 1. 清理旧表 (注意删除顺序，先删子表)
-- SQL Server 不支持 CASCADE DROP，必须按依赖顺序删除
IF OBJECT_ID('dbo.recipe_tags', 'U') IS NOT NULL DROP TABLE dbo.recipe_tags;
IF OBJECT_ID('dbo.tags', 'U') IS NOT NULL DROP TABLE dbo.tags;
IF OBJECT_ID('dbo.follows', 'U') IS NOT NULL DROP TABLE dbo.follows;
IF OBJECT_ID('dbo.user_behavior_logs', 'U') IS NOT NULL DROP TABLE dbo.user_behavior_logs;
IF OBJECT_ID('dbo.review_tags', 'U') IS NOT NULL DROP TABLE dbo.review_tags;
IF OBJECT_ID('dbo.reviews', 'U') IS NOT NULL DROP TABLE dbo.reviews;
IF OBJECT_ID('dbo.collection_items', 'U') IS NOT NULL DROP TABLE dbo.collection_items;
IF OBJECT_ID('dbo.collections', 'U') IS NOT NULL DROP TABLE dbo.collections;
IF OBJECT_ID('dbo.user_preferences', 'U') IS NOT NULL DROP TABLE dbo.user_preferences;
IF OBJECT_ID('dbo.nutrition', 'U') IS NOT NULL DROP TABLE dbo.nutrition;
IF OBJECT_ID('dbo.steps', 'U') IS NOT NULL DROP TABLE dbo.steps;
IF OBJECT_ID('dbo.recipe_ingredients', 'U') IS NOT NULL DROP TABLE dbo.recipe_ingredients;
IF OBJECT_ID('dbo.ingredient_aliases', 'U') IS NOT NULL DROP TABLE dbo.ingredient_aliases;
IF OBJECT_ID('dbo.ingredients', 'U') IS NOT NULL DROP TABLE dbo.ingredients;
IF OBJECT_ID('dbo.recipe_stats', 'U') IS NOT NULL DROP TABLE dbo.recipe_stats;
IF OBJECT_ID('dbo.recipes', 'U') IS NOT NULL DROP TABLE dbo.recipes;
IF OBJECT_ID('dbo.categories', 'U') IS NOT NULL DROP TABLE dbo.categories;
IF OBJECT_ID('dbo.users', 'U') IS NOT NULL DROP TABLE dbo.users;

-- =============================================
-- 一、 核心内容域 (Content Domain)
-- =============================================

-- 1. Users (用户表)
CREATE TABLE users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    password_hash NVARCHAR(255) NOT NULL,
    avatar_url NVARCHAR(255),
    bio NVARCHAR(MAX),
    level NVARCHAR(50) DEFAULT 'Kitchen Novice',
    points INT DEFAULT 0,
    created_at DATETIME2 DEFAULT GETDATE()
);

-- 2. Categories (分类树)
CREATE TABLE categories (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    parent_id INT REFERENCES categories(category_id)
);
CREATE INDEX idx_categories_parent ON categories(parent_id);

-- 3. Recipes (菜谱主表)
CREATE TABLE recipes (
    recipe_id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    cover_image_url NVARCHAR(255),
    video_url NVARCHAR(255),
    status NVARCHAR(20) DEFAULT 'published' CHECK (status IN ('draft', 'published', 'banned')),
    difficulty NVARCHAR(20) CHECK (difficulty IN ('Easy', 'Medium', 'Hard')),
    cooking_time INT,
    preparation_time INT,
    servings NVARCHAR(50),
    rating_avg DECIMAL(3, 2) DEFAULT 0.0,
    author_id INT REFERENCES users(user_id),
    created_at DATETIME2 DEFAULT GETDATE(),
    search_vector NVARCHAR(MAX) -- SQL Server 不使用 TSVECTOR，保留字段
);
CREATE INDEX idx_recipes_author ON recipes(author_id);

-- 3.1 Recipe_Stats (高频更新计数器分离)
CREATE TABLE recipe_stats (
    recipe_id INT PRIMARY KEY REFERENCES recipes(recipe_id) ON DELETE CASCADE,
    view_count INT DEFAULT 0,
    like_count INT DEFAULT 0
);

-- 4. Ingredients (食材库)
CREATE TABLE ingredients (
    ingredient_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    category_id INT REFERENCES categories(category_id),
    image_url NVARCHAR(255)
);
CREATE INDEX idx_ingredients_category ON ingredients(category_id);

-- 4.1 Ingredient_Aliases (食材别名表)
CREATE TABLE ingredient_aliases (
    alias_id INT IDENTITY(1,1) PRIMARY KEY,
    ingredient_id INT REFERENCES ingredients(ingredient_id) ON DELETE CASCADE,
    alias_name NVARCHAR(50) NOT NULL
);
CREATE INDEX idx_ingredient_aliases_name ON ingredient_aliases(alias_name);

-- 5. Recipe_Ingredients (菜谱-食材关联)
CREATE TABLE recipe_ingredients (
    id INT IDENTITY(1,1) PRIMARY KEY,
    recipe_id INT REFERENCES recipes(recipe_id) ON DELETE CASCADE,
    ingredient_id INT REFERENCES ingredients(ingredient_id),
    quantity DECIMAL(10, 2),
    unit NVARCHAR(20),
    remark NVARCHAR(50),
    is_main BIT DEFAULT 0
);
CREATE INDEX idx_recipe_ingredients_recipe ON recipe_ingredients(recipe_id);
CREATE INDEX idx_recipe_ingredients_ingredient ON recipe_ingredients(ingredient_id);

-- 6. Steps (烹饪步骤)
CREATE TABLE steps (
    step_id INT IDENTITY(1,1) PRIMARY KEY,
    recipe_id INT REFERENCES recipes(recipe_id) ON DELETE CASCADE,
    step_number INT NOT NULL,
    description NVARCHAR(MAX) NOT NULL,
    image_url NVARCHAR(255),
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

-- 8. User_Preferences (用户偏好)
-- SQL Server 不支持 JSONB 和 数组，使用 NVARCHAR(MAX) 存储 JSON 字符串
CREATE TABLE user_preferences (
    user_id INT PRIMARY KEY REFERENCES users(user_id) ON DELETE CASCADE,
    dietary_type NVARCHAR(MAX), -- e.g. '["vegan", "keto"]'
    allergies NVARCHAR(MAX), -- e.g. '[1, 2]'
    disliked_ingredients NVARCHAR(MAX), -- e.g. '[3, 4]'
    spicy_tolerance INT CHECK (spicy_tolerance BETWEEN 0 AND 5)
);

-- =============================================
-- 三、 交互与推荐域 (Interaction & RecSys Domain)
-- =============================================

-- 9. Collections (收藏夹)
CREATE TABLE collections (
    collection_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    name NVARCHAR(100) NOT NULL,
    is_public BIT DEFAULT 1
);
CREATE INDEX idx_collections_user ON collections(user_id);

-- 10. Collection_Items (收藏夹内容)
CREATE TABLE collection_items (
    collection_id INT REFERENCES collections(collection_id) ON DELETE CASCADE,
    recipe_id INT REFERENCES recipes(recipe_id) ON DELETE CASCADE,
    created_at DATETIME2 DEFAULT GETDATE(),
    PRIMARY KEY (collection_id, recipe_id)
);

-- 11. Reviews (评价)
CREATE TABLE reviews (
    review_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    recipe_id INT REFERENCES recipes(recipe_id) ON DELETE CASCADE,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    content NVARCHAR(MAX),
    image_url NVARCHAR(255),
    created_at DATETIME2 DEFAULT GETDATE()
);
CREATE INDEX idx_reviews_user ON reviews(user_id);
CREATE INDEX idx_reviews_recipe ON reviews(recipe_id);

-- 11.1 Review_Tags (评价标签)
CREATE TABLE review_tags (
    review_tag_id INT IDENTITY(1,1) PRIMARY KEY,
    review_id INT REFERENCES reviews(review_id) ON DELETE CASCADE,
    tag_name NVARCHAR(50) NOT NULL
);
CREATE INDEX idx_review_tags_review ON review_tags(review_id);

-- 12. User_Behavior_Logs (行为日志)
CREATE TABLE user_behavior_logs (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    recipe_id INT REFERENCES recipes(recipe_id),
    action_type NVARCHAR(20), -- view, share, print, add_to_cart, search
    duration INT, -- seconds
    search_keyword NVARCHAR(255),
    timestamp DATETIME2 DEFAULT GETDATE()
);
CREATE INDEX idx_logs_user ON user_behavior_logs(user_id);
CREATE INDEX idx_logs_recipe ON user_behavior_logs(recipe_id);
CREATE INDEX idx_logs_time ON user_behavior_logs(timestamp);

-- 13. Follows (社交关系)
CREATE TABLE follows (
    follower_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    followed_id INT REFERENCES users(user_id), -- 移除 CASCADE 避免多重级联路径
    created_at DATETIME2 DEFAULT GETDATE(),
    PRIMARY KEY (follower_id, followed_id)
);

-- =============================================
-- 四、 元数据与分类域 (Metadata Domain)
-- =============================================

-- 14. Tags (标签库)
CREATE TABLE tags (
    tag_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(50) UNIQUE NOT NULL
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
(N'中餐', NULL),
(N'西餐', NULL),
(N'川菜', 1),
(N'粤菜', 1),
(N'烘焙', 2);

-- Ingredients
INSERT INTO ingredients (name, category_id) VALUES
(N'鸡胸肉', 1),
(N'花生', 1),
(N'干辣椒', 1),
(N'鸡蛋', 1),
(N'面粉', 5);

-- Ingredient Aliases
INSERT INTO ingredient_aliases (ingredient_id, alias_name) VALUES
(1, 'chicken breast'), (1, N'鸡肉'),
(2, 'peanut'), (2, N'土豆'),
(3, 'dried chili'), (3, 'chili'),
(4, 'egg'), (4, N'鸡子'),
(5, 'flour');

-- Recipes
INSERT INTO recipes (title, description, difficulty, cooking_time, preparation_time, servings, author_id) VALUES
(N'宫保鸡丁', N'经典川菜，麻辣鲜香', 'Medium', 20, 15, N'2人份', 1),
(N'戚风蛋糕', N'松软可口的基础蛋糕', 'Hard', 60, 30, N'6寸', 2);

-- Recipe Stats
INSERT INTO recipe_stats (recipe_id, view_count, like_count) VALUES
(1, 0, 0),
(2, 0, 0);

-- Recipe_Ingredients
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, remark, is_main) VALUES
(1, 1, 300, 'g', N'切丁', 1),
(1, 2, 50, 'g', N'去皮', 0),
(1, 3, 10, 'g', N'剪段', 0),
(2, 4, 3, N'个', N'蛋黄蛋白分离', 1),
(2, 5, 100, 'g', N'过筛', 1);

-- Steps
INSERT INTO steps (recipe_id, step_number, description, timer_seconds) VALUES
(1, 1, N'鸡胸肉切丁，加入淀粉腌制', 600),
(1, 2, N'热锅凉油，放入干辣椒爆香', 30),
(1, 3, N'加入鸡丁滑炒至变色', 180),
(2, 1, N'打发蛋白至硬性发泡', 300),
(2, 2, N'混合蛋黄糊和蛋白霜', 120);

-- Nutrition
INSERT INTO nutrition (recipe_id, calories, protein, fat, carbohydrates, sodium) VALUES
(1, 450, 35, 20, 15, 800),
(2, 300, 8, 15, 40, 100);

-- Tags
INSERT INTO tags (name) VALUES (N'川菜'), (N'下饭菜'), (N'甜点'), (N'下午茶');

-- Recipe_Tags
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES
(1, 1), (1, 2),
(2, 3), (2, 4);

-- User_Preferences
INSERT INTO user_preferences (user_id, dietary_type, allergies, spicy_tolerance) VALUES
(2, '["low-carb"]', '[2]', 1);

-- Collections
INSERT INTO collections (user_id, name) VALUES (2, N'周末烘焙计划');

-- Collection_Items
INSERT INTO collection_items (collection_id, recipe_id) VALUES (1, 2);

-- Reviews
INSERT INTO reviews (user_id, recipe_id, rating, content) VALUES
(2, 1, 5, N'虽然有点辣，但是很好吃！'),
(3, 1, 4, N'不够辣，下次多放点辣椒');

-- Review Tags
INSERT INTO review_tags (review_id, tag_name) VALUES
(1, N'味道赞'), (1, N'做法简单'),
(2, N'不够辣');

-- Follows
INSERT INTO follows (follower_id, followed_id) VALUES (2, 1);
