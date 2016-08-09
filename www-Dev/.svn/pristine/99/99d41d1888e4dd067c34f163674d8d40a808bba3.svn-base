<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server"> 
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Dispatch Work Order"
      Master.PageTitleText = "Dispatch Work Order"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""tickets.aspx"">Ticket Management</a> &gt; Dispatch Work Order"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If _ID > 0 Then
      Dim wrk As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      wrk.Load(_ID)
      If wrk.WorkOrderID = 0 Then
        Response.Redirect(lblReturnUrl.Text, True)
      End If
    Else
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub

  Private Sub btnYes_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim strChangeLog As String = ""
    Dim wrk As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim ptr As New BridgesInterface.PartnerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim pta As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim strBody As String
    Dim strBodySMS as string      
    wrk.Load(_ID)
    wrk.DispatchDate = DateTime.Now
    wrk.Save(strChangeLog)
        ptr.Load(wrk.PartnerID)
        pta.Load(wrk.PartnerAgentID)
    tkt.Load (wrk.TicketID)
    
    Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
    eml.Subject = "Best Servicers - New Service Dispatch in your area!"
        strBodySMS = "Best Servicers - New Service Dispatch arrived: " & tkt.TicketID & " (" & tkt.City & ", FL " & tkt.ZipCode & ")"
    strBody = "New Dispatch - Ticket Information: " & "%0D%0A"
            strBody= strBody & "Customer Name: " & tkt.ContactFirstName & " " & tkt.ContactLastName & "%0D%0A"
            strBody= strBody & "Address: " & tkt.Street & "%0D%0A"
            'strBody= strBody & "City,State,Zip: " & tkt.City & "  " & stt.Abbreviation & ", " & tkt.ZipCode & "%0D%0A"
            strBody = strBody & "City,State,Zip: " & tkt.City & ", FL " & tkt.ZipCode & "%0D%0A"
            strBody= strBody & "CustomerNumber: " & tkt.ReferenceNumber1 & "%0D%0A"
            strBody= strBody & "Customer PO Number: " & tkt.ReferenceNumber2 & "%0D%0A"
            strBody = strBody & "Type of Service: " & tkt.Manufacturer & "%0D%0A"
            strBody = strBody & "Problem Description: " & tkt.Description & "%0D%0A"
    strBodySMS = "test"
    
    eml.Body = "A new Service Dispatch has been assigned to your account. To print the work order <a href=""" & System.Configuration.ConfigurationManager.AppSettings("LoginFormPath") & """>Log In</a> to our private website. Thanks, Dispatcher.</a>"
    eml.SendFrom = System.Configuration.ConfigurationManager.AppSettings("PartnerSupportEmail")
        eml.SendTo = pta.Email
        
        eml.Send()
        
        'SendSMSMessage(1 ,  GetPartnerAgentBusinessPhoneNumber(wrk.PartnerAgentID),  strBodySMS)
        
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
        
        Dim plog As New BridgesInterface.ProductionLogRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        plog.Add(Master.WebLoginID, Now(), 18, "Ticket has been Dispatched to the technician. Ticket - " & tkt.TicketID)
        
    Response.Redirect(lblReturnUrl.Text, True)
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
    Private Sub SendSMSMessage(ByVal intCountryID As Integer, ByVal strPhoneNumber As String, ByVal strSMSMessage As String)
        'Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        'Dim cmd As New System.Data.SqlClient.SqlCommand("spGetCellPhoneCarriersByCountryID")
        'cmd.CommandType = Data.CommandType.StoredProcedure
        'cmd.Parameters.Add("@CountryID", Data.SqlDbType.Int).Value = intCountryID
        'cnn.Open()
        'cmd.Connection = cnn
        'Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
        'Dim emal as New BridgesInterface.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
         'eml.SendFrom = System.Configuration.ConfigurationManager.AppSettings("PartnerSupportEmail")
         'emal.SendFrom = "rcordeiro@bestservicers.com"
         'emal.Subject = "New Service Call"
         ' emal.Body = "test"
         '   emal.SendTo = "5612450215@txt.att.net"
         '   emal.Send( )
       ' Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        'Dim strAllPhoneNumbers as String
        'strAllPhoneNumbers = ""
        'While dtr.Read
           'If strAllPhoneNumbers = "" then
            ' strAllPhoneNumbers = strPhoneNumber & dtr("Format") 
           'else
           ' strAllPhoneNumbers = strAllPhoneNumbers & "; " & strPhoneNumber & dtr("Format")
           'end if 
            'eml.Body = strSMSMessage
            'eml.SendTo = strPhoneNumber & dtr("Format")
            'eml.Send()
        'End While
           
        'cnn.Close()
  
    End Sub
    
    Private Function GetPartnerAgentBusinessPhoneNumber(ByVal intPartnerAgentID As Integer) As String
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spListPartnerAgentBusinessPhoneNumber")
        Dim strPhoneNumber As String
        strPhoneNumber = "0000000000"
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@PartnerAgentID", Data.SqlDbType.Int).Value = intPartnerAgentID
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            strPhoneNumber = dtr("AreaCode") & dtr("Exchange") & dtr("LineNumber")
        End While
        cnn.Close()
        
        GetPartnerAgentBusinessPhoneNumber = strPhoneNumber
        
    End Function
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div class="errorzone" id="divErrors" runat="server" visible="false" />
    <div>Are you sure you wish to dispatch this work order?</div>
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="No" />&nbsp;<asp:Button ID="btnYes" runat="server" Text="Yes" OnClick="btnYes_Click" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>