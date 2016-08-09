Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class AddressTypeRecord
        ' Methods
        Public Sub New()
            Me._AddressTypeID = -1
            Me._AddressType = ""
        End Sub

        Public Sub New(ByVal strConnectionstring As String)
            Me._AddressTypeID = -1
            Me._AddressType = ""
            Me._ConnectionString = strConnectionstring
        End Sub

        Public Sub New(ByVal lngAddressTypeID As Long, ByVal strConnectionstring As String)
            Me._AddressTypeID = -1
            Me._AddressType = ""
            Me._ConnectionString = strConnectionstring
            Me.Load(lngAddressTypeID)
        End Sub

        Public Sub New(ByVal strAddressType As String, ByVal strConnectionString As String)
            Me._AddressTypeID = -1
            Me._AddressType = ""
            Me._ConnectionString = strConnectionString
            Me.AddressType = strAddressType
            Me.Add
        End Sub

        Public Function Add() As Long
            Dim lngReturn As Long = 0
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddAddressType")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@AddressType", SqlDbType.VarChar, Me._AddressType.Length).Value = Me._AddressType
                cnn.Open
                cmd.Connection = cnn
                lngReturn = Convert.ToInt32(RuntimeHelpers.GetObjectValue(cmd.ExecuteScalar))
                cnn.Close
            End If
            Me.Load(lngReturn)
            Return lngReturn
        End Function

        Public Function Add(ByVal strAddressType As String) As Long
            Me.AddressType = strAddressType
            Return Me.Add
        End Function

        Private Sub ClearValues()
            Me._AddressTypeID = -1
            Me._AddressType = ""
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveAddressType")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@AddressTypeID", SqlDbType.Int).Value = Me._AddressTypeID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
            End If
            Me.Load(Me._AddressTypeID)
        End Sub

        Public Sub Load(ByVal lngAddressTypeID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetAddressType")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@AddressTypeID", SqlDbType.Int).Value = lngAddressTypeID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._AddressTypeID = Convert.ToInt32(RuntimeHelpers.GetObjectValue(dtr.Item("AddressTypeID")))
                    Me._AddressType = dtr.Item("AddressType").ToString
                Else
                    Me.ClearValues
                End If
                cnn.Close
            End If
        End Sub

        Public Sub Save()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim adtCompare As New AddressTypeRecord(Me._AddressTypeID, Me._ConnectionString)
                If ((adtCompare.AddressType <> Me._AddressType) AndAlso (Me._AddressType.Trim.Length > 0)) Then
                    Dim cnn As New SqlConnection(Me._ConnectionString)
                    Dim cmd As New SqlCommand("spUpdateAddressType")
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.Add("@AddressType", SqlDbType.VarChar, Me._AddressType.Length).Value = Me._AddressType
                    cnn.Open
                    cmd.Connection = cnn
                    cmd.ExecuteNonQuery
                    cnn.Close
                End If
            End If
        End Sub


        ' Properties
        Public Property AddressType As String
            Get
                Return Me._AddressType
            End Get
            Set(ByVal value As String)
                If (value.Length <= &H20) Then
                    Me._AddressType = value
                Else
                    Me._AddressType = value.Substring(0, &H20)
                End If
            End Set
        End Property

        Public ReadOnly Property AddressTypeID As Long
            Get
                Return Me._AddressTypeID
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


        ' Fields
        Private _AddressType As String
        Private _AddressTypeID As Long
        Private _ConnectionString As String
        Private Const AddressTypeMaxLength As Integer = &H20
    End Class
End Namespace

