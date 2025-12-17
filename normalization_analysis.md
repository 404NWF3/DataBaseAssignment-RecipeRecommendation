# 数据库表设计规范性分析报告

本文档详细分析 AllRecipes 食谱网站数据库逻辑模型中各表的函数依赖及 BCNF (Boyce-Codd Normal Form) 规范性。

## 1. 规范化理论基础

**BCNF 定义**：
一个关系模式 R 属于 BCNF，当且仅当对于 R 的每一个非平凡函数依赖 X → Y，X 必包含 R 的候选键（即 X 是超键）。
简而言之：**每个决定因素都必须是候选键**。

---

1. **USERS** (<u>user_id</u>, username, email, password_hash, first_name, last_name, bio, profile_image, join_date, last_login, account_status, total_followers, total_recipes, created_at, updated_at)

**候选键**：
{USER_ID} (主键)，{USERNAME} (唯一键)，{EMAIL} (唯一键)
**函数依赖**：
USER_ID → {所有其他属性}，USERNAME → {所有其他属性}，EMAIL → {所有其他属性}
**BCNF 分析**：
所有非平凡函数依赖的左部（决定因素）USER_ID, USERNAME, EMAIL 均为候选键。符合BCNF。

2. **INGREDIENTS** (<u>ingredient_id</u>, ingredient_name, category, description, created_at)

**候选键**：
{INGREDIENT_ID} (主键)，{INGREDIENT_NAME} (唯一键)
**函数依赖**：
INGREDIENT_ID → {所有其他属性}，INGREDIENT_NAME → {所有其他属性}
**BCNF 分析**：
决定因素均为候选键。符合 BCNF。

3. **UNITS** (<u>unit_id</u>, unit_name, abbreviation, description, created_at)

**候选键**：
{UNIT_ID} (主键)，{UNIT_NAME} (唯一键)
**函数依赖**：
UNIT_ID → {所有其他属性}，UNIT_NAME → {所有其他属性}
**BCNF 分析**：
决定因素均为候选键。符合 BCNF。

4. **ALLERGENS** (<u>allergen_id</u>, allergen_name, description, created_at)

**候选键**：
{ALLERGEN_ID} (主键)，{ALLERGEN_NAME} (唯一键)
**函数依赖**：
ALLERGEN_ID → {所有其他属性}，ALLERGEN_NAME → {所有其他属性}
**BCNF 分析**：
决定因素均为候选键。符合 BCNF。

5. **TAGS** (<u>tag_id</u>, tag_name, tag_description, created_at)

**候选键**：
{TAG_ID} (主键)，{TAG_NAME} (唯一键)
**函数依赖**：
TAG_ID → {所有其他属性}，TAG_NAME → {所有其他属性}
**BCNF 分析**：
决定因素均为候选键。符合 BCNF。

6. **RECIPES** (<u>recipe_id</u>, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)

**候选键**：
{RECIPE_ID} (主键)
**函数依赖**：
RECIPE_ID → {所有其他属性}
**BCNF 分析**：
唯一的决定因素 RECIPE_ID 是候选键。符合 BCNF。

7. **RECIPE_INGREDIENTS** (<u>recipe_id</u>, <u>ingredient_id</u>, unit_id, quantity, notes, added_at)

**候选键**：
{RECIPE_ID, INGREDIENT_ID} (联合主键)
**函数依赖**：
{RECIPE_ID, INGREDIENT_ID} → {UNIT_ID, QUANTITY, NOTES, ADDED_AT}
**BCNF 分析**：
决定因素 {RECIPE_ID, INGREDIENT_ID} 是候选键。不存在部分依赖或传递依赖。符合 BCNF。

8. **COOKING_STEPS** (<u>step_id</u>, recipe_id, step_number, instruction, time_required, image_url)

**候选键**：
{STEP_ID} (主键)，{RECIPE_ID, STEP_NUMBER} (业务唯一键)
**函数依赖**：
STEP_ID → {所有其他属性}，{RECIPE_ID, STEP_NUMBER} → {所有其他属性}
**BCNF 分析**：
两个决定因素均为候选键。符合 BCNF。

9. **NUTRITION_INFO** (<u>nutrition_id</u>, recipe_id, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, sugar_grams, sodium_mg)

**候选键**：
{NUTRITION_ID} (主键)，{RECIPE_ID} (唯一键)
**函数依赖**：
NUTRITION_ID → {所有其他属性}，RECIPE_ID → {所有其他属性}
**BCNF 分析**：
决定因素均为候选键。符合 BCNF。

10. **INGREDIENT_ALLERGENS** (<u>ingredient_id</u>, <u>allergen_id</u>)

**候选键**：
{INGREDIENT_ID, ALLERGEN_ID} (联合主键)
**函数依赖**：
无非平凡函数依赖（全键表）。
**BCNF 分析**：
没有非平凡函数依赖。符合 BCNF。

11. **INGREDIENT_SUBSTITUTIONS** (<u>original_ingredient_id</u>, <u>substitute_ingredient_id</u>, substitution_ratio, notes, added_at)

**候选键**：
{ORIGINAL_INGREDIENT_ID, SUBSTITUTE_INGREDIENT_ID} (联合主键)
**函数依赖**：
{ORIGINAL_INGREDIENT_ID, SUBSTITUTE_INGREDIENT_ID} → {SUBSTITUTION_RATIO, NOTES, ADDED_AT}
**BCNF 分析**：
决定因素是候选键。符合 BCNF。

12. **RATINGS** (<u>rating_id</u>, user_id, recipe_id, rating_value, review_text, rating_date)

**候选键**：
{RATING_ID} (主键)，{USER_ID, RECIPE_ID} (唯一键)
**函数依赖**：
RATING_ID → {所有其他属性}，{USER_ID, RECIPE_ID} → {所有其他属性}
**BCNF 分析**：
决定因素均为候选键。符合 BCNF。

13. **RATING_HELPFULNESS** (<u>rating_id</u>, <u>user_id</u>, helpful_votes, voted_at)

**候选键**：
{RATING_ID, USER_ID} (联合主键)
**函数依赖**：
{RATING_ID, USER_ID} → {HELPFUL_VOTES, VOTED_AT}
**BCNF 分析**：
决定因素是候选键。符合 BCNF。

14. **COMMENTS** (<u>comment_id</u>, recipe_id, user_id, parent_comment_id, comment_text, is_deleted, created_at, updated_at)

**候选键**：
{COMMENT_ID} (主键)
**函数依赖**：
COMMENT_ID → {所有其他属性}
**BCNF 分析**：
决定因素是候选键。符合 BCNF。

15. **COMMENT_HELPFULNESS** (<u>comment_id</u>, <u>user_id</u>, voted_at)

**候选键**：
{COMMENT_ID, USER_ID} (联合主键)
**函数依赖**：
{COMMENT_ID, USER_ID} → {VOTED_AT}
**BCNF 分析**：
决定因素是候选键。符合 BCNF。

16. **SAVED_RECIPES** (<u>saved_recipe_id</u>, user_id, recipe_id, saved_at)

**候选键**：
{SAVED_RECIPE_ID} (主键)，{USER_ID, RECIPE_ID} (唯一键)
**函数依赖**：
SAVED_RECIPE_ID → {所有其他属性}，{USER_ID, RECIPE_ID} → {所有其他属性}
**BCNF 分析**：
决定因素均为候选键。符合 BCNF。

17. **FOLLOWERS** (<u>user_id</u>, <u>follower_user_id</u>, followed_at)

**候选键**：
{USER_ID, FOLLOWER_USER_ID} (联合主键)
**函数依赖**：
{USER_ID, FOLLOWER_USER_ID} → {FOLLOWED_AT}
**BCNF 分析**：
决定因素是候选键。符合 BCNF。

18. **USER_ALLERGIES** (<u>user_id</u>, <u>allergen_id</u>, added_at)

**候选键**：
{USER_ID, ALLERGEN_ID} (联合主键)
**函数依赖**：
{USER_ID, ALLERGEN_ID} → {ADDED_AT}
**BCNF 分析**：
决定因素是候选键。符合 BCNF。

19. **RECIPE_TAGS** (<u>recipe_id</u>, <u>tag_id</u>, added_at)

**候选键**：
{RECIPE_ID, TAG_ID} (联合主键)
**函数依赖**：
{RECIPE_ID, TAG_ID} → {ADDED_AT}
**BCNF 分析**：
决定因素是候选键。符合 BCNF。

20. **USER_ACTIVITY_LOG** (<u>activity_id</u>, user_id, activity_type, recipe_id, activity_description, activity_date)

**候选键**：
{ACTIVITY_ID} (主键)
**函数依赖**：
ACTIVITY_ID → {所有其他属性}
**BCNF 分析**：
决定因素是候选键。符合 BCNF。

21. **RECIPE_COLLECTIONS** (<u>collection_id</u>, user_id, collection_name, description, is_public, created_at, updated_at)

**候选键**：
{COLLECTION_ID} (主键)
**函数依赖**：
COLLECTION_ID → {所有其他属性}
**BCNF 分析**：
决定因素是候选键。符合 BCNF。

22. **COLLECTION_RECIPES** (<u>collection_id</u>, <u>recipe_id</u>, added_at)

**候选键**：
{COLLECTION_ID, RECIPE_ID} (联合主键)
**函数依赖**：
{COLLECTION_ID, RECIPE_ID} → {ADDED_AT}
**BCNF 分析**：
决定因素是候选键。符合 BCNF。

23. **SHOPPING_LISTS** (<u>list_id</u>, user_id, list_name, created_at, updated_at)

**候选键**：
{LIST_ID} (主键)
**函数依赖**：
LIST_ID → {所有其他属性}
**BCNF 分析**：
决定因素是候选键。符合 BCNF。

24. **SHOPPING_LIST_ITEMS** (<u>list_id</u>, <u>ingredient_id</u>, quantity, unit_id, is_checked, added_at)

**候选键**：
{LIST_ID, INGREDIENT_ID} (联合主键)
**函数依赖**：
{LIST_ID, INGREDIENT_ID} → {QUANTITY, UNIT_ID, IS_CHECKED, ADDED_AT}
**BCNF 分析**：
决定因素是候选键。符合 BCNF。

25. **MEAL_PLANS** (<u>plan_id</u>, user_id, plan_name, description, start_date, end_date, is_public, created_at, updated_at)

**候选键**：
{PLAN_ID} (主键)
**函数依赖**：
PLAN_ID → {所有其他属性}
**BCNF 分析**：
决定因素是候选键。符合 BCNF。

26. **MEAL_PLAN_ENTRIES** (<u>plan_id</u>, <u>recipe_id</u>, <u>meal_date</u>, meal_type, notes, added_at)

**候选键**：
{PLAN_ID, RECIPE_ID, MEAL_DATE} (联合主键)
**函数依赖**：
{PLAN_ID, RECIPE_ID, MEAL_DATE} → {MEAL_TYPE, NOTES, ADDED_AT}
**BCNF 分析**：
决定因素是候选键。符合 BCNF。

---

## 总结

经过对 AllRecipes 数据库逻辑模型中 26 个表的详细分析，所有表均符合 BCNF 规范。

**主要原因如下**：
1.  **单一职责原则**：每个表只描述一个实体或一种关系，避免了属性混杂。
2.  **联合主键的正确使用**：在多对多关系表（如 `RECIPE_INGREDIENTS`, `COLLECTION_RECIPES` 等）中，使用了关联实体的外键组合作为主键，确保了非主属性完全依赖于整个联合主键，消除了部分依赖。
3.  **消除传递依赖**：在实体表（如 `RECIPES`）中，只存储关联实体的 ID（如 `USER_ID`），而不存储关联实体的其他属性（如 `USERNAME`），消除了传递依赖。
4.  **唯一性约束的完善**：对于具有业务唯一性的字段组合（如 `COOKING_STEPS` 中的 `RECIPE_ID` + `STEP_NUMBER`），正确识别为候选键，确保了函数依赖的左部始终是超键。

该设计在保证数据完整性和减少冗余方面表现优异，为后续的物理实现和应用开发打下了坚实的基础。
