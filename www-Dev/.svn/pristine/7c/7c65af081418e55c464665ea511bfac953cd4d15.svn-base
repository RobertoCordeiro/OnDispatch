Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class SurveyRecord


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
        ''' <param name="lngSurveyID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngSurveyID As Long, ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
            Load(_SurveyID)
        End Sub

        ''' <summary>
        '''  Adds a new Survey record to the database.
        ''' </summary>
        ''' <param name="lngSurveyTypeID">The value for the SurveyTypeID portion of the record</param>
        ''' <param name="strSurveyName">The value for the SurveyName portion of the record</param>
        Public Sub Add(ByVal lngSurveyTypeID As Long, ByVal strSurveyName As String)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spAddSurvey")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngSurveyID As Long = 0
                cmd.Parameters.Add("@SurveyTypeID", SQLDBType.int).Value = lngSurveyTypeID
                cmd.Parameters.Add("@SurveyName", SQLDBType.varchar, TrimTrunc(strSurveyName, SurveyNameMaxLength).Length).Value = TrimTrunc(strSurveyName, SurveyNameMaxLength)
                cnn.Open()
                cmd.Connection = cnn
                lngSurveyID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngSurveyID > 0 Then
                    Load(lngSurveyID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a Survey record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngSurveyID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spGetSurvey")
                Dim dtr As SqlClient.SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@SurveyID", SqlDbType.Int).Value = lngSurveyID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _SurveyID = CType(dtr("SurveyID"), Long)
                    _SurveyTypeID = CType(dtr("SurveyTypeID"), Long)
                    _SurveyName = dtr("SurveyName").ToString
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
                Dim obj As New SurveyRecord(_SurveyID, _ConnectionString)
                obj.Load(_SurveyID)
                If obj.SurveyTypeID <> _SurveyTypeID Then
                    UpdateSurveyTypeID(_SurveyTypeID, cnn)
                    strTemp = "SurveyTypeID Changed to '" & _SurveyTypeID & "' from '" & obj.SurveyTypeID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.SurveyName <> _SurveyName Then
                    UpdateSurveyName(_SurveyName, cnn)
                    strTemp = "SurveyName Changed to '" & _SurveyName & "' from '" & obj.SurveyName & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(_SurveyID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded Survey Record
        ''' </summary>
        Public Sub Delete()
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spRemoveSurvey")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@SurveyID", SqlDbType.Int).Value = _SurveyID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(_SurveyID)
            End If
        End Sub

#End Region

#Region "Read/Write Properties"

        ''' <summary>
        ''' Returns/Sets the SurveyTypeID field for the currently loaded record
        ''' </summary>
        Public Property SurveyTypeID() As Long
            Get
                Return _SurveyTypeID
            End Get
            Set(ByVal value As Long)
                _SurveyTypeID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the SurveyName field for the currently loaded record
        ''' </summary>
        Public Property SurveyName() As String
            Get
                Return _SurveyName
            End Get
            Set(ByVal value As String)
                _SurveyName = TrimTrunc(value, SurveyNameMaxLength)
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
        ''' Returns the SurveyID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property SurveyID() As Long
            Get
                Return _SurveyID
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
            _SurveyID = 0
            _SurveyTypeID = 0
            _SurveyName = ""
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
        ''' Updates the SurveyTypeID field for this record.
        ''' </summary>
        ''' <param name="NewSurveyTypeID">The new value for theSurveyTypeID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateSurveyTypeID(ByVal NewSurveyTypeID As Long, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateSurveySurveyTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@SurveyID", sqlDBType.int).value = _SurveyID
            cmd.Parameters.Add("@SurveyTypeID", SqlDbType.int).value = NewSurveyTypeID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the SurveyName field for this record.
        ''' </summary>
        ''' <param name="NewSurveyName">The new value for theSurveyName field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateSurveyName(ByVal NewSurveyName As String, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateSurveySurveyName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@SurveyID", sqlDBType.int).value = _SurveyID
            cmd.Parameters.Add("@SurveyName", SqlDbType.varchar, TrimTrunc(NewSurveyName, SurveyNameMaxLength).Length).value = TrimTrunc(NewSurveyName, SurveyNameMaxLength)
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
            Dim obj As New SurveyRecord(_SurveyID, _ConnectionString)
            obj.Load(_SurveyID)
            If obj.SurveyTypeID <> _SurveyTypeID Then
                blnReturn = True
            End If
            If obj.SurveyName <> _SurveyName Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

#End Region


#Region "Private Constants"

        Private Const SurveyNameMaxLength As Integer = 50

#End Region

#Region "Private Members"

        Private _SurveyID As Long = 0
        Private _SurveyTypeID As Long = 0
        Private _SurveyName As String = ""
        Private _ConnectionString As String = ""

#End Region
    End Class
End Namespace
