<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">

  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      lblReturnUrl.Text = Request.QueryString("returnurl")
      Try
        _ID = CType(Request.QueryString("id"), Long)        
      Catch ex As Exception
        _ID = 0
      End Try      
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Partner Metrics"
      If _ID > 0 Then
        LoadMetrics()
        Dim ptr As New BridgesInterface.PartnerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ptr.Load(_ID)
        Master.PageHeaderText &= " for " & ptr.CompanyName & " (" & ptr.ResumeID & ")"
      End If      
      Master.PageTitleText = Master.PageHeaderText      
    End If
  End Sub
  
  Private Sub LoadMetrics()
    Dim ptr As New BridgesInterface.PartnerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ptr.Load(_ID)
    lblDateCreated.Text = ptr.DateCreated
    If ptr.Active Then
      lblStatus.Text = "Active"
    Else
      lblStatus.Text = "Inactive"
    End If
    Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    rsm.Load(ptr.ResumeID)
    imgICL.ImageUrl = DetermineAppropriateBar(rsm.ConfidenceLevel)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListAverageSkillSetForPartner", "@PartnerID", _ID, dgvAverageSkillSet)
    ldr.LoadSingleLongParameterDataGrid("spListPartnerCertifications", "@PartnerID", _ID, dgvCertifications)
    ldr.LoadSingleLongParameterDataGrid("spListActivePartnerShippingLocations", "@PartnerID", _ID, dgvLocations)
  End Sub

  Private Function DetermineAppropriateBar(ByVal lngLevel As Long) As String
    Dim strReturn As String = ""
    If lngLevel > 0 Then
      strReturn = "/graphics/bar" & CType(Math.Round((lngLevel / 5) * 100, 0), Long).ToString() & ".png"
    Else
      strReturn = "/graphics/bar0.png"
    End If
    Return strReturn
  End Function
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmMetrics" runat="server">
    <table style="margin-left: auto; margin-right: auto;" class="inputform">
      <tbody>
        <tr>
          <td class="inputformsectionheader">Averages and Metrics</td>
        </tr>
        <tr>
          <td>
            <table>
              <tbody>
                <tr>
                  <td>
                    <table>
                      <tbody>
                        <tr>
                          <td class="label">ICL*</td>
                          <td style="vertical-align: middle;"><asp:Image ID="imgICL" runat="server" /></td>
                        </tr>
                        <tr>
                          <td style="text-align: right;" class="smalltext" colspan="2">
                            *ICL = "Initial Confidence Level"
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </td>
                  <td>
                    <table>
                      <tbody>
                        <tr>
                          <td class="label">Partner Since</td>
                          <td><asp:Label ID="lblDateCreated" runat="server" /></td>
                        </tr>
                        <tr>
                          <td class="label">Status</td>
                          <td><asp:Label ID="lblStatus" runat="server" /></td>
                        </tr>
                      </tbody>
                    </table>
                  </td>
                </tr>
              </tbody>
            </table>
            <table>
              <tr>
                <td>
                  <div class="inputformsectionheader">Skill Sets</div>
                  <asp:DataGrid style="background-color: White;" ID="dgvAverageSkillSet" runat="server" AutoGenerateColumns="false">
                    <HeaderStyle CssClass="gridheader" />
                    <AlternatingItemStyle CssClass="altrow" />
                    <Columns>
                      <asp:BoundColumn HeaderText="ID" DataField="SkillSetQuestionID" Visible="false" />
                      <asp:BoundColumn HeaderText="Skill" DataField="Question" />
                      <asp:TemplateColumn HeaderText="Skill Level">
                        <ItemTemplate>
                          <img src="<%# DetermineAppropriateBar(Databinder.Eval(Container.DataItem,"SkillLevel")) %>" alt="Level <%# Databinder.Eval(Container.DataItem,"SkillLevel") %>" />            
                        </ItemTemplate>
                      </asp:TemplateColumn>
                      <asp:BoundColumn HeaderText="YOE*" DataField="YearsExperience" />
                    </Columns>    
                  </asp:DataGrid>
                  <div class="smalltext" style="text-align: right;">*YOE = Years Of Experience</div>
                </td>
                <td>
                  <div class="inputformsectionheader">Certifications</div>
                  <asp:DataGrid ID="dgvCertifications" style="background-color: White;" runat="server" AutoGenerateColumns="false">
                    <AlternatingItemStyle CssClass="altrow" />
                    <HeaderStyle CssClass="gridheader" />
                    <Columns>
                      <asp:BoundColumn HeaderText="Agency" DataField="AgencyName" />
                      <asp:BoundColumn HeaderText="Certification" DataField="CertificationName" />
                    </Columns>
                  </asp:DataGrid>
                </td>
                <td>
                  <div class="inputformsectionheader">Shipping&nbsp;Locations</div>
                  <asp:DataGrid ID="dgvLocations" runat="server" style="width: 100%; background-color: White;" AutoGenerateColumns="false">
                    <AlternatingItemStyle CssClass="altrow" />
                    <HeaderStyle CssClass="gridheader" />
                    <Columns>
                      <asp:BoundColumn DataField="City" HeaderText="City" />
                      <asp:BoundColumn DataField="Abbreviation" HeaderText="State" />
                      <asp:TemplateColumn HeaderText="Zip Code">
                        <ItemTemplate>
                          <a target="_blank" href="findzipcode.aspx?zip=<%# DataBinder.Eval(Container.DataItem,"ZipCode") %>"><%# DataBinder.Eval(Container.DataItem,"ZipCode") %></a>
                        </ItemTemplate>
                      </asp:TemplateColumn>
                    </Columns>
                  </asp:DataGrid>
                </td>
              </tr>
            </table>          
          </td>
        </tr>
      </tbody>
    </table>
    <asp:Label ID="lblReturnUrl" runat="server" />
  </form>
</asp:Content>