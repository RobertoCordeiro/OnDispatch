Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface

    Public Class ScheduleZoneTemplateRecord
#Region "Private Constants"

        Private Const ZoneNameMaxLength As Integer = 16

#End Region

#Region "Private Members"

        Private _ScheduleZonetemplateID As Long = 0
        Private _ZoneName As String = ""
        Private _StartScheduleTime As Date = DateTime.Now
        Private _EndScheduleTime As Date = DateTime.Now
        Private _Active As Boolean = False
        Private _ConnectionString As String = ""

#End Region

#Region "Read/Write Properties"

        ''' <summary>
        ''' Returns/Sets the ZoneName field for the currently loaded record
        ''' </summary>
        Public Property ZoneName() As String
            Get
                Return _ZoneName
            End Get
            Set(ByVal value As String)
                _ZoneName = TrimTrunc(value, ZoneNameMaxLength)
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the StartScheduleTime field for the currently loaded record
        ''' </summary>
        Public Property StartScheduleTime() As Date
            Get
                Return _StartScheduleTime
            End Get
            Set(ByVal value As Date)
                _StartScheduleTime = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the EndScheduleTime field for the currently loaded record
        ''' </summary>
        Public Property EndScheduleTime() As Date
            Get
                Return _EndScheduleTime
            End Get
            Set(ByVal value As Date)
                _EndScheduleTime = value
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
        ''' Returns the ScheduleZonetemplateID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property ScheduleZonetemplateID() As Long
            Get
                Return _ScheduleZonetemplateID
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
            _ScheduleZonetemplateID = 0
            _ZoneName = ""
            _StartScheduleTime = DateTime.Now
            _EndScheduleTime = DateTime.Now
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
        ''' Updates the ZoneName field for this record.
        ''' </summary>
        ''' <param name="NewZoneName">The new value for theZoneName field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateZoneName(ByVal NewZoneName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateScheduleZoneTemplateZoneName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ScheduleZonetemplateID", SqlDbType.Int).Value = _ScheduleZonetemplateID
            cmd.Parameters.Add("@ZoneName", SqlDbType.VarChar, TrimTrunc(NewZoneName, ZoneNameMaxLength).Length).Value = TrimTrunc(NewZoneName, ZoneNameMaxLength)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the StartScheduleTime field for this record.
        ''' </summary>
        ''' <param name="NewStartScheduleTime">The new value for theStartScheduleTime field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateStartScheduleTime(ByVal NewStartScheduleTime As Date, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateScheduleZoneTemplateStartScheduleTime")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ScheduleZonetemplateID", SqlDbType.Int).Value = _ScheduleZonetemplateID
            cmd.Parameters.Add("@StartScheduleTime", SqlDbType.DateTime).Value = NewStartScheduleTime
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the EndScheduleTime field for this record.
        ''' </summary>
        ''' <param name="NewEndScheduleTime">The new value for theEndScheduleTime field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateEndScheduleTime(ByVal NewEndScheduleTime As Date, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateScheduleZoneTemplateEndScheduleTime")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ScheduleZonetemplateID", SqlDbType.Int).Value = _ScheduleZonetemplateID
            cmd.Parameters.Add("@EndScheduleTime", SqlDbType.DateTime).Value = NewEndScheduleTime
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the Active field for this record.
        ''' </summary>
        ''' <param name="NewActive">The new value for theActive field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateActive(ByVal NewActive As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateScheduleZoneTemplateActive")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ScheduleZonetemplateID", SqlDbType.Int).Value = _ScheduleZonetemplateID
            cmd.Parameters.Add("@Active", SqlDbType.Bit).Value = NewActive
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
            Dim obj As New ScheduleZoneTemplateRecord(_ScheduleZonetemplateID, _ConnectionString)
            obj.Load(_ScheduleZonetemplateID)
            If obj.ZoneName <> _ZoneName Then
                blnReturn = True
            End If
            If obj.StartScheduleTime <> _StartScheduleTime Then
                blnReturn = True
            End If
            If obj.EndScheduleTime <> _EndScheduleTime Then
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
        ''' <param name="lngScheduleZonetemplateID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngScheduleZonetemplateID As Long, ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
            Load(_ScheduleZonetemplateID)
        End Sub

        ''' <summary>
        '''  Adds a new ScheduleZoneTemplate record to the database.
        ''' </summary>
        ''' <param name="strZoneName">The value for the ZoneName portion of the record</param>
        ''' <param name="datStartScheduleTime">The value for the StartScheduleTime portion of the record</param>
        ''' <param name="datEndScheduleTime">The value for the EndScheduleTime portion of the record</param>
        ''' <param name="blnActive">The value for the Active portion of the record</param>
        Public Sub Add(ByVal strZoneName As String, ByVal datStartScheduleTime As Date, ByVal datEndScheduleTime As Date, ByVal blnActive As Boolean)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spAddScheduleZoneTemplate")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngScheduleZonetemplateID As Long = 0
                cmd.Parameters.Add("@ZoneName", SQLDBType.varchar, TrimTrunc(strZoneName, ZoneNameMaxLength).Length).Value = TrimTrunc(strZoneName, ZoneNameMaxLength)
                cmd.Parameters.Add("@StartScheduleTime", SQLDBType.datetime).Value = datStartScheduleTime
                cmd.Parameters.Add("@EndScheduleTime", SQLDBType.datetime).Value = datEndScheduleTime
                cmd.Parameters.Add("@Active", SQLDBType.bit).Value = blnActive
                cnn.Open()
                cmd.Connection = cnn
                lngScheduleZonetemplateID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngScheduleZonetemplateID > 0 Then
                    Load(lngScheduleZonetemplateID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a ScheduleZoneTemplate record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngScheduleZonetemplateID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spGetScheduleZoneTemplate")
                Dim dtr As SqlClient.SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ScheduleZonetemplateID", SqlDbType.Int).Value = lngScheduleZonetemplateID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _ScheduleZonetemplateID = CType(dtr("ScheduleZonetemplateID"), Long)
                    _ZoneName = dtr("ZoneName").ToString
                    _StartScheduleTime = CType(dtr("StartScheduleTime"), Date)
                    _EndScheduleTime = CType(dtr("EndScheduleTime"), Date)
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
                Dim cnn As New SqlConnection(_ConnectionString)
                cnn.Open()
                Dim obj As New ScheduleZoneTemplateRecord(_ScheduleZonetemplateID, _ConnectionString)
                obj.Load(_ScheduleZonetemplateID)
                If obj.ZoneName <> _ZoneName Then
                    UpdateZoneName(_ZoneName, cnn)
                    strTemp = "ZoneName Changed to '" & _ZoneName & "' from '" & obj.ZoneName & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.StartScheduleTime <> _StartScheduleTime Then
                    UpdateStartScheduleTime(_StartScheduleTime, cnn)
                    strTemp = "StartScheduleTime Changed to '" & _StartScheduleTime & "' from '" & obj.StartScheduleTime & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.EndScheduleTime <> _EndScheduleTime Then
                    UpdateEndScheduleTime(_EndScheduleTime, cnn)
                    strTemp = "EndScheduleTime Changed to '" & _EndScheduleTime & "' from '" & obj.EndScheduleTime & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.Active <> _Active Then
                    UpdateActive(_Active, cnn)
                    strTemp = "Active Changed to '" & _Active & "' from '" & obj.Active & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(_ScheduleZonetemplateID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded ScheduleZoneTemplate Record
        ''' </summary>
        Public Sub Delete()
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spRemoveScheduleZoneTemplate")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ScheduleZonetemplateID", SqlDbType.Int).Value = _ScheduleZonetemplateID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(_ScheduleZonetemplateID)
            End If
        End Sub

#End Region

    End Class

End Namespace