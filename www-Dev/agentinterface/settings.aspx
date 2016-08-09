<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
    
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Settings"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Settings"
      Master.PageSubHeader = "<a href=""/agentinterface"">My Desktop</a> &gt; Settings"
    End If

  End Sub
       
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmSettings" runat="server">
    <div class="label">My Settings</div>
    <ul>
      <li><a href="changepassword.aspx">Change Password</a></li>
      <li><a href="changesignature.aspx">Change/Set Signature</a></li>
    </ul>
    <div class="label">General</div>
    <ul>
      <li><a href="editdocument.aspx?id=5&returnurl=settings.aspx">Edit Changed Password Email</a></li>      
    </ul>
    <ul>
      <li>Partners Default Rates and Labor Networks
        <ul>
         <li><a href="regularrates.aspx?id=9&returnurl=settings.aspx">Default Partner Reference Rates</a></li>
        </ul>
      </li>
    </ul>
    <ul>
      <li>End Users
        <ul>
         <li><a href="editdocument.aspx?id=9&returnurl=settings.aspx">Welcome Letter to EU</a></li>
         <li><a href="editdocument.aspx?id=10&returnurl=settings.aspx">Survey Email to EU</a></li>
        </ul>
      </li>
    </ul>
    <div style="font-weight: bold;"><a href="recruit.aspx">Recruiting</a></div>
    <ul>
      <li>Folders
        <ul>
         <li><a href="addresumefolder.aspx">Add Personal Folder</a></li>
        </ul>
      </li>
    </ul>
    <ul>    
      <li>Standard Emails
        <ul>
          
          <li><a href="editdocument.aspx?id=1&returnurl=settings.aspx">Edit Phase 2 Email</a></li>
          <li><a href="editdocument.aspx?id=6&returnurl=settings.aspx">Edit Documents Ready Email</a></li>
          <li><a href="editdocument.aspx?id=7&returnurl=settings.aspx">Edit New Partner Email</a></li>
        </ul>
      </li>
      <li>Documents
        <ul>
          <li><a href="editdocument.aspx?id=8&returnurl=settings.aspx">Edit Digital Signature Authorization</a></li>
          <li><a href="editdocument.aspx?id=2&returnurl=settings.aspx">Edit Workman's Comp Waiver</a></li>
          <li><a href="editdocument.aspx?id=3&returnurl=settings.aspx">Edit Confidentiality Agreement</a></li>
          <li><a href="editdocument.aspx?id=4&returnurl=settings.aspx">Edit Independent Contractor Agreement</a></li>
        </ul>
      </li>
    </ul>
    <asp:Label ID="lblMode" runat="Server" Visible="false" />
  </form>
</asp:Content>