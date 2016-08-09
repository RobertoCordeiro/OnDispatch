''' <summary>
''' A page that allows a user to edit a rate within his online resume
''' </summary>
''' <remarks>
'''   Completed: 08/23/2007
'''   Author: Bill Hedge
'''   Modifications: None
''' </remarks>
Public Class EditRate
  Inherits System.Web.UI.Page

#Region "Private Members"
  Private _ID As Long = 0
#End Region

#Region "Protected Sub-Routines"
  Protected Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageTitleText = "Edit Rate"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = "detail.aspx"
    If _ID > 0 Then
      Dim rrt As New BridgesInterface.ResumeRateRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim wbl As New BridgesInterface.WebLoginRecord(rrt.ConnectionString)
      wbl.Load(Master.WebLoginID)
      rrt.Load(_ID)
      If rrt.ResumeID = CType(wbl.Login, Long) Then
        If Not IsPostBack Then
          LoadResumeRate()
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
  Private Sub LoadResumeRate()
    Dim rrt As New BridgesInterface.ResumeRateRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim rtt As New BridgesInterface.RateTypeRecord(rrt.ConnectionString)
    rrt.Load(_ID)
    rtt.Load(rrt.RateTypeID)
    lblRateType.Text = rtt.Description
    txtRate.Text = rrt.Rate.ToString
  End Sub

  Private Sub SaveResumeRate()
    Dim rrt As New BridgesInterface.ResumeRateRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim act As New BridgesInterface.ActionRecord(rrt.ConnectionString)
    Dim strChangeLog As String = ""
    rrt.Load(_ID)
    rrt.Rate = CType(txtRate.Text, Double)
    rrt.Save(strChangeLog)
    act.Add(Master.UserID, "web", "web", "web", "web", 25, rrt.ResumeRateID, strChangeLog)
  End Sub

#End Region

#Region "Private Functions"
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    Dim dbl As Double = 0
    If Not Double.TryParse(txtRate.Text, dbl) Then
      strErrors = "<li>Rate must be Numeric</li>"
    End If
    strErrors = "<ul>" & strErrors & "</ul>"
    divError.InnerHtml = strErrors
    Return blnReturn
  End Function

#End Region

#Region "Event Handlers"
  Protected Sub btnSubmit_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      SaveResumeRate()
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