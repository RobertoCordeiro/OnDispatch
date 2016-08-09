<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<%@ Register Assembly="Telerik.ReportViewer.WebForms, Version=2.0.1.0, Culture=neutral, PublicKeyToken=a9d7983dfcc261be"
    Namespace="Telerik.ReportViewer.WebForms" TagPrefix="telerik" %>
<script runat="server">

  Private _ID As Long = 1
  

  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
        
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Ticket Management"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Ticket Management"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; Ticket Management"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
      If _ID < 1 Then
        _ID = 1
      End If
    Catch ex As Exception
      _ID = 1
    End Try
        
        Dim report As Reports.InvoiceSingle = CType(Me.ReportViewer1.Report, Reports.InvoiceSingle)
        report = New Reports.InvoiceSingle(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        
        report.Param1 = CInt(Request.QueryString("id"))
        
        ReportViewer1.Report = report
        
  End Sub
  
  
</script>
<asp:Content contentplaceholderID="bodycontent" id="cntBody" runat="server">

<form id="form1" runat="server">
    <div >
        <telerik:ReportViewer id="ReportViewer1" runat="server" height="537px" width="100%" zoommode="PageWidth" report="Reports.InvoiceSingle, Reports, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null" />
    
    </div>
</form>

</asp:Content>