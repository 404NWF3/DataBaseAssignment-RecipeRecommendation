-- =====================================================================
-- AllRecipes 食谱网站数据库设计
-- 数据库：Oracle 11g
-- 创建日期：2025年12月
-- 设计规范：BCNF （Boyce-Codd Normal Form）
-- =====================================================================

-- 1. 用户表（USERS）
CREATE TABLE USERS (
    user_id         NUMBER(10) PRIMARY KEY,
    username        VARCHAR2(50) NOT NULL UNIQUE,
    email           VARCHAR2(100) NOT NULL UNIQUE,
    password_hash   VARCHAR2(255) NOT NULL,
    first_name      VARCHAR2(50),
    last_name       VARCHAR2(50),
    bio             VARCHAR2(500),
    profile_image   VARCHAR2(255),
    join_date       DATE NOT NULL DEFAULT SYSDATE,
    last_login      DATE,
    account_status  VARCHAR2(20) DEFAULT 'active' CHECK (account_status IN ('active', 'inactive', 'suspended')),
    total_followers NUMBER(10) DEFAULT 0,
    total_recipes   NUMBER(10) DEFAULT 0,
    created_at      TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at      TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- 2. 食材表（INGREDIENTS）
CREATE TABLE INGREDIENTS (
    ingredient_id   NUMBER(10) PRIMARY KEY,
    ingredient_name VARCHAR2(100) NOT NULL UNIQUE,
    category        VARCHAR2(50) NOT NULL,
    description     VARCHAR2(255),
    created_at      TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- 3. 单位表（UNITS）
CREATE TABLE UNITS (
    unit_id         NUMBER(10) PRIMARY KEY,
    unit_name       VARCHAR2(50) NOT NULL UNIQUE,
    abbreviation    VARCHAR2(20),
    description     VARCHAR2(100),
    created_at      TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- 4. 食谱表（RECIPES）
CREATE TABLE RECIPES (
    recipe_id       NUMBER(10) PRIMARY KEY,
    user_id         NUMBER(10) NOT NULL,
    recipe_name     VARCHAR2(200) NOT NULL,
    description     VARCHAR2(1000),
    cuisine_type    VARCHAR2(50),
    meal_type       VARCHAR2(50) CHECK (meal_type IN ('breakfast', 'lunch', 'dinner', 'snack', 'dessert')),
    difficulty_level VARCHAR2(20) CHECK (difficulty_level IN ('easy', 'medium', 'hard')),
    prep_time       NUMBER(5),
    cook_time       NUMBER(5),
    total_time      NUMBER(5),
    servings        NUMBER(5),
    calories_per_serving NUMBER(10),
    image_url       VARCHAR2(255),
    is_published    VARCHAR2(1) DEFAULT 'Y' CHECK (is_published IN ('Y', 'N')),
    is_deleted      VARCHAR2(1) DEFAULT 'N' CHECK (is_deleted IN ('Y', 'N')),
    view_count      NUMBER(10) DEFAULT 0,
    rating_count    NUMBER(10) DEFAULT 0,
    average_rating  NUMBER(3,2) DEFAULT 0,
    created_at      TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at      TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_recipes_user FOREIGN KEY (user_id) REFERENCES USERS(user_id)
);

-- 5. 食谱食材表（RECIPE_INGREDIENTS）
CREATE TABLE RECIPE_INGREDIENTS (
    recipe_ingredient_id NUMBER(10) PRIMARY KEY,
    recipe_id       NUMBER(10) NOT NULL,
    ingredient_id   NUMBER(10) NOT NULL,
    unit_id         NUMBER(10) NOT NULL,
    quantity        NUMBER(10,2) NOT NULL,
    notes           VARCHAR2(255),
    CONSTRAINT fk_ri_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id),
    CONSTRAINT fk_ri_ingredient FOREIGN KEY (ingredient_id) REFERENCES INGREDIENTS(ingredient_id),
    CONSTRAINT fk_ri_unit FOREIGN KEY (unit_id) REFERENCES UNITS(unit_id),
    CONSTRAINT uk_recipe_ingredient UNIQUE (recipe_id, ingredient_id)
);

-- 6. 烹饪步骤表（COOKING_STEPS）
CREATE TABLE COOKING_STEPS (
    step_id         NUMBER(10) PRIMARY KEY,
    recipe_id       NUMBER(10) NOT NULL,
    step_number     NUMBER(5) NOT NULL,
    instruction     VARCHAR2(1000) NOT NULL,
    time_required   NUMBER(5),
    image_url       VARCHAR2(255),
    CONSTRAINT fk_steps_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id),
    CONSTRAINT uk_recipe_step UNIQUE (recipe_id, step_number)
);

-- 7. 用户收藏表（SAVED_RECIPES）
CREATE TABLE SAVED_RECIPES (
    saved_recipe_id NUMBER(10) PRIMARY KEY,
    user_id         NUMBER(10) NOT NULL,
    recipe_id       NUMBER(10) NOT NULL,
    saved_at        TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_sr_user FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    CONSTRAINT fk_sr_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id),
    CONSTRAINT uk_user_recipe UNIQUE (user_id, recipe_id)
);

-- 8. 用户评价表（RATINGS）
CREATE TABLE RATINGS (
    rating_id       NUMBER(10) PRIMARY KEY,
    user_id         NUMBER(10) NOT NULL,
    recipe_id       NUMBER(10) NOT NULL,
    rating_value    NUMBER(2,1) NOT NULL CHECK (rating_value >= 0 AND rating_value <= 5),
    review_text     VARCHAR2(2000),
    helpful_count   NUMBER(10) DEFAULT 0,
    rating_date     TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at      TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_rating_user FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    CONSTRAINT fk_rating_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id),
    CONSTRAINT uk_user_recipe_rating UNIQUE (user_id, recipe_id)
);

-- 9. 评论表（COMMENTS）
CREATE TABLE COMMENTS (
    comment_id      NUMBER(10) PRIMARY KEY,
    recipe_id       NUMBER(10) NOT NULL,
    user_id         NUMBER(10) NOT NULL,
    parent_comment_id NUMBER(10),
    comment_text    VARCHAR2(2000) NOT NULL,
    helpful_count   NUMBER(10) DEFAULT 0,
    is_deleted      VARCHAR2(1) DEFAULT 'N' CHECK (is_deleted IN ('Y', 'N')),
    created_at      TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at      TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_comment_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id),
    CONSTRAINT fk_comment_user FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    CONSTRAINT fk_comment_parent FOREIGN KEY (parent_comment_id) REFERENCES COMMENTS(comment_id)
);

-- 10. 标签表（TAGS）
CREATE TABLE TAGS (
    tag_id          NUMBER(10) PRIMARY KEY,
    tag_name        VARCHAR2(50) NOT NULL UNIQUE,
    tag_description VARCHAR2(255),
    created_at      TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- 11. 食谱标签表（RECIPE_TAGS）
CREATE TABLE RECIPE_TAGS (
    recipe_tag_id   NUMBER(10) PRIMARY KEY,
    recipe_id       NUMBER(10) NOT NULL,
    tag_id          NUMBER(10) NOT NULL,
    CONSTRAINT fk_rt_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id),
    CONSTRAINT fk_rt_tag FOREIGN KEY (tag_id) REFERENCES TAGS(tag_id),
    CONSTRAINT uk_recipe_tag UNIQUE (recipe_id, tag_id)
);

-- 12. 用户关注表（FOLLOWERS）
CREATE TABLE FOLLOWERS (
    follower_id     NUMBER(10) PRIMARY KEY,
    user_id         NUMBER(10) NOT NULL,
    follower_user_id NUMBER(10) NOT NULL,
    followed_at     TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_follow_user FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    CONSTRAINT fk_follow_follower FOREIGN KEY (follower_user_id) REFERENCES USERS(user_id),
    CONSTRAINT uk_follower UNIQUE (user_id, follower_user_id),
    CONSTRAINT ck_not_self_follow CHECK (user_id != follower_user_id)
);

-- 13. 食谱收藏清单表（RECIPE_COLLECTIONS）
CREATE TABLE RECIPE_COLLECTIONS (
    collection_id   NUMBER(10) PRIMARY KEY,
    user_id         NUMBER(10) NOT NULL,
    collection_name VARCHAR2(100) NOT NULL,
    description     VARCHAR2(500),
    is_public       VARCHAR2(1) DEFAULT 'Y' CHECK (is_public IN ('Y', 'N')),
    created_at      TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at      TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_rc_user FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    CONSTRAINT uk_user_collection UNIQUE (user_id, collection_name)
);

-- 14. 清单内食谱表（COLLECTION_RECIPES）
CREATE TABLE COLLECTION_RECIPES (
    collection_recipe_id NUMBER(10) PRIMARY KEY,
    collection_id   NUMBER(10) NOT NULL,
    recipe_id       NUMBER(10) NOT NULL,
    added_at        TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_colr_collection FOREIGN KEY (collection_id) REFERENCES RECIPE_COLLECTIONS(collection_id),
    CONSTRAINT fk_colr_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id),
    CONSTRAINT uk_collection_recipe UNIQUE (collection_id, recipe_id)
);

-- 15. 购物清单表（SHOPPING_LISTS）
CREATE TABLE SHOPPING_LISTS (
    list_id         NUMBER(10) PRIMARY KEY,
    user_id         NUMBER(10) NOT NULL,
    list_name       VARCHAR2(100) NOT NULL,
    created_at      TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at      TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_sl_user FOREIGN KEY (user_id) REFERENCES USERS(user_id)
);

-- 16. 购物清单项目表（SHOPPING_LIST_ITEMS）
CREATE TABLE SHOPPING_LIST_ITEMS (
    item_id         NUMBER(10) PRIMARY KEY,
    list_id         NUMBER(10) NOT NULL,
    ingredient_id   NUMBER(10) NOT NULL,
    quantity        NUMBER(10,2),
    unit_id         NUMBER(10),
    is_checked      VARCHAR2(1) DEFAULT 'N' CHECK (is_checked IN ('Y', 'N')),
    added_at        TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_sli_list FOREIGN KEY (list_id) REFERENCES SHOPPING_LISTS(list_id),
    CONSTRAINT fk_sli_ingredient FOREIGN KEY (ingredient_id) REFERENCES INGREDIENTS(ingredient_id),
    CONSTRAINT fk_sli_unit FOREIGN KEY (unit_id) REFERENCES UNITS(unit_id)
);

-- 17. 用户活动日志表（USER_ACTIVITY_LOG）
CREATE TABLE USER_ACTIVITY_LOG (
    activity_id     NUMBER(10) PRIMARY KEY,
    user_id         NUMBER(10) NOT NULL,
    activity_type   VARCHAR2(50) NOT NULL,
    activity_description VARCHAR2(500),
    related_recipe_id NUMBER(10),
    activity_timestamp TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_al_user FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    CONSTRAINT fk_al_recipe FOREIGN KEY (related_recipe_id) REFERENCES RECIPES(recipe_id)
);

-- 18. 过敏原表（ALLERGENS）
CREATE TABLE ALLERGENS (
    allergen_id     NUMBER(10) PRIMARY KEY,
    allergen_name   VARCHAR2(100) NOT NULL UNIQUE,
    description     VARCHAR2(255),
    created_at      TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- 19. 食材过敏原表（INGREDIENT_ALLERGENS）
CREATE TABLE INGREDIENT_ALLERGENS (
    ingredient_allergen_id NUMBER(10) PRIMARY KEY,
    ingredient_id   NUMBER(10) NOT NULL,
    allergen_id     NUMBER(10) NOT NULL,
    CONSTRAINT fk_ia_ingredient FOREIGN KEY (ingredient_id) REFERENCES INGREDIENTS(ingredient_id),
    CONSTRAINT fk_ia_allergen FOREIGN KEY (allergen_id) REFERENCES ALLERGENS(allergen_id),
    CONSTRAINT uk_ingredient_allergen UNIQUE (ingredient_id, allergen_id)
);

-- 20. 营养信息表（NUTRITION_INFO）
CREATE TABLE NUTRITION_INFO (
    nutrition_id    NUMBER(10) PRIMARY KEY,
    recipe_id       NUMBER(10) NOT NULL UNIQUE,
    calories        NUMBER(10),
    protein_grams   NUMBER(10,2),
    carbs_grams     NUMBER(10,2),
    fat_grams       NUMBER(10,2),
    fiber_grams     NUMBER(10,2),
    sugar_grams     NUMBER(10,2),
    sodium_mg       NUMBER(10),
    CONSTRAINT fk_ni_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id)
);

-- =====================================================================
-- 创建索引以提升查询性能
-- =====================================================================

-- 用户表索引
CREATE INDEX idx_users_email ON USERS(email);
CREATE INDEX idx_users_username ON USERS(username);
CREATE INDEX idx_users_join_date ON USERS(join_date);

-- 食谱表索引
CREATE INDEX idx_recipes_user_id ON RECIPES(user_id);
CREATE INDEX idx_recipes_cuisine_type ON RECIPES(cuisine_type);
CREATE INDEX idx_recipes_meal_type ON RECIPES(meal_type);
CREATE INDEX idx_recipes_created_at ON RECIPES(created_at);
CREATE INDEX idx_recipes_average_rating ON RECIPES(average_rating);
CREATE INDEX idx_recipes_is_published ON RECIPES(is_published);

-- 食谱食材表索引
CREATE INDEX idx_ri_recipe_id ON RECIPE_INGREDIENTS(recipe_id);
CREATE INDEX idx_ri_ingredient_id ON RECIPE_INGREDIENTS(ingredient_id);

-- 评分表索引
CREATE INDEX idx_ratings_recipe_id ON RATINGS(recipe_id);
CREATE INDEX idx_ratings_user_id ON RATINGS(user_id);
CREATE INDEX idx_ratings_date ON RATINGS(rating_date);

-- 评论表索引
CREATE INDEX idx_comments_recipe_id ON COMMENTS(recipe_id);
CREATE INDEX idx_comments_user_id ON COMMENTS(user_id);
CREATE INDEX idx_comments_created_at ON COMMENTS(created_at);

-- 关注表索引
CREATE INDEX idx_followers_user_id ON FOLLOWERS(user_id);
CREATE INDEX idx_followers_follower_user_id ON FOLLOWERS(follower_user_id);

-- 购物清单索引
CREATE INDEX idx_sl_user_id ON SHOPPING_LISTS(user_id);
CREATE INDEX idx_sli_list_id ON SHOPPING_LIST_ITEMS(list_id);

-- 活动日志索引
CREATE INDEX idx_al_user_id ON USER_ACTIVITY_LOG(user_id);
CREATE INDEX idx_al_timestamp ON USER_ACTIVITY_LOG(activity_timestamp);

-- =====================================================================
-- 创建序列以生成主键
-- =====================================================================

CREATE SEQUENCE seq_users START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_ingredients START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_units START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_recipes START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_recipe_ingredients START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_cooking_steps START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_saved_recipes START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_ratings START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_comments START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_tags START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_recipe_tags START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_followers START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_recipe_collections START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_collection_recipes START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_shopping_lists START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_shopping_list_items START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_user_activity_log START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_allergens START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_ingredient_allergens START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_nutrition_info START WITH 1 INCREMENT BY 1;

-- =====================================================================
-- 提交事务
-- =====================================================================

COMMIT;