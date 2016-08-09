Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class SurveyTypeRecord

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
        ''' <param name="lngSurveyTypeID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngSurveyTypeID As Long, ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
            Load(_SurveyTypeID)
        End Sub

        ''' <summary>
        '''  Adds a new SurveyType record to the database.
        ''' </summary>
        ''' <param name="strSurveyType">The value for the SurveyType portion of the record</param>
        Public Sub Add(ByVal strSurveyType As String)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spAddSurveyType")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngSurveyTypeID As Long = 0
                cmd.Parameters.Add("@SurveyType", SQLDBType.varchar, TrimTrunc(strSurveyType, SurveyTypeMaxLength).Length).Value = TrimTrunc(strSurveyType, SurveyTypeMaxLength)
                cnn.Open()
                cmd.Connection = cnn
                lngSurveyTypeID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngSurveyTypeID > 0 Then
                    Load(lngSurveyTypeID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a SurveyType record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngSurveyTypeID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spGetSurveyType")
                Dim dtr As SqlClient.SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@SurveyTypeID", SqlDbType.Int).Value = lngSurveyTypeID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _SurveyTypeID = CType(dtr("SurveyTypeID"), Long)
                    _SurveyType = dtr("SurveyType").ToString
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
                Dim obj As New SurveyTypeRecord(_SurveyTypeID, _ConnectionString)
                obj.Load(_SurveyTypeID)
                If obj.SurveyType <> _SurveyType Then
                    UpdateSurveyType(_SurveyType, cnn)
                    strTemp = "SurveyType Changed to '" & _SurveyType & "' from '" & obj.SurveyType & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(_SurveyTypeID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded SurveyType Record
        ''' </summary>
        Public Sub Delete()
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spRemoveSurveyType")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@SurveyTypeID", SqlDbType.Int).Value = _SurveyTypeID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(_SurveyTypeID)
            End If
        End Sub

#End Region


#Region "Read/Write Properties"

        ''' <summary>
        ''' Returns/Sets the SurveyType field for the currently loaded record
        ''' </summary>
        Public Property SurveyType() As String
            Get
                Return _SurveyType
            End Get
            Set(ByVal value As String)
                _SurveyType = TrimTrunc(value, SurveyTypeMaxLength)
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
        ''' Returns the SurveyTypeID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property SurveyTypeID() As Long
            Get
                Return _SurveyTypeID
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
            _SurveyTypeID = 0
            _SurveyType = ""
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
        ''' Updates the SurveyType field for this record.
        ''' </summary>
        ''' <param name="NewSurveyType">The new value for theSurveyType field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateSurveyType(ByVal NewSurveyType As String, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateSurveyTypeSurveyType")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@SurveyTypeID", sqlDBType.int).value = _SurveyTypeID
            cmd.Parameters.Add("@SurveyType", SqlDbType.varchar, TrimTrunc(NewSurveyType, SurveyTypeMaxLength).Length).value = TrimTrunc(NewSurveyType, SurveyTypeMaxLength)
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
            Dim obj As New SurveyTypeRecord(_SurveyTypeID, _ConnectionString)
            obj.Load(_SurveyTypeID)
            If obj.SurveyType <> _SurveyType Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

#End Region


#Region "Private Constants"

        Private Const SurveyTypeMaxLength As Integer = 50

#End Region

#Region "Private Members"

        Private _SurveyTypeID As Long = 0
        Private _SurveyType As String = ""
        Private _ConnectionString As String = ""

#End Region
    End Class
End Namespace