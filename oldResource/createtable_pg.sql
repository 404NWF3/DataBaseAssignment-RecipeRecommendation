-- =====================================================================
-- AllRecipes 食谱网站数据库设计
-- 数据库：PostgreSQL
-- 创建日期：2025年12月
-- 设计规范：BCNF （Boyce-Codd Normal Form）
-- =====================================================================

-- 1. 用户表（USERS）
CREATE TABLE USERS (
    user_id         SERIAL PRIMARY KEY,
    username        VARCHAR(50) NOT NULL UNIQUE,
    email           VARCHAR(100) NOT NULL UNIQUE,
    password_hash   VARCHAR(255) NOT NULL,
    first_name      VARCHAR(50),
    last_name       VARCHAR(50),
    bio             VARCHAR(500),
    profile_image   VARCHAR(255),
    join_date       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_login      TIMESTAMP,
    account_status  VARCHAR(20) DEFAULT 'active' CHECK (account_status IN ('active', 'inactive', 'suspended')),
    total_followers INTEGER DEFAULT 0,
    total_recipes   INTEGER DEFAULT 0,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. 食材表（INGREDIENTS）
CREATE TABLE INGREDIENTS (
    ingredient_id   SERIAL PRIMARY KEY,
    ingredient_name VARCHAR(100) NOT NULL UNIQUE,
    category        VARCHAR(50) NOT NULL,
    description     VARCHAR(255),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. 单位表（UNITS）
CREATE TABLE UNITS (
    unit_id         SERIAL PRIMARY KEY,
    unit_name       VARCHAR(50) NOT NULL UNIQUE,
    abbreviation    VARCHAR(20),
    description     VARCHAR(100),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. 食谱表（RECIPES）
CREATE TABLE RECIPES (
    recipe_id       SERIAL PRIMARY KEY,
    user_id         INTEGER NOT NULL,
    recipe_name     VARCHAR(200) NOT NULL,
    description     VARCHAR(1000),
    cuisine_type    VARCHAR(50),
    meal_type       VARCHAR(50) CHECK (meal_type IN ('breakfast', 'lunch', 'dinner', 'snack', 'dessert')),
    difficulty_level VARCHAR(20) CHECK (difficulty_level IN ('easy', 'medium', 'hard')),
    prep_time       INTEGER,
    cook_time       INTEGER,
    total_time      INTEGER,
    servings        INTEGER,
    calories_per_serving INTEGER,
    image_url       VARCHAR(255),
    is_published    VARCHAR(1) DEFAULT 'Y' CHECK (is_published IN ('Y', 'N')),
    is_deleted      VARCHAR(1) DEFAULT 'N' CHECK (is_deleted IN ('Y', 'N')),
    view_count      INTEGER DEFAULT 0,
    rating_count    INTEGER DEFAULT 0,
    average_rating  NUMERIC(3,2) DEFAULT 0,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_recipes_user FOREIGN KEY (user_id) REFERENCES USERS(user_id)
);

-- 5. 食谱食材表（RECIPE_INGREDIENTS）
CREATE TABLE RECIPE_INGREDIENTS (
    recipe_ingredient_id SERIAL PRIMARY KEY,
    recipe_id       INTEGER NOT NULL,
    ingredient_id   INTEGER NOT NULL,
    unit_id         INTEGER NOT NULL,
    quantity        NUMERIC(10,2) NOT NULL,
    notes           VARCHAR(255),
    CONSTRAINT fk_ri_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id),
    CONSTRAINT fk_ri_ingredient FOREIGN KEY (ingredient_id) REFERENCES INGREDIENTS(ingredient_id),
    CONSTRAINT fk_ri_unit FOREIGN KEY (unit_id) REFERENCES UNITS(unit_id),
    CONSTRAINT uk_recipe_ingredient UNIQUE (recipe_id, ingredient_id)
);

-- 6. 烹饪步骤表（COOKING_STEPS）
CREATE TABLE COOKING_STEPS (
    step_id         SERIAL PRIMARY KEY,
    recipe_id       INTEGER NOT NULL,
    step_number     INTEGER NOT NULL,
    instruction     VARCHAR(1000) NOT NULL,
    time_required   INTEGER,
    image_url       VARCHAR(255),
    CONSTRAINT fk_steps_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id),
    CONSTRAINT uk_recipe_step UNIQUE (recipe_id, step_number)
);

-- 7. 用户收藏表（SAVED_RECIPES）
CREATE TABLE SAVED_RECIPES (
    saved_recipe_id SERIAL PRIMARY KEY,
    user_id         INTEGER NOT NULL,
    recipe_id       INTEGER NOT NULL,
    saved_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_sr_user FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    CONSTRAINT fk_sr_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id),
    CONSTRAINT uk_user_recipe UNIQUE (user_id, recipe_id)
);

-- 8. 用户评价表（RATINGS）
CREATE TABLE RATINGS (
    rating_id       SERIAL PRIMARY KEY,
    user_id         INTEGER NOT NULL,
    recipe_id       INTEGER NOT NULL,
    rating_value    NUMERIC(2,1) NOT NULL CHECK (rating_value >= 0 AND rating_value <= 5),
    review_text     VARCHAR(2000),
    helpful_count   INTEGER DEFAULT 0,
    rating_date     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_rating_user FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    CONSTRAINT fk_rating_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id),
    CONSTRAINT uk_user_recipe_rating UNIQUE (user_id, recipe_id)
);

-- 9. 评论表（COMMENTS）
CREATE TABLE COMMENTS (
    comment_id      SERIAL PRIMARY KEY,
    recipe_id       INTEGER NOT NULL,
    user_id         INTEGER NOT NULL,
    parent_comment_id INTEGER,
    comment_text    VARCHAR(2000) NOT NULL,
    helpful_count   INTEGER DEFAULT 0,
    is_deleted      VARCHAR(1) DEFAULT 'N' CHECK (is_deleted IN ('Y', 'N')),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_comment_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id),
    CONSTRAINT fk_comment_user FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    CONSTRAINT fk_comment_parent FOREIGN KEY (parent_comment_id) REFERENCES COMMENTS(comment_id)
);

-- 10. 标签表（TAGS）
CREATE TABLE TAGS (
    tag_id          SERIAL PRIMARY KEY,
    tag_name        VARCHAR(50) NOT NULL UNIQUE,
    tag_description VARCHAR(255),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 11. 食谱标签表（RECIPE_TAGS）
CREATE TABLE RECIPE_TAGS (
    recipe_tag_id   SERIAL PRIMARY KEY,
    recipe_id       INTEGER NOT NULL,
    tag_id          INTEGER NOT NULL,
    CONSTRAINT fk_rt_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id),
    CONSTRAINT fk_rt_tag FOREIGN KEY (tag_id) REFERENCES TAGS(tag_id),
    CONSTRAINT uk_recipe_tag UNIQUE (recipe_id, tag_id)
);

-- 12. 用户关注表（FOLLOWERS）
CREATE TABLE FOLLOWERS (
    follower_id     SERIAL PRIMARY KEY,
    user_id         INTEGER NOT NULL,
    follower_user_id INTEGER NOT NULL,
    followed_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_follow_user FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    CONSTRAINT fk_follow_follower FOREIGN KEY (follower_user_id) REFERENCES USERS(user_id),
    CONSTRAINT uk_follower UNIQUE (user_id, follower_user_id),
    CONSTRAINT ck_not_self_follow CHECK (user_id != follower_user_id)
);

-- 13. 食谱收藏清单表（RECIPE_COLLECTIONS）
CREATE TABLE RECIPE_COLLECTIONS (
    collection_id   SERIAL PRIMARY KEY,
    user_id         INTEGER NOT NULL,
    collection_name VARCHAR(100) NOT NULL,
    description     VARCHAR(500),
    is_public       VARCHAR(1) DEFAULT 'Y' CHECK (is_public IN ('Y', 'N')),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_rc_user FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    CONSTRAINT uk_user_collection UNIQUE (user_id, collection_name)
);

-- 14. 清单内食谱表（COLLECTION_RECIPES）
CREATE TABLE COLLECTION_RECIPES (
    collection_recipe_id SERIAL PRIMARY KEY,
    collection_id   INTEGER NOT NULL,
    recipe_id       INTEGER NOT NULL,
    added_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_colr_collection FOREIGN KEY (collection_id) REFERENCES RECIPE_COLLECTIONS(collection_id),
    CONSTRAINT fk_colr_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id),
    CONSTRAINT uk_collection_recipe UNIQUE (collection_id, recipe_id)
);

-- 15. 购物清单表（SHOPPING_LISTS）
CREATE TABLE SHOPPING_LISTS (
    list_id         SERIAL PRIMARY KEY,
    user_id         INTEGER NOT NULL,
    list_name       VARCHAR(100) NOT NULL,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_sl_user FOREIGN KEY (user_id) REFERENCES USERS(user_id)
);

-- 16. 购物清单项目表（SHOPPING_LIST_ITEMS）
CREATE TABLE SHOPPING_LIST_ITEMS (
    item_id         SERIAL PRIMARY KEY,
    list_id         INTEGER NOT NULL,
    ingredient_id   INTEGER NOT NULL,
    quantity        NUMERIC(10,2),
    unit_id         INTEGER,
    is_checked      VARCHAR(1) DEFAULT 'N' CHECK (is_checked IN ('Y', 'N')),
    added_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_sli_list FOREIGN KEY (list_id) REFERENCES SHOPPING_LISTS(list_id),
    CONSTRAINT fk_sli_ingredient FOREIGN KEY (ingredient_id) REFERENCES INGREDIENTS(ingredient_id),
    CONSTRAINT fk_sli_unit FOREIGN KEY (unit_id) REFERENCES UNITS(unit_id)
);

-- 17. 用户活动日志表（USER_ACTIVITY_LOG）
CREATE TABLE USER_ACTIVITY_LOG (
    activity_id     SERIAL PRIMARY KEY,
    user_id         INTEGER NOT NULL,
    activity_type   VARCHAR(50) NOT NULL,
    activity_description VARCHAR(500),
    related_recipe_id INTEGER,
    activity_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_al_user FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    CONSTRAINT fk_al_recipe FOREIGN KEY (related_recipe_id) REFERENCES RECIPES(recipe_id)
);

-- 18. 过敏原表（ALLERGENS）
CREATE TABLE ALLERGENS (
    allergen_id     SERIAL PRIMARY KEY,
    allergen_name   VARCHAR(100) NOT NULL UNIQUE,
    description     VARCHAR(255),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 19. 食材过敏原表（INGREDIENT_ALLERGENS）
CREATE TABLE INGREDIENT_ALLERGENS (
    ingredient_allergen_id SERIAL PRIMARY KEY,
    ingredient_id   INTEGER NOT NULL,
    allergen_id     INTEGER NOT NULL,
    CONSTRAINT fk_ia_ingredient FOREIGN KEY (ingredient_id) REFERENCES INGREDIENTS(ingredient_id),
    CONSTRAINT fk_ia_allergen FOREIGN KEY (allergen_id) REFERENCES ALLERGENS(allergen_id),
    CONSTRAINT uk_ingredient_allergen UNIQUE (ingredient_id, allergen_id)
);

-- 20. 营养信息表（NUTRITION_INFO）
CREATE TABLE NUTRITION_INFO (
    nutrition_id    SERIAL PRIMARY KEY,
    recipe_id       INTEGER NOT NULL UNIQUE,
    calories        INTEGER,
    protein_grams   NUMERIC(10,2),
    carbs_grams     NUMERIC(10,2),
    fat_grams       NUMERIC(10,2),
    fiber_grams     NUMERIC(10,2),
    sugar_grams     NUMERIC(10,2),
    sodium_mg       INTEGER,
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
-- 提交事务
-- =====================================================================

COMMIT;
