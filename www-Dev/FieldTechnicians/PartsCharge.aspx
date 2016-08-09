<%@ Page Language="vb" masterpagefile="~/masters/FieldTechnicians.master" %>
<%@ MasterType VirtualPath="~/masters/FieldTechnicians.master" %>
<script runat="server">
 
  Private _ID As Long = 1
  Private lngCustID as long = 1
  Private lngIt as long 
    Private mFocus As Integer
    Private mCheckedTotal As Double
    Private mListCoreChargeTotal As Double
    Private mListPartCostTotal As Double
    Private mListTotalPartsCharge As Double
    Private mTotalSelected As Double


  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
            Master.PageHeaderText = " Parts Charge"
            Master.PageTitleText = " Parts Charge"
     
            Master.ActiveMenu = "L"
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
            'strPayperiod = "From " & dtStartDate & " to " & dtEndDate & "<br/>"
            strPayPeriod = "<br/>" & "(If any discrepancies, please send an email to <a href='mailto:PaymentReview@bestservicers.com'>Payment Review</a> with explanation for correction)"
            payperiod.Text = strPayPeriod
   else
            'strPayPeriod = " " & datetime.Today.AddDays (1 - datetime.Today.Day) & " and " & Month(Now()) & "/" & intLastDay & "/" & year(now()) & " - Payment will be received on: " & (Month(Now()) + 1) & "/20/" & Year(Now()) & "<br/>"
            strPayPeriod = "<br/>" & "(If any discrepancies, please send an email to <a href='mailto:PaymentReview@bestservicers.com' >Payment Review</a> with explanation for correction)"
            payperiod.Text = strPayPeriod
   
   end if 
        'lastday.Text = FormatDateTime((Month(Now()) & "/" & intLastDay & "/" & year(now())) & " 23:59:00",DateFormat.GeneralDate)
   
        loadpartchargesbypartnerID(Master.PartnerID)
  
  end sub
  
    Private Sub loadpartchargesbypartnerID(ByVal lngPartnerID As Long)
        
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSingleLongParameterDataGrid("spListPartsChargeByPartnerID", "@PartnerID", lngPartnerID, dgvChargeParts)
        
        lblTicketCount1.Text = " [ " & CType(dgvChargeParts.DataSource, Data.DataSet).Tables(0).Rows.Count & " ] "

        
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
 <div style=" text-align:center;"><asp:label ID="lastDay" runat="server" visible="false"></asp:label>Parts not returned within 15 days after ticket closed - Charges may apply on the following pay period!  <asp:Label ID="payperiod" runat="server"></asp:Label></div>
 <form id="frmTickets" runat="server" >
    <table style="width: 100%">
      <tbody>
        <tr>
          <td>
            <div class="inputformsectionheader" style="text-align:center;">
                List of Parts and Amounts to be charged:<asp:Label ID="lblTicketCount" runat="server"></asp:Label>
            </div>
            <div class="inputform">
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
                  <asp:BoundColumn HeaderText="ChargeCore" DataField="ChargeTechCoreAmount"  />
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
            </div>
          </td>
        </tr>
      </tbody>
    </table>
  </form>
  <asp:Label ID="lblSortOrder" runat="server" Visible="false" />
</asp:Content>