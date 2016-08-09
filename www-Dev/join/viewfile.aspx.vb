''' <summary>
''' A page that allows a user to view electronic documents relating to his online resume
''' </summary>
''' <remarks>
'''   Completed: 08/23/2007
'''   Author: Bill Hedge
'''   Modifications: None
''' </remarks>
Public Class ViewFile
  Inherits System.Web.UI.Page

#Region "Private Constants"
  Private Const cstDeniedImageFileID As Integer = 48
#End Region

#Region "Private Members"
  Dim _ID As Long = 0
#End Region

#Region "Protected Sub-Routines"
  Protected Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
    Call HandleSSL()
    Dim fil As New cvFileLibrary.FileRecord(System.Configuration.ConfigurationManager.AppSettings("FLCnn"))
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    If User.Identity.IsAuthenticated Then
      Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      wbl.Load(CType(User.Identity.Name, Long))
      If wbl.WebLoginID > 0 Then
        Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        rsm.Load(CType(wbl.Login, Long))
        If rsm.ResumeID > 0 Then
          If rsm.BlankContractFileID = _ID _
            Or rsm.BlankNDAFileID = _ID _
            Or rsm.BlankWaiverFileID = _ID _
            Or rsm.SignedContractFileID = _ID _
            Or rsm.SignedNDAFileID = _ID _
            Or rsm.SignedWaiverFileID = _ID _
            Or rsm.BlankSignatureFileID = _ID _
            Or rsm.SignatureFileID = _ID _
            Or rsm.DLFileID = _ID Then
            _ID = _ID
          Else
            _ID = cstDeniedImageFileID
          End If
        Else
          _ID = cstDeniedImageFileID
        End If
      Else
        _ID = cstDeniedImageFileID
      End If
    Else
      _ID = cstDeniedImageFileID
    End If
    fil.Load(_ID)
    Response.Clear()
    Response.ContentType = GetContentType(fil.Extension)
    Response.AddHeader("content-disposition", "attachment;filename=" & fil.FileName)
    Response.Charset = ""
    Response.Cache.SetCacheability(HttpCacheability.NoCache)
    Response.BinaryWrite(fil.BinaryData)
    Response.End()
  End Sub

#End Region

#Region "Private Sub-Routines"
  Private Sub HandleSSL()
    If (Request.ServerVariables("HTTPS") = "on") Then
      Dim strRedirect As String = ""
      Dim strQuery As String = ""
      strRedirect = "http://" & Request.ServerVariables("SERVER_NAME")
      strRedirect &= Request.ServerVariables("SCRIPT_NAME")
      strQuery = Request.ServerVariables("QUERY_STRING")
      If strQuery.Trim.Length > 0 Then
        strRedirect &= "?"
        strRedirect &= strQuery
      End If
      Response.Redirect(strRedirect, True)
    End If
  End Sub

#End Region

#Region "Public Functions"
  Private Function GetContentType(ByVal strExtension As String) As String
    Dim strReturn As String = ""
    Select Case strExtension.ToLower.Trim
      Case "tiff"
        strReturn = "image/tiff"
      Case "tif"
        strReturn = "image/tif"
      Case "pdf"
        strReturn = "application/pdf"
      Case "gif"
        strReturn = "image/gif"
      Case "png"
        strReturn = "image/png"
      Case "jpeg"
        strReturn = "image/jpg"
      Case "jpg"
        strReturn = "image/jpg"
      Case "doc"
        strReturn = "application/vnd.ms-word"
      Case "xls"
        strReturn = "application/vnd.ms-excel"
    End Select
    Return strReturn
  End Function

#End Region

End Class