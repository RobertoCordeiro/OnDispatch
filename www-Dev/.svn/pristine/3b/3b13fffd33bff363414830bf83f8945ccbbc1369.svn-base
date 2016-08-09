<%@ Page Language="vb"%>
<script runat="server"> 
  
  Private Class Zip
    Private _ZipCode As String = ""
    Private _ResumeID As Long = 0
    Public Property ZipCode() As String
      Get
        Return _ZipCode
      End Get
      Set(ByVal value As String)
        _ZipCode = value
      End Set
    End Property
    Public Property ResumeID() As Long
      Get
        Return _ResumeID
      End Get
      Set(ByVal value As Long)
        _ResumeID = 0
      End Set
    End Property
    Public Sub New(ByVal strZipCode As String, ByVal lngResumeID As String)
      _ZipCode = strZipCode
      _ResumeID = lngResumeID
    End Sub
  End Class
  
  Private _ID As Long = 0

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
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    HandleSSL()
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    Response.Clear()
    Response.ContentType = "application/vnd.ms-excel"
    Response.AddHeader("content-disposition", "attachment;filename=" & "territory.xls")
    Response.Charset = ""
    Response.Cache.SetCacheability(HttpCacheability.NoCache)
    If _ID > 0 Then
      LoadZips(_ID)
    End If
    Dim stringWrite As New System.IO.StringWriter
    Dim htmlWrite As HtmlTextWriter = New HtmlTextWriter(stringWrite)
    Me.Render(htmlWrite)
    Response.Write(stringWrite.ToString)
    Response.End()
  End Sub
  
  Private Sub LoadZips(ByVal lngID As Long)
    Dim lstZips As New System.Collections.Generic.List(Of Zip)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("spGetDistinctZipsInResumeFolder")
    Dim cmd2 As New System.Data.SqlClient.SqlCommand
    Dim cnn2 As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim dtr As System.Data.SqlClient.SqlDataReader
    Dim strHTML As String = ""
    cmd.CommandType = Data.CommandType.StoredProcedure
    cmd.Parameters.Add("@ResumeFolderID", Data.SqlDbType.Int).Value = lngID
    cnn.Open()
    cmd.Connection = cnn
    dtr = cmd.ExecuteReader
    While dtr.Read
      lstZips.Add(New Zip(dtr("ZipCode"), dtr("ResumeID")))
    End While
    dtr.Close()
    cnn.Close()
    For Each zp As Zip In lstZips
      cmd = New System.Data.SqlClient.SqlCommand("spFindZipCodesWithinRadius")
      cmd.Parameters.Add("@ZipCode", Data.SqlDbType.VarChar, zp.ZipCode.Trim.Length).Value = zp.ZipCode.Trim
      cmd.Parameters.Add("@Radius", Data.SqlDbType.Int).Value = 75
      cmd.CommandType = Data.CommandType.StoredProcedure
      cnn.Open()
      cmd.Connection = cnn
      dtr = cmd.ExecuteReader
      cnn2.Open()
      Try
        While dtr.Read
          cmd2 = New System.Data.SqlClient.SqlCommand("spInsertTempTerritory")
          cmd2.Parameters.Add("@ZipCode", Data.SqlDbType.VarChar, dtr("ZipCode").ToString.Trim.Length).Value = dtr("ZipCode").ToString.Trim
          cmd2.Parameters.Add("@ResumeID", Data.SqlDbType.Int).Value = zp.ResumeID
          cmd2.CommandType = Data.CommandType.StoredProcedure
        
          cmd2.Connection = cnn2
          cmd2.ExecuteNonQuery()
        
        End While
      Catch ex As Exception
        Response.Write(zp.ZipCode)
      End Try
      cnn2.Close()
      dtr.Close()
      cnn.Close()
    Next
  End Sub
   
</script>
<html xmlns:x="urn:schemas-microsoft-com:office:excel">
  <head>
  <style>
  <!--table
  @page
     {mso-header-data:"&CMultiplication Table\000ADate\: &D\000APage &P";
	mso-page-orientation:landscape;}
     br
     {mso-data-placement:same-cell;}
     .zipcode{mso-number-format:00000;}
  -->
</style>
  <!--[if gte mso 9]><xml>
   <x:ExcelWorkbook>
    <x:ExcelWorksheets>
     <x:ExcelWorksheet>
      <x:Name>Sample Workbook</x:Name>
      <x:WorksheetOptions>
       <x:Print>
        <x:ValidPrinterInfo/>
       </x:Print>
      </x:WorksheetOptions>
     </x:ExcelWorksheet>
    </x:ExcelWorksheets>
   </x:ExcelWorkbook>
  </xml><![endif]--> 
  </head>
  <body>
    <div id="divResults" runat="server" />
  </body>
</html>
