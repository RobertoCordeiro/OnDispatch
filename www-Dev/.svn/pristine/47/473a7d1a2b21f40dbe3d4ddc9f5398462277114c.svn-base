<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Skillset Survey Question Control"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Skillset Survey Question Control"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; Skillset Survey Question Control"
    End If
    If Not IsPostBack Then
      LoadSkillSetQuestions()
    End If
  End Sub
  
  Private Sub LoadSkillSetQuestions()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDataGrid("spListSkillSetQuestions", dgvQuestions)
  End Sub
  
  Private Sub btnAdd_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      divErrors.Visible = False
      Dim ssq As New BridgesInterface.SkillSetQuestionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      ssq.Add(Master.UserID, txtQuestion.Text)
      Response.Redirect("skillsetsurveyquestions.aspx", True)      
    Else
      divErrors.Visible = True
    End If
  End Sub

  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If txtQuestion.Text.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Question is Required</li>"
    End If
    divErrors.innerhtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
 
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">

  <form id="frmDialog" runat="server" defaultbutton="btnAdd">
    <asp:DataGrid ID="dgvQuestions" runat="server" style="width: 100%" AutoGenerateColumns="false">
      <HeaderStyle CssClass="gridheader" />
      <AlternatingItemStyle CssClass="altrow" />
      <Columns>
        <asp:BoundColumn HeaderText="ID" DataField="SkillSetQuestionID" Visible="false" />
        <asp:BoundColumn HeaderText="Question/Skill" DataField="Question" />
        <asp:TemplateColumn HeaderText="Author">
          <ItemTemplate>
            <a href="mailto:<%# DataBinder.Eval(Container.DataItem,"Email") %>"><%# DataBinder.Eval(Container.DataItem,"Author") %></a>
          </ItemTemplate>
        </asp:TemplateColumn>
        <asp:BoundColumn HeaderText="Date Created" DataField="DateCreated" />
      </Columns>
    </asp:DataGrid>
    <div class="errorzone" id="divErrors" runat="server" visible="false" />
    <div>&nbsp;</div>
    <div class="label">Question Quick Add</div>
    <div style="padding-right: 6px;"><asp:TextBox ID="txtQuestion" runat="server" style="width: 100%" /></div>
    <div style="text-align: right;"><asp:Button OnClick="btnAdd_Click" ID="btnAdd" runat="server" Text="Add" />&nbsp;</div>    
  </form>

</asp:Content>