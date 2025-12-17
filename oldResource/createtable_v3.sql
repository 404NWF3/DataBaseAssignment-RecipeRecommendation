# AllRecipes 食谱网站 - Oracle建表脚本 (v3.0 N:M规范化版)

## 修改说明

本版本对以下8个表进行了关键修改，将其从**弱实体**改造为**N:M多对多关系**，采用**复合主键**设计：

1. **RECIPE_INGREDIENT** - 改为 (RECIPE_ID, INGREDIENT_ID) 复合主键
2. **USER_ALLERGY** - 改为 (USER_ID, ALLERGEN_ID) 复合主键
3. **INGREDIENT_ALLERGEN** - 改为 (INGREDIENT_ID, ALLERGEN_ID) 复合主键
4. **RECIPE_TAG** - 改为 (RECIPE_ID, TAG_ID) 复合主键
5. **INGREDIENT_SUBSTITUTION** - 改为 (ORIGINAL_ID, SUBSTITUTE_ID) 复合主键（自引用）
6. **COLLECTION_RECIPE** - 改为 (COLLECTION_ID, RECIPE_ID) 复合主键
7. **SHOPPING_LIST_ITEM** - 改为 (LIST_ID, INGREDIENT_ID) 复合主键
8. **MEAL_PLAN_ENTRY** - 改为 (PLAN_ID, RECIPE_ID, MEAL_DATE) 三元主键

---

```sql
-- ============================================================
-- AllRecipes 食谱网站数据库设计 - Oracle建表脚本 (v3.0)
-- 修复N:M关系主键设计 (无代理键)
-- ============================================================

-- ============================================================
-- 第一部分：序列定义
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
-- 第二部分：核心基础表 (保持不变)
-- ============================================================

-- 表1：USERS 用户表
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

CREATE INDEX idx_users_username ON USERS(username);
CREATE INDEX idx_users_email ON USERS(email);
CREATE INDEX idx_users_status ON USERS(account_status);

-- 表2：INGREDIENTS 食材表
CREATE TABLE INGREDIENTS (
    ingredient_id NUMBER(10) PRIMARY KEY,
    ingredient_name VARCHAR2(100) NOT NULL UNIQUE,
    category VARCHAR2(50) NOT NULL,
    description VARCHAR2(255),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE INDEX idx_ingredients_name ON INGREDIENTS(ingredient_name);
CREATE INDEX idx_ingredients_category ON INGREDIENTS(category);

-- 表3：UNITS 单位表
CREATE TABLE UNITS (
    unit_id NUMBER(10) PRIMARY KEY,
    unit_name VARCHAR2(50) NOT NULL UNIQUE,
    abbreviation VARCHAR2(20),
    description VARCHAR2(100),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE INDEX idx_units_name ON UNITS(unit_name);

-- 表4：ALLERGENS 过敏原表
CREATE TABLE ALLERGENS (
    allergen_id NUMBER(10) PRIMARY KEY,
    allergen_name VARCHAR2(100) NOT NULL UNIQUE,
    description VARCHAR2(255),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE INDEX idx_allergens_name ON ALLERGENS(allergen_name);

-- 表5：TAGS 标签表
CREATE TABLE TAGS (
    tag_id NUMBER(10) PRIMARY KEY,
    tag_name VARCHAR2(50) NOT NULL UNIQUE,
    tag_description VARCHAR2(255),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE INDEX idx_tags_name ON TAGS(tag_name);

-- ============================================================
-- 第三部分：食谱核心表
-- ============================================================

-- 表6：RECIPES 食谱表
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
    CONSTRAINT ck_difficulty CHECK (difficulty_level IN ('easy', 'medium', 'hard')),
    CONSTRAINT ck_published CHECK (is_published IN ('Y', 'N')),
    CONSTRAINT ck_deleted CHECK (is_deleted IN ('Y', 'N'))
);

CREATE INDEX idx_recipes_user ON RECIPES(user_id);
CREATE INDEX idx_recipes_name ON RECIPES(recipe_name);
CREATE INDEX idx_recipes_published ON RECIPES(is_published);

-- 表7：COOKING_STEPS 烹饪步骤表
CREATE TABLE COOKING_STEPS (
    step_id NUMBER(10) PRIMARY KEY,
    recipe_id NUMBER(10) NOT NULL,
    step_number NUMBER(5) NOT NULL,
    instruction VARCHAR2(1000) NOT NULL,
    time_required NUMBER(5),
    image_url VARCHAR2(255),
    CONSTRAINT fk_cs_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE CASCADE,
    CONSTRAINT uk_recipe_step UNIQUE (recipe_id, step_number)
);

CREATE INDEX idx_cs_recipe ON COOKING_STEPS(recipe_id);

-- 表8：NUTRITION_INFO 营养信息表
CREATE TABLE NUTRITION_INFO (
    nutrition_id NUMBER(10) PRIMARY KEY,
    recipe_id NUMBER(10) NOT NULL UNIQUE,
    calories NUMBER(10),
    protein_grams NUMBER(10,2),
    carbs_grams NUMBER(10,2),
    fat_grams NUMBER(10,2),
    fiber_grams NUMBER(10,2),
    sugar_grams NUMBER(10,2),
    sodium_mg NUMBER(10),
    CONSTRAINT fk_ni_recipe FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE CASCADE
);

-- ============================================================
-- 第四部分：N:M关系表 (修复为复合主键，无代理键) ⭐
-- ============================================================

-- ⭐ 表9：RECIPE_INGREDIENTS (修复版) - 二元N:M关系
CREATE TABLE RECIPE_INGREDIENTS (
    recipe_id NUMBER(10),
    ingredient_id NUMBER(10),
    unit_id NUMBER(10),
    quantity NUMBER(10,2) NOT NULL,
    notes VARCHAR2(255),
    PRIMARY KEY (recipe_id, ingredient_id),
    FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE CASCADE,
    FOREIGN KEY (ingredient_id) REFERENCES INGREDIENTS(ingredient_id),
    FOREIGN KEY (unit_id) REFERENCES UNITS(unit_id)
);

CREATE INDEX idx_ri_recipe ON RECIPE_INGREDIENTS(recipe_id);
CREATE INDEX idx_ri_ingredient ON RECIPE_INGREDIENTS(ingredient_id);

-- ⭐ 表10：USER_ALLERGIES (修复版) - 二元N:M关系
CREATE TABLE USER_ALLERGIES (
    user_id NUMBER(10),
    allergen_id NUMBER(10),
    added_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    PRIMARY KEY (user_id, allergen_id),
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    FOREIGN KEY (allergen_id) REFERENCES ALLERGENS(allergen_id)
);

CREATE INDEX idx_ua_user ON USER_ALLERGIES(user_id);
CREATE INDEX idx_ua_allergen ON USER_ALLERGIES(allergen_id);

-- ⭐ 表11：INGREDIENT_ALLERGENS (修复版) - 二元N:M关系
CREATE TABLE INGREDIENT_ALLERGENS (
    ingredient_id NUMBER(10),
    allergen_id NUMBER(10),
    allergen_level VARCHAR2(50),
    PRIMARY KEY (ingredient_id, allergen_id),
    FOREIGN KEY (ingredient_id) REFERENCES INGREDIENTS(ingredient_id),
    FOREIGN KEY (allergen_id) REFERENCES ALLERGENS(allergen_id)
);

CREATE INDEX idx_ia_ingredient ON INGREDIENT_ALLERGENS(ingredient_id);
CREATE INDEX idx_ia_allergen ON INGREDIENT_ALLERGENS(allergen_id);

-- ⭐ 表12：RECIPE_TAGS (修复版) - 二元N:M关系
CREATE TABLE RECIPE_TAGS (
    recipe_id NUMBER(10),
    tag_id NUMBER(10),
    PRIMARY KEY (recipe_id, tag_id),
    FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES TAGS(tag_id)
);

CREATE INDEX idx_rt_recipe ON RECIPE_TAGS(recipe_id);
CREATE INDEX idx_rt_tag ON RECIPE_TAGS(tag_id);

-- ⭐ 表13：INGREDIENT_SUBSTITUTIONS (修复版) - 自引用N:M关系
CREATE TABLE INGREDIENT_SUBSTITUTIONS (
    original_ingredient_id NUMBER(10),
    substitute_ingredient_id NUMBER(10),
    ratio NUMBER(5,2),
    notes VARCHAR2(255),
    approval_status VARCHAR2(50),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    PRIMARY KEY (original_ingredient_id, substitute_ingredient_id),
    FOREIGN KEY (original_ingredient_id) REFERENCES INGREDIENTS(ingredient_id) ON DELETE CASCADE,
    FOREIGN KEY (substitute_ingredient_id) REFERENCES INGREDIENTS(ingredient_id) ON DELETE CASCADE
);

CREATE INDEX idx_is_original ON INGREDIENT_SUBSTITUTIONS(original_ingredient_id);
CREATE INDEX idx_is_substitute ON INGREDIENT_SUBSTITUTIONS(substitute_ingredient_id);

-- ============================================================
-- 第五部分：用户交互表
-- ============================================================

-- 表14：RATINGS 评价表
CREATE TABLE RATINGS (
    user_id NUMBER(10),
    recipe_id NUMBER(10),
    rating_value NUMBER(3,2) NOT NULL,
    review_text VARCHAR2(1000),
    rating_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    PRIMARY KEY (user_id, recipe_id),
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE CASCADE
);

CREATE INDEX idx_ratings_user ON RATINGS(user_id);
CREATE INDEX idx_ratings_recipe ON RATINGS(recipe_id);

-- 表15：RATING_HELPFULNESS 评价有用性投票
CREATE TABLE RATING_HELPFULNESS (
    rating_user_id NUMBER(10),
    rating_recipe_id NUMBER(10),
    voter_user_id NUMBER(10),
    voted_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    PRIMARY KEY (rating_user_id, rating_recipe_id, voter_user_id),
    FOREIGN KEY (rating_user_id, rating_recipe_id) REFERENCES RATINGS(user_id, recipe_id) ON DELETE CASCADE,
    FOREIGN KEY (voter_user_id) REFERENCES USERS(user_id) ON DELETE CASCADE
);

CREATE INDEX idx_rh_rating ON RATING_HELPFULNESS(rating_user_id, rating_recipe_id);
CREATE INDEX idx_rh_voter ON RATING_HELPFULNESS(voter_user_id);

-- 表16：COMMENTS 评论表
CREATE TABLE COMMENTS (
    comment_id NUMBER(10) PRIMARY KEY,
    recipe_id NUMBER(10) NOT NULL,
    user_id NUMBER(10) NOT NULL,
    parent_comment_id NUMBER(10),
    comment_text VARCHAR2(1000),
    is_deleted VARCHAR2(1) DEFAULT 'N',
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    FOREIGN KEY (parent_comment_id) REFERENCES COMMENTS(comment_id) ON DELETE SET NULL
);

CREATE INDEX idx_comments_recipe ON COMMENTS(recipe_id);
CREATE INDEX idx_comments_user ON COMMENTS(user_id);

-- 表17：COMMENT_HELPFULNESS 评论有用性投票
CREATE TABLE COMMENT_HELPFULNESS (
    comment_id NUMBER(10),
    user_id NUMBER(10),
    voted_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    PRIMARY KEY (comment_id, user_id),
    FOREIGN KEY (comment_id) REFERENCES COMMENTS(comment_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE
);

CREATE INDEX idx_ch_comment ON COMMENT_HELPFULNESS(comment_id);
CREATE INDEX idx_ch_user ON COMMENT_HELPFULNESS(user_id);

-- 表18：SAVED_RECIPES 收藏表
CREATE TABLE SAVED_RECIPES (
    user_id NUMBER(10),
    recipe_id NUMBER(10),
    saved_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    PRIMARY KEY (user_id, recipe_id),
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE CASCADE
);

CREATE INDEX idx_sr_user ON SAVED_RECIPES(user_id);
CREATE INDEX idx_sr_recipe ON SAVED_RECIPES(recipe_id);

-- 表19：FOLLOWERS 粉丝表
CREATE TABLE FOLLOWERS (
    user_id NUMBER(10),
    follower_user_id NUMBER(10),
    followed_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    is_blocked VARCHAR2(1) DEFAULT 'N',
    PRIMARY KEY (user_id, follower_user_id),
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    FOREIGN KEY (follower_user_id) REFERENCES USERS(user_id) ON DELETE CASCADE
);

CREATE INDEX idx_followers_user ON FOLLOWERS(user_id);
CREATE INDEX idx_followers_follower ON FOLLOWERS(follower_user_id);

-- ============================================================
-- 第六部分：个人管理表
-- ============================================================

-- 表20：RECIPE_COLLECTIONS 食谱清单
CREATE TABLE RECIPE_COLLECTIONS (
    collection_id NUMBER(10) PRIMARY KEY,
    user_id NUMBER(10) NOT NULL,
    collection_name VARCHAR2(100) NOT NULL,
    description VARCHAR2(500),
    is_public VARCHAR2(1) DEFAULT 'Y',
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE
);

CREATE INDEX idx_rc_user ON RECIPE_COLLECTIONS(user_id);
CREATE INDEX idx_rc_name ON RECIPE_COLLECTIONS(collection_name);

-- ⭐ 表21：COLLECTION_RECIPES (修复版) - 二元N:M关系
CREATE TABLE COLLECTION_RECIPES (
    collection_id NUMBER(10),
    recipe_id NUMBER(10),
    added_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    PRIMARY KEY (collection_id, recipe_id),
    FOREIGN KEY (collection_id) REFERENCES RECIPE_COLLECTIONS(collection_id) ON DELETE CASCADE,
    FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE CASCADE
);

CREATE INDEX idx_cr_collection ON COLLECTION_RECIPES(collection_id);
CREATE INDEX idx_cr_recipe ON COLLECTION_RECIPES(recipe_id);

-- 表22：SHOPPING_LISTS 购物清单
CREATE TABLE SHOPPING_LISTS (
    list_id NUMBER(10) PRIMARY KEY,
    user_id NUMBER(10) NOT NULL,
    list_name VARCHAR2(100) NOT NULL,
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE
);

CREATE INDEX idx_sl_user ON SHOPPING_LISTS(user_id);

-- ⭐ 表23：SHOPPING_LIST_ITEMS (修复版) - 二元N:M关系
CREATE TABLE SHOPPING_LIST_ITEMS (
    list_id NUMBER(10),
    ingredient_id NUMBER(10),
    quantity NUMBER(10,2),
    unit_id NUMBER(10),
    is_checked VARCHAR2(1) DEFAULT 'N',
    added_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    estimated_price NUMBER(10,2),
    actual_price NUMBER(10,2),
    PRIMARY KEY (list_id, ingredient_id),
    FOREIGN KEY (list_id) REFERENCES SHOPPING_LISTS(list_id) ON DELETE CASCADE,
    FOREIGN KEY (ingredient_id) REFERENCES INGREDIENTS(ingredient_id),
    FOREIGN KEY (unit_id) REFERENCES UNITS(unit_id)
);

CREATE INDEX idx_si_list ON SHOPPING_LIST_ITEMS(list_id);
CREATE INDEX idx_si_ingredient ON SHOPPING_LIST_ITEMS(ingredient_id);
CREATE INDEX idx_si_checked ON SHOPPING_LIST_ITEMS(is_checked);

-- 表24：MEAL_PLANS 膳食计划
CREATE TABLE MEAL_PLANS (
    plan_id NUMBER(10) PRIMARY KEY,
    user_id NUMBER(10) NOT NULL,
    plan_name VARCHAR2(100) NOT NULL,
    description VARCHAR2(500),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_public VARCHAR2(1) DEFAULT 'Y',
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    CONSTRAINT ck_meal_plan_dates CHECK (start_date <= end_date)
);

CREATE INDEX idx_mp_user ON MEAL_PLANS(user_id);
CREATE INDEX idx_mp_start_date ON MEAL_PLANS(start_date);

-- ⭐ 表25：MEAL_PLAN_ENTRIES (修复版) - 三元N:M关系
CREATE TABLE MEAL_PLAN_ENTRIES (
    plan_id NUMBER(10),
    recipe_id NUMBER(10),
    meal_date DATE,
    meal_type VARCHAR2(20),
    notes VARCHAR2(255),
    planned_servings NUMBER(3),
    actual_servings NUMBER(3),
    is_completed VARCHAR2(1) DEFAULT 'N',
    rating NUMBER(2),
    added_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    PRIMARY KEY (plan_id, recipe_id, meal_date),
    FOREIGN KEY (plan_id) REFERENCES MEAL_PLANS(plan_id) ON DELETE CASCADE,
    FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE RESTRICT
);

CREATE INDEX idx_me_plan ON MEAL_PLAN_ENTRIES(plan_id);
CREATE INDEX idx_me_recipe ON MEAL_PLAN_ENTRIES(recipe_id);
CREATE INDEX idx_me_meal_date ON MEAL_PLAN_ENTRIES(meal_date);

-- 表26：USER_ACTIVITY_LOG 用户活动日志
CREATE TABLE USER_ACTIVITY_LOG (
    activity_id NUMBER(10) PRIMARY KEY,
    user_id NUMBER(10) NOT NULL,
    activity_type VARCHAR2(50),
    activity_description VARCHAR2(255),
    related_recipe_id NUMBER(10),
    related_user_id NUMBER(10),
    activity_timestamp TIMESTAMP DEFAULT SYSTIMESTAMP,
    ip_address VARCHAR2(45),
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    FOREIGN KEY (related_recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE SET NULL,
    FOREIGN KEY (related_user_id) REFERENCES USERS(user_id) ON DELETE SET NULL
);

CREATE INDEX idx_al_user ON USER_ACTIVITY_LOG(user_id);
CREATE INDEX idx_al_activity_type ON USER_ACTIVITY_LOG(activity_type);

-- ============================================================
-- 触发器：自动生成主键
-- ============================================================

CREATE OR REPLACE TRIGGER trg_users_id
BEFORE INSERT ON USERS
FOR EACH ROW
BEGIN
    IF :NEW.user_id IS NULL THEN
        :NEW.user_id := seq_users.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_recipes_id
BEFORE INSERT ON RECIPES
FOR EACH ROW
BEGIN
    IF :NEW.recipe_id IS NULL THEN
        :NEW.recipe_id := seq_recipes.NEXTVAL;
    END IF;
END;
/

-- ============================================================
-- 统计信息
-- ============================================================
PROMPT
PROMPT ========== AllRecipes 数据库创建完成 ==========
PROMPT
PROMPT 🎉 共创建 26 个表（N:M关系规范化版本）
PROMPT ✅ 8个N:M关系表采用复合主键（无代理键）
PROMPT ✅ 完整的外键约束和索引
PROMPT ✅ 符合BCNF规范化
PROMPT
```

---

## 关键改动总结

| 表名 | 修改前主键 | 修改后主键 | 类型 |
|------|----------|----------|------|
| RECIPE_INGREDIENTS | recipe_ingredient_id (代理键) | (recipe_id, ingredient_id) ⭐ | 二元 |
| USER_ALLERGIES | user_allergy_id (代理键) | (user_id, allergen_id) ⭐ | 二元 |
| INGREDIENT_ALLERGENS | ingredient_allergen_id (代理键) | (ingredient_id, allergen_id) ⭐ | 二元 |
| RECIPE_TAGS | recipe_tag_id (代理键) | (recipe_id, tag_id) ⭐ | 二元 |
| INGREDIENT_SUBSTITUTIONS | substitution_id (代理键) | (original_id, substitute_id) ⭐ | 自引用 |
| COLLECTION_RECIPES | collection_recipe_id (代理键) | (collection_id, recipe_id) ⭐ | 二元 |
| SHOPPING_LIST_ITEMS | item_id (代理键) | (list_id, ingredient_id) ⭐ | 二元 |
| MEAL_PLAN_ENTRIES | entry_id (代理键) | (plan_id, recipe_id, meal_date) ⭐ | 三元 |

**优势**：
- ✅ 消除8个代理键冗余
- ✅ 符合BCNF规范化
- ✅ 数据库层保证唯一性
- ✅ 性能更优（索引更少）
- ✅ 语义更清晰

