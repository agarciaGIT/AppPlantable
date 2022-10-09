/**
* Class ChargentSFATransactionTriggerHandler
*
* Trigger Handler for the (ChargentSFA__Transaction__c) SObject. This class implements the TriggerAbstract
* interface to help ensure the trigger code is bulkified and all in one place.
*/
public without sharing class ChargentSFATransactionTriggerHandler implements TriggerAbstract {
    
    public static List<Opportunity> OppListToUpdate = new List<Opportunity>();
    static List<Product_Refunds__c> ProductRefundsListToUpdate = new List<Product_Refunds__c>();
    static Set<String> VoidTypeOppSet = new Set<String>();
    static Set<String> ChargeTypeOppSet = new Set<String>();
    static Set<String> RefundOppSet = new Set<String>();
    static Map<String,String> oppTransactionMap = new Map<String,String>();
    static List<Transaction_Event__e> eventList = new List<Transaction_Event__e>();
    
    
    public static boolean stopRecurssion = true;
    
    // Constructor
    public ChargentSFATransactionTriggerHandler(){
    }
    
    /**
* bulkBefore
*
* This method is called prior to execution of a BEFORE trigger. Use this to cache
* any data required into maps prior execution of the trigger.
*/
    public void bulkBefore(){
        if(stopRecurssion){}
	}
    
    public void bulkAfter(){
        if(stopRecurssion){}
    }
    
    public void beforeInsert(SObject so){
        system.debug('**********In ChargentSFATransactionTriggerHandler beforeInsert*******  ');
        ChargentSFA__Transaction__c newTransaction = (ChargentSFA__Transaction__c)so;
        if(stopRecurssion){
            if(newTransaction.ChargentSFA__Response_Status__c == 'Approved' && newTransaction.ChargentSFA__Type__c == 'Charge' && 
               newTransaction.ChargentSFA__Amount__c > 0 && !newTransaction.ChargentSFA__Recurring__c && newTransaction.ChargentSFA__Payment_Method__c == 'Credit Card') {        
                   Transaction_Event__e evt = new Transaction_Event__e();
                   evt.Amount__c = newTransaction.ChargentSFA__Amount__c;
                   evt.Authorization__c = newTransaction.ChargentSFA__Authorization__c;
                   evt.Card_Last_4__c = newTransaction.ChargentSFA__Card_Last_4__c;
                   evt.Chargent_Token__c = newTransaction.ChargentSFA__Tokenization__c;
                   evt.Gateway_Date__c = newTransaction.ChargentSFA__Gateway_Date__c;
                   evt.Gateway_ID__c = newTransaction.ChargentSFA__Gateway_ID__c;
                   evt.Gateway_Response__c = newTransaction.ChargentSFA__Gateway_Response__c;
                   evt.Opportunity_ID__c = newTransaction.ChargentSFA__Opportunity__c;
                   evt.Response_Status__c = newTransaction.ChargentSFA__Response_Status__c;
				   eventList.add(evt); 
               }
        }
    }
    
    public void beforeUpdate(SObject oldSo, SObject so){
        
        if(stopRecurssion){}
    }
    
    public void beforeDelete(SObject so){
        system.debug('**********In ChargentSFATransactionTriggerHandler beforeDelete*******  ');
        
    }
    
    public void afterInsert(SObject so){
        system.debug('**********In ChargentSFATransactionTriggerHandler afterInsert*******  ');
        ChargentSFA__Transaction__c newTransaction = (ChargentSFA__Transaction__c)so;
        if(stopRecurssion){
            if(!newTransaction.Do_not_fire__c){
                system.debug(newTransaction.ChargentSFA__Response_Status__c+'   :::    '+newTransaction.ChargentSFA__Type__c);
                system.debug(newTransaction.ChargentSFA__Recurring__c+'   :::    '+newTransaction.Opportunity_Stage__c);
                if(newTransaction.ChargentSFA__Response_Status__c== 'Approved' && newTransaction.ChargentSFA__Type__c =='Charge' && 
                   newTransaction.ChargentSFA__Recurring__c != true && newTransaction.Opportunity_Stage__c =='New Lead'){
                       ChargeTypeOppSet.add(newTransaction.ChargentSFA__Opportunity__c); 
                      
                   }
                
                
                if(newTransaction.ChargentSFA__Response_Status__c== 'Approved' && 
                   (newTransaction.ChargentSFA__Type__c =='Refund'|| newTransaction.ChargentSFA__Type__c =='Charge Back Accepted' || newTransaction.ChargentSFA__Type__c =='Charge Back Loss')){
                       RefundOppSet.add(newTransaction.ChargentSFA__Opportunity__c); 
                       
                       oppTransactionMap.put(newTransaction.ChargentSFA__Opportunity__c,newTransaction.id);    
                   }
            }
        }
    }
    
    public void afterUpdate(SObject oldSo, SObject so){
        system.debug('**********In ChargentSFATransactionTriggerHandler afterUpdate*******  ');
        ChargentSFA__Transaction__c newTransaction = (ChargentSFA__Transaction__c)so;
        if(stopRecurssion){
            system.debug(newTransaction.ChargentSFA__Response_Status__c+'   :::    '+newTransaction.ChargentSFA__Type__c);
            if(newTransaction.ChargentSFA__Response_Status__c== 'Approved' && newTransaction.ChargentSFA__Type__c =='Void' && 
               newTransaction.ChargentSFA__Recurring__c != true && newTransaction.Opportunity_Stage__c =='New Lead'){
                   VoidTypeOppSet.add(newTransaction.ChargentSFA__Opportunity__c);                   
               }
        }
        
    }
    
    public void afterDelete(SObject so){
        system.debug('**********In ChargentSFATransactionTriggerHandler afterDelete*******  ');
    }
    
    /**
* andFinally
*
* This method is called once all records have been processed by the trigger. Use this
* method to accomplish any final operations such as creation or updates of other records.
*/
    public void andFinally(){
        if(!trigger.isDelete && stopRecurssion){
            if(trigger.isafter && trigger.isinsert){
                if(ChargeTypeOppSet.size() > 0){
                    for(Opportunity opp : [SELECT Id,StageName FROM Opportunity WHERE Id IN: ChargeTypeOppSet]){
                        opp.StageName = 'Closed';
                        opp.CloseDate = system.today();
                        OppListToUpdate.add(opp);
                    }
                }
            
                if(RefundOppSet.size() > 0 && oppTransactionMap.size() > 0){
                    for(Product_Refunds__c pr : [SELECT Id,status__C,Opportunity__c FROM Product_Refunds__c WHERE Opportunity__c IN: RefundOppSet and status__c ='Approved']){
                        pr.Status__c  ='Completed';
                        pr.Payment_Transaction__c = oppTransactionMap.get(pr.Opportunity__c);
                        ProductRefundsListToUpdate.add(pr);  
                    }
                }
        	}
            
            if(trigger.isafter && trigger.isUpdate){
                if(VoidTypeOppSet.size() > 0){
                    for(Opportunity opp : [SELECT Id,StageName FROM Opportunity WHERE Id IN: VoidTypeOppSet]){
                        opp.StageName = 'Recurring Intent';
                        opp.CloseDate = system.today();
                        OppListToUpdate.add(opp);
                    }
                }
        	}
        
            if(OppListToUpdate.size() > 0){
              update OppListToUpdate;  
            }
            
            if(ProductRefundsListToUpdate.size() > 0){
                update ProductRefundsListToUpdate; 
            }
            
            if(eventList.size() > 0){
               EventBus.Publish(eventList); 
            }
            if(trigger.isAfter && trigger.isUpdate){
                stopRecurssion = false;
            }
        }
    }
}