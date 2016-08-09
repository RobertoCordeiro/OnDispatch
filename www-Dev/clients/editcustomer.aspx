<%@ Page Language="vb" masterpagefile="~/masters/customerdialog.master" %>
<%@ MasterType VirtualPath="~/masters/customerdialog.master" %>
<script runat="server"> 
    
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Edit Customer"
      Master.PageTitleText = " Edit Customer"
    End If
    Secure()
    lblReturnUrl.Text = "account.aspx"
    If Not IsPostBack Then
      LoadCustomer()
    End If
  End Sub

  Private Sub Secure()
    Dim cag As New BridgesInterface.CustomerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    cag.Load(Master.CustomerAgentID)
    If Not cag.AdminAgent Then
      Response.Redirect("account.aspx", True)
    End If
    If cag.CustomerID <> Master.CustomerID Then
      Response.Redirect("account.aspx", True)
    End If
  End Sub
  
  Private Sub LoadCustomer()
    Dim cst As New BridgesInterface.CustomerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    cst.Load(Master.CustomerID)
    txtCompany.Text = cst.Company
    txtPrefix.Text = cst.Title
    txtFirstName.Text = cst.FirstName
    txtMI.Text = cst.MiddleName
    txtLastName.Text = cst.LastName
    txtSuffix.Text = cst.Suffix
    txtEmail.Text = cst.Email
    txtWebSite.Text = cst.WebSite
    txtRef1Label.Text = cst.Ref1Label
    txtRef2Label.Text = cst.Ref2Label
    txtRef3Label.Text = cst.Ref3Label
    txtRef4Label.Text = cst.Ref4Label
  End Sub

  Private Sub btnSave_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      divErrors.Visible = False
      Dim strChangeLog As String = ""
      Dim cst As New BridgesInterface.CustomerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      cst.Load(Master.CustomerID)
      cst.Company = txtCompany.Text
      cst.Title = txtPrefix.Text
      cst.FirstName = txtFirstName.Text
      cst.MiddleName = txtMI.Text
      cst.LastName = txtLastName.Text
      cst.Suffix = txtSuffix.Text
      cst.Email = txtEmail.Text
      cst.WebSite = txtWebSite.Text
      cst.Ref1Label = txtRef1Label.Text
      cst.Ref2Label = txtRef2Label.Text
      cst.Ref3Label = txtRef3Label.Text
      cst.Ref4Label = txtRef4Label.Text
      cst.Save(strChangeLog)
      Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim strIp As String = Request.QueryString("REMOTE_ADDR")
      Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
      If IsNothing(strIp) Then
        strIp = "unknown"
      End If
      If IsNothing(strType) Then
        strType = "web"
      End If
      act.Add(Master.UserID, "web", strType, strIp, Master.WebLoginID, 6, cst.CustomerID, strChangeLog)
      Response.Redirect(lblReturnUrl.Text, True)
    Else
      divErrors.Visible = True
    End If
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    Dim val As New cvCommon.Validators
    divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
    If txtCompany.Text.Trim.Length + (txtFirstName.Text.Trim & txtLastName.Text.Trim).Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>A Company Name or Name is Required</li>"
    End If
    If txtEmail.Text.Trim.Length > 0 Then
      If Not val.IsValidEmail(txtEmail.Text) Then
        blnReturn = False
        strErrors &= "<li>Email is Invalid</li>"        
      End If
    End If
    If txtWebSite.Text.Trim.Length > 0 Then
      If Not val.IsValidUrl(txtWebSite.Text) Then
        blnReturn = False
        strErrors &= "<li>Web Site is Invalid</li>"
      End If
    End If
    divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
  Private Sub btnSubmit_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      divErrors.Visible = False
    Else
      divErrors.Visible = True
    End If
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server" style="padding-right: 8px;">
    <div class="errorzone" id="divErrors" runat="server" visible="false" />
    <div style="width: 400px">&nbsp;</div>
    <div class="label">Company Name</div>
    <asp:TextBox ID="txtCompany" runat="server" style="width: 100%;" />
    <div class="label">Name</div>
    <table style="width: 100%;">
      <tbody>
        <tr>
          <td class="label">Prefix</td>
          <td>&nbsp;</td>
          <td class="label">First&nbsp;Name</td>
          <td>&nbsp;</td>
          <td class="label">MI</td>
          <td>&nbsp;</td>
          <td class="label">Last&nbsp;Name</td>
          <td>&nbsp;</td>
          <td class="label" style="padding-right: 8px;">Suffix</td>
        </tr>
        <tr>
          <td><asp:TextBox style="width: 100%" id="txtPrefix" runat="server" /></td>
          <td>&nbsp;</td>
          <td><asp:TextBox style="width: 100%" id="txtFirstName" runat="server" /></td>
          <td>&nbsp;</td>
          <td><asp:TextBox style="width: 100%" id="txtMI" runat="server" /></td>
          <td>&nbsp;</td>
          <td><asp:TextBox style="width: 100%" id="txtLastName" runat="server" /></td>
          <td>&nbsp;</td>
          <td style="padding-right: 4px;"><asp:TextBox style="width: 100%;" id="txtSuffix" runat="server" /></td>
        </tr>
      </tbody>
    </table>
    <div class="label">Email Address</div>
    <asp:TextBox id="txtEmail" runat="server" style="width: 100%" />
    <div class="label">Web Site</div>
    <asp:TextBox ID="txtWebSite" runat="server" style="width: 100%" />
    <div>&nbsp;</div>
    <div class="bandheader">Display Settings</div>
    <table style="width: 100%">
      <tr>
        <td class="label">Ref 1 Label</td>
        <td>&nbsp;</td>
        <td class="label">Ref 2 Label</td>
      </tr>
      <tr>
        <td class="label"><asp:TextBox ID="txtRef1Label" runat="server" style="width: 100%" /></td>
        <td>&nbsp;</td>
        <td style="padding-right: 4px"><asp:TextBox ID="txtRef2Label" runat="server" style="width: 100%" /></td>
      </tr>      
      <tr>
        <td class="label">Ref 3 Label</td>
        <td>&nbsp;</td>
        <td class="label">Ref 4 Label</td>
      </tr>
      <tr>
        <td class="label"><asp:TextBox ID="txtRef3Label" runat="server" style="width: 100%" /></td>
        <td>&nbsp;</td>
        <td style="padding-right: 4px;"><asp:TextBox ID="txtRef4Label" runat="server" style="width: 100%" /></td>
      </tr>
    </table>
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:button ID="btnSave" OnClick="btnSave_Click" runat="server" Text="Save" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>