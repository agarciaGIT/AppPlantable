/******************************************************************************************************************************************
* DESCRIPTION  :   helper for Plant_TransactionTigger(Trigger), update subscription and create shipment
* TEST CLASS   :
* 
* CREATED BY   :   HIC Dev(25 May)
******************************************************************************************************************************************/

public  class Plant_TransactionTiggerHelper {
    
    // Method 1
    // @desc    :   update subscriptions
    public static void processSubscription(Map<String,String> cOrder_Vs_transactionId_Map){
        
        // SET SAVE POINT FOR CALLBACK
        Savepoint sp_default = Database.setSavepoint();
        
        // ** new Logic
        try{
            List<Plant_Shipment__c> insertNonRecurrShipments = new List<Plant_Shipment__c>();
            List<Plant_Subscription__c> updateSubscription_List = new List<Plant_Subscription__c>();
            Map<String, Plant_Order_Properties__c> insertOrderProperty_Map = new Map<String, Plant_Order_Properties__c>();
            Map<String,Order> insertOrder_Map = new Map<String,Order>();
            Map<String,OrderItem> oldOrderItem_Map = new Map<String, OrderItem>();
            List<orderItem> orderLine_ToInsert = new List<orderItem>();
            List<Order> updateCurrent_Orders = new List<Order>(); //
            Map<String, String> ChargentIdVsOrderId_Map=new Map<String, String>();
            Map<Date, Plant_Shipping_Date__c> shipdateVsRecord=new Map<Date, Plant_Shipping_Date__c>();
            
            // List of Post Order Event Calls
            List<Plant_TransComm_BC.pubTransEvent> pubEvents = new List<Plant_TransComm_BC.pubTransEvent>();

            //Record for Plant Shipping Date
            for(Plant_Shipping_Date__c pshipDate:[Select id, name , Plant_Shipping_Date__c, Plant_One_Day_Shipping_Delivery_Date__c,Plant_Total_Orders__c,Max_Orders_Allowed__c,
            Plant_2_Day_Shipping_Delivery_Date__c, X3_Day_Shipping_Delivery_Date__c from Plant_Shipping_Date__c where Is_Shipping_Date_Available__c=true AND Plant_Shipping_Date__c>Today Limit 49999]){
                if(pshipDate.Plant_Total_Orders__c<pshipDate.Max_Orders_Allowed__c){
                    shipdateVsRecord.put(pshipDate.Plant_Shipping_Date__c, pshipDate);
                }
            }
            system.debug('@@@ TEsting Map '+shipdateVsRecord);
            for(Order oddr : [SELECT Id, Status,TotalAmount,OrderNumber,AccountId,Plant_Order_Properties__c,Plant_Shipping_Date__c,Plant_Shipping_Date__r.Plant_Shipping_Date__c, (Select id, OrderId, Product2Id, UnitPrice, PricebookEntryId, Quantity from OrderItems Limit 1), pricebook2id, comty_Chargent_Order__c,Plant_Subscription__c,
                              Plant_Subscription__r.Plant_Shipping_Address__c,Plant_Subscription__r.Plant_Shipping_Date__c,Plant_Subscription__r.Plant_Meal_Selection__c,Plant_Subscription__r.Plant_Payment_Method__c, Plant_Subscription__r.Order_Count__c,Plant_Subscription__r.RecordType.Name,Plant_Subscription__r.Plant_Account__c,
                              Plant_Subscription__r.Plant_Status__c,Plant_Subscription__r.Plant_Cadence__c,Plant_Subscription__r.Plant_Start_Date__c,Plant_Subscription__r.Plant_Charge_Day__c,Plant_Subscription__r.Plant_Next_Delivery_Date__c,Plant_Subscription__r.Plant_Next_Shipment_Date__c,Plant_Subscription__r.Plant_Next_Charge_Date__c, 
                              Plant_Subscription__r.Plant_Shipping_Address__r.Plant_Postal_Code__c, Plant_Subscription__r.Plant_Shipping_Address__r.Plant_Province_State__c,Plant_Subscription__r.Plant_Chargent_Order__c,
                              Plant_Subscription__r.Ghost_Next_Shipment_Date__c, Plant_Subscription__r.Ghost_Shipment_Day__c,Plant_Subscription__r.Plant_Delivery_Schedule__c,
                              (SELECT Id, IsDeleted, Name, SystemModstamp, LastViewedDate, LastReferencedDate, Plant_Order__c, Plant_Status__c, Plant_Delivery_Schedule__c, Plant_Shipping_Address__c, Plant_Tracking_Number__c, Plant_Flagged_Details__c, Chargent_Transaction__c FROM Shipments__r Limit 1), 
                              Plant_Order_Properties__r.Shipping_Address__r.Plant_Province_State__c ,Plant_Order_Properties__r.Shipping_Address__r.Plant_Postal_Code__c ,Plant_Order_Properties__r.RecordTypeId,Plant_Order_Properties__r.RecordType.Name,
                              Plant_Order_Properties__r.plan_discountedAmount__c, Plant_Order_Properties__r.Plant_Account__c, Plant_Order_Properties__r.Plant_First_Name__c, Plant_Order_Properties__r.Plant_Last_Name__c, 
                              Plant_Order_Properties__r.Plant_Phone__c, Plant_Order_Properties__r.Plant_Can_SMS__c, Plant_Order_Properties__r.Plant_Email__c, Plant_Order_Properties__r.Shipping_Address__c, 
                              Plant_Order_Properties__r.Plant_Delivery_Date__c, Plant_Order_Properties__r.Plant_Shipping_Date__c, Plant_Order_Properties__r.Plant_Meal_Selection__c, Plant_Order_Properties__r.Plant_Payment_Method__c, 
                              Plant_Order_Properties__r.Plant_Recurrence__c, Plant_Order_Properties__r.Plant_Status__c, Plant_Order_Properties__r.Plant_Gift_Recipient__c, Plant_Order_Properties__r.Delivery_Schedule__c 
                              FROM Order WHERE comty_Chargent_Order__c IN: cOrder_Vs_transactionId_Map.keySet() ORDER BY CreatedDate DESC Limit 49999]){
                               
                if(ChargentIdVsOrderId_Map.isEmpty() || !ChargentIdVsOrderId_Map.keySet().contains(oddr.comty_Chargent_Order__c)){
                    // NO RECURRING ORDER
                    ChargentIdVsOrderId_Map.put(oddr.comty_Chargent_Order__c, oddr.id);
                    if(oddr.Plant_Order_Properties__r.Plant_Recurrence__c == 'Once') {
                        
                        // Set Order to Active
                        oddr.Status = 'Activated';
                        oddr.Plant_Transaction_Id__c=cOrder_Vs_transactionId_Map.get(oddr.Plant_Subscription__r.Plant_Chargent_Order__c);
                        updateCurrent_Orders.add(oddr);

                        // Add post Order Event
                        pubEvents.add(Plant_TransComm_BC.setTransactionEvent('Order Paid',oddr.AccountId,oddr.id,null));
                        
                        system.debug('@@@@ new order update list:' + updateCurrent_Orders);
                        
                        // Create Shipment
                        // insertNonRecurrShipments
                        Plant_Shipment__c shipmt=new Plant_Shipment__c();
                        shipmt.Plant_Shipping_Address__c= oddr.Plant_Order_Properties__r.Shipping_Address__c;
                        shipmt.Plant_Status__c = 'Pending';
                        shipmt.Chargent_Transaction__c = cOrder_Vs_transactionId_Map.get(oddr.id);
                        shipmt.Plant_Delivery_Schedule__c=oddr.Plant_Order_Properties__r.Delivery_Schedule__c;
                        shipmt.Plant_Order__c = oddr.id;

                        insertNonRecurrShipments.add(shipmt);
                        system.debug('@@@@ new shipment list:' + insertNonRecurrShipments);
                        
                    }
                    else{// RECURRING ORDER

                        // Set Order to Active
                        oddr.Status = 'Activated';
                        oddr.Plant_Transaction_Id__c=cOrder_Vs_transactionId_Map.get(oddr.Plant_Subscription__r.Plant_Chargent_Order__c);
                        updateCurrent_Orders.add(oddr);

						// Add post Order Event
                        pubEvents.add(Plant_TransComm_BC.setTransactionEvent('Order Paid',oddr.AccountId,oddr.id,null));
                        
                        // FIREST ORDER
                        if(oddr.Plant_Subscription__r.Order_Count__c==0){
                            
                            // Create Shipment Plant_Shipment__c
                            Plant_Shipment__c shipmt=new Plant_Shipment__c();
                            shipmt.Plant_Shipping_Address__c= oddr.Plant_Order_Properties__r.Shipping_Address__c;
                            shipmt.Plant_Status__c = 'Pending';
                            shipmt.Chargent_Transaction__c = cOrder_Vs_transactionId_Map.get(oddr.id);
                            shipmt.Plant_Delivery_Schedule__c=oddr.Plant_Order_Properties__r.Delivery_Schedule__c;
                            shipmt.Plant_Order__c = oddr.id;

                            insertNonRecurrShipments.add(shipmt);

                            // Update Subscription Order_Count__c
                            Plant_Subscription__c subscpt = new Plant_Subscription__c();
                            subscpt.Id = oddr.Plant_Subscription__c;
                            subscpt.Plant_Next_Charge_Date__c=oddr.Plant_Shipping_Date__r.Plant_Shipping_Date__c.addDays(5);
                            subscpt.Order_Count__c =1 ; 
                            subscpt.Plant_Status__c = 'Active';
                            subscpt.Plant_Next_Shipment_Date__c = Plant_Shipping_BC.getClosestShipmentDate(oddr.Plant_Shipping_Date__r.Plant_Shipping_Date__c.addDays(7), oddr.Plant_Order_Properties__r.Shipping_Address__c,NULL,NULL,NULL);
                            if(shipdateVsRecord.keyset().contains(subscpt.Plant_Next_Shipment_Date__c)){
                                subscpt.Plant_Shipping_Date__c = shipdateVsRecord.get(subscpt.Plant_Next_Shipment_Date__c).id;
                            }
                            Decimal shippingDuration = Plant_Shipping_BC.getShippingDuration(oddr.Plant_Order_Properties__r.Shipping_Address__c,NULL,NULL);
                            if(shippingDuration != NULL) {
                                subscpt.Plant_Next_Delivery_Date__c = subscpt.Plant_Next_Shipment_Date__c.addDays(Integer.valueOf(shippingDuration));
                            }
                            updateSubscription_List.add(subscpt);

                        }// AUTOMATIC ORDER
                        else {
                            // @ create shipment for current order
                            // @ create Order property from subscripiton
                            // @ create order
                            // @ create order line
                            // @ update subscription
                            
                            // CREATE SHIPMENT **
                            Plant_Shipment__c shipmt=new Plant_Shipment__c();
                            shipmt.Plant_Shipping_Address__c= oddr.Plant_Order_Properties__r.Shipping_Address__c;
                            shipmt.Plant_Status__c = 'Pending';
                            shipmt.Chargent_Transaction__c = cOrder_Vs_transactionId_Map.get(oddr.id);
                            shipmt.Plant_Delivery_Schedule__c=oddr.Plant_Order_Properties__r.Delivery_Schedule__c;
                            shipmt.Plant_Order__c = oddr.id;
                                insertNonRecurrShipments.add(shipmt);

                            // CREATE new order property 
                            // (CLONE existing and also pull from subscription)  **
                            Plant_Order_Properties__c nw_OrderProp = new Plant_Order_Properties__c();
                            nw_OrderProp.plan_discountedAmount__c = oddr.Plant_Order_Properties__r.plan_discountedAmount__c ;
                            nw_OrderProp.Plant_Account__c = oddr.Plant_Order_Properties__r.Plant_Account__c ;
                            nw_OrderProp.Plant_First_Name__c = oddr.Plant_Order_Properties__r.Plant_First_Name__c ;
                            nw_OrderProp.Plant_Last_Name__c = oddr.Plant_Order_Properties__r.Plant_Last_Name__c ;
                            nw_OrderProp.Plant_Phone__c = oddr.Plant_Order_Properties__r.Plant_Phone__c ;
                            nw_OrderProp.Plant_Can_SMS__c = oddr.Plant_Order_Properties__r.Plant_Can_SMS__c ;
                            nw_OrderProp.Plant_Email__c = oddr.Plant_Order_Properties__r.Plant_Email__c ;
                            nw_OrderProp.Shipping_Address__c = oddr.Plant_Subscription__r.Plant_Shipping_Address__c ;
                            
                            // new filed Plant_Subscription__r.Plant_Shipping_Date__c
                            nw_OrderProp.Plant_Shipping_Date__c =  oddr.Plant_Subscription__r.Plant_Shipping_Date__c;
                            nw_OrderProp.Plant_Delivery_Date__c =  oddr.Plant_Subscription__r.Plant_Next_Delivery_Date__c;
                            nw_OrderProp.Delivery_Schedule__c = oddr.Plant_Subscription__r.Plant_Delivery_Schedule__c;

                            nw_OrderProp.Plant_Meal_Selection__c = oddr.Plant_Subscription__r.Plant_Meal_Selection__c;
                            nw_OrderProp.Plant_Payment_Method__c = oddr.Plant_Subscription__r.Plant_Payment_Method__c ;
                            nw_OrderProp.Plant_Recurrence__c = oddr.Plant_Order_Properties__r.Plant_Recurrence__c ;
                            nw_OrderProp.Plant_Status__c = oddr.Plant_Order_Properties__r.Plant_Status__c ;
                            nw_OrderProp.Plant_Gift_Recipient__c = oddr.Plant_Order_Properties__r.Plant_Gift_Recipient__c ;
                                insertOrderProperty_Map.put(oddr.Id,nw_OrderProp);

                            // CLONE Order **
                            Order new_sfOrder = new Order();
                            new_sfOrder = oddr.clone(false, true, false, false);
                            new_sfOrder.Plant_Delivery_Date__c = nw_OrderProp.Plant_Delivery_Date__c;
                            new_sfOrder.Plant_Shipping_Date__c = nw_OrderProp.Plant_Shipping_Date__c;
                            new_sfOrder.EffectiveDate = System.today();
                            new_sfOrder.comty_Chargent_Order__c= oddr.Plant_Subscription__r.Plant_Chargent_Order__c;
                            new_sfOrder.status='Draft';
                            new_sfOrder.Plant_Transaction_Id__c=cOrder_Vs_transactionId_Map.get(oddr.Plant_Subscription__r.Plant_Chargent_Order__c);
                                insertOrder_Map.put(oddr.Id,new_sfOrder);

                            // CLONE ORDER LINE **
                            // create order item: GET PRODUCT(pricebook entry) BY ORDER PROPERTY RECORD TYPE
                            if(oddr.OrderItems.size()>0)
                                oldOrderItem_Map.put(oddr.Id,oddr.OrderItems[0]);


                            // UPDATE Subscription  **
                            Plant_Subscription__c subscpt = new Plant_Subscription__c();
                            subscpt.Id = oddr.Plant_Subscription__c;
                            subscpt.Plant_Next_Charge_Date__c=oddr.Plant_Subscription__r.Plant_Next_Charge_Date__c.addDays(7);
                            subscpt.Order_Count__c =oddr.Plant_Subscription__r.Order_Count__c+1; 
                            subscpt.Plant_Next_Shipment_Date__c = Plant_Shipping_BC.getClosestShipmentDate(oddr.Plant_Subscription__r.Plant_Next_Shipment_Date__c.addDays(7), oddr.Plant_Subscription__r.Plant_Shipping_Address__c,NULL,NULL,NULL);
                            System.debug('@@@@ Plant next shipment Date '+subscpt.Plant_Next_Shipment_Date__c);
                            system.debug('@@@@ Plant shipping Date Map Record : '+shipdateVsRecord);
        
                            if(shipdateVsRecord.keyset().contains(subscpt.Plant_Next_Shipment_Date__c)){
                                subscpt.Plant_Shipping_Date__c = shipdateVsRecord.get(subscpt.Plant_Next_Shipment_Date__c).id;
                            }
                            
                            subscpt.Plant_Status__c = 'Active';
                            Decimal shippingDuration = Plant_Shipping_BC.getShippingDuration(oddr.Plant_Subscription__r.Plant_Shipping_Address__c,NULL,NULL);
                            if(shippingDuration != NULL) {
                                subscpt.Plant_Next_Delivery_Date__c = subscpt.Plant_Next_Shipment_Date__c.addDays(Integer.valueOf(shippingDuration));
                            }
                            updateSubscription_List.add(subscpt);

                        }
                    }
                }
            }
                  
            // update current order status as "Active"
            if(!updateCurrent_Orders.isEmpty())
                update updateCurrent_Orders;

            // Insert Shipment
            if(!insertNonRecurrShipments.isEmpty())
                insert insertNonRecurrShipments;


            // insert order property
            if(!insertOrderProperty_Map.isEmpty())
                insert insertOrderProperty_Map.values();

            // add Order property to new Order records
            for(String odrId : insertOrderProperty_Map.keySet()){
                if(insertOrder_Map.containsKey(odrId)){
                    insertOrder_Map.get(odrId).Plant_Order_Properties__c = insertOrderProperty_Map.get(odrId).Id;
                }
            }

            // insert new Order
            if(!insertOrder_Map.isEmpty())
                 insert insertOrder_Map.values();

            // insert Order line
            for(String odrId : oldOrderItem_Map.keySet()){
                if(insertOrder_Map.containsKey(odrId)){
                    orderItem newOdl = oldOrderItem_Map.get(odrId).clone(false, true, false, false);
                    newOdl.OrderId = insertOrder_Map.get(odrId).id;
                    orderLine_ToInsert.add(newOdl);
                }
            }
            
            if(!orderLine_ToInsert.isEmpty())
                insert orderLine_ToInsert;

            // update subscription
            if(!updateSubscription_List.isEmpty())
                update updateSubscription_List;

            // Publish Post Order Events
            Plant_TransComm_BC.publishTransactionEvent(pubEvents);
        }
        catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD SUBSCRIPTION : line: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            // rollback to default savepoint in case of exception
            Database.rollback(sp_default);
        }
        
    }
    
}