global class batchUpdateWorkSchoolStatus implements Database.Batchable<sObject>,Database.StateFul{
    
    public String mode; 
    
    global batchUpdateWorkSchoolStatus (String mode){
        this.mode = mode;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){  
        String mem = '01240000000UdO3';
        if(mode != null) {
            return Database.getQueryLocator('SELECT Id, Name, Currently_in_School_Status__c, Currently_Working_Status__c, Currently_in_School__c, Currently_Working__c from Contact where RecordTypeID = :mem and Id=:mode');
        } else {
        	return Database.getQueryLocator('SELECT Id, Name, Currently_in_School_Status__c, Currently_Working_Status__c, Currently_in_School__c, Currently_Working__c from Contact where RecordTypeID = :mem');    
        }
        
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> scope){

        system.Debug('Scope:' + scope.size());
        List<Contact> updateCont = new List<Contact>();
        for(Contact cont :scope) {
            Boolean updated = false;
            if(cont.Currently_Working__c == true) {
                cont.Currently_Working_Status__c = 'Working';
                updated=true;
            }
            if(cont.Currently_in_School__c == true) {
                cont.Currently_in_School_Status__c = 'In School';
                updated=true;
            }
            if(updated == true)
                updateCont.add(cont);
        }
        update updateCont;
        
   }
    
    
    global void finish(Database.BatchableContext BC){
        
    }
}