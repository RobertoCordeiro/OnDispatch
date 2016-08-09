''' <summary>
''' A control that allows a user to enter an address and type of address
''' </summary>
''' <remarks>
'''   Completed: 08/29/2007
'''   Author: Bill Hedge
'''   Modifications: None
''' </remarks>
Partial Class controls_Address
  Inherits System.Web.UI.UserControl

#Region "Private Members"
  Private _RequireStreet As Boolean = False
  Private _RequireExtended As Boolean = False
  Private _RequireCity As Boolean = False
  Private _RequireState As Boolean = False
  Private _RequireZip As Boolean = False
  Private _RequireAddressType As Boolean = False
  Private _ShowType As Boolean = True
#End Region

#Region "Public Properties"
  ''' <summary>
  ''' Returns/Sets if the Address Type is required
  ''' </summary>
  Public Property RequireAddressType() As Boolean
    Get
      Return _RequireAddressType
    End Get
    Set(ByVal value As Boolean)
      _RequireAddressType = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the type of address
  ''' </summary>
  Public Property ShowType() As Boolean
    Get
      Return _ShowType
    End Get
    Set(ByVal value As Boolean)
      _ShowType = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/Sets if the extended portion of the address is required
  ''' </summary>
  Public Property RequireExtended() As Boolean
    Get
      Return _RequireExtended
    End Get
    Set(ByVal value As Boolean)
      _RequireExtended = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/Sets if the street is required
  ''' </summary>
  Public Property RequireStreet() As Boolean
    Get
      Return _RequireStreet
    End Get
    Set(ByVal value As Boolean)
      _RequireStreet = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/Sets if the city is required
  ''' </summary>
  Public Property RequireCity() As Boolean
    Get
      Return _RequireCity
    End Get
    Set(ByVal value As Boolean)
      _RequireCity = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/Sets if the state is required
  ''' </summary>
  Public Property RequireState() As Boolean
    Get
      Return _RequireState
    End Get
    Set(ByVal value As Boolean)
      _RequireState = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/Sets if the Zip is required
  ''' </summary>
  Public Property RequireZip() As Boolean
    Get
      Return _RequireZip
    End Get
    Set(ByVal value As Boolean)
      _RequireZip = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/Sets the street portion for this address
  ''' </summary>  
  Public Property Street() As String
    Get
      Return txtStreet.Text
    End Get
    Set(ByVal value As String)
      txtStreet.Text = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/Sets the extended portion for this address
  ''' </summary>
  Public Property Extended() As String
    Get
      Return txtExtended.Text
    End Get
    Set(ByVal value As String)
      txtExtended.Text = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/Sets the city for this address
  ''' </summary>
  Public Property City() As String
    Get
      Return txtCity.Text
    End Get
    Set(ByVal value As String)
      txtCity.Text = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/Sets the StateID for this address
  ''' </summary>
  Public Property StateID() As Long
    Get
      Return CType(cbxStates.SelectedValue, Long)
    End Get
    Set(ByVal value As Long)
      If Not IsPostBack Then
        LoadStates()
      End If
      cbxStates.SelectedValue = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/Sets the Zip for this address
  ''' </summary>
  Public Property Zip() As String
    Get
      Return txtZip.Text
    End Get
    Set(ByVal value As String)
      txtZip.Text = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/Sets the AddressTypeID for this address
  ''' </summary>
  Public Property AddressTypeID() As Long
    Get
      Return CType(cbxAddressTypes.SelectedValue, Long)
    End Get
    Set(ByVal value As Long)
      If Not IsPostBack Then
        LoadAddressTypes()
      End If
      cbxAddressTypes.SelectedValue = value
    End Set
  End Property
#End Region

#Region "Public Sub-Routines"
  ''' <summary>
  ''' Initializes the form
  ''' </summary>
  ''' <param name="S">Sender</param>
  ''' <param name="E">Event Arguments</param>
  Public Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)

    lblAddressType.Visible = _ShowType
    cbxAddressTypes.Visible = _ShowType
    If _RequireStreet Then
      lblStreet.Text = "Street *"
            lblStreet.Attributes("style") = "font-weight: bold; "
    Else
      lblStreet.Text = "Street"
    End If
    If _RequireExtended Then
      lblExtended.Text = "Apt/Suite/Etc. *"
            lblExtended.Attributes("style") = "font-weight: bold; "
    Else
      lblExtended.Text = "Apt/Suite/Etc."
    End If
    If _RequireCity Then
      lblCity.Text = "City *"
            lblCity.Attributes("style") = "font-weight: bold; "
    Else
      lblCity.Text = "City"
    End If
    If _RequireZip Then
      lblZip.Text = "Zip *"
            lblZip.Attributes("style") = "font-weight: bold; "
    Else
      lblZip.Text = "Zip"
    End If
    If _RequireState Then
      lblState.Text = "State *"
            lblState.Attributes("style") = "font-weight: bold; "
    Else
      lblState.Text = "State"
    End If
    If _RequireAddressType Then
      lblAddressType.Text = "Address Type *"
            lblAddressType.Attributes("style") = "font-weight: bold; ;"
    Else
      lblAddressType.Text = "Address Type"
    End If
    If Not IsPostBack() Then
      LoadStates()
      LoadAddressTypes()
    End If
  End Sub
#End Region

#Region "Private Sub-Routines"
  ''' <summary>
  ''' Loads the states into the appropriate combo
  ''' </summary>
  Private Sub LoadStates()
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListStates")
    Dim itm As ListItem
    Dim lngSelectedValue As Long = 0
    If Long.TryParse(cbxStates.SelectedValue, lngSelectedValue) Then
      lngSelectedValue = CType(cbxStates.SelectedValue, Long)
    End If
    cmd.CommandType = Data.CommandType.StoredProcedure
    cnn.Open()
    cmd.Connection = cnn
    Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
    cbxStates.Items.Clear()
    While dtr.Read
      itm = New ListItem
      itm.Text = dtr("StateName")
      itm.Value = dtr("StateID")
      cbxStates.Items.Add(itm)
    End While
    If lngSelectedValue > 0 Then
      cbxStates.SelectedValue = lngSelectedValue.ToString
    End If
    cnn.Close()
  End Sub

  ''' <summary>
  ''' Loads all the address types into the appropriate combo
  ''' </summary>
  Private Sub LoadAddressTypes()
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListAddressTypes")
    Dim itm As ListItem
    Dim lngSelectedValue As Long = 0
    Long.TryParse(cbxAddressTypes.SelectedValue, lngSelectedValue)
    cmd.CommandType = Data.CommandType.StoredProcedure
    cnn.Open()
    cmd.Connection = cnn
    Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
    cbxAddressTypes.Items.Clear()
    While dtr.Read
      itm = New ListItem
      itm.Text = dtr("AddressType")
      itm.Value = dtr("AddressTypeID")
      cbxAddressTypes.Items.Add(itm)
    End While
    If lngSelectedValue > 0 Then
      cbxAddressTypes.SelectedValue = lngSelectedValue.ToString
    End If
    cnn.Close()
  End Sub
#End Region

End Class