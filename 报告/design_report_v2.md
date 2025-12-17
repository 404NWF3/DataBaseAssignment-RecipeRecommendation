# AllRecipes 食谱网站数据库设计报告 (增强版 v2.0)

## 目录

1. **项目背景介绍**
2. **ER图设计（概念模型）**
3. **数据库库表设计（逻辑模型）**
4. **规范化**
5. **常见操作归纳**
6. **完整性约束方案设计**
7. **表的详细设计（物理模型）**
8. **视图设计方案**
9. **数据库安全方案设计**

---

# 第1章 项目背景介绍

## 1.1 AllRecipes 网站概述

AllRecipes 是全球最大的食谱分享平台之一，拥有数百万用户和数百万条食谱。该网站以其用户友好的界面、丰富的食谱内容和强大的社区功能而闻名。

![AllRecipe-Index](image-1.png)

### 核心业务功能

- **食谱发布与分享**：用户可以上传自己创作的食谱，包括详细的食材清单、烹饪步骤、烹饪时间、难度等级等信息，并支持上传高质量的图片。
- **多维度食谱搜索与浏览**：用户通过关键词、菜系、食材、难度级别、烹饪时间等多个维度进行灵活搜索，发现适合自己的食谱。
- **用户交互与社交功能**：包括食谱评价、评论、收藏、关注其他用户等丰富的互动方式，建立活跃的社区文化。
- **个性化食谱管理**：用户可以创建多个食谱收藏清单、购物清单、膳食计划等，提高烹饪的便利性和计划性。
- **健康饮食支持**：系统支持用户管理过敏原信息、查看营养信息、推荐过敏源安全食谱等功能。

## 1.2 核心业务数据

AllRecipes 的主要数据对象包括：

| 数据对象 | 描述 | 关键属性 |
|---------|------|---------|
| **用户（Users）** | 平台使用者 | 用户名、邮箱、密码、个人资料、粉丝数、账户状态 |
| **食谱（Recipes）** | 烹饪菜谱 | 食谱名称、描述、菜系、难度、烹饪时间、评分、浏览数 |
| **食材（Ingredients）** | 烹饪所需原料 | 食材名称、分类、描述、过敏原信息 |
| **膳食计划（MealPlans）** | 用户的一周/一月食谱安排 | 计划名称、时间范围、公开状态 |
| **购物清单（ShoppingLists）** | 用户需要购买的食材 | 清单名称、食材列表、购买状态 |
| **评价和评论（Ratings & Comments）** | 用户对食谱的反馈 | 评分、评论文本、有用性评分 |
| **社交关系（Followers）** | 用户之间的关注关系 | 关注时间、粉丝数、活动流 |
| **食材替代（Substitutions）** | 食材替代品知识库 | 替代品、替代比例、批准状态 |

## 1.3 业务流程分析

### 食谱发布流程
```
用户注册 → 登录 → 创建食谱 → 添加基本信息 → 添加食材
→ 设置烹饪步骤 → 上传图片 → 验证和预览 → 发布
```

### 食谱浏览与评价流程
```
用户浏览 → 搜索（按菜系/食材/难度等） → 查看食谱详情 
→ 查看评价和评论 → 添加到收藏/清单 → 评价或评论
```

### 膳食规划流程
```
查看推荐食谱 → 创建膳食计划 → 为每天安排食谱
→ 系统整合购物清单 → 生成购物清单 → 管理购物进度
```

### 社区互动流程
```
浏览用户资料 → 关注用户 → 查看关注用户的食谱
→ 与用户互动（评价、评论、私信等）
```

---

# 第2章 ER图设计（概念模型）

## 2.1 ER图架构概览

本数据库系统包含 **26 个核心表**，分为以下功能模块：

```
┌─────────────────────────────────────────────────────────────┐
│                     核心基础模块 (6个表)                      │
│  USERS / INGREDIENTS / UNITS / ALLERGENS / TAGS / USER_ALLERGIES
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                     食谱核心模块 (7个表)                      │
│  RECIPES / RECIPE_INGREDIENTS / COOKING_STEPS / NUTRITION_INFO
│  INGREDIENT_ALLERGENS / RECIPE_TAGS / INGREDIENT_SUBSTITUTIONS
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                    用户交互模块 (7个表)                      │
│  RATINGS / RATING_HELPFULNESS / COMMENTS / COMMENT_HELPFULNESS
│  SAVED_RECIPES / FOLLOWERS / USER_ACTIVITY_LOG
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                    个人管理模块 (6个表)                      │
│  RECIPE_COLLECTIONS / COLLECTION_RECIPES
│  SHOPPING_LISTS / SHOPPING_LIST_ITEMS
│  MEAL_PLANS / MEAL_PLAN_ENTRIES
└─────────────────────────────────────────────────────────────┘
```

## 2.2 主要关系描述

**1:N 关系**：
- USERS → RECIPES（一个用户可以创建多个食谱）
- RECIPES → RECIPE_INGREDIENTS（一个食谱包含多个食材）
- RECIPES → COOKING_STEPS（一个食谱有多个烹饪步骤）
- RECIPES → RATINGS（一个食谱接收多个评价）
- RECIPES → COMMENTS（一个食谱接收多个评论）
- USERS → FOLLOWERS（一个用户可被多人关注）

**N:M 关系**：
- RECIPES ↔ INGREDIENTS（通过 RECIPE_INGREDIENTS 表）
- RECIPES ↔ TAGS（通过 RECIPE_TAGS 表）
- INGREDIENTS ↔ ALLERGENS（通过 INGREDIENT_ALLERGENS 表）
- USERS ↔ USERS（通过 FOLLOWERS 表实现自关系）

**新增关系**：
- USERS → MEAL_PLANS → RECIPES（膳食计划管理）
- INGREDIENTS ↔ INGREDIENTS（通过 INGREDIENT_SUBSTITUTIONS 表表示替代关系）
- USERS → USER_ALLERGIES → ALLERGENS（用户过敏原管理）

---

# 第3章 数据库库表设计（逻辑模型）

## 3.1 表的分类和数量统计

| 模块 | 表名 | 数量 | 说明 |
|------|------|------|------|
| **核心基础** | USERS, INGREDIENTS, UNITS, ALLERGENS, TAGS, USER_ALLERGIES | 6 | 系统基础数据表 |
| **食谱核心** | RECIPES, RECIPE_INGREDIENTS, COOKING_STEPS, NUTRITION_INFO, INGREDIENT_ALLERGENS, RECIPE_TAGS, INGREDIENT_SUBSTITUTIONS | 7 | 食谱及其属性表 |
| **用户交互** | RATINGS, RATING_HELPFULNESS, COMMENTS, COMMENT_HELPFULNESS, SAVED_RECIPES, FOLLOWERS, USER_ACTIVITY_LOG | 7 | 社交和交互表 |
| **个人管理** | RECIPE_COLLECTIONS, COLLECTION_RECIPES, SHOPPING_LISTS, SHOPPING_LIST_ITEMS, MEAL_PLANS, MEAL_PLAN_ENTRIES | 6 | 个性化管理表 |
| **总计** | | **26** | 完整系统 |

## 3.2 核心表详细设计

### 第一组：基础数据表

#### 1. USERS（用户表）
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| user_id | NUMBER(10) | PK | 用户唯一标识 |
| username | VARCHAR2(50) | NOT NULL, UNIQUE | 用户名，平台唯一 |
| email | VARCHAR2(100) | NOT NULL, UNIQUE | 邮箱，用于登录和联系 |
| password_hash | VARCHAR2(255) | NOT NULL | 加密密码 |
| first_name | VARCHAR2(50) | | 名 |
| last_name | VARCHAR2(50) | | 姓 |
| bio | VARCHAR2(500) | | 用户简介 |
| profile_image | VARCHAR2(255) | | 头像URL |
| join_date | DATE | NOT NULL, DEFAULT SYSDATE | 注册日期 |
| last_login | DATE | | 最后登录时间 |
| account_status | VARCHAR2(20) | DEFAULT 'active', CHECK | active/inactive/suspended |
| total_followers | NUMBER(10) | DEFAULT 0 | 粉丝总数（冗余字段，性能优化） |
| total_recipes | NUMBER(10) | DEFAULT 0 | 食谱总数（冗余字段，性能优化） |
| created_at | TIMESTAMP | DEFAULT SYSTIMESTAMP | 创建时间戳 |
| updated_at | TIMESTAMP | DEFAULT SYSTIMESTAMP | 最后更新时间戳 |

#### 2. INGREDIENTS（食材表）
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| ingredient_id | NUMBER(10) | PK | 食材唯一标识 |
| ingredient_name | VARCHAR2(100) | NOT NULL, UNIQUE | 食材名称 |
| category | VARCHAR2(50) | NOT NULL | 分类（蔬菜、肉类、调味料等） |
| description | VARCHAR2(255) | | 详细描述 |
| created_at | TIMESTAMP | DEFAULT SYSTIMESTAMP | 创建时间 |

#### 3. UNITS（单位表）
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| unit_id | NUMBER(10) | PK | 单位唯一标识 |
| unit_name | VARCHAR2(50) | NOT NULL, UNIQUE | 单位名称（克、毫升、杯等） |
| abbreviation | VARCHAR2(20) | | 缩写（g, ml, cup等） |
| description | VARCHAR2(100) | | 单位说明 |
| created_at | TIMESTAMP | DEFAULT SYSTIMESTAMP | 创建时间 |

#### 4. ALLERGENS（过敏原表）
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| allergen_id | NUMBER(10) | PK | 过敏原唯一标识 |
| allergen_name | VARCHAR2(100) | NOT NULL, UNIQUE | 过敏原名称（花生、坚果等） |
| description | VARCHAR2(255) | | 过敏原描述 |
| created_at | TIMESTAMP | DEFAULT SYSTIMESTAMP | 创建时间 |

#### 5. TAGS（标签表）
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| tag_id | NUMBER(10) | PK | 标签唯一标识 |
| tag_name | VARCHAR2(50) | NOT NULL, UNIQUE | 标签名称（素食、低脂等） |
| tag_description | VARCHAR2(255) | | 标签描述 |
| created_at | TIMESTAMP | DEFAULT SYSTIMESTAMP | 创建时间 |

#### 6. USER_ALLERGIES（用户过敏原表）- 新增
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| user_allergy_id | NUMBER(10) | PK | 记录唯一标识 |
| user_id | NUMBER(10) | FK | 用户ID |
| allergen_id | NUMBER(10) | FK | 过敏原ID |
| added_at | TIMESTAMP | DEFAULT SYSTIMESTAMP | 添加时间 |

### 第二组：食谱核心表

#### 7. RECIPES（食谱表）
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| recipe_id | NUMBER(10) | PK | 食谱唯一标识 |
| user_id | NUMBER(10) | FK | 创建者用户ID |
| recipe_name | VARCHAR2(200) | NOT NULL | 食谱名称 |
| description | VARCHAR2(1000) | | 详细描述 |
| cuisine_type | VARCHAR2(50) | | 菜系（中式、意式、日式等） |
| meal_type | VARCHAR2(50) | CHECK | breakfast/lunch/dinner/snack/dessert |
| difficulty_level | VARCHAR2(20) | CHECK | easy/medium/hard |
| prep_time | NUMBER(5) | | 准备时间（分钟） |
| cook_time | NUMBER(5) | | 烹饪时间（分钟） |
| total_time | NUMBER(5) | | 总时间（分钟） |
| servings | NUMBER(5) | | 份数 |
| calories_per_serving | NUMBER(10) | | 每份热量 |
| image_url | VARCHAR2(255) | | 食谱主图URL |
| is_published | VARCHAR2(1) | CHECK | Y/N，是否发布 |
| is_deleted | VARCHAR2(1) | CHECK | Y/N，逻辑删除标记 |
| view_count | NUMBER(10) | DEFAULT 0 | 浏览次数 |
| rating_count | NUMBER(10) | DEFAULT 0 | 评价数量 |
| average_rating | NUMBER(3,2) | DEFAULT 0 | 平均评分（0-5） |
| created_at | TIMESTAMP | DEFAULT SYSTIMESTAMP | 创建时间 |
| updated_at | TIMESTAMP | DEFAULT SYSTIMESTAMP | 最后更新时间 |

#### 8. RECIPE_INGREDIENTS（食谱食材表）
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| recipe_ingredient_id | NUMBER(10) | PK | 关联唯一标识 |
| recipe_id | NUMBER(10) | FK | 食谱ID |
| ingredient_id | NUMBER(10) | FK | 食材ID |
| unit_id | NUMBER(10) | FK | 单位ID |
| quantity | NUMBER(10,2) | NOT NULL | 数量 |
| notes | VARCHAR2(255) | | 备注（如"切碎"、"预先煮沸"等） |

#### 9. COOKING_STEPS（烹饪步骤表）
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| step_id | NUMBER(10) | PK | 步骤唯一标识 |
| recipe_id | NUMBER(10) | FK | 食谱ID |
| step_number | NUMBER(5) | NOT NULL | 步骤序号（1, 2, 3...） |
| instruction | VARCHAR2(1000) | NOT NULL | 步骤详细说明 |
| time_required | NUMBER(5) | | 该步骤所需时间（分钟） |
| image_url | VARCHAR2(255) | | 步骤配图URL |

#### 10. NUTRITION_INFO（营养信息表）
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| nutrition_id | NUMBER(10) | PK | 营养信息唯一标识 |
| recipe_id | NUMBER(10) | FK, UNIQUE | 食谱ID（一对一关系） |
| calories | NUMBER(10) | | 热量（卡） |
| protein_grams | NUMBER(10,2) | | 蛋白质（克） |
| carbs_grams | NUMBER(10,2) | | 碳水化合物（克） |
| fat_grams | NUMBER(10,2) | | 脂肪（克） |
| fiber_grams | NUMBER(10,2) | | 纤维（克） |
| sugar_grams | NUMBER(10,2) | | 糖（克） |
| sodium_mg | NUMBER(10) | | 钠（毫克） |

#### 11-27. 其他核心表（省略详细设计以节省篇幅）

详见 `createtable_v2.sql` 文件。

---

# 第4章 规范化

## 4.1 规范化目标与策略

本数据库严格遵循 **BCNF（Boyce-Codd Normal Form）** 规范，通过系统化的设计确保：

- **消除数据冗余**：每条数据只在一个地方存储
- **确保数据一致性**：任何修改自动反映到所有依赖
- **防止异常操作**：避免插入、更新、删除异常
- **优化查询性能**：通过合理的表分解提高查询效率

## 4.2 逐级规范化分析

### 第一范式（1NF）- 原子性

**原则**：所有字段值都必须是原子的（不可再分）。

**应用示例**：

❌ **错误设计**：在 RECIPES 表中存储
```
ingredients VARCHAR2(1000) := '鸡蛋 2个, 面粉 2杯, 糖 1杯'
```

✅ **正确设计**：创建 RECIPE_INGREDIENTS 表
```
RECIPE_INGREDIENTS:
  recipe_id = 1, ingredient_id = 1, quantity = 2, unit_id = 6 (个)
  recipe_id = 1, ingredient_id = 2, quantity = 2, unit_id = 3 (杯)
  recipe_id = 1, ingredient_id = 5, quantity = 1, unit_id = 3 (杯)
```

### 第二范式（2NF）- 消除部分函数依赖

**原则**：所有非主键属性必须完全依赖于整个主键，不能部分依赖。

**应用示例**：

❌ **错误设计**：RECIPE_INGREDIENTS 表中同时存储
```
recipe_id, ingredient_id, quantity, ingredient_name, ingredient_category
```
此时 ingredient_name 只依赖于 ingredient_id，形成部分依赖。

✅ **正确设计**：分离为两个表
```
RECIPE_INGREDIENTS: recipe_id, ingredient_id, quantity, unit_id
INGREDIENTS: ingredient_id, ingredient_name, category
```

### 第三范式（3NF）- 消除传递函数依赖

**原则**：所有非主键属性都直接依赖于主键，不能通过其他非主键属性间接依赖。

**应用示例**：

❌ **错误设计**：RECIPES 表中存储
```
recipe_id → user_id → total_followers
```
这形成了传递依赖。

✅ **正确设计**：分离为两个表，且 total_followers 作为冗余字段仅用于性能优化
```
RECIPES: recipe_id, user_id, recipe_name, ...
USERS: user_id, username, ..., total_followers
```

### Boyce-Codd 范式（BCNF）- 最强形式的规范化

**原则**：对于每个非平凡的函数依赖 X→Y，X 必须是超键（包含候选键）。

**分析关键表**：

**表1：RATINGS**
```
候选键：{user_id, recipe_id}（一个用户对一个食谱只能评价一次）
函数依赖：
  {user_id, recipe_id} → rating_value ✓（超键）
  {user_id, recipe_id} → review_text ✓（超键）
  {user_id, recipe_id} → rating_date ✓（超键）
结论：满足 BCNF ✓
```

**表2：RECIPE_INGREDIENTS**
```
候选键：{recipe_id, ingredient_id}
函数依赖：
  {recipe_id, ingredient_id} → quantity ✓（超键）
  {recipe_id, ingredient_id} → unit_id ✓（超键）
  {recipe_id, ingredient_id} → notes ✓（超键）
结论：满足 BCNF ✓
```

**表3：FOLLOWERS**
```
候选键：{user_id, follower_user_id}
函数依赖：
  {user_id, follower_user_id} → followed_at ✓（超键）
结论：满足 BCNF ✓
```

## 4.3 规范化总结表

| # | 表名 | 主键 | 规范化等级 | 关键设计决策 |
|---|------|------|----------|-----------|
| 1 | USERS | user_id | BCNF | 用户基本信息，total_followers/total_recipes为性能冗余 |
| 2 | INGREDIENTS | ingredient_id | BCNF | 食材基础库，避免重复存储 |
| 3 | UNITS | unit_id | BCNF | 独立单位表，支持扩展 |
| 4 | ALLERGENS | allergen_id | BCNF | 过敏原字典 |
| 5 | TAGS | tag_id | BCNF | 标签字典 |
| 6 | USER_ALLERGIES | user_allergy_id | BCNF | 用户过敏原关系 |
| 7 | RECIPES | recipe_id | BCNF | 食谱主表，包含聚合字段 |
| 8 | RECIPE_INGREDIENTS | recipe_ingredient_id | BCNF | N:M关系表，完全依赖于复合主键 |
| 9 | COOKING_STEPS | step_id | BCNF | 步骤序列保证唯一性 |
| 10 | NUTRITION_INFO | nutrition_id | BCNF | 一对一关系，完整分离营养数据 |
| 11 | INGREDIENT_ALLERGENS | ingredient_allergen_id | BCNF | N:M关系表 |
| 12 | RECIPE_TAGS | recipe_tag_id | BCNF | N:M关系表 |
| 13 | RATINGS | rating_id | BCNF | 复合唯一键保证一人一评 |
| 14 | RATING_HELPFULNESS | helpful_id | BCNF | 跟踪每个"有用"投票，防重复 |
| 15 | COMMENTS | comment_id | BCNF | 自引用支持嵌套评论 |
| 16 | COMMENT_HELPFULNESS | helpful_id | BCNF | 跟踪每个"有用"投票 |
| 17 | SAVED_RECIPES | saved_recipe_id | BCNF | N:M关系，收藏管理 |
| 18 | FOLLOWERS | follower_id | BCNF | N:M自关系，防自关注 |
| 19 | USER_ACTIVITY_LOG | activity_id | BCNF | 活动日志，支持审计 |
| 20 | RECIPE_COLLECTIONS | collection_id | BCNF | 用户创建的清单 |
| 21 | COLLECTION_RECIPES | collection_recipe_id | BCNF | N:M关系 |
| 22 | SHOPPING_LISTS | list_id | BCNF | 购物清单主表 |
| 23 | SHOPPING_LIST_ITEMS | item_id | BCNF | 清单项目 |
| 24 | MEAL_PLANS | plan_id | BCNF | 膳食计划新增功能 |
| 25 | MEAL_PLAN_ENTRIES | entry_id | BCNF | 膳食计划条目 |
| 26 | INGREDIENT_SUBSTITUTIONS | substitution_id | BCNF | 食材替代品知识库 |

---

# 第5章 常见操作归纳

本章列举数据库的日常操作，分为查询、插入、更新、删除四大类，共涵盖 **40+ 个实际应用场景**。

## 5.1 查询操作（SELECT）

### 5.1.1 基础查询

**1. 按菜系搜索食谱**
```sql
SELECT r.recipe_id, r.recipe_name, r.average_rating, r.view_count, u.username
FROM RECIPES r
JOIN USERS u ON r.user_id = u.user_id
WHERE r.cuisine_type = '中式' 
  AND r.is_published = 'Y'
  AND r.is_deleted = 'N'
ORDER BY r.average_rating DESC, r.view_count DESC
FETCH FIRST 20 ROWS ONLY;
```

**2. 按难度和时间查询食谱**
```sql
SELECT r.recipe_id, r.recipe_name, r.difficulty_level, r.total_time
FROM RECIPES r
WHERE r.difficulty_level = 'easy'
  AND r.total_time <= 30
  AND r.is_published = 'Y'
ORDER BY r.average_rating DESC;
```

**3. 查询用户的所有食谱**
```sql
SELECT r.recipe_id, r.recipe_name, r.created_at, r.rating_count, r.average_rating
FROM RECIPES r
WHERE r.user_id = :user_id
  AND r.is_deleted = 'N'
ORDER BY r.created_at DESC;
```

**4. 查询用户收藏的食谱**
```sql
SELECT DISTINCT r.recipe_id, r.recipe_name, r.average_rating
FROM SAVED_RECIPES sr
JOIN RECIPES r ON sr.recipe_id = r.recipe_id
WHERE sr.user_id = :user_id
  AND r.is_deleted = 'N'
ORDER BY sr.saved_at DESC;
```

### 5.1.2 复杂关联查询

**5. 查询食谱详情（含所有关联信息）**

```sql
SELECT 
    r.recipe_id,
    r.recipe_name,
    r.description,
    r.cuisine_type,
    r.meal_type,
    r.difficulty_level,
    r.prep_time,
    r.cook_time,
    r.total_time,
    r.servings,
    u.username AS creator,
    r.average_rating,
    r.rating_count,
    r.view_count,
    ni.calories,
    ni.protein_grams,
    ni.carbs_grams,
    ni.fat_grams,
    STRING_AGG(t.tag_name, ',') AS tags
FROM RECIPES r
JOIN USERS u ON r.user_id = u.user_id
LEFT JOIN NUTRITION_INFO ni ON r.recipe_id = ni.recipe_id
LEFT JOIN RECIPE_TAGS rt ON r.recipe_id = rt.recipe_id
LEFT JOIN TAGS t ON rt.tag_id = t.tag_id
WHERE r.recipe_id = :recipe_id
  AND r.is_deleted = 'N'
GROUP BY r.recipe_id, r.recipe_name, r.description, r.cuisine_type, r.meal_type,
         r.difficulty_level, r.prep_time, r.cook_time, r.total_time, r.servings,
         u.username, r.average_rating, r.rating_count, r.view_count,
         ni.calories, ni.protein_grams, ni.carbs_grams, ni.fat_grams;
```

**6. 查询食谱包含的所有食材及用量**
```sql
SELECT 
    ri.ingredient_id,
    i.ingredient_name,
    i.category,
    ri.quantity,
    u.unit_name,
    u.abbreviation,
    ri.notes
FROM RECIPE_INGREDIENTS ri
JOIN INGREDIENTS i ON ri.ingredient_id = i.ingredient_id
JOIN UNITS u ON ri.unit_id = u.unit_id
WHERE ri.recipe_id = :recipe_id
ORDER BY ri.ingredient_id;
```

**7. 查询食谱的所有烹饪步骤**
```sql
SELECT 
    step_number,
    instruction,
    time_required,
    image_url
FROM COOKING_STEPS
WHERE recipe_id = :recipe_id
ORDER BY step_number;
```

### 5.1.3 评价与评论查询

**8. 查询食谱的所有评价（分页）**
```sql
SELECT 
    rt.rating_id,
    rt.user_id,
    u.username,
    rt.rating_value,
    rt.review_text,
    COUNT(rh.helpful_id) AS helpful_count,
    rt.rating_date
FROM RATINGS rt
JOIN USERS u ON rt.user_id = u.user_id
LEFT JOIN RATING_HELPFULNESS rh ON rt.rating_id = rh.rating_id
WHERE rt.recipe_id = :recipe_id
GROUP BY rt.rating_id, rt.user_id, u.username, rt.rating_value, rt.review_text, rt.rating_date
ORDER BY helpful_count DESC, rt.rating_date DESC;
```

**9. 查询食谱的所有评论（支持嵌套显示）**
```sql
WITH RECURSIVE comment_tree AS (
    -- 基础查询：获取顶级评论（parent_comment_id 为 NULL）
    SELECT 
        c.comment_id,
        c.recipe_id,
        c.user_id,
        u.username,
        c.comment_text,
        c.parent_comment_id,
        c.created_at,
        0 AS level,
        CAST(c.comment_id AS VARCHAR2(255)) AS path
    FROM COMMENTS c
    JOIN USERS u ON c.user_id = u.user_id
    WHERE c.recipe_id = :recipe_id
      AND c.parent_comment_id IS NULL
      AND c.is_deleted = 'N'
    
    UNION ALL
    
    -- 递归查询：获取回复评论
    SELECT 
        c.comment_id,
        c.recipe_id,
        c.user_id,
        u.username,
        c.comment_text,
        c.parent_comment_id,
        c.created_at,
        ct.level + 1,
        ct.path || '-' || c.comment_id
    FROM COMMENTS c
    JOIN USERS u ON c.user_id = u.user_id
    JOIN comment_tree ct ON c.parent_comment_id = ct.comment_id
    WHERE c.is_deleted = 'N'
      AND ct.level < 5  -- 限制嵌套深度
)
SELECT 
    comment_id,
    username,
    comment_text,
    created_at,
    level,
    path
FROM comment_tree
ORDER BY path;
```

**10. 查询用户给出的所有评价**
```sql
SELECT 
    r.recipe_name,
    rt.rating_value,
    rt.review_text,
    rt.rating_date,
    COUNT(rh.helpful_id) AS helpful_count
FROM RATINGS rt
JOIN RECIPES r ON rt.recipe_id = r.recipe_id
LEFT JOIN RATING_HELPFULNESS rh ON rt.rating_id = rh.rating_id
WHERE rt.user_id = :user_id
GROUP BY r.recipe_name, rt.rating_value, rt.review_text, rt.rating_date
ORDER BY rt.rating_date DESC;
```

### 5.1.4 社交与推荐查询

**11. 查询用户的关注者和粉丝**
```sql
-- 用户A关注的人
SELECT 
    u.user_id,
    u.username,
    u.total_recipes,
    u.total_followers,
    f.followed_at
FROM FOLLOWERS f
JOIN USERS u ON f.user_id = u.user_id
WHERE f.follower_user_id = :user_id
ORDER BY f.followed_at DESC;

-- 关注用户A的人
SELECT 
    u.user_id,
    u.username,
    u.total_recipes,
    u.total_followers,
    f.followed_at
FROM FOLLOWERS f
JOIN USERS u ON f.follower_user_id = u.user_id
WHERE f.user_id = :user_id
ORDER BY f.followed_at DESC;
```

**12. 推荐食谱（基于用户关注的创作者）**
```sql
SELECT DISTINCT 
    r.recipe_id,
    r.recipe_name,
    r.average_rating,
    r.view_count,
    u.username,
    COUNT(*) OVER (PARTITION BY r.recipe_id) AS rank_score
FROM RECIPES r
JOIN FOLLOWERS f ON r.user_id = f.user_id
JOIN USERS u ON r.user_id = u.user_id
WHERE f.follower_user_id = :user_id
  AND r.is_published = 'Y'
  AND r.is_deleted = 'N'
  AND r.recipe_id NOT IN (SELECT recipe_id FROM SAVED_RECIPES WHERE user_id = :user_id)
ORDER BY r.average_rating DESC, r.view_count DESC
FETCH FIRST 10 ROWS ONLY;
```

**13. 包含特定食材的食谱**
```sql
SELECT DISTINCT 
    r.recipe_id,
    r.recipe_name,
    r.average_rating,
    COUNT(ri.ingredient_id) AS matching_ingredients
FROM RECIPES r
JOIN RECIPE_INGREDIENTS ri ON r.recipe_id = ri.recipe_id
WHERE ri.ingredient_id IN (
    SELECT ingredient_id FROM INGREDIENTS 
    WHERE ingredient_name IN ('鸡蛋', '面粉', '牛奶')
)
  AND r.is_published = 'Y'
  AND r.is_deleted = 'N'
GROUP BY r.recipe_id, r.recipe_name, r.average_rating
HAVING COUNT(ri.ingredient_id) >= 2
ORDER BY r.average_rating DESC;
```

**14. 不含过敏原的安全食谱推荐**
```sql
SELECT DISTINCT 
    r.recipe_id,
    r.recipe_name,
    r.average_rating
FROM RECIPES r
WHERE r.is_published = 'Y'
  AND r.is_deleted = 'N'
  AND NOT EXISTS (
      -- 检查食谱中是否包含用户过敏的食材
      SELECT 1
      FROM RECIPE_INGREDIENTS ri
      JOIN INGREDIENT_ALLERGENS ia ON ri.ingredient_id = ia.ingredient_id
      JOIN USER_ALLERGIES ua ON ia.allergen_id = ua.allergen_id
      WHERE ri.recipe_id = r.recipe_id
        AND ua.user_id = :user_id
  )
ORDER BY r.average_rating DESC
FETCH FIRST 20 ROWS ONLY;
```

### 5.1.5 高级分析查询

**15. 热门食谱排行（综合评分、评论数、浏览数）**
```sql
SELECT 
    r.recipe_id,
    r.recipe_name,
    r.average_rating,
    r.rating_count,
    r.view_count,
    ROUND(
        r.average_rating * 0.5 +           -- 评分权重 50%
        (r.rating_count / 100.0) * 0.3 +   -- 评价数权重 30%
        (r.view_count / 1000.0) * 0.2, 2   -- 浏览数权重 20%
    ) AS popularity_score
FROM RECIPES r
WHERE r.is_published = 'Y'
  AND r.is_deleted = 'N'
  AND r.created_at > SYSDATE - 365  -- 过去一年
ORDER BY popularity_score DESC
FETCH FIRST 30 ROWS ONLY;
```

**16. 生成整合的购物清单（为膳食计划）**
```sql
SELECT 
    i.ingredient_name,
    SUM(ri.quantity) AS total_quantity,
    u.unit_name,
    STRING_AGG(DISTINCT r.recipe_name, '; ') AS recipes
FROM MEAL_PLAN_ENTRIES mpe
JOIN RECIPES r ON mpe.recipe_id = r.recipe_id
JOIN RECIPE_INGREDIENTS ri ON r.recipe_id = ri.recipe_id
JOIN INGREDIENTS i ON ri.ingredient_id = i.ingredient_id
JOIN UNITS u ON ri.unit_id = u.unit_id
WHERE mpe.plan_id = :plan_id
GROUP BY i.ingredient_name, u.unit_name
ORDER BY i.ingredient_name;
```

**17. 查询食材的替代品**
```sql
SELECT 
    i_orig.ingredient_name AS original_ingredient,
    i_sub.ingredient_name AS substitute_ingredient,
    sub.ratio,
    sub.notes,
    sub.approval_status
FROM INGREDIENT_SUBSTITUTIONS sub
JOIN INGREDIENTS i_orig ON sub.original_ingredient_id = i_orig.ingredient_id
JOIN INGREDIENTS i_sub ON sub.substitute_ingredient_id = i_sub.ingredient_id
WHERE sub.original_ingredient_id = :ingredient_id
  AND sub.approval_status = 'approved'
ORDER BY sub.ratio DESC;
```

**18. 最受欢迎的食材搭配**
```sql
SELECT 
    i1.ingredient_name AS ingredient_a,
    i2.ingredient_name AS ingredient_b,
    COUNT(*) AS pair_frequency,
    ROUND(AVG(r.average_rating), 2) AS avg_rating
FROM RECIPE_INGREDIENTS ri1
JOIN RECIPE_INGREDIENTS ri2 ON ri1.recipe_id = ri2.recipe_id 
                             AND ri1.ingredient_id < ri2.ingredient_id
JOIN INGREDIENTS i1 ON ri1.ingredient_id = i1.ingredient_id
JOIN INGREDIENTS i2 ON ri2.ingredient_id = i2.ingredient_id
JOIN RECIPES r ON ri1.recipe_id = r.recipe_id
WHERE r.average_rating >= 4.0
GROUP BY i1.ingredient_name, i2.ingredient_name
ORDER BY pair_frequency DESC, avg_rating DESC
FETCH FIRST 20 ROWS ONLY;
```

## 5.2 插入操作（INSERT）

### 5.2.1 新用户注册

**19. 创建新用户**
```sql
INSERT INTO USERS (
    user_id, username, email, password_hash, 
    first_name, last_name, account_status
) VALUES (
    seq_users.NEXTVAL, 
    :username, 
    :email, 
    DBMS_CRYPTO.HASH(UTL_RAW.CAST_TO_RAW(:password), DBMS_CRYPTO.HASH_SH256),
    :first_name,
    :last_name,
    'active'
);
COMMIT;
```

### 5.2.2 发布新食谱

**20. 完整的食谱发布流程**
```sql
-- 步骤1：插入食谱基本信息
INSERT INTO RECIPES (
    recipe_id, user_id, recipe_name, description, cuisine_type, 
    meal_type, difficulty_level, prep_time, cook_time, total_time, 
    servings, calories_per_serving, is_published
) VALUES (
    seq_recipes.NEXTVAL, :user_id, :recipe_name, :description, :cuisine_type,
    :meal_type, :difficulty_level, :prep_time, :cook_time, 
    (:prep_time + :cook_time), :servings, :calories_per_serving, 'Y'
);

-- 步骤2：插入食材关联
INSERT INTO RECIPE_INGREDIENTS (
    recipe_ingredient_id, recipe_id, ingredient_id, unit_id, quantity, notes
) VALUES (
    seq_recipe_ingredients.NEXTVAL, :recipe_id, :ingredient_id, :unit_id, :quantity, :notes
);

-- 步骤3：插入烹饪步骤
INSERT INTO COOKING_STEPS (
    step_id, recipe_id, step_number, instruction, time_required
) VALUES (
    seq_cooking_steps.NEXTVAL, :recipe_id, :step_number, :instruction, :time_required
);

-- 步骤4：插入营养信息（可选）
INSERT INTO NUTRITION_INFO (
    nutrition_id, recipe_id, calories, protein_grams, carbs_grams, fat_grams
) VALUES (
    seq_nutrition_info.NEXTVAL, :recipe_id, :calories, :protein, :carbs, :fat
);

-- 步骤5：记录用户活动
INSERT INTO USER_ACTIVITY_LOG (
    activity_id, user_id, activity_type, activity_description, related_recipe_id
) VALUES (
    seq_user_activity_log.NEXTVAL, :user_id, 'recipe_published',
    '发布了食谱：' || :recipe_name, :recipe_id
);

-- 步骤6：更新用户食谱计数
UPDATE USERS SET total_recipes = total_recipes + 1 WHERE user_id = :user_id;

COMMIT;
```

### 5.2.3 用户交互操作

**21. 用户评价食谱**
```sql
INSERT INTO RATINGS (
    rating_id, user_id, recipe_id, rating_value, review_text
) VALUES (
    seq_ratings.NEXTVAL, :user_id, :recipe_id, :rating_value, :review_text
);

-- 更新食谱的平均评分
UPDATE RECIPES SET 
    average_rating = ROUND((SELECT AVG(rating_value) FROM RATINGS WHERE recipe_id = :recipe_id), 2),
    rating_count = (SELECT COUNT(*) FROM RATINGS WHERE recipe_id = :recipe_id),
    updated_at = SYSTIMESTAMP
WHERE recipe_id = :recipe_id;

-- 记录活动
INSERT INTO USER_ACTIVITY_LOG (activity_id, user_id, activity_type, activity_description, related_recipe_id)
VALUES (seq_user_activity_log.NEXTVAL, :user_id, 'recipe_rated', 
        '评价了食谱，评分：' || :rating_value, :recipe_id);

COMMIT;
```

**22. 用户收藏食谱**
```sql
INSERT INTO SAVED_RECIPES (
    saved_recipe_id, user_id, recipe_id
) VALUES (
    seq_saved_recipes.NEXTVAL, :user_id, :recipe_id
);

INSERT INTO USER_ACTIVITY_LOG (activity_id, user_id, activity_type, activity_description, related_recipe_id)
VALUES (seq_user_activity_log.NEXTVAL, :user_id, 'recipe_saved', '收藏了食谱', :recipe_id);

COMMIT;
```

**23. 用户评论食谱**
```sql
INSERT INTO COMMENTS (
    comment_id, recipe_id, user_id, parent_comment_id, comment_text
) VALUES (
    seq_comments.NEXTVAL, :recipe_id, :user_id, :parent_comment_id, :comment_text
);

INSERT INTO USER_ACTIVITY_LOG (activity_id, user_id, activity_type, activity_description, related_recipe_id)
VALUES (seq_user_activity_log.NEXTVAL, :user_id, 'comment_added', '评论了食谱', :recipe_id);

COMMIT;
```

**24. 用户关注其他用户**
```sql
INSERT INTO FOLLOWERS (
    follower_id, user_id, follower_user_id
) VALUES (
    seq_followers.NEXTVAL, :user_id_to_follow, :current_user_id
);

-- 更新被关注用户的粉丝数
UPDATE USERS SET total_followers = total_followers + 1 WHERE user_id = :user_id_to_follow;

INSERT INTO USER_ACTIVITY_LOG (activity_id, user_id, activity_type, activity_description)
VALUES (seq_user_activity_log.NEXTVAL, :current_user_id, 'user_followed', 
        '关注了用户');

COMMIT;
```

### 5.2.4 膳食计划和购物清单

**25. 创建膳食计划**
```sql
INSERT INTO MEAL_PLANS (
    plan_id, user_id, plan_name, description, start_date, end_date, is_public
) VALUES (
    seq_meal_plans.NEXTVAL, :user_id, :plan_name, :description, 
    :start_date, :end_date, :is_public
);

COMMIT;
```

**26. 为膳食计划添加食谱**
```sql
INSERT INTO MEAL_PLAN_ENTRIES (
    entry_id, plan_id, recipe_id, meal_date, meal_type, notes
) VALUES (
    seq_meal_plan_entries.NEXTVAL, :plan_id, :recipe_id, :meal_date, :meal_type, :notes
);

COMMIT;
```

**27. 创建购物清单**
```sql
-- 创建购物清单
INSERT INTO SHOPPING_LISTS (
    list_id, user_id, list_name
) VALUES (
    seq_shopping_lists.NEXTVAL, :user_id, :list_name
);

-- 自动添加膳食计划中的所有食材到购物清单
INSERT INTO SHOPPING_LIST_ITEMS (
    item_id, list_id, ingredient_id, quantity, unit_id
)
SELECT 
    seq_shopping_list_items.NEXTVAL,
    :list_id,
    i.ingredient_id,
    SUM(ri.quantity),
    u.unit_id
FROM MEAL_PLAN_ENTRIES mpe
JOIN RECIPES r ON mpe.recipe_id = r.recipe_id
JOIN RECIPE_INGREDIENTS ri ON r.recipe_id = ri.recipe_id
JOIN INGREDIENTS i ON ri.ingredient_id = i.ingredient_id
JOIN UNITS u ON ri.unit_id = u.unit_id
WHERE mpe.plan_id = :plan_id
GROUP BY i.ingredient_id, u.unit_id;

COMMIT;
```

## 5.3 更新操作（UPDATE）

### 5.3.1 编辑和状态管理

**28. 更新食谱信息**
```sql
UPDATE RECIPES SET 
    recipe_name = :new_name,
    description = :new_description,
    cuisine_type = :new_cuisine_type,
    difficulty_level = :new_difficulty,
    updated_at = SYSTIMESTAMP
WHERE recipe_id = :recipe_id
  AND user_id = :user_id;  -- 确保用户权限

UPDATE RECIPES SET view_count = view_count + 1 WHERE recipe_id = :recipe_id;

COMMIT;
```

**29. 逻辑删除食谱**
```sql
UPDATE RECIPES SET 
    is_deleted = 'Y',
    is_published = 'N',
    updated_at = SYSTIMESTAMP
WHERE recipe_id = :recipe_id
  AND user_id = :user_id;

COMMIT;
```

**30. 标记评论为已删除**
```sql
UPDATE COMMENTS SET 
    is_deleted = 'Y',
    updated_at = SYSTIMESTAMP
WHERE comment_id = :comment_id
  AND user_id = :user_id;

COMMIT;
```

### 5.3.2 用户管理

**31. 禁用用户账户**
```sql
UPDATE USERS SET 
    account_status = 'suspended'
WHERE user_id = :user_id;

-- （可选）同时删除该用户的所有食谱
UPDATE RECIPES SET 
    is_published = 'N',
    is_deleted = 'Y'
WHERE user_id = :user_id;

COMMIT;
```

**32. 取消用户关注**
```sql
DELETE FROM FOLLOWERS 
WHERE user_id = :user_id_to_unfollow 
  AND follower_user_id = :current_user_id;

-- 更新粉丝数
UPDATE USERS SET 
    total_followers = total_followers - 1 
WHERE user_id = :user_id_to_unfollow;

COMMIT;
```

**33. 标记购物清单项为已购买**
```sql
UPDATE SHOPPING_LIST_ITEMS SET 
    is_checked = 'Y'
WHERE item_id = :item_id;

COMMIT;
```

## 5.4 删除操作（DELETE）

### 5.4.1 清理和维护

**34. 删除用户的评价**
```sql
DELETE FROM RATINGS 
WHERE rating_id = :rating_id
  AND user_id = :user_id;

-- 重新计算食谱评分
UPDATE RECIPES SET 
    average_rating = NVL(ROUND((SELECT AVG(rating_value) FROM RATINGS WHERE recipe_id = :recipe_id), 2), 0),
    rating_count = NVL((SELECT COUNT(*) FROM RATINGS WHERE recipe_id = :recipe_id), 0),
    updated_at = SYSTIMESTAMP
WHERE recipe_id = :recipe_id;

COMMIT;
```

**35. 移除收藏的食谱**
```sql
DELETE FROM SAVED_RECIPES 
WHERE user_id = :user_id
  AND recipe_id = :recipe_id;

COMMIT;
```

**36. 清空购物清单**
```sql
DELETE FROM SHOPPING_LIST_ITEMS 
WHERE list_id = :list_id;

COMMIT;
```

### 5.4.2 投票管理

**37. 删除"有用"投票**
```sql
DELETE FROM RATING_HELPFULNESS 
WHERE rating_id = :rating_id
  AND user_id = :user_id;

DELETE FROM COMMENT_HELPFULNESS 
WHERE comment_id = :comment_id
  AND user_id = :user_id;

COMMIT;
```

## 5.5 添加"有用"投票

### 5.5.1 标记评价为有用

**38. 给评价点"有用"**
```sql
INSERT INTO RATING_HELPFULNESS (
    helpful_id, rating_id, user_id
) VALUES (
    seq_rating_helpfulness.NEXTVAL, :rating_id, :user_id
);

COMMIT;
```

**39. 给评论点"有用"**
```sql
INSERT INTO COMMENT_HELPFULNESS (
    helpful_id, comment_id, user_id
) VALUES (
    seq_comment_helpfulness.NEXTVAL, :comment_id, :user_id
);

COMMIT;
```

### 5.5.2 管理用户过敏原

**40. 添加用户过敏原**
```sql
INSERT INTO USER_ALLERGIES (
    user_allergy_id, user_id, allergen_id
) VALUES (
    seq_user_allergies.NEXTVAL, :user_id, :allergen_id
);

COMMIT;
```

**41. 移除用户过敏原**
```sql
DELETE FROM USER_ALLERGIES 
WHERE user_id = :user_id
  AND allergen_id = :allergen_id;

COMMIT;
```

---

# 第6章 完整性约束方案设计

完整性约束是数据库的守护者，确保数据的准确性、一致性和可靠性。

## 6.1 实体完整性

**定义**：每个表都有唯一的主键，确保记录的唯一性。

**实现**：
```sql
-- 主键约束示例
ALTER TABLE USERS ADD CONSTRAINT pk_users PRIMARY KEY (user_id);
ALTER TABLE RECIPES ADD CONSTRAINT pk_recipes PRIMARY KEY (recipe_id);
ALTER TABLE RATINGS ADD CONSTRAINT pk_ratings PRIMARY KEY (rating_id);
-- ... （所有表都有类似约束）
```

**验证**：
```sql
-- 插入重复主键时将失败
INSERT INTO USERS VALUES (1, 'user1', ...);
INSERT INTO USERS VALUES (1, 'user2', ...);  -- 错误：违反主键约束
```

## 6.2 参照完整性

**定义**：确保外键值在其参考表中存在。

**外键约束设计**：

```sql
-- 1. 食谱与用户的关系
ALTER TABLE RECIPES ADD CONSTRAINT fk_recipes_user 
FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE;
-- ON DELETE CASCADE: 删除用户时，其食谱也被删除

-- 2. 食谱食材的关系
ALTER TABLE RECIPE_INGREDIENTS ADD CONSTRAINT fk_ri_recipe 
FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE CASCADE;

ALTER TABLE RECIPE_INGREDIENTS ADD CONSTRAINT fk_ri_ingredient 
FOREIGN KEY (ingredient_id) REFERENCES INGREDIENTS(ingredient_id);
-- 食材本身不会被删除，只是解除关系

-- 3. 评价与用户、食谱的关系
ALTER TABLE RATINGS ADD CONSTRAINT fk_rating_user 
FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE;

ALTER TABLE RATINGS ADD CONSTRAINT fk_rating_recipe 
FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE CASCADE;

-- 4. 评论与其父评论的自引用关系
ALTER TABLE COMMENTS ADD CONSTRAINT fk_comment_parent 
FOREIGN KEY (parent_comment_id) REFERENCES COMMENTS(comment_id) ON DELETE SET NULL;
-- ON DELETE SET NULL: 删除父评论时，子评论的parent_comment_id设置为NULL

-- 5. 膳食计划条目
ALTER TABLE MEAL_PLAN_ENTRIES ADD CONSTRAINT fk_mpe_plan 
FOREIGN KEY (plan_id) REFERENCES MEAL_PLANS(plan_id) ON DELETE CASCADE;

-- 6. 有用性投票跟踪
ALTER TABLE RATING_HELPFULNESS ADD CONSTRAINT fk_rh_rating 
FOREIGN KEY (rating_id) REFERENCES RATINGS(rating_id) ON DELETE CASCADE;
```

**级联操作说明**：

| 操作 | 说明 | 适用场景 |
|------|------|---------|
| ON DELETE CASCADE | 自动删除相关记录 | 用户删除时级联删除其食谱 |
| ON DELETE SET NULL | 设置外键为NULL | 父评论删除时，子评论的parent_id为NULL |
| ON DELETE RESTRICT | 拒绝删除操作 | 食材仍被使用时拒绝删除 |
| ON UPDATE CASCADE | 自动更新相关记录 | 用户ID变更时级联更新（较少使用） |

## 6.3 唯一性约束

**定义**：确保字段值的唯一性，防止重复数据。

```sql
-- 用户表
ALTER TABLE USERS ADD CONSTRAINT uk_username UNIQUE (username);
ALTER TABLE USERS ADD CONSTRAINT uk_email UNIQUE (email);

-- 食材表
ALTER TABLE INGREDIENTS ADD CONSTRAINT uk_ingredient_name UNIQUE (ingredient_name);

-- 复合唯一约束：确保每个用户只能评价一次某个食谱
ALTER TABLE RATINGS ADD CONSTRAINT uk_user_recipe_rating 
UNIQUE (user_id, recipe_id);

-- 复合唯一约束：确保每个用户只能关注一次另一个用户
ALTER TABLE FOLLOWERS ADD CONSTRAINT uk_follower 
UNIQUE (user_id, follower_user_id);

-- 确保食谱中每个食材只出现一次
ALTER TABLE RECIPE_INGREDIENTS ADD CONSTRAINT uk_recipe_ingredient 
UNIQUE (recipe_id, ingredient_id);

-- 确保烹饪步骤的序号唯一
ALTER TABLE COOKING_STEPS ADD CONSTRAINT uk_recipe_step 
UNIQUE (recipe_id, step_number);

-- 有用性投票：确保每个用户只能点"有用"一次
ALTER TABLE RATING_HELPFULNESS ADD CONSTRAINT uk_rating_helpful_vote 
UNIQUE (rating_id, user_id);

ALTER TABLE COMMENT_HELPFULNESS ADD CONSTRAINT uk_comment_helpful_vote 
UNIQUE (comment_id, user_id);
```

## 6.4 检查约束

**定义**：确保字段值符合业务规则。

```sql
-- 1. 账户状态限制
ALTER TABLE USERS ADD CONSTRAINT ck_account_status 
CHECK (account_status IN ('active', 'inactive', 'suspended'));

-- 2. 用户类型 (可扩展为 '普通用户', '专业厨师', '美食博主')
ALTER TABLE USERS ADD CONSTRAINT ck_user_type 
CHECK (user_type IN ('普通用户', '专业厨师', '美食博主'));

-- 3. 餐次限制
ALTER TABLE RECIPES ADD CONSTRAINT ck_meal_type 
CHECK (meal_type IN ('breakfast', 'lunch', 'dinner', 'snack', 'dessert'));

-- 4. 难度等级限制
ALTER TABLE RECIPES ADD CONSTRAINT ck_difficulty_level 
CHECK (difficulty_level IN ('easy', 'medium', 'hard'));

-- 5. 发布状态
ALTER TABLE RECIPES ADD CONSTRAINT ck_is_published 
CHECK (is_published IN ('Y', 'N'));

-- 6. 逻辑删除标记
ALTER TABLE RECIPES ADD CONSTRAINT ck_is_deleted 
CHECK (is_deleted IN ('Y', 'N'));

-- 7. 评分值范围
ALTER TABLE RATINGS ADD CONSTRAINT ck_rating_value 
CHECK (rating_value >= 0 AND rating_value <= 5);

-- 8. 不能自己关注自己
ALTER TABLE FOLLOWERS ADD CONSTRAINT ck_not_self_follow 
CHECK (user_id != follower_user_id);

-- 9. 烹饪时间必须为正数
ALTER TABLE RECIPES ADD CONSTRAINT ck_cook_time 
CHECK (cook_time > 0);

-- 10. 食材替代比例合理范围
ALTER TABLE INGREDIENT_SUBSTITUTIONS ADD CONSTRAINT ck_ratio 
CHECK (ratio > 0 AND ratio <= 5);

-- 11. 膳食计划日期顺序
ALTER TABLE MEAL_PLANS ADD CONSTRAINT ck_meal_plan_dates 
CHECK (start_date <= end_date);

-- 12. 购物清单项检查
ALTER TABLE SHOPPING_LIST_ITEMS ADD CONSTRAINT ck_is_checked 
CHECK (is_checked IN ('Y', 'N'));

-- 13. 收藏清单公开状态
ALTER TABLE RECIPE_COLLECTIONS ADD CONSTRAINT ck_is_public 
CHECK (is_public IN ('Y', 'N'));
```

## 6.5 默认值约束

**定义**：为字段设置默认值，简化插入操作。

```sql
-- 时间戳自动设置
ALTER TABLE USERS MODIFY created_at DEFAULT SYSTIMESTAMP;
ALTER TABLE RECIPES MODIFY created_at DEFAULT SYSTIMESTAMP;
ALTER TABLE RATINGS MODIFY rating_date DEFAULT SYSTIMESTAMP;
ALTER TABLE COMMENTS MODIFY created_at DEFAULT SYSTIMESTAMP;

-- 状态默认值
ALTER TABLE USERS MODIFY account_status DEFAULT 'active';
ALTER TABLE RECIPES MODIFY is_published DEFAULT 'Y';
ALTER TABLE RECIPES MODIFY is_deleted DEFAULT 'N';
ALTER TABLE SHOPPING_LIST_ITEMS MODIFY is_checked DEFAULT 'N';
ALTER TABLE RECIPE_COLLECTIONS MODIFY is_public DEFAULT 'Y';

-- 计数器初始值
ALTER TABLE RECIPES MODIFY view_count DEFAULT 0;
ALTER TABLE RECIPES MODIFY rating_count DEFAULT 0;
ALTER TABLE RECIPES MODIFY average_rating DEFAULT 0;

-- 食材替代比例默认
ALTER TABLE INGREDIENT_SUBSTITUTIONS MODIFY ratio DEFAULT 1.0;
```

## 6.6 约束冲突解决

当发生约束冲突时的处理策略：

| 约束类型 | 冲突场景 | 解决方案 |
|---------|---------|---------|
| PRIMARY KEY | 重复主键 | 使用序列自动生成唯一值 |
| UNIQUE | 重复唯一值 | 检查已有值，选择新值 |
| FOREIGN KEY | 孤立记录 | 级联删除或设置NULL |
| CHECK | 违反业务规则 | 输入验证 + 数据库约束双重防护 |
| NOT NULL | 缺失必要数据 | 应用层强制输入 |

---

# 第7章 表的详细设计（物理模型）

物理模型是逻辑模型在实际数据库中的实现，涉及数据类型、存储、索引等物理特性。

## 7.1 核心表的物理模型详细定义

### 表1-6：基础数据表

在 `createtable_v2.sql` 中已详细定义。

### 表7-12：食谱核心表

详见SQL脚本。

### 表13-19：用户交互表

详见SQL脚本。

### 表20-26：个人管理与新增表

详见SQL脚本。

## 7.2 索引设计

**索引目标**：加速常见查询，改善性能。

```sql
-- ==================== 用户表索引 ====================
CREATE INDEX idx_users_email ON USERS(email);              -- 登录查询
CREATE INDEX idx_users_username ON USERS(username);        -- 用户搜索
CREATE INDEX idx_users_join_date ON USERS(join_date);      -- 统计分析

-- ==================== 食谱表索引 ====================
CREATE INDEX idx_recipes_user_id ON RECIPES(user_id);                    -- 查询用户食谱
CREATE INDEX idx_recipes_cuisine_type ON RECIPES(cuisine_type);          -- 按菜系搜索
CREATE INDEX idx_recipes_meal_type ON RECIPES(meal_type);                -- 按餐次搜索
CREATE INDEX idx_recipes_created_at ON RECIPES(created_at);              -- 时间排序
CREATE INDEX idx_recipes_average_rating ON RECIPES(average_rating);      -- 评分排序
CREATE INDEX idx_recipes_is_published ON RECIPES(is_published);          -- 发布状态过滤

-- 复合索引：常见查询组合
CREATE INDEX idx_recipes_published_rating ON RECIPES(is_published, average_rating DESC);

-- ==================== 食材相关表索引 ====================
CREATE INDEX idx_ri_recipe_id ON RECIPE_INGREDIENTS(recipe_id);          -- 查询食谱食材
CREATE INDEX idx_ri_ingredient_id ON RECIPE_INGREDIENTS(ingredient_id);  -- 查询食材所在食谱

-- ==================== 评分和评论索引 ====================
CREATE INDEX idx_ratings_recipe_id ON RATINGS(recipe_id);                -- 查询食谱评分
CREATE INDEX idx_ratings_user_id ON RATINGS(user_id);                    -- 查询用户评分
CREATE INDEX idx_ratings_date ON RATINGS(rating_date);                   -- 时间排序

CREATE INDEX idx_comments_recipe_id ON COMMENTS(recipe_id);              -- 查询食谱评论
CREATE INDEX idx_comments_user_id ON COMMENTS(user_id);                  -- 查询用户评论
CREATE INDEX idx_comments_created_at ON COMMENTS(created_at);            -- 时间排序

-- ==================== 社交关系索引 ====================
CREATE INDEX idx_followers_user_id ON FOLLOWERS(user_id);                -- 查询用户粉丝
CREATE INDEX idx_followers_follower_user_id ON FOLLOWERS(follower_user_id); -- 查询关注列表

-- ==================== 个人管理索引 ====================
CREATE INDEX idx_sl_user_id ON SHOPPING_LISTS(user_id);                  -- 查询用户购物清单
CREATE INDEX idx_sli_list_id ON SHOPPING_LIST_ITEMS(list_id);            -- 查询清单项
CREATE INDEX idx_saved_recipes_user ON SAVED_RECIPES(user_id);           -- 查询用户收藏

-- ==================== 活动日志索引 ====================
CREATE INDEX idx_al_user_id ON USER_ACTIVITY_LOG(user_id);               -- 查询用户活动
CREATE INDEX idx_al_timestamp ON USER_ACTIVITY_LOG(activity_timestamp);  -- 时间范围查询

-- ==================== 新增表索引 ====================
CREATE INDEX idx_mp_user_id ON MEAL_PLANS(user_id);                      -- 查询膳食计划
CREATE INDEX idx_mpe_plan_id ON MEAL_PLAN_ENTRIES(plan_id);              -- 查询计划条目
CREATE INDEX idx_mpe_meal_date ON MEAL_PLAN_ENTRIES(meal_date);          -- 按日期查询

CREATE INDEX idx_sub_original ON INGREDIENT_SUBSTITUTIONS(original_ingredient_id);  -- 查询替代品
CREATE INDEX idx_sub_status ON INGREDIENT_SUBSTITUTIONS(approval_status);           -- 按批准状态查询

CREATE INDEX idx_rh_rating_id ON RATING_HELPFULNESS(rating_id);          -- 查询评分投票
CREATE INDEX idx_rh_user_id ON RATING_HELPFULNESS(user_id);              -- 查询用户投票

CREATE INDEX idx_ch_comment_id ON COMMENT_HELPFULNESS(comment_id);       -- 查询评论投票
CREATE INDEX idx_ch_user_id ON COMMENT_HELPFULNESS(user_id);             -- 查询用户投票

CREATE INDEX idx_ua_user_id ON USER_ALLERGIES(user_id);                  -- 查询用户过敏原
CREATE INDEX idx_ua_allergen_id ON USER_ALLERGIES(allergen_id);          -- 查询哪些用户过敏
```

## 7.3 数据类型选择

| 字段类型 | Oracle数据类型 | 字节数 | 选择理由 |
|---------|---------------|-------|--------|
| ID字段 | NUMBER(10) | 4-8 | 足以表示十亿级数据 |
| 用户名 | VARCHAR2(50) | 可变 | 足够长的用户名 |
| 邮箱 | VARCHAR2(100) | 可变 | RFC标准邮箱最长254字符 |
| 密码哈希 | VARCHAR2(255) | 可变 | SHA256哈希输出64字符 |
| 时间戳 | TIMESTAMP | 7字节 | 精确到纳秒级 |
| 时间 | DATE | 7字节 | 足以表示日期 |
| 浮点数 | NUMBER(3,2) | 可变 | 评分0-5.00，精确到两位小数 |
| 计数器 | NUMBER(10) | 4-8 | 支持十亿级计数 |
| 布尔值 | VARCHAR2(1) | 1字节 | 存储'Y'/'N' |
| 文本 | VARCHAR2(n) | 可变 | 可变长文本存储 |

## 7.4 分区设计（针对大表）

对于生产环境中的大表，可考虑按时间分区以提升性能：

```sql
-- 按月份分区RECIPES表（可选优化）
CREATE TABLE RECIPES (
    -- 列定义...
)
PARTITION BY RANGE (TRUNC(created_at, 'MM')) (
    PARTITION p_202301 VALUES LESS THAN (TO_DATE('2023-02-01', 'YYYY-MM-DD')),
    PARTITION p_202302 VALUES LESS THAN (TO_DATE('2023-03-01', 'YYYY-MM-DD')),
    -- ... 更多分区
    PARTITION p_max VALUES LESS THAN (MAXVALUE)
);
```

---

# 第8章 视图设计方案

视图是一种虚拟表，基于一个或多个实际表的查询结果。视图可以简化复杂查询、提供数据安全层、优化性能。

## 8.1 用户相关视图

### 视图1：USER_OVERVIEW（用户概览视图）
```sql
CREATE OR REPLACE VIEW USER_OVERVIEW AS
SELECT 
    u.user_id,
    u.username,
    u.first_name,
    u.last_name,
    u.profile_image,
    u.bio,
    u.join_date,
    u.account_status,
    COUNT(DISTINCT r.recipe_id) AS recipe_count,
    COUNT(DISTINCT f.follower_user_id) AS follower_count,
    COUNT(DISTINCT f2.user_id) AS following_count,
    ROUND(AVG(rt.rating_value), 2) AS avg_recipe_rating
FROM USERS u
LEFT JOIN RECIPES r ON u.user_id = r.user_id AND r.is_deleted = 'N'
LEFT JOIN FOLLOWERS f ON u.user_id = f.user_id
LEFT JOIN FOLLOWERS f2 ON u.user_id = f2.follower_user_id
LEFT JOIN RATINGS rt ON r.recipe_id = rt.recipe_id
GROUP BY u.user_id, u.username, u.first_name, u.last_name, u.profile_image, 
         u.bio, u.join_date, u.account_status;
```

**用途**：在用户个人资料页面显示用户统计信息（食谱数、粉丝数、关注数、平均评分）。

### 视图2：ACTIVE_USERS（活跃用户视图）
```sql
CREATE OR REPLACE VIEW ACTIVE_USERS AS
SELECT 
    u.user_id,
    u.username,
    u.email,
    u.account_status,
    u.last_login,
    COUNT(DISTINCT CASE WHEN r.created_at > SYSDATE - 7 THEN r.recipe_id END) AS recipes_this_week,
    COUNT(DISTINCT CASE WHEN rt.rating_date > SYSDATE - 7 THEN rt.rating_id END) AS ratings_this_week,
    COUNT(DISTINCT CASE WHEN c.created_at > SYSDATE - 7 THEN c.comment_id END) AS comments_this_week
FROM USERS u
LEFT JOIN RECIPES r ON u.user_id = r.user_id
LEFT JOIN RATINGS rt ON u.user_id = rt.user_id
LEFT JOIN COMMENTS c ON u.user_id = c.user_id
WHERE u.account_status = 'active'
GROUP BY u.user_id, u.username, u.email, u.account_status, u.last_login
HAVING COUNT(DISTINCT r.recipe_id) + COUNT(DISTINCT rt.rating_id) + COUNT(DISTINCT c.comment_id) > 0;
```

**用途**：识别活跃用户，用于社区分析、推荐和激励。

### 视图3：USER_CONTRIBUTION_SCORE（用户贡献评分视图）
```sql
CREATE OR REPLACE VIEW USER_CONTRIBUTION_SCORE AS
SELECT 
    u.user_id,
    u.username,
    u.total_recipes,
    u.total_followers,
    COUNT(DISTINCT rt.rating_id) AS ratings_given,
    COUNT(DISTINCT c.comment_id) AS comments_given,
    SUM(rh.helpful_votes) AS helpful_votes_received,
    ROUND(
        u.total_recipes * 100 +           -- 每个食谱 100分
        u.total_followers * 50 +          -- 每个粉丝 50分
        COUNT(DISTINCT rt.rating_id) * 10 +  -- 每个评分 10分
        COUNT(DISTINCT c.comment_id) * 5 +   -- 每个评论 5分
        COALESCE(SUM(rh.helpful_votes), 0) * 2  -- 每个有用投票 2分
    ) AS total_contribution_score
FROM USERS u
LEFT JOIN RATINGS rt ON u.user_id = rt.user_id
LEFT JOIN COMMENTS c ON u.user_id = c.user_id
LEFT JOIN (
    SELECT user_id, COUNT(*) AS helpful_votes
    FROM RATING_HELPFULNESS
    GROUP BY user_id
) rh ON u.user_id = rh.user_id
WHERE u.account_status = 'active'
GROUP BY u.user_id, u.username, u.total_recipes, u.total_followers;
```

**用途**：计算用户的社区贡献度，用于排行榜、徽章系统等。

## 8.2 食谱相关视图

### 视图4：RECIPE_DETAIL（食谱详情视图）
```sql
CREATE OR REPLACE VIEW RECIPE_DETAIL AS
SELECT 
    r.recipe_id,
    r.recipe_name,
    r.description,
    r.cuisine_type,
    r.meal_type,
    r.difficulty_level,
    r.prep_time,
    r.cook_time,
    r.total_time,
    r.servings,
    r.image_url,
    r.average_rating,
    r.rating_count,
    r.view_count,
    u.user_id AS creator_id,
    u.username AS creator_name,
    u.profile_image AS creator_avatar,
    ni.calories,
    ni.protein_grams,
    ni.carbs_grams,
    ni.fat_grams,
    ni.fiber_grams,
    ni.sugar_grams,
    ni.sodium_mg,
    r.created_at,
    r.updated_at
FROM RECIPES r
JOIN USERS u ON r.user_id = u.user_id
LEFT JOIN NUTRITION_INFO ni ON r.recipe_id = ni.recipe_id
WHERE r.is_published = 'Y' 
  AND r.is_deleted = 'N';
```

**用途**：显示食谱详情页，包含所有基本信息和创作者信息。

### 视图5：POPULAR_RECIPES（热门食谱视图）
```sql
CREATE OR REPLACE VIEW POPULAR_RECIPES AS
SELECT 
    r.recipe_id,
    r.recipe_name,
    r.cuisine_type,
    r.average_rating,
    r.rating_count,
    r.view_count,
    u.username,
    ROUND(
        r.average_rating * 0.5 +              -- 评分权重 50%
        LEAST(r.rating_count / 100.0, 5) * 0.3 +  -- 评价数权重 30%
        LEAST(r.view_count / 10000.0, 5) * 0.2    -- 浏览数权重 20%
    , 2) AS popularity_score
FROM RECIPES r
JOIN USERS u ON r.user_id = u.user_id
WHERE r.is_published = 'Y' 
  AND r.is_deleted = 'N'
  AND r.created_at > SYSDATE - 180  -- 过去6个月
ORDER BY popularity_score DESC;
```

**用途**：显示热门食谱推荐列表。

### 视图6：RECIPE_WITH_INGREDIENTS（食材详情视图）
```sql
CREATE OR REPLACE VIEW RECIPE_WITH_INGREDIENTS AS
SELECT 
    r.recipe_id,
    r.recipe_name,
    r.servings,
    ri.ingredient_id,
    i.ingredient_name,
    i.category AS ingredient_category,
    ri.quantity,
    u.unit_name,
    u.abbreviation,
    ri.notes,
    STRING_AGG(ia.allergen_name, ', ') AS allergens
FROM RECIPES r
JOIN RECIPE_INGREDIENTS ri ON r.recipe_id = ri.recipe_id
JOIN INGREDIENTS i ON ri.ingredient_id = i.ingredient_id
JOIN UNITS u ON ri.unit_id = u.unit_id
LEFT JOIN INGREDIENT_ALLERGENS ia ON i.ingredient_id = ia.ingredient_id
LEFT JOIN ALLERGENS al ON ia.allergen_id = al.allergen_id
WHERE r.is_deleted = 'N'
GROUP BY r.recipe_id, r.recipe_name, r.servings, ri.ingredient_id, 
         i.ingredient_name, i.category, ri.quantity, u.unit_name, 
         u.abbreviation, ri.notes;
```

**用途**：显示食谱的完整食材列表，包括过敏原信息。

### 视图7：RECIPE_WITH_STEPS（烹饪步骤视图）
```sql
CREATE OR REPLACE VIEW RECIPE_WITH_STEPS AS
SELECT 
    r.recipe_id,
    r.recipe_name,
    cs.step_number,
    cs.instruction,
    cs.time_required,
    cs.image_url,
    LAG(cs.step_number) OVER (PARTITION BY r.recipe_id ORDER BY cs.step_number) AS previous_step,
    LEAD(cs.step_number) OVER (PARTITION BY r.recipe_id ORDER BY cs.step_number) AS next_step
FROM RECIPES r
LEFT JOIN COOKING_STEPS cs ON r.recipe_id = cs.recipe_id
WHERE r.is_deleted = 'N'
ORDER BY r.recipe_id, cs.step_number;
```

**用途**：显示食谱的烹饪步骤，支持步骤间导航。

## 8.3 社交和互动视图

### 视图8：USER_NETWORK（社交网络视图）
```sql
CREATE OR REPLACE VIEW USER_NETWORK AS
SELECT 
    u.user_id,
    u.username,
    u.profile_image,
    COUNT(DISTINCT f.follower_user_id) AS follower_count,
    COUNT(DISTINCT f2.user_id) AS following_count,
    COUNT(DISTINCT sr.saved_recipe_id) AS saved_recipes_count,
    COUNT(DISTINCT rt.rating_id) AS reviews_count,
    COUNT(DISTINCT c.comment_id) AS comments_count
FROM USERS u
LEFT JOIN FOLLOWERS f ON u.user_id = f.user_id
LEFT JOIN FOLLOWERS f2 ON u.user_id = f2.follower_user_id
LEFT JOIN SAVED_RECIPES sr ON u.user_id = sr.user_id
LEFT JOIN RATINGS rt ON u.user_id = rt.user_id
LEFT JOIN COMMENTS c ON u.user_id = c.user_id
WHERE u.account_status = 'active'
GROUP BY u.user_id, u.username, u.profile_image;
```

**用途**：展示用户的社交网络信息。

### 视图9：USER_FEED（用户动态流视图）
```sql
CREATE OR REPLACE VIEW USER_FEED AS
SELECT 
    f.follower_user_id AS feed_for_user,
    ual.user_id AS actor_user_id,
    u.username AS actor_username,
    u.profile_image,
    ual.activity_type,
    ual.activity_description,
    r.recipe_id,
    r.recipe_name,
    ual.activity_timestamp
FROM USER_ACTIVITY_LOG ual
JOIN FOLLOWERS f ON ual.user_id = f.user_id
JOIN USERS u ON ual.user_id = u.user_id
LEFT JOIN RECIPES r ON ual.related_recipe_id = r.recipe_id
WHERE ual.activity_timestamp > SYSDATE - 30
  AND ual.activity_type IN ('recipe_published', 'recipe_rated', 'comment_added')
  AND u.account_status = 'active';
```

**用途**：为用户生成关注者的活动动态流，类似社交媒体。

### 视图10：TOP_CONTRIBUTORS（顶级贡献者视图）
```sql
CREATE OR REPLACE VIEW TOP_CONTRIBUTORS AS
SELECT 
    u.user_id,
    u.username,
    u.profile_image,
    u.total_recipes,
    u.total_followers,
    COUNT(DISTINCT rt.rating_id) AS total_ratings,
    COUNT(DISTINCT c.comment_id) AS total_comments,
    SUM(CASE WHEN rt.rating_value >= 4.5 THEN 1 ELSE 0 END) AS high_rated_recipes,
    RANK() OVER (ORDER BY u.total_recipes DESC, u.total_followers DESC) AS rank
FROM USERS u
LEFT JOIN RATINGS rt ON u.user_id = rt.user_id
LEFT JOIN COMMENTS c ON u.user_id = c.user_id
WHERE u.account_status = 'active'
GROUP BY u.user_id, u.username, u.profile_image, u.total_recipes, u.total_followers
ORDER BY rank
FETCH FIRST 100 ROWS ONLY;
```

**用途**：显示社区贡献者排行榜。

## 8.4 健康与过敏相关视图

### 视图11：INGREDIENT_HEALTH_PROFILE（食材健康档案视图）
```sql
CREATE OR REPLACE VIEW INGREDIENT_HEALTH_PROFILE AS
SELECT 
    i.ingredient_id,
    i.ingredient_name,
    i.category,
    i.description,
    STRING_AGG(DISTINCT a.allergen_name, ', ') AS contains_allergens,
    COUNT(DISTINCT ris.recipe_id) AS used_in_recipes,
    ROUND(AVG(r.average_rating), 2) AS avg_recipe_rating
FROM INGREDIENTS i
LEFT JOIN INGREDIENT_ALLERGENS ia ON i.ingredient_id = ia.ingredient_id
LEFT JOIN ALLERGENS a ON ia.allergen_id = a.allergen_id
LEFT JOIN RECIPE_INGREDIENTS ris ON i.ingredient_id = ris.ingredient_id
LEFT JOIN RECIPES r ON ris.recipe_id = r.recipe_id
GROUP BY i.ingredient_id, i.ingredient_name, i.category, i.description;
```

**用途**：显示食材的健康信息和过敏原。

### 视图12：SAFE_RECIPES_FOR_USER（用户安全食谱视图）
```sql
CREATE OR REPLACE VIEW SAFE_RECIPES_FOR_USER AS
SELECT 
    u.user_id,
    r.recipe_id,
    r.recipe_name,
    r.average_rating,
    STRING_AGG(t.tag_name, ', ') AS tags
FROM USERS u
CROSS JOIN RECIPES r
LEFT JOIN RECIPE_TAGS rt ON r.recipe_id = rt.recipe_id
LEFT JOIN TAGS t ON rt.tag_id = t.tag_id
WHERE r.is_published = 'Y'
  AND r.is_deleted = 'N'
  AND NOT EXISTS (
      SELECT 1
      FROM RECIPE_INGREDIENTS ri
      JOIN INGREDIENT_ALLERGENS ia ON ri.ingredient_id = ia.ingredient_id
      JOIN USER_ALLERGIES ua ON ia.allergen_id = ua.allergen_id
      WHERE ri.recipe_id = r.recipe_id
        AND ua.user_id = u.user_id
  )
GROUP BY u.user_id, r.recipe_id, r.recipe_name, r.average_rating;
```

**用途**：为每个用户显示不含其过敏原的安全食谱。

## 8.5 规划和购物相关视图

### 视图13：MEAL_PLAN_SUMMARY（膳食计划摘要视图）
```sql
CREATE OR REPLACE VIEW MEAL_PLAN_SUMMARY AS
SELECT 
    mp.plan_id,
    mp.user_id,
    u.username,
    mp.plan_name,
    mp.start_date,
    mp.end_date,
    COUNT(DISTINCT mpe.entry_id) AS total_entries,
    COUNT(DISTINCT mpe.recipe_id) AS unique_recipes,
    ROUND(AVG(r.average_rating), 2) AS avg_recipe_rating,
    TRUNC(DATEDIFF(DAY, mp.start_date, mp.end_date)) AS plan_duration_days
FROM MEAL_PLANS mp
LEFT JOIN MEAL_PLAN_ENTRIES mpe ON mp.plan_id = mpe.plan_id
LEFT JOIN RECIPES r ON mpe.recipe_id = r.recipe_id
LEFT JOIN USERS u ON mp.user_id = u.user_id
GROUP BY mp.plan_id, mp.user_id, u.username, mp.plan_name, mp.start_date, mp.end_date;
```

**用途**：显示膳食计划的摘要统计。

### 视图14：CONSOLIDATED_SHOPPING_LIST（整合购物清单视图）
```sql
CREATE OR REPLACE VIEW CONSOLIDATED_SHOPPING_LIST AS
SELECT 
    mp.plan_id,
    i.ingredient_id,
    i.ingredient_name,
    i.category,
    SUM(ri.quantity) AS total_quantity,
    u.unit_name,
    COUNT(DISTINCT mpe.recipe_id) AS recipe_count,
    STRING_AGG(DISTINCT r.recipe_name, '; ') AS recipes
FROM MEAL_PLAN_ENTRIES mpe
JOIN RECIPES r ON mpe.recipe_id = r.recipe_id
JOIN RECIPE_INGREDIENTS ri ON r.recipe_id = ri.recipe_id
JOIN INGREDIENTS i ON ri.ingredient_id = i.ingredient_id
JOIN UNITS u ON ri.unit_id = u.unit_id
LEFT JOIN MEAL_PLANS mp ON mpe.plan_id = mp.plan_id
GROUP BY mp.plan_id, i.ingredient_id, i.ingredient_name, i.category, u.unit_name
ORDER BY i.ingredient_name;
```

**用途**：为膳食计划自动生成整合的购物清单。

## 8.6 分析和报表视图

### 视图15：RECIPE_QUALITY_METRICS（食谱质量指标视图）
```sql
CREATE OR REPLACE VIEW RECIPE_QUALITY_METRICS AS
SELECT 
    r.recipe_id,
    r.recipe_name,
    u.username,
    r.average_rating,
    r.rating_count,
    r.view_count,
    COUNT(DISTINCT c.comment_id) AS comment_count,
    COUNT(DISTINCT cs.step_id) AS step_count,
    COUNT(DISTINCT ri.ingredient_id) AS ingredient_count,
    CASE 
        WHEN r.average_rating >= 4.5 AND r.rating_count >= 10 THEN '★★★★★'
        WHEN r.average_rating >= 4.0 AND r.rating_count >= 5 THEN '★★★★'
        WHEN r.average_rating >= 3.5 THEN '★★★'
        ELSE '★'
    END AS quality_rating,
    ROUND(r.average_rating * 0.5 + LEAST(r.rating_count / 100.0, 1) * 0.3 + 
          LEAST(r.view_count / 10000.0, 1) * 0.2, 2) AS quality_score
FROM RECIPES r
JOIN USERS u ON r.user_id = u.user_id
LEFT JOIN COMMENTS c ON r.recipe_id = c.recipe_id
LEFT JOIN COOKING_STEPS cs ON r.recipe_id = cs.recipe_id
LEFT JOIN RECIPE_INGREDIENTS ri ON r.recipe_id = ri.recipe_id
WHERE r.is_published = 'Y'
  AND r.is_deleted = 'N'
GROUP BY r.recipe_id, r.recipe_name, u.username, r.average_rating, 
         r.rating_count, r.view_count;
```

**用途**：评估食谱质量，用于推荐和展示。

### 视图16：MONTHLY_STATISTICS（月度统计视图）
```sql
CREATE OR REPLACE VIEW MONTHLY_STATISTICS AS
SELECT 
    TRUNC(r.created_at, 'MM') AS month,
    COUNT(DISTINCT r.recipe_id) AS new_recipes,
    COUNT(DISTINCT r.user_id) AS active_creators,
    COUNT(DISTINCT rt.rating_id) AS total_ratings,
    COUNT(DISTINCT c.comment_id) AS total_comments,
    ROUND(AVG(r.average_rating), 2) AS avg_rating
FROM RECIPES r
LEFT JOIN RATINGS rt ON r.created_at = TRUNC(rt.rating_date, 'MM')
LEFT JOIN COMMENTS c ON r.created_at = TRUNC(c.created_at, 'MM')
WHERE r.is_deleted = 'N'
GROUP BY TRUNC(r.created_at, 'MM')
ORDER BY month DESC;
```

**用途**：提供月度运营统计数据。

---

# 第9章 数据库安全方案设计

数据库安全是多层次的防御体系，涵盖用户认证、权限控制、数据加密、审计日志等多个方面。

## 9.1 用户认证和权限管理

### 9.1.1 数据库用户角色划分

```sql
-- 创建不同权限等级的数据库用户

-- 1. 应用用户（APP_USER）：生产应用使用
CREATE USER app_user IDENTIFIED BY "SecureP@ss123";
GRANT CONNECT, RESOURCE TO app_user;

-- 2. 只读报表用户（REPORT_USER）：用于报表和分析
CREATE USER report_user IDENTIFIED BY "ReportP@ss456";
GRANT CONNECT TO report_user;

-- 3. 数据库管理员（DBA_ADMIN）：DBA使用
CREATE USER dba_admin IDENTIFIED BY "AdminP@ss789";
GRANT DBA TO dba_admin;

-- 4. 备份用户（BACKUP_USER）：备份和恢复
CREATE USER backup_user IDENTIFIED BY "BackupP@ss000";
GRANT CREATE SESSION, EXPORT_FULL_DATABASE TO backup_user;

-- 5. 审计用户（AUDIT_USER）：审计日志查看
CREATE USER audit_user IDENTIFIED BY "AuditP@ss111";
GRANT CONNECT TO audit_user;
```

### 9.1.2 精细化权限分配

```sql
-- 为APP_USER分配表级权限
GRANT SELECT, INSERT, UPDATE, DELETE ON USERS TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON RECIPES TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON RATINGS TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON COMMENTS TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON FOLLOWERS TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON SAVED_RECIPES TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON SHOPPING_LISTS TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON SHOPPING_LIST_ITEMS TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON MEAL_PLANS TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON MEAL_PLAN_ENTRIES TO app_user;

-- 只读权限
GRANT SELECT ON INGREDIENTS TO app_user;
GRANT SELECT ON UNITS TO app_user;
GRANT SELECT ON TAGS TO app_user;
GRANT SELECT ON ALLERGENS TO app_user;

-- 为REPORT_USER分配只读权限
GRANT SELECT ON RECIPES TO report_user;
GRANT SELECT ON USERS TO report_user;
GRANT SELECT ON RATINGS TO report_user;
GRANT SELECT ON COMMENTS TO report_user;
GRANT SELECT ON FOLLOWERS TO report_user;
GRANT SELECT ON ALL VIEWS TO report_user;

-- 执行存储过程权限
GRANT EXECUTE ON publish_recipe TO app_user;
GRANT EXECUTE ON rate_recipe TO app_user;
GRANT EXECUTE ON save_recipe TO app_user;
```

### 9.1.3 列级安全（Column-Level Security）

```sql
-- 限制某些用户无法看到密码哈希
GRANT SELECT(user_id, username, email, first_name, last_name, profile_image) 
ON USERS TO report_user;

-- 管理员可以看到所有字段
GRANT SELECT ON USERS TO dba_admin;
```

## 9.2 数据加密

### 9.2.1 密码哈希加密

```sql
-- 在应用层或触发器中实现密码哈希

-- 创建触发器自动加密密码
CREATE OR REPLACE TRIGGER encrypt_user_password
BEFORE INSERT OR UPDATE ON USERS
FOR EACH ROW
BEGIN
    -- 如果password_hash字段被修改，使用SHA256加密
    IF :NEW.password_hash != :OLD.password_hash OR INSERTING THEN
        :NEW.password_hash := DBMS_CRYPTO.HASH(
            src => UTL_RAW.CAST_TO_RAW(:NEW.password_hash),
            typ => DBMS_CRYPTO.HASH_SH256
        );
    END IF;
END;
/
```

### 9.2.2 敏感字段透明加密（Transparent Data Encryption - TDE）

```sql
-- 启用Oracle TDE（需要DBA权限）
-- 1. 创建钱包
ADMINISTER KEY MANAGEMENT CREATE KEYSTORE '/path/to/wallet' IDENTIFIED BY "wallet_password";

-- 2. 打开钱包
ADMINISTER KEY MANAGEMENT SET KEYSTORE OPEN IDENTIFIED BY "wallet_password";

-- 3. 创建主密钥
ADMINISTER KEY MANAGEMENT CREATE KEY IDENTIFIED BY "key_password" CONTAINER=ALL;

-- 4. 加密特定表空间或表
ALTER TABLE USERS ENCRYPTION ENCRYPT;
ALTER TABLE RATINGS ENCRYPTION ENCRYPT;
```

### 9.2.3 API密钥和令牌加密

```sql
-- 为移动应用或第三方API存储加密的令牌
CREATE TABLE API_TOKENS (
    token_id NUMBER(10) PRIMARY KEY,
    user_id NUMBER(10) NOT NULL,
    token_value VARCHAR2(500),  -- 加密存储
    token_type VARCHAR2(50),    -- 'mobile', 'web', 'partner'
    expiration_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_at_user FOREIGN KEY (user_id) REFERENCES USERS(user_id)
);

-- 触发器确保令牌加密
CREATE OR REPLACE TRIGGER encrypt_api_token
BEFORE INSERT ON API_TOKENS
FOR EACH ROW
BEGIN
    :NEW.token_value := DBMS_CRYPTO.ENCRYPT(
        src => UTL_RAW.CAST_TO_RAW(:NEW.token_value),
        typ => DBMS_CRYPTO.ENCRYPT_AES256 + DBMS_CRYPTO.CHAIN_CBC,
        key => UTL_RAW.CAST_TO_RAW('your_encryption_key')
    );
END;
/
```

## 9.3 审计日志

### 9.3.1 创建审计表

```sql
-- 审计日志表：记录所有关键操作
CREATE TABLE AUDIT_LOG (
    audit_id            NUMBER(10) PRIMARY KEY,
    audit_timestamp     TIMESTAMP DEFAULT SYSTIMESTAMP,
    database_user       VARCHAR2(50),
    session_id          NUMBER(10),
    operation_type      VARCHAR2(50),  -- INSERT, UPDATE, DELETE, SELECT
    table_name          VARCHAR2(50),
    record_id           VARCHAR2(50),
    old_values          VARCHAR2(4000),
    new_values          VARCHAR2(4000),
    status              VARCHAR2(20),  -- 'SUCCESS', 'FAILURE'
    error_message       VARCHAR2(500)
);

CREATE SEQUENCE seq_audit_log START WITH 1;
```

### 9.3.2 审计触发器

```sql
-- 审计所有RECIPES表的修改
CREATE OR REPLACE TRIGGER audit_recipes_changes
BEFORE INSERT OR UPDATE OR DELETE ON RECIPES
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO AUDIT_LOG (
            audit_id, database_user, operation_type, table_name, 
            record_id, new_values, status
        ) VALUES (
            seq_audit_log.NEXTVAL,
            USER,
            'INSERT',
            'RECIPES',
            :NEW.recipe_id,
            'recipe_name=' || :NEW.recipe_name || '; user_id=' || :NEW.user_id,
            'SUCCESS'
        );
    ELSIF UPDATING THEN
        INSERT INTO AUDIT_LOG (
            audit_id, database_user, operation_type, table_name,
            record_id, old_values, new_values, status
        ) VALUES (
            seq_audit_log.NEXTVAL,
            USER,
            'UPDATE',
            'RECIPES',
            :OLD.recipe_id,
            'name=' || :OLD.recipe_name || '; published=' || :OLD.is_published,
            'name=' || :NEW.recipe_name || '; published=' || :NEW.is_published,
            'SUCCESS'
        );
    ELSIF DELETING THEN
        INSERT INTO AUDIT_LOG (
            audit_id, database_user, operation_type, table_name,
            record_id, old_values, status
        ) VALUES (
            seq_audit_log.NEXTVAL,
            USER,
            'DELETE',
            'RECIPES',
            :OLD.recipe_id,
            'recipe_name=' || :OLD.recipe_name,
            'SUCCESS'
        );
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        INSERT INTO AUDIT_LOG (
            audit_id, database_user, operation_type, table_name,
            status, error_message
        ) VALUES (
            seq_audit_log.NEXTVAL,
            USER,
            'AUDIT_TRIGGER_ERROR',
            'RECIPES',
            'FAILURE',
            SQLERRM
        );
END;
/

-- 审计用户登录
CREATE OR REPLACE TRIGGER audit_user_login
AFTER LOGON ON DATABASE
BEGIN
    INSERT INTO AUDIT_LOG (
        audit_id, database_user, operation_type, status
    ) VALUES (
        seq_audit_log.NEXTVAL,
        USER,
        'LOGON',
        'SUCCESS'
    );
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/
```

### 9.3.3 审计日志查询

```sql
-- 查询过去7天内所有高敏感操作
SELECT * FROM AUDIT_LOG
WHERE audit_timestamp > SYSDATE - 7
  AND operation_type IN ('DELETE', 'UPDATE')
ORDER BY audit_timestamp DESC;

-- 查询特定用户的操作
SELECT * FROM AUDIT_LOG
WHERE database_user = 'app_user'
  AND audit_timestamp > SYSDATE - 30
ORDER BY audit_timestamp DESC;
```

## 9.4 网络安全

### 9.4.1 SQL连接安全

```sql
-- 在 sqlnet.ora 中配置 SSL/TLS
-- ====================================================
-- 强制使用 SSL 加密连接
SQLNET.ENCRYPTION_SERVER = REQUIRED
SQLNET.ENCRYPTION_CLIENT = REQUIRED

-- 支持的加密算法
SQLNET.ENCRYPTION_TYPES_SERVER = (AES256,AES192,AES128)
SQLNET.ENCRYPTION_TYPES_CLIENT = (AES256,AES192,AES128)

-- 数据完整性检查
SQLNET.CRYPTO_CHECKSUM_SERVER = REQUIRED
SQLNET.CRYPTO_CHECKSUM_CLIENT = REQUIRED
SQLNET.CRYPTO_CHECKSUM_TYPES_SERVER = (SHA256)

-- 限制连接协议
SQLNET.ALLOWED_LOGON_VERSION = 12c
```

### 9.4.2 连接字符串示例

```sql
-- 安全的连接字符串
CONNECT app_user/password@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCPS)
         (HOST=db.allrecipes.com)(PORT=2484))
         (CONNECT_DATA=(SERVICE_NAME=ALLRECIPES)))

-- 配置文件（tnsnames.ora）
ALLRECIPES_SECURE =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCPS)(HOST = db.allrecipes.com)(PORT = 2484))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = ALLRECIPES)
    )
  )
```

## 9.5 防火墙和网络隔离

```
应用服务器群        →  防火墙 (仅允许特定端口)  →  数据库服务器
(192.168.1.0/24)     (2484/TCP, 1521/TCP)       (10.0.0.0/8)

┌─────────────────────────────────────────────────────┐
│                 网络分段                            │
├─────────────────────────────────────────────────────┤
│ DMZ: Web服务器                                      │
│ 应用层: 应用服务器、缓存服务器                      │
│ 数据库层: 数据库服务器、备份服务器                  │
│ 管理层: DBA工作站、审计服务器                       │
└─────────────────────────────────────────────────────┘
```

## 9.6 备份与灾难恢复

### 9.6.1 备份策略

```sql
-- 全库备份
EXPDP backup_user/password@allrecipes \
    FULL=Y \
    DIRECTORY=backup_dir \
    DUMPFILE=allrecipes_full_%d_%t.dmp \
    LOGFILE=allrecipes_full_%d_%t.log \
    ENCRYPT_BACKUP=ALL \
    ENCRYPTION_PWD=secure_password

-- 增量备份（仅备份更改数据）
EXPDP backup_user/password@allrecipes \
    FULL=Y \
    INCTYPE=INCREMENTAL \
    DIRECTORY=backup_dir \
    DUMPFILE=allrecipes_incremental_%d_%t.dmp
```

### 9.6.2 恢复过程

```sql
-- 完全恢复
IMPDP backup_user/password@allrecipes \
    FULL=Y \
    DIRECTORY=backup_dir \
    DUMPFILE=allrecipes_full_%.dmp \
    LOGFILE=recovery_full_%t.log

-- 恢复特定表
IMPDP backup_user/password@allrecipes \
    TABLES=RECIPES,USERS \
    DIRECTORY=backup_dir \
    DUMPFILE=allrecipes_full.dmp \
    LOGFILE=recovery_selective.log
```

### 9.6.3 备份验证

```sql
-- 验证备份完整性
BEGIN
    DBMS_BACKUP_RESTORE.validate_backup(
        backup_file => '/path/to/backup/allrecipes_full.dmp'
    );
END;
/
```

## 9.7 安全检查清单

| # | 检查项 | 实现状态 | 说明 |
|---|--------|--------|------|
| 1 | 强制密码策略 | ✓ | 最小12位，包含大小写字母、数字、特殊字符 |
| 2 | 用户权限最小化 | ✓ | 按照最小权限原则分配权限 |
| 3 | 审计日志启用 | ✓ | 所有关键操作都被记录和监控 |
| 4 | 数据加密传输 | ✓ | 使用 SSL/TLS 加密数据库连接 |
| 5 | 敏感字段加密 | ✓ | 密码使用SHA256哈希，关键数据使用AES加密 |
| 6 | SQL注入防护 | ✓ | 应用层使用参数化查询 |
| 7 | 备份加密 | ✓ | 备份文件使用加密存储 |
| 8 | 定期备份 | ✓ | 每日全量备份，每小时增量备份 |
| 9 | 灾难恢复计划 | ✓ | 建立RTO/RPO指标 |
| 10 | 访问控制 | ✓ | 实施行级和列级安全 |
| 11 | 网络隔离 | ✓ | 数据库服务器在独立网络分段 |
| 12 | 防火墙配置 | ✓ | 仅允许特定IP和端口访问 |
| 13 | 日志监控 | ✓ | 定期审查审计日志 |
| 14 | 漏洞扫描 | ✓ | 定期进行安全评估 |
| 15 | 员工培训 | ✓ | 数据库安全意识培训 |

## 9.8 安全事件应急响应

### 检测到异常访问时

```sql
-- 1. 立即查看最近的异常操作
SELECT * FROM AUDIT_LOG
WHERE audit_timestamp > SYSDATE - 1/24  -- 过去一小时
ORDER BY audit_timestamp DESC;

-- 2. 检查特定用户的操作
SELECT * FROM AUDIT_LOG
WHERE database_user = 'suspicious_user'
AND audit_timestamp > SYSDATE - 7;

-- 3. 暂时禁用可疑用户
ALTER USER suspicious_user ACCOUNT LOCK;

-- 4. 检查数据完整性
SELECT COUNT(*) FROM RECIPES;
SELECT COUNT(*) FROM USERS;
```

---

# 总结

本数据库设计方案是一个**企业级、完全规范化的关系型数据库系统**，涵盖了 AllRecipes 食谱网站的所有核心业务需求。

## 主要亮点

- **26个精心设计的表**：覆盖用户、食谱、社交、健康、规划等所有功能模块
- **BCNF规范化**：消除数据冗余，确保数据一致性和完整性
- **16个功能型视图**：简化应用层逻辑，提供安全的数据访问层
- **40+ 常见操作**：覆盖查询、插入、更新、删除等日常业务流程
- **完整的安全方案**：从认证、加密、审计到灾难恢复的多层防护
- **灵活的扩展性**：支持未来新功能的添加和优化

## 部署建议

1. **开发环境**：使用本完整方案进行数据库设计和功能验证
2. **测试环境**：进行压力测试和性能调优
3. **生产环境**：
   - 启用 TDE 加密
   - 配置 SSL/TLS 连接
   - 部署审计和监控系统
   - 实施备份和灾难恢复

## 性能优化建议

1. 定期分析表统计信息：`ANALYZE TABLE ... COMPUTE STATISTICS`
2. 根据查询模式添加分区索引
3. 考虑物化视图缓存频繁查询
4. 定期检查并优化慢查询

## 后续维护

- 每周检查审计日志
- 每月分析数据增长情况
- 每季度进行性能调优
- 每年进行安全审查和升级

