<%@ Page Language="vb" masterpagefile="~/masters/FieldTechniciansdialog.master" %>
<%@ MasterType VirtualPath="~/masters/FieldTechniciansdialog.master" %>
<script runat="server">  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = ""
      Master.PageTitleText = ""
    End If
    lblReturnUrl.Text = Request.QueryString("returnurl")
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>