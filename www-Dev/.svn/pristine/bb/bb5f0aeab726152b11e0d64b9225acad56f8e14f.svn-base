<%@ Page Language="vb" masterpagefile="~/masters/customerdialog.master" %>
<%@ MasterType VirtualPath="~/masters/customerdialog.master" %>
<script runat="server"> 
  
  Private _ID As Long = 0
  Private _ReadOnly As Boolean = False
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Update Priority"
      Master.PageTitleText = " Update Priority"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = "ticket.aspx?id=" & _ID
    Secure()
    If _ID > 0 Then
      If Not IsPostBack Then
        LoadPriorities()
        LoadTicket()
      End If
    Else
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub
  
  Private Sub Secure()
    Dim cag As New BridgesInterface.CustomerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    cag.Load(Master.CustomerAgentID)
    Dim tkt As New BridgesInterface.TicketRecord(cag.ConnectionString)
    tkt.Load(_ID)
    Dim srv As New BridgesInterface.ServiceRecord(cag.ConnectionString)
    srv.Load(tkt.ServiceID)
    If tkt.CustomerID <> Master.CustomerID Then
      Response.Redirect("default.aspx")
    Else
      _ReadOnly = cag.ServiceTypeReadOnly(srv.ServiceTypeID)      
      Me.btnChange.Enabled = Not _ReadOnly
    End If
  End Sub
  
  Private Sub LoadTicket()
    Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    tkt.Load(_ID)
    cbxPriorities.SelectedValue = tkt.CustomerPrioritySetting
  End Sub
  
  Private Sub LoadPriorities()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDropDownList("spListPriorities", "Description", "PriorityID", cbxPriorities)
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If txtNote.Text.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>A Note explaining the reason for the priority change is required.</li>"
    End If
    divErrors.innerhtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function

  Private Sub btnChange_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim strChangeLog As String = ""
      tkt.Load(_ID)
      tkt.CustomerPrioritySetting = cbxPriorities.SelectedValue
      tkt.Save(strChangeLog)
      Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim strIp As String = Request.QueryString("REMOTE_ADDR")
      Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
      If IsNothing(strIp) Then
        strIp = "unknown"
      End If
      If IsNothing(strType) Then
        strType = "web"
      End If      
      act.Add(Master.UserID, "web", strType, strIp, Master.WebLoginID.ToString, 33, tkt.TicketID, strChangeLog)
      Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      tnt.Add(_ID, Master.WebLoginID, Master.UserID, "Priority Has Changed To " & cbxPriorities.SelectedItem.Text & ": " & txtNote.Text)
      tnt.CustomerVisible = True
      tnt.Acknowledged = False
      tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Customer
      tnt.Save(strChangeLog)
      If tkt.CustomerPrioritySetting > 3 Then
        Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
        eml.Subject = tkt.TicketID & ": High Priority Ticket!!!"
        eml.Body = tnt.NoteBody
        eml.SendFrom = "info@bestservicers.com"
        'eml.SendTo = "3522500564@vtext.com"
        
        eml.SendTo = "5617161312@cingularme.com"
        eml.Send()
        eml.SendTo = "5612810783@cingularme.com"
        eml.Send()
      End If
      Response.Redirect(lblReturnUrl.Text)
    Else
      divErrors.Visible = True
    End If
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div class="errorzone" id="divErrors" runat="server" visible="false" />
    <div class="label">Priority</div>
    <div style="padding-right: 4px"><asp:DropDownList style="width: 100%" ID="cbxPriorities" runat="server" /></div>
    <div class="label">Reason for Priority Change</div>
    <div style="padding-right: 8px;"><asp:TextBox ID="txtNote" runat="server" style="width: 100%" TextMode="multiline" /></div>
    <div>&nbsp;</div>
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnChange" runat="server" Text="Update" OnClick="btnChange_Click" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>