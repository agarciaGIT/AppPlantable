global class batchjobtodeleterecords implements Database.Batchable<sObject>{

String query;
String str = '%@garpautoqaqatesting.com';
//set<id> id = new set<id>{'0034000001aeCB7'};
final List<SObject> records;
Map<Id,Id> mapContactId = new Map<Id,Id>();

global Database.querylocator start(Database.BatchableContext BC){
    
    
    return Database.getQueryLocator('select id,accountId from contact where Email like : str');
}

global void execute(Database.BatchableContext BC, List<contact> scope){

    Set<id> acc = new Set<id>();
    List<contact> lstConts = new List<contact>();
    for(Contact s : scope)
    {
       acc.add(s.accountid);
       lstConts.add(s);
        
    }
    
    List<Opportunity> lstOpptyIds = [select id from opportunity where accountID in: acc];
    List<Account> lstAccIds = [select id from account where id in: acc];
    List<Contract> lstcontractids = [select id from Contract where accountID in: acc];
    List<Exam_Attempt__c> lstExamAtmpts = [select id from Exam_Attempt__c where Candidate_Commitment__c in : lstcontractids];
    delete lstcontractids;
    delete lstOpptyIds;
    delete lstExamAtmpts;
    delete lstAccIds;
    //delete lstConts;

}

global void finish(Database.BatchableContext BC){


}
}