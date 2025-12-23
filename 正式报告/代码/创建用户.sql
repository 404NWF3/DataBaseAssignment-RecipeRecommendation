-- 1. 创建用户
CREATE USER user5 IDENTIFIED BY "12345678"
DEFAULT TABLESPACE allrecipes_data
QUOTA UNLIMITED ON allrecipes_data;

-- 2. 赋予必要权限
-- CONNECT: 允许登录
-- RESOURCE: 允许创建表、序列等基本对象
GRANT CONNECT, RESOURCE TO user5;

-- 3. (可选) 如果需要创建视图，显式赋予权限
GRANT CREATE VIEW TO user5;
