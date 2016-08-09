<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<%@ Import Namespace="System.IO"%>

<script runat="server"> 
  
  Private _ID As string = "0"
  
  Private Sub Page_Load(sender as Object, e as EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Documentation for Model Number: " & Request.QueryString("id")
      Master.PageTitleText = " Documentation for Model Number: " & Request.QueryString("id")
    End If
    Try
      _ID = Request.QueryString("id")
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If _ID <> "0" Then
      
      Dim dirInfo as New DirectoryInfo (Server.MapPath("../Manuals/" & PurgeString(_ID) & "/"))
      
      dgvManuals.DataSource = dirInfo.GetFiles("*.*")
      dgvManuals.DataBind()
      
    Else
      Response.Redirect(lblReturnUrl.Text, True)
      
    End If
  End Sub
 
    Private Function FormatURL(ByVal strValue As String) As String
        Dim URL As String
        URL = "../Manuals/" & PurgeString(_ID) & "/"
  
        Return URL

    End Function

Private Function PurgeString (OldStr as String) as String

OldStr = OldStr.Replace ("/","")
OldStr = OldStr.Replace ("\","")
PurgeString = OldStr
End Function  
  
  
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div>&nbsp;</div>
    <div>&nbsp;</div>
    <asp:DataGrid style="width: 100%" ID="dgvManuals" AutoGenerateColumns="false"  runat="server">
      <HeaderStyle cssclass="gridheader" />
      <AlternatingItemStyle cssclass="altrow" />  
      <Columns>
          <asp:TemplateColumn HeaderText="File Name" >
           <ItemTemplate>
              <a  href="<%# FormatURL(DataBinder.Eval(Container.DataItem,"Name"))%><%# DataBinder.Eval(Container.DataItem,"Name") %>" target="_blank"><%# DataBinder.Eval(Container.DataItem,"Name") %></a>
           </ItemTemplate>
         </asp:TemplateColumn>
         <asp:BoundColumn DataField="LastWriteTime" HeaderText="Last Write Time" ItemStyle-HorizontalAlign="Center" DataFormatString="{0:d}" />
         <asp:BoundColumn DataField="Length" HeaderText="File Size" ItemStyle-HorizontalAlign ="Right" DataFormatString="{0:#,### bytes}" />

      </Columns>
    </asp:DataGrid>
    <div>&nbsp;</div>
    <div><a href="http://www.celartem.com/en/download/djvu.asp" target="_blank" >Djvu Viewer: Free download</a></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>