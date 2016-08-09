<%@ Page Language="vb" masterpagefile="~/masters/customerdialog.master" %>
<%@ Register Src="~/controls/FirstLastName.ascx" TagName="FirstLastName" TagPrefix="cv" %>
<%@ MasterType VirtualPath="~/masters/customerdialog.master" %>
<script runat="server"> 
  

  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Add Customer Agent"
      Master.PageTitleText = "Add Customer Agent"
    End If
    Secure()
    If Not IsPostBack Then
      LoadAgentTypes()
    End If        
  End Sub
  
  Private Sub Secure()
    Dim cag As New BridgesInterface.CustomerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    cag.Load(Master.CustomerAgentID)
    If Not cag.AdminAgent Then
      Response.Redirect("account.aspx", True)
    End If
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
    Response.Redirect("account.aspx", True)
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
      If txtLogin.Text.Trim.Length = 0 Then
        blnReturn = False
        strErrors &= "<li>Login is Required</li>"
      Else
        wbl.Load(txtLogin.Text)
        If wbl.WebLoginID > 0 Then
          blnReturn = False
          strErrors &= "<li>Login Already Exists, Please Choose Another</li>"
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
  
  Private Sub btnSubmit_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      divErrors.Visible = False
      Dim strTrash As String = ""
      Dim cag As New BridgesInterface.CustomerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim wbl As New BridgesInterface.WebLoginRecord(cag.ConnectionString)
      cag.Add(Master.CustomerID, cbxAgentTypes.SelectedValue, Master.UserID, fnlAgent.FirstName, fnlAgent.LastName, chkAdminAgent.Checked)
      cag.MiddleName = fnlAgent.MI
      cag.Email = txtEmail.Text
      If chkCreateLogin.Checked Then
        wbl.Add(Master.UserID, txtLogin.Text.Trim, txtPassword.Text.Trim, "C")
        cag.WebLoginID = wbl.WebLoginID
      End If
      cag.Save(strTrash)
      Response.Redirect("account.aspx", True)
    Else
      divErrors.Visible = True
    End If
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div style="padding: 4px 4px 4px 4px">
      <div class="errorzone" id="divErrors" runat="server" visible="false"/>
      <div class="label">Agent Type</div>
      <div><asp:DropDownList ID="cbxAgentTypes" style="width:99%" runat="server" /></div>
      <cv:FirstLastName ID="fnlAgent" runat="server" />
      <div class="label">Email Address</div>
      <asp:TextBox style="width: 99%" ID="txtEmail" runat="server" />
      <div style="text-align: right;"><asp:CheckBox ID="chkAdminAgent" runat="server" Text="Admin Agent" /></div>
      <div>&nbsp;</div>    
      <asp:CheckBox Text="Create Web Login" ID="chkCreateLogin" runat="server" />
      <div class="label">Login</div>
      <asp:TextBox style="width: 99%" ID="txtLogin" MaxLength="32" runat="server" />
      <div class="label">Password</div>
      <asp:TextBox style="width: 99%" ID="txtPassword" runat="server" />
      <div class="label">Confirm Password</div>
      <asp:TextBox style="width: 99%" ID="txtConfirmPassword" runat="server" />
      <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnSubmit" Text="Submit" runat="server" OnClick="btnSubmit_Click" /></div>
      <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
    </div>
  </form>
</asp:Content>