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


-- 视图2：带原料的食谱

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

SELECT 
    r.recipe_name,
    c.comment_id,
    c.parent_comment_id,
    u.username AS commenter_name,
    c.comment_text,
    c.created_at,
    r.recipe_id,
    u.user_id,
    u.profile_image AS commenter_avatar,
    (SELECT COUNT(*) FROM COMMENT_HELPFULNESS ch WHERE ch.comment_id = c.comment_id) AS helpful_count
FROM COMMENTS c
JOIN RECIPES r ON c.recipe_id = r.recipe_id
JOIN USERS u ON c.user_id = u.user_id
WHERE c.is_deleted = 'N' AND r.is_deleted = 'N';

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

