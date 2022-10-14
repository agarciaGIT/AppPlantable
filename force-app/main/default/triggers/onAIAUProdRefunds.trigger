trigger onAIAUProdRefunds on Product_Refunds__c (after insert,after update) {
    
    Object_Trigger_Switch__mdt metadataSwitch = Object_Trigger_Switch__mdt.getInstance('ProductRefundsMDT');
    System.debug('metadataSwitch::>>    '+metadataSwitch);
    Boolean runTrigger = False;
    if(metadataSwitch != null && !metadataSwitch.isActive__c && !Test.isRunningTest()){
        runTrigger = True;
    }
    
    if(Test.isRunningTest() && TestClassUtil.isOldTrigger == 'OLD' ){
        runTrigger = True;
    }
    
    if(runTrigger){
        
        List<Product_Refunds__c> lstProdRefunds = new List<Product_Refunds__c>();
        Set<ID> setOpps = new Set<Id>();
        List<MembershipRefundCodes__c > refundCodes = MembershipRefundCodes__c.getall().values();
        Set<Id> setCancelEbooksOppIds = new Set<Id>();
        Set<Id> setCancelFFRA = new Set<Id>();
        Set<Id> setCancelERPOppIds = new Set<Id>();
        Set<Id> setCancelFRMOppIds = new Set<Id>();
        Set<Id> setCancelOTSAOppIds = new Set<Id>();
        Set<Id> setCancelFRMEAoppIds1 = new Set<Id>();
        Set<Id> setCancelFRMEAoppIds2 = new Set<Id>();
        Set<Id> setCancelERPEAOppIds = new Set<Id>();
        Set<Id> AddMisc = new Set<Id>();
        Set<Id> setCancelERPEAoppIds1 = new Set<Id>();
        Set<Id> setCancelERPEAoppIds2 = new Set<Id>();
        Set<Id> setCancelFFRAoppIds2 = new Set<Id>();
        Set<Id> setCancelScrOppIds = new Set<Id>();
        Set<Id> setCancelFrrOppIds = new Set<Id>();
        Set<Id> setCancelOpportunitiesForEventRegistration = new Set<Id>();
        Set<Id> setCancelwiley = new Set<Id>();
        Set<Id> setCancelRiskDotNet = new Set<Id>();
        Set<String> setCancelPracticeExamIds = new Set<String>();
        set<Id> setCancelPracticeExamOppIds = new Set<Id>();
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        integer term;
        
        //build set of associated opportunity ids
        Map<Id, String> garpMemberIdByOpportunityId = new Map<Id, String>();
        for(Product_Refunds__c pr: Trigger.new){
            garpMemberIdByOpportunityId.put(pr.Opportunity__c, pr.GARP_ID__c);
        }
        
        for(Product_Refunds__c obj : Trigger.new)
        {
            for(MembershipRefundCodes__c ref : refundCodes)
            {
                if(ref.Product_Code__c == obj.Product_Code__c)
                {
                    if(trigger.isUpdate)
                    {
                        if((obj.Status__c != trigger.oldMap.get(obj.Id).Status__c) && obj.Status__c == 'Completed' && (obj.Take_Membership__c || obj.Charge_Back__c))
                        {
                            lstProdRefunds.add(obj);
                            setOpps.add(obj.Opportunity__c);
                        }
                    }
                    else
                    {
                        if(obj.Status__c == 'Completed' && (obj.Take_Membership__c || obj.Charge_Back__c))
                        {
                            lstProdRefunds.add(obj);
                            setOpps.add(obj.Opportunity__c);
                        }
                        
                        
                    }
                    
                }
            }
            
            //if the status is completed and the ebook has been cancelled
            if(obj.Cancel_E_book__c && obj.Status__c == 'Completed'){
                
                setCancelPracticeExamIds.add(obj.Product_Code__c);
                setCancelPracticeExamOppIds.add(obj.Opportunity__c);
                
                setCancelEbooksOppIds.add(obj.Opportunity__c);
                
                //check for key
                if(garpMemberIdByOpportunityId.containsKey(obj.Opportunity__c)){
                    
                    //create a map of opportunities to refund
                    Map<Id, String> toRefund = new Map<Id, String>();               
                    toRefund.put(obj.Opportunity__c, garpMemberIdByOpportunityId.get(obj.Opportunity__c));
                    
                    system.debug('toRefund=======>'+toRefund);                
                    //if FRM 1 or FRM 2 ebook 
                    if(obj.Product_Code__c == 'FRM1X'){
                        OpportunityTriggerUtils.unprovisionMobiuseBook(toRefund, 'FRM', 'I');
                    } else if(obj.Product_Code__c == 'FRM2X'){
                        OpportunityTriggerUtils.unprovisionMobiuseBook(toRefund, 'FRM', 'II');
                    } else if(obj.Product_Code__c == 'SCRX'){
                        OpportunityTriggerUtils.unprovisionMobiuseBook(toRefund, 'SCR', 'I');
                    } else if(obj.Product_Code__c == 'ENC1X'){
                        OpportunityTriggerUtils.unprovisionMobiuseBook(toRefund, 'ERP', 'I');
                    } else if(obj.Product_Code__c == 'ENC2X'){
                        OpportunityTriggerUtils.unprovisionMobiuseBook(toRefund, 'ERP', 'II');
                    } 
                }
                
            }
            
            if(obj.Cancel_ERP_Enrollment__c&& obj.Status__c == 'Completed')
                setCancelERPOppIds.add(obj.Opportunity__c);
            
            //     get all the opportunities in a Set
            //     get all the opportunities in relation to events in a MAP
            
            if(obj.Status__c == 'Completed' && obj.Cancel_Event__c){
                setCancelOpportunitiesForEventRegistration.add(obj.Opportunity__c);
            }
            system.debug(setCancelOpportunitiesForEventRegistration);
            
            if(obj.Status__c == 'Completed' && (obj.Cancel_FBRA__c) && (obj.Status__c != trigger.oldMap.get(obj.Id).Status__c)){
                setCancelFFRA.add(obj.Opportunity__c);
                setCancelFFRAoppIds2.add(obj.Opportunity__c);} 
            if(obj.Cancel_FRM_Enrollment__c && obj.Status__c == 'Completed')
                setCancelFRMOppIds.add(obj.Opportunity__c);
            
            if(obj.Cancel_OTSA__c && obj.Status__c == 'Completed')
                setCancelOTSAOppIds.add(obj.Opportunity__c);
            
            if((obj.Cancel_FRM1__c ) && obj.Status__c == 'Completed')
                setCancelFRMEAoppIds1.add(obj.Opportunity__c);
            
            if((obj.Cancel_FRM2__c) && obj.Status__c == 'Completed')
                setCancelFRMEAoppIds2.add(obj.Opportunity__c);
            
            if(obj.Cancel_ERP__c && obj.Status__c == 'Completed')
                setCancelERPEAOppIds.add(obj.Opportunity__c);
            
            if(obj.Cancel_ERP1__c && obj.Status__c == 'Completed')
                setCancelERPEAoppIds1.add(obj.Opportunity__c);
            
            if(obj.Cancel_ERP2__c && obj.Status__c == 'Completed')
                setCancelERPEAoppIds2.add(obj.Opportunity__c);
            
            if(obj.Cancel_SCR__c && obj.Status__c == 'Completed')
                setCancelScrOppIds.add(obj.Opportunity__c);
            
            if(obj.Cancel_FRR__c && obj.Status__c == 'Completed')
                setCancelFrrOppIds.add(obj.Opportunity__c);
            
            if(obj.Cancel_Practice_exam__c == true && obj.Status__c == 'Completed')
            {
                setCancelPracticeExamIds.add(obj.Product_Code__c);
                setCancelPracticeExamOppIds.add(obj.Opportunity__c);
            }
            
            if(obj.Re_stocking_fees__c && obj.Status__c == 'Completed' ){
                AddMisc.add(obj.Opportunity__c);
                
            }
            
            if(obj.Cancel_Wiley__c && obj.Status__c == 'Completed'){
                setCancelwiley.add(obj.Opportunity__c);
                if(obj.Wiley_Quantity__c !=null )
                    term = integer.valueof(obj.Wiley_Quantity__c) ;
            }
            
            if(obj.Cancel_Risk_Net__c && obj.Status__c == 'Completed'){
                setCancelRiskDotNet.add(obj.Opportunity__c);
            }
        }
        
        if(!setCancelwiley.isEmpty())
        {
            Set<Id> setAccs1 = new Set<Id>();
            for(Opportunity opp: [select id,accountId from opportunity where id in: setCancelwiley]) {
                // RiskDotNetUtilityClass.CreateUser(opp.id,'Inactive');
                setAccs1.add(opp.accountId);
            }
            if(!updatewileyByRefunds.bRecursive)
                updatewileyByRefunds.updatewileyTerm(setAccs1,term);
        }
        
        if(!setCancelRiskDotNet.isEmpty())
        {
            system.debug('======Risk.net========');
            system.debug('setCancelRiskDotNet========>'+setCancelRiskDotNet);
            Id riskNetId = RecordTypeHelper.GetRecordTypeId('Contract', 'Risk.Net');
            List<Contract> conlst = new List<Contract>();
            for(contract con: [select id,CustomerSignedId from contract where (recordTypeID =:riskNetId) and Opportunity__c in: setCancelRiskDotNet]) {
                system.debug('con======>'+con);
                con.status =  'Canceled';
                conlst.add(con);
            }
            if(!conlst.isempty()){
                update conlst;
            }
        }
        
        if(!setOpps.isEmpty())
        {
            Set<Id> setAccs = new Set<Id>();
            for(Opportunity opp: [select id,accountId from opportunity where id in: setOpps]){
                setAccs.add(opp.accountId);
                if(opp.ChargentSFA__Payment_Status__c == 'Recurring'){
                    opp.ChargentSFA__Payment_Status__c = 'Stopped';
                    oppsToUpdate.add(opp);
                }
            
            }
            if(!updateContractByRefunds.bRecursive)
                updateContractByRefunds.updateContractTerm(setAccs);
            
            if(!oppsToUpdate.isEmpty()){
                update oppsToUpdate;
            }
            
        }
        
        if(!setCancelFFRAoppIds2.isEmpty())
        {
            
        }
        
        if(!setCancelEbooksOppIds.isEmpty())
        {
            List<eBook_Key__c> lstEbooks = new List<eBook_Key__c>();
            for(eBook_Key__c eBook : [select id,Cancelled__c,Opportunity__c from eBook_Key__c where Opportunity__c in: setCancelEbooksOppIds])
            {
                eBook.Cancelled__c = true;
                lstEbooks.add(eBook);
            }
            
            if(!lstEbooks.isEmpty())
                update lstEbooks;
            
        } 
        
        if(!setCancelERPOppIds.isEmpty())
        {
            Set<Id> setAccountIds = new Set<Id>();
            for(Opportunity opp : [select id,accountId from opportunity where id in: setCancelERPOppIds])
            {
                setAccountIds.add(opp.accountId);
            }
            // Id frmRecType = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program');
            Id erpRecType = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program');
            List<Contract> lstContracts = new List<Contract>();
            for(Contract ct : [select id,Status from contract where Status = 'Activated ( Auto-Renew )' and (recordTypeID =:erpRecType) and accountID in: setAccountIds])
            {
                ct.Status = 'Canceled';
                lstContracts.add(ct);
            }
            if(!lstContracts.isEmpty())
                update lstContracts;
        }   
        
        if(!setCancelScrOppIds.isEmpty())
        {
            List<Exam_Attempt__c> lstEA = new List<Exam_Attempt__c>();
            Id scrRecType = RecordTypeHelper.GetRecordTypeId('Contract','SCR Program');
            List<Contract> lstContracts = new List<Contract>();
            for(Contract ct : [select id,Status from contract where Status = 'Activated' and (recordTypeID =:scrRecType) and Opportunity__c in: setCancelScrOppIds])
            {
                ct.Status = 'Canceled';
                lstContracts.add(ct);
            }
            if(!lstContracts.isEmpty())
                update lstContracts;
            
            
            for(Exam_Attempt__c ea : [select id,Cancelled__c,Section__c,opportunity__C from Exam_Attempt__c where opportunity__C in: setCancelScrOppIds and Section__c ='SCR'])
            {
                ea.Cancelled__c = true;
                lstEA.add(ea);
            }
            if(!lstEA.isEmpty())
                update lstEA;
            
            
        } 
        
        
        
        if(!setCancelFrrOppIds.isEmpty())
        {
            List<Exam_Attempt__c> lstEA = new List<Exam_Attempt__c>();
            Id FrrRecType = RecordTypeHelper.GetRecordTypeId('Contract','ICBRR Program');
            List<Contract> lstContracts = new List<Contract>();
            for(Contract ct : [select id,Status from contract where Status = 'Activated ( Auto-Renew )' and (recordTypeID =:FrrRecType) and Opportunity__c in: setCancelScrOppIds])
            {
                ct.Status = 'Canceled';
                lstContracts.add(ct);
            }
            if(!lstContracts.isEmpty())
                update lstContracts;
            
            
            for(Exam_Attempt__c ea : [select id,Cancelled__c,Section__c,opportunity__C from Exam_Attempt__c where opportunity__C in: setCancelScrOppIds and Section__c ='ICBRR'])
            {
                ea.Cancelled__c = true;
                lstEA.add(ea);
            }
            if(!lstEA.isEmpty())
                update lstEA;
            
            
        } 
        
        if(!setCancelFRMOppIds.isEmpty())
        {
            Set<Id> setAccountIds = new Set<Id>();
            for(Opportunity opp : [select id,accountId from opportunity where id in: setCancelFRMOppIds])
            {
                setAccountIds.add(opp.accountId);
            }
            Id frmRecType = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program');
            //Id erpRecType = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program');
            List<Contract> lstContracts = new List<Contract>();
            for(Contract ct : [select id,Status from contract where Status = 'Activated ( Auto-Renew )' and (recordTypeID =:frmRecType) and accountID in: setAccountIds])
            {
                ct.Status = 'Canceled';
                lstContracts.add(ct);
            }
            if(!lstContracts.isEmpty())
                update lstContracts;
        }   
        
        
        if(!setCancelOTSAOppIds.isEmpty())
        {
            // AG 2/18/2021 - Only Cancel OSTA Program related to the Opp refunded
            //Set<Id> setAccountIds = new Set<Id>();
            //for(Opportunity opp : [select id,accountId from opportunity where id in: setCancelOTSAOppIds])
            //{
            //    setAccountIds.add(opp.accountId);
            //}
            Id OTSARecType = RecordTypeHelper.GetRecordTypeId('Contract','OSTA Program');
            List<Contract> lstContracts = new List<Contract>();
            for(Contract ct : [select id,Status from contract where Status = 'Activated ( Auto-Renew )' and (recordTypeID =:OTSARecType) and Opportunity__c in: setCancelOTSAOppIds])
            {
                ct.Status = 'Canceled';
                lstContracts.add(ct);
            }
            if(!lstContracts.isEmpty())
                update lstContracts;
        }   
        
        
        
        
        
        if(!setCancelFFRA.isEmpty())
        {
            Set<Id> setAccountIds = new Set<Id>();
            for(Opportunity opp : [select id,accountId from opportunity where id in: setCancelFFRA])
            {
                setAccountIds.add(opp.accountId);
            }
            Id fbraRecType = RecordTypeHelper.GetRecordTypeId('Contract','FBRA Program');
            //Id erpRecType = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program');
            List<Contract> lstContracts = new List<Contract>();
            for(Contract ct : [select id,Status from contract where Status = 'Activated ( Auto-Renew )' and (recordTypeID =:fbraRecType) and accountID in: setAccountIds])
            {
                ct.Status = 'Canceled';
                lstContracts.add(ct);
                opportunityTriggerUtils.cancelFFRA(setCancelFFRAoppIds2);
            }
            if(!lstContracts.isEmpty())
                update lstContracts;
        }   
        
        
        if(!setCancelFRMEAoppIds1.isEmpty())
        {
            Set<Id> setoppids = new Set<Id>();
            List<Exam_Attempt__c> lstEA = new List<Exam_Attempt__c>();
            
            for(Opportunity opp : [select id,accountId from opportunity where id in: setCancelFRMEAoppIds1])
            {
                setoppids.add(opp.Id);
            }
            
            for(Exam_Attempt__c ea : [select id,Cancelled__c,Section__c,opportunity__C from Exam_Attempt__c where opportunity__C in: setoppids and Section__c ='FRM Part 1'])
            {
                ea.Cancelled__c = true;
                lstEA.add(ea);
            }
            if(!lstEA.isEmpty())
                update lstEA;
            
            // 01/29/2019 Xiang - Move [US-12115] logic out of Registration transaction (Previously in Trigger)
            if(!setoppids.isEmpty()) {
                // If FRM Part 1 is cancelled, then mark Opportunity Is_Exam_Cancelled__c true
                List<Opportunity> oppsUpdt = new List<Opportunity>();
                for(Id oppId : setoppids) {
                    oppsUpdt.add(new Opportunity(Id = oppId, Is_Exam_Cancelled__c = true));
                }
                update oppsUpdt;
            }
        }   
        
        if(!setCancelFRMEAoppIds2.isEmpty())
        {
            Set<Id> setoppids = new Set<Id>();
            List<Exam_Attempt__c> lstEA = new List<Exam_Attempt__c>();
            Set<Id> targetOppIds = new Set<Id>();
            
            for(Opportunity opp : [select id,accountId from opportunity where id in: setCancelFRMEAoppIds2])
            {
                setoppids.add(opp.Id);
            }
            
            for(Exam_Attempt__c ea : [select id, Cancelled__c, Section__c ,opportunity__C, Other_Exam_Registrations__c from Exam_Attempt__c where opportunity__C in: setoppids and Section__c ='FRM Part 2'])
            {
                ea.Cancelled__c = true;
                lstEA.add(ea);
                
                // 01/29/2019 Xiang - Move [US-12115] logic out of Registration transaction (Previously in Trigger)
                if(ea.Other_Exam_Registrations__c == NULL) {
                    targetOppIds.add(ea.Opportunity__c);
                }
            }
            if(!lstEA.isEmpty())
                update lstEA;
            
            // If FRM Part 2 is cancelled and it is stand alone, mark Opportunity Is_Exam_Cancelled__c true
            if(!targetOppIds.isEmpty()) {
                List<Opportunity> oppsUpdt = new List<Opportunity>();
                for(Id oppId : targetOppIds) {
                    oppsUpdt.add(new Opportunity(Id = oppId, Is_Exam_Cancelled__c = true));
                }
                update oppsUpdt;
            }
        }   
        
        
        if(!setCancelERPEAoppIds1.isEmpty())
        {
            Set<Id> setoppids = new Set<Id>();
            List<Exam_Attempt__c> lstEA = new List<Exam_Attempt__c>();
            
            for(Opportunity opp : [select id,accountId from opportunity where id in: setCancelERPEAoppIds1])
            {
                setoppids.add(opp.Id);
            }
            
            for(Exam_Attempt__c ea : [select id,Cancelled__c,Section__c,opportunity__C from Exam_Attempt__c where opportunity__C in: setoppids and Section__c ='ERP Exam Part I'])
            {
                ea.Cancelled__c = true;
                lstEA.add(ea);
            }
            if(!lstEA.isEmpty())
                update lstEA;
            
            // 01/29/2019 Xiang - Move [US-12115] logic out of Registration transaction (Previously in Trigger)
            if(!setoppids.isEmpty()) {
                // If ERP Part 1 is cancelled, then mark Opportunity Is_Exam_Cancelled__c true
                List<Opportunity> oppsUpdt = new List<Opportunity>();
                for(Id oppId : setoppids) {
                    oppsUpdt.add(new Opportunity(Id = oppId, Is_Exam_Cancelled__c = true));
                }
                update oppsUpdt;
            }
        }   
        
        if(!setCancelERPEAoppIds2.isEmpty())
        {
            Set<Id> setoppids = new Set<Id>();
            List<Exam_Attempt__c> lstEA = new List<Exam_Attempt__c>();
            Set<Id> targetOppIds = new Set<Id>();
            
            for(Opportunity opp : [select id,accountId from opportunity where id in: setCancelERPEAoppIds2])
            {
                setoppids.add(opp.Id);
            }
            
            for(Exam_Attempt__c ea : [select id,Cancelled__c, Section__c ,opportunity__C, Other_Exam_Registrations__c from Exam_Attempt__c where opportunity__C in: setoppids and Section__c ='ERP Exam Part II'])
            {
                ea.Cancelled__c = true;
                lstEA.add(ea);
                
                // 01/29/2019 Xiang - Move [US-12115] logic out of Registration transaction (Previously in Trigger)
                if(ea.Other_Exam_Registrations__c == NULL) {
                    targetOppIds.add(ea.Opportunity__c);
                }
            }
            if(!lstEA.isEmpty())
                update lstEA;
            
            // If ERP Part 2 is cancelled and it is stand alone, mark Opportunity Is_Exam_Cancelled__c true
            if(!targetOppIds.isEmpty()) {
                List<Opportunity> oppsUpdt = new List<Opportunity>();
                for(Id oppId : targetOppIds) {
                    oppsUpdt.add(new Opportunity(Id = oppId, Is_Exam_Cancelled__c = true));
                }
                update oppsUpdt;
            }
        }   
        
        if(!AddMisc.isEmpty())
        {
            
            list<OpportunityLineItem> opl = new list<OpportunityLineItem>();
            Set<Id> setoppids = new Set<Id>();
            List<Exam_Attempt__c> lstEA = new List<Exam_Attempt__c>();
            Integer iRecCount = 0;
            
            for(Opportunity opp : [select id,accountId, Stop_Recurring__c from opportunity where id in: AddMisc and Stop_Recurring__c =false])
            {
                setoppids.add(opp.Id);
            }
            for(Opportunity opp1 : [select id from opportunity where id in: setoppids ])
            {
                integer pr = (integer)[select count(id) r from Product_Refunds__c where Opportunity__c in :setoppids and Re_stocking_fees__c =true] [0].get('r');
                //integer ff = pr[0].get('r');
                PriceBookEntry PricebookEntryId = [select unitprice,productcode,Product2.GL_Code__c from PriceBookEntry where Pricebook2.IsActive = true and productcode ='MISC' and isActive =: true];
                OpportunityLineItem oppLineItem = new OpportunityLineItem();
                oppLineItem.OpportunityId = opp1.id;
                oppLineItem.PricebookEntryId = PricebookEntryId.Id;
                oppLineItem.Quantity = 1;
                oppLineItem.Description ='Restocking-fees';
                oppLineItem.UnitPrice = 25.00*pr;   
                opplineitem.Stop_Recurring__c =true;
                //insert oppLineItem;
                //lstEA.add(ea);
                opl.add(oppLineItem);
            }
            if(!opl.isEmpty())
                insert opl;
        }   
        
        
        if(!setCancelERPEAOppIds.isEmpty())
        {
            Set<Id> setoppids = new Set<Id>();
            List<Exam_Attempt__c> lstEA = new List<Exam_Attempt__c>();
            for(Opportunity opp : [select id,accountId from opportunity where id in: setCancelERPEAOppIds])
            {
                setoppids.add(opp.id);
            }
            
            for(Exam_Attempt__c ea : [select id,Cancelled__c,opportunity__C from Exam_Attempt__c where opportunity__C in: setoppids])
            {
                ea.Cancelled__c = true;
                lstEA.add(ea);
            }
            if(!lstEA.isEmpty())
                update lstEA;
        } 
        
        // Event Refunds
        // Assumes to cancel all Registrations realted to the Opportunity
        // Does not support two seperate events on 1 Opp
        Set<Id> setEventIds = new Set<Id>();
        List<Event_Registration__c> setAllMatchingEventRegistrations = new List<Event_Registration__c>();
        for (Event_Registration__c er: [select id, Event__c, Status__c, Opportunity__c from Event_Registration__c where Opportunity__c in :setCancelOpportunitiesForEventRegistration]) {        
            er.Status__c  = 'Cancelled';
            setAllMatchingEventRegistrations.add(er);
        }
        if(!setAllMatchingEventRegistrations.isEmpty())
            update setAllMatchingEventRegistrations;
        
        
        if(!setCancelPracticeExamIds.isEmpty()){
            system.debug('update===>');
            List<OpportunityLineItem> oppLineItemslst = new List<OpportunityLineItem>();
            for(OpportunityLineItem  oppLine : [select id from OpportunityLineItem where ProductCode IN:setCancelPracticeExamIds and OpportunityId IN:setCancelPracticeExamOppIds]){
                oppLine.Cancel_Refunded__c = true;
                oppLineItemslst.add(oppLine);
                system.debug(' Cancel_Refunded__c =====>');
            }
            if(!oppLineItemslst.isEmpty()){
                update oppLineItemslst;
            }
        }
    }      
    
}