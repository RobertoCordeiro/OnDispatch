<%@ Page Language="vb" masterpagefile="~/masters/agent.master" ValidateRequest="false" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)    
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Edit FAQ"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Edit FAQ"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""faqs.aspx"">Faqs</a> &gt; Edit FAQ"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If _ID > 0 Then
      If Not IsPostBack Then
        LoadFaq(_ID)
      End If
    Else
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub
  
  Private Sub LoadFaq(ByVal lngFAQID As Long)
    Dim faq As New BridgesInterface.FaqRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    faq.Load(lngFAQID)
    txtTitle.Text = faq.Title
    chkPublic.Checked = faq.PublicFaq
    LoadQuestions(lngFAQID)
  End Sub

  Private Sub LoadQuestions(ByVal lngFAQID As Long)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListFaqQuestions")
    cmd.CommandType = Data.CommandType.StoredProcedure
    cmd.Parameters.Add("@FaqID", Data.SqlDbType.Int).Value = lngFAQID
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvQuestions.DataSource = ds
    dgvQuestions.DataBind()
    dgvAnswers.DataSource = ds
    dgvAnswers.DataBind()
    cnn.Close()
  End Sub
  
  Private Sub btnOK_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      Dim strChangeLog As String = ""
      Dim faq As New BridgesInterface.FaqRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      faq.Load(_ID)
      faq.Title = txtTitle.Text
      faq.PublicFaq = chkPublic.Checked
      faq.Save(strChangeLog)
      Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim strIp As String = Request.QueryString("REMOTE_ADDR")
      Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
      If IsNothing(strIp) Then
        strIp = "unknown"
      End If
      If IsNothing(strType) Then
        strType = "web"
      End If
      act.Add(Master.UserID, "web", strType, strIp, "web", 26, faq.FaqID, strChangeLog)
      If txtQuestion.Text.Trim.Length + txtAnswer.Text.Trim.Length > 0 Then
        Dim fqq As New BridgesInterface.FaqQuestionRecord(faq.ConnectionString)
        fqq.Add(faq.FaqID, Master.UserID, txtQuestion.Text, txtAnswer.Text)
        txtQuestion.Text = ""
        txtAnswer.Text = ""
        LoadFaq(_ID)
      End If
    Else
      divErrors.Visible = True
    End If
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If txtTitle.Text.Trim.Length = 0 Then
      strErrors &= "<li>Title is Required</li>"
      blnReturn = False
    End If
    If txtQuestion.Text.Trim.Length + txtAnswer.Text.Trim.Length > 0 Then
      If txtQuestion.Text.Trim.Length = 0 Then
        strErrors &= "<li>Question is Required</li>"
        blnReturn = False
      End If
      If txtAnswer.Text.Trim.Length = 0 Then
        strErrors &= "<li>Answer is Required</li>"
        blnReturn = False
      End If
    End If
    divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn    
  End Function
  
  Private Function ReturnToMe() As String
    Dim strQueryString As String = Request.ServerVariables("QUERY_STRING")
    Dim strReturn As String = "editfaq.aspx%3f" & strQueryString
    Return strReturn
  End Function
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmFaq" runat="server">
    <div class="errorzone" id="divErrors" runat="server" visible="false" />
    <div class="Label">FAQ</div>
    <div><asp:TextBox ID="txtTitle" style="width: 99%" runat="server" /></div>
    <div><asp:CheckBox ID="chkPublic" Text="Public" runat="server" /></div>
    <div class="bandheader">Questions</div>
    <asp:DataGrid ID="dgvQuestions" ItemStyle-BorderStyle="None" AlternatingItemStyle-BorderStyle="none" GridLines="none" AutoGenerateColumns="false" ShowHeader="false"  BorderStyle="None" style="width: 100%" runat="server">
      <AlternatingItemStyle CssClass="altrow" /> 
      <Columns>
        <asp:TemplateColumn>
          <ItemTemplate>
            <a href="#<%# databinder.eval(Container.DataItem,"FaqQuestionID") %>"><%# databinder.eval(Container.DataItem,"Question") %></a>
          </ItemTemplate>
        </asp:TemplateColumn>
      </Columns>
    </asp:DataGrid>
    <div class="bandheader">Answers</div>
      <asp:DataGrid ID="dgvAnswers" GridLines="horizontal" AutoGenerateColumns="false" ShowHeader="false" BorderStyle="None" style="width: 100%" runat="server">
      <AlternatingItemStyle CssClass="altrow" /> 
      <Columns>
        <asp:TemplateColumn>
          <ItemTemplate>
            <a name="<%# databinder.eval(Container.DataItem,"FaqQuestionID") %>" />
            <div class="label">Q:&nbsp;<%# databinder.eval(Container.DataItem,"Question") %></div>
            <div>&nbsp;</div>
            <div><span class="label">A:&nbsp;</span><%#DataBinder.Eval(Container.DataItem, "Answer")%></div>
            <div style="text-align: right;"><a href="editfaqquestion.aspx?id=<%#DataBinder.Eval(Container.DataItem, "FaqQuestionID")%>&returnurl=<%# ReturnToMe %>">[Edit]</a>&nbsp;<a href="deletefaqquestion.aspx?id=<%#DataBinder.Eval(Container.DataItem, "FaqQuestionID")%>&returnurl=<%# ReturnToMe %>">[Delete]</a></div>
            <div>&nbsp;</div>            
          </ItemTemplate>
        </asp:TemplateColumn>
      </Columns>
    </asp:DataGrid>
    <div class="label">Add Question</div>
    <div><asp:TextBox style="width: 99%" ID="txtQuestion" runat="server" MaxLength="255" /></div>
    <div class="label">Answer</div>
    <asp:TextBox style="width: 99%" ID="txtAnswer" TextMode="multiLine" runat="server" />    
    <div style="text-align: right"><asp:Button OnClick="btnOK_Click" ID="btnOK" Text="Save" runat="server" /></div>
    <asp:Label ID="lblReturnUrl" runat="server" />
  </form>
</asp:Content>