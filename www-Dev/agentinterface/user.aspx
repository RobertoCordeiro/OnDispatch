<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" ValidateRequest="false" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server"> 
  
  Private _ID As Long = 0
  Private _InfoID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Edit User"
      Master.PageTitleText = "Edit User"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    
    
    If _ID > 0 Then
           Dim usr As New BridgesInterface.UserRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
           Dim inf As New BridgesInterface.CompanyInfoRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
           usr.Load(_ID)
           _InfoID = usr.InfoID 
           inf.Load (_InfoID)
           lblReturnUrl.Text = "mycompany.aspx?id=" & inf.CustomerID  & "&t=1&infoID=" & _InfoID 

       Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""mycompany.aspx?id=" & inf.CustomerID & "&infoID=" & usr.InfoID & """>My Company</a>"

      If Not IsPostBack Then
        LoadUser(_ID)
      End If
    Else
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub
  
  Private Sub LoadUser(ByVal lngUserID As Long)
    Dim usr As New BridgesInterface.UserRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    usr.Load(lngUserID)
    Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        wbl.Load(usr.WebLoginID)
        LoadPositions()
        LoadDepartments()
    txtUserName.Text = usr.UserName 
    txtTitle.Text = usr.Title
    txtExtension.Text = usr.Extension
    txtFirstName.Text = usr.FirstName
    txtMI.Text = usr.MiddleName
    txtLastName.Text = usr.LastName
    txtSuffix.Text = usr.Suffix
    txtEmail.Text = usr.Email
    drpDepartments.SelectedValue = usr.DepartmentID
        txtSignature.Text = usr.Signature
        drpPositions.SelectedValue = usr.PositionID
        chkActive.Checked = usr.Active
        If drpPositions.SelectedValue = 8 Then
            LoadUnAssignedStatesForUser(_ID)
            LoadAssignedStatesForUser(_ID)
            dgvAssignedStates.Visible = True
            dgvUnAssignedStates.Visible = True
            lblAssignedStates.Text = "Assigned States"
            lblUnAssignedStates.Text = "UnAssigned States"
        Else
            dgvAssignedStates.Visible = False
            dgvUnAssignedStates.Visible = False
            lblAssignedStates.Text = ""
            lblUnAssignedStates.Text = ""
        End If
        
    End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If txtUserName.Text.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>User Name is Required</li>"
    End If
    If txtFirstName.Text.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>First Name is Required</li>"
    End If
    If txtLastName.Text.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Last Name is Required</li>"      
    End If
    If txtEmail.Text.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Email is Required</li>"
    Else
      Dim val As New cvCommon.Validators
      If Not val.IsValidEmail(txtEmail.Text.Trim) Then
        blnReturn = False
        strErrors &= "<li>Email Address is Invalid</li>"
      End If
    End If
    If txtPassword1.Text.Trim.Length & txtPassword2.Text.Trim.Length > 0 Then
      If txtPassword1.Text.Trim.Length = 0 Then
        blnReturn = False
        strErrors &= "<li>Password is Required</li>"
      End If
      If txtPassword2.Text.Trim.Length = 0 Then
        blnReturn = False
        strErrors &= "<li>Password (Confirm) is Required</li>"
      End If
      If txtPassword1.Text.Trim <> txtPassword2.Text.Trim Then
        blnReturn = False
        strErrors &= "<li>Password and Password (Confirm) must match</li>"
      End If
        End If
        If drpPositions.SelectedValue = "Assign Position" Then
            blnReturn = False
            strErrors &= "<li>You need to Assign a Position to this Employee</li>"
        End If
        If drpDepartments.SelectedValue = "Choose One" Then
            blnReturn = False
            strErrors &= "<li>You need to Assign a Department to this Employee</li>"
        End If
    divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
  Private Sub Save()
    Dim strChangeLog As String = ""
    Dim usr As New BridgesInterface.UserRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    usr.Load(_ID)
    wbl.Load(usr.WebLoginID)
    usr.UserName = txtUserName.Text.Trim
    wbl.Login = txtUserName.Text.Trim
    If txtPassword1.Text.Trim.Length > 0 Then
      wbl.SetPassword(txtPassword1.Text)
    End If
    usr.Title = txtTitle.Text.Trim
    usr.FirstName = txtFirstName.Text.Trim
    usr.MiddleName = txtMI.Text.Trim
    usr.Extension = txtExtension.Text.Trim
    usr.LastName = txtLastName.Text
    usr.Suffix = txtSuffix.Text
    usr.Email = txtEmail.Text
    usr.Signature = txtSignature.Text
        usr.Active = chkActive.Checked
        usr.PositionID = drpPositions.SelectedValue
    wbl.Active = usr.Active
        usr.Save(strChangeLog)
        If drpPositions.SelectedValue = 8 Then
            LoadUnAssignedStatesForUser(_ID)
            LoadAssignedStatesForUser(_ID)
            dgvAssignedStates.Visible = True
            dgvUnAssignedStates.Visible = True
            lblAssignedStates.Text = "Assigned States"
            lblUnAssignedStates.Text = "UnAssigned States"
        Else
            dgvAssignedStates.Visible = False
            dgvUnAssignedStates.Visible = False
            lblAssignedStates.Text = ""
            lblUnAssignedStates.Text = ""
        End If
    Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strIp As String = Request.QueryString("REMOTE_ADDR")
    Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
    If IsNothing(strIp) Then
      strIp = "unknown"
    End If
    If IsNothing(strType) Then
      strType = "web"
    End If
    act.Add(Master.UserID, "web", strType, strIp, Master.WebLoginID.ToString, 1, usr.UserID, strChangeLog)
    wbl.Save(strChangeLog)
    act.Add(Master.UserID, "web", strType, strIp, Master.WebLoginID.ToString, 21, wbl.WebLoginID, strChangeLog)
  End Sub
  
  Private Sub btnOK_Click(ByVal S As Object, ByVal e As EventArgs)
    If IsComplete() Then
            divErrors.Visible = False
            AssignStates(_ID)
      Save()
      Response.Redirect(lblReturnUrl.Text, True)
    Else
      divErrors.Visible = True
    End If
    End Sub
    Private Sub btnApply_Click(ByVal S As Object, ByVal e As EventArgs)
        If IsComplete() Then
            divErrors.Visible = False
            AssignStates(_ID)
            RemoveStates(_ID)
            Save()
            
        Else
            divErrors.Visible = True
        End If
    End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
    End Sub
    Private Sub drpPositions_OnSelectedIndexChanged(ByVal S As Object, ByVal E As EventArgs)
        If drpPositions.SelectedValue = 8 Then
            LoadUnAssignedStatesForUser(_ID)
            LoadAssignedStatesForUser(_ID)
            dgvAssignedStates.Visible = True
            dgvUnAssignedStates.Visible = True
            lblAssignedStates.Text = "Assigned States"
            lblUnAssignedStates.Text = "UnAssigned States"
        Else
            dgvAssignedStates.Visible = False
            dgvUnAssignedStates.Visible = False
            lblAssignedStates.Text = ""
            lblUnAssignedStates.Text = ""
        End If
        
    End Sub
    
    Private Sub LoadPositions()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSimpleDropDownList("spListPositions", "Position", "PositionID", drpPositions)
        drpPositions.Items.Add("Assign Position")
        drpPositions.SelectedValue = "Assign Position"
    End Sub
    Private Sub LoadUnAssignedStatesForUser(ByVal lngUserID As Long)
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadTwoLongParameterDataGrid("spListUnAssignedStatesForUser", "@UserID", lngUserID, "@CountryID", 1, dgvUnAssignedStates)
       
    End Sub
    Private Sub LoadAssignedStatesForUser(ByVal lngUserID As Long)
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadTwoLongParameterDataGrid("spListAssignedStatesForUser", "@UserID", lngUserID, "@CountryID", 1, dgvAssignedStates)
       
    End Sub
    Private Sub AssignStates(ByVal lngUserID As Long)
        Dim itm As System.Web.UI.WebControls.DataGridItem
        Dim chk As System.Web.UI.WebControls.CheckBox
        Dim aaa As New BridgesInterface.UserRecruitAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        For Each itm In dgvUnAssignedStates.Items
            chk = itm.FindControl("chkSelected")
            If chk.Checked Then
                aaa.Add(lngUserID, CType(itm.Cells(0).Text, Long))
            End If
        Next
    End Sub
    Private Sub RemoveStates(ByVal lngUserID As Long)
        Dim itm As System.Web.UI.WebControls.DataGridItem
        Dim chk As System.Web.UI.WebControls.CheckBox
        Dim aaa As New BridgesInterface.UserRecruitAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        For Each itm In dgvAssignedStates.Items
            chk = itm.FindControl("chkSelect")
            If chk.Checked Then
                aaa.Delete(lngUserID, CType(itm.Cells(0).Text, Long))
            End If
        Next
    End Sub
    Private Sub LoadDepartments()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSimpleDropDownList("spListDepartments", "DepartmentName", "DepartmentID", drpDepartments)
        drpDepartments.Items.Add("Choose One")
        drpDepartments.SelectedValue = "Choose One"
        
    End Sub
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div class="errorzone" id="divErrors" runat="server" visible="false" />
    <table>
      <tbody>
        <tr>
          <td class="label">User Name</td>
          <td class="label">Position</td>
          <td class="label">Department</td>
          <td class="label">Password (Confirm)</td>
        </tr>
        <tr>
          <td><asp:TextBox ID="txtUserName" runat="server" /></td>
          <td><asp:DropDownList ID="drpPositions" runat="server"  AutoPostBack="true" OnSelectedIndexChanged="drpPositions_OnSelectedIndexChanged"/></td>
          <td><asp:DropDownList ID="drpDepartments" runat="server"  /></td>
          <td><asp:TextBox ID="txtPassword1" runat="server" /></td>
          <td><asp:TextBox ID="txtPassword2" runat="server" /></td>
        </tr>
      </tbody>
    </table>
    <table>
      <tbody>
        <tr>
          <td class="label">Title</td>
          <td class="label">First Name</td>
          <td class="label">MI</td>
          <td class="label">Last Name</td>
          <td class="label">Suffix</td>
        </tr>
        <tr>
          <td><asp:TextBox ID="txtTitle" MaxLength="16" runat="server" /></td>
          <td><asp:TextBox ID="txtFirstName" maxlength="32" runat="server" /></td>
          <td><asp:TextBox ID="txtMI" MaxLength="32" runat="server" /></td>
          <td><asp:TextBox ID="txtLastName" MaxLength="64" runat="server" /></td>
          <td><asp:TextBox ID="txtSuffix" MaxLength="8" runat="server" /></td>
        </tr>
        <tr>
          <td colspan="4" class="label">Email Address</td>
          <td class="label">Extension</td>
        </tr>
        <tr>
          <td style="padding-right: 3px" colspan="4" class="label"><asp:TextBox ID="txtEmail" runat="server" style="width: 100%" /></td>
          <td><asp:TextBox ID="txtExtension" runat="server" /></td>
        </tr>
        <tr>
          <td colspan="5" class="label">Email Signature</td>
        </tr>
        <tr>
          <td colspan="5" class="label"><asp:TextBox ID="txtSignature" runat="server" TextMode="multiline" style="width: 100%; height: 200px" />&nbsp;</td>
          
        </tr>
        <tr>
        <td>
             <div>&nbsp;&nbsp;</div>
             <div class="inputformsectionheader"><asp:label ID="lblAssignedStates" runat="server" /></div>
                            <asp:DataGrid ID="dgvAssignedStates" style="width: 100%" runat="server" AutoGenerateColumns="false" CssClass="Grid1">
                               <AlternatingItemStyle CssClass="altrow" />
                                  <HeaderStyle CssClass="gridheader" />
                                     <Columns>
                                        <asp:BoundColumn HeaderText="ID" DataField="StateID" visible="false" />
                                         <asp:BoundColumn HeaderText="ID" DataField="StateID" visible="false" />
                                         <asp:TemplateColumn HeaderText="Remove" >
                                           <ItemTemplate>
                                              <asp:CheckBox ID="chkSelect" runat="server" />
                                           </ItemTemplate>
                                         </asp:TemplateColumn>
                                         <asp:BoundColumn HeaderText="State" DataField="Abbreviation" />             
                                     </Columns>                
                               </asp:DataGrid>  
          </td>
          <td> 
             <div>&nbsp;</div>
             <div class="inputformsectionheader"> <asp:label ID="lblUnAssignedStates" runat="server" /></div>
              <asp:DataGrid ID="dgvUnAssignedStates" style="width: 100%" runat="server" AutoGenerateColumns="false" CssClass="Grid1">
                <AlternatingItemStyle CssClass="altrow" />
                <HeaderStyle CssClass="gridheader" />
                <Columns>
                 <asp:BoundColumn HeaderText="ID" DataField="StateID" visible="false" />
                   <asp:TemplateColumn HeaderText="Add">
                     <ItemTemplate>
                       <asp:CheckBox ID="chkSelected" runat="server" />
                     </ItemTemplate>
                   </asp:TemplateColumn>
                   <asp:BoundColumn HeaderText="State" DataField="Abbreviation" />                 
                 </Columns>                
              </asp:DataGrid>            
          
          </td>  
          <td colspan="5" align="right">
    
    <div style="text-align: right;"><asp:CheckBox ID="chkActive" Text="Active" runat="server" />&nbsp;&nbsp;&nbsp;<asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnApply" runat="server" Text="Apply" OnClick="btnApply_Click" />&nbsp;<asp:Button ID="btnOK" runat="server" Text="Close" OnClick="btnOK_Click" /></div></td>       
        </tr>
      </tbody>
    </table>
    
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
    
  </form>
</asp:Content>