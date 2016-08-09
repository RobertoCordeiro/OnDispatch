<%@ Page Language="VB" masterpagefile="~/masters/agent.master"%>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<%@ Register Src="~/controls/ticket.ascx" TagName="Ticket" TagPrefix="cv" %>
<script language="VB" runat="server">

  Public swfFileName as String = ""
  Private Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Dim lgn As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim strMode As String = ""
      If CType(Request.QueryString("mode"), String) <> "" Then
        strMode = Request.QueryString("mode")
      End If
            Dim strHeaderText As String = "Training Video"
      lgn.Load(CType(User.Identity.Name, Long))
      If lgn.WebLoginID > 0 Then
        Master.WebLoginID = lgn.WebLoginID
                Master.PageTitleText = "BSA Learning Center"
        Master.PageHeaderText = strHeaderText
               
                If Not Page.IsPostBack Then
                    LoadDepartments()
                End If
                'swfFileName = "../TrainingVideos/CheckOldMessages/CheckOldMessages.mp4"
                'swfFileName = "../TrainingVideos/SetScheduleAvailability/SetScheduleAvailability.mp4"
            Else
                Response.Redirect("/login.aspx", True)
            End If
        Else
            Response.Redirect("/login.aspx", True)
        End If
  End Sub
  
    Private Sub LoadDepartments()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSimpleDropDownList("spListDepartments", "DepartmentName", "DepartmentID", drpDepartments)
        drpDepartments.Items.Add("Choose One")
        drpDepartments.SelectedValue = "Choose One"
        dgvVideos.DataSource = Nothing
    End Sub
    Private Sub LoadDepartmentGroups(ByVal lngDepartmentID As Long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSingleLongParameterDropDownList("spGetDepartmentGroups", "@DepartmentID", lngDepartmentID, "GroupName", "GroupID", drpDepartmentGroups)
        drpDepartmentGroups.Items.Add("Choose One")
        drpDepartmentGroups.SelectedValue = "Choose One"
    End Sub
    
    Protected Sub drpDepartments_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        If drpDepartments.SelectedValue <> "Choose One" Then
            LoadDepartmentGroups(drpDepartments.SelectedValue)
            
        End If
    End Sub
    Protected Sub drpDepartmentGroups_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        If drpDepartmentGroups.SelectedValue <> "Choose One" Then
            Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            ldr.LoadSingleLongParameterDataGrid("spGetTrainingVideoByGroupID", "@GroupID", drpDepartmentGroups.SelectedValue, dgvVideos)
        End If
    End Sub
    
    Private Sub btnLinkView_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim m_ClientID As String = ""
        Dim bt As New LinkButton
        Dim rb As New LinkButton
        bt = CType(S, LinkButton)
        m_ClientID = bt.ClientID
        For Each i As DataGridItem In dgvVideos.Items
            rb = CType(i.FindControl("LinkView"), LinkButton)
            If (rb.ClientID = bt.ClientID) Then
                swfFileName = i.Cells(4).Text
            End If
        Next
    End Sub
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="bodycontent" runat="server">
  <form id="frmTrainingVideo" runat="server"> 
  <table>
    <tr>
      <td>
      <div > 
        <p > 
          <object classid="clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B" width="600" height="498" codebase="http://www.apple.com/qtactivex/qtplugin.cab">
           <param name="src" value="<% =swfFileName%>" />
           <param name="autoplay" value="false" />
           <param name="controller" value="true" />
           <embed src="<% =swfFileName%>" autoplay="false" controller="true" width="600" height="498" pluginspage="http://www.apple.com/quicktime/download/"></embed>
          </object>
        </p> 
      </div> 
      <div>&nbsp;</div>
      </td>
      <td></td>
      <td></td>
      <td>
        <div>
           <div class ="label">Departments</div>
           <asp:DropDownList ID="drpDepartments" runat="server"  AutoPostBack = "true" OnSelectedIndexChanged="drpDepartments_SelectedIndexChanged" />&nbsp;&nbsp;&nbsp;<asp:DropDownList ID="drpDepartmentGroups" runat="server" AutoPostBack ="true" OnSelectedIndexChanged ="drpDepartmentGroups_SelectedIndexChanged" />
           <asp:DataGrid ID="dgvVideos" runat="server" AutoGenerateColumns="false" style="width: 600px;">
           <AlternatingItemStyle CssClass="altrow" />
           <HeaderStyle CssClass="gridheader" />
              <Columns>
                 <asp:BoundColumn DataField="TrainingVideoID" HeaderText="TrainingVideoID" Visible="false" />
                 <asp:TemplateColumn>
                    <ItemTemplate>
                      <asp:LinkButton id="LinkView" OnClick="btnLinkView_Click" runat="server">View</asp:LinkButton>
                    </ItemTemplate>
               </asp:TemplateColumn>
           <asp:BoundColumn DataField="Title" HeaderText="Title" />
           <asp:BoundColumn DataField="Subject" HeaderText="Subject" />
           <asp:BoundColumn DataField="FilePath" HeaderText="FilePath" Visible="false" />
      </Columns>
    </asp:DataGrid>
  </div>
      </td>
    </tr>
  </table>
  </form>
</asp:Content>
