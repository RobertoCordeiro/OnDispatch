Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class PositionRoleAssignmentRecord
        ' Methods
        Public Sub New()
            Me._PositionID = 0
            Me._RoleID = 0
            Me._ConnectionString = ""
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._PositionID = 0
            Me._RoleID = 0
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngRoleID As Long, ByVal lngPositionID As Long, ByVal strConnectionString As String)
            Me._PositionID = 0
            Me._RoleID = 0
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(lngRoleID, lngPositionID)
        End Sub

        Public Sub Add(ByVal lngRoleID As Long, ByVal lngPositionID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddPositionRoleAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PositionID", SqlDbType.Int).Value = lngPositionID
                cmd.Parameters.Add("@RoleID", SqlDbType.Int).Value = lngRoleID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                Me.Load(lngRoleID, lngPositionID)
                cnn.Close
            End If
        End Sub

        Private Sub ClearValues()
            Me._RoleID = 0
            Me._PositionID = 0
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemovePositionRoleAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PositionID", SqlDbType.Int).Value = Me._PositionID
                cmd.Parameters.Add("@RoleID", SqlDbType.Int).Value = Me._RoleID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._RoleID, Me._PositionID)
            End If
        End Sub

        Public Sub Load(ByVal lngRoleID As Long, ByVal lngPositionID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetPositionRoleAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PositionID", SqlDbType.Int).Value = lngPositionID
                cmd.Parameters.Add("@RoleID", SqlDbType.Int).Value = lngRoleID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._PositionID = Conversions.ToLong(dtr.Item("PositionID"))
                    Me._RoleID = Conversions.ToLong(dtr.Item("RoleID"))
                Else
                    Me.ClearValues
                End If
                dtr.Close
                cnn.Close
            Else
                Me.ClearValues
            End If
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

        Public ReadOnly Property PositionID As Long
            Get
                Return Me._PositionID
            End Get
        End Property

        Public ReadOnly Property RoleID As Long
            Get
                Return Me._RoleID
            End Get
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _PositionID As Long
        Private _RoleID As Long
    End Class
End Namespace

