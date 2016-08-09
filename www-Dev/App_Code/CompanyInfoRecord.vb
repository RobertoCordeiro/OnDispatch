Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class CompanyInfoRecord
        ' Methods
        Public Sub New()
            Me._InfoID = 0
            Me._CreatedBy = 0
            Me._InvoiceStateID = 0
            Me._CompanyName = ""
            Me._InvoiceStreet = ""
            Me._InvoiceExtended = ""
            Me._InvoiceCity = ""
            Me._InvoiceZipCode = ""
            Me._InvoicePhone = ""
            Me._DataFileRootFolder = ""
            Me._ConnectionString = ""
            Me._DateCreated = New DateTime
            Me._OpticalModuleEnabled = False
            Me._ServiceModuleEnabled = False
            Me._ProductModuleEnabled = False
            Me._CustomerID = 0
            Me._PartnerID = 0
            Me._CountryID = 0
            Me._AdminUserId = 0
            Me._WebUserID = 0
            Me._UserID = 0
            Me._AuthorizeLogin = ""
            Me._AuthorizeKey = ""
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._InfoID = 0
            Me._CreatedBy = 0
            Me._InvoiceStateID = 0
            Me._CompanyName = ""
            Me._InvoiceStreet = ""
            Me._InvoiceExtended = ""
            Me._InvoiceCity = ""
            Me._InvoiceZipCode = ""
            Me._InvoicePhone = ""
            Me._DataFileRootFolder = ""
            Me._ConnectionString = ""
            Me._DateCreated = New DateTime
            Me._OpticalModuleEnabled = False
            Me._ServiceModuleEnabled = False
            Me._ProductModuleEnabled = False
            Me._CustomerID = 0
            Me._PartnerID = 0
            Me._CountryID = 0
            Me._AdminUserId = 0
            Me._WebUserID = 0
            Me._UserID = 0
            Me._AuthorizeLogin = ""
            Me._AuthorizeKey = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngInfoID As Long, ByVal strConnectionString As String)
            Me._InfoID = 0
            Me._CreatedBy = 0
            Me._InvoiceStateID = 0
            Me._CompanyName = ""
            Me._InvoiceStreet = ""
            Me._InvoiceExtended = ""
            Me._InvoiceCity = ""
            Me._InvoiceZipCode = ""
            Me._InvoicePhone = ""
            Me._DataFileRootFolder = ""
            Me._ConnectionString = ""
            Me._DateCreated = New DateTime
            Me._OpticalModuleEnabled = False
            Me._ServiceModuleEnabled = False
            Me._ProductModuleEnabled = False
            Me._CustomerID = 0
            Me._PartnerID = 0
            Me._CountryID = 0
            Me._AdminUserId = 0
            Me._WebUserID = 0
            Me._UserID = 0
            Me._AuthorizeLogin = ""
            Me._AuthorizeKey = ""
            Me._ConnectionString = strConnectionString
            Me.Load(lngInfoID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal lngInvoiceStateID As Long, ByVal strCompanyName As String, ByVal strInvoiceStreet As String, ByVal strInvoiceExtended As String, ByVal strInvoiceCity As String, ByVal strInvoiceZipCode As String, ByVal strInvoicePhone As String, ByVal blnOpticalModuleEnabled As Boolean, ByVal blnServiceModuleEnabled As Boolean, ByVal blnProductModuleEnabled As Boolean, ByVal datDateCreated As Date, ByVal lngCustomerID As Long, ByVal lngPartnerID As Long, ByVal lngCountryID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spAddCompanyInfo")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngInfoID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@InvoiceStateID", SqlDbType.Int).Value = lngInvoiceStateID
                cmd.Parameters.Add("@CompanyName", SqlDbType.VarChar, TrimTrunc(strCompanyName, CompanyNameMaxLength).Length).Value = TrimTrunc(strCompanyName, CompanyNameMaxLength)
                cmd.Parameters.Add("@InvoiceStreet", SqlDbType.VarChar, TrimTrunc(strInvoiceStreet, InvoiceStreetMaxLength).Length).Value = TrimTrunc(strInvoiceStreet, InvoiceStreetMaxLength)
                cmd.Parameters.Add("@InvoiceExtended", SqlDbType.VarChar, TrimTrunc(strInvoiceExtended, InvoiceExtendedMaxLength).Length).Value = TrimTrunc(strInvoiceExtended, InvoiceExtendedMaxLength)
                cmd.Parameters.Add("@InvoiceCity", SqlDbType.VarChar, TrimTrunc(strInvoiceCity, InvoiceCityMaxLength).Length).Value = TrimTrunc(strInvoiceCity, InvoiceCityMaxLength)
                cmd.Parameters.Add("@InvoiceZipCode", SqlDbType.VarChar, TrimTrunc(strInvoiceZipCode, InvoiceZipCodeMaxLength).Length).Value = TrimTrunc(strInvoiceZipCode, InvoiceZipCodeMaxLength)
                cmd.Parameters.Add("@InvoicePhone", SqlDbType.VarChar, TrimTrunc(strInvoicePhone, InvoicePhoneMaxLength).Length).Value = TrimTrunc(strInvoicePhone, InvoicePhoneMaxLength)
                cmd.Parameters.Add("@OpticalModuleEnabled", SqlDbType.Bit).Value = blnOpticalModuleEnabled
                cmd.Parameters.Add("@ServiceModuleEnabled", SqlDbType.Bit).Value = blnServiceModuleEnabled
                cmd.Parameters.Add("@ProductModuleEnabled", SqlDbType.Bit).Value = blnProductModuleEnabled
                cmd.Parameters.Add("@DateCreated", SqlDbType.DateTime).Value = datDateCreated
                cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = lngCustomerID
                cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = lngPartnerID
                cmd.Parameters.Add("@CountryID", SqlDbType.Int).Value = lngCountryID
                cnn.Open()
                cmd.Connection = cnn
                lngInfoID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngInfoID > 0 Then
                    Load(lngInfoID)
                End If
            End If
        End Sub

        Private Sub AppendChangeLog(ByRef strLog As String, ByVal strNewLine As String)
            Dim strReturn As String = ""
            If (strLog.Length > 0) Then
                strReturn = (strLog & Environment.NewLine)
            End If
            strReturn = (strReturn & strNewLine)
            strLog = strReturn
        End Sub

        Private Sub ClearValues()
            Me._InfoID = 0
            Me._CreatedBy = 0
            Me._InvoiceStateID = 0
            Me._CompanyName = ""
            Me._InvoiceStreet = ""
            Me._InvoiceExtended = ""
            Me._InvoiceCity = ""
            Me._InvoiceZipCode = ""
            Me._InvoicePhone = ""
            Me._DataFileRootFolder = ""
            Me._DateCreated = New DateTime
            Me._CustomerID = 0
            Me._PartnerID = 0
            Me._CountryID = 0
            Me._AdminUserId = 0
            Me._WebUserID = 0
            Me._UserID = 0
            Me._AuthorizeLogin = ""
            Me._AuthorizeKey = ""
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cir As New CompanyInfoRecord(Me._InfoID, Me._ConnectionString)
                If (cir.InvoiceStateID <> Me._InvoiceStateID) Then
                    blnReturn = True
                End If
                If (cir.CompanyName <> Me._CompanyName) Then
                    blnReturn = True
                End If
                If (cir.InvoiceStreet <> Me._InvoiceStreet) Then
                    blnReturn = True
                End If
                If (cir.InvoiceExtended <> Me._InvoiceExtended) Then
                    blnReturn = True
                End If
                If (cir.InvoiceCity <> Me._InvoiceCity) Then
                    blnReturn = True
                End If
                If (cir.InvoiceZipCode <> Me._InvoiceZipCode) Then
                    blnReturn = True
                End If
                If (cir.InvoicePhone <> Me._InvoicePhone) Then
                    blnReturn = True
                End If
                If (cir.DataFileRootFolder <> Me._DataFileRootFolder) Then
                    blnReturn = True
                End If
                If (cir.OpticalModuleEnabled <> Me._OpticalModuleEnabled) Then
                    blnReturn = True
                End If
                If (cir.ServiceModuleEnabled <> Me._ServiceModuleEnabled) Then
                    blnReturn = True
                End If
                If (cir.ProductModuleEnabled <> Me._ProductModuleEnabled) Then
                    blnReturn = True
                End If
                If (cir.CustomerID <> Me._CustomerID) Then
                    blnReturn = True
                End If
                If (cir.PartnerID <> Me._PartnerID) Then
                    blnReturn = True
                End If
                If (cir.CountryID <> Me._CountryID) Then
                    blnReturn = True
                End If
                If (cir.AdminUserID <> Me._AdminUserId) Then
                    blnReturn = True
                End If
                If (cir.WebUserID <> Me._WebUserID) Then
                    blnReturn = True
                End If
                If (cir.UserID <> Me._UserID) Then
                    blnReturn = True
                End If
                If (cir.AuthorizeLogin <> Me._AuthorizeLogin) Then
                    blnReturn = True
                End If
                If (cir.AuthorizeKey <> Me._AuthorizeKey) Then
                    blnReturn = True
                End If
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngInfoID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetCompanyInfo")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@InfoID", SqlDbType.Int).Value = lngInfoID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._InfoID = Conversions.ToLong(dtr.Item("InfoID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Try 
                        Me._InvoiceStateID = Conversions.ToLong(dtr.Item("InvoiceStateID"))
                    Catch exception1 As Exception
                        ProjectData.SetProjectError(exception1)
                        Dim ex As Exception = exception1
                        Me._InvoiceStateID = 0
                        ProjectData.ClearProjectError
                    End Try
                    Me._CompanyName = dtr.Item("CompanyName").ToString
                    Me._InvoiceStreet = dtr.Item("InvoiceStreet").ToString
                    Me._InvoiceExtended = dtr.Item("InvoiceExtended").ToString
                    Me._InvoiceCity = dtr.Item("InvoiceCity").ToString
                    Me._InvoiceZipCode = dtr.Item("InvoiceZipCode").ToString
                    Me._InvoicePhone = dtr.Item("InvoicePhone").ToString
                    Me._DataFileRootFolder = dtr.Item("DataFileRootFolder").ToString
                    Me._OpticalModuleEnabled = Conversions.ToBoolean(dtr.Item("OpticalModuleEnabled"))
                    Me._ServiceModuleEnabled = Conversions.ToBoolean(dtr.Item("ServiceModuleEnabled"))
                    Me._ProductModuleEnabled = Conversions.ToBoolean(dtr.Item("ProductModuleEnabled"))
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                    Me._CustomerID = dtr.Item("CustomerID").ToString
                    Me._PartnerID = dtr.Item("PartnerID").ToString
                    Me._CountryID = dtr.Item("CountryID").ToString
                    If Not IsDBNull(dtr("AdminUserID")) Then
                        _AdminUserId = CType(dtr("AdminUserID"), Long)
                    Else
                        _AdminUserId = 0
                    End If
                    If Not IsDBNull(dtr("WebUserID")) Then
                        _WebUserID = CType(dtr("WebUserID"), Long)
                    Else
                        _WebUserID = 0
                    End If
                    If Not IsDBNull(dtr("UserID")) Then
                        _UserID = CType(dtr("UserID"), Long)
                    Else
                        _UserID = 0
                    End If
                Else
                    Me.ClearValues
                End If
                cnn.Close
            End If
        End Sub

        Public Sub Save(ByRef strChangeLog As String)
            strChangeLog = ""
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim strTemp As String = ""
                Dim cnn As New SqlConnection(Me._ConnectionString)
                cnn.Open
                Dim cir As New CompanyInfoRecord(Me._InfoID, Me._ConnectionString)
                If (cir.InvoiceStateID <> Me._InvoiceStateID) Then
                    Me.UpdateInvoiceStateID(Me._InvoiceStateID, (cnn))
                    strTemp = ("Changed InvoiceStateID from " & Conversions.ToString(cir.InvoiceStateID) & " to " & Me._InvoiceStateID.ToString)
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (cir.CompanyName <> Me._CompanyName) Then
                    Me.UpdateCompanyName(Me._CompanyName, (cnn))
                    strTemp = String.Concat(New String() { "Changed Company Name from '", cir.CompanyName, "' to '", Me._CompanyName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (cir.InvoiceStreet <> Me._InvoiceStreet) Then
                    Me.UpdateInvoiceStreet(Me._InvoiceStreet, (cnn))
                    strTemp = String.Concat(New String() { "Changed Invoice Street from '", cir.InvoiceStreet, "' to '", Me._InvoiceStreet, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (cir.InvoiceExtended <> Me._InvoiceExtended) Then
                    Me.UpdateInvoiceExtended(Me._InvoiceExtended, (cnn))
                    strTemp = String.Concat(New String() { "Changed Invoice Extended from '", cir.InvoiceExtended, "' to '", Me._InvoiceExtended, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (cir.InvoiceCity <> Me._InvoiceCity) Then
                    Me.UpdateInvoiceCity(Me._InvoiceCity, (cnn))
                    strTemp = String.Concat(New String() { "Changed Invoice City from '", cir.InvoiceCity, "' to '", Me._InvoiceCity, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (cir.InvoiceZipCode <> Me._InvoiceZipCode) Then
                    Me.UpdateInvoiceZipCode(Me._InvoiceZipCode, (cnn))
                    strTemp = String.Concat(New String() { "Changed Invoice ZipCode from '", cir.InvoiceZipCode, "' to '", Me._InvoiceZipCode, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (cir.InvoicePhone <> Me._InvoicePhone) Then
                    Me.UpdateInvoicePhone(Me._InvoicePhone, (cnn))
                    strTemp = String.Concat(New String() { "Changed Invoice Phone from '", cir.InvoicePhone, "' to '", Me._InvoicePhone, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (cir.DataFileRootFolder <> Me._DataFileRootFolder) Then
                    Me.UpdateDataFileRootFolder(Me._DataFileRootFolder, (cnn))
                    strTemp = String.Concat(New String() { "Changed Data File Root Folder from '", cir.DataFileRootFolder, "' to '", Me._DataFileRootFolder, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (cir.OpticalModuleEnabled <> Me._OpticalModuleEnabled) Then
                    Me.UpdateOpticalModuleEnabled(Me._OpticalModuleEnabled, (cnn))
                    strTemp = String.Concat(New String() { "Changed Optical Module Enabled from '", cir.OpticalModuleEnabled.ToString, "' to '", Me._OpticalModuleEnabled.ToString, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (cir.ServiceModuleEnabled <> Me._ServiceModuleEnabled) Then
                    Me.UpdateServiceModuleEnabled(Me._ServiceModuleEnabled, (cnn))
                    strTemp = String.Concat(New String() { "Changed Service Module Enabled from '", cir.ServiceModuleEnabled.ToString, "' to '", Me._ServiceModuleEnabled.ToString, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (cir.ProductModuleEnabled <> Me._ProductModuleEnabled) Then
                    Me.UpdateProductModuleEnabled(Me._ProductModuleEnabled, (cnn))
                    strTemp = String.Concat(New String() { "Changed Product Module Enabled from '", cir.ProductModuleEnabled.ToString, "' to '", Me._ProductModuleEnabled.ToString, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (cir.CustomerID <> Me._CustomerID) Then
                    Me.UpdateCustomerID(Me._CustomerID, (cnn))
                    strTemp = ("Changed CustomerID from " & Conversions.ToString(cir.CustomerID) & " to " & Me._CustomerID.ToString)
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (cir.PartnerID <> Me._PartnerID) Then
                    Me.UpdatePartnerID(Me._PartnerID, (cnn))
                    strTemp = ("Changed PartnerID from " & Conversions.ToString(cir.PartnerID) & " to " & Me._PartnerID.ToString)
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (cir.CountryID <> Me._CountryID) Then
                    Me.UpdateCountryID(Me._CountryID, (cnn))
                    strTemp = ("Changed CountryID from " & Conversions.ToString(cir.CountryID) & " to " & Me._CountryID.ToString)
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If cir.AdminUserID <> Me._AdminUserId Then
                    Me.UpdateAdminUserID(Me._AdminUserId, cnn)
                    strTemp = "AdminUserID Changed to '" & Me._AdminUserId & "' from '" & cir.AdminUserID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If cir.WebUserID <> Me._WebUserID Then
                    Me.UpdateWebUserID(Me._WebUserID, cnn)
                    strTemp = "WebUserID Changed to '" & Me._WebUserID & "' from '" & cir.WebUserID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If cir.UserID <> Me._UserID Then
                    Me.UpdateUserID(Me._UserID, cnn)
                    strTemp = "UserID Changed to '" & Me._UserID & "' from '" & cir.UserID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If cir.AuthorizeLogin <> Me._AuthorizeLogin Then
                    Me.UpdateAuthorizeLogin(Me._AuthorizeLogin, cnn)
                    strTemp = "AuthorizeLogin Changed to '" & Me._AuthorizeLogin & "' from '" & cir.AuthorizeLogin & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If cir.AuthorizeKey <> Me._AuthorizeKey Then
                    Me.UpdateAuthorizeKey(Me._AuthorizeKey, cnn)
                    strTemp = "AuthorizeKey Changed to '" & Me._AuthorizeKey & "' from '" & cir.AuthorizeKey & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If

                cnn.Close
                Me.Load(Me._InfoID)
            Else
                Me.ClearValues
            End If
        End Sub

        Private Function TrimTrunc(ByVal strInput As String, ByVal intMaxLength As Integer) As String
            Dim strReturn As String = strInput
            If (strReturn.Trim.Length <= intMaxLength) Then
                Return strReturn.Trim
            End If
            Return strReturn.Substring(0, intMaxLength).Trim
        End Function

        Private Sub UpdateCompanyName(ByVal NewCompanyName As String, ByRef cnn As SqlConnection)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cmd As New SqlCommand("spUpdateCompanyInfoCompanyName")
                Dim strCompanyName As String = Me.TrimTrunc(NewCompanyName, &H80)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@InfoID", SqlDbType.Int).Value = Me._InfoID
                If (strCompanyName.Trim.Length > 0) Then
                    cmd.Parameters.Add("@CompanyName", SqlDbType.VarChar, strCompanyName.Length).Value = strCompanyName
                End If
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
            End If
        End Sub

        Private Sub UpdateDataFileRootFolder(ByVal NewDataFileRootFolder As String, ByRef cnn As SqlConnection)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cmd As New SqlCommand("spUpdateCompanyInfoDataFileRootFolder")
                Dim strDataFileRootFolder As String = Me.TrimTrunc(NewDataFileRootFolder, &HFF)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@InfoID", SqlDbType.Int).Value = Me._InfoID
                If (strDataFileRootFolder.Trim.Length > 0) Then
                    cmd.Parameters.Add("@DataFileRootFolder", SqlDbType.VarChar, strDataFileRootFolder.Length).Value = strDataFileRootFolder
                Else
                    cmd.Parameters.Add("@DataFileRootFolder", SqlDbType.VarChar).Value = DBNull.Value
                End If
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
            End If
        End Sub

        Private Sub UpdateInvoiceCity(ByVal NewInvoiceCity As String, ByRef cnn As SqlConnection)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cmd As New SqlCommand("spUpdateCompanyInfoInvoiceCity")
                Dim strInvoiceCity As String = Me.TrimTrunc(NewInvoiceCity, &H80)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@InfoID", SqlDbType.Int).Value = Me._InfoID
                If (strInvoiceCity.Trim.Length > 0) Then
                    cmd.Parameters.Add("@InvoiceCity", SqlDbType.VarChar, strInvoiceCity.Length).Value = strInvoiceCity
                Else
                    cmd.Parameters.Add("@InvoiceCity", SqlDbType.VarChar).Value = DBNull.Value
                End If
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
            End If
        End Sub

        Private Sub UpdateInvoiceExtended(ByVal NewInvoiceExtended As String, ByRef cnn As SqlConnection)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cmd As New SqlCommand("spUpdateCompanyInfoInvoiceExtended")
                Dim strInvoiceExtended As String = Me.TrimTrunc(NewInvoiceExtended, &HFF)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@InfoID", SqlDbType.Int).Value = Me._InfoID
                If (strInvoiceExtended.Trim.Length > 0) Then
                    cmd.Parameters.Add("@InvoiceExtended", SqlDbType.VarChar, strInvoiceExtended.Length).Value = strInvoiceExtended
                Else
                    cmd.Parameters.Add("@InvoiceExtended", SqlDbType.VarChar).Value = DBNull.Value
                End If
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
            End If
        End Sub

        Private Sub UpdateInvoicePhone(ByVal NewInvoicePhone As String, ByRef cnn As SqlConnection)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cmd As New SqlCommand("spUpdateCompanyInfoInvoicePhone")
                Dim strInvoicePhone As String = Me.TrimTrunc(NewInvoicePhone, &H20)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@InfoID", SqlDbType.Int).Value = Me._InfoID
                If (strInvoicePhone.Trim.Length > 0) Then
                    cmd.Parameters.Add("@InvoicePhone", SqlDbType.VarChar, strInvoicePhone.Length).Value = strInvoicePhone
                Else
                    cmd.Parameters.Add("@InvoicePhone", SqlDbType.VarChar).Value = DBNull.Value
                End If
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
            End If
        End Sub

        Private Sub UpdateInvoiceStateID(ByVal NewInvoiceStateID As Long, ByRef cnn As SqlConnection)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cmd As New SqlCommand("spUpdateCompanyInfoInvoiceStateID")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@InfoID", SqlDbType.Int).Value = Me._InfoID
                If (NewInvoiceStateID > 0) Then
                    cmd.Parameters.Add("@InvoiceStateID", SqlDbType.Int).Value = NewInvoiceStateID
                Else
                    cmd.Parameters.Add("@InvoiceStateID", SqlDbType.Int).Value = DBNull.Value
                End If
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
            End If
        End Sub

        Private Sub UpdateInvoiceStreet(ByVal NewInvoiceStreet As String, ByRef cnn As SqlConnection)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cmd As New SqlCommand("spUpdateCompanyInfoInvoiceStreet")
                Dim strInvoiceStreet As String = Me.TrimTrunc(NewInvoiceStreet, &HFF)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@InfoID", SqlDbType.Int).Value = Me._InfoID
                If (strInvoiceStreet.Trim.Length > 0) Then
                    cmd.Parameters.Add("@InvoiceStreet", SqlDbType.VarChar, strInvoiceStreet.Length).Value = strInvoiceStreet
                Else
                    cmd.Parameters.Add("@InvoiceStreet", SqlDbType.VarChar).Value = DBNull.Value
                End If
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
            End If
        End Sub

        Private Sub UpdateInvoiceZipCode(ByVal NewInvoiceZipCode As String, ByRef cnn As SqlConnection)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cmd As New SqlCommand("spUpdateCompanyInfoInvoiceZipCode")
                Dim strInvoiceZipCode As String = Me.TrimTrunc(NewInvoiceZipCode, &H10)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@InfoID", SqlDbType.Int).Value = Me._InfoID
                If (strInvoiceZipCode.Trim.Length > 0) Then
                    cmd.Parameters.Add("@InvoiceZipCode", SqlDbType.VarChar, strInvoiceZipCode.Length).Value = strInvoiceZipCode
                Else
                    cmd.Parameters.Add("@InvoiceZipCode", SqlDbType.VarChar).Value = DBNull.Value
                End If
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
            End If
        End Sub

        Private Sub UpdateOpticalModuleEnabled(ByVal NewOpticalModuleEnabled As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCompanyInfoOpticalModuleEnabled")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InfoID", SqlDbType.Int).Value = Me._InfoID
            cmd.Parameters.Add("@OpticalModuleEnabled", SqlDbType.Bit).Value = NewOpticalModuleEnabled
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateProductModuleEnabled(ByVal NewProductModuleEnabled As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCompanyInfoProductModuleEnabled")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InfoID", SqlDbType.Int).Value = Me._InfoID
            cmd.Parameters.Add("@ProductModuleEnabled", SqlDbType.Bit).Value = NewProductModuleEnabled
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateServiceModuleEnabled(ByVal NewServiceModuleEnabled As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCompanyInfoServiceModuleEnabled")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InfoID", SqlDbType.Int).Value = Me._InfoID
            cmd.Parameters.Add("@ServiceModuleEnabled", SqlDbType.Bit).Value = NewServiceModuleEnabled
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub
        Private Sub UpdateCustomerID(ByVal NewCustomerID As Long, ByRef cnn As SqlConnection)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cmd As New SqlCommand("spUpdateCompanyInfoCustomerID")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@InfoID", SqlDbType.Int).Value = Me._InfoID
                cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = NewCustomerID
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
            End If
        End Sub
        Private Sub UpdatePartnerID(ByVal NewPartnerID As Long, ByRef cnn As SqlConnection)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cmd As New SqlCommand("spUpdateCompanyInfoPartnerID")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@InfoID", SqlDbType.Int).Value = Me._InfoID
                cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = NewPartnerID
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
            End If
        End Sub
        Private Sub UpdateCountryID(ByVal NewCountryID As Long, ByRef cnn As SqlConnection)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cmd As New SqlCommand("spUpdateCompanyInfoCountryID")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@InfoID", SqlDbType.Int).Value = Me._InfoID
                cmd.Parameters.Add("@CountryID", SqlDbType.Int).Value = NewCountryID
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
            End If
        End Sub

        Private Sub UpdateAdminUserID(ByVal NewAdminUserID As Long, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateCompanyInfoAdminUserID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@InfoID", sqlDBType.int).value = _InfoID
            If NewAdminUserID > 0 Then
                cmd.Parameters.Add("@AdminUserID", SqlDbType.int).value = NewAdminUserID
            Else
                cmd.Parameters.Add("@AdminUserID", SqlDbType.int).Value = System.DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdateWebUserID(ByVal NewWebUserID As Long, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New SqlClient.SqlCommand("spUpdateCompanyInfoWebUserID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InfoID", SqlDbType.Int).Value = _InfoID
            If NewWebUserID > 0 Then
                cmd.Parameters.Add("@WebUserID", SqlDbType.Int).Value = NewWebUserID
            Else
                cmd.Parameters.Add("@WebUserID", SqlDbType.Int).Value = System.DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdateUserID(ByVal NewUserID As Long, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New SqlClient.SqlCommand("spUpdateCompanyInfoUserID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InfoID", SqlDbType.Int).Value = _InfoID
            If NewUserID > 0 Then
                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = NewUserID
            Else
                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = System.DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdateAuthorizeLogin(ByVal NewAuthorizeLogin As String, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New SqlClient.SqlCommand("spUpdateCompanyInfoAuthorizeLogin")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InfoID", SqlDbType.Int).Value = _InfoID
            If NewAuthorizeLogin.Trim.Length > 0 Then
                cmd.Parameters.Add("@AuthorizeLogin", SqlDbType.NVarChar, TrimTrunc(NewAuthorizeLogin, AuthorizeLoginMaxLength).Length).Value = TrimTrunc(NewAuthorizeLogin, AuthorizeLoginMaxLength)
            Else
                cmd.Parameters.Add("@AuthorizeLogin", SqlDbType.NVarChar).Value = System.DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdateAuthorizeKey(ByVal NewAuthorizeKey As String, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New SqlClient.SqlCommand("spUpdateCompanyInfoAuthorizeKey")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InfoID", SqlDbType.Int).Value = _InfoID
            If NewAuthorizeKey.Trim.Length > 0 Then
                cmd.Parameters.Add("@AuthorizeKey", SqlDbType.NVarChar, TrimTrunc(NewAuthorizeKey, AuthorizeKeyMaxLength).Length).value = TrimTrunc(NewAuthorizeKey, AuthorizeKeyMaxLength)
            Else
                cmd.Parameters.Add("@AuthorizeKey", SqlDbType.NVarChar).Value = System.DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub


        ' Properties
        Public Property CompanyName As String
            Get
                Return Me._CompanyName.Trim
            End Get
            Set(ByVal value As String)
                Me._CompanyName = Me.TrimTrunc(value, &H80)
            End Set
        End Property

        Public Property ConnectionString As String
            Get
                Return Me._ConnectionString
            End Get
            Set(ByVal value As String)
                Me._ConnectionString = value
            End Set
        End Property

        Public ReadOnly Property CreatedBy As Long
            Get
                Return Me._CreatedBy
            End Get
        End Property

        Public Property DataFileRootFolder As String
            Get
                Return Me._DataFileRootFolder
            End Get
            Set(ByVal value As String)
                Me._DataFileRootFolder = Me.TrimTrunc(value, &HFF)
            End Set
        End Property

        Public ReadOnly Property DateCreated As DateTime
            Get
                Return Me._DateCreated
            End Get
        End Property

        Public ReadOnly Property InfoID As Long
            Get
                Return Me._InfoID
            End Get
        End Property

        Public Property InvoiceCity As String
            Get
                Return Me._InvoiceCity
            End Get
            Set(ByVal value As String)
                Me._InvoiceCity = Me.TrimTrunc(value, &H80)
            End Set
        End Property

        Public Property InvoiceExtended As String
            Get
                Return Me._InvoiceExtended
            End Get
            Set(ByVal value As String)
                Me._InvoiceExtended = Me.TrimTrunc(value, &HFF)
            End Set
        End Property

        Public Property InvoicePhone As String
            Get
                Return Me._InvoicePhone
            End Get
            Set(ByVal value As String)
                Me._InvoicePhone = Me.TrimTrunc(value, &H20)
            End Set
        End Property

        Public Property InvoiceStateID As Long
            Get
                Return Me._InvoiceStateID
            End Get
            Set(ByVal value As Long)
                Me._InvoiceStateID = value
            End Set
        End Property

        Public Property InvoiceStreet As String
            Get
                Return Me._InvoiceStreet
            End Get
            Set(ByVal value As String)
                Me._InvoiceStreet = Me.TrimTrunc(value.Trim, &HFF)
            End Set
        End Property

        Public Property InvoiceZipCode As String
            Get
                Return Me._InvoiceZipCode
            End Get
            Set(ByVal value As String)
                Me._InvoiceZipCode = Me.TrimTrunc(value, &H10)
            End Set
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public Property OpticalModuleEnabled As Boolean
            Get
                Return Me._OpticalModuleEnabled
            End Get
            Set(ByVal value As Boolean)
                Me._OpticalModuleEnabled = value
            End Set
        End Property

        Public Property ProductModuleEnabled As Boolean
            Get
                Return Me._ProductModuleEnabled
            End Get
            Set(ByVal value As Boolean)
                Me._ProductModuleEnabled = value
            End Set
        End Property

        Public Property ServiceModuleEnabled As Boolean
            Get
                Return Me._ServiceModuleEnabled
            End Get
            Set(ByVal value As Boolean)
                Me._ServiceModuleEnabled = value
            End Set
        End Property
        Public Property CustomerID() As Long
            Get
                Return Me._CustomerID
            End Get
            Set(ByVal value As Long)
                Me._CustomerID = value
            End Set
        End Property
        Public Property PartnerID() As Long
            Get
                Return Me._PartnerID
            End Get
            Set(ByVal value As Long)
                Me._PartnerID = value
            End Set
        End Property
        Public Property CountryID() As Long
            Get
                Return Me._CountryID
            End Get
            Set(ByVal value As Long)
                Me._CountryID = value
            End Set
        End Property
        Public Property AdminUserID() As Long
            Get
                Return Me._AdminUserId
            End Get
            Set(ByVal value As Long)
                Me._AdminUserId = value
            End Set
        End Property
        Public Property WebUserID() As Long
            Get
                Return Me._WebUserID
            End Get
            Set(ByVal value As Long)
                Me._WebUserID = value
            End Set
        End Property
        Public Property UserID() As Long
            Get
                Return Me._UserID
            End Get
            Set(ByVal value As Long)
                Me._UserID = value
            End Set
        End Property
        Public Property AuthorizeLogin As String
            Get
                Return Me._AuthorizeLogin
            End Get
            Set(ByVal value As String)
                Me._AuthorizeLogin = Me.TrimTrunc(value, AuthorizeLoginMaxLength)
            End Set
        End Property
        Public Property AuthorizeKey As String
            Get
                Return Me._AuthorizeKey
            End Get
            Set(ByVal value As String)
                Me._AuthorizeKey = Me.TrimTrunc(value, AuthorizeKeyMaxLength)
            End Set
        End Property

        ' Fields
        Private _CompanyName As String
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DataFileRootFolder As String
        Private _DateCreated As DateTime
        Private _InfoID As Long
        Private _InvoiceCity As String
        Private _InvoiceExtended As String
        Private _InvoicePhone As String
        Private _InvoiceStateID As Long
        Private _InvoiceStreet As String
        Private _InvoiceZipCode As String
        Private _OpticalModuleEnabled As Boolean
        Private _ProductModuleEnabled As Boolean
        Private _ServiceModuleEnabled As Boolean
        Private _CustomerID As Long
        Private _PartnerID As Long
        Private _CountryID As Long
        Private _AdminUserId As Long
        Private _WebUserID As Long
        Private _UserID As Long
        Private _AuthorizeLogin As String
        Private _AuthorizeKey As String
        Private Const CompanyNameMaxLength As Integer = &H80
        Private Const DataFileRootFolderMaxLength As Integer = &HFF
        Private Const InvoiceCityMaxLength As Integer = &H80
        Private Const InvoiceExtendedMaxLength As Integer = &HFF
        Private Const InvoicePhoneMaxLength As Integer = &H20
        Private Const InvoiceStreetMaxLength As Integer = &HFF
        Private Const InvoiceZipCodeMaxLength As Integer = &H10
        Private Const AuthorizeLoginMaxLength As Integer = 30
        Private Const AuthorizeKeyMaxLength As Integer = 50
    End Class
End Namespace

