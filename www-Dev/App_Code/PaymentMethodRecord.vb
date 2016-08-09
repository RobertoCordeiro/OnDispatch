Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class PaymentMethodRecord
        ' Methods
        Public Sub New()
            Me._MethodID = 0
            Me._CreatedBy = 0
            Me._Method = ""
            Me._DateCreated = New DateTime
            Me._ConnectionString = ""
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._MethodID = 0
            Me._CreatedBy = 0
            Me._Method = ""
            Me._DateCreated = New DateTime
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngMethodID As Long, ByVal strConnectionString As String)
            Me._MethodID = 0
            Me._CreatedBy = 0
            Me._Method = ""
            Me._DateCreated = New DateTime
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(lngMethodID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal strMethod As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddPaymentMethod")
                Dim lngMethodID As Long = 0
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                If (strMethod.Trim.Length <= &H20) Then
                    cmd.Parameters.Add("@Method", SqlDbType.VarChar, strMethod.Trim.Length).Value = strMethod.Trim
                Else
                    cmd.Parameters.Add("@Method", SqlDbType.VarChar, &H20).Value = strMethod.Trim.Substring(0, &H20)
                End If
                cnn.Open
                lngMethodID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                Me.Load(lngMethodID)
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
            Me._MethodID = 0
            Me._CreatedBy = 0
            Me._Method = ""
            Me._DateCreated = New DateTime
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemovePaymentMethod")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@MethodID", SqlDbType.Int).Value = Me._MethodID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._MethodID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim pym As New PaymentMethodRecord(Me._MethodID, Me._ConnectionString)
            Dim blnReturn As Boolean = False
            If (pym.Method <> Me._Method) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngMethodID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetPaymentMethod")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@MethodID", SqlDbType.Int).Value = lngMethodID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._MethodID = Conversions.ToLong(dtr.Item("MethodID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._Method = dtr.Item("Method").ToString
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                Else
                    Me.ClearValues
                End If
                cnn.Close
            Else
                Me.ClearValues
            End If
        End Sub

        Public Sub Save(ByRef strChangeLog As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                strChangeLog = ""
                Dim pym As New PaymentMethodRecord(Me._MethodID, Me._ConnectionString)
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim strTemp As String = ""
                cnn.Open
                If (pym.Method <> Me._Method) Then
                    Me.UpdatePaymentMethodMethod(Me._Method.Trim, (cnn))
                    strTemp = String.Concat(New String() { "Changed payment method text from '", pym.Method, "' to '", Me._Method.Trim, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._MethodID)
            End If
        End Sub

        Private Sub UpdatePaymentMethodMethod(ByVal NewMethod As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePaymentMethodMethod")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@MethodID", SqlDbType.Int).Value = Me._MethodID
            If (NewMethod.Trim.Length <= &H20) Then
                cmd.Parameters.Add("@Method", SqlDbType.VarChar, NewMethod.Trim.Length).Value = NewMethod.Trim
            Else
                cmd.Parameters.Add("@Method", SqlDbType.VarChar, &H20).Value = NewMethod.Trim.Substring(0, &H20)
            End If
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

        Public Property Method As String
            Get
                Return Me._Method
            End Get
            Set(ByVal value As String)
                If (value.Trim.Length <= &H20) Then
                    Me._Method = value.Trim
                Else
                    Me._Method = value.Trim.Substring(0, &H20).Trim
                End If
            End Set
        End Property

        Public ReadOnly Property MethodID As Long
            Get
                Return Me._MethodID
            End Get
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _Method As String
        Private _MethodID As Long
        Private Const MethodMaxLength As Integer = &H20
    End Class
End Namespace

