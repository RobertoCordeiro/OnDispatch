<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server"> 
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Edit Ticket Note"
      Master.PageTitleText = "Edit Ticket Note"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""tickets.aspx"">Ticket Management</a> &gt; "
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If _ID > 0 Then
      If Not IsPostBack Then
        LoadNote()
      End If
    Else
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub
  
  Private Sub LoadNote()
    Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    tnt.Load(_ID)    
    Master.PageSubHeader = "<a href=""ticket.aspx?id=" & tnt.TicketID & """>Ticket</a> &gt; Edit Ticket Note"    
    txtNote.Text = tnt.NoteBody
    chkAcknowledged.Checked = tnt.Acknowledged
    chkCustomerVisible.Checked = tnt.CustomerVisible
    chkPartnerVisible.Checked = tnt.PartnerVisible
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If txtNote.Text.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Note is Required</li>      "
    End If
    divErrors.innerhtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function

  Private Sub btnOK_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      Dim strChangeLog As String = ""
      divErrors.Visible = False
      Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      tnt.Load(_ID)
      'tnt.NoteBody = txtNote.Text
      tnt.Acknowledged = chkAcknowledged.Checked
      tnt.PartnerVisible = chkPartnerVisible.Checked
      tnt.CustomerVisible = chkCustomerVisible.Checked
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
      act.Add(Master.UserID, "web", strType, strIp, Master.WebLoginID.ToString, tnt.ActionObjectID, tnt.TicketNoteID, strChangeLog)
      Response.Redirect(lblReturnUrl.Text, True)
    Else
      divErrors.Visible = True
    End If
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form style="width: 620px;" id="frmDialog" runat="server">
    <div class="errorzone" id="divErrors" runat="server" visible="false" />
    <div class="label">Note Body</div>
    <div style="padding-right: 3px"><asp:TextBox ID="txtNote" runat="server" style="width: 100%; height: 200px;" TextMode="multiline" /></div>
    <div style="text-align: right;"><asp:CheckBox ID="chkAcknowledged" runat="server" Text="Acknowledged" />&nbsp;<asp:CheckBox ID="chkPartnerVisible" Text="Partner Visible" runat="server" />&nbsp;<asp:CheckBox ID="chkCustomerVisible" runat="server" Text="Customer Visible" /></div>
    <div>&nbsp;</div>
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnOK" OnClick="btnOK_Click" Text="OK" runat="server" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>