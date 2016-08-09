<%@ Page Language="vb" masterpagefile="~/masters/login.master" %>
<%@ MasterType VirtualPath="~/masters/login.master" %>
<%@ Import Namespace="BridgesInterface.UserRecord" %>
<script runat="server">
 
  Private Sub TrackTraffic()
    Exit Sub
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
      eml.SendFrom = "services@bestservicers.com"
      eml.SendTo = "services@bestservicers.com"
      eml.Subject = "Possible Login Security Breach!"
      eml.Body = "<p>A user at a flagged IP Address tried to access the system, this is a possible security breach!</p>"
      eml.Body &= "<div>Details</div>"
      eml.Body &= "Login:" & txtUserName.Text & "<br />"
      eml.Send()
    End If
  End Sub
  
  Private Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
    Dim strRef As String = Request.QueryString("ReturnUrl")
    Dim strDefaultText As String = ""
    TrackTraffic()
    If Not IsNothing(strRef) Then
      Try
        Select Case strRef.Split("/")(1).ToLower
          Case "partners"
            lblWelcome.Text = ""
          Case "agentinterface"
            lblWelcome.Text = ""
          Case "clients"
            lblWelcome.Text = ""
          Case Else
            lblWelcome.Text = strDefaultText
        End Select
      Catch ex As Exception
        lblWelcome.Text = strDefaultText
      End Try
    Else
      lblWelcome.Text = strDefaultText
    End If
  End Sub
  
  ''' <summary>
  ''' Determines if the input is complete
  ''' </summary>
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strError As String = ""
    If txtUserName.Text.Trim.Length = 0 Then
      blnReturn = False
      strError &= "<li>User Name is required</li>"
    End If
    If txtPassword.Text.Trim.Length = 0 Then
      blnReturn = False
      strError &= "<li>Password is required</li>"
    End If
    If Not blnReturn Then
      strError = "The following errors occured...<br /><ul class=""errortext"">" & strError & "</ul>"
      lblErrorText.Text = strError
      divErrors.Visible = True
    End If
    Return blnReturn
  End Function
  
  ''' <summary>
  ''' Attempts to validate the login information
  ''' </summary>
  Private Sub AttemptLogin(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      Dim strRef As String = Request.QueryString("ReturnUrl")
      Dim x As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
      If x.Validate(txtUserName.Text.Trim, txtPassword.Text.Trim) Then
        FormsAuthentication.SetAuthCookie(x.WebLoginID.ToString, chkRememberMe.Checked)
        
        If IsNothing(strRef) Then
          Select Case x.AccessCoding.ToLower
            Case "c"
              Response.Redirect("/clients/default.aspx")
            Case "a"
              Response.Redirect("/agentinterface/default.aspx")
            Case "p"
              Response.Redirect("/partners/default.aspx")
            Case "r"
                            Response.Redirect("/join/detail.aspx")
                        Case "e"
                            Response.Redirect("/agentinterface/default.aspx")
            Case Else
              lblErrorText.Text = "This login has no associated access rights"
          End Select
          divErrors.Visible = True
        Else
          Response.Redirect(strRef)
        End If
      Else
        FormsAuthentication.SignOut()
        lblErrorText.Text = "The following errors occured...<br /><ul><li>Invalid User Name or Password</li></ul>"
        divErrors.Visible = True
      End If
    End If
  End Sub
  
</script>
<asp:Content ID="cntLogin" ContentPlaceHolderID="cntMain" runat="server">
   <form id="frmLogin" runat="server" class="FBG">
    <div style="text-align:center"><h2>Web Portal </h2></div>            
    <div >&nbsp;</div>
    <div style="text-align:left">User Name</div>                
    <div ><asp:textbox style="width: 50%" id="txtUserName" runat="server" /></div>
    <div style="text-align:left">Password</div>
    <div><asp:textbox TextMode="password" style="width: 50%" id="txtPassword" runat="server" /></div>
    <div >&nbsp;</div>
    <div style="text-align:left"><asp:CheckBox ID="chkRememberMe" runat="server" Text="Remember me" /></div>
    <div style="text-align: right;"><asp:button ID="btnLogin" runat="server" Text="Log In" OnClick="AttemptLogin" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
    <div>&nbsp;</div>
    <div style="font-weight: bold;" ><asp:label id="lblWelcome" runat="server" /></div>
    <div >&nbsp;</div>
    <div id="divErrors" visible="false" runat="server" class="errorzone"><asp:Label ID="lblErrorText" runat="server" /></div>
    
  </form>
 </asp:Content>