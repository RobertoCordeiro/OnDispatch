<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server"> 
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Remove Labor Network"
      Master.PageTitleText = " Remove Labor Network"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If _ID > 0 Then
      LoadResumeType()
    Else
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub

  Private Sub LoadResumeType()
    Dim par As New BridgesInterface.PartnerAgentResumeTypeRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
    par.Load(_ID)
    Dim rtr As New BridgesInterface.ResumeTypeRecord(par.ConnectionString)
    rtr.Load(par.ResumeTypeID )
    lblResumeType.Text = "<div><pre>" & rtr.ResumeType  & "</pre></div>"
  End Sub
    
  Private Sub btnOK_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim par As New BridgesInterface.PartnerAgentResumeTypeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    par.Load(_ID)
    par.Delete()
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div>&nbsp;</div>
    <div>Are you sure you wish to disassociate <asp:Label ID="lblResumeType" runat="server" /></div>
    <div>&nbsp;</div>
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnOk" OnClick="btnOK_Click" Text="Yes" runat="server" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>