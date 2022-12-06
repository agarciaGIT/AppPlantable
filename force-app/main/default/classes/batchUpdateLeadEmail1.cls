global class batchUpdateLeadEmail1 implements Database.Batchable<SObject>
{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select Id,Email from lead where Email != null');
     }
    
    
    global void execute(Database.BatchableContext BC, List<lead> scope){
       
        for(lead ct : scope)
        {
            ct.Email = '';
            
        }
        
       if(!scope.isEmpty())
            update scope;
       
            
    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}