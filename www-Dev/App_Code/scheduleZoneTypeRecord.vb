Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface

    Public Class ScheduleZoneTypeRecord

#Region "Private Constants"

        Private Const DescriptionMaxLength As Integer = 64

#End Region

#Region "Private Members"

        Private _ScheduleZoneTypeID As Long = 0
        Private _Description As String = ""
        Private _ConnectionString As String = ""

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
        ''' Returns the ScheduleZoneTypeID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property ScheduleZoneTypeID() As Long
            Get
                Return _ScheduleZoneTypeID
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
            _ScheduleZoneTypeID = 0
            _Description = ""
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
        Private Sub UpdateDescription(ByVal NewDescription As String, ByRef cnn As sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateScheduleZoneTypeDescription")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@ScheduleZoneTypeID", sqlDBType.int).value = _ScheduleZoneTypeID
            cmd.Parameters.Add("@Description", SqlDbType.nvarchar, TrimTrunc(NewDescription, DescriptionMaxLength).Length).value = TrimTrunc(NewDescription, DescriptionMaxLength)
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
            Dim obj As New ScheduleZoneTypeRecord(_ScheduleZoneTypeID, _ConnectionString)
            obj.load(_ScheduleZoneTypeID)
            If obj.Description <> _Description Then
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
        ''' <param name="lngScheduleZoneTypeID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngScheduleZoneTypeID As Long, ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
            Load(_ScheduleZoneTypeID)
        End Sub

        ''' <summary>
        '''  Adds a new ScheduleZoneType record to the database.
        ''' </summary>
        ''' <param name="strDescription">The value for the Description portion of the record</param>
        Public Sub Add(ByVal strDescription As String)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spAddScheduleZoneType")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngScheduleZoneTypeID As Long = 0
                cmd.Parameters.Add("@Description", SQLDBType.nvarchar, TrimTrunc(strDescription, DescriptionMaxLength).Length).Value = TrimTrunc(strDescription, DescriptionMaxLength)
                cnn.Open()
                cmd.Connection = cnn
                lngScheduleZoneTypeID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngScheduleZoneTypeID > 0 Then
                    Load(lngScheduleZoneTypeID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a ScheduleZoneType record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngScheduleZoneTypeID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spGetScheduleZoneType")
                Dim dtr As SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ScheduleZoneTypeID", SqlDbType.Int).Value = lngScheduleZoneTypeID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _ScheduleZoneTypeID = CType(dtr("ScheduleZoneTypeID"), Long)
                    _Description = dtr("Description").ToString
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
                Dim obj As New ScheduleZoneTypeRecord(_ScheduleZoneTypeID, _ConnectionString)
                obj.Load(_ScheduleZoneTypeID)
                If obj.Description <> _Description Then
                    UpdateDescription(_Description, cnn)
                    strTemp = "Description Changed to '" & _Description & "' from '" & obj.Description & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(_ScheduleZoneTypeID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded ScheduleZoneType Record
        ''' </summary>
        Public Sub Delete()
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spRemoveScheduleZoneType")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ScheduleZoneTypeID", SqlDbType.Int).Value = _ScheduleZoneTypeID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(_ScheduleZoneTypeID)
            End If
        End Sub

#End Region

    End Class

End Namespace