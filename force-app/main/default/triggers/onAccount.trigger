trigger onAccount on Account (before update) {

    for(Integer i=0; i<trigger.new.size(); i++) {
        Account obj = trigger.new[i];
        Account objOld = trigger.old[i];            
        system.debug('Automated_Update: ' + objOld.Automated_Update__c + ':' + obj.Automated_Update__c);
    
        obj.Dietary_Restrictions_Text__c = obj.Dietary_Exceptions__c;
        if(obj.Sync_Shopify__c == True) {
            List<Contact> contacts = [select Id, Name, FirstName, LastName from Contact where AccountId = :obj.id];
            if(contacts != null && contacts.size() > 0) {
               String jsonCont = JSON.serialize(contacts[0]);        
               String jsonAcct = JSON.serialize(obj);
               shopifyClass.setCustomerFuture(jsonAcct,jsonCont);
            }
        }
        obj.Sync_Shopify__c = False;
    }    
}