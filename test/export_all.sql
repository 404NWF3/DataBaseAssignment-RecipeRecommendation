-- ============================================================
-- Oracle 全表导出 CSV 脚本 (兼容版)
-- ============================================================
-- 说明：
-- 1. 本脚本通过动态构建 SQL 语句，手动拼接逗号和引号，生成标准的 CSV 格式。
-- 2. 兼容 SQL*Plus 和 SQLcl。
-- 3. 关于中文乱码：
--    - 如果导出的 CSV 中文乱码，请在运行 sqlplus 前设置环境变量：
--      Windows CMD: set NLS_LANG=SIMPLIFIED CHINESE_CHINA.AL32UTF8
--      PowerShell:  $env:NLS_LANG="SIMPLIFIED CHINESE_CHINA.AL32UTF8"
-- ============================================================

-- 尝试设置 SQLcl 编码 (SQL*Plus 会忽略此行报错)
set encoding UTF-8

-- 基础环境设置
set head off
set feed off
set termout off
set pagesize 0
set linesize 32767
set trimspool on
set verify off
set long 100000

-- 尝试切换 Windows 控制台代码页到 UTF-8
host chcp 65001

-- 第一步：生成执行脚本 run_export.sql
spool run_export.sql

SELECT 'PROMPT Exporting ' || table_name || '...' || chr(10) ||
       'spool ' || table_name || '.csv' || chr(10) ||
       'SELECT ' || 
       (
           SELECT LISTAGG(
               CASE 
                   -- 字符串类型：加双引号，并处理内容中的双引号
                   WHEN data_type LIKE '%CHAR%' OR data_type LIKE '%CLOB%' THEN 
                       '''"''||REPLACE(' || column_name || ',''"'',''""'')||''"'''
                   -- 日期类型：格式化为标准时间字符串，加双引号
                   WHEN data_type LIKE '%DATE%' OR data_type LIKE '%TIMESTAMP%' THEN 
                       '''"''||TO_CHAR(' || column_name || ',''YYYY-MM-DD HH24:MI:SS'')||''"'''
                   -- 数字和其他类型：直接输出
                   ELSE 
                       column_name 
               END, 
               '||'',''||'
           ) WITHIN GROUP (ORDER BY column_id)
           FROM user_tab_columns c 
           WHERE c.table_name = t.table_name
       ) || 
       ' FROM ' || table_name || ';' || chr(10) ||
       'spool off'
FROM user_tables t
ORDER BY table_name;

spool off

-- 第二步：执行生成的脚本
set termout on
PROMPT =================================================
PROMPT Starting Export Process...
PROMPT =================================================
@run_export.sql
PROMPT =================================================
PROMPT Export Complete! Check .csv files in current dir.
PROMPT =================================================
set termout on
PROMPT >>> 正在以 UTF-8 编码导出所有表...
@run_export.sql
PROMPT >>> 导出完成！

-- 4. 恢复默认设置
set markup csv off