<%@ Page Language="vb" masterpagefile="~/masters/partner.master" %>
<%@ MasterType VirtualPath="~/masters/partner.master" %>
<script runat="server">
 
  Private _ID As Long = 1
  Private lngCustID as long = 1
  Private lngIt as long 
    Private mListLaborTotal As Double
    Private mListExtraTotal As Double
    Private mListPartTotal As Double
    Private mListTotal As Double 
    Private mFocus as Integer 
    Private mCheckedTotal as Double


  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Invoices"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Invoices"
     
      Master.ActiveMenu = "K"
    End If
    
    GetpayPeriod
    
  End Sub
  
  Private Sub GetPayPeriod()
    Dim dtLastMonthFirstDay as date
    Dim dtLastMonthLastDay as date
    Dim intLastMonth as integer
    Dim dtStartdate as Date
    Dim dtEndDate as Date
    dim intDay as Integer 
    dim intlastday as Integer 
    Dim strPayPeriod as String

   dtLastMonthLastDay = datetime.Today.AddDays(0 - datetime.Today.Day)
   dtLastMonthFirstDay = dtLastMonthLastDay.AddDays (1 - dtLastMonthLastDay.Day)
   intLastMonth = (datetime.Today.Month - 1)
   
   dtStartDate = dtLastMonthFirstDay.Date 
   dtEndDate = dtLastMonthLastDay.Date
   intday = datetime.Today.Day
   intlastDay = Day(DateSerial(Year(Now()),Month(Now())+1,0))
   
   if intday <= 15 then
     strPayperiod = "From " & dtStartDate & " to " & dtEndDate & "<br/>"
     strPayperiod = strPayperiod & "(If any discrepancies, please send an email to <a href='mailto:PaymentReview@bestservicers.com'>Payment Review</a> with explanation for correction)"
     payperiod.Text = strPayperiod
   else
     strPayPeriod = " " & datetime.Today.AddDays (1 - datetime.Today.Day) & " and " & Month(Now()) & "/" & intLastDay & "/" & year(now()) & " - Payment will be received on: " & (Month(Now()) + 1) & "/20/" & Year(Now()) & "<br/>"
     strPayperiod = strPayperiod & "(If any discrepancies, please send an email to <a href='mailto:PaymentReview@bestservicers.com' >Payment Review</a> with explanation for correction)"
     payperiod.Text = strPayperiod
   
   end if 
        lastDay.Text = FormatDateTime((Month(Now()) & "/" & intlastday & "/" & Year(Now())) & " 23:59:59", DateFormat.GeneralDate)
   
        LoadTicketsByPartners(Master.PartnerID, dtEndDate & " 23:59:59")
  
  end sub
  
  Private Sub LoadTicketsByPartners(ByVal lngPartnerID As Long, ByVal datDate As DateTime)
       
        Dim ldl As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
       
        ldl.LoadLongDateParameterDataGrid("spGetListTicketsTopayBYPartnerID", "@PartnerID", lngPartnerID, "@Date", datDate, dgvTickets)
        lblTicketCount.Text = " ( " & CType(dgvTickets.DataSource, Data.Dataset).Tables(0).Rows.Count & " ) "
       
    
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
    
    Protected Sub dgvTickets_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs)
        Dim ldl As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    If lblSortOrder.Text.ToLower = " asc" Then
      lblSortOrder.Text = " desc"
    Else
      lblSortOrder.Text = " asc"
    End If
   
            ldl.LoadLongDateParameterDataGrid("spGetListTicketsTopayBYPartnerID", "@PartnerID", master.PartnerID , "@Date", lastday.text, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
        'lblTicketCount.Text = " ( " & CType(dgvTickets.DataSource, Data.Dataset).Tables(0).Rows.Count & " ) "

    'ldr.LoadTwoLongParameterDataGrid("spListTicketsInFolderByPartner", "@TicketFolderID", _ID, "@PartnerID", master.PartnerID , dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
           
   End sub
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
 <div style=" text-align:center;"><asp:label ID="lastDay" runat="server" visible="false"></asp:label>Current Pay Period - All service calls completed  <asp:Label ID="payperiod" runat="server"></asp:Label></div>
 <form id="frmTickets" runat="server" >
    <table style="width: 100%">
      <tbody>
        <tr>
          <td>
            <div class="inputformsectionheader">
                Tickets List<asp:Label ID="lblTicketCount" runat="server"></asp:Label>
            </div>
            <div class="inputform">
              <asp:DataGrid AllowSorting="true" ID="dgvTickets" AutoGenerateColumns="false" runat="server" style="background-color: White; width: 100%" OnSortCommand="dgvTickets_SortCommand" ShowFooter = "True"  ><FooterStyle cssClass="gridheader" HorizontalAlign="Right" 
             BackColor="#C0C0C0" />
                <AlternatingItemStyle CssClass="altrow" />
                <HeaderStyle CssClass="gridheader" />
                <Columns>
                  <asp:BoundColumn DataField="TicketID" HeaderText="ID" Visible="false" />
                  <asp:TemplateColumn SortExpression="TicketID" HeaderText="Ticket&nbsp;ID">
                    <ItemTemplate>
                     <a href="ticket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>&act=K"><%# DataBinder.Eval(Container.DataItem,"TicketID") %></a><a target="_blank" href="printableticket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>"></a>
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
                  <asp:TemplateColumn SortExpression="PartAmount" HeaderText="Part" ItemStyle-HorizontalAlign="Right" >
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
          </td>
        </tr>
      </tbody>
    </table>
  </form>
  <asp:Label ID="lblSortOrder" runat="server" Visible="false" />
</asp:Content>