''' <summary>
''' A page that allows a user to edit or delete a phone number within his online resume
''' </summary>
''' <remarks>
'''   Completed: 08/23/2007
'''   Author: Bill Hedge
'''   Modifications: None
''' </remarks>
Public Class EditPhone
  Inherits System.Web.UI.Page

#Region "Private Members"
  Private _ID As Long = 0
#End Region

#Region "Protected Sub-Routines"
  Protected Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageTitleText = "Edit Phone Number"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = "detail.aspx"
    If _ID > 0 Then
      Dim phn As New BridgesInterface.ResumePhoneNumberRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim wbl As New BridgesInterface.WebLoginRecord(phn.ConnectionString)
      wbl.Load(Master.WebLoginID)
      phn.Load(_ID)
      If phn.ResumeID = CType(wbl.Login, Long) Then
        If Not IsPostBack Then
          LoadResumePhone()
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
  Private Sub LoadResumePhone()
    Dim rpn As New BridgesInterface.ResumePhoneNumberRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    rpn.Load(_ID)
    phn.AreaCode = rpn.AreaCode
    phn.Exchange = rpn.Exchange
    phn.LineNumber = rpn.LineNumber
    phn.Pin = rpn.Pin
    phn.PhoneTypeID = rpn.PhoneTypeID
    phn.Extension = rpn.Extension
  End Sub

  Private Sub SaveResumePhone()
    Dim rpn As New BridgesInterface.ResumePhoneNumberRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strChangeLog As String = ""
    rpn.Load(_ID)
    rpn.AreaCode = phn.AreaCode
    rpn.Exchange = phn.Exchange
    rpn.LineNumber = phn.LineNumber
    rpn.Extension = phn.Extension
    rpn.Pin = phn.Pin
    rpn.PhoneTypeID = phn.PhoneTypeID
    rpn.Active = Not chkRemove.Checked
    rpn.Save(strChangeLog)
    Dim act As New BridgesInterface.ActionRecord(rpn.ConnectionString)
    Dim strIP As String = Request.QueryString("REMOTE_ADDR")
    If IsNothing(strIP) Then
      strIP = "unknown"
    End If
    act.Add(Master.UserID, "web", "web", strIP, "web", 23, rpn.ResumePhoneNumberID, strChangeLog)
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
      Response.Redirect(lblReturnUrl.Text, True)
    Else
      divError.Visible = True
    End If
  End Sub

  Protected Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text, True)
  End Sub

#End Region

End Class