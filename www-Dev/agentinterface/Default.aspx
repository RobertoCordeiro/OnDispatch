<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<%@ Import Namespace="LGInterface" %>
<script runat="server">
    
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
        Response.AppendHeader("Refresh", "500")
                              
        If User.Identity.IsAuthenticated Then
            Master.WebLoginID = CType(User.Identity.Name, Long)
            Master.PageHeaderText = "Welcome"
            Master.PageTitleText = "Desktop"
            Master.PageSubHeader = ""
            'lblWelcome.Text = "Welcome " & Master.userName
            Dim usr As New BridgesInterface.UserRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            usr.LoadByWebLoginID(Master.WebLoginID)
            Dim inf As New BridgesInterface.CompanyInfoRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            Dim pta As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            Dim ptn As New BridgesInterface.PartnerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            If usr.UserName <> "" Then
                inf.Load(usr.InfoID)
            Else
                pta.LoadByWebLoginID(Master.WebLoginID)
                ptn.Load(pta.PartnerID)
                inf.Load(ptn.InfoID)
            End If
            
      
            lnkMycompany.Text = "<a target='_blank' href='mycompany.aspx?id=" & inf.CustomerID & "&t=0&infoID=" & inf.InfoID & "'>My Company</a>"
            lnkAccountReceivables.Text = "<a target='_blank' href='accountsreceivables.aspx?id=" & inf.InfoID & "&t=0'>Bill Customers</a>"
            lnkCustomerServiceControl.Text = "<a target='_blank' href='customerservicecontrol.aspx?id=" & inf.CustomerID & "&infoID=" & inf.InfoID & "&t=0&eta=4'>Service Tickets</a>"
            '_InfoID = usr.InfoID
            'CallLGTickets()
            LoadTotalOpenTickets()
            LoadTotalOpenTickets1()
            LoadTotalOpenTickets2()
            LoadTotalOpenTickets3()
            LoadTotalOpenTicketsNT()
            LoadTotalOpenTicketsProcess()
            LoadTotalOpenTicketsNAS()
            LoadTotalOpenTicketsRTS()
            LoadTotalOpenTicketsOPTS()
            LoadTotalOpenTicketsBKOR()
            LoadTotalOpenTicketsAWPTS()
            LoadTotalClosedTickets()
            LoadTotalCancelledTickets()
            LoadTotalOpenTicketsNTT()
            LoadTotalOpenTicketsSCH()
            LoadTotalOpenTicketsMSA()
            
            LoadNewsArticles(inf.InfoID)
            LoadSurveys()
            If (Calendar1.SelectedDate = "#12:00:00 AM#") Then
                LoadDailyProduction(DateTime.Today)
                LoadBlackBookResults()
            End If
        End If
        TrackTraffic()
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
            eml.SendFrom = System.Configuration.ConfigurationManager.AppSettings("TrafficMasterEmail")
            eml.SendTo = System.Configuration.ConfigurationManager.AppSettings("TrafficMasterEmail")
            eml.Subject = "Possible Internal Security Breach!"
            eml.Body = "<p>A user at a flagged IP Address accessed the system, this is a possible security breach!</p>"
            eml.Body &= "<div>Details</div>"
            eml.Body &= "User ID: " & Master.UserID & "<br />"
            eml.Body &= "Web Login ID:" & Master.WebLoginID & "<br />"
            eml.Send()
        End If
    End Sub
    Private Function LoadTotalTickets(ByVal datStartDate As Date, ByVal datEndDate As Date) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spPerformanceStatisticTotalTicketsByInfoID")
        
        Dim lngTotalTickets As Long
        lngTotalTickets = 0
        cmd.Parameters.Add("@InfoID", Data.SqlDbType.Int).Value = Master.InfoID
        cmd.Parameters.Add("@dtStartDate", Data.SqlDbType.DateTime).Value = datStartDate & " 00:00:00"
        cmd.Parameters.Add("@dtEndDate", Data.SqlDbType.VarChar).Value = datEndDate & " 23:59:59"
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            If Not IsDBNull(dtr("TotalTickets")) Then
                lngTotalTickets = dtr("TotalTickets")
            Else
                lngTotalTickets = 0
            End If
        End While
        Return lngTotalTickets
        cnn.Close()
    End Function
    Private Function LoadAvgDaysToClose(ByVal datStartDate As Date, ByVal datEndDate As Date) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spPerformanceStatisticDaysToCloseByInfoID")
        
        Dim lngDaysToClose As Long
        lngDaysToClose = 0
        cmd.Parameters.Add("@InfoID", Data.SqlDbType.Int).Value = Master.InfoID
        cmd.Parameters.Add("@dtStartDate", Data.SqlDbType.DateTime).Value = datStartDate & " 00:00:00"
        cmd.Parameters.Add("@dtEndDate", Data.SqlDbType.VarChar).Value = datEndDate & " 23:59:59"
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            If Not IsDBNull(dtr("AvgAgeToClose")) Then
                lngDaysToClose = dtr("AvgAgeToClose")
            Else
                lngDaysToClose = 0
            End If
        End While
        Return lngDaysToClose
        cnn.Close()
    End Function
        
    Private Function LoadMultipleVisits(ByVal datStartDate As Date, ByVal datEndDate As Date) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spPerformanceStatisticMultipleVisitsByInfoID")
        
        Dim lngMultiVisit As Long
        lngMultiVisit = 0
        cmd.Parameters.Add("@InfoID", Data.SqlDbType.Int).Value = Master.InfoID
        cmd.Parameters.Add("@dtStartDate", Data.SqlDbType.DateTime).Value = datStartDate & " 00:00:00"
        cmd.Parameters.Add("@dtEndDate", Data.SqlDbType.VarChar).Value = datEndDate & " 23:59:59"
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            If Not IsDBNull(dtr("Avarage")) Then
                lngMultiVisit = dtr("Avarage")
            Else
                lngMultiVisit = 0
            End If
        End While
        Return lngMultiVisit
        cnn.Close()
    End Function
    
    
    Private Function LoadRecall(ByVal datStartDate As Date, ByVal datEndDate As Date) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spPerformanceStatisticRecallTicketsByInfoID")
        
        Dim lngTotalRecall As Long
        lngTotalRecall = 0
        cmd.Parameters.Add("@InfoID", Data.SqlDbType.Int).Value = Master.InfoID
        cmd.Parameters.Add("@dtStartDate", Data.SqlDbType.DateTime).Value = datStartDate & " 00:00:00"
        cmd.Parameters.Add("@dtEndDate", Data.SqlDbType.VarChar).Value = datEndDate & " 23:59:59"
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            If Not IsDBNull(dtr("TotalRecall")) Then
                lngTotalRecall = dtr("TotalRecall")
            Else
                lngTotalRecall = 0
            End If
        End While
        Return lngTotalRecall
        cnn.Close()
    End Function
    
    Private Sub LoadNewsArticles(lngInfoID As Long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        
        ldr.LoadSingleLongParameterDataGrid("spListCustomerNewsArticlesByInfoID", "@InfoID", lngInfoID, dgvNews)
        
    End Sub
    
    Private Sub LoadTotalOpenTickets()
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spCountTotalOpenTicketsAllByInfoID")
        
        cmd.Parameters.Add("@InfoID", Data.SqlDbType.Int).Value = Master.InfoID
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            
            lblTotalOpentickets.Text = dtr("Total").ToString
           
        End While
        
        cnn.Close()
    End Sub
    Private Sub LoadTotalOpenTickets1()
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spCountTotalOpenTickets1ByInfoID")
        
        cmd.Parameters.Add("@InfoID", Data.SqlDbType.Int).Value = Master.InfoID
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            
            lblUpto7.Text = dtr("Total1").ToString
           
        End While
        
        cnn.Close()
    End Sub
    Private Sub LoadTotalOpenTickets2()
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spCountTotalOpenTickets2ByInfoID")
        
        cmd.Parameters.Add("@InfoID", Data.SqlDbType.Int).Value = Master.InfoID
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            
            lblFrom8to15.Text = dtr("Total2").ToString
           
        End While
        
        cnn.Close()
    End Sub
    Private Sub LoadTotalOpenTickets3()
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spCountTotalOpenTickets3ByInfoID")
        
        cmd.Parameters.Add("@InfoID", Data.SqlDbType.Int).Value = Master.InfoID
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            
            lblFrom16andOver.Text = dtr("Total3").ToString
           
        End While
        
        cnn.Close()
    End Sub
    
    Private Sub LoadTotalOpenTicketsNT()
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spCountTotalOpenTicketsNTByInfoID")
        
        cmd.Parameters.Add("@InfoID", Data.SqlDbType.Int).Value = Master.InfoID
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            
            lblTotalNT.Text = dtr("TotalNT").ToString
           
        End While
        
        cnn.Close()
    End Sub
    Private Sub LoadTotalOpenTicketsProcess()
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spCountTotalOpenTicketsProcessByInfoID")
        
        cmd.Parameters.Add("@InfoID", Data.SqlDbType.Int).Value = Master.InfoID
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            
            lblTotalInProcess.Text = dtr("TotalProcess").ToString
           
        End While
        
        cnn.Close()
    End Sub
    Private Sub LoadTotalOpenTicketsNAS()
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spCountTotalOpenTicketsNASByInfoID")
        
        cmd.Parameters.Add("@InfoID", Data.SqlDbType.Int).Value = Master.InfoID
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            
            lblTotalNAS.Text = dtr("TotalNAS").ToString
           
        End While
        
        cnn.Close()
    End Sub
    
    Private Sub LoadTotalOpenTicketsRTS()
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spCountTotalOpenTicketsRTSByInfoID")
        
        cmd.Parameters.Add("@InfoID", Data.SqlDbType.Int).Value = Master.InfoID
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            
            lblTotalRTS.Text = dtr("TotalRTS").ToString
           
        End While
        
        cnn.Close()
    End Sub
    
    Private Sub LoadTotalOpenTicketsOPTS()
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spCountTotalOpenTicketsOPTSByInfoID")
        
        cmd.Parameters.Add("@InfoID", Data.SqlDbType.Int).Value = Master.InfoID
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            
            lblTotalOrderingParts.Text = dtr("TotalOrderingParts").ToString
           
        End While
        
        cnn.Close()
    End Sub
    
    Private Sub LoadTotalOpenTicketsAWPTS()
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spCountTotalOpenTicketsAWPTSByInfoID")
        
        cmd.Parameters.Add("@InfoID", Data.SqlDbType.Int).Value = Master.InfoID
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            
            lblTotalAwaitingParts.Text = dtr("TotalAwaitingParts").ToString
           
        End While
        
        cnn.Close()
    End Sub
    
    Private Sub LoadTotalOpenTicketsBKOR()
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spCountTotalOpenTicketsBKORByInfoID")
        
        cmd.Parameters.Add("@InfoID", Data.SqlDbType.Int).Value = Master.InfoID
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            
            lblTotalBackOrder.Text = dtr("TotalBackOrder").ToString
           
        End While
        
        cnn.Close()
    End Sub
    
    Private Sub LoadTotalClosedTickets()
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spCountTotalClosedTicketsByInfoID")
        
        cmd.Parameters.Add("@InfoID", Data.SqlDbType.Int).Value = Master.InfoID
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            
            lblTotalClosed.Text = dtr("TotalClosed").ToString
           
        End While
        
        cnn.Close()
    End Sub
    
    Private Sub LoadTotalCancelledTickets()
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spCountTotalCancelledTicketsByInfoID")
        
        cmd.Parameters.Add("@InfoID", Data.SqlDbType.Int).Value = Master.InfoID
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            
            lblTotalCancelled.Text = dtr("TotalCancelled").ToString
           
        End While
        
        cnn.Close()
    End Sub
    
    Private Sub LoadTotalOpenTicketsNTT()
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spCountTotalOpenTicketsNTTByInfoID")
        
        cmd.Parameters.Add("@InfoID", Data.SqlDbType.Int).Value = Master.InfoID
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            
            lblTotalNewTicketsForToday.Text = dtr("TotalNTT").ToString
           
        End While
        
        cnn.Close()
    End Sub
    
    Private Sub LoadTotalOpenTicketsSCH()
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spCountTotalOpenTicketsSCHByInfoID")
        
        cmd.Parameters.Add("@InfoID", Data.SqlDbType.Int).Value = Master.InfoID
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            
            lblTotalScheduled.Text = dtr("TotalScheduled").ToString
           
        End While
        
        cnn.Close()
    End Sub
    
    Private Sub LoadTotalOpenTicketsMSA()
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spCountTotalOpenTicketsMSAByInfoID")
        
        cmd.Parameters.Add("@InfoID", Data.SqlDbType.Int).Value = Master.InfoID
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            
            lblTotalMissedAppt.Text = dtr("TotalMissedAppt").ToString
           
        End While
        
        cnn.Close()
    End Sub
    
    Private Sub LoadSurveys()
        Dim par As New BridgesInterface.PartnerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim res As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim dtLastMonthFirstDay As Date
        Dim dtLastMonthLastDay As Date
        Dim intLastMonth As Integer
        Dim dtStartdate As Date
        Dim dtEndDate As Date
        Dim intDay As Integer
        Dim intlastday As Integer
        Dim lngTotalRecallTickets As Long
        Dim lngTotal As Long
        Dim lngTotalTicketResults As Long
        Dim lngAverage As Long
        Dim lngMultiVisits As Long
        
        dtLastMonthLastDay = DateTime.Today.AddDays(0 - DateTime.Today.Day)
        dtLastMonthFirstDay = dtLastMonthLastDay.AddDays(1 - dtLastMonthLastDay.Day)
        intLastMonth = (DateTime.Today.Month - 1)
   
        dtStartdate = dtLastMonthFirstDay.Date
        dtEndDate = dtLastMonthLastDay.Date
        intDay = DateTime.Today.Day
        intlastday = Day(DateSerial(Year(Now()), Month(Now()) + 1, 0))
        lblMonth.Text = "From " & dtStartdate & " and " & dtEndDate
        
        lngTotalTicketResults = (LoadTotalTickets(dtStartdate, dtEndDate))
        lblTotalTicketsResults.Text = lngTotalTicketResults
        
        lngAverage = LoadAvgDaysToClose(dtStartdate, dtEndDate)
        lblGoalAvgDTC.Text = lngAverage
        If lngAverage <= 7 Then
            lblDaystoCloseGraph.Text = "<img src='/graphics/green_small.png' id='img1' runat ='server' />"
        Else
            If lngAverage >= 8 And lngAverage <= 10 Then
                lblDaystoCloseGraph.Text = "<img src='/graphics/Yellow_small.png' id='img1' runat ='server' />"
            Else
                If lngAverage <> 0 Then
                    lblDaystoCloseGraph.Text = "<img src='/graphics/red_small.png' id='img1' runat ='server' />"
                Else
                    'lblDaystoCloseGraph.Text = "<img src='/images/1_w3.gif' id='img1' runat ='server' width='10'/>"
                End If
            End If
        End If
        
        lngMultiVisits = LoadMultipleVisits(dtStartdate, dtEndDate)
        lblMultiVisitResults.Text = lngMultiVisits & " %"
        
        If lngMultiVisits <= 5 Then
            lblMultipleVisitsToClose.Text = "<img src='/graphics/green_small.png' id='img1' runat ='server' />"
        Else
            If lngMultiVisits >= 6 And lngMultiVisits <= 8 Then
                lblMultipleVisitsToClose.Text = "<img src='/graphics/Yellow_small.png' id='img1' runat ='server' />"
            Else
                If lngMultiVisits <> 0 Then
                    lblMultipleVisitsToClose.Text = "<img src='/graphics/red_small.png' id='img1' runat ='server' />"
                Else
                    'lblMultipleVisitsToClose.Text = "<img src='/images/1_w3.gif' id='img1' runat ='server' width='10'/>"
                End If
            End If
        End If
        
        lngTotalRecallTickets = LoadRecall(dtStartdate, dtEndDate)
        If CType(lblTotalTicketsResults.Text, Long) > 0 Then
            lngTotal = (lngTotalRecallTickets * 100) / CType(lblTotalTicketsResults.Text, Long)
        Else
            lngTotal = 0
        End If
        lblRecall.Text = lngTotal & " %"
        If lngTotal <= 5 Then
            lblTotalRecall.Text = "<img src='/graphics/green_small.png' id='img1' runat ='server' />"
        Else
            If lngTotal >= 6 And lngTotal <= 8 Then
                lblTotalRecall.Text = "<img src='/graphics/Yellow_small.png' id='img1' runat ='server' />"
            Else
                If lngTotal <> 0 Then
                    lblTotalRecall.Text = "<img src='/graphics/red_small.png' id='img1' runat ='server' />"
                Else
                    'lblTotalRecall.Text = "<img src='/images/1_w3.gif' id='img1' runat ='server' width='10'/>"
                End If
            End If
        End If
        
    End Sub
    
    Private Sub LoadDailyProduction(ByVal datDate As DateTime)
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        
        'ldr.LoadSingleDateParameterDataGrid("spCountDailyProduction", "@datDate", datDate, dgvProduction)
        ldr.LoadLongDateParameterDataGrid("spCountDailyProduction", "@InfoID", Master.InfoID, "@datDate", datDate, dgvProduction)
    End Sub
    Private Sub LoadBlackBookResults()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        
        'ldr.LoadSimpleDataGrid("spGetBlackBookResults",dgvBlackBook)
        ldr.LoadSingleLongParameterDataGrid("spGetBlackBookResultsByInfoID", "@InfoID", Master.InfoID, dgvBlackBook)
    End Sub
    Protected Sub Calendar1_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        LoadDailyProduction(Calendar1.SelectedDate)
        
    End Sub
    'Private Sub CallLGTickets()
    '    Dim objLG As New LG(Master.UserID)
    '    objLG.getNewDispatchList(Master.UserID, Master.WebLoginID)
    'End Sub
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
<form id="frmMain" runat="server">
     <table style="width: 100%">
      <tbody>
        <tr>
          <td style="width: 5%" class="inputform" >
            <div class="inputformsectionheader">Powered By</div>
              <img src="../images/onDispatch_Logo1.jpg" alt="logo" width="170" height="100" />
            
            <div ></div>
             <table  width="100%" cellspacing ="0"  >
                <tr>
                    <td colspan="3" class="inputformsectionheader" ><div  style="text-align:center;">Aging Tickets</div></td>
                </tr>
                <tr >
                    <td class="bodytable1" >
                    <div ><a target="_blank" href="customerservicecontrol.aspx?id=1&infoID=1&t=0&eta=4">Total Open Tickets:</a></div>
                    </td>
                                  
                    <td align="right" class="bodytable1" style="text-align:center; width:90px;">
                    <div><asp:Label ID="lblTotalOpentickets" runat ="server"></asp:Label></div>
                    </td>
                </tr>
                <tr>
                    <td class="bodytable1">
                    <div><a target="_blank" href="CustomerServiceControl.aspx?id=30&infoID=1&eta=1&CustID=0&ProgID=0&StatusID=0&StateID=0&NP=False&C=0">From 0 to 7 Days:</a></div>
                    </td>
                                  
                    <td align="right" class="bodytable1" style="text-align:center; width:90px;">
                        <div><asp:Label ID="lblUpto7" runat="server"></asp:Label></div>
                    </td>
                </tr>
                <tr>
                    <td class="bodytable1">
                        <div><a target="_blank" href="CustomerServiceControl.aspx?id=30&infoID=1&eta=2&CustID=0&ProgID=0&StatusID=0&StateID=0&NP=False&C=0" >From 8 to 15 Days:</a></div>
                    </td>
                                 
                    <td align="right" class="bodytable1" style="text-align:center; width:90px;">
                        <div><asp:Label ID="lblFrom8to15" runat="server"></asp:Label></div>
                    </td>
                </tr>
                <tr>
                    <td class="bodytable1">
                        <div><a target="_blank" href="CustomerServiceControl.aspx?id=30&infoID=1&eta=3&CustID=0&ProgID=0&StatusID=0&StateID=0&NP=False&C=0">From 16 and Over:</a></div>
                    </td>
                                  
                    <td class="bodytable1" style="text-align:center; width:90px;">
                        <div><asp:Label ID="lblFrom16andOver" runat="server"></asp:Label></div>
                    </td>
                </tr>
            </table>
              <table  width="100%" cellspacing ="0" >
                <tr>
                    <td colspan="3" class="inputformsectionheader" ><div  style="text-align:center;">Ticket Status</div></td>
                </tr>
                <tr >
                    <td class="bodytable1" >
                    <div><a target="_blank" href="CustomerServiceControl.aspx?id=30&infoID=1&eta=4&CustID=0&ProgID=0&StatusID=1&StateID=0&NP=False&parid=0&C=1&UserID=0" >New Tickets (<asp:label ID="lblTotalNewTicketsForToday" runat="server"></asp:label>):</a></div>
                    </td>
                                  
                    <td align="right" class="bodytable1" style="text-align:center; width:90px;">
                    <div><asp:Label ID="lblTotalNT" runat ="server"></asp:Label></div>
                    </td>
                </tr>
                <tr>
                    <td class="bodytable1">
                    <div><a target="_blank" href="CustomerServiceControl.aspx?id=30&infoID=1&eta=4&CustID=0&ProgID=0&StatusID=5&StateID=0&NP=False&parid=0&C=1&UserID=0">In Process:</a></div>
                    </td>
                                  
                    <td align="right" class="bodytable1" style="text-align:center; width:90px;">
                        <div><asp:Label ID="lblTotalInProcess" runat="server"></asp:Label></div>
                    </td>
                </tr>
                <tr>
                    <td class="bodytable1">
                        <div><a target="_blank" href="customerservicecontrol.aspx?id=30&infoID=1&t=0&eta=7">Need Appt Set:</a></div>
                    </td>
                                 
                    <td align="right" class="bodytable1" style="text-align:center; width:90px;">
                        <div><asp:Label ID="lblTotalNAS" runat="server"></asp:Label></div>
                    </td>
                </tr>
                <tr>
                    <td class="bodytable1">
                        <div><a target="_blank" href="customerservicecontrol.aspx?id=30&infoID=1&t=0&eta=7">Ready To Service:</a></div>
                    </td>
                                  
                    <td class="bodytable1" style="text-align:center; width:90px; " >
                        <div><asp:Label ID="lblTotalRTS" runat="server"></asp:Label></div>
                    </td>
                </tr>
                <tr>
                    <td class="bodytable1">
                        <div>Scheduled:</div>
                    </td>
                                  
                    <td class="bodytable1" style="text-align:center; width:90px; " >
                        <div><asp:Label ID="lblTotalScheduled" runat="server"></asp:Label></div>
                    </td>
                </tr>
                <tr>
                    <td class="bodytable1">
                        <div><a target="_blank" href="CustomerServiceControl.aspx?id=1&infoID=1&eta=5&CustID=0&ProgID=0&StatusID=0&StateID=0&NP=False&C=0&UserID=0">Missed Appt:</a></div>
                    </td>
                                  
                    <td class="bodytable1" style="text-align:center; width:90px; " >
                        <div><asp:Label ID="lblTotalMissedAppt" runat="server"></asp:Label></div>
                    </td>
                </tr>
                   <tr>
                    <td class="bodytable1">
                        <div>Closed Repaired:</div>
                    </td>
                                  
                    <td class="bodytable1" style="text-align:center; width:90px;">
                        <div><asp:Label ID="lblTotalClosed" runat="server"></asp:Label></div>
                    </td>
                </tr>
 
                  <tr>
                    <td class="bodytable1">
                        <div>Cancelled:</div>
                    </td>
                                  
                    <td class="bodytable1" style="text-align:center; width:90px;">
                        <div><asp:Label ID="lblTotalCancelled" runat="server"></asp:Label></div>
                    </td>
                </tr>
            </table>
             <table  width="100%" cellspacing ="0" >
                <tr>
                    <td colspan="3" class="inputformsectionheader" ><div  style="text-align:center;">Parts</div></td>
                </tr>
                <tr >
                    <td class="bodytable1" >
                    <div><a target="_blank" href="PartsManagementTeam.aspx">Ordering Parts:</a></div>
                    </td>
                                  
                    <td align="right" class="bodytable1" style="text-align:center; width:90px;">
                    <div><asp:Label ID="lblTotalOrderingParts" runat ="server"></asp:Label></div>
                    </td>
                </tr>
                <tr>
                    <td class="bodytable1">
                    <div><a target="_blank" href="PartsManagementTeam.aspx">Awaiting Parts:</a></div>
                    </td>
                                  
                    <td align="right" class="bodytable1" style="text-align:center; width:90px;">
                        <div><asp:Label ID="lblTotalAwaitingParts" runat="server"></asp:Label></div>
                    </td>
                </tr>
                <tr>
                    <td class="bodytable1">
                        <div><a target="_blank" href="PartsManagementTeam.aspx">Back Order:</a></div>
                    </td>
                                 
                    <td align="right" class="bodytable1" style="text-align:center; width:90px;">
                        <div><asp:Label ID="lblTotalBackOrder" runat="server"></asp:Label></div>
                    </td>
                </tr>
            </table>
             <table width ="100%" cellspacing ="0" >
                <tr>
                    <td colspan="4" class="inputformsectionheader" ><div  style="text-align:center;">Company Performance</div></td>
                </tr>
                 <tr>
                     <td class="bodytable1" colspan="4"><div  style="text-align: center; "><asp:Label ID="lblMonth" runat ="server" /> - <asp:Label ID="lblTickets" runat ="server" Text="Tickets: " /> <asp:Label ID="lblTotalTicketsResults" runat ="server" /></div></td>
                 </tr>
                <tr  >
                    <td class="bodytable1" style="vertical-align:middle;text-align: center; " ><asp:Label ID="lblStatistics" runat ="server"  /></td>
                                  
                    <td class="bodytable1" style="text-align:center;" ><asp:Label ID="lblGoal" runat ="server" Text="Goal" /></td>
                    <td class="bodytable1" style="text-align:center;" ><asp:Label ID="lblResults" runat ="server" Text="Results" /></td>
                    <td class="bodytable1" style="text-align:center;" ><asp:Label ID="lblPicture" runat ="server" Text="Graph" /></td>
                </tr>
                <tr>
                    <td class="bodytable1" style="vertical-align:middle;" ><asp:Label ID="lblDaystoClose" runat ="server" Text="DClose " /> </td>
                                  
                    <td  class="bodytable1" style="vertical-align:middle; font-size: small;text-align: center;"><asp:Label ID="lblGoalDaysToClose" runat ="server" Text="< 7" /></td>
                    <td  class="bodytable1" style="vertical-align:middle; font-size: small;text-align: center;"><asp:Label ID="lblGoalAvgDTC" runat ="server" Text="6%" /></td> 
                    <td  class="bodytable1" style="vertical-align: bottom; text-align: center;"><asp:Label ID="lblDaystoCloseGraph" runat="server"  /></td> 
                </tr>
                <tr>
                    <td class="bodytable1" style="vertical-align:middle;" ><asp:Label ID="lblMultipleVisits" runat ="server" Text="Visits" /></td>
                                  
                    <td class="bodytable1" style="vertical-align:middle;font-size: small;text-align: center;"><asp:Label ID="Label9" runat ="server" Text="<5%"/></td>
                    <td class="bodytable1" style="vertical-align:middle;font-size: small;text-align: center;"><asp:Label ID="lblMultiVisitResults" runat ="server" Text="30%" /></td> 
                    <td class="bodytable1" style="vertical-align:middle;text-align: center;"><asp:Label ID="lblMultipleVisitsToClose" runat="server"  /></td>  
                </tr>
                <tr>
                    <td class="bodytable1" style="vertical-align:middle;" ><asp:Label ID="lblRecallTickets" runat ="server" Text="Recall" /></td>
                                  
                    <td class="bodytable1" style="vertical-align:middle;font-size: small;text-align: center;"><asp:Label ID="Label10" runat ="server" Text="<5%"  /></td>
                    <td class="bodytable1" style="vertical-align:middle;font-size: small;text-align: center;"><asp:Label ID="lblRecall" runat ="server" Text="10%" /></td>
                    <td class="bodytable1" style="vertical-align:middle;text-align: center;text-align: center;"><asp:Label ID="lblTotalRecall" runat="server"  /></td>  
                </tr>

            </table>
          </td>
          <td>
              <table width ="100%"  cellspacing ="0" >
                   <tr>
                     <td >
                           <table width ="100%" cellspacing ="0" >
                               <tr>
                                    <td width="50%">
                                    <div id="main" >
                                      <ul id="mainmenu">
                                          <li ><a href="#" class="first" >Applications &raquo;</a>
                                            <ul>
                                                <li ><asp:Label ID="lnkMycompany" runat ="server"></asp:Label></li>
                                                <li ><a target="_blank" href="customers.aspx" >Customers</a></li>
                                                <li><a target="_blank" href="partners.aspx">Partners</a></li>
                                                <li><a href="#">Recruitment &raquo;</a>
                                                  <ul>
                                                      <li><a target="_blank" href="recruit.aspx">Add Candidate</a></li>
                                                      <li><a target="_blank" href="recruit.aspx">Recruit Console</a></li>
                                                  </ul></li>
                                            </ul></li>
                                          <li><a href="#">Service Administration &raquo;</a>
                                             <ul>
                                                 <li><a target="_blank" href="">Add Tickets &raquo;</a>
                                                     <ul>
                                                         <li><a target="_blank" href="../RequestService.aspx">Out of Warranty</a></li>
                                                         <li><a target="_blank" href="AddTicketChooseCustomer.aspx?returnurl='default.aspx'">Under Contract</a></li>
                                                     </ul>
                                                 </li> 
                                                 <li><asp:Label ID="lnkCustomerServiceControl" runat ="server"></asp:Label></li>
                                                 <li><a target="_blank" href="/FieldTechnicians/default.aspx">Technician Access</a></li>
                                                 <li><a target="_blank" href="PartsManagementTeam.aspx">Parts &raquo;</a>
                                                     <ul>
                                                         <li><a target="_blank" href="PartsManagementTeam.aspx">Order Parts</a></li>
                                                         <li><a target="_blank" href="ReturnLabels.aspx">Return Lables</a></li>
                                                         <li><a target="_blank" href="PartsManagementTeam.aspx">Inventory</a></li>
                                                     </ul>
                                                 </li> 
                                                 <li><a target="_blank" href="tickets.aspx">Management</a></li>                                               
                                             </ul></li>
                                          <li><a href="#">Billing &raquo;</a>
                                              <ul>
                                                  <li><asp:Label ID="lnkAccountReceivables" runat ="server"></asp:Label></li>
                                                  <li><a target="_blank" href="RecordPayments.aspx">Record Payments/Credits</a></li>
                                                  <li><a target="_blank" href="payvendors.aspx">Pay Employees</a></li>
                                                  <li><a target="_blank" href="paysuppliers.aspx">Pay Suppliers</a></li>
                                                  <li><a target="_blank" href="payvendors.aspx">Pay Partners</a></li>
                                                  <li><a target="_blank" href="ClientServices.aspx">Pay Sales Commission</a></li>
                                              </ul></li>
                                          <li><a href="#">Tools &raquo; </a>
                                              <ul>
                                                  <li><a target="_blank" href="newsarticles.aspx">News</a></li>
                                                   <li><a target="_blank" href="settings.aspx">Settings</a></li>
                                                  <li><a target="_blank" href="/phonesystem/default.aspx">Download Phone Software</a></li>
                                                  <li><a target="_blank" href="/LG/default.aspx">Download LG tickets</a></li>
                                              </ul></li>
                                          <li><a href="#" class="last">Help &raquo;</a>
                                            <ul>
                                                <li><a target="_blank" href="faqs.aspx">FAQs</a></li>
                                                <li><a target="_blank" href="TrainingVideo.aspx">Training Videos</a></li>
                                                <li><a target="_blank" href="TrainingVideo.aspx">Training Manuals</a></li>
                                                <li><a target="_blank"  href="chat.aspx">Live Chat</a></li>
                                            </ul></li>
                                      </ul>
                                    <img style="border: 0" alt="Guide" width="100%" src="/images/needhelp1.jpg" />
                                        </div>
                                  </td>
                              </tr>
                              <tr>
                                  <td   >
                                  <div class="inputformsectionheader" style="text-align:center; width:100%;">Latest News</div>
                                      <div id="divNews" runat="server" >
                                          <asp:DataGrid ShowHeader="true" style="width: 100%" ID="dgvNews" runat="server" AutoGenerateColumns="false" CssClass="Grid" >
                                          <AlternatingItemStyle CssClass="GridAltItem" />
                                              <ItemStyle CssClass="GridItem" />
                                           <HeaderStyle CssClass="GridHeader" />  
                                          <Columns>
                                              <asp:BoundColumn DataField="NewsArticleID" HeaderText="ID" Visible="false" />
                                            <asp:TemplateColumn HeaderText ="Date" Visible="true">
                                              <ItemTemplate>
                                                <%# FormatDateTime(DataBinder.Eval(Container.DataItem, "DateCreated"), DateFormat.ShortDate)%>
                                              </ItemTemplate>
                                            </asp:TemplateColumn>  
                                            <asp:TemplateColumn HeaderText ="Subject">
                                              <ItemTemplate>
                                                <%# DataBinder.Eval(Container.DataItem, "ArticleSubject")%>&nbsp;&nbsp;<a target="_blank" href="NewsArticlePreview.aspx?id=<%# DataBinder.Eval(Container.DataItem,"NewsArticleID") %>">More Information...</a>
                                              </ItemTemplate>
                                            </asp:TemplateColumn> 
 
                                          </Columns>
                                        </asp:DataGrid>
                                      </div>
                                      <div></div>
                              </td>
                               </tr>
                            </table>
                      </td>
                      
                   </tr>
                  
              </table>
          </td>
          <td  style="width: 5%" class="inputform" rowspan ="2">
                        <div class="inputformsectionheader">Reminder</div>
                           <asp:Calendar ID="Calendar1" runat="server" BackColor="white" BorderColor="#999999" DayNameFormat="Shortest" Font-Names="Verdana" Font-Size="8pt" ForeColor="Black" Height="180px" Width="180px" OnSelectionChanged="Calendar1_SelectionChanged" >
                               <SelectedDayStyle BackColor="#666666" Font-Bold="True" ForeColor="White" />
                               <SelectorStyle BackColor="#CCCCCC" />
                               <WeekendDayStyle BackColor="#FFFFCC" />
                               <TodayDayStyle BackColor="#CCCCCC" ForeColor="Black" />
                               <OtherMonthDayStyle ForeColor="#808080" />
                               <NextPrevStyle VerticalAlign="Bottom" />
                               <DayHeaderStyle BackColor="#CCCCCC" Font-Bold="True" Font-Size="7pt" />
                               <TitleStyle BackColor="#999999" BorderColor="Black" Font-Bold="True" />
                            </asp:Calendar>
                        <div class="inputformsectionheader">Daily Production ( Min/Tkt )</div>
                        <div class="bodytable1">
                         <table  width="100%" cellspacing ="0" >
                            <tr >
                               <td>
                                  <asp:DataGrid ID="dgvProduction" runat="server" AutoGenerateColumns="false" style="width: 100%; background-color: White;" ShowFooter = "false" ShowHeader = "false"  Cssclass="Grid1" >
                                   
                                  <HeaderStyle CssClass="gridheader" />
                                  <AlternatingItemStyle CssClass="altrow" />
                                  <Columns>      
                                    <asp:BoundColumn DataField="UserName" HeaderText="Agent" />
                                    <asp:BoundColumn DataField="Average" HeaderText="Avg/min" />
                                  </Columns> 
                                 </asp:DataGrid>
                               </td>
                            </tr>
                         </table>
                         </div>
                         <div class="inputformsectionheader">Black Book Results</div>
                        <div class="bodytable1">
                         <table  width="100%" cellspacing ="0" >
                            <tr >
                               <td>
                                  <asp:DataGrid ID="dgvBlackBook" runat="server" AutoGenerateColumns="false" style="width: 100%; background-color: White;" ShowFooter = "false" ShowHeader = "false"  Cssclass="Grid1" >
                                   
                                  <HeaderStyle CssClass="gridheader" />
                                  <AlternatingItemStyle CssClass="altrow" />
                                  <Columns>      
                                    <asp:BoundColumn DataField="BlackBookTypeID" HeaderText="ID" Visible="false" />
                                    <asp:BoundColumn DataField="BlackBookType" HeaderText="Type" />
                                    <asp:BoundColumn DataField="Total" HeaderText="Total" />
                                  </Columns> 
                                 </asp:DataGrid>
                               </td>
                            </tr>
                         </table>
                         </div>
                         <div class="inputformsectionheader">Product Support</div>
                          <div class="bodytable1"><img style="border: 0" alt="Guide"  src="/graphics/phone.png" />
                          <div >1.800.245.0215</div>
                          <div><img style="border: 0" alt="Guide"  src="/graphics/email.png" /></div>
                          <div >support@ondispatch.com</div>
                          <div><img style="border: 0" alt="Guide"  src="/graphics/chat.png" /></div>
                          <div >Live Chat</div>  
                          <div style="text-align: right;"></div></div>
                      </td>
        </tr>
      </tbody>
    </table>
</form>
</asp:Content>