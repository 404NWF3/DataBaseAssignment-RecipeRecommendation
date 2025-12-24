select * from users;

-- 视图1：用户概览

CREATE OR REPLACE VIEW USER_OVERVIEW AS
SELECT 
    u.user_id,
    u.username,
    u.account_status,
    COUNT(DISTINCT r.recipe_id) AS recipe_count,
    COUNT(DISTINCT f.follower_user_id) AS follower_count,
    COUNT(DISTINCT f2.user_id) AS following_count,
    u.profile_image,
    ROUND(AVG(rt.rating_value), 2) AS avg_recipe_rating,
    u.bio
FROM USERS u
LEFT JOIN RECIPES r ON u.user_id = r.user_id AND r.is_deleted = 'N'
LEFT JOIN FOLLOWERS f ON u.user_id = f.user_id
LEFT JOIN FOLLOWERS f2 ON u.user_id = f2.follower_user_id
LEFT JOIN RATINGS rt ON r.recipe_id = rt.recipe_id
GROUP BY u.user_id, u.username, u.first_name, u.last_name, u.profile_image, 
         u.bio, u.join_date, u.account_status;

-- 视图2：ACTIVE_USERS（活跃用户视图）

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
GROUP BY u.user_id, u.username, u.email, u.account_status, u.last_login
HAVING COUNT(DISTINCT r.recipe_id) + COUNT(DISTINCT rt.rating_id) + COUNT(DISTINCT c.comment_id) > 0;



-- 视图3：用户贡献评分视图
CREATE OR REPLACE VIEW USER_CONTRIBUTION_SCORE AS
SELECT 
    u.user_id,
    u.username,
    u.total_recipes,
    u.total_followers,
    COUNT(DISTINCT rt.rating_id) AS ratings_given,
    COUNT(DISTINCT c.comment_id) AS comments_given,
    SUM(rh.helpful_votes) AS helpful_votes_received,
    ROUND(
        u.total_recipes * 100 +           -- 每个食谱 100分
        u.total_followers * 50 +          -- 每个粉丝 50分
        COUNT(DISTINCT rt.rating_id) * 10 +  -- 每个评分 10分
        COUNT(DISTINCT c.comment_id) * 5 +   -- 每个评论 5分
        COALESCE(SUM(rh.helpful_votes), 0) * 2  -- 每个有用投票 2分
    ) AS total_contribution_score
FROM USERS u
LEFT JOIN RATINGS rt ON u.user_id = rt.user_id
LEFT JOIN COMMENTS c ON u.user_id = c.user_id
LEFT JOIN (
    SELECT user_id, COUNT(*) AS helpful_votes
    FROM RATING_HELPFULNESS
    GROUP BY user_id
) rh ON u.user_id = rh.user_id
WHERE u.account_status = 'active'
GROUP BY u.user_id, u.username, u.total_recipes, u.total_followers;

-- 视图4：食谱相关视图
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
    ni.calories,
    ni.protein_grams,
    ni.carbs_grams,
    ni.fat_grams,
    ni.fiber_grams,
    ni.sugar_grams,
    ni.sodium_mg,
    r.created_at,
    r.updated_at
FROM RECIPES r
JOIN USERS u ON r.user_id = u.user_id
LEFT JOIN NUTRITION_INFO ni ON r.recipe_id = ni.recipe_id
WHERE r.is_published = 'Y' 
  AND r.is_deleted = 'N';

-- 视图5：热门食谱视图
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
        r.average_rating * 0.5 +              -- 评分权重 50%
        LEAST(r.rating_count / 100.0, 5) * 0.3 +  -- 评价数权重 30%
        LEAST(r.view_count / 10000.0, 5) * 0.2    -- 浏览数权重 20%
    , 2) AS popularity_score
FROM RECIPES r
JOIN USERS u ON r.user_id = u.user_id
WHERE r.is_published = 'Y' 
  AND r.is_deleted = 'N'
  AND r.created_at > SYSDATE - 180  -- 过去6个月
ORDER BY popularity_score DESC;

-- 视图6：食材详尽视图

CREATE OR REPLACE VIEW RECIPE_WITH_INGREDIENTS AS
SELECT 
    r.recipe_id,
    r.recipe_name,
    r.servings,
    ri.ingredient_id,
    i.ingredient_name,
    i.category AS ingredient_category,
    ri.quantity,
    u.unit_name,
    u.abbreviation,
    ri.notes
FROM RECIPES r
JOIN RECIPE_INGREDIENTS ri ON r.recipe_id = ri.recipe_id
JOIN INGREDIENTS i ON ri.ingredient_id = i.ingredient_id
JOIN UNITS u ON ri.unit_id = u.unit_id
LEFT JOIN INGREDIENT_ALLERGENS ia ON i.ingredient_id = ia.ingredient_id
LEFT JOIN ALLERGENS al ON ia.allergen_id = al.allergen_id
WHERE r.is_deleted = 'N';

-- 视图7：食谱步骤视图

CREATE OR REPLACE VIEW RECIPE_WITH_STEPS AS
SELECT 
    r.recipe_id,
    r.recipe_name,
    cs.step_number,
    cs.instruction,
    cs.time_required,
    cs.image_url,
    LAG(cs.step_number) OVER (PARTITION BY r.recipe_id ORDER BY cs.step_number) AS previous_step,
    LEAD(cs.step_number) OVER (PARTITION BY r.recipe_id ORDER BY cs.step_number) AS next_step
FROM RECIPES r
LEFT JOIN COOKING_STEPS cs ON r.recipe_id = cs.recipe_id
WHERE r.is_deleted = 'N'
ORDER BY r.recipe_id, cs.step_number;


-- 视图8：用户社交网络

CREATE OR REPLACE VIEW USER_NETWORK AS
SELECT 
    u.user_id,
    u.username,
    u.profile_image,
    COUNT(DISTINCT f.follower_user_id) AS follower_count,
    COUNT(DISTINCT f2.user_id) AS following_count,
    COUNT(DISTINCT sr.saved_recipe_id) AS saved_recipes_count,
    COUNT(DISTINCT rt.rating_id) AS reviews_count,
    COUNT(DISTINCT c.comment_id) AS comments_count
FROM USERS u
LEFT JOIN FOLLOWERS f ON u.user_id = f.user_id
LEFT JOIN FOLLOWERS f2 ON u.user_id = f2.follower_user_id
LEFT JOIN SAVED_RECIPES sr ON u.user_id = sr.user_id
LEFT JOIN RATINGS rt ON u.user_id = rt.user_id
LEFT JOIN COMMENTS c ON u.user_id = c.user_id
WHERE u.account_status = 'active'
GROUP BY u.user_id, u.username, u.profile_image;


-- 视图9：用户动态试图

-- -- CREATE OR REPLACE VIEW USER_FEED AS
-- SELECT 
--     f.follower_user_id AS feed_for_user,
--     ual.user_id AS actor_user_id,
--     u.username AS actor_username,
--     u.profile_image,
--     ual.activity_type,
--     ual.activity_description,
--     r.recipe_id,
--     r.recipe_name,
--     ual.activity_timestamp
-- FROM USER_ACTIVITY_LOG ual
-- JOIN FOLLOWERS f ON ual.user_id = f.user_id
-- JOIN USERS u ON ual.user_id = u.user_id
-- LEFT JOIN RECIPES r ON ual.related_recipe_id = r.recipe_id
-- WHERE ual.activity_timestamp > SYSDATE - 30
--   AND ual.activity_type IN ('recipe_published', 'recipe_rated', 'comment_added')
--   AND u.account_status = 'active';

-- select * from USER_ACTIVITY_LOG;

-- -- 视图10：顶级贡献者视图
-- -- CREATE OR REPLACE VIEW TOP_CONTRIBUTORS AS
-- SELECT 
--     u.user_id,
--     u.username,
--     u.profile_image,
--     u.total_recipes,
--     u.total_followers,
--     COUNT(DISTINCT rt.rating_id) AS total_ratings,
--     COUNT(DISTINCT c.comment_id) AS total_comments,
--     SUM(CASE WHEN rt.rating_value >= 4.5 THEN 1 ELSE 0 END) AS high_rated_recipes,
--     RANK() OVER (ORDER BY u.total_recipes DESC, u.total_followers DESC) AS rank
-- FROM USERS u
-- LEFT JOIN RATINGS rt ON u.user_id = rt.user_id
-- LEFT JOIN COMMENTS c ON u.user_id = c.user_id
-- WHERE u.account_status = 'active'
-- GROUP BY u.user_id, u.username, u.profile_image, u.total_recipes, u.total_followers
-- ORDER BY rank
-- FETCH FIRST 100 ROWS ONLY;

-- CREATE OR REPLACE VIEW INGREDIENT_HEALTH_PROFILE AS
SELECT 
    i.ingredient_id,
    i.ingredient_name,
    i.category,
    i.description,
    -- STRING_AGG(DISTINCT a.allergen_name, ', ') AS contains_allergens,
    COUNT(DISTINCT ris.recipe_id) AS used_in_recipes,
    ROUND(AVG(r.average_rating), 2) AS avg_recipe_rating
FROM INGREDIENTS i
LEFT JOIN INGREDIENT_ALLERGENS ia ON i.ingredient_id = ia.ingredient_id
LEFT JOIN ALLERGENS a ON ia.allergen_id = a.allergen_id
LEFT JOIN RECIPE_INGREDIENTS ris ON i.ingredient_id = ris.ingredient_id
LEFT JOIN RECIPES r ON ris.recipe_id = r.recipe_id;
-- GROUP BY i.ingredient_id, i.ingredient_name, i.category, i.description;

CREATE OR REPLACE VIEW RECIPE_COMMENTS_DETAIL AS
SELECT 
    r.recipe_id,
    r.recipe_name,
    c.comment_id,
    u.user_id,
    u.username AS commenter_name,
    u.profile_image AS commenter_avatar,
    c.comment_text,
    c.parent_comment_id,
    c.created_at,
    (SELECT COUNT(*) FROM COMMENT_HELPFULNESS ch WHERE ch.comment_id = c.comment_id) AS helpful_count
FROM COMMENTS c
JOIN RECIPES r ON c.recipe_id = r.recipe_id
JOIN USERS u ON c.user_id = u.user_id
WHERE c.is_deleted = 'N' AND r.is_deleted = 'N'
WITH READ ONLY;

insert into user_views values (1,15);

CREATE OR REPLACE VIEW SAFE_RECIPES_FOR_USER AS
SELECT 
    u.user_id,
    r.recipe_id,
    r.recipe_name,
    r.average_rating
    -- STRING_AGG(t.tag_name, ', ') AS tags
FROM USERS u
CROSS JOIN RECIPES r
LEFT JOIN RECIPE_TAGS rt ON r.recipe_id = rt.recipe_id
LEFT JOIN TAGS t ON rt.tag_id = t.tag_id
WHERE r.is_published = 'Y'
  AND r.is_deleted = 'N'
  AND NOT EXISTS (
      SELECT 1
      FROM RECIPE_INGREDIENTS ri
      JOIN INGREDIENT_ALLERGENS ia ON ri.ingredient_id = ia.ingredient_id
      JOIN USER_ALLERGIES ua ON ia.allergen_id = ua.allergen_id
      WHERE ri.recipe_id = r.recipe_id
        AND ua.user_id = u.user_id
  )
WITH READ ONLY;
-- GROUP BY u.user_id, r.recipe_id, r.recipe_name, r.average_rating;


CREATE OR REPLACE VIEW MONTHLY_STATISTICS AS
SELECT 
    TRUNC(r.created_at, 'MM') AS month,
    COUNT(DISTINCT r.recipe_id) AS new_recipes,
    COUNT(DISTINCT r.user_id) AS active_creators,
    COUNT(DISTINCT rt.rating_id) AS total_ratings,
    COUNT(DISTINCT c.comment_id) AS total_comments,
    ROUND(AVG(r.average_rating), 2) AS avg_rating
FROM RECIPES r
LEFT JOIN RATINGS rt ON r.created_at = TRUNC(rt.rating_date, 'MM')
LEFT JOIN COMMENTS c ON r.created_at = TRUNC(c.created_at, 'MM')
WHERE r.is_deleted = 'N'
GROUP BY TRUNC(r.created_at, 'MM')
ORDER BY month DESC;

select * from user_views;

commit;