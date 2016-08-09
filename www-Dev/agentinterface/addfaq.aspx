<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" ValidateRequest="false" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server">  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Add FAQ"
      Master.PageTitleText = "Add FAQ"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; Add FAQ"
    End If    
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If Not IsPostBack Then
      chkPublic.Checked = True
    End If
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text, True)
  End Sub
  
  Private Sub btnOK_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      AddFAQ()
      divErrors.Visible = False
    Else
      divErrors.Visible = True
    End If
  End Sub
  
  Private Sub AddFAQ()
    Dim strTrash As String = ""
    Dim faq As New BridgesInterface.FaqRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim fqq As New BridgesInterface.FaqQuestionRecord(faq.ConnectionString)
    faq.Add(txtTitle.Text, Master.UserID)
    faq.PublicFaq = chkPublic.Checked
    faq.Save(strTrash)
    fqq.Add(faq.FaqID, Master.UserID, txtQuestion.Text, txtAnswer.Text)
    Response.Redirect("editfaq.aspx?id=" & faq.FaqID & "&returnurl=faqs.aspx", True)
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If txtTitle.Text.Trim.Length = 0 Then
      strErrors &= "<li>The Title of the FAQ is Required</li>"
      blnReturn = False
    End If
    If txtQuestion.Text.Trim.Length = 0 Then
      strErrors &= "<li>The First Question of the FAQ is Required</li>"
      blnReturn = False
    End If
    If txtAnswer.Text.Trim.Length = 0 Then
      strErrors &= "<li>The Answer to the First Question of the FAQ is Required</li>"
      blnReturn = False
    End If
    divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div id="divErrors" class="errorzone" visible="false" runat="server" />
    <div class="label">Title of FAQ</div>
    <div><asp:TextBox style="width: 99%" ID="txtTitle" runat="server" MaxLength="128" /></div>
    <div>&nbsp;</div>
    <div class="label">First Question</div>
    <div><asp:TextBox style="width: 99%" ID="txtQuestion" runat="server" MaxLength="255" /></div>
    <div class="label">Answer</div>
    <asp:TextBox style="width: 99%" ID="txtAnswer" TextMode="multiLine" runat="server" />
    <div><asp:CheckBox id="chkPublic" Text="Public FAQ" runat="server" /></div>
    <div style="text-align: right"><asp:button ID="btnCancel" Text="Cancel" OnClick="btnCancel_Click" runat="server" />&nbsp;<asp:Button OnClick="btnOK_Click" ID="btnOK" Text="Add" runat="server" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />    
  </form>
</asp:Content>