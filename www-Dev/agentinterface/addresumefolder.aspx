<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server"> 
  
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Add Resume Folder"
      Master.PageTitleText = " Add Resume Folder"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""settings.aspx"">Settings</a> &gt; Add Resume Folder"
    End If
    If Not IsPostBack Then
      Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      ldr.LoadSimpleDropDownList("spListActiveUsers", "UserName", "UserID", cbxUsers)
    End If
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If txtFolderName.Text.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Folder Name is Required</li>"
    End If
    divErrors.innerhtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
  Private Sub Save()
    Dim rfd As New BridgesInterface.ResumeFolderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    rfd.Add(cbxUsers.SelectedValue, txtFolderName.Text, True, chkShared.Checked)
    Response.Redirect("settings.aspx", True)
  End Sub
  
  Private Sub btnSave_Click(ByVal S As Object, ByVal E As EventArgs)
    Save()
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div class="errorzone" id="divErrors" runat="server" visible="false" />
    <div>&nbsp;</div>
    <div class="label">Belongs To</div>
    <asp:DropDownList style="width: 99%" ID="cbxUsers" runat="server" />
    <div class="label">Folder Name</div>
    <asp:TextBox style="width: 99%" ID="txtFolderName" runat="server" />
    <div style="text-align: right;"><asp:CheckBox ID="chkShared" runat="server" Text="Shared" /></div>
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnSave" OnClick="btnSave_Click" Text="Save" runat="server" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>