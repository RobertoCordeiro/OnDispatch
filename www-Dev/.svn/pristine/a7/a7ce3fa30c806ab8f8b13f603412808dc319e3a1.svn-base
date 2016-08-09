<%@ Page Language="VB" masterpagefile="~/masters/customer.master"%>
<%@ MasterType VirtualPath="~/masters/customer.master" %>
<script language="VB" runat="server">
  Private Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
  
    If User.Identity.IsAuthenticated Then
      Dim lgn As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      lgn.Load(CType(User.Identity.Name, Long))
      Master.ActiveMenu = "A"
      If lgn.WebLoginID > 0 Then
        If lgn.AccessCoding.Contains("C") Then
          Master.WebLoginID = lgn.WebLoginID
          Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("CompanyName") & " Client Access"
          Dim strHeaderText As String = "Client Access"
          Dim strMode As String = ""
          If Not IsNothing(Request.QueryString("mode")) Then
            strMode = Request.QueryString("mode")
          End If
          If strMode.Trim.Length <= 0 Then
            strMode = "news"
          End If
          lnkPresidentsEmail.HRef = "mailto:" & System.Configuration.ConfigurationManager.AppSettings("PresidentsEmail")
          lblPresidentsName.Text = System.Configuration.ConfigurationManager.AppSettings("PresidentsName")
          Select Case strMode.ToLower
            Case "news"
            
              'lnkNews.InnerText = "[News]"
              'lnkNews.Attributes("class") = "selectedclienttablink"
              divNews.Visible = True
              strHeaderText = "Client Access - News"
              LoadNewsArticles()
            Case "help"
              'lnkHelp.InnerText = "[Help]"
              'lnkHelp.Attributes("class") = "selectedclienttablink"
              divHelp.Visible = True
              strHeaderText = "Client Access - Help"
            Case "contact"
              'lnkContact.InnerText = "[Contact]"
              'lnkContact.Attributes("class") = "selectedclienttablink"
              divContact.Visible = True
              strHeaderText = "Client Access - Contact"
              lblStreet.Text = System.Configuration.ConfigurationManager.AppSettings("StreetAddress")
              lblExtended.Text = System.Configuration.ConfigurationManager.AppSettings("Extended")
              lblCityStateZip.Text = System.Configuration.ConfigurationManager.AppSettings("City") & " " & System.Configuration.ConfigurationManager.AppSettings("State") & ", " & System.Configuration.ConfigurationManager.AppSettings("ZipCode")
              lblPhone.Text = System.Configuration.ConfigurationManager.AppSettings("PhoneNumber")
              lblFax.Text = System.Configuration.ConfigurationManager.AppSettings("FaxNumber")
          End Select
          Master.PageHeaderText = strHeaderText
        Else
          Response.Redirect("/login.aspx", True)
        End If
      Else
        Response.Redirect(User.Identity.Name, True)
      End If
    Else
      Response.Redirect("/login.aspx", True)
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
      eml.Subject = "Possible Client Security Breach!"
      eml.Body = "<p>A user at a flagged IP Address accessed the system, this is a possible security breach!</p>"
      eml.Body &= "<div>Details</div>"
      eml.Body &= "User ID: " & Master.UserID & "<br />"
      eml.Body &= "Web Login ID:" & Master.WebLoginID & "<br />"
      eml.Send()
    End If
  End Sub
  
  Private Sub LoadNewsArticles()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDataGrid("spListCustomerNewsArticles", dgvNews)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" runat="server">
<form runat="server" id="frmDefault">
 <div class="minHeight" runat="server">
  <div id="divNews" runat="server" visible="false">
      <asp:DataGrid ShowHeader="false" style="width: 100%" ID="dgvNews" runat="server" AutoGenerateColumns="false" >
      <AlternatingItemStyle CssClass="altrow" /> 
      <Columns>
        <asp:TemplateColumn>
          <ItemTemplate>
            <div class="ticketformsectionheader"><%#DataBinder.Eval(Container.DataItem, "ArticleSubject")%></div>
            <div style="font-size: 7pt"><%#DataBinder.Eval(Container.DataItem, "DateCreated")%>&nbsp;<a href="mailto:<%# Databinder.eval(Container.DataItem, "email") %>"><%# Databinder.eval(Container.DataItem, "FirstName") %>&nbsp;<%# Databinder.eval(Container.DataItem, "LastName") %></a></div>
            <div><%#DataBinder.Eval(Container.DataItem, "ArticleText")%></div>            
            <div>&nbsp;</div>
          </ItemTemplate>
        </asp:TemplateColumn>  
      </Columns>
    </asp:DataGrid>
  </div>
  <div id="divContact" runat="server" visible="false">
    <div class="bandheader">Phone Numbers</div>
    <table>
      <tbody>
        <tr>
          <td class="label">Voice</td>
          <td>&nbsp;</td>
          <td><asp:Label ID="lblPhone" runat="server" /></td>
        </tr>
        <tr>
          <td class="label">Fax</td>
          <td>&nbsp;</td>
          <td><asp:Label ID="lblFax" runat="server" /></td>
        </tr>
      </tbody>
    </table>
    <div>&nbsp;</div>    
    <div class="bandheader">Mailling Address</div>
    <div><asp:Label ID="lblStreet" runat="server" /></div>
    <div><asp:Label ID="lblExtended" runat="server" /></div>
    <div><asp:Label ID="lblCityStateZip" runat="server" /></div>
    <div>&nbsp;</div>
    <div class="bandheader">Email Addresses</div>
    <table>
      <tbody>
        <tr>
          <td class="label">President</td>
          <td>&nbsp;</td>
          <td><a id="lnkPresidentsEmail" runat="server"><asp:Label runat="server" ID="lblPresidentsName" /></a></td>
        </tr>       
      </tbody>
    </table>
  </div>
  <div id="divHelp" runat="server" visible="false">
    <div class="bandheader"></div>
    <ul>
      <li>&nbsp;</li>
      <li><a href="viewfaq.aspx?id=5">General FAQ</a></li>
    </ul>
  </div>
  </div>
   </form>
</asp:Content>