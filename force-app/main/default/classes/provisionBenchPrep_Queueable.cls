public class provisionBenchPrep_Queueable implements System.Queueable, Database.AllowsCallouts{

    public Set<Id> oppIdSet = new Set<Id>();
    
    public provisionBenchPrep_Queueable(Set<Id> oppIds){
        this.oppIdSet = oppIds;
    }
    
    public void execute(System.QueueableContext context) {
        Set<Id> accountIds = new Set<Id>();
        List<Opportunity> oppslist = [Select Id,name,Shipping_First_Name__c,Shipping_Last_Name__c,GARP_Member_ID__c,Shipping_E_mail__c,
                                      		 ChargentSFA__Billing_Email__c, ChargentSFA__Billing_First__c, ChargentSFA__Billing_Last__c,
                                      		 ChargentSFA__Invoice_Number__c,AccountId,
                                        	(SELECT Id,ProductCode, Product_ID__c FROM OpportunityLineItems)
                                      from Opportunity where Id IN: oppIdSet];
        System.debug('oppslist:' + oppslist);
        
        for(Opportunity opp : oppslist){
            accountIds.add(opp.AccountId);
        }
        
        List<Contact> lstContacts = [select Id, AccountId from Contact where AccountId in :accountIds];
        System.debug('lstContacts:' + lstContacts);
        Map<String,Contact> mapContactsByAccountId = new Map<String,Contact>();
        for(Contact cont :lstContacts) {
            mapContactsByAccountId.put(cont.AccountId,cont);
        }
        
        MAP<String, String> prodCodeToIdMap = new MAP<String, String>();
        List<eBook_Key__c> lstNewEBooks = new List<eBook_Key__c>();
        for(Opportunity opp :oppslist) {
            Contact fndCont = mapContactsByAccountId.get(opp.AccountId);
            if(fndCont != NULL) {
                for(OpportunityLineItem ol :opp.OpportunityLineItems){
                    // Replace with Real Product Code
                    if(ol.ProductCode == 'SCRBP') {
                        eBook_Key__c newEbook = new eBook_Key__c(
                            Member_EMail__c = opp.Shipping_E_mail__c,
                            Type__c = 'BenchPrep',
                            Opportunity__c = opp.Id,
                            Contact__c = fndCont.Id,
                            Product_ID__c = ol.Product_ID__c,
                            Key__c = opp.Id + 'BenchPrep',
                            Is_API__c = True,
                            Access_Duration_in_Months__c = 12,
                            Access_Expiration_Date__c = Date.today().addMonths(12)
                        );
                        lstNewEBooks.add(newEbook);
                        break;
                    }
                }
            }
        }
        insert lstNewEBooks;
        System.debug('accountIds:' + accountIds);
        
        if(!lstContacts.isEmpty() && !test.isRunningTest()) {
            List<User> lstUsers = [select Id, Bench_Prep_SSO_Attribute__c from User where ContactId in :lstContacts];
            System.debug('lstUsers:' + lstUsers);
            
            for(User u :lstUsers) {
                // Replace with Correct BenchPrep Access field
                u.Bench_Prep_SSO_Attribute__c = '[ { "course_slug": "scr", "expiration_date": "' + String.valueOf(Date.today().addMonths(12)) + '" } ]';
            }
            update lstUsers;
        }
        
    }
}