<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>

<script runat="server"> 
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
        If User.Identity.IsAuthenticated Then
            Master.WebLoginID = CType(User.Identity.Name, Long)
            Master.PageHeaderText = " Remove Partner Agent Availability"
            Master.PageTitleText = " Remove Partner Agent Availability"
        End If
        
        Try
            _ID = CType(Request.QueryString("id"), Long)
        Catch ex As Exception
            _ID = 0
        End Try
        lblReturnUrl.Text = Request.QueryString("returnurl")
        If _ID > 0 Then
            LoadScheduleZones()
        Else
            Response.Redirect(lblReturnUrl.Text, True)
        End If
    End Sub

    Private Sub LoadScheduleZones()
        Dim par As New BridgesInterface.PartnerAgentAvailabilityRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
        par.Load(_ID)
        Dim rtr As New BridgesInterface.ScheduleZoneTemplateRecord(par.ConnectionString)
        rtr.Load(par.ScheduleZoneTemplateID)
        lblPartnerAgentAvailability.Text = "<div><pre>" & rtr.ZoneName & ":" & rtr.StartScheduleTime & "-" & rtr.EndScheduleTime & "</pre></div>"
    End Sub
  
  Private Sub btnOK_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim strChangeLog as String = ""
        Dim apa As New BridgesInterface.PartnerAgentAvailabilityRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    apa.Load(_ID)
    apa.Active = 0
    apa.Save(strChangeLog)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div>&nbsp;</div>
    <div>Are you sure you wish to disassociate <asp:Label ID="lblPartnerAgentAvailability" runat="server" /></div>
    <div>&nbsp;</div>
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnOk" OnClick="btnOK_Click" Text="Yes" runat="server" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>
