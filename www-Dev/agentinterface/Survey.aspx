<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<%@ Register Src="~/controls/RadioButtonList.ascx" TagName="Radio" TagPrefix="cv" %>
<%@ Register Src="~/controls/RadioButtonYN.ascx" TagName="RadioYN" TagPrefix="cv" %>
<script runat="server">  
  
    Dim _ID As Long = 0
    Dim _c As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)        
    If User.Identity.IsAuthenticated Then
            Dim wkr As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))

            Master.WebLoginID = CType(User.Identity.Name, Long)
      lblReturnUrl.Text = Request.QueryString("returnurl")      
            Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""" & Request.QueryString("returnurl") & """>Ticket</a> &gt; Survey"
      Try
        _ID = CType(Request.QueryString("id"), Long)
                wkr.Load(_ID)
                tkt.Load(wkr.TicketID)
                SurveyScript.InnerHtml = "<div>Our system indicates that a service on your [ " & tkt.Manufacturer & " ] has been completed by one of our technicians and we would like to find out how was that service experience for you.<br> Your opinion is really important for us. Would you mind answering few survey questions so we can rate our service and your Technician?</div>"
      Catch ex As Exception
        _ID = 0
            End Try
            
            Master.PageHeaderText = "<br>TicketID:" & wkr.TicketID & " - Visit: " & _ID & " - " & tkt.ContactFirstName & " " & tkt.ContactLastName & " - " & tkt.Manufacturer
            Master.PageTitleText = " Survey"
            
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
                lblReturnUrl.Text = "ticket.aspx?id=" & wkr.TicketID
            End If
        End If
  End Sub
  
  Private Sub LoadUnAnsweredQuestions(ByVal lngSurveyID As Long)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSingleLongParameterDataGrid("spGetSurveyQuestionsBySurveyID", "@SurveyID", lngSurveyID, dgvUnansweredQuestions)
    End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)    
    Response.Redirect(lblReturnUrl.Text, True)
  End Sub

    Private Sub btnSave_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim strErrors As String = ""
        If IsComplete() Then
            divErrors.Visible = False
            SaveAnswers()
            Response.Redirect(lblReturnUrl.Text, True)
        Else
            If chkRefuse.Checked Then
                If txtComments.Text <> "" Then
                    divErrors.Visible = False
                    SaveAnswers()
                    Response.Redirect(lblReturnUrl.Text, True)
                Else
                    divErrors.Visible = True
                    strErrors &= "<li>You need to explain why questions were not asnwered." & "</li>"
                    divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
                End If
            Else
                divErrors.Visible = True
            End If
            
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
                        sar.Add(CType(itm.Cells(2).Text, Long), CType(itm.Cells(0).Text, Long), _ID, 1, CType(ctl.SelectedValue, Long), Now(), Master.UserID)
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
                        sar.Add(CType(itm.Cells(2).Text, Long), CType(itm.Cells(0).Text, Long), _ID, 1, CType(ctl1.SelectedValue, Long), Now(), Master.UserID)
                        Exit For
                    End If
                End If
                
            Next
        Next
        Dim wkr As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        wkr.Load(_ID)

        tnt.Add(wkr.TicketID, Master.WebLoginID, Master.UserID, "Auto Note: A Survey has been performed on this ticket by " & Master.UserName & " for WorkOrderID: " & _ID)
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
        strErrors &= "<li>All questions must be asnwered. No questions should be left unanswered." & "</li>"
            divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
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
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <table>
      <tbody>
        <tr>
          <td>
            <div>&nbsp;</div>
            <div></div>
            <div id="SurveyScript" runat="server"></div>
            <div>&nbsp;</div>
            <div id="divErrors" class="errorzone" runat="server" visible="false" />
            <div class="bandheader">Survey Questions - Onsite Service Completed</div>
            <asp:DataGrid ID="dgvUnansweredQuestions" style="width: 100%" runat="server" AutoGenerateColumns="false">
              <AlternatingItemStyle CssClass="altrow" />
              <HeaderStyle CssClass="gridheader" />
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
    <div style="text-align: right"><asp:CheckBox ID="chkRefuse" runat="server" Text="EU Refuse to Answer"/>&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="btnCancel" runat="server" OnClick="btnCancel_Click" Text="Cancel" />&nbsp;<asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" Text="Save" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
    <div>&nbsp;</div>
    <div>Thanks very much for your time and the information you have provided us, we really appreciated.</div>
    <div>Have a Good Day!</div>
  </form>
</asp:Content>