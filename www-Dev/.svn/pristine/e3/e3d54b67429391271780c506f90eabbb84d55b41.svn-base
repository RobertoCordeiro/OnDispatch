<%@ Page Language="vb" %>

<%@ Register Assembly="Telerik.ReportViewer.WebForms, Version=2.0.1.0, Culture=neutral, PublicKeyToken=a9d7983dfcc261be"
    Namespace="Telerik.ReportViewer.WebForms" TagPrefix="telerik" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    Dim _ID As Long = 0
    
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
   
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try 
        'If Not IsPostBack Then
        Dim report As Reports.rptOldInvoices = CType(Me.ReportViewer1.Report, Reports.rptOldInvoices)
        report.Param1 = CInt(Request.QueryString("ID"))
        'TryCast(Me.ReportViewer1.Report, Reports.rptOldInvoices).Param1 = 124
        'Me.ReportViewer1.Report = report
            
        'End If
    End Sub

</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Reports</title>
    <link href="mvwres:1-Telerik.ReportViewer.WebForms.Skins.Default.ReportViewer.css,Telerik.ReportViewer.WebForms, Culture=neutral, PublicKeyToken=a9d7983dfcc261be"
        rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <telerik:ReportViewer ID="ReportViewer1" runat="server" Height="537px" Width="100%" ZoomMode="FullPage" Report="Reports.rptOldInvoices, Reports, Culture=neutral, PublicKeyToken=null" />
    
    </div>
    </form>
</body>
</html>
