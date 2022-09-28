trigger Plant_PaymentMethodChangeEventTrigger on Plant_Payment_Method__ChangeEvent (after insert) {
    
    System.debug('!!!!Plant_Payment_Method__ChangeEvent');
    
    List<Plant_Payment_Method__c> lstPayMethods = new List<Plant_Payment_Method__c>();
    for(Plant_Payment_Method__ChangeEvent event :Trigger.new){
        EventBus.ChangeEventHeader header = event.ChangeEventHeader;
        System.debug('Received change event for ' + header.entityName +' for the ' + header.changeType + ' operation.');
        if (header.changetype == 'UPDATE' || header.changetype == 'INSERT') {
            if(event.Plant_Save_Payment_Method__c == True) {
                Plant_Payment_Method__c clonedPM = new Plant_Payment_Method__c(
                    Plant_Account__c = event.Plant_Account__c,
                    Plant_Is_Account_Record__c = event.Plant_Is_Account_Record__c,
                    Plant_Card_Number__c = event.Plant_Card_Number__c,
                    Plant_Card_Type__c = event.Plant_Card_Type__c,
                    CCV__c = event.CCV__c,
                    Plant_Card_Last_4_Digits__c = event.Plant_Card_Last_4_Digits__c,
                    Plant_City__c = event.Plant_City__c,
                    Plant_Country__c = event.Plant_Country__c,
                    Plant_Customer_Name__c = event.Plant_Customer_Name__c,
                    Plant_Expiration_Date__c = event.Plant_Expiration_Date__c,
                    Plant_Phone__c = event.Plant_Phone__c,
                    Plant_Postal_Code__c = event.Plant_Postal_Code__c,
                    Plant_Province_State__c = event.Plant_Province_State__c,
                    Plant_Street1__c = event.Plant_Street1__c,
                    Plant_Street2__c = event.Plant_Street2__c,
                    Plant_Street3__c = event.Plant_Street3__c
                );                
                lstPayMethods.add(clonedPM);
            }
        }
        
    }
    System.debug('lstPayMethods:' + lstPayMethods);
	Plant_Orders_BC.paymentMethodTriggerHandler(lstPayMethods);
}