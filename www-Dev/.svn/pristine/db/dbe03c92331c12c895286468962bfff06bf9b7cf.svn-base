<%@ Page Language="VB" masterpagefile="~/masters/cust.master"%>
<%@ MasterType VirtualPath="~/masters/cust.master" %>
<%@ Register Src="~/controls/FirstLastName.ascx" TagName="FirstLastName" TagPrefix="cv" %>
<%@ Register Src="~/controls/Address.ascx" TagName="Address" TagPrefix="cv" %>
<%@ Register Src="~/controls/PhoneNumber.ascx" TagName="Phone" TagPrefix="cv" %>
<%@ Register Src="~/controls/TicketComponent.ascx" TagName="Component" TagPrefix="cv" %>
<script language="VB" runat="server">
  Private Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Dim lgn As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim strMode As String = ""
      If CType(Request.QueryString("mode"), String) <> "" Then
        strMode = Request.QueryString("mode")
      End If
      Dim strHeaderText As String = "Add Ticket"
      lgn.Load(CType(User.Identity.Name, Long))
      If lgn.WebLoginID > 0 Then  
        Master.WebLoginID = lgn.WebLoginID
        'Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("CompanyName") & " Client Access [Add Ticket]"
        'Master.PageHeaderText = strHeaderText
        LoadReferenceLabels()
        lblReturnUrl.Text = "tickets.aspx"
        If AllowedToAdd() Then
          divNoAccess.Visible = False
          divForm.Visible = True
          If Not IsPostBack Then
            LoadReferenceLabels()
            chkAutoPopulate.Checked = True
            LoadWarrantyTerms()
            LoadServiceTypes()
            LoadServices()
            LoadPriorities()
          End If
        Else
          divNoAccess.Visible = True
          divForm.Visible = False
        End If
      Else
        Response.Redirect("/login.aspx", True)
      End If
    Else
      Response.Redirect("/login.aspx", True)
    End If
  End Sub
  
  Private Function AllowedToAdd() As Boolean
    Dim blnReturn As Boolean = True
    Dim cag As New BridgesInterface.CustomerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    cag.Load(Master.CustomerAgentID)
    If cag.AddAbleServiceTypeCount = 0 Then
      blnReturn = False
    End If
    Return blnReturn
  End Function
  
  Private Sub LoadReferenceLabels()
    Dim cst As New BridgesInterface.CustomerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    cst.Load(Master.CustomerID)
    If cst.Ref1Label.Trim.Length > 0 Then
      lblRef1Label.Text = cst.Ref1Label
    Else
      lblRef1Label.Text = "Reference # 1 *"
    End If
    If cst.Ref2Label.Trim.Length > 0 Then
      lblRef2Label.Text = cst.Ref2Label
    Else
      lblRef2Label.Text = "Reference # 2 * (Must be unique)"
    End If
    If cst.Ref3Label.Trim.Length > 0 Then
      lblRef3Label.Text = cst.Ref3Label
    Else
      lblRef3Label.Text = "Reference # 3"
    End If
    If cst.Ref4Label.Trim.Length > 0 Then
      lblRef4Label.Text = cst.Ref4Label
    Else
      lblRef4Label.Text = "Reference # 4"
    End If
  End Sub
  
  Private Sub LoadPriorities()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDropDownList("spListPriorities", "Description", "PriorityID", cbxPriority)
  End Sub
  
  Private Sub LoadServiceTypes()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDropDownList("spListAddableCustomerAgentServiceTypes", "@CustomerAgentID", Master.CustomerAgentID, "ServiceType", "ServiceTypeID", cbxServiceTypes)
    If cbxServiceTypes.Items.Count > 0 Then
      LoadServices()
      LoadManufacturers(CType(cbxServiceTypes.SelectedValue, Long))
    Else
      AddOtherItem(cbxManufacturer)
    End If
  End Sub
  
  Private Sub ServiceTypeChanged(ByVal S As Object, ByVal E As EventArgs)
    LoadServices()
    LoadManufacturers(CType(cbxServiceTypes.SelectedValue, Long))
  End Sub
  
  Private Sub LoadServices()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDropDownList("spListServices", "@ServiceTypeID", cbxServiceTypes.SelectedValue, "ServiceName", "ServiceID", cbxService)
    If cbxService.Items.Count > 0 Then
      PopDescriptionAndInstructions(cbxService.SelectedValue)
    End If
  End Sub
  
  Private Sub LoadManufacturers(ByVal lngID As Long)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDropDownList("spListServiceTypeManufacturers", "@ServiceTypeID", lngID, "Manufacturer", "ManufacturerID", cbxManufacturer)
    AddOtherItem(cbxManufacturer)
    If CType(cbxManufacturer.SelectedValue, Long) <> 0 Then
      txtManufacturer.Text = cbxManufacturer.SelectedItem.Text
      LoadModels(cbxManufacturer.SelectedValue)
    Else
      cbxModel.Items.Clear()
      AddOtherItem(cbxModel)
      txtManufacturer.Text = "Other"
      txtModel.Text = "Other"
    End If
  End Sub
  
  Private Sub LoadModels(ByVal lngID As Long)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDropDownList("spListModels", "@ManufacturerID", lngID, "ModelName", "ModelID", cbxModel)
    AddOtherItem(cbxModel)
    If chkAutoPopulate.Checked Then
      If cbxModel.Items.Count > 0 Then
        PopModel(CType(cbxModel.SelectedValue, Long))
      Else
        txtModel.Text = "Other"
      End If
    End If
  End Sub
  
  Private Sub LoadWarrantyTerms()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDropDownList("spListWarrantyTerms", "Term", "WarrantyTermID", cbxWarrantyTerm)
  End Sub
  
  Private Sub AddOtherItem(ByRef drp As DropDownList)
    Dim itm As New ListItem
    itm.Value = 0
    itm.Text = "Other"
    drp.Items.Add(itm)
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    Dim dat As Date
    Dim val As New cvCommon.Validators
    Dim zip As New BridgesInterface.ZipCodeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    If fnl.FirstName.Trim.Length + fnl.LastName.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li> Name is Required</li>"
    End If
    If txtEmail.Text.Trim.Length > 0 Then
      If Not val.IsValidEmail(txtEmail.Text) Then
        blnReturn = False
        strErrors &= "<li>Email does not appear to be valid</li>"
      End If
    End If
    If add.Street.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Street is a Required Field</li>"
    End If
    If add.Zip.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Zip Code is Required</li>"
    End If
    If add.City.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>City is Required</li>"
    Else
      zip.Load(add.Zip)
      If zip.ZipCodeID = 0 Then
        blnReturn = False
        strErrors &= "<li>Zip Code Not Found</li>"
      End If
    End If
    If phn1.AreaCode.Trim.Length + phn1.Exchange.Trim.Length + phn1.LineNumber.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Primary Phone Number is Required</li>"
    End If
    If phn2.AreaCode.Trim.Length + phn2.Exchange.Trim.Length + phn2.LineNumber.Trim.Length > 0 Then
      If phn2.AreaCode.Trim.Length = 0 Then
        blnReturn = False
        strErrors &= "<li>Secondary Phone Number is Incomplete (Area Code Required)</li>"
      End If
      If phn2.Exchange.Trim.Length = 0 Then
        blnReturn = False
        strErrors &= "<li>Secondary Phone Number is Incomplete (Exchange Required)</li>"
      End If
      If phn2.LineNumber.Trim.Length = 0 Then
        blnReturn = False
        strErrors &= "<li>Secondary Phone Number is Incomplete (Line Number Required)</li>"
      End If
    End If
    If txtRequestedStartDate.Text.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Start Service By Date is Required</li>"
    Else
      If Not DateTime.TryParse(txtRequestedStartDate.Text, dat) Then
        blnReturn = False
        strErrors &= "<li>Start Service By Date is Not a Valid Date</li>"
      End If
    End If
    If txtRequestedEndDate.Text.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>End Service By Date is Required</li>"
    Else
      If Not DateTime.TryParse(txtRequestedEndDate.Text, dat) Then
        blnReturn = False
        strErrors &= "<li>End Service By Date is Not a Valid Date</li>"
      End If
    End If
    If txtWarrantyStart.Text.Trim.Length > 0 Then
      If Not DateTime.TryParse(txtWarrantyStart.Text, dat) Then
        blnReturn = False
        strErrors &= "<li>Warranty Start Date is Not a Valid Date</li>"
      End If
    End If
    If txtWarrantyEnd.Text.Trim.Length > 0 Then
      If Not DateTime.TryParse(txtWarrantyEnd.Text, dat) Then
        blnReturn = False
        strErrors &= "<li>Warranty End Date is Not a Valid Date</li>"
      End If
    End If
    If txtPurchaseDate.Text.Trim.Length > 0 Then
      If Not DateTime.TryParse(txtPurchaseDate.Text, dat) Then
        blnReturn = False
        strErrors &= "<li>Purchase Date is Not a Valid Date</li>"
      End If
    End If
    If txtDescription.Text.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Description of Work to be Performed is Required</li>"
    End If
    If com1.Code.Trim.Length + com1.Component.Trim.Length + com1.SerialNumber.Trim.Length > 0 Then
      If com1.Component.Trim.Length = 0 Then
        blnReturn = False
        strErrors &= "<li>Component Name is Required (Component 1)</li>"
      End If
    End If
    If com2.Code.Trim.Length + com2.Component.Trim.Length + com2.SerialNumber.Trim.Length > 0 Then
      If com2.Component.Trim.Length = 0 Then
        blnReturn = False
        strErrors &= "<li>Component Name is Required (Component 2)</li>"
      End If
    End If
    If com3.Code.Trim.Length + com3.Component.Trim.Length + com3.SerialNumber.Trim.Length > 0 Then
      If com3.Component.Trim.Length = 0 Then
        blnReturn = False
        strErrors &= "<li>Component Name is Required (Component 3)</li>"
      End If
    End If
    If com4.Code.Trim.Length + com4.Component.Trim.Length + com4.SerialNumber.Trim.Length > 0 Then
      If com4.Component.Trim.Length = 0 Then
        blnReturn = False
        strErrors &= "<li>Component Name is Required (Component 4)</li>"
      End If
    End If
    divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
  Private Sub ServiceChanged(ByVal S As Object, ByVal e As EventArgs)
    If cbxService.Items.Count > 0 Then
      If chkAutoPopulate.Checked = True Then
        PopDescriptionAndInstructions(cbxService.SelectedValue)
      End If
    End If
  End Sub

  Private Sub ManufacturerChanged(ByVal S As Object, ByVal E As EventArgs)
    If cbxManufacturer.Items.Count > 0 Then
      If chkAutoPopulate.Checked Then
        PopManufacturer(CType(cbxManufacturer.SelectedValue, Long))
      End If
      LoadModels(CType(cbxManufacturer.SelectedValue, Long))
    End If
  End Sub
  
  Private Sub PopModel(ByVal lngID As Long)
    If lngID > 0 Then
      txtModel.Text = cbxModel.SelectedItem.Text
    Else
      txtModel.Text = "Other"
    End If
  End Sub
  
  Private Sub PopManufacturer(ByVal lngID As Long)
    If lngID > 0 Then
      txtManufacturer.Text = cbxManufacturer.SelectedItem.Text
    Else
      txtManufacturer.Text = "Other"
    End If
  End Sub
  
  Private Sub PopDescriptionAndInstructions(ByVal lngID As Long)
    Dim srv As New BridgesInterface.ServiceRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
    If cbxService.Items.Count > 0 Then
      srv.Load(lngID)
      txtDescription.Text = srv.Description
    End If
  End Sub
    
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub

  Private Sub btnAdd_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      Dim dat As Date
      divErrors.Visible = False
      Dim strChangeLog As String = ""
      Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim srv As New BridgesInterface.ServiceRecord(tkt.ConnectionString)
      Dim phn As New BridgesInterface.TicketPhoneNumberRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      srv.Load(CType(cbxService.SelectedValue, Long))
      tkt.Add(Master.UserID, 1, Master.CustomerID, 1, add.StateID, srv.ServiceID, srv.PayIncrementID, CType(cbxWarrantyTerm.SelectedValue, Long), CType(cbxPriority.SelectedValue, Long), CType(cbxPriority.SelectedValue, Long), srv.MinimumCharge, srv.ChargeRate, srv.AdjustmentCharge, fnl.FirstName, fnl.LastName, add.Street, add.City, add.Zip, txtDescription.Text, CType(txtRequestedStartDate.Text, Date), CType(txtRequestedEndDate.Text, Date))
      tkt.Company = txtCompany.Text
      tkt.ContactMiddleName = fnl.MI.ToCharArray
      tkt.Email = txtEmail.Text
      tkt.Extended = add.Extended
      tkt.SerialNumber = txtSerialNumber.Text
      tkt.ReferenceNumber1 = txtRef1.Text 
      tkt.ReferenceNumber2 = txtRef2.Text 
      tkt.ReferenceNumber3 = txtRef3.Text
      tkt.LaborOnly = chkLaborOnly.Checked
      tkt.ReferenceNumber4 = txtRef4.Text
      tkt.Manufacturer = txtManufacturer.Text
      tkt.Model = txtModel.Text
      If txtWarrantyStart.Text.Trim.Length > 0 Then
        DateTime.TryParse(txtWarrantyStart.Text, dat)
        tkt.WarrantyStart = dat
      Else
        tkt.WarrantyStart = Nothing
      End If
      If txtWarrantyEnd.Text.Trim.Length > 0 Then
        DateTime.TryParse(txtWarrantyEnd.Text, dat)
        tkt.WarrantyEnd = dat
      Else
        tkt.WarrantyEnd = Nothing
      End If
      tkt.Instructions = srv.Instructions
      tkt.Description = srv.Description
      tkt.Notes = txtNotes.Text
      tkt.Save(strChangeLog)
      phn.Add(tkt.TicketID, phn1.PhoneTypeID, Master.UserID, 1, phn1.AreaCode, phn1.Exchange, phn1.LineNumber, True)
      If phn1.Pin.Trim.Length > 0 Then
        phn.Pin = phn1.Pin
      End If
      If phn1.Extension.Trim.Length > 0 Then
        phn.Extension = phn1.Extension
      End If
      phn.Save(strChangeLog)
      If phn2.AreaCode.Trim.Length > 0 Then
        phn.Add(tkt.TicketID, phn2.PhoneTypeID, Master.UserID, 1, phn2.AreaCode, phn2.Exchange, phn2.LineNumber, True)
        If phn2.Pin.Trim.Length > 0 Then
          phn.Pin = phn2.Pin
        End If
        If phn2.Extension.Trim.Length > 0 Then
          phn.Extension = phn2.Extension
        End If
        phn.Save(strChangeLog)
      End If
      Dim com As New BridgesInterface.TicketComponentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim lbl As New BridgesInterface.ShippingLabelRecord(com.ConnectionString)
      If com1.Code.Trim.Length + com1.Component.Trim.Length + com1.SerialNumber.Trim.Length > 0 Then
        com.Add(Master.UserID, tkt.TicketID, com1.Consumable, com1.Component)
        com.Code = com1.Code
        com.SerialNumber = com1.SerialNumber
        com.Notes = com1.Notes
        com.Save(strChangeLog)
        If com1.ShipLabel.Trim.Length > 0 Then
          lbl.Add(Master.UserID, com.TicketComponentID, com1.ShipMethod, 1, com1.ShipLabel)
        End If
        If com1.ReturnLabel.Trim.Length > 0 Then
          lbl.Add(Master.UserID, com.TicketComponentID, com1.ReturnMethod, 2, com1.ReturnMethod)
        End If
      End If
      If com2.Code.Trim.Length + com2.Component.Trim.Length + com2.SerialNumber.Trim.Length > 0 Then
        com.Add(Master.UserID, tkt.TicketID, com2.Consumable, com2.Component)
        com.Code = com2.Code
        com.SerialNumber = com2.SerialNumber
        com.Notes = com2.Notes
        com.Save(strChangeLog)
        If com2.ShipLabel.Trim.Length > 0 Then
          lbl.Add(Master.UserID, com.TicketComponentID, com2.ShipMethod, 1, com2.ShipLabel)
        End If
        If com2.ReturnLabel.Trim.Length > 0 Then
          lbl.Add(Master.UserID, com.TicketComponentID, com2.ReturnMethod, 2, com2.ReturnMethod)
        End If
      End If
      If com3.Code.Trim.Length + com3.Component.Trim.Length + com3.SerialNumber.Trim.Length > 0 Then
        com.Add(Master.UserID, tkt.TicketID, com3.Consumable, com3.Component)
        com.Code = com3.Code
        com.SerialNumber = com3.SerialNumber
        com.Notes = com3.Notes
        com.Save(strChangeLog)
        If com3.ShipLabel.Trim.Length > 0 Then
          lbl.Add(Master.UserID, com.TicketComponentID, com3.ShipMethod, 1, com3.ShipLabel)
        End If
        If com3.ReturnLabel.Trim.Length > 0 Then
          lbl.Add(Master.UserID, com.TicketComponentID, com3.ReturnMethod, 2, com3.ReturnMethod)
        End If
      End If
      If com4.Code.Trim.Length + com4.Component.Trim.Length + com4.SerialNumber.Trim.Length > 0 Then
        com.Add(Master.UserID, tkt.TicketID, com4.Consumable, com4.Component)
        com.Code = com4.Code
        com.SerialNumber = com4.SerialNumber
        com.Notes = com4.Notes
        com.Save(strChangeLog)
        If com4.ShipLabel.Trim.Length > 0 Then
          lbl.Add(Master.UserID, com.TicketComponentID, com4.ShipMethod, 1, com4.ShipLabel)
        End If
        If com4.ReturnLabel.Trim.Length > 0 Then
          lbl.Add(Master.UserID, com.TicketComponentID, com4.ReturnMethod, 2, com4.ReturnMethod)
        End If
      End If
      Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, "Ticket Added to System.")
      tnt.CustomerVisible = True
      tnt.Acknowledged = True
      tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Customer
      tnt.Save(strChangeLog)
      Dim cst As New BridgesInterface.CustomerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      cst.Load(Master.CustomerID)
      If cst.InternalEmail.Trim.Length > 0 Then
        Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
        Dim car As New BridgesInterface.CustomerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        car.Load(Master.CustomerAgentID)
        If car.Email.Trim.Length > 0 Then
          eml.SendFrom = car.Email
        Else
          eml.SendFrom = cst.InternalEmail
        End If
        eml.SendTo = cst.InternalEmail
        eml.Subject = "New Ticket Added " & tkt.TicketID
        eml.Body = "A new ticket was added: <a href=""https://" & System.Configuration.ConfigurationManager.AppSettings("BaseWebsiteAddress") & "/agentinterface/ticket.aspx?id=" & tkt.TicketID & """>" & tkt.TicketID & "</a>"
        eml.BCC = "services@bestservicers.com"
        eml.Send()
      End If
      Response.Redirect("ticket.aspx?id=" & tkt.TicketID.ToString, True)
    Else
      divErrors.Visible = True
    End If
  End Sub
  
  
</script>


<asp:Content ContentPlaceHolderID="bodycontent" runat="server">
 <form id="frmAddTicket" runat="server">
  <div id="divForm" runat="server" visible="true">
    <div class="errorzone" id="divErrors" runat="server" visible="false" />
    <table style="width: 100%">
      <tbody>
        <tr>
          <td style="background-color: #EAEAEA; padding-left: 1px; padding-right: 1px">
            <div class="ticketformsectionheader">Contact</div>
            <div class="label">Company</div>
            <asp:TextBox style="width: 99%" ID="txtCompany" runat="server"  />
            <cv:FirstLastName ID="fnl" runat="server" />
            <div class="label">Email Address</div>
            <asp:TextBox id="txtEmail" runat="server" style="width: 99%" />
            <div>&nbsp;</div>
            <div class="ticketformsectionheader">Address and Phone Numbers</div>
            <cv:Address ID="add" ShowType="false" runat="server" />
            <cv:Phone ID="phn1" Text="Primary Phone" RequirePhone="true" runat="server" />
            <cv:Phone ID="phn2" Text="Secondary Phone" RequirePhone="False" runat="server" />
            <br />
            <div class="ticketformsectionheader">Service&nbsp;<asp:CheckBox ID="chkAutoPopulate" runat="server" Text="Auto Populate" /></div>
            <table>
              <tbody>
                <tr>
                  <td>
                    <div class="label">Type of Service</div>
                    <asp:DropDownList style="width: 170px" ID="cbxServiceTypes" runat="server" OnSelectedIndexChanged="ServiceTypeChanged" AutoPostBack="true" />
                    <div class="label">Service SKU</div>
                    <asp:DropDownList style="width: 99%" ID="cbxService" OnSelectedIndexChanged="ServiceChanged" AutoPostBack="true" runat="server" />            
                  </td>
                  <td>&nbsp;</td>
                  <td>
                    <table border="0" cellpadding="0" cellspacing="0">           
                      <tbody>
                        <tr>
                          <td class="label"><asp:Label ID="lblRef1Label" runat="server" /></td>
                          <td>&nbsp;</td>
                          <td class="label"><asp:Label ID="lblRef2Label" runat="server" /></td>
                        </tr>
                        <tr>
                          <td><asp:textbox ID="txtRef1" runat="server" /></td>                  
                          <td>&nbsp;</td>
                          <td><asp:textbox ID="txtRef2" runat="server" /></td>
                        </tr>
                        <tr>
                          <td class="label"><asp:Label ID="lblRef3Label" runat="server" /></td>                                
                          <td>&nbsp;</td>                  
                          <td class="label"><asp:Label ID="lblRef4Label" runat="server" /></td>
                        </tr>
                        <tr>
                          <td><asp:textbox ID="txtRef3" runat="server" /></td>                  
                          <td>&nbsp;</td>
                          <td><asp:textbox ID="txtRef4" runat="server" /></td>
                        </tr>
                      </tbody>
                    </table>
                  </td>
                </tr>
              </tbody>
            </table>
            <table>
              <tbody>
                <tr>
                  <td class="label">REQ. Start</td>
                  <td>&nbsp;</td>
                  <td class="label">REQ. End</td>
                  <td>&nbsp;</td>
                  <td class="label">Priority</td>
                </tr>
                <tr>
                  <td class="label"><asp:TextBox ID="txtRequestedStartDate" style="Width: 99%" runat="server" /></td>
                  <td>&nbsp;</td>
                  <td class="label"><asp:TextBox ID="txtRequestedEndDate" style="Width: 99%" runat="server" /></td>
                  <td>&nbsp;</td>
                  <td><asp:DropDownList ID="cbxPriority" runat="server" style="width: 150px" /></td>
                </tr>
              </tbody>
            </table> 
            <br />  
            <div class="ticketformsectionheader">Unit</div>
            <table>
              <tr>
                <td class="label">Manufacturer</td>
                <td>&nbsp;</td>
                <td class="label">Manufacturer Desc.</td>
                <td>&nbsp;</td>
                <td class="label">Model</td>
                <td>&nbsp;</td>
                <td class="label">Model Desc.</td>
                <td>&nbsp;</td>
                <td class="label">Serial Number</td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td class="label"><asp:DropDownList ID="cbxManufacturer" AutoPostBack="true" OnSelectedIndexChanged="ManufacturerChanged" runat="server" style="Width: 99%" /></td>
                <td>&nbsp;</td>
                <td class="label"><asp:TextBox ID="txtManufacturer" style="Width: 99%" runat="server" /></td>
                <td>&nbsp;</td>
                <td class="label"><asp:dropdownlist ID="cbxModel" runat="server" style="Width: 99%" /></td>
                <td>&nbsp;</td>
                <td class="label"><asp:TextBox ID="txtModel" runat="server" style="Width: 99%" /></td>
                <td>&nbsp;</td>
                <td class="label"><asp:TextBox ID="txtSerialNumber" runat="server" style="Width: 99%" /></td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td class="label">Warranty Start</td>
                <td>&nbsp;</td>
                <td class="label">Warranty End</td>
                <td>&nbsp;</td>
                <td class="label">Warranty Term</td>
                <td>&nbsp;</td>
                <td class="label">Purchase Date</td>
                <td>&nbsp;</td>
                <td class="label">&nbsp</td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td class="label"><asp:TextBox ID="txtWarrantyStart" style="Width: 99%" runat="server" /></td>
                <td>&nbsp;</td>
                <td class="label"><asp:TextBox ID="txtWarrantyEnd" style="Width: 99%" runat="server" /></td>
                <td>&nbsp;</td>
                <td class="label"><asp:dropdownlist ID="cbxWarrantyTerm" runat="server" style="Width: 99%" /></td>
                <td>&nbsp;</td>
                <td class="label"><asp:TextBox ID="txtPurchaseDate" runat="server" style="Width: 99%" /></td>
                <td>&nbsp;</td>
                <td class="label">&nbsp</td>
                <td>&nbsp;</td>
              </tr>      
            </table>
            <br />    
            <div class="ticketformsectionheader">Information</div>    
            <div visible="false" class="label">On Site Instructions</div>
            <asp:TextBox ReadOnly="true" visible="false" ID="txtDescription" runat="server" style="Width: 99%;" TextMode="multiline" />
            <div class="label">Description Of Work</div>
            <asp:TextBox ID="txtNotes" runat="server" style="Width: 99%" TextMode="multiline" />
          </td>
          <td>&nbsp;</td>
          <td style="width: 1%" visible="false">
            <div class="bandheader"></div>
            <cv:Component ID="com1" runat="server"  Visible="false"/>
            <div class="altrow"><cv:Component ID="com2" runat="server" Visible="false"/></div>
            <cv:Component ID="com3" runat="server" Visible="false"/>
            <div class="altrow"><cv:Component ID="com4" runat="server" Visible="false"/></div>
          </td>
          <td>&nbsp;</td>
        </tr>
      </tbody>
    </table>
        <div style="text-align: right;"><asp:CheckBox ID="chkLaborOnly" runat="server" Text="Labor Only" /></div>
    <div>&nbsp;</div>
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnAdd" runat="Server" Text="Add" OnClick="btnAdd_Click" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
    <asp:Label ID="lblCurrentServiceType" Visible="false" runat="server" />
  </div>
  <div id="divNoAccess" visible="false" runat="server">
    <div>&nbsp;</div>
    <div style="text-align: center">We're sorry, your account does not have sufficient access rights to enter a ticket. Please see your account administrator for further information.</div>
  </div>
 </form>
</asp:Content>