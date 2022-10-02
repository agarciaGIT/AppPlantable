/******************************************************************************************************************************************
 * DESCRIPTION  :   after insert/update trigger. automate shipment record automations and subscripiton record update on transaction completed
 * HELPER CLASS :   Plant_TransactionTiggerHelper
 * TEST CLASS   :	Plant_TransactionTigger_Test
 * 
 * CREATED BY   :   HIC Dev(25 May)
 ******************************************************************************************************************************************/

trigger Plant_TransactionTigger on ChargentOrders__Transaction__c (after insert, after update) { 
    // active - unactive trigger
    if(!Test.isRunningTest() && !plantable_TriggersSwitch__c.getValues('plantableHIC_Switches').pauseChargentTransaction_Trigger__c){
        System.debug('@@## TRANSACTION TRIGGER START');
        if(Trigger.isAfter){
            Map<String,String> cOrder_Vs_transactionId_Map = new Map<String,String>();
           
                for(String trans : Trigger.newMap.KeySet()){
                    if(Trigger.isInsert ){
                        if(Trigger.newMap.get(trans).ChargentOrders__Type__c=='Charge' && Trigger.newMap.get(trans).ChargentOrders__Response_Status__c=='Approved' && Trigger.newMap.get(trans).ChargentOrders__Response__c=='OK' && Trigger.newMap.get(trans).ChargentOrders__Amount__c== Trigger.newMap.get(trans).Plant_ChargentOrders_ChargeAmount__c){
                            cOrder_Vs_transactionId_Map.put(Trigger.newMap.get(trans).ChargentOrders__Order__c,trans);
                        }
                        else{
                            System.debug('Transaction not completed on insert => '+trans);
                        }
                    }
                    else if(Trigger.isUpdate ){
                        if((Trigger.newMap.get(trans).ChargentOrders__Type__c!=Trigger.oldMap.get(trans).ChargentOrders__Type__c && Trigger.newMap.get(trans).ChargentOrders__Type__c=='Charge') || (Trigger.newMap.get(trans).ChargentOrders__Response_Status__c!=Trigger.oldMap.get(trans).ChargentOrders__Response_Status__c && Trigger.newMap.get(trans).ChargentOrders__Response_Status__c=='Approved') && Trigger.newMap.get(trans).ChargentOrders__Response__c=='OK' && Trigger.newMap.get(trans).ChargentOrders__Amount__c==Trigger.newMap.get(trans).Plant_ChargentOrders_ChargeAmount__c){
                            cOrder_Vs_transactionId_Map.put(Trigger.newMap.get(trans).ChargentOrders__Order__c,trans);
                        }
                        else{
                            System.debug('Transaction not completed on update => '+trans);
                        }
                    }

                }

                // call helper class
                if(!cOrder_Vs_transactionId_Map.isEmpty()){
                    System.debug('###@@ helper class calling : '+cOrder_Vs_transactionId_Map);
                    Plant_TransactionTiggerHelper.processSubscription(cOrder_Vs_transactionId_Map);
                }
                else {
                    System.debug('###@@ no record to update ');
                }
                
        }
    }
}