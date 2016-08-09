<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
  
  Private _LookIn As String = ""
  Private _Criteria As String = ""
  Private _PageNumber As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Resume Search"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Resume Search"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""recruit.aspx"">Recruitment</a> &gt; Resume Search"
    End If
    If Not IsNothing(Request.QueryString("page")) Then
      If Not Long.TryParse(Request.QueryString("page"), _PageNumber) Then
        _PageNumber = 0
      End If
    End If
    dgvResumes.CurrentPageIndex = _PageNumber
    _LookIn = Request.QueryString("lookin")
    _Criteria = Request.QueryString("criteria")
    If IsQueryStringComplete() Then
      divErrors.Visible = False
      PerformSearch(_LookIn, _Criteria)
    Else
      divErrors.Visible = True
    End If
  End Sub
  
  Private Sub PerformSearch(ByVal strLookin As String, ByVal strCriteria As String)
    Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim lng As Long = 0
    Select Case strLookin.ToLower
      Case "resumeid"
        If Long.TryParse(strCriteria, lng) Then
          rsm.Load(lng)
          If rsm.ResumeID > 0 Then
            Response.Redirect("resume.aspx?resumeid=" & lng.ToString, True)
          Else
            divErrors.InnerHtml = "<ul><li>Your Search Returned No Results</li></ul>"
            divErrors.Visible = True            
          End If
        Else
          divErrors.InnerHtml = "<ul><li>Resume ID Must Be A Number</li></ul>"
          divErrors.Visible = True          
        End If
      Case "referrer"
        LoadResumesByReferrer(strCriteria)
      Case "companyname"
        LoadResumesByCompanyName(strCriteria)
      Case "name"
        LoadResumesByName(strCriteria)
      Case "email"
        LoadResumesByEmail(strCriteria)
      Case "website"
        LoadResumesByWebSite(strCriteria)
      Case "ipaddress"
        LoadResumesByIPAddress(strCriteria)
      Case "resume"
        LoadResumesByResume(strCriteria)
      Case "misc"
        LoadResumesByMisc(strCriteria)
      Case "zipcode"
        LoadResumesByZipCode(strCriteria)
      Case "city"
        LoadResumesByCity(strCriteria)
      Case "state"
        LoadResumesByState(strCriteria)
      Case "phone"
        LoadResumesByPhoneNumber(strCriteria)
    End Select
    If dgvResumes.Items.Count = 1 Then
      Response.Redirect("resume.aspx?resumeid=" & dgvResumes.Items(0).Cells(1).Text, True)
    End If
  End Sub
  
  Private Sub LoadResumesByReferrer(ByVal strReferrer As String)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spSearchResumesByReferrer")
    cmd.CommandType = Data.CommandType.StoredProcedure
    If strReferrer.Trim.Length > 32 Then
      strReferrer = strReferrer.Substring(1, 32)
    End If
    cmd.Parameters.Add("@Referrer", Data.SqlDbType.VarChar, strReferrer.Trim.Length).Value = strReferrer.Trim
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvResumes.DataSource = ds
    dgvResumes.DataBind()
    cnn.Close()
  End Sub

  Private Sub LoadResumesByCompanyName(ByVal strInput As String)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spSearchResumesByCompanyName")
    cmd.CommandType = Data.CommandType.StoredProcedure
    If strInput.Trim.Length > 128 Then
      strInput = strInput.Substring(1, 128)
    End If
    cmd.Parameters.Add("@CompanyName", Data.SqlDbType.VarChar, strInput.Trim.Length).Value = strInput.Trim
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvResumes.DataSource = ds
    dgvResumes.DataBind()
    cnn.Close()
  End Sub

  Private Sub LoadResumesByName(ByVal strInput As String)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spSearchResumesByName")
    cmd.CommandType = Data.CommandType.StoredProcedure
    If strInput.Trim.Length > 1028 Then
      strInput = strInput.Substring(1, 1028)
    End If
    cmd.Parameters.Add("@Name", Data.SqlDbType.VarChar, strInput.Trim.Length).Value = strInput.Trim
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvResumes.DataSource = ds
    dgvResumes.DataBind()
    cnn.Close()
  End Sub

  Private Sub LoadResumesByEmail(ByVal strInput As String)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spSearchResumesByEmail")
    cmd.CommandType = Data.CommandType.StoredProcedure
    If strInput.Trim.Length > 255 Then
      strInput = strInput.Substring(1, 255)
    End If
    cmd.Parameters.Add("@Email", Data.SqlDbType.VarChar, strInput.Trim.Length).Value = strInput.Trim
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)    
    dgvResumes.DataSource = ds
    dgvResumes.DataBind()
    cnn.Close()
  End Sub
  
  Private Sub LoadResumesByWebSite(ByVal strInput As String)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spSearchResumesByWebsite")
    cmd.CommandType = Data.CommandType.StoredProcedure
    If strInput.Trim.Length > 255 Then
      strInput = strInput.Substring(1, 255)
    End If
    cmd.Parameters.Add("@Website", Data.SqlDbType.VarChar, strInput.Trim.Length).Value = strInput.Trim
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvResumes.DataSource = ds
    dgvResumes.DataBind()
    cnn.Close()
  End Sub

  Private Sub LoadResumesByIPAddress(ByVal strInput As String)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spSearchResumesByIPAddress")
    cmd.CommandType = Data.CommandType.StoredProcedure
    If strInput.Trim.Length > 32 Then
      strInput = strInput.Substring(1, 32)
    End If
    cmd.Parameters.Add("@IPAddress", Data.SqlDbType.VarChar, strInput.Trim.Length).Value = strInput.Trim
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvResumes.DataSource = ds
    dgvResumes.DataBind()
    cnn.Close()
  End Sub

  Private Sub LoadResumesByResume(ByVal strInput As String)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spSearchResumesByResume")
    cmd.CommandType = Data.CommandType.StoredProcedure
    cmd.Parameters.Add("@Resume", Data.SqlDbType.VarChar, strInput.Trim.Length + 2).Value = "%" & strInput.Trim & "%"
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvResumes.DataSource = ds
    dgvResumes.DataBind()
    cnn.Close()
  End Sub

  Private Sub LoadResumesByMisc(ByVal strInput As String)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spSearchResumesByMisc")
    cmd.CommandType = Data.CommandType.StoredProcedure
    cmd.Parameters.Add("@Misc", Data.SqlDbType.VarChar, strInput.Trim.Length + 2).Value = "%" & strInput.Trim & "%"
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvResumes.DataSource = ds
    dgvResumes.DataBind()
    cnn.Close()
  End Sub
  
  Private Sub LoadResumesByZipCode(ByVal strInput As String)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spSearchResumesByZipCode")
    cmd.CommandType = Data.CommandType.StoredProcedure
    If strInput.Trim.Length > 16 Then
      strInput = strInput.Substring(1, 16)
    End If
    cmd.Parameters.Add("@ZipCode", Data.SqlDbType.VarChar, strInput.Trim.Length).Value = strInput.Trim
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvResumes.DataSource = ds
    dgvResumes.DataBind()
    cnn.Close()
  End Sub

  Private Sub LoadResumesByCity(ByVal strInput As String)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spSearchResumesByCity")
    cmd.CommandType = Data.CommandType.StoredProcedure
    If strInput.Trim.Length > 128 Then
      strInput = strInput.Substring(1, 128)
    End If
    cmd.Parameters.Add("@City", Data.SqlDbType.VarChar, strInput.Trim.Length).Value = strInput.Trim
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvResumes.DataSource = ds
    dgvResumes.DataBind()
    cnn.Close()
  End Sub
  
  Private Sub LoadResumesByState(ByVal strInput As String)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spSearchResumesByState")
    cmd.CommandType = Data.CommandType.StoredProcedure
    If strInput.Trim.Length > 2 Then
      strInput = strInput.Substring(1, 2)
    End If
    cmd.Parameters.Add("@State", Data.SqlDbType.VarChar, strInput.Trim.Length).Value = strInput.Trim
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvResumes.DataSource = ds
    dgvResumes.DataBind()
    cnn.Close()
  End Sub

  Private Sub LoadResumesByPhoneNumber(ByVal strInput As String)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spSearchResumesByPhoneNumber")
    cmd.CommandType = Data.CommandType.StoredProcedure
        'If strInput.Trim.Length > 64 Then
        'strInput = strInput.Substring(1, 64)
        'End If
        cmd.Parameters.Add("@PhoneNumber", Data.SqlDbType.VarChar, strInput.Trim.Length).Value = Left(strInput.Trim, 10)
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgvResumes.DataSource = ds
        dgvResumes.DataBind()
        cnn.Close()
  End Sub
  
  Private Function IsQueryStringComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If IsNothing(Request.QueryString("lookin")) Then
      strErrors &= "<li>Field To Look In Is Missing</li>"
      blnReturn = False
    End If
    If IsNothing(Request.QueryString("criteria")) Then
      strErrors &= "<li>Criteria is Missing</li>"
      blnReturn = False
    End If
    divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
    
  Private Sub dgvResumes_Paged(ByVal S As Object, ByVal E As DataGridPageChangedEventArgs)
    Response.Redirect("resumesearch.aspx?lookin=" & _LookIn & "&criteria=" & _Criteria & "&page=" & E.NewPageIndex.ToString, True)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmResults" runat="server">
    <div class="errorzone" visible="false" id="divErrors" runat="server" />
    <div class="label"><asp:label ID="lblSearchCount" runat="server" /> Search Results</div>
    <asp:DataGrid CellPadding="1" Width="100%" PagerStyle-Mode="NumericPages" OnPageIndexChanged="dgvResumes_Paged" AllowPaging="true" PageSize="25" AutoGenerateColumns="false" runat="server" ID="dgvResumes">
      <HeaderStyle CssClass="gridheader" />
      <AlternatingItemStyle CssClass="altrow" />          
      <Columns>
        <asp:templatecolumn
          HeaderText="View"
          SortExpression="ResumeID"
          >
          <ItemTemplate>
            <a href="resume.aspx?resumeid=<%# Databinder.eval(Container.DataItem, "ResumeID") %>"><%# Databinder.eval(Container.DataItem, "ResumeID") %></a>
          </ItemTemplate>
        </asp:templatecolumn>
        <asp:BoundColumn
          HeaderText="Resume ID"
          DataField="ResumeID"
          Visible="false"
          />
        <asp:BoundColumn
          HeaderText="Company"
          DataField="CompanyName" 
          SortExpression="CompanyName"
        />
        <asp:BoundColumn
          HeaderText="First Name"
          DataField="FirstName"
          SortExpression="FirstName"
         />
         <asp:TemplateColumn
           HeaderText="Last Name"               
           SortExpression="LastName">               
           <ItemTemplate>
             <a href="mailto:<%# Databinder.eval(Container.DataItem, "Email") %>"><%# Databinder.eval(Container.DataItem, "LastName") %></a>
           </ItemTemplate>
         </asp:TemplateColumn>             
         <asp:HyperLinkColumn 
           HeaderText="WebSite"
           Target="_blank"
           DataTextField="Website"               
           DataNavigateUrlFormatString="http://{0}"
           Datanavigateurlfield="Website"              
           SortExpression="WebSite"                          
         />
         <asp:BoundColumn
           HeaderText="City"
           DataField="City"
           SortExpression="City"
         />
         <asp:BoundColumn
           HeaderText="State"
           DataField="StateName"
           SortExpression="StateName"
          />
         <asp:TemplateColumn
           HeaderText="Zip"
           SortExpression="ZipCode" 
           >
           <ItemTemplate>
             <a href="findzipcode.aspx?zip=<%# Databinder.eval(Container.DataItem,"ZipCode") %>" target="_blank"><%# Databinder.eval(Container.DataItem,"ZipCode") %></a>
           </ItemTemplate>
         </asp:TemplateColumn>             
         <asp:TemplateColumn 
           HeaderText="Su"
           SortExpression="ContactSunday">             
           <ItemTemplate>
             <img src="/graphics/<%# Databinder.eval(Container.DataItem, "ContactSunday") %>.png" />                 
           </ItemTemplate>
         </asp:TemplateColumn>            
         <asp:TemplateColumn              
           HeaderText="M"
           SortExpression="ContactMonday">                            
           <ItemTemplate>
             <img src="/graphics/<%# Databinder.eval(Container.DataItem, "ContactMonday") %>.png" />                 
           </ItemTemplate>
         </asp:TemplateColumn>            
         <asp:TemplateColumn 
           HeaderText="T"
           SortExpression="ContactTuesday">             
           <ItemTemplate>
             <img src="/graphics/<%# Databinder.eval(Container.DataItem, "ContactTuesday") %>.png" />                 
           </ItemTemplate>
         </asp:TemplateColumn>            
         <asp:TemplateColumn 
           HeaderText="W"
           SortExpression="ContactFriday">             
           <ItemTemplate>
             <img src="/graphics/<%# Databinder.eval(Container.DataItem, "ContactWednesday") %>.png" />                 
           </ItemTemplate>
         </asp:TemplateColumn>            
         <asp:TemplateColumn 
           HeaderText="Th"
           SortExpression="ContactThursday">             
           <ItemTemplate>
             <img src="/graphics/<%# Databinder.eval(Container.DataItem, "ContactThursday") %>.png" />                 
           </ItemTemplate>
         </asp:TemplateColumn>            
         <asp:TemplateColumn 
           HeaderText="F"
           SortExpression="ContactFriday">             
           <ItemTemplate>
             <img src="/graphics/<%# Databinder.eval(Container.DataItem, "ContactFriday") %>.png" />                 
           </ItemTemplate>
         </asp:TemplateColumn>            
         <asp:TemplateColumn 
           HeaderText="S"
           SortExpression="ContactSaturday">             
           <ItemTemplate>
             <img src="/graphics/<%# Databinder.eval(Container.DataItem, "ContactSaturday") %>.png" />                 
           </ItemTemplate>
         </asp:TemplateColumn>
         <asp:BoundColumn
           HeaderText="Start"
           DataFormatString="{0}:00"
           DataField="ContactStart"
           SortExpression="ContactStart"
         />
         <asp:BoundColumn
           HeaderText="End"
           DataFormatString="{0}:00"
           DataField="ContactEnd"
           SortExpression="ContactEnd"
         />
         <asp:TemplateColumn
           HeaderText="LocalTime"
           >
           <ItemStyle CssClass="highlightcell" />
           <ItemTemplate>
             <%#CType(DataBinder.Eval(Container.DataItem, "LocalTime"), Date).ToShortTimeString()%>
           </ItemTemplate>
         </asp:TemplateColumn>
         <asp:BoundColumn 
           HeaderText="Date Entered"
           DataField="DateCreated" 
           SortExpression="DateCreated"               
         />
      </Columns>
    </asp:DataGrid>
  </form>
</asp:Content>