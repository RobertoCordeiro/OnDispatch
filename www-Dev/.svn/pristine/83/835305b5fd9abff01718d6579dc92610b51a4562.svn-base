Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class WeekDayRecord
        ' Methods
        Public Sub New()
            Me._WeekDayID = 0
            Me._CreatedBy = 0
            Me._DayName = ""
            Me._Abbreviation = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._WeekDayID = 0
            Me._CreatedBy = 0
            Me._DayName = ""
            Me._Abbreviation = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngWeekDayID As Long, ByVal strConnectionString As String)
            Me._WeekDayID = 0
            Me._CreatedBy = 0
            Me._DayName = ""
            Me._Abbreviation = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(CLng(Me._WeekDayID))
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal strDayName As String, ByVal strAbbreviation As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddWeekDay")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngWeekDayID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@DayName", SqlDbType.VarChar, Me.TrimTrunc(strDayName, &H10).Length).Value = Me.TrimTrunc(strDayName, &H10)
                cmd.Parameters.Add("@Abbreviation", SqlDbType.Char, Me.TrimTrunc(strAbbreviation, 3).Length).Value = Me.TrimTrunc(strAbbreviation, 3)
                cnn.Open
                cmd.Connection = cnn
                lngWeekDayID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngWeekDayID > 0) Then
                    Me.Load(lngWeekDayID)
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
            Me._WeekDayID = 0
            Me._CreatedBy = 0
            Me._DayName = ""
            Me._Abbreviation = ""
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveWeekDay")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@WeekDayID", SqlDbType.Int).Value = Me._WeekDayID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(CLng(Me._WeekDayID))
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New WeekDayRecord(CLng(Me._WeekDayID), Me._ConnectionString)
            obj.Load(CLng(Me._WeekDayID))
            If (obj.DayName <> Me._DayName) Then
                blnReturn = True
            End If
            If (obj.Abbreviation <> Me._Abbreviation) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngWeekDayID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetWeekDay")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@WeekDayID", SqlDbType.Int).Value = lngWeekDayID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._WeekDayID = Conversions.ToInteger(dtr.Item("WeekDayID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._DayName = dtr.Item("DayName").ToString
                    Me._Abbreviation = dtr.Item("Abbreviation").ToString
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
                Dim obj As New WeekDayRecord(CLng(Me._WeekDayID), Me._ConnectionString)
                obj.Load(CLng(Me._WeekDayID))
                If (obj.DayName <> Me._DayName) Then
                    Me.UpdateDayName(Me._DayName, (cnn))
                    strTemp = String.Concat(New String() { "DayName Changed to '", Me._DayName, "' from '", obj.DayName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Abbreviation <> Me._Abbreviation) Then
                    Me.UpdateAbbreviation(Me._Abbreviation, (cnn))
                    strTemp = String.Concat(New String() { "Abbreviation Changed to '", Me._Abbreviation, "' from '", obj.Abbreviation, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(CLng(Me._WeekDayID))
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

        Private Sub UpdateAbbreviation(ByVal NewAbbreviation As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWeekDayAbbreviation")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WeekDayID", SqlDbType.TinyInt).Value = Me._WeekDayID
            cmd.Parameters.Add("@Abbreviation", SqlDbType.Char, Me.TrimTrunc(NewAbbreviation, 3).Length).Value = Me.TrimTrunc(NewAbbreviation, 3)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateDayName(ByVal NewDayName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWeekDayDayName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WeekDayID", SqlDbType.TinyInt).Value = Me._WeekDayID
            cmd.Parameters.Add("@DayName", SqlDbType.VarChar, Me.TrimTrunc(NewDayName, &H10).Length).Value = Me.TrimTrunc(NewDayName, &H10)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub


        ' Properties
        Public Property Abbreviation As String
            Get
                Return Me._Abbreviation
            End Get
            Set(ByVal value As String)
                Me._Abbreviation = Me.TrimTrunc(value, 3)
            End Set
        End Property

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

        Public Property DayName As String
            Get
                Return Me._DayName
            End Get
            Set(ByVal value As String)
                Me._DayName = Me.TrimTrunc(value, &H10)
            End Set
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public ReadOnly Property WeekDayID As Integer
            Get
                Return Me._WeekDayID
            End Get
        End Property


        ' Fields
        Private _Abbreviation As String
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _DayName As String
        Private _WeekDayID As Integer
        Private Const AbbreviationMaxLength As Integer = 3
        Private Const DayNameMaxLength As Integer = &H10
    End Class
End Namespace

