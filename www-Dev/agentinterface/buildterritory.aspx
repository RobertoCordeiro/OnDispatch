<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<%@ Import Namespace= "System.Data"%>
<%@ Import Namespace= "System.Data.OleDb" %>

<script runat="server">  
  
  Private _ID As Long = 0
  Private _Mode As String = ""
    
    
    Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long) 
      Master.PageHeaderText = " Build Territory"
      Master.PageTitleText = " Build Territory"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If _ID > 0 Then
      
      If Not IsPostBack Then
                
                LoadDistances()
        'LoadTerritory()
                GetLocation(_ID)
                LoadStates()
                LoadHomeZip()
                LoadEmptyLocations()
                LoadUnassignedLocations ()
                

      End If
    Else
      Response.Redirect(lblReturnUrl.Text, True)
        End If
        
  End Sub
  
  Private Sub LoadTerritory()
    'Dim add As New BridgesInterface.PartnerAddressRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
     '   add.Load(_ID)
    
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadLongStringParameterDataGrid("spFindZipCodesWithinRadius", "@Radius", cbxDistances.SelectedValue, "@ZipCode", txtHomeZip.Text.toString, dgvZips)
        If lblLocationID.Text.ToString = "" Then
            btnCreate.Text = "Create"
        Else
            btnCreate.Text = "Update"
        End If
    End Sub
    
  Private Sub LoadHomeZip()
    Dim add As New BridgesInterface.PartnerAddressRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        add.Load(_ID)
        txtHomeZip.Text = add.ZipCode
        txtLastLocation.text = GetLastLocation
        
  end sub
  
  Private Sub LoadDistances()
        Dim itm As ListItem
    
        itm = New ListItem
        itm.Text = "Choose One"
        itm.Value = 0
        cbxDistances.Items.Add(itm)
        itm = New ListItem
        itm.Text = "20 Miles"
        itm.Value = 20
        cbxDistances.Items.Add(itm)
        itm = New ListItem
        itm.Text = "25 Miles"
        itm.Value = 25
        cbxDistances.Items.Add(itm)
        itm = New ListItem
        itm.Text = "30 Miles"
        itm.Value = 30
        cbxDistances.Items.Add(itm)
        itm = New ListItem
        itm.Text = "40 Miles"
        itm.Value = 40
        cbxDistances.Items.Add(itm)
        itm = New ListItem
        itm.Text = "50 Miles"
        itm.Value = 50
        cbxDistances.Items.Add(itm)
        itm = New ListItem
        itm.Text = "60 Miles"
        itm.Value = 60
        cbxDistances.Items.Add(itm)
        itm = New ListItem
        itm.Text = "70 Miles"
        itm.Value = 70
        cbxDistances.Items.Add(itm)
        itm = New ListItem
        itm.Text = "80 Miles"
        itm.Value = 80
        cbxDistances.Items.Add(itm)
        itm = New ListItem
        itm.Text = "90 Miles"
        itm.Value = 90
        cbxDistances.Items.Add(itm)
        itm = New ListItem
        itm.Text = "100 Miles"
        itm.Value = 100
        cbxDistances.Items.Add(itm)
  End Sub
  
  Private Sub btnRebuild_Click(ByVal S As Object, ByVal E As EventArgs)
    
    LoadTerritory()
    Master.PageHeaderText = " Build Territory - Total Zips:" & dgvZips.Items.Count.ToString 
  End Sub
  
  Private Sub btnAssignLocation_Click(ByVal S As Object, ByVal E As EventArgs) Handles btnAssignLocation.Click
    If cbxEmptyLocations.SelectedValue <> "Empty Locations" And cbxUnassignedLocations.SelectedValue = "Unassigned Locations" then
        AssignLocationToAddressID (_ID,cbxEmptyLocations.SelectedValue )
            GetLocation(_ID)
    Else
        If cbxEmptyLocations.selectedValue = "Empty Locations" and cbxUnassignedLocations.SelectedValue <> "Unassigned Locations" then
           AssignLocationToAddressID (_ID, cbxUnassignedLocations.SelectedValue)
                GetLocation(_ID)
        Else
           MsgBox ("You must choose an Empty Location or an Unassigned Location, not both!")
           
        end if
    end if 
  End Sub
  
  
  
  Private Sub btnRemoveLocation_Click(ByVal S As Object, ByVal E As EventArgs) Handles btnRemoveLocation.Click
    Dim loc as New BridgesInterface.LocationRecord(system.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim lngLocationID as Long
 
    lngLocationID = loc.GetLocationByPartnerAddressID (_ID)
    If lngLocationID > 0 then
      UnassignLocationFromAddress (lngLocationID) 
      If chkRemoveZips.Checked = True then
         RemoveZipsFromLocation(lngLocationID)
                GetLocation(_ID)
      end if
    Else
      MsgBox ("There is no location assigned to this vendor.")
    End if 
     
  End Sub
  
  Private Sub btnCreateNewLocation_Click(ByVal S As Object, ByVal E As EventArgs) Handles btnCreateNewLocation.Click
    
    Dim strLocationName As String
    Dim strNum As string
    Dim strLen As string

   strLocationName = GetLastLocation()
   strNum = Right(strLocationName,5)
   strNum = Cstr(Cint(strNum) + 1)
   strLen = Len(strNum)
   Select Case strLen
   
   Case =  1
     strNum = "BSA00000" + strNum
   Case = 2
     strNum = "BSA000" + strNum
   Case = 3
     strNum = "BSA00" + strNum
   Case = 4
     strNum = "BSA0" + strNum
   end select
   
   txtLastLocation.Text = CreateNewLocation(strNum,0)
        GetLocation(_ID)
     
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
    End Sub
    
    Protected Sub dgvZips_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs)
        
        If lblSortOrder.Text.ToLower = " asc" Then
            lblSortOrder.Text = " desc"
        Else
            lblSortOrder.Text = " asc"
        End If
        
        Dim add As New BridgesInterface.PartnerAddressRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        add.Load(_ID)
        
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadLongStringParameterDataGrid("spFindZipCodesWithinRadius", "@Radius", cbxDistances.SelectedValue, "@ZipCode", add.ZipCode, dgvZips, True, e, e.SortExpression, lblSortOrder.Text)
        
        
    End Sub

  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If fup.FileName.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Upload Failed, Either the file doesn't exists or you did not enter a file name</li>"
    Else
      If Not IsAcceptableType(System.IO.Path.GetExtension(fup.FileName.Trim)) Then
        blnReturn = False
        strErrors &= "<li>Invalid File Type. Please Only Upload (JPG, TIF, GIF, PDF, or PNG)</li>"
      End If
    End If
    divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
Private Function IsAcceptableType(ByVal strExtension As String) As Boolean
    
        Dim blnReturn As Boolean = True
    Select Case strExtension.ToLower.Replace(".", "")
      Case "tif"
      Case "tiff"
      Case "jpg"
      Case "jpeg"
      Case "gif"
      Case "pdf"
      Case "png"
      Case "xls"
      Case "xlsx"
      Case Else
        blnReturn = False
    End Select
    Return blnReturn
  End Function
  
  Private Sub btnUpload_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim strPath As String = fup.FileName
    Try
            Dim MyConnection As System.Data.OleDb.OleDbConnection
            
            Dim DtSet As System.Data.DataSet
            Dim MyCommand As System.Data.OleDb.OleDbDataAdapter

            MyConnection = New System.Data.OleDb.OleDbConnection("provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & System.IO.Path.GetFullPath(fup.PostedFile.FileName) & ";Extended Properties=Excel 8.0;HDR=YES")
            MyCommand = New System.Data.OleDb.OleDbDataAdapter("select * from [Sheet1$]", MyConnection)
            MyCommand.TableMappings.Add("Table", "TestTable")
            DtSet = New System.Data.DataSet
            MyCommand.Fill(DtSet)

            dgvZips.DataSource = DtSet.Tables(0)
            dgvZips.DataBind()
            MyConnection.Close()

  Catch ex As Exception
            'Msgbox.Show(ex.Message)

  End Try
End Sub

  Private Sub dgvZips_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgvZips.ItemDataBound
        Dim nZip As New BridgesInterface.ZipCodeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim add As New BridgesInterface.PartnerAddressRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim ste As New BridgesInterface.StateRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim rowData As Data.DataRowView
        
        Dim intDistance as Integer 
        Dim lblAbbreviation As System.Web.UI.WebControls.Literal
        Dim lblCountyName As System.Web.UI.WebControls.Literal
        Dim lblDistanceInMiles As System.Web.UI.WebControls.Literal
        Dim lblPopulation As System.Web.UI.WebControls.Literal
        Dim strZip As String
        Dim strZipSource as string
        Dim strChangeLog as string
        Dim lblCityAliasName as System.Web.UI.WebControls.Literal 
        Dim lblCity as System.Web.UI.WebControls.Literal
        strChangeLog = ""
        
        add.Load(_ID)
        'strZipSource = add.ZipCode 
        strZipSource = txtHomeZip.text.ToString
        add.Save (strChangeLog)
        
        Select Case (e.Item.ItemType)
            Case ListItemType.AlternatingItem, ListItemType.EditItem, ListItemType.Item, ListItemType.SelectedItem 
                'get the data for the item being bound
                
                rowData = CType(e.Item.DataItem, Data.DataRowView)
                strZip = (rowData.Item("ZipCode"))'verifying data from excel file.
                If strZip <> "" Then
                    'e.Item.ForeColor = Drawing.Color.Red
                    nZip.Load (strZip)
                    ste.Load (nZip.StateID)
                    rowData.Item("ZipCode")= nZip.ZipCode
                    rowData.Item("ZipCodeID") = nZip.ZipCodeID
                    
                    lblCity = Ctype(e.Item.FindControl("lblCity"),System.Web.UI.WebControls.Literal)
                    lblCity.Text = nZip.City
                    
                    lblCityAliasName = Ctype(e.Item.FindControl("lblCityAliasName"),System.Web.UI.WebControls.Literal)
                    lblCityAliasName.text = nZip.CityAliasName

                    lblAbbreviation = Ctype(e.Item.FindControl("lblAbbreviation"),System.Web.UI.WebControls.Literal)
                    lblAbbreviation.Text = ste.Abbreviation 
                    
                    lblCountyName = Ctype(e.Item.FindControl("lblCountyName"),System.Web.UI.WebControls.Literal)
                    lblCountyName.Text = nZip.CountyName
                    
                    If Not IsDBNull(rowData.Item("DistanceInMiles")) or rowData.Item("DistanceInMiles") <> 0 then
                      intDistance = (rowData.Item("DistanceInMiles"))
                      lblDistanceInMiles = Ctype(e.Item.FindControl("lblDistanceInMiles"),System.Web.UI.WebControls.Literal)
                      lblDistanceInMiles.Text = intDistance
                    else
                      lblDistanceInMiles = Ctype(e.Item.FindControl("lblDistanceInMiles"),System.Web.UI.WebControls.Literal)
                      lblDistanceInMiles.Text = GetDistance(strZipSource , strZip)
                    end if
                     
                    lblPopulation = Ctype(e.Item.FindControl("lblPopulation"),System.Web.UI.WebControls.Literal)
                    'lblPopulation.Text = nZip.Population 
                    lblPopulation.Text = GetLocationByZipID(nZip.ZipCodeID)
                    
                    'lbllocationID = Ctype(e.Item.FindControl("lblLocationID"),System.Web.UI.WebControls.Literal)
                    'lblLocationID.Text = GetLocationByZipID(nZip.ZipCodeID) 
                    
                    nZip.save(strChangeLog)
                    ste.Save(strChangeLog)
                End If
                
                'datClosingDate = (rowData.Item("CloseDate"))
                'lblClosingDate = Ctype(e.Item.FindControl ("lblCloseDate"), System.Web.UI.WebControls.Literal)
                'lblClosingDate.text = FormatDateTime(datClosingDate,DateFormat.ShortDate).ToString
                
                ''get the value for the laboramount and add it to the sum
                'price = CDec(rowData.Item("LaborAmount"))
                'mListLaborTotal += price
                
                'If price = 0 And strStatus <> "Closed - Canceled" Then
                '    e.Item.ForeColor = Drawing.Color.RoyalBlue
                'End If
                
                
                ''get the control used to display the list price
                ''NOTE: This can be done by using the FindControl method of the 
                ''      passed item because ItemTemplates were used and the anchor
                ''      controls in the templates where given IDs.  If a standard
                ''      BoundColumn was used, the data would have to be accessed
                ''      using the cellscollection (e.g. e.Item.Cells(1).controls(1)
                ''      would access the label control in this example.
                'listLaborLabel = CType(e.Item.FindControl("lblLaborAmount"), System.Web.UI.WebControls.Literal)
          
                ''now format the list price in currency format
                'listLaborLabel.Text = price.ToString("C2")

                ''get the value for the extra amount and add it to the sum
                'price = CDec(rowData.Item("AdjustCharge"))
                'mListExtraTotal += price

                ''get the control used to display the discounted price
                'listExtraLabel = CType(e.Item.FindControl("lblAdjustCharge"), System.Web.UI.WebControls.Literal)
          
                ''now format the discounted price in currency format
                'listExtraLabel.Text = price.ToString("C2")
                

                ''get the value for the PartAmount and add it to the sum
                'If Not IsDBNull(rowData.Item("PartAmount")) Then
                '    price = CDec(rowData.Item("PartAmount"))
                '    mListPartTotal += price
                    
                '    If (price > 0) And (strStatus = "Closed - Resolved") and listLaborLabel.Text = 0 Then
                '       e.Item.ForeColor = Drawing.Color.DarkGreen
                '    End If
                'End If
                ''get the control used to display the PartAmount price
                'listPartLabel = CType(e.Item.FindControl("lblPartAmount"), System.Web.UI.WebControls.Literal)
          
                ''now format the discounted price in currency format
                'listPartLabel.Text = price.ToString("C2")

                ''get the value for the Total and add it to the sum
                'If Not IsDBNull(rowData.Item("Total")) Then
                '    price = CDec(rowData.Item("Total"))
                '    mListTotal += price
                'End If
                ''get the control used to display the PartAmount price
                'listTotalLabel = CType(e.Item.FindControl("lblTotal"), System.Web.UI.WebControls.Literal)
          
                ''now format the discounted price in currency format
                'listTotalLabel.Text = price.ToString("C2")
                
            Case ListItemType.Footer

                ''get the control used to display the total of the list prices
                ''and set its value to the total of the list prices
                'GrandLabortotalLabel = CType(e.Item.FindControl("lblTotalLaborAmount"), System.Web.UI.WebControls.Literal)
                'GrandLabortotalLabel.Text = mListLaborTotal.ToString("C2")
          
                ''get the control used to display the total of the extra prices
                'and set its value to the total of the discounted prices
                'GrandExtraTotalLabel = CType(e.Item.FindControl("lblTotalAdjustCharge"), System.Web.UI.WebControls.Literal)
                'GrandExtraTotalLabel.Text = mListExtraTotal.ToString("C2")
                
                'GrandPartTotalLabel = CType(e.Item.FindControl("lblTotalPartAmount"), System.Web.UI.WebControls.Literal)
                'GrandPartTotalLabel.Text = mListPartTotal.ToString("C2")
                
                'GrandTotalLabel = CType(e.Item.FindControl("lblGrandTotalAmount"), System.Web.UI.WebControls.Literal)
                'GrandTotalLabel.Text = mListTotal.ToString("C2")
                
            Case Else
                'ListItemType.Header, ListItemType.Pager, or ListItemType.Separator
                'no action required
                
        End Select
        
    End Sub  'dgvZips_ItemDataBound
    
    Private Function GetDistance (strZipSource as String, strZipTarget as String) as Integer 
      Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim cmd As New System.Data.SqlClient.SqlCommand("spGetDistance")
      Dim intDistance as integer

      cmd.CommandType = Data.CommandType.StoredProcedure
      cmd.Parameters.Add("@ZipSource",System.Data.SqlDbType.Nvarchar,16).Value = strZipSource
      cmd.Parameters.Add("@ZipTarget",System.Data.SqlDbType.NVarChar,16).value = strZipTarget
      cnn.open        
      cmd.Connection = cnn
      intDistance =  cmd.ExecuteScalar()
      cnn.Close()
      GetDistance = intDistance 
    
    End Function
    
    Private Function CreateNewLocation (strLocationName as String, intAddressID As integer) as string 
      Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim cmd As New System.Data.SqlClient.SqlCommand("spAddLocation")
      Dim intNewLocationID as integer

      cmd.CommandType = Data.CommandType.StoredProcedure
      cmd.Parameters.Add("@LocationName",System.Data.SqlDbType.Nvarchar,16).Value = strLocationName
      cmd.Parameters.Add("@PartnerAddressID",System.Data.SqlDbType.NVarChar,16).value = intAddressID
      cnn.open        
      cmd.Connection = cnn
      intNewLocationID =  cmd.ExecuteScalar()
      cnn.Close()
      CreateNewLocation = GetLocationNameByLocationID(intNewLocationID) 
    
    End Function
    
    Private Function GetLocationNameByLocationID (intLocationID As Integer) as string 
      Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim cmd As New System.Data.SqlClient.SqlCommand("spGetLocationNameByLocationID")
      
      cmd.CommandType = Data.CommandType.StoredProcedure
      cmd.Parameters.Add("@LocationID",System.Data.SqlDbType.NVarChar,16).value = intLocationID
      cnn.open        
      cmd.Connection = cnn
      GetLocationNameByLocationID =  cmd.ExecuteScalar()
      cnn.Close()
      
    
    End Function
    
    Private Sub AssignLocationToAddressID (intAddressID as Integer, intLocationID as integer)  
      Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim cmd As New System.Data.SqlClient.SqlCommand("spAssignLocationToAddressID")
      

      cmd.CommandType = Data.CommandType.StoredProcedure
      cmd.Parameters.Add("@PartnerAddressID",System.Data.SqlDbType.Nvarchar,16).Value = intAddressID
      cmd.Parameters.Add("@LocationID",System.Data.SqlDbType.NVarChar,16).value = intLocationID
      cnn.open        
      cmd.Connection = cnn
      cmd.ExecuteScalar()
      cnn.Close()
      
    
    End Sub
    
    Private Sub UnassignLocationFromAddress (intLocationID as integer)  
      Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim cmd As New System.Data.SqlClient.SqlCommand("spUnassignLocationFromAddress")
      

      cmd.CommandType = Data.CommandType.StoredProcedure
      cmd.Parameters.Add("@LocationID",System.Data.SqlDbType.NVarChar,16).value = intLocationID
      cnn.open        
      cmd.Connection = cnn
      cmd.ExecuteScalar()
      cnn.Close()
      
    End Sub
    Protected Sub chkSelected_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim ck1 As CheckBox = CType(sender, CheckBox)
        Dim CheckedItems As ArrayList = New ArrayList
        Dim dgItem As DataGridItem = CType(ck1.NamingContainer, DataGridItem)
                             
       If Ck1.Checked Then            
         If Not IsNothing(Session ("CheckedItems")) Then            
         CheckedItems = Session ("CheckedItems")
         End If          
        'Add to Session if it doesnt already exist            
        If Not CheckedItems.Contains(dgitem.Cells.Item(1).text) Then                
          CheckedItems.Add(dgItem.Cells.Item(1).text)            
        End If
         
      Else            
        'Remove value from Session when unchecked            
        CheckedItems.Remove(dgItem.Cells.Item(1).text)        
      End If    
End Sub


    
    Private Sub dgvZips_DeleteCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgvZips.DeleteCommand
        Dim index As Integer
        index = e.Item.ItemIndex
        DeleteItem(e)
        ' Add code to delete data from data source.
        'dgvZips.DataBind()
    End Sub

    
    Private Sub DeleteItem(ByVal e As DataGridCommandEventArgs)
        
        ' e.Item is the table row where the command is raised. For bound 
        ' columns, the value is stored in the Text property of a TableCell.
        Dim itemCell As TableCell = e.Item.Cells(2)
        Dim item As String = itemCell.Text
        
        item.Remove(e.Item.ItemIndex)
        
        
        ' Rebind the data source to refresh the DataGrid control.
        'dgvZips.DataBind()
        
    End Sub
    
    Private Sub btnCreate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCreate.Click
        Dim trt As New BridgesInterface.TerritoryRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim loc As New BridgesInterface.LocationRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim nZip As New BridgesInterface.ZipCodeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim chkbox As CheckBox
        Dim dgItem As DataGridItem
        Dim intIndex As Integer
        Dim strID As String
        Dim strLocationName As String
        Dim lngLocationID As Long
       
        
        If lblLocationID.Text.ToString = "" or lblLocationID.text.tostring = "No ID" Then
            'create new location ID
            strLocationName = loc.GetNewLocation
            If Len(strLocationName) > 1 Then
                loc.Add(strLocationName, _ID)
            End If
            For Each dgItem In dgvZips.Items
                chkbox = dgItem.FindControl("chkselected")
                If chkbox.Checked Then
                    intIndex = dgItem.ItemIndex
                    strID = dgItem.Cells(1).Text
                    If IsDBNull(strID) Or strID = "" Then
                        nZip.Load(dgItem.Cells(2).Text)
                        strID = nZip.ZipCodeID
                    End If
                    trt.Add(loc.LocationID, CType(strID, Long), False)
                End If
            Next
            GetLocation(_ID)
        Else
            For Each dgItem In dgvZips.Items
                chkbox = dgItem.FindControl("chkselected")
                If chkbox.Checked Then
                    intIndex = dgItem.ItemIndex
                    strID = dgItem.Cells(1).Text
                    If IsDBNull(strID) Or strID = "" Or strID = "&nbsp;" Then
                        nZip.Load(dgItem.Cells(2).Text)
                        strID = nZip.ZipCodeID
                    End If
                    lngLocationID = loc.GetLocationByPartnerAddressID(_ID)
                    If Len(lngLocationID) > 0 Then
                        'Verify if zipcode already in the location. If not add
                        IsZipInLocation(lngLocationID, CType(strID, Long),False)
                    End If
                Else
                  intIndex = dgItem.ItemIndex
                    strID = dgItem.Cells(1).Text
                    If IsDBNull(strID) Or strID = "" Or strID = "&nbsp;" Then
                        nZip.Load(dgItem.Cells(2).Text)
                        strID = nZip.ZipCodeID
                    End If
                    lngLocationID = loc.GetLocationByPartnerAddressID(_ID)
                    If Len(lngLocationID) > 0 Then
                        'Verify if zipcode already in the location. If not add
                        IsZipInLocation(lngLocationID, CType(strID, Long),True)
                    End If
                End If
            Next
            If lngLocationID <> 0 Then
                'Remove unwanted zip codes for location
                RemoveZipsFromLocation(lngLocationID)
                
                'clear version from location
                UpdateLocationVersion(lngLocationID)
            End If
            'Reload zips for location
            GetLocation(_ID)
            End If
    End Sub

Private Sub GetLocation(lngPartnerAddressID as Long)
 Dim loc as New BridgesInterface.LocationRecord(system.Configuration.ConfigurationManager.AppSettings("DBCnn"))
 Dim lngLocationID as Long
 
 lngLocationID = loc.GetLocationByPartnerAddressID (lngPartnerAddressID)
 If lngLocationID > 0 then
  Loc.Load (lngLocationID)
  lblLocationID.Text = lblLocationID.Text.Replace ("No ID" , "<a href='/Maps/" & loc.LocationName & ".pdf'>" & loc.LocationName & "</a>")
  'lblLocationID.text = loc.LocationName 
  lblLocationID.Visible = True
  LoadZipsForLocation(lngLocationID)
 End if
End sub

Private Function GetLocationByZipID(lngZipCodeID as Long) as string
 Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetLocationByZipCodeID")
        Dim trt As New BridgesInterface.TerritoryRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim strLocation as string
        
        strLocation = ""
        

        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@ZipCodeID", System.Data.SqlDbType.Int).Value = lngZipCodeID
        cnn.Open()
        cmd.Connection = cnn
        strLocation = cmd.ExecuteScalar()
        cnn.Close()
        GetLocationByZipID = strLocation
End Function

Private Function GetLastLocation() as string
 Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetLastLocation")
        Dim trt As New BridgesInterface.TerritoryRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim strLastLocation as string
        
        strLastLocation = ""
        

        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        strLastLocation = cmd.ExecuteScalar()
        cnn.Close()
        GetLastLocation = strLastLocation
    End Function
    
    Private Function IsZipInTempTable(ByVal strTableName As String, ByVal strZipCodeID As string) As String
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spIsZipInTempTable")
        Dim strResponse As String
        strResponse = 0
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TableName", System.Data.SqlDbType.Nvarchar,64).Value = strTableName
        cmd.Parameters.Add("@ZipCodeID", System.Data.SqlDbType.Nvarchar,16).Value = strZipCodeID
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            strResponse = dtr("Total")
        End While
        cnn.Close()
        IsZipInTempTable = strResponse
    End Function

Private Sub LoadZipsForLocation(lngLocationID as long)
    Dim add As New BridgesInterface.PartnerAddressRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        add.Load(_ID)
        
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadLongStringParameterDataGrid("spGetTerritoryByLocation", "@LocationID", lngLocationID, "@ZipCode", add.ZipCode, dgvZips)
    End Sub

    Private Sub IsZipInLocation(ByVal lngLocationID As Long, ByVal lngZipCodeID As Long, boolRemove as Boolean )
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spIsZipInLocation")
        Dim trt As New BridgesInterface.TerritoryRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim intTerritoryID As Integer
        Dim strChangeLog As String
        
        strChangeLog = ""

        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@LocationID", System.Data.SqlDbType.Int).Value = lngLocationID
        cmd.Parameters.Add("@ZipID", System.Data.SqlDbType.Int).Value = lngZipCodeID
        cnn.Open()
        cmd.Connection = cnn
        intTerritoryID = cmd.ExecuteScalar()
        If intTerritoryID <> 0 Then
            if boolRemove = False then
              trt.Load(intTerritoryID)
              trt.Version = True
              trt.Save(strChangeLog)
            else
              trt.Load(intTerritoryID)
              trt.Version = False
              trt.Save(strChangeLog)
            end if
        Else
            trt.Add(lngLocationID, lngZipCodeID, True)
            trt.Save(strChangeLog)
        End If
        cnn.Close()
        
    End Sub
    Private Sub RemoveZipsFromLocation(ByVal lngLocationID As Long)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spRemoveZipsFromLocationByVersion")

        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@LocationID", System.Data.SqlDbType.Int).Value = lngLocationID
        cmd.Parameters.Add("@Version", System.Data.SqlDbType.Bit).Value = False
        cnn.Open()
        cmd.Connection = cnn
        cmd.ExecuteScalar()
        cnn.Close()
        
    End Sub
    Private Sub UpdateLocationVersion(ByVal lngLocationID As Long)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spUpdateLocationVersion")

        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@LocationID", System.Data.SqlDbType.Int).Value = lngLocationID
        cmd.Parameters.Add("@Version", System.Data.SqlDbType.Bit).Value = False
        cnn.Open()
        cmd.Connection = cnn
        cmd.ExecuteScalar()
        cnn.Close()
        
    End Sub
    Protected Sub chkAll_OnCheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim chkbox As CheckBox
        Dim dgItem As DataGridItem
        
        For Each dgItem In dgvZips.Items
            chkbox = dgItem.FindControl("chkselected")
            If Not chkbox.Checked Then
                chkbox.Checked = True
            Else
                chkbox.Checked = False
            End If
        Next
        
        
    End Sub
    Private Sub LoadStates()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        ldr.LoadSimpleDropDownList("spListStates", "StateName", "StateID", cbxState)
        cbxState.Items.Add("Select State")
        cbxState.SelectedValue = "Select State"
       
    End  sub
    Private Sub LoadEmptyLocations()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        ldr.LoadSimpleDropDownList("spGetEmptyLocations", "LocationName", "LocationID", cbxEmptyLocations)
        cbxEmptyLocations.Items.Add("Empty Locations")
        cbxEmptyLocations.SelectedValue = "Empty Locations"
       
    End Sub
    
    Private Sub LoadUnassignedLocations()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        ldr.LoadSimpleDropDownList("spGetUnassignedLocations", "LocationName", "LocationID", cbxUnassignedLocations)
        cbxUnassignedLocations.Items.Add("Unassigned Locations")
        cbxUnassignedLocations.SelectedValue = "Unassigned Locations"
       
    End Sub
    
    Private Sub LoadCounties(ByVal lngStateID As Long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSingleLongParameterDropDownList("spGetCountyByState", "@StateID", lngStateID, "CountyName", "CountyName", cbxCounties)
        cbxCounties.Items.Add("Select County")
        cbxCounties.SelectedValue = "Select County"
    End Sub
    Protected Sub cbxCounties_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        If cbxState.SelectedValue <> "Select State" Then
            LoadCounties(CType(cbxState.SelectedValue, Long))
            
        End If
    End Sub
    
    Private Sub btnAdd_Click(ByVal S As Object, ByVal E As EventArgs)
        'Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        'ldr.LoadLongStringParameterDataGrid("sp", "@Radius", cbxDistances.SelectedValue, "@ZipCode", add.ZipCode, dgvZips)
        if dgvZips.Items.Count.ToString > 0 then
           Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
           Dim add As New BridgesInterface.PartnerAddressRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
           add.Load(_ID)
           wbl.Load(Master.WebLoginID)    
           Dim strUserName as string
           strUserName = wbl.Login
           'strUserName = "PauloPinheiro"
           Dim dgItem As DataGridItem
           
           CreateTempTable (strUserName)
           'Add data into temp table
           For Each dgItem In dgvZips.Items
           
            Dim str1,str2,str3,str4,str5,str6,str7,str8 as String
            
            str1 = dgItem.cells(1).text
            str2 = dgItem.cells(2).text
            str3 = dgItem.cells(3).text
            if dgItem.cells(3).text = "" then
              str3 = 0
            end if
            str4 = dgItem.cells(4).text
            if dgItem.Cells(4).Text = "" then
              str4 = 0
            end if
            str5 = dgItem.cells(5).text
            if dgItem.Cells(5).Text = "" then
              str5 = 0
            end if
            str6 = dgItem.cells(6).text
            if dgItem.Cells(6).Text = "" then
              str6 = 0
            end if
            str7 = dgItem.cells(7).text
            if dgItem.Cells(7).Text = "" then
              str7 = 0
            end if
             
            str8 = dgItem.cells(8).text
            if dgItem.Cells(8).Text = "" then
              str8 = 0
            end if      
          
             AddDataIntoTemptable (strUserName, dgItem.Cells(1).Text, dgItem.Cells(2).Text,str4, str5, str6, str7,str3,str8) 
           Next
           
          'Is Zip already in the table
          
           
           'Add data from new chosen county to the temp table
           AddZipsFromNewCounty (strUserName, add.ZipCode,cbxState.SelectedValue,cbxCounties.selectedValue)
          
           'Get Data From Temp Table and attach to grid.
           
           GetDataFromTempTable (strUserName)
          
           'delete temp table
           DropTemptable (strUserName)
           Master.PageHeaderText = " Build Territory - Total Zips:" & dgvZips.Items.Count.ToString 
       else
          Dim add As New BridgesInterface.PartnerAddressRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
          add.Load(_ID)
          
          Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            ldr.LoadTwoLongStringParameterDataGrid("spGetZipsByCountyName", "@ZipCode", add.ZipCode, "@StateID", cbxState.SelectedValue, "@CountyName", cbxCounties.SelectedValue, dgvZips)
            
          Master.PageHeaderText = " Build Territory - Total Zips:" & dgvZips.Items.Count.ToString 
        end if
    End Sub
    Private Sub CreateTempTable(ByVal strUserName As String)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spCreateTempTable")
        
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TableName", System.Data.SqlDbType.varchar).Value = strUserName
        cnn.Open()
        cmd.Connection = cnn
        cmd.ExecuteScalar()
        cnn.Close()
    End Sub
    
    Private Sub DropTempTable(ByVal strUserName As String)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spDropTempTable")

        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TableName", System.Data.SqlDbType.varchar).Value = strUserName
        cnn.Open()
        cmd.Connection = cnn
        cmd.ExecuteScalar()
        cnn.Close()
    End Sub
    
    Private Sub AddDataIntoTempTable(ByVal strTableName As String, ByVal strZipCodeID As String, ByVal strZipCode As String, ByVal strCity As String, ByVal strCityAliasName As String, ByVal strAbbreviation As String, ByVal strCountyName As String, ByVal strDistanceInMiles As String, ByVal strPopulation As String)
               
        If IsZipInTempTable(strTableName, strZipCodeID) = 0 Then
            Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            Dim cmd As New System.Data.SqlClient.SqlCommand("spAddDataIntoTempTable")
        
            cmd.CommandType = Data.CommandType.StoredProcedure
            cmd.Parameters.Add("@TableName", System.Data.SqlDbType.VarChar, Me.TrimTrunc(strTableName, &H40).Length).Value = strTableName
            cmd.Parameters.Add("@ZipCodeID", System.Data.SqlDbType.VarChar, Me.TrimTrunc(strZipCodeID, &H40).Length).Value = strZipCodeID
            cmd.Parameters.Add("@ZipCode", System.Data.SqlDbType.VarChar, Me.TrimTrunc(strZipCode, &H40).Length).Value = strZipCode
            cmd.Parameters.Add("@City", System.Data.SqlDbType.VarChar, 64).Value = 0
            cmd.Parameters.Add("@CityAliasName", System.Data.SqlDbType.VarChar, 64).Value = 0
            cmd.Parameters.Add("@Abbreviation", System.Data.SqlDbType.VarChar, 64).Value = 0
            cmd.Parameters.Add("@CountyName", System.Data.SqlDbType.VarChar, 64).Value = 0
            cmd.Parameters.Add("@DistanceInMiles", System.Data.SqlDbType.VarChar, 64).Value = 0
            cmd.Parameters.Add("@Population", System.Data.SqlDbType.VarChar, 64).Value = 0
            cnn.Open()
            cmd.Connection = cnn
            cmd.ExecuteScalar()
            cnn.Close()
        End If
    End Sub
    
    Private Sub GetDataFromTempTable(ByVal strTableName As String)
        'Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        'Dim cmd As New System.Data.SqlClient.SqlCommand("spGetDataFromTempTable")
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadStringParameterDataGrid("spGetDataFromTempTable","@TableName",strTableName,dgvZips)
       
        
    End Sub
    
    Private Sub AddZipsFromNewCounty (ByVal strTableName as String,ByVal strZip as String, ByVal lngStateID as Long, ByVal strCountyName as String)
    
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("spGetZipsByCountyName")
    cmd.CommandType = Data.CommandType.StoredProcedure 
    cmd.Parameters.Add("@ZipCode", System.Data.SqlDbType.VarChar,16).value = strZip
    cmd.Parameters.Add("@CountyName", System.Data.SqlDbType.Varchar,64).Value = strCountyName
    cmd.Parameters.Add("@StateID", System.Data.SqlDbType.int).Value = lngStateID
        
    cnn.Open()
    cmd.Connection = cnn
    Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
    
    While dtr.Read
      AddDataIntoTempTable (strTableName,dtr("ZipCodeID"),dtr("ZipCode"),dtr("City"),dtr("CityAliasName"),dtr("Abbreviation"),dtr("CountyName"),dtr("DistanceInMiles"),dtr("Population"))  

    End While
    cnn.Close()
    
    end sub
    
    Private Function TrimTrunc(ByVal strInput As String, ByVal intMaxLength As Integer) As String
            Dim strReturn As String = strInput
            If (strReturn.Trim.Length <= intMaxLength) Then
                Return strReturn.Trim
            End If
            Return strReturn.Substring(0, intMaxLength).Trim
        End Function
        
    Private Sub btnExport_Click(sender As Object, e As System.Web.UI.ImageClickEventArgs)
      Dim ex As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim loc as New BridgesInterface.LocationRecord(system.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim lngLocationID as long
      
      If _ID <> 0 then
        lngLocationID = loc.GetLocationByPartnerAddressID (_ID)
        If lngLocationID > 0 then
          loc.Load(lngLocationID)
          ex.ExportGrid(loc.LocationName & ".xls",dgvZips) 
        else
          ex.ExportGrid("NewLocation.xls",dgvZips)
        end if
      else
        ex.ExportGrid("NewLocation.xls",dgvZips)
      end if   
    end sub
    
    
    Private Sub btnRemove_Click(ByVal S As Object, ByVal E As EventArgs)
      if dgvZips.Items.Count.ToString > 0 then
           Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
           Dim add As New BridgesInterface.PartnerAddressRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
           Dim chkbox as CheckBox 
           Dim intCount as Integer 
           intCount = 0
           add.Load(_ID)
           wbl.Load(Master.WebLoginID)    
           Dim strUserName as string
            strUserName = wbl.Login
            'strUserName = "PauloPinheiro"
           Dim dgItem As DataGridItem
           
           CreateTempTable (strUserName)
           'Add data into temp table
           For Each dgItem In dgvZips.Items
           
            chkbox = dgItem.FindControl("chkselected")
            If Not chkbox.Checked Then
           
              Dim str1,str2,str3,str4,str5,str6,str7,str8 as String
            
              str1 = dgItem.cells(1).text
              str2 = dgItem.cells(2).text
              str3 = dgItem.cells(3).text
              if dgItem.cells(3).text = "" then
                str3 = 0
              end if
              str4 = dgItem.cells(4).text
              if dgItem.Cells(4).Text = "" then
                str4 = 0
              end if
              str5 = dgItem.cells(5).text
              if dgItem.Cells(5).Text = "" then
                str5 = 0
              end if
              str6 = dgItem.cells(6).text
              if dgItem.Cells(6).Text = "" then
                str6 = 0
              end if
              str7 = dgItem.cells(7).text
              if dgItem.Cells(7).Text = "" then
                str7 = 0
              end if
             
              str8 = dgItem.cells(8).text
              if dgItem.Cells(8).Text = "" then
                str8 = 0
              end if      
          
               AddDataIntoTemptable (strUserName, dgItem.Cells(1).Text, dgItem.Cells(2).Text,str4, str5, str6, str7,str3,str8) 
               intCount = intCount + 1
            end if
         Next
         if intCount = 0 then
           if dgvZips.Items.Count.ToString = 1 then          
             dgvZips.DataSource = ""
             dgvZips.DataBind ()
           end if
         else
           'Get Data From Temp Table and attach to grid.
            GetDataFromTempTable (strUserName)
         end if 
         'delete temp table
         DropTemptable (strUserName)
         
        end if
        Master.PageHeaderText = " Build Territory - Total Zips:" & dgvZips.Items.Count.ToString 
    end sub

Private Sub MsgBox(ByVal strMessage As String) 
'Begin building the script 
Dim strScript As String = "<SCRIPT LANGUAGE=""JavaScript"">" & vbCrLf 
strScript += "alert(""" & strMessage & """)" & vbCrLf 
strScript += "<" & "/" & "SCRIPT" & ">" 
'Register the script for the client side 
ClientScript.RegisterStartupScript(GetType(String), "messageBox", strScript ) 
End Sub


</script>

<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <table>
      <tr style=" background-color: Scrollbar" valign="middle">
        <td class="label" align ="center">Empty Locations  &  Available Locations  
        </td>
        <td class="label">Last Location Created 
        </td>
        <td class="label" >Remove Location from Address
        </td>
        <td>  
        </td>
      </tr>
      <tr>
        <td>
          <asp:DropDownList ID="cbxEmptyLocations" runat="server" />&nbsp;&nbsp;<asp:DropDownList ID="cbxUnassignedLocations" runat="server" />&nbsp;&nbsp;<asp:Button ID="btnAssignLocation" runat="server" Text="Assign Location" OnClick="btnAssignLocation_Click" />&nbsp;</td>
        <td><asp:TextBox  ID="txtLastLocation" runat ="server" Width="80px" />&nbsp;&nbsp;<asp:Button ID="btnCreateNewLocation" runat="server" Text="Create New Location" OnClick="btnCreateNewLocation_Click" /></td>
        <td><asp:Button ID="btnRemoveLocation" runat="server" Text="RemoveLocation" OnClick="btnRemoveLocation_Click" />&nbsp;&nbsp;<asp:CheckBox ID="chkRemoveZips" runat ="server" Text="Also Remove Zip Codes from Location" /></td>
        <td><asp:Button ID="btnCancel" runat="server" Text="Exit" OnClick="btnCancel_Click" /></td>
      </tr>
    </table>
    <table border="0" cellpadding="0" cellspacing="2"  width="100%">
      <tr style=" background-color:   Scrollbar" valign="middle" >
        <td  class="label">Home Zip Code
        </td>
        <td  class="label">By Radius
        </td>
        <td  class="label">By County
        </td>
        <td  class="label">By Importing Excel File
        </td>
        <td class="label">Geographic Location
        </td>
        <td></td>
      </tr>
      <tr>
        <td>
          <asp:TextBox  ID="txtHomeZip" runat ="server" Width="80px" />
        </td>
        <td>
          <asp:DropDownList ID="cbxDistances" runat="server" />&nbsp;<asp:Button ID="btnRebuild" runat="server" Text="GetZips" OnClick="btnRebuild_Click" />&nbsp;<asp:Button ID="btnRemove" runat="server" Text="Remove" OnClick="btnRemove_Click" />
        </td>
        <td><asp:DropDownList ID="cbxState" runat="server" AutoPostBack="true" OnSelectedIndexChanged="cbxCounties_SelectedIndexChanged" />&nbsp;<asp:DropDownList ID="cbxCounties" runat="server" />&nbsp;<asp:Button ID="btnAdd" runat="server" Text="Add" OnClick="btnAdd_Click" /></td>
        <td>
          <asp:FileUpload ID="fup" runat="server" /><asp:Button OnClick="btnUpload_Click" ID="btnUpload" Text="Upload" runat="server" />
          <asp:Label ID="lblReturnAddress" Visible="false" runat="server" />  
        </td>
        <td align="center" valign="middle" >
          <asp:Label ID="lblLocationID" runat="server" Visible="false"  Text="No ID" Font-Bold="True" ForeColor="Red" Font-Size ="Large" />&nbsp;&nbsp;&nbsp;<asp:ImageButton ID="btnExport" AlternateText ="Export to Excel" ImageUrl ="/images/Excel-16.gif"  ImageAlign="Middle"  OnClick="btnExport_Click" runat="server"/>
        </td>
        <td valign="bottom" align="center" style="background-color:#ffffff"><asp:Button  ID="btnCreate" Text="Create" runat="server" />
        </td>
       </tr>
    </table>
    <div class="errorzone" runat="server" id="divErrors" visible="false" />
    <asp:DataGrid AllowSorting="True" ID="dgvZips" runat="server" AutoGenerateColumns="False" style="width: 1195px;" OnSortCommand="dgvZips_SortCommand"  >
      <AlternatingItemStyle CssClass="altrow" />
      <HeaderStyle CssClass="gridheader" />
      <Columns>
        <asp:TemplateColumn>
          <HeaderTemplate>
            <asp:CheckBox id="chkAll" runat="server"  OnCheckedChanged ="chkAll_OnCheckedChanged" AutoPostBack = "True"></asp:CheckBox>
          </HeaderTemplate>
          <ItemTemplate>
            <asp:CheckBox ID="chkSelected" runat="server" AutoPostBack ="False" OnCheckedChanged="chkSelected_CheckedChanged" visible="True"/>
          </ItemTemplate>
        </asp:TemplateColumn>
        <asp:BoundColumn SortExpression="ZipCodeID" DataField="ZipCodeID" HeaderText="ID" Visible = "False" />
        <asp:BoundColumn SortExpression="ZipCode" DataField="ZipCode" HeaderText="Zip" Visible="False" />
        <asp:TemplateColumn SortExpression="ZipCode" HeaderText="Zip Code">
          <ItemTemplate>
            <a href="findzipcode.aspx?zip=<%# DataBinder.Eval(Container.DataItem,"ZipCode") %>"><%# DataBinder.Eval(Container.DataItem,"ZipCode") %></a>
          </ItemTemplate>
        </asp:TemplateColumn>
        <asp:BoundColumn SortExpression="DistanceInMiles" DataField="DistanceInMiles" HeaderText="Distance" Visible="False" >
            <ItemStyle HorizontalAlign="Right" />
        </asp:BoundColumn>
        <asp:TemplateColumn SortExpression="DistanceInMiles" HeaderText="Distance">
          <ItemTemplate>
            <asp:Literal id="lblDistanceInMiles" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "DistanceInMiles") %>' />
          </ItemTemplate>
            <ItemStyle HorizontalAlign="Right" />
        </asp:TemplateColumn>
        <asp:TemplateColumn SortExpression="City" HeaderText="City">
         <ItemTemplate>
            <asp:Literal id="lblCity" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "City") %>' />
         </ItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn SortExpression="CityAliasName" HeaderText="CityAliasName">
         <ItemTemplate>
           <asp:Literal id="lblCityAliasName" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "CityAliasName") %>' />
         </ItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn SortExpression="Abbreviation" HeaderText="State">
         <ItemTemplate>
           <asp:Literal id="lblAbbreviation" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Abbreviation") %>' />
         </ItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn SortExpression="CountyName" HeaderText="CountyName">
          <ItemTemplate>
            <asp:Literal id="lblCountyName" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "CountyName") %>' />
          </ItemTemplate>
        </asp:TemplateColumn>
        <asp:BoundColumn SortExpression="Population" DataField="Population" HeaderText="Population" Visible="False" >
            <ItemStyle HorizontalAlign="Right" />
        </asp:BoundColumn>
        <asp:TemplateColumn SortExpression="LocationID" HeaderText="LocationID">
          <ItemTemplate>
            <asp:Literal id="lblPopulation" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Population") %>' />
          </ItemTemplate>
            <ItemStyle HorizontalAlign="Right" />
        </asp:TemplateColumn>
        <asp:ButtonColumn CommandName="Delete" Text="Delete" Visible = "False"></asp:ButtonColumn>
      </Columns>
    </asp:DataGrid>
    <div style="text-align: right;">* Distance is miles from central zip code of the address.</div>
    <div style="text-align: right"></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
  <asp:Label ID="lblSortOrder" runat="server" Visible="false" />
</asp:Content>