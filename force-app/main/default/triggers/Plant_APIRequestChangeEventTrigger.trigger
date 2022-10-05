trigger Plant_APIRequestChangeEventTrigger on API_Request__ChangeEvent (after insert) {

    System.debug('!!!!Plant_APIRequestChangeEventTrigger');
    
	// AG - Used for legacy data load - then can deactivate.
    SET<String> apiReqsIDs = new SET<String>();
    for(API_Request__ChangeEvent event :Trigger.new){
        EventBus.ChangeEventHeader header = event.ChangeEventHeader;
        if (header.changetype == 'UPDATE' && event.Enable_Automation__c == TRUE) {
            List<String> ids = header.getRecordIds();
            apiReqsIDs.add(ids[0]);    
        }
    }
    System.debug('apiReqsIDs:' + apiReqsIDs);
    for(String apir :apiReqsIDs) {
    	Plant_Orders_BC_Helper.subscriptionLegacyLoadHandler(apiReqsIDs);    
    }
    
}