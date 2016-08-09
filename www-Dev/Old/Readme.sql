/* add splistpaypartners
	add payvendors.aspx
	add fnCalcVendorTicketRate
	add ddbo.spGetListTicketsToPayByPartnerID
	INVOICERECORD.VB
	WORKORDERECORD.VB

/* created store procedure spBillingVerificationByInvoiceID
  billingverification.aspx
  


/* created store procedure: spGetInvoiceSinglesByInvoiceID



/* add field to tblInvoices = InvoiceNumber  done
   add field to tbltickets = InvoiceID  done
   added function fnInvoiceCount  done
   added store procedure spCreateCustomerInvoiceNumber done
   added store procedure UpdateInvoiceInvoiceNumber done
   changes on invoicerecord.vb done
   create PROCEDURE dbo.spUpdateInvoiceInvoiceNumber done
   create PROCEDURE spUpdateTicketTicketInvoiceID done
    create PROCEDURE spUpdateTicketInvoiceID done

/* add store procedure spbillingverification
   change on fnCallCustomerAmount


/* 08/17/08 - added sql function fnCalcCustomerAmount DONE
   08/17/08 - added sql function fnCallvendorAmount DONE
   08/17/08 - Created tblTripChargeTypes DONE
   08/17/08 - add field in tblworkOrders - TripChargeTypeID int DONE
   08/17/08 - add field in tblworkOrders - Billable bit DONE
   08/17/08 - created store procedure - spGetServiceAmountByTicketID done
   add two fields to tblTicketComponents - Markup , BillCustomer, BillShipping, BillTaxes, NeedReturned, RMA done
   spUpdateTripChargeTypeID done
   spUpdateWorkOrderBillable done
   spUpdateTicketComponentBillCustomer done
   splisttripchargetypes done
   spUpdateTicketComponentBillShipping done
   spUpdateTicketComponentBillTaxes done
   spUpdateTicketComponentNeedReturned dpne
   spUpdateTicketComponentRMA done
   spUpdateTicketComponentMarkUp done
   makde changes to store procedure spaddticketComponent done
   addTicketcomponent.aspx done
   editTicketcomponent.aspx done
   changed workOrderRecord.vb done
   ticketbilling.aspx done
   add function fnCalcCustomerPartChargeAmount done
   add spGetTicketCOmponentChargesForTicketID
   
   

/* 08/14/08 add field to store procedure spAddTicketComponentAll - suppliedBy
/* 08/13/08 added field suppliedBy to the tblTicketComponents to indicate who we are buying the part from.



/* 08/06/08 :Added a new field to the table tblWorkOrders - Billable bit.
changed splistclosestpartnerAgentstozipcode store procedure
08/07/08: spListPartnerAgents - added criteria webloginID <> Null
08/07/08: add procedure - spGetPriorTickets 
08/07/08: added column on tblSevices - FlatRate
*/

/* need to create the following store procedures
spUpdateTicketComponentPartAmount
spUpdateTicketComponentDateOrdered
spUpdateTicketComponentTax
spUpdateTicketComponentShipping


*/

/*
pages modified:

ticketComponenteRecord.vb
agentinterface/addticket.aspx
agentinterface/editComponent.aspx
agentinterface/addcomponent.aspx
clients/addticket.aspx
clients/addcomponent.aspx
agentinterface/tickets.aspx
*/


/********************************************************************
	New SQL after adding TrackInformation and Tracked To tblShippingLabels
********************************************************************/
CREATE PROCEDURE spAddShippingLabel
  (
    @CreatedBy int,
    @TicketComponentID int,
    @CourierMethodID int,
    @ShippingDestinationID int,
    @ShippingLabel varchar(128),
    @DateCreated datetime
  )
  AS
    SET NOCOUNT ON
      Insert Into tblShippingLabels
        (
          CreatedBy,
          TicketComponentID,
          CourierMethodID,
          ShippingDestinationID,
          ShippingLabel,
          DateCreated
        )
      Values
        (
          @CreatedBy,
          @TicketComponentID,
          @CourierMethodID,
          @ShippingDestinationID,
          @ShippingLabel,
          @DateCreated
        )

      Select @@Identity

    RETURN
GO

CREATE PROCEDURE spGetShippingLabel
  (
    @ShippingLabelID int
  )
  AS
    SET NOCOUNT ON
      Select
        *
      From
        tblShippingLabels
      Where
        ShippingLabelID = @ShippingLabelID
    RETURN
GO

CREATE PROCEDURE spUpdateShippingLabelTicketComponentID
  (
    @ShippingLabelID int,
    @TicketComponentID int
  )
  AS
    SET NOCOUNT ON
      Update
        tblShippingLabels
      Set
        TicketComponentID = @TicketComponentID
      Where
        ShippingLabelID = @ShippingLabelID
    RETURN
GO

CREATE PROCEDURE spUpdateShippingLabelCourierMethodID
  (
    @ShippingLabelID int,
    @CourierMethodID int
  )
  AS
    SET NOCOUNT ON
      Update
        tblShippingLabels
      Set
        CourierMethodID = @CourierMethodID
      Where
        ShippingLabelID = @ShippingLabelID
    RETURN
GO

CREATE PROCEDURE spUpdateShippingLabelShippingDestinationID
  (
    @ShippingLabelID int,
    @ShippingDestinationID int
  )
  AS
    SET NOCOUNT ON
      Update
        tblShippingLabels
      Set
        ShippingDestinationID = @ShippingDestinationID
      Where
        ShippingLabelID = @ShippingLabelID
    RETURN
GO

CREATE PROCEDURE spUpdateShippingLabelShippingLabel
  (
    @ShippingLabelID int,
    @ShippingLabel varchar(128)
  )
  AS
    SET NOCOUNT ON
      Update
        tblShippingLabels
      Set
        ShippingLabel = @ShippingLabel
      Where
        ShippingLabelID = @ShippingLabelID
    RETURN
GO

CREATE PROCEDURE spUpdateShippingLabelDelivered
  (
    @ShippingLabelID int,
    @Delivered datetime
  )
  AS
    SET NOCOUNT ON
      Update
        tblShippingLabels
      Set
        Delivered = @Delivered
      Where
        ShippingLabelID = @ShippingLabelID
    RETURN
GO

CREATE PROCEDURE spUpdateShippingLabelTrackInformation
  (
    @ShippingLabelID int,
    @TrackInformation text
  )
  AS
    SET NOCOUNT ON
      Update
        tblShippingLabels
      Set
        TrackInformation = @TrackInformation
      Where
        ShippingLabelID = @ShippingLabelID
    RETURN
GO

CREATE PROCEDURE spUpdateShippingLabelTracked
  (
    @ShippingLabelID int,
    @Tracked bit
  )
  AS
    SET NOCOUNT ON
      Update
        tblShippingLabels
      Set
        Tracked = @Tracked
      Where
        ShippingLabelID = @ShippingLabelID
    RETURN
GO

CREATE PROCEDURE spRemoveShippingLabel
  (
    @ShippingLabelID int
  )
  AS
    SET NOCOUNT ON
      Delete From
        tblShippingLabels
      Where
        ShippingLabelID = @ShippingLabelID
    RETURN
GO

