Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface

    Public Class ScheduleAvailabilityAssignmentRecord


#Region "Private Members"

        Private _ScheduleAvailabilityAssignementID As Long = 0
        Private _PartnerAgentID As Long = 0
        Private _ScheduleDay As Date = DateTime.Now
        Private _PartnerAgentAvailabilityID As Long = 0
        Private _ScheduleAvailabilityCodeID As Long = 0
        Private _TicketID As Long = 0
        Private _ConnectionString As String = ""

#End Region

#Region "Read/Write Properties"

        ''' <summary>
        ''' Returns/Sets the PartnerAgentID field for the currently loaded record
        ''' </summary>
        Public Property PartnerAgentID() As Long
            Get
                Return Me._PartnerAgentID
            End Get
            Set(ByVal value As Long)
                Me._PartnerAgentID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the ScheduleDay field for the currently loaded record
        ''' </summary>
        Public Property ScheduleDay() As Date
            Get
                Return Me._ScheduleDay
            End Get
            Set(ByVal value As Date)
                Me._ScheduleDay = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the PartnerAgentAvailabilityID field for the currently loaded record
        ''' </summary>
        Public Property PartnerAgentAvailabilityID() As Long
            Get
                Return Me._PartnerAgentAvailabilityID
            End Get
            Set(ByVal value As Long)
                Me._PartnerAgentAvailabilityID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the ScheduleAvailabilityCodeID field for the currently loaded record
        ''' </summary>
        Public Property ScheduleAvailabilityCodeID() As Long
            Get
                Return Me._ScheduleAvailabilityCodeID
            End Get
            Set(ByVal value As Long)
                Me._ScheduleAvailabilityCodeID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the TicketID field for the currently loaded record
        ''' </summary>
        Public Property TicketID() As Long
            Get
                Return Me._TicketID
            End Get
            Set(ByVal value As Long)
                Me._TicketID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the connection string to the database
        ''' </summary>
        Public Property ConnectionString() As String
            Get
                Return Me._ConnectionString
            End Get
            Set(ByVal value As String)
                Me._ConnectionString = value
            End Set
        End Property

#End Region

#Region "ReadOnly Properties"

        ''' <summary>
        ''' Returns the ScheduleAvailabilityAssignementID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property ScheduleAvailabilityAssignementID() As Long
            Get
                Return Me._ScheduleAvailabilityAssignementID
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
            Me._ScheduleAvailabilityAssignementID = 0
            Me._PartnerAgentID = 0
            Me._ScheduleDay = DateTime.Now
            Me._PartnerAgentAvailabilityID = 0
            Me._ScheduleAvailabilityCodeID = 0
            Me._TicketID = 0
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
            Dim cmd As New SqlCommand("spUpdateScheduleAvailabilityAssignmentPartnerAgentID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ScheduleAvailabilityAssignementID", SqlDbType.Int).Value = Me._ScheduleAvailabilityAssignementID
            cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = NewPartnerAgentID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the ScheduleDay field for this record.
        ''' </summary>
        ''' <param name="NewScheduleDay">The new value for theScheduleDay field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateScheduleDay(ByVal NewScheduleDay As Date, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateScheduleAvailabilityAssignmentScheduleDay")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ScheduleAvailabilityAssignementID", SqlDbType.Int).Value = Me._ScheduleAvailabilityAssignementID
            cmd.Parameters.Add("@ScheduleDay", SqlDbType.DateTime).Value = NewScheduleDay
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the PartnerAgentAvailabilityID field for this record.
        ''' </summary>
        ''' <param name="NewPartnerAgentAvailabilityID">The new value for thePartnerAgentAvailabilityID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdatePartnerAgentAvailabilityID(ByVal NewPartnerAgentAvailabilityID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateScheduleAvailabilityAssignmentPartnerAgentAvailabilityID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ScheduleAvailabilityAssignementID", SqlDbType.Int).Value = Me._ScheduleAvailabilityAssignementID
            cmd.Parameters.Add("@PartnerAgentAvailabilityID", SqlDbType.Int).Value = NewPartnerAgentAvailabilityID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the ScheduleAvailabilityCodeID field for this record.
        ''' </summary>
        ''' <param name="NewScheduleAvailabilityCodeID">The new value for theScheduleAvailabilityCodeID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateScheduleAvailabilityCodeID(ByVal NewScheduleAvailabilityCodeID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateScheduleAvailabilityAssignmentScheduleAvailabilityCodeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ScheduleAvailabilityAssignementID", SqlDbType.Int).Value = Me._ScheduleAvailabilityAssignementID
            cmd.Parameters.Add("@ScheduleAvailabilityCodeID", SqlDbType.Int).Value = NewScheduleAvailabilityCodeID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the TicketID field for this record.
        ''' </summary>
        ''' <param name="NewTicketID">The new value for theTicketID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateTicketID(ByVal NewTicketID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateScheduleAvailabilityAssignmentTicketID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ScheduleAvailabilityAssignementID", SqlDbType.Int).Value = Me._ScheduleAvailabilityAssignementID
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = NewTicketID
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
            Dim obj As New ScheduleAvailabilityAssignmentRecord(Me._ScheduleAvailabilityAssignementID, Me._ConnectionString)
            obj.Load(Me._ScheduleAvailabilityAssignementID)
            If obj.PartnerAgentID <> Me._PartnerAgentID Then
                blnReturn = True
            End If
            If obj.ScheduleDay <> Me._ScheduleDay Then
                blnReturn = True
            End If
            If obj.PartnerAgentAvailabilityID <> Me._PartnerAgentAvailabilityID Then
                blnReturn = True
            End If
            If obj.ScheduleAvailabilityCodeID <> Me._ScheduleAvailabilityCodeID Then
                blnReturn = True
            End If
            If obj.TicketID <> Me._TicketID Then
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
            Me._ConnectionString = strConnectionString
        End Sub

        ''' <summary>
        ''' Overloaded, Initializes the object and loads by the passed in Primary Key
        ''' </summary>
        ''' <param name="lngScheduleAvailabilityAssignementID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngScheduleAvailabilityAssignementID As Long, ByVal strConnectionString As String)
            Me._ConnectionString = strConnectionString
            Load(Me._ScheduleAvailabilityAssignementID)
        End Sub

        ''' <summary>
        '''  Adds a new ScheduleAvailabilityAssignment record to the database.
        ''' </summary>
        ''' <param name="lngPartnerAgentID">The value for the PartnerAgentID portion of the record</param>
        ''' <param name="datScheduleDay">The value for the ScheduleDay portion of the record</param>
        ''' <param name="lngPartnerAgentAvailabilityID">The value for the PartnerAgentAvailabilityID portion of the record</param>
        ''' <param name="lngScheduleAvailabilityCodeID">The value for the ScheduleAvailabilityCodeID portion of the record</param>
        ''' <param name="lngTicketID">The value for the TicketID portion of the record</param>
        Public Sub Add(ByVal lngPartnerAgentID As Long, ByVal datScheduleDay As Date, ByVal lngPartnerAgentAvailabilityID As Long, ByVal lngScheduleAvailabilityCodeID As Long, ByVal lngTicketID As Long)
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddScheduleAvailabilityAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngScheduleAvailabilityAssignementID As Long = 0
                cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = lngPartnerAgentID
                cmd.Parameters.Add("@ScheduleDay", SqlDbType.DateTime).Value = datScheduleDay
                cmd.Parameters.Add("@PartnerAgentAvailabilityID", SqlDbType.Int).Value = lngPartnerAgentAvailabilityID
                cmd.Parameters.Add("@ScheduleAvailabilityCodeID", SqlDbType.Int).Value = lngScheduleAvailabilityCodeID
                cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = lngTicketID
                cnn.Open()
                cmd.Connection = cnn
                lngScheduleAvailabilityAssignementID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngScheduleAvailabilityAssignementID > 0 Then
                    Load(lngScheduleAvailabilityAssignementID)
                End If
            End If
        End Sub
        Public Sub Add(ByVal lngPartnerAgentID As Long, ByVal datScheduleDay As Date, ByVal lngPartnerAgentAvailabilityID As Long, ByVal lngScheduleAvailabilityCodeID As Long)
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddScheduleAvailabilityAssignment2")
                cmd.CommandType = CommandType.StoredProcedure

                cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = lngPartnerAgentID
                cmd.Parameters.Add("@ScheduleDay", SqlDbType.DateTime).Value = datScheduleDay
                cmd.Parameters.Add("@PartnerAgentAvailabilityID", SqlDbType.Int).Value = lngPartnerAgentAvailabilityID
                cmd.Parameters.Add("@ScheduleAvailabilityCodeID", SqlDbType.Int).Value = lngScheduleAvailabilityCodeID

                cnn.Open()
                cmd.Connection = cnn
                Dim lngScheduleAvailabilityAssignmentID As Long = 0
                lngScheduleAvailabilityAssignmentID = CType(cmd.ExecuteScalar, Long)

                If lngScheduleAvailabilityAssignmentID > 0 Then
                    Load(lngScheduleAvailabilityAssignmentID)
                End If
                cnn.Close()
            End If
        End Sub

        ''' <summary>
        ''' Loads a ScheduleAvailabilityAssignment record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngScheduleAvailabilityAssignmentID As Long)
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetScheduleAvailabilityAssignment")
                Dim dtr As SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ScheduleAvailabilityAssignmentID", SqlDbType.Int).Value = lngScheduleAvailabilityAssignmentID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    Me._ScheduleAvailabilityAssignementID = CType(dtr("ScheduleAvailabilityAssignmentID"), Long)
                    Me._PartnerAgentID = CType(dtr("PartnerAgentID"), Long)
                    Me._ScheduleDay = CType(dtr("ScheduleDay"), Date)
                    Me._PartnerAgentAvailabilityID = CType(dtr("PartnerAgentAvailabilityID"), Long)
                    Me._ScheduleAvailabilityCodeID = CType(dtr("ScheduleAvailabilityCodeID"), Long)
                    If Not IsDBNull(dtr("TicketID")) Then
                        Me._TicketID = CType(dtr("TicketID"), Long)
                    Else
                        Me._TicketID = 0
                    End If
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
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim strTemp As String = ""
                Dim cnn As New SqlConnection(Me._ConnectionString)
                cnn.Open()
                Dim obj As New ScheduleAvailabilityAssignmentRecord(Me._ScheduleAvailabilityAssignementID, Me._ConnectionString)
                obj.Load(Me._ScheduleAvailabilityAssignementID)
                If obj.PartnerAgentID <> Me._PartnerAgentID Then
                    UpdatePartnerAgentID(Me._PartnerAgentID, cnn)
                    strTemp = "PartnerAgentID Changed to '" & Me._PartnerAgentID & "' from '" & obj.PartnerAgentID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.ScheduleDay <> Me._ScheduleDay Then
                    UpdateScheduleDay(Me._ScheduleDay, cnn)
                    strTemp = "ScheduleDay Changed to '" & Me._ScheduleDay & "' from '" & obj.ScheduleDay & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.PartnerAgentAvailabilityID <> Me._PartnerAgentAvailabilityID Then
                    UpdatePartnerAgentAvailabilityID(Me._PartnerAgentAvailabilityID, cnn)
                    strTemp = "PartnerAgentAvailabilityID Changed to '" & Me._PartnerAgentAvailabilityID & "' from '" & obj.PartnerAgentAvailabilityID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.ScheduleAvailabilityCodeID <> Me._ScheduleAvailabilityCodeID Then
                    UpdateScheduleAvailabilityCodeID(Me._ScheduleAvailabilityCodeID, cnn)
                    strTemp = "ScheduleAvailabilityCodeID Changed to '" & Me._ScheduleAvailabilityCodeID & "' from '" & obj.ScheduleAvailabilityCodeID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.TicketID <> Me._TicketID Then
                    UpdateTicketID(Me._TicketID, cnn)
                    strTemp = "TicketID Changed to '" & Me._TicketID & "' from '" & obj.TicketID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(Me._ScheduleAvailabilityAssignementID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded ScheduleAvailabilityAssignment Record
        ''' </summary>
        Public Sub Delete()
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveScheduleAvailabilityAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ScheduleAvailabilityAssignmentID", SqlDbType.Int).Value = Me._ScheduleAvailabilityAssignementID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                'Load(Me._ScheduleAvailabilityAssignementID)
            End If
        End Sub

#End Region

    End Class

End Namespace