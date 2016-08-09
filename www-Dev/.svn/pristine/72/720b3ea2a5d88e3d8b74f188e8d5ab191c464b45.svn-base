Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class TicketRecord
        ' Methods
        Public Sub New()
            Me._Email = ""
            Me._TicketID = 0
            Me._ParentID = 0
            Me._CreatedBy = 0
            Me._AssignedTo = 0
            Me._CustomerID = 0
            Me._TicketStatusID = 0
            Me._StateID = 0
            Me._IncrementTypeID = 0
            Me._CompletedBy = 0
            Me._MileageStart = 0
            Me._MileageEnd = 0
            Me._WarrantyTermID = 0
            Me._InternalPrioritySetting = 0
            Me._CustomerPrioritySetting = 0
            Me._MinimumCharge = 0
            Me._ChargeRate = 0
            Me._AdjustCharge = 0
            Me._ReferenceNumber1 = ""
            Me._ReferenceNumber2 = ""
            Me._ReferenceNumber3 = ""
            Me._ReferenceNumber4 = ""
            Me._ContactFirstName = ""
            Me._ContactMiddleName = ""
            Me._ContactLastName = ""
            Me._Company = ""
            Me._Street = ""
            Me._Extended = ""
            Me._City = ""
            Me._ZipCode = ""
            Me._Description = ""
            Me._Instructions = ""
            Me._Notes = ""
            Me._ScheduledDate = New DateTime
            Me._ServiceStartDate = New DateTime
            Me._ServiceEndDate = New DateTime
            Me._ScheduledEndDate = New DateTime
            Me._PurchaseDate = New DateTime
            Me._WarrantyStart = New DateTime
            Me._WarrantyEnd = New DateTime
            Me._RequestedStartDate = DateTime.Now
            Me._RequestedEndDate = DateTime.Now
            Me._CompletedDate = New DateTime
            Me._DateCreated = DateTime.Now
            Me._Manufacturer = ""
            Me._Model = ""
            Me._ConnectionString = ""
            Me._SerialNumber = ""
            Me._ServiceID = 0
            Me._InitialContact = New DateTime
            Me._LaborOnly = False
            Me._WorkOrderIDs = New List(Of Long)
            Me._MaximumCharge = 0
            Me._InvoiceID = 0
            Me._SupportAgentID = 0
            Me._TicketClaimApprovalStatusID = 0
            Me._ApprovalDate = New DateTime
            Me._WebInvoiceID = 0
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._Email = ""
            Me._TicketID = 0
            Me._ParentID = 0
            Me._CreatedBy = 0
            Me._AssignedTo = 0
            Me._CustomerID = 0
            Me._TicketStatusID = 0
            Me._StateID = 0
            Me._IncrementTypeID = 0
            Me._CompletedBy = 0
            Me._MileageStart = 0
            Me._MileageEnd = 0
            Me._WarrantyTermID = 0
            Me._InternalPrioritySetting = 0
            Me._CustomerPrioritySetting = 0
            Me._MinimumCharge = 0
            Me._ChargeRate = 0
            Me._AdjustCharge = 0
            Me._ReferenceNumber1 = ""
            Me._ReferenceNumber2 = ""
            Me._ReferenceNumber3 = ""
            Me._ReferenceNumber4 = ""
            Me._ContactFirstName = ""
            Me._ContactMiddleName = ""
            Me._ContactLastName = ""
            Me._Company = ""
            Me._Street = ""
            Me._Extended = ""
            Me._City = ""
            Me._ZipCode = ""
            Me._Description = ""
            Me._Instructions = ""
            Me._Notes = ""
            Me._ScheduledDate = New DateTime
            Me._ServiceStartDate = New DateTime
            Me._ServiceEndDate = New DateTime
            Me._ScheduledEndDate = New DateTime
            Me._PurchaseDate = New DateTime
            Me._WarrantyStart = New DateTime
            Me._WarrantyEnd = New DateTime
            Me._RequestedStartDate = DateTime.Now
            Me._RequestedEndDate = DateTime.Now
            Me._CompletedDate = New DateTime
            Me._DateCreated = DateTime.Now
            Me._Manufacturer = ""
            Me._Model = ""
            Me._ConnectionString = ""
            Me._SerialNumber = ""
            Me._ServiceID = 0
            Me._InitialContact = New DateTime
            Me._LaborOnly = False
            Me._WorkOrderIDs = New List(Of Long)
            Me._MaximumCharge = 0
            Me._InvoiceID = 0
            Me._SupportAgentID = 0
            Me._TicketClaimApprovalStatusID = 0
            Me._ApprovalDate = New DateTime
            Me._WebInvoiceID = 0
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngTicketID As Long, ByVal strConnectionString As String)
            Me._Email = ""
            Me._TicketID = 0
            Me._ParentID = 0
            Me._CreatedBy = 0
            Me._AssignedTo = 0
            Me._CustomerID = 0
            Me._TicketStatusID = 0
            Me._StateID = 0
            Me._IncrementTypeID = 0
            Me._CompletedBy = 0
            Me._MileageStart = 0
            Me._MileageEnd = 0
            Me._WarrantyTermID = 0
            Me._InternalPrioritySetting = 0
            Me._CustomerPrioritySetting = 0
            Me._MinimumCharge = 0
            Me._ChargeRate = 0
            Me._AdjustCharge = 0
            Me._ReferenceNumber1 = ""
            Me._ReferenceNumber2 = ""
            Me._ReferenceNumber3 = ""
            Me._ReferenceNumber4 = ""
            Me._ContactFirstName = ""
            Me._ContactMiddleName = ""
            Me._ContactLastName = ""
            Me._Company = ""
            Me._Street = ""
            Me._Extended = ""
            Me._City = ""
            Me._ZipCode = ""
            Me._Description = ""
            Me._Instructions = ""
            Me._Notes = ""
            Me._ScheduledDate = New DateTime
            Me._ServiceStartDate = New DateTime
            Me._ServiceEndDate = New DateTime
            Me._ScheduledEndDate = New DateTime
            Me._PurchaseDate = New DateTime
            Me._WarrantyStart = New DateTime
            Me._WarrantyEnd = New DateTime
            Me._RequestedStartDate = DateTime.Now
            Me._RequestedEndDate = DateTime.Now
            Me._CompletedDate = New DateTime
            Me._DateCreated = DateTime.Now
            Me._Manufacturer = ""
            Me._Model = ""
            Me._ConnectionString = ""
            Me._SerialNumber = ""
            Me._ServiceID = 0
            Me._InitialContact = New DateTime
            Me._LaborOnly = False
            Me._WorkOrderIDs = New List(Of Long)
            Me._MaximumCharge = 0
            Me._InvoiceID = 0
            Me._SupportAgentID = 0
            Me._TicketClaimApprovalStatusID = 0
            Me._ApprovalDate = New DateTime
            Me._WebInvoiceID = 0
            Me._ConnectionString = strConnectionString
            Me.Load(Me._TicketID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal lngAssignedTo As Long, ByVal lngCustomerID As Long, ByVal lngTicketStatusID As Long, ByVal lngStateID As Long, ByVal lngServiceID As Long, ByVal lngIncrementTypeID As Long, ByVal lngWarrantyTermID As Long, ByVal intInternalPrioritySetting As Integer, ByVal intCustomerPrioritySetting As Integer, ByVal dblMinimumCharge As Double, ByVal dblChargeRate As Double, ByVal dblAdjustCharge As Double, ByVal strContactFirstName As String, ByVal strContactLastName As String, ByVal strStreet As String, ByVal strCity As String, ByVal strZipCode As String, ByVal strDescription As String, ByVal datRequestedStartDate As DateTime, ByVal datRequestedEndDate As DateTime)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddTicket")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngTicketID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@ServiceID", SqlDbType.Int).Value = lngServiceID
                cmd.Parameters.Add("@AssignedTo", SqlDbType.Int).Value = lngAssignedTo
                cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = lngCustomerID
                cmd.Parameters.Add("@TicketStatusID", SqlDbType.Int).Value = lngTicketStatusID
                cmd.Parameters.Add("@StateID", SqlDbType.Int).Value = lngStateID
                cmd.Parameters.Add("@IncrementTypeID", SqlDbType.Int).Value = lngIncrementTypeID
                cmd.Parameters.Add("@WarrantyTermID", SqlDbType.Int).Value = lngWarrantyTermID
                cmd.Parameters.Add("@InternalPrioritySetting", SqlDbType.TinyInt).Value = intInternalPrioritySetting
                cmd.Parameters.Add("@CustomerPrioritySetting", SqlDbType.TinyInt).Value = intCustomerPrioritySetting
                cmd.Parameters.Add("@MinimumCharge", SqlDbType.Money).Value = dblMinimumCharge
                cmd.Parameters.Add("@ChargeRate", SqlDbType.Money).Value = dblChargeRate
                cmd.Parameters.Add("@AdjustCharge", SqlDbType.Money).Value = dblAdjustCharge
                cmd.Parameters.Add("@ContactFirstName", SqlDbType.VarChar, Me.TrimTrunc(strContactFirstName, &H20).Length).Value = Me.TrimTrunc(strContactFirstName, &H20)
                cmd.Parameters.Add("@ContactLastName", SqlDbType.VarChar, Me.TrimTrunc(strContactLastName, &H40).Length).Value = Me.TrimTrunc(strContactLastName, &H40)
                cmd.Parameters.Add("@Street", SqlDbType.VarChar, Me.TrimTrunc(strStreet, &HFF).Length).Value = Me.TrimTrunc(strStreet, &HFF)
                cmd.Parameters.Add("@City", SqlDbType.VarChar, Me.TrimTrunc(strCity, &H80).Length).Value = Me.TrimTrunc(strCity, &H80)
                cmd.Parameters.Add("@ZipCode", SqlDbType.VarChar, Me.TrimTrunc(strZipCode, &H10).Length).Value = Me.TrimTrunc(strZipCode, &H10)
                cmd.Parameters.Add("@Description", SqlDbType.Text).Value = strDescription
                cmd.Parameters.Add("@RequestedStartDate", SqlDbType.DateTime).Value = datRequestedStartDate
                cmd.Parameters.Add("@RequestedEndDate", SqlDbType.DateTime).Value = datRequestedEndDate
                cnn.Open
                cmd.Connection = cnn
                lngTicketID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngTicketID > 0) Then
                    Me.Load(lngTicketID)
                    Dim x As New TicketFolderAssignmentRecord(Me._ConnectionString)
                    x.Add(1, lngTicketID, 1)
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
            Me._MaximumCharge = 0
            Me._WorkOrderIDs = New List(Of Long)
            Me._LaborOnly = False
            Me._InitialContact = New DateTime
            Me._Email = ""
            Me._ServiceID = 0
            Me._TicketID = 0
            Me._ParentID = 0
            Me._CreatedBy = 0
            Me._AssignedTo = 0
            Me._CustomerID = 0
            Me._TicketStatusID = 0
            Me._StateID = 0
            Me._IncrementTypeID = 0
            Me._CompletedBy = 0
            Me._MileageStart = 0
            Me._MileageEnd = 0
            Me._WarrantyTermID = 0
            Me._InternalPrioritySetting = 0
            Me._CustomerPrioritySetting = 0
            Me._MinimumCharge = 0
            Me._ChargeRate = 0
            Me._AdjustCharge = 0
            Me._ReferenceNumber1 = ""
            Me._ReferenceNumber2 = ""
            Me._ReferenceNumber3 = ""
            Me._ReferenceNumber4 = ""
            Me._ContactFirstName = ""
            Me._ContactMiddleName = ""
            Me._ContactLastName = ""
            Me._Company = ""
            Me._Street = ""
            Me._Extended = ""
            Me._City = ""
            Me._ZipCode = ""
            Me._Description = ""
            Me._Instructions = ""
            Me._Notes = ""
            Me._ScheduledDate = New DateTime
            Me._ServiceStartDate = New DateTime
            Me._ServiceEndDate = New DateTime
            Me._ScheduledEndDate = New DateTime
            Me._PurchaseDate = New DateTime
            Me._WarrantyStart = New DateTime
            Me._WarrantyEnd = New DateTime
            Me._RequestedStartDate = DateTime.Now
            Me._RequestedEndDate = DateTime.Now
            Me._CompletedDate = New DateTime
            Me._DateCreated = DateTime.Now
            Me._Manufacturer = ""
            Me._SerialNumber = ""
            Me._Model = ""
            Me._InvoiceID = 0
            Me._SupportAgentID = 0
            Me._TicketClaimApprovalStatusID = 0
            Me._ApprovalDate = New DateTime
            Me._WebInvoiceID = 0
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveTicket")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._TicketID)
            End If
        End Sub

        Private Function GetWorkOrderCount() As Long
            Dim lngReturn As Long = 0
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spCountTicketWorkOrders")
                cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
                cmd.CommandType = CommandType.StoredProcedure
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
            Dim obj As New TicketRecord(Me._TicketID, Me._ConnectionString)
            obj.Load(Me._TicketID)
            obj.Load(Me._TicketID)
            If (obj.MaximumCharge <> Me._MaximumCharge) Then
                blnReturn = True
            End If
            If (DateTime.Compare(obj.InitialContact, Me._InitialContact) <> 0) Then
                blnReturn = True
            End If
            If (obj.LaborOnly <> Me._LaborOnly) Then
                blnReturn = True
            End If
            If (obj.Email <> Me._Email) Then
                blnReturn = True
            End If
            If (obj.SerialNumber <> Me._SerialNumber) Then
                blnReturn = True
            End If
            If (obj.AssignedTo <> Me._AssignedTo) Then
                blnReturn = True
            End If
            If (obj.TicketStatusID <> Me._TicketStatusID) Then
                blnReturn = True
            End If
            If (obj.CustomerID <> Me._CustomerID) Then
                blnReturn = True
            End If
            If (obj.StateID <> Me._StateID) Then
                blnReturn = True
            End If
            If (obj.IncrementTypeID <> Me._IncrementTypeID) Then
                blnReturn = True
            End If
            If (obj.CompletedBy <> Me._CompletedBy) Then
                blnReturn = True
            End If
            If (obj.MileageStart <> Me._MileageStart) Then
                blnReturn = True
            End If
            If (obj.MileageEnd <> Me._MileageEnd) Then
                blnReturn = True
            End If
            If (obj.WarrantyTermID <> Me._WarrantyTermID) Then
                blnReturn = True
            End If
            If (obj.InternalPrioritySetting <> Me._InternalPrioritySetting) Then
                blnReturn = True
            End If
            If (obj.CustomerPrioritySetting <> Me._CustomerPrioritySetting) Then
                blnReturn = True
            End If
            If (obj.MinimumCharge <> Me._MinimumCharge) Then
                blnReturn = True
            End If
            If (obj.ChargeRate <> Me._ChargeRate) Then
                blnReturn = True
            End If
            If (obj.AdjustCharge <> Me._AdjustCharge) Then
                blnReturn = True
            End If
            If (obj.ReferenceNumber1 <> Me._ReferenceNumber1) Then
                blnReturn = True
            End If
            If (obj.ReferenceNumber2 <> Me._ReferenceNumber2) Then
                blnReturn = True
            End If
            If (obj.ReferenceNumber3 <> Me._ReferenceNumber3) Then
                blnReturn = True
            End If
            If (obj.ReferenceNumber4 <> Me._ReferenceNumber4) Then
                blnReturn = True
            End If
            If (obj.ContactFirstName <> Me._ContactFirstName) Then
                blnReturn = True
            End If
            If (obj.ContactMiddleName <> Me._ContactMiddleName) Then
                blnReturn = True
            End If
            If (obj.ContactLastName <> Me._ContactLastName) Then
                blnReturn = True
            End If
            If (obj.Company <> Me._Company) Then
                blnReturn = True
            End If
            If (obj.Street <> Me._Street) Then
                blnReturn = True
            End If
            If (obj.Extended <> Me._Extended) Then
                blnReturn = True
            End If
            If (obj.City <> Me._City) Then
                blnReturn = True
            End If
            If (obj.ZipCode <> Me._ZipCode) Then
                blnReturn = True
            End If
            If (obj.Description <> Me._Description) Then
                blnReturn = True
            End If
            If (obj.Instructions <> Me._Instructions) Then
                blnReturn = True
            End If
            If (obj.Notes <> Me._Notes) Then
                blnReturn = True
            End If
            If (DateTime.Compare(obj.DateCreated, Me._DateCreated) <> 0) Then
                blnReturn = True
            End If
            If (DateTime.Compare(obj.ScheduledDate, Me._ScheduledDate) <> 0) Then
                blnReturn = True
            End If
            If (DateTime.Compare(obj.ServiceStartDate, Me._ServiceStartDate) <> 0) Then
                blnReturn = True
            End If
            If (DateTime.Compare(obj.ServiceEndDate, Me._ServiceEndDate) <> 0) Then
                blnReturn = True
            End If
            If (DateTime.Compare(obj.ScheduledEndDate, Me._ScheduledEndDate) <> 0) Then
                blnReturn = True
            End If
            If (DateTime.Compare(obj.PurchaseDate, Me._PurchaseDate) <> 0) Then
                blnReturn = True
            End If
            If (DateTime.Compare(obj.WarrantyStart, Me._WarrantyStart) <> 0) Then
                blnReturn = True
            End If
            If (DateTime.Compare(obj.WarrantyEnd, Me._WarrantyEnd) <> 0) Then
                blnReturn = True
            End If
            If (DateTime.Compare(obj.RequestedStartDate, Me._RequestedStartDate) <> 0) Then
                blnReturn = True
            End If
            If (DateTime.Compare(obj.RequestedEndDate, Me._RequestedEndDate) <> 0) Then
                blnReturn = True
            End If
            If (DateTime.Compare(obj.CompletedDate, Me._CompletedDate) <> 0) Then
                blnReturn = True
            End If
            If (obj.ServiceID <> Me._ServiceID) Then
                blnReturn = True
            End If
            If (obj.Manufacturer <> Me._Manufacturer) Then
                blnReturn = True
            End If
            If (obj.ParentID <> Me._ParentID) Then
                blnReturn = True
            End If
            If (obj.SupportAgentID <> Me._SupportAgentID) Then
                blnReturn = True
            End If
            If (obj.Model <> Me._Model) Then
                blnReturn = True
            End If
            If (obj.InvoiceID <> Me._InvoiceID) Then
                blnReturn = True
            End If
            If obj.TicketClaimApprovalStatusID <> _TicketClaimApprovalStatusID Then
                blnReturn = True
            End If
            If obj.ApprovalDate <> _ApprovalDate Then
                blnReturn = True
            End If
            If obj.WebInvoiceID <> _WebInvoiceID Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngTicketID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetTicket")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = lngTicketID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._TicketID = Conversions.ToLong(dtr.Item("TicketID"))
                    Me._LaborOnly = Conversions.ToBoolean(dtr.Item("LaborOnly"))
                    Me._ServiceID = Conversions.ToLong(dtr.Item("ServiceID"))
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("ParentID"))) Then
                        Me._ParentID = Conversions.ToLong(dtr.Item("ParentID"))
                    Else
                        Me._ParentID = 0
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("SupportAgentID"))) Then
                        Me._SupportAgentID = Conversions.ToLong(dtr.Item("SupportAgentID"))
                    Else
                        Me._SupportAgentID = 0
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("InitialContact"))) Then
                        Me._InitialContact = Conversions.ToDate(dtr.Item("InitialContact"))
                    Else
                        Me._InitialContact = New DateTime
                    End If
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._AssignedTo = Conversions.ToLong(dtr.Item("AssignedTo"))
                    Me._CustomerID = Conversions.ToLong(dtr.Item("CustomerID"))
                    Me._TicketStatusID = Conversions.ToLong(dtr.Item("TicketStatusID"))
                    Me._StateID = Conversions.ToLong(dtr.Item("StateID"))
                    Me._CustomerID = Conversions.ToLong(dtr.Item("CustomerID"))
                    Me._IncrementTypeID = Conversions.ToLong(dtr.Item("IncrementTypeID"))
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("CompletedBy"))) Then
                        Me._CompletedBy = Conversions.ToLong(dtr.Item("CompletedBy"))
                    Else
                        Me._CompletedBy = 0
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("SerialNumber"))) Then
                        Me._SerialNumber = dtr.Item("SerialNumber").ToString
                    Else
                        Me._SerialNumber = ""
                    End If
                    Me._MileageStart = Conversions.ToLong(dtr.Item("MileageStart"))
                    Me._MileageEnd = Conversions.ToLong(dtr.Item("MileageEnd"))
                    Me._WarrantyTermID = Conversions.ToLong(dtr.Item("WarrantyTermID"))
                    Me._InternalPrioritySetting = Conversions.ToInteger(dtr.Item("InternalPrioritySetting"))
                    Me._CustomerPrioritySetting = Conversions.ToInteger(dtr.Item("CustomerPrioritySetting"))
                    Me._MinimumCharge = Conversions.ToDouble(dtr.Item("MinimumCharge"))
                    Me._ChargeRate = Conversions.ToDouble(dtr.Item("ChargeRate"))
                    Me._AdjustCharge = Conversions.ToDouble(dtr.Item("AdjustCharge"))
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("ReferenceNumber1"))) Then
                        Me._ReferenceNumber1 = dtr.Item("ReferenceNumber1").ToString
                    Else
                        Me._ReferenceNumber1 = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("ReferenceNumber2"))) Then
                        Me._ReferenceNumber2 = dtr.Item("ReferenceNumber2").ToString
                    Else
                        Me._ReferenceNumber2 = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("ReferenceNumber3"))) Then
                        Me._ReferenceNumber3 = dtr.Item("ReferenceNumber3").ToString
                    Else
                        Me._ReferenceNumber3 = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("ReferenceNumber4"))) Then
                        Me._ReferenceNumber4 = dtr.Item("ReferenceNumber4").ToString
                    Else
                        Me._ReferenceNumber4 = ""
                    End If
                    Me._ContactFirstName = dtr.Item("ContactFirstName").ToString
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("ContactMiddleName"))) Then
                        Me._ContactMiddleName = dtr.Item("ContactMiddleName").ToString
                    Else
                        Me._ContactMiddleName = ""
                    End If
                    Me._ContactLastName = dtr.Item("ContactLastName").ToString
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Company"))) Then
                        Me._Company = dtr.Item("Company").ToString
                    Else
                        Me._Company = ""
                    End If
                    Me._Street = dtr.Item("Street").ToString
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Extended"))) Then
                        Me._Extended = dtr.Item("Extended").ToString
                    Else
                        Me._Extended = ""
                    End If
                    Me._City = dtr.Item("City").ToString
                    Me._ZipCode = dtr.Item("ZipCode").ToString
                    Me._Description = dtr.Item("Description").ToString
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Instructions"))) Then
                        Me._Instructions = dtr.Item("Instructions").ToString
                    Else
                        Me._Instructions = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Notes"))) Then
                        Me._Notes = dtr.Item("Notes").ToString
                    Else
                        Me._Notes = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("ScheduledDate"))) Then
                        Me._ScheduledDate = Conversions.ToDate(dtr.Item("ScheduledDate"))
                    Else
                        Me._ScheduledDate = New DateTime
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("ServiceStartDate"))) Then
                        Me._ServiceStartDate = Conversions.ToDate(dtr.Item("ServiceStartDate"))
                    Else
                        Me._ServiceStartDate = New DateTime
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("ServiceEndDate"))) Then
                        Me._ServiceEndDate = Conversions.ToDate(dtr.Item("ServiceEndDate"))
                    Else
                        Me._ServiceEndDate = New DateTime
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("ScheduledEndDate"))) Then
                        Me._ScheduledEndDate = Conversions.ToDate(dtr.Item("ScheduledEndDate"))
                    Else
                        Me._ScheduledEndDate = New DateTime
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("PurchaseDate"))) Then
                        Me._PurchaseDate = Conversions.ToDate(dtr.Item("PurchaseDate"))
                    Else
                        Me._PurchaseDate = New DateTime
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("WarrantyStart"))) Then
                        Me._WarrantyStart = Conversions.ToDate(dtr.Item("WarrantyStart"))
                    Else
                        Me._WarrantyStart = New DateTime
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("WarrantyEnd"))) Then
                        Me._WarrantyEnd = Conversions.ToDate(dtr.Item("WarrantyEnd"))
                    Else
                        Me._WarrantyEnd = New DateTime
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Email"))) Then
                        Me._Email = dtr.Item("Email").ToString
                    Else
                        Me._Email = ""
                    End If
                    Me._RequestedStartDate = Conversions.ToDate(dtr.Item("RequestedStartDate"))
                    Me._RequestedEndDate = Conversions.ToDate(dtr.Item("RequestedEndDate"))
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("CompletedDate"))) Then
                        Me._CompletedDate = Conversions.ToDate(dtr.Item("CompletedDate"))
                    Else
                        Me._CompletedDate = New DateTime
                    End If
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Manufacturer"))) Then
                        Me._Manufacturer = dtr.Item("Manufacturer").ToString
                    Else
                        Me._Manufacturer = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Model"))) Then
                        Me._Model = dtr.Item("Model").ToString
                    Else
                        Me._Model = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("InvoiceID"))) Then
                        Me._InvoiceID = dtr.Item("InvoiceID").ToString
                    Else
                        Me._InvoiceID = 0
                    End If
                    Me._MaximumCharge = Conversions.ToDouble(dtr.Item("MaximumCharge"))

                    If Not IsDBNull(dtr("TicketClaimApprovalStatusID")) Then
                        Me._TicketClaimApprovalStatusID = CType(dtr("TicketClaimApprovalStatusID"), Long)
                    Else
                        Me._TicketClaimApprovalStatusID = 0
                    End If
                    If Not IsDBNull(dtr("ApprovalDate")) Then
                        Me._ApprovalDate = CType(dtr("ApprovalDate"), Date)
                    Else
                        Me._ApprovalDate = DateTime.Now
                    End If
                    If Not IsDBNull(dtr("WebInvoiceID")) Then
                        Me._WebInvoiceID = CType(dtr("WebInvoiceID"), Long)
                    Else
                        Me._WebInvoiceID = 0
                    End If


                    dtr.Close
                    Me.LoadWorkOrderIDs
                    Me.RunFolderCode((cnn))
                Else
                    Me.ClearValues
                End If
                cnn.Close
            End If
        End Sub

        Private Sub LoadWorkOrderIDs()
            Me._WorkOrderIDs = New List(Of Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spListWorkOrders")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                Do While dtr.Read
                    Me._WorkOrderIDs.Add(Conversions.ToLong(dtr.Item("WorkOrderID")))
                Loop
                dtr.Close
                cnn.Close
                cmd.Dispose
                cnn.Dispose
            End If
        End Sub

        Private Sub RunFolderCode(ByRef cnn As SqlConnection)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cmd As New SqlCommand("spTicketFolderCode")
                cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
            End If
        End Sub
        

        Public Sub Save(ByRef strChangeLog As String)
            strChangeLog = ""
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim strTemp As String = ""
                Dim cnn As New SqlConnection(Me._ConnectionString)
                cnn.Open
                Dim obj As New TicketRecord(Me._TicketID, Me._ConnectionString)
                obj.Load(Me._TicketID)
                If (obj.AssignedTo <> Me._AssignedTo) Then
                    Me.UpdateAssignedTo(Me._AssignedTo, (cnn))
                    strTemp = String.Concat(New String() { "AssignedTo Changed to '", Conversions.ToString(Me._AssignedTo), "' from '", Conversions.ToString(obj.AssignedTo), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.LaborOnly <> Me._LaborOnly) Then
                    Me.UpdateLaborOnly(Me._LaborOnly, (cnn))
                    strTemp = String.Concat(New String() { "LaborOnly Changed to '", Conversions.ToString(Me._LaborOnly), "' from '", Conversions.ToString(obj.LaborOnly), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ParentID <> Me._ParentID) Then
                    Me.UpdateParentID(Me._ParentID, (cnn))
                    strTemp = String.Concat(New String() { "ParentID Changed to '", Conversions.ToString(Me._ParentID), "' from '", Conversions.ToString(obj.ParentID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.CustomerID <> Me._CustomerID) Then
                    Me.UpdateCustomerID(Me._CustomerID, (cnn))
                    strTemp = String.Concat(New String() {"CustomerID Changed to '", Conversions.ToString(Me._CustomerID), "' from '", Conversions.ToString(obj.CustomerID), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Email <> Me._Email) Then
                    Me.UpdateEmail(Me._Email, (cnn))
                    strTemp = String.Concat(New String() { "Email Changed to '", Me._Email, "' from '", obj.Email, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.TicketStatusID <> Me._TicketStatusID) Then
                    Me.UpdateTicketStatusID(Me._TicketStatusID, (cnn))
                    strTemp = String.Concat(New String() { "TicketStatusID Changed to '", Conversions.ToString(Me._TicketStatusID), "' from '", Conversions.ToString(obj.TicketStatusID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (DateTime.Compare(obj.InitialContact, Me._InitialContact) <> 0) Then
                    Me.UpdateInitialContact(Me._InitialContact, (cnn))
                    strTemp = String.Concat(New String() { "InitialContact Changed to '", Conversions.ToString(Me._InitialContact), "' from '", Conversions.ToString(obj.InitialContact), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ServiceID <> Me._ServiceID) Then
                    Me.UpdateServiceID(Me._ServiceID, (cnn))
                    strTemp = String.Concat(New String() { "ServiceID Changed to '", Conversions.ToString(Me._ServiceID), "' from '", Conversions.ToString(obj.ServiceID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.StateID <> Me._StateID) Then
                    Me.UpdateStateID(Me._StateID, (cnn))
                    strTemp = String.Concat(New String() { "StateID Changed to '", Conversions.ToString(Me._StateID), "' from '", Conversions.ToString(obj.StateID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.SerialNumber <> Me._SerialNumber) Then
                    Me.UpdateSerialNumber(Me._SerialNumber, (cnn))
                    strTemp = String.Concat(New String() { "SerialNumber Changed to '", Me._SerialNumber, "' from '", obj.SerialNumber, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.IncrementTypeID <> Me._IncrementTypeID) Then
                    Me.UpdateIncrementTypeID(Me._IncrementTypeID, (cnn))
                    strTemp = String.Concat(New String() { "IncrementTypeID Changed to '", Conversions.ToString(Me._IncrementTypeID), "' from '", Conversions.ToString(obj.IncrementTypeID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.CompletedBy <> Me._CompletedBy) Then
                    Me.UpdateCompletedBy(Me._CompletedBy, (cnn))
                    strTemp = String.Concat(New String() { "CompletedBy Changed to '", Conversions.ToString(Me._CompletedBy), "' from '", Conversions.ToString(obj.CompletedBy), "'" })
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
                If (obj.WarrantyTermID <> Me._WarrantyTermID) Then
                    Me.UpdateWarrantyTermID(Me._WarrantyTermID, (cnn))
                    strTemp = String.Concat(New String() { "WarrantyTermID Changed to '", Conversions.ToString(Me._WarrantyTermID), "' from '", Conversions.ToString(obj.WarrantyTermID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.InvoiceID <> Me._InvoiceID) Then
                    Me.UpdateTicketInvoiceID(Me._InvoiceID, (cnn))
                    strTemp = String.Concat(New String() {"InvoiceID Changed to '", Conversions.ToString(Me._InvoiceID), "' from '", Conversions.ToString(obj.InvoiceID), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.SupportAgentID <> Me._SupportAgentID) Then
                    Me.UpdateSupportAgentID(Me._SupportAgentID, (cnn))
                    strTemp = String.Concat(New String() {"SupportAgentID Changed to '", Conversions.ToString(Me._SupportAgentID), "' from '", Conversions.ToString(obj.SupportAgentID), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.InternalPrioritySetting <> Me._InternalPrioritySetting) Then
                    Me.UpdateInternalPrioritySetting(Me._InternalPrioritySetting, (cnn))
                    strTemp = String.Concat(New String() { "InternalPrioritySetting Changed to '", Conversions.ToString(Me._InternalPrioritySetting), "' from '", Conversions.ToString(obj.InternalPrioritySetting), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.CustomerPrioritySetting <> Me._CustomerPrioritySetting) Then
                    Me.UpdateCustomerPrioritySetting(Me._CustomerPrioritySetting, (cnn))
                    strTemp = String.Concat(New String() { "CustomerPrioritySetting Changed to '", Conversions.ToString(Me._CustomerPrioritySetting), "' from '", Conversions.ToString(obj.CustomerPrioritySetting), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.MinimumCharge <> Me._MinimumCharge) Then
                    Me.UpdateMinimumCharge(Me._MinimumCharge, (cnn))
                    strTemp = String.Concat(New String() { "MinimumCharge Changed to '", Conversions.ToString(Me._MinimumCharge), "' from '", Conversions.ToString(obj.MinimumCharge), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ChargeRate <> Me._ChargeRate) Then
                    Me.UpdateChargeRate(Me._ChargeRate, (cnn))
                    strTemp = String.Concat(New String() { "ChargeRate Changed to '", Conversions.ToString(Me._ChargeRate), "' from '", Conversions.ToString(obj.ChargeRate), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.AdjustCharge <> Me._AdjustCharge) Then
                    Me.UpdateAdjustCharge(Me._AdjustCharge, (cnn))
                    strTemp = String.Concat(New String() { "AdjustCharge Changed to '", Conversions.ToString(Me._AdjustCharge), "' from '", Conversions.ToString(obj.AdjustCharge), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ReferenceNumber1 <> Me._ReferenceNumber1) Then
                    Me.UpdateReferenceNumber1(Me._ReferenceNumber1, (cnn))
                    strTemp = String.Concat(New String() { "ReferenceNumber1 Changed to '", Me._ReferenceNumber1, "' from '", obj.ReferenceNumber1, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ReferenceNumber2 <> Me._ReferenceNumber2) Then
                    Me.UpdateReferenceNumber2(Me._ReferenceNumber2, (cnn))
                    strTemp = String.Concat(New String() { "ReferenceNumber2 Changed to '", Me._ReferenceNumber2, "' from '", obj.ReferenceNumber2, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ReferenceNumber3 <> Me._ReferenceNumber3) Then
                    Me.UpdateReferenceNumber3(Me._ReferenceNumber3, (cnn))
                    strTemp = String.Concat(New String() { "ReferenceNumber3 Changed to '", Me._ReferenceNumber3, "' from '", obj.ReferenceNumber3, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ReferenceNumber4 <> Me._ReferenceNumber4) Then
                    Me.UpdateReferenceNumber4(Me._ReferenceNumber4, (cnn))
                    strTemp = String.Concat(New String() { "ReferenceNumber4 Changed to '", Me._ReferenceNumber4, "' from '", obj.ReferenceNumber4, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ContactFirstName <> Me._ContactFirstName) Then
                    Me.UpdateContactFirstName(Me._ContactFirstName, (cnn))
                    strTemp = String.Concat(New String() { "ContactFirstName Changed to '", Me._ContactFirstName, "' from '", obj.ContactFirstName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ContactMiddleName <> Me._ContactMiddleName) Then
                    Me.UpdateContactMiddleName(Me._ContactMiddleName, (cnn))
                    strTemp = String.Concat(New String() { "ContactMiddleName Changed to '", Me._ContactMiddleName, "' from '", obj.ContactMiddleName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ContactLastName <> Me._ContactLastName) Then
                    Me.UpdateContactLastName(Me._ContactLastName, (cnn))
                    strTemp = String.Concat(New String() { "ContactLastName Changed to '", Me._ContactLastName, "' from '", obj.ContactLastName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Company <> Me._Company) Then
                    Me.UpdateCompany(Me._Company, (cnn))
                    strTemp = String.Concat(New String() { "Company Changed to '", Me._Company, "' from '", obj.Company, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Street <> Me._Street) Then
                    Me.UpdateStreet(Me._Street, (cnn))
                    strTemp = String.Concat(New String() { "Street Changed to '", Me._Street, "' from '", obj.Street, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Extended <> Me._Extended) Then
                    Me.UpdateExtended(Me._Extended, (cnn))
                    strTemp = String.Concat(New String() { "Extended Changed to '", Me._Extended, "' from '", obj.Extended, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.City <> Me._City) Then
                    Me.UpdateCity(Me._City, (cnn))
                    strTemp = String.Concat(New String() { "City Changed to '", Me._City, "' from '", obj.City, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ZipCode <> Me._ZipCode) Then
                    Me.UpdateZipCode(Me._ZipCode, (cnn))
                    strTemp = String.Concat(New String() { "ZipCode Changed to '", Me._ZipCode, "' from '", obj.ZipCode, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Description <> Me._Description) Then
                    Me.UpdateDescription(Me._Description, (cnn))
                    strTemp = String.Concat(New String() { "Description Changed to '", Me._Description, "' from '", obj.Description, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Instructions <> Me._Instructions) Then
                    Me.UpdateInstructions(Me._Instructions, (cnn))
                    strTemp = String.Concat(New String() { "Instructions Changed to '", Me._Instructions, "' from '", obj.Instructions, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Notes <> Me._Notes) Then
                    Me.UpdateNotes(Me._Notes, (cnn))
                    strTemp = String.Concat(New String() { "Notes Changed to '", Me._Notes, "' from '", obj.Notes, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (DateTime.Compare(obj.DateCreated, Me._DateCreated) <> 0) Then
                    Me.UpdateDateCreated((Me._DateCreated), (cnn))
                End If
                If (DateTime.Compare(obj.ScheduledDate, Me._ScheduledDate) <> 0) Then
                    Me.UpdateScheduledDate((Me._ScheduledDate), (cnn))
                End If
                If (DateTime.Compare(obj.ServiceStartDate, Me._ServiceStartDate) <> 0) Then
                    Me.UpdateServiceStartDate((Me._ServiceStartDate), (cnn))
                End If
                If (DateTime.Compare(obj.ServiceEndDate, Me._ServiceEndDate) <> 0) Then
                    Me.UpdateServiceEndDate((Me._ServiceEndDate), (cnn))
                End If
                If (DateTime.Compare(obj.ScheduledEndDate, Me._ScheduledEndDate) <> 0) Then
                    Me.UpdateScheduledEndDate((Me._ScheduledEndDate), (cnn))
                End If
                If (DateTime.Compare(obj.PurchaseDate, Me._PurchaseDate) <> 0) Then
                    Me.UpdatePurchaseDate((Me._PurchaseDate), (cnn))
                End If
                If (DateTime.Compare(obj.WarrantyStart, Me._WarrantyStart) <> 0) Then
                    Me.UpdateWarrantyStart((Me._WarrantyStart), (cnn))
                End If
                If (DateTime.Compare(obj.WarrantyEnd, Me._WarrantyEnd) <> 0) Then
                    Me.UpdateWarrantyEnd((Me._WarrantyEnd), (cnn))
                End If
                If (DateTime.Compare(obj.RequestedStartDate, Me._RequestedStartDate) <> 0) Then
                    Me.UpdateRequestedStartDate(Me._RequestedStartDate, (cnn))
                    strTemp = String.Concat(New String() { "RequestedStartDate Changed to '", Conversions.ToString(Me._RequestedStartDate), "' from '", Conversions.ToString(obj.RequestedStartDate), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (DateTime.Compare(obj.RequestedEndDate, Me._RequestedEndDate) <> 0) Then
                    Me.UpdateRequestedEndDate(Me._RequestedEndDate, (cnn))
                    strTemp = String.Concat(New String() { "RequestedEndDate Changed to '", Conversions.ToString(Me._RequestedEndDate), "' from '", Conversions.ToString(obj.RequestedEndDate), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (DateTime.Compare(obj.CompletedDate, Me._CompletedDate) <> 0) Then
                    Me.UpdateCompletedDate((Me._CompletedDate), (cnn))
                End If
                If (obj.Manufacturer <> Me._Manufacturer) Then
                    Me.UpdateManufacturer(Me._Manufacturer, (cnn))
                    strTemp = String.Concat(New String() { "Manufacturer Changed to '", Me._Manufacturer, "' from '", obj.Manufacturer, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Model <> Me._Model) Then
                    Me.UpdateModel(Me._Model, (cnn))
                    strTemp = String.Concat(New String() { "Model Changed to '", Me._Model, "' from '", obj.Model, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.MaximumCharge <> Me._MaximumCharge) Then
                    Me.UpdateMaximumCharge(Me._MaximumCharge, (cnn))
                    strTemp = String.Concat(New String() { "MaximumCharge Changed to '", Conversions.ToString(Me._MaximumCharge), "' from '", Conversions.ToString(obj.MaximumCharge), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.TicketClaimApprovalStatusID <> Me._TicketClaimApprovalStatusID) Then
                    Me.UpdateTicketClaimApprovalStatusID(Me._TicketClaimApprovalStatusID, cnn)
                    'strTemp = "TicketClaimApprovalStatusID Changed to '" & _TicketClaimApprovalStatusID & "' from '" & obj.TicketClaimApprovalStatusID & "'"
                    'AppendChangeLog(strChangeLog, strTemp)
                End If
                If (obj.ApprovalDate <> _ApprovalDate) Then
                    Me.UpdateApprovalDate(Me._ApprovalDate, cnn)
                    'strTemp = "ApprovalDate Changed to '" & _ApprovalDate & "' from '" & obj.ApprovalDate & "'"
                    'AppendChangeLog(strChangeLog, strTemp)
                End If
                If (obj.WebInvoiceID <> Me._WebInvoiceID) Then
                    Me.UpdateWebInvoiceID(Me._WebInvoiceID, cnn)
                    'strTemp = "TicketClaimApprovalStatusID Changed to '" & _TicketClaimApprovalStatusID & "' from '" & obj.TicketClaimApprovalStatusID & "'"
                    'AppendChangeLog(strChangeLog, strTemp)
                End If


                Me.RunFolderCode((cnn))
                cnn.Close
                Me.Load(Me._TicketID)
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

        Private Sub UpdateAdjustCharge(ByVal NewAdjustCharge As Double, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketAdjustCharge")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            cmd.Parameters.Add("@AdjustCharge", SqlDbType.Money).Value = NewAdjustCharge
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateAssignedTo(ByVal NewAssignedTo As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketAssignedTo")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            cmd.Parameters.Add("@AssignedTo", SqlDbType.Int).Value = NewAssignedTo
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateChargeRate(ByVal NewChargeRate As Double, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketChargeRate")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            cmd.Parameters.Add("@ChargeRate", SqlDbType.Money).Value = NewChargeRate
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCity(ByVal NewCity As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketCity")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            cmd.Parameters.Add("@City", SqlDbType.VarChar, Me.TrimTrunc(NewCity, &H80).Length).Value = Me.TrimTrunc(NewCity, &H80)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCompany(ByVal NewCompany As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketCompany")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            If (NewCompany.Trim.Length > 0) Then
                cmd.Parameters.Add("@Company", SqlDbType.VarChar, Me.TrimTrunc(NewCompany, &H80).Length).Value = Me.TrimTrunc(NewCompany, &H80)
            Else
                cmd.Parameters.Add("@Company", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCompletedBy(ByVal NewCompletedBy As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketCompletedBy")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            If (NewCompletedBy > 0) Then
                cmd.Parameters.Add("@CompletedBy", SqlDbType.Int).Value = NewCompletedBy
            Else
                cmd.Parameters.Add("@CompletedBy", SqlDbType.Int).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCompletedDate(ByRef NewCompletedDate As DateTime, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketCompletedDate")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            Dim datNothing As New DateTime
            If (DateTime.Compare(NewCompletedDate, datNothing) <> 0) Then
                cmd.Parameters.Add("@CompletedDate", SqlDbType.DateTime).Value = CDate(NewCompletedDate)
            Else
                cmd.Parameters.Add("@CompletedDate", SqlDbType.DateTime).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateContactFirstName(ByVal NewContactFirstName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketContactFirstName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            cmd.Parameters.Add("@ContactFirstName", SqlDbType.VarChar, Me.TrimTrunc(NewContactFirstName, &H20).Length).Value = Me.TrimTrunc(NewContactFirstName, &H20)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateContactLastName(ByVal NewContactLastName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketContactLastName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            cmd.Parameters.Add("@ContactLastName", SqlDbType.VarChar, Me.TrimTrunc(NewContactLastName, &H40).Length).Value = Me.TrimTrunc(NewContactLastName, &H40)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateContactMiddleName(ByVal NewContactMiddleName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketContactMiddleName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            If (NewContactMiddleName.Trim.Length > 0) Then
                cmd.Parameters.Add("@ContactMiddleName", SqlDbType.VarChar, Me.TrimTrunc(NewContactMiddleName, &H20).Length).Value = Me.TrimTrunc(NewContactMiddleName, &H20)
            Else
                cmd.Parameters.Add("@ContactMiddleName", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCustomerPrioritySetting(ByVal NewCustomerPrioritySetting As Integer, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketCustomerPrioritySetting")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            cmd.Parameters.Add("@CustomerPrioritySetting", SqlDbType.TinyInt).Value = NewCustomerPrioritySetting
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateDescription(ByVal NewDescription As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketDescription")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            cmd.Parameters.Add("@Description", SqlDbType.Text).Value = NewDescription
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateEmail(ByVal NewEmail As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketEmail")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            If (NewEmail.Trim.Length > 0) Then
                cmd.Parameters.Add("@Email", SqlDbType.VarChar, Me.TrimTrunc(NewEmail, &HFF).Length).Value = Me.TrimTrunc(NewEmail, &HFF)
            Else
                cmd.Parameters.Add("@Email", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateExtended(ByVal NewExtended As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketExtended")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            If (NewExtended.Trim.Length > 0) Then
                cmd.Parameters.Add("@Extended", SqlDbType.VarChar, Me.TrimTrunc(NewExtended, &HFF).Length).Value = Me.TrimTrunc(NewExtended, &HFF)
            Else
                cmd.Parameters.Add("@Extended", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateIncrementTypeID(ByVal NewIncrementTypeID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketIncrementTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            cmd.Parameters.Add("@IncrementTypeID", SqlDbType.Int).Value = NewIncrementTypeID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub
        Private Sub UpdateCustomerID(ByVal NewCustomerID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketCustomerID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = NewCustomerID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdateInitialContact(ByVal NewInitialContact As DateTime, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketInitialContact")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            Dim datNothing As New DateTime
            If (DateTime.Compare(NewInitialContact, datNothing) <> 0) Then
                cmd.Parameters.Add("@InitialContact", SqlDbType.DateTime).Value = NewInitialContact
            Else
                cmd.Parameters.Add("@InitialContact", SqlDbType.DateTime).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateInstructions(ByVal NewInstructions As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketInstructions")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            If (NewInstructions.Trim.Length > 0) Then
                cmd.Parameters.Add("@Instructions", SqlDbType.Text).Value = NewInstructions
            Else
                cmd.Parameters.Add("@Instructions", SqlDbType.Text).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateInternalPrioritySetting(ByVal NewInternalPrioritySetting As Integer, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketInternalPrioritySetting")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            cmd.Parameters.Add("@InternalPrioritySetting", SqlDbType.TinyInt).Value = NewInternalPrioritySetting
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateLaborOnly(ByVal NewLaborOnly As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketLaborOnly")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            cmd.Parameters.Add("@LaborOnly", SqlDbType.Bit).Value = NewLaborOnly
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateManufacturer(ByVal NewManufacturer As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketManufacturer")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            If (NewManufacturer.Trim.Length > 0) Then
                cmd.Parameters.Add("@Manufacturer", SqlDbType.VarChar, Me.TrimTrunc(NewManufacturer, &H80).Length).Value = Me.TrimTrunc(NewManufacturer, &H80)
            Else
                cmd.Parameters.Add("@Manufacturer", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateMaximumCharge(ByVal NewMaximumCharge As Double, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketMaximumCharge")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            cmd.Parameters.Add("@MaximumCharge", SqlDbType.Money).Value = NewMaximumCharge
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateMileageEnd(ByVal NewMileageEnd As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketMileageEnd")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            cmd.Parameters.Add("@MileageEnd", SqlDbType.Int).Value = NewMileageEnd
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateMileageStart(ByVal NewMileageStart As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketMileageStart")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            cmd.Parameters.Add("@MileageStart", SqlDbType.Int).Value = NewMileageStart
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateMinimumCharge(ByVal NewMinimumCharge As Double, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketMinimumCharge")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            cmd.Parameters.Add("@MinimumCharge", SqlDbType.Money).Value = NewMinimumCharge
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateModel(ByVal NewModel As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketModel")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            If (NewModel.Trim.Length > 0) Then
                cmd.Parameters.Add("@Model", SqlDbType.VarChar, Me.TrimTrunc(NewModel, &HDA).Length).Value = Me.TrimTrunc(NewModel, &HDA)
            Else
                cmd.Parameters.Add("@Model", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateNotes(ByVal NewNotes As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketNotes")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            If (NewNotes.Trim.Length > 0) Then
                cmd.Parameters.Add("@Notes", SqlDbType.Text).Value = NewNotes
            Else
                cmd.Parameters.Add("@Notes", SqlDbType.Text).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateParentID(ByVal NewParentID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketParentID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            If (NewParentID > 0) Then
                cmd.Parameters.Add("@ParentID", SqlDbType.Int).Value = NewParentID
            Else
                cmd.Parameters.Add("@ParentID", SqlDbType.Int).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdatePurchaseDate(ByRef NewPurchaseDate As DateTime, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketPurchaseDate")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            Dim datNothing As New DateTime
            If (DateTime.Compare(NewPurchaseDate, datNothing) <> 0) Then
                cmd.Parameters.Add("@PurchaseDate", SqlDbType.DateTime).Value = CDate(NewPurchaseDate)
            Else
                cmd.Parameters.Add("@PurchaseDate", SqlDbType.DateTime).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateReferenceNumber1(ByVal NewReferenceNumber1 As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketReferenceNumber1")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            If (NewReferenceNumber1.Trim.Length > 0) Then
                cmd.Parameters.Add("@ReferenceNumber1", SqlDbType.VarChar, Me.TrimTrunc(NewReferenceNumber1, &HFF).Length).Value = Me.TrimTrunc(NewReferenceNumber1, &HFF)
            Else
                cmd.Parameters.Add("@ReferenceNumber1", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateReferenceNumber2(ByVal NewReferenceNumber2 As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketReferenceNumber2")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            If (NewReferenceNumber2.Trim.Length > 0) Then
                cmd.Parameters.Add("@ReferenceNumber2", SqlDbType.VarChar, Me.TrimTrunc(NewReferenceNumber2, &HFF).Length).Value = Me.TrimTrunc(NewReferenceNumber2, &HFF)
            Else
                cmd.Parameters.Add("@ReferenceNumber2", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateReferenceNumber3(ByVal NewReferenceNumber3 As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketReferenceNumber3")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            If (NewReferenceNumber3.Trim.Length > 0) Then
                cmd.Parameters.Add("@ReferenceNumber3", SqlDbType.VarChar, Me.TrimTrunc(NewReferenceNumber3, &HFF).Length).Value = Me.TrimTrunc(NewReferenceNumber3, &HFF)
            Else
                cmd.Parameters.Add("@ReferenceNumber3", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateReferenceNumber4(ByVal NewReferenceNumber4 As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketReferenceNumber4")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            If (NewReferenceNumber4.Trim.Length > 0) Then
                cmd.Parameters.Add("@ReferenceNumber4", SqlDbType.VarChar, Me.TrimTrunc(NewReferenceNumber4, &HFF).Length).Value = Me.TrimTrunc(NewReferenceNumber4, &HFF)
            Else
                cmd.Parameters.Add("@ReferenceNumber4", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateRequestedEndDate(ByVal NewRequestedEndDate As DateTime, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketRequestedEndDate")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            cmd.Parameters.Add("@RequestedEndDate", SqlDbType.DateTime).Value = NewRequestedEndDate
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateRequestedStartDate(ByVal NewRequestedStartDate As DateTime, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketRequestedStartDate")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            cmd.Parameters.Add("@RequestedStartDate", SqlDbType.DateTime).Value = NewRequestedStartDate
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateScheduledDate(ByRef NewScheduledDate As DateTime, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketScheduledDate")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            Dim datNothing As New DateTime
            If (DateTime.Compare(NewScheduledDate, datNothing) <> 0) Then
                cmd.Parameters.Add("@ScheduledDate", SqlDbType.DateTime).Value = CDate(NewScheduledDate)
            Else
                cmd.Parameters.Add("@ScheduledDate", SqlDbType.DateTime).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateScheduledEndDate(ByRef NewScheduledEndDate As DateTime, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketScheduledEndDate")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            Dim datNothing As New DateTime
            If (DateTime.Compare(NewScheduledEndDate, datNothing) <> 0) Then
                cmd.Parameters.Add("@ScheduledEndDate", SqlDbType.DateTime).Value = CDate(NewScheduledEndDate)
            Else
                cmd.Parameters.Add("@ScheduledEndDate", SqlDbType.DateTime).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateSerialNumber(ByVal NewSerialNumber As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketSerialNumber")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            If (NewSerialNumber.Trim.Length > 0) Then
                cmd.Parameters.Add("@SerialNumber", SqlDbType.VarChar, Me.TrimTrunc(NewSerialNumber, &H80).Length).Value = Me.TrimTrunc(NewSerialNumber, &H80)
            Else
                cmd.Parameters.Add("@SerialNumber", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateServiceEndDate(ByRef NewServiceEndDate As DateTime, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketServiceEndDate")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            Dim datNothing As New DateTime
            If (DateTime.Compare(NewServiceEndDate, datNothing) <> 0) Then
                cmd.Parameters.Add("@ServiceEndDate", SqlDbType.DateTime).Value = CDate(NewServiceEndDate)
            Else
                cmd.Parameters.Add("@ServiceEndDate", SqlDbType.DateTime).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateServiceID(ByVal NewServiceID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketServiceID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            cmd.Parameters.Add("@ServiceID", SqlDbType.Int).Value = NewServiceID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateServiceStartDate(ByRef NewServiceStartDate As DateTime, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketServiceStartDate")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            Dim datNothing As New DateTime
            If (DateTime.Compare(NewServiceStartDate, datNothing) <> 0) Then
                cmd.Parameters.Add("@ServiceStartDate", SqlDbType.DateTime).Value = CDate(NewServiceStartDate)
            Else
                cmd.Parameters.Add("@ServiceStartDate", SqlDbType.DateTime).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateDateCreated(ByRef NewDateCreated As DateTime, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketDateReceived")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            Dim datNothing As New DateTime
            If (DateTime.Compare(NewDateCreated, datNothing) <> 0) Then
                cmd.Parameters.Add("@DateCreated", SqlDbType.DateTime).Value = CDate(NewDateCreated)
            Else
                cmd.Parameters.Add("@DateCreate", SqlDbType.DateTime).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdateStateID(ByVal NewStateID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketStateID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            cmd.Parameters.Add("@StateID", SqlDbType.Int).Value = NewStateID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateStreet(ByVal NewStreet As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketStreet")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            cmd.Parameters.Add("@Street", SqlDbType.VarChar, Me.TrimTrunc(NewStreet, &HFF).Length).Value = Me.TrimTrunc(NewStreet, &HFF)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateTicketStatusID(ByVal NewTicketStatusID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketTicketStatusID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            cmd.Parameters.Add("@TicketStatusID", SqlDbType.Int).Value = NewTicketStatusID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateTicketInvoiceID(ByVal NewTicketInvoiceID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketInvoiceID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            cmd.Parameters.Add("@InvoiceID", SqlDbType.Int).Value = NewTicketInvoiceID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateSupportAgentID(ByVal NewSupportAgentID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketSupportAgentID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            cmd.Parameters.Add("@SupportAgentID", SqlDbType.Int).Value = NewSupportAgentID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdateWarrantyEnd(ByRef NewWarrantyEnd As DateTime, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketWarrantyEnd")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            Dim datNothing As New DateTime
            If (DateTime.Compare(NewWarrantyEnd, datNothing) <> 0) Then
                cmd.Parameters.Add("@WarrantyEnd", SqlDbType.DateTime).Value = CDate(NewWarrantyEnd)
            Else
                cmd.Parameters.Add("@WarrantyEnd", SqlDbType.DateTime).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateWarrantyStart(ByRef NewWarrantyStart As DateTime, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketWarrantyStart")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            Dim datNothing As New DateTime
            If (DateTime.Compare(NewWarrantyStart, datNothing) <> 0) Then
                cmd.Parameters.Add("@WarrantyStart", SqlDbType.DateTime).Value = CDate(NewWarrantyStart)
            Else
                cmd.Parameters.Add("@WarrantyStart", SqlDbType.DateTime).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateApprovalDate(ByVal NewApprovalDate As Date, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateTicketApprovalDate")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            Dim datNothing As New DateTime
            If (DateTime.Compare(NewApprovalDate, datNothing) <> 0) Then
                cmd.Parameters.Add("@ApprovalDate", SqlDbType.SmallDateTime).Value = CDate(NewApprovalDate)
            Else
                cmd.Parameters.Add("@ApprovalDate", SqlDbType.SmallDateTime).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub


        Private Sub UpdateWarrantyTermID(ByVal NewWarrantyTermID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketWarrantyTermID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            cmd.Parameters.Add("@WarrantyTermID", SqlDbType.Int).Value = NewWarrantyTermID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateZipCode(ByVal NewZipCode As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketZipCode")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            cmd.Parameters.Add("@ZipCode", SqlDbType.VarChar, Me.TrimTrunc(NewZipCode, &H10).Length).Value = Me.TrimTrunc(NewZipCode, &H10)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateTicketClaimApprovalStatusID(ByVal NewTicketClaimApprovalStatusID As Long, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateTicketTicketClaimApprovalStatusID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = Me._TicketID
            If NewTicketClaimApprovalStatusID > 0 Then
                cmd.Parameters.Add("@TicketClaimApprovalStatusID", SqlDbType.int).value = NewTicketClaimApprovalStatusID
            Else
                cmd.Parameters.Add("@TicketClaimApprovalStatusID", SqlDbType.int).Value = System.DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdateWebInvoiceID(ByVal NewWebInvoiceID As Long, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateTicketWebInvoiceID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@TicketID", sqlDBType.int).value = _TicketID
            If NewWebInvoiceID > 0 Then
                cmd.Parameters.Add("@WebInvoiceID", SqlDbType.int).value = NewWebInvoiceID
            Else
                cmd.Parameters.Add("@WebInvoiceID", SqlDbType.int).Value = System.DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub


        ' Properties
        Public ReadOnly Property ActionObjectID As Long
            Get
                Return &H21
            End Get
        End Property

        Public Property AdjustCharge As Double
            Get
                Return Me._AdjustCharge
            End Get
            Set(ByVal value As Double)
                Me._AdjustCharge = value
            End Set
        End Property

        Public Property AssignedTo As Long
            Get
                Return Me._AssignedTo
            End Get
            Set(ByVal value As Long)
                Me._AssignedTo = value
            End Set
        End Property

        Public Property ChargeRate As Double
            Get
                Return Me._ChargeRate
            End Get
            Set(ByVal value As Double)
                Me._ChargeRate = value
            End Set
        End Property

        Public Property City As String
            Get
                Return Me._City
            End Get
            Set(ByVal value As String)
                Me._City = Me.TrimTrunc(value, &H80)
            End Set
        End Property

        Public Property Company As String
            Get
                Return Me._Company
            End Get
            Set(ByVal value As String)
                Me._Company = Me.TrimTrunc(value, &H80)
            End Set
        End Property

        Public Property CompletedBy As Long
            Get
                Return Me._CompletedBy
            End Get
            Set(ByVal value As Long)
                Me._CompletedBy = value
            End Set
        End Property

        Public Property CompletedDate As DateTime
            Get
                Return Me._CompletedDate
            End Get
            Set(ByVal value As DateTime)
                Me._CompletedDate = value
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

        Public Property ContactFirstName As String
            Get
                Return Me._ContactFirstName
            End Get
            Set(ByVal value As String)
                Me._ContactFirstName = Me.TrimTrunc(value, &H20)
            End Set
        End Property

        Public Property ContactLastName As String
            Get
                Return Me._ContactLastName
            End Get
            Set(ByVal value As String)
                Me._ContactLastName = Me.TrimTrunc(value, &H40)
            End Set
        End Property

        Public Property ContactMiddleName As String
            Get
                Return Me._ContactMiddleName
            End Get
            Set(ByVal value As String)
                Me._ContactMiddleName = Me.TrimTrunc(value, &H20)
            End Set
        End Property

        Public ReadOnly Property CreatedBy As Long
            Get
                Return Me._CreatedBy
            End Get
        End Property

        Public Property CustomerID() As Long
            Get
                Return Me._CustomerID
            End Get
            Set(ByVal value As Long)
                Me._CustomerID = value
            End Set
        End Property

        Public Property CustomerPrioritySetting As Integer
            Get
                Return Me._CustomerPrioritySetting
            End Get
            Set(ByVal value As Integer)
                Me._CustomerPrioritySetting = value
            End Set
        End Property

        Public Property DateCreated() As DateTime
            Get
                Return Me._DateCreated
            End Get
            Set(ByVal value As DateTime)
                Me._DateCreated = value
            End Set
        End Property

        Public Property Description As String
            Get
                Return Me._Description
            End Get
            Set(ByVal value As String)
                Me._Description = value
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

        Public Property Extended As String
            Get
                Return Me._Extended
            End Get
            Set(ByVal value As String)
                Me._Extended = Me.TrimTrunc(value, &HFF)
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

        Public Property InitialContact As DateTime
            Get
                Return Me._InitialContact
            End Get
            Set(ByVal value As DateTime)
                Me._InitialContact = value
            End Set
        End Property

        Public Property Instructions As String
            Get
                Return Me._Instructions
            End Get
            Set(ByVal value As String)
                Me._Instructions = value
            End Set
        End Property

        Public Property InternalPrioritySetting As Integer
            Get
                Return Me._InternalPrioritySetting
            End Get
            Set(ByVal value As Integer)
                Me._InternalPrioritySetting = value
            End Set
        End Property

        Public Property LaborOnly As Boolean
            Get
                Return Me._LaborOnly
            End Get
            Set(ByVal value As Boolean)
                Me._LaborOnly = value
            End Set
        End Property

        Public Property Manufacturer As String
            Get
                Return Me._Manufacturer
            End Get
            Set(ByVal value As String)
                Me._Manufacturer = Me.TrimTrunc(value, &H80)
            End Set
        End Property

        Public Property MaximumCharge As Double
            Get
                Return Me._MaximumCharge
            End Get
            Set(ByVal value As Double)
                Me._MaximumCharge = value
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

        Public Property MinimumCharge As Double
            Get
                Return Me._MinimumCharge
            End Get
            Set(ByVal value As Double)
                Me._MinimumCharge = value
            End Set
        End Property

        Public Property Model As String
            Get
                Return Me._Model
            End Get
            Set(ByVal value As String)
                Me._Model = Me.TrimTrunc(value, &HDA)
            End Set
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public Property Notes As String
            Get
                Return Me._Notes
            End Get
            Set(ByVal value As String)
                Me._Notes = value
            End Set
        End Property

        Public Property ParentID As Long
            Get
                Return Me._ParentID
            End Get
            Set(ByVal value As Long)
                Me._ParentID = value
            End Set
        End Property

        Public Property PurchaseDate As DateTime
            Get
                Return Me._PurchaseDate
            End Get
            Set(ByVal value As DateTime)
                Me._PurchaseDate = value
            End Set
        End Property

        Public Property ReferenceNumber1 As String
            Get
                Return Me._ReferenceNumber1
            End Get
            Set(ByVal value As String)
                Me._ReferenceNumber1 = Me.TrimTrunc(value, &HFF)
            End Set
        End Property

        Public Property ReferenceNumber2 As String
            Get
                Return Me._ReferenceNumber2
            End Get
            Set(ByVal value As String)
                Me._ReferenceNumber2 = Me.TrimTrunc(value, &HFF)
            End Set
        End Property

        Public Property ReferenceNumber3 As String
            Get
                Return Me._ReferenceNumber3
            End Get
            Set(ByVal value As String)
                Me._ReferenceNumber3 = Me.TrimTrunc(value, &HFF)
            End Set
        End Property

        Public Property ReferenceNumber4 As String
            Get
                Return Me._ReferenceNumber4
            End Get
            Set(ByVal value As String)
                Me._ReferenceNumber4 = Me.TrimTrunc(value, &HFF)
            End Set
        End Property

        Public Property RequestedEndDate As DateTime
            Get
                Return Me._RequestedEndDate
            End Get
            Set(ByVal value As DateTime)
                Me._RequestedEndDate = value
            End Set
        End Property

        Public Property RequestedStartDate As DateTime
            Get
                Return Me._RequestedStartDate
            End Get
            Set(ByVal value As DateTime)
                Me._RequestedStartDate = value
            End Set
        End Property

        Public Property ScheduledDate As DateTime
            Get
                Return Me._ScheduledDate
            End Get
            Set(ByVal value As DateTime)
                Me._ScheduledDate = value
            End Set
        End Property

        Public Property ScheduledEndDate As DateTime
            Get
                Return Me._ScheduledEndDate
            End Get
            Set(ByVal value As DateTime)
                Me._ScheduledEndDate = value
            End Set
        End Property

        Public Property SerialNumber As String
            Get
                Return Me._SerialNumber
            End Get
            Set(ByVal value As String)
                Me._SerialNumber = Me.TrimTrunc(value, &H80)
            End Set
        End Property

        Public Property ServiceEndDate As DateTime
            Get
                Return Me._ServiceEndDate
            End Get
            Set(ByVal value As DateTime)
                Me._ServiceEndDate = value
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

        Public Property ServiceStartDate As DateTime
            Get
                Return Me._ServiceStartDate
            End Get
            Set(ByVal value As DateTime)
                Me._ServiceStartDate = value
            End Set
        End Property

        Public Property StateID As Long
            Get
                Return Me._StateID
            End Get
            Set(ByVal value As Long)
                Me._StateID = value
            End Set
        End Property

        Public Property Street As String
            Get
                Return Me._Street
            End Get
            Set(ByVal value As String)
                Me._Street = Me.TrimTrunc(value, &HFF)
            End Set
        End Property

        Public ReadOnly Property TicketID As Long
            Get
                Return Me._TicketID
            End Get
        End Property

        Public Property TicketStatusID As Long
            Get
                Return Me._TicketStatusID
            End Get
            Set(ByVal value As Long)
                Me._TicketStatusID = value
            End Set
        End Property

        Public Property WarrantyEnd As DateTime
            Get
                Return Me._WarrantyEnd
            End Get
            Set(ByVal value As DateTime)
                Me._WarrantyEnd = value
            End Set
        End Property

        Public Property WarrantyStart As DateTime
            Get
                Return Me._WarrantyStart
            End Get
            Set(ByVal value As DateTime)
                Me._WarrantyStart = value
            End Set
        End Property

        Public Property WarrantyTermID As Long
            Get
                Return Me._WarrantyTermID
            End Get
            Set(ByVal value As Long)
                Me._WarrantyTermID = value
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
        Public Property SupportAgentID() As Long
            Get
                Return Me._SupportAgentID
            End Get
            Set(ByVal value As Long)
                Me._SupportAgentID = value
            End Set
        End Property


        Public ReadOnly Property WorkOrderCount As Long
            Get
                Return Me.GetWorkOrderCount
            End Get
        End Property

        Public ReadOnly Property WorkOrderIDs As List(Of Long)
            Get
                Return Me._WorkOrderIDs
            End Get
        End Property

        Public Property ZipCode As String
            Get
                Return Me._ZipCode
            End Get
            Set(ByVal value As String)
                Me._ZipCode = Me.TrimTrunc(value, &H10)
            End Set
        End Property

        Public Property TicketClaimApprovalStatusID() As Long
            Get
                Return Me._TicketClaimApprovalStatusID
            End Get
            Set(ByVal value As Long)
                Me._TicketClaimApprovalStatusID = value
            End Set
        End Property

        Public Property ApprovalDate() As Date
            Get
                Return Me._ApprovalDate
            End Get
            Set(ByVal value As Date)
                Me._ApprovalDate = value
            End Set
        End Property

        Public Property WebInvoiceID() As Long
            Get
                Return _WebInvoiceID
            End Get
            Set(ByVal value As Long)
                _WebInvoiceID = value
            End Set
        End Property



        ' Fields
        Private _AdjustCharge As Double
        Private _AssignedTo As Long
        Private _ChargeRate As Double
        Private _City As String
        Private _Company As String
        Private _CompletedBy As Long
        Private _CompletedDate As DateTime
        Private _ConnectionString As String
        Private _ContactFirstName As String
        Private _ContactLastName As String
        Private _ContactMiddleName As String
        Private _CreatedBy As Long
        Private _CustomerID As Long
        Private _CustomerPrioritySetting As Integer
        Private _DateCreated As DateTime
        Private _Description As String
        Private _Email As String
        Private _Extended As String
        Private _IncrementTypeID As Long
        Private _InitialContact As DateTime
        Private _Instructions As String
        Private _InternalPrioritySetting As Integer
        Private _LaborOnly As Boolean
        Private _Manufacturer As String
        Private _MaximumCharge As Double
        Private _MileageEnd As Long
        Private _MileageStart As Long
        Private _MinimumCharge As Double
        Private _Model As String
        Private _Notes As String
        Private _ParentID As Long
        Private _PurchaseDate As DateTime
        Private _ReferenceNumber1 As String
        Private _ReferenceNumber2 As String
        Private _ReferenceNumber3 As String
        Private _ReferenceNumber4 As String
        Private _RequestedEndDate As DateTime
        Private _RequestedStartDate As DateTime
        Private _ScheduledDate As DateTime
        Private _ScheduledEndDate As DateTime
        Private _SerialNumber As String
        Private _ServiceEndDate As DateTime
        Private _ServiceID As Long
        Private _ServiceStartDate As DateTime
        Private _StateID As Long
        Private _Street As String
        Private _TicketID As Long
        Private _TicketStatusID As Long
        Private _WarrantyEnd As DateTime
        Private _WarrantyStart As DateTime
        Private _WarrantyTermID As Long
        Private _WorkOrderIDs As List(Of Long)
        Private _ZipCode As String
        Private _InvoiceID As Long
        Private _SupportAgentID As Long
        Private _TicketClaimApprovalStatusID As Long = 0
        Private _ApprovalDate As Date = DateTime.Now
        Private _WebInvoiceID As Long = 0
        Private Const CityMaxLength As Integer = &H80
        Private Const CompanyMaxLength As Integer = &H80
        Private Const ContactFirstNameMaxLength As Integer = &H20
        Private Const ContactLastNameMaxLength As Integer = &H40
        Private Const ContactMiddleNameMaxLength As Integer = &H20
        Private Const EmailMaxLength As Integer = &HFF
        Private Const ExtendedMaxLength As Integer = &HFF
        Private Const ManufacturerMaxLength As Integer = &H80
        Private Const ModelMaxLength As Integer = &HDA
        Private Const ObjectID As Long = &H21
        Private Const ReferenceNumber1MaxLength As Integer = &HFF
        Private Const ReferenceNumber2MaxLength As Integer = &HFF
        Private Const ReferenceNumber3MaxLength As Integer = &HFF
        Private Const ReferenceNumber4MaxLength As Integer = &HFF
        Private Const SerialNumberMaxLength As Integer = &H80
        Private Const StreetMaxLength As Integer = &HFF
        Private Const ZipCodeMaxLength As Integer = &H10
    End Class
End Namespace

