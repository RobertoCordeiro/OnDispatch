<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<%@ Register Src="~/controls/FirstLastName.ascx" TagName="FirstLastName" TagPrefix="cv" %>
<script runat="server"> 
  
  Private _ID As Long = 0
   
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Edit Partner"
      Master.PageTitleText = "Edit Partner"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""partners.aspx"">Partner Management</a> &gt; Edit Partner"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If _ID > 0 Then
            If Not IsPostBack Then
                Dim inf As New BridgesInterface.CompanyInfoRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                inf.Load(Master.InfoID)
                Dim par As New BridgesInterface.PartnerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                par.Load(_ID)
                If par.InfoID <> inf.InfoID Then
                    Response.Redirect("/logout.aspx")
                Else
                    LoadMonths(cbxMonths)
                    LoadCSRs()
                    LoadPartner()
                End If
            End If
    Else
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub
  
  Private Sub LoadEntityTypes()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDropDownList("spListEntityTypes", "EntityType", "EntityTypeID", cbxEntityTypes)
  End Sub
  
  ''' <summary>
  ''' Loads the states into the appropriate combo
  ''' </summary>
  Private Sub LoadMonths(ByRef cbx As System.Web.UI.WebControls.DropDownList)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListMonths")
    Dim itm As ListItem
    Dim lngSelectedValue As Long = 0
    cmd.CommandType = Data.CommandType.StoredProcedure
    cnn.Open()
    cmd.Connection = cnn
    Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
    cbx.Items.Clear()
    itm = New ListItem
    itm.Text = "[Choose One]"
    itm.Value = 0
    cbx.Items.Add(itm)
    While dtr.Read
      itm = New ListItem
      itm.Text = dtr("MonthName")
      itm.Value = dtr("MonthID")
      cbx.Items.Add(itm)
    End While
    cnn.Close()
  End Sub
  
  Private Sub LoadPartner()
    LoadEntityTypes()
    Dim sec As New cvCommon.Security
    Dim par As New BridgesInterface.PartnerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    par.Load(_ID)
    txtEmail.Text = par.Email
    txtWebsite.Text = par.WebSite
    txtCompanyName.Text = par.CompanyName
    txtEIN.Text = sec.GDecypher2(par.EIN)
        txtConfirmEIN.Text = sec.GDecypher2(par.EIN)
        chkActive.Checked = par.Active
        cbxEntityTypes.SelectedValue = par.EntityTypeID
    cbxMonths.SelectedValue = par.BusinessStartedMonthID
    txtYear.Text = par.BusinessStartedYear
    drpCSR.SelectedValue = par.UserID

  End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim lngID As Long = 0
    Dim lng As Long = 0
    Dim strError As String = "<ul>"
    If txtCompanyName.Text.Trim.Length = 0 Then
      strError &= "<li>COmpany Name is Required</li>"
      blnReturn = False
    End If
    If txtEIN.Text.Trim <> txtConfirmEIN.Text.Trim Then
      strError &= "<li>EINs Do Not Match</li>"
      blnReturn = False
    End If
    If txtEIN.Text.Trim.Length > 0 Then
      If txtEIN.Text.Trim.Length <> 9 Then
        strError &= "<li>EIN Must Be 9 Digits</li>"
        blnReturn = False
      End If
      If Not Long.TryParse(txtEIN.Text, lngID) Then
        strError &= "<li>EIN Requires Numbers Only</li>"
        blnReturn = False
      End If
    End If
    If txtEmail.Text.Trim.Length = 0 Then
      blnReturn = False
      strError &= "<li>" & "Email is Required" & "</li>"
    End If
    If Not Long.TryParse(txtYear.Text, lng) Then
      blnReturn = False
      strError &= "<li>Business Start Year Must Be A While Number</li>"
    End If
    strError &= "</ul>"
    divError.InnerHtml = strError
    Return blnReturn
  End Function
  
  Private Sub btnOK_Click(ByVal S As Object, ByVal e As EventArgs)
    If IsComplete() Then
      divErrors.Visible = False
      Dim strChangeLog As String = ""
      Dim par As New BridgesInterface.PartnerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      par.Load(_ID)
      Dim sec As New cvCommon.Security
      par.Email = txtEmail.Text
      par.WebSite = txtWebsite.Text
      par.CompanyName = txtCompanyName.Text
      par.EIN = sec.GCypher2(txtEIN.Text)
      par.EntityTypeID = cbxEntityTypes.SelectedValue
      par.BusinessStartedMonthID = cbxMonths.SelectedValue
            par.BusinessStartedYear = txtYear.Text
            par.Active = chkActive.Checked
            par.UserID = drpCSR.SelectedValue 
      par.Save(strChangeLog)
      Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim strIp As String = Request.QueryString("REMOTE_ADDR")
      Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
      If IsNothing(strIp) Then
        strIp = "unknown"
      End If
      If IsNothing(strType) Then
        strType = "web"
      End If
      act.Add(Master.UserID, "web", strType, strIp, Master.WebLoginID.ToString, par.ActionObjectID, par.PartnerID, strChangeLog)
      Response.Redirect(lblReturnUrl.Text, True)
    Else
      divErrors.Visible = True
    End If
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  Private Sub LoadCSRs()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSimpleDropDownList("spListUsersCallCenter", "UserName", "UserID",drpCSR)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div class="errorzone" id="divErrors" runat="server" visible="false" />
    <div id="divError" runat="server" visible="false" class="errorzone" />
    <div class="resumesectionheader">Metrics</div>
    <div style="font-weight:bold; font-style:italic;">Active<asp:CheckBox ID="chkActive" runat="server" /></div>
    <div style="font-weight:bold;">Assigned Administrator: <asp:DropDownList ID="drpCSR" Runat="server" Visible="True" /></div>
    <div style="font-weight:bold; font-style:italic;">Entity Type*</div>
    <div><asp:DropDownList TabIndex="1" ID="cbxEntityTypes" runat="server" /></div>
    <div>Company Name</div>
    <div><asp:TextBox style="width:99%" TabIndex="2" ID="txtCompanyName" runat="server" /></div>
    <table>
      <tbody>
        <tr>
          <td>
            <div class="label" style="font-style: italic">EIN*</div>
            <div><asp:TextBox TabIndex="5" ID="txtEIN" MaxLength="9"  runat="server" /></div>
          </td>
          <td>
            <div class="label" style="font-style: italic">Confirm EIN* (No Dashes, Numbers Only)</div>
            <div><asp:TextBox TabIndex="6" ID="txtConfirmEIN" MaxLength="9" runat="server" /></div>
          </td>
        </tr>
      </tbody>
    </table>  
    <div class="resumesectionheader">Business Start Date</div>  
    <table>
      <tbody>
        <tr>
          <td class="label">Month</td>
          <td class="label">Year</td>
        </tr>
        <tr>
          <td><asp:DropDownList ID="cbxMonths" TabIndex="2" runat="server" /></td>
          <td><asp:textbox ID="txtYear" MaxLength="4" TabIndex="3" runat="server" /></td>
        </tr>
      </tbody>
    </table>      
    <div class="resumesectionheader">Contact Information</div>
    <div style="font-weight: bold; font-style: italic;">Email Address *</div>
    <div><asp:TextBox style="width: 99%" ID="txtEmail" runat="server" /></div>
    <div>Web Site (url)</div>
    <div><asp:TextBox style="width: 99%" ID="txtWebsite" runat="server" /></div>
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnOK" runat="server" Text="OK" OnClick="btnOK_Click" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>