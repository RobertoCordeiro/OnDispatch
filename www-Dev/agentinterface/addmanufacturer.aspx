<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server"> 
    
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Add Manufacturer"
      Master.PageTitleText = "Add Manufacturer"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""makers.aspx"">Manufacturer Model Contro</a> &gt; Add Manufacturer"
    End If
    lblReturnUrl.Text = Request.QueryString("returnurl")
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub

  Private Sub btnAdd_Click(ByVal S As Object, ByVal E As EventArgs)
    If isComplete() Then
      divErrors.Visible = False
      Dim man As New BridgesInterface.ManufacturerRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
      man.Add(Master.UserID, txtManufacturer.Text)
      Response.Redirect(lblReturnUrl.Text)
    Else
      divErrors.Visible = True
    End If
  End Sub
  
  Private Function isComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If txtManufacturer.Text.Trim.Length = 0 Then
      strErrors &= "<li>Manufacturer is Required</li>"
      blnReturn = False
    End If
    divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div class="errorzone" runat="server" visible="false" id="divErrors" />
    <div class="label">Manufacturer</div>
    <asp:TextBox style="width: 99%" runat="server" ID="txtManufacturer" />    
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnAdd" runat="server" OnClick="btnAdd_Click" Text="Add" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>