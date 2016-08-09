Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface

    Public Class PartnerAgentAvailabilityRecord
#Region "Private Members"

        Private _PartnerAgentAvailabilityID As Long = 0
        Private _PartnerAgentID As Long = 0
        Private _ScheduleZoneTemplateID As Long = 0
        Private _Active As Boolean = False
        Private _WeekDayID As Long = 0
        Private _ConnectionString As String = ""

#End Region

#Region "Read/Write Properties"

        ''' <summary>
        ''' Returns/Sets the PartnerAgentID field for the currently loaded record
        ''' </summary>
        Public Property PartnerAgentID() As Long
            Get
                Return _PartnerAgentID
            End Get
            Set(ByVal value As Long)
                _PartnerAgentID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the ScheduleZoneTemplateID field for the currently loaded record
        ''' </summary>
        Public Property ScheduleZoneTemplateID() As Long
            Get
                Return _ScheduleZoneTemplateID
            End Get
            Set(ByVal value As Long)
                _ScheduleZoneTemplateID = value
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

        Public Property Active() As Boolean
            Get
                Return _Active
            End Get
            Set(ByVal value As Boolean)
                _Active = value
            End Set
        End Property


#End Region

#Region "ReadOnly Properties"

        ''' <summary>
        ''' Returns the PartnerAgentAvailabilityID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property PartnerAgentAvailabilityID() As Long
            Get
                Return _PartnerAgentAvailabilityID
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

        Public ReadOnly Property WeekDayID() As Long
            Get
                Return _WeekDayID
            End Get
        End Property
#End Region

#Region "Private Sub-Routines"

        ''' <summary>
        ''' Clears all values except for the connection string
        ''' </summary>
        Private Sub ClearValues()
            _PartnerAgentAvailabilityID = 0
            _PartnerAgentID = 0
            _ScheduleZoneTemplateID = 0
            _WeekDayID = 0
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
        ''' Updates the PartnerAgentID field for this record.
        ''' </summary>
        ''' <param name="NewPartnerAgentID">The new value for thePartnerAgentID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdatePartnerAgentID(ByVal NewPartnerAgentID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentAvailabilitiesPartnerAgentID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentAvailabilityID", SqlDbType.Int).Value = _PartnerAgentAvailabilityID
            cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = NewPartnerAgentID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the ScheduleZoneTemplateID field for this record.
        ''' </summary>
        ''' <param name="NewScheduleZoneTemplateID">The new value for theScheduleZoneTemplateID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateScheduleZoneTemplateID(ByVal NewScheduleZoneTemplateID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentAvailabilitiesScheduleZoneTemplateID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentAvailabilityID", SqlDbType.Int).Value = _PartnerAgentAvailabilityID
            cmd.Parameters.Add("@ScheduleZoneTemplateID", SqlDbType.Int).Value = NewScheduleZoneTemplateID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdateActive(ByVal NewActive As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateActive")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentAvailabilityID", SqlDbType.Int).Value = _PartnerAgentAvailabilityID
            cmd.Parameters.Add("@Active", SqlDbType.Bit).Value = NewActive
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdateWeekDayID(ByVal NewWeekDayID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentAvailabilitiesWeekDayID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentAvailabilityID", SqlDbType.Int).Value = _PartnerAgentAvailabilityID
            cmd.Parameters.Add("@WeekDayID", SqlDbType.Int).Value = NewWeekDayID
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
            Dim obj As New PartnerAgentAvailabilityRecord(_PartnerAgentAvailabilityID, _ConnectionString)
            obj.Load(_PartnerAgentAvailabilityID)
            If obj.PartnerAgentID <> _PartnerAgentID Then
                blnReturn = True
            End If
            If obj.ScheduleZoneTemplateID <> _ScheduleZoneTemplateID Then
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
        ''' <param name="lngPartnerAgentAvailabilityID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngPartnerAgentAvailabilityID As Long, ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
            Load(_PartnerAgentAvailabilityID)
        End Sub

        ''' <summary>
        '''  Adds a new PartnerAgentAvailabilities record to the database.
        ''' </summary>
        ''' <param name="lngPartnerAgentID">The value for the PartnerAgentID portion of the record</param>
        ''' <param name="lngScheduleZoneTemplateID">The value for the ScheduleZoneTemplateID portion of the record</param>
        Public Sub Add(ByVal lngPartnerAgentID As Long, ByVal lngScheduleZoneTemplateID As Long, ByVal lngWeekDayID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spAddPartnerAgentAvailabilities")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngPartnerAgentAvailabilityID As Long = 0
                cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = lngPartnerAgentID
                cmd.Parameters.Add("@ScheduleZoneTemplateID", SqlDbType.Int).Value = lngScheduleZoneTemplateID
                cmd.Parameters.Add("@WeekDayID", SqlDbType.Int).Value = lngWeekDayID
                cnn.Open()
                cmd.Connection = cnn
                lngPartnerAgentAvailabilityID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngPartnerAgentAvailabilityID > 0 Then
                    Load(lngPartnerAgentAvailabilityID)
                End If
            End If
        End Sub

        Public Sub Add(ByVal lngPartnerAgentID As Long, ByVal lngScheduleZoneTemplateID As Long, ByVal blnActive As Boolean, ByVal lngWeekDayID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spAdd")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngPartnerAgentAvailabilityID As Long = 0
                cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = lngPartnerAgentID
                cmd.Parameters.Add("@ScheduleZoneTemplateID", SqlDbType.Int).Value = lngScheduleZoneTemplateID
                cmd.Parameters.Add("@WeekDay", SqlDbType.Int).Value = lngWeekDayID
                cmd.Parameters.Add("@Active", SqlDbType.Bit).Value = blnActive
                cnn.Open()
                cmd.Connection = cnn
                lngPartnerAgentAvailabilityID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngPartnerAgentAvailabilityID > 0 Then
                    Load(lngPartnerAgentAvailabilityID)
                End If
            End If
        End Sub


        ''' <summary>
        ''' Loads a PartnerAgentAvailabilities record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngPartnerAgentAvailabilityID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spGetPartnerAgentAvailabilities")
                Dim dtr As SqlClient.SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PartnerAgentAvailabilityID", SqlDbType.Int).Value = lngPartnerAgentAvailabilityID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _PartnerAgentAvailabilityID = CType(dtr("PartnerAgentAvailabilityID"), Long)
                    _PartnerAgentID = CType(dtr("PartnerAgentID"), Long)
                    _ScheduleZoneTemplateID = CType(dtr("ScheduleZoneTemplateID"), Long)
                    _WeekDayID = CType(dtr("WeekDayID"), Long)
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
                Dim obj As New PartnerAgentAvailabilityRecord(_PartnerAgentAvailabilityID, _ConnectionString)
                obj.load(_PartnerAgentAvailabilityID)
                If obj.PartnerAgentID <> _PartnerAgentID Then
                    UpdatePartnerAgentID(_PartnerAgentID, cnn)
                    strTemp = "PartnerAgentID Changed to '" & _PartnerAgentID & "' from '" & obj.PartnerAgentID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.ScheduleZoneTemplateID <> _ScheduleZoneTemplateID Then
                    UpdateScheduleZoneTemplateID(_ScheduleZoneTemplateID, cnn)
                    strTemp = "ScheduleZoneTemplateID Changed to '" & _ScheduleZoneTemplateID & "' from '" & obj.ScheduleZoneTemplateID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.Active <> _Active Then
                    UpdateActive(_Active, cnn)
                    strTemp = "Active Changed to '" & _Active & "' from '" & obj.Active & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.WeekDayID <> _WeekDayID Then
                    UpdateWeekDayID(_WeekDayID, cnn)
                    strTemp = "WeekDayID Changed to '" & _WeekDayID & "' from '" & obj.WeekDayID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(_PartnerAgentAvailabilityID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded PartnerAgentAvailabilities Record
        ''' </summary>
        Public Sub Delete()
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spRemovePartnerAgentAvailabilities")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PartnerAgentAvailabilityID", SqlDbType.Int).Value = _PartnerAgentAvailabilityID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(_PartnerAgentAvailabilityID)
            End If
        End Sub

#End Region

    End Class
End Namespace