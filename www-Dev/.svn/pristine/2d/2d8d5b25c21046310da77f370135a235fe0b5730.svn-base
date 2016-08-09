Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface

    Public Class SurveyAnswerRecord

#Region "Private Constants"

        Private Const SurveyCommentMaxLength As Integer = 510

#End Region

#Region "Private Members"

        Private _SurveyAnswerID As Long = 0
        Private _SurveyID As Long = 0
        Private _SurveyQuestionID As Long = 0
        Private _WorkOrderID As Long = 0
        Private _SurveyMethodID As Long = 0
        Private _SurveyAnswer As Long = 0
        Private _SurveyComment As String = ""
        Private _DateCreated As Date = DateTime.Now
        Private _SurveyedBy As Long = 0
        Private _ConnectionString As String = ""

#End Region

#Region "Read/Write Properties"

        ''' <summary>
        ''' Returns/Sets the SurveyID field for the currently loaded record
        ''' </summary>
        Public Property SurveyID() As Long
            Get
                Return _SurveyID
            End Get
            Set(ByVal value As Long)
                _SurveyID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the SurveyQuestionID field for the currently loaded record
        ''' </summary>
        Public Property SurveyQuestionID() As Long
            Get
                Return _SurveyQuestionID
            End Get
            Set(ByVal value As Long)
                _SurveyQuestionID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the WorkOrderID field for the currently loaded record
        ''' </summary>
        Public Property WorkOrderID() As Long
            Get
                Return _WorkOrderID
            End Get
            Set(ByVal value As Long)
                _WorkOrderID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the SurveyMethodID field for the currently loaded record
        ''' </summary>
        Public Property SurveyMethodID() As Long
            Get
                Return _SurveyMethodID
            End Get
            Set(ByVal value As Long)
                _SurveyMethodID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the SurveyAnswer field for the currently loaded record
        ''' </summary>
        Public Property SurveyAnswer() As Long
            Get
                Return _SurveyAnswer
            End Get
            Set(ByVal value As Long)
                _SurveyAnswer = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the SurveyComment field for the currently loaded record
        ''' </summary>
        Public Property SurveyComment() As String
            Get
                Return _SurveyComment
            End Get
            Set(ByVal value As String)
                _SurveyComment = TrimTrunc(value, SurveyCommentMaxLength)
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the SurveyedBy field for the currently loaded record
        ''' </summary>
        Public Property SurveyedBy() As Long
            Get
                Return _SurveyedBy
            End Get
            Set(ByVal value As Long)
                _SurveyedBy = value
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
        ''' Returns the SurveyAnswerID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property SurveyAnswerID() As Long
            Get
                Return _SurveyAnswerID
            End Get
        End Property

        ''' <summary>
        ''' Returns the DateCreated field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property DateCreated() As Date
            Get
                Return _DateCreated
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
            _SurveyAnswerID = 0
            _SurveyID = 0
            _SurveyQuestionID = 0
            _WorkOrderID = 0
            _SurveyMethodID = 0
            _SurveyAnswer = 0
            _SurveyComment = ""
            _DateCreated = DateTime.Now
            _SurveyedBy = 0
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
        ''' Updates the SurveyID field for this record.
        ''' </summary>
        ''' <param name="NewSurveyID">The new value for theSurveyID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateSurveyID(ByVal NewSurveyID As Long, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateSurveyAnswerSurveyID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@SurveyAnswerID", sqlDBType.int).value = _SurveyAnswerID
            cmd.Parameters.Add("@SurveyID", SqlDbType.int).value = NewSurveyID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the SurveyQuestionID field for this record.
        ''' </summary>
        ''' <param name="NewSurveyQuestionID">The new value for theSurveyQuestionID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateSurveyQuestionID(ByVal NewSurveyQuestionID As Long, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateSurveyAnswerSurveyQuestionID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@SurveyAnswerID", sqlDBType.int).value = _SurveyAnswerID
            cmd.Parameters.Add("@SurveyQuestionID", SqlDbType.int).value = NewSurveyQuestionID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the WorkOrderID field for this record.
        ''' </summary>
        ''' <param name="NewWorkOrderID">The new value for theWorkOrderID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateWorkOrderID(ByVal NewWorkOrderID As Long, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateSurveyAnswerWorkOrderID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@SurveyAnswerID", sqlDBType.int).value = _SurveyAnswerID
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.int).value = NewWorkOrderID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the SurveyMethodID field for this record.
        ''' </summary>
        ''' <param name="NewSurveyMethodID">The new value for theSurveyMethodID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateSurveyMethodID(ByVal NewSurveyMethodID As Long, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateSurveyAnswerSurveyMethodID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@SurveyAnswerID", sqlDBType.int).value = _SurveyAnswerID
            cmd.Parameters.Add("@SurveyMethodID", SqlDbType.int).value = NewSurveyMethodID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the SurveyAnswer field for this record.
        ''' </summary>
        ''' <param name="NewSurveyAnswer">The new value for theSurveyAnswer field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateSurveyAnswer(ByVal NewSurveyAnswer As Long, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateSurveyAnswerSurveyAnswer")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@SurveyAnswerID", sqlDBType.int).value = _SurveyAnswerID
            cmd.Parameters.Add("@SurveyAnswer", SqlDbType.int).value = NewSurveyAnswer
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the SurveyComment field for this record.
        ''' </summary>
        ''' <param name="NewSurveyComment">The new value for theSurveyComment field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateSurveyComment(ByVal NewSurveyComment As String, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateSurveyAnswerSurveyComment")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@SurveyAnswerID", sqlDBType.int).value = _SurveyAnswerID
            If NewSurveyComment.Trim.Length > 0 Then
                cmd.Parameters.Add("@SurveyComment", SqlDbType.nvarchar, TrimTrunc(NewSurveyComment, SurveyCommentMaxLength).Length).value = TrimTrunc(NewSurveyComment, SurveyCommentMaxLength)
            Else
                cmd.Parameters.Add("@SurveyComment", SqlDbType.nvarchar).Value = System.DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the SurveyedBy field for this record.
        ''' </summary>
        ''' <param name="NewSurveyedBy">The new value for theSurveyedBy field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateSurveyedBy(ByVal NewSurveyedBy As Long, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateSurveyAnswerSurveyedBy")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@SurveyAnswerID", sqlDBType.int).value = _SurveyAnswerID
            cmd.Parameters.Add("@SurveyedBy", SqlDbType.int).value = NewSurveyedBy
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
            Dim obj As New SurveyAnswerRecord(_SurveyAnswerID, _ConnectionString)
            obj.Load(_SurveyAnswerID)
            If obj.SurveyID <> _SurveyID Then
                blnReturn = True
            End If
            If obj.SurveyQuestionID <> _SurveyQuestionID Then
                blnReturn = True
            End If
            If obj.WorkOrderID <> _WorkOrderID Then
                blnReturn = True
            End If
            If obj.SurveyMethodID <> _SurveyMethodID Then
                blnReturn = True
            End If
            If obj.SurveyAnswer <> _SurveyAnswer Then
                blnReturn = True
            End If
            If obj.SurveyComment <> _SurveyComment Then
                blnReturn = True
            End If
            If obj.SurveyedBy <> _SurveyedBy Then
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
        ''' <param name="lngSurveyAnswerID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngSurveyAnswerID As Long, ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
            Load(_SurveyAnswerID)
        End Sub

        ''' <summary>
        '''  Adds a new SurveyAnswer record to the database.
        ''' </summary>
        ''' <param name="lngSurveyID">The value for the SurveyID portion of the record</param>
        ''' <param name="lngSurveyQuestionID">The value for the SurveyQuestionID portion of the record</param>
        ''' <param name="lngWorkOrderID">The value for the WorkOrderID portion of the record</param>
        ''' <param name="lngSurveyMethodID">The value for the SurveyMethodID portion of the record</param>
        ''' <param name="lngSurveyAnswer">The value for the SurveyAnswer portion of the record</param>
        ''' <param name="datDateCreated">The value for the DateCreated portion of the record</param>
        ''' <param name="lngSurveyedBy">The value for the SurveyedBy portion of the record</param>
        Public Sub Add(ByVal lngSurveyID As Long, ByVal lngSurveyQuestionID As Long, ByVal lngWorkOrderID As Long, ByVal lngSurveyMethodID As Long, ByVal lngSurveyAnswer As Long, ByVal datDateCreated As Date, ByVal lngSurveyedBy As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spAddSurveyAnswer")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngSurveyAnswerID As Long = 0
                cmd.Parameters.Add("@SurveyID", SQLDBType.int).Value = lngSurveyID
                cmd.Parameters.Add("@SurveyQuestionID", SQLDBType.int).Value = lngSurveyQuestionID
                cmd.Parameters.Add("@WorkOrderID", SQLDBType.int).Value = lngWorkOrderID
                cmd.Parameters.Add("@SurveyMethodID", SQLDBType.int).Value = lngSurveyMethodID
                cmd.Parameters.Add("@SurveyAnswer", SQLDBType.int).Value = lngSurveyAnswer
                cmd.Parameters.Add("@DateCreated", SQLDBType.datetime).Value = datDateCreated
                cmd.Parameters.Add("@SurveyedBy", SQLDBType.int).Value = lngSurveyedBy
                cnn.Open()
                cmd.Connection = cnn
                lngSurveyAnswerID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngSurveyAnswerID > 0 Then
                    Load(lngSurveyAnswerID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a SurveyAnswer record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngSurveyAnswerID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spGetSurveyAnswer")
                Dim dtr As SqlClient.SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@SurveyAnswerID", SqlDbType.Int).Value = lngSurveyAnswerID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _SurveyAnswerID = CType(dtr("SurveyAnswerID"), Long)
                    _SurveyID = CType(dtr("SurveyID"), Long)
                    _SurveyQuestionID = CType(dtr("SurveyQuestionID"), Long)
                    _WorkOrderID = CType(dtr("WorkOrderID"), Long)
                    _SurveyMethodID = CType(dtr("SurveyMethodID"), Long)
                    _SurveyAnswer = CType(dtr("SurveyAnswer"), Long)
                    If Not IsDBNull(dtr("SurveyComment")) Then
                        _SurveyComment = dtr("SurveyComment").ToString
                    Else
                        _SurveyComment = ""
                    End If
                    _DateCreated = CType(dtr("DateCreated"), Date)
                    _SurveyedBy = CType(dtr("SurveyedBy"), Long)
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
                Dim obj As New SurveyAnswerRecord(_SurveyAnswerID, _ConnectionString)
                obj.Load(_SurveyAnswerID)
                If obj.SurveyID <> _SurveyID Then
                    UpdateSurveyID(_SurveyID, cnn)
                    strTemp = "SurveyID Changed to '" & _SurveyID & "' from '" & obj.SurveyID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.SurveyQuestionID <> _SurveyQuestionID Then
                    UpdateSurveyQuestionID(_SurveyQuestionID, cnn)
                    strTemp = "SurveyQuestionID Changed to '" & _SurveyQuestionID & "' from '" & obj.SurveyQuestionID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.WorkOrderID <> _WorkOrderID Then
                    UpdateWorkOrderID(_WorkOrderID, cnn)
                    strTemp = "WorkOrderID Changed to '" & _WorkOrderID & "' from '" & obj.WorkOrderID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.SurveyMethodID <> _SurveyMethodID Then
                    UpdateSurveyMethodID(_SurveyMethodID, cnn)
                    strTemp = "SurveyMethodID Changed to '" & _SurveyMethodID & "' from '" & obj.SurveyMethodID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.SurveyAnswer <> _SurveyAnswer Then
                    UpdateSurveyAnswer(_SurveyAnswer, cnn)
                    strTemp = "SurveyAnswer Changed to '" & _SurveyAnswer & "' from '" & obj.SurveyAnswer & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.SurveyComment <> _SurveyComment Then
                    UpdateSurveyComment(_SurveyComment, cnn)
                    strTemp = "SurveyComment Changed to '" & _SurveyComment & "' from '" & obj.SurveyComment & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.SurveyedBy <> _SurveyedBy Then
                    UpdateSurveyedBy(_SurveyedBy, cnn)
                    strTemp = "SurveyedBy Changed to '" & _SurveyedBy & "' from '" & obj.SurveyedBy & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(_SurveyAnswerID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded SurveyAnswer Record
        ''' </summary>
        Public Sub Delete()
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spRemoveSurveyAnswer")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@SurveyAnswerID", SqlDbType.Int).Value = _SurveyAnswerID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(_SurveyAnswerID)
            End If
        End Sub

#End Region

    End Class
End Namespace