Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class IdentificationTypeRecord
        ' Methods
        Public Sub New()
            Me._IdentificationTypeID = -1
            Me._IdentificationType = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionstring As String)
            Me._IdentificationTypeID = -1
            Me._IdentificationType = ""
            Me._ConnectionString = strConnectionstring
        End Sub

        Public Sub New(ByVal lngIdentificationTypeID As Long, ByVal strConnectionstring As String)
            Me._IdentificationTypeID = -1
            Me._IdentificationType = ""
            Me._ConnectionString = strConnectionstring
            Me.Load(lngIdentificationTypeID)
        End Sub

        Public Sub New(ByVal strIdentificationType As String, ByVal strConnectionString As String)
            Me._IdentificationTypeID = -1
            Me._IdentificationType = ""
            Me._ConnectionString = strConnectionString
            Me.IdentificationType = strIdentificationType
            Me.Add
        End Sub

        Public Function Add() As Long
            Dim lngReturn As Long = 0
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddIdentificationType")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@IdentificationType", SqlDbType.VarChar, Me._IdentificationType.Length).Value = Me._IdentificationType
                cnn.Open
                cmd.Connection = cnn
                lngReturn = Convert.ToInt32(RuntimeHelpers.GetObjectValue(cmd.ExecuteScalar))
                cnn.Close
            End If
            Me.Load(lngReturn)
            Return lngReturn
        End Function

        Public Function Add(ByVal strIdentificationType As String) As Long
            Me.IdentificationType = strIdentificationType
            Return Me.Add
        End Function

        Private Sub ClearValues()
            Me._IdentificationTypeID = -1
            Me._IdentificationType = ""
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveIdentificationType")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@IdentificationTypeID", SqlDbType.Int).Value = Me._IdentificationTypeID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
            End If
            Me.Load(Me._IdentificationTypeID)
        End Sub

        Public Sub Load(ByVal lngIdentificationTypeID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetIdentificationType")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@IdentificationTypeID", SqlDbType.Int).Value = lngIdentificationTypeID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._IdentificationTypeID = Convert.ToInt32(RuntimeHelpers.GetObjectValue(dtr.Item("IdentificationTypeID")))
                    Me._IdentificationType = dtr.Item("IdentificationType").ToString
                Else
                    Me.ClearValues
                End If
                cnn.Close
            End If
        End Sub

        Public Sub Save()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim adtCompare As New IdentificationTypeRecord(Me._IdentificationTypeID, Me._ConnectionString)
                If ((adtCompare.IdentificationType <> Me._IdentificationType) AndAlso (Me._IdentificationType.Trim.Length > 0)) Then
                    Dim cnn As New SqlConnection(Me._ConnectionString)
                    Dim cmd As New SqlCommand("spUpdateIdentificationType")
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.Add("@IdentificationType", SqlDbType.VarChar, Me._IdentificationType.Length).Value = Me._IdentificationType
                    cnn.Open
                    cmd.Connection = cnn
                    cmd.ExecuteNonQuery
                    cnn.Close
                End If
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

        Public Property IdentificationType As String
            Get
                Return Me._IdentificationType
            End Get
            Set(ByVal value As String)
                If (value.Length <= &H20) Then
                    Me._IdentificationType = value
                Else
                    Me._IdentificationType = value.Substring(0, &H20)
                End If
            End Set
        End Property

        Public ReadOnly Property IdentificationTypeID As Long
            Get
                Return Me._IdentificationTypeID
            End Get
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _IdentificationType As String
        Private _IdentificationTypeID As Long
        Private Const IdentificationTypeMaxLength As Integer = &H20
    End Class
End Namespace

