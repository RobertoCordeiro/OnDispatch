<%@ Page Language="vb" masterpagefile="~/masters/agent.master" MaintainScrollPositionOnPostback = "True" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">

  Private _ID As Long = 1
  Private lngCustID as long = 1
    Private lngIt As Long
    Private mListLaborTotal As Double
    Private mListPartsTotal As Double
    Private mListChargedTotal As Double
    Private mListPaidTotal As Double
    Private mListDueTotal As Double
    Private mFocus as Integer
    Private mCheckedTotal As Double
    Private mTotalPartAmount As Double
    Private mTotalAmountPaid As Double
    Private mTotalOutstanding As Double
        
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
        lblTicketCount.Text = ""
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
            Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " - Record Payments"
            Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " - Record Payments"
            Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; Record Payments"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
      If _ID < 1 Then
        _ID = 1
      End If
    Catch ex As Exception
      _ID = 1
    End Try
        mListLaborTotal = 0
        mListPartsTotal = 0
        mListChargedTotal = 0
        mListPaidTotal = 0
        mListDueTotal = 0
        
        
        If (Not Page.IsPostBack) Then
            txtCheckNumber.Text = ""
            txtInvoiceNumber.Text = ""
            txtTicketID.Text = ""
            LoadMethods()
            loadpartners()
            Dim datDate2 As DateTime
            If Calendar1.SelectedDate = "#12:00:00 AM#" Then
                datDate2 = Now()
            Else
                datDate2 = Calendar1.SelectedDate & " 23:29:00"
            End If
        else
        
        End If
  End Sub
  
  Private Sub LoadPaidTickets()
    Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim ldl as New Loaders(system.Configuration.ConfigurationManager.AppSettings ("DBCnn"))
    Dim inv as New BridgesInterface.PaymentRecord (system.Configuration.ConfigurationManager.AppSettings ("DBCnn"))
    Dim lngCustomerID as Long
        Dim strChangeLog As String
    Dim datDate2 as DateTime 
    strChangeLog = ""
    If Calendar1.SelectedDate = "#12:00:00 AM#" Then
       datDate2 = Now()
    Else
       datDate2 = Calendar1.SelectedDate & " 23:59:59"
    END IF


    If txtTicketID.Text.ToString <> "" then
      tkt.Load(Ctype(txtTicketID.Text,long)) 
      lngCustomerID = tkt.CustomerID 
      If tkt.InvoiceID <> 0 And Not IsDbNull(tkt.InvoiceID) then
        inv.Add (tkt.InvoiceID,1,drpMethod.selectedvalue,Ctype(txtPaidAmount.text,Double ),datDate2)
        ldl.LoadStringDateParameterDataGrid ("spGetPaidInvoices","@CheckNumber",txtCheckNumber.Text,"@DateCreated",Calendar1.SelectedDate,dgvTickets )
      End if 
    else
      If txtInvoiceNumber.Text <> "" or Not IsDbNull(txtInvoiceNumber.Text) then
      
      end if
    end if
    
    For Each itm As DataGridItem In dgvTickets.Items
      If CType(itm.Cells(0).Text, Long) = Ctype(txtTicketID.Text,Long) Then
        itm.CssClass = "selectedbandbar"
      End If
    Next
    End Sub
    
  Private Sub RecordPayment()
    Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim invrecord as New BridgesInterface .InvoiceRecord(system.Configuration.ConfigurationManager.AppSettings ("DBCnn"))
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim ldl as New Loaders(system.Configuration.ConfigurationManager.AppSettings ("DBCnn"))
    Dim inv as New BridgesInterface.PaymentRecord (system.Configuration.ConfigurationManager.AppSettings ("DBCnn"))
    Dim pay as New BridgesInterface.PaymentRecord (system.Configuration.ConfigurationManager.AppSettings ("DBCnn"))
    Dim jrn as New BridgesInterface.JournalEntryRecord (system.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strChangeLog as string
    Dim datDate2 As DateTime
    Dim lngInvoiceID as long
    
    strChangeLog = ""
    If Calendar1.SelectedDate = "#12:00:00 AM#" Then
       datDate2 = Now()
    Else
       datDate2 = Calendar1.SelectedDate & " 23:59:59"
    END IF
    
        If txtPaidAmount.Text.ToString <> "" Then
        
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
                    'If txtTicketID.Text.ToString <> "" Then
                    '    tkt.Load(CType(txtTicketID.Text, Long))
                    '    If (tkt.InvoiceID <> 0) And (Not IsDBNull(tkt.InvoiceID)) Then
                    '        'If rdoType.SelectedItem.Value = "1" Then
                    '        inv.Add(tkt.InvoiceID, 1, drpMethod.SelectedValue, CType(txtPaidAmount.Text, Double), datDate2)
                    '        inv.CheckNumber = txtCheckNumber.Text.ToString
                    '        If txtTicketID.Text.ToString <> "" Then
                    '            inv.TicketID = CType(txtTicketID.Text, Long)
                    '        Else
                    '            inv.TicketID = 0
                    '        End If
                    '        If txtWorkOrderID.Text.ToString <> "" Then
                    '            inv.WorkOrderID = CType(txtWorkOrderID.Text, Long)
                    '        Else
                    '            inv.WorkOrderID = 0
                    '        End If
                    '        inv.Comments = txtComments.Text.ToString
                    '        inv.Save(strChangeLog)

                    '        Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                    '        tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, drpMethod.SelectedItem.ToString & ": Payment record has been processed - " & txtTicketID.Text & " / CheckNumber: " & txtCheckNumber.Text & " - Amount: $" & txtPaidAmount.Text)

                    '        tnt.CustomerVisible = False
                    '        tnt.PartnerVisible = False
                    '        tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                    '        tnt.Acknowledged = True
                    '        tnt.Save(strChangeLog)

                    '        ldl.LoadStringDateParameterDataGrid("spGetPaidInvoices", "@CheckNumber", CType(txtCheckNumber.Text, String), "@DateCreated", datDate2, dgvTickets)
                    '        For Each itm As DataGridItem In dgvTickets.Items
                    '            If CType(itm.Cells(3).Text, Long) = CType(txtTicketID.Text, Long) Then
                    '                itm.CssClass = "selectedbandbar"
                    '            End If
                    '        Next
                    '        'End If
                    '    Else
                    '        MsgBox("This ticket has not been invoiced. Unable to record payment.You must invoice this ticket first before we can submit payment.")
                    '    End If
                    'Else

                    'End If
   
                Case Is = 11 'credit for parts
                    
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
                        'If txtTicketID.Text.ToString <> "" Then
                        '    tkt.Load(CType(txtTicketID.Text, Long))
                        '    If tkt.InvoiceID <> 0 And Not IsDBNull(tkt.InvoiceID) Then
                        '        'If rdoType.SelectedItem.Value = "1" Then
                        '        inv.Add(tkt.InvoiceID, 1, drpMethod.SelectedValue, CType(txtPaidAmount.Text, Double), datDate2)
                        '        inv.CheckNumber = txtCheckNumber.Text.ToString
                        '        If txtTicketID.Text.ToString <> "" Then
                        '            inv.TicketID = CType(txtTicketID.Text, Long)
                        '        Else
                        '            inv.TicketID = 0
                        '        End If
                        '        If txtWorkOrderID.Text.ToString <> "" Then
                        '            inv.WorkOrderID = CType(txtWorkOrderID.Text, Long)
                        '        Else
                        '            inv.WorkOrderID = 0
                        '        End If
                        '        inv.Comments = txtComments.Text.ToString
                        '        inv.Save(strChangeLog)

                        '        Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                        '        tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, drpMethod.SelectedItem.ToString & ": Payment record has been processed - " & txtTicketID.Text & " / CheckNumber: " & txtCheckNumber.Text & " - Amount: $" & txtPaidAmount.Text)

                        '        tnt.CustomerVisible = False
                        '        tnt.PartnerVisible = False
                        '        tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                        '        tnt.Acknowledged = True
                        '        tnt.Save(strChangeLog)

                        '        ldl.LoadStringDateParameterDataGrid("spGetPaidInvoices", "@CheckNumber", CType(txtCheckNumber.Text, String), "@DateCreated", datDate2, dgvTickets)
                        '        For Each itm As DataGridItem In dgvTickets.Items
                        '            If CType(itm.Cells(3).Text, Long) = CType(txtTicketID.Text, Long) Then
                        '                itm.CssClass = "selectedbandbar"
                        '            End If
                        '        Next
                        '        'End If
                        '    End If
                        'Else

                        'End If
    
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
                                'ldl.LoadLongStringParameterDataGrid("spGetPaidInvoicesByInvoiceID", "@InvoiceID", lngInvoiceID, "@CheckNumber", txtCheckNumber.Text, dgvTickets)
            
                                Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                                tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, drpMethod.SelectedItem.ToString & ": Payment record has been processed - " & txtTicketID.Text & " / CheckNumber: " & txtCheckNumber.Text)
         
                                tnt.CustomerVisible = False
                                tnt.PartnerVisible = False
                                tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                                tnt.Acknowledged = True
                                tnt.Save(strChangeLog)
            
                                For Each itm As DataGridItem In dgvTickets.Items
                                    If itm.Cells(2).Text.ToString = txtInvoiceNumber.Text.ToString Then
                                        itm.CssClass = "selectedbandbar"
                                    End If
                                Next
                            Else
                                MsgBox("Unable to find Invoice Number. Unable to Update Record in the system.")
                            End If
                            MsgBox("Invoice Number has been recorded as paid. All tickets belonging to this invoice has been updated.")

                        Else
                            MsgBox("You must enter an Invoice Number in the field called Invoice Number.")

                        End If
    
                Case Is = 15 'credit for labor
    
                Case Is = 17 'Journal Entry
                        Dim lngPartnerID As Long
                        Dim lngTicketID As Long
                        Dim lngWorkOrderID As Long
                        If drpPartners.SelectedValue <> "Choose One" Then
                            If txtInvoiceNumber.Text <> "" Then
                                If txtTicketID.Text.ToString <> "" Then
                                    If txtWorkOrderID.Text.ToString <> "" Then
                                        'Submitting Journal Entry having Invoice Number,ticketID and work orderID
                                        lngInvoiceID = GetInvoiceIDByInvoiceNumber(txtInvoiceNumber.Text.ToString)
                                        invrecord.Load(lngInvoiceID)

                                        lngPartnerID = invrecord.PartnerID
                                        lngTicketID = CType(txtTicketID.Text, Long)
                                        lngWorkOrderID = CType(txtWorkOrderID.Text, Long)
             
                                        jrn.Add(lngPartnerID, 0, CType(txtPaidAmount.Text, Double), lngInvoiceID, lngTicketID, lngWorkOrderID, txtComments.Text.ToString, Now(), datDate2)
             
             
                                    Else
                                        'Submitting journal entry having invoice number and ticketID
                                        lngInvoiceID = GetInvoiceIDByInvoiceNumber(txtInvoiceNumber.Text.ToString)
                                        invrecord.Load(lngInvoiceID)

                                        lngPartnerID = invrecord.PartnerID
                                        lngTicketID = CType(txtTicketID.Text, Long)
                          
                                        jrn.Add(lngPartnerID, 0, CType(txtPaidAmount.Text, Double), lngInvoiceID, lngTicketID, 0, txtComments.Text.ToString, Now(), datDate2)
             
                   
                                    End If
                                Else
                                    If txtWorkOrderID.Text <> "" Then
                                        'Submitting journal entry having invoice number and work orderID
                                        lngInvoiceID = GetInvoiceIDByInvoiceNumber(txtInvoiceNumber.Text.ToString)
                                        invrecord.Load(lngInvoiceID)

                                        lngPartnerID = invrecord.PartnerID
                                        lngWorkOrderID = CType(txtWorkOrderID.Text, Long)
                          
                                        jrn.Add(lngPartnerID, 0, CType(txtPaidAmount.Text, Double), lngInvoiceID, 0, lngWorkOrderID, txtComments.Text.ToString, Now(), datDate2)
             
             
                                    Else
                                        'Submitting journal entry with invoice number only
                                        lngInvoiceID = GetInvoiceIDByInvoiceNumber(txtInvoiceNumber.Text.ToString)
                                        invrecord.Load(lngInvoiceID)

                                        lngPartnerID = invrecord.PartnerID
                          
                                        jrn.Add(lngPartnerID, 0, CType(txtPaidAmount.Text, Double), lngInvoiceID, 0, 0, txtComments.Text.ToString, Now(), datDate2)
             
                 
                                    End If
                                End If
                            Else
                                If txtTicketID.Text <> "" Then
                                    If txtWorkOrderID.Text <> "" Then
                                        'Submitting journal entry having ticketID and workOrderID 
                                        lngPartnerID = invrecord.PartnerID
                                        lngTicketID = CType(txtTicketID.Text, Long)
                                        lngWorkOrderID = CType(txtWorkOrderID.Text, Long)
             
                                        jrn.Add(lngPartnerID, 0, CType(txtPaidAmount.Text, Double), 0, lngTicketID, lngWorkOrderID, txtComments.Text.ToString, Now(), datDate2)
             
             
                                    Else
                                        'Submitting journal entry having ticketID only
                                        lngPartnerID = invrecord.PartnerID
                                        lngTicketID = CType(txtTicketID.Text, Long)
                                        jrn.Add(lngPartnerID, 0, CType(txtPaidAmount.Text, Double), 0, lngTicketID, 0, txtComments.Text.ToString, Now(), datDate2)
             
                                    End If
                                Else
                                    'Submitting journal entry having just the partnerID
                                    lngPartnerID = CType(drpPartners.SelectedValue, Long)
             
                                    jrn.Add(lngPartnerID, 0, CType(txtPaidAmount.Text, Double), 0, 0, 0, txtComments.Text.ToString, Now(), datDate2)
             
             
                                End If
                            End If
                        Else
                            'set up to enter journal entry for customers
                        End If
                Case Else
            End Select
            
        Else
            If txtCheckNumber.Text.ToString <> "" Then
                
                ProcessLaborPayment(CLng(txtTicketID.Text))
                ProcessPartsPayment(CLng(txtTicketID.Text))
                
            Else
                MsgBox("You must enter a check number to be processed")
            End If
        
        End If
    End Sub
  
  Private Sub LoadMethods()
      Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      ldr.LoadSimpleDropDownList ("splistPaymentMethods","Method","MethodID",drpMethod)
      
    End Sub
    Function GetInvoiceIDByInvoiceNumber(ByVal strInvoiceNumber As String) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetInvoiceIDByInvoiceNumber")
        Dim lngInvoiceID As Long

        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@InvoiceNumber", Data.SqlDbType.VarChar, len(strInvoiceNumber)).Value = strInvoiceNumber
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
        lblTicketCount.Text = " ( " & CType(dgvTickets.DataSource, Data.DataSet).Tables(0).Rows.Count & " ) "
       
    End Sub
  
  Private Sub btnSubmit1_Click(ByVal S As Object, ByVal E as EventArgs )
    recordPayment()
    
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
    end if
    
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
    
Function CheckForErrors() as boolean

Dim dgItem As DataGridItem
Dim chkbox As CheckBox
Dim boolError as Boolean 

boolError = True
 
 For Each dgItem in dgvTickets.Items
     chkbox = dgItem.FindControl("chkselected")
            If chkbox.Checked Then
                
                If (dgItem.Cells.Item(12).Text) = "" Or (dgItem.Cells.Item(12).Text) = "&nbsp;" Then
                    boolError = False
                    Exit For
                End If
            End If
 Next
 CheckForErrors = boolError
 
end function
    
    Protected Sub Calendar1_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        'InvoiceNumber.Text = Calendar1.SelectedDate
        'LoadPartners()
        dgvTickets.DataSource = Nothing
        dgvTickets.DataBind()
    End Sub
    
    Private Sub btnDelete_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim ldl As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim dgItem As DataGridItem
        Dim chkbox As CheckBox
        Dim intPaymentID As Integer
        Dim datDate2 As DateTime
        
        If Calendar1.SelectedDate = "#12:00:00 AM#" Then
            datDate2 = Now()
        Else
            datDate2 = Calendar1.SelectedDate & " 23:59:59"
        End If
        
        For Each dgItem In dgvTickets.Items
            chkbox = dgItem.FindControl("chkselected")
            If chkbox.Checked Then
                intPaymentID = CType(dgItem.Cells.Item(1).Text, Long)
                
                Dim payr As New BridgesInterface.PaymentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                payr.Load(intPaymentID)
                
                payr.Delete()
                
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
        drppartners.Items.Add("Choose One")
       
        drpPartners.SelectedValue = "Choose One"
        
    End Sub
    Private sub drppartners_change (ByVal S As Object, ByVal E As EventArgs)
      if drpmethod.SelectedValue = 17 then
        secpartners.Visible = True
      else
        secpartners.Visible = False
      end if
    end sub
    
   Private Sub MsgBox(ByVal strMessage As String) 
'Begin building the script 
Dim strScript As String = "<SCRIPT LANGUAGE=""JavaScript"">" & vbCrLf 
strScript += "alert(""" & strMessage & """)" & vbCrLf 
strScript += "<" & "/" & "SCRIPT" & ">" 
'Register the script for the client side 
ClientScript.RegisterStartupScript(GetType(String), "messageBox", strScript ) 
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
                  
                   If chkbox.Checked then
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
                            Else
                                pay.Add(tkt.InvoiceID, 1, 11, CDec(dgItem.Cells.Item(6).Text), datDate2)
                                par.Load(CLng(dgItem.Cells.Item(1).Text.ToString))
                                par.Paid = True
                                par.Save(strChangeLog)
                                
                                dblselectedAmount = CDec(dgItem.Cells.Item(6).Text)
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
                            
                            tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, "Credit for Parts: Payment record has been processed - " & txtTicketID.Text & " / CheckNumber: " & txtCheckNumber.Text & " - Amount: $" & dblselectedAmount & " - Part Description: " & dgItem.Cells.Item(4).Text)
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
                
                Dim plog As New BridgesInterface.ProductionLogRecord(System.Configuration.ConfigurationManager.AppSettings ("DBCnn"))
                plog.Add(Master.WebLoginID,Now(),8,"Parts Credit record has been processed - " & txtTicketID.Text & " / CheckNumber: " & txtCheckNumber.Text)
                
                        
                Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
                eml.Subject = "Production from: " & strUserName
                eml.Body = "Parts Credit record has been processed - " & txtTicketID.Text & " / CheckNumber: " & txtCheckNumber.Text
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
                
                'production
           
                'Dim usr As New BridgesInterface.UserRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                'usr.Load(Master.LoginID)
                Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                wbl.Load(Master.WebLoginID)
                Dim strUserName As String
                strUserName = wbl.Login
                
                Dim plog As New BridgesInterface.ProductionLogRecord(System.Configuration.ConfigurationManager.AppSettings ("DBCnn"))
                plog.Add(Master.WebLoginID ,Now(), 7,"Payment/Credit record has been processed - " & txtTicketID.Text & " / CheckNumber: " & txtCheckNumber.Text )
                        
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
        Dim lngTotalCharge As Double
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TicketID", Data.SqlDbType.Int).Value = lngTicketID
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            lngTotalCharge = dtr("TotalCharged")
        End While
        cnn.Close()
        Return lngTotalCharge
    End Function
    
    Private Function GetTotalPayment(ByVal lngTicketID As Long) As Double
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spOutstandingBalanceByTicketID")
        Dim lngTotalPayment As Double
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TicketID", Data.SqlDbType.Int).Value = lngTicketID
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            lngTotalPayment = dtr("TotalAmountPaid")
            
        End While
        cnn.Close()
        Return lngTotalPayment
    End Function
    
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
  <form id="frmTickets" runat="server" >
    <table style="width: 100%">
      <tbody>
        <tr>
          <td class="band" style="width: 12%">
            <div class="bandheader">Payment Date</div>
            <asp:Calendar ID="Calendar1" runat="server" BackColor="white" BorderColor="#999999" DayNameFormat="Shortest" Font-Names="Verdana" Font-Size="8pt" ForeColor="Black" Height="180px" Width="210px" OnSelectionChanged="Calendar1_SelectionChanged" >
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
            <span style="white-space:nowrap">
            </span>
            
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
            <div >Invoice Number</div>
            <div><asp:TextBox ID="txtInvoiceNumber" runat="server" Width ="95%" />
            <div>TicketID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;WorkOrderID</div>
            <asp:TextBox ID="txtTicketID" runat="server" Width ="45%" />&nbsp;<asp:TextBox ID="txtWorkOrderID" runat="server" Width ="45%" /></div>
            <div>Method&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Amount</div>
            <div><asp:DropDownList ID="drpMethod" runat="server" AutoPostBack="true" Width="53%" OnSelectedIndexChanged="drppartners_change" />&nbsp;<asp:TextBox ID="txtPaidAmount" runat="server" Width="40%"  /></div>
            <div id="secpartners" runat="server" visible ="false">
            <div>Partners</div>
            <div><asp:DropDownList ID="drpPartners" runat="server" AutoPostBack="true" Width="53%" /></div></div>
            <div>Check Number</div>
            <div><asp:TextBox ID="txtCheckNumber" runat="server" width="95%" /></div>
            <div>Comments</div>
            <asp:TextBox runat="server" ID="txtComments" TextMode="multiLine" style="width: 95%; height: 50px;" />
            <div style="text-align: left;"><asp:Button ID="btnDelete" runat="server" Text="Delete" OnClick="btnDelete_Click" />&nbsp;<asp:Button ID="btnRefresh" runat="server" Text="Refresh" OnClick="btnRefresh_Click" />&nbsp;<asp:Button ID="btnSubmit1" runat="server" Text="Record" OnClick="btnSubmit1_Click" /></div>
            <div class="inputform" visible ="False">
              <div class="errorzone" id="divJumpToError" runat="server" visible="false" />
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
          </td>
          <td style="width: 3px;">&nbsp;</td>
          <td>
            <div class="inputformsectionheader">
                Labor<asp:Label ID="Label2" runat="server"></asp:Label>
            </div>
            <div class="inputform">
           <asp:DataGrid ID="dgvLabor" runat="server" style="background-color: white; width: 100%"  ShowFooter="false" AutoGenerateColumns="false" CssClass="Grid1" >
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
            <div class="inputformsectionheader">
                Parts<asp:Label ID="Label1" runat="server"></asp:Label>
            </div>
             <div class="inputform">
           <asp:DataGrid ID="dgvParts" runat="server" style="background-color: white; width: 100%"  ShowFooter="true" AutoGenerateColumns="false" CssClass="Grid1"><FooterStyle cssClass="gridheader" HorizontalAlign="Right" 
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
                <asp:BoundColumn DataField="Code" HeaderText="Part Number" />
                 <asp:BoundColumn DataField="Component" HeaderText="Part Description" />
                 <asp:BoundColumn DataField ="serialnumber" HeaderText = "Order Number - Invoice Number" />
                <asp:BoundColumn DataField="TotalPartAmount" HeaderText="Part Charge"  DataFormatString="{0:C}" Visible="false"/>
                <asp:BoundColumn DataField="AmountPaid" HeaderText="AmountPaid"  DataFormatString="{0:C}" Visible="false"/>
                <asp:BoundColumn DataField="Outstanding" HeaderText="Outstanding"  DataFormatString="{0:C}" Visible="false"/>
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
              </Columns>              
            </asp:DataGrid>
            </div>
            <div>&nbsp;<asp:Label ID="lblTotalCharge" runat="server"></asp:Label></div>
            <div>&nbsp;<asp:Label ID="lblTotalPayment" runat="server"></asp:Label></div>

           <div>&nbsp;</div>
            <div class="inputformsectionheader">
                Tickets List<asp:Label ID="lblTicketCount" runat="server"></asp:Label>
            </div>
            <div class="inputform">
            <asp:DataGrid AllowSorting="true" ID="dgvTickets" AutoGenerateColumns="false" runat="server" style="background-color: White; width: 100%" ShowFooter = "True" Cssclass="Grid1" ><FooterStyle cssClass="gridheader" HorizontalAlign="Right" 
             BackColor="#C0C0C0" />
                <AlternatingItemStyle CssClass="altrow" />
                <HeaderStyle CssClass="gridheader" />
                <Columns>
                  <asp:TemplateColumn>
                  <ItemTemplate>
                    <asp:CheckBox ID="chkSelected" runat="server"  AutoPostBack ="True" />
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
  </form>
  <asp:Label ID="lblSortOrder" runat="server" Visible="false" />
</asp:Content>