import os
import csv
import getpass
import sys

# 尝试导入 oracledb 或 cx_Oracle
try:
    import oracledb as db_driver
    # 启用瘦客户端模式 (Thin mode)，不需要安装 Oracle Instant Client
    # 如果需要连接旧版数据库，可能需要 db_driver.init_oracle_client()
except ImportError:
    try:
        import cx_Oracle as db_driver
    except ImportError:
        print("错误: 未找到 Oracle 驱动程序。")
        print("请运行以下命令安装: pip install oracledb")
        sys.exit(1)

# ================= 配置区域 =================
# 你可以在这里直接修改默认值，或者运行时输入
DEFAULT_DSN = "localhost:1522/orcl30"  # 格式: hostname:port/service_name
OUTPUT_DIR = "csv_exports"           # 导出文件夹名称
ENCODING = "utf-8-sig"               # 使用 utf-8-sig 可以让 Excel 正确识别中文
# ===========================================

def get_connection():
    """获取数据库连接信息"""
    print("=== Oracle 数据库导出工具 ===")
    user = input("请输入用户名: ").strip()
    if not user:
        print("用户名不能为空")
        sys.exit(1)
        
    password = getpass.getpass("请输入密码: ").strip()
    
    dsn = input(f"请输入连接串 (默认 {DEFAULT_DSN}): ").strip()
    if not dsn:
        dsn = DEFAULT_DSN
        
    return user, password, dsn

def export_data():
    user, password, dsn = get_connection()
    
    # 创建输出目录
    if not os.path.exists(OUTPUT_DIR):
        os.makedirs(OUTPUT_DIR)
        print(f"已创建输出目录: {OUTPUT_DIR}")

    connection = None
    try:
        print(f"\n正在连接到 {dsn} ...")
        connection = db_driver.connect(user=user, password=password, dsn=dsn)
        cursor = connection.cursor()
        
        # 1. 获取所有用户表
        print("正在获取表列表...")
        cursor.execute("SELECT table_name FROM user_tables ORDER BY table_name")
        tables = [row[0] for row in cursor.fetchall()]
        
        print(f"找到 {len(tables)} 个表。开始导出...\n")
        
        for table in tables:
            try:
                csv_file = os.path.join(OUTPUT_DIR, f"{table}.csv")
                
                # 2. 查询表数据
                sql = f"SELECT * FROM {table}"
                cursor.execute(sql)
                
                # 获取列名
                columns = [col[0] for col in cursor.description]
                
                with open(csv_file, 'w', newline='', encoding=ENCODING) as f:
                    writer = csv.writer(f)
                    
                    # 写入表头
                    writer.writerow(columns)
                    
                    # 批量写入数据 (防止内存溢出)
                    row_count = 0
                    while True:
                        rows = cursor.fetchmany(5000)
                        if not rows:
                            break
                        writer.writerows(rows)
                        row_count += len(rows)
                        
                print(f"[成功] {table:<30} -> {csv_file} ({row_count} 行)")
                
            except Exception as e:
                print(f"[失败] {table:<30} -> 错误: {str(e)}")
                
    except db_driver.Error as e:
        print(f"\n数据库错误: {e}")
    except Exception as e:
        print(f"\n发生错误: {e}")
    finally:
        if connection:
            connection.close()
            print("\n数据库连接已关闭。")

if __name__ == "__main__":
    export_data()
