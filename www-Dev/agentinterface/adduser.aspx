<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" ValidateRequest="false" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server"> 
  Private _InfoID As Long = 0
    Private _ID As Long = 0
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Add Agent"
      Master.PageTitleText = "Add Agent"
      
    End If
    Try
            _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
            _ID = 0
    End Try
    Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""mycompany.aspx?id=" & _InfoID & """>My Company</a> "
    
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If Not IsPostBack then
            LoadPositions()
            LoadDepartments()
    end if
    
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
      If drpPositions.SelectedValue = "Assign Position" Then
            blnReturn = False
            strErrors &= "<li>You need to Assign a Position to this Employee</li>"
            End If
            If drpDepartments.SelectedValue = "Choose One" Then
                blnReturn = False
                strErrors &= "<li>You need to Assign a Department to this Employee</li>"
            End If
    End If
    divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
  Private Sub Save()
    Dim sec As New cvCommon.Security
    Dim strChangeLog As String = ""
    Dim usr As New BridgesInterface.UserRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        usr.Add(1, Master.UserID, txtUserName.Text, 0, txtFirstName.Text, txtLastName.Text, Master.InfoID, drpDepartments.selectedValue)
    Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    wbl.Add(Master.UserID, txtUserName.Text, txtPassword1.Text,  "A")
    usr.WebLoginID = wbl.WebLoginID
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
        usr.DepartmentID = drpDepartments.SelectedValue
    usr.Signature = txtSignature.Text
    usr.Active = chkActive.Checked
        usr.InfoID = Master.InfoID
    usr.Save(strChangeLog)
    wbl.Save(strChangeLog)
  End Sub
  
  Private Sub btnOK_Click(ByVal S As Object, ByVal e As EventArgs)
    If IsComplete() Then
      divErrors.Visible = False
      Save()
      Response.Redirect(lblReturnUrl.Text, True)
    Else
      divErrors.Visible = True
    End If
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  Private Sub LoadPositions()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSimpleDropDownList("spListPositions", "Position", "PositionID", drpPositions)
        drpPositions.Items.Add("Assign Position")
        drpPositions.SelectedValue = "Assign Position"
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
        <td class="label">Department</td>
          <td class="label">Login ID</td>
          <td class="label">Position</td>
          <td class="label">Password</td>
          <td class="label">Password (Confirm)</td>
        </tr>
        <tr>
        <td><asp:DropDownList ID="drpDepartments" runat="server" /></td>
          <td><asp:TextBox ID="txtUserName" runat="server" /></td>
          <td><asp:DropDownList ID="drpPositions" runat="server"   /></td>
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
          <td colspan="5" class="label"><asp:TextBox ID="txtSignature" runat="server" TextMode="multiline" style="width: 100%; height: 200px" /></td>
        </tr>
      </tbody>
    </table>
    <asp:CheckBox Checked="true" ID="chkActive" Text="Active" runat="server" />
    <div>&nbsp;</div>
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnOK" runat="server" Text="OK" OnClick="btnOK_Click" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>