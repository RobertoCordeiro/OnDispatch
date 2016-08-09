Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class ServiceTypeManufacturerAssignmentRecord
        ' Methods
        Public Sub New()
            Me._AssignmentID = 0
            Me._CreatedBy = 0
            Me._ServiceTypeID = 0
            Me._ManufacturerID = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._AssignmentID = 0
            Me._CreatedBy = 0
            Me._ServiceTypeID = 0
            Me._ManufacturerID = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngAssignmentID As Long, ByVal strConnectionString As String)
            Me._AssignmentID = 0
            Me._CreatedBy = 0
            Me._ServiceTypeID = 0
            Me._ManufacturerID = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._AssignmentID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal lngServiceTypeID As Long, ByVal lngManufacturerID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddServiceTypeManufacturerAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngAssignmentID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@ServiceTypeID", SqlDbType.Int).Value = lngServiceTypeID
                cmd.Parameters.Add("@ManufacturerID", SqlDbType.Int).Value = lngManufacturerID
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
            Me._ServiceTypeID = 0
            Me._ManufacturerID = 0
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveServiceTypeManufacturerAssignment")
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
            Dim obj As New ServiceTypeManufacturerAssignmentRecord(Me._AssignmentID, Me._ConnectionString)
            obj.Load(Me._AssignmentID)
            If (obj.ServiceTypeID <> Me._ServiceTypeID) Then
                blnReturn = True
            End If
            If (obj.ManufacturerID <> Me._ManufacturerID) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngAssignmentID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetServiceTypeManufacturerAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@AssignmentID", SqlDbType.Int).Value = lngAssignmentID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._AssignmentID = Conversions.ToLong(dtr.Item("AssignmentID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._ServiceTypeID = Conversions.ToLong(dtr.Item("ServiceTypeID"))
                    Me._ManufacturerID = Conversions.ToLong(dtr.Item("ManufacturerID"))
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
                Dim obj As New ServiceTypeManufacturerAssignmentRecord(Me._AssignmentID, Me._ConnectionString)
                obj.Load(Me._AssignmentID)
                If (obj.ServiceTypeID <> Me._ServiceTypeID) Then
                    Me.UpdateServiceTypeID(Me._ServiceTypeID, (cnn))
                    strTemp = String.Concat(New String() { "ServiceTypeID Changed to '", Conversions.ToString(Me._ServiceTypeID), "' from '", Conversions.ToString(obj.ServiceTypeID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ManufacturerID <> Me._ManufacturerID) Then
                    Me.UpdateManufacturerID(Me._ManufacturerID, (cnn))
                    strTemp = String.Concat(New String() { "ManufacturerID Changed to '", Conversions.ToString(Me._ManufacturerID), "' from '", Conversions.ToString(obj.ManufacturerID), "'" })
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

        Private Sub UpdateManufacturerID(ByVal NewManufacturerID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateServiceTypeManufacturerAssignmentManufacturerID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@AssignmentID", SqlDbType.BigInt).Value = Me._AssignmentID
            cmd.Parameters.Add("@ManufacturerID", SqlDbType.Int).Value = NewManufacturerID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateServiceTypeID(ByVal NewServiceTypeID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateServiceTypeManufacturerAssignmentServiceTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@AssignmentID", SqlDbType.BigInt).Value = Me._AssignmentID
            cmd.Parameters.Add("@ServiceTypeID", SqlDbType.Int).Value = NewServiceTypeID
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

        Public Property ManufacturerID As Long
            Get
                Return Me._ManufacturerID
            End Get
            Set(ByVal value As Long)
                Me._ManufacturerID = value
            End Set
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public Property ServiceTypeID As Long
            Get
                Return Me._ServiceTypeID
            End Get
            Set(ByVal value As Long)
                Me._ServiceTypeID = value
            End Set
        End Property


        ' Fields
        Private _AssignmentID As Long
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _ManufacturerID As Long
        Private _ServiceTypeID As Long
    End Class
End Namespace

