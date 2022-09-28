trigger Plant_ShippingAddressTrigger on Plant_Shipping_Address__c (before insert, before update) {
    List<Plant_Shipping_Address__c> lstShipAddrs = new List<Plant_Shipping_Address__c>();
    for(Plant_Shipping_Address__c sa : Trigger.new){
        if(sa.Plant_Save_Shipping_Address__c == True) {
        	lstShipAddrs.add(sa);    
        }
    }
    System.debug('lstShipAddrs:' + lstShipAddrs);
	Plant_Shipping_BC.shippingAddressTriggerHandler(lstShipAddrs);
}