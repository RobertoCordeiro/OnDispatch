<%@ Page Language="VB" masterpagefile="~/masters/agentdialog.master"%>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script language="VB" runat="server">
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Messages to Technician"
      Master.PageTitleText = "Message to Technician"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; Message to Technician"
    End If
    Try
      lblReturnUrl.Text = Request.QueryString("returnurl")
    Catch ex As Exception
    End Try
    If Not IsPostBack Then      
       LoadPartnerAgents()
    End If
  End Sub
  Private Sub btnlnkNew_Click (ByVal S As Object, ByVal E As EventArgs)
    If drpPartnerAgents.SelectedValue  <> "Choose One" then
      Multiview1.ActiveViewIndex = 0
     else
            MsgBox("You must choose a technician to write him a  message.")
    end if 
    
    
  end sub
  Private Sub btnlnkDeliver_Click (ByVal S As Object, ByVal E As EventArgs)
     If drpPartnerAgents.SelectedValue <> "Choose One" then
      Multiview1.ActiveViewIndex = 1
      GetMessage(drpPartnerAgents.SelectedValue )
    else
            MsgBox("You must choose a technician to deliver messages to him.")
    end if
  end sub
  Private Sub btnlnkOld_Click (ByVal S As Object, ByVal E As EventArgs)
    
    If drpPartnerAgents.SelectedValue <> "Choose One" then
      Multiview1.ActiveViewIndex = 2
      GetOldMessages()
    else
            MsgBox("You must choose a technician to view his old messages.")
    end if
  end sub  
  Private Sub LoadPartnerAgents()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSimpleDropDownList("spListActivePartnersAgentsWithCalls2", "Login", "PartnerAgentID", drpPartnerAgents)
        drpPartnerAgents.Items.Add("Choose One")
        drpPartnerAgents.SelectedValue = "Choose One"
    End Sub
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
        
      intTotalMessages = getTotalMessages(drpPartnerAgents.SelectedValue )
      if intTotalMessages > 0 then
         lblTotalMessages.Text = "Total Messages: " & intTotalMessages
         GetMessage(drpPartnerAgents.SelectedValue )
      else
       ClearForm()    
      end if
      
    End Sub
    
    Private Sub SelectIndexChange_PartnerAgents(ByVal sender As Object, ByVal e As System.EventArgs)
    
    If drpPartnerAgents.SelectedValue <> "Choose One" then
     lblTotalMessages.Text = "Total Messages: " & GetTotalMessages(drpPartnerAgents.SelectedValue)
     lblTotalMessages.Visible = "true"
    end if
    end sub
    Private Function GetTotalMessages (lngPartnerAgentID as Long) as Integer 
            Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            Dim cmd As New System.Data.SqlClient.SqlCommand("spGetTotalMessagesForPartnerAgent")
            cmd.CommandType = Data.CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentID", Data.SqlDbType.Int).Value = CType(drpPartnerAgents.SelectedValue, Long)
            cnn.Open()
            cmd.Connection = cnn
            Return cmd.ExecuteScalar 
            
            cnn.Close()
    
    end Function
    Private Sub btnSendMessage_Click (ByVal S As Object, ByVal E As EventArgs)
     If drpPartnerAgents.SelectedValue  <> "Choose One" then
     
        Dim msg as New BridgesInterface.PartnerAgentMessageRecord (System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        msg.Add(drpPartnerAgents.SelectedValue, Master.WebLoginID,datetime.Now(), txtArticleText.text)
        Clearform ()
     else
            MsgBox("You must choose a technician to send him a message.")
    end if
    end sub
    
    Private Sub GetMessage (lngPartnerAgentID as Long)  
            Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            Dim cmd As New System.Data.SqlClient.SqlCommand("spGetPartnerAgentMessageByPartnerAgentID")
            cmd.CommandType = Data.CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentID", Data.SqlDbType.Int).Value = CType(drpPartnerAgents.SelectedValue, Long)
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
      drpPartnerAgents.SelectedValue = "Choose One"
      txtArticletext.Text = ""
      lblTotalMessages.Text = "Total Messages: 0 "  
      lblCreatedDate.text = ""
      lblCreatedBy.text = ""
      getdelivered.Checked = False
      txtMessage.Text = ""
    end sub
    Private Sub GetOldMessages()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadTwoLongParameterDataGrid("spListOldPartnerAgentMessages", "@PartnerAgentID",drpPartnerAgents.SelectedValue ,"@UserID",Master.WebLoginID, dgvNotes)
    'For Each itm As DataGridItem In dgvNotes.Items
    '  If Not CType(itm.Cells(1).Text, Boolean) Then
     '   itm.CssClass = "selectedbandbar"
     ' End If
    'Next
    
    end sub
    Private Sub btnClose_Click (ByVal S As Object, ByVal E As EventArgs)
      Response.Redirect(lblReturnURL.text, True)
    
    end sub
    Private Sub MsgBox(ByVal strMessage As String)
        'Begin building the script 
        Dim strScript As String = "<SCRIPT LANGUAGE=""JavaScript"">" & vbCrLf
        strScript += "alert(""" & strMessage & """)" & vbCrLf
        strScript += "<" & "/" & "SCRIPT" & ">"
        'Register the script for the client side 
        ClientScript.RegisterStartupScript(GetType(String), "messageBox", strScript)
    End Sub
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
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmChangeSignature" runat="server">
    <table style="width: 600px;">
      <tbody>
        <tr>
          <td>
            <div id="divForm" style="margin-left: 4px; margin-right: 4px; margin-top: 4px; margin-bottom: 4px;" runat="server">
              <div class="errorzone" id="divError" runat="server" visible="false" />
              <div class="label">Choose Technician </div>
              <asp:DropDownList ID="drpPartnerAgents" runat="server"  OnSelectedIndexChanged ="SelectIndexChange_PartnerAgents" AutoPostBack ="true"/>&nbsp;&nbsp;&nbsp;<asp:Label ID="lblTotalMessages" runat ="server"></asp:Label> 
              <div style="text-align: right"><asp:LinkButton id="lnkNew" OnClick="btnlnkNew_Click" runat="server">[New]</asp:LinkButton>&nbsp;&nbsp;&nbsp;<asp:LinkButton id="LinkDeliver" OnClick="btnlnkDeliver_Click" runat="server">[Deliver]</asp:LinkButton>&nbsp;&nbsp;&nbsp;<asp:LinkButton id="LinkOld" OnClick="btnlnkOld_Click" runat="server">[Old]</asp:LinkButton></div>     
              <div>&nbsp;</div>
              <asp:MultiView ID="Multiview1" runat="server" ActiveViewIndex = "0" >
                <asp:View ID="vwNewNotes"  runat="server">
                   <div class="label">Message</div>
                   <asp:TextBox ID="txtArticleText" TextMode="MultiLine" runat="server" style="width: 99%; height: 100px;" />
                   <div style="text-align: right"><asp:Button ID="btnSendMessage"  Text="Send Message" runat="Server" OnClick ="btnSendMessage_Click" /></div>
            
                </asp:View>
                <asp:View ID="vwToBeDelivered"  runat="server">
                 <asp:Label ID="lblCreatedDate" runat ="server" Visible = "true"  /> &nbsp;&nbsp;<asp:Label ID="lblCreatedBy" runat ="server" /> <asp:Label ID="lblPartnerAgentMessageID" runat ="server" Visible="false" />
                 <asp:TextBox ID="txtMessage" TextMode="MultiLine" runat="server" style="width: 99%; height: 100px;" ReadOnly = "true" />
                   <div style="text-align: right"><asp:CheckBox ID="GetDelivered" runat="server"  Text="Delivered" OnCheckedChanged="MessageDelivered"  AutoPostBack="true"  /></div>
                
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