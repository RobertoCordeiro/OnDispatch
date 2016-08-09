<%@ Page Language="vb" MasterPageFile="~/masters/resumedialog.master" CodeFile="addphone.aspx.vb"
  Inherits="AddPhone" %>

<%@ MasterType VirtualPath="~/masters/resumedialog.master" %>
<%@ Register Src="~/controls/PhoneNumber.ascx" TagName="Phone" TagPrefix="cv" %>

<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmChangePass" runat="server">
    <div id="divForm" style="margin-left: 4px; margin-right: 4px; margin-top: 4px; margin-bottom: 4px;"
      runat="server">
      <div id="divError" runat="server" visible="false" class="errorzone" />
      <div>
        <cv:Phone Text="Phone Number" RequirePhone="true" ID="phn" runat="server" />
      </div>
      <div>
        &nbsp;</div>
      <div style="text-align: right">
        <asp:Button ID="btnCancel" Text="Cancel" OnClick="btnCancel_Click" runat="server" />&nbsp;<asp:Button
          ID="btnSubmit" runat="server" Text="Add" OnClick="btnSubmit_Click" /></div>
    </div>
    <div id="divResult" visible="false" runat="server">
      <div>
        &nbsp;</div>
      <div class="successtext">
        Success!</div>
    </div>
  </form>
  <asp:Label ID="lblReturnUrl" runat="server" Visible="false" />
</asp:Content>
