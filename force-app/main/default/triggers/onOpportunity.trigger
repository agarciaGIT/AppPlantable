trigger onOpportunity on Opportunity (before update) {
    for(Integer i=0; i<trigger.new.size(); i++) {
        Opportunity opp = trigger.new[i];
        if(opp.Reload__c == True) {
            shopifyClass.loadShopifyOrderFuture(opp.External_Order_Id__c);
            opp.Reload__c = False;
        }
    }    
}