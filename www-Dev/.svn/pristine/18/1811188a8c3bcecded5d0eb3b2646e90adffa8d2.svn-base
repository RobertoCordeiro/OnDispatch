Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface

    Public Class SurveyQuestionTypeRecord

#Region "Private Constants"

        Private Const QuestionTypeMaxLength As Integer = 256

#End Region

#Region "Private Members"

        Private _SurveyQuestionTypeID As Long = 0
        Private _QuestionType As String = ""
        Private _ConnectionString As String = ""

#End Region

#Region "Read/Write Properties"

        ''' <summary>
        ''' Returns/Sets the QuestionType field for the currently loaded record
        ''' </summary>
        Public Property QuestionType() As String
            Get
                Return _QuestionType
            End Get
            Set(ByVal value As String)
                _QuestionType = TrimTrunc(value, QuestionTypeMaxLength)
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
        ''' Returns the SurveyQuestionTypeID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property SurveyQuestionTypeID() As Long
            Get
                Return _SurveyQuestionTypeID
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
            _SurveyQuestionTypeID = 0
            _QuestionType = ""
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
        ''' Updates the QuestionType field for this record.
        ''' </summary>
        ''' <param name="NewQuestionType">The new value for theQuestionType field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateQuestionType(ByVal NewQuestionType As String, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateSurveyQuestionTypeQuestionType")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@SurveyQuestionTypeID", sqlDBType.int).value = _SurveyQuestionTypeID
            cmd.Parameters.Add("@QuestionType", SqlDbType.nvarchar, TrimTrunc(NewQuestionType, QuestionTypeMaxLength).Length).value = TrimTrunc(NewQuestionType, QuestionTypeMaxLength)
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
            Dim obj As New SurveyQuestionTypeRecord(_SurveyQuestionTypeID, _ConnectionString)
            obj.Load(_SurveyQuestionTypeID)
            If obj.QuestionType <> _QuestionType Then
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
        ''' <param name="lngSurveyQuestionTypeID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngSurveyQuestionTypeID As Long, ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
            Load(_SurveyQuestionTypeID)
        End Sub

        ''' <summary>
        '''  Adds a new SurveyQuestionType record to the database.
        ''' </summary>
        ''' <param name="strQuestionType">The value for the QuestionType portion of the record</param>
        Public Sub Add(ByVal strQuestionType As String)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spAddSurveyQuestionType")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngSurveyQuestionTypeID As Long = 0
                cmd.Parameters.Add("@QuestionType", SQLDBType.nvarchar, TrimTrunc(strQuestionType, QuestionTypeMaxLength).Length).Value = TrimTrunc(strQuestionType, QuestionTypeMaxLength)
                cnn.Open()
                cmd.Connection = cnn
                lngSurveyQuestionTypeID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngSurveyQuestionTypeID > 0 Then
                    Load(lngSurveyQuestionTypeID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a SurveyQuestionType record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngSurveyQuestionTypeID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spGetSurveyQuestionType")
                Dim dtr As SqlClient.SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@SurveyQuestionTypeID", SqlDbType.Int).Value = lngSurveyQuestionTypeID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _SurveyQuestionTypeID = CType(dtr("SurveyQuestionTypeID"), Long)
                    _QuestionType = dtr("QuestionType").ToString
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
                Dim obj As New SurveyQuestionTypeRecord(_SurveyQuestionTypeID, _ConnectionString)
                obj.Load(_SurveyQuestionTypeID)
                If obj.QuestionType <> _QuestionType Then
                    UpdateQuestionType(_QuestionType, cnn)
                    strTemp = "QuestionType Changed to '" & _QuestionType & "' from '" & obj.QuestionType & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(_SurveyQuestionTypeID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded SurveyQuestionType Record
        ''' </summary>
        Public Sub Delete()
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spRemoveSurveyQuestionType")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@SurveyQuestionTypeID", SqlDbType.Int).Value = _SurveyQuestionTypeID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(_SurveyQuestionTypeID)
            End If
        End Sub

#End Region

    End Class
End Namespace