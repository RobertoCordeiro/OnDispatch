Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class RoleRecord
        ' Methods
        Public Sub New()
            Me._RoleID = 0
            Me._CreatedBy = 0
            Me._RoleName = ""
            Me._EditAutoFills = False
            Me._EditTypes = False
            Me._EditUsers = False
            Me._EditRoles = False
            Me._EditCustomers = False
            Me._EditCompanyInfo = False
            Me._ViewInvoiceReport = False
            Me._EditCouriers = False
            Me._DateCreated = New DateTime
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._RoleID = 0
            Me._CreatedBy = 0
            Me._RoleName = ""
            Me._EditAutoFills = False
            Me._EditTypes = False
            Me._EditUsers = False
            Me._EditRoles = False
            Me._EditCustomers = False
            Me._EditCompanyInfo = False
            Me._ViewInvoiceReport = False
            Me._EditCouriers = False
            Me._DateCreated = New DateTime
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngRoleID As Long, ByVal strConnectionString As String)
            Me._RoleID = 0
            Me._CreatedBy = 0
            Me._RoleName = ""
            Me._EditAutoFills = False
            Me._EditTypes = False
            Me._EditUsers = False
            Me._EditRoles = False
            Me._EditCustomers = False
            Me._EditCompanyInfo = False
            Me._ViewInvoiceReport = False
            Me._EditCouriers = False
            Me._DateCreated = New DateTime
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(lngRoleID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal strRoleName As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddRole")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngRoleID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@RoleName", SqlDbType.VarChar, Me.TrimTrunc(strRoleName, &H20).Length).Value = Me.TrimTrunc(strRoleName, &H20)
                cnn.Open
                cmd.Connection = cnn
                lngRoleID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngRoleID > 0) Then
                    Me.Load(lngRoleID)
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
            Me._RoleID = 0
            Me._CreatedBy = 0
            Me._RoleName = ""
            Me._EditAutoFills = False
            Me._EditTypes = False
            Me._EditUsers = False
            Me._EditRoles = False
            Me._EditCompanyInfo = False
            Me._ViewInvoiceReport = False
            Me._EditCustomers = False
            Me._DateCreated = New DateTime
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveRole")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@RoleID", SqlDbType.Int).Value = Me._RoleID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._RoleID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New RoleRecord(Me._RoleID, Me._ConnectionString)
            If (obj.RoleName <> Me._RoleName) Then
                blnReturn = True
            End If
            If (obj.EditCompanyInfo <> Me._EditCompanyInfo) Then
                blnReturn = True
            End If
            If (obj.EditAutoFills <> Me._EditAutoFills) Then
                blnReturn = True
            End If
            If (obj.EditTypes <> Me._EditTypes) Then
                blnReturn = True
            End If
            If (obj.EditUsers <> Me._EditUsers) Then
                blnReturn = True
            End If
            If (obj.EditRoles <> Me._EditRoles) Then
                blnReturn = True
            End If
            If (obj.EditCustomers <> Me._EditCustomers) Then
                blnReturn = True
            End If
            If (obj.EditCouriers <> Me._EditCouriers) Then
                blnReturn = True
            End If
            If (DateTime.Compare(obj.DateCreated, Me._DateCreated) <> 0) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngRoleID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetRole")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@RoleID", SqlDbType.Int).Value = lngRoleID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._RoleID = Conversions.ToLong(dtr.Item("RoleID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._RoleName = dtr.Item("RoleName").ToString
                    Me._EditAutoFills = Conversions.ToBoolean(dtr.Item("EditAutoFills"))
                    Me._EditTypes = Conversions.ToBoolean(dtr.Item("EditTypes"))
                    Me._EditUsers = Conversions.ToBoolean(dtr.Item("EditUsers"))
                    Me._EditRoles = Conversions.ToBoolean(dtr.Item("EditRoles"))
                    Me._EditCouriers = Conversions.ToBoolean(dtr.Item("EditCouriers"))
                    Me._EditCompanyInfo = Conversions.ToBoolean(dtr.Item("EditCompanyInfo"))
                    Me._EditCustomers = Conversions.ToBoolean(dtr.Item("EditCustomers"))
                    Me._ViewInvoiceReport = Conversions.ToBoolean(dtr.Item("ViewInvoiceReport"))
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
                Dim obj As New RoleRecord(Me._RoleID, Me._ConnectionString)
                If (obj.RoleName <> Me._RoleName) Then
                    Me.UpdateRoleName(Me._RoleName, (cnn))
                    strTemp = String.Concat(New String() { "RoleName Changed from '", Me._RoleName, "' to '", obj.RoleName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.EditAutoFills <> Me._EditAutoFills) Then
                    Me.UpdateEditAutoFills(Me._EditAutoFills, (cnn))
                    strTemp = String.Concat(New String() { "EditAutoFills Changed to '", Conversions.ToString(Me._EditAutoFills), "' from '", Conversions.ToString(obj.EditAutoFills), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.EditTypes <> Me._EditTypes) Then
                    Me.UpdateEditTypes(Me._EditTypes, (cnn))
                    strTemp = String.Concat(New String() { "EditTypes Changed to '", Conversions.ToString(Me._EditTypes), "' from '", Conversions.ToString(obj.EditTypes), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.EditUsers <> Me._EditUsers) Then
                    Me.UpdateEditUsers(Me._EditUsers, (cnn))
                    strTemp = String.Concat(New String() { "EditUsers Changed to '", Conversions.ToString(Me._EditUsers), "' from '", Conversions.ToString(obj.EditUsers), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.EditRoles <> Me._EditRoles) Then
                    Me.UpdateEditRoles(Me._EditRoles, (cnn))
                    strTemp = String.Concat(New String() { "EditRoles Changed to '", Conversions.ToString(Me._EditRoles), "' from '", Conversions.ToString(obj.EditRoles), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.EditCustomers <> Me._EditCustomers) Then
                    Me.UpdateEditCustomers(Me._EditCustomers, (cnn))
                    strTemp = String.Concat(New String() { "EditCustomers Changed to '", Conversions.ToString(Me._EditCustomers), "' from '", Conversions.ToString(obj.EditCustomers), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.EditCompanyInfo <> Me._EditCompanyInfo) Then
                    Me.UpdateEditCompanyInfo(Me._EditCompanyInfo, (cnn))
                    strTemp = String.Concat(New String() { "EditCompanyInfo Changed to '", Conversions.ToString(Me._EditCompanyInfo), "' from '", Conversions.ToString(obj.EditCompanyInfo), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ViewInvoiceReport <> Me._ViewInvoiceReport) Then
                    Me.UpdateViewInvoiceReport(Me._ViewInvoiceReport, (cnn))
                    strTemp = ("ViewInvoiceReport Changed to '" & Conversions.ToString(Me._ViewInvoiceReport) & "' from '" & Conversions.ToString(obj.ViewInvoiceReport))
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.EditCouriers <> Me._EditCouriers) Then
                    Me.UpdateEditCouriers(Me._EditCouriers, (cnn))
                    strTemp = String.Concat(New String() { "EditCouriers Changed to '", Conversions.ToString(Me._EditCouriers), "' from '", Conversions.ToString(obj.EditCouriers), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._RoleID)
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

        Private Sub UpdateDateCreated(ByVal NewDateCreated As DateTime, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateRoleDateCreated")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@RoleID", SqlDbType.Int).Value = Me._RoleID
            cmd.Parameters.Add("@DateCreated", SqlDbType.DateTime).Value = NewDateCreated
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateEditAutoFills(ByVal NewEditAutoFills As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateRoleEditAutoFills")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@RoleID", SqlDbType.Int).Value = Me._RoleID
            cmd.Parameters.Add("@EditAutoFills", SqlDbType.Bit).Value = NewEditAutoFills
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateEditCompanyInfo(ByVal NewEditCompanyInfo As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateRoleEditCompanyInfo")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@RoleID", SqlDbType.Int).Value = Me._RoleID
            cmd.Parameters.Add("@EditCompanyInfo", SqlDbType.Bit).Value = NewEditCompanyInfo
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateEditCouriers(ByVal NewEditCouriers As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateRoleEditCouriers")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@RoleID", SqlDbType.Int).Value = Me._RoleID
            cmd.Parameters.Add("@EditCouriers", SqlDbType.Bit).Value = NewEditCouriers
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateEditCustomers(ByVal NewEditCustomers As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateRoleEditCustomers")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@RoleID", SqlDbType.Int).Value = Me._RoleID
            cmd.Parameters.Add("@EditCustomers", SqlDbType.Bit).Value = NewEditCustomers
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateEditRoles(ByVal NewEditRoles As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateRoleEditRoles")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@RoleID", SqlDbType.Int).Value = Me._RoleID
            cmd.Parameters.Add("@EditRoles", SqlDbType.Bit).Value = NewEditRoles
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateEditTypes(ByVal NewEditTypes As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateRoleEditTypes")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@RoleID", SqlDbType.Int).Value = Me._RoleID
            cmd.Parameters.Add("@EditTypes", SqlDbType.Bit).Value = NewEditTypes
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateEditUsers(ByVal NewEditUsers As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateRoleEditUsers")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@RoleID", SqlDbType.Int).Value = Me._RoleID
            cmd.Parameters.Add("@EditUsers", SqlDbType.Bit).Value = NewEditUsers
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateRoleName(ByVal NewRoleName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateRoleRoleName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@RoleID", SqlDbType.Int).Value = Me._RoleID
            cmd.Parameters.Add("@RoleName", SqlDbType.VarChar, Me.TrimTrunc(NewRoleName, &H20).Length).Value = Me.TrimTrunc(NewRoleName, &H20)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateViewInvoiceReport(ByVal NewViewInvoiceReport As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateRoleViewInvoiceReport")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@RoleID", SqlDbType.Int).Value = Me._RoleID
            cmd.Parameters.Add("@ViewInvoiceReport", SqlDbType.Bit).Value = NewViewInvoiceReport
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub


        ' Properties
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

        Public Property DateCreated As DateTime
            Get
                Return Me._DateCreated
            End Get
            Set(ByVal value As DateTime)
                Me._DateCreated = value
            End Set
        End Property

        Public Property EditAutoFills As Boolean
            Get
                Return Me._EditAutoFills
            End Get
            Set(ByVal value As Boolean)
                Me._EditAutoFills = value
            End Set
        End Property

        Public Property EditCompanyInfo As Boolean
            Get
                Return Me._EditCompanyInfo
            End Get
            Set(ByVal value As Boolean)
                Me._EditCompanyInfo = value
            End Set
        End Property

        Public Property EditCouriers As Boolean
            Get
                Return Me._EditCouriers
            End Get
            Set(ByVal value As Boolean)
                Me._EditCouriers = value
            End Set
        End Property

        Public Property EditCustomers As Boolean
            Get
                Return Me._EditCustomers
            End Get
            Set(ByVal value As Boolean)
                Me._EditCustomers = value
            End Set
        End Property

        Public Property EditRoles As Boolean
            Get
                Return Me._EditRoles
            End Get
            Set(ByVal value As Boolean)
                Me._EditRoles = value
            End Set
        End Property

        Public Property EditTypes As Boolean
            Get
                Return Me._EditTypes
            End Get
            Set(ByVal value As Boolean)
                Me._EditTypes = value
            End Set
        End Property

        Public Property EditUsers As Boolean
            Get
                Return Me._EditUsers
            End Get
            Set(ByVal value As Boolean)
                Me._EditUsers = value
            End Set
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public ReadOnly Property RoleID As Long
            Get
                Return Me._RoleID
            End Get
        End Property

        Public Property RoleName As String
            Get
                Return Me._RoleName
            End Get
            Set(ByVal value As String)
                Me._RoleName = Me.TrimTrunc(value, &H20)
            End Set
        End Property

        Public Property ViewInvoiceReport As Boolean
            Get
                Return Me._ViewInvoiceReport
            End Get
            Set(ByVal value As Boolean)
                Me._ViewInvoiceReport = value
            End Set
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _EditAutoFills As Boolean
        Private _EditCompanyInfo As Boolean
        Private _EditCouriers As Boolean
        Private _EditCustomers As Boolean
        Private _EditRoles As Boolean
        Private _EditTypes As Boolean
        Private _EditUsers As Boolean
        Private _RoleID As Long
        Private _RoleName As String
        Private _ViewInvoiceReport As Boolean
        Private Const RoleNameMaxLength As Integer = &H20
    End Class
End Namespace

