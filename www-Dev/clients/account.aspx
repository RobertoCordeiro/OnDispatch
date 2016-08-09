<%@ Page Language="VB" masterpagefile="~/masters/customer.master"%>
<%@ MasterType VirtualPath="~/masters/customer.master" %>
<script language="VB" runat="server">
    
  Private Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Dim lgn As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      lgn.Load(CType(User.Identity.Name, Long))
      Master.ActiveMenu = "D"
      If lgn.WebLoginID > 0 Then
        If lgn.AccessCoding.Contains("C") Then
          Master.WebLoginID = lgn.WebLoginID
          Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("CompanyName") & " Client Access [My Account]"
          Master.PageHeaderText = "My Account"
          Secure()
          LoadAccountPage()
        Else
          Response.Redirect("/login.aspx", True)
        End If
      Else
        Response.Redirect("/login.aspx", True)
      End If
    Else      
      Response.Redirect("/login.aspx", True)
    End If
  End Sub
  
  Private Sub LoadCustomerAgents()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListCustomerAgents", "@CustomerID", Master.CustomerID, dgvAgents)
  End Sub
  
  Private Sub LoadCustomerPhoneNumbers()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListPhoneNumbersForCustomer", "@CustomerID", Master.CustomerID, dgvPhoneNumbers)
  End Sub
  
  Private Sub LoadAddresses()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListAddressesForCustomer", "@CustomerID", Master.CustomerID, dgvAddresses)
  End Sub
  
  Private Sub LoadServiceTypes()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListServiceTypes", "@CustomerID", Master.CustomerID, dgvServiceTypes)
  End Sub
  
  Private Sub LoadAccountPage()
    Dim car As New BridgesInterface.CustomerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    car.Load(Master.CustomerAgentID)
    Dim cst As New BridgesInterface.CustomerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    cst.Load(Master.CustomerID)
    Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    wbl.Load(Master.WebLoginID)
    lblLogin.Text = wbl.Login
    lblUserName.Text = car.FirstName & " " & car.MiddleName & " " & car.LastName
    lblCompany.Text = cst.Company
    lblName.Text = cst.Title & " " & cst.FirstName & " " & cst.MiddleName & " " & cst.LastName & " " & cst.Suffix
    lnkWebsite.HRef = cst.WebSite
    lblWebsite.Text = cst.WebSite
    lnkEmail.HRef = "mailto:" & cst.Email
    lblEmail.Text = cst.Email
    lblDateCreated.Text = cst.DateCreated.ToString
    lblRef1Label.Text = cst.Ref1Label
    lblRef2Label.Text = cst.Ref2Label
    lblRef3Label.Text = cst.Ref3Label
    lblRef4Label.Text = cst.Ref4Label
    lblTaxExempt.Text = cst.TaxExempt.ToString
    If tdAdmin.Visible Then
      LoadCustomerAgents()
      LoadCustomerPhoneNumbers()
      LoadServiceTypes()
      LoadAddresses()
      lnkEditCustomer.Visible = True
      divPrograms.Visible = True
      dgvServiceTypes.Visible = True
    Else
      divPrograms.Visible = False
      dgvServiceTypes.Visible = False
      lnkEditCustomer.Visible = False
    End If
    If cst.Active Then
      lblStatus.Text = "Active"
    Else
      lblStatus.Text = "Inactive"
    End If
  End Sub
  
  Private Sub Secure()
    Dim cag As New BridgesInterface.CustomerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    cag.Load(Master.CustomerAgentID)
    tdAdmin.Visible = cag.AdminAgent
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" runat="server">
  <form id="frmAccountInfo" runat="server">
    <div class="ticketformsectionheader">Company Information <a id="lnkEditCustomer" href="editcustomer.aspx" visible="false" runat="server">[Edit]</a></div>
    <table style="width: 100%">
      <tbody>
        <tr>
          <td>
            <table >
              <tbody>
                <tr>
                  <td class="label">Company</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblCompany" runat="server" /></td>
                  <td>&nbsp;</td>
                  <td class="label">Customer Since</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblDateCreated" runat="server" /></td>
                </tr>
                <tr>
                  <td class="label">Name</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblName" runat="server" /></td>
                  <td>&nbsp;</td>
                  <td class="label">Status</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblStatus" runat="server" /></td>                  
                </tr>
                <tr>
                  <td class="label">Email</td>
                  <td>&nbsp;</td>                  
                  <td><a id="lnkEmail" runat="server"><asp:Label ID="lblEmail" runat="server" /></a></td>
                  <td>&nbsp;</td>
                  <td class="label">Tax Exempt</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblTaxExempt" runat="server" /></td>                  
                </tr>
                <tr>
                  <td class="label">Website</td>
                  <td>&nbsp;</td>
                  <td colspan="5"><a target="_blank" id="lnkWebsite" runat="server"><asp:Label ID="lblWebsite" runat="server" /></a></td>
                </tr>
              </tbody>
            </table>
            
            <div>&nbsp;</div>
            <div class="ticketformsectionheader">Display Settings</div><br />
            <table>
              <tbody>
                <tr>
                  <td class="label">Ref 1 Label</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblRef1Label" runat="server" /></td>
                  <td>&nbsp;</td>
                  <td class="label">Ref 2 Label</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblRef2Label" runat="server" /></td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td class="label">Ref 3 Label</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblRef3Label" runat="server" /></td>
                  <td>&nbsp;</td>
                  <td class="label">Ref 4 Label</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblRef4Label" runat="server" /></td>
                  <td>&nbsp;</td>          
                </tr>
              </tbody>
            </table>
            
            <div>&nbsp;</div>
            <div runat="server" id="divPrograms" visible="false" class="ticketformsectionheader">Programs</div>
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
            <div class="ticketformsectionheader">Contacts / Agents</div>
            <asp:DataGrid style="width: 100%" ID="dgvAgents" AutoGenerateColumns="false" runat="server">
              <HeaderStyle cssclass="gridheader" />
              <AlternatingItemStyle cssclass="altrow" />  
              <Columns>
                <asp:BoundColumn
                  HeaderText="ID"
                  DataField="CustomerAgentID"
                  Visible="false"
                />
                <asp:TemplateColumn
                  HeaderText="Command"
                  >
                  <ItemTemplate>
                    <a href="editcustomeragent.aspx?id=<%# DataBinder.Eval(Container.DataItem,"CustomerAgentID") %>&returnurl=account.aspx">Open</a>
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
            <div style="text-align:right;"><a href="addcustomeragent.aspx">[Add Agent]</a></div>
            <div class="ticketformsectionheader">Phone Numbers</div>
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
                    <a href="editphone.aspx?returnurl=account.aspx&id=<%# DataBinder.Eval(Container.DataItem,"CustomerPhoneNumberID") %>&mode=customer">Edit</a>
                  </Itemtemplate>
                </asp:TemplateColumn>                            
              </Columns>                
            </asp:DataGrid>
            <div style="text-align:right"><a href="addphone.aspx?mode=customer&returnurl=account.aspx">[Add Phone Number]</a></div>
            <div class="ticketformsectionheader">Addresses</div>
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
                    <%# Databinder.eval(Container.DataItem, "Street") %> <%#DataBinder.Eval(Container.DataItem, "Extended")%> 
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
                    <a href="editaddress.aspx?id=<%# DataBinder.Eval(Container.DataItem,"CustomerAddressID") %>">Edit</a>
                  </Itemtemplate>
                </asp:TemplateColumn>                                                    
              </Columns>        
            </asp:DataGrid>
            <div style="text-align:right"><a href="addaddress.aspx?returnurl=account.aspx">[Add Address]</a></div>            
          </td>
        </tr>
      </tbody>
    </table>
    <div class="ticketformsectionheader">My Information</div>
    <table>
      <tbody>
        <tr>
          <td class="label">Login</td>
          <td>&nbsp;</td>
          <td><asp:Label ID="lblLogin" runat="server" /></td>          
          <td>&nbsp;</td>
          <td><a href="changepassword.aspx">[Change Password]</a></td>
        </tr>
      </tbody>
    </table>
    <table>
      <tbody>
        <tr>
          <td class="label">Name</td>
          <td>&nbsp;</td>
          <td><asp:Label ID="lblUserName" runat="server" /></td>
        </tr>        
      </tbody>      
    </table>
  </form>
</asp:Content>
