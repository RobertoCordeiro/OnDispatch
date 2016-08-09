<%@ Page Language="vb" masterpagefile="~/masters/FieldTechnicians.master" %>
<%@ MasterType VirtualPath="~/masters/FieldTechnicians.master" %>
<script runat="server">
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
            Master.PageHeaderText = Now() & " - Schedule Calendar"
            Master.PageTitleText =  " Schedule Calendar"
            Master.ActiveMenu = "D"
    End If
        TrackTraffic()
        
        If Not IsPostBack Then
            '  Generates report for current year
            lblCalendar.Text = "<table width='100%'>"
            Dim horizontalRepeat As Integer = 1     '   number of months in horizontal direction
            Dim month As Integer
            GetMonths()
            For month = drpMonths.SelectedValue To drpMonths.SelectedValue
                If (month Mod horizontalRepeat = 1) Then
                    lblCalendar.Text += "<tr valign='top'>"
                End If

                lblCalendar.Text += "<td>" + generateCalendar(month, drpYears.SelectedValue) + "</td>"

                If (month Mod horizontalRepeat = 0) Then
                    lblCalendar.Text += "</tr>"
                End If
            Next

            lblCalendar.Text += "</table>"
        Else
            '  Generates report for current year
            lblCalendar.Text = "<table width='100%'>"
            Dim horizontalRepeat As Integer = 1     '   number of months in horizontal direction
            Dim month As Integer
            
            For month = drpMonths.SelectedValue To drpMonths.SelectedValue
                If (month Mod horizontalRepeat = 1) Then
                    lblCalendar.Text += "<tr valign='top'>"
                End If

                lblCalendar.Text += "<td>" + generateCalendar(month, drpYears.SelectedValue) + "</td>"

                If (month Mod horizontalRepeat = 0) Then
                    lblCalendar.Text += "</tr>"
                End If
            Next

            lblCalendar.Text += "</table>"
        End If
  End Sub
  
  Private Sub TrackTraffic()
    Dim tm As New cvTrafficMaster.TransactionRecord(System.Configuration.ConfigurationManager.AppSettings("TMCnn"))
    tm.Add(Request.ServerVariables("SCRIPT_NAME"))
    If Not IsNothing(Request.ServerVariables("HTTP_REFERER")) Then
      tm.Referrer = Request.ServerVariables("HTTP_REFERER")
    End If
    If Not IsNothing(Request.ServerVariables("HTTP_USER_AGENT")) Then
      tm.UserAgent = Request.ServerVariables("HTTP_USER_AGENT")
    End If
    If Not IsNothing(Request.ServerVariables("REMOTE_ADDR")) Then
      tm.RemoteAddress = Request.ServerVariables("REMOTE_ADDR")
    End If
    If Not IsNothing(Request.ServerVariables("QUERY_STRING")) Then
      tm.QueryString = Request.ServerVariables("QUERY_STRING")
    End If
    If Not IsNothing(Request.ServerVariables("SERVER_NAME")) Then
      tm.ServerName = Request.ServerVariables("SERVER_NAME")
    End If
    Dim strChangelog As String = ""
    tm.Save(strChangelog)
    Dim tf As New cvTrafficMaster.FlagRecord(System.Configuration.ConfigurationManager.AppSettings("TMCnn"))
    tf.LoadByRemoteHost(tm.RemoteAddress)
    If tf.FlagID > 0 Then
      Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      eml.SendFrom = "info@bestservicers.com"
      eml.SendTo = "info@bestservicers.com"
      eml.Subject = "Possible Partner Security Breach!"
      eml.Body = "<p>A user at a flagged IP Address accessed the system, this is a possible security breach!</p>"
      eml.Body &= "<div>Details</div>"
      eml.Body &= "User ID: " & Master.UserID & "<br />"
      eml.Body &= "Web Login ID:" & Master.WebLoginID & "<br />"
      eml.Send()
    End If
    End Sub
    
    
    Private Function generateCalendar(ByVal month As Integer, ByVal year As Integer) As String
        '  generates the calendar as per the booking status
        Dim wholeCalendar(5, 6) As Integer
        Dim weeks As Integer = 0
        Dim day As String = ""
        Dim tmpDate As DateTime
        Dim myDate As Integer

        For myDate = 1 To 31
            Try
                tmpDate = New DateTime(year, month, myDate)
                If (day = "Saturday") Then
                    weeks += 1
                End If
                day = tmpDate.DayOfWeek.ToString()

                If (day = "Sunday") Then
                    'If (wholeCalendar(weeks, 0) > 0) Then weeks += 1
                    wholeCalendar(weeks, 0) = myDate
                ElseIf (day = "Monday") Then
                    'If (wholeCalendar(weeks, 1) > 0) Then weeks += 1
                    wholeCalendar(weeks, 1) = myDate
                ElseIf (day = "Tuesday") Then
                    'If (wholeCalendar(weeks, 2) > 0) Then weeks += 1
                    wholeCalendar(weeks, 2) = myDate
                ElseIf (day = "Wednesday") Then
                    'If (wholeCalendar(weeks, 3) > 0) Then weeks += 1
                    wholeCalendar(weeks, 3) = myDate
                ElseIf (day = "Thursday") Then
                    'If (wholeCalendar(weeks, 4) > 0) Then weeks += 1
                    wholeCalendar(weeks, 4) = myDate
                ElseIf (day = "Friday") Then
                    'If (wholeCalendar(weeks, 5) > 0) Then weeks += 1
                    wholeCalendar(weeks, 5) = myDate
                ElseIf (day = "Saturday") Then
                    'If (wholeCalendar(weeks, 6) > 0) Then weeks += 1
                    wholeCalendar(weeks, 6) = myDate
                End If
            Catch ex As Exception
                Exit For
            End Try
        Next

        '   Generates the HTML calendar
        Dim htmlCalendar As String = ""
        Dim dt As System.Data.SqlClient.SqlDataReader
        Dim i As Integer, j As Integer
        
        printSchedule.Text = "<a target='_blank' href='schedulereport.aspx?id=" & Master.PartnerAgentID & "&day=" & DateTime.Today.Day & "&month=" & DateTime.Today.Month & "&year=" & DateTime.Today.Year & "'>Print Todays Schedule</a>" & "       " & "<a target='_blank' href='schedulereport.aspx?id=" & Master.PartnerAgentID & "&day=" & (DateTime.Today.Day + 1) & "&month=" & (DateTime.Today.Month) & "&year=" & (DateTime.Today.Year) & "'>Print Tomorrow Schedule</a>"
        
        htmlCalendar += "<table class='calendarFrame' cellspacing=0>"
        htmlCalendar += "<tr class='calendarMonthYear' style='text-align: center;'><td colspan='7'>" + getMonthName(month) + " " + year.ToString() + "</td></tr>"
        htmlCalendar += "<tr class='calendarDay' style='text-align: center;'> <td>Sun</td>  <td>Mon</td>  <td>Tue</td>  <td>Wed</td>  <td>Thu</td>  <td>Fri</td>  <td>Sat</td> </tr>"

        For i = 0 To 5
            htmlCalendar += "<tr>"

            For j = 0 To 6
                If wholeCalendar(i, j) > 0 Then
                    dt = GetEvent(wholeCalendar(i, j), month, year)
                    
                    If dt.HasRows Then
                        'Dim toolTip As String = dt.Rows(0)("Event").ToString()
                       
                          htmlCalendar += "<td class='hasEvent'>" + wholeCalendar(i, j).ToString() + "<ul>"
                       
                        While dt.Read
                            If IsDBNull(dt("Departed")) Then
                                htmlCalendar += "<li ><a target='_blank' href='ticket.aspx?id=" & dt("TicketID").ToString & "&act=D'>" + FormatDateTime(dt("scheduledDate"), DateFormat.ShortTime) + " " + dt("TicketID").ToString() + "-" + dt("ContactLastName").ToString + "</a></li>"
                            Else
                                htmlCalendar += "<li ><a target='_blank' href='ticket.aspx?id=" & dt("TicketID").ToString & "&act=D'>" + FormatDateTime(dt("scheduledDate"), DateFormat.ShortTime) + " " + dt("TicketID").ToString() + "-" + dt("ContactLastName").ToString + "</a><img src='/graphics/true1.png' alt='Closed Call' /></li>"
                            End If
                            
                        End While
                        htmlCalendar += "</ul></td>"
                    Else
                       
                          htmlCalendar += "<td class='hasNoEvent'>" + wholeCalendar(i, j).ToString() + "</td>"
                        
                    End If
                    
                Else
                    htmlCalendar += "<td class='previous'>&nbsp;</td>"
                    
                End If
            Next

            htmlCalendar += "</tr>"
        Next
        htmlCalendar += "</table>"

        '   Close database connection
        'objEventsDAO.CloseConnection()

        '   returns the generated HTML calendar
        Return htmlCalendar

    End Function

    Private Function getMonthName(ByVal month As Integer) As String
        Dim months() As String = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"}

        Return months(month - 1)
    End Function
   
    Private Sub GetMonths()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSimpleDropDownList("spListMonths", "MonthName", "MonthID", drpMonths)
                
        drpMonths.SelectedValue = Month(Now())
        GetYears()
    End Sub
    Private Sub GetYears()
        drpYears.Items.Add(2009)
        drpYears.Items.Add(2010)
        drpYears.Items.Add(2011)
        drpYears.Items.Add(2012)
        drpYears.Items.Add(2013)
        drpYears.Items.Add(2014)
        drpYears.Items.Add(2015)
        drpYears.SelectedValue = Year(Now())
    End Sub
    
    Public Function GetEvent(ByVal currentDate As Integer, ByVal month As Integer, ByVal year As Integer) As System.Data.SqlClient.SqlDataReader
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetTicketsScheduledByPartnerID")
        cmd.CommandType = Data.CommandType.StoredProcedure
        Dim str1 As String
        Dim str2 As String
        
        str1 = FormatDateTime(CDate(ProperDateFormat(currentDate, month, year)) + " 00:00:00", DateFormat.GeneralDate)
        str2 = FormatDateTime(CDate(ProperDateFormat(currentDate, month, year)) + " 23:59:00", DateFormat.GeneralDate)
        
        cmd.Parameters.Add("@PartnerAgentID", Data.SqlDbType.Int).Value = Master.PartnerAgentID
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
    
  
</script>

<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  
    <form id="form1" runat="server">
    <div style="text-align:center;">
        <table class="mainTableFrame">
            <tr>
                <td class="subHeader" style="text-align: center">Schedule Calendar - <asp:DropDownList ID="drpMonths" runat="server" AutoPostBack ="True"></asp:DropDownList><asp:DropDownList ID="drpYears" runat="server" AutoPostBack ="True"></asp:DropDownList><asp:label ID="printSchedule" runat="server"></asp:label></td>
            </tr>
            
            <tr>
                <td>
                    <asp:Label ID="lblCalendar" runat="server" Text="Generated Calendar Holder"></asp:Label></td>
            </tr>
        </table>
    </div>
    </form>
</asp:Content> 