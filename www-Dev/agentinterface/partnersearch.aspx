<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
  
  Private _LookIn As String = ""
  Private _Criteria As String = ""
  Private _PageNumber As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Partner Search"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Partner Search"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""partners.aspx"">Partners</a> &gt; Partner Search"
    End If
    If Not IsNothing(Request.QueryString("page")) Then
      If Not Long.TryParse(Request.QueryString("page"), _PageNumber) Then
        _PageNumber = 0
      End If
    End If
    dgvPartners.CurrentPageIndex = _PageNumber
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
    Dim ptr As New BridgesInterface.PartnerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim lng As Long = 0
    Select Case strLookin.ToLower
      Case "id"
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
    End Select
    If dgvPartners.Items.Count = 1 Then
      Response.Redirect("partner.aspx?id=" & dgvPartners.Items(0).Cells(1).Text, True)
    End If
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
    Response.Redirect("partnersearch.aspx?lookin=" & _LookIn & "&criteria=" & _Criteria & "&page=" & E.NewPageIndex.ToString, True)
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