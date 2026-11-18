import os
output_path = r'S:/solid mech project/FUSESAFE_M4_Working/16_P1P4_Optimization_Project/Optimization_Runs_P1P4/OPT_20261110_171551_317/mechanical_tree_inspection.txt'
f = open(output_path, 'w')

def inspect_object(obj, level, f):
    try:
        name = str(obj.Name)
    except:
        name = str(obj)
    try:
        type_name = obj.GetType().FullName
    except:
        type_name = 'Unknown type'
    f.write(' ' * level + name + ' | ' + type_name + '\n')
    try:
        children = obj.Children
        for i in range(children.Count):
            inspect_object(children[i], level + 2, f)
    except:
        pass

try:
    f.write('FUSESAFE MECHANICAL TREE\n')
    f.write('Analysis count: %s\n' % Model.Analyses.Count)
    for i in range(Model.Analyses.Count):
        analysis = Model.Analyses[i]
        f.write('\nANALYSIS: %s\n' % analysis.Name)
        f.write('SOLUTION TREE:\n')
        inspect_object(analysis.Solution, 2, f)
    try:
        f.write('\nGEOMETRY TREE:\n')
        inspect_object(Model.Geometry, 2, f)
    except:
        f.write('Geometry tree unavailable\n')
    try:
        f.write('\nMESH TREE:\n')
        inspect_object(Model.Mesh, 2, f)
    except:
        f.write('Mesh tree unavailable\n')
    f.write('\nINSPECTION_COMPLETE\n')
finally:
    f.close()
