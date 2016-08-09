Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class ManufacturerRecord
        ' Methods
        Public Sub New()
            Me._ManufacturerID = 0
            Me._CreatedBy = 0
            Me._Manufacturer = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._ManufacturerID = 0
            Me._CreatedBy = 0
            Me._Manufacturer = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngManufacturerID As Long, ByVal strConnectionString As String)
            Me._ManufacturerID = 0
            Me._CreatedBy = 0
            Me._Manufacturer = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._ManufacturerID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal strManufacturer As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddManufacturer")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngManufacturerID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@Manufacturer", SqlDbType.VarChar, Me.TrimTrunc(strManufacturer, &H80).Length).Value = Me.TrimTrunc(strManufacturer, &H80)
                cnn.Open
                cmd.Connection = cnn
                lngManufacturerID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngManufacturerID > 0) Then
                    Me.Load(lngManufacturerID)
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
            Me._ManufacturerID = 0
            Me._CreatedBy = 0
            Me._Manufacturer = ""
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveManufacturer")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ManufacturerID", SqlDbType.Int).Value = Me._ManufacturerID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._ManufacturerID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New ManufacturerRecord(Me._ManufacturerID, Me._ConnectionString)
            obj.Load(Me._ManufacturerID)
            If (obj.Manufacturer <> Me._Manufacturer) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngManufacturerID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetManufacturer")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ManufacturerID", SqlDbType.Int).Value = lngManufacturerID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._ManufacturerID = Conversions.ToLong(dtr.Item("ManufacturerID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._Manufacturer = dtr.Item("Manufacturer").ToString
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
                Dim obj As New ManufacturerRecord(Me._ManufacturerID, Me._ConnectionString)
                obj.Load(Me._ManufacturerID)
                If (obj.Manufacturer <> Me._Manufacturer) Then
                    Me.UpdateManufacturer(Me._Manufacturer, (cnn))
                    strTemp = String.Concat(New String() { "Manufacturer Changed to '", Me._Manufacturer, "' from '", obj.Manufacturer, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._ManufacturerID)
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

        Private Sub UpdateManufacturer(ByVal NewManufacturer As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateManufacturerManufacturer")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ManufacturerID", SqlDbType.Int).Value = Me._ManufacturerID
            cmd.Parameters.Add("@Manufacturer", SqlDbType.VarChar, Me.TrimTrunc(NewManufacturer, &H80).Length).Value = Me.TrimTrunc(NewManufacturer, &H80)
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

        Public Property Manufacturer As String
            Get
                Return Me._Manufacturer
            End Get
            Set(ByVal value As String)
                Me._Manufacturer = Me.TrimTrunc(value, &H80)
            End Set
        End Property

        Public ReadOnly Property ManufacturerID As Long
            Get
                Return Me._ManufacturerID
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
        Private _Manufacturer As String
        Private _ManufacturerID As Long
        Private Const ManufacturerMaxLength As Integer = &H80
    End Class
End Namespace

