<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" ValidateRequest="false" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server">
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Edit Question"
      Master.PageTitleText = " Edit Question"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; "
    End If
    Try
      _ID = Request.QueryString("id")
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
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
  Private Sub LoadQuestion(ByVal ID As Long)
    Dim fqq As New BridgesInterface.FaqQuestionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    fqq.Load(ID)
    txtQuestion.Text = fqq.Question
    txtAnswer.Text = fqq.Answer
  End Sub
  
    
  Private Sub btnOK_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      divErrors.Visible = False
      Dim strChangeLog As String = ""
      Dim fqq As New BridgesInterface.FaqQuestionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      fqq.Load(_ID)
      fqq.Answer = txtAnswer.Text
      fqq.Question = txtQuestion.Text
      fqq.Save(strChangeLog)
      Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim strIp As String = Request.QueryString("REMOTE_ADDR")
      Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
      If IsNothing(strIp) Then
        strIp = "unknown"
      End If
      If IsNothing(strType) Then
        strType = "web"
      End If
      act.Add(Master.UserID, "web", strType, strIp, "web", 27, fqq.FaqQuestionID, strChangeLog)
      Response.Redirect(lblReturnUrl.Text, True)
    Else
      divErrors.Visible = True
    End If
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If txtQuestion.Text.Trim.Length = 0 Then
      strErrors &= "<li>Question is Required</li>"
      blnReturn = False
    End If
    If txtAnswer.Text.Trim.Length = 0 Then
      strErrors &= "<li>Answer is Required</li>"
      blnReturn = False
    End If
    divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div class="errorzone" id="divErrors" runat="server" visible="false" />
    <div class="label">Add Question</div>
    <div><asp:TextBox style="width: 99%" ID="txtQuestion" runat="server" MaxLength="255" /></div>
    <div class="label">Answer</div>
    <asp:TextBox style="width: 99%" ID="txtAnswer" TextMode="multiLine" runat="server" />    
    <div style="text-align: right"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" Text="Cancel" runat="server" />&nbsp;<asp:Button OnClick="btnOK_Click" ID="btnOK" Text="Save" runat="server" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>