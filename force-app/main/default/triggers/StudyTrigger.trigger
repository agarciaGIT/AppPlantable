trigger StudyTrigger on Study__c (before insert, before update, after insert, after update) {

    if(StudyTriggerHelper.firstExecution){
        if(Trigger.isBefore){
            if(Trigger.isInsert){

            }else if(Trigger.isUpdate){

            }
        }else if(Trigger.isAfter){
            StudyTriggerHelper.firstExecution = false;
            if(Trigger.isInsert){
                StudyTriggerHelper.onAfterInsert(Trigger.newMap, Trigger.oldMap);
            }else if(Trigger.isUpdate){
                StudyTriggerHelper.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
            }
        }
    }

}