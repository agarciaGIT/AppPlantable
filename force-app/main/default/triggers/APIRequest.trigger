trigger APIRequest on API_Request__c (before update) {
    for(API_Request__c obj : trigger.new) {
        System.debug('obj:' + obj);
        if(obj.Enable_Trigger__c == true) {
            shopifyClass.returnItems ri;
            
            if(obj.Request_Type__c != NULL) {
                if(obj.Request_Type__c == 'Subscription_Update')
                    ri = shopifyClass.setSubscription(obj, obj.Raw_Request__c, true);    
                else ri = shopifyClass.setOrder(obj, obj.Raw_Request__c, null);    
            } else {
                ri = shopifyClass.setOrder(obj, obj.Raw_Request__c, null);    
            }
            if(ri.apiReq != null) {
                obj = ri.apiReq;                
            }
            obj.Enable_Trigger__c = False;
            system.debug('returnItems' + ri); 
            obj = shopifyClass.processAPIRequest(ri,true);
        }
    }
}