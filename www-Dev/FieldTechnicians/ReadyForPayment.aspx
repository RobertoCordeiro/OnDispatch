<%@ Page Language="vb" masterpagefile="~/masters/FieldTechnicians.master" %>
<%@ MasterType VirtualPath="~/masters/FieldTechnicians.master" %>
<script runat="server">
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
            Master.PageHeaderText = "Tickets Ready for Payment"
            Master.PageTitleText = "Tickets Ready for Payment"
      
           
      Master.ActiveMenu = "I"
    End If
    LoadWorkOrders()
  End Sub
  
  Private Sub LoadWorkOrders()
  Dim intlastDay as Integer 
  Dim dtLastMonthFirstDay  as date
  Dim dtLastMonthLastDay as date
  
  dtLastMonthLastDay = datetime.Today.AddDays(0 - datetime.Today.Day)
  dtLastMonthFirstDay = dtLastMonthLastDay.AddDays (1 - dtLastMonthLastDay.Day)
  intlastDay = Day(DateSerial(Year(Now()),Month(Now())+1,0))
  
    if master.AdminAgent then
      Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        'ldr.LoadSingleLongParameterDataGrid("spListClosedPartnerWorkOrdersReadyForPayment", "@PartnerID", Master.PartnerID, Me.dgvReadyForPayment)
            ldr.LoadLongDateParameterDataGrid("spListClosedPartnerWorkOrdersReadyForPayment", "@PartnerID", Master.PartnerID, "@LastDate", FormatDateTime((Month(Now()) & "/01/" & Year(Now())) & " 00:00:00", DateFormat.GeneralDate), dgvReadyForPayment)
    else
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        'ldr.LoadSingleLongParameterDataGrid("spListClosedPartnerAgentWorkOrdersReadyForPayment", "@PartnerAgentID", Master.PartnerAgentID, Me.dgvReadyForPayment)
            ldr.LoadLongDateParameterDataGrid("spListClosedPartnerAgentWorkOrdersReadyForPayment", "@PartnerAgentID", Master.PartnerAgentID, "@LastDate", FormatDateTime((Month(Now()) & "/01/" & Year(Now())) & " 00:00:00", DateFormat.GeneralDate), dgvReadyForPayment)
    end if
            lblTicketCount.Text = " [ " & CType(dgvReadyForPayment.DataSource, Data.DataSet).Tables(0).Rows.Count & " ] "

  End Sub
  
  Private Function GetAppointmentText(ByRef objStart As Object, ByRef objEnd As Object, ByVal lngTicketID As Long) As String
    Dim strReturn As String = ""
    Dim datStart As Date = Nothing
    Dim datEnd As Date = Nothing
    If Not IsDBNull(objStart) And Not IsDBNull(objEnd) Then
      datStart = CType(objStart, Date)
      datEnd = CType(objEnd, Date)
      If (datStart.Month = datEnd.Month) And (datStart.Year = datEnd.Year) And (datStart.Day = datEnd.Day) Then
        strReturn = "<a href=""editticketappointment.aspx?id=" & lngTicketID & "&returnurl=workorders.aspx"">" & datStart.Month & "/" & datStart.Day & "/" & datStart.Year & " " & datStart.Hour.ToString("00") & ":" & datStart.Minute.ToString("00") & " - " & datEnd.Hour.ToString("00") & ":" & datEnd.Minute.ToString("00") & "</a>"
      Else
        strReturn = "<a href=""editticketappointment.aspx?id=" & lngTicketID & "&returnurl=workorders.aspx"">" & datStart.Month & "/" & datStart.Day & "/" & datStart.Year & " " & datStart.Hour.ToString("00") & ":" & datStart.Minute.ToString("00") & " - " & datEnd.Month & "/" & datEnd.Day & "/" & datEnd.Year & " " & datEnd.Hour.ToString("00") & ":" & datEnd.Minute.ToString("00") & datEnd.Hour.ToString("00") & ":" & datEnd.Minute.ToString("00") & "</a>"
      End If
    Else
      strReturn = "<a href=""editticketappointment.aspx?id=" & lngTicketID & "&returnurl=workorders.aspx"">Set Appointment</a>"
    End If
    Return strReturn
  End Function
   
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
 <div class="important">Tickets Ready for Payment (System will move them automatically to the "TO BE PAID" section of the menu based on pay period)</div>
  <form id="frmWorkOrders" runat="server">
    <div class="inputformsectionheader"><asp:Label ID="lblTicketCount" runat="server"></asp:Label> Tickets Ready For Payment</div>
        <asp:DataGrid ID="dgvReadyForPayment" runat="server" style="width: 100%; background-color:White;" AutoGenerateColumns="false">
      <HeaderStyle CssClass="gridheader" />
      <AlternatingItemStyle CssClass="altrow" />
      <Columns>
        <asp:BoundColumn HeaderText="ID" DataField="WorkOrderID" Visible="false" />
        <asp:TemplateColumn HeaderText="Ticket ID">
          <ItemTemplate>
            <a href="ticket.aspx?id=<%# Databinder.Eval(Container.DataItem,"TicketID") %>&returnurl=workorders.aspx&act=I"><%# Databinder.Eval(Container.DataItem,"TicketID") %></a>
          </ItemTemplate>
        </asp:TemplateColumn>
        <asp:templatecolumn HeaderText="Work Order ID">
          <itemtemplate>
            <a href="printableworkorder.aspx?id=<%#DataBinder.Eval(Container.DataItem, "WorkOrderID")%>"><%#DataBinder.Eval(Container.DataItem, "WorkOrderID")%></a>
          </itemtemplate>
        </asp:templatecolumn>
        <asp:BoundColumn HeaderText="Status" DataField="WorkOrderStatus" />
        <asp:BoundColumn HeaderText="Resolved" DataField="Resolved" />
        <asp:BoundColumn HeaderText="Dispatched" DataField="DispatchDate" />
        <asp:BoundColumn HeaderText="Date Closed" DataField="Departed" />
      </Columns>      
    </asp:DataGrid>
  </form>
</asp:Content>