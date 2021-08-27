Attribute VB_Name = "cams2csv"
Option Compare Database

Public Sub process_directory()
    work_dir = InputBox("Enter the directory to process")
    'work_dir = "C:\GENIE2K\CAMFILES\isotope_project\2021"
    Set fso = CreateObject("Scripting.FileSystemObject")
    
    If Not fso.FolderExists(work_dir) Then
        MsgBox ("Sorry, Directory not found")
        Exit Sub
    End If
    
    Set Files = fso.GetFolder(work_dir).Files
    
    For Each f In Files
        If fso.GetExtensionName(f.Name) = "CNF" Then
            get_file f.Name, work_dir
            Debug.Print (f.Name)
        End If
    
    Next

End Sub

Public Sub get_file(file_name As String, work_dir)
    Dim oDs As New CamDatasource
    Set oDs = New CamDatasource
    
    
    out_text = "out_file1.csv"
    Debug.Print ("Outputing to :" & work_dir & "\" & out_text)
    Set fso = CreateObject("Scripting.FileSystemObject")
    
    If fso.FileExists(work_dir & out_text) Then
        
        Set out_file = fso.OpenTextFile(work_dir & out_text, 8)
        
    Else
        header = "title, ana_date, s_date, nuclide, energy (keV), line_activity, activity_error, peak_area, peak_unc, continuum, ambient_bkg, centroid"
        Set out_file = fso.CreateTextFile(work_dir & out_text, False)
        out_file.WriteLine (header)
    End If
    
    oDs.Open work_dir & "\" & file_name, camReadOnly, camFile
    
    Call loop_lines(oDs, oDs.Parameter(ParamCodes.CAM_T_STITLE), out_file)
    
    
End Sub

Public Sub loop_lines(oDs As CamDatasource, smp_name As String, out_file)

    
    nucl_lines = oDs.Count(ClassCodes.CAM_CLS_NLINES)
    ana_date = oDs.Parameter(ParamCodes.CAM_X_ASTIME)
    s_date = oDs.Parameter(ParamCodes.CAM_X_STIME)
    

    For i = 1 To nucl_lines
        nclines = oDs.Parameter(ParamCodes.CAM_L_NCLLINE)
        
        ' if nonzero, the peak associated with this line energy was identified
        nl_peak = oDs.Parameter(ParamCodes.CAM_L_NLPEAK, i)
        
        ' this is the nuclide associated with this energy line, there can me multiple nuclides per line
        nl_nucl = oDs.Parameter(ParamCodes.CAM_L_NLNUCL, i)
        
        ' if the peak was identified
        If nl_peak <> 0 Then
            peak_area = oDs.Parameter(ParamCodes.CAM_F_PSAREA, nl_peak)
            peak_unc = oDs.Parameter(ParamCodes.CAM_F_PSDAREA, nl_peak)
            peak_cont = oDs.Parameter(ParamCodes.CAM_F_PSBACKGND, nl_peak)
            peak_bkg = oDs.Parameter(ParamCodes.CAM_F_PSAMBBACK, nl_peak)
            centroid = oDs.Parameter(ParamCodes.CAM_F_PSENERGY, nl_peak)

            'if the nuclide was identified
            If oDs.Parameter(ParamCodes.CAM_L_NCLFIDENT, nl_nucl) = 1 Then
            
                ene = (oDs.Parameter(ParamCodes.CAM_F_NLENERGY, i))
                nme = (oDs.Parameter(ParamCodes.CAM_T_NCLNAME, nl_nucl))
                nl_act = (oDs.Parameter(ParamCodes.CAM_G_NLACTVTY, i))
                nl_act_err = (oDs.Parameter(ParamCodes.CAM_G_NLERR, i))
                
                vals = smp_name & ", " & ana_date & ", " & s_date & ", " & nme & ", " & ene & _
                    " keV, " & nl_act & ", " & nl_act_err & "," & _
                    peak_area & ", " & peak_unc & ", " & peak_cont & ", " & peak_bkg & ", " & centroid
                
                out_file.WriteLine (vals)
                Debug.Print (vals)
                
            End If
        End If
        
    Next i

End Sub





