Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class PositionRecord
        ' Methods
        Public Sub New()
            Me._PositionID = -1
            Me._Position = ""
            Me._Active = True
            Me._ConnectionString = ""
            Me.ClearProperties
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._PositionID = -1
            Me._Position = ""
            Me._Active = True
            Me._ConnectionString = ""
            Me.ClearProperties
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal PositionID As Long, ByVal strConnectionString As String)
            Me._PositionID = -1
            Me._Position = ""
            Me._Active = True
            Me._ConnectionString = ""
            Me.ClearProperties
            Me._ConnectionString = strConnectionString
            Me.Load(PositionID)
        End Sub

        Public Function Add(ByVal strPosition As String) As Long
            Me.Position = strPosition
            Return Me.AddPosition
        End Function

        Public Function Add(ByVal strPosition As String, ByVal strConnectionstring As String) As Long
            Me._ConnectionString = strConnectionstring
            Me.Position = strPosition
            Return Me.AddPosition
        End Function

        Private Function AddPosition() As Long
            Dim cnn As New SqlConnection(Me._ConnectionString)
            Dim cmd As New SqlCommand("spAddPosition")
            Dim lngReturn As Long = 0
            cmd.CommandType = CommandType.StoredProcedure
            If (Me._Position.Length > 0) Then
                cmd.Parameters.Add("@Position", SqlDbType.VarChar, Me._Position.Length).Value = Me._Position
                cnn.Open
                cmd.Connection = cnn
                lngReturn = Convert.ToInt32(RuntimeHelpers.GetObjectValue(cmd.ExecuteScalar))
                cnn.Close
                Return lngReturn
            End If
            Return -1
        End Function

        Private Sub ClearProperties()
            Me._PositionID = -1
            Me._Position = ""
        End Sub

        Public Sub Deactivate()
            Dim cnn As New SqlConnection(Me._ConnectionString)
            Dim cmd As New SqlCommand
            If (Me._PositionID > -1) Then
                cnn.Open
                cmd.Connection = cnn
                cmd.CommandText = "spDeactivatePosition"
                cmd.Parameters.Add("@PositionID", SqlDbType.Int).Value = Me._PositionID
                cmd.CommandType = CommandType.StoredProcedure
                cmd.ExecuteNonQuery
                Me._Active = False
                cnn.Close
            End If
        End Sub

        Public Sub Delete()
            Dim cnn As New SqlConnection(Me._ConnectionString)
            Dim cmd As New SqlCommand
            If (Me._PositionID > -1) Then
                cnn.Open
                cmd.Connection = cnn
                cmd.CommandText = "spRemovePosition"
                cmd.Parameters.Add("@PositionID", SqlDbType.Int).Value = Me._PositionID
                cmd.CommandType = CommandType.StoredProcedure
                cmd.ExecuteNonQuery
                Me.Load(Me._PositionID)
                cnn.Close
            End If
        End Sub

        Public Sub Load(ByVal PositionID As Long)
            Dim cnn As New SqlConnection(Me._ConnectionString)
            Dim cmd As New SqlCommand
            cmd.CommandText = "spGetPosition"
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PositionID", SqlDbType.Int).Value = PositionID
            cnn.Open
            cmd.Connection = cnn
            Dim dtr As SqlDataReader = cmd.ExecuteReader
            If dtr.Read Then
                Me._PositionID = Convert.ToInt32(RuntimeHelpers.GetObjectValue(dtr.Item("PositionID")))
                Me._Position = dtr.Item("Position").ToString
                Me._Active = Convert.ToBoolean(RuntimeHelpers.GetObjectValue(dtr.Item("Active")))
            Else
                Me._PositionID = -1
                Me._Position = ""
                Me._Active = False
            End If
            cnn.Close
        End Sub

        Public Function Save() As Long
            If (Me._PositionID > -1) Then
                Return Me.SavePosition
            End If
            Return Me.Add(Me._Position)
        End Function

        Private Function SavePosition() As Long
            Dim cnn As New SqlConnection(Me.ConnectionString)
            Dim cmd As New SqlCommand("spUpdatePosition")
            cmd.CommandType = CommandType.StoredProcedure
            If (Me._PositionID <= -1) Then
                Return Me._PositionID
                Exit Function
            End If
            If (Me._Position.Length > 0) Then
                cnn.Open
                cmd.Connection = cnn
                cmd.Parameters.Add("@PositionID", SqlDbType.Int).Value = Me._PositionID
                cmd.Parameters.Add("@Position", SqlDbType.VarChar, Me._Position.Length).Value = Me._Position
                cmd.Parameters.Add("@Active", SqlDbType.Bit).Value = Me._Active
                cmd.ExecuteNonQuery
                cnn.Close
                Return Me._PositionID
            End If
            Me.Deactivate
            Return -1
        End Function


        ' Properties
        Public Property Active As Boolean
            Get
                Return Me._Active
            End Get
            Set(ByVal value As Boolean)
                Me._Active = value
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

        Public Property Position As String
            Get
                Return Me._Position
            End Get
            Set(ByVal value As String)
                If (value.Length <= &H10) Then
                    Me._Position = value
                Else
                    Me._Position = value.Substring(0, &H10)
                End If
            End Set
        End Property

        Public ReadOnly Property PositionID As Long
            Get
                Return Me._PositionID
            End Get
        End Property


        ' Fields
        Private _Active As Boolean
        Private _ConnectionString As String
        Private _Position As String
        Private _PositionID As Long
        Private Const PositionMaxLength As Integer = &H10
    End Class
End Namespace

