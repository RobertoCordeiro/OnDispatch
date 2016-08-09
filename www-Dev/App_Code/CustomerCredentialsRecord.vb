Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class CustomerCredentialsRecord
        ' Methods
        Public Sub New()
            Me._CustomerID = 0
            Me._InfoID = 0
            Me._UserID = ""
            Me._Password = ""
            Me._Misc1 = ""
            Me._Misc2 = ""
            Me._Misc3 = ""
            Me._ConnectionString = ""
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._CustomerID = 0
            Me._InfoID = 0
            Me._UserID = ""
            Me._Password = ""
            Me._Misc1 = ""
            Me._Misc2 = ""
            Me._Misc3 = ""
            Me._ConnectionString = strConnectionString
        End Sub

    
        'Public Sub Add(ByVal lngCreatedBy As Long, ByVal lngInfoID As Long)
        '    If (Me._ConnectionString.Trim.Length > 0) Then
        '        Dim cnn As New SqlConnection(Me._ConnectionString)
        '        Dim cmd As New SqlCommand("spAddCustomer")
        '        cmd.CommandType = CommandType.StoredProcedure
        '        Dim lngCustomerID As Long = 0
        '        cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
        '        cmd.Parameters.Add("@InfoID", SqlDbType.Int).Value = lngInfoID
        '        cnn.Open()
        '        cmd.Connection = cnn
        '        lngCustomerID = Conversions.ToLong(cmd.ExecuteScalar)
        '        cnn.Close()
        '        If (lngCustomerID > 0) Then
        '            Me.Load(lngCustomerID)
        '        End If
        '    End If
        'End Sub

     

        Public Sub Load(ByVal lngCustomerID As Long, lngInfoID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetCustomerCredentials")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = lngCustomerID
                cmd.Parameters.Add("@InfoID", SqlDbType.Int).Value = lngInfoID
                cnn.Open()
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._CustomerID = Conversions.ToLong(dtr.Item("CustomerID"))
                    Me._InfoID = Conversions.ToInteger(dtr.Item("InfoID"))
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("UserID"))) Then
                        Me._UserID = dtr.Item("UserID").ToString
                    Else
                        Me._UserID = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Password"))) Then
                        Me._Password = dtr.Item("Password").ToString
                    Else
                        Me._Password = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Misc1"))) Then
                        Me._Misc1 = dtr.Item("Misc1").ToString
                    Else
                        Me._Misc1 = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Misc2"))) Then
                        Me._Misc2 = dtr.Item("Misc2").ToString
                    Else
                        Me._Misc2 = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Misc3"))) Then
                        Me._Misc3 = dtr.Item("Misc3").ToString
                    Else
                        Me._Misc3 = ""
                    End If
                End If
                cnn.Close()
            End If
        End Sub

        Private Function TrimTrunc(ByVal strInput As String, ByVal intMaxLength As Integer) As String
            Dim strReturn As String = strInput
            If (strReturn.Trim.Length <= intMaxLength) Then
                Return strReturn.Trim
            End If
            Return strReturn.Substring(0, intMaxLength).Trim
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

        Public Property Password As String
            Get
                Return Me._Password
            End Get
            Set(ByVal value As String)
                Me._Password = Me.TrimTrunc(value, &H10)
            End Set
        End Property

        Public Property Misc1 As String
            Get
                Return Me._Misc1
            End Get
            Set(ByVal value As String)
                Me._Misc1 = Me.TrimTrunc(value, &H10)
            End Set
        End Property
        Public Property Misc2 As String
            Get
                Return Me._Misc2
            End Get
            Set(ByVal value As String)
                Me._Misc2 = Me.TrimTrunc(value, &H10)
            End Set
        End Property
        Public Property Misc3 As String
            Get
                Return Me._Misc3
            End Get
            Set(ByVal value As String)
                Me._Misc3 = Me.TrimTrunc(value, &H10)
            End Set
        End Property
        Public Property UserID As String
            Get
                Return Me._UserID
            End Get
            Set(ByVal value As String)
                Me._UserID = Me.TrimTrunc(value, &HFF)
            End Set
        End Property

        Public Property InfoID() As Long
            Get
                Return _InfoID
            End Get
            Set(ByVal value As Long)
                Me._InfoID = value
            End Set
        End Property

        Public Property CustomerID() As Long
            Get
                Return _CustomerID
            End Get
            Set(ByVal value As Long)
                Me._CustomerID = value
            End Set
        End Property

        ' Fields
        Private _CustomerID As Long
        Private _InfoID As Long
        Private _UserID As String
        Private _Password As String
        Private _Misc1 As String
        Private _Misc2 As String
        Private _Misc3 As String
        Private _ConnectionString As String
    End Class
End Namespace

