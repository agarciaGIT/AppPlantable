trigger StudyAccountTrigger on Study_Account__c (before insert, before update, after insert, after update) {

    if(StudyAccountTriggerHelper.firstExecution){
        if(Trigger.isBefore){
            if(Trigger.isInsert){

            }else if(Trigger.isUpdate){

            }
        }else if(Trigger.isAfter){
            StudyAccountTriggerHelper.firstExecution = false;
            if(Trigger.isInsert){
                StudyAccountTriggerHelper.onAfterInsert(Trigger.newMap, Trigger.oldMap);
            }else if(Trigger.isUpdate){
                StudyAccountTriggerHelper.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
            }
        }
    }
    
}