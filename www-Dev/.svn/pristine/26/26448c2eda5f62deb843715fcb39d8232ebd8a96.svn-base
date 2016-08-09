Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class PartnerAgentAddressAssignmentRecord
        ' Methods
        Public Sub New()
            Me._PartnerAgentAddressAssignmentID = 0
            Me._CreatedBy = 0
            Me._PartnerAddressID = 0
            Me._PartnerAgentID = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._PartnerAgentAddressAssignmentID = 0
            Me._CreatedBy = 0
            Me._PartnerAddressID = 0
            Me._PartnerAgentID = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngPartnerAgentAddressAssignmentID As Long, ByVal strConnectionString As String)
            Me._PartnerAgentAddressAssignmentID = 0
            Me._CreatedBy = 0
            Me._PartnerAddressID = 0
            Me._PartnerAgentID = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._PartnerAgentAddressAssignmentID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal lngPartnerAddressID As Long, ByVal lngPartnerAgentID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddPartnerAgentAddressAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngPartnerAgentAddressAssignmentID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@PartnerAddressID", SqlDbType.Int).Value = lngPartnerAddressID
                cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = lngPartnerAgentID
                cnn.Open
                cmd.Connection = cnn
                lngPartnerAgentAddressAssignmentID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngPartnerAgentAddressAssignmentID > 0) Then
                    Me.Load(lngPartnerAgentAddressAssignmentID)
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
            Me._PartnerAgentAddressAssignmentID = 0
            Me._CreatedBy = 0
            Me._PartnerAddressID = 0
            Me._PartnerAgentID = 0
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemovePartnerAgentAddressAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PartnerAgentAddressAssignmentID", SqlDbType.Int).Value = Me._PartnerAgentAddressAssignmentID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._PartnerAgentAddressAssignmentID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New PartnerAgentAddressAssignmentRecord(Me._PartnerAgentAddressAssignmentID, Me._ConnectionString)
            obj.Load(Me._PartnerAgentAddressAssignmentID)
            If (obj.PartnerAddressID <> Me._PartnerAddressID) Then
                blnReturn = True
            End If
            If (obj.PartnerAgentID <> Me._PartnerAgentID) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngPartnerAgentAddressAssignmentID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetPartnerAgentAddressAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PartnerAgentAddressAssignmentID", SqlDbType.Int).Value = lngPartnerAgentAddressAssignmentID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._PartnerAgentAddressAssignmentID = Conversions.ToLong(dtr.Item("PartnerAgentAddressAssignmentID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._PartnerAddressID = Conversions.ToLong(dtr.Item("PartnerAddressID"))
                    Me._PartnerAgentID = Conversions.ToLong(dtr.Item("PartnerAgentID"))
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
                Dim obj As New PartnerAgentAddressAssignmentRecord(Me._PartnerAgentAddressAssignmentID, Me._ConnectionString)
                obj.Load(Me._PartnerAgentAddressAssignmentID)
                If (obj.PartnerAddressID <> Me._PartnerAddressID) Then
                    Me.UpdatePartnerAddressID(Me._PartnerAddressID, (cnn))
                    strTemp = String.Concat(New String() { "PartnerAddressID Changed to '", Conversions.ToString(Me._PartnerAddressID), "' from '", Conversions.ToString(obj.PartnerAddressID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.PartnerAgentID <> Me._PartnerAgentID) Then
                    Me.UpdatePartnerAgentID(Me._PartnerAgentID, (cnn))
                    strTemp = String.Concat(New String() { "PartnerAgentID Changed to '", Conversions.ToString(Me._PartnerAgentID), "' from '", Conversions.ToString(obj.PartnerAgentID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._PartnerAgentAddressAssignmentID)
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

        Private Sub UpdatePartnerAddressID(ByVal NewPartnerAddressID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentAddressAssignmentPartnerAddressID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentAddressAssignmentID", SqlDbType.Int).Value = Me._PartnerAgentAddressAssignmentID
            cmd.Parameters.Add("@PartnerAddressID", SqlDbType.Int).Value = NewPartnerAddressID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdatePartnerAgentID(ByVal NewPartnerAgentID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentAddressAssignmentPartnerAgentID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentAddressAssignmentID", SqlDbType.Int).Value = Me._PartnerAgentAddressAssignmentID
            cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = NewPartnerAgentID
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

        Public Property PartnerAddressID As Long
            Get
                Return Me._PartnerAddressID
            End Get
            Set(ByVal value As Long)
                Me._PartnerAddressID = value
            End Set
        End Property

        Public ReadOnly Property PartnerAgentAddressAssignmentID As Long
            Get
                Return Me._PartnerAgentAddressAssignmentID
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
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _PartnerAddressID As Long
        Private _PartnerAgentAddressAssignmentID As Long
        Private _PartnerAgentID As Long
    End Class
End Namespace

