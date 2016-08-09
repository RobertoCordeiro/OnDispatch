<%@ Page Language="vb" masterpagefile="~/masters/partner.master" %>
<%@ MasterType VirtualPath="~/masters/partner.master" %>
<script runat="server">
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Work Orders"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Work Orders"
     
      Master.ActiveMenu = "H"
    End If
    LoadWorkOrders()
  End Sub
  
  Private Sub LoadWorkOrders()
    if master.AdminAgent then
      Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      ldr.LoadSingleLongParameterDataGrid("spListRequireSignatureDispatchedPartnerWorkOrders", "@PartnerID", Master.PartnerID, Me.dgvRequireUpload)
    else
      Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      ldr.LoadSingleLongParameterDataGrid("spListRequireSignatureDispatchedPartnerAgentWorkOrders", "@PartnerAgentID", Master.PartnerAgentID, Me.dgvRequireUpload)
    end if 
          lblTicketCount.Text = " [ " & CType(dgvRequireUpload.DataSource, Data.DataSet).Tables(0).Rows.Count & " ] "

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
  <form id="frmWorkOrders" runat="server">
    <div class="inputformsectionheader"><asp:Label ID="lblTicketCount" runat="server"></asp:Label> Tickets Needing Work Order Uploaded</div>
        <asp:DataGrid ID="dgvRequireUpload" runat="server" style="width: 100%; background-color:White;" AutoGenerateColumns="false" CssClass="Grid1">
      <HeaderStyle CssClass="gridheader" />
      <AlternatingItemStyle CssClass="altrow" />
      <Columns>
        <asp:BoundColumn HeaderText="ID" DataField="WorkOrderID" Visible="false" />
        <asp:TemplateColumn HeaderText="Ticket ID">
          <ItemTemplate>
            <a href="ticket.aspx?id=<%# Databinder.Eval(Container.DataItem,"TicketID") %>&returnurl=workorders.aspx&act=H"><%# Databinder.Eval(Container.DataItem,"TicketID") %></a>
          </ItemTemplate>
        </asp:TemplateColumn>
        <asp:templatecolumn HeaderText="Work Order ID">
          <itemtemplate>
            <a href="printableworkorder.aspx?id=<%#DataBinder.Eval(Container.DataItem, "WorkOrderID")%>"><%#DataBinder.Eval(Container.DataItem, "WorkOrderID")%></a>
          </itemtemplate>
        </asp:templatecolumn>
        <asp:TemplateColumn HeaderText="Upload">
          <ItemTemplate>
            <a href="upload.aspx?mode=wo&id=<%# DataBinder.Eval(Container.DataItem, "WorkOrderID") %>&returnurl=workorders.aspx">Upload</a>
          </ItemTemplate>
        </asp:TemplateColumn>
        <asp:BoundColumn HeaderText="Status" DataField="WorkOrderStatus" />
        <asp:BoundColumn HeaderText="Resolved" DataField="Resolved" />
        <asp:BoundColumn HeaderText="Dispatched" DataField="DispatchDate" />
        <asp:BoundColumn HeaderText="Date Closed" DataField="Departed" />
      </Columns>      
    </asp:DataGrid>
  </form>
</asp:Content>