Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class SurveyQuestionAssignmentRecord

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
        ''' <param name="lngSurveyQuestionAssignmentID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngSurveyQuestionAssignmentID As Long, ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
            Load(_SurveyQuestionAssignmentID)
        End Sub

        ''' <summary>
        '''  Adds a new SurveyQuestionAssignment record to the database.
        ''' </summary>
        ''' <param name="lngSurveyID">The value for the SurveyID portion of the record</param>
        ''' <param name="lngSurveyQuestionID">The value for the SurveyQuestionID portion of the record</param>
        Public Sub Add(ByVal lngSurveyID As Long, ByVal lngSurveyQuestionID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spAddSurveyQuestionAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngSurveyQuestionAssignmentID As Long = 0
                cmd.Parameters.Add("@SurveyID", SQLDBType.int).Value = lngSurveyID
                cmd.Parameters.Add("@SurveyQuestionID", SqlDbType.Int).Value = lngSurveyQuestionID
                cnn.Open()
                cmd.Connection = cnn
                lngSurveyQuestionAssignmentID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngSurveyQuestionAssignmentID > 0 Then
                    Load(lngSurveyQuestionAssignmentID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a SurveyQuestionAssignment record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngSurveyQuestionAssignmentID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spGetSurveyQuestionAssignment")
                Dim dtr As SqlClient.SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@SurveyQuestionAssignmentID", SqlDbType.Int).Value = lngSurveyQuestionAssignmentID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _SurveyQuestionAssignmentID = CType(dtr("SurveyQuestionAssignmentID"), Long)
                    _SurveyID = CType(dtr("SurveyID"), Long)
                    _SurveyQuestionID = CType(dtr("SurveyQuestionID"), Long)
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
                Dim obj As New SurveyQuestionAssignmentRecord(_SurveyQuestionAssignmentID, _ConnectionString)
                obj.Load(_SurveyQuestionAssignmentID)
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
                cnn.Close()
                Load(_SurveyQuestionAssignmentID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded SurveyQuestionAssignment Record
        ''' </summary>
        Public Sub Delete()
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spRemoveSurveyQuestionAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@SurveyQuestionAssignmentID", SqlDbType.Int).Value = _SurveyQuestionAssignmentID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(_SurveyQuestionAssignmentID)
            End If
        End Sub

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
        ''' Returns the SurveyQuestionAssignmentID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property SurveyQuestionAssignmentID() As Long
            Get
                Return _SurveyQuestionAssignmentID
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
            _SurveyQuestionAssignmentID = 0
            _SurveyID = 0
            _SurveyQuestionID = 0
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
            Dim cmd As New sqlClient.sqlCommand("spUpdateSurveyQuestionAssignmentSurveyID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@SurveyQuestionAssignmentID", sqlDBType.int).value = _SurveyQuestionAssignmentID
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
            Dim cmd As New sqlClient.sqlCommand("spUpdateSurveyQuestionAssignmentSurveyQuestionID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@SurveyQuestionAssignmentID", sqlDBType.int).value = _SurveyQuestionAssignmentID
            cmd.Parameters.Add("@SurveyQuestionID", SqlDbType.Int).Value = NewSurveyQuestionID
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
            Dim obj As New SurveyQuestionAssignmentRecord(_SurveyQuestionAssignmentID, _ConnectionString)
            obj.Load(_SurveyQuestionAssignmentID)
            If obj.SurveyID <> _SurveyID Then
                blnReturn = True
            End If
            If obj.SurveyQuestionID <> _SurveyQuestionID Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

#End Region


#Region "Private Members"

        Private _SurveyQuestionAssignmentID As Long = 0
        Private _SurveyID As Long = 0
        Private _SurveyQuestionID As Long = 0
        Private _ConnectionString As String = ""

#End Region
    End Class
End Namespace