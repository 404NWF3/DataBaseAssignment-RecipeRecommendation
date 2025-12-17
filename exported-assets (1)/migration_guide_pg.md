# Oracle → PostgreSQL 迁移指南

## 📋 关键差异和转换说明

### 1. 数据类型映射

| Oracle | PostgreSQL | 说明 |
|--------|-----------|------|
| NUMBER(10) | INTEGER / SERIAL | 整数类型 |
| NUMBER(3,2) | NUMERIC(3,2) | 精确小数 |
| VARCHAR2(n) | VARCHAR(n) | 可变字符串 |
| DATE | DATE | 仅日期 |
| TIMESTAMP | TIMESTAMP | 时间戳 |
| BOOLEAN | BOOLEAN | 布尔值（Oracle用CHAR(1)) |
| CLOB | TEXT | 大文本 |
| - | JSONB | JSON支持 |
| - | TEXT[] | 数组 |

### 2. 序列和自增

**Oracle:**
```sql
CREATE SEQUENCE seq_users START WITH 1 INCREMENT BY 1;
INSERT INTO USERS (user_id, ...) VALUES (seq_users.NEXTVAL, ...);
```

**PostgreSQL:**
```sql
CREATE SEQUENCE seq_users START WITH 1 INCREMENT BY 1;
-- 或者使用更简洁的方式
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,  -- 自动创建序列
    ...
);
```

### 3. 时间戳函数

| Oracle | PostgreSQL | 说明 |
|--------|-----------|------|
| SYSDATE | CURRENT_DATE | 当前日期 |
| SYSTIMESTAMP | CURRENT_TIMESTAMP | 当前时间戳 |
| TRUNC(date, 'MM') | DATE_TRUNC('month', date) | 截断到月份 |
| DATEDIFF() | 不存在 | 用 - 运算符替代 |
| - | AGE(date) | 计算时间差 |

### 4. 字符串函数

| Oracle | PostgreSQL | 说明 |
|--------|-----------|------|
| CONCAT() | \|\| 或 CONCAT() | 字符串连接 |
| SUBSTR() | SUBSTRING() | 子串 |
| LENGTH() | LENGTH() | 字符串长度 |
| UPPER/LOWER | UPPER/LOWER | 大小写转换 |
| INSTR() | POSITION() | 查找位置 |
| REPLACE() | REPLACE() | 字符串替换 |
| TRIM() | TRIM() | 删除空白 |
| ROUND() | ROUND() | 四舍五入 |

### 5. 存储过程语法差异

**Oracle PLpgsql:**
```plpgsql
CREATE OR REPLACE PROCEDURE proc_name(param IN TYPE)
AS
BEGIN
    -- SQL语句
    EXCEPTION
        WHEN exception_name THEN
            -- 处理异常
END proc_name;
/
```

**PostgreSQL PL/pgSQL:**
```plpgsql
CREATE OR REPLACE FUNCTION proc_name(param TYPE)
RETURNS void AS $$
BEGIN
    -- SQL语句
EXCEPTION
    WHEN exception_name THEN
        -- 处理异常
END;
$$ LANGUAGE plpgsql;
```

**关键差异:**
- Oracle 用 `PROCEDURE`，PostgreSQL 用 `FUNCTION`
- Oracle 用 `/` 作为语句结束符，PostgreSQL 用 `$$`
- Oracle 的 `OUT` 参数在 PostgreSQL 也支持
- PostgreSQL 需要明确指定 `LANGUAGE plpgsql`

### 6. 触发器差异

**Oracle:**
```plpgsql
CREATE OR REPLACE TRIGGER trg_name
AFTER INSERT ON table_name
FOR EACH ROW
BEGIN
    -- PL/SQL 代码
END trg_name;
/
```

**PostgreSQL:**
```plpgsql
CREATE FUNCTION trigger_func()
RETURNS TRIGGER AS $$
BEGIN
    -- PL/pgSQL 代码
    RETURN NEW;  -- 必须返回 NEW 或 OLD
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_name
AFTER INSERT ON table_name
FOR EACH ROW EXECUTE FUNCTION trigger_func();
```

### 7. 密码加密

**Oracle:**
```sql
DBMS_CRYPTO.HASH(UTL_RAW.CAST_TO_RAW(password), DBMS_CRYPTO.HASH_SH256)
```

**PostgreSQL:**
```sql
-- 使用 pgcrypto 扩展
CREATE EXTENSION pgcrypto;

-- 加密密码
crypt('password', gen_salt('bf'))

-- 验证密码
password_hash = crypt('input_password', password_hash)
```

### 8. 异常处理

**Oracle:**
```plpgsql
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    WHEN DUP_VAL_ON_INDEX THEN
    WHEN OTHERS THEN
```

**PostgreSQL:**
```plpgsql
EXCEPTION
    WHEN NO_DATA_FOUND THEN  -- 仍然可用
    WHEN UNIQUE_VIOLATION THEN  -- PostgreSQL特定
    WHEN OTHERS THEN
```

### 9. 约束查询

**Oracle:**
```sql
-- 查询约束
SELECT constraint_name FROM user_constraints WHERE table_name = 'USERS';
```

**PostgreSQL:**
```sql
-- 查询约束
SELECT constraint_name FROM information_schema.table_constraints 
WHERE table_name = 'users';
```

### 10. 索引部分匹配

**Oracle:**
```sql
CREATE INDEX idx_recipes_published 
ON recipes(is_published) WHERE is_published = 'Y';
```

**PostgreSQL:**
```sql
CREATE INDEX idx_recipes_published 
ON recipes(is_published) WHERE is_published = TRUE;
```

### 11. 事务处理

**Oracle:**
```sql
BEGIN
    -- SQL语句
COMMIT;  -- 显式提交
EXCEPTION
    WHEN OTHERS THEN ROLLBACK;
END;
/
```

**PostgreSQL:**
```sql
BEGIN;  -- 或 START TRANSACTION;
    -- SQL语句
COMMIT;  -- 或 ROLLBACK;
```

### 12. 查看系统信息

**Oracle:**
```sql
-- 查看表
SELECT table_name FROM user_tables;

-- 查看序列
SELECT sequence_name FROM user_sequences;

-- 查看视图
SELECT view_name FROM user_views;
```

**PostgreSQL:**
```sql
-- 查看表
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public';

-- 查看序列
SELECT sequence_name FROM information_schema.sequences 
WHERE sequence_schema = 'public';

-- 查看视图
SELECT viewname FROM pg_views WHERE schemaname = 'public';
```

---

## 🔄 迁移步骤

### 1. 数据库初始化

```bash
# PostgreSQL 连接
psql -U postgres -h localhost

# 创建数据库
CREATE DATABASE allrecipes_db;

# 连接到新数据库
\c allrecipes_db
```

### 2. 执行建表脚本

```bash
# 执行建表脚本
psql -U postgres -d allrecipes_db -f createtable_pg.sql

# 执行实现脚本
psql -U postgres -d allrecipes_db -f implement_pg.sql
```

### 3. 验证迁移

```sql
-- 检查表数量
SELECT COUNT(*) FROM information_schema.tables 
WHERE table_schema = 'public' AND table_type = 'BASE TABLE';
-- 应返回 26

-- 检查索引数量
SELECT COUNT(*) FROM pg_indexes WHERE schemaname = 'public';
-- 应返回 30+

-- 检查函数
SELECT COUNT(*) FROM information_schema.routines 
WHERE routine_schema = 'public' AND routine_type = 'FUNCTION';

-- 查看示例数据
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM units;
SELECT COUNT(*) FROM allergens;
```

---

## ⚡ PostgreSQL 特有优势

### 1. JSON支持

```sql
-- 存储灵活的配置
ALTER TABLE recipes ADD COLUMN metadata JSONB;

UPDATE recipes SET metadata = jsonb_build_object(
    'tips', 'Keep heat high',
    'storage', 'Refrigerate'
) WHERE recipe_id = 1;

-- 查询 JSON
SELECT recipe_name FROM recipes 
WHERE metadata->>'tips' LIKE '%high%';
```

### 2. 数组类型

```sql
-- 存储标签数组
ALTER TABLE recipes ADD COLUMN tags_array TEXT[];

UPDATE recipes SET tags_array = ARRAY['素食', '快手菜']
WHERE recipe_id = 1;

-- 查询数组
SELECT recipe_name FROM recipes 
WHERE '素食' = ANY(tags_array);
```

### 3. 全文搜索

```sql
-- 创建搜索向量
ALTER TABLE recipes ADD COLUMN search_vector tsvector;

UPDATE recipes SET search_vector = 
    to_tsvector('chinese', recipe_name) || 
    to_tsvector('chinese', COALESCE(description, ''));

-- 创建索引
CREATE INDEX idx_recipe_search ON recipes USING GIN(search_vector);

-- 搜索
SELECT recipe_name, ts_rank(search_vector, query) as rank
FROM recipes, plainto_tsquery('chinese', '番茄') query
WHERE search_vector @@ query
ORDER BY rank DESC;
```

### 4. 递归查询 (CTE)

```sql
-- 嵌套评论树查询（已在脚本中实现）
WITH RECURSIVE comment_tree AS (
    SELECT comment_id, parent_comment_id, 0 as level
    FROM comments WHERE parent_comment_id IS NULL
    
    UNION ALL
    
    SELECT c.comment_id, c.parent_comment_id, ct.level + 1
    FROM comments c
    JOIN comment_tree ct ON c.parent_comment_id = ct.comment_id
    WHERE ct.level < 5
)
SELECT * FROM comment_tree;
```

### 5. 窗口函数

```sql
-- 排名
SELECT 
    username,
    total_followers,
    ROW_NUMBER() OVER (ORDER BY total_followers DESC) as rank
FROM users;

-- 分组排名
SELECT 
    meal_type,
    recipe_name,
    average_rating,
    ROW_NUMBER() OVER (PARTITION BY meal_type ORDER BY average_rating DESC) as rank
FROM recipes;
```

### 6. ON CONFLICT (UPSERT)

```sql
-- 自动处理重复插入更新
INSERT INTO ratings (user_id, recipe_id, rating_value, review_text)
VALUES ($1, $2, $3, $4)
ON CONFLICT (user_id, recipe_id)
DO UPDATE SET 
    rating_value = $3,
    review_text = $4,
    rating_date = CURRENT_TIMESTAMP;
```

---

## 📊 性能提示

### 1. 查询优化

```sql
-- 使用 EXPLAIN 分析查询计划
EXPLAIN ANALYZE
SELECT * FROM recipes 
WHERE cuisine_type = '中式' AND is_published = TRUE
ORDER BY average_rating DESC
LIMIT 20;

-- 查看索引使用情况
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM recipes WHERE recipe_id = 1;
```

### 2. 物化视图刷新

```sql
-- 定期刷新物化视图以保持数据最新
REFRESH MATERIALIZED VIEW recipe_popularity_stats;

-- 并发刷新（不锁表）
REFRESH MATERIALIZED VIEW CONCURRENTLY recipe_popularity_stats;
```

### 3. 统计信息更新

```sql
-- 更新统计信息以优化查询计划
ANALYZE recipes;
ANALYZE users;

-- 更新所有表
ANALYZE;
```

### 4. 慢查询日志

```sql
-- 设置慢查询日志
ALTER SYSTEM SET log_min_duration_statement = 1000;  -- 1秒
SELECT pg_reload_conf();

-- 查看日志
tail -f /var/log/postgresql/postgresql.log
```

---

## 🔐 安全建议

### 1. 用户权限管理

```sql
-- 创建应用用户
CREATE ROLE app_user WITH LOGIN PASSWORD 'SecurePass123';

-- 授予权限
GRANT CONNECT ON DATABASE allrecipes_db TO app_user;
GRANT USAGE ON SCHEMA public TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO app_user;

-- 撤销权限
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM app_user;
```

### 2. 密码政策

```sql
-- 定期更改密码
ALTER ROLE app_user WITH PASSWORD 'NewSecurePass456';

-- 设置过期时间
ALTER ROLE app_user VALID UNTIL '2025-12-31';
```

### 3. 连接加密

在 `postgresql.conf` 中配置：
```
ssl = on
ssl_cert_file = 'path/to/cert.crt'
ssl_key_file = 'path/to/key.key'
```

---

## 🐛 常见问题

### Q1: 中文搜索不工作？
**A:** 确保配置了中文全文搜索：
```sql
CREATE TEXT SEARCH CONFIGURATION chinese (COPY = simple);
ALTER TEXT SEARCH CONFIGURATION chinese ALTER MAPPING 
FOR word WITH simple;
```

### Q2: 并发更新冲突？
**A:** 使用 ON CONFLICT 或事务隔离级别：
```sql
-- 使用可序列化隔离
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
```

### Q3: 查询变慢？
**A:** 分析和优化：
```sql
EXPLAIN ANALYZE <your query>;
-- 根据结果创建适当的索引
```

### Q4: 磁盘空间不足？
**A:** 清理和优化：
```sql
VACUUM FULL;  -- 回收空间（锁表）
REINDEX;      -- 重建索引
```

---

## ✅ 迁移检查清单

- [ ] PostgreSQL 安装完成
- [ ] 创建数据库
- [ ] 执行建表脚本
- [ ] 执行实现脚本
- [ ] 验证表数量（26个）
- [ ] 验证索引数量（30+个）
- [ ] 测试示例数据
- [ ] 执行存储过程测试
- [ ] 查询视图验证
- [ ] 性能基准测试
- [ ] 备份配置
- [ ] 监控告警配置

---

## 📞 需要帮助？

- PostgreSQL 官方文档：https://www.postgresql.org/docs/
- 中文社区：https://www.postgresql.org.cn/
- 性能优化：https://wiki.postgresql.org/wiki/Performance_Optimization

**迁移完成！您现在拥有一个生产就绪的PostgreSQL数据库系统。** 🚀
