<%@ Page Language="VB" %>
<script runat="server">
  
  Dim _ID As Long = 0
  
  Private Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
    HandleSSL()
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    Dim fil As New cvFileLibrary.FileRecord(System.Configuration.ConfigurationManager.AppSettings("FLCnn"))
    fil.Load(_ID)
    Response.Clear()
    Response.ContentType = GetContentType(fil.Extension)
    Response.AddHeader("Accept-Header", fil.FileSize.ToString)
    Response.AddHeader("Content-Length", fil.FileSize.ToString)
    Response.AddHeader("content-disposition", "attachment;filename=" & fil.FileName)
    Response.Charset = ""
    Response.Cache.SetCacheability(HttpCacheability.NoCache)
    Response.BinaryWrite(fil.BinaryData)
    Response.Flush()
    Response.End()
  End Sub
  
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
      Response.Redirect(strRedirect)
    End If
  End Sub
  
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

</script>
