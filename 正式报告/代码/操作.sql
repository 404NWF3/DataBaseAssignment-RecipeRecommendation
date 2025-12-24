-- 新用户注册

INSERT INTO USERS (
    user_id, username, email, password_hash, first_name, last_name, 
    bio, join_date, account_status, created_at, updated_at
)
VALUES (
    seq_users.NEXTVAL,'nwf','2024110089','IloveDBLearning',
    'Jane','Doe','我是一位美食爱好者',SYSDATE,'active',SYSTIMESTAMP,SYSTIMESTAMP
);

select * from USERS;

commit;

-- 创建新食谱

-- 第一步：插入食谱主表
INSERT INTO RECIPES (
    recipe_id, user_id, recipe_name, description, cuisine_type, 
    meal_type, difficulty_level, prep_time, cook_time, servings,
    is_published, is_deleted, created_at, updated_at
)
VALUES (
    seq_recipes.NEXTVAL,11,'番茄鸡蛋汤',
    '清汤营养，简单快手，适合全年龄段食用',
    '家常','lunch','easy',5,10,2,
    'Y','N',SYSTIMESTAMP,SYSTIMESTAMP
);

select * from RECIPES where recipe_name='番茄鸡蛋汤';

-- 第二步：插入食谱食材（外键依赖 RECIPES、INGREDIENTS、UNITS）
INSERT INTO RECIPE_INGREDIENTS (
    recipe_id, ingredient_id, unit_id, quantity, notes
)VALUES (15, 1,1,300,'新鲜番茄，切块');

INSERT INTO RECIPE_INGREDIENTS (
    recipe_id, ingredient_id, unit_id, quantity, notes
)VALUES (15,11,8,2,'打散后倒入汤中');

select * from RECIPE_INGREDIENTS where recipe_id=15;

-- 第三步：插入烹饪步骤
INSERT INTO COOKING_STEPS (
    step_id, recipe_id, step_number, instruction, time_required
)VALUES (seq_cooking_steps.NEXTVAL,15,1,'番茄洗净切块，鸡蛋打碎备用',5);

INSERT INTO COOKING_STEPS (
    step_id, recipe_id, step_number, instruction, time_required
)VALUES (seq_cooking_steps.NEXTVAL,15,2,'烧开一锅清水，加入番茄块，煮 5 分钟至番茄软烂',5);

INSERT INTO COOKING_STEPS (
    step_id, recipe_id, step_number, instruction, time_required
)VALUES (seq_cooking_steps.NEXTVAL,15,3,'倒入打散的鸡蛋，边倒边搅拌形成蛋花，加盐调味，完成',5);

select * from COOKING_STEPS where recipe_id=15;
-- 第四步：插入营养信息（一对一关系）
INSERT INTO NUTRITION_INFO (
    nutrition_id, 
    recipe_id, 
    calories, 
    protein_grams, 
    carbs_grams, 
    fat_grams,
    fiber_grams,
    sugar_grams,
    sodium_mg
)
VALUES (
    seq_nutrition_info.NEXTVAL,
    seq_recipes.CURRVAL,
    150,
    8.5,
    15,
    5.2,
    2,
    3,
    800
);

COMMIT;


SELECT 
    r.recipe_id,
    r.recipe_name,
    r.description,
    r.cuisine_type,
    r.meal_type,
    r.difficulty_level,
    r.prep_time,
    r.cook_time,
    r.servings,
    u.username AS creator,
    i.ingredient_name,
    ri.quantity,
    un.unit_name,
    ni.calories,
    ni.protein_grams,
    ni.carbs_grams,
    ni.fat_grams
FROM RECIPES r
JOIN USERS u ON r.user_id = u.user_id
LEFT JOIN RECIPE_INGREDIENTS ri ON r.recipe_id = ri.recipe_id
LEFT JOIN INGREDIENTS i ON ri.ingredient_id = i.ingredient_id
LEFT JOIN UNITS un ON ri.unit_id = un.unit_id
LEFT JOIN NUTRITION_INFO ni ON r.recipe_id = ni.recipe_id
WHERE r.recipe_id = 1          -- 查询 recipe_id=1 的食谱
ORDER BY ri.ingredient_id;

select * from recipes;

    
select * from RECIPE_WITH_INGREDIENTS where recipe_id=1;
select * from RECIPE_WITH_STEPs where recipe_id=1;
select * from RECIPE_COMMENTS_DETAIL where recipe_id=1;

-- 查找对用户安全的食谱（不含用户过敏原）
SELECT 
    r.recipe_id,
    r.recipe_name,
    r.average_rating
FROM RECIPES r
WHERE r.is_published = 'Y'
  AND r.is_deleted = 'N'
  AND NOT EXISTS (
      -- 子查询：检查此食谱是否包含用户的过敏原
      SELECT 1
      FROM RECIPE_INGREDIENTS ri
      JOIN INGREDIENT_ALLERGENS ia ON ri.ingredient_id = ia.ingredient_id
      JOIN USER_ALLERGIES ua ON ia.allergen_id = ua.allergen_id
      WHERE ri.recipe_id = r.recipe_id
        AND ua.user_id = 5            -- user_id=5 是徐慧（营养师）
  )
ORDER BY r.average_rating DESC;



UPDATE USERS
SET 
    bio = '新手烹饪爱好者，分享家常菜做法',
    profile_image = 'https://avatars.githubusercontent.com/u/145841814?v=4',
    updated_at = SYSTIMESTAMP
WHERE user_id = 11;

SELECT user_id, bio, profile_image FROM USERS WHERE user_id = 11;

COMMIT;

UPDATE RECIPES
SET 
    is_published = 'Y',
    updated_at = SYSTIMESTAMP
WHERE recipe_id = 5;
  
select RECIPE_ID, USER_ID, is_published from RECIPES where recipe_id=5;

UPDATE RECIPES
SET 
    is_deleted = 'Y',
    updated_at = SYSTIMESTAMP
WHERE recipe_id = 10;

SELECT RECIPE_ID, is_deleted from RECIPES WHERE recipe_id = 10;