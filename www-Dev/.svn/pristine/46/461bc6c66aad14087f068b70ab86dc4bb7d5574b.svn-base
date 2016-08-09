<%@ Page Language="vb" masterpagefile="~/masters/partner.master" %>
<%@ MasterType VirtualPath="~/masters/partner.master" %>
<script runat="server">

  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Partner Information"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Partner Information"
      master.ActiveMenu = "O"
      LoadInformation()
      LoadContractInformation()
    End If
  End Sub
  
  Private Sub LoadInformation()
    Dim ptr As New BridgesInterface.PartnerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ptr.Load(Master.PartnerID)
    lblCompany.Text = ptr.CompanyName
    lblWebsite.Text = ptr.WebSite
    lblEmail.Text = ptr.Email
    lblDateCreated.Text = ptr.DateCreated
    If ptr.Active Then
      lblStatus.Text = "Active"
    Else
      lblStatus.Text = "Not Active"
    End If
    Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    wbl.Load(Master.WebLoginID)
    'lblLogin.Text = wbl.Login
    Dim pta As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    pta.Load(Master.PartnerAgentID)
    'lblUserName.Text = pta.NameTag
    If pta.AdminAgent Then
      tdAdmin.Visible = True
      LoadAgents()
      LoadPhoneNumbers()
      LoadAddresses()
      divRates.Visible = True
      dgvRates.Visible = True
      LoadReferenceRates()
    Else
      tdAdmin.Visible = False
    End If
    LoadCertifications()
    LoadSkillSets()
  End Sub
  
  Private Sub LoadReferenceRates()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    'ldr.LoadSingleLongParameterDataGrid("spListPartnerReferenceRates", "@PartnerID", Master.PartnerID, dgvRates)
  End Sub
  
  Private Sub LoadSkillSets()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
    'ldr.LoadSingleLongParameterDataGrid("spListPartnerSkillSurveyQuestions", "@PartnerAgentID", Master.PartnerAgentID, dgvAnswered)
  End Sub
  
  Private Sub LoadCertifications()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    'ldr.LoadSingleLongParameterDataGrid("spListPartnerAgentCertifications", "@PartnerAgentID", Master.PartnerAgentID, dgvCertifications)
  End Sub
  
  Private Sub LoadAgents()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListPartnerAgents", "@PartnerID", Master.PartnerID, dgvAgents)
  End Sub
  
  Private Sub LoadPhoneNumbers()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListPartnerPhoneNumbers", "@PartnerID", Master.PartnerID, Me.dgvPhoneNumbers)
  End Sub
  
  Private Sub LoadAddresses()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListPartnerAddresses", "@PartnerID", Master.PartnerID, Me.dgvAddresses)
  End Sub
  
  Private Sub btnEditRate_Click(ByVal S As Object, ByVal E As System.Web.UI.WebControls.DataGridCommandEventArgs)
    
  End Sub
  
  Private Sub LoadContractInformation()
    Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    par.Load(Master.PartnerAgentID)
    Dim ptr As New BridgesInterface.PartnerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ptr.Load(Master.PartnerID)
    ulAdminDocuments.Visible = par.AdminAgent
    Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    rsm.Load(ptr.ResumeID)
    Dim pdr As New BridgesInterface.PartnerDocumentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))    
    lnkContract.HRef = "viewfile.aspx?id=" & rsm.BlankContractFileID
    lnkContractSig.HRef = "viewfile.aspx?id=" & rsm.SignedContractFileID
    lnkAddAddress.HRef = "addaddress.aspx?id=" & master.partnerID & "&returnurl=settings.aspx%3fid=" & master.partnerID & "&mode=partner"
    lblSignatureDate.Text = rsm.ContractSignatureDate
    lnkNDA.HRef = "viewfile.aspx?id=" & rsm.BlankNDAFileID
    lnkNDASig.HRef = "viewfile.aspx?id=" & rsm.SignedNDAFileID
    lblNDASignatureDate.Text = rsm.NDASignatureDate.ToString
    lnkWaiver.HRef = "viewfile.aspx?id=" & rsm.BlankWaiverFileID
    lnkWaiverSig.HRef = "viewfile.aspx?id=" & rsm.SignedWaiverFileID
    lblWaiverSignatureDate.Text = rsm.WaiverSignatureDate.ToString
    If par.SignatureFileID > 0 Then
      lnkEsig.HRef = "viewfile.aspx?id=" & par.SignatureFileID
    End If
    pdr.Load(Master.PartnerID, 1)
    If pdr.PartnerDocumentID > 0 Then
      lnkW9.HRef = "viewfile.aspx?id=" & pdr.FileID
    End If
    pdr = New BridgesInterface.PartnerDocumentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    pdr.Load(Master.PartnerID, 2)
    If pdr.PartnerDocumentID > 0 Then
      lnkInsurance.HRef = "viewfile.aspx?id=" & pdr.FileID
    End If
  End Sub
  Private Function MapIt(ByVal strAddress As String, ByVal strZipCode As String) As String
    Dim strReturn As String = ""
    Dim ggl As New cvCommon.Googler
    strReturn = ggl.MapAddress(strAddress, strZipCode)
    Return strReturn
  End Function
  '<a id="lnkEditPartner" href="editPartner.aspx" visible="false" runat="server">[Edit]</a>
  </script>

<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
<form id="frmSettings" runat="server">
    <div class="inputformsectionheader">Partner Information</div>
    <table style="width: 100%">
      <tbody>
        <tr>
          <td>
            <table>
              <tbody>
                <tr>
                  <td class="label">Partner Since</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblDateCreated" runat="server" /></td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td class="label">Company</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblCompany" runat="server" /></td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td class="label">Status</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblStatus" runat="server" /></td>
                  <td>&nbsp;</td>               
                </tr>
                <tr>
                  <td class="label">Email</td>
                  <td>&nbsp;</td>                  
                  <td><a id="lnkEmail" runat="server"><asp:Label ID="lblEmail" runat="server" /></a></td>
                  <td></td>
                </tr>
                <tr>
                  <td class="label">Website</td>
                  <td>&nbsp;</td>
                  <td colspan="5"><a target="_blank" id="lnkWebsite" runat="server"><asp:Label ID="lblWebsite" runat="server" /></a></td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                <td colspan ="4">
                <div class="inputformsectionheader">Company Documents</div>
                  <ul id="ulAdminDocuments" runat="server">
                     <li><a id="lnkContract" runat="server">Contract</a>&nbsp;<a id="lnkContractSig" runat="server">Signature</a>&nbsp;<asp:label ID="lblSignatureDate" runat="server" /></li>
                     <li><a id="lnkNDA" runat="server">Confidentiality Agreement</a>&nbsp;<a id="lnkNDASig" runat="server">Signature</a>&nbsp;<asp:Label ID="lblNDASignatureDate" runat="server" /></li>
                     <li><a id="lnkWaiver" runat="server">Workmans Comp Waiver</a>&nbsp;<a id="lnkWaiverSig" runat="server">Signature</a>&nbsp;<asp:Label ID="lblWaiverSignatureDate" runat="server" /></li>
                     <li><a id="lnkEsig" runat="server">E-Signature</a></li>
                     <li><a id="lnkW9" runat="server">W9</a>&nbsp;<a href="upload.aspx?mode=w9&returnurl=documents.aspx">Upload New</a>&nbsp;(<a target=_blank href="/files/fw9.pdf">Blank W9)</a></li>
                     <li><a id="lnkInsurance" runat="server">Proof of Insurance</a>&nbsp;<a href="upload.aspx?mode=li&returnurl=documents.aspx">Upload New</a></li>
                     <li><a id="lnkEFT" runat="server">Electronic Funds Transfer Authorization Form</a>&nbsp;<a target=_blank href="/files/BSA_EFT.pdf">Blank EFT Form</a></li>
                     <li><a id="lnkBackground" runat="server">Authorization Release for Background Check Form</a>&nbsp;<a target=_blank href="/images/authorization_releaseform.pdf">Blank EFT Form</a></li>
                  </ul>
                </td>
                </tr>
                <tr>
                <td colspan ="4" class="important">
                <div >*** IMPORTANT: To Change Billing/Business Address you will need to upload a new W9 Form with company name, new address, your EIN Number, signature and date. The W9 Form  is used when sending your 1099 in the end of the year. If you have the incorrect W9 in your files, you might not receive your 1099 due to incorrect address.</div>
                </td>
                </tr>
              </tbody>
            </table>
            <div>&nbsp;</div>
            <div visible="false" id="divRates" class="inputformsectionheader" runat="server"></div>
            <asp:DataGrid Visible="false" ID="dgvRates" style="width: 100%" OnItemCommand="btnEditRate_Click" runat="server" AutoGenerateColumns="false">
              <HeaderStyle CssClass="gridheader" />
              <AlternatingItemStyle CssClass="altrow" />   
              <Columns>
                <asp:BoundColumn
                  DataField="PartnerReferenceRateID"
                  HeaderText="ID"
                  visible="False"
                />
                <asp:BoundColumn
                  DataField="Description"
                  HeaderText="Type"
                  ItemStyle-Wrap="false"
                  />
                <asp:BoundColumn
                  DataField="Rate"
                  HeaderText="Rate"
                  DataFormatString="{0:C}"
                  />
                <asp:TemplateColumn>
                  <ItemTemplate>
                    <a href="editrate.aspx?id=<%# Databinder.eval(Container.DataItem,"PartnerReferenceRateID") %>">Edit</a>
                  </ItemTemplate>
                </asp:TemplateColumn>               
              </Columns>                
            </asp:DataGrid>            
            <div>&nbsp;</div>
            <div runat="server" id="divPrograms" visible="false" class="inputformsectionheader">Programs</div>
            <asp:DataGrid ID="dgvServiceTypes" AutoGenerateColumns="false" style="width: 100%" runat="server">
              <AlternatingItemStyle CssClass="altrow" />
              <HeaderStyle CssClass="gridheader" />
              <Columns>
                <asp:BoundColumn
                  HeaderText="ID"
                  DataField="ServiceTypeID"
                  visible="false"
                  />
                <asp:BoundColumn
                  HeaderText="Program"
                  DataField="ServiceType"
                  />
                <asp:TemplateColumn 
                  HeaderText="Active"
                  >             
                  <ItemTemplate>
                    <img alt="status" src="/graphics/<%# Databinder.eval(Container.DataItem, "Active") %>.png" />                 
                  </ItemTemplate>
                </asp:TemplateColumn>         
                <asp:BoundColumn
                  HeaderText="Date&nbsp;Created"
                  DataField="DateCreated"
                  />
              </Columns>      
            </asp:DataGrid>
          </td>          
          <td id="tdAdmin" runat="server" visible="false" style="padding-left: 16px; padding-right: 8px;">
            <div class="inputformsectionheader">Contacts / Agents</div>
            <asp:DataGrid style="width: 100%" ID="dgvAgents" AutoGenerateColumns="false" runat="server">
              <HeaderStyle cssclass="gridheader" />
              <AlternatingItemStyle cssclass="altrow" />  
              <Columns>
                <asp:BoundColumn
                  HeaderText="ID"
                  DataField="PartnerAgentID"
                  Visible="false"
                />
                <asp:TemplateColumn
                  HeaderText="Command"
                  >
                  <ItemTemplate>
                    <a href="editpartneragent.aspx?id=<%# DataBinder.Eval(Container.DataItem,"PartnerAgentID") %>">Open</a>
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:BoundColumn
                  HeaderText="Type"
                  DataField="AgentType"
                  />
                <asp:TemplateColumn
                  HeaderText="Name"
                  >
                  <Itemtemplate>
                    <%# DataBinder.Eval(Container.DataItem,"FirstName") %>&nbsp;<%# DataBinder.Eval(Container.DataItem,"MiddleName") %>&nbsp;<%#DataBinder.Eval(Container.DataItem, "LastName")%>                    
                  </Itemtemplate>                  
                </asp:TemplateColumn>
                <asp:TemplateColumn 
                  HeaderText="Admin"
                  >             
                  <ItemTemplate>
                    <img alt="Admin Agent" src="/graphics/<%# Databinder.eval(Container.DataItem, "AdminAgent") %>.png" />                 
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn 
                  HeaderText="Active"
                  >             
                  <ItemTemplate>
                    <img alt="Active" src="/graphics/<%# Databinder.eval(Container.DataItem, "Active") %>.png" />                 
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:BoundColumn
                  DataField="DateCreated"
                  HeaderText="Date&nbsp;Created"
                  />                
              </Columns>
            </asp:DataGrid>            
            <div style="text-align:right;"><a href="addpartneragent.aspx">[Add Agent]</a></div>
            <div class="inputformsectionheader">Phone Numbers</div>
            <asp:DataGrid style="width:100%" ID="dgvPhoneNumbers" runat="server" AutoGenerateColumns="false">
              <HeaderStyle CssClass="gridheader" />
              <AlternatingItemStyle CssClass="altrow" />   
              <Columns>
                <asp:BoundColumn
                  DataField="PhoneType"
                  HeaderText="Type"
                  ItemStyle-Wrap="false"
                  />                    
                <asp:TemplateColumn
                  HeaderText="Phone Number"
                  ItemStyle-Wrap="false"
                  >
                  <ItemTemplate>
                    <%# Databinder.eval(Container.DataItem, "CountryCode") %> (<%# Databinder.eval(Container.DataItem, "AreaCode") %>) <%# Databinder.eval(Container.DataItem, "Exchange") %>-<%# Databinder.eval(Container.DataItem, "LineNumber") %>
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:BoundColumn
                  DataField="Extension"
                  headertext="Extension"
                  />
                <asp:BoundColumn
                  DataField="Pin"
                  headertext="Pin"
                  />
                <asp:TemplateColumn 
                  HeaderText="Active"
                  >             
                  <ItemTemplate>
                    <img alt="status" src="/graphics/<%# Databinder.eval(Container.DataItem, "Active") %>.png" />                 
                  </ItemTemplate>
                </asp:TemplateColumn>                              
                <asp:TemplateColumn
                  HeaderText="Command"
                  >
                  <Itemtemplate>
                    <a href="editphone.aspx?returnurl=settings.aspx&id=<%# DataBinder.Eval(Container.DataItem,"PartnerPhoneNumberID") %>&mode=Partner">Edit</a>
                  </Itemtemplate>
                </asp:TemplateColumn>                            
              </Columns>                
            </asp:DataGrid>
            <div style="text-align:right"><a href="addphone.aspx?mode=Partner&returnurl=settings.aspx">[Add Phone Number]</a></div>
            <div class="inputformsectionheader">Addresses</div>
            <asp:DataGrid style="width: 100%" AutoGenerateColumns="false" ID="dgvAddresses" runat="server">
              <HeaderStyle CssClass="gridheader" />
              <AlternatingItemStyle CssClass="altrow" />   
              <Columns>
                <asp:BoundColumn
                  DataField="AddressType"
                  HeaderText="Type"
                  ItemStyle-Wrap="false"
                  />
                <asp:TemplateColumn
                  HeaderText="Address"
                  >
                  <ItemTemplate>
                    <a target="_blank" href="<%# MapIt(DataBinder.Eval(Container.DataItem,"Street"),DataBinder.Eval(Container.DataItem,"ZipCode")) %>"><%# Databinder.eval(Container.DataItem, "Street") %> <%#DataBinder.Eval(Container.DataItem, "Extended")%></a>
                  </ItemTemplate>
                </asp:TemplateColumn>                  
                <asp:BoundColumn
                  DataField="City"
                  HeaderText="City"
                  />
                <asp:BoundColumn
                  DataField="StateAbbreviation"
                  HeaderText="State"
                  />
                <asp:TemplateColumn
                  HeaderText="Zip"
                  >
                  <ItemTemplate>
                    <a href="findzipcode.aspx?zip=<%# Databinder.eval(Container.DataItem,"ZipCode") %>" target="_blank"><%# Databinder.eval(Container.DataItem,"ZipCode") %></a>
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn
                  HeaderText="Location"
                  >
                  <ItemTemplate>
                    <a href="../Maps/<%# Databinder.eval(Container.DataItem,"LocationName") %>.pdf" target="_blank"><%# Databinder.eval(Container.DataItem,"LocationName") %></a>
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn 
                  HeaderText="Active"
                  >             
                  <ItemTemplate>
                    <img alt="status" src="/graphics/<%# Databinder.eval(Container.DataItem, "Active") %>.png" />                 
                  </ItemTemplate>
                </asp:TemplateColumn>                              
                <asp:TemplateColumn
                  HeaderText="Command"
                  >
                  <Itemtemplate>
                    <a href="editaddress.aspx?mode=partner&returnurl=partner.aspx%3fid=<%# DataBinder.Eval(Container.DataItem,"PartnerID") %>&id=<%# DataBinder.Eval(Container.DataItem,"PartnerAddressID") %>">Edit</a>
                  </Itemtemplate>
                </asp:TemplateColumn>                                                    
              </Columns>        
            </asp:DataGrid>
            <div style="text-align:right"><a id="lnkAddAddress" runat="server">[Add Address]</a></div>    
          </td>
        </tr>
      </tbody>
    </table>
    <div class="bandheader"></div>
    <table>
      <tbody>
        <tr>
          <td>
            <table>
              <tbody>
                <tr>
                  <td class="label"></td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblLogin" runat="server" /></td>          
                  <td>&nbsp;</td>
                  <td><a href="changepassword.aspx"></a></td>
                </tr>
              </tbody>
            </table>
            <table>
              <tbody>
                <tr>
                  <td class="label"></td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblUserName" runat="server" /></td>
                </tr>        
              </tbody>      
            </table>
          </td>
          <td>&nbsp;</td>
          <td>
            <div class="bandheader"></div>
            <asp:DataGrid ID="dgvCertifications" style="width: 100%" AutoGenerateColumns="false" runat="server">
              <AlternatingItemStyle CssClass="altrow" />
              <HeaderStyle CssClass="gridheader" />
              <Columns>
                <asp:BoundColumn DataField="partneragentcertificationid" HeaderText="ID" Visible="false" />
                <asp:BoundColumn DataField="agencyname" HeaderText="Agency" />
                <asp:BoundColumn DataField="certificationname" HeaderText="Certification" />
                <asp:BoundColumn DataField="certificationdate" HeaderText="Date Certified" />
                <asp:BoundColumn DataField="certificationnumber" HeaderText="Certification Number" />                
                <asp:BoundColumn DataField="certificationexpires" HeaderText="Expires" />
              </Columns>
            </asp:DataGrid>
            <div style="text-align: right;"><a href="certificationsurvey.aspx?returnurl=settings.aspx"></a></div>
          </td>
        </tr>
        <tr>
          <td colspan="3">
            <div class="bandheader"></div>
            <asp:DataGrid ID="dgvAnswered" style="width: 100%" runat="server" AutoGenerateColumns="false">
              <AlternatingItemStyle CssClass="altrow" />
              <HeaderStyle CssClass="gridheader" />
              <Columns>
                <asp:BoundColumn HeaderText="ID" DataField="SkillSetQuestionAssignmentID" Visible="false" />
                <asp:BoundColumn HeaderText="Skill Set" DataField="Question" />
                <asp:BoundColumn HeaderText="Skill Level" DataField="SkillLevel" />
                <asp:BoundColumn HeaderText="Years&nbsp;Experience" DataField="YearsExperience" />
              </Columns>
            </asp:DataGrid>          
            <div style="text-align: right;"><a href="skillsetsurvey.aspx"></a></div>
          </td>
        </tr>
      </tbody>
    </table>
</form>
</asp:Content>