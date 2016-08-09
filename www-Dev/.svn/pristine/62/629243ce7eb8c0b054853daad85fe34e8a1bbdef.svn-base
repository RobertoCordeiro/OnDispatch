<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<%@ Register Src="~/controls/FirstLastName.ascx" TagName="FirstLastName" TagPrefix="cv" %>
<%@ Register Src="~/controls/BasicPhoneNumber.ascx" TagName="PhoneNumber" TagPrefix="cv" %>
<script runat="server">  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Edit Resume"
      Master.PageTitleText = "Edit Resume"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; Edit Resume"
    End If
    lblReturnUrl.Text = Request.QueryString("returnurl")
    lblResumeID.Text = Request.QueryString("id")
    If lblResumeID.Text.Trim.Length > 0 Then
      If Not IsPostBack Then
        LoadStates(cbxDLStates)
        LoadMonths(cbxMonths)
        LoadReferrers()
        LoadTimeBoxes()
        LoadEntityTypes()
        LoadResumeTypes()
        LoadCSRs ()
        LoadResume(CType(lblResumeID.Text, Long))
      End If
    Else
      Response.Redirect(lblReturnUrl.Text)
    End If
  End Sub
  
  Private Sub LoadResume(ByVal lngResumeID As Long)
    Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim sec As New cvCommon.Security
    rsm.Load(lngResumeID)
    If rsm.EIN.Trim.Length > 0 Then
      txtEIN.Text = sec.GDecypher2(rsm.EIN)
      txtConfirmEIN.Text = sec.GDecypher2(rsm.EIN)
    End If
    If rsm.SSN.Trim.Length > 0 Then
      txtSSN.Text = sec.GDecypher2(rsm.SSN)
      txtConfirmSSN.Text = sec.GDecypher2(rsm.SSN)
    End If
    If rsm.DLNumber.Trim.Length > 0 Then
      txtDLNumber.Text = sec.GDecypher2(rsm.DLNumber)
    End If
    If drpCSR.SelectedValue.Length.ToString > 0 then
      drpCSR.SelectedValue = rsm.userID
    end if
    cbxMonths.SelectedValue = rsm.BusinessStartedMonthID
    txtYear.Text = rsm.BusinessStartedYear
    cbxDLStates.SelectedValue = rsm.DLStateID
    cbxEntityTypes.SelectedValue = rsm.EntityTypeID
    txtCompanyName.Text = rsm.CompanyName
    flnContact.FirstName = rsm.FirstName
    flnContact.MI = rsm.MiddleName
    radICL.SelectedValue = rsm.ConfidenceLevel
    flnContact.LastName = rsm.LastName
    fnlEmergency.LastName = rsm.EmergencyLastName
    fnlEmergency.MI = rsm.EmergencyMiddleName
    fnlEmergency.FirstName = rsm.EmergencyFirstName
    phnEmergency.Exchange = rsm.EmergencyExchange
    phnEmergency.AreaCode = rsm.EmergencyAreaCode
    phnEmergency.LineNumber = rsm.EmergencyLineNumber
    txtResume.Text = rsm.ResumeText
    txtEmail.Text = rsm.Email
    txtWebsite.Text = rsm.WebSite
    cbxResumeTypes.SelectedValue = rsm.ResumeTypeID
    chkSunday.Checked = rsm.ContactSunday
    chkMonday.Checked = rsm.ContactMonday
    chkTuesday.Checked = rsm.ContactTuesday
    chkWednesday.Checked = rsm.ContactWednesday
    chkThursday.Checked = rsm.ContactThursday
    chkFriday.Checked = rsm.ContactFriday
    chkSaturday.Checked = rsm.ContactSaturday
    cbxStart.SelectedValue = rsm.ContactStart
    cbxEnd.SelectedValue = rsm.ContactEnd
    cbxReferrers.SelectedValue = rsm.ReferrerID
    txtReferrerOther.Text = rsm.ReferrerOther
  End Sub

  Private Sub SaveResume(ByVal lngResumeID As Long)
    Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim sec As New cvCommon.Security
    Dim rnt As New BridgesInterface.ResumeNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strChangeLog As String = ""
    rsm.Load(lngResumeID)
    If (txtCompanyName.Text.Trim <> rsm.CompanyName) Or (cbxEntityTypes.SelectedValue <> rsm.EntityTypeID) Then
      rsm.BlankContractFileID = 0
      rsm.BlankWaiverFileID = 0
      rsm.BlankNDAFileID = 0
      rsm.SignedContractFileID = 0
      rsm.SignedNDAFileID = 0
      rsm.SignedWaiverFileID = 0
      rsm.DocumentsApproved = False
      rnt.Add(rsm.ResumeID, Master.UserID, "DOCUMENTS INVALIDATED!: Company Name or Entity Type Changed, Please resend documents to prospective partner")
    End If
    If txtYear.Text.Trim.Length > 0 Then
      rsm.BusinessStartedYear = CType(txtYear.Text, Integer)
    Else
      rsm.BusinessStartedYear = 0
    End If
    rsm.BusinessStartedMonthID = cbxMonths.SelectedValue
    If txtEIN.Text.Trim.Length > 0 Then
      rsm.EIN = sec.GCypher2(txtEIN.Text.Trim)
    Else
      rsm.EIN = ""
    End If
    If txtSSN.Text.Trim.Length > 0 Then
      rsm.SSN = sec.GCypher2(txtSSN.Text.Trim)
    Else
      rsm.SSN = ""
    End If
    If txtDLNumber.Text.Trim.Length > 0 Then
      rsm.DLNumber = sec.GCypher2(txtDLNumber.Text.Trim)
    Else
      rsm.DLNumber = ""
    End If
    rsm.ConfidenceLevel = CType(radICL.SelectedValue, Long)
    rsm.ResumeText = txtResume.Text
    rsm.DLStateID = cbxDLStates.SelectedValue
    rsm.EntityTypeID = cbxEntityTypes.SelectedValue
    rsm.CompanyName = txtCompanyName.Text
    rsm.EmergencyAreaCode = phnEmergency.AreaCode
    rsm.EmergencyLineNumber = phnEmergency.LineNumber
    rsm.EmergencyExchange = phnEmergency.Exchange
    rsm.EmergencyLastName = fnlEmergency.LastName
    rsm.EmergencyFirstName = fnlEmergency.FirstName
    rsm.EmergencyMiddleName = fnlEmergency.MI
    rsm.FirstName = flnContact.FirstName
    rsm.MiddleName = flnContact.MI
    rsm.LastName = flnContact.LastName
    rsm.Email = txtEmail.Text
    rsm.WebSite = txtWebsite.Text
    rsm.ContactSunday = chkSunday.Checked
    rsm.ContactMonday = chkMonday.Checked
    rsm.ContactTuesday = chkTuesday.Checked
    rsm.ContactWednesday = chkSaturday.Checked
    rsm.ContactThursday = chkThursday.Checked
    rsm.ContactFriday = chkFriday.Checked
    rsm.ContactSaturday = chkSaturday.Checked
    rsm.ContactStart = cbxStart.SelectedValue
    rsm.ContactEnd = cbxEnd.SelectedValue
    rsm.ReferrerID = cbxReferrers.SelectedValue
    rsm.ResumeTypeID = CType(cbxResumeTypes.SelectedValue, Long)
    rsm.ReferrerOther = txtReferrerOther.Text
    If drpCSR.SelectedValue <> "CSR All" then
      rsm.UserID = drpCSR.SelectedValue 
    end if
    rsm.Save(strChangeLog)
    Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strIp As String = Request.QueryString("REMOTE_ADDR")
    If IsNothing(strIp) Then
      strIp = "unknown"
    End If
    act.Add(Master.UserID, "web", "web", strIp, "web", 23, rsm.ResumeID, strChangeLog)
  End Sub
  
  Private Sub btnSubmit_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      divError.Visible = False
      SaveResume(CType(lblResumeID.Text, Long))
      Response.Redirect(lblReturnUrl.Text, True)
    Else
      divError.Visible = True
    End If
  End Sub

  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim lngID As Long = 0
    Dim lng As Long = 0
    Dim strError As String = "<ul>"
    If txtEIN.Text.Trim <> txtConfirmEIN.Text.Trim Then
      strError &= "<li>EINs Do Not Match</li>"
      blnReturn = False
    End If
    If txtSSN.Text.Trim <> txtConfirmSSN.Text.Trim Then
      strError &= "<li>SSNs Do Not Match</li>"
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
    If txtSSN.Text.Trim.Length > 0 Then
      If txtSSN.Text.Trim.Length <> 9 Then
        strError &= "<li>SSN Must Be 9 Digits</li>"
        blnReturn = False
      End If
      If Not Long.TryParse(txtSSN.Text, lngID) Then
        strError &= "<li>SSN Requires Numbers Only</li>"
        blnReturn = False
      End If
    End If
    'If txtEIN.Text.Trim.Length + txtSSN.Text.Trim.Length > 0 Then
    '  If txtEIN.Text.Trim.ToLower = txtSSN.Text.Trim.ToLower Then
    '    strError &= "<li>SSN and EIN Can Not Be The Same</li>"
    '    blnReturn = False
    '  End If
    'End If
    If txtResume.Text.Trim.Length = 0 Then
      blnReturn = False
      strError &= "<li>Resume Is Required</li>"
    End If
    If flnContact.FirstName.Trim.Length = 0 Then
      blnReturn = False
      strError &= "<li>" & "First Name is Required" & "</li>"
    End If
    If flnContact.LastName.Trim.Length = 0 Then
      blnReturn = False
      strError &= "<li>" & "Last Name is Required" & "</li>"
    End If
    If txtEmail.Text.Trim.Length = 0 Then
      blnReturn = False
      strError &= "<li>" & "Email is Required" & "</li>"
    End If
    Dim intDayCount As Integer = 0
    If chkSunday.Checked Then
      intDayCount += 1
    End If
    If chkMonday.Checked Then
      intDayCount += 1
    End If
    If chkTuesday.Checked Then
      intDayCount += 1
    End If
    If chkWednesday.Checked Then
      intDayCount += 1
    End If
    If chkThursday.Checked Then
      intDayCount += 1
    End If
    If chkFriday.Checked Then
      intDayCount += 1
    End If
    If chkSaturday.Checked Then
      intDayCount += 1
    End If
    If intDayCount = 0 Then
      blnReturn = False
      strError &= "<li>You Must Choose at Least One Day That You Are Available For Contact</li>"
    End If
    If CType(cbxStart.SelectedValue, Long) > CType(cbxEnd.SelectedValue, Long) Then
      blnReturn = False
      strError &= "<li>Contact Window Start Must Be Less Than Its End</li>"
    End If
    If CType(cbxStart.SelectedValue, Long) + CType(cbxEnd.SelectedValue, Long) = 0 Then
      blnReturn = False
      strError &= "<li>Contact Window Must Be Set (Please choose two different times)</li>"
    End If
    If Not Long.TryParse(txtYear.Text, lng) Then
      blnReturn = False
      strError &= "<li>Business Start Year Must Be A While Number</li>"
    End If  
    If drpCSR.SelectedValue = "CSR All" then
      blnReturn = False
      strError &= "<li>You must assign a Recruiter to this Resume.</li>"
    end if  
    strError &= "</ul>"
    divError.InnerHtml = strError
    Return blnReturn
  End Function

  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
  Private Sub LoadTimeBoxes()
    StuffTimeBox(cbxStart)
    StuffTimeBox(cbxEnd)
  End Sub
  
  Private Sub StuffTimeBox(ByRef cbx As DropDownList)
    cbx.Items.Clear()
    Dim itm As ListItem
    For X As Integer = 0 To 24
      itm = New ListItem
      itm.Value = X
      itm.Text = X.ToString("00") & ":00"
      cbx.Items.Add(itm)
    Next
  End Sub
  
  Private Sub LoadReferrers()
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListResumeReferrers")
    Dim itm As ListItem
    cmd.CommandType = Data.CommandType.StoredProcedure
    cnn.Open()
    cmd.Connection = cnn
    Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
    cbxReferrers.Items.Clear()
    While dtr.Read
      itm = New ListItem
      itm.Text = dtr("Referrer").ToString
      itm.Value = dtr("ReferrerID")
      cbxReferrers.Items.Add(itm)
    End While
    cnn.Close()
  End Sub

  Private Sub LoadResumeTypes()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDropDownList("spListResumeTypes", "ResumeType", "ResumeTypeID", cbxResumeTypes)
  End Sub
  
  Private Sub LoadEntityTypes()
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListEntityTypes")
    Dim itm As ListItem
    cmd.CommandType = Data.CommandType.StoredProcedure
    cnn.Open()
    cmd.Connection = cnn
    Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
    cbxEntityTypes.Items.Clear()
    While dtr.Read
      itm = New ListItem
      itm.Text = dtr("EntityType")
      itm.Value = dtr("EntityTypeID")
      cbxEntityTypes.Items.Add(itm)
    End While
    cnn.Close()
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
  
  ''' <summary>
  ''' Loads the states into the appropriate combo
  ''' </summary>
  Private Sub LoadStates(ByRef cbx As System.Web.UI.WebControls.DropDownList)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListStates")
    Dim itm As ListItem
    Dim lngSelectedValue As Long = 0
    If Long.TryParse(cbx.SelectedValue, lngSelectedValue) Then
      lngSelectedValue = CType(cbx.SelectedValue, Long)
    End If
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
      itm.Text = dtr("StateName")
      itm.Value = dtr("StateID")
      cbx.Items.Add(itm)
    End While
    If lngSelectedValue > 0 Then
      cbx.SelectedValue = lngSelectedValue.ToString
    End If
    cnn.Close()
  End Sub
  Private Sub LoadCSRs()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        ldr.LoadSimpleDropDownList("spListUsersRecruiter", "UserName", "UserID",drpCSR)
        'ldr.LoadSingleLongParameterDropDownList("spListUsersCallCenter", "@TicketFolderID", 7, "Login", "PartnerID", drpPartners)
        drpCSR.Items.Add("CSR All")
        drpCSR.SelectedValue = "CSR All"
    End Sub  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div id="divError" runat="server" visible="false" class="errorzone" />
    <div class="resumesectionheader">Metrics</div>
    <div style="font-weight:bold; font-style:italic;">Entity Type*</div>
    <div><asp:DropDownList TabIndex="1" ID="cbxEntityTypes" runat="server" />&nbsp;&nbsp;<asp:DropDownList ID="drpCSR" runat="server" /></div>
    <div>Company Name</div>
    <div><asp:TextBox style="width:99%" TabIndex="2" ID="txtCompanyName" runat="server" /></div>
    <table>
      <tbody>
        <tr>
          <td class="label" style="font-style: italic">DL State *</td>
          <td class="label" style="font-style: italic">Drivers License Number *</td>
        </tr>
        <tr>
          <td><asp:DropDownList TabIndex="3" ID="cbxDLStates" runat="server" /></td>
          <td><asp:TextBox TabIndex="4" ID="txtDLNumber" runat="server" /></td>
        </tr>
        <tr>
          <td>
            <div class="label" style="font-style: italic">EIN*</div>
            <div><asp:TextBox TabIndex="5" ID="txtEIN" MaxLength="9"  runat="server" /></div>
            <div class="label" style="font-style: italic">SSN*</div>
            <div><asp:TextBox TabIndex="7" ID="txtSSN" MaxLength="9" runat="server" /></div>
          </td>
          <td>
            <div class="label" style="font-style: italic">Confirm EIN* (No Dashes, Numbers Only)</div>
            <div><asp:TextBox TabIndex="6" ID="txtConfirmEIN" MaxLength="9" runat="server" /></div>
            <div class="label" style="font-style: italic">Confirm SSN* (No Dashes, Numbers Only)</div>
            <div><asp:TextBox TabIndex="8" ID="txtConfirmSSN" MaxLength="9" runat="server" /></div>
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
    <cv:FirstLastName FirstNameRequired="true" LastNameRequired="true" runat="server" ID="flnContact" />
    <div style="font-weight: bold; font-style: italic;">Email Address *</div>
    <div><asp:TextBox style="width: 99%" ID="txtEmail" runat="server" /></div>
    <div>Web Site (url)</div>
    <div><asp:TextBox style="width: 99%" ID="txtWebsite" runat="server" /></div>
    <div class="resumesectionheader">Emergency Contact</div>
    <cv:FirstLastName ID="fnlEmergency" runat="server" />
    <cv:PhoneNumber ID="phnEmergency" Text="Emergency Number" runat="server" />
    <div class="resumesectionheader">Initial Confidence Level</div>
    <asp:RadioButtonList ID="radICL" runat="server" RepeatDirection="Horizontal">
      <asp:ListItem Text="0" Value="0" />
      <asp:ListItem text="1" Value="1" />
      <asp:ListItem text="2" Value="2" />
      <asp:ListItem Text="3" Value="3" />
      <asp:ListItem Text="4" Value="4" />
      <asp:ListItem Text="5" Value="5" />      
    </asp:RadioButtonList>
    <div class="resumesectionheader">Information</div>
    <div class="label">Applied For</div>
    <div><asp:DropDownList ID="cbxResumeTypes" runat="server" /></div>
    <div class="label">Resume</div>
    <asp:TextBox ID="txtResume" runat="server" TextMode="multiline" style="height: 200px; width: 600px;" />
    <div class="resumesectionheader">Scheduling</div>
    <div style="font-weight:bold; font-style:italic;">Best Day(s) to Contact *</div>
    <div>
      <asp:CheckBox ID="chkSunday" runat="server" Text="Sun" />
      <asp:CheckBox ID="chkMonday" runat="server" Text="Mon" />
      <asp:CheckBox ID="chkTuesday" runat="server" Text="Tue" />
      <asp:CheckBox ID="chkWednesday" runat="server" Text="Wed" />
      <asp:CheckBox ID="chkThursday" runat="server" Text="Thr" />
      <asp:CheckBox ID="chkFriday" runat="server" Text="Fri" />
      <asp:CheckBox ID="chkSaturday" runat="server" Text="Sat" />
    </div>
    <div style="font-weight:bold; font-style:italic;">Between *</div>
    <div><asp:DropDownList ID="cbxStart" runat="server" /> and <asp:DropDownList ID="cbxEnd" runat="server" /></div>
    <div class="resumesectionheader">Reference</div>
    <div style="font-weight: bold; font-style: italic">How did you hear about us?</div>
    <div><asp:DropDownList ID="cbxReferrers" runat="server" /></div>
    <div>Which One?</div>
    <div><asp:TextBox ID="txtReferrerOther" runat="server" /></div>
    <div>&nbsp;</div>
    <div style="text-align: right;"><asp:Button ID="btnCancel" OnClick="btnCancel_Click" Text="Cancel" runat="server" />&nbsp;<asp:button ID="btnSubmit" text="Update" runat="server" onclick="btnSubmit_Click" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
    <asp:Label ID="lblResumeID" Visible="false" runat="server" />    
  </form>
</asp:Content>