import os, traceback

out_dir = r'S:\solid mech project\FUSESAFE_M4_Working\16_P1P4_Optimization_Project\Optimization_Runs_P1P4\OPT_20261110_171551_317'
status_path = os.path.join(out_dir,'image_export_status.txt')
log = open(status_path,'w')
failed = []

def export_result(result, filename):
    try:
        result.Activate()
        camera = Graphics.Camera
        camera.SetSpecificViewOrientation(ViewOrientationType.Iso)
        camera.SetFit()
        settings = Ansys.Mechanical.Graphics.GraphicsImageExportSettings()
        settings.Resolution = GraphicsResolutionType.EnhancedResolution
        output_path = os.path.join(out_dir,filename)
        Graphics.ExportImage(output_path,GraphicsImageExportFormat.PNG,settings)
        log.write('SUCCESS: ' + filename + '\n')
    except Exception:
        failed.append(filename)
        log.write('FAILED: ' + filename + '\n')
        log.write(traceback.format_exc() + '\n')

try:
    analysis = Model.Analyses[0]
    solution = analysis.Solution

    stress_result = None
    deformation_result = None

    for obj in solution.Children:
        if obj.Name == 'Equivalent Stress':
            stress_result = obj
        elif obj.Name == 'Total Deformation':
            deformation_result = obj

    if stress_result is None:
        raise Exception('Equivalent Stress result not found.')
    if deformation_result is None:
        raise Exception('Total Deformation result not found.')

    export_result(stress_result,'stress_contour.png')
    export_result(deformation_result,'deformation_contour.png')

    try:
        Model.Geometry.Activate()
    except:
        Tree.Activate([Model.Geometry])

    camera = Graphics.Camera
    camera.SetSpecificViewOrientation(ViewOrientationType.Iso)
    camera.SetFit()

    settings = Ansys.Mechanical.Graphics.GraphicsImageExportSettings()
    settings.Resolution = GraphicsResolutionType.EnhancedResolution

    geometry_path = os.path.join(out_dir,'geometry_3d.png')
    Graphics.ExportImage(geometry_path,GraphicsImageExportFormat.PNG,settings)
    log.write('SUCCESS: geometry_3d.png\n')

except Exception:
    failed.append('SCRIPT_FATAL')
    log.write(traceback.format_exc() + '\n')

log.write('FAILED_COUNT=' + str(len(failed)) + '\n')
log.write('NO_SOLVE_COMMAND_ISSUED=True\n')
log.write('SOURCE_DESIGN_POINT=DP 98\n')
log.write('SOURCE_P1_MM=7\n')
log.write('SOURCE_P4_MM=-2.5\n')
log.close()
