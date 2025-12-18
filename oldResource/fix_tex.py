import re
import os

def restore():
    md_path = r'e:\@DataBase\RecipeRecommendation\正式报告\report.md'
    tex_path = r'e:\@DataBase\RecipeRecommendation\正式报告\report.tex'
    output_path = r'e:\@DataBase\RecipeRecommendation\正式报告\report_fixed.tex'

    with open(md_path, 'r', encoding='utf-8') as f:
        md_lines = f.readlines()
    
    with open(tex_path, 'r', encoding='utf-8', errors='ignore') as f:
        tex_lines = f.readlines()

    # Create a mapping of "clean" text to original MD text
    def clean(text):
        # Remove MD markers
        text = re.sub(r'\*\*|#|`|!\[\]\(.*?\)\{.*?\}|\[.*?\]\{.*?\}', '', text)
        # Remove LaTeX markers (simplified)
        text = re.sub(r'\\textbf\{|\\textit\{|\\uline\{|\\texttt\{|\}', '', text)
        # Remove common punctuation for matching
        text = re.sub(r'[，。？！：；（）\(\)\{\}\[\]\s]', '', text)
        return text

    md_map = {}
    for line in md_lines:
        c = clean(line)
        if len(c) > 5: # Only map substantial lines
            md_map[c] = line.strip()

    new_tex_lines = []
    for line in tex_lines:
        if '?' in line:
            c = clean(line.replace('?', ''))
            # Try to find a match in md_map
            match = None
            if c in md_map:
                match = md_map[c]
            else:
                # Try fuzzy match (if c is a substring of some md_map key or vice versa)
                for k in md_map:
                    if c and (c in k or k in c):
                        match = md_map[k]
                        break
            
            if match:
                # This is a very crude replacement. 
                # We want to keep the LaTeX structure but replace the text.
                # For now, let's just log it and try a more targeted approach.
                pass
        
        new_tex_lines.append(line)

    # Actually, let's just do a direct replacement of known garbled characters
    # based on the MD file content.
    
    full_tex = "".join(tex_lines)
    
    # Common replacements observed
    repls = {
        '图片?': '图片。',
        '食谱?': '食谱。',
        '文化?': '文化。',
        '计划性?': '计划性。',
        '功能?': '功能。',
        '平台使用?': '平台使用者',
        '账户状?': '账户状态',
        '一?一月食谱安?': '一周/一月食谱安排',
        '购买状?': '购买状态',
        '有用性评?': '有用性评分',
        '关注关?': '关注关系',
        '预?-> 发布': '预览 -> 发布',
        '评?-> 添加': '评论 -> 添加',
        '收?清单': '收藏清单',
        '评?': '评论',
        '食?-> 系统': '食谱 -> 系统',
        '等?': '等）',
        '规范?': '规范：',
        '范式?NF）': '范式（1NF）',
        '表，?': '表，如',
        '依赖?': '依赖于',
        '组合）?': '组合）。',
        '冗余?': '冗余。',
        '键?': '键。',
        '字?': '字典',
        '关?': '关系',
        '唯一?': '唯一性',
        '数?': '数据',
        '系?': '关系表',
        '评?': '评价',
        '审?': '审计',
        '清?': '清单',
        '食?': '食谱',
        '排?': '排序',
        '计?': '计数',
        '回复?': '回复）',
        '记?': '记录',
        '推?': '推荐',
        '例?': '比例',
        '注?': '注册',
        '据?': '数据',
        '夹?': '夹',
        '项?': '项',
        '原?': '原',
        '信?': '信息',
        '时?': '时间',
        '数据?': '数据）',
        '勾?': '勾选',
        '收?': '收藏',
        '条?': '条目',
        '评?评论?': '评价/评论',
        '有用"标记': '“有用”标记',
        '非空?': '非空。',
        '完整性?': '完整性。',
        '重复?': '重复。',
        '值域?': '值域。',
        '有值?': '有值。',
        '填充?': '填充。',
        '用户?': '用户表',
        '食材?': '食材表',
        '单位?': '单位表',
        '过敏原表?': '过敏原表',
        '标签?': '标签表',
        '食谱?': '食谱表',
        '被关注?': '被关注者',
        '关注?': '关注者',
        '自关?': '自关注',
        '日志?': '日志表',
        '清单?': '清单表',
        '项目?': '项目表',
        '计划?': '计划表',
        '条目?': '条目表',
        '重?': '重复',
        '部?': '部分',
        '日?': '日期',
        '餐型?': '餐型',
        '等?': '等）',
        '自?': '自增',
        '哈希?': '哈希值',
        '杯?': '杯）',
        'cup?': 'cup）',
        '发?': '发布',
        '部?': '部分',
        '关系?': '关系表',
        '序号?': '序号（',
        '关系?': '关系）',
        '里?': '里）',
        '克?': '克）',
        '毫克?': '毫克）',
        '如?': '如：',
        '评分?': '评分值',
        '投票?': '投票数',
        '引用?': '引用）',
        'Y/N?': 'Y/N）',
        '开始日?': '开始日期',
        '评分?': '评分',
        '用户?': '用户动态',
        '贡献?': '贡献者',
        '过程?': '过程。',
        '访问?': '访问。',
        '等?': '等。',
        '灾备?': '灾备。',
        '行为?': '行为。',
        '分析?': '分析。',
        '字段?': '字段。',
        '访问?': '访问。',
        '引用?': '引用。',
        '注入?': '注入。',
        '存储?': '存储。',
        '结果?': '结果。',
        '分?': '分析',
        '恢?': '恢复',
        '字?': '字段',
        '哈?': '哈希',
        '密?': '密码',
        '?': '✓', # This is what I saw in the read_file output for checkmarks
    }

    for old, new in repls.items():
        full_tex = full_tex.replace(old, new)
    
    # Fix the checkmarks specifically
    full_tex = full_tex.replace('?', '✓')
    
    # Fix the section titles and other things that might have been missed
    # by doing a more global replacement of '?' with punctuation if it fits
    full_tex = re.sub(r'([\u4e00-\u9fa5])\?(\s|\\|&|$)', r'\1。\2', full_tex)
    full_tex = re.sub(r'([\u4e00-\u9fa5])\?([\u4e00-\u9fa5])', r'\1，\2', full_tex)

    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(full_tex)

if __name__ == "__main__":
    restore()
