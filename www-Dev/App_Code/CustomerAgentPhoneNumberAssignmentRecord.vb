Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class CustomerAgentPhoneNumberAssignmentRecord
        ' Methods
        Public Sub New()
            Me._AssignmentID = 0
            Me._CreatedBy = 0
            Me._CustomerAgentID = 0
            Me._CustomerPhoneNumberID = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._AssignmentID = 0
            Me._CreatedBy = 0
            Me._CustomerAgentID = 0
            Me._CustomerPhoneNumberID = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngAssignmentID As Long, ByVal strConnectionString As String)
            Me._AssignmentID = 0
            Me._CreatedBy = 0
            Me._CustomerAgentID = 0
            Me._CustomerPhoneNumberID = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._AssignmentID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal lngCustomerAgentID As Long, ByVal lngCustomerPhoneNumberID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddCustomerAgentPhoneNumberAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngAssignmentID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@CustomerAgentID", SqlDbType.Int).Value = lngCustomerAgentID
                cmd.Parameters.Add("@CustomerPhoneNumberID", SqlDbType.Int).Value = lngCustomerPhoneNumberID
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
            Me._CustomerAgentID = 0
            Me._CustomerPhoneNumberID = 0
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveCustomerAgentPhoneNumberAssignment")
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
            Dim obj As New CustomerAgentPhoneNumberAssignmentRecord(Me._AssignmentID, Me._ConnectionString)
            obj.Load(Me._AssignmentID)
            If (obj.CustomerAgentID <> Me._CustomerAgentID) Then
                blnReturn = True
            End If
            If (obj.CustomerPhoneNumberID <> Me._CustomerPhoneNumberID) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngAssignmentID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetCustomerAgentPhoneNumberAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@AssignmentID", SqlDbType.Int).Value = lngAssignmentID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._AssignmentID = Conversions.ToLong(dtr.Item("AssignmentID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._CustomerAgentID = Conversions.ToLong(dtr.Item("CustomerAgentID"))
                    Me._CustomerPhoneNumberID = Conversions.ToLong(dtr.Item("CustomerPhoneNumberID"))
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
                Dim obj As New CustomerAgentPhoneNumberAssignmentRecord(Me._AssignmentID, Me._ConnectionString)
                obj.Load(Me._AssignmentID)
                If (obj.CustomerAgentID <> Me._CustomerAgentID) Then
                    Me.UpdateCustomerAgentID(Me._CustomerAgentID, (cnn))
                    strTemp = String.Concat(New String() { "CustomerAgentID Changed to '", Conversions.ToString(Me._CustomerAgentID), "' from '", Conversions.ToString(obj.CustomerAgentID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.CustomerPhoneNumberID <> Me._CustomerPhoneNumberID) Then
                    Me.UpdateCustomerPhoneNumberID(Me._CustomerPhoneNumberID, (cnn))
                    strTemp = String.Concat(New String() { "CustomerPhoneNumberID Changed to '", Conversions.ToString(Me._CustomerPhoneNumberID), "' from '", Conversions.ToString(obj.CustomerPhoneNumberID), "'" })
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

        Private Sub UpdateCustomerAgentID(ByVal NewCustomerAgentID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerAgentPhoneNumberAssignmentCustomerAgentID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@AssignmentID", SqlDbType.BigInt).Value = Me._AssignmentID
            cmd.Parameters.Add("@CustomerAgentID", SqlDbType.Int).Value = NewCustomerAgentID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCustomerPhoneNumberID(ByVal NewCustomerPhoneNumberID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerAgentPhoneNumberAssignmentCustomerPhoneNumberID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@AssignmentID", SqlDbType.BigInt).Value = Me._AssignmentID
            cmd.Parameters.Add("@CustomerPhoneNumberID", SqlDbType.Int).Value = NewCustomerPhoneNumberID
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

        Public Property CustomerAgentID As Long
            Get
                Return Me._CustomerAgentID
            End Get
            Set(ByVal value As Long)
                Me._CustomerAgentID = value
            End Set
        End Property

        Public Property CustomerPhoneNumberID As Long
            Get
                Return Me._CustomerPhoneNumberID
            End Get
            Set(ByVal value As Long)
                Me._CustomerPhoneNumberID = value
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
        Private _CustomerAgentID As Long
        Private _CustomerPhoneNumberID As Long
        Private _DateCreated As DateTime
    End Class
End Namespace

