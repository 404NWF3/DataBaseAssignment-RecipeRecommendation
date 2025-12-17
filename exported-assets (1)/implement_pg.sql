-- ============================================================
-- AllRecipes 食谱网站 - PostgreSQL业务实现脚本 (v2.0)
-- 包含存储过程、函数和视图定义
-- ============================================================

-- ============================================================
-- 第一部分：常用存储过程
-- ============================================================

-- 存储过程1：发布食谱
CREATE OR REPLACE FUNCTION publish_recipe(
    p_user_id INTEGER,
    p_recipe_name VARCHAR,
    p_description VARCHAR,
    p_cuisine_type VARCHAR,
    p_meal_type VARCHAR,
    p_difficulty_level VARCHAR,
    p_prep_time INTEGER,
    p_cook_time INTEGER,
    p_servings INTEGER,
    OUT p_result VARCHAR,
    OUT p_recipe_id INTEGER
) AS $$
DECLARE
    v_user_exists INTEGER;
BEGIN
    -- 验证用户存在
    SELECT user_id INTO v_user_exists FROM users WHERE user_id = p_user_id;
    IF v_user_exists IS NULL THEN
        p_result := 'ERROR: 用户不存在';
        RETURN;
    END IF;

    -- 插入食谱
    INSERT INTO recipes (
        user_id, recipe_name, description, cuisine_type,
        meal_type, difficulty_level, prep_time, cook_time,
        total_time, servings, is_published, is_deleted
    ) VALUES (
        p_user_id, p_recipe_name, p_description, p_cuisine_type,
        p_meal_type, p_difficulty_level, p_prep_time, p_cook_time,
        p_prep_time + p_cook_time, p_servings, TRUE, FALSE
    ) RETURNING recipe_id INTO p_recipe_id;

    p_result := 'SUCCESS: 食谱已发布，ID为' || p_recipe_id;

EXCEPTION
    WHEN OTHERS THEN
        p_result := 'ERROR: ' || SQLERRM;
        p_recipe_id := NULL;
END;
$$ LANGUAGE plpgsql;

-- 存储过程2：评价食谱
CREATE OR REPLACE FUNCTION rate_recipe(
    p_user_id INTEGER,
    p_recipe_id INTEGER,
    p_rating_value NUMERIC,
    p_review_text VARCHAR DEFAULT NULL,
    OUT p_result VARCHAR
) AS $$
BEGIN
    -- 使用 ON CONFLICT 自动处理更新或插入
    INSERT INTO ratings (user_id, recipe_id, rating_value, review_text)
    VALUES (p_user_id, p_recipe_id, p_rating_value, p_review_text)
    ON CONFLICT (user_id, recipe_id)
    DO UPDATE SET 
        rating_value = p_rating_value,
        review_text = p_review_text,
        rating_date = CURRENT_TIMESTAMP;

    p_result := 'SUCCESS: 评价已提交';

EXCEPTION
    WHEN OTHERS THEN
        p_result := 'ERROR: ' || SQLERRM;
END;
$$ LANGUAGE plpgsql;

-- 存储过程3：保存食谱到收藏
CREATE OR REPLACE FUNCTION save_recipe(
    p_user_id INTEGER,
    p_recipe_id INTEGER,
    OUT p_result VARCHAR
) AS $$
BEGIN
    INSERT INTO saved_recipes (user_id, recipe_id)
    VALUES (p_user_id, p_recipe_id)
    ON CONFLICT (user_id, recipe_id)
    DO NOTHING;

    p_result := 'SUCCESS: 食谱已收藏';

EXCEPTION
    WHEN OTHERS THEN
        p_result := 'ERROR: ' || SQLERRM;
END;
$$ LANGUAGE plpgsql;

-- 存储过程4：取消收藏
CREATE OR REPLACE FUNCTION unsave_recipe(
    p_user_id INTEGER,
    p_recipe_id INTEGER,
    OUT p_result VARCHAR
) AS $$
BEGIN
    DELETE FROM saved_recipes 
    WHERE user_id = p_user_id AND recipe_id = p_recipe_id;

    IF FOUND THEN
        p_result := 'SUCCESS: 已取消收藏';
    ELSE
        p_result := 'INFO: 食谱不在收藏中';
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        p_result := 'ERROR: ' || SQLERRM;
END;
$$ LANGUAGE plpgsql;

-- 存储过程5：关注用户
CREATE OR REPLACE FUNCTION follow_user(
    p_current_user_id INTEGER,
    p_target_user_id INTEGER,
    OUT p_result VARCHAR
) AS $$
BEGIN
    -- 检查不能自己关注自己
    IF p_current_user_id = p_target_user_id THEN
        p_result := 'ERROR: 不能关注自己';
        RETURN;
    END IF;

    INSERT INTO followers (user_id, follower_user_id)
    VALUES (p_target_user_id, p_current_user_id)
    ON CONFLICT (user_id, follower_user_id)
    DO NOTHING;

    p_result := 'SUCCESS: 已关注用户';

EXCEPTION
    WHEN OTHERS THEN
        p_result := 'ERROR: ' || SQLERRM;
END;
$$ LANGUAGE plpgsql;

-- 存储过程6：创建膳食计划
CREATE OR REPLACE FUNCTION create_meal_plan(
    p_user_id INTEGER,
    p_plan_name VARCHAR,
    p_description VARCHAR DEFAULT NULL,
    p_start_date DATE,
    p_end_date DATE,
    p_is_public BOOLEAN DEFAULT TRUE,
    OUT p_plan_id INTEGER,
    OUT p_result VARCHAR
) AS $$
BEGIN
    -- 验证日期
    IF p_start_date > p_end_date THEN
        p_result := 'ERROR: 开始日期不能晚于结束日期';
        RETURN;
    END IF;

    -- 创建膳食计划
    INSERT INTO meal_plans (user_id, plan_name, description, start_date, end_date, is_public)
    VALUES (p_user_id, p_plan_name, p_description, p_start_date, p_end_date, p_is_public)
    RETURNING plan_id INTO p_plan_id;

    p_result := 'SUCCESS: 膳食计划已创建';

EXCEPTION
    WHEN OTHERS THEN
        p_result := 'ERROR: ' || SQLERRM;
        p_plan_id := NULL;
END;
$$ LANGUAGE plpgsql;

-- 存储过程7：生成购物清单（从膳食计划）
CREATE OR REPLACE FUNCTION generate_shopping_list(
    p_user_id INTEGER,
    p_plan_id INTEGER,
    OUT p_list_id INTEGER,
    OUT p_result VARCHAR
) AS $$
BEGIN
    -- 创建购物清单
    INSERT INTO shopping_lists (user_id, list_name)
    VALUES (p_user_id, '膳食计划购物清单 - ' || CURRENT_DATE)
    RETURNING list_id INTO p_list_id;

    -- 添加所有食材
    INSERT INTO shopping_list_items (list_id, ingredient_id, quantity, unit_id)
    SELECT 
        p_list_id,
        ri.ingredient_id,
        SUM(ri.quantity),
        ri.unit_id
    FROM meal_plan_entries mpe
    JOIN recipes r ON mpe.recipe_id = r.recipe_id
    JOIN recipe_ingredients ri ON r.recipe_id = ri.recipe_id
    WHERE mpe.plan_id = p_plan_id
    GROUP BY ri.ingredient_id, ri.unit_id;

    p_result := 'SUCCESS: 购物清单已生成';

EXCEPTION
    WHEN OTHERS THEN
        p_result := 'ERROR: ' || SQLERRM;
        p_list_id := NULL;
END;
$$ LANGUAGE plpgsql;

-- 存储过程8：添加用户过敏原
CREATE OR REPLACE FUNCTION add_user_allergy(
    p_user_id INTEGER,
    p_allergen_id INTEGER,
    OUT p_result VARCHAR
) AS $$
BEGIN
    INSERT INTO user_allergies (user_id, allergen_id)
    VALUES (p_user_id, p_allergen_id)
    ON CONFLICT (user_id, allergen_id)
    DO NOTHING;

    p_result := 'SUCCESS: 过敏原已记录';

EXCEPTION
    WHEN OTHERS THEN
        p_result := 'ERROR: ' || SQLERRM;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 第二部分：查询函数
-- ============================================================

-- 函数1：获取食谱的平均评分
CREATE OR REPLACE FUNCTION get_recipe_avg_rating(p_recipe_id INTEGER)
RETURNS NUMERIC AS $$
DECLARE
    v_avg_rating NUMERIC;
BEGIN
    SELECT ROUND(AVG(rating_value)::numeric, 2) INTO v_avg_rating
    FROM ratings
    WHERE recipe_id = p_recipe_id;
    
    RETURN COALESCE(v_avg_rating, 0);
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END;
$$ LANGUAGE plpgsql;

-- 函数2：计算用户的贡献分数
CREATE OR REPLACE FUNCTION calculate_user_score(p_user_id INTEGER)
RETURNS INTEGER AS $$
DECLARE
    v_score INTEGER := 0;
    v_recipes INTEGER;
    v_followers INTEGER;
    v_ratings INTEGER;
    v_comments INTEGER;
    v_helpful_votes INTEGER;
BEGIN
    -- 获取各项指标
    SELECT total_recipes, total_followers INTO v_recipes, v_followers
    FROM users WHERE user_id = p_user_id;

    SELECT COUNT(*) INTO v_ratings FROM ratings WHERE user_id = p_user_id;
    SELECT COUNT(*) INTO v_comments FROM comments WHERE user_id = p_user_id;
    SELECT COUNT(*) INTO v_helpful_votes FROM rating_helpfulness WHERE user_id = p_user_id;

    -- 计算综合分数
    v_score := COALESCE(v_recipes, 0) * 100 + COALESCE(v_followers, 0) * 50 + 
               COALESCE(v_ratings, 0) * 10 + COALESCE(v_comments, 0) * 5 + 
               COALESCE(v_helpful_votes, 0) * 2;

    RETURN v_score;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END;
$$ LANGUAGE plpgsql;

-- 函数3：检查食谱是否安全（不含用户过敏原）
CREATE OR REPLACE FUNCTION is_recipe_safe_for_user(p_user_id INTEGER, p_recipe_id INTEGER)
RETURNS VARCHAR AS $$
DECLARE
    v_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM recipe_ingredients ri
    JOIN ingredient_allergens ia ON ri.ingredient_id = ia.ingredient_id
    JOIN user_allergies ua ON ia.allergen_id = ua.allergen_id
    WHERE ri.recipe_id = p_recipe_id
    AND ua.user_id = p_user_id;

    IF v_count = 0 THEN
        RETURN 'Y';
    ELSE
        RETURN 'N';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'U';
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 第三部分：视图定义
-- ============================================================

-- 视图1：用户概览视图
CREATE OR REPLACE VIEW user_overview AS
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
    ROUND(AVG(rt.rating_value)::numeric, 2) AS avg_recipe_rating
FROM users u
LEFT JOIN followers f2 ON u.user_id = f2.follower_user_id
LEFT JOIN recipes r ON u.user_id = r.user_id AND r.is_deleted = FALSE
LEFT JOIN ratings rt ON r.recipe_id = rt.recipe_id
WHERE u.account_status = 'active'
GROUP BY u.user_id, u.username, u.first_name, u.last_name, u.profile_image, 
         u.bio, u.join_date, u.account_status;

-- 视图2：热门食谱视图
CREATE OR REPLACE VIEW popular_recipes AS
SELECT 
    r.recipe_id,
    r.recipe_name,
    r.cuisine_type,
    r.average_rating,
    r.rating_count,
    r.view_count,
    u.username,
    ROUND(
        (r.average_rating * 0.5 +
        LEAST(r.rating_count / 100.0, 5) * 0.3 +
        LEAST(r.view_count / 10000.0, 5) * 0.2)::numeric, 2
    ) AS popularity_score
FROM recipes r
JOIN users u ON r.user_id = u.user_id
WHERE r.is_published = TRUE
  AND r.is_deleted = FALSE
  AND r.created_at > CURRENT_TIMESTAMP - INTERVAL '6 months';

-- 视图3：食谱详情视图
CREATE OR REPLACE VIEW recipe_detail AS
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
    COALESCE(ni.calories, 0) AS calories,
    COALESCE(ni.protein_grams, 0) AS protein_grams,
    COALESCE(ni.carbs_grams, 0) AS carbs_grams,
    COALESCE(ni.fat_grams, 0) AS fat_grams,
    r.created_at,
    r.updated_at
FROM recipes r
JOIN users u ON r.user_id = u.user_id
LEFT JOIN nutrition_info ni ON r.recipe_id = ni.recipe_id
WHERE r.is_published = TRUE AND r.is_deleted = FALSE;

-- 视图4：活跃用户视图
CREATE OR REPLACE VIEW active_users AS
SELECT 
    u.user_id,
    u.username,
    u.email,
    u.account_status,
    u.last_login,
    COUNT(DISTINCT CASE WHEN r.created_at > CURRENT_TIMESTAMP - INTERVAL '7 days' THEN r.recipe_id END) AS recipes_this_week,
    COUNT(DISTINCT CASE WHEN rt.rating_date > CURRENT_TIMESTAMP - INTERVAL '7 days' THEN rt.rating_id END) AS ratings_this_week,
    COUNT(DISTINCT CASE WHEN c.created_at > CURRENT_TIMESTAMP - INTERVAL '7 days' THEN c.comment_id END) AS comments_this_week
FROM users u
LEFT JOIN recipes r ON u.user_id = r.user_id
LEFT JOIN ratings rt ON u.user_id = rt.user_id
LEFT JOIN comments c ON u.user_id = c.user_id
WHERE u.account_status = 'active'
GROUP BY u.user_id, u.username, u.email, u.account_status, u.last_login;

-- 视图5：用户贡献分数视图
CREATE OR REPLACE VIEW user_contribution_score AS
SELECT 
    u.user_id,
    u.username,
    u.total_recipes,
    u.total_followers,
    COUNT(DISTINCT rt.rating_id) AS ratings_given,
    COUNT(DISTINCT c.comment_id) AS comments_given,
    (u.total_recipes * 100 +
     u.total_followers * 50 +
     COUNT(DISTINCT rt.rating_id) * 10 +
     COUNT(DISTINCT c.comment_id) * 5) AS total_contribution_score
FROM users u
LEFT JOIN ratings rt ON u.user_id = rt.user_id
LEFT JOIN comments c ON u.user_id = c.user_id
WHERE u.account_status = 'active'
GROUP BY u.user_id, u.username, u.total_recipes, u.total_followers;

-- ============================================================
-- 第四部分：常见查询过程
-- ============================================================

-- 查询1：按菜系搜索食谱（按评分排序）
CREATE OR REPLACE FUNCTION search_recipes_by_cuisine(
    p_cuisine_type VARCHAR,
    p_limit INTEGER DEFAULT 20
)
RETURNS TABLE (recipe_id INTEGER, recipe_name VARCHAR, average_rating NUMERIC, view_count INTEGER, username VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT r.recipe_id, r.recipe_name, r.average_rating, r.view_count, u.username
    FROM recipes r
    JOIN users u ON r.user_id = u.user_id
    WHERE r.cuisine_type = p_cuisine_type
      AND r.is_published = TRUE
      AND r.is_deleted = FALSE
    ORDER BY r.average_rating DESC, r.view_count DESC
    LIMIT p_limit;
END;
$$ LANGUAGE plpgsql;

-- 查询2：推荐食谱（基于关注的用户）
CREATE OR REPLACE FUNCTION recommend_recipes(
    p_user_id INTEGER,
    p_limit INTEGER DEFAULT 10
)
RETURNS TABLE (recipe_id INTEGER, recipe_name VARCHAR, average_rating NUMERIC, username VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT r.recipe_id, r.recipe_name, r.average_rating, u.username
    FROM recipes r
    JOIN followers f ON r.user_id = f.user_id
    JOIN users u ON r.user_id = u.user_id
    WHERE f.follower_user_id = p_user_id
      AND r.is_published = TRUE
      AND r.is_deleted = FALSE
      AND r.recipe_id NOT IN (
          SELECT recipe_id FROM saved_recipes WHERE user_id = p_user_id
      )
    ORDER BY r.average_rating DESC, r.view_count DESC
    LIMIT p_limit;
END;
$$ LANGUAGE plpgsql;

-- 查询3：获取不含过敏原的食谱
CREATE OR REPLACE FUNCTION get_safe_recipes(
    p_user_id INTEGER,
    p_limit INTEGER DEFAULT 20
)
RETURNS TABLE (recipe_id INTEGER, recipe_name VARCHAR, average_rating NUMERIC) AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT r.recipe_id, r.recipe_name, r.average_rating
    FROM recipes r
    WHERE r.is_published = TRUE
      AND r.is_deleted = FALSE
      AND NOT EXISTS (
          SELECT 1
          FROM recipe_ingredients ri
          JOIN ingredient_allergens ia ON ri.ingredient_id = ia.ingredient_id
          JOIN user_allergies ua ON ia.allergen_id = ua.allergen_id
          WHERE ri.recipe_id = r.recipe_id
            AND ua.user_id = p_user_id
      )
    ORDER BY r.average_rating DESC
    LIMIT p_limit;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 第五部分：统计分析视图
-- ============================================================

-- 视图6：月度统计视图
CREATE OR REPLACE VIEW monthly_statistics AS
SELECT 
    DATE_TRUNC('month', r.created_at)::DATE AS month,
    COUNT(DISTINCT r.recipe_id) AS new_recipes,
    COUNT(DISTINCT r.user_id) AS active_creators,
    COUNT(DISTINCT rt.rating_id) AS total_ratings,
    COUNT(DISTINCT c.comment_id) AS total_comments,
    ROUND(AVG(r.average_rating)::numeric, 2) AS avg_rating
FROM recipes r
LEFT JOIN ratings rt ON DATE_TRUNC('month', rt.rating_date) = DATE_TRUNC('month', r.created_at)
LEFT JOIN comments c ON DATE_TRUNC('month', c.created_at) = DATE_TRUNC('month', r.created_at)
WHERE r.is_deleted = FALSE
GROUP BY DATE_TRUNC('month', r.created_at)
ORDER BY month DESC;

-- 视图7：食谱质量指标
CREATE OR REPLACE VIEW recipe_quality_metrics AS
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
FROM recipes r
JOIN users u ON r.user_id = u.user_id
LEFT JOIN comments c ON r.recipe_id = c.recipe_id AND c.is_deleted = FALSE
LEFT JOIN cooking_steps cs ON r.recipe_id = cs.recipe_id
LEFT JOIN recipe_ingredients ri ON r.recipe_id = ri.recipe_id
WHERE r.is_published = TRUE AND r.is_deleted = FALSE
GROUP BY r.recipe_id, r.recipe_name, u.username, r.average_rating, 
         r.rating_count, r.view_count;

-- 视图8：最受欢迎的食材搭配
CREATE OR REPLACE VIEW top_ingredient_combinations AS
SELECT 
    i1.ingredient_name AS ingredient_a,
    i2.ingredient_name AS ingredient_b,
    COUNT(*) AS pair_frequency,
    ROUND(AVG(r.average_rating)::numeric, 2) AS avg_rating,
    ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC, AVG(r.average_rating) DESC) AS rank
FROM recipe_ingredients ri1
JOIN recipe_ingredients ri2 ON ri1.recipe_id = ri2.recipe_id 
    AND ri1.ingredient_id < ri2.ingredient_id
JOIN ingredients i1 ON ri1.ingredient_id = i1.ingredient_id
JOIN ingredients i2 ON ri2.ingredient_id = i2.ingredient_id
JOIN recipes r ON ri1.recipe_id = r.recipe_id
WHERE r.average_rating >= 4.0
GROUP BY i1.ingredient_name, i2.ingredient_name
HAVING COUNT(*) >= 3;

-- ============================================================
-- 第六部分：数据维护函数
-- ============================================================

-- 维护1：更新食谱统计信息
CREATE OR REPLACE FUNCTION update_recipe_statistics()
RETURNS TABLE (updated_count INTEGER) AS $$
BEGIN
    UPDATE recipes SET
        rating_count = (SELECT COUNT(*) FROM ratings WHERE recipe_id = recipes.recipe_id),
        average_rating = ROUND(
            COALESCE((SELECT AVG(rating_value) FROM ratings WHERE recipe_id = recipes.recipe_id), 0)::numeric, 2
        )
    WHERE is_published = TRUE;
    
    RETURN QUERY SELECT ROW_COUNT()::INTEGER;
END;
$$ LANGUAGE plpgsql;

-- 维护2：禁用用户账户
CREATE OR REPLACE FUNCTION disable_user_account(
    p_user_id INTEGER,
    OUT p_result VARCHAR
) AS $$
BEGIN
    UPDATE users SET account_status = 'suspended' WHERE user_id = p_user_id;
    
    -- 取消发布该用户的所有食谱
    UPDATE recipes SET 
        is_published = FALSE,
        is_deleted = TRUE
    WHERE user_id = p_user_id;
    
    p_result := 'SUCCESS: 用户账户已禁用';
EXCEPTION
    WHEN OTHERS THEN
        p_result := 'ERROR: ' || SQLERRM;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 第七部分：物化视图（可选性能优化）
-- ============================================================

-- 创建物化视图：食谱流行度统计
CREATE MATERIALIZED VIEW IF NOT EXISTS recipe_popularity_stats AS
SELECT 
    r.recipe_id,
    r.recipe_name,
    r.average_rating,
    r.rating_count,
    r.view_count,
    COUNT(DISTINCT sr.user_id) AS save_count,
    COUNT(DISTINCT c.comment_id) AS comment_count,
    ROUND(
        (r.average_rating * 0.5 +
        LEAST(r.rating_count / 100.0, 5) * 0.3 +
        LEAST(r.view_count / 10000.0, 5) * 0.2)::numeric, 2
    ) AS popularity_score
FROM recipes r
LEFT JOIN saved_recipes sr ON r.recipe_id = sr.recipe_id
LEFT JOIN comments c ON r.recipe_id = c.recipe_id AND c.is_deleted = FALSE
WHERE r.is_deleted = FALSE
GROUP BY r.recipe_id, r.recipe_name, r.average_rating, r.rating_count, r.view_count;

-- 创建索引加速查询
CREATE INDEX IF NOT EXISTS idx_popularity_stats ON recipe_popularity_stats(popularity_score DESC);

-- 刷新物化视图函数
CREATE OR REPLACE FUNCTION refresh_popularity_stats()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY recipe_popularity_stats;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 第八部分：审计日志
-- ============================================================

CREATE TABLE IF NOT EXISTS audit_log (
    audit_id SERIAL PRIMARY KEY,
    audit_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    database_user VARCHAR(50),
    operation_type VARCHAR(50),
    table_name VARCHAR(50),
    record_id VARCHAR(50),
    old_values JSONB,
    new_values JSONB,
    status VARCHAR(20)
);

-- 创建审计触发器函数
CREATE OR REPLACE FUNCTION log_recipe_changes()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit_log (
        database_user, operation_type, table_name, record_id, 
        new_values, status
    ) VALUES (
        CURRENT_USER, TG_OP, TG_TABLE_NAME, NEW.recipe_id::text,
        row_to_json(NEW), 'SUCCESS'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 绑定审计触发器
DROP TRIGGER IF EXISTS trg_audit_recipes ON recipes;
CREATE TRIGGER trg_audit_recipes
AFTER INSERT OR UPDATE ON recipes
FOR EACH ROW EXECUTE FUNCTION log_recipe_changes();

-- ============================================================
-- 验证和测试
-- ============================================================

-- 查看所有表
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- 查看所有视图
SELECT viewname FROM pg_views WHERE schemaname = 'public'
ORDER BY viewname;

-- 查看所有函数
SELECT routine_name FROM information_schema.routines
WHERE routine_schema = 'public' AND routine_type = 'FUNCTION'
ORDER BY routine_name;

-- 查看所有索引
SELECT indexname FROM pg_indexes 
WHERE schemaname = 'public'
ORDER BY indexname;

-- 验证数据
SELECT 
    (SELECT COUNT(*) FROM users) as users_count,
    (SELECT COUNT(*) FROM recipes) as recipes_count,
    (SELECT COUNT(*) FROM ratings) as ratings_count,
    (SELECT COUNT(*) FROM comments) as comments_count;

COMMIT;
