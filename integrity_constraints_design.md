# AllRecipes 数据库完整性约束方案设计文档

## 1. 概述

本文档基于 `logical_model_oracle.md` (v3.0) 和 `design_report.md`，详细记录了 AllRecipes 食谱网站数据库的所有完整性约束。

本设计严格遵循 **BCNF (Boyce-Codd Normal Form)** 规范，通过广泛使用**联合主键 (Composite Primary Keys)** 来处理多对多关系，从而保证数据的逻辑完整性和一致性。

## 2. 约束类型说明

- **PK (Primary Key)**: 主键约束，保证记录唯一性，非空。
- **FK (Foreign Key)**: 外键约束，保证引用完整性。
- **UK (Unique Key)**: 唯一约束，保证字段值不重复。
- **CK (Check Constraint)**: 检查约束，保证数据符合特定条件或值域。
- **NN (Not Null)**: 非空约束，保证字段必须有值。
- **DF (Default)**: 默认值，当未提供值时自动填充。

---

## 3. 详细表约束定义

### 1. USERS (用户表)
| 约束类型 | 字段/表达式 | 详情/规则 |
| :--- | :--- | :--- |
| **PK** | `USER_ID` | 用户唯一标识 |
| **UK** | `USERNAME` | 用户名唯一 |
| **UK** | `EMAIL` | 邮箱唯一 |
| **NN** | `USER_ID`, `USERNAME`, `EMAIL`, `PASSWORD_HASH`, `JOIN_DATE`, `ACCOUNT_STATUS`, `TOTAL_FOLLOWERS`, `TOTAL_RECIPES`, `CREATED_AT`, `UPDATED_AT` | 必填字段 |
| **CK** | `ACCOUNT_STATUS` | 值域: `('active', 'inactive', 'suspended')` |
| **DF** | `TOTAL_FOLLOWERS` | `0` |
| **DF** | `TOTAL_RECIPES` | `0` |
| **DF** | `CREATED_AT` | `SYSDATE` |
| **DF** | `UPDATED_AT` | `SYSDATE` |

### 2. INGREDIENTS (食材表)
| 约束类型 | 字段/表达式 | 详情/规则 |
| :--- | :--- | :--- |
| **PK** | `INGREDIENT_ID` | 食材唯一标识 |
| **UK** | `INGREDIENT_NAME` | 食材名称唯一 |
| **NN** | `INGREDIENT_ID`, `INGREDIENT_NAME`, `CATEGORY`, `CREATED_AT` | 必填字段 |
| **DF** | `CREATED_AT` | `SYSDATE` |

### 3. UNITS (单位表)
| 约束类型 | 字段/表达式 | 详情/规则 |
| :--- | :--- | :--- |
| **PK** | `UNIT_ID` | 单位唯一标识 |
| **UK** | `UNIT_NAME` | 单位名称唯一 |
| **NN** | `UNIT_ID`, `UNIT_NAME`, `CREATED_AT` | 必填字段 |
| **DF** | `CREATED_AT` | `SYSDATE` |

### 4. ALLERGENS (过敏原表)
| 约束类型 | 字段/表达式 | 详情/规则 |
| :--- | :--- | :--- |
| **PK** | `ALLERGEN_ID` | 过敏原唯一标识 |
| **UK** | `ALLERGEN_NAME` | 过敏原名称唯一 |
| **NN** | `ALLERGEN_ID`, `ALLERGEN_NAME`, `CREATED_AT` | 必填字段 |
| **DF** | `CREATED_AT` | `SYSDATE` |

### 5. TAGS (标签表)
| 约束类型 | 字段/表达式 | 详情/规则 |
| :--- | :--- | :--- |
| **PK** | `TAG_ID` | 标签唯一标识 |
| **UK** | `TAG_NAME` | 标签名称唯一 |
| **NN** | `TAG_ID`, `TAG_NAME`, `CREATED_AT` | 必填字段 |
| **DF** | `CREATED_AT` | `SYSDATE` |

### 6. RECIPES (食谱表)
| 约束类型 | 字段/表达式 | 详情/规则 |
| :--- | :--- | :--- |
| **PK** | `RECIPE_ID` | 食谱唯一标识 |
| **FK** | `USER_ID` | 引用 `USERS(USER_ID)` |
| **NN** | `RECIPE_ID`, `USER_ID`, `RECIPE_NAME`, `COOK_TIME`, `IS_PUBLISHED`, `IS_DELETED`, `CREATED_AT`, `UPDATED_AT` | 必填字段 |
| **CK** | `MEAL_TYPE` | 值域: `('breakfast', 'lunch', 'dinner', 'snack', 'dessert')` |
| **CK** | `DIFFICULTY_LEVEL` | 值域: `('easy', 'medium', 'hard')` |
| **CK** | `COOK_TIME` | `> 0` |
| **CK** | `IS_PUBLISHED` | 值域: `('Y', 'N')` |
| **CK** | `IS_DELETED` | 值域: `('Y', 'N')` |
| **DF** | `VIEW_COUNT` | `0` |
| **DF** | `RATING_COUNT` | `0` |
| **DF** | `AVERAGE_RATING` | `0` |
| **DF** | `CREATED_AT` | `SYSDATE` |
| **DF** | `UPDATED_AT` | `SYSDATE` |

### 7. RECIPE_INGREDIENTS (食谱食材关联表)
| 约束类型 | 字段/表达式 | 详情/规则 |
| :--- | :--- | :--- |
| **PK** | `(RECIPE_ID, INGREDIENT_ID)` | **联合主键**，确保同一食谱不重复添加同一食材 |
| **FK** | `RECIPE_ID` | 引用 `RECIPES(RECIPE_ID)` (ON DELETE CASCADE) |
| **FK** | `INGREDIENT_ID` | 引用 `INGREDIENTS(INGREDIENT_ID)` |
| **FK** | `UNIT_ID` | 引用 `UNITS(UNIT_ID)` |
| **NN** | `RECIPE_ID`, `INGREDIENT_ID`, `UNIT_ID`, `QUANTITY`, `ADDED_AT` | 必填字段 |
| **DF** | `ADDED_AT` | `SYSDATE` |

### 8. COOKING_STEPS (烹饪步骤表)
| 约束类型 | 字段/表达式 | 详情/规则 |
| :--- | :--- | :--- |
| **PK** | `STEP_ID` | 步骤唯一标识 |
| **FK** | `RECIPE_ID` | 引用 `RECIPES(RECIPE_ID)` (ON DELETE CASCADE) |
| **UK** | `(RECIPE_ID, STEP_NUMBER)` | 确保同一食谱的步骤序号不重复 |
| **NN** | `STEP_ID`, `RECIPE_ID`, `STEP_NUMBER`, `INSTRUCTION` | 必填字段 |

### 9. NUTRITION_INFO (营养信息表)
| 约束类型 | 字段/表达式 | 详情/规则 |
| :--- | :--- | :--- |
| **PK** | `NUTRITION_ID` | 营养信息唯一标识 |
| **FK** | `RECIPE_ID` | 引用 `RECIPES(RECIPE_ID)` |
| **UK** | `RECIPE_ID` | 确保一对一关系，一个食谱只有一条营养记录 |
| **NN** | `NUTRITION_ID`, `RECIPE_ID` | 必填字段 |

### 10. INGREDIENT_ALLERGENS (食材过敏原关联表)
| 约束类型 | 字段/表达式 | 详情/规则 |
| :--- | :--- | :--- |
| **PK** | `(INGREDIENT_ID, ALLERGEN_ID)` | **联合主键**，确保关系唯一 |
| **FK** | `INGREDIENT_ID` | 引用 `INGREDIENTS(INGREDIENT_ID)` |
| **FK** | `ALLERGEN_ID` | 引用 `ALLERGENS(ALLERGEN_ID)` |
| **NN** | `INGREDIENT_ID`, `ALLERGEN_ID` | 必填字段 |

### 11. INGREDIENT_SUBSTITUTIONS (食材替代品关联表)
| 约束类型 | 字段/表达式 | 详情/规则 |
| :--- | :--- | :--- |
| **PK** | `(ORIGINAL_INGREDIENT_ID, SUBSTITUTE_INGREDIENT_ID)` | **联合主键**，确保关系唯一 |
| **FK** | `ORIGINAL_INGREDIENT_ID` | 引用 `INGREDIENTS(INGREDIENT_ID)` |
| **FK** | `SUBSTITUTE_INGREDIENT_ID` | 引用 `INGREDIENTS(INGREDIENT_ID)` |
| **CK** | `ORIGINAL_INGREDIENT_ID != SUBSTITUTE_INGREDIENT_ID` | 防止自引用（不能替代自己） |
| **NN** | `ORIGINAL_INGREDIENT_ID`, `SUBSTITUTE_INGREDIENT_ID`, `ADDED_AT` | 必填字段 |
| **DF** | `ADDED_AT` | `SYSDATE` |

### 12. RATINGS (食谱评价表)
| 约束类型 | 字段/表达式 | 详情/规则 |
| :--- | :--- | :--- |
| **PK** | `RATING_ID` | 评价唯一标识 |
| **FK** | `USER_ID` | 引用 `USERS(USER_ID)` |
| **FK** | `RECIPE_ID` | 引用 `RECIPES(RECIPE_ID)` |
| **UK** | `(USER_ID, RECIPE_ID)` | 确保每个用户对每个食谱只能评价一次 |
| **CK** | `RATING_VALUE` | 值域: `0 <= RATING_VALUE <= 5` |
| **NN** | `RATING_ID`, `USER_ID`, `RECIPE_ID`, `RATING_VALUE`, `RATING_DATE` | 必填字段 |
| **DF** | `RATING_DATE` | `SYSDATE` |

### 13. RATING_HELPFULNESS (评价有用性投票表)
| 约束类型 | 字段/表达式 | 详情/规则 |
| :--- | :--- | :--- |
| **PK** | `(RATING_ID, USER_ID)` | **联合主键**，确保每个用户对每个评价只能投票一次 |
| **FK** | `RATING_ID` | 引用 `RATINGS(RATING_ID)` |
| **FK** | `USER_ID` | 引用 `USERS(USER_ID)` |
| **NN** | `RATING_ID`, `USER_ID`, `VOTED_AT` | 必填字段 |
| **DF** | `HELPFUL_VOTES` | `0` |
| **DF** | `VOTED_AT` | `SYSDATE` |

### 14. COMMENTS (评论表)
| 约束类型 | 字段/表达式 | 详情/规则 |
| :--- | :--- | :--- |
| **PK** | `COMMENT_ID` | 评论唯一标识 |
| **FK** | `RECIPE_ID` | 引用 `RECIPES(RECIPE_ID)` |
| **FK** | `USER_ID` | 引用 `USERS(USER_ID)` |
| **FK** | `PARENT_COMMENT_ID` | 引用 `COMMENTS(COMMENT_ID)` (自引用，用于回复) |
| **NN** | `COMMENT_ID`, `RECIPE_ID`, `USER_ID` | 必填字段 |
| **DF** | `IS_DELETED` | `'N'` |
| **DF** | `CREATED_AT` | `SYSTIMESTAMP` |
| **DF** | `UPDATED_AT` | `SYSTIMESTAMP` |

### 15. COMMENT_HELPFULNESS (评论有用性投票表)
| 约束类型 | 字段/表达式 | 详情/规则 |
| :--- | :--- | :--- |
| **PK** | `(COMMENT_ID, USER_ID)` | **联合主键**，确保每个用户对每个评论只能投票一次 |
| **FK** | `COMMENT_ID` | 引用 `COMMENTS(COMMENT_ID)` |
| **FK** | `USER_ID` | 引用 `USERS(USER_ID)` |
| **NN** | `COMMENT_ID`, `USER_ID` | 必填字段 |
| **DF** | `VOTED_AT` | `SYSTIMESTAMP` |

### 16. SAVED_RECIPES (收藏食谱表)
| 约束类型 | 字段/表达式 | 详情/规则 |
| :--- | :--- | :--- |
| **PK** | `SAVED_RECIPE_ID` | 收藏记录唯一标识 |
| **FK** | `USER_ID` | 引用 `USERS(USER_ID)` |
| **FK** | `RECIPE_ID` | 引用 `RECIPES(RECIPE_ID)` |
| **UK** | `(USER_ID, RECIPE_ID)` | 确保不重复收藏 |
| **NN** | `SAVED_RECIPE_ID`, `USER_ID`, `RECIPE_ID`, `SAVED_AT` | 必填字段 |
| **DF** | `SAVED_AT` | `SYSDATE` |

### 17. FOLLOWERS (用户关注关系表)
| 约束类型 | 字段/表达式 | 详情/规则 |
| :--- | :--- | :--- |
| **PK** | `(USER_ID, FOLLOWER_USER_ID)` | **联合主键**，确保关注关系唯一 |
| **FK** | `USER_ID` | 引用 `USERS(USER_ID)` (被关注者) |
| **FK** | `FOLLOWER_USER_ID` | 引用 `USERS(USER_ID)` (关注者) |
| **CK** | `USER_ID != FOLLOWER_USER_ID` | 防止自关注 |
| **NN** | `USER_ID`, `FOLLOWER_USER_ID`, `FOLLOWED_AT` | 必填字段 |
| **DF** | `FOLLOWED_AT` | `SYSDATE` |

### 18. USER_ALLERGIES (用户过敏原关联表)
| 约束类型 | 字段/表达式 | 详情/规则 |
| :--- | :--- | :--- |
| **PK** | `(USER_ID, ALLERGEN_ID)` | **联合主键**，确保关系唯一 |
| **FK** | `USER_ID` | 引用 `USERS(USER_ID)` |
| **FK** | `ALLERGEN_ID` | 引用 `ALLERGENS(ALLERGEN_ID)` |
| **NN** | `USER_ID`, `ALLERGEN_ID`, `ADDED_AT` | 必填字段 |
| **DF** | `ADDED_AT` | `SYSDATE` |

### 19. RECIPE_TAGS (食谱标签关联表)
| 约束类型 | 字段/表达式 | 详情/规则 |
| :--- | :--- | :--- |
| **PK** | `(RECIPE_ID, TAG_ID)` | **联合主键**，确保关系唯一 |
| **FK** | `RECIPE_ID` | 引用 `RECIPES(RECIPE_ID)` |
| **FK** | `TAG_ID` | 引用 `TAGS(TAG_ID)` |
| **NN** | `RECIPE_ID`, `TAG_ID`, `ADDED_AT` | 必填字段 |
| **DF** | `ADDED_AT` | `SYSDATE` |

### 20. USER_ACTIVITY_LOG (用户活动日志表)
| 约束类型 | 字段/表达式 | 详情/规则 |
| :--- | :--- | :--- |
| **PK** | `ACTIVITY_ID` | 活动记录唯一标识 |
| **FK** | `USER_ID` | 引用 `USERS(USER_ID)` |
| **FK** | `RECIPE_ID` | 引用 `RECIPES(RECIPE_ID)` (可选) |
| **NN** | `ACTIVITY_ID`, `USER_ID`, `ACTIVITY_DATE` | 必填字段 |
| **DF** | `ACTIVITY_DATE` | `SYSDATE` |

### 21. RECIPE_COLLECTIONS (食谱收藏清单表)
| 约束类型 | 字段/表达式 | 详情/规则 |
| :--- | :--- | :--- |
| **PK** | `COLLECTION_ID` | 清单唯一标识 |
| **FK** | `USER_ID` | 引用 `USERS(USER_ID)` |
| **NN** | `COLLECTION_ID`, `USER_ID`, `COLLECTION_NAME`, `IS_PUBLIC`, `CREATED_AT`, `UPDATED_AT` | 必填字段 |
| **CK** | `IS_PUBLIC` | 值域: `('Y', 'N')` |
| **DF** | `IS_PUBLIC` | `'Y'` |
| **DF** | `CREATED_AT` | `SYSDATE` |
| **DF** | `UPDATED_AT` | `SYSDATE` |

### 22. COLLECTION_RECIPES (清单食谱关联表)
| 约束类型 | 字段/表达式 | 详情/规则 |
| :--- | :--- | :--- |
| **PK** | `(COLLECTION_ID, RECIPE_ID)` | **联合主键**，确保关系唯一 |
| **FK** | `COLLECTION_ID` | 引用 `RECIPE_COLLECTIONS(COLLECTION_ID)` |
| **FK** | `RECIPE_ID` | 引用 `RECIPES(RECIPE_ID)` |
| **NN** | `COLLECTION_ID`, `RECIPE_ID`, `ADDED_AT` | 必填字段 |
| **DF** | `ADDED_AT` | `SYSDATE` |

### 23. SHOPPING_LISTS (购物清单表)
| 约束类型 | 字段/表达式 | 详情/规则 |
| :--- | :--- | :--- |
| **PK** | `LIST_ID` | 购物清单唯一标识 |
| **FK** | `USER_ID` | 引用 `USERS(USER_ID)` |
| **NN** | `LIST_ID`, `USER_ID`, `LIST_NAME`, `CREATED_AT`, `UPDATED_AT` | 必填字段 |
| **DF** | `CREATED_AT` | `SYSDATE` |
| **DF** | `UPDATED_AT` | `SYSDATE` |

### 24. SHOPPING_LIST_ITEMS (购物清单项目表)
| 约束类型 | 字段/表达式 | 详情/规则 |
| :--- | :--- | :--- |
| **PK** | `(LIST_ID, INGREDIENT_ID)` | **联合主键**，确保关系唯一 |
| **FK** | `LIST_ID` | 引用 `SHOPPING_LISTS(LIST_ID)` |
| **FK** | `INGREDIENT_ID` | 引用 `INGREDIENTS(INGREDIENT_ID)` |
| **FK** | `UNIT_ID` | 引用 `UNITS(UNIT_ID)` |
| **NN** | `LIST_ID`, `INGREDIENT_ID`, `IS_CHECKED`, `ADDED_AT` | 必填字段 |
| **CK** | `IS_CHECKED` | 值域: `('Y', 'N')` |
| **DF** | `IS_CHECKED` | `'N'` |
| **DF** | `ADDED_AT` | `SYSDATE` |

### 25. MEAL_PLANS (膳食计划表)
| 约束类型 | 字段/表达式 | 详情/规则 |
| :--- | :--- | :--- |
| **PK** | `PLAN_ID` | 膳食计划唯一标识 |
| **FK** | `USER_ID` | 引用 `USERS(USER_ID)` |
| **NN** | `PLAN_ID`, `USER_ID`, `PLAN_NAME`, `START_DATE`, `END_DATE`, `IS_PUBLIC`, `CREATED_AT`, `UPDATED_AT` | 必填字段 |
| **CK** | `START_DATE <= END_DATE` | 结束日期必须晚于或等于开始日期 |
| **CK** | `IS_PUBLIC` | 值域: `('Y', 'N')` |
| **DF** | `IS_PUBLIC` | `'Y'` |
| **DF** | `CREATED_AT` | `SYSDATE` |
| **DF** | `UPDATED_AT` | `SYSDATE` |

### 26. MEAL_PLAN_ENTRIES (膳食计划条目表)
| 约束类型 | 字段/表达式 | 详情/规则 |
| :--- | :--- | :--- |
| **PK** | `(PLAN_ID, RECIPE_ID, MEAL_DATE)` | **三字段联合主键**，确保同一计划同一天同一食谱不重复 |
| **FK** | `PLAN_ID` | 引用 `MEAL_PLANS(PLAN_ID)` |
| **FK** | `RECIPE_ID` | 引用 `RECIPES(RECIPE_ID)` |
| **NN** | `PLAN_ID`, `RECIPE_ID`, `MEAL_DATE`, `ADDED_AT` | 必填字段 |
| **CK** | `MEAL_TYPE` | 值域: `('breakfast', 'lunch', 'dinner', 'snack')` |
| **DF** | `ADDED_AT` | `SYSDATE` |
