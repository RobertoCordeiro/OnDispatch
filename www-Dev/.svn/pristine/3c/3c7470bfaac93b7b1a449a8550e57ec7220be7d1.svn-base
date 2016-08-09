''' <summary>
''' A page that allows a user to add another address to his online resume
''' </summary>
''' <remarks>
'''   Completed: 08/23/2007
'''   Author: Bill Hedge
'''   Modifications: None
''' </remarks>
Public Class AddAddress
  Inherits System.Web.UI.Page

#Region "Private Members"
  Private _ID As Long = 0
#End Region

#Region "Protected Sub-Routines"
  Protected Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      wbl.Load(Master.WebLoginID)
      _ID = CType(wbl.Login, Long)
      Master.PageTitleText = "Add Address"
    End If
    lblReturnUrl.Text = "detail.aspx"
  End Sub
#End Region

#Region "Private Sub-Routines"
  Private Sub SaveResumeAddress()
    Dim rad As New BridgesInterface.ResumeAddressRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strChangeLog As String = ""
    rad.Add(_ID, Master.UserID, addAddress.StateID, addAddress.AddressTypeID, addAddress.Street, addAddress.City, addAddress.Zip)
    rad.Extended = addAddress.Extended
    rad.Save(strChangeLog)
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
      SaveResumeAddress()
      Response.Redirect(lblReturnUrl.Text, True)
    Else
      divError.Visible = True
    End If
  End Sub

#End Region

End Class