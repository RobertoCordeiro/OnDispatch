<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Skillset Report"
      Master.PageTitleText = "Skillset Report"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""reports.aspx"">Reports</a> &gt; <a href=""skillsetreport.aspx"">Skillset Report</a>"
      If Not IsPostBack Then
        LoadSkillSetQuestions()
      End If
    End If
  End Sub
  
  Private Sub LoadSkillSetQuestions()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDataGrid("spListSkillSetQuestions", dgvSkillSetQuestions)
  End Sub
  
  Private Sub btnClear_Click(ByVal S As Object, ByVal E As EventArgs)
    LoadSkillSetQuestions()
  End Sub
  
  Private Sub btnGetReport_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      Dim ds As New System.Data.DataSet
      Dim rad As RadioButtonList
      Dim txt As TextBox
      Dim lngID As Long = 0
      Dim lngLevel As Long = 0
      Dim lngYears As Long = 0
      divErrors.Visible = False
      For Each itm As DataGridItem In dgvSkillSetQuestions.Items
        lngID = CType(itm.Cells(0).Text, Long)
        rad = itm.FindControl("radSkillLevel")
        txt = itm.FindControl("txtYearsExperience")
        If txt.Text.Trim.Length + rad.SelectedValue.Trim.Length > 0 Then
          lngLevel = CType(rad.SelectedValue, Long)
          lngYears = CType(txt.Text, Long)
          LoadData(ds, lngID, lngLevel, lngYears)
        End If
      Next
      Me.dgvSkillSetReport.DataSource = ds
      Try
        Me.dgvSkillSetReport.DataBind()
        Dim exp As New cvCommon.Export
        Dim blnRequireSecure As Boolean = System.Configuration.ConfigurationManager.AppSettings("RequireSecureConnection")
        exp.DataGridToExcel(Response, Me.dgvSkillSetReport, "SkillSetReport.xls", "Sheet1", blnRequireSecure)
      Catch ex As Exception
      End Try
    Else
      divErrors.Visible = True
    End If
  End Sub
  
  Private Sub LoadData(ByRef ds As System.Data.DataSet, ByVal lngSkillSetQuestionID As Long, ByVal lngSkillLevel As Long, ByVal lngYearsExperience As Long)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListPartnerAgentsForSkillSet")
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    cmd.Parameters.Add("@SkillSetQuestionID", Data.SqlDbType.Int).Value = lngSkillSetQuestionID
    cmd.Parameters.Add("@SkillLevel", Data.SqlDbType.Int).Value = lngSkillLevel
    cmd.Parameters.Add("@YearsExperience", Data.SqlDbType.Int).Value = lngYearsExperience
    cmd.CommandType = Data.CommandType.StoredProcedure
    cnn.Open()
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    cnn.Close()
    cmd.Dispose()
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    Dim lng As Long = 0
    Dim rad As RadioButtonList
    Dim txt As TextBox
    For Each itm As DataGridItem In dgvSkillSetQuestions.Items
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
    divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmSkillset" runat="server">
    <div id="divErrors" runat="server" class="errorzone" visible="false" />
    <asp:DataGrid ID="dgvSkillSetQuestions" style="width: 100%" runat="server" AutoGenerateColumns="false">
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
    <div style="text-align: right;"><asp:Button ID="btnClear" runat="server" Text="Clear" OnClick="btnClear_Click" />&nbsp;<asp:Button ID="btnGetReport" Text="Get Report" OnClick="btnGetReport_Click" runat="server" /></div>
    <asp:DataGrid Visible="false" ID="dgvSkillSetReport" AutoGenerateColumns="false" runat="server">
      <AlternatingItemStyle CssClass="altrow" />
      <HeaderStyle CssClass="gridheader" />
      <Columns>
        <asp:BoundColumn DataField="Question" HeaderText="Skill" />
        <asp:BoundColumn DataField="Login" HeaderText="Agent" />
        <asp:BoundColumn DataField="City" HeaderText="City" />
        <asp:BoundColumn DataField="Abbreviation" HeaderText="State" />
        <asp:BoundColumn DataField="ZipCode" HeaderText="Zip" />
        <asp:BoundColumn DataField="SkillLevel" HeaderText="Skill Level" />
        <asp:BoundColumn DataField="YearsExperience" HeaderText="Years Experience" />
      </Columns>
    </asp:DataGrid>
  </form>
</asp:Content>