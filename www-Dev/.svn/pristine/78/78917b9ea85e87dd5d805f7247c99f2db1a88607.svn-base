Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class ResumeFolderRecord
        ' Methods
        Public Sub New()
            Me._FolderID = 0
            Me._CreatedBy = 0
            Me._FolderName = ""
            Me._Personal = False
            Me._Shared = False
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._FolderID = 0
            Me._CreatedBy = 0
            Me._FolderName = ""
            Me._Personal = False
            Me._Shared = False
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngFolderID As Long, ByVal strConnectionString As String)
            Me._FolderID = 0
            Me._CreatedBy = 0
            Me._FolderName = ""
            Me._Personal = False
            Me._Shared = False
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._FolderID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal strFolderName As String, ByVal blnPersonal As Boolean, ByVal blnShared As Boolean)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddResumeFolder")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngFolderID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@FolderName", SqlDbType.VarChar, Me.TrimTrunc(strFolderName, &H20).Length).Value = Me.TrimTrunc(strFolderName, &H20)
                cmd.Parameters.Add("@Personal", SqlDbType.Bit).Value = blnPersonal
                cmd.Parameters.Add("@Shared", SqlDbType.Bit).Value = blnShared
                cnn.Open
                cmd.Connection = cnn
                lngFolderID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngFolderID > 0) Then
                    Me.Load(lngFolderID)
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
            Me._FolderID = 0
            Me._CreatedBy = 0
            Me._FolderName = ""
            Me._Personal = False
            Me._Shared = False
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveResumeFolder")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@FolderID", SqlDbType.Int).Value = Me._FolderID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._FolderID)
            End If
        End Sub

        Private Function GetItemCount() As Long
            Dim lngReturn As Long = 0
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetResumeFolderItemCount")
                If (Me._FolderID > 0) Then
                    cmd.Parameters.Add("@FolderID", SqlDbType.Int).Value = Me._FolderID
                Else
                    cmd.CommandText = "spGetUnassignedResumeCount"
                End If
                cmd.CommandType = CommandType.StoredProcedure
                cnn.Open
                cmd.Connection = cnn
                lngReturn = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
            End If
            Return lngReturn
        End Function

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New ResumeFolderRecord(Me._FolderID, Me._ConnectionString)
            If (obj.FolderName <> Me._FolderName) Then
                blnReturn = True
            End If
            If (obj.Personal <> Me._Personal) Then
                blnReturn = True
            End If
            If (obj.SharedFolder <> Me._Shared) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngFolderID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetResumeFolder")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@FolderID", SqlDbType.Int).Value = lngFolderID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._FolderID = Conversions.ToLong(dtr.Item("FolderID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._FolderName = dtr.Item("FolderName").ToString
                    Me._Personal = Conversions.ToBoolean(dtr.Item("Personal"))
                    Me._Shared = Conversions.ToBoolean(dtr.Item("Shared"))
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                Else
                    Me.ClearValues
                End If
                cnn.Close
            End If
        End Sub

        Public Sub Load(ByVal strFolderName As String, ByVal blnPersonal As Boolean)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetResumeFolderByFolderNameAndPersonal")
                Dim lngID As Long = 0
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@FolderName", SqlDbType.VarChar, strFolderName.Trim.Length).Value = strFolderName.Trim
                cmd.Parameters.Add("@Personal", SqlDbType.Bit).Value = blnPersonal
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    lngID = Conversions.ToLong(dtr.Item("FolderID"))
                End If
                cnn.Close
                Me.Load(lngID)
            End If
        End Sub

        Public Sub Load(ByVal strFolderName As String, ByVal blnPersonal As Boolean, ByVal lngCreatedBy As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetResumeFolderByFolderNameAndPersonalAndCreatedBy")
                Dim lngID As Long = 0
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@FolderName", SqlDbType.VarChar, strFolderName.Trim.Length).Value = strFolderName.Trim
                cmd.Parameters.Add("@Personal", SqlDbType.Bit).Value = blnPersonal
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    lngID = Conversions.ToLong(dtr.Item("FolderID"))
                End If
                cnn.Close
                Me.Load(lngID)
            End If
        End Sub

        Public Sub Save(ByRef strChangeLog As String)
            strChangeLog = ""
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim strTemp As String = ""
                Dim cnn As New SqlConnection(Me._ConnectionString)
                cnn.Open
                Dim obj As New ResumeFolderRecord(Me._FolderID, Me._ConnectionString)
                If (obj.FolderName <> Me._FolderName) Then
                    Me.UpdateFolderName(Me._FolderName, (cnn))
                    strTemp = String.Concat(New String() { "FolderName Changed to '", Me._FolderName, "' from '", obj.FolderName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Personal <> Me._Personal) Then
                    Me.UpdatePersonal(Me._Personal, (cnn))
                    strTemp = String.Concat(New String() { "Personal Changed to '", Conversions.ToString(Me._Personal), "' from '", Conversions.ToString(obj.Personal), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.SharedFolder <> Me._Shared) Then
                    Me.UpdateShared(Me._Shared, (cnn))
                    strTemp = String.Concat(New String() { "Shared Changed to '", Conversions.ToString(Me._Shared), "' from '", Conversions.ToString(obj.SharedFolder), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._FolderID)
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

        Private Sub UpdateFolderName(ByVal NewFolderName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeFolderFolderName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@FolderID", SqlDbType.Int).Value = Me._FolderID
            cmd.Parameters.Add("@FolderName", SqlDbType.VarChar, Me.TrimTrunc(NewFolderName, &H20).Length).Value = Me.TrimTrunc(NewFolderName, &H20)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdatePersonal(ByVal NewPersonal As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeFolderPersonal")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@FolderID", SqlDbType.Int).Value = Me._FolderID
            cmd.Parameters.Add("@Personal", SqlDbType.Bit).Value = NewPersonal
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateShared(ByVal NewShared As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeFolderShared")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@FolderID", SqlDbType.Int).Value = Me._FolderID
            cmd.Parameters.Add("@Shared", SqlDbType.Bit).Value = NewShared
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

        Public ReadOnly Property FolderID As Long
            Get
                Return Me._FolderID
            End Get
        End Property

        Public Property FolderName As String
            Get
                Return Me._FolderName
            End Get
            Set(ByVal value As String)
                Me._FolderName = Me.TrimTrunc(value, &H20)
            End Set
        End Property

        Public ReadOnly Property ItemCount As Long
            Get
                Return Me.GetItemCount
            End Get
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public Property Personal As Boolean
            Get
                Return Me._Personal
            End Get
            Set(ByVal value As Boolean)
                Me._Personal = value
            End Set
        End Property

        Public Property SharedFolder As Boolean
            Get
                Return Me._Shared
            End Get
            Set(ByVal value As Boolean)
                Me._Shared = value
            End Set
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _FolderID As Long
        Private _FolderName As String
        Private _Personal As Boolean
        Private _Shared As Boolean
        Private Const FolderNameMaxLength As Integer = &H20
    End Class
End Namespace

