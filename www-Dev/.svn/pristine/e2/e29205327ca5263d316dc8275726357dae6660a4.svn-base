<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server"> 
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = ""
      Master.PageTitleText = ""
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; "
    End If
    Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("Select * From tblTickets")
    cmd.CommandType = Data.CommandType.Text
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    cnn.Open()
    cmd.Connection = cnn
    Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
    While dtr.Read
      tkt.Load(dtr("TicketID"))
      Response.Write(dtr("TicketID"))
      Response.Flush()
    End While
    cnn.Close()
  End Sub
  
</script>
