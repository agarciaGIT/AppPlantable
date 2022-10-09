public class BulkCloseInstitutionalSaleOrdersBatch implements Database.Batchable<Opportunity>, Database.Stateful{
    
    public List<Opportunity> childOppportunitiesToClose { get; set; }
    public Map<Id, ChargentSFA__Transaction__c> childOppportunityTransactionsByOpportunityId { get; set; }
    
    public BulkCloseInstitutionalSaleOrdersBatch(List<Opportunity> childOppportunitiesToClose, Map<Id, ChargentSFA__Transaction__c> childOppportunityTransactionsByOpportunityId){
        this.childOppportunitiesToClose = childOppportunitiesToClose;
        this.childOppportunityTransactionsByOpportunityId = childOppportunityTransactionsByOpportunityId;
    }
    
    public Iterable<Opportunity> start(Database.BatchableContext bc) {                
        return this.childOppportunitiesToClose;
    }

    public void execute(Database.BatchableContext bc, List<Opportunity> childOppportunitiesToClose) {
        
        List<ChargentSFA__Transaction__c> transactions = new List<ChargentSFA__Transaction__c>();
        for(Opportunity childOpportunity: childOppportunitiesToClose){
            if(childOppportunityTransactionsByOpportunityId.containsKey(childOpportunity.Id)){
            	transactions.add(childOppportunityTransactionsByOpportunityId.get(childOpportunity.Id));
            }
        }
        
        if(!transactions.isEmpty()) INSERT transactions;
        if(!childOppportunitiesToClose.isEmpty()) UPDATE childOppportunitiesToClose;
        
    }

    public void finish(Database.BatchableContext bc) {
        
    }
    
}