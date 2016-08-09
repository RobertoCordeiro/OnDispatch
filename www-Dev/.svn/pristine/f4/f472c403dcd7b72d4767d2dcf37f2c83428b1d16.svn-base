Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class VendorRecord
        ' Methods
        Public Sub New()
            Me._VendorID = 0
            Me._CreatedBy = 0
            Me._EntityTypeID = 0
            Me._VendorTypeID = 0
            Me._Company = ""
            Me._FirstName = ""
            Me._MiddleName = ""
            Me._LastName = ""
            Me._WebSite = ""
            Me._Active = True
            Me._DateCreated = New DateTime
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._VendorID = 0
            Me._CreatedBy = 0
            Me._EntityTypeID = 0
            Me._VendorTypeID = 0
            Me._Company = ""
            Me._FirstName = ""
            Me._MiddleName = ""
            Me._LastName = ""
            Me._WebSite = ""
            Me._Active = True
            Me._DateCreated = New DateTime
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngVendorID As Long, ByVal strConnectionString As String)
            Me._VendorID = 0
            Me._CreatedBy = 0
            Me._EntityTypeID = 0
            Me._VendorTypeID = 0
            Me._Company = ""
            Me._FirstName = ""
            Me._MiddleName = ""
            Me._LastName = ""
            Me._WebSite = ""
            Me._Active = True
            Me._DateCreated = New DateTime
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._VendorID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal lngEntityTypeID As Long, ByVal lngVendorTypeID As Long, ByVal strCompany As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddVendor")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngVendorID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@EntityTypeID", SqlDbType.Int).Value = lngEntityTypeID
                cmd.Parameters.Add("@VendorTypeID", SqlDbType.Int).Value = lngVendorTypeID
                cmd.Parameters.Add("@Company", SqlDbType.VarChar, Me.TrimTrunc(strCompany, &H80).Length).Value = Me.TrimTrunc(strCompany, &H80)
                cnn.Open
                cmd.Connection = cnn
                lngVendorID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngVendorID > 0) Then
                    Me.Load(lngVendorID)
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
            Me._VendorID = 0
            Me._CreatedBy = 0
            Me._EntityTypeID = 0
            Me._VendorTypeID = 0
            Me._Company = ""
            Me._FirstName = ""
            Me._MiddleName = ""
            Me._LastName = ""
            Me._WebSite = ""
            Me._Active = True
            Me._DateCreated = New DateTime
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveVendor")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@VendorID", SqlDbType.Int).Value = Me._VendorID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._VendorID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New VendorRecord(Me._VendorID, Me._ConnectionString)
            If (obj.EntityTypeID <> Me._EntityTypeID) Then
                blnReturn = True
            End If
            If (obj.VendorTypeID <> Me._VendorTypeID) Then
                blnReturn = True
            End If
            If (obj.Company <> Me._Company) Then
                blnReturn = True
            End If
            If (obj.FirstName <> Me._FirstName) Then
                blnReturn = True
            End If
            If (obj.MiddleName <> Me._MiddleName) Then
                blnReturn = True
            End If
            If (obj.LastName <> Me._LastName) Then
                blnReturn = True
            End If
            If (obj.WebSite <> Me._WebSite) Then
                blnReturn = True
            End If
            If (obj.Active <> Me._Active) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngVendorID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetVendor")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@VendorID", SqlDbType.Int).Value = lngVendorID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._VendorID = Conversions.ToLong(dtr.Item("VendorID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._EntityTypeID = Conversions.ToLong(dtr.Item("EntityTypeID"))
                    Me._VendorTypeID = Conversions.ToLong(dtr.Item("VendorTypeID"))
                    Me._Company = dtr.Item("Company").ToString
                    Me._FirstName = dtr.Item("FirstName").ToString
                    Me._MiddleName = dtr.Item("MiddleName").ToString
                    Me._LastName = dtr.Item("LastName").ToString
                    Me._WebSite = dtr.Item("WebSite").ToString
                    Me._Active = Conversions.ToBoolean(dtr.Item("Active"))
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
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
                Dim obj As New VendorRecord(Me._VendorID, Me._ConnectionString)
                If (obj.EntityTypeID <> Me._EntityTypeID) Then
                    Me.UpdateEntityTypeID(Me._EntityTypeID, (cnn))
                    strTemp = String.Concat(New String() { "EntityTypeID Changed to '", Conversions.ToString(Me._EntityTypeID), "' from '", Conversions.ToString(obj.EntityTypeID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.VendorTypeID <> Me._VendorTypeID) Then
                    Me.UpdateVendorTypeID(Me._VendorTypeID, (cnn))
                    strTemp = String.Concat(New String() { "VendorTypeID Changed to '", Conversions.ToString(Me._VendorTypeID), "' from '", Conversions.ToString(obj.VendorTypeID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Company <> Me._Company) Then
                    Me.UpdateCompany(Me._Company, (cnn))
                    strTemp = String.Concat(New String() { "Company Changed to '", Me._Company, "' from '", obj.Company, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.FirstName <> Me._FirstName) Then
                    Me.UpdateFirstName(Me._FirstName, (cnn))
                    strTemp = String.Concat(New String() { "FirstName Changed to '", Me._FirstName, "' from '", obj.FirstName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.MiddleName <> Me._MiddleName) Then
                    Me.UpdateMiddleName(Me._MiddleName, (cnn))
                    strTemp = String.Concat(New String() { "MiddleName Changed to '", Me._MiddleName, "' from '", obj.MiddleName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.LastName <> Me._LastName) Then
                    Me.UpdateLastName(Me._LastName, (cnn))
                    strTemp = String.Concat(New String() { "LastName Changed to '", Me._LastName, "' from '", obj.LastName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.WebSite <> Me._WebSite) Then
                    Me.UpdateWebSite(Me._WebSite, (cnn))
                    strTemp = String.Concat(New String() { "WebSite Changed to '", Me._WebSite, "' from '", obj.WebSite, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Active <> Me._Active) Then
                    Me.UpdateActive(Me._Active, (cnn))
                    strTemp = String.Concat(New String() { "Active Changed to '", Conversions.ToString(Me._Active), "' from '", Conversions.ToString(obj.Active), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._VendorID)
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

        Private Sub UpdateActive(ByVal NewActive As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateVendorActive")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@VendorID", SqlDbType.Int).Value = Me._VendorID
            cmd.Parameters.Add("@Active", SqlDbType.Bit).Value = NewActive
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCompany(ByVal NewCompany As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateVendorCompany")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@VendorID", SqlDbType.Int).Value = Me._VendorID
            cmd.Parameters.Add("@Company", SqlDbType.VarChar, Me.TrimTrunc(NewCompany, &H80).Length).Value = Me.TrimTrunc(NewCompany, &H80)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateEntityTypeID(ByVal NewEntityTypeID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateVendorEntityTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@VendorID", SqlDbType.Int).Value = Me._VendorID
            cmd.Parameters.Add("@EntityTypeID", SqlDbType.Int).Value = NewEntityTypeID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateFirstName(ByVal NewFirstName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateVendorFirstName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@VendorID", SqlDbType.Int).Value = Me._VendorID
            If (NewFirstName.Trim.Length > 0) Then
                cmd.Parameters.Add("@FirstName", SqlDbType.VarChar, Me.TrimTrunc(NewFirstName, &H20).Length).Value = Me.TrimTrunc(NewFirstName, &H20)
            Else
                cmd.Parameters.Add("@FirstName", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateLastName(ByVal NewLastName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateVendorLastName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@VendorID", SqlDbType.Int).Value = Me._VendorID
            If (NewLastName.Trim.Length > 0) Then
                cmd.Parameters.Add("@LastName", SqlDbType.VarChar, Me.TrimTrunc(NewLastName, &H40).Length).Value = Me.TrimTrunc(NewLastName, &H40)
            Else
                cmd.Parameters.Add("@LastName", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateMiddleName(ByVal NewMiddleName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateVendorMiddleName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@VendorID", SqlDbType.Int).Value = Me._VendorID
            If (NewMiddleName.Trim.Length > 0) Then
                cmd.Parameters.Add("@MiddleName", SqlDbType.VarChar, Me.TrimTrunc(NewMiddleName, &H20).Length).Value = Me.TrimTrunc(NewMiddleName, &H20)
            Else
                cmd.Parameters.Add("@MiddleName", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateVendorTypeID(ByVal NewVendorTypeID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateVendorVendorTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@VendorID", SqlDbType.Int).Value = Me._VendorID
            cmd.Parameters.Add("@VendorTypeID", SqlDbType.Int).Value = NewVendorTypeID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateWebSite(ByVal NewWebSite As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateVendorWebSite")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@VendorID", SqlDbType.Int).Value = Me._VendorID
            If (NewWebSite.Trim.Length > 0) Then
                cmd.Parameters.Add("@WebSite", SqlDbType.VarChar, Me.TrimTrunc(NewWebSite, &HFF).Length).Value = Me.TrimTrunc(NewWebSite, &HFF)
            Else
                cmd.Parameters.Add("@WebSite", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub


        ' Properties
        Public Property Active As Boolean
            Get
                Return Me._Active
            End Get
            Set(ByVal value As Boolean)
                Me._Active = value
            End Set
        End Property

        Public Property Company As String
            Get
                Return Me._Company
            End Get
            Set(ByVal value As String)
                Me._Company = Me.TrimTrunc(value, &H80)
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

        Public ReadOnly Property DateCreated As DateTime
            Get
                Return Me._DateCreated
            End Get
        End Property

        Public Property EntityTypeID As Long
            Get
                Return Me._EntityTypeID
            End Get
            Set(ByVal value As Long)
                Me._EntityTypeID = value
            End Set
        End Property

        Public Property FirstName As String
            Get
                Return Me._FirstName
            End Get
            Set(ByVal value As String)
                Me._FirstName = Me.TrimTrunc(value, &H20)
            End Set
        End Property

        Public Property LastName As String
            Get
                Return Me._LastName
            End Get
            Set(ByVal value As String)
                Me._LastName = Me.TrimTrunc(value, &H40)
            End Set
        End Property

        Public Property MiddleName As String
            Get
                Return Me._MiddleName
            End Get
            Set(ByVal value As String)
                Me._MiddleName = Me.TrimTrunc(value, &H20)
            End Set
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public ReadOnly Property VendorID As Long
            Get
                Return Me._VendorID
            End Get
        End Property

        Public Property VendorTypeID As Long
            Get
                Return Me._VendorTypeID
            End Get
            Set(ByVal value As Long)
                Me._VendorTypeID = value
            End Set
        End Property

        Public Property WebSite As String
            Get
                Return Me._WebSite
            End Get
            Set(ByVal value As String)
                Me._WebSite = Me.TrimTrunc(value, &HFF)
            End Set
        End Property


        ' Fields
        Private _Active As Boolean
        Private _Company As String
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _EntityTypeID As Long
        Private _FirstName As String
        Private _LastName As String
        Private _MiddleName As String
        Private _VendorID As Long
        Private _VendorTypeID As Long
        Private _WebSite As String
        Private Const CompanyMaxLength As Integer = &H80
        Private Const FirstNameMaxLength As Integer = &H20
        Private Const LastNameMaxLength As Integer = &H40
        Private Const MiddleNameMaxLength As Integer = &H20
        Private Const WebSiteMaxLength As Integer = &HFF
    End Class
End Namespace

