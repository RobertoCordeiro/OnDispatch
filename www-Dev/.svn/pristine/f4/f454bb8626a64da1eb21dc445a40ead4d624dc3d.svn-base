Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class SuffixRecord
        ' Methods
        Public Sub New()
            Me._SuffixID = 0
            Me._CreatedBy = 0
            Me._Suffix = ""
            Me._DateCreated = New DateTime
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._SuffixID = 0
            Me._CreatedBy = 0
            Me._Suffix = ""
            Me._DateCreated = New DateTime
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngSuffixID As Long, ByVal strConnectionString As String)
            Me._SuffixID = 0
            Me._CreatedBy = 0
            Me._Suffix = ""
            Me._DateCreated = New DateTime
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._SuffixID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal strSuffix As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddSuffix")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngSuffixID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@Suffix", SqlDbType.VarChar, Me.TrimTrunc(strSuffix, &H10).Length).Value = Me.TrimTrunc(strSuffix, &H10)
                cnn.Open
                cmd.Connection = cnn
                lngSuffixID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngSuffixID > 0) Then
                    Me.Load(lngSuffixID)
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
            Me._SuffixID = 0
            Me._CreatedBy = 0
            Me._Suffix = ""
            Me._DateCreated = New DateTime
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveSuffix")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@SuffixID", SqlDbType.Int).Value = Me._SuffixID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._SuffixID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New SuffixRecord(Me._SuffixID, Me._ConnectionString)
            If (obj.Suffix <> Me._Suffix) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngSuffixID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetSuffix")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@SuffixID", SqlDbType.Int).Value = lngSuffixID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._SuffixID = Conversions.ToLong(dtr.Item("SuffixID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._Suffix = dtr.Item("Suffix").ToString
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
                Dim obj As New SuffixRecord(Me._SuffixID, Me._ConnectionString)
                If (obj.Suffix <> Me._Suffix) Then
                    Me.UpdateSuffix(Me._Suffix, (cnn))
                    strTemp = String.Concat(New String() { "Suffix Changed to '", Me._Suffix, "' from '", obj.Suffix, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._SuffixID)
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

        Private Sub UpdateSuffix(ByVal NewSuffix As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateSuffixSuffix")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@SuffixID", SqlDbType.Int).Value = Me._SuffixID
            cmd.Parameters.Add("@Suffix", SqlDbType.VarChar, Me.TrimTrunc(NewSuffix, &H10).Length).Value = Me.TrimTrunc(NewSuffix, &H10)
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

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public Property Suffix As String
            Get
                Return Me._Suffix
            End Get
            Set(ByVal value As String)
                Me._Suffix = Me.TrimTrunc(value, &H10)
            End Set
        End Property

        Public ReadOnly Property SuffixID As Long
            Get
                Return Me._SuffixID
            End Get
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _Suffix As String
        Private _SuffixID As Long
        Private Const SuffixMaxLength As Integer = &H10
    End Class
End Namespace

