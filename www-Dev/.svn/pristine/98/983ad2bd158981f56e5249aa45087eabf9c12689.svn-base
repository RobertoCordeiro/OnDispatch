<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">

  Private _Mode As String = ""
  Private _Page As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Partner Management"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Partner Management"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; Partner Management"
      Try
        _Mode = Request.QueryString("mode")
        If _Mode.Trim.Length = 0 Then
          _Mode = "active"
        End If
        _Page = CType(Request.QueryString("page"), Long)
      Catch ex As Exception
        _Mode = "active"
        _Page = 0
      End Try
    End If
    LoadPartners()
    If Not IsPostBack Then
      LoadLookin()
    End If
  End Sub
  
  Private Sub LoadLookIn()
    With cbxLookIn.Items
      .Clear()
      .Add(cboxitem("Partner ID", "ResumeID"))
      .Add(cboxitem("Company Name", "companyname"))
      .Add(cboxitem("Name", "name"))
      .Add(cboxitem("Email", "email"))
      .Add(cboxitem("Zip Code", "zipcode"))
      .Add(cboxitem("City", "city"))
      .Add(cboxitem("State", "state"))
      .Add(cboxitem("Phone Number", "phone"))
    End With
  End Sub
  Private Function cboxitem(ByVal strText As String, ByVal strValue As String) As ListItem
    Dim itmReturn As New ListItem
    itmReturn.Text = strText
    itmReturn.Value = strValue
    Return itmReturn
  End Function
  Private Sub LoadPartners()
    divActiveBar.Attributes("class") = "bandbar"
        divInactiveBar.Attributes("class") = "bandbar"
        divholdBar.Attributes("class") = "bandbar"
        divExitingBar.Attributes("class") = "bandbar"
    Select Case _Mode
      Case "active"
        divActiveBar.Attributes("class") = "selectedbandbar"
        LoadActivePartners()
      Case "inactive"
        divInactiveBar.Attributes("class") = "selectedbandbar"
                LoadInActivePartners()
            Case "hold"
                divholdBar.Attributes("class") = "selectedbandbar"
                LoadHoldPartners()
            Case "exiting"
                divExitingBar.Attributes("class") = "selectedbandbar"
                LoadExitingPartners()
        End Select
  End Sub
  
  Private Sub LoadActivePartners()
        dgvPartners.CurrentPageIndex = _Page
        Dim inf As New BridgesInterface.CompanyInfoRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        inf.Load(Master.InfoID)
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadTwoLongParameterDataGrid("spListActivePartnersByInfoIDAndPartnerID", "@infoID", Master.InfoID, "@PartnerID", inf.PartnerID, dgvPartners)
        
  End Sub
  
  Private Sub LoadInActivePartners()
    dgvPartners.CurrentPageIndex = _Page
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSingleLongParameterDataGrid("spListInactivePartnersByInfoID", "@InfoID", Master.InfoID, dgvPartners)
        
    End Sub
    Private Sub LoadHoldPartners()
        dgvPartners.CurrentPageIndex = _Page
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSingleLongParameterDataGrid("spLIstActiveHoldPartnersByInfoID", "@InfoID", Master.InfoID, dgvPartners)
    End Sub
    
    Private Sub LoadExitingPartners()
        dgvPartners.CurrentPageIndex = _Page
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSingleLongParameterDataGrid("spListActiveExitingPartnersByInfoID", "@infoID", Master.InfoID, dgvPartners)
    End Sub
    
  Private Function BuildCompanyColumn(ByRef strCompanyName As String, ByRef strWebsite As Object) As String
    Dim val As New cvCommon.Validators
    Dim strReturn As String = strCompanyName
    If Not IsNothing(strWebsite) Then
      If Not IsDBNull(strWebsite) Then
        If strWebsite.ToString.Trim.Length > 0 Then
          If val.IsValidUrl("http://" & strWebsite.ToString) Then
            strReturn = "<a target=""_blank"" href=""http://" & strWebsite.ToString & """>" & strCompanyName & "</a>"
          End If
        End If
      End If
    End If
    Return strReturn
  End Function
  
  Protected Sub dgvPartners_PageIndexChanged(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs)
    Select Case _Mode.ToLower
      Case "active"
        Response.Redirect("partners.aspx?mode=active&page=" & e.NewPageIndex, True)
      Case "inactive"
                Response.Redirect("partners.aspx?mode=inactive&page=" & e.NewPageIndex, True)
            Case "hold"
                Response.Redirect("partners.aspx?mode=hold&page=" & e.NewPageIndex, True)
            Case "exiting"
                Response.Redirect("partners.aspx?mode=exiting&page=" & e.NewPageIndex, True)
        End Select
  End Sub
  
  Private Sub btnQuickSearch_Click(ByVal S As Object, ByVal E As EventArgs)
    If txtPartnerSearch.Text.Trim.Length > 0 Then
      Response.Redirect("partnersearch1.aspx?lookin=" & cbxLookIn.SelectedValue & "&criteria=" & Server.UrlEncode(txtPartnerSearch.Text.Trim), True)
    Else
      divResumeSearchError.InnerHtml = "You Must Enter Criteria"
      divResumeSearchError.Visible = True
    End If
  End Sub
  
    
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmPartners" runat="server" defaultbutton="btnQuickSearch">
    <table style="width: 100%">
      <tbody>
        <tr>
          <td style="width: 1%" class="band">
            <div class="bandheader">Lists</div>            
            <div id="divActiveBar" runat="server"><a href="partners.aspx?mode=active">Active</a></div>
            <div id="divholdBar" runat="server"><a href="partners.aspx?mode=hold">Hold</a></div>
            <div id="divExitingBar" runat="server"><a href="partners.aspx?mode=Exiting">Exiting</a></div>
            <div id="divInactiveBar" runat="server"><a href="partners.aspx?mode=inactive">Inactive</a></div>
            <div>&nbsp;</div>
            <div class="inputformsectionheader">Partner&nbsp;Search</div> 
            <div class="inputform" style="white-space: nowrap;">
              <div id="divResumeSearchError" class="errorzone" visible="false" runat="server" />
              <div style="padding-left: 3px;">
                <div class="label">Criteria</div>
                <div><asp:TextBox style="width:95%;" ID="txtPartnerSearch" runat="server" /></div>
                <div class="label">Look In</div>
                <div><asp:DropDownList ID="cbxLookIn" runat="server" /></div>
                <div style="text-align: right;"><asp:button ID="btnQuickSearch" OnClick="btnQuickSearch_Click" text="Search" runat="server" /></div>
              </div>
            </div>                      
          </td>
          <td>
            <asp:DataGrid style="width: 100%" ID="dgvPartners" runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="25" PagerStyle-Mode="NumericPages" OnPageIndexChanged="dgvPartners_PageIndexChanged" CssClass="Grid1">
              <AlternatingItemStyle CssClass="altrow" />
              <HeaderStyle CssClass="gridheader" />
              <Columns>
                <asp:BoundColumn DataField="partnerid" HeaderText="ID" Visible="false" />
                <asp:TemplateColumn
                  HeaderText="Partner ID">
                  <ItemTemplate>
                    <a href="partner.aspx?id=<%# DataBinder.Eval(Container.DataItem, "PartnerID") %>"><%#DataBinder.Eval(Container.DataItem, "ResumeID")%></a>&nbsp;<a href="resume.aspx?resumeid=<%# DataBinder.Eval(Container.DataItem, "ResumeID") %>">(Resume)</a>
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:BoundColumn HeaderText="Agents" DataField="AgentCount" />
                <asp:TemplateColumn HeaderText="Company">
                  <ItemTemplate>
                    <%# BuildCompanyColumn(DataBinder.Eval(Container.DataItem,"CompanyName"),databinder.Eval(Container.DataItem,"WebSite")) %>
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Email">
                  <ItemTemplate>
                    <a href="mailto:<%# DataBinder.Eval(Container.DataItem,"Email") %>"><%# DataBinder.Eval(Container.DataItem,"Email") %></a>
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:BoundColumn HeaderText="City" DataField="City" />
                <asp:BoundColumn HeaderText="State" DataField="Abbreviation" />
                <asp:TemplateColumn HeaderText="Zip">
                  <ItemTemplate>
                    <a href="findzipcode.aspx?zip=<%# Databinder.eval(Container.DataItem,"ZipCode") %>" target="_blank"><%# Databinder.eval(Container.DataItem,"ZipCode") %></a>
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="LocationID">
                  <ItemTemplate>
                    <a href="../Maps/<%# Databinder.eval(Container.DataItem,"LocationName") %>.jpg" target="_blank"><%# DataBinder.Eval(Container.DataItem,"LocationName") %></a>
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Local">
                  <ItemStyle CssClass="highlightcell" />
                  <ItemTemplate>
                    <%#CType(DataBinder.Eval(Container.DataItem, "LocalTime"), Date).ToString("hh:mm")%>
                  </ItemTemplate>
                </asp:TemplateColumn>               
                <asp:BoundColumn
                   HeaderText="Date Created"
                   DataField="DateCreated"
                   />
              </Columns>
            </asp:DataGrid>
          </td>
        </tr>
      </tbody>
    </table>
  </form>
</asp:Content>