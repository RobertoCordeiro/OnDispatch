<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<%@ Register Src="~/controls/PhoneNumber.ascx" TagName="Phone" TagPrefix="cv" %>
<script runat="server">
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageTitleText = "Add Rate"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    'lblReturnUrl.Text = "regularrates.aspx"
    
  End Sub
  
    
  Private Sub btnSubmit_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      SaveReferenceRate()
      'Response.Redirect(lblReturnUrl.Text, True)
      Dim str as String = "<script language=javascript>window.top.close()"
           
      str = str & ";</"
      str = str & "script>"
      
      if (not page.ClientScript.IsStartupScriptRegistered ("ClientScript")) then
        Page.ClientScript.RegisterStartupScript (GetType(Page),"ClientScript",str)
      end if
    Else
      divError.Visible = True
    End If
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    'Response.Redirect(lblReturnUrl.Text, True)
    'Response.Close()
    Dim str as String = "<script language=javascript>window.top.close()"
           
      str = str & ";</"
      str = str & "script>"
      
      if (not page.ClientScript.IsStartupScriptRegistered ("ClientScript")) then
        Page.ClientScript.RegisterStartupScript (GetType(Page),"ClientScript",str)
      end if
    
    
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    Dim dbl As Double = 0
    If txtserviceType.Text.ToString.Length = 0 Then
      strErrors = "<li>You must give a service name</li>"
    End If
    If Not Double.TryParse(txtFlatRate.Text, dbl) Then
      strErrors = "<li>Rate must be Numeric</li>"
    End If
    strErrors = "<ul>" & strErrors & "</ul>"
    divError.InnerHtml = strErrors
    Return blnReturn
  End Function
      
  Private Sub SaveReferenceRate()
    Dim rrt As New BridgesInterface.RateTypeRecord (System.Configuration.ConfigurationManager.AppSettings("DBCnn"))    
    Dim strChangeLog As String = ""
    rrt.Load(_ID)
    rrt.Add( Master.UserID,txtServiceType.Text,True,txtFlatRate.Text ,False,_ID)
    'rrt.Rate = CType(txtRate.Text, Double)
    rrt.Save(strChangeLog)
    
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmChangePass" runat="server">
    <div id="divForm" style="margin-left: 4px; margin-right: 4px; margin-top: 4px; margin-bottom: 4px;" runat="server">
      <div >
        <div id="divError" runat="server" visible="false" class="errorzone" />
        <div class="inputformsectionheader">Add Service Type and Rate</div>
        <div class="addservicetype">
        <div >Service Name
         <div><asp:TextBox ID="txtServiceType" runat="server"  Width="100%"/></div>
        </div>
        <div >Rate
         <div ><asp:TextBox ID="txtFlatRate" runat="server"   /></div>
        </div>
        </div>
        <div>&nbsp;</div>
        <div style="text-align: right"><asp:Button ID="btnCancel" Text="Cancel" OnClick="btnCancel_Click" runat="server" />&nbsp;<asp:Button ID="btnSubmit" runat="server" Text="Add" OnClick="btnSubmit_Click"/></div>
      </div>
    </div>
    <div id="divResult" visible="false" runat="server">
      <div>&nbsp;</div>
      <div class="successtext">Success!</div>
    </div>
    <asp:label ID="lblReturnUrl" runat="server" Visible="False" />
  </form>
</asp:Content>