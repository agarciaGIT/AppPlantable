global class batchSiteCodeUpdateSage implements Database.Batchable<Sobject>{
    global Database.QueryLocator start(Database.BatchableContext bc){
        Date newDate = Date.newInstance(2020, 12, 01);
        return Database.getQueryLocator([Select Id, Opportunity__c,Section__c,Result__c from Exam_Attempt__c where Opportunity__c != null and Opportunity__r.StageName = 'Closed' and Result__c = null and cancelled__c = false and createddate >=: newDate]);
        
    }
    
    global void execute(Database.BatchableContext bc, List<Exam_Attempt__c> scope){
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
        Set<Id> oppIds = new Set<Id>();
        Map<String,String> IntacctUserDimensionMap = new Map<String,String>();
        Map<String,Site_Code_MDT__mdt> siteCodeMap = new map<String,Site_Code_MDT__mdt>();
        Map<String,Opportunity_Product_Mapping__mdt> oppProductToMethodMap = OpportunityTriggerHelper_New.getOppProductMethodMapAllProducts();
        
        for(ia_crm__Intacct_User_Dimension__c ciud : [SELECT ID,Name FROM ia_crm__Intacct_User_Dimension__c LIMIT 10000]){
            IntacctUserDimensionMap.put(ciud.Name.substring(0,4), ciud.Id);
        }
        
        for(Site_Code_MDT__mdt mdt : [Select DeveloperName,Label,code__c from Site_Code_MDT__mdt]){
            siteCodeMap.put(mdt.Label, mdt);
        }
        
        for(Exam_Attempt__c ea : scope){
            oppIds.add(ea.Opportunity__c);
        }
        
        List<OpportunityLineItem> oppProdList = [Select Id,Site_Code__c,ProductCode,Sage_Reporting_Country__c,Sage_Shipping_Country__c,Batches_Updated__c from OpportunityLineItem where OpportunityId IN: oppIds];
        
        for(OpportunityLineItem oli : oppProdList){
            if(oppProductToMethodMap.containsKey(oli.ProductCode) && oppProductToMethodMap.get(oli.ProductCode).Product_Category__c == 'Exam' && oppProductToMethodMap.get(oli.ProductCode).Product_Sub_Category__c != 'Scholarship'){
                string siteId = Sage_Default_Records_Ref__mdt.getInstance('Unallocated_Site_Id').value__c;
                oli.Site_Code__c = siteId;
                
            }
            
            Site_Code_MDT__mdt siteCodeMDT = new Site_Code_MDT__mdt();
            
            if(String.isNotBlank(oli.Sage_Shipping_Country__c) && siteCodeMap.containskey(oli.Sage_Shipping_Country__c)){
                siteCodeMDT = siteCodeMap.get(oli.Sage_Shipping_Country__c);
            }else if(String.isNotBlank(oli.Sage_Shipping_Country__c) && oli.Sage_Shipping_Country__c == 'United States'){
                siteCodeMDT = siteCodeMap.get('United States of America (USA)');
            }else if(String.isNotBlank(oli.Sage_Reporting_Country__c) && siteCodeMap.containskey(oli.Sage_Reporting_Country__c)){
                siteCodeMDT = siteCodeMap.get(oli.Sage_Reporting_Country__c);
            }else if(String.isNotBlank(oli.Sage_Reporting_Country__c) && oli.Sage_Reporting_Country__c == 'United States'){
                siteCodeMDT = siteCodeMap.get('United States of America (USA)');
            }else{
                siteCodeMDT = null;
            }
            
            system.debug(oli.Sage_Reporting_Country__c+'      <<::inside updateSageOLI  siteCodeMDT::>>>   '+siteCodeMDT);
            
            if(oli.Site_Code__c == null && siteCodeMDT != null && IntacctUserDimensionMap!= null && IntacctUserDimensionMap.containsKey(siteCodeMDT.Code__c)){
                system.debug(oli.Sage_Reporting_Country__c+'      <<::inside updateSageOLI  IntacctUserDimensionMap::>>>   '+IntacctUserDimensionMap.get(siteCodeMDT.Code__c));
                oli.Site_Code__c = IntacctUserDimensionMap.get(siteCodeMDT.Code__c);
            }
            
            if(oli.Batches_Updated__c != null){
                List<String> batches = oli.Batches_Updated__c.split(';');
                batches.add('Site Code Batch');
                oli.Batches_Updated__c = String.join(batches, ';');
            }else{
                oli.Batches_Updated__c = 'Site Code Batch';
            }
            oliList.add(oli);
        }
        
        update oliList;
    }

    
    global void finish(Database.BatchableContext bc){
        
    }
}