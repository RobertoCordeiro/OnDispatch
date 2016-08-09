''' <summary>
''' A page that allows a user view FAQs relating to his online resume
''' </summary>
''' <remarks>
'''   Completed: 08/23/2007
'''   Author: Bill Hedge
'''   Modifications: None
''' </remarks>
Public Class ViewFaq
  Inherits System.Web.UI.Page

#Region "Private Members"
  Private _ID As Long = 0
#End Region

#Region "Private Sub-Routines"
  Private Sub LoadFaq(ByVal lngFAQID As Long)
    Dim faq As New BridgesInterface.FaqRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    faq.Load(lngFAQID)
    If faq.PublicFaq Then
      Master.PageTitleText = "FAQ: " & faq.Title
      LoadQuestions(lngFAQID)
    End If
  End Sub

  Private Sub LoadQuestions(ByVal lngFAQID As Long)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListFaqQuestions")
    cmd.CommandType = Data.CommandType.StoredProcedure
    cmd.Parameters.Add("@FaqID", Data.SqlDbType.Int).Value = lngFAQID
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvQuestions.DataSource = ds
    dgvQuestions.DataBind()
    dgvAnswers.DataSource = ds
    dgvAnswers.DataBind()
    cnn.Close()
  End Sub
#End Region

#Region "Protected Sub-Routines"
  Protected Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " View FAQ"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If _ID > 0 Then
      LoadFaq(_ID)
    Else
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub
#End Region

End Class