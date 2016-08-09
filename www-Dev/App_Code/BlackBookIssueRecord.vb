Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class BlackBookIssueRecord

#Region "Private Constants"

        Private Const BlackBookIssueMaxLength As Integer = 100

#End Region

#Region "Private Members"

        Private _BlackBookIssueID As Long = 0
        Private _BlackBookIssue As String = ""
        Private _BlackBookTypeID As Long = 0
        Private _Active As Boolean = False
        Private _ConnectionString As String = ""

#End Region

#Region "Read/Write Properties"

        
        Public Property BlackBookIssue() As String
            Get
                Return _BlackBookIssue
            End Get
            Set(ByVal value As String)
                _BlackBookIssue = TrimTrunc(value, BlackBookIssueMaxLength)
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the BlackBookTypeID field for the currently loaded record
        ''' </summary>
        Public Property BlackBookTypeID() As Long
            Get
                Return _BlackBookTypeID
            End Get
            Set(ByVal value As Long)
                _BlackBookTypeID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the Active field for the currently loaded record
        ''' </summary>
        Public Property Active() As Boolean
            Get
                Return _Active
            End Get
            Set(ByVal value As Boolean)
                _Active = value
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
        ''' Returns the BlackBookIssueID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property BlackBookIssueID() As Long
            Get
                Return _BlackBookIssueID
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
            _BlackBookIssueID = 0
            _BlackBookIssue = ""
            _BlackBookTypeID = 0
            _Active = False
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
        ''' Updates the BlackBookIssue field for this record.
        ''' </summary>
        ''' <param name="NewBlackBookIssue">The new value for theBlackBookIssue field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateBlackBookIssue(ByVal NewBlackBookIssue As String, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New SqlClient.SqlCommand("spUpdateBlackBookIssueBlackBookIssue")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@BlackBookIssueID", SqlDbType.Int).Value = _BlackBookIssueID
            cmd.Parameters.Add("@BlackBookIssue", SqlDbType.NVarChar, TrimTrunc(NewBlackBookIssue, BlackBookIssueMaxLength).Length).value = TrimTrunc(NewBlackBookIssue, BlackBookIssueMaxLength)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the BlackBookTypeID field for this record.
        ''' </summary>
        ''' <param name="NewBlackBookTypeID">The new value for theBlackBookTypeID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateBlackBookTypeID(ByVal NewBlackBookTypeID As Long, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateBlackBookIssueBlackBookTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@BlackBookIssueID", sqlDBType.int).value = _BlackBookIssueID
            cmd.Parameters.Add("@BlackBookTypeID", SqlDbType.int).value = NewBlackBookTypeID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the Active field for this record.
        ''' </summary>
        ''' <param name="NewActive">The new value for theActive field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateActive(ByVal NewActive As Boolean, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateBlackBookIssueActive")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@BlackBookIssueID", sqlDBType.int).value = _BlackBookIssueID
            cmd.Parameters.Add("@Active", SqlDbType.bit).value = NewActive
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
            Dim obj As New BlackBookIssueRecord(_BlackBookIssueID, _ConnectionString)
            obj.Load(_BlackBookIssueID)
            If obj.BlackBookIssue <> _BlackBookIssue Then
                blnReturn = True
            End If
            If obj.BlackBookTypeID <> _BlackBookTypeID Then
                blnReturn = True
            End If
            If obj.Active <> _Active Then
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
        ''' <param name="lngBlackBookIssueID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngBlackBookIssueID As Long, ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
            Load(_BlackBookIssueID)
        End Sub

        ''' <summary>
        '''  Adds a new BlackBookIssue record to the database.
        ''' </summary>
        ''' <param name="BlackBookIssue">The value for the BlackBookIssue portion of the record</param>
        ''' <param name="lngBlackBookTypeID">The value for the BlackBookTypeID portion of the record</param>
        ''' <param name="blnActive">The value for the Active portion of the record</param>
        Public Sub Add(ByVal BlackBookIssue As String, ByVal lngBlackBookTypeID As Long, ByVal blnActive As Boolean)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spAddBlackBookIssue")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngBlackBookIssueID As Long = 0
                cmd.Parameters.Add("@BlackBookIssue", SqlDbType.NVarChar, TrimTrunc(BlackBookIssue, BlackBookIssueMaxLength).Length).Value = TrimTrunc(BlackBookIssue, BlackBookIssueMaxLength)
                cmd.Parameters.Add("@BlackBookTypeID", SqlDbType.Int).Value = lngBlackBookTypeID
                cmd.Parameters.Add("@Active", SqlDbType.Bit).Value = blnActive
                cnn.Open()
                cmd.Connection = cnn
                lngBlackBookIssueID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngBlackBookIssueID > 0 Then
                    Load(lngBlackBookIssueID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a BlackBookIssue record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngBlackBookIssueID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spGetBlackBookIssue")
                Dim dtr As SqlClient.SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@BlackBookIssueID", SqlDbType.Int).Value = lngBlackBookIssueID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _BlackBookIssueID = CType(dtr("BlackBookIssueID"), Long)
                    _BlackBookTypeID = CType(dtr("BlackBookTypeID"), Long)
                    _Active = CType(dtr("Active"), Boolean)
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
                Dim obj As New BlackBookIssueRecord(_BlackBookIssueID, _ConnectionString)
                obj.Load(_BlackBookIssueID)
                If obj._BlackBookIssue <> _BlackBookIssue Then
                    UpdateBlackBookIssue(_BlackBookIssue, cnn)
                    strTemp = "BlackBookIssue Changed to '" & _BlackBookIssue & "' from '" & obj._BlackBookIssue & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.BlackBookTypeID <> _BlackBookTypeID Then
                    UpdateBlackBookTypeID(_BlackBookTypeID, cnn)
                    strTemp = "BlackBookTypeID Changed to '" & _BlackBookTypeID & "' from '" & obj.BlackBookTypeID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.Active <> _Active Then
                    UpdateActive(_Active, cnn)
                    strTemp = "Active Changed to '" & _Active & "' from '" & obj.Active & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(_BlackBookIssueID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded BlackBookIssue Record
        ''' </summary>
        Public Sub Delete()
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spRemoveBlackBookIssue")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@BlackBookIssueID", SqlDbType.Int).Value = _BlackBookIssueID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(_BlackBookIssueID)
            End If
        End Sub

#End Region

    End Class
End Namespace