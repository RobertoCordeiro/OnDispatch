<%@ Page Language="vb" masterpagefile="~/masters/partnerdialog.master" %>
<%@ MasterType VirtualPath="~/masters/partnerdialog.master" %>
<%@ Register Src="~/controls/Address.ascx" TagName="Address" TagPrefix="cv" %>
<script runat="server">
  
  Private _Mode As String = ""
  Private _ReturnUrl As String = ""
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Edit Address"
      Master.PageTitleText = "Edit Address"
    End If
    lblReturnUrl.Text = Request.QueryString("returnurl")
    _Mode = Request.QueryString("mode")
    _ReturnUrl = Request.QueryString("returnurl")
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    If Not IsNothing(_Mode) Then
      Select Case _Mode.Trim.ToLower
        Case "resume"
          If Not IsPostBack Then
            LoadResumeAddress()
          End If
        Case "partner"
          If Not IsPostBack Then
            LoadPartnerAddress()
          End If
      End Select
    Else
      divForm.Visible = False
    End If
  End Sub
  
  Private Sub LoadResumeAddress()
    Dim rad As New BridgesInterface.ResumeAddressRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    rad.Load(_ID)
    addAddress.AddressTypeID = rad.AddressTypeID
    addAddress.Street = rad.Street
    addAddress.Extended = rad.Extended
    addAddress.City = rad.City
    addAddress.StateID = rad.StateID
    addAddress.Zip = rad.ZipCode
    chkActive.Checked = rad.Active
  End Sub
  
  Private Sub LoadPartnerAddress()
    Dim pad As New BridgesInterface.PartnerAddressRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    pad.Load(_ID)
    addAddress.AddressTypeID = pad.AddressTypeID
    addAddress.Street = pad.Street
    addAddress.Extended = pad.Extended
    addAddress.City = pad.City
    addAddress.StateID = pad.StateID
    addAddress.Zip = pad.ZipCode
    chkActive.Checked = pad.Active
    Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    par.Load(Master.PartnerAgentID)
    If par.AdminAgent Then
      divAgents.Visible = True
      Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      ldr.LoadSingleLongParameterDataGrid("spListPartnerAgentsAssignedToAddress", "@PartnerAddressID", _ID, dgvAgents)
    Else
      divAgents.Visible = False
    End If
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
  Private Sub btnSubmit_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsAddressComplete() Then
      divError.Visible = False
      Select Case _Mode.Trim.ToLower
        Case "resume"
          SaveResumeAddress()
        Case "partner"
          SavePartnerAddress()
      End Select
      Response.Redirect(_ReturnUrl)
    Else
      divError.Visible = True
    End If
  End Sub
  
  Private Sub SaveResumeAddress()
    Dim rad As New BridgesInterface.ResumeAddressRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strChangeLog As String = ""
    rad.Load(_ID)
    rad.Street = addAddress.Street
    rad.Extended = addAddress.Extended
    rad.City = addAddress.City
    rad.StateID = addAddress.StateID
    rad.ZipCode = addAddress.Zip
    rad.AddressTypeID = addAddress.AddressTypeID
    rad.Active = chkActive.Checked
    rad.Save(strChangeLog)
    Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    act.Add(Master.UserID, "web", "web", "web", "web", 24, rad.ResumeAddressID, strChangeLog)
  End Sub
  
  Private Sub SavePartnerAddress()
    Dim pad As New BridgesInterface.PartnerAddressRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strChangeLog As String = ""
    pad.Load(_ID)
    pad.Street = addAddress.Street
    pad.Extended = addAddress.Extended
    pad.City = addAddress.City
    pad.StateID = addAddress.StateID
    pad.ZipCode = addAddress.Zip
    pad.AddressTypeID = addAddress.AddressTypeID
    pad.Active = chkActive.Checked
    pad.Save(strChangeLog)
    Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strIp As String = Request.QueryString("REMOTE_ADDR")
    Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
    If IsNothing(strIp) Then
      strIp = "unknown"
    End If
    If IsNothing(strType) Then
      strType = "web"
    End If
    act.Add(Master.UserID, "web", strType, strIp, Master.WebLoginID.ToString, 39, _ID, strChangeLog)    
  End Sub
  
  Private Function IsAddressComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim zip As New BridgesInterface.ZipCodeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strErrors As String = ""
    If addAddress.AddressTypeID <= 0 Then
      blnReturn = False
      strErrors &= "<li>Address Type is Required</li>"
    End If
    If addAddress.Street.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Street is Required</li>"
    End If
    If addAddress.City.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>City is Required</li>"
    End If
    If addAddress.StateID <= 0 Then
      blnReturn = False
      strErrors &= "<li>State is Required</li>"
    End If
    If addAddress.Zip.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Zip Code is Required</li>"
    Else
      zip.Load(addAddress.Zip.Trim)
      If zip.ZipCodeID <= 0 Then
        blnReturn = False
        strErrors &= "<li>Zip Code is Invalid</li>"
      End If
    End If
    divError.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div id="divForm" style="margin-left: 4px; margin-right: 4px; margin-top: 4px; margin-bottom: 4px;" runat="server">
      <div id="divError" runat="server" visible="false" class="errorzone" />
      <div><cv:Address ID="addAddress" runat="server" RequireAddressType="true" RequireCity="true" RequireState="true" RequireZip="true" RequireStreet="true" /></div>
      <asp:CheckBox ID="chkActive" runat="server" Text="Active" />
      <div id="divAgents" runat="server" visible="false">
        <div class="bandheader">Agents Assigned to This Address</div>
          <asp:DataGrid style="width: 100%" ID="dgvAgents" AutoGenerateColumns="false" runat="server">
            <HeaderStyle cssclass="gridheader" />
            <AlternatingItemStyle cssclass="altrow" />  
            <Columns>
              <asp:BoundColumn
                HeaderText="ID"
                DataField="PartnerAgentID"
                Visible="false"
              />
              <asp:TemplateColumn
                HeaderText="Command"
                >
                <ItemTemplate>
                  <a href="editpartneragent.aspx?id=<%# DataBinder.Eval(Container.DataItem,"PartnerAgentID") %>">Open</a>
                </ItemTemplate>
              </asp:TemplateColumn>
              <asp:BoundColumn
                HeaderText="Type"
                DataField="AgentType"
                />
              <asp:TemplateColumn
                HeaderText="Name"
                >
                <Itemtemplate>
                  <%# DataBinder.Eval(Container.DataItem,"FirstName") %>&nbsp;<%# DataBinder.Eval(Container.DataItem,"MiddleName") %>&nbsp;<%#DataBinder.Eval(Container.DataItem, "LastName")%>                    
                </Itemtemplate>                  
              </asp:TemplateColumn>
              <asp:TemplateColumn 
                HeaderText="Admin"
                >             
                <ItemTemplate>
                  <img alt="Admin Agent" src="/graphics/<%# Databinder.eval(Container.DataItem, "AdminAgent") %>.png" />                 
                </ItemTemplate>
              </asp:TemplateColumn>
              <asp:TemplateColumn 
                HeaderText="Active"
                >             
                <ItemTemplate>
                  <img alt="Active" src="/graphics/<%# Databinder.eval(Container.DataItem, "Active") %>.png" />                 
                </ItemTemplate>
              </asp:TemplateColumn>
              <asp:BoundColumn
                DataField="DateCreated"
                HeaderText="Date&nbsp;Created"
                />                
            </Columns>
          </asp:DataGrid>
        </div>
      <div>&nbsp;</div>
      <div style="text-align: right"><asp:Button ID="btnCancel" Text="Cancel" OnClick="btnCancel_Click" runat="server" />&nbsp;<asp:Button ID="btnSubmit" runat="server" Text="Update" OnClick="btnSubmit_Click"/></div>
    </div>
    <div id="divResult" visible="false" runat="server">
      <div>&nbsp;</div>
      <div class="successtext">Success!</div>
    </div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>