# AllRecipes 食谱网站 - ER模型设计文档 (v3.0 N:M规范化版)

## 执行摘要

本文档详细描述 AllRecipes 食谱网站的**概念数据模型 (ER图)**，包含：
- **26个实体**（表）
- **35+个属性**（字段）
- **30+个关系**
- **完全的BCNF规范化设计**

**核心创新**：8个N:M关系采用**复合主键**设计，消除冗余代理键

---

## 目录

1. [ER图总体架构](#er图总体架构)
2. [实体分类及定义](#实体分类及定义)
3. [属性详解](#属性详解)
4. [关系类型及定义](#关系类型及定义)
5. [N:M关系规范化设计](#nm关系规范化设计)
6. [业务流程关系图](#业务流程关系图)
7. [设计决策与亮点](#设计决策与亮点)
8. [与前版本对比](#与前版本对比)

---

## ER图总体架构

### 模块划分

```
┌──────────────────────────────────────────────────────────────┐
│                     核心基础模块 (6个表)                       │
│  USERS | INGREDIENTS | UNITS | ALLERGENS | TAGS | USER_ALLERGIES |
└────────────────────────┬─────────────────────────────────────┘
                         │ 1:N 关系
                         ↓
┌──────────────────────────────────────────────────────────────┐
│                     食谱核心模块 (7个表)                       │
│  RECIPES | RECIPE_INGREDIENTS | COOKING_STEPS                │
│  NUTRITION_INFO | INGREDIENT_ALLERGENS | RECIPE_TAGS         │
│  INGREDIENT_SUBSTITUTIONS (N:M复合主键)                      │
└────────────────────────┬─────────────────────────────────────┘
                         │ 1:N 关系
                         ↓
┌──────────────────────────────────────────────────────────────┐
│                     用户交互模块 (7个表)                       │
│  RATINGS | RATING_HELPFULNESS | COMMENTS                     │
│  COMMENT_HELPFULNESS | SAVED_RECIPES | FOLLOWERS             │
│  USER_ACTIVITY_LOG                                           │
└────────────────────────┬─────────────────────────────────────┘
                         │ 1:N 关系
                         ↓
┌──────────────────────────────────────────────────────────────┐
│                     个人管理模块 (6个表)                       │
│  RECIPE_COLLECTIONS | COLLECTION_RECIPES                     │
│  SHOPPING_LISTS | SHOPPING_LIST_ITEMS                        │
│  MEAL_PLANS | MEAL_PLAN_ENTRIES (三元N:M)                    │
└──────────────────────────────────────────────────────────────┘
```

---

## 实体分类及定义

### 类型1：强实体（11个）

强实体可独立存在，不依赖其他实体

| # | 实体名 | 中文 | 关键属性 | 作用 |
|---|--------|------|---------|------|
| 1 | USERS | 用户 | user_id, username, email | 平台用户 |
| 2 | INGREDIENTS | 食材 | ingredient_id, name, category | 食材库 |
| 3 | UNITS | 单位 | unit_id, unit_name, abbr | 计量单位 |
| 4 | ALLERGENS | 过敏原 | allergen_id, name | 过敏原库 |
| 5 | TAGS | 标签 | tag_id, tag_name | 分类标签 |
| 6 | RECIPES | 食谱 | recipe_id, name, description | 核心内容 |
| 7 | COOKING_STEPS | 烹饪步骤 | step_id, recipe_id, instruction | 步骤说明 |
| 8 | NUTRITION_INFO | 营养信息 | nutrition_id, calories, protein | 营养数据 |
| 9 | RECIPE_COLLECTIONS | 食谱清单 | collection_id, name | 用户收藏 |
| 10 | SHOPPING_LISTS | 购物清单 | list_id, user_id, name | 购物管理 |
| 11 | MEAL_PLANS | 膳食计划 | plan_id, user_id, name | 膳食规划 |

### 类型2：弱实体（5个）

弱实体依赖强实体生存，无法独立标识

| # | 实体名 | 依赖于 | 特点 |
|---|--------|--------|------|
| 1 | COMMENTS | RECIPES | 评论必须属于某个食谱 |
| 2 | RATINGS | RECIPES | 评分必须属于某个食谱 |
| 3 | SAVED_RECIPES | USERS/RECIPES | 收藏记录依赖用户和食谱 |
| 4 | USER_ACTIVITY_LOG | USERS | 活动日志属于用户 |
| 5 | FOLLOWERS | USERS | 粉丝关系自引用用户 |

### 类型3：N:M关系表（8个，**修复版复合主键**）⭐

**修复核心**：从弱实体改造为规范的N:M关系表

| # | 表名 | 类型 | 主键 | 说明 |
|---|------|------|------|------|
| 1 | USER_ALLERGIES | 二元 | (user_id, allergen_id) | 用户过敏原关系 |
| 2 | RECIPE_INGREDIENTS | 二元 | (recipe_id, ingredient_id) | 食谱食材关系 |
| 3 | INGREDIENT_ALLERGENS | 二元 | (ingredient_id, allergen_id) | 食材过敏原 |
| 4 | RECIPE_TAGS | 二元 | (recipe_id, tag_id) | 食谱标签关系 |
| 5 | INGREDIENT_SUBSTITUTIONS | 二元 | (original_id, substitute_id) | 食材替代关系（自引用） |
| 6 | COLLECTION_RECIPES | 二元 | (collection_id, recipe_id) | 清单食谱关系 |
| 7 | SHOPPING_LIST_ITEMS | 二元 | (list_id, ingredient_id) | 购物清单项目 |
| 8 | MEAL_PLAN_ENTRIES | 三元 | (plan_id, recipe_id, meal_date) | 膳食计划条目 |

**关键改进**：
- ✅ 消除8个代理键冗余
- ✅ 复合主键直接反映业务主键
- ✅ 符合BCNF最高规范化
- ✅ 数据库层强制唯一性

---

## 属性详解

### USERS 实体的属性

| 属性名 | 数据类型 | 约束 | 说明 |
|--------|---------|------|------|
| user_id | NUMBER(10) | PK | 用户编号 |
| username | VARCHAR2(50) | UK | 用户名（唯一） |
| email | VARCHAR2(100) | UK | 邮箱（唯一） |
| password_hash | VARCHAR2(255) | NN | 密码哈希 |
| first_name | VARCHAR2(50) | | 名字 |
| last_name | VARCHAR2(50) | | 姓氏 |
| bio | VARCHAR2(500) | | 个人简介 |
| profile_image | VARCHAR2(255) | | 头像 |
| join_date | DATE | NN | 注册日期 |
| last_login | DATE | | 最后登录 |
| account_status | VARCHAR2(20) | CK | 账户状态 |
| total_followers | NUMBER(10) | DF=0 | 粉丝数（冗余性能） |
| total_recipes | NUMBER(10) | DF=0 | 食谱数（冗余性能） |
| created_at | TIMESTAMP | NN | 创建时间 |
| updated_at | TIMESTAMP | NN | 更新时间 |

**设计说明**：
- `username` 和 `email` 都是候选键（唯一标识用户）
- `password_hash` 存储加密后的密码（bcrypt）
- `account_status ∈ {'active', 'inactive', 'suspended'}`
- `total_followers` 和 `total_recipes` 为**冗余性能字段**，通过触发器维护

### RECIPES 实体的属性

| 属性名 | 数据类型 | 约束 | 说明 |
|--------|---------|------|------|
| recipe_id | NUMBER(10) | PK | 食谱编号 |
| user_id | NUMBER(10) | FK | 创建者编号 |
| recipe_name | VARCHAR2(200) | NN | 食谱名称 |
| description | VARCHAR2(1000) | | 详细描述 |
| cuisine_type | VARCHAR2(50) | | 菜系（中/日/意等） |
| meal_type | VARCHAR2(20) | CK | 餐型 |
| difficulty_level | VARCHAR2(20) | CK | 难度级别 |
| prep_time | NUMBER(5) | | 准备时间（分钟） |
| cook_time | NUMBER(5) | | 烹饪时间（分钟） |
| total_time | NUMBER(5) | | 总时间 |
| servings | NUMBER(5) | | 份数 |
| calories_per_serving | NUMBER(10) | | 每份热量 |
| is_published | VARCHAR2(1) | CK | 是否发布 |
| is_deleted | VARCHAR2(1) | CK | 逻辑删除 |
| average_rating | NUMBER(3,2) | DF=0 | 平均评分（冗余） |
| rating_count | NUMBER(10) | DF=0 | 评分数（冗余） |
| created_at | TIMESTAMP | NN | 创建时间 |

**设计说明**：
- `meal_type ∈ {'breakfast', 'lunch', 'dinner', 'snack', 'dessert'}`
- `difficulty_level ∈ {'easy', 'medium', 'hard'}`
- `average_rating` 和 `rating_count` 为**冗余字段**（提升查询性能）

### 其他实体的关键属性

| 实体 | 关键属性 |
|------|---------|
| INGREDIENTS | ingredient_id, ingredient_name(UK), category |
| UNITS | unit_id, unit_name(UK), abbreviation |
| ALLERGENS | allergen_id, allergen_name(UK) |
| TAGS | tag_id, tag_name(UK) |
| COOKING_STEPS | step_id, recipe_id(FK), step_number, instruction |
| COMMENTS | comment_id, recipe_id(FK), user_id(FK), parent_comment_id(FK-递归), comment_text |
| RATINGS | user_id(PK), recipe_id(PK), rating_value, review_text |
| SAVED_RECIPES | user_id(PK), recipe_id(PK), saved_at |

---

## 关系类型及定义

### 1. 一对多 (1:N) 关系（16个）

#### 实体→表映射

| 关系 | 类型 | 示例 | 说明 |
|------|------|------|------|
| USERS → RECIPES | 1:N | 一个用户创建多个食谱 | 用户作为创建者 |
| RECIPES → COOKING_STEPS | 1:N | 一个食谱有多个步骤 | 一对多 |
| RECIPES → RATINGS | 1:N | 一个食谱接收多个评分 | 一对多 |
| RECIPES → COMMENTS | 1:N | 一个食谱接收多个评论 | 一对多 |
| USERS → FOLLOWERS | 1:N | 一个用户被多人关注 | 被关注者为"1" |
| USERS → RECIPE_COLLECTIONS | 1:N | 一个用户创建多个清单 | 一对多 |
| USERS → SHOPPING_LISTS | 1:N | 一个用户创建多个购物清单 | 一对多 |
| USERS → MEAL_PLANS | 1:N | 一个用户创建多个膳食计划 | 一对多 |
| RECIPE_COLLECTIONS → COLLECTION_RECIPES | 1:N | 一个清单包含多个食谱 | 通过关系表 |
| SHOPPING_LISTS → SHOPPING_LIST_ITEMS | 1:N | 一个购物清单包含多个项 | 通过关系表 |
| MEAL_PLANS → MEAL_PLAN_ENTRIES | 1:N | 一个计划包含多个食谱 | 通过三元关系表 |

### 2. 多对多 (N:M) 关系（8个，**复合主键设计**）⭐

#### ⭐ 关系1：USERS ↔ ALLERGENS (通过 USER_ALLERGIES)

**ER表示**：
```
    USERS (1)
      |
      | N:M
      |
   USER_ALLERGIES (主键: user_id, allergen_id)
      |
      | N:M
      |
   ALLERGENS (1)
```

**语义**：
- 一个用户可以标记多个过敏原
- 一个过敏原可以被多个用户标记
- 同一用户同一过敏原仅记录一次（复合主键保证）

**实际例子**：
```
用户1：花生、乳制品
用户2：乳制品、芝麻
用户3：花生
```

#### ⭐ 关系2：RECIPES ↔ INGREDIENTS (通过 RECIPE_INGREDIENTS)

**ER表示**：
```
    RECIPES (1)
      |
      | N:M
      |
RECIPE_INGREDIENTS (主键: recipe_id, ingredient_id)
      |
      | N:M
      |
   INGREDIENTS (1)
```

**额外属性**：quantity, unit_id, notes

**例子**：
```
食谱1（番茄鸡蛋面）：
  - 番茄 2个
  - 鸡蛋 1个
  - 面条 100克

食谱2（番茄汤）：
  - 番茄 5个
  - 洋葱 1个
```

#### ⭐ 关系3：INGREDIENTS ↔ ALLERGENS (通过 INGREDIENT_ALLERGENS)

| 属性 | 含义 |
|------|------|
| ingredient_id | 食材ID |
| allergen_id | 过敏原ID |
| allergen_level | 过敏原等级（高/中/低） |

**用途**：标记食材包含的过敏原

#### ⭐ 关系4：RECIPES ↔ TAGS (通过 RECIPE_TAGS)

**用途**：给食谱打多个分类标签（素食、低脂、快手等）

#### ⭐ 关系5：INGREDIENTS ↔ INGREDIENTS (自引用N:M)

通过 INGREDIENT_SUBSTITUTIONS 表实现

```
主键：(original_ingredient_id, substitute_ingredient_id)
```

**示例**：
```
黄油 ↔ 油（比例 1:1）
牛奶 ↔ 豆浆（比例 1:1）
面粉 ↔ 玉米粉（比例 1:0.8）
```

**特点**：自引用 N:M 关系

#### ⭐ 关系6：RECIPE_COLLECTIONS ↔ RECIPES (通过 COLLECTION_RECIPES)

用户的食谱收藏清单

#### ⭐ 关系7：SHOPPING_LISTS ↔ INGREDIENTS (通过 SHOPPING_LIST_ITEMS)

购物清单中的食材项

#### ⭐ 关系8：MEAL_PLANS ↔ RECIPES (通过 MEAL_PLAN_ENTRIES - **三元关系**)

**特殊设计**：**三元N:M关系**

```
主键：(plan_id, recipe_id, meal_date)
```

**业务含义**：
- 同一个计划、同一个食谱可以在**不同日期**出现多次
- 但同一日期同一食谱仅出现一次
- 支持多个餐型（早/午/晚）

**例子**：
```
计划1（周一食谱）：
  周一早餐：食谱A
  周一午餐：食谱B
  周二早餐：食谱A（重复）
```

### 3. 一对一 (1:1) 关系（1个）

**RECIPES ↔ NUTRITION_INFO**

```sql
NUTRITION_INFO.recipe_id 有 UNIQUE 约束
```

每个食谱最多有一条营养信息

---

## N:M关系规范化设计

### 修改前 vs 修改后对比

#### ❌ 修改前设计（违反BCNF）

```sql
-- 使用代理键 + 唯一约束
CREATE TABLE RECIPE_INGREDIENTS (
    recipe_ingredient_id NUMBER(10) PRIMARY KEY,  -- 冗余代理键
    recipe_id NUMBER(10),
    ingredient_id NUMBER(10),
    unit_id NUMBER(10),
    quantity NUMBER(10,2),
    UNIQUE (recipe_id, ingredient_id)              -- 真实主键被降级
);
```

**问题**：
- ❌ recipe_ingredient_id 是冗余的，业务中不需要
- ❌ 数据库无法强制防止重复（只有唯一约束）
- ❌ 违反 BCNF（（recipe_id, ingredient_id）也能作为主键）
- ❌ 表空间浪费（多一列索引和存储）

#### ✅ 修改后设计（符合BCNF）

```sql
-- 直接使用复合主键
CREATE TABLE RECIPE_INGREDIENTS (
    recipe_id NUMBER(10),
    ingredient_id NUMBER(10),
    unit_id NUMBER(10),
    quantity NUMBER(10,2) NOT NULL,
    notes VARCHAR2(255),
    PRIMARY KEY (recipe_id, ingredient_id),        -- 业务主键
    FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id),
    FOREIGN KEY (ingredient_id) REFERENCES INGREDIENTS(ingredient_id),
    FOREIGN KEY (unit_id) REFERENCES UNITS(unit_id)
);
```

**优势**：
- ✅ 清晰的业务语义
- ✅ 数据库层强制唯一性
- ✅ 符合 BCNF 规范
- ✅ 节省存储空间
- ✅ 性能更优

### 8个修改的表总结

| 表名 | 修改前主键 | 修改后主键 | 优势 |
|------|-----------|-----------|------|
| USER_ALLERGIES | user_allergy_id | (user_id, allergen_id) | 语义清晰 |
| RECIPE_INGREDIENTS | recipe_ingredient_id | (recipe_id, ingredient_id) | 清除冗余 |
| INGREDIENT_ALLERGENS | ingredient_allergen_id | (ingredient_id, allergen_id) | BCNF |
| RECIPE_TAGS | recipe_tag_id | (recipe_id, tag_id) | 性能优化 |
| INGREDIENT_SUBSTITUTIONS | substitution_id | (original_id, substitute_id) | 自引用规范 |
| COLLECTION_RECIPES | collection_recipe_id | (collection_id, recipe_id) | 主键精准 |
| SHOPPING_LIST_ITEMS | item_id | (list_id, ingredient_id) | 消除代理键 |
| MEAL_PLAN_ENTRIES | entry_id | (plan_id, recipe_id, meal_date) | 三元主键 |

---

## 业务流程关系图

### 流程1：食谱发布与浏览

```
用户(USERS)
    |
    ├─→ 发布 ─→ 食谱(RECIPES)
    |              |
    |              ├─→ 包含 ─→ 食材(INGREDIENTS)
    |              |   [通过 RECIPE_INGREDIENTS]
    |              |
    |              ├─→ 包含 ─→ 烹饪步骤(COOKING_STEPS)
    |              |
    |              ├─→ 含有 ─→ 标签(TAGS)
    |              |   [通过 RECIPE_TAGS]
    |              |
    |              └─→ 提供 ─→ 营养信息(NUTRITION_INFO)
    |
    └─→ 浏览评价
           |
           ├─→ 评分(RATINGS)
           ├─→ 评论(COMMENTS)
           └─→ 收藏(SAVED_RECIPES)
```

### 流程2：膳食规划与购物

```
用户(USERS)
    |
    ├─→ 创建 ─→ 膳食计划(MEAL_PLANS)
    |              |
    |              └─→ 包含 ─→ 食谱(RECIPES)
    |                  [通过 MEAL_PLAN_ENTRIES - 三元N:M]
    |
    └─→ 生成购物清单(SHOPPING_LISTS)
           |
           └─→ 包含 ─→ 食材(INGREDIENTS)
               [通过 SHOPPING_LIST_ITEMS]
```

### 流程3：过敏原管理

```
用户(USERS)
    |
    ├─→ 标记 ─→ 过敏原(ALLERGENS)
    |       [通过 USER_ALLERGIES]
    |
    └─→ 查询安全食谱
           |
           └─→ 食谱(RECIPES)
               |
               ├─→ 食材(INGREDIENTS)
               |   [通过 RECIPE_INGREDIENTS]
               |
               └─→ 过敏原(ALLERGENS)
                   [通过 INGREDIENT_ALLERGENS]
```

---

## 设计决策与亮点

### 亮点1：N:M关系的规范化设计

**决策**：8个N:M关系全部采用复合主键

**理由**：
- ✅ 符合BCNF最高规范化
- ✅ 消除不必要的代理键
- ✅ 提升数据完整性

**影响**：
- ✅ 表大小减少 8 列
- ✅ 索引数量减少
- ✅ 查询性能提升

### 亮点2：三元N:M关系 (MEAL_PLAN_ENTRIES)

**设计**：(plan_id, recipe_id, meal_date) 三元主键

**业务支持**：
- 同一食谱在同一计划中可以在不同日期出现
- 同一日期可以有多个食谱（不同餐型）
- 自动防止重复（一天同一个食谱仅一次）

### 亮点3：自引用N:M关系 (INGREDIENT_SUBSTITUTIONS)

**设计**：(original_id, substitute_id) 指向同一个 INGREDIENTS

**用途**：
- 管理食材替代关系
- 支持复杂烹饪场景

### 亮点4：双候选键设计 (USERS)

**USERS**：
- 主键：user_id (代理键，数据库性能)
- 候选键：username (业务唯一)
- 候选键：email (业务唯一)

**权衡**：
- ✅ 支持用户登录（通过 username 或 email）
- ✅ 数据库性能（使用 user_id 作FK）
- ✅ 业务灵活性

### 亮点5：冗余性能字段

**USERS**：
- `total_followers` 冗余字段
- `total_recipes` 冗余字段

**RECIPES**：
- `rating_count` 冗余字段
- `average_rating` 冗余字段

**维护策略**：通过 Oracle 触发器自动维护

**权衡**：
- ✅ 读取性能：O(1) 而不是 O(n)
- ✅ 存储成本：少量增加
- ✅ 维护成本：触发器自动处理

### 亮点6：逻辑删除策略

**RECIPES**：is_deleted 字段（'Y'/'N'）

**COMMENTS**：is_deleted 字段（'Y'/'N'）

**优势**：
- ✅ 保留审计日志
- ✅ 支持数据恢复
- ✅ 不破坏外键关系

---

## 与前版本对比

### 核心数据对比

| 指标 | 前版本 | 现版本 | 改进 |
|------|--------|--------|------|
| **表数量** | 26 | 26 | - |
| **代理键数** | 16 | 8 | -8 (-50%) |
| **复合主键** | 1 | 9 | +8 |
| **三元主键** | 0 | 1 | +1 |
| **规范化级别** | 3NF | BCNF | 最高级 |
| **N:M关系规范性** | 部分 | 完全 | ✅ 完全规范 |

### 设计对比表

| 特性 | 前版本 | 现版本 |
|-----|--------|--------|
| **RECIPE_INGREDIENTS** | 有 recipe_ingredient_id | 使用 (recipe_id, ingredient_id) |
| **USER_ALLERGIES** | 有 user_allergy_id | 使用 (user_id, allergen_id) |
| **MEAL_PLAN_ENTRIES** | 有 entry_id | 使用 (plan_id, recipe_id, meal_date) |
| **规范化严格性** | 中等 | 严格 (BCNF) |
| **存储效率** | 基础 | 优化 (+8列减少) |
| **数据完整性** | 约束 | 主键强制 |

---

## 总结

### 26个表的分类

| 分类 | 数量 | 包含 |
|-----|------|------|
| 强实体 | 11 | USERS, INGREDIENTS, RECIPES 等 |
| 弱实体 | 5 | COMMENTS, RATINGS, FOLLOWERS 等 |
| **N:M关系表** | **8** | **采用复合/三元主键** |
| 一对多关系 | - | 通过FK实现 |
| **总计** | **26** | **完整业务支持** |

### 关键特征

✅ **完全BCNF规范化**
- 所有依赖关系都是函数依赖
- 无冗余代理键
- 业务主键即数据库主键

✅ **8个N:M关系规范设计**
- 二元复合主键 (7个)
- 三元复合主键 (1个)
- 消除代理键冗余
- 数据库层强制唯一性

✅ **30+个完整关系**
- 1:N 关系 (16个)
- N:M 关系 (8个)
- 1:1 关系 (1个)
- 自引用关系 (多个)

✅ **完整的业务支持**
- 食谱发布、评价、收藏
- 膳食规划、购物清单
- 用户社交、关注
- 过敏原管理

