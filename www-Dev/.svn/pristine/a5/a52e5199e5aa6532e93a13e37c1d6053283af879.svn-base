<%@ Page Language="vb" MasterPageFile="~/masters/resume.master" CodeFile="viewfaq.aspx.vb"
  Inherits="ViewFaq" %>

<%@ MasterType VirtualPath="~/masters/resume.master" %>

<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmFaq" runat="server">
    <div class="resumeform">
      <div class="bandheader">
        Questions</div>
      <asp:DataGrid ID="dgvQuestions" ItemStyle-BorderStyle="None" AlternatingItemStyle-BorderStyle="none"
        GridLines="none" AutoGenerateColumns="false" ShowHeader="false" BorderStyle="None"
        Style="width: 100%" runat="server">
        <AlternatingItemStyle CssClass="altrow" />
        <Columns>
          <asp:TemplateColumn>
            <ItemTemplate>
              <a href="#<%# databinder.eval(Container.DataItem,"FaqQuestionID") %>">
                <%# databinder.eval(Container.DataItem,"Question") %>
              </a>
            </ItemTemplate>
          </asp:TemplateColumn>
        </Columns>
      </asp:DataGrid>
      <div class="bandheader">
        Answers</div>
      <asp:DataGrid ID="dgvAnswers" GridLines="horizontal" AutoGenerateColumns="false"
        ShowHeader="false" BorderStyle="None" Style="width: 100%" runat="server">
        <AlternatingItemStyle CssClass="altrow" />
        <Columns>
          <asp:TemplateColumn>
            <ItemTemplate>
              <a name="<%# databinder.eval(Container.DataItem,"FaqQuestionID") %>" />
              <div class="label">
                Q:&nbsp;<%# databinder.eval(Container.DataItem,"Question") %></div>
              <div>
                &nbsp;</div>
              <div>
                <span class="label">A:&nbsp;</span><%#DataBinder.Eval(Container.DataItem, "Answer")%></div>
              <div>
                &nbsp;</div>
            </ItemTemplate>
          </asp:TemplateColumn>
        </Columns>
      </asp:DataGrid>
    </div>
    <asp:Label ID="lblReturnUrl" runat="server" />
  </form>
</asp:Content>
