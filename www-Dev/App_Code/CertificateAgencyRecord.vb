Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class CertificateAgencyRecord
        ' Methods
        Public Sub New()
            Me._AgencyID = 0
            Me._CreatedBy = 0
            Me._AgencyName = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._AgencyID = 0
            Me._CreatedBy = 0
            Me._AgencyName = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngAgencyID As Long, ByVal strConnectionString As String)
            Me._AgencyID = 0
            Me._CreatedBy = 0
            Me._AgencyName = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._AgencyID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal strAgencyName As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddCertificateAgency")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngAgencyID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@AgencyName", SqlDbType.VarChar, Me.TrimTrunc(strAgencyName, &H40).Length).Value = Me.TrimTrunc(strAgencyName, &H40)
                cnn.Open
                cmd.Connection = cnn
                lngAgencyID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngAgencyID > 0) Then
                    Me.Load(lngAgencyID)
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
            Me._AgencyID = 0
            Me._CreatedBy = 0
            Me._AgencyName = ""
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveCertificateAgency")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@AgencyID", SqlDbType.Int).Value = Me._AgencyID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._AgencyID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New CertificateAgencyRecord(Me._AgencyID, Me._ConnectionString)
            obj.Load(Me._AgencyID)
            If (obj.AgencyName <> Me._AgencyName) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngAgencyID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetCertificateAgency")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@AgencyID", SqlDbType.Int).Value = lngAgencyID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._AgencyID = Conversions.ToLong(dtr.Item("AgencyID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._AgencyName = dtr.Item("AgencyName").ToString
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
                Dim obj As New CertificateAgencyRecord(Me._AgencyID, Me._ConnectionString)
                obj.Load(Me._AgencyID)
                If (obj.AgencyName <> Me._AgencyName) Then
                    Me.UpdateAgencyName(Me._AgencyName, (cnn))
                    strTemp = String.Concat(New String() { "AgencyName Changed to '", Me._AgencyName, "' from '", obj.AgencyName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._AgencyID)
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

        Private Sub UpdateAgencyName(ByVal NewAgencyName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCertificateAgencyAgencyName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@AgencyID", SqlDbType.Int).Value = Me._AgencyID
            cmd.Parameters.Add("@AgencyName", SqlDbType.VarChar, Me.TrimTrunc(NewAgencyName, &H40).Length).Value = Me.TrimTrunc(NewAgencyName, &H40)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub


        ' Properties
        Public ReadOnly Property AgencyID As Long
            Get
                Return Me._AgencyID
            End Get
        End Property

        Public Property AgencyName As String
            Get
                Return Me._AgencyName
            End Get
            Set(ByVal value As String)
                Me._AgencyName = Me.TrimTrunc(value, &H40)
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


        ' Fields
        Private _AgencyID As Long
        Private _AgencyName As String
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private Const AgencyNameMaxLength As Integer = &H40
    End Class
End Namespace

