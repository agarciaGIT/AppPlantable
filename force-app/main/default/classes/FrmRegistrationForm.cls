public class FrmRegistrationForm extends ExamRegistrationForm {

    public List<OpportunityLineItem> addChinaLocationFee(List<ExamSelectionOptions.Site> sites){

        System.debug('** addChinaLocationFee');        
        FINAL String contactId = super.validatedUser.user.ContactId;
        FINAL PricebookEntry CHLF = super.pricebookEntries.pricebookEntryByProductCode.get('CHLF');
        
        List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();

        Set<Id> ostaExamSiteIds = new Set<Id>();
        for(ExamSelectionOptions.Site site: sites){
            if(site.site.Is_OSTA_Information_Required__c){
                ostaExamSiteIds.add(site.examSite.Id);
            }
        }
        
        if(ostaExamSiteIds.isEmpty()){
            return opportunityLineItems;
        }
        
        List<Exam_Sites__c> examSites = [
            SELECT Id, Name, Exam__r.Exam__c, Exam__r.Exam_Group__c, Exam_Part__r.Exam_Administration__c
            FROM Exam_Sites__c 
            WHERE 
                Id IN :ostaExamSiteIds AND 
                Exam__r.Exam__c IN ('FRM Part 1', 'FRM Part 2') AND
                Exam__r.Exam_Group__r.Active__c = TRUE AND
                Exam__r.Exam_Group__r.RecordType.Name = 'FRM/ERP'
            ORDER BY Exam__r.Exam__c ASC
        ];

        if(contactId != null){

            List<Exam_Attempt__c> examRegistrations = [
                SELECT Id, Exam_Name__c, Name, Defered__c, Deferral_Status__c, Opportunity__c, Exam_Site__c, Exam_Site__r.Name, Exam_Site__r.Exam__r.Exam__c, Exam_Site__r.Exam__r.Exam_Group__r.Active__c, 
                Exam_Site__r.Site__r.Is_OSTA_Information_Required__c, 
                Exam_Site__r.Site__r.Is_Gender_Required__c
                FROM Exam_Attempt__c 
                WHERE 
                    Exam_Site__r.Exam__r.Exam_Group__r.Active__c = TRUE AND
                    Exam_Site__r.Exam__r.Exam_Group__r.RecordType.Name = 'FRM/ERP' AND
                    Exam_Site__r.Site__r.Is_OSTA_Information_Required__c = TRUE AND
                    Member__c = :contactId AND 
                    Cancelled__c = FALSE AND
                    Opportunity__r.StageName = 'Closed'
                ORDER BY Exam_Site__r.Exam__r.Exam__c ASC
            ];

            //if(examRegistrations.isEmpty()){
                
                Set<ID> parts = new Set<ID>();
                for(Exam_Sites__c es: examSites){
                                       
                    // Only charge 1 time per Exam Part
                    if(es.Exam_Part__c != NULL && !parts.contains(es.Exam_Part__c)) {
                        opportunityLineItems.add(new OpportunityLineItem(
                            Exam_Site__c = es.Id,
                            PricebookEntryId = CHLF.Id,
                            Product2Id = CHLF.Product2Id,
                            UnitPrice = CHLF.UnitPrice,
                            Quantity = 1
                        ));
                        parts.add(es.Exam_Part__c);
                    }
                }

            //}

        }else{
            
            Set<ID> parts = new Set<ID>();
            for(Exam_Sites__c es: examSites){
                
                // Only charge 1 time per Exam Part
                if(es.Exam_Part__c != NULL && !parts.contains(es.Exam_Part__c)) {
                    opportunityLineItems.add(new OpportunityLineItem(
                        Exam_Site__c = es.Id,
                        PricebookEntryId = CHLF.Id,
                        Product2Id = CHLF.Product2Id,
                        UnitPrice = CHLF.UnitPrice,
                        Quantity = 1
                    ));
                    parts.add(es.Exam_Part__c);

                }
            }
        }
        
        return opportunityLineItems;
        
    }

    public List<OpportunityLineItem> addChinaDataFee(List<ExamSelectionOptions.Site> sites){

        FINAL String contactId = super.validatedUser.user.ContactId;
        FINAL String accountId = super.validatedUser.user.AccountId;
        FINAL PricebookEntry CHNDF = super.pricebookEntries.pricebookEntryByProductCode.get('CHNDF');
        
        List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();

        Site__c testSite = null;
        String siteName = null;
        for(ExamSelectionOptions.Site site: sites){
            if(site.site.Is_OSTA_Information_Required__c){
                testSite = site.site;
                siteName = testSite.Name;
            }
        }
        
        if(testSite == null){
            return opportunityLineItems;
        }
        
        if(contactId != null && accountId != null){

            List<Contract> ostaPrograms = [
                SELECT Id, RecordType.Name, Status
                FROM Contract
                WHERE
                    AccountId = :accountId AND 
                    RecordType.Name = 'OSTA Program' AND 
                    Status LIKE 'Activated%'                    
            ];

            if(ostaPrograms.isEmpty()){
                                
                OpportunityLineItem oli = new OpportunityLineItem(
                    PricebookEntryId = CHNDF.Id,
                    Product2Id = CHNDF.Product2Id,
                    UnitPrice = CHNDF.UnitPrice,
                    Quantity = 1
                );

                opportunityLineItems.add(oli);

            }

        }else{

            OpportunityLineItem oli = new OpportunityLineItem(
                PricebookEntryId = CHNDF.Id,
                Product2Id = CHNDF.Product2Id,
                UnitPrice = CHNDF.UnitPrice,
                Quantity = 1
            );

            opportunityLineItems.add(oli);

        }
        
        return opportunityLineItems;
        
    }

    public RegistrationEligibility getExamEligibility(String inContactId) {
        Set<String> eligibleExams = new Set<String>();
        
        Boolean isInProgram = False;
        Boolean isRegistrationOpen = False; 
        Boolean isPaymentBlocked = False; 
        
        Boolean isERPRegistered = False;
        Boolean isERPPart1AwaitingResults = False;
        Boolean isERPPart2AwaitingResults = False;
        Boolean isERPOpenOrder = False;
        
        Exam_Attempt__c part1ERP;
        Exam_Attempt__c part2ERP;
        
        Boolean isOpenOrder = False;
        
        Boolean isPart1Passed = False;
        Boolean isPart1Offered = False;
        Boolean isPart1RegisteredInActiveGroup = False;
        Boolean isPart1RegisteredAwaitingResults = False;
        Boolean isPart1Deferred = False;

        Exam_Attempt__c part1EA;
        Exam_Attempt__c part2EA;        
        
        Boolean isPart2Passed = False;
        Boolean isPart2Offered = False;
        Boolean isPart2RegisteredInActiveGroup = False;
        Boolean isPart2RegisteredAwaitingResults = False;
        Boolean isPart2Deferred = False;
        
        List<Exam_Group__c> lstExamGroup = [select Id, Name, Registration_Start_Date__c, Last_Date_For_Late_Registration__c from Exam_Group__c where Active__c = True];
        if(lstExamGroup != NULL && lstExamGroup.size() > 0) {
            Exam_Group__c eg = lstExamGroup[0];
            Date tdy = Date.today();

            if(tdy >= eg.Registration_Start_Date__c && tdy <= eg.Last_Date_For_Late_Registration__c) {
                isRegistrationOpen = true;
            }
        }
        if(isRegistrationOpen) {       
            
            FINAL Id contactId;
            if(inContactId != NULL) {
                contactId = inContactId;
            } else {
                contactId = super.validatedUser.user.ContactId;   
            }
            System.debug('contactId:' + contactId);      
                        
            Contract cont = getExamContract(this.validatedUser.user.AccountId);
            if(cont != NULL) {
                isInProgram = True;
                if(cont.Status == 'Completed') {
                    isPart1Passed = True;
                    isPart2Passed = True;
                } else if(cont.Candidate_Requirements__r != NULL) {
                    for(Candidate_Requirement__c cr :cont.Candidate_Requirements__r) {
                        if(cr.RecordType.Name == 'Exam' && cr.Exam__c == 'FRM Part I' && cr.Status__c == 'Completed') {
                            isPart1Passed = True;
                        } else if(cr.RecordType.Name == 'Exam' && cr.Exam__c == 'FRM Part II' && cr.Status__c == 'Completed') {
                            isPart2Passed = True;
                        }
                    }
                }
            }
            System.debug('isInProgram:' + isInProgram);
            System.debug('isPart1Passed:' + isPart1Passed);
            System.debug('isPart2Passed:' + isPart2Passed);
            
            List<Account> lstAcct = [select Id, Block_Purchases_All_Types__c from Account where id = :this.validatedUser.user.AccountId];
            if(!lstAcct.isEmpty()) {
                isPaymentBlocked = lstAcct[0].Block_Purchases_All_Types__c;
            }

            
            List<Exam_Part__c> parts = [select Id, Name, Exam_Part_Number__c, Exam__r.Exam__c,
                                        Exam_Administration__c, Exam_Date__c, Exam_Start_Date__c
                                        from Exam_Part__c where Exam_Administration__r.Exam_Group__r.Active__c = True AND
                                       	Exam__r.Exam__c in ('FRM Part 1','FRM Part 2') 
                                        AND
                                        
                                       	// AG 2/17/2021
                                        // Allow to hide Exam Admin by Date
                                        (Exam_Administration__r.Registration_Start_Date__c = NULL OR Exam_Administration__r.Registration_Start_Date__c <= TODAY) AND
                                        (Exam_Administration__r.Registration_End_Date__c = NULL OR Exam_Administration__r.Registration_End_Date__c >= TODAY)
										];
            
            MAP<String,Exam_Part__c> mapParts = new MAP<String,Exam_Part__c>();
            for(Exam_Part__c p :parts) {
                String key = p.Exam_Administration__c + ':' + p.Exam_Part_Number__c;
                mapParts.put(key,p);
                
                if(p.Exam__r.Exam__c == 'FRM Part 1') {
                    isPart1Offered = True;
                } else if(p.Exam__r.Exam__c == 'FRM Part 2') {
                    isPart2Offered = True;
                }
            }
            System.debug('mapParts:' + mapParts);
            
            System.debug('isPart1Offered:' + isPart2Passed);
            System.debug('isPart2Offered:' + isPart2Passed);
                        
            List<Exam_Attempt__c> examRegistrations = [
                SELECT Id, Candidate_Commitment__r.EndDate, Candidate_Commitment__r.Last_Exam_Registration_Date__c, 
                Candidate_Commitment__r.RecordType.Name, Contract_End_Date__c, Defered__c, 
                Exam_Administration__c,
                Exam_Administration__r.Exam_Results_Loading__c,
                Exam_Site__r.Exam__r.Exam__c,
                Exam_Part__c, Exam_Part__r.Exam_Part_Number__c, Exam_Part__r.Exam_Date__c, Exam_Part__r.Exam_Start_Date__c,
                Opportunity_StageName__c, Member__c, Exam_Date__c, Exam_Site__c, Exam_Site__r.Exam__r.Exam_Group__r.Active__c, 
                Exam_Site__r.Exam__r.Exam_Group__r.Loading_Exam_Results__c, Exam_Site__r.site__c, Section__c, Result__c, Candidate_Commitment__c, 
                Candidate_Commitment__r.Status
                FROM Exam_Attempt__c 
                WHERE 
                (Candidate_Commitment__r.Status LIKE '%Activated%' OR Candidate_Commitment__r.Status = : 'Completed' OR Candidate_Commitment__r.Status = : 'Draft') AND 
                Member__c = :contactId AND 
                (Opportunity_StageName__c = 'Closed' OR Opportunity_StageName__c = 'New Lead') AND 
                Candidate_Commitment__r.RecordType.Name in ('FRM Program','ERP Program') AND 
                Cancelled__c != true 
                ORDER BY Exam_Date__c DESC
            ];
    
            System.debug('examRegistrations:' + examRegistrations);
            
            Integer cntDeferred=0;
            Integer cntActive=0;
            
            for (Exam_Attempt__c objFRMEA: examRegistrations) {
                
                System.debug('objFRMEA:' + objFRMEA);
                
                if(objFRMEA.Candidate_Commitment__r.RecordType.Name == 'ERP Program') {
                    
                    if(objFRMEA.Candidate_Commitment__r.Status == 'Draft')  {
                        isERPOpenOrder = True;
                        
                    } else if(objFRMEA.Candidate_Commitment__r.Status != 'Completed')  {
                        
                        if(objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c == True && (objFRMEA.Defered__c == NULL || objFRMEA.Defered__c != 'Pending')) {
                            isERPRegistered = True;
                            part1ERP=objFRMEA;
                            part2ERP=objFRMEA;
                        }
                        
                        if(part1ERP==NULL && objFRMEA.Exam_Site__r.Exam__r.Exam__c == 'ERP Exam Part I' && objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c == False && 
                           (objFRMEA.Defered__c == NULL || objFRMEA.Defered__c != 'Pending') &&
                           (objFRMEA.Result__c == null || objFRMEA.Result__c == '' || objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.Loading_Exam_Results__c == True || objFRMEA.Exam_Administration__r.Exam_Results_Loading__c == True)) {
                               isERPPart1AwaitingResults = True;
                               part1ERP=objFRMEA;
                           } 
                        
                        if(part2ERP==NULL && objFRMEA.Exam_Site__r.Exam__r.Exam__c == 'ERP Exam Part II' && objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c == False && 
                           (objFRMEA.Defered__c == NULL || objFRMEA.Defered__c != 'Pending') &&
                           (objFRMEA.Result__c == null|| objFRMEA.Result__c == '' || objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.Loading_Exam_Results__c == True || objFRMEA.Exam_Administration__r.Exam_Results_Loading__c == True)) {
                               isERPPart2AwaitingResults = True;
                               part2ERP=objFRMEA;
                           }
                    }
                }
                
                if(objFRMEA.Candidate_Commitment__r.RecordType.Name == 'FRM Program') {
                    
                    if(objFRMEA.Candidate_Commitment__r.Status == 'Draft' || objFRMEA.Opportunity_StageName__c == 'New Lead')  {
                        isOpenOrder = True;
                        
                    } else if(objFRMEA.Candidate_Commitment__r.Status != 'Completed')  { 
                        
                        if(part1EA==Null && objFRMEA.Exam_Site__r.Exam__r.Exam__c == 'FRM Part 1') {
                            if(objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c == True) {
                                isPart1RegisteredInActiveGroup = True;
                                isPart1RegisteredAwaitingResults = False;  
                                part1EA = objFRMEA;
                            }
                            if(objFRMEA.Defered__c == 'Pending') {
                                isPart1Deferred = True;
                                part1EA = objFRMEA;
                            }                            
                        }
                        if(part2EA==Null && objFRMEA.Exam_Site__r.Exam__r.Exam__c == 'FRM Part 2') {
                            if(objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c == True) {
                                isPart2RegisteredInActiveGroup = True;
                                isPart2RegisteredAwaitingResults = False;
                                part2EA = objFRMEA;
                            }
                            if(objFRMEA.Defered__c == 'Pending') {
                                isPart2Deferred = True;
                                part2EA = objFRMEA;
                            }
                        }
                        
                        
                        
                        if(part1EA==Null && objFRMEA.Exam_Site__r.Exam__r.Exam__c == 'FRM Part 1' && objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c == False && 
                           (objFRMEA.Defered__c == NULL || objFRMEA.Defered__c != 'Pending') &&
                           (objFRMEA.Result__c == null || objFRMEA.Result__c == '' || objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.Loading_Exam_Results__c == True || objFRMEA.Exam_Administration__r.Exam_Results_Loading__c == True)) {
                               isPart1RegisteredAwaitingResults = True;
                               part1EA = objFRMEA;
                           }
                        
                       
                        if(part2EA==Null && objFRMEA.Exam_Site__r.Exam__r.Exam__c == 'FRM Part 2' && objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c == False && 
                           (objFRMEA.Defered__c == NULL || objFRMEA.Defered__c != 'Pending') &&
                           (objFRMEA.Result__c == null|| objFRMEA.Result__c == '' || objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.Loading_Exam_Results__c == True || objFRMEA.Exam_Administration__r.Exam_Results_Loading__c == True)) {
                               isPart2RegisteredAwaitingResults = True;
                               part2EA = objFRMEA;
                           }
                    }
                }
            }    
            System.debug('isPart1RegisteredInActiveGroup:' + isPart1RegisteredInActiveGroup);
            System.debug('isPart1RegisteredAwaitingResults:' + isPart1RegisteredAwaitingResults);
            System.debug('isPart2RegisteredInActiveGroup:' + isPart2RegisteredInActiveGroup);
            System.debug('isPart2RegisteredAwaitingResults:' + isPart2RegisteredAwaitingResults);
            
            System.debug('isERPRegistered:' + isERPRegistered);
            System.debug('isERPPart1AwaitingResults:' + isERPPart1AwaitingResults);
            System.debug('isERPPart2AwaitingResults:' + isERPPart2AwaitingResults);
            
            System.debug('isPart1Deferred:' + isPart1Deferred);
            System.debug('isPart2Deferred:' + isPart2Deferred);        
            
            //system.assert(false, 'BOOM!5'+ isPart1RegisteredInActiveGroup);
            
            // Per Vivek allow Awaiting Results for FRM to reg
            // && !isERPPart1AwaitingResults && !isERPPart2AwaitingResults
            if(!isERPRegistered && !isERPOpenOrder && !isOpenOrder && !isPaymentBlocked) {
                if(!isPart1Passed && isPart1Offered && !isPart1RegisteredInActiveGroup && !isPart1RegisteredAwaitingResults && !isPart2RegisteredAwaitingResults && !isPart1Deferred && !isPart2Deferred) {
                    eligibleExams.add('FRM Part 1');
                }   
                
                if(!isPart2Passed && isPart2Offered && !isPart2RegisteredInActiveGroup && !isPart1RegisteredAwaitingResults && !isPart2RegisteredAwaitingResults && !isPart1Deferred && !isPart2Deferred) {
                                    
                    // If already registered for Part I is Part II available in the same Admin on of after Part I
                    if(part1EA != NULL && isPart1RegisteredInActiveGroup) {
                        String key1 = part1EA.Exam_Administration__c + ':' + part1EA.Exam_Part__r.Exam_Part_Number__c;
                        Exam_Part__c fndPart1 = mapParts.get(key1);
                        System.debug('fndPart1:' + fndPart1);
                        if(fndPart1 != NULL) {                        
                            for(String key :mapParts.keySet()) {
                                
                                System.debug('key:' + key);
                                
                                // If Part 2 
                                if(key.indexOf(':2') > -1) {
                                    Exam_Part__c fndPart2 = mapParts.get(key);
                                    
                                    System.debug('fndPart2:' + fndPart2);
                                    
                                    if(fndPart2 != NULL) {                                
                                        if(fndPart2.Exam_Administration__c == fndPart1.Exam_Administration__c) {
                                            eligibleExams.add('FRM Part 2');
                                        } else {
                                            Date p1 = (fndPart1.Exam_Date__c != NULL) ? fndPart1.Exam_Date__c : fndPart1.Exam_Start_Date__c;
                                            Date p2 = (fndPart2.Exam_Date__c != NULL) ? fndPart2.Exam_Date__c : fndPart2.Exam_Start_Date__c;
                                            
                                            System.debug('p1:' + p1);
                                            System.debug('p2:' + p2);
                                            
                                            if(p1 != NULL && p1 != NULL && p2 >= p1) {
                                                eligibleExams.add('FRM Part 2');
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        eligibleExams.add('FRM Part 2');    
                    }
                    
                }   
            }
        }
        System.debug('eligibleExams:' + eligibleExams);
        
        RegistrationEligibility reObj = new RegistrationEligibility();
        reObj.eligibleExams = eligibleExams;
        reObj.isRegistrationOpen = isRegistrationOpen;
        reObj.isPaymentBlocked = isPaymentBlocked;
        reObj.isInProgram = isInProgram;
        reObj.isOtherRegistered = isERPRegistered;
        reObj.isOtherPart1AwaitingResults = isERPPart1AwaitingResults;
        reObj.isOtherPart2AwaitingResults = isERPPart2AwaitingResults;
        reObj.isOtherOpenOrder = isERPOpenOrder;               
        reObj.isOpenOrder = isOpenOrder;
                
        reObj.isPart1Passed = isPart1Passed;
        reObj.isPart1Offered = isPart1Offered;
        reObj.isPart1RegisteredInActiveGroup = isPart1RegisteredInActiveGroup;
        reObj.isPart1RegisteredAwaitingResults = isPart1RegisteredAwaitingResults;
        reObj.isPart1Deferred = isPart1Deferred;
                
        reObj.isPart2Passed = isPart2Passed;
        reObj.isPart2Offered = isPart2Offered;
        reObj.isPart2RegisteredInActiveGroup = isPart2RegisteredInActiveGroup;
        reObj.isPart2RegisteredAwaitingResults = isPart2RegisteredAwaitingResults;
        reObj.isPart2Deferred = isPart2Deferred; 
            
        return reObj;        
    }
    
    public override RegistrationEligibility getEligibileExams(String inContactId) {
        
        return getExamEligibility(inContactId);
        
        /*
        FINAL Id contactId;
        if(inContactId != NULL) {
            contactId = inContactId;
        } else {
            contactId = super.validatedUser.user.ContactId;   
        }
        System.debug('contactId:' + contactId);         

        Set<String> eligibleExams = new Set<String>();
        
        Date dtExamDate = null;
        Date examDate = super.getExamDate();
        
        Integer iDefferedCount = 0;
        Integer iActiveEA = 0;
        
        Boolean bhasRecords = false;
        Boolean bhasFrm12 = false;
        Boolean bFrm1 = false;
        Boolean bFrm2 = false;
        Boolean bPassFrm1 = false;
        Boolean bhasERP = false;
        Integer erpActive = 0;
        Integer erpDeferred = 0;
        
        List<Exam_Part__c> parts = [select Id, Name, Exam_Part_Number__c, Exam_Administration__c, Exam_Date__c, Exam_Start_Date__c
                                    from Exam_Part__c where Exam_Administration__r.Exam_Group__r.Active__c = True];
        MAP<String,Exam_Part__c> mapParts = new MAP<String,Exam_Part__c>();
        for(Exam_Part__c p :parts) {
            String key = p.Exam_Administration__c + ':' + p.Exam_Part_Number__c;
            mapParts.put(key,p);
        }
        
        System.debug('mapParts:' + mapParts);
        
        List<Exam_Attempt__c> examRegistrations = [
            SELECT Id, Candidate_Commitment__r.EndDate, Candidate_Commitment__r.Last_Exam_Registration_Date__c, Candidate_Commitment__r.RecordType.Name, Contract_End_Date__c, Defered__c, 
            Exam_Administration__c,
            Exam_Part__c, Exam_Part__r.Exam_Part_Number__c, Exam_Part__r.Exam_Date__c, Exam_Part__r.Exam_Start_Date__c,
            Opportunity_StageName__c, Member__c, Exam_Date__c, Exam_Site__c, Exam_Site__r.Exam__r.Exam_Group__r.Active__c, 
            Exam_Site__r.Exam__r.Exam_Group__r.Loading_Exam_Results__c, Exam_Site__r.site__c, Section__c, Result__c, Candidate_Commitment__c, 
            Candidate_Commitment__r.Status 
            FROM Exam_Attempt__c 
            WHERE 
            (Candidate_Commitment__r.Status LIKE '%Activated%' OR Candidate_Commitment__r.Status = : 'Completed') AND 
            Member__c = :contactId AND 
            Opportunity_StageName__c = 'Closed' AND 
            Candidate_Commitment__r.RecordType.Name in ('FRM Program','ERP Program') AND 
            Cancelled__c != true 
            ORDER BY Exam_Date__c DESC
        ];

        for (Exam_Attempt__c objFRMEA: examRegistrations) {
            
            System.debug('objFRMEA:' + objFRMEA);
            
            
            if(objFRMEA.Candidate_Commitment__r.RecordType.Name == 'ERP Program') {
                if(objFRMEA.Defered__c == 'Pending') {
                    erpDeferred=erpDeferred+1;
                }
                
                if(objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c) {
                    erpActive=erpActive+1;
                } 
                continue;
            }
            

            // Prevent exam registration for users who have an associated exam registration who's related exam group results are being loaded
            if(objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.Loading_Exam_Results__c){
                return null;
            }
            
            // Check 4 year expiration window
            if(
                objFRMEA.Candidate_Commitment__r.Status == 'Activated' && 
                objFRMEA.Candidate_Commitment__r.Last_Exam_Registration_Date__c != null &&
                objFRMEA.Candidate_Commitment__r.Last_Exam_Registration_Date__c.year()  <= ExamDate.year()  &&
                objFRMEA.Candidate_Commitment__r.Last_Exam_Registration_Date__c.month() != ExamDate.month() &&
                objFRMEA.Candidate_Commitment__r.Last_Exam_Registration_Date__c.month() <= ExamDate.month()                                            
            ){
                System.debug('The four year expiration window has expired.');
                return null;
            }
            
            if(objFRMEA.Candidate_Commitment__r.Status == 'Completed'){
                return null;
            }
            
            bhasRecords = true;
            
            if(dtExamDate == null){
                dtExamDate = objFRMEA.Exam_Date__c;
            }
            
            if(objFRMEA.Defered__c == 'Pending'){
                iDefferedCount += 1;
            }
            
            if(objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c){
                iActiveEA += 1;
            }
            
            if(objFRMEA.Section__c.indexOf('FRM Part 2') >= 0 && (objFRMEA.Result__c == 'pass' || objFRMEA.Result__c == null|| objFRMEA.Result__c == '')) {
                
                if ((objFRMEA.Result__c == null ||objFRMEA.Result__c =='Pass')&& !objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c){
                    eligibleExams.clear();
                }
                
                bhasFrm12 = true;
                bFrm2 = true;
                
                break;
                
            }else if(objFRMEA.Section__c.indexOf('FRM Full Program') >= 0 && !bFrm1 && !bFrm2){
                
                if(objFRMEA.Result__c == 'Pass') {
                    bhasFrm12 = true;
                    break;
                }else if((objFRMEA.Result__c != null) && objFRMEA.Result__c != 'Pass' || objFRMEA.Result__c == 'No-Show') {
                    eligibleExams.clear();
                    eligibleExams.add('FRM Part 1');
                    eligibleExams.add('FRM Part 2');
                }
                
            }else if(objFRMEA.Section__c.indexOf('FRM Part 1') >= 0) {
                
                bFrm1 = true;
                                
                if(objFRMEA.Result__c == null && !objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c){
                    break;
                }else if((objFRMEA.Result__c != null) && objFRMEA.Result__c != 'Pass' || objFRMEA.Result__c == 'No-Show') {
                    eligibleExams.clear();
                    if(bPassFrm1==false){
                        eligibleExams.add('FRM Part 1');
                    }
                    eligibleExams.add('FRM Part 2');
                }else if(objFRMEA.Result__c == 'Pass' || objFRMEA.Result__c == null){                 
                    bPassFrm1=true ;              
                    eligibleExams.clear();  
                    
                    if(objFRMEA.Exam_Part__r == NULL) {
                        eligibleExams.add('FRM Part 2');                        
                    } else {
                        // If Part 2 is available in the same admin as 1 or before
                        
                        String key1 = objFRMEA.Exam_Administration__c + ':' + objFRMEA.Exam_Part__r.Exam_Part_Number__c;
                        Exam_Part__c fndPart1 = mapParts.get(key1);
                        
                        System.debug('fndPart1:' + fndPart1);
                        
                        if(fndPart1 != NULL) {                        
                            for(String key :mapParts.keySet()) {
                                
                                System.debug('key:' + key);
                                
                                // If Part 2 
                                if(key.indexOf(':2') > -1) {
                                    Exam_Part__c fndPart2 = mapParts.get(key);
                                    
                                    System.debug('fndPart2:' + fndPart2);
                                    
                                    if(fndPart2 != NULL) {                                
                                        if(fndPart2.Exam_Administration__c == fndPart1.Exam_Administration__c) {
                                            eligibleExams.add('FRM Part 2');
                                        } else {
                                            Date p1 = (fndPart1.Exam_Date__c != NULL) ? fndPart1.Exam_Date__c : fndPart1.Exam_Start_Date__c;
                                            Date p2 = (fndPart2.Exam_Date__c != NULL) ? fndPart2.Exam_Date__c : fndPart2.Exam_Start_Date__c;
                                            
                                            System.debug('p1:' + p1);
                                            System.debug('p2:' + p2);
                                            
                                            if(p1 != NULL && p1 != NULL && p2 >= p1) {
                                                eligibleExams.add('FRM Part 2');
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                }
                    
            }
            
        }

        System.debug('eligibleExams:' + eligibleExams);
        System.debug('erpActive:' + erpActive);
        System.debug('erpDeferred:' + erpDeferred);
        
            
        if(erpActive > 0 && erpActive > erpDeferred) {
            eligibleExams.clear();
        } else if(iDefferedCount == iActiveEA && iDefferedCount > 0){
            eligibleExams.clear();
        }else if(bhasFrm12 && (iDefferedCount != iActiveEA)){
            eligibleExams.clear();
        }else if (!bhasRecords) {
            eligibleExams.add('FRM Part 1');
            eligibleExams.add('FRM Part 2');
        }
        
        System.debug('eligibleExams final:' + eligibleExams);
        
        return eligibleExams;
        */
    }

    public override ExamSelectionOptions getExamSelectionOptions(){

        Set<String> examPartNames = new Set<String>{'FRM Part 1', 'FRM Part 2'};

        Map<Id, Exam_Sites__c> examSitesMap = super.getExamSitesMap(examPartNames);
        System.debug('examSitesMap:' + examSitesMap);
        
        Set<Id> exams = new Set<Id>();
        for(Exam_Sites__c es: examSitesMap.values()){
            exams.add(es.Exam__c);
        }

        System.debug('exams:' + exams);
                
        Map<Id, ExamSelectionOptions.ExamPricebookEntry> examPricebookEntries = super.getExamPricebookEntries(exams);
        
        ExamSelectionOptions eso = new ExamSelectionOptions(examSitesMap, examPricebookEntries);
        
        eso.createExamsArray();
        //system.assert(false, 'BOOM!5'+ eso);
        
        eso.createOptionsArray();

        return eso;

    }

    public override ExamSelectionOptions getExamSelectionOptions(Set<String> examPartNames){

        Map<Id, Exam_Sites__c> examSitesMap = super.getExamSitesMap(examPartNames);

        Set<Id> exams = new Set<Id>();
        for(Exam_Sites__c es: examSitesMap.values()){
            exams.add(es.Exam__c);
        }

        Map<Id, ExamSelectionOptions.ExamPricebookEntry> examPricebookEntries = super.getExamPricebookEntries(exams);

        System.debug('***examPricebookEntries:' + examPricebookEntries);
        
        ExamSelectionOptions eso = new ExamSelectionOptions(examSitesMap, examPricebookEntries);
        
        System.debug('***eso:' + eso);

        eso.createExamsArray();
        eso.createOptionsArray();

        return eso;

    }

    public override Map<String, Item> getFeesMap(){
        
        Set<String> productCodes = new Set<String>{'CHLF', 'CHNDF', 'PRFEE', 'MEMF', 'CDNTAX'};
        
        Map<Id, PricebookEntry> pricebookEntries = new Map<Id, PricebookEntry>();
        for(String productCode: productCodes){
            if(super.pricebookEntries.pricebookEntryByProductCode.containsKey(productCode)){
                PricebookEntry pbe = super.pricebookEntries.pricebookEntryByProductCode.get(productCode);
                pricebookEntries.put(pbe.Id, pbe);
            }
        }
      
        //The unit price of these fees/discounts are dynamically computed
        PricebookEntry enrollmentFee = super.getEnrollmentFee();
        if(enrollmentFee != null){
            pricebookEntries.put(enrollmentFee.Id, enrollmentFee);
        }  
                
        //Create Item objects using the defined model
        Map<String, Item> availableFees = new Map<String, Item>();
 
        for(PricebookEntry pbe: pricebookEntries.values()){
            
            Item item = new Item(pbe);
            
            availableFees.put(item.id, item);
            
        }
        
        return availableFees;
        
    }

    public override Map<String, Item> getFeesMapAuthenticated(List<ExamSelectionOptions.Exam> availableExams){

        FINAL Id contactId = this.validatedUser.user.ContactId;
        FINAL Id accountId = this.validatedUser.user.AccountId;

        Set<String> productCodes = new Set<String>{'PRFEE', 'MEMF', 'CDNTAX'};

        //Datamine existing Exam Registrations for the authenticated user
        List<Exam_Attempt__c> examRegistrations = [
            SELECT Id, Exam_Name__c, Name, Defered__c, Deferral_Status__c, Opportunity__c, Exam_Site__c, Exam_Site__r.Name, Exam_Site__r.Exam__r.Exam__c, Exam_Site__r.Exam__r.Exam_Group__r.Active__c
            FROM Exam_Attempt__c 
            WHERE 
            Exam_Site__r.Exam__r.Exam_Group__r.Active__c = TRUE AND
            Exam_Site__r.Exam__r.Exam_Group__r.RecordType.Name = 'FRM/ERP' AND
            Exam_Site__r.Site__r.Is_OSTA_Information_Required__c = TRUE AND
            Member__c = :contactId AND 
            Cancelled__c = FALSE AND
            Opportunity__r.StageName = 'Closed' AND
            Section__c LIKE 'FRM%'
            ORDER BY Exam_Site__r.Exam__r.Exam__c ASC
        ];

        //Add product codes
        //if(examRegistrations.isEmpty()){
            productCodes.add('CHLF');
        //}

        List<Contract> ostaPrograms = [
            SELECT Id, RecordType.Name, Status
            FROM Contract
            WHERE 
                AccountId = :accountId AND 
                RecordType.Name = 'OSTA Program' AND 
                Status LIKE 'Activated%'
        ];

        if(ostaPrograms.isEmpty()){
            productCodes.add('CHNDF');
        }

        Map<Id, PricebookEntry> pricebookEntries = new Map<Id, PricebookEntry>();
        for(String productCode: productCodes){
            if(super.pricebookEntries.pricebookEntryByProductCode.containsKey(productCode)){
                PricebookEntry pbe = super.pricebookEntries.pricebookEntryByProductCode.get(productCode);
                pricebookEntries.put(pbe.Id, pbe);
            }
        }
        
        //The unit price of these fees/discounts are dynamically computed
        PricebookEntry enrollmentFee = super.getEnrollmentFee();
        if(enrollmentFee != null){
            pricebookEntries.put(enrollmentFee.Id, enrollmentFee);
        }   
        
        PricebookEntry scholarshipDiscount = super.getScholarshipDiscount(availableExams);
        if(scholarshipDiscount != null){
            pricebookEntries.put(scholarshipDiscount.Id, scholarshipDiscount);
        }
 
        //Create Item objects using the defined model
        Map<String, Item> availableFees = new Map<String, Item>();
 
        for(PricebookEntry pbe: pricebookEntries.values()){
            
            Item item = new Item(pbe);
            
            availableFees.put(item.id, item);
            
        }
        
        return availableFees;
        
    }

    public override Set<Integer> getExamPartNumbers(List<ExamSelectionOptions.Exam> exams){

        Set<Integer> examPartNumbers = new Set<Integer>();
        for(ExamSelectionOptions.Exam exam: exams){
            String examName = exam.exam.Exam__c;
            if(examName == 'FRM Part 1'){
                examPartNumbers.add(1);
            }else if(examName == 'FRM Part 2'){
                examPartNumbers.add(2);
            }
        }
        return examPartNumbers;

    }

    public override List<PricebookEntry> getStudyMaterials(Set<Integer> examPartNumbers){
                
        Set<String> productCodes = new Set<String>();
        
        for(Integer i: examPartNumbers){
            productCodes.add('FRM' + i + 'H');
            productCodes.add('FRM' + i + 'X');
            productCodes.add('FRMC' + i);
        }
                
        List<PricebookEntry> materials = [
            SELECT Product2.Content__c, Product2.Content__r.Story__c, Product2.Content__r.Mobile_Story__c,Product2.Content__r.Name, Product2.Content__r.Content_Name__c, Product2.Content__r.Image__c, Product2.Content__r.Start_Date__c,Product2.Content__r.Status__c,Product2.Content__r.Lead_Gen_URL__c,Product2.Id, Product2.ProductCode, Product2.Name, Product2.Weight__c,Product2.Product_ID__c,Product2.Inventory__c, Product2.Taxable__c, Product2.Electronic_Delivery__c, Product2.Pre_Order_Date__c, Product2.Pre_Order_Shipping_Date__c, Product2.Is_Comped_Registration__c, Product2.Exam_Part__c, UnitPrice, ProductCode
            FROM PricebookEntry 
            WHERE ProductCode IN :productCodes AND IsActive = TRUE AND Pricebook2.IsActive = TRUE AND Product2.IsActive = TRUE 
            ORDER BY Product2.ProductCode ASC
        ];        
        
        return materials;
        
    }

    public override Contract getExamContract(Id accountId){
        
        List<Contract> contracts = [
            SELECT Id, Name, RecordTypeId, Status,
            (
                SELECT Id, Name, Status__c, Exam__c, RecordType.Name
                FROM Candidate_Requirements__r
            )
            FROM Contract 
            WHERE 
            AccountId = :accountId AND 
            RecordType.Name = 'FRM Program' AND
            (Status LIKE 'Activated%' OR Status = 'Completed')
            LIMIT 1
        ];
              
        Contract contract = (contracts.isEmpty()) ? null : contracts[0];
        
        return contract;
        
    }

    public override Contract createExamContract(Id accountId, Id contactId, Id opportunityId, List<Selection> selections){
        
        Contract examContract = new Contract(
            AccountId = accountId,
            Opportunity__c = opportunityId,
            CustomerSignedId = contactId,
            StartDate = System.Today(),
            ContractTerm = 48
        );
        
        examContract.RecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'FRM Program');
            
        INSERT examContract;
        
        return examContract;      
        
    }

    public override Map<String, Candidate_Requirement__c> createExamContractRequirementsByExamMap(Id contractId, String email) {
        
        Id examRecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Exam');
        Id jobExperienceRecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Job Experience');
        
        Map<String, Candidate_Requirement__c> candidateRequirementsByExamMap = new Map<String, Candidate_Requirement__c>();
            
        Candidate_Requirement__c candidateExamPartIRequirement = new Candidate_Requirement__c(
            Candidate_Commitment__c = contractId,
            Candidate_Email__c = email,
            Name = 'Pass FRM1',
            Exam__c = 'FRM Part I',
            Status__c = 'Initial',
            RecordTypeID = examRecordTypeID,
            Prerequisite__c = null
        );
        
        INSERT candidateExamPartIRequirement;
        
        Candidate_Requirement__c candidateExamPartIIRequirement = new Candidate_Requirement__c(
            Candidate_Commitment__c = contractId,
            Candidate_Email__c = email,
            Name = 'Pass FRM2',
            Exam__c = 'FRM Part II',
            Status__c = 'Initial',
            RecordTypeID = examRecordTypeID,
            Prerequisite__c = candidateExamPartIRequirement.Id
        );
        
        INSERT candidateExamPartIIRequirement;
        
        Candidate_Requirement__c candidateJobRequirement = new Candidate_Requirement__c(
            Candidate_Commitment__c = contractId,
            Candidate_Email__c = email,
            Name = 'Job Requirement',
            Status__c = 'Initial',
            RecordTypeID = jobExperienceRecordTypeID,
            Email_GARP_Member__c = email,
            Prerequisite__c = candidateExamPartIIRequirement.Id
        );
        
        INSERT candidateJobRequirement;
        
        candidateRequirementsByExamMap.put(candidateExamPartIRequirement.Exam__c, candidateExamPartIRequirement);
        candidateRequirementsByExamMap.put(candidateExamPartIIRequirement.Exam__c, candidateExamPartIIRequirement);
            
        return candidateRequirementsByExamMap;
        
    }

    public override Map<String, Candidate_Requirement__c> getExamContractRequirementsByExamMap(Id contractId){
        
        List<Candidate_Requirement__c> candidateRequirements = [
            SELECT Id, Name, RecordTypeId, Exam__c, Candidate_Commitment__c
            FROM Candidate_Requirement__c
            WHERE Candidate_Commitment__c = :contractId AND Exam__c LIKE '%FRM%'
        ];
        
        Map<String, Candidate_Requirement__c> candidateRequirementsByExamMap = new Map<String, Candidate_Requirement__c>();
        
        for(Candidate_Requirement__c cr: candidateRequirements){
            candidateRequirementsByExamMap.put(cr.Exam__c, cr);
        }
        
        return candidateRequirementsByExamMap;
        
    }

    public override List<OpportunityLineItem> stageOpportunityLineItems(RegistrationRequest registrationRequest){

        FINAL Id contactId = super.validatedUser.user.ContactId;
        FINAL Id examGroupId = super.examGroup.Id;
        
        List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();
        system.debug(opportunityLineItems);
        
        //Add shipping to opportunity line items
        if(!registrationRequest.products.isEmpty()){
            
            Set<Id> pricebookEntryIds = new Set<Id>();
            for(Item item: registrationRequest.products.values()){
                pricebookEntryIds.add(item.pricebookEntry.Id);
            }
            
            if(registrationRequest.shippingInfo != NULL) {
            
                system.debug('shippingInfo:' + registrationRequest.shippingInfo);
                    
                Response.Collection validatedShippingResponse = RegistrationFormShippingHelper.validateShippingSelection(
                    registrationRequest.shippingInfo, 
                    registrationRequest.lead, 
                    pricebookEntryIds
                );
                
                system.debug('validatedShippingResponse:' + validatedShippingResponse);
                
                if(validatedShippingResponse.data != null) {
                    for(Object col :validatedShippingResponse.data) {
                        OpportunityLineItem shippingOli = (OpportunityLineItem)col;
                        opportunityLineItems.add(shippingOli);
                    }
                    system.debug('opportunityLineItems:' + opportunityLineItems);
                }
            
            } else {
            
                Response.Collection validatedShippingResponse = RegistrationFormShippingHelper.validateShippingSelection(
                    registrationRequest.shipping, 
                    registrationRequest.lead, 
                    pricebookEntryIds
                );
                
                if(validatedShippingResponse.data != null) {
                    for(Object col :validatedShippingResponse.data) {
                        OpportunityLineItem shippingOli = (OpportunityLineItem)col;
                        opportunityLineItems.add(shippingOli);
                    }
                    system.debug('opportunityLineItems:' + opportunityLineItems);
                }
            }
            
        }
        system.debug(opportunityLineItems);
        System.debug('registrationRequest.selections:' + registrationRequest.selections);
        
        List<ExamSelectionOptions.Exam> selectedExams = new List<ExamSelectionOptions.Exam>();
        List<ExamSelectionOptions.Site> selectedSites = new List<ExamSelectionOptions.Site>();
        Set<ID> examIds = new Set<ID>();
        Set<ID> adminIds = new Set<ID>();
        for(Selection selection: registrationRequest.selections){
            selectedExams.add(selection.exam);
            selectedSites.add(selection.site);
            examIds.add(selection.exam.id);
            adminIds.add(selection.examPart.examPart.Exam_Administration__c);
        }
        System.debug('examIds:' + examIds);
        System.debug('adminIds:' + adminIds);
        system.debug(opportunityLineItems);
        List<OpportunityLineItem> studyMaterials = super.addStudyMaterials(registrationRequest.products);
        if(studyMaterials != null && !studyMaterials.isEmpty()){
            opportunityLineItems.addAll(studyMaterials);
        }
        system.debug(opportunityLineItems);
        List<OpportunityLineItem> taxesAndDuty = super.addTaxAndDuty(opportunityLineItems, registrationRequest.lead);
        if(taxesAndDuty != null && !taxesAndDuty.isEmpty()){
            opportunityLineItems.addAll(taxesAndDuty);
        }  
        system.debug(opportunityLineItems);
        List<OpportunityLineItem> enrollmentAndMembershipFees = super.addEnrollmentAndMembershipFee();
        if(enrollmentAndMembershipFees != null && !enrollmentAndMembershipFees.isEmpty()){
            opportunityLineItems.addAll(enrollmentAndMembershipFees);
        }
        system.debug(opportunityLineItems);
        //List<OpportunityLineItem> exams = super.addExamRegistrations(selectedExams);
        //if(exams != null && !exams.isEmpty()){
        //    opportunityLineItems.addAll(exams);     
        //}
    
        List<Exam_Rate__c> lstExamRates = [
            SELECT Id, Name, Exam__c, Rate_Type__c, Exam_Administration__c, Exam__r.Exam__c, Exam__r.Name, Exam__r.Administration_Time_of_Day__c, Product__c, Product__r.Name, Product__r.ProductCode
            FROM Exam_Rate__c 
            WHERE 
            Exam__c IN :examIds AND
            Exam_Administration__c IN :adminIds AND
            Exam_Registration_Window__r.Exam_Group__r.RecordType.Name in ('FRM/ERP') AND
            Exam_Registration_Window__r.Exam_Registration_Window_Open__c <= TODAY AND
            Exam_Registration_Window__r.Exam_Registration_Window_Close__c >= TODAY 
            ORDER BY Product__r.ProductCode ASC
        ];        
        
        System.debug('lstExamRates:' + lstExamRates);
        
        if(super.validatedUser.isAuthenticated){
            
            List<Exam_Rate_Offering__c> examRateOfferings = [
                SELECT Id, Exam_Rate__c, Contact__c, Start_Date__c, End_Date__c,
                Exam_Rate__r.Name, Exam_Rate__r.Exam__c, Exam_Rate__r.Rate_Type__c, Exam_Rate__r.Exam_Administration__c, Exam_Rate__r.Exam__r.Exam__c, Exam_Rate__r.Exam__r.Name, Exam_Rate__r.Exam__r.Administration_Time_of_Day__c, Exam_Rate__r.Product__c, Exam_Rate__r.Product__r.Name, Exam_Rate__r.Product__r.ProductCode
                FROM Exam_Rate_Offering__c
                WHERE 
                Exam_Rate__r.Exam__c IN :examIds AND
                Exam_Rate__r.Exam_Administration__c IN :adminIds AND
                Contact__c = :super.validatedUser.user.ContactId AND
                Start_Date__c <= TODAY AND
                End_Date__c >= TODAY
            ];
            
            if(!examRateOfferings.isEmpty()){
                
                Map<Id, Exam_Rate_Offering__c> examRateOfferingByExamId = new Map<Id, Exam_Rate_Offering__c>();
                for(Exam_Rate_Offering__c ero: examRateOfferings){
                    examRateOfferingByExamId.put(ero.Exam_Rate__r.Exam__c, ero);
                }
                
                // Override Exam Rate with datamined Exam Offering Rate
                for(Integer i = 0; i < lstExamRates.size(); i++){
                    Exam_Rate__c examRate = lstExamRates[i];
                    if(examRateOfferingByExamId.containsKey(examRate.Exam__c)){
                        Exam_Rate__c specialRate = examRateOfferingByExamId.get(examRate.Exam__c).Exam_Rate__r;
                        lstExamRates.set(i, specialRate);
                    }
                }
                
            }
            
        }
        System.debug('lstExamRates final:' + lstExamRates); 
        
        MAP<String,Exam_Rate__c> mapExamRates = new MAP<String,Exam_Rate__c>();
        for(Exam_Rate__c er :lstExamRates) {
            mapExamRates.put(er.Exam__c + ':' + er.Exam_Administration__c,er);
        }
        System.debug('mapExamRates:' + mapExamRates);
        
        // Team Registration Custom Settings
        Map<String, Team_Registration_Products__c> mapCustTeamProds = Team_Registration_Products__c.getAll();
        Map<String, Team_Registration_Products__c> mapTeamProds = new Map<String, Team_Registration_Products__c>();
        if(teamRegistration != NULL && mapCustTeamProds != NULL) {
            for(Team_Registration_Products__c trp :mapCustTeamProds.values()) {
                mapTeamProds.put(trp.Product_Code__c + '~' + trp.GL_Code__c, trp);
            }
        }
        System.debug('mapCustTeamProds:' + mapCustTeamProds);
        System.debug('mapTeamProds:' + mapTeamProds);
                
        for(Selection selection: registrationRequest.selections){
            String key = selection.examPart.examPart.Exam__c +':'+selection.examPart.examPart.Exam_Administration__c;
            System.debug('selection key:' + key);
            
            Exam_Rate__c fndRate = mapExamRates.get(key);
            System.debug('fndRate:' + fndRate);
            if(fndRate != NULL) {
                PricebookEntry pbe = PricebookEntries.pricebookEntryByProductId.get(fndRate.Product__c); 
                System.debug('pbe:' + pbe);
                if(pbe != NULL) {
                    OpportunityLineItem oli = new OpportunityLineItem(
                        PricebookEntryId = pbe.Id,
                        Product2Id = pbe.Product2Id,
                        UnitPrice = pbe.UnitPrice,
                        Quantity = 1
                    );
                    
                    // AG 3/18/2022 - Replace team reg products
                    Team_Registration_Products__c fndTeamProd = mapTeamProds.get(pbe.ProductCode + '~' + pbe.Product2.GL_Code__c);
                    if(fndTeamProd != NULL && teamRegistration.Discounted_Price__c == NULL && teamRegistration.Is_Scholarship__c == False) {
                        
                        oli.Product2Id = fndTeamProd.Replacement_Product_Id__c;
                        oli.PricebookEntryId = fndTeamProd.Replacement_Product_Price_Id__c;                            
                        
                        System.debug('team reg replace:' + oli);

                    }
                        opportunityLineItems.add(oli); 
    
                    // AG 5/27/2022 - Add team discount
                    if(fndTeamProd != NULL && (teamRegistration.Discounted_Price__c != NULL || teamRegistration.Is_Scholarship__c)) {
                        
                        if(teamRegistration.Discounted_Price__c != NULL) {
                            // Add Discount Product
                            OpportunityLineItem oppLineItemRate = new OpportunityLineItem();
                            oppLineItemRate.Product2Id = fndTeamProd.Discount_Product_Id__c;
                            oppLineItemRate.PricebookEntryId = fndTeamProd.Discount_Product_Price_Id__c;
                            oppLineItemRate.Quantity = 1; 
                            oppLineItemRate.UnitPrice = (pbe.UnitPrice - teamRegistration.Discounted_Price__c) * -1;
                            opportunityLineItems.add(oppLineItemRate);
                            System.debug('team reg add disc:' + oppLineItemRate);
                            
                        } else {
                            // Add Scholarship Product
                            OpportunityLineItem oppLineItemRate = new OpportunityLineItem();
                            oppLineItemRate.Product2Id = fndTeamProd.Scholarship_Product_Id__c;
                            oppLineItemRate.PricebookEntryId = fndTeamProd.Scholarship_Product_Price_Id__c;   
                            oppLineItemRate.Quantity = 1; 
                            oppLineItemRate.UnitPrice = pbe.UnitPrice * -1;
                            opportunityLineItems.add(oppLineItemRate);
                            System.debug('team reg add scholarship discount:' + oppLineItemRate);                        
                        }
                    }        
                    System.debug('opportunityLineItems:' + opportunityLineItems);   
                }
            }
        }
        
        system.debug(opportunityLineItems);
        List<OpportunityLineItem> chinaLocationFees = this.addChinaLocationFee(selectedSites);
        if(chinaLocationFees != null && !chinaLocationFees.isEmpty()){
            opportunityLineItems.addAll(chinaLocationFees);  
        }
        system.debug(opportunityLineItems);
        List<OpportunityLineItem> chinaDataFees = this.addChinaDataFee(selectedSites);
        if(chinaDataFees != null && !chinaDataFees.isEmpty()){
            opportunityLineItems.addAll(chinaDataFees);  
        }
        system.debug(opportunityLineItems);
        List<OpportunityLineItem> processingFees = super.addProcessingFee(registrationRequest.lead);
        if(processingFees != null && !processingFees.isEmpty()){
            opportunityLineItems.addAll(processingFees);
        }
        system.debug(opportunityLineItems);
        List<OpportunityLineItem> scholarshipDiscounts = super.addScholarshipDiscounts(contactId, examGroupId, selectedExams);
        if(scholarshipDiscounts != null && !scholarshipDiscounts.isEmpty()){
            opportunityLineItems.addAll(scholarshipDiscounts);
        }
        system.debug(opportunityLineItems);
        return opportunityLineItems;

    }

    public FrmRegistrationForm() {
        super.registrationType = ExamRegistrationForm.RegistrationTypes.FRM;
    }

}