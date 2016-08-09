<%@ Page Language="VB" %>
<script runat="server">
  Private Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
    HandleSSL()
    Response.Clear()
    Response.ContentType = "application/vnd.ms-excel"
    Response.AddHeader("content-disposition", "attachment;filename=export.xls")
    Response.Charset = ""
    Response.Cache.SetCacheability(HttpCacheability.NoCache)
    LoadZips()
    Dim stringWrite As New System.IO.StringWriter
    Dim htmlWrite As New HtmlTextWriter(stringWrite)
    Me.Render(htmlWrite)
    Response.Write(stringWrite.ToString)
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
  
  Private Sub LoadZips()
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spReportResumesInZip")
    cmd.CommandType = Data.CommandType.StoredProcedure
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvZips.DataSource = ds
    dgvZips.DataBind()
    cnn.Close()
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
    <asp:DataGrid ID="dgvZips" runat="server" AutoGenerateColumns="false">
      <Columns>
        <asp:BoundColumn
          HeaderText="Resume Count"
          datafield="resumes"
          />
        <asp:BoundColumn
          HeaderText="Zip Code"
          ItemStyle-CssClass="zipcode"
          DataField="zipCode"
          />
        <asp:BoundColumn
          HeaderText="Country"
          DataField="CountryName"
          />
        <asp:BoundColumn
          HeaderText="State"
          DataField="StateName"
          />
        <asp:BoundColumn
          HeaderText="County"
          DataField="CountyName"
          />
        <asp:BoundColumn
          HeaderText="City"
          DataField="City"
          />
        <asp:BoundColumn
          HeaderText="Area Code"
          DataField="AreaCode"
          />
        <asp:BoundColumn
          HeaderText="Population"
          DataField="Population"
          />
      </Columns>
    </asp:DataGrid>      
  </body>
</html>
