Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class ActionRecord
        ' Methods
        Public Sub New()
            Me._ActionID = 0
            Me._UserID = 0
            Me._TerminalName = ""
            Me._TerminalType = ""
            Me._TerminalIP = ""
            Me._SessionToken = ""
            Me._ObjectID = 0
            Me._ObjectKey = 0
            Me._Action = ""
            Me._DateCreated = New DateTime
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._ActionID = 0
            Me._UserID = 0
            Me._TerminalName = ""
            Me._TerminalType = ""
            Me._TerminalIP = ""
            Me._SessionToken = ""
            Me._ObjectID = 0
            Me._ObjectKey = 0
            Me._Action = ""
            Me._DateCreated = New DateTime
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngActionID As Long, ByVal strConnectionString As String)
            Me._ActionID = 0
            Me._UserID = 0
            Me._TerminalName = ""
            Me._TerminalType = ""
            Me._TerminalIP = ""
            Me._SessionToken = ""
            Me._ObjectID = 0
            Me._ObjectKey = 0
            Me._Action = ""
            Me._DateCreated = New DateTime
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._ActionID)
        End Sub

        Public Sub Add(ByVal lngUserID As Long, ByVal strTerminalName As String, ByVal strTerminalType As String, ByVal strTerminalIP As String, ByVal strSessionToken As String, ByVal lngObjectID As Long, ByVal lngObjectKey As Long, ByVal strAction As String)
            If ((Me._ConnectionString.Trim.Length > 0) AndAlso (strAction.Trim.Length > 0)) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddAction")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngActionID As Long = 0
                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = lngUserID
                cmd.Parameters.Add("@TerminalName", SqlDbType.VarChar, Me.TrimTrunc(strTerminalName, &H80).Length).Value = Me.TrimTrunc(strTerminalName, &H80)
                cmd.Parameters.Add("@TerminalType", SqlDbType.VarChar, Me.TrimTrunc(strTerminalType, &H80).Length).Value = Me.TrimTrunc(strTerminalType, &H80)
                cmd.Parameters.Add("@TerminalIP", SqlDbType.VarChar, Me.TrimTrunc(strTerminalIP, &H10).Length).Value = Me.TrimTrunc(strTerminalIP, &H10)
                cmd.Parameters.Add("@ObjectID", SqlDbType.Int).Value = lngObjectID
                cmd.Parameters.Add("@ObjectKey", SqlDbType.Int).Value = lngObjectKey
                cmd.Parameters.Add("@Action", SqlDbType.Text).Value = strAction
                cmd.Parameters.Add("@SessionToken", SqlDbType.VarChar, Me.TrimTrunc(strSessionToken, &H40).Length).Value = Me.TrimTrunc(strSessionToken, &H40)
                cnn.Open
                cmd.Connection = cnn
                lngActionID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngActionID > 0) Then
                    Me.Load(lngActionID)
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
            Me._ActionID = 0
            Me._UserID = 0
            Me._TerminalName = ""
            Me._TerminalType = ""
            Me._TerminalIP = ""
            Me._SessionToken = ""
            Me._ObjectID = 0
            Me._ObjectKey = 0
            Me._Action = ""
            Me._DateCreated = New DateTime
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveAction")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ActionID", SqlDbType.Int).Value = Me._ActionID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._ActionID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New ActionRecord(Me._ActionID, Me._ConnectionString)
            If (obj.TerminalName <> Me._TerminalName) Then
                blnReturn = True
            End If
            If (obj.TerminalType <> Me._TerminalType) Then
                blnReturn = True
            End If
            If (obj.TerminalIP <> Me._TerminalIP) Then
                blnReturn = True
            End If
            If (obj.SessionToken <> Me._SessionToken) Then
                blnReturn = True
            End If
            If (obj.ObjectID <> Me._ObjectID) Then
                blnReturn = True
            End If
            If (obj.ObjectKey <> Me._ObjectKey) Then
                blnReturn = True
            End If
            If (obj.Action <> Me._Action) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngActionID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetAction")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ActionID", SqlDbType.Int).Value = lngActionID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._ActionID = Conversions.ToLong(dtr.Item("ActionID"))
                    Me._UserID = Conversions.ToLong(dtr.Item("UserID"))
                    Me._TerminalName = dtr.Item("TerminalName").ToString
                    Me._TerminalType = dtr.Item("TerminalType").ToString
                    Me._TerminalIP = dtr.Item("TerminalIP").ToString
                    Me._SessionToken = dtr.Item("SessionToken").ToString
                    Me._ObjectID = Conversions.ToLong(dtr.Item("ObjectID"))
                    Me._ObjectKey = Conversions.ToLong(dtr.Item("ObjectKey"))
                    Me._Action = dtr.Item("Action").ToString
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
                Dim obj As New ActionRecord(Me._ActionID, Me._ConnectionString)
                If (obj.TerminalName <> Me._TerminalName) Then
                    Me.UpdateTerminalName(Me._TerminalName, (cnn))
                    strTemp = String.Concat(New String() { "TerminalName Changed to '", Me._TerminalName, "' from '", obj.TerminalName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.TerminalType <> Me._TerminalType) Then
                    Me.UpdateTerminalType(Me._TerminalType, (cnn))
                    strTemp = String.Concat(New String() { "TerminalType Changed to '", Me._TerminalType, "' from '", obj.TerminalType, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.TerminalIP <> Me._TerminalIP) Then
                    Me.UpdateTerminalIP(Me._TerminalIP, (cnn))
                    strTemp = String.Concat(New String() { "TerminalIP Changed to '", Me._TerminalIP, "' from '", obj.TerminalIP, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.SessionToken <> Me._SessionToken) Then
                    Me.UpdateSessionToken(Me._SessionToken, (cnn))
                    strTemp = String.Concat(New String() { "SessionToken Changed to '", Me._SessionToken, "' from '", obj.SessionToken, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ObjectID <> Me._ObjectID) Then
                    Me.UpdateObjectID(Me._ObjectID, (cnn))
                    strTemp = String.Concat(New String() { "ObjectID Changed to '", Conversions.ToString(Me._ObjectID), "' from '", Conversions.ToString(obj.ObjectID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ObjectKey <> Me._ObjectKey) Then
                    Me.UpdateObjectKey(Me._ObjectKey, (cnn))
                    strTemp = String.Concat(New String() { "ObjectKey Changed to '", Conversions.ToString(Me._ObjectKey), "' from '", Conversions.ToString(obj.ObjectKey), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Action <> Me._Action) Then
                    Me.UpdateAction(Me._Action, (cnn))
                    strTemp = String.Concat(New String() { "Action Changed to '", Me._Action, "' from '", obj.Action, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._ActionID)
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

        Private Sub UpdateAction(ByVal NewAction As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateActionAction")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ActionID", SqlDbType.Int).Value = Me._ActionID
            cmd.Parameters.Add("@Action", SqlDbType.Text).Value = NewAction
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateObjectID(ByVal NewObjectID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateActionObjectID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ActionID", SqlDbType.Int).Value = Me._ActionID
            cmd.Parameters.Add("@ObjectID", SqlDbType.Int).Value = NewObjectID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateObjectKey(ByVal NewObjectKey As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateActionObjectKey")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ActionID", SqlDbType.Int).Value = Me._ActionID
            cmd.Parameters.Add("@ObjectKey", SqlDbType.Int).Value = NewObjectKey
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateSessionToken(ByVal NewSessionToken As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateActionSessionToken")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ActionID", SqlDbType.Int).Value = Me._ActionID
            cmd.Parameters.Add("@SessionToken", SqlDbType.VarChar, Me.TrimTrunc(NewSessionToken, &H40).Length).Value = Me.TrimTrunc(NewSessionToken, &H40)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateTerminalIP(ByVal NewTerminalIP As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateActionTerminalIP")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ActionID", SqlDbType.Int).Value = Me._ActionID
            cmd.Parameters.Add("@TerminalIP", SqlDbType.VarChar, Me.TrimTrunc(NewTerminalIP, &H10).Length).Value = Me.TrimTrunc(NewTerminalIP, &H10)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateTerminalName(ByVal NewTerminalName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateActionTerminalName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ActionID", SqlDbType.Int).Value = Me._ActionID
            cmd.Parameters.Add("@TerminalName", SqlDbType.VarChar, Me.TrimTrunc(NewTerminalName, &H80).Length).Value = Me.TrimTrunc(NewTerminalName, &H80)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateTerminalType(ByVal NewTerminalType As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateActionTerminalType")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ActionID", SqlDbType.Int).Value = Me._ActionID
            cmd.Parameters.Add("@TerminalType", SqlDbType.VarChar, Me.TrimTrunc(NewTerminalType, &H80).Length).Value = Me.TrimTrunc(NewTerminalType, &H80)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub


        ' Properties
        Public Property Action As String
            Get
                Return Me._Action
            End Get
            Set(ByVal value As String)
                Me._Action = value
            End Set
        End Property

        Public ReadOnly Property ActionID As Long
            Get
                Return Me._ActionID
            End Get
        End Property

        Public Property ConnectionString As String
            Get
                Return Me._ConnectionString
            End Get
            Set(ByVal value As String)
                Me._ConnectionString = value
            End Set
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

        Public Property ObjectID As Long
            Get
                Return Me._ObjectID
            End Get
            Set(ByVal value As Long)
                Me._ObjectID = value
            End Set
        End Property

        Public Property ObjectKey As Long
            Get
                Return Me._ObjectKey
            End Get
            Set(ByVal value As Long)
                Me._ObjectKey = value
            End Set
        End Property

        Public Property SessionToken As String
            Get
                Return Me._SessionToken
            End Get
            Set(ByVal value As String)
                Me._SessionToken = Me.TrimTrunc(value, &H40)
            End Set
        End Property

        Public Property TerminalIP As String
            Get
                Return Me._TerminalIP
            End Get
            Set(ByVal value As String)
                Me._TerminalIP = Me.TrimTrunc(value, &H10)
            End Set
        End Property

        Public Property TerminalName As String
            Get
                Return Me._TerminalName
            End Get
            Set(ByVal value As String)
                Me._TerminalName = Me.TrimTrunc(value, &H80)
            End Set
        End Property

        Public Property TerminalType As String
            Get
                Return Me._TerminalType
            End Get
            Set(ByVal value As String)
                Me._TerminalType = Me.TrimTrunc(value, &H80)
            End Set
        End Property

        Public ReadOnly Property UserID As Long
            Get
                Return Me._UserID
            End Get
        End Property


        ' Fields
        Private _Action As String
        Private _ActionID As Long
        Private _ConnectionString As String
        Private _DateCreated As DateTime
        Private _ObjectID As Long
        Private _ObjectKey As Long
        Private _SessionToken As String
        Private _TerminalIP As String
        Private _TerminalName As String
        Private _TerminalType As String
        Private _UserID As Long
        Private Const SessionTokenMaxLength As Integer = &H40
        Private Const TerminalIPMaxLength As Integer = &H10
        Private Const TerminalNameMaxLength As Integer = &H80
        Private Const TerminalTypeMaxLength As Integer = &H80

        ' Nested Types
        Public Enum ActionObjects
            ' Fields
            Application = 2
            CompanyInfo = 13
            CustomerAddresses = 8
            CustomerIdentifications = 9
            CustomerPhoneNumbers = 7
            Customers = 6
            EntityTypes = &H13
            InvoiceItems = 11
            Invoices = 10
            None = 0
            PaymentMethods = 12
            Payments = 14
            PersonalTitles = &H10
            Pictures = 3
            ResumeAddresses = &H18
            ResumePhones = &H16
            Resumes = &H17
            Roles = 15
            Suffixes = &H11
            User = 1
            UserAddresses = 4
            UserPhoneNumbers = 5
            Vendors = &H12
            VendorTypes = 20
            WebLogins = &H15
        End Enum
    End Class
End Namespace

