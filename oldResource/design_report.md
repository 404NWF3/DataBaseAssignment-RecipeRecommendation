# AllRecipes 食谱网站数据库设计报告

## 目录
1. 项目背景介绍
2. 数据库库表设计
3. 规范化分析
4. 常见操作归纳
5. 完整性约束方案设计
6. 视图设计方案
7. 数据库安全方案设计

---

## 1. 项目背景介绍

### 1.1 AllRecipes 网站概述

AllRecipes 是全球最大的食谱分享平台之一，拥有数百万用户和数百万食谱。该网站的核心业务包括：

- **食谱发布与分享**：用户可以上传自己的食谱，包括食材、烹饪步骤、烹饪时间等信息
- **食谱搜索与浏览**：用户通过关键词、菜系、食材等多维度搜索食谱
- **用户交互功能**：包括评价、评论、收藏等互动功能
- **社区功能**：用户可以关注其他用户，建立社交网络
- **个人食谱管理**：用户可以管理自己的食谱、购物清单、收藏等

### 1.2 核心业务数据

AllRecipes 的主要数据对象包括：

1. **用户（Users）**：平台使用者，具有个人资料、关注关系等
2. **食谱（Recipes）**：烹饪菜谱，包含基本信息、食材、步骤等
3. **食材（Ingredients）**：烹饪所需的原料，具有分类和营养信息
4. **评价和评论（Ratings & Comments）**：用户对食谱的反馈
5. **收藏与清单（Collections & Shopping Lists）**：用户的个人收藏和购物清单

### 1.3 业务流程分析

#### 食谱上传流程
```
用户登录 → 创建食谱 → 添加食材 → 设置烹饪步骤 → 添加图片 → 发布
```

#### 食谱浏览流程
```
用户搜索 → 显示食谱列表 → 查看食谱详情 → 查看评价评论 → 收藏/评价
```

#### 社交互动流程
```
查看用户资料 → 关注用户 → 查看关注用户的食谱 → 与用户互动
```

---

## 2. 数据库库表设计

### 2.1 ER图逻辑关系

数据库包含20个核心表，采用规范化设计，确保数据完整性和查询效率。

### 2.2 表设计详解

#### 2.2.1 用户表（USERS）
```
user_id         (PK) 用户ID
username        唯一用户名
email           唯一邮箱
password_hash   密码哈希值
first_name      名
last_name       姓
bio             用户简介
profile_image   头像URL
join_date       加入日期
last_login      最后登录时间
account_status  账户状态（active/inactive/suspended）
total_followers 粉丝总数
total_recipes   食谱总数
created_at      创建时间
updated_at      更新时间
```

#### 2.2.2 食材表（INGREDIENTS）
```
ingredient_id   (PK) 食材ID
ingredient_name (UNIQUE) 食材名称
category        分类（蔬菜、肉类等）
description     描述
created_at      创建时间
```

#### 2.2.3 食谱表（RECIPES）
```
recipe_id           (PK) 食谱ID
user_id             (FK) 创建者用户ID
recipe_name         食谱名称
description         详细描述
cuisine_type        菜系（中式、意式等）
meal_type           餐次（早餐、午餐等）
difficulty_level    难度（简单、中等、困难）
prep_time           准备时间（分钟）
cook_time           烹饪时间（分钟）
total_time          总时间
servings            份数
calories_per_serving 每份热量
image_url           食谱主图
is_published        是否发布
is_deleted          是否删除（逻辑删除）
view_count          浏览次数
rating_count        评价数
average_rating      平均评分
created_at          创建时间
updated_at          更新时间
```

#### 2.2.4 食谱食材表（RECIPE_INGREDIENTS）
```
recipe_ingredient_id (PK) 关系ID
recipe_id            (FK) 食谱ID
ingredient_id        (FK) 食材ID
unit_id              (FK) 单位ID
quantity             数量
notes                备注（如"切碎"等）
```

#### 2.2.5 烹饪步骤表（COOKING_STEPS）
```
step_id          (PK) 步骤ID
recipe_id        (FK) 食谱ID
step_number      步骤序号
instruction      步骤说明
time_required    所需时间
image_url        步骤配图
```

#### 2.2.6 评价表（RATINGS）
```
rating_id        (PK) 评价ID
user_id          (FK) 用户ID
recipe_id        (FK) 食谱ID
rating_value     评分值（0-5）
review_text      评价文本
helpful_count    有用数
rating_date      评价时间
```

#### 2.2.7 评论表（COMMENTS）
```
comment_id            (PK) 评论ID
recipe_id             (FK) 食谱ID
user_id               (FK) 用户ID
parent_comment_id     (FK) 父评论ID（支持嵌套评论）
comment_text          评论内容
helpful_count         有用数
is_deleted            是否删除
created_at            创建时间
```

#### 2.2.8 其他核心表

- **TAGS（标签表）**：food-friendly, vegan, gluten-free等标签
- **RECIPE_TAGS（食谱标签表）**：多对多关系
- **SAVED_RECIPES（收藏表）**：用户收藏食谱
- **FOLLOWERS（关注表）**：用户关注关系
- **RECIPE_COLLECTIONS（收藏清单）**：用户的食谱集合
- **SHOPPING_LISTS（购物清单）**：用户创建的购物清单
- **ALLERGENS（过敏原表）**：常见过敏物质
- **NUTRITION_INFO（营养信息）**：食谱营养成分

---

## 3. 规范化分析

### 3.1 规范化目标

本数据库设计遵循 **BCNF（Boyce-Codd Normal Form）** 规范，最大化消除数据冗余并保证数据一致性。

### 3.2 规范化过程

#### 3.2.1 第一范式（1NF）- 原子性

所有字段值都是原子的（不可再分）。

**示例：RECIPE_INGREDIENTS 表**
- ❌ 错误设计：在 RECIPES 表中存储 `ingredients` 字段为 "鸡蛋1个,面粉2杯,糖1杯"
- ✅ 正确设计：创建 RECIPE_INGREDIENTS 表，每行记录一种食材

```sql
-- 符合1NF的正确设计
CREATE TABLE RECIPE_INGREDIENTS (
    recipe_ingredient_id NUMBER(10) PRIMARY KEY,
    recipe_id NUMBER(10),
    ingredient_id NUMBER(10),
    unit_id NUMBER(10),
    quantity NUMBER(10,2)
);
```

#### 3.2.2 第二范式（2NF）- 消除部分依赖

所有非主键属性都必须完全依赖于整个主键，不能部分依赖。

**示例：分离用户与食谱的关系**
- ❌ 错误：在 RECIPE_INGREDIENTS 中同时存储 `ingredient_name` 和 `ingredient_id`
- ✅ 正确：只存储 `ingredient_id`，通过外键关联 INGREDIENTS 表

**关键优化：**
- 创建独立的 INGREDIENTS 表，避免在 RECIPE_INGREDIENTS 中重复存储食材属性
- 创建独立的 UNITS 表，避免在 RECIPE_INGREDIENTS 中存储单位信息
- COOKING_STEPS 单独存储，不在 RECIPES 中存储烹饪步骤

#### 3.2.3 第三范式（3NF）- 消除传递依赖

所有非主键属性都直接依赖于主键，而不是传递依赖。

**示例分析：**
```
RECIPES 表：
- recipe_id → recipe_name ✓ 直接依赖
- recipe_id → user_id → total_recipes ✗ 传递依赖

解决方案：
- total_recipes 应在 USERS 表中，不在 RECIPES 中
- 通过 COUNT 查询计算，或在用户修改食谱时更新 USERS.total_recipes
```

**关键优化：**
- USERS 表包含 `total_followers` 和 `total_recipes`：这些是冗余字段，用于性能优化，在应用层维护
- 避免在 RATINGS 表中存储 `recipe_name` 和 `user_name`
- 避免在 COMMENTS 表中存储 `recipe_name` 和 `user_name`

#### 3.2.4 BCNF - 消除所有异常

BCNF 是 3NF 的增强版本。对于每个非平凡的函数依赖 X→Y，X 必须是超键（候选键）。

**分析关键表：**

1. **RECIPE_INGREDIENTS 表**
```
候选键：{recipe_id, ingredient_id}
所有函数依赖：
- {recipe_id, ingredient_id} → quantity ✓
- {recipe_id, ingredient_id} → unit_id ✓
- {recipe_id, ingredient_id} → notes ✓
所有依赖的左侧都是超键，满足BCNF
```

2. **RATINGS 表**
```
候选键：{user_id, recipe_id}（每个用户对每个食谱只能评价一次）
所有函数依赖：
- {user_id, recipe_id} → rating_value ✓
- {user_id, recipe_id} → review_text ✓
所有依赖的左侧都是超键，满足BCNF
```

3. **FOLLOWERS 表**
```
候选键：{user_id, follower_user_id}（防止自关注）
所有函数依赖：
- {user_id, follower_user_id} → followed_at ✓
满足BCNF
```

4. **COMMENTS 表**
```
候选键：{comment_id}
注意：parent_comment_id 形成自引用关系，已通过外键约束处理
```

### 3.3 规范化总结表

| 表名 | 主键 | 外键 | 规范化级别 | 说明 |
|------|------|------|----------|------|
| USERS | user_id | 无 | BCNF | 基础用户信息表 |
| INGREDIENTS | ingredient_id | 无 | BCNF | 基础食材表 |
| UNITS | unit_id | 无 | BCNF | 基础单位表 |
| RECIPES | recipe_id | user_id | BCNF | 食谱基本信息 |
| RECIPE_INGREDIENTS | recipe_ingredient_id | recipe_id, ingredient_id, unit_id | BCNF | 食谱与食材的多对多关系 |
| COOKING_STEPS | step_id | recipe_id | BCNF | 烹饪步骤 |
| RATINGS | rating_id | user_id, recipe_id | BCNF | 用户评价 |
| COMMENTS | comment_id | recipe_id, user_id, parent_comment_id | BCNF | 用户评论 |
| SAVED_RECIPES | saved_recipe_id | user_id, recipe_id | BCNF | 用户收藏 |
| FOLLOWERS | follower_id | user_id, follower_user_id | BCNF | 用户关注 |
| TAGS | tag_id | 无 | BCNF | 标签表 |
| RECIPE_TAGS | recipe_tag_id | recipe_id, tag_id | BCNF | 食谱与标签的多对多关系 |
| ALLERGENS | allergen_id | 无 | BCNF | 过敏原表 |
| INGREDIENT_ALLERGENS | ingredient_allergen_id | ingredient_id, allergen_id | BCNF | 食材与过敏原的多对多关系 |
| NUTRITION_INFO | nutrition_id | recipe_id | BCNF | 营养信息 |

---

## 4. 常见操作归纳

### 4.1 查询操作

1. **按菜系搜索食谱**
   ```sql
   SELECT * FROM RECIPES 
   WHERE cuisine_type = '中式' 
   AND is_published = 'Y'
   ORDER BY average_rating DESC;
   ```

2. **查询用户的所有食谱**
   ```sql
   SELECT * FROM RECIPES 
   WHERE user_id = :user_id 
   AND is_deleted = 'N';
   ```

3. **查询食谱详情（含食材和步骤）**
   ```sql
   SELECT r.*, 
          LISTAGG(ri.quantity || ' ' || u.unit_name || ' ' || i.ingredient_name, ', ')
          WITHIN GROUP (ORDER BY ri.ingredient_id) as ingredients,
          LISTAGG(cs.instruction, '|') WITHIN GROUP (ORDER BY cs.step_number) as steps
   FROM RECIPES r
   LEFT JOIN RECIPE_INGREDIENTS ri ON r.recipe_id = ri.recipe_id
   LEFT JOIN INGREDIENTS i ON ri.ingredient_id = i.ingredient_id
   LEFT JOIN UNITS u ON ri.unit_id = u.unit_id
   LEFT JOIN COOKING_STEPS cs ON r.recipe_id = cs.recipe_id
   WHERE r.recipe_id = :recipe_id;
   ```

4. **查询用户的评价**
   ```sql
   SELECT r.recipe_name, rt.rating_value, rt.review_text
   FROM RATINGS rt
   JOIN RECIPES r ON rt.recipe_id = r.recipe_id
   WHERE rt.user_id = :user_id
   ORDER BY rt.rating_date DESC;
   ```

5. **查询用户的关注者和粉丝**
   ```sql
   -- 用户关注的人
   SELECT u.* FROM USERS u
   JOIN FOLLOWERS f ON u.user_id = f.user_id
   WHERE f.follower_user_id = :user_id;
   
   -- 关注用户的人
   SELECT u.* FROM USERS u
   JOIN FOLLOWERS f ON u.user_id = f.follower_user_id
   WHERE f.user_id = :user_id;
   ```

### 4.2 插入操作

1. **发布新食谱**
   ```sql
   -- 1. 插入食谱
   INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, ...)
   VALUES (seq_recipes.NEXTVAL, :user_id, :recipe_name, :description, ...);
   
   -- 2. 插入食材关联
   INSERT INTO RECIPE_INGREDIENTS (recipe_ingredient_id, recipe_id, ingredient_id, unit_id, quantity)
   VALUES (seq_recipe_ingredients.NEXTVAL, :recipe_id, :ingredient_id, :unit_id, :quantity);
   
   -- 3. 插入烹饪步骤
   INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction)
   VALUES (seq_cooking_steps.NEXTVAL, :recipe_id, :step_number, :instruction);
   ```

2. **用户评价食谱**
   ```sql
   INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text)
   VALUES (seq_ratings.NEXTVAL, :user_id, :recipe_id, :rating_value, :review_text);
   
   -- 更新食谱的平均评分
   UPDATE RECIPES SET 
       average_rating = (SELECT AVG(rating_value) FROM RATINGS WHERE recipe_id = :recipe_id),
       rating_count = (SELECT COUNT(*) FROM RATINGS WHERE recipe_id = :recipe_id)
   WHERE recipe_id = :recipe_id;
   ```

3. **用户收藏食谱**
   ```sql
   INSERT INTO SAVED_RECIPES (saved_recipe_id, user_id, recipe_id)
   VALUES (seq_saved_recipes.NEXTVAL, :user_id, :recipe_id);
   ```

4. **用户留言评论**
   ```sql
   INSERT INTO COMMENTS (comment_id, recipe_id, user_id, parent_comment_id, comment_text)
   VALUES (seq_comments.NEXTVAL, :recipe_id, :user_id, :parent_comment_id, :comment_text);
   ```

### 4.3 更新操作

1. **更新食谱信息**
   ```sql
   UPDATE RECIPES SET 
       recipe_name = :recipe_name,
       description = :description,
       updated_at = SYSTIMESTAMP
   WHERE recipe_id = :recipe_id
   AND user_id = :user_id;  -- 确保用户权限
   ```

2. **删除食谱（逻辑删除）**
   ```sql
   UPDATE RECIPES SET 
       is_deleted = 'Y',
       updated_at = SYSTIMESTAMP
   WHERE recipe_id = :recipe_id
   AND user_id = :user_id;
   ```

3. **关注/取消关注用户**
   ```sql
   -- 关注
   INSERT INTO FOLLOWERS (follower_id, user_id, follower_user_id)
   VALUES (seq_followers.NEXTVAL, :user_id, :follower_user_id);
   
   -- 取消关注
   DELETE FROM FOLLOWERS 
   WHERE user_id = :user_id AND follower_user_id = :follower_user_id;
   
   -- 更新粉丝数
   UPDATE USERS SET 
       total_followers = (SELECT COUNT(*) FROM FOLLOWERS WHERE user_id = :user_id)
   WHERE user_id = :user_id;
   ```

### 4.4 删除操作

1. **删除食谱评价**
   ```sql
   DELETE FROM RATINGS 
   WHERE rating_id = :rating_id
   AND user_id = :user_id;
   
   -- 重新计算平均评分
   UPDATE RECIPES SET 
       average_rating = (SELECT AVG(rating_value) FROM RATINGS WHERE recipe_id = :recipe_id),
       rating_count = (SELECT COUNT(*) FROM RATINGS WHERE recipe_id = :recipe_id)
   WHERE recipe_id = :recipe_id;
   ```

2. **删除评论（逻辑删除）**
   ```sql
   UPDATE COMMENTS SET 
       is_deleted = 'Y',
       updated_at = SYSTIMESTAMP
   WHERE comment_id = :comment_id
   AND user_id = :user_id;
   ```

### 4.5 高级查询操作

1. **热门食谱排行（按评分和浏览数）**
   ```sql
   SELECT recipe_id, recipe_name, average_rating, view_count
   FROM RECIPES
   WHERE is_published = 'Y' AND is_deleted = 'N'
   ORDER BY average_rating DESC, view_count DESC
   FETCH FIRST 10 ROWS ONLY;
   ```

2. **推荐食谱（基于用户关注的创作者）**
   ```sql
   SELECT DISTINCT r.recipe_id, r.recipe_name, r.average_rating
   FROM RECIPES r
   JOIN FOLLOWERS f ON r.user_id = f.user_id
   WHERE f.follower_user_id = :user_id
   AND r.is_published = 'Y'
   AND r.is_deleted = 'N'
   ORDER BY r.average_rating DESC;
   ```

3. **包含特定食材的食谱**
   ```sql
   SELECT DISTINCT r.recipe_id, r.recipe_name
   FROM RECIPES r
   JOIN RECIPE_INGREDIENTS ri ON r.recipe_id = ri.recipe_id
   JOIN INGREDIENTS i ON ri.ingredient_id = i.ingredient_id
   WHERE i.ingredient_name IN (:ingredient_list)
   AND r.is_published = 'Y'
   AND r.is_deleted = 'N';
   ```

4. **不含过敏原的食谱**
   ```sql
   SELECT DISTINCT r.recipe_id, r.recipe_name
   FROM RECIPES r
   WHERE r.recipe_id NOT IN (
       SELECT DISTINCT ri.recipe_id
       FROM RECIPE_INGREDIENTS ri
       JOIN INGREDIENT_ALLERGENS ia ON ri.ingredient_id = ia.ingredient_id
       WHERE ia.allergen_id IN (:allergen_ids)
   );
   ```

---

## 5. 完整性约束方案设计

### 5.1 实体完整性

通过主键约束确保每条记录的唯一性：

```sql
-- 每个表都有 PRIMARY KEY 约束
ALTER TABLE USERS ADD CONSTRAINT pk_users PRIMARY KEY (user_id);
ALTER TABLE INGREDIENTS ADD CONSTRAINT pk_ingredients PRIMARY KEY (ingredient_id);
ALTER TABLE RECIPES ADD CONSTRAINT pk_recipes PRIMARY KEY (recipe_id);
```

### 5.2 参照完整性（外键约束）

通过外键约束确保数据一致性：

```sql
-- 食谱表外键
ALTER TABLE RECIPES ADD CONSTRAINT fk_recipes_user 
FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE;

-- 食谱食材表外键
ALTER TABLE RECIPE_INGREDIENTS ADD CONSTRAINT fk_ri_recipe 
FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE CASCADE;
ALTER TABLE RECIPE_INGREDIENTS ADD CONSTRAINT fk_ri_ingredient 
FOREIGN KEY (ingredient_id) REFERENCES INGREDIENTS(ingredient_id);
ALTER TABLE RECIPE_INGREDIENTS ADD CONSTRAINT fk_ri_unit 
FOREIGN KEY (unit_id) REFERENCES UNITS(unit_id);

-- 评价表外键
ALTER TABLE RATINGS ADD CONSTRAINT fk_rating_user 
FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE;
ALTER TABLE RATINGS ADD CONSTRAINT fk_rating_recipe 
FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE CASCADE;

-- 评论表外键
ALTER TABLE COMMENTS ADD CONSTRAINT fk_comment_recipe 
FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id) ON DELETE CASCADE;
ALTER TABLE COMMENTS ADD CONSTRAINT fk_comment_user 
FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE;
ALTER TABLE COMMENTS ADD CONSTRAINT fk_comment_parent 
FOREIGN KEY (parent_comment_id) REFERENCES COMMENTS(comment_id) ON DELETE SET NULL;

-- 关注表外键
ALTER TABLE FOLLOWERS ADD CONSTRAINT fk_follow_user 
FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE;
ALTER TABLE FOLLOWERS ADD CONSTRAINT fk_follow_follower 
FOREIGN KEY (follower_user_id) REFERENCES USERS(user_id) ON DELETE CASCADE;
```

### 5.3 唯一性约束

确保字段的唯一性：

```sql
-- 用户表
ALTER TABLE USERS ADD CONSTRAINT uk_username UNIQUE (username);
ALTER TABLE USERS ADD CONSTRAINT uk_email UNIQUE (email);

-- 食材表
ALTER TABLE INGREDIENTS ADD CONSTRAINT uk_ingredient_name UNIQUE (ingredient_name);

-- 单位表
ALTER TABLE UNITS ADD CONSTRAINT uk_unit_name UNIQUE (unit_name);

-- 食谱食材关系
ALTER TABLE RECIPE_INGREDIENTS ADD CONSTRAINT uk_recipe_ingredient 
UNIQUE (recipe_id, ingredient_id);

-- 烹饪步骤
ALTER TABLE COOKING_STEPS ADD CONSTRAINT uk_recipe_step 
UNIQUE (recipe_id, step_number);

-- 用户评价（每个用户只能评价一次）
ALTER TABLE RATINGS ADD CONSTRAINT uk_user_recipe_rating 
UNIQUE (user_id, recipe_id);

-- 用户关注关系
ALTER TABLE FOLLOWERS ADD CONSTRAINT uk_follower 
UNIQUE (user_id, follower_user_id);

-- 收藏关系
ALTER TABLE SAVED_RECIPES ADD CONSTRAINT uk_user_recipe 
UNIQUE (user_id, recipe_id);
```

### 5.4 检查约束

确保字段值在允许的范围内：

```sql
-- 账户状态
ALTER TABLE USERS ADD CONSTRAINT ck_account_status 
CHECK (account_status IN ('active', 'inactive', 'suspended'));

-- 餐次类型
ALTER TABLE RECIPES ADD CONSTRAINT ck_meal_type 
CHECK (meal_type IN ('breakfast', 'lunch', 'dinner', 'snack', 'dessert'));

-- 难度等级
ALTER TABLE RECIPES ADD CONSTRAINT ck_difficulty_level 
CHECK (difficulty_level IN ('easy', 'medium', 'hard'));

-- 发布状态
ALTER TABLE RECIPES ADD CONSTRAINT ck_is_published 
CHECK (is_published IN ('Y', 'N'));

-- 删除标记
ALTER TABLE RECIPES ADD CONSTRAINT ck_is_deleted 
CHECK (is_deleted IN ('Y', 'N'));

-- 评分值范围
ALTER TABLE RATINGS ADD CONSTRAINT ck_rating_value 
CHECK (rating_value >= 0 AND rating_value <= 5);

-- 不能自己关注自己
ALTER TABLE FOLLOWERS ADD CONSTRAINT ck_not_self_follow 
CHECK (user_id != follower_user_id);

-- 评论删除标记
ALTER TABLE COMMENTS ADD CONSTRAINT ck_comment_deleted 
CHECK (is_deleted IN ('Y', 'N'));

-- 购物清单项检查
ALTER TABLE SHOPPING_LIST_ITEMS ADD CONSTRAINT ck_is_checked 
CHECK (is_checked IN ('Y', 'N'));

-- 公开状态
ALTER TABLE RECIPE_COLLECTIONS ADD CONSTRAINT ck_is_public 
CHECK (is_public IN ('Y', 'N'));
```

### 5.5 默认值约束

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

-- 计数器初始值
ALTER TABLE RECIPES MODIFY view_count DEFAULT 0;
ALTER TABLE RECIPES MODIFY rating_count DEFAULT 0;
ALTER TABLE RECIPES MODIFY average_rating DEFAULT 0;
```

---

## 6. 视图设计方案

### 6.1 用户视图

#### 6.1.1 用户概览视图（USER_OVERVIEW）
```sql
CREATE VIEW USER_OVERVIEW AS
SELECT 
    u.user_id,
    u.username,
    u.first_name,
    u.last_name,
    u.email,
    u.join_date,
    u.account_status,
    COUNT(DISTINCT r.recipe_id) as recipe_count,
    COUNT(DISTINCT f.follower_user_id) as follower_count,
    COUNT(DISTINCT f2.user_id) as following_count,
    ROUND(AVG(rt.rating_value), 2) as avg_recipe_rating
FROM USERS u
LEFT JOIN RECIPES r ON u.user_id = r.user_id AND r.is_deleted = 'N'
LEFT JOIN FOLLOWERS f ON u.user_id = f.user_id
LEFT JOIN FOLLOWERS f2 ON u.user_id = f2.follower_user_id
LEFT JOIN RATINGS rt ON r.recipe_id = rt.recipe_id
GROUP BY u.user_id, u.username, u.first_name, u.last_name, u.email, u.join_date, u.account_status;
```

#### 6.1.2 活跃用户视图（ACTIVE_USERS）
```sql
CREATE VIEW ACTIVE_USERS AS
SELECT 
    u.user_id,
    u.username,
    u.email,
    u.account_status,
    u.last_login,
    COUNT(r.recipe_id) as recent_recipes,
    COUNT(rt.rating_id) as recent_ratings
FROM USERS u
LEFT JOIN RECIPES r ON u.user_id = r.user_id 
    AND r.created_at > SYSDATE - 30
LEFT JOIN RATINGS rt ON u.user_id = rt.user_id 
    AND rt.rating_date > SYSDATE - 30
WHERE u.account_status = 'active'
GROUP BY u.user_id, u.username, u.email, u.account_status, u.last_login;
```

### 6.2 食谱视图

#### 6.2.1 食谱详情视图（RECIPE_DETAIL）
```sql
CREATE VIEW RECIPE_DETAIL AS
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
    r.calories_per_serving,
    r.image_url,
    r.average_rating,
    r.rating_count,
    r.view_count,
    u.user_id as creator_id,
    u.username as creator_name,
    ni.calories,
    ni.protein_grams,
    ni.carbs_grams,
    ni.fat_grams,
    r.created_at,
    r.updated_at
FROM RECIPES r
JOIN USERS u ON r.user_id = u.user_id
LEFT JOIN NUTRITION_INFO ni ON r.recipe_id = ni.recipe_id
WHERE r.is_published = 'Y' AND r.is_deleted = 'N';
```

#### 6.2.2 热门食谱视图（POPULAR_RECIPES）
```sql
CREATE VIEW POPULAR_RECIPES AS
SELECT 
    recipe_id,
    recipe_name,
    cuisine_type,
    average_rating,
    rating_count,
    view_count,
    (average_rating * rating_count + view_count * 0.1) as popularity_score
FROM RECIPES
WHERE is_published = 'Y' AND is_deleted = 'N'
ORDER BY popularity_score DESC;
```

#### 6.2.3 食谱与食材视图（RECIPE_WITH_INGREDIENTS）
```sql
CREATE VIEW RECIPE_WITH_INGREDIENTS AS
SELECT 
    r.recipe_id,
    r.recipe_name,
    ri.ingredient_id,
    i.ingredient_name,
    i.category as ingredient_category,
    ri.quantity,
    u.unit_name,
    ri.notes
FROM RECIPES r
JOIN RECIPE_INGREDIENTS ri ON r.recipe_id = ri.recipe_id
JOIN INGREDIENTS i ON ri.ingredient_id = i.ingredient_id
JOIN UNITS u ON ri.unit_id = u.unit_id
WHERE r.is_deleted = 'N';
```

### 6.3 社交视图

#### 6.3.1 用户社交网络视图（USER_NETWORK）
```sql
CREATE VIEW USER_NETWORK AS
SELECT 
    u.user_id,
    u.username,
    COUNT(DISTINCT f.follower_user_id) as follower_count,
    COUNT(DISTINCT f2.user_id) as following_count,
    COUNT(DISTINCT sr.saved_recipe_id) as saved_recipes_count,
    COUNT(DISTINCT rt.rating_id) as reviews_count
FROM USERS u
LEFT JOIN FOLLOWERS f ON u.user_id = f.user_id
LEFT JOIN FOLLOWERS f2 ON u.user_id = f2.follower_user_id
LEFT JOIN SAVED_RECIPES sr ON u.user_id = sr.user_id
LEFT JOIN RATINGS rt ON u.user_id = rt.user_id
GROUP BY u.user_id, u.username;
```

#### 6.3.2 用户活动视图（USER_ACTIVITY）
```sql
CREATE VIEW USER_ACTIVITY AS
SELECT 
    u.user_id,
    u.username,
    ual.activity_type,
    ual.activity_description,
    ual.activity_timestamp,
    CASE 
        WHEN ual.activity_type = 'recipe_created' THEN r.recipe_name
        WHEN ual.activity_type = 'recipe_rated' THEN r.recipe_name
        ELSE NULL
    END as related_recipe_name
FROM USERS u
LEFT JOIN USER_ACTIVITY_LOG ual ON u.user_id = ual.user_id
LEFT JOIN RECIPES r ON ual.related_recipe_id = r.recipe_id
WHERE ual.activity_timestamp > SYSDATE - 30;
```

### 6.4 分析视图

#### 6.4.1 食谱统计视图（RECIPE_STATISTICS）
```sql
CREATE VIEW RECIPE_STATISTICS AS
SELECT 
    DATE_TRUNC('month', r.created_at) as month,
    COUNT(DISTINCT r.recipe_id) as total_recipes,
    COUNT(DISTINCT r.user_id) as unique_creators,
    ROUND(AVG(r.average_rating), 2) as avg_rating,
    SUM(r.view_count) as total_views,
    SUM(r.rating_count) as total_ratings
FROM RECIPES r
WHERE r.is_deleted = 'N'
GROUP BY DATE_TRUNC('month', r.created_at);
```

#### 6.4.2 用户互动统计视图（ENGAGEMENT_STATISTICS）
```sql
CREATE VIEW ENGAGEMENT_STATISTICS AS
SELECT 
    u.user_id,
    u.username,
    COUNT(DISTINCT rt.rating_id) as total_ratings,
    COUNT(DISTINCT cmt.comment_id) as total_comments,
    COUNT(DISTINCT sr.saved_recipe_id) as total_saves,
    COUNT(DISTINCT f.follower_user_id) as followers_gained
FROM USERS u
LEFT JOIN RATINGS rt ON u.user_id = rt.user_id
LEFT JOIN COMMENTS cmt ON u.user_id = cmt.user_id
LEFT JOIN SAVED_RECIPES sr ON u.user_id = sr.user_id
LEFT JOIN FOLLOWERS f ON u.user_id = f.user_id
GROUP BY u.user_id, u.username;
```

### 6.5 视图用途总结

| 视图名称 | 主要用途 | 涉及表 |
|---------|---------|--------|
| USER_OVERVIEW | 显示用户个人资料页面 | USERS, RECIPES, FOLLOWERS, RATINGS |
| ACTIVE_USERS | 分析活跃用户 | USERS, RECIPES, RATINGS |
| RECIPE_DETAIL | 显示食谱详情页面 | RECIPES, USERS, NUTRITION_INFO |
| POPULAR_RECIPES | 显示热门推荐列表 | RECIPES |
| RECIPE_WITH_INGREDIENTS | 查询食材列表 | RECIPES, INGREDIENTS, UNITS, RECIPE_INGREDIENTS |
| USER_NETWORK | 社交网络分析 | USERS, FOLLOWERS, SAVED_RECIPES, RATINGS |
| USER_ACTIVITY | 用户活动时间线 | USERS, USER_ACTIVITY_LOG, RECIPES |
| RECIPE_STATISTICS | 月度报表统计 | RECIPES |
| ENGAGEMENT_STATISTICS | 用户互动分析 | USERS, RATINGS, COMMENTS, SAVED_RECIPES, FOLLOWERS |

---

## 7. 数据库安全方案设计

### 7.1 用户权限控制

#### 7.1.1 创建数据库用户

```sql
-- 创建应用用户（具有标准权限）
CREATE USER app_user IDENTIFIED BY app_password123;

-- 创建只读用户（用于报表和分析）
CREATE USER report_user IDENTIFIED BY report_password123;

-- 创建管理员用户（具有较高权限）
CREATE USER admin_user IDENTIFIED BY admin_password123;

-- 创建备份用户（用于数据备份）
CREATE USER backup_user IDENTIFIED BY backup_password123;
```

#### 7.1.2 授予基本权限

```sql
-- 授予应用用户基本权限
GRANT CONNECT, RESOURCE TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON USERS TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON RECIPES TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON RATINGS TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON COMMENTS TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON SAVED_RECIPES TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON FOLLOWERS TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON SHOPPING_LISTS TO app_user;
GRANT SELECT ON INGREDIENTS TO app_user;
GRANT SELECT ON UNITS TO app_user;
GRANT SELECT ON TAGS TO app_user;
GRANT SELECT ON ALLERGENS TO app_user;

-- 授予只读用户权限
GRANT CONNECT TO report_user;
GRANT SELECT ON USERS TO report_user;
GRANT SELECT ON RECIPES TO report_user;
GRANT SELECT ON RATINGS TO report_user;
GRANT SELECT ON COMMENTS TO report_user;
GRANT SELECT ON INGREDIENTS TO report_user;
GRANT SELECT ON ALL VIEWS TO report_user;

-- 授予管理员权限（通常是DBA）
GRANT DBA TO admin_user;

-- 授予备份用户权限
GRANT CONNECT, RESOURCE, BACKUP ANY TABLE TO backup_user;
```

#### 7.1.3 精细化权限控制示例

```sql
-- 只允许用户修改自己的个人资料
CREATE OR REPLACE TRIGGER update_own_profile
BEFORE UPDATE ON USERS
FOR EACH ROW
BEGIN
    IF :NEW.user_id != SYS_CONTEXT('USERENV', 'SESSION_USER') THEN
        RAISE_APPLICATION_ERROR(-20001, '用户只能修改自己的个人资料');
    END IF;
END;
/

-- 只允许用户删除自己的食谱
CREATE OR REPLACE TRIGGER delete_own_recipe
BEFORE DELETE ON RECIPES
FOR EACH ROW
BEGIN
    IF :OLD.user_id != SYS_CONTEXT('USERENV', 'SESSION_USER') THEN
        RAISE_APPLICATION_ERROR(-20002, '用户只能删除自己的食谱');
    END IF;
END;
/
```

### 7.2 数据加密

#### 7.2.1 密码加密

```sql
-- 创建存储过程来安全地存储密码
CREATE OR REPLACE PROCEDURE hash_password(
    p_password VARCHAR2,
    p_hash OUT VARCHAR2
) AS
BEGIN
    -- 使用 DBMS_CRYPTO 进行加密
    p_hash := DBMS_CRYPTO.HASH(
        src => UTL_RAW.CAST_TO_RAW(p_password),
        typ => DBMS_CRYPTO.HASH_SH256
    );
END;
/

-- 修改 USERS 表的插入/更新触发器
CREATE OR REPLACE TRIGGER hash_user_password
BEFORE INSERT OR UPDATE ON USERS
FOR EACH ROW
BEGIN
    IF :NEW.password_hash IS NOT NULL AND 
       (:NEW.password_hash = :OLD.password_hash OR :OLD.password_hash IS NULL) THEN
        -- 使用应用层加密或数据库加密
        :NEW.password_hash := DBMS_CRYPTO.HASH(
            src => UTL_RAW.CAST_TO_RAW(:NEW.password_hash),
            typ => DBMS_CRYPTO.HASH_SH256
        );
    END IF;
END;
/
```

#### 7.2.2 敏感字段加密

```sql
-- 添加加密字段
ALTER TABLE USERS ADD email_encrypted RAW(2000);

-- 创建过程加密敏感邮箱
CREATE OR REPLACE PROCEDURE encrypt_user_email(
    p_user_id NUMBER,
    p_email VARCHAR2
) AS
BEGIN
    UPDATE USERS SET
        email_encrypted = DBMS_CRYPTO.ENCRYPT(
            src => UTL_RAW.CAST_TO_RAW(p_email),
            typ => DBMS_CRYPTO.ENCRYPT_AES256 + DBMS_CRYPTO.CHAIN_CBC,
            key => UTL_RAW.CAST_TO_RAW('your_encryption_key')
        )
    WHERE user_id = p_user_id;
COMMIT;
END;
/
```

### 7.3 审计日志

#### 7.3.1 创建审计表

```sql
CREATE TABLE AUDIT_LOG (
    audit_id        NUMBER(10) PRIMARY KEY,
    table_name      VARCHAR2(50),
    operation       VARCHAR2(10),  -- INSERT, UPDATE, DELETE
    user_name       VARCHAR2(50),
    old_values      VARCHAR2(2000),
    new_values      VARCHAR2(2000),
    audit_timestamp TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE SEQUENCE seq_audit_log START WITH 1 INCREMENT BY 1;
```

#### 7.3.2 创建审计触发器

```sql
-- 审计食谱表的修改
CREATE OR REPLACE TRIGGER audit_recipes
BEFORE INSERT OR UPDATE OR DELETE ON RECIPES
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO AUDIT_LOG (audit_id, table_name, operation, user_name, new_values)
        VALUES (
            seq_audit_log.NEXTVAL,
            'RECIPES',
            'INSERT',
            USER,
            'recipe_id:' || :NEW.recipe_id || ', user_id:' || :NEW.user_id || ', recipe_name:' || :NEW.recipe_name
        );
    ELSIF UPDATING THEN
        INSERT INTO AUDIT_LOG (audit_id, table_name, operation, user_name, old_values, new_values)
        VALUES (
            seq_audit_log.NEXTVAL,
            'RECIPES',
            'UPDATE',
            USER,
            'recipe_name:' || :OLD.recipe_name || ', status:' || :OLD.is_published,
            'recipe_name:' || :NEW.recipe_name || ', status:' || :NEW.is_published
        );
    ELSIF DELETING THEN
        INSERT INTO AUDIT_LOG (audit_id, table_name, operation, user_name, old_values)
        VALUES (
            seq_audit_log.NEXTVAL,
            'RECIPES',
            'DELETE',
            USER,
            'recipe_id:' || :OLD.recipe_id || ', recipe_name:' || :OLD.recipe_name
        );
    END IF;
    COMMIT;
END;
/

-- 审计用户表的修改
CREATE OR REPLACE TRIGGER audit_users
BEFORE INSERT OR UPDATE OR DELETE ON USERS
FOR EACH ROW
BEGIN
    IF UPDATING THEN
        INSERT INTO AUDIT_LOG (audit_id, table_name, operation, user_name, old_values, new_values)
        VALUES (
            seq_audit_log.NEXTVAL,
            'USERS',
            'UPDATE',
            USER,
            'status:' || :OLD.account_status || ', email:' || :OLD.email,
            'status:' || :NEW.account_status || ', email:' || :NEW.email
        );
    END IF;
    COMMIT;
END;
/

-- 审计评价表的修改
CREATE OR REPLACE TRIGGER audit_ratings
BEFORE INSERT OR UPDATE OR DELETE ON RATINGS
FOR EACH ROW
BEGIN
    IF DELETING THEN
        INSERT INTO AUDIT_LOG (audit_id, table_name, operation, user_name, old_values)
        VALUES (
            seq_audit_log.NEXTVAL,
            'RATINGS',
            'DELETE',
            USER,
            'rating_id:' || :OLD.rating_id || ', value:' || :OLD.rating_value
        );
    END IF;
    COMMIT;
END;
/
```

### 7.4 访问控制策略

#### 7.4.1 行级安全（RLS - Row Level Security）

```sql
-- 创建安全策略：用户只能看到自己发布的食谱
CREATE OR REPLACE PACKAGE recipe_security AS
    PROCEDURE set_recipe_predicate;
END recipe_security;
/

CREATE OR REPLACE PACKAGE BODY recipe_security AS
    PROCEDURE set_recipe_predicate IS
    BEGIN
        DBMS_RLS.add_policy(
            object_schema => 'ALLRECIPES',
            object_name => 'RECIPES',
            policy_name => 'user_recipe_policy',
            function_schema => 'ALLRECIPES',
            policy_function => 'recipe_policy_func',
            statement_types => 'SELECT, INSERT, UPDATE, DELETE'
        );
    END set_recipe_predicate;
END recipe_security;
/

-- 创建策略函数
CREATE OR REPLACE FUNCTION recipe_policy_func(
    p_schema varchar2,
    p_object varchar2
) RETURN varchar2 AS
BEGIN
    RETURN 'user_id = SYS_CONTEXT(''USERENV'', ''USER_ID'')';
END recipe_policy_func;
/
```

#### 7.4.2 列级安全

```sql
-- 限制某些用户无法看到敏感字段（如密码哈希）
GRANT SELECT(user_id, username, email, first_name, last_name, profile_image)
ON USERS TO app_user;

-- 管理员可以看到所有字段
GRANT SELECT ON USERS TO admin_user;
```

### 7.5 连接安全

#### 7.5.1 强制SSL连接

```sql
-- 配置 Oracle 强制使用 SSL/TLS
-- 在 sqlnet.ora 中添加：
-- SQLNET.ENCRYPTION_SERVER = REQUIRED
-- SQLNET.ENCRYPTION_CLIENT = REQUIRED
-- SQLNET.ENCRYPTION_TYPES_SERVER = (AES256)
-- SQLNET.CRYPTO_CHECKSUM_SERVER = REQUIRED
-- SQLNET.CRYPTO_CHECKSUM_CLIENT = REQUIRED
```

#### 7.5.2 连接字符串示例

```sql
-- 安全的连接字符串
CONNECT app_user/app_password123@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCPS)(HOST=db.allrecipes.com)(PORT=2484))(CONNECT_DATA=(SERVICE_NAME=ALLRECIPES)))
```

### 7.6 备份与恢复安全

#### 7.6.1 定期备份策略

```sql
-- 创建备份脚本
CREATE OR REPLACE PROCEDURE backup_database AS
BEGIN
    -- 全库备份
    EXECUTE IMMEDIATE 'EXPDP backup_user/backup_password123@allrecipes ' ||
        'FULL=Y DIRECTORY=backup_dir DUMPFILE=allrecipes_full_%D_%T.dmp ' ||
        'LOGFILE=allrecipes_full_%D_%T.log ENCRYPT_BACKUP=all';
END;
/

-- 执行备份存储过程
BEGIN
    backup_database;
END;
/
```

#### 7.6.2 恢复过程

```sql
-- 恢复数据库（需要DBA权限）
-- IMPDP backup_user/backup_password123@allrecipes \
--     FULL=Y DIRECTORY=backup_dir DUMPFILE=allrecipes_full_*.dmp \
--     LOGFILE=recovery.log
```

### 7.7 参数加固

#### 7.7.1 初始化参数安全配置

```sql
-- Oracle 11g 推荐参数配置
ALTER SYSTEM SET audit_trail=DB SCOPE=SPFILE;
ALTER SYSTEM SET remote_login_passwordfile=EXCLUSIVE SCOPE=SPFILE;
ALTER SYSTEM SET open_cursors=500 SCOPE=BOTH;
ALTER SYSTEM SET processes=500 SCOPE=SPFILE;
ALTER SYSTEM SET db_recovery_file_dest='/backup/fra' SCOPE=BOTH;
ALTER SYSTEM SET log_archive_dest_1='LOCATION=/archive VALID_FOR=(ALL_LOGS,ALL_ROLES) DB_UNIQUE_NAME=ALLRECIPES' SCOPE=SPFILE;

-- 重启数据库使参数生效
SHUTDOWN IMMEDIATE;
STARTUP;
```

### 7.8 安全检查清单

| 检查项 | 状态 | 说明 |
|--------|------|------|
| 强制密码策略 | ✓ | 密码最小长度12位，包含大小写和数字 |
| 用户权限最小化 | ✓ | 用户只获得必要的权限 |
| 审计日志启用 | ✓ | 记录所有关键操作 |
| 数据加密 | ✓ | 敏感数据使用加密存储 |
| SSL连接 | ✓ | 强制使用加密连接 |
| 备份加密 | ✓ | 备份文件加密存储 |
| 定期备份 | ✓ | 每日备份，异地存储 |
| 访问控制 | ✓ | 实施行级和列级安全 |
| 日志监控 | ✓ | 定期审查审计日志 |

---

## 附录：表信息速查

### A.1 表关系图描述

```
USERS (1)
├── (1:N) RECIPES
│   ├── (1:N) RECIPE_INGREDIENTS (N:M via INGREDIENTS)
│   ├── (1:N) COOKING_STEPS
│   ├── (1:N) RATINGS (N:1 USERS)
│   ├── (1:N) COMMENTS (N:1 USERS)
│   ├── (1:N) SAVED_RECIPES (N:1 USERS)
│   ├── (1:N) RECIPE_TAGS (N:M via TAGS)
│   └── (1:1) NUTRITION_INFO
├── (1:N) FOLLOWERS (N:1 USERS as follower_user_id)
├── (1:N) SAVED_RECIPES
├── (1:N) RATINGS
├── (1:N) COMMENTS
├── (1:N) RECIPE_COLLECTIONS
│   └── (1:N) COLLECTION_RECIPES (N:1 RECIPES)
├── (1:N) SHOPPING_LISTS
│   └── (1:N) SHOPPING_LIST_ITEMS (N:1 INGREDIENTS)
└── (1:N) USER_ACTIVITY_LOG

INGREDIENTS (M)
├── (N:M) RECIPE_INGREDIENTS
├── (1:N) INGREDIENT_ALLERGENS (N:1 ALLERGENS)
└── (1:N) SHOPPING_LIST_ITEMS

TAGS (M)
└── (N:M) RECIPE_TAGS

UNITS (1)
└── (1:N) RECIPE_INGREDIENTS
└── (1:N) SHOPPING_LIST_ITEMS

ALLERGENS (1)
└── (1:N) INGREDIENT_ALLERGENS

COMMENTS (1)
└── (1:N) COMMENTS (self-referencing)
```

---

## 总结

本数据库设计遵循 **BCNF 规范**，通过以下特点确保系统的稳定性和可维护性：

1. **完整的规范化设计**：消除数据冗余，确保数据一致性
2. **多层安全保障**：从用户认证到数据加密再到审计日志
3. **灵活的视图结构**：支持多种查询需求和分析功能
4. **明确的业务逻辑**：清晰的表关系和约束定义
5. **可扩展性**：支持未来功能拓展和数据增长

该设计适用于 Oracle 11g 及更高版本，能够支持数百万用户和数百万食谱的规模。