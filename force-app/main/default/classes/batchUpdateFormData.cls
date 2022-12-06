global class batchUpdateFormData implements Database.Batchable<SObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id, Email__c from Form_Data__c');
     }
    
    
    global void execute(Database.BatchableContext BC, List<Form_Data__c> scope){
       
        for(Form_Data__c objOpp : scope)
        {
            objOpp.Email__c = '';
           
            
        }
       
      
        update scope;
            
    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}