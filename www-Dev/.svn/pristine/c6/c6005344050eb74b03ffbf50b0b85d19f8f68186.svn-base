<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
  
  Private _ZipCode As String = ""
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Zip Code Lookup"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Zip Code Lookup"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; Zip Code Lookup"
    End If
    Dim strZipCode As String = Request.QueryString("zip")
    Dim lng As Long = 0    
    Try            
      If Long.TryParse(Request.QueryString("rad"), lng) Then
        If Not IsPostBack Then
          txtRadius.Text = lng.ToString
        End If
      Else
        If Not IsPostBack Then
          txtRadius.Text = "50"
        End If        
      End If     
    Catch ex As Exception
      txtRadius.Text = "50"
    End Try
    If Not IsPostBack Then
      txtZipCode.Text = strZipCode
    End If
    If IsNothing(strZipCode) Then
      divSearchForm.Visible = True
    Else
      divSearchForm.Visible = True
      DisplayZip(strZipCode)
    End If
  End Sub
  
  Private Sub DisplayZip(ByVal strZipCode As String)
    Dim zip As New BridgesInterface.ZipCodeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim stt As New BridgesInterface.StateRecord(zip.ConnectionString)
    Dim cnt As New BridgesInterface.CountryRecord(zip.ConnectionString)
    Dim ctp As New BridgesInterface.CityTypeRecord(zip.ConnectionString)
    Dim ggl As New cvCommon.Googler    
    zip.Load(strZipCode.Trim)
    _ZipCode = strZipCode.Trim
    If zip.ZipCodeID > 0 Then
      stt.Load(zip.StateID)
      cnt.Load(stt.CountryID)
      ctp.Load(zip.CityTypeID)
      divResults.Visible = True
      lnkMapIt.HRef = ggl.MapZipCode(strZipCode.Trim)
      lblZipCode.Text = zip.ZipCode
      lblLocalTime.Text = zip.LocalTime.ToString
      lblCountry.Text = cnt.CountryName
      lblState.Text = stt.StateName
      lblCounty.Text = zip.CountyName
      lblCity.Text = zip.City
      lblCityAbbr.Text = zip.CityAliasAbbr
      lblCityAlias.Text = zip.CityAliasName
      lblCityType.Text = ctp.CityType
      lblAreaCode.Text = zip.AreaCode
      lblLatitude.Text = zip.Latitude
      lblLongitude.Text = zip.Longitude
      lblPopulation.Text = zip.Population
      lblSurfaceArea.Text = zip.CountiesArea
      lblAverageIncome.Text = zip.IncomePerHouseHold.ToString("C2")
      lblAverageHouseValue.Text = zip.AverageHouseValue.ToString("C2")
      lblPeoplePerHousehould.Text = zip.PersonsPerHouseHold
      LoadClosestResumes(zip.ZipCode, CType(txtRadius.Text, Long))
      LoadClosestPartnerAgents(zip.ZipCode, CType(txtRadius.Text, Long))
    Else
      divNotFound.Visible = True
      divResults.Visible = False      
    End If
  End Sub
  
  Private Sub LoadClosestResumes(ByVal strZipCode As String, ByVal lngRadius As Long)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadLongStringParameterDataGrid("spListClosestResumesToZipCode", "@Radius", lngRadius, "@ZipCode", strZipCode, dgvClosestResumes)
  End Sub

  Private Sub LoadClosestPartnerAgents(ByVal strZipCode As String, ByVal lngRadius As Long)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadLongStringParameterDataGrid("spListClosestPartnerAgentsToZipCode", "@Radius", lngRadius, "@ZipCode", strZipCode, dgvClosestAgents)
  End Sub
  
  Public Sub btnSubmit_Click(ByVal S As Object, ByVal E As EventArgs)    
    If IsComplete() Then
      divErrors.Visible = False
      Response.Redirect("findzipcode.aspx?zip=" & txtZipCode.Text & "&rad=" & txtRadius.Text, True)
    Else
      divResults.Visible = False
      divNotFound.Visible = False
      divErrors.Visible = True
    End If
  End Sub

  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    Dim lng As Long = 0
    If txtZipCode.Text.Trim.Length = 0 Then
      strErrors &= "<li>Zip Code Required</li>"
      blnReturn = False
    End If
    If txtRadius.Text.Trim.Length = 0 Then
      strErrors &= "<li>Radius is Required</li>"
      blnReturn = False
    Else
      If Not Long.TryParse(txtRadius.Text, lng) Then
        blnReturn = False
        strErrors &= "<li>Radius must be a whole number</li>"
      End If
    End If
    divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function

  
  Private Function CurrentZip() As String
    Return Request.QueryString("zip")
  End Function
  
  Private Function ZipToZip(ByVal strDestinationZipCode As String) As String
    Dim ggl As New cvCommon.Googler
    Dim strReturn As String = ggl.ZipToZip(strDestinationZipCode, _ZipCode)
    Return strReturn
  End Function
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmLookup" runat="server">
    <div id="divSearchForm" class="inputform" runat="server" visible="false">
      <div class="inputformsectionheader">Zip Code Lookup</div>
      <div>&nbsp;</div>
      <div style="margin-left: auto; margin-right: auto; width: 200px;">
        <div class="errorzone" id="divErrors" visible="false" runat="server" />
        <div class="label">Enter Zip Code</div>
        <asp:TextBox style="width: 99%" ID="txtZipCode" runat="server" />
        <div class="label">Radius</div>
        <asp:TextBox style="width: 50%" ID="txtRadius" runat="server" />
        <div style="text-align: right;"><asp:Button ID="btnSubmit" Onclick="btnSubmit_Click" runat="server" Text="Find" /></div>
      </div>
      <div>&nbsp;</div>
    </div>    
    <div style="margin-top: 32px;" id="divNotFound" visible="false" runat="server">Zip Code Not Found, <a href="findzipcode.aspx">Retry</a>?</div>
    <div id="divResults" visible="false" runat="server" class="inputform">
      <div class="inputformsectionheader">Results</div>
      <table style="margin-left: auto; margin-right: auto">
        <tbody>
          <tr>
            <td class="label">Zip Code</td>
            <td><a id="lnkMapIt" target="_blank" runat="server"><asp:Label ID="lblZipCode" runat="server" /></a></td>
            <td>&nbsp;</td>
            <td class="label">Current Local Time</td>
            <td><asp:Label ID="lblLocalTime" runat="server" /></td>
          </tr>
          <tr>
            <td class="label">Country</td>
            <td><asp:Label ID="lblCountry" runat="server" /></td>
            <td>&nbsp;</td>
            <td class="label">State</td>
            <td><asp:Label ID="lblState" runat="server" /></td>
          </tr>          
          <tr>
            <td class="label">County</td>
            <td><asp:Label ID="lblCounty" runat="server" /></td>
            <td>&nbsp;</td>
            <td class="label">City</td>
            <td><asp:Label ID="lblCity" runat="server" /></td>
          </tr>          
          <tr>
            <td class="label">Alias</td>
            <td><asp:Label ID="lblCityAlias" runat="server" /></td>
            <td>&nbsp;</td>
            <td class="label">Abbr</td>
            <td><asp:Label ID="lblCityAbbr" runat="server" /></td>
          </tr>          
          <tr>
            <td class="label">Type</td>
            <td><asp:Label ID="lblCityType" runat="server" /></td>
            <td>&nbsp;</td>
            <td class="label">Area Code</td>
            <td><asp:Label ID="lblAreaCode" runat="server" /></td>
          </tr>          
          <tr>
            <td class="label">Latitude</td>
            <td><asp:Label ID="lblLatitude" runat="server" /></td>
            <td>&nbsp;</td>
            <td class="label">Longitude</td>
            <td><asp:Label ID="lblLongitude" runat="server" /></td>
          </tr>                    
          <tr>
            <td class="label">Surface Area</td>
            <td><asp:Label ID="lblSurfaceArea" runat="server" /></td>
            <td>&nbsp;</td>
            <td class="label">&nbsp;</td>
            <td>&nbsp;</td>
          </tr> 
          <tr>
            <td colspan="5">&nbsp;</td>
          </tr>                    
          <tr>
            <td class="label">Population</td>
            <td><asp:Label ID="lblPopulation" runat="server" /></td>
            <td>&nbsp;</td>
            <td class="label">Income Per Household</td>
            <td><asp:Label ID="lblAverageIncome" runat="server" /></td>
          </tr>                    
          <tr>
            <td class="label">Average Home Value</td>
            <td><asp:Label ID="lblAverageHouseValue" runat="server" /></td>
            <td>&nbsp;</td>
            <td class="label">People Per Househould</td>
            <td><asp:Label ID="lblPeoplePerHousehould" runat="server" /></td>
          </tr>                              
        </tbody>
      </table>
      <div>&nbsp;</div>
      <div class="inputformsectionheader">Closest Partner Agents</div>
      <asp:DataGrid ID="dgvClosestAgents" runat="server" style="width: 100%; background-color: White;" AutoGenerateColumns="false">
        <HeaderStyle CssClass="gridheader" />
        <AlternatingItemStyle CssClass="altrow" />
        <Columns>
          <asp:BoundColumn HeaderText="ID" DataField="ResumeID" Visible="false" />
          <asp:TemplateColumn HeaderText="Partner ID">
            <ItemTemplate>
              <a href="partner.aspx?id=<%#DataBinder.Eval(Container.DataItem, "PartnerID")%>"><%#DataBinder.Eval(Container.DataItem, "ResumeID")%></a>
            </ItemTemplate>
          </asp:TemplateColumn>          
          <asp:TemplateColumn HeaderText="Agent ID">
            <ItemTemplate>
              <a href="editpartneragent.aspx?id=<%#DataBinder.Eval(Container.DataItem, "PartnerAgentID")%>&returnurl=findzipcode.aspx%3fzip=<%# currentzip %>"><%#DataBinder.Eval(Container.DataItem, "Login")%></a>
            </ItemTemplate>
          </asp:TemplateColumn>
          <asp:Templatecolumn HeaderText="Name">
            <ItemTemplate>
              <%#DataBinder.Eval(Container.DataItem, "FirstName")%>&nbsp;<%#DataBinder.Eval(Container.DataItem, "LastName")%>
            </ItemTemplate>
          </asp:Templatecolumn>                
          <asp:BoundColumn HeaderText="City" DataField="City" />
          <asp:BoundColumn HeaderText="State" DataField="Abbreviation" />
          <asp:TemplateColumn HeaderText="Distance">
            <ItemTemplate>
              <a target="_blank" href="<%#ZipToZip(DataBinder.Eval(Container.DataItem,"ZipCode")) %>"><%#DataBinder.Eval(Container.DataItem, "Distance")%></a>
            </ItemTemplate>
          </asp:TemplateColumn>
        </Columns>
      </asp:DataGrid>
      <div>&nbsp;</div>
      <div class="inputformsectionheader">Closest Resumes</div>
      <asp:DataGrid ID="dgvClosestResumes" runat="server" style="width: 100%; background-color: White;" AutoGenerateColumns="false">
        <HeaderStyle CssClass="gridheader" />
        <AlternatingItemStyle CssClass="altrow" />
        <Columns>
          <asp:BoundColumn HeaderText="ID" DataField="ResumeID" Visible="false" />
          <asp:TemplateColumn HeaderText="Resume ID">
            <ItemTemplate>
              <a href="resume.aspx?resumeid=<%#DataBinder.Eval(Container.DataItem, "ResumeID")%>"><%#DataBinder.Eval(Container.DataItem, "ResumeID")%></a>
            </ItemTemplate>
          </asp:TemplateColumn>
          <asp:Templatecolumn HeaderText="Name">
            <ItemTemplate>
              <%#DataBinder.Eval(Container.DataItem, "FirstName")%>&nbsp;<%#DataBinder.Eval(Container.DataItem, "LastName")%>
            </ItemTemplate>
          </asp:Templatecolumn>                
          <asp:BoundColumn HeaderText="Folder" DataField="FolderName" />
          <asp:BoundColumn HeaderText="City" DataField="City" />
          <asp:BoundColumn HeaderText="State" DataField="Abbreviation" />
          <asp:TemplateColumn HeaderText="Distance">
            <ItemTemplate>
              <a target="_blank" href="<%#ZipToZip(DataBinder.Eval(Container.DataItem,"ZipCode")) %>"><%#DataBinder.Eval(Container.DataItem, "Distance")%></a>
            </ItemTemplate>
          </asp:TemplateColumn>
        </Columns>
      </asp:DataGrid>
    </div>
  </form>
</asp:Content>