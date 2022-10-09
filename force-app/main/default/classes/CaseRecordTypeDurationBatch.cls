global class CaseRecordTypeDurationBatch implements Database.Batchable<SObject> {
   
   global Database.QueryLocator start(Database.BatchableContext BC) {
        
            return Database.getQueryLocator([select id from Case]);
           
   }
    
   //the "execute" method is called after the "start" method has been invoked and passed a batch of records
   global void execute(Database.BatchableContext BC, List<SObject> scope) {
      map<Id, List<CaseHistory>> caseHistoryMap = new map<Id, List<CaseHistory>> ();
      map<Id, Decimal> caseDuration = new map<Id, Decimal> ();
      for(CaseHistory caHist : [SELECT CaseId, Oldvalue, case.CreatedDate, newvalue, createddate from CaseHistory where CaseId IN :scope AND Field='RecordType' order by CaseId,createddate ASC]){
          System.debug(caHist);
          List<CaseHistory> casHistList = caseHistoryMap.get(caHist.CaseId);
          if(caseHistoryMap.get(caHist.CaseId) == null){
              casHistList = new List<CaseHistory> ();
          }
          casHistList.add(caHist);
          caseHistoryMap.put(caHist.CaseId, casHistList);
      }
      system.debug('---caseHistoryMap----'+caseHistoryMap);
      List<Case> caseListToUpdate = new List<Case> ();
      for(Id caseId : caseHistoryMap.keyset()){
         // DateTime customerCreatedDate;
          DateTime techRequestCreatedDate ;
          Decimal duration = 0.0; 
          for(CaseHistory casHis : caseHistoryMap.get(caseId )){
         //  DateTime customerCreatedDate = system.now();
            //DateTime techRequestCreatedDate = casHis.case.CreatedDate;
            system.debug('---caseHistory Details----'+casHis);
            system.debug('Case History Created Date:'+casHis.createddate);
              if(casHis.NewValue == 'Tech Request' && casHis.OldValue == 'Customer'){
                  system.debug('Tech request date----:'+casHis.createddate);
                  techRequestCreatedDate =  casHis.createddate ;
                  
              }
              else if(casHis.NewValue == 'Customer' && casHis.OldValue == 'Tech Request'){
                  system.debug('techRequestCreatedDate----:'+techRequestCreatedDate);
                  system.debug('Customer Created Date----:'+casHis.createddate);
                  if(techRequestCreatedDate != null){
                     duration = (casHis.createddate.getTime()-techRequestCreatedDate.getTime())/ (1000*60*60) + duration; 
                  }
                  System.debug('Duration-------->>>'+duration);
             }
          }
         
          caseDuration.put(caseId, duration);
      }
      
      for(Id caId : caseDuration.keyset()){
          Case cas = new Case(id= caId );
          cas.Customer_Support_duration_in_hrs__c = caseDuration.get(caId);
          caseListToUpdate.add(cas);
      }
      system.debug('---caseListToUpdate----'+caseListToUpdate);
      if(caseListToUpdate.size()>0){
          update caseListToUpdate;
      }
   }
   global void finish(Database.BatchableContext info) {
       
       //Attempt to get CaseHistory into test class
  
  

   }

}