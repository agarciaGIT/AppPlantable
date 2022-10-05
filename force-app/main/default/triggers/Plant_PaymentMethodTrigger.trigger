trigger Plant_PaymentMethodTrigger on Plant_Payment_Method__c (before insert, before update) {
/*    List<Plant_Payment_Method__c> lstPayMethods = new List<Plant_Payment_Method__c>();
    for(Plant_Payment_Method__c pm : Trigger.new){
        if(pm.Plant_Save_Payment_Method__c == True && pm.Plant_Account__c != NULL) {
            lstPayMethods.add(pm);
        }
    }
    System.debug('lstPayMethods:' + lstPayMethods);
    Plant_Orders_BC_Helper.paymentMethodTriggerHandler(lstPayMethods);
*/
}