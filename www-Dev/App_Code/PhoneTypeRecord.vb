Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices
Namespace BridgesInterface
    Public Class PhoneTypeRecord
        ' Methods
        Public Sub New()
            Me._PhoneTypeID = -1
            Me._PhoneType = ""
            Me._ConnectionString = ""
            Me.ClearProperties
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._PhoneTypeID = -1
            Me._PhoneType = ""
            Me._ConnectionString = ""
            Me.ClearProperties
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal PhoneTypeID As Long, ByVal strConnectionString As String)
            Me._PhoneTypeID = -1
            Me._PhoneType = ""
            Me._ConnectionString = ""
            Me.ClearProperties
            Me._ConnectionString = strConnectionString
            Me.Load(PhoneTypeID)
        End Sub

        Public Function Add(ByVal strPhoneType As String) As Long
            Me.PhoneType = strPhoneType
            Return Me.AddPhoneType
        End Function

        Public Function Add(ByVal strPhoneType As String, ByVal strConnectionstring As String) As Long
            Me._ConnectionString = strConnectionstring
            Me.PhoneType = strPhoneType
            Return Me.AddPhoneType
        End Function

        Private Function AddPhoneType() As Long
            Dim cnn As New SqlConnection(Me._ConnectionString)
            Dim cmd As New SqlCommand("spAddPhoneType")
            Dim lngReturn As Long = 0
            cmd.CommandType = CommandType.StoredProcedure
            If (Me._PhoneType.Length > 0) Then
                cmd.Parameters.Add("@PhoneType", SqlDbType.VarChar, Me._PhoneType.Length).Value = Me._PhoneType
                cnn.Open
                cmd.Connection = cnn
                lngReturn = Convert.ToInt32(RuntimeHelpers.GetObjectValue(cmd.ExecuteScalar))
                cnn.Close
                Return lngReturn
            End If
            Return -1
        End Function

        Private Sub ClearProperties()
            Me._PhoneTypeID = -1
            Me._PhoneType = ""
        End Sub

        Public Sub Delete()
            Dim cnn As New SqlConnection(Me._ConnectionString)
            Dim cmd As New SqlCommand
            If (Me._PhoneTypeID > -1) Then
                cnn.Open
                cmd.Connection = cnn
                cmd.CommandText = "spRemovePhoneType"
                cmd.Parameters.Add("@PhoneTypeID", SqlDbType.Int).Value = Me._PhoneTypeID
                cmd.CommandType = CommandType.StoredProcedure
                cmd.ExecuteNonQuery
                Me._PhoneTypeID = -1
                Me._PhoneType = ""
                cnn.Close
            End If
        End Sub

        Public Sub Load(ByVal PhoneTypeID As Long)
            Dim cnn As New SqlConnection(Me._ConnectionString)
            Dim cmd As New SqlCommand
            cmd.CommandText = "spGetPhoneType"
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PhoneTypeID", SqlDbType.Int).Value = PhoneTypeID
            cnn.Open
            cmd.Connection = cnn
            Dim dtr As SqlDataReader = cmd.ExecuteReader
            If dtr.Read Then
                Me._PhoneTypeID = Convert.ToInt32(RuntimeHelpers.GetObjectValue(dtr.Item("PhoneTypeID")))
                Me._PhoneType = dtr.Item("PhoneType").ToString
            Else
                Me._PhoneTypeID = -1
                Me._PhoneType = ""
            End If
            cnn.Close
        End Sub
        

        Public Function Save() As Long
            If (Me._PhoneTypeID > -1) Then
                Return Me.SavePhoneType
            End If
            Return Me.Add(Me._PhoneType)
        End Function

        Private Function SavePhoneType() As Long
            Dim cnn As New SqlConnection(Me.ConnectionString)
            Dim cmd As New SqlCommand("spUpdatePhoneType")
            cmd.CommandType = CommandType.StoredProcedure
            If (Me._PhoneTypeID <= -1) Then
                Return Me._PhoneTypeID
                Exit Function
            End If
            If (Me._PhoneType.Length > 0) Then
                cnn.Open
                cmd.Connection = cnn
                cmd.Parameters.Add("@PhoneTypeID", SqlDbType.Int).Value = Me._PhoneTypeID
                cmd.Parameters.Add("@PhoneType", SqlDbType.VarChar, Me._PhoneType.Length).Value = Me._PhoneType
                cmd.ExecuteNonQuery
                cnn.Close
                Return Me._PhoneTypeID
            End If
            Me.Delete
            Return -1
        End Function


        ' Properties
        Public Property ConnectionString As String
            Get
                Return Me._ConnectionString
            End Get
            Set(ByVal value As String)
                Me._ConnectionString = value
            End Set
        End Property

        Public Property PhoneType As String
            Get
                Return Me._PhoneType
            End Get
            Set(ByVal value As String)
                If (value.Length <= &H20) Then
                    Me._PhoneType = value
                Else
                    Me._PhoneType = value.Substring(0, &H20)
                End If
            End Set
        End Property

        Public ReadOnly Property PhoneTypeID As Long
            Get
                Return Me._PhoneTypeID
            End Get
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _PhoneType As String
        Private _PhoneTypeID As Long
        Private Const PhoneTypeMaxLength As Integer = &H20
    End Class
End Namespace

