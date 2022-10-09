trigger formDataTrigger on form_data__c (before insert,before update,after insert,after update) { 
    
    if(Trigger.isbefore && (Trigger.isinsert || Trigger.isUpdate)){
        if(Trigger.isinsert){
          formDataTriggerHelper.beforeinsertUpdate(trigger.new);
        }
        if(Trigger.isUpdate){
          formDataTriggerHelper.beforeinsertUpdate(trigger.new);
        }
    } 
    
    if(Trigger.isAfter && (Trigger.isinsert || Trigger.isUpdate)){ 
        formDataTriggerHelper.afterinsertupdate(trigger.new);
    }      
}