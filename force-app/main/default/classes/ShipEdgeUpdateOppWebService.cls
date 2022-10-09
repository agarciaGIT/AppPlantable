@RestResource(urlMapping='/ShipEdge')
global without sharing class ShipEdgeUpdateOppWebService {
    
    @HttpPost
    global static void doPatch() {
        List<Integration_Log__c> logList = new List<Integration_Log__c>();
        String returnValue = 'Success';
        RestRequest request = RestContext.request;
        RestResponse res = RestContext.response;
        
        String jsonBody = '';
        if(!Test.isRunningTest() && request != null && request.requestBody != null){ jsonBody = request.requestBody.toString(); }
        else{
            if(Test.isRunningTest()){
                jsonBody = webHookRequestWrapper.testParse();
            }
        }
        
        try{
            webHookRequestWrapper reqWrapper = webHookRequestWrapper.parse(jsonBody);
            system.debug('reqWrapper::>>   '+reqWrapper);
            if(reqWrapper != null && reqWrapper.order != null && reqWrapper.order.Id != null){
                system.debug('reqWrapper  id::>>   '+reqWrapper.order.id);
                List<Opportunity> oppList = new List<Opportunity>();
                List<Opportunity> oppToUpdate = new List<Opportunity>();
                oppList = [SELECT Id,Ship_Edge_Order_Id__c,Tracking_Number__c FROM Opportunity WHERE Ship_Edge_Order_Id__c =: reqWrapper.order.Id];
                for(Opportunity opp : oppList){
                    opp.Tracking_Number__c = reqWrapper.order.tracking_number; oppToUpdate.add(opp);
                    opp.Ups_Stage__c = 'Completed';
                    logList.add(ShipEdgeAPIClass.createLogRecord(opp.Id,jsonBody,returnValue,returnValue,'ShipEdgeUpdateOppWebService'));
                }
                
                update oppToUpdate;
            }
            res.responseBody = Blob.valueOf('Success'); 
            res.statusCode = 200; 
        }catch(Exception ex){ 
            res.responseBody = Blob.valueOf('Error'); 
            res.statusCode = 500;
        }
        
        if(logList.size() > 0){
            insert logList;
        }
    }
}