global class batchAccountCompanyNormalizeMaint implements Database.Batchable<sObject>{

    public String mode;  
    public String item;  

    global batchAccountCompanyNormalizeMaint (String modeIn, String itemIn){
        
        system.debug('Function: batchAccountCompanyNormalizeMaint ');
        system.debug('mode:' + modeIn);
        system.debug('item:' + item);
        
        this.mode= modeIn;        
        this.item= itemIn;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){  
        
        system.debug('Function: start');
        system.debug('mode:' + mode);
        system.debug('item:' + item);
        
        if(mode == 'all') {
            return Database.getQueryLocator('select Id, Name, RPT_Company__c, Company_Last_Updated__c, Company_Last_Processed__c from Account where Name != null AND Company_Last_Processed__c != null');
        } else {
            return Database.getQueryLocator('select Id, Name, RPT_Company__c, Company_Last_Updated__c, Company_Last_Processed__c from Account where Name != null AND Company_Last_Processed__c != null && id = :item');
        }
    }    
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
        for(Account cont :scope) {
            cont.RPT_Company__c = null;
            cont.Company_Last_Processed__c = null;
            //cont.do_not_fire__c = true;
        }
        update scope;
    }
    
    global void finish(Database.BatchableContext BC){
        
      
    }     

}