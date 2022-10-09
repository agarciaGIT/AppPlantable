global class batchPreOrderEBookDelivery implements Database.Batchable<sObject>,Database.StateFul{
    
    public String startDate; 
    public String endDate; 
    public String mode; 
    
    global batchPreOrderEBookDelivery (String startDate, String endDate, String mode){
        this.startDate = startDate;
        this.endDate = endDate;
        this.mode = mode;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){  
        String stage = 'Closed';
        DateTime sd = DateTime.parse(this.startDate);
        DateTime ed = DateTime.parse(this.endDate); 
        
        return Database.getQueryLocator('SELECT Id, Name, StageName, Amount, Shipping_E_mail__c, (SELECT Id,Description,ProductCode FROM OpportunityLineItems) FROM Opportunity where Pre_Order_eBook_Delivery__c != true and StageName = :stage and CreatedDate >= :sd and CreatedDate <= :ed');
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
        Map < Id, Opportunity > eBookFRM1ProvisionOpps = new Map < Id, Opportunity > ();    
        Map < Id, Opportunity > eBookFRM2ProvisionOpps = new Map < Id, Opportunity > ();    
        Map < Id, Opportunity > eBookERP2ProvisionOpps = new Map < Id, Opportunity > ();    
        
        system.Debug('Scope:' + scope.size());

        MAP<String, Product_Refunds__c> refundMap = new MAP<String, Product_Refunds__c>();
        List < Product_Refunds__c > lstPr = [select Id, Refund_amount__c, Opportunity__c, Opportunity__r.AccountId,
            Product__r.ProductCode, Product__r.Product_ID__c from Product_Refunds__c where
            Status__c = 'Completed'
            and Opportunity__c in : scope
        ];
        for(Product_Refunds__c ref: lstPr) {
            if(ref.Product__r.ProductCode != null)
            	refundMap.put(ref.Product__r.ProductCode, ref);
        }

        system.Debug('refundMap:' + refundMap);
                
        for(Opportunity opp :scope) {
            Boolean foundERP = false;
            Boolean foundFRM = false;
            for(OpportunityLineItem oppLine :opp.OpportunityLineItems){
                Product_Refunds__c refund = refundMap.get(oppLine.ProductCode);
                
                if (oppLine.ProductCode == 'FRM1X' && refund == null) {
                    eBookFRM1ProvisionOpps.put(opp.Id, opp);
                    foundFRM=true;
                } else if (oppLine.ProductCode == 'FRM2X' && refund == null) {
                    eBookFRM2ProvisionOpps.put(opp.Id, opp);
                    foundFRM=true;
                } else if (oppLine.ProductCode == 'ENC2X' && refund == null) {
                    eBookERP2ProvisionOpps.put(opp.Id, opp);
                    foundERP=true;
                }                    
            }
            if((this.mode == 'ERP' && foundERP == true) || (this.mode == 'FRM' && foundFRM == true) || (foundFRM == false && foundERP == false))
            	opp.Pre_Order_eBook_Delivery__c = true;
        }
        update scope;
        
        List<Integration_Stream_Event__e> eventList = new List<Integration_Stream_Event__e>();
        
        if(this.mode == 'FRM') {
            system.debug('eBookFRM1ProvisionOpps:' + eBookFRM1ProvisionOpps);
            if (eBookFRM1ProvisionOpps.size() > 0) {
                List<Integration_Stream_Event__e> evtList = TriggerUtilities.getIntgEvents(eBookFRM1ProvisionOpps.keyset(),'Opportunity','FRM1EBook');
                eventList.addAll(evtList);
            }
    
            system.debug('eBookFRM2ProvisionOpps:' + eBookFRM2ProvisionOpps);
            if (eBookFRM2ProvisionOpps.size() > 0) {
                List<Integration_Stream_Event__e> evtList = TriggerUtilities.getIntgEvents(eBookFRM2ProvisionOpps.keyset(),'Opportunity','FRM2EBook');
                eventList.addAll(evtList);
            }
        }
        
        if(this.mode == 'ERP') {
            
            system.debug('eBookERP2ProvisionOpps:' + eBookERP2ProvisionOpps);
            if (eBookERP2ProvisionOpps.size() > 0) {
                List<Integration_Stream_Event__e> evtList = TriggerUtilities.getIntgEvents(eBookERP2ProvisionOpps.keyset(),'Opportunity','ERP2EBook');
                eventList.addAll(evtList);
            }
        }
        
    }
    
    
    global void finish(Database.BatchableContext BC){
        
    }
}