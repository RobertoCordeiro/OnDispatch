<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server"> 
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Delete Question"
      Master.PageTitleText = " Delete Question"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""faqs.aspx"">FAQs</a> &gt; Delete Question"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If _ID > 0 Then
      If Not IsPostBack Then
        LoadQuestion(_ID)
      End If
    Else
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub

  Private Sub LoadQuestion(ByVal ID As Long)
    Dim fqq As New BridgesInterface.FaqQuestionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    fqq.Load(ID)
    lblQuestion.Text = fqq.Question
  End Sub
  
  Private Sub btnDelete_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim fqq As New BridgesInterface.FaqQuestionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    fqq.Load(_ID)
    If fqq.FaqQuestionID > 0 Then
      fqq.Delete()
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div class="label"><asp:Label ID="lblQuestion" runat="server" /></div>
    Are you sure you wish to delete this question?
    <div style="text-align: right"><asp:Button ID="btnCancel" Text="Cancel" OnClick="btnCancel_Click" runat="server" />&nbsp;<asp:Button OnClick="btnDelete_Click" ID="btnDelete" Text="Delete" runat="server" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>