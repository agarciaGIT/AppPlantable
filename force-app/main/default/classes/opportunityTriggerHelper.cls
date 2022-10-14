public class opportunityTriggerHelper {
    
    public static Boolean isFirstRun = true;
    
    public static void opportunityTriggerHelper(List<opportunity> setOpps) {
        
        System.debug('setOpps: ' + setOpps);
        
        isFirstRun = false;
        
        boolean NoEbookcallout = false;
        
        Opportunity oppForContract = new Opportunity();
        Opportunity oppForRenewContract = new Opportunity();
         
        Set<String> examAttemptMember = new Set<String> ();
        Set < String > SiteCode = new Set < String > ();
        Set < String > OSTAoppRefund = new Set < String > ();
         set<id> AtaPsiInteration = new set<id>();
        Set < ID > setExamAttempts = new Set < Id > ();
        Set < ID > setUnDeferredExamAttempts = new Set < Id > ();
        Set < ID > setLateDeferredExamAttempts = new Set < Id > ();
        Set < ID > setLateUnDeferredExamAttempts = new Set < Id > ();
        Set < Id > setaccIdsforContracts = new Set < Id > ();
        Set < Id > setAcctoUpdateContracts = new Set < Id > ();
        Set < ID > setERPAccounts = new Set < ID > ();
        Set < ID > setFRMAccounts = new Set < ID > ();
        Set < ID > setAllAccounts = new Set < ID > ();
        Set < Id > setAutoRenewAccounts = new Set < Id > ();
        
        Set < Id > setRenewOpps = new Set < Id > ();
        Set < Id > setAccountIds = new Set < Id > ();
        Set < Id > setAccts = new Set < Id > ();
        Set < ID > setRegisterExamAttempts = new Set < Id > ();
        Set < Id > setEventOpps = new Set < Id > ();
        Set < Id > setOppGarpDirectory = new Set < Id > ();
        //Set < Id > setOppON24Hub = new Set < Id > ();
        
        
        Map < Id, Opportunity > mapOppForContracts = new Map < Id, Opportunity > ();
        Map < Id, Set < String >> mapProdCodesWithAccount = new Map < Id, Set < String >> ();
        Map < Id, Set < String >> mapProductCodes = new Map < Id, Set < String >> ();
        Map < Id, Opportunity > mapUpdateShipServieOpps = new Map < Id, Opportunity > ();
        Map < Id, Opportunity > eBookFRM1ProvisionOpps = new Map < Id, Opportunity > ();    
        Map < Id, Opportunity > eBookFRM2ProvisionOpps = new Map < Id, Opportunity > ();    
        Map < Id, Opportunity > eBookERP1ProvisionOpps = new Map < Id, Opportunity > ();    
        Map < Id, Opportunity > eBookERP2ProvisionOpps = new Map < Id, Opportunity > ();    

        Map < Id, Opportunity > eBookSCRProvisionOpps = new Map < Id, Opportunity > ();    

        Map < Id, Opportunity > eBookFRRProvisionOpps = new Map < Id, Opportunity > ();        
        Map < Id, Opportunity > wileyOpps = new Map < Id, Opportunity > ();
        Map < Id, Opportunity > riskNetOpps = new Map < Id, Opportunity > ();
        Map < Id, Opportunity > ffrOpps = new Map < Id, Opportunity > ();
        Map < Id, Opportunity >frrOpps = new Map < Id, Opportunity > ();
        Map < Id, Opportunity > ffraOpps = new Map < Id, Opportunity > ();
        Map < Id, Opportunity > chaptMeetingRegOpps = new Map < Id, Opportunity > ();
        Map < String, Product2 > mapProducts = new Map < String, Product2 > ();
        Map < Id, Opportunity > bulkOpps = new Map < Id, Opportunity > ();    
        Map < Id, Id > mapLineItems = new Map < Id, Id > ();
        Map < Id, Boolean > maphasFRM1EBook = new Map < Id, Boolean > ();
        Map < Id, Boolean > maphasFRM2EBook = new Map < Id, Boolean > ();
        Map < Id, Boolean > maphasERP1EBook = new Map < Id, Boolean > ();
        Map < Id, Boolean > maphasERP2EBook = new Map < Id, Boolean > ();

        Map < Id, Boolean > maphasSCREBook = new Map < Id, Boolean > ();

        Map < Id, Boolean > maphasFRREBook = new Map < Id, Boolean > ();
        Map < Id, OpportunityLineItem > maphasWiley = new Map < Id, OpportunityLineItem > ();
        Map < Id, OpportunityLineItem > mapHasRiskNet = new Map < Id, OpportunityLineItem > ();
        Map < Id, Boolean > maphasFFR = new Map < Id, Boolean > ();

        Map < Id, Boolean > maphasFFRA = new Map < Id, Boolean > ();
        Map < Id, Boolean > maphasChaptMeetingReg = new Map < Id, Boolean > ();
        
        Map < Id, Boolean > maphasExamRegMod = new Map < Id, Boolean > ();
        
        Map<Id, OpportunityLineItem> chinaDataFeesMapByOpportunityId = new Map<Id, OpportunityLineItem>();
        Map<Id, OpportunityLineItem> chinaLocationFeesMapByOpportunityId = new Map<Id, OpportunityLineItem>();
        Map<Id, OpportunityLineItem> retabulationRequestFeesMapByOpportunityId = new Map<Id, OpportunityLineItem>();
        
        Set<Id> scholarshipApplicationIds = new Set<Id>();
        Set<Id> retabulationRequestExamRegistrationIds = new Set<Id>();
        Set<Id> setExamRegMods = new Set<Id>();
        
        // Create Map for Orders to close out Rate Offers
        MAP<String,String> mapRateOrders = new MAP<String,String>();
        
        Set<String> productCodes = new Set<String>();
        Set<String> glCodes = new Set<String>();
        Set<String> emailAddresses = new Set<String>();
        Set<String> productKeys = new Set<String>();
        
        for (OpportunityLineItem oppLine: [
            SELECT Id, Name, ProductCode,Product2.GL_Code__c,Exam_Registration__r.Member__c, Product2Id, Opportunity.StageName, Opportunity.ChargentSFA__Billing_Email__c, Opportunity.OSTA_Exam_Site_Code__c, Opportunity.OSTA_Opportunity_Refund__c, Opportunity.Exam_Registration_Modification__c, Product2.Family, Event__c, Exam_Site__r.Id, Exam_Registration__c, OpportunityId, UnitPrice, Quantity, Opportunity.AccountId,Opportunity.GARP_Member_ID__c, Scholarship_Application__c
            FROM OpportunityLineItem 
            WHERE OpportunityId in :setOpps
        ]) { 
            
            Product2 prod = mapProducts.get(oppLine.Product2Id);
            
            system.debug('mapProducts:' + mapProducts);
            system.debug('oppLine:' + oppLine);
            system.debug('setOpps:' + setOpps);
            
            if(oppLine.Opportunity.StageName == 'Closed' && oppLine.Opportunity.ChargentSFA__Billing_Email__c != NULL) {
                productCodes.add(oppLine.ProductCode);
                glCodes.add(oppLine.Product2.GL_Code__c);
                emailAddresses.add(oppLine.Opportunity.ChargentSFA__Billing_Email__c.tolowercase());
                productKeys.add(oppLine.ProductCode + ':' + oppLine.Product2.GL_Code__c + ':' + oppLine.Opportunity.ChargentSFA__Billing_Email__c.tolowercase());
            }
            
            if (oppLine.ProductCode == 'FRM1' && oppLine.UnitPrice == 250) {
                Id frmRecordType = RecordTypeHelper.GetRecordTypeId('Contract', 'FRM Program');
                mapLineItems.put(oppLine.Opportunity.accountID, frmRecordType);
            } else if (oppLine.ProductCode == 'ENC' && oppLine.UnitPrice == 250) {
                Id erpRecordType = RecordTypeHelper.GetRecordTypeId('Contract', 'ERP Program');
                mapLineItems.put(oppLine.Opportunity.accountID, erpRecordType);
            } else if (oppLine.ProductCode == 'FRM1X') {
                maphasFRM1EBook.put(oppLine.OpportunityId, true);
            } else if (oppLine.ProductCode == 'FRM2X') {
                maphasFRM2EBook.put(oppLine.OpportunityId, true);
            } else if (oppLine.ProductCode == 'ENC1X') {
                maphasERP1EBook.put(oppLine.OpportunityId, true);
            } else if (oppLine.ProductCode == 'ENC2X') {
                maphasERP2EBook.put(oppLine.OpportunityId, true);
            } else if (oppLine.ProductCode == 'SCRX') {
                maphasSCREBook.put(oppLine.OpportunityId, true);                
            } else if (oppLine.ProductCode == 'CBRNM' || oppLine.ProductCode == 'CBR' || oppLine.ProductCode =='CBRX') {
                maphasFRREBook.put(oppLine.OpportunityId, true);
                if(oppLine.ProductCode =='CBRX'){
                NoEbookcallout = true;
                }
            } else if (oppLine.ProductCode == 'CBR2A') {
                Id FrrRecordType = RecordTypeHelper.GetRecordTypeId('Contract', 'ICBRR Program');
                 mapLineItems.put(oppLine.Opportunity.accountID, FrrRecordType);
            } else if (oppLine.ProductCode == 'MEMW') {
                maphasWiley.put(oppLine.OpportunityId, oppLine);
            } else if (oppLine.ProductCode == 'MEMR') {
                mapHasRiskNet.put(oppLine.OpportunityId, oppLine);
            } else if (oppLine.ProductCode == 'FCBR' || oppLine.ProductCode == 'FBRNM') {
                maphasFFR.put(oppLine.OpportunityId, true);
            } else if (oppLine.ProductCode == 'FBRA') {
                maphasFFRA.put(oppLine.OpportunityId, true);
            } else if (oppLine.Product2.family != null && oppLine.Product2.family == 'Events') {
                setEventOpps.add(oppLine.OpportunityId);
            } else if(oppLine.ProductCode == 'CHMT1') {
                maphasChaptMeetingReg.put(oppLine.OpportunityId, true);
            } else if(oppLine.ProductCode == 'CHLF') {          
                //chinaLocationFeesMapByOpportunityId.put(oppLine.OpportunityId, oppLine);
            } else if(oppLine.ProductCode == 'CHNDF' && oppLine.Opportunity.Exam_Registration_Modification__c == NULL) {          
                chinaDataFeesMapByOpportunityId.put(oppLine.OpportunityId, oppLine);
            } else if(oppLine.ProductCode == 'FRMRET1' || oppLine.ProductCode == 'FRMRET2'){
                retabulationRequestFeesMapByOpportunityId.put(oppLine.OpportunityId, oppLine);
            } else if(oppLine.ProductCode == 'ERPRET1' || oppLine.ProductCode == 'ERPRET2'){
                retabulationRequestFeesMapByOpportunityId.put(oppLine.OpportunityId, oppLine);
            } else if(oppLine.ProductCode == 'SAFRM1' || oppLine.ProductCode == 'SAFRM2'){
                scholarshipApplicationIds.add(oppLine.Scholarship_Application__c);
            }else if(oppLine.ProductCode == 'SAERP1' || oppLine.ProductCode == 'SAERP2'){
                scholarshipApplicationIds.add(oppLine.Scholarship_Application__c);
            }
           // this is for the duplicate certificate shipping.
            else if(oppLine.ProductCode == 'DCERTFRM'){
                  opportunityTriggerUtils.CreateDuplicateShipping(oppLine.Opportunity.accountID,oppLine.Opportunity.GARP_Member_ID__c,'FRM');
            }
            
            else if(oppLine.ProductCode == 'DCERTENC'){
                  opportunityTriggerUtils.CreateDuplicateShipping(oppLine.Opportunity.accountID,oppLine.Opportunity.GARP_Member_ID__c,'ERP');
            } else if(oppLine.ProductCode == 'MEMI' || oppLine.ProductCode == 'MEMC' || oppLine.ProductCode == 'MEMF') {
                
                  setOppGarpDirectory.add(oppLine.Opportunity.AccountId);
            }
            /*if(oppLine.ProductCode == 'MEMI' || oppLine.ProductCode == 'MEMC') {
                setOppON24Hub.add(oppLine.Opportunity.AccountId);
            }*/
            
            if (mapProductCodes.containsKey(oppLine.OpportunityId)){
                mapProductCodes.get(oppLine.OpportunityId).add(oppLine.ProductCode);
            }else{
                mapProductCodes.put(oppLine.OpportunityId, new Set < String > {oppLine.ProductCode});
            }
            
            if (mapProdCodesWithAccount.containsKey(oppLine.Opportunity.accountID)){
                mapProdCodesWithAccount.get(oppLine.Opportunity.accountID).add(oppLine.ProductCode);
            }else{
                mapProdCodesWithAccount.put(oppLine.Opportunity.accountID, new Set <String>{oppLine.ProductCode});
            }
            
            //if(oppLine.Opportunity.OSTA_Exam_Site_Code__c != null){
            //    SiteCode.add(oppLine.Opportunity.OSTA_Exam_Site_Code__c);
            //}
            if(oppLine.Exam_Registration__r.Member__c != null){
                examAttemptMember.add(oppLine.Exam_Registration__r.Member__c);
            }
            //if(oppLine.Opportunity.OSTA_Opportunity_Refund__c != null){
            //    OSTAoppRefund.add(oppLine.Opportunity.OSTA_Opportunity_Refund__c);
            //}
        }

        System.debug('productCodes:' + productCodes);
        System.debug('glCodes:' + glCodes);
        System.debug('emailAddresses:' + emailAddresses);
        System.debug('productKeys:' + productKeys);
        
        if(productCodes.size() > 0) {
            opportunityTriggerUtils.closeRateOffers(productCodes, glCodes, emailAddresses, productKeys);
        }
        
        if(setOppGarpDirectory.size() != NULL){
            opportunityTriggerUtils.updateGarpDirectoryOptIn(setOppGarpDirectory);
        }

        /*if(setOppON24Hub.size() != NULL){
            opportunityTriggerUtils.updateGarpON24HubOptIn(setOppON24Hub);
        }*/
        
        //if(!OSTAoppRefund.isEmpty()){
        //    opportunityTriggerUtils.createProductRefunds(OSTAoppRefund);
        //}
        if(!SiteCode.isEmpty() && !examAttemptMember.isEmpty()){
            opportunityTriggerUtils.getExamSitedata(SiteCode,examAttemptMember);
        }
        
        
        System.debug('chinaDataFeesMapByOpportunityId >> ' + chinaDataFeesMapByOpportunityId);
            
        System.debug('scholarshipApplicationIds >> ' + scholarshipApplicationIds);
        system.debug('maphasFRME1Book:' + maphasFRM1EBook);
        system.debug('maphasFRME2Book:' + maphasFRM2EBook);
        system.debug('maphasERPE1Book:' + maphasERP1EBook);
        system.debug('maphasERPE2Book:' + maphasERP2EBook);
        
        system.debug('maphasSCREBook:' + maphasSCREBook);
        
        system.debug('maphasFRREBook:' + maphasFRREBook);
        system.debug('setEventOpps:' + setEventOpps);
        
        for (Opportunity opp: [
            SELECT Id, Exam_Registration_Modification__c, Has_Books__c, Shipping_E_mail__c,Late_Undeferred_EA_Id__c, Cross_Check__c,GARP_Member_ID__c, Deferred_Exam_Registration__c, Wiley__c, EA_Id__c, Auto_Renew__c, Eligible_for_Membership_Extension__c, Renew_Membership__c, Inst_Sale_Emails__c, Institutional_Sale_Stage__c, Institutional_Sale__c, RecordTypeId, Shipping_Country__c, Shipping_Street__c, Undefred_EA_Id__c,Late_EA_Id__c, AccountId, StageName 
            FROM Opportunity 
            WHERE Id = :setOpps
        ]) {
            
            system.debug('setOpps:' + opp);
            
            // Exam Reg Modifications
            if(opp.stagename == 'Closed'  && opp.Exam_Registration_Modification__c != NULL) {
                setExamRegMods.add(opp.Exam_Registration_Modification__c);
            }
                
            // This is logic for the when the user defers the exam and the values in the correspondign fields are placed from the web.         
            if (opp.stagename == 'Closed'  && opp.EA_Id__c != null && (mapProductCodes.get(opp.Id).Contains('ENC') || mapProductCodes.get(opp.Id).Contains('FRM1'))) {
                setExamAttempts.add(opp.EA_Id__c);
            }
            
            // This is logic for the when the user un-defers the exam and the values in the correspondign fields are placed from the web.       
            if (opp.stagename == 'Closed' && opp.Undefred_EA_Id__c != null && (mapProductCodes.get(opp.Id).Contains('ENC') || mapProductCodes.get(opp.Id).Contains('FRM1'))) {
                //setUnDeferredExamAttempts.add(opp.Undefred_EA_Id__c);
            }
            
            if (opp.stagename == 'Closed' && opp.Late_Undeferred_EA_Id__c != null && (mapProductCodes.get(opp.Id).Contains('ENC') || mapProductCodes.get(opp.Id).Contains('FRM1'))) {
                //setLateUnDeferredExamAttempts.add(opp.Late_Undeferred_EA_Id__c);
            }
            
            // This is logic for the when the customer service uses the late deferral the exam and the values in the correspondign fields are placed from the web.                      
            if (opp.stagename == 'Closed'  && opp.Late_EA_Id__c != null && (mapProductCodes.get(opp.Id).Contains('ENC') || mapProductCodes.get(opp.Id).Contains('FRM1'))) {
                //setLateDeferredExamAttempts.add(opp.Late_EA_Id__c);
            }
            
            if (opp.stagename == 'Closed' ) {
                
                system.debug('opp: ' + opp);
                
                Set < String > rprods = mapProductCodes.get(opp.Id);
                system.debug('rprods: ' + rprods);
                if(rprods != null){
                    
                    if(
                        (
                            rprods.Contains('ENC1E') || 
                            rprods.Contains('ENC1S') || 
                            rprods.Contains('ENC1L')
                        ) ||
                        (
                            rprods.Contains('ENC2E') || 
                            rprods.Contains('ENC2S') || 
                            rprods.Contains('ENC2L')
                        ) ||
                        (
                            rprods.Contains('FRM1E') || 
                            rprods.Contains('FRM1S') || 
                            rprods.Contains('FRM1L')
                        ) ||
                        (
                            rprods.Contains('FRM2E') || 
                            rprods.Contains('FRM2S') || 
                            rprods.Contains('FRM2L')
                        )
                    ){
                        setRegisterExamAttempts.add(opp.Deferred_Exam_Registration__c);
                        AtaPsiInteration.add(opp.id);
                    }
                    
                }
                
            }
            
            if ( opp.Has_Books__c == true) {
                system.debug('opp.Has_Books__c:' + opp.Has_Books__c);                                
                String[] strAddress  = opp.Shipping_Street__c.split('\n');
                
                system.debug('strAddress:' + strAddress);
                if (strAddress != null) {
                    opp.Shipping_Address1__c = (strAddress.size() > 0) ? strAddress[0] : null;
                    opp.Shipping_Address2__c = (strAddress.size() > 1) ? strAddress[1] : null;
                    opp.Shipping_Address3__c = (strAddress.size() > 2) ? strAddress[2] : null;         
                }
            }
            
            CountryCodes__c countryCodes = CountryCodes__c.getValues(opp.Shipping_Country__c);
            opp.Country_Code_for_UPS__c = countryCodes != null ? countryCodes.Country_Code__c : '';
            
            mapUpdateShipServieOpps.put(opp.Id, opp); 
            
            // A blank opportunity is created when the user chooses to do the recurring for the future and his contract end date is greater so we have to use the token,logic for what we do with that opportuntiy.   
            if ((opp.stagename == 'Recurring Intent')&& opp.Auto_Renew__c && trigger.isafter) {
                setAccts.add(opp.accountId);
            }
            
            //Change Exam Registration Location after the CC payment closed
            if (opp.StageName == 'Closed'  && !chinaLocationFeesMapByOpportunityId.values().isEmpty()){  
                if(chinaLocationFeesMapByOpportunityId.containsKey(opp.Id)){
                    OpportunityLineItem chinaLocationFee = chinaLocationFeesMapByOpportunityId.get(opp.Id);
                    if(chinaLocationFee.Exam_Registration__c != null && chinaLocationFee.Exam_Site__c != null){
                        ExamManagementController.switchExamSites(chinaLocationFee.Exam_Registration__c, chinaLocationFee.Exam_Site__c);
                    }
                }
            }
            
            Contract ostaProgram = null;
            
            //Create OSTA Program Contract on Opportunity StageName set to 'Closed'
            if (opp.StageName == 'Closed'  && !chinaDataFeesMapByOpportunityId.values().isEmpty()){  
                
                system.debug('OSTA Program opp.StageName: ' + opp);
                
                if(chinaDataFeesMapByOpportunityId.containsKey(opp.Id)){
                    
                    system.debug('OSTA Program opp.StageName Contains: ' + opp);
                    
                    OpportunityLineItem chinaDataFee = chinaDataFeesMapByOpportunityId.get(opp.Id);
                    
                    system.debug('chinaDataFee: ' + chinaDataFee);
                    
                    ostaProgram = ExamManagementController.createOstaProgram(opp, chinaDataFee);
                }
            }
            
            if(ostaProgram == null){
                ostaProgram = ExamManagementController.fetchOstaProgram(opp.AccountId);
            }
            
            //Create OSTA Exam Registration Data record on Opportunity StageName set to 'Closed' 
            if (opp.StageName == 'Closed'  && ostaProgram != null){                      
                ExamManagementController.createOrUpdateOstaExamRegistrationData(ostaProgram);
            }
            
            if(retabulationRequestFeesMapByOpportunityId.containsKey(opp.Id)){
                
                OpportunityLineItem oli = retabulationRequestFeesMapByOpportunityId.get(opp.Id);
                
                Id examRegistrationId = oli.Exam_Registration__c;
                
                if(examRegistrationId != null){                    
                    retabulationRequestExamRegistrationIds.add(examRegistrationId);                        
                }
                
            }
            
            Boolean hasEBook = maphasFRM1EBook.get(opp.Id);
            if (opp.StageName == 'Closed'  && hasEBook == True) {
                eBookFRM1ProvisionOpps.put(opp.Id, opp);
                system.debug('eBookFRM1ProvisionOpps:' + opp);
                system.debug('hasEBook:' + hasEBook);
            }
            
            hasEBook = maphasFRM2EBook.get(opp.Id);
            if (opp.StageName == 'Closed'  && hasEBook == True) {
                eBookFRM2ProvisionOpps.put(opp.Id, opp);
                system.debug('eBookFRM2ProvisionOpps:' + opp);
            }
            
            hasEBook = maphasERP1EBook.get(opp.Id);
            if (opp.StageName == 'Closed'  && hasEBook == True) {
                eBookERP1ProvisionOpps.put(opp.Id, opp);
                system.debug('eBookERP1ProvisionOpps:' + opp);
            }
            
            hasEBook = maphasERP2EBook.get(opp.Id);
            if (opp.StageName == 'Closed'  && hasEBook == True) {
                eBookERP2ProvisionOpps.put(opp.Id, opp);
                system.debug('eBookERP2ProvisionOpps:' + opp);
            }
            
            hasEBook = maphasSCREBook.get(opp.Id);
            if (opp.StageName == 'Closed'  && hasEBook == True) {
                eBookSCRProvisionOpps.put(opp.Id, opp);
                system.debug('eBookSCRProvisionOpps:' + opp);
                system.debug('hasEBook:' + hasEBook);
            }
            
            
            hasEBook = maphasFRREBook.get(opp.Id);
            if (opp.StageName == 'Closed'  && hasEBook == True) {
                eBookFRRProvisionOpps.put(opp.Id, opp);
                system.debug('eBookFRRProvisionOpps:' + opp);
            }
            
            OpportunityLineItem hasWiley = maphasWiley.get(opp.Id);
            if (opp.StageName == 'Closed' && hasWiley != NULL && trigger.isafter) {
                wileyOpps.put(opp.Id, opp);
                system.debug('wileyOpps:' + opp);
            }            
         
            OpportunityLineItem hasRiskNet = mapHasRiskNet.get(opp.Id);
            if (opp.StageName == 'Closed' && hasRiskNet != null && trigger.isAfter) {
                riskNetOpps.put(opp.Id, opp);
                system.debug('riskNetOpps:' + opp);
            }   

            Id manualRecId = RecordTypeHelper.GetRecordTypeId('Opportunity','Manual');
            if (opp.stagename == 'Closed' && Opp.RecordTypeID == manualRecId && opp.Institutional_Sale__c == True && opp.Institutional_Sale_Stage__c == 'Approved' && opp.Inst_Sale_Emails__c != null) {
                bulkOpps.put(opp.Id, opp);                
            }
            
            if (opp.StageName == 'Closed' && (opp.Renew_Membership__c || opp.Eligible_for_Membership_Extension__c || opp.Auto_Renew__c || opp.Wiley__c)) {
                setRenewOpps.add(opp.Id);
                setAccountIds.add(opp.accountId);
                oppForRenewContract = opp;
            }
            
            Boolean hasFFR = maphasFFR.get(opp.Id);
            if (opp.StageName == 'Closed' && hasFFR != NULL && trigger.isafter) {
                ffrOpps.put(opp.Id, opp);
            }
            
            Boolean hasFFRA = maphasFFRA.get(opp.Id);
            if (opp.StageName == 'Closed' && hasFFRA != NULL && trigger.isafter) {
                ffraOpps.put(opp.Id, opp);
            }
            
            Boolean hasChaptMeetReg = maphasChaptMeetingReg.get(opp.Id);
            if (opp.StageName == 'Closed' && hasChaptMeetReg != NULL && trigger.isafter) {
                chaptMeetingRegOpps.put(opp.Id, opp);
            }
            
        }
        
        
        if(setExamRegMods.size() > 0) {
            ExamManagementController.processExamRegMods(setExamRegMods,false,false);
        }
        
        if (!opportunityTriggerUtils.bUpdateEA && (!setExamAttempts.isEmpty() || !setUnDeferredExamAttempts.isEmpty() || !setLateDeferredExamAttempts.isEmpty() || !setLateUnDeferredExamAttempts.isEmpty())) {
            opportunityTriggerUtils.updateExamAttempts(setExamAttempts, setUnDeferredExamAttempts, setLateDeferredExamAttempts,setLateUnDeferredExamAttempts);
        } else if(setRegisterExamAttempts.size() > 0) {
            opportunityTriggerUtils.updateRegisterExamAttempts(setRegisterExamAttempts);
        }
        
        if (mapLineItems.size() > 0) {
            
            Id frmRecType = RecordTypeHelper.GetRecordTypeId('Contract', 'FRM Program');
            Id erpRecType = RecordTypeHelper.GetRecordTypeId('Contract', 'ERP Program');
            Id FrrRecType = RecordTypeHelper.GetRecordTypeId('Contract', 'ICBRR Program');
            
            List < Contract > lstCons = new List < Contract > ();
            for (Contract objCon: [
                SELECT id, name, Enrollment_paid_for_2009__c, accountId, RecordType.Name 
                FROM Contract 
                WHERE 
                AccountId IN :mapLineItems.keySet() AND
                (
                    Status = :'Activated' OR 
                    Status = :'Activated ( Auto-Renew )'
                ) AND
                (
                    RecordTypeId = :frmRecType OR 
                    RecordTypeId = :erpRecType OR
                    RecordTypeId = :FrrRecType
                )
            ]){
                Id idVal = mapLineItems.get(objCon.accountId);         
                
                if (objCon.RecordTypeId == idVal && objCon.RecordTypeId ==FrrRecType){
                    objCon.Second_Attempt_FRR__c = true;
                }

                if (objCon.RecordTypeId == idVal && objCon.RecordTypeId !=FrrRecType){
                    objCon.Enrollment_paid_for_2009__c = true;
                }
                lstCons.add(objCon);
            }
            
            if (!lstCons.isEmpty()){
                UPDATE lstCons;
            }
            
        }
        
        // For sending call outs to ATA/PSI
        system.debug('AtaPsiInteration.size()===========>'+AtaPsiInteration.size());
        system.debug('Trigger.isAfter========>'+Trigger.isAfter);
        system.debug('opportunityTriggerUtils.bIsRecursiveForRenewOpps-------->'+opportunityTriggerUtils.bIsRecursiveForRenewOpps);
        if (AtaPsiInteration.size() > 0 && !opportunityTriggerUtils.bIsRecursiveForRenewOpps) {
            System.debug('AtaPsiInteration: ' + setRenewOpps);
            opportunityTriggerUtils.UpdateATAPsi(AtaPsiInteration);
        }
        // passing the above lists to the corresponding methods
        if (setRenewOpps.size() > 0 && Trigger.isAfter && !opportunityTriggerUtils.bIsRecursiveForRenewOpps) {
            System.debug('updateRenewContracts: ' + setRenewOpps);
            opportunityTriggerUtils.updateRenewContracts(setRenewOpps, setAccountIds, mapProdCodesWithAccount, oppForRenewContract);
        }
        
        // passing the above lists to the corresponding methods
        if (mapUpdateShipServieOpps.size() > 0 && !opportunityTriggerUtils.bIsRecursiveForOpps) {
            system.debug('mapUpdateShipServieOpps:' + mapUpdateShipServieOpps);
            opportunityTriggerUtils.updateShipService(mapUpdateShipServieOpps);
        }
        
        // passing the above lists to the corresponding methods
        if (setAccts.size() > 0 && !opportunityTriggerUtils.bAutoRenew) {
            opportunityTriggerUtils.updateAutoRenew(setAccts);
        }
        
        system.debug('eBookFRM1ProvisionOpps:' + eBookFRM1ProvisionOpps);
        if (eBookFRM1ProvisionOpps.size() > 0) {
            opportunityTriggerUtils.provisionMobiuseBook(eBookFRM1ProvisionOpps,'FRM','I');
        }
        
        system.debug('eBookFRM2ProvisionOpps:' + eBookFRM2ProvisionOpps);
        if (eBookFRM2ProvisionOpps.size() > 0) {
            opportunityTriggerUtils.provisionMobiuseBook(eBookFRM2ProvisionOpps,'FRM','II');
        }
        
        system.debug('eBookERP1ProvisionOpps:' + eBookERP1ProvisionOpps);
        if (eBookERP1ProvisionOpps.size() > 0) {
            opportunityTriggerUtils.provisionEBookWithKeys(eBookERP1ProvisionOpps,'ERP Exam Part I');
        }
        
        system.debug('eBookERP2ProvisionOpps:' + eBookERP2ProvisionOpps);
        if (eBookERP2ProvisionOpps.size() > 0) {
            opportunityTriggerUtils.provisionEBookWithKeys(eBookERP2ProvisionOpps,'ERP Exam Part II');
        }

        system.debug('eBookSCRProvisionOpps:' + eBookSCRProvisionOpps);
        if (eBookSCRProvisionOpps.size() > 0) {
            opportunityTriggerUtils.provisionMobiuseBook(eBookSCRProvisionOpps,'SCR',null);
        }
        
        system.debug('eBookFRRProvisionOpps:' + eBookFRRProvisionOpps);
        if (eBookFRRProvisionOpps.size() > 0) {
            opportunityTriggerUtils.provisionEBookWithKeys(eBookFRRProvisionOpps,'FRR');
             // this is to call yardstick for the LMS.
             if(NoEbookcallout ==false)
            opportunityTriggerUtils.provisionYardstick(eBookFRRProvisionOpps,'17609');
        }
        
         if (ffrOpps.size() > 0) {
             opportunityTriggerUtils.provisionEBookWithKeys(ffrOpps,'FFR');
              // this is to call yardstick for the LMS.
             opportunityTriggerUtils.provisionYardstick(ffrOpps,'14319');
         }
        
        if (wileyOpps.size() > 0) {
            opportunityTriggerUtils.extendWiley(wileyOpps, maphasWiley);
        }
       
        if (riskNetOpps.size() > 0) {
            opportunityTriggerUtils.extendRiskNet(riskNetOpps, mapHasRiskNet);
        }

        if(bulkOpps.size() > 0) {
            opportunityTriggerUtils.closeBulkOrders(bulkOpps);
        }
        
        if(chaptMeetingRegOpps.size() > 0 && !opportunityTriggerUtils.bIsRecursiveForFFRAOpps) {
            opportunityTriggerUtils.provisionChapterMeetingRegistrations(chaptMeetingRegOpps);
        } 
        
        if(setEventOpps.size() > 0){
            opportunityTriggerUtils.provisionEvents(setEventOpps);
        }
        
        if(!retabulationRequestExamRegistrationIds.isEmpty()){
            ExamManagementController.setExamRegistionReScoreStatusForReview(retabulationRequestExamRegistrationIds, retabulationRequestFeesMapByOpportunityId);
        }
        
        if(!scholarshipApplicationIds.isEmpty()){
            ExamManagementController.setScholarshipApplicationStatusAsUsed(scholarshipApplicationIds);
        }
        
    }
}