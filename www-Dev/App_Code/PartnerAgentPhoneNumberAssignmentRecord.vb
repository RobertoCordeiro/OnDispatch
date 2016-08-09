Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class PartnerAgentPhoneNumberAssignmentRecord
        ' Methods
        Public Sub New()
            Me._AssignmentID = 0
            Me._CreatedBy = 0
            Me._PartnerAgentID = 0
            Me._PartnerPhoneNumberID = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._AssignmentID = 0
            Me._CreatedBy = 0
            Me._PartnerAgentID = 0
            Me._PartnerPhoneNumberID = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngAssignmentID As Long, ByVal strConnectionString As String)
            Me._AssignmentID = 0
            Me._CreatedBy = 0
            Me._PartnerAgentID = 0
            Me._PartnerPhoneNumberID = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._AssignmentID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal lngPartnerAgentID As Long, ByVal lngPartnerPhoneNumberID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddPartnerAgentPhoneNumberAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngAssignmentID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = lngPartnerAgentID
                cmd.Parameters.Add("@PartnerPhoneNumberID", SqlDbType.Int).Value = lngPartnerPhoneNumberID
                cnn.Open
                cmd.Connection = cnn
                lngAssignmentID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngAssignmentID > 0) Then
                    Me.Load(lngAssignmentID)
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
            Me._AssignmentID = 0
            Me._CreatedBy = 0
            Me._PartnerAgentID = 0
            Me._PartnerPhoneNumberID = 0
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemovePartnerAgentPhoneNumberAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@AssignmentID", SqlDbType.Int).Value = Me._AssignmentID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._AssignmentID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New PartnerAgentPhoneNumberAssignmentRecord(Me._AssignmentID, Me._ConnectionString)
            obj.Load(Me._AssignmentID)
            If (obj.PartnerAgentID <> Me._PartnerAgentID) Then
                blnReturn = True
            End If
            If (obj.PartnerPhoneNumberID <> Me._PartnerPhoneNumberID) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngAssignmentID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetPartnerAgentPhoneNumberAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@AssignmentID", SqlDbType.Int).Value = lngAssignmentID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._AssignmentID = Conversions.ToLong(dtr.Item("AssignmentID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._PartnerAgentID = Conversions.ToLong(dtr.Item("PartnerAgentID"))
                    Me._PartnerPhoneNumberID = Conversions.ToLong(dtr.Item("PartnerPhoneNumberID"))
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
                Dim obj As New PartnerAgentPhoneNumberAssignmentRecord(Me._AssignmentID, Me._ConnectionString)
                obj.Load(Me._AssignmentID)
                If (obj.PartnerAgentID <> Me._PartnerAgentID) Then
                    Me.UpdatePartnerAgentID(Me._PartnerAgentID, (cnn))
                    strTemp = String.Concat(New String() { "PartnerAgentID Changed to '", Conversions.ToString(Me._PartnerAgentID), "' from '", Conversions.ToString(obj.PartnerAgentID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.PartnerPhoneNumberID <> Me._PartnerPhoneNumberID) Then
                    Me.UpdatePartnerPhoneNumberID(Me._PartnerPhoneNumberID, (cnn))
                    strTemp = String.Concat(New String() { "PartnerPhoneNumberID Changed to '", Conversions.ToString(Me._PartnerPhoneNumberID), "' from '", Conversions.ToString(obj.PartnerPhoneNumberID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._AssignmentID)
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

        Private Sub UpdatePartnerAgentID(ByVal NewPartnerAgentID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentPhoneNumberAssignmentPartnerAgentID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@AssignmentID", SqlDbType.BigInt).Value = Me._AssignmentID
            cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = NewPartnerAgentID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdatePartnerPhoneNumberID(ByVal NewPartnerPhoneNumberID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentPhoneNumberAssignmentPartnerPhoneNumberID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@AssignmentID", SqlDbType.BigInt).Value = Me._AssignmentID
            cmd.Parameters.Add("@PartnerPhoneNumberID", SqlDbType.Int).Value = NewPartnerPhoneNumberID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub


        ' Properties
        Public ReadOnly Property AssignmentID As Long
            Get
                Return Me._AssignmentID
            End Get
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

        Public Property PartnerAgentID As Long
            Get
                Return Me._PartnerAgentID
            End Get
            Set(ByVal value As Long)
                Me._PartnerAgentID = value
            End Set
        End Property

        Public Property PartnerPhoneNumberID As Long
            Get
                Return Me._PartnerPhoneNumberID
            End Get
            Set(ByVal value As Long)
                Me._PartnerPhoneNumberID = value
            End Set
        End Property


        ' Fields
        Private _AssignmentID As Long
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _PartnerAgentID As Long
        Private _PartnerPhoneNumberID As Long
    End Class
End Namespace

