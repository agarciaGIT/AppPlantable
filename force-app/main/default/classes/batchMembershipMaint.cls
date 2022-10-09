global class batchMembershipMaint implements Database.Batchable<sObject>{
    
    public Integer year;  
    public String mode;  
    
    global batchMembershipMaint(Integer year, String mode){
        this.year = year;
        this.mode= mode;        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){  
        
         return Database.getQueryLocator('select Id, Name, Year__c, Member_Type_Description__c, Country__c from Reporting_Snapshot_Membership__c where Year__c != null');    
    }    
    
    global void execute(Database.BatchableContext BC, List<Reporting_Snapshot_Membership__c> scope){
          delete scope;
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
    
}