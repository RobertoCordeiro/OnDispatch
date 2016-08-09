<%@ Page Language="vb"  masterpagefile="~/masters/partner.master" AutoEventWireup="True"  %>
<%@ MasterType VirtualPath="~/masters/partner.master" %>
<script runat="server">
  Public _Act as string = "B"
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Open Tickets"
      Master.PageTitleText = " Open Tickets"
      Try
         _Act = Request.QueryString("act")
        
       Catch ex As Exception
         _Act = "B"
        End Try
    End If
    Master.ActiveMenu = "B"
    
    LoadWorkOrders()
    
    
 End Sub
 
  Private Sub LoadWorkOrders()
    if master.AdminAgent then
      Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      ldr.LoadSingleLongParameterDataGrid("spListOpenDispatchedPartnerWorkOrders", "@PartnerID", Master.PartnerID, dgvOpenWorkOrders)    
      'ldr.LoadSingleLongParameterDataGrid("spListRequireSignatureDispatchedPartnerWorkOrders", "@PartnerID", Master.PartnerID, Me.dgvRequireUpload)
    else
      Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      ldr.LoadSingleLongParameterDataGrid("spListOpenDispatchedPartnerAgentWorkOrders", "@PartnerAgentID", Master.PartnerAgentID, dgvOpenWorkOrders)    

    end if
    lblTicketCount.Text = " [ " & CType(dgvOpenWorkOrders.DataSource, Data.DataSet).Tables(0).Rows.Count & " ] "

  End Sub
  
    Private Function GetAppointmentText(ByRef objStart As Object, ByRef objEnd As Object, ByVal lngTicketID As Long, ByVal lngWorkOrderID As Long, ByVal lngPartnerAgentID As Long) As String
        Dim strReturn As String = ""
        Dim datStart As Date = Nothing
        Dim datEnd As Date = Nothing
        If Not IsDBNull(objStart) And Not IsDBNull(objEnd) Then
            datStart = CType(objStart, Date)
            datEnd = CType(objEnd, Date)
            If (datStart.Month = datEnd.Month) And (datStart.Year = datEnd.Year) And (datStart.Day = datEnd.Day) Then
                strReturn = "<a href=""editticketappointment2.aspx?id=" & lngTicketID & "&pid=" & lngPartnerAgentID & "&wid=" & lngWorkOrderID & "&returnurl=workorders.aspx?act=" & _Act & """>" & datStart.Month & "/" & datStart.Day & "/" & datStart.Year & " " & datStart.Hour.ToString("00") & ":" & datStart.Minute.ToString("00") & " - " & datEnd.Hour.ToString("00") & ":" & datEnd.Minute.ToString("00") & "</a>"
            Else
                strReturn = "<a href=""editticketappointment2.aspx?id=" & lngTicketID & "&pid=" & lngPartnerAgentID & "&wid=" & lngWorkOrderID & "&returnurl=workorders.aspx?act=" & _Act & """>" & datStart.Month & "/" & datStart.Day & "/" & datStart.Year & " " & datStart.Hour.ToString("00") & ":" & datStart.Minute.ToString("00") & " - " & datEnd.Month & "/" & datEnd.Day & "/" & datEnd.Year & " " & datEnd.Hour.ToString("00") & ":" & datEnd.Minute.ToString("00") & datEnd.Hour.ToString("00") & ":" & datEnd.Minute.ToString("00") & "</a>"
            End If
        Else
            strReturn = "<a href=""editticketappointment2.aspx?id=" & lngTicketID & "&pid=" & lngPartnerAgentID & "&wid=" & lngWorkOrderID & "&returnurl=workorders.aspx?act=" & _Act & """>Set Appointment</a>"
        End If
        Return strReturn
    End Function
  
  
    
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmWorkOrders" runat="server">
    <div class="inputformsectionheader"><asp:Label ID="lblTicketCount" runat="server"></asp:Label> Open Tickets</div>
    <asp:DataGrid ID="dgvOpenWorkOrders" runat="server" style="width: 100%; background-color:White;" AutoGenerateColumns="false">
      <HeaderStyle CssClass="gridheader" />
      <AlternatingItemStyle CssClass="altrow" />
      <Columns>
        <asp:BoundColumn HeaderText="ID" DataField="WorkOrderID" Visible="false" />
        <asp:BoundColumn HeaderText="Age" DataField="Age" />
        <asp:TemplateColumn HeaderText="Ticket ID">
          <ItemTemplate>
            <a href="ticket.aspx?id=<%# Databinder.Eval(Container.DataItem,"TicketID") %>&returnurl=workorders.aspx&act=B"><%# Databinder.Eval(Container.DataItem,"TicketID") %></a>
          </ItemTemplate>
        </asp:TemplateColumn>
        <asp:templatecolumn HeaderText="Print Work Order">
          <itemtemplate>
            <a href="printableworkorder.aspx?id=<%#DataBinder.Eval(Container.DataItem, "WorkOrderID")%>"><%#DataBinder.Eval(Container.DataItem, "WorkOrderID")%></a>
          </itemtemplate>
        </asp:templatecolumn>
        <asp:BoundColumn HeaderText="Customer PO" DataField="ReferenceNumber2" />
        <asp:BoundColumn HeaderText="End User" DataField="EndUser" />
        <asp:BoundColumn HeaderText="City" DataField="City" />
        <asp:TemplateColumn HeaderText="Appt">
          <ItemTemplate>
            <%#GetAppointmentText(DataBinder.Eval(Container.DataItem, "ScheduledDate"), DataBinder.Eval(Container.DataItem, "ScheduledEndDate"), DataBinder.Eval(Container.DataItem, "TicketID"), DataBinder.Eval(Container.DataItem, "WorkOrderID"), DataBinder.Eval(Container.DataItem, "PartnerAgentID"))%>
          </ItemTemplate>
        </asp:TemplateColumn>
        <asp:BoundColumn HeaderText="Status" DataField="WorkOrderStatus" />
        <asp:BoundColumn HeaderText="Dispatched" DataField="DispatchDate" />
      </Columns>      
    </asp:DataGrid>
    
  </form>
</asp:Content>