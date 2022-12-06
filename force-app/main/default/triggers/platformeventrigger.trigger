trigger platformeventrigger on AGTEST__e (after insert) {
    
    System.debug('platformeventrigger!');
    
    for(AGTEST__e evt : trigger.new){
    
        eComm_Transaction__c trans = new eComm_Transaction__c();
        trans.Response_Status__c = 'platformeventrigger ';
        insert trans;
        
    }
}