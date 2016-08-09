Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface

    Public Class ScheduleAvailabilityCodeRecord

#Region "Private Constants"

        Private Const CodeNameMaxLength As Integer = 16
        Private Const CodeMaxLength As Integer = 3
        Private Const CodeName_ptMaxLength As Integer = 16
        Private Const CodeName_spMaxLength As Integer = 16

#End Region

#Region "Private Members"

        Private _ScheduleAvailabilityCodeID As Long = 0
        Private _CodeName As String = ""
        Private _Code As String = ""
        Private _CodeName_pt As String = ""
        Private _CodeName_sp As String = ""
        Private _ConnectionString As String = ""

#End Region

#Region "Read/Write Properties"

        ''' <summary>
        ''' Returns/Sets the CodeName field for the currently loaded record
        ''' </summary>
        Public Property CodeName() As String
            Get
                Return _CodeName
            End Get
            Set(ByVal value As String)
                _CodeName = TrimTrunc(value, CodeNameMaxLength)
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the Code field for the currently loaded record
        ''' </summary>
        Public Property Code() As String
            Get
                Return _Code
            End Get
            Set(ByVal value As String)
                _Code = TrimTrunc(value, CodeMaxLength)
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the CodeName_pt field for the currently loaded record
        ''' </summary>
        Public Property CodeName_pt() As String
            Get
                Return _CodeName_pt
            End Get
            Set(ByVal value As String)
                _CodeName_pt = TrimTrunc(value, CodeName_ptMaxLength)
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the CodeName_sp field for the currently loaded record
        ''' </summary>
        Public Property CodeName_sp() As String
            Get
                Return _CodeName_sp
            End Get
            Set(ByVal value As String)
                _CodeName_sp = TrimTrunc(value, CodeName_spMaxLength)
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
        ''' Returns the ScheduleAvailabilityCodeID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property ScheduleAvailabilityCodeID() As Long
            Get
                Return _ScheduleAvailabilityCodeID
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
            _ScheduleAvailabilityCodeID = 0
            _CodeName = ""
            _Code = ""
            _CodeName_pt = ""
            _CodeName_sp = ""
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
        ''' Updates the CodeName field for this record.
        ''' </summary>
        ''' <param name="NewCodeName">The new value for theCodeName field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateCodeName(ByVal NewCodeName As String, ByRef cnn As sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateScheduleAvailabilityCodeCodeName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@ScheduleAvailabilityCodeID", sqlDBType.int).value = _ScheduleAvailabilityCodeID
            cmd.Parameters.Add("@CodeName", SqlDbType.varchar, TrimTrunc(NewCodeName, CodeNameMaxLength).Length).value = TrimTrunc(NewCodeName, CodeNameMaxLength)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the Code field for this record.
        ''' </summary>
        ''' <param name="NewCode">The new value for theCode field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateCode(ByVal NewCode As String, ByRef cnn As sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateScheduleAvailabilityCodeCode")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@ScheduleAvailabilityCodeID", sqlDBType.int).value = _ScheduleAvailabilityCodeID
            cmd.Parameters.Add("@Code", SqlDbType.varchar, TrimTrunc(NewCode, CodeMaxLength).Length).value = TrimTrunc(NewCode, CodeMaxLength)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the CodeName_pt field for this record.
        ''' </summary>
        ''' <param name="NewCodeName_pt">The new value for theCodeName_pt field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateCodeName_pt(ByVal NewCodeName_pt As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlClient.SqlCommand("spUpdateScheduleAvailabilityCodeCodeName_pt")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ScheduleAvailabilityCodeID", SqlDbType.Int).Value = _ScheduleAvailabilityCodeID
            cmd.Parameters.Add("@CodeName_pt", SqlDbType.VarChar, TrimTrunc(NewCodeName_pt, CodeName_ptMaxLength).Length).Value = TrimTrunc(NewCodeName_pt, CodeName_ptMaxLength)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the CodeName_sp field for this record.
        ''' </summary>
        ''' <param name="NewCodeName_sp">The new value for theCodeName_sp field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateCodeName_sp(ByVal NewCodeName_sp As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlClient.SqlCommand("spUpdateScheduleAvailabilityCodeCodeName_sp")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ScheduleAvailabilityCodeID", SqlDbType.Int).Value = _ScheduleAvailabilityCodeID
            cmd.Parameters.Add("@CodeName_sp", SqlDbType.VarChar, TrimTrunc(NewCodeName_sp, CodeName_spMaxLength).Length).Value = TrimTrunc(NewCodeName_sp, CodeName_spMaxLength)
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
            Dim obj As New ScheduleAvailabilityCodeRecord(_ScheduleAvailabilityCodeID, _ConnectionString)
            obj.Load(_ScheduleAvailabilityCodeID)
            If obj.CodeName <> _CodeName Then
                blnReturn = True
            End If
            If obj.Code <> _Code Then
                blnReturn = True
            End If
            If obj.CodeName_pt <> _CodeName_pt Then
                blnReturn = True
            End If
            If obj.CodeName_sp <> _CodeName_sp Then
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
        ''' <param name="lngScheduleAvailabilityCodeID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngScheduleAvailabilityCodeID As Long, ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
            Load(_ScheduleAvailabilityCodeID)
        End Sub

        ''' <summary>
        '''  Adds a new ScheduleAvailabilityCode record to the database.
        ''' </summary>
        ''' <param name="strCodeName">The value for the CodeName portion of the record</param>
        ''' <param name="strCode">The value for the Code portion of the record</param>
        ''' <param name="strCodeName_pt">The value for the CodeName_pt portion of the record</param>
        ''' <param name="strCodeName_sp">The value for the CodeName_sp portion of the record</param>
        Public Sub Add(ByVal strCodeName As String, ByVal strCode As String, ByVal strCodeName_pt As String, ByVal strCodeName_sp As String)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spAddScheduleAvailabilityCode")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngScheduleAvailabilityCodeID As Long = 0
                cmd.Parameters.Add("@CodeName", SQLDBType.varchar, TrimTrunc(strCodeName, CodeNameMaxLength).Length).Value = TrimTrunc(strCodeName, CodeNameMaxLength)
                cmd.Parameters.Add("@Code", SQLDBType.varchar, TrimTrunc(strCode, CodeMaxLength).Length).Value = TrimTrunc(strCode, CodeMaxLength)
                cmd.Parameters.Add("@CodeName_pt", SQLDBType.varchar, TrimTrunc(strCodeName_pt, CodeName_ptMaxLength).Length).Value = TrimTrunc(strCodeName_pt, CodeName_ptMaxLength)
                cmd.Parameters.Add("@CodeName_sp", SQLDBType.varchar, TrimTrunc(strCodeName_sp, CodeName_spMaxLength).Length).Value = TrimTrunc(strCodeName_sp, CodeName_spMaxLength)
                cnn.Open()
                cmd.Connection = cnn
                lngScheduleAvailabilityCodeID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngScheduleAvailabilityCodeID > 0 Then
                    Load(lngScheduleAvailabilityCodeID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a ScheduleAvailabilityCode record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngScheduleAvailabilityCodeID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spGetScheduleAvailabilityCode")
                Dim dtr As SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ScheduleAvailabilityCodeID", SqlDbType.Int).Value = lngScheduleAvailabilityCodeID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _ScheduleAvailabilityCodeID = CType(dtr("ScheduleAvailabilityCodeID"), Long)
                    _CodeName = dtr("CodeName").ToString
                    _Code = dtr("Code").ToString
                    _CodeName_pt = dtr("CodeName_pt").ToString
                    _CodeName_sp = dtr("CodeName_sp").ToString
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
                Dim obj As New ScheduleAvailabilityCodeRecord(_ScheduleAvailabilityCodeID, _ConnectionString)
                obj.Load(_ScheduleAvailabilityCodeID)
                If obj.CodeName <> _CodeName Then
                    UpdateCodeName(_CodeName, cnn)
                    strTemp = "CodeName Changed to '" & _CodeName & "' from '" & obj.CodeName & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.Code <> _Code Then
                    UpdateCode(_Code, cnn)
                    strTemp = "Code Changed to '" & _Code & "' from '" & obj.Code & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.CodeName_pt <> _CodeName_pt Then
                    UpdateCodeName_pt(_CodeName_pt, cnn)
                    strTemp = "CodeName_pt Changed to '" & _CodeName_pt & "' from '" & obj.CodeName_pt & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.CodeName_sp <> _CodeName_sp Then
                    UpdateCodeName_sp(_CodeName_sp, cnn)
                    strTemp = "CodeName_sp Changed to '" & _CodeName_sp & "' from '" & obj.CodeName_sp & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(_ScheduleAvailabilityCodeID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded ScheduleAvailabilityCode Record
        ''' </summary>
        Public Sub Delete()
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spRemoveScheduleAvailabilityCode")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ScheduleAvailabilityCodeID", SqlDbType.Int).Value = _ScheduleAvailabilityCodeID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(_ScheduleAvailabilityCodeID)
            End If
        End Sub

#End Region

    End Class
End Namespace