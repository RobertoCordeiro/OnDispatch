Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class SkillSetQuestionAssignmentRecord
        ' Methods
        Public Sub New()
            Me._SkillSetQuestionAssignmentID = 0
            Me._CreatedBy = 0
            Me._SkillSetQuestionID = 0
            Me._PartnerAgentID = 0
            Me._SkillLevel = 0
            Me._YearsExperience = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._SkillSetQuestionAssignmentID = 0
            Me._CreatedBy = 0
            Me._SkillSetQuestionID = 0
            Me._PartnerAgentID = 0
            Me._SkillLevel = 0
            Me._YearsExperience = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngSkillSetQuestionAssignmentID As Long, ByVal strConnectionString As String)
            Me._SkillSetQuestionAssignmentID = 0
            Me._CreatedBy = 0
            Me._SkillSetQuestionID = 0
            Me._PartnerAgentID = 0
            Me._SkillLevel = 0
            Me._YearsExperience = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._SkillSetQuestionAssignmentID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal lngSkillSetQuestionID As Long, ByVal lngPartnerAgentID As Long, ByVal intSkillLevel As Integer, ByVal intYearsExperience As Integer)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddSkillSetQuestionAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngSkillSetQuestionAssignmentID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@SkillSetQuestionID", SqlDbType.Int).Value = lngSkillSetQuestionID
                cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = lngPartnerAgentID
                cmd.Parameters.Add("@SkillLevel", SqlDbType.TinyInt).Value = intSkillLevel
                cmd.Parameters.Add("@YearsExperience", SqlDbType.TinyInt).Value = intYearsExperience
                cnn.Open
                cmd.Connection = cnn
                lngSkillSetQuestionAssignmentID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngSkillSetQuestionAssignmentID > 0) Then
                    Me.Load(lngSkillSetQuestionAssignmentID)
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
            Me._SkillSetQuestionAssignmentID = 0
            Me._CreatedBy = 0
            Me._SkillSetQuestionID = 0
            Me._PartnerAgentID = 0
            Me._SkillLevel = 0
            Me._YearsExperience = 0
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveSkillSetQuestionAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@SkillSetQuestionAssignmentID", SqlDbType.Int).Value = Me._SkillSetQuestionAssignmentID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._SkillSetQuestionAssignmentID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New SkillSetQuestionAssignmentRecord(Me._SkillSetQuestionAssignmentID, Me._ConnectionString)
            obj.Load(Me._SkillSetQuestionAssignmentID)
            If (obj.SkillSetQuestionID <> Me._SkillSetQuestionID) Then
                blnReturn = True
            End If
            If (obj.PartnerAgentID <> Me._PartnerAgentID) Then
                blnReturn = True
            End If
            If (obj.SkillLevel <> Me._SkillLevel) Then
                blnReturn = True
            End If
            If (obj.YearsExperience <> Me._YearsExperience) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngSkillSetQuestionAssignmentID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetSkillSetQuestionAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@SkillSetQuestionAssignmentID", SqlDbType.Int).Value = lngSkillSetQuestionAssignmentID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._SkillSetQuestionAssignmentID = Conversions.ToLong(dtr.Item("SkillSetQuestionAssignmentID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._SkillSetQuestionID = Conversions.ToLong(dtr.Item("SkillSetQuestionID"))
                    Me._PartnerAgentID = Conversions.ToLong(dtr.Item("PartnerAgentID"))
                    Me._SkillLevel = Conversions.ToInteger(dtr.Item("SkillLevel"))
                    Me._YearsExperience = Conversions.ToInteger(dtr.Item("YearsExperience"))
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
                Dim obj As New SkillSetQuestionAssignmentRecord(Me._SkillSetQuestionAssignmentID, Me._ConnectionString)
                obj.Load(Me._SkillSetQuestionAssignmentID)
                If (obj.SkillSetQuestionID <> Me._SkillSetQuestionID) Then
                    Me.UpdateSkillSetQuestionID(Me._SkillSetQuestionID, (cnn))
                    strTemp = String.Concat(New String() { "SkillSetQuestionID Changed to '", Conversions.ToString(Me._SkillSetQuestionID), "' from '", Conversions.ToString(obj.SkillSetQuestionID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.PartnerAgentID <> Me._PartnerAgentID) Then
                    Me.UpdatePartnerAgentID(Me._PartnerAgentID, (cnn))
                    strTemp = String.Concat(New String() { "PartnerAgentID Changed to '", Conversions.ToString(Me._PartnerAgentID), "' from '", Conversions.ToString(obj.PartnerAgentID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.SkillLevel <> Me._SkillLevel) Then
                    Me.UpdateSkillLevel(Me._SkillLevel, (cnn))
                    strTemp = String.Concat(New String() { "SkillLevel Changed to '", Conversions.ToString(Me._SkillLevel), "' from '", Conversions.ToString(obj.SkillLevel), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.YearsExperience <> Me._YearsExperience) Then
                    Me.UpdateYearsExperience(Me._YearsExperience, (cnn))
                    strTemp = String.Concat(New String() { "YearsExperience Changed to '", Conversions.ToString(Me._YearsExperience), "' from '", Conversions.ToString(obj.YearsExperience), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._SkillSetQuestionAssignmentID)
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

        Private Sub UpdatePartnerAgentID(ByVal NewPartnerAgentID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateSkillSetQuestionAssignmentPartnerAgentID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@SkillSetQuestionAssignmentID", SqlDbType.Int).Value = Me._SkillSetQuestionAssignmentID
            cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = NewPartnerAgentID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateSkillLevel(ByVal NewSkillLevel As Integer, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateSkillSetQuestionAssignmentSkillLevel")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@SkillSetQuestionAssignmentID", SqlDbType.Int).Value = Me._SkillSetQuestionAssignmentID
            cmd.Parameters.Add("@SkillLevel", SqlDbType.TinyInt).Value = NewSkillLevel
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateSkillSetQuestionID(ByVal NewSkillSetQuestionID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateSkillSetQuestionAssignmentSkillSetQuestionID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@SkillSetQuestionAssignmentID", SqlDbType.Int).Value = Me._SkillSetQuestionAssignmentID
            cmd.Parameters.Add("@SkillSetQuestionID", SqlDbType.Int).Value = NewSkillSetQuestionID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateYearsExperience(ByVal NewYearsExperience As Integer, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateSkillSetQuestionAssignmentYearsExperience")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@SkillSetQuestionAssignmentID", SqlDbType.Int).Value = Me._SkillSetQuestionAssignmentID
            cmd.Parameters.Add("@YearsExperience", SqlDbType.TinyInt).Value = NewYearsExperience
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

        Public Property PartnerAgentID As Long
            Get
                Return Me._PartnerAgentID
            End Get
            Set(ByVal value As Long)
                Me._PartnerAgentID = value
            End Set
        End Property

        Public Property SkillLevel As Integer
            Get
                Return Me._SkillLevel
            End Get
            Set(ByVal value As Integer)
                Me._SkillLevel = value
            End Set
        End Property

        Public ReadOnly Property SkillSetQuestionAssignmentID As Long
            Get
                Return Me._SkillSetQuestionAssignmentID
            End Get
        End Property

        Public Property SkillSetQuestionID As Long
            Get
                Return Me._SkillSetQuestionID
            End Get
            Set(ByVal value As Long)
                Me._SkillSetQuestionID = value
            End Set
        End Property

        Public Property YearsExperience As Integer
            Get
                Return Me._YearsExperience
            End Get
            Set(ByVal value As Integer)
                Me._YearsExperience = value
            End Set
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _PartnerAgentID As Long
        Private _SkillLevel As Integer
        Private _SkillSetQuestionAssignmentID As Long
        Private _SkillSetQuestionID As Long
        Private _YearsExperience As Integer
    End Class
End Namespace

