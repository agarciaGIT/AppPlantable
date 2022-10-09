global class ErpPart1LateDeferal implements Database.Batchable<sObject>,Database.StateFul{
    
   global Database.QueryLocator start(Database.BatchableContext BC){
      
     //run this batch for only one record at once.

               
         String oppstatus = 'closed';
         Set<String> strSection = new Set<String>{'ERP Exam Part I'};
         Set<String> id =new Set<String>{'a1a1W000008ijQ5'};
          string StrDefered ='pending';  
         string strQuery = 'select id,Section__c, Exam_Site__r.Exam__r.Exam_Group__c,Exam_Site__r.Exam__r.exam__C, Exam_Site__r.Exam_Site_Code_idetifier__c,Exam_Site__r.exam_date__C,Candidate_Commitment__r.AccountId,Opportunity__c,Deferral_Status__c,Candidate_Commitment__c,Member__c,Candidate_Requirement__c,Exam_Site__c,Defered__c from Exam_Attempt__c where   Opportunity_StageName__c =:oppstatus and cancelled__c !=true and Section__c in: strSection and Exam_Date__c = 2020-10-24  and Covid_Late_Deferral__c =true and Defered__c !=:StrDefered';
         
         if(test.isRunningTest()){
       strQuery = 'select id,Section__c, Exam_Site__r.Exam__r.Exam_Group__c,Exam_Site__r.Exam__r.exam__C, Exam_Site__r.Exam_Site_Code_idetifier__c,Exam_Site__r.exam_date__C,Candidate_Commitment__r.AccountId,Opportunity__c,Deferral_Status__c,Candidate_Commitment__c,Member__c,Candidate_Requirement__c,Exam_Site__c,Defered__c  from Exam_Attempt__c where  Opportunity_StageName__c =:oppstatus and cancelled__c !=true and Section__c in: strSection';         
       }
         return Database.getQueryLocator(strQuery); 
   
   }

   global void execute(Database.BatchableContext BC, List<Exam_Attempt__c> scope){
        string examName = 'Free Exam Deferral';
         Registration.wrapperCreateOrder wco = new Registration.wrapperCreateOrder();
        Set<Id> Conids = new Set<Id>();

        for(Exam_Attempt__c obj : scope)  
        {
            
           Conids.add(obj.Member__c);  
            wco = portalClass.createOppRecord(obj,examName,'ENC','4020',false);
        }

      ChargentSFA__Transaction__c trans = new ChargentSFA__Transaction__c();
                trans.ChargentSFA__Opportunity__c = wco.opportunityId;
                trans.ChargentSFA__Amount__c = 0.00;
                trans.ChargentSFA__Response_Message__c = 'Approved';
                trans.ChargentSFA__Response_Status__c = 'Approved';
                trans.ChargentSFA__Type__c = 'Charge';
               
                trans.ChargentSFA__Gateway_Date__c =system.now();
              
                 insert trans;
      
        }
    
  global void finish(Database.BatchableContext BC){
   
   }
}