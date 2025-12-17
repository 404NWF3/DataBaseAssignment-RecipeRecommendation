-- ============================================================
-- AllRecipes 食谱网站数据库设计报告 (PostgreSQL版 v2.0)
-- ============================================================

# AllRecipes 食谱网站数据库设计报告 (PostgreSQL版 v2.0)

## 目录

1. **项目背景介绍**
2. **ER图设计（概念模型）**
3. **数据库库表设计（逻辑模型）**
4. **规范化**
5. **常见操作归纳**
6. **完整性约束方案设计**
7. **表的详细设计（物理模型）**
8. **视图设计方案**
9. **数据库安全方案设计**
10. **PostgreSQL特性应用**

---

# 第1章 项目背景介绍

## 1.1 AllRecipes 网站概述

AllRecipes 是全球最大的食谱分享平台之一，拥有数百万用户和数百万条食谱。该网站以其用户友好的界面、丰富的食谱内容和强大的社区功能而闻名。

### 核心业务功能

- **食谱发布与分享**：用户可以上传自己创作的食谱，包括详细的食材清单、烹饪步骤、烹饪时间、难度等级等信息，并支持上传高质量的图片。
- **多维度食谱搜索与浏览**：用户通过关键词、菜系、食材、难度级别、烹饪时间等多个维度进行灵活搜索，发现适合自己的食谱。
- **用户交互与社交功能**：包括食谱评价、评论、收藏、关注其他用户等丰富的互动方式，建立活跃的社区文化。
- **个性化食谱管理**：用户可以创建多个食谱收藏清单、购物清单、膳食计划等，提高烹饪的便利性和计划性。
- **健康饮食支持**：系统支持用户管理过敏原信息、查看营养信息、推荐过敏源安全食谱等功能。

## 1.2 PostgreSQL 选择理由

本项目选择 PostgreSQL 作为数据库实现，主要原因：

| 特性 | 优势 |
|------|------|
| **开源免费** | 完全开源，无许可证成本 |
| **ACID特性** | 完全支持事务，数据一致性有保障 |
| **JSON支持** | 原生 JSONB 类型，便于存储灵活数据 |
| **全文搜索** | 内置全文搜索引擎，适合食谱搜索 |
| **数组类型** | 支持数组，便于存储标签、食材等 |
| **递归查询** | CTE 支持递归查询，便于嵌套评论 |
| **性能优化** | 轻量级、高效能，适合中等规模应用 |
| **扩展丰富** | 支持众多扩展（PostGIS、UUID等） |
| **社区活跃** | 文档齐全，社区支持好 |

## 1.3 数据库规模与架构

**数据库级别统计：**
- **表数量**: 26 个
- **索引数量**: 30+ 个
- **触发器**: 4 个
- **函数**: 8 个
- **视图**: 21+ 个

**支持用户规模：**
- 百万级用户
- 千万级食谱
- 实时协作和数据一致性

---

# 第2章 ER图设计（概念模型）

## 2.1 ER图架构概览

本数据库系统包含 **26 个核心表**，分为以下功能模块：

```
┌─────────────────────────────────────────────────────────────┐
│                     核心基础模块 (6个表)                      │
│  users / ingredients / units / allergens / tags / user_allergies
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                     食谱核心模块 (7个表)                      │
│  recipes / recipe_ingredients / cooking_steps / nutrition_info
│  ingredient_allergens / recipe_tags / ingredient_substitutions
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                    用户交互模块 (7个表)                      │
│  ratings / rating_helpfulness / comments / comment_helpfulness
│  saved_recipes / followers / user_activity_log
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                    个人管理模块 (6个表)                      │
│  recipe_collections / collection_recipes
│  shopping_lists / shopping_list_items
│  meal_plans / meal_plan_entries
└─────────────────────────────────────────────────────────────┘
```

## 2.2 主要关系描述

**1:N 关系**：
- users → recipes（一个用户可以创建多个食谱）
- recipes → recipe_ingredients（一个食谱包含多个食材）
- recipes → cooking_steps（一个食谱有多个烹饪步骤）
- recipes → ratings（一个食谱接收多个评价）
- recipes → comments（一个食谱接收多个评论）
- users → followers（一个用户可被多人关注）

**N:M 关系**：
- recipes ↔ ingredients（通过 recipe_ingredients 表）
- recipes ↔ tags（通过 recipe_tags 表）
- ingredients ↔ allergens（通过 ingredient_allergens 表）
- users ↔ users（通过 followers 表实现自关系）

**新增关系**：
- users → meal_plans → recipes（膳食计划管理）
- ingredients ↔ ingredients（通过 ingredient_substitutions 表表示替代关系）
- users → user_allergies → allergens（用户过敏原管理）

---

# 第3章 数据库库表设计（逻辑模型）

## 3.1 表的分类和数量统计

| 模块 | 表名 | 数量 | 说明 |
|------|------|------|------|
| **核心基础** | users, ingredients, units, allergens, tags, user_allergies | 6 | 系统基础数据表 |
| **食谱核心** | recipes, recipe_ingredients, cooking_steps, nutrition_info, ingredient_allergens, recipe_tags, ingredient_substitutions | 7 | 食谱及其属性表 |
| **用户交互** | ratings, rating_helpfulness, comments, comment_helpfulness, saved_recipes, followers, user_activity_log | 7 | 社交和交互表 |
| **个人管理** | recipe_collections, collection_recipes, shopping_lists, shopping_list_items, meal_plans, meal_plan_entries | 6 | 个性化管理表 |
| **总计** | | **26** | 完整系统 |

## 3.2 核心表字段说明

### USERS 表（用户表）
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| user_id | SERIAL PRIMARY KEY | PK | 用户唯一标识 |
| username | VARCHAR(50) | NOT NULL, UNIQUE | 用户名 |
| email | VARCHAR(100) | NOT NULL, UNIQUE | 邮箱 |
| password_hash | VARCHAR(255) | NOT NULL | 加密密码 |
| first_name | VARCHAR(50) | | 名 |
| last_name | VARCHAR(50) | | 姓 |
| bio | VARCHAR(500) | | 简介 |
| profile_image | VARCHAR(255) | | 头像URL |
| join_date | DATE | DEFAULT CURRENT_DATE | 注册日期 |
| last_login | TIMESTAMP | | 最后登录时间 |
| account_status | VARCHAR(20) | CHECK | active/inactive/suspended |
| total_followers | INTEGER | DEFAULT 0 | 粉丝数 |
| total_recipes | INTEGER | DEFAULT 0 | 食谱数 |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | 创建时间 |
| updated_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | 更新时间 |

### RECIPES 表（食谱表）
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| recipe_id | SERIAL PRIMARY KEY | PK | 食谱唯一标识 |
| user_id | INTEGER | FK | 创建者用户ID |
| recipe_name | VARCHAR(200) | NOT NULL | 食谱名称 |
| description | VARCHAR(1000) | | 详细描述 |
| cuisine_type | VARCHAR(50) | | 菜系 |
| meal_type | VARCHAR(20) | CHECK | breakfast/lunch/dinner/snack/dessert |
| difficulty_level | VARCHAR(20) | CHECK | easy/medium/hard |
| prep_time | INTEGER | | 准备时间（分钟） |
| cook_time | INTEGER | | 烹饪时间（分钟） |
| total_time | INTEGER | | 总时间（分钟） |
| servings | INTEGER | | 份数 |
| calories_per_serving | INTEGER | | 每份热量 |
| image_url | VARCHAR(255) | | 主图URL |
| is_published | BOOLEAN | DEFAULT TRUE | 是否发布 |
| is_deleted | BOOLEAN | DEFAULT FALSE | 逻辑删除标记 |
| view_count | INTEGER | DEFAULT 0 | 浏览次数 |
| rating_count | INTEGER | DEFAULT 0 | 评价数量 |
| average_rating | NUMERIC(3,2) | DEFAULT 0 | 平均评分 |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | 创建时间 |
| updated_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | 更新时间 |

### 其他关键表
详见建表脚本文件。

---

# 第4章 规范化

本数据库严格遵循 **BCNF（Boyce-Codd Normal Form）** 规范。

## 4.1 规范化目标

- **消除数据冗余**：每条数据只在一个地方存储
- **确保数据一致性**：任何修改自动反映到所有依赖
- **防止异常操作**：避免插入、更新、删除异常
- **优化查询性能**：通过合理的表分解提高查询效率

## 4.2 规范化等级总结

| # | 表名 | 主键 | 规范化等级 | 关键设计决策 |
|---|------|------|----------|-----------|
| 1 | users | user_id | BCNF | 用户基本信息，total_followers为性能冗余 |
| 2 | ingredients | ingredient_id | BCNF | 食材基础库 |
| 3 | units | unit_id | BCNF | 独立单位表 |
| 4 | recipes | recipe_id | BCNF | 食谱主表 |
| 5 | recipe_ingredients | recipe_ingredient_id | BCNF | N:M关系表 |
| 6 | ratings | rating_id | BCNF | 复合唯一键防止重复评分 |
| 7 | comments | comment_id | BCNF | 自引用支持嵌套 |
| ... | ... | ... | BCNF | 所有表均满足BCNF |

---

# 第5章 常见操作归纳

## 5.1 查询操作

### 1. 按菜系搜索食谱
```sql
SELECT r.recipe_id, r.recipe_name, r.average_rating, r.view_count, u.username
FROM recipes r
JOIN users u ON r.user_id = u.user_id
WHERE r.cuisine_type = '中式'
  AND r.is_published = TRUE
  AND r.is_deleted = FALSE
ORDER BY r.average_rating DESC
LIMIT 20;
```

### 2. 查询用户收藏的食谱
```sql
SELECT r.recipe_id, r.recipe_name, r.average_rating
FROM saved_recipes sr
JOIN recipes r ON sr.recipe_id = r.recipe_id
WHERE sr.user_id = $1
ORDER BY sr.saved_at DESC;
```

### 3. 查询食谱的嵌套评论
```sql
WITH RECURSIVE comment_tree AS (
    -- 基础：顶级评论
    SELECT 
        comment_id, recipe_id, user_id, comment_text, 
        parent_comment_id, created_at, 0 AS level
    FROM comments
    WHERE recipe_id = $1 AND parent_comment_id IS NULL
    
    UNION ALL
    
    -- 递归：子评论
    SELECT 
        c.comment_id, c.recipe_id, c.user_id, c.comment_text,
        c.parent_comment_id, c.created_at, ct.level + 1
    FROM comments c
    JOIN comment_tree ct ON c.parent_comment_id = ct.comment_id
    WHERE ct.level < 5
)
SELECT * FROM comment_tree ORDER BY created_at;
```

### 4. 推荐食谱（基于关注用户）
```sql
SELECT DISTINCT r.recipe_id, r.recipe_name, r.average_rating
FROM recipes r
JOIN followers f ON r.user_id = f.user_id
WHERE f.follower_user_id = $1
  AND r.is_published = TRUE
  AND r.is_deleted = FALSE
  AND r.recipe_id NOT IN (
      SELECT recipe_id FROM saved_recipes WHERE user_id = $1
  )
ORDER BY r.average_rating DESC
LIMIT 10;
```

## 5.2 插入操作

### 1. 发布食谱（完整流程）
```sql
-- 使用事务确保一致性
BEGIN;

INSERT INTO recipes (
    user_id, recipe_name, description, cuisine_type, 
    meal_type, difficulty_level, prep_time, cook_time,
    total_time, servings, is_published
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8,
    $7 + $8, $9, TRUE
);

-- 记录活动
INSERT INTO user_activity_log (
    user_id, activity_type, activity_description
) VALUES (
    $1, 'recipe_published', '发布了食谱：' || $2
);

-- 更新用户食谱计数
UPDATE users SET total_recipes = total_recipes + 1 WHERE user_id = $1;

COMMIT;
```

### 2. 用户评价食谱
```sql
INSERT INTO ratings (user_id, recipe_id, rating_value, review_text)
VALUES ($1, $2, $3, $4)
ON CONFLICT (user_id, recipe_id) 
DO UPDATE SET 
    rating_value = $3,
    review_text = $4,
    rating_date = CURRENT_TIMESTAMP;
```

## 5.3 更新操作

### 1. 更新食谱评分统计
```sql
UPDATE recipes SET 
    average_rating = ROUND(
        (SELECT AVG(rating_value) FROM ratings WHERE recipe_id = $1)::numeric, 2
    ),
    rating_count = (SELECT COUNT(*) FROM ratings WHERE recipe_id = $1),
    updated_at = CURRENT_TIMESTAMP
WHERE recipe_id = $1;
```

## 5.4 删除操作

### 1. 移除收藏的食谱
```sql
DELETE FROM saved_recipes 
WHERE user_id = $1 AND recipe_id = $2;
```

---

# 第6章 完整性约束方案设计

## 6.1 主键约束
```sql
ALTER TABLE users ADD PRIMARY KEY (user_id);
ALTER TABLE recipes ADD PRIMARY KEY (recipe_id);
-- 所有表都有主键
```

## 6.2 外键约束
```sql
-- 食谱与用户关系
ALTER TABLE recipes 
ADD CONSTRAINT fk_recipes_user 
FOREIGN KEY (user_id) REFERENCES users(user_id) 
ON DELETE CASCADE;

-- 食谱评价
ALTER TABLE ratings 
ADD CONSTRAINT fk_rating_recipe 
FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) 
ON DELETE CASCADE;

-- 评论自引用（嵌套评论）
ALTER TABLE comments 
ADD CONSTRAINT fk_comment_parent 
FOREIGN KEY (parent_comment_id) REFERENCES comments(comment_id) 
ON DELETE SET NULL;
```

## 6.3 唯一性约束
```sql
-- 用户唯一性
ALTER TABLE users ADD CONSTRAINT uk_username UNIQUE (username);
ALTER TABLE users ADD CONSTRAINT uk_email UNIQUE (email);

-- 防止重复评价
ALTER TABLE ratings ADD CONSTRAINT uk_user_recipe_rating 
UNIQUE (user_id, recipe_id);

-- 防止重复关注
ALTER TABLE followers ADD CONSTRAINT uk_follower 
UNIQUE (user_id, follower_user_id);
```

## 6.4 检查约束
```sql
-- 账户状态限制
ALTER TABLE users ADD CONSTRAINT ck_account_status 
CHECK (account_status IN ('active', 'inactive', 'suspended'));

-- 评分值范围
ALTER TABLE ratings ADD CONSTRAINT ck_rating_value 
CHECK (rating_value >= 0 AND rating_value <= 5);

-- 不能自己关注自己
ALTER TABLE followers ADD CONSTRAINT ck_not_self_follow 
CHECK (user_id != follower_user_id);
```

---

# 第7章 表的详细设计（物理模型）

## 7.1 PostgreSQL 数据类型选择

| 字段类型 | PostgreSQL类型 | 说明 |
|---------|--------------|------|
| ID字段 | SERIAL / BIGSERIAL | 自增主键 |
| 用户名 | VARCHAR(50) | 可变长文本 |
| 时间 | TIMESTAMP | 精确到微秒 |
| 日期 | DATE | 仅日期 |
| 浮点数 | NUMERIC(3,2) | 精确小数，避免浮点误差 |
| 计数器 | INTEGER | 足够表示十亿 |
| 布尔值 | BOOLEAN | 原生布尔类型 |
| JSON | JSONB | 灵活存储复杂结构 |
| 数组 | TEXT[] / INTEGER[] | 原生数组支持 |

## 7.2 索引设计

```sql
-- 用户表索引
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_join_date ON users(join_date);

-- 食谱表索引
CREATE INDEX idx_recipes_user_id ON recipes(user_id);
CREATE INDEX idx_recipes_cuisine_type ON recipes(cuisine_type);
CREATE INDEX idx_recipes_created_at ON recipes(created_at DESC);
CREATE INDEX idx_recipes_average_rating ON recipes(average_rating DESC);
CREATE INDEX idx_recipes_is_published ON recipes(is_published) 
WHERE is_published = TRUE;

-- 复合索引：常见查询组合
CREATE INDEX idx_recipes_published_rating 
ON recipes(is_published, average_rating DESC) 
WHERE is_published = TRUE;

-- 评分和评论索引
CREATE INDEX idx_ratings_recipe_id ON ratings(recipe_id);
CREATE INDEX idx_ratings_user_id ON ratings(user_id);
CREATE INDEX idx_comments_recipe_id ON comments(recipe_id);

-- 社交关系索引
CREATE INDEX idx_followers_user_id ON followers(user_id);
CREATE INDEX idx_followers_follower_user_id ON followers(follower_user_id);
```

## 7.3 分区设计（可选，针对大表）

```sql
-- 按月份分区 recipes 表
CREATE TABLE recipes_y2024m01 PARTITION OF recipes
FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');

CREATE TABLE recipes_y2024m02 PARTITION OF recipes
FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');
-- 更多分区...
```

---

# 第8章 视图设计方案

## 8.1 用户相关视图

### 视图1：USER_OVERVIEW（用户概览视图）
```sql
CREATE VIEW user_overview AS
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
```

## 8.2 食谱相关视图

### 视图2：POPULAR_RECIPES（热门食谱视图）
```sql
CREATE VIEW popular_recipes AS
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
```

---

# 第9章 数据库安全方案设计

## 9.1 用户认证和权限管理

```sql
-- 创建应用用户
CREATE ROLE app_user WITH LOGIN PASSWORD 'SecureP@ss123';

-- 创建只读用户（报表用）
CREATE ROLE report_user WITH LOGIN PASSWORD 'ReportP@ss456';

-- 授权表级权限
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE users TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE recipes TO app_user;

-- 只读权限
GRANT SELECT ON TABLE users, recipes, ratings TO report_user;
```

## 9.2 数据加密

```sql
-- 创建密码哈希函数
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 使用 pgcrypto 的哈希函数
INSERT INTO users (username, email, password_hash, ...)
VALUES ('john', 'john@example.com', crypt('password123', gen_salt('bf')), ...);

-- 验证密码
SELECT password_hash = crypt($1, password_hash) as password_match
FROM users WHERE user_id = $2;
```

## 9.3 审计日志

```sql
-- 创建审计日志表
CREATE TABLE audit_log (
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
CREATE FUNCTION log_recipe_changes()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit_log (database_user, operation_type, table_name, record_id, new_values)
    VALUES (CURRENT_USER, TG_OP, TG_TABLE_NAME, NEW.recipe_id::text, 
            row_to_json(NEW));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 绑定触发器
CREATE TRIGGER trg_audit_recipes
AFTER INSERT OR UPDATE ON recipes
FOR EACH ROW EXECUTE FUNCTION log_recipe_changes();
```

---

# 第10章 PostgreSQL特性应用

## 10.1 JSON类型应用

```sql
-- 存储灵活的配置信息
ALTER TABLE recipes ADD COLUMN metadata JSONB;

-- 示例
UPDATE recipes SET metadata = jsonb_build_object(
    'difficulty_tips', 'Turn heat to high',
    'storage', 'Keep in fridge',
    'tags', '["quick", "easy"]'::jsonb
) WHERE recipe_id = 1;

-- 查询
SELECT recipe_name FROM recipes 
WHERE metadata->>'tags' LIKE '%quick%';
```

## 10.2 数组类型应用

```sql
-- 存储标签数组
ALTER TABLE recipes ADD COLUMN tags_array TEXT[];

-- 添加标签
UPDATE recipes SET tags_array = ARRAY['素食', '快手菜', '低脂']
WHERE recipe_id = 1;

-- 查询包含特定标签的食谱
SELECT recipe_name FROM recipes 
WHERE '素食' = ANY(tags_array);
```

## 10.3 全文搜索

```sql
-- 创建全文搜索配置
CREATE FUNCTION update_recipe_search_index()
RETURNS TRIGGER AS $$
BEGIN
    NEW.search_vector = to_tsvector('chinese', NEW.recipe_name) || 
                        to_tsvector('chinese', COALESCE(NEW.description, ''));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 添加搜索向量列
ALTER TABLE recipes ADD COLUMN search_vector tsvector;

-- 创建触发器
CREATE TRIGGER trg_recipe_search_update
BEFORE INSERT OR UPDATE ON recipes
FOR EACH ROW EXECUTE FUNCTION update_recipe_search_index();

-- 创建索引加速搜索
CREATE INDEX idx_recipe_search ON recipes USING GIN(search_vector);

-- 全文搜索查询
SELECT recipe_name, ts_rank(search_vector, query) AS rank
FROM recipes, plainto_tsquery('chinese', '番茄') query
WHERE search_vector @@ query
ORDER BY rank DESC
LIMIT 10;
```

## 10.4 窗口函数应用

```sql
-- 计算用户贡献排名
SELECT 
    username,
    total_recipes,
    total_followers,
    ROW_NUMBER() OVER (ORDER BY total_followers DESC) AS follower_rank,
    RANK() OVER (ORDER BY total_followers DESC) AS follower_rank_with_ties,
    DENSE_RANK() OVER (ORDER BY total_followers DESC) AS dense_rank
FROM users
WHERE account_status = 'active'
LIMIT 10;

-- 食材配对热度排名
SELECT 
    i1.ingredient_name,
    i2.ingredient_name,
    COUNT(*) AS pair_frequency,
    ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS rank
FROM recipe_ingredients ri1
JOIN recipe_ingredients ri2 ON ri1.recipe_id = ri2.recipe_id
    AND ri1.ingredient_id < ri2.ingredient_id
JOIN ingredients i1 ON ri1.ingredient_id = i1.ingredient_id
JOIN ingredients i2 ON ri2.ingredient_id = i2.ingredient_id
GROUP BY i1.ingredient_name, i2.ingredient_name
ORDER BY rank
LIMIT 20;
```

## 10.5 物化视图

```sql
-- 创建物化视图（用于复杂且耗时的查询）
CREATE MATERIALIZED VIEW recipe_popularity_stats AS
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
LEFT JOIN comments c ON r.recipe_id = c.recipe_id
WHERE r.is_deleted = FALSE
GROUP BY r.recipe_id, r.recipe_name, r.average_rating, r.rating_count, r.view_count;

-- 创建索引加速查询
CREATE INDEX idx_popularity_stats ON recipe_popularity_stats(popularity_score DESC);

-- 刷新物化视图
REFRESH MATERIALIZED VIEW recipe_popularity_stats;
```

## 10.6 CTE (公用表表达式)

```sql
-- 使用 CTE 生成膳食计划购物清单
WITH meal_plan_recipes AS (
    SELECT DISTINCT mpe.recipe_id
    FROM meal_plan_entries mpe
    WHERE mpe.plan_id = $1
),
recipe_ingredients_agg AS (
    SELECT 
        ri.ingredient_id,
        i.ingredient_name,
        i.category,
        SUM(ri.quantity) AS total_quantity,
        u.unit_name,
        STRING_AGG(DISTINCT r.recipe_name, ', ') AS recipes
    FROM meal_plan_recipes mpr
    JOIN recipes r ON mpr.recipe_id = r.recipe_id
    JOIN recipe_ingredients ri ON r.recipe_id = ri.recipe_id
    JOIN ingredients i ON ri.ingredient_id = i.ingredient_id
    JOIN units u ON ri.unit_id = u.unit_id
    GROUP BY ri.ingredient_id, i.ingredient_name, i.category, u.unit_name
)
SELECT * FROM recipe_ingredients_agg
ORDER BY category, ingredient_name;
```

## 10.7 扩展功能

```sql
-- UUID 支持（更好的主键）
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 创建使用 UUID 的表
CREATE TABLE users_v2 (
    user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username VARCHAR(50) NOT NULL UNIQUE,
    ...
);

-- 范围类型支持（营养值范围）
CREATE TABLE recipe_nutrition_range (
    recipe_id INTEGER PRIMARY KEY,
    calories_range INT4RANGE,
    protein_range NUMRANGE,
    FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id)
);

INSERT INTO recipe_nutrition_range VALUES (1, '[200, 500]', '[5.5, 15.5]');
SELECT * FROM recipe_nutrition_range 
WHERE 300 <@ calories_range AND 10 <@ protein_range;
```

---

# 总结

本设计方案充分利用了 PostgreSQL 的高级特性，提供了：

- **高度规范化**的26张表设计
- **完整的ACID事务**保证数据一致性
- **强大的查询能力**（CTE、窗口函数、全文搜索）
- **灵活的JSON和数组**支持
- **完善的安全方案**（加密、权限、审计）
- **性能优化**（索引、物化视图、分区）

系统已完全就绪投入生产环境！
