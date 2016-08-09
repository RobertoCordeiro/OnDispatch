''' <summary>
''' A page that allows a user to send us an email message
''' </summary>
''' <remarks>
'''   Completed: 03/01/2010
'''   Author: Paulo Pinheiro
'''   Modifications: None
''' </remarks>
Public Class _default
  Inherits System.Web.UI.Page

#Region "Private Sub Routines"
  Private Sub TrackTraffic()
    Dim tm As New cvTrafficMaster.TransactionRecord(System.Configuration.ConfigurationManager.AppSettings("TMCnn"))
    tm.Add(Request.ServerVariables("SCRIPT_NAME"))
    If Not IsNothing(Request.ServerVariables("HTTP_REFERER")) Then
      tm.Referrer = Request.ServerVariables("HTTP_REFERER")
    End If
    If Not IsNothing(Request.ServerVariables("HTTP_USER_AGENT")) Then
      tm.UserAgent = Request.ServerVariables("HTTP_USER_AGENT")
    End If
    If Not IsNothing(Request.ServerVariables("REMOTE_ADDR")) Then
      tm.RemoteAddress = Request.ServerVariables("REMOTE_ADDR")
    End If
    If Not IsNothing(Request.ServerVariables("QUERY_STRING")) Then
      tm.QueryString = Request.ServerVariables("QUERY_STRING")
    End If
    If Not IsNothing(Request.ServerVariables("SERVER_NAME")) Then
      tm.ServerName = Request.ServerVariables("SERVER_NAME")
    End If
    Dim strChangelog As String = ""
    tm.Save(strChangelog)
  End Sub

  
#End Region

#Region "Protected Sub Routines"
  Protected Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
    Response.Buffer = True
    If CType(System.Configuration.ConfigurationManager.AppSettings("DownForMaintenance"), Boolean) Then
      Response.Redirect(System.Configuration.ConfigurationManager.AppSettings("MaintenanceUrl"), True)
      Response.Flush()
      Response.End()
    Else
      Dim strCompanyName As String = System.Configuration.ConfigurationManager.AppSettings("CompanyName")
      Dim lngCopyrightStartYear As Integer = CType(System.Configuration.ConfigurationManager.AppSettings("CopyrightStartYear"), Integer)
     
            Me.Page.Title = "Contact Us"
            If Not IsPostBack() Then
                TrackTraffic()
            End If
        End If
  End Sub

    Protected Sub SubmitMessage(ByVal S As Object, ByVal E As EventArgs)
        If IsComplete() Then
            If divInput.Visible Then
                Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
                eml.SendFrom = txtEmail.Text
                eml.SendTo = "services@bestservicers.com"
                eml.Subject = txtSubject.Text & " [web message]"
                eml.Body = txtMessage.Text
                eml.Body &= "<div>Details</div>"
                eml.Body &= "Sent from Contact Page on the website. <br />"
                eml.Send()

                divResult.Visible = True
                divInput.Visible = False
            Else
                divResult.Visible = True
                divInput.Visible = False
            End If
        Else
            divError.Visible = True
        End If
    End Sub
#End Region

#Region "Private Functions"
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strError As String = "<ul>"
    Dim val As New cvCommon.Validators
    If txtEmail.Text.Trim.Length > 0 Then
      If Not val.IsValidEmail(txtEmail.Text.Trim) Then
        blnReturn = False
        strError &= "<li>Email does not appear to be valid</li>"
      End If
    End If
        If txtFirstName.Text.Trim.Length = 0 Then
            blnReturn = False
            strError &= "<li>" & "First Name is Required" & "</li>"
        End If
        If txtEmail.Text.Trim.Length = 0 Then
            blnReturn = False
            strError &= "<li>" & "Email is Required" & "</li>"
        End If

        If txtMessage.Text.Trim.Length = 0 Then
            blnReturn = False
            strError &= "<li>A Message is Required</li>"
        End If
        strError &= "</ul>"
    divError.InnerHtml = strError
    Return blnReturn
  End Function
    
#End Region

End Class