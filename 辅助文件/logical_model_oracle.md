# AllRecipes 食谱网站 - 数据库逻辑模型设计文档（修订版v3.0）

## 目录

1. [概述](#概述)
2. [表设计原则](#表设计原则)
3. [核心基础表](#核心基础表)
4. [食谱核心表](#食谱核心表)
5. [用户交互表](#用户交互表)
6. [个人管理表](#个人管理表)
7. [多对多关系联合主键设计](#多对多关系联合主键设计)
8. [表间关系详解](#表间关系详解)

---

# 概述

本文档详细描述AllRecipes食谱网站数据库的逻辑模型，包含**26个核心表**的完整设计。本版本（v3.0）重点修改了多对多关系的设计方案，采用**联合主键**而不是弱实体ID方案。

**总体统计：**
- 表数量：26个
- 字段总数：200+
- 主键数：26个
- 外键关系：30+个
- **多对多关系采用联合主键：8个**
- 数据规范化等级：BCNF（Boyce-Codd Normal Form）

---

# 表设计原则

## 1. 规范化原则

本设计严格遵循数据库规范化理论：

- **第一范式（1NF）**：每个字段包含原子值，不可再分
- **第二范式（2NF）**：在1NF基础上，所有非主键字段完全依赖于主键
- **第三范式（3NF）**：在2NF基础上，消除所有传递依赖
- **BCNF**：消除所有的异常依赖

## 2. 命名规范

| 元素 | 规范 | 示例 |
|-----|------|------|
| 表名 | 大写，复数形式 | USERS, RECIPES |
| 列名 | 大写，用下划线分隔 | USER_ID, RECIPE_NAME |
| 主键 | {表名}_ID或联合主键 | USER_ID或(RECIPE_ID, INGREDIENT_ID) |
| 外键 | {被引用表名}_ID | USER_ID (in RECIPES) |
| 时间戳 | CREATED_AT, UPDATED_AT | - |

## 3. 多对多关系处理策略

**传统方法（v2.0）：** 使用单独的ID字段作为主键
```sql
CREATE TABLE RECIPE_INGREDIENTS (
    recipe_ingredient_id NUMBER(10) PRIMARY KEY,
    recipe_id NUMBER(10) NOT NULL,
    ingredient_id NUMBER(10) NOT NULL,
    UNIQUE (recipe_id, ingredient_id)
)
```

**改进方法（v3.0）：** 使用联合外键作为主键
```sql
CREATE TABLE RECIPE_INGREDIENTS (
    recipe_id NUMBER(10) NOT NULL,
    ingredient_id NUMBER(10) NOT NULL,
    PRIMARY KEY (recipe_id, ingredient_id),
    FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id),
    FOREIGN KEY (ingredient_id) REFERENCES INGREDIENTS(ingredient_id)
)
```

**优势：**
- ✅ 更简洁的主键设计
- ✅ 消除冗余的ID字段
- ✅ 自动防止重复关联
- ✅ 查询性能更优
- ✅ 符合BCNF规范

---

# 核心基础表

## 1. USERS 表（用户表）

**用途**：存储所有注册用户的基本信息

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| USER_ID | NUMBER(10) | ✓ | ✓ | PK | 用户唯一标识，自增 |
| USERNAME | VARCHAR2(50) | ✓ | | UK | 用户名，唯一 |
| EMAIL | VARCHAR2(100) | ✓ | | UK | 邮箱，唯一，用于登录和验证 |
| PASSWORD_HASH | VARCHAR2(255) | ✓ | | | 加密后的密码哈希值 |
| FIRST_NAME | VARCHAR2(50) | | | | 用户名字 |
| LAST_NAME | VARCHAR2(50) | | | | 用户姓氏 |
| BIO | VARCHAR2(500) | | | | 个人简介或专业资格描述 |
| PROFILE_IMAGE | VARCHAR2(255) | | | | 头像图片URL |
| JOIN_DATE | DATE | ✓ | | | 注册日期 |
| LAST_LOGIN | TIMESTAMP | | | | 最后登录时间 |
| ACCOUNT_STATUS | VARCHAR2(20) | ✓ | | CK | active/inactive/suspended |
| TOTAL_FOLLOWERS | NUMBER(10) | ✓ | | DF=0 | 粉丝数量（冗余字段用于性能） |
| TOTAL_RECIPES | NUMBER(10) | ✓ | | DF=0 | 发布的食谱数量（冗余字段用于性能） |
| CREATED_AT | TIMESTAMP | ✓ | | DF=SYSDATE | 创建记录时间 |
| UPDATED_AT | TIMESTAMP | ✓ | | DF=SYSDATE | 最后修改时间 |

---

## 2. INGREDIENTS 表（食材表）

**用途**：维护系统中所有可用食材的基础库

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| INGREDIENT_ID | NUMBER(10) | ✓ | ✓ | PK | 食材唯一标识 |
| INGREDIENT_NAME | VARCHAR2(100) | ✓ | | UK | 食材名称（如：番茄、鸡蛋） |
| CATEGORY | VARCHAR2(50) | ✓ | | | 食材分类（蔬菜、肉类、调味料等） |
| DESCRIPTION | VARCHAR2(255) | | | | 食材描述和特性 |
| CREATED_AT | TIMESTAMP | ✓ | | DF=SYSDATE | 创建时间 |

---

## 3. UNITS 表（单位表）

**用途**：定义烹饪中使用的所有计量单位

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| UNIT_ID | NUMBER(10) | ✓ | ✓ | PK | 单位唯一标识 |
| UNIT_NAME | VARCHAR2(50) | ✓ | | UK | 单位名称（如：克、毫升、杯） |
| ABBREVIATION | VARCHAR2(20) | | | | 单位缩写（如：g, ml, cup） |
| DESCRIPTION | VARCHAR2(100) | | | | 单位描述和转换信息 |
| CREATED_AT | TIMESTAMP | ✓ | | DF=SYSDATE | 创建时间 |

---

## 4. ALLERGENS 表（过敏原表）

**用途**：维护所有已知的可能引起过敏的物质

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| ALLERGEN_ID | NUMBER(10) | ✓ | ✓ | PK | 过敏原唯一标识 |
| ALLERGEN_NAME | VARCHAR2(100) | ✓ | | UK | 过敏原名称（花生、坚果、乳制品等） |
| DESCRIPTION | VARCHAR2(255) | | | | 过敏原详细描述和影响 |
| CREATED_AT | TIMESTAMP | ✓ | | DF=SYSDATE | 创建时间 |

---

## 5. TAGS 表（标签表）

**用途**：维护系统中所有可用的标签

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| TAG_ID | NUMBER(10) | ✓ | ✓ | PK | 标签唯一标识 |
| TAG_NAME | VARCHAR2(50) | ✓ | | UK | 标签名称（如：素食、低脂、快手菜） |
| TAG_DESCRIPTION | VARCHAR2(255) | | | | 标签描述 |
| CREATED_AT | TIMESTAMP | ✓ | | DF=SYSDATE | 创建时间 |

---

# 食谱核心表

## 6. RECIPES 表（食谱表）

**用途**：存储所有食谱的核心信息

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| RECIPE_ID | NUMBER(10) | ✓ | ✓ | PK | 食谱唯一标识 |
| USER_ID | NUMBER(10) | ✓ | | FK | 创建者用户ID |
| RECIPE_NAME | VARCHAR2(200) | ✓ | | | 食谱名称 |
| DESCRIPTION | VARCHAR2(1000) | | | | 详细描述 |
| CUISINE_TYPE | VARCHAR2(50) | | | | 菜系（中式、西式、日式等） |
| MEAL_TYPE | VARCHAR2(20) | | | CK | breakfast/lunch/dinner/snack/dessert |
| DIFFICULTY_LEVEL | VARCHAR2(20) | | | CK | easy/medium/hard |
| PREP_TIME | NUMBER(5) | | | | 准备时间（分钟） |
| COOK_TIME | NUMBER(5) | ✓ | | CK>0 | 烹饪时间（分钟） |
| TOTAL_TIME | NUMBER(5) | | | | 总时间（分钟） |
| SERVINGS | NUMBER(5) | | | | 份数 |
| CALORIES_PER_SERVING | NUMBER(10) | | | | 每份热量 |
| IMAGE_URL | VARCHAR2(255) | | | | 食谱主图URL |
| IS_PUBLISHED | VARCHAR2(1) | ✓ | | CK | Y/N，是否发布 |
| IS_DELETED | VARCHAR2(1) | ✓ | | CK | Y/N，逻辑删除 |
| VIEW_COUNT | NUMBER(10) | | | DF=0 | 浏览次数 |
| RATING_COUNT | NUMBER(10) | | | DF=0 | 评价数量 |
| AVERAGE_RATING | NUMBER(3,2) | | | DF=0 | 平均评分(0-5) |
| CREATED_AT | TIMESTAMP | ✓ | | DF=SYSDATE | 创建时间 |
| UPDATED_AT | TIMESTAMP | ✓ | | DF=SYSDATE | 最后更新时间 |

**业务规则**：
- USER_ID是非空的，一个食谱必须有创建者
- COOK_TIME必须>0
- IS_PUBLISHED和IS_DELETED控制食谱的可见性
- AVERAGE_RATING的范围是0-5，精确到两位小数

---

## 7. RECIPE_INGREDIENTS 表（食谱食材关联表 - **多对多**）

**用途**：定义每个食谱包含的食材及其用量

**关系类型**：N:M（多对多），采用**联合主键**

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| RECIPE_ID | NUMBER(10) | ✓ | ✓(PK1) | FK | 食谱ID，联合主键第一部分 |
| INGREDIENT_ID | NUMBER(10) | ✓ | ✓(PK2) | FK | 食材ID，联合主键第二部分 |
| UNIT_ID | NUMBER(10) | ✓ | | FK | 计量单位ID |
| QUANTITY | NUMBER(10,2) | ✓ | | | 食材用量 |
| NOTES | VARCHAR2(255) | | | | 特殊说明（如：切碎、预先煮沸） |
| ADDED_AT | TIMESTAMP | ✓ | | DF=SYSDATE | 添加时间 |

**关键特性**：
- **主键**：(RECIPE_ID, INGREDIENT_ID) 的复合主键
- **自动唯一性**：同一食谱中同一食材只能出现一次
- **不需要额外ID字段**：联合主键直接作为主键
- **外键约束**：
  - RECIPE_ID → RECIPES(RECIPE_ID) ON DELETE CASCADE
  - INGREDIENT_ID → INGREDIENTS(INGREDIENT_ID)
  - UNIT_ID → UNITS(UNIT_ID)

**业务规则**：
- 一个食谱可以包含多个食材
- 一个食材可以在多个食谱中使用
- 同一食谱中同一食材不能重复添加
- 删除食谱时，其所有食材关联也删除

---

## 8. COOKING_STEPS 表（烹饪步骤表）

**用途**：存储食谱的详细烹饪步骤

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| STEP_ID | NUMBER(10) | ✓ | ✓ | PK | 步骤唯一标识 |
| RECIPE_ID | NUMBER(10) | ✓ | | FK | 食谱ID |
| STEP_NUMBER | NUMBER(5) | ✓ | | UK(与RECIPE_ID) | 步骤序号（1,2,3...） |
| INSTRUCTION | VARCHAR2(1000) | ✓ | | | 详细操作说明 |
| TIME_REQUIRED | NUMBER(5) | | | | 该步骤所需时间（分钟） |
| IMAGE_URL | VARCHAR2(255) | | | | 步骤配图URL |

**约束**：
- 外键：FK_CS_RECIPE 引用 RECIPES(RECIPE_ID) ON DELETE CASCADE
- 唯一约束：(RECIPE_ID, STEP_NUMBER) 唯一

---

## 9. NUTRITION_INFO 表（营养信息表）

**用途**：存储食谱的营养成分信息

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| NUTRITION_ID | NUMBER(10) | ✓ | ✓ | PK | 营养信息唯一标识 |
| RECIPE_ID | NUMBER(10) | ✓ | | FK, UK | 食谱ID（一对一关系） |
| CALORIES | NUMBER(10) | | | | 热量（卡路里） |
| PROTEIN_GRAMS | NUMBER(10,2) | | | | 蛋白质（克） |
| CARBS_GRAMS | NUMBER(10,2) | | | | 碳水化合物（克） |
| FAT_GRAMS | NUMBER(10,2) | | | | 脂肪（克） |
| FIBER_GRAMS | NUMBER(10,2) | | | | 纤维（克） |
| SUGAR_GRAMS | NUMBER(10,2) | | | | 糖（克） |
| SODIUM_MG | NUMBER(10) | | | | 钠（毫克） |

---

## 10. INGREDIENT_ALLERGENS 表（食材过敏原关联表 - **多对多**）

**用途**：定义哪些食材含有哪些过敏原

**关系类型**：N:M（多对多），采用**联合主键**

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| INGREDIENT_ID | NUMBER(10) | ✓ | ✓(PK1) | FK | 食材ID，联合主键第一部分 |
| ALLERGEN_ID | NUMBER(10) | ✓ | ✓(PK2) | FK | 过敏原ID，联合主键第二部分 |

**关键特性**：
- **主键**：(INGREDIENT_ID, ALLERGEN_ID) 的复合主键
- **不需要ID字段**：两个外键组成主键
- **自动唯一性**：同一食材的同一过敏原只能记录一次

**业务规则**：
- 一个食材可以含有多个过敏原
- 一个过敏原可能存在于多个食材中
- 帮助系统识别含有用户过敏原的食材，推荐安全食谱

---

## 11. INGREDIENT_SUBSTITUTIONS 表（食材替代品关联表 - **多对多**）

**用途**：定义食材之间的替代关系

**关系类型**：N:M（多对多），采用**联合主键**

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| ORIGINAL_INGREDIENT_ID | NUMBER(10) | ✓ | ✓(PK1) | FK | 原始食材ID，联合主键第一部分 |
| SUBSTITUTE_INGREDIENT_ID | NUMBER(10) | ✓ | ✓(PK2) | FK | 替代食材ID，联合主键第二部分 |
| SUBSTITUTION_RATIO | NUMBER(5,2) | | | | 替代比例（如：1.5表示1:1.5） |
| NOTES | VARCHAR2(255) | | | | 替代说明 |
| ADDED_AT | TIMESTAMP | ✓ | | DF=SYSDATE | 添加时间 |

**关键特性**：
- **主键**：(ORIGINAL_INGREDIENT_ID, SUBSTITUTE_INGREDIENT_ID) 的复合主键
- **检查约束**：original_ingredient_id != substitute_ingredient_id（避免自引用）

**业务规则**：
- 帮助用户在缺少食材时寻找替代品
- 支持食谱的灵活调整
- 替代比例指导用户调整用量

---

# 用户交互表

## 12. RATINGS 表（食谱评价表）

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| RATING_ID | NUMBER(10) | ✓ | ✓ | PK | 评价唯一标识 |
| USER_ID | NUMBER(10) | ✓ | | FK | 评价者用户ID |
| RECIPE_ID | NUMBER(10) | ✓ | | FK | 被评价的食谱ID |
| RATING_VALUE | NUMBER(3,2) | ✓ | | CK | 评分值(0-5) |
| REVIEW_TEXT | VARCHAR2(1000) | | | | 评价文本 |
| RATING_DATE | TIMESTAMP | ✓ | | DF=SYSDATE | 评价时间 |

**唯一约束**：(USER_ID, RECIPE_ID) 唯一，确保每个用户对每个食谱只有一条评价

---

## 13. RATING_HELPFULNESS 表（评价有用性投票表 - **多对多**）

**用途**：记录用户对其他评价的有用性投票

**关系类型**：N:M（多对多），采用**联合主键**

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| RATING_ID | NUMBER(10) | ✓ | ✓(PK1) | FK | 被投票的评价ID，联合主键第一部分 |
| USER_ID | NUMBER(10) | ✓ | ✓(PK2) | FK | 投票者用户ID，联合主键第二部分 |
| HELPFUL_VOTES | NUMBER(10) | | | DF=0 | 有用投票数 |
| VOTED_AT | TIMESTAMP | ✓ | | DF=SYSDATE | 投票时间 |

**关键特性**：
- **主键**：(RATING_ID, USER_ID) 的复合主键
- **自动唯一性**：每个用户对每个评价只能投票一次

---

## 14. COMMENTS 表（评论表）

**用途**：存储用户对食谱的评论，支持嵌套回复

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| COMMENT_ID | NUMBER(10) | ✓ | ✓ | PK | 评论唯一标识 |
| RECIPE_ID | NUMBER(10) | ✓ | | FK | 食谱ID（外键） |
| USER_ID | NUMBER(10) | ✓ | | FK | 评论者用户ID |
| PARENT_COMMENT_ID | NUMBER(10) | | | FK | 父评论ID（自引用） |
| COMMENT_TEXT | VARCHAR2(1000) | | | | 评论内容 |
| IS_DELETED | VARCHAR2(1) | | | DF='N' | 逻辑删除标记 |
| CREATED_AT | TIMESTAMP | | | DF=SYSTIMESTAMP | 创建时间 |
| UPDATED_AT | TIMESTAMP | | | DF=SYSTIMESTAMP | 更新时间 |

---

## 15. COMMENT_HELPFULNESS 表（评论有用性投票表）

**用途**：用户对其他用户的评论进行"有用"投票

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| COMMENT_ID | NUMBER(10) | ✓ | ✓ | PK, FK | 被投票的评论ID |
| USER_ID | NUMBER(10) | ✓ | ✓ | PK, FK | 投票者用户ID |
| VOTED_AT | TIMESTAMP | | | DF=SYSTIMESTAMP | 投票时间 |

**v3.0 变更说明**：
- 移除代理主键 `HELPFUL_ID`
- 采用 `(COMMENT_ID, USER_ID)` 复合主键

---

## 16. SAVED_RECIPES 表（收藏食谱表）

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| SAVED_RECIPE_ID | NUMBER(10) | ✓ | ✓ | PK | 收藏记录唯一标识 |
| USER_ID | NUMBER(10) | ✓ | | FK | 收藏者用户ID |
| RECIPE_ID | NUMBER(10) | ✓ | | FK | 被收藏的食谱ID |
| SAVED_AT | TIMESTAMP | ✓ | | DF=SYSDATE | 收藏时间 |

**唯一约束**：(USER_ID, RECIPE_ID) 唯一

---

## 17. FOLLOWERS 表（用户关注关系表 - **多对多自引用**）

**用途**：维护用户之间的关注关系

**关系类型**：N:M（多对多、自引用），采用**联合主键**

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| USER_ID | NUMBER(10) | ✓ | ✓(PK1) | FK | 被关注者用户ID，联合主键第一部分 |
| FOLLOWER_USER_ID | NUMBER(10) | ✓ | ✓(PK2) | FK | 关注者用户ID，联合主键第二部分 |
| FOLLOWED_AT | TIMESTAMP | ✓ | | DF=SYSDATE | 关注时间 |

**关键特性**：
- **主键**：(USER_ID, FOLLOWER_USER_ID) 的复合主键
- **检查约束**：USER_ID != FOLLOWER_USER_ID（不能关注自己）
- **自引用**：两个外键都引用 USERS 表

---

## 18. USER_ALLERGIES 表（用户过敏原关联表 - **多对多**）

**用途**：记录每个用户的过敏原信息

**关系类型**：N:M（多对多），采用**联合主键**

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| USER_ID | NUMBER(10) | ✓ | ✓(PK1) | FK | 用户ID，联合主键第一部分 |
| ALLERGEN_ID | NUMBER(10) | ✓ | ✓(PK2) | FK | 过敏原ID，联合主键第二部分 |
| ADDED_AT | TIMESTAMP | ✓ | | DF=SYSDATE | 添加时间 |

**关键特性**：
- **主键**：(USER_ID, ALLERGEN_ID) 的复合主键
- **自动唯一性**：每个用户的每个过敏原只记录一次

**业务应用**：
- 用户可以标记自己的过敏原
- 系统可以自动过滤含有该过敏原的食谱
- 推荐安全、符合用户饮食需求的食谱

---

## 19. RECIPE_TAGS 表（食谱标签关联表 - **多对多**）

**用途**：给食谱添加标签，支持分类和搜索

**关系类型**：N:M（多对多），采用**联合主键**

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| RECIPE_ID | NUMBER(10) | ✓ | ✓(PK1) | FK | 食谱ID，联合主键第一部分 |
| TAG_ID | NUMBER(10) | ✓ | ✓(PK2) | FK | 标签ID，联合主键第二部分 |
| ADDED_AT | TIMESTAMP | ✓ | | DF=SYSDATE | 添加时间 |

**关键特性**：
- **主键**：(RECIPE_ID, TAG_ID) 的复合主键
- **自动唯一性**：每个食谱的每个标签只能添加一次

---

## 20. USER_ACTIVITY_LOG 表（用户活动日志表）

**用途**：记录用户在平台上的各种活动

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| ACTIVITY_ID | NUMBER(10) | ✓ | ✓ | PK | 活动记录唯一标识 |
| USER_ID | NUMBER(10) | ✓ | | FK | 用户ID |
| ACTIVITY_TYPE | VARCHAR2(50) | | | | 活动类型（view/comment/rate等） |
| RECIPE_ID | NUMBER(10) | | | FK | 相关食谱ID（可为空） |
| ACTIVITY_DESCRIPTION | VARCHAR2(255) | | | | 活动描述 |
| ACTIVITY_DATE | TIMESTAMP | ✓ | | DF=SYSDATE | 活动时间 |

---

# 个人管理表

## 21. RECIPE_COLLECTIONS 表（食谱收藏清单表）

**用途**：用户可以创建多个食谱清单进行分类管理

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| COLLECTION_ID | NUMBER(10) | ✓ | ✓ | PK | 清单唯一标识 |
| USER_ID | NUMBER(10) | ✓ | | FK | 创建者用户ID |
| COLLECTION_NAME | VARCHAR2(100) | ✓ | | | 清单名称 |
| DESCRIPTION | VARCHAR2(500) | | | | 清单描述 |
| IS_PUBLIC | VARCHAR2(1) | ✓ | | DF='Y',CK | 是否公开（Y/N） |
| CREATED_AT | TIMESTAMP | ✓ | | DF=SYSDATE | 创建时间 |
| UPDATED_AT | TIMESTAMP | ✓ | | DF=SYSDATE | 更新时间 |

---

## 22. COLLECTION_RECIPES 表（清单食谱关联表 - **多对多**）

**用途**：定义每个清单包含的食谱

**关系类型**：N:M（多对多），采用**联合主键**

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| COLLECTION_ID | NUMBER(10) | ✓ | ✓(PK1) | FK | 清单ID，联合主键第一部分 |
| RECIPE_ID | NUMBER(10) | ✓ | ✓(PK2) | FK | 食谱ID，联合主键第二部分 |
| ADDED_AT | TIMESTAMP | ✓ | | DF=SYSDATE | 添加时间 |

**关键特性**：
- **主键**：(COLLECTION_ID, RECIPE_ID) 的复合主键
- **自动唯一性**：每个清单中每个食谱只能添加一次

---

## 23. SHOPPING_LISTS 表（购物清单表）

**用途**：用户创建购物清单，记录需要购买的食材

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| LIST_ID | NUMBER(10) | ✓ | ✓ | PK | 购物清单唯一标识 |
| USER_ID | NUMBER(10) | ✓ | | FK | 用户ID |
| LIST_NAME | VARCHAR2(100) | ✓ | | | 清单名称 |
| CREATED_AT | TIMESTAMP | ✓ | | DF=SYSDATE | 创建时间 |
| UPDATED_AT | TIMESTAMP | ✓ | | DF=SYSDATE | 更新时间 |

---

## 24. SHOPPING_LIST_ITEMS 表（购物清单项目表 - **多对多**）

**用途**：定义购物清单中的每个食材项

**关系类型**：N:M（多对多），采用**联合主键**

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| LIST_ID | NUMBER(10) | ✓ | ✓(PK1) | FK | 购物清单ID，联合主键第一部分 |
| INGREDIENT_ID | NUMBER(10) | ✓ | ✓(PK2) | FK | 食材ID，联合主键第二部分 |
| QUANTITY | NUMBER(10,2) | | | | 数量 |
| UNIT_ID | NUMBER(10) | | | FK | 单位ID |
| IS_CHECKED | VARCHAR2(1) | ✓ | | DF='N',CK | 是否已购（Y/N） |
| ADDED_AT | TIMESTAMP | ✓ | | DF=SYSDATE | 添加时间 |

**关键特性**：
- **主键**：(LIST_ID, INGREDIENT_ID) 的复合主键
- **自动唯一性**：每个清单中每个食材只能出现一次

---

## 25. MEAL_PLANS 表（膳食计划表）

**用途**：用户创建膳食计划，规划一周或一月的食谱

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| PLAN_ID | NUMBER(10) | ✓ | ✓ | PK | 膳食计划唯一标识 |
| USER_ID | NUMBER(10) | ✓ | | FK | 用户ID |
| PLAN_NAME | VARCHAR2(100) | ✓ | | | 计划名称 |
| DESCRIPTION | VARCHAR2(500) | | | | 计划描述 |
| START_DATE | DATE | ✓ | | CK | 开始日期 |
| END_DATE | DATE | ✓ | | CK | 结束日期 |
| IS_PUBLIC | VARCHAR2(1) | ✓ | | DF='Y',CK | 是否公开（Y/N） |
| CREATED_AT | TIMESTAMP | ✓ | | DF=SYSDATE | 创建时间 |
| UPDATED_AT | TIMESTAMP | ✓ | | DF=SYSDATE | 更新时间 |

**检查约束**：START_DATE <= END_DATE

---

## 26. MEAL_PLAN_ENTRIES 表（膳食计划条目表 - **多对多**）

**用途**：定义膳食计划中每一天的食谱

**关系类型**：N:M（多对多），采用**复合联合主键（三字段）**

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| PLAN_ID | NUMBER(10) | ✓ | ✓(PK1) | FK | 膳食计划ID，联合主键第一部分 |
| RECIPE_ID | NUMBER(10) | ✓ | ✓(PK2) | FK | 食谱ID，联合主键第二部分 |
| MEAL_DATE | DATE | ✓ | ✓(PK3) | | 该食谱的日期，联合主键第三部分 |
| MEAL_TYPE | VARCHAR2(20) | | | CK | 餐型（breakfast/lunch/dinner/snack） |
| NOTES | VARCHAR2(255) | | | | 特殊说明 |
| ADDED_AT | TIMESTAMP | ✓ | | DF=SYSDATE | 添加时间 |

**关键特性**：
- **主键**：(PLAN_ID, RECIPE_ID, MEAL_DATE) 的复合主键（三个字段）
- **自动唯一性**：每个计划中的每一天每个食谱只能添加一次
- **业务含义**：支持同一食谱在计划中的不同日期出现，但同一日期同一食谱只能添加一次

---

# 多对多关系联合主键设计

## 设计对比

### v2.0 设计（旧）- 使用独立ID

```sql
CREATE TABLE RECIPE_INGREDIENTS (
    recipe_ingredient_id NUMBER(10) PRIMARY KEY,
    recipe_id NUMBER(10) NOT NULL,
    ingredient_id NUMBER(10) NOT NULL,
    unit_id NUMBER(10) NOT NULL,
    quantity NUMBER(10,2) NOT NULL,
    UNIQUE (recipe_id, ingredient_id)
);

-- 插入数据需要两条语句
INSERT INTO RECIPE_INGREDIENTS VALUES (seq.nextval, 1, 5, 1, 100);
```

### v3.0 设计（新）- 使用联合主键

```sql
CREATE TABLE RECIPE_INGREDIENTS (
    recipe_id NUMBER(10) NOT NULL,
    ingredient_id NUMBER(10) NOT NULL,
    unit_id NUMBER(10) NOT NULL,
    quantity NUMBER(10,2) NOT NULL,
    PRIMARY KEY (recipe_id, ingredient_id)
);

-- 插入数据直接进行
INSERT INTO RECIPE_INGREDIENTS VALUES (1, 5, 1, 100);
```

## 优势分析

| 指标 | v2.0（ID方式） | v3.0（联合主键） |
|------|---------------|-----------------|
| **主键字段数** | 1个 | 2个或更多 |
| **总字段数** | 多1个 | 减少1个 |
| **存储空间** | 更多 | 更省 |
| **唯一性保证** | 需要额外UNIQUE约束 | 主键自动保证 |
| **查询效率** | 较低（需要额外索引） | 较高（主键索引） |
| **数据完整性** | 容易违反 | 自动强制 |
| **BCNF合规性** | 部分合规 | 完全合规 |
| **代码复杂性** | 较高 | 较低 |

## 修改的8个表

1. **RECIPE_INGREDIENTS**：(RECIPE_ID, INGREDIENT_ID)
2. **INGREDIENT_ALLERGENS**：(INGREDIENT_ID, ALLERGEN_ID)
3. **INGREDIENT_SUBSTITUTIONS**：(ORIGINAL_INGREDIENT_ID, SUBSTITUTE_INGREDIENT_ID)
4. **USER_ALLERGIES**：(USER_ID, ALLERGEN_ID)
5. **RATING_HELPFULNESS**：(RATING_ID, USER_ID)
6. **COMMENT_HELPFULNESS**：(COMMENT_ID, USER_ID)
7. **COLLECTION_RECIPES**：(COLLECTION_ID, RECIPE_ID)
8. **SHOPPING_LIST_ITEMS**：(LIST_ID, INGREDIENT_ID)
9. **RECIPE_TAGS**：(RECIPE_ID, TAG_ID)
10. **FOLLOWERS**：(USER_ID, FOLLOWER_USER_ID)
11. **MEAL_PLAN_ENTRIES**：(PLAN_ID, RECIPE_ID, MEAL_DATE)

---

# 表间关系详解

## 关键关系汇总

### 1:N 关系（12个）

- USERS → RECIPES
- USERS → RATINGS
- USERS → COMMENTS
- USERS → SAVED_RECIPES
- USERS → FOLLOWERS（被关注）
- USERS → USER_ACTIVITY_LOG
- USERS → RECIPE_COLLECTIONS
- USERS → SHOPPING_LISTS
- USERS → MEAL_PLANS
- RECIPES → COOKING_STEPS
- RECIPES → NUTRITION_INFO（一对一）
- SHOPPING_LISTS → SHOPPING_LIST_ITEMS

### N:M 关系（11个，全部采用联合主键）

1. RECIPES ↔ INGREDIENTS（通过 RECIPE_INGREDIENTS）
2. INGREDIENTS ↔ ALLERGENS（通过 INGREDIENT_ALLERGENS）
3. INGREDIENTS ↔ INGREDIENTS（通过 INGREDIENT_SUBSTITUTIONS - 自引用）
4. RECIPES ↔ TAGS（通过 RECIPE_TAGS）
5. USERS ↔ USERS（通过 FOLLOWERS - 自引用）
6. USERS ↔ ALLERGENS（通过 USER_ALLERGIES）
7. RATINGS ↔ USERS（通过 RATING_HELPFULNESS）
8. COMMENTS ↔ USERS（通过 COMMENT_HELPFULNESS）
9. RECIPE_COLLECTIONS ↔ RECIPES（通过 COLLECTION_RECIPES）
10. SHOPPING_LISTS ↔ INGREDIENTS（通过 SHOPPING_LIST_ITEMS）
11. MEAL_PLANS ↔ RECIPES（通过 MEAL_PLAN_ENTRIES）

---

# 数据规范化确认

本设计严格满足BCNF规范：

✅ **1NF**：所有字段包含原子值  
✅ **2NF**：所有非主键字段完全依赖于主键  
✅ **3NF**：消除所有传递依赖  
✅ **BCNF**：消除所有异常依赖  

通过联合主键的使用，确保了每条关联记录的唯一性，完全消除了冗余ID字段带来的异常。
