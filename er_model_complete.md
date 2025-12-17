# AllRecipes 食谱网站 - ER模型设计文档（修订版v3.0）

## 目录

1. [概述](#概述)
2. [核心设计变更](#核心设计变更)
3. [实体设计](#实体设计)
4. [关系设计](#关系设计)
5. [多对多关系详解](#多对多关系详解)
6. [关系规范化](#关系规范化)

---

# 概述

本文档详细描述AllRecipes食谱网站数据库的**ER（实体-关系）模型**，包含所有实体、属性及其关系的完整分析。v3.0版本特别强调了多对多关系的**联合主键**设计方案。

## 统计数据

| 项目 | 数量 |
|-----|------|
| **实体** | 23个 |
| **常规实体** | 23个 |
| **属性总数** | 180+ |
| **关系** | 35+ |
| **1:1关系** | 1个 |
| **1:N关系** | 12个 |
| **N:M关系** | 11个（全部采用联合主键） |

---

# 核心设计变更（v2.0 → v3.0）

## 主要改进

### 问题识别（v2.0）

1. **冗余ID字段**：多对多关系表中既有ID主键，又有UNIQUE约束
   ```sql
   -- v2.0: 冗余设计
   recipe_ingredient_id NUMBER(10) PRIMARY KEY,  -- 不必要的ID
   recipe_id NUMBER(10) NOT NULL,
   ingredient_id NUMBER(10) NOT NULL,
   UNIQUE (recipe_id, ingredient_id)  -- 才是真正的唯一标识
   ```

2. **违反BCNF规范**：ID字段不能被非主键字段完全函数依赖
3. **存储浪费**：额外的ID字段占用存储空间
4. **查询复杂**：需要额外的索引和JOIN操作

### 解决方案（v3.0）

采用**联合主键（Composite Primary Key）** 设计：
- 使用两个或多个外键组成主键
- 自动保证关联记录的唯一性
- 符合BCNF规范
- 查询性能更优

### 修改的表（共11个）

```
1. RECIPE_INGREDIENTS (recipe_id, ingredient_id)
2. INGREDIENT_ALLERGENS (ingredient_id, allergen_id)
3. INGREDIENT_SUBSTITUTIONS (original_id, substitute_id)
4. USER_ALLERGIES (user_id, allergen_id)
5. RATING_HELPFULNESS (rating_id, user_id)
6. COMMENT_HELPFULNESS (comment_id, user_id)
7. COLLECTION_RECIPES (collection_id, recipe_id)
8. SHOPPING_LIST_ITEMS (list_id, ingredient_id)
9. RECIPE_TAGS (recipe_id, tag_id)
10. FOLLOWERS (user_id, follower_user_id)
11. MEAL_PLAN_ENTRIES (plan_id, recipe_id, meal_date)
```

---

# 实体设计

## 第一部分：用户域实体

### 实体1：USER（用户）

**实体类型**：常规实体

**主键**：User_ID

**关键属性**：

| # | 属性名 | 类型 | 说明 |
|----|--------|------|------|
| 1 | **User_ID** | 简单 | 🔑主键，用户唯一标识 |
| 2 | Username | 简单 | 用户名，唯一 |
| 3 | Email | 简单 | 邮箱地址，唯一 |
| 4 | Password_Hash | 简单 | 加密密码 |
| 5 | First_Name | 简单 | 用户名字 |
| 6 | Last_Name | 简单 | 用户姓氏 |
| 7 | Bio | 简单 | 个人简介 |
| 8 | Profile_Image | 简单 | 头像URL |
| 9 | Join_Date | 简单 | 注册日期 |
| 10 | Last_Login | 简单 | 最后登录时间 |
| 11 | Account_Status | 简单 | active/inactive/suspended |
| 12 | User_Type | 简单 | 普通用户/专业厨师/美食博主 |
| 13 | Total_Followers | 简单 | 派生属性：粉丝数 |
| 14 | Total_Recipes | 简单 | 派生属性：食谱数 |

---

## 第二部分：食材域实体

### 实体2：INGREDIENT（食材）

**实体类型**：常规实体

**主键**：Ingredient_ID

**关键属性**：

| # | 属性名 | 说明 |
|----|--------|------|
| 1 | **Ingredient_ID** | 🔑主键 |
| 2 | Ingredient_Name | 食材名称 |
| 3 | Category | 分类（蔬菜、肉类等） |
| 4 | Description | 描述 |

### 实体3：ALLERGEN（过敏原）

**实体类型**：常规实体

**主键**：Allergen_ID

**关键属性**：

| # | 属性名 | 说明 |
|----|--------|------|
| 1 | **Allergen_ID** | 🔑主键 |
| 2 | Allergen_Name | 过敏原名称（花生、乳制品等） |
| 3 | Description | 描述 |

### 实体4：UNIT（计量单位）

**实体类型**：常规实体

**主键**：Unit_ID

**关键属性**：

| # | 属性名 | 说明 |
|----|--------|------|
| 1 | **Unit_ID** | 🔑主键 |
| 2 | Unit_Name | 单位名称（克、毫升、杯等） |
| 3 | Abbreviation | 缩写（g、ml、cup） |

### 实体5：TAG（标签）

**实体类型**：常规实体

**主键**：Tag_ID

**关键属性**：

| # | 属性名 | 说明 |
|----|--------|------|
| 1 | **Tag_ID** | 🔑主键 |
| 2 | Tag_Name | 标签名称（素食、低脂等） |
| 3 | Tag_Description | 描述 |

---

## 第三部分：食谱域实体

### 实体6：RECIPE（食谱）

**实体类型**：常规实体

**主键**：Recipe_ID

**关键属性**：

| # | 属性名 | 说明 |
|----|--------|------|
| 1 | **Recipe_ID** | 🔑主键 |
| 2 | Recipe_Name | 食谱名称 |
| 3 | Description | 描述 |
| 4 | Cuisine_Type | 菜系 |
| 5 | Meal_Type | 早午晚餐 |
| 6 | Difficulty_Level | 难度等级 |
| 7 | Prep_Time | 准备时间 |
| 8 | Cook_Time | 烹饪时间 |
| 9 | Total_Time | 派生属性：总时间 |
| 10 | Servings | 份数 |
| 11 | Calories_Per_Serving | 每份热量 |
| 12 | Is_Published | 是否发布 |
| 13 | Average_Rating | 派生属性：平均评分 |
| 14 | View_Count | 派生属性：浏览数 |

---

## 第四部分：评价交互实体

### 实体7：RATING（食谱评价）

**实体类型**：常规实体

**主键**：Rating_ID

**关键属性**：

| # | 属性名 | 说明 |
|----|--------|------|
| 1 | **Rating_ID** | 🔑主键 |
| 2 | User_ID | 🔗外键：评价者 |
| 3 | Recipe_ID | 🔗外键：被评价食谱 |
| 4 | Rating_Value | 评分值(0-5) |
| 5 | Review_Text | 评价文本 |
| 6 | Rating_Date | 评价时间 |

**约束**：(User_ID, Recipe_ID) 唯一

### 实体8：COMMENT（评论）

**实体类型**：常规实体

**主键**：Comment_ID

**关键属性**：

| # | 属性名 | 说明 |
|----|--------|------|
| 1 | **Comment_ID** | 🔑主键 |
| 2 | User_ID | 🔗外键：评论者 |
| 3 | Recipe_ID | 🔗外键：被评论食谱 |
| 4 | Comment_Text | 评论文本 |
| 5 | Parent_Comment_ID | 自引用：回复的评论 |

---

# 关系设计

## 关系分类

### 1. 一对多（1:N）关系

#### 关系1：USERS → RECIPES

**名称**：Creates（用户创建食谱）

**基数**：1:N

**参与类型**：
- USERS：部分参与（不是所有用户都创建食谱）
- RECIPES：完全参与（每个食谱必须有创建者）

**外键**：RECIPES.USER_ID → USERS.USER_ID

**特性**：ON DELETE CASCADE（删除用户时，其食谱也删除）

---

#### 关系2：USERS → FOLLOWERS（被关注）

**名称**：Is_Followed_By

**基数**：1:N

**参与类型**：
- USERS（被关注者）：部分参与
- FOLLOWERS：完全参与

**外键**：FOLLOWERS.USER_ID → USERS.USER_ID

---

#### 其他1:N关系

- USERS → RATINGS（用户给出评价）
- USERS → COMMENTS（用户发表评论）
- USERS → SAVED_RECIPES（用户收藏食谱）
- RECIPES → COOKING_STEPS（食谱包含步骤）
- SHOPPING_LISTS → SHOPPING_LIST_ITEMS（购物清单包含项目）
- MEAL_PLANS → MEAL_PLAN_ENTRIES（膳食计划包含条目）

---

### 2. 多对多（N:M）关系 - 全部采用联合主键

#### 关系1：RECIPES ↔ INGREDIENTS

**关系表**：RECIPE_INGREDIENTS

**主键设计**：(RECIPE_ID, INGREDIENT_ID) - **联合主键**

**表结构**：
```sql
CREATE TABLE RECIPE_INGREDIENTS (
    recipe_id NUMBER(10) NOT NULL,
    ingredient_id NUMBER(10) NOT NULL,
    unit_id NUMBER(10) NOT NULL,
    quantity NUMBER(10,2) NOT NULL,
    notes VARCHAR2(255),
    added_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    PRIMARY KEY (recipe_id, ingredient_id),
    FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id),
    FOREIGN KEY (ingredient_id) REFERENCES INGREDIENTS(ingredient_id),
    FOREIGN KEY (unit_id) REFERENCES UNITS(unit_id)
);
```

**优势**：
- ✅ 无冗余ID字段
- ✅ 主键自动防止重复
- ✅ 查询高效
- ✅ 符合BCNF规范

---

#### 关系2：INGREDIENTS ↔ ALLERGENS

**关系表**：INGREDIENT_ALLERGENS

**主键设计**：(INGREDIENT_ID, ALLERGEN_ID) - **联合主键**

**业务含义**：定义食材中含有的过敏原

**表结构**：
```sql
CREATE TABLE INGREDIENT_ALLERGENS (
    ingredient_id NUMBER(10) NOT NULL,
    allergen_id NUMBER(10) NOT NULL,
    PRIMARY KEY (ingredient_id, allergen_id),
    FOREIGN KEY (ingredient_id) REFERENCES INGREDIENTS(ingredient_id),
    FOREIGN KEY (allergen_id) REFERENCES ALLERGENS(allergen_id)
);
```

---

#### 关系3：INGREDIENTS ↔ INGREDIENTS（自引用）

**关系表**：INGREDIENT_SUBSTITUTIONS

**主键设计**：(ORIGINAL_INGREDIENT_ID, SUBSTITUTE_INGREDIENT_ID) - **联合主键**

**业务含义**：定义食材之间的替代关系

**检查约束**：ORIGINAL_INGREDIENT_ID != SUBSTITUTE_INGREDIENT_ID

**表结构**：
```sql
CREATE TABLE INGREDIENT_SUBSTITUTIONS (
    original_ingredient_id NUMBER(10) NOT NULL,
    substitute_ingredient_id NUMBER(10) NOT NULL,
    substitution_ratio NUMBER(5,2),
    notes VARCHAR2(255),
    PRIMARY KEY (original_ingredient_id, substitute_ingredient_id),
    CONSTRAINT ck_different CHECK (original_ingredient_id != substitute_ingredient_id)
);
```

---

#### 关系4：RECIPES ↔ TAGS

**关系表**：RECIPE_TAGS

**主键设计**：(RECIPE_ID, TAG_ID) - **联合主键**

**表结构**：
```sql
CREATE TABLE RECIPE_TAGS (
    recipe_id NUMBER(10) NOT NULL,
    tag_id NUMBER(10) NOT NULL,
    added_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    PRIMARY KEY (recipe_id, tag_id),
    FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id),
    FOREIGN KEY (tag_id) REFERENCES TAGS(tag_id)
);
```

---

#### 关系5：USERS ↔ USERS（自引用）

**关系表**：FOLLOWERS

**主键设计**：(USER_ID, FOLLOWER_USER_ID) - **联合主键**

**业务含义**：用户关注其他用户的关系

**表结构**：
```sql
CREATE TABLE FOLLOWERS (
    user_id NUMBER(10) NOT NULL,
    follower_user_id NUMBER(10) NOT NULL,
    followed_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    PRIMARY KEY (user_id, follower_user_id),
    FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    FOREIGN KEY (follower_user_id) REFERENCES USERS(user_id),
    CONSTRAINT ck_not_self CHECK (user_id != follower_user_id)
);
```

**特殊性**：
- 自引用关系（两个外键都指向USERS）
- 非对称关系（A关注B ≠ B关注A）
- 检查约束防止自引用

---

#### 关系6：USERS ↔ ALLERGENS

**关系表**：USER_ALLERGIES

**主键设计**：(USER_ID, ALLERGEN_ID) - **联合主键**

**业务含义**：记录用户的过敏原信息

**表结构**：
```sql
CREATE TABLE USER_ALLERGIES (
    user_id NUMBER(10) NOT NULL,
    allergen_id NUMBER(10) NOT NULL,
    added_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    PRIMARY KEY (user_id, allergen_id),
    FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    FOREIGN KEY (allergen_id) REFERENCES ALLERGENS(allergen_id)
);
```

---

#### 关系7：RATINGS ↔ USERS（评价有用性投票）

**关系表**：RATING_HELPFULNESS

**主键设计**：(RATING_ID, USER_ID) - **联合主键**

**业务含义**：用户投票表示某个评价是否有用

**表结构**：
```sql
CREATE TABLE RATING_HELPFULNESS (
    rating_id NUMBER(10) NOT NULL,
    user_id NUMBER(10) NOT NULL,
    helpful_votes NUMBER(10) DEFAULT 0,
    voted_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    PRIMARY KEY (rating_id, user_id),
    FOREIGN KEY (rating_id) REFERENCES RATINGS(rating_id),
    FOREIGN KEY (user_id) REFERENCES USERS(user_id)
);
```

---

#### 关系8：COMMENTS ↔ USERS（评论有用性投票）

**关系表**：COMMENT_HELPFULNESS

**主键设计**：(COMMENT_ID, USER_ID) - **联合主键**

**业务含义**：用户投票表示某个评论是否有用

---

#### 关系9：RECIPE_COLLECTIONS ↔ RECIPES

**关系表**：COLLECTION_RECIPES

**主键设计**：(COLLECTION_ID, RECIPE_ID) - **联合主键**

**业务含义**：清单中包含的食谱

**表结构**：
```sql
CREATE TABLE COLLECTION_RECIPES (
    collection_id NUMBER(10) NOT NULL,
    recipe_id NUMBER(10) NOT NULL,
    added_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    PRIMARY KEY (collection_id, recipe_id),
    FOREIGN KEY (collection_id) REFERENCES RECIPE_COLLECTIONS(collection_id),
    FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id)
);
```

---

#### 关系10：SHOPPING_LISTS ↔ INGREDIENTS

**关系表**：SHOPPING_LIST_ITEMS

**主键设计**：(LIST_ID, INGREDIENT_ID) - **联合主键**

**业务含义**：购物清单中的食材项目

**表结构**：
```sql
CREATE TABLE SHOPPING_LIST_ITEMS (
    list_id NUMBER(10) NOT NULL,
    ingredient_id NUMBER(10) NOT NULL,
    quantity NUMBER(10,2),
    unit_id NUMBER(10),
    is_checked VARCHAR2(1) DEFAULT 'N',
    added_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    PRIMARY KEY (list_id, ingredient_id),
    FOREIGN KEY (list_id) REFERENCES SHOPPING_LISTS(list_id),
    FOREIGN KEY (ingredient_id) REFERENCES INGREDIENTS(ingredient_id),
    FOREIGN KEY (unit_id) REFERENCES UNITS(unit_id)
);
```

---

#### 关系11：MEAL_PLANS ↔ RECIPES（三字段联合主键）

**关系表**：MEAL_PLAN_ENTRIES

**主键设计**：(PLAN_ID, RECIPE_ID, MEAL_DATE) - **三字段联合主键**

**业务含义**：膳食计划中的每一天的食谱

**表结构**：
```sql
CREATE TABLE MEAL_PLAN_ENTRIES (
    plan_id NUMBER(10) NOT NULL,
    recipe_id NUMBER(10) NOT NULL,
    meal_date DATE NOT NULL,
    meal_type VARCHAR2(20),
    notes VARCHAR2(255),
    added_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    PRIMARY KEY (plan_id, recipe_id, meal_date),
    FOREIGN KEY (plan_id) REFERENCES MEAL_PLANS(plan_id),
    FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id),
    CONSTRAINT ck_meal_type CHECK (meal_type IN ('breakfast', 'lunch', 'dinner', 'snack'))
);
```

**特殊性**：
- 三个字段组成联合主键
- MEAL_DATE作为主键一部分，确保同一日期同一食谱只能添加一次
- 支持多个MEAL_TYPE（早、午、晚）在同一天

---

# 多对多关系详解

## 设计演进

### 传统弱实体设计（v1.0）

```sql
CREATE TABLE RECIPE_INGREDIENTS (
    recipe_ingredient_id NUMBER(10) PRIMARY KEY,
    recipe_id NUMBER(10) NOT NULL,
    ingredient_id NUMBER(10) NOT NULL
);
```

**问题**：
- ❌ 需要手动维护UNIQUE约束
- ❌ ID字段冗余，浪费存储
- ❌ 违反BCNF规范

### 改进ID方案（v2.0）

```sql
CREATE TABLE RECIPE_INGREDIENTS (
    recipe_ingredient_id NUMBER(10) PRIMARY KEY,
    recipe_id NUMBER(10) NOT NULL,
    ingredient_id NUMBER(10) NOT NULL,
    UNIQUE (recipe_id, ingredient_id)
);
```

**改进**：
- ✓ 添加UNIQUE约束防止重复
- ❌ 仍然有冗余ID字段
- ❌ 仍然违反BCNF规范

### 联合主键方案（v3.0）✅

```sql
CREATE TABLE RECIPE_INGREDIENTS (
    recipe_id NUMBER(10) NOT NULL,
    ingredient_id NUMBER(10) NOT NULL,
    PRIMARY KEY (recipe_id, ingredient_id),
    FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id),
    FOREIGN KEY (ingredient_id) REFERENCES INGREDIENTS(ingredient_id)
);
```

**优势**：
- ✅ 无冗余字段
- ✅ 主键自动强制唯一性
- ✅ 符合BCNF规范
- ✅ 存储高效
- ✅ 查询性能好

---

# 关系规范化

## ER模型到关系模型的转换

### 1:N关系的转换

**ER模型**：
```
USER (1) -----Creates-----> (N) RECIPE
```

**转换规则**：在RECIPE中添加外键

**关系模型**：
```sql
CREATE TABLE RECIPE (
    recipe_id NUMBER(10) PRIMARY KEY,
    user_id NUMBER(10) NOT NULL,
    -- ...
    FOREIGN KEY (user_id) REFERENCES USER(user_id)
);
```

### N:M关系的转换

**ER模型**：
```
RECIPE (N) ----Contains----> (M) INGREDIENT
```

**转换规则（v3.0）**：创建关联表，使用联合主键

**关系模型**：
```sql
CREATE TABLE RECIPE_INGREDIENTS (
    recipe_id NUMBER(10) NOT NULL,
    ingredient_id NUMBER(10) NOT NULL,
    PRIMARY KEY (recipe_id, ingredient_id),
    -- 其他非键属性：unit_id, quantity, notes等
);
```

### 一对一关系的转换

**ER模型**：
```
RECIPE (1) ----Has-----> (1) NUTRITION_INFO
```

**转换规则**：在从实体中添加主键外键 + UNIQUE约束

**关系模型**：
```sql
CREATE TABLE NUTRITION_INFO (
    nutrition_id NUMBER(10) PRIMARY KEY,
    recipe_id NUMBER(10) NOT NULL UNIQUE,
    -- ...
    FOREIGN KEY (recipe_id) REFERENCES RECIPE(recipe_id)
);
```

---

## 总结

本v3.0设计通过采用**联合主键**方案，完全消除了多对多关系表中的冗余ID字段，使得数据库设计更加规范、高效、符合BCNF规范。这是对v2.0的重大改进，也是业界推荐的最佳实践。
