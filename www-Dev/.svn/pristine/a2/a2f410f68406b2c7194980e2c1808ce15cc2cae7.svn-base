<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<%@ Register Src="~/controls/DateTimePicker.ascx" TagName="DateTimePicker" TagPrefix="cv" %>
<script runat="server"> 
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Set Ticket Appointment"
      Master.PageTitleText = "Set Ticket Appointment"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; "
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If _ID > 0 Then
      If Not IsPostBack Then
        LoadTicket()
      End If
    Else
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub

  Private Sub LoadTicket()
    Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    tkt.Load(_ID)
    dtpStart.DateValue = tkt.ScheduledDate
    dtpEnd.DateValue = tkt.ScheduledEndDate
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If Not dtpStart.Validates Then
      blnReturn = False
      strErrors &= "<li>Start Date is Invalid</li>"
    End If
    If Not dtpEnd.Validates Then
      blnReturn = False
      strErrors &= "<li>End Date is Invalid</li>"
    End If
    If dtpEnd.Validates And dtpStart.Validates Then
      If dtpEnd.DateValue < dtpStart.DateValue Then
        blnReturn = False
        strErrors &= "<li>End Date Must Be After Start Date</li>"
      End If
    End If
    divErrors.innerhtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
  Private Sub btnOK_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      divErrors.Visible = False
      Dim strChangeLog As String = ""
      Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      tkt.Load(_ID)
      tkt.ScheduledDate = dtpStart.DateValue
      tkt.ScheduledEndDate = dtpEnd.DateValue
      tkt.Save(strChangeLog)
      Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, "Appointment Set: " & dtpStart.DateValue.ToString & " - " & dtpEnd.DateValue.ToString)
      tnt.CustomerVisible = True
      tnt.PartnerVisible = True
      tnt.Acknowledged = True
      tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
      tnt.Save(strChangeLog)
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
  <form id="frmDialog" runat="server">
    <div class="errorzone" id="divErrors" runat="server" visible="false" />    
    <div class="label">Appointment Starts</div>
    <cv:DateTimePicker ID="dtpStart" YearLower="0" YearUpper="1" runat="server" />
    <div>&nbsp;</div>
    <div class="label">Appintment Ends</div>
    <cv:DateTimePicker ID="dtpEnd" YearLower="0" YearUpper="1" runat="server" />
    <div>&nbsp;</div>
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnOk" runat="server" OnClick="btnOK_Click" Text="OK" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>