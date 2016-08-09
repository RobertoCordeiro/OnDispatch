<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<%@ Register Src="~/controls/DateTimePicker.ascx" TagName="DateTimePicker" TagPrefix="cv" %>
<script runat="server"> 
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      'Master.PageHeaderText = "Work Order Punch Clock"
      Master.PageTitleText = "Work Order Punch Clock"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""tickets.aspx"">Ticket Management</a> &gt; Work Order Punch Clock"
    End If
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If Not IsPostBack Then    
      dtpArrived.DateValue = DateTime.Now 
      txtArrivalTime.text = DateTime.Now   
    End If   
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim lng As Long = 0
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If (txtWorkOrderID.Text.Trim & txtTicketID.Text.Trim).Length > 0 Then
      If txtWorkOrderID.Text.Trim.Length > 0 Then
        If Not Long.TryParse(txtWorkOrderID.Text.Trim, lng) Then
          strErrors &= "<li>Work Order ID must be a whole number</li>"
          blnReturn = False
        Else
          Dim wrk As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
          wrk.Load(CType(txtWorkOrderID.Text.Trim, Long))
          If wrk.WorkOrderID = 0 Then
            strErrors &= "<li>Work Order Not Found</li>"
            blnReturn = False
          Else
            If wrk.ClosingAgent > 0 Then
              strErrors &= "<li>This Work Order has already been closed <a href=""ticket.aspx?id=" & wrk.TicketID & """><img src=""/graphics/smallticket.png"" alt=""View Ticket"" /></a></li>"
              blnReturn = False
            Else
              If wrk.arrived < DateTime.Now Then               
                 If not IsDBNull(wrk.arrived.ToString) then
                    blnReturn = True
                 else
 
                    strErrors &= "<li>Technician has already logged in <a href=""ticket.aspx?id=" & wrk.TicketID & """><img src=""/graphics/smallticket.png"" alt=""View Ticket"" /></a></li>"
                    blnReturn = False
                 end if
              Else
                    strErrors &= "<li>Technician has already logged in <a href=""ticket.aspx?id=" & wrk.TicketID & """><img src=""/graphics/smallticket.png"" alt=""View Ticket"" /></a></li>"
                    blnReturn = False
              End if
            End If
          End If
        End If
      End If
      If txtTicketID.Text.Trim.Length > 0 Then
        If Not Long.TryParse(txtTicketID.Text.Trim, lng) Then
          strErrors &= "<li>Ticket ID must be a whole number</li>"
          blnReturn = False
        Else
          Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
          tkt.Load(CType(txtTicketID.Text, Long))
          If tkt.TicketID = 0 Then
            strErrors &= "<li>Ticket Not Found</li>"
            blnReturn = False
          Else
            If tkt.WorkOrderIDs.Count < 1 Then
              strErrors &= "<li>This Ticket does not have a Work Order assigned to it  <a href=""ticket.aspx?id=" & tkt.TicketID & """><img src=""/graphics/smallticket.png"" alt=""View Ticket"" /></a></li>"
              blnReturn = False
            Else
              If tkt.WorkOrderIDs.Count > 1 Then
                strErrors &= "<li>This Ticket has more than one Work Order assigned to it  <a href=""ticket.aspx?id=" & tkt.TicketID & """><img src=""/graphics/smallticket.png"" alt=""View Ticket"" /></li></a>"
                blnReturn = False
               
              End If
            End If
          End If
        End If
      End If
    Else
      blnReturn = False
      strErrors &= "<li>You must enter a Work Order ID or Ticket ID</li>"
    End If
    divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
  Private Sub btnOK_Click(ByVal S As Object, ByVal e As EventArgs)
    Dim strChangeLog As String = ""
    If IsComplete() Then
      divErrors.Visible = False
      Dim wrk As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
      If txtWorkOrderID.Text.Trim.Length > 0 Then
        wrk.Load(CType(txtWorkOrderID.Text.Trim, Long))
        'wrk.Arrived = dtpArrived.DateValue
        wrk.Arrived = DateTime.Now 
        

        Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        tnt.Add(wrk.ticketID, Master.WebLoginID, Master.UserID, "Onsite Login - Visit ID " & txtWorkOrderID.text & ": Tech has arrvied onsite and logged in at " & DateTime.Now)
        tnt.CustomerVisible = True
        tnt.PartnerVisible = True
        tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
        tnt.Acknowledged = True
        tnt.Save(strChangeLog)
        wrk.Save(strChangeLog)
        Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim strIp As String = Request.QueryString("REMOTE_ADDR")
        Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
        If IsNothing(strIp) Then
          strIp = "unknown"
        End If
        If IsNothing(strType) Then
          strType = "web"
        End If
        act.Add(Master.UserID, "web", strType, strIp, Master.WebLoginID.ToString, 43, wrk.WorkOrderID, strChangeLog)
        Response.Redirect(lblReturnUrl.Text, True)
      Else
        Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        tkt.Load(CType(txtTicketID.Text.Trim, Long))
        wrk.Load(tkt.WorkOrderIDs(0))
        wrk.Arrived = dtpArrived.DateValue
        wrk.Save(strChangeLog)

        Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        tnt.Add(tkt.workorderIDs(0), Master.WebLoginID, Master.UserID, "Tech Onsite Login: Tech has arrvied onsite and logged in at " & DateTime.Now)
        tnt.CustomerVisible = True
        tnt.PartnerVisible = True
        tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
        tnt.Acknowledged = True
        tnt.Save(strChangeLog)


        Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim strIp As String = Request.QueryString("REMOTE_ADDR")
        Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
        If IsNothing(strIp) Then
          strIp = "unknown"
        End If
        If IsNothing(strType) Then
          strType = "web"
        End If
        act.Add(Master.UserID, "web", strType, strIp, Master.WebLoginID.ToString, 43, wrk.WorkOrderID, strChangeLog)
        Response.Redirect(lblReturnUrl.Text, True)
      End If
    Else
      divErrors.Visible = True
    End If
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" defaultbutton="btnOk" runat="server">
    <div class="errorzone" id="divErrors" runat="server" visible="false" />
    <div class="label">Work Order ID</div>
    <div style="padding-right: 3px;"><asp:TextBox style="width: 100%" ID="txtWorkOrderID" runat="server" /></div>
    <div style="font-style: italic;"></div>
    <div class="label">Arrival Time</div>
    <div style="padding-right: 3px"><asp:TextBox style="width: 50%" ID="txtTicketID" runat="server" visible="false" /></div>
    <div style="padding-right: 3px"><asp:TextBox style="width: 50%" ID="txtArrivalTime" runat="server" ReadOnly="true" visible="True" /></div    
    <div class="label"></div>
    <cv:DateTimePicker runat="server" ID="dtpArrived" visible="false" />
    <div>&nbsp;</div>
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnOK" runat="server" Text="OK" OnClick="btnOK_Click" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>