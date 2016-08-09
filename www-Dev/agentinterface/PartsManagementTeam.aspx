<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">

    Private _ID As Long = 4
    Private _lngCustID As Long = 1
  Private lngIt as long 
    Private _lngButtonOption As Long = 0
    Private _lngStatusID As Long = 0
    Private _lngStateID As Long = 0
    Private _lngProgramID As Long = 0
    Private _chkNeedUpdate As Boolean = False
    Private _lngColor As Long = 1
    Private _ParID As Long = 0
    Private _CountryID As Long = 1
    Private _chkRMA As Boolean = False
    Private _chkRMAEsc As Boolean = False
    Private mListTotal As Double
    
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
        lblTicketCount.Text = ""
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
            Master.PageHeaderText = "Parts Management Team"
            Master.PageTitleText = "Parts Management Team"
            Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; Parts Management Team"
    End If
    Try
            _ID = CType(Request.QueryString("id"), Long)
        Catch ex As Exception
            _ID = 0
        End Try
        Try
            _lngButtonOption = CType(Request.QueryString("id"), Long)
        Catch ex As Exception
            _lngButtonOption = 0
        End Try
        Try
            _lngCustID = CType(Request.QueryString("CustID"), Long)
        Catch ex As Exception
            _lngCustID = 0
        End Try
        Try
            _lngStatusID = CType(Request.QueryString("StatusID"), Long)
        Catch ex As Exception
            _lngStatusID = 0
        End Try
        Try
            _lngProgramID = CType(Request.QueryString("ProgID"), Long)
        Catch ex As Exception
            _lngProgramID = 0
        End Try
        Try
            _lngStateID = CType(Request.QueryString("StateID"), Long)
        Catch ex As Exception
            _lngStateID = 0
        End Try
        Try
            _chkNeedUpdate = CType(Request.QueryString("NP"), Boolean)
        Catch ex As Exception
            _chkNeedUpdate = 0
        End Try
        Try
            _lngColor = CType(Request.QueryString("C"), Long)
        Catch ex As Exception
            _lngColor = 0
        End Try
        Try
            _ParID = CType(Request.QueryString("ParID"), Long)
        Catch ex As Exception
            _ParID = 0
        End Try
        Try
            _chkRMA = CType(Request.QueryString("RMA"), Boolean)
        Catch ex As Exception
            _chkRMA = 0
        End Try
        Try
            _chkRMAEsc = CType(Request.QueryString("RMAEsc"), Boolean)
        Catch ex As Exception
            _chkRMAEsc = 0
        End Try
        
        If Not Page.IsPostBack Then
            
            LoadCustomers()
            LoadStates()
            LoadPrograms()
            LoadStatus()
            LoadAgents()
            
            If _lngButtonOption <> 0 Then
                drpCustomers1.SelectedValue = _lngCustID
                drpStatus.SelectedValue = _lngStatusID
                drpState.SelectedValue = _lngStateID
                chkNeedUpdateID.Checked = _chkNeedUpdate
                If drpCustomers1.SelectedValue <> "Assign Customer" And drpProgram.SelectedValue = "Assign Program" Then
                    LoadPrograms1(drpCustomers1.SelectedValue)
                End If
                drpProgram.SelectedValue = _lngProgramID
                
                If _lngButtonOption = 1 Then  'ordering parts
                    btnOrderParts.BorderColor = Drawing.Color.Blue
                    drpPartners.Visible = False
                    btnCharge.Visible = False
                    btnClear.Visible = False
                    lstPartners.Visible = True
                    GetPartners()
                    If _ParID = 0 Then
                        LoadTickets(29, _lngButtonOption)
                    Else
                        For Each itm As DataGridItem In dgvVendors.Items
                            If CType(itm.Cells(0).Text, Long) = _ParID Then
                                itm.CssClass = "selectedbandbar"
                            End If
                        Next
                        LoadTickets(29, _lngButtonOption)
                    End If
                End If
                
                If _lngButtonOption = 2 Then 'PONT
                    btnETA2.BorderColor = Drawing.Color.Blue
                    drpPartners.Visible = False
                    btnCharge.Visible = False
                    btnClear.Visible = False
                    lstPartners.Visible = False
                    If _ParID = 0 Then
                        LoadTickets(39, _lngButtonOption)
                        
                    Else
                        LoadTickets(28, _lngButtonOption)
                    End If
                End If
                
                If _lngButtonOption = 3 Then 'Back Order
                    btnETA3.BorderColor = Drawing.Color.Blue
                    drpPartners.Visible = False
                    btnCharge.Visible = False
                    btnClear.Visible = False
                    lstPartners.Visible = False
                    If _ParID = 0 Then
                        LoadTickets(31, _lngButtonOption)
                    Else
                        LoadTickets(28, _lngButtonOption)
                    End If
                End If
                
                If _lngButtonOption = 4 Then  'Awaiting Parts
                    btnAll.BorderColor = Drawing.Color.Blue
                    drpPartners.Visible = False
                    btnCharge.Visible = False
                    btnClear.Visible = False
                    lstPartners.Visible = False
                    If _ParID = 0 Then
                        LoadTickets(3, _lngButtonOption)
                    Else
                        LoadTickets(28, _lngButtonOption)
                    End If
                End If
                If _lngButtonOption = 5 Then  'Need Parts Researched
                    btnAuthorizations.BorderColor = Drawing.Color.Blue
                    drpPartners.Visible = False
                    btnCharge.Visible = False
                    btnClear.Visible = False
                    lstPartners.Visible = False
                    If _ParID = 0 Then
                        LoadTickets(38, _lngButtonOption)
                    Else
                        LoadTickets(28, _lngButtonOption)
                    End If
                End If
                If _lngButtonOption = 6 Then  'RMA Requests
                    btnRMA.BorderColor = Drawing.Color.Blue
                    drpPartners.Visible = False
                    btnCharge.Visible = False
                    btnClear.Visible = False
                    chkRMACreditVerification.Checked = _chkRMA
                    chkRMAEscalation.Checked = _chkRMAEsc
                    If _ParID = 0 Then
                        
                        LoadTickets(13, _lngButtonOption)
                   
                    Else
                       
                        LoadTickets(28, _lngButtonOption)
                    
                        
                    End If
                End If
                If _lngButtonOption = 7 Then 'Core Returns
                    btnCoreReturns.BorderColor = Drawing.Color.Blue
                    drpPartners.Visible = True
                    btnCharge.Visible = False
                    btnClear.Visible = False
                    LoadPartners()
                    If _ParID > 0 Then
                        drpPartners.SelectedValue = _ParID
                        lblEmailTech.Text = GetTechEmailAddress(_ParID)
                        LoadTickets(28, _lngButtonOption)
                        btnCharge.Visible = True
                        btnClear.Visible = True
                    Else
                        LoadTickets(28, _lngButtonOption)
                    End If
                    btnCharge.Attributes.Add("onclick", "return confirm('You will be charging all the selected items to the technician, do you want to continue?');")
                    btnClear.Attributes.Add("onclick", " return confirm('You will be marking tracked all the selected items from the list and you will not be able to charge the technician for these parts. Do you want to continue?');")
                End If
            End If
        Else

            If drpCustomers1.SelectedValue <> "Assign Customer" And drpProgram.SelectedValue = "Assign Program" Then
                LoadPrograms1(drpCustomers1.SelectedValue)
                If _lngButtonOption <> 0 Then
                    If _ParID = 0 Then
                        LoadTickets(2, _lngButtonOption)
                    Else
                        LoadTickets(29, _lngButtonOption)
                    End If
                    
                Else
                    LoadTickets(0, 0)
                End If
                Else
                    If drpProgram.SelectedValue = "Assign By Program" Then
                        drpProgram.Items.Clear()
                        drpProgram.Items.Add("Assign Program")
                        drpProgram.SelectedValue = "Assign Program"
                    Else
                        If _ParID = 0 Then
                        
                            'LoadTickets(13, _lngButtonOption)
                    
                        Else
                            'LoadTickets(28, _lngButtonOption)
                        End If
                    End If

                End If
            
        End If
        
    End Sub
  
    Private Sub LoadTickets(ByVal lngTicketFolderID As Long, ByVal lngButtonOption As Long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim ldr1 As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                
        drpCustomers1.Visible = True
        drpStatus.Visible = True
        drpProgram.Visible = True
        drpState.Visible = True
        
        If _lngButtonOption < 6 Then
            If drpCustomers1.SelectedValue <> "Assign Customer" Then
                If drpStatus.SelectedValue <> "Filter By Status" Then
                    If drpProgram.SelectedValue <> "Assign Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter by Customer, status, Program and state
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByCSPSPartsConsole", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@CountryID", _CountryID, dgvTickets)
                            Else
                                If _ParID = 0 Then
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByCSPSPartsConsole1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByCSPSPartsConsole1ByPartnerID", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@CountryID", _CountryID, "@PartnerID", _ParID, dgvTickets)
                                End If
                                
                            End If
                        Else
                            'Filter by Customer, status and program
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByCSPPartsConsole1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "@CountryID", _CountryID, dgvTickets)
                            Else
                                If _ParID = 0 Then
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByCSPPartsConsole", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "@CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByCSPPartsConsoleByPartnerID", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "@CountryID", _CountryID, "@PartnerID", _ParID, dgvTickets)
                                End If
                                
                            End If
                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter by customer, Status and State
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByCSSPartsConsole1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@CountryID", _CountryID, dgvTickets)
                            Else
                                If _ParID = 0 Then
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByCSSPartsConsole", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByCSSPartsConsoleByPartnerID", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@CountryID", _CountryID, "@PartnerID", _ParID, dgvTickets)
                                End If
                                
                            End If
                        Else
                            'Filter by Customer Status
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByCSPartsConsole1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "@CountryID", _CountryID, dgvTickets)
                            Else
                                If _ParID = 0 Then
                                    ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByCSPartsConsole", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "@CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByCSPartsConsoleByPartnerID", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "@CountryID", _CountryID, "@PartnerID", _ParID, dgvTickets)
                                    
                                End If
                                
                            End If
                        End If

                    End If
                Else
                    If drpProgram.SelectedValue <> "Assign Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter by Customer, Program and State
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByCPSPartsConsole1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@CountryID", _CountryID, dgvTickets)
                            Else
                                If _ParID = 0 Then
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByCPSPartsConsole", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByCPSPartsConsoleByPartnerID", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@CountryID", _CountryID, "@PartnerID", _ParID, dgvTickets)
                                End If
                                
                            End If
                        Else
                            'Filter By Customer, Program
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByCPPartsConsole1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "@CountryID", _CountryID, dgvTickets)
                            Else
                                If _ParID = 0 Then
                                    ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByCPPartsConsole", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "@CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByCPPartsConsoleByPartnerID", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "@CountryID", _CountryID, "@PartnerID", _ParID, dgvTickets)
                                End If
                                
                            End If
                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By Customer, State
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByCStatePartsConsole1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@CountryID", _CountryID, dgvTickets)
                            Else
                                If _ParID = 0 Then
                                    ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByCStatePartsConsole", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByCStatePartsConsoleByPartnerID", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@CountryID", _CountryID, "@PartnerID", _ParID, dgvTickets)
                                End If
                                
                            End If
                        Else
                            'Filter By Customer
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByCustomerPartsConsole1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "@CountryID", _CountryID, dgvTickets)
                            Else
                                If _ParID = 0 Then
                                    ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByCustomerPartsConsole", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "@CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByCustomerPartsConsoleByPartnerID", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "@CountryID", _CountryID, "@PartnerID", _ParID, dgvTickets)
                                End If
                            End If
                        End If
                    End If

                End If
            Else
                If drpStatus.SelectedValue <> "Filter By Status" Then
                    If drpProgram.SelectedValue <> "Assign Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By status, Program and state
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByStatusStatePartsConsole1", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@CountryID", _CountryID, dgvTickets)
                            Else
                                If _ParID = 0 Then
                                    ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByStatusStatePartsConsole", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByStatusStatePartsConsoleByPartnerID", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@CountryID", _CountryID, "@PartnerID", _ParID, dgvTickets)
                                End If
                                
                            End If
                        Else
                            'Filter By Status and program
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByStatusPartsConsole1", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "@CountryID", _CountryID, dgvTickets)
                            Else
                                If _ParID = 0 Then
                                    ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByStatusPartsConsole", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "@CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByStatusPartsConsoleByPartnerID", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "@CountryID", _CountryID, "@PartnerID", _ParID, dgvTickets)
                                End If
                                
                            End If
                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By status and State
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByStatusStatePartsConsole1", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@CountryID", _CountryID, dgvTickets)
                            Else
                                If _ParID = 0 Then
                                    ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByStatusStatePartsConsole", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByStatusStatePartsConsoleByPartnerID", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@CountryID", _CountryID, "@PartnerID", _ParID, dgvTickets)
                                End If
                            End If
                        Else
                            'Filter By Status
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByStatusPartsConsole1", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "@CountryID", _CountryID, dgvTickets)
                            Else
                                If _ParID = 0 Then
                                    ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByStatusPartsConsole", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "@CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByStatusPartsConsoleByPartnerID", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "@CountryID", _CountryID, "@PartnerID", _ParID, dgvTickets)
                                End If
                            End If
                        End If
                    End If
                Else
                    If drpProgram.SelectedValue <> "Assign Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By Program and state
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByStatePartsConsole1", "@TicketFolderID", lngTicketFolderID, "@StateID", CType(drpState.SelectedValue, Long), "@CountryID", _CountryID, dgvTickets)
                            Else
                                If _ParID = 0 Then
                                    ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByStatePartsConsole", "@TicketFolderID", lngTicketFolderID, "@StateID", CType(drpState.SelectedValue, Long), "@CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByStatePartsConsoleByPartnerID", "@TicketFolderID", lngTicketFolderID, "@StateID", CType(drpState.SelectedValue, Long), "@CountryID", _CountryID, "@PartnerID", _ParID, dgvTickets)
                                End If
                            End If
                        Else
                            'Filter By Program
                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By State
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByStatePartsConsole1", "@TicketFolderID", lngTicketFolderID, "@StateID", CType(drpState.SelectedValue, Long), "@CountryID", _CountryID, dgvTickets)
                            Else
                                If _ParID = 0 Then
                                    ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByStatePartsConsole", "@TicketFolderID", lngTicketFolderID, "@StateID", CType(drpState.SelectedValue, Long), "@CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByStatePartsConsoleByPartnerID", "@TicketFolderID", lngTicketFolderID, "@StateID", CType(drpState.SelectedValue, Long), "@CountryID", _CountryID, "@PartnerID", _ParID, dgvTickets)
                                End If
                                
                            End If
                        Else
                            'Dont filter - Show all the tickets in the folder
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByPartsConsole1", "@TicketFolderID", lngTicketFolderID, "@Temp", 0, "@CountryID", _CountryID, dgvTickets)
                            Else
                                If _ParID = 0 Then
                                    ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByPartsConsole", "@TicketFolderID", lngTicketFolderID, "@Temp", 0, "@CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByPartsConsoleByPartnerID", "@TicketFolderID", lngTicketFolderID, "@Temp", 0, "@CountryID", _CountryID, "@PartnerID", _ParID, dgvTickets)
                                End If
                                
                            End If
                        End If
                    End If
                End If
        
            End If
            lblTicketCount.Text = " [ " & CType(dgvTickets.DataSource, Data.DataSet).Tables(0).Rows.Count & " ] "
        Else
            Multiview1.ActiveViewIndex = 1
            If _lngButtonOption <> 6 Then
                If _ParID = 0 Then
                    'ldr.LoadSingleLongParameterDataGrid("spListTicketsInFolder", "@TicketFolderID", 28, dgvTickets)
                    If drpCustomers1.SelectedValue = "Assign Customer" Then
                        ldr.LoadSimpleDataGrid("spListPartsNeedReturnedAll", dgvOpenWorkOrders)
                    Else
                        ldr.LoadSingleLongParameterDataGrid("spListPartsNeedReturnedByCustomer", "@CustomerID", CType(drpCustomers1.SelectedValue, Long), dgvOpenWorkOrders)
                    End If
                Else
                    'ldr.LoadTwoLongParameterDataGrid("spListTicketsInFolderByPartner", "@TicketFolderID", 28, "@PartnerID", CType(drpPartners.SelectedValue, Long), dgvTickets)
                    If drpCustomers1.SelectedValue = "Assign Customer" Then
                      
                        ldr.LoadSingleLongParameterDataGrid("spListPartsNeedReturnedByPartnerID", "@PartnerID", _ParID, dgvOpenWorkOrders)
                      
                    Else
                       
                        ldr.LoadTwoLongParameterDataGrid("spListPartsNeedReturnedByPartnerIDAndCustomer", "@PartnerID", CType(drpPartners.SelectedValue, Long), "@CustomerID", CType(drpCustomers1.SelectedValue, Long), dgvOpenWorkOrders)
                      
                    End If
                End If
                lblTicketCount1.Text = " [ " & CType(dgvOpenWorkOrders.DataSource, Data.DataSet).Tables(0).Rows.Count & " ] "
            Else
                If drpCustomers1.SelectedValue = "Assign Customer" Then
                    If chkRMACreditVerification.Checked Then
                        ldr.LoadSimpleDataGrid("spListPartsReturnedRACreditVerification", dgvOpenWorkOrders)
                    Else
                        If chkRMAEscalation.Checked Then
                            ldr.LoadSimpleDataGrid("spListPartsNeedReturnedRAEscalation", dgvOpenWorkOrders)
                        Else
                            ldr.LoadSimpleDataGrid("spListPartsNeedReturnedRA", dgvOpenWorkOrders)
                        End If
                    End If
                Else
                    If chkRMACreditVerification.Checked Then
                        ldr.LoadSingleLongParameterDataGrid("spListPartsNeedReturnedRACreditVerificationByCustomer", "@CustomerID", CType(drpCustomers1.SelectedValue, Long), dgvOpenWorkOrders)
                    Else
                        If chkRMAEscalation.Checked Then
                            If drpCustomers1.SelectedValue = "Assign Customer" Then
                                ldr.LoadSimpleDataGrid("spListPartsNeedReturnedRAEscalation", dgvOpenWorkOrders)
                            Else
                                ldr.LoadSingleLongParameterDataGrid("spListPartsNeedReturnedRAEscalationByCustomer", "@CustomerID", CType(drpCustomers1.SelectedValue, Long), dgvOpenWorkOrders)
                                
                            End If
                        Else
                            ldr.LoadSingleLongParameterDataGrid("spListPartsNeedReturnedRAByCustomer", "@CustomerID", CType(drpCustomers1.SelectedValue, Long), dgvOpenWorkOrders)
                        End If
                    End If
                End If
                  
                lblTicketCount1.Text = " [ " & CType(dgvOpenWorkOrders.DataSource, Data.DataSet).Tables(0).Rows.Count & " ] "
            End If
        End If
        
     
    End Sub

    Private Sub LoadTicketsByCustomer(ByVal lngTicketFolderID As Long, ByVal lngCustomerID As Long)
        Dim ldr1 As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))

        ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByCustomer", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
        lblTicketCount.Text = " ( " & CType(dgvTickets.DataSource, Data.DataSet).Tables(0).Rows.Count & " ) "

    End Sub

  Private Function DetermineCustomerLabel(ByRef strCompanyName As String, ByRef strCompanyContact As String) As String
    Dim strReturn As String = ""
    If Not IsNothing(strCompanyName) Then
      If strCompanyName.Trim.Length > 0 Then
        strReturn = strCompanyName
      Else
        If Not IsNothing(strCompanyContact) Then
          If strCompanyContact.Trim.Length > 0 Then
            strReturn = strCompanyContact
          Else
            strReturn = "Unknown"
          End If
        End If
      End If
    Else
      If Not IsNothing(strCompanyContact) Then
        If strCompanyContact.Trim.Length > 0 Then
          strReturn = strCompanyContact
        Else
          strReturn = "Unknown"
        End If
      End If
    End If
    Return strCompanyName
  End Function
  
  Protected Sub dgvTickets_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        
        
        If lblSortOrder.Text.ToLower = " asc" Then
            lblSortOrder.Text = " desc"
        Else
            lblSortOrder.Text = " asc"
        End If
        
                
        Dim ldr1 As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        If _lngButtonOption < 6 Then
            If drpCustomers1.SelectedValue <> "Assign Customer" Then
                If drpStatus.SelectedValue <> "Filter By Status" Then
                    If drpProgram.SelectedValue <> "Assign Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter by Customer, status, Program and state
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByCSPSPartsConsole1", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByCSPSPartsConsole", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        Else
                            'Filter by Customer, status and program
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByCSPPartsConsole1", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByCSPPartsConsole", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter by customer, Status and State
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByCSSPartsConsole1", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByCSSPartsConsole", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        Else
                            'Filter by Customer Status
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByCSPartsConsole1", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByCSPartsConsole", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        End If

                    End If
                Else
                    If drpProgram.SelectedValue <> "Assign Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter by Customer, Program and State
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByCPSPartsConsole1", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByCPSPartsConsole", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        Else
                            'Filter By Customer, Program
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByCPPartsConsole1", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByCPPartsConsole", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By Customer, State
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByCStatePartsConsole1", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByCStatePartsConsole", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        Else
                            'Filter By Customer
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByCustomerPartsConsole1", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByCustomerPartsConsole", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        End If
                    End If

                End If
            Else
                If drpStatus.SelectedValue <> "Filter By Status" Then
                    If drpProgram.SelectedValue <> "Assign Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By status, Program and state
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByStatusStatePartsConsole1", "@TicketFolderID", 2, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByStatusStatePartsConsole", "@TicketFolderID", 2, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        Else
                            'Filter By Status and program
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByStatusPartsConsole1", "@TicketFolderID", 2, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByStatusPartsConsole", "@TicketFolderID", 2, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By status and State
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByStatusStatePartsConsole1", "@TicketFolderID", 2, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByStatusStatePartsConsole", "@TicketFolderID", 2, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        Else
                            'Filter By Status
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByStatusPartsConsole1", "@TicketFolderID", 2, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByStatusPartsConsole", "@TicketFolderID", 2, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        End If
                    End If
                Else
                    If drpProgram.SelectedValue <> "Assign Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By Program and state
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByStatePartsConsole1", "@TicketFolderID", 2, "@StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByStatePartsConsole", "@TicketFolderID", 2, "@StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        Else
                            'Filter By Program
                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By State
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByStatePartsConsole1", "@TicketFolderID", 2, "@StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByStatePartsConsole", "@TicketFolderID", 2, "@StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        Else
                            'Dont filter - Show all the tickets in the folder
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByPartsConsole1", "@TicketFolderID", 2, "Temp", 0, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByPartsConsole", "@TicketFolderID", 2, "Temp", 0, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        End If
                    End If
                End If
            End If
        Else
            'ldr.LoadSingleLongParameterDataGrid("spListTicketsInFolder", "@TicketFolderID", 28, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
        End If
    End Sub
 
  Private Sub LoadCustomers()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSimpleDropDownList("spListActiveCustomers", "Company", "CustomerID", drpCustomers1)
        drpCustomers1.Items.Add("Assign Customer")
        drpCustomers1.SelectedValue = "Assign Customer"
    End Sub
    Private Sub LoadStates()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        ldr.LoadSimpleDropDownList("spListStates", "StateName", "StateID", drpState)
        drpState.Items.Add("Filter By State")
        drpState.SelectedValue = "Filter By State"
        
        
    End Sub
    Private Sub LoadPrograms()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        
        'ldr.LoadSimpleDropDownList("spListStates", "StateName", "StateID", drpState)
        drpProgram.Items.Add("Assign Program")
        drpProgram.SelectedValue = "Assign Program"
        
        
    End Sub
    Private Sub LoadStatus()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        ldr.LoadSimpleDropDownList("spListStatuses", "Status", "TicketStatusID", drpStatus)
        drpStatus.Items.Add("Filter By Status")
        drpStatus.SelectedValue = "Filter By Status"
        
        
    End Sub
 

    Private Sub btnEmail_Click(ByVal S As Object, ByVal E As EventArgs)
        'drpCustomers.selectedValue = "Choose one"
        'LoadTicketsByPartners(CType(Request.QueryString("id"), Long),Ctype(drpPartners.SelectedValue,long) )
    
    End Sub
    Protected Sub drpCustomers1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        If drpCustomers1.SelectedValue <> "Assign Customer" Then
            LoadPrograms1(drpCustomers1.SelectedValue)
            
        End If
    End Sub
    Private Sub LoadPrograms1(ByVal lngCustomerID As Long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim ldr1 As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        'ldr.LoadSimpleDropDownList("spListServiceTypes", "ServiceType", "CustomerID", drpProgram)
        ldr.LoadSingleLongParameterDropDownList("spListServiceTypes", "@CustomerID", lngCustomerID, "ServiceType", "ServiceTypeID", drpProgram)
        
        drpProgram.Items.Add("Assign Program")
        drpProgram.SelectedValue = "Assign Program"
       
        
    End Sub
    Private Sub LoadAgents()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        
        ldr.LoadSingleLongParameterDropDownList("spListAgentsByPositionID", "@PositionID", CType(9, Long), "UserName", "UserID", drpAgents)
        drpAgents.Items.Add("Assign Agent")
        drpAgents.SelectedValue = "Assign Agent"
        
    End Sub
    Private Sub btnOrderParts_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim lngCustomerID As Long
        Dim lngProgramID As Long
        Dim lngStatusID As Long
        Dim lngStateID As Long
        Dim boolNeedUpdate As Boolean
        
        Multiview1.ActiveViewIndex = 0
        
        _lngButtonOption = 1 'ordering parts
        
        If drpCustomers1.SelectedValue <> "Assign Customer" Then
            lngCustomerID = drpCustomers1.SelectedValue
        Else
            lngCustomerID = 0
        End If
        If drpProgram.SelectedValue <> "Assign Program" Then
            lngProgramID = drpProgram.SelectedValue
        Else
            lngProgramID = 0
        End If
        If drpStatus.SelectedValue <> "Filter By Status" Then
            lngStatusID = drpStatus.SelectedValue
        Else
            lngStatusID = 0
        End If
        If drpState.SelectedValue <> "Filter By State" Then
            lngStateID = drpState.SelectedValue
        Else
            lngStateID = 0
        End If
        boolNeedUpdate = chkNeedUpdateID.Checked
        If _lngColor = 1 Then
            btnAll.BorderColor = Drawing.Color.Black
        Else
            btnAll.BorderColor = Drawing.Color.Blue
        End If
        'LoadTickets(CType(2, Long), _lngButtonOption)
        Response.Redirect("PartsManagementTeam.aspx?id=" & _lngButtonOption & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&C=0", True)
    End Sub
    Private Sub btnETA2_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim lngCustomerID As Long
        Dim lngProgramID As Long
        Dim lngStatusID As Long
        Dim lngStateID As Long
        Dim boolNeedUpdate As Boolean
        
        Multiview1.ActiveViewIndex = 0
        
        _lngButtonOption = 2 'PONT
        
        If drpCustomers1.SelectedValue <> "Assign Customer" Then
            lngCustomerID = drpCustomers1.SelectedValue
        Else
            lngCustomerID = 0
        End If
        If drpProgram.SelectedValue <> "Assign Program" Then
            lngProgramID = drpProgram.SelectedValue
        Else
            lngProgramID = 0
        End If
        If drpStatus.SelectedValue <> "Filter By Status" Then
            lngStatusID = drpStatus.SelectedValue
        Else
            lngStatusID = 0
        End If
        If drpState.SelectedValue <> "Filter By State" Then
            lngStateID = drpState.SelectedValue
        Else
            lngStateID = 0
        End If
        boolNeedUpdate = chkNeedUpdateID.Checked
        If _lngColor = 1 Then
            btnETA2.BorderColor = Drawing.Color.Black
        Else
            btnETA2.BorderColor = Drawing.Color.Blue
        End If
        'LoadTickets(CType(2, Long), _lngButtonOption)
        Response.Redirect("PartsManagementTeam.aspx?id=" & _lngButtonOption & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&C=0", True)
    End Sub
    Private Sub btnETA3_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim lngCustomerID As Long
        Dim lngProgramID As Long
        Dim lngStatusID As Long
        Dim lngStateID As Long
        Dim boolNeedUpdate As Boolean
        
        Multiview1.ActiveViewIndex = 0
        
        _lngButtonOption = 3 ' Parts on Back Order
        
        If drpCustomers1.SelectedValue <> "Assign Customer" Then
            lngCustomerID = drpCustomers1.SelectedValue
        Else
            lngCustomerID = 0
        End If
        If drpProgram.SelectedValue <> "Assign Program" Then
            lngProgramID = drpProgram.SelectedValue
        Else
            lngProgramID = 0
        End If
        If drpStatus.SelectedValue <> "Filter By Status" Then
            lngStatusID = drpStatus.SelectedValue
        Else
            lngStatusID = 0
        End If
        If drpState.SelectedValue <> "Filter By State" Then
            lngStateID = drpState.SelectedValue
        Else
            lngStateID = 0
        End If
        boolNeedUpdate = chkNeedUpdateID.Checked
        If _lngColor = 1 Then
            btnAll.BorderColor = Drawing.Color.Black
        Else
            btnAll.BorderColor = Drawing.Color.Blue
        End If
        'LoadTickets(CType(2, Long), _lngButtonOption)
        Response.Redirect("PartsManagementTeam.aspx?id=" & _lngButtonOption & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&C=0", True)
    End Sub
    Private Sub btnAll_Click(ByVal S As Object, ByVal E As EventArgs)
        ' Show all tickets for a customer
        Dim lngCustomerID As Long
        Dim lngProgramID As Long
        Dim lngStatusID As Long
        Dim lngStateID As Long
        Dim boolNeedUpdate As Boolean
        
        Multiview1.ActiveViewIndex = 0
        
        _lngButtonOption = 4 ' Awaiting Parts
        
        If drpCustomers1.SelectedValue <> "Assign Customer" Then
            lngCustomerID = drpCustomers1.SelectedValue
        Else
            lngCustomerID = 0
        End If
        If drpProgram.SelectedValue <> "Assign Program" Then
            lngProgramID = drpProgram.SelectedValue
        Else
            lngProgramID = 0
        End If
        If drpStatus.SelectedValue <> "Filter By Status" Then
            lngStatusID = drpStatus.SelectedValue
        Else
            lngStatusID = 0
        End If
        If drpState.SelectedValue <> "Filter By State" Then
            lngStateID = drpState.SelectedValue
        Else
            lngStateID = 0
        End If
        boolNeedUpdate = chkNeedUpdateID.Checked
        If _lngColor = 1 Then
            btnAll.BorderColor = Drawing.Color.Black
        Else
            btnAll.BorderColor = Drawing.Color.Blue
        End If
        'LoadTickets(CType(2, Long), _lngButtonOption)
        Response.Redirect("PartsManagementTeam.aspx?id=" & _lngButtonOption & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&C=0", True)
        
    End Sub
    
    Private Sub btnAuthorizations_Click(ByVal S As Object, ByVal E As EventArgs)
        ' Show all tickets for a customer
        Dim lngCustomerID As Long
        Dim lngProgramID As Long
        Dim lngStatusID As Long
        Dim lngStateID As Long
        Dim boolNeedUpdate As Boolean
        
        Multiview1.ActiveViewIndex = 0
        
        _lngButtonOption = 5 ' Need Parts Researched
        
        If drpCustomers1.SelectedValue <> "Assign Customer" Then
            lngCustomerID = drpCustomers1.SelectedValue
        Else
            lngCustomerID = 0
        End If
        If drpProgram.SelectedValue <> "Assign Program" Then
            lngProgramID = drpProgram.SelectedValue
        Else
            lngProgramID = 0
        End If
        If drpStatus.SelectedValue <> "Filter By Status" Then
            lngStatusID = drpStatus.SelectedValue
        Else
            lngStatusID = 0
        End If
        If drpState.SelectedValue <> "Filter By State" Then
            lngStateID = drpState.SelectedValue
        Else
            lngStateID = 0
        End If
        boolNeedUpdate = chkNeedUpdateID.Checked
        If _lngColor = 1 Then
            btnAuthorizations.BorderColor = Drawing.Color.Black
        Else
            btnAuthorizations.BorderColor = Drawing.Color.Blue
        End If
        'LoadTickets(CType(2, Long), _lngButtonOption)
        Response.Redirect("PartsManagementTeam.aspx?id=" & _lngButtonOption & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&C=0", True)
        
    End Sub
    
    Private Sub btnRMA_Click(ByVal S As Object, ByVal E As EventArgs)
        ' Show tickets needing RMA requests
        Dim lngCustomerID As Long
        Dim lngProgramID As Long
        Dim lngStatusID As Long
        Dim lngStateID As Long
        Dim boolNeedUpdate As Boolean
        
        Multiview1.ActiveViewIndex = 1
        
        _lngButtonOption = 6 ' Need RMA requested
        
        If drpCustomers1.SelectedValue <> "Assign Customer" Then
            lngCustomerID = drpCustomers1.SelectedValue
        Else
            lngCustomerID = 0
        End If
        If drpProgram.SelectedValue <> "Assign Program" Then
            lngProgramID = drpProgram.SelectedValue
        Else
            lngProgramID = 0
        End If
        If drpStatus.SelectedValue <> "Filter By Status" Then
            lngStatusID = drpStatus.SelectedValue
        Else
            lngStatusID = 0
        End If
        If drpState.SelectedValue <> "Filter By State" Then
            lngStateID = drpState.SelectedValue
        Else
            lngStateID = 0
        End If
        boolNeedUpdate = chkNeedUpdateID.Checked
        If _lngColor = 1 Then
            btnRMA.BorderColor = Drawing.Color.Black
        Else
            btnRMA.BorderColor = Drawing.Color.Blue
        End If
        'LoadTickets(CType(2, Long), _lngButtonOption)
        Response.Redirect("PartsManagementTeam.aspx?id=" & _lngButtonOption & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&C=0&RMA=" & chkRMACreditVerification.Checked & "&RMAEsc=" & chkRMAEscalation.Checked, True)
        
    End Sub
    Private Sub ShowCoreParts ()
     ' Show tickets needing core parts returned
        Dim lngCustomerID As Long
        Dim lngProgramID As Long
        Dim lngStatusID As Long
        Dim lngStateID As Long
        Dim boolNeedUpdate As Boolean
        
        Multiview1.ActiveViewIndex = 1
        
        
        _lngButtonOption = 7
        
        If drpCustomers1.SelectedValue <> "Assign Customer" Then
            lngCustomerID = drpCustomers1.SelectedValue
        Else
            lngCustomerID = 0
        End If
        If drpProgram.SelectedValue <> "Assign Program" Then
            lngProgramID = drpProgram.SelectedValue
        Else
            lngProgramID = 0
        End If
        If drpStatus.SelectedValue <> "Filter By Status" Then
            lngStatusID = drpStatus.SelectedValue
        Else
            lngStatusID = 0
        End If
        If drpState.SelectedValue <> "Filter By State" Then
            lngStateID = drpState.SelectedValue
        Else
            lngStateID = 0
        End If
        boolNeedUpdate = chkNeedUpdateID.Checked
        If _lngColor = 1 Then
            btnCoreReturns.BorderColor = Drawing.Color.Black
        Else
            btnCoreReturns.BorderColor = Drawing.Color.Blue
        End If
        'LoadTickets(CType(2, Long), _lngButtonOption)
        
        if drpPartners.SelectedValue = "Choose One"  or drpPartners.SelectedValue = "" then
          Response.Redirect("PartsManagementTeam.aspx?id=" & _lngButtonOption & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&C=0", True)
        else
          Response.Redirect("PartsManagementTeam.aspx?id=" & _lngButtonOption & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&ParID=" & CType(drpPartners.SelectedValue, Long) & "&C=0", True)

        end if
    
    end sub
    
    Private Sub btnCoreReturns_Click(ByVal S As Object, ByVal E As EventArgs)
       ShowCoreParts()
    End Sub
    Protected Sub drpPartners_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        If drpPartners.SelectedValue <> "Choose One" Then
            Dim lngCustomerID As Long
            Dim lngProgramID As Long
            Dim lngStatusID As Long
            Dim lngStateID As Long
            Dim boolNeedUpdate As Boolean
        
            Multiview1.ActiveViewIndex = 1
            _lngButtonOption = 7
        
            If drpCustomers1.SelectedValue <> "Assign Customer" Then
                lngCustomerID = drpCustomers1.SelectedValue
            Else
                lngCustomerID = 0
            End If
            If drpProgram.SelectedValue <> "Assign Program" Then
                lngProgramID = drpProgram.SelectedValue
            Else
                lngProgramID = 0
            End If
            If drpStatus.SelectedValue <> "Filter By Status" Then
                lngStatusID = drpStatus.SelectedValue
            Else
                lngStatusID = 0
            End If
            If drpState.SelectedValue <> "Filter By State" Then
                lngStateID = drpState.SelectedValue
            Else
                lngStateID = 0
            End If
            boolNeedUpdate = chkNeedUpdateID.Checked
            If _lngColor = 1 Then
                btnCoreReturns.BorderColor = Drawing.Color.Black
            Else
                btnCoreReturns.BorderColor = Drawing.Color.Blue
            End If
            'LoadTickets(CType(2, Long), _lngButtonOption)
        
            Response.Redirect("PartsManagementTeam.aspx?id=" & _lngButtonOption & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&ParID=" & CType(drpPartners.SelectedValue, Long) & "&C=0", True)
            
            'LoadTicketsByPartners(7, CType(drpPartners.SelectedValue, Long))
            'drpCustomers.SelectedValue = "Choose One"
        End If
    End Sub
    Private Sub LoadPartners()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        'ldr.LoadSimpleDropDownList("spListActivePartnersWithCalls","ResumeID","PartnerID" , drpPartners)
        ldr.LoadSingleLongParameterDropDownList("spListPartnersByTicketFolderID", "@TicketFolderID", 28, "Login", "PartnerID", drpPartners)
        drpPartners.Items.Add("Choose One")
        drpPartners.SelectedValue = "Choose One"
        
    End Sub
    Private Sub btnExport_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs)
        Dim ex As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
     
        If dgvOpenWorkOrders.Items.Count > 0 Then
            ex.ExportGrid("PartsNotReturned.xls", dgvOpenWorkOrders)
        End If
    End Sub
    Private Function GetTechEmailAddress(ByVal lngPartnerID As Long) As String
        Dim ptr As New BridgesInterface.PartnerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ptr.Load(lngPartnerID)
        
        GetTechEmailAddress = "<a href=""mailto:" & ptr.Email & """>Email Tech</a>"
        
        
    End Function
    
    Private Sub btnCharge_Click(ByVal S As Object, ByVal E As EventArgs)
       Dim tco as New BridgesInterface.TicketComponentRecord (System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
       Dim dgItem As DataGridItem
       Dim chkbox As CheckBox
       Dim strChangeLog as String = ""

       
        For Each dgItem in dgvOpenWorkOrders.Items
          chkbox = dgItem.FindControl("chkSelected")
          
          If chkbox.Checked Then
             if  dgItem.Cells(10).text = "Core Return" then
                tco.Load (Ctype((dgItem.Cells(1).Text),Long))
                tco.ChargeTechCoreAmount = True
                tco.CoreCharge = Cdec((Ctype((dgItem.Cells(9).Text), Double )*0.30))
                tco.Save(strChangeLog)
                    removeTicketFromFolder(CType((dgItem.Cells(13).Text), Long), CType(28, Long))
             else
                 if  dgItem.Cells(10).text = "RA Number" then
                    tco.Load (Ctype((dgItem.Cells(1).Text),Long))
                    tco.BillTaxes = True
                        tco.Save(strChangeLog)
                        removeTicketFromFolder(CType((dgItem.Cells(13).Text), Long), CType(13, Long))
                 end if
             end if
           End If
            
        Next
         ShowCoreParts()
    end sub
    
     Private Sub btnClear_Click(ByVal S As Object, ByVal E As EventArgs)
       Dim tco as New BridgesInterface.TicketComponentRecord (System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
       Dim shp as New BridgesInterface.ShippingLabelRecord (System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
       Dim dgItem As DataGridItem
       Dim chkbox As CheckBox
       Dim strChangeLog as String = ""

       
        For Each dgItem in dgvOpenWorkOrders.Items
          chkbox = dgItem.FindControl("chkselected")
          
          If chkbox.Checked Then
             if  dgItem.Cells(10).text = "Core Return" then
                
                shp.Load(Ctype((dgItem.Cells(12).Text),Long))
                shp.Tracked = True
                shp.Save(strChangeLog)
                    removeTicketFromFolder(CType((dgItem.Cells(13).Text), Long), CType(28, Long))
                
             else
                 if  dgItem.Cells(10).text = "RA Number" then
                   shp.Load(Ctype((dgItem.Cells(12).Text),Long))
                   shp.Tracked = True
                        shp.Save(strChangeLog)
                        removeTicketFromFolder(CType((dgItem.Cells(13).Text), Long), CType(13, Long))
                 end if
             end if
           End If
            
        Next
        ShowCoreParts()
    end sub
    Private Sub removeTicketFromFolder(ByVal lngTicketID As Long, ByVal lngFolderID As Long)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spRemoveTicketFromFolder")
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TicketID", Data.SqlDbType.Int).Value = lngTicketID
        cmd.Parameters.Add("@FolderID", Data.SqlDbType.Int).Value = lngFolderID
        cnn.open()
        cmd.Connection = cnn
        
        cmd.ExecuteNonQuery()
        cnn.Close()
    End Sub
    
    Private Sub chkRMAEscalation_change(ByVal S As Object, ByVal E As EventArgs) Handles btnRMA.Click
        If chkRMAEscalation.Checked Then
            chkRMACreditVerification.Checked = False
        End If
        btnRMA_Click(S, E)
        
    End Sub
    Private Sub chkRMACreditVerification_change(ByVal S As Object, ByVal E As EventArgs) Handles btnRMA.Click
        If chkRMACreditVerification.Checked Then
            chkRMAEscalation.Checked = False
        End If
        btnRMA_Click(S, E)
    End Sub
        Private Sub dgvOpenWorkOrders_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgvOpenWorkOrders.ItemDataBound
           Dim rowData As Data.DataRowView
        Dim price As Decimal
        Dim listTotalLabel As System.Web.UI.WebControls.Literal
        Dim GrandTotalLabel As System.Web.UI.WebControls.Literal
        
                Select Case (e.Item.ItemType)
            Case ListItemType.AlternatingItem, ListItemType.EditItem, ListItemType.Item, ListItemType.SelectedItem
                rowData = CType(e.Item.DataItem, Data.DataRowView)
             
                'get the value for the Total and add it to the sum
                If Not IsDBNull(rowData.Item("PartCost")) Then
                    price = CDec(rowData.Item("PartCost"))
                    mListTotal += price
                End If
                'get the control used to display the PartAmount price
                listTotalLabel = CType(e.Item.FindControl("lblTotal"), System.Web.UI.WebControls.Literal)
          
                'now format the discounted price in currency format
                listTotalLabel.Text = price.ToString("C2")
            Case ListItemType.Footer

                'get the control used to display the total of the list prices
                'and set its value to the total of the list prices
                
                GrandTotalLabel = CType(e.Item.FindControl("lblGrandTotalAmount"), System.Web.UI.WebControls.Literal)
                GrandTotalLabel.Text = mListTotal.ToString("C2")
        End Select
    End Sub
    
    Private Sub GetPartners()
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        
        ldr.LoadSimpleDataGrid("spGetPartnersNeedingPartsOrdered", dgvVendors)
    End Sub
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmTickets" runat="server">
    <table style="width: 100%">
      <tbody>
        <tr style="width: 100%">
          <td class="band" colspan="2">
            <div class="bandheader">&nbsp;</div>
            <asp:Button ID="btnOrderParts" runat="server" Text="Order Parts"  OnClick="btnOrderParts_Click"  />&nbsp;<asp:Button ID="btnETA2" runat="server" Text="PONT" OnClick="btnETA2_Click" />&nbsp;<asp:Button ID="btnETA3" runat="server" Text="Back Order" OnClick="btnETA3_Click"/>&nbsp;<asp:Button ID="btnAll" runat="server" Text="Waiting Parts" OnClick="btnAll_Click" />&nbsp;<asp:Button ID="btnAuthorizations" runat="server" Text="Part Need Researched" OnClick="btnAuthorizations_Click" />&nbsp;<asp:Button ID="btnRMA" runat="server" Text="RMA Requests" OnClick="btnRMA_Click" visible="false"/>&nbsp;<asp:CheckBox ID="chkRMACreditVerification" runat ="server" Text="RMA Credit Verification" AutoPostBack = "true" OnCheckedChanged ="chkRMACreditVerification_Change" visible="false"/>&nbsp;<asp:CheckBox ID="chkRMAEscalation" runat ="server" Text="RMA Escalation" OnCheckedChanged="chkRMAEscalation_change" AutoPostBack = "true" visible="false"/>&nbsp;<asp:CheckBox ID="chkNeedUpdateID" runat="server" Text="NeedUpdate" Visible = "False" />&nbsp;<asp:DropDownList ID="drpAgents" runat="server" AutoPostBack="true" visible="False"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="btnCoreReturns" runat="server" Text="Core Returns" OnClick="btnCoreReturns_Click" visible="false"/>&nbsp;&nbsp;&nbsp;<asp:DropDownList ID="drpPartners" runat="server" AutoPostBack="true" OnSelectedIndexChanged="drpPartners_SelectedIndexChanged" visible="false"/>&nbsp;&nbsp;<asp:Label ID="lblEmailTech" runat ="server" visible="false"/>&nbsp;&nbsp;<asp:Button ID="btnCharge" runat="server" Text="Charge" OnClick="btnCharge_Click" Visible="false"  />&nbsp;&nbsp;<asp:Button ID="btnClear" runat="server" Text="Clear" OnClick="btnClear_Click" Visible="false" />
            <div class="bandheader">&nbsp;</div>
          </td>
          </tr>
        <tr>
            <td id="lstPartners" runat ="server" class="band" style="width: 1%">
                <div >
                    <asp:DataGrid ID="dgvVendors" runat="server" ShowHeader="True" ShowFooter="false" AutoGenerateColumns="false" Width ="100%" CssClass="Grid1">
                      <ItemStyle CssClass="bandbar" />
                      <Columns>
                         <asp:BoundColumn DataField="PartnerID" HeaderText="ID" Visible="false" />
                        <asp:TemplateColumn ItemStyle-Wrap="false" HeaderText ="Partners" >
                          <ItemTemplate>
                            <a href="PartsManagementTeam.aspx?id=1&ParID=<%# DataBinder.Eval(Container.DataItem, "PartnerID")%>&CustID=<%# _lngCustID %>&ProgID=<%# _lngProgramID %>&StatusID=<%# _lngStatusID%>&StateID=<%# _lngStateID %>&NP=0&C=0"><%# DataBinder.Eval(Container.DataItem,"ResumeID") %></a>&nbsp;(<%# DataBinder.Eval(Container.DataItem,"Total") %>)
                          </ItemTemplate>
                        </asp:TemplateColumn>
                      </Columns> 
                    </asp:DataGrid>
                </div>
            </td>
          <td>
            <div class="inputformsectionheader">
                <asp:Label ID="lblTicketCount" runat="server"></asp:Label>
                <asp:DropDownList ID="drpCustomers1" runat="server" AutoPostBack="True" OnSelectedIndexChanged="drpCustomers1_SelectedIndexChanged" />&nbsp;<asp:DropDownList ID="drpProgram" runat="server" AutoPostBack="true"  /> 
                <asp:DropDownList ID="drpCustomers2" Runat="server" Visible="False" />
                
                <asp:DropDownList ID="drpStatus" Runat="server" AutoPostBack="True" />
                
                <asp:DropDownList ID="drpProgram2" Runat="server" Visible="False" />
                
                <asp:DropDownList ID="drpState" Runat="server" AutoPostBack="True" />
            </div>
            <div class="inputform">
            <asp:MultiView ID="Multiview1" runat="server" ActiveViewIndex="0" >
          <asp:View ID="viewA"  runat="server">

              <asp:DataGrid AllowSorting="true" ID="dgvTickets" AutoGenerateColumns="false" runat="server" style="background-color: White; width: 100%" OnSortCommand="dgvTickets_SortCommand" CssClass="Grid1">
                <AlternatingItemStyle CssClass="altrow" />
                <HeaderStyle CssClass="gridheader" />
                <Columns>
                  <asp:BoundColumn DataField="TicketID" HeaderText="ID" Visible="false" />
                  <asp:TemplateColumn SortExpression="TicketID" HeaderText="Ticket&nbsp;ID">
                    <ItemTemplate>
                      <a target="_blank" href="ticket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>"><%# DataBinder.Eval(Container.DataItem,"TicketID") %></a><a target="_blank" href="printableticket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>"><img style="border: 0" alt="Printable Version" src="/graphics/printable.png" /></a>
                    </ItemTemplate>
                  </asp:TemplateColumn>
		            <asp:BoundColumn SortExpression="Age" HeaderText="Age" DataField="Age" />
                  <asp:TemplateColumn SortExpression="CustomerID" HeaderText="Customer">
                    <ItemTemplate>
                      <a href="customer.aspx?id=<%# DataBinder.Eval(Container.DataItem,"CustomerID") %>"><%#DetermineCustomerLabel(DataBinder.Eval(Container.DataItem, "Company"), DataBinder.Eval(Container.DataItem, "CompanyContact"))%></a>
                    </ItemTemplate>
                  </asp:TemplateColumn>
                  <asp:BoundColumn SortExpression="Status" HeaderText="Status" DataField="Status" />
                  <asp:BoundColumn SortExpression="ContactLastName" HeaderText="EULastName" DataField="ContactLastName" />
                  <asp:BoundColumn SortExpression="ServiceType" HeaderText="Program" DataField="ServiceType" />
                  <asp:TemplateColumn SortExpression="ServiceID" HeaderText="Service SKU">
                    <ItemTemplate>
                      <a target="_blank" href="servicedetail.aspx?id=<%# DataBinder.Eval(Container.DataItem,"ServiceID") %>"><%# DataBinder.Eval(Container.DataItem,"ServiceName") %></a>
                    </ItemTemplate>
                  </asp:TemplateColumn>
                  
                  <asp:TemplateColumn
                    SortExpression="CustomerPrioritySetting"
                    HeaderText="C&nbsp;Priority"
                    >
                  <ItemTemplate>
                    <img alt="Internal Priority" src="../graphics/level<%# Databinder.eval(Container.DataItem,"CustomerPrioritySetting") %>.png" />          
                  </ItemTemplate>
                  </asp:TemplateColumn>
                  <asp:BoundColumn SortExpression="City" DataField="City" HeaderText="City" />
                  <asp:BoundColumn SortExpression="Abbreviation" DataField="Abbreviation" HeaderText="State" />                  
                  <asp:TemplateColumn
                    SortExpression="ZipCode"
                    HeaderText="Zip"
                    >
                    <ItemTemplate>
                      <a href="findzipcode.aspx?zip=<%# Databinder.eval(Container.DataItem,"ZipCode") %>&id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %> " target="_blank"><%# Databinder.eval(Container.DataItem,"ZipCode") %></a>
                    </ItemTemplate>
                  </asp:TemplateColumn>                  
                  <asp:BoundColumn SortExpression="ETA" HeaderText="ETA" DataField="ETA" Visible="True" />        
                  <asp:BoundColumn SortExpression="ScheduledEndDate" HeaderText="Schedule Date" DataField="ScheduledEndDate" />        
                </Columns>
              </asp:DataGrid>
              </asp:View>
              <asp:View ID="viewB" runat="server">
              <div class="inputformsectionheader"><asp:ImageButton ID="btnExport" AlternateText ="Export to Excel" ImageUrl ="/images/Excel-16.gif"  ImageAlign="right"  OnClick="btnExport_Click" runat="server"/></div> 
              <div class="inputformsectionheader">&nbsp;</div>
              <div class="inputformsectionheader"><asp:Label ID="lblTicketCount1" runat="server"></asp:Label> Tickets Needing Part Returned</div>
              <asp:DataGrid ID="dgvOpenWorkOrders" runat="server" style="width: 100%; background-color:White;" AutoGenerateColumns="false" ShowFooter="True" CssClass="Grid1"><FooterStyle  HorizontalAlign="Right" BackColor="#C0C0C0" CssClass="Grid1"/>
              <HeaderStyle CssClass="gridheader" />
               <AlternatingItemStyle CssClass="altrow" />
                 <Columns>
                   <asp:TemplateColumn >
                      <ItemTemplate>
                         <asp:CheckBox ID="chkSelected" runat="server"   />
                      </ItemTemplate>
                   </asp:TemplateColumn>
                   <asp:BoundColumn HeaderText="ID" DataField="TicketComponentID" visible="false" />
                   <asp:TemplateColumn HeaderText="Ticket ID">
                     <ItemTemplate>
                        <a target="_blank" href="ticket.aspx?id=<%# Databinder.Eval(Container.DataItem,"TicketID") %>&returnurl=workoders.aspx&act=G"><%# Databinder.Eval(Container.DataItem,"TicketID") %></a>
                     </ItemTemplate>
                   </asp:TemplateColumn>
                  <asp:BoundColumn HeaderText="Age" DataField="Age" />
                  <asp:BoundColumn HeaderText="Customer" DataField="Company" />
                  <asp:BoundColumn HeaderText="Supplier" DataField="Supplier" />
                  <asp:BoundColumn HeaderText="Status" DataField="Status" />
                  <asp:BoundColumn HeaderText="PartNumber" DataField="Code" />
                  <asp:BoundColumn HeaderText="Description" DataField="Component" />
                  <asp:BoundColumn HeaderText="PartCost" DataField="PartCost" DataFormatString="{0:c}" Visible="false"/>
                  <asp:TemplateColumn SortExpression="PartCost" HeaderText="PartCost" ItemStyle-HorizontalAlign="Right">
                    <ItemTemplate>
                        <asp:Literal id="lblTotal" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "PartCost")%>' />
                    </ItemTemplate>
                    <FooterTemplate >
                    <asp:Literal id="lblGrandTotalAmount" runat="server" />
                  </FooterTemplate>

                  </asp:TemplateColumn>
                  <asp:BoundColumn HeaderText="ReturnType" DataField="Destination" />
                  <asp:TemplateColumn HeaderText="TrackingNumber">
                          <ItemTemplate>
                            <a target="_blank" href="<%# Databinder.eval(Container.DataItem,"TrackingScript").ToString.Replace("$shippinglabel",DataBinder.Eval(Container.DataItem,"ShippingLabel")) %>"><%# DataBinder.Eval(Container.DataItem,"ShippingLabel") %></a>                    
                          </ItemTemplate>
                  </asp:TemplateColumn>
                  <asp:BoundColumn HeaderText="LabelID" DataField="ShippingLabelID" visible="false" />  
                  <asp:BoundColumn DataField="TicketID" HeaderText="ID" Visible="false" />    
               </Columns>      
            </asp:DataGrid>
              </asp:View>
           </asp:MultiView>
            </div>
          </td>
        </tr>
      </tbody>
    </table>
  </form>
  <asp:Label ID="lblSortOrder" runat="server" Visible="false" />
</asp:Content>