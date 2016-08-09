<%@ Page Language="vb" masterpagefile="~/masters/agent.master" ValidateRequest="false" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
            Master.WebLoginID = CType(User.Identity.Name, Long)
            Master.PageHeaderText = Now() & " - Schedule Calendar"
            Master.PageTitleText =  " Schedule Calendar"
            
    End If
          
        If Not IsPostBack Then
            '  Generates report for current year
            lblCalendar.Text = "<table width='100%'>"
            Dim horizontalRepeat As Integer = 1     '   number of months in horizontal direction
            Dim month As Integer
            GetMonths()
            LoadPartners()
            LoadCSRAgents()
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
        
        If drpPartners.SelectedValue <> "Choose One" Then
            printSchedule.Text = "<a target='_blank' href='schedulereport.aspx?id=" & CType(drpPartners.SelectedValue, Long) & "&day=" & DateTime.Today.Day & "&month=" & DateTime.Today.Month & "&year=" & DateTime.Today.Year & "'>Print Todays Schedule</a>" & "       " & "<a target='_blank' href='schedulereport.aspx?id=" & CType(drpPartners.SelectedValue, Long) & "&day=" & (DateTime.Today.Day + 1) & "&month=" & (DateTime.Today.Month + 1) & "&year=" & (DateTime.Today.Year + 1) & "'>Print Tomorrow Schedule</a>"
        Else
            
        End If
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
                                htmlCalendar += "<li ><a target='_blank' href='ticket.aspx?id=" & dt("TicketID").ToString & "&act=D'>" + FormatDateTime(dt("scheduledDate"), DateFormat.ShortTime) + " " + dt("TicketID").ToString() + "-" + dt("ContactLastName").ToString + "-" + dt("County").ToString + "</a></li>"
                            Else
                                
                                ' htmlCalendar += "<li ><a target='_blank' href='ticket.aspx?id=" & dt("TicketID").ToString & "&act=D'>" + FormatDateTime(dt("scheduledDate"), DateFormat.ShortTime) + " " + dt("TicketID").ToString() + "-" + dt("ContactLastName").ToString + "-" + dt("County").ToString + "</a><img src='/graphics/true1.png' alt='Closed Call' /></li>"
                            
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
        drpYears.Items.Add(2016)
        drpYears.Items.Add(2017)
        drpYears.Items.Add(2018)
        drpYears.Items.Add(2019)
        drpYears.Items.Add(2020)
        drpYears.SelectedValue = Year(Now())
    End Sub
    
    Public Function GetEvent(ByVal currentDate As Integer, ByVal month As Integer, ByVal year As Integer) As System.Data.SqlClient.SqlDataReader
        Dim strChangeLog As String
        Dim str1 As String
        Dim str2 As String
        If drpPartners.SelectedValue = "Choose One" And drpCSRAgents.SelectedValue = "CSR All" Then
            
            Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            Dim cmd As New System.Data.SqlClient.SqlCommand("spGetTicketsScheduled")
            cmd.CommandType = Data.CommandType.StoredProcedure
            
        
            str1 = FormatDateTime(CDate(ProperDateFormat(currentDate, month, year)) + " 00:00:00", DateFormat.GeneralDate)
            str2 = FormatDateTime(CDate(ProperDateFormat(currentDate, month, year)) + " 23:59:00", DateFormat.GeneralDate)
        
            'cmd.Parameters.Add("@PartnerAgentID", Data.SqlDbType.Int).Value = 2368
            cmd.Parameters.Add("@Date1", Data.SqlDbType.DateTime).Value = Convert.ToDateTime(str1)
            cmd.Parameters.Add("@Date2", Data.SqlDbType.DateTime).Value = Convert.ToDateTime(str2)
        
            
            strChangeLog = ""
            cnn.Open()
            cmd.Connection = cnn
            'Dim dtr1 As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        
            Return cmd.ExecuteReader
            cnn.Close()
            
        Else
            If drpCSRAgents.SelectedValue <> "CSR All" And drpPartners.SelectedValue = "Choose One" Then
                LoadPartnersByUserID(drpCSRAgents.SelectedValue)
                
                Dim cnn2 As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                Dim cmd2 As New System.Data.SqlClient.SqlCommand("spGetTicketsScheduledByUserID")
                cmd2.CommandType = Data.CommandType.StoredProcedure
                    
                str1 = FormatDateTime(CDate(ProperDateFormat(currentDate, month, year)) + " 00:00:00", DateFormat.GeneralDate)
                str2 = FormatDateTime(CDate(ProperDateFormat(currentDate, month, year)) + " 23:59:00", DateFormat.GeneralDate)
        
                cmd2.Parameters.Add("@UserID", Data.SqlDbType.Int).Value = CType(drpCSRAgents.SelectedValue, Long)
                cmd2.Parameters.Add("@Date1", Data.SqlDbType.DateTime).Value = Convert.ToDateTime(str1)
                cmd2.Parameters.Add("@Date2", Data.SqlDbType.DateTime).Value = Convert.ToDateTime(str2)
        
                strChangeLog = ""
                cnn2.Open()
                cmd2.Connection = cnn2
                'Dim dtr1 As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        
                Return cmd2.ExecuteReader
            
                cnn2.Close()
                
                
            Else
                If drpCSRAgents.SelectedValue <> "CSR All" And drpPartners.SelectedValue <> "Choose One" Then
                    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                    Dim cmd As New System.Data.SqlClient.SqlCommand("spGetTicketsScheduledByPartnerAgentIDAndUserID")
                    cmd.CommandType = Data.CommandType.StoredProcedure
                    
                    str1 = FormatDateTime(CDate(ProperDateFormat(currentDate, month, year)) + " 00:00:00", DateFormat.GeneralDate)
                    str2 = FormatDateTime(CDate(ProperDateFormat(currentDate, month, year)) + " 23:59:00", DateFormat.GeneralDate)
        
                    cmd.Parameters.Add("@PartnerAgentID", Data.SqlDbType.Int).Value = CType(drpPartners.SelectedValue, Long)
                    cmd.Parameters.Add("@Date1", Data.SqlDbType.DateTime).Value = Convert.ToDateTime(str1)
                    cmd.Parameters.Add("@Date2", Data.SqlDbType.DateTime).Value = Convert.ToDateTime(str2)
                    cmd.Parameters.Add("@UserID", Data.SqlDbType.Int).Value = CType(drpCSRAgents.SelectedValue, Long)
                    strChangeLog = ""
                    cnn.Open()
                    cmd.Connection = cnn
                    'Dim dtr1 As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        
                    Return cmd.ExecuteReader
            
                    cnn.Close()
                Else
                    
                    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                    Dim cmd As New System.Data.SqlClient.SqlCommand("spGetTicketsScheduledByPartnerAgentID")
                    cmd.CommandType = Data.CommandType.StoredProcedure
                    
                    str1 = FormatDateTime(CDate(ProperDateFormat(currentDate, month, year)) + " 00:00:00", DateFormat.GeneralDate)
                    str2 = FormatDateTime(CDate(ProperDateFormat(currentDate, month, year)) + " 23:59:00", DateFormat.GeneralDate)
        
                    cmd.Parameters.Add("@PartnerAgentID", Data.SqlDbType.Int).Value = CType(drpPartners.SelectedValue, Long)
                    cmd.Parameters.Add("@Date1", Data.SqlDbType.DateTime).Value = Convert.ToDateTime(str1)
                    cmd.Parameters.Add("@Date2", Data.SqlDbType.DateTime).Value = Convert.ToDateTime(str2)
                    
                    strChangeLog = ""
                    cnn.Open()
                    cmd.Connection = cnn
                    'Dim dtr1 As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        
                    Return cmd.ExecuteReader
            
                    cnn.Close()
                End If
                
            End If
        End If
        
    End Function

    Private Function ProperDateFormat(ByVal d As Integer, ByVal m As Integer, ByVal y As Integer) As String
        Try
            Dim months() As String = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"}
                     
            Return m.ToString() + "/" + d.ToString() + "/" + y.ToString()
        Catch ex As Exception
            Return ""
        End Try
    End Function
    Private Sub LoadPartners()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        ldr.LoadSimpleDropDownList("spListActivePartnersAgentsWithCalls", "Login", "PartnerAgentID", drpPartners)
        'ldr.LoadSingleLongParameterDropDownList("spListPartnersByTicketFolderID", "@TicketFolderID", _ID, "ResumeID", "PartnerID", drpPartners)
        drpPartners.Items.Add("Choose One")
        drpPartners.SelectedValue = "Choose One"
    End Sub
    Private Sub LoadPartnersByUserID(ByVal lngUserID As Long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        'ldr.LoadSimpleDropDownList("spListActivePartnersAgentsWithCalls", "Login", "PartnerAgentID", drpPartners)
        ldr.LoadSingleLongParameterDropDownList("spListActivePartnersAgentsWithCallsByUserID", "@UserID", lngUserID, "Login", "PartnerAgentID", drpPartners)
        drpPartners.Items.Add("Choose One")
        drpPartners.SelectedValue = "Choose One"
    End Sub
    Private Sub LoadCSRAgents()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        ldr.LoadSimpleDropDownList("spListUsersCallCenter", "UserName", "UserID", drpCSRAgents)
        'ldr.LoadSingleLongParameterDropDownList("spListUsersCallCenter", "@TicketFolderID", 7, "Login", "PartnerID", drpPartners)
        drpCSRAgents.Items.Add("CSR All")
        drpCSRAgents.SelectedValue = "CSR All"
    End Sub
    Protected Sub drpPartners_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        If drpPartners.SelectedValue <> "Choose One" Then
            '' LoadTicketsByPartners(CType(Request.QueryString("id"), Long), CType(drpPartners.SelectedValue, Long))
            'drpCustomers.SelectedValue = "Choose One"
        End If
    End Sub
    Protected Sub drpCSRAgents_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        'If drpPartners.SelectedValue <> "Choose One" Then
        '' LoadTicketsByPartners(CType(Request.QueryString("id"), Long), CType(drpPartners.SelectedValue, Long))
        'drpCustomers.SelectedValue = "Choose One"
        'End If
        If drpCSRAgents.SelectedValue <> "CSR All" Then
            LoadPartnersByUserID(drpCSRAgents.SelectedValue)
        Else
            LoadPartners()
        End If
    End Sub
    
</script>

<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  
    <form id="form1" runat="server">
    <div style="text-align:center;">
        <table class="mainTableFrame">
            <tr>
                <td class="subHeader" style="text-align: center">CSR Agents: <asp:DropDownList ID="drpCSRAgents" runat="server" AutoPostBack="true" OnSelectedIndexChanged="drpCSRAgents_SelectedIndexChanged" /> - Technicians: <asp:DropDownList ID="drpPartners" runat="server" AutoPostBack="true" OnSelectedIndexChanged="drpPartners_SelectedIndexChanged" /> - 
Schedule Calendar - <asp:DropDownList ID="drpMonths" runat="server" AutoPostBack ="True"></asp:DropDownList><asp:DropDownList ID="drpYears" runat="server" AutoPostBack ="True"></asp:DropDownList>                                                                      <asp:label ID="printSchedule" runat="server"></asp:label></td>
            </tr>
            
            <tr>
                <td>
                    <asp:Label ID="lblCalendar" runat="server" Text="Generated Calendar Holder"></asp:Label></td>
            </tr>
        </table>
    </div>
    </form>
</asp:Content> 