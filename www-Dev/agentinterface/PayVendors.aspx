<%@ Page Language="vb" masterpagefile="~/masters/agent.master" MaintainScrollPositionOnPostback = "True" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">

    Private _ID As Long = 0
    Private _InfoID As Long = 0
    Private lngCustID As Long = 0
    Private _PartnerID As Long = 0
  Private lngIt as long 
    Private mListLaborTotal As Double
    Private mListExtraTotal As Double
    Private mListPartTotal As Double
    Private mListTotal As Double
    Private mFocus as Integer
    Private mCheckedTotal As Double
    Private mListCoreChargeTotal As Double
    Private mListPartCostTotal As Double
    Private mListTotalPartsCharge As Double
    Private mTotalSelected As Double
    Private mListTotalPay As Double
    Private mListGrandTotalPay As Double
    Private mListTotalTickets As Integer
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
            Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " - Pay Vendors"
            Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " - Pay Vendors"
            Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; Pay Vendors"
            
        End If
        
        If (Not Page.IsPostBack) Then
            Session.Clear()
            menu5.Items(0).Selected = True
            Multiview1.ActiveViewIndex = 0
        Else
            If CType(Session("SelectedPartner"), Long) > 0 Then
                drpPartners.SelectedValue = CType(Session("SelectedPartner"), Long)
            End If
        End If
         lblTotalVendors.Text = " ( " & drpPartners.Items.Count() & " ) "
            btnJump.Attributes.Add("onclick", "return confirm('You are about to create an Invoice, do you want to continue?');")

    End Sub
  
    Private Sub LoadOldInvoices()
    if drpPartners.SelectedValue <> "Choose One" then
      Dim ldr as New cvCommon.Loaders(system.Configuration.ConfigurationManager .AppSettings ("DBCnn"))
      ldr.LoadSingleLongParameterDataGrid ("spGetVendorInvoicesByPartnerID","@PartnerID",drpPartners.selectedValue,dgvOldInvoices)
      Dim inv As New BridgesInterface.InvoiceRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))    

      Dim dgv1 As System.Web.UI.WebControls.DataGrid
      For Each itm As DataGridItem In dgvOldInvoices.Items
        inv.Load(CType(itm.Cells(0).Text, Long))  
        dgv1 = itm.FindControl ("dgvPayments")
        LoadPayments (CType(itm.Cells(0).Text, Long),dgv1)
      
        dgv1 = itm.FindControl ("dgvJournal")
        loadJournal (Ctype(itm.Cells(0).Text,Long),dgv1)
      Next
   end if 
  End Sub

    Private Sub LoadTicketsByInvoiceID(ByVal lngInvoiceID As Long, ByVal lngCustomerID As Long)
       
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSingleLongParameterDataGrid("spBillingVerificationByInvoiceID", "@InvoiceID", lngInvoiceID, dgvTickets)
        lblTicketCount.Text = " ( " & CType(dgvTickets.DataSource, Data.DataSet).Tables(0).Rows.Count & " ) "
       
    End Sub

    Private Sub LoadTicketsByPartners(ByVal lngPartnerID As Long, ByVal datDate As DateTime)
        Dim chkbox As CheckBox
        Dim datDate1 As Date
        datDate1 = Replace(Calendar1.SelectedDate, "#", "")
        datDate1 = datDate1 & " 23:59:00"
        datDate1 = CType(datDate1, DateTime)
        Dim ldl As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        drpPartners.SelectedValue = lngPartnerID
        If Calendar1.SelectedDate <> "#12:00:00 AM#" Then
            ldl.LoadLongDateParameterDataGrid("spGetListTicketsTopayBYPartnerID", "@PartnerID", CType(drpPartners.SelectedValue, Long), "@Date", datDate1, dgvTickets)
            lblTicketCount.Text = " ( " & CType(dgvTickets.DataSource, Data.DataSet).Tables(0).Rows.Count & " ) "
            btnJump.Enabled = True
        Else
            ldl.LoadLongDateParameterDataGrid("spGetListTicketsTopayBYPartnerID", "@PartnerID", CType(drpPartners.SelectedValue, Long), "@Date", datDate, dgvTickets)
            lblTicketCount.Text = " ( " & CType(dgvTickets.DataSource, Data.DataSet).Tables(0).Rows.Count & " ) " 
            btnJump.Enabled = False
        End If
        For Each itm As DataGridItem In dgvPartnerList.Items
            If CType(itm.Cells(1).Text, Long) = lngPartnerID Then
                itm.CssClass = "selectedbandbar"
                chkbox = CType(itm.FindControl("chkTechSelected"), CheckBox)
                chkbox.Checked = True
            Else
                itm.CssClass = "Grid1"
            End If
        Next
    End Sub
    Private Sub LoadTicketsByOldInvoiceID(ByVal lngInvoiceID As Long)
       
        Dim ldl As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        
        ldl.LoadSingleLongParameterDataGrid ("spGetListPartnerTicketsByInvoiceID","@InvoiceID",lngInvoiceID,dgvTickets)    
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
  
  Private Sub btnJump_Click(ByVal S As Object, ByVal E As EventArgs)
   
      Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim wko As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim inv As New BridgesInterface.InvoiceRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim invItem As New BridgesInterface.InvoiceItemRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim par As New BridgesInterface.TicketComponentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim dgItem As DataGridItem
        Dim chkbox As CheckBox
        Dim FindLabel As System.Web.UI.WebControls.Literal
      Dim strInvoiceNumber as String
      Dim lngInvoiceID as Integer
        Dim strChangeLog As String = ""
        Dim price As Double
        
        btnJump.Enabled = False
      price = 0
      strInvoiceNumber = 0
        If Multiview1.ActiveViewIndex = 0 Then
            If CheckForErrors() = True Then
                strInvoiceNumber = CreateInvoiceNumber(CType(drpPartners.SelectedItem.Text, Long))
                inv.Add(30, 1, "Mothly vendor Payment")
                inv.InvoiceNumber = strInvoiceNumber
                lngInvoiceID = inv.InvoiceID
                inv.IsVendorPayment = True
                inv.PartnerID = drpPartners.SelectedValue
                svdInvoiceID.Text = lngInvoiceID
                'add contacts and address for billing later on
                'add total amount
                lblTicketCount.Text = strInvoiceNumber
      
                For Each dgItem In dgvTickets.Items
                    chkbox = dgItem.FindControl("chkselected")
                    If chkbox.Checked Then
                        wko.Load(CType(dgItem.Cells.Item(3).Text, Integer))
                        wko.InvoiceID = lngInvoiceID
                        wko.Invoiced = True
                        wko.Save(strChangeLog)
               
                        tnt.Add(CType(dgItem.Cells.Item(1).Text, Integer), Master.WebLoginID, Master.UserID, "This Ticket is part of the vendor payment group: " & strInvoiceNumber)
                        tnt.CustomerVisible = False
                        tnt.PartnerVisible = True
                        tnt.Acknowledged = False
                        tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                        tnt.Save(strChangeLog)
                
                        price = price + CDec(dgItem.Cells.Item(15).Text)
                
                        InvoiceNumber.Text = price.ToString("C2")
                    End If
                Next
                invItem.Add(lngInvoiceID, 1, "Vendor Payment", 1, price, 0)
                inv.Save(strChangeLog)
        
            Else
                lblTicketCount.Text = " | ATTENTION! You must verify the totals for the tickets you have checked in. Unable to create invoice."
  
            End If
        Else
            If CheckForErrors1() = True Then
                strInvoiceNumber = CreatePartInvoiceNumber(CType(drpPartners.SelectedItem.Text, Long))
                inv.Add(30, 1, "Monthly Part Charges")
                inv.InvoiceNumber = strInvoiceNumber
                lngInvoiceID = inv.InvoiceID
                inv.IsVendorPayment = True
                inv.IsVendorPartInvoice = True
                inv.PartnerID = drpPartners.SelectedValue
                svdInvoiceID.Text = lngInvoiceID
                'add contacts and address for billing later on
                'add total amount
                lblTicketCount.Text = strInvoiceNumber
      
                For Each dgItem In dgvChargeParts.Items
                    chkbox = dgItem.FindControl("chkselected1")
                   
                    
                   
                    If chkbox.Checked Then
                        par.Load(CType(dgItem.Cells.Item(1).Text, Integer))
                        par.InvoiceID = lngInvoiceID
                        par.Save(strChangeLog)
                       
               
                        tnt.Add( CType(dgItem.Cells.Item(2).Text, Integer), Master.WebLoginID, Master.UserID, "This Ticket is part of the vendor Parts Charge group: " & strInvoiceNumber)
                        tnt.CustomerVisible = False
                        tnt.PartnerVisible = True
                        tnt.Acknowledged = False
                        tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                        tnt.Save(strChangeLog)
                        
                        FindLabel = (dgItem.FindControl("lblTotalCharge"))
                        price = price + CDec(FindLabel.Text)
                        
                        
                    End If
                Next
                price = price * -1
                InvoiceNumber.Text = price.ToString("C2")
                invItem.Add(lngInvoiceID, 1, "Vendor Parts Charge",  1, price, 0)
                
                inv.Save(strChangeLog)
        
            Else
                lblTicketCount.Text = " | ATTENTION! Each ticket checked in must have a valid amount. Null value as prices are not allowed. Unable to create invoice."
  
            End If
        End If
    End Sub
  
  Protected Sub dgvTickets_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    If lblSortOrder.Text.ToLower = " asc" Then
      lblSortOrder.Text = " desc"
    Else
      lblSortOrder.Text = " asc"
    End If
        Dim datDate1 As Date
        datDate1 = Replace(Calendar1.SelectedDate, "#", "")
        datDate1 = datDate1 & " 23:59:00"
        datDate1 = CType(datDate1, DateTime)
        Dim ldl As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        
        If Calendar1.SelectedDate <> "#12:00:00 AM#" Then
            ldl.LoadLongDateParameterDataGrid("spGetListTicketsTopayBYPartnerID", "@PartnerID", CType(drpPartners.SelectedValue, Long), "@Date", datDate1, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
        Else
            ldl.LoadLongDateParameterDataGrid("spGetListTicketsTopayBYPartnerID", "@PartnerID", CType(drpPartners.SelectedValue, Long), "@Date", Now(), dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
       
        End If
        RePopulateCheckBoxes()
 
   
  End Sub
 
  
 Private Sub LoadPartners()
        Dim inf As New BridgesInterface.CompanyInfoRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        inf.Load(Master.InfoID)
        Dim ldl As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim datCurDate As DateTime
       
            datCurDate = Calendar1.SelectedDate & " 23:59:00"
        ldl.LoadTwoLongDateParameterDropDownList("spListPayPartnersByInfoID", "@InfoID", Master.InfoID, "@DefaultPartnerID", inf.PartnerID, "@UptoDate", datCurDate, "ResumeID", "PartnerID", drpPartners)
       
            drpPartners.Items.Add("Choose One")
            drpPartners.SelectedValue = "Choose One"
        
      
    End Sub
    
    Private Sub LoadPartnerList(lngPartnerID As Long)
        Dim inf As New BridgesInterface.CompanyInfoRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        inf.Load(Master.InfoID)
        Dim ldl As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim datCurDate As DateTime
       
        datCurDate = Calendar1.SelectedDate & " 23:59:00"
        ldl.LoadTwoLongDateParameterDataGrid("spListPayPartnersByInfoID", "@InfoID", Master.InfoID, "@DefaultPartnerID", inf.PartnerID, "@UptoDate", datCurDate, dgvPartnerList)
       
        lblTotalVendors.Text = " ( " & drpPartners.Items.Count() & " ) "
        
        If lngPartnerID <> 0 Then
            For Each itm As DataGridItem In dgvPartnerList.Items
                If CType(itm.Cells(1).Text, Long) = lngPartnerID Then
                    itm.CssClass = "selectedbandbar"

                Else
                    itm.CssClass = "Grid1"
                End If
            Next
           
        End If
        
    End Sub

    
    Protected Sub drpPartners_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim datDate2 As DateTime
        
        If drpPartners.SelectedValue <> "Choose One" Then
            If Calendar1.SelectedDate <> "#12:00:00 AM#" Then
                If btnJump.Enabled = False Then
                    btnJump.Enabled = True
                End If
            Else
                datDate2 = Now()
               
                If btnJump.Enabled = False Then
                    btnJump.Enabled = True
                End If
            End If
             menu5.Items(0).Selected= true
             Multiview1.ActiveViewIndex = 0   
        End If
    End Sub
    
    Private Sub dgvTickets_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgvTickets.ItemDataBound
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
        Dim datClosingDate as Date 
        Dim lblClosingDate as System.Web.UI.WebControls.Literal
        
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
                lblClosingDate = Ctype(e.Item.FindControl ("lblCloseDate"), System.Web.UI.WebControls.Literal)
                lblClosingDate.text = FormatDateTime(datClosingDate,DateFormat.ShortDate).ToString
                
                'get the value for the laboramount and add it to the sum
                price = CDec(rowData.Item("LaborAmount"))
                mListLaborTotal += price
                
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
                listLaborLabel = CType(e.Item.FindControl("lblLaborAmount"), System.Web.UI.WebControls.Literal)
          
                'now format the list price in currency format
                listLaborLabel.Text = price.ToString("C2")

                'get the value for the extra amount and add it to the sum
                price = CDec(rowData.Item("AdjustPay"))
                mListExtraTotal += price

                'get the control used to display the discounted price
                listExtraLabel = CType(e.Item.FindControl("lblAdjustCharge"), System.Web.UI.WebControls.Literal)
          
                'now format the discounted price in currency format
                listExtraLabel.Text = price.ToString("C2")
                

                'get the value for the PartAmount and add it to the sum
                If Not IsDBNull(rowData.Item("PartAmount")) Then
                    price = CDec(rowData.Item("PartAmount"))
                    mListPartTotal += price
                    
                    If (price > 0) And (strStatus = "Closed - Resolved") and listLaborLabel.Text = 0 Then
                       e.Item.ForeColor = Drawing.Color.DarkGreen
                    End If
               End If
                'get the control used to display the PartAmount price
                listPartLabel = CType(e.Item.FindControl("lblPartAmount"), System.Web.UI.WebControls.Literal)
          
                'now format the discounted price in currency format
                listPartLabel.Text = price.ToString("C2")

                'get the value for the Total and add it to the sum
                If Not IsDBNull(rowData.Item("Total")) Then
                    price = CDec(rowData.Item("Total"))
                    mListTotal += price
                End If
                'get the control used to display the PartAmount price
                listTotalLabel = CType(e.Item.FindControl("lblTotal"), System.Web.UI.WebControls.Literal)
          
                'now format the discounted price in currency format
                listTotalLabel.Text = price.ToString("C2")
                
            Case ListItemType.Footer

                'get the control used to display the total of the list prices
                'and set its value to the total of the list prices
                GrandLabortotalLabel = CType(e.Item.FindControl("lblTotalLaborAmount"), System.Web.UI.WebControls.Literal)
                GrandLabortotalLabel.Text = mListLaborTotal.ToString("C2")
          
                'get the control used to display the total of the extra prices
                'and set its value to the total of the discounted prices
                GrandExtraTotalLabel = CType(e.Item.FindControl("lblTotalAdjustCharge"), System.Web.UI.WebControls.Literal)
                GrandExtraTotalLabel.Text = mListExtraTotal.ToString("C2")
                
                GrandPartTotalLabel = CType(e.Item.FindControl("lblTotalPartAmount"), System.Web.UI.WebControls.Literal)
                GrandPartTotalLabel.Text = mListPartTotal.ToString("C2")
                
                GrandTotalLabel = CType(e.Item.FindControl("lblGrandTotalAmount"), System.Web.UI.WebControls.Literal)
                GrandTotalLabel.Text = mListTotal.ToString("C2")
                
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
    For Each dgITem In dgvTickets.Items        
    'Retrieve key value of each record based on DataGrids        
    ' DataKeyField property        
    
      'ChkBxIndex = dgvTickets.DataKeys(1)        
      ChkBox = dgItem.FindControl("chkSelected")        
      'Add ArrayList to Session if it doesnt exist        
      If Not IsNothing(Session ("CheckedItems")) Then            
        CheckedItems = Session ("CheckedItems")        
      End If        
      If ChkBox.Checked Then            
                  
        'Add to Session if it doesnt already exist            
        If Not CheckedItems.Contains(dgitem.Cells.Item(1).text) Then                
          CheckedItems.Add(dgitem.Cells.Item(1).text)            
        End If        
      Else            
        'Remove value from Session when unchecked            
        CheckedItems.Remove(dgitem.Cells.Item(1).text)        
      End If  
     
    Next
    'Update Session with the list of checked items    
    Session ("CheckedItems") = CheckedItems 
 'end if          
    
    End Sub
     
Private Sub RePopulateCheckBoxes ()

        Dim CheckedItems As ArrayList = New ArrayList
    Dim dgItem As DataGridItem
    'Dim chkBxIndex as Integer 
    Dim chkbox As CheckBox
    
    CheckedItems = Session ("CheckedItems")

    If Not IsNothing(CheckedItems) Then

    'Loop through GridView Items                
    For Each dgItem In dgvTickets.Items  

      'ChkBxIndex = dgvTickets.DataKeys(dgitem.Cells.Item(1).text)

      'Repopulate GridView with items found in Session                
      If CheckedItems.Contains(dgitem.Cells.Item(1).text) Then

        ChkBox = CType(dgItem.FindControl("chkSelected"), CheckBox)
        ChkBox.Checked = True
        

      End If
   Next
End If
End Sub

Protected Sub chkSelected_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim ck1 As CheckBox = CType(sender, CheckBox)
        Dim CheckedItems As ArrayList = New ArrayList
        Dim dgItem As DataGridItem = CType(ck1.NamingContainer, DataGridItem)
               
       'now we've got what we need!
        'If invoiceNumber.Text = "" then
        'InvoiceNumber.Text = ""
        'end if
       
        If ck1.Checked Then
            If Not IsNothing(Session("CheckedItems")) Then
                CheckedItems = Session("CheckedItems")
                'price = CDec(dgItem.Cells.Item(12).Text)
                'invoicenumber.text = price.ToString 
                
            End If
            'Add to Session if it doesnt already exist            
            If Not CheckedItems.Contains(dgItem.Cells.Item(1).Text) Then
                CheckedItems.Add(dgItem.Cells.Item(1).Text)
            End If
            'production
            Dim plog As New BridgesInterface.ProductionLogRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            plog.Add(Master.WebLoginID, Now(), 14, "Vendor Payment - checked ticket for payment: " & dgItem.Cells.Item(1).Text)
        Else
            'Remove value from Session when unchecked            
            CheckedItems.Remove(dgItem.Cells.Item(1).Text)
        End If
        LoadData(drpPartners.SelectedValue)
End Sub

Protected Sub Page_Unload(ByVal sender As Object, ByVal e As System.EventArgs)
        'GetCheckBoxValues()
        'GetCheckBoxValues1()
End Sub

Function SortOrder (Field As String) As String
  Dim so As String = Session ("SortOrder")
    If Field = so Then
      SortOrder = Replace (Field,"asc","desc")
    ElseIf Field <> so Then
      SortOrder = Replace (Field,"desc","asc")
    Else
      SortOrder = Replace (Field,"asc","desc")
    End If
   'Maintain persistent sort order 
   Session ("SortOrder") = SortOrder
End Function

    Function CreateInvoiceNumber(ByVal lngResumeID As Integer) As String
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spCreateCustomerInvoiceNumber")
        Dim strInvoiceNumber As String

        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@CustomerNumber", Data.SqlDbType.Int).Value = lngResumeID
        cnn.Open()
        cmd.Connection = cnn
        strInvoiceNumber = cmd.ExecuteScalar()
        cnn.Close()
        CreateInvoiceNumber = strInvoiceNumber
    End Function

Function CheckForErrors() as boolean

Dim dgItem As DataGridItem
Dim chkbox As CheckBox
Dim boolError as Boolean 
        Dim FindLabel As System.Web.UI.WebControls.Literal
boolError = True
 
 For Each dgItem in dgvTickets.Items
     chkbox = dgItem.FindControl("chkselected")
            If chkbox.Checked Then
                FindLabel = dgItem.FindControl("lblTotal")
                If FindLabel.Text = "" Or FindLabel.Text = "&nbsp;" Then
                    boolError = False
                    Exit For
                End If
            End If
 Next
 CheckForErrors = boolError
 
end function
    
    Protected Sub Calendar1_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        
        LoadPartners()
        LoadPartnerList(0)
        dgvTickets.DataSource = Nothing
        dgvTickets.DataBind()
        menu5.Items(0).Selected= true
        Multiview1.ActiveViewIndex = 0
    End Sub
        
    Private Sub menu5_MenuItemClick(ByVal sender As Object, ByVal e As MenuEventArgs) Handles menu5.MenuItemClick
        Multiview1.ActiveViewIndex = Int32.Parse(e.Item.Value)
        Select Case Int32.Parse(e.Item.Value)
            
            Case Is = 0
                
              
               
            Case Is = 1
                If drpPartners.SelectedValue <> "Choose One" Then
                    LoadInvoiceNumbers()
                    LoadJournalEntries()
                End If
            Case Is = 2
                If drpPartners.SelectedValue <> "Choose One" Then
                    LoadPartnerNotes(CType(Session("SelectedPartner"), Long))
                End If
            Case Is = 3
                If drpPartners.SelectedValue <> "Choose One" Then
                    LoadOldInvoices()
                End If
            Case Is = 4
                If drpPartners.SelectedValue <> "Choose One" Then
                    If dgvChargeParts.Items.Count = 0 Then
                        LoadNeedPartsReturned()
                        
                    End If
                End If
        End Select
        
    End Sub
    
    Private Sub LoadJournalEntries()
        Dim datDate2 As DateTime
        datDate2 = Now()
        Dim datDate1  As DateTime

        
        datDate1 = replace(calendar1.SelectedDate ,"#","")
        datDate1 = datDate1 & " 23:59:00"
        datDate1 = CType(datDate1, DateTime)
        
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        If drpPartners.SelectedValue <> "Choose One" Then
            If Calendar1.SelectedDate <> "#12:00:00 AM#" Then
                ldr.LoadLongDateParameterDataGrid("spGetJournalEntriesByPartnerIDAndEndDate", "@PartnerID", CType(Session("SelectedPartner"), Long), "@EndPayPeriod", datDate1, dgvJournalEntries)
            Else
                ldr.LoadLongDateParameterDataGrid("spGetJournalEntriesByPartnerIDAndEndDate", "@PartnerID", CType(Session("SelectedPartner"), Long), "@EndPayPeriod", datDate2, dgvJournalEntries)
            End If
        End If
        
    End Sub
    Private Sub btnAddBillingNote_Click(ByVal S As Object, ByVal E As EventArgs)
    dim ptr as New BridgesInterface.PartnerRecord(system.configuration.configurationmanager.appsettings("DBCnn"))    
        ptr.Load(CType(Session("SelectedPartner"), Long))
    If txtBillingNote.Text.Trim.Length > 0 Then
      Dim rnt As New BridgesInterface.PartnerNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            rnt.Add(CType(Session("SelectedPartner"), Long), Master.UserID, txtBillingNote.Text)
      
            LoadPartnerNotes(CType(Session("SelectedPartner"), Long))
      txtBillingNote.Text = ""
    End If
  End Sub
  Private Sub LoadPartnerNotes(ByVal lngPartnerID As Long)
    
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListPartnerNotes", "@PartnerID", lngPartnerID,dgvBillingNotes)
  End Sub
  
  Private Sub LoadPayments(lngInvoiceID as long, dgv as System.Web.UI.WebControls.DataGrid)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      If Not IsNothing(dgv) Then
        ldr.LoadSingleLongParameterDataGrid("spGetInvoicePaymentsByInvoiceID", "@InvoiceID", lngInvoiceID, dgv)
      End If
  End Sub
  
  Private Sub LoadJournal(lngInvoiceID as long, dgv as System.Web.UI.WebControls.DataGrid)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      If Not IsNothing(dgv) Then
        ldr.LoadSingleLongParameterDataGrid("spGetJournalEntriesForInvoice", "@InvoiceID", lngInvoiceID, dgv)
      End If
  End Sub
    Private Sub LoadNeedPartsReturned()
        
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSingleLongParameterDataGrid("spListPartsChargeByPartnerID", "@PartnerID", CType(drpPartners.SelectedValue, Long), dgvChargeParts)
      
        lblTicketCount1.Text = " [ " & CType(dgvChargeParts.DataSource, Data.DataSet).Tables(0).Rows.Count & " ] "

  
    End Sub
    
    Private Sub btnExport_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs)
        Dim ex As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
     
        If dgvChargeParts.Items.Count > 0 Then
            ex.ExportGrid("PartsNotReturned.xls", dgvChargeParts)
        End If
    End Sub
    
    Private Sub dgvChargeParts_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgvChargeParts.ItemDataBound
        Dim rowData As Data.DataRowView
        Dim price As Decimal
        Dim price1 As Decimal
        Dim priceTotal As Decimal
        Dim listCoreChargeLabel As System.Web.UI.WebControls.Literal
        Dim listPartCostLabel As System.Web.UI.WebControls.Literal
        Dim listTotalPartChargeLabel As System.Web.UI.WebControls.Literal
        Dim GrandTotalCoreChargeLabel As System.Web.UI.WebControls.Literal
        Dim GrandTotalPartCostLabel As System.Web.UI.WebControls.Literal
        Dim GrandTotalChargeLabel As System.Web.UI.WebControls.Literal
       
        
        Dim strStatus As String
        
        
        'check the type of item that was databound and only take action if it 
        'was a row in the datagrid
        Select Case (e.Item.ItemType)
            Case ListItemType.AlternatingItem, ListItemType.EditItem, ListItemType.Item, ListItemType.SelectedItem
                'get the data for the item being bound
               
                rowData = CType(e.Item.DataItem, Data.DataRowView)
                strStatus = (rowData.Item("Status"))
                'If strStatus = "Closed - Canceled" Then
                'e.Item.ForeColor = Drawing.Color.Red
                'End If
                
                
                'get the value for the laboramount and add it to the sum
                If rowData.Item("ChargeTechCoreAmount").ToString = True Then
                    price = CDec(rowData.Item("CoreCharge"))
                Else
                    price = 0
                End If
                mListCoreChargeTotal += price
                
                
                
                'If price = 0 And strStatus <> "Closed - Canceled" Then
                'e.Item.ForeColor = Drawing.Color.RoyalBlue
                'End If
                
                
                'get the control used to display the list price
                'NOTE: This can be done by using the FindControl method of the 
                '      passed item because ItemTemplates were used and the anchor
                '      controls in the templates where given IDs.  If a standard
                '      BoundColumn was used, the data would have to be accessed
                '      using the cellscollection (e.g. e.Item.Cells(1).controls(1)
                '      would access the label control in this example.
                listCoreChargeLabel = CType(e.Item.FindControl("lblCoreCharge"), System.Web.UI.WebControls.Literal)
          
                'now format the list price in currency format
                listCoreChargeLabel.Text = price.ToString("C2")
               

                'get the value for the PartAmount and add it to the sum
                
                If Not IsDBNull(rowData.Item("PartCost")) Then
                    If rowData.Item("BillTaxes").ToString = True Then
                        price1 = CDec(rowData.Item("PartCost"))
                    Else
                        price1 = 0
                    End If
                    mListPartCostTotal = mListPartCostTotal + price1

                End If
                'get the control used to display the PartAmount price
                listPartCostLabel = CType(e.Item.FindControl("lblPartCost"), System.Web.UI.WebControls.Literal)
          
                'now format the discounted price in currency format
                listPartCostLabel.Text = price1.ToString("C2")
              
                'get the value for the Total and add it to the sum
                
                priceTotal = price + price1
                mListTotalPartsCharge += priceTotal
               
                'get the control used to display the PartAmount price
                listTotalPartChargeLabel = CType(e.Item.FindControl("lblTotalCharge"), System.Web.UI.WebControls.Literal)
          
                'now format the discounted price in currency format
                listTotalPartChargeLabel.Text = priceTotal.ToString("C2")
                
                
                
            Case ListItemType.Footer

                'get the control used to display the total of the list prices
                'and set its value to the total of the list prices
                GrandTotalCoreChargeLabel = CType(e.Item.FindControl("lblTotalCoreCharge"), System.Web.UI.WebControls.Literal)
                GrandTotalCoreChargeLabel.Text = mListCoreChargeTotal.ToString("C2")
          
                GrandTotalPartCostLabel = CType(e.Item.FindControl("lblTotalPartCost"), System.Web.UI.WebControls.Literal)
                GrandTotalPartCostLabel.Text = mListPartCostTotal.ToString("C2")
                
                GrandTotalChargeLabel = CType(e.Item.FindControl("lblGrandTotalCharge"), System.Web.UI.WebControls.Literal)
                GrandTotalChargeLabel.Text = mListTotalPartsCharge.ToString("C2")
                
                
            Case Else
                'ListItemType.Header, ListItemType.Pager, or ListItemType.Separator
                'no action required
                
        End Select
        
    End Sub  'dgvTickets_ItemDataBound
    
    Protected Sub chkSelected1_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim ck2 As CheckBox = CType(sender, CheckBox)
        Dim CheckedItems1 As ArrayList = New ArrayList
        Dim dgItem As DataGridItem = CType(ck2.NamingContainer, DataGridItem)
       
        
        
        'now we've got what we need!
        'If invoiceNumber.Text = "" then
        'InvoiceNumber.Text = ""
        'end if
       
        If ck2.Checked Then
           
            If Not IsNothing(Session("CheckedItems1")) Then
                CheckedItems1 = Session("CheckedItems1")
                'price1 = CDec(dgItem.Cells.Item(8).Text)
                'invoicenumber.text = price.ToString 
            End If
            'Add to Session if it doesnt already exist            
            If Not CheckedItems1.Contains(dgItem.Cells.Item(1).Text) Then
                CheckedItems1.Add(dgItem.Cells.Item(1).Text)
               
               
            End If
         
        Else
            'Remove value from Session when unchecked            
            CheckedItems1.Remove(dgItem.Cells.Item(1).Text)
            
        End If
        LoadData(CType(Session("SelectedPartner"), Long))
        
    End Sub
    Private Sub RePopulateCheckBoxes1()

        Dim CheckedItems1 As ArrayList = New ArrayList
        Dim dgItem As DataGridItem
        'Dim chkBxIndex as Integer 
        Dim chkbox1 As CheckBox
    
        CheckedItems1 = Session("CheckedItems1")
        
        
        
        If Not IsNothing(CheckedItems1) Then

            'Loop through GridView Items                
            For Each dgItem In dgvChargeParts.Items
                
                'ChkBxIndex = dgvTickets.DataKeys(dgitem.Cells.Item(1).text)

                'Repopulate GridView with items found in Session                
                If CheckedItems1.Contains(dgItem.Cells.Item(1).Text) Then

                    chkbox1 = CType(dgItem.FindControl("chkSelected1"), CheckBox)
                    chkbox1.Checked = True
                    
                End If
            Next
        End If
    End Sub
    Private Sub GetCheckBoxValues1()
        'As paging occurs store checkbox values    
        Dim dgItem1 As DataGridItem
        Dim chkbox1 As CheckBox
        'Dim chkBxIndex as Integer 
        Dim CheckedItems1 As ArrayList = New ArrayList
    
        'If Not isnothing (Session("CheckedItems"))then
        'Loop through DataGrid Items    
        For Each dgItem1 In dgvChargeParts.Items
            'Retrieve key value of each record based on DataGrids        
            ' DataKeyField property        
    
            'ChkBxIndex = dgvTickets.DataKeys(1)        
            chkbox1 = dgItem1.FindControl("chkSelected1")
            'Add ArrayList to Session if it doesnt exist        
            If Not IsNothing(Session("CheckedItems1")) Then
                CheckedItems1 = Session("CheckedItems1")
            End If
            If chkbox1.Checked Then
                  
                'Add to Session if it doesnt already exist            
                If Not CheckedItems1.Contains(dgItem1.Cells.Item(1).Text) Then
                    CheckedItems1.Add(dgItem1.Cells.Item(1).Text)
                End If
            Else
                'Remove value from Session when unchecked            
                CheckedItems1.Remove(dgItem1.Cells.Item(1).Text)
            End If
     
        Next
        'Update Session with the list of checked items    
        Session("CheckedItems1") = CheckedItems1
        'end if          
        
    End Sub
    Function CreatePartInvoiceNumber(ByVal lngResumeID As Integer) As String
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spCreateCustomerInvoiceNumber")
        Dim strInvoiceNumber As String

        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@CustomerNumber", Data.SqlDbType.Int).Value = lngResumeID
        cnn.Open()
        cmd.Connection = cnn
        strInvoiceNumber = cmd.ExecuteScalar()
        cnn.Close()
        CreatePartInvoiceNumber = "P" & strInvoiceNumber
    End Function
   
    Function CheckForErrors1() As Boolean

        Dim dgItem As DataGridItem
        Dim chkbox As CheckBox
        Dim boolError As Boolean

        boolError = True
 
        For Each dgItem In dgvChargeParts.Items
            chkbox = dgItem.FindControl("chkselected1")
            If chkbox.Checked Then
                
                If (dgItem.Cells.Item(8).Text) = "" Or (dgItem.Cells.Item(8).Text) = "&nbsp;" Then
                    boolError = False
                    Exit For
                End If
            End If
        Next
        CheckForErrors1 = boolError
 
    End Function
    
    Protected Sub chkTechSelected_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim ck1 As CheckBox = CType(sender, CheckBox)
        Dim dgItem As DataGridItem = CType(ck1.NamingContainer, DataGridItem)
        
        If ck1.Checked Then
            Session.Clear()
            LoadData(CType(dgItem.Cells.Item(1).Text, Long))
        End If
    End Sub
    Private Sub LoadData(lngSelectedPartnerID As Long)
        mListLaborTotal = 0
        mListExtraTotal = 0
        mListPartTotal = 0
        mListTotal = 0
        GetCheckBoxValues()
        GetCheckBoxValues1()
        GetCheckBoxValues_PartnerList()
        LoadPartnerList(lngSelectedPartnerID)
        LoadTicketsByPartners(lngSelectedPartnerID, Calendar1.SelectedDate)
        LoadJournalEntries()
        LoadPartnerNotes(lngSelectedPartnerID)
        LoadOldInvoices()
        LoadNeedPartsReturned()
        Session("SelectedPartner") = lngSelectedPartnerID
        RePopulateCheckBoxes()
        RePopulateCheckBoxes1()
        RePopulateCheckBoxes_PartnerList()
        
    End Sub
    
    Private Sub dgvPartnerList_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgvPartnerList.ItemDataBound
        Dim rowData As Data.DataRowView
        Dim price As Decimal
        Dim total As Integer
        Dim listLaborLabel As System.Web.UI.WebControls.Literal
        Dim listTicketTotalLabel As System.Web.UI.WebControls.Literal
        Dim GrandTotalPayLabel As System.Web.UI.WebControls.Literal
        Dim GrandTotalTickets As System.Web.UI.WebControls.Literal
        
        'check the type of item that was databound and only take action if it 
        'was a row in the datagrid
        Select Case (e.Item.ItemType)
            Case ListItemType.AlternatingItem, ListItemType.EditItem, ListItemType.Item, ListItemType.SelectedItem
                'get the data for the item being bound
                rowData = CType(e.Item.DataItem, Data.DataRowView)
                                
                'get the value for the laboramount and add it to the sum
                price = CDec(rowData.Item("TotalPay"))
                mListTotalPay += price
                
                listLaborLabel = CType(e.Item.FindControl("lblPay"), System.Web.UI.WebControls.Literal)
          
                'now format the list price in currency format
                listLaborLabel.Text = price.ToString("C2")

                'Get the total number of tickets to pay
                total = CInt(rowData.Item("TotalTickets"))
                mListTotalTickets += total
                listTicketTotalLabel = CType(e.Item.FindControl("lblTotalTickets"), System.Web.UI.WebControls.Literal)
                listTicketTotalLabel.Text = total.ToString
                
                
            Case ListItemType.Footer

                'get the control used to display the total of the list prices
                'and set its value to the total of the list prices
                GrandTotalPayLabel = CType(e.Item.FindControl("lblTotalPay"), System.Web.UI.WebControls.Literal)
                GrandTotalPayLabel.Text = mListTotalPay.ToString("C2")
          
                GrandTotalTickets = CType(e.Item.FindControl("lblGrandTotalTickets"), System.Web.UI.WebControls.Literal)
                GrandTotalTickets.Text = mListTotalTickets.ToString
            Case Else
                'ListItemType.Header, ListItemType.Pager, or ListItemType.Separator
                'no action required
                
        End Select
        
    End Sub
    
    Private Sub GetCheckBoxValues_PartnerList()
        'As paging occurs store checkbox values    
        Dim dgItem As DataGridItem
        Dim chkbox As CheckBox
        'Dim chkBxIndex as Integer 
        Dim CheckedItems_PartnerList As ArrayList = New ArrayList
    
        'If Not isnothing (Session("CheckedItems_PartnerList"))then
        'Loop through DataGrid Items    
        For Each dgITem In dgvPartnerList.Items
            'Retrieve key value of each record based on DataGrids        
            ' DataKeyField property        
    
            'ChkBxIndex = dgvPartnerList.DataKeys(1)        
            ChkBox = dgItem.FindControl("chkTechSelected")
            'Add ArrayList to Session if it doesnt exist        
            If Not IsNothing(Session("CheckedItems_PartnerList")) Then
                CheckedItems_PartnerList = Session("CheckedItems_PartnerList")
            End If
            If ChkBox.Checked Then
                  
                'Add to Session if it doesnt already exist            
                If Not CheckedItems_PartnerList.Contains(dgitem.Cells.Item(1).text) Then
                    CheckedItems_PartnerList.Add(dgitem.Cells.Item(1).text)
                End If
            Else
                'Remove value from Session when unchecked            
                CheckedItems_PartnerList.Remove(dgitem.Cells.Item(1).text)
            End If
     
        Next
        'Update Session with the list of checked items    
        Session("CheckedItems_PartnerList") = CheckedItems_PartnerList
        'end if          
    
    End Sub

    Private Sub RePopulateCheckBoxes_PartnerList()

        Dim CheckedItems_PartnerList As ArrayList = New ArrayList
        Dim dgItem As DataGridItem
        'Dim chkBxIndex as Integer 
        Dim chkbox As CheckBox
    
        CheckedItems_PartnerList = Session("CheckedItems_PartnerList")

        If Not IsNothing(CheckedItems_PartnerList) Then

            'Loop through GridView Items                
            For Each dgItem In dgvPartnerList.Items

                'ChkBxIndex = dgvPartnerList.DataKeys(dgitem.Cells.Item(1).text)

                'Repopulate GridView with items found in Session                
                If CheckedItems_Partnerlist.Contains(dgitem.Cells.Item(1).text) Then

                    ChkBox = CType(dgItem.FindControl("chkTechSelected"), CheckBox)
                    ChkBox.Checked = True
        

                End If
            Next
        End If
    End Sub
    
    Private Sub btnSubmitJournalEntry_Click(ByVal S As Object, ByVal E As EventArgs)
        If IsComplete Then
            Dim ptr As New BridgesInterface.PartnerRecord(system.configuration.configurationmanager.appsettings("DBCnn"))
            ptr.Load(CType(Session("SelectedPartner"), Long))
            Dim rnt As New BridgesInterface.JournalEntryRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            Dim pay As New BridgesInterface.PaymentRecord(system.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            Dim lngInvoiceID As Long
   
            If drpInvoiceNumber.selectedValue <> "Choose One" Then
                If txtTicketID.Text <> "" Then
                    If txtWorkOrderID.Text <> "" Then
                        'Submit with InvoiceNumber, TicketID and workorderID
                        rnt.Add(CType(Session("SelectedPartner"), Long), 0, txtAmount.Text, drpInvoiceNumber.SelectedValue, txtTicketID.Text, txtWorkOrderID.Text, txtJournalNotes.Text, Now(), txtDate.Text)
                        'adding journal entry to payment records associated with invoice number
                        lngInvoiceID = getinvoiceIDbyinvoicenumber(drpInvoiceNumber.SelectedValue)
                        If lngInvoiceID <> 0 Then
                            pay.Add(lngInvoiceID, 1, 17, CType(txtAmount.Text, Double), CType(txtDate.Text, Date))
                        End If
                    Else
                        'submit with InvoiceNumber and TicketID
                        rnt.Add(CType(Session("SelectedPartner"), Long), 0, txtAmount.Text, drpInvoiceNumber.SelectedValue, txtTicketID.Text, 0, txtJournalNotes.Text, Now(), txtDate.Text)
                        lngInvoiceID = getinvoiceIDbyinvoicenumber(drpInvoiceNumber.SelectedValue)
                        If lngInvoiceID <> 0 Then
                            pay.Add(lngInvoiceID, 1, 17, CType(txtAmount.Text, Double), CType(txtDate.Text, Date))
                        End If
                    End If
                Else
                    If txtWorkorderID.Text <> "" Then
                        'submit with InvoiceNumber and workoderID
                        rnt.Add(CType(Session("SelectedPartner"), Long), 0, txtAmount.Text, drpInvoiceNumber.SelectedValue, 0, txtWorkOrderID.Text, txtJournalNotes.Text, Now(), txtDate.Text)
                        lngInvoiceID = getinvoiceIDbyinvoicenumber(drpInvoiceNumber.SelectedValue)
                        If lngInvoiceID <> 0 Then
                            pay.Add(lngInvoiceID, 1, 17, CType(txtAmount.Text, Double), CType(txtDate.Text, Date))
                        End If
                    Else
                        'submit with InvoiceNumber
                        rnt.Add(CType(Session("SelectedPartner"), Long), 0, txtAmount.Text, drpInvoiceNumber.SelectedValue, 0, 0, txtJournalNotes.Text, Now(), txtDate.Text)
                        lngInvoiceID = drpInvoiceNumber.SelectedValue
                        If lngInvoiceID <> 0 Then
                            pay.Add(lngInvoiceID, 1, 17, CType(txtAmount.Text, Double), CType(txtDate.Text, Date))
                        End If
                    End If
                End If
            Else
                If txtTicketID.Text <> "" Then
                    If txtWorkOrderID.Text <> "" Then
                        'submit with TicketID and WorkOrderID
                        rnt.Add(CType(Session("SelectedPartner"), Long), 0, txtAmount.Text, 0, txtTicketID.Text, txtWorkOrderID.Text, txtJournalNotes.Text, Now(), txtDate.Text)

                    Else
                        'submit with TicketID only
                        rnt.Add(CType(Session("SelectedPartner"), Long), 0, txtAmount.Text, 0, txtTicketID.Text, 0, txtJournalNotes.Text, Now(), txtDate.Text)

                    End If
                Else
                    'submit WITHOUT InvoiceNumber, TicketID and WorkOrderID
                    rnt.Add(CType(Session("SelectedPartner"), Long), 0, txtAmount.Text, 0, 0, 0, txtJournalNotes.Text, Now(), txtDate.Text)

                End If
            End If
    
            txtJournalNotes.Text = ""
            txtdate.Text = ""
            txtAmount.Text = ""
            drpInvoiceNumber.selectedvalue = "Choose One"
            txtTicketID.Text = ""
            txtWorkOrderID.Text = ""
            LoadJournalEntries()
        End If
  
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
    
    Private Sub btnApplyJournalEntry_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim ldl As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim payr As New BridgesInterface.JournalEntryRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim pay As New BridgesInterface.PaymentRecord(system.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim dgItem As DataGridItem
        Dim chkbox As CheckBox
        Dim intJournalID As Integer
        Dim strChangeLog As String = ""
  
      
        For Each dgItem In dgvJournalEntries.Items
            chkbox = dgItem.FindControl("chkselected")
            If chkbox.Checked Then
                intJournalID = CType(dgItem.Cells.Item(1).Text, Long)
                
                payr.Load(intJournalID)
                payr.InvoiceID = drpInvoiceNumber.SelectedValue
                
                pay.Add(CType(drpInvoiceNumber.SelectedValue, Long), 1, 17, payr.Amount, payr.EndPayPeriod)
                pay.Comments = payr.Notes
                
                payr.save(strChangeLog)
                pay.Save(strChangeLog)
            End If
        Next
        dgvJournalEntries.DataSource = Nothing
        LoadJournalEntries()
    End Sub
    
    Private Sub btnDeleteJournalEntry_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim ldl As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim payr As New BridgesInterface.JournalEntryRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim dgItem As DataGridItem
        Dim chkbox As CheckBox
        Dim intJournalID As Integer
        
        For Each dgItem In dgvJournalEntries.Items
            chkbox = dgItem.FindControl("chkselected")
            If chkbox.Checked Then
                intJournalID = CType(dgItem.Cells.Item(1).Text, Long)
                
                payr.Load(intJournalID)
                
                payr.Delete()
                
            End If
        Next
        dgvJournalEntries.DataSource = Nothing
        
        'ldl.LoadStringDateParameterDataGrid("spGetPaidInvoices", "@CheckNumber", CType(txtCheckNumber.Text, String), "@DateCreated", datDate2, dgvTickets)
        LoadJournalEntries()
    End Sub
    
    Private Function IsComplete() As Boolean
        Dim bolReturn As Boolean
        bolReturn = False
        If txtDate.Text <> "" Then
            If IsDate(txtDate.Text) Then
                bolReturn = True
            Else
        
            End If
        Else
        End If
        If txtAmount.Text <> "" Then
            bolReturn = True
        Else
    
        End If
        If txtJournalNotes.Text <> "" Then
            bolReturn = True
        Else
      
        End If
    
        IsComplete = bolReturn
      
    End Function
    Private Sub LoadInvoiceNumbers()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        ldr.LoadSingleLongParameterDropDownList("spGetUnpaidInvoicesForPartner", "@PartnerID", CType(Session("SelectedPartner"), Long), "InvoiceNumber", "InvoiceID", drpInvoiceNumber)
        drpInvoiceNumber.Items.Add("Choose One")
        drpInvoiceNumber.SelectedValue = "Choose One"
    End Sub
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmTickets" runat="server" >
    <table style="width: 100%">
      <tbody>
        <tr>
          <td class="band" style="width: 1%">
            <div class="bandheader">End Pay Period</div>
            <asp:Calendar ID="Calendar1" runat="server" BackColor="White" BorderColor="#999999" CellPadding="4" DayNameFormat="Shortest" Font-Names="Verdana" Font-Size="8pt" ForeColor="Black" Height="180px" Width="180px" OnSelectionChanged="Calendar1_SelectionChanged">
                <SelectedDayStyle BackColor="#666666" Font-Bold="True" ForeColor="White" />
                <SelectorStyle BackColor="#CCCCCC" />
                <WeekendDayStyle BackColor="#FFFFCC" />
                <TodayDayStyle BackColor="#CCCCCC" ForeColor="Black" />
                <OtherMonthDayStyle ForeColor="#808080" />
                <NextPrevStyle VerticalAlign="Bottom" />
                <DayHeaderStyle BackColor="#CCCCCC" Font-Bold="True" Font-Size="7pt" />
                <TitleStyle BackColor="#999999" BorderColor="Black" Font-Bold="True" />
            </asp:Calendar>
             <div class="inputformsectionheader">Create Invoice</div>
            <div class="inputform">
              <div class="errorzone" id="divJumpToError" runat="server" visible="false" />
              <div class="label">Total Invoice Amount</div>
              <div><asp:TextBox ID="InvoiceNumber" runat="server" /><asp:TextBox ID="svdInvoiceID" runat="server" Visible = "false" /></div>
              <div style="text-align: right;"><a target="_blank" href="OldInvoicesReport.aspx?id=<%# Databinder.Eval(container,"svdInvoiceID")%>">Print Report <img style="border: 0" alt="Printable Version" src="/graphics/printable.png" /></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="btnJump" runat="server" Text="Submit" OnClick="btnJump_Click" /></div>
            </div>
            <div>&nbsp;</div>
            <div class="bandheader">Vendors <asp:Label ID="lblTotalVendors" runat="server"></asp:Label></div>
            <asp:DropDownList ID="drpPartners" runat="server" AutoPostBack="true" OnSelectedIndexChanged="drpPartners_SelectedIndexChanged" Visible="false" />
            <div class="bandheader" visible = "False"></div>
            <span style="white-space:nowrap">
            </span>
            <div class="bandheader" ></div>
             <asp:DataGrid AllowSorting="true" ID="dgvPartnerList" AutoGenerateColumns="false" runat="server" style="background-color: White; width: 100%" OnSortCommand="dgvTickets_SortCommand" ShowFooter = "True" CssClass="Grid1" ><FooterStyle cssClass="gridheader" HorizontalAlign="Right" BackColor="#C0C0C0" />
                <AlternatingItemStyle CssClass="altrow" />
                <HeaderStyle CssClass="gridheader" />
                <Columns>
                    <asp:TemplateColumn>
                  <ItemTemplate>
                    <asp:CheckBox ID="chkTechSelected" runat="server"  AutoPostBack ="True" OnCheckedChanged="chkTechSelected_CheckedChanged" />
                  </ItemTemplate>
                </asp:TemplateColumn>
                    <asp:BoundColumn DataField="PartnerID"  Visible="false" />
                    <asp:BoundColumn DataField="ResumeID" HeaderText="ID"  />
                    <asp:TemplateColumn HeaderText="Amount" ItemStyle-HorizontalAlign="Right">
                    <ItemTemplate>
                        <asp:Literal id="lblPay" runat="server"  text='<%#DataBinder.Eval(Container.DataItem, "TotalPay")%>' />
                    </ItemTemplate>
                    <FooterTemplate  >
                    <asp:Literal id="lblTotalPay" runat="server" />
                  </FooterTemplate>
                   </asp:TemplateColumn>
                     <asp:TemplateColumn HeaderText="Amount" ItemStyle-HorizontalAlign="Right" Visible="false">
                    <ItemTemplate>
                        <asp:Literal id="lblTotalTickets" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "TotalTickets")%>' />
                    </ItemTemplate>
                    <FooterTemplate>
                        <asp:Literal ID="lblGrandTotalTickets" runat="server" />
                    </FooterTemplate>
                      </asp:TemplateColumn>  
                </Columns> 
            </asp:DataGrid>
          </td>
          <td ></td>
          <td>
          <div id="tab5">
          <asp:Menu ID="menu5" runat="server" Orientation="Horizontal" OnMenuItemClick ="menu5_MenuItemClick" CssClass="ul">
             <StaticMenuItemStyle CssClass="li" />
             <StaticHoverStyle CssClass="hoverstyle" />
             <StaticSelectedStyle CssClass="current" />
             <Items>
                <asp:MenuItem  value ="0" Text="Pay Tickets"></asp:MenuItem>
                <asp:MenuItem value ="1" Text="Journal Entries"></asp:MenuItem> 
                <asp:MenuItem value = "2" Text="Billing Notes"></asp:MenuItem>
                <asp:MenuItem value = "3" Text="Old Invoices"></asp:MenuItem>
                <asp:MenuItem value = "4" Text="Charge for Parts"></asp:MenuItem>
             </Items>
           </asp:Menu>
          </div>
          <div id="ratesheader" class="tabbody">
          <div>&nbsp;</div></div>
          <asp:MultiView ID="Multiview1" runat="server" ActiveViewIndex="0" >
          <asp:View ID="viewTickets"  runat="server">
            <div class="inputformsectionheader">
                Tickets List<asp:Label ID="lblTicketCount" runat="server"></asp:Label>
            </div>
            <div class="inputform">
              <asp:DataGrid AllowSorting="true" ID="dgvTickets" AutoGenerateColumns="false" runat="server" style="background-color: White; width: 100%" OnSortCommand="dgvTickets_SortCommand" ShowFooter = "True" CssClass="Grid1" ><FooterStyle cssClass="gridheader" HorizontalAlign="Right" BackColor="#C0C0C0" />
                <AlternatingItemStyle CssClass="altrow" />
                <HeaderStyle CssClass="gridheader" />
                <Columns>
                  <asp:TemplateColumn>
                  <ItemTemplate>
                    <asp:CheckBox ID="chkSelected" runat="server"  AutoPostBack ="True" OnCheckedChanged="chkSelected_CheckedChanged" />
                  </ItemTemplate>
                </asp:TemplateColumn>
                  <asp:BoundColumn DataField="TicketID" HeaderText="ID" Visible="false" />
                  <asp:TemplateColumn SortExpression="TicketID" HeaderText="Ticket&nbsp;ID">
                    <ItemTemplate>
                     <a target="_blank" href="ticket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>"><%# DataBinder.Eval(Container.DataItem,"TicketID") %></a><a target="_blank" href="printableticket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>"><img style="border: 0" alt="Printable Version" src="/graphics/printable.png" /></a>
                    </ItemTemplate>
                  </asp:TemplateColumn>
                  <asp:BoundColumn DataField="WorkOrderID" HeaderText="WOID" Visible="false" />
                  <asp:TemplateColumn SortExpression="WorkOrderID" HeaderText="PO">
                    <ItemTemplate>
                       <asp:Literal id="lblWorkOrderID" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "WorkOrderID") %>' />
                    </ItemTemplate>
                  </asp:TemplateColumn>
                   <asp:BoundColumn DataField="ParentID" HeaderText="ParentID" Visible="false" />
                  <asp:TemplateColumn SortExpression="Status" HeaderText="Status">
                    <ItemTemplate>
                        <asp:Literal id="lblStatus" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Status") %>' />
                    </ItemTemplate>
                  </asp:TemplateColumn>
                  <asp:TemplateColumn SortExpression="TicketStatus" HeaderText="TicketStatus">
                    <ItemTemplate>
                        <asp:Literal id="lblTicketStatus" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "TicketStatus") %>' />
                    </ItemTemplate>
                  </asp:TemplateColumn>
                  <asp:TemplateColumn SortExpression="Company" HeaderText="Company">
                    <ItemTemplate>
                         <asp:Literal id="lblCompany" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "Company")%>' />
                    </ItemTemplate>
                  </asp:TemplateColumn>
                   <asp:TemplateColumn SortExpression="ScheduledEndDate" HeaderText="Scheduled">
                    <ItemTemplate>
                         <asp:Literal id="lblScheduledEndDate" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "ScheduledEndDate")%>' />
                    </ItemTemplate>
                  </asp:TemplateColumn>
                  <asp:TemplateColumn SortExpression="CloseDate" HeaderText="CloseDate">
                    <ItemTemplate>
                         <asp:Literal id="lblCloseDate" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "CloseDate")%>' />
                    </ItemTemplate>
                  </asp:TemplateColumn>
                  <asp:TemplateColumn SortExpression="Servicename" HeaderText="Service" Footertext="Grand Total:">
                    <ItemTemplate>
                        <asp:Literal id="lblServiceType" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "Servicename")%>' />
                    </ItemTemplate>
                  </asp:TemplateColumn>
                  <asp:TemplateColumn SortExpression="LaborAmount" HeaderText="Labor" ItemStyle-HorizontalAlign="Right">
                    <ItemTemplate>
                        <asp:Literal id="lblLaborAmount" runat="server"  text='<%#DataBinder.Eval(Container.DataItem, "LaborAmount")%>' />
                    </ItemTemplate>
                    <FooterTemplate  >
                    <asp:Literal id="lblTotalLaborAmount" runat="server" />
                  </FooterTemplate>
                  </asp:TemplateColumn>
                  <asp:TemplateColumn SortExpression="AdjustPay" HeaderText="Extra" ItemStyle-HorizontalAlign="Right">
                    <ItemTemplate>
                        <asp:Literal id="lblAdjustCharge" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "AdjustPay")%>' />
                    </ItemTemplate>
                    <FooterTemplate >
                    <asp:Literal id="lblTotalAdjustCharge" runat="server" />
                  </FooterTemplate>
                  </asp:TemplateColumn>
                  <asp:TemplateColumn SortExpression="PartAmount" HeaderText="Part" ItemStyle-HorizontalAlign="Right">
                    <ItemTemplate>
                        <asp:Literal id="lblPartAmount" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "PartAmount")%>' />
                    </ItemTemplate>
                    <FooterTemplate >
                    <asp:Literal id="lblTotalPartAmount" runat="server" />
                  </FooterTemplate>
                  </asp:TemplateColumn>
                  <asp:BoundColumn DataField="Total" HeaderText="Total" Visible="false" />
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
            </div>
           </asp:View>
           <asp:View ID="viewJournalEntries"  runat="server">
           <div >    
           <div >&nbsp;</div>
            <div >Date:<asp:textbox ID="txtDate" runat="server" Width="15%"/>&nbsp;Amount:<asp:textbox ID="txtAmount" runat="server" Width="15%"/>&nbsp;&nbsp;TicketID<asp:textbox ID="txtTicketID" runat="server" Width="15%"/>&nbsp;WorkOrderID:<asp:textbox ID="txtWorkOrderID" runat="server" Width="15%" /></div>
             <div >&nbsp;</div>
             <div style="text-align: right;"><asp:textbox ID="txtJournalNotes" runat="server" style="width: 100%; height: 100px;" TextMode="multiLine" /><asp:Button ID="btnSubmitJournalEntry" OnClick="btnSubmitJournalEntry_Click" runat="server" Text="Submit"  /></div>
             <div style="text-align: left;"><asp:Button ID="btnDelete" OnClick="btnDeleteJournalEntry_Click" runat="server" Text="Delete Journal Entry"  />&nbsp;&nbsp;&nbsp;&nbsp;&nbspInvoiceNumber:<asp:dropdownlist ID="drpInvoiceNumber" runat="server" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="btnApply" OnClick="btnApplyJournalEntry_Click" runat="server" Text="Apply Journal Entry to Invoice"  /></div>
             <div >&nbsp;</div>
           </div>
           <asp:DataGrid ID="dgvJournalEntries" AutoGenerateColumns="false" runat="server" style="background-color: White; width: 100%"  ShowFooter = "True" CssClass="Grid1" ><FooterStyle cssClass="gridheader" HorizontalAlign="Right" BackColor="#C0C0C0" />
             <AlternatingItemStyle CssClass="altrow" />
             <HeaderStyle CssClass="gridheader" />
             <Columns>
             <asp:TemplateColumn>
                  <ItemTemplate>
                    <asp:CheckBox ID="chkSelected" runat="server" />
                  </ItemTemplate>
             </asp:TemplateColumn>
             <asp:BoundColumn DataField="JournalEntryID" HeaderText="ID" Visible="false" />
             <asp:BoundColumn DataField="Amount" HeaderText="Amount" />
             <asp:BoundColumn DataField="Notes" HeaderText="Notes"  />
             <asp:BoundColumn DataField="EndPayPeriod" HeaderText="End Date"  />
             </Columns>
             </asp:DataGrid> 
           </asp:View> 
            <asp:View ID="viewBilingNotes"  runat="server">
             <div id="divNoteError1" visible="false" runat="server" class="errorzone" />            
                <div class="inputformsectionheader">Add Billing Note</div>
                <div class="inputform">
                <div style="padding-right: 3px"><asp:textbox ID="txtBillingNote" runat="server" style="width: 100%; height: 100px;" TextMode="multiLine" /></div>
                <div style="text-align: right;"><asp:Button ID="btnBillingNote" OnClick="btnAddBillingNote_Click" runat="server" Text="Add Note" /></div>
              </div>
              <div class="inputformsectionheader">Notes</div>
              <asp:DataGrid ID="dgvBillingNotes" runat="server" ShowHeader="false" AutoGenerateColumns="false" style="width: 100%" CssClass="Grid1">
                <AlternatingItemStyle CssClass="altrow" />   
                <Columns>
                  <asp:TemplateColumn ItemStyle-Width="1%" ItemStyle-VerticalAlign="top" >
                    <ItemTemplate>
                      <div style="white-space:nowrap;"><%# Databinder.eval(Container.DataItem, "DateCreated") %></div>
                      <div><a href="mailto:<%# Databinder.eval(Container.DataItem, "Email") %>"><%# Databinder.eval(Container.DataItem, "UserName") %></a></div>
                    </ItemTemplate>
                  </asp:TemplateColumn>
                  <asp:TemplateColumn ItemStyle-Wrap="true">
                    <Itemtemplate>
                    <%# Databinder.eval(Container.DataItem, "NoteBody").ToString.Replace(environment.NewLine,"<br />") %>
                    </Itemtemplate>
                  </asp:TemplateColumn>
                </Columns>
              </asp:DataGrid>
           </asp:View>
            <asp:View ID="viewOldInvoices"  runat="server">
            <div visible="True" id="divOldInvoices" class="inputformsectionheader" runat="server">Old Invoices</div>
            <asp:DataGrid Visible="True" ID="dgvOldInvoices" style="width: 100%" runat="server" AutoGenerateColumns="false" CssClass="Grid1">
              <HeaderStyle CssClass="gridheader" />
              <AlternatingItemStyle CssClass="altrow" />   
              <Columns>
                <asp:BoundColumn DataField="InvoiceID" HeaderText="ID" visible="False" />
                <asp:TemplateColumn HeaderText ="InvoiceNumber" > 
                  <ItemTemplate>
                    <a href="OldInvoices.aspx?id=<%# Databinder.eval(Container.DataItem,"InvoiceID") %>" target="_blank"> <%# Databinder.eval(Container.DataItem,"InvoiceNumber") %></a><a target="_blank" href="VendorInvoiceReport.aspx?id=<%# Databinder.eval(Container.DataItem,"InvoiceID") %>"><img style="border: 0" alt="Printable Version" src="/graphics/printable.png" />
                  </ItemTemplate>
                </asp:TemplateColumn>           
                 <asp:BoundColumn DataField="InvoiceDate" HeaderText="InvoiceDate" DataFormatString="{0:d}"/>
                  <asp:BoundColumn DataField="Total" HeaderText="Total" DataFormatString="{0:C}" />
                <asp:TemplateColumn HeaderText ="Journal Entries" > 
                  <ItemTemplate>
                     <asp:DataGrid Visible="True" ID="dgvJournal" style="width: 100%" runat="server" AutoGenerateColumns="false" CssClass ="Grid1">
                        <HeaderStyle CssClass="gridheader" />
                          <AlternatingItemStyle CssClass="altrow" />   
                            <Columns>
                               <asp:BoundColumn DataField="InvoiceID" HeaderText="ID" visible="False" />
                               <asp:BoundColumn DataField="Comments" HeaderText="Notes" />            
                               <asp:BoundColumn DataField="Amount" HeaderText="Amount" DataFormatString="{0:C}" />
                            </Columns>                
                     </asp:DataGrid>   
                  </ItemTemplate>
                </asp:TemplateColumn>    
                <asp:TemplateColumn HeaderText ="Payment Records">
                  <ItemTemplate>
                     <asp:DataGrid Visible="True" ID="dgvPayments" style="width: 100%" runat="server" AutoGenerateColumns="false" CssClass ="Grid1">
                        <HeaderStyle CssClass="gridheader" />
                          <AlternatingItemStyle CssClass="altrow" />   
                            <Columns>
                               <asp:BoundColumn DataField="InvoiceID" HeaderText="ID" visible="False" />
                               <asp:BoundColumn DataField="checkNumber" HeaderText="CheckNumber" />            
                               <asp:BoundColumn DataField="Amount" HeaderText="CheckAmount" DataFormatString="{0:C}" />
                               <asp:BoundColumn DataField="PayDate" HeaderText="PayDate" DataFormatString="{0:d}"/>
                            </Columns>                
                     </asp:DataGrid>    
                  </ItemTemplate>
                </asp:TemplateColumn>
                            
              </Columns>                
            </asp:DataGrid>  
           </asp:View>
            <asp:View ID="NeedReturnParts"  runat="server">
            <div class="inputformsectionheader"><asp:ImageButton ID="btnExport" AlternateText ="Export to Excel" ImageUrl ="/images/Excel-16.gif"  ImageAlign="right"  OnClick="btnExport_Click" runat="server"/></div> 
            <div class="inputformsectionheader">&nbsp;</div>
            <div class="inputformsectionheader"><asp:Label ID="lblTicketCount1" runat="server"></asp:Label> List of Parts Not Returned</div>
            <asp:DataGrid ID="dgvChargeParts" runat="server" style="width: 100%; background-color:White;" AutoGenerateColumns="false" ShowFooter = "True" Cssclass="Grid1" ><FooterStyle cssClass="gridheader" HorizontalAlign="Right" BackColor="#C0C0C0" />
              <HeaderStyle CssClass="gridheader" />
               <AlternatingItemStyle CssClass="altrow" />
                 <Columns>
                 <asp:TemplateColumn>
                  <ItemTemplate>
                    <asp:CheckBox ID="chkSelected1" runat="server"  AutoPostBack ="True" OnCheckedChanged="chkSelected1_CheckedChanged" />
                  </ItemTemplate>
                   </asp:TemplateColumn>
                   <asp:BoundColumn HeaderText="TicketComponentID" DataField="TicketComponentID" Visible="false"  />
                   <asp:BoundColumn HeaderText="TicketID" DataField="TicketID" Visible="false"  />
                   <asp:TemplateColumn HeaderText="Ticket ID">
                     <ItemTemplate>
                        <a target="_blank" href="ticket.aspx?id=<%# Databinder.Eval(Container.DataItem,"TicketID") %>&returnurl=workoders.aspx&act=G"><%# Databinder.Eval(Container.DataItem,"TicketID") %></a>
                     </ItemTemplate>
                   </asp:TemplateColumn>
                  <asp:BoundColumn HeaderText="Age" DataField="Age" />
                  <asp:BoundColumn HeaderText="Customer" DataField="Company" />
                  <asp:BoundColumn HeaderText="TypeOfService" DataField="ServiceName" />
                  <asp:BoundColumn HeaderText="Status" DataField="Status" />
                  <asp:BoundColumn HeaderText="PartNumber" DataField="Code" />
                  <asp:BoundColumn HeaderText="ChargeCore" DataField="ChargeTechCoreAmount" />
                  <asp:BoundColumn HeaderText="ChargeRA" DataField="BillTaxes" />
                  <asp:TemplateColumn SortExpression="CoreCharge" HeaderText="Core Charge" ItemStyle-HorizontalAlign="Right">
                    <ItemTemplate>
                        <asp:Literal id="lblCoreCharge" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "CoreCharge")%>' />
                    </ItemTemplate>
                    <FooterTemplate >
                    <asp:Literal id="lblTotalCoreCharge" runat="server" />
                  </FooterTemplate>
                  </asp:TemplateColumn>
                  <asp:TemplateColumn SortExpression="PartCost" HeaderText="Part Cost" ItemStyle-HorizontalAlign="Right">
                    <ItemTemplate>
                        <asp:Literal id="lblPartCost" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "PartCost")%>' />
                    </ItemTemplate>
                    <FooterTemplate >
                    <asp:Literal id="lblTotalPartCost" runat="server" />
                  </FooterTemplate>
                  </asp:TemplateColumn>
                  <asp:TemplateColumn SortExpression="TotalCharge" HeaderText="Total" ItemStyle-HorizontalAlign="Right">
                    <ItemTemplate>
                        <asp:Literal id="lblTotalCharge" runat="server" text='TotalCharge' />
                    </ItemTemplate>
                    <FooterTemplate >
                    <asp:Literal id="lblGrandTotalCharge" runat="server" />
                  </FooterTemplate>
                  </asp:TemplateColumn>
                  <asp:BoundColumn HeaderText="ReturnType" DataField="Destination" />
                  <asp:TemplateColumn HeaderText="TrackingNumber">
                          <ItemTemplate>
                            <a target="_blank" href="<%# Databinder.eval(Container.DataItem,"TrackingScript").ToString.Replace("$shippinglabel",DataBinder.Eval(Container.DataItem,"ShippingLabel")) %>"><%# DataBinder.Eval(Container.DataItem,"ShippingLabel") %></a>                    
                          </ItemTemplate>
                  
                  <FooterTemplate >
                    <asp:Literal id="lblTotalSelected" runat="server" />
                  </FooterTemplate>
                  </asp:TemplateColumn>
               </Columns>      
            </asp:DataGrid>
           </asp:View>
            </asp:MultiView>
          </td>
        </tr>
      </tbody>
    </table>
  </form>
  <asp:Label ID="lblSortOrder" runat="server" Visible="false" />
</asp:Content>