<%@ Page Language="vb" masterpagefile="~/masters/partnerdialog.master" %>
<%@ MasterType VirtualPath="~/masters/partnerdialog.master" %>
<script runat="server">  
  
  Private _ID As Long = 0
  Private _Mode As String = ""
  Private _Zip as String = ""  
    
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
               
      LoadHomeZip()
      GetLocation(_ID)
      End If
    Else
      Response.Redirect(lblReturnUrl.Text, True)
        End If
        
  End Sub
  
  
    
  Private Sub LoadHomeZip()
    Dim add As New BridgesInterface.PartnerAddressRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        add.Load(_ID)
        _Zip = add.ZipCode
        
  end sub
  
   
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
        'ldr.LoadLongStringParameterDataGrid("spFindZipCodesWithinRadius", "@Radius", cbxDistances.SelectedValue, "@ZipCode", add.ZipCode, dgvZips, True, e, e.SortExpression, lblSortOrder.Text)
        
        
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
        strZipSource = _Zip
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
    Protected Sub chkSelected_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim ck1 As CheckBox = CType(sender, CheckBox)
        Dim CheckedItems = New ArrayList
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
           'Add data from new chosen county to the temp table
           'AddZipsFromNewCounty (strUserName, add.ZipCode,cbxState.SelectedValue,cbxCounties.selectedValue)
          
           'Get Data From Temp Table and attach to grid.
           
           GetDataFromTempTable (strUserName)
          
           'delete temp table
           DropTemptable (strUserName)
           Master.PageHeaderText = " Build Territory - Total Zips:" & dgvZips.Items.Count.ToString 
       else
          Dim add As New BridgesInterface.PartnerAddressRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
          add.Load(_ID)
          
          Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            'ldr.LoadTwoLongStringParameterDataGrid("spGetZipsByCountyName", "@ZipCode", add.ZipCode, "@StateID", cbxState.SelectedValue, "@CountyName", cbxCounties.SelectedValue, dgvZips)
            
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
    
    Private Sub AddDataIntoTempTable(ByVal strTableName As String,ByVal strZipCodeID as string,ByVal strZipCode as String, ByVal strCity as String,ByVal strCityAliasName as String,ByVal strAbbreviation as String, ByVal strCountyName as String,ByVal strDistanceInMiles as string, ByVal strPopulation as string)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spAddDataIntoTempTable")

        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TableName", System.Data.SqlDbType.VarChar,Me.TrimTrunc(strTableName, &H40).Length).Value = strTableName
        cmd.Parameters.Add("@ZipCodeID", System.Data.SqlDbType.varchar,Me.TrimTrunc(strZipCodeID, &H40).Length).Value = strZipCodeID
        cmd.Parameters.Add("@ZipCode", System.Data.SqlDbType.varchar,Me.TrimTrunc(strZipCode, &H40).Length).Value = strZipCode
        cmd.Parameters.Add("@City", System.Data.SqlDbType.varchar,64).Value = 0
        cmd.Parameters.Add("@CityAliasName", System.Data.SqlDbType.varchar,64).Value = 0
        cmd.Parameters.Add("@Abbreviation", System.Data.SqlDbType.varchar,64).Value = 0
        cmd.Parameters.Add("@CountyName", System.Data.SqlDbType.varchar,64).Value = 0
        cmd.Parameters.Add("@DistanceInMiles", System.Data.SqlDbType.varchar,64).Value = 0
        cmd.Parameters.Add("@Population", System.Data.SqlDbType.varchar,64).Value= 0
        cnn.Open()
        cmd.Connection = cnn
        cmd.ExecuteScalar()
        cnn.Close()
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
           'strUserName = wbl.Login
           strUserName = "PauloPinheiro"
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
Private Sub GetLocation(lngPartnerAddressID as Long)
 Dim loc as New BridgesInterface.LocationRecord(system.Configuration.ConfigurationManager.AppSettings("DBCnn"))
 Dim lngLocationID as Long
 
 lngLocationID = loc.GetLocationByPartnerAddressID (lngPartnerAddressID)
 If lngLocationID > 0 then
  Loc.Load (lngLocationID)
  'lblLocationID.Text = lblLocationID.Text.Replace ("No ID" , "<a href='/Maps/" & loc.LocationName & ".pdf'>" & loc.LocationName & "</a>")
  'lblLocationID.text = loc.LocationName 
  'lblLocationID.Visible = True
  LoadZipsForLocation(lngLocationID)
 End if
End sub


</script>

<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div class="errorzone" runat="server" id="divErrors" visible="false" />
    <div class="inputformsectionheader">List of Zip Codes</div>
    <asp:DataGrid AllowSorting="True" ID="dgvZips" runat="server" AutoGenerateColumns="False" style="width: 1195px;" OnSortCommand="dgvZips_SortCommand"  >
      <AlternatingItemStyle CssClass="altrow" />
      <HeaderStyle CssClass="gridheader" />
      <Columns>
        <asp:TemplateColumn>
          <HeaderTemplate>
            <asp:CheckBox id="chkAll" runat="server"  OnCheckedChanged ="chkAll_OnCheckedChanged"  visible="False" AutoPostBack = "True"></asp:CheckBox>
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
    <div style="text-align: right"><asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
  <asp:Label ID="lblSortOrder" runat="server" Visible="false" />
</asp:Content>