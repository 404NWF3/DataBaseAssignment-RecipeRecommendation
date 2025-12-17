-- ============================================================
-- AllRecipes 食谱网站 - 数据导入脚本 (v3.0)
-- 包含所有表的完整测试数据
-- Oracle SQL脚本
-- ============================================================

-- ============================================================
-- 第一阶段：基础参考数据（无依赖）
-- ============================================================

-- 清空现有数据（可选 - 生产环境谨慎使用）
-- DELETE FROM USERS;
-- COMMIT;

-- ============================================================
-- 1. 插入USERS（50个用户）
-- ============================================================

INSERT INTO USERS (user_id, username, email, password_hash, first_name, last_name, bio, profile_image, join_date, last_login, account_status, user_type, total_followers, total_recipes, created_at, updated_at)
VALUES (seq_users.NEXTVAL, 'admin', 'admin@allrecipes.com', 'hash_admin_123', 'Admin', 'User', '系统管理员', NULL, TRUNC(SYSDATE - 365), TRUNC(SYSDATE - 1), 'active', '普通用户', 10, 5, SYSTIMESTAMP, SYSTIMESTAMP);

-- 专业厨师用户 (11-22)
INSERT INTO USERS (user_id, username, email, password_hash, first_name, last_name, bio, profile_image, join_date, last_login, account_status, user_type, total_followers, total_recipes, created_at, updated_at)
SELECT seq_users.NEXTVAL, 'chef_master_' || LPAD(i, 3, '0'), 'chef.master.' || LPAD(i, 3, '0') || '@allrecipes.com', 'hash_chef_' || i, 'Chef', 'Master' || i, '专业厨师，专注' || CASE MOD(i, 3) WHEN 0 THEN '中式烹饪' WHEN 1 THEN '西餐烹饪' ELSE '日式料理' END, NULL, TRUNC(SYSDATE - 300 + MOD(i*11, 200)), TRUNC(SYSDATE - MOD(i*7, 30)), 'active', '专业厨师', 50 + i*5, 20 + i*2, SYSTIMESTAMP, SYSTIMESTAMP
FROM (SELECT ROWNUM i FROM DUAL WHERE ROWNUM <= 12);

-- 美食博主用户 (23-30)
INSERT INTO USERS (user_id, username, email, password_hash, first_name, last_name, bio, profile_image, join_date, last_login, account_status, user_type, total_followers, total_recipes, created_at, updated_at)
SELECT seq_users.NEXTVAL, 'foodblogger_' || LPAD(i, 3, '0'), 'foodblog.' || LPAD(i, 3, '0') || '@allrecipes.com', 'hash_blog_' || i, 'Food', 'Blogger' || i, '美食博主，粉丝数' || 1000 + i*100, NULL, TRUNC(SYSDATE - 250 + MOD(i*13, 150)), TRUNC(SYSDATE - MOD(i*3, 15)), 'active', '美食博主', 100 + i*10, 30 + i*3, SYSTIMESTAMP, SYSTIMESTAMP
FROM (SELECT ROWNUM i FROM DUAL WHERE ROWNUM <= 8);

-- 普通用户 (31-50)
INSERT INTO USERS (user_id, username, email, password_hash, first_name, last_name, bio, profile_image, join_date, last_login, account_status, user_type, total_followers, total_recipes, created_at, updated_at)
SELECT seq_users.NEXTVAL, 'user_common_' || LPAD(i, 3, '0'), 'user.common.' || LPAD(i, 3, '0') || '@allrecipes.com', 'hash_user_' || i, 'User', 'Common' || i, '烹饪爱好者，分享日常美食', NULL, TRUNC(SYSDATE - 180 + MOD(i*17, 100)), TRUNC(SYSDATE - MOD(i*5, 25)), CASE WHEN MOD(i, 12) = 0 THEN 'inactive' ELSE 'active' END, '普通用户', MOD(i*3, 20), MOD(i*2, 10), SYSTIMESTAMP, SYSTIMESTAMP
FROM (SELECT ROWNUM i FROM DUAL WHERE ROWNUM <= 20);

COMMIT;

-- ============================================================
-- 2. 插入UNITS（15个单位）
-- ============================================================

INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (1, '克', 'g', '重量单位，1000克=1千克', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (2, '千克', 'kg', '重量单位', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (3, '毫升', 'ml', '容量单位', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (4, '升', 'L', '容量单位，1L=1000ml', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (5, '杯', 'cup', '容量单位，1杯≈240ml', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (6, '汤匙', 'tbsp', '容量单位，1汤匙≈15ml', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (7, '茶匙', 'tsp', '容量单位，1茶匙≈5ml', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (8, '个', 'pc', '数量单位', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (9, '对', 'pair', '数量单位，2个为1对', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (10, '打', 'dozen', '数量单位，12个为1打', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (11, '斤', 'catty', '中国重量单位，1斤=500g', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (12, '两', 'liang', '中国重量单位，1两=50g', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (13, '条', 'stick', '数量单位', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (14, '片', 'slice', '数量单位', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (15, '适量', 'as needed', '不固定数量', SYSTIMESTAMP);

COMMIT;

-- ============================================================
-- 3. 插入ALLERGENS（10个过敏原）
-- ============================================================

INSERT INTO ALLERGENS (allergen_id, allergen_name, description, created_at)
VALUES (seq_allergens.NEXTVAL, '花生', '常见过敏原，可导致严重反应', SYSTIMESTAMP);
INSERT INTO ALLERGENS (allergen_id, allergen_name, description, created_at)
VALUES (seq_allergens.NEXTVAL, '坚果', '树坚果类，可导致严重过敏', SYSTIMESTAMP);
INSERT INTO ALLERGENS (allergen_id, allergen_name, description, created_at)
VALUES (seq_allergens.NEXTVAL, '乳制品', '含乳糖，乳糖不耐症患者避免', SYSTIMESTAMP);
INSERT INTO ALLERGENS (allergen_id, allergen_name, description, created_at)
VALUES (seq_allergens.NEXTVAL, '鸡蛋', '常见过敏原之一', SYSTIMESTAMP);
INSERT INTO ALLERGENS (allergen_id, allergen_name, description, created_at)
VALUES (seq_allergens.NEXTVAL, '海鲜', '甲壳类和贝类', SYSTIMESTAMP);
INSERT INTO ALLERGENS (allergen_id, allergen_name, description, created_at)
VALUES (seq_allergens.NEXTVAL, '鱼', '鱼类及鱼制品', SYSTIMESTAMP);
INSERT INTO ALLERGENS (allergen_id, allergen_name, description, created_at)
VALUES (seq_allergens.NEXTVAL, '小麦', '面筋相关，面粉/面条等', SYSTIMESTAMP);
INSERT INTO ALLERGENS (allergen_id, allergen_name, description, created_at)
VALUES (seq_allergens.NEXTVAL, '大豆', '豆制品，包括豆浆/豆腐等', SYSTIMESTAMP);
INSERT INTO ALLERGENS (allergen_id, allergen_name, description, created_at)
VALUES (seq_allergens.NEXTVAL, '芝麻', '芝麻油和芝麻制品', SYSTIMESTAMP);
INSERT INTO ALLERGENS (allergen_id, allergen_name, description, created_at)
VALUES (seq_allergens.NEXTVAL, '芥末', '调味料，常见于沙拉酱', SYSTIMESTAMP);

COMMIT;

-- ============================================================
-- 4. 插入TAGS（20个标签）
-- ============================================================

INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (1, '素食', '不含肉类的食物', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (2, '纯素', '不含任何动物产品', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (3, '无麸质', '不含小麦和谷物', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (4, '低脂', '脂肪含量低，适合健康饮食', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (5, '烤', '通过烘烤制作', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (6, '炸', '油炸制作', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (7, '蒸', '清蒸制作', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (8, '煮', '水煮或炖煮', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (9, '炒', '快速炒制', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (10, '快手菜', '30分钟以内完成', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (11, '节日大餐', '特殊场合', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (12, '儿童食品', '适合儿童食用', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (13, '健身餐', '高蛋白低碳水', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (14, '减肥餐', '低热量', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (15, '补气血', '中医食疗', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (16, '家常菜', '传统做法', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (17, '创意菜', '创新组合', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (18, '早餐', '上午食用', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (19, '甜点', '甜品糕点', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (20, '零食', '小食品', SYSTIMESTAMP);

COMMIT;

-- ============================================================
-- 5. 插入INGREDIENTS（100个食材）
-- ============================================================

-- 蔬菜类 (1-25)
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, ingredient_name, '蔬菜', description, SYSTIMESTAMP
FROM (
SELECT '番茄' ingredient_name, '新鲜番茄，富含番茄红素' description FROM DUAL
UNION ALL SELECT '黄瓜', '清爽爽脆的夏日蔬菜' FROM DUAL
UNION ALL SELECT '洋葱', '提味的调味蔬菜' FROM DUAL
UNION ALL SELECT '大蒜', '香味十足的调味料' FROM DUAL
UNION ALL SELECT '胡萝卜', '富含β胡萝卜素' FROM DUAL
UNION ALL SELECT '土豆', '淀粉丰富的根茎蔬菜' FROM DUAL
UNION ALL SELECT '生菜', '爽脆的沙拉菜' FROM DUAL
UNION ALL SELECT '甘蓝', '营养丰富的卷心菜' FROM DUAL
UNION ALL SELECT '菠菜', '含铁丰富的绿叶菜' FROM DUAL
UNION ALL SELECT '西兰花', '十字花科蔬菜，含硫苷' FROM DUAL
UNION ALL SELECT '青豆', '嫩豆荚' FROM DUAL
UNION ALL SELECT '辣椒', '增添风味和营养' FROM DUAL
UNION ALL SELECT '南瓜', '秋季应季蔬菜' FROM DUAL
UNION ALL SELECT '茄子', '紫色蔬菜，含花青素' FROM DUAL
UNION ALL SELECT '冬瓜', '清热利湿的蔬菜' FROM DUAL
UNION ALL SELECT '苦瓜', '清苦甘甜' FROM DUAL
UNION ALL SELECT '冬笋', '春笋的冬季版本' FROM DUAL
UNION ALL SELECT '香菇', '营养丰富的菌类' FROM DUAL
UNION ALL SELECT '口蘑', '白色蘑菇' FROM DUAL
UNION ALL SELECT '木耳', '黑色菌类，含胶质' FROM DUAL
UNION ALL SELECT '豌豆', '春季豆类' FROM DUAL
UNION ALL SELECT '玉米', '黄色的谷物蔬菜' FROM DUAL
UNION ALL SELECT '芹菜', '低热量蔬菜' FROM DUAL
UNION ALL SELECT '萝卜', '十字花科根菜' FROM DUAL
UNION ALL SELECT '山药', '淀粉含量高' FROM DUAL
);

-- 肉类 (26-45)
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, ingredient_name, '肉类', description, SYSTIMESTAMP
FROM (
SELECT '鸡肉', '低脂肉类' FROM DUAL
UNION ALL SELECT '鸡腿', '鸡腿肉' FROM DUAL
UNION ALL SELECT '鸡翅', '鸡翅' FROM DUAL
UNION ALL SELECT '鸡胸', '低脂高蛋白' FROM DUAL
UNION ALL SELECT '五花肉', '猪肉中脂肪较多的部分' FROM DUAL
UNION ALL SELECT '瘦肉', '猪肉中的瘦肉部分' FROM DUAL
UNION ALL SELECT '排骨', '带骨的肋骨' FROM DUAL
UNION ALL SELECT '猪肝', '富含铁和维生素' FROM DUAL
UNION ALL SELECT '牛肉', '营养丰富的红肉' FROM DUAL
UNION ALL SELECT '牛腩', '牛肉的腹部' FROM DUAL
UNION ALL SELECT '牛排', '高档牛肉' FROM DUAL
UNION ALL SELECT '梅花肉', '牛肉的肩胛部分' FROM DUAL
UNION ALL SELECT '羊肉', '温阳补气' FROM DUAL
UNION ALL SELECT '羊腿', '羊肉的腿部' FROM DUAL
UNION ALL SELECT '羊排', '羊的肋骨' FROM DUAL
UNION ALL SELECT '虾', '海鲜，低脂高蛋白' FROM DUAL
UNION ALL SELECT '鱼', '白肉鱼类' FROM DUAL
UNION ALL SELECT '三文鱼', '含丰富omega-3脂肪酸' FROM DUAL
UNION ALL SELECT '蟹', '海鲜，美味营养' FROM DUAL
UNION ALL SELECT '贝类', '海鲜贝类' FROM DUAL
);

-- 调味料 (46-60)
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, ingredient_name, '调味料', description, SYSTIMESTAMP
FROM (
SELECT '盐', '基础调味料' FROM DUAL
UNION ALL SELECT '糖', '甜味来源' FROM DUAL
UNION ALL SELECT '酱油', '传统调味料' FROM DUAL
UNION ALL SELECT '醋', '酸味来源' FROM DUAL
UNION ALL SELECT '油', '烹饪用油' FROM DUAL
UNION ALL SELECT '植物油', '植物类烹饪油' FROM DUAL
UNION ALL SELECT '辣椒粉', '香辣调味' FROM DUAL
UNION ALL SELECT '咖喱粉', '香料混合' FROM DUAL
UNION ALL SELECT '孜然', '香料' FROM DUAL
UNION ALL SELECT '香叶', '烹饪香料' FROM DUAL
UNION ALL SELECT '八角', '香料，八角形' FROM DUAL
UNION ALL SELECT '黄酒', '烹饪用酒' FROM DUAL
UNION ALL SELECT '豆瓣酱', '咸味酱料' FROM DUAL
UNION ALL SELECT '番茄酱', '番茄制品' FROM DUAL
UNION ALL SELECT '味精', '鲜味增强剂' FROM DUAL
);

-- 乳制品 (61-70)
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, ingredient_name, '乳制品', description, SYSTIMESTAMP
FROM (
SELECT '牛奶', '新鲜牛奶' FROM DUAL
UNION ALL SELECT '黄油', '乳脂提取' FROM DUAL
UNION ALL SELECT '奶酪', '发酵乳制品' FROM DUAL
UNION ALL SELECT '酸奶', '益生菌乳制品' FROM DUAL
UNION ALL SELECT '淡奶油', '烹饪用奶油' FROM DUAL
UNION ALL SELECT '牛奶粉', '干制牛奶' FROM DUAL
UNION ALL SELECT '炼乳', '浓缩牛奶' FROM DUAL
UNION ALL SELECT '马苏里拉奶酪', '披萨常用' FROM DUAL
UNION ALL SELECT '帕玛森芝士', '意大利奶酪' FROM DUAL
UNION ALL SELECT '羊奶', '山羊奶' FROM DUAL
);

-- 谷物 (71-85)
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, ingredient_name, '谷物', description, SYSTIMESTAMP
FROM (
SELECT '白米', '日常主食' FROM DUAL
UNION ALL SELECT '黑米', '营养米类' FROM DUAL
UNION ALL SELECT '糯米', '粘性米' FROM DUAL
UNION ALL SELECT '面粉', '小麦粉' FROM DUAL
UNION ALL SELECT '面条', '面食' FROM DUAL
UNION ALL SELECT '馄饨皮', '馄饨制作用' FROM DUAL
UNION ALL SELECT '饺子皮', '饺子制作用' FROM DUAL
UNION ALL SELECT '玉米', '玉米谷物' FROM DUAL
UNION ALL SELECT '燕麦', '燕麦粥原料' FROM DUAL
UNION ALL SELECT '大豆', '豆类谷物' FROM DUAL
UNION ALL SELECT '绿豆', '豆类' FROM DUAL
UNION ALL SELECT '红豆', '豆类' FROM DUAL
UNION ALL SELECT '黑豆', '豆类' FROM DUAL
UNION ALL SELECT '花生', '坚果豆类' FROM DUAL
UNION ALL SELECT '芝麻', '油料作物' FROM DUAL
);

-- 其他 (86-100)
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, ingredient_name, '其他', description, SYSTIMESTAMP
FROM (
SELECT '鸡蛋', '优质蛋白' FROM DUAL
UNION ALL SELECT '面包', '烘焙食品' FROM DUAL
UNION ALL SELECT '巧克力', '甜味料' FROM DUAL
UNION ALL SELECT '果酱', '果实制品' FROM DUAL
UNION ALL SELECT '蜂蜜', '天然甜味剂' FROM DUAL
UNION ALL SELECT '坚果', '营养零食' FROM DUAL
UNION ALL SELECT '葡萄干', '干果' FROM DUAL
UNION ALL SELECT '腰果', '坚果' FROM DUAL
UNION ALL SELECT '杏仁', '坚果' FROM DUAL
UNION ALL SELECT '松子', '坚果' FROM DUAL
UNION ALL SELECT '香草精', '烘焙香料' FROM DUAL
UNION ALL SELECT '肉桂', '香料粉' FROM DUAL
UNION ALL SELECT '姜粉', '香料粉' FROM DUAL
UNION ALL SELECT '黑胡椒', '香料' FROM DUAL
UNION ALL SELECT '白胡椒', '香料' FROM DUAL
);

COMMIT;

-- ============================================================
-- 第二阶段：主体数据（依赖第一阶段）
-- ============================================================

-- ============================================================
-- 6. 插入RECIPES（200个食谱）
-- ============================================================

-- 中式菜 (1-80)
INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)
SELECT seq_recipes.NEXTVAL, 
       CASE MOD(ROWNUM, 30) + 1 WHEN 1 THEN 11 WHEN 2 THEN 12 WHEN 3 THEN 13 ELSE MOD(ROWNUM, 30) + 31 END as user_id,
       CASE MOD(ROWNUM, 10)
           WHEN 1 THEN '红烧肉'
           WHEN 2 THEN '宫保鸡丁'
           WHEN 3 THEN '麻婆豆腐'
           WHEN 4 THEN '番茄鸡蛋面'
           WHEN 5 THEN '回锅肉'
           WHEN 6 THEN '鱼香肉丝'
           WHEN 7 THEN '青椒炒肉'
           WHEN 8 THEN '清蒸鱼'
           WHEN 9 THEN '冬瓜汤'
           ELSE '炒青菜'
       END as recipe_name,
       '这是一道美味的中式菜肴，传承传统烹饪工艺' as description,
       '中式' as cuisine_type,
       CASE MOD(ROWNUM, 3) WHEN 0 THEN 'breakfast' WHEN 1 THEN 'lunch' ELSE 'dinner' END as meal_type,
       CASE MOD(ROWNUM, 5) WHEN 0 THEN 'easy' WHEN 1 THEN 'hard' ELSE 'medium' END as difficulty_level,
       10 + MOD(ROWNUM, 20) as prep_time,
       15 + MOD(ROWNUM, 45) as cook_time,
       25 + MOD(ROWNUM, 60) as total_time,
       2 + MOD(ROWNUM, 5) as servings,
       300 + MOD(ROWNUM*13, 400) as calories_per_serving,
       NULL as image_url,
       CASE WHEN MOD(ROWNUM, 12) = 0 THEN 'N' ELSE 'Y' END as is_published,
       'N' as is_deleted,
       50 + MOD(ROWNUM*7, 1000) as view_count,
       MOD(ROWNUM, 10) + 1 as rating_count,
       3.5 + MOD(ROWNUM, 15) * 0.1 as average_rating,
       SYSTIMESTAMP as created_at,
       SYSTIMESTAMP as updated_at
FROM DUAL
WHERE ROWNUM <= 80;

-- 西式菜 (81-140)
INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)
SELECT seq_recipes.NEXTVAL, 
       CASE MOD(ROWNUM, 20) + 1 WHEN 1 THEN 11 WHEN 2 THEN 15 WHEN 3 THEN 16 ELSE MOD(ROWNUM, 20) + 31 END as user_id,
       CASE MOD(ROWNUM, 8)
           WHEN 1 THEN '意大利面'
           WHEN 2 THEN '凯撒沙拉'
           WHEN 3 THEN '烤鸡'
           WHEN 4 THEN '披萨'
           WHEN 5 THEN '牛排'
           WHEN 6 THEN '汉堡'
           WHEN 7 THEN '法式洋葱汤'
           ELSE '提拉米苏'
       END as recipe_name,
       '西方烹饪艺术的代表，融合传统与现代风味' as description,
       '西式' as cuisine_type,
       CASE MOD(ROWNUM, 4) WHEN 0 THEN 'breakfast' WHEN 1 THEN 'lunch' WHEN 2 THEN 'dinner' ELSE 'snack' END as meal_type,
       CASE MOD(ROWNUM, 4) WHEN 0 THEN 'easy' WHEN 1 THEN 'hard' ELSE 'medium' END as difficulty_level,
       15 + MOD(ROWNUM, 25) as prep_time,
       20 + MOD(ROWNUM, 50) as cook_time,
       35 + MOD(ROWNUM, 70) as total_time,
       3 + MOD(ROWNUM, 4) as servings,
       350 + MOD(ROWNUM*11, 450) as calories_per_serving,
       NULL as image_url,
       CASE WHEN MOD(ROWNUM, 10) = 0 THEN 'N' ELSE 'Y' END as is_published,
       'N' as is_deleted,
       60 + MOD(ROWNUM*9, 800) as view_count,
       MOD(ROWNUM, 8) + 1 as rating_count,
       3.6 + MOD(ROWNUM, 14) * 0.1 as average_rating,
       SYSTIMESTAMP as created_at,
       SYSTIMESTAMP as updated_at
FROM DUAL
WHERE ROWNUM <= 60;

-- 日式菜 (141-170)
INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)
SELECT seq_recipes.NEXTVAL, 
       CASE MOD(ROWNUM, 12) + 1 WHEN 1 THEN 22 WHEN 2 THEN 24 WHEN 3 THEN 25 ELSE MOD(ROWNUM, 12) + 35 END as user_id,
       CASE MOD(ROWNUM, 5)
           WHEN 1 THEN '寿司'
           WHEN 2 THEN '拉面'
           WHEN 3 THEN '天妇罗'
           WHEN 4 THEN '烤肉'
           ELSE '乌冬面'
       END as recipe_name,
       '日本传统料理，讲究食材新鲜和摆盘精美' as description,
       '日式' as cuisine_type,
       CASE MOD(ROWNUM, 3) WHEN 0 THEN 'breakfast' WHEN 1 THEN 'lunch' ELSE 'dinner' END as meal_type,
       CASE MOD(ROWNUM, 3) WHEN 0 THEN 'easy' WHEN 1 THEN 'hard' ELSE 'medium' END as difficulty_level,
       20 + MOD(ROWNUM, 30) as prep_time,
       25 + MOD(ROWNUM, 35) as cook_time,
       45 + MOD(ROWNUM, 60) as total_time,
       2 + MOD(ROWNUM, 4) as servings,
       280 + MOD(ROWNUM*17, 350) as calories_per_serving,
       NULL as image_url,
       'Y' as is_published,
       'N' as is_deleted,
       80 + MOD(ROWNUM*11, 600) as view_count,
       MOD(ROWNUM, 6) + 2 as rating_count,
       3.7 + MOD(ROWNUM, 13) * 0.1 as average_rating,
       SYSTIMESTAMP as created_at,
       SYSTIMESTAMP as updated_at
FROM DUAL
WHERE ROWNUM <= 30;

-- 其他菜系 (171-200)
INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)
SELECT seq_recipes.NEXTVAL, 
       CASE MOD(ROWNUM, 10) + 1 WHEN 1 THEN 26 WHEN 2 THEN 27 WHEN 3 THEN 28 ELSE MOD(ROWNUM, 10) + 38 END as user_id,
       CASE MOD(ROWNUM, 4)
           WHEN 1 THEN '咖喱饭'
           WHEN 2 THEN '泰式冬阴功汤'
           WHEN 3 THEN '印度烤鸡'
           ELSE '韩式烤肉'
       END as recipe_name,
       '各地特色料理，汇聚世界风味' as description,
       CASE MOD(ROWNUM, 4) WHEN 1 THEN '泰式' WHEN 2 THEN '印度' WHEN 3 THEN '韩式' ELSE '其他' END as cuisine_type,
       CASE MOD(ROWNUM, 2) WHEN 0 THEN 'lunch' ELSE 'dinner' END as meal_type,
       'medium' as difficulty_level,
       15 + MOD(ROWNUM, 20) as prep_time,
       30 + MOD(ROWNUM, 40) as cook_time,
       45 + MOD(ROWNUM, 55) as total_time,
       3 + MOD(ROWNUM, 3) as servings,
       320 + MOD(ROWNUM*19, 400) as calories_per_serving,
       NULL as image_url,
       'Y' as is_published,
       'N' as is_deleted,
       70 + MOD(ROWNUM*13, 700) as view_count,
       MOD(ROWNUM, 7) + 1 as rating_count,
       3.5 + MOD(ROWNUM, 15) * 0.1 as average_rating,
       SYSTIMESTAMP as created_at,
       SYSTIMESTAMP as updated_at
FROM DUAL
WHERE ROWNUM <= 30;

COMMIT;

-- ============================================================
-- 第三阶段：食谱详情数据（依赖第二阶段）
-- ============================================================

-- ============================================================
-- 7. 插入COOKING_STEPS（食谱步骤）
-- ============================================================

-- 为每个食谱添加4-5个步骤
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
SELECT seq_cooking_steps.NEXTVAL, recipe_id, step_num, instruction, time_req, NULL
FROM (
    SELECT recipe_id, 
           ROWNUM as step_num,
           CASE step_num
               WHEN 1 THEN '准备所有食材，按照食谱要求进行测量和预处理'
               WHEN 2 THEN '锅中加油烧热至适当温度（约160-180℃）'
               WHEN 3 THEN '依次加入食材，按照烹饪时间顺序进行处理'
               WHEN 4 THEN '调整火力和调味，根据口味进行加减'
               ELSE '装盘盛出，可根据个人喜好进行装饰，趁热享用'
           END as instruction,
           CASE step_num WHEN 1 THEN 5 WHEN 2 THEN 3 WHEN 3 THEN 10 WHEN 4 THEN 5 ELSE 2 END as time_req
    FROM (
        SELECT recipe_id, ROWNUM as step_num
        FROM (SELECT DISTINCT recipe_id FROM RECIPES ORDER BY recipe_id)
        WHERE ROWNUM <= 5
        CONNECT BY ROWNUM <= 5 AND PRIOR recipe_id = recipe_id
    )
);

COMMIT;

-- ============================================================
-- 8. 插入RECIPE_INGREDIENTS（食谱食材）
-- ============================================================

-- 为每个食谱添加3-7个食材
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
SELECT recipe_id, 
       (ingredient_id + MOD(recipe_id * 7, 90)) as ingredient_id,
       CASE MOD(ROWNUM, 6) WHEN 1 THEN 1 WHEN 2 THEN 3 WHEN 3 THEN 6 WHEN 4 THEN 7 WHEN 5 THEN 8 ELSE 15 END as unit_id,
       CASE MOD(ROWNUM, 4) WHEN 0 THEN 50 WHEN 1 THEN 100 WHEN 2 THEN 200 ELSE 5 END as quantity,
       CASE MOD(ROWNUM, 3) WHEN 0 THEN '切碎' WHEN 1 THEN '预先煮沸' ELSE NULL END as notes,
       SYSTIMESTAMP as added_at
FROM (
    SELECT recipe_id, ROWNUM as ingredient_id, ROWNUM as in_seq
    FROM (SELECT DISTINCT recipe_id FROM RECIPES WHERE recipe_id <= 200)
    WHERE ROWNUM <= 6
    CONNECT BY ROWNUM <= 6 AND PRIOR recipe_id = recipe_id
)
WHERE ingredient_id <= 100;

COMMIT;

-- ============================================================
-- 9. 插入NUTRITION_INFO（营养信息）
-- ============================================================

-- 为已发布的食谱添加营养信息
INSERT INTO NUTRITION_INFO (nutrition_id, recipe_id, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, sugar_grams, sodium_mg)
SELECT seq_nutrition_info.NEXTVAL, recipe_id, 
       calories_per_serving,
       15 + MOD(recipe_id*7, 25),
       35 + MOD(recipe_id*11, 45),
       12 + MOD(recipe_id*5, 20),
       3 + MOD(recipe_id, 5),
       5 + MOD(recipe_id*3, 15),
       500 + MOD(recipe_id*13, 800)
FROM RECIPES
WHERE is_published = 'Y' AND ROWNUM <= 180;

COMMIT;

-- ============================================================
-- 10. 插入INGREDIENT_ALLERGENS（食材过敏原）
-- ============================================================

INSERT INTO INGREDIENT_ALLERGENS (ingredient_id, allergen_id)
VALUES (55, 1); -- 花生油 → 花生
INSERT INTO INGREDIENT_ALLERGENS (ingredient_id, allergen_id)
VALUES (62, 3); -- 牛奶 → 乳制品
INSERT INTO INGREDIENT_ALLERGENS (ingredient_id, allergen_id)
VALUES (86, 4); -- 鸡蛋 → 鸡蛋
INSERT INTO INGREDIENT_ALLERGENS (ingredient_id, allergen_id)
VALUES (42, 5); -- 虾 → 海鲜
INSERT INTO INGREDIENT_ALLERGENS (ingredient_id, allergen_id)
VALUES (43, 6); -- 鱼 → 鱼
INSERT INTO INGREDIENT_ALLERGENS (ingredient_id, allergen_id)
VALUES (79, 7); -- 面粉 → 小麦
INSERT INTO INGREDIENT_ALLERGENS (ingredient_id, allergen_id)
VALUES (82, 8); -- 大豆 → 大豆
INSERT INTO INGREDIENT_ALLERGENS (ingredient_id, allergen_id)
VALUES (88, 9); -- 芝麻 → 芝麻
INSERT INTO INGREDIENT_ALLERGENS (ingredient_id, allergen_id)
VALUES (59, 10); -- 芥末 → 芥末

COMMIT;

-- ============================================================
-- 11. 插入INGREDIENT_SUBSTITUTIONS（食材替代品）
-- ============================================================

INSERT INTO INGREDIENT_SUBSTITUTIONS (original_ingredient_id, substitute_ingredient_id, substitution_ratio, notes, added_at)
VALUES (55, 56, 1.2, '植物油替代动物油，用量增加20%', SYSTIMESTAMP); -- 油 → 植物油
INSERT INTO INGREDIENT_SUBSTITUTIONS (original_ingredient_id, substitute_ingredient_id, substitution_ratio, notes, added_at)
VALUES (62, 64, 1.5, '酸奶替代淡奶油，用量增加50%', SYSTIMESTAMP); -- 牛奶 → 酸奶
INSERT INTO INGREDIENT_SUBSTITUTIONS (original_ingredient_id, substitute_ingredient_id, substitution_ratio, notes, added_at)
VALUES (79, 80, 1.0, '全麦粉替代普通面粉，比例相同', SYSTIMESTAMP); -- 面粉 → 全麦粉
INSERT INTO INGREDIENT_SUBSTITUTIONS (original_ingredient_id, substitute_ingredient_id, substitution_ratio, notes, added_at)
VALUES (46, 47, 0.8, '糖可用蜂蜜替代，用量减少20%', SYSTIMESTAMP); -- 糖 → 蜂蜜
INSERT INTO INGREDIENT_SUBSTITUTIONS (original_ingredient_id, substitute_ingredient_id, substitution_ratio, notes, added_at)
VALUES (82, 1, 1.0, '豆类可用其他豆类替代', SYSTIMESTAMP); -- 大豆 → 番茄

COMMIT;

-- ============================================================
-- 12. 插入RECIPE_TAGS（食谱标签）
-- ============================================================

INSERT INTO RECIPE_TAGS (recipe_id, tag_id, added_at)
SELECT recipe_id, 
       CASE MOD(recipe_id, 20) + 1
           WHEN 1 THEN 1 -- 素食
           WHEN 2 THEN 4 -- 低脂
           WHEN 3 THEN 8 -- 煮
           WHEN 4 THEN 10 -- 快手菜
           WHEN 5 THEN 13 -- 健身餐
           WHEN 6 THEN 16 -- 家常菜
           WHEN 7 THEN 18 -- 早餐
           WHEN 8 THEN 19 -- 甜点
           WHEN 9 THEN 20 -- 零食
           ELSE 15 -- 补气血
       END as tag_id,
       SYSTIMESTAMP as added_at
FROM RECIPES
WHERE ROWNUM <= 150;

INSERT INTO RECIPE_TAGS (recipe_id, tag_id, added_at)
SELECT recipe_id, 
       CASE MOD(recipe_id, 10) + 1
           WHEN 1 THEN 5 -- 烤
           WHEN 2 THEN 6 -- 炸
           WHEN 3 THEN 7 -- 蒸
           WHEN 4 THEN 9 -- 炒
           WHEN 5 THEN 11 -- 节日大餐
           WHEN 6 THEN 12 -- 儿童食品
           WHEN 7 THEN 14 -- 减肥餐
           WHEN 8 THEN 17 -- 创意菜
           WHEN 9 THEN 2 -- 纯素
           ELSE 3 -- 无麸质
       END as tag_id,
       SYSTIMESTAMP as added_at
FROM RECIPES
WHERE recipe_id > 100 AND ROWNUM <= 100;

COMMIT;

-- ============================================================
-- 第四阶段：用户交互数据（依赖前面的阶段）
-- ============================================================

-- ============================================================
-- 13. 插入RATINGS（食谱评价）
-- ============================================================

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
SELECT seq_ratings.NEXTVAL, 
       31 + MOD(ROWNUM, 20) as user_id,
       1 + MOD(ROWNUM, 190) as recipe_id,
       CASE MOD(ROWNUM, 10)
           WHEN 0 THEN 5.0
           WHEN 1 THEN 4.5
           WHEN 2 THEN 4.0
           WHEN 3 THEN 4.0
           WHEN 4 THEN 4.5
           WHEN 5 THEN 3.5
           WHEN 6 THEN 3.5
           WHEN 7 THEN 3.0
           WHEN 8 THEN 2.5
           ELSE 2.0
       END as rating_value,
       CASE MOD(ROWNUM, 5)
           WHEN 0 THEN '非常好吃！强烈推荐给所有人！'
           WHEN 1 THEN '不错，但需要改进调味，下次会调整'
           WHEN 2 THEN '还可以，口味一般，没什么特别的'
           WHEN 3 THEN '按照步骤做的，但不如预期那么好吃'
           ELSE NULL
       END as review_text,
       TRUNC(SYSDATE - MOD(ROWNUM, 30)) as rating_date
FROM DUAL
WHERE ROWNUM <= 350;

COMMIT;

-- ============================================================
-- 14. 插入COMMENTS（评论）
-- ============================================================

INSERT INTO COMMENTS (comment_id, user_id, recipe_id, comment_text, parent_comment_id, created_at, updated_at)
SELECT seq_comments.NEXTVAL,
       31 + MOD(ROWNUM, 20) as user_id,
       1 + MOD(ROWNUM*3, 190) as recipe_id,
       CASE MOD(ROWNUM, 6)
           WHEN 0 THEN '这道菜配XX会更好吃，我下次要这样试试'
           WHEN 1 THEN '我的做法是这样的：先炒香配菜，然后...'
           WHEN 2 THEN '请问用高压锅行吗？应该怎么调整时间？'
           WHEN 3 THEN '按照步骤做的但还是失败了，有什么建议吗？'
           WHEN 4 THEN '非常感谢分享这个食谱！我家人都很喜欢！'
           ELSE '能否详细说明一下第三步的温度控制？'
       END as comment_text,
       NULL as parent_comment_id,
       TRUNC(SYSDATE - MOD(ROWNUM, 20)) as created_at,
       TRUNC(SYSDATE - MOD(ROWNUM, 20)) as updated_at
FROM DUAL
WHERE ROWNUM <= 200;

COMMIT;

-- ============================================================
-- 15. 插入SAVED_RECIPES（收藏）
-- ============================================================

INSERT INTO SAVED_RECIPES (saved_recipe_id, user_id, recipe_id, saved_at)
SELECT seq_saved_recipes.NEXTVAL,
       31 + MOD(ROWNUM, 20) as user_id,
       1 + MOD(ROWNUM*13, 180) as recipe_id,
       TRUNC(SYSDATE - MOD(ROWNUM, 45)) as saved_at
FROM DUAL
WHERE ROWNUM <= 250
AND (31 + MOD(ROWNUM, 20), 1 + MOD(ROWNUM*13, 180)) NOT IN (
    SELECT 31 + MOD(ROWNUM, 20), 1 + MOD(ROWNUM*13, 180)
    FROM DUAL
    WHERE ROWNUM <= 249
);

COMMIT;

-- ============================================================
-- 16. 插入FOLLOWERS（关注关系）
-- ============================================================

INSERT INTO FOLLOWERS (user_id, follower_user_id, followed_at)
SELECT CASE MOD(ROWNUM, 20) WHEN 0 THEN 11 WHEN 1 THEN 12 WHEN 2 THEN 13 WHEN 3 THEN 14 ELSE 15 + MOD(ROWNUM, 8) END as user_id,
       31 + MOD(ROWNUM*7, 20) as follower_user_id,
       TRUNC(SYSDATE - MOD(ROWNUM, 60)) as followed_at
FROM DUAL
WHERE ROWNUM <= 100
AND CASE MOD(ROWNUM, 20) WHEN 0 THEN 11 WHEN 1 THEN 12 WHEN 2 THEN 13 WHEN 3 THEN 14 ELSE 15 + MOD(ROWNUM, 8) END != 31 + MOD(ROWNUM*7, 20);

COMMIT;

-- ============================================================
-- 17. 插入USER_ALLERGIES（用户过敏原）
-- ============================================================

INSERT INTO USER_ALLERGIES (user_id, allergen_id, added_at)
VALUES (5, 1, SYSTIMESTAMP); -- 用户5 → 花生
INSERT INTO USER_ALLERGIES (user_id, allergen_id, added_at)
VALUES (8, 3, SYSTIMESTAMP); -- 用户8 → 乳制品
INSERT INTO USER_ALLERGIES (user_id, allergen_id, added_at)
VALUES (12, 5, SYSTIMESTAMP); -- 用户12 → 海鲜
INSERT INTO USER_ALLERGIES (user_id, allergen_id, added_at)
VALUES (15, 1, SYSTIMESTAMP); -- 用户15 → 花生
INSERT INTO USER_ALLERGIES (user_id, allergen_id, added_at)
VALUES (15, 2, SYSTIMESTAMP); -- 用户15 → 坚果
INSERT INTO USER_ALLERGIES (user_id, allergen_id, added_at)
VALUES (20, 4, SYSTIMESTAMP); -- 用户20 → 鸡蛋
INSERT INTO USER_ALLERGIES (user_id, allergen_id, added_at)
VALUES (25, 7, SYSTIMESTAMP); -- 用户25 → 小麦
INSERT INTO USER_ALLERGIES (user_id, allergen_id, added_at)
VALUES (30, 6, SYSTIMESTAMP); -- 用户30 → 鱼

COMMIT;

-- ============================================================
-- 第五阶段：个人管理数据（依赖前面的阶段）
-- ============================================================

-- ============================================================
-- 18. 插入RECIPE_COLLECTIONS（食谱清单）
-- ============================================================

INSERT INTO RECIPE_COLLECTIONS (collection_id, user_id, collection_name, description, is_public, created_at, updated_at)
SELECT seq_recipe_collections.NEXTVAL,
       11 + MOD(ROWNUM, 25) as user_id,
       CASE MOD(ROWNUM, 5)
           WHEN 0 THEN '健康晚餐'
           WHEN 1 THEN '快手菜大全'
           WHEN 2 THEN '适合儿童的菜谱'
           WHEN 3 THEN '节日大餐'
           ELSE '减肥食谱'
       END as collection_name,
       '精心整理的食谱清单，适合各种场景' as description,
       CASE WHEN MOD(ROWNUM, 3) = 0 THEN 'N' ELSE 'Y' END as is_public,
       TRUNC(SYSDATE - MOD(ROWNUM, 60)) as created_at,
       TRUNC(SYSDATE - MOD(ROWNUM, 30)) as updated_at
FROM DUAL
WHERE ROWNUM <= 30;

COMMIT;

-- ============================================================
-- 19. 插入COLLECTION_RECIPES（清单食谱）
-- ============================================================

INSERT INTO COLLECTION_RECIPES (collection_id, recipe_id, added_at)
SELECT MOD(ROWNUM, 30) + 1 as collection_id,
       1 + MOD(ROWNUM*7, 190) as recipe_id,
       TRUNC(SYSDATE - MOD(ROWNUM, 40)) as added_at
FROM DUAL
WHERE ROWNUM <= 180;

COMMIT;

-- ============================================================
-- 20. 插入SHOPPING_LISTS（购物清单）
-- ============================================================

INSERT INTO SHOPPING_LISTS (list_id, user_id, list_name, created_at, updated_at)
SELECT seq_shopping_lists.NEXTVAL,
       31 + MOD(ROWNUM, 20) as user_id,
       '购物清单 ' || TO_CHAR(TRUNC(SYSDATE - MOD(ROWNUM, 30)), 'YYYY-MM-DD') as list_name,
       TRUNC(SYSDATE - MOD(ROWNUM, 30)) as created_at,
       TRUNC(SYSDATE - MOD(ROWNUM, 15)) as updated_at
FROM DUAL
WHERE ROWNUM <= 40;

COMMIT;

-- ============================================================
-- 21. 插入SHOPPING_LIST_ITEMS（购物清单项目）
-- ============================================================

INSERT INTO SHOPPING_LIST_ITEMS (list_id, ingredient_id, quantity, unit_id, is_checked, added_at)
SELECT MOD(ROWNUM, 40) + 1 as list_id,
       1 + MOD(ROWNUM*11, 95) as ingredient_id,
       CASE MOD(ROWNUM, 4) WHEN 0 THEN 500 WHEN 1 THEN 1000 WHEN 2 THEN 250 ELSE 100 END as quantity,
       CASE MOD(ROWNUM, 3) WHEN 0 THEN 1 WHEN 1 THEN 3 ELSE 8 END as unit_id,
       CASE WHEN MOD(ROWNUM, 3) = 0 THEN 'Y' ELSE 'N' END as is_checked,
       TRUNC(SYSDATE - MOD(ROWNUM, 25)) as added_at
FROM DUAL
WHERE ROWNUM <= 200;

COMMIT;

-- ============================================================
-- 22. 插入MEAL_PLANS（膳食计划）
-- ============================================================

INSERT INTO MEAL_PLANS (plan_id, user_id, plan_name, description, start_date, end_date, is_public, created_at, updated_at)
SELECT seq_meal_plans.NEXTVAL,
       11 + MOD(ROWNUM, 25) as user_id,
       CASE MOD(ROWNUM, 3) WHEN 0 THEN '7日膳食计划' WHEN 1 THEN '14日膳食计划' ELSE '月度膳食计划' END as plan_name,
       '科学合理的膳食安排，营养均衡' as description,
       TRUNC(SYSDATE) as start_date,
       TRUNC(SYSDATE) + CASE MOD(ROWNUM, 3) WHEN 0 THEN 7 WHEN 1 THEN 14 ELSE 30 END as end_date,
       CASE WHEN MOD(ROWNUM, 4) = 0 THEN 'N' ELSE 'Y' END as is_public,
       TRUNC(SYSDATE - MOD(ROWNUM, 40)) as created_at,
       TRUNC(SYSDATE - MOD(ROWNUM, 20)) as updated_at
FROM DUAL
WHERE ROWNUM <= 20;

COMMIT;

-- ============================================================
-- 23. 插入MEAL_PLAN_ENTRIES（膳食计划条目）
-- ============================================================

INSERT INTO MEAL_PLAN_ENTRIES (plan_id, recipe_id, meal_date, meal_type, notes, added_at)
SELECT MOD(ROWNUM, 20) + 1 as plan_id,
       1 + MOD(ROWNUM*13, 180) as recipe_id,
       TRUNC(SYSDATE) + FLOOR(MOD(ROWNUM, 10) / 3) as meal_date,
       CASE MOD(ROWNUM, 3) WHEN 0 THEN 'breakfast' WHEN 1 THEN 'lunch' ELSE 'dinner' END as meal_type,
       CASE WHEN MOD(ROWNUM, 5) = 0 THEN '可根据口味调整' ELSE NULL END as notes,
       TRUNC(SYSDATE - MOD(ROWNUM, 30)) as added_at
FROM DUAL
WHERE ROWNUM <= 120;

COMMIT;

-- ============================================================
-- 数据导入完成
-- ============================================================

PROMPT
PROMPT ========== AllRecipes 数据导入完成 ==========
PROMPT

SELECT '用户总数' label, COUNT(*) cnt FROM USERS
UNION ALL SELECT '食材总数', COUNT(*) FROM INGREDIENTS
UNION ALL SELECT '单位总数', COUNT(*) FROM UNITS
UNION ALL SELECT '过敏原总数', COUNT(*) FROM ALLERGENS
UNION ALL SELECT '标签总数', COUNT(*) FROM TAGS
UNION ALL SELECT '食谱总数', COUNT(*) FROM RECIPES
UNION ALL SELECT '烹饪步骤总数', COUNT(*) FROM COOKING_STEPS
UNION ALL SELECT '食谱食材总数', COUNT(*) FROM RECIPE_INGREDIENTS
UNION ALL SELECT '评价总数', COUNT(*) FROM RATINGS
UNION ALL SELECT '评论总数', COUNT(*) FROM COMMENTS
UNION ALL SELECT '收藏总数', COUNT(*) FROM SAVED_RECIPES
UNION ALL SELECT '关注总数', COUNT(*) FROM FOLLOWERS
UNION ALL SELECT '用户过敏原总数', COUNT(*) FROM USER_ALLERGIES
UNION ALL SELECT '食谱清单总数', COUNT(*) FROM RECIPE_COLLECTIONS
UNION ALL SELECT '购物清单总数', COUNT(*) FROM SHOPPING_LISTS
UNION ALL SELECT '膳食计划总数', COUNT(*) FROM MEAL_PLANS
ORDER BY label;

PROMPT
PROMPT ========== 数据导入统计完成 ==========
