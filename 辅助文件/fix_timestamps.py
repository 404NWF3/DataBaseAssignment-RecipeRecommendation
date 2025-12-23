import re
import os

path = r'e:\@DataBase\RecipeRecommendation\assets\插入数据\05_INGREDIENTS.sql'
if os.path.exists(path):
    with open(path, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    
    print(f"Read {len(content)} characters")
    
    # Replace to_timestamp(...) with SYSTIMESTAMP
    # Using a more generic regex to catch all variations
    new_content = re.sub(r"to_timestamp\s*\([^)]+\)", "SYSTIMESTAMP", content)
    
    # Also replace lowercase systemtimestamp
    new_content = new_content.replace("systemtimestamp", "SYSTIMESTAMP")
    
    print(f"New content length: {len(new_content)}")
    
    with open(path, 'w', encoding='utf-8') as f:
        f.write(new_content)
    print("Replacement complete.")
else:
    print("File not found.")
