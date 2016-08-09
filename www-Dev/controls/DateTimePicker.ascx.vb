''' <summary>
''' A control that allows a user to select a date and time
''' </summary>
''' <remarks>
'''   Completed: 08/29/2007
'''   Author: Bill Hedge
'''   Modifications: None
''' </remarks>
Partial Class controls_DateTimePicker
  Inherits System.Web.UI.UserControl

#Region "Private Members"

  Private _YearLower As Long = 5
  Private _YearUpper As Long = 5
  Private _datNothing As Date = Nothing

#End Region

#Region "Public Properties"

  ''' <summary>
  ''' Returns/sets the date value of the control
  ''' </summary>
  Public Property DateValue() As Date
    Get
      Return ReturnDate()
    End Get
    Set(ByVal value As Date)
      If value <> _datNothing Then
        cbxYears.SelectedValue = value.Year.ToString("0000")
        cbxDays.SelectedValue = value.Day.ToString("00")
        cbxMonths.SelectedValue = value.Month
        cbxHours.SelectedValue = value.Hour.ToString("00")
        cbxMinutes.SelectedValue = value.Minute.ToString("00")
      Else
        cbxYears.SelectedValue = 0
        cbxDays.SelectedValue = 0
        cbxMonths.SelectedValue = 0
        cbxHours.SelectedValue = 0
        cbxMinutes.SelectedValue = 0
      End If
    End Set
  End Property

  ''' <summary>
  ''' Returns/Sets whether or not the minute portion of the control is visible
  ''' </summary>
  Public Property MinuteVisible() As Boolean
    Get
      Return tdMinute.Visible
    End Get
    Set(ByVal value As Boolean)
      tdMinute.Visible = value
      tdMinuteData.Visible = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/Sets whether or not the hour portion of the control is visible
  ''' </summary>
  Public Property HourVisible() As Boolean
    Get
      Return tdHour.Visible
    End Get
    Set(ByVal value As Boolean)
      tdHour.Visible = value
      tdHourData.Visible = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/Sets whether or not the day portion of the control is visible
  ''' </summary>
  Public Property DayVisible() As Boolean
    Get
      Return tdDay.Visible
    End Get
    Set(ByVal value As Boolean)
      tdDay.Visible = value
      tdDayData.Visible = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/Sets whether or not the month portion of the control is visible
  ''' </summary>
  Public Property MonthVisible() As Boolean
    Get
      Return tdMonth.Visible
    End Get
    Set(ByVal value As Boolean)
      tdMonth.Visible = value
      tdMonthData.Visible = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/Sets whether or not the year portion of the control is visible
  ''' </summary>
  Public Property YearVisible() As Boolean
    Get
      Return tdYear.Visible
    End Get
    Set(ByVal value As Boolean)
      tdYear.Visible = value
      tdYearData.Visible = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/Sets how many years to go back (from this year)
  ''' </summary>
  Public Property YearLower() As Long
    Get
      Return _YearLower
    End Get
    Set(ByVal value As Long)
      _YearLower = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/Sets how many years to go forward (from this year)
  ''' </summary>
  Public Property YearUpper() As Long
    Get
      Return _YearUpper
    End Get
    Set(ByVal value As Long)
      _YearUpper = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/Sets the minute value
  ''' </summary>
  Public Property Minutes() As Integer
    Get
      Return cbxMinutes.SelectedValue
    End Get
    Set(ByVal value As Integer)
      cbxMinutes.SelectedValue = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/Sets the hour value
  ''' </summary>  
  Public Property Hour() As Integer
    Get
      Return cbxHours.SelectedValue
    End Get
    Set(ByVal value As Integer)
      cbxHours.SelectedValue = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/Sets the year value
  ''' </summary>
  Public Property Year() As Integer
    Get
      Return cbxYears.SelectedValue
    End Get
    Set(ByVal value As Integer)
      cbxYears.SelectedValue = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/Sets the day value
  ''' </summary>
  Public Property Day() As Integer
    Get
      Return cbxDays.SelectedValue
    End Get
    Set(ByVal value As Integer)
      cbxDays.SelectedValue = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/Sets the month value
  ''' </summary>
  Public Property Month() As Integer
    Get
      Return cbxMonths.SelectedValue
    End Get
    Set(ByVal value As Integer)
      cbxMonths.SelectedValue = value
    End Set
  End Property

#End Region

#Region "Read Only Properties"
  ''' <summary>
  ''' Returns whether the date is valid or not
  ''' </summary>
  Public ReadOnly Property Validates() As Boolean
    Get
      Return DateValidates()
    End Get
  End Property

#End Region

#Region "Private Sub Routines"
  ''' <summary>
  ''' Loads values into the dropdownlists for Year, Month, Day, Hours, and Minutes
  ''' </summary>
  Private Sub LoadCombos()
    Dim I As Integer = 0
    Dim itm As ListItem
    itm = New ListItem("[Choose One]", 0)
    cbxYears.Items.Clear()
    cbxMonths.Items.Clear()
    cbxDays.Items.Clear()
    cbxHours.Items.Clear()
    cbxMinutes.Items.Clear()
    cbxYears.Items.Add(itm)
    cbxMonths.Items.Add(itm)
    cbxDays.Items.Add(itm)
    For I = DateTime.Now.Year - _YearLower To DateTime.Now.Year + _YearUpper
      cbxYears.Items.Add(I)
    Next
    For I = 1 To 12
      itm = New ListItem(MonthName(I, True), I)
      cbxMonths.Items.Add(itm)
    Next
    For I = 1 To 31
      cbxDays.Items.Add(I.ToString)
    Next
    For I = 0 To 23
      cbxHours.Items.Add(I.ToString("00"))
    Next
    For I = 0 To 59
      cbxMinutes.Items.Add(I.ToString("00"))
    Next
  End Sub
#End Region

#Region "Protected Sub Routines"
  ''' <summary>
  ''' Initialized the form
  ''' </summary>
  ''' <param name="sender">Sender</param>
  ''' <param name="e">Event Arguments</param>
  Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs)
    If Not IsPostBack Then
      LoadCombos()
    End If
  End Sub

#End Region

#Region "Private Functions"
  ''' <summary>
  ''' Returns a date based on the values selected in the date/time dropdownlists
  ''' </summary>
  ''' <returns>A Date</returns>
  Private Function ReturnDate() As Date
    Dim datReturn As Date = Nothing
    Dim strTemp As String = cbxMonths.SelectedValue & "/" & cbxDays.SelectedValue & "/" & cbxYears.SelectedValue & " " & cbxHours.SelectedValue & ":" & cbxMinutes.SelectedValue
    If (CType(cbxYears.SelectedValue, Integer) = 0) Or (CType(cbxMonths.SelectedValue, Integer) = 0) Or (CType(cbxDays.SelectedValue, Integer) = 0) Then
      datReturn = Nothing
    Else
      If Date.TryParse(strTemp, datReturn) Then
        datReturn = CType(strTemp, Date)
      Else
        datReturn = Nothing
      End If
    End If
    Return datReturn
  End Function

  ''' <summary>
  ''' Returns whether the selected date/time combination is a validate date
  ''' </summary>
  ''' <returns>Boolean indication of valid date/time</returns>
  Private Function DateValidates() As Boolean
    Dim blnReturn As Boolean = True
    Dim dat As Date = Nothing
    Dim strTemp As String = cbxMonths.SelectedValue & "/" & cbxDays.SelectedValue & "/" & cbxYears.SelectedValue & " " & cbxHours.SelectedValue & ":" & cbxMinutes.SelectedValue
    If (CType(cbxYears.SelectedValue, Integer) = 0) Or (CType(cbxMonths.SelectedValue, Integer) = 0) Or (CType(cbxDays.SelectedValue, Integer) = 0) Then
      blnReturn = True
    Else
      blnReturn = Date.TryParse(strTemp, dat)
    End If
    Return blnReturn
  End Function

#End Region

End Class