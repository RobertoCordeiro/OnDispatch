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
    Private _Age1ID As Long = 10
    Private _Age2ID As Long = 6000
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
        lblTicketCount.Text = ""
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
            Master.PageHeaderText = "Client Services"
            Master.PageTitleText = "Client Services"
            Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; Client Services"
    End If
    Try
            _ID = CType(Request.QueryString("id"), Long)
            _lngButtonOption = CType(Request.QueryString("id"), Long)
            _lngCustID = CType(Request.QueryString("CustID"), Long)
            _lngStatusID = CType(Request.QueryString("StatusID"), Long)
            _lngProgramID = CType(Request.QueryString("ProgID"), Long)
            _lngStateID = CType(Request.QueryString("StateID"), Long)
            _chkNeedUpdate = CType(Request.QueryString("NP"), Boolean)
            _lngColor = CType(Request.QueryString("C"), Long)
            _ParID = CType(Request.QueryString("ParID"), Long)
            
            'If _ID < 1 Then
            '    _ID = 4
            'End If
      Catch ex As Exception
        _ID = 1
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
                    btnClear.Visible = false
                    If _ParID = 0 Then
                       LoadTickets(29, _lngButtonOption)
                    Else
                       LoadTickets(28, _lngButtonOption)
                    End If
                End If
                
                If _lngButtonOption = 2 Then 'extra work needing approval
                    btnETA2.BorderColor = Drawing.Color.Blue
                    drpPartners.Visible = False
                    btnCharge.Visible = False
                    btnClear.Visible = false
                    If _ParID = 0 Then
                       LoadTickets(32, _lngButtonOption)
                    Else
                       LoadTickets(28, _lngButtonOption)
                    End If
                End If
                
                If _lngButtonOption = 3 Then 'Need EU Payment
                    btnETA3.BorderColor = Drawing.Color.Blue
                    drpPartners.Visible = False
                    btnCharge.Visible = False
                    btnClear.Visible = False
                    If _ParID = 0 Then
                        LoadTickets(37, _lngButtonOption)
                    Else
                        LoadTickets(28, _lngButtonOption)
                    End If
                End If
                
                If _lngButtonOption = 4 Then  'Back Order
                    btnAll.BorderColor = Drawing.Color.Blue
                    drpPartners.Visible = False
                    btnCharge.Visible = False
                    btnClear.Visible = False
                    If _ParID = 0 Then
                        LoadTickets(31, _lngButtonOption)
                    Else
                        LoadTickets(28, _lngButtonOption)
                    End If
                End If
                If _lngButtonOption = 5 Then  'Needing Authorization
                    btnAuthorizations.BorderColor = Drawing.Color.Blue
                    drpPartners.Visible = False
                    btnCharge.Visible = False
                    btnClear.Visible = false
                    If _ParID = 0 Then
                       LoadTickets(30, _lngButtonOption)
                    Else
                       LoadTickets(28, _lngButtonOption)
                    End If
                End If
                If _lngButtonOption = 6 Then  'Over 10 days
                    btnOver10.BorderColor = Drawing.Color.Blue
                    drpPartners.Visible = False
                    btnCharge.Visible = False
                    btnClear.Visible = False
                    If _ParID = 0 Then
                        LoadTickets(2, _lngButtonOption)
                    Else
                        LoadTickets(2, _lngButtonOption)
                    End If
                End If
                If _lngButtonOption = 9 Then  'RMA Requests
                    btnRMA.BorderColor = Drawing.Color.Blue
                    drpPartners.Visible = False
                    btnCharge.Visible = False
                    btnClear.Visible = False
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
             end if
        Else

            If drpCustomers1.SelectedValue <> "Assign Customer" And drpProgram.SelectedValue = "Assign Program" Then
                LoadPrograms1(drpCustomers1.SelectedValue)
                If _lngButtonOption <> 0 Then
                    Select Case _lngButtonOption
                        
                        Case Is = 1
                            LoadTickets(29, _lngButtonOption)
                        Case Is = 2
                            LoadTickets(32, _lngButtonOption)
                        Case Is = 3
                            LoadTickets(37, _lngButtonOption)
                        Case Is = 4
                            LoadTickets(31, _lngButtonOption)
                        Case Is = 5
                            LoadTickets(30, _lngButtonOption)
                        Case Is = 6
                            LoadTickets(2, _lngButtonOption)
                        
                        Case Else
                            LoadTickets(2, _lngButtonOption)
                        
                    End Select
                    
                Else
                    'LoadTickets(0, 0)
                End If
            Else
                If drpProgram.SelectedValue = "Assign By Program" Then
                    drpProgram.Items.Clear()
                    drpProgram.Items.Add("Assign Program")
                    drpProgram.SelectedValue = "Assign Program"
                Else
                    If _ParID = 0 Then
                        'LoadTickets(2, _lngButtonOption)
                    Else
                        'LoadTickets(7, _lngButtonOption)
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
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByCSPSPartsConsole", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                            Else
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByCSPSPartsConsole1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                            End If
                        Else
                            'Filter by Customer, status and program
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByCSPPartsConsole1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                            Else
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByCSPPartsConsole", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                            End If
                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter by customer, Status and State
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByCSSPartsConsole1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                            Else
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByCSSPartsConsole", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                            End If
                        Else
                            'Filter by Customer Status
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByCSPartsConsole1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                            Else
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByCSPartsConsole", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                            End If
                        End If

                    End If
                Else
                    If drpProgram.SelectedValue <> "Assign Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter by Customer, Program and State
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByCPSPartsConsole1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                            Else
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByCPSPartsConsole", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                            End If
                        Else
                            'Filter By Customer, Program
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByCPPartsConsole1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                            Else
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByCPPartsConsole", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                            End If
                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By Customer, State
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByCStatePartsConsole1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                            Else
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByCStatePartsConsole", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                            End If
                        Else
                            'Filter By Customer
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByCustomerPartsConsole1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                            Else
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByCustomerPartsConsole", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
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
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByStatusStatePartsConsole1", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                            Else
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByStatusStatePartsConsole", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                            End If
                        Else
                            'Filter By Status and program
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByStatusPartsConsole1", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                            Else
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByStatusPartsConsole", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                            End If
                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By status and State
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByStatusStatePartsConsole1", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                            Else
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByStatusStatePartsConsole", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                            End If
                        Else
                            'Filter By Status
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByStatusPartsConsole1", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                            Else
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByStatusPartsConsole", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                            End If
                        End If
                    End If
                Else
                    If drpProgram.SelectedValue <> "Assign Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By Program and state
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByStatePartsConsole1", "@TicketFolderID", lngTicketFolderID, "@StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                            Else
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByStatePartsConsole", "@TicketFolderID", lngTicketFolderID, "@StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                            End If
                        Else
                            'Filter By Program
                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By State
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByStatePartsConsole1", "@TicketFolderID", lngTicketFolderID, "@StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                            Else
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByStatePartsConsole", "@TicketFolderID", lngTicketFolderID, "@StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                            End If
                        Else
                            'Dont filter - Show all the tickets in the folder
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByPartsConsole1", "@TicketFolderID", lngTicketFolderID, "@Temp", 0, "CountryID", _CountryID, dgvTickets)
                            
                            Else
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByPartsConsole", "@TicketFolderID", lngTicketFolderID, "@Temp", 0, "CountryID", _CountryID, dgvTickets)
                            End If
                        End If
                    End If
                End If
        
            End If
            lblTicketCount.Text = " [ " & CType(dgvTickets.DataSource, Data.DataSet).Tables(0).Rows.Count & " ] "
        Else
            If _lngButtonOption = 6 Then
                If drpCustomers1.SelectedValue <> "Assign Customer" Then
                    If drpStatus.SelectedValue <> "Filter By Status" Then
                        If drpProgram.SelectedValue <> "Assign Program" Then
                            If drpState.SelectedValue <> "Filter By State" Then
                                'Filter by Customer, status, Program and state
                                ldr1.LoadEightLongParameterDataGrid("spListTicketsInFolderByCSPSETA", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", _Age1ID, "@Age2", _Age2ID, "CountryID", _CountryID, dgvTickets)
                            Else
                                'Filter by Customer, status and program
                                ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByCSPETA", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "@Age1", _Age1ID, "@Age2", _Age2ID, "CountryID", _CountryID, dgvTickets)
                            End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter by customer, Status and State
                                ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByCSSETA", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", _Age1ID, "@Age2", _Age2ID, "CountryID", _CountryID, dgvTickets)
                            
                        Else
                            'Filter by Customer Status
                            
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByCSETA", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "@Age1", _Age1ID, "@Age2", _Age2ID, "CountryID", _CountryID, dgvTickets)
                            
                            End If

                        End If
                Else
                    If drpProgram.SelectedValue <> "Assign Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter by Customer, Program and State
                            
                                ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByCPSETA", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", _Age1ID, "@Age2", _Age2ID, "CountryID", _CountryID, dgvTickets)
                            
                            Else
                                'Filter By Customer, Program
                                
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByCPETA", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "@Age1", _Age1ID, "@Age2", _Age2ID, "CountryID", _CountryID, dgvTickets)
                            
                            End If
                        Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By Customer, State
                            
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByCStateETA", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", _Age1ID, "@Age2", _Age2ID, "CountryID", _CountryID, dgvTickets)
                            
                        Else
                            'Filter By Customer
                            
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByCustomerETA", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "@Age1", _Age1ID, "@Age2", _Age2ID, "CountryID", _CountryID, dgvTickets)
                            
                            End If
                        End If

                    End If
            Else
                If drpStatus.SelectedValue <> "Filter By Status" Then
                    If drpProgram.SelectedValue <> "Assign Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By status, Program and state
                            
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByStatusStateETA", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", _Age1ID, "@Age2", _Age2ID, "CountryID", _CountryID, dgvTickets)
                           
                            Else
                                'Filter By Status and program
                                
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByStatusETA", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "@Age1", _Age1ID, "@Age2", _Age2ID, "CountryID", _CountryID, dgvTickets)
                            
                            End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By status and State
                            
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByStatusStateETA", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", _Age1ID, "@Age2", _Age2ID, "CountryID", _CountryID, dgvTickets)
                            
                        Else
                            'Filter By Status
                            
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByStatusETA", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "@Age1", _Age1ID, "@Age2", _Age2ID, "CountryID", _CountryID, dgvTickets)
                           
                            End If
                        End If
                    Else
                    If drpProgram.SelectedValue <> "Assign Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By Program and state
                            
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByStateETA", "@TicketFolderID", lngTicketFolderID, "@StateID", CType(drpState.SelectedValue, Long), "@Age1", _Age1ID, "@Age2", _Age2ID, "CountryID", _CountryID, dgvTickets)
                            
                            Else
                                'Filter By Program
                            End If
                        Else
                            If drpState.SelectedValue <> "Filter By State" Then
                                'Filter By State
                                
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByStateETA", "@TicketFolderID", lngTicketFolderID, "@StateID", CType(drpState.SelectedValue, Long), "@Age1", _Age1ID, "@Age2", _Age2ID, "CountryID", _CountryID, dgvTickets)
                            
                            Else
                            'Dont filter - Show all the tickets in the folder
                            
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByETA", "@TicketFolderID", 2, "@Temp", 0, "@Age1", _Age1ID, "@Age2", _Age2ID, "CountryID", _CountryID, dgvTickets)
                            
                            End If
                        End If
                    End If
        
                End If
                lblTicketCount.Text = " [ " & CType(dgvTickets.DataSource, Data.DataSet).Tables(0).Rows.Count & " ] "
            Else
            Multiview1.ActiveViewIndex = 1
                Select _lngButtonOption
               
                    Case Is = 7
                       
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
                    Case Is = 9
                        If drpCustomers1.SelectedValue = "Assign Customer" Then
                            ldr.LoadSimpleDataGrid("spListPartsNeedReturnedRA", dgvOpenWorkOrders)
                        Else
                            ldr.LoadSingleLongParameterDataGrid("spListPartsNeedReturnedRAByCustomer", "@CustomerID", CType(drpCustomers1.SelectedValue, Long), dgvOpenWorkOrders)
                        End If
                  
                        lblTicketCount1.Text = " [ " & CType(dgvOpenWorkOrders.DataSource, Data.DataSet).Tables(0).Rows.Count & " ] "
                End Select
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
        If _lngButtonOption < 7 Then
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
    
        ldr.LoadSimpleDropDownList("spListStatusesForCustomerService", "Status", "TicketStatusID", drpStatus)
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
        Response.Redirect("ClientServices.aspx?id=" & _lngButtonOption & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&C=0", True)
    End Sub
    Private Sub btnETA2_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim lngCustomerID As Long
        Dim lngProgramID As Long
        Dim lngStatusID As Long
        Dim lngStateID As Long
        Dim boolNeedUpdate As Boolean
        
        Multiview1.ActiveViewIndex = 0
        
        _lngButtonOption = 2 'Extra work needing approval
        
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
        Response.Redirect("ClientServices.aspx?id=" & _lngButtonOption & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&C=0", True)
    End Sub
    Private Sub btnETA3_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim lngCustomerID As Long
        Dim lngProgramID As Long
        Dim lngStatusID As Long
        Dim lngStateID As Long
        Dim boolNeedUpdate As Boolean
        
        Multiview1.ActiveViewIndex = 0
        
        _lngButtonOption = 3 ' Need EU Payment
        
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
        Response.Redirect("ClientServices.aspx?id=" & _lngButtonOption & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&C=0", True)
    End Sub
    Private Sub btnAll_Click(ByVal S As Object, ByVal E As EventArgs)
        ' Show all tickets for a customer
        Dim lngCustomerID As Long
        Dim lngProgramID As Long
        Dim lngStatusID As Long
        Dim lngStateID As Long
        Dim boolNeedUpdate As Boolean
        
        Multiview1.ActiveViewIndex = 0
        
        _lngButtonOption = 4 ' Back Order
        
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
        Response.Redirect("ClientServices.aspx?id=" & _lngButtonOption & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&C=0", True)
        
    End Sub
    
    Private Sub btnAuthorizations_Click(ByVal S As Object, ByVal E As EventArgs)
        ' Show all tickets for a customer
        Dim lngCustomerID As Long
        Dim lngProgramID As Long
        Dim lngStatusID As Long
        Dim lngStateID As Long
        Dim boolNeedUpdate As Boolean
        
        Multiview1.ActiveViewIndex = 0
        
        _lngButtonOption = 5 ' Need Authorization
        
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
        Response.Redirect("ClientServices.aspx?id=" & _lngButtonOption & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&C=0", True)
        
    End Sub
    
    Private Sub btnRMA_Click(ByVal S As Object, ByVal E As EventArgs)
        ' Show tickets needing RMA requests
        Dim lngCustomerID As Long
        Dim lngProgramID As Long
        Dim lngStatusID As Long
        Dim lngStateID As Long
        Dim boolNeedUpdate As Boolean
        
        Multiview1.ActiveViewIndex = 1
        
        _lngButtonOption = 9 ' Need RMA requested
        
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
        Response.Redirect("ClientServices.aspx?id=" & _lngButtonOption & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&C=0", True)
        
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
            Response.Redirect("ClientServices.aspx?id=" & _lngButtonOption & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&C=0", True)
        else
            Response.Redirect("ClientServices.aspx?id=" & _lngButtonOption & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&ParID=" & CType(drpPartners.SelectedValue, Long) & "&C=0", True)

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
            _lngButtonOption = 9
        
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
        
            Response.Redirect("ClientServices.aspx?id=" & _lngButtonOption & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&ParID=" & CType(drpPartners.SelectedValue, Long) & "&C=0", True)
            
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
    
    Private Sub btnOver10_Click(ByVal S As Object, ByVal E As EventArgs)
        ' Show tickets over 10 days old
        Dim lngCustomerID As Long
        Dim lngProgramID As Long
        Dim lngStatusID As Long
        Dim lngStateID As Long
        Dim boolNeedUpdate As Boolean
        
        Multiview1.ActiveViewIndex = 1
        
        _lngButtonOption = 6 ' Over 10 days
        
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
            btnOver10.BorderColor = Drawing.Color.Black
        Else
            btnOver10.BorderColor = Drawing.Color.Blue
        End If
        'LoadTickets(CType(2, Long), _lngButtonOption)
        Response.Redirect("ClientServices.aspx?id=" & _lngButtonOption & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&C=0", True)
        
    End Sub
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmTickets" runat="server">
    <table style="width: 100%">
      <tbody>
        <tr style="width: 100%">
          <td class="band">
            <div class="bandheader">&nbsp;</div>
            <asp:Button ID="btnOrderParts" runat="server" Text="Order Parts"  OnClick="btnOrderParts_Click" Visible="false" />&nbsp;<asp:Button ID="btnETA2" runat="server" Text="Extra Approval" OnClick="btnETA2_Click" />&nbsp;<asp:Button ID="btnETA3" runat="server" Text="EU Payment" OnClick="btnETA3_Click" />&nbsp;<asp:Button ID="btnAll" runat="server" Text="Back Order" OnClick="btnAll_Click" />&nbsp;<asp:Button ID="btnAuthorizations" runat="server" Text="Authorizations" OnClick="btnAuthorizations_Click" />&nbsp;<asp:Button ID="btnOver10" runat="server" Text="Over 10"  OnClick="btnOver10_Click" />&nbsp;&nbsp;<asp:Button ID="btnRMA" runat="server" Text="RMA Requests" OnClick="btnRMA_Click" />&nbsp;<asp:CheckBox ID="chkNeedUpdateID" runat="server" Text="NeedUpdate" Visible = "False" />&nbsp;<asp:DropDownList ID="drpAgents" runat="server" AutoPostBack="true" visible="False" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="btnCoreReturns" runat="server" Text="Core Returns" OnClick="btnCoreReturns_Click" />&nbsp;&nbsp;&nbsp;<asp:DropDownList ID="drpPartners" runat="server" AutoPostBack="true" OnSelectedIndexChanged="drpPartners_SelectedIndexChanged" />&nbsp;&nbsp;<asp:Label ID="lblEmailTech" runat ="server" />&nbsp;&nbsp;<asp:Button ID="btnCharge" runat="server" Text="Charge" OnClick="btnCharge_Click" Visible="false"  />&nbsp;&nbsp;<asp:Button ID="btnClear" runat="server" Text="Clear" OnClick="btnClear_Click" Visible="false"  />
            <div class="bandheader">&nbsp;</div>
          </td>
          </tr>
        <tr>
          <td>
            <div class="inputformsectionheader">
                <asp:Label ID="lblTicketCount" runat="server"></asp:Label>
                <asp:DropDownList ID="drpCustomers1" runat="server" AutoPostBack="true" OnSelectedIndexChanged="drpCustomers1_SelectedIndexChanged" />&nbsp;<asp:DropDownList ID="drpProgram" runat="server" AutoPostBack="true"  /> 
                <asp:DropDownList ID="drpCustomers2" Runat="server" Visible="False" />
                
                <asp:DropDownList ID="drpStatus" Runat="server" AutoPostBack="True" />
                
                <asp:DropDownList ID="drpProgram2" Runat="server" Visible="False" />
                
                <asp:DropDownList ID="drpState" Runat="server" AutoPostBack="True" />
            </div>
            <div class="inputform">
            <asp:MultiView ID="Multiview1" runat="server" ActiveViewIndex="0" >
          <asp:View ID="viewA"  runat="server">
              <asp:DataGrid AllowSorting="true" ID="dgvTickets" AutoGenerateColumns="false" runat="server" style="background-color: White; width: 100%" OnSortCommand="dgvTickets_SortCommand">
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
              <asp:DataGrid ID="dgvOpenWorkOrders" runat="server" style="width: 100%; background-color:White;" AutoGenerateColumns="false">
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
                  <asp:BoundColumn HeaderText="PartCost" DataField="PartCost" DataFormatString="{0:c}"/>
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