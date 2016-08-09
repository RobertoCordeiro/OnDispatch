''' <summary>
''' A web user control for editing a first middle and last name
''' </summary>
''' <remarks>
'''   Completed: 05/01/2007
'''   Author: George H. Slaterpryce III
'''   Modifications: 
'''   1. Added Width Property (George, 06/29/2007)
'''   2. Converted to code-behind (Bill Hedge, 08/29/2007)
''' </remarks>
Partial Class controls_FirstLastName
  Inherits System.Web.UI.UserControl

#Region "Private Methods"
  Private _LabelClass As String = ""
  Private _FirstNameRequired As Boolean = False
  Private _LastNameRequired As Boolean = False
  Private _MIRequired As Boolean = False
#End Region

#Region "Public Properties"
  ''' <summary>
  ''' Returns/Sets Data contained in the first name field
  ''' </summary>
  Public Property FirstName() As String
    Get
      Return txtFirstName.Text
    End Get
    Set(ByVal value As String)
      txtFirstName.Text = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/Sets Data contained in the mi field
  ''' </summary>
  Public Property MI() As String
    Get
      Return txtMI.Text
    End Get
    Set(ByVal value As String)
      txtMI.Text = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/Sets Data contained in the last name field
  ''' </summary>
  Public Property LastName() As String
    Get
      Return txtLastName.Text
    End Get
    Set(ByVal value As String)
      txtLastName.Text = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/Sets if the first name is required and marks the field as such
  ''' </summary>
  Public Property FirstNameRequired() As Boolean
    Get
      Return _FirstNameRequired
    End Get
    Set(ByVal value As Boolean)
      _FirstNameRequired = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/Sets if the middle name/initial is required and marks the field as such
  ''' </summary>
  Public Property MIRequired() As Boolean
    Get
      Return _MIRequired
    End Get
    Set(ByVal value As Boolean)
      _MIRequired = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/Sets if the last name is required and marks the field as such
  ''' </summary>
  Public Property LastNameRequired() As Boolean
    Get
      Return _LastNameRequired
    End Get
    Set(ByVal value As Boolean)
      _LastNameRequired = value
    End Set
  End Property

  ''' <summary>
  ''' Returns/Sets the class used for the field labels.
  ''' </summary>
  Public Property LabelClass() As String
    Get
      Return _LabelClass
    End Get
    Set(ByVal value As String)
      _LabelClass = value
      tdFirstName.Attributes("Class") = value
      tdMI.Attributes("Class") = value
      tdLastName.Attributes("Class") = value
    End Set
  End Property
#End Region

#Region "Private Sub-Routines"
  ''' <summary>
  ''' Initializes the control
  ''' </summary>
  Private Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
    If _FirstNameRequired Then
      lblFirstName.Text = "First Name *"
            lblFirstName.Attributes("style") = "font-weight: bold; "
    Else
      lblFirstName.Text = "First Name"
    End If
    If _LastNameRequired Then
      lblLastName.Text = "Last Name *"
            lblLastName.Attributes("style") = "font-weight: bold; "
    Else
      lblLastName.Text = "Last Name"
    End If
    If _MIRequired Then
      lblMI.Text = "MI *"
            lblMI.Attributes("style") = "font-weight: bold; "
    Else
      lblMI.Text = "MI"
    End If
  End Sub
#End Region

End Class