<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server"> 
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Add Program"
      Master.PageTitleText = " Add Program"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If _ID > 0 Then
      Dim cus As New BridgesInterface.CustomerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim com As New BridgesInterface.CompanyInfoRecord (System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      cus.Load(_ID)
      com.Load (cus.InfoID )
      
      If com.CustomerID = _ID then
         Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""mycompany.aspx?id=" & cus.InfoID & """>My Company</a>"
         lblReturnUrl.Text = "mycompany.aspx?id=" & _ID & "&infoID=" & cus.InfoID
      else
         Master.PageSubHeader &= "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""customer.aspx?id=" & _ID & """>Customer</a></a>"
         lblReturnUrl.Text = "customer.aspx?id=" & _ID
      end if
    Else
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub
    
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If txtServiceType.Text.Trim.Length = 0 Then
      strErrors &= "<li>Service Type is Required</li>"
      blnReturn = False
    End If
    divErrors.innerhtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function

  Private Sub btnOk_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      divErrors.Visible = False
      Dim strChangeLog As String = ""
      Dim stp As New BridgesInterface.ServiceTypeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      stp.Add(Master.UserID, _ID, txtServiceType.Text)
      stp.Notes = txtNotes.Text
      stp.Save(strChangeLog)
      Response.Redirect(lblReturnUrl.Text, True)
    Else
      divErrors.Visible = True
    End If
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div class="errorzone" id="divErrors" runat="server" visible="false" />
    <div class="label">Program Name</div>
    <asp:TextBox ID="txtServiceType" runat="server" style="width: 99%" />
    <div class="label">Program Instructions</div>
    <asp:TextBox ID="txtNotes" runat="server" TextMode="MultiLine" style="width: 99%; Height: 300px" />
    <div>&nbsp;</div>
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnOk" OnClick="btnOK_Click" Text="Submit" runat="server" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>