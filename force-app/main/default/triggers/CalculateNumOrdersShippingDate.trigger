trigger CalculateNumOrdersShippingDate on Plant_Order_Properties__c (after insert, after update, after delete) {
    Set<Id> shipDateIds = new Set<Id>();
    
    if(!Trigger.isDelete){
        for(Plant_Order_Properties__c oNew : Trigger.New){
        	if(oNew.Plant_Shipping_Date__c != null){
            	shipDateIds.add(oNew.Plant_Shipping_Date__c);
        	}
    	}
    }
    if(!Trigger.isInsert){
        for(Plant_Order_Properties__c oOld : Trigger.Old){
            if(oOld.Plant_Shipping_Date__c != null){
                shipDateIds.add(oOld.Plant_Shipping_Date__c);
            }       
        }
    }
    
    List<Plant_Order_Properties__c> orders = [SELECT Id, Plant_Shipping_Date__c FROM Plant_Order_Properties__c WHERE Plant_Shipping_Date__c IN :shipDateIds];
    Map<Id, List<Plant_Order_Properties__c>> mappedOrders = new Map<Id, List<Plant_Order_Properties__c>>();
    for(Plant_Order_Properties__c o : orders){
        if(!mappedOrders.containsKey(o.Plant_Shipping_Date__c)){
            List<Plant_Order_Properties__c> os = new List<Plant_Order_Properties__c>();
            os.add(o);
            mappedOrders.put(o.Plant_Shipping_Date__c, os);
        }else{
            mappedOrders.get(o.Plant_Shipping_Date__c).add(o);
        }
    }

    List<Plant_Shipping_Date__c> shipDates = [SELECT Id, Plant_Total_Orders__c FROM Plant_Shipping_Date__c WHERE Id IN :shipDateIds];

    for(Plant_Shipping_Date__c d : shipDates){
        d.Plant_Total_Orders__c = mappedOrders.get(d.Id) != null? mappedOrders.get(d.Id).size() : 0;
    }
    
    update shipDates;
}