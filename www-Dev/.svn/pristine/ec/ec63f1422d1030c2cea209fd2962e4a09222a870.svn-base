<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
  
  Private _ID As Long = 1
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Certification Control"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Certification Control"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; Certification Control"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 1
    End Try
    If _ID = 0 Then
      _ID = 1
    End If
    LoadAgencies()
    LoadCertifications()
  End Sub
  
  Private Sub LoadAgencies()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDataGrid("spListCertificateAgencies", dgvAgencies)
    For Each itm As DataGridItem In dgvAgencies.Items
      If CType(itm.Cells(0).Text, Long) = _ID Then
        itm.CssClass = "selectedbandbar"
      Else
        itm.CssClass = "bandbar"
      End If
    Next
  End Sub
  
  Private Sub LoadCertifications()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListCertificationsForAgency", "@AgencyID", _ID, dgvCertifications)
  End Sub

  Private Sub btnAddCert_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      divErrors.Visible = False
      Dim crt As New BridgesInterface.CertificationRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      crt.Add(_ID, Master.UserID, txtCertification.Text)
      Response.Redirect("certifications.aspx?id=" & _ID, True)
    Else
      divErrors.Visible = True
    End If
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If txtCertification.Text.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>You Must Supply a Certification Name</li>"
    End If
    divErrors.innerhtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmCerts" runat="server">
    <table style="width: 100%">
      <tbody>
        <tr>
          <td style="width: 1%" class="band">
            <div class="bandheader">Certifying&nbsp;Agencies</div>
            <asp:DataGrid style="width: 100%" ShowHeader="false" AutoGenerateColumns="false" ID="dgvAgencies" runat="server">
              <Columns>
                <asp:BoundColumn HeaderText="ID" Visible="false" DataField="AgencyID" />
                <asp:templatecolumn HeaderText="Agency">
                  <ItemTemplate>
                    <a href="certifications.aspx?id=<%# Databinder.Eval(Container.DataItem,"AgencyID") %>"><%#DataBinder.Eval(Container.DataItem, "AgencyName")%></a>
                  </ItemTemplate>
                </asp:templatecolumn>
              </Columns>
            </asp:DataGrid>
            <div style="text-align: right;"><a href="addcertifyingagency.aspx?returnurl=certifications.aspx">[Add&nbsp;Agency]</a></div>
          </td>
          <td>
            <div class="bandheader">Available Certifications</div>
            <asp:DataGrid ID="dgvCertifications" style="width: 100%" runat="server" AutoGenerateColumns="false">
              <AlternatingItemStyle CssClass="altrow" />
              <HeaderStyle CssClass="gridheader" />
              <Columns>
                <asp:BoundColumn DataField="CertificationID" HeaderText="ID" Visible="false" />
                <asp:TemplateColumn>
                  <Itemtemplate>
                    <a href="editcertification.aspx?id=<%# Databinder.eval(Container.DataItem,"CertificationID") %>&returnurl=certifications.aspx%3fid=<%# Databinder.eval(Container.DataItem,"AgencyID") %>">Edit</a>                    
                  </Itemtemplate>
                </asp:TemplateColumn>
                <asp:BoundColumn DataField="CertificationName" Headertext="Certification" />
                <asp:templatecolumn>
                  <ItemTemplate>
                    <a href="mailto:<%# Databinder.Eval(Container.DataItem,"Email") %>"><%#DataBinder.Eval(Container.DataItem, "Author")%></a>
                  </ItemTemplate>
                </asp:templatecolumn>
                <asp:BoundColumn DataField="DateCreated" HeaderText="Date Created" />
              </Columns>
            </asp:DataGrid>
            <div>&nbsp;</div>
            <div class="inputform">
              <div class="inputformsectionheader">Certification Quick Add</div>
              <div id="divErrors" class="errorzone" visible="false" runat="server" />
              <div class="label">Certification Name</div>
              <div style="padding-left: 3px; padding-right: 8px;"><asp:TextBox ID="txtCertification" style="width: 100%" runat="server" /></div>
              <div style="text-align: right"><asp:Button ID="btnAddCert" runat="server" Text="Add" OnClick="btnAddCert_Click" /></div>
            </div>
          </td>          
        </tr>
      </tbody> 
    </table>
  </form>
</asp:Content>