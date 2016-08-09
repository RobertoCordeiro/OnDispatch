<%@ Page Language="VB" masterpagefile="~/masters/euTicket.master" ValidateRequest="false"%>
<%@ MasterType VirtualPath="~/masters/euTicket.master" %>
<%@ Import Namespace="BridgesInterface.UserRecord" %>
<%@ Register Src="~/controls/RadioButtonList.ascx" TagName="Radio" TagPrefix="cv" %>
<%@ Register Src="~/controls/RadioButtonYN.ascx" TagName="RadioYN" TagPrefix="cv" %>
<script runat="server">  
  
    Dim _ID As Long = 0
    Dim _c As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)        
    
        Dim strRef As String = Request.QueryString("ReturnUrl")
        Dim strDefaultText As String = ""
        'TrackTraffic()
        
        If Not IsNothing(strRef) Then
            Try
                Select Case strRef.Split("/")(1).ToLower
                    Case "partners"
                        'lblWelcome.Text = ""
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
        
        
        Dim wkr As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))

        lblReturnUrl.Text = Request.QueryString("returnurl")
        Try
            _ID = CType(Request.QueryString("id"), Long)
            wkr.Load(_ID)
            tkt.Load(wkr.TicketID)
            SurveyScript.InnerHtml = "<div>Our system indicates that a service on your [ " & tkt.Manufacturer & " ] has been completed by one of our technicians and we would like to find out how was that service experience for you.<br> Your opinion is really important for us. Would you mind answering few survey questions so we can rate our service and your Technician?</div>"
        Catch ex As Exception
            _ID = 0
        End Try
            
          
        Try
            _c = CType(Request.QueryString("c"), Long)
                
        Catch ex As Exception
            _c = 0
        End Try
            
        If Not IsPostBack Then
            LoadUnAnsweredQuestions(2)
               
        Else
            LoadUnAnsweredQuestions(2)
        End If
        If lblReturnUrl.Text.Trim.Length = 0 Then
            lblReturnUrl.Text = "/eu/ticket.aspx?id=" & wkr.TicketID
        End If
       
  End Sub
  
    'Private Sub TrackTraffic()
    '    Exit Sub
    '    Dim tm As New cvTrafficMaster.TransactionRecord(System.Configuration.ConfigurationManager.AppSettings("TMCnn"))
    '    tm.Add(Request.ServerVariables("SCRIPT_NAME"))
    '    If Not IsNothing(Request.ServerVariables("HTTP_REFERER")) Then
    '        tm.Referrer = Request.ServerVariables("HTTP_REFERER")
    '    End If
    '    If Not IsNothing(Request.ServerVariables("HTTP_USER_AGENT")) Then
    '        tm.UserAgent = Request.ServerVariables("HTTP_USER_AGENT")
    '    End If
    '    If Not IsNothing(Request.ServerVariables("REMOTE_ADDR")) Then
    '        tm.RemoteAddress = Request.ServerVariables("REMOTE_ADDR")
    '    End If
    '    If Not IsNothing(Request.ServerVariables("QUERY_STRING")) Then
    '        tm.QueryString = Request.ServerVariables("QUERY_STRING")
    '    End If
    '    If Not IsNothing(Request.ServerVariables("SERVER_NAME")) Then
    '        tm.ServerName = Request.ServerVariables("SERVER_NAME")
    '    End If
    '    Dim strChangelog As String = ""
    '    tm.Save(strChangelog)
    '    Dim tf As New cvTrafficMaster.FlagRecord(System.Configuration.ConfigurationManager.AppSettings("TMCnn"))
    '    tf.LoadByRemoteHost(tm.RemoteAddress)
    '    If tf.FlagID > 0 Then
    '        Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    '        eml.SendFrom = "services@bestservicers.com"
    '        eml.SendTo = "services@bestservicers.com"
    '        eml.Subject = "Possible Login Security Breach!"
    '        eml.Body = "<p>A user at a flagged IP Address tried to access the system, this is a possible security breach!</p>"
    '        eml.Body &= "<div>Details</div>"
    '        'eml.Body &= "Login:" & txtEmailAddress.Text & "<br />"
    '        eml.Send()
    '    End If
    'End Sub
    
    
  Private Sub LoadUnAnsweredQuestions(ByVal lngSurveyID As Long)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSingleLongParameterDataGrid("spGetSurveyQuestionsBySurveyID", "@SurveyID", lngSurveyID, dgvUnansweredQuestions)
    End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)    
    Response.Redirect(lblReturnUrl.Text, True)
  End Sub

  Private Sub btnSave_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
            'divErrors.Visible = False
            SaveAnswers()
            Response.Redirect(lblReturnUrl.Text, True)
    Else
            'divErrors.Visible = True
    End If
  End Sub
  
  Private Sub SaveAnswers()
        Dim strMessage As Boolean = False
        Dim strChangeLog As String = ""
        
        Dim sar As New BridgesInterface.SurveyAnswerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        For Each itm As DataGridItem In dgvUnansweredQuestions.Items
            Dim d As PlaceHolder = itm.FindControl("ItemPlaceHolder")
            Dim i As Integer = 0
            Dim ctl As controls_radiobuttonyn_ascx
            Dim ctl1 As controls_radiobuttonlist_ascx
            For i = 0 To d.Controls.Count - 1
                If TypeOf d.Controls(i) Is controls_radiobuttonyn_ascx Then
                    ctl = d.Controls(i)
                    If ctl.SelectedValue <> "" Then
                        sar.Add(CType(itm.Cells(2).Text, Long), CType(itm.Cells(0).Text, Long), _ID, 1, CType(ctl.SelectedValue, Long), Now(), 2)
                        If CType(itm.Cells(0).Text.ToString, Long) = CType(7, Long) Then 'survey question ID comments
                            If txtComments.Text <> "" Then
                                sar.SurveyComment = txtComments.Text
                                sar.Save(strChangeLog)
                            End If
                        End If
                        Exit For
                        
                    End If
                End If
                If TypeOf d.Controls(i) Is controls_radiobuttonlist_ascx Then
                    ctl1 = d.Controls(i)
                    If ctl1.SelectedValue <> "" Then
                        sar.Add(CType(itm.Cells(2).Text, Long), CType(itm.Cells(0).Text, Long), _ID, 1, CType(ctl1.SelectedValue, Long), Now(), 2)
                        Exit For
                    End If
                End If
                
            Next
        Next
        Dim wkr As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        wkr.Load(_ID)

        tnt.Add(wkr.TicketID, 2, 1, "Auto Note: A Survey has been performed on this ticket by end user online for WorkOrderID: " & _ID)
        tnt.CustomerVisible = False
        tnt.PartnerVisible = False
        tnt.Acknowledged = True
        tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
        tnt.Save(strChangeLog)
        
    End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    Dim lng As Long = 0
        Dim dgItem As DataGridItem
        
        For Each dgItem In dgvUnansweredQuestions.Items
            Dim d As PlaceHolder = dgItem.FindControl("ItemPlaceHolder")
            Dim i As Integer = 0
            Dim ctl As controls_radiobuttonyn_ascx
            Dim ctl1 As controls_radiobuttonlist_ascx
            For i = 0 To d.Controls.Count - 1
                If TypeOf d.Controls(i) Is controls_radiobuttonyn_ascx Then
                    ctl = d.Controls(i)
                    If ctl.SelectedValue = "" Then
                        blnReturn = False
                        Exit For
                    End If
                End If
                If TypeOf d.Controls(i) Is controls_radiobuttonlist_ascx Then
                    ctl1 = d.Controls(i)
                    If ctl1.SelectedValue = "" Then
                        blnReturn = False
                        Exit For
                    End If
                End If
                
            Next
        Next
            strErrors &= "<li>All questions must be asnwered. No questins should be left unanswered." & "</li>"
        'divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
            Return blnReturn
    End Function
    
    Private Sub dgvUnAnsweredQuestions_itemDateBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgvUnansweredQuestions.ItemDataBound
        Dim rowData As Data.DataRowView
        
        Select Case (e.Item.ItemType)
            Case ListItemType.AlternatingItem, ListItemType.EditItem, ListItemType.Item, ListItemType.SelectedItem
                Dim plc As PlaceHolder = DirectCast(e.Item.FindControl("itemPlaceHolder"), PlaceHolder)
                Dim di As Data.DataRowView = e.Item.DataItem()
               
                rowData = CType(e.Item.DataItem, Data.DataRowView)
                                
                    Select Case CType(rowData.Item("SurveyLayoutTypeID"), Long)
                       Case Is = 1
                           plc.Controls.Add(LoadControl("~/controls/RadioButtonYN.ascx"))
                        
                       Case Is = 2
                           plc.Controls.Add(LoadControl("~/controls/RadioButtonList.ascx"))
                    
                       Case Is = 3
                        
                       Case Is = 4
                        
                      Case Is = 5
                           plc.Controls.Add(LoadControl("~/controls/RadioButtonYN.ascx"))
                       
                   End Select
        End Select
    End Sub
  
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="bodycontent" runat="server">
  <form id="frmDialog" runat="server">
    <table>
      <tbody>
        <tr>
          <td>
            <div>&nbsp;</div>
            <div></div>
            <div id="SurveyScript" runat="server"></div>
            <div>&nbsp;</div>
            <div class="bandheader">Survey Questions - Onsite Service Completed</div>
            <asp:DataGrid ID="dgvUnansweredQuestions" style="width: 100%" runat="server" AutoGenerateColumns="false">
              <AlternatingItemStyle CssClass="altrow" />
              <HeaderStyle CssClass="ticketformsectionheader" />
              <Columns>
                <asp:BoundColumn HeaderText="ID" DataField="SurveyQuestionID" Visible="false" />
                <asp:BoundColumn HeaderText="LayoutID" DataField="SurveyLayoutTypeID" Visible="false" />
                <asp:BoundColumn HeaderText="SurveyID" DataField="SurveyID" Visible="false" />
                <asp:BoundColumn HeaderText="Subject" DataField="QuestionType" />
                <asp:BoundColumn HeaderText="Survey Questions:" DataField="Description" />
                <asp:TemplateColumn HeaderText="Rating&nbsp;Levels">
                  <ItemTemplate>
                    <asp:PlaceHolder  runat ="server" ID="ItemPlaceHolder" />
                  </ItemTemplate>
                </asp:TemplateColumn>
              </Columns>
            </asp:DataGrid>
          </td>
          <td></td>
        </tr>
      </tbody>
    </table>
    <div>&nbsp;</div>
    <div>Comments:</div>
    <asp:TextBox ID="txtComments" runat="server" TextMode="MultiLine" style="width: 100%" Height="75px" Wrap="true"  />
    <div>&nbsp;</div>
    <div style="text-align: right"><asp:Button ID="btnCancel" runat="server" OnClick="btnCancel_Click" Text="Cancel" visible="false" />&nbsp;<asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" Text="Save" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
    <div>&nbsp;</div>
    <div>Thanks very much for your time and the information you have provided us, we really appreciated.</div>
    <div>Have a Good Day!</div>
  </form>
</asp:Content>
