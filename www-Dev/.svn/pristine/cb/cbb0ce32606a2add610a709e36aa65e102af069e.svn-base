''' <summary>
''' A page that allows a user to edit or delete an address within his online resume
''' </summary>
''' <remarks>
'''   Completed: 08/23/2007
'''   Author: Bill Hedge
'''   Modifications: None
''' </remarks>
Public Class EditAddress
  Inherits System.Web.UI.Page

#Region "Private Members"
  Private _ID As Long = 0
#End Region

#Region "Protected Sub-Routines"
  Protected Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageTitleText = "Edit Address"
    End If
    lblReturnUrl.Text = "detail.aspx"
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    If _ID > 0 Then
      Dim add As New BridgesInterface.ResumeAddressRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim wbl As New BridgesInterface.WebLoginRecord(add.ConnectionString)
      wbl.Load(Master.WebLoginID)
      add.Load(_ID)
      If add.ResumeID = CType(wbl.Login, Long) Then
        If Not IsPostBack Then
          LoadResumeAddress()
        End If
      Else
        divForm.Visible = False
        Response.Redirect(lblReturnUrl.Text, True)
      End If
    Else
      divForm.Visible = False
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub
#End Region

#Region "Private Sub-Routines"
  Private Sub LoadResumeAddress()
    Dim rad As New BridgesInterface.ResumeAddressRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    rad.Load(_ID)
    addAddress.AddressTypeID = rad.AddressTypeID
    addAddress.Street = rad.Street
    addAddress.Extended = rad.Extended
    addAddress.City = rad.City
    addAddress.StateID = rad.StateID
    addAddress.Zip = rad.ZipCode
  End Sub

  Private Sub SaveResumeAddress()
    Dim rad As New BridgesInterface.ResumeAddressRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strChangeLog As String = ""
    rad.Load(_ID)
    rad.Street = addAddress.Street
    rad.Extended = addAddress.Extended
    rad.City = addAddress.City
    rad.StateID = addAddress.StateID
    rad.ZipCode = addAddress.Zip
    rad.AddressTypeID = addAddress.AddressTypeID
    rad.Active = Not chkRemove.Checked
    rad.Save(strChangeLog)
    Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    act.Add(Master.UserID, "web", "web", "web", "web", 24, rad.ResumeAddressID, strChangeLog)
  End Sub

#End Region

#Region "Private Functions"
  Private Function IsAddressComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim zip As New BridgesInterface.ZipCodeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strErrors As String = ""
    If addAddress.AddressTypeID <= 0 Then
      blnReturn = False
      strErrors &= "<li>Address Type is Required</li>"
    End If
    If addAddress.Street.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Street is Required</li>"
    End If
    If addAddress.City.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>City is Required</li>"
    End If
    If addAddress.StateID <= 0 Then
      blnReturn = False
      strErrors &= "<li>State is Required</li>"
    End If
    If addAddress.Zip.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Zip Code is Required</li>"
    Else
      zip.Load(addAddress.Zip.Trim)
      If zip.ZipCodeID <= 0 Then
        blnReturn = False
        strErrors &= "<li>Zip Code is Invalid</li>"
      End If
    End If
    divError.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function

#End Region

#Region "Event Handlers"
  Protected Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text, True)
  End Sub

  Protected Sub btnSubmit_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsAddressComplete() Then
      divError.Visible = False
      SaveResumeAddress()
      Response.Redirect(lblReturnUrl.Text, True)
    Else
      divError.Visible = True
    End If
  End Sub
#End Region

End Class