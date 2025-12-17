# AllRecipes 食谱网站 - 数据库设计与实现报告

## 目录

### 1. 设计部分

1.1 项目背景介绍 
1.2 ER图设计（概念模型）
1.3 数据库库表设计（逻辑模型） 
1.4 规范化
1.5 常见操作归纳
1.6 完整性约束方案设计
1.7 表的详细设计（物理模型）
1.8 视图设计方案
1.9 数据库安全方案的设计

### 2. 实现部分
2.1 表格创建（含约束条件）
2.2 数据录入
2.3 视图创建和使用
2.4 常见操作的实例演示
2.5 数据库安全的实现

### 3. 总结
3.1 组员分工
3.2 难点与不足分析
3.3 收获或体会及建议

---

# 第一部分：设计部分

## 1.1 项目背景介绍

### 1.1.1 AllRecipes 网站概述

AllRecipes 是全球最大的食谱分享平台之一，拥有数百万用户和数百万条食谱。该网站以其用户友好的界面、丰富的食谱内容和强大的社区功能而闻名。

**核心业务功能：**

- **食谱发布与分享**：用户可以上传自己创作的食谱，包括详细的食材清单、烹饪步骤、烹饪时间、难度等级等信息，并支持上传高质量的图片。
- **多维度食谱搜索与浏览**：用户通过关键词、菜系、食材、难度级别、烹饪时间等多个维度进行灵活搜索，发现适合自己的食谱。
- **用户交互与社交功能**：包括食谱评价、评论、收藏、关注其他用户等丰富的互动方式，建立活跃的社区文化。
- **个性化食谱管理**：用户可以创建多个食谱收藏清单、购物清单、膳食计划等，提高烹饪的便利性和计划性。
- **健康饮食支持**：系统支持用户管理过敏原信息、查看营养信息、推荐过敏源安全食谱等功能。

### 1.1.2 核心业务数据

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

## 1.2 ER图设计（概念模型）

### 1.2.1 ER图架构概览

本数据库系统包含 **26 个核心表**，分为以下功能模块：

```
┌─────────────────────────────────────────────────────────────┐
│                     核心基础模块 (5个表)                      │
│        USERS / INGREDIENTS / UNITS / ALLERGENS / TAGS        │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                     食谱核心模块 (6个表)                      │
│  RECIPES / RECIPE_INGREDIENTS / COOKING_STEPS / NUTRITION_INFO
│     INGREDIENT_ALLERGENS / INGREDIENT_SUBSTITUTIONS          │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                    用户交互模块 (8个表)                      │
│  RATINGS / RATING_HELPFULNESS / COMMENTS / COMMENT_HELPFULNESS
│  SAVED_RECIPES / FOLLOWERS / USER_ALLERGIES / RECIPE_TAGS    │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                    个人管理模块 (6个表)                      │
│  RECIPE_COLLECTIONS / COLLECTION_RECIPES
│  SHOPPING_LISTS / SHOPPING_LIST_ITEMS
│  MEAL_PLANS / MEAL_PLAN_ENTRIES
└─────────────────────────────────────────────────────────────┘
```

*(此处应插入ER图图片)*

## 1.3 数据库库表设计（逻辑模型）

### 1.3.1 关系模式设计

本系统采用关系型数据库模型，核心关系模式如下（下划线表示主键，斜体表示外键）：

1.  **用户(Users)**: (<u>user_id</u>, username, email, password_hash, ...)
2.  **食谱(Recipes)**: (<u>recipe_id</u>, *user_id*, recipe_name, description, ...)
3.  **食谱食材(Recipe_Ingredients)**: (<u>*recipe_id*, *ingredient_id*</u>, *unit_id*, quantity, notes)
4.  **评价(Ratings)**: (<u>rating_id</u>, *user_id*, *recipe_id*, rating_value, ...)
5.  **关注(Followers)**: (<u>*user_id*, *follower_user_id*</u>, followed_at)

### 1.3.2 核心设计变更说明（v2.0 → v3.0）

在逻辑模型设计过程中，我们针对多对多关系进行了优化，从“代理主键”变更为“联合主键”。

**变更案例：RECIPE_INGREDIENTS 表**

*   **旧设计 (v2.0)**: 使用 `recipe_ingredient_id` 作为主键，`(recipe_id, ingredient_id)` 作为唯一约束。存在数据冗余和不必要的索引。
*   **新设计 (v3.0)**: 直接使用 `(recipe_id, ingredient_id)` 作为联合主键。
    *   **优势**: 消除冗余ID字段，节省存储空间；主键自动强制唯一性；完全符合BCNF规范；查询性能更优。

## 1.4 规范化

本设计严格遵循 **BCNF（Boyce-Codd Normal Form）** 规范：

- **第一范式（1NF）**：所有字段包含原子值，不可再分。
- **第二范式（2NF）**：所有非主键字段完全依赖于主键（特别是针对联合主键的表，如 `RECIPE_INGREDIENTS`，`quantity` 依赖于 `recipe_id` 和 `ingredient_id` 的组合）。
- **第三范式（3NF）**：消除了所有传递依赖。例如，在 `RECIPES` 表中，用户信息只存储 `user_id`，而不存储 `username`（通过连接查询获取），避免了数据冗余。
- **BCNF**：消除了所有异常依赖，主键是唯一的候选键。

## 1.5 常见操作归纳

基于业务需求，系统需要支持以下核心操作：

1.  **用户管理**：注册、登录、更新个人资料、关注/取消关注用户。
2.  **食谱管理**：
    *   **发布食谱**：事务性操作，涉及插入 `RECIPES` 表以及关联的 `RECIPE_INGREDIENTS`、`COOKING_STEPS` 表。
    *   **搜索食谱**：基于名称、食材、标签的复杂查询。
    *   **更新/删除食谱**：级联更新或软删除。
3.  **交互操作**：
    *   **评价与评论**：用户对食谱打分和留言。
    *   **收藏**：将食谱添加到收藏夹。
4.  **个人规划**：
    *   **创建膳食计划**：为特定日期安排食谱。
    *   **生成购物清单**：根据膳食计划自动汇总所需食材。

## 1.6 完整性约束方案设计

### 1.6.1 主键约束 (Primary Key)
- 单字段主键：如 `USERS(user_id)`，使用序列自增。
- 联合主键：如 `RECIPE_INGREDIENTS(recipe_id, ingredient_id)`，确保关系的唯一性。

### 1.6.2 外键约束 (Foreign Key)
- 维护表之间的引用完整性。
- 设置级联删除（`ON DELETE CASCADE`）：例如删除用户时，自动删除其发布的食谱、评价和关注关系。
- 设置限制删除（`ON DELETE RESTRICT`）：部分关键数据可能需要防止误删。

### 1.6.3 检查约束 (Check Constraint)
- **数值范围**：`rating_value` 必须在 0-5 之间。
- **枚举值**：`account_status` 必须为 'active', 'inactive', 'suspended'。
- **逻辑判断**：`start_date` 必须小于等于 `end_date`。
- **自引用逻辑**：用户不能关注自己 (`user_id != follower_user_id`)。

### 1.6.4 唯一约束 (Unique Constraint)
- `username` 和 `email` 必须全局唯一。
- `ingredient_name` 必须唯一。

## 1.7 表的详细设计（物理模型）

以下列举部分核心表的物理设计（以Oracle数据库为例）：

**表名：USERS（用户表）**

| 字段名 | 数据类型 | 长度 | 约束 | 说明 |
|---|---|---|---|---|
| user_id | NUMBER | 10 | PK | 用户ID |
| username | VARCHAR2 | 50 | UK, NN | 用户名 |
| email | VARCHAR2 | 100 | UK, NN | 邮箱 |
| password_hash | VARCHAR2 | 255 | NN | 密码哈希 |
| join_date | DATE | - | DEFAULT SYSDATE | 加入日期 |

**表名：RECIPES（食谱表）**

| 字段名 | 数据类型 | 长度 | 约束 | 说明 |
|---|---|---|---|---|
| recipe_id | NUMBER | 10 | PK | 食谱ID |
| user_id | NUMBER | 10 | FK, NN | 发布者ID |
| recipe_name | VARCHAR2 | 200 | NN | 食谱名称 |
| is_published | VARCHAR2 | 1 | 'Y'/'N' | 是否发布 |

**表名：RECIPE_INGREDIENTS（食谱食材关联表）**

| 字段名 | 数据类型 | 长度 | 约束 | 说明 |
|---|---|---|---|---|
| recipe_id | NUMBER | 10 | PK, FK | 食谱ID |
| ingredient_id | NUMBER | 10 | PK, FK | 食材ID |
| unit_id | NUMBER | 10 | FK | 单位ID |
| quantity | NUMBER | 10,2 | NN | 数量 |

## 1.8 视图设计方案

为了简化复杂查询并提供数据安全性，设计了以下视图：

1.  **RECIPE_DETAIL_VIEW（食谱详情视图）**：
    *   **功能**：整合食谱基本信息和作者信息。
    *   **逻辑**：连接 `RECIPES` 和 `USERS` 表，过滤未发布和已删除的食谱。
2.  **USER_RECIPE_STATS（用户统计视图）**：
    *   **功能**：统计用户的食谱发布数、平均评分、总获赞数。
    *   **逻辑**：聚合查询 `RECIPES` 表数据。
3.  **SAFE_RECIPES_FOR_USER（安全食谱视图）**：
    *   **功能**：基于用户过敏原设置，动态筛选安全的食谱。
    *   **逻辑**：排除包含用户过敏食材的食谱。

## 1.9 数据库安全方案的设计

### 1.9.1 用户与角色体系
- **数据库管理员 (DBA)**：拥有所有表的增删改查及DDL权限。
- **应用服务账号 (APP_USER)**：拥有业务表的读写权限，用于后端API连接。
- **只读分析账号 (ANALYST)**：仅拥有对视图和部分表的 SELECT 权限，用于数据分析。

### 1.9.2 权限控制
- 最小权限原则：应用账号仅授予必要的 `SELECT`, `INSERT`, `UPDATE`, `DELETE` 权限。
- 敏感数据保护：密码字段 (`password_hash`) 仅应用账号可写，普通查询不可见。

---

# 第二部分：实现部分

## 2.1 表格创建（可同时包括约束条件的创建）

使用 SQL DDL 语句创建数据库对象。首先创建序列（Sequence）以支持主键自增，然后创建表（Table）并定义约束。

**代码片段示例：**

```sql
-- 创建序列
CREATE SEQUENCE seq_users START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_recipes START WITH 1 INCREMENT BY 1;

-- 创建用户表
CREATE TABLE USERS (
    user_id NUMBER(10) PRIMARY KEY,
    username VARCHAR2(50) NOT NULL UNIQUE,
    email VARCHAR2(100) NOT NULL UNIQUE,
    password_hash VARCHAR2(255) NOT NULL,
    -- ... 其他字段
    CONSTRAINT ck_account_status CHECK (account_status IN ('active', 'inactive', 'suspended'))
);

-- 创建食谱表（含外键）
CREATE TABLE RECIPES (
    recipe_id NUMBER(10) PRIMARY KEY,
    user_id NUMBER(10) NOT NULL,
    -- ... 其他字段
    CONSTRAINT fk_recipes_user FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE
);
```

*(此处可插入运行 createtable.sql 的截图)*

## 2.2 数据录入

数据录入主要通过 `INSERT` 语句或封装好的存储过程进行。

**基础数据录入（字典表）：**
```sql
INSERT INTO UNITS (unit_id, unit_name, abbreviation) VALUES (seq_units.NEXTVAL, '克', 'g');
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category) VALUES (seq_ingredients.NEXTVAL, '番茄', '蔬菜');
```

**业务数据录入（使用存储过程）：**
```sql
-- 调用存储过程发布食谱
DECLARE
    v_result VARCHAR2(200);
BEGIN
    publish_recipe(
        p_user_id => 1,
        p_recipe_name => '番茄炒蛋',
        p_description => '经典家常菜',
        -- ... 参数
        p_result => v_result
    );
END;
```

*(此处可插入数据录入后的 SELECT 查询结果截图)*

## 2.3 视图创建和使用

**视图创建 SQL：**
```sql
CREATE OR REPLACE VIEW RECIPE_DETAIL_VIEW AS
SELECT 
    r.recipe_id, r.recipe_name, u.username AS creator_name
FROM RECIPES r
JOIN USERS u ON r.user_id = u.user_id
WHERE r.is_published = 'Y';
```

**视图查询演示：**
```sql
SELECT * FROM RECIPE_DETAIL_VIEW WHERE recipe_name LIKE '%番茄%';
```

*(此处可插入视图查询结果截图)*

## 2.4 常见操作的实例演示

### 2.4.1 复杂查询：查找包含特定食材的食谱
```sql
SELECT r.recipe_name
FROM RECIPES r
JOIN RECIPE_INGREDIENTS ri ON r.recipe_id = ri.recipe_id
JOIN INGREDIENTS i ON ri.ingredient_id = i.ingredient_id
WHERE i.ingredient_name = '番茄';
```

### 2.4.2 事务操作：添加食谱食材
```sql
-- 演示向食谱添加食材，如果违反唯一约束（联合主键）会报错
BEGIN
    add_recipe_ingredient(1, 101, 5, 200, '切块', v_out);
END;
```

*(此处可插入操作演示截图)*

## 2.5 数据库安全的实现

**创建角色与用户：**
```sql
-- 创建应用角色
CREATE ROLE app_role;
-- 授权
GRANT CONNECT, RESOURCE TO app_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON USERS TO app_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON RECIPES TO app_role;

-- 创建具体用户并分配角色
CREATE USER recipe_app IDENTIFIED BY password123;
GRANT app_role TO recipe_app;
```

---

# 第三部分：总结

## 3.1 组员分工

*   **[组员姓名]**：负责需求分析、ER图设计、文档编写（设计部分）。
*   **[组员姓名]**：负责数据库逻辑设计、规范化分析、SQL脚本编写（建表与数据插入）。
*   **[组员姓名]**：负责存储过程开发、视图设计、安全方案实现、文档编写（实现与总结部分）。

## 3.2 难点与不足分析

**难点：**
1.  **多对多关系的处理**：在设计初期，对于食谱与食材、用户与关注者等多对多关系，我们在选择“代理主键”还是“联合主键”上进行了深入讨论。最终为了符合BCNF规范并减少冗余，选择了联合主键，但这增加了外键引用的复杂性。
2.  **复杂业务逻辑的SQL实现**：如“生成购物清单”功能，需要根据膳食计划聚合食材数量，涉及多表连接和分组运算，编写存储过程时逻辑较为复杂。

**不足：**
1.  **性能优化尚浅**：虽然建立了索引，但未在大数据量下进行压力测试，对于千万级数据的查询性能尚无实测数据。
2.  **缺乏分区设计**：对于日志表（USER_ACTIVITY_LOG）等增长极快的表，目前未设计分区策略，长期运行可能影响性能。

## 3.3 收获或体会及建议

**收获：**
通过本次数据库课程设计，我们深入理解了从概念模型（ER图）到逻辑模型再到物理实现的完整流程。特别是对数据库规范化理论（BCNF）有了实践层面的认识，明白了良好的设计如何避免数据异常。同时，熟练掌握了 Oracle 数据库的 PL/SQL 编程，能够编写复杂的存储过程和触发器。

**建议：**
建议在未来的课程中，增加关于数据库性能调优（如执行计划分析）和非关系型数据库（如 Redis 缓存）结合使用的实践内容，以适应现代互联网高并发应用的需求。
