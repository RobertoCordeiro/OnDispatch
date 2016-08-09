Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class CustomerAgentAddressAssignmentRecord
        ' Methods
        Public Sub New()
            Me._AssignmentID = 0
            Me._CustomerAgentID = 0
            Me._CustomerAddressID = 0
            Me._DateCreated = DateTime.Now
            Me._CreatedBy = 0
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._AssignmentID = 0
            Me._CustomerAgentID = 0
            Me._CustomerAddressID = 0
            Me._DateCreated = DateTime.Now
            Me._CreatedBy = 0
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngAssignmentID As Long, ByVal strConnectionString As String)
            Me._AssignmentID = 0
            Me._CustomerAgentID = 0
            Me._CustomerAddressID = 0
            Me._DateCreated = DateTime.Now
            Me._CreatedBy = 0
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._AssignmentID)
        End Sub

        Public Sub Add(ByVal lngCustomerAgentID As Long, ByVal lngCustomerAddressID As Long, ByVal lngCreatedBy As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddCustomerAgentAddressAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngAssignmentID As Long = 0
                cmd.Parameters.Add("@CustomerAgentID", SqlDbType.Int).Value = lngCustomerAgentID
                cmd.Parameters.Add("@CustomerAddressID", SqlDbType.Int).Value = lngCustomerAddressID
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
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
            Me._CustomerAgentID = 0
            Me._CustomerAddressID = 0
            Me._DateCreated = DateTime.Now
            Me._CreatedBy = 0
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveCustomerAgentAddressAssignment")
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
            Dim obj As New CustomerAgentAddressAssignmentRecord(Me._AssignmentID, Me._ConnectionString)
            obj.Load(Me._AssignmentID)
            If (obj.CustomerAgentID <> Me._CustomerAgentID) Then
                blnReturn = True
            End If
            If (obj.CustomerAddressID <> Me._CustomerAddressID) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngAssignmentID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetCustomerAgentAddressAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@AssignmentID", SqlDbType.Int).Value = lngAssignmentID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._AssignmentID = Conversions.ToLong(dtr.Item("AssignmentID"))
                    Me._CustomerAgentID = Conversions.ToLong(dtr.Item("CustomerAgentID"))
                    Me._CustomerAddressID = Conversions.ToLong(dtr.Item("CustomerAddressID"))
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
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
                Dim obj As New CustomerAgentAddressAssignmentRecord(Me._AssignmentID, Me._ConnectionString)
                obj.Load(Me._AssignmentID)
                If (obj.CustomerAgentID <> Me._CustomerAgentID) Then
                    Me.UpdateCustomerAgentID(Me._CustomerAgentID, (cnn))
                    strTemp = String.Concat(New String() { "CustomerAgentID Changed to '", Conversions.ToString(Me._CustomerAgentID), "' from '", Conversions.ToString(obj.CustomerAgentID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.CustomerAddressID <> Me._CustomerAddressID) Then
                    Me.UpdateCustomerAddressID(Me._CustomerAddressID, (cnn))
                    strTemp = String.Concat(New String() { "CustomerAddressID Changed to '", Conversions.ToString(Me._CustomerAddressID), "' from '", Conversions.ToString(obj.CustomerAddressID), "'" })
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

        Private Sub UpdateCustomerAddressID(ByVal NewCustomerAddressID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerAgentAddressAssignmentCustomerAddressID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@AssignmentID", SqlDbType.BigInt).Value = Me._AssignmentID
            cmd.Parameters.Add("@CustomerAddressID", SqlDbType.Int).Value = NewCustomerAddressID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCustomerAgentID(ByVal NewCustomerAgentID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerAgentAddressAssignmentCustomerAgentID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@AssignmentID", SqlDbType.BigInt).Value = Me._AssignmentID
            cmd.Parameters.Add("@CustomerAgentID", SqlDbType.Int).Value = NewCustomerAgentID
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

        Public Property CustomerAddressID As Long
            Get
                Return Me._CustomerAddressID
            End Get
            Set(ByVal value As Long)
                Me._CustomerAddressID = value
            End Set
        End Property

        Public Property CustomerAgentID As Long
            Get
                Return Me._CustomerAgentID
            End Get
            Set(ByVal value As Long)
                Me._CustomerAgentID = value
            End Set
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
        Private _AssignmentID As Long
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _CustomerAddressID As Long
        Private _CustomerAgentID As Long
        Private _DateCreated As DateTime
    End Class
End Namespace

