**《AllRecipes食谱网站数据库方案设计与实现》报告**

## **目录**

### **1. 设计部分**

1.1 项目背景介绍

1.2 ER图设计（概念模型）

1.3 数据库库表设计（逻辑模型）

1.4 规范化

1.5 常见操作归纳

1.6 完整性约束方案设计

1.7 表的详细设计（物理模型）

1.8 视图设计方案

1.9 数据库安全方案的设计

### **2. 实现部分**

2.1 表格创建（含约束条件）

2.2 数据录入

2.3 视图创建和使用

2.4 常见操作的实例演示

2.5 数据库安全的实现

### **3. 总结**

3.1 组员分工

3.2 难点与不足分析

3.3 收获或体会及建议

# 1 设计部分 {#设计部分-1 .1级}

## 1.1 项目背景介绍 {#项目背景介绍 .2级}

### 1.1.1 AllRecipes网站概述 {#allrecipes网站概述 .3级}

AllRecipes是全球最大的食谱分享平台之一，拥有数百万用户和数百万条食谱。该网站以其用户友好的界面、丰富的食谱内容和强大的社区功能而闻名。该网站有以下五点核心功能：

**食谱发布与分享**：用户可以上传自己创作的食谱，包括详细的食材清单、烹饪步骤、烹饪时间、难度等级等信息，并支持上传高质量的图片。

**多维度食谱搜索与浏览**：用户通过关键词、菜系、食材、难度级别、烹饪时间等多个维度进行灵活搜索，发现适合自己的食谱。

**用户交互与社交功能**：包括食谱评价、评论、收藏、关注其他用户等丰富的互动方式，建立活跃的社区文化。

**个性化食谱管理**：用户可以创建多个食谱收藏清单、购物清单、膳食计划等，提高烹饪的便利性和计划性。

**健康饮食支持**：系统支持用户管理过敏原信息、查看营养信息、推荐过敏源安全食谱等功能。

![](images\media\image1.png){width="5.768055555555556in"
height="3.154861111111111in"}

### 1.1.2 核心业务数据 {#核心业务数据 .3级}

AllRecipes 的主要数据对象包括：

  数据对象                               描述                      关键属性
  -------------------------------------- ------------------------- ----------------------------------------------------
  **用户（Users）**                      平台使用者                用户名、邮箱、密码、个人资料、粉丝数、账户状态
  **食谱（Recipes）**                    烹饪菜谱                  食谱名称、描述、菜系、难度、烹饪时间、评分、浏览数
  **食材（Ingredients）**                烹饪所需原料              食材名称、分类、描述、过敏原信息
  **膳食计划（MealPlans）**              用户的一周/一月食谱安排   计划名称、时间范围、公开状态
  **购物清单（ShoppingLists）**          用户需要购买的食材        清单名称、食材列表、购买状态
  **评价和评论（Ratings & Comments）**   用户对食谱的反馈          评分、评论文本、有用性评分
  **社交关系（Followers）**              用户之间的关注关系        关注时间、粉丝数、活动流

### 业务流程分析 {#业务流程分析 .3级}

**1.1.3.1食谱发布流程**

    用户注册 → 登录 → 创建食谱 → 添加基本信息 → 添加食材→ 设置烹饪步骤 → 上传图片 → 验证和预览 → 发布

**1.1.3.2食谱浏览与评价流程**

    用户浏览 → 搜索（按菜系/食材/难度等） → 查看食谱详情 → 查看评价和评论 → 添加到收藏/清单 → 评价或评论

**1.1.3.3膳食规划流程**

    查看推荐食谱 → 创建膳食计划 → 为每天安排食谱 → 系统整合购物清单 → 生成购物清单 → 管理购物进度

**1.1.3.4社区互动流程**

    浏览用户资料 → 关注用户 → 查看关注用户的食谱 → 与用户互动（评价、评论、私信等）

## 1.2 ER图设计（概念模型） {#er图设计概念模型 .2级}

![](images\media\image2.png){width="6.6930555555555555in"
height="6.274305555555555in"}

## 数据库库表设计（逻辑模型） {#数据库库表设计逻辑模型 .2级}

1.  **USERS** ([user_id]{.ul}, username, email, password_hash,
    first_name, last_name, bio, profile_image, join_date, last_login,
    account_status, total_followers, total_recipes, created_at,
    updated_at)

2.  **INGREDIENTS** ([ingredient_id]{.ul}, ingredient_name, category,
    description, created_at)

3.  **UNITS** ([unit_id]{.ul}, unit_name, abbreviation, description,
    created_at)

4.  **ALLERGENS** ([allergen_id]{.ul}, allergen_name, description,
    created_at)

5.  **TAGS** ([tag_id]{.ul}, tag_name, tag_description, created_at)

6.  **RECIPES** ([recipe_id]{.ul}, *user_id*, recipe_name, description,
    cuisine_type, meal_type, difficulty_level, prep_time, cook_time,
    total_time, servings, calories_per_serving, image_url, is_published,
    is_deleted, view_count, rating_count, average_rating, created_at,
    updated_at)

7.  **RECIPE_INGREDIENTS** (*[recipe_id]{.ul}*, *[ingredient_id]{.ul}*,
    *unit_id*, quantity, notes, added_at)

8.  **COOKING_STEPS** ([step_id]{.ul}, *[recipe_id]{.ul}*, step_number,
    instruction, time_required, image_url)

9.  **NUTRITION_INFO** ([nutrition_id]{.ul}, *[recipe_id]{.ul}*,
    calories, protein_grams, carbs_grams, fat_grams, fiber_grams,
    sugar_grams, sodium_mg)

10. **INGREDIENT_ALLERGENS** (*[ingredient_id]{.ul}*,
    *[allergen_id]{.ul}*)

11. **INGREDIENT_SUBSTITUTIONS** (*[original_ingredient_id]{.ul}*,
    *[substitute_ingredient_id]{.ul}*, substitution_ratio, notes,
    added_at)

12. **RATINGS** ([rating_id]{.ul}, *user_id*, *recipe_id*, rating_value,
    review_text, rating_date)

13. **RATING_HELPFULNESS** (*[rating_id]{.ul}*, *[user_id]{.ul}*,
    helpful_votes, voted_at)

14. **COMMENTS** ([comment_id]{.ul}, *recipe_id*, *user_id*,
    *parent_comment_id*, comment_text, is_deleted, created_at,
    updated_at)

15. **COMMENT_HELPFULNESS** (*[comment_id]{.ul}*, *[user_id]{.ul}*,
    voted_at)

16. **SAVED_RECIPES** ([saved_recipe_id]{.ul}, *user_id*, *recipe_id*,
    saved_at)

17. **FOLLOWERS** (*[user_id]{.ul}*, *[follower_user_id]{.ul}*,
    followed_at)

18. **USER_ALLERGIES** (*[user_id]{.ul}*, *[allergen_id]{.ul}*,
    added_at)

19. **RECIPE_TAGS** (*[recipe_id]{.ul}*, *[tag_id]{.ul}*, added_at)

20. **USER_ACTIVITY_LOG** ([activity_id]{.ul}, *user_id*, activity_type,
    *recipe_id*, activity_description, activity_date)

21. **RECIPE_COLLECTIONS** ([collection_id]{.ul}, *user_id*,
    collection_name, description, is_public, created_at, updated_at)

22. **COLLECTION_RECIPES** (*[collection_id]{.ul}*, *[recipe_id]{.ul}*,
    added_at)

23. **SHOPPING_LISTS** ([list_id]{.ul}, *user_id*, list_name,
    created_at, updated_at)

24. **SHOPPING_LIST_ITEMS** (*[list_id]{.ul}*, *[ingredient_id]{.ul}*,
    quantity, *unit_id*, is_checked, added_at)

25. **MEAL_PLANS** ([plan_id]{.ul}, *user_id*, plan_name, description,
    start_date, end_date, is_public, created_at, updated_at)

26. **MEAL_PLAN_ENTRIES** (*[plan_id]{.ul}*, *[recipe_id]{.ul}*,
    [meal_date]{.ul}, meal_type, notes, added_at)

## 1.4 规范化 {#规范化 .2级}

本设计严格遵循 **BCNF（Boyce-Codd Normal Form）** 规范：

-   **第一范式（1NF）**：所有字段包含原子值，不可再分。

-   **第二范式（2NF）**：所有非主键字段完全依赖于主键（特别是针对联合主键的表，如
    `RECIPE_INGREDIENTS`，`quantity` 依赖于 `recipe_id` 和
    `ingredient_id` 的组合）。

-   **第三范式（3NF）**：消除了所有传递依赖。例如，在 `RECIPES`
    表中，用户信息只存储 `user_id`，而不存储
    `username`（通过连接查询获取），避免了数据冗余。

-   **BCNF**：消除了所有异常依赖，主键是唯一的候选键。

  表名                       主键                     规范化等级   关键设计决策
  -------------------------- ------------------------ ------------ -------------------------------------------------------
  USERS                      user_id                  BCNF         用户基本信息，total_followers/total_recipes为性能冗余
  INGREDIENTS                ingredient_id            BCNF         食材基础库，避免重复存储
  UNITS                      unit_id                  BCNF         独立单位表，支持扩展
  ALLERGENS                  allergen_id              BCNF         过敏原字典
  TAGS                       tag_id                   BCNF         标签字典
  USER_ALLERGIES             user_allergy_id          BCNF         用户过敏原关系
  RECIPES                    recipe_id                BCNF         食谱主表，包含聚合字段
  RECIPE_INGREDIENTS         recipe_ingredient_id     BCNF         N:M关系表，完全依赖于复合主键
  COOKING_STEPS              step_id                  BCNF         步骤序列保证唯一性
  NUTRITION_INFO             nutrition_id             BCNF         一对一关系，完整分离营养数据
  INGREDIENT_ALLERGENS       ingredient_allergen_id   BCNF         N:M关系表
  RECIPE_TAGS                recipe_tag_id            BCNF         N:M关系表
  RATINGS                    rating_id                BCNF         复合唯一键保证一人一评
  RATING_HELPFULNESS         helpful_id               BCNF         跟踪每个\"有用\"投票，防重复
  COMMENTS                   comment_id               BCNF         自引用支持嵌套评论
  COMMENT_HELPFULNESS        helpful_id               BCNF         跟踪每个\"有用\"投票
  SAVED_RECIPES              saved_recipe_id          BCNF         N:M关系，收藏管理
  FOLLOWERS                  follower_id              BCNF         N:M自关系，防自关注
  USER_ACTIVITY_LOG          activity_id              BCNF         活动日志，支持审计
  RECIPE_COLLECTIONS         collection_id            BCNF         用户创建的清单
  COLLECTION_RECIPES         collection_recipe_id     BCNF         N:M关系
  SHOPPING_LISTS             list_id                  BCNF         购物清单主表
  SHOPPING_LIST_ITEMS        item_id                  BCNF         清单项目
  MEAL_PLANS                 plan_id                  BCNF         膳食计划新增功能
  MEAL_PLAN_ENTRIES          entry_id                 BCNF         膳食计划条目
  INGREDIENT_SUBSTITUTIONS   substitution_id          BCNF         食材替代品知识库

## 常见操作归纳 {#常见操作归纳 .2级}

### 1.5.1查询操作（SELECT） {#查询操作select .3级}

  类别           操作名称               描述/目的
  -------------- ---------------------- ----------------------------------------------------
  基础查询       按菜系搜索食谱         根据菜系、发布状态筛选食谱，按评分和浏览量排序
                 按难度和时间查询食谱   筛选特定难度和时间限制内的食谱
                 查询用户的所有食谱     获取指定用户发布的所有未删除食谱
                 查询用户收藏的食谱     获取指定用户收藏的食谱列表
  复杂关联查询   查询食谱详情           获取食谱的基本信息、作者、营养成分及标签等完整详情
                 查询食谱食材           列出食谱所需的所有食材、用量及单位
                 查询烹饪步骤           按顺序获取食谱的制作步骤和图片
  评价与评论     查询食谱评价           获取食谱的评分、评论内容及有用性计数
                 查询食谱评论           递归查询食谱的评论树（含回复）
                 查询用户评价           获取指定用户发出的所有评价记录
  社交与推荐     查询关注/粉丝          获取用户的关注列表和粉丝列表
                 关注者食谱推荐         推荐用户关注的创作者发布的新食谱
                 特定食材搜索           查找包含指定食材（如鸡蛋、面粉）的食谱
                 安全食谱推荐           排除用户过敏食材的食谱推荐
  高级分析       热门食谱排行           基于评分、评论数、浏览数计算热度并排行
                 生成购物清单           根据膳食计划自动汇总所需食材清单
                 查询食材替代品         查找指定食材的已批准替代品及比例
                 热门食材搭配           分析高分食谱中常见的食材组合

**1.5.2 数据变更操作**

  操作类型        类别         操作名称        描述/目的
  --------------- ------------ --------------- ----------------------------------------------------
  插入 (INSERT)   用户与食谱   新用户注册      创建新的用户账户信息
                               发布新食谱      事务处理：插入食谱、食材、步骤、营养信息并记录日志
                  交互         用户评价/评论   添加评分、评论内容，并更新统计数据
                               收藏食谱        将食谱添加到用户收藏夹
                               关注用户        建立用户间的关注关系
                               点赞有用        标记评价或评论为"有用"
                  计划与清单   创建膳食计划    建立新的膳食计划记录
                               添加计划项      向膳食计划中添加食谱
                               创建购物清单    生成清单并自动导入计划所需的食材
                  设置         添加过敏原      记录用户的过敏食材信息
  更新 (UPDATE)   编辑         更新食谱信息    修改食谱详情及更新时间
                               逻辑删除        将食谱或评论标记为删除状态（保留数据）
                  状态         禁用账户        修改用户账户状态为挂起
                               购物清单勾选    标记清单中的物品为已购买
  删除 (DELETE)   清理         删除评价/收藏   物理删除评价记录或取消收藏
                               清空购物清单    删除指定清单内的所有条目
                               取消关注        移除关注关系
                               撤销投票        取消对评价/评论的"有用"标记
                               移除过敏原      删除用户的过敏记录

## 1.6 完整性约束方案设计 {#完整性约束方案设计 .2级}

### 1.6.1 约束类型说明 {#约束类型说明 .3级}

-   **PK (Primary Key)**: 主键约束，保证记录唯一性，非空。

-   **FK (Foreign Key)**: 外键约束，保证引用完整性。

-   **UK (Unique Key)**: 唯一约束，保证字段值不重复。

-   **CK (Check Constraint)**: 检查约束，保证数据符合特定条件或值域。

-   **NN (Not Null)**: 非空约束，保证字段必须有值。

-   **DF (Default)**: 默认值，当未提供值时自动填充。

### 1.6.2 详细表约束定义 {#详细表约束定义 .3级}

1\. USERS (用户表)

  约束类型   字段/表达式                                                                                                                                      详情/规则
  ---------- ------------------------------------------------------------------------------------------------------------------------------------------------ ---------------------------------------------
  **PK**     `USER_ID`                                                                                                                                        用户唯一标识
  **UK**     `USERNAME`                                                                                                                                       用户名唯一
  **UK**     `EMAIL`                                                                                                                                          邮箱唯一
  **NN**     `USER_ID`, `USERNAME`, `EMAIL`, `PASSWORD_HASH`, `JOIN_DATE`, `ACCOUNT_STATUS`, `TOTAL_FOLLOWERS`, `TOTAL_RECIPES`, `CREATED_AT`, `UPDATED_AT`   必填字段
  **CK**     `ACCOUNT_STATUS`                                                                                                                                 值域: `('active', 'inactive', 'suspended')`
  **DF**     `TOTAL_FOLLOWERS`                                                                                                                                `0`
  **DF**     `TOTAL_RECIPES`                                                                                                                                  `0`
  **DF**     `CREATED_AT`                                                                                                                                     `SYSDATE`
  **DF**     `UPDATED_AT`                                                                                                                                     `SYSDATE`

2\. INGREDIENTS (食材表)

  约束类型   字段/表达式                                                    详情/规则
  ---------- -------------------------------------------------------------- --------------
  **PK**     `INGREDIENT_ID`                                                食材唯一标识
  **UK**     `INGREDIENT_NAME`                                              食材名称唯一
  **NN**     `INGREDIENT_ID`, `INGREDIENT_NAME`, `CATEGORY`, `CREATED_AT`   必填字段
  **DF**     `CREATED_AT`                                                   `SYSDATE`

3\. UNITS (单位表)

  约束类型   字段/表达式                            详情/规则
  ---------- -------------------------------------- --------------
  **PK**     `UNIT_ID`                              单位唯一标识
  **UK**     `UNIT_NAME`                            单位名称唯一
  **NN**     `UNIT_ID`, `UNIT_NAME`, `CREATED_AT`   必填字段
  **DF**     `CREATED_AT`                           `SYSDATE`

4\. ALLERGENS (过敏原表)

  约束类型   字段/表达式                                    详情/规则
  ---------- ---------------------------------------------- ----------------
  **PK**     `ALLERGEN_ID`                                  过敏原唯一标识
  **UK**     `ALLERGEN_NAME`                                过敏原名称唯一
  **NN**     `ALLERGEN_ID`, `ALLERGEN_NAME`, `CREATED_AT`   必填字段
  **DF**     `CREATED_AT`                                   `SYSDATE`

5\. TAGS (标签表)

  约束类型   字段/表达式                          详情/规则
  ---------- ------------------------------------ --------------
  **PK**     `TAG_ID`                             标签唯一标识
  **UK**     `TAG_NAME`                           标签名称唯一
  **NN**     `TAG_ID`, `TAG_NAME`, `CREATED_AT`   必填字段
  **DF**     `CREATED_AT`                         `SYSDATE`

6\. RECIPES (食谱表)

  约束类型   字段/表达式                                                                                                    详情/规则
  ---------- -------------------------------------------------------------------------------------------------------------- --------------------------------------------------------------
  **PK**     `RECIPE_ID`                                                                                                    食谱唯一标识
  **FK**     `USER_ID`                                                                                                      引用 `USERS(USER_ID)`
  **NN**     `RECIPE_ID`, `USER_ID`, `RECIPE_NAME`, `COOK_TIME`, `IS_PUBLISHED`, `IS_DELETED`, `CREATED_AT`, `UPDATED_AT`   必填字段
  **CK**     `MEAL_TYPE`                                                                                                    值域: `('breakfast', 'lunch', 'dinner', 'snack', 'dessert')`
  **CK**     `DIFFICULTY_LEVEL`                                                                                             值域: `('easy', 'medium', 'hard')`
  **CK**     `COOK_TIME`                                                                                                    `> 0`
  **CK**     `IS_PUBLISHED`                                                                                                 值域: `('Y', 'N')`
  **CK**     `IS_DELETED`                                                                                                   值域: `('Y', 'N')`
  **DF**     `VIEW_COUNT`                                                                                                   `0`
  **DF**     `RATING_COUNT`                                                                                                 `0`
  **DF**     `AVERAGE_RATING`                                                                                               `0`
  **DF**     `CREATED_AT`                                                                                                   `SYSDATE`
  **DF**     `UPDATED_AT`                                                                                                   `SYSDATE`

7\. RECIPE_INGREDIENTS (食谱食材关联表)

  约束类型   字段/表达式                                                       详情/规则
  ---------- ----------------------------------------------------------------- -----------------------------------------------
  **PK**     `(RECIPE_ID, INGREDIENT_ID)`                                      **联合主键**，确保同一食谱不重复添加同一食材
  **FK**     `RECIPE_ID`                                                       引用 `RECIPES(RECIPE_ID)` (ON DELETE CASCADE)
  **FK**     `INGREDIENT_ID`                                                   引用 `INGREDIENTS(INGREDIENT_ID)`
  **FK**     `UNIT_ID`                                                         引用 `UNITS(UNIT_ID)`
  **NN**     `RECIPE_ID`, `INGREDIENT_ID`, `UNIT_ID`, `QUANTITY`, `ADDED_AT`   必填字段
  **DF**     `ADDED_AT`                                                        `SYSDATE`

8\. COOKING_STEPS (烹饪步骤表)

  约束类型   字段/表达式                                            详情/规则
  ---------- ------------------------------------------------------ -----------------------------------------------
  **PK**     `STEP_ID`                                              步骤唯一标识
  **FK**     `RECIPE_ID`                                            引用 `RECIPES(RECIPE_ID)` (ON DELETE CASCADE)
  **UK**     `(RECIPE_ID, STEP_NUMBER)`                             确保同一食谱的步骤序号不重复
  **NN**     `STEP_ID`, `RECIPE_ID`, `STEP_NUMBER`, `INSTRUCTION`   必填字段

9\. NUTRITION_INFO (营养信息表)

  约束类型   字段/表达式                   详情/规则
  ---------- ----------------------------- ------------------------------------------
  **PK**     `NUTRITION_ID`                营养信息唯一标识
  **FK**     `RECIPE_ID`                   引用 `RECIPES(RECIPE_ID)`
  **UK**     `RECIPE_ID`                   确保一对一关系，一个食谱只有一条营养记录
  **NN**     `NUTRITION_ID`, `RECIPE_ID`   必填字段

10\. INGREDIENT_ALLERGENS (食材过敏原关联表)

  约束类型   字段/表达式                      详情/规则
  ---------- -------------------------------- -----------------------------------
  **PK**     `(INGREDIENT_ID, ALLERGEN_ID)`   **联合主键**，确保关系唯一
  **FK**     `INGREDIENT_ID`                  引用 `INGREDIENTS(INGREDIENT_ID)`
  **FK**     `ALLERGEN_ID`                    引用 `ALLERGENS(ALLERGEN_ID)`
  **NN**     `INGREDIENT_ID`, `ALLERGEN_ID`   必填字段

11\. INGREDIENT_SUBSTITUTIONS (食材替代品关联表)

  约束类型   字段/表达式                                                        详情/规则
  ---------- ------------------------------------------------------------------ -----------------------------------
  **PK**     `(ORIGINAL_INGREDIENT_ID, SUBSTITUTE_INGREDIENT_ID)`               **联合主键**，确保关系唯一
  **FK**     `ORIGINAL_INGREDIENT_ID`                                           引用 `INGREDIENTS(INGREDIENT_ID)`
  **FK**     `SUBSTITUTE_INGREDIENT_ID`                                         引用 `INGREDIENTS(INGREDIENT_ID)`
  **CK**     `ORIGINAL_INGREDIENT_``ID !``= SUBSTITUTE_INGREDIENT_ID`           防止自引用（不能替代自己）
  **NN**     `ORIGINAL_INGREDIENT_ID`, `SUBSTITUTE_INGREDIENT_ID`, `ADDED_AT`   必填字段
  **DF**     `ADDED_AT`                                                         `SYSDATE`

12\. RATINGS (食谱评价表)

  约束类型   字段/表达式                                                          详情/规则
  ---------- -------------------------------------------------------------------- ------------------------------------
  **PK**     `RATING_ID`                                                          评价唯一标识
  **FK**     `USER_ID`                                                            引用 `USERS(USER_ID)`
  **FK**     `RECIPE_ID`                                                          引用 `RECIPES(RECIPE_ID)`
  **UK**     `(USER_ID, RECIPE_ID)`                                               确保每个用户对每个食谱只能评价一次
  **CK**     `RATING_VALUE`                                                       值域: `0 <= RATING_VALUE <= 5`
  **NN**     `RATING_ID`, `USER_ID`, `RECIPE_ID`, `RATING_VALUE`, `RATING_DATE`   必填字段
  **DF**     `RATING_DATE`                                                        `SYSDATE`

13\. RATING_HELPFULNESS (评价有用性投票表)

  约束类型   字段/表达式                          详情/规则
  ---------- ------------------------------------ --------------------------------------------------
  **PK**     `(RATING_ID, USER_ID)`               **联合主键**，确保每个用户对每个评价只能投票一次
  **FK**     `RATING_ID`                          引用 `RATINGS(RATING_ID)`
  **FK**     `USER_ID`                            引用 `USERS(USER_ID)`
  **NN**     `RATING_ID`, `USER_ID`, `VOTED_AT`   必填字段
  **DF**     `HELPFUL_VOTES`                      `0`
  **DF**     `VOTED_AT`                           `SYSDATE`

14\. COMMENTS (评论表)

  约束类型   字段/表达式                            详情/规则
  ---------- -------------------------------------- ------------------------------------------------
  **PK**     `COMMENT_ID`                           评论唯一标识
  **FK**     `RECIPE_ID`                            引用 `RECIPES(RECIPE_ID)`
  **FK**     `USER_ID`                              引用 `USERS(USER_ID)`
  **FK**     `PARENT_COMMENT_ID`                    引用 `COMMENTS(COMMENT_ID)` (自引用，用于回复)
  **NN**     `COMMENT_ID`, `RECIPE_ID`, `USER_ID`   必填字段
  **DF**     `IS_DELETED`                           `'N'`
  **DF**     `CREATED_AT`                           `SYSTIMESTAMP`
  **DF**     `UPDATED_AT`                           `SYSTIMESTAMP`

15\. COMMENT_HELPFULNESS (评论有用性投票表)

  约束类型   字段/表达式               详情/规则
  ---------- ------------------------- --------------------------------------------------
  **PK**     `(COMMENT_ID, USER_ID)`   **联合主键**，确保每个用户对每个评论只能投票一次
  **FK**     `COMMENT_ID`              引用 `COMMENTS(COMMENT_ID)`
  **FK**     `USER_ID`                 引用 `USERS(USER_ID)`
  **NN**     `COMMENT_ID`, `USER_ID`   必填字段
  **DF**     `VOTED_AT`                `SYSTIMESTAMP`

16\. SAVED_RECIPES (收藏食谱表)

  约束类型   字段/表达式                                             详情/规则
  ---------- ------------------------------------------------------- ---------------------------
  **PK**     `SAVED_RECIPE_ID`                                       收藏记录唯一标识
  **FK**     `USER_ID`                                               引用 `USERS(USER_ID)`
  **FK**     `RECIPE_ID`                                             引用 `RECIPES(RECIPE_ID)`
  **UK**     `(USER_ID, RECIPE_ID)`                                  确保不重复收藏
  **NN**     `SAVED_RECIPE_ID`, `USER_ID`, `RECIPE_ID`, `SAVED_AT`   必填字段
  **DF**     `SAVED_AT`                                              `SYSDATE`

17\. FOLLOWERS (用户关注关系表)

  约束类型   字段/表达式                                    详情/规则
  ---------- ---------------------------------------------- ----------------------------------
  **PK**     `(USER_ID, FOLLOWER_USER_ID)`                  **联合主键**，确保关注关系唯一
  **FK**     `USER_ID`                                      引用 `USERS(USER_ID)` (被关注者)
  **FK**     `FOLLOWER_USER_ID`                             引用 `USERS(USER_ID)` (关注者)
  **CK**     `USER_``ID !``= FOLLOWER_USER_ID`              防止自关注
  **NN**     `USER_ID`, `FOLLOWER_USER_ID`, `FOLLOWED_AT`   必填字段
  **DF**     `FOLLOWED_AT`                                  `SYSDATE`

18\. USER_ALLERGIES (用户过敏原关联表)

  约束类型   字段/表达式                            详情/规则
  ---------- -------------------------------------- -------------------------------
  **PK**     `(USER_ID, ALLERGEN_ID)`               **联合主键**，确保关系唯一
  **FK**     `USER_ID`                              引用 `USERS(USER_ID)`
  **FK**     `ALLERGEN_ID`                          引用 `ALLERGENS(ALLERGEN_ID)`
  **NN**     `USER_ID`, `ALLERGEN_ID`, `ADDED_AT`   必填字段
  **DF**     `ADDED_AT`                             `SYSDATE`

19\. RECIPE_TAGS (食谱标签关联表)

  约束类型   字段/表达式                         详情/规则
  ---------- ----------------------------------- ----------------------------
  **PK**     `(RECIPE_ID, TAG_ID)`               **联合主键**，确保关系唯一
  **FK**     `RECIPE_ID`                         引用 `RECIPES(RECIPE_ID)`
  **FK**     `TAG_ID`                            引用 `TAGS(TAG_ID)`
  **NN**     `RECIPE_ID`, `TAG_ID`, `ADDED_AT`   必填字段
  **DF**     `ADDED_AT`                          `SYSDATE`

20\. USER_ACTIVITY_LOG (用户活动日志表)

  约束类型   字段/表达式                                 详情/规则
  ---------- ------------------------------------------- ----------------------------------
  **PK**     `ACTIVITY_ID`                               活动记录唯一标识
  **FK**     `USER_ID`                                   引用 `USERS(USER_ID)`
  **FK**     `RECIPE_ID`                                 引用 `RECIPES(RECIPE_ID)` (可选)
  **NN**     `ACTIVITY_ID`, `USER_ID`, `ACTIVITY_DATE`   必填字段
  **DF**     `ACTIVITY_DATE`                             `SYSDATE`

21\. RECIPE_COLLECTIONS (食谱收藏清单表)

  约束类型   字段/表达式                                                                              详情/规则
  ---------- ---------------------------------------------------------------------------------------- -----------------------
  **PK**     `COLLECTION_ID`                                                                          清单唯一标识
  **FK**     `USER_ID`                                                                                引用 `USERS(USER_ID)`
  **NN**     `COLLECTION_ID`, `USER_ID`, `COLLECTION_NAME`, `IS_PUBLIC`, `CREATED_AT`, `UPDATED_AT`   必填字段
  **CK**     `IS_PUBLIC`                                                                              值域: `('Y', 'N')`
  **DF**     `IS_PUBLIC`                                                                              `'Y'`
  **DF**     `CREATED_AT`                                                                             `SYSDATE`
  **DF**     `UPDATED_AT`                                                                             `SYSDATE`

22\. COLLECTION_RECIPES (清单食谱关联表)

  约束类型   字段/表达式                                详情/规则
  ---------- ------------------------------------------ ------------------------------------------
  **PK**     `(COLLECTION_ID, RECIPE_ID)`               **联合主键**，确保关系唯一
  **FK**     `COLLECTION_ID`                            引用 `RECIPE_COLLECTIONS(COLLECTION_ID)`
  **FK**     `RECIPE_ID`                                引用 `RECIPES(RECIPE_ID)`
  **NN**     `COLLECTION_ID`, `RECIPE_ID`, `ADDED_AT`   必填字段
  **DF**     `ADDED_AT`                                 `SYSDATE`

23\. SHOPPING_LISTS (购物清单表)

  约束类型   字段/表达式                                                     详情/规则
  ---------- --------------------------------------------------------------- -----------------------
  **PK**     `LIST_ID`                                                       购物清单唯一标识
  **FK**     `USER_ID`                                                       引用 `USERS(USER_ID)`
  **NN**     `LIST_ID`, `USER_ID`, `LIST_NAME`, `CREATED_AT`, `UPDATED_AT`   必填字段
  **DF**     `CREATED_AT`                                                    `SYSDATE`
  **DF**     `UPDATED_AT`                                                    `SYSDATE`

24\. SHOPPING_LIST_ITEMS (购物清单项目表)

  约束类型   字段/表达式                                            详情/规则
  ---------- ------------------------------------------------------ -----------------------------------
  **PK**     `(LIST_ID, INGREDIENT_ID)`                             **联合主键**，确保关系唯一
  **FK**     `LIST_ID`                                              引用 `SHOPPING_LISTS(LIST_ID)`
  **FK**     `INGREDIENT_ID`                                        引用 `INGREDIENTS(INGREDIENT_ID)`
  **FK**     `UNIT_ID`                                              引用 `UNITS(UNIT_ID)`
  **NN**     `LIST_ID`, `INGREDIENT_ID`, `IS_CHECKED`, `ADDED_AT`   必填字段
  **CK**     `IS_CHECKED`                                           值域: `('Y', 'N')`
  **DF**     `IS_CHECKED`                                           `'N'`
  **DF**     `ADDED_AT`                                             `SYSDATE`

25\. MEAL_PLANS (膳食计划表)

  约束类型   字段/表达式                                                                                            详情/规则
  ---------- ------------------------------------------------------------------------------------------------------ --------------------------------
  **PK**     `PLAN_ID`                                                                                              膳食计划唯一标识
  **FK**     `USER_ID`                                                                                              引用 `USERS(USER_ID)`
  **NN**     `PLAN_ID`, `USER_ID`, `PLAN_NAME`, `START_DATE`, `END_DATE`, `IS_PUBLIC`, `CREATED_AT`, `UPDATED_AT`   必填字段
  **CK**     `START_DATE <= END_DATE`                                                                               结束日期必须晚于或等于开始日期
  **CK**     `IS_PUBLIC`                                                                                            值域: `('Y', 'N')`
  **DF**     `IS_PUBLIC`                                                                                            `'Y'`
  **DF**     `CREATED_AT`                                                                                           `SYSDATE`
  **DF**     `UPDATED_AT`                                                                                           `SYSDATE`

26\. MEAL_PLAN_ENTRIES (膳食计划条目表)

  约束类型   字段/表达式                                       详情/规则
  ---------- ------------------------------------------------- ------------------------------------------------------
  **PK**     `(PLAN_ID, RECIPE_ID, MEAL_DATE)`                 **三字段联合主键**，确保同一计划同一天同一食谱不重复
  **FK**     `PLAN_ID`                                         引用 `MEAL_PLANS(PLAN_ID)`
  **FK**     `RECIPE_ID`                                       引用 `RECIPES(RECIPE_ID)`
  **NN**     `PLAN_ID`, `RECIPE_ID`, `MEAL_DATE`, `ADDED_AT`   必填字段
  **CK**     `MEAL_TYPE`                                       值域: `('breakfast', 'lunch', 'dinner', 'snack')`
  **DF**     `ADDED_AT`                                        `SYSDATE`

## 1.7 表的详细设计（物理模型） {#表的详细设计物理模型 .2级}

### 1.7.1 表的分类和数量统计 {#表的分类和数量统计 .3级}

  模块           表名                                                                                                                      数量     说明
  -------------- ------------------------------------------------------------------------------------------------------------------------- -------- ----------------
  **核心基础**   USERS, INGREDIENTS, UNITS, ALLERGENS, TAGS, USER_ALLERGIES                                                                6        系统基础数据表
  **食谱核心**   RECIPES, RECIPE_INGREDIENTS, COOKING_STEPS, NUTRITION_INFO, INGREDIENT_ALLERGENS, RECIPE_TAGS, INGREDIENT_SUBSTITUTIONS   7        食谱及其属性表
  **用户交互**   RATINGS, RATING_HELPFULNESS, COMMENTS, COMMENT_HELPFULNESS, SAVED_RECIPES, FOLLOWERS, USER_ACTIVITY_LOG                   7        社交和交互表
  **个人管理**   RECIPE_COLLECTIONS, COLLECTION_RECIPES, SHOPPING_LISTS, SHOPPING_LIST_ITEMS, MEAL_PLANS, MEAL_PLAN_ENTRIES                6        个性化管理表
  **总计**                                                                                                                                 **26**   完整系统

### 1.7.2 核心表详细设计 {#核心表详细设计 .3级}

用户核心表

1\. USERS表（用户表）

  字段名            数据类型        非空   主键   约束         说明
  ----------------- --------------- ------ ------ ------------ ------------------------------------
  USER_ID           NUMBER(10)      ✓      ✓      PK           用户唯一标识，自增
  USERNAME          VARCHAR2(50)    ✓             UK           用户名，唯一
  EMAIL             VARCHAR2(100)   ✓             UK           邮箱，唯一，用于登录和验证
  PASSWORD_HASH     VARCHAR2(255)   ✓                          加密后的密码哈希值
  FIRST_NAME        VARCHAR2(50)                               用户名字
  LAST_NAME         VARCHAR2(50)                               用户姓氏
  BIO               VARCHAR2(500)                              个人简介或专业资格描述
  PROFILE_IMAGE     VARCHAR2(255)                              头像图片URL
  JOIN_DATE         DATE            ✓                          注册日期
  LAST_LOGIN        TIMESTAMP                                  最后登录时间
  ACCOUNT_STATUS    VARCHAR2(20)    ✓             CK           active/inactive/suspended
  TOTAL_FOLLOWERS   NUMBER(10)      ✓             DF=0         粉丝数量（冗余字段用于性能）
  TOTAL_RECIPES     NUMBER(10)      ✓             DF=0         发布的食谱数量（冗余字段用于性能）
  CREATED_AT        TIMESTAMP       ✓             DF=SYSDATE   创建记录时间
  UPDATED_AT        TIMESTAMP       ✓             DF=SYSDATE   最后修改时间

2\. INGREDIENTS 表（食材表）

  字段名            数据类型        非空   主键   约束         说明
  ----------------- --------------- ------ ------ ------------ ----------------------------------
  INGREDIENT_ID     NUMBER(10)      ✓      ✓      PK           食材唯一标识
  INGREDIENT_NAME   VARCHAR2(100)   ✓             UK           食材名称（如：番茄、鸡蛋）
  CATEGORY          VARCHAR2(50)    ✓                          食材分类（蔬菜、肉类、调味料等）
  DESCRIPTION       VARCHAR2(255)                              食材描述和特性
  CREATED_AT        TIMESTAMP       ✓             DF=SYSDATE   创建时间

3\. UNITS 表（单位表）

  字段名         数据类型        非空   主键   约束         说明
  -------------- --------------- ------ ------ ------------ ------------------------------
  UNIT_ID        NUMBER(10)      ✓      ✓      PK           单位唯一标识
  UNIT_NAME      VARCHAR2(50)    ✓             UK           单位名称（如：克、毫升、杯）
  ABBREVIATION   VARCHAR2(20)                               单位缩写（如：g, ml, cup）
  DESCRIPTION    VARCHAR2(100)                              单位描述和转换信息
  CREATED_AT     TIMESTAMP       ✓             DF=SYSDATE   创建时间

4\. ALLERGENS 表（过敏原表）

  字段名          数据类型        非空   主键   约束         说明
  --------------- --------------- ------ ------ ------------ ------------------------------------
  ALLERGEN_ID     NUMBER(10)      ✓      ✓      PK           过敏原唯一标识
  ALLERGEN_NAME   VARCHAR2(100)   ✓             UK           过敏原名称（花生、坚果、乳制品等）
  DESCRIPTION     VARCHAR2(255)                              过敏原详细描述和影响
  CREATED_AT      TIMESTAMP       ✓             DF=SYSDATE   创建时间

5\. TAGS 表（标签**表）**

  字段名            数据类型        非空   主键   约束         说明
  ----------------- --------------- ------ ------ ------------ ------------------------------------
  TAG_ID            NUMBER(10)      ✓      ✓      PK           标签唯一标识
  TAG_NAME          VARCHAR2(50)    ✓             UK           标签名称（如：素食、低脂、快手菜）
  TAG_DESCRIPTION   VARCHAR2(255)                              标签描述
  CREATED_AT        TIMESTAMP       ✓             DF=SYSDATE   创建时间

食谱核心表

6\. RECIPES 表（食谱表）

  字段名                 数据类型         非空   主键   约束         说明
  ---------------------- ---------------- ------ ------ ------------ --------------------------------------
  RECIPE_ID              NUMBER(10)       ✓      ✓      PK           食谱唯一标识
  USER_ID                NUMBER(10)       ✓             FK           创建者用户ID
  RECIPE_NAME            VARCHAR2(200)    ✓                          食谱名称
  DESCRIPTION            VARCHAR2(1000)                              详细描述
  CUISINE_TYPE           VARCHAR2(50)                                菜系（中式、西式、日式等）
  MEAL_TYPE              VARCHAR2(20)                   CK           breakfast/lunch/dinner/snack/dessert
  DIFFICULTY_LEVEL       VARCHAR2(20)                   CK           easy/medium/hard
  PREP_TIME              NUMBER(5)                                   准备时间（分钟）
  COOK_TIME              NUMBER(5)        ✓             CK\>0        烹饪时间（分钟）
  TOTAL_TIME             NUMBER(5)                                   总时间（分钟）
  SERVINGS               NUMBER(5)                                   份数
  CALORIES_PER_SERVING   NUMBER(10)                                  每份热量
  IMAGE_URL              VARCHAR2(255)                               食谱主图URL
  IS_PUBLISHED           VARCHAR2(1)      ✓             CK           Y/N，是否发布
  IS_DELETED             VARCHAR2(1)      ✓             CK           Y/N，逻辑删除
  VIEW_COUNT             NUMBER(10)                     DF=0         浏览次数
  RATING_COUNT           NUMBER(10)                     DF=0         评价数量
  AVERAGE_RATING         NUMBER(3,2)                    DF=0         平均评分(0-5)
  CREATED_AT             TIMESTAMP        ✓             DF=SYSDATE   创建时间
  UPDATED_AT             TIMESTAMP        ✓             DF=SYSDATE   最后更新时间

7\. RECIPE_INGREDIENTS 表（食谱食材关联表 - 多对多）

  字段名          数据类型        非空   主键     约束         说明
  --------------- --------------- ------ -------- ------------ --------------------------------
  RECIPE_ID       NUMBER(10)      ✓      ✓(PK1)   FK           食谱ID，联合主键第一部分
  INGREDIENT_ID   NUMBER(10)      ✓      ✓(PK2)   FK           食材ID，联合主键第二部分
  UNIT_ID         NUMBER(10)      ✓               FK           计量单位ID
  QUANTITY        NUMBER(10,2)    ✓                            食材用量
  NOTES           VARCHAR2(255)                                特殊说明（如：切碎、预先煮沸）
  ADDED_AT        TIMESTAMP       ✓               DF=SYSDATE   添加时间

8\. COOKING_STEPS 表（烹饪步骤表）

  字段名          数据类型         非空   主键   约束              说明
  --------------- ---------------- ------ ------ ----------------- ------------------------
  STEP_ID         NUMBER(10)       ✓      ✓      PK                步骤唯一标识
  RECIPE_ID       NUMBER(10)       ✓      ✓      PK, FK            食谱ID
  STEP_NUMBER     NUMBER(5)        ✓             UK(与RECIPE_ID)   步骤序号（1,2,3\...）
  INSTRUCTION     VARCHAR2(1000)   ✓                               详细操作说明
  TIME_REQUIRED   NUMBER(5)                                        该步骤所需时间（分钟）
  IMAGE_URL       VARCHAR2(255)                                    步骤配图URL

9\. NUTRITION_INFO 表（营养信息表）

  字段名          数据类型       非空   主键   约束         说明
  --------------- -------------- ------ ------ ------------ ----------------------
  NUTRITION_ID    NUMBER(10)     ✓      ✓      PK           营养信息唯一标识
  RECIPE_ID       NUMBER(10)     ✓      ✓      PK, FK, UK   食谱ID（一对一关系）
  CALORIES        NUMBER(10)                                热量（卡路里）
  PROTEIN_GRAMS   NUMBER(10,2)                              蛋白质（克）
  CARBS_GRAMS     NUMBER(10,2)                              碳水化合物（克）
  FAT_GRAMS       NUMBER(10,2)                              脂肪（克）
  FIBER_GRAMS     NUMBER(10,2)                              纤维（克）
  SUGAR_GRAMS     NUMBER(10,2)                              糖（克）
  SODIUM_MG       NUMBER(10)                                钠（毫克）

10\. INGREDIENT_ALLERGENS 表（食材过敏原关联表 - 多对多）

  字段名          数据类型     非空   主键     约束   说明
  --------------- ------------ ------ -------- ------ ----------------------------
  INGREDIENT_ID   NUMBER(10)   ✓      ✓(PK1)   FK     食材ID，联合主键第一部分
  ALLERGEN_ID     NUMBER(10)   ✓      ✓(PK2)   FK     过敏原ID，联合主键第二部分

11\. INGREDIENT_SUBSTITUTIONS 表（食材替代品关联表 - 多对多）

  字段名                     数据类型        非空   主键     约束         说明
  -------------------------- --------------- ------ -------- ------------ ------------------------------
  ORIGINAL_INGREDIENT_ID     NUMBER(10)      ✓      ✓(PK1)   FK           原始食材ID，联合主键第一部分
  SUBSTITUTE_INGREDIENT_ID   NUMBER(10)      ✓      ✓(PK2)   FK           替代食材ID，联合主键第二部分
  SUBSTITUTION_RATIO         NUMBER(5,2)                                  替代比例（如：1.5表示1:1.5）
  NOTES                      VARCHAR2(255)                                替代说明
  ADDED_AT                   TIMESTAMP       ✓               DF=SYSDATE   添加时间

用户交互表

12\. RATINGS 表（食谱评价表）

  字段名         数据类型         非空   主键   约束         说明
  -------------- ---------------- ------ ------ ------------ ----------------
  RATING_ID      NUMBER(10)       ✓      ✓      PK           评价唯一标识
  USER_ID        NUMBER(10)       ✓             FK           评价者用户ID
  RECIPE_ID      NUMBER(10)       ✓             FK           被评价的食谱ID
  RATING_VALUE   NUMBER(3,2)      ✓             CK           评分值(0-5)
  REVIEW_TEXT    VARCHAR2(1000)                              评价文本
  RATING_DATE    TIMESTAMP        ✓             DF=SYSDATE   评价时间

13\. RATING_HELPFULNESS 表（评价有用性投票表 - 多对多）

  字段名          数据类型     非空   主键     约束         说明
  --------------- ------------ ------ -------- ------------ ----------------------------------
  RATING_ID       NUMBER(10)   ✓      ✓(PK1)   FK           被投票的评价ID，联合主键第一部分
  USER_ID         NUMBER(10)   ✓      ✓(PK2)   FK           投票者用户ID，联合主键第二部分
  HELPFUL_VOTES   NUMBER(10)                   DF=0         有用投票数
  VOTED_AT        TIMESTAMP    ✓               DF=SYSDATE   投票时间

14\. COMMENTS 表（评论表）

  字段名              数据类型         非空   主键   约束              说明
  ------------------- ---------------- ------ ------ ----------------- --------------------
  COMMENT_ID          NUMBER(10)       ✓      ✓      PK                评论唯一标识
  RECIPE_ID           NUMBER(10)       ✓             FK                食谱ID（外键）
  USER_ID             NUMBER(10)       ✓             FK                评论者用户ID
  PARENT_COMMENT_ID   NUMBER(10)                     FK                父评论ID（自引用）
  COMMENT_TEXT        VARCHAR2(1000)                                   评论内容
  IS_DELETED          VARCHAR2(1)                    DF=\'N\'          逻辑删除标记
  CREATED_AT          TIMESTAMP                      DF=SYSTIMESTAMP   创建时间
  UPDATED_AT          TIMESTAMP                      DF=SYSTIMESTAMP   更新时间

15\. COMMENT_HELPFULNESS 表（评论有用性投票表）

  字段名       数据类型     非空   主键   约束              说明
  ------------ ------------ ------ ------ ----------------- ----------------
  COMMENT_ID   NUMBER(10)   ✓      ✓      PK, FK            被投票的评论ID
  USER_ID      NUMBER(10)   ✓      ✓      PK, FK            投票者用户ID
  VOTED_AT     TIMESTAMP                  DF=SYSTIMESTAMP   投票时间

16\. SAVED_RECIPES 表（收藏食谱表）

  字段名            数据类型     非空   主键   约束         说明
  ----------------- ------------ ------ ------ ------------ ------------------
  SAVED_RECIPE_ID   NUMBER(10)   ✓      ✓      PK           收藏记录唯一标识
  USER_ID           NUMBER(10)   ✓             FK           收藏者用户ID
  RECIPE_ID         NUMBER(10)   ✓             FK           被收藏的食谱ID
  SAVED_AT          TIMESTAMP    ✓             DF=SYSDATE   收藏时间

17\. FOLLOWERS 表（用户关注关系表 - 多对多自引用）

  字段名             数据类型     非空   主键     约束         说明
  ------------------ ------------ ------ -------- ------------ ----------------------------------
  USER_ID            NUMBER(10)   ✓      ✓(PK1)   FK           被关注者用户ID，联合主键第一部分
  FOLLOWER_USER_ID   NUMBER(10)   ✓      ✓(PK2)   FK           关注者用户ID，联合主键第二部分
  FOLLOWED_AT        TIMESTAMP    ✓               DF=SYSDATE   关注时间

18\. USER_ALLERGIES 表（用户过敏原关联表 - 多对多）

  字段名        数据类型     非空   主键     约束         说明
  ------------- ------------ ------ -------- ------------ ----------------------------
  USER_ID       NUMBER(10)   ✓      ✓(PK1)   FK           用户ID，联合主键第一部分
  ALLERGEN_ID   NUMBER(10)   ✓      ✓(PK2)   FK           过敏原ID，联合主键第二部分
  ADDED_AT      TIMESTAMP    ✓               DF=SYSDATE   添加时间

19\. RECIPE_TAGS 表（食谱标签关联表 - 多对多）

  字段名      数据类型     非空   主键     约束         说明
  ----------- ------------ ------ -------- ------------ --------------------------
  RECIPE_ID   NUMBER(10)   ✓      ✓(PK1)   FK           食谱ID，联合主键第一部分
  TAG_ID      NUMBER(10)   ✓      ✓(PK2)   FK           标签ID，联合主键第二部分
  ADDED_AT    TIMESTAMP    ✓               DF=SYSDATE   添加时间

20\. USER_ACTIVITY_LOG 表（用户活动日志表）

  字段名                 数据类型        非空   主键   约束         说明
  ---------------------- --------------- ------ ------ ------------ ---------------------------------
  ACTIVITY_ID            NUMBER(10)      ✓      ✓      PK           活动记录唯一标识
  USER_ID                NUMBER(10)      ✓             FK           用户ID
  ACTIVITY_TYPE          VARCHAR2(50)                               活动类型（view/comment/rate等）
  RECIPE_ID              NUMBER(10)                    FK           相关食谱ID（可为空）
  ACTIVITY_DESCRIPTION   VARCHAR2(255)                              活动描述
  ACTIVITY_DATE          TIMESTAMP       ✓             DF=SYSDATE   活动时间

个人管理表

21\. RECIPE_COLLECTIONS 表（食谱收藏清单表）

  字段名            数据类型        非空   主键   约束          说明
  ----------------- --------------- ------ ------ ------------- -----------------
  COLLECTION_ID     NUMBER(10)      ✓      ✓      PK            清单唯一标识
  USER_ID           NUMBER(10)      ✓             FK            创建者用户ID
  COLLECTION_NAME   VARCHAR2(100)   ✓                           清单名称
  DESCRIPTION       VARCHAR2(500)                               清单描述
  IS_PUBLIC         VARCHAR2(1)     ✓             DF=\'Y\',CK   是否公开（Y/N）
  CREATED_AT        TIMESTAMP       ✓             DF=SYSDATE    创建时间
  UPDATED_AT        TIMESTAMP       ✓             DF=SYSDATE    更新时间

22\. COLLECTION_RECIPES 表（清单食谱关联表 - 多对多）

  字段名          数据类型     非空   主键     约束         说明
  --------------- ------------ ------ -------- ------------ --------------------------
  COLLECTION_ID   NUMBER(10)   ✓      ✓(PK1)   FK           清单ID，联合主键第一部分
  RECIPE_ID       NUMBER(10)   ✓      ✓(PK2)   FK           食谱ID，联合主键第二部分
  ADDED_AT        TIMESTAMP    ✓               DF=SYSDATE   添加时间

23\. SHOPPING_LISTS 表（购物清单表）

  字段名       数据类型        非空   主键   约束         说明
  ------------ --------------- ------ ------ ------------ ------------------
  LIST_ID      NUMBER(10)      ✓      ✓      PK           购物清单唯一标识
  USER_ID      NUMBER(10)      ✓             FK           用户ID
  LIST_NAME    VARCHAR2(100)   ✓                          清单名称
  CREATED_AT   TIMESTAMP       ✓             DF=SYSDATE   创建时间
  UPDATED_AT   TIMESTAMP       ✓             DF=SYSDATE   更新时间

24\. SHOPPING_LIST_ITEMS 表（购物清单项目表 - 多对多）

  字段名          数据类型       非空   主键     约束          说明
  --------------- -------------- ------ -------- ------------- ------------------------------
  LIST_ID         NUMBER(10)     ✓      ✓(PK1)   FK            购物清单ID，联合主键第一部分
  INGREDIENT_ID   NUMBER(10)     ✓      ✓(PK2)   FK            食材ID，联合主键第二部分
  QUANTITY        NUMBER(10,2)                                 数量
  UNIT_ID         NUMBER(10)                     FK            单位ID
  IS_CHECKED      VARCHAR2(1)    ✓               DF=\'N\',CK   是否已购（Y/N）
  ADDED_AT        TIMESTAMP      ✓               DF=SYSDATE    添加时间

25\. MEAL_PLANS 表（膳食计划表）

  字段名        数据类型        非空   主键   约束          说明
  ------------- --------------- ------ ------ ------------- ------------------
  PLAN_ID       NUMBER(10)      ✓      ✓      PK            膳食计划唯一标识
  USER_ID       NUMBER(10)      ✓             FK            用户ID
  PLAN_NAME     VARCHAR2(100)   ✓                           计划名称
  DESCRIPTION   VARCHAR2(500)                               计划描述
  START_DATE    DATE            ✓             CK            开始日期
  END_DATE      DATE            ✓             CK            结束日期
  IS_PUBLIC     VARCHAR2(1)     ✓             DF=\'Y\',CK   是否公开（Y/N）
  CREATED_AT    TIMESTAMP       ✓             DF=SYSDATE    创建时间
  UPDATED_AT    TIMESTAMP       ✓             DF=SYSDATE    更新时间

26\. MEAL_PLAN_ENTRIES 表（膳食计划条目表 - 多对多）

  字段名      数据类型        非空   主键     约束         说明
  ----------- --------------- ------ -------- ------------ --------------------------------------
  PLAN_ID     NUMBER(10)      ✓      ✓(PK1)   FK           膳食计划ID，联合主键第一部分
  RECIPE_ID   NUMBER(10)      ✓      ✓(PK2)   FK           食谱ID，联合主键第二部分
  MEAL_DATE   DATE            ✓      ✓(PK3)                该食谱的日期，联合主键第三部分
  MEAL_TYPE   VARCHAR2(20)                    CK           餐型（breakfast/lunch/dinner/snack）
  NOTES       VARCHAR2(255)                                特殊说明
  ADDED_AT    TIMESTAMP       ✓               DF=SYSDATE   添加时间

## 1.8 视图设计方案 {#视图设计方案 .2级}

  --------------------------------------------------------------------------------------------------------------------------------------------
  类别         视图名称                          描述/用途                                                关键数据源
  ------------ --------------------------------- -------------------------------------------------------- ------------------------------------
  用户相关     **USER_OVERVIEW**\                **个人资料页展示**。\                                    Users, Recipes, Followers, Ratings
               (用户概览)                        聚合用户的基本信息、食谱数、粉丝数、关注数及平均评分。   

               **ACTIVE_USERS**\                 **运营分析**。\                                          Users, Activity Logs
               (活跃用户)                        筛选过去7天内有发布、评分或评论行为的用户。              

               **USER_CONTRIBUTION_SCORE**\      **排行榜计算**。\                                        Users, Ratings, Comments
               (贡献评分)                        基于食谱、粉丝、互动量加权计算用户的社区贡献分。         

  食谱相关     **RECIPE_DETAIL**\                **详情页展示**。\                                        Recipes, Users, Nutrition
               (食谱详情)                        封装食谱基本信息、作者信息及营养成分，屏蔽已删除数据。   

               **POPULAR_RECIPES**\              **推荐算法**。\                                          Recipes, Ratings
               (热门食谱)                        基于评分(50%)、评价数(30%)、浏览量(20%)计算热度分。      

               **RECIPE_WITH_INGREDIENTS**\      **详情页展示**。\                                        Recipes, Ingredients, Units
               (食材清单)                        将食谱与食材、单位、过敏原表进行关联展平。               

               **RECIPE_WITH_STEPS**\            **详情页展示**。\                                        Recipes, Cooking_Steps
               (烹饪步骤)                        按顺序提取烹饪步骤，支持步骤导航（上一布/下一步）。      

  社交互动     **USER_NETWORK**\                 **个人中心**。\                                          Users, Followers, Saved_Recipes
               (社交网络)                        统计用户的社交圈数据（关注/粉丝/收藏/评论数）。          

               **USER_FEED**\                    **首页Feed流**。\                                        Followers, Activity_Log
               (用户动态)                        聚合用户关注对象的最新动态（发布、评分、评论）。         

               **TOP_CONTRIBUTORS**\             **社区发现**。\                                          Users, Ratings
               (顶级贡献者)                      按综合指标排名的优质创作者列表。                         

  健康与安全   **INGREDIENT_HEALTH_PROFILE**\    **健康分析**。\                                          Ingredients, Allergens
               (食材档案)                        展示食材的分类、过敏原信息及在食谱中的使用频率。         

               **SAFE_RECIPES_FOR_USER**\        **个性化推荐**。\                                        Recipes, User_Allergies
               (安全食谱)                        自动过滤掉当前用户过敏原的食谱列表。                     

  规划与购物   **MEAL_PLAN_SUMMARY**\            **膳食管理**。\                                          Meal_Plans, Meal_Plan_Entries
               (计划摘要)                        统计膳食计划的天数、食谱数及覆盖时段。                   

               **CONSOLIDATED_SHOPPING_LIST**\   **工具功能**。\                                          Meal_Plans, Ingredients
               (购物清单)                        合并膳食计划中所有食谱的食材，自动汇总同类食材数量。     

  分析报表     **RECIPE_QUALITY_METRICS**\       **后台审核**。\                                          Recipes, Comments, Steps
               (质量指标)                        多维度评估食谱质量（图片、步骤完整度、互动率）。         

               **MONTHLY_STATISTICS**\           **管理驾驶舱**。\                                        Recipes, Ratings, Comments
               (月度统计)                        按月统计新增食谱、活跃用户及互动总量。                   
  --------------------------------------------------------------------------------------------------------------------------------------------

## 1.9 数据库安全方案的设计 {#数据库安全方案的设计 .2级}

### 用户认证和权限管理 {#用户认证和权限管理 .3级}

### 数据库人员 {#数据库人员 .3级}

根据系统运维与业务需求，划分以下五类数据库用户角色：

  用户角色       建议用户名    描述                                   核心权限/职责
  -------------- ------------- -------------------------------------- ------------------------------------------------------
  **应用用户**   APP_USER      生产环境应用程序连接数据库使用的账户   拥有业务数据的增删改查权限，可执行业务存储过程。
  **报表用户**   REPORT_USER   用于BI报表、数据分析的只读账户         仅拥有业务数据的查询权限，严格限制对敏感字段的访问。
  **管理员**     DBA_ADMIN     数据库管理员(DBA)维护使用              拥有DBA最高权限，负责系统配置、用户管理等。
  **备份用户**   BACKUP_USER   自动化备份脚本使用的账户               拥有导出数据库、读取所有数据的权限，用于灾备。
  **审计用户**   AUDIT_USER    安全审计人员使用                       查看数据库审计日志，监控异常访问行为。

### 权限分配 {#权限分配 .3级}

  数据对象类别     具体对象示例                             APP_USER                                REPORT_USER     安全备注
  ---------------- ---------------------------------------- --------------------------------------- --------------- --------------------------------------------------------------
  **核心业务表**   RECIPES, RATINGS, COMMENTS               读写 (Select, Insert, Update, Delete)   只读 (Select)   公开业务数据，报表可分析。
  **用户敏感表**   USERS                                    读写                                    **受限只读**    报表用户通过列级安全策略，**不可见**密码、手机号等隐私字段。
  **私有数据表**   SHOPPING_LISTS, MEAL_PLANS               读写                                    **无权限**      个人私有数据，仅应用端可操作，报表端无需访问。
  **基础字典表**   INGREDIENTS, UNITS, TAGS                 只读                                    只读            基础元数据，通常由后台管理，应用端仅引用。
  **业务逻辑**     publish_recipe, rate_recipe (存储过程)   执行 (Execute)                          无权限          封装复杂业务逻辑，防止直接SQL注入。

### 数据加密策略 {#数据加密策略 .3级}

用户密码使用哈希存储。

# 2 实现部分 {#实现部分-1 .1级}

## 2.1 表格创建（可同时包括约束条件的创建） {#表格创建可同时包括约束条件的创建 .2级}

为了节省正文篇幅，sql代码实现部分见附录，正文部分仅展示运行结果。

表格创建分为两个部分：第一部分是创建所有序列，用于再插入数据时生成自增的主键；第二部分是根据1.7表的详细设计（物理模型），撰写create
table代码，顺便一次性定义完整性约束，同时创建索引。

### 2.2.1创建序列（主键自增） {#创建序列主键自增 .3级}

查询数据字典User_Sequences得到：

![](images\media\image3.png){width="3.6969389763779525in"
height="2.7286242344706912in"}

### 2.2.2创建表 {#创建表 .3级}

查询数据字典User_tables得到：

![](images\media\image4.png){width="4.791821959755031in"
height="3.5936176727909013in"}

### 2.2.3查询约束 {#查询约束 .3级}

查询数据字典User_constraints得到，将约束表导出到附件。

### 2.2.3查询索引 {#查询索引 .3级}

查询数据字典User_indexes得到，将索引表导出到附件。

## 2.2 数据录入 {#数据录入 .2级}

## 2.3 视图创建和使用 {#视图创建和使用 .2级}

## 2.4 常见操作的实例演示 {#常见操作的实例演示 .2级}

## 2.5 数据库安全的实现 {#数据库安全的实现 .2级}

### 2.5.1 数据库用户角色划分 {#数据库用户角色划分 .3级}

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

### 2.5.2 精细化权限分配 {#精细化权限分配 .3级}

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

### 2.5.3 列级安全 {#列级安全 .3级}

    -- 限制某些用户无法看到密码哈希
    GRANT SELECT(user_id, username, email, first_name, last_name, profile_image) 
    ON USERS TO report_user;

    -- 管理员可以看到所有字段
    GRANT SELECT ON USERS TO dba_admin;

### 2.5.4 密码哈希加密 {#密码哈希加密 .3级}

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

# 3 总结

## 3.1 组员分工

## 3.2 难点与不足分析

## 3.3 收获或体会及建议
