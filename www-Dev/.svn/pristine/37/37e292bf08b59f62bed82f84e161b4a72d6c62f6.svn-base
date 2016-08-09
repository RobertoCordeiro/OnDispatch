<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
    
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)

    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
            Master.PageHeaderText = "Welcome"
            Master.PageTitleText = "Desktop"
            Master.PageSubHeader = ""
            'lblWelcome.Text = "Welcome " & Master.userName
            Dim usr As New BridgesInterface.UserRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            usr.LoadByWebLoginID(Master.WebLoginID)
            Dim inf As New BridgesInterface.CompanyInfoRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            inf.Load(usr.InfoID)
      
            lnkMycompany.Text = "<a href='mycompany.aspx?id=" & inf.CustomerID & "&t=0&infoID=" & inf.InfoID & "'>My Company</a>"
            lnkAccountReceivables.Text = "<a href='accountsreceivables.aspx?id=" & inf.InfoID & "&t=0'>Bill Customers</a>"
            lnkCustomerServiceControl.Text = "<a href='customerservicecontrol.aspx?id=" & inf.CustomerID & "&infoID=" & inf.InfoID & "&t=0&eta=4'>Service Tickets</a>"
            '_InfoID = usr.InfoID
            LoadSurveys()
            LoadTotalOpenTickets()
            LoadNewsArticles(inf.InfoID)
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
        'lblMonth.Text = "From " & dtStartdate & " and " & dtEndDate
        
        lngTotalTicketResults = (LoadTotalTickets(dtStartdate, dtEndDate))
        lblTotalTicketsResults.Text = lngTotalTicketResults
        
        lngAverage = LoadAvgDaysToClose(dtStartdate, dtEndDate)
        lblGoalAvgDTC.Text = lngAverage
        If lngAverage <= 7 Then
            lblDaystoCloseGraph.Text = "<img src='/graphics/green.jpg' id='img1' runat ='server' height='50' width='60'/>"
        Else
            If lngAverage >= 8 And lngAverage <= 10 Then
                lblDaystoCloseGraph.Text = "<img src='/graphics/yellow.jpg' id='img1' runat ='server' height='50' width='60'/>"
            Else
                If lngAverage <> 0 Then
                    lblDaystoCloseGraph.Text = "<img src='/graphics/red.jpg' id='img1' runat ='server' height='50' width='60'/>"
                Else
                    'lblDaystoCloseGraph.Text = "<img src='/images/1_w3.gif' id='img1' runat ='server' width='10'/>"
                End If
            End If
        End If
        
        lngMultiVisits = LoadMultipleVisits(dtStartdate, dtEndDate)
        lblMultiVisitResults.Text = lngMultiVisits & " %"
        
        If lngMultiVisits <= 5 Then
            lblMultipleVisitsToClose.Text = "<img src='/graphics/green.jpg' id='img1' runat ='server' height='50' width='60'/>"
        Else
            If lngMultiVisits >= 6 And lngMultiVisits <= 8 Then
                lblMultipleVisitsToClose.Text = "<img src='/graphics/yellow.jpg' id='img1' runat ='server' height='50' width='60'/>"
            Else
                If lngMultiVisits <> 0 Then
                    lblMultipleVisitsToClose.Text = "<img src='/graphics/red.jpg' id='img1' runat ='server' height='50' width='60'/>"
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
            lblTotalRecall.Text = "<img src='/graphics/green.jpg' id='img1' runat ='server' height='50' width='60'/>"
        Else
            If lngTotal >= 6 And lngTotal <= 8 Then
                lblTotalRecall.Text = "<img src='/graphics/yellow.jpg' id='img1' runat ='server' height='50' width='60'/>"
            Else
                If lngTotal <> 0 Then
                    lblTotalRecall.Text = "<img src='/graphics/red.jpg' id='img1' runat ='server' height='50' width='60'/>"
                Else
                    'lblTotalRecall.Text = "<img src='/images/1_w3.gif' id='img1' runat ='server' width='10'/>"
                End If
            End If
        End If
        
    End Sub
    Private Sub LoadNewsArticles(lngInfoID As Long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        
        ldr.LoadSingleLongParameterDataGrid("spListCustomerNewsArticlesByInfoID", "@InfoID", lngInfoID, dgvNews)
        
    End Sub
    
    Private Sub LoadTotalOpenTickets()
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spCountTotalOpenTickets")
        
             
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            
            lblTotalOpentickets.Text = dtr("Total").ToString
            lblUpto7.Text = dtr("Total1").ToString 
            lblFrom8to15.Text = dtr("Total2").ToString
            lblFrom16andOver.Text = dtr("Total3").ToString
        End While
        
        cnn.Close()
    End Sub
    Protected Sub Calendar1_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        
        
    End Sub
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
<form id="frmMain" runat="server">
     <table style="width: 100%">
      <tbody>
        <tr>
          <td  style="width: 5%" class="inputform">
            <div class="inputformsectionheader">Powered By</div>
              <img src="../images/onDispatch_Logo1.jpg" alt="logo" width="150" height="100" />
            <div class="inputformsectionheader">Menu</div>
            <div ></div>
             <dl>
              <dt><asp:Label ID="lnkMycompany" runat ="server"></asp:Label></dt>
              <dt><a href="customers.aspx">Customers</a></dt>
              <dt><a href="partners.aspx">Vendors</a></dt>
              <dt><a href="PartsManagementTeam.aspx">Parts</a></dt>
              <dt><a href="ClientServices.aspx">Sales</a></dt>
              <dt><a href="recruit.aspx">Recruitment</a></dt>
              <dt><asp:Label ID="lnkAccountReceivables" runat ="server"></asp:Label></dt>
              <dt><asp:Label ID="lnkCustomerServiceControl" runat ="server"></asp:Label></dt>
              <dt><a href="recruit.aspx">Pay Vendors</a></dt>
              <dt><a href="VendorAdministrationControl.aspx">Technicians Access</a></dt>
              <dt><a href="PartsManagementTeam.aspx">Parts</a></dt>
              <dt><a href="ClientServices.aspx">Sales</a></dt>
            </dl>
             <div class="inputformsectionheader">Product Support</div>
              <div class="label">&nbsp;</div>
              <div class="label">1.800.245.0215</div>
              <div >support@ondispatch.com</div>
              <div >Live Chat</div>  
              <div style="text-align: right;"></div>
          </td>
          <td>
              <table width ="100%"  cellspacing ="0" >
                   <tr>
                     <td class="inputform">
                        <div class="inputformsectionheader" style="text-align:center;">Company Performance</div>
                        <div>&nbsp;</div>
                            <div  style="text-align: center; font-size: large;"><asp:Label ID="lblPerformanceVendor" runat ="server" /></div>
                              <div  style="text-align: center; "><asp:Label ID="lblMonth" runat ="server" /> - <asp:Label ID="lblTickets" runat ="server" Text="Tickets: " /> <asp:Label ID="lblTotalTicketsResults" runat ="server" /></div>
                          <div>&nbsp;</div>    
                          <table width ="100%" cellspacing ="0" >
                                <tr  >
                                  <td class="datacell1" style="vertical-align:middle;text-align: center; " ><asp:Label ID="lblStatistics" runat ="server" Text="Statistics: " /></td>
                                  
                                  <td class="datacell1" style="text-align:center;" ><asp:Label ID="lblGoal" runat ="server" Text="Goal" /></td>
                                  <td class="datacell1" style="text-align:center;" ><asp:Label ID="lblResults" runat ="server" Text="Results" /></td>
                                  <td class="datacell1" style="text-align:center;" ><asp:Label ID="lblPicture" runat ="server" Text="Graph" /></td>
                                </tr>
                                <tr>
                                  <td class="datacell2" style="vertical-align:middle;" >&nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID="lblDaystoClose" runat ="server" Text="Avg Days to Close " /> </td>
                                  
                                  <td  class="datacell2" style="vertical-align:middle; font-size: large;text-align: center;"><asp:Label ID="lblGoalDaysToClose" runat ="server" Text="< 7" /></td>
                                  <td  class="datacell2" style="vertical-align:middle; font-size: large;text-align: center;"><asp:Label ID="lblGoalAvgDTC" runat ="server" Text="6%" /></td> 
                                  <td  class="datacell2" style="vertical-align: bottom; text-align: center;"><asp:Label ID="lblDaystoCloseGraph" runat="server"  /></td> 
                                </tr>
                                <tr>
                                  <td class="datacell2" style="vertical-align:middle;" >&nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID="lblMultipleVisits" runat ="server" Text="Multiple Visits " /></td>
                                  
                                  <td class="datacell2" style="vertical-align:middle;font-size: large;text-align: center;"><asp:Label ID="Label2" runat ="server" Text="< 5%"/></td>
                                  <td class="datacell2" style="vertical-align:middle;font-size: large;text-align: center;"><asp:Label ID="lblMultiVisitResults" runat ="server" Text="30%" /></td> 
                                  <td class="datacell2" style="vertical-align:middle;text-align: center;"><asp:Label ID="lblMultipleVisitsToClose" runat="server"  /></td>  
                                </tr>
                                <tr>
                                  <td class="datacell2" style="vertical-align:middle;" >&nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID="lblRecallTickets" runat ="server" Text="Recall Tickets " /></td>
                                  
                                  <td class="datacell2" style="vertical-align:middle;font-size: large;text-align: center;"><asp:Label ID="Label3" runat ="server" Text="< 5%"  /></td>
                                  <td class="datacell2" style="vertical-align:middle;font-size: large;text-align: center;"><asp:Label ID="lblRecall" runat ="server" Text="10%" /></td>
                                  <td class="datacell2" style="vertical-align:middle;text-align: center;text-align: center;"><asp:Label ID="lblTotalRecall" runat="server"  /></td>  
                                </tr>
                              <tr>
                                  <td >
                                      <table  width="100%" cellspacing ="0" >
                                       <tr>
                                          <td colspan="3" class="datacell1" ><div  style="text-align:center;">Aging Tickets</div></td>
                                      </tr>
                                      <tr >
                                         <td class="bodytable1" >
                                            <div>Total Open Tickets:</div>
                                         </td>
                                  
                                         <td align="right" class="bodytable1" style="text-align:center;">
                                            <div><asp:Label ID="lblTotalOpentickets" runat ="server"></asp:Label></div>
                                         </td>
                                      </tr>
                                      <tr>
                                         <td class="bodytable1">
                                           <div>From 0 to 7 Days:</div>
                                         </td>
                                  
                                         <td align="right" class="bodytable1" style="text-align:center;">
                                             <div><asp:Label ID="lblUpto7" runat="server"></asp:Label></div>
                                         </td>
                                      </tr>
                                      <tr>
                                         <td class="bodytable1">
                                             <div>From 8 to 15 Days:</div>
                                         </td>
                                 
                                         <td align="right" class="bodytable1" style="text-align:center;">
                                             <div><asp:Label ID="lblFrom8to15" runat="server"></asp:Label></div>
                                         </td>
                                      </tr>
                                      <tr>
                                         <td class="bodytable1">
                                             <div>From 16 and Over:</div>
                                         </td>
                                  
                                          <td class="bodytable1" style="text-align:center;">
                                             <div><asp:Label ID="lblFrom16andOver" runat="server"></asp:Label></div>
                                         </td>
                                      </tr>
                                  </table>
                                 </td>
                                  <td>
                                      <table  width="100%" cellspacing ="0">
                                       <tr>
                                          <td colspan="3"><div class="datacell1" style="text-align:center;">Service Tickets</div></td>
                                      </tr>
                                      <tr >
                                         <td class="bodytable1" >
                                            <div>Total Open Tickets:</div>
                                         </td>
                                  
                                         <td align="right" class="bodytable1" style="text-align:center;">
                                            <div><asp:Label ID="Label1" runat ="server"></asp:Label></div>
                                         </td>
                                      </tr>
                                      <tr>
                                         <td class="bodytable1">
                                           <div>From 0 to 7 Days:</div>
                                         </td>
                                  
                                         <td align="right" class="bodytable1" style="text-align:center;">
                                             <div><asp:Label ID="Label4" runat="server"></asp:Label></div>
                                         </td>
                                      </tr>
                                      <tr>
                                         <td class="bodytable1">
                                             <div>From 8 to 15 Days:</div>
                                         </td>
                                 
                                         <td align="right" class="bodytable" style="text-align:center;">
                                             <div><asp:Label ID="Label5" runat="server"></asp:Label></div>
                                         </td>
                                      </tr>
                                      <tr>
                                         <td class="bodytable1">
                                             <div>From 16 and Over:</div>
                                         </td>
                                  
                                          <td class="bodytable1" style="text-align:center;">
                                             <div><asp:Label ID="Label6" runat="server"></asp:Label></div>
                                         </td>
                                      </tr>
                                  </table>
                                  </td>
                                  <td>
                                      <table  width="100%" cellspacing ="0">
                                       <tr>
                                          <td colspan="3"><div class="datacell1" style="text-align:center;">Parts </div></td>
                                      </tr>
                                      <tr >
                                         <td class="bodytable1" >
                                            <div>Total Open Tickets:</div>
                                         </td>
                                  
                                         <td align="right" class="bodytable1" style="text-align:center;">
                                            <div><asp:Label ID="Label7" runat ="server"></asp:Label></div>
                                         </td>
                                      </tr>
                                      <tr>
                                         <td class="bodytable1">
                                           <div>From 0 to 7 Days:</div>
                                         </td>
                                  
                                         <td align="right" class="bodytable1" style="text-align:center;">
                                             <div><asp:Label ID="Label8" runat="server"></asp:Label></div>
                                         </td>
                                      </tr>
                                      <tr>
                                         <td class="bodytable1">
                                             <div>From 8 to 15 Days:</div>
                                         </td>
                                 
                                         <td align="right" class="bodytable1" style="text-align:center;">
                                             <div><asp:Label ID="Label9" runat="server"></asp:Label></div>
                                         </td>
                                      </tr>
                                      <tr>
                                         <td class="bodytable1">
                                             <div>From 16 and Over:</div>
                                         </td>
                                  
                                          <td class="bodytable" style="text-align:center;">
                                             <div><asp:Label ID="Label10" runat="server"></asp:Label></div>
                                         </td>
                                      </tr>
                                  </table>
                                  </td>
                                  <td>
                                      <table  width="100%" cellspacing ="0">
                                       <tr>
                                          <td colspan="3"><div class="datacell1" style="text-align:center;">Billing</div></td>
                                      </tr>
                                      <tr >
                                         <td class="bodytable1" >
                                            <div>Total Open Tickets:</div>
                                         </td>
                                  
                                         <td align="right" class="bodytable1" style="text-align:center;">
                                            <div><asp:Label ID="Label14" runat ="server"></asp:Label></div>
                                         </td>
                                      </tr>
                                      <tr>
                                         <td class="bodytable1">
                                           <div>From 0 to 7 Days:</div>
                                         </td>
                                  
                                         <td align="right" class="bodytable1" style="text-align:center;">
                                             <div><asp:Label ID="Label15" runat="server"></asp:Label></div>
                                         </td>
                                      </tr>
                                      <tr>
                                         <td class="bodytable1">
                                             <div>From 8 to 15 Days:</div>
                                         </td>
                                 
                                         <td align="right" class="bodytable1" style="text-align:center;">
                                             <div><asp:Label ID="Label16" runat="server"></asp:Label></div>
                                         </td>
                                      </tr>
                                      <tr>
                                         <td class="bodytable1">
                                             <div>From 16 and Over:</div>
                                         </td>
                                  
                                          <td class="bodytable1" style="text-align:center;">
                                             <div><asp:Label ID="Label17" runat="server"></asp:Label></div>
                                         </td>
                                      </tr>
                                  </table>
                                  </td>
                              </tr>
                              <tr>
                                 <td colspan ="4">
                                  <div class="inputformsectionheader" style="text-align:center;">Latest News</div>
                                      <div id="divNews" runat="server" >
                                          <asp:DataGrid ShowHeader="true" style="width: 100%" ID="dgvNews" runat="server" AutoGenerateColumns="false" >
                                          <AlternatingItemStyle CssClass="altrow" />
                                              <ItemStyle CssClass="bandbar" />
                                           <HeaderStyle CssClass="gridheader" />  
                                          <Columns>
                                              <asp:BoundColumn DataField="NewsArticleID" HeaderText="ID" Visible="false" />
                                            <asp:TemplateColumn HeaderText ="Date" Visible="true">
                                              <ItemTemplate>
                                                <%# FormatDateTime(DataBinder.Eval(Container.DataItem, "DateCreated"), DateFormat.ShortDate)%>
                                              </ItemTemplate>
                                            </asp:TemplateColumn>  
                                            <asp:TemplateColumn HeaderText ="Subject">
                                              <ItemTemplate>
                                                <%# DataBinder.Eval(Container.DataItem, "ArticleSubject")%>
                                              </ItemTemplate>
                                            </asp:TemplateColumn> 
 
                                          </Columns>
                                        </asp:DataGrid>
                                      </div>
                              </td>
                              </tr>
                            </table>
                      </td>
                       <td  style="width: 5%" class="inputform" rowspan ="2">
                        <div class="inputformsectionheader">Reminder</div>
                           <asp:Calendar ID="Calendar1" runat="server" BackColor="#FFFFCC" BorderColor="#FFCC66" DayNameFormat="Shortest" Font-Names="Verdana" Font-Size="8pt" ForeColor="#663399" Height="180px" Width="180px" OnSelectionChanged="Calendar1_SelectionChanged" BorderWidth="1px" ShowGridLines="True">
                                <SelectedDayStyle BackColor="#CCCCFF" Font-Bold="True" />
                                <SelectorStyle BackColor="#FFCC66" />
                                <TodayDayStyle BackColor="#FFCC66" ForeColor="White" />
                                <OtherMonthDayStyle ForeColor="#CC9966" />
                                <NextPrevStyle Font-Size="9pt" ForeColor="#FFFFCC" />
                                <DayHeaderStyle BackColor="#FFCC66" Font-Bold="True" Height="1px" />
                                <TitleStyle BackColor="#003380" Font-Bold="True" Font-Size="9pt" ForeColor="#FFFFCC" />
                            </asp:Calendar>
                        <div class="inputformsectionheader">Menu</div>
                        <div ></div>
                         <dl>
                          <dt><asp:Label ID="Label11" runat ="server"></asp:Label></dt>
                          <dt><a href="customers.aspx">Customers</a></dt>
                          <dt><a href="partners.aspx">Vendors</a></dt>
                          <dt><a href="PartsManagementTeam.aspx">Parts</a></dt>
                          <dt><a href="ClientServices.aspx">Sales</a></dt>
                          <dt><a href="recruit.aspx">Recruitment</a></dt>
                          <dt><asp:Label ID="Label12" runat ="server"></asp:Label></dt>
                          <dt><asp:Label ID="Label13" runat ="server"></asp:Label></dt>
                          <dt><a href="recruit.aspx">Pay Vendors</a></dt>
                          <dt><a href="VendorAdministrationControl.aspx">Technicians Access</a></dt>
                          <dt><a href="PartsManagementTeam.aspx">Parts</a></dt>
                          <dt><a href="ClientServices.aspx">Sales</a></dt>
                        </dl>
                         <div class="inputformsectionheader">Product Support</div>
                          <div class="label">&nbsp;</div>
                          <div class="label">1.800.245.0215</div>
                          <div >support@ondispatch.com</div>
                          <div >Live Chat</div>  
                          <div style="text-align: right;"></div>
                      </td>
                   </tr>
                  
              </table>
          </td>
          
        </tr>
      </tbody>
    </table>
</form>
</asp:Content>