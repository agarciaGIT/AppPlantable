global class batchUpdateLeadEmail implements Database.Batchable<SObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id, Email from lead');
     }
    
    
    global void execute(Database.BatchableContext BC, List<lead> scope){
       
        for(lead objOpp : scope)
        {
            objOpp.Email = '';
           
            
        }
       
      
        update scope;
            
    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}