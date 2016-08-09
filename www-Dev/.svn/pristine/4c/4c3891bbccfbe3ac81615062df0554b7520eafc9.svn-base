''' <summary>
''' A page that allows a user to add another phone number to his online resume
''' </summary>
''' <remarks>
'''   Completed: 08/23/2007
'''   Author: Bill Hedge
'''   Modifications: None
''' </remarks>
Public Class AddPhone
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
      Master.PageTitleText = "Add Phone Number"
    End If
    lblReturnUrl.Text = "detail.aspx"
  End Sub

#End Region

#Region "Private Sub-Routines"
  Private Sub SaveResumePhone()
    Dim rpn As New BridgesInterface.ResumePhoneNumberRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strChangeLog As String = ""
    rpn.Add(_ID, phn.PhoneTypeID, Master.UserID, "1", phn.AreaCode, phn.Exchange, phn.LineNumber)
    rpn.Extension = phn.Extension
    rpn.Pin = phn.Pin
    rpn.PhoneTypeID = phn.PhoneTypeID
    rpn.Save(strChangeLog)
  End Sub

#End Region

#Region "Private Functions"
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If phn.AreaCode.Trim.Length = 0 Then
      strErrors &= "<li>Area Code is Required</li>"
      blnReturn = False
    End If
    If phn.Exchange.Trim.Length = 0 Then
      strErrors &= "<li>Exchange is Required</li>"
      blnReturn = False
    End If
    If phn.LineNumber.Trim.Length = 0 Then
      strErrors &= "<li>Line Number is Required</li>"
      blnReturn = False
    End If
    strErrors = "<ul>" & strErrors & "</ul>"
    divError.InnerHtml = strErrors
    Return blnReturn
  End Function

#End Region

#Region "Event Handlers"
  Protected Sub btnSubmit_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      SaveResumePhone()
      Response.Redirect(lblReturnUrl.Text)
    Else
      divError.Visible = True
    End If
  End Sub

  Protected Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub

#End Region

End Class