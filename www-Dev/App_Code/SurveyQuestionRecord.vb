Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class SurveyQuestionRecord

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
        ''' <param name="lngSurveyQuestionID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngSurveyQuestionID As Long, ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
            Load(_SurveyQuestionID)
        End Sub

        ''' <summary>
        '''  Adds a new SurveyQuestion record to the database.
        ''' </summary>
        ''' <param name="strDescription">The value for the Description portion of the record</param>
        ''' <param name="blnActive">The value for the Active portion of the record</param>
        Public Sub Add(ByVal strDescription As String, ByVal blnActive As Boolean, ByVal lngSurveyQuestionTypeID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spAddSurveyQuestion")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngSurveyQuestionID As Long = 0
                cmd.Parameters.Add("@Description", SqlDbType.VarChar, TrimTrunc(strDescription, DescriptionMaxLength).Length).Value = TrimTrunc(strDescription, DescriptionMaxLength)
                cmd.Parameters.Add("@Active", SqlDbType.Bit).Value = blnActive
                cmd.Parameters.Add("@SurveyQuestionTypeID", SqlDbType.Int).Value = lngSurveyQuestionTypeID
                cnn.Open()
                cmd.Connection = cnn
                lngSurveyQuestionID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngSurveyQuestionID > 0 Then
                    Load(lngSurveyQuestionID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a SurveyQuestion record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngSurveyQuestionID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spGetSurveyQuestion")
                Dim dtr As SqlClient.SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@SurveyQuestionID", SqlDbType.Int).Value = lngSurveyQuestionID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _SurveyQuestionID = CType(dtr("SurveyQuestionID"), Long)
                    _Description = dtr("Description").ToString
                    _Active = CType(dtr("Active"), Boolean)
                    _SurveyQuestionTypeID = CType(dtr("SurveyQuestionTypeID"), Long)
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
                Dim obj As New SurveyQuestionRecord(_SurveyQuestionID, _ConnectionString)
                obj.Load(_SurveyQuestionID)
                If obj.Description <> _Description Then
                    UpdateDescription(_Description, cnn)
                    strTemp = "Description Changed to '" & _Description & "' from '" & obj.Description & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.Active <> _Active Then
                    UpdateActive(_Active, cnn)
                    strTemp = "Active Changed to '" & _Active & "' from '" & obj.Active & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.SurveyQuestionTypeID <> _SurveyQuestionTypeID Then
                    UpdateSurveyQuestionTypeID(_SurveyQuestionTypeID, cnn)
                    strTemp = "SurveyQuestionTypeID Changed to '" & _SurveyQuestionTypeID & "' from '" & obj.SurveyQuestionTypeID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If

                cnn.Close()
                Load(_SurveyQuestionID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded SurveyQuestion Record
        ''' </summary>
        Public Sub Delete()
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spRemoveSurveyQuestion")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@SurveyQuestionID", SqlDbType.Int).Value = _SurveyQuestionID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(_SurveyQuestionID)
            End If
        End Sub

#End Region


#Region "Read/Write Properties"

        ''' <summary>
        ''' Returns/Sets the Description field for the currently loaded record
        ''' </summary>
        Public Property Description() As String
            Get
                Return _Description
            End Get
            Set(ByVal value As String)
                _Description = TrimTrunc(value, DescriptionMaxLength)
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
        ''' Returns/Sets the SurveyQuestionTypeID field for the currently loaded record
        ''' </summary>
        Public Property SurveyQuestionTypeID() As Long
            Get
                Return _SurveyQuestionTypeID
            End Get
            Set(ByVal value As Long)
                _SurveyQuestionTypeID = value
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
        ''' Returns the SurveyQuestionID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property SurveyQuestionID() As Long
            Get
                Return _SurveyQuestionID
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
            _SurveyQuestionID = 0
            _Description = ""
            _Active = False
            _SurveyQuestionTypeID = 0
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
        ''' Updates the Description field for this record.
        ''' </summary>
        ''' <param name="NewDescription">The new value for theDescription field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateDescription(ByVal NewDescription As String, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateSurveyQuestionDescription")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@SurveyQuestionID", sqlDBType.int).value = _SurveyQuestionID
            cmd.Parameters.Add("@Description", SqlDbType.varchar, TrimTrunc(NewDescription, DescriptionMaxLength).Length).value = TrimTrunc(NewDescription, DescriptionMaxLength)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the Active field for this record.
        ''' </summary>
        ''' <param name="NewActive">The new value for theActive field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateActive(ByVal NewActive As Boolean, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateSurveyQuestionActive")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@SurveyQuestionID", sqlDBType.int).value = _SurveyQuestionID
            cmd.Parameters.Add("@Active", SqlDbType.bit).value = NewActive
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the SurveyQuestionTypeID field for this record.
        ''' </summary>
        ''' <param name="NewSurveyQuestionTypeID">The new value for theSurveyQuestionTypeID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateSurveyQuestionTypeID(ByVal NewSurveyQuestionTypeID As Long, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateSurveyQuestionSurveyQuestionTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@SurveyQuestionID", sqlDBType.int).value = _SurveyQuestionID
            cmd.Parameters.Add("@SurveyQuestionTypeID", SqlDbType.int).value = NewSurveyQuestionTypeID
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
            Dim obj As New SurveyQuestionRecord(_SurveyQuestionID, _ConnectionString)
            obj.Load(_SurveyQuestionID)
            If obj.Description <> _Description Then
                blnReturn = True
            End If
            If obj.Active <> _Active Then
                blnReturn = True
            End If
            If obj.SurveyQuestionTypeID <> _SurveyQuestionTypeID Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

#End Region


#Region "Private Constants"

        Private Const DescriptionMaxLength As Integer = 50

#End Region

#Region "Private Members"

        Private _SurveyQuestionID As Long = 0
        Private _Description As String = ""
        Private _Active As Boolean = False
        Private _SurveyQuestionTypeID As Long = 0
        Private _ConnectionString As String = ""

#End Region
    End Class
End Namespace