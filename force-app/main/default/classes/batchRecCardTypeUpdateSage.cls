global class batchRecCardTypeUpdateSage implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([Select Id,ChargentSFA__Card_Type__c,Payment_Method__c,ChargentSFA__Payment_Status__c,Cloned_From__c
                                         from Opportunity 
                                         where ChargentSFA__Payment_Status__c = 'Recurring' and ChargentSFA__Card_Type__c = null 
                                         and Cloned_From__c != null and ChargentSFA__Payment_Method__c = 'Credit Card' and StageName = 'Closed' and Amount > 0]); 
    }
    
    global void execute(Database.BatchableContext bc, List<Opportunity> scope){
        Set<Id> oppIds = new Set<Id>();
        List<Opportunity> oppListToUpdate = new List<Opportunity>();
        for(Opportunity opp : scope){
            string oppId = opp.Cloned_From__c;
            string cardType;
            integer i = 0;
            do{
                string response;
                response = getCardType(oppId);
                if(String.isNotBlank(response) && response.startsWithIgnoreCase('006')){
                    oppId = response;
                }else if(String.isNotBlank(response) && !response.startsWithIgnoreCase('006')){
                    cardType = response;
                }else if(String.isBlank(response)){
                    cardtype = '';
                    oppId = '';
                }
                i++;
            }while(i < 7 && !String.isNotBlank(cardType) && String.isNotBlank(oppId));
            
            if(String.isNotBlank(cardType)){
                opp.ChargentSFA__Card_Type__c = cardtype;
                opp.Recurring_Card_Type_Batch__c = true;
                oppListToUpdate.add(opp);
            }
        }
        
        if(! oppListToUpdate.isEmpty()){
            update oppListToUpdate;
        }
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
    
    public string getCardType(string OppId){
        string response;
        Opportunity opp = [Select Id,ChargentSFA__Card_Type__c,Cloned_From__c from Opportunity where Id =: oppId];
        if(opp != null){
            if(opp.ChargentSFA__Card_Type__c != null){
                if(opp.ChargentSFA__Card_Type__c == 'American Express'){
                    response = 'AMEX';
                }else if(opp.ChargentSFA__Card_Type__c == 'null'){
                    response = '';
                }else{
                    response = opp.ChargentSFA__Card_Type__c;
                }
                response = opp.ChargentSFA__Card_Type__c;
            }else if(opp.Cloned_From__c != null){
                response = opp.Cloned_From__c;
            }else{
                response = '';
            }
        }else{
            response = '';
        }
        
        return response;
    }
}