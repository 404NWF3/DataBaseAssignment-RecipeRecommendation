-- 1. 插入USERS
DROP SEQUENCE seq_users;
CREATE SEQUENCE seq_users START WITH 1 INCREMENT BY 1 NOCACHE ORDER;
INSERT INTO USERS (user_id, username, email, password_hash, first_name, last_name, bio, profile_image, join_date, last_login, account_status, total_followers, total_recipes, created_at, updated_at)
VALUES (seq_users.NEXTVAL, 'zhang_wei', 'zhang.wei@email.com', 'pwd_hash_zw123', 'Zhang', 'Wei', '专业美食摄影师，运营家常菜那些事公众号，分享地道家常菜做法', NULL, TRUNC(SYSDATE - 180), TRUNC(SYSDATE - 2), 'active', 450, 8, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO USERS (user_id, username, email, password_hash, first_name, last_name, bio, profile_image, join_date, last_login, account_status, total_followers, total_recipes, created_at, updated_at)
VALUES (seq_users.NEXTVAL, 'li_na', 'li.na.cooking@email.com', 'pwd_hash_ln456', 'Li', 'Na', '餐厅主厨5年，擅长川菜和湖南菜，热爱分享烹饪技巧', NULL, TRUNC(SYSDATE - 200), TRUNC(SYSDATE - 1), 'active', 320, 6, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO USERS (user_id, username, email, password_hash, first_name, last_name, bio, profile_image, join_date, last_login, account_status, total_followers, total_recipes, created_at, updated_at)
VALUES (seq_users.NEXTVAL, 'wang_jun', 'wangjun1990@email.com', 'pwd_hash_wj789', 'Wang', 'Jun', '上班族，热爱快手菜和健身餐，记录美食生活', NULL, TRUNC(SYSDATE - 120), TRUNC(SYSDATE), 'active', 0, 2, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO USERS (user_id, username, email, password_hash, first_name, last_name, bio, profile_image, join_date, last_login, account_status, total_followers, total_recipes, created_at, updated_at)
VALUES (seq_users.NEXTVAL, 'liu_fang', 'fang.liu.home@email.com', 'pwd_hash_lf111', 'Liu', 'Fang', '全职妈妈，分享家常菜和儿童食谱，让孩子享受美食', NULL, TRUNC(SYSDATE - 150), TRUNC(SYSDATE - 3), 'active', 180, 4, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO USERS (user_id, username, email, password_hash, first_name, last_name, bio, profile_image, join_date, last_login, account_status, total_followers, total_recipes, created_at, updated_at)
VALUES (seq_users.NEXTVAL, 'chen_ming', 'chen.ming.chef@email.com', 'pwd_hash_cm222', 'Chen', 'Ming', '面食专家，自有面馆，专注于传统面食制作和创新', NULL, TRUNC(SYSDATE - 220), TRUNC(SYSDATE - 5), 'active', 280, 5, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO USERS (user_id, username, email, password_hash, first_name, last_name, bio, profile_image, join_date, last_login, account_status, total_followers, total_recipes, created_at, updated_at)
VALUES (seq_users.NEXTVAL, 'xu_hui', 'hui.xu.health@email.com', 'pwd_hash_xh333', 'Xu', 'Hui', '注册营养师，分享科学健康的食谱和营养知识', NULL, TRUNC(SYSDATE - 160), TRUNC(SYSDATE - 1), 'active', 520, 5, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO USERS (user_id, username, email, password_hash, first_name, last_name, bio, profile_image, join_date, last_login, account_status, total_followers, total_recipes, created_at, updated_at)
VALUES (seq_users.NEXTVAL, 'zhou_tao', 'tao.zhou@email.com', 'pwd_hash_zt444', 'Zhou', 'Tao', '美食爱好者，热爱尝试新菜谱，分享心得体会', NULL, TRUNC(SYSDATE - 100), TRUNC(SYSDATE - 4), 'active', 0, 1, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO USERS (user_id, username, email, password_hash, first_name, last_name, bio, profile_image, join_date, last_login, account_status, total_followers, total_recipes, created_at, updated_at)
VALUES (seq_users.NEXTVAL, 'guo_qiang', 'guo.qiang.food@email.com', 'pwd_hash_gq555', 'Guo', 'Qiang', '资深吃货，热爱测评各地特色菜，探寻美食故事', NULL, TRUNC(SYSDATE - 140), TRUNC(SYSDATE - 2), 'active', 380, 4, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO USERS (user_id, username, email, password_hash, first_name, last_name, bio, profile_image, join_date, last_login, account_status, total_followers, total_recipes, created_at, updated_at)
VALUES (seq_users.NEXTVAL, 'sun_yue', 'sun.yue.cook@email.com', 'pwd_hash_sy666', 'Sun', 'Yue', '大学生，想学做家常菜，与家人分享美食', NULL, TRUNC(SYSDATE - 80), TRUNC(SYSDATE), 'active', 0, 1, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO USERS (user_id, username, email, password_hash, first_name, last_name, bio, profile_image, join_date, last_login, account_status, total_followers, total_recipes, created_at, updated_at)
VALUES (seq_users.NEXTVAL, 'jiang_lin', 'jiang.lin.baker@email.com', 'pwd_hash_jl777', 'Jiang', 'Lin', '西点烘焙师，分享烘焙技巧和精致甜品食谱', NULL, TRUNC(SYSDATE - 170), TRUNC(SYSDATE - 3), 'active', 290, 3, SYSTIMESTAMP, SYSTIMESTAMP);

delete from users;
DROP SEQUENCE seq_users;
CREATE SEQUENCE seq_users START WITH 1 INCREMENT BY 1 NOCACHE ORDER;
INSERT INTO USERS (user_id, username, email, password_hash, first_name, last_name, bio, profile_image, join_date, last_login, account_status, total_followers, total_recipes, created_at, updated_at)
VALUES (seq_users.NEXTVAL, 'zhang_wei', 'zhang.wei@email.com', 'pwd_hash_zw123', 'Zhang', 'Wei', '专业美食摄影师，运营家常菜那些事公众号，分享地道家常菜做法', NULL, TRUNC(SYSDATE - 180), TRUNC(SYSDATE - 2), 'active', 450, 8, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO USERS (user_id, username, email, password_hash, first_name, last_name, bio, profile_image, join_date, last_login, account_status, total_followers, total_recipes, created_at, updated_at)
VALUES (seq_users.NEXTVAL, 'li_na', 'li.na.cooking@email.com', 'pwd_hash_ln456', 'Li', 'Na', '餐厅主厨5年，擅长川菜和湖南菜，热爱分享烹饪技巧', NULL, TRUNC(SYSDATE - 200), TRUNC(SYSDATE - 1), 'active', 320, 6, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO USERS (user_id, username, email, password_hash, first_name, last_name, bio, profile_image, join_date, last_login, account_status, total_followers, total_recipes, created_at, updated_at)
VALUES (seq_users.NEXTVAL, 'wang_jun', 'wangjun1990@email.com', 'pwd_hash_wj789', 'Wang', 'Jun', '上班族，热爱快手菜和健身餐，记录美食生活', NULL, TRUNC(SYSDATE - 120), TRUNC(SYSDATE), 'active', 0, 2, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO USERS (user_id, username, email, password_hash, first_name, last_name, bio, profile_image, join_date, last_login, account_status, total_followers, total_recipes, created_at, updated_at)
VALUES (seq_users.NEXTVAL, 'liu_fang', 'fang.liu.home@email.com', 'pwd_hash_lf111', 'Liu', 'Fang', '全职妈妈，分享家常菜和儿童食谱，让孩子享受美食', NULL, TRUNC(SYSDATE - 150), TRUNC(SYSDATE - 3), 'active', 180, 4, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO USERS (user_id, username, email, password_hash, first_name, last_name, bio, profile_image, join_date, last_login, account_status, total_followers, total_recipes, created_at, updated_at)
VALUES (seq_users.NEXTVAL, 'chen_ming', 'chen.ming.chef@email.com', 'pwd_hash_cm222', 'Chen', 'Ming', '面食专家，自有面馆，专注于传统面食制作和创新', NULL, TRUNC(SYSDATE - 220), TRUNC(SYSDATE - 5), 'active', 280, 5, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO USERS (user_id, username, email, password_hash, first_name, last_name, bio, profile_image, join_date, last_login, account_status, total_followers, total_recipes, created_at, updated_at)
VALUES (seq_users.NEXTVAL, 'xu_hui', 'hui.xu.health@email.com', 'pwd_hash_xh333', 'Xu', 'Hui', '注册营养师，分享科学健康的食谱和营养知识', NULL, TRUNC(SYSDATE - 160), TRUNC(SYSDATE - 1), 'active', 520, 5, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO USERS (user_id, username, email, password_hash, first_name, last_name, bio, profile_image, join_date, last_login, account_status, total_followers, total_recipes, created_at, updated_at)
VALUES (seq_users.NEXTVAL, 'zhou_tao', 'tao.zhou@email.com', 'pwd_hash_zt444', 'Zhou', 'Tao', '美食爱好者，热爱尝试新菜谱，分享心得体会', NULL, TRUNC(SYSDATE - 100), TRUNC(SYSDATE - 4), 'active', 0, 1, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO USERS (user_id, username, email, password_hash, first_name, last_name, bio, profile_image, join_date, last_login, account_status, total_followers, total_recipes, created_at, updated_at)
VALUES (seq_users.NEXTVAL, 'guo_qiang', 'guo.qiang.food@email.com', 'pwd_hash_gq555', 'Guo', 'Qiang', '资深吃货，热爱测评各地特色菜，探寻美食故事', NULL, TRUNC(SYSDATE - 140), TRUNC(SYSDATE - 2), 'active', 380, 4, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO USERS (user_id, username, email, password_hash, first_name, last_name, bio, profile_image, join_date, last_login, account_status, total_followers, total_recipes, created_at, updated_at)
VALUES (seq_users.NEXTVAL, 'sun_yue', 'sun.yue.cook@email.com', 'pwd_hash_sy666', 'Sun', 'Yue', '大学生，想学做家常菜，与家人分享美食', NULL, TRUNC(SYSDATE - 80), TRUNC(SYSDATE), 'active', 0, 1, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO USERS (user_id, username, email, password_hash, first_name, last_name, bio, profile_image, join_date, last_login, account_status, total_followers, total_recipes, created_at, updated_at)
VALUES (seq_users.NEXTVAL, 'jiang_lin', 'jiang.lin.baker@email.com', 'pwd_hash_jl777', 'Jiang', 'Lin', '西点烘焙师，分享烘焙技巧和精致甜品食谱', NULL, TRUNC(SYSDATE - 170), TRUNC(SYSDATE - 3), 'active', 290, 3, SYSTIMESTAMP, SYSTIMESTAMP);

-- 2. 插入UNITS（12个标准单位）
delete from units;
DROP SEQUENCE seq_units;
CREATE SEQUENCE seq_units START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (seq_units.NEXTVAL, '克', 'g', '重量单位，烹饪最常用', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (seq_units.NEXTVAL, '千克', 'kg', '大重量单位，1000g=1kg', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (seq_units.NEXTVAL, '毫升', 'ml', '容量单位，液体测量', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (seq_units.NEXTVAL, '升', 'L', '大容量单位，1L=1000ml', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (seq_units.NEXTVAL, '杯', 'cup', '烹饪杯，约240ml', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (seq_units.NEXTVAL, '汤匙', 'tbsp', '大勺，约15ml', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (seq_units.NEXTVAL, '茶匙', 'tsp', '小勺，约5ml', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (seq_units.NEXTVAL, '个', 'pc', '单个计数', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (seq_units.NEXTVAL, '条', 'stick', '条状物品计数', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (seq_units.NEXTVAL, '斤', 'catty', '中国单位，1斤=500g', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (seq_units.NEXTVAL, '块', 'block', '块状物品计数', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (seq_units.NEXTVAL, '适量', 'to_taste', '不固定数量，按口味调整', SYSTIMESTAMP);

delete from units;
DROP SEQUENCE seq_units;
CREATE SEQUENCE seq_units START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (seq_units.NEXTVAL, '克', 'g', '重量单位，烹饪最常用', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (seq_units.NEXTVAL, '千克', 'kg', '大重量单位，1000g=1kg', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (seq_units.NEXTVAL, '毫升', 'ml', '容量单位，液体测量', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (seq_units.NEXTVAL, '升', 'L', '大容量单位，1L=1000ml', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (seq_units.NEXTVAL, '杯', 'cup', '烹饪杯，约240ml', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (seq_units.NEXTVAL, '汤匙', 'tbsp', '大勺，约15ml', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (seq_units.NEXTVAL, '茶匙', 'tsp', '小勺，约5ml', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (seq_units.NEXTVAL, '个', 'pc', '单个计数', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (seq_units.NEXTVAL, '条', 'stick', '条状物品计数', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (seq_units.NEXTVAL, '斤', 'catty', '中国单位，1斤=500g', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (seq_units.NEXTVAL, '块', 'block', '块状物品计数', SYSTIMESTAMP);
INSERT INTO UNITS (unit_id, unit_name, abbreviation, description, created_at)
VALUES (seq_units.NEXTVAL, '适量', 'to_taste', '不固定数量，按口味调整', SYSTIMESTAMP);

select * from UNITS;
COMMIT;

-- ============================================================
-- 3. 插入ALLERGENS（8个常见过敏原）
-- ============================================================
delete from allergens;
DROP SEQUENCE seq_allergens;
CREATE SEQUENCE seq_allergens START WITH 1 INCREMENT BY 1 NOCACHE ORDER;
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
VALUES (seq_allergens.NEXTVAL, '小麦', '面筋相关，面粉和面条等', SYSTIMESTAMP);
INSERT INTO ALLERGENS (allergen_id, allergen_name, description, created_at)
VALUES (seq_allergens.NEXTVAL, '大豆', '豆制品，豆浆豆腐等', SYSTIMESTAMP);
delete from allergens;
DROP SEQUENCE seq_allergens;
CREATE SEQUENCE seq_allergens START WITH 1 INCREMENT BY 1 NOCACHE ORDER;
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
VALUES (seq_allergens.NEXTVAL, '小麦', '面筋相关，面粉和面条等', SYSTIMESTAMP);
INSERT INTO ALLERGENS (allergen_id, allergen_name, description, created_at)
VALUES (seq_allergens.NEXTVAL, '大豆', '豆制品，豆浆豆腐等', SYSTIMESTAMP);
-- ============================================================
-- 4. 插入TAGS（12个标签）
-- ============================================================
delete from tags;
DROP SEQUENCE seq_tags;
CREATE SEQUENCE seq_tags START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (seq_tags.NEXTVAL, '快手菜', '30分钟以内完成的简单菜', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (seq_tags.NEXTVAL, '家常菜', '日常家庭餐桌常见的菜', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (seq_tags.NEXTVAL, '高蛋白', '适合健身增肌的高蛋白菜', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (seq_tags.NEXTVAL, '低脂', '脂肪含量低的健康菜', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (seq_tags.NEXTVAL, '儿童食品', '适合儿童食用的菜谱', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (seq_tags.NEXTVAL, '素食', '不含肉类的植物性菜', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (seq_tags.NEXTVAL, '清蒸', '用清蒸方法制作的菜', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (seq_tags.NEXTVAL, '炒制', '用炒锅快速炒制的菜', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (seq_tags.NEXTVAL, '烤制', '用烤箱或火烤制作的菜', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (seq_tags.NEXTVAL, '汤类', '各种汤品类菜谱', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (seq_tags.NEXTVAL, '甜点', '甜品和糕点类菜谱', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (seq_tags.NEXTVAL, '面食', '面条面食类菜谱', SYSTIMESTAMP);
delete from tags;
DROP SEQUENCE seq_tags;
CREATE SEQUENCE seq_tags START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (seq_tags.NEXTVAL, '快手菜', '30分钟以内完成的简单菜', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (seq_tags.NEXTVAL, '家常菜', '日常家庭餐桌常见的菜', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (seq_tags.NEXTVAL, '高蛋白', '适合健身增肌的高蛋白菜', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (seq_tags.NEXTVAL, '低脂', '脂肪含量低的健康菜', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (seq_tags.NEXTVAL, '儿童食品', '适合儿童食用的菜谱', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (seq_tags.NEXTVAL, '素食', '不含肉类的植物性菜', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (seq_tags.NEXTVAL, '清蒸', '用清蒸方法制作的菜', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (seq_tags.NEXTVAL, '炒制', '用炒锅快速炒制的菜', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (seq_tags.NEXTVAL, '烤制', '用烤箱或火烤制作的菜', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (seq_tags.NEXTVAL, '汤类', '各种汤品类菜谱', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (seq_tags.NEXTVAL, '甜点', '甜品和糕点类菜谱', SYSTIMESTAMP);
INSERT INTO TAGS (tag_id, tag_name, tag_description, created_at)
VALUES (seq_tags.NEXTVAL, '面食', '面条面食类菜谱', SYSTIMESTAMP);
-- ============================================================
-- 5. 插入INGREDIENTS（35个常用食材）
-- ============================================================
delete from ingredients;
DROP SEQUENCE seq_ingredients;
CREATE SEQUENCE seq_ingredients START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

-- 蔬菜(1-8)
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '番茄', '蔬菜', '新鲜番茄，富含番茄红素和维生素C', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '洋葱', '蔬菜', '提味的调味蔬菜，含硫化物', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '大蒜', '蔬菜', '香味十足的调味蔬菜，含有大蒜素', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '青椒', '蔬菜', '清爽的甜椒，含丰富维生素A', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '生菜', '蔬菜', '爽脆的沙拉菜，低热量', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '冬瓜', '蔬菜', '清热利湿的蔬菜，利尿效果好', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '土豆', '蔬菜', '淀粉丰富的根茎蔬菜，营养均衡', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '菠菜', '蔬菜', '绿叶菜，含铁丰富，营养高', SYSTIMESTAMP FROM DUAL;

-- 肉类(9-16)
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '鸡肉', '肉类', '白肉，低脂高蛋白', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '鸡腿', '肉类', '鸡腿肉，含骨，风味丰富', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '鸡蛋', '肉类', '完全蛋白，含丰富卵磷脂', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '猪肉', '肉类', '常见肉类，营养丰富', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '五花肉', '肉类', '猪肉中脂肪较多的部分，口感肥香', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '排骨', '肉类', '带骨的肋骨，汤料首选', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '虾', '肉类', '海鲜，低脂高蛋白，易消化', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '鱼', '肉类', '白肉鱼类，含Omega-3脂肪酸', SYSTIMESTAMP FROM DUAL;

-- 调味料(17-26)
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '盐', '调味料', '基础调味料，矿物质丰富', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '糖', '调味料', '甜味来源，能量物质', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '酱油', '调味料', '传统调味料，咸鲜味', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '醋', '调味料', '酸味来源，促进消化', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '油', '调味料', '烹饪用油，提供油脂', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '豆瓣酱', '调味料', '咸鲜辣的酱料，传统调味', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '番茄酱', '调味料', '番茄制品，酸酸甜甜', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '料酒', '调味料', '烹饪用酒，去腥增香', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '黑胡椒', '调味料', '香料，增加风味深度', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '姜', '调味料', '暖胃调味，驱寒温阳', SYSTIMESTAMP FROM DUAL;

-- 乳制品和谷物(27-31)
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '牛奶', '乳制品', '新鲜牛奶，含钙丰富', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '黄油', '乳制品', '乳脂提取，烘焙常用', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '米', '谷物', '白米，日常主食', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '面粉', '谷物', '小麦粉，烘焙基础', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '面条', '谷物', '面食，方便快手', SYSTIMESTAMP FROM DUAL;

-- 其他(32-35)
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '豆腐', '其他', '植物蛋白，营养丰富', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '蜂蜜', '其他', '天然甜味剂，营养价值高', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '坚果', '其他', '营养丰富，富含健康脂肪', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '淡奶油', '其他', '烘焙用奶油，奶香浓郁', SYSTIMESTAMP FROM DUAL;
delete from ingredients;
DROP SEQUENCE seq_ingredients;
CREATE SEQUENCE seq_ingredients START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

-- 蔬菜(1-8)
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '番茄', '蔬菜', '新鲜番茄，富含番茄红素和维生素C', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '洋葱', '蔬菜', '提味的调味蔬菜，含硫化物', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '大蒜', '蔬菜', '香味十足的调味蔬菜，含有大蒜素', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '青椒', '蔬菜', '清爽的甜椒，含丰富维生素A', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '生菜', '蔬菜', '爽脆的沙拉菜，低热量', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '冬瓜', '蔬菜', '清热利湿的蔬菜，利尿效果好', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '土豆', '蔬菜', '淀粉丰富的根茎蔬菜，营养均衡', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '菠菜', '蔬菜', '绿叶菜，含铁丰富，营养高', SYSTIMESTAMP FROM DUAL;

-- 肉类(9-16)
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '鸡肉', '肉类', '白肉，低脂高蛋白', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '鸡腿', '肉类', '鸡腿肉，含骨，风味丰富', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '鸡蛋', '肉类', '完全蛋白，含丰富卵磷脂', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '猪肉', '肉类', '常见肉类，营养丰富', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '五花肉', '肉类', '猪肉中脂肪较多的部分，口感肥香', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '排骨', '肉类', '带骨的肋骨，汤料首选', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '虾', '肉类', '海鲜，低脂高蛋白，易消化', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '鱼', '肉类', '白肉鱼类，含Omega-3脂肪酸', SYSTIMESTAMP FROM DUAL;

-- 调味料(17-26)
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '盐', '调味料', '基础调味料，矿物质丰富', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '糖', '调味料', '甜味来源，能量物质', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '酱油', '调味料', '传统调味料，咸鲜味', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '醋', '调味料', '酸味来源，促进消化', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '油', '调味料', '烹饪用油，提供油脂', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '豆瓣酱', '调味料', '咸鲜辣的酱料，传统调味', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '番茄酱', '调味料', '番茄制品，酸酸甜甜', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '料酒', '调味料', '烹饪用酒，去腥增香', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '黑胡椒', '调味料', '香料，增加风味深度', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '姜', '调味料', '暖胃调味，驱寒温阳', SYSTIMESTAMP FROM DUAL;

-- 乳制品和谷物(27-31)
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '牛奶', '乳制品', '新鲜牛奶，含钙丰富', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '黄油', '乳制品', '乳脂提取，烘焙常用', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '米', '谷物', '白米，日常主食', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '面粉', '谷物', '小麦粉，烘焙基础', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '面条', '谷物', '面食，方便快手', SYSTIMESTAMP FROM DUAL;

-- 其他(32-35)
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '豆腐', '其他', '植物蛋白，营养丰富', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '蜂蜜', '其他', '天然甜味剂，营养价值高', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '坚果', '其他', '营养丰富，富含健康脂肪', SYSTIMESTAMP FROM DUAL;
INSERT INTO INGREDIENTS (ingredient_id, ingredient_name, category, description, created_at)
SELECT seq_ingredients.NEXTVAL, '淡奶油', '其他', '烘焙用奶油，奶香浓郁', SYSTIMESTAMP FROM DUAL;


-- 6. 插入RECIPES（15个真实菜谱）
delete from recipes;
DROP SEQUENCE seq_recipes;
CREATE SEQUENCE seq_recipes START WITH 1 INCREMENT BY 1 NOCACHE ORDER;


-- 中式菜(1-8)
INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)
VALUES (seq_recipes.NEXTVAL, 2, '宫保鸡丁', '经典川菜，花生碎、辣椒和鸡丁的完美结合，香辣开胃', '川菜', 'lunch', 'medium', 15, 10, 25, 3, 280, NULL, 'Y', 'N', 120, 5, 4.6, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)
VALUES (seq_recipes.NEXTVAL, 5, '番茄鸡蛋面', '清汤面条，番茄酸酸甜甜，鸡蛋软滑，快手早餐首选', '家常', 'breakfast', 'easy', 5, 10, 15, 2, 320, NULL, 'Y', 'N', 250, 8, 4.75, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)
VALUES (seq_recipes.NEXTVAL, 1, '红烧肉', '入口即化的红烧肉，肥而不腻，是家宴的首选硬菜', '经典', 'dinner', 'medium', 10, 60, 70, 4, 380, NULL, 'Y', 'N', 180, 6, 4.8, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)
VALUES (seq_recipes.NEXTVAL, 6, '清蒸鱼', '保留鱼的鲜美，鲜嫩多汁，营养丰富，低脂健康', '粤菜', 'dinner', 'easy', 10, 15, 25, 2, 180, NULL, 'Y', 'N', 95, 4, 4.5, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)
VALUES (seq_recipes.NEXTVAL, 2, '麻婆豆腐', '麻辣豆腐，是川菜代表，豆腐嫩滑，汤汁浓郁', '川菜', 'lunch', 'medium', 10, 15, 25, 3, 200, NULL, 'Y', 'N', 140, 5, 4.4, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)
VALUES (seq_recipes.NEXTVAL, 4, '青菜炒蛋', '简单却美味，翠绿的菜叶配金黄的蛋液，营养快手菜', '家常', 'lunch', 'easy', 5, 8, 13, 2, 150, NULL, 'Y', 'N', 200, 7, 4.7, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)
VALUES (seq_recipes.NEXTVAL, 4, '冬瓜排骨汤', '清汤，清热利尿，冬瓜软烂，排骨软糯，营养汤品', '家常', 'dinner', 'easy', 10, 50, 60, 4, 120, NULL, 'Y', 'N', 85, 3, 4.3, SYSTIMESTAMP, SYSTIMESTAMP);

-- 西式菜(9-12)
INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)
VALUES (seq_recipes.NEXTVAL, 10, '意大利面-番茄肉酱', '经典意面，番茄肉酱香浓，面条劲道，家庭快手菜', '意大利', 'lunch', 'easy', 10, 20, 30, 2, 350, NULL, 'Y', 'N', 110, 4, 4.5, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)
VALUES (seq_recipes.NEXTVAL, 6, '凯撒沙拉', '清爽健康的沙拉，生菜爽脆，酱汁香浓，低脂健康', '美式', 'lunch', 'easy', 10, 5, 15, 2, 180, NULL, 'Y', 'N', 160, 6, 4.6, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)
VALUES (seq_recipes.NEXTVAL, 8, '烤鸡腿', '外脆内嫩的烤鸡腿，色泽金黄，香气扑鼻，高蛋白', '西式', 'dinner', 'easy', 10, 35, 45, 2, 320, NULL, 'Y', 'N', 140, 5, 4.6, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)
VALUES (seq_recipes.NEXTVAL, 10, '提拉米苏', '意大利经典甜品，层次丰富，咖啡香气，入口即化', '意大利', 'dessert', 'easy', 20, 0, 20, 4, 280, NULL, 'Y', 'N', 200, 8, 4.75, SYSTIMESTAMP, SYSTIMESTAMP);

-- 其他菜(13-15)
INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)
VALUES (seq_recipes.NEXTVAL, 8, '日式味增汤', '传统日式汤品，清汤鲜美，味增香气，营养丰富', '日本', 'breakfast', 'easy', 5, 10, 15, 2, 80, NULL, 'Y', 'N', 75, 3, 4.3, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)
VALUES (seq_recipes.NEXTVAL, 9, '寿司卷', '新鲜海鲜和蔬菜卷成的寿司，视觉漂亮，学习佳作', '日本', 'lunch', 'medium', 20, 10, 30, 2, 220, NULL, 'Y', 'N', 130, 5, 4.4, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)
VALUES (seq_recipes.NEXTVAL, 7, '咖喱鸡饭', '泰式咖喱，鸡肉软烂，米饭吸满咖喱汤汁，香气十足', '泰式', 'lunch', 'easy', 10, 20, 30, 2, 380, NULL, 'Y', 'N', 165, 6, 4.5, SYSTIMESTAMP, SYSTIMESTAMP);

delete from recipes;
DROP SEQUENCE seq_recipes;
CREATE SEQUENCE seq_recipes START WITH 1 INCREMENT BY 1 NOCACHE ORDER;


-- 中式菜(1-8)
INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)
VALUES (seq_recipes.NEXTVAL, 2, '宫保鸡丁', '经典川菜，花生碎、辣椒和鸡丁的完美结合，香辣开胃', '川菜', 'lunch', 'medium', 15, 10, 25, 3, 280, NULL, 'Y', 'N', 120, 5, 4.6, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)
VALUES (seq_recipes.NEXTVAL, 5, '番茄鸡蛋面', '清汤面条，番茄酸酸甜甜，鸡蛋软滑，快手早餐首选', '家常', 'breakfast', 'easy', 5, 10, 15, 2, 320, NULL, 'Y', 'N', 250, 8, 4.75, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)
VALUES (seq_recipes.NEXTVAL, 1, '红烧肉', '入口即化的红烧肉，肥而不腻，是家宴的首选硬菜', '经典', 'dinner', 'medium', 10, 60, 70, 4, 380, NULL, 'Y', 'N', 180, 6, 4.8, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)
VALUES (seq_recipes.NEXTVAL, 6, '清蒸鱼', '保留鱼的鲜美，鲜嫩多汁，营养丰富，低脂健康', '粤菜', 'dinner', 'easy', 10, 15, 25, 2, 180, NULL, 'Y', 'N', 95, 4, 4.5, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)
VALUES (seq_recipes.NEXTVAL, 2, '麻婆豆腐', '麻辣豆腐，是川菜代表，豆腐嫩滑，汤汁浓郁', '川菜', 'lunch', 'medium', 10, 15, 25, 3, 200, NULL, 'Y', 'N', 140, 5, 4.4, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)
VALUES (seq_recipes.NEXTVAL, 4, '青菜炒蛋', '简单却美味，翠绿的菜叶配金黄的蛋液，营养快手菜', '家常', 'lunch', 'easy', 5, 8, 13, 2, 150, NULL, 'Y', 'N', 200, 7, 4.7, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)
VALUES (seq_recipes.NEXTVAL, 4, '冬瓜排骨汤', '清汤，清热利尿，冬瓜软烂，排骨软糯，营养汤品', '家常', 'dinner', 'easy', 10, 50, 60, 4, 120, NULL, 'Y', 'N', 85, 3, 4.3, SYSTIMESTAMP, SYSTIMESTAMP);

-- 西式菜(9-12)
INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)
VALUES (seq_recipes.NEXTVAL, 10, '意大利面-番茄肉酱', '经典意面，番茄肉酱香浓，面条劲道，家庭快手菜', '意大利', 'lunch', 'easy', 10, 20, 30, 2, 350, NULL, 'Y', 'N', 110, 4, 4.5, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)
VALUES (seq_recipes.NEXTVAL, 6, '凯撒沙拉', '清爽健康的沙拉，生菜爽脆，酱汁香浓，低脂健康', '美式', 'lunch', 'easy', 10, 5, 15, 2, 180, NULL, 'Y', 'N', 160, 6, 4.6, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)
VALUES (seq_recipes.NEXTVAL, 8, '烤鸡腿', '外脆内嫩的烤鸡腿，色泽金黄，香气扑鼻，高蛋白', '西式', 'dinner', 'easy', 10, 35, 45, 2, 320, NULL, 'Y', 'N', 140, 5, 4.6, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)
VALUES (seq_recipes.NEXTVAL, 10, '提拉米苏', '意大利经典甜品，层次丰富，咖啡香气，入口即化', '意大利', 'dessert', 'easy', 20, 0, 20, 4, 280, NULL, 'Y', 'N', 200, 8, 4.75, SYSTIMESTAMP, SYSTIMESTAMP);

-- 其他菜(13-15)
INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)
VALUES (seq_recipes.NEXTVAL, 8, '日式味增汤', '传统日式汤品，清汤鲜美，味增香气，营养丰富', '日本', 'breakfast', 'easy', 5, 10, 15, 2, 80, NULL, 'Y', 'N', 75, 3, 4.3, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)
VALUES (seq_recipes.NEXTVAL, 9, '寿司卷', '新鲜海鲜和蔬菜卷成的寿司，视觉漂亮，学习佳作', '日本', 'lunch', 'medium', 20, 10, 30, 2, 220, NULL, 'Y', 'N', 130, 5, 4.4, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO RECIPES (recipe_id, user_id, recipe_name, description, cuisine_type, meal_type, difficulty_level, prep_time, cook_time, total_time, servings, calories_per_serving, image_url, is_published, is_deleted, view_count, rating_count, average_rating, created_at, updated_at)
VALUES (seq_recipes.NEXTVAL, 7, '咖喱鸡饭', '泰式咖喱，鸡肉软烂，米饭吸满咖喱汤汁，香气十足', '泰式', 'lunch', 'easy', 10, 20, 30, 2, 380, NULL, 'Y', 'N', 165, 6, 4.5, SYSTIMESTAMP, SYSTIMESTAMP);


-- ============================================================
-- 7. 插入COOKING_STEPS（食谱步骤，平均4-5步/菜谱）
-- ============================================================
delete from cooking_steps;
DROP SEQUENCE seq_cooking_steps;
CREATE SEQUENCE seq_cooking_steps START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

-- 宫保鸡丁（recipe_id=1）
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 1, 1, '鸡肉切丁（约1厘米见方），花生米炒香备用，干辣椒切段', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 1, 2, '鸡丁用盐、料酒、淀粉腌制10分钟，锁住水分', 3, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 1, 3, '锅中油热，放入鸡丁快速翻炒至变白，盛起备用', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 1, 4, '锅中再下油，炒香干辣椒和葱段，倒入鸡丁翻炒', 3, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 1, 5, '加入酱油、糖、醋调味，最后加入花生米，炒匀即可', 2, NULL);

-- 番茄鸡蛋面（recipe_id=2）
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 2, 1, '番茄洗净切块，鸡蛋打散备用', 3, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 2, 2, '锅中油热，倒入蛋液快速炒散盛起', 3, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 2, 3, '同一锅加油炒番茄块，出汁后加入清汤烧开', 4, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 2, 4, '下面条煮至半熟，加入鸡蛋和调料，煮2分钟即可', 3, NULL);


-- 红烧肉（recipe_id=3）
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 3, 1, '五花肉切块，焯水去血水后沥干', 10, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 3, 2, '锅中油热，放糖炒至焦黄，加入肉块炒匀上色', 8, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 3, 3, '加酱油、料酒、葱段、姜片、八角、香叶等调料翻炒', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 3, 4, '加热水没过肉块，大火烧开转小火炖50分钟', 50, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 3, 5, '炖至肉块软烂，汤汁浓稠，撒葱段即可出锅', 5, NULL);


-- 清蒸鱼（recipe_id=4）
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 4, 1, '鱼洗净，腹腔用盐搓洗，沥干，放在盘中', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 4, 2, '鱼身上放葱段和姜片，用酱油腌制5分钟', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 4, 3, '水烧开放入蒸盘，大火蒸10-15分钟至鱼肉熟透', 15, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 4, 4, '蒸好后撒葱段，淋热油，再浇热酱油，立即上桌', 2, NULL);

-- 麻婆豆腐（recipe_id=5）
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 5, 1, '豆腐切成小块，在盐水中浸泡，防止碎裂', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 5, 2, '锅中油热，下豆瓣酱炒香，加入清汤烧开', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 5, 3, '轻轻放入豆腐块，煮3-5分钟，豆腐入味', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 5, 4, '用淀粉勾芡，加花椒粉和辣椒油，撒葱段即可', 2, NULL);

-- 青菜炒蛋（recipe_id=6）
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 6, 1, '鸡蛋打散加盐，青菜洗净切段', 3, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 6, 2, '锅中油热，倒入蛋液快速炒散，盛起备用', 3, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 6, 3, '同锅再下油，炒青菜至半熟，加入鸡蛋炒匀', 4, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 6, 4, '加盐和少许酱油调味，炒匀即可出锅', 1, NULL);

-- 冬瓜排骨汤（recipe_id=7）
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 7, 1, '排骨焯水去血水，冬瓜去皮切块', 8, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 7, 2, '砂锅加清水，放入排骨大火烧开，撇去浮沫', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 7, 3, '转小火炖30分钟，排骨软烂，加入冬瓜块和盐', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 7, 4, '继续炖15分钟，冬瓜软烂，撒葱段即可', 15, NULL);

-- 意大利面（recipe_id=8）
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 8, 1, '番茄洗净切块，洋葱切碎，猪肉绞碎备用', 8, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 8, 2, '锅中油热，炒洋葱香，加入肉末炒至变色', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 8, 3, '加入番茄块和番茄酱，煮10分钟至浓稠，加盐调味', 10, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 8, 4, '面条按包装煮至al dente，沥干盛盘，铺上肉酱', 12, NULL);

-- 凯撒沙拉（recipe_id=9）
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 9, 1, '生菜洗净擦干切段，鸡蛋煮熟切块', 8, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 9, 2, '黑胡椒、盐、柠檬汁、橄榄油混合成酱汁', 3, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 9, 3, '生菜铺盘，加鸡蛋、芝士、坚果等配菜', 3, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 9, 4, '淋上酱汁，轻轻混匀即可食用', 2, NULL);

-- 烤鸡腿（recipe_id=10）
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 10, 1, '鸡腿用盐、黑胡椒、料酒腌制30分钟', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 10, 2, '烤箱预热至200℃，鸡腿排放在烤盘上', 3, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 10, 3, '烤30分钟至表面金黄，用筷子戳一下无血水即可', 30, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 10, 4, '取出装盘，撒葱段和香菜即可享用', 2, NULL);

-- 提拉米苏（recipe_id=11）
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 11, 1, '蛋黄加糖打发至浅色，加入马斯卡彭芝士混匀', 10, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 11, 2, '蛋白打发至硬性泡沫，分次加入蛋黄混合物', 8, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 11, 3, '手指饼蘸咖啡液，铺在容器底部，铺一层奶油', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 11, 4, '重复步骤，最后撒可可粉，冷藏4小时即可', 0, NULL);

-- 日式味增汤（recipe_id=12）
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 12, 1, '豆腐切小块，海带泡软，葱切段', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 12, 2, '清汤烧开，加入海带小火煮5分钟', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 12, 3, '加入豆腐块和味增，用勺子拌匀', 3, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 12, 4, '即将沸腾时关火，倒入碗中，撒葱段', 2, NULL);

-- 寿司卷（recipe_id=13）
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 13, 1, '寿司米煮好冷却，混入醋和糖调味', 10, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 13, 2, '海苔铺在竹帘上，铺一层米，压实', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 13, 3, '米上放黄瓜、胡萝卜、鸡蛋条等馅料', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 13, 4, '用竹帘卷成筒状，沾水刀切成片，装盘', 10, NULL);

-- 咖喱鸡饭（recipe_id=14）
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 14, 1, '鸡肉切块，洋葱切块，土豆切块', 8, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 14, 2, '锅中油热，下咖喱块或咖喱粉炒香，加清汤', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 14, 3, '加入鸡肉、土豆、洋葱块，煮15分钟至软烂', 15, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 14, 4, '盛米饭到盘中，浇上咖喱汤即可享用', 2, NULL);

delete from cooking_steps;
DROP SEQUENCE seq_cooking_steps;
CREATE SEQUENCE seq_cooking_steps START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

-- 宫保鸡丁（recipe_id=1）
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 1, 1, '鸡肉切丁（约1厘米见方），花生米炒香备用，干辣椒切段', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 1, 2, '鸡丁用盐、料酒、淀粉腌制10分钟，锁住水分', 3, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 1, 3, '锅中油热，放入鸡丁快速翻炒至变白，盛起备用', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 1, 4, '锅中再下油，炒香干辣椒和葱段，倒入鸡丁翻炒', 3, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 1, 5, '加入酱油、糖、醋调味，最后加入花生米，炒匀即可', 2, NULL);

-- 番茄鸡蛋面（recipe_id=2）
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 2, 1, '番茄洗净切块，鸡蛋打散备用', 3, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 2, 2, '锅中油热，倒入蛋液快速炒散盛起', 3, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 2, 3, '同一锅加油炒番茄块，出汁后加入清汤烧开', 4, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 2, 4, '下面条煮至半熟，加入鸡蛋和调料，煮2分钟即可', 3, NULL);


-- 红烧肉（recipe_id=3）
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 3, 1, '五花肉切块，焯水去血水后沥干', 10, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 3, 2, '锅中油热，放糖炒至焦黄，加入肉块炒匀上色', 8, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 3, 3, '加酱油、料酒、葱段、姜片、八角、香叶等调料翻炒', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 3, 4, '加热水没过肉块，大火烧开转小火炖50分钟', 50, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 3, 5, '炖至肉块软烂，汤汁浓稠，撒葱段即可出锅', 5, NULL);


-- 清蒸鱼（recipe_id=4）
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 4, 1, '鱼洗净，腹腔用盐搓洗，沥干，放在盘中', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 4, 2, '鱼身上放葱段和姜片，用酱油腌制5分钟', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 4, 3, '水烧开放入蒸盘，大火蒸10-15分钟至鱼肉熟透', 15, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 4, 4, '蒸好后撒葱段，淋热油，再浇热酱油，立即上桌', 2, NULL);

-- 麻婆豆腐（recipe_id=5）
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 5, 1, '豆腐切成小块，在盐水中浸泡，防止碎裂', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 5, 2, '锅中油热，下豆瓣酱炒香，加入清汤烧开', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 5, 3, '轻轻放入豆腐块，煮3-5分钟，豆腐入味', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 5, 4, '用淀粉勾芡，加花椒粉和辣椒油，撒葱段即可', 2, NULL);

-- 青菜炒蛋（recipe_id=6）
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 6, 1, '鸡蛋打散加盐，青菜洗净切段', 3, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 6, 2, '锅中油热，倒入蛋液快速炒散，盛起备用', 3, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 6, 3, '同锅再下油，炒青菜至半熟，加入鸡蛋炒匀', 4, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 6, 4, '加盐和少许酱油调味，炒匀即可出锅', 1, NULL);

-- 冬瓜排骨汤（recipe_id=7）
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 7, 1, '排骨焯水去血水，冬瓜去皮切块', 8, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 7, 2, '砂锅加清水，放入排骨大火烧开，撇去浮沫', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 7, 3, '转小火炖30分钟，排骨软烂，加入冬瓜块和盐', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 7, 4, '继续炖15分钟，冬瓜软烂，撒葱段即可', 15, NULL);

-- 意大利面（recipe_id=8）
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 8, 1, '番茄洗净切块，洋葱切碎，猪肉绞碎备用', 8, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 8, 2, '锅中油热，炒洋葱香，加入肉末炒至变色', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 8, 3, '加入番茄块和番茄酱，煮10分钟至浓稠，加盐调味', 10, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 8, 4, '面条按包装煮至al dente，沥干盛盘，铺上肉酱', 12, NULL);

-- 凯撒沙拉（recipe_id=9）
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 9, 1, '生菜洗净擦干切段，鸡蛋煮熟切块', 8, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 9, 2, '黑胡椒、盐、柠檬汁、橄榄油混合成酱汁', 3, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 9, 3, '生菜铺盘，加鸡蛋、芝士、坚果等配菜', 3, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 9, 4, '淋上酱汁，轻轻混匀即可食用', 2, NULL);

-- 烤鸡腿（recipe_id=10）
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 10, 1, '鸡腿用盐、黑胡椒、料酒腌制30分钟', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 10, 2, '烤箱预热至200℃，鸡腿排放在烤盘上', 3, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 10, 3, '烤30分钟至表面金黄，用筷子戳一下无血水即可', 30, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 10, 4, '取出装盘，撒葱段和香菜即可享用', 2, NULL);

-- 提拉米苏（recipe_id=11）
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 11, 1, '蛋黄加糖打发至浅色，加入马斯卡彭芝士混匀', 10, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 11, 2, '蛋白打发至硬性泡沫，分次加入蛋黄混合物', 8, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 11, 3, '手指饼蘸咖啡液，铺在容器底部，铺一层奶油', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 11, 4, '重复步骤，最后撒可可粉，冷藏4小时即可', 0, NULL);

-- 日式味增汤（recipe_id=12）
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 12, 1, '豆腐切小块，海带泡软，葱切段', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 12, 2, '清汤烧开，加入海带小火煮5分钟', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 12, 3, '加入豆腐块和味增，用勺子拌匀', 3, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 12, 4, '即将沸腾时关火，倒入碗中，撒葱段', 2, NULL);

-- 寿司卷（recipe_id=13）
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 13, 1, '寿司米煮好冷却，混入醋和糖调味', 10, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 13, 2, '海苔铺在竹帘上，铺一层米，压实', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 13, 3, '米上放黄瓜、胡萝卜、鸡蛋条等馅料', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 13, 4, '用竹帘卷成筒状，沾水刀切成片，装盘', 10, NULL);

-- 咖喱鸡饭（recipe_id=14）
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 14, 1, '鸡肉切块，洋葱切块，土豆切块', 8, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 14, 2, '锅中油热，下咖喱块或咖喱粉炒香，加清汤', 5, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 14, 3, '加入鸡肉、土豆、洋葱块，煮15分钟至软烂', 15, NULL);
INSERT INTO COOKING_STEPS (step_id, recipe_id, step_number, instruction, time_required, image_url)
VALUES (seq_cooking_steps.NEXTVAL, 14, 4, '盛米饭到盘中，浇上咖喱汤即可享用', 2, NULL);


-- ============================================================
-- 8. 插入NUTRITION_INFO（每个菜谱一条营养信息）
-- ============================================================
delete from NUTRITION_INFO;
DROP SEQUENCE seq_nutrition_info;
CREATE SEQUENCE seq_nutrition_info START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

INSERT INTO NUTRITION_INFO (nutrition_id, recipe_id, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, sugar_grams, sodium_mg)
VALUES (seq_nutrition_info.NEXTVAL, 1, 280, 32, 8, 12, 2, 2, 680);  -- 宫保鸡丁
INSERT INTO NUTRITION_INFO (nutrition_id, recipe_id, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, sugar_grams, sodium_mg)
VALUES (seq_nutrition_info.NEXTVAL, 2, 320, 14, 48, 6, 2, 3, 520);  -- 番茄鸡蛋面
INSERT INTO NUTRITION_INFO (nutrition_id, recipe_id, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, sugar_grams, sodium_mg)
VALUES (seq_nutrition_info.NEXTVAL, 3, 380, 28, 12, 26, 1, 8, 880);  -- 红烧肉
INSERT INTO NUTRITION_INFO (nutrition_id, recipe_id, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, sugar_grams, sodium_mg)
VALUES (seq_nutrition_info.NEXTVAL, 4, 180, 26, 2, 8, 0, 1, 420);  -- 清蒸鱼
INSERT INTO NUTRITION_INFO (nutrition_id, recipe_id, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, sugar_grams, sodium_mg)
VALUES (seq_nutrition_info.NEXTVAL, 5, 200, 18, 6, 12, 2, 3, 950);  -- 麻婆豆腐
INSERT INTO NUTRITION_INFO (nutrition_id, recipe_id, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, sugar_grams, sodium_mg)
VALUES (seq_nutrition_info.NEXTVAL, 6, 150, 12, 4, 10, 1, 1, 380);  -- 青菜炒蛋
INSERT INTO NUTRITION_INFO (nutrition_id, recipe_id, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, sugar_grams, sodium_mg)
VALUES (seq_nutrition_info.NEXTVAL, 7, 120, 16, 8, 3, 2, 2, 420);  -- 冬瓜排骨汤
INSERT INTO NUTRITION_INFO (nutrition_id, recipe_id, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, sugar_grams, sodium_mg)
VALUES (seq_nutrition_info.NEXTVAL, 8, 350, 18, 52, 8, 3, 4, 680);  -- 意大利面
INSERT INTO NUTRITION_INFO (nutrition_id, recipe_id, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, sugar_grams, sodium_mg)
VALUES (seq_nutrition_info.NEXTVAL, 9, 180, 14, 8, 10, 3, 2, 520);  -- 凯撒沙拉
INSERT INTO NUTRITION_INFO (nutrition_id, recipe_id, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, sugar_grams, sodium_mg)
VALUES (seq_nutrition_info.NEXTVAL, 10, 320, 38, 2, 18, 0, 0, 680);  -- 烤鸡腿
INSERT INTO NUTRITION_INFO (nutrition_id, recipe_id, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, sugar_grams, sodium_mg)
VALUES (seq_nutrition_info.NEXTVAL, 11, 280, 6, 32, 14, 1, 28, 120);  -- 提拉米苏
INSERT INTO NUTRITION_INFO (nutrition_id, recipe_id, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, sugar_grams, sodium_mg)
VALUES (seq_nutrition_info.NEXTVAL, 12, 80, 8, 4, 3, 1, 2, 420);  -- 日式味增汤
INSERT INTO NUTRITION_INFO (nutrition_id, recipe_id, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, sugar_grams, sodium_mg)
VALUES (seq_nutrition_info.NEXTVAL, 13, 220, 12, 28, 6, 2, 1, 480);  -- 寿司卷
INSERT INTO NUTRITION_INFO (nutrition_id, recipe_id, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, sugar_grams, sodium_mg)
VALUES (seq_nutrition_info.NEXTVAL, 14, 380, 20, 48, 12, 3, 3, 680);  -- 咖喱鸡饭

delete from NUTRITION_INFO;
DROP SEQUENCE seq_nutrition_info;
CREATE SEQUENCE seq_nutrition_info START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

INSERT INTO NUTRITION_INFO (nutrition_id, recipe_id, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, sugar_grams, sodium_mg)
VALUES (seq_nutrition_info.NEXTVAL, 1, 280, 32, 8, 12, 2, 2, 680);  -- 宫保鸡丁
INSERT INTO NUTRITION_INFO (nutrition_id, recipe_id, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, sugar_grams, sodium_mg)
VALUES (seq_nutrition_info.NEXTVAL, 2, 320, 14, 48, 6, 2, 3, 520);  -- 番茄鸡蛋面
INSERT INTO NUTRITION_INFO (nutrition_id, recipe_id, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, sugar_grams, sodium_mg)
VALUES (seq_nutrition_info.NEXTVAL, 3, 380, 28, 12, 26, 1, 8, 880);  -- 红烧肉
INSERT INTO NUTRITION_INFO (nutrition_id, recipe_id, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, sugar_grams, sodium_mg)
VALUES (seq_nutrition_info.NEXTVAL, 4, 180, 26, 2, 8, 0, 1, 420);  -- 清蒸鱼
INSERT INTO NUTRITION_INFO (nutrition_id, recipe_id, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, sugar_grams, sodium_mg)
VALUES (seq_nutrition_info.NEXTVAL, 5, 200, 18, 6, 12, 2, 3, 950);  -- 麻婆豆腐
INSERT INTO NUTRITION_INFO (nutrition_id, recipe_id, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, sugar_grams, sodium_mg)
VALUES (seq_nutrition_info.NEXTVAL, 6, 150, 12, 4, 10, 1, 1, 380);  -- 青菜炒蛋
INSERT INTO NUTRITION_INFO (nutrition_id, recipe_id, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, sugar_grams, sodium_mg)
VALUES (seq_nutrition_info.NEXTVAL, 7, 120, 16, 8, 3, 2, 2, 420);  -- 冬瓜排骨汤
INSERT INTO NUTRITION_INFO (nutrition_id, recipe_id, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, sugar_grams, sodium_mg)
VALUES (seq_nutrition_info.NEXTVAL, 8, 350, 18, 52, 8, 3, 4, 680);  -- 意大利面
INSERT INTO NUTRITION_INFO (nutrition_id, recipe_id, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, sugar_grams, sodium_mg)
VALUES (seq_nutrition_info.NEXTVAL, 9, 180, 14, 8, 10, 3, 2, 520);  -- 凯撒沙拉
INSERT INTO NUTRITION_INFO (nutrition_id, recipe_id, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, sugar_grams, sodium_mg)
VALUES (seq_nutrition_info.NEXTVAL, 10, 320, 38, 2, 18, 0, 0, 680);  -- 烤鸡腿
INSERT INTO NUTRITION_INFO (nutrition_id, recipe_id, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, sugar_grams, sodium_mg)
VALUES (seq_nutrition_info.NEXTVAL, 11, 280, 6, 32, 14, 1, 28, 120);  -- 提拉米苏
INSERT INTO NUTRITION_INFO (nutrition_id, recipe_id, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, sugar_grams, sodium_mg)
VALUES (seq_nutrition_info.NEXTVAL, 12, 80, 8, 4, 3, 1, 2, 420);  -- 日式味增汤
INSERT INTO NUTRITION_INFO (nutrition_id, recipe_id, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, sugar_grams, sodium_mg)
VALUES (seq_nutrition_info.NEXTVAL, 13, 220, 12, 28, 6, 2, 1, 480);  -- 寿司卷
INSERT INTO NUTRITION_INFO (nutrition_id, recipe_id, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, sugar_grams, sodium_mg)
VALUES (seq_nutrition_info.NEXTVAL, 14, 380, 20, 48, 12, 3, 3, 680);  -- 咖喱鸡饭

-- ============================================================
-- 9. 插入RECIPE_INGREDIENTS（食谱食材，平均4-5个/菜谱）
-- ============================================================

-- 宫保鸡丁的食材
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (1, 9, 1, 400, '鸡肉切丁', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (1, 11, 1, 60, '烘烤过', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (1, 2, 1, 50, NULL, SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (1, 20, 1, 60, NULL, SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (1, 24, 2, 2, NULL, SYSTIMESTAMP);

-- 番茄鸡蛋面的食材
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (2, 1, 1, 300, '新鲜番茄', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (2, 11, 8, 2, '鸡蛋', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (2, 33, 1, 200, '面条', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (2, 17, 1, 5, '盐', SYSTIMESTAMP);

-- 红烧肉的食材
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (3, 15, 1, 700, '五花肉', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (3, 18, 1, 50, '冰糖', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (3, 19, 3, 100, '酱油', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (3, 24, 1, 30, '料酒', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (3, 3, 1, 20, '生姜', SYSTIMESTAMP);

-- 清蒸鱼的食材
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (4, 16, 1, 500, '新鲜鱼', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (4, 19, 3, 30, '酱油', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (4, 3, 1, 15, '生姜', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (4, 9, 3, 1, '植物油', SYSTIMESTAMP);

-- 麻婆豆腐的食材
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (5, 31, 1, 300, '豆腐', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (5, 21, 1, 30, '豆瓣酱', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (5, 2, 1, 40, '洋葱', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (5, 25, 2, 2, '黑胡椒', SYSTIMESTAMP);

-- 青菜炒蛋的食材
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (6, 8, 1, 200, '菠菜', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (6, 11, 8, 2, '鸡蛋', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (6, 20, 1, 5, '油', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (6, 19, 3, 5, '酱油', SYSTIMESTAMP);

-- 冬瓜排骨汤的食材
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (7, 17, 1, 300, '排骨', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (7, 6, 1, 400, '冬瓜', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (7, 3, 1, 10, '生姜', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (7, 17, 1, 8, '盐', SYSTIMESTAMP);

-- 意大利面的食材
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (8, 33, 1, 200, '面条', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (8, 13, 1, 200, '猪肉', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (8, 1, 1, 250, '番茄', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (8, 22, 1, 50, '番茄酱', SYSTIMESTAMP);

-- 凯撒沙拉的食材
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (9, 5, 1, 200, '生菜', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (9, 11, 8, 1, '鸡蛋', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (9, 25, 6, 1, '黑胡椒', SYSTIMESTAMP);

-- 烤鸡腿的食材
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (10, 10, 1, 400, '鸡腿', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (10, 24, 1, 30, '料酒', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (10, 25, 2, 2, '黑胡椒', SYSTIMESTAMP);

-- 提拉米苏的食材
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (11, 34, 3, 200, '淡奶油', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (11, 18, 1, 100, '糖', SYSTIMESTAMP);

-- 日式味增汤的食材
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (12, 31, 1, 100, '豆腐', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (12, 2, 1, 20, '洋葱', SYSTIMESTAMP);

-- 寿司卷的食材
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (13, 32, 1, 200, '米', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (13, 20, 1, 20, '醋', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (13, 7, 1, 100, '黄瓜', SYSTIMESTAMP);

-- 咖喱鸡饭的食材
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (14, 9, 1, 300, '鸡肉', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (14, 32, 1, 200, '米', SYSTIMESTAMP);
INSERT INTO RECIPE_INGREDIENTS (recipe_id, ingredient_id, unit_id, quantity, notes, added_at)
VALUES (14, 7, 1, 150, '土豆', SYSTIMESTAMP);

COMMIT;

-- ============================================================
-- 10. 插入RECIPE_TAGS（食谱标签）
-- ============================================================

INSERT INTO RECIPE_TAGS (recipe_id, tag_id, added_at)
VALUES (1, 1, SYSTIMESTAMP);  -- 宫保鸡丁 - 快手菜
INSERT INTO RECIPE_TAGS (recipe_id, tag_id, added_at)
VALUES (1, 2, SYSTIMESTAMP);  -- 宫保鸡丁 - 家常菜
INSERT INTO RECIPE_TAGS (recipe_id, tag_id, added_at)
VALUES (1, 3, SYSTIMESTAMP);  -- 宫保鸡丁 - 高蛋白

INSERT INTO RECIPE_TAGS (recipe_id, tag_id, added_at)
VALUES (2, 1, SYSTIMESTAMP);  -- 番茄鸡蛋面 - 快手菜
INSERT INTO RECIPE_TAGS (recipe_id, tag_id, added_at)
VALUES (2, 12, SYSTIMESTAMP);  -- 番茄鸡蛋面 - 面食

INSERT INTO RECIPE_TAGS (recipe_id, tag_id, added_at)
VALUES (3, 2, SYSTIMESTAMP);  -- 红烧肉 - 家常菜
INSERT INTO RECIPE_TAGS (recipe_id, tag_id, added_at)
VALUES (3, 3, SYSTIMESTAMP);  -- 红烧肉 - 高蛋白

INSERT INTO RECIPE_TAGS (recipe_id, tag_id, added_at)
VALUES (4, 7, SYSTIMESTAMP);  -- 清蒸鱼 - 清蒸
INSERT INTO RECIPE_TAGS (recipe_id, tag_id, added_at)
VALUES (4, 4, SYSTIMESTAMP);  -- 清蒸鱼 - 低脂

INSERT INTO RECIPE_TAGS (recipe_id, tag_id, added_at)
VALUES (5, 8, SYSTIMESTAMP);  -- 麻婆豆腐 - 炒制
INSERT INTO RECIPE_TAGS (recipe_id, tag_id, added_at)
VALUES (5, 6, SYSTIMESTAMP);  -- 麻婆豆腐 - 素食

INSERT INTO RECIPE_TAGS (recipe_id, tag_id, added_at)
VALUES (6, 1, SYSTIMESTAMP);  -- 青菜炒蛋 - 快手菜
INSERT INTO RECIPE_TAGS (recipe_id, tag_id, added_at)
VALUES (6, 5, SYSTIMESTAMP);  -- 青菜炒蛋 - 儿童食品

INSERT INTO RECIPE_TAGS (recipe_id, tag_id, added_at)
VALUES (7, 10, SYSTIMESTAMP);  -- 冬瓜排骨汤 - 汤类

INSERT INTO RECIPE_TAGS (recipe_id, tag_id, added_at)
VALUES (8, 12, SYSTIMESTAMP);  -- 意大利面 - 面食
INSERT INTO RECIPE_TAGS (recipe_id, tag_id, added_at)
VALUES (8, 1, SYSTIMESTAMP);  -- 意大利面 - 快手菜

INSERT INTO RECIPE_TAGS (recipe_id, tag_id, added_at)
VALUES (9, 4, SYSTIMESTAMP);  -- 凯撒沙拉 - 低脂
INSERT INTO RECIPE_TAGS (recipe_id, tag_id, added_at)
VALUES (9, 6, SYSTIMESTAMP);  -- 凯撒沙拉 - 素食

INSERT INTO RECIPE_TAGS (recipe_id, tag_id, added_at)
VALUES (10, 9, SYSTIMESTAMP);  -- 烤鸡腿 - 烤制
INSERT INTO RECIPE_TAGS (recipe_id, tag_id, added_at)
VALUES (10, 3, SYSTIMESTAMP);  -- 烤鸡腿 - 高蛋白

INSERT INTO RECIPE_TAGS (recipe_id, tag_id, added_at)
VALUES (11, 11, SYSTIMESTAMP);  -- 提拉米苏 - 甜点

INSERT INTO RECIPE_TAGS (recipe_id, tag_id, added_at)
VALUES (12, 10, SYSTIMESTAMP);  -- 日式味增汤 - 汤类

INSERT INTO RECIPE_TAGS (recipe_id, tag_id, added_at)
VALUES (13, 1, SYSTIMESTAMP);  -- 寿司卷 - 快手菜

INSERT INTO RECIPE_TAGS (recipe_id, tag_id, added_at)
VALUES (14, 1, SYSTIMESTAMP);  -- 咖喱鸡饭 - 快手菜

select * from RECIPE_TAGS;
COMMIT;

-- ============================================================
-- 11. 插入INGREDIENT_ALLERGENS（食材过敏原）
-- ============================================================

INSERT INTO INGREDIENT_ALLERGENS (ingredient_id, allergen_id) VALUES (11, 2);  -- 花生 - 坚果
INSERT INTO INGREDIENT_ALLERGENS (ingredient_id, allergen_id) VALUES (27, 3);  -- 牛奶 - 乳制品
INSERT INTO INGREDIENT_ALLERGENS (ingredient_id, allergen_id) VALUES (28, 3);  -- 黄油 - 乳制品
INSERT INTO INGREDIENT_ALLERGENS (ingredient_id, allergen_id) VALUES (11, 4);  -- 鸡蛋 - 鸡蛋
INSERT INTO INGREDIENT_ALLERGENS (ingredient_id, allergen_id) VALUES (7, 5);  -- 虾 - 海鲜
INSERT INTO INGREDIENT_ALLERGENS (ingredient_id, allergen_id) VALUES (16, 6);  -- 鱼 - 鱼
INSERT INTO INGREDIENT_ALLERGENS (ingredient_id, allergen_id) VALUES (30, 7);  -- 面粉 - 小麦
-- ============================================================
-- 12. 插入RATINGS（20个真实评价）
-- ============================================================
delete from RATINGS;
DROP SEQUENCE seq_ratings;
CREATE SEQUENCE seq_ratings START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 3, 1, 4.5, '真的很好吃！鸡丁嫩，花生香，唯一不足是有点辣', TRUNC(SYSDATE - 5));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 4, 1, 4.0, '按照食谱做的，家人都喜欢，下次还要做', TRUNC(SYSDATE - 8));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 7, 1, 5.0, '完美！配菜的比例把握得很好，香气十足', TRUNC(SYSDATE - 3));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 3, 2, 5.0, '早餐最爱这个，简单快手，老公和孩子都喜欢', TRUNC(SYSDATE - 2));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 9, 2, 4.5, '首次尝试做面，成功了！番茄酸酸的很开胃', TRUNC(SYSDATE - 6));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 4, 3, 4.8, '红烧肉做得最好吃的一次，软烂入味，真棒！', TRUNC(SYSDATE - 7));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 7, 3, 4.5, '步骤清晰，易于上手，我的第二次做红烧肉成功', TRUNC(SYSDATE - 10));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 3, 4, 4.0, '清蒸很成功，鱼很嫩，健康又美味', TRUNC(SYSDATE - 4));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 6, 4, 4.5, '这个食谱营养很均衡，适合健身餐', TRUNC(SYSDATE - 9));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 4, 5, 4.0, '麻婆豆腐做得不错，麻辣味道很正宗', TRUNC(SYSDATE - 6));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 3, 6, 5.0, '儿子很爱吃，简单易做，营养丰富', TRUNC(SYSDATE - 3));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 4, 7, 4.0, '汤很清甜，家人都喝了两碗', TRUNC(SYSDATE - 5));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 3, 8, 4.5, '意大利面很成功，肉酱香浓', TRUNC(SYSDATE - 2));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 6, 9, 5.0, '完美的健康沙拉，低脂又美味', TRUNC(SYSDATE - 4));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 3, 10, 4.5, '烤鸡腿外脆内嫩，孩子很喜欢', TRUNC(SYSDATE - 7));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 4, 11, 5.0, '提拉米苏太好吃了，甜度刚好', TRUNC(SYSDATE - 1));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 7, 12, 4.0, '日式汤很清爽，适合冬天喝', TRUNC(SYSDATE - 8));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 9, 13, 4.5, '寿司卷很漂亮，虽然第一次卷得不太完美', TRUNC(SYSDATE - 2));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 7, 14, 4.5, '咖喱鸡饭香气扑鼻，下饭超级好吃', TRUNC(SYSDATE - 6));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 8, 1, 4.0, '朋友点名要吃这个，确实好吃', TRUNC(SYSDATE - 9));


delete from RATINGS;
DROP SEQUENCE seq_ratings;
CREATE SEQUENCE seq_ratings START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 3, 1, 4.5, '真的很好吃！鸡丁嫩，花生香，唯一不足是有点辣', TRUNC(SYSDATE - 5));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 4, 1, 4.0, '按照食谱做的，家人都喜欢，下次还要做', TRUNC(SYSDATE - 8));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 7, 1, 5.0, '完美！配菜的比例把握得很好，香气十足', TRUNC(SYSDATE - 3));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 3, 2, 5.0, '早餐最爱这个，简单快手，老公和孩子都喜欢', TRUNC(SYSDATE - 2));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 9, 2, 4.5, '首次尝试做面，成功了！番茄酸酸的很开胃', TRUNC(SYSDATE - 6));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 4, 3, 4.8, '红烧肉做得最好吃的一次，软烂入味，真棒！', TRUNC(SYSDATE - 7));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 7, 3, 4.5, '步骤清晰，易于上手，我的第二次做红烧肉成功', TRUNC(SYSDATE - 10));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 3, 4, 4.0, '清蒸很成功，鱼很嫩，健康又美味', TRUNC(SYSDATE - 4));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 6, 4, 4.5, '这个食谱营养很均衡，适合健身餐', TRUNC(SYSDATE - 9));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 4, 5, 4.0, '麻婆豆腐做得不错，麻辣味道很正宗', TRUNC(SYSDATE - 6));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 3, 6, 5.0, '儿子很爱吃，简单易做，营养丰富', TRUNC(SYSDATE - 3));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 4, 7, 4.0, '汤很清甜，家人都喝了两碗', TRUNC(SYSDATE - 5));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 3, 8, 4.5, '意大利面很成功，肉酱香浓', TRUNC(SYSDATE - 2));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 6, 9, 5.0, '完美的健康沙拉，低脂又美味', TRUNC(SYSDATE - 4));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 3, 10, 4.5, '烤鸡腿外脆内嫩，孩子很喜欢', TRUNC(SYSDATE - 7));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 4, 11, 5.0, '提拉米苏太好吃了，甜度刚好', TRUNC(SYSDATE - 1));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 7, 12, 4.0, '日式汤很清爽，适合冬天喝', TRUNC(SYSDATE - 8));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 9, 13, 4.5, '寿司卷很漂亮，虽然第一次卷得不太完美', TRUNC(SYSDATE - 2));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 7, 14, 4.5, '咖喱鸡饭香气扑鼻，下饭超级好吃', TRUNC(SYSDATE - 6));

INSERT INTO RATINGS (rating_id, user_id, recipe_id, rating_value, review_text, rating_date)
VALUES (seq_ratings.NEXTVAL, 8, 1, 4.0, '朋友点名要吃这个，确实好吃', TRUNC(SYSDATE - 9));

-- ============================================================
-- 13. 插入COMMENTS（12条评论）
-- ============================================================
delete from comments;
DROP SEQUENCE seq_comments;
CREATE SEQUENCE seq_comments START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

INSERT INTO COMMENTS (comment_id, user_id, recipe_id, comment_text, parent_comment_id, created_at, updated_at)
VALUES (seq_comments.NEXTVAL, 3, 1, '请问花生可以用杏仁替代吗？', NULL, TRUNC(SYSDATE - 4), TRUNC(SYSDATE - 4));

INSERT INTO COMMENTS (comment_id, user_id, recipe_id, comment_text, parent_comment_id, created_at, updated_at)
VALUES (seq_comments.NEXTVAL, 2, 1, '可以的，杏仁的香气也很不错，用量可以少一点', 1, TRUNC(SYSDATE - 3), TRUNC(SYSDATE - 3));

INSERT INTO COMMENTS (comment_id, user_id, recipe_id, comment_text, parent_comment_id, created_at, updated_at)
VALUES (seq_comments.NEXTVAL, 4, 2, '有没有其他配菜的建议？', NULL, TRUNC(SYSDATE - 5), TRUNC(SYSDATE - 5));

INSERT INTO COMMENTS (comment_id, user_id, recipe_id, comment_text, parent_comment_id, created_at, updated_at)
VALUES (seq_comments.NEXTVAL, 3, 3, '多久可以吃完一份红烧肉？', NULL, TRUNC(SYSDATE - 6), TRUNC(SYSDATE - 6));

INSERT INTO COMMENTS (comment_id, user_id, recipe_id, comment_text, parent_comment_id, created_at, updated_at)
VALUES (seq_comments.NEXTVAL, 1, 3, '一般两三天内吃完比较好，可以冷藏保存', 4, TRUNC(SYSDATE - 5), TRUNC(SYSDATE - 5));

INSERT INTO COMMENTS (comment_id, user_id, recipe_id, comment_text, parent_comment_id, created_at, updated_at)
VALUES (seq_comments.NEXTVAL, 6, 4, '蒸鱼用什么样的火候最好？', NULL, TRUNC(SYSDATE - 7), TRUNC(SYSDATE - 7));

INSERT INTO COMMENTS (comment_id, user_id, recipe_id, comment_text, parent_comment_id, created_at, updated_at)
VALUES (seq_comments.NEXTVAL, 2, 4, '中火蒸12-15分钟就够了，过度蒸会变老', 6, TRUNC(SYSDATE - 6), TRUNC(SYSDATE - 6));

INSERT INTO COMMENTS (comment_id, user_id, recipe_id, comment_text, parent_comment_id, created_at, updated_at)
VALUES (seq_comments.NEXTVAL, 9, 13, '寿司卷怎样防止散开？', NULL, TRUNC(SYSDATE - 1), TRUNC(SYSDATE - 1));

INSERT INTO COMMENTS (comment_id, user_id, recipe_id, comment_text, parent_comment_id, created_at, updated_at)
VALUES (seq_comments.NEXTVAL, 5, 13, '米要均匀摊平，海苔要新鲜，切刀要锋利并蘸水', 8, TRUNC(SYSDATE), TRUNC(SYSDATE));

INSERT INTO COMMENTS (comment_id, user_id, recipe_id, comment_text, parent_comment_id, created_at, updated_at)
VALUES (seq_comments.NEXTVAL, 4, 6, '小孩喜欢吃这个，简直是完美的儿童菜', NULL, TRUNC(SYSDATE - 2), TRUNC(SYSDATE - 2));

INSERT INTO COMMENTS (comment_id, user_id, recipe_id, comment_text, parent_comment_id, created_at, updated_at)
VALUES (seq_comments.NEXTVAL, 3, 8, '这个番茄肉酱可以冷冻保存吗？', NULL, TRUNC(SYSDATE - 1), TRUNC(SYSDATE - 1));

INSERT INTO COMMENTS (comment_id, user_id, recipe_id, comment_text, parent_comment_id, created_at, updated_at)
VALUES (seq_comments.NEXTVAL, 10, 8, '可以的，冷冻可以保存2-3周，用时解冻即可', 11, TRUNC(SYSDATE), TRUNC(SYSDATE));

delete from comments;
DROP SEQUENCE seq_comments;
CREATE SEQUENCE seq_comments START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

INSERT INTO COMMENTS (comment_id, user_id, recipe_id, comment_text, parent_comment_id, created_at, updated_at)
VALUES (seq_comments.NEXTVAL, 3, 1, '请问花生可以用杏仁替代吗？', NULL, TRUNC(SYSDATE - 4), TRUNC(SYSDATE - 4));

INSERT INTO COMMENTS (comment_id, user_id, recipe_id, comment_text, parent_comment_id, created_at, updated_at)
VALUES (seq_comments.NEXTVAL, 2, 1, '可以的，杏仁的香气也很不错，用量可以少一点', 1, TRUNC(SYSDATE - 3), TRUNC(SYSDATE - 3));

INSERT INTO COMMENTS (comment_id, user_id, recipe_id, comment_text, parent_comment_id, created_at, updated_at)
VALUES (seq_comments.NEXTVAL, 4, 2, '有没有其他配菜的建议？', NULL, TRUNC(SYSDATE - 5), TRUNC(SYSDATE - 5));

INSERT INTO COMMENTS (comment_id, user_id, recipe_id, comment_text, parent_comment_id, created_at, updated_at)
VALUES (seq_comments.NEXTVAL, 3, 3, '多久可以吃完一份红烧肉？', NULL, TRUNC(SYSDATE - 6), TRUNC(SYSDATE - 6));

INSERT INTO COMMENTS (comment_id, user_id, recipe_id, comment_text, parent_comment_id, created_at, updated_at)
VALUES (seq_comments.NEXTVAL, 1, 3, '一般两三天内吃完比较好，可以冷藏保存', 4, TRUNC(SYSDATE - 5), TRUNC(SYSDATE - 5));

INSERT INTO COMMENTS (comment_id, user_id, recipe_id, comment_text, parent_comment_id, created_at, updated_at)
VALUES (seq_comments.NEXTVAL, 6, 4, '蒸鱼用什么样的火候最好？', NULL, TRUNC(SYSDATE - 7), TRUNC(SYSDATE - 7));

INSERT INTO COMMENTS (comment_id, user_id, recipe_id, comment_text, parent_comment_id, created_at, updated_at)
VALUES (seq_comments.NEXTVAL, 2, 4, '中火蒸12-15分钟就够了，过度蒸会变老', 6, TRUNC(SYSDATE - 6), TRUNC(SYSDATE - 6));

INSERT INTO COMMENTS (comment_id, user_id, recipe_id, comment_text, parent_comment_id, created_at, updated_at)
VALUES (seq_comments.NEXTVAL, 9, 13, '寿司卷怎样防止散开？', NULL, TRUNC(SYSDATE - 1), TRUNC(SYSDATE - 1));

INSERT INTO COMMENTS (comment_id, user_id, recipe_id, comment_text, parent_comment_id, created_at, updated_at)
VALUES (seq_comments.NEXTVAL, 5, 13, '米要均匀摊平，海苔要新鲜，切刀要锋利并蘸水', 8, TRUNC(SYSDATE), TRUNC(SYSDATE));

INSERT INTO COMMENTS (comment_id, user_id, recipe_id, comment_text, parent_comment_id, created_at, updated_at)
VALUES (seq_comments.NEXTVAL, 4, 6, '小孩喜欢吃这个，简直是完美的儿童菜', NULL, TRUNC(SYSDATE - 2), TRUNC(SYSDATE - 2));

INSERT INTO COMMENTS (comment_id, user_id, recipe_id, comment_text, parent_comment_id, created_at, updated_at)
VALUES (seq_comments.NEXTVAL, 3, 8, '这个番茄肉酱可以冷冻保存吗？', NULL, TRUNC(SYSDATE - 1), TRUNC(SYSDATE - 1));

INSERT INTO COMMENTS (comment_id, user_id, recipe_id, comment_text, parent_comment_id, created_at, updated_at)
VALUES (seq_comments.NEXTVAL, 10, 8, '可以的，冷冻可以保存2-3周，用时解冻即可', 11, TRUNC(SYSDATE), TRUNC(SYSDATE));


-- ============================================================
-- 14. 插入SAVED_RECIPES（收藏）
-- ============================================================
delete from saved_recipes;
DROP SEQUENCE seq_saved_recipes;
CREATE SEQUENCE seq_saved_recipes START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

INSERT INTO SAVED_RECIPES (saved_recipe_id, user_id, recipe_id, saved_at)
VALUES (seq_saved_recipes.NEXTVAL, 3, 1, TRUNC(SYSDATE - 10));
INSERT INTO SAVED_RECIPES (saved_recipe_id, user_id, recipe_id, saved_at)
VALUES (seq_saved_recipes.NEXTVAL, 3, 2, TRUNC(SYSDATE - 15));
INSERT INTO SAVED_RECIPES (saved_recipe_id, user_id, recipe_id, saved_at)
VALUES (seq_saved_recipes.NEXTVAL, 3, 3, TRUNC(SYSDATE - 12));
INSERT INTO SAVED_RECIPES (saved_recipe_id, user_id, recipe_id, saved_at)
VALUES (seq_saved_recipes.NEXTVAL, 4, 1, TRUNC(SYSDATE - 8));
INSERT INTO SAVED_RECIPES (saved_recipe_id, user_id, recipe_id, saved_at)
VALUES (seq_saved_recipes.NEXTVAL, 4, 3, TRUNC(SYSDATE - 20));
INSERT INTO SAVED_RECIPES (saved_recipe_id, user_id, recipe_id, saved_at)
VALUES (seq_saved_recipes.NEXTVAL, 4, 5, TRUNC(SYSDATE - 7));
INSERT INTO SAVED_RECIPES (saved_recipe_id, user_id, recipe_id, saved_at)
VALUES (seq_saved_recipes.NEXTVAL, 4, 6, TRUNC(SYSDATE - 5));
INSERT INTO SAVED_RECIPES (saved_recipe_id, user_id, recipe_id, saved_at)
VALUES (seq_saved_recipes.NEXTVAL, 6, 4, TRUNC(SYSDATE - 6));
INSERT INTO SAVED_RECIPES (saved_recipe_id, user_id, recipe_id, saved_at)
VALUES (seq_saved_recipes.NEXTVAL, 6, 9, TRUNC(SYSDATE - 9));
INSERT INTO SAVED_RECIPES (saved_recipe_id, user_id, recipe_id, saved_at)
VALUES (seq_saved_recipes.NEXTVAL, 6, 12, TRUNC(SYSDATE - 3));
INSERT INTO SAVED_RECIPES (saved_recipe_id, user_id, recipe_id, saved_at)
VALUES (seq_saved_recipes.NEXTVAL, 7, 14, TRUNC(SYSDATE - 4));
INSERT INTO SAVED_RECIPES (saved_recipe_id, user_id, recipe_id, saved_at)
VALUES (seq_saved_recipes.NEXTVAL, 8, 1, TRUNC(SYSDATE - 11));
INSERT INTO SAVED_RECIPES (saved_recipe_id, user_id, recipe_id, saved_at)
VALUES (seq_saved_recipes.NEXTVAL, 9, 13, TRUNC(SYSDATE - 2));
INSERT INTO SAVED_RECIPES (saved_recipe_id, user_id, recipe_id, saved_at)
VALUES (seq_saved_recipes.NEXTVAL, 10, 11, TRUNC(SYSDATE - 1));

delete from saved_recipes;
DROP SEQUENCE seq_saved_recipes;
CREATE SEQUENCE seq_saved_recipes START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

INSERT INTO SAVED_RECIPES (saved_recipe_id, user_id, recipe_id, saved_at)
VALUES (seq_saved_recipes.NEXTVAL, 3, 1, TRUNC(SYSDATE - 10));
INSERT INTO SAVED_RECIPES (saved_recipe_id, user_id, recipe_id, saved_at)
VALUES (seq_saved_recipes.NEXTVAL, 3, 2, TRUNC(SYSDATE - 15));
INSERT INTO SAVED_RECIPES (saved_recipe_id, user_id, recipe_id, saved_at)
VALUES (seq_saved_recipes.NEXTVAL, 3, 3, TRUNC(SYSDATE - 12));
INSERT INTO SAVED_RECIPES (saved_recipe_id, user_id, recipe_id, saved_at)
VALUES (seq_saved_recipes.NEXTVAL, 4, 1, TRUNC(SYSDATE - 8));
INSERT INTO SAVED_RECIPES (saved_recipe_id, user_id, recipe_id, saved_at)
VALUES (seq_saved_recipes.NEXTVAL, 4, 3, TRUNC(SYSDATE - 20));
INSERT INTO SAVED_RECIPES (saved_recipe_id, user_id, recipe_id, saved_at)
VALUES (seq_saved_recipes.NEXTVAL, 4, 5, TRUNC(SYSDATE - 7));
INSERT INTO SAVED_RECIPES (saved_recipe_id, user_id, recipe_id, saved_at)
VALUES (seq_saved_recipes.NEXTVAL, 4, 6, TRUNC(SYSDATE - 5));
INSERT INTO SAVED_RECIPES (saved_recipe_id, user_id, recipe_id, saved_at)
VALUES (seq_saved_recipes.NEXTVAL, 6, 4, TRUNC(SYSDATE - 6));
INSERT INTO SAVED_RECIPES (saved_recipe_id, user_id, recipe_id, saved_at)
VALUES (seq_saved_recipes.NEXTVAL, 6, 9, TRUNC(SYSDATE - 9));
INSERT INTO SAVED_RECIPES (saved_recipe_id, user_id, recipe_id, saved_at)
VALUES (seq_saved_recipes.NEXTVAL, 6, 12, TRUNC(SYSDATE - 3));
INSERT INTO SAVED_RECIPES (saved_recipe_id, user_id, recipe_id, saved_at)
VALUES (seq_saved_recipes.NEXTVAL, 7, 14, TRUNC(SYSDATE - 4));
INSERT INTO SAVED_RECIPES (saved_recipe_id, user_id, recipe_id, saved_at)
VALUES (seq_saved_recipes.NEXTVAL, 8, 1, TRUNC(SYSDATE - 11));
INSERT INTO SAVED_RECIPES (saved_recipe_id, user_id, recipe_id, saved_at)
VALUES (seq_saved_recipes.NEXTVAL, 9, 13, TRUNC(SYSDATE - 2));
INSERT INTO SAVED_RECIPES (saved_recipe_id, user_id, recipe_id, saved_at)
VALUES (seq_saved_recipes.NEXTVAL, 10, 11, TRUNC(SYSDATE - 1));

-- ============================================================
-- 15. 插入FOLLOWERS（关注）
-- ============================================================
delete from followers;
DROP SEQUENCE seq_followers;
CREATE SEQUENCE seq_followers START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

INSERT INTO FOLLOWERS (user_id, follower_user_id, followed_at)
VALUES (1, 3, TRUNC(SYSDATE - 30));  -- 用户3关注用户1（美食博主）
INSERT INTO FOLLOWERS (user_id, follower_user_id, followed_at)
VALUES (1, 4, TRUNC(SYSDATE - 25));  -- 用户4关注用户1
INSERT INTO FOLLOWERS (user_id, follower_user_id, followed_at)
VALUES (1, 7, TRUNC(SYSDATE - 20));  -- 用户7关注用户1
INSERT INTO FOLLOWERS (user_id, follower_user_id, followed_at)
VALUES (2, 3, TRUNC(SYSDATE - 28));  -- 用户3关注用户2（专业厨师）
INSERT INTO FOLLOWERS (user_id, follower_user_id, followed_at)
VALUES (2, 9, TRUNC(SYSDATE - 15));  -- 用户9关注用户2
INSERT INTO FOLLOWERS (user_id, follower_user_id, followed_at)
VALUES (6, 3, TRUNC(SYSDATE - 35));  -- 用户3关注用户6（营养师）
INSERT INTO FOLLOWERS (user_id, follower_user_id, followed_at)
VALUES (6, 4, TRUNC(SYSDATE - 22));  -- 用户4关注用户6
INSERT INTO FOLLOWERS (user_id, follower_user_id, followed_at)
VALUES (8, 7, TRUNC(SYSDATE - 10));  -- 用户7关注用户8（美食博主）
delete from followers;
DROP SEQUENCE seq_followers;
CREATE SEQUENCE seq_followers START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

INSERT INTO FOLLOWERS (user_id, follower_user_id, followed_at)
VALUES (1, 3, TRUNC(SYSDATE - 30));  -- 用户3关注用户1（美食博主）
INSERT INTO FOLLOWERS (user_id, follower_user_id, followed_at)
VALUES (1, 4, TRUNC(SYSDATE - 25));  -- 用户4关注用户1
INSERT INTO FOLLOWERS (user_id, follower_user_id, followed_at)
VALUES (1, 7, TRUNC(SYSDATE - 20));  -- 用户7关注用户1
INSERT INTO FOLLOWERS (user_id, follower_user_id, followed_at)
VALUES (2, 3, TRUNC(SYSDATE - 28));  -- 用户3关注用户2（专业厨师）
INSERT INTO FOLLOWERS (user_id, follower_user_id, followed_at)
VALUES (2, 9, TRUNC(SYSDATE - 15));  -- 用户9关注用户2
INSERT INTO FOLLOWERS (user_id, follower_user_id, followed_at)
VALUES (6, 3, TRUNC(SYSDATE - 35));  -- 用户3关注用户6（营养师）
INSERT INTO FOLLOWERS (user_id, follower_user_id, followed_at)
VALUES (6, 4, TRUNC(SYSDATE - 22));  -- 用户4关注用户6
INSERT INTO FOLLOWERS (user_id, follower_user_id, followed_at)
VALUES (8, 7, TRUNC(SYSDATE - 10));  -- 用户7关注用户8（美食博主）


-- ============================================================
-- 16. 插入USER_ALLERGIES（用户过敏原）
-- ============================================================

INSERT INTO USER_ALLERGIES (user_id, allergen_id, added_at)
VALUES (3, 1, SYSTIMESTAMP);  -- 用户3 - 花生过敏
INSERT INTO USER_ALLERGIES (user_id, allergen_id, added_at)
VALUES (4, 3, SYSTIMESTAMP);  -- 用户4 - 乳制品过敏
INSERT INTO USER_ALLERGIES (user_id, allergen_id, added_at)
VALUES (7, 5, SYSTIMESTAMP);  -- 用户7 - 海鲜过敏
INSERT INTO USER_ALLERGIES (user_id, allergen_id, added_at)
VALUES (9, 7, SYSTIMESTAMP);  -- 用户9 - 小麦过敏
INSERT INTO USER_ALLERGIES (user_id, allergen_id, added_at)
VALUES (10, 2, SYSTIMESTAMP);  -- 用户10 - 坚果过敏

COMMIT;

-- ============================================================
-- 阶段4：个人管理数据
-- ============================================================

-- ============================================================
-- 17. 插入RECIPE_COLLECTIONS（食谱清单）
-- ============================================================
delete from RECIPE_COLLECTIONS;
DROP SEQUENCE seq_recipe_collections;
CREATE SEQUENCE seq_recipe_collections START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

INSERT INTO RECIPE_COLLECTIONS (collection_id, user_id, collection_name, description, is_public, created_at, updated_at)
VALUES (seq_recipe_collections.NEXTVAL, 1, '快手晚餐', '30分钟内能做好的晚餐菜谱，上班族必备', 'Y', TRUNC(SYSDATE - 60), TRUNC(SYSDATE - 10));

INSERT INTO RECIPE_COLLECTIONS (collection_id, user_id, collection_name, description, is_public, created_at, updated_at)
VALUES (seq_recipe_collections.NEXTVAL, 4, '儿童食谱', '营养均衡，适合小朋友食用的菜谱', 'Y', TRUNC(SYSDATE - 50), TRUNC(SYSDATE - 5));

INSERT INTO RECIPE_COLLECTIONS (collection_id, user_id, collection_name, description, is_public, created_at, updated_at)
VALUES (seq_recipe_collections.NEXTVAL, 6, '健康菜谱', '低脂低热量，适合健身和减肥人士', 'Y', TRUNC(SYSDATE - 40), TRUNC(SYSDATE - 8));
delete from RECIPE_COLLECTIONS;
DROP SEQUENCE seq_recipe_collections;
CREATE SEQUENCE seq_recipe_collections START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

INSERT INTO RECIPE_COLLECTIONS (collection_id, user_id, collection_name, description, is_public, created_at, updated_at)
VALUES (seq_recipe_collections.NEXTVAL, 1, '快手晚餐', '30分钟内能做好的晚餐菜谱，上班族必备', 'Y', TRUNC(SYSDATE - 60), TRUNC(SYSDATE - 10));

INSERT INTO RECIPE_COLLECTIONS (collection_id, user_id, collection_name, description, is_public, created_at, updated_at)
VALUES (seq_recipe_collections.NEXTVAL, 4, '儿童食谱', '营养均衡，适合小朋友食用的菜谱', 'Y', TRUNC(SYSDATE - 50), TRUNC(SYSDATE - 5));

INSERT INTO RECIPE_COLLECTIONS (collection_id, user_id, collection_name, description, is_public, created_at, updated_at)
VALUES (seq_recipe_collections.NEXTVAL, 6, '健康菜谱', '低脂低热量，适合健身和减肥人士', 'Y', TRUNC(SYSDATE - 40), TRUNC(SYSDATE - 8));

-- ============================================================
-- 18. 插入COLLECTION_RECIPES（清单食谱）
-- ============================================================

-- 快手晚餐清单
INSERT INTO COLLECTION_RECIPES (collection_id, recipe_id, added_at)
VALUES (1, 1, TRUNC(SYSDATE - 55));  -- 宫保鸡丁
INSERT INTO COLLECTION_RECIPES (collection_id, recipe_id, added_at)
VALUES (1, 2, TRUNC(SYSDATE - 50));  -- 番茄鸡蛋面
INSERT INTO COLLECTION_RECIPES (collection_id, recipe_id, added_at)
VALUES (1, 5, TRUNC(SYSDATE - 45));  -- 麻婆豆腐
INSERT INTO COLLECTION_RECIPES (collection_id, recipe_id, added_at)
VALUES (1, 8, TRUNC(SYSDATE - 40));  -- 意大利面
INSERT INTO COLLECTION_RECIPES (collection_id, recipe_id, added_at)
VALUES (1, 14, TRUNC(SYSDATE - 35));  -- 咖喱鸡饭

-- 儿童食谱清单
INSERT INTO COLLECTION_RECIPES (collection_id, recipe_id, added_at)
VALUES (2, 2, TRUNC(SYSDATE - 48));  -- 番茄鸡蛋面
INSERT INTO COLLECTION_RECIPES (collection_id, recipe_id, added_at)
VALUES (2, 6, TRUNC(SYSDATE - 42));  -- 青菜炒蛋
INSERT INTO COLLECTION_RECIPES (collection_id, recipe_id, added_at)
VALUES (2, 10, TRUNC(SYSDATE - 38));  -- 烤鸡腿
INSERT INTO COLLECTION_RECIPES (collection_id, recipe_id, added_at)
VALUES (2, 7, TRUNC(SYSDATE - 32));  -- 冬瓜排骨汤

-- 健康菜谱清单
INSERT INTO COLLECTION_RECIPES (collection_id, recipe_id, added_at)
VALUES (3, 4, TRUNC(SYSDATE - 35));  -- 清蒸鱼
INSERT INTO COLLECTION_RECIPES (collection_id, recipe_id, added_at)
VALUES (3, 9, TRUNC(SYSDATE - 28));  -- 凯撒沙拉
INSERT INTO COLLECTION_RECIPES (collection_id, recipe_id, added_at)
VALUES (3, 12, TRUNC(SYSDATE - 20));  -- 日式味增汤

COMMIT;

-- ============================================================
-- 19. 插入SHOPPING_LISTS（购物清单）
-- ============================================================
delete from shopping_lists;
DROP SEQUENCE seq_shopping_lists;
CREATE SEQUENCE seq_shopping_lists START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

INSERT INTO SHOPPING_LISTS (list_id, user_id, list_name, created_at, updated_at)
VALUES (seq_shopping_lists.NEXTVAL, 3, '周末烹饪计划采购', TRUNC(SYSDATE - 3), TRUNC(SYSDATE - 1));

INSERT INTO SHOPPING_LISTS (list_id, user_id, list_name, created_at, updated_at)
VALUES (seq_shopping_lists.NEXTVAL, 4, '家庭聚餐食材', TRUNC(SYSDATE - 7), TRUNC(SYSDATE - 2));
delete from shopping_lists;
DROP SEQUENCE seq_shopping_lists;
CREATE SEQUENCE seq_shopping_lists START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

INSERT INTO SHOPPING_LISTS (list_id, user_id, list_name, created_at, updated_at)
VALUES (seq_shopping_lists.NEXTVAL, 3, '周末烹饪计划采购', TRUNC(SYSDATE - 3), TRUNC(SYSDATE - 1));

INSERT INTO SHOPPING_LISTS (list_id, user_id, list_name, created_at, updated_at)
VALUES (seq_shopping_lists.NEXTVAL, 4, '家庭聚餐食材', TRUNC(SYSDATE - 7), TRUNC(SYSDATE - 2));

-- ============================================================
-- 20. 插入SHOPPING_LIST_ITEMS（购物清单项目）
-- ============================================================

-- 清单1的项目
INSERT INTO SHOPPING_LIST_ITEMS (list_id, ingredient_id, quantity, unit_id, is_checked, added_at)
VALUES (1, 9, 500, 1, 'Y', TRUNC(SYSDATE - 2));  -- 鸡肉
INSERT INTO SHOPPING_LIST_ITEMS (list_id, ingredient_id, quantity, unit_id, is_checked, added_at)
VALUES (1, 11, 100, 1, 'Y', TRUNC(SYSDATE - 2));  -- 花生米
INSERT INTO SHOPPING_LIST_ITEMS (list_id, ingredient_id, quantity, unit_id, is_checked, added_at)
VALUES (1, 1, 300, 1, 'Y', TRUNC(SYSDATE - 2));  -- 番茄
INSERT INTO SHOPPING_LIST_ITEMS (list_id, ingredient_id, quantity, unit_id, is_checked, added_at)
VALUES (1, 31, 400, 1, 'N', TRUNC(SYSDATE - 1));  -- 豆腐
INSERT INTO SHOPPING_LIST_ITEMS (list_id, ingredient_id, quantity, unit_id, is_checked, added_at)
VALUES (1, 33, 400, 1, 'N', TRUNC(SYSDATE - 1));  -- 面条
INSERT INTO SHOPPING_LIST_ITEMS (list_id, ingredient_id, quantity, unit_id, is_checked, added_at)
VALUES (1, 20, 100, 3, 'Y', TRUNC(SYSDATE - 2));  -- 油
INSERT INTO SHOPPING_LIST_ITEMS (list_id, ingredient_id, quantity, unit_id, is_checked, added_at)
VALUES (1, 19, 100, 3, 'Y', TRUNC(SYSDATE - 2));  -- 酱油
INSERT INTO SHOPPING_LIST_ITEMS (list_id, ingredient_id, quantity, unit_id, is_checked, added_at)
VALUES (1, 17, 200, 1, 'N', TRUNC(SYSDATE - 1));  -- 盐
INSERT INTO SHOPPING_LIST_ITEMS (list_id, ingredient_id, quantity, unit_id, is_checked, added_at)
VALUES (1, 3, 50, 1, 'N', TRUNC(SYSDATE));  -- 大蒜

-- 清单2的项目
INSERT INTO SHOPPING_LIST_ITEMS (list_id, ingredient_id, quantity, unit_id, is_checked, added_at)
VALUES (2, 15, 1, 10, 'Y', TRUNC(SYSDATE - 6));  -- 五花肉
INSERT INTO SHOPPING_LIST_ITEMS (list_id, ingredient_id, quantity, unit_id, is_checked, added_at)
VALUES (2, 18, 100, 1, 'Y', TRUNC(SYSDATE - 6));  -- 糖
INSERT INTO SHOPPING_LIST_ITEMS (list_id, ingredient_id, quantity, unit_id, is_checked, added_at)
VALUES (2, 21, 50, 1, 'Y', TRUNC(SYSDATE - 6));  -- 豆瓣酱
INSERT INTO SHOPPING_LIST_ITEMS (list_id, ingredient_id, quantity, unit_id, is_checked, added_at)
VALUES (2, 2, 200, 1, 'Y', TRUNC(SYSDATE - 6));  -- 洋葱
INSERT INTO SHOPPING_LIST_ITEMS (list_id, ingredient_id, quantity, unit_id, is_checked, added_at)
VALUES (2, 24, 50, 3, 'Y', TRUNC(SYSDATE - 6));  -- 料酒
INSERT INTO SHOPPING_LIST_ITEMS (list_id, ingredient_id, quantity, unit_id, is_checked, added_at)
VALUES (2, 3, 30, 1, 'Y', TRUNC(SYSDATE - 6));  -- 生姜

COMMIT;

-- ============================================================
-- 21. 插入MEAL_PLANS（膳食计划）
-- ============================================================
delete from MEAL_PLANS;
DROP SEQUENCE seq_meal_plans;
CREATE SEQUENCE seq_meal_plans START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

INSERT INTO MEAL_PLANS (plan_id, user_id, plan_name, description, start_date, end_date, is_public, created_at, updated_at)
VALUES (seq_meal_plans.NEXTVAL, 6, '7日健康膳食计划', '营养均衡，低脂健康，适合健身爱好者', TRUNC(SYSDATE), TRUNC(SYSDATE) + 6, 'Y', TRUNC(SYSDATE - 10), TRUNC(SYSDATE - 2));

INSERT INTO MEAL_PLANS (plan_id, user_id, plan_name, description, start_date, end_date, is_public, created_at, updated_at)
VALUES (seq_meal_plans.NEXTVAL, 4, '本周家庭菜单', '家常菜，家人都喜欢，营养丰富', TRUNC(SYSDATE), TRUNC(SYSDATE) + 6, 'Y', TRUNC(SYSDATE - 5), TRUNC(SYSDATE - 1));
delete from MEAL_PLANS;
DROP SEQUENCE seq_meal_plans;
CREATE SEQUENCE seq_meal_plans START WITH 1 INCREMENT BY 1 NOCACHE ORDER;

INSERT INTO MEAL_PLANS (plan_id, user_id, plan_name, description, start_date, end_date, is_public, created_at, updated_at)
VALUES (seq_meal_plans.NEXTVAL, 6, '7日健康膳食计划', '营养均衡，低脂健康，适合健身爱好者', TRUNC(SYSDATE), TRUNC(SYSDATE) + 6, 'Y', TRUNC(SYSDATE - 10), TRUNC(SYSDATE - 2));

INSERT INTO MEAL_PLANS (plan_id, user_id, plan_name, description, start_date, end_date, is_public, created_at, updated_at)
VALUES (seq_meal_plans.NEXTVAL, 4, '本周家庭菜单', '家常菜，家人都喜欢，营养丰富', TRUNC(SYSDATE), TRUNC(SYSDATE) + 6, 'Y', TRUNC(SYSDATE - 5), TRUNC(SYSDATE - 1));


-- ============================================================
-- 22. 插入MEAL_PLAN_ENTRIES（膳食计划条目）
-- ============================================================

-- 7日健康膳食计划（plan_id=1）
INSERT INTO MEAL_PLAN_ENTRIES (plan_id, recipe_id, meal_date, meal_type, notes, added_at)
VALUES (1, 4, TRUNC(SYSDATE), 'lunch', '清蒸鱼，低脂高蛋白', TRUNC(SYSDATE - 8));

INSERT INTO MEAL_PLAN_ENTRIES (plan_id, recipe_id, meal_date, meal_type, notes, added_at)
VALUES (1, 9, TRUNC(SYSDATE), 'dinner', '凯撒沙拉，新鲜清爽', TRUNC(SYSDATE - 8));

INSERT INTO MEAL_PLAN_ENTRIES (plan_id, recipe_id, meal_date, meal_type, notes, added_at)
VALUES (1, 12, TRUNC(SYSDATE) + 1, 'breakfast', '日式汤，清淡营养', TRUNC(SYSDATE - 7));

INSERT INTO MEAL_PLAN_ENTRIES (plan_id, recipe_id, meal_date, meal_type, notes, added_at)
VALUES (1, 4, TRUNC(SYSDATE) + 1, 'lunch', '清蒸鱼，常换花样', TRUNC(SYSDATE - 7));

INSERT INTO MEAL_PLAN_ENTRIES (plan_id, recipe_id, meal_date, meal_type, notes, added_at)
VALUES (1, 6, TRUNC(SYSDATE) + 2, 'breakfast', '青菜炒蛋，简单快手', TRUNC(SYSDATE - 6));

INSERT INTO MEAL_PLAN_ENTRIES (plan_id, recipe_id, meal_date, meal_type, notes, added_at)
VALUES (1, 10, TRUNC(SYSDATE) + 2, 'lunch', '烤鸡腿，高蛋白', TRUNC(SYSDATE - 6));

INSERT INTO MEAL_PLAN_ENTRIES (plan_id, recipe_id, meal_date, meal_type, notes, added_at)
VALUES (1, 9, TRUNC(SYSDATE) + 3, 'lunch', '凯撒沙拉，健康首选', TRUNC(SYSDATE - 5));

-- 本周家庭菜单（plan_id=2）
INSERT INTO MEAL_PLAN_ENTRIES (plan_id, recipe_id, meal_date, meal_type, notes, added_at)
VALUES (2, 2, TRUNC(SYSDATE), 'breakfast', '早饭简单快手', TRUNC(SYSDATE - 3));

INSERT INTO MEAL_PLAN_ENTRIES (plan_id, recipe_id, meal_date, meal_type, notes, added_at)
VALUES (2, 1, TRUNC(SYSDATE), 'lunch', '午饭家人都喜欢', TRUNC(SYSDATE - 3));

INSERT INTO MEAL_PLAN_ENTRIES (plan_id, recipe_id, meal_date, meal_type, notes, added_at)
VALUES (2, 3, TRUNC(SYSDATE), 'dinner', '晚饭硬菜', TRUNC(SYSDATE - 3));

INSERT INTO MEAL_PLAN_ENTRIES (plan_id, recipe_id, meal_date, meal_type, notes, added_at)
VALUES (2, 6, TRUNC(SYSDATE) + 1, 'breakfast', '儿子最爱', TRUNC(SYSDATE - 2));

INSERT INTO MEAL_PLAN_ENTRIES (plan_id, recipe_id, meal_date, meal_type, notes, added_at)
VALUES (2, 7, TRUNC(SYSDATE) + 1, 'lunch', '清汤营养', TRUNC(SYSDATE - 2));

INSERT INTO MEAL_PLAN_ENTRIES (plan_id, recipe_id, meal_date, meal_type, notes, added_at)
VALUES (2, 5, TRUNC(SYSDATE) + 2, 'dinner', '川菜开胃', TRUNC(SYSDATE - 1));

COMMIT;
