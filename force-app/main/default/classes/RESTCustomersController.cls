@RestResource(urlMapping='/customers/*')
global class RESTCustomersController {
    
    public static void processRequest(String rawJson) {
        API_Request__c apiReq = new API_Request__c();
        apiReq.Raw_Request__c = rawJson;
        insert apiReq;
        shopifyClass.returnItems ri = new shopifyClass.returnItems();
        apiReq = shopifyClass.setCustomer(apiReq, rawJson);
        //apiReq = ri.apiReq;
        apiReq.Response__c = String.ValueOf(ri);
        system.debug('apiReq' + apiReq);
        //if(ri.apiLines != null)
        //    insert ri.apiLines;
        apiReq.Enable_Automation__c = true;
        if(!Test.isRunningTest())
        	update apiReq;
    }
    
    public static void processError(RestRequest req, String expMsg) {
        API_Request__c apiReq = new API_Request__c();
        String rawJson = req.requestBody.toString();
        apiReq.Response__c = expMsg;
        if(rawJson != null)
            apiReq.Raw_Request__c = rawJson;
        insert apiReq;    
    }
    
    @HttpPost  
    //global static String setOrder(String orderNumber, String productCode, Integer amount, String customerEmail) {
    global static String setCustomer() {
        RestRequest req = RestContext.request;
        try {           
            String rawJson = req.requestBody.toString();
            processRequest(rawJson);            
        } catch (Exception e) {
            if(req != null) {
                processError(req, e.getMessage());
            }
        }  
        
        return 'OK';
        
    }        

    @HttpGet  
    //global static String setOrder(String orderNumber, String productCode, Integer amount, String customerEmail) {
    global static String getCustomer() {        
        return 'OK';
    }        


}