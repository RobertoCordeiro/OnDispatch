<%@ Page Language="vb" masterpagefile="~/masters/partner.master" %>
<%@ MasterType VirtualPath="~/masters/partner.master" %>
<script runat="server">
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Zip Code Information"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Zip Code Information"
    End If
    Dim strZipCode As String = Request.QueryString("zip")
    If Not IsNothing(strZipCode) Then
      DisplayZip(strZipCode)
    End If
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
    Else
      divNotFound.Visible = True
      divResults.Visible = False      
    End If
  End Sub

  </script>

<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmLookup" runat="server">
    <div style="margin-top: 32px;" id="divNotFound" visible="false" runat="server">Zip Code Not Found, <a href="findzipcode.aspx">Retry</a>?</div>
    <div id="divResults" visible="false" runat="server">
    <div>&nbsp;</div>
      <table style="margin-left: auto; margin-right: auto" class="inputform">
        <tbody>
          <tr>
            <td colspan="5" class="inputformsectionheader">Zip Code Information</td>
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
        </tbody>
      </table>      
    </div>
  </form>
</asp:Content>