Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class ResumeRecord
        ' Methods
        Public Sub New()
            Me._ConfidenceLevel = 0
            Me._ResumeID = 0
            Me._DLFileID = 0
            Me._CreatedBy = 0
            Me._EntityTypeID = 1
            Me._CompanyName = ""
            Me._FirstName = ""
            Me._MiddleName = ""
            Me._LastName = ""
            Me._Email = ""
            Me._Resume = ""
            Me._WebSite = ""
            Me._Misc = ""
            Me._ContactMonday = False
            Me._ContactTuesday = False
            Me._ContactWednesday = False
            Me._ContactThursday = False
            Me._ContactFriday = False
            Me._ContactSaturday = False
            Me._ContactSunday = False
            Me._DocumentsApproved = False
            Me._ContactStart = 0
            Me._ContactEnd = 0
            Me._DateCreated = DateTime.Now
            Me._ReferrerID = 0
            Me._ReferrerOther = ""
            Me._IPAddress = ""
            Me._EIN = ""
            Me._SSN = ""
            Me._DLNumber = ""
            Me._DLStateID = 0
            Me._EmergencyFirstName = ""
            Me._EmergencyMiddleName = ""
            Me._EmergencyLastName = ""
            Me._EmergencyCountryCode = ""
            Me._EmergencyAreaCode = ""
            Me._EmergencyExchange = ""
            Me._EmergencyLineNumber = ""
            Me._WebLoginID = 0
            Me._Declined = False
            Me._BusinessStartedMonthID = 0
            Me._BusinessStartedYear = 0
            Me._ConnectionString = ""
            Me._BlankWaiverFileID = 0
            Me._BlankContractFileID = 0
            Me._BlankNDAFileID = 0
            Me._SignedWaiverFileID = 0
            Me._SignedContractFileID = 0
            Me._SignedNDAFileID = 0
            Me._SignatureFileID = 0
            Me._BlankSignatureFileID = 0
            Me._ContractCode = ""
            Me._NDACode = ""
            Me._WaiverCode = ""
            Me._ContractSignatureDate = New DateTime
            Me._WaiverSignatureDate = New DateTime
            Me._NDASignatureDate = New DateTime
            Me._ResumeTypeID = 0
            Me._UserID = 0
            Me._InfoID = 0
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._ConfidenceLevel = 0
            Me._ResumeID = 0
            Me._DLFileID = 0
            Me._CreatedBy = 0
            Me._EntityTypeID = 1
            Me._CompanyName = ""
            Me._FirstName = ""
            Me._MiddleName = ""
            Me._LastName = ""
            Me._Email = ""
            Me._Resume = ""
            Me._WebSite = ""
            Me._Misc = ""
            Me._ContactMonday = False
            Me._ContactTuesday = False
            Me._ContactWednesday = False
            Me._ContactThursday = False
            Me._ContactFriday = False
            Me._ContactSaturday = False
            Me._ContactSunday = False
            Me._DocumentsApproved = False
            Me._ContactStart = 0
            Me._ContactEnd = 0
            Me._DateCreated = DateTime.Now
            Me._ReferrerID = 0
            Me._ReferrerOther = ""
            Me._IPAddress = ""
            Me._EIN = ""
            Me._SSN = ""
            Me._DLNumber = ""
            Me._DLStateID = 0
            Me._EmergencyFirstName = ""
            Me._EmergencyMiddleName = ""
            Me._EmergencyLastName = ""
            Me._EmergencyCountryCode = ""
            Me._EmergencyAreaCode = ""
            Me._EmergencyExchange = ""
            Me._EmergencyLineNumber = ""
            Me._WebLoginID = 0
            Me._Declined = False
            Me._BusinessStartedMonthID = 0
            Me._BusinessStartedYear = 0
            Me._ConnectionString = ""
            Me._BlankWaiverFileID = 0
            Me._BlankContractFileID = 0
            Me._BlankNDAFileID = 0
            Me._SignedWaiverFileID = 0
            Me._SignedContractFileID = 0
            Me._SignedNDAFileID = 0
            Me._SignatureFileID = 0
            Me._BlankSignatureFileID = 0
            Me._ContractCode = ""
            Me._NDACode = ""
            Me._WaiverCode = ""
            Me._ContractSignatureDate = New DateTime
            Me._WaiverSignatureDate = New DateTime
            Me._NDASignatureDate = New DateTime
            Me._ResumeTypeID = 0
            Me._UserID = 0
            Me._InfoID = 0
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngResumeID As Long, ByVal strConnectionString As String)
            Me._ConfidenceLevel = 0
            Me._ResumeID = 0
            Me._DLFileID = 0
            Me._CreatedBy = 0
            Me._EntityTypeID = 1
            Me._CompanyName = ""
            Me._FirstName = ""
            Me._MiddleName = ""
            Me._LastName = ""
            Me._Email = ""
            Me._Resume = ""
            Me._WebSite = ""
            Me._Misc = ""
            Me._ContactMonday = False
            Me._ContactTuesday = False
            Me._ContactWednesday = False
            Me._ContactThursday = False
            Me._ContactFriday = False
            Me._ContactSaturday = False
            Me._ContactSunday = False
            Me._DocumentsApproved = False
            Me._ContactStart = 0
            Me._ContactEnd = 0
            Me._DateCreated = DateTime.Now
            Me._ReferrerID = 0
            Me._ReferrerOther = ""
            Me._IPAddress = ""
            Me._EIN = ""
            Me._SSN = ""
            Me._DLNumber = ""
            Me._DLStateID = 0
            Me._EmergencyFirstName = ""
            Me._EmergencyMiddleName = ""
            Me._EmergencyLastName = ""
            Me._EmergencyCountryCode = ""
            Me._EmergencyAreaCode = ""
            Me._EmergencyExchange = ""
            Me._EmergencyLineNumber = ""
            Me._WebLoginID = 0
            Me._Declined = False
            Me._BusinessStartedMonthID = 0
            Me._BusinessStartedYear = 0
            Me._ConnectionString = ""
            Me._BlankWaiverFileID = 0
            Me._BlankContractFileID = 0
            Me._BlankNDAFileID = 0
            Me._SignedWaiverFileID = 0
            Me._SignedContractFileID = 0
            Me._SignedNDAFileID = 0
            Me._SignatureFileID = 0
            Me._BlankSignatureFileID = 0
            Me._ContractCode = ""
            Me._NDACode = ""
            Me._WaiverCode = ""
            Me._ContractSignatureDate = New DateTime
            Me._WaiverSignatureDate = New DateTime
            Me._NDASignatureDate = New DateTime
            Me._ResumeTypeID = 0
            Me._UserID = 0
            Me._InfoID = 0
            Me._ConnectionString = strConnectionString
            Me.Load(Me._ResumeID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal lngEntityTypeID As Long, ByVal strFirstName As String, ByVal strLastName As String, ByVal strEmail As String, ByVal strResume As String, ByVal blnContactMonday As Boolean, ByVal blnContactTuesday As Boolean, ByVal blnContactWednesday As Boolean, ByVal blnContactThursday As Boolean, ByVal blnContactFriday As Boolean, ByVal blnContactSaturday As Boolean, ByVal blnContactSunday As Boolean, ByVal intContactStart As Integer, ByVal intContactEnd As Integer, ByVal lngUserID As Long, ByVal lngInfoID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddResume")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngResumeID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@EntityTypeID", SqlDbType.Int).Value = lngEntityTypeID
                cmd.Parameters.Add("@FirstName", SqlDbType.VarChar, Me.TrimTrunc(strFirstName, &H20).Length).Value = Me.TrimTrunc(strFirstName, &H20)
                cmd.Parameters.Add("@LastName", SqlDbType.VarChar, Me.TrimTrunc(strLastName, &H40).Length).Value = Me.TrimTrunc(strLastName, &H40)
                cmd.Parameters.Add("@Email", SqlDbType.VarChar, Me.TrimTrunc(strEmail, &HFF).Length).Value = Me.TrimTrunc(strEmail, &HFF)
                cmd.Parameters.Add("@Resume", SqlDbType.Text).Value = strResume
                cmd.Parameters.Add("@ContactMonday", SqlDbType.Bit).Value = blnContactMonday
                cmd.Parameters.Add("@ContactTuesday", SqlDbType.Bit).Value = blnContactTuesday
                cmd.Parameters.Add("@ContactWednesday", SqlDbType.Bit).Value = blnContactWednesday
                cmd.Parameters.Add("@ContactThursday", SqlDbType.Bit).Value = blnContactThursday
                cmd.Parameters.Add("@ContactFriday", SqlDbType.Bit).Value = blnContactFriday
                cmd.Parameters.Add("@ContactSaturday", SqlDbType.Bit).Value = blnContactSaturday
                cmd.Parameters.Add("@ContactSunday", SqlDbType.Bit).Value = blnContactSunday
                cmd.Parameters.Add("@ContactStart", SqlDbType.TinyInt).Value = intContactStart
                cmd.Parameters.Add("@ContactEnd", SqlDbType.TinyInt).Value = intContactEnd
                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = lngUserID
                cmd.Parameters.Add("@InfoID", SqlDbType.Int).Value = lngInfoID
                cnn.Open()
                cmd.Connection = cnn
                lngResumeID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close()
                If (lngResumeID > 0) Then
                    Me.Load(lngResumeID)
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
            Me._DLFileID = 0
            Me._ResumeTypeID = 0
            Me._SignatureFileID = 0
            Me._BlankWaiverFileID = 0
            Me._BlankContractFileID = 0
            Me._BlankNDAFileID = 0
            Me._SignedWaiverFileID = 0
            Me._SignedContractFileID = 0
            Me._SignedNDAFileID = 0
            Me._BusinessStartedMonthID = 0
            Me._BusinessStartedYear = 0
            Me._ResumeID = 0
            Me._WebLoginID = 0
            Me._Declined = False
            Me._CreatedBy = 0
            Me._EntityTypeID = 1
            Me._CompanyName = ""
            Me._FirstName = ""
            Me._MiddleName = ""
            Me._LastName = ""
            Me._Email = ""
            Me._Resume = ""
            Me._WebSite = ""
            Me._Misc = ""
            Me._DocumentsApproved = False
            Me._ContactMonday = False
            Me._ContactTuesday = False
            Me._ContactWednesday = False
            Me._ContactThursday = False
            Me._ContactFriday = False
            Me._ContactSaturday = False
            Me._ContactSunday = False
            Me._ContactStart = 0
            Me._ContactEnd = 0
            Me._DateCreated = DateTime.Now
            Me._ResumeID = 0
            Me._ReferrerID = 0
            Me._ReferrerOther = ""
            Me._IPAddress = ""
            Me._EIN = ""
            Me._SSN = ""
            Me._DLNumber = ""
            Me._DLStateID = 0
            Me._EmergencyFirstName = ""
            Me._EmergencyMiddleName = ""
            Me._EmergencyLastName = ""
            Me._EmergencyCountryCode = ""
            Me._EmergencyAreaCode = ""
            Me._EmergencyExchange = ""
            Me._EmergencyLineNumber = ""
            Me._BlankSignatureFileID = 0
            Me._ContractCode = ""
            Me._NDACode = ""
            Me._ConfidenceLevel = 0
            Me._WaiverCode = ""
            Me._ContractSignatureDate = New DateTime
            Me._WaiverSignatureDate = New DateTime
            Me._NDASignatureDate = New DateTime
            Me._UserID = 0
            Me._InfoID = 0
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveResume")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._ResumeID)
            End If
        End Sub

        Private Function GetLocalTime() As DateTime
            Dim datReturn As DateTime = DateTime.Now
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetResumeLocalTime")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
                cnn.Open
                cmd.Connection = cnn
                datReturn = Conversions.ToDate(cmd.ExecuteScalar)
                cnn.Close
            End If
            Return datReturn
        End Function

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New ResumeRecord(Me._ResumeID, Me._ConnectionString)
            obj.Load(Me._ResumeID)
            If (obj.BlankSignatureFileID <> Me._BlankSignatureFileID) Then
                blnReturn = True
            End If
            If (obj.ConfidenceLevel <> Me._ConfidenceLevel) Then
                blnReturn = True
            End If
            If (obj.ContractCode <> Me._ContractCode) Then
                blnReturn = True
            End If
            If (obj.ResumeTypeID <> Me._ResumeTypeID) Then
                blnReturn = True
            End If
            If (obj.NDACode <> Me._NDACode) Then
                blnReturn = True
            End If
            If (obj.WaiverCode <> Me._WaiverCode) Then
                blnReturn = True
            End If
            If (DateTime.Compare(obj.ContractSignatureDate, Me._ContractSignatureDate) <> 0) Then
                blnReturn = True
            End If
            If (DateTime.Compare(obj.WaiverSignatureDate, Me._WaiverSignatureDate) <> 0) Then
                blnReturn = True
            End If
            If (DateTime.Compare(obj.NDASignatureDate, Me._NDASignatureDate) <> 0) Then
                blnReturn = True
            End If
            If (obj.SignatureFileID <> Me._SignatureFileID) Then
                blnReturn = True
            End If
            If (obj.DLFileID <> Me._DLFileID) Then
                blnReturn = True
            End If
            If (obj.BlankWaiverFileID <> Me._BlankWaiverFileID) Then
                blnReturn = True
            End If
            If (obj.BlankContractFileID <> Me._BlankContractFileID) Then
                blnReturn = True
            End If
            If (obj.BlankNDAFileID <> Me._BlankNDAFileID) Then
                blnReturn = True
            End If
            If (obj.SignedWaiverFileID <> Me._SignedWaiverFileID) Then
                blnReturn = True
            End If
            If (obj.SignedContractFileID <> Me._SignedContractFileID) Then
                blnReturn = True
            End If
            If (obj.SignedNDAFileID <> Me._SignedNDAFileID) Then
                blnReturn = True
            End If
            If (obj.BusinessStartedMonthID <> Me._BusinessStartedMonthID) Then
                blnReturn = True
            End If
            If (obj.BusinessStartedYear <> Me._BusinessStartedYear) Then
                blnReturn = True
            End If
            If (obj.WebLoginID <> Me._WebLoginID) Then
                blnReturn = True
            End If
            If (obj.Declined <> Me._Declined) Then
                blnReturn = True
            End If
            If (obj.EntityTypeID <> Me._EntityTypeID) Then
                blnReturn = True
            End If
            If (obj.ReferrerID <> Me._ReferrerID) Then
                blnReturn = True
            End If
            If (obj.ReferrerOther <> Me._ReferrerOther) Then
                blnReturn = True
            End If
            If (obj.IPAddress <> Me._IPAddress) Then
                blnReturn = True
            End If
            If (obj.CompanyName <> Me._CompanyName) Then
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
            If (obj.Email <> Me._Email) Then
                blnReturn = True
            End If
            If (obj.ResumeText <> Me._Resume) Then
                blnReturn = True
            End If
            If (obj.WebSite <> Me._WebSite) Then
                blnReturn = True
            End If
            If (obj.Misc <> Me._Misc) Then
                blnReturn = True
            End If
            If (obj.ContactMonday <> Me._ContactMonday) Then
                blnReturn = True
            End If
            If (obj.ContactTuesday <> Me._ContactTuesday) Then
                blnReturn = True
            End If
            If (obj.ContactWednesday <> Me._ContactWednesday) Then
                blnReturn = True
            End If
            If (obj.ContactThursday <> Me._ContactThursday) Then
                blnReturn = True
            End If
            If (obj.ContactFriday <> Me._ContactFriday) Then
                blnReturn = True
            End If
            If (obj.ContactSaturday <> Me._ContactSaturday) Then
                blnReturn = True
            End If
            If (obj.ContactSunday <> Me._ContactSunday) Then
                blnReturn = True
            End If
            If (obj.ContactStart <> Me._ContactStart) Then
                blnReturn = True
            End If
            If (obj.ContactEnd <> Me._ContactEnd) Then
                blnReturn = True
            End If
            If (obj.EIN <> Me._EIN) Then
                blnReturn = True
            End If
            If (obj.SSN <> Me._SSN) Then
                blnReturn = True
            End If
            If (obj.DLNumber <> Me._DLNumber) Then
                blnReturn = True
            End If
            If (obj.DLStateID <> Me._DLStateID) Then
                blnReturn = True
            End If
            If (obj.EmergencyFirstName <> Me._EmergencyFirstName) Then
                blnReturn = True
            End If
            If (obj.EmergencyMiddleName <> Me._EmergencyMiddleName) Then
                blnReturn = True
            End If
            If (obj.EmergencyLastName <> Me._EmergencyLastName) Then
                blnReturn = True
            End If
            If (obj.EmergencyCountryCode <> Me._EmergencyCountryCode) Then
                blnReturn = True
            End If
            If (obj.EmergencyAreaCode <> Me._EmergencyAreaCode) Then
                blnReturn = True
            End If
            If (obj.EmergencyExchange <> Me._EmergencyExchange) Then
                blnReturn = True
            End If
            If (obj.DocumentsApproved <> Me._DocumentsApproved) Then
                blnReturn = True
            End If
            If (obj.EmergencyLineNumber <> Me._EmergencyLineNumber) Then
                blnReturn = True
            End If
            If (obj.UserID <> Me._UserID) Then
                blnReturn = True
            End If
            If (obj.InfoID <> Me._InfoID) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Function IsInFolder(ByVal Folder As ResumeSystemFolders) As Boolean
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spIsResumeInFolder")
                Dim lngCount As Integer = 0
                cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
                cmd.Parameters.Add("@ResumeFolderID", SqlDbType.Int).Value = CLng(Folder)
                cmd.CommandType = CommandType.StoredProcedure
                cnn.Open
                cmd.Connection = cnn
                lngCount = Conversions.ToInteger(cmd.ExecuteScalar)
                cnn.Close
                Return (lngCount > 0)
            End If
            Return False
        End Function

        Public Sub Load(ByVal lngResumeID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetResume")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = lngResumeID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._ConfidenceLevel = Conversions.ToInteger(dtr.Item("ConfidenceLevel"))
                    Me._ResumeID = Conversions.ToLong(dtr.Item("ResumeID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._EntityTypeID = Conversions.ToLong(dtr.Item("EntityTypeID"))
                    Me._CompanyName = dtr.Item("CompanyName").ToString
                    Me._FirstName = dtr.Item("FirstName").ToString
                    Me._MiddleName = dtr.Item("MiddleName").ToString
                    Me._LastName = dtr.Item("LastName").ToString
                    Me._Email = dtr.Item("Email").ToString
                    Me._Resume = dtr.Item("Resume").ToString
                    Me._WebSite = dtr.Item("WebSite").ToString
                    Me._Misc = dtr.Item("Misc").ToString
                    Me._ContactMonday = Conversions.ToBoolean(dtr.Item("ContactMonday"))
                    Me._ContactTuesday = Conversions.ToBoolean(dtr.Item("ContactTuesday"))
                    Me._ContactWednesday = Conversions.ToBoolean(dtr.Item("ContactWednesday"))
                    Me._ContactThursday = Conversions.ToBoolean(dtr.Item("ContactThursday"))
                    Me._ContactFriday = Conversions.ToBoolean(dtr.Item("ContactFriday"))
                    Me._ContactSaturday = Conversions.ToBoolean(dtr.Item("ContactSaturday"))
                    Me._ContactSunday = Conversions.ToBoolean(dtr.Item("ContactSunday"))
                    Me._ContactStart = Conversions.ToInteger(dtr.Item("ContactStart"))
                    Me._ContactEnd = Conversions.ToInteger(dtr.Item("ContactEnd"))
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                    Me._DocumentsApproved = Conversions.ToBoolean(dtr.Item("DocumentsApproved"))
                    Me._ResumeID = Conversions.ToLong(dtr.Item("ResumeID"))
                    Me._EIN = dtr.Item("EIN").ToString
                    Me._SSN = dtr.Item("SSN").ToString
                    Me._DLNumber = dtr.Item("DLNumber").ToString
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("ResumeTypeID"))) Then
                        Me._ResumeTypeID = Conversions.ToLong(dtr.Item("ResumeTypeID"))
                    Else
                        Me._ResumeTypeID = 0
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("SignatureFileID"))) Then
                        Me._SignatureFileID = Conversions.ToLong(dtr.Item("SignatureFileID"))
                    Else
                        Me._SignatureFileID = 0
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("DLFileID"))) Then
                        Me._DLFileID = Conversions.ToLong(dtr.Item("DLFileID"))
                    Else
                        Me._DLFileID = 0
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("BlankWaiverFileID"))) Then
                        Me._BlankWaiverFileID = Conversions.ToLong(dtr.Item("BlankWaiverFileID"))
                    Else
                        Me._BlankWaiverFileID = 0
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("BlankNDAFileID"))) Then
                        Me._BlankNDAFileID = Conversions.ToLong(dtr.Item("BlankNDAFileID"))
                    Else
                        Me._BlankNDAFileID = 0
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("BlankContractFileID"))) Then
                        Me._BlankContractFileID = Conversions.ToLong(dtr.Item("BlankContractFileID"))
                    Else
                        Me._BlankContractFileID = 0
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("SignedContractFileID"))) Then
                        Me._SignedContractFileID = Conversions.ToLong(dtr.Item("SignedContractFileID"))
                    Else
                        Me._SignedContractFileID = 0
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("SignedNDAFileID"))) Then
                        Me._SignedNDAFileID = Conversions.ToLong(dtr.Item("SignedNDAFileID"))
                    Else
                        Me._SignedNDAFileID = 0
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("SignedWaiverFileID"))) Then
                        Me._SignedWaiverFileID = Conversions.ToLong(dtr.Item("SignedWaiverFileID"))
                    Else
                        Me._SignedWaiverFileID = 0
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("BusinessStartedMonthID"))) Then
                        Me._BusinessStartedMonthID = Conversions.ToInteger(dtr.Item("BusinessStartedMonthID"))
                    Else
                        Me._BusinessStartedMonthID = 0
                    End If
                    Me._BusinessStartedYear = Conversions.ToInteger(dtr.Item("BusinessStartedYear"))
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("DLStateID"))) Then
                        Me._DLStateID = Conversions.ToLong(dtr.Item("DLStateID"))
                    Else
                        Me._DLStateID = 0
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("WebLoginID"))) Then
                        Me._WebLoginID = Conversions.ToLong(dtr.Item("WebLoginID"))
                    Else
                        Me._WebLoginID = 0
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("BlankSignatureFileID"))) Then
                        Me._BlankSignatureFileID = Conversions.ToLong(dtr.Item("BlankSignatureFileID"))
                    Else
                        Me._BlankSignatureFileID = 0
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("ContractCode"))) Then
                        Me._ContractCode = dtr.Item("ContractCode").ToString
                    Else
                        Me._ContractCode = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("NDACode"))) Then
                        Me._NDACode = dtr.Item("NDACode").ToString
                    Else
                        Me._NDACode = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("WaiverCode"))) Then
                        Me._WaiverCode = dtr.Item("WaiverCode").ToString
                    Else
                        Me._WaiverCode = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("ContractSignatureDate"))) Then
                        Me._ContractSignatureDate = Conversions.ToDate(dtr.Item("ContractSignatureDate"))
                    Else
                        Me._ContractSignatureDate = New DateTime
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("WaiverSignatureDate"))) Then
                        Me._WaiverSignatureDate = Conversions.ToDate(dtr.Item("WaiverSignatureDate"))
                    Else
                        Me._WaiverSignatureDate = New DateTime
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("NDASignatureDate"))) Then
                        Me._NDASignatureDate = Conversions.ToDate(dtr.Item("NDASignatureDate"))
                    Else
                        Me._NDASignatureDate = New DateTime
                    End If
                    Me._Declined = Conversions.ToBoolean(dtr.Item("Declined"))
                    Me._EmergencyFirstName = dtr.Item("EmergencyFirstName").ToString
                    Me._EmergencyMiddleName = dtr.Item("EmergencyMiddleName").ToString
                    Me._EmergencyLastName = dtr.Item("EmergencyLastName").ToString
                    Me._EmergencyCountryCode = dtr.Item("EmergencyCountryCode").ToString
                    Me._EmergencyAreaCode = dtr.Item("EmergencyAreaCode").ToString
                    Me._EmergencyExchange = dtr.Item("EmergencyExchange").ToString
                    Me._EmergencyLineNumber = dtr.Item("EmergencyLineNumber").ToString
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("ReferrerID"))) Then
                        Me._ReferrerID = Conversions.ToLong(dtr.Item("ReferrerID"))
                    Else
                        Me._ReferrerID = 0
                    End If
                    Me._ReferrerOther = dtr.Item("ReferrerOther").ToString
                    Me._IPAddress = dtr.Item("IPAddress").ToString
                    Me._UserID = Conversions.ToLong(dtr.Item("UserID"))
                    Me._InfoID = Conversions.ToLong(dtr.Item("InfoID"))
                Else
                    Me.ClearValues()
                End If
                cnn.Close
            End If
        End Sub

        Public Sub Load(ByVal strEmail As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetResumeIDByEmail")
                Dim lngID As Long = 0
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@Email", SqlDbType.VarChar, strEmail.Trim.Length).Value = strEmail
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    lngID = Conversions.ToLong(dtr.Item("ResumeID"))
                Else
                    lngID = 0
                End If
                cnn.Close
                If (lngID > 0) Then
                    Me.Load(lngID)
                Else
                    Me.ClearValues
                End If
            End If
        End Sub

        Private Function MakeNameTag() As String
            Dim strReturn As String = Me._FirstName.Trim
            If (Me._MiddleName.Trim.Length > 0) Then
                strReturn = (strReturn & " " & Me._MiddleName.Trim)
            End If
            If (Me._LastName.Trim.Length > 0) Then
                strReturn = (strReturn & " " & Me._LastName.Trim)
            End If
            Return strReturn.Trim
        End Function

        Public Sub RemoveFromFolder(ByVal lngFolderID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveResumeFromFolder")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
                cmd.Parameters.Add("@ResumeFolderID", SqlDbType.Int).Value = lngFolderID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                cmd.Dispose
                cnn.Dispose
            End If
        End Sub

        Public Sub Save(ByRef strChangeLog As String)
            strChangeLog = ""
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim strTemp As String = ""
                Dim cnn As New SqlConnection(Me._ConnectionString)
                cnn.Open
                Dim obj As New ResumeRecord(Me._ResumeID, Me._ConnectionString)
                obj.Load(Me._ResumeID)
                If (obj.BlankWaiverFileID <> Me._BlankWaiverFileID) Then
                    Me.UpdateBlankWaiverFileID(Me._BlankWaiverFileID, (cnn))
                    strTemp = String.Concat(New String() { "BlankWaiverFileID Changed to '", Conversions.ToString(Me._BlankWaiverFileID), "' from '", Conversions.ToString(obj.BlankWaiverFileID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ConfidenceLevel <> Me._ConfidenceLevel) Then
                    Me.UpdateConfidenceLevel(Me._ConfidenceLevel, (cnn))
                    strTemp = String.Concat(New String() { "ConfidenceLevel Changed to '", Conversions.ToString(Me._ConfidenceLevel), "' from '", Conversions.ToString(obj.ConfidenceLevel), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.DLFileID <> Me._DLFileID) Then
                    Me.UpdateDLFileID(Me._DLFileID, (cnn))
                    strTemp = String.Concat(New String() { "DLFileID Changed to '", Conversions.ToString(Me._DLFileID), "' from '", Conversions.ToString(obj.DLFileID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.BlankContractFileID <> Me._BlankContractFileID) Then
                    Me.UpdateBlankContractFileID(Me._BlankContractFileID, (cnn))
                    strTemp = String.Concat(New String() { "BlankContractFileID Changed to '", Conversions.ToString(Me._BlankContractFileID), "' from '", Conversions.ToString(obj.BlankContractFileID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.BlankNDAFileID <> Me._BlankNDAFileID) Then
                    Me.UpdateBlankNDAFileID(Me._BlankNDAFileID, (cnn))
                    strTemp = String.Concat(New String() { "BlankNDAFileID Changed to '", Conversions.ToString(Me._BlankNDAFileID), "' from '", Conversions.ToString(obj.BlankNDAFileID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.SignedWaiverFileID <> Me._SignedWaiverFileID) Then
                    Me.UpdateSignedWaiverFileID(Me._SignedWaiverFileID, (cnn))
                    strTemp = String.Concat(New String() { "SignedWaiverFileID Changed to '", Conversions.ToString(Me._SignedWaiverFileID), "' from '", Conversions.ToString(obj.SignedWaiverFileID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.DocumentsApproved <> Me._DocumentsApproved) Then
                    Me.UpdateDocumentsApproved(Me._DocumentsApproved, (cnn))
                    strTemp = String.Concat(New String() { "DocumentsApproved Changed to '", Conversions.ToString(Me._DocumentsApproved), "' from '", Conversions.ToString(obj.DocumentsApproved), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.SignedContractFileID <> Me._SignedContractFileID) Then
                    Me.UpdateSignedContractFileID(Me._SignedContractFileID, (cnn))
                    strTemp = String.Concat(New String() { "SignedContractFileID Changed to '", Conversions.ToString(Me._SignedContractFileID), "' from '", Conversions.ToString(obj.SignedContractFileID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.SignedNDAFileID <> Me._SignedNDAFileID) Then
                    Me.UpdateSignedNDAFileID(Me._SignedNDAFileID, (cnn))
                    strTemp = String.Concat(New String() { "SignedNDAFileID Changed to '", Conversions.ToString(Me._SignedNDAFileID), "' from '", Conversions.ToString(obj.SignedNDAFileID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.WebLoginID <> Me._WebLoginID) Then
                    Me.UpdateWebLoginID(Me._WebLoginID, (cnn))
                    strTemp = String.Concat(New String() { "WebLoginID Changed to '", Conversions.ToString(Me._WebLoginID), "' from '", Conversions.ToString(obj.WebLoginID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Declined <> Me._Declined) Then
                    Me.UpdateDeclined(Me._Declined, (cnn))
                    strTemp = String.Concat(New String() { "Declined Changed to '", Conversions.ToString(Me._Declined), "' from '", Conversions.ToString(obj.Declined), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.BusinessStartedMonthID <> Me._BusinessStartedMonthID) Then
                    Me.UpdateBusinessStartedMonthID(Me._BusinessStartedMonthID, (cnn))
                    strTemp = String.Concat(New String() { "BusinessStartedMonthID Changed to '", Conversions.ToString(Me._BusinessStartedMonthID), "' from '", Conversions.ToString(obj.BusinessStartedMonthID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.BusinessStartedYear <> Me._BusinessStartedYear) Then
                    Me.UpdateBusinessStartedYear(Me._BusinessStartedYear, (cnn))
                    strTemp = String.Concat(New String() { "BusinessStartedYear Changed to '", Conversions.ToString(Me._BusinessStartedYear), "' from '", Conversions.ToString(obj.BusinessStartedYear), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.EntityTypeID <> Me._EntityTypeID) Then
                    Me.UpdateEntityTypeID(Me._EntityTypeID, (cnn))
                    strTemp = String.Concat(New String() { "EntityTypeID Changed to '", Conversions.ToString(Me._EntityTypeID), "' from '", Conversions.ToString(obj.EntityTypeID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.CompanyName <> Me._CompanyName) Then
                    Me.UpdateCompanyName(Me._CompanyName, (cnn))
                    strTemp = String.Concat(New String() { "CompanyName Changed to '", Me._CompanyName, "' from '", obj.CompanyName, "'" })
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
                If (obj.Email <> Me._Email) Then
                    Me.UpdateEmail(Me._Email, (cnn))
                    strTemp = String.Concat(New String() { "Email Changed to '", Me._Email, "' from '", obj.Email, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ResumeText <> Me._Resume) Then
                    Me.UpdateResume(Me._Resume, (cnn))
                    strTemp = String.Concat(New String() { "Resume Changed to '", Me._Resume, "' from '", obj.ResumeText, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.WebSite <> Me._WebSite) Then
                    Me.UpdateWebSite(Me._WebSite, (cnn))
                    strTemp = String.Concat(New String() { "WebSite Changed to '", Me._WebSite, "' from '", obj.WebSite, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Misc <> Me._Misc) Then
                    Me.UpdateMisc(Me._Misc, (cnn))
                    strTemp = String.Concat(New String() { "Misc Changed to '", Me._Misc, "' from '", obj.Misc, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ContactMonday <> Me._ContactMonday) Then
                    Me.UpdateContactMonday(Me._ContactMonday, (cnn))
                    strTemp = String.Concat(New String() { "ContactMonday Changed to '", Conversions.ToString(Me._ContactMonday), "' from '", Conversions.ToString(obj.ContactMonday), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ContactTuesday <> Me._ContactTuesday) Then
                    Me.UpdateContactTuesday(Me._ContactTuesday, (cnn))
                    strTemp = String.Concat(New String() { "ContactTuesday Changed to '", Conversions.ToString(Me._ContactTuesday), "' from '", Conversions.ToString(obj.ContactTuesday), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ContactWednesday <> Me._ContactWednesday) Then
                    Me.UpdateContactWednesday(Me._ContactWednesday, (cnn))
                    strTemp = String.Concat(New String() { "ContactWednesday Changed to '", Conversions.ToString(Me._ContactWednesday), "' from '", Conversions.ToString(obj.ContactWednesday), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ContactThursday <> Me._ContactThursday) Then
                    Me.UpdateContactThursday(Me._ContactThursday, (cnn))
                    strTemp = String.Concat(New String() { "ContactThursday Changed to '", Conversions.ToString(Me._ContactThursday), "' from '", Conversions.ToString(obj.ContactThursday), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ContactFriday <> Me._ContactFriday) Then
                    Me.UpdateContactFriday(Me._ContactFriday, (cnn))
                    strTemp = String.Concat(New String() { "ContactFriday Changed to '", Conversions.ToString(Me._ContactFriday), "' from '", Conversions.ToString(obj.ContactFriday), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ContactSaturday <> Me._ContactSaturday) Then
                    Me.UpdateContactSaturday(Me._ContactSaturday, (cnn))
                    strTemp = String.Concat(New String() { "ContactSaturday Changed to '", Conversions.ToString(Me._ContactSaturday), "' from '", Conversions.ToString(obj.ContactSaturday), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ContactSunday <> Me._ContactSunday) Then
                    Me.UpdateContactSunday(Me._ContactSunday, (cnn))
                    strTemp = String.Concat(New String() { "ContactSunday Changed to '", Conversions.ToString(Me._ContactSunday), "' from '", Conversions.ToString(obj.ContactSunday), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ContactStart <> Me._ContactStart) Then
                    Me.UpdateContactStart(Me._ContactStart, (cnn))
                    strTemp = String.Concat(New String() { "ContactStart Changed to '", Conversions.ToString(Me._ContactStart), "' from '", Conversions.ToString(obj.ContactStart), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ContactEnd <> Me._ContactEnd) Then
                    Me.UpdateContactEnd(Me._ContactEnd, (cnn))
                    strTemp = String.Concat(New String() { "ContactEnd Changed to '", Conversions.ToString(Me._ContactEnd), "' from '", Conversions.ToString(obj.ContactEnd), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ReferrerID <> Me._ReferrerID) Then
                    Me.UpdateReferrerID(Me._ReferrerID, (cnn))
                    strTemp = String.Concat(New String() { "ReferrerID Changed to '", Conversions.ToString(Me._ReferrerID), "' from '", Conversions.ToString(obj.ReferrerID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ReferrerOther <> Me._ReferrerOther) Then
                    Me.UpdateReferrerOther(Me._ReferrerOther, (cnn))
                    strTemp = String.Concat(New String() { "ReferrerOther Changed to '", Me._ReferrerOther, "' from '", obj.ReferrerOther, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.IPAddress <> Me._IPAddress) Then
                    Me.UpdateIPAddress(Me._IPAddress, (cnn))
                    strTemp = String.Concat(New String() { "IPAddress Changed to '", Me._IPAddress, "' from '", obj.IPAddress, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.EIN <> Me._EIN) Then
                    Me.UpdateEIN(Me._EIN, (cnn))
                    strTemp = String.Concat(New String() { "EIN Changed to '", Me._EIN, "' from '", obj.EIN, "'" })
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
                If (obj.DLStateID <> Me._DLStateID) Then
                    Me.UpdateDLStateID(Me._DLStateID, (cnn))
                    strTemp = String.Concat(New String() { "DLStateID Changed to '", Conversions.ToString(Me._DLStateID), "' from '", Conversions.ToString(obj.DLStateID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.EmergencyFirstName <> Me._EmergencyFirstName) Then
                    Me.UpdateEmergencyFirstName(Me._EmergencyFirstName, (cnn))
                    strTemp = String.Concat(New String() { "EmergencyFirstName Changed to '", Me._EmergencyFirstName, "' from '", obj.EmergencyFirstName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.EmergencyMiddleName <> Me._EmergencyMiddleName) Then
                    Me.UpdateEmergencyMiddleName(Me._EmergencyMiddleName, (cnn))
                    strTemp = String.Concat(New String() { "EmergencyMiddleName Changed to '", Me._EmergencyMiddleName, "' from '", obj.EmergencyMiddleName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.EmergencyLastName <> Me._EmergencyLastName) Then
                    Me.UpdateEmergencyLastName(Me._EmergencyLastName, (cnn))
                    strTemp = String.Concat(New String() { "EmergencyLastName Changed to '", Me._EmergencyLastName, "' from '", obj.EmergencyLastName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.EmergencyCountryCode <> Me._EmergencyCountryCode) Then
                    Me.UpdateEmergencyCountryCode(Me._EmergencyCountryCode, (cnn))
                    strTemp = String.Concat(New String() { "EmergencyCountryCode Changed to '", Me._EmergencyCountryCode, "' from '", obj.EmergencyCountryCode, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.EmergencyAreaCode <> Me._EmergencyAreaCode) Then
                    Me.UpdateEmergencyAreaCode(Me._EmergencyAreaCode, (cnn))
                    strTemp = String.Concat(New String() { "EmergencyAreaCode Changed to '", Me._EmergencyAreaCode, "' from '", obj.EmergencyAreaCode, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.EmergencyExchange <> Me._EmergencyExchange) Then
                    Me.UpdateEmergencyExchange(Me._EmergencyExchange, (cnn))
                    strTemp = String.Concat(New String() { "EmergencyExchange Changed to '", Me._EmergencyExchange, "' from '", obj.EmergencyExchange, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.SignatureFileID <> Me._SignatureFileID) Then
                    Me.UpdateSignatureFileID(Me._SignatureFileID, (cnn))
                    strTemp = String.Concat(New String() { "SignatureFileID Changed to '", Conversions.ToString(Me._SignatureFileID), "' from '", Conversions.ToString(obj.SignatureFileID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.EmergencyLineNumber <> Me._EmergencyLineNumber) Then
                    Me.UpdateEmergencyLineNumber(Me._EmergencyLineNumber, (cnn))
                    strTemp = String.Concat(New String() { "EmergencyLineNumber Changed to '", Me._EmergencyLineNumber, "' from '", obj.EmergencyLineNumber, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.BlankSignatureFileID <> Me._BlankSignatureFileID) Then
                    Me.UpdateBlankSignatureFileID(Me._BlankSignatureFileID, (cnn))
                    strTemp = String.Concat(New String() { "BlankSignatureFileID Changed to '", Conversions.ToString(Me._BlankSignatureFileID), "' from '", Conversions.ToString(obj.BlankSignatureFileID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ContractCode <> Me._ContractCode) Then
                    Me.UpdateContractCode(Me._ContractCode, (cnn))
                    strTemp = String.Concat(New String() { "ContractCode Changed to '", Me._ContractCode, "' from '", obj.ContractCode, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.NDACode <> Me._NDACode) Then
                    Me.UpdateNDACode(Me._NDACode, (cnn))
                    strTemp = String.Concat(New String() { "NDACode Changed to '", Me._NDACode, "' from '", obj.NDACode, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.WaiverCode <> Me._WaiverCode) Then
                    Me.UpdateWaiverCode(Me._WaiverCode, (cnn))
                    strTemp = String.Concat(New String() { "WaiverCode Changed to '", Me._WaiverCode, "' from '", obj.WaiverCode, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (DateTime.Compare(obj.ContractSignatureDate, Me._ContractSignatureDate) <> 0) Then
                    Me.UpdateContractSignatureDate((Me._ContractSignatureDate), (cnn))
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (DateTime.Compare(obj.WaiverSignatureDate, Me._WaiverSignatureDate) <> 0) Then
                    Me.UpdateWaiverSignatureDate((Me._WaiverSignatureDate), (cnn))
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (DateTime.Compare(obj.NDASignatureDate, Me._NDASignatureDate) <> 0) Then
                    Me.UpdateNDASignatureDate((Me._NDASignatureDate), (cnn))
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ResumeTypeID <> Me._ResumeTypeID) Then
                    Me.UpdateResumeTypeID(Me._ResumeTypeID, (cnn))
                    strTemp = String.Concat(New String() { "ResumeTypeID Changed to '", Conversions.ToString(Me._ResumeTypeID), "' from '", Conversions.ToString(obj.ResumeTypeID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If obj.UserID <> _UserID Then
                    UpdateUserID(_UserID, cnn)
                    strTemp = "UserID Changed to '" & _UserID & "' from '" & obj.UserID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.InfoID <> Me._InfoID Then
                    UpdateInfoID(Me._InfoID, cnn)
                    strTemp = "InfoID Changed to '" & Me._InfoID & "' from '" & obj.InfoID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close
                Me.Load(Me._ResumeID)
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

        Private Sub UpdateBlankContractFileID(ByVal NewBlankContractFileID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeBlankContractFileID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewBlankContractFileID > 0) Then
                cmd.Parameters.Add("@BlankContractFileID", SqlDbType.Int).Value = NewBlankContractFileID
            Else
                cmd.Parameters.Add("@BlankContractFileID", SqlDbType.Int).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateBlankNDAFileID(ByVal NewBlankNDAFileID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeBlankNDAFileID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewBlankNDAFileID > 0) Then
                cmd.Parameters.Add("@BlankNDAFileID", SqlDbType.Int).Value = NewBlankNDAFileID
            Else
                cmd.Parameters.Add("@BlankNDAFileID", SqlDbType.Int).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateBlankSignatureFileID(ByVal NewBlankSignatureFileID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeBlankSignatureFileID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewBlankSignatureFileID > 0) Then
                cmd.Parameters.Add("@BlankSignatureFileID", SqlDbType.Int).Value = NewBlankSignatureFileID
            Else
                cmd.Parameters.Add("@BlankSignatureFileID", SqlDbType.Int).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateBlankWaiverFileID(ByVal NewBlankWaiverFileID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeBlankWaiverFileID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewBlankWaiverFileID > 0) Then
                cmd.Parameters.Add("@BlankWaiverFileID", SqlDbType.Int).Value = NewBlankWaiverFileID
            Else
                cmd.Parameters.Add("@BlankWaiverFileID", SqlDbType.Int).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateBusinessStartedMonthID(ByVal NewBusinessStartedMonthID As Integer, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeBusinessStartedMonthID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewBusinessStartedMonthID > 0) Then
                cmd.Parameters.Add("@BusinessStartedMonthID", SqlDbType.TinyInt).Value = NewBusinessStartedMonthID
            Else
                cmd.Parameters.Add("@BusinessStartedMonthID", SqlDbType.TinyInt).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateBusinessStartedYear(ByVal NewBusinessStartedYear As Integer, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeBusinessStartedYear")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            cmd.Parameters.Add("@BusinessStartedYear", SqlDbType.SmallInt).Value = NewBusinessStartedYear
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCompanyName(ByVal NewCompanyName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeCompanyName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewCompanyName.Trim.Length > 0) Then
                cmd.Parameters.Add("@CompanyName", SqlDbType.VarChar, Me.TrimTrunc(NewCompanyName, &H80).Length).Value = Me.TrimTrunc(NewCompanyName, &H80)
            Else
                cmd.Parameters.Add("@CompanyName", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateConfidenceLevel(ByVal NewConfidenceLevel As Integer, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeConfidenceLevel")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            cmd.Parameters.Add("@ConfidenceLevel", SqlDbType.SmallInt).Value = NewConfidenceLevel
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateContactEnd(ByVal NewContactEnd As Integer, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeContactEnd")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            cmd.Parameters.Add("@ContactEnd", SqlDbType.TinyInt).Value = NewContactEnd
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateContactFriday(ByVal NewContactFriday As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeContactFriday")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            cmd.Parameters.Add("@ContactFriday", SqlDbType.Bit).Value = NewContactFriday
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateContactMonday(ByVal NewContactMonday As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeContactMonday")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            cmd.Parameters.Add("@ContactMonday", SqlDbType.Bit).Value = NewContactMonday
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateContactSaturday(ByVal NewContactSaturday As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeContactSaturday")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            cmd.Parameters.Add("@ContactSaturday", SqlDbType.Bit).Value = NewContactSaturday
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateContactStart(ByVal NewContactStart As Integer, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeContactStart")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            cmd.Parameters.Add("@ContactStart", SqlDbType.TinyInt).Value = NewContactStart
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateContactSunday(ByVal NewContactSunday As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeContactSunday")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            cmd.Parameters.Add("@ContactSunday", SqlDbType.Bit).Value = NewContactSunday
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateContactThursday(ByVal NewContactThursday As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeContactThursday")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            cmd.Parameters.Add("@ContactThursday", SqlDbType.Bit).Value = NewContactThursday
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateContactTuesday(ByVal NewContactTuesday As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeContactTuesday")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            cmd.Parameters.Add("@ContactTuesday", SqlDbType.Bit).Value = NewContactTuesday
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateContactWednesday(ByVal NewContactWednesday As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeContactWednesday")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            cmd.Parameters.Add("@ContactWednesday", SqlDbType.Bit).Value = NewContactWednesday
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateContractCode(ByVal NewContractCode As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeContractCode")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewContractCode.Trim.Length > 0) Then
                cmd.Parameters.Add("@ContractCode", SqlDbType.VarChar, Me.TrimTrunc(NewContractCode, 8).Length).Value = Me.TrimTrunc(NewContractCode, 8)
            Else
                cmd.Parameters.Add("@ContractCode", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateContractSignatureDate(ByRef NewContractSignatureDate As DateTime, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeContractSignatureDate")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            Dim datNothing As New DateTime
            If (DateTime.Compare(Me.ContractSignatureDate, datNothing) <> 0) Then
                cmd.Parameters.Add("@ContractSignatureDate", SqlDbType.DateTime).Value = CDate(NewContractSignatureDate)
            Else
                cmd.Parameters.Add("@ContractSignatureDate", SqlDbType.DateTime).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateDeclined(ByVal NewDeclined As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeDeclined")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            cmd.Parameters.Add("@Declined", SqlDbType.Bit).Value = NewDeclined
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateDLFileID(ByVal NewDLFileID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeDLFileID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewDLFileID > 0) Then
                cmd.Parameters.Add("@DLFileID", SqlDbType.Int).Value = NewDLFileID
            Else
                cmd.Parameters.Add("@DLFileID", SqlDbType.Int).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateDLNumber(ByVal NewDLNumber As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeDLNumber")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewDLNumber.Trim.Length > 0) Then
                cmd.Parameters.Add("@DLNumber", SqlDbType.VarChar, NewDLNumber.Length).Value = NewDLNumber
            Else
                cmd.Parameters.Add("@DLNumber", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateDLStateID(ByVal NewDLStateID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeDLStateID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewDLStateID > 0) Then
                cmd.Parameters.Add("@DLStateID", SqlDbType.Int).Value = NewDLStateID
            Else
                cmd.Parameters.Add("@DLStateID", SqlDbType.Int).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateDocumentsApproved(ByVal NewDocumentsApproved As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeDocumentsApproved")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            cmd.Parameters.Add("@DocumentsApproved", SqlDbType.Bit).Value = NewDocumentsApproved
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateEIN(ByVal NewEIN As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeEIN")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewEIN.Trim.Length > 0) Then
                cmd.Parameters.Add("@EIN", SqlDbType.VarChar, NewEIN.Length).Value = NewEIN
            Else
                cmd.Parameters.Add("@EIN", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateEmail(ByVal NewEmail As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeEmail")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            cmd.Parameters.Add("@Email", SqlDbType.VarChar, Me.TrimTrunc(NewEmail, &HFF).Length).Value = Me.TrimTrunc(NewEmail, &HFF)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateEmergencyAreaCode(ByVal NewEmergencyAreaCode As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeEmergencyAreaCode")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewEmergencyAreaCode.Trim.Length > 0) Then
                cmd.Parameters.Add("@EmergencyAreaCode", SqlDbType.VarChar, Me.TrimTrunc(NewEmergencyAreaCode, 3).Length).Value = Me.TrimTrunc(NewEmergencyAreaCode, 3)
            Else
                cmd.Parameters.Add("@EmergencyAreaCode", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateEmergencyCountryCode(ByVal NewEmergencyCountryCode As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeEmergencyCountryCode")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewEmergencyCountryCode.Trim.Length > 0) Then
                cmd.Parameters.Add("@EmergencyCountryCode", SqlDbType.VarChar, Me.TrimTrunc(NewEmergencyCountryCode, 8).Length).Value = Me.TrimTrunc(NewEmergencyCountryCode, 8)
            Else
                cmd.Parameters.Add("@EmergencyCountryCode", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateEmergencyExchange(ByVal NewEmergencyExchange As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeEmergencyExchange")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewEmergencyExchange.Trim.Length > 0) Then
                cmd.Parameters.Add("@EmergencyExchange", SqlDbType.VarChar, Me.TrimTrunc(NewEmergencyExchange, 3).Length).Value = Me.TrimTrunc(NewEmergencyExchange, 3)
            Else
                cmd.Parameters.Add("@EmergencyExchange", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateEmergencyFirstName(ByVal NewEmergencyFirstName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeEmergencyFirstName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewEmergencyFirstName.Trim.Length > 0) Then
                cmd.Parameters.Add("@EmergencyFirstName", SqlDbType.VarChar, Me.TrimTrunc(NewEmergencyFirstName, &H20).Length).Value = Me.TrimTrunc(NewEmergencyFirstName, &H20)
            Else
                cmd.Parameters.Add("@EmergencyFirstName", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateEmergencyLastName(ByVal NewEmergencyLastName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeEmergencyLastName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewEmergencyLastName.Trim.Length > 0) Then
                cmd.Parameters.Add("@EmergencyLastName", SqlDbType.VarChar, Me.TrimTrunc(NewEmergencyLastName, &H40).Length).Value = Me.TrimTrunc(NewEmergencyLastName, &H40)
            Else
                cmd.Parameters.Add("@EmergencyLastName", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateEmergencyLineNumber(ByVal NewEmergencyLineNumber As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeEmergencyLineNumber")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewEmergencyLineNumber.Trim.Length > 0) Then
                cmd.Parameters.Add("@EmergencyLineNumber", SqlDbType.VarChar, Me.TrimTrunc(NewEmergencyLineNumber, 4).Length).Value = Me.TrimTrunc(NewEmergencyLineNumber, 4)
            Else
                cmd.Parameters.Add("@EmergencyLineNumber", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateEmergencyMiddleName(ByVal NewEmergencyMiddleName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeEmergencyMiddleName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewEmergencyMiddleName.Trim.Length > 0) Then
                cmd.Parameters.Add("@EmergencyMiddleName", SqlDbType.VarChar, Me.TrimTrunc(NewEmergencyMiddleName, &H20).Length).Value = Me.TrimTrunc(NewEmergencyMiddleName, &H20)
            Else
                cmd.Parameters.Add("@EmergencyMiddleName", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateEntityTypeID(ByVal NewEntityTypeID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeEntityTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            cmd.Parameters.Add("@EntityTypeID", SqlDbType.Int).Value = NewEntityTypeID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateFirstName(ByVal NewFirstName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeFirstName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            cmd.Parameters.Add("@FirstName", SqlDbType.VarChar, Me.TrimTrunc(NewFirstName, &H20).Length).Value = Me.TrimTrunc(NewFirstName, &H20)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateIPAddress(ByVal NewIPAddress As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeIPAddress")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewIPAddress.Trim.Length > 0) Then
                cmd.Parameters.Add("@IPAddress", SqlDbType.VarChar, Me.TrimTrunc(NewIPAddress, &H20).Length).Value = Me.TrimTrunc(NewIPAddress, &H20)
            Else
                cmd.Parameters.Add("@IPAddress", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateLastName(ByVal NewLastName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeLastName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            cmd.Parameters.Add("@LastName", SqlDbType.VarChar, Me.TrimTrunc(NewLastName, &H40).Length).Value = Me.TrimTrunc(NewLastName, &H40)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateMiddleName(ByVal NewMiddleName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeMiddleName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewMiddleName.Trim.Length > 0) Then
                cmd.Parameters.Add("@MiddleName", SqlDbType.VarChar, Me.TrimTrunc(NewMiddleName, &H20).Length).Value = Me.TrimTrunc(NewMiddleName, &H20)
            Else
                cmd.Parameters.Add("@MiddleName", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateMisc(ByVal NewMisc As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeMisc")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewMisc.Trim.Length > 0) Then
                cmd.Parameters.Add("@Misc", SqlDbType.Text).Value = NewMisc
            Else
                cmd.Parameters.Add("@Misc", SqlDbType.Text).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateNDACode(ByVal NewNDACode As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeNDACode")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewNDACode.Trim.Length > 0) Then
                cmd.Parameters.Add("@NDACode", SqlDbType.VarChar, Me.TrimTrunc(NewNDACode, 8).Length).Value = Me.TrimTrunc(NewNDACode, 8)
            Else
                cmd.Parameters.Add("@NDACode", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateNDASignatureDate(ByRef NewNDASignatureDate As DateTime, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeNDASignatureDate")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (DateTime.Compare(New DateTime, NewNDASignatureDate) <> 0) Then
                cmd.Parameters.Add("@NDASignatureDate", SqlDbType.DateTime).Value = CDate(NewNDASignatureDate)
            Else
                cmd.Parameters.Add("@NDASignatureDate", SqlDbType.DateTime).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateReferrerID(ByVal NewReferrerID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeReferrerID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewReferrerID > 0) Then
                cmd.Parameters.Add("@ReferrerID", SqlDbType.Int).Value = NewReferrerID
            Else
                cmd.Parameters.Add("@ReferrerID", SqlDbType.Int).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateReferrerOther(ByVal NewReferrerOther As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeReferrerOther")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewReferrerOther.Trim.Length > 0) Then
                cmd.Parameters.Add("@ReferrerOther", SqlDbType.VarChar, Me.TrimTrunc(NewReferrerOther, &H20).Length).Value = Me.TrimTrunc(NewReferrerOther, &H20)
            Else
                cmd.Parameters.Add("@ReferrerOther", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateResume(ByVal NewResume As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeResume")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            cmd.Parameters.Add("@Resume", SqlDbType.Text).Value = NewResume
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateResumeTypeID(ByVal NewResumeTypeID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeResumeTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewResumeTypeID > 0) Then
                cmd.Parameters.Add("@ResumeTypeID", SqlDbType.Int).Value = NewResumeTypeID
            Else
                cmd.Parameters.Add("@ResumeTypeID", SqlDbType.Int).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateSignatureFileID(ByVal NewSignatureFileID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeSignatureFileID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewSignatureFileID > 0) Then
                cmd.Parameters.Add("@SignatureFileID", SqlDbType.Int).Value = NewSignatureFileID
            Else
                cmd.Parameters.Add("@SignatureFileID", SqlDbType.Int).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateSignedContractFileID(ByVal NewSignedContractFileID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeSignedContractFileID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewSignedContractFileID > 0) Then
                cmd.Parameters.Add("@SignedContractFileID", SqlDbType.Int).Value = NewSignedContractFileID
            Else
                cmd.Parameters.Add("@SignedContractFileID", SqlDbType.Int).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateSignedNDAFileID(ByVal NewSignedNDAFileID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeSignedNDAFileID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewSignedNDAFileID > 0) Then
                cmd.Parameters.Add("@SignedNDAFileID", SqlDbType.Int).Value = NewSignedNDAFileID
            Else
                cmd.Parameters.Add("@SignedNDAFileID", SqlDbType.Int).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateSignedWaiverFileID(ByVal NewSignedWaiverFileID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeSignedWaiverFileID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewSignedWaiverFileID > 0) Then
                cmd.Parameters.Add("@SignedWaiverFileID", SqlDbType.Int).Value = NewSignedWaiverFileID
            Else
                cmd.Parameters.Add("@SignedWaiverFileID", SqlDbType.Int).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateSSN(ByVal NewSSN As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeSSN")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewSSN.Trim.Length > 0) Then
                cmd.Parameters.Add("@SSN", SqlDbType.VarChar, NewSSN.Length).Value = NewSSN
            Else
                cmd.Parameters.Add("@SSN", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateWaiverCode(ByVal NewWaiverCode As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeWaiverCode")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewWaiverCode.Trim.Length > 0) Then
                cmd.Parameters.Add("@WaiverCode", SqlDbType.VarChar, Me.TrimTrunc(NewWaiverCode, 8).Length).Value = Me.TrimTrunc(NewWaiverCode, 8)
            Else
                cmd.Parameters.Add("@WaiverCode", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateWaiverSignatureDate(ByRef NewWaiverSignatureDate As DateTime, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeWaiverSignatureDate")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (DateTime.Compare(New DateTime, NewWaiverSignatureDate) <> 0) Then
                cmd.Parameters.Add("@WaiverSignatureDate", SqlDbType.DateTime).Value = CDate(NewWaiverSignatureDate)
            Else
                cmd.Parameters.Add("@WaiverSignatureDate", SqlDbType.DateTime).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateWebLoginID(ByVal NewWebLoginID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeWebLoginID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewWebLoginID > 0) Then
                cmd.Parameters.Add("@WebLoginID", SqlDbType.Int).Value = NewWebLoginID
            Else
                cmd.Parameters.Add("@WebLoginID", SqlDbType.Int).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateWebSite(ByVal NewWebSite As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeWebSite")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            If (NewWebSite.Trim.Length > 0) Then
                cmd.Parameters.Add("@WebSite", SqlDbType.VarChar, Me.TrimTrunc(NewWebSite, &HFF).Length).Value = Me.TrimTrunc(NewWebSite, &HFF)
            Else
                cmd.Parameters.Add("@WebSite", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateUserID(ByVal NewUserID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeUserID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = NewUserID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateInfoID(ByVal NewInfoID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeInfoID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = Me._ResumeID
            cmd.Parameters.Add("@InfoID", SqlDbType.Int).Value = NewInfoID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        ' Properties
        Public Property BlankContractFileID As Long
            Get
                Return Me._BlankContractFileID
            End Get
            Set(ByVal value As Long)
                Me._BlankContractFileID = value
            End Set
        End Property

        Public Property BlankNDAFileID As Long
            Get
                Return Me._BlankNDAFileID
            End Get
            Set(ByVal value As Long)
                Me._BlankNDAFileID = value
            End Set
        End Property

        Public Property BlankSignatureFileID As Long
            Get
                Return Me._BlankSignatureFileID
            End Get
            Set(ByVal value As Long)
                Me._BlankSignatureFileID = value
            End Set
        End Property

        Public Property BlankWaiverFileID As Long
            Get
                Return Me._BlankWaiverFileID
            End Get
            Set(ByVal value As Long)
                Me._BlankWaiverFileID = value
            End Set
        End Property

        Public Property BusinessStartedMonthID As Integer
            Get
                Return Me._BusinessStartedMonthID
            End Get
            Set(ByVal value As Integer)
                Me._BusinessStartedMonthID = value
            End Set
        End Property

        Public Property BusinessStartedYear As Integer
            Get
                Return Me._BusinessStartedYear
            End Get
            Set(ByVal value As Integer)
                Me._BusinessStartedYear = value
            End Set
        End Property

        Public Property CompanyName As String
            Get
                Return Me._CompanyName
            End Get
            Set(ByVal value As String)
                Me._CompanyName = Me.TrimTrunc(value, &H80)
            End Set
        End Property

        Public Property ConfidenceLevel As Integer
            Get
                Return Me._ConfidenceLevel
            End Get
            Set(ByVal value As Integer)
                Me._ConfidenceLevel = value
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

        Public Property ContactEnd As Integer
            Get
                Return Me._ContactEnd
            End Get
            Set(ByVal value As Integer)
                Me._ContactEnd = value
            End Set
        End Property

        Public Property ContactFriday As Boolean
            Get
                Return Me._ContactFriday
            End Get
            Set(ByVal value As Boolean)
                Me._ContactFriday = value
            End Set
        End Property

        Public Property ContactMonday As Boolean
            Get
                Return Me._ContactMonday
            End Get
            Set(ByVal value As Boolean)
                Me._ContactMonday = value
            End Set
        End Property

        Public Property ContactSaturday As Boolean
            Get
                Return Me._ContactSaturday
            End Get
            Set(ByVal value As Boolean)
                Me._ContactSaturday = value
            End Set
        End Property

        Public Property ContactStart As Integer
            Get
                Return Me._ContactStart
            End Get
            Set(ByVal value As Integer)
                Me._ContactStart = value
            End Set
        End Property

        Public Property ContactSunday As Boolean
            Get
                Return Me._ContactSunday
            End Get
            Set(ByVal value As Boolean)
                Me._ContactSunday = value
            End Set
        End Property

        Public Property ContactThursday As Boolean
            Get
                Return Me._ContactThursday
            End Get
            Set(ByVal value As Boolean)
                Me._ContactThursday = value
            End Set
        End Property

        Public Property ContactTuesday As Boolean
            Get
                Return Me._ContactTuesday
            End Get
            Set(ByVal value As Boolean)
                Me._ContactTuesday = value
            End Set
        End Property

        Public Property ContactWednesday As Boolean
            Get
                Return Me._ContactWednesday
            End Get
            Set(ByVal value As Boolean)
                Me._ContactWednesday = value
            End Set
        End Property

        Public Property ContractCode As String
            Get
                Return Me._ContractCode
            End Get
            Set(ByVal value As String)
                Me._ContractCode = Me.TrimTrunc(value, 8)
            End Set
        End Property

        Public Property ContractSignatureDate As DateTime
            Get
                Return Me._ContractSignatureDate
            End Get
            Set(ByVal value As DateTime)
                Me._ContractSignatureDate = value
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

        Public Property Declined As Boolean
            Get
                Return Me._Declined
            End Get
            Set(ByVal value As Boolean)
                Me._Declined = value
            End Set
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
                Me._DLNumber = value
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

        Public Property DocumentsApproved As Boolean
            Get
                Return Me._DocumentsApproved
            End Get
            Set(ByVal value As Boolean)
                Me._DocumentsApproved = value
            End Set
        End Property

        Public Property EIN As String
            Get
                Return Me._EIN
            End Get
            Set(ByVal value As String)
                Me._EIN = value
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

        Public Property EmergencyAreaCode As String
            Get
                Return Me._EmergencyAreaCode
            End Get
            Set(ByVal value As String)
                Me._EmergencyAreaCode = Me.TrimTrunc(value, 3)
            End Set
        End Property

        Public Property EmergencyCountryCode As String
            Get
                Return Me._EmergencyCountryCode
            End Get
            Set(ByVal value As String)
                Me._EmergencyCountryCode = Me.TrimTrunc(value, 8)
            End Set
        End Property

        Public Property EmergencyExchange As String
            Get
                Return Me._EmergencyExchange
            End Get
            Set(ByVal value As String)
                Me._EmergencyExchange = Me.TrimTrunc(value, 3)
            End Set
        End Property

        Public Property EmergencyFirstName As String
            Get
                Return Me._EmergencyFirstName
            End Get
            Set(ByVal value As String)
                Me._EmergencyFirstName = Me.TrimTrunc(value, &H20)
            End Set
        End Property

        Public Property EmergencyLastName As String
            Get
                Return Me._EmergencyLastName
            End Get
            Set(ByVal value As String)
                Me._EmergencyLastName = Me.TrimTrunc(value, &H40)
            End Set
        End Property

        Public Property EmergencyLineNumber As String
            Get
                Return Me._EmergencyLineNumber
            End Get
            Set(ByVal value As String)
                Me._EmergencyLineNumber = Me.TrimTrunc(value, 4)
            End Set
        End Property

        Public Property EmergencyMiddleName As String
            Get
                Return Me._EmergencyMiddleName
            End Get
            Set(ByVal value As String)
                Me._EmergencyMiddleName = Me.TrimTrunc(value, &H20)
            End Set
        End Property

        Public Property EntityTypeID As Long
            Get
                Return Me._EntityTypeID
            End Get
            Set(ByVal value As Long)
                Me._EntityTypeID = value
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

        Public Property IPAddress As String
            Get
                Return Me._IPAddress
            End Get
            Set(ByVal value As String)
                Me._IPAddress = Me.TrimTrunc(value, &H20)
            End Set
        End Property

        Public Property LastName As String
            Get
                Return Me._LastName
            End Get
            Set(ByVal value As String)
                Me._LastName = Me.TrimTrunc(value, &H40)
            End Set
        End Property

        Public ReadOnly Property LocalTime As DateTime
            Get
                Return Me.GetLocalTime
            End Get
        End Property

        Public Property MiddleName As String
            Get
                Return Me._MiddleName
            End Get
            Set(ByVal value As String)
                Me._MiddleName = Me.TrimTrunc(value, &H20)
            End Set
        End Property

        Public Property Misc As String
            Get
                Return Me._Misc
            End Get
            Set(ByVal value As String)
                Me._Misc = value
            End Set
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public ReadOnly Property NameTag As String
            Get
                Return Me.MakeNameTag
            End Get
        End Property

        Public Property NDACode As String
            Get
                Return Me._NDACode
            End Get
            Set(ByVal value As String)
                Me._NDACode = Me.TrimTrunc(value, 8)
            End Set
        End Property

        Public Property NDASignatureDate As DateTime
            Get
                Return Me._NDASignatureDate
            End Get
            Set(ByVal value As DateTime)
                Me._NDASignatureDate = value
            End Set
        End Property

        Public Property ReferrerID As Long
            Get
                Return Me._ReferrerID
            End Get
            Set(ByVal value As Long)
                Me._ReferrerID = value
            End Set
        End Property

        Public Property ReferrerOther As String
            Get
                Return Me._ReferrerOther
            End Get
            Set(ByVal value As String)
                Me._ReferrerOther = Me.TrimTrunc(value, &H20)
            End Set
        End Property

        Public ReadOnly Property ResumeID As Long
            Get
                Return Me._ResumeID
            End Get
        End Property

        Public Property ResumeText As String
            Get
                Return Me._Resume
            End Get
            Set(ByVal value As String)
                Me._Resume = value
            End Set
        End Property

        Public Property ResumeTypeID As Long
            Get
                Return Me._ResumeTypeID
            End Get
            Set(ByVal value As Long)
                Me._ResumeTypeID = value
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

        Public Property SignedContractFileID As Long
            Get
                Return Me._SignedContractFileID
            End Get
            Set(ByVal value As Long)
                Me._SignedContractFileID = value
            End Set
        End Property

        Public Property SignedNDAFileID As Long
            Get
                Return Me._SignedNDAFileID
            End Get
            Set(ByVal value As Long)
                Me._SignedNDAFileID = value
            End Set
        End Property

        Public Property SignedWaiverFileID As Long
            Get
                Return Me._SignedWaiverFileID
            End Get
            Set(ByVal value As Long)
                Me._SignedWaiverFileID = value
            End Set
        End Property

        Public Property SSN As String
            Get
                Return Me._SSN
            End Get
            Set(ByVal value As String)
                Me._SSN = value
            End Set
        End Property

        Public Property WaiverCode As String
            Get
                Return Me._WaiverCode
            End Get
            Set(ByVal value As String)
                Me._WaiverCode = Me.TrimTrunc(value, 8)
            End Set
        End Property

        Public Property WaiverSignatureDate As DateTime
            Get
                Return Me._WaiverSignatureDate
            End Get
            Set(ByVal value As DateTime)
                Me._WaiverSignatureDate = value
            End Set
        End Property

        Public Property WebLoginID As Long
            Get
                Return Me._WebLoginID
            End Get
            Set(ByVal value As Long)
                Me._WebLoginID = value
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
        Public Property UserID() As Long
            Get
                Return Me._UserID
            End Get
            Set(ByVal value As Long)
                Me._UserID = value
            End Set
        End Property
        Public Property InfoID() As Long
            Get
                Return Me._InfoID
            End Get
            Set(ByVal value As Long)
                Me._InfoID = value
            End Set
        End Property

        ' Fields
        Private _BlankContractFileID As Long
        Private _BlankNDAFileID As Long
        Private _BlankSignatureFileID As Long
        Private _BlankWaiverFileID As Long
        Private _BusinessStartedMonthID As Integer
        Private _BusinessStartedYear As Integer
        Private _CompanyName As String
        Private _ConfidenceLevel As Integer
        Private _ConnectionString As String
        Private _ContactEnd As Integer
        Private _ContactFriday As Boolean
        Private _ContactMonday As Boolean
        Private _ContactSaturday As Boolean
        Private _ContactStart As Integer
        Private _ContactSunday As Boolean
        Private _ContactThursday As Boolean
        Private _ContactTuesday As Boolean
        Private _ContactWednesday As Boolean
        Private _ContractCode As String
        Private _ContractSignatureDate As DateTime
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _Declined As Boolean
        Private _DLFileID As Long
        Private _DLNumber As String
        Private _DLStateID As Long
        Private _DocumentsApproved As Boolean
        Private _EIN As String
        Private _Email As String
        Private _EmergencyAreaCode As String
        Private _EmergencyCountryCode As String
        Private _EmergencyExchange As String
        Private _EmergencyFirstName As String
        Private _EmergencyLastName As String
        Private _EmergencyLineNumber As String
        Private _EmergencyMiddleName As String
        Private _EntityTypeID As Long
        Private _FirstName As String
        Private _IPAddress As String
        Private _LastName As String
        Private _MiddleName As String
        Private _Misc As String
        Private _NDACode As String
        Private _NDASignatureDate As DateTime
        Private _ReferrerID As Long
        Private _ReferrerOther As String
        Private _Resume As String
        Private _ResumeID As Long
        Private _ResumeTypeID As Long
        Private _SignatureFileID As Long
        Private _SignedContractFileID As Long
        Private _SignedNDAFileID As Long
        Private _SignedWaiverFileID As Long
        Private _SSN As String
        Private _WaiverCode As String
        Private _WaiverSignatureDate As DateTime
        Private _WebLoginID As Long
        Private _WebSite As String
        Private _UserID As Long
        Private _InfoID As Long
        Private Const CompanyNameMaxLength As Integer = &H80
        Private Const ContractCodeMaxLength As Integer = 8
        Private Const DLNumberMaxLength As Integer = &H40
        Private Const EINMaxLength As Integer = &H40
        Private Const EmailMaxLength As Integer = &HFF
        Private Const EmergencyAreaCodeMaxLength As Integer = 3
        Private Const EmergencyCountryCodeMaxLength As Integer = 8
        Private Const EmergencyExchangeMaxLength As Integer = 3
        Private Const EmergencyFirstNameMaxLength As Integer = &H20
        Private Const EmergencyLastNameMaxLength As Integer = &H40
        Private Const EmergencyLineNumberMaxLength As Integer = 4
        Private Const EmergencyMiddleNameMaxLength As Integer = &H20
        Private Const FirstNameMaxLength As Integer = &H20
        Private Const IPAddressMaxLength As Integer = &H20
        Private Const LastNameMaxLength As Integer = &H40
        Private Const MiddleNameMaxLength As Integer = &H20
        Private Const NDACodeMaxLength As Integer = 8
        Private Const ReferrerOtherMaxLength As Integer = &H20
        Private Const SSNMaxLength As Integer = &H40
        Private Const WaiverCodeMaxLength As Integer = 8
        Private Const WebSiteMaxLength As Integer = &HFF

        ' Nested Types
        Public Enum ResumeSystemFolders
            ' Fields
            AwaitingDocuments = 4
            'AwaitingDocuments = &H20
            Completed = 7
            Declined = 8
            InitialContact = 1
            InProcess = 1
            PartialApp = 2
            'PartialApp = &H1D
            PendingApproval = 5
            ReadyForContract = 3
            'ReadyForContract = &H1F
            'ReadyToImport = &H1B
            ReadyToImport = 6
            ResumeInBox = 0
        End Enum
    End Class
End Namespace

