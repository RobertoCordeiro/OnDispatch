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
            Master.PageHeaderText = " Samsung Excel Update"
            Master.PageTitleText = " Samsung Excel Update"
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
                

      End If
    Else
            'Response.Redirect(lblReturnUrl.Text, True)
        End If
        
  End Sub
  
  Private Sub LoadTerritory()
    Dim add As New BridgesInterface.PartnerAddressRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        add.Load(_ID)
        
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadLongStringParameterDataGrid("spFindZipCodesWithinRadius", "@Radius", cbxDistances.SelectedValue, "@ZipCode", add.ZipCode, dgvZips)
        
    End Sub
  
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
        ' Try
        Dim MyConnection As System.Data.OleDb.OleDbConnection
            
        Dim DtSet As System.Data.DataSet
        Dim MyCommand As System.Data.OleDb.OleDbDataAdapter

        MyConnection = New System.Data.OleDb.OleDbConnection("provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & System.IO.Path.GetFullPath(fup.PostedFile.FileName) & ";Extended Properties='Excel 8.0;HDR=YES'")
        MyCommand = New System.Data.OleDb.OleDbDataAdapter("select * from [Sheet1$]", MyConnection)
        MyCommand.TableMappings.Add("Table", "TestTable")
        DtSet = New System.Data.DataSet
        MyCommand.Fill(DtSet)

        dgvZips.DataSource = DtSet.Tables(0)
        dgvZips.DataBind()
        MyConnection.Close()

        'Catch ex As Exception
        'Msgbox.Show(ex.Message)

        'End Try
    End Sub

    Private Sub dgvZips_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgvZips.ItemDataBound

        Dim rowData As Data.DataRowView
        Dim strMessage As String
        Dim lblUpdate As System.Web.UI.WebControls.Literal
        Dim lblStatus As System.Web.UI.WebControls.Literal
        Dim strCustomerNumber As String
       
        strMessage = ""
        Select Case (e.Item.ItemType)
            Case ListItemType.AlternatingItem, ListItemType.EditItem, ListItemType.Item, ListItemType.SelectedItem
                'get the data for the item being bound
                
                rowData = CType(e.Item.DataItem, Data.DataRowView)
                strCustomerNumber = (rowData.Item("ticket No")) 'verifying data from excel file.
                If strCustomerNumber <> "" Then
                    lblStatus = CType(e.Item.FindControl("lblStatus"), System.Web.UI.WebControls.Literal)
                    lblStatus.Text = GetStatus(strCustomerNumber, 25)
                    
                    lblUpdate = CType(e.Item.FindControl("lblUpdate"), System.Web.UI.WebControls.Literal)
                    lblUpdate.text = strMessage
                    Select Case lblStatus.Text
                        Case Is = "In Process", "NEW", "Phone Support Needed"
                            strMessage = "Contacting customer to verify service."
                            lblUpdate.Text = strMessage
                        Case Is = "NTA", "NTFT", "PONT", "OWNT"
                            strMessage = "Trying to coordinate an appt with customer."
                            lblUpdate.Text = strMessage
                        Case Is = "Ordering Parts"
                            strMessage = "Ordering parts for service."
                            lblUpdate.Text = strMessage
                        Case Is = "Parts On Back Order"
                            strMessage = "Parts are on back order. Pending."
                            lblUpdate.Text = strMessage
                        Case Is = "Awaiting Parts"
                            strMessage = "Awaiting parts to be shipped out."
                            lblUpdate.Text = strMessage
                        Case Is = "Need Appointment Set"
                            strMessage = "Trying to coordinate an appt with customer for service."
                            lblUpdate.Text = strMessage
                        Case Is = "Scheduled"
                            strMessage = "Appointment set. Ready for service."
                            lblUpdate.Text = strMessage
                        Case Else
                            strMessage = "Need verify information"
                    End Select
                End If
                
            Case ListItemType.Footer

                
            Case Else
                
        End Select
        
    End Sub  'dgvZips_ItemDataBound
    Private Function GetStatus(ByVal strCustomerNumber As String, ByVal lngCustomerID As Long) As String
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetTicketStatusByReferenceNumber1")
        Dim strStatus As String

        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@CustomerNumber", System.Data.SqlDbType.NVarChar, 64).Value = strCustomerNumber
        cmd.Parameters.Add("@CustomerID", System.Data.SqlDbType.Int).Value = lngCustomerID
        cnn.Open()
        cmd.Connection = cnn
        strStatus = cmd.ExecuteScalar()
        cnn.Close()
        GetStatus = strStatus
    
    End Function
    Protected Sub chkSelected_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim ck1 As CheckBox = CType(sender, CheckBox)
        Dim CheckedItems As ArrayList = New ArrayList
        Dim dgItem As DataGridItem = CType(ck1.NamingContainer, DataGridItem)
                             
        If ck1.Checked Then
            If Not IsNothing(Session("CheckedItems")) Then
                CheckedItems = Session("CheckedItems")
            End If
            'Add to Session if it doesnt already exist            
            If Not CheckedItems.Contains(dgItem.Cells.Item(1).Text) Then
                CheckedItems.Add(dgItem.Cells.Item(1).Text)
            End If
         
        Else
            'Remove value from Session when unchecked            
            CheckedItems.Remove(dgItem.Cells.Item(1).Text)
        End If
    End Sub


    
    Private Sub dgvZips_DeleteCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgvZips.DeleteCommand
        'Dim index As Integer
        'index = e.Item.ItemIndex
        DeleteItem(e)
        ' Add code to delete data from data source.
        'dgvZips.DataBind()
    End Sub

    
    Sub DeleteItem(ByVal e As DataGridCommandEventArgs)
        
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
       
        
        If lblLocationID.Text.ToString = "" Then
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
                        IsZipInLocation(lngLocationID, CType(strID, Long))
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

    Private Sub GetLocation(ByVal lngPartnerAddressID As Long)
        Dim loc As New BridgesInterface.LocationRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim lngLocationID As Long
 
        lngLocationID = loc.GetLocationByPartnerAddressID(lngPartnerAddressID)
        If lngLocationID > 0 Then
            loc.Load(lngLocationID)
            lblLocationID.Text = loc.LocationName
            lblLocationID.Visible = True
            LoadZipsForLocation(lngLocationID)
        End If
    End Sub

    Private Sub LoadZipsForLocation(ByVal lngLocationID As Long)
        Dim add As New BridgesInterface.PartnerAddressRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        add.Load(_ID)
        
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadLongStringParameterDataGrid("spGetTerritoryByLocation", "@LocationID", lngLocationID, "@ZipCode", add.ZipCode, dgvZips)
    End Sub

    Private Sub IsZipInLocation(ByVal lngLocationID As Long, ByVal lngZipCodeID As Long)
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
            trt.Load(intTerritoryID)
            trt.Version = True
            trt.Save(strChangeLog)
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
    
    
    
</script>

<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <table border="0" cellpadding="0" cellspacing="2"  width="100%">
      <tr style=" background-color:GrayText" valign="middle" >
        <td  class="label">By Radius
        </td>
        <td  class="label">By Importing Excel File
        </td>
        <td class="label">Geographic Location
        </td>
        <td></td>
      </tr>
      <tr>
        <td>
          <asp:DropDownList ID="cbxDistances" runat="server" />&nbsp;<asp:Button ID="btnRebuild" runat="server" Text="Rebuild" OnClick="btnRebuild_Click" />
        </td>
        <td>
          <asp:FileUpload ID="fup" runat="server" /><asp:Button OnClick="btnUpload_Click" ID="btnUpload" Text="Upload" runat="server" />
          <asp:Label ID="lblReturnAddress" Visible="false" runat="server" />  
        </td>
        <td align="center" valign="middle" >
          <asp:Label ID="lblLocationID" runat="server" Visible="false"  Font-Bold="True" ForeColor="Red" Font-Size ="Large" /> 
        </td>
        <td valign="bottom" align="center" style="background-color:#ffffff"><asp:Button  ID="btnCreate" Text="Create" runat="server" />
        </td>
       </tr>
    </table>
    <div class="errorzone" runat="server" id="divErrors" visible="false" />
    <asp:DataGrid AllowSorting="True" ID="dgvZips" runat="server" AutoGenerateColumns="False" style="width: 800px;" OnSortCommand="dgvZips_SortCommand" >
      <AlternatingItemStyle CssClass="altrow" />
      <HeaderStyle CssClass="gridheader" />
      <Columns>
        <asp:BoundColumn SortExpression="ticket No" DataField="ticket No" HeaderText="ticket No" Visible = "True" />
        <asp:BoundColumn SortExpression="Posting Date" DataField="Posting Date" HeaderText="Posting Date" Visible = "True" />
        <asp:BoundColumn SortExpression="Confirm Date" DataField="Confirm Date" HeaderText="Confirm Date" Visible = "True" />
        <asp:BoundColumn SortExpression="Aging" DataField="Aging" HeaderText="Aging" Visible = "True" />
        <asp:BoundColumn SortExpression="In/O" DataField="In/O" HeaderText="In/O" Visible = "True" />
        <asp:BoundColumn SortExpression="Service Product" DataField="Service Product" HeaderText="Service Product" Visible = "True" />
        <asp:BoundColumn SortExpression="Service Model" DataField="Service Model" HeaderText="Service Model" Visible = "True" />
        <asp:BoundColumn SortExpression="CNT" DataField="CNT" HeaderText="CNT" Visible = "True" />
        <asp:TemplateColumn SortExpression="Status" HeaderText="Status">
          <ItemTemplate>
            <asp:Literal id="lblStatus" runat="server" />
          </ItemTemplate>
            <ItemStyle HorizontalAlign="Right" />
        </asp:TemplateColumn>
        <asp:TemplateColumn SortExpression="Update" HeaderText="Update">
          <ItemTemplate>
            <asp:Literal id="lblUpdate" runat="server" />
          </ItemTemplate>
            <ItemStyle HorizontalAlign="Right" />
        </asp:TemplateColumn>
      </Columns>
    </asp:DataGrid>
    <div style="text-align: right;">* Distance is miles from central zip code of the address.</div>
    <div style="text-align: right"><asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
  <asp:Label ID="lblSortOrder" runat="server" Visible="false" />
</asp:Content>