/*  Apex Trigger for Event_Session_Registration__c
 *  01/11/2019 Xiang - Created per [US-17044] for EventMobi Integration
 */
trigger EventSessionRegistrationTrigger on Event_Session_Registration__c (after insert, before delete, after delete) {
    
    if(trigger.isBefore) {
        if(trigger.isDelete) {
            EventSessionRegistrationTriggerHelper.setDeletedRecordValues(trigger.oldMap);
        }
    }else if(trigger.isAfter) {
        if(trigger.isInsert) {
            EventSessionRegistrationTriggerHelper.sendAddReqToEventMobi(trigger.newMap);
        }else if(trigger.isDelete) {
            EventSessionRegistrationTriggerHelper.sendDeleteReqToEventMobi();
        }
    }
    
}