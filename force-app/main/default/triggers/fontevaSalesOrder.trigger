trigger fontevaSalesOrder on OrderApi__Sales_Order__c (after update) {
    Set<String> registrationIds = new Set<String>();
    Set<String> salesIds = new Set<String>();
    
    for(OrderApi__Sales_Order__c obj : trigger.New) {
        System.debug('SalesOrder obj:' + obj);
        System.debug('SalesOrder OrderApi__Is_Voided__c:' + obj.OrderApi__Is_Voided__c);
        System.debug('SalesOrder OrderApi__Is_Closed__c:' + obj.OrderApi__Is_Closed__c);
        System.debug('SalesOrder OrderApi__Is_Posted__c:' + obj.OrderApi__Is_Posted__c);
        System.debug('SalesOrder OrderApi__Is_Posted__c OLD:' + Trigger.oldMap.get(obj.Id).OrderApi__Is_Posted__c);
        
        // Order Paid
        if(obj.OrderApi__Overall_Total__c > 0 && obj.OrderApi__Amount_Paid__c == obj.OrderApi__Overall_Total__c && obj.OrderApi__Amount_Paid__c != Trigger.oldMap.get(obj.Id).OrderApi__Amount_Paid__c) {
            salesIds.add(obj.id);        
        }
        
        // Free Order Completed
        else if(obj.OrderApi__Overall_Total__c == 0 && obj.OrderApi__Is_Posted__c == TRUE && Trigger.oldMap.get(obj.Id).OrderApi__Is_Posted__c == FALSE) {
            salesIds.add(obj.id);
        }
    }
    
    LIST<EventApi__Attendee__c> lstAtt = [select Id from EventApi__Attendee__c where EventApi__Sales_Order__c in :salesIds];
    for(EventApi__Attendee__c att :lstAtt) {
        registrationIds.add(att.id);
    }
    
    //System.assert(false, 'BOOM!!!!' + registrationIds); 
    System.debug('registrationIds obj:' + registrationIds);
    
    if(!registrationIds.isEmpty()) {    
        FontevaClass.setRegistrations(registrationIds);
    }
}