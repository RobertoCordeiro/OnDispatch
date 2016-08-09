<%@ Page Language="vb" masterpagefile="~/masters/partnerdialog.master" %>
<%@ MasterType VirtualPath="~/masters/partnerdialog.master" %>
<%@ PreviousPageType VirtualPath="~/partners/TrainingVideos.aspx" %>
<script runat="server"> 
    Private _Url As String = ""
    Public swfFileName As String = ""
    Private Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
        If User.Identity.IsAuthenticated Then
            Master.WebLoginID = CType(User.Identity.Name, Long)
            Master.PageHeaderText = "Training Video"
            Master.PageTitleText = "BSA Learning Center"
            Try
                _Url = CType(Request.QueryString("Url"), String)
            Catch ex As Exception
                _Url = ""
            End Try
            swfFileName = _Url
        Else
            Response.Redirect("/login.aspx", True)
        End If
    End Sub
</script>

<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div style ="text-align:center;" ><b><%=PreviousPage._somedata%></b>
     <p style=" padding-right:30px;">
          <object classid="clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B" width="600" height="498" codebase="http://www.apple.com/qtactivex/qtplugin.cab">
           <param name="src" value="<% =swfFileName%>" />
           <param name="autoplay" value="false" />
           <param name="controller" value="true" />
           <embed src="<% =swfFileName%>" autoplay="false" controller="true" width="600" height="498" pluginspage="http://www.apple.com/quicktime/download/"></embed>
          </object>
        </p>
    </div>
    <div>&nbsp;</div>
  </form>
</asp:Content>