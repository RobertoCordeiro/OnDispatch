Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class ResumeTypeRecord
        ' Methods
        Public Sub New()
            Me._ResumeTypeID = 0
            Me._CreatedBy = 0
            Me._ResumeType = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._ResumeTypeID = 0
            Me._CreatedBy = 0
            Me._ResumeType = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngResumeTypeID As Long, ByVal strConnectionString As String)
            Me._ResumeTypeID = 0
            Me._CreatedBy = 0
            Me._ResumeType = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._ResumeTypeID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal strResumeType As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddResumeType")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngResumeTypeID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@ResumeType", SqlDbType.VarChar, Me.TrimTrunc(strResumeType, &H80).Length).Value = Me.TrimTrunc(strResumeType, &H80)
                cnn.Open
                cmd.Connection = cnn
                lngResumeTypeID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngResumeTypeID > 0) Then
                    Me.Load(lngResumeTypeID)
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
            Me._ResumeTypeID = 0
            Me._CreatedBy = 0
            Me._ResumeType = ""
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveResumeType")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ResumeTypeID", SqlDbType.Int).Value = Me._ResumeTypeID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._ResumeTypeID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New ResumeTypeRecord(Me._ResumeTypeID, Me._ConnectionString)
            obj.Load(Me._ResumeTypeID)
            If (obj.ResumeType <> Me._ResumeType) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngResumeTypeID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetResumeType")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ResumeTypeID", SqlDbType.Int).Value = lngResumeTypeID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._ResumeTypeID = Conversions.ToLong(dtr.Item("ResumeTypeID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._ResumeType = dtr.Item("ResumeType").ToString
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
                Dim obj As New ResumeTypeRecord(Me._ResumeTypeID, Me._ConnectionString)
                obj.Load(Me._ResumeTypeID)
                If (obj.ResumeType <> Me._ResumeType) Then
                    Me.UpdateResumeType(Me._ResumeType, (cnn))
                    strTemp = String.Concat(New String() { "ResumeType Changed to '", Me._ResumeType, "' from '", obj.ResumeType, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._ResumeTypeID)
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

        Private Sub UpdateResumeType(ByVal NewResumeType As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeTypeResumeType")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeTypeID", SqlDbType.Int).Value = Me._ResumeTypeID
            cmd.Parameters.Add("@ResumeType", SqlDbType.VarChar, Me.TrimTrunc(NewResumeType, &H80).Length).Value = Me.TrimTrunc(NewResumeType, &H80)
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

        Public Property ResumeType As String
            Get
                Return Me._ResumeType
            End Get
            Set(ByVal value As String)
                Me._ResumeType = Me.TrimTrunc(value, &H80)
            End Set
        End Property

        Public ReadOnly Property ResumeTypeID As Long
            Get
                Return Me._ResumeTypeID
            End Get
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _ResumeType As String
        Private _ResumeTypeID As Long
        Private Const ResumeTypeMaxLength As Integer = &H80
    End Class
End Namespace

