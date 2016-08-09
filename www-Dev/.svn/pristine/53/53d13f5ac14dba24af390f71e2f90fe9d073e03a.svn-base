<%@ Page Language="vb" masterpagefile="~/masters/partner.master" %>
<%@ MasterType VirtualPath="~/masters/partner.master" %>
<script language="VB" runat="server">
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Messages to Technicians"
      Master.PageTitleText = " Messages to Technicians"
      Master.ActiveMenu = "A"
    End If
    Try
      lblReturnUrl.Text = Request.QueryString("returnurl")
    Catch ex As Exception
    End Try
    If Not IsPostBack Then      
       lblTotalMessages.Text = "Total Messages: " & GetTotalMessages(Master.PartnerAgentID )
       GetMessage(master.PartnerAgentID)
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
      eml.SendFrom = "info@bestservicers.com"
      eml.SendTo = "info@bestservicers.com"
      eml.Subject = "Possible Partner Security Breach!"
      eml.Body = "<p>A user at a flagged IP Address accessed the system, this is a possible security breach!</p>"
      eml.Body &= "<div>Details</div>"
      eml.Body &= "User ID: " & Master.UserID & "<br />"
      eml.Body &= "Web Login ID:" & Master.WebLoginID & "<br />"
      eml.Send()
    End If
  End Sub
  
  Private Sub btnlnkOld_Click (ByVal S As Object, ByVal E As EventArgs)
      Multiview1.ActiveViewIndex = 1
      GetOldMessages()
  end sub  
  
    Private Sub MessageDelivered(ByVal S As Object, ByVal E As EventArgs)
      Dim msg as New BridgesInterface.PartnerAgentMessageRecord (System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim strChangeLog as String = ""
      Dim intTotalMessages as Integer 

      msg.Load(Ctype(lblPartnerAgentMessageID.text,Long))
      msg.Delivered = True 
      msg.DeliveredDate = Datetime.Now()
      msg.DeliveredBy = Master.WebLoginID 
      msg.Save(strChangeLog)
      
        EmailAdmin(msg.CreatedBy, msg.PartnerAgentID, msg.Message)
        
      intTotalMessages = getTotalMessages(Master.PartnerAgentID)
      if intTotalMessages > 0 then
         lblTotalMessages.Text = "Total Messages: " & intTotalMessages
         GetMessage(Master.PartnerAgentID)
          
      else
         Response.Redirect(lblReturnURL.text, True)
      end if
      
    End Sub
    
    
    Private Function GetTotalMessages (lngPartnerAgentID as Long) as Integer 
            Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            Dim cmd As New System.Data.SqlClient.SqlCommand("spGetTotalMessagesForPartnerAgent")
            cmd.CommandType = Data.CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentID", Data.SqlDbType.Int).Value = lngPartnerAgentID 
            cnn.Open()
            cmd.Connection = cnn
            Return cmd.ExecuteScalar 
            
            cnn.Close()
    
    end Function
    
    
    Private Sub GetMessage (lngPartnerAgentID as Long)  
            Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            Dim cmd As New System.Data.SqlClient.SqlCommand("spGetPartnerAgentMessageByPartnerAgentID")
            cmd.CommandType = Data.CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentID", Data.SqlDbType.Int).Value = lngPartnerAgentID
            cnn.Open()
            cmd.Connection = cnn
            cmd.ExecuteScalar 
            Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
            While dtr.Read
              lblCreatedDate.text = "Created On: " & dtr("CreatedDate")
              lblCreatedBy.text = "Sent By: " & GetUserName(dtr("CreatedBy"))
              txtMessage.Text = dtr("Message")
              lblPartnerAgentMessageID.text = dtr("PartnerAgentMessageID")
              getDelivered.Checked = dtr("delivered")
              
            End While
            lblTotalMessages.Text = "Total New Messages: " & GetTotalMessages(Master.PartnerAgentID )
            cnn.Close()
    
    end Sub
    
    Private Function GetUserName (lngLogin as long) as String
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            Dim cmd As New System.Data.SqlClient.SqlCommand("spGetWebLoginUser")
            Dim strUserName as string
            struserName = ""
            cmd.CommandType = Data.CommandType.StoredProcedure
            cmd.Parameters.Add("@Login", Data.SqlDbType.Int).Value = lngLogin
            cnn.Open()
            cmd.Connection = cnn
            cmd.ExecuteScalar 
            Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
            While dtr.Read
             
              strUserName = dtr("FirstName") & "  " & dtr("LastName")
            End While
            GetUserName = strUserName
            cnn.Close()
  
    End Function
    
    Private sub ClearForm ()
      
      lblTotalMessages.Text = "Total Messages: 0 "  
      lblCreatedDate.text = ""
      lblCreatedBy.text = ""
      getdelivered.Checked = False
      txtMessage.Text = ""
    end sub
    
    Private Sub GetOldMessages()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListOldPartnerAgentMessagesByID", "@PartnerAgentID",Master.PartnerAgentID, dgvNotes)
    lblTotalMessages.Text = "Total Old Messages: " & dgvnotes.Items.Count()
    
    
    end sub
    Private Sub btnClose_Click (ByVal S As Object, ByVal E As EventArgs)
      Response.Redirect(lblReturnURL.text, True)
    
    end sub
    Private Sub btnNew_Click (ByVal S As Object, ByVal E As EventArgs)
     
      Multiview1.ActiveViewIndex = 0
      GetMessage(Master.PartnerAgentID )
    
  end sub
    Private Sub EmailAdmin(ByVal lngLoginID As Long, ByVal lngPartnerAgentID As Long, ByVal strMessage As String)
        Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
        Dim usr As New BridgesInterface.UserRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        par.Load(lngPartnerAgentID)
        eml.Subject = "Your Message has been delivered to the technician:" & par.FirstName & " " & par.LastName
        eml.Body = strMessage
        eml.SendFrom = "DoNotReply@bestservicers.com"
        usr.Load(GetUserID(lngLoginID))
        
        eml.SendTo = usr.Email
           
        eml.Send()
    End Sub
    Private Function GetUserID(ByVal lngLogin As Long) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetWebLoginUser")
        Dim lngUserID As Long
        lngUserID = 0
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@Login", Data.SqlDbType.Int).Value = lngLogin
        cnn.Open()
        cmd.Connection = cnn
        cmd.ExecuteScalar()
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
             
            lngUserID = dtr("UserID")
        End While
        GetUserID = lngUserID
        cnn.Close()
  
    End Function
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server" >
  <form id="frmChangeSignature" runat="server" style="" >
    <table style="width: 600px;" border ="1">
      <tbody>
        <tr>
          <td >
            <div id="divForm" style="margin-left: 4px; margin-right: 4px; margin-top: 4px; margin-bottom: 4px;" runat="server">
              <div class="errorzone" id="divError" runat="server" visible="false" />
              <div class="label"></div>
              <asp:Label ID="lblTotalMessages" runat ="server"></asp:Label> 
              <div style="text-align: right"><asp:LinkButton id="LinkNew" OnClick="btnNew_Click" runat="server">[New]</asp:LinkButton>&nbsp;&nbsp;&nbsp;&nbsp;<asp:LinkButton id="LinkOld" OnClick="btnlnkOld_Click" runat="server">[Old]</asp:LinkButton></div>     
              <div>&nbsp;</div>
              <asp:MultiView ID="Multiview1" runat="server" ActiveViewIndex = "0" >
                <asp:View ID="vwToBeDelivered"  runat="server">
                 <asp:Label ID="lblCreatedDate" runat ="server" Visible = "true"  /> &nbsp;&nbsp;<asp:Label ID="lblCreatedBy" runat ="server" /> <asp:Label ID="lblPartnerAgentMessageID" runat ="server" Visible="false" />
                 <asp:TextBox ID="txtMessage" TextMode="MultiLine" runat="server" style="width: 99%; height: 100px;" ReadOnly = "true" />
                   <div style="text-align: right"><asp:CheckBox ID="GetDelivered" runat="server"  Text="Delivered" OnCheckedChanged="MessageDelivered"  AutoPostBack="true" /></div>
                
                </asp:View>
                <asp:View ID="vwDelivered"  runat="server">
                   <asp:DataGrid ID="dgvNotes" runat="server" ShowHeader="false" AutoGenerateColumns="false" style="background-color: White;">
              <AlternatingItemStyle CssClass="altrow" />   
              <Columns>
                <asp:BoundColumn HeaderText="ID" DataField="PartnerAgentMessageID" Visible="false" />
                <asp:TemplateColumn ItemStyle-Width="1%" ItemStyle-VerticalAlign="top" >
                  <ItemTemplate>
                    <div style="white-space:nowrap;">Date:<%# Databinder.eval(Container.DataItem, "CreatedDate") %></div>
                    <div>Created By:<%# Databinder.eval(Container.DataItem, "Author") %></a></div>
                    <div>Delivered: <%# Databinder.eval(Container.DataItem, "Delivered") %></div>
                    <div>Delivered Date: <%#DataBinder.Eval(Container.DataItem, "DeliveredDate")%></div>
                    <div>Delivered By: <%#DataBinder.Eval(Container.DataItem, "Deliverer")%></div>
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn ItemStyle-Wrap="true">
                  <Itemtemplate>
                  <%# Databinder.eval(Container.DataItem, "Message").ToString.Replace(environment.NewLine,"<br />") %>
                  </Itemtemplate>
                </asp:TemplateColumn>
              </Columns>
            </asp:DataGrid>    
                
                </asp:View>
             </asp:MultiView>
             </div>
             <div>&nbsp;</div>
             <div style="text-align: right"><asp:Label ID="lblReturnURL" runat ="server" Visible = "false"  /><asp:Button ID="btnClose"  Text="Close" runat="Server" OnClick ="btnClose_Click" /></div>
          </td>
        </tr>
        
      </tbody>
    </table>
  </form>
</asp:Content>