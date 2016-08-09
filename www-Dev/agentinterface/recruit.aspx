<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
  
  Private _FolderID As Long = 0
    Private _mnu As Long = 0
    Private _CountryID As Long = 0
    Private _user As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Dim usr As New BridgesInterface.UserRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim cpy As New BridgesInterface.CompanyInfoRecord (System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      usr.Load(Master.userID)
      cpy.Load(usr.InfoID)
      _CountryID = cpy.CountryID
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Recruitment"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Recruitment"
      Master.PageSubHeader = "<a href=""/agentinterface"">My Desktop</a> &gt; Recruitment"
    End If
    
        
        Try
            _mnu = CType(Request.QueryString("mnu"), Long)
        Catch ex As Exception
            _mnu = 0
        End Try
        
        Try
            _FolderID = CType(Request.QueryString("folder"), Long)
        Catch ex As Exception
            _FolderID = 0
        End Try
        Try
            _user = CType(Request.QueryString("user"), Long)
        Catch ex As Exception
            _user = 0
        End Try
        
        If Not IsPostBack Then
            LoadCSRs()
            LoadAppliedFor()
            LoadStates(_CountryID)
            LoadRegion()
            lnkRefresh.HRef = Request.ServerVariables("SCRIPT_NAME") & "?" & Request.ServerVariables("QUERY_STRING")
            divFolders.InnerHtml = BuildFolders(_FolderID)
            'dgvResumes.PagerStyle.PageButtonCount = 100
            lnkExportFolder.HRef = "resumesinfolderxls.aspx?folder=" & _FolderID
           
            
            LoadData(_FolderID, lblOrderBy.Text, lblDirection.Text)
            LoadLookIn()
            LoadCampaigns()
        
                
            menu.Items(_mnu).Selected = True
            Multiview1.ActiveViewIndex = _mnu
        Else
            'menu.Items(_mnu).Selected = True
            'Multiview1.ActiveViewIndex = _mnu
            If drpCSR.SelectedValue <> "CSR All" Then
                _user = CType(drpCSR.SelectedValue, Long)
            Else
                _user = 0
            End If
            lnkRefresh.HRef = Request.ServerVariables("SCRIPT_NAME") & "?" & Request.ServerVariables("QUERY_STRING")
            divFolders.InnerHtml = BuildFolders(_FolderID)
            'dgvResumes.PagerStyle.PageButtonCount = 100
            lnkExportFolder.HRef = "resumesinfolderxls.aspx?folder=" & _FolderID
            If txtZipCode.Text.Trim.Length > 0 Then
                If txtRadius.Text.Trim.Length > 0 Then
                    _FolderID = -1
                    If drpAppliedFor.SelectedValue <> "Filter By Labor Network" Then
                        
                        FilterData(_FolderID, lblOrderBy.Text, lblDirection.Text)
                    End If
                Else
                    LoadData(_FolderID, lblOrderBy.Text, lblDirection.Text)
                End If
            Else
                LoadData(_FolderID, lblOrderBy.Text, lblDirection.Text)

            End If
        End If
    End Sub
  
  Private Sub LoadLookIn()
    With cbxLookIn.Items
      .Clear()
      .Add(cboxitem("Resume ID", "resumeid"))
      .Add(cboxitem("Referrer", "referrer"))
      .Add(cboxitem("Company Name", "companyname"))
      .Add(cboxitem("Name", "name"))
      .Add(cboxitem("Email", "email"))
      .Add(cboxitem("WebSite", "website"))
      .Add(cboxitem("IP Address", "ipaddress"))
      .Add(cboxitem("Resume Text", "resume"))
      .Add(cboxitem("Misc", "misc"))
      .Add(cboxitem("Zip Code", "zipcode"))
      .Add(cboxitem("City", "city"))
      .Add(cboxitem("State", "state"))
      .Add(cboxitem("Phone Number", "phone"))
    End With
  End Sub
  
  Private Sub LoadCampaigns()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDropDownList("spListRecruitmentCampaigns", "Description", "RecruitmentCampaignID", cbxCampaigns)
  End Sub
 
  Private Function cboxitem(ByVal strText As String, ByVal strValue As String) As ListItem
    Dim itmReturn As New ListItem
    itmReturn.Text = strText
    itmReturn.Value = strValue
    Return itmReturn
  End Function
  
    Private Sub btnClosestCandidates_Click(ByVal S As Object, ByVal E As EventArgs)
        If txtZipCode.Text.Trim.Length > 0 Then
            If txtRadius.Text.Trim.Length > 0 Then
                'Response.Redirect("resumesearch.aspx?lookin=" & cbxLookIn.SelectedValue & "&criteria=" & Server.UrlEncode(txtResumeSearch.Text.Trim), True)
                lblDirection.Text = "asc"
                lblOrderBy.Text = "Distance"
                LoadDataByDistance(-1, lblOrderBy.Text, lblDirection.Text, txtZipCode.Text, txtRadius.Text)
            Else
                divResumeSearchError.InnerHtml = "A distance in Radius is required. Ex: 50"
                divResumeSearchError.Visible = True
            End If
        Else
            divResumeSearchError.InnerHtml = "A Valid Zip Code is required"
            divResumeSearchError.Visible = True
        End If
        
        
        
    End Sub
    
    Private Sub btnQuickSearch_Click(ByVal S As Object, ByVal E As EventArgs)
        If txtResumeSearch.Text.Trim.Length > 0 Then
            Response.Redirect("resumesearch.aspx?lookin=" & cbxLookIn.SelectedValue & "&criteria=" & Server.UrlEncode(txtResumeSearch.Text.Trim), True)
        Else
            divResumeSearchError.InnerHtml = "Resume ID is required"
            divResumeSearchError.Visible = True
        End If
    End Sub
    
    Protected Sub dgvResumes_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs)
        If lblDirection.Text.ToLower = " asc" Then
            lblDirection.Text = " desc"
        Else
            lblDirection.Text = " asc"
        End If
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        If _FolderID >= 0 Then
            If drpCSR.SelectedValue <> "CSR All" Then
                If drpAppliedFor.SelectedValue <> "Filter By Labor Network" Then
                    If drpRegion.SelectedValue <> "Filter By Region" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter by User Labor Region State
                            ldr.LoadSixLongParameterDataGrid("spGetResumesInFolderByResumeTypeStateRegionUser", "@FolderID", _FolderID, "@ResumeTypeID", CType(drpAppliedFor.SelectedValue, Long), "@StateID", CType(drpState.SelectedValue, Long), "@RegionID", CType(drpRegion.SelectedValue, Long), "@CountryID", _CountryID, "@UserID", CType(drpCSR.SelectedValue, Long), dgvResumes, True, e, e.SortExpression, lblDirection.Text)
                        Else
                            'Filter by User Labor Region
                            ldr.LoadFiveLongParameterDataGrid("spGetResumesInFolderByResumeTypeRegionUser", "@FolderID", _FolderID, "@ResumeTypeID", CType(drpAppliedFor.SelectedValue, Long), "@RegionID", CType(drpRegion.SelectedValue, Long), "@CountryID", _CountryID, "@UserID", CType(drpCSR.SelectedValue, Long), dgvResumes, True, e, e.SortExpression, lblDirection.Text)
                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter User Labor State
                            ldr.LoadFiveLongParameterDataGrid("spGetResumesInFolderByResumeTypeStateUser", "@FolderID", _FolderID, "@ResumeTypeID", CType(drpAppliedFor.SelectedValue, Long), "@StateID", CType(drpState.SelectedValue, Long), "@CountryID", _CountryID, "@UserID", CType(drpCSR.SelectedValue, Long), dgvResumes, True, e, e.SortExpression, lblDirection.Text)
                        Else
                            'Filter by user Labor
                            ldr.LoadFourLongParameterDataGrid("spGetResumesInFolderByResumeTypeUser", "@FolderID", _FolderID, "@ResumeTypeID", CType(drpAppliedFor.SelectedValue, Long), "@UserID", CType(drpCSR.SelectedValue, Long), "@CountryID", _CountryID, dgvResumes, True, e, e.SortExpression, lblDirection.Text)
                        End If
                    End If
                Else
                    If drpState.SelectedValue <> "Filter By State" Then
                        If drpRegion.SelectedValue <> "Filter By Region" Then
                            'Filter by User State Region
                            ldr.LoadFiveLongParameterDataGrid("spGetResumesInFolderByStateRegionUser", "@FolderID", _FolderID, "@StateID", CType(drpState.SelectedValue, Long), "@RegionID", CType(drpRegion.SelectedValue, Long), "@CountryID", _CountryID, "@UserID", CType(drpCSR.SelectedValue, Long), dgvResumes, True, e, e.SortExpression, lblDirection.Text)
                        Else
                            'Filter By User State
                            ldr.LoadFourLongParameterDataGrid("spGetResumesInFolderByStateUser", "@FolderID", _FolderID, "@StateID", CType(drpState.SelectedValue, Long), "@UserID", CType(drpCSR.SelectedValue, Long), "@CountryID", _CountryID, dgvResumes, True, e, e.SortExpression, lblDirection.Text)
                        End If
                    Else
                        If drpRegion.SelectedValue <> "Filter By Region" Then
                            'Filter by User Region
                            ldr.LoadFourLongParameterDataGrid("spGetResumesInFolderByUserRegion", "@FolderID", _FolderID, "@UserID", CType(drpCSR.SelectedValue, Long), "@RegionID", CType(drpRegion.SelectedValue, Long), "@CountryID", _CountryID, dgvResumes, True, e, e.SortExpression, lblDirection.Text)
                        Else
                            'Filter by User
                            ldr.LoadThreeLongParameterDataGrid("spGetResumesInFolderByUser", "@FolderID", _FolderID, "@UserID", CType(drpCSR.SelectedValue, Long), "@CountryID", _CountryID, dgvResumes, True, e, e.SortExpression, lblDirection.Text)
                        End If
                    End If
                End If
            Else
                If drpAppliedFor.SelectedValue <> "Filter By Labor Network" Then
                    If drpState.SelectedValue <> "Filter By State" Then
                        If drpRegion.SelectedValue <> "Filter By Region" Then
                            'Filter by labor state Region
                            ldr.LoadFiveLongParameterDataGrid("spGetResumesInFolderByResumeTypeStateRegion", "@FolderID", _FolderID, "@ResumeTypeID", CType(drpAppliedFor.SelectedValue, Long), "@StateID", CType(drpState.SelectedValue, Long), "@RegionID", CType(drpRegion.SelectedValue, Long), "@CountryID", _CountryID, dgvResumes, True, e, e.SortExpression, lblDirection.Text)
                        Else
                            'Filter labor state
                            ldr.LoadFourLongParameterDataGrid("spGetResumesInFolderByResumeTypeState", "@FolderID", _FolderID, "@ResumeTypeID", CType(drpAppliedFor.SelectedValue, Long), "@StateID", CType(drpState.SelectedValue, Long), "@CountryID", _CountryID, dgvResumes, True, e, e.SortExpression, lblDirection.Text)
                        End If
                    Else
                        If drpRegion.SelectedValue <> "Filter By Region" Then
                            'filter by labor region
                            ldr.LoadFourLongParameterDataGrid("spGetResumesInFolderByResumeTypeRegion", "@FolderID", _FolderID, "@ResumeTypeID", CType(drpAppliedFor.SelectedValue, Long), "@RegionID", CType(drpRegion.SelectedValue, Long), "@CountryID", _CountryID, dgvResumes, True, e, e.SortExpression, lblDirection.Text)
                        Else
                            'Filter by labor
                            ldr.LoadThreeLongParameterDataGrid("spGetResumesInFolderByResumeType", "@FolderID", _FolderID, "@ResumeTypeID", CType(drpAppliedFor.SelectedValue, Long), "@CountryID", _CountryID, dgvResumes, True, e, e.SortExpression, lblDirection.Text)
                        End If
                    End If
                Else
                    If drpState.SelectedValue <> "Filter By State" Then
                        If drpRegion.SelectedValue <> "Filter By Region" Then
                            'Filter by state Region
                            ldr.LoadFourLongParameterDataGrid("spGetResumesInFolderByStateRegion", "@FolderID", _FolderID, "@StateID", CType(drpState.SelectedValue, Long), "@RegionID", CType(drpRegion.SelectedValue, Long), "@CountryID", _CountryID, dgvResumes, True, e, e.SortExpression, lblDirection.Text)
                        Else
                            'Filter by State
                            ldr.LoadThreeLongParameterDataGrid("spGetResumesInFolderByState", "@FolderID", _FolderID, "@StateID", CType(drpAppliedFor.SelectedValue, Long), "@CountryID", _CountryID, dgvResumes, True, e, e.SortExpression, lblDirection.Text)
                        End If
                    Else
                        If drpRegion.SelectedValue <> "Filter By Region" Then
                            'Filter by Region
                            ldr.LoadThreeLongParameterDataGrid("spGetResumesInFolderByRegion", "@FolderID", _FolderID, "@RegionID", CType(drpRegion.SelectedValue, Long), "@CountryID", _CountryID, dgvResumes, True, e, e.SortExpression, lblDirection.Text)
                        Else
                            'No filter
                            ldr.LoadTwoLongParameterDataGrid("spGetResumesInFolder", "@FolderID", _FolderID, "@CountryID", _CountryID, dgvResumes, True, e, e.SortExpression, lblDirection.Text)
                        End If
                    End If
                End If
       
            End If
        End If
    End Sub
  
    Private Sub LoadDataByDistance(ByVal lngFolderID As Long, ByVal strCol As String, ByVal strSortOrder As String, ByVal strZipCode As String, ByVal lngRadius As Long)

        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim da As New System.Data.SqlClient.SqlDataAdapter
        Dim ds As New System.Data.DataSet
        cnn.Open()
        
        If lngFolderID = -1 Then
            
            'strCol = "Distance"
            'lblOrderBy.Text = "Distance"
            'strSortOrder = "asc"
            'lblDirection.Text = "asc"
            Dim strlenth As String
            strlenth = lblOrderBy.Text.Trim.Length
            dgvResumes.Columns(0).Visible = True
            Dim cmd As New System.Data.SqlClient.SqlCommand("spGetResumesClosestToZipCodeByRadius")
            cmd.CommandType = Data.CommandType.StoredProcedure
            cmd.Parameters.Add("@SortColumn", Data.SqlDbType.VarChar, Len(strCol)).Value = strCol
            cmd.Parameters.Add("@SortOrder", Data.SqlDbType.VarChar, Len(strSortOrder)).Value = strSortOrder
            cmd.Parameters.Add("@ZipCode", Data.SqlDbType.VarChar, 16).Value = strZipCode
            cmd.Parameters.Add("@Radius", Data.SqlDbType.Int).Value = lngRadius
            cmd.Parameters.Add("@CountryID", Data.SqlDbType.Int).Value = _CountryID
            cmd.Connection = cnn
            da.SelectCommand = cmd
            da.Fill(ds)
            dgvResumes.DataSource = ds
            dgvResumes.DataBind()
            lblTicketCount.Text = " [ " & CType(dgvResumes.DataSource, Data.DataSet).Tables(0).Rows.Count & " ] "

        End If
            
        cnn.Close()
    End Sub
    
    
    Private Sub LoadData(ByVal lngFolderID As Long, ByVal strCol As String, ByVal strSortOrder As String)

        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim da As New System.Data.SqlClient.SqlDataAdapter
        Dim ds As New System.Data.DataSet
        cnn.Open()
        'If lblPageNumber.Text = "" Then
        'lblPageNumber.Text = 0
        'End If
        
        'dgvResumes.CurrentPageIndex = lblPageNumber.text
        If lngFolderID = 0 Then
            If strCol = "" Then
                strCol = "tblResumes.DateCreated"
                lblOrderBy.Text = "tblResumes.DateCreated"
                strSortOrder = "desc"
                lblDirection.Text = "desc"
            End If
            If _user <> 0 Then
                Dim cmd As New System.Data.SqlClient.SqlCommand("spGetUnassignedResumesByUser")
                cmd.CommandType = Data.CommandType.StoredProcedure
                cmd.Parameters.Add("@SortColumn", Data.SqlDbType.VarChar, Len(strCol)).Value = strCol
                cmd.Parameters.Add("@SortOrder", Data.SqlDbType.VarChar, Len(strSortOrder)).Value = strSortOrder
                cmd.Parameters.Add("@CountryID", Data.SqlDbType.Int).Value = _CountryID
                cmd.Parameters.Add("@UserID", Data.SqlDbType.Int).Value = _user
                cmd.Connection = cnn
                da.SelectCommand = cmd
                da.Fill(ds)
                dgvResumes.DataSource = ds
                dgvResumes.DataBind()
            Else
                Dim cmd As New System.Data.SqlClient.SqlCommand("spGetUnassignedResumes")
                cmd.CommandType = Data.CommandType.StoredProcedure
                cmd.Parameters.Add("@SortColumn", Data.SqlDbType.VarChar, Len(strCol)).Value = strCol
                cmd.Parameters.Add("@SortOrder", Data.SqlDbType.VarChar, Len(strSortOrder)).Value = strSortOrder
                cmd.Parameters.Add("@CountryID", Data.SqlDbType.Int).Value = _CountryID
                cmd.Connection = cnn
                da.SelectCommand = cmd
                da.Fill(ds)
                dgvResumes.DataSource = ds
                dgvResumes.DataBind()
            End If
        Else
           
            FilterData(lngFolderID, strCol, strSortOrder)
        
        End If
        cnn.Close()
    End Sub

  Private Sub dgvResumes_Paged(ByVal S As Object, ByVal E As DataGridPageChangedEventArgs)
        'lblPageNumber.Text = (E.NewPageIndex).ToString
        'lblPageNumber.Text = lblPageNumber.Text + 1
        'LoadData(_FolderID, lblOrderBy.Text, lblDirection.Text)
        'Response.Redirect("recruit.aspx?folder=" & _FolderID.ToString & "&orderby=" & lblOrderBy.Text & "&sortorder=" & lblDirection.Text & "&page=" & (E.NewPageIndex + 1).ToString, True)
  End Sub
  
  Private Function BuildFolders(ByVal lngCurrentFolder As Long) As String
    Dim fld As New BridgesInterface.ResumeFolderRecord(0, System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strReturn As String = ""
    strReturn &= "<div class=""bandheader"">System Folders</div>"
    strReturn &= "<div "
        If lngCurrentFolder = 0 Then
            'strReturn &= "class=""bandbar"">"
            strReturn &= "class=""selectedbandbar"">"
            strReturn &= "<img src=""/graphics/openfolder.png"" alt=""Root"" />"
        Else
            
            If lngCurrentFolder = _FolderID Then
                'strReturn &= "class=""selectedbandbar"">"
                strReturn &= "class=""bandbar"">"
            Else
                strReturn &= "class=""bandbar"">"
            End If
            
            strReturn &= "<img src=""/graphics/folder.png"" alt=""Root"" />"
        End If
        If _user <> 0 Then
            strReturn &= "<a href=""" & Request.ServerVariables("SCRIPT_NAME") & "?folder=0&user=" & _user & """>Resume Inbox</a>&nbsp;("
            strReturn &= GetTotalResumesByUser(1, _user)
        Else
            strReturn &= "<a href=""" & Request.ServerVariables("SCRIPT_NAME") & "?folder=0"">Resume Inbox</a>&nbsp;("
            strReturn &= fld.ItemCount.ToString
        End If
        
    strReturn &= ")</div>"
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListSystemResumeFolders")
    cmd.CommandType = Data.CommandType.StoredProcedure
    Dim dtr As System.Data.SqlClient.SqlDataReader
    cnn.Open()
    cmd.Connection = cnn
    dtr = cmd.ExecuteReader
    LoadFoldersFromReader(dtr, strReturn, fld, lngCurrentFolder)
    strReturn &= "<div class=""bandheader"">Personal Folders</div>"
    cnn.Close()
    cnn.Open()
    cmd = New System.Data.SqlClient.SqlCommand("spListPersonalResumeFolders")
    cmd.CommandType = Data.CommandType.StoredProcedure
    cmd.Parameters.Add("CreatedBy", Data.SqlDbType.Int).Value = Master.UserID
    cmd.Connection = cnn
    Dim dtrPersonal As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
    LoadFoldersFromReader(dtrPersonal, strReturn, fld, lngCurrentFolder)
    cnn.Close()

    Return strReturn
  End Function

    Private Sub LoadFoldersFromReader(ByRef dtr As System.Data.SqlClient.SqlDataReader, ByRef strReturn As String, ByRef fld As BridgesInterface.ResumeFolderRecord, ByVal lngCurrentFolder As Long)
        Dim lngCount As Long
        lngCount = 0
        While dtr.Read
            
            strReturn &= "<div "
           
            If lngCurrentFolder = CType(dtr("FolderID"), Long) Then
                If lngCount < 8 Then
                    'strReturn &= "class=""bandbar"">&nbsp;&nbsp;&nbsp;"
                    strReturn &= "class=""selectedbandbar"">&nbsp;&nbsp;&nbsp;"
                Else
                    'strReturn &= "class=""bandbar"">"
                    strReturn &= "class=""selectedbandbar"">&nbsp;&nbsp;&nbsp;"
                End If
                
                strReturn &= "<img src=""/graphics/openfolder.png"" alt=""" & dtr("FolderName").ToString & """ />"
            Else
                If lngCount < 8 Then
                   
                    strReturn &= "class=""bandbar"">&nbsp;&nbsp;&nbsp;"
                    'strReturn &= "class=""selectedbandbar"">&nbsp;&nbsp;&nbsp;"
                Else
                    strReturn &= "class=""bandbar"">"
                End If
                
                strReturn &= "<img src=""/graphics/folder.png"" alt=""" & dtr("FolderName").ToString & """ />"
            End If
            If _user <> 0 Then
                strReturn &= "<a href=""" & Request.ServerVariables("SCRIPT_NAME") & "?folder=" & dtr("FolderID").ToString & "&user=" & _user & """>" & dtr("FolderName").ToString & "</a>&nbsp;("
            Else
                strReturn &= "<a href=""" & Request.ServerVariables("SCRIPT_NAME") & "?folder=" & dtr("FolderID").ToString & """>" & dtr("FolderName").ToString & "</a>&nbsp;("
            End If
            
            fld = New BridgesInterface.ResumeFolderRecord(CType(dtr("FolderID"), Long), System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            fld.Load(CType(dtr("FolderID"), Long))
            'strReturn &= fld.ItemCount.ToString
            If _user <> 0 Then
                strReturn &= GetTotalResumesInFolderByUser(CType(dtr("FolderID"), Long), 1, _user)
            Else
                strReturn &= GetTotalResumesInFolder(CType(dtr("FolderID"), Long), 1)
            End If
            
            strReturn &= ")</div>"
            lngCount = lngCount + 1
        End While

    End Sub
  
  Private Function CurrentFolder() As Long
        Return _FolderID
  End Function
  
  Private Function CurrentPage() As Long
        'Return lblPageNumber.text
  End Function
  
  Private Function SortOrder() As String
        Return lblDirection.Text
  End Function
  
  Private Function OrderBy() As String
        Return lblOrderBy.Text
  End Function

  Private Sub btnGoToCampaign_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect("recruitmentcampaign.aspx?id=" & cbxCampaigns.SelectedValue, True)    
  End Sub
  Private Sub btnGo_Click(ByVal S As Object, ByVal E As EventArgs)
        'LoadDataByResumeTypeID(CType(Request.QueryString("folder"), Long),Ctype(drpAppliedFor.SelectedValue,long) )  
  End Sub

    Private Sub LoadDataByResumeTypeID(ByVal lngFolderID As Long, ByVal lngResumeTypeID As Long, ByVal strCol As String, ByVal strSortOrder As String)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim da As New System.Data.SqlClient.SqlDataAdapter
        Dim ds As New System.Data.DataSet
        cnn.Open()
        'dgvResumes.CurrentPageIndex = lblPageNumber.text
     
        If lngFolderID > 0 Then
            Dim cmd As New System.Data.SqlClient.SqlCommand("spGetResumesInFolderByResumeType")
            cmd.CommandType = Data.CommandType.StoredProcedure
            cmd.Parameters.Add("@SortColumn", Data.SqlDbType.VarChar, Len(strCol)).Value = strCol
            cmd.Parameters.Add("@SortOrder", Data.SqlDbType.VarChar, Len(strSortOrder)).Value = strSortOrder
            cmd.Parameters.Add("@FolderID", Data.SqlDbType.Int).Value = lngFolderID
            cmd.Parameters.Add("@ResumeTypeID", Data.SqlDbType.Int).Value = lngResumeTypeID
            cmd.Parameters.Add("@CountryID", Data.SqlDbType.Int).Value = _CountryID
            cmd.Connection = cnn
            da.SelectCommand = cmd
            da.Fill(ds)
            dgvResumes.DataSource = ds
            dgvResumes.DataBind()
        Else
            If lngFolderID = 0 Then
                Dim cmd As New System.Data.SqlClient.SqlCommand("spGetResumesByResumeTypeID")
                cmd.CommandType = Data.CommandType.StoredProcedure
                cmd.Parameters.Add("@SortColumn", Data.SqlDbType.VarChar, Len(strCol)).Value = strCol
                cmd.Parameters.Add("@SortOrder", Data.SqlDbType.VarChar, Len(strSortOrder)).Value = strSortOrder
                cmd.Parameters.Add("@ResumeTypeID", Data.SqlDbType.Int).Value = lngResumeTypeID
                cmd.Parameters.Add("@CountryID", Data.SqlDbType.Int).Value = _CountryID
                cmd.Connection = cnn
                da.SelectCommand = cmd
                da.Fill(ds)
                dgvResumes.DataSource = ds
                dgvResumes.DataBind()
            Else
                Dim cmd As New System.Data.SqlClient.SqlCommand("spGetResumesByResumeTypeIDRadius")
                cmd.CommandType = Data.CommandType.StoredProcedure
                cmd.Parameters.Add("@SortColumn", Data.SqlDbType.VarChar, Len(strCol)).Value = strCol
                cmd.Parameters.Add("@SortOrder", Data.SqlDbType.VarChar, Len(strSortOrder)).Value = strSortOrder
                cmd.Parameters.Add("@ResumeTypeID", Data.SqlDbType.Int).Value = lngResumeTypeID
                cmd.Parameters.Add("@ZipCode", Data.SqlDbType.VarChar, 16).Value = txtZipCode.Text
                cmd.Parameters.Add("@Radius", Data.SqlDbType.Int).Value = CType(txtRadius.Text, Long)
                cmd.Parameters.Add("@CountryID", Data.SqlDbType.Int).Value = _CountryID
                cmd.Connection = cnn
                da.SelectCommand = cmd
                da.Fill(ds)
                dgvResumes.DataSource = ds
                dgvResumes.DataBind()
            End If
        End If
          
        cnn.Close()
    End Sub
    
    Private Sub LoadNoFilter(ByVal lngFolderID As Long, ByVal strCol As String, ByVal strSortOrder As String)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim da As New System.Data.SqlClient.SqlDataAdapter
        Dim ds As New System.Data.DataSet
        cnn.Open()
        'dgvResumes.CurrentPageIndex = lblPageNumber.text
        If strCol = "" Then
            strCol = "tblResumes.DateCreated"
            lblOrderBy.Text = "tblResumes.DateCreated"
            strSortOrder = "desc"
            lblDirection.Text = "desc"
        else
          lblOrderBy.Text = strCol
          lblDirection.Text = strSortOrder
        End If
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetResumesInFolder")
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@SortColumn", Data.SqlDbType.VarChar, Len(strCol)).Value = strCol
        cmd.Parameters.Add("@SortOrder", Data.SqlDbType.VarChar, Len(strSortOrder)).Value = strSortOrder
        cmd.Parameters.Add("@FolderID", Data.SqlDbType.Int).Value = lngFolderID
        cmd.Parameters.Add("@CountryID", Data.SqlDbType.Int).Value = _CountryID
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgvResumes.DataSource = ds
        dgvResumes.DataBind()
        'Dim ldr as New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        'ldr.LoadTwoStringLongParameterDataGrid("spGetResumesInFolder", "@SortColumn",lblOrderBy.Text,"@SortOrder",strSortOrder,"@FolderID",lngFolderID,dgvResumes)
        cnn.Close()
    End Sub
    
    
    Private Sub LoadLaborStateRegion(ByVal lngFolderID As Long, ByVal lngResumeTypeID As Long, ByVal lngStateID As Long, ByVal lngRegionID As Long, ByVal strCol As String, ByVal strSortOrder As String)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim da As New System.Data.SqlClient.SqlDataAdapter
        Dim ds As New System.Data.DataSet
        cnn.Open()
        'dgvResumes.CurrentPageIndex = lblPageNumber.text
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetResumesInFolderByResumeTypeStateRegion")
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@SortColumn", Data.SqlDbType.VarChar, Len(strCol)).Value = strCol
        cmd.Parameters.Add("@SortOrder", Data.SqlDbType.VarChar, Len(strSortOrder)).Value = strSortOrder
        cmd.Parameters.Add("@FolderID", Data.SqlDbType.Int).Value = lngFolderID
        cmd.Parameters.Add("@ResumeTypeID", Data.SqlDbType.Int).Value = lngResumeTypeID
        cmd.Parameters.Add("@StateID", Data.SqlDbType.Int).Value = lngStateID
        cmd.Parameters.Add("@RegionID", Data.SqlDbType.Int).Value = lngRegionID
        cmd.Parameters.Add("@CountryID", Data.SqlDbType.Int).Value = _CountryID
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgvResumes.DataSource = ds
        dgvResumes.DataBind()
        cnn.Close()
    End Sub
    
    Private Sub LoadRegion(ByVal lngFolderID As Long, ByVal lngRegionID As Long, ByVal strCol As String, ByVal strSortOrder As String)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim da As New System.Data.SqlClient.SqlDataAdapter
        Dim ds As New System.Data.DataSet
        cnn.Open()
        'dgvResumes.CurrentPageIndex = lblPageNumber.text
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetResumesInFolderByRegion")
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@SortColumn", Data.SqlDbType.VarChar, Len(strCol)).Value = strCol
        cmd.Parameters.Add("@SortOrder", Data.SqlDbType.VarChar, Len(strSortOrder)).Value = strSortOrder
        cmd.Parameters.Add("@FolderID", Data.SqlDbType.Int).Value = lngFolderID
        cmd.Parameters.Add("@RegionID", Data.SqlDbType.Int).Value = lngRegionID
        cmd.Parameters.Add("@CountryID", Data.SqlDbType.Int).Value = _CountryID
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgvResumes.DataSource = ds
        dgvResumes.DataBind()
        cnn.Close()
    End Sub
    
    Private Sub LoadLaborRegion(ByVal lngFolderID As Long, ByVal lngResumeTypeID As Long, ByVal lngRegionID As Long, ByVal strCol As String, ByVal strSortOrder As String)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim da As New System.Data.SqlClient.SqlDataAdapter
        Dim ds As New System.Data.DataSet
        cnn.Open()
        'dgvResumes.CurrentPageIndex = lblPageNumber.text
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetResumesInFolderByResumeTypeRegion")
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@SortColumn", Data.SqlDbType.VarChar, Len(strCol)).Value = strCol
        cmd.Parameters.Add("@SortOrder", Data.SqlDbType.VarChar, Len(strSortOrder)).Value = strSortOrder
        cmd.Parameters.Add("@FolderID", Data.SqlDbType.Int).Value = lngFolderID
        cmd.Parameters.Add("@ResumeTypeID", Data.SqlDbType.Int).Value = lngResumeTypeID
        cmd.Parameters.Add("@RegionID", Data.SqlDbType.Int).Value = lngRegionID
        cmd.Parameters.Add("@CountryID", Data.SqlDbType.Int).Value = _CountryID
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgvResumes.DataSource = ds
        dgvResumes.DataBind()
        cnn.Close()
    End Sub
    
    Private Sub LoadState(ByVal lngFolderID As Long, ByVal lngStateID As Long, ByVal strCol As String, ByVal strSortOrder As String)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim da As New System.Data.SqlClient.SqlDataAdapter
        Dim ds As New System.Data.DataSet
        cnn.Open()
        'dgvResumes.CurrentPageIndex = lblPageNumber.text
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetResumesInFolderByState")
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@SortColumn", Data.SqlDbType.VarChar, Len(strCol)).Value = strCol
        cmd.Parameters.Add("@SortOrder", Data.SqlDbType.VarChar, Len(strSortOrder)).Value = strSortOrder
        cmd.Parameters.Add("@FolderID", Data.SqlDbType.Int).Value = lngFolderID
        cmd.Parameters.Add("@StateID", Data.SqlDbType.Int).Value = lngStateID
        cmd.Parameters.Add("@CountryID", Data.SqlDbType.Int).Value = _CountryID
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgvResumes.DataSource = ds
        dgvResumes.DataBind()
        cnn.Close()
    End Sub
    
    Private Sub LoadLaborState(ByVal lngFolderID As Long, ByVal lngResumeTypeID As Long, ByVal lngStateID As Long, ByVal strCol As String, ByVal strSortOrder As String)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim da As New System.Data.SqlClient.SqlDataAdapter
        Dim ds As New System.Data.DataSet
        cnn.Open()
        'dgvResumes.CurrentPageIndex = lblPageNumber.text
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetResumesInFolderByResumeTypeState")
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@SortColumn", Data.SqlDbType.VarChar, Len(strCol)).Value = strCol
        cmd.Parameters.Add("@SortOrder", Data.SqlDbType.VarChar, Len(strSortOrder)).Value = strSortOrder
        cmd.Parameters.Add("@FolderID", Data.SqlDbType.Int).Value = lngFolderID
        cmd.Parameters.Add("@ResumeTypeID", Data.SqlDbType.Int).Value = lngResumeTypeID
        cmd.Parameters.Add("@StateID", Data.SqlDbType.Int).Value = lngStateID
        cmd.Parameters.Add("@CountryID", Data.SqlDbType.Int).Value = _CountryID
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgvResumes.DataSource = ds
        dgvResumes.DataBind()
        cnn.Close()
    End Sub
    
    Private Sub LoadStateRegion(ByVal lngFolderID As Long, ByVal lngStateID As Long, ByVal lngRegionID As Long, ByVal strCol As String, ByVal strSortOrder As String)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim da As New System.Data.SqlClient.SqlDataAdapter
        Dim ds As New System.Data.DataSet
        cnn.Open()
        'dgvResumes.CurrentPageIndex = lblPageNumber.text
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetResumesInFolderByStateRegion")
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@SortColumn", Data.SqlDbType.VarChar, Len(strCol)).Value = strCol
        cmd.Parameters.Add("@SortOrder", Data.SqlDbType.VarChar, Len(strSortOrder)).Value = strSortOrder
        cmd.Parameters.Add("@FolderID", Data.SqlDbType.Int).Value = lngFolderID
        cmd.Parameters.Add("@StateID", Data.SqlDbType.Int).Value = lngStateID
        cmd.Parameters.Add("@RegionID", Data.SqlDbType.Int).Value = lngRegionID
        cmd.Parameters.Add("@CountryID", Data.SqlDbType.Int).Value = _CountryID
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgvResumes.DataSource = ds
        dgvResumes.DataBind()
        cnn.Close()

    End Sub
    
    Private Sub LoadRegion()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        ldr.LoadSimpleDropDownList("spListRegions", "RegionName", "RegionID", drpRegion)
        drpRegion.Items.Add("Filter By Region")
        drpRegion.SelectedValue = "Filter By Region"
    End Sub
    Private Sub LoadStates(ByVal lngCountryID as long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        
          ldr.LoadSingleLongParameterDropDownList("spListStatesByCountryID","@CountryID",lngCountryID,"StateName","StateID",drpState)
          ldr.LoadSingleLongParameterDropDownList("spListStatesByCountryID","@CountryID",lngCountryID,"StateName","StateID",drpStates)
       
        drpState.Items.Add("Filter By State")
        drpState.SelectedValue = "Filter By State"
        
        drpStates.Items.Add("Select State")
        drpStates.SelectedValue = "Select State"
        
    End Sub
    
    Private Sub LoadAppliedFor()
    
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDropDownList("spListResumeTypes", "ResumeType", "ResumeTypeID",drpAppliedFor)
    drpAppliedFor.Items.add("Filter By Labor Network")
    drpAppliedFor.SelectedValue = "Filter By Labor Network"
    End Sub
    
    Private Sub FilterData(ByVal lngFolderID As Long, ByVal strCol As String, ByVal strSortOrder As String)
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim da As New System.Data.SqlClient.SqlDataAdapter
        Dim ds As New System.Data.DataSet
        cnn.Open()
        'dgvResumes.CurrentPageIndex = lblPageNumber.text
        If _FolderID >= 0 Then
            If drpCSR.SelectedValue <> "CSR All" Then
                If drpAppliedFor.SelectedValue <> "Filter By Labor Network" Then
                    If drpRegion.SelectedValue <> "Filter By Region" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter by User Labor Region State
                            ldr.LoadSixLongParameterDataGrid("spGetResumesInFolderByResumeTypeStateRegionUser", "@FolderID", _FolderID, "@ResumeTypeID", CType(drpAppliedFor.SelectedValue, Long), "@StateID", CType(drpState.SelectedValue, Long), "@RegionID", CType(drpRegion.SelectedValue, Long), "@CountryID", _CountryID, "@UserID", CType(drpCSR.SelectedValue, Long), dgvResumes)
                        Else
                            'Filter by User Labor Region
                            ldr.LoadFiveLongParameterDataGrid("spGetResumesInFolderByResumeTypeRegionUser", "@FolderID", _FolderID, "@ResumeTypeID", CType(drpAppliedFor.SelectedValue, Long), "@RegionID", CType(drpRegion.SelectedValue, Long), "@CountryID", _CountryID, "@UserID", CType(drpCSR.SelectedValue, Long), dgvResumes)
                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter User Labor State
                            ldr.LoadFiveLongParameterDataGrid("spGetResumesInFolderByResumeTypeStateUser", "@FolderID", _FolderID, "@ResumeTypeID", CType(drpAppliedFor.SelectedValue, Long), "@StateID", CType(drpState.SelectedValue, Long), "@CountryID", _CountryID, "@UserID", CType(drpCSR.SelectedValue, Long), dgvResumes)
                        Else
                            'Filter by user Labor
                            ldr.LoadFourLongParameterDataGrid("spGetResumesInFolderByResumeTypeUser", "@FolderID", _FolderID, "@ResumeTypeID", CType(drpAppliedFor.SelectedValue, Long), "@UserID", CType(drpCSR.SelectedValue, Long), "@CountryID", _CountryID, dgvResumes)
                        End If
                    End If
                Else
                    If drpState.SelectedValue <> "Filter By State" Then
                        If drpRegion.SelectedValue <> "Filter By Region" Then
                            'Filter by User State Region
                            ldr.LoadFiveLongParameterDataGrid("spGetResumesInFolderByStateRegionUser", "@FolderID", _FolderID, "@StateID", CType(drpState.SelectedValue, Long), "@RegionID", CType(drpRegion.SelectedValue, Long), "@CountryID", _CountryID, "@UserID", CType(drpCSR.SelectedValue, Long), dgvResumes)
                        Else
                            'Filter By User State
                            ldr.LoadFourLongParameterDataGrid("spGetResumesInFolderByStateUser", "@FolderID", _FolderID, "@StateID", CType(drpState.SelectedValue, Long), "@UserID", CType(drpCSR.SelectedValue, Long), "@CountryID", _CountryID, dgvResumes)
                        End If
                    Else
                        If drpRegion.SelectedValue <> "Filter By Region" Then
                            'Filter by User Region
                            ldr.LoadFourLongParameterDataGrid("spGetResumesInFolderByUserRegion", "@FolderID", _FolderID, "@UserID", CType(drpCSR.SelectedValue, Long), "@RegionID", CType(drpRegion.SelectedValue, Long), "@CountryID", _CountryID, dgvResumes)
                        Else
                            'Filter by User
                            ldr.LoadThreeLongParameterDataGrid("spGetResumesInFolderByUser", "@FolderID", _FolderID, "@UserID", CType(drpCSR.SelectedValue, Long), "@CountryID", _CountryID, dgvResumes)
                        End If
                    End If
                End If
            Else
                If drpAppliedFor.SelectedValue <> "Filter By Labor Network" Then
                    If drpState.SelectedValue <> "Filter By State" Then
                        If drpRegion.SelectedValue <> "Filter By Region" Then
                            'Filter by labor state region
                            ldr.LoadFiveLongParameterDataGrid("spGetResumesInFolderByResumeTypeStateRegion", "@FolderID", _FolderID, "@ResumeTypeID", CType(drpAppliedFor.SelectedValue, Long), "@StateID", CType(drpState.SelectedValue, Long), "@RegionID", CType(drpRegion.SelectedValue, Long), "@CountryID", _CountryID, dgvResumes)
                        Else
                            'Filter by Labor state
                            ldr.LoadFourLongParameterDataGrid("spGetResumesInFolderByResumeTypeState", "@FolderID", _FolderID, "@ResumeTypeID", CType(drpAppliedFor.SelectedValue, Long), "@StateID", CType(drpState.SelectedValue, Long), "@CountryID", _CountryID, dgvResumes)
                        End If
                    Else
                        If drpRegion.SelectedValue <> "Filter By Region" Then
                            'filter by labor region
                            ldr.LoadFourLongParameterDataGrid("spGetResumesInFolderByResumeTypeRegion", "@FolderID", _FolderID, "@ResumeTypeID", CType(drpAppliedFor.SelectedValue, Long), "@RegionID", CType(drpRegion.SelectedValue, Long), "@CountryID", _CountryID, dgvResumes)
                        Else
                            'Filter by labor
                            ldr.LoadThreeLongParameterDataGrid("spGetResumesInFolderByState", "@FolderID", _FolderID, "@ResumeTypeID", CType(drpAppliedFor.SelectedValue, Long), "@CountryID", _CountryID, dgvResumes)
                        End If
                    End If
                Else
                    If drpState.SelectedValue <> "Filter By State" Then
                        If drpRegion.SelectedValue <> "Filter By Region" Then
                            'Filter by state Region
                            ldr.LoadFourLongParameterDataGrid("spGetResumesInFolderByStateRegion", "@FolderID", _FolderID, "@StateID", CType(drpState.SelectedValue, Long), "@RegionID", CType(drpRegion.SelectedValue, Long), "@CountryID", _CountryID, dgvResumes)
                        Else
                            'Filter by State
                            ldr.LoadThreeLongParameterDataGrid("spGetResumesInFolderByState", "@FolderID", _FolderID, "@StateID", CType(drpState.SelectedValue, Long), "@CountryID", _CountryID, dgvResumes)
                        End If
                    Else
                        If drpRegion.SelectedValue <> "Filter By Region" Then
                            'Filter by Region
                            ldr.LoadThreeLongParameterDataGrid("spGetResumesInFolderByRegion", "@FolderID", _FolderID, "@RegionID", CType(drpRegion.SelectedValue, Long), "@CountryID", _CountryID, dgvResumes)
                        Else
                            'No filter
                            ldr.LoadTwoLongParameterDataGrid("spGetResumesInFolder", "@FolderID", _FolderID, "@CountryID", _CountryID, dgvResumes)
                        End If
                    End If
                End If
       
            End If
        End If
        If _user <> 0 then
          lblUntouched.Text = " U: " & GetTotalUntouchedResumesByUser(_user)
        Else
           lblUntouched.Text = " U: " & GetTotalUntouchedResumes()
        end if
        lblTicketCount.Text = " [ " & CType(dgvResumes.DataSource, Data.DataSet).Tables(0).Rows.Count & " ] "
       
        cnn.Close()
    End Sub
  
  Private Sub dgvResumes_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgvResumes.ItemDataBound
        Dim rowData As Data.DataRowView
        Dim strLocation As String
       
        
        'check the type of item that was databound and only take action if it 
        'was a row in the datagrid
        Select Case (e.Item.ItemType)
            Case ListItemType.AlternatingItem, ListItemType.EditItem, ListItemType.Item, ListItemType.SelectedItem 
                'get the data for the item being bound
                
                rowData = CType(e.Item.DataItem, Data.DataRowView)
                If Not IsDBNull((rowData.Item("LocationName"))) then 
                   strLocation = (rowData.Item("LocationName"))
                     if Not IsLocationAssigned(strLocation) then
                        e.Item.ForeColor = Drawing.Color.Red
                     else 
                       If IsAgentStatusProbation(strLocation) then
                         e.Item.ForeColor = Drawing.Color.DarkViolet
                       end if
                     end if
                else 
                   e.Item.ForeColor = Drawing.Color.Red
                 
                End If
                
            Case ListItemType.Footer

              
            Case Else
                
                
        End Select
        
    End Sub  'dgvResumes_ItemDataBound
  
  Private Function IsLocationAssigned (strLocationName as String) as Boolean 
  Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("spGetLocationAssignmentByLocationName")
    Dim dtr As System.Data.SqlClient.SqlDataReader
    Dim boolAssign as Boolean 
    cmd.CommandType = Data.CommandType.StoredProcedure
    cmd.Parameters.Add("@LocationName", Data.SqlDbType.VarChar, Len(strLocationName)).Value = strLocationName
    cnn.Open()
    cmd.Connection = cnn
    dtr = cmd.ExecuteReader
    while dtr.Read
       if dtr("PartnerAddressID").ToString = "0" then
         boolAssign = False
       else
         boolAssign = True
       end if
    
    end while
    IsLocationAssigned = boolAssign
  cnn.Close()
  End function
  
    Private Function IsAgentStatusProbation (strLocationName as String) as Boolean 
  Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("spGetAgentStatusByLocationName")
    Dim dtr As System.Data.SqlClient.SqlDataReader
    Dim boolAssign as Boolean 
    cmd.CommandType = Data.CommandType.StoredProcedure
    cmd.Parameters.Add("@LocationName", Data.SqlDbType.VarChar, Len(strLocationName)).Value = strLocationName
    cnn.Open()
    cmd.Connection = cnn
    dtr = cmd.ExecuteReader
    while dtr.Read
            If (dtr("PartnerAgentStatusID").ToString <> "1" And dtr("PartnerAgentStatusID").ToString <> "5") Then
                boolAssign = True
            Else
                boolAssign = False
            End If
    
    end while
    IsAgentStatusProbation = boolAssign
  cnn.Close()
  End function
  
  Private Sub menu_MenuItemClick(ByVal sender As Object, ByVal e As MenuEventArgs) Handles menu.MenuItemClick
        Multiview1.ActiveViewIndex = Int32.Parse(e.Item.Value)
        Select Case Int32.Parse(e.Item.Value)
            
            Case Is = 0
                
            Case Is = 1
                
                
        End Select
        
    End Sub
    
    Private Sub GetCoverage(lngStateID As long)
    
    Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spGetCoverage",  "@StateID", drpStates.selectedValue,dgvServiceTypes)
    
    End Sub
    
    Protected Sub drpStates_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        If drpStates.SelectedValue <> "Select State" Then
            GetCoverage(CType(drpStates.SelectedValue, Long))
            
            
            lblMap.Text = "<a href='/maps/" & drpStates.SelectedItem.Text & "-counties-map.gif' target='blank' >" & drpStates.SelectedItem.Text & " Map</a>"
                
               
        End If
    End Sub
    
    Private Sub dgvServiceTypes_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgvServiceTypes.ItemDataBound
      Dim rowData As Data.DataRowView
      Dim strTechName As string
      strTechName = "-"
      'check the type of item that was databound and only take action if it 
        'was a row in the datagrid
        Select Case (e.Item.ItemType)
            Case ListItemType.AlternatingItem, ListItemType.EditItem, ListItemType.Item, ListItemType.SelectedItem 
                'get the data for the item being bound
                
                rowData = CType(e.Item.DataItem, Data.DataRowView)
                If Not IsDBNull((rowData.Item("HVAC"))) then 
                   strTechName = (rowData.Item("HVAC"))
                   If strTechName.Contains("Probation") then
                     e.Item.Cells(0).ForeColor = drawing.Color.red
                     e.Item.Cells(1).ForeColor = drawing.Color.red
                     
                   end if
                   If strTechName.Contains("On Hold") then
                     e.Item.Cells(0).ForeColor = drawing.Color.red
                     e.Item.Cells(1).ForeColor = drawing.Color.red
                   end if
                   If strTechName.Contains("Exiting - Gave Notice") then
                     e.Item.Cells(0).ForeColor = drawing.Color.red
                     e.Item.Cells(1).ForeColor = drawing.Color.red
                   end if
                   If strTechName.Contains("Alert - Missing") then
                     e.Item.Cells(0).ForeColor = drawing.Color.red
                     e.Item.Cells(1).ForeColor = drawing.Color.red
                   end if
                 end if  
                 If Not IsDBNull((rowData.Item("ApplianceRepair"))) then 
                   strTechName = (rowData.Item("ApplianceRepair"))
                   If strTechName.Contains("Probation") then
                     e.Item.Cells(0).ForeColor = drawing.Color.red
                     e.Item.Cells(2).ForeColor = drawing.Color.red
                   end if
                   If strTechName.Contains("On Hold") then
                     e.Item.Cells(0).ForeColor = drawing.Color.red
                     e.Item.Cells(2).ForeColor = drawing.Color.red
                   end if
                   If strTechName.Contains("Exiting - Gave Notice") then
                     e.Item.Cells(0).ForeColor = drawing.Color.red
                     e.Item.Cells(2).ForeColor = drawing.Color.red
                   end if
                   If strTechName.Contains("Alert - Missing") then
                     e.Item.Cells(0).ForeColor = drawing.Color.red
                     e.Item.Cells(2).ForeColor = drawing.Color.red
                   end if
                 end if  
                 If Not IsDBNull((rowData.Item("TVRepair"))) then 
                   strTechName = (rowData.Item("TVRepair"))
                   If strTechName.Contains("Probation") then
                     e.Item.Cells(0).ForeColor = drawing.Color.red
                     e.Item.Cells(3).ForeColor = drawing.Color.red
                   end if
                   If strTechName.Contains("On Hold") then
                     e.Item.Cells(0).ForeColor = drawing.Color.red
                     e.Item.Cells(3).ForeColor = drawing.Color.red
                   end if
                   If strTechName.Contains("Exiting - Gave Notice") then
                     e.Item.Cells(0).ForeColor = drawing.Color.red
                     e.Item.Cells(3).ForeColor = drawing.Color.red
                   end if
                   If strTechName.Contains("Alert - Missing") then
                     e.Item.Cells(0).ForeColor = drawing.Color.red
                     e.Item.Cells(3).ForeColor = drawing.Color.red
                   end if
                 end if
                 If Not IsDBNull((rowData.Item("CentralAC"))) then 
                   strTechName = (rowData.Item("CentralAC"))
                   If strTechName.Contains("Probation") then
                     e.Item.Cells(0).ForeColor = drawing.Color.red
                     e.Item.Cells(4).ForeColor = drawing.Color.red
                   end if
                   If strTechName.Contains("On Hold") then
                     e.Item.Cells(0).ForeColor = drawing.Color.red
                     e.Item.Cells(4).ForeColor = drawing.Color.red
                   end if
                   If strTechName.Contains("Exiting - Gave Notice") then
                     e.Item.Cells(0).ForeColor = drawing.Color.red
                     e.Item.Cells(4).ForeColor = drawing.Color.red
                   end if
                   If strTechName.Contains("Alert - Missing") then
                     e.Item.Cells(0).ForeColor = drawing.Color.red
                     e.Item.Cells(4).ForeColor = drawing.Color.red
                   end if
                 end if    
            End Select
  
    End Sub  'dgvServiceTypes_ItemDataBound
  
    Private Function GetTotalResumesInFolder(ByVal lngFolderID As Long, ByVal lngCountryID As Long) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetTotalTicketInResumeFolder")
        Dim dtr As System.Data.SqlClient.SqlDataReader
        Dim lngTotal As Long
        lngTotal = 0
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@ResumeFolderID", Data.SqlDbType.Int).Value = lngFolderID
        cmd.Parameters.Add("@CountryID", Data.SqlDbType.Int).Value = lngCountryID
        cnn.Open()
        cmd.Connection = cnn
        dtr = cmd.ExecuteReader
        While dtr.Read
            lngTotal = dtr("Total")
        End While
        Return lngTotal
        cnn.Close()
    End Function
     Private Sub LoadCSRs()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        ldr.LoadSimpleDropDownList("spListUsersRecruiter", "UserName", "UserID",drpCSR)
        'ldr.LoadSingleLongParameterDropDownList("spListUsersCallCenter", "@TicketFolderID", 7, "Login", "PartnerID", drpPartners)
        If _user <> 0 Then
            drpCSR.Items.Add("CSR All")
            drpCSR.SelectedValue = _user
        Else
            drpCSR.Items.Add("CSR All")
            drpCSR.SelectedValue = "CSR All"
        End If
        
    End Sub
    
    Private Sub LoadLaborStateRegionUser(ByVal lngFolderID As Long, ByVal lngResumeTypeID As Long, ByVal lngStateID As Long, ByVal lngRegionID As Long, ByVal lnguserID As Long, ByVal strCol As String, ByVal strSortOrder As String)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim da As New System.Data.SqlClient.SqlDataAdapter
        Dim ds As New System.Data.DataSet
        cnn.Open()
        'dgvResumes.CurrentPageIndex = lblPageNumber.text
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetResumesInFolderByResumeTypeStateRegionUser")
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@SortColumn", Data.SqlDbType.VarChar, Len(strCol)).Value = strCol
        cmd.Parameters.Add("@SortOrder", Data.SqlDbType.VarChar, Len(strSortOrder)).Value = strSortOrder
        cmd.Parameters.Add("@FolderID", Data.SqlDbType.Int).Value = lngFolderID
        cmd.Parameters.Add("@ResumeTypeID", Data.SqlDbType.Int).Value = lngResumeTypeID
        cmd.Parameters.Add("@StateID", Data.SqlDbType.Int).Value = lngStateID
        cmd.Parameters.Add("@RegionID", Data.SqlDbType.Int).Value = lngRegionID
        cmd.Parameters.Add("@CountryID", Data.SqlDbType.Int).Value = _CountryID
        cmd.Parameters.Add("@UserID", Data.SqlDbType.Int).Value = lnguserID
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgvResumes.DataSource = ds
        dgvResumes.DataBind()
        cnn.Close()
    End Sub
    Private Sub LoadUser(ByVal lngFolderID As Long, ByVal lngUserID As Long, ByVal strCol As String, ByVal strSortOrder As String)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim da As New System.Data.SqlClient.SqlDataAdapter
        Dim ds As New System.Data.DataSet
        cnn.Open()
        'dgvResumes.CurrentPageIndex = lblPageNumber.text
        If strCol <> "" Then
            Dim cmd As New System.Data.SqlClient.SqlCommand("spGetResumesInFolderByUser")
            cmd.CommandType = Data.CommandType.StoredProcedure
            cmd.Parameters.Add("@SortColumn", Data.SqlDbType.VarChar, Len(strCol)).Value = strCol
            cmd.Parameters.Add("@SortOrder", Data.SqlDbType.VarChar, Len(strSortOrder)).Value = strSortOrder
            cmd.Parameters.Add("@FolderID", Data.SqlDbType.Int).Value = lngFolderID
            cmd.Parameters.Add("@UserID", Data.SqlDbType.Int).Value = lngUserID
            cmd.Parameters.Add("@CountryID", Data.SqlDbType.Int).Value = _CountryID
            cmd.Connection = cnn
            da.SelectCommand = cmd
            da.Fill(ds)
            dgvResumes.DataSource = ds
            dgvResumes.DataBind()
        Else
            Dim cmd As New System.Data.SqlClient.SqlCommand("spGetResumesInFolderByUser2")
            cmd.CommandType = Data.CommandType.StoredProcedure
            cmd.Parameters.Add("@FolderID", Data.SqlDbType.Int).Value = lngFolderID
            cmd.Parameters.Add("@UserID", Data.SqlDbType.Int).Value = lngUserID
            cmd.Parameters.Add("@CountryID", Data.SqlDbType.Int).Value = _CountryID
            cmd.Connection = cnn
            da.SelectCommand = cmd
            da.Fill(ds)
            dgvResumes.DataSource = ds
            dgvResumes.DataBind()
            
        End If
        cnn.Close()
    End Sub
    Private Sub LoadLaborUser(ByVal lngFolderID As Long, ByVal lngResumeTypeID As Long, ByVal lngUserID As Long, ByVal strCol As String, ByVal strSortOrder As String)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim da As New System.Data.SqlClient.SqlDataAdapter
        Dim ds As New System.Data.DataSet
        cnn.Open()
        'dgvResumes.CurrentPageIndex = lblPageNumber.text
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetResumesInFolderByResumeTypeUser")
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@SortColumn", Data.SqlDbType.VarChar, Len(strCol)).Value = strCol
        cmd.Parameters.Add("@SortOrder", Data.SqlDbType.VarChar, Len(strSortOrder)).Value = strSortOrder
        cmd.Parameters.Add("@FolderID", Data.SqlDbType.Int).Value = lngFolderID
        cmd.Parameters.Add("@ResumeTypeID", Data.SqlDbType.Int).Value = lngResumeTypeID
        cmd.Parameters.Add("@UserID", Data.SqlDbType.Int).Value = lngUserID
        cmd.Parameters.Add("@CountryID", Data.SqlDbType.Int).Value = _CountryID
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgvResumes.DataSource = ds
        dgvResumes.DataBind()
        cnn.Close()
    End Sub
    Private Sub LoadRegionUser(ByVal lngFolderID As Long, ByVal lngUserID As Long, ByVal lngRegionID As Long, ByVal strCol As String, ByVal strSortOrder As String)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim da As New System.Data.SqlClient.SqlDataAdapter
        Dim ds As New System.Data.DataSet
        cnn.Open()
        'dgvResumes.CurrentPageIndex = lblPageNumber.text
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetResumesInFolderByRegionUser")
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@SortColumn", Data.SqlDbType.VarChar, Len(strCol)).Value = strCol
        cmd.Parameters.Add("@SortOrder", Data.SqlDbType.VarChar, Len(strSortOrder)).Value = strSortOrder
        cmd.Parameters.Add("@FolderID", Data.SqlDbType.Int).Value = lngFolderID
        cmd.Parameters.Add("@UserID", Data.SqlDbType.Int).Value = lngUserID
        cmd.Parameters.Add("@RegionID", Data.SqlDbType.Int).Value = lngRegionID
        cmd.Parameters.Add("@CountryID", Data.SqlDbType.Int).Value = _CountryID
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgvResumes.DataSource = ds
        dgvResumes.DataBind()
        cnn.Close()
    End Sub
    Private Sub LoadStateUser(ByVal lngFolderID As Long, ByVal lngStateID As Long, ByVal lngUserID As Long, ByVal strCol As String, ByVal strSortOrder As String)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim da As New System.Data.SqlClient.SqlDataAdapter
        Dim ds As New System.Data.DataSet
        cnn.Open()
        'dgvResumes.CurrentPageIndex = lblPageNumber.text
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetResumesInFolderByStateUser")
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@SortColumn", Data.SqlDbType.VarChar, Len(strCol)).Value = strCol
        cmd.Parameters.Add("@SortOrder", Data.SqlDbType.VarChar, Len(strSortOrder)).Value = strSortOrder
        cmd.Parameters.Add("@FolderID", Data.SqlDbType.Int).Value = lngFolderID
        cmd.Parameters.Add("@StateID", Data.SqlDbType.Int).Value = lngStateID
        cmd.Parameters.Add("@UserID", Data.SqlDbType.Int).Value = lngUserID
        cmd.Parameters.Add("@CountryID", Data.SqlDbType.Int).Value = _CountryID
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgvResumes.DataSource = ds
        dgvResumes.DataBind()
        cnn.Close()

    End Sub
    Private Sub LoadLaborStateUser(ByVal lngFolderID As Long, ByVal lngResumeTypeID As Long, ByVal lngStateID As Long, ByVal lngUserID As Long, ByVal strCol As String, ByVal strSortOrder As String)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim da As New System.Data.SqlClient.SqlDataAdapter
        Dim ds As New System.Data.DataSet
        cnn.Open()
        'dgvResumes.CurrentPageIndex = lblPageNumber.text
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetResumesInFolderByResumeTypeStateUser")
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@SortColumn", Data.SqlDbType.VarChar, Len(strCol)).Value = strCol
        cmd.Parameters.Add("@SortOrder", Data.SqlDbType.VarChar, Len(strSortOrder)).Value = strSortOrder
        cmd.Parameters.Add("@FolderID", Data.SqlDbType.Int).Value = lngFolderID
        cmd.Parameters.Add("@ResumeTypeID", Data.SqlDbType.Int).Value = lngResumeTypeID
        cmd.Parameters.Add("@StateID", Data.SqlDbType.Int).Value = lngStateID
        cmd.Parameters.Add("@CountryID", Data.SqlDbType.Int).Value = _CountryID
        cmd.Parameters.Add("@UserID", Data.SqlDbType.Int).Value = lnguserID
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgvResumes.DataSource = ds
        dgvResumes.DataBind()
        cnn.Close()
    End Sub
    Private Sub LoadLaborRegionUser(ByVal lngFolderID As Long, ByVal lngResumeTypeID As Long, ByVal lngRegionID As Long, ByVal lngUserID As Long, ByVal strCol As String, ByVal strSortOrder As String)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim da As New System.Data.SqlClient.SqlDataAdapter
        Dim ds As New System.Data.DataSet
        cnn.Open()
        'dgvResumes.CurrentPageIndex = lblPageNumber.text
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetResumesInFolderByResumeTypeRegionUser")
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@SortColumn", Data.SqlDbType.VarChar, Len(strCol)).Value = strCol
        cmd.Parameters.Add("@SortOrder", Data.SqlDbType.VarChar, Len(strSortOrder)).Value = strSortOrder
        cmd.Parameters.Add("@FolderID", Data.SqlDbType.Int).Value = lngFolderID
        cmd.Parameters.Add("@ResumeTypeID", Data.SqlDbType.Int).Value = lngResumeTypeID
        cmd.Parameters.Add("@RegionID", Data.SqlDbType.Int).Value = lngRegionID
        cmd.Parameters.Add("@CountryID", Data.SqlDbType.Int).Value = _CountryID
        cmd.Parameters.Add("@UserID", Data.SqlDbType.Int).Value = lnguserID
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgvResumes.DataSource = ds
        dgvResumes.DataBind()
        cnn.Close()
    End Sub
    Private Sub LoadStateRegionUser(ByVal lngFolderID As Long, ByVal lngStateID As Long, ByVal lngRegionID As Long, ByVal lnguserID As Long, ByVal strCol As String, ByVal strSortOrder As String)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim da As New System.Data.SqlClient.SqlDataAdapter
        Dim ds As New System.Data.DataSet
        cnn.Open()
        'dgvResumes.CurrentPageIndex = lblPageNumber.text
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetResumesInFolderByResumeTypeStateRegionUser")
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@SortColumn", Data.SqlDbType.VarChar, Len(strCol)).Value = strCol
        cmd.Parameters.Add("@SortOrder", Data.SqlDbType.VarChar, Len(strSortOrder)).Value = strSortOrder
        cmd.Parameters.Add("@FolderID", Data.SqlDbType.Int).Value = lngFolderID
        cmd.Parameters.Add("@StateID", Data.SqlDbType.Int).Value = lngStateID
        cmd.Parameters.Add("@RegionID", Data.SqlDbType.Int).Value = lngRegionID
        cmd.Parameters.Add("@CountryID", Data.SqlDbType.Int).Value = _CountryID
        cmd.Parameters.Add("@UserID", Data.SqlDbType.Int).Value = lnguserID
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgvResumes.DataSource = ds
        dgvResumes.DataBind()
        cnn.Close()
    End Sub
    Private Function GetTotalResumesInFolderByUser(ByVal lngFolderID As Long, ByVal lngCountryID As Long, ByVal lngUserID As Long) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetTotalTicketInResumeFolderByUser")
        Dim dtr As System.Data.SqlClient.SqlDataReader
        Dim lngTotal As Long
        lngTotal = 0
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@ResumeFolderID", Data.SqlDbType.Int).Value = lngFolderID
        cmd.Parameters.Add("@CountryID", Data.SqlDbType.Int).Value = lngCountryID
        cmd.Parameters.Add("@UserID", Data.SqlDbType.Int).Value = lngUserID
        cnn.Open()
        cmd.Connection = cnn
        dtr = cmd.ExecuteReader
        While dtr.Read
            lngTotal = dtr("Total")
        End While
        Return lngTotal
        cnn.Close()
    End Function
    Private Function GetTotalResumesByUser(ByVal lngCountryID As Long, ByVal lngUserID As Long) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetTotalTicketInResumeByUser")
        Dim dtr As System.Data.SqlClient.SqlDataReader
        Dim lngTotal As Long
        lngTotal = 0
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@CountryID", Data.SqlDbType.Int).Value = lngCountryID
        cmd.Parameters.Add("@UserID", Data.SqlDbType.Int).Value = lngUserID
        cnn.Open()
        cmd.Connection = cnn
        dtr = cmd.ExecuteReader
        While dtr.Read
            lngTotal = dtr("Total")
        End While
        Return lngTotal
        cnn.Close()
    End Function
    Private Function GetTotalUntouchedResumesByUser(ByVal lngUserID As Long) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetTotalResumesUntouchedByUser")
        Dim lngTotal As Long = 0
        cmd.Parameters.Add("@UserID", Data.SqlDbType.Int).Value = lngUserID
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            lngTotal = dtr("Total")
        End While
        Return lngTotal
        cnn.Close()
    End Function



    Private Function GetTotalUntouchedResumes() As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetTotalResumesUntouched")
        Dim lngTotal As Long = 0
       
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            lngTotal = dtr("Total")
        End While
        Return lngTotal
        cnn.Close()
    End Function
</script>

<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmRecruit" runat="server" defaultbutton="btnQuickSearch">
  <div id="tab5">
   <asp:Menu ID="menu" runat="server" Orientation="Horizontal" OnMenuItemClick ="menu_MenuItemClick" CssClass="ul">
    <StaticMenuItemStyle CssClass="li" />
     <StaticHoverStyle CssClass="hoverstyle" />
      <StaticSelectedStyle CssClass="current" />
       <Items>
        <asp:MenuItem  value ="0" Text="Candidates"></asp:MenuItem>
        <asp:MenuItem value ="1" Text="Coverage"></asp:MenuItem> 
        <asp:MenuItem value ="2" Text="Placing Adds"></asp:MenuItem>
       </Items>
      </asp:Menu>
    </div>
    <div id="ratesheader" class="tabbody">
  <div >&nbsp;</div></div>
   <asp:MultiView ID="Multiview1" runat="server" ActiveViewIndex="0" >
   <asp:View ID="candidates"  runat="server">
    <table style="width:100%">
      <tr>
        <td class="band"><div class="bandheader"></div><asp:button ID="btnGo" Text="Go" OnClick="btnGo_Click" runat="server" visible="false"/>
          <div id="divFolders" runat="server" />
          <div>&nbsp;</div>          
          <div class="inputformsectionheader">Search</div> 
          <div class="inputform" style="padding-left: 3px">Quick Resume Search</div>
            <div id="divResumeSearchError" class="errorzone" visible="false" runat="server" /></div>
            <div style="padding-left: 3px;">
              <div class="label">Criteria</div>
              <div><asp:TextBox style="width:95%;" ID="txtResumeSearch" runat="server" /></div>
              <div class="label">Look In</div>
              <div><asp:DropDownList ID="cbxLookIn" style="width:95%;" runat="server" /></div>
              <div style="text-align: right;"><asp:button ID="btnQuickSearch" OnClick="btnQuickSearch_Click" text="Search" runat="server" /></div>
            </div> 
          <div>&nbsp;</div>          
          <div class="inputformsectionheader">Look Up By Radius</div> 
          <div class="inputform" style="padding-left: 3px" /></div>
            <div id="div1" class="errorzone" visible="false" runat="server" /></div>
            <div style="padding-left: 3px;">
              <div class="label">Zip Code</div>
              <div><asp:TextBox style="width:95%;" ID="txtZipCode" runat="server" /></div>
              <div class="label">Radius in Miles</div>
              <div><asp:TextBox style="width:95%;" ID="txtRadius" runat="server" /></div>
              <div style="text-align: right;"><asp:button ID="btnClosestCandidates" OnClick="btnClosestCandidates_Click" text="Get Candidates" runat="server" /></div>
            </div> 
          
          <div>&nbsp;</div>
          <div class="inputformsectionheader">Campaign</div>
          <div class="inputform" style="padding-left: 3px">
            <div class="label">Existing&nbsp;Campaigns</div>
            <asp:DropDownList ID="cbxCampaigns" runat="server" />
            <div style="text-align: right;"><asp:button ID="btnGoToCampaign" Text="Go" OnClick="btnGoToCampaign_Click" runat="server" /></div>
            <div><a href="addcampaign.aspx">New Campaign</a></div>
          </div>
          <div>&nbsp;</div>
          <div class="bandheader">Commands</div>
          <div><a id="lnkCountiesCoverage" runat="server">Counties Coverage</a></div>
          <div><a id="lnkExportFolder" runat="server">Export Folder</a></div>          
          <div><a href="/join/default.aspx" target="_blank">Enter A Resume</a> </div>
          <div><a id="lnkRefresh" runat="server">Refresh</a></div>          
        </td>
        <td>
        <div class="inputformsectionheader">
          <asp:Label ID="lblTicketCount" runat="server"></asp:Label>
          <asp:DropDownList ID="drpCSR" runat="server" AutoPostBack="True"/>
          <asp:DropDownList ID="drpAppliedFor" runat="server" AutoPostBack="True" />
          <asp:DropDownList ID="drpRegion" Runat="server" AutoPostBack="True" />
          <asp:DropDownList ID="drpState" Runat="server" AutoPostBack="True" />
          <asp:Label ID="lblUntouched" runat="server"></asp:Label>
        </div>  
        <asp:DataGrid CellPadding="1" Width="100%" AutoGenerateColumns="false" AllowSorting="true" OnSortCommand="dgvResumes_SortCommand" runat="server" ID="dgvResumes" Cssclass="Grid1">
          <HeaderStyle CssClass="gridheader" />
          
          <AlternatingItemStyle CssClass="altrow" />          
          <Columns>
            <asp:BoundColumn
              HeaderText="Distance"
              DataField="Distance" 
              SortExpression="Distance"
              Visible="False"
            />
            <asp:templatecolumn
              HeaderText="ID"
              SortExpression="ResumeID"
              >
              <ItemTemplate>
                <a target="_blank" href="resume.aspx?resumeid=<%# Databinder.eval(Container.DataItem, "ResumeID") %>&folder=<%# CurrentFolder() %>&orderby=<%# orderby() %>&sortorder=<%# SortOrder() %>"><%# Databinder.eval(Container.DataItem, "ResumeID") %></a>
              </ItemTemplate>
            </asp:templatecolumn>
            <asp:BoundColumn
              HeaderText="Company"
              DataField="CompanyName" 
              SortExpression="CompanyName"
            />
            <asp:BoundColumn
               HeaderText="Applied For"
               DataField="ResumeType"
               SortExpression="ResumeType"
             />
            <asp:BoundColumn
              HeaderText="First Name"
              DataField="FirstName"
              SortExpression="FirstName"
             />
             <asp:TemplateColumn
               HeaderText="Last Name"               
               SortExpression="LastName">               
               <ItemTemplate>
                 <a href="mailto:<%# Databinder.eval(Container.DataItem, "Email") %>"><%# Databinder.eval(Container.DataItem, "LastName") %></a>
               </ItemTemplate>
             </asp:TemplateColumn>             
             
             <asp:BoundColumn
               HeaderText="City"
               DataField="City"
               SortExpression="City"
             />
             <asp:BoundColumn
               HeaderText="State"
               DataField="StateName"
               SortExpression="StateName"
              />
              <asp:BoundColumn
               HeaderText="County"
               DataField="CountyName"
               SortExpression="CountyName"
              />
              <asp:TemplateColumn
                HeaderText="Location"
              >
              <ItemTemplate>
               <a href="../Maps/<%# Databinder.eval(Container.DataItem,"LocationName") %>.jpg" target="_blank"><%# Databinder.eval(Container.DataItem,"LocationName") %></a>                            </ItemTemplate>
              </asp:TemplateColumn>
             <asp:TemplateColumn
               HeaderText="Zip"
               SortExpression="ZipCode" 
               >
               <ItemTemplate>
                 <a href="findzipcode.aspx?zip=<%# Databinder.eval(Container.DataItem,"ZipCode") %>" target="_blank"><%# Databinder.eval(Container.DataItem,"ZipCode") %></a>
               </ItemTemplate>
             </asp:TemplateColumn>             
             
             <asp:TemplateColumn HeaderText="Local">
               <ItemStyle CssClass="highlightcell" />
               <ItemTemplate>
                 <%#CType(DataBinder.Eval(Container.DataItem, "LocalTime"), Date).ToString("hh:mm")%>
               </ItemTemplate>
             </asp:TemplateColumn>
             <asp:BoundColumn 
               HeaderText="Date Entered"
               DataField="DateCreated" 
               SortExpression="DateCreated"               
             />
          </Columns>
        </asp:DataGrid>
        <div><asp:Label Visible="false" ID="lblOrder" runat="server" /></div>
        </td>
      </tr>
    </table>
    <asp:label ID="lblOrderBy" runat="server" Visible="false" />
    <asp:Label ID="lblDirection" runat="server" Visible="false" />
    <asp:Label ID="lblPageNumber" runat="server" Visible="false" />
    </asp:View>
    <asp:View ID="coverage"  runat="server">
    
      <table>
        <tr>
          <td class="band" >
            
            <div class="bandheader">Choose States</div>
            <div>&nbsp;</div> 
              <asp:Label ID="Label1" runat="server"></asp:Label>
              <asp:DropDownList ID="drpStates" runat="server" AutoPostBack="True" OnSelectedIndexChanged="drpStates_SelectedIndexChanged" />
              <div>&nbsp;</div>
              <div>&nbsp;</div>
              <div>&nbsp;</div>
              <div><asp:Label ID="lblMap" runat ="server" /></div>
          </td>
        
          <td>
            <div runat="server" id="divPrograms" visible="false" class="inputformsectionheader">Coverage</div>
            <asp:DataGrid ID="dgvServiceTypes" AutoGenerateColumns="false" style="width: 100%" runat="server" Cssclass="Grid1">
              <AlternatingItemStyle CssClass="altrow" />
              <HeaderStyle CssClass="gridheader" />
              <Columns>
                <asp:BoundColumn HeaderText="County" DataField="CountyName"  />
                <asp:BoundColumn HeaderText="HVAC" DataField="HVAC"  />
                <asp:BoundColumn HeaderText="ApplianceRepair" DataField="ApplianceRepair"  />
                <asp:BoundColumn HeaderText="TVRepair" DataField="TVRepair"  />
                <asp:BoundColumn HeaderText="CentralAC" DataField="CentralAC"  />
              </Columns>      
            </asp:DataGrid>
           </td>
         </tr>
      </table>
      
    </asp:View>
    <asp:View ID="Adds"  runat="server">
    
    </asp:View>
  </asp:MultiView> 
  </form>
</asp:Content>