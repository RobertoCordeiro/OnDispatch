<%@ Page Language="VB" %>

<script runat="server">
  Private _FolderID As Long = 0

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
  
  Private Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
    HandleSSL()
    Dim lng As Long = 0
    If Not IsNothing(Request.QueryString("folder")) Then
      If Long.TryParse(Request.QueryString("folder"), lng) Then
        _FolderID = lng
      Else
        _FolderID = 0
      End If
    Else
      _FolderID = 0
    End If
    Dim strFileName As String = ""
    Dim fld As New BridgesInterface.ResumeFolderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    fld.Load(_FolderID)
    If fld.FolderID > 0 Then
      strFileName = fld.FolderName.Trim & ".xls"
    Else
      strFileName = "ResumeInbox.xls"
    End If
    Response.Clear()
    Response.ContentType = "application/vnd.ms-excel"
    Response.AddHeader("content-disposition", "attachment;filename=" & strFileName)
    Response.Charset = ""
    Response.Cache.SetCacheability(HttpCacheability.NoCache)
    LoadData(_FolderID)
    Dim stringWrite As New System.IO.StringWriter
    Dim htmlWrite As HtmlTextWriter = New HtmlTextWriter(stringWrite)
    Me.Render(htmlWrite)
    Response.Write(stringWrite.ToString)
    Response.End()
  End Sub

  Private Sub LoadData(ByVal lngFolderID As Long)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    If lngFolderID = 0 Then
      Dim cmd As New System.Data.SqlClient.SqlCommand("spGetUnassignedResumes")
      cmd.Parameters.Add("@SortColumn", Data.SqlDbType.VarChar, "tblResumes.ResumeID".Length).Value = "tblResumes.ResumeID"
            cmd.Parameters.Add("@SortOrder", Data.SqlDbType.VarChar, 3).Value = "ASC"
            cmd.Parameters.Add("@CountryID", Data.SqlDbType.Int).Value = 1
      cmd.CommandType = Data.CommandType.StoredProcedure
      cmd.Connection = cnn
      da.SelectCommand = cmd
      da.Fill(ds)
      dgvResumes.DataSource = ds
      dgvResumes.DataBind()      
    Else
      Dim cmd As New System.Data.SqlClient.SqlCommand("spGetResumesInFolder")
      cmd.Parameters.Add("@SortColumn", Data.SqlDbType.VarChar, "tblResumes.ResumeID".Length).Value = "tblResumes.ResumeID"
      cmd.Parameters.Add("@SortOrder", Data.SqlDbType.VarChar, 3).Value = "ASC"
      cmd.CommandType = Data.CommandType.StoredProcedure
            cmd.Parameters.Add("@FolderID", Data.SqlDbType.Int).Value = lngFolderID
            cmd.Parameters.Add("CountryID", Data.SqlDbType.Int).Value = 1
      cmd.Connection = cnn
      da.SelectCommand = cmd
      da.Fill(ds)
      dgvResumes.DataSource = ds
      dgvResumes.DataBind()      
    End If
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
    <asp:DataGrid AutoGenerateColumns="false" runat="server" ID="dgvResumes">
      <Columns>
        <asp:BoundColumn
          HeaderText="Resume ID"
          DataField="ResumeID"
          />
        <asp:BoundColumn
          HeaderText="Company"
          DataField="CompanyName" 
          />
        <asp:BoundColumn
          HeaderText="First Name"
          DataField="FirstName"
          />          
         <asp:BoundColumn
           HeaderText="Last Name" 
           DataField="LastName"              
           />
         <asp:BoundColumn
           HeaderText="Email"
           DataField="Email"
           />
         <asp:HyperLinkColumn 
           HeaderText="WebSite"
           Target="_blank"
           DataTextField="Website"               
           DataNavigateUrlFormatString="http://{0}"
           Datanavigateurlfield="Website"                                        
           />
         <asp:BoundColumn
           HeaderText="City"
           DataField="City"
           />
         <asp:BoundColumn
           HeaderText="State"
           DataField="StateName"
           />
         <asp:BoundColumn
           HeaderText="Zip"
           DataField="ZipCode"
           ItemStyle-CssClass="zipcode"           
           />
         <asp:BoundColumn
           HeaderText="Su"
           DataField="ContactSunday"
           />
         <asp:BoundColumn
           HeaderText="M"
           DataField="ContactSunday"
           />
         <asp:BoundColumn
           HeaderText="T"
           DataField="ContactSunday"
           />
         <asp:BoundColumn
           HeaderText="W"
           DataField="ContactSunday"
           />
         <asp:BoundColumn
           HeaderText="Th"
           DataField="ContactSunday"
           />
         <asp:BoundColumn
           HeaderText="F"
           DataField="ContactSunday"
           />
         <asp:BoundColumn
           HeaderText="S"
           DataField="ContactSunday"
           />                                                       
         <asp:BoundColumn
           HeaderText="Start"
           DataFormatString="{0}:00"
           DataField="ContactStart"
           />
         <asp:BoundColumn
           HeaderText="End"
           DataFormatString="{0}:00"
           DataField="ContactEnd"
           />
         <asp:BoundColumn 
           HeaderText="Date Entered"
           DataField="DateCreated" 
           SortExpression="tblResumes.DateCreated"               
           />
      </Columns>
    </asp:DataGrid>  
  </body>
</html>
