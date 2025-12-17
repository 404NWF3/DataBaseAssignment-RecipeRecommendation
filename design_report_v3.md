# AllRecipes 食谱网站 - 数据库设计报告 (v3.0 N:M规范化版)

## 执行摘要

本报告描述 AllRecipes 食谱网站的数据库完整设计，包含 **26 个核心表**的逻辑模型。

**核心修改**：将8个弱实体表改造为规范的N:M多对多关系表，采用**复合主键**设计，消除代理键冗余，提升至 **BCNF** 规范化等级。

---

## 目录

1. [项目背景](#项目背景)
2. [核心业务功能](#核心业务功能)
3. [ER图设计](#er图设计)
4. [表设计详解](#表设计详解)
5. [规范化分析](#规范化分析)
6. [关键改动说明](#关键改动说明)
7. [完整性约束](#完整性约束)
8. [查询场景](#查询场景)
9. [实施建议](#实施建议)

---

## 项目背景

### 业务概述

AllRecipes 是全球领先的食谱分享平台，核心功能包括：

- **食谱管理**：发布、搜索、浏览、评价食谱
- **社交互动**：关注用户、评论、点赞、分享
- **个性化服务**：膳食规划、购物清单、收藏清单
- **健康管理**：过敏原追踪、营养信息展示

### 核心数据

| 对象 | 数量 | 说明 |
|------|------|------|
| 用户 | M | 注册会员 |
| 食谱 | M | 用户发布的烹饪菜谱 |
| 食材 | K | 可用食材库 |
| 标签 | H | 食谱分类标签 |
| 膳食计划 | M | 用户的周/月食谱安排 |

---

## 核心业务功能

### 1. 食谱发布与管理

- 用户创建和发布食谱
- 编写食材清单（支持单位、数量）
- 记录烹饪步骤（支持图片）
- 添加营养信息
- 标签分类

### 2. 食材管理

- 维护全局食材库
- 标记过敏原信息
- 支持食材替代（如黄油→油）
- 管理计量单位

### 3. 用户交互

- 食谱评价（5星制）
- 食谱评论（支持嵌套）
- 评论点赞
- 收藏食谱
- 关注用户

### 4. 个性化服务

- 创建食谱收藏清单
- 建立膳食计划（一周、一月）
- 生成购物清单
- 管理个人过敏原

---

## ER图设计

### 模块架构

```
┌─────────────────────────────────────────┐
│      核心基础模块 (6个表)               │
│ USERS / INGREDIENTS / UNITS / ALLERGENS │
│ TAGS / USER_ALLERGIES                   │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│      食谱核心模块 (7个表)               │
│ RECIPES / RECIPE_INGREDIENTS            │
│ COOKING_STEPS / NUTRITION_INFO          │
│ INGREDIENT_ALLERGENS / RECIPE_TAGS      │
│ INGREDIENT_SUBSTITUTIONS                │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│      用户交互模块 (7个表)               │
│ RATINGS / RATING_HELPFULNESS            │
│ COMMENTS / COMMENT_HELPFULNESS          │
│ SAVED_RECIPES / FOLLOWERS               │
│ USER_ACTIVITY_LOG                       │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│      个人管理模块 (6个表)               │
│ RECIPE_COLLECTIONS / COLLECTION_RECIPES │
│ SHOPPING_LISTS / SHOPPING_LIST_ITEMS    │
│ MEAL_PLANS / MEAL_PLAN_ENTRIES          │
└─────────────────────────────────────────┘
```

### 主要关系

#### 1:N 关系
- USERS → RECIPES（一个用户多个食谱）
- RECIPES → COOKING_STEPS（一个食谱多个步骤）
- RECIPES → RATINGS（一个食谱多个评价）
- RECIPES → COMMENTS（一个食谱多个评论）
- USERS → FOLLOWERS（一个用户被多人关注）
- RECIPE_COLLECTIONS → COLLECTION_RECIPES（一个清单多个食谱）
- SHOPPING_LISTS → SHOPPING_LIST_ITEMS（一个清单多个食材）
- MEAL_PLANS → MEAL_PLAN_ENTRIES（一个计划多个条目）

#### N:M 关系（复合主键）⭐
- **RECIPE_INGREDIENTS** - (RECIPE_ID, INGREDIENT_ID)
- **USER_ALLERGIES** - (USER_ID, ALLERGEN_ID)
- **INGREDIENT_ALLERGENS** - (INGREDIENT_ID, ALLERGEN_ID)
- **RECIPE_TAGS** - (RECIPE_ID, TAG_ID)
- **INGREDIENT_SUBSTITUTIONS** - (ORIGINAL_ID, SUBSTITUTE_ID) [自引用]
- **COLLECTION_RECIPES** - (COLLECTION_ID, RECIPE_ID)
- **SHOPPING_LIST_ITEMS** - (LIST_ID, INGREDIENT_ID)
- **MEAL_PLAN_ENTRIES** - (PLAN_ID, RECIPE_ID, MEAL_DATE) [三元]

---

## 表设计详解

### 第一组：核心基础表 (6个表)

#### 1. USERS 用户表

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| user_id | NUMBER(10) | PK | 用户ID |
| username | VARCHAR2(50) | UK | 用户名（唯一） |
| email | VARCHAR2(100) | UK | 邮箱（唯一） |
| password_hash | VARCHAR2(255) | NN | 密码哈希 |
| first_name | VARCHAR2(50) | | 名 |
| last_name | VARCHAR2(50) | | 姓 |
| bio | VARCHAR2(500) | | 个人简介 |
| profile_image | VARCHAR2(255) | | 头像URL |
| join_date | DATE | NN | 注册日期 |
| account_status | VARCHAR2(20) | CK | active/inactive/suspended |
| total_followers | NUMBER(10) | DF=0 | 粉丝数（冗余性能） |
| total_recipes | NUMBER(10) | DF=0 | 食谱数（冗余性能） |
| created_at | TIMESTAMP | NN | 创建时间 |
| updated_at | TIMESTAMP | NN | 更新时间 |

**业务规则**：
- 用户名和邮箱全局唯一
- 密码必须加密存储（bcrypt/SHA256）
- TOTAL_FOLLOWERS 和 TOTAL_RECIPES 通过触发器自动维护

#### 2-5. INGREDIENTS, UNITS, ALLERGENS, TAGS

这四个表为**主表**，用于维护系统的基础数据：

- **INGREDIENTS**：食材库（名称、分类、描述）
- **UNITS**：计量单位库（克、毫升、杯等）
- **ALLERGENS**：过敏原库（花生、乳制品等）
- **TAGS**：标签库（素食、低脂等）

#### 6. USER_ALLERGIES ⭐ (修复版N:M表)

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| user_id | NUMBER(10) | PK, FK | 用户ID |
| allergen_id | NUMBER(10) | PK, FK | 过敏原ID |
| added_at | TIMESTAMP | | 添加时间 |

**复合主键**：(user_id, allergen_id)
- 无代理键，完全规范化
- 一个用户可以标记多个过敏原
- 一个过敏原可以被多个用户标记

---

### 第二组：食谱核心表 (7个表)

#### 7. RECIPES 食谱表

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| recipe_id | NUMBER(10) | PK | 食谱ID |
| user_id | NUMBER(10) | FK | 创建者 |
| recipe_name | VARCHAR2(200) | NN | 食谱名称 |
| description | CLOB | | 详细描述 |
| cuisine_type | VARCHAR2(50) | | 菜系 |
| meal_type | VARCHAR2(20) | CK | breakfast/lunch/dinner/snack/dessert |
| difficulty_level | VARCHAR2(20) | CK | easy/medium/hard |
| prep_time | NUMBER(5) | | 准备时间（分钟） |
| cook_time | NUMBER(5) | | 烹饪时间（分钟） |
| servings | NUMBER(5) | | 份数 |
| is_published | VARCHAR2(1) | CK | Y/N |
| is_deleted | VARCHAR2(1) | CK | Y/N（逻辑删除） |
| average_rating | NUMBER(3,2) | DF=0 | 平均评分（性能冗余） |
| rating_count | NUMBER(10) | DF=0 | 评分数量（性能冗余） |
| created_at | TIMESTAMP | NN | 创建时间 |

**关系**：
- 1:N 引用 USERS
- 1:N 指向 COOKING_STEPS
- 1:N 指向 RATINGS
- N:M 关系 INGREDIENTS（通过 RECIPE_INGREDIENTS）
- N:M 关系 TAGS（通过 RECIPE_TAGS）

#### 8. COOKING_STEPS 烹饪步骤表

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| step_id | NUMBER(10) | PK | 步骤ID |
| recipe_id | NUMBER(10) | FK | 食谱ID |
| step_number | NUMBER(5) | NN | 步骤序号 |
| instruction | VARCHAR2(1000) | NN | 步骤详细说明 |
| time_required | NUMBER(5) | | 所需时间（分钟） |
| image_url | VARCHAR2(255) | | 步骤配图 |

**唯一约束**：(recipe_id, step_number)

#### 9. NUTRITION_INFO 营养信息表

与 RECIPES 一对一关系

#### 10-15. 多对多关系表 ⭐

##### RECIPE_INGREDIENTS (修复版)
```
主键：(recipe_id, ingredient_id)
字段：
  - recipe_id → FK RECIPES
  - ingredient_id → FK INGREDIENTS
  - unit_id → FK UNITS
  - quantity 数量
  - notes 备注
```

**业务含义**：
- 一个食谱包含多个食材
- 一个食材可用于多个食谱
- 同一食材在同一食谱中仅出现一次（主键保证）

##### INGREDIENT_ALLERGENS (修复版)
```
主键：(ingredient_id, allergen_id)
含义：标记食材含有的过敏原
```

##### RECIPE_TAGS (修复版)
```
主键：(recipe_id, tag_id)
含义：给食谱打多个标签
```

##### INGREDIENT_SUBSTITUTIONS (修复版 - 自引用)
```
主键：(original_ingredient_id, substitute_ingredient_id)
含义：食材可以被替代
示例：黄油 ↔ 油（1:1）
```

---

### 第三组：用户交互表 (7个表)

#### RATINGS 评价表

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| user_id | NUMBER(10) | PK | 评价用户 |
| recipe_id | NUMBER(10) | PK | 被评价食谱 |
| rating_value | NUMBER(3,2) | NN | 评分值（0-5） |
| review_text | VARCHAR2(1000) | | 评论文本 |
| rating_date | TIMESTAMP | | 评价时间 |

**复合主键**：(user_id, recipe_id) - 同一用户对同一食谱仅能评价一次

#### COMMENTS 评论表

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| comment_id | NUMBER(10) | PK | 评论ID |
| recipe_id | NUMBER(10) | FK | 所属食谱 |
| user_id | NUMBER(10) | FK | 评论用户 |
| parent_comment_id | NUMBER(10) | FK | 父评论ID（支持嵌套） |
| comment_text | VARCHAR2(1000) | NN | 评论内容 |
| is_deleted | VARCHAR2(1) | DF='N' | 逻辑删除标记 |
| created_at | TIMESTAMP | | 创建时间 |

**特点**：
- 支持评论嵌套（通过 parent_comment_id 自引用）
- 使用逻辑删除（保留审计日志）

#### RATING_HELPFULNESS / COMMENT_HELPFULNESS

记录用户对评价和评论的"有用"投票

**主键**：
- RATING_HELPFULNESS: (rating_user_id, rating_recipe_id, voter_user_id)
- COMMENT_HELPFULNESS: (comment_id, user_id)

#### SAVED_RECIPES 收藏表

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| user_id | NUMBER(10) | PK | 用户ID |
| recipe_id | NUMBER(10) | PK | 食谱ID |
| saved_at | TIMESTAMP | | 收藏时间 |

**复合主键**：(user_id, recipe_id)

#### FOLLOWERS 粉丝表

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| user_id | NUMBER(10) | PK | 被关注用户 |
| follower_user_id | NUMBER(10) | PK | 关注者 |
| followed_at | TIMESTAMP | | 关注时间 |
| is_blocked | VARCHAR2(1) | DF='N' | 是否被屏蔽 |

**复合主键**：(user_id, follower_user_id)
**自引用关系**：两个字段都引用 USERS(user_id)

---

### 第四组：个人管理表 (6个表)

#### RECIPE_COLLECTIONS 食谱收藏清单

用户可以创建多个清单，每个清单可以包含多个食谱

#### COLLECTION_RECIPES ⭐ (修复版)

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| collection_id | NUMBER(10) | PK | 清单ID |
| recipe_id | NUMBER(10) | PK | 食谱ID |
| added_at | TIMESTAMP | | 添加时间 |

**复合主键**：(collection_id, recipe_id)

#### SHOPPING_LISTS 购物清单

用户创建的购物清单

#### SHOPPING_LIST_ITEMS ⭐ (修复版)

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| list_id | NUMBER(10) | PK | 清单ID |
| ingredient_id | NUMBER(10) | PK | 食材ID |
| quantity | NUMBER(10,2) | | 数量 |
| unit_id | NUMBER(10) | FK | 单位ID |
| is_checked | VARCHAR2(1) | DF='N' | 已购标记 |
| added_at | TIMESTAMP | | 添加时间 |
| estimated_price | NUMBER(10,2) | | 预估价格 |
| actual_price | NUMBER(10,2) | | 实际价格 |

**复合主键**：(list_id, ingredient_id)

**注意**：
- 同一食材在同一清单中仅出现一次
- 支持价格追踪（预估 vs 实际）

#### MEAL_PLANS 膳食计划

用户的周/月食谱安排

#### MEAL_PLAN_ENTRIES ⭐ (修复版 - 三元主键)

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| plan_id | NUMBER(10) | PK | 计划ID |
| recipe_id | NUMBER(10) | PK | 食谱ID |
| meal_date | DATE | PK | 用餐日期 |
| meal_type | VARCHAR2(20) | | 早/午/晚 |
| notes | VARCHAR2(255) | | 特殊备注 |
| planned_servings | NUMBER(3) | | 计划份数 |
| actual_servings | NUMBER(3) | | 实际份数 |
| is_completed | VARCHAR2(1) | DF='N' | 是否完成 |
| rating | NUMBER(2) | | 满意度评分 |

**三元复合主键**：(plan_id, recipe_id, meal_date)
- 一个计划同一日期同一食谱仅出现一次
- 但可以在不同日期出现多次

**业务规则**：
- meal_date 必须在计划的 start_date 和 end_date 之间
- meal_type 可为 breakfast/lunch/dinner/snack

---

## 规范化分析

### 规范化等级

本设计达到 **BCNF (Boyce-Codd Normal Form)** 级别：

#### 第一范式 (1NF)
✅ 所有字段都是原子值，不可再分
- 例：addresses 不存储完整地址，而是分解为 street, city 等

#### 第二范式 (2NF)
✅ 在 1NF 基础上，所有非主键字段完全依赖于整个主键
- N:M 表中的非主键字段（如数量、单位）只依赖于整个复合主键

#### 第三范式 (3NF)
✅ 在 2NF 基础上，消除传递依赖
- RECIPES 表不保存 USERNAME，而是存储 USER_ID，通过外键关联

#### BCNF (最高规范化)
✅ 消除所有异常依赖
- 改造后的 N:M 表完全符合 BCNF
- 使用复合主键而非代理键，确保数据完整性

### 规范化的益处

| 方面 | 益处 |
|------|------|
| **数据一致性** | 消除冗余减少不一致风险 |
| **数据完整性** | 外键约束自动维护关系 |
| **性能** | 更小的表、更少的扫描 |
| **易维护性** | 修改单一事实源 |
| **可扩展性** | 易于添加新关系 |

---

## 关键改动说明

### 修改前 vs 修改后

#### 问题1：RECIPE_INGREDIENTS 的代理键设计

**修改前** ❌
```sql
CREATE TABLE RECIPE_INGREDIENTS (
    recipe_ingredient_id NUMBER(10) PRIMARY KEY,
    recipe_id NUMBER(10) NOT NULL,
    ingredient_id NUMBER(10) NOT NULL,
    UNIQUE KEY (recipe_id, ingredient_id)
);
-- 问题：
-- - 代理键冗余（业务已有 recipe_id + ingredient_id）
-- - 违反 BCNF（recipe_id, ingredient_id 也可以作为主键）
-- - 浪费存储空间
```

**修改后** ✅
```sql
CREATE TABLE RECIPE_INGREDIENTS (
    recipe_id NUMBER(10),
    ingredient_id NUMBER(10),
    PRIMARY KEY (recipe_id, ingredient_id)
);
-- 优势：
-- - 直接使用业务主键
-- - 符合 BCNF 规范
-- - 更清晰的语义
-- - 更小的表大小
```

### 8个修改的表

| # | 表名 | 修改 | 新主键 |
|---|------|------|--------|
| 1 | RECIPE_INGREDIENTS | 删除代理键 | (recipe_id, ingredient_id) |
| 2 | USER_ALLERGIES | 删除代理键 | (user_id, allergen_id) |
| 3 | INGREDIENT_ALLERGENS | 删除代理键 | (ingredient_id, allergen_id) |
| 4 | RECIPE_TAGS | 删除代理键 | (recipe_id, tag_id) |
| 5 | INGREDIENT_SUBSTITUTIONS | 删除代理键 | (original_id, substitute_id) |
| 6 | COLLECTION_RECIPES | 删除代理键 | (collection_id, recipe_id) |
| 7 | SHOPPING_LIST_ITEMS | 删除代理键 | (list_id, ingredient_id) |
| 8 | MEAL_PLAN_ENTRIES | 删除代理键 | (plan_id, recipe_id, meal_date) |

**统计**：
- 消除代理键 8 个
- 新增复合/三元主键 8 个
- 规范化提升：3NF → BCNF
- 表数量：26 个（不变）

---

## 完整性约束

### 主键约束

**单字段主键**（16个表）
```
USERS, INGREDIENTS, UNITS, RECIPES, COOKING_STEPS, 
NUTRITION_INFO, COMMENTS, RECIPE_COLLECTIONS, 
SHOPPING_LISTS, MEAL_PLANS, TAGS, ALLERGENS, 
USER_ACTIVITY_LOG
```

**复合主键**（9个表）
```
RATINGS(user_id, recipe_id)
SAVED_RECIPES(user_id, recipe_id)
FOLLOWERS(user_id, follower_user_id)
RATING_HELPFULNESS(rating_user_id, rating_recipe_id, voter_user_id)
COMMENT_HELPFULNESS(comment_id, user_id)
⭐ RECIPE_INGREDIENTS(recipe_id, ingredient_id)
⭐ USER_ALLERGIES(user_id, allergen_id)
⭐ INGREDIENT_ALLERGENS(ingredient_id, allergen_id)
⭐ RECIPE_TAGS(recipe_id, tag_id)
⭐ INGREDIENT_SUBSTITUTIONS(original_id, substitute_id)
⭐ COLLECTION_RECIPES(collection_id, recipe_id)
⭐ SHOPPING_LIST_ITEMS(list_id, ingredient_id)
```

**三元主键**（1个表）
```
⭐ MEAL_PLAN_ENTRIES(plan_id, recipe_id, meal_date)
```

### 外键约束

总计 30+ 个外键关系，确保数据完整性

### 检查约束

```sql
-- account_status
CHECK (account_status IN ('active', 'inactive', 'suspended'))

-- meal_type
CHECK (meal_type IN ('breakfast', 'lunch', 'dinner', 'snack', 'dessert'))

-- difficulty_level
CHECK (difficulty_level IN ('easy', 'medium', 'hard'))

-- 布尔标志
CHECK (is_published IN ('Y', 'N'))
CHECK (is_deleted IN ('Y', 'N'))

-- 日期范围
CHECK (start_date <= end_date)
```

---

## 查询场景

### 常见查询

#### 1. 获取食谱的完整食材列表
```sql
SELECT ri.recipe_id, i.ingredient_name, ri.quantity, u.unit_name
FROM RECIPE_INGREDIENTS ri
JOIN INGREDIENTS i ON ri.ingredient_id = i.ingredient_id
JOIN UNITS u ON ri.unit_id = u.unit_id
WHERE ri.recipe_id = ?;
```

#### 2. 检查食谱是否含有用户过敏原
```sql
SELECT DISTINCT r.recipe_id, r.recipe_name
FROM RECIPES r
JOIN RECIPE_INGREDIENTS ri ON r.recipe_id = ri.recipe_id
JOIN INGREDIENT_ALLERGENS ia ON ri.ingredient_id = ia.ingredient_id
WHERE ia.allergen_id IN (SELECT allergen_id FROM USER_ALLERGIES WHERE user_id = ?)
  AND r.is_published = 'Y';
```

#### 3. 为膳食计划生成购物清单
```sql
INSERT INTO SHOPPING_LIST_ITEMS (list_id, ingredient_id, quantity, unit_id)
SELECT sl.list_id, ri.ingredient_id, SUM(ri.quantity), ri.unit_id
FROM SHOPPING_LISTS sl
JOIN MEAL_PLAN_ENTRIES mpe ON mpe.plan_id = ?
JOIN RECIPES r ON mpe.recipe_id = r.recipe_id
JOIN RECIPE_INGREDIENTS ri ON r.recipe_id = ri.recipe_id
GROUP BY sl.list_id, ri.ingredient_id, ri.unit_id;
```

#### 4. 查找食材替代品
```sql
SELECT original_ingredient_id, substitute_ingredient_id, ratio
FROM INGREDIENT_SUBSTITUTIONS
WHERE original_ingredient_id = ? AND approval_status = 'approved';
```

---

## 实施建议

### 迁移策略

1. **备份现有数据** → 导出
2. **在测试环境执行** → 验证脚本
3. **转换数据** → 去重、映射
4. **应用代码修改** → 更新 ORM/查询
5. **验收测试** → 功能、性能
6. **灰度发布** → 小流量、大流量
7. **监控告警** → 异常检测

### 性能考量

✅ **优化**：
- 复合主键减少索引数量
- 外键级联删除自动清理
- 逻辑删除保留审计日志

⚠️ **需注意**：
- JOIN 复杂度略增（但通常不明显）
- 复合主键 ORM 映射需要配置类

---

## 总结

本数据库设计：
- ✅ 完全符合 BCNF 规范化
- ✅ 26 个表的完整架构
- ✅ 8 个 N:M 关系规范化
- ✅ 30+ 外键完整性约束
- ✅ 支持所有业务场景
- ✅ 可扩展、易维护

