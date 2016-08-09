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
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""partner.aspx"">Partners</a> &gt; Partner Search"
    End If
    If Not IsNothing(Request.QueryString("page")) Then
      If Not Long.TryParse(Request.QueryString("page"), _PageNumber) Then
        _PageNumber = 0
      End If
    End If
    'dgvPartners.CurrentPageIndex = _PageNumber
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
    Dim ptr As New BridgesInterface.PartnerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim lng As Long = 0
    Select Case strLookin.ToLower
      Case "resumeid"
        If Long.TryParse(strCriteria, lng) Then
          ptr.LoadByResumeID(lng)
          If ptr.ResumeID > 0 Then
            Response.Redirect("partner.aspx?id=" & ptr.PartnerID, True)
          Else
            divErrors.InnerHtml = "<ul><li>Your Search Returned No Results</li></ul>"
            divErrors.Visible = True
          End If
        Else
          divErrors.InnerHtml = "<ul><li>Partner ID Must Be A Number</li></ul>"
          divErrors.Visible = True
        End If
      
      
      Case "companyname"
        LoadPartnerByCompanyName(strCriteria)
      Case "name"
        LoadPartnerByName(strCriteria)
      Case "email"
        LoadPartnerByEmail(strCriteria)
      Case "ResumeID"
        LoadPartnerResumeID(strCriteria)
      Case "zipcode"
        LoadPartnerByZipCode(strCriteria)
      Case "city"
        LoadPartnerByCity(strCriteria)
      Case "state"
        LoadPartnerByState(strCriteria)
      Case "phone"
        LoadPartnerByPhoneNumber(strCriteria)
    End Select
    If dgvPartners.Items.Count = 1 Then
      'Response.Redirect("resume.aspx?resumeid=" & dgvPartners.Items(0).Cells(1).Text, True)
      Dim str as String
      str = dgvPartners.Items(0).Cells(1).text
      
      Response.Redirect("partner.aspx?id=" & dgvPartners.Items(0).Cells(1).Text, True)
    End If
  End Sub

  Private Sub LoadPartnerByCompanyName(ByVal strInput As String)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spSearchPartnerByCompanyName")
    cmd.CommandType = Data.CommandType.StoredProcedure
    If strInput.Trim.Length > 128 Then
      strInput = strInput.Substring(1, 128)
    End If
    cmd.Parameters.Add("@CompanyName", Data.SqlDbType.VarChar, strInput.Trim.Length).Value = strInput.Trim
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvPartners.DataSource = ds
    dgvPartners.DataBind()
    cnn.Close()
  End Sub

  Private Sub LoadPartnerByName(ByVal strInput As String)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spSearchPartnerByName")
    cmd.CommandType = Data.CommandType.StoredProcedure
    If strInput.Trim.Length > 1028 Then
      strInput = strInput.Substring(1, 1028)
    End If
    cmd.Parameters.Add("@Name", Data.SqlDbType.VarChar, strInput.Trim.Length).Value = strInput.Trim
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvPartners.DataSource = ds
    dgvPartners.DataBind()
    cnn.Close()
  End Sub
  Private Sub LoadPartnerResumeID(ByVal strInput As String)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spSearchPartnerResumeID")
    cmd.CommandType = Data.CommandType.StoredProcedure
    If strInput.Trim.Length > 1028 Then
      strInput = strInput.Substring(1, 1028)
    End If
    cmd.Parameters.Add("@ResumeID", Data.SqlDbType.VarChar, strInput.Trim.Length).Value = strInput.Trim
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvPartners.DataSource = ds
    dgvPartners.DataBind()
    cnn.Close()
  End Sub

  Private Sub LoadPartnerByEmail(ByVal strInput As String)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spSearchPartnerByEmail")
    cmd.CommandType = Data.CommandType.StoredProcedure
    If strInput.Trim.Length > 255 Then
      strInput = strInput.Substring(1, 255)
    End If
    cmd.Parameters.Add("@Email", Data.SqlDbType.VarChar, strInput.Trim.Length).Value = strInput.Trim
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)    
    dgvPartners.DataSource = ds
    dgvPartners.DataBind()
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
    dgvPartners.DataSource = ds
    dgvPartners.DataBind()
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
    dgvPartners.DataSource = ds
    dgvPartners.DataBind()
    cnn.Close()
  End Sub

  

 
  Private Sub LoadPartnerByZipCode(ByVal strInput As String)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spSearchPartnerByZipCode")
    cmd.CommandType = Data.CommandType.StoredProcedure
    If strInput.Trim.Length > 16 Then
      strInput = strInput.Substring(1, 16)
    End If
    cmd.Parameters.Add("@ZipCode", Data.SqlDbType.VarChar, strInput.Trim.Length).Value = strInput.Trim
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvPartners.DataSource = ds
    dgvPartners.DataBind()
    cnn.Close()
  End Sub

  Private Sub LoadPartnerByCity(ByVal strInput As String)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spSearchPartnerByCity")
    cmd.CommandType = Data.CommandType.StoredProcedure
    If strInput.Trim.Length > 128 Then
      strInput = strInput.Substring(1, 128)
    End If
    cmd.Parameters.Add("@City", Data.SqlDbType.VarChar, strInput.Trim.Length).Value = strInput.Trim
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvPartners.DataSource = ds
    dgvPartners.DataBind()
    cnn.Close()
  End Sub
  
  Private Sub LoadPartnerByState(ByVal strInput As String)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spSearchPartnerByState")
    cmd.CommandType = Data.CommandType.StoredProcedure
    If strInput.Trim.Length > 2 Then
      strInput = strInput.Substring(1, 2)
    End If
    cmd.Parameters.Add("@State", Data.SqlDbType.VarChar, strInput.Trim.Length).Value = strInput.Trim
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvPartners.DataSource = ds
    dgvPartners.DataBind()
    cnn.Close()
  End Sub

  Private Sub LoadPartnerByPhoneNumber(ByVal strInput As String)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spSearchPartnerByPhoneNumber")
    cmd.CommandType = Data.CommandType.StoredProcedure
        'If strInput.Trim.Length > 64 Then
        'strInput = strInput.Substring(1, 64)
        'End If
        cmd.Parameters.Add("@PhoneNumber", Data.SqlDbType.VarChar, strInput.Trim.Length).Value = Left(strInput.Trim, 10)
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgvPartners.DataSource = ds
        dgvPartners.DataBind()
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
    
  Private Sub dgvPartners_Paged(ByVal S As Object, ByVal E As DataGridPageChangedEventArgs)
    Response.Redirect("resumesearch.aspx?lookin=" & _LookIn & "&criteria=" & _Criteria & "&page=" & E.NewPageIndex.ToString, True)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmResults" runat="server">
    <div class="errorzone" visible="false" id="divErrors" runat="server" />
    <div class="label"><asp:label ID="lblSearchCount" runat="server" /> Search Results</div>
    <asp:DataGrid CellPadding="1" Width="100%" PagerStyle-Mode="NumericPages" OnPageIndexChanged="dgvPartners_Paged" AllowPaging="true" PageSize="25" AutoGenerateColumns="false" runat="server" ID="dgvPartners">
      <HeaderStyle CssClass="gridheader" />
      <AlternatingItemStyle CssClass="altrow" />          
      <Columns>
        <asp:templatecolumn
          HeaderText="View"
          SortExpression="PartnerID"
          >
          <ItemTemplate>
            <a href="partner.aspx?id=<%# Databinder.eval(Container.DataItem, "PartnerID") %>"><%# Databinder.eval(Container.DataItem, "ResumeID") %></a>
          </ItemTemplate>
        </asp:templatecolumn>
        <asp:BoundColumn
          HeaderText="Partner ID"
          DataField="PartnerID"
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
         
      </Columns>
    </asp:DataGrid>
  </form>
</asp:Content>