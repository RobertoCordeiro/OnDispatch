<%@ Page Language="vb" MasterPageFile="~/masters/resumedialog.master" CodeFile="edittimeslot.aspx.vb"
  Inherits="EditTimeSlot" %>

<%@ MasterType VirtualPath="~/masters/resumedialog.master" %>
<%@ Register Src="~/controls/PhoneNumber.ascx" TagName="Phone" TagPrefix="cv" %>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmChangePass" runat="server">
    <div class="label">
      <asp:Label ID="lblDay" runat="server" /></div>
    <div id="divForm" style="margin-left: 4px; margin-right: 4px; margin-top: 4px; margin-bottom: 4px;"
      runat="server">
      <div style="margin-left: auto; margin-right: auto;">
        <asp:DataGrid Style="width: 100%" ID="dgvTimeSlots" OnItemCommand="btnDeleteTimeSlot_Click"
          runat="server" AutoGenerateColumns="false">
          <HeaderStyle CssClass="gridheader" />
          <AlternatingItemStyle CssClass="altrow" />
          <Columns>
            <asp:BoundColumn DataField="ResumeTimeSlotID" HeaderText="ID" Visible="False" />
            <asp:TemplateColumn HeaderText="Start">
              <ItemTemplate>
                <%#ctype(DataBinder.Eval(Container.DataItem, "StartHour"),Integer).ToString("00")%>
                :<%#ctype(DataBinder.Eval(Container.DataItem, "StartMinute"),Integer).ToString("00")%>
              </ItemTemplate>
            </asp:TemplateColumn>
            <asp:TemplateColumn HeaderText="End">
              <ItemTemplate>
                <%#CType(DataBinder.Eval(Container.DataItem, "EndHour"), Integer).ToString("00")%>
                :<%#CType(DataBinder.Eval(Container.DataItem, "EndMinute"), Integer).ToString("00")%>
              </ItemTemplate>
            </asp:TemplateColumn>
            <asp:ButtonColumn HeaderText="Command" Text="Delete" ButtonType="LinkButton" />
          </Columns>
        </asp:DataGrid>
        <div id="divError" runat="server" visible="false" class="errorzone" />
        <div class="label">
          Add Time Slot</div>
        <div>
          <asp:DropDownList ID="cbxStartHour" runat="server" />:<asp:DropDownList ID="cbxStartMinute"
            runat="server" />
          to
          <asp:DropDownList ID="cbxEndHour" runat="Server" />:<asp:DropDownList ID="cbxEndMinute"
            runat="server" /><asp:Button ID="btnAdd" runat="server" Text="Add" OnClick="btnAdd_Click" /></div>
        <div>
          &nbsp;</div>
        <div style="text-align: right">
          <asp:Button ID="btnSubmit" runat="server" Text="Done" OnClick="btnSubmit_Click" /></div>
      </div>
    </div>
    <div id="divResult" visible="false" runat="server">
      <div>
        &nbsp;</div>
      <div class="successtext">
        Success!</div>
    </div>
    <asp:Label ID="lblReturnUrl" runat="server" Visible="False" />
  </form>
</asp:Content>
