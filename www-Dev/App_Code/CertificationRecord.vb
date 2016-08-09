Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class CertificationRecord
        ' Methods
        Public Sub New()
            Me._CertificationID = 0
            Me._AgencyID = 0
            Me._CreatedBy = 0
            Me._CertificationName = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._CertificationID = 0
            Me._AgencyID = 0
            Me._CreatedBy = 0
            Me._CertificationName = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngCertificationID As Long, ByVal strConnectionString As String)
            Me._CertificationID = 0
            Me._AgencyID = 0
            Me._CreatedBy = 0
            Me._CertificationName = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._CertificationID)
        End Sub

        Public Sub Add(ByVal lngAgencyID As Long, ByVal lngCreatedBy As Long, ByVal strCertificationName As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddCertification")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngCertificationID As Long = 0
                cmd.Parameters.Add("@AgencyID", SqlDbType.Int).Value = lngAgencyID
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@CertificationName", SqlDbType.VarChar, Me.TrimTrunc(strCertificationName, &H40).Length).Value = Me.TrimTrunc(strCertificationName, &H40)
                cnn.Open
                cmd.Connection = cnn
                lngCertificationID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngCertificationID > 0) Then
                    Me.Load(lngCertificationID)
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
            Me._CertificationID = 0
            Me._AgencyID = 0
            Me._CreatedBy = 0
            Me._CertificationName = ""
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveCertification")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CertificationID", SqlDbType.Int).Value = Me._CertificationID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._CertificationID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New CertificationRecord(Me._CertificationID, Me._ConnectionString)
            obj.Load(Me._CertificationID)
            If (obj.CertificationName <> Me._CertificationName) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngCertificationID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetCertification")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CertificationID", SqlDbType.Int).Value = lngCertificationID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._CertificationID = Conversions.ToLong(dtr.Item("CertificationID"))
                    Me._AgencyID = Conversions.ToLong(dtr.Item("AgencyID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._CertificationName = dtr.Item("CertificationName").ToString
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
                Dim obj As New CertificationRecord(Me._CertificationID, Me._ConnectionString)
                obj.Load(Me._CertificationID)
                If (obj.CertificationName <> Me._CertificationName) Then
                    Me.UpdateCertificationName(Me._CertificationName, (cnn))
                    strTemp = String.Concat(New String() { "CertificationName Changed to '", Me._CertificationName, "' from '", obj.CertificationName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._CertificationID)
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

        Private Sub UpdateCertificationName(ByVal NewCertificationName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCertificationCertificationName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CertificationID", SqlDbType.Int).Value = Me._CertificationID
            cmd.Parameters.Add("@CertificationName", SqlDbType.VarChar, Me.TrimTrunc(NewCertificationName, &H40).Length).Value = Me.TrimTrunc(NewCertificationName, &H40)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub


        ' Properties
        Public ReadOnly Property AgencyID As Long
            Get
                Return Me._AgencyID
            End Get
        End Property

        Public ReadOnly Property CertificationID As Long
            Get
                Return Me._CertificationID
            End Get
        End Property

        Public Property CertificationName As String
            Get
                Return Me._CertificationName
            End Get
            Set(ByVal value As String)
                Me._CertificationName = Me.TrimTrunc(value, &H40)
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
        Private _CertificationID As Long
        Private _CertificationName As String
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private Const CertificationNameMaxLength As Integer = &H40
    End Class
End Namespace

