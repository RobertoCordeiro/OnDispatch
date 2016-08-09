<%@ Page Language="VB" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

  Private _ID As Long = 0
  Private _TicketID As Long = 0
  Private _Day as Integer = 0
  Private _Month as Integer = 0
  Private _Year as Integer = 0
  Private _intCount as Integer = 0
  
  Private Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
    Response.Buffer = True
    If CType(System.Configuration.ConfigurationManager.AppSettings("DownForMaintenance"), Boolean) Then
      Response.Redirect(System.Configuration.ConfigurationManager.AppSettings("MaintenanceUrl"), True)
      Response.Flush()
      Response.End()
    Else
      Dim blnRequireSecure As Boolean = System.Configuration.ConfigurationManager.AppSettings("RequireSecureConnection")
      If blnRequireSecure Then
        If (Request.ServerVariables("HTTPS") = "off") Then
          Dim strRedirect As String = ""
          Dim strQuery As String = ""
          strRedirect = "https://" & Request.ServerVariables("SERVER_NAME")
          strRedirect &= Request.ServerVariables("SCRIPT_NAME")
          strQuery = Request.ServerVariables("QUERY_STRING")
          If strQuery.Trim.Length > 0 Then
            strRedirect &= "?"
            strRedirect &= strQuery
          End If
          Response.Redirect(strRedirect, True)
        End If
      End If
      Try
        _ID = CType(Request.QueryString("id"), Long)
        _Day = Ctype(Request.QueryString ("Day"),Long)
        _Month = Ctype(request.QueryString ("Month"),Long)
        _Year = Ctype(request.QueryString ("Year"),Long)
        
      Catch ex As Exception
        _ID = 0
        _Day = 0
        _Month = 0
        _Year = 0
      End Try
      If _ID > 0 Then
        lblCompanyName.Text = "Daily Schedule"
        'lblCompanyName.Text = System.Configuration.ConfigurationManager.AppSettings("CompanyName")        
        
        lblContinuousForm.Text = "<table width='100%'><tr>"
        lblContinuousForm.Text += "<td>" + BuildContinuousForm(_Day,_Month,_Year) + "</td>"
        lblContinuousForm.Text += "</tr>"
        lblContinuousForm.Text += "</table>"
        
      Else
        frmTicket.Visible = False
      End If
    End If
  End Sub
  
  Private Function BuildContinuousForm(lngDay as Integer,lngMonth as Integer ,lngYear as Integer ) as string
  Dim htmlForm As String = ""
  Dim dt As System.Data.SqlClient.SqlDataReader
  Dim dt1 as System.Data.SqlClient.SqlDataReader
        Dim i As Integer
    Dim rptPhoneNumbers as New System.Web.UI.WebControls.Repeater 
  i = 1
        htmlForm += "<table' cellspacing=0>"
        htmlForm += "<tr><td>"

       dt = GetEvent(lngDay, lngMonth, lngYear)
       If dt.HasRows Then
         'Dim toolTip As String = dt.Rows(0)("Event").ToString()
         While dt.Read
            htmlForm += "<table style='width: 100%'><tbody><tr><td>" 
            htmlForm += "<div class='ticketsectionheader'>Scheduled Time</div>"
            htmlForm += "<div><b>From:</b>&nbsp; " + dt("ScheduledDate").ToString  + "</div>"
            htmlForm += "<div><b>To:</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; " + dt("ScheduledEndDate").ToString + "</div>"
            htmlForm += "<div style='text-align: left;'></div>"
            htmlForm += "</td>"
            htmlForm += "<td>&nbsp;</td><td>"
            htmlForm += "<div class='ticketsectionheader'>Customer Information</div>"
            htmlForm += "<div>" + dt("Company").tostring() + "</div>"
            htmlForm += "<div>" + dt("EndUser").tostring() + "</div>"
            htmlForm += "<div>" + dt("Street").ToString + " " + dt("Extended").ToString  + "</div>"
            htmlForm += "<div>" + dt("City").ToString + ", " + dt("Abbreviation").ToString + "  " + dt("ZipCode").ToString + "<div>"
            dt1 = GetPhoneNumbers(dt("TicketID"))
            if dt1.HasRows then
              while dt1.Read 
                htmlForm += "<div><b>" + dt1("PhoneType").ToString + ":</b> " + dt1("AreaCode").ToString + "-" + dt1("Exchange").ToString + "-" + dt1("LineNumber").ToString + " - Ext. " + dt1("Extension").ToString 
              end while
            
            end if
                        
            htmlForm += "</td><td>&nbsp;</td><td>"
            htmlForm += "<div class='ticketsectionheader'>Ticket Information</div>"
            htmlForm += "<table cellspacing='0'><tr>"
            htmlForm += "<td class='label'>Ticket ID</td><td>&nbsp;</td>"
            htmlForm += "<td>" + dt("TicketID").ToString + "</td></tr><tr>"
            htmlForm += "<td class='label'>Work Order ID</td><td>&nbsp;</td>"
            htmlForm += "<td>" + dt("WorkOrderID").ToString + "</td></tr><tr>"
            htmlForm += "<td class='label'>Manufacturer</td><td>&nbsp;</td>"
            htmlForm += "<td>" + dt("Manufacturer").ToString + "</td></tr><tr>"
            htmlForm += "<td class='label'>Customer Number:</td><td>&nbsp;</td>"
            htmlForm += "<td>" + dt("ReferenceNumber1").ToString + "</td></tr><tr>"                    
            htmlForm += "<td class='label'>Customer PO:</td><td>&nbsp;</td>"
            htmlForm += "<td>" + dt("ReferenceNumber2").ToString + "</td></tr></table></td></tr>"
            htmlForm += "<tr><td colspan='5'>"
            htmlForm += "<div class='ticketsectionheader'>Problem Description</div>" + dt("Notes").ToString 
            htmlForm += "</td><td><hr align='left' width='100%' size='5' noshade='noshade' />"
            htmlForm += "</td></tr></tbody></table>"
            htmlForm += "<hr align='left' width='100%' size='3' noshade='noshade' />"
            i = i + 1
         End While
         
       End If
       ' htmlCalendar += "<td class='previous'>&nbsp;</td>"
       htmlForm += "</td></tr>"
        
       htmlForm += "</table>"
             
       _intCount = i
       Return htmlForm
       
       
  End Function
  
    
  Public Function GetEvent(ByVal currentDate As Integer, ByVal month As Integer, ByVal year As Integer) As System.Data.SqlClient.SqlDataReader
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetTicketsScheduledByPartnerID")
        cmd.CommandType = Data.CommandType.StoredProcedure
        Dim str1 As String
        Dim str2 As String
        
        str1 = FormatDateTime(CDate(ProperDateFormat(currentDate, month, year)) + " 00:00:00", DateFormat.GeneralDate)
        str2 = FormatDateTime(CDate(ProperDateFormat(currentDate, month, year)) + " 23:59:00", DateFormat.GeneralDate)
        
        cmd.Parameters.Add("@PartnerAgentID", Data.SqlDbType.Int).Value = _ID
        cmd.Parameters.Add("@Date1", Data.SqlDbType.DateTime).Value = Convert.ToDateTime(str1)
        cmd.Parameters.Add("@Date2", Data.SqlDbType.DateTime).Value = Convert.ToDateTime(str2)
        
        Dim strChangeLog As String
        strChangeLog = ""
        cnn.Open()
        cmd.Connection = cnn
        'Dim dtr1 As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        
        Return cmd.ExecuteReader
       
        cnn.Close()
    End Function
    Private Function ProperDateFormat(ByVal d As Integer, ByVal m As Integer, ByVal y As Integer) As String
        Try
            Dim months() As String = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"}
                     
            Return m.ToString() + "/" + d.ToString() + "/" + y.ToString()
        Catch ex As Exception
            Return ""
        End Try
    End Function
    
    Public Function GetPhoneNumbers(lngTicketID as long) As System.Data.SqlClient.SqlDataReader
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spListTicketPhoneNumbers")
        cmd.CommandType = Data.CommandType.StoredProcedure
        
        
        
        cmd.Parameters.Add("@TicketID", Data.SqlDbType.Int).Value = lngTicketID
        
        Dim strChangeLog As String
        strChangeLog = ""
        cnn.Open()
        cmd.Connection = cnn
        'Dim dtr1 As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        
        Return cmd.ExecuteReader
       
        cnn.Close()
    End Function
  
</script>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Daily Schedule</title>
    <link rel="stylesheet" type="text/css"  href="/stylesheets/paper.css" />
</head>
  <body class="paper">
    <form id="frmTicket" runat="server">
        <table style="width: 100%;">
          <tr>
            <td style="width: 64px;"></td>
            <td class="ticketsectionheader" style="text-align: center;"><asp:Label ID="lblCompanyName" runat="server" /></td>
            <td style="width: 64px;"></td>
          </tr>
        </table>
                 <asp:Label ID="lblContinuousForm" runat="server" Text="Generated Calendar Holder"></asp:Label>
                 
    </form>
  </body>
</html>
