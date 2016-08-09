Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface

    Public Class TrainingVideoRecord

#Region "Private Constants"

        Private Const TitleMaxLength As Integer = 32
        Private Const SubjectMaxLength As Integer = 32
        Private Const FilePathMaxLength As Integer = 128

#End Region

#Region "Private Members"

        Private _TrainingVideoID As Long = 0
        Private _CreatedBy As Long = 0
        Private _Title As String = ""
        Private _Subject As String = ""
        Private _FilePath As String = ""
        Private _FileID As Long = 0
        Private _GroupID As Long = 0
        Private _ConnectionString As String = ""

#End Region

#Region "Read/Write Properties"

        ''' <summary>
        ''' Returns/Sets the Title field for the currently loaded record
        ''' </summary>
        Public Property Title() As String
            Get
                Return _Title
            End Get
            Set(ByVal value As String)
                _Title = TrimTrunc(value, TitleMaxLength)
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the Subject field for the currently loaded record
        ''' </summary>
        Public Property Subject() As String
            Get
                Return _Subject
            End Get
            Set(ByVal value As String)
                _Subject = TrimTrunc(value, SubjectMaxLength)
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the FilePath field for the currently loaded record
        ''' </summary>
        Public Property FilePath() As String
            Get
                Return _FilePath
            End Get
            Set(ByVal value As String)
                _FilePath = TrimTrunc(value, FilePathMaxLength)
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the FileID field for the currently loaded record
        ''' </summary>
        Public Property FileID() As Long
            Get
                Return _FileID
            End Get
            Set(ByVal value As Long)
                _FileID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the GroupID field for the currently loaded record
        ''' </summary>
        Public Property GroupID() As Long
            Get
                Return _GroupID
            End Get
            Set(ByVal value As Long)
                _GroupID = value
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
        ''' Returns the TrainingVideoID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property TrainingVideoID() As Long
            Get
                Return _TrainingVideoID
            End Get
        End Property

        ''' <summary>
        ''' Returns the CreatedBy field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property CreatedBy() As Long
            Get
                Return _CreatedBy
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
            _TrainingVideoID = 0
            _CreatedBy = 0
            _Title = ""
            _Subject = ""
            _FilePath = ""
            _FileID = 0
            _GroupID = 0
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
        ''' Updates the Title field for this record.
        ''' </summary>
        ''' <param name="NewTitle">The new value for theTitle field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateTitle(ByVal NewTitle As String, ByRef cnn As sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateTrainingVideoTitle")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@TrainingVideoID", sqlDBType.int).value = _TrainingVideoID
            cmd.Parameters.Add("@Title", SqlDbType.varchar, TrimTrunc(NewTitle, TitleMaxLength).Length).value = TrimTrunc(NewTitle, TitleMaxLength)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the Subject field for this record.
        ''' </summary>
        ''' <param name="NewSubject">The new value for theSubject field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateSubject(ByVal NewSubject As String, ByRef cnn As sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateTrainingVideoSubject")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@TrainingVideoID", sqlDBType.int).value = _TrainingVideoID
            cmd.Parameters.Add("@Subject", SqlDbType.varchar, TrimTrunc(NewSubject, SubjectMaxLength).Length).value = TrimTrunc(NewSubject, SubjectMaxLength)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the FilePath field for this record.
        ''' </summary>
        ''' <param name="NewFilePath">The new value for theFilePath field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateFilePath(ByVal NewFilePath As String, ByRef cnn As sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateTrainingVideoFilePath")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@TrainingVideoID", sqlDBType.int).value = _TrainingVideoID
            cmd.Parameters.Add("@FilePath", SqlDbType.varchar, TrimTrunc(NewFilePath, FilePathMaxLength).Length).value = TrimTrunc(NewFilePath, FilePathMaxLength)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the FileID field for this record.
        ''' </summary>
        ''' <param name="NewFileID">The new value for theFileID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateFileID(ByVal NewFileID As Long, ByRef cnn As sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateTrainingVideoFileID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@TrainingVideoID", sqlDBType.int).value = _TrainingVideoID
            If NewFileID > 0 Then
                cmd.Parameters.Add("@FileID", SqlDbType.int).value = NewFileID
            Else
                cmd.Parameters.Add("@FileID", SqlDbType.int).Value = System.DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the GroupID field for this record.
        ''' </summary>
        ''' <param name="NewGroupID">The new value for theGroupID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateGroupID(ByVal NewGroupID As Long, ByRef cnn As sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateTrainingVideoGroupID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@TrainingVideoID", sqlDBType.int).value = _TrainingVideoID
            cmd.Parameters.Add("@GroupID", SqlDbType.int).value = NewGroupID
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
            Dim obj As New TrainingVideoRecord(_TrainingVideoID, _ConnectionString)
            obj.Load(_TrainingVideoID)
            If obj.Title <> _Title Then
                blnReturn = True
            End If
            If obj.Subject <> _Subject Then
                blnReturn = True
            End If
            If obj.FilePath <> _FilePath Then
                blnReturn = True
            End If
            If obj.FileID <> _FileID Then
                blnReturn = True
            End If
            If obj.GroupID <> _GroupID Then
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
        ''' <param name="lngTrainingVideoID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngTrainingVideoID As Long, ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
            Load(_TrainingVideoID)
        End Sub

        ''' <summary>
        '''  Adds a new TrainingVideo record to the database.
        ''' </summary>
        ''' <param name="lngCreatedBy">The value for the CreatedBy portion of the record</param>
        ''' <param name="strTitle">The value for the Title portion of the record</param>
        ''' <param name="strSubject">The value for the Subject portion of the record</param>
        ''' <param name="strFilePath">The value for the FilePath portion of the record</param>
        ''' <param name="lngGroupID">The value for the GroupID portion of the record</param>
        Public Sub Add(ByVal lngCreatedBy As Long, ByVal strTitle As String, ByVal strSubject As String, ByVal strFilePath As String, ByVal lngGroupID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spAddTrainingVideo")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngTrainingVideoID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SQLDBType.int).Value = lngCreatedBy
                cmd.Parameters.Add("@Title", SQLDBType.varchar, TrimTrunc(strTitle, TitleMaxLength).Length).Value = TrimTrunc(strTitle, TitleMaxLength)
                cmd.Parameters.Add("@Subject", SQLDBType.varchar, TrimTrunc(strSubject, SubjectMaxLength).Length).Value = TrimTrunc(strSubject, SubjectMaxLength)
                cmd.Parameters.Add("@FilePath", SQLDBType.varchar, TrimTrunc(strFilePath, FilePathMaxLength).Length).Value = TrimTrunc(strFilePath, FilePathMaxLength)
                cmd.Parameters.Add("@GroupID", SQLDBType.int).Value = lngGroupID
                cnn.Open()
                cmd.Connection = cnn
                lngTrainingVideoID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngTrainingVideoID > 0 Then
                    Load(lngTrainingVideoID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a TrainingVideo record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngTrainingVideoID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spGetTrainingVideo")
                Dim dtr As SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@TrainingVideoID", SqlDbType.Int).Value = lngTrainingVideoID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _TrainingVideoID = CType(dtr("TrainingVideoID"), Long)
                    _CreatedBy = CType(dtr("CreatedBy"), Long)
                    _Title = dtr("Title").ToString
                    _Subject = dtr("Subject").ToString
                    _FilePath = dtr("FilePath").ToString
                    If Not IsDBNull(dtr("FileID")) Then
                        _FileID = CType(dtr("FileID"), Long)
                    Else
                        _FileID = 0
                    End If
                    _GroupID = CType(dtr("GroupID"), Long)
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
                Dim cnn As New SqlConnection(_ConnectionString)
                cnn.Open()
                Dim obj As New TrainingVideoRecord(_TrainingVideoID, _ConnectionString)
                obj.Load(_TrainingVideoID)
                If obj.Title <> _Title Then
                    UpdateTitle(_Title, cnn)
                    strTemp = "Title Changed to '" & _Title & "' from '" & obj.Title & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.Subject <> _Subject Then
                    UpdateSubject(_Subject, cnn)
                    strTemp = "Subject Changed to '" & _Subject & "' from '" & obj.Subject & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.FilePath <> _FilePath Then
                    UpdateFilePath(_FilePath, cnn)
                    strTemp = "FilePath Changed to '" & _FilePath & "' from '" & obj.FilePath & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.FileID <> _FileID Then
                    UpdateFileID(_FileID, cnn)
                    strTemp = "FileID Changed to '" & _FileID & "' from '" & obj.FileID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.GroupID <> _GroupID Then
                    UpdateGroupID(_GroupID, cnn)
                    strTemp = "GroupID Changed to '" & _GroupID & "' from '" & obj.GroupID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(_TrainingVideoID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded TrainingVideo Record
        ''' </summary>
        Public Sub Delete()
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spRemoveTrainingVideo")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@TrainingVideoID", SqlDbType.Int).Value = _TrainingVideoID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(_TrainingVideoID)
            End If
        End Sub

#End Region

    End Class

End Namespace