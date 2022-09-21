@RestResource(urlMapping='/subscriptions/*')
global class RESTSubscriptionsController {
 
    @HttpPost
    global static String setSubscription() {
        RestRequest req = RestContext.request;
        try {
            API_Request__c apiReq = new API_Request__c();
            shopifyClass.returnItems ri = new shopifyClass.returnItems();
            
            String rawJson = req.requestBody.toString();
            apiReq.Raw_Request__c = rawJson;
            insert apiReq;
            
            ri = shopifyClass.setSubscription(apiReq, rawJson, false);
            apiReq = ri.apiReq;
            apiReq.Response__c = String.ValueOf(ri);
            system.debug('returnItems' + ri);
            if(ri.apiLines != null)
                insert ri.apiLines;
              
            update apiReq;
        } catch (Exception e) {
            API_Request__c apiReq = new API_Request__c();
            String rawJson = req.requestBody.toString();
            apiReq.Response__c = e.getMessage();
            if(rawJson != null)
                apiReq.Raw_Request__c = rawJson;
            insert apiReq;
        }  
        
        return 'OK';
        
    }    
    
}