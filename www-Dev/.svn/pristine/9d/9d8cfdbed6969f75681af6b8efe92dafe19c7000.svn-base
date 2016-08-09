''' <summary>
''' A control that allows a user to create/view a part for a ticket
''' </summary>
''' <remarks>
'''   Completed: 08/29/2007
'''   Author: Bill Hedge
'''   Modifications: None
''' </remarks>
Partial Class controls_TicketComponent
  Inherits System.Web.UI.UserControl

#Region "Public Properties"
  ''' <summary>
  ''' Returns/sets the code for a part
  ''' </summary>
  Public Property Code() As String
    Get
      Return txtCode.Text
    End Get
    Set(ByVal value As String)
      txtCode.Text = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the name of the part
  ''' </summary>
  Public Property Component() As String
    Get
      Return txtComponent.Text
    End Get
    Set(ByVal value As String)
      txtComponent.Text = ""
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the return shipping label for the part
  ''' </summary>
  Public Property ReturnLabel() As String
    Get
      Return txtReturnLabel.Text
    End Get
    Set(ByVal value As String)
      txtReturnLabel.Text = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the outbound shipping label for the part
  ''' </summary>
  Public Property ShipLabel() As String
    Get
      Return txtShipLabel.Text
    End Get
    Set(ByVal value As String)
      txtShipLabel.Text = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the serial number for the part
  ''' </summary>
  Public Property SerialNumber() As String
    Get
      Return txtSerialNumber.Text
    End Get
    Set(ByVal value As String)
      txtSerialNumber.Text = ""
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the outbound shipping courier for the part
  ''' </summary>
  Public Property ShipCourier() As Long
    Get
      Return CType(cbxShipCourier.SelectedValue, Long)
    End Get
    Set(ByVal value As Long)
      cbxShipCourier.SelectedValue = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the return shipping courier for the part
  ''' </summary>
  Public Property ReturnCourier() As Long
    Get
      Return CType(cbxReturnCourier.SelectedValue, Long)
    End Get
    Set(ByVal value As Long)
      cbxReturnCourier.SelectedValue = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the method of return shipping for the part
  ''' </summary>
  Public Property ReturnMethod() As Long
    Get
      Return CType(cbxReturnMethod.SelectedValue, Long)
    End Get
    Set(ByVal value As Long)
      cbxReturnMethod.SelectedValue = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets the method of outbound shipping for the parts
  ''' </summary>
  Public Property ShipMethod() As Long
    Get
      Return CType(cbxShipMethod.SelectedValue, Long)
    End Get
    Set(ByVal value As Long)
      cbxShipMethod.SelectedValue = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets whether the part has to be returned
  ''' </summary>
  Public Property Consumable() As Boolean
    Get
      Return chkConsumable.Checked
    End Get
    Set(ByVal value As Boolean)
      chkConsumable.Checked = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/sets notes for the part
  ''' </summary>
  Public Property Notes() As String
    Get
      Return txtNotes.Text
    End Get
    Set(ByVal value As String)
      txtNotes.Text = value
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
    If Not IsPostBack Then
      LoadCouriers()
    End If
  End Sub

  ''' <summary>
  ''' Loads couriers and methods into the shipping and return couriers and methods dropdownlists
  ''' </summary>
  Private Sub LoadCouriers()
    LoadShipCouriers()
    LoadReturnCouriers()
    If cbxShipCourier.Items.Count > 0 Then
      LoadShipMethod(CType(cbxShipCourier.SelectedValue, Long))
    End If
    If cbxReturnCourier.Items.Count > 0 Then
      LoadReturnMethod(CType(cbxReturnCourier.SelectedValue, Long))
    End If
  End Sub

  ''' <summary>
  ''' Loads couriers into the shipping couriers dropdownlist
  ''' </summary>
  Private Sub LoadShipCouriers()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDropDownList("spListCouriers", "Courier", "CourierID", cbxShipCourier)
  End Sub

  ''' <summary>
  ''' Loads couriers into the return couriers dropdownlist
  ''' </summary>
  Private Sub LoadReturnCouriers()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDropDownList("spListCouriers", "Courier", "CourierID", cbxReturnCourier)
  End Sub

  ''' <summary>
  ''' Loads shipping methods based on the passed in CourierID into the shipping methods dropdownlist
  ''' </summary>
  ''' <param name="lngID"></param>
  ''' <remarks></remarks>
  Private Sub LoadShipMethod(ByVal lngID As Long)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDropDownList("spListCourierMethods", "@CourierID", lngID, "Method", "CourierMethodID", cbxShipMethod)
  End Sub

  ''' <summary>
  ''' Loads return methods based on the passed in CourierID into the return methods dropdownlist
  ''' </summary>
  ''' <param name="lngID"></param>
  ''' <remarks></remarks>
  Private Sub LoadReturnMethod(ByVal lngID As Long)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDropDownList("spListCourierMethods", "@CourierID", lngID, "Method", "CourierMethodID", cbxReturnMethod)
  End Sub
#End Region

#Region "Protected Sub-Routines"
  ''' <summary>
  ''' Reloads shipping methods into the shipping methods dropdownlist when the shipping courier is changed
  ''' </summary>
  ''' <param name="S">Sender (dropdownlist)</param>
  ''' <param name="E">Event Arguments</param>
  Protected Sub ShipCourierChanged(ByVal S As Object, ByVal E As EventArgs)
    If cbxShipCourier.Items.Count > 0 Then
      LoadShipMethod(CType(cbxShipCourier.SelectedValue, Long))
    End If
  End Sub

  ''' <summary>
  ''' Reloads return methods into the return methods dropdownlist when the return courier is changed
  ''' </summary>
  ''' <param name="S">Sender (dropdownlist)</param>
  ''' <param name="E">Event Arguments</param>
  Protected Sub ReturnCourierChanged(ByVal S As Object, ByVal E As EventArgs)
    If cbxReturnCourier.Items.Count > 0 Then
      LoadReturnMethod(CType(cbxReturnCourier.SelectedValue, Long))
    End If
  End Sub
#End Region

End Class