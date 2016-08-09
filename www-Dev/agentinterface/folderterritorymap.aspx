<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server"> 
    
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Folder Territory Map Data Generator"
      Master.PageTitleText = " Folder Territory Map Data Generator"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a>"
    End If
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If Not IsPostBack Then
      LoadFolders()
    End If
  End Sub
  
  Private Sub LoadFolders()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDropDownList("spListResumeFolders", "FolderName", "FolderID", cbxFolders)
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    divErrors.innerhtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function

  Private Sub btnExport_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect("folderterritorymapxls.aspx?id=" & cbxFolders.SelectedValue)
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
  Private Sub btnZipExport_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim exp As New cvCommon.Export
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDataGrid("spGetDistinctTemporaryTerritory", dgvExcel)
    exp.DataGridToExcel(Response, dgvExcel, "territory.xls", "worksheet1", False)
  End Sub

  </script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    
    <asp:DataGrid ID="dgvExcel" runat="server" AutoGenerateColumns="false">
      <Columns>
        <asp:BoundColumn HeaderText="ZipCode" DataField="ZipCode" />
        <asp:BoundColumn HeaderText="ResumeID" DataField="ResumeID" />
      </Columns>
    </asp:DataGrid>
    
    <div class="errorzone" id="divErrors" runat="server" visible="false" />
    <div>&nbsp;</div>
    <div class="label">Folder</div>
    <asp:DropDownList ID="cbxFolders" runat="server" />
    <div>&nbsp;</div>
    <div>Please note this operation may take several minutes.</div>
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnExport" Text="Export" runat="server" OnClick="btnExport_Click" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
    <asp:Button ID="btnZipExport" runat="Server" Text="export" OnClick="btnZipExport_Click" />
  </form>
</asp:Content>