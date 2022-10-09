public class smartProsAPI {

    static String PortalKey = '10002';
    static String ProductCode = 'GARP01-V2';
    static String PurchaseType = '1';
    static String TransactionType = 'SmartPros';
    static String CancelReason = 'NotNeeded';
    static String APIURL = 'https://fulfillmentservice.smartpros.com/SmartprosFulfillmentService.svc';
    //static String APIURL = 'http://ec2-54-191-42-178.us-west-2.compute.amazonaws.com/sfdc/smartPros';

    public static API_Transaction__c UpdateUserStart(String contactId, String Company, String FirstName, String LastName, String Email) {

        String params =  EncodingUtil.urlEncode(PortalKey + '|' + Email + '|' + Company + '|' + FirstName + '|' + LastName + '|' + Email,'UTF-8');
        params = params.replaceAll('[+]', '%20');
        String callURL = APIURL + '/UpdateUser/' + params;
        
        API_Transaction__c trans = new API_Transaction__c();
        
        trans.Type__c = TransactionType;
        trans.Contact__c = contactId;        
        trans.Request__c = callURL;
        insert trans;
       
        return trans;
        
    }    
        
    public static API_Transaction__c RecordPurchaseStart(String contactId, String Company, String FirstName, String LastName, String Email, String opportunityId) {

        String params =  EncodingUtil.urlEncode(PortalKey + '|' + Email + '|' + Company + '|' + FirstName + '|' + LastName + '|' + Email + '|' + ProductCode + '~' + PurchaseType + '|' + opportunityId,'UTF-8');
        params = params.replaceAll('[+]', '%20');
        params = params.replaceAll('%7E', '~');
        String callURL = APIURL + '/RecordPurchase/' + params;
        
        API_Transaction__c trans = new API_Transaction__c();
       
        trans.Type__c = TransactionType;
        trans.Opportunity__c = opportunityId;        
        trans.Request__c = callURL;
        insert trans;
        
        return trans;
               
    }
    
    public static API_Transaction__c cancelPurchaseStart(String contactId, String opportunityId) {
        String params =  EncodingUtil.urlEncode(PortalKey + '|' + contactId + '|' + opportunityId + '|' + CancelReason,'UTF-8');
        params.replace('+', '%20');
        String callURL = APIURL + '/CancelPurchase/' + params;        
        system.debug('callURL == '+callURL);

        API_Transaction__c trans = new API_Transaction__c();
        trans.Type__c = TransactionType;
        trans.Opportunity__c = opportunityId;        
        trans.Request__c = callURL;        
        insert trans;
        return trans;
    }

    @future(callout=true)
    public static void SendRequest(String requestURL, String transID) {

        try {
            HttpResponse res;
            if ( !Test.isRunningTest() ) {
                HttpRequest req = new HttpRequest();      
                system.debug('requestURL:' + requestURL);
                req.setEndpoint(requestURL);
                req.setMethod('GET');
                Http h=new Http();
                res = h.send(req);
                system.debug('res == '+res.getBody());
            } else {
                res = new HttpResponse();
                res.setStatusCode(200);
                res.setBody('{"PurchaseCode":null,"ResponseCode":"S200","ResponseMessage":"Updation Successful"}');
            }
            API_Transaction__c trans = [select Response__c from API_Transaction__c where Id = :transID];

            if(res.getStatusCode() == 200) {
                String resp = res.getBody();
                if(resp.length() > 255)
                    trans.Response__c = resp.substring(0,255);
                else trans.Response__c = resp;
                JSONParser parser = JSON.createParser(resp);
                while (parser.nextToken() != null) {
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'ResponseCode')) {
                        parser.nextToken();
                        trans.Response_Code__c = parser.getText();
                    }
                }
            } else {
                trans.Response_Code__c = String.valueOf(res.getStatusCode());
            }           
            update trans;
            
        
        } catch(exception e) {
            API_Transaction__c trans = [select Response__c from API_Transaction__c where Id = :transID];
            String err = e.getMessage();
            if(err.length() > 255)
                trans.Error__c = err.substring(0,255);
            else trans.Error__c = err;
        }
        
    }
   
}