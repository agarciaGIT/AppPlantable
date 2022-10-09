/*
 * Test calss coverge from class : paymentUtils_Test
*/
trigger paymentTrasanctionEventTrigger on Payment_Transaction__e (after insert) {
    List<ChargentSFA__Transaction__c> transactionsToInsert = new List<ChargentSFA__Transaction__c>();
    for(Payment_Transaction__e evt : trigger.new){
        ChargentSFA__Transaction__c trans = new ChargentSFA__Transaction__c();
        trans.ChargentSFA__Opportunity__c = evt.Opportunity_Id__c;
        trans.ChargentSFA__Amount__c = evt.Amount__c;
        if(evt.Status__c == 'Approved'){
            trans.ChargentSFA__Response_Message__c = 'Approved';
            trans.ChargentSFA__Response_Status__c = 'Approved';
        }
        trans.ChargentSFA__Type__c = 'Charge';
        trans.ChargentSFA__Gateway_Date__c =system.now();
        transactionsToInsert.add(trans);
    }
    
    if(!transactionsToInsert.isEmpty())
        insert transactionsToInsert;
}