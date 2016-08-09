Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class ModelRecord
        ' Methods
        Public Sub New()
            Me._ModelID = 0
            Me._CreatedBy = 0
            Me._ManufacturerID = 0
            Me._ProductTypeID = 0
            Me._ModelName = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._ModelID = 0
            Me._CreatedBy = 0
            Me._ManufacturerID = 0
            Me._ProductTypeID = 0
            Me._ModelName = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngModelID As Long, ByVal strConnectionString As String)
            Me._ModelID = 0
            Me._CreatedBy = 0
            Me._ManufacturerID = 0
            Me._ProductTypeID = 0
            Me._ModelName = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._ModelID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal lngManufacturerID As Long, ByVal lngProductTypeID As Long, ByVal strModelName As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddModel")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngModelID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@ManufacturerID", SqlDbType.Int).Value = lngManufacturerID
                cmd.Parameters.Add("@ProductTypeID", SqlDbType.Int).Value = lngProductTypeID
                cmd.Parameters.Add("@ModelName", SqlDbType.VarChar, Me.TrimTrunc(strModelName, &H80).Length).Value = Me.TrimTrunc(strModelName, &H80)
                cnn.Open
                cmd.Connection = cnn
                lngModelID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngModelID > 0) Then
                    Me.Load(lngModelID)
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
            Me._ModelID = 0
            Me._CreatedBy = 0
            Me._ManufacturerID = 0
            Me._ProductTypeID = 0
            Me._ModelName = ""
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveModel")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ModelID", SqlDbType.Int).Value = Me._ModelID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._ModelID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New ModelRecord(Me._ModelID, Me._ConnectionString)
            obj.Load(Me._ModelID)
            If (obj.ManufacturerID <> Me._ManufacturerID) Then
                blnReturn = True
            End If
            If (obj.ProductTypeID <> Me._ProductTypeID) Then
                blnReturn = True
            End If
            If (obj.ModelName <> Me._ModelName) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngModelID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetModel")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ModelID", SqlDbType.Int).Value = lngModelID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._ModelID = Conversions.ToLong(dtr.Item("ModelID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._ManufacturerID = Conversions.ToLong(dtr.Item("ManufacturerID"))
                    Me._ProductTypeID = Conversions.ToLong(dtr.Item("ProductTypeID"))
                    Me._ModelName = dtr.Item("ModelName").ToString
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
                Dim obj As New ModelRecord(Me._ModelID, Me._ConnectionString)
                obj.Load(Me._ModelID)
                If (obj.ManufacturerID <> Me._ManufacturerID) Then
                    Me.UpdateManufacturerID(Me._ManufacturerID, (cnn))
                    strTemp = String.Concat(New String() { "ManufacturerID Changed to '", Conversions.ToString(Me._ManufacturerID), "' from '", Conversions.ToString(obj.ManufacturerID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ProductTypeID <> Me._ProductTypeID) Then
                    Me.UpdateProductTypeID(Me._ProductTypeID, (cnn))
                    strTemp = String.Concat(New String() { "ProductTypeID Changed to '", Conversions.ToString(Me._ProductTypeID), "' from '", Conversions.ToString(obj.ProductTypeID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ModelName <> Me._ModelName) Then
                    Me.UpdateModelName(Me._ModelName, (cnn))
                    strTemp = String.Concat(New String() { "ModelName Changed to '", Me._ModelName, "' from '", obj.ModelName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._ModelID)
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
            Dim cmd As New SqlCommand("spUpdateModelManufacturerID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ModelID", SqlDbType.Int).Value = Me._ModelID
            cmd.Parameters.Add("@ManufacturerID", SqlDbType.Int).Value = NewManufacturerID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateModelName(ByVal NewModelName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateModelModelName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ModelID", SqlDbType.Int).Value = Me._ModelID
            cmd.Parameters.Add("@ModelName", SqlDbType.VarChar, Me.TrimTrunc(NewModelName, &H80).Length).Value = Me.TrimTrunc(NewModelName, &H80)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateProductTypeID(ByVal NewProductTypeID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateModelProductTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ModelID", SqlDbType.Int).Value = Me._ModelID
            cmd.Parameters.Add("@ProductTypeID", SqlDbType.Int).Value = NewProductTypeID
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

        Public Property ManufacturerID As Long
            Get
                Return Me._ManufacturerID
            End Get
            Set(ByVal value As Long)
                Me._ManufacturerID = value
            End Set
        End Property

        Public ReadOnly Property ModelID As Long
            Get
                Return Me._ModelID
            End Get
        End Property

        Public Property ModelName As String
            Get
                Return Me._ModelName
            End Get
            Set(ByVal value As String)
                Me._ModelName = Me.TrimTrunc(value, &H80)
            End Set
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public Property ProductTypeID As Long
            Get
                Return Me._ProductTypeID
            End Get
            Set(ByVal value As Long)
                Me._ProductTypeID = value
            End Set
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _ManufacturerID As Long
        Private _ModelID As Long
        Private _ModelName As String
        Private _ProductTypeID As Long
        Private Const ModelNameMaxLength As Integer = &H80
    End Class
End Namespace

