Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class SkillSetRecord
        ' Methods
        Public Sub New()
            Me._SkillSetID = 0
            Me._CreatedBy = 0
            Me._SkillSetName = ""
            Me._Description = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._SkillSetID = 0
            Me._CreatedBy = 0
            Me._SkillSetName = ""
            Me._Description = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngSkillSetID As Long, ByVal strConnectionString As String)
            Me._SkillSetID = 0
            Me._CreatedBy = 0
            Me._SkillSetName = ""
            Me._Description = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._SkillSetID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal strSkillSetName As String, ByVal strDescription As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddSkillSet")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngSkillSetID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@SkillSetName", SqlDbType.VarChar, Me.TrimTrunc(strSkillSetName, &H80).Length).Value = Me.TrimTrunc(strSkillSetName, &H80)
                cmd.Parameters.Add("@Description", SqlDbType.Text).Value = strDescription
                cnn.Open
                cmd.Connection = cnn
                lngSkillSetID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngSkillSetID > 0) Then
                    Me.Load(lngSkillSetID)
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
            Me._SkillSetID = 0
            Me._CreatedBy = 0
            Me._SkillSetName = ""
            Me._Description = ""
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveSkillSet")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@SkillSetID", SqlDbType.Int).Value = Me._SkillSetID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._SkillSetID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New SkillSetRecord(Me._SkillSetID, Me._ConnectionString)
            obj.Load(Me._SkillSetID)
            If (obj.SkillSetName <> Me._SkillSetName) Then
                blnReturn = True
            End If
            If (obj.Description <> Me._Description) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngSkillSetID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetSkillSet")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@SkillSetID", SqlDbType.Int).Value = lngSkillSetID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._SkillSetID = Conversions.ToLong(dtr.Item("SkillSetID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._SkillSetName = dtr.Item("SkillSetName").ToString
                    Me._Description = dtr.Item("Description").ToString
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
                Dim obj As New SkillSetRecord(Me._SkillSetID, Me._ConnectionString)
                obj.Load(Me._SkillSetID)
                If (obj.SkillSetName <> Me._SkillSetName) Then
                    Me.UpdateSkillSetName(Me._SkillSetName, (cnn))
                    strTemp = String.Concat(New String() { "SkillSetName Changed to '", Me._SkillSetName, "' from '", obj.SkillSetName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Description <> Me._Description) Then
                    Me.UpdateDescription(Me._Description, (cnn))
                    strTemp = String.Concat(New String() { "Description Changed to '", Me._Description, "' from '", obj.Description, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._SkillSetID)
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

        Private Sub UpdateDescription(ByVal NewDescription As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateSkillSetDescription")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@SkillSetID", SqlDbType.Int).Value = Me._SkillSetID
            cmd.Parameters.Add("@Description", SqlDbType.Text).Value = NewDescription
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateSkillSetName(ByVal NewSkillSetName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateSkillSetSkillSetName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@SkillSetID", SqlDbType.Int).Value = Me._SkillSetID
            cmd.Parameters.Add("@SkillSetName", SqlDbType.VarChar, Me.TrimTrunc(NewSkillSetName, &H80).Length).Value = Me.TrimTrunc(NewSkillSetName, &H80)
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

        Public Property Description As String
            Get
                Return Me._Description
            End Get
            Set(ByVal value As String)
                Me._Description = value
            End Set
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public ReadOnly Property SkillSetID As Long
            Get
                Return Me._SkillSetID
            End Get
        End Property

        Public Property SkillSetName As String
            Get
                Return Me._SkillSetName
            End Get
            Set(ByVal value As String)
                Me._SkillSetName = Me.TrimTrunc(value, &H80)
            End Set
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _Description As String
        Private _SkillSetID As Long
        Private _SkillSetName As String
        Private Const SkillSetNameMaxLength As Integer = &H80
    End Class
End Namespace

