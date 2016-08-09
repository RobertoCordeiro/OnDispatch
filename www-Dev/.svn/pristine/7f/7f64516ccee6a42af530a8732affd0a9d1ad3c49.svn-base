Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface

    Public Class UserRecruitAssignmentRecord

#Region "Private Members"

        Private _UserRecruitAssignmentID As Long = 0
        Private _UserID As Long = 0
        Private _StateID As Long = 0
        Private _ConnectionString As String = ""

#End Region

#Region "Read/Write Properties"

        ''' <summary>
        ''' Returns/Sets the UserID field for the currently loaded record
        ''' </summary>
        Public Property UserID() As Long
            Get
                Return _UserID
            End Get
            Set(ByVal value As Long)
                _UserID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the StateID field for the currently loaded record
        ''' </summary>
        Public Property StateID() As Long
            Get
                Return _StateID
            End Get
            Set(ByVal value As Long)
                _StateID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the connection string to the database
        ''' </summary>
        Public Property ConnectionString() As String
            Get
                Return _ConnectionString
            End Get
            Set(ByVal value As String)
                _ConnectionString = value
            End Set
        End Property

#End Region

#Region "ReadOnly Properties"

        ''' <summary>
        ''' Returns the UserRecruitAssignmentID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property UserRecruitAssignmentID() As Long
            Get
                Return _UserRecruitAssignmentID
            End Get
        End Property

        ''' <summary>
        ''' Returns a boolean value indicating if the object has changed
        ''' since the last time it was loaded.
        ''' </summary>
        Public ReadOnly Property Modified() As Boolean
            Get
                Return HasChanged()
            End Get
        End Property

#End Region

#Region "Private Sub-Routines"

        ''' <summary>
        ''' Clears all values except for the connection string
        ''' </summary>
        Private Sub ClearValues()
            _UserRecruitAssignmentID = 0
            _UserID = 0
            _StateID = 0
        End Sub

        ''' <summary>
        ''' Appends a line to a change log
        ''' </summary>
        ''' <param name="strLog">The log to append to</param>
        ''' <param name="strNewLine">The line to append to the log</param>
        Private Sub AppendChangeLog(ByRef strLog As String, ByVal strNewLine As String)
            Dim strReturn As String = ""
            If strLog.Length > 0 Then
                strReturn = strLog & Environment.NewLine
            End If
            strReturn &= strNewLine
            strLog = strReturn
        End Sub

        ''' <summary>
        ''' Updates the UserID field for this record.
        ''' </summary>
        ''' <param name="NewUserID">The new value for theUserID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateUserID(ByVal NewUserID As Long, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New SqlClient.SqlCommand("spUpdateUserRecruitAssignmentUserID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@UserRecruitAssignmentID", SqlDbType.Int).Value = _UserRecruitAssignmentID
            cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = NewUserID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the StateID field for this record.
        ''' </summary>
        ''' <param name="NewStateID">The new value for theStateID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateStateID(ByVal NewStateID As Long, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New SqlClient.SqlCommand("spUpdateUserRecruitAssignmentStateID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@UserRecruitAssignmentID", SqlDbType.Int).Value = _UserRecruitAssignmentID
            cmd.Parameters.Add("@StateID", SqlDbType.Int).Value = NewStateID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

#End Region

#Region "Private Functions"

        ''' <summary>
        ''' Returns a string that has been trimmed and trunced down to its max length
        ''' </summary>
        ''' <param name="strInput">The string to manipulate</param>
        ''' <param name="intMaxLength">The maximum length the string can be</param>
        Private Function TrimTrunc(ByVal strInput As String, ByVal intMaxLength As Integer) As String
            Dim strReturn As String = strInput
            If strReturn.Trim.Length <= intMaxLength Then
                strReturn = strReturn.Trim
            Else
                strReturn = strReturn.Substring(0, intMaxLength)
                strReturn = strReturn.Trim
            End If
            Return strReturn
        End Function

        ''' <summary>
        ''' Returns a boolean indicating if the object has changed
        ''' </summary>
        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New UserRecruitAssignmentRecord(_UserRecruitAssignmentID, _ConnectionString)
            obj.Load(_UserRecruitAssignmentID)
            If obj.UserID <> _UserID Then
                blnReturn = True
            End If
            If obj.StateID <> _StateID Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

#End Region

#Region "Public Sub-Routines"

        ''' <summary>
        ''' Overloaded, initializes the object
        ''' </summary>
        Public Sub New()
            ClearValues()
        End Sub

        ''' <summary>
        ''' Overloaded, Initializes the object with a given connection string
        ''' </summary>
        ''' <param name="strConnectionString">The connection string to the database the customer is contained in</param>
        Public Sub New(ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
        End Sub

        ''' <summary>
        ''' Overloaded, Initializes the object and loads by the passed in Primary Key
        ''' </summary>
        ''' <param name="lngUserRecruitAssignmentID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngUserRecruitAssignmentID As Long, ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
            Load(_UserRecruitAssignmentID)
        End Sub

        ''' <summary>
        '''  Adds a new UserRecruitAssignment record to the database.
        ''' </summary>
        ''' <param name="lngUserID">The value for the UserID portion of the record</param>
        ''' <param name="lngStateID">The value for the StateID portion of the record</param>
        Public Sub Add(ByVal lngUserID As Long, ByVal lngStateID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spAddUserRecruitAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngUserRecruitAssignmentID As Long = 0
                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = lngUserID
                cmd.Parameters.Add("@StateID", SqlDbType.Int).Value = lngStateID
                cnn.Open()
                cmd.Connection = cnn
                lngUserRecruitAssignmentID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngUserRecruitAssignmentID > 0 Then
                    Load(lngUserRecruitAssignmentID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a UserRecruitAssignment record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngUserRecruitAssignmentID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spGetUserRecruitAssignment")
                Dim dtr As SqlClient.SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@UserRecruitAssignmentID", SqlDbType.Int).Value = lngUserRecruitAssignmentID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _UserRecruitAssignmentID = CType(dtr("UserRecruitAssignmentID"), Long)
                    _UserID = CType(dtr("UserID"), Long)
                    _StateID = CType(dtr("StateID"), Long)
                Else
                    ClearValues()
                End If
                cnn.Close()
            End If
        End Sub
        Public Sub Load(ByVal lngUserID As Long, ByVal lngStateID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spGetUserRecruitAssignmentByUserStateID")
                Dim dtr As SqlClient.SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = lngUserID
                cmd.Parameters.Add("@StateID", SqlDbType.Int).Value = lngStateID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _UserRecruitAssignmentID = CType(dtr("UserRecruitAssignmentID"), Long)
                    _UserID = CType(dtr("UserID"), Long)
                    _StateID = CType(dtr("StateID"), Long)
                Else
                    ClearValues()
                End If
                cnn.Close()
            End If
        End Sub

        ''' <summary>
        ''' Saves any changes to the record since it was last loaded
        ''' </summary>
        ''' <param name="strChangeLog">The string variable you want manipulated that returns a log of changes.</param>
        Public Sub Save(ByRef strChangeLog As String)
            strChangeLog = ""
            If _ConnectionString.Trim.Length > 0 Then
                Dim strTemp As String = ""
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                cnn.Open()
                Dim obj As New UserRecruitAssignmentRecord(_UserRecruitAssignmentID, _ConnectionString)
                obj.Load(_UserRecruitAssignmentID)
                If obj.UserID <> _UserID Then
                    UpdateUserID(_UserID, cnn)
                    strTemp = "UserID Changed to '" & _UserID & "' from '" & obj.UserID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.StateID <> _StateID Then
                    UpdateStateID(_StateID, cnn)
                    strTemp = "StateID Changed to '" & _StateID & "' from '" & obj.StateID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(_UserRecruitAssignmentID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded UserRecruitAssignment Record
        ''' </summary>
        Public Sub Delete()
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spRemoveUserRecruitAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@UserRecruitAssignmentID", SqlDbType.Int).Value = _UserRecruitAssignmentID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(_UserRecruitAssignmentID)
            End If
        End Sub
        Public Sub Delete(ByVal lngUserID As Long, ByVal lngStateID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spRemoveUserRecruitAssignmentByUserStateID")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = lngUserID
                cmd.Parameters.Add("@StateID", SqlDbType.Int).Value = lngStateID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(lngUserID, lngStateID)
            End If
        End Sub
#End Region

    End Class
End Namespace