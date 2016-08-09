Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class PartnerRecord
        ' Methods
        Public Sub New()
            Me._Email = ""
            Me._PartnerID = 0
            Me._CreatedBy = 0
            Me._ResumeID = 0
            Me._EntityTypeID = 0
            Me._BusinessStartedMonthID = 0
            Me._BusinessStartedYear = 0
            Me._BlankWaiverFileID = 0
            Me._BlankContractFileID = 0
            Me._BlankNDAFileID = 0
            Me._SignedWaiverFileID = 0
            Me._SignedContractFileID = 0
            Me._SignedNDAFileID = 0
            Me._UserID = 0
            Me._EIN = ""
            Me._CompanyName = ""
            Me._WebSite = ""
            Me._Active = True
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._OpenWorkOrderCount = 0
            Me._ClosedWorkOrderCount = 0
            Me._InfoID = 0
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._Email = ""
            Me._PartnerID = 0
            Me._CreatedBy = 0
            Me._ResumeID = 0
            Me._EntityTypeID = 0
            Me._BusinessStartedMonthID = 0
            Me._BusinessStartedYear = 0
            Me._BlankWaiverFileID = 0
            Me._BlankContractFileID = 0
            Me._BlankNDAFileID = 0
            Me._SignedWaiverFileID = 0
            Me._SignedContractFileID = 0
            Me._SignedNDAFileID = 0
            Me._UserID = 0
            Me._EIN = ""
            Me._CompanyName = ""
            Me._WebSite = ""
            Me._Active = True
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._OpenWorkOrderCount = 0
            Me._ClosedWorkOrderCount = 0
            Me._InfoID = 0
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngPartnerID As Long, ByVal strConnectionString As String)
            Me._Email = ""
            Me._PartnerID = 0
            Me._CreatedBy = 0
            Me._ResumeID = 0
            Me._EntityTypeID = 0
            Me._BusinessStartedMonthID = 0
            Me._BusinessStartedYear = 0
            Me._BlankWaiverFileID = 0
            Me._BlankContractFileID = 0
            Me._BlankNDAFileID = 0
            Me._SignedWaiverFileID = 0
            Me._SignedContractFileID = 0
            Me._SignedNDAFileID = 0
            Me._UserID = 0
            Me._EIN = ""
            Me._CompanyName = ""
            Me._WebSite = ""
            Me._Active = True
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._OpenWorkOrderCount = 0
            Me._ClosedWorkOrderCount = 0
            Me._InfoID = 0
            Me._ConnectionString = strConnectionString
            Me.Load(Me._PartnerID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal lngResumeID As Long, ByVal lngEntityTypeID As Long, ByVal lngBusinessStartedMonthID As Long, ByVal intBusinessStartedYear As Integer, ByVal lngBlankWaiverFileID As Long, ByVal lngBlankContractFileID As Long, ByVal lngBlankNDAFileID As Long, ByVal lngSignedWaiverFileID As Long, ByVal lngSignedContractFileID As Long, ByVal lngSignedNDAFileID As Long, ByVal strEIN As String, ByVal strCompanyName As String, ByVal blnActive As Boolean, ByVal datDateCreated As Date, ByVal lngUserID As Long, ByVal lngInfoID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddPartner")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngPartnerID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = lngResumeID
                cmd.Parameters.Add("@EntityTypeID", SqlDbType.Int).Value = lngEntityTypeID
                cmd.Parameters.Add("@BusinessStartedMonthID", SqlDbType.Int).Value = lngBusinessStartedMonthID
                cmd.Parameters.Add("@BusinessStartedYear", SqlDbType.Int).Value = intBusinessStartedYear
                cmd.Parameters.Add("@BlankWaiverFileID", SqlDbType.Int).Value = lngBlankWaiverFileID
                cmd.Parameters.Add("@BlankContractFileID", SqlDbType.Int).Value = lngBlankContractFileID
                cmd.Parameters.Add("@BlankNDAFileID", SqlDbType.Int).Value = lngBlankNDAFileID
                cmd.Parameters.Add("@SignedWaiverFileID", SqlDbType.Int).Value = lngSignedWaiverFileID
                cmd.Parameters.Add("@SignedContractFileID", SqlDbType.Int).Value = lngSignedContractFileID
                cmd.Parameters.Add("@SignedNDAFileID", SqlDbType.Int).Value = lngSignedNDAFileID
                cmd.Parameters.Add("@EIN", SqlDbType.VarChar, Me.TrimTrunc(strEIN, &H40).Length).Value = Me.TrimTrunc(strEIN, &H40)
                cmd.Parameters.Add("@CompanyName", SqlDbType.VarChar, Me.TrimTrunc(strCompanyName, &H80).Length).Value = Me.TrimTrunc(strCompanyName, &H80)
                cmd.Parameters.Add("@Active", SqlDbType.Bit).Value = blnActive
                cmd.Parameters.Add("@DateCreated", SqlDbType.DateTime).Value = datDateCreated
                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = lngUserID
                cmd.Parameters.Add("@InfoID", SqlDbType.Int).Value = lngInfoID
                cnn.Open()
                cmd.Connection = cnn
                lngPartnerID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close()
                If (lngPartnerID > 0) Then
                    Me.Load(lngPartnerID)
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
            Me._OpenWorkOrderCount = 0
            Me._ClosedWorkOrderCount = 0
            Me._PartnerID = 0
            Me._CreatedBy = 0
            Me._EntityTypeID = 0
            Me._BusinessStartedMonthID = 0
            Me._BusinessStartedYear = 0
            Me._BlankWaiverFileID = 0
            Me._BlankContractFileID = 0
            Me._BlankNDAFileID = 0
            Me._SignedWaiverFileID = 0
            Me._SignedContractFileID = 0
            Me._SignedNDAFileID = 0
            Me._UserID = 0
            Me._InfoID = 0
            Me._EIN = ""
            Me._CompanyName = ""
            Me._WebSite = ""
            Me._Active = True
            Me._Email = ""
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Deactivate()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spDeactivatePartner")
                cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = Me._PartnerID
                cmd.CommandType = CommandType.StoredProcedure
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
            End If
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemovePartner")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = Me._PartnerID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._PartnerID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New PartnerRecord(Me._PartnerID, Me._ConnectionString)
            obj.Load(Me._PartnerID)
            If (obj.Email <> Me._Email) Then
                blnReturn = True
            End If
            If (obj.EntityTypeID <> Me._EntityTypeID) Then
                blnReturn = True
            End If
            If (obj.BusinessStartedMonthID <> Me._BusinessStartedMonthID) Then
                blnReturn = True
            End If
            If (obj.BusinessStartedYear <> Me._BusinessStartedYear) Then
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
            If (obj.EIN <> Me._EIN) Then
                blnReturn = True
            End If
            If (obj.CompanyName <> Me._CompanyName) Then
                blnReturn = True
            End If
            If (obj.WebSite <> Me._WebSite) Then
                blnReturn = True
            End If
            If (obj.Active <> Me._Active) Then
                blnReturn = True
            End If
            If (obj.UserID <> Me._UserID) Then
                blnReturn = True
            End If
            If obj.InfoID <> Me._InfoID Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngPartnerID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetPartner")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = lngPartnerID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._PartnerID = Conversions.ToLong(dtr.Item("PartnerID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._ResumeID = Conversions.ToLong(dtr.Item("ResumeID"))
                    Me._EntityTypeID = Conversions.ToLong(dtr.Item("EntityTypeID"))
                    Me._BusinessStartedMonthID = Conversions.ToLong(dtr.Item("BusinessStartedMonthID"))
                    Me._BusinessStartedYear = Conversions.ToInteger(dtr.Item("BusinessStartedYear"))
                    Me._BlankWaiverFileID = Conversions.ToLong(dtr.Item("BlankWaiverFileID"))
                    Me._BlankContractFileID = Conversions.ToLong(dtr.Item("BlankContractFileID"))
                    Me._BlankNDAFileID = Conversions.ToLong(dtr.Item("BlankNDAFileID"))
                    Me._SignedWaiverFileID = Conversions.ToLong(dtr.Item("SignedWaiverFileID"))
                    Me._SignedContractFileID = Conversions.ToLong(dtr.Item("SignedContractFileID"))
                    Me._SignedNDAFileID = Conversions.ToLong(dtr.Item("SignedNDAFileID"))
                    Me._UserID = Conversions.ToLong(dtr.Item("UserID"))
                    Me._EIN = dtr.Item("EIN").ToString
                    Me._CompanyName = dtr.Item("CompanyName").ToString
                    Me._InfoID = Conversions.ToLong(dtr.Item("InfoID"))
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("WebSite"))) Then
                        Me._WebSite = dtr.Item("WebSite").ToString
                    Else
                        Me._WebSite = ""
                    End If
                    Me._Active = Conversions.ToBoolean(dtr.Item("Active"))
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Email"))) Then
                        Me._Email = dtr.Item("Email").ToString
                    Else
                        Me._Email = ""
                    End If
                    dtr.Close
                    cmd = New SqlCommand
                    cmd.Connection = cnn
                    cmd.CommandText = "spCountOpenWorkOrdersForPartner"
                    cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = Me._PartnerID
                    cmd.CommandType = CommandType.StoredProcedure
                    Me._OpenWorkOrderCount = Conversions.ToLong(cmd.ExecuteScalar)
                    cmd = New SqlCommand
                    cmd.Connection = cnn
                    cmd.CommandText = "spCountClosedWorkOrdersForPartner"
                    cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = Me._PartnerID
                    cmd.CommandType = CommandType.StoredProcedure
                    Me._ClosedWorkOrderCount = Conversions.ToLong(cmd.ExecuteScalar)
                Else
                    Me.ClearValues
                End If
                cnn.Close
            End If
        End Sub

        Public Sub LoadByResumeID(ByVal lngResumeID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetPartnerByResumeID")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = lngResumeID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me.Load(Conversions.ToLong(dtr.Item("PartnerID")))
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
                Dim obj As New PartnerRecord(Me._PartnerID, Me._ConnectionString)
                obj.Load(Me._PartnerID)
                If (obj.EntityTypeID <> Me._EntityTypeID) Then
                    Me.UpdateEntityTypeID(Me._EntityTypeID, (cnn))
                    strTemp = String.Concat(New String() { "EntityTypeID Changed to '", Conversions.ToString(Me._EntityTypeID), "' from '", Conversions.ToString(obj.EntityTypeID), "'" })
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
                If (obj.BlankWaiverFileID <> Me._BlankWaiverFileID) Then
                    Me.UpdateBlankWaiverFileID(Me._BlankWaiverFileID, (cnn))
                    strTemp = String.Concat(New String() { "BlankWaiverFileID Changed to '", Conversions.ToString(Me._BlankWaiverFileID), "' from '", Conversions.ToString(obj.BlankWaiverFileID), "'" })
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
                If (obj.EIN <> Me._EIN) Then
                    Me.UpdateEIN(Me._EIN, (cnn))
                    strTemp = String.Concat(New String() { "EIN Changed to '", Me._EIN, "' from '", obj.EIN, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Email <> Me._Email) Then
                    Me.UpdateEmail(Me._Email, (cnn))
                    strTemp = String.Concat(New String() { "Email Changed to '", Me._Email, "' from '", obj.Email, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.CompanyName <> Me._CompanyName) Then
                    Me.UpdateCompanyName(Me._CompanyName, (cnn))
                    strTemp = String.Concat(New String() { "CompanyName Changed to '", Me._CompanyName, "' from '", obj.CompanyName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.WebSite <> Me._WebSite) Then
                    Me.UpdateWebSite(Me._WebSite, (cnn))
                    strTemp = String.Concat(New String() { "WebSite Changed to '", Me._WebSite, "' from '", obj.WebSite, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Active <> Me._Active) Then
                    Me.UpdateActive(Me._Active, (cnn))
                    strTemp = String.Concat(New String() { "Active Changed to '", Conversions.ToString(Me._Active), "' from '", Conversions.ToString(obj.Active), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.UserID <> Me._UserID) Then
                    Me.UpdateUserID(Me._UserID, (cnn))
                    strTemp = String.Concat(New String() {"UserID Changed to '", Conversions.ToString(Me._UserID), "' from '", Conversions.ToString(obj.UserID), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If obj.InfoID <> Me._InfoID Then
                    UpdateInfoID(Me._InfoID, (cnn))
                    strTemp = "InfoID Changed to '" & Me._InfoID & "' from '" & obj.InfoID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close
                Me.Load(Me._PartnerID)
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
            Dim cmd As New SqlCommand("spUpdatePartnerActive")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = Me._PartnerID
            cmd.Parameters.Add("@Active", SqlDbType.Bit).Value = NewActive
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateBlankContractFileID(ByVal NewBlankContractFileID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerBlankContractFileID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = Me._PartnerID
            cmd.Parameters.Add("@BlankContractFileID", SqlDbType.Int).Value = NewBlankContractFileID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateBlankNDAFileID(ByVal NewBlankNDAFileID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerBlankNDAFileID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = Me._PartnerID
            cmd.Parameters.Add("@BlankNDAFileID", SqlDbType.Int).Value = NewBlankNDAFileID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateBlankWaiverFileID(ByVal NewBlankWaiverFileID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerBlankWaiverFileID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = Me._PartnerID
            cmd.Parameters.Add("@BlankWaiverFileID", SqlDbType.Int).Value = NewBlankWaiverFileID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateBusinessStartedMonthID(ByVal NewBusinessStartedMonthID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerBusinessStartedMonthID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = Me._PartnerID
            cmd.Parameters.Add("@BusinessStartedMonthID", SqlDbType.Int).Value = NewBusinessStartedMonthID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateBusinessStartedYear(ByVal NewBusinessStartedYear As Integer, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerBusinessStartedYear")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = Me._PartnerID
            cmd.Parameters.Add("@BusinessStartedYear", SqlDbType.TinyInt).Value = NewBusinessStartedYear
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCompanyName(ByVal NewCompanyName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerCompanyName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = Me._PartnerID
            cmd.Parameters.Add("@CompanyName", SqlDbType.VarChar, Me.TrimTrunc(NewCompanyName, &H80).Length).Value = Me.TrimTrunc(NewCompanyName, &H80)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateEIN(ByVal NewEIN As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerEIN")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = Me._PartnerID
            cmd.Parameters.Add("@EIN", SqlDbType.VarChar, Me.TrimTrunc(NewEIN, &H40).Length).Value = Me.TrimTrunc(NewEIN, &H40)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateEmail(ByVal NewEmail As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerEmail")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = Me._PartnerID
            If (NewEmail.Trim.Length > 0) Then
                cmd.Parameters.Add("@Email", SqlDbType.VarChar, Me.TrimTrunc(NewEmail, &HFF).Length).Value = Me.TrimTrunc(NewEmail, &HFF)
            Else
                cmd.Parameters.Add("@Email", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateEntityTypeID(ByVal NewEntityTypeID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerEntityTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = Me._PartnerID
            cmd.Parameters.Add("@EntityTypeID", SqlDbType.Int).Value = NewEntityTypeID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateSignedContractFileID(ByVal NewSignedContractFileID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerSignedContractFileID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = Me._PartnerID
            cmd.Parameters.Add("@SignedContractFileID", SqlDbType.Int).Value = NewSignedContractFileID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateSignedNDAFileID(ByVal NewSignedNDAFileID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerSignedNDAFileID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = Me._PartnerID
            cmd.Parameters.Add("@SignedNDAFileID", SqlDbType.Int).Value = NewSignedNDAFileID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateSignedWaiverFileID(ByVal NewSignedWaiverFileID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerSignedWaiverFileID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = Me._PartnerID
            cmd.Parameters.Add("@SignedWaiverFileID", SqlDbType.Int).Value = NewSignedWaiverFileID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateWebSite(ByVal NewWebSite As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerWebSite")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = Me._PartnerID
            If (NewWebSite.Trim.Length > 0) Then
                cmd.Parameters.Add("@WebSite", SqlDbType.VarChar, Me.TrimTrunc(NewWebSite, &HFF).Length).Value = Me.TrimTrunc(NewWebSite, &HFF)
            Else
                cmd.Parameters.Add("@WebSite", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub
        Private Sub UpdateUserID(ByVal NewUserID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerUserID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = Me._PartnerID
            cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = NewUserID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdateInfoID(ByVal NewInfoID As Long, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdatePartnerInfoID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = Me._PartnerID
            cmd.Parameters.Add("@InfoID", SqlDbType.int).value = NewInfoID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ' Properties
        Public ReadOnly Property ActionObjectID As Integer
            Get
                Return &H2D
            End Get
        End Property

        Public Property Active As Boolean
            Get
                Return Me._Active
            End Get
            Set(ByVal value As Boolean)
                Me._Active = value
            End Set
        End Property

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

        Public Property BlankWaiverFileID As Long
            Get
                Return Me._BlankWaiverFileID
            End Get
            Set(ByVal value As Long)
                Me._BlankWaiverFileID = value
            End Set
        End Property

        Public Property BusinessStartedMonthID As Long
            Get
                Return Me._BusinessStartedMonthID
            End Get
            Set(ByVal value As Long)
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

        Public ReadOnly Property ClosedWorkOrderCount As Long
            Get
                Return Me._ClosedWorkOrderCount
            End Get
        End Property

        Public Property CompanyName As String
            Get
                Return Me._CompanyName
            End Get
            Set(ByVal value As String)
                Me._CompanyName = Me.TrimTrunc(value, &H80)
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

        Public Property EIN As String
            Get
                Return Me._EIN
            End Get
            Set(ByVal value As String)
                Me._EIN = Me.TrimTrunc(value, &H40)
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

        Public Property EntityTypeID As Long
            Get
                Return Me._EntityTypeID
            End Get
            Set(ByVal value As Long)
                Me._EntityTypeID = value
            End Set
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public ReadOnly Property OpenWorkOrderCount As Long
            Get
                Return Me._OpenWorkOrderCount
            End Get
        End Property

        Public ReadOnly Property PartnerID As Long
            Get
                Return Me._PartnerID
            End Get
        End Property

        Public ReadOnly Property ResumeID As Long
            Get
                Return Me._ResumeID
            End Get
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
        Private _Active As Boolean
        Private _BlankContractFileID As Long
        Private _BlankNDAFileID As Long
        Private _BlankWaiverFileID As Long
        Private _BusinessStartedMonthID As Long
        Private _BusinessStartedYear As Integer
        Private _ClosedWorkOrderCount As Long
        Private _CompanyName As String
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _EIN As String
        Private _Email As String
        Private _EntityTypeID As Long
        Private _OpenWorkOrderCount As Long
        Private _PartnerID As Long
        Private _ResumeID As Long
        Private _SignedContractFileID As Long
        Private _SignedNDAFileID As Long
        Private _SignedWaiverFileID As Long
        Private _WebSite As String
        Private _UserID As Long
        Private _InfoID As Long = 0
        Private Const CompanyNameMaxLength As Integer = &H80
        Private Const EINMaxLength As Integer = &H40
        Private Const EmailMaxLength As Integer = &HFF
        Private Const ObjectID As Integer = &H2D
        Private Const WebSiteMaxLength As Integer = &HFF
    End Class
End Namespace

