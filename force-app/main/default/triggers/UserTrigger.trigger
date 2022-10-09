/* Trigger on Salesforce User Object
 * 01/03/2019 Xiang - Created for [US-16772]
 */
trigger UserTrigger on User (before update, after update) {
    
    // Prevent Community Users change locale settings
    if(trigger.isUpdate) {
        if(trigger.isBefore) {
            UserTriggerHelper.checkUserLocaleChange(trigger.new, trigger.oldMap);
        }
        if(trigger.isAfter){
            UserTriggerHelper.updateUserEmail(trigger.newMap, trigger.oldMap);
        }
    }
    

    
}