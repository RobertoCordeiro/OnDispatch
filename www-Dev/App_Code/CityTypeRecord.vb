Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class CityTypeRecord
        ' Methods
        Public Sub New()
            Me._CityTypeID = 0
            Me._CreatedBy = 0
            Me._Code = ""
            Me._CityType = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._CityTypeID = 0
            Me._CreatedBy = 0
            Me._Code = ""
            Me._CityType = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngCityTypeID As Long, ByVal strConnectionString As String)
            Me._CityTypeID = 0
            Me._CreatedBy = 0
            Me._Code = ""
            Me._CityType = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._CityTypeID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal strCode As String, ByVal strCityType As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddCityType")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngCityTypeID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@Code", SqlDbType.Char, Me.TrimTrunc(strCode, 1).Length).Value = Me.TrimTrunc(strCode, 1)
                cmd.Parameters.Add("@CityType", SqlDbType.VarChar, Me.TrimTrunc(strCityType, &H40).Length).Value = Me.TrimTrunc(strCityType, &H40)
                cnn.Open
                cmd.Connection = cnn
                lngCityTypeID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngCityTypeID > 0) Then
                    Me.Load(lngCityTypeID)
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
            Me._CityTypeID = 0
            Me._CreatedBy = 0
            Me._Code = ""
            Me._CityType = ""
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveCityType")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CityTypeID", SqlDbType.Int).Value = Me._CityTypeID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._CityTypeID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New CityTypeRecord(Me._CityTypeID, Me._ConnectionString)
            If (obj.Code <> Me._Code) Then
                blnReturn = True
            End If
            If (obj.CityType <> Me._CityType) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngCityTypeID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetCityType")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CityTypeID", SqlDbType.Int).Value = lngCityTypeID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._CityTypeID = Conversions.ToLong(dtr.Item("CityTypeID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._Code = dtr.Item("Code").ToString
                    Me._CityType = dtr.Item("CityType").ToString
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
                Dim obj As New CityTypeRecord(Me._CityTypeID, Me._ConnectionString)
                If (obj.Code <> Me._Code) Then
                    Me.UpdateCode(Me._Code, (cnn))
                    strTemp = String.Concat(New String() { "Code Changed to '", Me._Code, "' from '", obj.Code, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.CityType <> Me._CityType) Then
                    Me.UpdateCityType(Me._CityType, (cnn))
                    strTemp = String.Concat(New String() { "CityType Changed to '", Me._CityType, "' from '", obj.CityType, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._CityTypeID)
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

        Private Sub UpdateCityType(ByVal NewCityType As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCityTypeCityType")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CityTypeID", SqlDbType.Int).Value = Me._CityTypeID
            cmd.Parameters.Add("@CityType", SqlDbType.VarChar, Me.TrimTrunc(NewCityType, &H40).Length).Value = Me.TrimTrunc(NewCityType, &H40)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCode(ByVal NewCode As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCityTypeCode")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CityTypeID", SqlDbType.Int).Value = Me._CityTypeID
            cmd.Parameters.Add("@Code", SqlDbType.Char, Me.TrimTrunc(NewCode, 1).Length).Value = Me.TrimTrunc(NewCode, 1)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub


        ' Properties
        Public Property CityType As String
            Get
                Return Me._CityType
            End Get
            Set(ByVal value As String)
                Me._CityType = Me.TrimTrunc(value, &H40)
            End Set
        End Property

        Public ReadOnly Property CityTypeID As Long
            Get
                Return Me._CityTypeID
            End Get
        End Property

        Public Property Code As String
            Get
                Return Me._Code
            End Get
            Set(ByVal value As String)
                Me._Code = Me.TrimTrunc(value, 1)
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
        Private _CityType As String
        Private _CityTypeID As Long
        Private _Code As String
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private Const CityTypeMaxLength As Integer = &H40
        Private Const CodeMaxLength As Integer = 1
    End Class
End Namespace

