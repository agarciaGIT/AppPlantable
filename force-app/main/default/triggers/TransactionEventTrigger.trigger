trigger TransactionEventTrigger on Transaction_Event__e (after insert) {
    List<eComm_Transaction__c> aeList = new List<eComm_Transaction__c>();
    for(Transaction_Event__e e : Trigger.new){
        
        System.debug('!TransactionEventTrigger:' + e.Chargent_Token__c);
        
        eComm_Transaction__c ae = new eComm_Transaction__c(Amount__c=e.Amount__c,
                                                           Authorization__c=e.Authorization__c,
                                                           Card_Last_4__c=e.Card_Last_4__c,
                                                           Chargent_Token__c=e.Chargent_Token__c,
                                                           Gateway_Date__c=e.Gateway_Date__c,
                                                           Gateway_ID__c=e.Gateway_ID__c,
                                                           Gateway_Response__c=e.Gateway_Response__c,
                                                           Opportunity_ID__c=e.Opportunity_ID__c,
                                                           Response_Status__c=e.Response_Status__c);
        
        System.debug('TransactionEventTrigger ae:' + ae);
        aeList.add(ae);
    }
    insert aeList;
}