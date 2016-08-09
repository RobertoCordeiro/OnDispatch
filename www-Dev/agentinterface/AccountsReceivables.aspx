﻿<%@ Page Language="vb" masterpagefile="~/masters/agent.master" MaintainScrollPositionOnPostback = "True" %>

<%@ Register Assembly="RadCalendar.Net2" Namespace="Telerik.WebControls" TagPrefix="rad" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<%@ Import Namespace="LGInterface" %>
<script runat="server">
    'from tab 2
    Private _ID As Long = 0
    Private _CustomerID As Long = 0
    Private _StatusID As Long = 0
    Private _Tab As Long = 0
    Private _Dt1 As Date = Format(Now(), "D")
    Private _Dt2 As Date = Format(Now(), "D")
    'from tab 1
    Private mListLaborTotal As Double
    Private mListPartsTotal As Double
    Private mListChargedTotal As Double
    Private mListPaidTotal As Double
    Private mListDueTotal As Double
    Private mFocus As Integer
    Private mCheckedTotal As Double
    Private mListTotal As Double
    Private mTotalCustomer As Double
    Private mTotalPartAmount As Double
    Private mTotalAmountPaid As Double
    Private mTotalOutstanding As Double
    'tab 0
    Private _CustID As Long
    Private mLaborTotal As Double
    Private mExtraTotal As Double
    Private mPartTotal As Double
    Private mTotal As Double
    Private mTotalSelected As Double

    Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
        If User.Identity.IsAuthenticated Then
            Master.WebLoginID = CType(User.Identity.Name, Long)
            Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Customer"
            Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Customer Control"
            Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""customers.aspx"">Customer Management</a> &gt; Customer"
        End If
        lblReturnUrl.Text = Request.QueryString("returnurl")
        
        Try
            _Tab = CType(Request.QueryString("t"), Long)
        Catch ex As Exception
            _Tab = 0
        End Try
        Try
            _ID = CType(Request.QueryString("id"), Long)
        Catch ex As Exception
            _ID = 0
        End Try
               
        Try
            _CustID = CType(Request.QueryString("c"), Long)
        Catch ex As Exception
            _CustID = 0
        End Try
        mLaborTotal = 0
        mExtraTotal = 0
        mPartTotal = 0
        mTotal = 0
            
        mListLaborTotal = 0
        mListPartsTotal = 0
        mListChargedTotal = 0
        mListPaidTotal = 0
        mListDueTotal = 0
        mTotalPartAmount = 0
        mTotalAmountPaid = 0
        mTotalOutstanding = 0
                
            
        Try
            _CustomerID = CType(Request.QueryString("custID"), Long)
        Catch ex As Exception
            _CustomerID = 0
        End Try
        Try
            _StatusID = CType(Request.QueryString("StatusID"), Long)
        Catch ex As Exception
            _StatusID = 0
        End Try
        
        Try
            _Dt1 = CType(Request.QueryString("dt1"), Date)
        Catch ex As Exception
            _Dt1 = Format(Now(), "D")

        End Try
        Try
            _Dt2 = CType(Request.QueryString("dt2"), Date)
        Catch ex As Exception
            _Dt2 = Format(Now(), "D")

        End Try
            
        
        
        If _ID > 0 Then
            If Master.InfoID <> _ID Then
                Response.Redirect("/logout.aspx")
            End If
            
            If Not IsPostBack Then
                Select Case _Tab
                    
                    Case Is = 0
                        Multiview1.ActiveViewIndex = 0
                        menu.Items(0).Selected = True
                        If _CustID > 0 Then
                            Multiview2.ActiveViewIndex = 1
                            LoadPriorInvoices()
                            If (Not Page.IsPostBack) Then
                                Session.Clear()
                            End If
                            GetCheckBoxValues()
                            LoadTicketsByCustomer( 1, _CustID)
                            RePopulateCheckBoxes()
                            btnJump.Attributes.Add("onclick", "return confirm('You are about to create an Invoice, do you want to continue?');")

                        Else
                            Multiview2.ActiveViewIndex = 0
                            LoadCustomerTotals()
                            If (Not Page.IsPostBack) Then
                                Session.Clear()
                                If _ID = CLng(1) Then
                                    If IsNothing(Session("SortOrder")) Then
                                        LoadTickets(  _ID, "TicketID ASC")
                                    Else
                                        LoadTickets(_ID, Session("SortOrder"))
                                    End If
                                Else
                                    
                                    LoadTicketsByInvoiceID( _ID, _CustID)
                                    LoadPriorInvoices()
                                    btnJump.Enabled = False
                                End If
                            Else
                                GetCheckBoxValues()
                                LoadTickets(_ID, Session("SortOrder"))
                                RePopulateCheckBoxes()
               
                            End If
                        End If
                        If _StatusID = 0 Then
                            If _CustomerID = 0 Then
                                LoadCustomers()
                                LoadMethods()
                                'GetStatuses()
                                RadDatePickerFrom.SelectedDate = DateTime.Now.Date
                                RadDatePickerTo.SelectedDate = DateTime.Now.Date
                            Else
                                LoadCustomers()
                                drpCustomers.SelectedValue = _CustomerID
                                RadDatePickerFrom.SelectedDate = _Dt1
                                RadDatePickerTo.SelectedDate = _Dt2
                                LoadData()
                            End If
                        End If
                        LoadMethods()
                    Case Is = 1
                        txtCheckNumber.Text = ""
                        txtInvoiceNumber.Text = ""
                        txtTicketID.Text = ""
                        LoadMethods()
                        LoadPartners()
                        Dim datDate2 As DateTime
                        If Calendar1.SelectedDate = "#12:00:00 AM#" Then
                            datDate2 = Now()
                        Else
                            datDate2 = Calendar1.SelectedDate & " 23:29:00"
                        End If
                        Multiview1.ActiveViewIndex = 1
                        menu.Items(1).Selected = True
                    Case Is = 2
                        If _StatusID = 0 Then
                            
                            LoadCustomers()
                            'LoadStatuses()
                            GetStatuses()
                            RadDatePickerFrom.SelectedDate = DateTime.Now.Date
                            RadDatePickerTo.SelectedDate = DateTime.Now.Date
                            Multiview1.ActiveViewIndex = _Tab
                            menu.Items(_Tab).Selected = True
                        Else
                            LoadCustomers()
                            drpCustomers.SelectedValue = _CustomerID
                            RadDatePickerFrom.SelectedDate = _Dt1
                            RadDatePickerTo.SelectedDate = _Dt2
                            LoadData()
                            Multiview1.ActiveViewIndex = _Tab
                            menu.Items(_Tab).Selected = True
                            For Each itm As DataGridItem In dgvStatuses.Items
                                If CType(itm.Cells(0).Text, Long) = _StatusID Then
                                    itm.CssClass = "selectedbandbar"
                                End If
                            Next
                            Multiview2.ActiveViewIndex = 0
                            LoadCustomerTotals()
                            LoadMethods()
                        End If
                End Select
            Else
                Select Case _Tab
                    Case Is = 0
                       
                        GetCheckBoxValues()
                        LoadTickets(_ID, Session("SortOrder"))
                        RePopulateCheckBoxes()
                        
                    Case Is = 1
                        
                        
                    Case Is = 2
                        If drpCustomers.SelectedValue <> "Assign Customer" Then
                            LoadData()
                        End If
                End Select
            End If
        End If
        
    End Sub
    
    Private Sub menu_MenuItemClick(ByVal sender As Object, ByVal e As MenuEventArgs) Handles menu.MenuItemClick
        Multiview1.ActiveViewIndex = Int32.Parse(e.Item.Value)
        Select Case Int32.Parse(e.Item.Value)
            
            Case Is = 0 'Bill Customer
                _Tab = 0
            Case Is = 1 'Receive Payments
                _Tab = 1
            Case Is = 2 'Reconciliation
                _Tab = 2
                
                
        End Select
        
    End Sub
    
    Private Sub btnView_Click(ByVal S As Object, ByVal E As EventArgs)
        If Not IsNothing(dgvOutstandingBalance) Then
            _StatusID = 0
            LoadData()
        End If
    End Sub
    Private Sub LoadData()
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim ldr1 As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        If _StatusID = 0 Then
            If drpCustomers.SelectedValue <> "Assign Customer" Then
                ldr.LoadLongTwoDateParameterDataGrid("spOutstandingBalanceByCustomerByDate", "@CustomerID", drpCustomers.SelectedValue, "@FromDate", (RadDatePickerFrom.SelectedDate), "@ToDate", (RadDatePickerTo.SelectedDate), dgvOutstandingBalance)
                lblTicketCount.Text = "Total Tickets: ( " & dgvOutstandingBalance.Items.Count.ToString & " ) "
                ldr1.LoadLongTwoDateParameterDataGrid("spCustomerReconciliationByCustomerID", "@CustomerID", drpCustomers.SelectedValue, "@DateStart", RadDatePickerFrom.SelectedDate.ToString, "@DateEnd", RadDatePickerTo.SelectedDate.ToString, dgvStatuses)
            Else
                
            End If
            
        Else
            ldr.LoadTwoLongTwoDateParameterDataGrid("spOutstandingBalanceByCustomerDateStatus", "@CustomerID", drpCustomers.SelectedValue, "@StatusID", _StatusID, "@FromDate", (RadDatePickerFrom.SelectedDate), "@ToDate", (RadDatePickerTo.SelectedDate), dgvOutstandingBalance)
            lblTicketCount.Text = "Total Tickets: ( " & dgvOutstandingBalance.Items.Count.ToString & " ) "
            ldr1.LoadLongTwoDateParameterDataGrid("spCustomerReconciliationByCustomerID", "@CustomerID", drpCustomers.SelectedValue, "@DateStart", RadDatePickerFrom.SelectedDate.ToString, "@DateEnd", RadDatePickerTo.SelectedDate.ToString, dgvStatuses)
        End If
    End Sub
    Protected Sub dgvOutstandingBalance_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs)
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim ldr1 As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        If lblSortOrder1.Text.ToLower = " asc" Then
            lblSortOrder1.Text = " desc"
        Else
            lblSortOrder1.Text = " asc"
        End If
        If _StatusID = 0 Then
            ldr.LoadLongTwoDateParameterDataGrid("spOutstandingBalanceByCustomerByDate", "@CustomerID", drpCustomers.SelectedValue, "@FromDate", (RadDatePickerFrom.SelectedDate), "@ToDate", (RadDatePickerTo.SelectedDate), dgvOutstandingBalance, True, e, e.SortExpression, lblSortOrder1.Text)
            'lblTicketCount.Text = "Total Tickets: ( " & dgvOutstandingBalance.Items.Count.ToString & " ) "
            'ldr1.LoadLongTwoDateParameterDataGrid("spCustomerReconciliationByCustomerID", "@CustomerID", drpCustomers.SelectedValue, "@DateStart", RadDatePickerFrom.SelectedDate.ToString, "@DateEnd", RadDatePickerTo.SelectedDate.ToString, dgvStatuses)
        Else
            ldr.LoadTwoLongTwoDateParameterDataGrid("spOutstandingBalanceByCustomerDateStatus", "@CustomerID", drpCustomers.SelectedValue, "@StatusID", _StatusID, "@FromDate", (RadDatePickerFrom.SelectedDate), "@ToDate", (RadDatePickerTo.SelectedDate), dgvOutstandingBalance, True, e, e.SortExpression, lblSortOrder1.Text)
            'lblTicketCount.Text = "Total Tickets: ( " & dgvOutstandingBalance.Items.Count.ToString & " ) "
            'ldr1.LoadLongTwoDateParameterDataGrid("spCustomerReconciliationByCustomerID", "@CustomerID", drpCustomers.SelectedValue, "@DateStart", RadDatePickerFrom.SelectedDate.ToString, "@DateEnd", RadDatePickerTo.SelectedDate.ToString, dgvStatuses)
        End If
    End Sub
    Private Sub dgvOutstandingBalance_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgvOutstandingBalance.ItemDataBound
        Dim rowData As Data.DataRowView
        Dim decLaborCharge As Decimal
        Dim decOutstanding As Decimal
        Dim strStatus As String
        Dim price As Decimal
        Dim listLaborChargedLabel As System.Web.UI.WebControls.Literal
        Dim GrandTotalLaborChargedLabel As System.Web.UI.WebControls.Literal
        Dim listPartsChargedLabel As System.Web.UI.WebControls.Literal
        Dim GrandTotalPartsChargedLabel As System.Web.UI.WebControls.Literal
        Dim listTotalChargedLabel As System.Web.UI.WebControls.Literal
        Dim GrandTotalChargedLabel As System.Web.UI.WebControls.Literal
        Dim listTotalUnpaidLabel As System.Web.UI.WebControls.Literal
        Dim GrandTotalUnpaidLabel As System.Web.UI.WebControls.Literal
        Select Case (e.Item.ItemType)
            Case ListItemType.AlternatingItem, ListItemType.EditItem, ListItemType.Item, ListItemType.SelectedItem
                rowData = CType(e.Item.DataItem, Data.DataRowView)
                decLaborCharge = (rowData.Item("AmountCharged"))
                decOutstanding = (rowData.Item("Outstanding"))
                If Not IsDBNull((rowData.Item("StatusDescription"))) Then
                    strStatus = (rowData.Item("StatusDescription"))
                Else
                    strStatus = ""
                End If
                If decLaborCharge <> decOutstanding Then
                    If strStatus <> "Processing" And strStatus <> "" Then
                        e.Item.ForeColor = Drawing.Color.Red
                    Else
                        e.Item.ForeColor = Drawing.Color.Blue
                    End If
                Else
                    If strStatus = "" Then
                        e.Item.ForeColor = Drawing.Color.Blue
                    End If
                End If
                'get the value for the Labor and add it to the sum
                If Not IsDBNull(rowData.Item("AmountCharged")) Then
                    price = CDec(rowData.Item("AmountCharged"))
                    mListLaborTotal += price
                End If
                'get the control used to display the PartAmount price
                listLaborChargedLabel = CType(e.Item.FindControl("lblLaborTotal"), System.Web.UI.WebControls.Literal)
                'now format the discounted price in currency format
                listLaborChargedLabel.Text = price.ToString("C2")
                
                'get the value for the Labor and add it to the sum
                If Not IsDBNull(rowData.Item("PartsCharged")) Then
                    price = CDec(rowData.Item("PartsCharged"))
                    mListPartsTotal += price
                End If
                'get the control used to display the PartAmount price
                listPartsChargedLabel = CType(e.Item.FindControl("lblPartsTotal"), System.Web.UI.WebControls.Literal)
                'now format the discounted price in currency format
                listPartsChargedLabel.Text = price.ToString("C2")
                
                'get the value for the Labor and add it to the sum
                If Not IsDBNull(rowData.Item("TotalCharged")) Then
                    price = CDec(rowData.Item("TotalCharged"))
                    mListChargedTotal += price
                End If
                'get the control used to display the PartAmount price
                listTotalChargedLabel = CType(e.Item.FindControl("lblTotalCharged"), System.Web.UI.WebControls.Literal)
                'now format the discounted price in currency format
                listTotalChargedLabel.Text = price.ToString("C2")
                
                
                'get the value for the Total and add it to the sum
                If Not IsDBNull(rowData.Item("Outstanding")) Then
                    price = CDec(rowData.Item("Outstanding"))
                    mListTotal += price
                End If
                'get the control used to display the PartAmount price
                listTotalUnpaidLabel = CType(e.Item.FindControl("lblTotal"), System.Web.UI.WebControls.Literal)
          
                'now format the discounted price in currency format
                listTotalUnpaidLabel.Text = price.ToString("C2")
            Case ListItemType.Footer

                'get the control used to display the total of the list prices
                'and set its value to the total of the list prices
                
                GrandTotalUnpaidLabel = CType(e.Item.FindControl("lblGrandTotalAmount"), System.Web.UI.WebControls.Literal)
                GrandTotalUnpaidLabel.Text = mListTotal.ToString("C2")
                
                GrandTotalLaborChargedLabel = CType(e.Item.FindControl("lblGrandTotalLaborAmount"), System.Web.UI.WebControls.Literal)
                GrandTotalLaborChargedLabel.Text = mListLaborTotal.ToString("C2")
                
                GrandTotalPartsChargedLabel = CType(e.Item.FindControl("lblGrandTotalPartsAmount"), System.Web.UI.WebControls.Literal)
                GrandTotalPartsChargedLabel.Text = mListPartsTotal.ToString("C2")
                
                GrandTotalChargedLabel = CType(e.Item.FindControl("lblGrandTotalChargedAmount"), System.Web.UI.WebControls.Literal)
                GrandTotalChargedLabel.Text = mListChargedTotal.ToString("C2")
        End Select
    End Sub
    Private Sub btnExport_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs)
        Dim ex As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
     
        If dgvOutstandingBalance.Items.Count > 0 Then
            ex.ExportGrid("OutstandingBalance.xls", dgvOutstandingBalance)
        End If
    End Sub
    Private Sub GetStatuses()
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSimpleDropDownList("spListTicketClaimApprovalStatuses", "StatusDescription", "TicketClaimApprovalStatusID", drpStatus)
        drpStatus.Items.Add("Filter By Status")
        drpStatus.SelectedValue = "Filter By Status"
    End Sub
    Private Sub LoadStatuses()
        Dim ldr1 As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        'If drpCustomers.SelectedValue <> "Assign Customer" Then
        If _StatusID = 0 Then
            ldr1.LoadLongTwoDateParameterDataGrid("spCustomerReconciliationByCustomerID", "@CustomerID", _CustomerID, "@DateStart", RadDatePickerFrom.SelectedDate.ToString, "@DateEnd", RadDatePickerTo.SelectedDate.ToString, dgvStatuses)
        Else
            If _CustomerID = 0 Then
                ldr1.LoadLongTwoDateParameterDataGrid("spCustomerReconciliationByCustomerID", "@CustomerID", drpCustomers.SelectedValue, "@DateStart", RadDatePickerFrom.SelectedDate.ToString, "@DateEnd", RadDatePickerTo.SelectedDate.ToString, dgvStatuses)
            Else
                ldr1.LoadLongTwoDateParameterDataGrid("spCustomerReconciliationByCustomerID", "@CustomerID", _CustomerID, "@DateStart", RadDatePickerFrom.SelectedDate.ToString, "@DateEnd", RadDatePickerTo.SelectedDate.ToString, dgvStatuses)
            End If
        End If
            
        'End If
    End Sub
    Private Sub LoadCustomers()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        
        ldr.LoadSingleLongParameterDropDownList("spListActiveCustomersByInfoID", "@InfoID", _ID, "Company", "CustomerID", drpCustomers)
        drpCustomers.Items.Add("Assign Customer")
        drpCustomers.SelectedValue = "Assign Customer"
    End Sub
    Private Sub LoadPaidTickets()
        Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim ldl As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim inv As New BridgesInterface.PaymentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim lngCustomerID As Long
        Dim strChangeLog As String
        Dim datDate2 As DateTime
        strChangeLog = ""
        If Calendar1.SelectedDate = "#12:00:00 AM#" Then
            datDate2 = Now()
        Else
            datDate2 = Calendar1.SelectedDate & " 23:59:59"
        End If


        If txtTicketID.Text.ToString <> "" Then
            tkt.Load(CType(txtTicketID.Text, Long))
            lngCustomerID = tkt.CustomerID
            If tkt.InvoiceID <> 0 And Not IsDBNull(tkt.InvoiceID) Then
                inv.Add(tkt.InvoiceID, 1, drpMethod.SelectedValue, CType(txtPaidAmount.Text, Double), datDate2)
                ldl.LoadStringDateParameterDataGrid("spGetPaidInvoices", "@CheckNumber", txtCheckNumber.Text, "@DateCreated", Calendar1.SelectedDate, dgvTickets)
            End If
        Else
            If txtInvoiceNumber.Text <> "" Or Not IsDBNull(txtInvoiceNumber.Text) Then
      
            End If
        End If
    
        For Each itm As DataGridItem In dgvTickets.Items
            If CType(itm.Cells(0).Text, Long) = CType(txtTicketID.Text, Long) Then
                itm.CssClass = "selectedbandbar"
            End If
        Next
    End Sub
    Private Sub RecordPayment()
        Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim invrecord As New BridgesInterface.InvoiceRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim ldl As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim inv As New BridgesInterface.PaymentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim pay As New BridgesInterface.PaymentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim jrn As New BridgesInterface.JournalEntryRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim strChangeLog As String
        Dim datDate2 As DateTime
        Dim lngInvoiceID As Long
    
        strChangeLog = ""
        If Calendar1.SelectedDate = "#12:00:00 AM#" Then
            datDate2 = Now()
        Else
            datDate2 = Calendar1.SelectedDate & " 23:59:59"
        End If
    
        'If txtPaidAmount.Text.ToString <> "" Then
        Select Case drpMethod.SelectedValue
            Case Is = 1, 2, 3, 4, 5, 6, 7, 8, 9, 13 'paying for tickets
                If dgvLabor.Items.Count.ToString <> "" Then
                    If txtTicketID.Text.ToString <> "" Then
                        If txtCheckNumber.Text.ToString <> "" Then
                            ProcessLaborPayment(CLng(txtTicketID.Text))
                        Else
                            MsgBox("You must enter a check number to be processed")
                        End If
                    Else
                        MsgBox("You must enter a Ticket Number to be processed")
                    End If
                Else
                    MsgBox("No Ticket has been found so we can process payment")
                End If
            Case Is = 11, 18, 19 'credit for parts
                If dgvParts.Items.Count > 0 Then
                    If txtTicketID.Text.ToString <> "" Then
                        If txtCheckNumber.Text.ToString <> "" Then
                            ProcessPartsPayment(CLng(txtTicketID.Text))
                        Else
                            MsgBox("You must enter a check number to be processed")
                        End If
                    Else
                        MsgBox("You must enter a Ticket Number to be processed")
                    End If
                Else
                    MsgBox("This ticket has not parts to be credited")
                End If
            Case Is = 16 'vendor payments
                If txtInvoiceNumber.Text <> "" Or Not IsDBNull(txtInvoiceNumber.Text) Then
                    lngInvoiceID = 0
                    lngInvoiceID = GetInvoiceIDByInvoiceNumber(txtInvoiceNumber.Text.ToString)
                    If lngInvoiceID <> 0 Or Not IsDBNull(lngInvoiceID) Then
                        invrecord.Load(lngInvoiceID)
                        inv.Add(invrecord.InvoiceID, 1, drpMethod.SelectedValue, CType(txtPaidAmount.Text, Double), datDate2)
                        inv.CheckNumber = txtCheckNumber.Text.ToString
                        If txtTicketID.Text.ToString <> "" Then
                            inv.TicketID = CType(txtTicketID.Text, Long)
                        Else
                            inv.TicketID = 0
                        End If
                        If txtWorkOrderID.Text.ToString <> "" Then
                            inv.WorkOrderID = CType(txtWorkOrderID.Text, Long)
                        Else
                            inv.WorkOrderID = 0
                        End If
                        inv.Comments = txtComments.Text.ToString
                        inv.Save(strChangeLog)

                        'Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                        'tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, drpMethod.SelectedItem.ToString & ": Payment record has been processed - " & txtTicketID.Text & " / CheckNumber: " & txtCheckNumber.Text)
                        'tnt.CustomerVisible = False
                        'tnt.PartnerVisible = False
                        'tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                        'tnt.Acknowledged = True
                        'tnt.Save(strChangeLog)
          
                        'For Each itm As DataGridItem In dgvTickets.Items
                        'If itm.Cells(2).Text.ToString = txtInvoiceNumber.Text.ToString Then
                        'itm.CssClass = "selectedbandbar"
                        'End If
                        'Next
                        MsgBox("Payment has been recorded into Partner's Account!")
                        txtInvoiceNumber.Text = ""
                        txtCheckNumber.Text = ""
                        txtPaidAmount.Text = ""
                    Else
                        MsgBox("Unable to find Invoice Number. Unable to Update Record in the system.")
                    End If
                    MsgBox("Invoice Number has been recorded as paid. All tickets belonging to this invoice has been updated.")
                Else
                    MsgBox("You must enter an Invoice Number in the field called Invoice Number.")
                End If
            Case Else
        End Select
        ' Else
            
        'MsgBox("You must enter a Dollar Amount to be processed")
        
        'End If
    End Sub
    Private Sub LoadMethods()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSimpleDropDownList("splistPaymentMethods", "Method", "MethodID", drpMethod)
      
    End Sub
    Function GetInvoiceIDByInvoiceNumber(ByVal strInvoiceNumber As String) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetInvoiceIDByInvoiceNumber")
        Dim lngInvoiceID As Long

        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@InvoiceNumber", Data.SqlDbType.VarChar, Len(strInvoiceNumber)).Value = strInvoiceNumber
        cnn.Open()
        cmd.Connection = cnn
        lngInvoiceID = cmd.ExecuteScalar()
        cnn.Close()
        GetInvoiceIDByInvoiceNumber = lngInvoiceID
    End Function
    
    Private Sub LoadTicketsByInvoiceID(ByVal lngInvoiceID As Long, ByVal lngCustomerID As Long)
       
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        'LoadCustomers()
        'LoadPartners()
        'drpPartners.SelectedValue = "Choose One"
        'drpCustomers.SelectedValue = lngCustomerID
        ldr.LoadSingleLongParameterDataGrid("spBillingVerificationByInvoiceID", "@InvoiceID", lngInvoiceID, dgvTickets)
        
        'ldr.LoadTwoLongParameterDataGrid("spListTicketsInFolderByCustomer", "@TicketFolderID", _ID, "@CustomerID", CType(drpCustomers.SelectedValue, Long), dgvTickets)
        lblTicketCount2.Text = " ( " & CType(dgvTickets.DataSource, Data.DataSet).Tables(0).Rows.Count & " ) "
       
    End Sub
  
    Private Sub btnSubmit1_Click(ByVal S As Object, ByVal E As EventArgs)
        RecordPayment()
    
        Dim ldl As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim datDate2 As DateTime
    
        If txtTicketID.Text.ToString <> "" Then
            If Calendar1.SelectedDate = "#12:00:00 AM#" Then
                datDate2 = Now()
            Else
                datDate2 = Calendar1.SelectedDate & " 23:59:59"
            End If
            ldl.LoadSingleLongParameterDataGrid("spOutstandingBalanceByTIcketID", "@TicketID", txtTicketID.Text, dgvLabor)
            ldl.LoadSingleLongParameterDataGrid("spOutstandingPartsPaymentByTicketID", "@TicketID", txtTicketID.Text, dgvParts)
            lblTotalCharge.Text = "Total Charges for this ticket: " & FormatCurrency(GetTotalCharge(txtTicketID.Text), 2)
            lblTotalPayment.Text = "Total Payments for this ticket: " & FormatCurrency(GetTotalPayment(txtTicketID.Text), 2)

            If txtCheckNumber.Text.ToString <> "" Then
                ldl.LoadStringDateParameterDataGrid("spGetPaidInvoices", "@CheckNumber", CType(txtCheckNumber.Text, String), "@DateCreated", datDate2, dgvTickets)
                For Each itm As DataGridItem In dgvTickets.Items
                    If CType(itm.Cells(3).Text, Long) = CType(txtTicketID.Text, Long) Then
                        itm.CssClass = "selectedbandbar"
                    End If
                Next
            End If
        End If
    
    End Sub
    
    Private Sub dgvTickets_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgvTickets.ItemDataBound
        Dim rowData As Data.DataRowView
        Dim price As Decimal
        Dim listAmountChargedLabel As System.Web.UI.WebControls.Literal
        Dim listAmountPaidLabel As System.Web.UI.WebControls.Literal
        Dim listAmountDueLabel As System.Web.UI.WebControls.Literal
        Dim listLaborLabel As System.Web.UI.WebControls.Literal
        Dim listPartsLabel As System.Web.UI.WebControls.Literal
        Dim GrandTotalLaborLabel As System.Web.UI.WebControls.Literal
        Dim GrandTotalPartsLabel As System.Web.UI.WebControls.Literal
        Dim GrandtotalChargeLabel As System.Web.UI.WebControls.Literal
        Dim GrandTotalPaidLabel As System.Web.UI.WebControls.Literal
        Dim GrandTotalDueLabel As System.Web.UI.WebControls.Literal
        Dim datClosingDate As Date
        Dim lblClosingDate As System.Web.UI.WebControls.Literal
        
        'check the type of item that was databound and only take action if it 
        'was a row in the datagrid
        Select Case (e.Item.ItemType)
            Case ListItemType.AlternatingItem, ListItemType.EditItem, ListItemType.Item, ListItemType.SelectedItem
                'get the data for the item being bound
                
                rowData = CType(e.Item.DataItem, Data.DataRowView)
                If Not IsDBNull(rowData.Item("Billable")) Then
                    If (rowData.Item("Billable")) Then
                        datClosingDate = (rowData.Item("CloseDate"))
                        lblClosingDate = CType(e.Item.FindControl("lblCloseDate"), System.Web.UI.WebControls.Literal)
                        lblClosingDate.Text = FormatDateTime(datClosingDate, DateFormat.ShortDate).ToString
                               
                        'get the value for labor only and add it to the sum
                        If Not IsDBNull(rowData.Item("Labor")) Then
                            price = CDec(rowData.Item("Labor"))
                            mListLaborTotal += price
                        End If
                        'get the control used to display the labor price
                        listLaborLabel = CType(e.Item.FindControl("lblLabor"), System.Web.UI.WebControls.Literal)
                        'now format the discounted price in currency format
                        listLaborLabel.Text = price.ToString("C2")
                
                
                        'get the value for parts and add it to the sum
                        If Not IsDBNull(rowData.Item("Parts")) Then
                            price = CDec(rowData.Item("Parts"))
                            mListPartsTotal += price
                        End If
                        'get the control used to display the PartAmount price
                        listPartsLabel = CType(e.Item.FindControl("lblParts"), System.Web.UI.WebControls.Literal)
                        'now format the discounted price in currency format
                        listPartsLabel.Text = price.ToString("C2")
                
                        'get the value Charged (labor and parts) and add it to the sum
                        If Not IsDBNull(rowData.Item("AmountCharged")) Then
                            price = CDec(rowData.Item("AmountCharged"))
                            mListChargedTotal += price
                        End If
                
                        'get the control used to display the amount charged(parts and labor) price
                        listAmountChargedLabel = CType(e.Item.FindControl("lblAmountCharged"), System.Web.UI.WebControls.Literal)
                        'now format the discounted price in currency format
                        listAmountChargedLabel.Text = price.ToString("C2")
                
                
                        'get the value for the Paid and add it to the sum
                        If Not IsDBNull(rowData.Item("AmountPaid")) Then
                            price = CDec(rowData.Item("AmountPaid"))
                            mListPaidTotal += price
                        End If
                        'get the control used to display the PartAmount price
                        listAmountPaidLabel = CType(e.Item.FindControl("lblAmountPaid"), System.Web.UI.WebControls.Literal)
          
                        'now format the discounted price in currency format
                        listAmountPaidLabel.Text = price.ToString("C2")
                
                        'get the value for the Due and add it to the sum
                        If Not IsDBNull(rowData.Item("AmountDue")) Then
                            price = CDec(rowData.Item("AmountDue"))
                            mListDueTotal += price
                        End If
                        'get the control used to display the PartAmount price
                        listAmountDueLabel = CType(e.Item.FindControl("lblAmountDue"), System.Web.UI.WebControls.Literal)
          
                        'now format the discounted price in currency format
                        listAmountDueLabel.Text = price.ToString("C2")
                    Else
                        datClosingDate = (rowData.Item("CloseDate"))
                        lblClosingDate = CType(e.Item.FindControl("lblCloseDate"), System.Web.UI.WebControls.Literal)
                        lblClosingDate.Text = FormatDateTime(datClosingDate, DateFormat.ShortDate).ToString
                               
                        'get the value for labor only and add it to the sum
                        If Not IsDBNull(rowData.Item("Labor")) Then
                            price = CDec(0)
                            mListLaborTotal += price
                        End If
                        'get the control used to display the labor price
                        listLaborLabel = CType(e.Item.FindControl("lblLabor"), System.Web.UI.WebControls.Literal)
                        'now format the discounted price in currency format
                        listLaborLabel.Text = price.ToString("C2")
                
                
                        'get the value for parts and add it to the sum
                        If Not IsDBNull(rowData.Item("Parts")) Then
                            price = CDec(0)
                            mListPartsTotal += price
                        End If
                        'get the control used to display the PartAmount price
                        listPartsLabel = CType(e.Item.FindControl("lblParts"), System.Web.UI.WebControls.Literal)
                        'now format the discounted price in currency format
                        listPartsLabel.Text = price.ToString("C2")
                
                        'get the value Charged (labor and parts) and add it to the sum
                        If Not IsDBNull(rowData.Item("AmountCharged")) Then
                            price = CDec(0)
                            mListChargedTotal += price
                        End If
                
                        'get the control used to display the amount charged(parts and labor) price
                        listAmountChargedLabel = CType(e.Item.FindControl("lblAmountCharged"), System.Web.UI.WebControls.Literal)
                        'now format the discounted price in currency format
                        listAmountChargedLabel.Text = price.ToString("C2")
                
                
                        'get the value for the Paid and add it to the sum
                        If Not IsDBNull(rowData.Item("AmountPaid")) Then
                            price = CDec(0)
                            mListPaidTotal += price
                        End If
                        'get the control used to display the PartAmount price
                        listAmountPaidLabel = CType(e.Item.FindControl("lblAmountPaid"), System.Web.UI.WebControls.Literal)
          
                        'now format the discounted price in currency format
                        listAmountPaidLabel.Text = price.ToString("C2")
                
                        'get the value for the Due and add it to the sum
                        If Not IsDBNull(rowData.Item("AmountDue")) Then
                            price = CDec(0)
                            mListDueTotal += price
                        End If
                        'get the control used to display the PartAmount price
                        listAmountDueLabel = CType(e.Item.FindControl("lblAmountDue"), System.Web.UI.WebControls.Literal)
          
                        'now format the discounted price in currency format
                        listAmountDueLabel.Text = price.ToString("C2")
              
              
              
              
                    End If

                Else
                    datClosingDate = (rowData.Item("CloseDate"))
                    lblClosingDate = CType(e.Item.FindControl("lblCloseDate"), System.Web.UI.WebControls.Literal)
                    lblClosingDate.Text = FormatDateTime(datClosingDate, DateFormat.ShortDate).ToString

                    'get the value for labor only and add it to the sum
                    If Not IsDBNull(rowData.Item("Labor")) Then
                        price = CDec(0)
                        mListLaborTotal += price
                    End If
                    'get the control used to display the labor price
                    listLaborLabel = CType(e.Item.FindControl("lblLabor"), System.Web.UI.WebControls.Literal)
                    'now format the discounted price in currency format
                    listLaborLabel.Text = price.ToString("C2")


                    'get the value for parts and add it to the sum
                    If Not IsDBNull(rowData.Item("Parts")) Then
                        price = CDec(0)
                        mListPartsTotal += price
                    End If
                    'get the control used to display the PartAmount price
                    listPartsLabel = CType(e.Item.FindControl("lblParts"), System.Web.UI.WebControls.Literal)
                    'now format the discounted price in currency format
                    listPartsLabel.Text = price.ToString("C2")

                    'get the value Charged (labor and parts) and add it to the sum
                    If Not IsDBNull(rowData.Item("AmountCharged")) Then
                        price = CDec(0)
                        mListChargedTotal += price
                    End If

                    'get the control used to display the amount charged(parts and labor) price
                    listAmountChargedLabel = CType(e.Item.FindControl("lblAmountCharged"), System.Web.UI.WebControls.Literal)
                    'now format the discounted price in currency format
                    listAmountChargedLabel.Text = price.ToString("C2")
                
                
                    'get the value for the Paid and add it to the sum
                    If Not IsDBNull(rowData.Item("AmountPaid")) Then
                        price = CDec(0)
                        mListPaidTotal += price
                    End If
                    'get the control used to display the PartAmount price
                    listAmountPaidLabel = CType(e.Item.FindControl("lblAmountPaid"), System.Web.UI.WebControls.Literal)
          
                    'now format the discounted price in currency format
                    listAmountPaidLabel.Text = price.ToString("C2")
                
                    ''get the value for the Due and add it to the sum
                    If Not IsDBNull(rowData.Item("AmountDue")) Then
                        price = CDec(0)
                        mListDueTotal += price
                    End If
                    ''get the control used to display the PartAmount price
                    listAmountDueLabel = CType(e.Item.FindControl("lblAmountDue"), System.Web.UI.WebControls.Literal)

                    ''now format the discounted price in currency format
                    listAmountDueLabel.Text = price.ToString("C2")

                End If
            Case ListItemType.Footer
              
                GrandTotalLaborLabel = CType(e.Item.FindControl("lblGrandTotalLaborAmount"), System.Web.UI.WebControls.Literal)
                GrandTotalLaborLabel.Text = mListLaborTotal.ToString("C2")

                GrandTotalPartsLabel = CType(e.Item.FindControl("lblGrandTotalPartAmount"), System.Web.UI.WebControls.Literal)
                GrandTotalPartsLabel.Text = mListPartsTotal.ToString("C2")

                'get the control used to display the total of the list prices
                'and set its value to the total of the list prices
                GrandtotalChargeLabel = CType(e.Item.FindControl("lblGrandTotalAmountCharged"), System.Web.UI.WebControls.Literal)
                GrandtotalChargeLabel.Text = mListChargedTotal.ToString("C2")

                'get the control used to display the total of the extra prices
                'and set its value to the total of the discounted prices
                GrandTotalPaidLabel = CType(e.Item.FindControl("lblGrandTotalAmountPaid"), System.Web.UI.WebControls.Literal)
                GrandTotalPaidLabel.Text = mListPaidTotal.ToString("C2")
                
                GrandTotalDueLabel = CType(e.Item.FindControl("lblGrandTotalAmountDue"), System.Web.UI.WebControls.Literal)
                GrandTotalDueLabel.Text = mListDueTotal.ToString("C2")
            
            Case Else
                'ListItemType.Header, ListItemType.Pager, or ListItemType.Separator
                'no action required
                
        End Select
        
    End Sub  'dgvTickets_ItemDataBound
    
    Function CheckForErrors() As Boolean

        Dim dgItem As DataGridItem
        Dim chkbox As CheckBox
        Dim boolError As Boolean

        boolError = True
 
        For Each dgItem In dgvTickets.Items
            chkbox = dgItem.FindControl("chkselected")
            If chkbox.Checked Then
                
                If (dgItem.Cells.Item(12).Text) = "" Or (dgItem.Cells.Item(12).Text) = "&nbsp;" Then
                    boolError = False
                    Exit For
                End If
            End If
        Next
        CheckForErrors = boolError
 
    End Function
    Protected Sub Calendar1_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        'InvoiceNumber.Text = Calendar1.SelectedDate
        'LoadPartners()
        dgvTickets.DataSource = Nothing
        dgvTickets.DataBind()
    End Sub
    
    Private Sub btnDelete_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim ldl As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim par As New BridgesInterface.TicketComponentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim payr As New BridgesInterface.PaymentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim dgItem As DataGridItem
        Dim chkbox As CheckBox
        Dim intPaymentID As Integer
        Dim datDate2 As DateTime
        Dim intTicketComponentID As Integer
        Dim strChangeLog As String = ""
        
        If Calendar1.SelectedDate = "#12:00:00 AM#" Then
            datDate2 = Now()
        Else
            datDate2 = Calendar1.SelectedDate & " 23:59:59"
        End If
        
        For Each dgItem In dgvTickets.Items
            chkbox = dgItem.FindControl("chkselected")
            If chkbox.Checked Then
                intPaymentID = CType(dgItem.Cells.Item(1).Text, Long)
                payr.Load(intPaymentID)
                intTicketComponentID = payr.TicketComponentID
                payr.Delete()
                par.Load(intTicketComponentID)
                par.Paid = False
                par.Save(strChangeLog)
                
            End If
        Next
        dgvTickets.DataSource = Nothing
        
        ldl.LoadStringDateParameterDataGrid("spGetPaidInvoices", "@CheckNumber", CType(txtCheckNumber.Text, String), "@DateCreated", datDate2, dgvTickets)
    End Sub
    
    Private Sub btnRefresh_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim ldl As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim datDate2 As DateTime

        If Calendar1.SelectedDate = "#12:00:00 AM#" Then
            datDate2 = Now()
        Else
            datDate2 = Calendar1.SelectedDate & " 23:59:59"
        End If
        
        dgvTickets.DataSource = Nothing
       
        If txtTicketID.Text.ToString <> "" Then
            ldl.LoadSingleLongParameterDataGrid("spOutstandingBalanceByTIcketID", "@TicketID", txtTicketID.Text, dgvLabor)
            ldl.LoadSingleLongParameterDataGrid("spOutstandingPartsPaymentByTicketID", "@TicketID", txtTicketID.Text, dgvParts)
            lblTotalCharge.Text = "Total Charges for this ticket: " & FormatCurrency(GetTotalCharge(txtTicketID.Text), 2)
            lblTotalPayment.Text = "Total Payments for this ticket: " & FormatCurrency(GetTotalPayment(txtTicketID.Text), 2)
        End If
        If txtCheckNumber.Text.ToString <> "" Then
            ldl.LoadStringDateParameterDataGrid("spGetPaidInvoices", "@CheckNumber", CType(txtCheckNumber.Text, String), "@DateCreated", datDate2, dgvTickets)
        End If
    End Sub
    
    Private Sub LoadPartners()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        
        ldr.LoadSimpleDropDownList("spListAllPartners", "ResumeID", "PartnerID", drpPartners)
        drpPartners.Items.Add("Choose One")
       
        drpPartners.SelectedValue = "Choose One"
        
    End Sub
    Private Sub drppartners_change(ByVal S As Object, ByVal E As EventArgs)
        If drpMethod.SelectedValue = 17 Then
            secpartners.Visible = True
        Else
            secpartners.Visible = False
        End If
    End Sub
    
    Private Sub MsgBox(ByVal strMessage As String)
        'Begin building the script 
        Dim strScript As String = "<SCRIPT LANGUAGE=""JavaScript"">" & vbCrLf
        strScript += "alert(""" & strMessage & """)" & vbCrLf
        strScript += "<" & "/" & "SCRIPT" & ">"
        'Register the script for the client side 
        ClientScript.RegisterStartupScript(GetType(String), "messageBox", strScript)
    End Sub

    Private Sub ProcessPartsPayment(ByVal lngTicketID As Long)
        Dim chkbox As CheckBox
        Dim dgItem As DataGridItem
        Dim par As New BridgesInterface.TicketComponentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim pay As New BridgesInterface.PaymentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim ldl As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim strChangeLog As String = ""
        Dim datDate2 As DateTime
        
        If txtTicketID.Text.ToString <> "" Then
            If txtCheckNumber.Text.ToString <> "" Then
                If Calendar1.SelectedDate = "#12:00:00 AM#" Then
                    datDate2 = Now()
                Else
                    datDate2 = Calendar1.SelectedDate & " 23:59:59"
                End If
                For Each dgItem In dgvParts.Items
                    chkbox = dgItem.FindControl("chkPart")
                  
                    If chkbox.Checked Then
                        Dim dblselectedAmount As Double
                        tkt.Load(CType(txtTicketID.Text, Long))
                        If tkt.InvoiceID <> 0 And Not IsDBNull(tkt.InvoiceID) Then
                            If txtPaidAmount.Text.ToString <> "" Then
                                pay.Add(tkt.InvoiceID, 1, 11, CDec(txtPaidAmount.Text), datDate2)
                                If CDec(txtPaidAmount.Text) = CDec(dgItem.Cells.Item(1).Text) Then
                                    par.Load(CLng(dgItem.Cells.Item(1).Text))
                                    par.Paid = True
                                    par.Save(strChangeLog)
                                End If
                                dblselectedAmount = CDec(txtPaidAmount.Text)
                                txtPaidAmount.Text = ""
                            Else
                                pay.Add(tkt.InvoiceID, 1, 11, CDec(dgItem.Cells.Item(7).Text), datDate2)
                                par.Load(CLng(dgItem.Cells.Item(1).Text.ToString))
                                par.Paid = True
                                par.Save(strChangeLog)
                                
                                dblselectedAmount = CDec(dgItem.Cells.Item(7).Text)
                            End If
                            pay.CheckNumber = txtCheckNumber.Text.ToString
                            pay.TicketComponentID = CLng(dgItem.Cells.Item(1).Text)
                            If txtTicketID.Text.ToString <> "" Then
                                pay.TicketID = CType(txtTicketID.Text, Long)
                            Else
                                pay.TicketID = 0
                            End If
                            If txtWorkOrderID.Text.ToString <> "" Then
                                pay.WorkOrderID = CType(txtWorkOrderID.Text, Long)
                            Else
                                pay.WorkOrderID = 0
                            End If
                            pay.Comments = txtComments.Text.ToString
                            pay.Save(strChangeLog)
                            If drpMethod.SelectedValue = 18 Or drpMethod.SelectedValue = 19 Then
                                tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, "Deduction: " & drpMethod.SelectedItem.ToString & " has been processed - " & txtTicketID.Text & " / CheckNumber: " & txtCheckNumber.Text & " - Amount: $" & dblselectedAmount & " - Part Description: " & dgItem.Cells.Item(5).Text)
                            Else
                                tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, "Credit for Parts: Payment record has been processed - " & txtTicketID.Text & " / CheckNumber: " & txtCheckNumber.Text & " - Amount: $" & dblselectedAmount & " - Part Description: " & dgItem.Cells.Item(5).Text)
                            End If
                            tnt.CustomerVisible = False
                            tnt.PartnerVisible = False
                            tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                            tnt.Acknowledged = True
                            tnt.Save(strChangeLog)
                        End If
                    End If
                Next
               
                'production
           
                'Dim usr As New BridgesInterface.UserRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                'usr.Load(Master.LoginID)
                Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                wbl.Load(Master.WebLoginID)
                Dim strUserName As String
                strUserName = wbl.Login
                
                Dim plog As New BridgesInterface.ProductionLogRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                plog.Add(Master.WebLoginID, Now(), 8, "Parts Credit record has been processed - " & txtTicketID.Text & " / CheckNumber: " & txtCheckNumber.Text)
            Else
                MsgBox("You must enter a check number so payment can be processed")
            End If
        Else
            MsgBox("You must enter a ticket number to be processed")
        End If
        
    End Sub
    Private Sub ProcessLaborPayment(ByVal lngTicketID As Long)
        Dim dgItem As DataGridItem
        Dim chkbox As CheckBox
        Dim par As New BridgesInterface.TicketComponentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim pay As New BridgesInterface.PaymentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim ldl As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim strChangeLog As String = ""
        Dim datDate2 As DateTime
        
        If txtTicketID.Text.ToString <> "" Then
            If txtCheckNumber.Text.ToString <> "" Then
                If Calendar1.SelectedDate = "#12:00:00 AM#" Then
                    datDate2 = Now()
                Else
                    datDate2 = Calendar1.SelectedDate & " 23:59:59"
                End If
            
                For Each dgItem In dgvLabor.Items
                    Dim dblselectedAmount As Double
                    chkbox = dgItem.FindControl("chkLabor")
                    If chkbox.Checked Then
                        tkt.Load(CType(txtTicketID.Text, Long))
                        If (tkt.InvoiceID <> 0) And (Not IsDBNull(tkt.InvoiceID)) Then
                            If txtPaidAmount.Text.ToString <> "" Then
                                pay.Add(tkt.InvoiceID, 1, drpMethod.SelectedValue, CType(txtPaidAmount.Text, Double), datDate2)
                                dblselectedAmount = CType(txtPaidAmount.Text, Double)
                                txtPaidAmount.Text = ""
                            Else
                                pay.Add(tkt.InvoiceID, 1, drpMethod.SelectedValue, CDec(dgItem.Cells.Item(11).Text), datDate2)
                                dblselectedAmount = CDec(dgItem.Cells.Item(11).Text)
                            End If
                            tkt.TicketClaimApprovalStatusID = 1
                            tkt.Save(strChangeLog)
                            
                            pay.CheckNumber = txtCheckNumber.Text.ToString
                            If txtTicketID.Text.ToString <> "" Then
                                pay.TicketID = CType(txtTicketID.Text, Long)
                            Else
                                pay.TicketID = 0
                            End If
                            If txtWorkOrderID.Text.ToString <> "" Then
                                pay.WorkOrderID = CType(txtWorkOrderID.Text, Long)
                            Else
                                pay.WorkOrderID = 0
                            End If
                            pay.Comments = txtComments.Text.ToString
                            pay.Save(strChangeLog)
                            
                                tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, drpMethod.SelectedItem.ToString & ": Payment record has been processed - " & txtTicketID.Text & " / CheckNumber: " & txtCheckNumber.Text & " - Amount: $" & dblselectedAmount)
                           
                                
                            tnt.CustomerVisible = False
                            tnt.PartnerVisible = False
                            tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                            tnt.Acknowledged = True
                            tnt.Save(strChangeLog)
                        End If
                    End If
                Next
                'verifying parts payment
                For Each dgItem In dgvParts.Items
                    chkbox = dgItem.FindControl("chkPart")
                  
                    If chkbox.Checked Then
                        Dim dblselectedAmount As Double
                        tkt.Load(CType(txtTicketID.Text, Long))
                        If tkt.InvoiceID <> 0 And Not IsDBNull(tkt.InvoiceID) Then
                            If txtPaidAmount.Text.ToString <> "" Then
                                pay.Add(tkt.InvoiceID, 1, 11, CDec(txtPaidAmount.Text), datDate2)
                                If CDec(txtPaidAmount.Text) = CDec(dgItem.Cells.Item(1).Text) Then
                                    par.Load(CLng(dgItem.Cells.Item(1).Text))
                                    par.Paid = True
                                    par.Save(strChangeLog)
                                End If
                                dblselectedAmount = CDec(txtPaidAmount.Text)
                                txtPaidAmount.Text = ""
                            Else
                                pay.Add(tkt.InvoiceID, 1, 11, CDec(dgItem.Cells.Item(7).Text), datDate2)
                                par.Load(CLng(dgItem.Cells.Item(1).Text.ToString))
                                par.Paid = True
                                par.Save(strChangeLog)
                                
                                dblselectedAmount = CDec(dgItem.Cells.Item(7).Text)
                            End If
                            pay.CheckNumber = txtCheckNumber.Text.ToString
                            pay.TicketComponentID = CLng(dgItem.Cells.Item(1).Text)
                            If txtTicketID.Text.ToString <> "" Then
                                pay.TicketID = CType(txtTicketID.Text, Long)
                            Else
                                pay.TicketID = 0
                            End If
                            If txtWorkOrderID.Text.ToString <> "" Then
                                pay.WorkOrderID = CType(txtWorkOrderID.Text, Long)
                            Else
                                pay.WorkOrderID = 0
                            End If
                            pay.Comments = txtComments.Text.ToString
                            pay.Save(strChangeLog)
                            
                            tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, "Credit for Parts: Payment record has been processed - " & txtTicketID.Text & " / CheckNumber: " & txtCheckNumber.Text & " - Amount: $" & dblselectedAmount & " - Part Description: " & dgItem.Cells.Item(5).Text)
                        
                            tnt.CustomerVisible = False
                            tnt.PartnerVisible = False
                            tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                            tnt.Acknowledged = True
                            tnt.Save(strChangeLog)
                        End If
                    End If
                Next
                
                'production
           
                'Dim usr As New BridgesInterface.UserRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                'usr.Load(Master.LoginID)
                Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                wbl.Load(Master.WebLoginID)
                Dim strUserName As String
                strUserName = wbl.Login
                
                Dim plog As New BridgesInterface.ProductionLogRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                plog.Add(Master.WebLoginID, Now(), 7, "Payment/Credit record has been processed - " & txtTicketID.Text & " / CheckNumber: " & txtCheckNumber.Text)
                        
                Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
                eml.Subject = "Production from: " & strUserName
                eml.Body = "Payment/Credit record has been processed - " & txtTicketID.Text & " / CheckNumber: " & txtCheckNumber.Text
                eml.SendFrom = System.Configuration.ConfigurationManager.AppSettings("PartnerSupportEmail")
                eml.SendFrom = strUserName & "@bestservicers.com"
                'eml.SendTo = ptr.Email
                eml.SendTo = "agentproduction@bestservicers.com"
                eml.Send()
                
            Else
                MsgBox("You must enter a check number so payment can be processed")
            End If
                
        Else
            MsgBox("You must enter a ticket number to be processed")
        End If
        
    End Sub
    Private Function GetTotalCharge(ByVal lngTicketID As Long) As Double
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spOutstandingBalanceByTicketID")
  
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TicketID", Data.SqlDbType.Int).Value = lngTicketID
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            GetTotalCharge = dtr("TotalCharged")
            
        End While
        Return GetTotalCharge
        cnn.Close()

    End Function
    
    Private Function GetTotalPayment(ByVal lngTicketID As Long) As Double
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spOutstandingBalanceByTicketID")
  
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TicketID", Data.SqlDbType.Int).Value = lngTicketID
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            GetTotalPayment = dtr("TotalAmountPaid")
            
        End While
        Return GetTotalPayment
        cnn.Close()

    End Function
    Private Sub dgvCustomerTotals_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgvCustomerTotals.ItemDataBound
        Dim rowData As Data.DataRowView
        Dim price As Decimal
        Dim listTotalLabel As System.Web.UI.WebControls.Literal
        Dim GrandtotalChargeLabel As System.Web.UI.WebControls.Literal
       
        Select Case (e.Item.ItemType)
            Case ListItemType.AlternatingItem, ListItemType.EditItem, ListItemType.Item, ListItemType.SelectedItem
                'get the data for the item being bound
                
                rowData = CType(e.Item.DataItem, Data.DataRowView)
                'get the value for Total only and add it to the sum
                If Not IsDBNull(rowData.Item("Total")) Then
                    price = CDec(rowData.Item("Total"))
                    mTotalCustomer += price
                End If
                'get the control used to display the labor price
                listTotalLabel = CType(e.Item.FindControl("lblTotal"), System.Web.UI.WebControls.Literal)
                'now format the discounted price in currency format
                listTotalLabel.Text = price.ToString("C2")
                

            Case ListItemType.Footer
                'get the control used to display the total of the list prices
                'and set its value to the total of the list prices
                GrandtotalChargeLabel = CType(e.Item.FindControl("lblGrandTotalAmount"), System.Web.UI.WebControls.Literal)
                GrandtotalChargeLabel.Text = mTotalCustomer.ToString("C2")
    
            Case Else
                    
        End Select
        
    End Sub
    
    Private Sub LoadCustomerTotals()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSimpleDataGrid("spBillingVerificationCustomerTotals", dgvCustomerTotals)
        If CType(dgvCustomerTotals.DataSource, Data.DataSet).Tables(0).Rows.Count = 0 Then
            lblNoCustomers.Text = "No Customers to be billed at this moment."
            lblNoCustomers.Visible = True
        End If
    End Sub
    
    Private Sub LoadPriorInvoices()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        If _CustID > 0 Then
            ldr.LoadSingleLongParameterDataGrid("spGetCustomerTop10PriorInvoices", "@CustomerID", _CustID, dgvOldInvoices)
    
            For Each itm As DataGridItem In dgvOldInvoices.Items
                If CType(itm.Cells(0).Text, Long) = _ID Then
                    itm.CssClass = "selectedbandbar"
                End If
            Next
        End If
    End Sub
    Private Sub LoadTickets(ByVal lngTicketFolderID As Long, ByVal SortField As String)
       
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Session("sortOrder") = SortField
        
        If _CustID > 0 Then
            ldr.LoadSingleLongParameterDataGrid("spBillingVerificationByCustomer", "@CustomerID", _CustID, dgvInvoiceTickets)
            lblTicketCount1.Text = " ( " & CType(dgvInvoiceTickets.DataSource, Data.DataSet).Tables(0).Rows.Count & " ) "
            btnJump.Enabled = True
        End If
    End Sub
    Private Sub LoadTicketsByCustomer(ByVal lngTicketFolderID As Long, ByVal lngCustomerID As Long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSingleLongParameterDataGrid("spBillingVerificationByCustomer", "@CustomerID", _CustID, dgvInvoiceTickets)
        lblTicketCount1.Text = " ( " & CType(dgvInvoiceTickets.DataSource, Data.DataSet).Tables(0).Rows.Count & " ) "
    End Sub
    Private Sub btnClaim_Click(ByVal S As Object, ByVal E As EventArgs)
        'Dim objLG As New LG(Master.UserID)
        'Dim cnt As Integer = 0
        'Dim i As Integer
        'Dim dgItem As DataGridItem
        'Dim chkbox As CheckBox
        'For Each dgItem In dgvInvoiceTickets.Items
        '    chkbox = dgItem.FindControl("chkselected1")
        '    i = IIf(chkbox.Checked, CType(dgItem.Cells.Item(1).Text, Integer), 0)
        '    If i > 0 Then
        '        objLG.submitWarranty(i)
        '        i += 1
        '    End If
        'Next
        'If i = 0 Then
        '    MsgBox("Please select at least one ticket to submit claim")
        'End If
    End Sub

    Private Sub btnJump_Click(ByVal S As Object, ByVal E As EventArgs)
   
        Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim inv As New BridgesInterface.InvoiceRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim invItem As New BridgesInterface.InvoiceItemRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cad As New BridgesInterface.CustomerAddressRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cst As New BridgesInterface.CustomerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cag As New BridgesInterface.CustomerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim sta As New BridgesInterface.StateRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        
        Dim dgItem As DataGridItem
        Dim chkbox As CheckBox
        Dim strInvoiceNumber As String
        Dim lngInvoiceID As Integer
        Dim strChangeLog As String = ""
        Dim price As Double
        Dim lngCustomerID As Long
        
        btnJump.Enabled = False
        price = 0
        strInvoiceNumber = 0
        If CheckForErrors2() = True Then
            strInvoiceNumber = CreateInvoiceNumber(_CustID)
            inv.Add(_CustID, 1, "Thanks for your business")
            inv.InvoiceNumber = strInvoiceNumber
            lngInvoiceID = inv.InvoiceID
            lngCustomerID = inv.CustomerID
            cst.Load(inv.CustomerID)
            If tkt.CustomerID = 30 Then ' BSA
                inv.BillCompany = "Residence/Business"
                inv.BillName = tkt.ContactFirstName & " " & tkt.ContactLastName
                inv.BillStreet = tkt.Street
                inv.BillCity = tkt.City
                sta.Load(tkt.StateID)
                inv.BillState = sta.Abbreviation
                inv.BillZipCode = tkt.ZipCode
                
                inv.ShipCompany = "Residence/Business"
                inv.ShipName = tkt.ContactFirstName & " " & tkt.ContactLastName
                inv.ShipStreet = tkt.Street
                inv.ShipCity = tkt.City
                inv.ShipState = sta.Abbreviation
                inv.ShipZipCode = tkt.ZipCode
                
            Else
                inv.BillCompany = cst.Company
                inv.ShipCompany = cst.Company
            End If
            cst.Save(strChangeLog)
            'add contacts and address for billing later on
            'add total amount
            lblTicketCount1.Text = strInvoiceNumber
      
            For Each dgItem In dgvInvoiceTickets.Items
                chkbox = dgItem.FindControl("chkselected1")
                If chkbox.Checked Then
                    tkt.Load(CType(dgItem.Cells.Item(1).Text, Integer))
                    tkt.InvoiceID = lngInvoiceID
                    tkt.CompletedDate = Now()
                    tkt.TicketClaimApprovalStatusID = 4
                    tkt.Save(strChangeLog)
                
                    tnt.Add(CType(dgItem.Cells.Item(1).Text, Integer), Master.WebLoginID, Master.UserID, "Ticket has been invoiced: " & strInvoiceNumber)
                    tnt.CustomerVisible = False
                    tnt.Acknowledged = False
                    tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                    tnt.Save(strChangeLog)
                
                    price = price + CDec(dgItem.Cells.Item(11).Text)
                
                    InvoiceNumber1.Text = price.ToString("C2")
                    
                End If
            Next
            invItem.Add(lngInvoiceID, 1, "Onsite Service Provided", 1, price, 0)
            inv.Notes = "Thanks for your business."
            inv.Save(strChangeLog)
            If tkt.CustomerID <> 30 Then ' bsa
                GetCustomerBillingAgent(lngCustomerID, lngInvoiceID)
                GetCustomerBillingAddress(lngCustomerID, lngInvoiceID)
            End If
            
            'production
             
            'Dim usr As New BridgesInterface.UserRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            'usr.Load(Master.LoginID)
            Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            wbl.Load(Master.WebLoginID)
            Dim strUserName As String
            strUserName = wbl.Login
            
            'production  3  Invoice  Created          
            Dim plog As New BridgesInterface.ProductionLogRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            plog.Add(Master.WebLoginID, Now(), 3, "Invoice for Customer " & drpCustomers.SelectedItem.Text & " has been created. Invoice Number: " & strInvoiceNumber)
            
            'Response.Redirect("accountsreceivables.aspx?id=" & _ID)
        Else
            lblTicketCount1.Text = " | ATTENTION! You must verify the totals for the tickets you have checked in. Unable to create invoice."
  
        End If
        
    End Sub
    Protected Sub dgvInvoiceTickets_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        If lblSortOrder.Text.ToLower = " asc" Then
            lblSortOrder.Text = " desc"
        Else
            lblSortOrder.Text = " asc"
        End If
        If _CustID > 0 Then
            ldr.LoadSingleLongParameterDataGrid("spBillingVerificationByCustomer", "@CustomerID", _CustID, dgvInvoiceTickets, True, e, e.SortExpression, lblSortOrder.Text)
            lblTicketCount1.Text = " ( " & CType(dgvInvoiceTickets.DataSource, Data.DataView).Count & " ) "
            RePopulateCheckBoxes()
        End If
    End Sub
    Private Sub dgvInvoiceTickets_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgvInvoiceTickets.ItemDataBound
        Dim rowData As Data.DataRowView
        Dim price As Decimal
        Dim listLaborLabel As System.Web.UI.WebControls.Literal
        Dim listPartLabel As System.Web.UI.WebControls.Literal
        Dim listExtraLabel As System.Web.UI.WebControls.Literal
        Dim listTotalLabel As System.Web.UI.WebControls.Literal
        Dim GrandLabortotalLabel As System.Web.UI.WebControls.Literal
        Dim GrandExtraTotalLabel As System.Web.UI.WebControls.Literal
        Dim GrandPartTotalLabel As System.Web.UI.WebControls.Literal
        Dim GrandTotalLabel As System.Web.UI.WebControls.Literal
        Dim strStatus As String
        Dim datClosingDate As Date
        Dim lblClosingDate As System.Web.UI.WebControls.Literal
        Dim chkSel As System.Web.UI.WebControls.CheckBox
        'check the type of item that was databound and only take action if it 
        'was a row in the datagrid
        Select Case (e.Item.ItemType)
            Case ListItemType.AlternatingItem, ListItemType.EditItem, ListItemType.Item, ListItemType.SelectedItem
                'get the data for the item being bound
                
                rowData = CType(e.Item.DataItem, Data.DataRowView)
                strStatus = (rowData.Item("Status"))
                If strStatus = "Closed - Canceled" Then
                    e.Item.ForeColor = Drawing.Color.Red
                End If
                
                datClosingDate = (rowData.Item("CloseDate"))
                lblClosingDate = CType(e.Item.FindControl("lblCloseDate"), System.Web.UI.WebControls.Literal)
                lblClosingDate.Text = FormatDateTime(datClosingDate, DateFormat.ShortDate).ToString
                
                'get the value for the laboramount and add it to the sum
                price = CDec(rowData.Item("LaborAmount"))
                mLaborTotal += price
                
                If price = 0 And strStatus <> "Closed - Canceled" Then
                    e.Item.ForeColor = Drawing.Color.RoyalBlue
                End If
                
                
                'get the control used to display the list price
                'NOTE: This can be done by using the FindControl method of the 
                '      passed item because ItemTemplates were used and the anchor
                '      controls in the templates where given IDs.  If a standard
                '      BoundColumn was used, the data would have to be accessed
                '      using the cellscollection (e.g. e.Item.Cells(1).controls(1)
                '      would access the label control in this example.
                listLaborLabel = CType(e.Item.FindControl("lblLaborAmount1"), System.Web.UI.WebControls.Literal)
          
                'now format the list price in currency format
                listLaborLabel.Text = price.ToString("C2")

                'get the value for the extra amount and add it to the sum
                price = CDec(rowData.Item("AdjustCharge"))
                mExtraTotal += price

                'get the control used to display the discounted price
                listExtraLabel = CType(e.Item.FindControl("lblAdjustCharge1"), System.Web.UI.WebControls.Literal)
          
                'now format the discounted price in currency format
                listExtraLabel.Text = price.ToString("C2")
                

                'get the value for the PartAmount and add it to the sum
                If Not IsDBNull(rowData.Item("PartAmount")) Then
                    price = CDec(rowData.Item("PartAmount"))
                    mPartTotal += price
                    
                    If (price > 0) And (strStatus = "Closed - Resolved") And listLaborLabel.Text = 0 Then
                        e.Item.ForeColor = Drawing.Color.DarkGreen
                    End If
                End If
                'get the control used to display the PartAmount price
                listPartLabel = CType(e.Item.FindControl("lblPartAmount1"), System.Web.UI.WebControls.Literal)
          
                'now format the discounted price in currency format
                listPartLabel.Text = price.ToString("C2")

                'get the value for the Total and add it to the sum
                If Not IsDBNull(rowData.Item("Total")) Then
                    price = CDec(rowData.Item("Total"))
                    mTotal += price
                End If
                'get the control used to display the PartAmount price
                listTotalLabel = CType(e.Item.FindControl("lblTotal1"), System.Web.UI.WebControls.Literal)
          
                'now format the discounted price in currency format
                listTotalLabel.Text = price.ToString("C2")
                
                chkSel = CType(e.Item.FindControl("chkSelected1"),System.Web.UI.WebControls.CheckBox )
                    If chkSel.checked then
                        mTotalSelected += mTotal
                    end if
                
                
            Case ListItemType.Footer

                'get the control used to display the total of the list prices
                'and set its value to the total of the list prices
                GrandLabortotalLabel = CType(e.Item.FindControl("lblTotalLaborAmount1"), System.Web.UI.WebControls.Literal)
                GrandLabortotalLabel.Text = mLaborTotal.ToString("C2")
          
                'get the control used to display the total of the extra prices
                'and set its value to the total of the discounted prices
                GrandExtraTotalLabel = CType(e.Item.FindControl("lblTotalAdjustCharge1"), System.Web.UI.WebControls.Literal)
                GrandExtraTotalLabel.Text = mExtraTotal.ToString("C2")
                
                GrandPartTotalLabel = CType(e.Item.FindControl("lblTotalPartAmount1"), System.Web.UI.WebControls.Literal)
                GrandPartTotalLabel.Text = mPartTotal.ToString("C2")
                
                GrandTotalLabel = CType(e.Item.FindControl("lblGrandTotalAmount1"), System.Web.UI.WebControls.Literal)
                GrandTotalLabel.Text = mTotal.ToString("C2")
                
            Case Else
                'ListItemType.Header, ListItemType.Pager, or ListItemType.Separator
                'no action required
                
        End Select
        
    End Sub  'dgvTickets_ItemDataBound
    Private Sub GetCheckBoxValues()
        'As paging occurs store checkbox values    
        Dim dgItem As DataGridItem
        Dim chkbox As CheckBox
        'Dim chkBxIndex as Integer 
        Dim CheckedItems As ArrayList = New ArrayList
    
        'If Not isnothing (Session("CheckedItems"))then
        'Loop through DataGrid Items    
        For Each dgItem In dgvInvoiceTickets.Items
            'Retrieve key value of each record based on DataGrids        
            ' DataKeyField property        
    
            'ChkBxIndex = dgvTickets.DataKeys(1)        
            chkbox = dgItem.FindControl("chkSelected1")
            'Add ArrayList to Session if it doesnt exist        
            If Not IsNothing(Session("CheckedItems")) Then
                CheckedItems = Session("CheckedItems")
            End If
            If chkbox.Checked Then
                  
                'Add to Session if it doesnt already exist            
                If Not CheckedItems.Contains(dgItem.Cells.Item(1).Text) Then
                    CheckedItems.Add(dgItem.Cells.Item(1).Text)
                End If
            Else
                'Remove value from Session when unchecked            
                CheckedItems.Remove(dgItem.Cells.Item(1).Text)
            End If
     
        Next
        'Update Session with the list of checked items    
        Session("CheckedItems") = CheckedItems
        'end if          
    
    End Sub
     
    Private Sub RePopulateCheckBoxes()

        Dim CheckedItems As ArrayList = New ArrayList
        Dim dgItem As DataGridItem
        'Dim chkBxIndex as Integer 
        Dim chkbox As CheckBox
    
        CheckedItems = Session("CheckedItems")

        If Not IsNothing(CheckedItems) Then

            'Loop through GridView Items                
            For Each dgItem In dgvInvoiceTickets.Items

                'ChkBxIndex = dgvTickets.DataKeys(dgitem.Cells.Item(1).text)

                'Repopulate GridView with items found in Session                
                If CheckedItems.Contains(dgItem.Cells.Item(1).Text) Then

                    chkbox = CType(dgItem.FindControl("chkSelected1"), CheckBox)
                    chkbox.Checked = True
                    mTotalSelected += dgItem.Cells.Item(11).Text
                    lblTotalSelected.Text = FormatCurrency(mTotalSelected.tostring)
                End If
            Next
        End If
    End Sub

    Protected Sub chkSelected1_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim ck1 As CheckBox = CType(sender, CheckBox)
        Dim CheckedItems As ArrayList = New ArrayList
        Dim dgItem As DataGridItem = CType(ck1.NamingContainer, DataGridItem)
        Dim price As Decimal
        
        
        'now we've got what we need!
        If InvoiceNumber.Text = "" Then
            InvoiceNumber.Text = 0
        End If
       
        If ck1.Checked Then
            
            If Not IsNothing(Session("CheckedItems")) Then
                CheckedItems = Session("CheckedItems")
                price = CDec(dgItem.Cells.Item(11).Text)
                
            End If
            'Add to Session if it doesnt already exist            
            If Not CheckedItems.Contains(dgItem.Cells.Item(1).Text) Then
                CheckedItems.Add(dgItem.Cells.Item(1).Text)
            End If
            'production
            Dim plog As New BridgesInterface.ProductionLogRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            plog.Add(Master.WebLoginID, Now(), 14, "Invoice Customer - checked ticket to be invoiced: " & dgItem.Cells.Item(1).Text)
        Else
            'Remove value from Session when unchecked            
            CheckedItems.Remove(dgItem.Cells.Item(1).Text)
        End If
    End Sub

    Protected Sub Page_Unload(ByVal sender As Object, ByVal e As System.EventArgs)
        GetCheckBOxValues()
    End Sub

    Function SortOrder(ByVal Field As String) As String
        Dim so As String = Session("SortOrder")
        If Field = so Then
            SortOrder = Replace(Field, "asc", "desc")
        ElseIf Field <> so Then
            SortOrder = Replace(Field, "desc", "asc")
        Else
            SortOrder = Replace(Field, "asc", "desc")
        End If
        'Maintain persistent sort order 
        Session("SortOrder") = SortOrder
    End Function

    Function CreateInvoiceNumber(ByVal lngCustomerID As Integer) As String
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spCreateCustomerInvoiceNumber")
        Dim strInvoiceNumber As String

        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@CustomerNumber", Data.SqlDbType.Int).Value = lngCustomerID
        cnn.open()
        cmd.Connection = cnn
        strInvoiceNumber = cmd.ExecuteScalar()
        cnn.Close()
        CreateInvoiceNumber = strInvoiceNumber
    End Function

    
    Private Sub GetCustomerBillingAgent(ByVal lngCustomerID As Long, ByVal lngInvoiceID As Long)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetCustomerBillingAgent")
        Dim inv As New BridgesInterface.InvoiceRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim sta As New BridgesInterface.StateRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))

        Dim strFullName As String
        Dim strChangeLog As String
        strChangeLog = ""
        
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@CustomerID", Data.SqlDbType.Int).Value = lngCustomerID
        cmd.Parameters.Add("@TypeID", Data.SqlDbType.Int).Value = 12 ' 12 Billing/Invoices Type
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            strFullName = dtr("FirstName") & " " & dtr("LastName")
            inv.Load(lngInvoiceID)
            inv.BillName = strFullName
            inv.ShipName = strFullName
            inv.Save(strChangeLog)
        End While
        cnn.Close()
        
    End Sub
    
    Private Sub GetCustomerBillingAddress(ByVal lngCustomerID As Long, ByVal lngInvoiceID As Long)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetCustomerBillingAddress")
        Dim inv As New BridgesInterface.InvoiceRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim sta As New BridgesInterface.StateRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        
        Dim strChangeLog As String
        strChangeLog = ""
        
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@CustomerID", Data.SqlDbType.Int).Value = lngCustomerID
        cmd.Parameters.Add("@AddressTypeID", Data.SqlDbType.Int).Value = 2 ' 2 Billing Address Type
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            sta.Load(dtr("StateID"))
            inv.Load(lngInvoiceID)
            inv.BillStreet = dtr("Street")
            If Not isDBnull(dtr("Extended")) Then
                inv.BillExtended = dtr("Extended")
            End If
            inv.BillCity = dtr("City")
            inv.BillState = sta.Abbreviation
            inv.BillZipCode = dtr("ZipCode")
            inv.ShipStreet = dtr("Street")
            If Not isDBNull(dtr("Extended")) Then
                inv.ShipExtended = dtr("Extended")
            End If
            inv.ShipCity = dtr("City")
            inv.ShipState = sta.Abbreviation
            inv.ShipZipCode = dtr("ZipCode")
            inv.Save(strChangeLog)
            sta.Save(strChangeLog)
        End While
        cnn.Close()
        
    End Sub
    Function CheckForErrors2() As Boolean

        Dim dgItem As DataGridItem
        Dim chkbox As CheckBox
        Dim boolError As Boolean

        boolError = True
 
        For Each dgItem In dgvInvoiceTickets.Items
            chkbox = dgItem.FindControl("chkselected1")
            If chkbox.Checked Then
                If (dgItem.Cells.Item(11).Text) = "" Or (dgItem.Cells.Item(11).Text) = "&nbsp;" Then
                    boolError = False
                    Exit For
                End If
            End If
        Next
        CheckForErrors2 = boolError
 
    End Function
    Private Sub btnBack_Click(ByVal S As Object, ByVal E As EventArgs)
        Response.Redirect("accountsreceivables.aspx?id=" & _ID)
    End Sub
    
    Private Sub dgvParts_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgvParts.ItemDataBound
        Dim rowData As Data.DataRowView
        Dim price As Decimal
        Dim listTotalPartAmountLabel As System.Web.UI.WebControls.Literal
        Dim GrandTotalPartAmountLabel As System.Web.UI.WebControls.Literal
        Dim listAmountPaidLabel As System.Web.UI.WebControls.Literal
        Dim GrandTotalAmountPaidLabel As System.Web.UI.WebControls.Literal
        Dim listOutstandingLabel As System.Web.UI.WebControls.Literal
        Dim GrandTotalOutstandingLabel As System.Web.UI.WebControls.Literal
        
        Select Case (e.Item.ItemType)
            Case ListItemType.AlternatingItem, ListItemType.EditItem, ListItemType.Item, ListItemType.SelectedItem
                rowData = CType(e.Item.DataItem, Data.DataRowView)
                
                price = CDec(rowData.Item("TotalPartAmount"))
                mTotalPartAmount += price
                
                listTotalPartAmountLabel = CType(e.Item.FindControl("lblTotalPartAmount"), System.Web.UI.WebControls.Literal)
                
                listTotalPartAmountLabel.Text = price.ToString("C2")
                
                
                price = CDec(rowData.Item("AmountPaid"))
                mTotalAmountPaid += price
                
                listAmountPaidLabel = CType(e.Item.FindControl("lblAmountPaid"), System.Web.UI.WebControls.Literal)
                listAmountPaidLabel.Text = price.ToString("C2")
                
                
                price = CDec(rowData.Item("Outstanding"))
                mTotalOutstanding += price
                
                listOutstandingLabel = CType(e.Item.FindControl("lblOutstanding"), System.Web.UI.WebControls.Literal)
                listOutstandingLabel.Text = price.ToString("C2")
                
            Case ListItemType.Footer
                
                GrandTotalPartAmountLabel = CType(e.Item.FindControl("lblGrandTotalPartAmount"), System.Web.UI.WebControls.Literal)
                GrandTotalPartAmountLabel.Text = mTotalPartAmount.ToString("C2")
                
                GrandTotalAmountPaidLabel = CType(e.Item.FindControl("lblGrandTotalAmountPaid"), System.Web.UI.WebControls.Literal)
                GrandTotalAmountPaidLabel.Text = mTotalAmountPaid.ToString("C2")
                
                GrandTotalOutstandingLabel = CType(e.Item.FindControl("lblGrandTotalOutstanding"), System.Web.UI.WebControls.Literal)
                GrandTotalOutstandingLabel.Text = mTotalOutstanding.ToString("C2")
                
        End Select
    End Sub
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmAccountReceivables" runat="server" class="inputform">
    <div class="inputformsectionheader">Account Receivables</div>
      <div>&nbsp;</div>
            <div id="tab5">
          <asp:Menu ID="menu" runat="server" Orientation="Horizontal" OnMenuItemClick ="menu_MenuItemClick" CssClass="ul">
             <StaticMenuItemStyle CssClass="li" />
             <StaticHoverStyle CssClass="hoverstyle" />
             <StaticSelectedStyle CssClass="current" />
             <Items>
                <asp:MenuItem  value ="0" Text="Bill Customer"></asp:MenuItem>
                <asp:MenuItem value ="1" Text="Receive Payments"></asp:MenuItem> 
                <asp:MenuItem value = "2" Text="Reconciliation"></asp:MenuItem>
             </Items>
           </asp:Menu>
          </div>
          <div id="ratesheader" class="tabbody">
          <div>&nbsp;</div></div>
          <asp:MultiView ID="Multiview1" runat="server" ActiveViewIndex="0" >
          <asp:View ID="viewBillCustomers"  runat="server">
           <div>
           <table>
             <tr>
               <td>
                  <asp:MultiView ID="Multiview2" runat="server" ActiveViewIndex="0" >
                     <asp:View ID="viewCustomerTotals" runat ="server" >
                         <asp:Label ID="lblNoCustomers" runat="server" ></asp:Label>
                         <asp:DataGrid ID="dgvCustomerTotals" runat="server" style="background-color: White; width: 30%" ShowHeader="true" ShowFooter="true" AutoGenerateColumns="false" CssClass="Grid1"><FooterStyle cssClass="gridheader" HorizontalAlign="Right" BackColor="#C0C0C0" />
                            <ItemStyle CssClass="bandbar" />
                              <HeaderStyle CssClass="gridheader" />
                              <Columns>
                                <asp:BoundColumn DataField="CustomerID" HeaderText="ID" Visible="false" />
                                <asp:TemplateColumn ItemStyle-Wrap="false" headertext="Customers">
                                   <ItemTemplate>
                                      <a href="accountsreceivables.aspx?id=<%#_ID%>&c=<%# DataBinder.Eval(Container.DataItem,"CustomerID")%>&CustID=<%=drpCustomers.selectedValue%>&t=0&dt1=<%=RadDatePickerFrom.SelectedDate%>&dt2=<%=RadDatePickerTo.SelectedDate%>"><%#DataBinder.Eval(Container.DataItem, "Company")%></a>
                                   </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn SortExpression="Total" HeaderText="Total" ItemStyle-HorizontalAlign="Right">
                                   <ItemTemplate>
                                      <asp:Literal id="lblTotal" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "Total")%>' />
                                   </ItemTemplate>
                                   <FooterTemplate >
                                      <asp:Literal id="lblGrandTotalAmount" runat="server" />
                                   </FooterTemplate>
                                </asp:TemplateColumn>
                             </Columns>              
                        </asp:DataGrid>
                    </asp:View>
                    <asp:View ID="viewBillCustomerDetails" runat ="server" >
                         <table style="width: 100%">
                          <tbody>
                            <tr>
                              <td class="band" style="width: 1%">
                                 <div class="inputformsectionheader">Create Invoice</div>
                                 <div class="inputform"></div>
                                 <div class="label">Total Invoice Amount</div>
                                            <div><asp:TextBox ID="InvoiceNumber1" runat="server" /></div>
                                            <div>&nbsp;</div>
                                            <div style="text-align: right;" ><asp:Button ID="btnBack" runat="server" Text="<<< Back" OnClick="btnBack_Click" />&nbsp;&nbsp;<asp:Button ID="btnJump" runat="server" Text="Create" OnClick="btnJump_Click" /></div>
                                    <div>&nbsp;</div>
                                            <div style="text-align: right;" ><asp:Button ID="btnClaim" runat="server" Text="Submit Claim" OnClick="btnClaim_Click" />&nbsp;</div>
                                    <div>&nbsp;</div>
                                  <div class="inputformsectionheader">Prior Invoices</div>
                                    <asp:DataGrid ID="dgvOldInvoices" runat="server" ShowHeader="false" ShowFooter="false" AutoGenerateColumns="false" CssClass="Grid1">
                                       <ItemStyle CssClass="bandbar" />
                                           <Columns>
                                               <asp:BoundColumn DataField="InvoiceID" HeaderText="ID" Visible="false" />
                                               <asp:TemplateColumn ItemStyle-Wrap="false" >
                                                 <ItemTemplate>
                                                    <a target="_blank" href="billingverification.aspx?id=<%# DataBinder.Eval(Container.DataItem,"InvoiceID") %>&CustID=<%# _CustID %>"><%# DataBinder.Eval(Container.DataItem,"InvoiceNumber") %></a>&nbsp;<a target="_blank" href="OldInvoicesReport.aspx?id=<%# DataBinder.Eval(Container.DataItem,"InvoiceID") %>"><img style="border: 0" alt="Group Invoices" src="/graphics/printable.png" />&nbsp;</a><a target="_blank" href="OldSingleInvoicesReport.aspx?id=<%# DataBinder.Eval(Container.DataItem,"InvoiceID") %>"><img style="border: 0" alt="Single Invoices" src="/graphics/printable.png" /></a>
                                                 </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:BoundColumn DataField="Total" HeaderText="Total"  DataFormatString="{0:C}"/>
                                            </Columns>              
                                     </asp:DataGrid>
                                    <div>&nbsp;</div>
                              </td>
                              <td style="width: 3px;">&nbsp;</td>
                              <td>
                                <div class="inputformsectionheader">
                                    Tickets to be invoiced <asp:Label ID="lblTicketCount1" runat="server"></asp:Label>&nbsp;&nbsp;&nbsp;<asp:Label ID="lblTotalSelected" runat="server" ></asp:Label>
                                </div>
                                <div class="inputform" style="width:100%";>
                                  <asp:DataGrid AllowSorting="true" ID="dgvInvoiceTickets" AutoGenerateColumns="false" runat="server" style="background-color: White; width: 100%" OnSortCommand="dgvInvoiceTickets_SortCommand" ShowFooter = "True"  Width="100%" CssClass="Grid1"><FooterStyle cssClass="gridheader" HorizontalAlign="Right" BackColor="#C0C0C0" />
                                    <AlternatingItemStyle CssClass="altrow" />
                                   <HeaderStyle CssClass="gridheader" />
                                    <Columns>
                                      <asp:TemplateColumn>
                                      <ItemTemplate>
                                        <asp:CheckBox ID="chkSelected1" runat="server"  AutoPostBack ="True" OnCheckedChanged="chkSelected1_CheckedChanged" />
                                      </ItemTemplate>
                                    </asp:TemplateColumn>
                                      <asp:BoundColumn DataField="TicketID" HeaderText="ID" Visible="false" />
                                      <asp:TemplateColumn SortExpression="TicketID" HeaderText="Ticket&nbsp;ID">
                                        <ItemTemplate>
                                         <a target="_blank" href="ticket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>"><%# DataBinder.Eval(Container.DataItem,"TicketID") %></a><a target="_blank" href="InvoiceSingleTicket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>"><img style="border: 0" alt="Single Invoices" src="/graphics/printable.png" /></a>
                                        </ItemTemplate>
                                      </asp:TemplateColumn>
                                      <asp:TemplateColumn SortExpression="Company" HeaderText="Customer">
                                        <ItemTemplate>
                                           <asp:Literal id="lblCompany" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Company") %>' />
                                        </ItemTemplate>
                                      </asp:TemplateColumn>
                                      <asp:TemplateColumn SortExpression="CustomerPO" HeaderText="CustomerPO">
                                        <ItemTemplate>
                                            <asp:Literal id="lblCustomerPO" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "CustomerPO") %>' />
                                        </ItemTemplate>
                                      </asp:TemplateColumn>
                                      <asp:TemplateColumn SortExpression="Status" HeaderText="Status">
                                        <ItemTemplate>
                                             <asp:Literal id="lblStatus" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "Status")%>' />
                                        </ItemTemplate>
                                      </asp:TemplateColumn>
                                      <asp:TemplateColumn SortExpression="CloseDate" HeaderText="CloseDate">
                                        <ItemTemplate>
                                             <asp:Literal id="lblCloseDate" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "CloseDate")%>' />
                                        </ItemTemplate>
                                      </asp:TemplateColumn>
                                      <asp:TemplateColumn SortExpression="ServiceType" HeaderText="ServiceType" Footertext="Grand Total:">
                                        <ItemTemplate>
                                            <asp:Literal id="lblServiceType" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "Servicename")%>' />
                                        </ItemTemplate>
                                      </asp:TemplateColumn>
                                      <asp:TemplateColumn SortExpression="LaborAmount" HeaderText="Labor" ItemStyle-HorizontalAlign="Right">
                                        <ItemTemplate>
                                            <asp:Literal id="lblLaborAmount1" runat="server"  text='<%#DataBinder.Eval(Container.DataItem, "LaborAmount")%>' />
                                        </ItemTemplate>
                                        <FooterTemplate  >
                                        <asp:Literal id="lblTotalLaborAmount1" runat="server" />
                                      </FooterTemplate>
                                      </asp:TemplateColumn>
                                      <asp:TemplateColumn SortExpression="AdjustCharge" HeaderText="Extra" ItemStyle-HorizontalAlign="Right">
                                        <ItemTemplate>
                                            <asp:Literal id="lblAdjustCharge1" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "AdjustCharge")%>' />
                                        </ItemTemplate>
                                        <FooterTemplate >
                                        <asp:Literal id="lblTotalAdjustCharge1" runat="server" />
                                      </FooterTemplate>
                                      </asp:TemplateColumn>
                                      <asp:TemplateColumn SortExpression="PartAmount" HeaderText="Part" ItemStyle-HorizontalAlign="Right">
                                        <ItemTemplate>
                                            <asp:Literal id="lblPartAmount1" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "PartAmount")%>' />
                                        </ItemTemplate>
                                        <FooterTemplate >
                                        <asp:Literal id="lblTotalPartAmount1" runat="server" />
                                      </FooterTemplate>
                                      </asp:TemplateColumn>
                                      <asp:BoundColumn DataField="Total" HeaderText="Total" Visible="false" />
                                      <asp:TemplateColumn SortExpression="Total" HeaderText="Total" ItemStyle-HorizontalAlign="Right">
                                        <ItemTemplate>
                                            <asp:Literal id="lblTotal1" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "Total")%>' />
                                        </ItemTemplate>
                                        <FooterTemplate >
                                        <asp:Literal id="lblGrandTotalAmount1" runat="server" />
                                      </FooterTemplate>
                                      </asp:TemplateColumn>
                                    </Columns>
                                  </asp:DataGrid>
                                </div>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                                   
                   </asp:View>
                 </asp:MultiView>
               </td>
             </tr>
           </table>
            </div>
          </asp:View>
          <asp:View ID="viewReceivePayments"  runat="server">
             <table style="width: 100%">
               <tbody >
                 <tr>
                     <td class="band" style="width: 12%">
                        <div class="bandheader">Payment Date</div>
                       <asp:Calendar ID="Calendar1" runat="server" BackColor="white" BorderColor="#999999" DayNameFormat="Shortest" Font-Names="Verdana" Font-Size="8pt" ForeColor="Black" Height="180px" Width="220px" OnSelectionChanged="Calendar1_SelectionChanged" >
                               <SelectedDayStyle BackColor="#666666" Font-Bold="True" ForeColor="White" />
                               <SelectorStyle BackColor="#CCCCCC" />
                               <WeekendDayStyle BackColor="#FFFFCC" />
                               <TodayDayStyle BackColor="#CCCCCC" ForeColor="Black" />
                               <OtherMonthDayStyle ForeColor="#808080" />
                               <NextPrevStyle VerticalAlign="Bottom" />
                               <DayHeaderStyle BackColor="#CCCCCC" Font-Bold="True" Font-Size="7pt" />
                               <TitleStyle BackColor="#999999" BorderColor="Black" Font-Bold="True" />
                            </asp:Calendar>
                        <div class="bandheader" visible= "False"><asp:Label ID="lblTotalVendors" runat="server"></asp:Label></div>
                        <div class="bandheader" visible = "False"></div>
                        <span style="white-space:nowrap"></span>
                        <div class="bandheader" ></div>
                        <asp:DataGrid ID="dgvFolders" runat="server" ShowHeader="false" ShowFooter="false" AutoGenerateColumns="false" CssClass="Grid1">
                            <ItemStyle CssClass="bandbar" />
                              <Columns>
                                <asp:BoundColumn DataField="TicketFolderID" HeaderText="ID" Visible="false" />
                                <asp:TemplateColumn ItemStyle-Wrap="false" >
                                   <ItemTemplate>
                                      <a href="tickets.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketFolderID") %>">&nbsp;(<%# DataBinder.Eval(Container.DataItem,"TicketCount") %>)</a>
                                   </ItemTemplate>
                                </asp:TemplateColumn>
                              </Columns>              
                        </asp:DataGrid>
                        <div>&nbsp;</div>
                        <div class="inputformsectionheader">Payments/Parts Credit</div>
                        <div class="bandheader" visible ="False"><asp:Label ID="lblSearch" runat="server"></asp:Label></div>
                        <div><asp:RadioButtonList ID="rdoType" runat="server"  Visible="False">
                               <asp:listitem   value="1" text="Payment"/>
                               <asp:ListItem   Value="2" text="Parts Credit"/>
                             </asp:RadioButtonList> 
                        </div>
                        <div></div>
                        <div>Invoice Number</div>
                        <div><asp:TextBox ID="txtInvoiceNumber" runat="server" Width ="95%" /></div>
                        <div>TicketID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;WorkOrderID</div>
                        <asp:TextBox ID="txtTicketID" runat="server" Width ="45%" />&nbsp;<asp:TextBox ID="txtWorkOrderID" runat="server" Width ="45%" />
                        <div>Method&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Amount</div>
                        <div><asp:DropDownList ID="drpMethod" runat="server" AutoPostBack="true" Width="53%" OnSelectedIndexChanged="drppartners_change" />&nbsp;<asp:TextBox ID="txtPaidAmount" runat="server" Width="40%"  /></div>
                        <div id="secpartners" runat="server" visible ="false">
                           <div>Partners</div>
                           <div><asp:DropDownList ID="drpPartners" runat="server" AutoPostBack="true" Width="53%" /></div>
                        </div>
                        <div>Check Number</div>
                        <div><asp:TextBox ID="txtCheckNumber" runat="server" width="95%" /></div>
                        <div>Comments</div>
                        <asp:TextBox runat="server" ID="txtComments" TextMode="multiLine" style="width: 95%; height: 50px;" />
                        <div style="text-align: left;"><asp:Button ID="btnDelete" runat="server" Text="Delete" OnClick="btnDelete_Click" />&nbsp;<asp:Button ID="btnRefresh" runat="server" Text="Refresh" OnClick="btnRefresh_Click" />&nbsp;<asp:Button ID="btnSubmit1" runat="server" Text="Record" OnClick="btnSubmit1_Click" /></div>
                        <div class="inputform" visible ="False">
                            <div class="errorzone" id="divJumpToError" runat="server" visible="false">
                                <div class="label" visible ="False"></div>
                                <div><asp:TextBox ID="InvoiceNumber" runat="server" visible ="False"/><asp:TextBox ID="svdInvoiceID" runat="server" Visible = "false" /></div>
                            </div>
                            <div class="inputformsectionheader" visible ="False"></div>
                            <asp:DataGrid ID="dgvPriorInvoices" runat="server" ShowHeader="false" ShowFooter="false" AutoGenerateColumns="false" visible ="False" CssClass="Grid1">
                                <ItemStyle CssClass="bandbar" />
                                  <Columns>
                                    <asp:BoundColumn DataField="InvoiceID" HeaderText="ID" Visible="false" />
                                    <asp:TemplateColumn ItemStyle-Wrap="false" >
                                      <ItemTemplate>
                                      </ItemTemplate>
                                    </asp:TemplateColumn>
                                  </Columns>              
                              </asp:DataGrid>
                        </div>
                     </td>
                     <td>
                        <div class="inputformsectionheader">Labor<asp:Label ID="Label2" runat="server"></asp:Label></div>    
                        <div class="inputform">
                              <asp:DataGrid ID="dgvLabor" runat="server" style="background-color: white; width: 100%"  ShowFooter="false" AutoGenerateColumns="false" CssClass="Grid1">
                                 <HeaderStyle CssClass="gridheader" />
                                 <AlternatingItemStyle CssClass="altrow" />   
                                 <Columns>
                                    <asp:TemplateColumn>
                                       <ItemTemplate>
                                            <asp:CheckBox ID="chkLabor" runat="server"  AutoPostBack ="false" />
                                       </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:BoundColumn DataField="TicketID" HeaderText="TicketID" Visible= "false" />
                                    <asp:TemplateColumn SortExpression="TicketID" HeaderText="Ticket&nbsp;ID">
                                       <ItemTemplate>
                                              <a target ="blank" href="ticket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>"><%# DataBinder.Eval(Container.DataItem,"TicketID") %></a><a target="_blank" href="printableticket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>"></a>
                                       </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn ItemStyle-Wrap="false" HeaderText="Invoice Number" >
                                       <ItemTemplate>
                                            <a  target ="blank" href="billingverification.aspx?id=<%# DataBinder.Eval(Container.DataItem,"InvoiceID") %>&CustID=<%# _ID %>"><%# DataBinder.Eval(Container.DataItem,"InvoiceNumber") %></a>
                                       </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:BoundColumn DataField="Age" HeaderText="Age" />
                                    <asp:BoundColumn DataField="StatusDescription" HeaderText="Status" />
                                    <asp:BoundColumn DataField="DateApproved" HeaderText="Approval Date" />
                                    <asp:BoundColumn DataField="MonthNames" HeaderText="Month" />
                                    <asp:BoundColumn DataField="ReferenceNumber2" HeaderText="CustomerPO" />
                                    <asp:BoundColumn DataField="SerialNumber" HeaderText="SerialNumber" />
                                    <asp:BoundColumn DataField="Status" HeaderText="Status" />
                                    <asp:BoundColumn DataField="AmountCharged" HeaderText="LaborCharged"  DataFormatString="{0:C}"/>
                                    <asp:BoundColumn DataField="AmountPaid" HeaderText="AmountPaid"  DataFormatString="{0:C}"/>
                                    <asp:BoundColumn DataField="Outstanding" HeaderText="Outstanding"  DataFormatString="{0:C}"/>
                                     
                                 </Columns>              
                              </asp:DataGrid>
                           </div>
                           <div>&nbsp;</div>
                           <div class="inputformsectionheader">Parts<asp:Label ID="Label1" runat="server"></asp:Label></div>
                           <div class="inputform">
                              <asp:DataGrid ID="dgvParts" runat="server" style="background-color: white; width: 100%"  ShowFooter = "True" AutoGenerateColumns="false" CssClass="Grid1"><FooterStyle cssClass="gridheader" HorizontalAlign="Right" 
                               BackColor="#C0C0C0" />
                                 <HeaderStyle CssClass="gridheader" />
                                 <AlternatingItemStyle CssClass="altrow" />   
                                 <Columns>
                                      <asp:TemplateColumn>
                                          <ItemTemplate>
                                            <asp:CheckBox ID="chkPart" runat="server"  AutoPostBack ="false" />
                                          </ItemTemplate>
                                      </asp:TemplateColumn>
                                      <asp:BoundColumn DataField="TicketComponentID" HeaderText="TicketComponentID" Visible= "false" />
                                      <asp:BoundColumn DataField="TicketID" HeaderText="TicketID" Visible= "false" />
                                      <asp:BoundColumn DataField="Qty" HeaderText="Qty" />
                                      <asp:BoundColumn DataField="Code" HeaderText="Part Number" />
                                      <asp:BoundColumn DataField="Component" HeaderText="Part Description" />
                                      <asp:BoundColumn DataField="SerialNumber" HeaderText="Invoice Number" />
                                      <asp:BoundColumn DataField="TotalPartAmount" HeaderText="Total Part Charge"  DataFormatString="{0:C}" Visible="false"/>
                                      <asp:TemplateColumn SortExpression="TotalPartAmount" HeaderText="Total Part Charge" ItemStyle-HorizontalAlign="Right">
                                        <ItemTemplate>
                                              <asp:Literal id="lblTotalPartAmount" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "TotalPartAmount")%>' />
                                        </ItemTemplate>
                                        <FooterTemplate >
                                              <asp:Literal id="lblGrandTotalPartAmount" runat="server" />
                                        </FooterTemplate>
                                      </asp:TemplateColumn>
                                      <asp:BoundColumn DataField="AmountPaid" HeaderText="AmountPaid"  DataFormatString="{0:C}" visible="false" />
                                      <asp:TemplateColumn SortExpression="AmountPaid" HeaderText="AmountPaid" ItemStyle-HorizontalAlign="Right">
                                         <ItemTemplate>
                                              <asp:Literal id="lblAmountPaid" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "AmountPaid")%>' />
                                         </ItemTemplate>
                                         <FooterTemplate >
                                               <asp:Literal id="lblGrandTotalAmountPaid" runat="server" />
                                         </FooterTemplate>
                                      </asp:TemplateColumn>
                                      <asp:BoundColumn DataField="Outstanding" HeaderText="Outstanding"  DataFormatString="{0:C}" visible="false"/>
                                      <asp:TemplateColumn SortExpression="Outstanding" HeaderText="Outstanding" ItemStyle-HorizontalAlign="Right">
                                         <ItemTemplate>
                                             <asp:Literal id="lblOutstanding" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "Outstanding")%>' />
                                         </ItemTemplate>
                                         <FooterTemplate >
                                             <asp:Literal id="lblGrandTotalOutstanding" runat="server" />
                                         </FooterTemplate>
                                      </asp:TemplateColumn>
                                     <asp:BoundColumn DataField ="RMA" HeaderText="RMA" />
                                      
                                 </Columns>              
                              </asp:DataGrid>
                           </div>
                           <div>&nbsp;<asp:Label ID="lblTotalCharge" runat="server"></asp:Label></div>
                           <div>&nbsp;<asp:Label ID="lblTotalPayment" runat="server"></asp:Label></div>
                           <div>&nbsp;</div>
                           <div class="inputformsectionheader">Tickets List<asp:Label ID="lblTicketCount2" runat="server"></asp:Label></div>
                           <div class="inputform">
                               <asp:DataGrid AllowSorting="true" ID="dgvTickets" AutoGenerateColumns="false" runat="server" style="background-color: White; width: 100%" ShowFooter = "True" CssClass="Grid1" ><FooterStyle cssClass="gridheader" HorizontalAlign="Right" 
                                     BackColor="#C0C0C0" />
                                     <AlternatingItemStyle CssClass="altrow" />
                                     <HeaderStyle CssClass="gridheader" />
                                     <Columns>
                                        <asp:TemplateColumn>
                                          <ItemTemplate>
                                            <asp:CheckBox ID="chkSelected" runat="server"   />
                                          </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField = "PaymentID" HeaderText ="PaymentID" Visible="false" />
                                        <asp:BoundColumn DataField="InvoiceNumber" HeaderText ="InvNumber" />
                                        <asp:BoundColumn DataField="TicketID" HeaderText="ID" Visible="false" />
                                        <asp:TemplateColumn SortExpression="TicketID" HeaderText="Ticket&nbsp;ID">
                                            <ItemTemplate>
                                             <a target="_blank" href="ticket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>"><%# DataBinder.Eval(Container.DataItem,"TicketID") %></a>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="WorkOrderID" HeaderText="WOID" Visible="false" />
                                        <asp:TemplateColumn SortExpression="WorkOrderID" HeaderText="PO">
                                            <ItemTemplate>
                                               <asp:Literal id="lblWorkOrderID" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "WorkOrderID") %>' />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn SortExpression="Status" HeaderText="Status">
                                            <ItemTemplate>
                                                <asp:Literal id="lblStatus" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Status") %>' />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn SortExpression="Company" HeaderText="Company">
                                            <ItemTemplate>
                                                 <asp:Literal id="lblCompany" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "Company")%>' />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn SortExpression="CloseDate" HeaderText="CloseDate">
                                            <ItemTemplate>
                                                 <asp:Literal id="lblCloseDate" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "CloseDate")%>' />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="Method" HeaderText="Method" Visible="True" />
                                        <asp:BoundColumn DataField="Labor" HeaderText="Labor" Visible="false" />
                                        <asp:TemplateColumn SortExpression="Labor" HeaderText="Labor" ItemStyle-HorizontalAlign="Right">
                                            <ItemTemplate>
                                                <asp:Literal id="lblLabor" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "Labor")%>' />
                                            </ItemTemplate>
                                            <FooterTemplate >
                                              <asp:Literal id="lblGrandTotalLaborAmount" runat="server" />
                                            </FooterTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="Parts" HeaderText="Parts" Visible="false" />
                                        <asp:TemplateColumn SortExpression="Parts" HeaderText="Parts" ItemStyle-HorizontalAlign="Right">
                                            <ItemTemplate>
                                                <asp:Literal id="lblParts" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "Parts")%>' />
                                            </ItemTemplate>
                                            <FooterTemplate >
                                               <asp:Literal id="lblGrandTotalPartAmount" runat="server" />
                                            </FooterTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="AmountCharged" HeaderText="Total" Visible="false" />
                                        <asp:TemplateColumn SortExpression="AmountCharged" HeaderText="Total" ItemStyle-HorizontalAlign="Right">
                                            <ItemTemplate>
                                                <asp:Literal id="lblAmountCharged" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "AmountCharged")%>' />
                                            </ItemTemplate>
                                            <FooterTemplate >
                                               <asp:Literal id="lblGrandTotalAmountCharged" runat="server" />
                                            </FooterTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="AmountPaid" HeaderText="Paid" Visible="false" />
                                        <asp:TemplateColumn SortExpression="AmountPaid" HeaderText="Paid" ItemStyle-HorizontalAlign="Right">
                                            <ItemTemplate>
                                                <asp:Literal id="lblAmountPaid" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "AmountPaid")%>' />
                                            </ItemTemplate>
                                            <FooterTemplate >
                                               <asp:Literal id="lblGrandTotalAmountPaid" runat="server" />
                                            </FooterTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="AmountDue" HeaderText="Due" Visible="false" />
                                        <asp:TemplateColumn SortExpression="AmountDue" HeaderText="Due" ItemStyle-HorizontalAlign="Right">
                                            <ItemTemplate>
                                                <asp:Literal id="lblAmountDue" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "AmountDue")%>' />
                                            </ItemTemplate>
                                            <FooterTemplate >
                                              <asp:Literal id="lblGrandTotalAmountDue" runat="server" />
                                            </FooterTemplate>
                                        </asp:TemplateColumn>
                                     </Columns>
                                 </asp:DataGrid>
                               </div>
                         
                     </td>
                 </tr>
              </tbody>
             </table>
             <asp:Label ID="lblSortOrder" runat="server" Visible="false" />
          </asp:View>
          <asp:View ID="viewOutstandingBalance"  runat="server">
            <div style="background-color:#83acca; text-align:center;" class="tabbody">
            <table >
              <tr>
                <td>
                
                   <asp:DropDownList ID="drpStatus" runat="server" Visible="false" ></asp:DropDownList><asp:DropDownList ID="drpCustomers" runat="server" ></asp:DropDownList>
                
              </td>
                <td>
                   <div><rad:RadDatePicker ID="RadDatePickerFrom" runat="server"  DateInput-Font-Size="Medium" Culture="English (United States)" SelectedDate="2012-05-15" Skin="" Calendar-Skin="Web20" Calendar-FastNavigationStep="12" Calendar-MonthLayout="Layout_7columns_x_6rows">
                       <DateInput Font-Size="Medium" Skin="">
                       </DateInput>
                   </rad:RadDatePicker></div>
                </td>
                <td>
                   <div><rad:RadDatePicker ID="RadDatePickerTo" runat="server"  DateInput-Font-Size="Medium" Culture="English (United States)" SelectedDate="2012-05-15" Skin="" Calendar-Skin="Web20" Calendar-FastNavigationStep="12" Calendar-MonthLayout="Layout_7columns_x_6rows">
                       <DateInput Font-Size="Medium" Skin="">
                       </DateInput>
                   </rad:RadDatePicker></div>
                </td>
                <td>
                   <div><asp:Button ID="btnView" runat="server"  Text="View" OnClick="btnView_Click"/></div>
                </td>
                <td>
                   <div><asp:ImageButton ID="btnExport" AlternateText ="Export to Excel" ImageUrl ="/images/Excel-16.gif"  ImageAlign="right"  OnClick="btnExport_Click" runat="server"/></div> 
                </td>
              </tr>
             </table> 
             <div style="text-align:left"><asp:Label ID="lblTicketCount" runat="server"></asp:Label></div> </div>
             <table width ="100%"> 
               <tr>
               <td>
                  <asp:DataGrid ID="dgvStatuses" runat="server" style="background-color: white; width: 100%" ShowFooter="false" AutoGenerateColumns="false" Width ="100%" CssClass="Grid1">
              <HeaderStyle CssClass="gridheader" />
              <AlternatingItemStyle CssClass="altrow" />
              <Columns>
                <asp:BoundColumn DataField="TicketClaimApprovalStatusID" HeaderText="ID" Visible="false" />
                <asp:TemplateColumn  HeaderText ="Filter by Status" >
                  <ItemTemplate>
                     <a href="accountsreceivables.aspx?id=<%=_ID%>&CustID=<%=drpCustomers.selectedValue%>&t=2&dt1=<%=RadDatePickerFrom.SelectedDate%>&dt2=<%=RadDatePickerTo.SelectedDate%>&StatusID=<%# DataBinder.Eval(Container.DataItem,"TicketClaimApprovalStatusID") %>"><%#DataBinder.Eval(Container.DataItem, "_Status")%></a>&nbsp;(<%# DataBinder.Eval(Container.DataItem,"Total") %>)
                  </ItemTemplate> 
                </asp:TemplateColumn>
              </Columns> 
            </asp:DataGrid>
               </td>
               <td>
            <asp:DataGrid ID="dgvOutstandingBalance" runat="server" style="background-color: white; width: 100%"  ShowFooter="True" AutoGenerateColumns="false" AllowSorting="true" OnSortCommand="dgvOutstandingBalance_SortCommand" CssClass="Grid1"><FooterStyle cssClass="gridheader" HorizontalAlign="Right" BackColor="#C0C0C0" />
              <HeaderStyle CssClass="gridheader" />
              <AlternatingItemStyle CssClass="altrow" />   
              <Columns>
              <asp:BoundColumn DataField="InvoiceID" HeaderText="InvoiceID" Visible= "false" />
                 <asp:TemplateColumn SortExpression="TicketID" HeaderText="Ticket&nbsp;ID">
                    <ItemTemplate>
                      <a target ="blank" href="ticket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>"><%# DataBinder.Eval(Container.DataItem,"TicketID") %></a><a target="_blank" href="printableticket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>"></a>
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
                  <asp:TemplateColumn ItemStyle-Wrap="false" HeaderText="Invoice"  SortExpression="Invoice">
                  <ItemTemplate>
                    <a  target ="blank" href="billingverification.aspx?id=<%# DataBinder.Eval(Container.DataItem,"InvoiceID") %>&CustID=<%# _ID %>"><%# DataBinder.Eval(Container.DataItem,"InvoiceNumber") %></a>
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:BoundColumn DataField="Age" HeaderText="Age" SortExpression="Age" />
                <asp:BoundColumn DataField="StatusDescription" HeaderText="Status" SortExpression="StatusDescription"/>
                 <asp:BoundColumn DataField="DateApproved" HeaderText="Date" SortExpression="DateApproved"/>
                 <asp:BoundColumn DataField="MonthNames" HeaderText="Month" SortExpression="MonthNames"/>
                <asp:BoundColumn DataField="ReferenceNumber2" HeaderText="CustomerPO" SortExpression="ReferenceNumber2"/>
                <asp:BoundColumn DataField="AmountCharged" HeaderText="Labor"  DataFormatString="{0:C}" ItemStyle-HorizontalAlign="Right" SortExpression="AmountCharged" Visible="false"/>
                <asp:TemplateColumn SortExpression="AmountCharged" HeaderText="Labor" ItemStyle-HorizontalAlign="Right">
                    <ItemTemplate>
                        <asp:Literal id="lblLaborTotal" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "AmountCharged")%>' />
                    </ItemTemplate>
                    <FooterTemplate >
                    <asp:Literal id="lblGrandTotalLaborAmount" runat="server" />
                  </FooterTemplate>
                  </asp:TemplateColumn>
                <asp:BoundColumn DataField="PartsCharged" HeaderText="Parts"  DataFormatString="{0:C}" ItemStyle-HorizontalAlign="Right" SortExpression="PartsCharged" Visible="false"/>
                <asp:TemplateColumn SortExpression="PartsCharged" HeaderText="Parts" ItemStyle-HorizontalAlign="Right">
                    <ItemTemplate>
                        <asp:Literal id="lblPartsTotal" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "PartsCharged")%>' />
                    </ItemTemplate>
                    <FooterTemplate >
                    <asp:Literal id="lblGrandTotalPartsAmount" runat="server" />
                  </FooterTemplate>
                  </asp:TemplateColumn>
                <asp:BoundColumn DataField="TotalCharged" HeaderText="Total"  DataFormatString="{0:C}" ItemStyle-HorizontalAlign="Right" SortExpression="TotalCharged" Visible="false"/>
                <asp:TemplateColumn SortExpression="TotalCharged" HeaderText="Total" ItemStyle-HorizontalAlign="Right">
                    <ItemTemplate>
                        <asp:Literal id="lblTotalCharged" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "TotalCharged")%>' />
                    </ItemTemplate>
                    <FooterTemplate >
                    <asp:Literal id="lblGrandTotalChargedAmount" runat="server" />
                  </FooterTemplate>
                  </asp:TemplateColumn>
                
                <asp:BoundColumn DataField="AmountPaid" HeaderText="Paid"  DataFormatString="{0:C}" ItemStyle-HorizontalAlign="Right" SortExpression="AmountPaid"/>
                <asp:BoundColumn DataField="Outstanding" HeaderText="Unpaid"  DataFormatString="{0:C}" Visible="false" SortExpression="Outstanding"/>
                 <asp:TemplateColumn SortExpression="Outstanding" HeaderText="Unpaid" ItemStyle-HorizontalAlign="Right">
                    <ItemTemplate>
                        <asp:Literal id="lblTotal" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "Outstanding")%>' />
                    </ItemTemplate>
                    <FooterTemplate >
                    <asp:Literal id="lblGrandTotalAmount" runat="server" />
                  </FooterTemplate>
                  </asp:TemplateColumn>
              </Columns>              
            </asp:DataGrid>
                 </td>
              </tr>
            </table>
            <asp:Label ID="lblSortOrder1" runat="server" Visible="false" />
          </asp:View>
          </asp:MultiView>
    
    <asp:Label ID="lblReturnUrl" runat="server" Visible="false" />
</form>
</asp:Content>
