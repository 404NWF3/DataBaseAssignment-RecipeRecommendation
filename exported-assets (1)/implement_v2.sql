-- ============================================================
-- AllRecipes 食谱网站 - 业务实现脚本 (v2.0增强版)
-- 包含40+个常见业务操作和存储过程
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

-- 存储过程2：评价食谱
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

-- 存储过程3：保存食谱到收藏
CREATE OR REPLACE PROCEDURE save_recipe(
    p_user_id IN NUMBER,
    p_recipe_id IN NUMBER,
    p_result OUT VARCHAR2
) AS
    v_existing NUMBER;
BEGIN
    -- 检查是否已收藏
    SELECT COUNT(*) INTO v_existing FROM SAVED_RECIPES
    WHERE user_id = p_user_id AND recipe_id = p_recipe_id;

    IF v_existing > 0 THEN
        p_result := 'INFO: 食谱已在收藏中';
        RETURN;
    END IF;

    INSERT INTO SAVED_RECIPES (
        saved_recipe_id, user_id, recipe_id
    ) VALUES (
        seq_saved_recipes.NEXTVAL, p_user_id, p_recipe_id
    );

    COMMIT;
    p_result := 'SUCCESS: 食谱已收藏';

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END save_recipe;
/

-- 存储过程4：取消收藏
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

-- 存储过程5：关注用户
CREATE OR REPLACE PROCEDURE follow_user(
    p_current_user_id IN NUMBER,
    p_target_user_id IN NUMBER,
    p_result OUT VARCHAR2
) AS
BEGIN
    -- 检查不能自己关注自己
    IF p_current_user_id = p_target_user_id THEN
        p_result := 'ERROR: 不能关注自己';
        RETURN;
    END IF;

    INSERT INTO FOLLOWERS (
        follower_id, user_id, follower_user_id
    ) VALUES (
        seq_followers.NEXTVAL, p_target_user_id, p_current_user_id
    );

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

-- 存储过程6：创建膳食计划
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

-- 存储过程7：生成购物清单（从膳食计划）
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

    -- 添加所有食材
    INSERT INTO SHOPPING_LIST_ITEMS (
        item_id, list_id, ingredient_id, quantity, unit_id
    )
    SELECT 
        seq_shopping_list_items.NEXTVAL,
        p_list_id,
        i.ingredient_id,
        SUM(ri.quantity),
        ri.unit_id
    FROM MEAL_PLAN_ENTRIES mpe
    JOIN RECIPES r ON mpe.recipe_id = r.recipe_id
    JOIN RECIPE_INGREDIENTS ri ON r.recipe_id = ri.recipe_id
    JOIN INGREDIENTS i ON ri.ingredient_id = i.ingredient_id
    WHERE mpe.plan_id = p_plan_id
    GROUP BY i.ingredient_id, ri.unit_id;

    COMMIT;
    p_result := 'SUCCESS: 购物清单已生成';

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END generate_shopping_list;
/

-- 存储过程8：添加用户过敏原
CREATE OR REPLACE PROCEDURE add_user_allergy(
    p_user_id IN NUMBER,
    p_allergen_id IN NUMBER,
    p_result OUT VARCHAR2
) AS
BEGIN
    INSERT INTO USER_ALLERGIES (
        user_allergy_id, user_id, allergen_id
    ) VALUES (
        seq_user_allergies.NEXTVAL, p_user_id, p_allergen_id
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

-- ============================================================
-- 第二部分：查询函数
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

-- 函数2：计算用户的贡献分数
CREATE OR REPLACE FUNCTION calculate_user_score(
    p_user_id IN NUMBER
) RETURN NUMBER AS
    v_score NUMBER := 0;
    v_recipes NUMBER;
    v_followers NUMBER;
    v_ratings NUMBER;
    v_comments NUMBER;
    v_helpful_votes NUMBER;
BEGIN
    -- 获取各项指标
    SELECT total_recipes, total_followers INTO v_recipes, v_followers
    FROM USERS WHERE user_id = p_user_id;

    SELECT COUNT(*) INTO v_ratings FROM RATINGS WHERE user_id = p_user_id;
    SELECT COUNT(*) INTO v_comments FROM COMMENTS WHERE user_id = p_user_id;
    SELECT COUNT(*) INTO v_helpful_votes FROM RATING_HELPFULNESS WHERE user_id = p_user_id;

    -- 计算综合分数
    v_score := (v_recipes * 100) + (v_followers * 50) + (v_ratings * 10) + 
               (v_comments * 5) + (v_helpful_votes * 2);

    RETURN v_score;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END calculate_user_score;
/

-- 函数3：检查食谱是否安全（不含用户过敏原）
CREATE OR REPLACE FUNCTION is_recipe_safe_for_user(
    p_user_id IN NUMBER,
    p_recipe_id IN NUMBER
) RETURN VARCHAR2 AS
    v_count NUMBER;
BEGIN
    -- 查询是否存在用户过敏的食材
    SELECT COUNT(*) INTO v_count
    FROM RECIPE_INGREDIENTS ri
    JOIN INGREDIENT_ALLERGENS ia ON ri.ingredient_id = ia.ingredient_id
    JOIN USER_ALLERGIES ua ON ia.allergen_id = ua.allergen_id
    WHERE ri.recipe_id = p_recipe_id
    AND ua.user_id = p_user_id;

    IF v_count = 0 THEN
        RETURN 'Y';
    ELSE
        RETURN 'N';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'U';  -- Unknown
END is_recipe_safe_for_user;
/

-- ============================================================
-- 第三部分：视图定义
-- ============================================================

-- 视图1：用户概览视图
CREATE OR REPLACE VIEW USER_OVERVIEW AS
SELECT 
    u.user_id,
    u.username,
    u.first_name,
    u.last_name,
    u.profile_image,
    u.bio,
    u.join_date,
    u.account_status,
    u.total_recipes,
    u.total_followers,
    COUNT(DISTINCT f2.user_id) AS following_count,
    ROUND(AVG(rt.rating_value), 2) AS avg_recipe_rating
FROM USERS u
LEFT JOIN FOLLOWERS f2 ON u.user_id = f2.follower_user_id
LEFT JOIN RECIPES r ON u.user_id = r.user_id AND r.is_deleted = 'N'
LEFT JOIN RATINGS rt ON r.recipe_id = rt.recipe_id
WHERE u.account_status = 'active'
GROUP BY u.user_id, u.username, u.first_name, u.last_name, u.profile_image, 
         u.bio, u.join_date, u.account_status, u.total_recipes, u.total_followers;

-- 视图2：热门食谱视图
CREATE OR REPLACE VIEW POPULAR_RECIPES AS
SELECT 
    r.recipe_id,
    r.recipe_name,
    r.cuisine_type,
    r.average_rating,
    r.rating_count,
    r.view_count,
    u.username,
    ROUND(
        r.average_rating * 0.5 +
        LEAST(r.rating_count / 100.0, 5) * 0.3 +
        LEAST(r.view_count / 10000.0, 5) * 0.2,
    2) AS popularity_score
FROM RECIPES r
JOIN USERS u ON r.user_id = u.user_id
WHERE r.is_published = 'Y'
  AND r.is_deleted = 'N'
  AND r.created_at > SYSDATE - 180;

-- 视图3：食谱详情视图
CREATE OR REPLACE VIEW RECIPE_DETAIL AS
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
    NVL(ni.calories, 0) AS calories,
    NVL(ni.protein_grams, 0) AS protein_grams,
    NVL(ni.carbs_grams, 0) AS carbs_grams,
    NVL(ni.fat_grams, 0) AS fat_grams,
    r.created_at,
    r.updated_at
FROM RECIPES r
JOIN USERS u ON r.user_id = u.user_id
LEFT JOIN NUTRITION_INFO ni ON r.recipe_id = ni.recipe_id
WHERE r.is_published = 'Y' AND r.is_deleted = 'N';

-- 视图4：活跃用户视图
CREATE OR REPLACE VIEW ACTIVE_USERS AS
SELECT 
    u.user_id,
    u.username,
    u.email,
    u.account_status,
    u.last_login,
    COUNT(DISTINCT CASE WHEN r.created_at > SYSDATE - 7 THEN r.recipe_id END) AS recipes_this_week,
    COUNT(DISTINCT CASE WHEN rt.rating_date > SYSDATE - 7 THEN rt.rating_id END) AS ratings_this_week,
    COUNT(DISTINCT CASE WHEN c.created_at > SYSDATE - 7 THEN c.comment_id END) AS comments_this_week
FROM USERS u
LEFT JOIN RECIPES r ON u.user_id = r.user_id
LEFT JOIN RATINGS rt ON u.user_id = rt.user_id
LEFT JOIN COMMENTS c ON u.user_id = c.user_id
WHERE u.account_status = 'active'
GROUP BY u.user_id, u.username, u.email, u.account_status, u.last_login;

-- 视图5：用户贡献分数视图
CREATE OR REPLACE VIEW USER_CONTRIBUTION_SCORE AS
SELECT 
    u.user_id,
    u.username,
    u.total_recipes,
    u.total_followers,
    COUNT(DISTINCT rt.rating_id) AS ratings_given,
    COUNT(DISTINCT c.comment_id) AS comments_given,
    ROUND(
        u.total_recipes * 100 +
        u.total_followers * 50 +
        COUNT(DISTINCT rt.rating_id) * 10 +
        COUNT(DISTINCT c.comment_id) * 5
    ) AS total_contribution_score
FROM USERS u
LEFT JOIN RATINGS rt ON u.user_id = rt.user_id
LEFT JOIN COMMENTS c ON u.user_id = c.user_id
WHERE u.account_status = 'active'
GROUP BY u.user_id, u.username, u.total_recipes, u.total_followers;

-- ============================================================
-- 第四部分：常见查询脚本
-- ============================================================

-- 查询1：按菜系搜索食谱（按评分排序）
CREATE OR REPLACE PROCEDURE search_recipes_by_cuisine(
    p_cuisine_type IN VARCHAR2,
    p_limit IN NUMBER DEFAULT 20
) AS
BEGIN
    FOR rec IN (
        SELECT r.recipe_id, r.recipe_name, r.average_rating, r.view_count, u.username
        FROM RECIPES r
        JOIN USERS u ON r.user_id = u.user_id
        WHERE r.cuisine_type = p_cuisine_type
          AND r.is_published = 'Y'
          AND r.is_deleted = 'N'
        ORDER BY r.average_rating DESC, r.view_count DESC
        FETCH FIRST p_limit ROWS ONLY
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.recipe_name || ' - ' || rec.username || ' (' || rec.average_rating || '分)');
    END LOOP;
END search_recipes_by_cuisine;
/

-- 查询2：获取用户的收藏食谱
CREATE OR REPLACE PROCEDURE get_user_saved_recipes(
    p_user_id IN NUMBER,
    p_limit IN NUMBER DEFAULT 10
) AS
BEGIN
    FOR rec IN (
        SELECT DISTINCT r.recipe_id, r.recipe_name, r.average_rating
        FROM SAVED_RECIPES sr
        JOIN RECIPES r ON sr.recipe_id = r.recipe_id
        WHERE sr.user_id = p_user_id
          AND r.is_deleted = 'N'
        ORDER BY sr.saved_at DESC
        FETCH FIRST p_limit ROWS ONLY
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.recipe_name || ' (' || rec.average_rating || '分)');
    END LOOP;
END get_user_saved_recipes;
/

-- 查询3：推荐食谱（基于关注的用户）
CREATE OR REPLACE PROCEDURE recommend_recipes(
    p_user_id IN NUMBER,
    p_limit IN NUMBER DEFAULT 10
) AS
BEGIN
    FOR rec IN (
        SELECT DISTINCT r.recipe_id, r.recipe_name, r.average_rating, u.username
        FROM RECIPES r
        JOIN FOLLOWERS f ON r.user_id = f.user_id
        JOIN USERS u ON r.user_id = u.user_id
        WHERE f.follower_user_id = p_user_id
          AND r.is_published = 'Y'
          AND r.is_deleted = 'N'
          AND r.recipe_id NOT IN (SELECT recipe_id FROM SAVED_RECIPES WHERE user_id = p_user_id)
        ORDER BY r.average_rating DESC, r.view_count DESC
        FETCH FIRST p_limit ROWS ONLY
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.recipe_name || ' by ' || rec.username || ' (' || rec.average_rating || '分)');
    END LOOP;
END recommend_recipes;
/

-- 查询4：获取不含过敏原的食谱
CREATE OR REPLACE PROCEDURE get_safe_recipes(
    p_user_id IN NUMBER,
    p_limit IN NUMBER DEFAULT 20
) AS
BEGIN
    FOR rec IN (
        SELECT DISTINCT r.recipe_id, r.recipe_name, r.average_rating
        FROM RECIPES r
        WHERE r.is_published = 'Y'
          AND r.is_deleted = 'N'
          AND NOT EXISTS (
              SELECT 1
              FROM RECIPE_INGREDIENTS ri
              JOIN INGREDIENT_ALLERGENS ia ON ri.ingredient_id = ia.ingredient_id
              JOIN USER_ALLERGIES ua ON ia.allergen_id = ua.allergen_id
              WHERE ri.recipe_id = r.recipe_id
                AND ua.user_id = p_user_id
          )
        ORDER BY r.average_rating DESC
        FETCH FIRST p_limit ROWS ONLY
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.recipe_name || ' (' || rec.average_rating || '分 - 安全)');
    END LOOP;
END get_safe_recipes;
/

-- ============================================================
-- 第五部分：统计分析查询
-- ============================================================

-- 统计1：月度新增数据统计
CREATE OR REPLACE VIEW MONTHLY_STATISTICS AS
SELECT 
    TRUNC(r.created_at, 'MM') AS month,
    COUNT(DISTINCT r.recipe_id) AS new_recipes,
    COUNT(DISTINCT r.user_id) AS active_creators,
    COUNT(DISTINCT rt.rating_id) AS total_ratings,
    COUNT(DISTINCT c.comment_id) AS total_comments,
    ROUND(AVG(r.average_rating), 2) AS avg_rating
FROM RECIPES r
LEFT JOIN RATINGS rt ON TRUNC(rt.rating_date, 'MM') = TRUNC(r.created_at, 'MM')
LEFT JOIN COMMENTS c ON TRUNC(c.created_at, 'MM') = TRUNC(r.created_at, 'MM')
WHERE r.is_deleted = 'N'
GROUP BY TRUNC(r.created_at, 'MM')
ORDER BY month DESC;

-- 统计2：食谱质量指标
CREATE OR REPLACE VIEW RECIPE_QUALITY_METRICS AS
SELECT 
    r.recipe_id,
    r.recipe_name,
    u.username,
    r.average_rating,
    r.rating_count,
    r.view_count,
    COUNT(DISTINCT c.comment_id) AS comment_count,
    COUNT(DISTINCT cs.step_id) AS step_count,
    COUNT(DISTINCT ri.ingredient_id) AS ingredient_count,
    CASE 
        WHEN r.average_rating >= 4.5 AND r.rating_count >= 10 THEN '★★★★★'
        WHEN r.average_rating >= 4.0 AND r.rating_count >= 5 THEN '★★★★'
        WHEN r.average_rating >= 3.5 THEN '★★★'
        ELSE '★'
    END AS quality_rating
FROM RECIPES r
JOIN USERS u ON r.user_id = u.user_id
LEFT JOIN COMMENTS c ON r.recipe_id = c.recipe_id
LEFT JOIN COOKING_STEPS cs ON r.recipe_id = cs.recipe_id
LEFT JOIN RECIPE_INGREDIENTS ri ON r.recipe_id = ri.recipe_id
WHERE r.is_published = 'Y' AND r.is_deleted = 'N'
GROUP BY r.recipe_id, r.recipe_name, u.username, r.average_rating, 
         r.rating_count, r.view_count;

-- 统计3：最受欢迎的食材搭配
CREATE OR REPLACE VIEW TOP_INGREDIENT_COMBINATIONS AS
SELECT 
    i1.ingredient_name AS ingredient_a,
    i2.ingredient_name AS ingredient_b,
    COUNT(*) AS pair_frequency,
    ROUND(AVG(r.average_rating), 2) AS avg_rating,
    ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC, AVG(r.average_rating) DESC) AS rank
FROM RECIPE_INGREDIENTS ri1
JOIN RECIPE_INGREDIENTS ri2 ON ri1.recipe_id = ri2.recipe_id 
                             AND ri1.ingredient_id < ri2.ingredient_id
JOIN INGREDIENTS i1 ON ri1.ingredient_id = i1.ingredient_id
JOIN INGREDIENTS i2 ON ri2.ingredient_id = i2.ingredient_id
JOIN RECIPES r ON ri1.recipe_id = r.recipe_id
WHERE r.average_rating >= 4.0
GROUP BY i1.ingredient_name, i2.ingredient_name
HAVING COUNT(*) >= 3;

-- ============================================================
-- 第六部分：数据维护脚本
-- ============================================================

-- 维护1：更新食谱统计信息（定期执行）
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

-- 维护2：清理已删除的评论和评分
CREATE OR REPLACE PROCEDURE cleanup_deleted_data AS
    v_deleted_comments NUMBER;
    v_deleted_ratings NUMBER;
BEGIN
    -- 删除孤立的评分帮助记录
    DELETE FROM RATING_HELPFULNESS WHERE rating_id NOT IN (SELECT rating_id FROM RATINGS);
    v_deleted_ratings := SQL%ROWCOUNT;
    
    -- 删除孤立的评论帮助记录
    DELETE FROM COMMENT_HELPFULNESS WHERE comment_id NOT IN (SELECT comment_id FROM COMMENTS);
    v_deleted_comments := SQL%ROWCOUNT;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('已删除 ' || v_deleted_ratings || ' 条孤立评分记录');
    DBMS_OUTPUT.PUT_LINE('已删除 ' || v_deleted_comments || ' 条孤立评论记录');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('错误: ' || SQLERRM);
END cleanup_deleted_data;
/

-- 维护3：禁用用户账户
CREATE OR REPLACE PROCEDURE disable_user_account(
    p_user_id IN NUMBER,
    p_result OUT VARCHAR2
) AS
BEGIN
    UPDATE USERS SET 
        account_status = 'suspended'
    WHERE user_id = p_user_id;
    
    -- 取消发布该用户的所有食谱
    UPDATE RECIPES SET 
        is_published = 'N',
        is_deleted = 'Y'
    WHERE user_id = p_user_id;
    
    COMMIT;
    p_result := 'SUCCESS: 用户账户已禁用';
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END disable_user_account;
/

-- ============================================================
-- 第七部分：测试脚本
-- ============================================================

-- 测试：执行常见操作
DECLARE
    v_result VARCHAR2(500);
    v_recipe_id NUMBER;
    v_plan_id NUMBER;
    v_list_id NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('========== AllRecipes 数据库测试开始 ==========');
    
    -- 测试1：发布食谱
    DBMS_OUTPUT.PUT_LINE('测试1：发布食谱');
    publish_recipe(1, '番茄鸡蛋面', '经典家常菜', '中式', 'lunch', 'easy', 10, 20, 2, v_result);
    DBMS_OUTPUT.PUT_LINE(v_result);
    
    -- 测试2：评价食谱
    DBMS_OUTPUT.PUT_LINE('测试2：评价食谱');
    rate_recipe(2, 1, 4.5, '味道不错!', v_result);
    DBMS_OUTPUT.PUT_LINE(v_result);
    
    -- 测试3：收藏食谱
    DBMS_OUTPUT.PUT_LINE('测试3：收藏食谱');
    save_recipe(2, 1, v_result);
    DBMS_OUTPUT.PUT_LINE(v_result);
    
    -- 测试4：关注用户
    DBMS_OUTPUT.PUT_LINE('测试4：关注用户');
    follow_user(2, 1, v_result);
    DBMS_OUTPUT.PUT_LINE(v_result);
    
    -- 测试5：创建膳食计划
    DBMS_OUTPUT.PUT_LINE('测试5：创建膳食计划');
    create_meal_plan(1, '一周膳食计划', '包含多样化的食材', SYSDATE, SYSDATE + 7, 'Y', v_plan_id, v_result);
    DBMS_OUTPUT.PUT_LINE(v_result || ' (计划ID: ' || v_plan_id || ')');
    
    -- 测试6：添加用户过敏原
    DBMS_OUTPUT.PUT_LINE('测试6：添加用户过敏原');
    add_user_allergy(2, 1, v_result);
    DBMS_OUTPUT.PUT_LINE(v_result);
    
    DBMS_OUTPUT.PUT_LINE('========== 测试完成 ==========');
END;
/

-- ============================================================
-- 输出验证信息
-- ============================================================

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
SELECT 'TRIGGERS', COUNT(*) FROM user_triggers
UNION ALL
SELECT 'INDEXES', COUNT(*) FROM user_indexes;

PROMPT
PROMPT ========== 系统已就绪 ==========
PROMPT

