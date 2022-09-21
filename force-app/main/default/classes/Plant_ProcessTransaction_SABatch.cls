/*
* @ d e s c:	Batch to execute chargent API for ProcessTransaction
* @ t e s t: 	
* @ C r e a t e d  B y: Bhagwan S
* */
public class Plant_ProcessTransaction_SABatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    // @ Start method
    public static Database.QueryLocator start(Database.BatchableContext BC){
        //ChargentOrders.TChargentOperations.TChargentResult auth_result = ChargentOrders.TChargentOperations.AuthorizeOrder_ClickJSON(charg_jsonBody);
        return Database.getQueryLocator([SELECT id, Plant_Request_Body__c, endpoint__c, Plant_Done__c, Plant_Response__c, Plant_Status__c FROM Plant_Site_ReqBody__c WHERE Plant_Done__c=False]);
    }
    
    // @ Execute Method
    public static void execute(Database.BatchableContext BC, List<Plant_Site_ReqBody__c> scope){
        try{
        // Call Apex method to Authorize transaction
        Plant_Site_ReqBody__c tempRecd = new Plant_Site_ReqBody__c();
        tempRecd.Id = scope[0].Id;
        Plant_Utility.responseWrapper response = new Plant_Utility.responseWrapper();
        
        if(scope[0].endpoint__c=='ProcessTransaction'){
            Plant_Orders_BC.TransactionReqWrap reqWrap = new Plant_Orders_BC.TransactionReqWrap().parse(scope[0].Plant_Request_Body__c);
        	response= new Plant_Orders_BC().authorizeChargent_Method2(reqWrap);
        }
        if(scope[0].endpoint__c=='ProcessPayment'){
            Plant_Orders_BC.processPayment_Wrap reqWrap = new Plant_Orders_BC.processPayment_Wrap().parse(scope[0].Plant_Request_Body__c);
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
        Update tempRecd;
        }Catch(Exception e){
            System.debug('@@@ Exception Occured at line : '+e.getLineNumber()+' with Message : '+e.getMessage());
        }
    }
    
    // @ Finish Method
    public static void finish(Database.BatchableContext BC){
        System.debug('@@@@@ FINISH METHOD @@@@@');
    }
}