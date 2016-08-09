<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server">  
  
  Dim _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try    
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Import Partner"
      Master.PageTitleText = "Import Partner"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""recruit.aspx"">Recruitment</a> &gt; Import Partner"
    End If
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If Not IsPostBack Then
      LoadResume(_ID)
      LoadAddresses(_ID)
    End If
  End Sub
  
  Private Sub LoadResume(ByVal lngResumeID As Long)
    Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    rsm.Load(lngResumeID)
    If rsm.ResumeID > 0 Then
      lblName.Text = rsm.CompanyName & " : " & rsm.NameTag
      If Not rsm.IsInFolder(BridgesInterface.ResumeRecord.ResumeSystemFolders.ReadyToImport) Then
        Response.Redirect(lblReturnUrl.Text, True)
      End If
    End If
  End Sub
  
  Private Sub LoadAddresses(ByVal lngResumeID As Long)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListActiveShippingAddressesForResume")
    cmd.CommandType = Data.CommandType.StoredProcedure
    cmd.Parameters.Add("@ResumeID", Data.SqlDbType.Int).Value = lngResumeID
    Dim itm As ListItem
    cnn.Open()
    cmd.Connection = cnn
    Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
    cbxAddresses.Items.Clear()
    While dtr.Read
      itm = New ListItem
      itm.Text = dtr("Street")
      itm.Value = dtr("ResumeAddressID")
      cbxAddresses.Items.Add(itm)
    End While
    cnn.Close()
  End Sub

  Private Sub btnSubmit_Click(ByVal S As Object, ByVal e As EventArgs)
    Dim strTrash As String = ""
    Dim lngID As Long = 0
    Dim sec As New cvCommon.Security
    Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim prt As New BridgesInterface.PartnerRecord(rsm.ConnectionString)
    Dim paa As New BridgesInterface.PartnerAgentAddressAssignmentRecord(rsm.ConnectionString)
    Dim wbl As New BridgesInterface.WebLoginRecord(rsm.ConnectionString)
    Dim pad As New BridgesInterface.PartnerAddressRecord(rsm.ConnectionString)
    Dim prr As New BridgesInterface.PartnerReferenceRateRecord(rsm.ConnectionString)
    Dim pta As New BridgesInterface.PartnerAgentRecord(rsm.ConnectionString)
    Dim ppn As New BridgesInterface.PartnerPhoneNumberRecord(rsm.ConnectionString)
    Dim ppa As New BridgesInterface.PartnerAgentPhoneNumberAssignmentRecord(rsm.ConnectionString)
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListActiveAddressesForResume")
    Dim dtr As System.Data.SqlClient.SqlDataReader
    rsm.Load(_ID)
    If Not rsm.IsInFolder(BridgesInterface.ResumeRecord.ResumeSystemFolders.Completed) Then                
      cmd.CommandType = Data.CommandType.StoredProcedure
      cmd.Parameters.Add("@ResumeID", Data.SqlDbType.Int).Value = _ID
      Dim cnn As New System.Data.SqlClient.SqlConnection(rsm.ConnectionString)
            prt.Add(Master.UserID, rsm.ResumeID, rsm.EntityTypeID, rsm.BusinessStartedMonthID, rsm.BusinessStartedYear, rsm.BlankWaiverFileID, rsm.BlankContractFileID, rsm.BlankNDAFileID, rsm.SignedWaiverFileID, rsm.SignedContractFileID, rsm.SignedNDAFileID, rsm.EIN, rsm.CompanyName, True, Now(), Master.UserID, Master.InfoID)
      prt.Email = rsm.Email      
      If rsm.WebSite.Trim.Length > 0 Then
        prt.WebSite = rsm.WebSite      
      End If
      prt.Save(strTrash)
      cnn.Open()
      cmd.Connection = cnn
      dtr = cmd.ExecuteReader
      While dtr.Read
        pad.Add(prt.PartnerID, Master.UserID, CType(dtr("StateID"), Long), CType(dtr("AddressTypeID"), Long), dtr("Street").ToString, dtr("City").ToString, dtr("ZipCode").ToString)
        If CType(dtr("ResumeAddressID"), Long) = CType(cbxAddresses.SelectedValue, Long) Then
          lngID = pad.PartnerAddressID
        End If
        If Not IsDBNull(dtr("Extended")) Then
          pad.Extended = dtr("Extended").ToString
          pad.Save(strTrash)
        End If
      End While
      cnn.Close()
      pta.Add(prt.PartnerID, 11, Master.UserID, rsm.EmergencyFirstName, rsm.EmergencyLastName)
      If rsm.EmergencyMiddleName.Trim.Length > 0 Then
        pta.MiddleName = rsm.EmergencyMiddleName
        pta.Save(strTrash)
      End If
      ppn.Add(pta.PartnerID, 7, Master.UserID, rsm.EmergencyCountryCode, rsm.EmergencyAreaCode, rsm.EmergencyExchange, rsm.EmergencyLineNumber)
      ppa.Add(Master.UserID, pta.PartnerAgentID, ppn.PartnerPhoneNumberID)
      pta.Add(prt.PartnerID, 6, Master.UserID, rsm.FirstName, rsm.LastName)
      If rsm.MiddleName.Trim.Length > 0 Then
        pta.MiddleName = rsm.MiddleName
      End If
      wbl.Load(rsm.WebLoginID)
      wbl.AccessCoding = "P"      
      wbl.Save(strTrash)
      pta.WebLoginID = wbl.WebLoginID
      pta.AdminAgent = True
      pta.Email = rsm.Email
      pta.SSN = rsm.SSN
      pta.DLNumber = rsm.DLNumber
      pta.DLStateID = rsm.DLStateID
      pta.DLFileID = rsm.DLFileID
      
      pta.Save(strTrash)
      paa.Add(Master.UserID, lngID, pta.PartnerAgentID)
      cmd = New System.Data.SqlClient.SqlCommand("spListActivePhoneNumbersForResume")
      cmd.CommandType = Data.CommandType.StoredProcedure
      cmd.Parameters.Add("@ResumeID", Data.SqlDbType.Int).Value = _ID
      cnn.Open()
      cmd.Connection = cnn
      dtr = cmd.ExecuteReader
      While dtr.Read
        ppn.Add(pta.PartnerID, CType(dtr("PhoneTypeID"), Long), Master.UserID, dtr("CountryCode").ToString, dtr("AreaCode").ToString, dtr("Exchange").ToString, dtr("LineNumber").ToString)
        If Not IsDBNull(dtr("Comment")) Then
          ppn.Comment = dtr("Comment").ToString
        End If
        If Not IsDBNull(dtr("Pin")) Then
          ppn.Pin = dtr("Pin").ToString
        End If
        If Not IsDBNull(dtr("Extension")) Then
          ppn.Extension = dtr("Extension").ToString
        End If
        ppn.Save(strTrash)
        ppa.Add(Master.UserID, pta.PartnerAgentID, ppn.PartnerPhoneNumberID)
      End While
      cnn.Close()
      cmd = New System.Data.SqlClient.SqlCommand("spListResumeRates")
      cmd.CommandType = Data.CommandType.StoredProcedure
      cmd.Parameters.Add("@ResumeID", Data.SqlDbType.Int).Value = _ID
      cnn.Open()
      cmd.Connection = cnn
      dtr = cmd.ExecuteReader
      While dtr.Read
        prr.Add(Master.UserID, prt.PartnerID, CType(dtr("RateTypeID"), Long), CType(dtr("Rate"), Double), CType(dtr("HourlY"), Boolean))
      End While
      SendEmail(prt.ResumeID, "", rsm.Email, rsm.FirstName, rsm.LastName)
      rsm.RemoveFromFolder(34)
      rsm.RemoveFromFolder(25)
      rsm.RemoveFromFolder(26)
      rsm.RemoveFromFolder(27)
      rsm.RemoveFromFolder(28)
      rsm.RemoveFromFolder(29)
      
      cnn.Close()
      
      
      'Load the resume again because this runs the folder code.          
      rsm.Load(_ID)
      Response.Redirect(lblReturnUrl.Text)
    Else
      divErrors.InnerHtml = "<ul><li>This Resume Has Already Been Imported and CAN NOT be imported again</li></ul>"
    End If
  End Sub
  
  Private Sub SendEmail(ByVal strLogin As String, ByVal strPassword As String, ByVal strEmail As String, ByVal strFirstName As String, ByVal strLastName As String)
    Dim doc As New BridgesInterface.DocumentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
    Dim usr As New BridgesInterface.UserRecord(doc.ConnectionString)
    Dim rnt As New BridgesInterface.ResumeNoteRecord(doc.ConnectionString)
    Dim strBody As String = ""
    Dim strLoginPath As String = System.Configuration.ConfigurationManager.AppSettings("LoginFormPath")
    Dim strEmailFrom As String = System.Configuration.ConfigurationManager.AppSettings("RecruiterEmail")
    Dim strArchiveEmail As String = System.Configuration.ConfigurationManager.AppSettings("ArchiveEmail")
    doc.Load(7) ' 6 Is the ID to the Send Documents Email
    usr.Load(Master.UserID)
    strBody = doc.DocumentText
    strBody = strBody.Replace("$firstname", strFirstName)
    strBody = strBody.Replace("$lastname", strLastName)
    strBody = strBody.Replace("$partnerid", strLogin)
    strBody = strBody.Replace("$password", strPassword)
    strBody = strBody.Replace("$link", strLoginPath)
    If usr.Signature.Trim.Length > 0 Then
      strBody = strBody.Replace("$signature", usr.Signature)
    Else
      strBody = strBody.Replace("$signature", usr.FirstName & " " & usr.LastName)
    End If
    eml.BCC = strArchiveEmail
    eml.Subject = "Welcome New Partner! (Partner ID " & strLogin & ")"
    eml.SendTo = strEmail
    eml.SendFrom = strEmailFrom
    eml.Body = strBody
    eml.HTMLBody = True
    eml.Send()
    rnt.Add(_ID, Master.UserID, "Partner Has Been Imported")
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div id="divErrors" class="errorzone" visible="false" runat="server" />
    <div class="label">Importing</div>
    <div><asp:Label ID="lblName" runat="server" /></div>
    <div>&nbsp;</div>
    <div>Once you import this applicant into the system as a partner the following will happen.</div>
    <ul>
      <li>They will be entered into the system as a partner</li>
      <li>Their user name and password will be reset to their new partner login</li>
      <li>They will no longer be able to edit or view their resume</li>
    </ul>
    <div>Are you sure you wish to do this?</div>
    <div class="label">Select Partner's Primary Address</div>
    <asp:DropDownList style="width: 99%" ID="cbxAddresses" runat="server" />
    <div>&nbsp;</div>
    <div style="text-align: right;"><asp:Button ID="btnCancel" Text="Cancel" OnClick="btnCancel_Click" runat="server" /><asp:Button ID="btnSubmit" Text="Import" OnClick="btnSubmit_Click" runat="server" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>