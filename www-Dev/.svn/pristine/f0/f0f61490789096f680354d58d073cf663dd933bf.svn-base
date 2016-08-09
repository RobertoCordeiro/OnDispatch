<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server">  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Add Certifying Agency"
      Master.PageTitleText = "Add Certifying Agency"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""certifications.aspx"">Certifications</a> &gt; Add Certifying Agency"
    End If
    lblReturnUrl.Text = Request.QueryString("returnurl")
  End Sub     

  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub

  Private Sub btnSubmit_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      divErrors.Visible = False
      Dim car As New BridgesInterface.CertificateAgencyRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      car.Add(Master.UserID, txtCertifierName.Text.Trim)
      Response.Redirect(lblReturnUrl.Text)
    Else
      divErrors.Visible = True
    End If
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim strErrors As String = ""
    Dim blnReturn As Boolean = True
    If txtCertifierName.Text.Trim.Length = 0 Then
      strErrors &= "<li>Certifying Agency Name Is Required</li>"
      blnReturn = False
    End If
    divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
  Private Sub SaveAgency()
    Dim cta As New BridgesInterface.CertificateAgencyRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))    
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div class="errorzone" id="divErrors" runat="server" visible="false" />
    <div class="label">Certifying Agency Name</div>
    <div><asp:TextBox style="width: 99%" ID="txtCertifierName" runat="server" /></div>
    <div style="text-align: right;"><asp:Button ID="btnCancel" runat="server" OnClick="btnCancel_Click" Text="Cancel" />&nbsp;<asp:Button ID="btnSubmit" OnClick="btnSubmit_Click" Text="Submit" runat="server" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>