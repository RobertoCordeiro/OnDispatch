<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<%@ Register Src="~/controls/PhoneNumber.ascx" TagName="Phone" TagPrefix="cv" %>
<script runat="server">
    Private _ID As Long = 0
  
    Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
        If User.Identity.IsAuthenticated Then
            Master.WebLoginID = CType(User.Identity.Name, Long)
            Master.PageTitleText = "Payment"
        End If
        Try
            _ID = CType(Request.QueryString("id"), Long)
        Catch ex As Exception
            _ID = 0
        End Try
        'lblReturnUrl.Text = "regularrates.aspx"
    
    End Sub




</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmChangePass" runat="server">
     <input type="hidden" name="LinkId" value="a1d0d71d-e12b-49e4-b405-61753e3ca098" />
     <asp:ImageButton ID="ImageButPayNow" runat="server"  ImageUrl="/images/paybutton1.jpg" PostBackUrl="https://simplecheckout.authorize.net/payment/catalogpayment.aspx" />
        
    <asp:label ID="lblReturnUrl" runat="server" Visible="False" />
  </form>
</asp:Content>

