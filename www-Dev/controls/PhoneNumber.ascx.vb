''' <summary>
''' A control that allows a user to enter a phone number aloing with an extension, PIN, and type
''' </summary>
''' <remarks>
'''   Completed: 08/29/2007
'''   Author: Bill Hedge
'''   Modifications: None
''' </remarks>
Partial Class controls_PhoneNumber
  Inherits System.Web.UI.UserControl

#Region "Private Members"
  Private _Text As String = ""
  Private _RequirePhone As Boolean = False
  Private _RequireExtension As Boolean = False
  Private _RequirePin As Boolean = False
  Private _RequirePhoneType As Boolean = False
#End Region

#Region "Public Properties"
  ''' <summary>
  ''' Returns/sets whether the phone number is required
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
  ''' Returns/sets the numeric ID of the type of phone number
  ''' </summary>
  Public Property PhoneTypeID() As Long
    Get
      Return CType(cbxPhoneTypes.SelectedValue, Long)
    End Get
    Set(ByVal value As Long)
      If Not IsPostBack Then
        LoadPhoneTypes()
      End If
      cbxPhoneTypes.SelectedValue = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the area code for the phone number
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
  ''' Returns/sets the exchange for the phone number
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
  ''' Returns/sets the line number for the phone number
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
  ''' Returns/sets the extension for the phone number
  ''' </summary>
  Public Property Extension() As String
    Get
      Return txtExtension.Text
    End Get
    Set(ByVal value As String)
      txtExtension.Text = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/Sets the PIN for the phone number
  ''' </summary>
  Public Property Pin() As String
    Get
      Return txtPin.Text
    End Get
    Set(ByVal value As String)
      txtPin.Text = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the text property for lblPhoneNumber
  ''' </summary>
  Public Property Text() As String
    Get
      Return _Text
    End Get
    Set(ByVal value As String)
      _Text = value
      If _RequirePhone Then
        lblPhoneNumber.Text = _Text.Trim & " *"
        lblPhoneNumber.Attributes("style") = "font-weight: bold; font-style: italic;"
      Else
        lblPhoneNumber.Text = _Text.Trim
      End If
    End Set
  End Property
#End Region

#Region "Private Sub-Routines"
  ''' <summary>
  ''' Loads all the phone types into the appropriate combo
  ''' </summary>
  Private Sub LoadPhoneTypes()
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListPhoneTypes")
    Dim itm As ListItem
    cmd.CommandType = Data.CommandType.StoredProcedure
    cnn.Open()
    cmd.Connection = cnn
    Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
    cbxPhoneTypes.Items.Clear()
    While dtr.Read
      itm = New ListItem
      itm.Text = dtr("PhoneType")
      itm.Value = dtr("PhoneTypeID")
      cbxPhoneTypes.Items.Add(itm)
    End While
    cnn.Close()
  End Sub

  ''' <summary>
  ''' Initializes the form
  ''' </summary>
  ''' <param name="S">Sender</param>
  ''' <param name="E">Event Arguments</param>
  Private Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
    If _RequirePhone Then
      lblPhoneNumber.Text = _Text.Trim & " *"
      lblPhoneNumber.Attributes("style") = "font-weight: bold; font-style: italic;"
    Else
      lblPhoneNumber.Text = _Text.Trim
    End If
    If _RequireExtension Then
      lblExtension.Text = "Extension *"
      lblExtension.Attributes("style") = "font-weight: bold; font-style: italic;"
    Else
      lblExtension.Text = "Extension"
    End If
    If _RequirePin Then
      lblPin.Text = "Pin *"
      lblPin.Attributes("style") = "font-weight: bold; font-style: italic;"
    Else
      lblPin.Text = "Pin"
    End If
    If _RequirePhoneType Then
      lblPhoneType.Text = "Phone Type *"
      lblPhoneType.Attributes("style") = "font-weight: bold; font-style: italic;"
    Else
      lblPhoneType.Text = "Phone Type"
    End If
    If Not IsPostBack Then
      LoadPhoneTypes()
    End If
  End Sub
#End Region

End Class