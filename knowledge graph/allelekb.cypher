LOAD CSV WITH HEADERS FROM 'file:///annnotationTool.csv' as row create (n: annnotationTool) set n = row;
match(n:cellType) delete n;
LOAD CSV WITH HEADERS FROM 'file:///cellType.csv' as row create (n: cellType) set n = row;
match(n:subcellType) delete n;
LOAD CSV WITH HEADERS FROM 'file:///subcellType.csv' as row create (n: subcellType) set n = row;
LOAD CSV WITH HEADERS FROM 'file:///gene.csv' as row create (n: gene) set n = row;
LOAD CSV WITH HEADERS FROM 'file:///literature.csv' as row create (n: literature) set n = row;

// relationship
LOAD CSV WITH HEADERS FROM 'file:///annotationTool_gene.csv' as row 
create (n: annotationTool_gene) set n = row;
match (c:annnotationTool),(d:annotationTool_gene),(a:gene) where c.AnnId = d.AnnId and a.GeneId = d.GeneId
create (a) -[r:identified_by{log2foldchange:d.avg_log2FC, p_val:d.p_val} ]->(c)
return c, a;
match (n:annotationTool_gene) delete n;

LOAD CSV WITH HEADERS FROM 'file:///literaturetrue_gene.csv' as row 
create (n: literatrue_gene) set n = row;
match (c:literature),(d:literatrue_gene),(a:gene) where c.LitId = d.LitId and a.GeneId = d.GeneId
create (c) -[r:describes]->(a)
return c, a;
match (n:literatrue_gene) delete n;

LOAD CSV WITH HEADERS FROM 'file:///subcellType_gene.csv' as row 
create (n: subcellType_gene) set n = row;
match (c:subcellType),(d:subcellType_gene),(a:gene) where c.SubCellTypeId = d.SubCellTypeId and a.GeneId = d.GeneId
create (a) -[r:is_expressed_in]->(c)
return c, a;
match (n:subcellType_gene) delete n;

match (a:cellType),(b:subcellType) where a.CellTypeId = b.CellTypeId create (b)-[r:is_a_type_of]->(a) return a, b;




