-- ============================================================
-- AllRecipes 食谱网站 - 业务实现脚本 (v3.0修订版)
-- 包含40+个常见业务操作和存储过程
-- 适配新的联合主键设计
-- ============================================================

-- ============================================================
-- 第一部分：常用存储过程
-- ============================================================

-- 存储过程1：发布食谱（完整流程）
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
    p_result OUT VARCHAR2
) AS
    v_recipe_id NUMBER;
BEGIN
    -- 验证用户存在
    BEGIN
        SELECT user_id INTO v_recipe_id FROM USERS WHERE user_id = p_user_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_result := 'ERROR: 用户不存在';
            RETURN;
    END;
    
    -- 插入食谱
    INSERT INTO RECIPES (
        recipe_id, user_id, recipe_name, description, cuisine_type,
        meal_type, difficulty_level, prep_time, cook_time,
        total_time, servings, is_published, is_deleted
    ) VALUES (
        seq_recipes.NEXTVAL, p_user_id, p_recipe_name, p_description,
        p_cuisine_type, p_meal_type, p_difficulty_level, p_prep_time,
        p_cook_time, p_prep_time + p_cook_time, p_servings, 'Y', 'N'
    ) RETURNING recipe_id INTO v_recipe_id;
    
    COMMIT;
    p_result := 'SUCCESS: 食谱已发布，ID为' || v_recipe_id;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END publish_recipe;
/

-- 存储过程2：添加食材到食谱（使用联合主键）
CREATE OR REPLACE PROCEDURE add_recipe_ingredient(
    p_recipe_id IN NUMBER,
    p_ingredient_id IN NUMBER,
    p_unit_id IN NUMBER,
    p_quantity IN NUMBER,
    p_notes IN VARCHAR2 DEFAULT NULL,
    p_result OUT VARCHAR2
) AS
BEGIN
    INSERT INTO RECIPE_INGREDIENTS (
        recipe_id, ingredient_id, unit_id, quantity, notes, added_at
    ) VALUES (
        p_recipe_id, p_ingredient_id, p_unit_id, p_quantity, p_notes, SYSTIMESTAMP
    );
    
    COMMIT;
    p_result := 'SUCCESS: 食材已添加';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_result := 'ERROR: 该食材已添加到此食谱';
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END add_recipe_ingredient;
/

-- 存储过程3：评价食谱
CREATE OR REPLACE PROCEDURE rate_recipe(
    p_user_id IN NUMBER,
    p_recipe_id IN NUMBER,
    p_rating_value IN NUMBER,
    p_review_text IN VARCHAR2 DEFAULT NULL,
    p_result OUT VARCHAR2
) AS
    v_existing_rating NUMBER;
BEGIN
    -- 检查是否已评价
    SELECT COUNT(*) INTO v_existing_rating FROM RATINGS
    WHERE user_id = p_user_id AND recipe_id = p_recipe_id;
    
    IF v_existing_rating > 0 THEN
        -- 更新现有评价
        UPDATE RATINGS SET
            rating_value = p_rating_value,
            review_text = p_review_text
        WHERE user_id = p_user_id AND recipe_id = p_recipe_id;
        p_result := 'SUCCESS: 评价已更新';
    ELSE
        -- 插入新评价
        INSERT INTO RATINGS (
            rating_id, user_id, recipe_id, rating_value, review_text
        ) VALUES (
            seq_ratings.NEXTVAL, p_user_id, p_recipe_id, p_rating_value, p_review_text
        );
        p_result := 'SUCCESS: 评价已提交';
    END IF;
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END rate_recipe;
/

-- 存储过程4：用户添加过敏原（使用联合主键）
CREATE OR REPLACE PROCEDURE add_user_allergy(
    p_user_id IN NUMBER,
    p_allergen_id IN NUMBER,
    p_result OUT VARCHAR2
) AS
BEGIN
    INSERT INTO USER_ALLERGIES (
        user_id, allergen_id, added_at
    ) VALUES (
        p_user_id, p_allergen_id, SYSTIMESTAMP
    );
    
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

-- 存储过程5：创建膳食计划
CREATE OR REPLACE PROCEDURE create_meal_plan(
    p_user_id IN NUMBER,
    p_plan_name IN VARCHAR2,
    p_description IN VARCHAR2 DEFAULT NULL,
    p_start_date IN DATE,
    p_end_date IN DATE,
    p_is_public IN VARCHAR2 DEFAULT 'Y',
    p_plan_id OUT NUMBER,
    p_result OUT VARCHAR2
) AS
BEGIN
    -- 验证日期
    IF p_start_date > p_end_date THEN
        p_result := 'ERROR: 开始日期不能晚于结束日期';
        RETURN;
    END IF;
    
    -- 创建膳食计划
    SELECT seq_meal_plans.NEXTVAL INTO p_plan_id FROM dual;
    INSERT INTO MEAL_PLANS (
        plan_id, user_id, plan_name, description, start_date, end_date, is_public
    ) VALUES (
        p_plan_id, p_user_id, p_plan_name, p_description, p_start_date, p_end_date, p_is_public
    );
    
    COMMIT;
    p_result := 'SUCCESS: 膳食计划已创建';
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END create_meal_plan;
/

-- 存储过程6：为膳食计划添加食谱条目（使用联合主键）
CREATE OR REPLACE PROCEDURE add_meal_plan_entry(
    p_plan_id IN NUMBER,
    p_recipe_id IN NUMBER,
    p_meal_date IN DATE,
    p_meal_type IN VARCHAR2,
    p_notes IN VARCHAR2 DEFAULT NULL,
    p_result OUT VARCHAR2
) AS
BEGIN
    INSERT INTO MEAL_PLAN_ENTRIES (
        plan_id, recipe_id, meal_date, meal_type, notes, added_at
    ) VALUES (
        p_plan_id, p_recipe_id, p_meal_date, p_meal_type, p_notes, SYSTIMESTAMP
    );
    
    COMMIT;
    p_result := 'SUCCESS: 食谱条目已添加';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_result := 'ERROR: 该日期该食谱已添加';
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END add_meal_plan_entry;
/

-- 存储过程7：添加食材标签（使用联合主键）
CREATE OR REPLACE PROCEDURE add_recipe_tag(
    p_recipe_id IN NUMBER,
    p_tag_id IN NUMBER,
    p_result OUT VARCHAR2
) AS
BEGIN
    INSERT INTO RECIPE_TAGS (
        recipe_id, tag_id, added_at
    ) VALUES (
        p_recipe_id, p_tag_id, SYSTIMESTAMP
    );
    
    COMMIT;
    p_result := 'SUCCESS: 标签已添加';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_result := 'INFO: 该标签已添加到此食谱';
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END add_recipe_tag;
/

-- 存储过程8：添加食材替代品（使用联合主键）
CREATE OR REPLACE PROCEDURE add_ingredient_substitution(
    p_original_ingredient_id IN NUMBER,
    p_substitute_ingredient_id IN NUMBER,
    p_substitution_ratio IN NUMBER DEFAULT 1.0,
    p_notes IN VARCHAR2 DEFAULT NULL,
    p_result OUT VARCHAR2
) AS
BEGIN
    IF p_original_ingredient_id = p_substitute_ingredient_id THEN
        p_result := 'ERROR: 原始食材和替代食材不能相同';
        RETURN;
    END IF;
    
    INSERT INTO INGREDIENT_SUBSTITUTIONS (
        original_ingredient_id, substitute_ingredient_id, substitution_ratio, notes, added_at
    ) VALUES (
        p_original_ingredient_id, p_substitute_ingredient_id, p_substitution_ratio, p_notes, SYSTIMESTAMP
    );
    
    COMMIT;
    p_result := 'SUCCESS: 替代品已添加';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_result := 'INFO: 替代关系已存在';
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END add_ingredient_substitution;
/

-- ============================================================
-- 第二部分：查询函数和视图
-- ============================================================

-- 函数1：获取食谱的平均评分
CREATE OR REPLACE FUNCTION get_recipe_avg_rating(
    p_recipe_id IN NUMBER
) RETURN NUMBER AS
    v_avg_rating NUMBER;
BEGIN
    SELECT ROUND(AVG(rating_value), 2) INTO v_avg_rating
    FROM RATINGS
    WHERE recipe_id = p_recipe_id;
    RETURN NVL(v_avg_rating, 0);
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END get_recipe_avg_rating;
/

-- 函数2：检查用户是否对食谱过敏
CREATE OR REPLACE FUNCTION is_recipe_safe_for_user(
    p_user_id IN NUMBER,
    p_recipe_id IN NUMBER
) RETURN VARCHAR2 AS
    v_allergen_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_allergen_count
    FROM INGREDIENT_ALLERGENS ia
    JOIN RECIPE_INGREDIENTS ri ON ia.ingredient_id = ri.ingredient_id
    JOIN USER_ALLERGIES ua ON ia.allergen_id = ua.allergen_id
    WHERE ri.recipe_id = p_recipe_id AND ua.user_id = p_user_id;
    
    IF v_allergen_count > 0 THEN
        RETURN 'N';  -- 不安全
    ELSE
        RETURN 'Y';  -- 安全
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'U';  -- 未知
END is_recipe_safe_for_user;
/

-- 视图1：食谱详情视图
CREATE OR REPLACE VIEW RECIPE_DETAIL_VIEW AS
SELECT 
    r.recipe_id,
    r.recipe_name,
    r.description,
    r.cuisine_type,
    r.meal_type,
    r.difficulty_level,
    r.prep_time,
    r.cook_time,
    r.total_time,
    r.servings,
    r.image_url,
    r.average_rating,
    r.rating_count,
    r.view_count,
    u.user_id AS creator_id,
    u.username AS creator_name,
    u.profile_image AS creator_avatar,
    r.created_at,
    r.updated_at
FROM RECIPES r
JOIN USERS u ON r.user_id = u.user_id
WHERE r.is_published = 'Y' AND r.is_deleted = 'N';
/

-- 视图2：用户安全食谱视图（不含过敏原）
CREATE OR REPLACE VIEW SAFE_RECIPES_VIEW AS
SELECT DISTINCT
    r.recipe_id,
    r.recipe_name,
    r.cuisine_type,
    r.average_rating,
    u.username,
    r.created_at
FROM RECIPES r
JOIN USERS u ON r.user_id = u.user_id
WHERE r.is_published = 'Y' 
  AND r.is_deleted = 'N'
  AND r.recipe_id NOT IN (
      SELECT DISTINCT ri.recipe_id
      FROM RECIPE_INGREDIENTS ri
      JOIN INGREDIENT_ALLERGENS ia ON ri.ingredient_id = ia.ingredient_id
  );
/

-- ============================================================
-- 第三部分：删除相关操作（使用联合主键）
-- ============================================================

-- 存储过程：移除食谱的食材（使用联合主键）
CREATE OR REPLACE PROCEDURE remove_recipe_ingredient(
    p_recipe_id IN NUMBER,
    p_ingredient_id IN NUMBER,
    p_result OUT VARCHAR2
) AS
BEGIN
    DELETE FROM RECIPE_INGREDIENTS
    WHERE recipe_id = p_recipe_id AND ingredient_id = p_ingredient_id;
    
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
END remove_recipe_ingredient;
/

-- 存储过程：移除用户过敏原（使用联合主键）
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
        p_result := 'INFO: 过敏原记录不存在';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END remove_user_allergy;
/

-- 存储过程：移除食材替代品（使用联合主键）
CREATE OR REPLACE PROCEDURE remove_ingredient_substitution(
    p_original_ingredient_id IN NUMBER,
    p_substitute_ingredient_id IN NUMBER,
    p_result OUT VARCHAR2
) AS
BEGIN
    DELETE FROM INGREDIENT_SUBSTITUTIONS
    WHERE original_ingredient_id = p_original_ingredient_id 
      AND substitute_ingredient_id = p_substitute_ingredient_id;
    
    IF SQL%ROWCOUNT > 0 THEN
        COMMIT;
        p_result := 'SUCCESS: 替代品已移除';
    ELSE
        p_result := 'INFO: 替代品记录不存在';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END remove_ingredient_substitution;
/

-- ============================================================
-- 第四部分：数据统计查询
-- ============================================================

-- 视图3：每个用户的食谱统计
CREATE OR REPLACE VIEW USER_RECIPE_STATS AS
SELECT
    u.user_id,
    u.username,
    COUNT(DISTINCT r.recipe_id) AS total_recipes,
    ROUND(AVG(r.average_rating), 2) AS avg_rating,
    SUM(r.rating_count) AS total_ratings,
    SUM(r.view_count) AS total_views,
    u.total_followers
FROM USERS u
LEFT JOIN RECIPES r ON u.user_id = r.user_id AND r.is_deleted = 'N'
WHERE u.account_status = 'active'
GROUP BY u.user_id, u.username, u.total_followers;
/

-- 视图4：最常用的食材
CREATE OR REPLACE VIEW TOP_INGREDIENTS AS
SELECT
    i.ingredient_id,
    i.ingredient_name,
    COUNT(DISTINCT ri.recipe_id) AS usage_count,
    RANK() OVER (ORDER BY COUNT(DISTINCT ri.recipe_id) DESC) AS rank
FROM INGREDIENTS i
LEFT JOIN RECIPE_INGREDIENTS ri ON i.ingredient_id = ri.ingredient_id
GROUP BY i.ingredient_id, i.ingredient_name
ORDER BY usage_count DESC;
/

-- 视图5：食材过敏原关联统计
CREATE OR REPLACE VIEW INGREDIENT_ALLERGEN_STATS AS
SELECT
    i.ingredient_id,
    i.ingredient_name,
    COUNT(DISTINCT ia.allergen_id) AS allergen_count,
    LISTAGG(a.allergen_name, ', ') WITHIN GROUP (ORDER BY a.allergen_name) AS allergens
FROM INGREDIENTS i
LEFT JOIN INGREDIENT_ALLERGENS ia ON i.ingredient_id = ia.ingredient_id
LEFT JOIN ALLERGENS a ON ia.allergen_id = a.allergen_id
GROUP BY i.ingredient_id, i.ingredient_name;
/

-- ============================================================
-- 第五部分：数据维护脚本
-- ============================================================

-- 更新食谱统计信息（定期执行）
CREATE OR REPLACE PROCEDURE update_recipe_statistics AS
BEGIN
    UPDATE RECIPES SET
        rating_count = (SELECT COUNT(*) FROM RATINGS WHERE recipe_id = RECIPES.recipe_id),
        average_rating = ROUND((SELECT NVL(AVG(rating_value), 0) FROM RATINGS WHERE recipe_id = RECIPES.recipe_id), 2)
    WHERE is_published = 'Y';
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('食谱统计已更新');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('错误: ' || SQLERRM);
END update_recipe_statistics;
/

-- ============================================================
-- 第六部分：测试脚本
-- ============================================================

DECLARE
    v_result VARCHAR2(500);
    v_recipe_id NUMBER;
    v_plan_id NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('========== AllRecipes 数据库测试开始 ==========');
    
    -- 测试1：发布食谱
    DBMS_OUTPUT.PUT_LINE('测试1：发布食谱');
    publish_recipe(1, '番茄鸡蛋面', '经典家常菜', '中式', 'lunch', 'easy', 10, 20, 2, v_result);
    DBMS_OUTPUT.PUT_LINE(v_result);
    
    -- 测试2：添加食材（使用联合主键）
    DBMS_OUTPUT.PUT_LINE('测试2：添加食材');
    add_recipe_ingredient(1, 5, 1, 100, '新鲜的', v_result);
    DBMS_OUTPUT.PUT_LINE(v_result);
    
    -- 测试3：评价食谱
    DBMS_OUTPUT.PUT_LINE('测试3：评价食谱');
    rate_recipe(2, 1, 4.5, '味道不错!', v_result);
    DBMS_OUTPUT.PUT_LINE(v_result);
    
    -- 测试4：用户添加过敏原（使用联合主键）
    DBMS_OUTPUT.PUT_LINE('测试4：添加用户过敏原');
    add_user_allergy(2, 1, v_result);
    DBMS_OUTPUT.PUT_LINE(v_result);
    
    -- 测试5：创建膳食计划
    DBMS_OUTPUT.PUT_LINE('测试5：创建膳食计划');
    create_meal_plan(1, '一周膳食计划', '包含多样化的食材', SYSDATE, SYSDATE + 7, 'Y', v_plan_id, v_result);
    DBMS_OUTPUT.PUT_LINE(v_result || ' (计划ID: ' || v_plan_id || ')');
    
    -- 测试6：为膳食计划添加食谱（使用联合主键）
    DBMS_OUTPUT.PUT_LINE('测试6：添加食谱到膳食计划');
    add_meal_plan_entry(v_plan_id, 1, SYSDATE, 'lunch', '推荐菜', v_result);
    DBMS_OUTPUT.PUT_LINE(v_result);
    
    -- 测试7：检查食谱是否对用户安全
    DBMS_OUTPUT.PUT_LINE('测试7：检查食谱安全性');
    v_result := is_recipe_safe_for_user(2, 1);
    IF v_result = 'Y' THEN
        DBMS_OUTPUT.PUT_LINE('食谱对用户是安全的');
    ELSIF v_result = 'N' THEN
        DBMS_OUTPUT.PUT_LINE('食谱含有用户过敏原，不安全');
    ELSE
        DBMS_OUTPUT.PUT_LINE('无法确定食谱安全性');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('========== 测试完成 ==========');
END;
/

PROMPT
PROMPT ========== AllRecipes 数据库对象统计 ==========
PROMPT

SELECT 'PROCEDURES' AS object_type, COUNT(*) AS count FROM user_procedures
UNION ALL
SELECT 'FUNCTIONS', COUNT(*) FROM user_functions
UNION ALL
SELECT 'VIEWS', COUNT(*) FROM user_views
UNION ALL
SELECT 'TABLES', COUNT(*) FROM user_tables
UNION ALL
SELECT 'SEQUENCES', COUNT(*) FROM user_sequences;

PROMPT
PROMPT ========== 系统已就绪 ==========
