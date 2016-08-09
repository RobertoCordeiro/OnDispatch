<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<%@ Import Namespace="LGInterface" %>

<script runat="server">

    
Private Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)

        If User.Identity.IsAuthenticated Then
            Master.WebLoginID = CType(User.Identity.Name, Long)
            Master.PageHeaderText = " LG Services"
            Master.PageTitleText = " LG Services"
            '  Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""customers.aspx"">Customers</a> &gt; Add Ticket"
        End If
        If Not IsPostBack Then Exit Sub
        
        Dim objLG As New LG(Master.UserID)
        objLG.getNewDispatchList(Master.UserID, Master.WebLoginID)
        End Sub
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
    <form id="frmMain" runat="server">
 <div>
                <asp:Button ID="btnRun" runat="server" Text="Download Tickets" />

  </div>
</form>
</asp:Content>
