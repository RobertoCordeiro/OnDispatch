
<script language="VB" runat="server">

  Private _TicketFolderID As Long = 0
  Private _ServiceTypeID As Long = 0
  
  Private Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
    HandleSSL()
    Try
      _TicketFolderID = CType(Request.QueryString("id"), Long)
      _ServiceTypeID = CType(Request.QueryString("sid"), Long)
    Catch ex As Exception
      _TicketFolderID = 0
      _ServiceTypeID = 0
    End Try
    Response.Clear()
    Response.ContentType = "application/vnd.ms-excel"
    Response.AddHeader("content-disposition", "attachment;filename=export.xls")
    Response.Charset = ""
    Response.Cache.SetCacheability(HttpCacheability.NoCache)
    LoadList()
    Dim stringWrite As New System.IO.StringWriter
    Dim htmlWrite As New HtmlTextWriter(stringWrite)
    Me.Render(htmlWrite)
    Response.Write(stringWrite.ToString)
    Response.End()
  End Sub

  Private Sub HandleSSL()
    If (Request.ServerVariables("HTTPS") = "on") Then
      Dim strRedirect As String = ""
      Dim strQuery As String = ""
      strRedirect = "http://" & Request.ServerVariables("SERVER_NAME")
      strRedirect &= Request.ServerVariables("SCRIPT_NAME")
      strQuery = Request.ServerVariables("QUERY_STRING")
      If strQuery.Trim.Length > 0 Then
        strRedirect &= "?"
        strRedirect &= strQuery
      End If
      Response.Redirect(strRedirect)
    End If
  End Sub

  Private Sub LoadList()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadTwoLongParameterDataGrid("spListTicketsForServiceTypeAndFolder", "@TicketFolderID", _TicketFolderID, "@ServiceTypeID", _ServiceTypeID, dgvList)
  End Sub
  
  Private Sub dgvList_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgvList.ItemDataBound
    If e.Item.ItemType = ListItemType.Header Then
      Dim stp As New BridgesInterface.ServiceTypeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      stp.Load(_ServiceTypeID)
      Dim cst As New BridgesInterface.CustomerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))    
      cst.Load(stp.CustomerID)
      For Each cel As System.Web.UI.WebControls.TableCell In e.Item.Cells
        If cel.Text = "RefLabel1" Then
          cel.Text = cst.Ref1Label
        End If
      Next
    End If
  End Sub
    
</script>
<html xmlns:x="urn:schemas-microsoft-com:office:excel">
  <head>
  <style>
  <!--table
  @page
     {mso-header-data:"&CMultiplication Table\000ADate\: &D\000APage &P";
	mso-page-orientation:landscape;}
     br
     {mso-data-placement:same-cell;}
     .zipcode{mso-number-format:00000;}
  -->
</style>
  <!--[if gte mso 9]><xml>
   <x:ExcelWorkbook>
    <x:ExcelWorksheets>
     <x:ExcelWorksheet>
      <x:Name>Sample Workbook</x:Name>
      <x:WorksheetOptions>
       <x:Print>
        <x:ValidPrinterInfo/>
       </x:Print>
      </x:WorksheetOptions>
     </x:ExcelWorksheet>
    </x:ExcelWorksheets>
   </x:ExcelWorkbook>
  </xml><![endif]--> 
  </head>
  <body>

      <asp:DataGrid ID="dgvList" EnableViewState="false" runat="server" style="width: 100%" AutoGenerateColumns="false">
        <Columns>
          <asp:BoundColumn HeaderText="Ticket ID" DataField="TicketID" Visible="true" />
          <asp:BoundColumn headertext="Status" DataField="Status" />
          <asp:BoundColumn HeaderText="Service SKU" DataField="ServiceName" />
          <asp:BoundColumn HeaderText="Priority" DataField="CustomerPrioritySetting" />
          <asp:TemplateColumn HeaderText="End User">
            <ItemTemplate>
              <%# DataBinder.Eval(Container.DataItem,"ContactFirstName") %> <%# DataBinder.Eval(Container.DataItem,"ContactMiddleName") %> <%# DataBinder.Eval(Container.DataItem,"ContactLastName") %>
            </ItemTemplate>
          </asp:TemplateColumn>
          <asp:TemplateColumn HeaderText="RefLabel1">
            <ItemTemplate>
              <%#DataBinder.Eval(Container.DataItem, "ReferenceNumber1")%>
            </ItemTemplate>
          </asp:TemplateColumn> 
          <asp:BoundColumn datafield="city" HeaderText="City" />
          <asp:BoundColumn DataField="Abbreviation" HeaderText="State" />
          <asp:BoundColumn DataField="ZipCode" HeaderText="Zip" />          
          <asp:BoundColumn HeaderText="Requested Start" DataField="RequestedStartDate" />
          <asp:BoundColumn HeaderText="Requested End" DataField="RequestedEndDate" />        
          <asp:BoundColumn HeaderText="Date Created" DataField="DateCreated" />
        </Columns>    
      </asp:DataGrid>
  
</body>
</html>