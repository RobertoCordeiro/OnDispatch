''' <summary>
''' A page that allows a user to add or delete availabilities within his online resume
''' </summary>
''' <remarks>
'''   Completed: 08/23/2007
'''   Author: Bill Hedge
'''   Modifications: None
''' </remarks>
Public Class EditTimeSlot
  Inherits System.Web.UI.Page

#Region "Private Members"
  Private _ID As Long = 0
#End Region

#Region "Protected Sub-Routines"
  Protected Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageTitleText = "Edit Time Slot"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = "detail.aspx"
    If _ID > 0 Then
      Dim wdy As New BridgesInterface.WeekDayRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      wdy.Load(_ID)
      lblDay.Text = "Edit Availability for " & wdy.DayName
      If Not IsPostBack Then
        StuffHourBox(cbxStartHour)
        StuffHourBox(cbxEndHour)
        StuffMinuteBox(cbxStartMinute)
        StuffMinuteBox(cbxEndMinute)
        LoadTimeSlots()
      End If
    Else
      divForm.Visible = False
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub

#End Region

#Region "Private Sub-Routines"
  Private Sub LoadTimeSlots()
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListResumeTimeSlotsForDay")
    cmd.CommandType = Data.CommandType.StoredProcedure
    cmd.Parameters.Add("@ResumeID", Data.SqlDbType.Int).Value = Master.ResumeID
    cmd.Parameters.Add("@WeekDayID", Data.SqlDbType.TinyInt).Value = _ID
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvTimeSlots.DataSource = ds
    dgvTimeSlots.DataBind()
    cnn.Close()
  End Sub

  Private Sub StuffHourBox(ByRef cbx As DropDownList)
    cbx.Items.Clear()
    Dim itm As ListItem
    For X As Integer = 0 To 23
      itm = New ListItem
      itm.Value = X
      itm.Text = X.ToString("00")
      cbx.Items.Add(itm)
    Next
  End Sub

  Private Sub StuffMinuteBox(ByRef cbx As DropDownList)
    cbx.Items.Clear()
    Dim itm As ListItem
    For X As Integer = 0 To 59
      itm = New ListItem
      itm.Value = X
      itm.Text = X.ToString("00")
      cbx.Items.Add(itm)
    Next
  End Sub

#End Region

#Region "Private Functions"
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    Dim lngStart As Long = (CType(cbxStartHour.Text, Long)) * 60 + CType(cbxStartMinute.Text, Long)
    Dim lngEnd As Long = (CType(cbxEndHour.Text, Long)) * 60 + CType(cbxEndMinute.Text, Long)
    If lngStart + lngEnd = 0 Then
      strErrors &= "<li>You Must Enter a Range</li>"
      blnReturn = False
    Else
      If lngStart >= lngEnd Then
        blnReturn = False
        strErrors &= "<li>End Time Must Be Greater Than Start Time</li>"
      End If
    End If
    divError.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function

#End Region

#Region "Event Handlers"
  Protected Sub btnSubmit_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub

  Protected Sub btnAdd_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      divError.Visible = False
      Dim slt As New BridgesInterface.ResumeTimeSlotRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      slt.Add(Master.UserID, _ID, Master.ResumeID, CType(cbxStartHour.Text, Integer), CType(cbxStartMinute.Text, Integer), CType(cbxEndHour.Text, Integer), CType(cbxEndMinute.Text, Integer))
      LoadTimeSlots()
    Else
      divError.Visible = True
    End If
  End Sub

  Protected Sub btnDeleteTimeSlot_Click(ByVal S As Object, ByVal E As DataGridCommandEventArgs)
    Dim slt As New BridgesInterface.ResumeTimeSlotRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    slt.Load(CType(E.Item.Cells(0).Text, Long))
    If slt.ResumeTimeSlotID > 0 Then
      slt.Delete()
    End If
    LoadTimeSlots()
  End Sub

#End Region

End Class