Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class RecruitmentCampaignRecord
        ' Methods
        Public Sub New()
            Me._RecruitmentCampaignID = 0
            Me._CreatedBy = 0
            Me._Description = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._RecruitmentCampaignID = 0
            Me._CreatedBy = 0
            Me._Description = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngRecruitmentCampaignID As Long, ByVal strConnectionString As String)
            Me._RecruitmentCampaignID = 0
            Me._CreatedBy = 0
            Me._Description = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._RecruitmentCampaignID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal strDescription As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddRecruitmentCampaign")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngRecruitmentCampaignID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@Description", SqlDbType.VarChar, Me.TrimTrunc(strDescription, &H40).Length).Value = Me.TrimTrunc(strDescription, &H40)
                cnn.Open
                cmd.Connection = cnn
                lngRecruitmentCampaignID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngRecruitmentCampaignID > 0) Then
                    Me.Load(lngRecruitmentCampaignID)
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
            Me._RecruitmentCampaignID = 0
            Me._CreatedBy = 0
            Me._Description = ""
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveRecruitmentCampaign")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@RecruitmentCampaignID", SqlDbType.Int).Value = Me._RecruitmentCampaignID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._RecruitmentCampaignID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New RecruitmentCampaignRecord(Me._RecruitmentCampaignID, Me._ConnectionString)
            obj.Load(Me._RecruitmentCampaignID)
            If (obj.Description <> Me._Description) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngRecruitmentCampaignID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetRecruitmentCampaign")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@RecruitmentCampaignID", SqlDbType.Int).Value = lngRecruitmentCampaignID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._RecruitmentCampaignID = Conversions.ToLong(dtr.Item("RecruitmentCampaignID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
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
                Dim obj As New RecruitmentCampaignRecord(Me._RecruitmentCampaignID, Me._ConnectionString)
                obj.Load(Me._RecruitmentCampaignID)
                If (obj.Description <> Me._Description) Then
                    Me.UpdateDescription(Me._Description, (cnn))
                    strTemp = String.Concat(New String() { "Description Changed to '", Me._Description, "' from '", obj.Description, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._RecruitmentCampaignID)
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
            Dim cmd As New SqlCommand("spUpdateRecruitmentCampaignDescription")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@RecruitmentCampaignID", SqlDbType.Int).Value = Me._RecruitmentCampaignID
            cmd.Parameters.Add("@Description", SqlDbType.VarChar, Me.TrimTrunc(NewDescription, &H40).Length).Value = Me.TrimTrunc(NewDescription, &H40)
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
                Me._Description = Me.TrimTrunc(value, &H40)
            End Set
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public ReadOnly Property RecruitmentCampaignID As Long
            Get
                Return Me._RecruitmentCampaignID
            End Get
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _Description As String
        Private _RecruitmentCampaignID As Long
        Private Const DescriptionMaxLength As Integer = &H40
    End Class
End Namespace

