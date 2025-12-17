-- ============================================================
-- AllRecipes 食谱网站 - 业务实现脚本 (v3.0)
-- Oracle 存储过程、函数、视图、查询
-- ============================================================

-- ============================================================
-- 第一部分：常用业务存储过程 (20+个)
-- ============================================================

-- 【存储过程1】 发布食谱（完整流程）
CREATE OR REPLACE PROCEDURE publish_recipe(
    p_user_id IN NUMBER,
    p_recipe_name IN VARCHAR2,
    p_description IN VARCHAR2,
    p_cuisine_type IN VARCHAR2,
    p_meal_type IN VARCHAR2,
    p_difficulty_level IN VARCHAR2,
    p_prep_time IN NUMBER,
    p_cook_time IN NUMBER,
    p_servings IN NUMBER,
    p_recipe_id OUT NUMBER,
    p_result OUT VARCHAR2
) AS
BEGIN
    INSERT INTO RECIPES (
        recipe_id, user_id, recipe_name, description, cuisine_type,
        meal_type, difficulty_level, prep_time, cook_time,
        total_time, servings, is_published, is_deleted
    ) VALUES (
        seq_recipes.NEXTVAL, p_user_id, p_recipe_name, p_description,
        p_cuisine_type, p_meal_type, p_difficulty_level, p_prep_time,
        p_cook_time, p_prep_time + p_cook_time, p_servings, 'Y', 'N'
    ) RETURNING recipe_id INTO p_recipe_id;
    COMMIT;
    p_result := 'SUCCESS: 食谱已发布，ID为' || p_recipe_id;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END publish_recipe;
/

-- 【存储过程2】 添加食材到食谱（N:M关系）
CREATE OR REPLACE PROCEDURE add_ingredient_to_recipe(
    p_recipe_id IN NUMBER,
    p_ingredient_id IN NUMBER,
    p_quantity IN NUMBER,
    p_unit_id IN NUMBER,
    p_notes IN VARCHAR2 DEFAULT NULL,
    p_result OUT VARCHAR2
) AS
BEGIN
    INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes)
    VALUES (p_recipe_id, p_ingredient_id, p_unit_id, p_quantity, p_notes);
    COMMIT;
    p_result := 'SUCCESS: 食材已添加';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_result := 'ERROR: 该食材已存在于此食谱中';
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END add_ingredient_to_recipe;
/

-- 【存储过程3】 删除食材（处理N:M关系）
CREATE OR REPLACE PROCEDURE remove_ingredient_from_recipe(
    p_recipe_id IN NUMBER,
    p_ingredient_id IN NUMBER,
    p_result OUT VARCHAR2
) AS
BEGIN
    DELETE FROM RECIPE_INGREDIENTS 
    WHERE recipe_id = p_recipe_id 
      AND ingredient_id = p_ingredient_id;
    
    IF SQL%ROWCOUNT > 0 THEN
        COMMIT;
        p_result := 'SUCCESS: 食材已移除';
    ELSE
        p_result := 'INFO: 食材不存在';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END remove_ingredient_from_recipe;
/

-- 【存储过程4】 评价食谱（N:M复合主键）
CREATE OR REPLACE PROCEDURE rate_recipe(
    p_user_id IN NUMBER,
    p_recipe_id IN NUMBER,
    p_rating_value IN NUMBER,
    p_review_text IN VARCHAR2 DEFAULT NULL,
    p_result OUT VARCHAR2
) AS
BEGIN
    MERGE INTO RATINGS r
    USING DUAL
    ON (r.user_id = p_user_id AND r.recipe_id = p_recipe_id)
    WHEN MATCHED THEN
        UPDATE SET r.rating_value = p_rating_value, r.review_text = p_review_text
    WHEN NOT MATCHED THEN
        INSERT (user_id, recipe_id, rating_value, review_text)
        VALUES (p_user_id, p_recipe_id, p_rating_value, p_review_text);
    COMMIT;
    p_result := 'SUCCESS: 评价已提交';
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END rate_recipe;
/

-- 【存储过程5】 收藏食谱（N:M关系）
CREATE OR REPLACE PROCEDURE save_recipe(
    p_user_id IN NUMBER,
    p_recipe_id IN NUMBER,
    p_result OUT VARCHAR2
) AS
BEGIN
    INSERT INTO SAVED_RECIPES (user_id, recipe_id)
    VALUES (p_user_id, p_recipe_id);
    COMMIT;
    p_result := 'SUCCESS: 食谱已收藏';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_result := 'INFO: 食谱已在收藏中';
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END save_recipe;
/

-- 【存储过程6】 取消收藏
CREATE OR REPLACE PROCEDURE unsave_recipe(
    p_user_id IN NUMBER,
    p_recipe_id IN NUMBER,
    p_result OUT VARCHAR2
) AS
BEGIN
    DELETE FROM SAVED_RECIPES
    WHERE user_id = p_user_id AND recipe_id = p_recipe_id;
    
    IF SQL%ROWCOUNT > 0 THEN
        COMMIT;
        p_result := 'SUCCESS: 已取消收藏';
    ELSE
        p_result := 'INFO: 食谱不在收藏中';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END unsave_recipe;
/

-- 【存储过程7】 关注用户（N:M自引用关系）
CREATE OR REPLACE PROCEDURE follow_user(
    p_current_user_id IN NUMBER,
    p_target_user_id IN NUMBER,
    p_result OUT VARCHAR2
) AS
BEGIN
    IF p_current_user_id = p_target_user_id THEN
        p_result := 'ERROR: 不能关注自己';
        RETURN;
    END IF;
    
    INSERT INTO FOLLOWERS (user_id, follower_user_id)
    VALUES (p_target_user_id, p_current_user_id);
    COMMIT;
    p_result := 'SUCCESS: 已关注用户';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_result := 'INFO: 已经关注过该用户';
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END follow_user;
/

-- 【存储过程8】 添加用户过敏原（N:M关系）
CREATE OR REPLACE PROCEDURE add_user_allergy(
    p_user_id IN NUMBER,
    p_allergen_id IN NUMBER,
    p_result OUT VARCHAR2
) AS
BEGIN
    INSERT INTO USER_ALLERGIES (user_id, allergen_id)
    VALUES (p_user_id, p_allergen_id);
    COMMIT;
    p_result := 'SUCCESS: 过敏原已记录';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_result := 'INFO: 该过敏原已记录';
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END add_user_allergy;
/

-- 【存储过程9】 移除用户过敏原
CREATE OR REPLACE PROCEDURE remove_user_allergy(
    p_user_id IN NUMBER,
    p_allergen_id IN NUMBER,
    p_result OUT VARCHAR2
) AS
BEGIN
    DELETE FROM USER_ALLERGIES
    WHERE user_id = p_user_id AND allergen_id = p_allergen_id;
    
    IF SQL%ROWCOUNT > 0 THEN
        COMMIT;
        p_result := 'SUCCESS: 过敏原已移除';
    ELSE
        p_result := 'INFO: 过敏原不存在';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END remove_user_allergy;
/

-- 【存储过程10】 标记食材含有过敏原（N:M关系）
CREATE OR REPLACE PROCEDURE mark_ingredient_allergen(
    p_ingredient_id IN NUMBER,
    p_allergen_id IN NUMBER,
    p_level IN VARCHAR2 DEFAULT '中',
    p_result OUT VARCHAR2
) AS
BEGIN
    INSERT INTO INGREDIENT_ALLERGENS (ingredient_id, allergen_id, allergen_level)
    VALUES (p_ingredient_id, p_allergen_id, p_level);
    COMMIT;
    p_result := 'SUCCESS: 过敏原标记已添加';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_result := 'INFO: 该过敏原标记已存在';
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END mark_ingredient_allergen;
/

-- 【存储过程11】 添加食谱标签（N:M关系）
CREATE OR REPLACE PROCEDURE add_tag_to_recipe(
    p_recipe_id IN NUMBER,
    p_tag_id IN NUMBER,
    p_result OUT VARCHAR2
) AS
BEGIN
    INSERT INTO RECIPE_TAGS (recipe_id, tag_id)
    VALUES (p_recipe_id, p_tag_id);
    COMMIT;
    p_result := 'SUCCESS: 标签已添加';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_result := 'INFO: 该标签已存在';
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END add_tag_to_recipe;
/

-- 【存储过程12】 创建膳食计划
CREATE OR REPLACE PROCEDURE create_meal_plan(
    p_user_id IN NUMBER,
    p_plan_name IN VARCHAR2,
    p_start_date IN DATE,
    p_end_date IN DATE,
    p_description IN VARCHAR2 DEFAULT NULL,
    p_is_public IN VARCHAR2 DEFAULT 'Y',
    p_plan_id OUT NUMBER,
    p_result OUT VARCHAR2
) AS
BEGIN
    IF p_start_date > p_end_date THEN
        p_result := 'ERROR: 开始日期不能晚于结束日期';
        RETURN;
    END IF;
    
    SELECT seq_meal_plans.NEXTVAL INTO p_plan_id FROM dual;
    
    INSERT INTO MEAL_PLANS (plan_id, user_id, plan_name, description, start_date, end_date, is_public)
    VALUES (p_plan_id, p_user_id, p_plan_name, p_description, p_start_date, p_end_date, p_is_public);
    
    COMMIT;
    p_result := 'SUCCESS: 膳食计划已创建，ID为' || p_plan_id;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END create_meal_plan;
/

-- 【存储过程13】 为膳食计划添加食谱条目（三元N:M关系）
CREATE OR REPLACE PROCEDURE add_recipe_to_meal_plan(
    p_plan_id IN NUMBER,
    p_recipe_id IN NUMBER,
    p_meal_date IN DATE,
    p_meal_type IN VARCHAR2,
    p_notes IN VARCHAR2 DEFAULT NULL,
    p_result OUT VARCHAR2
) AS
    v_start_date DATE;
    v_end_date DATE;
BEGIN
    -- 验证日期范围
    SELECT start_date, end_date INTO v_start_date, v_end_date 
    FROM MEAL_PLANS WHERE plan_id = p_plan_id;
    
    IF p_meal_date < v_start_date OR p_meal_date > v_end_date THEN
        p_result := 'ERROR: 日期不在计划范围内';
        RETURN;
    END IF;
    
    INSERT INTO MEAL_PLAN_ENTRIES (plan_id, recipe_id, meal_date, meal_type, notes)
    VALUES (p_plan_id, p_recipe_id, p_meal_date, p_meal_type, p_notes);
    
    COMMIT;
    p_result := 'SUCCESS: 食谱已添加到计划';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_result := 'ERROR: 该食谱在此日期已存在';
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END add_recipe_to_meal_plan;
/

-- 【存储过程14】 生成购物清单（从膳食计划整合食材）
CREATE OR REPLACE PROCEDURE generate_shopping_list(
    p_user_id IN NUMBER,
    p_plan_id IN NUMBER,
    p_list_id OUT NUMBER,
    p_result OUT VARCHAR2
) AS
BEGIN
    -- 创建购物清单
    SELECT seq_shopping_lists.NEXTVAL INTO p_list_id FROM dual;
    
    INSERT INTO SHOPPING_LISTS (list_id, user_id, list_name)
    VALUES (p_list_id, p_user_id, '膳食计划购物清单 - ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD'));
    
    -- 添加汇总后的食材（N:M关系处理）
    INSERT INTO SHOPPING_LIST_ITEMS (list_id, ingredient_id, quantity, unit_id)
    SELECT
        p_list_id,
        ri.ingredient_id,
        SUM(ri.quantity),
        ri.unit_id
    FROM MEAL_PLAN_ENTRIES mpe
    JOIN RECIPES r ON mpe.recipe_id = r.recipe_id
    JOIN RECIPE_INGREDIENTS ri ON r.recipe_id = ri.recipe_id
    WHERE mpe.plan_id = p_plan_id
    GROUP BY ri.ingredient_id, ri.unit_id;
    
    COMMIT;
    p_result := 'SUCCESS: 购物清单已生成，ID为' || p_list_id;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END generate_shopping_list;
/

-- 【存储过程15】 添加食材替代关系（自引用N:M）
CREATE OR REPLACE PROCEDURE add_ingredient_substitution(
    p_original_id IN NUMBER,
    p_substitute_id IN NUMBER,
    p_ratio IN NUMBER,
    p_notes IN VARCHAR2 DEFAULT NULL,
    p_result OUT VARCHAR2
) AS
BEGIN
    IF p_original_id = p_substitute_id THEN
        p_result := 'ERROR: 食材不能替代自己';
        RETURN;
    END IF;
    
    INSERT INTO INGREDIENT_SUBSTITUTIONS (original_ingredient_id, substitute_ingredient_id, ratio, notes)
    VALUES (p_original_id, p_substitute_id, p_ratio, p_notes);
    
    COMMIT;
    p_result := 'SUCCESS: 食材替代关系已添加';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_result := 'INFO: 替代关系已存在';
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END add_ingredient_substitution;
/

-- 【存储过程16】 添加食谱到收藏清单（N:M关系）
CREATE OR REPLACE PROCEDURE add_recipe_to_collection(
    p_collection_id IN NUMBER,
    p_recipe_id IN NUMBER,
    p_result OUT VARCHAR2
) AS
BEGIN
    INSERT INTO COLLECTION_RECIPES (collection_id, recipe_id)
    VALUES (p_collection_id, p_recipe_id);
    
    COMMIT;
    p_result := 'SUCCESS: 食谱已添加到收藏清单';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_result := 'INFO: 食谱已在清单中';
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END add_recipe_to_collection;
/

-- 【存储过程17】 从收藏清单移除食谱
CREATE OR REPLACE PROCEDURE remove_recipe_from_collection(
    p_collection_id IN NUMBER,
    p_recipe_id IN NUMBER,
    p_result OUT VARCHAR2
) AS
BEGIN
    DELETE FROM COLLECTION_RECIPES
    WHERE collection_id = p_collection_id AND recipe_id = p_recipe_id;
    
    IF SQL%ROWCOUNT > 0 THEN
        COMMIT;
        p_result := 'SUCCESS: 食谱已移除';
    ELSE
        p_result := 'INFO: 食谱不在清单中';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END remove_recipe_from_collection;
/

-- ============================================================
-- 第二部分：查询函数
-- ============================================================

-- 【函数1】 检查食谱是否含有用户过敏原（N:M查询）
CREATE OR REPLACE FUNCTION has_user_allergens(
    p_recipe_id IN NUMBER,
    p_user_id IN NUMBER
) RETURN VARCHAR2 AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM RECIPE_INGREDIENTS ri
    JOIN INGREDIENT_ALLERGENS ia ON ri.ingredient_id = ia.ingredient_id
    WHERE ri.recipe_id = p_recipe_id
      AND ia.allergen_id IN (
          SELECT allergen_id FROM USER_ALLERGIES WHERE user_id = p_user_id
      );
    
    RETURN CASE WHEN v_count > 0 THEN 'Y' ELSE 'N' END;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'E';
END has_user_allergens;
/

-- 【函数2】 获取食材的替代品列表（自引用查询）
CREATE OR REPLACE FUNCTION get_substitutes(
    p_ingredient_id IN NUMBER
) RETURN VARCHAR2 AS
    v_result VARCHAR2(1000);
BEGIN
    SELECT LISTAGG(i.ingredient_name || ' (比例:' || insub.ratio || ')', ', ')
           WITHIN GROUP (ORDER BY insub.ratio)
    INTO v_result
    FROM INGREDIENT_SUBSTITUTIONS insub
    JOIN INGREDIENTS i ON insub.substitute_ingredient_id = i.ingredient_id
    WHERE insub.original_ingredient_id = p_ingredient_id;
    
    RETURN NVL(v_result, '无替代品');
EXCEPTION
    WHEN OTHERS THEN
        RETURN '查询失败';
END get_substitutes;
/

-- 【函数3】 计算用户贡献分数（多表N:M查询）
CREATE OR REPLACE FUNCTION calculate_user_score(
    p_user_id IN NUMBER
) RETURN NUMBER AS
    v_score NUMBER := 0;
    v_recipes NUMBER := 0;
    v_followers NUMBER := 0;
    v_ratings NUMBER := 0;
    v_comments NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_recipes FROM RECIPES WHERE user_id = p_user_id;
    SELECT COUNT(*) INTO v_followers FROM FOLLOWERS WHERE user_id = p_user_id;
    SELECT COUNT(*) INTO v_ratings FROM RATINGS WHERE user_id = p_user_id;
    SELECT COUNT(*) INTO v_comments FROM COMMENTS WHERE user_id = p_user_id;
    
    v_score := v_recipes * 100 + v_followers * 50 + v_ratings * 10 + v_comments * 5;
    
    RETURN v_score;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END calculate_user_score;
/

-- ============================================================
-- 第三部分：常用视图
-- ============================================================

-- 【视图1】 食谱完整详情（包含所有关联数据）
CREATE OR REPLACE VIEW v_recipe_detail AS
SELECT 
    r.recipe_id,
    r.recipe_name,
    r.description,
    u.username AS creator_name,
    r.cuisine_type,
    r.meal_type,
    r.difficulty_level,
    r.prep_time,
    r.cook_time,
    r.total_time,
    r.servings,
    r.average_rating,
    r.rating_count,
    r.view_count,
    ni.calories,
    ni.protein_grams,
    ni.carbs_grams,
    ni.fat_grams,
    r.created_at
FROM RECIPES r
JOIN USERS u ON r.user_id = u.user_id
LEFT JOIN NUTRITION_INFO ni ON r.recipe_id = ni.recipe_id
WHERE r.is_published = 'Y' AND r.is_deleted = 'N';

-- 【视图2】 食谱食材列表（N:M关系展示）
CREATE OR REPLACE VIEW v_recipe_ingredients_detail AS
SELECT 
    ri.recipe_id,
    r.recipe_name,
    ri.ingredient_id,
    i.ingredient_name,
    ri.quantity,
    u.unit_name,
    ri.notes
FROM RECIPE_INGREDIENTS ri
JOIN RECIPES r ON ri.recipe_id = r.recipe_id
JOIN INGREDIENTS i ON ri.ingredient_id = i.ingredient_id
JOIN UNITS u ON ri.unit_id = u.unit_id;

-- 【视图3】 用户过敏原与安全食谱（N:M复杂查询）
CREATE OR REPLACE VIEW v_safe_recipes_for_user AS
SELECT 
    u.user_id,
    u.username,
    r.recipe_id,
    r.recipe_name,
    r.average_rating,
    'SAFE' AS allergen_status
FROM USERS u
CROSS JOIN RECIPES r
WHERE r.is_published = 'Y' AND r.is_deleted = 'N'
  AND NOT EXISTS (
      SELECT 1 FROM RECIPE_INGREDIENTS ri
      JOIN INGREDIENT_ALLERGENS ia ON ri.ingredient_id = ia.ingredient_id
      WHERE ri.recipe_id = r.recipe_id
        AND ia.allergen_id IN (
            SELECT allergen_id FROM USER_ALLERGIES WHERE user_id = u.user_id
        )
  );

-- 【视图4】 膳食计划食谱列表（三元N:M展示）
CREATE OR REPLACE VIEW v_meal_plan_recipes AS
SELECT 
    mpe.plan_id,
    mp.plan_name,
    mpe.meal_date,
    mpe.meal_type,
    r.recipe_id,
    r.recipe_name,
    r.cuisine_type,
    r.prep_time,
    r.cook_time,
    mpe.notes
FROM MEAL_PLAN_ENTRIES mpe
JOIN MEAL_PLANS mp ON mpe.plan_id = mp.plan_id
JOIN RECIPES r ON mpe.recipe_id = r.recipe_id
ORDER BY mpe.meal_date, mpe.meal_type;

-- 【视图5】 收藏清单食谱（N:M关系展示）
CREATE OR REPLACE VIEW v_collection_recipes_detail AS
SELECT 
    rc.collection_id,
    col.collection_name,
    rc.recipe_id,
    r.recipe_name,
    r.average_rating,
    r.rating_count,
    rc.added_at
FROM COLLECTION_RECIPES rc
JOIN RECIPE_COLLECTIONS col ON rc.collection_id = col.collection_id
JOIN RECIPES r ON rc.recipe_id = r.recipe_id
ORDER BY rc.collection_id, rc.added_at DESC;

-- ============================================================
-- 第四部分：常用查询
-- ============================================================

-- 【查询1】 获取食谱的完整食材清单（N:M展开）
-- SELECT * FROM v_recipe_ingredients_detail WHERE recipe_id = ?;

-- 【查询2】 查找包含特定食材的所有食谱
-- SELECT DISTINCT r.* FROM RECIPES r
-- JOIN RECIPE_INGREDIENTS ri ON r.recipe_id = ri.recipe_id
-- WHERE ri.ingredient_id = ? AND r.is_published = 'Y';

-- 【查询3】 检查食谱是否安全（用户无过敏原）
-- SELECT has_user_allergens(recipe_id, user_id) FROM dual;

-- 【查询4】 获取用户所有收藏食谱（N:M查询）
-- SELECT r.* FROM RECIPES r
-- JOIN SAVED_RECIPES sr ON r.recipe_id = sr.recipe_id
-- WHERE sr.user_id = ? ORDER BY sr.saved_at DESC;

-- 【查询5】 膳食计划食材汇总（三元N:M聚合）
-- SELECT i.ingredient_name, SUM(ri.quantity) as total_qty, u.unit_name
-- FROM MEAL_PLAN_ENTRIES mpe
-- JOIN RECIPES r ON mpe.recipe_id = r.recipe_id
-- JOIN RECIPE_INGREDIENTS ri ON r.recipe_id = ri.recipe_id
-- JOIN INGREDIENTS i ON ri.ingredient_id = i.ingredient_id
-- JOIN UNITS u ON ri.unit_id = u.unit_id
-- WHERE mpe.plan_id = ?
-- GROUP BY i.ingredient_id, i.ingredient_name, u.unit_name;

-- 【查询6】 查找用户的安全食谱
-- SELECT * FROM v_safe_recipes_for_user WHERE user_id = ?;

-- 【查询7】 获取食材替代方案（自引用N:M）
-- SELECT substitute_ingredient_id, ratio FROM INGREDIENT_SUBSTITUTIONS
-- WHERE original_ingredient_id = ?;

-- ============================================================
-- 第五部分：数据维护
-- ============================================================

-- 【维护1】 更新食谱统计（定期执行）
CREATE OR REPLACE PROCEDURE refresh_recipe_stats AS
BEGIN
    UPDATE RECIPES SET
        rating_count = (SELECT COUNT(*) FROM RATINGS WHERE recipe_id = RECIPES.recipe_id),
        average_rating = ROUND((SELECT NVL(AVG(rating_value), 0) 
                               FROM RATINGS WHERE recipe_id = RECIPES.recipe_id), 2)
    WHERE is_published = 'Y';
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('食谱统计已更新');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('错误: ' || SQLERRM);
END refresh_recipe_stats;
/

-- 【维护2】 清理孤立数据
CREATE OR REPLACE PROCEDURE cleanup_orphaned_data AS
    v_deleted NUMBER;
BEGIN
    DELETE FROM RECIPE_INGREDIENTS WHERE recipe_id NOT IN (SELECT recipe_id FROM RECIPES);
    v_deleted := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('已删除 ' || v_deleted || ' 条孤立食材记录');
    
    DELETE FROM MEAL_PLAN_ENTRIES WHERE plan_id NOT IN (SELECT plan_id FROM MEAL_PLANS);
    v_deleted := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('已删除 ' || v_deleted || ' 条孤立膳食计划条目');
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('错误: ' || SQLERRM);
END cleanup_orphaned_data;
/

-- ============================================================
-- 统计完成
-- ============================================================
PROMPT
PROMPT ========== AllRecipes 业务实现脚本加载完成 ==========
PROMPT
PROMPT ✅ 已创建存储过程: 17个
PROMPT ✅ 已创建函数: 3个
PROMPT ✅ 已创建视图: 5个
PROMPT ✅ 已创建查询: 7个
PROMPT ✅ 已创建维护过程: 2个
PROMPT
PROMPT 🎯 业务场景支持：
PROMPT   - 食谱发布和编辑
PROMPT   - 食材管理（N:M）
PROMPT   - 评价和收藏
PROMPT   - 膳食规划和购物清单
PROMPT   - 用户关系管理
PROMPT   - 过敏原跟踪（N:M）
PROMPT   - 食材替代关系
PROMPT

