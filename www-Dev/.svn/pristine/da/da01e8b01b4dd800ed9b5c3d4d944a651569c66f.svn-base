Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class CountryRecord
        ' Methods
        Public Sub New()
            Me._CountryID = 0
            Me._CreatedBy = 0
            Me._CountryName = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._CountryID = 0
            Me._CreatedBy = 0
            Me._CountryName = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngCountryID As Long, ByVal strConnectionString As String)
            Me._CountryID = 0
            Me._CreatedBy = 0
            Me._CountryName = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._CountryID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal strCountryName As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddCountry")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngCountryID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@CountryName", SqlDbType.VarChar, Me.TrimTrunc(strCountryName, &H40).Length).Value = Me.TrimTrunc(strCountryName, &H40)
                cnn.Open
                cmd.Connection = cnn
                lngCountryID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngCountryID > 0) Then
                    Me.Load(lngCountryID)
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
            Me._CountryID = 0
            Me._CreatedBy = 0
            Me._CountryName = ""
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveCountry")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CountryID", SqlDbType.Int).Value = Me._CountryID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._CountryID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New CountryRecord(Me._CountryID, Me._ConnectionString)
            obj.Load(Me._CountryID)
            If (obj.CountryName <> Me._CountryName) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngCountryID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetCountry")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CountryID", SqlDbType.Int).Value = lngCountryID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._CountryID = Conversions.ToLong(dtr.Item("CountryID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._CountryName = dtr.Item("CountryName").ToString
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
                Dim obj As New CountryRecord(Me._CountryID, Me._ConnectionString)
                obj.Load(Me._CountryID)
                If (obj.CountryName <> Me._CountryName) Then
                    Me.UpdateCountryName(Me._CountryName, (cnn))
                    strTemp = String.Concat(New String() { "CountryName Changed to '", Me._CountryName, "' from '", obj.CountryName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._CountryID)
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

        Private Sub UpdateCountryName(ByVal NewCountryName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCountryCountryName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CountryID", SqlDbType.Int).Value = Me._CountryID
            cmd.Parameters.Add("@CountryName", SqlDbType.VarChar, Me.TrimTrunc(NewCountryName, &H40).Length).Value = Me.TrimTrunc(NewCountryName, &H40)
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

        Public ReadOnly Property CountryID As Long
            Get
                Return Me._CountryID
            End Get
        End Property

        Public Property CountryName As String
            Get
                Return Me._CountryName
            End Get
            Set(ByVal value As String)
                Me._CountryName = Me.TrimTrunc(value, &H40)
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


        ' Fields
        Private _ConnectionString As String
        Private _CountryID As Long
        Private _CountryName As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private Const CountryNameMaxLength As Integer = &H40
    End Class
End Namespace

