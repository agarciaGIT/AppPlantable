public class Plant_TransComm_BC {


    public class pubTransEvent {
        public String type;
        public String accountId;
        public String orderId;
        public String subscriptionId; 
        public DateTime scheduleDateTime; 
    }

    public static pubTransEvent setTransactionEvent(String type, String accountId, String orderId, String subscriptionId) {
        Plant_TransComm_BC.pubTransEvent pte = new Plant_TransComm_BC.pubTransEvent();
        pte.type = type;
        pte.accountId = accountId;
        pte.orderId = orderId;
        pte.subscriptionId = subscriptionId;
        return pte;
    }
    
    public static void publishTransactionEvent(pubTransEvent pubEvents) {
        List<Plant_Transaction__e> events = new List<Plant_Transaction__e>();
        events.add(new Plant_Transaction__e(
            Plant_Type__c = pubEvents.type,
            Plant_AccountId__c = pubEvents.accountId,
            Plant_OrderId__c = pubEvents.orderId,
            Plant_SubscriptionId__c = pubEvents.subscriptionId
        ));     
        system.debug('new Plant_Transaction__e:' + events);
        
        // Call method to publish events
        List<Database.SaveResult> results = EventBus.publish(events);
        system.debug('Publish Plant_Transaction__e:' + results);
    }

	// AG - Publish Post Transaction Events
	// Testing:
	// List<Plant_TransComm_BC.pubTransEvent> pubEvents = new List<Plant_TransComm_BC.pubTransEvent>();
	// pubEvents.add(Plant_TransComm_BC.setTransactionEvent('Order Paid','0013J00000R2WHyQAN','8013J00000083oEQAQ',null));
	// pubEvents.add(Plant_TransComm_BC.setTransactionEvent('Subscription Created','0013J00000R2WHyQAN',null,'a1F3J00000094hZUAQ'));
	// Plant_TransComm_BC.publishTransactionEvents(pubEvents);
	// select id from Plant_Subscription__c where id = 'a1F3J00000094hZ'
	// 
	// Plant_TransComm_BC.publishTransactionEvent(Plant_TransComm_BC.setTransactionEvent('Order Paid','0013J00000R2WHyQAN','8013J00000083oEQAQ',null));    
	// Plant_TransComm_BC.publishTransactionEvent(Plant_TransComm_BC.setTransactionEvent('Order Meal Change','0013J00000R2WHyQAN','8013J00000083oEQAQ',null));    
	// Plant_TransComm_BC.publishTransactionEvent(Plant_TransComm_BC.setTransactionEvent('Order Date Change','0013J00000R2WHyQAN','8013J00000083oEQAQ',null));    
	// Plant_TransComm_BC.publishTransactionEvent(Plant_TransComm_BC.setTransactionEvent('Order Address Change','0013J00000R2WHyQAN','8013J00000083oEQAQ',null));    
	// Plant_TransComm_BC.publishTransactionEvent(Plant_TransComm_BC.setTransactionEvent('Order Cancelled','0013J00000R2WHyQAN','8013J00000083oEQAQ',null));    
    //
    // Plant_TransComm_BC.publishTransactionEvent(Plant_TransComm_BC.setTransactionEvent('Subscription Payment Change','0013J00000R2WHyQAN',null,'a1F3J00000094hZUAQ'));    
    // Plant_TransComm_BC.publishTransactionEvent(Plant_TransComm_BC.setTransactionEvent('Subscription Address Change','0013J00000R2WHyQAN',null,'a1F3J00000094hZUAQ'));    
    // Plant_TransComm_BC.publishTransactionEvent(Plant_TransComm_BC.setTransactionEvent('Subscription Date Change','0013J00000R2WHyQAN',null,'a1F3J00000094hZUAQ'));    
    // Plant_TransComm_BC.publishTransactionEvent(Plant_TransComm_BC.setTransactionEvent('Subscription Meal Change','0013J00000R2WHyQAN',null,'a1F3J00000094hZUAQ'));    
    // Plant_TransComm_BC.publishTransactionEvent(Plant_TransComm_BC.setTransactionEvent('Subscription Paused','0013J00000R2WHyQAN',null,'a1F3J00000094hZUAQ'));    
    // Plant_TransComm_BC.publishTransactionEvent(Plant_TransComm_BC.setTransactionEvent('Subscription Resumed','0013J00000R2WHyQAN',null,'a1F3J00000094hZUAQ'));
    // Plant_TransComm_BC.publishTransactionEvent(Plant_TransComm_BC.setTransactionEvent('Subscription Cancelled','0013J00000R2WHyQAN',null,'a1F3J00000094hZUAQ'));
    public static void publishTransactionEvents(List<pubTransEvent> pubEvents) {
        List<Plant_Transaction__e> events = new List<Plant_Transaction__e>();
        for(pubTransEvent pte :pubEvents) {
            events.add(new Plant_Transaction__e(
                Plant_Type__c = pte.type,
                Plant_AccountId__c = pte.accountId,
                Plant_OrderId__c = pte.orderId,
                Plant_SubscriptionId__c = pte.subscriptionId
            ));     
        }
        system.debug('new Plant_Transaction__e:' + events);
                    
        // Call method to publish events
        List<Database.SaveResult> results = EventBus.publish(events);
        system.debug('Publish Plant_Transaction__e:' + results);
    }
    
    // AG - Prepare a communication to go out in the future
    // Creates the TransComm record with just Type, and Lokups
    // Plant_ScheduledTransCommBatch.cls will run looking for these to call sendTransComm()
    // Testing:
    // Date dt = Date.today();
    // Plant_TransComm_BC.stageScheduledTransComm('Subscription Payment Upcoming','0013J00000R2NxfQAF',null,'a1F3J00000094Z1',dt);
    public static void stageScheduledTransComm(String type, String accountId, String orderId, String subscriptionId, Date scheduleDate) {
        
        // Get Schedule Settings
		Map<String, Plant_Scheduled_Comms__c> settings = Plant_Scheduled_Comms__c.getAll();
        system.debug('settings:' + settings);
        
        // Get Automated User Offset
        Integer offset = Integer.valueOf(System.Label.PlantAutomatedUserOffset);
        String UserInfoName = UserInfo.getName();//Returns the context user's full name.
        System.Debug('UserInfoName:' + UserInfoName);
        if(UserInfoName != 'Automated Process') {
            offset = 0;
        }

        
        // Find duplicate staged transactions
        List<Plant_Transaction_Comm__c> existingTransComm = [select id from Plant_Transaction_Comm__c 
                                                             where Plant_Status__c = 'Scheduled' AND Plant_Account__c = :accountId AND
                                                             Plant_Type__c = :type AND (Plant_Order__c = :orderId OR Plant_Subscription__c = :subscriptionId)];
        
        system.debug('existingTransComm:' + existingTransComm);
        
        
        // If found, cancel them
        if(!existingTransComm.isEmpty()) {
            for(Plant_Transaction_Comm__c tc :existingTransComm) {
                tc.Plant_Status__c = 'Cancelled';
            }
            system.debug('update existingTransComm:' + existingTransComm);
            update existingTransComm;
        }
        
        // Setup Date and Time to send
        Plant_Scheduled_Comms__c setting = settings.get(type);
        if(Test.isRunningTest()) {
            setting = new Plant_Scheduled_Comms__c();
            setting.Time__c = 8;
            setting.Days_Before_After__c = 0;
        }
        if(setting != NULL) {
            DateTime dt = DateTime.newInstance(scheduleDate.year(), scheduleDate.month(), 
                                               scheduleDate.addDays(Integer.valueOf(setting.Days_Before_After__c)).day(), 
                                               Integer.valueOf(setting.Time__c + offset), 0, 0);
            
            system.debug('dt:' + dt);
            
            // Insert Scheduled Transaction Comm
            Plant_Transaction_Comm__c newTransComm = new Plant_Transaction_Comm__c(
                Plant_Type__c = type,
                Plant_Account__c = accountId,
                Plant_Order__c = orderId,
                Plant_Subscription__c = subscriptionId,
                Plant_Schedule_Date_Time__c = dt,
                Plant_Status__c = 'Scheduled'
            );
            system.debug('insert newTransComm:' + newTransComm);
            insert newTransComm;
        }
        
    }
    
    // AG - Cancel Scheduled Communication
    // Testing:
    // Plant_TransComm_BC.cancelStagedScheduledTransComm('Subscription Payment Upcoming', '0013J00000R2WHyQAN',null,'a1F3J00000094hZUAQ')
    public static void cancelStagedScheduledTransComm(String type, String accountId, String orderId, String subscriptionId) {
        // Find duplicate staged transactions
        List<Plant_Transaction_Comm__c> existingTransComm = [select id from Plant_Transaction_Comm__c 
                                                             where Plant_Status__c = 'Scheduled' AND Plant_Account__c = :accountId AND
                                                             Plant_Type__c = :type AND (Plant_Order__c = :orderId OR Plant_Subscription__c = :subscriptionId)];
        
        system.debug('existingTransComm:' + existingTransComm);
        
        
        // If found, cancel them
        if(!existingTransComm.isEmpty()) {
            for(Plant_Transaction_Comm__c tc :existingTransComm) {
                tc.Plant_Status__c = 'Cancelled';
            }
            system.debug('update existingTransComm:' + existingTransComm);
            update existingTransComm;
        }
    }
    
    public static void sendTransComm(String plantTransCommId) {
        
        system.debug('sendTransComm:' + plantTransCommId);
        
        list<Plant_Transaction_Comm__c> transComms = [select Id, Name, Plant_Status__c, Plant_Type__c, Plant_Account__c, Plant_Shipping_Date__c,
                                                      Plant_Account__r.Email__c, Plant_Account__r.First_Name__c, Plant_Account__r.Last_Name__c,
                                                      Plant_Order_Shipment_Tracking_Number__c,
                                                      
                                                      Plant_Order__r.Plant_Shipping_Date__r.Plant_Shipping_Date__c,
                                                      Plant_Order__r.Plant_Order_Properties__r.Shipping_Address__r.Plant_Street1__c,
                                                      Plant_Order__r.Plant_Order_Properties__r.Shipping_Address__r.Plant_Street2__c,
                                                      Plant_Order__r.Plant_Order_Properties__r.Shipping_Address__r.Plant_Street3__c,
                                                      Plant_Order__r.Plant_Order_Properties__r.Shipping_Address__r.Plant_City__c,
                                                      Plant_Order__r.Plant_Order_Properties__r.Shipping_Address__r.Plant_Province_State__c,
                                                      Plant_Order__r.Plant_Order_Properties__r.Shipping_Address__r.Plant_Postal_Code__c,
                                                      Plant_Order__r.Plant_Order_Properties__r.Shipping_Address__r.Plant_Country__c,
                                                      Plant_Order__r.Plant_Order_Properties__r.Plant_Delivery_Date__c,
                                                      Plant_Order__r.Plant_Order_Properties__r.Plant_Provider__c,
                                                      Plant_Order__r.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Card_Type__c,
                                                      Plant_Order__r.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Card_Last_4_Digits__c,
                                                      Plant_Order__r.Plant_Order_Properties__r.Plant_Meal_Selection__c,
                                                      Plant_Order__r.Plant_Order_Properties__r.RecordType.Name,
                                                      Plant_Order__r.TotalAmount,
                                                      Plant_Order__r.Plant_Main_Product__c,
                                                      
                                                      Plant_Subscription_Address__c, Plant_Subscription_Charge_Day__c,
                                                      Plant_Subscription_Meals__c, Plant_Subscription_Next_Charge_Date__c,
                                                      Plant_Subscription_Next_Delivery_Date__c, Plant_Subscription_Next_Shipment_Date__c,
                                                      Plant_Subscription_Payment_Method__c, Plant_Subscription_Status__c,
                                                      Plant_Subscription_Type__c,Plant_Subscription_Amount__c,
                                                      
                                                      Plant_Order__r.Plant_Subscription__c,  
                                                      Plant_Order__r.Plant_Subscription__r.Plant_Amount__c,
                                                      Plant_Order__r.Plant_Subscription__r.Plant_Meal_Selection__c,
                                                      Plant_Order__r.Plant_Subscription__r.Plant_Shipping_Address__r.Plant_Street1__c,
                                                      Plant_Order__r.Plant_Subscription__r.Plant_Shipping_Address__r.Plant_Street2__c,
                                                      Plant_Order__r.Plant_Subscription__r.Plant_Shipping_Address__r.Plant_Street3__c,
                                                      Plant_Order__r.Plant_Subscription__r.Plant_Shipping_Address__r.Plant_City__c,
                                                      Plant_Order__r.Plant_Subscription__r.Plant_Shipping_Address__r.Plant_Province_State__c,
                                                      Plant_Order__r.Plant_Subscription__r.Plant_Shipping_Address__r.Plant_Postal_Code__c,
                                                      Plant_Order__r.Plant_Subscription__r.Plant_Shipping_Address__r.Plant_Country__c,
													  Plant_Order__r.Plant_Subscription__r.Plant_Charge_Day__c,
                                                      Plant_Order__r.Plant_Subscription__r.Plant_Next_Charge_Date__c,
                                                      Plant_Order__r.Plant_Subscription__r.Plant_Next_Delivery_Date__c,
                                                      Plant_Order__r.Plant_Subscription__r.Plant_Next_Shipment_Date__c,
                                                      Plant_Order__r.Plant_Subscription__r.Plant_Payment_Method__r.Plant_Card_Type__c,
                                                      Plant_Order__r.Plant_Subscription__r.Plant_Payment_Method__r.Plant_Card_Last_4_Digits__c,
                                                      Plant_Order__r.Plant_Subscription__r.Plant_Status__c,
                                                      Plant_Order__r.Plant_Subscription__r.RecordType.Name,
                                                      
                                                      Plant_Subscription__c,  
                                                      Plant_Subscription__r.Plant_Amount__c,
                                                      Plant_Subscription__r.Plant_Meal_Selection__c,
                                                      Plant_Subscription__r.Plant_Shipping_Address__r.Plant_Street1__c,
                                                      Plant_Subscription__r.Plant_Shipping_Address__r.Plant_Street2__c,
                                                      Plant_Subscription__r.Plant_Shipping_Address__r.Plant_Street3__c,
                                                      Plant_Subscription__r.Plant_Shipping_Address__r.Plant_City__c,
                                                      Plant_Subscription__r.Plant_Shipping_Address__r.Plant_Province_State__c,
                                                      Plant_Subscription__r.Plant_Shipping_Address__r.Plant_Postal_Code__c,
                                                      Plant_Subscription__r.Plant_Shipping_Address__r.Plant_Country__c,
													  Plant_Subscription__r.Plant_Charge_Day__c,
                                                      Plant_Subscription__r.Plant_Next_Charge_Date__c,
                                                      Plant_Subscription__r.Plant_Next_Delivery_Date__c,
                                                      Plant_Subscription__r.Plant_Next_Shipment_Date__c,
                                                      Plant_Subscription__r.Plant_Payment_Method__r.Plant_Card_Type__c,
                                                      Plant_Subscription__r.Plant_Payment_Method__r.Plant_Card_Last_4_Digits__c,
                                                      Plant_Subscription__r.Plant_Status__c,
                                                      Plant_Subscription__r.RecordType.Name,

                                                      Plant_Customer_Email__c, Plant_Error_Message__c, Plant_Comm_Sent__c
                                                      from Plant_Transaction_Comm__c where id = :plantTransCommId and Plant_Status__c in ('Created','Scheduled')];
        system.debug('transComms:' + transComms);
    
        if(!transComms.isEmpty()) {
            Plant_Transaction_Comm__c transComm = transComms[0];
            system.debug('transComm:' + transComm);
                        
            // Prep Data
            transComm.Plant_Customer_Email__c = transComm.Plant_Account__r.Email__c;
            transComm.Plant_Customer_Name__c = transComm.Plant_Account__r.First_Name__c + ' ' + transComm.Plant_Account__r.Last_Name__c;
            system.debug('prep1 transComm:' + transComm);
            
            if(transComm.Plant_Order__c != NULL && transComm.Plant_Order__r.Plant_Order_Properties__c != NULL) {
                
                // Get Shipment Info
                List<Plant_Shipment__c> lstShip = [select Id, Plant_Tracking_Number__c from Plant_Shipment__c where Plant_Order__c = :transComm.Plant_Order__c];
                if(!lstShip.isEmpty()) {
                    transComm.Plant_Order_Shipment_Tracking_Number__c = lstShip[0].Plant_Tracking_Number__c;
                }

                transComm.Plant_Payment_Method__c = transComm.Plant_Order__r.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Card_Type__c + ' ' + transComm.Plant_Order__r.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Card_Last_4_Digits__c;
                transComm.Plant_Estimated_Delivery__c = transComm.Plant_Order__r.Plant_Order_Properties__r.Plant_Delivery_Date__c;
                transComm.Plant_Product__c = transComm.Plant_Order__r.Plant_Main_Product__c;
                transComm.Plant_Transaction_Amount__c = transComm.Plant_Order__r.TotalAmount;
                transComm.Plant_Shipping_Date__c = transComm.Plant_Order__r.Plant_Shipping_Date__r.Plant_Shipping_Date__c;
                
                if(transComm.Plant_Order__r.Plant_Order_Properties__r.Shipping_Address__c != NULL) {
                    String strAddr = transComm.Plant_Order__r.Plant_Order_Properties__r.Shipping_Address__r.Plant_Street1__c;
                    if(transComm.Plant_Order__r.Plant_Order_Properties__r.Shipping_Address__r.Plant_Street2__c != NULL)
                        strAddr = strAddr + '\n' + transComm.Plant_Order__r.Plant_Order_Properties__r.Shipping_Address__r.Plant_Street2__c;
                    if(transComm.Plant_Order__r.Plant_Order_Properties__r.Shipping_Address__r.Plant_Street3__c != NULL)
                        strAddr = strAddr + '\n' + transComm.Plant_Order__r.Plant_Order_Properties__r.Shipping_Address__r.Plant_Street3__c;
                    strAddr = strAddr + '\n' + transComm.Plant_Order__r.Plant_Order_Properties__r.Shipping_Address__r.Plant_City__c;
                    strAddr = strAddr + ', ' + transComm.Plant_Order__r.Plant_Order_Properties__r.Shipping_Address__r.Plant_Province_State__c;
                    strAddr = strAddr + ', ' + transComm.Plant_Order__r.Plant_Order_Properties__r.Shipping_Address__r.Plant_Postal_Code__c;
                    strAddr = strAddr + ', ' + transComm.Plant_Order__r.Plant_Order_Properties__r.Shipping_Address__r.Plant_Country__c;
                    transComm.Plant_Customer_Address__c = strAddr;
                    system.debug('prep2 transComm:' + transComm);
                }
                
                if(transComm.Plant_Order__r.Plant_Order_Properties__r.Plant_Meal_Selection__c != NULL) {
                    List<Plant_Meal_Selection_Meal__c> lstMeals = [select Id, Plant_Quantity__c, Plant_Meal__r.Name 
                                                                   FROM Plant_Meal_Selection_Meal__c 
                                                                   WHERE Plant_Meal_Selection__c = :transComm.Plant_Order__r.Plant_Order_Properties__r.Plant_Meal_Selection__c ORDER BY Plant_Quantity__c];
                    system.debug('lstMeals:' + lstMeals);
                    transComm.Plant_Meals__c = '';
                    for(Plant_Meal_Selection_Meal__c msm :lstMeals) {
                        transComm.Plant_Meals__c = transComm.Plant_Meals__c + msm.Plant_Quantity__c;
                        transComm.Plant_Meals__c = transComm.Plant_Meals__c + ' ' + msm.Plant_Meal__r.Name + '<br>';
                    }
                    system.debug('prep3 transComm:' + transComm);
                }
                
                if(transComm.Plant_Order__r.Plant_Subscription__c != NULL) {
                    
                    if(transComm.Plant_Order__r.Plant_Subscription__r.Plant_Shipping_Address__c != NULL) {
                        String strAddr = transComm.Plant_Order__r.Plant_Subscription__r.Plant_Shipping_Address__r.Plant_Street1__c;
                        if(transComm.Plant_Order__r.Plant_Subscription__r.Plant_Shipping_Address__r.Plant_Street2__c != NULL)
                            strAddr = strAddr + '\n' + transComm.Plant_Order__r.Plant_Subscription__r.Plant_Shipping_Address__r.Plant_Street2__c;
                        if(transComm.Plant_Order__r.Plant_Subscription__r.Plant_Shipping_Address__r.Plant_Street3__c != NULL)
                            strAddr = strAddr + '\n' + transComm.Plant_Order__r.Plant_Subscription__r.Plant_Shipping_Address__r.Plant_Street3__c;
                        strAddr = strAddr + '\n' + transComm.Plant_Order__r.Plant_Subscription__r.Plant_Shipping_Address__r.Plant_City__c;
                        strAddr = strAddr + ', ' + transComm.Plant_Order__r.Plant_Subscription__r.Plant_Shipping_Address__r.Plant_Province_State__c;
                        strAddr = strAddr + ', ' + transComm.Plant_Order__r.Plant_Subscription__r.Plant_Shipping_Address__r.Plant_Postal_Code__c;
                        strAddr = strAddr + ', ' + transComm.Plant_Order__r.Plant_Subscription__r.Plant_Shipping_Address__r.Plant_Country__c;
                        transComm.Plant_Subscription_Address__c = strAddr;
                        system.debug('prep4 transComm:' + transComm);
                    }
                    
                    if(transComm.Plant_Order__r.Plant_Subscription__r.Plant_Meal_Selection__c != NULL) {
                        List<Plant_Meal_Selection_Meal__c> lstMeals = [select Id, Plant_Quantity__c, Plant_Meal__r.Name 
                                                                       FROM Plant_Meal_Selection_Meal__c 
                                                                       WHERE Plant_Meal_Selection__c = :transComm.Plant_Order__r.Plant_Subscription__r.Plant_Meal_Selection__c ORDER BY Plant_Quantity__c];
                        system.debug('lstMeals:' + lstMeals);
                        transComm.Plant_Subscription_Meals__c = '';
                        for(Plant_Meal_Selection_Meal__c msm :lstMeals) {
                            transComm.Plant_Subscription_Meals__c = transComm.Plant_Subscription_Meals__c + msm.Plant_Quantity__c;
                            transComm.Plant_Subscription_Meals__c = transComm.Plant_Subscription_Meals__c + ' ' + msm.Plant_Meal__r.Name + '<br>';
                        }
                        system.debug('prep5 transComm:' + transComm);
                    }                        
                    
                    transComm.Plant_Subscription_Charge_Day__c = transComm.Plant_Order__r.Plant_Subscription__r.Plant_Charge_Day__c;
                    transComm.Plant_Subscription_Next_Charge_Date__c = transComm.Plant_Order__r.Plant_Subscription__r.Plant_Next_Charge_Date__c;
                    transComm.Plant_Subscription_Next_Delivery_Date__c = transComm.Plant_Order__r.Plant_Subscription__r.Plant_Next_Delivery_Date__c;
                    transComm.Plant_Subscription_Next_Shipment_Date__c = transComm.Plant_Order__r.Plant_Subscription__r.Plant_Next_Shipment_Date__c;
                    transComm.Plant_Subscription_Payment_Method__c = transComm.Plant_Order__r.Plant_Subscription__r.Plant_Payment_Method__r.Plant_Card_Type__c + ' ' + transComm.Plant_Order__r.Plant_Subscription__r.Plant_Payment_Method__r.Plant_Card_Last_4_Digits__c; 
                    transComm.Plant_Subscription_Status__c = transComm.Plant_Order__r.Plant_Subscription__r.Plant_Status__c;
                    transComm.Plant_Subscription_Type__c = transComm.Plant_Order__r.Plant_Subscription__r.RecordType.Name;
                    transComm.Plant_Subscription_Amount__c = transComm.Plant_Order__r.Plant_Subscription__r.Plant_Amount__c;
                    system.debug('prep6 transComm:' + transComm);
                }
            }
            
            if(transComm.Plant_Subscription__c != NULL) {
                
                String strAddr = transComm.Plant_Subscription__r.Plant_Shipping_Address__r.Plant_Street1__c;
                if(transComm.Plant_Subscription__r.Plant_Shipping_Address__r.Plant_Street2__c != NULL)
                    strAddr = strAddr + '\n' + transComm.Plant_Subscription__r.Plant_Shipping_Address__r.Plant_Street2__c;
                if(transComm.Plant_Subscription__r.Plant_Shipping_Address__r.Plant_Street3__c != NULL)
                    strAddr = strAddr + '\n' + transComm.Plant_Subscription__r.Plant_Shipping_Address__r.Plant_Street3__c;
                strAddr = strAddr + '\n' + transComm.Plant_Subscription__r.Plant_Shipping_Address__r.Plant_City__c;
                strAddr = strAddr + ', ' + transComm.Plant_Subscription__r.Plant_Shipping_Address__r.Plant_Province_State__c;
                strAddr = strAddr + ', ' + transComm.Plant_Subscription__r.Plant_Shipping_Address__r.Plant_Postal_Code__c;
                strAddr = strAddr + ', ' + transComm.Plant_Subscription__r.Plant_Shipping_Address__r.Plant_Country__c;
                transComm.Plant_Subscription_Address__c = strAddr;
                system.debug('prep7 transComm:' + transComm);
                
                if(transComm.Plant_Subscription__r.Plant_Meal_Selection__c != NULL) {
                    List<Plant_Meal_Selection_Meal__c> lstMeals = [select Id, Plant_Quantity__c, Plant_Meal__r.Name 
                                                                   FROM Plant_Meal_Selection_Meal__c 
                                                                   WHERE Plant_Meal_Selection__c = :transComm.Plant_Subscription__r.Plant_Meal_Selection__c ORDER BY Plant_Quantity__c];
                    system.debug('lstMeals:' + lstMeals);
                    transComm.Plant_Subscription_Meals__c = '';
                    for(Plant_Meal_Selection_Meal__c msm :lstMeals) {
                        transComm.Plant_Subscription_Meals__c = transComm.Plant_Subscription_Meals__c + msm.Plant_Quantity__c;
                        transComm.Plant_Subscription_Meals__c = transComm.Plant_Subscription_Meals__c + ' ' + msm.Plant_Meal__r.Name + '<br>';
                    }
                    system.debug('prep5 transComm:' + transComm);
                }                        
                
                transComm.Plant_Subscription_Charge_Day__c = transComm.Plant_Subscription__r.Plant_Charge_Day__c;
                transComm.Plant_Subscription_Next_Charge_Date__c = transComm.Plant_Subscription__r.Plant_Next_Charge_Date__c;
                transComm.Plant_Subscription_Next_Delivery_Date__c = transComm.Plant_Subscription__r.Plant_Next_Delivery_Date__c;
                transComm.Plant_Subscription_Next_Shipment_Date__c = transComm.Plant_Subscription__r.Plant_Next_Shipment_Date__c;
                transComm.Plant_Subscription_Payment_Method__c = transComm.Plant_Subscription__r.Plant_Payment_Method__r.Plant_Card_Type__c + ' ' + transComm.Plant_Subscription__r.Plant_Payment_Method__r.Plant_Card_Last_4_Digits__c; 
                transComm.Plant_Subscription_Status__c = transComm.Plant_Subscription__r.Plant_Status__c;
                transComm.Plant_Subscription_Type__c = transComm.Plant_Subscription__r.RecordType.Name;
                transComm.Plant_Subscription_Amount__c = transComm.Plant_Subscription__r.Plant_Amount__c;
                system.debug('prep6 transComm:' + transComm);
                
            }
            system.debug('after transComms:' + transComms);
            update transComms;
            
            Plant_Transaction_Comm__c updateTransComm = sendSalesforceEmail(transComm);
            system.debug('updateTransComm:' + updateTransComm);
            
            update updateTransComm;
        }        
    }


    public static Plant_Transaction_Comm__c sendSalesforceEmail(Plant_Transaction_Comm__c transComm) {        
        String orgWideId = Label.PlantTransCommOrgWideId;
        
        system.debug('transComm:' + transComm);
        system.debug('orgWideId:' + orgWideId);

        List<EmailTemplate> lstEmailTemplates = [SELECT Id, Body, Subject, HtmlValue from EmailTemplate where Name = :transComm.Plant_Type__c];
        List<OrgWideEmailAddress> lstOrgWide = [select Id, Address, DisplayName from OrgWideEmailAddress where Id = :orgWideId];
        
        system.debug('lstEmailTemplates:' + lstEmailTemplates);
        system.debug('lstOrgWide:' + lstOrgWide);
        
        if(transComm != NULL && transComm.Plant_Account__c != NULL && lstEmailTemplates != null && lstEmailTemplates.size() > 0 && lstOrgWide != null && lstOrgWide.size() > 0) {
            
            List<Contact> lstCont = [select Id from Contact where AccountId = :transComm.Plant_Account__c];
            system.debug('lstCont:' + lstCont);
            
            if(!lstCont.isEmpty()) {
                List<String> bodies = new List<String>();
                bodies.add(lstEmailTemplates[0].HtmlValue);
                
                List<Messaging.RenderEmailTemplateBodyResult> resList = 
                    Messaging.renderEmailTemplate(transComm.Plant_Account__c, transComm.Id, bodies);
                
                String msg;
                if(!resList.IsEmpty()) {
                    msg = resList[0].getMergedBody();
                    msg = msg.replace('Plant_TransCommEmailTracker', 'XXX');
                    system.debug('msg:' + msg);
                }
                transComm.Plant_Comm_Sent__c = msg;
                
                // Send Email - just sent this to True, Flow will send the email
                transComm.Plant_Send__c = True;
                    
                //String errMsg = sendEmail(lstEmailTemplates[0].Id, lstCont[0].Id, 'noreply@plantable.com', transComm.Id, orgWideId);
                //if(errMsg == NULL) {
                //    transComm.Plant_Status__c = 'Sent';
                //} else {
                //    transComm.Plant_Status__c = 'Error';
                //    transComm.Plant_Error_Message__c = errMsg;
                //}
                            
            }

        }
        return transComm;
    }
    
        public static PageReference emailTracker() {
        
        // Can test with these:
        // https://euphebe--hicdev.sandbox.my.site.com/apex/Plant_TransCommEmailTracker?recid=a1Z3J0000011mvF
        // https://euphebe--hicdev.sandbox.my.site.com/apex/Plant_TransCommEmailTracker?recid=a1Z3J0000011mvF&url=https%3A%2F%2Fcheckout.plantable.com%2Faccount%2Flogin
        
        PageReference pg = null;
        
        // Get the Notification Recipient ID
        String recid = ApexPages.currentPage().getParameters().get('recid');
        system.debug('recid:' + recid);

        String url = ApexPages.currentPage().getParameters().get('url');
        system.debug('url:' + url);
        
        List<Plant_Transaction_Comm__c> lstRec = [select Id, Plant_Is_Open__c, Plant_Open_Date_Time__c, Plant_Is_Clicked__c, Plant_Is_Clicked_Date_Time__c from Plant_Transaction_Comm__c where id = :recid];
        system.debug('lstRec:' + lstRec);
        if(!lstRec.isEmpty()) {
            lstRec[0].Plant_Is_Open__c = True;
            lstRec[0].Plant_Open_Date_Time__c =  DateTime.now();
            if(url != NULL) {
                lstRec[0].Plant_Is_Clicked__c = True;
                lstRec[0].Plant_Is_Clicked_Date_Time__c =  DateTime.now();
                if(url.indexOf('http') > -1) {
                    pg = new PageReference(url);
                } else {
                    pg = new PageReference('/Login?start=' + url);
                }
                pg.setRedirect(true);
            }
            update lstRec;
        }
        
        return pg;
    }

 	/** use email alert and flow instead    
    public static String sendEmail(String templateId, String targetId, String replyTo, String whatObj, String ogrWideID) {

        system.debug('sendEmail');
        system.debug('templateId:' + templateId);
        system.debug('targetId:' + targetId);
        system.debug('replyTo:' + replyTo);
        system.debug('whatObj:' + whatObj);
        system.debug('ogrWideID:' + ogrWideID);
        
        String ret=null;
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTemplateId(templateId);
        mail.setSaveAsActivity(false);
        mail.setTargetObjectId(targetId);        
        mail.setReplyTo(replyTo);
        mail.setWhatId(whatObj);
        mail.setOrgWideEmailAddressId(ogrWideID);
        
        try {
            Messaging.SendEmailResult[] resultMail = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
            system.debug('resultMail:' + resultMail);
            if(!resultMail[0].isSuccess()) {
                List<Messaging.SendEmailError> errors = resultMail[0].getErrors(); 
                if(!errors.isEmpty()) {
                    ret = errors[0].getMessage();
                }
            }
        } catch(System.EmailException e) {
            System.debug('EmailException error: '+ e);
            ret = e.getMessage();
        }
        
        return ret;
    }
	**/
}