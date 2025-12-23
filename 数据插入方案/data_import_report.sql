-- 1. 插入USERS（50个用户）

INSERT INTO USERS (user_id, username, email, password_hash, first_name, last_name, bio, profile_image, join_date, last_login, account_status,  total_followers, total_recipes, created_at, updated_at)
VALUES (seq_users.NEXTVAL, 'admin', 'admin@allrecipes.com', 'hash_admin_123', 'Admin', 'User', '系统管理员', NULL, TRUNC(SYSDATE - 365), TRUNC(SYSDATE - 1), 'active', 0, 0, SYSTIMESTAMP, SYSTIMESTAMP);

INSERT INTO USERS (user_id, username, email, password_hash, first_name, last_name, bio, profile_image, join_date, last_login, account_status, total_followers, total_recipes, created_at, updated_at)
SELECT seq_users.NEXTVAL, 'chef_master_' || LPAD(i, 3, '0'), 'chef.master.' || LPAD(i, 3, '0') || '@allrecipes.com', 'hash_chef_' || i, 'Chef', 'Master' || i, '专业厨师，专注' || CASE MOD(i, 3) WHEN 0 THEN '中式烹饪' WHEN 1 THEN '西餐烹饪' ELSE '日式料理' END, NULL, TRUNC(SYSDATE - 300 + MOD(i*11, 200)), TRUNC(SYSDATE - MOD(i*7, 30)), 'active', 0, 0, SYSTIMESTAMP, SYSTIMESTAMP
FROM (SELECT LEVEL i FROM DUAL CONNECT BY LEVEL <= 12);

INSERT INTO USERS (user_id, username, email, password_hash, first_name, last_name, bio, profile_image, join_date, last_login, account_status, total_followers, total_recipes, created_at, updated_at)
SELECT seq_users.NEXTVAL, 'foodblogger_' || LPAD(i, 3, '0'), 'foodblog.' || LPAD(i, 3, '0') || '@allrecipes.com', 'hash_blog_' || i, 'Food', 'Blogger' || i, '美食博主，粉丝数' || (1000 + i*100), NULL, TRUNC(SYSDATE - 250 + MOD(i*13, 150)), TRUNC(SYSDATE - MOD(i*3, 15)), 'active', 0, 0, SYSTIMESTAMP, SYSTIMESTAMP
FROM (SELECT LEVEL i FROM DUAL CONNECT BY LEVEL <= 8);

INSERT INTO USERS (user_id, username, email, password_hash, first_name, last_name, bio, profile_image, join_date, last_login, account_status, total_followers, total_recipes, created_at, updated_at)
SELECT seq_users.NEXTVAL, 'user_common_' || LPAD(i, 3, '0'), 'user.common.' || LPAD(i, 3, '0') || '@allrecipes.com', 'hash_user_' || i, 'User', 'Common' || i, '烹饪爱好者，分享日常美食', NULL, TRUNC(SYSDATE - 180 + MOD(i*17, 100)), TRUNC(SYSDATE - MOD(i*5, 25)), CASE WHEN MOD(i, 12) = 0 THEN 'inactive' ELSE 'active' END, 0, 0, SYSTIMESTAMP, SYSTIMESTAMP
FROM (SELECT LEVEL i FROM DUAL CONNECT BY LEVEL <= 20);


-- 2. 插入UNITS（15个单位）

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


-- 3. 插入ALLERGENS（10个过敏原）

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


-- 4. 插入TAGS（20个标签）

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


-- 5. 插入INGREDIENTS（100个食材）

Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (2,'番茄','蔬菜','新鲜番茄，富含番茄红�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (3,'黄瓜','蔬菜','清爽爽脆的夏日蔬�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (4,'洋葱','蔬菜','提味的调味蔬�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (5,'大蒜','蔬菜','香味十足的调味料',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (6,'胡萝�?,'蔬菜','富含β胡萝卜素',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (7,'土豆','蔬菜','淀粉丰富的根茎蔬菜',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (8,'生菜','蔬菜','爽脆的沙拉菜',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (9,'甘蓝','蔬菜','营养丰富的卷心菜',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (10,'菠菜','蔬菜','含铁丰富的绿叶菜',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (11,'西兰�?,'蔬菜','十字花科蔬菜，含硫苷',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (12,'青豆','蔬菜','嫩豆�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (13,'辣椒','蔬菜','增添风味和营�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (14,'南瓜','蔬菜','秋季应季蔬菜',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (15,'茄子','蔬菜','紫色蔬菜，含花青�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (16,'冬瓜','蔬菜','清热利湿的蔬�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (17,'苦瓜','蔬菜','清苦甘甜',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (18,'冬笋','蔬菜','春笋的冬季版�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (19,'香菇','蔬菜','营养丰富的菌�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (20,'口蘑','蔬菜','白色蘑菇',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (21,'木�?,'蔬菜','黑色菌类，含胶质',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (22,'豌豆','蔬菜','春季豆类',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (23,'玉米','蔬菜','黄色的谷物蔬�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (24,'芹菜','蔬菜','低热量蔬�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (25,'萝卜','蔬菜','十字花科根菜',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (26,'山药','蔬菜','淀粉含量高',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (27,'鸡肉','肉类','低脂肉类',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (28,'鸡腿','肉类','鸡腿�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (29,'鸡翅','肉类','鸡翅',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (30,'鸡胸','肉类','低脂高蛋�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (31,'五花�?,'肉类','猪肉中脂肪较多的部分',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (32,'瘦肉','肉类','猪肉中的瘦肉部分',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (33,'排骨','肉类','带骨的肋�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (34,'猪肝','肉类','富含铁和维生�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (35,'牛肉','肉类','营养丰富的红�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (36,'牛腩','肉类','牛肉的腹�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (37,'牛排','肉类','高档牛肉',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (38,'梅花�?,'肉类','牛肉的肩胛部�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (39,'羊肉','肉类','温阳补气',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (40,'羊腿','肉类','羊肉的腿�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (41,'羊排','肉类','羊的肋骨',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (42,'�?,'肉类','海鲜，低脂高蛋白',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (43,'�?,'肉类','白肉鱼类',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (44,'三文�?,'肉类','含丰富omega-3脂肪�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (45,'�?,'肉类','海鲜，美味营�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (46,'贝类','肉类','海鲜贝类',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (47,'�?,'调味�?,'基础调味�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (48,'�?,'调味�?,'甜味来源',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (49,'酱油','调味�?,'传统调味�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (50,'�?,'调味�?,'酸味来源',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (51,'�?,'调味�?,'烹饪用油',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (52,'植物�?,'调味�?,'植物类烹饪油',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (53,'辣椒�?,'调味�?,'香辣调味',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (54,'咖喱�?,'调味�?,'香料混合',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (55,'孜然','调味�?,'香料',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (56,'香叶','调味�?,'烹饪香料',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (57,'八角','调味�?,'香料，八角形',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (58,'黄酒','调味�?,'烹饪用酒',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (59,'豆瓣�?,'调味�?,'咸味酱料',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (60,'番茄�?,'调味�?,'番茄制品',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (61,'味精','调味�?,'鲜味增强�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (62,'牛奶','乳制�?,'新鲜牛奶',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (63,'黄油','乳制�?,'乳脂提取',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (64,'奶酪','乳制�?,'发酵乳制�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (65,'酸奶','乳制�?,'益生菌乳制品',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (66,'淡奶�?,'乳制�?,'烹饪用奶�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (67,'牛奶�?,'乳制�?,'干制牛奶',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (68,'炼乳','乳制�?,'浓缩牛奶',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (69,'马苏里拉奶酪','乳制�?,'披萨常用',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (70,'帕玛森芝�?,'乳制�?,'意大利奶�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (71,'羊奶','乳制�?,'山羊�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (87,'鸡蛋','其他','优质蛋白',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (88,'面包','其他','烘焙食品',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (89,'巧克�?,'其他','甜味�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (90,'果酱','其他','果实制品',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (91,'蜂蜜','其他','天然甜味�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (92,'坚果','其他','营养零食',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (93,'葡萄�?,'其他','干果',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (94,'腰果','其他','坚果',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (95,'杏仁','其他','坚果',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (96,'松子','其他','坚果',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (97,'香草�?,'其他','烘焙香料',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (98,'肉桂','其他','香料�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (99,'姜粉','其他','香料�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (100,'黑胡�?,'其他','香料',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (101,'白胡�?,'其他','香料',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (102,'白米','谷物','日常主食',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (103,'黑米','谷物','营养米类',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (104,'糯米','谷物','粘性米',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (105,'面粉','谷物','小麦�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (106,'面条','谷物','面食',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (107,'馄饨�?,'谷物','馄饨制作�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (108,'饺子�?,'谷物','饺子制作�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (109,'燕麦','谷物','燕麦粥原�?,SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (110,'大豆','谷物','豆类谷物',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (111,'绿豆','谷物','豆类',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (112,'红豆','谷物','豆类',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (113,'黑豆','谷物','豆类',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (114,'花生','谷物','坚果豆类',SYSTIMESTAMP);
Insert into INGREDIENTS (INGREDIENT_ID,INGREDIENT_NAME,CATEGORY,DESCRIPTION,CREATED_AT) values (115,'芝麻','谷物','油料作物',SYSTIMESTAMP);


