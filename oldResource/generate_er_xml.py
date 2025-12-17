import re
import xml.etree.ElementTree as ET
import math
import os

# Absolute paths
base_dir = r'e:\@DataBase\RecipeRecommendation'
sql_file_path = os.path.join(base_dir, 'createtable_pg.sql')
output_xml_path = os.path.join(base_dir, 'recipe_er_diagram.xml')

def parse_sql(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        sql_content = f.read()

    tables = {}
    
    # Regex for table creation
    table_pattern = re.compile(r'CREATE TABLE (\w+)\s*\((.*?)\);', re.DOTALL | re.IGNORECASE)
    matches = table_pattern.findall(sql_content)

    for table_name, content in matches:
        columns = []
        pks = []
        fks = []
        
        # Clean up content
        lines = content.split('\n')
        for line in lines:
            line = line.strip()
            if not line or line.startswith('--'):
                continue
            
            # Remove trailing comma
            if line.endswith(','):
                line = line[:-1]
            
            # Check for constraints
            if 'PRIMARY KEY' in line.upper() and 'CONSTRAINT' not in line.upper():
                # Inline PK or table level PK
                if line.upper().startswith('PRIMARY KEY'):
                    # Table level
                    pk_match = re.search(r'\((.*?)\)', line)
                    if pk_match:
                        pks.extend([x.strip() for x in pk_match.group(1).split(',')])
                else:
                    # Column level
                    parts = line.split()
                    col_name = parts[0]
                    columns.append({'name': col_name, 'type': ' '.join(parts[1:])})
                    pks.append(col_name)
            elif 'FOREIGN KEY' in line.upper():
                # CONSTRAINT fk_name FOREIGN KEY (col) REFERENCES table(col)
                fk_match = re.search(r'FOREIGN KEY\s*\((.*?)\)\s*REFERENCES\s*(\w+)\s*\((.*?)\)', line, re.IGNORECASE)
                if fk_match:
                    local_col = fk_match.group(1).strip()
                    ref_table = fk_match.group(2).strip()
                    fks.append({'local_col': local_col, 'ref_table': ref_table})
            elif 'CONSTRAINT' in line.upper() and 'PRIMARY KEY' in line.upper():
                 pk_match = re.search(r'PRIMARY KEY\s*\((.*?)\)', line, re.IGNORECASE)
                 if pk_match:
                    pks.extend([x.strip() for x in pk_match.group(1).split(',')])
            elif 'UNIQUE' in line.upper() and 'CONSTRAINT' in line.upper():
                pass # Ignore unique constraints for now
            else:
                # Regular column
                parts = line.split()
                if len(parts) > 0:
                    col_name = parts[0]
                    # Check if it's a constraint line starting with CONSTRAINT
                    if col_name.upper() == 'CONSTRAINT':
                        continue
                    
                    # Check if already added (inline PK case handled above)
                    if not any(c['name'] == col_name for c in columns):
                         columns.append({'name': col_name, 'type': ' '.join(parts[1:])})

        tables[table_name] = {
            'columns': columns,
            'pks': pks,
            'fks': fks
        }
    return tables

def classify_tables(tables):
    entities = []
    relationships = []
    
    pure_relationships = [
        'RECIPE_INGREDIENTS', 'SAVED_RECIPES', 'RECIPE_TAGS', 'FOLLOWERS', 
        'COLLECTION_RECIPES', 'INGREDIENT_ALLERGENS', 'SHOPPING_LIST_ITEMS', 'RATINGS'
    ]

    for name, data in tables.items():
        if name in pure_relationships:
            relationships.append(name)
        else:
            entities.append(name)
            
    return entities, relationships

def generate_full_xml(tables, entities, relationships):
    root = ET.Element("mxfile", host="Electron", modified="2023-10-01T00:00:00.000Z", agent="5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) draw.io/21.0.0 Chrome/112.0.5615.204 Electron/24.3.0 Safari/537.36", etag="abcdef", version="21.0.0", type="device")
    diagram = ET.SubElement(root, "diagram", id="diagram_1", name="Page-1")
    mxGraphModel = ET.SubElement(diagram, "mxGraphModel", dx="1422", dy="798", grid="1", gridSize="10", guides="1", tooltips="1", connect="1", arrows="1", fold="1", page="1", pageScale="1", pageWidth="3000", pageHeight="3000", math="0", shadow="0")
    root_cell = ET.SubElement(mxGraphModel, "root")
    
    ET.SubElement(root_cell, "mxCell", id="0")
    ET.SubElement(root_cell, "mxCell", id="1", parent="0")
    
    cell_id = 2
    entity_ids = {}
    entity_positions = {}
    
    # Styles
    style_entity = "rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;"
    style_weak_entity = "rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;shape=ext;double=1;"
    style_relationship = "rhombus;whiteSpace=wrap;html=1;fillColor=#ffe6cc;strokeColor=#d79b00;"
    style_attribute = "ellipse;whiteSpace=wrap;html=1;fillColor=#f5f5f5;fontColor=#333333;strokeColor=#666666;"
    style_pk_attribute = "ellipse;whiteSpace=wrap;html=1;fillColor=#f5f5f5;fontColor=#333333;strokeColor=#666666;fontStyle=4;"
    style_derived_attribute = "ellipse;whiteSpace=wrap;html=1;fillColor=#f5f5f5;fontColor=#333333;strokeColor=#666666;dashed=1;"
    
    # Grid layout for entities
    grid_cols = 4
    col_spacing = 700
    row_spacing = 700
    start_x = 100
    start_y = 100
    
    # 1. Draw Entities
    for i, entity_name in enumerate(entities):
        row = i // grid_cols
        col = i % grid_cols
        x = start_x + col * col_spacing
        y = start_y + row * row_spacing
        
        entity_positions[entity_name] = (x, y)
        
        style = style_entity
        if entity_name in ['COOKING_STEPS', 'NUTRITION_INFO', 'COMMENTS']: # Heuristic for weak entities
             style = style_weak_entity

        mx_cell = ET.SubElement(root_cell, "mxCell", id=str(cell_id), value=entity_name, style=style, vertex="1", parent="1")
        ET.SubElement(mx_cell, "mxGeometry", x=str(x), y=str(y), width="120", height="60", as="geometry")
        entity_ids[entity_name] = cell_id
        current_entity_id = cell_id
        cell_id += 1
        
        # Attributes
        cols = tables[entity_name]['columns']
        pks = tables[entity_name]['pks']
        
        attr_radius = 200
        angle_step = 360 / len(cols) if len(cols) > 0 else 0
        
        for j, col in enumerate(cols):
            col_name = col['name']
            is_pk = col_name in pks
            is_derived = col_name in ['total_followers', 'total_recipes', 'average_rating', 'rating_count', 'helpful_count']
            
            attr_style = style_pk_attribute if is_pk else (style_derived_attribute if is_derived else style_attribute)
            
            angle_rad = math.radians(j * angle_step)
            attr_x = x + 60 + attr_radius * math.cos(angle_rad) - 50
            attr_y = y + 30 + attr_radius * math.sin(angle_rad) - 20
            
            mx_cell = ET.SubElement(root_cell, "mxCell", id=str(cell_id), value=col_name, style=attr_style, vertex="1", parent="1")
            ET.SubElement(mx_cell, "mxGeometry", x=str(attr_x), y=str(attr_y), width="100", height="40", as="geometry")
            attr_id = cell_id
            cell_id += 1
            
            # Edge
            mx_edge = ET.SubElement(root_cell, "mxCell", id=str(cell_id), style="endArrow=none;html=1;rounded=0;entryX=0.5;entryY=0.5;entryDx=0;entryDy=0;exitX=0.5;exitY=0.5;exitDx=0;exitDy=0;", edge="1", parent="1", source=str(current_entity_id), target=str(attr_id))
            ET.SubElement(mx_edge, "mxGeometry", relative="1", as="geometry")
            cell_id += 1

    # 2. Draw Relationships
    for rel_name in relationships:
        fks = tables[rel_name]['fks']
        connected_entities = [fk['ref_table'] for fk in fks if fk['ref_table'] in entities]
        
        if connected_entities:
            avg_x = sum([entity_positions[e][0] for e in connected_entities]) / len(connected_entities)
            avg_y = sum([entity_positions[e][1] for e in connected_entities]) / len(connected_entities)
            
            if rel_name == 'FOLLOWERS':
                avg_y += 150 
        else:
            avg_x, avg_y = start_x, start_y 
            
        mx_cell = ET.SubElement(root_cell, "mxCell", id=str(cell_id), value=rel_name, style=style_relationship, vertex="1", parent="1")
        ET.SubElement(mx_cell, "mxGeometry", x=str(avg_x), y=str(avg_y), width="140", height="70", as="geometry")
        rel_id = cell_id
        cell_id += 1
        
        # Connect to Entities
        for entity in set(connected_entities):
            if entity in entity_ids:
                target_id = entity_ids[entity]
                mx_edge = ET.SubElement(root_cell, "mxCell", id=str(cell_id), style="endArrow=none;html=1;rounded=0;", edge="1", parent="1", source=str(rel_id), target=str(target_id))
                ET.SubElement(mx_edge, "mxGeometry", relative="1", as="geometry")
                cell_id += 1
                
        # Attributes of Relationship
        cols = tables[rel_name]['columns']
        fk_col_names = [fk['local_col'] for fk in fks]
        rel_pks = tables[rel_name]['pks']
        
        rel_attrs = [c for c in cols if c['name'] not in fk_col_names and c['name'] not in rel_pks]
        
        attr_radius = 130
        angle_step = 360 / len(rel_attrs) if len(rel_attrs) > 0 else 0
        
        for j, col in enumerate(rel_attrs):
            col_name = col['name']
            attr_style = style_attribute
            
            angle_rad = math.radians(j * angle_step)
            attr_x = avg_x + 70 + attr_radius * math.cos(angle_rad) - 50
            attr_y = avg_y + 35 + attr_radius * math.sin(angle_rad) - 20
            
            mx_cell = ET.SubElement(root_cell, "mxCell", id=str(cell_id), value=col_name, style=attr_style, vertex="1", parent="1")
            ET.SubElement(mx_cell, "mxGeometry", x=str(attr_x), y=str(attr_y), width="100", height="40", as="geometry")
            attr_id = cell_id
            cell_id += 1
            
            mx_edge = ET.SubElement(root_cell, "mxCell", id=str(cell_id), style="endArrow=none;html=1;rounded=0;", edge="1", parent="1", source=str(rel_id), target=str(attr_id))
            ET.SubElement(mx_edge, "mxGeometry", relative="1", as="geometry")
            cell_id += 1

    # 3. Handle Direct Foreign Keys in Entities
    for entity_name in entities:
        fks = tables[entity_name]['fks']
        for fk in fks:
            ref_table = fk['ref_table']
            if ref_table in entities:
                rel_label = "Relates"
                if entity_name == 'RECIPES' and ref_table == 'USERS': rel_label = "Creates"
                if entity_name == 'COOKING_STEPS' and ref_table == 'RECIPES': rel_label = "HasStep"
                if entity_name == 'COMMENTS' and ref_table == 'RECIPES': rel_label = "OnRecipe"
                if entity_name == 'COMMENTS' and ref_table == 'USERS': rel_label = "AuthoredBy"
                
                e1_pos = entity_positions[entity_name]
                e2_pos = entity_positions[ref_table]
                
                mid_x = (e1_pos[0] + e2_pos[0]) / 2
                mid_y = (e1_pos[1] + e2_pos[1]) / 2
                
                mx_cell = ET.SubElement(root_cell, "mxCell", id=str(cell_id), value=rel_label, style=style_relationship, vertex="1", parent="1")
                ET.SubElement(mx_cell, "mxGeometry", x=str(mid_x), y=str(mid_y), width="100", height="50", as="geometry")
                rel_id = cell_id
                cell_id += 1
                
                source_id = entity_ids[entity_name]
                target_id = entity_ids[ref_table]
                
                ET.SubElement(root_cell, "mxCell", id=str(cell_id), style="endArrow=none;html=1;rounded=0;", edge="1", parent="1", source=str(source_id), target=str(rel_id))
                cell_id += 1
                ET.SubElement(root_cell, "mxCell", id=str(cell_id), style="endArrow=none;html=1;rounded=0;", edge="1", parent="1", source=str(rel_id), target=str(target_id))
                cell_id += 1

    return root

tables = parse_sql(sql_file_path)
entities, relationships = classify_tables(tables)
xml_root = generate_full_xml(tables, entities, relationships)

tree = ET.ElementTree(xml_root)
tree.write(output_xml_path, encoding='utf-8', xml_declaration=True)
print(f"Generated {output_xml_path}")
