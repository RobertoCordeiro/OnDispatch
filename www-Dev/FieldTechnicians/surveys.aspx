<%@ Page Language="vb" masterpagefile="~/masters/FieldTechnicians.master" %>
<%@ MasterType VirtualPath="~/masters/FieldTechnicians.master" %>
<script runat="server">
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
            Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Statistics"
            Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Statistics"
            Master.ActiveMenu = "RA"
            LoadSurveys(Master.PartnerID)
        End If
    End Sub
    Private Sub LoadSurveys(ByVal lngPartnerID As Long)
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
        
        'ldr.LoadSingleLongParameterDataGrid("spGetTicketDocumentsForVendors", "@TicketID", lngTicketID, dgvAttachments)
        ldr.LoadTwoLongTwoDateParameterDataGrid("spGetSurveyAnswersByPartnerAndDates", "@SurveyID", 2, "@PartnerID", lngPartnerID, "@StartDate", dtStartdate, "@EndDate", dtEndDate, dgvSurveys)
        If dgvSurveys.Items.Count = 0 Then
            lblSurveyResults.Text = "  Survey Results: Not enough surveys performed to calculate performance at this moment."
            dgvSurveys.Visible = False
        Else
            lblSurveyResults.Visible = False
        End If
    End Sub
    Private Function LoadTotalTickets(ByVal datStartDate As Date, ByVal datEndDate As Date) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spPerformanceStatisticTotalTickets")
        
        Dim lngTotalTickets As Long
        lngTotalTickets = 0
        cmd.Parameters.Add("@PartnerID", Data.SqlDbType.Int).Value = Master.PartnerID
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
        Dim cmd As New System.Data.SqlClient.SqlCommand("spPerformanceStatisticDaysToClose")
        
        Dim lngDaysToClose As Long
        lngDaysToClose = 0
        cmd.Parameters.Add("@PartnerID", Data.SqlDbType.Int).Value = Master.PartnerID
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
        Dim cmd As New System.Data.SqlClient.SqlCommand("spPerformanceStatisticMultipleVisits")
        
        Dim lngMultiVisit As Long
        lngMultiVisit = 0
        cmd.Parameters.Add("@PartnerID", Data.SqlDbType.Int).Value = Master.PartnerID
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
        Dim cmd As New System.Data.SqlClient.SqlCommand("spPerformanceStatisticRecallTickets")
        
        Dim lngTotalRecall As Long
        lngTotalRecall = 0
        cmd.Parameters.Add("@PartnerID", Data.SqlDbType.Int).Value = Master.PartnerID
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
    
    Private Sub dgvSurveys_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgvSurveys.ItemDataBound
        Dim rowData As Data.DataRowView
        Dim lngTotal As Long
        Dim lngGoal As Long
        Dim lngAvarage As Long
        Dim listlblSurveyPic As System.Web.UI.WebControls.Label
        
        Select (e.Item.ItemType)
            Case ListItemType.AlternatingItem, ListItemType.EditItem, ListItemType.Item, ListItemType.SelectedItem
                'get the data for the item being bound
                
                rowData = CType(e.Item.DataItem, Data.DataRowView)
                lngTotal = (rowData.Item("Total"))
                lngGoal = (rowData.Item("Goal"))
                lngAvarage = (rowData.Item("Avarage"))
                
                If lngAvarage >= lngGoal Then
                    listlblSurveyPic = CType(e.Item.FindControl("lblSurveyPic"), System.Web.UI.WebControls.Label)
                    listlblSurveyPic.Text = "<img src='/graphics/green.jpg' id='img1' runat ='server' height='50' width='60'/>"
                Else
                    If lngAvarage = (lngGoal - 1) Then
                        listlblSurveyPic = CType(e.Item.FindControl("lblSurveyPic"), System.Web.UI.WebControls.Label)
                        listlblSurveyPic.Text = "<img src='/graphics/yellow.jpg' id='img1' runat ='server' height='50' width='60'/>"
                    Else
                        listlblSurveyPic = CType(e.Item.FindControl("lblSurveyPic"), System.Web.UI.WebControls.Label)
                        listlblSurveyPic.Text = "<img src='/graphics/red.jpg' id='img1' runat ='server' height='50' width='60'/>"
                    End If
                End If
        End Select
    End Sub
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="servey1" runat="server">
  <div class="label" style="text-align: center; font-size: x-large;">Partner's Performance</div>
  <div class="label" style="text-align: center; "><asp:Label ID="lblMonth" runat ="server" /></div>
  <table cellpadding="10px" cellspacing="0">
    <tr>
      <td class="label">&nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID="lblTickets" runat ="server" Text="Tickets: " visible="false"/></td>
      <td style="font-size: x-large;"><asp:Label ID="lblTotalTicketsResults" runat ="server" visible="false"/></td>
      <td></td>
    </tr>
    <tr class="pageheader" >
      <td class="label" style="vertical-align:middle;">&nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID="lblStatistics" runat ="server" Text="Statistics: " /></td>
      <td class="label" style="text-align:midddle;" ><asp:Label ID="lblTotal" runat ="server"  /></td>
      <td  class="label" align="center" ><asp:Label ID="lblGoal" runat ="server" Text="Goal" /></td>
      <td class="label" align="center" ><asp:Label ID="lblResults" runat ="server" Text="Results" /></td>
      <td class="label" align="center" ><asp:Label ID="lblPicture" runat ="server" Text="Graph" /></td>
    </tr>
    <tr>
      <td class="label" style="vertical-align:middle;" >&nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID="lblDaystoClose" runat ="server" Text="Avg Days to Close " /> </td>
      <td></td>
      <td  style="vertical-align:middle; font-size: x-large;"><asp:Label ID="lblGoalDaysToClose" runat ="server" Text="< 7" /></td>
      <td  style="vertical-align:middle; font-size: x-large;"><asp:Label ID="lblGoalAvgDTC" runat ="server" Text="6%" /></td> 
      <td style="vertical-align: bottom; text-align: inherit;"><asp:Label ID="lblDaystoCloseGraph" runat="server"  /></td> 
    </tr>
    <tr>
      <td class="label" style="vertical-align:middle;" >&nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID="lblMultipleVisits" runat ="server" Text="Multiple Visits to Close " /></td>
      <td></td>
      <td style="vertical-align:middle;font-size: x-large;"><asp:Label ID="Label2" runat ="server" Text="< 5%"/></td>
      <td style="vertical-align:middle;font-size: x-large;"><asp:Label ID="lblMultiVisitResults" runat ="server" Text="30%" /></td> 
      <td style="vertical-align:middle;"><asp:Label ID="lblMultipleVisitsToClose" runat="server"  /></td>  
    </tr>
    <tr>
      <td class="label" style="vertical-align:middle;" >&nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID="lblRecallTickets" runat ="server" Text="Recall Tickets " /></td>
      <td></td>
      <td style="vertical-align:middle;font-size: x-large;"><asp:Label ID="Label3" runat ="server" Text="< 5%"  /></td>
      <td style="vertical-align:middle;font-size: x-large;"><asp:Label ID="lblRecall" runat ="server" Text="10%" /></td>
      <td style="vertical-align:middle;"><asp:Label ID="lblTotalRecall" runat="server"  /></td>  
    </tr>
    <tr>
      <td class="label" style="vertical-align:middle;" colspan ="5">
        <asp:Label ID="lblSurveyResults" runat ="server" Text="Survey Results: " />
        <asp:DataGrid ID="dgvSurveys" runat ="server" style="width:100%; background-color: White;" AutoGenerateColumns="false" GridLines="None"  CellPadding="15" EditItemStyle-HorizontalAlign="Center" EditItemStyle-VerticalAlign="Middle"  >
        <HeaderStyle CssClass="pageheader" />
         
           <Columns>
              <asp:BoundColumn DataField="QuestionType" HeaderText="Survey Results:" ItemStyle-Wrap="false" ItemStyle-VerticalAlign="Middle"/> 
              <asp:BoundColumn DataField="Total" HeaderText="Total" ItemStyle-Wrap="false" ItemStyle-Font-Size="X-Large" ItemStyle-HorizontalAlign="Right" ItemStyle-VerticalAlign="Middle"/> 
              <asp:BoundColumn DataField="Goal" HeaderText="Goal" ItemStyle-Wrap="false" ItemStyle-Font-Size="X-Large" ItemStyle-HorizontalAlign="Right" ItemStyle-VerticalAlign="Middle" /> 
              <asp:BoundColumn DataField="Avarage" HeaderText="Results" ItemStyle-Font-Size="X-Large" ItemStyle-HorizontalAlign="Right" ItemStyle-VerticalAlign="Middle"/> 
              <asp:TemplateColumn HeaderText="Graph" ItemStyle-Wrap="false"  ItemStyle-HorizontalAlign="Right" >
                 <ItemTemplate>
                    <asp:Label ID="lblSurveyPic" runat ="server"  />
                 </ItemTemplate>
              </asp:TemplateColumn>                  
           </Columns> 
        </asp:DataGrid>
      </td>  
    </tr>
    </table>
  </form>
</asp:Content>