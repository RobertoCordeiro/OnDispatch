<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<%@ Register Src="~/controls/Address.ascx" TagName="Address" TagPrefix="cv" %>
<script runat="server">
  
  Private _ID As Long = 0
  Private _Page As Long = 0
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Recruitment Campaign"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Recruitment Campaign"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""recruit.aspx"">Recruitment</a> &gt; "
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
      _Page = CType(Request.QueryString("page"), Long)
    Catch ex As Exception
      _ID = 0
      _Page = 0
    End Try
    If _ID = 0 Then
      Response.Redirect("recruit.aspx", True)
    Else
            If Not IsPostBack Then
                Dim cmp As New BridgesInterface.RecruitmentCampaignRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                cmp.Load(_ID)
                If cmp.RecruitmentCampaignID > 0 Then
                    LoadLocations(_ID)
                    Master.PageSubHeader &= cmp.Description & " Recruitment Campaign"
                Else
                    Response.Redirect("recruit.aspx", True)
                End If
                
            End If
        End If
    End Sub

  Private Sub btnAdd_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      divErrors.Visible = False
            AddLocation()
            Response.Redirect("recruitmentcampaign.aspx?id=" & _ID, True)
    Else
      divErrors.Visible = True
    End If
  End Sub

  Private Sub AddLocation()
    Dim strTrash As String = ""
    Dim clc As New BridgesInterface.RecruitementCampaignLocationRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    clc.Add(Master.UserID, _ID, add.StateID, add.Street, add.City, add.Zip)
    clc.Extended = add.Extended
    clc.Misc = txtMisc.Text
    clc.Save(strTrash)
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If add.Street.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Street is Required</li>"
    End If
    If add.City.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>City is Required</li>"
    End If
    If add.Zip.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Zip Code Is Required</li>"
    Else
      Dim zip As New BridgesInterface.ZipCodeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      zip.Load(add.Zip)
      If zip.ZipCodeID = 0 Then
        blnReturn = False
        strErrors &= "<li>Zip Code is Invalid</li>"
      End If
    End If
    divErrors.innerhtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
  Private Sub LoadLocations(ByVal lngCampaignID As Long)
    dgvLocations.CurrentPageIndex = _Page
    Dim chk As CheckBox
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListRecruitmentCampaignLocations", "@RecruitmentCampaignID", lngCampaignID, dgvLocations)
    For Each itm As DataGridItem In dgvLocations.Items
      chk = itm.FindControl("chkActive")
      chk.Checked = itm.Cells(1).Text
    Next
  End Sub
  
  Protected Sub dgvLocations_PageIndexChanged(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs)
    Response.Redirect("recruitmentcampaign.aspx?id=" & _ID & "&page=" & e.NewPageIndex, True)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmLocations" runat="server">
    <div class="inputformsectionheader">Quick Add</div>
    <div class="inputform" style="padding-left: 3px; padding-right: 8px;">
      <div class="errorzone" id="divErrors" runat="server" visible="false" />
      <cv:Address ID="add" ShowType="false" runat="server" />
      <div class="label">Misc</div>
      <asp:TextBox ID="txtMisc" runat="server" style="width: 100%" />
      <div>&nbsp;</div>
      <div style="text-align: right"><asp:Button ID="btnAdd" runat="Server" Text="Add" OnClick="btnAdd_Click" /></div>
    </div>
    <div>&nbsp;</div>
    <div class="inputformsectionheader">Recruitment Campaign Locations</div>
    <asp:DataGrid ID="dgvLocations" runat="server" PagerStyle-Mode="NumericPages"  AutoGenerateColumns="false" style="width: 100%" AllowPaging="true" PageSize="50" OnPageIndexChanged="dgvLocations_PageIndexChanged">
      <HeaderStyle CssClass="gridheader" />
      <AlternatingItemStyle CssClass="altrow" />
      <Columns>
        <asp:BoundColumn DataField="RecruitmentCampaignLocationID" Visible="false" HeaderText="ID" />
        <asp:BoundColumn DataField="Active" HeaderText="Active" Visible="false" />
        <asp:TemplateColumn HeaderText="Active" Visible="false">
          <ItemTemplate>
            <asp:CheckBox ID="chkActive" runat="server" />
          </ItemTemplate>          
        </asp:TemplateColumn>
        <asp:TemplateColumn HeaderText="Address">
          <ItemTemplate>
            <%# Databinder.eval(Container.DataItem,"Street") %>&nbsp;<%#DataBinder.Eval(Container.DataItem, "Extended")%>
          </ItemTemplate>
        </asp:TemplateColumn>
        <asp:BoundColumn HeaderText="City" DataField="City" />
        <asp:BoundColumn HeaderText="State" DataField="abbreviation" />
        <asp:TemplateColumn HeaderText="Zip Code">
          <ItemTemplate>
            <a target="_blank" href="findzipcode.aspx?zip=<%# DataBinder.Eval(Container.DataItem,"ZipCode") %>"><%# DataBinder.Eval(Container.DataItem,"ZipCode") %></a>
          </ItemTemplate>
        </asp:TemplateColumn>
      </Columns>
    </asp:DataGrid>
    
  </form>
</asp:Content>