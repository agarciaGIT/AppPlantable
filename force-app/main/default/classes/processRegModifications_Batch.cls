/* Class to create Opportunity from Exam Registartion Modifications
 * Changes for Exam Admin to be made - Exam Modes
 * 
 * Input strings will populate OLI Description with From and To Exam Group Details
 * Ex: October 24,2020 for first parameter and January 16,2021 for second parameter
*/

global class processRegModifications_Batch implements Database.Batchable<sObject>{
    
    private String frmGrp;
    private String toGrp;
    private String recordId;
    public processRegModifications_Batch(String fromGroup, String toGroup,string inputRecordId) {
        frmGrp = fromGroup;
        toGrp = toGroup;
        recordId = inputRecordId;
    }
    public processRegModifications_Batch(String fromGroup, String toGroup) {
        frmGrp = fromGroup;
        toGrp = toGroup;
    }
    global Database.QueryLocator start(Database.BatchableContext bc){
        if(String.isNotBlank(recordId)){
       		return Database.getQueryLocator([Select Id,Part_I_Exam_Registration__c,Part_II_Exam_Registration__c,
                                                   Part_I_Exam_Registration__r.Member__c,Part_II_Exam_Registration__r.Member__c,
                                                   Status__c,Part_I_Exam_Group_From__c,Part_II_Exam_Group_From__c,
                                                   Part_I_Exam_Group_To__c,Part_II_Exam_Group_To__c,Deferral_Subtype__c
                                            from Exam_Registration_Modification__c 
                                            where Status__c = 'Pending Bulk Modification' AND Id =: recordId]); 
        }else{
            return Database.getQueryLocator([Select Id,Part_I_Exam_Registration__c,Part_II_Exam_Registration__c,
                                                   Part_I_Exam_Registration__r.Member__c,Part_II_Exam_Registration__r.Member__c,
                                                   Status__c,Part_I_Exam_Group_From__c,Part_II_Exam_Group_From__c,
                                                   Part_I_Exam_Group_To__c,Part_II_Exam_Group_To__c,Deferral_Subtype__c
                                            from Exam_Registration_Modification__c 
                                            where Status__c = 'Pending Bulk Modification']);
        }
        
    }
    
    global void execute(Database.BatchableContext bc, List<Exam_Registration_Modification__c> scope){
        Set<Id> contactIds = new Set<Id>();
        Set<Id> examRegistrationIdSet = new Set<Id>();
        Set<Id> examModificationIds = new Set<Id>();
        List<Exam_Registration_Modification__c> modificationsToUpdate = new List<Exam_Registration_Modification__c>();
        List<Opportunity> newOppsList = new List<Opportunity>();
        List<Opportunity> createdOppsList = new List<Opportunity>();
        List<Opportunity> OppsToUpdate = new List<Opportunity>();
        List<OpportunityLineItem> newOppLineItems = new List<OpportunityLineItem>();
        List<PriceBookEntry> priceBookEntryList = new List<PriceBookEntry>();
        List<ChargentSFA__Transaction__c> newChrgntTransList = new List<ChargentSFA__Transaction__c>();
        Map<String,PriceBookEntry> productCodeToIdMap = new Map<String,PriceBookEntry>();
        Map<String,Opportunity> registrationToOpptyMap = new Map<String,Opportunity>();
        PriceBook2 priceBook = [Select Id,IsActive from PriceBook2 where IsActive = true Limit 1];
        String oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Automated').getRecordTypeId();
        
        for(Exam_Registration_Modification__c erm : scope){
            if(erm.Part_I_Exam_Registration__c != null){
                contactIds.add(erm.Part_I_Exam_Registration__r.Member__c);
                examRegistrationIdSet.add(erm.Part_I_Exam_Registration__c);
            }else if(erm.Part_II_Exam_Registration__c != null){
                contactIds.add(erm.Part_II_Exam_Registration__r.Member__c);
                examRegistrationIdSet.add(erm.Part_II_Exam_Registration__c);
            }
        }
        Map<Id,Contact> contactMap = new Map<Id,Contact>([Select Id,Email,FirstName,LastName,HomePhone,Company__c,AccountId,
                                                                 Account.Billing_Address_Company__c,Account.BillingStreet,
                                                                 Account.BillingCity,Account.BillingState,Account.BillingPostalCode,
                                                                 Account.BillingCountry,MailingStreet,MailingCity,MailingState,
                                                                 MailingPostalCode,MailingCountry
                                                          from Contact where Id IN: contactIds]);
		List<Opportunity> opptyList = [Select Id,Exam_Registration_Modification__c,Ea_Id__c,Late_Ea_Id__c from Opportunity where Ea_Id__c IN:examRegistrationIdSet OR Late_EA_Id__c IN: examRegistrationIdSet ORDER BY CreatedDate DESC];        
        for(Opportunity opp : opptyList){
            if(String.isNotBlank(opp.EA_Id__c) && !registrationToOpptyMap.containskey(opp.EA_Id__c)){
                registrationToOpptyMap.put(opp.EA_Id__c,opp);
            }else if(String.isNotBlank(opp.Late_Ea_Id__c) && !registrationToOpptyMap.containskey(opp.EA_Id__c)){
                registrationToOpptyMap.put(opp.Late_Ea_Id__c,opp);
            }
        }
        for(Exam_Registration_Modification__c erm : scope){
            Contact con = contactMap.containsKey(erm.Part_I_Exam_Registration__r.Member__c) ? contactMap.get(erm.Part_I_Exam_Registration__r.Member__c) : contactMap.get(erm.Part_II_Exam_Registration__r.Member__c); 
            if(erm.Part_I_Exam_Registration__c != null && registrationToOpptyMap.containskey(erm.Part_I_Exam_Registration__c)){
                Opportunity opp = registrationToOpptyMap.get(erm.Part_I_Exam_Registration__c);
                opp.Exam_Registration_Modification__c = erm.id;
                opp.Late_EA_Id__c = erm.Part_I_Exam_Registration__c;
                opp.Pending_Bulk_Deferral_Move__c = true;
                opp.Deferral_SubType__c = erm.Deferral_SubType__c;
                OppsToUpdate.add(opp);
            }else if(erm.Part_II_Exam_Registration__c != null && registrationToOpptyMap.containskey(erm.Part_II_Exam_Registration__c)){
                Opportunity opp = registrationToOpptyMap.get(erm.Part_II_Exam_Registration__c);
                opp.Exam_Registration_Modification__c = erm.id;
                opp.Late_EA_Id__c = erm.Part_II_Exam_Registration__c;
                opp.Pending_Bulk_Deferral_Move__c = true;
                opp.Deferral_SubType__c = erm.Deferral_SubType__c;
                OppsToUpdate.add(opp);
            }else{
                Opportunity objOpp = new Opportunity();
                objOpp.AccountId = con.AccountId;
                objOpp.ChargentSFA__Billing_Email__c = con.Email;
                objOpp.ChargentSFA__Billing_First__c = con.FirstName;
                objOpp.ChargentSFA__Billing_Last__c = con.LastName;
                objOpp.ChargentSFA__Billing_Phone__c = con.HomePhone;
                objOpp.ChargentSFA__Billing_Company__c = con.Account.Billing_Address_Company__c;
                objOpp.ChargentSFA__Billing_Address__c = con.Account.BillingStreet;
                objOpp.ChargentSFA__Billing_City__c = con.Account.BillingCity;
                objOpp.ChargentSFA__Billing_State__c = con.Account.BillingState;
                objOpp.ChargentSFA__Billing_Zip__c = con.Account.BillingPostalCode;
                objOpp.ChargentSFA__Billing_Country__c = con.Account.BillingCountry;
                objOpp.Shipping_First_Name__c = con.FirstName;
                objOpp.Shipping_Last_Name__c = con.LastName;
                objOpp.Shipping_E_mail__c = con.Email;
                objOpp.Shipping_Company_Name__c = con.Company__c;
                objOpp.Shipping_Phone_No__c = con.HomePhone;
                objOpp.Shipping_Street__c = con.MailingStreet;
                objOpp.Shipping_City__c = con.MailingCity;
                objOpp.Shipping_State__c = con.MailingState;
                objOpp.Shipping_Postal_Code__c = con.MailingPostalCode;
                objOpp.Shipping_Country__c = con.MailingCountry;
                objOpp.Exam_Registration_Modification__c = erm.id;
                objOpp.StageName = 'Closed';
                objOpp.CloseDate = system.today();
                objOpp.Name = 'Late Exam Deferral';
                objOpp.RecordTypeId = oppRecordTypeId;
                objOpp.Pending_Bulk_Deferral_Move__c = true;
                objOpp.priceBook2Id = priceBook.Id;
                objOpp.Late_EA_Id__c = erm.Part_I_Exam_Registration__c != null ? erm.Part_I_Exam_Registration__c : erm.Part_II_Exam_Registration__c;
                objOpp.Free_Deferral__c = true;
                objOpp.Deferral_SubType__c = erm.Deferral_SubType__c;
                newOppsList.add(objOpp);
                examModificationIds.add(erm.id);
            }
            
            erm.Status__c = 'Opportunity Created';
            modificationsToUpdate.add(erm);
            
        }
        
        if(!OppsToUpdate.isEmpty()){
            update OppsToUpdate;
        }
        if(!newOppsList.isEmpty()){
            insert newOppsList;
        }
        
        if(!modificationsToUpdate.isEmpty()){
            update modificationsToUpdate;
        }
        Set<String> productCodes = new Set<String>{'FRM1','ENC'};        
        priceBookEntryList = [Select Id,ProductCode,Product2.GL_Code__c,Product2Id,UnitPrice from PriceBookEntry where Pricebook2.IsActive = true AND Product2.GL_Code__c = '4020' AND ProductCode IN: productCodes AND isActive = true];
        
        for(PriceBookEntry pbe : priceBookEntryList){
            if(pbe.ProductCode == 'FRM1'){
                productCodeToIdMap.put('FRM',pbe);
            }else if(pbe.ProductCode == 'ENC'){
                productCodeToIdMap.put('ERP',pbe);
            }
        }
        
        createdOppsList = [Select Id,Exam_Registration_Modification__c,Exam_Registration_Modification__r.Part_I_Exam_Group_From__r.Name,
                                  Exam_Registration_Modification__r.Part_II_Exam_Group_From__r.Name,Exam_Registration_Modification__r.Part_I_Exam_Group_To__r.Name,
                                  Exam_Registration_Modification__r.Part_II_Exam_Group_To__r.Name,Exam_Registration_Modification__r.Part_I_Exam_Group_From__c,
                                  Exam_Registration_Modification__r.Part_I_Exam_Registration__c,Exam_Registration_Modification__r.Part_II_Exam_Registration__c,
                                  Exam_Registration_Modification__r.Part_I_Exam_Registration__r.Section__c,Exam_Registration_Modification__r.Part_II_Exam_Registration__r.Section__c
                           from Opportunity where Exam_Registration_Modification__c IN: examModificationIds];
        
        for(Opportunity opp: createdOppsList){
            String description = 'Deferral of ';
            String productId;
            String priceBookEntryId;
            if(opp.Exam_Registration_Modification__r.Part_I_Exam_Registration__c != null && opp.Exam_Registration_Modification__r.Part_I_Exam_Registration__r.Section__c.contains('FRM')){
                description += 'FRM Part 1 ';
                productId = productCodeToIdMap.get('FRM').Product2Id;
                priceBookEntryId = productCodeToIdMap.get('FRM').id;
            }
            if(opp.Exam_Registration_Modification__r.Part_I_Exam_Registration__c != null && opp.Exam_Registration_Modification__r.Part_I_Exam_Registration__r.Section__c.contains('ERP')){
                description += 'ERP Part 1 ';
                productId = productCodeToIdMap.get('ERP').Product2Id;
                priceBookEntryId = productCodeToIdMap.get('ERP').id;
            }
            if(opp.Exam_Registration_Modification__r.Part_II_Exam_Registration__c != null && opp.Exam_Registration_Modification__r.Part_II_Exam_Registration__r.Section__c.contains('FRM')){
                if(description.contains('Part')){
                    description += ' and 2 ';
                }else{
                    description += 'FRM Part 2 ';
                }
                productId = productCodeToIdMap.get('FRM').Product2Id;
                priceBookEntryId = productCodeToIdMap.get('FRM').id;
            }
            if(opp.Exam_Registration_Modification__r.Part_II_Exam_Registration__c != null && opp.Exam_Registration_Modification__r.Part_II_Exam_Registration__r.Section__c.contains('ERP')){
                if(description.contains('Part')){
                    description += ' and 2 ';
                }else{
                    description += 'ERP Part 2 ';
                }productId = productCodeToIdMap.get('ERP').Product2Id;
                priceBookEntryId = productCodeToIdMap.get('ERP').id;
            }
            
            description += 'from '+frmGrp+' to '+toGrp;
            OpportunityLineItem oli = new OpportunityLineItem();
            oli.OpportunityId = opp.Id;
            oli.Quantity = 1;
            oli.Description = description;
            oli.Product2Id = productId;
            oli.PricebookEntryId = priceBookEntryId;
            oli.UnitPrice = 0;
            newOppLineItems.add(oli);
            
            ChargentSFA__Transaction__c trans = new ChargentSFA__Transaction__c();
            trans.ChargentSFA__Opportunity__c = opp.Id;
            trans.ChargentSFA__Amount__c = 0.00;
            trans.ChargentSFA__Response_Message__c = 'Approved';
            trans.ChargentSFA__Response_Status__c = 'Approved';
            trans.ChargentSFA__Type__c = 'Charge';
            trans.ChargentSFA__Gateway_Date__c =system.now();
            newChrgntTransList.add(trans);
        }
        
        if(!newOppLineItems.isEmpty()){
           insert newOppLineItems; 
        }
        if(!newChrgntTransList.isEmpty()){
           insert newChrgntTransList; 
        }
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
}