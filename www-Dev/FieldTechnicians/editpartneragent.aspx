<%@ Page Language="vb" masterpagefile="~/masters/FieldTechniciansdialog.master" %>
<%@ Register Src="~/controls/FirstLastName.ascx" TagName="FirstLastName" TagPrefix="cv" %>
<%@ MasterType VirtualPath="~/masters/FieldTechniciansdialog.master" %>
<script runat="server"> 
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)    
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Edit Partner Agent"
      Master.PageTitleText = "Edit Partner Agent"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    If _ID > 0 Then
      lblReturnUrl.Text = "settings.aspx"
      If Not IsPostBack Then        
        LoadAgent(_ID)
      End If
    Else
      Response.Redirect("settings.aspx", True)
    End If
  End Sub

  Private Sub Secure()
    Dim bln As Boolean = True
    Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    par.Load(_ID)
    If Not par.PartnerID = Master.PartnerID Then
      bln = False
    End If
    par.Load(Master.PartnerAgentID)
    If Not par.AdminAgent Then
      bln = False
    End If
    If Not bln Then
      Response.Redirect("settings.aspx", True)
    End If
  End Sub
  
  
  Private Sub LoadAgent(ByVal lngID As Long)
    LoadAgentTypes()
    Dim ptr As New BridgesInterface.PartnerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
    par.Load(lngID)
    ptr.Load(par.PartnerID)
    lblResumeID.Text = ptr.ResumeID & "."
    chkAdminAgent.Checked = par.AdminAgent
    cbxAgentTypes.SelectedValue = par.AgentTypeID
    txtEmail.Text = par.Email
    fnlAgent.FirstName = par.FirstName
    fnlAgent.MI = par.MiddleName
    fnlAgent.LastName = par.LastName
    chkAgentActive.Checked = par.Active
    If par.DLFileID > 0 Then
      lnkDL.HRef = "viewfile.aspx?id=" & par.DLFileID
    End If
    If par.WebLoginID > 0 Then
      Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
      wbl.Load(par.WebLoginID)
      txtLogin.Text = wbl.Login
      chkCreateLogin.Text = "Change Password"
      txtLogin.ReadOnly = True
      chkActive.Checked = wbl.Active
      lblResumeID.Visible = False
    Else
      chkCreateLogin.Checked = False
      chkActive.Visible = False
    End If
    LoadAssignedPhoneNumbers()
    LoadUnassignedPhoneNumbers()
    LoadAssignedAddresses()
    LoadUnassignedAddresses()
  End Sub
  
  Private Sub LoadAssignedPhoneNumbers()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListPartnerAgentPhoneNumbers", "@PartnerAgentID", _ID, dgvAssociatedPhoneNumbers)
    lblAssociatedCount.Text = dgvAssociatedPhoneNumbers.Items.Count
  End Sub

  Private Sub LoadAssignedAddresses()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListPartnerAgentAddresses", "@PartnerAgentID", _ID, Me.dgvAddresses)
    lblAssignedAddresssCount.Text = dgvAddresses.Items.Count
  End Sub

  Private Sub LoadUnassignedPhoneNumbers()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListUnassignedPhoneNumbersForPartnerAgent", "@PartnerAgentID", _ID, Me.dgvUnassignedPhoneNumbers)
    lblUnassociatedCount.Text = dgvUnassignedPhoneNumbers.Items.Count
  End Sub

  Private Sub LoadUnassignedAddresses()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListUnassignedAddressesForPartnerAgent", "@PartnerAgentID", _ID, Me.dgvUnassignedAddresses)
    lblUnAssignedAddresssCount.Text = dgvUnassignedAddresses.Items.Count
  End Sub
  
  Private Sub AssignAddresses()
    Dim itm As System.Web.UI.WebControls.DataGridItem
    Dim chk As System.Web.UI.WebControls.CheckBox
    Dim aaa As New BridgesInterface.PartnerAgentAddressAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    For Each itm In dgvUnassignedAddresses.Items
      chk = itm.FindControl("chkSelectedAddress")      
      If chk.Checked Then    
        aaa.Add(Master.UserID, CType(itm.Cells(0).Text, Long), _ID)
      End If
    Next
  End Sub
  
  Private Sub AssignPhoneNumbers()
    Dim itm As System.Web.UI.WebControls.DataGridItem
    Dim chk As System.Web.UI.WebControls.CheckBox
    Dim apa As New BridgesInterface.PartnerAgentPhoneNumberAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    For Each itm In dgvUnassignedPhoneNumbers.Items
      chk = itm.FindControl("chkSelected")
      If Not IsNothing(chk) Then
        If chk.Checked Then
          apa.Add(Master.UserID, _ID, CType(itm.Cells(0).Text, Long))
        End If
      End If
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
    Dim lng As Long = 0
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
      wbl.Load(lblResumeID.Text & txtLogin.Text)
      Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      par.Load(_ID)
      If par.WebLoginID = 0 Then
        If txtLogin.Text.Trim.Length = 0 Then
          blnReturn = False
          strErrors &= "<li>Login is Required</li>"
        End If
        If Not Long.TryParse(txtLogin.Text.Trim, lng) Then
          blnReturn = False
          strErrors &= "<li>Login Must Be Numeric</li>"
        End If
        If wbl.WebLoginID > 0 Then
          blnReturn = False
          strErrors &= "<li>Login already exist, please use another</li>"
        End If
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
    If IsComplete() Then
      Save()
      LoadAgent(_ID)
      divErrors.Visible = False
    Else
      divErrors.Visible = True
    End If
  End Sub
  
  Private Sub Save()
    Dim strTrash As String = ""
    Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
    par.Load(_ID)
    par.FirstName = fnlAgent.FirstName
    par.LastName = fnlAgent.LastName
    par.MiddleName = fnlAgent.MI
    par.Email = txtEmail.Text
    par.AdminAgent = chkAdminAgent.Checked
    par.Active = chkAgentActive.Checked
    par.AgentTypeID = CType(cbxAgentTypes.SelectedValue, Long)
    par.Email = txtEmail.Text
    If chkCreateLogin.Checked Then
      If par.WebLoginID > 0 Then
        wbl.Load(par.WebLoginID)
        wbl.SetPassword(txtPassword.Text.Trim)
        wbl.Active = chkActive.Checked
        wbl.Save(strTrash)
      Else
        wbl.Add(Master.UserID, lblResumeID.Text & txtLogin.Text.Trim, txtPassword.Text.Trim, "P")
        par.WebLoginID = wbl.WebLoginID
      End If
    End If
    par.Save(strTrash)
    AssignPhoneNumbers()
    AssignAddresses()            
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
  
  Private Function CurrentID() As Long
    Return _ID
  End Function
  
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
              <div><a id="lnkDL" runat="server">Drivers License</a>&nbsp;<a href="upload.aspx?id=<%# currentid %>&mode=dl">[Upload New]</a></div>
              <div style="text-align: right;"><asp:CheckBox ID="chkAdminAgent" runat="server" Text="Admin Agent" />&nbsp;<asp:CheckBox ID="chkAgentActive" Text="Active" runat="server" /></div>
              <div>&nbsp;</div>    
            </td>
            <td>&nbsp;</td>
            <td>
              <asp:CheckBox Text="Create Web Login" ID="chkCreateLogin" runat="server" />
              <div class="label">Login</div>
              <asp:Label style="font-weight: bold;" ID="lblResumeID" runat="server" /><asp:TextBox ID="txtLogin" MaxLength="32" runat="server" />
              <div class="label">Password</div>
              <asp:TextBox style="width: 99%" ID="txtPassword" runat="server" />
              <div class="label">Confirm Password</div>
              <asp:TextBox style="width: 99%" ID="txtConfirmPassword" runat="server" />
              <div style="text-align: right"><asp:CheckBox ID="chkActive" runat="server" Text="Login Active" /></div>
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
                      <a href="removePartneragentphonenumber.aspx?id=<%# DataBinder.eval(Container.DataItem,"AssignmentID") %>&returnurl=editPartneragent.aspx%3fid=<%# _ID %>">Remove</a>                      
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
                    DataField="PartnerPhoneNumberID"
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
                      <a href="removepartneragentaddress.aspx?id=<%# DataBinder.Eval(Container.DataItem,"PartnerAgentAddressAssignmentID") %>&returnurl=editpartneragent.aspx%3fid=<%# _ID %>">Remove</a>
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
                  <asp:BoundColumn DataField="PartnerAddressID" Visible="false" />
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
        </tbody>
      </table>
      <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnApply" runat="server" OnClick="btnApply_Click" Text="Apply" />&nbsp;<asp:Button ID="btnSubmit" Text="Submit" runat="server" OnClick="btnSubmit_Click" /></div>
      <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
    </div>
  </form>
</asp:Content>