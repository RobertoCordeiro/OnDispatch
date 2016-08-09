<%@ Page Language="vb" masterpagefile="~/masters/chat.master" ValidateRequest="false" %>
<%@ MasterType VirtualPath="~/masters/chat.master" %>
<script runat="server">
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)

    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
            'Master.PageHeaderText = ""
            'Master.PageTitleText = ""
            'Master.PageSubHeader = ""
    End If
    TrackTraffic()
  End Sub
  
  Private Sub TrackTraffic()
    Dim tm As New cvTrafficMaster.TransactionRecord(System.Configuration.ConfigurationManager.AppSettings("TMCnn"))
    tm.Add(Request.ServerVariables("SCRIPT_NAME"))
    If Not IsNothing(Request.ServerVariables("HTTP_REFERER")) Then
      tm.Referrer = Request.ServerVariables("HTTP_REFERER")
    End If
    If Not IsNothing(Request.ServerVariables("HTTP_USER_AGENT")) Then
      tm.UserAgent = Request.ServerVariables("HTTP_USER_AGENT")
    End If
    If Not IsNothing(Request.ServerVariables("REMOTE_ADDR")) Then
      tm.RemoteAddress = Request.ServerVariables("REMOTE_ADDR")
    End If
    If Not IsNothing(Request.ServerVariables("QUERY_STRING")) Then
      tm.QueryString = Request.ServerVariables("QUERY_STRING")
    End If
    If Not IsNothing(Request.ServerVariables("SERVER_NAME")) Then
      tm.ServerName = Request.ServerVariables("SERVER_NAME")
    End If
    Dim strChangelog As String = ""
    tm.Save(strChangelog)
    Dim tf As New cvTrafficMaster.FlagRecord(System.Configuration.ConfigurationManager.AppSettings("TMCnn"))
    tf.LoadByRemoteHost(tm.RemoteAddress)
    If tf.FlagID > 0 Then
      Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      eml.SendFrom = System.Configuration.ConfigurationManager.AppSettings("TrafficMasterEmail")
      eml.SendTo = System.Configuration.ConfigurationManager.AppSettings("TrafficMasterEmail")
      eml.Subject = "Possible Internal Security Breach!"
      eml.Body = "<p>A user at a flagged IP Address accessed the system, this is a possible security breach!</p>"
      eml.Body &= "<div>Details</div>"
      eml.Body &= "User ID: " & Master.UserID & "<br />"
      eml.Body &= "Web Login ID:" & Master.WebLoginID & "<br />"
      eml.Send()
    End If
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
<form id="frmMain" runat="server">
    <table style="margin-left: auto; margin-right: auto;" class="inputform">
      <tbody>
        <tr>
          <td>
            <div style="height:600px;"><iframe style='overflow:hidden;height:100%;' frameborder='0' border='0' src="http://chat.zoho.com/shout.sas?k=%7B%22g%22%3A%22Anonymous%22%2C%22c%22%3A%22d284c45b46972075d07f8f82798954e35579346be8a4d778%22%2C%22o%22%3A%228e115ce8aa358e285547739b0c0e4f1d%22%7D&chaturl=Best%20Servicers&V=000000-70a9e1-eff4f9-70a9e1-BSA%20Group%20US"></iframe></div>
          </td>  
        </tr>
      </tbody>
    </table>      
</form>
</asp:Content>
