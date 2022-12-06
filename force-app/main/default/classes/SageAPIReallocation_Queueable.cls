public class SageAPIReallocation_Queueable implements System.Queueable, Database.AllowsCallouts{

    Public Set<Id> oppIds = new Set<Id>();
    Public SageAPIReallocation_Queueable(Set<Id> OppIdSet){
        this.oppIds = OppIdSet;
    }
    public void execute(System.QueueableContext context) {
        Set<Id> origOpps = new Set<Id>();
        List<Opportunity> oppslist = [Select Id,Display_Invoice_Number__c,Refund_Opportunity__c from Opportunity where Id IN: oppIds];
        for(Opportunity opp :oppslist) { 
            if(opp.Refund_Opportunity__c != null){
                origOpps.add(opp.Refund_Opportunity__c);
            }
        }
        
        List<Opportunity> originalOpps = [Select Id,Display_Invoice_Number__c,
                                          (SELECT Id,Opportunity__c,Take_Membership__c FROM Product_Refunds__r where Take_Membership__c = true)  
                                          from Opportunity where Id in: origOpps];
        
        for(Opportunity opp :originalOpps) {
            if(opp.Product_Refunds__r.size() > 0){
                SageApiWebService.reallocation(opp.Display_Invoice_Number__c,system.today());
            }
        }
        
    }
}