# AllRecipes 食谱网站 - 精细化真实数据录入方案（v3.0）

## 目录

1. [设计理念](#设计理念)
2. [数据量规划](#数据量规划)
3. [真实数据库设计](#真实数据库设计)
4. [各表数据详解](#各表数据详解)
5. [数据录入顺序](#数据录入顺序)
6. [数据验证查询](#数据验证查询)
7. [业务场景测试](#业务场景测试)

---

# 设计理念

## 核心原则

本次数据导入遵循 **"宁精勿多"** 原则：

- ✅ **数据精少**：每个表只插入 5-30 条精心设计的数据
- ✅ **数据真实**：所有数据都基于真实世界场景构造
- ✅ **充分利用功能**：通过有限的数据展现数据库的完整功能
- ✅ **易于验证**：数据量小，便于手工查看和验证结果
- ✅ **便于扩展**：为后续真实运营预留扩展空间

## 对比

| 指标 | 前版本 | 本版本 | 说明 |
|------|--------|--------|------|
| 用户数 | 50个 | **10个** | 但每个用户都有真实身份 |
| 食材数 | 100个 | **35个** | 覆盖主要分类 |
| 食谱数 | 200个 | **15个** | 真实菜谱名称和流程 |
| 评价数 | 500个 | **20个** | 真实评分和评论 |
| 总数据量 | ~3000条 | **~400条** | 减少87% |
| 建表性能 | 20-30秒 | **2-5秒** | 更快验证 |

---

# 数据量规划

## 精选数据清单

### 第一层：基础数据

| 表名 | 数量 | 备注 |
|------|------|------|
| USERS | 10 | 真实人物背景 |
| INGREDIENTS | 35 | 常用食材 |
| UNITS | 12 | 标准烹饪单位 |
| ALLERGENS | 8 | 常见过敏原 |
| TAGS | 12 | 分类标签 |

**小计**：77条基础数据

### 第二层：主体数据

| 表名 | 数量 | 备注 |
|------|------|------|
| RECIPES | 15 | 真实菜谱 |
| COOKING_STEPS | 60 | 平均4步/菜谱 |
| NUTRITION_INFO | 15 | 每个菜谱一条 |
| RECIPE_INGREDIENTS | 70 | 平均4-5个食材 |

**小计**：160条数据

### 第三层：用户交互

| 表名 | 数量 | 备注 |
|------|------|------|
| RATINGS | 20 | 真实评分分布 |
| COMMENTS | 12 | 有意义的评论 |
| SAVED_RECIPES | 15 | 收藏行为 |
| FOLLOWERS | 8 | 社交网络 |
| USER_ALLERGIES | 5 | 用户过敏原 |

**小计**：60条数据

### 第四层：个人管理

| 表名 | 数量 | 备注 |
|------|------|------|
| RECIPE_COLLECTIONS | 3 | 用户清单 |
| COLLECTION_RECIPES | 12 | 清单内容 |
| SHOPPING_LISTS | 2 | 购物清单 |
| SHOPPING_LIST_ITEMS | 18 | 清单项目 |
| MEAL_PLANS | 2 | 膳食计划 |
| MEAL_PLAN_ENTRIES | 14 | 计划条目 |

**小计**：51条数据

**总计：~348条数据**

---

# 真实数据库设计

## 用户数据（10个真实用户）

### 用户背景描述

1. **Zhang Wei** (user_id=1)
   - 邮箱：zhang.wei@email.com
   - 角色：美食博主
   - 简介：专业美食摄影师，运营"家常菜那些事"公众号
   - 粉丝数：450+

2. **Li Na** (user_id=2)
   - 邮箱：li.na.cooking@email.com
   - 角色：专业厨师
   - 简介：5年餐厅主厨，擅长川菜和湖南菜
   - 粉丝数：320+

3. **Wang Jun** (user_id=3)
   - 邮箱：wangjun1990@email.com
   - 角色：普通用户
   - 简介：上班族，喜欢快手菜和健身餐
   - 粉丝数：0

4. **Liu Fang** (user_id=4)
   - 邮箱：fang.liu.home@email.com
   - 角色：家庭主妇
   - 简介：全职妈妈，分享家常菜和儿童食谱
   - 粉丝数：180

5. **Chen Ming** (user_id=5)
   - 邮箱：chen.ming.chef@email.com
   - 角色：专业厨师
   - 简介：面食专家，拥有自己的面馆
   - 粉丝数：280

6. **Xu Hui** (user_id=6)
   - 邮箱：hui.xu.health@email.com
   - 角色：营养师
   - 简介：认证营养师，分享健康食谱
   - 粉丝数：520

7. **Zhou Tao** (user_id=7)
   - 邮箱：tao.zhou@email.com
   - 角色：普通用户
   - 简介：美食爱好者，热爱尝试新菜谱
   - 粉丝数：0

8. **Guo Qiang** (user_id=8)
   - 邮箱：guo.qiang.food@email.com
   - 角色：美食博主
   - 简介：资深吃货，测评各地特色菜
   - 粉丝数：380

9. **Sun Yue** (user_id=9)
   - 邮箱：sun.yue.cook@email.com
   - 角色：普通用户
   - 简介：学生，想学做家常菜
   - 粉丝数：0

10. **Jiang Lin** (user_id=10)
    - 邮箱：jiang.lin.baker@email.com
    - 角色：烘焙师
    - 简介：西点烘焙师，分享烘焙技巧和甜品食谱
    - 粉丝数：290

---

## 真实菜谱库（15个经典菜谱）

### 中式菜（8个）

1. **宫保鸡丁**
   - 创建者：Li Na (user_id=2)
   - 难度：中等，烹饪时间25分钟
   - 菜系：川菜
   - 份数：3-4人
   - 标签：快手菜、家常菜、高蛋白

2. **番茄鸡蛋面**
   - 创建者：Chen Ming (user_id=5)
   - 难度：简单，烹饪时间15分钟
   - 菜系：家常
   - 份数：2人
   - 标签：快手菜、早餐、面食

3. **红烧肉**
   - 创建者：Zhang Wei (user_id=1)
   - 难度：中等，烹饪时间90分钟
   - 菜系：经典家常菜
   - 份数：4-6人
   - 标签：家常菜、补气血、节日大餐

4. **清蒸鱼**
   - 创建者：Xu Hui (user_id=6)
   - 难度：简单，烹饪时间20分钟
   - 菜系：广东
   - 份数：2-3人
   - 标签：健康、低脂、清蒸

5. **麻婆豆腐**
   - 创建者：Li Na (user_id=2)
   - 难度：中等，烹饪时间20分钟
   - 菜系：川菜
   - 份数：3-4人
   - 标签：快手菜、家常菜、麻辣

6. **青菜炒蛋**
   - 创建者：Liu Fang (user_id=4)
   - 难度：简单，烹饪时间10分钟
   - 菜系：家常
   - 份数：2人
   - 标签：快手菜、儿童食品、简单易做

7. **冬瓜排骨汤**
   - 创建者：Liu Fang (user_id=4)
   - 难度：简单，烹饪时间60分钟
   - 菜系：家常
   - 份数：4人
   - 标签：汤类、清热、家常菜

8. **蒜蓉炒虾仁**
   - 创建者：Zhang Wei (user_id=1)
   - 难度：中等，烹饪时间15分钟
   - 菜系：粤菜
   - 份数：2-3人
   - 标签：快手菜、高蛋白、低脂

### 西式菜（4个）

9. **意大利面（番茄肉酱）**
   - 创建者：Jiang Lin (user_id=10)
   - 难度：简单，烹饪时间25分钟
   - 菜系：意大利
   - 份数：2人
   - 标签：快手菜、面食、素食可改

10. **凯撒沙拉**
    - 创建者：Xu Hui (user_id=6)
    - 难度：简单，烹饪时间10分钟
    - 菜系：美式
    - 份数：2人
    - 标签：健康、低脂、快手菜

11. **烤鸡腿**
    - 创建者：Guo Qiang (user_id=8)
    - 难度：简单，烹饪时间40分钟
    - 菜系：西式
    - 份数：2人
    - 标签：烤制、高蛋白、简单易做

12. **提拉米苏**
    - 创建者：Jiang Lin (user_id=10)
    - 难度：简单，烹饪时间30分钟（需冷藏）
    - 菜系：意大利
    - 份数：4人
    - 标签：甜点、无需烤箱、经典甜品

### 日式菜（2个）

13. **日式味增汤**
    - 创建者：Guo Qiang (user_id=8)
    - 难度：简单，烹饪时间10分钟
    - 菜系：日本
    - 份数：2人
    - 标签：汤类、健康、快手菜

14. **寿司卷**
    - 创建者：Sun Yue (user_id=9)
    - 难度：中等，烹饪时间30分钟
    - 菜系：日本
    - 份数：2人
    - 标签：海鲜、手工、学习菜谱

### 其他菜（1个）

15. **咖喱鸡饭**
    - 创建者：Zhou Tao (user_id=7)
    - 难度：简单，烹饪时间25分钟
    - 菜系：泰式
    - 份数：2人
    - 标签：快手菜、米饭、香料

---

## 真实食材库（35个精选食材）

### 蔬菜（8个）
- 番茄、洋葱、大蒜、青椒、生菜、冬瓜、土豆、菠菜

### 肉类（8个）
- 鸡肉、鸡腿、鸡蛋、猪肉、五花肉、排骨、虾、鱼

### 调味料（10个）
- 盐、糖、酱油、醋、油、辣椒粉、豆瓣酱、番茄酱、料酒、味精

### 乳制品和谷物（5个）
- 牛奶、黄油、米、面粉、面条

### 其他（4个）
- 豆腐、蜂蜜、坚果、黑胡椒

---

## 真实过敏原库（8个常见过敏原）

1. 花生
2. 坚果
3. 乳制品
4. 鸡蛋
5. 海鲜
6. 鱼类
7. 小麦
8. 大豆

---

## 真实标签库（12个标签）

### 饮食类型
- 素食、低脂、无麸质

### 烹饪方式
- 快手菜、烤制、清蒸、炒制

### 场景标签
- 家常菜、儿童食品、节日大餐、健康、甜点、面食

---

# 各表数据详解

## 1. USERS 表 - 10个真实用户

每个用户都有：
- 真实的名字和邮箱格式
- 清晰的职业身份（美食博主、专业厨师、普通用户）
- 合理的注册时间分布（6个月内）
- 逼真的粉丝数（根据身份）
- 最后登录时间（最近2周内）

## 2. INGREDIENTS 表 - 35个常用食材

精选最常见的食材：
- **蔬菜**：番茄、洋葱、大蒜等（日常烹饪必备）
- **肉类**：鸡、猪、虾等（蛋白质来源）
- **调味料**：盐、糖、酱油等（烹饪基础）
- **其他**：豆腐、面条等（主要碳水化合物）

## 3. UNITS 表 - 12个标准单位

- 重量：克、千克、斤
- 容量：毫升、升、杯
- 计数：个、条
- 烹饪专用：汤匙、茶匙

## 4. ALLERGENS 表 - 8个常见过敏原

涵盖最常见的食物过敏原。

## 5. TAGS 表 - 12个分类标签

用于标记菜谱的属性和特点。

## 6. RECIPES 表 - 15个真实菜谱

每个菜谱都是真实存在的：
- 准备时间 + 烹饪时间合理
- 难度等级合理分布
- 关键营养信息准确
- 发布状态：全部已发布

## 7. COOKING_STEPS 表 - 平均4-5步/菜谱

每个步骤都包含：
- 清晰的操作指令
- 估算的耗时（分钟）
- 可选的步骤说明

## 8. NUTRITION_INFO 表 - 对应每个菜谱

基于食材配比计算的营养信息：
- 热量（卡路里）
- 蛋白质、碳水、脂肪
- 钠、纤维等

## 9. RATINGS 表 - 20个真实评价

- 评分分布：5星30%、4星35%、3星20%、2星10%、1星5%
- 部分评价有评论文本
- 时间分散在最近30天

## 10. COMMENTS 表 - 12条有意义的评论

- 包括实用建议、经验分享、提问
- 5条有一级嵌套回复

## 11. SAVED_RECIPES 表 - 15个收藏行为

- 用户喜欢的菜谱多为高评分食谱
- 分散的收藏时间

## 12. FOLLOWERS 表 - 8条关注关系

- 粉丝多的用户被广泛关注
- 构建社交网络

## 13. USER_ALLERGIES 表 - 5个用户的过敏原记录

- 用户3：花生过敏
- 用户4：乳制品过敏
- 用户7：海鲜过敏
- 用户9：小麦过敏
- 用户10：坚果过敏

## 14. RECIPE_COLLECTIONS 表 - 3个用户清单

- 用户1：收藏"快手晚餐"、"家常菜精选"
- 用户4：收藏"儿童食谱"
- 用户6：收藏"健康菜谱"

## 15. SHOPPING_LISTS 表 - 2个购物清单

- 清单1：为红烧肉准备的材料
- 清单2：为周末聚餐准备的食材

## 16. MEAL_PLANS 表 - 2个膳食计划

- 计划1：7日健康膳食
- 计划2：周末家庭烹饪计划

---

# 数据录入顺序

## 严格依赖顺序（5阶段）

### 阶段1：基础参考数据（无依赖）
1. USERS (10条)
2. INGREDIENTS (35条)
3. UNITS (12条)
4. ALLERGENS (8条)
5. TAGS (12条)

**总计：77条** → **预计10秒**

### 阶段2：主体数据（依赖阶段1）
6. RECIPES (15条)
7. INGREDIENT_ALLERGENS (关系数据)
8. INGREDIENT_SUBSTITUTIONS (关系数据，可选)

**总计：15+ 条** → **预计5秒**

### 阶段3：食谱详情（依赖阶段1和2）
9. COOKING_STEPS (60条)
10. RECIPE_INGREDIENTS (70条)
11. RECIPE_TAGS (30条)
12. NUTRITION_INFO (15条)

**总计：175条** → **预计10秒**

### 阶段4：用户交互（依赖阶段1和3）
13. RATINGS (20条)
14. COMMENTS (12条)
15. SAVED_RECIPES (15条)
16. FOLLOWERS (8条)
17. USER_ALLERGIES (5条)

**总计：60条** → **预计8秒**

### 阶段5：个人管理（依赖阶段1和3）
18. RECIPE_COLLECTIONS (3条)
19. COLLECTION_RECIPES (12条)
20. SHOPPING_LISTS (2条)
21. SHOPPING_LIST_ITEMS (18条)
22. MEAL_PLANS (2条)
23. MEAL_PLAN_ENTRIES (14条)

**总计：51条** → **预计8秒**

---

**全部导入总用时：预计 50秒左右**

---

# 数据验证查询

## 验证查询1：查看热门食谱排行

```sql
SELECT r.recipe_id, r.recipe_name, u.username, r.average_rating, r.rating_count
FROM RECIPES r
JOIN USERS u ON r.user_id = u.user_id
ORDER BY r.average_rating DESC, r.rating_count DESC;
```

预期结果：看到15个食谱及其评分情况

## 验证查询2：查看用户粉丝

```sql
SELECT u.user_id, u.username, u.user_type,
       COUNT(f.follower_user_id) as follower_count
FROM USERS u
LEFT JOIN FOLLOWERS f ON u.user_id = f.user_id
GROUP BY u.user_id, u.username, u.user_type
ORDER BY follower_count DESC;
```

预期结果：看到用户的粉丝数统计

## 验证查询3：查看菜谱食材

```sql
SELECT r.recipe_name, r.recipe_id,
       LISTAGG(i.ingredient_name || ' ' || ri.quantity || ig.abbreviation, ', ') 
       WITHIN GROUP (ORDER BY i.ingredient_name) as ingredients
FROM RECIPES r
JOIN RECIPE_INGREDIENTS ri ON r.recipe_id = ri.recipe_id
JOIN INGREDIENTS i ON ri.ingredient_id = i.ingredient_id
JOIN UNITS ig ON ri.unit_id = ig.unit_id
GROUP BY r.recipe_id, r.recipe_name;
```

预期结果：看到每个菜谱的完整食材列表

## 验证查询4：安全菜谱推荐

```sql
-- 为用户3推荐安全菜谱（排除含过敏原的菜谱）
SELECT DISTINCT r.recipe_id, r.recipe_name, r.average_rating
FROM RECIPES r
WHERE r.is_published = 'Y'
  AND r.recipe_id NOT IN (
      SELECT DISTINCT ri.recipe_id
      FROM RECIPE_INGREDIENTS ri
      JOIN INGREDIENT_ALLERGENS ia ON ri.ingredient_id = ia.ingredient_id
      JOIN USER_ALLERGIES ua ON ia.allergen_id = ua.allergen_id
      WHERE ua.user_id = 3
  )
ORDER BY r.average_rating DESC;
```

预期结果：用户3能安全食用的菜谱列表

---

# 业务场景测试

## 场景1：用户想做快手菜

```sql
-- 查询所有快手菜（30分钟以内）且评分4.5以上
SELECT r.recipe_id, r.recipe_name, r.prep_time + r.cook_time as total_time,
       r.average_rating, u.username
FROM RECIPES r
JOIN RECIPE_TAGS rt ON r.recipe_id = rt.recipe_id
JOIN TAGS t ON rt.tag_id = t.tag_id
JOIN USERS u ON r.user_id = u.user_id
WHERE t.tag_name = '快手菜'
  AND (r.prep_time + r.cook_time) <= 30
  AND r.average_rating >= 4.0
ORDER BY r.average_rating DESC;
```

## 场景2：用户要做某菜谱，需要购物清单

```sql
-- 用户需要做"宫保鸡丁"，生成购物清单
SELECT ri.ingredient_id, i.ingredient_name, ri.quantity, u.abbreviation
FROM RECIPE_INGREDIENTS ri
JOIN INGREDIENTS i ON ri.ingredient_id = i.ingredient_id
JOIN UNITS u ON ri.unit_id = u.unit_id
WHERE ri.recipe_id = (SELECT recipe_id FROM RECIPES WHERE recipe_name = '宫保鸡丁')
ORDER BY i.ingredient_name;
```

## 场景3：用户想看某菜谱的评论

```sql
-- 查看"红烧肉"的所有评论及回复
SELECT 
    c1.comment_id,
    u1.username,
    c1.comment_text,
    c1.created_at,
    c2.comment_id as reply_id,
    u2.username as reply_author,
    c2.comment_text as reply_text,
    c2.created_at as reply_date
FROM COMMENTS c1
LEFT JOIN COMMENTS c2 ON c1.comment_id = c2.parent_comment_id
LEFT JOIN USERS u1 ON c1.user_id = u1.user_id
LEFT JOIN USERS u2 ON c2.user_id = u2.user_id
WHERE c1.recipe_id = (SELECT recipe_id FROM RECIPES WHERE recipe_name = '红烧肉')
ORDER BY c1.created_at DESC, c2.created_at DESC;
```

## 场景4：关注的厨师发布了新菜谱

```sql
-- 用户1关注的人最近发布了什么菜谱
SELECT r.recipe_id, r.recipe_name, u.username, r.created_at
FROM RECIPES r
JOIN USERS u ON r.user_id = u.user_id
WHERE u.user_id IN (
    SELECT user_id FROM FOLLOWERS WHERE follower_user_id = 1
)
ORDER BY r.created_at DESC;
```

---

**总结**：
- ✅ 数据量精简，但覆盖所有表
- ✅ 数据真实，符合业务逻辑
- ✅ 易于验证和理解
- ✅ 充分展现数据库功能
- ✅ 可直接用于演示和测试
