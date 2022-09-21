public with sharing class Plant_Edit_SubscriptionController {
    @AuraEnabled
    public static string getAuthorizationToken(string accountId){
        accountTokenWrapper accountTokenWrapperObj = new accountTokenWrapper(null,false , null);
        try {
            Account accountObj = [SELECT Id,plant_Authentication_Token__c FROM Account WHERE Id =:accountId];
            if(accountObj != null){
                string validToken = plant_AuthorizeController.validate_ByAccessToken(accountObj.plant_Authentication_Token__c);
                if(validToken.contains('Success')){
                    accountTokenWrapperObj = new accountTokenWrapper(accountObj.plant_Authentication_Token__c , true , validToken);
                }
                else{
                    accountTokenWrapperObj = new accountTokenWrapper(accountObj.plant_Authentication_Token__c , false ,validToken);
                }
            }
            return JSON.serialize(accountTokenWrapperObj);

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class accountTokenWrapper{
        string token{get;set;}
        Boolean validToken{get;set;}
        string tokenMesssage{get;set;}

        public accountTokenWrapper(string token , Boolean validToken ,string tokenMesssage){
            this.token = token;
            this.validToken = validToken;
            this.tokenMesssage = tokenMesssage;
        }
    }
}