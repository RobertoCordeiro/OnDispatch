''' <summary>
''' A control that allows a user to enter a phone number
''' </summary>
''' <remarks>
'''   Completed: 08/29/2007
'''   Author: Bill Hedge
'''   Modifications: None
''' </remarks>
Partial Class controls_BasicPhoneNumber
  Inherits System.Web.UI.UserControl

#Region "Private Members"
  Private _Text As String = ""
  Private _RequirePhone As Boolean = False
#End Region

#Region "Public Properties"
  ''' <summary>
  ''' Returns/sets whether the Phone Number is required or not
  ''' </summary>
  Public Property RequirePhone() As Boolean
    Get
      Return _RequirePhone
    End Get
    Set(ByVal value As Boolean)
      _RequirePhone = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the Area Code
  ''' </summary>
  Public Property AreaCode() As String
    Get
      Return txtAreaCode.Text
    End Get
    Set(ByVal value As String)
      txtAreaCode.Text = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the Exchange
  ''' </summary>
  Public Property Exchange() As String
    Get
      Return txtExchange.Text
    End Get
    Set(ByVal value As String)
      txtExchange.Text = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the Line Number
  ''' </summary>
  Public Property LineNumber() As String
    Get
      Return txtLineNumber.Text
    End Get
    Set(ByVal value As String)
      txtLineNumber.Text = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the text for lblPhoneNumber
  ''' </summary>
  Public Property Text() As String
    Get
      Return _Text
    End Get
    Set(ByVal value As String)
      _Text = value
      If _RequirePhone Then
        lblPhoneNumber.Text = _Text.Trim & " *"
                lblPhoneNumber.Attributes("style") = "font-weight: bold; "
      Else
        lblPhoneNumber.Text = _Text.Trim
      End If
    End Set
  End Property
#End Region

#Region "Private Sub-Routines"
  ''' <summary>
  ''' Initializes the form
  ''' </summary>
  ''' <param name="S">Sender</param>
  ''' <param name="E">Event Arguments</param>
  Private Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
    If _RequirePhone Then
      lblPhoneNumber.Text = _Text.Trim & " *"
            lblPhoneNumber.Attributes("style") = "font-weight: bold; "
    Else
      lblPhoneNumber.Text = _Text.Trim
    End If
  End Sub

#End Region

End Class