# AllRecipes 食谱网站 - 数据库逻辑模型设计文档 (v3.0)

## 目录

1. [概述](#概述)
2. [表设计原则](#表设计原则)
3. [核心基础表](#核心基础表)
4. [食谱核心表](#食谱核心表)
5. [用户交互表](#用户交互表)
6. [个人管理表](#个人管理表)
7. [表间关系详解](#表间关系详解)
8. [数据流转示例](#数据流转示例)

---

# 概述

本文档详细描述AllRecipes食谱网站数据库的逻辑模型（v3.0版本），包含**26个核心表**的完整设计。本版本重点优化了**N:M多对多关系**的实现，全面采用**复合主键**替代代理键，以严格符合BCNF（Boyce-Codd Normal Form）范式，消除数据冗余并增强数据完整性。

**总体统计：**
- 表数量：26个
- 字段总数：200+
- 复合主键表：13个
- 外键关系：30+个
- 数据规范化等级：BCNF（Boyce-Codd Normal Form）

---

# 表设计原则

## 1. 规范化原则 (v3.0重点)

本设计严格遵循数据库规范化理论，特别是针对关联表的优化：

- **第一范式（1NF）**：每个字段包含原子值，不可再分
- **第二范式（2NF）**：消除非主属性对码的部分依赖（通过复合主键实现）
- **第三范式（3NF）**：消除传递依赖
- **BCNF**：在3NF基础上，消除主属性对码的部分依赖和传递依赖。v3.0版本中，所有关联表（如食谱-食材、用户-收藏）均使用复合主键，不再引入无业务含义的代理主键，从而彻底消除潜在的非BCNF结构。

## 2. 命名规范

| 元素 | 规范 | 示例 |
|-----|------|------|
| 表名 | 大写，复数形式 | USERS, RECIPES |
| 列名 | 大写，用下划线分隔 | USER_ID, RECIPE_NAME |
| 主键 | {表名}_ID 或 复合列 | USER_ID, (RECIPE_ID, INGREDIENT_ID) |
| 外键 | {被引用表名}_ID | USER_ID (in RECIPES) |
| 时间戳 | CREATED_AT, UPDATED_AT | - |

## 3. 字段类型选择

| 类型 | 使用场景 | 示例 |
|-----|---------|------|
| NUMBER(10) | 整数ID | USER_ID, RECIPE_ID |
| NUMBER(3,2) | 评分值 | RATING_VALUE (0.00-5.00) |
| VARCHAR2(n) | 可变长文本 | USERNAME, EMAIL |
| DATE | 仅日期 | JOIN_DATE |
| TIMESTAMP | 日期时间 | CREATED_AT |
| CLOB | 大文本 | RECIPE_DESCRIPTION |
| CHAR(1) | 布尔标志 | IS_PUBLISHED ('Y'/'N') |

## 4. 约束设计

每个表都包含：
- **主键约束**：唯一标识每条记录（单列或复合列）
- **外键约束**：维护表间关系完整性
- **非空约束**：保证必填字段有值
- **唯一性约束**：防止重复数据
- **检查约束**：验证字段值范围
- **默认值**：简化数据插入

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
| JOIN_DATE | DATE | ✓ | | DF=SYSDATE | 注册日期 |
| LAST_LOGIN | DATE | | | | 最后登录时间 |
| ACCOUNT_STATUS | VARCHAR2(20) | ✓ | | CK, DF='active' | active/inactive/suspended |
| USER_TYPE | VARCHAR2(50) | | | CK, DF='普通用户' | 用户类型（普通用户/专业厨师/美食博主） |
| TOTAL_FOLLOWERS | NUMBER(10) | | | DF=0 | 粉丝数量（冗余字段用于性能） |
| TOTAL_RECIPES | NUMBER(10) | | | DF=0 | 发布的食谱数量（冗余字段用于性能） |
| CREATED_AT | TIMESTAMP | | | DF=SYSTIMESTAMP | 创建记录时间 |
| UPDATED_AT | TIMESTAMP | | | DF=SYSTIMESTAMP | 最后修改时间 |

**关键说明**：
- 新增 `USER_TYPE` 字段区分用户角色
- `ACCOUNT_STATUS` 检查约束：`IN ('active', 'inactive', 'suspended')`
- `USER_TYPE` 检查约束：`IN ('普通用户', '专业厨师', '美食博主')`

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
| CREATED_AT | TIMESTAMP | | | DF=SYSTIMESTAMP | 创建时间 |

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
| CREATED_AT | TIMESTAMP | | | DF=SYSTIMESTAMP | 创建时间 |

---

## 4. ALLERGENS 表（过敏原表）

**用途**：维护所有已知的可能引起过敏的物质

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| ALLERGEN_ID | NUMBER(10) | ✓ | ✓ | PK | 过敏原唯一标识 |
| ALLERGEN_NAME | VARCHAR2(100) | ✓ | | UK | 过敏原名称（花生、坚果、乳制品等） |
| DESCRIPTION | VARCHAR2(255) | | | | 过敏原详细描述和影响 |
| CREATED_AT | TIMESTAMP | | | DF=SYSTIMESTAMP | 创建时间 |

---

## 5. TAGS 表（标签表）

**用途**：定义食谱可以使用的标签，方便用户快速分类和搜索

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| TAG_ID | NUMBER(10) | ✓ | ✓ | PK | 标签唯一标识 |
| TAG_NAME | VARCHAR2(50) | ✓ | | UK | 标签名称（素食、低脂、快手菜等） |
| TAG_DESCRIPTION | VARCHAR2(255) | | | | 标签描述 |
| CREATED_AT | TIMESTAMP | | | DF=SYSTIMESTAMP | 创建时间 |

---

## 6. USER_ALLERGIES 表（用户过敏原表）

**用途**：记录每个用户个人的过敏原信息，用于个性化推荐

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| USER_ID | NUMBER(10) | ✓ | ✓ | PK, FK | 用户ID（外键） |
| ALLERGEN_ID | NUMBER(10) | ✓ | ✓ | PK, FK | 过敏原ID（外键） |
| ADDED_AT | TIMESTAMP | | | DF=SYSTIMESTAMP | 记录添加时间 |

**v3.0 变更说明**：
- 移除代理主键 `USER_ALLERGY_ID`
- 采用 `(USER_ID, ALLERGEN_ID)` 复合主键
- 物理上消除了重复记录的可能性

---

# 食谱核心表

## 7. RECIPES 表（食谱主表）

**用途**：存储所有发布的食谱的核心信息

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| RECIPE_ID | NUMBER(10) | ✓ | ✓ | PK | 食谱唯一标识 |
| USER_ID | NUMBER(10) | ✓ | | FK | 创建者用户ID |
| RECIPE_NAME | VARCHAR2(200) | ✓ | | | 食谱名称 |
| DESCRIPTION | VARCHAR2(1000) | | | | 食谱详细描述 |
| CUISINE_TYPE | VARCHAR2(50) | | | | 菜系（中式、西式、日式等） |
| MEAL_TYPE | VARCHAR2(20) | | | CK | 餐品类型 |
| DIFFICULTY_LEVEL | VARCHAR2(20) | | | CK | 难度等级 |
| PREP_TIME | NUMBER(5) | | | | 准备时间（分钟） |
| COOK_TIME | NUMBER(5) | | | | 烹饪时间（分钟） |
| TOTAL_TIME | NUMBER(5) | | | | 总时间（分钟） |
| SERVINGS | NUMBER(5) | | | | 份数 |
| CALORIES_PER_SERVING | NUMBER(10) | | | | 每份热量（卡路里） |
| IMAGE_URL | VARCHAR2(255) | | | | 食谱主图URL |
| IS_PUBLISHED | VARCHAR2(1) | ✓ | | DF='Y',CK | 是否发布（Y/N） |
| IS_DELETED | VARCHAR2(1) | ✓ | | DF='N',CK | 逻辑删除标记（Y/N） |
| VIEW_COUNT | NUMBER(10) | | | DF=0 | 浏览次数 |
| RATING_COUNT | NUMBER(10) | | | DF=0 | 评价数量 |
| AVERAGE_RATING | NUMBER(3,2) | | | DF=0 | 平均评分 |
| CREATED_AT | TIMESTAMP | | | DF=SYSTIMESTAMP | 创建时间 |
| UPDATED_AT | TIMESTAMP | | | DF=SYSTIMESTAMP | 更新时间 |

---

## 8. RECIPE_INGREDIENTS 表（食谱食材关联表）

**用途**：定义每个食谱需要的食材及用量

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| RECIPE_ID | NUMBER(10) | ✓ | ✓ | PK, FK | 食谱ID（外键） |
| INGREDIENT_ID | NUMBER(10) | ✓ | ✓ | PK, FK | 食材ID（外键） |
| UNIT_ID | NUMBER(10) | | | FK | 单位ID（外键） |
| QUANTITY | NUMBER(10,2) | ✓ | | | 用量（小数形式） |
| NOTES | VARCHAR2(255) | | | | 特殊说明（如：切碎、磨碎等） |

**v3.0 变更说明**：
- 移除代理主键 `RECIPE_INGREDIENT_ID`
- 采用 `(RECIPE_ID, INGREDIENT_ID)` 复合主键
- 确保同一食谱中同一食材只能出现一次

---

## 9. COOKING_STEPS 表（烹饪步骤表）

**用途**：存储每个食谱的详细烹饪步骤

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| STEP_ID | NUMBER(10) | ✓ | ✓ | PK | 步骤唯一标识 |
| RECIPE_ID | NUMBER(10) | ✓ | | FK | 食谱ID（外键） |
| STEP_NUMBER | NUMBER(5) | ✓ | | | 步骤序号（1, 2, 3...） |
| INSTRUCTION | VARCHAR2(1000) | ✓ | | | 详细操作说明 |
| TIME_REQUIRED | NUMBER(5) | | | | 该步骤耗时（分钟） |
| IMAGE_URL | VARCHAR2(255) | | | | 步骤演示图片URL |

**约束**：
- 复合唯一性：(RECIPE_ID, STEP_NUMBER) 唯一

---

## 10. NUTRITION_INFO 表（营养信息表）

**用途**：存储每个食谱的营养成分信息

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| NUTRITION_ID | NUMBER(10) | ✓ | ✓ | PK | 营养信息唯一标识 |
| RECIPE_ID | NUMBER(10) | ✓ | | FK,UK | 食谱ID（外键，一对一） |
| CALORIES | NUMBER(10) | | | | 总热量 |
| PROTEIN_GRAMS | NUMBER(10,2) | | | | 蛋白质克数 |
| CARBS_GRAMS | NUMBER(10,2) | | | | 碳水化合物克数 |
| FAT_GRAMS | NUMBER(10,2) | | | | 脂肪克数 |
| FIBER_GRAMS | NUMBER(10,2) | | | | 纤维克数 |
| SUGAR_GRAMS | NUMBER(10,2) | | | | 糖克数 |
| SODIUM_MG | NUMBER(10) | | | | 钠毫克数 |

---

## 11. INGREDIENT_ALLERGENS 表（食材过敏原关联表）

**用途**：定义哪些食材包含哪些过敏原

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| INGREDIENT_ID | NUMBER(10) | ✓ | ✓ | PK, FK | 食材ID（外键） |
| ALLERGEN_ID | NUMBER(10) | ✓ | ✓ | PK, FK | 过敏原ID（外键） |
| ALLERGEN_LEVEL | VARCHAR2(50) | | | | 过敏原等级/说明 |

**v3.0 变更说明**：
- 移除代理主键 `INGREDIENT_ALLERGEN_ID`
- 采用 `(INGREDIENT_ID, ALLERGEN_ID)` 复合主键
- 新增 `ALLERGEN_LEVEL` 字段

---

## 12. RECIPE_TAGS 表（食谱标签关联表）

**用途**：为食谱分配标签

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| RECIPE_ID | NUMBER(10) | ✓ | ✓ | PK, FK | 食谱ID（外键） |
| TAG_ID | NUMBER(10) | ✓ | ✓ | PK, FK | 标签ID（外键） |

**v3.0 变更说明**：
- 移除代理主键 `RECIPE_TAG_ID`
- 采用 `(RECIPE_ID, TAG_ID)` 复合主键

---

## 13. INGREDIENT_SUBSTITUTIONS 表（食材替代品表）

**用途**：定义食材之间的替代关系

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| ORIGINAL_INGREDIENT_ID | NUMBER(10) | ✓ | ✓ | PK, FK | 原始食材ID（外键） |
| SUBSTITUTE_INGREDIENT_ID | NUMBER(10) | ✓ | ✓ | PK, FK | 替代食材ID（外键） |
| RATIO | NUMBER(5,2) | | | | 替代比例 |
| NOTES | VARCHAR2(255) | | | | 替代说明 |
| APPROVAL_STATUS | VARCHAR2(50) | | | | 审核状态 |
| CREATED_AT | TIMESTAMP | | | DF=SYSTIMESTAMP | 创建时间 |

**v3.0 变更说明**：
- 移除代理主键 `SUBSTITUTION_ID`
- 采用 `(ORIGINAL_INGREDIENT_ID, SUBSTITUTE_INGREDIENT_ID)` 复合主键

---

# 用户交互表

## 14. RATINGS 表（评价表）

**用途**：存储用户对食谱的评价和评论

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| USER_ID | NUMBER(10) | ✓ | ✓ | PK, FK | 评价者用户ID |
| RECIPE_ID | NUMBER(10) | ✓ | ✓ | PK, FK | 被评价的食谱ID |
| RATING_VALUE | NUMBER(3,2) | ✓ | | | 评分值（0.00-5.00） |
| REVIEW_TEXT | VARCHAR2(1000) | | | | 评论文字内容 |
| RATING_DATE | TIMESTAMP | | | DF=SYSTIMESTAMP | 评价时间 |

**v3.0 变更说明**：
- 移除代理主键 `RATING_ID`
- 采用 `(USER_ID, RECIPE_ID)` 复合主键
- 强制一个用户对一个食谱只能有一条评价

---

## 15. RATING_HELPFULNESS 表（评价有用性投票表）

**用途**：用户对其他用户的评价进行"有用"投票

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| RATING_USER_ID | NUMBER(10) | ✓ | ✓ | PK, FK | 评价发布者ID |
| RATING_RECIPE_ID | NUMBER(10) | ✓ | ✓ | PK, FK | 评价关联食谱ID |
| VOTER_USER_ID | NUMBER(10) | ✓ | ✓ | PK, FK | 投票者用户ID |
| VOTED_AT | TIMESTAMP | | | DF=SYSTIMESTAMP | 投票时间 |

**v3.0 变更说明**：
- 移除代理主键 `HELPFUL_ID`
- 引用 `RATINGS` 表的复合主键 `(RATING_USER_ID, RATING_RECIPE_ID)`
- 采用三列复合主键

---

## 16. COMMENTS 表（评论表）

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

## 17. COMMENT_HELPFULNESS 表（评论有用性投票表）

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

## 18. SAVED_RECIPES 表（收藏食谱表）

**用途**：存储用户收藏的食谱

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| USER_ID | NUMBER(10) | ✓ | ✓ | PK, FK | 用户ID（外键） |
| RECIPE_ID | NUMBER(10) | ✓ | ✓ | PK, FK | 食谱ID（外键） |
| SAVED_AT | TIMESTAMP | | | DF=SYSTIMESTAMP | 收藏时间 |

**v3.0 变更说明**：
- 移除代理主键 `SAVED_RECIPE_ID`
- 采用 `(USER_ID, RECIPE_ID)` 复合主键

---

## 19. FOLLOWERS 表（关注表）

**用途**：实现用户之间的关注关系

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| USER_ID | NUMBER(10) | ✓ | ✓ | PK, FK | 被关注者用户ID |
| FOLLOWER_USER_ID | NUMBER(10) | ✓ | ✓ | PK, FK | 关注者用户ID |
| FOLLOWED_AT | TIMESTAMP | | | DF=SYSTIMESTAMP | 关注时间 |
| IS_BLOCKED | VARCHAR2(1) | | | DF='N' | 是否拉黑 |

**v3.0 变更说明**：
- 移除代理主键 `FOLLOWER_ID`
- 采用 `(USER_ID, FOLLOWER_USER_ID)` 复合主键
- 新增 `IS_BLOCKED` 字段

---

## 20. USER_ACTIVITY_LOG 表（用户活动日志表）

**用途**：记录用户的所有活动历史

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| ACTIVITY_ID | NUMBER(10) | ✓ | ✓ | PK | 活动记录唯一标识 |
| USER_ID | NUMBER(10) | ✓ | | FK | 用户ID（外键） |
| ACTIVITY_TYPE | VARCHAR2(50) | | | | 活动类型 |
| ACTIVITY_DESCRIPTION | VARCHAR2(255) | | | | 活动描述 |
| RELATED_RECIPE_ID | NUMBER(10) | | | FK | 相关食谱ID |
| RELATED_USER_ID | NUMBER(10) | | | FK | 相关用户ID |
| ACTIVITY_TIMESTAMP | TIMESTAMP | | | DF=SYSTIMESTAMP | 活动时间 |
| IP_ADDRESS | VARCHAR2(45) | | | | IP地址 |

**v3.0 变更说明**：
- 新增 `RELATED_USER_ID` 和 `IP_ADDRESS` 字段

---

# 个人管理表

## 21. RECIPE_COLLECTIONS 表（食谱收集清单表）

**用途**：用户可以创建多个食谱清单

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| COLLECTION_ID | NUMBER(10) | ✓ | ✓ | PK | 清单唯一标识 |
| USER_ID | NUMBER(10) | ✓ | | FK | 创建者用户ID |
| COLLECTION_NAME | VARCHAR2(100) | ✓ | | | 清单名称 |
| DESCRIPTION | VARCHAR2(500) | | | | 清单描述 |
| IS_PUBLIC | VARCHAR2(1) | | | DF='Y' | 是否公开 |
| CREATED_AT | TIMESTAMP | | | DF=SYSTIMESTAMP | 创建时间 |
| UPDATED_AT | TIMESTAMP | | | DF=SYSTIMESTAMP | 更新时间 |

---

## 22. COLLECTION_RECIPES 表（清单食谱关联表）

**用途**：定义食谱清单中包含的食谱

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| COLLECTION_ID | NUMBER(10) | ✓ | ✓ | PK, FK | 清单ID（外键） |
| RECIPE_ID | NUMBER(10) | ✓ | ✓ | PK, FK | 食谱ID（外键） |
| ADDED_AT | TIMESTAMP | | | DF=SYSTIMESTAMP | 添加时间 |

**v3.0 变更说明**：
- 移除代理主键 `COLLECTION_RECIPE_ID`
- 采用 `(COLLECTION_ID, RECIPE_ID)` 复合主键

---

## 23. SHOPPING_LISTS 表（购物清单表）

**用途**：用户可以创建购物清单

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| LIST_ID | NUMBER(10) | ✓ | ✓ | PK | 购物清单唯一标识 |
| USER_ID | NUMBER(10) | ✓ | | FK | 用户ID（外键） |
| LIST_NAME | VARCHAR2(100) | ✓ | | | 清单名称 |
| CREATED_AT | TIMESTAMP | | | DF=SYSTIMESTAMP | 创建时间 |
| UPDATED_AT | TIMESTAMP | | | DF=SYSTIMESTAMP | 更新时间 |

---

## 24. SHOPPING_LIST_ITEMS 表（购物清单项目表）

**用途**：定义购物清单中的每个食材项

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| LIST_ID | NUMBER(10) | ✓ | ✓ | PK, FK | 购物清单ID |
| INGREDIENT_ID | NUMBER(10) | ✓ | ✓ | PK, FK | 食材ID |
| QUANTITY | NUMBER(10,2) | | | | 采购数量 |
| UNIT_ID | NUMBER(10) | | | FK | 单位ID |
| IS_CHECKED | VARCHAR2(1) | | | DF='N' | 是否已购（Y/N） |
| ADDED_AT | TIMESTAMP | | | DF=SYSTIMESTAMP | 添加时间 |
| ESTIMATED_PRICE | NUMBER(10,2) | | | | 预估价格 |
| ACTUAL_PRICE | NUMBER(10,2) | | | | 实际价格 |

**v3.0 变更说明**：
- 移除代理主键 `ITEM_ID`
- 采用 `(LIST_ID, INGREDIENT_ID)` 复合主键
- 新增 `ESTIMATED_PRICE` 和 `ACTUAL_PRICE` 字段

---

## 25. MEAL_PLANS 表（膳食计划表）

**用途**：用户可以创建膳食计划

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| PLAN_ID | NUMBER(10) | ✓ | ✓ | PK | 膳食计划唯一标识 |
| USER_ID | NUMBER(10) | ✓ | | FK | 用户ID（外键） |
| PLAN_NAME | VARCHAR2(100) | ✓ | | | 计划名称 |
| DESCRIPTION | VARCHAR2(500) | | | | 计划描述 |
| START_DATE | DATE | ✓ | | | 开始日期 |
| END_DATE | DATE | ✓ | | | 结束日期 |
| IS_PUBLIC | VARCHAR2(1) | | | DF='Y' | 是否公开 |
| CREATED_AT | TIMESTAMP | | | DF=SYSTIMESTAMP | 创建时间 |
| UPDATED_AT | TIMESTAMP | | | DF=SYSTIMESTAMP | 更新时间 |

---

## 26. MEAL_PLAN_ENTRIES 表（膳食计划条目表）

**用途**：定义膳食计划中每一天的食谱

**表结构**：

| 字段名 | 数据类型 | 非空 | 主键 | 约束 | 说明 |
|--------|---------|------|------|------|------|
| PLAN_ID | NUMBER(10) | ✓ | ✓ | PK, FK | 膳食计划ID |
| RECIPE_ID | NUMBER(10) | ✓ | ✓ | PK, FK | 食谱ID |
| MEAL_DATE | DATE | ✓ | ✓ | PK | 该食谱的日期 |
| MEAL_TYPE | VARCHAR2(20) | | | | 餐型（早午晚等） |
| NOTES | VARCHAR2(255) | | | | 特殊说明 |
| PLANNED_SERVINGS | NUMBER(3) | | | | 计划份数 |
| ACTUAL_SERVINGS | NUMBER(3) | | | | 实际份数 |
| IS_COMPLETED | VARCHAR2(1) | | | DF='N' | 是否完成 |
| RATING | NUMBER(2) | | | | 评分 |
| ADDED_AT | TIMESTAMP | | | DF=SYSTIMESTAMP | 添加时间 |

**v3.0 变更说明**：
- 移除代理主键 `ENTRY_ID`
- 采用 `(PLAN_ID, RECIPE_ID, MEAL_DATE)` 三元复合主键
- 新增 `PLANNED_SERVINGS`, `ACTUAL_SERVINGS`, `IS_COMPLETED`, `RATING` 字段

---

# 表间关系详解

## 关系分类

### 1. 一对多（1:N）关系

| 主表 | 从表 | 关系说明 |
|------|------|---------|
| USERS | RECIPES | 一个用户发布多个食谱 |
| USERS | RECIPE_COLLECTIONS | 一个用户创建多个清单 |
| USERS | SHOPPING_LISTS | 一个用户创建多个购物清单 |
| USERS | MEAL_PLANS | 一个用户创建多个膳食计划 |
| USERS | COMMENTS | 一个用户发表多条评论 |
| USERS | USER_ACTIVITY_LOG | 一个用户有多条活动记录 |
| RECIPES | COOKING_STEPS | 一个食谱有多个烹饪步骤 |
| RECIPES | COMMENTS | 一个食谱接收多条评论 |
| COMMENTS | COMMENTS | 一条评论可有多条子评论（自引用） |

### 2. 多对多（N:M）关系 (v3.0 复合主键实现)

| 主表1 | 主表2 | 中间表 | 主键构成 |
|-------|-------|--------|----------|
| RECIPES | INGREDIENTS | RECIPE_INGREDIENTS | (RECIPE_ID, INGREDIENT_ID) |
| RECIPES | TAGS | RECIPE_TAGS | (RECIPE_ID, TAG_ID) |
| INGREDIENTS | ALLERGENS | INGREDIENT_ALLERGENS | (INGREDIENT_ID, ALLERGEN_ID) |
| USERS | USERS | FOLLOWERS | (USER_ID, FOLLOWER_USER_ID) |
| USERS | RECIPES | SAVED_RECIPES | (USER_ID, RECIPE_ID) |
| USERS | RECIPES | RATINGS | (USER_ID, RECIPE_ID) |
| USERS | RECIPES | MEAL_PLAN_ENTRIES | (PLAN_ID, RECIPE_ID, MEAL_DATE) |
| USERS | ALLERGENS | USER_ALLERGIES | (USER_ID, ALLERGEN_ID) |
| RECIPE_COLLECTIONS | RECIPES | COLLECTION_RECIPES | (COLLECTION_ID, RECIPE_ID) |
| SHOPPING_LISTS | INGREDIENTS | SHOPPING_LIST_ITEMS | (LIST_ID, INGREDIENT_ID) |

### 3. 一对一（1:1）关系

| 主表 | 从表 | 说明 |
|------|------|------|
| RECIPES | NUTRITION_INFO | 一个食谱一条营养信息 |

---

# 数据流转示例

## 场景：用户评价食谱 (v3.0)

```
1. 用户提交评价
   INSERT INTO RATINGS (user_id, recipe_id, rating_value, review_text)
   VALUES (101, 5001, 4.5, '非常好吃！');
   -- 数据库自动检查 (101, 5001) 是否已存在，存在则报错（主键冲突）

2. 触发器/应用逻辑更新统计
   UPDATE RECIPES SET 
     rating_count = rating_count + 1,
     average_rating = (SELECT AVG(rating_value) FROM RATINGS WHERE recipe_id = 5001)
   WHERE recipe_id = 5001;
```

## 场景：添加食材到购物清单 (v3.0)

```
1. 用户添加食材
   INSERT INTO SHOPPING_LIST_ITEMS (list_id, ingredient_id, quantity, unit_id)
   VALUES (200, 10, 500, 1);
   -- 如果再次添加相同食材到同一清单，主键冲突，应执行 UPDATE 而非 INSERT

2. 更新逻辑 (Merge)
   MERGE INTO SHOPPING_LIST_ITEMS target
   USING (SELECT 200 as list_id, 10 as ingredient_id, 200 as qty FROM dual) source
   ON (target.list_id = source.list_id AND target.ingredient_id = source.ingredient_id)
   WHEN MATCHED THEN
     UPDATE SET target.quantity = target.quantity + source.qty
   WHEN NOT MATCHED THEN
     INSERT (list_id, ingredient_id, quantity) VALUES (source.list_id, source.ingredient_id, source.qty);
```
