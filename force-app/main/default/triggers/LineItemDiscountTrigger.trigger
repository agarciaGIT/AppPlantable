trigger LineItemDiscountTrigger on Line_Item_Discount__c (before insert, before update, before delete, after insert, after update, after delete) {
	
    if(trigger.isBefore) {
        if(trigger.isInsert) {
            LineItemDiscountTriggerHelper.processBeforeInsert(trigger.new);
        }else if(trigger.isUpdate) {
            LineItemDiscountTriggerHelper.processBeforeUpdate(trigger.new, trigger.oldMap);
        }else if(trigger.isDelete) {
            LineItemDiscountTriggerHelper.gatherOppIds(trigger.old);
        }
    }else if(trigger.isAfter) {
        if(trigger.isInsert) {
            LineItemDiscountTriggerHelper.processAfterInsert(trigger.new);
        }else if(trigger.isUpdate) {
            LineItemDiscountTriggerHelper.processAfterUpdate(trigger.new, trigger.oldMap);
        }else if(trigger.isDelete) {
            LineItemDiscountTriggerHelper.recalculateOppAmount();
        }
    }
    
}