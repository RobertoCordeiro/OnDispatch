<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server"> 
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Close Work Order"
      Master.PageTitleText = "Close Work Order"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""tickets.aspx"">Ticket Management</a> &gt; Close Work Order"
    End If
    lblReturnUrl.Text = Request.QueryString("returnurl")
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
    If IsComplete() Then
      divErrors.Visible = False
      If txtWorkOrderID.Text.Trim.Length > 0 Then
        Dim wrk As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
        wrk.Load(CType(txtWorkOrderID.Text.Trim, Long))
        Response.Redirect("closeworkorder.aspx?id=" & wrk.WorkOrderID & "&returnurl=ticket.aspx%3fid=" & wrk.TicketID, True)
      Else
        Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        tkt.Load(CType(txtTicketID.Text.Trim, Long))
        Response.Redirect("closeworkorder.aspx?id=" & tkt.WorkOrderIDs(0) & "&returnurl=ticket.aspx%3fid=" & tkt.TicketID, True)
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
    <div style="font-style: italic;">Or</div>
    <div class="label">Ticket ID</div>
    <div style="padding-right: 3px"><asp:TextBox style="width: 100%" ID="txtTicketID" runat="server" /></div>
    <div>&nbsp;</div>
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnOK" runat="server" Text="OK" OnClick="btnOK_Click" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>