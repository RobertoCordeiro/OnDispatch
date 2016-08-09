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
        
        Dim report As Reports.rptVendorInvoices = CType(Me.ReportViewer1.Report, Reports.rptVendorInvoices)
        report = New  Reports.rptVendorInvoices(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        
        report.Param1 = CInt(Request.QueryString("id"))

        reportviewer1.report = report
        
  End Sub
  
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">

<form id="form1" runat="server">
    <div>
        <telerik:ReportViewer ID="ReportViewer1" runat="server" Height="537px" Width="100%" ZoomMode="FullPage" Report="Reports.rptVendorInvoices, Reports, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null" />
    
    </div>
</form>

</asp:Content>