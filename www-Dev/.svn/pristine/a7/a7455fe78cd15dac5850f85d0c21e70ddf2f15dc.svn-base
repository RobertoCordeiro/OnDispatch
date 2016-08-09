<%@ Page Language="VB" %>
<script language="VB" runat="server">
    
  Private Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
    If Not CType(System.Configuration.ConfigurationManager.AppSettings("DownForMaintenance"), Boolean) Then
      Response.Redirect("default.aspx")
    End If
    lblReturnTime.Text = System.Configuration.ConfigurationManager.AppSettings("ReturnFromMaintenance")
  End Sub
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>Down For Maintenance</title>
  </head>
  <body>
    <div style="text-align: center">We’re sorry the web site is currently down for scheduled maintenance. Services should be restored by <asp:Label ID="lblReturnTime" runat="server" /></div>
  </body>
</html>
