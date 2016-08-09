Imports System.Reflection
Namespace LGInterface
    Public Class LG
        Private _oLGESecurity As New LGESecurity
        Private _shipToCode As String
        Private _serviceEngineerCode As String
        Private _URL As String
        Private Const _LGCustNum As Long = 32

        Public Sub New(userID As Long)
            Dim usr As New BridgesInterface.UserRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            Dim CCreds As New BridgesInterface.CustomerCredentialsRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            'test
            _URL = "http://136.166.4.201/sps/services/LGEBMSRepairBiz"
            'prod
            '_URL = "http://136.166.4.221/sps/services/LGEBMSRepairBiz"

            usr.Load(userID)
            CCreds.Load(_LGCustNum, usr.InfoID)

            _oLGESecurity.userId = CCreds.UserID

            _oLGESecurity.password = CCreds.Password

            _oLGESecurity.bmsCompanyCode = CCreds.Misc1
            _shipToCode = CCreds.Misc2
            _serviceEngineerCode = CCreds.Misc1

        End Sub
        Public Sub getNewDispatchList(userID As Long, WebLoginID As Long)

            Dim objLG As New LGEBMSRepairBiz
            Dim objDispatchListRequest As New DispatchListRequest
            Dim objDispatchListResponse As New DispatchListResponse

            Dim objDispatchConfirmRequest As DispatchConfirmRequest
            Dim objDispatchConfirmResponse As New DispatchConfirmResponse
            Dim objDispatchAcceptRequest As DispatchAcceptRequest
            Dim objDispatchAcceptResponse As New DispatchAcceptResponse
            Dim iCnt As Integer = 0
            Dim rcptNo(0) As String

            objLG.Url = _URL

            objDispatchListRequest.fromDate = "1/1/15"
            objDispatchListRequest.toDate = Now

            objDispatchListRequest.lgeSecurity = _oLGESecurity
            objDispatchListRequest.shipToCode = _shipToCode
            objDispatchListRequest.serviceEngineerCode = _serviceEngineerCode
            objDispatchListResponse = objLG.getNewDispatchList(objDispatchListRequest)
            If objDispatchListResponse.responseType.statusCode <> "SUCCESS" Then
                'handle error
                MsgBox("Error downloading Dispatch List", , "Download")
                Exit Sub
            End If
            For Each di As DispatchItem In objDispatchListResponse.dispatchList
                If Not IsNothing(di.customerName) Then  'for some reason some of the list is just an empty item
                    If CreateTicket(di, userID, WebLoginID) Then
                        objDispatchAcceptRequest = New DispatchAcceptRequest
                        objDispatchAcceptRequest.lgeSecurity = _oLGESecurity
                        objDispatchAcceptRequest.shipToCode = _shipToCode
                        objDispatchAcceptRequest.serviceReceiptNo = di.serviceReceiptNo
                        objDispatchAcceptResponse = objLG.acceptDispatch(objDispatchAcceptRequest)
                        rcptNo(0) = di.serviceReceiptNo
                        iCnt += 1
                    End If
                End If
            Next
            If iCnt > 0 Then
                objDispatchConfirmRequest = New DispatchConfirmRequest
                objDispatchConfirmRequest.lgeSecurity = _oLGESecurity
                objDispatchConfirmRequest.shipToCode = _shipToCode
                objDispatchConfirmRequest.serviceReceiptNoList = rcptNo
                objDispatchConfirmResponse = objLG.confirmDispatchList(objDispatchConfirmRequest)
            End If
            MsgBox(CStr(iCnt) + " ticket(s) downloaded.", , "Download")
        End Sub


      
        Private Function CreateTicket(ByRef di As DispatchItem, userID As Long, WebLoginID As Long) As Boolean

            Dim datPromised As Date = Today
            Dim datPurchased As Date = Today

            Dim strChangeLog As String = ""
            Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            Dim srv As New BridgesInterface.ServiceRecord(tkt.ConnectionString)
            Dim phn As New BridgesInterface.TicketPhoneNumberRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            Dim cst As New BridgesInterface.CustomerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            Dim st As New BridgesInterface.StateRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            Dim props As PropertyInfo() = di.GetType().GetProperties()
            Dim pname, pval As String
            Dim NoteRecord As String
            Dim datDateCreated As Date
            Dim serviceID As Long = 209  'LG_APP Minor Repair
            Dim warrantyTerm As Long = 1
            Dim priorityCode As Long = 1
            Dim iPos As Long = InStr(di.customerName, " ")
            Dim firstName As String = di.customerName.Substring(0, iPos - 1)
            Dim lastName As String = di.customerName.Substring(iPos, Len(di.customerName) - iPos)
            Dim address As String
            Dim CustomerID As Long = _LGCustNum  ' LG electronics
            Try
                cst.Load(CustomerID)
                datDateCreated = Now()
                srv.Load(serviceID)
                st.LoadFromZip(di.postalCode)

                iPos = InStr(di.address1, di.cityName)
                If iPos > 1 Then
                    address = di.address1.Substring(0, iPos - 1).Replace(",", "")
                Else
                    address = ""
                End If
                If di.promiseDate <> "" Then
                    datPromised = CType(di.promiseDate.Substring(0, 2) + "/" + di.promiseDate.Substring(2, 2) + "/" + di.promiseDate.Substring(4, 4), Date)
                End If
                If di.purchaseDate <> "" Then
                    datPurchased = CType(di.purchaseDate.Substring(0, 2) + "/" + di.purchaseDate.Substring(2, 2) + "/" + di.purchaseDate.Substring(4, 4), Date)
                End If
                'Add new ticket to the system   
                tkt.Add(userID, userID, CustomerID, 1, st.StateID, srv.ServiceID, srv.PayIncrementID, warrantyTerm, priorityCode, 1, srv.MinimumCharge, srv.ChargeRate, srv.AdjustmentCharge, firstName, lastName, address, di.cityName, di.postalCode, srv.Description, datPromised, datPromised)
                tkt.Company = ""
                tkt.ContactMiddleName = ""
                tkt.Email = di.emailAddr
                tkt.SerialNumber = di.serialNo
                tkt.Extended = di.address2
                tkt.LaborOnly = False
                tkt.ReferenceNumber1 = di.serviceReceiptNo
                tkt.ReferenceNumber2 = di.serviceReceiptNo & "-1"
                'tkt.ReferenceNumber3 = txtRef3.Text
                'tkt.ReferenceNumber4 = txtRef4.Text
                tkt.Manufacturer = cst.Company & "/" & di.serviceProductName
                tkt.Model = di.modelCode

                'If txtWarrantyStart.Text.Trim.Length > 0 Then
                '    DateTime.TryParse(txtWarrantyStart.Text, dat)
                '    tkt.WarrantyStart = dat
                'Else
                '    tkt.WarrantyStart = Nothing
                'End If
                'If txtWarrantyEnd.Text.Trim.Length > 0 Then
                '    DateTime.TryParse(txtWarrantyEnd.Text, dat)
                '    tkt.WarrantyEnd = dat
                'Else
                '    tkt.WarrantyEnd = Nothing
                'End If

                tkt.PurchaseDate = datPurchased

                tkt.Notes = di.detailSymptomDesc & " " & di.receiptDetail
                tkt.Instructions = srv.Instructions
                tkt.Description = srv.Description
                '_TicketID = tkt.TicketID
                'tkt.AssignedTo = AssignAgent(LoadClosestPartnerAgents(tkt.ZipCode, 50))
                tkt.Save(strChangeLog)

                If di.phoneNo <> "" Then
                    phn.Add(tkt.TicketID, 1, userID, 1, di.phoneNo.Substring(0, 3), di.phoneNo.Substring(3, 3), di.phoneNo.Substring(6, 4), True)
                    phn.Save(strChangeLog)
                End If
                If di.cellularNo <> "" Then
                    phn.Add(tkt.TicketID, 4, userID, 1, di.cellularNo.Substring(0, 3), di.cellularNo.Substring(3, 3), di.cellularNo.Substring(6, 4), True)
                    phn.Save(strChangeLog)
                End If
                If di.faxNo <> "" Then
                    phn.Add(tkt.TicketID, 3, userID, 1, di.faxNo.Substring(0, 3), di.faxNo.Substring(3, 3), di.faxNo.Substring(6, 4), True)
                    phn.Save(strChangeLog)
                End If
                If di.officePhoneNo <> "" Then
                    phn.Add(tkt.TicketID, 2, userID, 1, di.officePhoneNo.Substring(0, 3), di.officePhoneNo.Substring(3, 3), di.officePhoneNo.Substring(6, 4), True)
                    phn.Save(strChangeLog)
                End If

                'Dim com As New BridgesInterface.TicketComponentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                'Dim lbl As New BridgesInterface.ShippingLabelRecord(com.ConnectionString)

                'If com1.Code.Trim.Length + com1.Component.Trim.Length + com1.SerialNumber.Trim.Length > 0 Then
                '    com.Add(Master.UserID, tkt.TicketID, com1.Consumable, com1.Component)
                '    com.Code = com1.Code
                '    com.SerialNumber = com1.SerialNumber
                '    com.Notes = com1.Notes
                '    com.Save(strChangeLog)
                '    If com1.ShipLabel.Trim.Length > 0 Then
                '        lbl.Add(Master.UserID, com.TicketComponentID, com1.ShipMethod, 1, com1.ShipLabel)
                '    End If
                '    If com1.ReturnLabel.Trim.Length > 0 Then
                '        lbl.Add(Master.UserID, com.TicketComponentID, com1.ReturnMethod, 2, com1.ReturnMethod)
                '    End If
                'End If
                'If com2.Code.Trim.Length + com2.Component.Trim.Length + com2.SerialNumber.Trim.Length > 0 Then
                '    com.Add(Master.UserID, tkt.TicketID, com2.Consumable, com2.Component)
                '    com.Code = com2.Code
                '    com.SerialNumber = com2.SerialNumber
                '    com.Notes = com2.Notes
                '    com.Save(strChangeLog)
                '    If com2.ShipLabel.Trim.Length > 0 Then
                '        lbl.Add(Master.UserID, com.TicketComponentID, com2.ShipMethod, 1, com2.ShipLabel)
                '    End If
                '    If com2.ReturnLabel.Trim.Length > 0 Then
                '        lbl.Add(Master.UserID, com.TicketComponentID, com2.ReturnMethod, 2, com2.ReturnMethod)
                '    End If
                'End If
                'If com3.Code.Trim.Length + com3.Component.Trim.Length + com3.SerialNumber.Trim.Length > 0 Then
                '    com.Add(Master.UserID, tkt.TicketID, com3.Consumable, com3.Component)
                '    com.Code = com3.Code
                '    com.SerialNumber = com3.SerialNumber
                '    com.Notes = com3.Notes
                '    com.Save(strChangeLog)
                '    If com3.ShipLabel.Trim.Length > 0 Then
                '        lbl.Add(Master.UserID, com.TicketComponentID, com3.ShipMethod, 1, com3.ShipLabel)
                '    End If
                '    If com3.ReturnLabel.Trim.Length > 0 Then
                '        lbl.Add(Master.UserID, com.TicketComponentID, com3.ReturnMethod, 2, com3.ReturnMethod)
                '    End If
                'End If
                'If com4.Code.Trim.Length + com4.Component.Trim.Length + com4.SerialNumber.Trim.Length > 0 Then
                '    com.Add(Master.UserID, tkt.TicketID, com4.Consumable, com4.Component)
                '    com.Code = com4.Code
                '    com.SerialNumber = com4.SerialNumber
                '    com.Notes = com4.Notes
                '    com.Save(strChangeLog)
                '    If com4.ShipLabel.Trim.Length > 0 Then
                '        lbl.Add(Master.UserID, com.TicketComponentID, com4.ShipMethod, 1, com4.ShipLabel)
                '    End If
                '    If com4.ReturnLabel.Trim.Length > 0 Then
                '        lbl.Add(Master.UserID, com.TicketComponentID, com4.ReturnMethod, 2, com4.ReturnMethod)
                '    End If
                'End If
                NoteRecord = "Ticket Added to System.<BR>"
                For Each pi As PropertyInfo In props
                    pname = pi.Name
                    pval = pi.GetValue(di, Nothing).ToString.Trim
                    If pval <> "" Then
                        NoteRecord += pname + "=" + pval + "<BR>"
                    End If
                Next
                Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                tnt.Add(tkt.TicketID, WebLoginID, userID, NoteRecord)
                tnt.CustomerVisible = True
                tnt.Acknowledged = True
                tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                tnt.Save(strChangeLog)

                tkt.DateCreated = datDateCreated
                tkt.Save(strChangeLog)

                ' production
                Dim plog As New BridgesInterface.ProductionLogRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                'Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                'wbl.Load(Master.WebLoginID)
                'Dim strUserName As String
                'strUserName = wbl.Login
                'Dim tst As New BridgesInterface.TicketStatusRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                'tst.Load(tkt.TicketStatusID)

                '14 New Ticket Added
                plog.Add(WebLoginID, Now(), 14, "New Ticket has been added to the system - ticket: " & tkt.TicketID)

                ' ''If drpTicketStatus.SelectedValue <> CType(17, Long) Then
                ''Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
                ''            eml.Subject = "Production from: " & strUserName
                ''            eml.Body = "New Ticket has been added to the system - ticket: " & tkt.TicketID
                ''            eml.SendFrom = System.Configuration.ConfigurationManager.AppSettings("PartnerSupportEmail")
                ''            eml.SendFrom = strUserName & "@bestservicers.com"
                ' ''eml.SendTo = ptr.Email
                ''            eml.SendTo = "agentproduction@bestservicers.com"
                ' ''eml.CC = "nelson.palavesino@centurionvision.com"
                ' ''eml.cc = "howard.goldman@centurionvision.com"
                ''            eml.Send()
                ' ''End If
                Return True
            Catch ex As Exception
                Return False
            End Try

        End Function
        Public Sub submitWarranty(ByVal TicketID As Integer)


            Dim objLG As New LGEBMSRepairBiz

            Dim objWarrantyClaimRequest As New WarrantyClaimRequest
            Dim objWarrantyClaimResponse As New WarrantyClaimResponse
            Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            Dim phn As New BridgesInterface.TicketPhoneNumberRecord(tkt.ConnectionString)
            Dim st As New BridgesInterface.StateRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            tkt.Load(TicketID)
            phn.LoadTicketPhones(TicketID)
            st.Load(tkt.StateID)
            objLG.Url = _URL

            objWarrantyClaimRequest.lgeSecurity = _oLGESecurity
            objWarrantyClaimRequest.shipToCode = _shipToCode
            objWarrantyClaimRequest.customerName = tkt.ContactFirstName & " " & tkt.ContactLastName
            objWarrantyClaimRequest.phoneNo = phn.AreaCode & phn.Exchange & phn.LineNumber
            objWarrantyClaimRequest.emailAddr = tkt.Email
            objWarrantyClaimRequest.postalCode = tkt.ZipCode
            objWarrantyClaimRequest.cityName = tkt.City
            objWarrantyClaimRequest.addressLine1Info = tkt.Street
            objWarrantyClaimRequest.stateName = st.Abbreviation
            objWarrantyClaimRequest.serviceTypeCode = "IH"
            objWarrantyClaimRequest.modelCode = tkt.Model
            objWarrantyClaimRequest.serialNo = tkt.SerialNumber
            'objWarrantyClaimRequest.dealerName = 
            objWarrantyClaimRequest.warrantyFlag = "I"
            objWarrantyClaimRequest.purchaseDate = tkt.PurchaseDate
            objWarrantyClaimRequest.requestTimestamp = tkt.RequestedStartDate
            'objWarrantyClaimRequest.serviceEngineerCode = "23530200"
            objWarrantyClaimRequest.receiptTimestamp = tkt.DateCreated
            'objWarrantyClaimRequest.receiptDetail = "Please fix leak"
            objWarrantyClaimRequest.startTimestamp = tkt.ServiceStartDate
            objWarrantyClaimRequest.completionTimestamp = tkt.ServiceEndDate
            objWarrantyClaimRequest.primaryDefectCode = "FEAT"
            objWarrantyClaimRequest.primaryRepairCode = "PTEL"
            objWarrantyClaimRequest.repairLevelCode = "DS"
            'objWarrantyClaimRequest.ascClaimNo = "55345ABC"
            'objWarrantyClaimRequest.reqLaborCostTxnAmount = "100.00"
            'objWarrantyClaimRequest.technicalFindingDesc = "Found a leak in line, repaired the leak"
            'objWarrantyClaimRequest.dealerStockFlag = "Y"
            objWarrantyClaimResponse = objLG.warrantyClaim(objWarrantyClaimRequest)

            'rstr = r.responseType.statusCode
            'rstr = r.responseType.statusDesc
            'rstr = r.serviceReceiptNo
            'rstr = ""
        End Sub
    End Class
End Namespace