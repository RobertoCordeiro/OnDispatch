<%@ Page Language="vb" masterpagefile="~/masters/FieldTechniciansdialog.master" %>
<%@ Register Src="~/controls/FirstLastName.ascx" TagName="FirstLastName" TagPrefix="cv" %>
<%@ Register Src="~/controls/PhoneNumber.ascx" TagName="PhoneNumber" TagPrefix="cv" %>
<%@ MasterType VirtualPath="~/masters/FieldTechniciansdialog.master" %>
<script runat="server"> 
    
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)    
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Edit Partner Agent"
      Master.PageTitleText = "Edit Partner Agent"
    End If
    Secure()
    lblReturnUrl.Text = "settings.aspx"
    If Not IsPostBack Then
      LoadAgentTypes()
      LoadUnassignedPhoneNumbers()
      LoadUnassignedAddresses()
      LoadWebLoginPrefix()
    End If
  End Sub

  Private Sub Secure()
    Dim bln As Boolean = True
    Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    par.Load(Master.PartnerAgentID)
    If Not par.AdminAgent Then
      bln = False
    End If
    If Not bln Then
      Response.Redirect("settings.aspx", True)
    End If
  End Sub

  Private Sub LoadWebLoginPrefix()
    Dim ptr As New BridgesInterface.PartnerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ptr.Load(Master.PartnerID)
    lblResumeID.Text = ptr.ResumeID & "."
  End Sub
  
  Private Sub LoadUnassignedPhoneNumbers()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListPartnerPhoneNumbers", "@PartnerID", Master.PartnerID, Me.dgvUnassignedPhoneNumbers)
    lblUnassociatedCount.Text = dgvUnassignedPhoneNumbers.Items.Count
  End Sub

  Private Sub LoadUnassignedAddresses()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListPartnerAddresses", "@PartnerID", Master.PartnerID, Me.dgvUnassignedAddresses)
    lblUnAssignedAddresssCount.Text = dgvUnassignedAddresses.Items.Count
  End Sub
  
  Private Sub AssignAddresses(ByVal lngID As Long)
    Dim itm As System.Web.UI.WebControls.DataGridItem
    Dim chk As System.Web.UI.WebControls.CheckBox
    Dim aaa As New BridgesInterface.PartnerAgentAddressAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    For Each itm In dgvUnassignedAddresses.Items
      chk = itm.FindControl("chkSelectedAddress")
      If chk.Checked Then
        aaa.Add(Master.UserID, CType(itm.Cells(0).Text, Long), lngID)
      End If
    Next
  End Sub
  
  Private Sub AssignPhoneNumbers(ByVal lngID As Long)
    Dim itm As System.Web.UI.WebControls.DataGridItem
    Dim chk As System.Web.UI.WebControls.CheckBox
    Dim apa As New BridgesInterface.PartnerAgentPhoneNumberAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    For Each itm In dgvUnassignedPhoneNumbers.Items
      chk = itm.FindControl("chkSelected")
      If Not IsNothing(chk) Then
        If chk.Checked Then
          apa.Add(Master.UserID, lngID, CType(itm.Cells(0).Text, Long))
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
    cbxAgentTypes.SelectedValue = 10
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
  
  Private Sub Save()
    Dim strTrash As String = ""
    Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
    par.Add(Master.PartnerID, CType(cbxAgentTypes.SelectedValue, Long), Master.UserID, fnlAgent.FirstName, fnlAgent.LastName)
    par.MiddleName = fnlAgent.MI
    par.Email = txtEmail.Text
    par.AdminAgent = chkAdminAgent.Checked
    par.AgentTypeID = CType(cbxAgentTypes.SelectedValue, Long)
    par.Email = txtEmail.Text
    If chkCreateLogin.Checked Then
      wbl.Add(Master.UserID, lblResumeID.Text & txtLogin.Text.Trim, txtPassword.Text.Trim, "P")
      par.WebLoginID = wbl.WebLoginID    
    End If
    par.Save(strTrash)
    AssignPhoneNumbers(par.PartnerAgentID)
    AssignAddresses(par.PartnerAgentID)
  End Sub

  Private Sub btnAddPhone_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsPhoneComplete() Then
      Dim strTrash As String = ""
      divPhoneErrors.Visible = False
      Dim ppr As New BridgesInterface.PartnerPhoneNumberRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      ppr.Add(Master.PartnerID, phn.PhoneTypeID, Master.UserID, "1", phn.AreaCode, phn.Exchange, phn.LineNumber)
      ppr.Pin = phn.Pin
      ppr.Extension = phn.Extension
      ppr.Save(strTrash)
      LoadUnassignedPhoneNumbers()
      phn.AreaCode = ""
      phn.Exchange = ""
      phn.LineNumber = ""
      phn.Pin = ""
      phn.Extension = ""
      phn.PhoneTypeID = 1
    Else
      divPhoneErrors.Visible = True
    End If
  End Sub
  
  Private Function IsPhoneComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If phn.AreaCode.Trim.Length = 0 Then
      strErrors &= "<li>Area Code is Required</li>"
      blnReturn = False
    End If
    If phn.Exchange.Trim.Length = 0 Then
      strErrors &= "<li>Exchange is Required</li>"
      blnReturn = False
    End If
    If phn.LineNumber.Trim.Length = 0 Then
      strErrors &= "<li>Line Number is Required</li>"
      blnReturn = False
    End If
    strErrors = "<ul>" & strErrors & "</ul>"
    divPhoneErrors.InnerHtml = strErrors
    Return blnReturn
  End Function

  
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
              <asp:Label style="font-weight: bold;" ID="lblResumeID" runat="server" /><asp:TextBox ID="txtLogin" MaxLength="32" runat="server" />
              <div class="label">Password</div>
              <asp:TextBox style="width: 99%" ID="txtPassword" runat="server" />
              <div class="label">Confirm Password</div>
              <asp:TextBox style="width: 99%" ID="txtConfirmPassword" runat="server" />
            </td>
          </tr>
        </tbody>
      </table>
      <div class="bandheader"> <asp:label ID="lblUnassociatedCount" runat="server" />&nbsp;Available&nbsp;Phone&nbsp;Number(s)</div>
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
      <cv:PhoneNumber Text="Additional Phone Number" ID="phn" runat="server" />
      <div class="errorzone" runat="server" visible="false" id="divPhoneErrors" />
      <div style="text-align: right;"><asp:Button ID="btnAddPhoneNumber" runat="server" Text="Add Phone Number" OnClick="btnAddPhone_Click" /></div>
      <div>&nbsp;</div>
      <div class="bandheader"><asp:Label ID="lblUnAssignedAddresssCount" runat="server" />&nbsp;Available&nbsp;Address(es)</div>
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
      <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnSubmit" Text="Submit" runat="server" OnClick="btnSubmit_Click" /></div>
      <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
    </div>
  </form>
</asp:Content>