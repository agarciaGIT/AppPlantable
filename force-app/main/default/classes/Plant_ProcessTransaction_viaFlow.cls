/******************************************************************************************************************************************
* DESCRIPTION  :   called by a Flow to hit Chargent
* Flow Name   :     Plant Hit Chargent By Flow
* 
* CREATED BY   :   HIC Dev(30 August 2022)
******************************************************************************************************************************************/
public without sharing class Plant_ProcessTransaction_viaFlow {
    
    // @Desc: Default Constructor
    public Plant_ProcessTransaction_viaFlow() {

    }

    //@Desc: Calling from Flow to chargent
    // @InvocableMethod(callout=true label='Hit Chargent' description='To hit Chargent By Flow')
    @InvocableMethod(label='Hit Chargent' description='To hit Chargent By Flow')
    public static void hitChargent(List<String> SiteId){
        System.debug('@@@ Site Id in Invocable Method   :   '+SiteId);
        Plant_ProcessTransaction_viaFlow.hitChargentFuture(SiteId[0]);
       
    }
    
    // @Desc // Making callout in Future Method
    @future(callout=true)
    public static void hitChargentFuture(String SiteId){
        try{
            System.debug('@@@ Form Flow Method User Profile   :   '+userinfo.getProfileId());
            System.debug('@@@ Site Id in Future Method   :   '+SiteId);
            List<Plant_Site_ReqBody__c> scope=[SELECT id, Plant_Request_Body__c, endpoint__c, Plant_Done__c, Plant_Response__c, Plant_Status__c FROM Plant_Site_ReqBody__c WHERE id=:SiteId AND Plant_Done__c=False Limit 1]; 
            System.debug('@@@ Form Flow getting Values of the Current list  :   '+scope);
            System.debug('@@@ Form Flow getting id of the Current list  :   '+scope[0].id);
            
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
            
            tempRecd.Plant_Responces__c = JSON.serialize(response);
            tempRecd.Plant_Done__c = True;
            
            // update response back to record
            Update tempRecd;
            }Catch(Exception e){
                System.debug('@@@ Exception Occured at line : '+e.getLineNumber()+' with Message : '+e.getMessage());
            }
    }
}