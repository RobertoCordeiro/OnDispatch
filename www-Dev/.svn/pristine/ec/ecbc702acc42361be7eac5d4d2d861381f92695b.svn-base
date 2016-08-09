Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class ProductTypeRecord
        ' Methods
        Public Sub New()
            Me._ProductTypeID = 0
            Me._CreatedBy = 0
            Me._ProductType = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._ProductTypeID = 0
            Me._CreatedBy = 0
            Me._ProductType = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngProductTypeID As Long, ByVal strConnectionString As String)
            Me._ProductTypeID = 0
            Me._CreatedBy = 0
            Me._ProductType = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._ProductTypeID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal strProductType As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddProductType")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngProductTypeID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@ProductType", SqlDbType.VarChar, Me.TrimTrunc(strProductType, &H80).Length).Value = Me.TrimTrunc(strProductType, &H80)
                cnn.Open
                cmd.Connection = cnn
                lngProductTypeID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngProductTypeID > 0) Then
                    Me.Load(lngProductTypeID)
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
            Me._ProductTypeID = 0
            Me._CreatedBy = 0
            Me._ProductType = ""
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveProductType")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ProductTypeID", SqlDbType.Int).Value = Me._ProductTypeID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._ProductTypeID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New ProductTypeRecord(Me._ProductTypeID, Me._ConnectionString)
            obj.Load(Me._ProductTypeID)
            If (obj.ProductType <> Me._ProductType) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngProductTypeID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetProductType")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ProductTypeID", SqlDbType.Int).Value = lngProductTypeID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._ProductTypeID = Conversions.ToLong(dtr.Item("ProductTypeID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._ProductType = dtr.Item("ProductType").ToString
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
                Dim obj As New ProductTypeRecord(Me._ProductTypeID, Me._ConnectionString)
                obj.Load(Me._ProductTypeID)
                If (obj.ProductType <> Me._ProductType) Then
                    Me.UpdateProductType(Me._ProductType, (cnn))
                    strTemp = String.Concat(New String() { "ProductType Changed to '", Me._ProductType, "' from '", obj.ProductType, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._ProductTypeID)
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

        Private Sub UpdateProductType(ByVal NewProductType As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateProductTypeProductType")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ProductTypeID", SqlDbType.Int).Value = Me._ProductTypeID
            cmd.Parameters.Add("@ProductType", SqlDbType.VarChar, Me.TrimTrunc(NewProductType, &H80).Length).Value = Me.TrimTrunc(NewProductType, &H80)
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

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public Property ProductType As String
            Get
                Return Me._ProductType
            End Get
            Set(ByVal value As String)
                Me._ProductType = Me.TrimTrunc(value, &H80)
            End Set
        End Property

        Public ReadOnly Property ProductTypeID As Long
            Get
                Return Me._ProductTypeID
            End Get
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _ProductType As String
        Private _ProductTypeID As Long
        Private Const ProductTypeMaxLength As Integer = &H80
    End Class
End Namespace

