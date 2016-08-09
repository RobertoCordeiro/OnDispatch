<%@ Page Language="vb" masterpagefile="~/masters/partnerdialog.master" %>
<%@ MasterType VirtualPath="~/masters/partnerdialog.master" %>
<%@ Register Src="~/controls/DateTimePicker.ascx" TagName="DateTimePicker" TagPrefix="cv" %>
<%@ Register Assembly="RadCalendar.Net2" Namespace="Telerik.WebControls" TagPrefix="rad" %>
<script runat="server"> 
  
  Private _ID As Long = 0
    Private _PartnerAgentID As Long = 0
    Private _WorkOrderID As Long = 0
    
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
        If User.Identity.IsAuthenticated Then
            Master.WebLoginID = CType(User.Identity.Name, Long)
            Master.PageHeaderText = "Set Ticket Appointment"
            Master.PageTitleText = "Set Ticket Appointment"
        End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
        End Try
        Try
            _PartnerAgentID = CType(Request.QueryString("pid"), Long)
        Catch ex As Exception
            _PartnerAgentID = 0
        End Try
        Try
            _WorkOrderID = CType(Request.QueryString("wid"), Long)
        Catch ex As Exception
            _WorkOrderID = 0
        End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If _ID > 0 Then
      If Not IsPostBack Then
                LoadTicket(Weekday(DateTime.Now.Date))
                RadDatePickerTo.SelectedDate = DateTime.Now.Date
                LoadAvailabilityForDay(_PartnerAgentID, DateTime.Now.Date)
      End If
    Else
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub

  Private Sub LoadTicket(ByVal lngWeekDay As long)
       
        Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        par.Load(_PartnerAgentID)
        
        
        chkSunday.Checked = par.WorkDaySunday
        chkMonday.Checked = par.WorkDayMonday
        chkTuesday.Checked = par.WorkDayTuesday
        chkWednesday.Checked = par.WorkDayWednesday
        chkThursday.Checked = par.WorkDayThursday
        chkFriday.Checked = par.WorkDayFriday
        chkSaturday.Checked = par.WorkDaySaturday
        
        If par.ScheduleZoneTypeID > 0 Then
            LoadAssignedScheduleAvailabilityZones(par.ScheduleZoneTypeID, lngWeekDay)
        End If
   
  End Sub
  
    
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
    End Sub
    
    Private Sub btnSetAppointment_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim sch As New BridgesInterface.ScheduleAvailabilityAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim tem As New BridgesInterface.ScheduleZoneTemplateRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim nts As New BridgesInterface.TicketNoteRecord(system.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim scd As New BridgesInterface.ScheduleAvailabilityCodeRecord(system.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim paa As New BridgesInterface.PartnerAgentAvailabilityRecord(system.Configuration.ConfigurationManager.AppSettings("DBCnn"))
         
        
            
        If _PartnerAgentID > 0 Then
            If dgvAssignedScheduleAvailabilityZones.Items.Count > 0 Then
                If Not IsDBNull(RadDatePickerTo.SelectedDate) Then
                    If IsZoneSpotTaken(_PartnerAgentID,CType(RadioSelectID.Text, Long),RadDatePickerTo.SelectedDate) = 0 then
                    
                       Dim strChangeLog As String
                      paa.Load(CType(RadioSelectID.Text, Long))
                      tem.Load(paa.ScheduleZoneTemplateID)
                      strChangeLog = ""
                      'add appt set to ticket
                      tkt.Load(_ID)
                      If Not IsDBNull(tkt.ScheduledDate) Then
                        DeleteScheduleAssignment(_ID)
                      End If
                      tkt.ScheduledDate = CType(RadDatePickerTo.SelectedDate, String) + " " + tem.StartScheduleTime.ToShortTimeString
                      tkt.ScheduledEndDate = CType(RadDatePickerTo.SelectedDate, String) + " " + tem.EndScheduleTime.ToShortTimeString
                        tkt.TicketStatusID = 11 'Scheduled
                        tkt.CustomerPrioritySetting = 1
                      tkt.Save(strChangeLog)
                      'add record to ScheduleAvailabilityAssignments table
                      sch.Add(_PartnerAgentID, RadDatePickerTo.SelectedDate, RadioSelectID.Text, 1, _ID)
                      'add note to the ticket
                      Dim strNota As String
                      strNota = "Auto Note: Appointment has been set for " + CType(RadDatePickerTo.SelectedDate, String) + " from " + tem.StartScheduleTime.ToShortTimeString + " and " + tem.EndScheduleTime.ToShortTimeString
                        nts.Add(_ID, Master.WebLoginID, Master.UserID, strNota)
                      nts.CustomerVisible = True
                      nts.PartnerVisible = True
                      nts.Acknowledged = True
                      nts.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                      nts.Save(strChangeLog)
                    
                      Response.Redirect("ticket.aspx?id=" & _ID, True)
                   Else
                     Msgbox ("You cannot assign two tickets for the same Time Zone. This Time Zone is unavalable")
                   end if
                End If
            Else
                MsgBox("You must set up your Schedule Zones prior from Scheduling a service call. Please go to the Set Availability section of the system and let the system know what hours you will be working everyday.")
            End If
        End If
    End Sub
    Private Sub SelectOnlyOne(ByVal sender As Object, ByVal e As System.EventArgs)
 
        Dim m_ClientID As String = ""
        Dim rb As New RadioButton
 
        rb = CType(sender, RadioButton)
        m_ClientID = rb.ClientID
 
        For Each i As DataGridItem In dgvAssignedScheduleAvailabilityZones.Items
            rb = CType(i.FindControl("rdbBatchTime"), RadioButton)
            rb.Checked = False
            If (m_ClientID = rb.ClientID) Then
                rb.Checked = True
                RadioSelectID.text = i.Cells(0).text
         
            End If
        Next
 
    End Sub
    Private Sub ShowSchedules(sender As Object, e As Telerik.WebControls.SelectedDateChangedEventArgs)
        LoadAvailabilityForDay(_PartnerAgentID, (RadDatePickerTo.SelectedDate))
    End Sub
    Private Sub LoadAvailabilityForDay(ByVal lngPartnerAgentID As Long, ByVal datScheduleDay As DateTime)
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadLongDateParameterDataGrid("spGetScheduleForPartnerAgentPerDay", "@PartnerAgentID", _PartnerAgentID, "@ScheduleDay", datScheduleDay, dgvShowAvailabilityforDay)
        
        Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        par.Load(_PartnerAgentID)
        
        Dim lngWeekDay As Long
        If Weekday(datScheduleDay) = 7 Then
            lngWeekDay = 8
        Else
            lngWeekDay = Weekday(datScheduleDay)
        End If
        
        LoadAssignedScheduleAvailabilityZones(CType(par.ScheduleZoneTypeID, Long), lngWeekDay)
        
    End Sub
    Private Sub LoadAssignedScheduleAvailabilityZones(ByVal lngScheduleZoneTypeID As Long, ByVal lngWeekday As long)
        Dim ldr1 As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr1.LoadThreeLongParameterDataGrid("spListAssignedScheduleAvailabilityForPartnerAgent", "@PartnerAgentID", _PartnerAgentID, "@ScheduleZoneTypeID", lngScheduleZoneTypeID,"WeekDayID",lngWeekDay, dgvAssignedScheduleAvailabilityZones)
        
    End Sub
    Private Sub DeleteScheduleAssignment(ByVal lngTicketID As Long)
  
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spDeleteScheduleAssignmentByTicketID")
  
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TicketID", Data.SqlDbType.Int).Value = lngTicketID
        cnn.open()
        cmd.Connection = cnn
        cmd.ExecuteScalar()
        cnn.Close()
   
    End Sub
    Private Function GetTicketPhoneNumbers (lngTicketID as Long) as string
  
   Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetPhoneNumbersForTicket")
        Dim strPhoneNumber As String
        strPhoneNumber = ""
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TicketID", Data.SqlDbType.Int).Value = lngTicketID
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            strPhoneNumber = strPhoneNumber & " / " & dtr("AreaCode") & dtr("Exchange") & dtr("LineNumber") & " - " & dtr("Comment")
        End While
        cnn.Close()
        GetTicketPhoneNumbers = strPhoneNumber
  end function
     
     Private Function IsZoneSpotTaken (lngPartnerAgentID as Long, lngPartnerAgentAvailabilityID as Long, datScheduleDate as Date ) as long
  
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spIsTimeZoneTaken")
        Dim strPhoneNumber As String
        strPhoneNumber = ""
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@PartnerAgentID", Data.SqlDbType.Int).Value = lngPartnerAgentID
        cmd.Parameters.Add("@PartnerAgentAvailabilityID", Data.SqlDbType.Int).Value = lngPartnerAgentAvailabilityID
        cmd.Parameters.Add("@ScheduleDate", Data.SqlDbType.DateTime).Value = datScheduleDate
        cnn.Open()
        cmd.Connection = cnn
        IsZoneSpotTaken = cmd.ExecuteScalar()
        cnn.Close()
        
  end function
  Private Sub MsgBox(ByVal strMessage As String)
        'Begin building the script 
        Dim strScript As String = "<SCRIPT LANGUAGE=""JavaScript"">" & vbCrLf
        strScript += "alert(""" & strMessage & """)" & vbCrLf
        strScript += "<" & "/" & "SCRIPT" & ">"
        'Register the script for the client side 
        ClientScript.RegisterStartupScript(GetType(String), "messageBox", strScript)
    End Sub
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <table>
                <tr>
                  <td style ="width:50%;">
                    <div class="bandheader">Working Days</div>
                                   <div>
                                    <asp:Label ID="lblWindow" runat="server" /> 
                                    <asp:CheckBox ID="chkSunday" runat="server" Text="Sun" />
                                    <asp:CheckBox ID="chkMonday" runat="server" Text="Mon" />
                                    <asp:CheckBox ID="chkTuesday" runat="server" Text="Tue" />
                                    <asp:CheckBox ID="chkWednesday" runat="server" Text="Wed" />
                                    <asp:CheckBox ID="chkThursday" runat="server" Text="Thr" />
                                    <asp:CheckBox ID="chkFriday" runat="server" Text="Fri" />
                                    <asp:CheckBox ID="chkSaturday" runat="server" Text="Sat" />                
                                  </div>
                                  <div>&nbsp;</div>
                                  <div><asp:TextBox ID="RadioSelectID" runat="server"  Visible ="false"  /></div>
                                  <div><asp:Button ID="btnSetSchedule" Text="Set Appointment" runat="server" OnClick="btnSetAppointment_click"  UseSubmitBehavior="true"  /></div>
                            <div class="inputformsectionheader"><asp:label ID="Label1" runat="server" />&nbsp;Days of Work&nbsp;</div>
                            <asp:DataGrid ID="dgvAssignedScheduleAvailabilityZones" style="width: 100%" runat="server" AutoGenerateColumns="false"  >
                               <AlternatingItemStyle CssClass="altrow" />
                                  <HeaderStyle CssClass="gridheader" />
                                     <Columns>
                                         <asp:BoundColumn HeaderText="ID" DataField="PartnerAgentAvailabilityID" visible="false" />
                                         <asp:TemplateColumn HeaderText="Select"  >
                                            <ItemTemplate>
                                              <asp:RadioButton id="rdbBatchTime" runat="server" AutoPostBack="True" OnCheckedChanged="SelectOnlyOne"></asp:RadioButton>
                                            </ItemTemplate>
                                         </asp:TemplateColumn>
                                         <asp:BoundColumn HeaderText="Type" DataField="ZoneName" />                 
                                         <asp:TemplateColumn HeaderText="ZoneName"  >
                                            <ItemTemplate>
                                               <%# CType(DataBinder.Eval(Container.DataItem, "ScheduleStart"), Date).ToString("HH:mm") %> - <%#CType(DataBinder.Eval(Container.DataItem, "ScheduleEnd"), Date).ToString("HH:mm")%>
                                            </ItemTemplate>
                                         </asp:TemplateColumn>
                                     </Columns>                
                               </asp:DataGrid>  
                  </td> 
                  <td><div>&nbsp;</div></td>
                  <td><div>&nbsp;</div></td>
                  <td align="center";>
                     <div><rad:RadDatePicker ID="RadDatePickerTo" runat="server" Width="60%" DateInput-Font-Size="Medium" Culture="English (United States)"  Skin="" Calendar-Skin="Web20" Calendar-FastNavigationStep="12" OnSelectedDateChanged ="ShowSchedules" AutoPostBack="true">
                       <DateInput Font-Size="Medium" Skin="">
                       </DateInput>
                     </rad:RadDatePicker></div>
                      <div>&nbsp;</div>
                       <div>&nbsp;</div>
                       <div>&nbsp;</div>
                       <div class="inputformsectionheader">Current Technician's Schedule</div>
                        <asp:DataGrid style="background-color: White;" ID="dgvShowAvailabilityforDay" runat="server" AutoGenerateColumns="false">
                          <HeaderStyle CssClass="gridheader" />
                          <AlternatingItemStyle CssClass="altrow" />
                          <Columns>
                            <asp:BoundColumn HeaderText="Type" DataField="ZoneName"  />
                            <asp:BoundColumn HeaderText="Schedule Start" DataField="ScheduleStart"  />
                            <asp:BoundColumn HeaderText="Schedule End" DataField="ScheduleEnd" />
                            <asp:BoundColumn HeaderText="Status" DataField="CodeName"  />
                            <asp:BoundColumn HeaderText="Date" DataField="dateSet" />
                            <asp:TemplateColumn HeaderText="TicketID">
                              <ItemTemplate>
                                 <a href="ticket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>" target ="_blank"><%# DataBinder.Eval(Container.DataItem,"TicketID")%> </a>
                              </ItemTemplate>
                            </asp:TemplateColumn>
                          </Columns>    
                        </asp:DataGrid>
                   </td>
                </tr>
            </table>
    <div>&nbsp;</div>
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>