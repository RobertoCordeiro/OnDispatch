Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class ResumeTimeSlotRecord
        ' Methods
        Public Sub New()
            Me._ResumeTimeSlotID = 0
            Me._CreatedBy = 0
            Me._WeekDayID = 0
            Me._ResumeID = 0
            Me._StartHour = 0
            Me._StartMinute = 0
            Me._EndHour = 0
            Me._EndMinute = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._ResumeTimeSlotID = 0
            Me._CreatedBy = 0
            Me._WeekDayID = 0
            Me._ResumeID = 0
            Me._StartHour = 0
            Me._StartMinute = 0
            Me._EndHour = 0
            Me._EndMinute = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngResumeTimeSlotID As Long, ByVal strConnectionString As String)
            Me._ResumeTimeSlotID = 0
            Me._CreatedBy = 0
            Me._WeekDayID = 0
            Me._ResumeID = 0
            Me._StartHour = 0
            Me._StartMinute = 0
            Me._EndHour = 0
            Me._EndMinute = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._ResumeTimeSlotID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal lngWeekDayID As Long, ByVal lngResumeID As Long, ByVal intStartHour As Integer, ByVal intStartMinute As Integer, ByVal intEndHour As Integer, ByVal intEndMinute As Integer)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddResumeTimeSlot")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngResumeTimeSlotID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@WeekDayID", SqlDbType.Int).Value = lngWeekDayID
                cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = lngResumeID
                cmd.Parameters.Add("@StartHour", SqlDbType.TinyInt).Value = intStartHour
                cmd.Parameters.Add("@StartMinute", SqlDbType.TinyInt).Value = intStartMinute
                cmd.Parameters.Add("@EndHour", SqlDbType.TinyInt).Value = intEndHour
                cmd.Parameters.Add("@EndMinute", SqlDbType.TinyInt).Value = intEndMinute
                cnn.Open
                cmd.Connection = cnn
                lngResumeTimeSlotID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngResumeTimeSlotID > 0) Then
                    Me.Load(lngResumeTimeSlotID)
                End If
            End If
        End Sub

        Private Sub AppendChangeLog(ByRef strLog As String, ByVal strNewLine As String)
            Dim strReturn As String = ""
            If (strLog.Length > 0) Then
                strReturn = (strLog & Environment.NewLine)
            End If
            strReturn = (strReturn & strNewLine)
            strLog = strReturn
        End Sub

        Private Sub ClearValues()
            Me._ResumeTimeSlotID = 0
            Me._CreatedBy = 0
            Me._WeekDayID = 0
            Me._StartHour = 0
            Me._StartMinute = 0
            Me._EndHour = 0
            Me._EndMinute = 0
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveResumeTimeSlot")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ResumeTimeSlotID", SqlDbType.Int).Value = Me._ResumeTimeSlotID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._ResumeTimeSlotID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New ResumeTimeSlotRecord(Me._ResumeTimeSlotID, Me._ConnectionString)
            obj.Load(Me._ResumeTimeSlotID)
            If (obj.WeekDayID <> Me._WeekDayID) Then
                blnReturn = True
            End If
            If (obj.StartHour <> Me._StartHour) Then
                blnReturn = True
            End If
            If (obj.StartMinute <> Me._StartMinute) Then
                blnReturn = True
            End If
            If (obj.EndHour <> Me._EndHour) Then
                blnReturn = True
            End If
            If (obj.EndMinute <> Me._EndMinute) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngResumeTimeSlotID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetResumeTimeSlot")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ResumeTimeSlotID", SqlDbType.Int).Value = lngResumeTimeSlotID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._ResumeTimeSlotID = Conversions.ToLong(dtr.Item("ResumeTimeSlotID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._WeekDayID = Conversions.ToLong(dtr.Item("WeekDayID"))
                    Me._ResumeID = Conversions.ToLong(dtr.Item("ResumeID"))
                    Me._StartHour = Conversions.ToInteger(dtr.Item("StartHour"))
                    Me._StartMinute = Conversions.ToInteger(dtr.Item("StartMinute"))
                    Me._EndHour = Conversions.ToInteger(dtr.Item("EndHour"))
                    Me._EndMinute = Conversions.ToInteger(dtr.Item("EndMinute"))
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                Else
                    Me.ClearValues
                End If
                cnn.Close
            End If
        End Sub

        Public Sub Save(ByRef strChangeLog As String)
            strChangeLog = ""
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim strTemp As String = ""
                Dim cnn As New SqlConnection(Me._ConnectionString)
                cnn.Open
                Dim obj As New ResumeTimeSlotRecord(Me._ResumeTimeSlotID, Me._ConnectionString)
                obj.Load(Me._ResumeTimeSlotID)
                If (obj.WeekDayID <> Me._WeekDayID) Then
                    Me.UpdateWeekDayID(Me._WeekDayID, (cnn))
                    strTemp = String.Concat(New String() { "WeekDayID Changed to '", Conversions.ToString(Me._WeekDayID), "' from '", Conversions.ToString(obj.WeekDayID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.StartHour <> Me._StartHour) Then
                    Me.UpdateStartHour(Me._StartHour, (cnn))
                    strTemp = String.Concat(New String() { "StartHour Changed to '", Conversions.ToString(Me._StartHour), "' from '", Conversions.ToString(obj.StartHour), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.StartMinute <> Me._StartMinute) Then
                    Me.UpdateStartMinute(Me._StartMinute, (cnn))
                    strTemp = String.Concat(New String() { "StartMinute Changed to '", Conversions.ToString(Me._StartMinute), "' from '", Conversions.ToString(obj.StartMinute), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.EndHour <> Me._EndHour) Then
                    Me.UpdateEndHour(Me._EndHour, (cnn))
                    strTemp = String.Concat(New String() { "EndHour Changed to '", Conversions.ToString(Me._EndHour), "' from '", Conversions.ToString(obj.EndHour), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.EndMinute <> Me._EndMinute) Then
                    Me.UpdateEndMinute(Me._EndMinute, (cnn))
                    strTemp = String.Concat(New String() { "EndMinute Changed to '", Conversions.ToString(Me._EndMinute), "' from '", Conversions.ToString(obj.EndMinute), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._ResumeTimeSlotID)
            Else
                Me.ClearValues
            End If
        End Sub

        Private Function TrimTrunc(ByVal strInput As String, ByVal intMaxLength As Integer) As String
            Dim strReturn As String = strInput
            If (strReturn.Trim.Length <= intMaxLength) Then
                Return strReturn.Trim
            End If
            Return strReturn.Substring(0, intMaxLength).Trim
        End Function

        Private Sub UpdateEndHour(ByVal NewEndHour As Integer, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeTimeSlotEndHour")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeTimeSlotID", SqlDbType.Int).Value = Me._ResumeTimeSlotID
            cmd.Parameters.Add("@EndHour", SqlDbType.TinyInt).Value = NewEndHour
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateEndMinute(ByVal NewEndMinute As Integer, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeTimeSlotEndMinute")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeTimeSlotID", SqlDbType.Int).Value = Me._ResumeTimeSlotID
            cmd.Parameters.Add("@EndMinute", SqlDbType.TinyInt).Value = NewEndMinute
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateStartHour(ByVal NewStartHour As Integer, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeTimeSlotStartHour")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeTimeSlotID", SqlDbType.Int).Value = Me._ResumeTimeSlotID
            cmd.Parameters.Add("@StartHour", SqlDbType.TinyInt).Value = NewStartHour
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateStartMinute(ByVal NewStartMinute As Integer, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeTimeSlotStartMinute")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeTimeSlotID", SqlDbType.Int).Value = Me._ResumeTimeSlotID
            cmd.Parameters.Add("@StartMinute", SqlDbType.TinyInt).Value = NewStartMinute
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateWeekDayID(ByVal NewWeekDayID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeTimeSlotWeekDayID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeTimeSlotID", SqlDbType.Int).Value = Me._ResumeTimeSlotID
            cmd.Parameters.Add("@WeekDayID", SqlDbType.Int).Value = NewWeekDayID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub


        ' Properties
        Public Property ConnectionString As String
            Get
                Return Me._ConnectionString
            End Get
            Set(ByVal value As String)
                Me._ConnectionString = value
            End Set
        End Property

        Public ReadOnly Property CreatedBy As Long
            Get
                Return Me._CreatedBy
            End Get
        End Property

        Public ReadOnly Property DateCreated As DateTime
            Get
                Return Me._DateCreated
            End Get
        End Property

        Public Property EndHour As Integer
            Get
                Return Me._EndHour
            End Get
            Set(ByVal value As Integer)
                Me._EndHour = value
            End Set
        End Property

        Public Property EndMinute As Integer
            Get
                Return Me._EndMinute
            End Get
            Set(ByVal value As Integer)
                Me._EndMinute = value
            End Set
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public ReadOnly Property ResumeID As Long
            Get
                Return Me._ResumeID
            End Get
        End Property

        Public ReadOnly Property ResumeTimeSlotID As Long
            Get
                Return Me._ResumeTimeSlotID
            End Get
        End Property

        Public Property StartHour As Integer
            Get
                Return Me._StartHour
            End Get
            Set(ByVal value As Integer)
                Me._StartHour = value
            End Set
        End Property

        Public Property StartMinute As Integer
            Get
                Return Me._StartMinute
            End Get
            Set(ByVal value As Integer)
                Me._StartMinute = value
            End Set
        End Property

        Public Property WeekDayID As Long
            Get
                Return Me._WeekDayID
            End Get
            Set(ByVal value As Long)
                Me._WeekDayID = value
            End Set
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _EndHour As Integer
        Private _EndMinute As Integer
        Private _ResumeID As Long
        Private _ResumeTimeSlotID As Long
        Private _StartHour As Integer
        Private _StartMinute As Integer
        Private _WeekDayID As Long
    End Class
End Namespace

