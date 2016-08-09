Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class MonthRecord
        ' Methods
        Public Sub New()
            Me._MonthID = 0
            Me._CreatedBy = 0
            Me._MonthName = ""
            Me._Abbreviation = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._MonthID = 0
            Me._CreatedBy = 0
            Me._MonthName = ""
            Me._Abbreviation = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngMonthID As Long, ByVal strConnectionString As String)
            Me._MonthID = 0
            Me._CreatedBy = 0
            Me._MonthName = ""
            Me._Abbreviation = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(CLng(Me._MonthID))
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal strMonthName As String, ByVal strAbbreviation As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddMonth")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngMonthID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@MonthName", SqlDbType.VarChar, Me.TrimTrunc(strMonthName, &H10).Length).Value = Me.TrimTrunc(strMonthName, &H10)
                cmd.Parameters.Add("@Abbreviation", SqlDbType.Char, Me.TrimTrunc(strAbbreviation, 3).Length).Value = Me.TrimTrunc(strAbbreviation, 3)
                cnn.Open
                cmd.Connection = cnn
                lngMonthID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngMonthID > 0) Then
                    Me.Load(lngMonthID)
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
            Me._MonthID = 0
            Me._CreatedBy = 0
            Me._MonthName = ""
            Me._Abbreviation = ""
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveMonth")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@MonthID", SqlDbType.Int).Value = Me._MonthID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(CLng(Me._MonthID))
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New MonthRecord(CLng(Me._MonthID), Me._ConnectionString)
            obj.Load(CLng(Me._MonthID))
            If (obj.MonthName <> Me._MonthName) Then
                blnReturn = True
            End If
            If (obj.Abbreviation <> Me._Abbreviation) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngMonthID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetMonth")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@MonthID", SqlDbType.Int).Value = lngMonthID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._MonthID = Conversions.ToInteger(dtr.Item("MonthID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._MonthName = dtr.Item("MonthName").ToString
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
                Dim obj As New MonthRecord(CLng(Me._MonthID), Me._ConnectionString)
                obj.Load(CLng(Me._MonthID))
                If (obj.MonthName <> Me._MonthName) Then
                    Me.UpdateMonthName(Me._MonthName, (cnn))
                    strTemp = String.Concat(New String() { "MonthName Changed to '", Me._MonthName, "' from '", obj.MonthName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Abbreviation <> Me._Abbreviation) Then
                    Me.UpdateAbbreviation(Me._Abbreviation, (cnn))
                    strTemp = String.Concat(New String() { "Abbreviation Changed to '", Me._Abbreviation, "' from '", obj.Abbreviation, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(CLng(Me._MonthID))
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
            Dim cmd As New SqlCommand("spUpdateMonthAbbreviation")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@MonthID", SqlDbType.TinyInt).Value = Me._MonthID
            cmd.Parameters.Add("@Abbreviation", SqlDbType.Char, Me.TrimTrunc(NewAbbreviation, 3).Length).Value = Me.TrimTrunc(NewAbbreviation, 3)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateMonthName(ByVal NewMonthName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateMonthMonthName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@MonthID", SqlDbType.TinyInt).Value = Me._MonthID
            cmd.Parameters.Add("@MonthName", SqlDbType.VarChar, Me.TrimTrunc(NewMonthName, &H10).Length).Value = Me.TrimTrunc(NewMonthName, &H10)
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

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public ReadOnly Property MonthID As Integer
            Get
                Return Me._MonthID
            End Get
        End Property

        Public Property MonthName As String
            Get
                Return Me._MonthName
            End Get
            Set(ByVal value As String)
                Me._MonthName = Me.TrimTrunc(value, &H10)
            End Set
        End Property


        ' Fields
        Private _Abbreviation As String
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _MonthID As Integer
        Private _MonthName As String
        Private Const AbbreviationMaxLength As Integer = 3
        Private Const MonthNameMaxLength As Integer = &H10
    End Class
End Namespace

