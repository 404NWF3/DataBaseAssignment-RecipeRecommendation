-- ============================================================
-- AllRecipes 食谱网站数据库设计 - 建表脚本 (Oracle v3.0)
-- 包含26个表，完整的约束、索引和触发器
-- 修改多对多关系：采用联合主键设计
-- ============================================================

-- ============================================================
-- 清理已存在的对象（可选）
-- ============================================================

BEGIN
FOR cur IN (SELECT object_name FROM user_objects WHERE object_type='TABLE')
LOOP
EXECUTE IMMEDIATE 'DROP TABLE ' || cur.object_name || ' CASCADE CONSTRAINTS';
END LOOP;
FOR cur IN (SELECT sequence_name FROM user_sequences)
LOOP
EXECUTE IMMEDIATE 'DROP SEQUENCE ' || cur.sequence_name;
END LOOP;
END;
/

-- ============================================================
-- 第一部分：创建序列（主键自增）
-- ============================================================

CREATE SEQUENCE seq_users START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_ingredients START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_units START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_recipes START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_cooking_steps START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_nutrition_info START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_ratings START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_rating_helpfulness START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_comments START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_comment_helpfulness START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_saved_recipes START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_followers START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_tags START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_allergens START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_recipe_collections START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_shopping_lists START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_user_activity_log START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_meal_plans START WITH 1 INCREMENT BY 1;

-- ============================================================
-- 第二部分：核心基础表
-- ============================================================

-- 表1：USERS（用户表）
CREATE TABLE USERS (
    user_id NUMBER(10) PRIMARY KEY,
    username VARCHAR2(50) NOT NULL UNIQUE,
    email VARCHAR2(100) NOT NULL UNIQUE,
    password_hash VARCHAR2(255) NOT NULL,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    bio VARCHAR2(500),
    profile_image VARCHAR2(255),
    join_date DATE NOT NULL DEFAULT SYSDATE,
    last_login DATE,
    account_status VARCHAR2(20) NOT NULL DEFAULT 'active',
    user_type VARCHAR2(50) DEFAULT '普通用户',
    total_followers NUMBER(10) DEFAULT 0,
    total_recipes NUMBER(10) DEFAULT 0,
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT ck_account_status CHECK (account_status IN ('active', 'inactive', 'suspended')),
    CONSTRAINT ck_user_type CHECK (user_type IN ('普通用户', '专业厨师', '美食博主'))
);

-- 表2：INGREDIENTS（食材表）
CREATE TABLE INGREDIENTS (
    ingredient_id NUMBER(10) PRIMARY KEY,
    ingredient_name VARCHAR2(100) NOT NULL UNIQUE,
    category VARCHAR2(50) NOT NULL,
    description VARCHAR2(255),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- 表3：UNITS（单位表）
CREATE TABLE UNITS (
    unit_id NUMBER(10) PRIMARY KEY,
    unit_name VARCHAR2(50) NOT NULL UNIQUE,
    abbreviation VARCHAR2(20),
    description VARCHAR2(100),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- 表4：ALLERGENS（过敏原表）
CREATE TABLE ALLERGENS (
    allergen_id NUMBER(10) PRIMARY KEY,
    allergen_name VARCHAR2(100) NOT NULL UNIQUE,
    description VARCHAR2(255),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- 表5：TAGS（标签表）
CREATE TABLE TAGS (
    tag_id NUMBER(10) PRIMARY KEY,
    tag_name VARCHAR2(50) NOT NULL UNIQUE,
    tag_description VARCHAR2(255),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- ============================================================
-- 第三部分：食谱核心表
-- ============================================================

-- 表6：RECIPES（食谱表）
CREATE TABLE RECIPES (
    recipe_id NUMBER(10) PRIMARY KEY,
    user_id NUMBER(10) NOT NULL,
    recipe_name VARCHAR2(200) NOT NULL,
    description VARCHAR2(1000),
    cuisine_type VARCHAR2(50),
    meal_type VARCHAR2(20),
    difficulty_level VARCHAR2(20),
    prep_time NUMBER(5),
    cook_time NUMBER(5),
    total_time NUMBER(5),
    servings NUMBER(5),
    calories_per_serving NUMBER(10),
    image_url VARCHAR2(255),
    is_published VARCHAR2(1) NOT NULL DEFAULT 'Y',
    is_deleted VARCHAR2(1) NOT NULL DEFAULT 'N',
    view_count NUMBER(10) DEFAULT 0,
    rating_count NUMBER(10) DEFAULT 0,
    average_rating NUMBER(3,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_recipes_user FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    CONSTRAINT ck_meal_type CHECK (meal_type IN ('breakfast', 'lunch', 'dinner', 'snack', 'dessert')),
    CONSTRAINT ck_difficulty_level CHECK (difficulty_level IN ('easy', 'medium', 'hard')),
    CONSTRAINT ck_is_published CHECK (is_published IN ('Y', 'N')),
    CONSTRAINT ck_is_deleted CHECK (is_deleted IN ('Y', 'N')),
    CONSTRAINT ck_cook_time CHECK (cook_time > 0)
);

-- 表7：RECIPE_INGREDIENTS（食谱食材关联表 - 多对多 - 联合主键）
CREATE TABLE RECIPE_INGREDIENTS (
    recipe_id NUMBER(10) NOT NULL,
    ingredient_id NUMBER(10) NOT NULL,
    unit_id NUMBER(10) NOT NULL,
    quantity NUMBER(10,2) NOT NULL,
    notes VARCHAR2(255),
    added_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    PRIMARY KEY (recipe_id, ingredient_id),
    CONSTRAINT fk_ri_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE CASCADE,
    CONSTRAINT fk_ri_ingredient FOREIGN KEY (ingredient_id) REFERENCES INGREDIENTS(ingredient_id),
    CONSTRAINT fk_ri_unit FOREIGN KEY (unit_id) REFERENCES UNITS(unit_id)
);

-- 表8：COOKING_STEPS（烹饪步骤表）
CREATE TABLE COOKING_STEPS (
    step_id NUMBER(10),
    recipe_id NUMBER(10) NOT NULL,
    step_number NUMBER(5) NOT NULL,
    instruction VARCHAR2(1000) NOT NULL,
    time_required NUMBER(5),
    image_url VARCHAR2(255),
    PRIMARY KEY (step_id, recipe_id),
    CONSTRAINT fk_cs_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE CASCADE,
    CONSTRAINT uk_recipe_step UNIQUE (recipe_id, step_number)
);

-- 表9：NUTRITION_INFO（营养信息表）
CREATE TABLE NUTRITION_INFO (
    nutrition_id NUMBER(10),
    recipe_id NUMBER(10) NOT NULL UNIQUE,
    calories NUMBER(10),
    protein_grams NUMBER(10,2),
    carbs_grams NUMBER(10,2),
    fat_grams NUMBER(10,2),
    fiber_grams NUMBER(10,2),
    sugar_grams NUMBER(10,2),
    sodium_mg NUMBER(10),
    PRIMARY KEY (nutrition_id, recipe_id),
    CONSTRAINT fk_ni_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE CASCADE
);

-- 表10：INGREDIENT_ALLERGENS（食材过敏原关联表 - 多对多 - 联合主键）
CREATE TABLE INGREDIENT_ALLERGENS (
    ingredient_id NUMBER(10) NOT NULL,
    allergen_id NUMBER(10) NOT NULL,
    PRIMARY KEY (ingredient_id, allergen_id),
    CONSTRAINT fk_ia_ingredient FOREIGN KEY (ingredient_id) REFERENCES INGREDIENTS(ingredient_id),
    CONSTRAINT fk_ia_allergen FOREIGN KEY (allergen_id) REFERENCES ALLERGENS(allergen_id)
);

-- 表11：INGREDIENT_SUBSTITUTIONS（食材替代品关联表 - 多对多 - 联合主键）
CREATE TABLE INGREDIENT_SUBSTITUTIONS (
    original_ingredient_id NUMBER(10) NOT NULL,
    substitute_ingredient_id NUMBER(10) NOT NULL,
    substitution_ratio NUMBER(5,2),
    notes VARCHAR2(255),
    added_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    PRIMARY KEY (original_ingredient_id, substitute_ingredient_id),
    CONSTRAINT fk_is_original FOREIGN KEY (original_ingredient_id) REFERENCES INGREDIENTS(ingredient_id),
    CONSTRAINT fk_is_substitute FOREIGN KEY (substitute_ingredient_id) REFERENCES INGREDIENTS(ingredient_id),
    CONSTRAINT ck_different_ingredient CHECK (original_ingredient_id != substitute_ingredient_id)
);

-- ============================================================
-- 第四部分：用户交互表
-- ============================================================

-- 表12：RATINGS（食谱评价表）
CREATE TABLE RATINGS (
    rating_id NUMBER(10) PRIMARY KEY,
    user_id NUMBER(10) NOT NULL,
    recipe_id NUMBER(10) NOT NULL,
    rating_value NUMBER(3,2) NOT NULL,
    review_text VARCHAR2(1000),
    rating_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_ratings_user FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_ratings_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE CASCADE,
    CONSTRAINT uk_user_recipe_rating UNIQUE (user_id, recipe_id),
    CONSTRAINT ck_rating_value CHECK (rating_value >= 0 AND rating_value <= 5)
);

-- 表13：RATING_HELPFULNESS（评价有用性投票表 - 多对多 - 联合主键）
CREATE TABLE RATING_HELPFULNESS (
    rating_id NUMBER(10) NOT NULL,
    user_id NUMBER(10) NOT NULL,
    helpful_votes NUMBER(10) DEFAULT 0,
    voted_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    PRIMARY KEY (rating_id, user_id),
    CONSTRAINT fk_rh_rating FOREIGN KEY (rating_id) REFERENCES RATINGS(rating_id) ON DELETE CASCADE,
    CONSTRAINT fk_rh_user FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE
);

-- 表14：COMMENTS（评论表）
CREATE TABLE COMMENTS (
    comment_id NUMBER(10) PRIMARY KEY,
    user_id NUMBER(10) NOT NULL,
    recipe_id NUMBER(10) NOT NULL,
    comment_text VARCHAR2(1000) NOT NULL,
    parent_comment_id NUMBER(10),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_comments_user FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_comments_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE CASCADE,
    CONSTRAINT fk_comments_parent FOREIGN KEY (parent_comment_id) REFERENCES COMMENTS(comment_id) ON DELETE CASCADE
);

-- 表15：COMMENT_HELPFULNESS（评论有用性投票表 - 多对多 - 联合主键）
CREATE TABLE COMMENT_HELPFULNESS (
    comment_id NUMBER(10) NOT NULL,
    user_id NUMBER(10) NOT NULL,
    helpful_votes NUMBER(10) DEFAULT 0,
    voted_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    PRIMARY KEY (comment_id, user_id),
    CONSTRAINT fk_ch_comment FOREIGN KEY (comment_id) REFERENCES COMMENTS(comment_id) ON DELETE CASCADE,
    CONSTRAINT fk_ch_user FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE
);

-- 表16：SAVED_RECIPES（收藏食谱表）
CREATE TABLE SAVED_RECIPES (
    saved_recipe_id NUMBER(10) PRIMARY KEY,
    user_id NUMBER(10) NOT NULL,
    recipe_id NUMBER(10) NOT NULL,
    saved_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_sr_user FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_sr_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE CASCADE,
    CONSTRAINT uk_user_saved_recipe UNIQUE (user_id, recipe_id)
);

-- 表17：FOLLOWERS（用户关注关系表 - 自引用多对多 - 联合主键）
CREATE TABLE FOLLOWERS (
    user_id NUMBER(10) NOT NULL,
    follower_user_id NUMBER(10) NOT NULL,
    followed_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    PRIMARY KEY (user_id, follower_user_id),
    CONSTRAINT fk_followers_user FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_followers_follower FOREIGN KEY (follower_user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    CONSTRAINT ck_not_self_follow CHECK (user_id != follower_user_id)
);

-- 表18：USER_ALLERGIES（用户过敏原关联表 - 多对多 - 联合主键）
CREATE TABLE USER_ALLERGIES (
    user_id NUMBER(10) NOT NULL,
    allergen_id NUMBER(10) NOT NULL,
    added_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    PRIMARY KEY (user_id, allergen_id),
    CONSTRAINT fk_ua_user FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_ua_allergen FOREIGN KEY (allergen_id) REFERENCES ALLERGENS(allergen_id)
);

-- 表19：RECIPE_TAGS（食谱标签关联表 - 多对多 - 联合主键）
CREATE TABLE RECIPE_TAGS (
    recipe_id NUMBER(10) NOT NULL,
    tag_id NUMBER(10) NOT NULL,
    added_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    PRIMARY KEY (recipe_id, tag_id),
    CONSTRAINT fk_rt_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE CASCADE,
    CONSTRAINT fk_rt_tag FOREIGN KEY (tag_id) REFERENCES TAGS(tag_id)
);

-- 表20：USER_ACTIVITY_LOG（用户活动日志表）
CREATE TABLE USER_ACTIVITY_LOG (
    activity_id NUMBER(10) PRIMARY KEY,
    user_id NUMBER(10) NOT NULL,
    activity_type VARCHAR2(50),
    recipe_id NUMBER(10),
    activity_description VARCHAR2(255),
    activity_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_ual_user FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_ual_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE SET NULL
);

-- ============================================================
-- 第五部分：个人管理表
-- ============================================================

-- 表21：RECIPE_COLLECTIONS（食谱收藏清单表）
CREATE TABLE RECIPE_COLLECTIONS (
    collection_id NUMBER(10) PRIMARY KEY,
    user_id NUMBER(10) NOT NULL,
    collection_name VARCHAR2(100) NOT NULL,
    description VARCHAR2(500),
    is_public VARCHAR2(1) NOT NULL DEFAULT 'Y',
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_collection_user FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    CONSTRAINT ck_is_public CHECK (is_public IN ('Y', 'N'))
);

-- 表22：COLLECTION_RECIPES（清单食谱关联表 - 多对多 - 联合主键）
CREATE TABLE COLLECTION_RECIPES (
    collection_id NUMBER(10) NOT NULL,
    recipe_id NUMBER(10) NOT NULL,
    added_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    PRIMARY KEY (collection_id, recipe_id),
    CONSTRAINT fk_cr_collection FOREIGN KEY (collection_id) REFERENCES RECIPE_COLLECTIONS(collection_id) ON DELETE CASCADE,
    CONSTRAINT fk_cr_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE CASCADE
);

-- 表23：SHOPPING_LISTS（购物清单表）
CREATE TABLE SHOPPING_LISTS (
    list_id NUMBER(10) PRIMARY KEY,
    user_id NUMBER(10) NOT NULL,
    list_name VARCHAR2(100) NOT NULL,
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_shoplist_user FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE
);

-- 表24：SHOPPING_LIST_ITEMS（购物清单项目表 - 多对多 - 联合主键）
CREATE TABLE SHOPPING_LIST_ITEMS (
    list_id NUMBER(10) NOT NULL,
    ingredient_id NUMBER(10) NOT NULL,
    quantity NUMBER(10,2),
    unit_id NUMBER(10),
    is_checked VARCHAR2(1) NOT NULL DEFAULT 'N',
    added_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    PRIMARY KEY (list_id, ingredient_id),
    CONSTRAINT fk_sli_list FOREIGN KEY (list_id) REFERENCES SHOPPING_LISTS(list_id) ON DELETE CASCADE,
    CONSTRAINT fk_sli_ingredient FOREIGN KEY (ingredient_id) REFERENCES INGREDIENTS(ingredient_id),
    CONSTRAINT fk_sli_unit FOREIGN KEY (unit_id) REFERENCES UNITS(unit_id),
    CONSTRAINT ck_is_checked CHECK (is_checked IN ('Y', 'N'))
);

-- 表25：MEAL_PLANS（膳食计划表）
CREATE TABLE MEAL_PLANS (
    plan_id NUMBER(10) PRIMARY KEY,
    user_id NUMBER(10) NOT NULL,
    plan_name VARCHAR2(100) NOT NULL,
    description VARCHAR2(500),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_public VARCHAR2(1) NOT NULL DEFAULT 'Y',
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_mealplan_user FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    CONSTRAINT ck_meal_plan_dates CHECK (start_date <= end_date),
    CONSTRAINT ck_meal_plan_public CHECK (is_public IN ('Y', 'N'))
);

-- 表26：MEAL_PLAN_ENTRIES（膳食计划条目表 - 多对多 - 联合主键）
CREATE TABLE MEAL_PLAN_ENTRIES (
    plan_id NUMBER(10) NOT NULL,
    recipe_id NUMBER(10) NOT NULL,
    meal_date DATE NOT NULL,
    meal_type VARCHAR2(20),
    notes VARCHAR2(255),
    added_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    PRIMARY KEY (plan_id, recipe_id, meal_date),
    CONSTRAINT fk_mpe_plan FOREIGN KEY (plan_id) REFERENCES MEAL_PLANS(plan_id) ON DELETE CASCADE,
    CONSTRAINT fk_mpe_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE RESTRICT,
    CONSTRAINT ck_mpe_meal_type CHECK (meal_type IN ('breakfast', 'lunch', 'dinner', 'snack'))
);

-- ============================================================
-- 第六部分：创建索引以提升查询性能
-- ============================================================

-- 用户相关索引
CREATE INDEX idx_users_username ON USERS(username);
CREATE INDEX idx_users_email ON USERS(email);
CREATE INDEX idx_users_status ON USERS(account_status);

-- 食材相关索引
CREATE INDEX idx_ingredients_category ON INGREDIENTS(category);
CREATE INDEX idx_ingredients_name ON INGREDIENTS(ingredient_name);

-- 食谱相关索引
CREATE INDEX idx_recipes_user_id ON RECIPES(user_id);
CREATE INDEX idx_recipes_is_published ON RECIPES(is_published);
CREATE INDEX idx_recipes_difficulty ON RECIPES(difficulty_level);
CREATE INDEX idx_recipes_cuisine ON RECIPES(cuisine_type);
CREATE INDEX idx_recipes_created_at ON RECIPES(created_at);

-- 评价相关索引
CREATE INDEX idx_ratings_user_id ON RATINGS(user_id);
CREATE INDEX idx_ratings_recipe_id ON RATINGS(recipe_id);
CREATE INDEX idx_ratings_value ON RATINGS(rating_value);

-- 评论相关索引
CREATE INDEX idx_comments_user_id ON COMMENTS(user_id);
CREATE INDEX idx_comments_recipe_id ON COMMENTS(recipe_id);
CREATE INDEX idx_comments_created_at ON COMMENTS(created_at);

-- 关注相关索引
CREATE INDEX idx_followers_user_id ON FOLLOWERS(user_id);
CREATE INDEX idx_followers_follower_id ON FOLLOWERS(follower_user_id);

-- 收藏相关索引
CREATE INDEX idx_saved_recipes_user_id ON SAVED_RECIPES(user_id);
CREATE INDEX idx_saved_recipes_recipe_id ON SAVED_RECIPES(recipe_id);

-- 膳食计划索引
CREATE INDEX idx_meal_plans_user_id ON MEAL_PLANS(user_id);
CREATE INDEX idx_meal_plan_entries_plan_id ON MEAL_PLAN_ENTRIES(plan_id);
CREATE INDEX idx_meal_plan_entries_date ON MEAL_PLAN_ENTRIES(meal_date);

-- 购物清单索引
CREATE INDEX idx_shopping_lists_user_id ON SHOPPING_LISTS(user_id);
CREATE INDEX idx_shopping_list_items_list_id ON SHOPPING_LIST_ITEMS(list_id);

-- 清单索引
CREATE INDEX idx_collections_user_id ON RECIPE_COLLECTIONS(user_id);
CREATE INDEX idx_collection_recipes_collection_id ON COLLECTION_RECIPES(collection_id);
CREATE INDEX idx_collection_recipes_recipe_id ON COLLECTION_RECIPES(recipe_id);

-- ============================================================
-- 提交事务
-- ============================================================

COMMIT;

-- ============================================================
-- 输出验证信息
-- ============================================================

PROMPT
PROMPT ========== AllRecipes 数据库对象统计 ==========
PROMPT

SELECT 'TABLES' AS object_type, COUNT(*) AS count FROM user_tables
UNION ALL
SELECT 'INDEXES', COUNT(*) FROM user_indexes
UNION ALL
SELECT 'SEQUENCES', COUNT(*) FROM user_sequences;

PROMPT
PROMPT ========== 已创建的表列表 ==========
PROMPT

SELECT table_name FROM user_tables WHERE table_name NOT LIKE 'BIN$%' ORDER BY table_name;

PROMPT
PROMPT ========== 系统已就绪 ==========
