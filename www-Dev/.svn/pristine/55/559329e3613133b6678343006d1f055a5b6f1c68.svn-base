<%@ Page Language="vb" masterpagefile="~/masters/partnerdialog.master" %>
<%@ MasterType VirtualPath="~/masters/partnerdialog.master" %>
<script runat="server"> 
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Remove Address"
      Master.PageTitleText = " Remove Address"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If _ID > 0 Then
      LoadAddress()
    Else
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub

  Private Sub LoadAddress()
    Dim aaa As New BridgesInterface.PartnerAgentAddressAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
    aaa.Load(_ID)
    Dim add As New BridgesInterface.PartnerAddressRecord(aaa.ConnectionString)
    add.Load(aaa.PartnerAddressID)
    lblAddress.Text = "<div><pre>" & add.Street & "</pre></div>"
  End Sub
    
  Private Sub btnOK_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim apa As New BridgesInterface.PartnerAgentAddressAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    apa.Load(_ID)
    apa.Delete()
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div>&nbsp;</div>
    <div>Are you sure you wish to disassociate <asp:Label ID="lblAddress" runat="server" /></div>
    <div>&nbsp;</div>
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnOk" OnClick="btnOK_Click" Text="Yes" runat="server" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>