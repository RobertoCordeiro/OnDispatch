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
      Master.WebLoginID = CType(User.Identity.Name, Long)
      lblReturnUrl.Text = Request.QueryString("returnurl")      
            Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""" & Request.QueryString("returnurl") & """>Ticket</a> &gt; Survey Answers"
      Try
        _ID = CType(Request.QueryString("id"), Long)
                wkr.Load(_ID)
      Catch ex As Exception
        _ID = 0
            End Try
            
            Master.PageHeaderText = " Survey For Ticket: " & wkr.TicketID & " - Visit: " & _ID
            Master.PageTitleText = " Survey Answers"
            
            Try
                _c = CType(Request.QueryString("c"), Long)
                
            Catch ex As Exception
                _c = 0
            End Try
            
            If Not IsPostBack Then
                    LoadAnsweredQuestions(_ID)
            Else
                    LoadAnsweredQuestions(_ID)
            End If
            If lblReturnUrl.Text.Trim.Length = 0 Then
                lblReturnUrl.Text = "ticket.aspx?id=" & wkr.TicketID
            End If
        End If
  End Sub
  
  
  Private Sub LoadAnsweredQuestions(ByVal lngWorkOrderID As Long)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSingleLongParameterDataGrid("spGetSurveyAnswerByWorkOrderID", "@WorkOrderID", lngWorkOrderID, dgvUnansweredQuestions)
    End Sub
   
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)    
    Response.Redirect(lblReturnUrl.Text, True)
  End Sub
    
    Private Sub dgvUnAnsweredQuestions_itemDateBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgvUnansweredQuestions.ItemDataBound
        Dim rowData As Data.DataRowView
        
        Select Case (e.Item.ItemType)
            Case ListItemType.AlternatingItem, ListItemType.EditItem, ListItemType.Item, ListItemType.SelectedItem
                
                Dim di As Data.DataRowView = e.Item.DataItem()
               
                rowData = CType(e.Item.DataItem, Data.DataRowView)
                    
                    e.Item.Cells(5).HorizontalAlign =HorizontalAlign.Center
                     
                    Select Case CType(rowData.Item("SurveyLayoutTypeID"), Long)
                       Case Is = 1
                           'plc.Controls.Add(LoadControl("~/controls/RadioButtonYN.ascx"))
                           If e.Item.Cells(5).Text.ToString  = "1" then
                             e.item.cells(5).text = "Yes"
                             
                           Else
                             e.Item.Cells(5).Text = "No"
                           end if
                       Case Is = 2
                           'plc.Controls.Add(LoadControl("~/controls/RadioButtonList.ascx"))
                    
                       Case Is = 3
                        
                       Case Is = 4
                        
                      Case Is = 5
                           'plc.Controls.Add(LoadControl("~/controls/RadioButtonYN.ascx"))
                             If e.Item.Cells(5).Text.ToString = "1" then
                             e.item.cells(5).text = "Yes"
                             
                             Dim san As New BridgesInterface.SurveyAnswerRecord (System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                             san.Load(Ctype(e.Item.Cells(0).text.ToString,Long))
                             
                             txtComments.Text = san.SurveyComment 
                             
                           Else
                             e.Item.Cells(5).Text = "No"
                           end if
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
            <div id="divErrors" class="errorzone" runat="server" visible="false" />
            <div class="bandheader">Survey Answers - Onsite Service Completed</div>
            <asp:DataGrid ID="dgvUnansweredQuestions" style="width: 100%" runat="server" AutoGenerateColumns="false" >
              <AlternatingItemStyle CssClass="altrow" />
              <HeaderStyle CssClass="gridheader" />
              <Columns>
                <asp:BoundColumn HeaderText="ID" DataField="SurveyAnswerID" Visible="false" />
                <asp:BoundColumn HeaderText="LayoutID" DataField="SurveyLayoutTypeID" Visible="false" />
                <asp:BoundColumn HeaderText="SurveyID" DataField="SurveyID" Visible="false" />
                <asp:BoundColumn HeaderText="Subject" DataField="QuestionType" />
                <asp:BoundColumn HeaderText="Survey Questions:" DataField="Description" />
                <asp:BoundColumn HeaderText="SurveyAnswer" DataField="SurveyAnswer" ItemStyle-HorizontalAlign="Center"/>
                <asp:BoundColumn HeaderText="SurveyQuestionID" DataField="SurveyQuestionID" Visible="false" />
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
    <div style="text-align: right"><asp:Button ID="btnCancel" runat="server" OnClick="btnCancel_Click" Text="Close" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
    
    
  </form>
</asp:Content>
