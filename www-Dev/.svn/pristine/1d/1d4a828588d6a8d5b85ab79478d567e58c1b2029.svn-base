<%@ Page Language="vb" masterpagefile="~/masters/partner.master" %>
<%@ MasterType VirtualPath="~/masters/partner.master" %>
<script runat="server">
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Vendor Interface"
      Master.PageTitleText = " Vendor Interface"
      Master.ActiveMenu = "A"
    End If
    LoadArticles()
    'LoadTasks()
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
  
  Private Sub LoadArticles()
    If GetTotalMessages(Master.PartnerAgentID) > 0 then
       Response.Redirect("MessagesToTech.aspx?returnurl=default.aspx", True)
    else
      Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSimpleDataGrid("spListPartnerNewsArticles", dgvNews)
        If dgvNews.Items.Count = 0 Then
           divNoNews.Visible = True
        End If
    End if
  End Sub
  
  Private Sub LoadTasks()
    Dim lngTaskCount As Long = 0
    Dim lngUnansweredSkillSetQuestionCount As Long = 0
    Dim pdr As New BridgesInterface.PartnerDocumentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strTaskList As String = ""
    Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    par.Load(Master.PartnerAgentID)
    Dim ptr As New BridgesInterface.PartnerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))    
    lngUnansweredSkillSetQuestionCount = par.UnAnsweredSkillSetQuestionCount
    If lngUnansweredSkillSetQuestionCount > 0 Then
      lngTaskCount += 1
      strTaskList &= "<li><a href=""skillsetsurvey.aspx?returnurl=default.aspx"">" & lngUnansweredSkillSetQuestionCount & " Question(s) need to be answered on your Skill Set Survey</a></li>"
    End If
    If par.CertificationCount = 0 Then
      lngTaskCount += 1
      strTaskList &= "<li><a href=""certificationsurvey.aspx?returnurl=default.aspx"">No certifications on record, please register your certifications with us.</a></li>"
    End If
    If par.AdminAgent Then
      ptr.Load(Master.PartnerID)
      If ptr.Email.Trim.Length = 0 Then
        lngTaskCount += 1
        strTaskList &= "<li><a href=""settings.aspx"">An email address is required for new work order notification.</a></li>"
      End If
      pdr.Load(Master.PartnerID, 1)
      If pdr.PartnerDocumentID = 0 Then
        lngTaskCount += 1
        strTaskList &= "<li><a href=""documents.aspx"">A scanned copy of your W9 is required</a></li>"
      End If
      pdr.Load(Master.PartnerID, 2)
      If pdr.PartnerDocumentID = 0 Then
        lngTaskCount += 1
        strTaskList &= "<li><a href=""documents.aspx"">A scanned copy of your proof of insurance is required</a></li>"
      End If
    End If
    If lngTaskCount = 0 Then
      divTasks.InnerHtml = "<div style=""text-align: center"">No Task Currently Available</div>"
    Else
      divTasks.InnerHtml = "<ol>" & strTaskList & "</ol>"
    End If
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
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form runat="server" id="frmDefault">
    <div class="bandheader">News</div>
    <asp:DataGrid ShowHeader="false" style="width: 100%" ID="dgvNews" runat="server" AutoGenerateColumns="false" >
      <AlternatingItemStyle CssClass="altrow" /> 
      <Columns>
        <asp:TemplateColumn>
          <ItemTemplate>
            <div class="label"><%#DataBinder.Eval(Container.DataItem, "ArticleSubject")%></div>
            <div style="font-size: 6pt"><%#DataBinder.Eval(Container.DataItem, "DateCreated")%>&nbsp;<a href="mailto:<%# Databinder.eval(Container.DataItem, "email") %>"><%# Databinder.eval(Container.DataItem, "FirstName") %>&nbsp;<%# Databinder.eval(Container.DataItem, "LastName") %></a></div>
            <div><%#DataBinder.Eval(Container.DataItem, "ArticleText")%></div>            
            <div>&nbsp;</div>
          </ItemTemplate>
        </asp:TemplateColumn>  
      </Columns>
    </asp:DataGrid>
    <div id="divNoNews" runat="server" visible="false" style="text-align: center;">No News Currently Available</div>
    <div>&nbsp;</div>
    <div class="bandheader"></div>
    <div id="divTasks" runat="server" />
  </form>
</asp:Content>