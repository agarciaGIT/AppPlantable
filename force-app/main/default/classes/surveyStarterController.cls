public without sharing class surveyStarterController {
    
    @auraEnabled public Health_Survey__c  healthSurveyItem {get;set;}
    @auraEnabled public Account contactItem {get;set;}
    
	@AuraEnabled
    public static surveyStarterController initClass(String inputId){
        surveyStarterController obj = new surveyStarterController();
        obj.healthSurveyItem = new Health_Survey__c();

        List<Account> lstAcct = [select id, name  from Account where Id = :inputId];
        if(lstAcct != NULL && lstAcct.size() > 0) {
            obj.contactItem = lstAcct[0];
        }
        
        return obj;
    }
    
    @auraEnabled
    public static contact getcontact(String inputId){
        
        contact c =[select id, name from contact where Id = :inputId];
        return c;
    }
    
    @auraEnabled
    public static Health_Survey__c setSurvey(String  strObjClassController, String inputId){

        system.debug('strObjClassController:' + strObjClassController);
        system.debug('inputId:' + inputId);
                
        Health_Survey__c hs = new Health_Survey__c ();
        if(strObjClassController != NULL && inputId != NULL) {
            
			surveyStarterController objClassController = (surveyStarterController)JSON.deserialize(strObjClassController, surveyStarterController.class);
            //contact c =[select id, name, AccountId from contact where Id = :inputId];
            
            objClassController.healthSurveyItem.Account__c = inputId;            
            insert objClassController.healthSurveyItem;            
        }
        
        return hs;
    }
    
}