-- =====================================================================
-- AllRecipes 数据库实现脚本
-- 包含：视图创建、存储过程、触发器、示例数据
-- =====================================================================

-- =====================================================================
-- 第一部分：视图创建
-- =====================================================================

-- 用户概览视图
CREATE OR REPLACE VIEW USER_OVERVIEW AS
SELECT 
    u.user_id,
    u.username,
    u.first_name,
    u.last_name,
    u.join_date,
    u.account_status,
    COUNT(DISTINCT r.recipe_id) as recipe_count,
    COUNT(DISTINCT f.follower_user_id) as follower_count,
    ROUND(AVG(rt.rating_value), 2) as avg_recipe_rating
FROM USERS u
LEFT JOIN RECIPES r ON u.user_id = r.user_id AND r.is_deleted = 'N'
LEFT JOIN FOLLOWERS f ON u.user_id = f.user_id
LEFT JOIN RATINGS rt ON r.recipe_id = rt.recipe_id
GROUP BY u.user_id, u.username, u.first_name, u.last_name, u.join_date, u.account_status;

-- 食谱详情视图
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
    r.calories_per_serving,
    r.average_rating,
    r.rating_count,
    r.view_count,
    u.username as creator_name,
    ni.calories,
    ni.protein_grams,
    ni.carbs_grams,
    ni.fat_grams,
    r.created_at
FROM RECIPES r
JOIN USERS u ON r.user_id = u.user_id
LEFT JOIN NUTRITION_INFO ni ON r.recipe_id = ni.recipe_id
WHERE r.is_published = 'Y' AND r.is_deleted = 'N';

-- 热门食谱视图
CREATE OR REPLACE VIEW POPULAR_RECIPES AS
SELECT 
    recipe_id,
    recipe_name,
    cuisine_type,
    average_rating,
    rating_count,
    view_count,
    ROUND(average_rating * rating_count + view_count * 0.1, 2) as popularity_score
FROM RECIPES
WHERE is_published = 'Y' AND is_deleted = 'N'
ORDER BY popularity_score DESC;

-- 食谱与食材视图
CREATE OR REPLACE VIEW RECIPE_WITH_INGREDIENTS AS
SELECT 
    r.recipe_id,
    r.recipe_name,
    i.ingredient_name,
    i.category as ingredient_category,
    ri.quantity,
    u.unit_name,
    ri.notes
FROM RECIPES r
JOIN RECIPE_INGREDIENTS ri ON r.recipe_id = ri.recipe_id
JOIN INGREDIENTS i ON ri.ingredient_id = i.ingredient_id
JOIN UNITS u ON ri.unit_id = u.unit_id
WHERE r.is_deleted = 'N';

-- 用户社交网络视图
CREATE OR REPLACE VIEW USER_NETWORK AS
SELECT 
    u.user_id,
    u.username,
    COUNT(DISTINCT f.follower_user_id) as follower_count,
    COUNT(DISTINCT f2.user_id) as following_count,
    COUNT(DISTINCT sr.saved_recipe_id) as saved_recipes_count,
    COUNT(DISTINCT rt.rating_id) as reviews_count
FROM USERS u
LEFT JOIN FOLLOWERS f ON u.user_id = f.user_id
LEFT JOIN FOLLOWERS f2 ON u.user_id = f2.follower_user_id
LEFT JOIN SAVED_RECIPES sr ON u.user_id = sr.user_id
LEFT JOIN RATINGS rt ON u.user_id = rt.user_id
GROUP BY u.user_id, u.username;

-- =====================================================================
-- 第二部分：存储过程
-- =====================================================================

-- 创建用户的存储过程
CREATE OR REPLACE PROCEDURE create_user(
    p_username VARCHAR2,
    p_email VARCHAR2,
    p_password_hash VARCHAR2,
    p_first_name VARCHAR2,
    p_last_name VARCHAR2,
    p_user_id OUT NUMBER
) AS
BEGIN
    SELECT seq_users.NEXTVAL INTO p_user_id FROM DUAL;
    
    INSERT INTO USERS (
        user_id, username, email, password_hash, 
        first_name, last_name, account_status, join_date
    ) VALUES (
        p_user_id, p_username, p_email, p_password_hash,
        p_first_name, p_last_name, 'active', SYSDATE
    );
    
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20001, '用户名或邮箱已存在');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

-- 发布食谱的存储过程
CREATE OR REPLACE PROCEDURE publish_recipe(
    p_user_id NUMBER,
    p_recipe_name VARCHAR2,
    p_description VARCHAR2,
    p_cuisine_type VARCHAR2,
    p_meal_type VARCHAR2,
    p_difficulty_level VARCHAR2,
    p_prep_time NUMBER,
    p_cook_time NUMBER,
    p_servings NUMBER,
    p_recipe_id OUT NUMBER
) AS
BEGIN
    SELECT seq_recipes.NEXTVAL INTO p_recipe_id FROM DUAL;
    
    INSERT INTO RECIPES (
        recipe_id, user_id, recipe_name, description,
        cuisine_type, meal_type, difficulty_level,
        prep_time, cook_time, total_time, servings,
        is_published, view_count, rating_count
    ) VALUES (
        p_recipe_id, p_user_id, p_recipe_name, p_description,
        p_cuisine_type, p_meal_type, p_difficulty_level,
        p_prep_time, p_cook_time, (p_prep_time + p_cook_time), p_servings,
        'Y', 0, 0
    );
    
    -- 更新用户的食谱计数
    UPDATE USERS SET 
        total_recipes = (SELECT COUNT(*) FROM RECIPES WHERE user_id = p_user_id AND is_deleted = 'N')
    WHERE user_id = p_user_id;
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

-- 添加食材到食谱的存储过程
CREATE OR REPLACE PROCEDURE add_ingredient_to_recipe(
    p_recipe_id NUMBER,
    p_ingredient_id NUMBER,
    p_unit_id NUMBER,
    p_quantity NUMBER,
    p_notes VARCHAR2 DEFAULT NULL
) AS
BEGIN
    INSERT INTO RECIPE_INGREDIENTS (
        recipe_ingredient_id, recipe_id, ingredient_id, unit_id, quantity, notes
    ) VALUES (
        seq_recipe_ingredients.NEXTVAL, p_recipe_id, p_ingredient_id, p_unit_id, p_quantity, p_notes
    );
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20002, '该食材已添加到此食谱');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

-- 添加烹饪步骤的存储过程
CREATE OR REPLACE PROCEDURE add_cooking_step(
    p_recipe_id NUMBER,
    p_step_number NUMBER,
    p_instruction VARCHAR2,
    p_time_required NUMBER DEFAULT NULL
) AS
BEGIN
    INSERT INTO COOKING_STEPS (
        step_id, recipe_id, step_number, instruction, time_required
    ) VALUES (
        seq_cooking_steps.NEXTVAL, p_recipe_id, p_step_number, p_instruction, p_time_required
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

-- 评价食谱的存储过程
CREATE OR REPLACE PROCEDURE rate_recipe(
    p_user_id NUMBER,
    p_recipe_id NUMBER,
    p_rating_value NUMBER,
    p_review_text VARCHAR2 DEFAULT NULL
) AS
BEGIN
    INSERT INTO RATINGS (
        rating_id, user_id, recipe_id, rating_value, review_text
    ) VALUES (
        seq_ratings.NEXTVAL, p_user_id, p_recipe_id, p_rating_value, p_review_text
    );
    
    -- 更新食谱的平均评分和评价数
    UPDATE RECIPES SET 
        average_rating = ROUND((SELECT AVG(rating_value) FROM RATINGS WHERE recipe_id = p_recipe_id), 2),
        rating_count = (SELECT COUNT(*) FROM RATINGS WHERE recipe_id = p_recipe_id),
        updated_at = SYSTIMESTAMP
    WHERE recipe_id = p_recipe_id;
    
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20003, '您已经评价过此食谱');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

-- 收藏食谱的存储过程
CREATE OR REPLACE PROCEDURE save_recipe(
    p_user_id NUMBER,
    p_recipe_id NUMBER
) AS
BEGIN
    INSERT INTO SAVED_RECIPES (
        saved_recipe_id, user_id, recipe_id
    ) VALUES (
        seq_saved_recipes.NEXTVAL, p_user_id, p_recipe_id
    );
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20004, '您已经收藏此食谱');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

-- 关注用户的存储过程
CREATE OR REPLACE PROCEDURE follow_user(
    p_user_id NUMBER,
    p_follower_user_id NUMBER
) AS
BEGIN
    IF p_user_id = p_follower_user_id THEN
        RAISE_APPLICATION_ERROR(-20005, '用户不能关注自己');
    END IF;
    
    INSERT INTO FOLLOWERS (
        follower_id, user_id, follower_user_id
    ) VALUES (
        seq_followers.NEXTVAL, p_user_id, p_follower_user_id
    );
    
    -- 更新粉丝数
    UPDATE USERS SET 
        total_followers = (SELECT COUNT(*) FROM FOLLOWERS WHERE user_id = p_user_id)
    WHERE user_id = p_user_id;
    
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20006, '您已经关注此用户');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

-- =====================================================================
-- 第三部分：触发器
-- =====================================================================

-- 更新食谱浏览次数的触发器
CREATE OR REPLACE TRIGGER update_recipe_view_count
AFTER SELECT ON RECIPES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
    UPDATE RECIPES SET view_count = view_count + 1
    WHERE recipe_id = :NEW.recipe_id;
END;
/

-- 记录用户活动的触发器（记录食谱创建）
CREATE OR REPLACE TRIGGER log_recipe_creation
AFTER INSERT ON RECIPES
FOR EACH ROW
BEGIN
    INSERT INTO USER_ACTIVITY_LOG (
        activity_id, user_id, activity_type, activity_description, related_recipe_id
    ) VALUES (
        seq_user_activity_log.NEXTVAL, :NEW.user_id, 'recipe_created', 
        '创建了食谱：' || :NEW.recipe_name, :NEW.recipe_id
    );
END;
/

-- 记录用户活动的触发器（记录评价）
CREATE OR REPLACE TRIGGER log_recipe_rating
AFTER INSERT ON RATINGS
FOR EACH ROW
BEGIN
    INSERT INTO USER_ACTIVITY_LOG (
        activity_id, user_id, activity_type, activity_description, related_recipe_id
    ) VALUES (
        seq_user_activity_log.NEXTVAL, :NEW.user_id, 'recipe_rated',
        '评价了食谱，评分：' || :NEW.rating_value, :NEW.recipe_id
    );
END;
/

-- 验证评分值的触发器
CREATE OR REPLACE TRIGGER validate_rating_value
BEFORE INSERT OR UPDATE ON RATINGS
FOR EACH ROW
BEGIN
    IF :NEW.rating_value < 0 OR :NEW.rating_value > 5 THEN
        RAISE_APPLICATION_ERROR(-20007, '评分值必须在0到5之间');
    END IF;
END;
/

-- =====================================================================
-- 第四部分：示例数据
-- =====================================================================

-- 插入单位数据
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description) VALUES (1, '克', 'g', '重量单位');
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description) VALUES (2, '毫升', 'ml', '容量单位');
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description) VALUES (3, '杯', 'cup', '容量单位');
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description) VALUES (4, '汤匙', 'tbsp', '容量单位');
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description) VALUES (5, '茶匙', 'tsp', '容量单位');
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description) VALUES (6, '个', 'pc', '计数单位');
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description) VALUES (7, '份', 'serving', '份量单位');

-- 插入食材数据
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description) 
VALUES (1, '鸡蛋', '蛋类', '新鲜鸡蛋');
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description) 
VALUES (2, '面粉', '谷物', '通用面粉');
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description) 
VALUES (3, '牛奶', '奶制品', '鲜牛奶');
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description) 
VALUES (4, '黄油', '奶制品', '黄油');
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description) 
VALUES (5, '糖', '调味料', '白砂糖');
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description) 
VALUES (6, '盐', '调味料', '食用盐');
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description) 
VALUES (7, '番茄', '蔬菜', '新鲜番茄');
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description) 
VALUES (8, '洋葱', '蔬菜', '黄洋葱');
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description) 
VALUES (9, '大蒜', '蔬菜', '新鲜大蒜');
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description) 
VALUES (10, '橄榄油', '油脂', '特级初榨橄榄油');

-- 插入过敏原数据
INSERT INTO ALLERGENS (allergen_id, allergen_name, description) 
VALUES (1, '花生', '花生及花生制品');
INSERT INTO ALLERGENS (allergen_id, allergen_name, description) 
VALUES (2, '贝类', '虾、蟹、贝类等');
INSERT INTO ALLERGENS (allergen_id, allergen_name, description) 
VALUES (3, '坚果', '各类坚果');
INSERT INTO ALLERGENS (allergen_id, allergen_name, description) 
VALUES (4, '麸质', '含麸质食物');
INSERT INTO ALLERGENS (allergen_id, allergen_name, description) 
VALUES (5, '乳制品', '牛奶、乳酪等');

-- 插入食材过敏原关系
INSERT INTO INGREDIENT_ALLERGENS (ingredient_allergen_id, ingredient_id, allergen_id) 
VALUES (1, 1, 5);  -- 鸡蛋可能含乳制品
INSERT INTO INGREDIENT_ALLERGENS (ingredient_allergen_id, ingredient_id, allergen_id) 
VALUES (2, 3, 5);  -- 牛奶含乳制品
INSERT INTO INGREDIENT_ALLERGENS (ingredient_allergen_id, ingredient_id, allergen_id) 
VALUES (3, 4, 5);  -- 黄油含乳制品

-- 插入标签数据
INSERT INTO TAGS (tag_id, tag_name, tag_description) VALUES (1, '素食', '不含肉类的食谱');
INSERT INTO TAGS (tag_id, tag_name, tag_description) VALUES (2, '低脂', '低脂肪食谱');
INSERT INTO TAGS (tag_id, tag_name, tag_description) VALUES (3, '快手菜', '烹饪时间少于30分钟');
INSERT INTO TAGS (tag_id, tag_name, tag_description) VALUES (4, '健康', '营养均衡的食谱');
INSERT INTO TAGS (tag_id, tag_name, tag_description) VALUES (5, '甜品', '甜点和甜品');

-- 插入用户数据
DECLARE
    v_user_id NUMBER;
BEGIN
    create_user('alice_chef', 'alice@allrecipes.com', 'hashed_password_123', 'Alice', 'Chen', v_user_id);
    create_user('bob_baker', 'bob@allrecipes.com', 'hashed_password_456', 'Bob', 'Smith', v_user_id);
    create_user('carol_cook', 'carol@allrecipes.com', 'hashed_password_789', 'Carol', 'Johnson', v_user_id);
END;
/

-- 插入食谱数据
DECLARE
    v_recipe_id NUMBER;
BEGIN
    -- 插入食谱1：番茄鸡蛋面
    publish_recipe(1, '番茄鸡蛋面', '简单易做的番茄鸡蛋面，营养丰富', 
                   '中式', 'lunch', 'easy', 10, 15, 2, v_recipe_id);
    
    -- 添加食材
    add_ingredient_to_recipe(v_recipe_id, 1, 6, 2);  -- 2个鸡蛋
    add_ingredient_to_recipe(v_recipe_id, 7, 1, 150);  -- 150克番茄
    add_ingredient_to_recipe(v_recipe_id, 8, 1, 100);  -- 100克洋葱
    add_ingredient_to_recipe(v_recipe_id, 9, 1, 10);   -- 10克大蒜
    add_ingredient_to_recipe(v_recipe_id, 10, 2, 15);  -- 15毫升橄榄油
    add_ingredient_to_recipe(v_recipe_id, 6, 1, 5);    -- 5克盐
    
    -- 添加烹饪步骤
    add_cooking_step(v_recipe_id, 1, '将番茄洗净切块', 5);
    add_cooking_step(v_recipe_id, 2, '鸡蛋打入碗中，加盐拌匀', 3);
    add_cooking_step(v_recipe_id, 3, '热锅下油，炒香洋葱和大蒜', 3);
    add_cooking_step(v_recipe_id, 4, '加入番茄炒匀', 5);
    add_cooking_step(v_recipe_id, 5, '倒入炒好的鸡蛋，加盐调味', 5);
END;
/

-- 插入营养信息
INSERT INTO NUTRITION_INFO (nutrition_id, recipe_id, calories, protein_grams, carbs_grams, fat_grams, fiber_grams)
VALUES (1, 1, 250, 12, 20, 10, 3);

-- 插入评价数据
INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text)
VALUES (1, 2, 1, 5, '做法简单，味道很棒！');
INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text)
VALUES (2, 3, 1, 4, '很好吃，但建议多加点盐');

-- 更新食谱评分
UPDATE RECIPES SET 
    average_rating = ROUND((SELECT AVG(rating_value) FROM RATINGS WHERE recipe_id = 1), 2),
    rating_count = (SELECT COUNT(*) FROM RATINGS WHERE recipe_id = 1)
WHERE recipe_id = 1;

-- 插入收藏记录
INSERT INTO SAVED_RECIPES (saved_recipe_id, user_id, recipe_id)
VALUES (1, 2, 1);
INSERT INTO SAVED_RECIPES (saved_recipe_id, user_id, recipe_id)
VALUES (2, 3, 1);

-- 插入关注关系
INSERT INTO FOLLOWERS (follower_id, user_id, follower_user_id)
VALUES (1, 1, 2);  -- 用户1被用户2关注
INSERT INTO FOLLOWERS (follower_id, user_id, follower_user_id)
VALUES (2, 1, 3);  -- 用户1被用户3关注

-- 更新粉丝数
UPDATE USERS SET total_followers = 2 WHERE user_id = 1;

-- 提交所有更改
COMMIT;