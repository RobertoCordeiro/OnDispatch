Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class CourierRecord
        ' Methods
        Public Sub New()
            Me._CourierID = 0
            Me._CreatedBy = 0
            Me._Courier = ""
            Me._WebSite = ""
            Me._TrackingScript = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._CourierID = 0
            Me._CreatedBy = 0
            Me._Courier = ""
            Me._WebSite = ""
            Me._TrackingScript = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngCourierID As Long, ByVal strConnectionString As String)
            Me._CourierID = 0
            Me._CreatedBy = 0
            Me._Courier = ""
            Me._WebSite = ""
            Me._TrackingScript = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._CourierID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal strCourier As String, ByVal datDateCreated As DateTime)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddCourier")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngCourierID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@Courier", SqlDbType.VarChar, Me.TrimTrunc(strCourier, &H40).Length).Value = Me.TrimTrunc(strCourier, &H40)
                cmd.Parameters.Add("@DateCreated", SqlDbType.DateTime).Value = datDateCreated
                cnn.Open
                cmd.Connection = cnn
                lngCourierID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngCourierID > 0) Then
                    Me.Load(lngCourierID)
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
            Me._CourierID = 0
            Me._CreatedBy = 0
            Me._Courier = ""
            Me._WebSite = ""
            Me._TrackingScript = ""
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveCourier")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CourierID", SqlDbType.Int).Value = Me._CourierID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._CourierID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New CourierRecord(Me._CourierID, Me._ConnectionString)
            obj.Load(Me._CourierID)
            If (obj.Courier <> Me._Courier) Then
                blnReturn = True
            End If
            If (obj.WebSite <> Me._WebSite) Then
                blnReturn = True
            End If
            If (obj.TrackingScript <> Me._TrackingScript) Then
                blnReturn = True
            End If
            If (DateTime.Compare(obj.DateCreated, Me._DateCreated) <> 0) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngCourierID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetCourier")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CourierID", SqlDbType.Int).Value = lngCourierID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._CourierID = Conversions.ToLong(dtr.Item("CourierID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._Courier = dtr.Item("Courier").ToString
                    Me._WebSite = dtr.Item("WebSite").ToString
                    Me._TrackingScript = dtr.Item("TrackingScript").ToString
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
                Dim obj As New CourierRecord(Me._CourierID, Me._ConnectionString)
                obj.Load(Me._CourierID)
                If (obj.Courier <> Me._Courier) Then
                    Me.UpdateCourier(Me._Courier, (cnn))
                    strTemp = String.Concat(New String() { "Courier Changed to '", Me._Courier, "' from '", obj.Courier, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.WebSite <> Me._WebSite) Then
                    Me.UpdateWebSite(Me._WebSite, (cnn))
                    strTemp = String.Concat(New String() { "WebSite Changed to '", Me._WebSite, "' from '", obj.WebSite, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.TrackingScript <> Me._TrackingScript) Then
                    Me.UpdateTrackingScript(Me._TrackingScript, (cnn))
                    strTemp = String.Concat(New String() { "TrackingScript Changed to '", Me._TrackingScript, "' from '", obj.TrackingScript, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (DateTime.Compare(obj.DateCreated, Me._DateCreated) <> 0) Then
                    Me.UpdateDateCreated(Me._DateCreated, (cnn))
                    strTemp = String.Concat(New String() { "DateCreated Changed to '", Conversions.ToString(Me._DateCreated), "' from '", Conversions.ToString(obj.DateCreated), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._CourierID)
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

        Private Sub UpdateCourier(ByVal NewCourier As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCourierCourier")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CourierID", SqlDbType.Int).Value = Me._CourierID
            cmd.Parameters.Add("@Courier", SqlDbType.VarChar, Me.TrimTrunc(NewCourier, &H40).Length).Value = Me.TrimTrunc(NewCourier, &H40)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateDateCreated(ByVal NewDateCreated As DateTime, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCourierDateCreated")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CourierID", SqlDbType.Int).Value = Me._CourierID
            cmd.Parameters.Add("@DateCreated", SqlDbType.DateTime).Value = NewDateCreated
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateTrackingScript(ByVal NewTrackingScript As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCourierTrackingScript")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CourierID", SqlDbType.Int).Value = Me._CourierID
            cmd.Parameters.Add("@TrackingScript", SqlDbType.VarChar, Me.TrimTrunc(NewTrackingScript, &HFF).Length).Value = Me.TrimTrunc(NewTrackingScript, &HFF)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateWebSite(ByVal NewWebSite As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCourierWebSite")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CourierID", SqlDbType.Int).Value = Me._CourierID
            cmd.Parameters.Add("@WebSite", SqlDbType.VarChar, Me.TrimTrunc(NewWebSite, &HFF).Length).Value = Me.TrimTrunc(NewWebSite, &HFF)
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

        Public Property Courier As String
            Get
                Return Me._Courier
            End Get
            Set(ByVal value As String)
                Me._Courier = Me.TrimTrunc(value, &H40)
            End Set
        End Property

        Public ReadOnly Property CourierID As Long
            Get
                Return Me._CourierID
            End Get
        End Property

        Public ReadOnly Property CreatedBy As Long
            Get
                Return Me._CreatedBy
            End Get
        End Property

        Public Property DateCreated As DateTime
            Get
                Return Me._DateCreated
            End Get
            Set(ByVal value As DateTime)
                Me._DateCreated = value
            End Set
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public Property TrackingScript As String
            Get
                Return Me._TrackingScript
            End Get
            Set(ByVal value As String)
                Me._TrackingScript = Me.TrimTrunc(value, &HFF)
            End Set
        End Property

        Public Property WebSite As String
            Get
                Return Me._WebSite
            End Get
            Set(ByVal value As String)
                Me._WebSite = Me.TrimTrunc(value, &HFF)
            End Set
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _Courier As String
        Private _CourierID As Long
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _TrackingScript As String
        Private _WebSite As String
        Private Const CourierMaxLength As Integer = &H40
        Private Const TrackingScriptMaxLength As Integer = &HFF
        Private Const WebSiteMaxLength As Integer = &HFF
    End Class
End Namespace

