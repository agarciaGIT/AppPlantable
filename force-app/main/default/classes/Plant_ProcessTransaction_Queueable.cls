/*
* @ desc        :	Class to execute chargent API for ProcessTransaction
* @ test        : 
* @ trigger     :   Plant_Site_ReqBody_Trigger	
* @ Created By  :   Bhagwan S
* */

public with sharing class Plant_ProcessTransaction_Queueable implements Queueable, Database.AllowsCallouts{
public String jsonWrap;
public String subscriptionId;
//Default Constructor
public Plant_ProcessTransaction_Queueable(String jsonWrap, String subscriptionId) {
    this.jsonWrap=jsonWrap;
    this.subscriptionId = subscriptionId;
    System.debug('@@@@ ID   '+jsonWrap);
    
}

// Execute Method

public void execute(QueueableContext context) {
    try{
        // Call Apex method to Authorize transaction
       
        Plant_Utility.responseWrapper response = new Plant_Utility.responseWrapper();
        Plant_Orders_BC.TransactionReqWrap reqWrap = new Plant_Orders_BC.TransactionReqWrap();
        if(!String.isBlank(jsonWrap)){
            ChargentOrders.TChargentOperations.TChargentResult auth_result = ChargentOrders.TChargentOperations.AuthorizeOrder_ClickJSON(jsonWrap);
            if(auth_result.responseData!=null){
                // SUCCESSFULL CALLOUT
                Map<String,Object> responseDta = (Map<String,Object>)JSON.deserializeUntyped(auth_result.responseData);
                System.debug('#### key set==> '+responseDta.keySet());
                // complete transaction
                if(auth_result.Status=='OK' && auth_result.TransactID!=null && String.valueOf(responseDta.get('responseCode'))=='200' && String.valueOf(responseDta.get('isApproved'))=='true'){
                    System.debug('###### Transaction authorization OK');
                }
                else {
                    System.debug('###### unsuccessfull');
                    Plant_Subscription__c subscripton = new Plant_Subscription__c();
                    subscripton.id=subscriptionId;
                    subscripton.Plant_New_Chargent_Order_Id__c = null;
                    update subscripton;
                }
            }
        }

        
    }Catch(Exception e){
        System.debug('@@@ Exception Occured at line : '+e.getLineNumber()+' with Message : '+e.getMessage()+' get Cause '+e.getCause());
    }        
}

// @future (callout=true)
// public static void call(String jsonWrap){
//     System.debug('@@@@ future method ID   '+jsonWrap);
//     system.debug('@@@@@ System user  '+userinfo.getProfileId());
//     Plant_Utility.responseWrapper response = new Plant_Utility.responseWrapper();
//     Plant_Orders_BC.TransactionReqWrap reqWrap = new Plant_Orders_BC.TransactionReqWrap();
//         if(!String.isBlank(jsonWrap)){
//             reqWrap = new Plant_Orders_BC.TransactionReqWrap().parse(jsonWrap);
//             response= new Plant_Orders_BC().authorizeChargent_Method2(reqWrap);
//         }
        
//         System.debug('@@@@@ Responce   '+response);
//         System.debug(' @@@@ Responce status Code '+response.statusCode+' @@@ Responce status '+response.status);
//         if(response.statusCode!='200'){
//             System.debug('@@@@ Responce Successsfull '+response);
//         }
//         else
//             System.debug('@@@@ Responce error '+response);
        
        
// }
}