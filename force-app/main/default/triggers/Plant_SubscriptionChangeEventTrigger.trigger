trigger Plant_SubscriptionChangeEventTrigger on Plant_Subscription__ChangeEvent (after insert) {
    
    System.debug('!!!!Plant_Subscription__ChangeEvent');
    
	// AG - Used for legacy data load - then can deactivate.
    SET<String> subscriptionIDs = new SET<String>();
    for(Plant_Subscription__ChangeEvent event :Trigger.new){
        EventBus.ChangeEventHeader header = event.ChangeEventHeader;
        if (header.changetype == 'UPDATE' && event.Plant_Import_Legacy_Data__c == TRUE) {
            List<String> ids = header.getRecordIds();
            subscriptionIDs.add(ids[0]);    
        }
    }
    System.debug('subscriptionIDs:' + subscriptionIDs);
    Plant_Orders_BC_Helper.subscriptionLegacyLoadHandler(subscriptionIDs);

}