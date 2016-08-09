Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class CustomerAgentRecord
        ' Methods
        Public Sub New()
            Me._CustomerAgentID = 0
            Me._CustomerID = 0
            Me._AgentTypeID = 0
            Me._CreatedBy = 0
            Me._WebLoginID = 0
            Me._FirstName = ""
            Me._MiddleName = ""
            Me._LastName = ""
            Me._Email = ""
            Me._AdminAgent = False
            Me._Active = False
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._CustomerAgentID = 0
            Me._CustomerID = 0
            Me._AgentTypeID = 0
            Me._CreatedBy = 0
            Me._WebLoginID = 0
            Me._FirstName = ""
            Me._MiddleName = ""
            Me._LastName = ""
            Me._Email = ""
            Me._AdminAgent = False
            Me._Active = False
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngCustomerAgentID As Long, ByVal strConnectionString As String)
            Me._CustomerAgentID = 0
            Me._CustomerID = 0
            Me._AgentTypeID = 0
            Me._CreatedBy = 0
            Me._WebLoginID = 0
            Me._FirstName = ""
            Me._MiddleName = ""
            Me._LastName = ""
            Me._Email = ""
            Me._AdminAgent = False
            Me._Active = False
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._CustomerAgentID)
        End Sub

        Public Sub Add(ByVal lngCustomerID As Long, ByVal lngAgentTypeID As Long, ByVal lngCreatedBy As Long, ByVal strFirstName As String, ByVal strLastName As String, ByVal blnAdminAgent As Boolean)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddCustomerAgent")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngCustomerAgentID As Long = 0
                cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = lngCustomerID
                cmd.Parameters.Add("@AgentTypeID", SqlDbType.Int).Value = lngAgentTypeID
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@FirstName", SqlDbType.VarChar, Me.TrimTrunc(strFirstName, &H20).Length).Value = Me.TrimTrunc(strFirstName, &H20)
                cmd.Parameters.Add("@LastName", SqlDbType.VarChar, Me.TrimTrunc(strLastName, &H40).Length).Value = Me.TrimTrunc(strLastName, &H40)
                cmd.Parameters.Add("@AdminAgent", SqlDbType.Bit).Value = blnAdminAgent
                cnn.Open
                cmd.Connection = cnn
                lngCustomerAgentID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngCustomerAgentID > 0) Then
                    Me.Load(lngCustomerAgentID)
                End If
            End If
        End Sub

        Private Function AddableAssignedServiceTypesCount() As Long
            Dim lngReturn As Long = 0
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spCountCustomerAgentAddableServiceTypes")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CustomerAgentID", SqlDbType.Int).Value = Me._CustomerAgentID
                cnn.Open
                cmd.Connection = cnn
                Try 
                    lngReturn = Conversions.ToLong(cmd.ExecuteScalar)
                Catch exception1 As Exception
                    ProjectData.SetProjectError(exception1)
                    Dim ex As Exception = exception1
                    lngReturn = 0
                    ProjectData.ClearProjectError
                End Try
                cnn.Close
                Return lngReturn
            End If
            Return 0
        End Function

        Private Sub AppendChangeLog(ByRef strLog As String, ByVal strNewLine As String)
            Dim strReturn As String = ""
            If (strLog.Length > 0) Then
                strReturn = (strLog & Environment.NewLine)
            End If
            strReturn = (strReturn & strNewLine)
            strLog = strReturn
        End Sub

        Private Function AssignedServiceTypesCount() As Long
            Dim lngReturn As Long = 0
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spCountCustomerAgentServiceTypes")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CustomerAgentID", SqlDbType.Int).Value = Me._CustomerAgentID
                cnn.Open
                cmd.Connection = cnn
                Try 
                    lngReturn = Conversions.ToLong(cmd.ExecuteScalar)
                Catch exception1 As Exception
                    ProjectData.SetProjectError(exception1)
                    Dim ex As Exception = exception1
                    lngReturn = 0
                    ProjectData.ClearProjectError
                End Try
                cnn.Close
                Return lngReturn
            End If
            Return 0
        End Function

        Public Function AssignedToServiceType(ByVal ServiceTypeID As Long) As Boolean
            Dim blnReturn As Boolean = False
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetServiceTypeForCustomerAgent")
                cmd.Parameters.Add("@CustomerAgentID", SqlDbType.Int).Value = Me._CustomerAgentID
                cmd.Parameters.Add("@ServiceTypeID", SqlDbType.Int).Value = ServiceTypeID
                cmd.CommandType = CommandType.StoredProcedure
                cnn.Open
                cmd.Connection = cnn
                If cmd.ExecuteReader.Read Then
                    blnReturn = True
                Else
                    blnReturn = False
                End If
                cnn.Close
                cmd.Dispose
            End If
            Return blnReturn
        End Function

        Private Sub ClearValues()
            Me._CustomerAgentID = 0
            Me._CustomerID = 0
            Me._AgentTypeID = 0
            Me._CreatedBy = 0
            Me._WebLoginID = 0
            Me._FirstName = ""
            Me._MiddleName = ""
            Me._LastName = ""
            Me._Email = ""
            Me._AdminAgent = False
            Me._Active = False
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveCustomerAgent")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CustomerAgentID", SqlDbType.Int).Value = Me._CustomerAgentID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._CustomerAgentID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New CustomerAgentRecord(Me._CustomerAgentID, Me._ConnectionString)
            obj.Load(Me._CustomerAgentID)
            If (obj.AgentTypeID <> Me._AgentTypeID) Then
                blnReturn = True
            End If
            If (obj.WebLoginID <> Me._WebLoginID) Then
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
            If (obj.Email <> Me._Email) Then
                blnReturn = True
            End If
            If (obj.AdminAgent <> Me._AdminAgent) Then
                blnReturn = True
            End If
            If (obj.Active <> Me._Active) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngCustomerAgentID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetCustomerAgent")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CustomerAgentID", SqlDbType.Int).Value = lngCustomerAgentID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._CustomerAgentID = Conversions.ToLong(dtr.Item("CustomerAgentID"))
                    Me._CustomerID = Conversions.ToLong(dtr.Item("CustomerID"))
                    Me._AgentTypeID = Conversions.ToLong(dtr.Item("AgentTypeID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("WebLoginID"))) Then
                        Me._WebLoginID = Conversions.ToLong(dtr.Item("WebLoginID"))
                    Else
                        Me._WebLoginID = 0
                    End If
                    Me._FirstName = dtr.Item("FirstName").ToString
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("MiddleName"))) Then
                        Me._MiddleName = dtr.Item("MiddleName").ToString
                    Else
                        Me._MiddleName = ""
                    End If
                    Me._LastName = dtr.Item("LastName").ToString
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Email"))) Then
                        Me._Email = dtr.Item("Email").ToString
                    Else
                        Me._Email = ""
                    End If
                    Me._AdminAgent = Conversions.ToBoolean(dtr.Item("AdminAgent"))
                    Me._Active = Conversions.ToBoolean(dtr.Item("Active"))
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                Else
                    Me.ClearValues
                End If
                cnn.Close
            End If
        End Sub

        Public Sub LoadByWebLoginID(ByVal lngWebLoginID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetCustomerAgentIDByWebLoginID")
                Dim lngId As Long = 0
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@WebLoginID", SqlDbType.Int).Value = lngWebLoginID
                cnn.Open
                cmd.Connection = cnn
                lngId = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngId > 0) Then
                    Me.Load(lngId)
                Else
                    Me.ClearValues
                End If
                cmd.Dispose
            End If
        End Sub

        Public Sub Save(ByRef strChangeLog As String)
            strChangeLog = ""
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim strTemp As String = ""
                Dim cnn As New SqlConnection(Me._ConnectionString)
                cnn.Open
                Dim obj As New CustomerAgentRecord(Me._CustomerAgentID, Me._ConnectionString)
                obj.Load(Me._CustomerAgentID)
                If (obj.AgentTypeID <> Me._AgentTypeID) Then
                    Me.UpdateAgentTypeID(Me._AgentTypeID, (cnn))
                    strTemp = String.Concat(New String() { "AgentTypeID Changed to '", Conversions.ToString(Me._AgentTypeID), "' from '", Conversions.ToString(obj.AgentTypeID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.WebLoginID <> Me._WebLoginID) Then
                    Me.UpdateWebLoginID(Me._WebLoginID, (cnn))
                    strTemp = String.Concat(New String() { "WebLoginID Changed to '", Conversions.ToString(Me._WebLoginID), "' from '", Conversions.ToString(obj.WebLoginID), "'" })
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
                If (obj.Email <> Me._Email) Then
                    Me.UpdateEmail(Me._Email, (cnn))
                    strTemp = String.Concat(New String() { "Email Changed to '", Me._Email, "' from '", obj.Email, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.AdminAgent <> Me._AdminAgent) Then
                    Me.UpdateAdminAgent(Me._AdminAgent, (cnn))
                    strTemp = String.Concat(New String() { "AdminAgent Changed to '", Conversions.ToString(Me._AdminAgent), "' from '", Conversions.ToString(obj.AdminAgent), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Active <> Me._Active) Then
                    Me.UpdateActive(Me._Active, (cnn))
                    strTemp = String.Concat(New String() { "Active Changed to '", Conversions.ToString(Me._Active), "' from '", Conversions.ToString(obj.Active), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._CustomerAgentID)
            Else
                Me.ClearValues
            End If
        End Sub

        Public Function ServiceTypeAdmin(ByVal ServiceTypeID As Long) As Boolean
            Dim blnReturn As Boolean = False
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetServiceTypeForCustomerAgent")
                cmd.Parameters.Add("@CustomerAgentID", SqlDbType.Int).Value = Me._CustomerAgentID
                cmd.Parameters.Add("@ServiceTypeID", SqlDbType.Int).Value = ServiceTypeID
                cmd.CommandType = CommandType.StoredProcedure
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    blnReturn = Conversions.ToBoolean(dtr.Item("AdminAccess"))
                Else
                    blnReturn = False
                End If
                cnn.Close
                cmd.Dispose
            End If
            Return blnReturn
        End Function

        Public Function ServiceTypeReadOnly(ByVal ServiceTypeID As Long) As Boolean
            Dim blnReturn As Boolean = True
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetServiceTypeForCustomerAgent")
                cmd.Parameters.Add("@CustomerAgentID", SqlDbType.Int).Value = Me._CustomerAgentID
                cmd.Parameters.Add("@ServiceTypeID", SqlDbType.Int).Value = ServiceTypeID
                cmd.CommandType = CommandType.StoredProcedure
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    blnReturn = Conversions.ToBoolean(dtr.Item("ReadOnlyAccess"))
                Else
                    blnReturn = True
                End If
                cnn.Close
                cmd.Dispose
            End If
            Return blnReturn
        End Function

        Private Function TrimTrunc(ByVal strInput As String, ByVal intMaxLength As Integer) As String
            Dim strReturn As String = strInput
            If (strReturn.Trim.Length <= intMaxLength) Then
                Return strReturn.Trim
            End If
            Return strReturn.Substring(0, intMaxLength).Trim
        End Function

        Private Sub UpdateActive(ByVal NewActive As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerAgentActive")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerAgentID", SqlDbType.Int).Value = Me._CustomerAgentID
            cmd.Parameters.Add("@Active", SqlDbType.Bit).Value = NewActive
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateAdminAgent(ByVal NewAdminAgent As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerAgentAdminAgent")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerAgentID", SqlDbType.Int).Value = Me._CustomerAgentID
            cmd.Parameters.Add("@AdminAgent", SqlDbType.Bit).Value = NewAdminAgent
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateAgentTypeID(ByVal NewAgentTypeID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerAgentAgentTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerAgentID", SqlDbType.Int).Value = Me._CustomerAgentID
            cmd.Parameters.Add("@AgentTypeID", SqlDbType.Int).Value = NewAgentTypeID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateEmail(ByVal NewEmail As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerAgentEmail")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerAgentID", SqlDbType.Int).Value = Me._CustomerAgentID
            If (NewEmail.Trim.Length > 0) Then
                cmd.Parameters.Add("@Email", SqlDbType.VarChar, Me.TrimTrunc(NewEmail, &HFF).Length).Value = Me.TrimTrunc(NewEmail, &HFF)
            Else
                cmd.Parameters.Add("@Email", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateFirstName(ByVal NewFirstName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerAgentFirstName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerAgentID", SqlDbType.Int).Value = Me._CustomerAgentID
            cmd.Parameters.Add("@FirstName", SqlDbType.VarChar, Me.TrimTrunc(NewFirstName, &H20).Length).Value = Me.TrimTrunc(NewFirstName, &H20)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateLastName(ByVal NewLastName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerAgentLastName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerAgentID", SqlDbType.Int).Value = Me._CustomerAgentID
            cmd.Parameters.Add("@LastName", SqlDbType.VarChar, Me.TrimTrunc(NewLastName, &H40).Length).Value = Me.TrimTrunc(NewLastName, &H40)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateMiddleName(ByVal NewMiddleName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerAgentMiddleName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerAgentID", SqlDbType.Int).Value = Me._CustomerAgentID
            If (NewMiddleName.Trim.Length > 0) Then
                cmd.Parameters.Add("@MiddleName", SqlDbType.VarChar, Me.TrimTrunc(NewMiddleName, &H20).Length).Value = Me.TrimTrunc(NewMiddleName, &H20)
            Else
                cmd.Parameters.Add("@MiddleName", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateWebLoginID(ByVal NewWebLoginID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerAgentWebLoginID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerAgentID", SqlDbType.Int).Value = Me._CustomerAgentID
            If (NewWebLoginID > 0) Then
                cmd.Parameters.Add("@WebLoginID", SqlDbType.Int).Value = NewWebLoginID
            Else
                cmd.Parameters.Add("@WebLoginID", SqlDbType.Int).Value = DBNull.Value
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

        Public ReadOnly Property AddAbleServiceTypeCount As Long
            Get
                Return Me.AddableAssignedServiceTypesCount
            End Get
        End Property

        Public Property AdminAgent As Boolean
            Get
                Return Me._AdminAgent
            End Get
            Set(ByVal value As Boolean)
                Me._AdminAgent = value
            End Set
        End Property

        Public Property AgentTypeID As Long
            Get
                Return Me._AgentTypeID
            End Get
            Set(ByVal value As Long)
                Me._AgentTypeID = value
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

        Public ReadOnly Property CustomerAgentID As Long
            Get
                Return Me._CustomerAgentID
            End Get
        End Property

        Public ReadOnly Property CustomerID As Long
            Get
                Return Me._CustomerID
            End Get
        End Property

        Public ReadOnly Property DateCreated As DateTime
            Get
                Return Me._DateCreated
            End Get
        End Property

        Public Property Email As String
            Get
                Return Me._Email
            End Get
            Set(ByVal value As String)
                Me._Email = Me.TrimTrunc(value, &HFF)
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

        Public ReadOnly Property ServiceTypeCount As Long
            Get
                Return Me.AssignedServiceTypesCount
            End Get
        End Property

        Public Property WebLoginID As Long
            Get
                Return Me._WebLoginID
            End Get
            Set(ByVal value As Long)
                Me._WebLoginID = value
            End Set
        End Property


        ' Fields
        Private _Active As Boolean
        Private _AdminAgent As Boolean
        Private _AgentTypeID As Long
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _CustomerAgentID As Long
        Private _CustomerID As Long
        Private _DateCreated As DateTime
        Private _Email As String
        Private _FirstName As String
        Private _LastName As String
        Private _MiddleName As String
        Private _WebLoginID As Long
        Private Const EmailMaxLength As Integer = &HFF
        Private Const FirstNameMaxLength As Integer = &H20
        Private Const LastNameMaxLength As Integer = &H40
        Private Const MiddleNameMaxLength As Integer = &H20
    End Class
End Namespace

