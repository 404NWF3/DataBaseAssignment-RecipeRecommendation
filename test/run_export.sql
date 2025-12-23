SQL> SELECT 'PROMPT Exporting ' || table_name || '...' || chr(10) ||
  2         'spool ' || table_name || '.csv' || chr(10) ||
  3         'SELECT ' ||
  4         (
  5             SELECT LISTAGG(
  6                 CASE
  7                     -- 字符串类型：加双引号，并处理内容中的双引号

  8                     WHEN data_type LIKE '%CHAR%' OR data_type LIKE '%CLOB%' THEN
  9                         '''"''||REPLACE(' || column_name || ',''"'',''""'')||''"'''
 10                     -- 日期类型：格式化为标准时间字符串，加双引号

 11                     WHEN data_type LIKE '%DATE%' OR data_type LIKE '%TIMESTAMP%' THEN
 12                         '''"''||TO_CHAR(' || column_name || ',''YYYY-MM-DD HH24:MI:SS'')||''"'''
 13                     -- 数字和其他类型：直接输出
 14                     ELSE
 15                         column_name
 16                 END,
 17                 '||'',''||'
 18             ) WITHIN GROUP (ORDER BY column_id)
 19             FROM user_tab_columns c
 20             WHERE c.table_name = t.table_name
 21         ) ||
 22         ' FROM ' || table_name || ';' || chr(10) ||
 23         'spool off'
 24  FROM user_tables t
 25  ORDER BY table_name;
                       '''"''||REPLACE(' || column_name || ',''"'',''""'')||''"'''
                       *
�� 8 �г��ִ���:
ORA-00907: ȱʧ������


SQL> 
SQL> spool off
