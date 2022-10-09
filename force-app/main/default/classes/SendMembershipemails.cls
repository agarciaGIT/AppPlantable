global class SendMembershipemails implements Database.Batchable<SObject>{
 
   global string memRecordType = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
    
   global Database.QueryLocator start(Database.BatchableContext BC){
    
    Set<integer> days = new Set<integer>{1,10,30};
    Set<String> setStatus = new Set<String>{'Activated','Activated ( Auto-Renew )'};
    Date dtEndDate = system.today(); 
    
     if(!test.isRunningTest())
    return Database.getQueryLocator('select id,Days_remaining__c,Last_Exam_registration_Date__c,AccountId,StartDate,enddate,All_Requirements_Completed__c,Last_Day_Contract_can_be_Active__c,recordTypeId,recordType.Name,Membership_Type__c,ContractTerm,Status,ActivatedDate from Contract where Days_remaining__c  in: days  and ActivatedDate !=null and status in:setStatus');
   else
   return Database.getQueryLocator('select id, Days_remaining__c ,Last_Exam_registration_Date__c,AccountId,Last_Day_Contract_can_be_Active__c,StartDate,enddate,All_Requirements_Completed__c,recordTypeId,recordType.Name,Membership_Type__c,ContractTerm,Status from Contract limit 1');
        
  
  }
    
   global void execute(Database.BatchableContext BC, List<Contract> scope){
    
        List<Contract> lstContract = new List<Contract>();
        Map<Id,Contract> mapContract = new Map<Id,Contract>();
        for(Contract con : scope)
        {
        con.Days_Left__c = con.Days_remaining__c;
         lstContract.add(con);
         mapContract.put(con.Id,con);
        } 
        update mapContract.values();
        }
     
    global void finish(Database.BatchableContext BC){
         }}