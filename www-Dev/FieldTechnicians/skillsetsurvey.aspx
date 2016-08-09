<%@ Page Language="vb" masterpagefile="~/masters/FieldTechniciansdialog.master" %>
<%@ MasterType VirtualPath="~/masters/FieldTechniciansdialog.master" %>
<script runat="server">  
  
  Dim _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)        
    If User.Identity.IsAuthenticated Then
      Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Master.WebLoginID = CType(User.Identity.Name, Long)
      par.Load(Master.PartnerAgentID)
      Try
        _ID = CType(Request.QueryString("id"), Long)
      Catch ex As Exception
        _ID = 0
      End Try
      If _ID > 0 Then
        If par.AdminAgent Then
          par.Load(_ID)
        Else
          Response.Redirect("default.aspx", True)
        End If
      End If
      If par.PartnerID <> Master.PartnerID Then
        Response.Redirect("default.aspx", True)
      End If
      _ID = par.PartnerAgentID
      Master.PageHeaderText = " Skill Set Survey For " & par.NameTag
      Master.PageTitleText = " Skill Set Survey"
      If Not IsPostBack Then
        LoadUnAnsweredQuestions(par.PartnerAgentID)
        LoadAnsweredQuestions(par.PartnerAgentID)
      End If
    End If
    lblCompanyName.Text = System.Configuration.ConfigurationManager.AppSettings("CompanyName")
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If lblReturnUrl.Text.Trim.Length = 0 Then
      lblReturnUrl.Text = "default.aspx"
    End If    
  End Sub
  
  Private Sub LoadUnAnsweredQuestions(ByVal lngID As Long)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListUnAnsweredSkillSetQuestions", "@PartnerAgentID", lngID, dgvUnansweredQuestions)
  End Sub
  
  Private Sub LoadAnsweredQuestions(ByVal lngID As Long)
    Dim rad As RadioButtonList
    Dim txt As TextBox
    Dim ssa As New BridgesInterface.SkillSetQuestionAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
    ldr.LoadSingleLongParameterDataGrid("spListPartnerSkillSurveyQuestions", "@PartnerAgentID", lngID, dgvAnswered)
    For Each itm As DataGridItem In dgvAnswered.Items
      rad = itm.FindControl("radSkillLevel")
      txt = itm.FindControl("txtYearsExperience")
      ssa.Load(CType(itm.Cells(0).Text, Long))
      rad.SelectedValue = ssa.SkillLevel
      txt.Text = ssa.YearsExperience      
    Next
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)    
    Response.Redirect(lblReturnUrl.Text, True)
  End Sub

  Private Sub btnSave_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      divErrors.Visible = False
      SaveAnswers()
      Response.Redirect(lblReturnUrl.Text, True)
    Else
      divErrors.Visible = True
    End If
  End Sub

  Private Sub btnApply_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      divErrors.Visible = False
      SaveAnswers()
      Response.Redirect("skillsetsurvey.aspx", True)
    Else
      divErrors.Visible = True
    End If    
  End Sub
  
  Private Sub SaveAnswers()
    Dim rad As RadioButtonList
    Dim txt As TextBox
    Dim lngLevel As Long = 0
    Dim lngYears As Long = 0
    Dim strChangeLog As String = ""
    Dim ssa As New BridgesInterface.SkillSetQuestionAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    For Each itm As DataGridItem In dgvUnansweredQuestions.Items
      rad = itm.FindControl("radSkillLevel")
      txt = itm.FindControl("txtYearsExperience")
      If txt.Text.Trim.Length + rad.SelectedValue.Trim.Length > 0 Then
        lngLevel = CType(rad.SelectedValue, Long)
        lngYears = CType(txt.Text, Long)
        ssa.Add(Master.UserID, CType(itm.Cells(0).Text, Long), _ID, lngLevel, lngYears)
      End If
    Next
    For Each itm As DataGridItem In dgvAnswered.Items
      rad = itm.FindControl("radSkillLevel")
      txt = itm.FindControl("txtYearsExperience")
      lngLevel = CType(rad.SelectedValue, Long)
      lngYears = CType(txt.Text, Long)
      ssa.Load(CType(itm.Cells(0).Text, Long))
      ssa.SkillLevel = lngLevel
      ssa.YearsExperience = lngYears
      ssa.Save(strChangeLog)
      Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim strIp As String = Request.QueryString("REMOTE_ADDR")
      Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
      If IsNothing(strIp) Then
        strIp = "unknown"
      End If
      If IsNothing(strType) Then
        strType = "web"
      End If
      act.Add(Master.UserID, "web", strType, strIp, Master.WebLoginID.ToString, 37, ssa.SkillSetQuestionAssignmentID, strChangeLog)
    Next
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    Dim lng As Long = 0
    Dim rad As RadioButtonList
    Dim txt As TextBox
    For Each itm As DataGridItem In dgvUnansweredQuestions.Items           
      rad = itm.FindControl("radSkillLevel")
      txt = itm.FindControl("txtYearsExperience")
      If txt.Text.Trim.Length + rad.SelectedValue.Trim.Length > 0 Then
        If txt.Text.Trim.Length = 0 Then
          blnReturn = False
          strErrors &= "<li>You Must Enter Years Experience For " & itm.Cells(1).Text & "</li>"
        Else
          If Not Long.TryParse(txt.Text, lng) Then
            blnReturn = False
            strErrors &= "<li>Years Experience Must Be a Whole Number For " & itm.Cells(1).Text & "</li>"
          End If
        End If
        If rad.SelectedValue.Trim.Length = 0 Then
          blnReturn = False
          strErrors &= "<li>You Must Choose a Skill Level For " & itm.Cells(1).Text & "</li>"
        End If
      End If      
    Next
    For Each itm As DataGridItem In dgvAnswered.Items
      rad = itm.FindControl("radSkillLevel")
      txt = itm.FindControl("txtYearsExperience")
      If txt.Text.Trim.Length + rad.SelectedValue.Trim.Length > 0 Then
        If txt.Text.Trim.Length = 0 Then
          blnReturn = False
          strErrors &= "<li>You Must Enter Years Experience For Previously Answered: " & itm.Cells(1).Text & "</li>"
        Else
          If Not Long.TryParse(txt.Text, lng) Then
            blnReturn = False
            strErrors &= "<li>Years Experience Must Be a Whole Number For Previously Answered: " & itm.Cells(1).Text & "</li>"
          End If
        End If
        If rad.SelectedValue.Trim.Length = 0 Then
          blnReturn = False
          strErrors &= "<li>You Must Choose a Skill Level For Previously Answered: " & itm.Cells(1).Text & "</li>"
        End If
      End If
    Next
    divErrors.innerhtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <table>
      <tbody>
        <tr>
          <td>
            <div id="divErrors" class="errorzone" runat="server" visible="false" />
            <div class="bandheader">To Be Answered</div>
            <asp:DataGrid ID="dgvUnansweredQuestions" style="width: 100%" runat="server" AutoGenerateColumns="false">
              <AlternatingItemStyle CssClass="altrow" />
              <HeaderStyle CssClass="gridheader" />
              <Columns>
                <asp:BoundColumn HeaderText="ID" DataField="SkillSetQuestionID" Visible="false" />
                <asp:BoundColumn HeaderText="Skill Set" DataField="Question" />
                <asp:TemplateColumn HeaderText="Skill&nbsp;Level">
                  <ItemTemplate>
                    <asp:RadioButtonlist runat="server" ID="radSkillLevel" RepeatDirection="Horizontal">
                      <asp:ListItem Text="0" Value="0" />
                      <asp:ListItem Text="1" Value="1" />
                      <asp:ListItem Text="2" Value="2" />
                      <asp:ListItem Text="3" Value="3" />
                      <asp:ListItem Text="4" Value="4" />
                      <asp:ListItem Text="5" Value="5" />
                    </asp:RadioButtonlist>
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Years&nbsp;Experience">
                  <ItemTemplate>
                    <asp:TextBox style="width: 50px;" ID="txtYearsExperience" runat="server" />
                  </ItemTemplate>
                </asp:TemplateColumn>
              </Columns>
            </asp:DataGrid>
            <div>&nbsp;</div>
            <div class="bandheader">Already Answered</div>
            <asp:DataGrid ID="dgvAnswered" style="width: 100%" runat="server" AutoGenerateColumns="false">
              <AlternatingItemStyle CssClass="altrow" />
              <HeaderStyle CssClass="gridheader" />
              <Columns>
                <asp:BoundColumn HeaderText="ID" DataField="SkillSetQuestionAssignmentID" Visible="false" />
                <asp:BoundColumn HeaderText="Skill Set" DataField="Question" />
                <asp:TemplateColumn HeaderText="Skill&nbsp;Level">
                  <ItemTemplate>
                    <asp:RadioButtonlist runat="server" ID="radSkillLevel" RepeatDirection="Horizontal">
                      <asp:ListItem Text="0" Value="0" />
                      <asp:ListItem Text="1" Value="1" />
                      <asp:ListItem Text="2" Value="2" />
                      <asp:ListItem Text="3" Value="3" />
                      <asp:ListItem Text="4" Value="4" />
                      <asp:ListItem Text="5" Value="5" />
                    </asp:RadioButtonlist>
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Years&nbsp;Experience">
                  <ItemTemplate>
                    <asp:TextBox style="width: 50px;" ID="txtYearsExperience" runat="server" />
                  </ItemTemplate>
                </asp:TemplateColumn>
              </Columns>
            </asp:DataGrid>          
          </td>
          <td>&nbsp;</td>
          <td style="width: 300px;">
            <p>Please fill out this skill set survey to assist <asp:Label ID="lblCompanyName" runat="server" /> more efficiently determine which training opportunities to offer and determine which types of work orders you are best suited to receive. </p>
            <div style="font-weight: bold;">While filling out the survey, please rate yourself according to the following scale:</div>
            <table>
              <tbody>
                <tr>
                  <td class="label">0</td>
                  <td>&nbsp;</td>
                  <td>I have no experience with this skill and I am not interested in learning.</td>
                </tr>
                <tr>
                  <td class="label">1</td>
                  <td>&nbsp;</td>
                  <td>I have very limited knowledge in this skill, but I would like to learn.</td>
                </tr>
                <tr>
                  <td class="label">2</td>
                  <td>&nbsp;</td>
                  <td>I know enough to get by so that others can’t tell what I don’t know.</td>
                </tr>
                <tr>
                  <td class="label">3</td>
                  <td>&nbsp;</td>
                  <td>I am comfortable with my abilities, and can demonstrate it at will.</td>
                </tr>
                <tr>
                  <td class="label">4</td>
                  <td>&nbsp;</td>
                  <td>I am extremely proficient at this skill.  People would recommend me specifically to handle this.</td>
                </tr>
                <tr>
                  <td class="label">5</td>
                  <td>&nbsp;</td>
                  <td>I am an expert at this skill, and I am able to teach others</td>
                </tr>   
              </tbody>
            </table>          
          </td>
        </tr>
      </tbody>
    </table>
    <div>&nbsp;</div>
    <div style="text-align: right"><asp:Button ID="btnCancel" runat="server" OnClick="btnCancel_Click" Text="Cancel" />&nbsp;<asp:Button ID="btnApply" runat="server" OnClick="btnApply_Click" Text="Apply" />&nbsp;<asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" Text="Save" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>