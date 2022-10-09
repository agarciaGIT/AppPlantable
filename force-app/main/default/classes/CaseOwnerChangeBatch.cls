global class CaseOwnerChangeBatch implements Database.Batchable<SObject> {
   
   global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([select id,owner_check__c  from case where status='closed'and recordtypeid='012400000005iFW'  and owner_check__c =false]);
   }
    
   //the "execute" method is called after the "start" method has been invoked and passed a batch of records
   global void execute(Database.BatchableContext BC, List<SObject> scope) {
      map<Id, CaseHistory> caseHistoryMap = new map<Id, CaseHistory> ();
      for(CaseHistory caHist : [SELECT CaseId, newvalue, createddate from CaseHistory where CaseId IN :scope AND Field='Owner' order by createddate DESC]){
          if(caseHistoryMap.get(caHist.CaseId) == null){
              caseHistoryMap.put(caHist.CaseId, caHist);
          }
      }
            

      List<Case> caseListToUpdate = new List<Case> ();
      system.debug('---caseHistoryMap----'+caseHistoryMap);
      for(CaseHistory casHis : caseHistoryMap.values()){
          Case cas = new Case(id= casHis.caseId);
          cas.owner_check__c = true;
          cas.Last_Owner_changed__c = casHis.createddate ;
         // cas.Last_Owner__c = String.valueOf(casHis.NewValue);
          caseListToUpdate.add(cas);
      }
      system.debug('---caseListToUpdate----'+caseListToUpdate);
      if(caseListToUpdate.size()>0){
          update caseListToUpdate;
      }
   }
   global void finish(Database.BatchableContext info) {
  
   }

}