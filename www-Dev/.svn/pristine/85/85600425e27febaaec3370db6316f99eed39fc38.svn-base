Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class CourierMethodRecord
        ' Methods
        Public Sub New()
            Me._CourierMethodID = 0
            Me._CreatedBy = 0
            Me._CourierID = 0
            Me._Method = ""
            Me._OverRideWebsite = ""
            Me._OverRideTrackingScript = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._CourierMethodID = 0
            Me._CreatedBy = 0
            Me._CourierID = 0
            Me._Method = ""
            Me._OverRideWebsite = ""
            Me._OverRideTrackingScript = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngCourierMethodID As Long, ByVal strConnectionString As String)
            Me._CourierMethodID = 0
            Me._CreatedBy = 0
            Me._CourierID = 0
            Me._Method = ""
            Me._OverRideWebsite = ""
            Me._OverRideTrackingScript = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._CourierMethodID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal lngCourierID As Long, ByVal strMethod As String, ByVal datDateCreated As DateTime)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddCourierMethod")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngCourierMethodID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@CourierID", SqlDbType.Int).Value = lngCourierID
                cmd.Parameters.Add("@Method", SqlDbType.VarChar, Me.TrimTrunc(strMethod, &H80).Length).Value = Me.TrimTrunc(strMethod, &H80)
                cmd.Parameters.Add("@DateCreated", SqlDbType.DateTime).Value = datDateCreated
                cnn.Open
                cmd.Connection = cnn
                lngCourierMethodID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngCourierMethodID > 0) Then
                    Me.Load(lngCourierMethodID)
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
            Me._CourierMethodID = 0
            Me._CreatedBy = 0
            Me._CourierID = 0
            Me._Method = ""
            Me._OverRideWebsite = ""
            Me._OverRideTrackingScript = ""
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveCourierMethod")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CourierMethodID", SqlDbType.Int).Value = Me._CourierMethodID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._CourierMethodID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New CourierMethodRecord(Me._CourierMethodID, Me._ConnectionString)
            obj.Load(Me._CourierMethodID)
            If (obj.Method <> Me._Method) Then
                blnReturn = True
            End If
            If (obj.OverRideWebsite <> Me._OverRideWebsite) Then
                blnReturn = True
            End If
            If (obj.OverRideTrackingScript <> Me._OverRideTrackingScript) Then
                blnReturn = True
            End If
            If (DateTime.Compare(obj.DateCreated, Me._DateCreated) <> 0) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngCourierMethodID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetCourierMethod")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CourierMethodID", SqlDbType.Int).Value = lngCourierMethodID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._CourierMethodID = Conversions.ToLong(dtr.Item("CourierMethodID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._CourierID = Conversions.ToLong(dtr.Item("CourierID"))
                    Me._Method = dtr.Item("Method").ToString
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("OverRideWebsite"))) Then
                        Me._OverRideWebsite = dtr.Item("OverRideWebsite").ToString
                    Else
                        Me._OverRideWebsite = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("OverRideTrackingScript"))) Then
                        Me._OverRideTrackingScript = dtr.Item("OverRideTrackingScript").ToString
                    Else
                        Me._OverRideTrackingScript = ""
                    End If
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
                Dim obj As New CourierMethodRecord(Me._CourierMethodID, Me._ConnectionString)
                obj.Load(Me._CourierMethodID)
                If (obj.Method <> Me._Method) Then
                    Me.UpdateMethod(Me._Method, (cnn))
                    strTemp = String.Concat(New String() { "Method Changed to '", Me._Method, "' from '", obj.Method, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.OverRideWebsite <> Me._OverRideWebsite) Then
                    Me.UpdateOverRideWebsite(Me._OverRideWebsite, (cnn))
                    strTemp = String.Concat(New String() { "OverRideWebsite Changed to '", Me._OverRideWebsite, "' from '", obj.OverRideWebsite, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.OverRideTrackingScript <> Me._OverRideTrackingScript) Then
                    Me.UpdateOverRideTrackingScript(Me._OverRideTrackingScript, (cnn))
                    strTemp = String.Concat(New String() { "OverRideTrackingScript Changed to '", Me._OverRideTrackingScript, "' from '", obj.OverRideTrackingScript, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (DateTime.Compare(obj.DateCreated, Me._DateCreated) <> 0) Then
                    Me.UpdateDateCreated(Me._DateCreated, (cnn))
                    strTemp = String.Concat(New String() { "DateCreated Changed to '", Conversions.ToString(Me._DateCreated), "' from '", Conversions.ToString(obj.DateCreated), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._CourierMethodID)
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

        Private Sub UpdateDateCreated(ByVal NewDateCreated As DateTime, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCourierMethodDateCreated")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CourierMethodID", SqlDbType.Int).Value = Me._CourierMethodID
            cmd.Parameters.Add("@DateCreated", SqlDbType.DateTime).Value = NewDateCreated
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateMethod(ByVal NewMethod As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCourierMethodMethod")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CourierMethodID", SqlDbType.Int).Value = Me._CourierMethodID
            cmd.Parameters.Add("@Method", SqlDbType.VarChar, Me.TrimTrunc(NewMethod, &H80).Length).Value = Me.TrimTrunc(NewMethod, &H80)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateOverRideTrackingScript(ByVal NewOverRideTrackingScript As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCourierMethodOverRideTrackingScript")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CourierMethodID", SqlDbType.Int).Value = Me._CourierMethodID
            If (NewOverRideTrackingScript.Trim.Length > 0) Then
                cmd.Parameters.Add("@OverRideTrackingScript", SqlDbType.VarChar, Me.TrimTrunc(NewOverRideTrackingScript, &HFF).Length).Value = Me.TrimTrunc(NewOverRideTrackingScript, &HFF)
            Else
                cmd.Parameters.Add("@OverRideTrackingScript", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateOverRideWebsite(ByVal NewOverRideWebsite As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCourierMethodOverRideWebsite")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CourierMethodID", SqlDbType.Int).Value = Me._CourierMethodID
            If (NewOverRideWebsite.Trim.Length > 0) Then
                cmd.Parameters.Add("@OverRideWebsite", SqlDbType.VarChar, Me.TrimTrunc(NewOverRideWebsite, &HFF).Length).Value = Me.TrimTrunc(NewOverRideWebsite, &HFF)
            Else
                cmd.Parameters.Add("@OverRideWebsite", SqlDbType.VarChar).Value = DBNull.Value
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

        Public ReadOnly Property CourierID As Long
            Get
                Return Me._CourierID
            End Get
        End Property

        Public ReadOnly Property CourierMethodID As Long
            Get
                Return Me._CourierMethodID
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

        Public Property Method As String
            Get
                Return Me._Method
            End Get
            Set(ByVal value As String)
                Me._Method = Me.TrimTrunc(value, &H80)
            End Set
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public Property OverRideTrackingScript As String
            Get
                Return Me._OverRideTrackingScript
            End Get
            Set(ByVal value As String)
                Me._OverRideTrackingScript = Me.TrimTrunc(value, &HFF)
            End Set
        End Property

        Public Property OverRideWebsite As String
            Get
                Return Me._OverRideWebsite
            End Get
            Set(ByVal value As String)
                Me._OverRideWebsite = Me.TrimTrunc(value, &HFF)
            End Set
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _CourierID As Long
        Private _CourierMethodID As Long
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _Method As String
        Private _OverRideTrackingScript As String
        Private _OverRideWebsite As String
        Private Const MethodMaxLength As Integer = &H80
        Private Const OverRideTrackingScriptMaxLength As Integer = &HFF
        Private Const OverRideWebsiteMaxLength As Integer = &HFF
    End Class
End Namespace

