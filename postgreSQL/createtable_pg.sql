-- ============================================================
-- AllRecipes 食谱网站数据库设计 - PostgreSQL建表脚本 (v2.0)
-- 包含26个表、索引、触发器和约束
-- ============================================================

-- ============================================================
-- 第一部分：创建扩展
-- ============================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================
-- 第二部分：核心基础表
-- ============================================================

-- 表1：users（用户表）
CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    bio VARCHAR(500),
    profile_image VARCHAR(255),
    join_date DATE NOT NULL DEFAULT CURRENT_DATE,
    last_login TIMESTAMP,
    account_status VARCHAR(20) NOT NULL DEFAULT 'active',
    user_type VARCHAR(50) DEFAULT '普通用户',
    total_followers INTEGER DEFAULT 0,
    total_recipes INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ck_account_status CHECK (account_status IN ('active', 'inactive', 'suspended')),
    CONSTRAINT ck_user_type CHECK (user_type IN ('普通用户', '专业厨师', '美食博主'))
);

-- 表2：ingredients（食材表）
CREATE TABLE IF NOT EXISTS ingredients (
    ingredient_id SERIAL PRIMARY KEY,
    ingredient_name VARCHAR(100) NOT NULL UNIQUE,
    category VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 表3：units（单位表）
CREATE TABLE IF NOT EXISTS units (
    unit_id SERIAL PRIMARY KEY,
    unit_name VARCHAR(50) NOT NULL UNIQUE,
    abbreviation VARCHAR(20),
    description VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 表4：allergens（过敏原表）
CREATE TABLE IF NOT EXISTS allergens (
    allergen_id SERIAL PRIMARY KEY,
    allergen_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 表5：tags（标签表）
CREATE TABLE IF NOT EXISTS tags (
    tag_id SERIAL PRIMARY KEY,
    tag_name VARCHAR(50) NOT NULL UNIQUE,
    tag_description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 表6：user_allergies（用户过敏原表）
CREATE TABLE IF NOT EXISTS user_allergies (
    user_allergy_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    allergen_id INTEGER NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (allergen_id) REFERENCES allergens(allergen_id),
    UNIQUE (user_id, allergen_id)
);

-- ============================================================
-- 第三部分：食谱核心表
-- ============================================================

-- 表7：recipes（食谱表）
CREATE TABLE IF NOT EXISTS recipes (
    recipe_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    recipe_name VARCHAR(200) NOT NULL,
    description VARCHAR(1000),
    cuisine_type VARCHAR(50),
    meal_type VARCHAR(20),
    difficulty_level VARCHAR(20),
    prep_time INTEGER,
    cook_time INTEGER,
    total_time INTEGER,
    servings INTEGER,
    calories_per_serving INTEGER,
    image_url VARCHAR(255),
    is_published BOOLEAN NOT NULL DEFAULT TRUE,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
    view_count INTEGER DEFAULT 0,
    rating_count INTEGER DEFAULT 0,
    average_rating NUMERIC(3,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT ck_meal_type CHECK (meal_type IN ('breakfast', 'lunch', 'dinner', 'snack', 'dessert')),
    CONSTRAINT ck_difficulty_level CHECK (difficulty_level IN ('easy', 'medium', 'hard')),
    CONSTRAINT ck_cook_time CHECK (cook_time > 0 OR cook_time IS NULL)
);

-- 表8：recipe_ingredients（食谱食材表）
CREATE TABLE IF NOT EXISTS recipe_ingredients (
    recipe_ingredient_id SERIAL PRIMARY KEY,
    recipe_id INTEGER NOT NULL,
    ingredient_id INTEGER NOT NULL,
    unit_id INTEGER NOT NULL,
    quantity NUMERIC(10,2) NOT NULL,
    notes VARCHAR(255),
    FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE CASCADE,
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(ingredient_id),
    FOREIGN KEY (unit_id) REFERENCES units(unit_id),
    UNIQUE (recipe_id, ingredient_id)
);

-- 表9：cooking_steps（烹饪步骤表）
CREATE TABLE IF NOT EXISTS cooking_steps (
    step_id SERIAL PRIMARY KEY,
    recipe_id INTEGER NOT NULL,
    step_number INTEGER NOT NULL,
    instruction VARCHAR(1000) NOT NULL,
    time_required INTEGER,
    image_url VARCHAR(255),
    FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE CASCADE,
    UNIQUE (recipe_id, step_number)
);

-- 表10：nutrition_info（营养信息表）
CREATE TABLE IF NOT EXISTS nutrition_info (
    nutrition_id SERIAL PRIMARY KEY,
    recipe_id INTEGER NOT NULL UNIQUE,
    calories INTEGER,
    protein_grams NUMERIC(10,2),
    carbs_grams NUMERIC(10,2),
    fat_grams NUMERIC(10,2),
    fiber_grams NUMERIC(10,2),
    sugar_grams NUMERIC(10,2),
    sodium_mg INTEGER,
    FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE CASCADE
);

-- 表11：ingredient_allergens（食材过敏原表）
CREATE TABLE IF NOT EXISTS ingredient_allergens (
    ingredient_allergen_id SERIAL PRIMARY KEY,
    ingredient_id INTEGER NOT NULL,
    allergen_id INTEGER NOT NULL,
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(ingredient_id),
    FOREIGN KEY (allergen_id) REFERENCES allergens(allergen_id),
    UNIQUE (ingredient_id, allergen_id)
);

-- 表12：recipe_tags（食谱标签表）
CREATE TABLE IF NOT EXISTS recipe_tags (
    recipe_tag_id SERIAL PRIMARY KEY,
    recipe_id INTEGER NOT NULL,
    tag_id INTEGER NOT NULL,
    FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(tag_id),
    UNIQUE (recipe_id, tag_id)
);

-- 表13：ingredient_substitutions（食材替代品表）
CREATE TABLE IF NOT EXISTS ingredient_substitutions (
    substitution_id SERIAL PRIMARY KEY,
    original_ingredient_id INTEGER NOT NULL,
    substitute_ingredient_id INTEGER NOT NULL,
    ratio NUMERIC(5,2) DEFAULT 1.0,
    notes VARCHAR(500),
    approval_status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (original_ingredient_id) REFERENCES ingredients(ingredient_id),
    FOREIGN KEY (substitute_ingredient_id) REFERENCES ingredients(ingredient_id),
    CONSTRAINT ck_ratio CHECK (ratio > 0 AND ratio <= 5),
    CONSTRAINT ck_approval_status CHECK (approval_status IN ('pending', 'approved', 'rejected'))
);

-- ============================================================
-- 第四部分：用户交互表
-- ============================================================

-- 表14：ratings（评价表）
CREATE TABLE IF NOT EXISTS ratings (
    rating_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    recipe_id INTEGER NOT NULL,
    rating_value NUMERIC(3,2) NOT NULL,
    review_text VARCHAR(1000),
    rating_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE CASCADE,
    UNIQUE (user_id, recipe_id),
    CONSTRAINT ck_rating_value CHECK (rating_value >= 0 AND rating_value <= 5)
);

-- 表15：rating_helpfulness（评价有用性投票表）
CREATE TABLE IF NOT EXISTS rating_helpfulness (
    helpful_id SERIAL PRIMARY KEY,
    rating_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    voted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (rating_id) REFERENCES ratings(rating_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE (rating_id, user_id)
);

-- 表16：comments（评论表）
CREATE TABLE IF NOT EXISTS comments (
    comment_id SERIAL PRIMARY KEY,
    recipe_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    parent_comment_id INTEGER,
    comment_text VARCHAR(1000) NOT NULL,
    is_deleted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (parent_comment_id) REFERENCES comments(comment_id) ON DELETE SET NULL
);

-- 表17：comment_helpfulness（评论有用性投票表）
CREATE TABLE IF NOT EXISTS comment_helpfulness (
    helpful_id SERIAL PRIMARY KEY,
    comment_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    voted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (comment_id) REFERENCES comments(comment_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE (comment_id, user_id)
);

-- 表18：saved_recipes（收藏食谱表）
CREATE TABLE IF NOT EXISTS saved_recipes (
    saved_recipe_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    recipe_id INTEGER NOT NULL,
    saved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE CASCADE,
    UNIQUE (user_id, recipe_id)
);

-- 表19：followers（关注表）
CREATE TABLE IF NOT EXISTS followers (
    follower_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    follower_user_id INTEGER NOT NULL,
    followed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (follower_user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE (user_id, follower_user_id),
    CONSTRAINT ck_not_self_follow CHECK (user_id != follower_user_id)
);

-- 表20：user_activity_log（用户活动日志表）
CREATE TABLE IF NOT EXISTS user_activity_log (
    activity_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    activity_type VARCHAR(50),
    activity_description VARCHAR(500),
    related_recipe_id INTEGER,
    activity_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (related_recipe_id) REFERENCES recipes(recipe_id) ON DELETE SET NULL
);

-- ============================================================
-- 第五部分：个人管理表
-- ============================================================

-- 表21：recipe_collections（食谱清单表）
CREATE TABLE IF NOT EXISTS recipe_collections (
    collection_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    collection_name VARCHAR(100) NOT NULL,
    description VARCHAR(500),
    is_public BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 表22：collection_recipes（清单食谱关联表）
CREATE TABLE IF NOT EXISTS collection_recipes (
    collection_recipe_id SERIAL PRIMARY KEY,
    collection_id INTEGER NOT NULL,
    recipe_id INTEGER NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (collection_id) REFERENCES recipe_collections(collection_id) ON DELETE CASCADE,
    FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE CASCADE,
    UNIQUE (collection_id, recipe_id)
);

-- 表23：shopping_lists（购物清单表）
CREATE TABLE IF NOT EXISTS shopping_lists (
    list_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    list_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 表24：shopping_list_items（购物清单项表）
CREATE TABLE IF NOT EXISTS shopping_list_items (
    item_id SERIAL PRIMARY KEY,
    list_id INTEGER NOT NULL,
    ingredient_id INTEGER NOT NULL,
    quantity NUMERIC(10,2),
    unit_id INTEGER,
    is_checked BOOLEAN DEFAULT FALSE,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (list_id) REFERENCES shopping_lists(list_id) ON DELETE CASCADE,
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(ingredient_id),
    FOREIGN KEY (unit_id) REFERENCES units(unit_id)
);

-- 表25：meal_plans（膳食计划表）
CREATE TABLE IF NOT EXISTS meal_plans (
    plan_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    plan_name VARCHAR(100) NOT NULL,
    description VARCHAR(500),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_public BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT ck_meal_plan_dates CHECK (start_date <= end_date)
);

-- 表26：meal_plan_entries（膳食计划条目表）
CREATE TABLE IF NOT EXISTS meal_plan_entries (
    entry_id SERIAL PRIMARY KEY,
    plan_id INTEGER NOT NULL,
    recipe_id INTEGER NOT NULL,
    meal_date DATE NOT NULL,
    meal_type VARCHAR(20),
    notes VARCHAR(255),
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (plan_id) REFERENCES meal_plans(plan_id) ON DELETE CASCADE,
    FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE RESTRICT
);

-- ============================================================
-- 第六部分：创建索引
-- ============================================================

-- 用户表索引
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_join_date ON users(join_date);

-- 食谱表索引
CREATE INDEX idx_recipes_user_id ON recipes(user_id);
CREATE INDEX idx_recipes_cuisine_type ON recipes(cuisine_type);
CREATE INDEX idx_recipes_meal_type ON recipes(meal_type);
CREATE INDEX idx_recipes_created_at ON recipes(created_at DESC);
CREATE INDEX idx_recipes_average_rating ON recipes(average_rating DESC);
CREATE INDEX idx_recipes_is_published ON recipes(is_published) WHERE is_published = TRUE;
CREATE INDEX idx_recipes_published_rating ON recipes(is_published, average_rating DESC) 
    WHERE is_published = TRUE;

-- 食材相关表索引
CREATE INDEX idx_ri_recipe_id ON recipe_ingredients(recipe_id);
CREATE INDEX idx_ri_ingredient_id ON recipe_ingredients(ingredient_id);

-- 评分和评论索引
CREATE INDEX idx_ratings_recipe_id ON ratings(recipe_id);
CREATE INDEX idx_ratings_user_id ON ratings(user_id);
CREATE INDEX idx_ratings_date ON ratings(rating_date DESC);
CREATE INDEX idx_comments_recipe_id ON comments(recipe_id);
CREATE INDEX idx_comments_user_id ON comments(user_id);
CREATE INDEX idx_comments_created_at ON comments(created_at DESC);

-- 社交关系索引
CREATE INDEX idx_followers_user_id ON followers(user_id);
CREATE INDEX idx_followers_follower_user_id ON followers(follower_user_id);

-- 个人管理索引
CREATE INDEX idx_sl_user_id ON shopping_lists(user_id);
CREATE INDEX idx_sli_list_id ON shopping_list_items(list_id);
CREATE INDEX idx_saved_recipes_user ON saved_recipes(user_id);

-- 活动日志索引
CREATE INDEX idx_al_user_id ON user_activity_log(user_id);
CREATE INDEX idx_al_timestamp ON user_activity_log(activity_timestamp DESC);

-- 新增表索引
CREATE INDEX idx_mp_user_id ON meal_plans(user_id);
CREATE INDEX idx_mpe_plan_id ON meal_plan_entries(plan_id);
CREATE INDEX idx_mpe_meal_date ON meal_plan_entries(meal_date);
CREATE INDEX idx_sub_original ON ingredient_substitutions(original_ingredient_id);
CREATE INDEX idx_sub_status ON ingredient_substitutions(approval_status);
CREATE INDEX idx_rh_rating_id ON rating_helpfulness(rating_id);
CREATE INDEX idx_rh_user_id ON rating_helpfulness(user_id);
CREATE INDEX idx_ch_comment_id ON comment_helpfulness(comment_id);
CREATE INDEX idx_ch_user_id ON comment_helpfulness(user_id);
CREATE INDEX idx_ua_user_id ON user_allergies(user_id);
CREATE INDEX idx_ua_allergen_id ON user_allergies(allergen_id);

-- ============================================================
-- 第七部分：创建触发器函数和触发器
-- ============================================================

-- 触发器函数1：更新食谱评分和计数
CREATE OR REPLACE FUNCTION update_recipe_stats()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE recipes SET 
        average_rating = ROUND(
            COALESCE((SELECT AVG(rating_value) FROM ratings WHERE recipe_id = NEW.recipe_id), 0)::numeric, 2
        ),
        rating_count = (SELECT COUNT(*) FROM ratings WHERE recipe_id = NEW.recipe_id),
        updated_at = CURRENT_TIMESTAMP
    WHERE recipe_id = NEW.recipe_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 创建触发器
CREATE TRIGGER trg_update_recipe_stats
AFTER INSERT OR DELETE ON ratings
FOR EACH ROW EXECUTE FUNCTION update_recipe_stats();

-- 触发器函数2：更新用户粉丝计数
CREATE OR REPLACE FUNCTION update_user_followers()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE users SET total_followers = total_followers + 1 WHERE user_id = NEW.user_id;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE users SET total_followers = total_followers - 1 WHERE user_id = OLD.user_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 创建触发器
CREATE TRIGGER trg_update_user_followers
AFTER INSERT OR DELETE ON followers
FOR EACH ROW EXECUTE FUNCTION update_user_followers();

-- 触发器函数3：更新用户食谱计数
CREATE OR REPLACE FUNCTION update_user_recipes()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE users SET total_recipes = total_recipes + 1 WHERE user_id = NEW.user_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 创建触发器
CREATE TRIGGER trg_update_user_recipes
AFTER INSERT ON recipes
FOR EACH ROW EXECUTE FUNCTION update_user_recipes();

-- 触发器函数4：记录用户活动
CREATE OR REPLACE FUNCTION log_recipe_publish()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO user_activity_log (user_id, activity_type, activity_description, related_recipe_id)
    VALUES (NEW.user_id, 'recipe_published', '发布了食谱：' || NEW.recipe_name, NEW.recipe_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 创建触发器
CREATE TRIGGER trg_log_recipe_publish
AFTER INSERT ON recipes
FOR EACH ROW EXECUTE FUNCTION log_recipe_publish();

-- ============================================================
-- 第八部分：示例数据
-- ============================================================

-- 插入单位数据
INSERT INTO units (unit_name, abbreviation, description) VALUES 
    ('克', 'g', '重量单位'),
    ('毫升', 'ml', '容量单位'),
    ('杯', 'cup', '容量单位'),
    ('汤匙', 'tbsp', '容量单位'),
    ('茶匙', 'tsp', '容量单位'),
    ('个', 'pc', '数量单位')
ON CONFLICT DO NOTHING;

-- 插入过敏原数据
INSERT INTO allergens (allergen_name, description) VALUES 
    ('花生', '花生类过敏原'),
    ('坚果', '树坚果类过敏原'),
    ('乳制品', '奶类过敏原'),
    ('鸡蛋', '蛋类过敏原'),
    ('海鲜', '甲壳类和鱼类过敏原'),
    ('小麦', '谷类过敏原')
ON CONFLICT DO NOTHING;

-- 插入标签数据
INSERT INTO tags (tag_name, tag_description) VALUES 
    ('素食', '不含肉类的食谱'),
    ('低脂', '低脂肪食谱'),
    ('快手菜', '30分钟内可完成'),
    ('烘焙', '面包和甜点类'),
    ('无麸质', '不含谷类蛋白质')
ON CONFLICT DO NOTHING;

-- 插入食材数据
INSERT INTO ingredients (ingredient_name, category, description) VALUES 
    ('鸡蛋', '蛋类', '新鲜鸡蛋'),
    ('面粉', '粮食', '通用小麦面粉'),
    ('牛奶', '乳制品', '全脂牛奶'),
    ('盐', '调味料', '食用盐'),
    ('糖', '调味料', '白砂糖')
ON CONFLICT DO NOTHING;

-- 插入示例用户
INSERT INTO users (username, email, password_hash, first_name, last_name, bio, account_status, user_type) VALUES 
    ('chef_john', 'chef@example.com', crypt('Password123', gen_salt('bf')), 'John', 'Doe', 
     '专业厨师，热爱分享美食', 'active', '专业厨师'),
    ('food_blogger_maria', 'maria@example.com', crypt('Password456', gen_salt('bf')), 'Maria', 'Garcia',
     '美食博主，探索世界美食', 'active', '美食博主')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 验证脚本
-- ============================================================

-- 查看所有表
\dt

-- 查看所有索引
\di

-- 查看表结构
\d users
\d recipes
\d ratings

-- 查看触发器
SELECT trigger_name, event_object_table FROM information_schema.triggers 
WHERE trigger_schema = 'public';

-- 验证数据
SELECT COUNT(*) as units_count FROM units;
SELECT COUNT(*) as allergens_count FROM allergens;
SELECT COUNT(*) as tags_count FROM tags;
SELECT COUNT(*) as users_count FROM users;

COMMIT;
