Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class CustomerAgentServiceTypeRecord
        ' Methods
        Public Sub New()
            Me._CustomerAgentServiceTypeID = 0
            Me._CreatedBy = 0
            Me._CustomerAgentID = 0
            Me._ServiceTypeID = 0
            Me._AdminAccess = False
            Me._ReadOnlyAccess = False
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._CustomerAgentServiceTypeID = 0
            Me._CreatedBy = 0
            Me._CustomerAgentID = 0
            Me._ServiceTypeID = 0
            Me._AdminAccess = False
            Me._ReadOnlyAccess = False
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngCustomerAgentServiceTypeID As Long, ByVal strConnectionString As String)
            Me._CustomerAgentServiceTypeID = 0
            Me._CreatedBy = 0
            Me._CustomerAgentID = 0
            Me._ServiceTypeID = 0
            Me._AdminAccess = False
            Me._ReadOnlyAccess = False
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._CustomerAgentServiceTypeID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal lngCustomerAgentID As Long, ByVal lngServiceTypeID As Long, ByVal blnAdminAccess As Boolean, ByVal blnReadOnlyAccess As Boolean)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddCustomerAgentServiceType")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngCustomerAgentServiceTypeID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@CustomerAgentID", SqlDbType.Int).Value = lngCustomerAgentID
                cmd.Parameters.Add("@ServiceTypeID", SqlDbType.Int).Value = lngServiceTypeID
                cmd.Parameters.Add("@AdminAccess", SqlDbType.Bit).Value = blnAdminAccess
                cmd.Parameters.Add("@ReadOnlyAccess", SqlDbType.Bit).Value = blnReadOnlyAccess
                cnn.Open
                cmd.Connection = cnn
                lngCustomerAgentServiceTypeID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngCustomerAgentServiceTypeID > 0) Then
                    Me.Load(lngCustomerAgentServiceTypeID)
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
            Me._CustomerAgentServiceTypeID = 0
            Me._CreatedBy = 0
            Me._CustomerAgentID = 0
            Me._ServiceTypeID = 0
            Me._AdminAccess = False
            Me._ReadOnlyAccess = False
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveCustomerAgentServiceType")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CustomerAgentServiceTypeID", SqlDbType.Int).Value = Me._CustomerAgentServiceTypeID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._CustomerAgentServiceTypeID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New CustomerAgentServiceTypeRecord(Me._CustomerAgentServiceTypeID, Me._ConnectionString)
            obj.Load(Me._CustomerAgentServiceTypeID)
            If (obj.CustomerAgentID <> Me._CustomerAgentID) Then
                blnReturn = True
            End If
            If (obj.ServiceTypeID <> Me._ServiceTypeID) Then
                blnReturn = True
            End If
            If (obj.AdminAccess <> Me._AdminAccess) Then
                blnReturn = True
            End If
            If (obj.ReadOnlyAccess <> Me._ReadOnlyAccess) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngCustomerAgentServiceTypeID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetCustomerAgentServiceType")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CustomerAgentServiceTypeID", SqlDbType.Int).Value = lngCustomerAgentServiceTypeID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._CustomerAgentServiceTypeID = Conversions.ToLong(dtr.Item("CustomerAgentServiceTypeID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._CustomerAgentID = Conversions.ToLong(dtr.Item("CustomerAgentID"))
                    Me._ServiceTypeID = Conversions.ToLong(dtr.Item("ServiceTypeID"))
                    Me._AdminAccess = Conversions.ToBoolean(dtr.Item("AdminAccess"))
                    Me._ReadOnlyAccess = Conversions.ToBoolean(dtr.Item("ReadOnlyAccess"))
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
                Dim obj As New CustomerAgentServiceTypeRecord(Me._CustomerAgentServiceTypeID, Me._ConnectionString)
                obj.Load(Me._CustomerAgentServiceTypeID)
                If (obj.CustomerAgentID <> Me._CustomerAgentID) Then
                    Me.UpdateCustomerAgentID(Me._CustomerAgentID, (cnn))
                    strTemp = String.Concat(New String() { "CustomerAgentID Changed to '", Conversions.ToString(Me._CustomerAgentID), "' from '", Conversions.ToString(obj.CustomerAgentID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ServiceTypeID <> Me._ServiceTypeID) Then
                    Me.UpdateServiceTypeID(Me._ServiceTypeID, (cnn))
                    strTemp = String.Concat(New String() { "ServiceTypeID Changed to '", Conversions.ToString(Me._ServiceTypeID), "' from '", Conversions.ToString(obj.ServiceTypeID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.AdminAccess <> Me._AdminAccess) Then
                    Me.UpdateAdminAccess(Me._AdminAccess, (cnn))
                    strTemp = String.Concat(New String() { "AdminAccess Changed to '", Conversions.ToString(Me._AdminAccess), "' from '", Conversions.ToString(obj.AdminAccess), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ReadOnlyAccess <> Me._ReadOnlyAccess) Then
                    Me.UpdateReadOnlyAccess(Me._ReadOnlyAccess, (cnn))
                    strTemp = String.Concat(New String() { "ReadOnlyAccess Changed to '", Conversions.ToString(Me._ReadOnlyAccess), "' from '", Conversions.ToString(obj.ReadOnlyAccess), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._CustomerAgentServiceTypeID)
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

        Private Sub UpdateAdminAccess(ByVal NewAdminAccess As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerAgentServiceTypeAdminAccess")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerAgentServiceTypeID", SqlDbType.Int).Value = Me._CustomerAgentServiceTypeID
            cmd.Parameters.Add("@AdminAccess", SqlDbType.Bit).Value = NewAdminAccess
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCustomerAgentID(ByVal NewCustomerAgentID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerAgentServiceTypeCustomerAgentID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerAgentServiceTypeID", SqlDbType.Int).Value = Me._CustomerAgentServiceTypeID
            cmd.Parameters.Add("@CustomerAgentID", SqlDbType.Int).Value = NewCustomerAgentID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateReadOnlyAccess(ByVal NewReadOnlyAccess As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerAgentServiceTypeReadOnlyAccess")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerAgentServiceTypeID", SqlDbType.Int).Value = Me._CustomerAgentServiceTypeID
            cmd.Parameters.Add("@ReadOnlyAccess", SqlDbType.Bit).Value = NewReadOnlyAccess
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateServiceTypeID(ByVal NewServiceTypeID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerAgentServiceTypeServiceTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerAgentServiceTypeID", SqlDbType.Int).Value = Me._CustomerAgentServiceTypeID
            cmd.Parameters.Add("@ServiceTypeID", SqlDbType.Int).Value = NewServiceTypeID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub


        ' Properties
        Public Property AdminAccess As Boolean
            Get
                Return Me._AdminAccess
            End Get
            Set(ByVal value As Boolean)
                Me._AdminAccess = value
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

        Public Property CustomerAgentID As Long
            Get
                Return Me._CustomerAgentID
            End Get
            Set(ByVal value As Long)
                Me._CustomerAgentID = value
            End Set
        End Property

        Public ReadOnly Property CustomerAgentServiceTypeID As Long
            Get
                Return Me._CustomerAgentServiceTypeID
            End Get
        End Property

        Public ReadOnly Property DateCreated As DateTime
            Get
                Return Me._DateCreated
            End Get
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public Property ReadOnlyAccess As Boolean
            Get
                Return Me._ReadOnlyAccess
            End Get
            Set(ByVal value As Boolean)
                Me._ReadOnlyAccess = value
            End Set
        End Property

        Public Property ServiceTypeID As Long
            Get
                Return Me._ServiceTypeID
            End Get
            Set(ByVal value As Long)
                Me._ServiceTypeID = value
            End Set
        End Property


        ' Fields
        Private _AdminAccess As Boolean
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _CustomerAgentID As Long
        Private _CustomerAgentServiceTypeID As Long
        Private _DateCreated As DateTime
        Private _ReadOnlyAccess As Boolean
        Private _ServiceTypeID As Long
    End Class
End Namespace

