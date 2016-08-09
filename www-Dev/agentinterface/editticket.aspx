<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<%@ Register Src="~/controls/FirstLastName.ascx" TagName="FirstLastName" TagPrefix="cv" %>
<%@ Register Src="~/controls/Address.ascx" TagName="Address" TagPrefix="cv" %>
<%@ Register Src="~/controls/PhoneNumber.ascx" TagName="Phone" TagPrefix="cv" %>
<%@ Register Src="~/controls/TicketComponent.ascx" TagName="Component" TagPrefix="cv" %>
<script runat="server"> 
  
  Private _ID As Long = 0
  Private _statusID as Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Edit Ticket "
      Master.PageTitleText = " Edit Ticket "
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""customers.aspx"">Customers</a> &gt; "
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If _ID > 0 Then
      If Not IsPostBack Then
                LoadStatuses(0)
        LoadReferenceLabels()
        LoadWarrantyTerms()
                LoadPriorities()
                LoadSupportAgents()
                LoadTicket()
                
      End If
    Else
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub

    Private Sub LoadStatuses(ByVal lngProductionOrder As Long)
        'If lngProductionOrder = 0 Then
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSimpleDropDownList("spListTicketStatuses", "Status", "TicketStatusID", drpTicketStatus)
        'Else
        'If CType(User.Identity.Name, Long) = 1652 Or CType(User.Identity.Name, Long) = 1654 Or CType(User.Identity.Name, Long) = 2204 Or CType(User.Identity.Name, Long) = 2204 Then
        '1652 Paulo, 1654 nelson, 3597 Rita,
        'Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        'ldr.LoadSimpleDropDownList("spListTicketStatuses", "Status", "TicketStatusID", drpTicketStatus)
        'Else
        'Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        'ldr.LoadSingleLongParameterDropDownList("spListticketStatusesByProductionOrder", "ProductionOrderID", lngProductionOrder, "Status", "TicketStatusID", drpTicketStatus)
        'End If
        'End If
    
    
    End Sub
    
    Private Sub LoadSupportAgents()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSimpleDropDownList("spListUsersCallCenter", "UserName", "UserID", drpSupportAgent)
        drpSupportAgent.Items.Add("Assign Agent")
        drpSupportAgent.SelectedValue = "Assign Agent"
        
    End Sub
  
  Private Sub LoadTicket()
    Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim srv As New BridgesInterface.ServiceRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim tst As New BridgesInterface.TicketStatusRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim datNothing As Date = Nothing
    tkt.Load(_ID)
    srv.Load(tkt.ServiceID)
        LoadServiceTypes(tkt.CustomerID)
        tst.Load(tkt.TicketStatusID)
    Master.PageSubHeader &= "<a href=""customer.aspx?id=" & tkt.CustomerID & """>Customer</a> &gt; Edit Ticket"
    Master.PageTitleText &= _ID
    Master.PageHeaderText &= _ID
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
        If tkt.TicketStatusID > 0 Then
            LoadStatuses(tst.ProductionOrder)
        End If
        drpTicketStatus.SelectedValue = tkt.TicketStatusID
        _statusID = tkt.TicketStatusID
        drpSupportAgent.SelectedValue = tkt.AssignedTo 
        cbxServiceTypes.SelectedValue = srv.ServiceTypeID  'programs
        LoadCustomers(tkt.CustomerID)
        LoadServices()
        cbxService.SelectedValue = tkt.ServiceID ' Service SKUs
        txtRef1.Text = tkt.ReferenceNumber1
        txtRef2.Text = tkt.ReferenceNumber2
        txtRef3.Text = tkt.ReferenceNumber3
        txtRef4.Text = tkt.ReferenceNumber4
        chkLaborOnly.Checked = tkt.LaborOnly
        txtRequestedStartDate.Text = tkt.RequestedStartDate.ToString
        txtRequestedEndDate.Text = tkt.RequestedEndDate.ToString
        cbxPriority.SelectedValue = tkt.CustomerPrioritySetting
        txtManufacturer.Text = tkt.Manufacturer
        txtModel.Text = tkt.Model
        txtSerialNumber.Text = tkt.SerialNumber
        If tkt.WarrantyStart <> datNothing Then
            txtWarrantyStart.Text = tkt.WarrantyStart.ToString
        End If
        If tkt.WarrantyEnd <> datNothing Then
            txtWarrantyEnd.Text = tkt.WarrantyEnd.ToString
        End If
        cbxWarrantyTerm.SelectedValue = tkt.WarrantyTermID
        If tkt.PurchaseDate <> datNothing Then
            txtPurchaseDate.Text = tkt.PurchaseDate.ToString
        End If
        txtDescription.Text = tkt.Description
        txtNotes.Text = tkt.Notes
    End Sub
  
  Private Sub LoadReferenceLabels()
    Dim cst As New BridgesInterface.CustomerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    If cst.Ref1Label.Trim.Length > 0 Then
      lblRef1Label.Text = cst.Ref1Label
    Else
      lblRef1Label.Text = "Reference # 1"
    End If
    If cst.Ref2Label.Trim.Length > 0 Then
      lblRef2Label.Text = cst.Ref1Label
    Else
      lblRef2Label.Text = "Reference # 2"
    End If
    If cst.Ref3Label.Trim.Length > 0 Then
      lblRef3Label.Text = cst.Ref1Label
    Else
      lblRef3Label.Text = "Reference # 3"
    End If
    If cst.Ref4Label.Trim.Length > 0 Then
      lblRef4Label.Text = cst.Ref1Label
    Else
      lblRef4Label.Text = "Reference # 4"
    End If

  End Sub
  
  Private Sub LoadPriorities()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDropDownList("spListPriorities", "Description", "PriorityID", cbxPriority)
  End Sub
  
  Private Sub LoadServiceTypes(ByVal lngID As Long)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDropDownList("spListServiceTypes", "@CustomerID", lngID, "ServiceType", "ServiceTypeID", cbxServiceTypes)
    If cbxServiceTypes.Items.Count > 0 Then
      LoadServices()
    End If
  End Sub
    Private Sub LoadCustomers(ByVal lngID As Long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSimpleDropDownList("spListActiveCustomers", "Company", "CustomerID", cbxCustomers)
        If cbxCustomers.Items.Count > 0 Then
            cbxCustomers.SelectedValue = lngID
        End If
    End Sub
    Private Sub CustomerChanged(ByVal S As Object, ByVal E As EventArgs)
        LoadServiceTypes(cbxCustomers.SelectedValue)
    End Sub
  
    
  Private Sub ServiceTypeChanged(ByVal S As Object, ByVal E As EventArgs)
    LoadServices()
  End Sub
  
  Private Sub LoadServices()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDropDownList("spListServices", "@ServiceTypeID", cbxServiceTypes.SelectedValue, "ServiceName", "ServiceID", cbxService)
    If cbxService.Items.Count > 0 Then
      PopDescriptionAndInstructions(cbxService.SelectedValue)
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
        
        If CType(drpTicketStatus.SelectedValue, Long) = 4 Or CType(drpTicketStatus.SelectedValue, Long) = 5 Or CType(drpTicketStatus.SelectedValue, Long) = 14 Or CType(drpTicketStatus.SelectedValue, Long) = 16 Or CType(drpTicketStatus.SelectedValue, Long) = 31 Then
            If Not IsTicketOpened(_ID) Then
                blnReturn = False
                strErrors &= "<li>You cannot assign this status to a closed ticket.</li>"
            End If
        End If
        If CType(drpTicketStatus.SelectedValue, Long) = 8 Or CType(drpTicketStatus.SelectedValue, Long) = 9 Or CType(drpTicketStatus.SelectedValue, Long) = 12 Then
            If IsTicketOpened(_ID) Then
                blnReturn = False
                strErrors &= "<li>You cannot chose a Closing status on a open ticket. You have to close the ticket.</li>"
            End If
        End If
        
        divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
        Return blnReturn
  End Function
  
  Private Sub ServiceChanged(ByVal S As Object, ByVal e As EventArgs)
    If cbxService.Items.Count > 0 Then
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

  Private Sub btnEdit_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      Dim dat As Date
      divErrors.Visible = False
      Dim strChangeLog As String = ""
      Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim srv As New BridgesInterface.ServiceRecord(tkt.ConnectionString)
      tkt.Load(_ID)
      srv.Load(CType(cbxService.SelectedValue, Long))
            tkt.StateID = add.StateID
            tkt.CustomerID = CType(cbxCustomers.SelectedValue, Long)
            'tkt.ServiceID = CType(cbxService.SelectedValue, Long)
      tkt.IncrementTypeID = srv.PayIncrementID
      tkt.WarrantyTermID = CType(cbxWarrantyTerm.SelectedValue, Long)
      tkt.CustomerPrioritySetting = CType(cbxPriority.SelectedValue, Integer)
      tkt.InternalPrioritySetting = tkt.CustomerPrioritySetting
      'tkt.MaximumCharge = srv.MinimumCharge
      'tkt.ChargeRate = srv.ChargeRate
      'tkt.AdjustCharge = srv.AdjustmentCharge
      
      tkt.ContactFirstName = fnl.FirstName
      tkt.ContactMiddleName = fnl.MI
      tkt.Description = txtDescription.Text
      tkt.ContactLastName = fnl.LastName
      tkt.Company = txtCompany.Text
      tkt.Street = add.Street
      tkt.City = add.City
      tkt.Extended = add.Extended
      tkt.StateID = add.StateID
      tkt.LaborOnly = chkLaborOnly.Checked
      tkt.ZipCode = add.Zip
      tkt.RequestedStartDate = CType(txtRequestedStartDate.Text, Date)
      tkt.RequestedEndDate = CType(txtRequestedEndDate.Text, Date)
      tkt.ContactMiddleName = fnl.MI.ToCharArray
      tkt.Email = txtEmail.Text
      tkt.Extended = add.Extended
      tkt.ReferenceNumber1 = txtRef1.Text
      tkt.SerialNumber = txtSerialNumber.Text
      tkt.ReferenceNumber2 = txtRef2.Text
      tkt.ReferenceNumber3 = txtRef3.Text
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

      tkt.Notes = txtNotes.Text

      If txtPurchaseDate.Text.Trim.Length > 0 Then
        DateTime.TryParse(txtPurchaseDate.Text, dat)
        tkt.PurchaseDate = dat
      Else
        tkt.PurchaseDate = Nothing
      End If
            Dim lngAgentID As Long
            
            If drpSupportAgent.SelectedValue = "Assign Agent" Then
                lngAgentID = 0
            Else
                lngAgentID = drpSupportAgent.SelectedValue
                 
            End If
            
            If CType(tkt.AssignedTo, Long) <> lngAgentID Then
                tkt.AssignedTo = drpSupportAgent.SelectedValue
                Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, " Auto Note: Ticket Agent Assignment has been changed to: " & drpSupportAgent.SelectedItem.Text)
                tnt.CustomerVisible = False
                tnt.Acknowledged = False
                tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                tnt.Save(strChangeLog)
                
            End If
            
           
            
            
            If CType(tkt.TicketStatusID, Long) = 28 then 'need eu feed back
               if CType(drpTicketStatus.SelectedValue, Long) <> 28 Then
                 removeTicketFromFolder(tkt.ticketID,37)
               end if
            else
               if CType(drpTicketStatus.SelectedValue, Long) = 28 Then
                 Dim fdl As New BridgesInterface.TicketFolderAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                    fdl.Add(1,tkt.TicketID,37)
               end if
            end if
            
            If CType(drpTicketStatus.SelectedValue, Long) = 12 or CType(drpTicketStatus.SelectedValue, Long) = 9 then 'additional service request or cancelled
              If not IsDBNull(tkt.CompletedDate) then
                 UpdatePayableStatus (tkt.TicketID,False)
              end if
            end if
            If CType(tkt.ServiceID, Long) <> CType(cbxService.SelectedValue, Long) Then
                tkt.ServiceID = CType(cbxService.SelectedValue, Long)
                Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, " Auto Note: Ticket SKU has been changed to: " & cbxService.SelectedItem.Text)
                tnt.CustomerVisible = False
                tnt.Acknowledged = False
                tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                tnt.Save(strChangeLog)
            End If
            
            
            ' Production control
            If CType(tkt.TicketStatusID, Long) <> CType(drpTicketStatus.SelectedValue, Long) Then
                Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, " Auto Note: Ticket Status has been changed to: " & drpTicketStatus.SelectedItem.Text)
                tnt.CustomerVisible = False
                tnt.Acknowledged = False
                tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                tnt.Save(strChangeLog)

                'Dim usr As New BridgesInterface.UserRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                'usr.Load(Master.LoginID)
                Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                wbl.Load(Master.WebLoginID)
                Dim strUserName As String
                strUserName = wbl.Login
                Dim tst As New BridgesInterface.TicketStatusRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                tst.Load(tkt.TicketStatusID)
                Dim OldProductionOrder As Integer
                Dim newProductionOrder As Integer
                OldProductionOrder = tst.ProductionOrder
                tst.Load(CType(drpTicketStatus.SelectedValue, Long))
                newProductionOrder = tst.ProductionOrder
                
                Dim plog As New BridgesInterface.ProductionLogRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                plog.Add(Master.WebLoginID, Now(), 4, "The status has been changed to - " & drpTicketStatus.SelectedItem.Text & " - on ticket: " & tkt.TicketID)
                
                'If drpTicketStatus.SelectedValue <> CType(17, Long) Then
                Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
                eml.Subject = "Production from: " & strUserName
                eml.Body = "The status has been changed to - " & drpTicketStatus.SelectedItem.Text & " - on ticket: " & tkt.TicketID
                eml.SendFrom = System.Configuration.ConfigurationManager.AppSettings("PartnerSupportEmail")
                eml.SendFrom = strUserName & "@bestservicers.com"
                'eml.SendTo = ptr.Email
                eml.SendTo = "agentproduction@bestservicers.com"
                'eml.CC = "nelson.palavesino@centurionvision.com"
                'eml.cc = "howard.goldman@centurionvision.com"
                eml.Send()
                'End If
            
                HandleFolders(tkt.TicketID, drpTicketStatus.SelectedValue)
            End If
      
            tkt.TicketStatusID = drpTicketStatus.SelectedValue
      
            'removeTicketFromFolder(tkt.ticketID,4)
 
            tkt.Save(strChangeLog)
            Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            Dim strIp As String = Request.QueryString("REMOTE_ADDR")
            Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
            If IsNothing(strIp) Then
                strIp = "unknown"
            End If
            If IsNothing(strType) Then
                strType = "web"
            End If
            act.Add(2, "web", strType, strIp, Master.WebLoginID, 33, tkt.TicketID, strChangeLog)
            Response.Redirect(lblReturnUrl.Text, True)
        Else
            divErrors.Visible = True
        End If
    End Sub
  Private Sub removeTicketFromFolder(ByVal lngTicketID As Long, ByVal lngFolderID As Long)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spRemoveTicketFromFolder")
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TicketID", Data.SqlDbType.Int).Value = lngTicketID
        cmd.Parameters.Add("@FolderID", Data.SqlDbType.Int).Value = lngFolderID
        cnn.open        
        cmd.Connection = cnn
        
        cmd.ExecuteNonQuery()
        cnn.Close()
  End Sub
  Private Sub HandleFolders(ByVal lngTicketID As Long, ByVal lngFolderID As Long)
        Dim fdl As New BridgesInterface.TicketFolderAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
               
        Select Case lngFolderID 'Ticket StatusID

            Case Is = CType(27, Long), CType(28, Long), CType(30, Long) 'phone support, awaiting eu feed back, need technical feed back
                'Add to folder Phone Support
                fdl.Add(6, lngTicketID, CType(26, Long)) 'phone support folder
                fdl.Add(6, lngTicketID, CType(2, Long)) ' open folder
                removeTicketFromFolder(lngTicketID, CType(29, Long))
                removeTicketFromFolder(lngTicketID, CType(32, Long))
                removeTicketFromFolder(lngTicketID, CType(25, Long))
                removeTicketFromFolder(lngTicketID, CType(30, Long))
                removeTicketFromFolder(lngTicketID, CType(31, Long))
                removeTicketFromFolder(lngTicketID, CType(17, Long))
                removeTicketFromFolder(lngTicketID, CType(33, Long))
            Case Is = CType(29, Long), CType(31, Long), CType(32, Long) 'PONT, NTFT,NTA
                'add to folder Need Tech
                fdl.Add(6, lngTicketID, CType(25, Long))
                fdl.Add(6, lngTicketID, CType(2, Long)) ' add to folder open
                fdl.Add(6, lngTicketID, CType(30, Long)) ' add to need authorization
                fdl.Add(6, lngTicketID, CType(39, Long)) 'PONT folder
                removeTicketFromFolder(lngTicketID, CType(29, Long))
                removeTicketFromFolder(lngTicketID, CType(26, Long))
                'removeTicketFromFolder(lngTicketID, CType(30, Long))
                removeTicketFromFolder(lngTicketID, CType(31, Long))
                removeTicketFromFolder(lngTicketID, CType(17, Long))
                removeTicketFromFolder(lngTicketID, CType(33, Long))
            Case Is = CType(14, Long) ' ORDERING PARTS
                'add to folder ordering parts
                fdl.Add(6, lngTicketID, CType(29, Long))
                fdl.Add(6, lngTicketID, CType(2, Long)) ' add to folder open
                removeTicketFromFolder(lngTicketID, CType(25, Long))
                removeTicketFromFolder(lngTicketID, CType(26, Long))
                removeTicketFromFolder(lngTicketID, CType(30, Long))
                removeTicketFromFolder(lngTicketID, CType(31, Long))
                removeTicketFromFolder(lngTicketID, CType(17, Long))
                removeTicketFromFolder(lngTicketID, CType(33, Long))
            Case Is = CType(26, Long) ' NEED CUSTOMER FEED BACK
                'add to folder cusotmer feed back
                fdl.Add(6, lngTicketID, CType(30, Long))
                fdl.Add(6, lngTicketID, CType(2, Long)) ' add to folder open
                removeTicketFromFolder(lngTicketID, CType(25, Long))
                removeTicketFromFolder(lngTicketID, CType(26, Long))
                removeTicketFromFolder(lngTicketID, CType(29, Long))
                removeTicketFromFolder(lngTicketID, CType(31, Long))
                removeTicketFromFolder(lngTicketID, CType(17, Long))
                removeTicketFromFolder(lngTicketID, CType(33, Long))
            Case Is = CType(16, Long) ' PART ON BACK ORDER
                'add to folder Need Tech
                fdl.Add(6, lngTicketID, CType(31, Long))
                fdl.Add(6, lngTicketID, CType(2, Long)) ' add to folder open
                removeTicketFromFolder(lngTicketID, CType(25, Long))
                removeTicketFromFolder(lngTicketID, CType(26, Long))
                removeTicketFromFolder(lngTicketID, CType(29, Long))
                removeTicketFromFolder(lngTicketID, CType(30, Long))
                removeTicketFromFolder(lngTicketID, CType(17, Long))
                removeTicketFromFolder(lngTicketID, CType(33, Long))
            Case Is = CType(22, Long) ' EXTRA WORK NEE APPROVAL
                'add to folder Need Tech
                fdl.Add(6, lngTicketID, CType(32, Long))
                fdl.Add(6, lngTicketID, CType(2, Long)) ' add to folder open
                removeTicketFromFolder(lngTicketID, CType(25, Long))
                removeTicketFromFolder(lngTicketID, CType(26, Long))
                removeTicketFromFolder(lngTicketID, CType(29, Long))
                removeTicketFromFolder(lngTicketID, CType(30, Long))
                removeTicketFromFolder(lngTicketID, CType(31, Long))
                removeTicketFromFolder(lngTicketID, CType(17, Long))
                removeTicketFromFolder(lngTicketID, CType(33, Long))
            Case Is = CType(11, Long) ' SCHEDULED
                'add to folder Need Tech
                'fdl.Add(6, lngTicketID, CType(33,long))
                fdl.Add(6, lngTicketID, CType(2, Long)) ' add to folder open
                removeTicketFromFolder(lngTicketID, CType(25, Long))
                removeTicketFromFolder(lngTicketID, CType(26, Long))
                removeTicketFromFolder(lngTicketID, CType(29, Long))
                removeTicketFromFolder(lngTicketID, CType(30, Long))
                removeTicketFromFolder(lngTicketID, CType(31, Long))
                removeTicketFromFolder(lngTicketID, CType(32, Long))
                removeTicketFromFolder(lngTicketID, CType(17, Long))
		

            Case Is = CType(17, Long), CType(19, Long) ' NEED APPT SET, READY FOR SERVICE
                'add to folder Need Tech
                fdl.Add(6, lngTicketID, CType(33, Long))
                fdl.Add(6, lngTicketID, CType(2, Long)) ' add to folder open
                removeTicketFromFolder(lngTicketID, CType(25, Long))
                removeTicketFromFolder(lngTicketID, CType(26, Long))
                removeTicketFromFolder(lngTicketID, CType(29, Long))
                removeTicketFromFolder(lngTicketID, CType(30, Long))
                removeTicketFromFolder(lngTicketID, CType(31, Long))
                removeTicketFromFolder(lngTicketID, CType(32, Long))
                removeTicketFromFolder(lngTicketID, CType(17, Long))

            Case Else
                removeTicketFromFolder(lngTicketID, CType(25, Long))
                removeTicketFromFolder(lngTicketID, CType(26, Long))
                removeTicketFromFolder(lngTicketID, CType(29, Long))
                removeTicketFromFolder(lngTicketID, CType(30, Long))
                removeTicketFromFolder(lngTicketID, CType(31, Long))
                removeTicketFromFolder(lngTicketID, CType(31, Long))
                removeTicketFromFolder(lngTicketID, CType(32, Long))
                removeTicketFromFolder(lngTicketID, CType(33, Long))

        End Select

    End Sub
      
    Private Sub UpdatePayableStatus(ByVal lngTicketID As Long, ByVal bolPayable As Boolean)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spUpdateWorkOrdersPayableByTicketID")
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TicketID", Data.SqlDbType.Int).Value = lngTicketID
        cmd.Parameters.Add("@Payable", Data.SqlDbType.Bit).Value = bolPayable
        cnn.open        
        cmd.Connection = cnn
        
        cmd.ExecuteNonQuery()
        cnn.Close()
  End Sub  
    Private Function IsTicketOpened(ByVal lngTicketID As Long) As Boolean
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spIsticketOpen")
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TicketID", Data.SqlDbType.Int).Value = lngTicketID
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr1 As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr1.Read
            IsTicketOpened = dtr1("Result")
        End While
        cnn.Close()
    End Function
      
      
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server" class="inputform">
    <div class="errorzone" id="divErrors" runat="server" visible="false" />
    <table>
      <tbody>
        <tr>
          <td>
            <div class="inputformsectionheader">Status&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Technical Support Agent</div>
            <asp:DropDownList ID="drpTicketStatus" runat="server" style="width: 70%" /><asp:DropDownList ID="drpSupportAgent" runat="server" style="width: 30%" />
            <div class="inputformsectionheader">Contact</div>
            <div class="label">Company</div>
            <asp:TextBox style="width: 99%" ID="txtCompany" runat="server"  />
            <cv:FirstLastName ID="fnl" runat="server" />
            <div class="label">Email Address</div>
            <asp:TextBox id="txtEmail" runat="server" style="width: 99%" />
            <div class="inputformsectionheader">Address</div>
            <cv:Address ID="add" ShowType="false" runat="server" />
            <div class="inputformsectionheader">Service</div>
            <table>
              <tbody>
                <tr>
                  <td>
                  <div class="label">Customer</div>
                    <asp:DropDownList style="width: 170px" ID="cbxCustomers" runat="server" OnSelectedIndexChanged="CustomerChanged" AutoPostBack="true" />
                    <div class="label">Program</div>
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
            <div class="inputformsectionheader">Unit</div>
            <table>
              <tr>
                <td class="label">Manufacturer Desc.</td>
                <td>&nbsp;</td>
                <td class="label">Model</td>
                <td>&nbsp;</td>
                <td class="label">Serial Number</td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td class="label"><asp:TextBox ID="txtManufacturer" style="Width: 99%" runat="server" /></td>
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
            <div class="inputformsectionheader">Information</div>    
            <div class="label">Onsite Instructions</div>
            <asp:TextBox ID="txtDescription" runat="server" style="Width: 99%;" TextMode="multiline" />
            <div class="label">Description Of Work</div>
            <asp:TextBox ID="txtNotes" runat="server" style="Width: 99%" TextMode="multiline" />
          </td>
        </tr>
      </tbody>
    </table>
    <div style="text-align: right;"><asp:CheckBox ID="chkLaborOnly" Text="Labor Only" runat="server" /></div>
    <div>&nbsp;</div>
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnEdit" runat="Server" Text="Save" OnClick="btnEdit_Click" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
    <asp:Label ID="lblCurrentServiceType" Visible="false" runat="server" />
  </form>
</asp:Content>