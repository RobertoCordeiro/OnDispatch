<%@ Page Language="vb" masterpagefile="~/masters/FieldTechnicians.master" %>
<%@ MasterType VirtualPath="~/masters/FieldTechnicians.master" %>
<%@ Register Assembly="RadCalendar.Net2" Namespace="Telerik.WebControls" TagPrefix="rad" %>
<script runat="server">

  Private _ID As Long = 0
    
    
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
            Master.PageHeaderText = " Set Availability"
            Master.PageTitleText = " Set Availability"
            _ID = Master.PartnerAgentID
            Master.ActiveMenu = "LA"
      If Not IsPostBack Then
                LoadWeekDays()
                LoadInfo()
                
      End If
    End If
    End Sub
    
    Private Sub LoadInfo()
        Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
        par.Load(_ID)
        LoadScheduleZoneTypes()
        
        chkSunday.Checked = par.WorkDaySunday
        chkMonday.Checked = par.WorkDayMonday
        chkTuesday.Checked = par.WorkDayTuesday
        chkWednesday.Checked = par.WorkDayWednesday
        chkThursday.Checked = par.WorkDayThursday
        chkFriday.Checked = par.WorkDayFriday
        chkSaturday.Checked = par.WorkDaySaturday
        If par.ScheduleZoneTypeID > 0 Then
            drpScheduleZoneTypes.SelectedValue = par.ScheduleZoneTypeID
            If drpWeekDays.SelectedValue = "Week Days" then
              LoadUnAssignedScheduleAvailabilityZones(_ID, par.ScheduleZoneTypeID,1)
              LoadAssignedScheduleAvailabilityZones(_ID, par.ScheduleZoneTypeID,1)
            Else
              LoadUnAssignedScheduleAvailabilityZones(_ID, par.ScheduleZoneTypeID, CType(drpWeekDays.SelectedValue ,Long))
              LoadAssignedScheduleAvailabilityZones(_ID, par.ScheduleZoneTypeID,CType(drpWeekDays.SelectedValue ,Long))
            end if
        End If
        ListScheduleAvailabilityCodes()
        RadDatePicker1.SelectedDate = DateTime.Now.Date
        RadDatePicker2.SelectedDate = DateTime.Now.Date
        LoadAvailabilityForDayRange(_ID, RadDatePicker1.SelectedDate, RadDatePicker2.SelectedDate)
        
    End Sub
    
    Private Sub btnRemove_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim chkbox As CheckBox
        Dim dgItem As DataGridItem
        Dim rty As New BridgesInterface.ScheduleAvailabilityAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))

        For Each dgItem In dgvShowAvailabilityforDay.Items
            chkbox = dgItem.FindControl("chkRemove")
            If chkbox.Checked Then
                rty.Load(CType(dgItem.Cells.Item(0).Text, Integer))
                If rty.TicketID.ToString.Length < 2 Then
                    rty.Delete()
                Else
                    MsgBox("You have ticket(s) scheduled for the time-frame you are trying to set time off for. Unable to set time off.")
                End If
            End If
        Next
        LoadAvailabilityForDayRange(_ID, RadDatePicker1.SelectedDate, RadDatePicker2.SelectedDate)

    End Sub
    Protected Sub chkAll_OnCheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim chkbox As CheckBox
        Dim dgItem As DataGridItem
        
        For Each dgItem In dgvShowAvailabilityforDay.Items
            chkbox = dgItem.FindControl("chkRemove")
            If Not chkbox.Checked Then
                chkbox.Checked = True
            Else
                chkbox.Checked = False
            End If
        Next
    End Sub
    Private Function IsScheduleTimeFrameAvailableForPartnerAgentID(ByVal lngPartnerAgentID As Long, ByVal lngPartnerAgentAvailabilityID As Long, ByVal datSetDate As DateTime) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spIsScheduleTimeFrameAvailableForPartnerAgentID")
  
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@PartnerAgentID", Data.SqlDbType.Int).Value = lngPartnerAgentID
        cmd.Parameters.Add("@PartnerAgentAvailabilityID", Data.SqlDbType.Int).Value = lngPartnerAgentAvailabilityID
        cmd.Parameters.Add("@SetDate", Data.SqlDbType.DateTime).Value = datSetDate
        cnn.Open()
        cmd.Connection = cnn
        IsScheduleTimeFrameAvailableForPartnerAgentID = cmd.ExecuteScalar()
        cnn.Close()

    End Function
    Private Sub MsgBox(ByVal strMessage As String)
        'Begin building the script 
        Dim strScript As String = "<SCRIPT LANGUAGE=""JavaScript"">" & vbCrLf
        strScript += "alert(""" & strMessage & """)" & vbCrLf
        strScript += "<" & "/" & "SCRIPT" & ">"
        'Register the script for the client side 
        ClientScript.RegisterStartupScript(GetType(String), "messageBox", strScript)
    End Sub
    Private Sub btnSetDayOff_Click(ByVal S As Object, ByVal E As EventArgs)
        If drpScheduleCodes.SelectedValue <> "Choose One" Then
            Dim TotalVacDays As Integer
            Dim CurrD As DateTime
            Dim dgItem As DataGridItem
            Dim chkBox As New CheckBox
            Dim rty As New BridgesInterface.ScheduleAvailabilityAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))

            Select Case drpScheduleCodes.SelectedValue
                Case Is = 2, 7 'vacation
                    
                    CurrD = RadDatePicker1.SelectedDate
                    
                    TotalVacDays = DateDiff("d", RadDatePicker1.SelectedDate, RadDatePicker2.SelectedDate)
                    If TotalVacDays > 0 Then
                        While (CurrD <= RadDatePicker2.SelectedDate)
                            For Each dgItem In dgvAssignedScheduleAvailabilityZones.Items
                                'chkbox = dgItem.FindControl("chkselected")
                                'If chkbox.Checked Then
                                If IsScheduleTimeFrameAvailableForPartnerAgentID(_ID, CType(dgItem.Cells(1).Text, Long), CurrD.Date) = 0 Then
                                   
                                    rty.Add(_ID, CurrD.Date, (CType(dgItem.Cells.Item(1).Text, Integer)), drpScheduleCodes.SelectedValue)
                                Else
                                    'message   
                                    MsgBox("The time-frame Type: " & dgItem.Cells.Item(3).Text & " is already scheduled for something else and it is not available for " & CurrD.ToShortDateString & ". Unable to set time off.")
                                End If
                                'End If
                            Next
                            LoadAssignedScheduleAvailabilityZones(_ID, CType(drpScheduleZoneTypes.SelectedValue, Long), Weekday(CurrD.AddDays(1)))

                            CurrD = CurrD.AddDays(1)
                        End While
                        
                        Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
                        Dim pta As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                        pta.Load(_ID)

                        Dim strBody As String
                        eml.HTMLBody = True
                        eml.Subject = "Technician Schedule Vacation Time off - ATTENTION!!!!!!"
                        strBody = "<b>The technician: " & pta.FirstName & " " & pta.LastName & " (" & pta.WebLoginID & ")" & " has scheduled vacation between: " & CType(RadDatePicker1.SelectedDate, String) & " and " & CType(RadDatePicker2.SelectedDate, String) & "</b><br>"
                       
                        eml.Body = strBody
                        eml.SendFrom = System.Configuration.ConfigurationManager.AppSettings("PartnerSupportEmail")
                        eml.SendTo = "services@bestservicers.com"
        
                        eml.Send()
                        
                        
                    Else
                        'message  
                        MsgBox("Vacation must be set within a range of two dates. If you are trying to set a day off, choose the Time Off option!")
                    End If
                    LoadAvailabilityForDayRange(_ID, RadDatePicker1.SelectedDate, RadDatePicker2.SelectedDate)
                Case Else
                    CurrD = RadDatePicker1.SelectedDate
                    For Each dgItem In dgvAssignedScheduleAvailabilityZones.Items
                        chkBox = dgItem.FindControl("chkSelect")
                        If chkBox.Checked Then
                            If IsScheduleTimeFrameAvailableForPartnerAgentID(_ID, CType(dgItem.Cells(1).Text, Long), CurrD.Date) = 0 Then
                                   
                                rty.Add(_ID, CurrD.Date, (CType(dgItem.Cells.Item(1).Text, Integer)), drpScheduleCodes.SelectedValue)
                            Else
                                'message   
                                MsgBox("The time-frame Type: " & dgItem.Cells.Item(3).Text & " is already scheduled for something else and it is not available for " & CurrD.ToShortDateString & ". Unable to set time off.")
                            End If
                        End If
                    Next
                    LoadAvailabilityForDayRange(_ID, RadDatePicker1.SelectedDate, RadDatePicker2.SelectedDate)
                    drpScheduleCodes.SelectedValue = "Choose One"
                    
            End Select
            
            If drpScheduleZoneTypes.SelectedValue <> "Choose One" then
              Dim strChangeLog As String = ""
              Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
              par.Load(_ID)
              par.ScheduleZoneTypeID = drpScheduleZoneTypes.SelectedValue
              par.Save(strChangeLog)
              Dim lngWeekDay As Long
            lngWeekDay = Weekday(RadDatePicker1.SelectedDate )
              If drpScheduleZoneTypes.SelectedValue <> "Choose One" then
                LoadUnAssignedScheduleAvailabilityZones(_ID, par.ScheduleZoneTypeID,lngWeekDay)
                LoadAssignedScheduleAvailabilityZones(_ID, par.ScheduleZoneTypeID,lngWeekDay)
              end if
            end if
        End If
    End Sub
    Private Sub LoadAvailabilityForDayRange(ByVal lngPartnerAgentID As Long, ByVal datScheduleDay As DateTime, ByVal datScheduleDay2 As DateTime)
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadLongTwoDateParameterDataGrid("spGetScheduleForPartnerAgentPerDayRange", "@PartnerAgentID", lngPartnerAgentID, "@ScheduleDay", datScheduleDay, "@ScheduleDay2", datScheduleDay2, dgvShowAvailabilityforDay)
        If drpScheduleZoneTypes.SelectedValue <> "Choose One" then
          LoadUnAssignedScheduleAvailabilityZones(_ID, Ctype(drpScheduleZoneTypes.SelectedValue,Long) ,weekday(datScheduleDay))
          LoadAssignedScheduleAvailabilityZones(_ID, Ctype(drpScheduleZoneTypes.SelectedValue,long),weekday(datScheduleDay))
        end if
    End Sub
    Private Sub ShowSchedules(ByVal sender As Object, ByVal e As Telerik.WebControls.SelectedDateChangedEventArgs)
        If Not IsDBNull(RadDatePicker1.SelectedDate) Then
            If Not IsDBNull(RadDatePicker2.SelectedDate) Then
                LoadAvailabilityForDayRange(_ID, RadDatePicker1.SelectedDate, RadDatePicker2.SelectedDate)
            Else
                LoadAvailabilityForDay(_ID, (RadDatePicker1.SelectedDate))
            End If
        End If
    End Sub
    Private Sub LoadAvailabilityForDay(ByVal lngPartnerAgentID As Long, ByVal datScheduleDay As DateTime)
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadLongDateParameterDataGrid("spGetScheduleForPartnerAgentPerDay", "@PartnerAgentID", lngPartnerAgentID, "@ScheduleDay", datScheduleDay, dgvShowAvailabilityforDay)
        If drpScheduleZoneTypes.SelectedValue <> "Choose One" then
          LoadUnAssignedScheduleAvailabilityZones(_ID, Ctype(drpScheduleZoneTypes.SelectedValue,Long) ,weekday(datScheduleDay))
          LoadAssignedScheduleAvailabilityZones(_ID, Ctype(drpScheduleZoneTypes.SelectedValue,long),weekday(datScheduleDay))
        end if
    End Sub
    Private Function GetPartnerAgentAvailabilityIDByTemplateID(ByVal lngPartnerAgentID As Long, ByVal lngScheduleZoneTemplateID As Long, ByVal lngWeekDayID As long) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetPartnerAgentAvailabilityIDByTemplateID")
  
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@PartnerAgentID", Data.SqlDbType.Int).Value = lngPartnerAgentID
        cmd.Parameters.Add("@ScheduleZoneTemplateID", Data.SqlDbType.Int).Value = lngScheduleZoneTemplateID
        cmd.Parameters.Add("WeekDayID", Data.SqlDbType.Int).Value = lngWeekDayID
        cnn.open()
        cmd.Connection = cnn
        GetPartnerAgentAvailabilityIDByTemplateID = cmd.ExecuteScalar()
        cnn.Close()

    End Function
    Private Function IsScheduleZoneAssignedToPartnerAgent(ByVal lngPartnerAgentID As Long, ByVal lngScheduleZoneTemplateID As Long, ByVal lngWeekDayID As long) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spIsScheduleZoneAssociatedToPartnerAgent")
  
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@PartnerAgentID", Data.SqlDbType.Int).Value = lngPartnerAgentID
        cmd.Parameters.Add("@ScheduleZoneTemplateID", Data.SqlDbType.Int).Value = lngScheduleZoneTemplateID
        cmd.Parameters.Add("@WeekDayID", Data.SqlDbType.Int).Value = lngWeekDayID
        cnn.open()
        cmd.Connection = cnn
        IsScheduleZoneAssignedToPartnerAgent = cmd.ExecuteScalar()
        cnn.Close()

    End Function
    Private Sub btnSet_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim strChangeLog As String = ""
        Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        par.Load(_ID)
        If drpScheduleZoneTypes.SelectedValue <> "Choose One" Then
            par.ScheduleZoneTypeID = drpScheduleZoneTypes.SelectedValue
            
            If drpWeekDays.SelectedValue = "Week Days" then
              LoadUnAssignedScheduleAvailabilityZones(_ID,par.ScheduleZoneTypeID,1 )
              LoadAssignedScheduleAvailabilityZones(_ID,par.ScheduleZoneTypeID,1 )
           Else
              LoadUnAssignedScheduleAvailabilityZones(_ID,par.ScheduleZoneTypeID,drpWeekDays.SelectedValue)
              LoadAssignedScheduleAvailabilityZones(_ID,par.ScheduleZoneTypeID,drpWeekDays.SelectedValue)
         end if 
        Else
            
            par.ScheduleZoneTypeID = Nothing
            
            If drpWeekDays.SelectedValue = "Week Days" then
              LoadUnAssignedScheduleAvailabilityZones(_ID,par.ScheduleZoneTypeID,1 )
              LoadAssignedScheduleAvailabilityZones(_ID,par.ScheduleZoneTypeID,1 )
           Else
              LoadUnAssignedScheduleAvailabilityZones(_ID,par.ScheduleZoneTypeID,drpWeekDays.SelectedValue)
              LoadAssignedScheduleAvailabilityZones(_ID,par.ScheduleZoneTypeID,drpWeekDays.SelectedValue)
         end if 
            
        End If
        par.WorkDayMonday = chkMonday.Checked
        par.WorkDayTuesday = chkTuesday.Checked
        par.WorkDayWednesday = chkWednesday.Checked
        par.WorkDayThursday = chkThursday.Checked
        par.WorkDayFriday = chkFriday.Checked
        par.WorkDaySaturday = chkSaturday.Checked
        par.WorkDaySunday = chkSunday.Checked
        par.Save(strChangeLog)
        
    End Sub
    Private Sub LoadScheduleZoneTypes()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSimpleDropDownList("spGetScheduleZoneTypes", "Description", "ScheduleZoneTypeID", drpScheduleZoneTypes)
        drpScheduleZoneTypes.Items.Add("Choose One")
        drpScheduleZoneTypes.SelectedValue = "Choose One"
    End Sub
    Private Sub AssignScheduleZones(lngWeekdayID As long)
        Dim itm As System.Web.UI.WebControls.DataGridItem
        Dim chk As System.Web.UI.WebControls.CheckBox
        Dim rty As New BridgesInterface.PartnerAgentAvailabilityRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim strChangeLog As String = ""
        For Each itm In dgvUnAssignedScheduleAvailabilityZones.Items
            chk = itm.FindControl("chkSelected")
            If chk.Checked Then
                If IsScheduleZoneAssignedToPartnerAgent(_ID, CType(itm.Cells(0).Text, Long),lngWeekDayID) = 0 Then
                    rty.Add(_ID, CType(itm.Cells(0).Text, Long),lngWeekDayID)
                Else
                    
                    rty.Load(GetPartnerAgentAvailabilityIDByTemplateID(_ID,  CType(itm.Cells(0).Text, Long),lngWeekDayID))
                    rty.Active = True
                    rty.Save(strChangeLog)
                End If
            End If
        Next
        
    End Sub
    Private Sub LoadUnAssignedScheduleAvailabilityZones(ByVal lngTicketID As Long, ByVal lngScheduleZoneTypeID As Long, ByVal lngWeekDayID As long)
        Dim ldr1 As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr1.LoadThreeLongParameterDataGrid("spListUnassignedScheduleAvailabilityForPartnerAgent", "@PartnerAgentID", lngTicketID, "@ScheduleZoneTypeID", lngScheduleZoneTypeID,"WeekDayID",lngWeekDayID, dgvUnAssignedScheduleAvailabilityZones)
        'lblAssociatedCount.Text = dgvUnAssignedScheduleAvailabilityZones.Items.Count
    End Sub
    Private Sub LoadAssignedScheduleAvailabilityZones(ByVal lngTicketID As Long, ByVal lngScheduleZoneTypeID As Long, ByVal lngWeekDayID As long)
        Dim ldr1 As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr1.LoadThreeLongParameterDataGrid("spListAssignedScheduleAvailabilityForPartnerAgent", "@PartnerAgentID", lngTicketID, "@ScheduleZoneTypeID", lngScheduleZoneTypeID,"WeekDayID",lngWeekDayID, dgvAssignedScheduleAvailabilityZones)
        'lblAssociatedCount.Text = dgvAssignedScheduleAvailabilityZones.Items.Count
    End Sub
    Private Sub ListScheduleAvailabilityCodes()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSimpleDropDownList("spListScheduleAvailabilityCodes", "CodeName", "ScheduleAvailabilityCodeID", drpScheduleCodes)
        drpScheduleCodes.Items.Add("Choose One")
        drpScheduleCodes.SelectedValue = ("Choose One")
    End Sub
    Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
        Response.Redirect("workorders.aspx?act=B")
    End Sub
    
    Private Sub btnApply_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim strChangeLog As String = ""
        Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        par.Load(_ID)
        
        par.WorkDayMonday = chkMonday.Checked
        par.WorkDayTuesday = chkTuesday.Checked
        par.WorkDayWednesday = chkWednesday.Checked
        par.WorkDayThursday = chkThursday.Checked
        par.WorkDayFriday = chkFriday.Checked
        par.WorkDaySaturday = chkSaturday.Checked
        par.WorkDaySunday = chkSunday.Checked
       
        If drpScheduleZoneTypes.SelectedValue <> "Choose One" Then
          If drpWeekDays.SelectedValue <> "Week Days" then
            AssignScheduleZones(Ctype(drpWeekDays.SelectedValue,Long))
            par.ScheduleZoneTypeID = drpScheduleZoneTypes.SelectedValue
            If drpWeekDays.SelectedValue = 1 then
              par.WorkDaySunday = True
            end if
            If drpWeekDays.SelectedValue = 2 then
             par.WorkDayMonday = True
            end if
            If drpWeekDays.SelectedValue = 3 then
             par.WorkDayTuesday = True
            end if
            If drpWeekDays.SelectedValue = 4 then
             par.WorkDayWednesday = True
            end if
            If drpWeekDays.SelectedValue = 5 then
             par.WorkDayThursday = True
            end if
            If drpWeekDays.SelectedValue = 6 then
             par.WorkDayFriday = True
            end if
            If drpWeekDays.SelectedValue = 8 then
             par.WorkDaySaturday = True
            end if
            LoadUnAssignedScheduleAvailabilityZones(_ID, par.ScheduleZoneTypeID,Ctype(drpWeekDays.SelectedValue,long))
            LoadAssignedScheduleAvailabilityZones(_ID, par.ScheduleZoneTypeID,CType(drpWeekDays.SelectedValue,long))
          Else
             If chkSunday.Checked then
               AssignScheduleZones(1)
             else
               UnAssignScheduleZones(1)
             end if
             If chkMonday.Checked then
               AssignScheduleZones(2)
             Else
              UnAssignScheduleZones(2)
             end if
             If chkTuesday.Checked then
               AssignScheduleZones(3)
             Else
               UnAssignScheduleZones(3)
             end if
             If chkWednesday.Checked then
               AssignScheduleZones(4)
             else
               UnAssignScheduleZones(4)
             end if
             If chkThursday.Checked then
               AssignScheduleZones(5)
             Else
               UnAssignScheduleZones(5)
             end if
             If chkFriday.Checked then
               AssignScheduleZones(6)
             Else
               UnAssignScheduleZones(6)
             end if
             If chkSaturday.Checked then
               AssignScheduleZones(8)
             Else
               UnAssignScheduleZones(8)
             end if
          end if
          par.Save(strChangeLog)
        LoadInfo()
        MsgBox ("Schedule Zones have been associated to your Schedule Availability. Go to the individual Week Days so you can verify it!")
        Else
            par.ScheduleZoneTypeID = Nothing
            If drpWeekDays.SelectedValue <> "Week Days" then
              LoadUnAssignedScheduleAvailabilityZones(_ID, par.ScheduleZoneTypeID,drpWeekDays.SelectedValue)
              LoadAssignedScheduleAvailabilityZones(_ID, par.ScheduleZoneTypeID,drpWeekDays.SelectedValue )
            
            end if
            par.Save(strChangeLog)
            Response.Redirect("Availability.aspx")
        End If
        
        
    End Sub
    Private Sub LoadWeekDays()
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSimpleDropDownList("spListWeekDays", "DayName","WeekDayID",drpWeekDays)
        drpWeekDays.Items.Add ("Week Days")
        drpWeekDays.SelectedValue = "Week Days"        
    End Sub
    
    Private Sub UnAssignScheduleZones(lngWeekdayID As long)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spRemovePartnerAgentAvailabilities2")
  
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@PartnerAgentID", Data.SqlDbType.Int).Value = _ID
        cmd.Parameters.Add("WeekDayID", Data.SqlDbType.Int).Value = lngWeekDayID
        cnn.open()
        cmd.Connection = cnn
        cmd.ExecuteScalar()
        cnn.Close()           
        
    End Sub
    Protected Sub drpScheduleZoneTypes_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSet.Click
        btnSet_Click(sender, e)
    End Sub
    Protected Sub drpWeekDays_OnSelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSet.Click
        btnSet_Click(sender, e)
    End Sub
    
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmCertificationSurvey" runat="server">
    <div class="inputformsectionheader">Schedule Availability</div>
                  <table width ="100%" >
                    <tr>
                      <td >
                         <div >
                         <table width="100%"  >
                           <tr >
                             <td colspan="2" >
                                <div class="bandheader">Set your Working Days and Schedule Zones</div>
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
                             </td>
                             <td><div></div>&nbsp;</td>
                             <td><div></div>&nbsp;</td>
                             <td colspan="2">
                                <div class="bandheader">Set Your Days/Times Off</div>
                                <div>Reason for Day/Time Off: </div>
                                <div><asp:DropDownList ID="drpScheduleCodes"  runat="server" /></div>
                             </td>
                           </tr>
                           <tr>
                             <td colspan="3" ><div>&nbsp;</div></td>
                             <td><div></div>&nbsp;</td>
                             <td><div></div>&nbsp;</td>
                             <td><div></div>&nbsp;</td>
                             <td colspan="2">
                             </td>
                           </tr>
                           <tr>
                             <td colspan ="3">
                                <div class="bandheader">Schedule Zone Type (Can only be assigned to one): </div>
                             </td>
                             <td>
                                <div></div>
                             </td>
                             <td>
                                <div class="bandheader">Day Off Start </div>
                             </td>
                             <td>
                                <div class="bandheader">Day Off End</div>
                             </td>
                           </tr>
                           <tr>
                             <td colspan ="3">
                                <div><asp:DropDownList ID="drpScheduleZoneTypes"  runat="server"  AutoPostBack="true" />&nbsp;&nbsp;<asp:DropDownList ID="drpWeekDays"  runat="server"  AutoPostBack="False" />&nbsp;&nbsp;<asp:Button ID="btnSet" runat="server" Text="View" OnClick="btnSet_Click"  /></div>
                             </td>
                             <td>
                                <div></div>
                             </td>
                             <td>
                                <div>
                                    <rad:RadDatePicker ID="RadDatePicker1" runat="server" width="180px" Height="19" DateInput-Font-Size="Small" OnSelectedDateChanged ="ShowSchedules" AutoPostBack="true">
                                    </rad:RadDatePicker>
                                    </div>
                             </td>
                             <td><rad:RadDatePicker ID="RadDatePicker2" runat="server" width="180px" Height="19" DateInput-Font-Size="Small" OnSelectedDateChanged ="ShowSchedules" AutoPostBack="true">
                                    </rad:RadDatePicker>&nbsp;&nbsp;&nbsp;<asp:Button ID="btnSetDayOff" runat="server" Text="Set Days Off" OnClick="btnSetDayOff_Click"  />
                             </td>
                           </tr>
                           <tr>
                             <td ></td>
                             <td></td>
                             <td></td>
                            
                           </tr>
                           <tr>
                         <td colspan ="2">
                            <div class="inputformsectionheader"><asp:label ID="Label1" runat="server" />&nbsp;Associated&nbsp;Schedule&nbsp;Zone(s)</div>
                            <asp:DataGrid ID="dgvAssignedScheduleAvailabilityZones" style="width: 100%" runat="server" AutoGenerateColumns="false">
                               <AlternatingItemStyle CssClass="altrow" />
                                  <HeaderStyle CssClass="gridheader" />
                                     <Columns>
                                         <asp:BoundColumn HeaderText="ID" DataField="ScheduleZoneTemplateID" visible="false" />
                                         <asp:BoundColumn HeaderText="PartnerAgentAvailabilityID" DataField="PartnerAgentAvailabilityID" visible="false" />
                                         <asp:TemplateColumn HeaderText="Remove">
                                            <ItemTemplate>
                                               <a href="removePartnerAgentAvailability.aspx?id=<%# DataBinder.eval(Container.DataItem,"PartnerAgentAvailabilityID") %>&returnurl=Availability.aspx%3fid=<%# _ID %>">Remove</a>     
                                            </ItemTemplate>
                                         </asp:TemplateColumn>
                                         <asp:BoundColumn HeaderText="Type" DataField="ZoneName" />                 
                                         <asp:TemplateColumn HeaderText="ZoneName"  >
                                            <ItemTemplate>
                                               <%# CType(DataBinder.Eval(Container.DataItem, "StartScheduleTime"), Date).ToString("HH:mm") %> - <%# CType(DataBinder.Eval(Container.DataItem, "EndScheduleTime"), Date).ToString("HH:mm") %>
                                            </ItemTemplate>
                                         </asp:TemplateColumn>
                                         <asp:TemplateColumn HeaderText="Select" >
                                           <ItemTemplate>
                                              <asp:CheckBox ID="chkSelect" runat="server" />
                                           </ItemTemplate>
                                         </asp:TemplateColumn>
                                     </Columns>                
                               </asp:DataGrid>  
                         </td>
                         <td>&nbsp;</td>
                         <td>&nbsp;</td>
                         <td colspan="2">
                           <div class="inputformsectionheader"> <asp:label ID="UnAssignedScheduleZones" runat="server" />&nbsp;Un-Associated&nbsp;Schedule&nbsp;Zone(s)</div>
                           <asp:DataGrid ID="dgvUnAssignedScheduleAvailabilityZones" style="width: 100%" runat="server" AutoGenerateColumns="false">
                               <AlternatingItemStyle CssClass="altrow" />
                                  <HeaderStyle CssClass="gridheader" />
                                     <Columns>
                                         <asp:BoundColumn HeaderText="ID" DataField="ScheduleZoneTemplateID" visible="false" />
                                         <asp:TemplateColumn HeaderText="Add">
                                            <ItemTemplate>
                                               <asp:CheckBox ID="chkSelected" runat="server" />
                                            </ItemTemplate>
                                         </asp:TemplateColumn>
                                         <asp:BoundColumn HeaderText="Type" DataField="ZoneName" />                 
                                         <asp:TemplateColumn HeaderText="ZoneName"  >
                                            <ItemTemplate>
                                               <%# CType(DataBinder.Eval(Container.DataItem, "StartScheduleTime"), Date).ToString("HH:mm") %> - <%# CType(DataBinder.Eval(Container.DataItem, "EndScheduleTime"), Date).ToString("HH:mm") %>
                                            </ItemTemplate>
                                         </asp:TemplateColumn>
                                     </Columns>                
                               </asp:DataGrid> 
                              
                            </td>
                      </tr>
                         </table>
                         <div>&nbsp;&nbsp;</div><div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnApply" runat="server" OnClick="btnApply_Click" Text="Apply" /></div>
                         </div>
                         <div><asp:Button OnClick="btnRemove_Click" ID="btnRemove" runat="server" Text="Remove Days Off" /></div>
                         <div class="inputformsectionheader" style="width:100%">List of Schedules & Days Off</div>
                         <asp:DataGrid style="background-color: White;" ID="dgvShowAvailabilityforDay" runat="server" AutoGenerateColumns="false">
                          <HeaderStyle CssClass="gridheader" />
                          <AlternatingItemStyle CssClass="altrow" />
                          <Columns>
                            <asp:BoundColumn HeaderText="ID" DataField="ScheduleAvailabilityAssignmentID" Visible="false"  />
                            <asp:TemplateColumn HeaderText="Select" >
                               <HeaderTemplate>
                                 <asp:CheckBox id="chkAll" runat="server"  OnCheckedChanged ="chkAll_OnCheckedChanged" AutoPostBack = "True"></asp:CheckBox>
                               </HeaderTemplate>
                               <ItemTemplate>
                                  <asp:CheckBox ID="chkRemove" runat="server"  />
                               </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:BoundColumn HeaderText="Date" DataField="dateSet" />
                            <asp:BoundColumn HeaderText="Type" DataField="ZoneName"  />
                            <asp:BoundColumn HeaderText="Schedule Start" DataField="ScheduleStart"  />
                            <asp:BoundColumn HeaderText="Schedule End" DataField="ScheduleEnd" />
                            <asp:BoundColumn HeaderText="Status" DataField="CodeName"  />
                            <asp:TemplateColumn HeaderText="TicketID">
                              <ItemTemplate>
                                 <a href="ticket.aspx?act=B&id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>" target ="_blank"><%# DataBinder.Eval(Container.DataItem,"TicketID")%> </a>
                              </ItemTemplate>
                            </asp:TemplateColumn>
                          </Columns>    
                        </asp:DataGrid>
                       </td>
                       <td></td>
                       <td></td>
                     </tr>
                   </table> 
  </form>
</asp:Content>