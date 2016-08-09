<%@ Page Language="vb" MasterPageFile="~/masters/Survey.master" %>

<%@ MasterType VirtualPath="~/masters/Survey.master" %>
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
      eml.Body &= "Login:" & "services@bestservicers.com" & "<br />"
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
           ' lblWelcome.Text = ""
          Case "agentinterface"
            'lblWelcome.Text = ""
          Case "clients"
            'lblWelcome.Text = ""
          Case "eu"
            'lblWelcome.Text = ""  
          Case Else
            'lblWelcome.Text = strDefaultText
        End Select
      Catch ex As Exception
        'lblWelcome.Text = strDefaultText
      End Try
    Else
      'lblWelcome.Text = strDefaultText
    End If
    if not Ispostback then
      main.ActiveViewIndex = 0
     
      
    end if
    
    
  End Sub
  
  
  Private Function IsComplete() As Boolean
   Dim val As New cvCommon.Validators
   Dim blnReturn As Boolean = True
   Dim strError As String = ""

   
    
    'If txtEmailAddress.Text.Trim.Length = 0 Then
    '  If Not val.IsValidEmail(txtEmailAddress.Text.Trim) Then
    '    blnReturn = False
    '    strError &= "<li>Email does not appear to be valid</li>"
    '  End If
    'End If
    'If Not blnReturn Then
    '  strError = "The following errors occured...<br /><ul class=""errortext"">" & strError & "</ul>"
    '  lblErrorPage3.Text = strError
      
    'End If
    Return blnReturn
  End Function
  
  ''' <summary>
  ''' Attempts to validate the login information
  ''' </summary>
  Private Sub AttemptLogin(ByVal S As Object, ByVal E As EventArgs)
    Dim lngTicketID as long = 0
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
       
    If IsComplete() Then
      Dim strRef As String = Request.QueryString("ReturnUrl")
      Dim x As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
      'lngTicketID = GetCredentials (txtReferenceNumber.Text,phn.AreaCode,phn.Exchange ,phn.LineNumber )
      If lngTicketID > 0 then
          'If x.Validate(txtUserName.Text.Trim, txtPassword.Text.Trim) Then
          FormsAuthentication.SetAuthCookie("2",False)
        
          If IsNothing(strRef) Then
              Dim tkt as New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
              Dim strChangeLog as String = ""
              tkt.Load (lngTicketID)
              'tkt.Email = txtEmailAddress.text
              tkt.Save(strChangeLog)

              Response.Redirect("/eu/ticket.aspx?id=" & lngTicketID)
          Else
            Response.Redirect(strRef)
          End If
       Else
          'lngTicketID = GetCredentials2(txtReferenceNumber.Text,phn.AreaCode,phn.Exchange,phn.LineNumber )
          If lngTicketID > 0 then 
             FormsAuthentication.SetAuthCookie("2",False)
        
             If IsNothing(strRef) Then
               Dim tkt as New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
               Dim strChangeLog as String = ""
               tkt.Load (lngTicketID)
               'tkt.Email = txtEmailAddress.text
               tkt.Save(strChangeLog)

               Response.Redirect("/eu/ticket.aspx?id=" & lngTicketID)
             Else
               'Response.Redirect("/eu/default.aspx")
               blnReturn = False
                strErrors &= "<li>No record has been found with information provided.</li>"
                
                'lblErrorPage3.Text = strErrors
                
               
             End If
          else
            'Response.Redirect("/eu/default.aspx")
            blnReturn = False
            strErrors &= "<li>No record has been found with information provided.</li>"
           
            
          end if  
        end if  
     end if
  End Sub
  
    Private Function GetCredentials(strReferenceNumber as String, strAreaCode as String, strExchange as String, strLineNumber as string)as long
        Dim blnReturn As Boolean = True
        Dim strErrors As String = ""
        Dim lngTicket As long = 0
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
            lngTicket = dtr("TicketID")
            If lngTicket > 0 Then
              Return lngTicket
            Else
              if IsNumeric(strReferenceNumber) then
                 lngTicket =  GetCredentials2 (Ctype(strReferenceNumber,Long),strAreaCode,strExchange,strLineNumber)
              else
                blnReturn = False
                strErrors &= "<li>No record has been found with information provided.</li>"
                
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
                
                Return lngTicket
            End If
        End While
        
        cnn.Close()
       
    end Function 
    
    Private Sub btnMoveNext_Click (ByVal sender As Object, e As System.Web.UI.ImageClickEventArgs)
     
        Select Case main.ActiveViewIndex.ToString
            
            Case Is = 0 'Type of Service needed
                if IsPage1Complete then
                  main.ActiveViewIndex = 1 
                else
                  lblErrorPage1.Visible = True
                end if
                
            Case Is = 1 ' Address
                if IsPage2Complete then
                  main.ActiveViewIndex = 2 
                else
                  lblErrorPage2.Visible = True
                end if
                
            Case Is = 2 'contact
                if IsPage3Complete then
                  main.ActiveViewIndex = 3 
                else
                  lblErrorPage3.Visible = True
                end if
            Case Is = 3 'unit information
                if IsPage4Complete then
                  main.ActiveViewIndex = 4 
                else
                  lblErrorPage4.Visible = True
                end if
            Case Is = 4 'date for service
                if IsPage5Complete then
                 
                   main.ActiveViewIndex = 5 
                  
                 else
                   lblErrorPage5.Text = "Our system indicates that there is already a service ticket in our database for your unit. Please call 561.886.6699 for assistance."
                   lblErrorPage5.Visible = True
                 end if
                
            Case Is = 5 'payment
                  main.ActiveViewIndex = 6 
        End Select
    
    
    
    End Sub
    Private Sub btnMoveBack_Click (ByVal sender As Object, e As System.Web.UI.ImageClickEventArgs)
    Select Case main.ActiveViewIndex.ToString
            
            Case Is = 5
                main.ActiveViewIndex = 4
            Case Is = 4
                main.ActiveViewIndex = 3
            Case Is = 3
                main.ActiveViewIndex = 2
            Case Is = 2
                main.ActiveViewIndex = 1
            Case Is = 1
                main.ActiveViewIndex = 0 
            
        End Select
    
    End Sub
    
    
    Private Sub CreateTicket ()
    'for testing purpose Customer ID = 1
    'if IsDuplicate(1,txtSerialNumber.text) = 0 then
    
    
                
                
    End Sub
    
    Private Function IsPage1Complete () as Boolean 
    Dim blnReturn As Boolean = True
    Dim strError As String = ""
    Dim str as String

    
    IsPage1Complete = blnReturn
    End Function
    
    Private Function IsPage2Complete () as Boolean 
    Dim blnReturn As Boolean = True
    Dim strError As String = ""
    
        
   
    
    IsPage2Complete = blnReturn
    End Function
    
    Private Function IsPage3Complete () as Boolean 
    Dim blnReturn As Boolean = True
    Dim strError As String = ""
    
    IsPage3Complete = blnReturn
    end Function
    
    Private Function IsPage4Complete () as Boolean 
     Dim blnReturn As Boolean = True
     Dim strError As String = ""
     
     
     IsPage4Complete = blnReturn
    end Function
    
    Private Function IsPage5Complete () as Boolean 
     Dim blnReturn As Boolean = True
     Dim strError As String = ""
     
     IsPage5Complete = blnReturn
     
    end function
    
     
    
    
</script>

<asp:Content ID="cntLogin" ContentPlaceHolderID="cntMain" runat="server">
    <form id="frmLogin" runat="server" >
        <asp:MultiView ID="main" runat="server">
            <asp:View ID="TypeofJob" runat="server">
                <div>&nbsp;</div>
                <div><h3>Was your service In-Warranty or Out of Warranty:</h3></div>
                <div>
                <asp:RadioButtonList ID="TypeofService" runat="server">
                <asp:ListItem  value = "1" Text="In-Warranty" ></asp:ListItem>
                <asp:ListItem Value="2" Text="Out of Warranty"></asp:ListItem>
                </asp:RadioButtonList></div>
                <div>&nbsp;</div>
                <div>&nbsp;</div>
                <div style="color:Red;"><asp:Label visible= "false" ID="lblErrorPage1" runat ="server"/></div>
                <div style="text-align:center; "><asp:ImageButton ID="imgNext" runat="server"  ImageUrl="/graphics/arrows_grey_071.gif"  OnClick="btnMoveNext_Click" /></div>
            
            </asp:View>
            
            <asp:View ID="Address" runat="server" >
                <div>&nbsp;</div>
                <div><h3>How do our Call Center Representatives rate on the following attributes?</h3></div>
                <table>
                  <tr>
                    <td style="width:50px;">&nbsp;</td>
                    <td style="width:50px;text-align :center;">Excellent</td>
                    <td style="width:100px;text-align :center;">Very Good</td>
                    <td style="width:50px;text-align :center;">Good</td>
                    <td style="width:50px;text-align :center;">Fair</td>
                    <td style="width:50px;text-align :center;">Poor</td>
                  </tr>
                  <tr>
                    <td ><b>Friendliness</b></td>
                    <td colspan="5" style="text-align :center;"><asp:RadioButtonList ID="RadioButtonList1" runat="server" RepeatDirection ="Horizontal"   >
                           <asp:ListItem  value = "1" Text="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" ></asp:ListItem>
                           <asp:ListItem  value = "2" Text="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"></asp:ListItem>
                           <asp:ListItem  value = "3" Text="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"></asp:ListItem>
                           <asp:ListItem  value = "4" Text="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"></asp:ListItem>
                           <asp:ListItem  value = "5" Text="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                    
                  </tr>
                
                </table>
                <div style="color:Red;"><asp:Label ID="lblErrorPage2" visible = "false" runat ="server"/></div>
                <div style="text-align:center; "><asp:ImageButton ID="ImageButton1" runat="server"  ImageUrl="/graphics/arrows_grey_072.gif" OnClick="btnMoveBack_Click" />   <asp:ImageButton ID="ImageButton3" runat="server"  ImageUrl="/graphics/arrows_grey_071.gif" OnClick="btnMoveNext_Click"/></div>

            </asp:View>
            
            <asp:View ID="contact" runat="server" >
            <div >
                    <h3>Contact Information</h3>
                </div>
                <div style="text-align: left;">
                    <b>First Name *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Last Name *</b></div>
                <div>
                    <asp:TextBox Style="width: 20%" ID="txtFirstName" runat="server" />&nbsp;&nbsp;&nbsp;&nbsp;<asp:TextBox Style="width: 20%" ID="txtLastName" runat="server" /></div>
                <div style="text-align: left;">
                <div>
                    <cv:Phone Text="Home Number" RequirePhone="true" ID="phn" runat="server" />
                </div>
                <div>
                    <cv:Phone Text="Cell Number" RequirePhone="true" ID="phnCell" runat="server" />
                </div>
                    <b>Email Address *</b></div>
                <div>
                    <asp:TextBox Style="width: 50%" ID="txtEmailAddress" runat="server" /></div>
                <div style="color:Red;"><asp:Label visible= "false" ID="lblErrorPage3" runat ="server"/></div>
                <div>&nbsp;</div>
                <div style="text-align:center; "><asp:ImageButton ID="imgBack"  runat="server"  ImageUrl="/graphics/arrows_grey_072.gif" OnClick="btnMoveBack_Click" />   <asp:ImageButton ID="ImageButton2" runat="server"  ImageUrl="/graphics/arrows_grey_071.gif"  OnClick="btnMoveNext_Click"/></div>
            </asp:View>
            
            <asp:View ID="UnitInfo" runat="server" >
                <div ><h3>Unit Information</h3></div>
                <div><b>Manufacturer *</b></div>
                <div><asp:TextBox Style="width: 50%" ID="txtManufacturer" runat="server" /></div>
                <div><b>Unit Type *</b></div>
                <div><asp:TextBox Style="width: 50%" ID="txtUnitType" runat="server" /></div>
                <div><b>Model Number *</b></div>
                <div>
                    <asp:TextBox Style="width: 50%" ID="txtModelNumber" runat="server" /></div>
            <div>
                    <b>Serial Number *</b></div>
                <div>
                    <asp:TextBox Style="width: 50%" ID="txtSerialNumber" runat="server" /></div>
            <div>
                    <b>Problem Description *</b></div>
                <div>
                    <asp:TextBox Style="width: 80%" ID="txtProblemDescription" runat="server"  TextMode="MultiLine" /></div>
                <div style="color:Red;"><asp:Label visible= "false" ID="lblErrorPage4" runat ="server"/></div>
                <div>&nbsp;</div>
                <div style="text-align:center; "><asp:ImageButton ID="ImageButton4"  runat="server"  ImageUrl="/graphics/arrows_grey_072.gif" OnClick="btnMoveBack_Click" /><asp:ImageButton ID="ImageButton5" runat="server"  ImageUrl="/graphics/arrows_grey_071.gif"  OnClick="btnMoveNext_Click"/></div>
            </asp:View>
            
            <asp:View runat="server" ID="servicedate">
            <div ><h3>Choose Service Date</h3></div>
            <div style="text-align:left; ">
              <asp:Calendar ID="Calendar1" runat="server" BackColor="White" BorderColor="#999999" CellPadding="4" DayNameFormat="Shortest" Font-Names="Verdana" Font-Size="8pt" ForeColor="Black" Height="150px" Width="230px" >
                <SelectedDayStyle BackColor="#666666" Font-Bold="True" ForeColor="White" />
                <SelectorStyle BackColor="#CCCCCC" />
                <WeekendDayStyle BackColor="#FFFFCC" />
                <TodayDayStyle BackColor="#CCCCCC" ForeColor="Black" />
                <OtherMonthDayStyle ForeColor="#808080" />
                <NextPrevStyle VerticalAlign="Bottom" />
                <DayHeaderStyle BackColor="#CCCCCC" Font-Bold="True" Font-Size="7pt" />
                <TitleStyle BackColor="#999999" BorderColor="Black" Font-Bold="True" />
              </asp:Calendar></div>
              <div>&nbsp;</div>
              <div style="color:Red;"><asp:Label ID="lblErrorPage5" visible = "false" runat ="server"/></div>
              <div style="text-align:center; "><asp:ImageButton ID="ImageButton6" runat="server"  ImageUrl="/graphics/arrows_grey_072.gif" OnClick="btnMoveBack_Click" />   <asp:ImageButton ID="ImageButton7" runat="server"  ImageUrl="/graphics/arrows_grey_071.gif"  OnClick="btnMoveNext_Click"/></div>
            </asp:View>
            <asp:View runat="server" ID="payment">
            <div><h3>Payment for Onsite Diagnostic</h3></div>
            <div>Our technician will diagnose your unit and provide you with a written estimate for the repair. By accepting the estimate, the diagnose fee you are paying now will be applied towards the total of the estimate which will make this a free diagnostic.</div>
            <div>&nbsp;</div>
               <input type="hidden" name="LinkId" value="a1d0d71d-e12b-49e4-b405-61753e3ca098" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
               <asp:ImageButton ID="ImageButPayNow" runat="server"  ImageUrl="/images/paybutton1.jpg" PostBackUrl="https://simplecheckout.authorize.net/payment/catalogpayment.aspx" />
               <div>* By clicking the Pay Now Button, you will be transferred to a secure site to process your credit card transaction.</div>
               <div>* By paying the onsite diagnose fee, our system will key the technician that a new service ticket is ready for service. You will be receiving a phone call to confirm the appointment time within 4 hour of your payment confirmation. If after hours, weekends or holidays, you will be contacted next business day. For any questions, please contact us at 561.886.6699.</div>

            <div style="text-align:center; "><asp:ImageButton ID="ImageButton8"  runat="server"  ImageUrl="/graphics/arrows_grey_072.gif" OnClick="btnMoveBack_Click" visible="False"/>   <asp:ImageButton ID="ImageButton9" runat="server"  ImageUrl="/graphics/arrows_grey_071.gif"  OnClick="btnMoveNext_Click" Visible="false" /></div>
            </asp:View>
            <asp:View >
            </asp:View>
        </asp:MultiView>
    </form>
</asp:Content>
