<%@ Page Language="vb" masterpagefile="~/masters/agent.master" MaintainScrollPositionOnPostback = "True" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">

  Private _ID As Long = 1
  Private lngCustID as long = 1
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
        
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
        lblTicketCount.Text = ""
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
            Master.PageHeaderText = "Vendor Payment Information " 
            Master.PageTitleText = "Vendor Payment Information " 
            Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; Invoice Payments"
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
        mListExtraTotal = 0
        mListPartTotal = 0
        mListTotal = 0
    'LoadFolders()
        
      
        
    if lngCustID = 0 then    
            
            If (Not Page.IsPostBack) Then
                Session.Clear()
                
                If _ID = CLng(1) Then
                   
                    If IsNothing(Session("SortOrder")) Then
                        'LoadTickets(_ID, "TicketID ASC")
                    Else
                        'LoadTickets(_ID, Session("SortOrder"))
                    End If
                Else
                    If Request.QueryString("ID") <> "" Then
                        'LoadTicketsByInvoiceID(_ID, lngCustID)
                        'LoadPriorInvoices()
                        'LoadPartnerLookUp()
                        LoadTicketsByOldInvoiceID(_ID)
                    End If
                End If
            Else
                'GetCheckBoxValues()
                'LoadTickets(_ID, Session("SortOrder"))
                'RePopulateCheckBoxes()
            End If
        Else
            If (Not Page.IsPostBack) Then
                Session.Clear()
                
                LoadTicketsByOldInvoiceID(_ID)
            End If
        End If
  End Sub
        
   
    Private Sub LoadTicketsByInvoiceID(ByVal lngInvoiceID As Long, ByVal lngCustomerID As Long)
       
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        'LoadPriorInvoices()
        'LoadPartnerLookUp()
        'drpPartners.SelectedValue = "Choose One"
        'drpCustomers.SelectedValue = lngCustomerID
        ldr.LoadSingleLongParameterDataGrid("spBillingVerificationByInvoiceID", "@InvoiceID", lngInvoiceID, dgvTickets)
        
        'ldr.LoadTwoLongParameterDataGrid("spListTicketsInFolderByCustomer", "@TicketFolderID", _ID, "@CustomerID", CType(drpCustomers.SelectedValue, Long), dgvTickets)
        lblTicketCount.Text = " ( " & CType(dgvTickets.DataSource, Data.DataSet).Tables(0).Rows.Count & " ) "
       
    End Sub
    
    Private Sub LoadTicketsByOldInvoiceID(ByVal lngInvoiceID As Long)
        Dim inv As New BridgesInterface.InvoiceRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim ldl As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        inv.Load(lngInvoiceID)
        
        If inv.IsVendorPartInvoice = False Then
            Multiview1.ActiveViewIndex = 0
            ldl.LoadSingleLongParameterDataGrid("spGetListPartnerTicketsByInvoiceID", "@InvoiceID", lngInvoiceID, dgvTickets)
            lblTicketCount.Text = " ( " & CType(dgvTickets.DataSource, Data.DataSet).Tables(0).Rows.Count & " ) "
            Master.PageHeaderText = "Vendor Invoice - " & GetInvoiceNumber(lngInvoiceID)
        Else
            Multiview1.ActiveViewIndex = 1
            Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            ldr.LoadSingleLongParameterDataGrid("spListPartsChargeByInvoiceID", "@InvoiceID", lngInvoiceID, dgvChargeParts)
            'ldr.LoadSingleLongParameterDataGrid("spListRequireSignatureDispatchedPartnerWorkOrders", "@PartnerID", Master.PartnerID, Me.dgvRequireUpload)
        
            lblTicketCount1.Text = " [ " & CType(dgvChargeParts.DataSource, Data.DataSet).Tables(0).Rows.Count & " ] "

        End If
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
     
    ldr.LoadSimpleDataGrid("spBillingVerification", dgvTickets,   True,  e,  e.SortExpression, lblSortOrder.Text)
    lblTicketCount.Text = " ( " & CType(dgvTickets.DataSource, Data.DataView).Count & " ) "
    
   
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

    Function GetInvoiceNumber(ByVal lngInvoiceID As Integer) As String
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetInvoice")
        Dim strInvoiceNumber As String
        
        strInvoiceNumber = "0"

        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@InvoiceID", Data.SqlDbType.Int).Value = lngInvoiceID
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            strInvoiceNumber = dtr("InvoiceNumber").ToString 
        End While
        cnn.Close()
        GetInvoiceNumber = strInvoiceNumber
        
    End Function

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
                    
                                       
                    'If (price > 0) And (strStatus = "Closed - Resolved") And lblPartCostLabel.Text = 0 Then
                    'e.Item.ForeColor = Drawing.Color.DarkGreen
                    'End If
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
    
    
    
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmTickets" runat="server" >
    <table style="width: 100%">
      <tbody>
        <tr>
          <td style="width: 3px;">&nbsp;</td>
          <td>
            <div class="inputformsectionheader">Tickets List<asp:Label ID="lblTicketCount" runat="server"></asp:Label>
            </div>
            <div class="inputform">
            <asp:MultiView ID="Multiview1" runat="server" ActiveViewIndex="0" >
            <asp:View ID="LaborInvoice"  runat="server">
              <asp:DataGrid AllowSorting="true" ID="dgvTickets" AutoGenerateColumns="false" runat="server" style="background-color: White; width: 100%" OnSortCommand="dgvTickets_SortCommand" ShowFooter = "True"  ><FooterStyle cssClass="gridheader" HorizontalAlign="Right" 
             BackColor="#C0C0C0" />
                <AlternatingItemStyle CssClass="altrow" />
                <HeaderStyle CssClass="gridheader" />
                <Columns>
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
               </asp:View>
              <asp:View ID="PartsInvoice"  runat="server">
            <div class="inputformsectionheader">&nbsp;</div>
            <div class="inputformsectionheader"><asp:Label ID="lblTicketCount1" runat="server"></asp:Label> Parts Charge Invoice</div>
            <asp:DataGrid ID="dgvChargeParts" runat="server" style="width: 100%; background-color:White;" AutoGenerateColumns="false" ShowFooter = "True"  ><FooterStyle cssClass="gridheader" HorizontalAlign="Right" BackColor="#C0C0C0" />
              <HeaderStyle CssClass="gridheader" />
               <AlternatingItemStyle CssClass="altrow" />
                 <Columns>
                 <asp:TemplateColumn Visible = "false" >
                  <ItemTemplate>
                    <asp:CheckBox ID="chkSelected1" runat="server"  AutoPostBack ="True"  />
                  </ItemTemplate>
                   </asp:TemplateColumn>
                   <asp:BoundColumn HeaderText="TicketComponentID" DataField="TicketComponentID" Visible="false"  />
                   <asp:TemplateColumn HeaderText="Ticket ID">
                     <ItemTemplate>
                        <a target="_blank" href="ticket.aspx?id=<%# Databinder.Eval(Container.DataItem,"TicketID") %>&returnurl=workoders.aspx&act=G"><%# Databinder.Eval(Container.DataItem,"TicketID") %></a>
                     </ItemTemplate>
                   </asp:TemplateColumn>
                  <asp:BoundColumn HeaderText="Age" DataField="Age" />
                  <asp:BoundColumn HeaderText="Customer" DataField="Company" Visible = "false" />
                  <asp:BoundColumn HeaderText="TypeOfService" DataField="ServiceName" Visible = "false" />
                  <asp:BoundColumn HeaderText="PartNumber" DataField="Code" />
                  <asp:BoundColumn HeaderText="Description" DataField="Component"  />
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
            </div>
          </td>
        </tr>
      </tbody>
    </table>
  </form>
  <asp:Label ID="lblSortOrder" runat="server" Visible="false" />
</asp:Content>