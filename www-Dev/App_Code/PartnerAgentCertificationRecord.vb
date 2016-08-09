Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class PartnerAgentCertificationRecord
        ' Methods
        Public Sub New()
            Me._PartnerAgentCertificationID = 0
            Me._CertificationID = 0
            Me._CreatedBy = 0
            Me._PartnerAgentID = 0
            Me._CertificationNumber = ""
            Me._CertificationDate = DateTime.Now
            Me._CertificationExpires = New DateTime
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._PartnerAgentCertificationID = 0
            Me._CertificationID = 0
            Me._CreatedBy = 0
            Me._PartnerAgentID = 0
            Me._CertificationNumber = ""
            Me._CertificationDate = DateTime.Now
            Me._CertificationExpires = New DateTime
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngPartnerAgentCertificationID As Long, ByVal strConnectionString As String)
            Me._PartnerAgentCertificationID = 0
            Me._CertificationID = 0
            Me._CreatedBy = 0
            Me._PartnerAgentID = 0
            Me._CertificationNumber = ""
            Me._CertificationDate = DateTime.Now
            Me._CertificationExpires = New DateTime
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._PartnerAgentCertificationID)
        End Sub

        Public Sub Add(ByVal lngCertificationID As Long, ByVal lngCreatedBy As Long, ByVal lngPartnerAgentID As Long, ByVal strCertificationNumber As String, ByVal datCertificationDate As DateTime)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddPartnerAgentCertification")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngPartnerAgentCertificationID As Long = 0
                cmd.Parameters.Add("@CertificationID", SqlDbType.Int).Value = lngCertificationID
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = lngPartnerAgentID
                cmd.Parameters.Add("@CertificationNumber", SqlDbType.VarChar, Me.TrimTrunc(strCertificationNumber, &HFF).Length).Value = Me.TrimTrunc(strCertificationNumber, &HFF)
                cmd.Parameters.Add("@CertificationDate", SqlDbType.DateTime).Value = datCertificationDate

                cnn.Open()
                cmd.Connection = cnn
                lngPartnerAgentCertificationID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close()
                If (lngPartnerAgentCertificationID > 0) Then
                    Me.Load(lngPartnerAgentCertificationID)
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
            Me._PartnerAgentCertificationID = 0
            Me._CertificationID = 0
            Me._CreatedBy = 0
            Me._PartnerAgentID = 0
            Me._CertificationNumber = ""
            Me._CertificationDate = DateTime.Now
            Me._CertificationExpires = New DateTime
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemovePartnerAgentCertification")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PartnerAgentCertificationID", SqlDbType.Int).Value = Me._PartnerAgentCertificationID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._PartnerAgentCertificationID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New PartnerAgentCertificationRecord(Me._PartnerAgentCertificationID, Me._ConnectionString)
            obj.Load(Me._PartnerAgentCertificationID)
            If (obj.CertificationID <> Me._CertificationID) Then
                blnReturn = True
            End If
            If (obj.PartnerAgentID <> Me._PartnerAgentID) Then
                blnReturn = True
            End If
            If (obj.CertificationNumber <> Me._CertificationNumber) Then
                blnReturn = True
            End If
            If (DateTime.Compare(obj.CertificationDate, Me._CertificationDate) <> 0) Then
                blnReturn = True
            End If
            If (DateTime.Compare(obj.CertificationExpires, Me._CertificationExpires) <> 0) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngPartnerAgentCertificationID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetPartnerAgentCertification")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PartnerAgentCertificationID", SqlDbType.Int).Value = lngPartnerAgentCertificationID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._PartnerAgentCertificationID = Conversions.ToLong(dtr.Item("PartnerAgentCertificationID"))
                    Me._CertificationID = Conversions.ToLong(dtr.Item("CertificationID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._PartnerAgentID = Conversions.ToLong(dtr.Item("PartnerAgentID"))
                    Me._CertificationNumber = dtr.Item("CertificationNumber").ToString
                    Me._CertificationDate = Conversions.ToDate(dtr.Item("CertificationDate"))
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("CertificationExpires"))) Then
                        Me._CertificationExpires = Conversions.ToDate(dtr.Item("CertificationExpires"))
                    Else
                        Me._CertificationExpires = New DateTime
                    End If
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
                Dim obj As New PartnerAgentCertificationRecord(Me._PartnerAgentCertificationID, Me._ConnectionString)
                obj.Load(Me._PartnerAgentCertificationID)
                If (obj.CertificationID <> Me._CertificationID) Then
                    Me.UpdateCertificationID(Me._CertificationID, (cnn))
                    strTemp = String.Concat(New String() { "CertificationID Changed to '", Conversions.ToString(Me._CertificationID), "' from '", Conversions.ToString(obj.CertificationID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.PartnerAgentID <> Me._PartnerAgentID) Then
                    Me.UpdatePartnerAgentID(Me._PartnerAgentID, (cnn))
                    strTemp = String.Concat(New String() { "PartnerAgentID Changed to '", Conversions.ToString(Me._PartnerAgentID), "' from '", Conversions.ToString(obj.PartnerAgentID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.CertificationNumber <> Me._CertificationNumber) Then
                    Me.UpdateCertificationNumber(Me._CertificationNumber, (cnn))
                    strTemp = String.Concat(New String() { "CertificationNumber Changed to '", Me._CertificationNumber, "' from '", obj.CertificationNumber, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (DateTime.Compare(obj.CertificationDate, Me._CertificationDate) <> 0) Then
                    Me.UpdateCertificationDate(Me._CertificationDate, (cnn))
                    strTemp = String.Concat(New String() { "CertificationDate Changed to '", Conversions.ToString(Me._CertificationDate), "' from '", Conversions.ToString(obj.CertificationDate), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (DateTime.Compare(obj.CertificationExpires, Me._CertificationExpires) <> 0) Then
                    Me.UpdateCertificationExpires((Me._CertificationExpires), (cnn))
                    strTemp = String.Concat(New String() { "CertificationExpires Changed to '", Conversions.ToString(Me._CertificationExpires), "' from '", Conversions.ToString(obj.CertificationExpires), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._PartnerAgentCertificationID)
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

        Private Sub UpdateCertificationDate(ByVal NewCertificationDate As DateTime, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentCertificationCertificationDate")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentCertificationID", SqlDbType.Int).Value = Me._PartnerAgentCertificationID
            cmd.Parameters.Add("@CertificationDate", SqlDbType.DateTime).Value = NewCertificationDate
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCertificationExpires(ByRef NewCertificationExpires As DateTime, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentCertificationCertificationExpires")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentCertificationID", SqlDbType.Int).Value = Me._PartnerAgentCertificationID
            Dim datNothing As New DateTime
            If (DateTime.Compare(NewCertificationExpires, datNothing) <> 0) Then
                cmd.Parameters.Add("@CertificationExpires", SqlDbType.DateTime).Value = CDate(NewCertificationExpires)
            Else
                cmd.Parameters.Add("@CertificationExpires", SqlDbType.DateTime).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCertificationID(ByVal NewCertificationID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentCertificationCertificationID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentCertificationID", SqlDbType.Int).Value = Me._PartnerAgentCertificationID
            cmd.Parameters.Add("@CertificationID", SqlDbType.Int).Value = NewCertificationID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCertificationNumber(ByVal NewCertificationNumber As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentCertificationCertificationNumber")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentCertificationID", SqlDbType.Int).Value = Me._PartnerAgentCertificationID
            cmd.Parameters.Add("@CertificationNumber", SqlDbType.VarChar, Me.TrimTrunc(NewCertificationNumber, &HFF).Length).Value = Me.TrimTrunc(NewCertificationNumber, &HFF)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdatePartnerAgentID(ByVal NewPartnerAgentID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentCertificationPartnerAgentID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentCertificationID", SqlDbType.Int).Value = Me._PartnerAgentCertificationID
            cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = NewPartnerAgentID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub


        ' Properties
        Public Property CertificationDate As DateTime
            Get
                Return Me._CertificationDate
            End Get
            Set(ByVal value As DateTime)
                Me._CertificationDate = value
            End Set
        End Property

        Public Property CertificationExpires As DateTime
            Get
                Return Me._CertificationExpires
            End Get
            Set(ByVal value As DateTime)
                Me._CertificationExpires = value
            End Set
        End Property

        Public Property CertificationID As Long
            Get
                Return Me._CertificationID
            End Get
            Set(ByVal value As Long)
                Me._CertificationID = value
            End Set
        End Property

        Public Property CertificationNumber As String
            Get
                Return Me._CertificationNumber
            End Get
            Set(ByVal value As String)
                Me._CertificationNumber = Me.TrimTrunc(value, &HFF)
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

        Public ReadOnly Property PartnerAgentCertificationID As Long
            Get
                Return Me._PartnerAgentCertificationID
            End Get
        End Property

        Public Property PartnerAgentID As Long
            Get
                Return Me._PartnerAgentID
            End Get
            Set(ByVal value As Long)
                Me._PartnerAgentID = value
            End Set
        End Property


        ' Fields
        Private _CertificationDate As DateTime
        Private _CertificationExpires As DateTime
        Private _CertificationID As Long
        Private _CertificationNumber As String
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _PartnerAgentCertificationID As Long
        Private _PartnerAgentID As Long
        Private Const CertificationNumberMaxLength As Integer = &HFF
    End Class
End Namespace

