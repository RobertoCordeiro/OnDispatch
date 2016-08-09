''' <summary>
''' A control that allows a user to create/view a ticket
''' </summary>
''' <remarks>
'''   Completed: 08/29/2007
'''   Author: Bill Hedge
'''   Modifications: None
''' </remarks>
Partial Class controls_ticket
  Inherits System.Web.UI.UserControl

#Region "Private Members"
  Private _Priority As Long = 0
  Private _TicketID As Long = 0
  Private _Company As String = ""
  Private _Phone As String = ""
  Private _Status As String = ""
  Private _Contact As String = ""
  Private _Scheduled As String = ""
  Private _Street As String = ""
  Private _ServiceStart As String = ""
  Private _ServiceEnd As String = ""
  Private _Ref1 As String = ""
  Private _Ref2 As String = ""
  Private _Ref3 As String = ""
  Private _Ref4 As String = ""
  Private _Extended As String = ""
  Private _City As String = ""
  Private _State As String = ""
  Private _Zip As String = ""
  Private _Completed As String = ""
  Private _Created As String = ""
  Private _POCAddress As String = ""
  Private _POCLabel As String = ""
  Private _Description As String = ""
  Private _Instructions As String = ""
  Private _Notes As String = ""
#End Region

#Region "Public Properties"
  ''' <summary>
  ''' Returns/sets the Notes for the ticket
  ''' </summary>
  Public Property Notes() As String
    Get
      Return _Notes
    End Get
    Set(ByVal value As String)
      _Notes = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the instructions for the ticket
  ''' </summary>
  Public Property Instructions() As String
    Get
      Return _Instructions
    End Get
    Set(ByVal value As String)
      _Instructions = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the Description for the ticket
  ''' </summary>
  Public Property Description() As String
    Get
      Return _Description
    End Get
    Set(ByVal value As String)
      _Description = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the POC Label for the ticket
  ''' </summary>
  Public Property POCLabel() As String
    Get
      Return _POCLabel
    End Get
    Set(ByVal value As String)
      _POCLabel = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the POC Address for the ticket
  ''' </summary>
  Public Property POCAddress() As String
    Get
      Return _POCAddress
    End Get
    Set(ByVal value As String)
      _POCAddress = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the Created (date) for the ticket
  ''' </summary>
  Public Property Created() As String
    Get
      Return _Created
    End Get
    Set(ByVal value As String)
      _Created = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the Completed (date) for the ticket
  ''' </summary>
  Public Property Completed() As String
    Get
      Return _Completed
    End Get
    Set(ByVal value As String)
      _Completed = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the ZIP Code for the ticket
  ''' </summary>
  Public Property Zip() As String
    Get
      Return _Zip
    End Get
    Set(ByVal value As String)
      _Zip = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the State for the ticket
  ''' </summary>
  Public Property State() As String
    Get
      Return _State
    End Get
    Set(ByVal value As String)
      _State = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the City for the ticket
  ''' </summary>
  Public Property City() As String
    Get
      Return _City
    End Get
    Set(ByVal value As String)
      _City = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the Extended address for the ticket
  ''' </summary>
  Public Property Extended() As String
    Get
      Return _Extended
    End Get
    Set(ByVal value As String)
      _Extended = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the Ref4 string for the ticket
  ''' </summary>
  Public Property Ref4() As String
    Get
      Return _Ref4
    End Get
    Set(ByVal value As String)
      _Ref4 = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the Ref3 string for the ticket
  ''' </summary>
  Public Property Ref3() As String
    Get
      Return _Ref3
    End Get
    Set(ByVal value As String)
      _Ref3 = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the Ref2 string for the ticket
  ''' </summary>
  Public Property Ref2() As String
    Get
      Return _Ref2
    End Get
    Set(ByVal value As String)
      _Ref2 = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the Ref1 string for the ticket
  ''' </summary>
  Public Property Ref1() As String
    Get
      Return _Ref1
    End Get
    Set(ByVal value As String)
      _Ref1 = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the Service End (date/time) for the ticket
  ''' </summary>
  Public Property ServiceEnd() As String
    Get
      Return _ServiceEnd
    End Get
    Set(ByVal value As String)
      _ServiceEnd = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the Service Start (date/time) for the ticket
  ''' </summary>
  Public Property ServiceStart() As String
    Get
      Return _ServiceStart
    End Get
    Set(ByVal value As String)
      _ServiceStart = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the Street address for the ticket
  ''' </summary>
  Public Property Street() As String
    Get
      Return _Street
    End Get
    Set(ByVal value As String)
      _Street = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the Scheduled (date) for the ticket
  ''' </summary>
  Public Property Scheduled() As String
    Get
      Return _Scheduled
    End Get
    Set(ByVal value As String)
      _Scheduled = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the Contact for the ticket
  ''' </summary>
  Public Property Contact() As String
    Get
      Return _Contact
    End Get
    Set(ByVal value As String)
      _Contact = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the Status for the ticket
  ''' </summary>
  Public Property Status() As String
    Get
      Return _Status
    End Get
    Set(ByVal value As String)
      _Status = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the Phone number for the ticket
  ''' </summary>
  Public Property Phone() As String
    Get
      Return _Phone
    End Get
    Set(ByVal value As String)
      _Phone = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the Company name for the ticket
  ''' </summary>
  Public Property Company() As String
    Get
      Return _Company
    End Get
    Set(ByVal value As String)
      _Company = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the Ticket ID for the ticket
  ''' </summary>
  Public Property TicketID() As Long
    Get
      Return _TicketID
    End Get
    Set(ByVal value As Long)
      _TicketID = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the Priority of the ticket
  ''' </summary>
  Public Property Priority() As Long
    Get
      Return _Priority
    End Get
    Set(ByVal value As Long)
      _Priority = value
    End Set
  End Property
#End Region

#Region "Public Sub-Routine"
  ''' <summary>
  ''' Initializes the form
  ''' </summary>
  ''' <param name="S">Sender</param>
  ''' <param name="E">Event Arguments</param>
  Public Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
    imgPriority.ImageAlign = ImageAlign.Baseline
    imgPriority.AlternateText = "Priority " & _Priority.ToString
    imgPriority.ImageUrl = "../graphics/level" & _Priority.ToString & ".png"
    lblPriority.Text = _Priority.ToString
    lblTicketID.Text = _TicketID.ToString
    lblCompany.Text = FilterString(_Company.ToString)
    lblPhone.Text = FilterString(_Phone.Trim)
    lblStatus.Text = FilterString(_Status.Trim)
    lblContact.Text = FilterString(_Contact.Trim)
    If _Scheduled.Trim.Length > 0 Then
      lblSchedule.Text = FilterString(_Scheduled.Trim)
    Else
      lblSchedule.Text = "---"
    End If
    lblStreet.Text = FilterString(_Street)
    If _ServiceStart.Trim.Length > 0 Then
      lblServiceStart.Text = FilterString(_ServiceStart.Trim)
    Else
      lblServiceStart.Text = "---"
    End If
    If _ServiceEnd.Trim.Length > 0 Then
      lblServiceEnd.Text = FilterString(_ServiceEnd.Trim)
    Else
      lblServiceEnd.Text = "---"
    End If
    lblRef1.Text = FilterString(_Ref1)
    lblRef2.Text = FilterString(_Ref2)
    lblRef3.Text = FilterString(_Ref3)
    lblRef4.Text = FilterString(_Ref4)
    lblExtended.Text = FilterString(_Extended)
    lblCity.Text = FilterString(_City)
    lblState.Text = FilterString(_State)
    lblZip.Text = FilterString(_Zip)
    lblCompleted.Text = FilterString(_Completed)
    lblCreated.Text = FilterString(_Created)
    If _POCAddress.Trim.Length > 0 Then
      lnkPOC.NavigateUrl = "mailto:" & _POCAddress
      lnkPOC.Text = FilterString(_POCLabel)
    Else
      lnkPOC.NavigateUrl = "mailto:" & System.Configuration.ConfigurationManager.AppSettings("DefaultCompanyEmail")
      lnkPOC.Text = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName")
    End If
    divDescription.InnerHtml = FilterString(_Description)
    divInstructions.InnerHtml = FilterString(_Instructions)
    divNotes.InnerHtml = FilterString(_Notes)
  End Sub
#End Region

#Region "Private Functions"
  ''' <summary>
  ''' Returns a string after performing some string replacements
  ''' </summary>
  ''' <param name="strInput">Input</param>
  ''' <returns>String</returns>
  Private Function FilterString(ByVal strInput As String) As String
    Dim strReturn As String = strInput
    If strReturn.Trim.Length = 0 Then
      strReturn = "&nbsp;"
    End If
    strReturn = strReturn.Replace("<", "&lt;")
    strReturn = strReturn.Replace(">", "&gt;")
    strReturn = strReturn.Replace(System.Environment.NewLine, "<br />")
    Return strReturn
  End Function
#End Region

End Class