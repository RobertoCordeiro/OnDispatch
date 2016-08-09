Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface

    Public Class SurveyMethodRecord
#Region "Private Constants"

        Private Const SurveyMethodMaxLength As Integer = 128

#End Region

#Region "Private Members"

        Private _SurveyMethodID As Long = 0
        Private _SurveyMethod As String = ""
        Private _Active As Boolean = False
        Private _ConnectionString As String = ""

#End Region

#Region "Read/Write Properties"

        ''' <summary>
        ''' Returns/Sets the SurveyMethod field for the currently loaded record
        ''' </summary>
        Public Property SurveyMethod() As String
            Get
                Return _SurveyMethod
            End Get
            Set(ByVal value As String)
                _SurveyMethod = TrimTrunc(value, SurveyMethodMaxLength)
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
        ''' Returns the SurveyMethodID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property SurveyMethodID() As Long
            Get
                Return _SurveyMethodID
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
            _SurveyMethodID = 0
            _SurveyMethod = ""
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
        ''' Updates the SurveyMethod field for this record.
        ''' </summary>
        ''' <param name="NewSurveyMethod">The new value for theSurveyMethod field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateSurveyMethod(ByVal NewSurveyMethod As String, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateSurveyMethodSurveyMethod")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@SurveyMethodID", sqlDBType.int).value = _SurveyMethodID
            cmd.Parameters.Add("@SurveyMethod", SqlDbType.nvarchar, TrimTrunc(NewSurveyMethod, SurveyMethodMaxLength).Length).value = TrimTrunc(NewSurveyMethod, SurveyMethodMaxLength)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the Active field for this record.
        ''' </summary>
        ''' <param name="NewActive">The new value for theActive field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateActive(ByVal NewActive As Boolean, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateSurveyMethodActive")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@SurveyMethodID", sqlDBType.int).value = _SurveyMethodID
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
            Dim obj As New SurveyMethodRecord(_SurveyMethodID, _ConnectionString)
            obj.load(_SurveyMethodID)
            If obj.SurveyMethod <> _SurveyMethod Then
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
        ''' <param name="lngSurveyMethodID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngSurveyMethodID As Long, ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
            Load(_SurveyMethodID)
        End Sub

        ''' <summary>
        '''  Adds a new SurveyMethod record to the database.
        ''' </summary>
        ''' <param name="strSurveyMethod">The value for the SurveyMethod portion of the record</param>
        ''' <param name="blnActive">The value for the Active portion of the record</param>
        Public Sub Add(ByVal strSurveyMethod As String, ByVal blnActive As Boolean)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spAddSurveyMethod")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngSurveyMethodID As Long = 0
                cmd.Parameters.Add("@SurveyMethod", SQLDBType.nvarchar, TrimTrunc(strSurveyMethod, SurveyMethodMaxLength).Length).Value = TrimTrunc(strSurveyMethod, SurveyMethodMaxLength)
                cmd.Parameters.Add("@Active", SQLDBType.bit).Value = blnActive
                cnn.Open()
                cmd.Connection = cnn
                lngSurveyMethodID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngSurveyMethodID > 0 Then
                    Load(lngSurveyMethodID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a SurveyMethod record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngSurveyMethodID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spGetSurveyMethod")
                Dim dtr As SqlClient.SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@SurveyMethodID", SqlDbType.Int).Value = lngSurveyMethodID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _SurveyMethodID = CType(dtr("SurveyMethodID"), Long)
                    _SurveyMethod = dtr("SurveyMethod").ToString
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
                Dim obj As New SurveyMethodRecord(_SurveyMethodID, _ConnectionString)
                obj.load(_SurveyMethodID)
                If obj.SurveyMethod <> _SurveyMethod Then
                    UpdateSurveyMethod(_SurveyMethod, cnn)
                    strTemp = "SurveyMethod Changed to '" & _SurveyMethod & "' from '" & obj.SurveyMethod & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.Active <> _Active Then
                    UpdateActive(_Active, cnn)
                    strTemp = "Active Changed to '" & _Active & "' from '" & obj.Active & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(_SurveyMethodID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded SurveyMethod Record
        ''' </summary>
        Public Sub Delete()
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spRemoveSurveyMethod")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@SurveyMethodID", SqlDbType.Int).Value = _SurveyMethodID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(_SurveyMethodID)
            End If
        End Sub

#End Region

    End Class
End Namespace