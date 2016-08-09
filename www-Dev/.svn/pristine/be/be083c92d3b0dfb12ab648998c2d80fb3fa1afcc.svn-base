<%@ Page Language="VB" masterpagefile="~/masters/cust.master"%>
<%@ MasterType VirtualPath="~/masters/cust.master" %>
<%@ Register Src="~/controls/ticket.ascx" TagName="Ticket" TagPrefix="cv" %>
<script language="VB" runat="server">
  Private _Zip as string
  Private Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Dim lgn As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim strMode As String = ""
      If CType(Request.QueryString("mode"), String) <> "" Then
        strMode = Request.QueryString("mode")
      End If
      If CType(Request.QueryString("zip"), String) <> "" Then
        _Zip = Request.QueryString("zip")
        
      End If
      Dim strHeaderText As String = "Coverage"
      lgn.Load(CType(User.Identity.Name, Long))
      If lgn.WebLoginID > 0 Then
        Master.WebLoginID = lgn.WebLoginID
        'Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("CompanyName") & " Client Access [Coverage]"
        'Master.PageHeaderText = strHeaderText
      Else
        Response.Redirect("/login.aspx", True)
      End If
    Else
      Response.Redirect("/login.aspx", True)
    End If
    DisplayZip(_Zip)
  End Sub
  
  ' This needs to be replaced once we're up and running, we have a temporary fix at the moment
  Private Sub HaveCoverage(strZip as string)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("spGetResumesInRadiusFromZip")
    cmd.Parameters.Add("@Radius", Data.SqlDbType.Int).Value = 50
        cmd.Parameters.Add("@ZipCode", Data.SqlDbType.VarChar, strZip).Value = strZip
        cmd.Parameters.Add("@CountryID", Data.SqlDbType.Int).Value = 1
    cmd.CommandType = Data.CommandType.StoredProcedure
    cnn.Open()
    cmd.Connection = cnn
    Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
    If dtr.HasRows Then
      lblNotCovered.Visible = False
      lblCovered.Visible = True
      dgvPartners.DataSource = dtr
      dgvPartners.DataBind()
    Else
      dgvPartners.DataSource = Nothing
      dgvPartners.DataBind()
      lblNotCovered.Visible = True
      lblCovered.Visible = False
    End If
    cnn.Close()
  End Sub
  
  Private Sub DisplayZip(ByVal strZipCode As String)
    Dim zip As New BridgesInterface.ZipCodeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim stt As New BridgesInterface.StateRecord(zip.ConnectionString)
    Dim cnt As New BridgesInterface.CountryRecord(zip.ConnectionString)
    Dim ctp As New BridgesInterface.CityTypeRecord(zip.ConnectionString)
    zip.Load(strZipCode.Trim)
    If zip.ZipCodeID > 0 Then
      stt.Load(zip.StateID)
      cnt.Load(stt.CountryID)
      ctp.Load(zip.CityTypeID)
      divResults.Visible = True
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
      lblAverageIncome.Text = zip.IncomePerHouseHold.ToString("C2")
      lblAverageHouseValue.Text = zip.AverageHouseValue.ToString("C2")
      lblPeoplePerHousehould.Text = zip.PersonsPerHouseHold
      HaveCoverage(Zip.zipcode)
      'trErrors.Visible = False      
    Else
      'trErrors.Visible = True
      'divErrors.InnerHtml = "<ul><li>Zip Code Not Found</li></ul>"
      divResults.Visible = False
    End If
  End Sub
  
  'Private Sub btnCheck_Click(ByVal S As Object, ByVal E As EventArgs)
  '  If txtZipCode.Text.Trim.Length > 0 Then
  '    trErrors.Visible = False
  '    DisplayZip(txtZipCode.Text)
  '    divForm.Visible = False
  '  Else
  '    divErrors.InnerHtml = "<ul><li>Zip Code is Required</li></ul>"
  '    trErrors.Visible = True
  '  End If
  'End Sub
  
</script>


<asp:Content ContentPlaceHolderID="bodycontent" runat="server">
  <form id="frmCoverage" runat="server">    
    <div id="divResults" visible="false" runat="server">
      <table style="margin-left: auto; margin-right: auto" class="inputform">
        <tbody>
          <tr>
            <td colspan="5" class="inputformsectionheader">Coverate Search Results</td>
          </tr>
          <tr>
            <td class="label">Zip Code</td>
            <td><asp:Label ID="lblZipCode" runat="server" /></td>
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
          <tr>
            <td colspan="5">
              <div style="text-align:center;"><asp:Label style="font-weight: bold; color: green; text-align:center; font-size:large;" ID="lblCovered" runat="server">Covered</asp:Label><asp:Label style="font-weight: bold; color: Red;" ID="lblNotCovered" runat="server">Not Covered (Currently Recruiting)</asp:Label></div>
              <div class="label">Partners Covering This Area</div>
              <div style="background-color: White;">
                <asp:DataGrid style="width: 100%;" ID="dgvPartners" runat="server" AutoGenerateColumns="false">
                  <HeaderStyle CssClass="gridheader" />
                  <AlternatingItemStyle CssClass="altrow" />
                  <Columns>
                    <asp:BoundColumn headertext="Partner ID" DataField="resumeid" />
                    <asp:BoundColumn HeaderText="Distance" DataField="distance" />
                  </Columns>
                </asp:DataGrid>
              </div>
            </td>
          </tr>                              
        </tbody>
      </table>
    </div>        
  </form>
</asp:Content>