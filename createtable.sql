SET SERVEROUTPUT ON;
BEGIN
  -- 删除所有表、视图和物化视图
  FOR cur IN (SELECT object_name, object_type FROM user_objects WHERE object_type IN ('TABLE', 'VIEW', 'MATERIALIZED VIEW') AND object_name NOT LIKE 'BIN$%')
  LOOP
    BEGIN
      IF cur.object_type = 'VIEW' THEN
        EXECUTE IMMEDIATE 'DROP VIEW "' || cur.object_name || '"';
      ELSIF cur.object_type = 'MATERIALIZED VIEW' THEN
        EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW "' || cur.object_name || '"';
      ELSE
        -- CASCADE CONSTRAINTS 会自动删除关联的外键
        EXECUTE IMMEDIATE 'DROP TABLE "' || cur.object_name || '" CASCADE CONSTRAINTS PURGE';
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Failed to drop ' || cur.object_type || ' ' || cur.object_name || ': ' || SQLERRM);
    END;
  END LOOP;

  -- 删除所有序列
  FOR cur IN (SELECT sequence_name FROM user_sequences)
  LOOP
    BEGIN
      EXECUTE IMMEDIATE 'DROP SEQUENCE "' || cur.sequence_name || '"';
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Failed to drop sequence ' || cur.sequence_name || ': ' || SQLERRM);
    END;
  END LOOP;
END;
/
commit;

select * from user_tables;
select * from user_sequences;
select * from user_views;
select * from user_indexes;

-- 第一部分：创建序列

CREATE SEQUENCE seq_users START WITH 0 INCREMENT BY 1;
CREATE SEQUENCE seq_ingredients START WITH 0 INCREMENT BY 1;
CREATE SEQUENCE seq_units START WITH 0 INCREMENT BY 1;
CREATE SEQUENCE seq_recipes START WITH 0 INCREMENT BY 1;
CREATE SEQUENCE seq_cooking_steps START WITH 0 INCREMENT BY 1;
CREATE SEQUENCE seq_nutrition_info START WITH 0 INCREMENT BY 1;
CREATE SEQUENCE seq_ratings START WITH 0 INCREMENT BY 1;
CREATE SEQUENCE seq_rating_helpfulness START WITH 0 INCREMENT BY 1;
CREATE SEQUENCE seq_comments START WITH 0 INCREMENT BY 1;
CREATE SEQUENCE seq_comment_helpfulness START WITH 0 INCREMENT BY 1;
CREATE SEQUENCE seq_saved_recipes START WITH 0 INCREMENT BY 1;
CREATE SEQUENCE seq_followers START WITH 0 INCREMENT BY 1;
CREATE SEQUENCE seq_tags START WITH 0 INCREMENT BY 1;
CREATE SEQUENCE seq_allergens START WITH 0 INCREMENT BY 1;
CREATE SEQUENCE seq_recipe_collections START WITH 0 INCREMENT BY 1;
CREATE SEQUENCE seq_shopping_lists START WITH 0 INCREMENT BY 1;
CREATE SEQUENCE seq_user_activity_log START WITH 0 INCREMENT BY 1;
CREATE SEQUENCE seq_meal_plans START WITH 0 INCREMENT BY 1;

SELECT sequence_name, min_value, INCREMENT_BY, LAST_NUMBER FROM user_sequences;


-- ============================================================
-- 第二部分：插入表

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
    join_date DATE DEFAULT SYSDATE NOT NULL,
    last_login DATE,
    account_status VARCHAR2(20) DEFAULT 'active' NOT NULL ,
    total_followers NUMBER(10) DEFAULT 0,
    total_recipes NUMBER(10) DEFAULT 0,
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT ck_account_status CHECK (account_status IN ('active', 'inactive', 'suspended'))
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
    is_published VARCHAR2(1) DEFAULT 'Y' NOT NULL,
    is_deleted VARCHAR2(1) DEFAULT 'N' NOT NULL,
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
    CONSTRAINT ck_cook_time CHECK (cook_time >= 0)
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
    is_deleted VARCHAR2(1) DEFAULT 'N' NOT NULL,
    CONSTRAINT ck_comments_is_deleted CHECK (is_deleted IN ('Y', 'N')),
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

-- 表21：RECIPE_COLLECTIONS（食谱收藏清单表）
CREATE TABLE RECIPE_COLLECTIONS (
    collection_id NUMBER(10) PRIMARY KEY,
    user_id NUMBER(10) NOT NULL,
    collection_name VARCHAR2(100) NOT NULL,
    description VARCHAR2(500),
    is_public VARCHAR2(1) DEFAULT 'Y' NOT NULL,
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
    is_checked VARCHAR2(1) DEFAULT 'N' NOT NULL,
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
    start_date DATE DEFAULT SYSDATE NOT NULL,
    end_date DATE DEFAULT SYSDATE NOT NULL,
    is_public VARCHAR2(1) DEFAULT 'Y' NOT NULL,
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
    CONSTRAINT fk_mpe_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id),
    CONSTRAINT ck_mpe_meal_type CHECK (meal_type IN ('breakfast', 'lunch', 'dinner', 'snack'))
);

select table_name from user_tables;

select table_name, CONSTRAINT_NAME, constraint_type, search_condition 
from user_constraints
order by table_name;

-- ============================================================

-- 第三部分：创建索引

CREATE INDEX idx_users_status ON USERS(account_status);

CREATE INDEX idx_ingredients_category ON INGREDIENTS(category);

CREATE INDEX idx_recipes_user_id ON RECIPES(user_id);
CREATE INDEX idx_recipes_is_published ON RECIPES(is_published);
CREATE INDEX idx_recipes_difficulty ON RECIPES(difficulty_level);
CREATE INDEX idx_recipes_cuisine ON RECIPES(cuisine_type);
CREATE INDEX idx_recipes_created_at ON RECIPES(created_at);

CREATE INDEX idx_ratings_user_id ON RATINGS(user_id);
CREATE INDEX idx_ratings_recipe_id ON RATINGS(recipe_id);
CREATE INDEX idx_ratings_value ON RATINGS(rating_value);

CREATE INDEX idx_comments_user_id ON COMMENTS(user_id);
CREATE INDEX idx_comments_recipe_id ON COMMENTS(recipe_id);
CREATE INDEX idx_comments_created_at ON COMMENTS(created_at);

CREATE INDEX idx_followers_user_id ON FOLLOWERS(user_id);
CREATE INDEX idx_followers_follower_id ON FOLLOWERS(follower_user_id);

CREATE INDEX idx_saved_recipes_user_id ON SAVED_RECIPES(user_id);
CREATE INDEX idx_saved_recipes_recipe_id ON SAVED_RECIPES(recipe_id);

CREATE INDEX idx_meal_plans_user_id ON MEAL_PLANS(user_id);
CREATE INDEX idx_meal_plan_entries_plan_id ON MEAL_PLAN_ENTRIES(plan_id);
CREATE INDEX idx_meal_plan_entries_date ON MEAL_PLAN_ENTRIES(meal_date);

CREATE INDEX idx_shopping_lists_user_id ON SHOPPING_LISTS(user_id);
CREATE INDEX idx_SLI_list_id ON SHOPPING_LIST_ITEMS(list_id);

CREATE INDEX idx_collections_user_id ON RECIPE_COLLECTIONS(user_id);
CREATE INDEX idx_collection_RC_id ON COLLECTION_RECIPES(collection_id);
CREATE INDEX idx_collection_RC_recipe_id ON COLLECTION_RECIPES(recipe_id);

select index_name, table_name, uniqueness from user_indexes order by table_name;


COMMIT;
