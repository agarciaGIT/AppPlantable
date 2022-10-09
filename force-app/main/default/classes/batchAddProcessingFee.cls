global class batchAddProcessingFee implements Database.Batchable<sObject>,Database.StateFul{
    
   global String prodCode = 'prfee';
   global Database.QueryLocator start(Database.BatchableContext BC){  
        
        Decimal dUnitPrice = 0.00; 
       return Database.getQueryLocator('select id,opportunityid from opportunitylineitem where productcode=: prodCode and UnitPrice =: dUnitPrice');
      
   }

   global void execute(Database.BatchableContext BC, List<opportunitylineitem> scope){

        
       list<string> oo = new list<string>();
        for(opportunitylineitem op :scope){
            
            oo.add(op.opportunityid);
            system.debug('&&&&&&:'+oo);
        }
        
        list<string> status = new list<string>{'closed','Closed Lost'};
        list<ChargentSFA__Payment_Request__c> pr =[select id,ChargentSFA__Opportunity__c,ChargentSFA__Status__c,ChargentSFA__Opportunity__r.stagename from ChargentSFA__Payment_Request__c  where ChargentSFA__Opportunity__c =:oo and ChargentSFA__Status__c ='Manually Sent' and createddate !=today and ChargentSFA__Opportunity__r.stagename !=:status];
        
        list<Id> op = new list<Id>();
        for(ChargentSFA__Payment_Request__c p:pr){
            
           op.add(p.ChargentSFA__Opportunity__c);
           system.debug('******:'+op);
        }
        
        List<opportunitylineitem> updateLineItems = new List<opportunitylineitem>();
        for(opportunitylineitem oL : [select id,UnitPrice,opportunityid from opportunitylineitem where opportunityid in : op and productcode=: prodCode])
        {
            oL.UnitPrice = 50.00;
            updateLineItems.add(oL);
        }
        
        if(!updateLineItems.isEmpty())
            update updateLineItems;

    }
    
    
   global void finish(Database.BatchableContext BC){
   
   }
}