Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class ResumeReferrerRecord
        ' Methods
        Public Sub New()
            Me._ReferrerID = 0
            Me._CreatedBy = 0
            Me._Referrer = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._ReferrerID = 0
            Me._CreatedBy = 0
            Me._Referrer = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngReferrerID As Long, ByVal strConnectionString As String)
            Me._ReferrerID = 0
            Me._CreatedBy = 0
            Me._Referrer = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._ReferrerID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal strReferrer As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddResumeReferrer")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngReferrerID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@Referrer", SqlDbType.VarChar, Me.TrimTrunc(strReferrer, &H40).Length).Value = Me.TrimTrunc(strReferrer, &H40)
                cnn.Open
                cmd.Connection = cnn
                lngReferrerID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngReferrerID > 0) Then
                    Me.Load(lngReferrerID)
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
            Me._ReferrerID = 0
            Me._CreatedBy = 0
            Me._Referrer = ""
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveResumeReferrer")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ReferrerID", SqlDbType.Int).Value = Me._ReferrerID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._ReferrerID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New ResumeReferrerRecord(Me._ReferrerID, Me._ConnectionString)
            If (obj.Referrer <> Me._Referrer) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngReferrerID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetResumeReferrer")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ReferrerID", SqlDbType.Int).Value = lngReferrerID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._ReferrerID = Conversions.ToLong(dtr.Item("ReferrerID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._Referrer = dtr.Item("Referrer").ToString
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
                Dim obj As New ResumeReferrerRecord(Me._ReferrerID, Me._ConnectionString)
                If (obj.Referrer <> Me._Referrer) Then
                    Me.UpdateReferrer(Me._Referrer, (cnn))
                    strTemp = String.Concat(New String() { "Referrer Changed to '", Me._Referrer, "' from '", obj.Referrer, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._ReferrerID)
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

        Private Sub UpdateReferrer(ByVal NewReferrer As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeReferrerReferrer")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ReferrerID", SqlDbType.Int).Value = Me._ReferrerID
            cmd.Parameters.Add("@Referrer", SqlDbType.VarChar, Me.TrimTrunc(NewReferrer, &H40).Length).Value = Me.TrimTrunc(NewReferrer, &H40)
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

        Public Property Referrer As String
            Get
                Return Me._Referrer
            End Get
            Set(ByVal value As String)
                Me._Referrer = Me.TrimTrunc(value, &H40)
            End Set
        End Property

        Public ReadOnly Property ReferrerID As Long
            Get
                Return Me._ReferrerID
            End Get
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _Referrer As String
        Private _ReferrerID As Long
        Private Const ReferrerMaxLength As Integer = &H40
    End Class
End Namespace

