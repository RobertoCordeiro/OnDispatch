<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ Register Src="~/controls/FirstLastName.ascx" TagName="FirstLastName" TagPrefix="cv" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server"> 
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)    
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Edit Customer Agent"
      Master.PageTitleText = "Edit Customer Agent"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""customers.aspx"">Customers</a> &gt; Edit Agent"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    If _ID > 0 Then
      Dim cag As New BridgesInterface.CustomerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      cag.Load(_ID)
      lblReturnUrl.Text = "customer.aspx?id=" & cag.CustomerID
      If Not IsPostBack Then        
        LoadAgent(_ID)
      End If
    Else
      Response.Redirect("default.aspx", True)
    End If
  End Sub
  
  Private Sub LoadAgent(ByVal lngID As Long)
    LoadAgentTypes()
    Dim cag As New BridgesInterface.CustomerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
    cag.Load(lngID)
    lblReturnUrl.Text = "customer.aspx?id=" & cag.CustomerID
    chkAdminAgent.Checked = cag.AdminAgent
    cbxAgentTypes.SelectedValue = cag.AgentTypeID
    txtEmail.Text = cag.Email
    fnlAgent.FirstName = cag.FirstName
    fnlAgent.MI = cag.MiddleName
    fnlAgent.LastName = cag.LastName
    If cag.WebLoginID > 0 Then
      Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
      wbl.Load(cag.WebLoginID)
      txtLogin.Text = wbl.Login
      chkCreateLogin.Text = "Edit Login / Change Password"
    Else
      chkCreateLogin.Checked = False
    End If
    LoadAssignedPhoneNumbers()
    LoadUnassignedPhoneNumbers()
    LoadAssignedAddresses()
    LoadUnassignedAddresses()
    LoadUnassignedServiceTypes()
    LoadAssignedServiceTypes()
  End Sub

  Private Sub LoadUnassignedServiceTypes()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListUnassignedServiceTypesForCustomerAgent", "@CustomerAgentID", _ID, dgvUnassignedServiceTypes)
    lblUnassignedPrograms.Text = dgvUnassignedServiceTypes.Items.Count
  End Sub
  
  Private Sub LoadAssignedServiceTypes()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListCustomerAgentServiceTypes", "@CustomerAgentID", _ID, dgvAssignedServiceTypes)
    lblAssignedServiceTypeCount.Text = dgvAssignedServiceTypes.Items.Count
    Dim chk As System.Web.UI.WebControls.CheckBox
    For Each itm As DataGridItem In dgvAssignedServiceTypes.Items
      chk = itm.FindControl("chkAdminAccess")
      If Not IsNothing(chk) Then
        chk.Checked = CType(itm.Cells(2).Text, Boolean)
      End If
      chk = itm.FindControl("chkReadOnlyAccess")
      If Not IsNothing(chk) Then
        chk.Checked = CType(itm.Cells(1).Text, Boolean)
      End If
    Next
  End Sub
  
  Private Sub LoadAssignedPhoneNumbers()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListCustomerAgentPhoneNumbers", "@CustomerAgentID", _ID, dgvAssociatedPhoneNumbers)
    lblAssociatedCount.Text = dgvAssociatedPhoneNumbers.Items.Count
  End Sub

  Private Sub LoadAssignedAddresses()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListCustomerAgentAddresses", "@CustomerAgentID", _ID, Me.dgvAddresses)
    lblAssignedAddresssCount.Text = dgvAddresses.Items.Count
  End Sub

  Private Sub LoadUnassignedPhoneNumbers()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListUnassignedPhoneNumbersForCustomerAgent", "@CustomerAgentID", _ID, Me.dgvUnassignedPhoneNumbers)
    lblUnassociatedCount.Text = dgvUnassignedPhoneNumbers.Items.Count
  End Sub

  Private Sub LoadUnassignedAddresses()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListUnassignedAddressesForCustomerAgent", "@CustomerAgentID", _ID, Me.dgvUnassignedAddresses)
    lblUnAssignedAddresssCount.Text = dgvUnassignedAddresses.Items.Count
  End Sub
  
  Private Sub AssignServiceTypes()
    Dim itm As System.Web.UI.WebControls.DataGridItem
    Dim chkAdd As System.Web.UI.WebControls.CheckBox
    Dim chkAdmin As System.Web.UI.WebControls.CheckBox
    Dim chkReadOnly As System.Web.UI.WebControls.CheckBox
    Dim cas As New BridgesInterface.CustomerAgentServiceTypeRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
    For Each itm In dgvUnassignedServiceTypes.Items
      chkAdd = itm.FindControl("chkAddServiceType")
      If Not IsNothing(chkAdd) Then
        If chkAdd.Checked Then
          chkAdmin = itm.FindControl("chkAddAsAdmin")
          chkReadOnly = itm.FindControl("chkAddAsReadOnly")
          cas.Add(Master.UserID, _ID, CType(itm.Cells(0).Text, Long), chkAdmin.Checked, chkReadOnly.Checked)
        End If
      End If
    Next
  End Sub

  Private Sub AssignAddresses()
    Dim itm As System.Web.UI.WebControls.DataGridItem
    Dim chk As System.Web.UI.WebControls.CheckBox
    Dim aaa As New BridgesInterface.CustomerAgentAddressAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    For Each itm In dgvUnassignedAddresses.Items
      chk = itm.FindControl("chkSelectedAddress")      
      If chk.Checked Then    
        aaa.Add(_ID, CType(itm.Cells(0).Text, Long), Master.UserID)
      End If
    Next
  End Sub
  
  Private Sub AssignPhoneNumbers()
    Dim itm As System.Web.UI.WebControls.DataGridItem
    Dim chk As System.Web.UI.WebControls.CheckBox
    Dim apa As New BridgesInterface.CustomerAgentPhoneNumberAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    For Each itm In dgvUnassignedPhoneNumbers.Items
      chk = itm.FindControl("chkSelected")
      If Not IsNothing(chk) Then
        If chk.Checked Then
          apa.Add(Master.UserID, _ID, CType(itm.Cells(0).Text, Long))
        End If
      End If
    Next
  End Sub
  
  Private Sub SaveAccessRights()
    Dim strChangeLog As String = ""
    Dim itm As System.Web.UI.WebControls.DataGridItem
    Dim chkAdmin As System.Web.UI.WebControls.CheckBox
    Dim chkReadOnly As System.Web.UI.WebControls.CheckBox
    Dim cas As New BridgesInterface.CustomerAgentServiceTypeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    For Each itm In dgvAssignedServiceTypes.Items
      chkAdmin = itm.FindControl("chkAdminAccess")
      chkReadOnly = itm.FindControl("chkReadOnlyAccess")
      ' If (Not IsNothing(chkAdmin)) And (Not IsNothing(chkReadOnly)) Then
      cas.Load(CType(itm.Cells(0).Text, Long))
      cas.ReadOnlyAccess = chkReadOnly.Checked
      cas.AdminAccess = chkAdmin.Checked
      cas.Save(strChangeLog)
      'End If      
    Next
  End Sub
  
  Private Sub LoadAgentTypes()
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListAgentTypes")
    cmd.CommandType = Data.CommandType.StoredProcedure
    Dim itm As ListItem
    cnn.Open()
    cmd.Connection = cnn
    Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
    cbxAgentTypes.Items.Clear()
    While dtr.Read
      itm = New ListItem
      itm.Text = dtr("AgentType")
      itm.Value = dtr("AgentTypeID")
      cbxAgentTypes.Items.Add(itm)
    End While
    cnn.Close()
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If fnlAgent.FirstName.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>First Name is Required</li>"
    End If
    If fnlAgent.LastName.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Last Name is Required</li>"
    End If
    If chkCreateLogin.Checked Then
      wbl.Load(txtLogin.Text)
      Dim cag As New BridgesInterface.CustomerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      cag.Load(_ID)
      If cag.WebLoginID = 0 Then
        If wbl.WebLoginID > 0 Then
          blnReturn = False
          strErrors &= "<li>Login already exist, please use another</li>"
        End If
      End If
      If txtLogin.Text.Trim.Length = 0 Then
        blnReturn = False
        strErrors &= "<li>Login is Required</li>"
      End If
      If txtPassword.Text.Trim.Length = 0 Then
        blnReturn = False
        strErrors &= "<li>Password is Required</li>"
      End If
      If txtConfirmPassword.Text.Trim.Length = 0 Then
        blnReturn = False
        strErrors &= "<li>Confirmation Password is Required</li>"
      End If
      If txtPassword.Text.Trim.Length + txtConfirmPassword.Text.Trim.Length > 0 Then
        If txtPassword.Text.Trim <> txtConfirmPassword.Text.Trim Then
          blnReturn = False
          strErrors &= "<li>Passwords do not Match</li>"
        End If
      End If
    End If
    divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function

  Private Sub btnApply_Click(ByVal S As Object, ByVal E As EventArgs)
    Save()
    LoadAgent(_ID)
  End Sub
  
  Private Sub Save()
    Dim strTrash As String = ""
    Dim cag As New BridgesInterface.CustomerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
    cag.Load(_ID)
    cag.FirstName = fnlAgent.FirstName
    cag.LastName = fnlAgent.LastName
    cag.MiddleName = fnlAgent.MI
    cag.Email = txtEmail.Text
    cag.AdminAgent = chkAdminAgent.Checked
    cag.AgentTypeID = CType(cbxAgentTypes.SelectedValue, Long)
    cag.Email = txtEmail.Text
    If chkCreateLogin.Checked Then
      If cag.WebLoginID > 0 Then        
        wbl.Load(cag.WebLoginID)
        wbl.SetPassword(txtPassword.Text.Trim)
      Else
        wbl.Add(Master.UserID, txtLogin.Text.Trim, txtPassword.Text.Trim, "C")
        cag.WebLoginID = wbl.WebLoginID
      End If
    End If
    cag.Save(strTrash)
    AssignPhoneNumbers()
    AssignAddresses()
    AssignServiceTypes()
    SaveAccessRights()
  End Sub
  
  Private Sub btnSubmit_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      divErrors.Visible = False
      Save()
      Response.Redirect(lblReturnUrl.Text, True)
    Else
      divErrors.Visible = True
    End If
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div style="padding: 4px 4px 4px 4px">
      <table>
        <tbody>
          <tr>
            <td>
              <div class="errorzone" id="divErrors" runat="server" visible="false"/>
              <div class="label">Agent Type</div>
              <div><asp:DropDownList ID="cbxAgentTypes" style="width:99%" runat="server" /></div>
              <cv:FirstLastName ID="fnlAgent" runat="server" />
              <div class="label">Email Address</div>
              <asp:TextBox style="width: 99%" ID="txtEmail" runat="server" />
              <div style="text-align: right;"><asp:CheckBox ID="chkAdminAgent" runat="server" Text="Admin Agent" /></div>
              <div>&nbsp;</div>    
            </td>
            <td>&nbsp;</td>
            <td>
              <asp:CheckBox Text="Create Web Login" ID="chkCreateLogin" runat="server" />
              <div class="label">Login</div>
              <asp:TextBox style="width: 99%" ID="txtLogin" MaxLength="32" runat="server" />
              <div class="label">Password</div>
              <asp:TextBox style="width: 99%" ID="txtPassword" runat="server" />
              <div class="label">Confirm Password</div>
              <asp:TextBox style="width: 99%" ID="txtConfirmPassword" runat="server" />
            </td>
          </tr>
          <tr>
            <td>
              <div class="bandheader"><asp:label ID="lblAssociatedCount" runat="server" />&nbsp;Associated&nbsp;Phone&nbsp;Number(s)</div>
              <asp:DataGrid style="width: 100%" ID="dgvAssociatedPhoneNumbers" runat="server" AutoGenerateColumns="false">
                <AlternatingItemStyle CssClass="altrow" />
                <HeaderStyle CssClass="gridheader" />
                <Columns>
                  <asp:BoundColumn
                    HeaderText="ID"
                    DataField="AssignmentID"
                    visible="false"
                    />                    
                  <asp:TemplateColumn>
                    <ItemTemplate>
                      <a href="removecustomeragentphonenumber.aspx?id=<%# DataBinder.eval(Container.DataItem,"AssignmentID") %>&returnurl=editcustomeragent.aspx%3fid=<%# _ID %>">Remove</a>                      
                    </ItemTemplate>                    
                  </asp:TemplateColumn>
                  <asp:BoundColumn
                    HeaderText="Type"
                    DataField="PhoneType"
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
                </Columns>                
              </asp:DataGrid>
            </td>
            <td>&nbsp;</td>
            <td>
              <div class="bandheader"> <asp:label ID="lblUnassociatedCount" runat="server" />&nbsp;Un-Associated&nbsp;Phone&nbsp;Number(s)</div>
              <asp:DataGrid ID="dgvUnassignedPhoneNumbers" style="width: 100%" runat="server" AutoGenerateColumns="false">
                <AlternatingItemStyle CssClass="altrow" />
                <HeaderStyle CssClass="gridheader" />
                <Columns>
                  <asp:BoundColumn
                    HeaderText="ID"
                    DataField="CustomerPhoneNumberID"
                    visible="false"
                    />
                 <asp:TemplateColumn HeaderText="Add">
                   <ItemTemplate>
                     <asp:CheckBox ID="chkSelected" runat="server" />
                   </ItemTemplate>
                 </asp:TemplateColumn>
                  <asp:BoundColumn
                    HeaderText="Type"
                    DataField="PhoneType"
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
                </Columns>                
              </asp:DataGrid>            
            </td>
          </tr>
          <tr>
            <td>
              <div class="bandheader"><asp:Label ID="lblAssignedAddresssCount" runat="server" />&nbsp;Associated&nbsp;Address(es)</div>
              <asp:DataGrid style="width: 100%" AutoGenerateColumns="false" ID="dgvAddresses" runat="server">
                <HeaderStyle CssClass="gridheader" />
                <AlternatingItemStyle CssClass="altrow" />   
                <Columns> 
                  <asp:TemplateColumn>
                    <Itemtemplate>
                      <a href="removecustomeragentaddress.aspx?id=<%# DataBinder.Eval(Container.DataItem,"AssignmentID") %>&returnurl=editcustomeragent.aspx%3fid=<%# _ID %>">Remove</a>
                    </Itemtemplate>
                  </asp:TemplateColumn>                                       
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
                </Columns>        
              </asp:DataGrid>
            </td>
            <td>&nbsp;</td>
            <td>
              <div class="bandheader"><asp:Label ID="lblUnAssignedAddresssCount" runat="server" />&nbsp;Un-Associated&nbsp;Address(es)</div>
              <asp:DataGrid style="width: 100%" AutoGenerateColumns="false" ID="dgvUnassignedAddresses" runat="server">
                <HeaderStyle CssClass="gridheader" />
                <AlternatingItemStyle CssClass="altrow" />   
                <Columns> 
                  <asp:BoundColumn DataField="CustomerAddressID" Visible="false" />
                  <asp:TemplateColumn HeaderText="Add">
                    <Itemtemplate>
                      <asp:CheckBox id="chkSelectedAddress" runat="server" />
                    </Itemtemplate>
                  </asp:TemplateColumn>                                       
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
                </Columns>        
              </asp:DataGrid>
            </td>
          </tr>
          <tr>
            <td>
              <div class="bandheader"><asp:Label ID="lblAssignedServiceTypeCount" runat="server" /> Assigned Program(s)</div>
              <asp:DataGrid ID="dgvAssignedServiceTypes" runat="server" AutoGenerateColumns="false" style="width: 100%">
                <HeaderStyle cssclass="gridheader" />
                <AlternatingItemStyle CssClass="altrow" />
                <Columns>
                  <asp:BoundColumn HeaderText="ID" Visible="false" DataField="CustomerAgentServiceTypeID" />
                  <asp:BoundColumn HeaderText="ReadOnlyAccess" DataField="ReadOnlyAccess" Visible="false" />
                  <asp:BoundColumn FooterText="AdminAcess" DataField="AdminAccess" Visible="false" />
                  <asp:TemplateColumn>
                    <ItemTemplate>
                      <a href="removecustomeragentservicetype.aspx?id=<%# DataBinder.Eval(Container.DataItem,"CustomerAgentServiceTypeID") %>&returnurl=editcustomeragent.aspx%3fid=<%# DataBinder.Eval(Container.DataItem,"CustomerAgentID") %>">Remove</a>
                    </ItemTemplate>
                  </asp:TemplateColumn>
                  <asp:BoundColumn HeaderText="Program" DataField="ServiceType" />
                  <asp:TemplateColumn HeaderText="Admin">
                    <ItemTemplate>
                      <asp:CheckBox ID="chkAdminAccess" runat="server" />
                    </ItemTemplate>
                  </asp:TemplateColumn>
                  <asp:TemplateColumn HeaderText="Read Only">
                    <ItemTemplate>
                      <asp:CheckBox ID="chkReadOnlyAccess" runat="server" />
                    </ItemTemplate>
                  </asp:TemplateColumn>
                </Columns>
              </asp:DataGrid>
            </td>
            <td>&nbsp;</td>
            <td>
              <div class="bandheader"><asp:Label ID="lblUnassignedPrograms" runat="server" /> Unassigned Program(s)</div>
              <asp:DataGrid ID="dgvUnassignedServiceTypes" runat="server" AutoGenerateColumns="false" style="width: 100%">
                <HeaderStyle cssclass="gridheader" />
                <AlternatingItemStyle CssClass="altrow" />
                <Columns>
                  <asp:BoundColumn HeaderText="ID" Visible="false" DataField="ServiceTypeID" />
                  <asp:TemplateColumn HeaderText="Add">
                    <ItemTemplate>
                      <asp:CheckBox ID="chkAddServiceType" runat="server" />
                    </ItemTemplate>
                  </asp:TemplateColumn>
                  <asp:BoundColumn HeaderText="Program" DataField="ServiceType" />
                  <asp:TemplateColumn HeaderText="Admin">
                    <ItemTemplate>
                      <asp:CheckBox ID="chkAddAsAdmin" runat="server" />
                    </ItemTemplate>
                  </asp:TemplateColumn>
                  <asp:TemplateColumn HeaderText="Read Only">
                    <ItemTemplate>
                      <asp:CheckBox ID="chkAddAsReadOnly" runat="server" />
                    </ItemTemplate>
                  </asp:TemplateColumn>
                </Columns>
              </asp:DataGrid>
            </td>
          </tr>
        </tbody>
      </table>
      <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnApply" runat="server" OnClick="btnApply_Click" Text="Apply" />&nbsp;<asp:Button ID="btnSubmit" Text="Submit" runat="server" OnClick="btnSubmit_Click" /></div>
      <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
    </div>
  </form>
</asp:Content>