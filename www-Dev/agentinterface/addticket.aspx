<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<%@ Register Src="~/controls/FirstLastName.ascx" TagName="FirstLastName" TagPrefix="cv" %>
<%@ Register Src="~/controls/Address.ascx" TagName="Address" TagPrefix="cv" %>
<%@ Register Src="~/controls/PhoneNumber.ascx" TagName="Phone" TagPrefix="cv" %>
<%@ Register Src="~/controls/TicketComponent.ascx" TagName="Component" TagPrefix="cv" %>

<script runat="server"> 
  
  Private _ID As Long = 0
    Private _TicketID As Long = 0
    Private _infoID As Long = 0
    
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Add Ticket"
      Master.PageTitleText = " Add Ticket"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""customers.aspx"">Customers</a> &gt; Add Ticket"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
        End Try
        Try
            _infoID = CType(Request.QueryString("infoID"), Long)
        Catch ex As Exception
            _infoID = 0
        End Try
        Try
            _TicketID = CType(Request.QueryString("tid"), Long)
        Catch ex As Exception
            _TicketID = 0
        End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
        If _ID > 0 Then
          
            If Master.InfoID <> _infoID Then
                 Response.Redirect("/logout.aspx")
            End If
            If Not IsPostBack Then
                LoadReferenceLabels()
                chkAutoPopulate.Checked = True
                LoadWarrantyTerms()
                LoadServiceTypes()
                LoadServices()
                LoadPriorities()
                If _TicketID > 0 Then
                    LoadPriorTicketInfo(_TicketID)
                End If
            End If
        Else
            Response.Redirect(lblReturnUrl.Text, True)
        End If
  End Sub

  Private Sub LoadReferenceLabels()
    Dim cst As New BridgesInterface.CustomerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    cst.Load(_ID)
    If cst.Ref1Label.Trim.Length > 0 Then
      lblRef1Label.Text = cst.Ref1Label
    Else
      lblRef1Label.Text = "Reference # 1"
    End If
    If cst.Ref2Label.Trim.Length > 0 Then
      lblRef2Label.Text = cst.Ref2Label
    Else
      lblRef2Label.Text = "Reference # 2"
    End If
    If cst.Ref3Label.Trim.Length > 0 Then
            lblRef3Label.Text = cst.Ref3Label
    Else
            lblRef3Label.Text = "Reference # 3"
    End If
    If cst.Ref4Label.Trim.Length > 0 Then
            lblRef4Label.Text = cst.Ref3Label
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
    ldr.LoadSingleLongParameterDropDownList("spListServiceTypes", "@CustomerID", _ID, "ServiceType", "ServiceTypeID", cbxServiceTypes)
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
        If cbxServiceTypes.Items.Count > 0 Then
            PopLayerID(cbxServiceTypes.SelectedValue)
        End If
    End Sub
  
    Private Sub PopLayerID(ByVal lngID As Long)
        Dim srv As New BridgesInterface.ServiceTypeRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
        If cbxServiceTypes.Items.Count > 0 Then
            srv.Load(lngID)
            txtLayerID.Text = srv.LayerID
        End If
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
    If fnl.FirstName.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li> First Name is Required</li>"
    End If
    If fnl.LastName.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li> Last Name is Required</li>"
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
            txtFlatRate.Text = srv.FlatRate
            txtHourly.Text = srv.ChargeRate
            txtMinTime.Text = srv.MinimumCharge
            txtIncrement.Text = srv.PayIncrementID
    End If
  End Sub
    
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub

  Private Sub btnAdd_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
            If IsDuplicate(_ID, txtRef2.Text) = 0 Then
                Dim dat As Date
                divErrors.Visible = False
                Dim strChangeLog As String = ""
                Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                Dim srv As New BridgesInterface.ServiceRecord(tkt.ConnectionString)
                Dim phn As New BridgesInterface.TicketPhoneNumberRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                Dim datDateCreated As Date
                Dim lngTotalDays As Long
                
                datDateCreated = Now()
                srv.Load(CType(cbxService.SelectedValue, Long))
                'get datecreated from prior ticket
                If _TicketID > 0 Then
                    tkt.Load(_TicketID)
                    lngTotalDays = DateDiff("d", tkt.DateCreated, Now())
                    If lngTotalDays < 30 Then
                        datDateCreated = tkt.DateCreated
                    End If
                    tkt.Save(strChangeLog)
                End If
                
                'Add new ticket to the system                
                tkt.Add(Master.UserID, Master.UserID, _ID, 1, add.StateID, srv.ServiceID, srv.PayIncrementID, CType(cbxWarrantyTerm.SelectedValue, Long), CType(cbxPriority.SelectedValue, Long), 1, srv.MinimumCharge, srv.ChargeRate, srv.AdjustmentCharge, fnl.FirstName, fnl.LastName, add.Street, add.City, add.Zip, txtDescription.Text, CType(txtRequestedStartDate.Text, Date), CType(txtRequestedEndDate.Text, Date))
                tkt.Company = txtCompany.Text
                tkt.ContactMiddleName = fnl.MI.ToCharArray
                tkt.Email = txtEmail.Text
                tkt.SerialNumber = txtSerialNumber.Text
                tkt.Extended = add.Extended
                tkt.LaborOnly = chkLaborOnly.Checked
                tkt.ReferenceNumber1 = txtRef1.Text
                tkt.ReferenceNumber2 = txtRef2.Text
                tkt.ReferenceNumber3 = txtRef3.Text
                tkt.ReferenceNumber4 = txtRef4.Text
                tkt.Manufacturer = txtManufacturer.Text
                tkt.Model = txtModel.Text
                If _TicketID > 0 Then
                    tkt.ParentID = _TicketID
                End If
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
                If txtPurchaseDate.Text.Trim.Length > 0 Then
                    DateTime.TryParse(txtPurchaseDate.Text, dat)
                    tkt.PurchaseDate = dat
                Else
                    tkt.PurchaseDate = Nothing
                End If

                tkt.Notes = cbxServiceTypes.SelectedItem.ToString & " / " & txtManufacturer.Text & " / " & txtNotes.Text
                tkt.Instructions = srv.Instructions
                tkt.Description = srv.Description
                _TicketID = tkt.TicketID
                tkt.AssignedTo = AssignAgent(LoadClosestPartnerAgents(tkt.ZipCode, 100))
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
                tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                tnt.Save(strChangeLog)
               
                tkt.DateCreated = datDateCreated
                'tkt.Save(strChangeLog)
                
                ' production
                Dim plog As New BridgesInterface.ProductionLogRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                wbl.Load(Master.WebLoginID)
                Dim strUserName As String
                strUserName = wbl.Login
                Dim tst As New BridgesInterface.TicketStatusRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                tst.Load(tkt.TicketStatusID)
                 
                '14 New Ticket Added
                plog.Add(Master.WebLoginID, Now(), 14, "New Ticket has been added to the system - ticket: " & tkt.TicketID)
                
                
                'If drpTicketStatus.SelectedValue <> CType(17, Long) Then
                Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
                eml.Subject = "Production from: " & strUserName
                eml.Body = "New Ticket has been added to the system - ticket: " & tkt.TicketID
                eml.SendFrom = System.Configuration.ConfigurationManager.AppSettings("PartnerSupportEmail")
                eml.SendFrom = strUserName & "@bestservicers.com"
                'eml.SendTo = ptr.Email
                eml.SendTo = "agentproduction@bestservicers.com"
                'eml.CC = "nelson.palavesino@centurionvision.com"
                'eml.cc = "howard.goldman@centurionvision.com"
                eml.Send()
                'End If
                
                
                tkt.Save(strChangeLog)
                
                Response.Redirect(lblReturnUrl.Text, True)
            Else
                divErrors.Visible = True
            End If
            
        Else
            divErrors.Visible = True
        End If
    End Sub
    Private Function IsDuplicate(ByVal lngCustomerID As Long, ByVal strCustomerPO As String) As Integer
        Dim blnReturn As Boolean = True
        Dim strErrors As String = ""
        Dim intTotal As Integer = 0
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spIsDuplicateTicket")
        cmd.Parameters.Add("@CustomerID", Data.SqlDbType.Int).Value = lngCustomerID
        cmd.Parameters.Add("@CustomerPO", Data.SqlDbType.VarChar).Value = strCustomerPO
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            intTotal = dtr("Total")
            If intTotal > 0 Then
                blnReturn = False
                strErrors &= "<li>Duplicate Ticket. ReferenceNumber 2 must be unique.</li>"
                divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
                Return intTotal
            Else
                Return intTotal
            End If
            
        End While
        cnn.Close()
        
    End Function
    Private Sub LoadPriorTicketInfo(ByVal intTicketID As Integer)
        Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim tst As New BridgesInterface.TicketStatusRecord(tkt.ConnectionString)
        Dim stt As New BridgesInterface.StateRecord(tkt.ConnectionString)
        Dim svt As New BridgesInterface.ServiceTypeRecord(tkt.ConnectionString)
        Dim srv As New BridgesInterface.ServiceRecord(tkt.ConnectionString)
        Dim zip As New BridgesInterface.ZipCodeRecord(tkt.ConnectionString)
        Dim wtm As New BridgesInterface.WarrantyTermRecord(tkt.ConnectionString)
        Dim phn As New BridgesInterface.TicketPhoneNumberRecord (tkt.ConnectionString)
        Dim strBlankDateSpacer As String = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
        Dim datNothing As Date = Nothing
        Dim strHtml As String = ""
        Dim lngTotalDays As Long
        Dim strChangeLog As String = ""
        
        tkt.Load(_TicketID)
        stt.Load(tkt.StateID)
        srv.Load(tkt.ServiceID)
        svt.Load(srv.ServiceTypeID)
        wtm.Load(tkt.WarrantyTermID)
        zip.Load(tkt.ZipCode)
        phn.LoadTicketPhones(tkt.TicketID)
        
        txtCompany.Text = tkt.Company
        fnl.FirstName = tkt.ContactFirstName
        fnl.MI = tkt.ContactMiddleName
        fnl.LastName = tkt.ContactLastName
        txtEmail.Text = tkt.Email
        add.Street = tkt.Street
        add.Extended = tkt.Extended
        add.City = tkt.City
        add.StateID = tkt.StateID
        add.Zip = tkt.ZipCode
        phn1.AreaCode = phn.AreaCode
        phn1.Exchange = phn.Exchange
        phn1.Extension = phn.Extension
        phn1.LineNumber = phn.LineNumber
        cbxServiceTypes.SelectedIndex = srv.ServiceTypeID
        cbxService.SelectedIndex = tkt.ServiceID
        txtRef1.Text = tkt.ReferenceNumber1
        txtRef2.Text = tkt.ReferenceNumber2 
        If _TicketID > 0 Then
            tkt.Load(_TicketID)
            lngTotalDays = DateDiff("d", tkt.DateCreated, Now())
            If lngTotalDays < 30 Then
                txtRef3.Text = "RECALL TICKET"
            Else
                txtRef3.Text = tkt.ReferenceNumber3
            End If
            tkt.Save(strChangeLog)
        End If
        
        
        txtRef4.Text = tkt.ReferenceNumber4
        txtRequestedStartDate.Text = Now()
        txtRequestedEndDate.Text = Now()
        txtSerialNumber.Text = tkt.SerialNumber
        txtManufacturer.Text = tkt.Manufacturer
        txtModel.Text = tkt.Model
        chkLaborOnly.Checked = tkt.LaborOnly
        txtWarrantyStart.Text = tkt.WarrantyStart
        txtWarrantyEnd.Text = tkt.WarrantyEnd
        txtPurchaseDate.Text = tkt.PurchaseDate
        txtNotes.Text = tkt.Notes
    End Sub
    
    Private Function GetZipID(ByVal strZip As String) As Long
     
        Dim lngZipCode As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetZipCodeByZipCode")
        cmd.Parameters.Add("@ZipCode", Data.SqlDbType.VarChar).Value = strZip
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            lngZipCode = dtr("ZipCodeID")
        End While
        Return lngZipCode
        cnn.Close()
        
    End Function
    Private Function AssignAgent(ByVal lngPartnerID As Long) As Long
        Dim lngAdminAgent As Long
        Dim par As New BridgesInterface.PartnerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        If lngPartnerID <> 0 Then
            par.Load(lngPartnerID)
            lngAdminAgent = par.UserID
        Else
            'lngAdminAgent = 15 'NELSON
            lngAdminAgent = 118 'NANA
        End If
        Return lngAdminAgent
    End Function
    Private Function LoadClosestPartnerAgents(ByVal strZipCode As String, ByVal lngRadius As Long) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spListClosestPartnerAgentsToZipCodeTop1")
        Dim lngPartnerID As Long
        lngPartnerID = 0
        cmd.Parameters.Add("@ZipCode", Data.SqlDbType.VarChar).Value = strZipCode
        cmd.Parameters.Add("@Radius", Data.SqlDbType.Int).Value = lngRadius
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            lngPartnerID = dtr("PartnerID")
        End While
        Return lngPartnerID
        cnn.Close()
    End Function
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div class="errorzone" id="divErrors" runat="server" visible="false" />
    <table>
      <tbody>
        <tr>
          <td>
            <div class="bandheader">Contact</div>
            <div class="label">Company</div>
            <asp:TextBox style="width: 99%" ID="txtCompany" runat="server"  />
            <cv:FirstLastName ID="fnl" runat="server" />
            <div class="label">Email Address</div>
            <asp:TextBox id="txtEmail" runat="server" style="width: 99%" />
            <div class="bandheader">Addresses and Phone Numbers</div>
            <cv:Address ID="add" ShowType="false" runat="server" />
            <cv:Phone ID="phn1" Text="Primary Phone" RequirePhone="true" runat="server" />
            <cv:Phone ID="phn2" Text="Secondary Phone" RequirePhone="False" runat="server" />
            <div class="bandheader">Service&nbsp;<asp:CheckBox ID="chkAutoPopulate" runat="server" Text="Auto Populate" /></div>
            <table>
              <tbody>
                <tr>
                  <td>
                    <div class="label">Service Type / Group</div>
                    <asp:DropDownList style="width: 170px" ID="cbxServiceTypes" runat="server" OnSelectedIndexChanged="ServiceTypeChanged" AutoPostBack="true" />
                    <asp:textbox ID="txtLayerID" runat="server" visible="False"/>
                    <div class="label">Service</div>
                    <asp:DropDownList style="width: 99%" ID="cbxService" OnSelectedIndexChanged="ServiceChanged" AutoPostBack="true" runat="server" />            
                    <asp:textbox ID="txtFlatRate" runat="server" visible="False"/>
                    <asp:textbox ID="txtHourly" runat="server" visible = "False"/>
                    <asp:textbox ID="txtMinTime" runat="server" visible = "False"/>
                    <asp:textbox ID="txtIncrement" runat="server" visible = "False"/>
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
                  <td class="label">Start Service By</td>
                  <td>&nbsp;</td>
                  <td class="label">End Service By</td>
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
            <div class="bandheader">Unit</div>
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
            <div class="bandheader">Information</div>    
            <div class="label">On Site Instructions</div>
            <asp:TextBox ReadOnly="True" ID="txtDescription" runat="server" style="Width: 99%;" TextMode="multiline" />
            <div class="label">Description Of Work</div>
            <asp:TextBox ID="txtNotes" runat="server" style="Width: 99%" TextMode="multiline" />
          </td>
          <td>&nbsp;</td>
          <td>
            <div class="bandheader"></div>
            <cv:Component ID="com1" runat="server" visible="false"/>
            <div class="altrow"><cv:Component ID="com2" runat="server" visible="false"/></div>
            <cv:Component ID="com3" runat="server" visible="false" />
            <div class="altrow"><cv:Component ID="com4" runat="server" visible="false"/></div>
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
  </form>
</asp:Content>