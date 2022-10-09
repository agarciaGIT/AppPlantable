global class batchUpdateEmail implements Database.Batchable<sObject>,Database.StateFul{
   //member email for all the programs should be updates
   global string icbrrRecordType = RecordTypeHelper.GetRecordTypeId('Contract','ICBRR Program');
    global string frmRecordType = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program');
    global string fbrRecordType = RecordTypeHelper.GetRecordTypeId('Contract','FBR Program');
    global string erpRecordType = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program'); 
        Set<String> recordtype = new Set<String>{'icbrrRecordType','frmRecordType','fbrRecordType','erpRecordType'};

   global Database.QueryLocator start(Database.BatchableContext BC){  
        String conId = '00329000003k2Wk';
        String fieldType = 'Email';
        date dtToday = System.today();
        if(!test.isRunningTest())
       return Database.getQueryLocator('Select id,field,ContactId,Contact.AccountID,Contact.email from contactHistory where  Field =: fieldType and CreatedDate= TODAY');
       else
        return Database.getQueryLocator('Select id,field,ContactId,Contact.AccountID,Contact.email from contactHistory where  Field =: fieldType');
   }

   global void execute(Database.BatchableContext BC, List<contactHistory> scope){
        Set<Id> setAccts = new Set<Id>();
         Map<Id,String> mapcontactEmail = new Map<Id,String>();
        Map<Id,String> mapAccountEmail = new Map<Id,String>();
        Set<Id> setContacts = new Set<Id>();
        for(contactHistory obj : scope)
        {
            setAccts.add(obj.Contact.accountId);
            mapAccountEmail.put(obj.Contact.AccountID,obj.Contact.email);
            mapcontactEmail.put(obj.Contactid,obj.Contact.email);
            setContacts.add(obj.ContactId);
        }
        
        Map<Id,String> mapOppEmail = new Map<Id,String>();
        Set<ID> setIds = new set<ID>();
        Set<ID> setco = new set<ID>();
        
        for(Opportunity o : [select id,accountId from opportunity where accountId in: mapAccountEmail.keySet()])
        {
            setIDs.add(o.Id);
            mapOppEmail.put(o.Id,mapAccountEmail.get(o.AccountId));
        }
        List<Contract> lstContracts = new List<Contract>();
        for(Contract ct : [select id,Member_Email__c,accountId from Contract where accountId in : mapAccountEmail.keySet()])
        {
            ct.Member_Email__c = mapAccountEmail.get(ct.accountId);
            lstContracts.add(ct);
            setco.add(ct.id);
        }
        
         
        
        
        List<Candidate_Requirement__c> lstPrs = new List<Candidate_Requirement__c>();
        for(Candidate_Requirement__c ct : [select id,Candidate_Email__c ,Candidate_Commitment__c,Candidate_Commitment__r.Opportunity__c,Candidate_Commitment__r.accountId from Candidate_Requirement__c where Candidate_Commitment__c in:setco])
        {
            String email = mapAccountEmail.get(ct.Candidate_Commitment__r.accountId);
            ct.Candidate_Email__c  = email;
            ct.Email_GARP_Member__c = email;
            lstPrs.add(ct);
        }
        
        if(!lstPrs.isEmpty())
            update lstPrs;
            
        if(!lstContracts.isEmpty())
            update lstContracts;
            
        
        
    }
    
   
   global void finish(Database.BatchableContext BC){
   
   }
}