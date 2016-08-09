Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class WorkOrderRecord
        ' Methods
        Public Sub New()
            Me._DateClosed = New DateTime
            Me._MinutesOnSite = 0
            Me._WorkOrderID = 0
            Me._DispatchDate = New DateTime
            Me._CreatedBy = 0
            Me._PartnerAddressID = 0
            Me._PartnerID = 0
            Me._PartnerAgentID = 0
            Me._WorkOrderStatusID = 0
            Me._ServiceID = 0
            Me._TicketID = 0
            Me._WorkOrderFileID = 0
            Me._IncrementTypeID = 0
            Me._ClosingAgent = 0
            Me._MileageStart = 0
            Me._MileageEnd = 0
            Me._TimeOnHold = 0
            Me._TravelTime = 0
            Me._SurveyEmail = ""
            Me._TechSupportAgentName = ""
            Me._ResolutionNote = ""
            Me._MinimumPay = 0
            Me._MaximumPay = 0
            Me._PayRate = 0
            Me._AdjustPay = 0
            Me._SurveyAuthorized = False
            Me._Payable = False
            Me._ClosedFromSite = False
            Me._Resolved = False
            Me._Arrived = New DateTime
            Me._Departed = New DateTime
            Me._DateCreated = DateTime.Now
            Me._Billable = False
            Me._TripChargeTypeID = False
            Me._InvoiceID = 0
            Me._Invoiced = False
            Me._RPW = False
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._DateClosed = New DateTime
            Me._MinutesOnSite = 0
            Me._WorkOrderID = 0
            Me._DispatchDate = New DateTime
            Me._CreatedBy = 0
            Me._PartnerAddressID = 0
            Me._PartnerID = 0
            Me._PartnerAgentID = 0
            Me._WorkOrderStatusID = 0
            Me._ServiceID = 0
            Me._TicketID = 0
            Me._WorkOrderFileID = 0
            Me._IncrementTypeID = 0
            Me._ClosingAgent = 0
            Me._MileageStart = 0
            Me._MileageEnd = 0
            Me._TimeOnHold = 0
            Me._TravelTime = 0
            Me._SurveyEmail = ""
            Me._TechSupportAgentName = ""
            Me._ResolutionNote = ""
            Me._MinimumPay = 0
            Me._MaximumPay = 0
            Me._PayRate = 0
            Me._AdjustPay = 0
            Me._SurveyAuthorized = False
            Me._Payable = False
            Me._ClosedFromSite = False
            Me._Resolved = False
            Me._Arrived = New DateTime
            Me._Departed = New DateTime
            Me._DateCreated = DateTime.Now
            Me._Billable = False
            Me._TripChargeTypeID = False
            Me._InvoiceID = 0
            Me._Invoiced = False
            Me._RPW = False
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngWorkOrderID As Long, ByVal strConnectionString As String)
            Me._DateClosed = New DateTime
            Me._MinutesOnSite = 0
            Me._WorkOrderID = 0
            Me._DispatchDate = New DateTime
            Me._CreatedBy = 0
            Me._PartnerAddressID = 0
            Me._PartnerID = 0
            Me._PartnerAgentID = 0
            Me._WorkOrderStatusID = 0
            Me._ServiceID = 0
            Me._TicketID = 0
            Me._WorkOrderFileID = 0
            Me._IncrementTypeID = 0
            Me._ClosingAgent = 0
            Me._MileageStart = 0
            Me._MileageEnd = 0
            Me._TimeOnHold = 0
            Me._TravelTime = 0
            Me._SurveyEmail = ""
            Me._TechSupportAgentName = ""
            Me._ResolutionNote = ""
            Me._MinimumPay = 0
            Me._MaximumPay = 0
            Me._PayRate = 0
            Me._AdjustPay = 0
            Me._SurveyAuthorized = False
            Me._Payable = False
            Me._ClosedFromSite = False
            Me._Resolved = False
            Me._Arrived = New DateTime
            Me._Departed = New DateTime
            Me._DateCreated = DateTime.Now
            Me._Billable = False
            Me._TripChargeTypeID = False
            Me._InvoiceID = 0
            Me._Invoiced = False
            Me._RPW = False
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._WorkOrderID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal lngWorkOrderStatusID As Long, ByVal lngServiceID As Long, ByVal lngTicketID As Long, ByVal lngIncrementTypeID As Long, ByVal dblMinimumPay As Double, ByVal dblMaximumPay As Double, ByVal dblPayRate As Double, ByVal dblAdjustPay As Double)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddWorkOrder")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngWorkOrderID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@WorkOrderStatusID", SqlDbType.Int).Value = lngWorkOrderStatusID
                cmd.Parameters.Add("@ServiceID", SqlDbType.Int).Value = lngServiceID
                cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = lngTicketID
                cmd.Parameters.Add("@IncrementTypeID", SqlDbType.Int).Value = lngIncrementTypeID
                cmd.Parameters.Add("@MinimumPay", SqlDbType.Money).Value = dblMinimumPay
                cmd.Parameters.Add("@MaximumPay", SqlDbType.Money).Value = dblMaximumPay
                cmd.Parameters.Add("@PayRate", SqlDbType.Money).Value = dblPayRate
                cmd.Parameters.Add("@AdjustPay", SqlDbType.Money).Value = dblAdjustPay
                cnn.Open
                cmd.Connection = cnn
                lngWorkOrderID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngWorkOrderID > 0) Then
                    Me.Load(lngWorkOrderID)
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
            Me._MinutesOnSite = 0
            Me._DateClosed = New DateTime
            Me._DispatchDate = New DateTime
            Me._WorkOrderID = 0
            Me._CreatedBy = 0
            Me._PartnerAddressID = 0
            Me._PartnerID = 0
            Me._PartnerAgentID = 0
            Me._WorkOrderStatusID = 0
            Me._ServiceID = 0
            Me._TicketID = 0
            Me._WorkOrderFileID = 0
            Me._IncrementTypeID = 0
            Me._ClosingAgent = 0
            Me._MileageStart = 0
            Me._MileageEnd = 0
            Me._TimeOnHold = 0
            Me._TravelTime = 0
            Me._SurveyEmail = ""
            Me._TechSupportAgentName = ""
            Me._ResolutionNote = ""
            Me._MinimumPay = 0
            Me._MaximumPay = 0
            Me._PayRate = 0
            Me._AdjustPay = 0
            Me._SurveyAuthorized = False
            Me._Payable = False
            Me._ClosedFromSite = False
            Me._Resolved = False
            Me._Arrived = New DateTime
            Me._Departed = New DateTime
            Me._DateCreated = DateTime.Now
            Me._Billable = False
            Me._TripChargeTypeID = False
            Me._InvoiceID = 0
            Me._Invoiced = False
            Me._RPW = False
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveWorkOrder")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._WorkOrderID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New WorkOrderRecord(Me._WorkOrderID, Me._ConnectionString)
            obj.Load(Me._WorkOrderID)
            If (DateTime.Compare(obj.DateClosed, Me._DateClosed) <> 0) Then
                blnReturn = True
            End If
            If (DateTime.Compare(obj.DispatchDate, Me._DispatchDate) <> 0) Then
                blnReturn = True
            End If
            If (obj.PartnerAddressID <> Me._PartnerAddressID) Then
                blnReturn = True
            End If
            If (obj.PartnerID <> Me._PartnerID) Then
                blnReturn = True
            End If
            If (obj.PartnerAgentID <> Me._PartnerAgentID) Then
                blnReturn = True
            End If
            If (obj.WorkOrderStatusID <> Me._WorkOrderStatusID) Then
                blnReturn = True
            End If
            If (obj.ServiceID <> Me._ServiceID) Then
                blnReturn = True
            End If
            If (obj.TicketID <> Me._TicketID) Then
                blnReturn = True
            End If
            If (obj.WorkOrderFileID <> Me._WorkOrderFileID) Then
                blnReturn = True
            End If
            If (obj.IncrementTypeID <> Me._IncrementTypeID) Then
                blnReturn = True
            End If
            If (obj.TripChargeTypeID <> Me._TripChargeTypeID) Then
                blnReturn = True
            End If
            If (obj.InvoiceID <> Me._InvoiceID) Then
                blnReturn = True
            End If
            If (obj.ClosingAgent <> Me._ClosingAgent) Then
                blnReturn = True
            End If
            If (obj.MileageStart <> Me._MileageStart) Then
                blnReturn = True
            End If
            If (obj.MileageEnd <> Me._MileageEnd) Then
                blnReturn = True
            End If
            If (obj.TimeOnHold <> Me._TimeOnHold) Then
                blnReturn = True
            End If
            If (obj.TravelTime <> Me._TravelTime) Then
                blnReturn = True
            End If
            If (obj.SurveyEmail <> Me._SurveyEmail) Then
                blnReturn = True
            End If
            If (obj.TechSupportAgentName <> Me._TechSupportAgentName) Then
                blnReturn = True
            End If
            If (obj.ResolutionNote <> Me._ResolutionNote) Then
                blnReturn = True
            End If
            If (obj.MinimumPay <> Me._MinimumPay) Then
                blnReturn = True
            End If
            If (obj.MaximumPay <> Me._MaximumPay) Then
                blnReturn = True
            End If
            If (obj.PayRate <> Me._PayRate) Then
                blnReturn = True
            End If
            If (obj.AdjustPay <> Me._AdjustPay) Then
                blnReturn = True
            End If
            If (obj.SurveyAuthorized <> Me._SurveyAuthorized) Then
                blnReturn = True
            End If
            If (obj.Payable <> Me._Payable) Then
                blnReturn = True
            End If
            If (obj.Billable <> Me._Billable) Then
                blnReturn = True
            End If
            If (obj.RPW <> Me._RPW) Then
                blnReturn = True
            End If
            If (obj.ClosedFromSite <> Me._ClosedFromSite) Then
                blnReturn = True
            End If
            If (obj.Resolved <> Me._Resolved) Then
                blnReturn = True
            End If
            If (obj.Invoiced <> Me._Invoiced) Then
                blnReturn = True
            End If
            If (DateTime.Compare(obj.Arrived, Me._Arrived) <> 0) Then
                blnReturn = True
            End If
            If (DateTime.Compare(obj.Departed, Me._Departed) <> 0) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngWorkOrderID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetWorkOrder")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = lngWorkOrderID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._WorkOrderID = Conversions.ToLong(dtr.Item("WorkOrderID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("PartnerAddressID"))) Then
                        Me._PartnerAddressID = Conversions.ToLong(dtr.Item("PartnerAddressID"))
                    Else
                        Me._PartnerAddressID = 0
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("PartnerID"))) Then
                        Me._PartnerID = Conversions.ToLong(dtr.Item("PartnerID"))
                    Else
                        Me._PartnerID = 0
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("PartnerAgentID"))) Then
                        Me._PartnerAgentID = Conversions.ToLong(dtr.Item("PartnerAgentID"))
                    Else
                        Me._PartnerAgentID = 0
                    End If
                    Me._WorkOrderStatusID = Conversions.ToLong(dtr.Item("WorkOrderStatusID"))
                    Me._ServiceID = Conversions.ToLong(dtr.Item("ServiceID"))
                    Me._TicketID = Conversions.ToLong(dtr.Item("TicketID"))
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("WorkOrderFileID"))) Then
                        Me._WorkOrderFileID = Conversions.ToLong(dtr.Item("WorkOrderFileID"))
                    Else
                        Me._WorkOrderFileID = 0
                    End If
                    Me._IncrementTypeID = Conversions.ToLong(dtr.Item("IncrementTypeID"))
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("TripChargeTypeID"))) Then
                        Me._TripChargeTypeID = Conversions.ToLong(dtr.Item("TripChargeTypeID"))
                    Else
                        Me._TripChargeTypeID = 0
                    End If

                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("InvoiceID"))) Then
                        Me._InvoiceID = Conversions.ToLong(dtr.Item("InvoiceID"))
                    Else
                        Me._InvoiceID = 0
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("ClosingAgent"))) Then
                        Me._ClosingAgent = Conversions.ToLong(dtr.Item("ClosingAgent"))
                    Else
                        Me._ClosingAgent = 0
                    End If
                    Me._MileageStart = Conversions.ToLong(dtr.Item("MileageStart"))
                    Me._MileageEnd = Conversions.ToLong(dtr.Item("MileageEnd"))
                    Me._TimeOnHold = Conversions.ToLong(dtr.Item("TimeOnHold"))
                    Me._TravelTime = Conversions.ToLong(dtr.Item("TravelTime"))
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("SurveyEmail"))) Then
                        Me._SurveyEmail = dtr.Item("SurveyEmail").ToString
                    Else
                        Me._SurveyEmail = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("TechSupportAgentName"))) Then
                        Me._TechSupportAgentName = dtr.Item("TechSupportAgentName").ToString
                    Else
                        Me._TechSupportAgentName = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("ResolutionNote"))) Then
                        Me._ResolutionNote = dtr.Item("ResolutionNote").ToString
                    Else
                        Me._ResolutionNote = ""
                    End If
                    Me._MinimumPay = Conversions.ToDouble(dtr.Item("MinimumPay"))
                    Me._MaximumPay = Conversions.ToDouble(dtr.Item("MaximumPay"))
                    Me._PayRate = Conversions.ToDouble(dtr.Item("PayRate"))
                    Me._AdjustPay = Conversions.ToDouble(dtr.Item("AdjustPay"))
                    Me._SurveyAuthorized = Conversions.ToBoolean(dtr.Item("SurveyAuthorized"))
                    Me._Payable = Conversions.ToBoolean(dtr.Item("Payable"))
                    Me._ClosedFromSite = Conversions.ToBoolean(dtr.Item("ClosedFromSite"))
                    Me._Resolved = Conversions.ToBoolean(dtr.Item("Resolved"))
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Billable"))) Then
                        Me._Billable = Conversions.ToBoolean(dtr.Item("Billable"))
                    Else
                        Me._Billable = 0
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("RPW"))) Then
                        Me._RPW = Conversions.ToBoolean(dtr.Item("RPW"))
                    Else
                        Me._RPW = 0
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Invoiced"))) Then
                        Me._Invoiced = Conversions.ToBoolean(dtr.Item("Invoiced"))
                    Else
                        Me._Invoiced = 0
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("DispatchDate"))) Then
                        Me._DispatchDate = Conversions.ToDate(dtr.Item("DispatchDate"))
                    Else
                        Me._DispatchDate = New DateTime
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Arrived"))) Then
                        Me._Arrived = Conversions.ToDate(dtr.Item("Arrived"))
                    Else
                        Me._Arrived = New DateTime
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Departed"))) Then
                        Me._Departed = Conversions.ToDate(dtr.Item("Departed"))
                    Else
                        Me._Departed = New DateTime
                    End If
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("DateClosed"))) Then
                        Me._DateClosed = Conversions.ToDate(dtr.Item("DateClosed"))
                    Else
                        Me._DateClosed = New DateTime
                    End If
                    Me._MinutesOnSite = Conversions.ToLong(dtr.Item("MinutesOnSite"))
                Else
                    Me.ClearValues()
                End If
                    cnn.Close()
                End If
        End Sub

        Public Sub Save(ByRef strChangeLog As String)
            strChangeLog = ""
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim strTemp As String = ""
                Dim cnn As New SqlConnection(Me._ConnectionString)
                cnn.Open
                Dim obj As New WorkOrderRecord(Me._WorkOrderID, Me._ConnectionString)
                obj.Load(Me._WorkOrderID)
                If (obj.PartnerAddressID <> Me._PartnerAddressID) Then
                    Me.UpdatePartnerAddressID(Me._PartnerAddressID, (cnn))
                    strTemp = String.Concat(New String() { "PartnerAddressID Changed to '", Conversions.ToString(Me._PartnerAddressID), "' from '", Conversions.ToString(obj.PartnerAddressID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (DateTime.Compare(obj.DateClosed, Me._DateClosed) <> 0) Then
                    Me.UpdateDateClosed(Me._DateClosed, (cnn))
                    strTemp = String.Concat(New String() { "DateClosed Changed to '", Conversions.ToString(Me._DateClosed), "' from '", Conversions.ToString(obj.DateClosed), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.PartnerID <> Me._PartnerID) Then
                    Me.UpdatePartnerID(Me._PartnerID, (cnn))
                    strTemp = String.Concat(New String() { "PartnerID Changed to '", Conversions.ToString(Me._PartnerID), "' from '", Conversions.ToString(obj.PartnerID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (DateTime.Compare(obj.DispatchDate, Me._DispatchDate) <> 0) Then
                    Me.UpdateDispatchDate(Me._DispatchDate, (cnn))
                    strTemp = String.Concat(New String() { "DispatchDate Changed to '", Conversions.ToString(Me._DispatchDate), "' from '", Conversions.ToString(obj.DispatchDate), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.PartnerAgentID <> Me._PartnerAgentID) Then
                    Me.UpdatePartnerAgentID(Me._PartnerAgentID, (cnn))
                    strTemp = String.Concat(New String() { "PartnerAgentID Changed to '", Conversions.ToString(Me._PartnerAgentID), "' from '", Conversions.ToString(obj.PartnerAgentID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.WorkOrderStatusID <> Me._WorkOrderStatusID) Then
                    Me.UpdateWorkOrderStatusID(Me._WorkOrderStatusID, (cnn))
                    strTemp = String.Concat(New String() { "WorkOrderStatusID Changed to '", Conversions.ToString(Me._WorkOrderStatusID), "' from '", Conversions.ToString(obj.WorkOrderStatusID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ServiceID <> Me._ServiceID) Then
                    Me.UpdateServiceID(Me._ServiceID, (cnn))
                    strTemp = String.Concat(New String() { "ServiceID Changed to '", Conversions.ToString(Me._ServiceID), "' from '", Conversions.ToString(obj.ServiceID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.TicketID <> Me._TicketID) Then
                    Me.UpdateTicketID(Me._TicketID, (cnn))
                    strTemp = String.Concat(New String() { "TicketID Changed to '", Conversions.ToString(Me._TicketID), "' from '", Conversions.ToString(obj.TicketID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.TripChargeTypeID <> Me._TripChargeTypeID) Then
                    Me.UpdateTripChargeTypeID(Me._TripChargeTypeID, (cnn))
                    strTemp = String.Concat(New String() {"TripChargeTypeID Changed to '", Conversions.ToString(Me._TripChargeTypeID), "' from '", Conversions.ToString(obj.TripChargeTypeID), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.WorkOrderFileID <> Me._WorkOrderFileID) Then
                    Me.UpdateWorkOrderFileID(Me._WorkOrderFileID, (cnn))
                    strTemp = String.Concat(New String() { "WorkOrderFileID Changed to '", Conversions.ToString(Me._WorkOrderFileID), "' from '", Conversions.ToString(obj.WorkOrderFileID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.IncrementTypeID <> Me._IncrementTypeID) Then
                    Me.UpdateIncrementTypeID(Me._IncrementTypeID, (cnn))
                    strTemp = String.Concat(New String() { "IncrementTypeID Changed to '", Conversions.ToString(Me._IncrementTypeID), "' from '", Conversions.ToString(obj.IncrementTypeID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ClosingAgent <> Me._ClosingAgent) Then
                    Me.UpdateClosingAgent(Me._ClosingAgent, (cnn))
                    strTemp = String.Concat(New String() { "ClosingAgent Changed to '", Conversions.ToString(Me._ClosingAgent), "' from '", Conversions.ToString(obj.ClosingAgent), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.MileageStart <> Me._MileageStart) Then
                    Me.UpdateMileageStart(Me._MileageStart, (cnn))
                    strTemp = String.Concat(New String() { "MileageStart Changed to '", Conversions.ToString(Me._MileageStart), "' from '", Conversions.ToString(obj.MileageStart), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.MileageEnd <> Me._MileageEnd) Then
                    Me.UpdateMileageEnd(Me._MileageEnd, (cnn))
                    strTemp = String.Concat(New String() { "MileageEnd Changed to '", Conversions.ToString(Me._MileageEnd), "' from '", Conversions.ToString(obj.MileageEnd), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.TimeOnHold <> Me._TimeOnHold) Then
                    Me.UpdateTimeOnHold(Me._TimeOnHold, (cnn))
                    strTemp = String.Concat(New String() { "TimeOnHold Changed to '", Conversions.ToString(Me._TimeOnHold), "' from '", Conversions.ToString(obj.TimeOnHold), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.TravelTime <> Me._TravelTime) Then
                    Me.UpdateTravelTime(Me._TravelTime, (cnn))
                    strTemp = String.Concat(New String() { "TravelTime Changed to '", Conversions.ToString(Me._TravelTime), "' from '", Conversions.ToString(obj.TravelTime), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.SurveyEmail <> Me._SurveyEmail) Then
                    Me.UpdateSurveyEmail(Me._SurveyEmail, (cnn))
                    strTemp = String.Concat(New String() { "SurveyEmail Changed to '", Me._SurveyEmail, "' from '", obj.SurveyEmail, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.TechSupportAgentName <> Me._TechSupportAgentName) Then
                    Me.UpdateTechSupportAgentName(Me._TechSupportAgentName, (cnn))
                    strTemp = String.Concat(New String() { "TechSupportAgentName Changed to '", Me._TechSupportAgentName, "' from '", obj.TechSupportAgentName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ResolutionNote <> Me._ResolutionNote) Then
                    Me.UpdateResolutionNote(Me._ResolutionNote, (cnn))
                    strTemp = String.Concat(New String() { "ResolutionNote Changed to '", Me._ResolutionNote, "' from '", obj.ResolutionNote, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.MinimumPay <> Me._MinimumPay) Then
                    Me.UpdateMinimumPay(Me._MinimumPay, (cnn))
                    strTemp = String.Concat(New String() { "MinimumPay Changed to '", Conversions.ToString(Me._MinimumPay), "' from '", Conversions.ToString(obj.MinimumPay), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.MaximumPay <> Me._MaximumPay) Then
                    Me.UpdateMaximumPay(Me._MaximumPay, (cnn))
                    strTemp = String.Concat(New String() { "MaximumPay Changed to '", Conversions.ToString(Me._MaximumPay), "' from '", Conversions.ToString(obj.MaximumPay), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.PayRate <> Me._PayRate) Then
                    Me.UpdatePayRate(Me._PayRate, (cnn))
                    strTemp = String.Concat(New String() { "PayRate Changed to '", Conversions.ToString(Me._PayRate), "' from '", Conversions.ToString(obj.PayRate), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.AdjustPay <> Me._AdjustPay) Then
                    Me.UpdateAdjustPay(Me._AdjustPay, (cnn))
                    strTemp = String.Concat(New String() { "AdjustPay Changed to '", Conversions.ToString(Me._AdjustPay), "' from '", Conversions.ToString(obj.AdjustPay), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.SurveyAuthorized <> Me._SurveyAuthorized) Then
                    Me.UpdateSurveyAuthorized(Me._SurveyAuthorized, (cnn))
                    strTemp = String.Concat(New String() { "SurveyAuthorized Changed to '", Conversions.ToString(Me._SurveyAuthorized), "' from '", Conversions.ToString(obj.SurveyAuthorized), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Payable <> Me._Payable) Then
                    Me.UpdatePayable(Me._Payable, (cnn))
                    strTemp = String.Concat(New String() { "Payable Changed to '", Conversions.ToString(Me._Payable), "' from '", Conversions.ToString(obj.Payable), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ClosedFromSite <> Me._ClosedFromSite) Then
                    Me.UpdateClosedFromSite(Me._ClosedFromSite, (cnn))
                    strTemp = String.Concat(New String() { "ClosedFromSite Changed to '", Conversions.ToString(Me._ClosedFromSite), "' from '", Conversions.ToString(obj.ClosedFromSite), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Resolved <> Me._Resolved) Then
                    Me.UpdateResolved(Me._Resolved, (cnn))
                    strTemp = String.Concat(New String() { "Resolved Changed to '", Conversions.ToString(Me._Resolved), "' from '", Conversions.ToString(obj.Resolved), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Billable <> Me._Billable) Then
                    Me.UpdateBillable(Me._Billable, (cnn))
                    strTemp = String.Concat(New String() {"Billable Changed to '", Conversions.ToString(Me._Billable), "' from '", Conversions.ToString(obj.Billable), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.RPW <> Me._RPW) Then
                    Me.UpdateRPW(Me._RPW, (cnn))
                    strTemp = String.Concat(New String() {"RPW Changed to '", Conversions.ToString(Me._RPW), "' from '", Conversions.ToString(obj.RPW), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (DateTime.Compare(obj.Arrived, Me._Arrived) <> 0) Then
                    Me.UpdateArrived((Me._Arrived), (cnn))
                    strTemp = String.Concat(New String() { "Arrived Changed to '", Conversions.ToString(Me._Arrived), "' from '", Conversions.ToString(obj.Arrived), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (DateTime.Compare(obj.Departed, Me._Departed) <> 0) Then
                    Me.UpdateDeparted((Me._Departed), (cnn))
                    strTemp = String.Concat(New String() { "Departed Changed to '", Conversions.ToString(Me._Departed), "' from '", Conversions.ToString(obj.Departed), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.InvoiceID <> Me._InvoiceID) Then
                    Me.UpdateWorkOrderInvoiceID(Me._InvoiceID, (cnn))
                    strTemp = String.Concat(New String() {"InvoiceID Changed to '", Conversions.ToString(Me._InvoiceID), "' from '", Conversions.ToString(obj.InvoiceID), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Invoiced <> Me._Invoiced) Then
                    Me.UpdateWorkOrderInvoiced(Me._Invoiced, (cnn))
                    strTemp = String.Concat(New String() {"Invoiced Changed to '", Conversions.ToString(Me._Invoiced), "' from '", Conversions.ToString(obj.Invoiced), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._WorkOrderID)
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

        Private Sub UpdateAdjustPay(ByVal NewAdjustPay As Double, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderAdjustPay")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            cmd.Parameters.Add("@AdjustPay", SqlDbType.Money).Value = NewAdjustPay
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateArrived(ByRef NewArrived As DateTime, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderArrived")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            Dim datNothing As New DateTime
            If (DateTime.Compare(NewArrived, datNothing) <> 0) Then
                cmd.Parameters.Add("@Arrived", SqlDbType.DateTime).Value = CDate(NewArrived)
            Else
                cmd.Parameters.Add("@Arrived", SqlDbType.DateTime).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateClosedFromSite(ByVal NewClosedFromSite As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderClosedFromSite")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            cmd.Parameters.Add("@ClosedFromSite", SqlDbType.Bit).Value = NewClosedFromSite
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateClosingAgent(ByVal NewClosingAgent As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderClosingAgent")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            If (NewClosingAgent > 0) Then
                cmd.Parameters.Add("@ClosingAgent", SqlDbType.Int).Value = NewClosingAgent
            Else
                cmd.Parameters.Add("@ClosingAgent", SqlDbType.Int).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateDateClosed(ByVal NewDateClosed As DateTime, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderDateClosed")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            Dim datNothing As New DateTime
            If (DateTime.Compare(NewDateClosed, datNothing) <> 0) Then
                cmd.Parameters.Add("@DateClosed", SqlDbType.DateTime).Value = NewDateClosed
            Else
                cmd.Parameters.Add("@DateClosed", SqlDbType.DateTime).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateDeparted(ByRef NewDeparted As DateTime, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderDeparted")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            Dim datNothing As New DateTime
            If (DateTime.Compare(NewDeparted, datNothing) <> 0) Then
                cmd.Parameters.Add("@Departed", SqlDbType.DateTime).Value = CDate(NewDeparted)
            Else
                cmd.Parameters.Add("@Departed", SqlDbType.DateTime).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateDispatchDate(ByVal NewDispatchDate As DateTime, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderDispatchDate")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            Dim datNothing As New DateTime
            If (DateTime.Compare(NewDispatchDate, datNothing) <> 0) Then
                cmd.Parameters.Add("@DispatchDate", SqlDbType.DateTime).Value = NewDispatchDate
            Else
                cmd.Parameters.Add("@DispatchDate", SqlDbType.DateTime).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateIncrementTypeID(ByVal NewIncrementTypeID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderIncrementTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            cmd.Parameters.Add("@IncrementTypeID", SqlDbType.Int).Value = NewIncrementTypeID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateMaximumPay(ByVal NewMaximumPay As Double, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderMaximumPay")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            cmd.Parameters.Add("@MaximumPay", SqlDbType.Money).Value = NewMaximumPay
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateMileageEnd(ByVal NewMileageEnd As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderMileageEnd")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            cmd.Parameters.Add("@MileageEnd", SqlDbType.Int).Value = NewMileageEnd
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateMileageStart(ByVal NewMileageStart As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderMileageStart")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            cmd.Parameters.Add("@MileageStart", SqlDbType.Int).Value = NewMileageStart
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateMinimumPay(ByVal NewMinimumPay As Double, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderMinimumPay")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            cmd.Parameters.Add("@MinimumPay", SqlDbType.Money).Value = NewMinimumPay
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdatePartnerAddressID(ByVal NewPartnerAddressID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderPartnerAddressID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            If (NewPartnerAddressID > 0) Then
                cmd.Parameters.Add("@PartnerAddressID", SqlDbType.Int).Value = NewPartnerAddressID
            Else
                cmd.Parameters.Add("@PartnerAddressID", SqlDbType.Int).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdatePartnerAgentID(ByVal NewPartnerAgentID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderPartnerAgentID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            If (NewPartnerAgentID > 0) Then
                cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = NewPartnerAgentID
            Else
                cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdatePartnerID(ByVal NewPartnerID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderPartnerID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            If (NewPartnerID > 0) Then
                cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = NewPartnerID
            Else
                cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdatePayable(ByVal NewPayable As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderPayable")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            cmd.Parameters.Add("@Payable", SqlDbType.Bit).Value = NewPayable
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdatePayRate(ByVal NewPayRate As Double, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderPayRate")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            cmd.Parameters.Add("@PayRate", SqlDbType.Money).Value = NewPayRate
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateResolutionNote(ByVal NewResolutionNote As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderResolutionNote")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            If (NewResolutionNote.Trim.Length > 0) Then
                cmd.Parameters.Add("@ResolutionNote", SqlDbType.Text).Value = NewResolutionNote
            Else
                cmd.Parameters.Add("@ResolutionNote", SqlDbType.Text).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateResolved(ByVal NewResolved As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderResolved")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            cmd.Parameters.Add("@Resolved", SqlDbType.Bit).Value = NewResolved
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub
        Private Sub UpdateBillable(ByVal NewBillable As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderBillable")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            cmd.Parameters.Add("@Billable", SqlDbType.Bit).Value = NewBillable
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateRPW(ByVal NewRPW As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderRPW")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            cmd.Parameters.Add("@RPW", SqlDbType.Bit).Value = NewRPW
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdateServiceID(ByVal NewServiceID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderServiceID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            cmd.Parameters.Add("@ServiceID", SqlDbType.Int).Value = NewServiceID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateSurveyAuthorized(ByVal NewSurveyAuthorized As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderSurveyAuthorized")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            cmd.Parameters.Add("@SurveyAuthorized", SqlDbType.Bit).Value = NewSurveyAuthorized
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub
        Private Sub UpdateWorkOrderInvoiced(ByVal NewInvoiced As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderInvoiced")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            cmd.Parameters.Add("@Invoiced", SqlDbType.Bit).Value = NewInvoiced
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdateSurveyEmail(ByVal NewSurveyEmail As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderSurveyEmail")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            If (NewSurveyEmail.Trim.Length > 0) Then
                cmd.Parameters.Add("@SurveyEmail", SqlDbType.VarChar, Me.TrimTrunc(NewSurveyEmail, &HFF).Length).Value = Me.TrimTrunc(NewSurveyEmail, &HFF)
            Else
                cmd.Parameters.Add("@SurveyEmail", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateTechSupportAgentName(ByVal NewTechSupportAgentName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderTechSupportAgentName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            If (NewTechSupportAgentName.Trim.Length > 0) Then
                cmd.Parameters.Add("@TechSupportAgentName", SqlDbType.VarChar, Me.TrimTrunc(NewTechSupportAgentName, &HFF).Length).Value = Me.TrimTrunc(NewTechSupportAgentName, &HFF)
            Else
                cmd.Parameters.Add("@TechSupportAgentName", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateTicketID(ByVal NewTicketID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderTicketID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = NewTicketID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateTimeOnHold(ByVal NewTimeOnHold As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderTimeOnHold")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            cmd.Parameters.Add("@TimeOnHold", SqlDbType.Int).Value = NewTimeOnHold
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateTravelTime(ByVal NewTravelTime As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderTravelTime")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            cmd.Parameters.Add("@TravelTime", SqlDbType.Int).Value = NewTravelTime
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateWorkOrderFileID(ByVal NewWorkOrderFileID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderWorkOrderFileID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            If (NewWorkOrderFileID > 0) Then
                cmd.Parameters.Add("@WorkOrderFileID", SqlDbType.Int).Value = NewWorkOrderFileID
            Else
                cmd.Parameters.Add("@WorkOrderFileID", SqlDbType.Int).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateWorkOrderStatusID(ByVal NewWorkOrderStatusID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderWorkOrderStatusID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            cmd.Parameters.Add("@WorkOrderStatusID", SqlDbType.Int).Value = NewWorkOrderStatusID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub
        Private Sub UpdateTripChargeTypeID(ByVal NewTripChargeTypeID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderTripChargeTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            cmd.Parameters.Add("@TripChargeTypeID", SqlDbType.Int).Value = NewTripChargeTypeID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateWorkOrderInvoiceID(ByVal NewInvoiceID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWorkOrderInvoiceID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = Me._WorkOrderID
            cmd.Parameters.Add("@InvoiceID", SqlDbType.Int).Value = NewInvoiceID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub


        ' Properties
        Public Property AdjustPay As Double
            Get
                Return Me._AdjustPay
            End Get
            Set(ByVal value As Double)
                Me._AdjustPay = value
            End Set
        End Property

        Public Property Arrived As DateTime
            Get
                Return Me._Arrived
            End Get
            Set(ByVal value As DateTime)
                Me._Arrived = value
            End Set
        End Property

        Public Property ClosedFromSite As Boolean
            Get
                Return Me._ClosedFromSite
            End Get
            Set(ByVal value As Boolean)
                Me._ClosedFromSite = value
            End Set
        End Property

        Public Property ClosingAgent As Long
            Get
                Return Me._ClosingAgent
            End Get
            Set(ByVal value As Long)
                Me._ClosingAgent = value
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

        Public Property DateClosed As DateTime
            Get
                Return Me._DateClosed
            End Get
            Set(ByVal value As DateTime)
                Me._DateClosed = value
            End Set
        End Property

        Public ReadOnly Property DateCreated As DateTime
            Get
                Return Me._DateCreated
            End Get
        End Property

        Public Property Departed As DateTime
            Get
                Return Me._Departed
            End Get
            Set(ByVal value As DateTime)
                Me._Departed = value
            End Set
        End Property

        Public Property DispatchDate As DateTime
            Get
                Return Me._DispatchDate
            End Get
            Set(ByVal value As DateTime)
                Me._DispatchDate = value
            End Set
        End Property

        Public Property IncrementTypeID As Long
            Get
                Return Me._IncrementTypeID
            End Get
            Set(ByVal value As Long)
                Me._IncrementTypeID = value
            End Set
        End Property

        Public Property MaximumPay As Double
            Get
                Return Me._MaximumPay
            End Get
            Set(ByVal value As Double)
                Me._MaximumPay = value
            End Set
        End Property

        Public Property MileageEnd As Long
            Get
                Return Me._MileageEnd
            End Get
            Set(ByVal value As Long)
                Me._MileageEnd = value
            End Set
        End Property

        Public Property MileageStart As Long
            Get
                Return Me._MileageStart
            End Get
            Set(ByVal value As Long)
                Me._MileageStart = value
            End Set
        End Property

        Public Property MinimumPay As Double
            Get
                Return Me._MinimumPay
            End Get
            Set(ByVal value As Double)
                Me._MinimumPay = value
            End Set
        End Property

        Public ReadOnly Property MinutesOnSite As Long
            Get
                Return Me._MinutesOnSite
            End Get
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public Property PartnerAddressID As Long
            Get
                Return Me._PartnerAddressID
            End Get
            Set(ByVal value As Long)
                Me._PartnerAddressID = value
            End Set
        End Property

        Public Property PartnerAgentID As Long
            Get
                Return Me._PartnerAgentID
            End Get
            Set(ByVal value As Long)
                Me._PartnerAgentID = value
            End Set
        End Property

        Public Property PartnerID As Long
            Get
                Return Me._PartnerID
            End Get
            Set(ByVal value As Long)
                Me._PartnerID = value
            End Set
        End Property
        Public Property TripChargeTypeID() As Long
            Get
                Return Me._TripChargeTypeID
            End Get
            Set(ByVal value As Long)
                Me._TripChargeTypeID = value
            End Set
        End Property


        Public Property Payable As Boolean
            Get
                Return Me._Payable
            End Get
            Set(ByVal value As Boolean)
                Me._Payable = value
            End Set
        End Property
        Public Property Billable() As Boolean
            Get
                Return Me._Billable
            End Get
            Set(ByVal value As Boolean)
                Me._Billable = value
            End Set
        End Property
        Public Property RPW() As Boolean
            Get
                Return Me._RPW
            End Get
            Set(ByVal value As Boolean)
                Me._RPW = value
            End Set
        End Property
        Public Property Invoiced() As Boolean
            Get
                Return Me._Invoiced
            End Get
            Set(ByVal value As Boolean)
                Me._Invoiced = value
            End Set
        End Property

        Public Property PayRate As Double
            Get
                Return Me._PayRate
            End Get
            Set(ByVal value As Double)
                Me._PayRate = value
            End Set
        End Property

        Public Property ResolutionNote As String
            Get
                Return Me._ResolutionNote
            End Get
            Set(ByVal value As String)
                Me._ResolutionNote = value
            End Set
        End Property

        Public Property Resolved As Boolean
            Get
                Return Me._Resolved
            End Get
            Set(ByVal value As Boolean)
                Me._Resolved = value
            End Set
        End Property

        Public Property ServiceID As Long
            Get
                Return Me._ServiceID
            End Get
            Set(ByVal value As Long)
                Me._ServiceID = value
            End Set
        End Property

        Public Property SurveyAuthorized As Boolean
            Get
                Return Me._SurveyAuthorized
            End Get
            Set(ByVal value As Boolean)
                Me._SurveyAuthorized = value
            End Set
        End Property
        

        Public Property SurveyEmail As String
            Get
                Return Me._SurveyEmail
            End Get
            Set(ByVal value As String)
                Me._SurveyEmail = Me.TrimTrunc(value, &HFF)
            End Set
        End Property

        Public Property TechSupportAgentName As String
            Get
                Return Me._TechSupportAgentName
            End Get
            Set(ByVal value As String)
                Me._TechSupportAgentName = Me.TrimTrunc(value, &HFF)
            End Set
        End Property

        Public Property TicketID As Long
            Get
                Return Me._TicketID
            End Get
            Set(ByVal value As Long)
                Me._TicketID = value
            End Set
        End Property

        Public Property TimeOnHold As Long
            Get
                Return Me._TimeOnHold
            End Get
            Set(ByVal value As Long)
                Me._TimeOnHold = value
            End Set
        End Property

        Public Property TravelTime As Long
            Get
                Return Me._TravelTime
            End Get
            Set(ByVal value As Long)
                Me._TravelTime = value
            End Set
        End Property

        Public Property WorkOrderFileID As Long
            Get
                Return Me._WorkOrderFileID
            End Get
            Set(ByVal value As Long)
                Me._WorkOrderFileID = value
            End Set
        End Property

        Public ReadOnly Property WorkOrderID As Long
            Get
                Return Me._WorkOrderID
            End Get
        End Property

        Public Property WorkOrderStatusID As Long
            Get
                Return Me._WorkOrderStatusID
            End Get
            Set(ByVal value As Long)
                Me._WorkOrderStatusID = value
            End Set
        End Property
        Public Property InvoiceID() As Long
            Get
                Return Me._InvoiceID
            End Get
            Set(ByVal value As Long)
                Me._InvoiceID = value
            End Set
        End Property


        ' Fields
        Private _AdjustPay As Double
        Private _Arrived As DateTime
        Private _ClosedFromSite As Boolean
        Private _ClosingAgent As Long
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateClosed As DateTime
        Private _DateCreated As DateTime
        Private _Departed As DateTime
        Private _DispatchDate As DateTime
        Private _IncrementTypeID As Long
        Private _MaximumPay As Double
        Private _MileageEnd As Long
        Private _MileageStart As Long
        Private _MinimumPay As Double
        Private _MinutesOnSite As Long
        Private _PartnerAddressID As Long
        Private _PartnerAgentID As Long
        Private _PartnerID As Long
        Private _Payable As Boolean
        Private _PayRate As Double
        Private _ResolutionNote As String
        Private _Resolved As Boolean
        Private _ServiceID As Long
        Private _SurveyAuthorized As Boolean
        Private _SurveyEmail As String
        Private _TechSupportAgentName As String
        Private _TicketID As Long
        Private _TimeOnHold As Long
        Private _TravelTime As Long
        Private _WorkOrderFileID As Long
        Private _WorkOrderID As Long
        Private _WorkOrderStatusID As Long
        Private _Billable As Boolean
        Private _TripChargeTypeID As Long
        Private _InvoiceID As Long
        Private _Invoiced As Boolean
        Private _RPW As Boolean
        Private Const SurveyEmailMaxLength As Integer = &HFF
        Private Const TechSupportAgentNameMaxLength As Integer = &HFF
    End Class
End Namespace

