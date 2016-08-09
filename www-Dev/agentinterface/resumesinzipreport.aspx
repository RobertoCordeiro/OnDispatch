<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Resumes in Zip Code Report"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Resumes in Zip Code Report"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""reports.aspx"">Reports</a> &gt; Resumes In Zip Report"
    End If
    LoadZips()
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

  Private Sub dgvZips_Paged(ByVal S As Object, ByVal E As DataGridPageChangedEventArgs)
    dgvZips.CurrentPageIndex = E.NewPageIndex
    LoadZips()
  End Sub

  Private Sub btnExport_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect("resumesinzipreportxls.aspx")
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmZips" runat="server">
    <asp:DataGrid ID="dgvZips" style="width: 100%" runat="server" PagerStyle-Mode="NumericPages" OnPageIndexChanged="dgvZips_Paged" AllowPaging="true" PageSize="25"  AutoGenerateColumns="false">
      <HeaderStyle CssClass="gridheader" />
      <AlternatingItemStyle CssClass="altrow" />
      <Columns>
        <asp:BoundColumn
          HeaderText="Resume Count"
          datafield="resumes"
          />
        <asp:TemplateColumn
          HeaderText="Zip Code"
          >
          <Itemtemplate>
            <a href="findzipcode.aspx?zip=<%# Databinder.Eval(Container.DataItem,"ZipCode") %>"><%# Databinder.Eval(Container.DataItem,"ZipCode") %></a>
          </Itemtemplate>
        </asp:TemplateColumn>
        <asp:BoundColumn
          HeaderText="Zip Code"                   
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
    <div style="text-align: right"><asp:Button ID="btnExport" Text="Export" OnClick="btnExport_Click" runat="server" /></div>
  </form>
</asp:Content>