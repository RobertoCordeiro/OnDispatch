Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class PartnerAgentRecord
        ' Methods
        Public Sub New()
            Me._PartnerAgentID = 0
            Me._PartnerID = 0
            Me._AgentTypeID = 0
            Me._DLFileID = 0
            Me._DLStateID = 0
            Me._SignatureFileID = 0
            Me._CreatedBy = 0
            Me._WebLoginID = 0
            Me._FirstName = ""
            Me._MiddleName = ""
            Me._LastName = ""
            Me._SSN = ""
            Me._DLNumber = ""
            Me._Email = ""
            Me._AdminAgent = False
            Me._Active = True
            Me._DateCreated = DateTime.Now
            Me._PartnerAgentStatusID = 0
            Me._WorkDayMonday = False
            Me._WorkDayTuesday = False
            Me._WorkDayWednesday = False
            Me._WorkDayThursday = False
            Me._WorkDayFriday = False
            Me._WorkDaySaturday = False
            Me._WorkDaySunday = False
            Me._ScheduleZoneTypeID = 0
            Me._SpecialInstructions = ""
            Me._ScheduleHisOwnAppt = 0
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._PartnerAgentID = 0
            Me._PartnerID = 0
            Me._AgentTypeID = 0
            Me._DLFileID = 0
            Me._DLStateID = 0
            Me._SignatureFileID = 0
            Me._CreatedBy = 0
            Me._WebLoginID = 0
            Me._FirstName = ""
            Me._MiddleName = ""
            Me._LastName = ""
            Me._SSN = ""
            Me._DLNumber = ""
            Me._Email = ""
            Me._AdminAgent = False
            Me._Active = True
            Me._DateCreated = DateTime.Now
            Me._PartnerAgentStatusID = 0
            Me._WorkDayMonday = False
            Me._WorkDayTuesday = False
            Me._WorkDayWednesday = False
            Me._WorkDayThursday = False
            Me._WorkDayFriday = False
            Me._WorkDaySaturday = False
            Me._WorkDaySunday = False
            Me._SpecialInstructions = ""
            Me._ScheduleHisOwnAppt = 0
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngPartnerAgentID As Long, ByVal strConnectionString As String)
            Me._PartnerAgentID = 0
            Me._PartnerID = 0
            Me._AgentTypeID = 0
            Me._DLFileID = 0
            Me._DLStateID = 0
            Me._SignatureFileID = 0
            Me._CreatedBy = 0
            Me._WebLoginID = 0
            Me._FirstName = ""
            Me._MiddleName = ""
            Me._LastName = ""
            Me._SSN = ""
            Me._DLNumber = ""
            Me._Email = ""
            Me._AdminAgent = False
            Me._Active = True
            Me._DateCreated = DateTime.Now
            Me._PartnerAgentStatusID = 0
            Me._WorkDayMonday = False
            Me._WorkDayTuesday = False
            Me._WorkDayWednesday = False
            Me._WorkDayThursday = False
            Me._WorkDayFriday = False
            Me._WorkDaySaturday = False
            Me._WorkDaySunday = False
            Me._SpecialInstructions = ""
            Me._ScheduleHisOwnAppt = 0
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._PartnerAgentID)
        End Sub

        Public Sub Add(ByVal lngPartnerID As Long, ByVal lngAgentTypeID As Long, ByVal lngCreatedBy As Long, ByVal strFirstName As String, ByVal strLastName As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddPartnerAgent")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngPartnerAgentID As Long = 0
                cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = lngPartnerID
                cmd.Parameters.Add("@AgentTypeID", SqlDbType.Int).Value = lngAgentTypeID
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@FirstName", SqlDbType.VarChar, Me.TrimTrunc(strFirstName, &H20).Length).Value = Me.TrimTrunc(strFirstName, &H20)
                cmd.Parameters.Add("@LastName", SqlDbType.VarChar, Me.TrimTrunc(strLastName, &H20).Length).Value = Me.TrimTrunc(strLastName, &H20)
                cnn.Open
                cmd.Connection = cnn
                lngPartnerAgentID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngPartnerAgentID > 0) Then
                    Me.Load(lngPartnerAgentID)
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
            Me._SignatureFileID = 0
            Me._PartnerAgentID = 0
            Me._PartnerID = 0
            Me._AgentTypeID = 0
            Me._DLFileID = 0
            Me._DLStateID = 0
            Me._CreatedBy = 0
            Me._WebLoginID = 0
            Me._FirstName = ""
            Me._MiddleName = ""
            Me._LastName = ""
            Me._SSN = ""
            Me._DLNumber = ""
            Me._Email = ""
            Me._AdminAgent = False
            Me._PartnerAgentStatusID = 0
            Me._WorkDayMonday = False
            Me._WorkDayTuesday = False
            Me._WorkDayWednesday = False
            Me._WorkDayThursday = False
            Me._WorkDayFriday = False
            Me._WorkDaySaturday = False
            Me._WorkDaySunday = False
            Me._ScheduleZoneTypeID = 0
            Me._Active = True
            Me._SpecialInstructions = ""
            Me._ScheduleHisOwnAppt = 0
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemovePartnerAgent")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = Me._PartnerAgentID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._PartnerAgentID)
            End If
        End Sub

        Private Function GetCertificationCount() As Long
            Dim lngReturn As Long = 0
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetCertificationCountForPartnerAgent")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = Me._PartnerAgentID
                cnn.Open
                cmd.Connection = cnn
                Try 
                    lngReturn = Conversions.ToLong(cmd.ExecuteScalar)
                Catch exception1 As Exception
                    ProjectData.SetProjectError(exception1)
                    Dim ex As Exception = exception1
                    lngReturn = 0
                    ProjectData.ClearProjectError
                End Try
                cnn.Close
                cnn.Dispose
                cmd.Dispose
            End If
            Return lngReturn
        End Function

        Private Function GetUnAnsweredSkillSetQuestionCount() As Long
            Dim lngReturn As Long = 0
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetUnAnsweredSkillSetQuestionCount")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = Me._PartnerAgentID
                cnn.Open
                cmd.Connection = cnn
                Try 
                    lngReturn = Conversions.ToLong(cmd.ExecuteScalar)
                Catch exception1 As Exception
                    ProjectData.SetProjectError(exception1)
                    Dim ex As Exception = exception1
                    lngReturn = 0
                    ProjectData.ClearProjectError
                End Try
                cnn.Close
            End If
            Return lngReturn
        End Function

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New PartnerAgentRecord(Me._PartnerAgentID, Me._ConnectionString)
            obj.Load(Me._PartnerAgentID)
            If (obj.SignatureFileID <> Me._SignatureFileID) Then
                blnReturn = True
            End If
            If (obj.PartnerID <> Me._PartnerID) Then
                blnReturn = True
            End If
            If (obj.AgentTypeID <> Me._AgentTypeID) Then
                blnReturn = True
            End If
            If (obj.DLFileID <> Me._DLFileID) Then
                blnReturn = True
            End If
            If (obj.DLStateID <> Me._DLStateID) Then
                blnReturn = True
            End If
            If (obj.WebLoginID <> Me._WebLoginID) Then
                blnReturn = True
            End If
            If (obj.FirstName <> Me._FirstName) Then
                blnReturn = True
            End If
            If (obj.MiddleName <> Me._MiddleName) Then
                blnReturn = True
            End If
            If (obj.LastName <> Me._LastName) Then
                blnReturn = True
            End If
            If (obj.SSN <> Me._SSN) Then
                blnReturn = True
            End If
            If (obj.DLNumber <> Me._DLNumber) Then
                blnReturn = True
            End If
            If (obj.Email <> Me._Email) Then
                blnReturn = True
            End If
            If (obj.AdminAgent <> Me._AdminAgent) Then
                blnReturn = True
            End If
            If (obj.Active <> Me._Active) Then
                blnReturn = True
            End If
            If (obj.Active <> Me._PartnerAgentStatusID) Then
                blnReturn = True
            End If
            If obj.WorkDayMonday <> _WorkDayMonday Then
                blnReturn = True
            End If
            If obj.WorkDayTuesday <> _WorkDayTuesday Then
                blnReturn = True
            End If
            If obj.WorkDayWednesday <> _WorkDayWednesday Then
                blnReturn = True
            End If
            If obj.WorkDayThursday <> _WorkDayThursday Then
                blnReturn = True
            End If
            If obj.WorkDayFriday <> _WorkDayFriday Then
                blnReturn = True
            End If
            If obj.WorkDaySaturday <> _WorkDaySaturday Then
                blnReturn = True
            End If
            If obj.WorkDaySunday <> _WorkDaySunday Then
                blnReturn = True
            End If
            If obj.ScheduleZoneTypeID <> _ScheduleZoneTypeID Then
                blnReturn = True
            End If
            If obj.SpecialInstructions <> _SpecialInstructions Then
                blnReturn = True
            End If
            If (obj.ScheduleHisOwnAppt <> Me._ScheduleHisOwnAppt) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Private Function LabelText() As String
            Dim strReturn As String = ""
            strReturn = Me._FirstName
            If (Me._MiddleName.Trim.Length > 0) Then
                strReturn = (strReturn & " " & Me._MiddleName)
            End If
            Return (strReturn & " " & Me._LastName)
        End Function

        Public Sub Load(ByVal lngPartnerAgentID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetPartnerAgent")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = lngPartnerAgentID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._PartnerAgentID = Conversions.ToLong(dtr.Item("PartnerAgentID"))
                    Me._PartnerID = Conversions.ToLong(dtr.Item("PartnerID"))
                    Me._AgentTypeID = Conversions.ToLong(dtr.Item("AgentTypeID"))
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("DLFileID"))) Then
                        Me._DLFileID = Conversions.ToLong(dtr.Item("DLFileID"))
                    Else
                        Me._DLFileID = 0
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("SignatureFileID"))) Then
                        Me._SignatureFileID = Conversions.ToLong(dtr.Item("SignatureFileID"))
                    Else
                        Me._SignatureFileID = 0
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("DLStateID"))) Then
                        Me._DLStateID = Conversions.ToLong(dtr.Item("DLStateID"))
                    Else
                        Me._DLStateID = 0
                    End If
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("WebLoginID"))) Then
                        Me._WebLoginID = Conversions.ToLong(dtr.Item("WebLoginID"))
                    Else
                        Me._WebLoginID = 0
                    End If
                    Me._FirstName = dtr.Item("FirstName").ToString
                    Me._MiddleName = dtr.Item("MiddleName").ToString
                    Me._LastName = dtr.Item("LastName").ToString
                    Me._SSN = dtr.Item("SSN").ToString
                    Me._DLNumber = dtr.Item("DLNumber").ToString
                    Me._Email = dtr.Item("Email").ToString
                    Me._AdminAgent = Conversions.ToBoolean(dtr.Item("AdminAgent"))
                    Me._Active = Conversions.ToBoolean(dtr.Item("Active"))
                    Me._ScheduleHisOwnAppt = Conversions.ToBoolean(dtr.Item("ScheduleHisOwnAppt"))
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                    Me._PartnerAgentStatusID = Conversions.ToLong(dtr.Item("PartnerAgentStatusID"))
                    Me._WorkDayMonday = Conversions.ToBoolean(dtr.Item("WorkDayMonday"))
                    Me._WorkDayTuesday = Conversions.ToBoolean(dtr.Item("WorkDayTuesday"))
                    Me._WorkDayWednesday = Conversions.ToBoolean(dtr.Item("WorkDayWednesday"))
                    Me._WorkDayThursday = Conversions.ToBoolean(dtr.Item("WorkDayThursday"))
                    Me._WorkDayFriday = Conversions.ToBoolean(dtr.Item("WorkDayFriday"))
                    Me._WorkDaySaturday = Conversions.ToBoolean(dtr.Item("WorkDaySaturday"))
                    Me._WorkDaySunday = Conversions.ToBoolean(dtr.Item("WorkDaySunday"))
                    If Not IsDBNull(dtr("ScheduleZoneTypeID")) Then
                        _ScheduleZoneTypeID = CType(dtr("ScheduleZoneTypeID"), Long)
                    Else
                        _ScheduleZoneTypeID = 0
                    End If
                    If Not IsDBNull(dtr("SpecialInstructions")) Then
                        _SpecialInstructions = dtr("SpecialInstructions").ToString
                    Else
                        _SpecialInstructions = ""
                    End If
                Else
                    Me.ClearValues
                End If
                cnn.Close
            End If
        End Sub

        Public Sub LoadByWebLoginID(ByVal lngWebLoginID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim lngID As Long = 0
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetPartnerAgentByWebLoginID")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@WebLoginID", SqlDbType.Int).Value = lngWebLoginID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    lngID = Conversions.ToLong(dtr.Item("PartnerAgentID"))
                Else
                    lngID = 0
                End If
                cnn.Close
                cmd.Dispose
                cnn.Dispose
                If (lngID > 0) Then
                    Me.Load(lngID)
                Else
                    Me.ClearValues
                End If
            Else
                Me.ClearValues
            End If
        End Sub

        Public Sub Save(ByRef strChangeLog As String)
            strChangeLog = ""
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim strTemp As String = ""
                Dim cnn As New SqlConnection(Me._ConnectionString)
                cnn.Open
                Dim obj As New PartnerAgentRecord(Me._PartnerAgentID, Me._ConnectionString)
                obj.Load(Me._PartnerAgentID)
                If (obj.SignatureFileID <> Me._SignatureFileID) Then
                    Me.UpdateSignatureFileID(Me._SignatureFileID, (cnn))
                    strTemp = String.Concat(New String() { "SignatureFileID Changed to '", Conversions.ToString(Me._SignatureFileID), "' from '", Conversions.ToString(obj.SignatureFileID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.PartnerID <> Me._PartnerID) Then
                    Me.UpdatePartnerID(Me._PartnerID, (cnn))
                    strTemp = String.Concat(New String() { "PartnerID Changed to '", Conversions.ToString(Me._PartnerID), "' from '", Conversions.ToString(obj.PartnerID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.AgentTypeID <> Me._AgentTypeID) Then
                    Me.UpdateAgentTypeID(Me._AgentTypeID, (cnn))
                    strTemp = String.Concat(New String() { "AgentTypeID Changed to '", Conversions.ToString(Me._AgentTypeID), "' from '", Conversions.ToString(obj.AgentTypeID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.DLFileID <> Me._DLFileID) Then
                    Me.UpdateDLFileID(Me._DLFileID, (cnn))
                    strTemp = String.Concat(New String() { "DLFileID Changed to '", Conversions.ToString(Me._DLFileID), "' from '", Conversions.ToString(obj.DLFileID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.DLStateID <> Me._DLStateID) Then
                    Me.UpdateDLStateID(Me._DLStateID, (cnn))
                    strTemp = String.Concat(New String() { "DLStateID Changed to '", Conversions.ToString(Me._DLStateID), "' from '", Conversions.ToString(obj.DLStateID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.WebLoginID <> Me._WebLoginID) Then
                    Me.UpdateWebLoginID(Me._WebLoginID, (cnn))
                    strTemp = String.Concat(New String() { "WebLoginID Changed to '", Conversions.ToString(Me._WebLoginID), "' from '", Conversions.ToString(obj.WebLoginID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.FirstName <> Me._FirstName) Then
                    Me.UpdateFirstName(Me._FirstName, (cnn))
                    strTemp = String.Concat(New String() { "FirstName Changed to '", Me._FirstName, "' from '", obj.FirstName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.MiddleName <> Me._MiddleName) Then
                    Me.UpdateMiddleName(Me._MiddleName, (cnn))
                    strTemp = String.Concat(New String() { "MiddleName Changed to '", Me._MiddleName, "' from '", obj.MiddleName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.LastName <> Me._LastName) Then
                    Me.UpdateLastName(Me._LastName, (cnn))
                    strTemp = String.Concat(New String() { "LastName Changed to '", Me._LastName, "' from '", obj.LastName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.SSN <> Me._SSN) Then
                    Me.UpdateSSN(Me._SSN, (cnn))
                    strTemp = String.Concat(New String() { "SSN Changed to '", Me._SSN, "' from '", obj.SSN, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.DLNumber <> Me._DLNumber) Then
                    Me.UpdateDLNumber(Me._DLNumber, (cnn))
                    strTemp = String.Concat(New String() { "DLNumber Changed to '", Me._DLNumber, "' from '", obj.DLNumber, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Email <> Me._Email) Then
                    Me.UpdateEmail(Me._Email, (cnn))
                    strTemp = String.Concat(New String() { "Email Changed to '", Me._Email, "' from '", obj.Email, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.AdminAgent <> Me._AdminAgent) Then
                    Me.UpdateAdminAgent(Me._AdminAgent, (cnn))
                    strTemp = String.Concat(New String() { "AdminAgent Changed to '", Conversions.ToString(Me._AdminAgent), "' from '", Conversions.ToString(obj.AdminAgent), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Active <> Me._Active) Then
                    Me.UpdateActive(Me._Active, (cnn))
                    strTemp = String.Concat(New String() { "Active Changed to '", Conversions.ToString(Me._Active), "' from '", Conversions.ToString(obj.Active), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.PartnerAgentStatusID <> Me._PartnerAgentStatusID) Then
                    Me.UpdatePartnerAgentStatusID(Me._PartnerAgentStatusID, (cnn))
                    strTemp = String.Concat(New String() {"PartnerAgentStatusID Changed to '", Conversions.ToString(Me._PartnerAgentStatusID), "' from '", Conversions.ToString(obj.PartnerAgentStatusID), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If obj.WorkDayMonday <> _WorkDayMonday Then
                    UpdateWorkDayMonday(_WorkDayMonday, cnn)
                    strTemp = "WorkDayMonday Changed to '" & _WorkDayMonday & "' from '" & obj.WorkDayMonday & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.WorkDayTuesday <> _WorkDayTuesday Then
                    UpdateWorkDayTuesday(_WorkDayTuesday, cnn)
                    strTemp = "WorkDayTuesday Changed to '" & _WorkDayTuesday & "' from '" & obj.WorkDayTuesday & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.WorkDayWednesday <> _WorkDayWednesday Then
                    UpdateWorkDayWednesday(_WorkDayWednesday, cnn)
                    strTemp = "WorkDayWednesday Changed to '" & _WorkDayWednesday & "' from '" & obj.WorkDayWednesday & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.WorkDayThursday <> _WorkDayThursday Then
                    UpdateWorkDayThursday(_WorkDayThursday, cnn)
                    strTemp = "WorkDayThursday Changed to '" & _WorkDayThursday & "' from '" & obj.WorkDayThursday & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.WorkDayFriday <> _WorkDayFriday Then
                    UpdateWorkDayFriday(_WorkDayFriday, cnn)
                    strTemp = "WorkDayFriday Changed to '" & _WorkDayFriday & "' from '" & obj.WorkDayFriday & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.WorkDaySaturday <> _WorkDaySaturday Then
                    UpdateWorkDaySaturday(_WorkDaySaturday, cnn)
                    strTemp = "WorkDaySaturday Changed to '" & _WorkDaySaturday & "' from '" & obj.WorkDaySaturday & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.WorkDaySunday <> _WorkDaySunday Then
                    UpdateWorkDaySunday(_WorkDaySunday, cnn)
                    strTemp = "WorkDaySunday Changed to '" & _WorkDaySunday & "' from '" & obj.WorkDaySunday & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.ScheduleZoneTypeID <> _ScheduleZoneTypeID Then
                    UpdateScheduleZoneTypeID(_ScheduleZoneTypeID, cnn)
                    strTemp = "ScheduleZoneTypeID Changed to '" & _ScheduleZoneTypeID & "' from '" & obj.ScheduleZoneTypeID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.SpecialInstructions <> _SpecialInstructions Then
                    UpdateSpecialInstructions(_SpecialInstructions, cnn)
                    strTemp = "SpecialInstructions Changed to '" & _SpecialInstructions & "' from '" & obj.SpecialInstructions & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If (obj.ScheduleHisOwnAppt <> Me._ScheduleHisOwnAppt) Then
                    Me.UpdateScheduleHisOwnAppt(Me._ScheduleHisOwnAppt, (cnn))
                    strTemp = String.Concat(New String() {"ScheduleHisOwnAppt Changed to '", Conversions.ToString(Me._ScheduleHisOwnAppt), "' from '", Conversions.ToString(obj.Active), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If

                cnn.Close
                Me.Load(Me._PartnerAgentID)
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

        Private Sub UpdateActive(ByVal NewActive As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentActive")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = Me._PartnerAgentID
            cmd.Parameters.Add("@Active", SqlDbType.Bit).Value = NewActive
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateAdminAgent(ByVal NewAdminAgent As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentAdminAgent")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = Me._PartnerAgentID
            cmd.Parameters.Add("@AdminAgent", SqlDbType.Bit).Value = NewAdminAgent
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateAgentTypeID(ByVal NewAgentTypeID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentAgentTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = Me._PartnerAgentID
            cmd.Parameters.Add("@AgentTypeID", SqlDbType.Int).Value = NewAgentTypeID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub
        Private Sub UpdatePartnerAgentStatusID(ByVal NewPartnerAgentStatusID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentStatusID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = Me._PartnerAgentID
            cmd.Parameters.Add("@PartnerAgentStatusID", SqlDbType.Int).Value = NewPartnerAgentStatusID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdateDLFileID(ByVal NewDLFileID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentDLFileID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = Me._PartnerAgentID
            If (NewDLFileID > 0) Then
                cmd.Parameters.Add("@DLFileID", SqlDbType.Int).Value = NewDLFileID
            Else
                cmd.Parameters.Add("@DLFileID", SqlDbType.Int).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateDLNumber(ByVal NewDLNumber As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentDLNumber")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = Me._PartnerAgentID
            If (NewDLNumber.Trim.Length > 0) Then
                cmd.Parameters.Add("@DLNumber", SqlDbType.VarChar, Me.TrimTrunc(NewDLNumber, &H40).Length).Value = Me.TrimTrunc(NewDLNumber, &H40)
            Else
                cmd.Parameters.Add("@DLNumber", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateDLStateID(ByVal NewDLStateID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentDLStateID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = Me._PartnerAgentID
            If (NewDLStateID > 0) Then
                cmd.Parameters.Add("@DLStateID", SqlDbType.Int).Value = NewDLStateID
            Else
                cmd.Parameters.Add("@DLStateID", SqlDbType.Int).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateEmail(ByVal NewEmail As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentEmail")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = Me._PartnerAgentID
            If (NewEmail.Trim.Length > 0) Then
                cmd.Parameters.Add("@Email", SqlDbType.VarChar, Me.TrimTrunc(NewEmail, &HFF).Length).Value = Me.TrimTrunc(NewEmail, &HFF)
            Else
                cmd.Parameters.Add("@Email", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateFirstName(ByVal NewFirstName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentFirstName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = Me._PartnerAgentID
            cmd.Parameters.Add("@FirstName", SqlDbType.VarChar, Me.TrimTrunc(NewFirstName, &H20).Length).Value = Me.TrimTrunc(NewFirstName, &H20)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateLastName(ByVal NewLastName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentLastName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = Me._PartnerAgentID
            cmd.Parameters.Add("@LastName", SqlDbType.VarChar, Me.TrimTrunc(NewLastName, &H20).Length).Value = Me.TrimTrunc(NewLastName, &H20)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateMiddleName(ByVal NewMiddleName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentMiddleName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = Me._PartnerAgentID
            If (NewMiddleName.Trim.Length > 0) Then
                cmd.Parameters.Add("@MiddleName", SqlDbType.VarChar, Me.TrimTrunc(NewMiddleName, &H20).Length).Value = Me.TrimTrunc(NewMiddleName, &H20)
            Else
                cmd.Parameters.Add("@MiddleName", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdatePartnerID(ByVal NewPartnerID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentPartnerID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = Me._PartnerAgentID
            cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = NewPartnerID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateSignatureFileID(ByVal NewSignatureFileID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentSignatureFileID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = Me._PartnerAgentID
            If (NewSignatureFileID > 0) Then
                cmd.Parameters.Add("@SignatureFileID", SqlDbType.Int).Value = NewSignatureFileID
            Else
                cmd.Parameters.Add("@SignatureFileID", SqlDbType.Int).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateSSN(ByVal NewSSN As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentSSN")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = Me._PartnerAgentID
            If (NewSSN.Trim.Length > 0) Then
                cmd.Parameters.Add("@SSN", SqlDbType.VarChar, Me.TrimTrunc(NewSSN, &H40).Length).Value = Me.TrimTrunc(NewSSN, &H40)
            Else
                cmd.Parameters.Add("@SSN", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateWebLoginID(ByVal NewWebLoginID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentWebLoginID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = Me._PartnerAgentID
            If (NewWebLoginID > 0) Then
                cmd.Parameters.Add("@WebLoginID", SqlDbType.Int).Value = NewWebLoginID
            Else
                cmd.Parameters.Add("@WebLoginID", SqlDbType.Int).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub



        ''' <summary>
        ''' Updates the WorkDayMonday field for this record.
        ''' </summary>
        ''' <param name="NewWorkDayMonday">The new value for theWorkDayMonday field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateWorkDayMonday(ByVal NewWorkDayMonday As Boolean, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateWorkDayMonday")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@PartnerAgentID", sqlDBType.int).value = _PartnerAgentID
            cmd.Parameters.Add("@WorkDayMonday", SqlDbType.bit).value = NewWorkDayMonday
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the WorkDayTuesday field for this record.
        ''' </summary>
        ''' <param name="NewWorkDayTuesday">The new value for theWorkDayTuesday field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateWorkDayTuesday(ByVal NewWorkDayTuesday As Boolean, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateWorkDayTuesday")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@PartnerAgentID", sqlDBType.int).value = _PartnerAgentID
            cmd.Parameters.Add("@WorkDayTuesday", SqlDbType.bit).value = NewWorkDayTuesday
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the WorkDayWednesday field for this record.
        ''' </summary>
        ''' <param name="NewWorkDayWednesday">The new value for theWorkDayWednesday field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateWorkDayWednesday(ByVal NewWorkDayWednesday As Boolean, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateWorkDayWednesday")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@PartnerAgentID", sqlDBType.int).value = _PartnerAgentID
            cmd.Parameters.Add("@WorkDayWednesday", SqlDbType.bit).value = NewWorkDayWednesday
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the WorkDayThursday field for this record.
        ''' </summary>
        ''' <param name="NewWorkDayThursday">The new value for theWorkDayThursday field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateWorkDayThursday(ByVal NewWorkDayThursday As Boolean, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateWorkDayThursday")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@PartnerAgentID", sqlDBType.int).value = _PartnerAgentID
            cmd.Parameters.Add("@WorkDayThursday", SqlDbType.bit).value = NewWorkDayThursday
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the WorkDayFriday field for this record.
        ''' </summary>
        ''' <param name="NewWorkDayFriday">The new value for theWorkDayFriday field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateWorkDayFriday(ByVal NewWorkDayFriday As Boolean, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateWorkDayFriday")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@PartnerAgentID", sqlDBType.int).value = _PartnerAgentID
            cmd.Parameters.Add("@WorkDayFriday", SqlDbType.bit).value = NewWorkDayFriday
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the WorkDaySaturday field for this record.
        ''' </summary>
        ''' <param name="NewWorkDaySaturday">The new value for theWorkDaySaturday field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateWorkDaySaturday(ByVal NewWorkDaySaturday As Boolean, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateWorkDaySaturday")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@PartnerAgentID", sqlDBType.int).value = _PartnerAgentID
            cmd.Parameters.Add("@WorkDaySaturday", SqlDbType.bit).value = NewWorkDaySaturday
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the WorkDaySunday field for this record.
        ''' </summary>
        ''' <param name="NewWorkDaySunday">The new value for theWorkDaySunday field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateWorkDaySunday(ByVal NewWorkDaySunday As Boolean, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateWorkDaySunday")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@PartnerAgentID", sqlDBType.int).value = _PartnerAgentID
            cmd.Parameters.Add("@WorkDaySunday", SqlDbType.bit).value = NewWorkDaySunday
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdateScheduleZoneTypeID(ByVal NewScheduleZoneTypeID As Long, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdatePartnerAgentScheduleZoneTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@PartnerAgentID", sqlDBType.int).value = _PartnerAgentID
            If NewScheduleZoneTypeID > 0 Then
                cmd.Parameters.Add("@ScheduleZoneTypeID", SqlDbType.int).value = NewScheduleZoneTypeID
            Else
                cmd.Parameters.Add("@ScheduleZoneTypeID", SqlDbType.int).Value = System.DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateSpecialInstructions(ByVal NewSpecialInstructions As String, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdatePartnerAgentSpecialInstructions")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@PartnerAgentID", sqlDBType.int).value = _PartnerAgentID
            If NewSpecialInstructions.Trim.Length > 0 Then
                cmd.Parameters.Add("@SpecialInstructions", SqlDbType.text).value = NewSpecialInstructions
            Else
                cmd.Parameters.Add("@SpecialInstructions", SqlDbType.text).Value = System.DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdateScheduleHisOwnAppt(ByVal NewScheduleHisOwnAppt As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentScheduleHisOwnAppt")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = Me._PartnerAgentID
            cmd.Parameters.Add("@ScheduleHisOwnAppt", SqlDbType.Bit).Value = NewScheduleHisOwnAppt
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ' Properties
        Public Property Active As Boolean
            Get
                Return Me._Active
            End Get
            Set(ByVal value As Boolean)
                Me._Active = value
            End Set
        End Property

        Public Property AdminAgent As Boolean
            Get
                Return Me._AdminAgent
            End Get
            Set(ByVal value As Boolean)
                Me._AdminAgent = value
            End Set
        End Property

        Public Property AgentTypeID As Long
            Get
                Return Me._AgentTypeID
            End Get
            Set(ByVal value As Long)
                Me._AgentTypeID = value
            End Set
        End Property
        Public Property PartnerAgentStatusID() As Long
            Get
                Return Me._PartnerAgentStatusID
            End Get
            Set(ByVal value As Long)
                Me._PartnerAgentStatusID = value
            End Set
        End Property

        Public ReadOnly Property CertificationCount As Long
            Get
                Return Me.GetCertificationCount
            End Get
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

        Public Property DLFileID As Long
            Get
                Return Me._DLFileID
            End Get
            Set(ByVal value As Long)
                Me._DLFileID = value
            End Set
        End Property

        Public Property DLNumber As String
            Get
                Return Me._DLNumber
            End Get
            Set(ByVal value As String)
                Me._DLNumber = Me.TrimTrunc(value, &H40)
            End Set
        End Property

        Public Property DLStateID As Long
            Get
                Return Me._DLStateID
            End Get
            Set(ByVal value As Long)
                Me._DLStateID = value
            End Set
        End Property

        Public Property Email As String
            Get
                Return Me._Email
            End Get
            Set(ByVal value As String)
                Me._Email = Me.TrimTrunc(value, &HFF)
            End Set
        End Property

        Public Property FirstName As String
            Get
                Return Me._FirstName
            End Get
            Set(ByVal value As String)
                Me._FirstName = Me.TrimTrunc(value, &H20)
            End Set
        End Property

        Public Property LastName As String
            Get
                Return Me._LastName
            End Get
            Set(ByVal value As String)
                Me._LastName = Me.TrimTrunc(value, &H20)
            End Set
        End Property

        Public Property MiddleName As String
            Get
                Return Me._MiddleName
            End Get
            Set(ByVal value As String)
                Me._MiddleName = Me.TrimTrunc(value, &H20)
            End Set
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public ReadOnly Property NameTag As String
            Get
                Return Me.LabelText
            End Get
        End Property

        Public ReadOnly Property PartnerAgentID As Long
            Get
                Return Me._PartnerAgentID
            End Get
        End Property

        Public Property PartnerID As Long
            Get
                Return Me._PartnerID
            End Get
            Set(ByVal value As Long)
                Me._PartnerID = value
            End Set
        End Property

        Public Property SignatureFileID As Long
            Get
                Return Me._SignatureFileID
            End Get
            Set(ByVal value As Long)
                Me._SignatureFileID = value
            End Set
        End Property

        Public Property SSN As String
            Get
                Return Me._SSN
            End Get
            Set(ByVal value As String)
                Me._SSN = Me.TrimTrunc(value, &H40)
            End Set
        End Property

        Public ReadOnly Property UnAnsweredSkillSetQuestionCount As Long
            Get
                Return Me.GetUnAnsweredSkillSetQuestionCount
            End Get
        End Property

        Public Property WebLoginID As Long
            Get
                Return Me._WebLoginID
            End Get
            Set(ByVal value As Long)
                Me._WebLoginID = value
            End Set
        End Property


        ''' <summary>
        ''' Returns/Sets the WorkDayMonday field for the currently loaded record
        ''' </summary>
        Public Property WorkDayMonday() As Boolean
            Get
                Return _WorkDayMonday
            End Get
            Set(ByVal value As Boolean)
                _WorkDayMonday = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the WorkDayTuesday field for the currently loaded record
        ''' </summary>
        Public Property WorkDayTuesday() As Boolean
            Get
                Return _WorkDayTuesday
            End Get
            Set(ByVal value As Boolean)
                _WorkDayTuesday = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the WorkDayWednesday field for the currently loaded record
        ''' </summary>
        Public Property WorkDayWednesday() As Boolean
            Get
                Return _WorkDayWednesday
            End Get
            Set(ByVal value As Boolean)
                _WorkDayWednesday = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the WorkDayThursday field for the currently loaded record
        ''' </summary>
        Public Property WorkDayThursday() As Boolean
            Get
                Return _WorkDayThursday
            End Get
            Set(ByVal value As Boolean)
                _WorkDayThursday = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the WorkDayFriday field for the currently loaded record
        ''' </summary>
        Public Property WorkDayFriday() As Boolean
            Get
                Return _WorkDayFriday
            End Get
            Set(ByVal value As Boolean)
                _WorkDayFriday = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the WorkDaySaturday field for the currently loaded record
        ''' </summary>
        Public Property WorkDaySaturday() As Boolean
            Get
                Return _WorkDaySaturday
            End Get
            Set(ByVal value As Boolean)
                _WorkDaySaturday = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the WorkDaySunday field for the currently loaded record
        ''' </summary>
        Public Property WorkDaySunday() As Boolean
            Get
                Return _WorkDaySunday
            End Get
            Set(ByVal value As Boolean)
                _WorkDaySunday = value
            End Set
        End Property

        Public Property ScheduleZoneTypeID() As Long
            Get
                Return _ScheduleZoneTypeID
            End Get
            Set(ByVal value As Long)
                _ScheduleZoneTypeID = value
            End Set
        End Property
        Public Property SpecialInstructions() As String
            Get
                Return _SpecialInstructions
            End Get
            Set(ByVal value As String)
                _SpecialInstructions = value
            End Set
        End Property

        Public Property ScheduleHisOwnAppt() As Boolean
            Get
                Return Me._ScheduleHisOwnAppt
            End Get
            Set(ByVal value As Boolean)
                Me._ScheduleHisOwnAppt = value
            End Set
        End Property

        ' Fields
        Private _Active As Boolean
        Private _AdminAgent As Boolean
        Private _AgentTypeID As Long
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _DLFileID As Long
        Private _DLNumber As String
        Private _DLStateID As Long
        Private _Email As String
        Private _FirstName As String
        Private _LastName As String
        Private _MiddleName As String
        Private _PartnerAgentID As Long
        Private _PartnerID As Long
        Private _SignatureFileID As Long
        Private _SSN As String
        Private _WebLoginID As Long
        Private _PartnerAgentStatusID As Long
        Private _WorkDayMonday As Boolean
        Private _WorkDayTuesday As Boolean
        Private _WorkDayWednesday As Boolean
        Private _WorkDayThursday As Boolean
        Private _WorkDayFriday As Boolean
        Private _WorkDaySaturday As Boolean
        Private _WorkDaySunday As Boolean
        Private _ScheduleZoneTypeID As Long
        Private _SpecialInstructions As String
        Private _ScheduleHisOwnAppt As Boolean
        Private Const DLNumberMaxLength As Integer = &H40
        Private Const EmailMaxLength As Integer = &HFF
        Private Const FirstNameMaxLength As Integer = &H20
        Private Const LastNameMaxLength As Integer = &H20
        Private Const MiddleNameMaxLength As Integer = &H20
        Private Const SSNMaxLength As Integer = &H40
    End Class
End Namespace

