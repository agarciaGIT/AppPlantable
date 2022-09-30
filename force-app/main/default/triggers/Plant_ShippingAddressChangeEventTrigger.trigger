trigger Plant_ShippingAddressChangeEventTrigger on Plant_Shipping_Address__ChangeEvent (after insert) {

    System.debug('!!!!Plant_Shipping_Address__changeEvent');
    
    List<Plant_Shipping_Address__c> lstCreatedShipAddresses = new List<Plant_Shipping_Address__c>();
    List<String> lstUpdatedShipAddressIds = new List<String>();
    for(Plant_Shipping_Address__changeEvent event :Trigger.new){
        
        System.debug('event:' + event);
       
        EventBus.ChangeEventHeader header = event.ChangeEventHeader;
        System.debug('Received change event for ' + header.entityName +' for the ' + header.changeType + ' operation.');
        if (header.changetype == 'CREATE') {
            if(event.Plant_Save_Shipping_Address__c == True) {
                Plant_Shipping_Address__c clonedSA = new Plant_Shipping_Address__c(
                    Plant_Account__c = event.Plant_Account__c,
                    Plant_Is_Account_Record__c = event.Plant_Is_Account_Record__c,
                    Plant_Save_Shipping_Address__c  = event.Plant_Save_Shipping_Address__c,
                    Plant_First_Name__c = event.Plant_First_Name__c,
                    Plant_Last_Name__c = event.Plant_Last_Name__c,
                    Plant_Can_SMS__c = event.Plant_Can_SMS__c,
                    Plant_Phone__c = event.Plant_Phone__c,
                    Plant_Street1__c = event.Plant_Street1__c,
                    Plant_Street2__c = event.Plant_Street2__c,
                    Plant_Street3__c = event.Plant_Street3__c,
                    Plant_City__c = event.Plant_City__c,
                    Plant_Province_State__c = event.Plant_Province_State__c,
                    Plant_Postal_Code__c = event.Plant_Postal_Code__c,
                    Plant_Country__c = event.Plant_Country__c
                );                
                lstCreatedShipAddresses.add(clonedSA);
            }
        } else if(header.changetype == 'UPDATE') {
            List<String> lstIds = header.getRecordIds();
            for(String pmid :lstIds) {
                lstUpdatedShipAddressIds.add(pmid);
            }
        }
        
    }
    System.debug('lstCreatedShipAddresses:' + lstCreatedShipAddresses);
    System.debug('lstUpdatedShipAddressIds:' + lstUpdatedShipAddressIds);
    if(!lstCreatedShipAddresses.isEmpty() || !lstUpdatedShipAddressIds.isEmpty()) {
    	Plant_Shipping_BC.shippingAddressTriggerHandler(lstCreatedShipAddresses, lstUpdatedShipAddressIds);    
    }
}