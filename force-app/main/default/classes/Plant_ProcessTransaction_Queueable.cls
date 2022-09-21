/*
* @ desc        :	Class to execute chargent API for ProcessTransaction
* @ test        : 
* @ trigger     :   Plant_Site_ReqBody_Trigger	
* @ Created By  :   Bhagwan S
* */

public with sharing class Plant_ProcessTransaction_Queueable implements Queueable, Database.AllowsCallouts{
    public String siteReqId;
    
    //Default Constructor
    public Plant_ProcessTransaction_Queueable(String Id) {
        this.siteReqId=Id;
        System.debug('@@@@ ID   '+Id);
        
    }
    
    // Execute Method
    
    public void execute(QueueableContext context) {
        try{
            // Call Apex method to Authorize transaction
            System.debug('@@@@ ID   '+siteReqId);
            Plant_ProcessTransaction_Queueable.call(siteReqId);
            System.debug('@@@@ ID   '+siteReqId);
        }Catch(Exception e){
            System.debug('@@@ Exception Occured at line : '+e.getLineNumber()+' with Message : '+e.getMessage()+' get Cause '+e.getCause());
        }        
    }
    
    @future (callout=true)
    public static void call(String siteId){
        System.debug('@@@@ future method ID   '+siteId);
        system.debug('@@@@@ System user  '+userinfo.getProfileId());
        Plant_Site_ReqBody__c SiteRequestBody=[SELECT id, Plant_Request_Body__c, endpoint__c, Plant_Done__c, Plant_Response__c, Plant_Status__c FROM Plant_Site_ReqBody__c WHERE id =:siteId AND Plant_Done__c=False Limit 1];
        Plant_Site_ReqBody__c tempRecd = new Plant_Site_ReqBody__c();
            tempRecd.Id = SiteRequestBody.Id;
            Plant_Utility.responseWrapper response = new Plant_Utility.responseWrapper();
            
            if(SiteRequestBody.endpoint__c=='ProcessTransaction'){
                Plant_Orders_BC.TransactionReqWrap reqWrap = new Plant_Orders_BC.TransactionReqWrap().parse(SiteRequestBody.Plant_Request_Body__c);
                response= new Plant_Orders_BC().authorizeChargent_Method2(reqWrap);
            }
            if(SiteRequestBody.endpoint__c=='ProcessPayment'){
                Plant_Orders_BC.processPayment_Wrap reqWrap = new Plant_Orders_BC.processPayment_Wrap().parse(SiteRequestBody.Plant_Request_Body__c);
                response= new Plant_Orders_BC().authorizeChargent_Method3(reqWrap);
            }
            
            System.debug('@@@@@ Responce   '+response);
            System.debug(' @@@@ Responce status Code '+response.statusCode+' @@@ Responce status '+response.status);
            if(response.statusCode!='200'){
                tempRecd.Plant_Status__c ='Error';
            }
            else
                tempRecd.Plant_Status__c ='Success';
            
            tempRecd.Plant_Response__c = JSON.serialize(response);
            tempRecd.Plant_Done__c = True;
            
            // update response back to record
            System.debug('@@@@ Before Update');
            Update tempRecd;
        	System.debug('@@@@ after Update');
    }
}