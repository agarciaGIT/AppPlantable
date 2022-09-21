trigger TeckstCaseClosed on Case (after update, after delete) {
    /*
  if (Trigger.isUpdate) {
    for (Case cse : Trigger.new) {
      if (cse.Is_Teckst_Case__c && Trigger.oldMap.get(cse.Id).Status != cse.Status) {
        TeckstController.defensiveChangeCaseStatus(String.valueOf(cse.Id), cse.Status);
      }
    }
  } else if (Trigger.isDelete) {
    for (Case cse : Trigger.old) {
      if (cse.Is_Teckst_Case__c) {
        TeckstController.defensiveChangeCaseStatus(String.valueOf(cse.Id), 'Closed');
      }
    }
  }
*/
}