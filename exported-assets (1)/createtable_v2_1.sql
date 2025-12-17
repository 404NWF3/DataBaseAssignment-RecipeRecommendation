-- ============================================================
-- AllRecipes 食谱网站数据库设计 - 建表脚本 (v2.0增强版)
-- 包含26个表，完整的约束、索引和触发器
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
CREATE SEQUENCE seq_recipe_ingredients START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_cooking_steps START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_nutrition_info START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_ratings START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_rating_helpfulness START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_comments START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_comment_helpfulness START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_saved_recipes START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_followers START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_tags START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_recipe_tags START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_allergens START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_ingredient_allergens START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_recipe_collections START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_collection_recipes START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_shopping_lists START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_shopping_list_items START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_user_activity_log START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_meal_plans START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_meal_plan_entries START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_ingredient_substitutions START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_user_allergies START WITH 1 INCREMENT BY 1;

-- ============================================================
-- 第二部分：核心基础表
-- ============================================================

-- 表1：USERS（用户表）
CREATE TABLE USERS (
    user_id                NUMBER(10) PRIMARY KEY,
    username               VARCHAR2(50) NOT NULL UNIQUE,
    email                  VARCHAR2(100) NOT NULL UNIQUE,
    password_hash          VARCHAR2(255) NOT NULL,
    first_name             VARCHAR2(50),
    last_name              VARCHAR2(50),
    bio                    VARCHAR2(500),
    profile_image          VARCHAR2(255),
    join_date              DATE NOT NULL DEFAULT SYSDATE,
    last_login             DATE,
    account_status         VARCHAR2(20) NOT NULL DEFAULT 'active',
    user_type              VARCHAR2(50) DEFAULT '普通用户',
    total_followers        NUMBER(10) DEFAULT 0,
    total_recipes          NUMBER(10) DEFAULT 0,
    created_at             TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at             TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT ck_account_status CHECK (account_status IN ('active', 'inactive', 'suspended')),
    CONSTRAINT ck_user_type CHECK (user_type IN ('普通用户', '专业厨师', '美食博主'))
);

-- 表2：INGREDIENTS（食材表）
CREATE TABLE INGREDIENTS (
    ingredient_id          NUMBER(10) PRIMARY KEY,
    ingredient_name        VARCHAR2(100) NOT NULL UNIQUE,
    category               VARCHAR2(50) NOT NULL,
    description            VARCHAR2(255),
    created_at             TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- 表3：UNITS（单位表）
CREATE TABLE UNITS (
    unit_id                NUMBER(10) PRIMARY KEY,
    unit_name              VARCHAR2(50) NOT NULL UNIQUE,
    abbreviation           VARCHAR2(20),
    description            VARCHAR2(100),
    created_at             TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- 表4：ALLERGENS（过敏原表）
CREATE TABLE ALLERGENS (
    allergen_id            NUMBER(10) PRIMARY KEY,
    allergen_name          VARCHAR2(100) NOT NULL UNIQUE,
    description            VARCHAR2(255),
    created_at             TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- 表5：TAGS（标签表）
CREATE TABLE TAGS (
    tag_id                 NUMBER(10) PRIMARY KEY,
    tag_name               VARCHAR2(50) NOT NULL UNIQUE,
    tag_description        VARCHAR2(255),
    created_at             TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- 表6：USER_ALLERGIES（用户过敏原表 - 新增）
CREATE TABLE USER_ALLERGIES (
    user_allergy_id        NUMBER(10) PRIMARY KEY,
    user_id                NUMBER(10) NOT NULL,
    allergen_id            NUMBER(10) NOT NULL,
    added_at               TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_ua_user FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_ua_allergen FOREIGN KEY (allergen_id) REFERENCES ALLERGENS(allergen_id),
    CONSTRAINT uk_user_allergen UNIQUE (user_id, allergen_id)
);

-- ============================================================
-- 第三部分：食谱核心表
-- ============================================================

-- 表7：RECIPES（食谱表）
CREATE TABLE RECIPES (
    recipe_id              NUMBER(10) PRIMARY KEY,
    user_id                NUMBER(10) NOT NULL,
    recipe_name            VARCHAR2(200) NOT NULL,
    description            VARCHAR2(1000),
    cuisine_type           VARCHAR2(50),
    meal_type              VARCHAR2(20),
    difficulty_level       VARCHAR2(20),
    prep_time              NUMBER(5),
    cook_time              NUMBER(5),
    total_time             NUMBER(5),
    servings               NUMBER(5),
    calories_per_serving   NUMBER(10),
    image_url              VARCHAR2(255),
    is_published           VARCHAR2(1) NOT NULL DEFAULT 'Y',
    is_deleted             VARCHAR2(1) NOT NULL DEFAULT 'N',
    view_count             NUMBER(10) DEFAULT 0,
    rating_count           NUMBER(10) DEFAULT 0,
    average_rating         NUMBER(3,2) DEFAULT 0,
    created_at             TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at             TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_recipes_user FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    CONSTRAINT ck_meal_type CHECK (meal_type IN ('breakfast', 'lunch', 'dinner', 'snack', 'dessert')),
    CONSTRAINT ck_difficulty_level CHECK (difficulty_level IN ('easy', 'medium', 'hard')),
    CONSTRAINT ck_is_published CHECK (is_published IN ('Y', 'N')),
    CONSTRAINT ck_is_deleted CHECK (is_deleted IN ('Y', 'N')),
    CONSTRAINT ck_cook_time CHECK (cook_time > 0)
);

-- 表8：RECIPE_INGREDIENTS（食谱食材表）
CREATE TABLE RECIPE_INGREDIENTS (
    recipe_ingredient_id   NUMBER(10) PRIMARY KEY,
    recipe_id              NUMBER(10) NOT NULL,
    ingredient_id          NUMBER(10) NOT NULL,
    unit_id                NUMBER(10) NOT NULL,
    quantity               NUMBER(10,2) NOT NULL,
    notes                  VARCHAR2(255),
    CONSTRAINT fk_ri_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE CASCADE,
    CONSTRAINT fk_ri_ingredient FOREIGN KEY (ingredient_id) REFERENCES INGREDIENTS(ingredient_id),
    CONSTRAINT fk_ri_unit FOREIGN KEY (unit_id) REFERENCES UNITS(unit_id),
    CONSTRAINT uk_recipe_ingredient UNIQUE (recipe_id, ingredient_id)
);

-- 表9：COOKING_STEPS（烹饪步骤表）
CREATE TABLE COOKING_STEPS (
    step_id                NUMBER(10) PRIMARY KEY,
    recipe_id              NUMBER(10) NOT NULL,
    step_number            NUMBER(5) NOT NULL,
    instruction            VARCHAR2(1000) NOT NULL,
    time_required          NUMBER(5),
    image_url              VARCHAR2(255),
    CONSTRAINT fk_cs_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE CASCADE,
    CONSTRAINT uk_recipe_step UNIQUE (recipe_id, step_number)
);

-- 表10：NUTRITION_INFO（营养信息表）
CREATE TABLE NUTRITION_INFO (
    nutrition_id           NUMBER(10) PRIMARY KEY,
    recipe_id              NUMBER(10) NOT NULL UNIQUE,
    calories               NUMBER(10),
    protein_grams          NUMBER(10,2),
    carbs_grams            NUMBER(10,2),
    fat_grams              NUMBER(10,2),
    fiber_grams            NUMBER(10,2),
    sugar_grams            NUMBER(10,2),
    sodium_mg              NUMBER(10),
    CONSTRAINT fk_ni_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE CASCADE
);

-- 表11：INGREDIENT_ALLERGENS（食材过敏原关联表）
CREATE TABLE INGREDIENT_ALLERGENS (
    ingredient_allergen_id NUMBER(10) PRIMARY KEY,
    ingredient_id          NUMBER(10) NOT NULL,
    allergen_id            NUMBER(10) NOT NULL,
    CONSTRAINT fk_ia_ingredient FOREIGN KEY (ingredient_id) REFERENCES INGREDIENTS(ingredient_id),
    CONSTRAINT fk_ia_allergen FOREIGN KEY (allergen_id) REFERENCES ALLERGENS(allergen_id),
    CONSTRAINT uk_ingredient_allergen UNIQUE (ingredient_id, allergen_id)
);

-- 表12：RECIPE_TAGS（食谱标签关联表）
CREATE TABLE RECIPE_TAGS (
    recipe_tag_id          NUMBER(10) PRIMARY KEY,
    recipe_id              NUMBER(10) NOT NULL,
    tag_id                 NUMBER(10) NOT NULL,
    CONSTRAINT fk_rt_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE CASCADE,
    CONSTRAINT fk_rt_tag FOREIGN KEY (tag_id) REFERENCES TAGS(tag_id),
    CONSTRAINT uk_recipe_tag UNIQUE (recipe_id, tag_id)
);

-- 表13：INGREDIENT_SUBSTITUTIONS（食材替代品表 - 新增）
CREATE TABLE INGREDIENT_SUBSTITUTIONS (
    substitution_id        NUMBER(10) PRIMARY KEY,
    original_ingredient_id NUMBER(10) NOT NULL,
    substitute_ingredient_id NUMBER(10) NOT NULL,
    ratio                  NUMBER(5,2) DEFAULT 1.0,
    notes                  VARCHAR2(500),
    approval_status        VARCHAR2(20) DEFAULT 'pending',
    created_at             TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_is_original FOREIGN KEY (original_ingredient_id) REFERENCES INGREDIENTS(ingredient_id),
    CONSTRAINT fk_is_substitute FOREIGN KEY (substitute_ingredient_id) REFERENCES INGREDIENTS(ingredient_id),
    CONSTRAINT ck_ratio CHECK (ratio > 0 AND ratio <= 5),
    CONSTRAINT ck_approval_status CHECK (approval_status IN ('pending', 'approved', 'rejected'))
);

-- ============================================================
-- 第四部分：用户交互表
-- ============================================================

-- 表14：RATINGS（评价表）
CREATE TABLE RATINGS (
    rating_id              NUMBER(10) PRIMARY KEY,
    user_id                NUMBER(10) NOT NULL,
    recipe_id              NUMBER(10) NOT NULL,
    rating_value           NUMBER(3,2) NOT NULL,
    review_text            VARCHAR2(1000),
    rating_date            TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_rating_user FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_rating_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE CASCADE,
    CONSTRAINT uk_user_recipe_rating UNIQUE (user_id, recipe_id),
    CONSTRAINT ck_rating_value CHECK (rating_value >= 0 AND rating_value <= 5)
);

-- 表15：RATING_HELPFULNESS（评价有用性投票表 - 新增）
CREATE TABLE RATING_HELPFULNESS (
    helpful_id             NUMBER(10) PRIMARY KEY,
    rating_id              NUMBER(10) NOT NULL,
    user_id                NUMBER(10) NOT NULL,
    voted_at               TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_rh_rating FOREIGN KEY (rating_id) REFERENCES RATINGS(rating_id) ON DELETE CASCADE,
    CONSTRAINT fk_rh_user FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    CONSTRAINT uk_rating_helpful_vote UNIQUE (rating_id, user_id)
);

-- 表16：COMMENTS（评论表）
CREATE TABLE COMMENTS (
    comment_id             NUMBER(10) PRIMARY KEY,
    recipe_id              NUMBER(10) NOT NULL,
    user_id                NUMBER(10) NOT NULL,
    parent_comment_id      NUMBER(10),
    comment_text           VARCHAR2(1000) NOT NULL,
    is_deleted             VARCHAR2(1) DEFAULT 'N',
    created_at             TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at             TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_comment_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE CASCADE,
    CONSTRAINT fk_comment_user FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_comment_parent FOREIGN KEY (parent_comment_id) REFERENCES COMMENTS(comment_id) ON DELETE SET NULL
);

-- 表17：COMMENT_HELPFULNESS（评论有用性投票表 - 新增）
CREATE TABLE COMMENT_HELPFULNESS (
    helpful_id             NUMBER(10) PRIMARY KEY,
    comment_id             NUMBER(10) NOT NULL,
    user_id                NUMBER(10) NOT NULL,
    voted_at               TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_ch_comment FOREIGN KEY (comment_id) REFERENCES COMMENTS(comment_id) ON DELETE CASCADE,
    CONSTRAINT fk_ch_user FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    CONSTRAINT uk_comment_helpful_vote UNIQUE (comment_id, user_id)
);

-- 表18：SAVED_RECIPES（收藏食谱表）
CREATE TABLE SAVED_RECIPES (
    saved_recipe_id        NUMBER(10) PRIMARY KEY,
    user_id                NUMBER(10) NOT NULL,
    recipe_id              NUMBER(10) NOT NULL,
    saved_at               TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_sr_user FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_sr_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE CASCADE,
    CONSTRAINT uk_user_saved_recipe UNIQUE (user_id, recipe_id)
);

-- 表19：FOLLOWERS（关注表）
CREATE TABLE FOLLOWERS (
    follower_id            NUMBER(10) PRIMARY KEY,
    user_id                NUMBER(10) NOT NULL,
    follower_user_id       NUMBER(10) NOT NULL,
    followed_at            TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_f_user FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_f_follower FOREIGN KEY (follower_user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    CONSTRAINT uk_follower UNIQUE (user_id, follower_user_id),
    CONSTRAINT ck_not_self_follow CHECK (user_id != follower_user_id)
);

-- 表20：USER_ACTIVITY_LOG（用户活动日志表）
CREATE TABLE USER_ACTIVITY_LOG (
    activity_id            NUMBER(10) PRIMARY KEY,
    user_id                NUMBER(10) NOT NULL,
    activity_type          VARCHAR2(50),
    activity_description   VARCHAR2(500),
    related_recipe_id      NUMBER(10),
    activity_timestamp     TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_al_user FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_al_recipe FOREIGN KEY (related_recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE SET NULL
);

-- ============================================================
-- 第五部分：个人管理表
-- ============================================================

-- 表21：RECIPE_COLLECTIONS（食谱清单表）
CREATE TABLE RECIPE_COLLECTIONS (
    collection_id          NUMBER(10) PRIMARY KEY,
    user_id                NUMBER(10) NOT NULL,
    collection_name        VARCHAR2(100) NOT NULL,
    description            VARCHAR2(500),
    is_public              VARCHAR2(1) DEFAULT 'Y',
    created_at             TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at             TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_rc_user FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    CONSTRAINT ck_rc_is_public CHECK (is_public IN ('Y', 'N'))
);

-- 表22：COLLECTION_RECIPES（清单食谱关联表）
CREATE TABLE COLLECTION_RECIPES (
    collection_recipe_id   NUMBER(10) PRIMARY KEY,
    collection_id          NUMBER(10) NOT NULL,
    recipe_id              NUMBER(10) NOT NULL,
    added_at               TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_cr_collection FOREIGN KEY (collection_id) REFERENCES RECIPE_COLLECTIONS(collection_id) ON DELETE CASCADE,
    CONSTRAINT fk_cr_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE CASCADE,
    CONSTRAINT uk_collection_recipe UNIQUE (collection_id, recipe_id)
);

-- 表23：SHOPPING_LISTS（购物清单表）
CREATE TABLE SHOPPING_LISTS (
    list_id                NUMBER(10) PRIMARY KEY,
    user_id                NUMBER(10) NOT NULL,
    list_name              VARCHAR2(100) NOT NULL,
    created_at             TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at             TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_sl_user FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE
);

-- 表24：SHOPPING_LIST_ITEMS（购物清单项表）
CREATE TABLE SHOPPING_LIST_ITEMS (
    item_id                NUMBER(10) PRIMARY KEY,
    list_id                NUMBER(10) NOT NULL,
    ingredient_id          NUMBER(10) NOT NULL,
    quantity               NUMBER(10,2),
    unit_id                NUMBER(10),
    is_checked             VARCHAR2(1) DEFAULT 'N',
    added_at               TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_sli_list FOREIGN KEY (list_id) REFERENCES SHOPPING_LISTS(list_id) ON DELETE CASCADE,
    CONSTRAINT fk_sli_ingredient FOREIGN KEY (ingredient_id) REFERENCES INGREDIENTS(ingredient_id),
    CONSTRAINT fk_sli_unit FOREIGN KEY (unit_id) REFERENCES UNITS(unit_id),
    CONSTRAINT ck_is_checked CHECK (is_checked IN ('Y', 'N'))
);

-- 表25：MEAL_PLANS（膳食计划表 - 新增）
CREATE TABLE MEAL_PLANS (
    plan_id                NUMBER(10) PRIMARY KEY,
    user_id                NUMBER(10) NOT NULL,
    plan_name              VARCHAR2(100) NOT NULL,
    description            VARCHAR2(500),
    start_date             DATE NOT NULL,
    end_date               DATE NOT NULL,
    is_public              VARCHAR2(1) DEFAULT 'Y',
    created_at             TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at             TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_mp_user FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    CONSTRAINT ck_meal_plan_dates CHECK (start_date <= end_date),
    CONSTRAINT ck_mp_is_public CHECK (is_public IN ('Y', 'N'))
);

-- 表26：MEAL_PLAN_ENTRIES（膳食计划条目表 - 新增）
CREATE TABLE MEAL_PLAN_ENTRIES (
    entry_id               NUMBER(10) PRIMARY KEY,
    plan_id                NUMBER(10) NOT NULL,
    recipe_id              NUMBER(10) NOT NULL,
    meal_date              DATE NOT NULL,
    meal_type              VARCHAR2(20),
    notes                  VARCHAR2(255),
    added_at               TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_mpe_plan FOREIGN KEY (plan_id) REFERENCES MEAL_PLANS(plan_id) ON DELETE CASCADE,
    CONSTRAINT fk_mpe_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE RESTRICT
);

-- ============================================================
-- 第三部分：创建索引（优化查询性能）
-- ============================================================

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
CREATE INDEX idx_recipes_published_rating ON RECIPES(is_published, average_rating DESC);

-- 食材相关表索引
CREATE INDEX idx_ri_recipe_id ON RECIPE_INGREDIENTS(recipe_id);
CREATE INDEX idx_ri_ingredient_id ON RECIPE_INGREDIENTS(ingredient_id);

-- 评分和评论索引
CREATE INDEX idx_ratings_recipe_id ON RATINGS(recipe_id);
CREATE INDEX idx_ratings_user_id ON RATINGS(user_id);
CREATE INDEX idx_ratings_date ON RATINGS(rating_date);

CREATE INDEX idx_comments_recipe_id ON COMMENTS(recipe_id);
CREATE INDEX idx_comments_user_id ON COMMENTS(user_id);
CREATE INDEX idx_comments_created_at ON COMMENTS(created_at);

-- 社交关系索引
CREATE INDEX idx_followers_user_id ON FOLLOWERS(user_id);
CREATE INDEX idx_followers_follower_user_id ON FOLLOWERS(follower_user_id);

-- 个人管理索引
CREATE INDEX idx_sl_user_id ON SHOPPING_LISTS(user_id);
CREATE INDEX idx_sli_list_id ON SHOPPING_LIST_ITEMS(list_id);
CREATE INDEX idx_saved_recipes_user ON SAVED_RECIPES(user_id);

-- 活动日志索引
CREATE INDEX idx_al_user_id ON USER_ACTIVITY_LOG(user_id);
CREATE INDEX idx_al_timestamp ON USER_ACTIVITY_LOG(activity_timestamp);

-- 新增表索引
CREATE INDEX idx_mp_user_id ON MEAL_PLANS(user_id);
CREATE INDEX idx_mpe_plan_id ON MEAL_PLAN_ENTRIES(plan_id);
CREATE INDEX idx_mpe_meal_date ON MEAL_PLAN_ENTRIES(meal_date);
CREATE INDEX idx_sub_original ON INGREDIENT_SUBSTITUTIONS(original_ingredient_id);
CREATE INDEX idx_sub_status ON INGREDIENT_SUBSTITUTIONS(approval_status);
CREATE INDEX idx_rh_rating_id ON RATING_HELPFULNESS(rating_id);
CREATE INDEX idx_rh_user_id ON RATING_HELPFULNESS(user_id);
CREATE INDEX idx_ch_comment_id ON COMMENT_HELPFULNESS(comment_id);
CREATE INDEX idx_ch_user_id ON COMMENT_HELPFULNESS(user_id);
CREATE INDEX idx_ua_user_id ON USER_ALLERGIES(user_id);
CREATE INDEX idx_ua_allergen_id ON USER_ALLERGIES(allergen_id);

-- ============================================================
-- 第四部分：创建触发器
-- ============================================================

-- 触发器1：自动更新食谱评分和计数
CREATE OR REPLACE TRIGGER trg_update_recipe_stats
AFTER INSERT OR DELETE ON RATINGS
FOR EACH ROW
BEGIN
    UPDATE RECIPES SET 
        average_rating = ROUND((SELECT NVL(AVG(rating_value), 0) FROM RATINGS WHERE recipe_id = :NEW.recipe_id), 2),
        rating_count = (SELECT COUNT(*) FROM RATINGS WHERE recipe_id = :NEW.recipe_id),
        updated_at = SYSTIMESTAMP
    WHERE recipe_id = :NEW.recipe_id;
END;
/

-- 触发器2：自动更新用户粉丝计数
CREATE OR REPLACE TRIGGER trg_update_user_followers
AFTER INSERT OR DELETE ON FOLLOWERS
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        UPDATE USERS SET 
            total_followers = total_followers + 1,
            updated_at = SYSTIMESTAMP
        WHERE user_id = :NEW.user_id;
    ELSIF DELETING THEN
        UPDATE USERS SET 
            total_followers = total_followers - 1,
            updated_at = SYSTIMESTAMP
        WHERE user_id = :OLD.user_id;
    END IF;
END;
/

-- 触发器3：自动更新用户食谱计数
CREATE OR REPLACE TRIGGER trg_update_user_recipes
AFTER INSERT ON RECIPES
FOR EACH ROW
BEGIN
    UPDATE USERS SET 
        total_recipes = total_recipes + 1,
        updated_at = SYSTIMESTAMP
    WHERE user_id = :NEW.user_id;
END;
/

-- 触发器4：记录用户活动日志
CREATE OR REPLACE TRIGGER trg_log_recipe_publish
AFTER INSERT ON RECIPES
FOR EACH ROW
BEGIN
    INSERT INTO USER_ACTIVITY_LOG (
        activity_id, user_id, activity_type, activity_description, related_recipe_id
    ) VALUES (
        seq_user_activity_log.NEXTVAL,
        :NEW.user_id,
        'recipe_published',
        '发布了食谱：' || :NEW.recipe_name,
        :NEW.recipe_id
    );
END;
/

-- ============================================================
-- 第五部分：示例数据插入（可选）
-- ============================================================

-- 插入单位数据
INSERT INTO UNITS VALUES (seq_units.NEXTVAL, '克', 'g', '重量单位', SYSTIMESTAMP);
INSERT INTO UNITS VALUES (seq_units.NEXTVAL, '毫升', 'ml', '容量单位', SYSTIMESTAMP);
INSERT INTO UNITS VALUES (seq_units.NEXTVAL, '杯', 'cup', '容量单位', SYSTIMESTAMP);
INSERT INTO UNITS VALUES (seq_units.NEXTVAL, '汤匙', 'tbsp', '容量单位', SYSTIMESTAMP);
INSERT INTO UNITS VALUES (seq_units.NEXTVAL, '茶匙', 'tsp', '容量单位', SYSTIMESTAMP);
INSERT INTO UNITS VALUES (seq_units.NEXTVAL, '个', 'pc', '数量单位', SYSTIMESTAMP);

-- 插入过敏原数据
INSERT INTO ALLERGENS VALUES (seq_allergens.NEXTVAL, '花生', '花生类过敏原', SYSTIMESTAMP);
INSERT INTO ALLERGENS VALUES (seq_allergens.NEXTVAL, '坚果', '树坚果类过敏原', SYSTIMESTAMP);
INSERT INTO ALLERGENS VALUES (seq_allergens.NEXTVAL, '乳制品', '奶类过敏原', SYSTIMESTAMP);
INSERT INTO ALLERGENS VALUES (seq_allergens.NEXTVAL, '鸡蛋', '蛋类过敏原', SYSTIMESTAMP);
INSERT INTO ALLERGENS VALUES (seq_allergens.NEXTVAL, '海鲜', '甲壳类和鱼类过敏原', SYSTIMESTAMP);
INSERT INTO ALLERGENS VALUES (seq_allergens.NEXTVAL, '小麦', '谷类过敏原', SYSTIMESTAMP);

-- 插入标签数据
INSERT INTO TAGS VALUES (seq_tags.NEXTVAL, '素食', '不含肉类的食谱', SYSTIMESTAMP);
INSERT INTO TAGS VALUES (seq_tags.NEXTVAL, '低脂', '低脂肪食谱', SYSTIMESTAMP);
INSERT INTO TAGS VALUES (seq_tags.NEXTVAL, '快手菜', '30分钟内可完成', SYSTIMESTAMP);
INSERT INTO TAGS VALUES (seq_tags.NEXTVAL, '烘焙', '面包和甜点类', SYSTIMESTAMP);
INSERT INTO TAGS VALUES (seq_tags.NEXTVAL, '无麸质', '不含谷类蛋白质', SYSTIMESTAMP);

-- 插入食材数据示例
INSERT INTO INGREDIENTS VALUES (seq_ingredients.NEXTVAL, '鸡蛋', '蛋类', '新鲜鸡蛋', SYSTIMESTAMP);
INSERT INTO INGREDIENTS VALUES (seq_ingredients.NEXTVAL, '面粉', '粮食', '通用小麦面粉', SYSTIMESTAMP);
INSERT INTO INGREDIENTS VALUES (seq_ingredients.NEXTVAL, '牛奶', '乳制品', '全脂牛奶', SYSTIMESTAMP);
INSERT INTO INGREDIENTS VALUES (seq_ingredients.NEXTVAL, '盐', '调味料', '食用盐', SYSTIMESTAMP);
INSERT INTO INGREDIENTS VALUES (seq_ingredients.NEXTVAL, '糖', '调味料', '白砂糖', SYSTIMESTAMP);

-- 插入示例用户
INSERT INTO USERS VALUES (
    seq_users.NEXTVAL,
    'chef_john',
    'chef@example.com',
    DBMS_CRYPTO.HASH(UTL_RAW.CAST_TO_RAW('Password123'), DBMS_CRYPTO.HASH_SH256),
    'John',
    'Doe',
    '专业厨师，热爱分享美食',
    'https://example.com/images/john.jpg',
    SYSDATE,
    SYSDATE,
    'active',
    '专业厨师',
    0,
    0,
    SYSTIMESTAMP,
    SYSTIMESTAMP
);

INSERT INTO USERS VALUES (
    seq_users.NEXTVAL,
    'food_blogger_maria',
    'maria@example.com',
    DBMS_CRYPTO.HASH(UTL_RAW.CAST_TO_RAW('Password456'), DBMS_CRYPTO.HASH_SH256),
    'Maria',
    'Garcia',
    '美食博主，探索世界美食',
    'https://example.com/images/maria.jpg',
    SYSDATE,
    SYSDATE,
    'active',
    '美食博主',
    0,
    0,
    SYSTIMESTAMP,
    SYSTIMESTAMP
);

COMMIT;

-- ============================================================
-- 验证脚本执行完成
-- ============================================================

SELECT 
    (SELECT COUNT(*) FROM user_tables) AS table_count,
    (SELECT COUNT(*) FROM user_indexes) AS index_count,
    (SELECT COUNT(*) FROM user_sequences) AS sequence_count,
    (SELECT COUNT(*) FROM user_triggers) AS trigger_count
FROM dual;

-- 输出所有创建的表
SELECT table_name FROM user_tables WHERE table_name NOT LIKE 'BIN$%' ORDER BY table_name;

COMMIT;
