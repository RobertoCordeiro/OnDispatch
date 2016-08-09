<%@ Page Language="vb" masterpagefile="~/masters/eu.master" %>
<%@ MasterType VirtualPath="~/masters/eu.master" %>
<%@ Import Namespace="BridgesInterface.UserRecord" %>
<%@ Register Src="~/controls/BasicPhoneNumber.ascx" TagName="Phone" TagPrefix="cv" %>

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
      eml.Body &= "Login:" & txtEmailAddress.Text & "<br />"
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
          Case "eu"
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
   Dim val As New cvCommon.Validators
   Dim blnReturn As Boolean = True
   Dim strError As String = ""

   If phn.AreaCode.Trim.Length + phn.LineNumber.Trim.Length + phn.Exchange.Trim.Length > 0 Then
      If phn.AreaCode.Trim.Length <> 3 Then
        blnReturn = False
        strError &= "<li>" & "Phone Area Code is Invalid" & "</li>"
      End If
      If phn.Exchange.Trim.Length <> 3 Then
        blnReturn = False
        strError &= "<li>" & "Phone Exchange is Invalid" & "</li>"
      End If
      If phn.LineNumber.Trim.Length <> 4 Then
        blnReturn = False
        strError &= "<li>" & "Phone Line Number is Invalid" & "</li>"
      End If
    Else
      blnReturn = False
      strError &= "<li>" & "Phone number is Required" & "</li>"
    End If
    If txtReferenceNumber.Text.Trim.Length = 0 Then
      blnReturn = False
      strError &= "<li>A Reference Number is required</li>"
    End If
    If txtEmailAddress.Text.Trim.Length = 0 Then
      If Not val.IsValidEmail(txtEmailAddress.Text.Trim) Then
        blnReturn = False
        strError &= "<li>Email does not appear to be valid</li>"
      End If
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
    Dim lngTicketID as long = 0
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    Dim lngStatusID As long
    Dim lngWorkOrderID As long 
    Dim strRef As String = Request.QueryString("ReturnUrl")
    
    If IsComplete() Then
     
      Dim x As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
      lngTicketID = GetCredentials (txtReferenceNumber.Text,phn.AreaCode,phn.Exchange ,phn.LineNumber )
      If lngTicketID > 0 then
          FormsAuthentication.SetAuthCookie("2",False)
          If IsNothing(strRef) Then
              Dim tkt as New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
              Dim strChangeLog as String = ""
              
              lngWorkOrderID = 0
              tkt.Load (lngTicketID)
              tkt.Email = txtEmailAddress.text
              lngStatusID = tkt.TicketStatusID
              tkt.Save(strChangeLog)
              If Not IsTicketOpened(lngticketID) Then
                 If lngStatusID = 8 then
                    lngWorkOrderID = GetWorkOrderID (lngTicketID)
                    If lngWorkOrderID > 0 then
                       If IsSurveyCompleted (GetWorkOrderID(lngTicketID)) = 0 then
                         Response.Redirect("/eu/Survey.aspx?id=" & lngWorkOrderID & "&returnurl=/eu/ticket.aspx?id=" & lngTicketID & "&c=0")
                       End if
                    Else
                      Response.Redirect("/eu/ticket.aspx?id=" & lngTicketID)
                    end if
                  end if
               Else
                   Response.Redirect("/eu/ticket.aspx?id=" & lngTicketID)
               end if
          Else
             Response.Redirect("default.aspx")
          end if
       Else
          lngTicketID = GetCredentials2(txtReferenceNumber.Text,phn.AreaCode,phn.Exchange,phn.LineNumber )
          If lngTicketID > 0 then 
             FormsAuthentication.SetAuthCookie("2",False)
             If IsNothing(strRef) Then
               Dim tkt as New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
               Dim strChangeLog as String = ""
               tkt.Load (lngTicketID)
               tkt.Email = txtEmailAddress.text
               tkt.Save(strChangeLog)
               If Not IsTicketOpened(lngticketID) Then
                  If lngStatusID = 8 then
                    lngWorkOrderID = GetWorkOrderID (lngTicketID)
                    If lngWorkOrderID > 0 then
                       If IsSurveyCompleted (GetWorkOrderID(lngTicketID)) = 0 then
                         Response.Redirect("/eu/Survey.aspx?id=" & lngWorkOrderID & "&returnurl=/eu/ticket.aspx?id=" & lngTicketID & "&c=0")
                       Else
                         Response.Redirect("/eu/ticket.aspx?id=" & lngTicketID)
                       End if
                    Else
                      Response.Redirect("/eu/ticket.aspx?id=" & lngTicketID)
                    end if
                  Else
                     Response.Redirect("/eu/ticket.aspx?id=" & lngTicketID)
                  end if
                Else
                   Response.Redirect("/eu/ticket.aspx?id=" & lngTicketID)
                end if
             Else
               'Response.Redirect("/eu/default.aspx")
               blnReturn = False
                strErrors &= "<li>No record has been found with information provided.</li>"
                divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
                lblErrorText.Text = strErrors
                divErrors.Visible = True
             End If
          else
            'Response.Redirect("/eu/default.aspx")
            blnReturn = False
            strErrors &= "<li>No record has been found with information provided.</li>"
            divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
            lblErrorText.Text = strErrors
            divErrors.Visible = True
          end if  
        end if 
    Else
       'Response.Redirect("/eu/default.aspx")
            blnReturn = False
            strErrors &= "<li>No record has been found with information provided.</li>"
            divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
            lblErrorText.Text = strErrors
            divErrors.Visible = True
    end if     
  End Sub
  
    Private Function GetCredentials(strReferenceNumber as String, strAreaCode as String, strExchange as String, strLineNumber as string)as long
        Dim blnReturn As Boolean = True
        Dim strErrors As String = ""
        Dim lngTicket As long = 0
        Dim lngTotal As Long = 0
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetTicketByPhoneReferenceNumber")
        cmd.Parameters.Add("@ReferenceNumber", Data.SqlDbType.VarChar).Value = strReferenceNumber
        cmd.Parameters.Add("@PhoneNumber1", Data.SqlDbType.VarChar).Value = strAreaCode
        cmd.Parameters.Add("@PhoneNumber2", Data.SqlDbType.VarChar).Value = strExchange
        cmd.Parameters.Add("@PhoneNumber3", Data.SqlDbType.VarChar).Value = strLineNumber
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            lngTotal = dtr("Total")
            If lngTotal > 0 Then
              lngTicket = GetTicketID(strReferenceNumber,strAreaCode,strExchange,strLineNumber )
              Return lngTicket
            Else
              if IsNumeric(strReferenceNumber) then
                 lngTicket =  GetCredentials2 (Ctype(strReferenceNumber,Long),strAreaCode,strExchange,strLineNumber)
                 If lngTicket > 0 then
                   Return lngTicket
                 end if
              else
                blnReturn = False
                strErrors &= "<li>No record has been found with information provided.</li>"
                divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
                Return lngTicket
              end if
            End If
        End While
        cnn.Close()
       
    end Function 
    
     Private Function GetCredentials2(lngTicketID as long, strAreaCode as String, strExchange as String, strLineNumber as string)as long
        Dim blnReturn As Boolean = True
        Dim strErrors As String = ""
        Dim lngTicket As long = 0
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetTicketByPhoneTicketID")
        cmd.Parameters.Add("@TicketID", Data.SqlDbType.int).Value = lngTicketID
        cmd.Parameters.Add("@PhoneNumber1", Data.SqlDbType.VarChar).Value = strAreaCode
        cmd.Parameters.Add("@PhoneNumber2", Data.SqlDbType.VarChar).Value = strExchange
        cmd.Parameters.Add("@PhoneNumber3", Data.SqlDbType.VarChar).Value = strLineNumber
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            lngTicket = dtr("TicketID")
            If lngTicket > 0 Then
              Return lngTicket
            Else
                blnReturn = False
                strErrors &= "<li>No record has been found with information provided.</li>"
                divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
                Return lngTicket
            End If
        End While
        
        cnn.Close()
       
    end Function 
    
    Private Function IsTicketOpened(ByVal lngTicketID As Long) As Boolean
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spIsticketOpen")
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TicketID", Data.SqlDbType.Int).Value = lngTicketID
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr1 As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr1.Read
            IsTicketOpened = dtr1("Result")
        End While
        cnn.Close()
    End Function
    
    Private Function IsSurveyCompleted (lngWorkOrderID As Long) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spCountSurveyAnswerByWorkOrderID")
  
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@WorkOrderID", Data.SqlDbType.Int).Value = lngWorkOrderID
        cnn.open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            IsSurveyCompleted = dtr("Total")
        End While
        cnn.Close()

    end function
    Private Function GetWorkOrderID (lngTicketID As Long) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetWorkOrderIDByTicketID")
  
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TicketID", Data.SqlDbType.Int).Value = lngTicketID
        cnn.open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            GetWorkOrderID = dtr("WorkOrderID")
        End While
        cnn.Close()

    end function
    
    Private Function GetTicketID (strReferenceNumber as String, strAreaCode as String, strExchange as String, strLineNumber as string) As Long
        Dim blnReturn As Boolean = True
        Dim strErrors As String = ""
        Dim lngTicket As long = 0
        
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetTicketByPhoneReferenceNumber2")
        cmd.Parameters.Add("@ReferenceNumber", Data.SqlDbType.VarChar).Value = strReferenceNumber
        cmd.Parameters.Add("@PhoneNumber1", Data.SqlDbType.VarChar).Value = strAreaCode
        cmd.Parameters.Add("@PhoneNumber2", Data.SqlDbType.VarChar).Value = strExchange
        cmd.Parameters.Add("@PhoneNumber3", Data.SqlDbType.VarChar).Value = strLineNumber
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            lngTicket = dtr("TicketID")
            Return lngTicket
        end while
        cnn.Close()

    end Function
    
    
</script>
<asp:Content ID="cntLogin" ContentPlaceHolderID="cntMain" runat="server">
   <form id="frmLogin" runat="server" class="FBG">
    <div style="text-align:center"><h2>Web Portal </h2></div> 
    <div><cv:Phone Text="Phone Number" RequirePhone="true" ID="phn" runat="server" /></div>
    <div style="text-align:left;"><b>Reference Number *</b></div>                
    <div ><asp:textbox style="width: 50%" id="txtReferenceNumber" runat="server" /></div>
    <div style="text-align:left;"><b>Email Address *</b></div>
    <div><asp:textbox style="width: 50%" id="txtEmailAddress" runat="server" /></div>&nbsp;
    <div style="text-align: right;"><asp:button ID="btnLogin" runat="server" Text="Log In" OnClick="AttemptLogin" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
    <div>&nbsp;</div>
    <div style="text-align:left" visible ="false"><asp:CheckBox ID="chkRememberMe" runat="server" Text="Remember me" Visible ="false"/></div>
    <div style="font-weight: bold;" ><asp:label id="lblWelcome" runat="server" /></div>
    <div >&nbsp;</div>
    <div id="divErrors" visible="false" runat="server" class="errorzone"><asp:Label ID="lblErrorText" runat="server" /></div>
    
  </form>
 </asp:Content>