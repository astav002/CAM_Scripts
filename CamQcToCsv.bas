Attribute VB_Name = "CamQcToCsv"
Function GetFile()
    
    Set fle = Application.FileDialog(msoFileDialogOpen)
    
    With fle
        .AllowMultiSelect = False
        .Title = "Please select the file"
        .Filters.Clear
        .Filters.Add "Images", "*.qaf"
        If .Show = True Then
            fleName = .SelectedItems(1)
            Debug.Print .SelectedItems(1)
        End If
    End With
    
    GetFile = fleName
End Function

Function GetCam()
    Dim dSrc As CamDatasource
    Set dSrc = New CamDatasource
    
    fle = GetFile()
    dSrc.Open fle
    
    Set fso = CreateObject("Scripting.FileSystemObject")
    Set csv = fso.OpenTextFile(fle & ".csv", 8, True)
       
    
    cnt_entries = dSrc.Count(ClassCodes.CAM_CLS_QAPDR)
    cnt_records = dSrc.Count(ClassCodes.CAM_CLS_QARREC)
    
    For i = 1 To cnt_records
        Name = "Date/Time"
        Value = dSrc.Parameter(ParamCodes.CAM_X_RMEASR, i)
        
        For j = 1 To cnt_entries
            
                Name = Name & ", " & dSrc.Parameter(ParamCodes.CAM_T_PDESC, j)
                Value = Value & ", " & dSrc.Parameter(ParamCodes.CAM_F_RVALUE, i, j)

        Next j
        If i = 1 Then
            Debug.Print (Name)
            csv.WriteLine (Name)
        End If
            csv.WriteLine (Value)
        If i < 10 Then
            Debug.Print (Value)
        End If
    Next i
    
    Debug.Print (Title)
    

    

End Function
