# 数据库表设计规范性分析报告

本文档详细分析 AllRecipes 食谱网站数据库逻辑模型中各表的函数依赖及 BCNF (Boyce-Codd Normal Form) 规范性。

## 1. 规范化理论基础

**BCNF 定义**：
一个关系模式 R 属于 BCNF，当且仅当对于 R 的每一个非平凡函数依赖 X → Y，X 必包含 R 的候选键（即 X 是超键）。
简而言之：**每个决定因素都必须是候选键**。

---

## 2. 核心基础表分析

### 2.1 USERS (用户表)
*   **属性**：USER_ID, USERNAME, EMAIL, PASSWORD_HASH, FIRST_NAME, LAST_NAME, BIO, PROFILE_IMAGE, JOIN_DATE, LAST_LOGIN, ACCOUNT_STATUS, TOTAL_FOLLOWERS, TOTAL_RECIPES, CREATED_AT, UPDATED_AT
*   **候选键**：
    1.  {USER_ID} (主键)
    2.  {USERNAME} (唯一键)
    3.  {EMAIL} (唯一键)
*   **函数依赖**：
    *   USER_ID → {所有其他属性}
    *   USERNAME → {所有其他属性}
    *   EMAIL → {所有其他属性}
*   **BCNF 分析**：
    *   所有非平凡函数依赖的左部（决定因素）USER_ID, USERNAME, EMAIL 均为候选键。
    *   **结论**：符合 BCNF。

### 2.2 INGREDIENTS (食材表)
*   **属性**：INGREDIENT_ID, INGREDIENT_NAME, CATEGORY, DESCRIPTION, CREATED_AT
*   **候选键**：
    1.  {INGREDIENT_ID} (主键)
    2.  {INGREDIENT_NAME} (唯一键)
*   **函数依赖**：
    *   INGREDIENT_ID → {所有其他属性}
    *   INGREDIENT_NAME → {所有其他属性}
*   **BCNF 分析**：
    *   决定因素均为候选键。
    *   **结论**：符合 BCNF。

### 2.3 UNITS (单位表)
*   **属性**：UNIT_ID, UNIT_NAME, ABBREVIATION, DESCRIPTION, CREATED_AT
*   **候选键**：
    1.  {UNIT_ID} (主键)
    2.  {UNIT_NAME} (唯一键)
*   **函数依赖**：
    *   UNIT_ID → {所有其他属性}
    *   UNIT_NAME → {所有其他属性}
*   **BCNF 分析**：
    *   决定因素均为候选键。
    *   **结论**：符合 BCNF。

### 2.4 ALLERGENS (过敏原表)
*   **属性**：ALLERGEN_ID, ALLERGEN_NAME, DESCRIPTION, CREATED_AT
*   **候选键**：
    1.  {ALLERGEN_ID} (主键)
    2.  {ALLERGEN_NAME} (唯一键)
*   **函数依赖**：
    *   ALLERGEN_ID → {所有其他属性}
    *   ALLERGEN_NAME → {所有其他属性}
*   **BCNF 分析**：
    *   决定因素均为候选键。
    *   **结论**：符合 BCNF。

### 2.5 TAGS (标签表)
*   **属性**：TAG_ID, TAG_NAME, TAG_DESCRIPTION, CREATED_AT
*   **候选键**：
    1.  {TAG_ID} (主键)
    2.  {TAG_NAME} (唯一键)
*   **函数依赖**：
    *   TAG_ID → {所有其他属性}
    *   TAG_NAME → {所有其他属性}
*   **BCNF 分析**：
    *   决定因素均为候选键。
    *   **结论**：符合 BCNF。

---

## 3. 食谱核心表分析

### 3.1 RECIPES (食谱表)
*   **属性**：RECIPE_ID, USER_ID, RECIPE_NAME, DESCRIPTION, CUISINE_TYPE, MEAL_TYPE, DIFFICULTY_LEVEL, PREP_TIME, COOK_TIME, TOTAL_TIME, SERVINGS, CALORIES_PER_SERVING, IMAGE_URL, IS_PUBLISHED, IS_DELETED, VIEW_COUNT, RATING_COUNT, AVERAGE_RATING, CREATED_AT, UPDATED_AT
*   **候选键**：{RECIPE_ID}
*   **函数依赖**：
    *   RECIPE_ID → {所有其他属性}
    *   注意：USER_ID 是外键，但不是候选键（一个用户可以创建多个食谱）。
*   **BCNF 分析**：
    *   唯一的决定因素 RECIPE_ID 是候选键。
    *   **结论**：符合 BCNF。

### 3.2 RECIPE_INGREDIENTS (食谱食材关联表)
*   **属性**：RECIPE_ID, INGREDIENT_ID, UNIT_ID, QUANTITY, NOTES, ADDED_AT
*   **候选键**：{RECIPE_ID, INGREDIENT_ID} (联合主键)
*   **函数依赖**：
    *   {RECIPE_ID, INGREDIENT_ID} → UNIT_ID, QUANTITY, NOTES, ADDED_AT
    *   这里不存在部分依赖（如 RECIPE_ID → QUANTITY 不成立，因为不同食材数量不同）。
    *   也不存在传递依赖。
*   **BCNF 分析**：
    *   决定因素 {RECIPE_ID, INGREDIENT_ID} 是候选键。
    *   **结论**：符合 BCNF。

### 3.3 COOKING_STEPS (烹饪步骤表)
*   **属性**：STEP_ID, RECIPE_ID, STEP_NUMBER, INSTRUCTION, TIME_REQUIRED, IMAGE_URL
*   **候选键**：
    1.  {STEP_ID} (主键)
    2.  {RECIPE_ID, STEP_NUMBER} (业务上的唯一键)
*   **函数依赖**：
    *   STEP_ID → {所有其他属性}
    *   {RECIPE_ID, STEP_NUMBER} → {所有其他属性}
*   **BCNF 分析**：
    *   两个决定因素均为候选键。
    *   **结论**：符合 BCNF。

### 3.4 NUTRITION_INFO (营养信息表)
*   **属性**：NUTRITION_ID, RECIPE_ID, CALORIES, PROTEIN_GRAMS, CARBS_GRAMS, FAT_GRAMS, FIBER_GRAMS, SUGAR_GRAMS, SODIUM_MG
*   **候选键**：
    1.  {NUTRITION_ID} (主键)
    2.  {RECIPE_ID} (唯一键，一对一关系)
*   **函数依赖**：
    *   NUTRITION_ID → {所有其他属性}
    *   RECIPE_ID → {所有其他属性}
*   **BCNF 分析**：
    *   决定因素均为候选键。
    *   **结论**：符合 BCNF。

### 3.5 INGREDIENT_ALLERGENS (食材过敏原关联表)
*   **属性**：INGREDIENT_ID, ALLERGEN_ID
*   **候选键**：{INGREDIENT_ID, ALLERGEN_ID}
*   **函数依赖**：
    *   这是全键表，只有平凡函数依赖。
*   **BCNF 分析**：
    *   没有非平凡函数依赖。
    *   **结论**：符合 BCNF。

### 3.6 INGREDIENT_SUBSTITUTIONS (食材替代品关联表)
*   **属性**：ORIGINAL_INGREDIENT_ID, SUBSTITUTE_INGREDIENT_ID, SUBSTITUTION_RATIO, NOTES, ADDED_AT
*   **候选键**：{ORIGINAL_INGREDIENT_ID, SUBSTITUTE_INGREDIENT_ID}
*   **函数依赖**：
    *   {ORIGINAL_INGREDIENT_ID, SUBSTITUTE_INGREDIENT_ID} → SUBSTITUTION_RATIO, NOTES, ADDED_AT
*   **BCNF 分析**：
    *   决定因素是候选键。
    *   **结论**：符合 BCNF。

---

## 4. 用户交互表分析

### 4.1 RATINGS (食谱评价表)
*   **属性**：RATING_ID, USER_ID, RECIPE_ID, RATING_VALUE, REVIEW_TEXT, RATING_DATE
*   **候选键**：
    1.  {RATING_ID} (主键)
    2.  {USER_ID, RECIPE_ID} (唯一键)
*   **函数依赖**：
    *   RATING_ID → {所有其他属性}
    *   {USER_ID, RECIPE_ID} → {所有其他属性}
*   **BCNF 分析**：
    *   决定因素均为候选键。
    *   **结论**：符合 BCNF。

### 4.2 RATING_HELPFULNESS (评价有用性投票表)
*   **属性**：RATING_ID, USER_ID, HELPFUL_VOTES, VOTED_AT
*   **候选键**：{RATING_ID, USER_ID}
*   **函数依赖**：
    *   {RATING_ID, USER_ID} → HELPFUL_VOTES, VOTED_AT
*   **BCNF 分析**：
    *   决定因素是候选键。
    *   **结论**：符合 BCNF。

### 4.3 COMMENTS (评论表)
*   **属性**：COMMENT_ID, RECIPE_ID, USER_ID, PARENT_COMMENT_ID, COMMENT_TEXT, IS_DELETED, CREATED_AT, UPDATED_AT
*   **候选键**：{COMMENT_ID}
*   **函数依赖**：
    *   COMMENT_ID → {所有其他属性}
*   **BCNF 分析**：
    *   决定因素是候选键。
    *   **结论**：符合 BCNF。

### 4.4 COMMENT_HELPFULNESS (评论有用性投票表)
*   **属性**：COMMENT_ID, USER_ID, VOTED_AT
*   **候选键**：{COMMENT_ID, USER_ID}
*   **函数依赖**：
    *   {COMMENT_ID, USER_ID} → VOTED_AT
*   **BCNF 分析**：
    *   决定因素是候选键。
    *   **结论**：符合 BCNF。

### 4.5 SAVED_RECIPES (收藏食谱表)
*   **属性**：SAVED_RECIPE_ID, USER_ID, RECIPE_ID, SAVED_AT
*   **候选键**：
    1.  {SAVED_RECIPE_ID} (主键)
    2.  {USER_ID, RECIPE_ID} (唯一键)
*   **函数依赖**：
    *   SAVED_RECIPE_ID → {所有其他属性}
    *   {USER_ID, RECIPE_ID} → {所有其他属性}
*   **BCNF 分析**：
    *   决定因素均为候选键。
    *   **结论**：符合 BCNF。

### 4.6 FOLLOWERS (用户关注关系表)
*   **属性**：USER_ID, FOLLOWER_USER_ID, FOLLOWED_AT
*   **候选键**：{USER_ID, FOLLOWER_USER_ID}
*   **函数依赖**：
    *   {USER_ID, FOLLOWER_USER_ID} → FOLLOWED_AT
*   **BCNF 分析**：
    *   决定因素是候选键。
    *   **结论**：符合 BCNF。

### 4.7 USER_ALLERGIES (用户过敏原关联表)
*   **属性**：USER_ID, ALLERGEN_ID, ADDED_AT
*   **候选键**：{USER_ID, ALLERGEN_ID}
*   **函数依赖**：
    *   {USER_ID, ALLERGEN_ID} → ADDED_AT
*   **BCNF 分析**：
    *   决定因素是候选键。
    *   **结论**：符合 BCNF。

### 4.8 RECIPE_TAGS (食谱标签关联表)
*   **属性**：RECIPE_ID, TAG_ID, ADDED_AT
*   **候选键**：{RECIPE_ID, TAG_ID}
*   **函数依赖**：
    *   {RECIPE_ID, TAG_ID} → ADDED_AT
*   **BCNF 分析**：
    *   决定因素是候选键。
    *   **结论**：符合 BCNF。

### 4.9 USER_ACTIVITY_LOG (用户活动日志表)
*   **属性**：ACTIVITY_ID, USER_ID, ACTIVITY_TYPE, RECIPE_ID, ACTIVITY_DESCRIPTION, ACTIVITY_DATE
*   **候选键**：{ACTIVITY_ID}
*   **函数依赖**：
    *   ACTIVITY_ID → {所有其他属性}
*   **BCNF 分析**：
    *   决定因素是候选键。
    *   **结论**：符合 BCNF。

---

## 5. 个人管理表分析

### 5.1 RECIPE_COLLECTIONS (食谱收藏清单表)
*   **属性**：COLLECTION_ID, USER_ID, COLLECTION_NAME, DESCRIPTION, IS_PUBLIC, CREATED_AT, UPDATED_AT
*   **候选键**：{COLLECTION_ID}
*   **函数依赖**：
    *   COLLECTION_ID → {所有其他属性}
*   **BCNF 分析**：
    *   决定因素是候选键。
    *   **结论**：符合 BCNF。

### 5.2 COLLECTION_RECIPES (清单食谱关联表)
*   **属性**：COLLECTION_ID, RECIPE_ID, ADDED_AT
*   **候选键**：{COLLECTION_ID, RECIPE_ID}
*   **函数依赖**：
    *   {COLLECTION_ID, RECIPE_ID} → ADDED_AT
*   **BCNF 分析**：
    *   决定因素是候选键。
    *   **结论**：符合 BCNF。

### 5.3 SHOPPING_LISTS (购物清单表)
*   **属性**：LIST_ID, USER_ID, LIST_NAME, CREATED_AT, UPDATED_AT
*   **候选键**：{LIST_ID}
*   **函数依赖**：
    *   LIST_ID → {所有其他属性}
*   **BCNF 分析**：
    *   决定因素是候选键。
    *   **结论**：符合 BCNF。

### 5.4 SHOPPING_LIST_ITEMS (购物清单项目表)
*   **属性**：LIST_ID, INGREDIENT_ID, QUANTITY, UNIT_ID, IS_CHECKED, ADDED_AT
*   **候选键**：{LIST_ID, INGREDIENT_ID}
*   **函数依赖**：
    *   {LIST_ID, INGREDIENT_ID} → QUANTITY, UNIT_ID, IS_CHECKED, ADDED_AT
*   **BCNF 分析**：
    *   决定因素是候选键。
    *   **结论**：符合 BCNF。

### 5.5 MEAL_PLANS (膳食计划表)
*   **属性**：PLAN_ID, USER_ID, PLAN_NAME, DESCRIPTION, START_DATE, END_DATE, IS_PUBLIC, CREATED_AT, UPDATED_AT
*   **候选键**：{PLAN_ID}
*   **函数依赖**：
    *   PLAN_ID → {所有其他属性}
*   **BCNF 分析**：
    *   决定因素是候选键。
    *   **结论**：符合 BCNF。

### 5.6 MEAL_PLAN_ENTRIES (膳食计划条目表)
*   **属性**：PLAN_ID, RECIPE_ID, MEAL_DATE, MEAL_TYPE, NOTES, ADDED_AT
*   **候选键**：{PLAN_ID, RECIPE_ID, MEAL_DATE}
*   **函数依赖**：
    *   {PLAN_ID, RECIPE_ID, MEAL_DATE} → MEAL_TYPE, NOTES, ADDED_AT
*   **BCNF 分析**：
    *   决定因素是候选键。
    *   **结论**：符合 BCNF。

---

## 6. 总结

经过对 AllRecipes 数据库逻辑模型中 26 个表的详细分析，所有表均符合 BCNF 规范。

**主要原因如下**：
1.  **单一职责原则**：每个表只描述一个实体或一种关系，避免了属性混杂。
2.  **联合主键的正确使用**：在多对多关系表（如 `RECIPE_INGREDIENTS`, `COLLECTION_RECIPES` 等）中，使用了关联实体的外键组合作为主键，确保了非主属性完全依赖于整个联合主键，消除了部分依赖。
3.  **消除传递依赖**：在实体表（如 `RECIPES`）中，只存储关联实体的 ID（如 `USER_ID`），而不存储关联实体的其他属性（如 `USERNAME`），消除了传递依赖。
4.  **唯一性约束的完善**：对于具有业务唯一性的字段组合（如 `COOKING_STEPS` 中的 `RECIPE_ID` + `STEP_NUMBER`），正确识别为候选键，确保了函数依赖的左部始终是超键。

该设计在保证数据完整性和减少冗余方面表现优异，为后续的物理实现和应用开发打下了坚实的基础。
