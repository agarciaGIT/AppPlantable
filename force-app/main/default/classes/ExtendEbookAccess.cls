global class ExtendEbookAccess implements Database.Batchable<sObject>,Database.StateFul,Database.AllowsCallouts{

   
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        //run this batch for only one record at once.
        // change the year or check with al before running.this is impotant.

        
       string strQuery = 'select id,accountid from opportunity where Give_Ebook_for_Free__c = true';

        return Database.getQueryLocator(strQuery); 
        
    }
    
    global void execute(Database.BatchableContext BC, List<opportunity> scope){
        
        string Newopp = scope[0].id;
        opportunity Opp1 = scope[0];
        string exam ='FRM';
        string Part ='I';
        map<Id,opportunity> OppMap = new map<Id,opportunity>();
        String MobiusProductYear = '2019';  
        OppMap.put(Newopp,Opp1);
      //  opportunityTriggerUtils.provisionFRMeBook (OppMap,exam,Part);
            List<Opportunity> lstOpp = [
                select Id, name,Shipping_First_Name__c,Shipping_Last_Name__c,GARP_Member_ID__c,Shipping_E_mail__c, (SELECT Id,ProductCode, Product_ID__c FROM OpportunityLineItems) 
                from Opportunity  where id = :Newopp];
        system.debug('lstOpp:' + lstOpp);
        
        MAP<String, String> mapProd = new MAP<String, String>();
        for(Opportunity opp :lstOpp) {           
            for(OpportunityLineItem ol :opp.OpportunityLineItems){
                mapProd.put(ol.ProductCode,ol.Product_ID__c);
            }                        
        }
        system.debug('mapProd:' + mapProd);
        
       
        Map<String,Mobius_Products__c> mProds = Mobius_Products__c.getall();
        Mobius_Products__c MobiusProductYearObj = mProds.get('Current Year');
        if(MobiusProductYearObj != null) {
            MobiusProductYear = MobiusProductYearObj.Year__c;
        }
        system.debug('MobiusProductYear:' + MobiusProductYear);
        
        List<Integer> iProdList = new List<Integer>();
        String productID;
        Integer accessDuration;
        
        for(Mobius_Products__c mp :mProds.values()) {
            if(mp.Year__c == MobiusProductYear && mp.Exam__c == exam && mp.Part__c == part) {
                iProdList.add(Integer.valueOf(mp.Product_Id__c));
                productID = mapProd.get(mp.Salesforce_Product_Code__c);
                if(mp.Access_Duration_in_Months__c != NULL) {
                    accessDuration = Integer.ValueOf(mp.Access_Duration_in_Months__c);
                }                
            }                        
        }
        system.debug('iProdList:' + iProdList);
        system.debug('productID:' + productID);
        
        if(iProdList.size() > 0) {
            
            for(Opportunity opp :lstOpp) {
                mobiusAPI.mProvisionAnEBookFromBatch(exam, part, productID, accessDuration, iProdList, opp.Id,opp.Shipping_E_mail__c,opp.Shipping_First_Name__c,opp.Shipping_Last_Name__c,opp.GARP_Member_ID__c);
            } 
            
        }  
       
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}