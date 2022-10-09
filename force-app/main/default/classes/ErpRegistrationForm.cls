public class ErpRegistrationForm extends ExamRegistrationForm{
    
    public RegistrationEligibility getExamEligibility(String inContactId) {
        Set<String> eligibleExams = new Set<String>();
        
        Boolean isInProgram = False;
        Boolean isRegistrationOpen = False;  
        
        Boolean isFRMRegistered = False;
        Boolean isFRMPart1AwaitingResults = False;
        Boolean isFRMPart2AwaitingResults = False;
        Boolean isFRMOpenOrder = False;
        
        Exam_Attempt__c part1FRM;
        Exam_Attempt__c part2FRM;
                
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
                        if(cr.RecordType.Name == 'Exam' && cr.Exam__c == 'ERP Part I' && cr.Status__c == 'Completed') {
                            isPart1Passed = True;
                        } else if(cr.RecordType.Name == 'Exam' && cr.Exam__c == 'ERP Part II' && cr.Status__c == 'Completed') {
                            isPart2Passed = True;
                        }
                    }
                }
            }
           
            System.debug('isInProgram:' + isInProgram);
            System.debug('isPart1Passed:' + isPart1Passed);
            System.debug('isPart2Passed:' + isPart2Passed);
            
            List<Exam_Part__c> parts = [select Id, Name, Exam_Part_Number__c, Exam__r.Exam__c,
                                        Exam_Administration__c, Exam_Date__c, Exam_Start_Date__c
                                        from Exam_Part__c where Exam_Administration__r.Exam_Group__r.Active__c = True
                                       AND Exam__r.Exam__c in ('ERP Exam Part I','ERP Exam Part II')];
            MAP<String,Exam_Part__c> mapParts = new MAP<String,Exam_Part__c>();
            for(Exam_Part__c p :parts) {
                String key = p.Exam_Administration__c + ':' + p.Exam_Part_Number__c;
                mapParts.put(key,p);
                
                if(p.Exam__r.Exam__c == 'ERP Exam Part I') {
                    isPart1Offered = True;
                } else if(p.Exam__r.Exam__c == 'ERP Exam Part II') {
                    isPart2Offered = True;
                }
            }
            System.debug('mapParts:' + mapParts);
            
            System.debug('isPart1Offered:' + isPart2Passed);
            System.debug('isPart2Offered:' + isPart2Passed);
            
            //system.assert(false, 'BOOM!5'+ isPart2Passed);
            
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
                
                if(objFRMEA.Candidate_Commitment__r.RecordType.Name == 'FRM Program') {
                    
                    if(objFRMEA.Candidate_Commitment__r.Status == 'Draft')  {
                        isFRMOpenOrder = True;
                        
                    } else if(objFRMEA.Candidate_Commitment__r.Status != 'Completed')  {
                        
                        if(objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c == True && (objFRMEA.Defered__c == NULL || objFRMEA.Defered__c != 'Pending')) {
                            isFRMRegistered = True;
                            part1FRM=objFRMEA;
                            part2FRM=objFRMEA;
                        }
                        
                        if(part1FRM==NULL && objFRMEA.Exam_Site__r.Exam__r.Exam__c == 'FRM Part 1' && objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c == False && 
                           (objFRMEA.Defered__c == NULL || objFRMEA.Defered__c != 'Pending') &&
                           (objFRMEA.Result__c == null || objFRMEA.Result__c == '' || objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.Loading_Exam_Results__c == True || objFRMEA.Exam_Administration__r.Exam_Results_Loading__c == True)) {
                               isFRMPart1AwaitingResults = True;
                               part1FRM=objFRMEA;
                           }
                        
                        if(part2FRM==NULL && objFRMEA.Exam_Site__r.Exam__r.Exam__c == 'FRM Part 2' && objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c == False && 
                           (objFRMEA.Defered__c == NULL || objFRMEA.Defered__c != 'Pending') &&
                           (objFRMEA.Result__c == null|| objFRMEA.Result__c == '' || objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.Loading_Exam_Results__c == True || objFRMEA.Exam_Administration__r.Exam_Results_Loading__c == True)) {
                               isFRMPart2AwaitingResults = True;
                               part2FRM=objFRMEA;
                           }
                    }
                }
                
                if(objFRMEA.Candidate_Commitment__r.RecordType.Name == 'ERP Program') {
                    
                    if(objFRMEA.Candidate_Commitment__r.Status == 'Draft')  {
                        isOpenOrder = True;
                        
                    } else if(objFRMEA.Candidate_Commitment__r.Status != 'Completed')  {
                        
                        if(part1EA==Null && objFRMEA.Exam_Site__r.Exam__r.Exam__c == 'ERP Exam Part I') {
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
                        if(part2EA==Null && objFRMEA.Exam_Site__r.Exam__r.Exam__c == 'ERP Exam Part II') {
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
                        
                        if(part1EA==Null && objFRMEA.Exam_Site__r.Exam__r.Exam__c == 'ERP Exam Part I' && objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c == False && 
                           (objFRMEA.Defered__c == NULL || objFRMEA.Defered__c != 'Pending') &&
                           (objFRMEA.Result__c == null || objFRMEA.Result__c == '' || objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.Loading_Exam_Results__c == True || objFRMEA.Exam_Administration__r.Exam_Results_Loading__c == True)) {
                               isPart1RegisteredAwaitingResults = True;
                               part1EA = objFRMEA;
                           }
                        
                        if(part2EA==Null && objFRMEA.Exam_Site__r.Exam__r.Exam__c == 'ERP Exam Part II' && objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c == False && 
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
            
            System.debug('isFRMRegistered:' + isFRMRegistered);
            System.debug('isFRMPart1AwaitingResults:' + isFRMPart1AwaitingResults);
            System.debug('isFRMPart2AwaitingResults:' + isFRMPart2AwaitingResults);
    
            System.debug('isPart1Deferred:' + isPart1Deferred);
            System.debug('isPart2Deferred:' + isPart2Deferred);
            
            // Per Vivek allow Awaiting Results for FRM to reg
            // && !isFRMPart1AwaitingResults && !isFRMPart2AwaitingResults
            if(!isFRMRegistered && !isFRMOpenOrder && !isOpenOrder) {
                
                if(!isPart1Passed && isPart1Offered && !isPart1RegisteredInActiveGroup && !isPart1RegisteredAwaitingResults && !isPart2RegisteredAwaitingResults && !isPart1Deferred && !isPart2Deferred) {
                    // AG 11/23/2020
                    // Remove ERP Part I - Program is Ending
                    //eligibleExams.add('ERP Exam Part I');
                }   
                if(isPart1Passed && !isPart2Passed && isPart2Offered && !isPart2RegisteredInActiveGroup && !isPart1RegisteredAwaitingResults && !isPart2RegisteredAwaitingResults && !isPart1Deferred && !isPart2Deferred) {
                    
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
                                            eligibleExams.add('ERP Exam Part II');
                                        } else {
                                            Date p1 = (fndPart1.Exam_Date__c != NULL) ? fndPart1.Exam_Date__c : fndPart1.Exam_Start_Date__c;
                                            Date p2 = (fndPart2.Exam_Date__c != NULL) ? fndPart2.Exam_Date__c : fndPart2.Exam_Start_Date__c;
                                            
                                            System.debug('p1:' + p1);
                                            System.debug('p2:' + p2);
                                            
                                            if(p1 != NULL && p1 != NULL && p2 >= p1) {
                                                eligibleExams.add('ERP Exam Part II');
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        eligibleExams.add('ERP Exam Part II');    
                    }
                    
                }   
            }
        }
        System.debug('eligibleExams:' + eligibleExams);
        
        RegistrationEligibility reObj = new RegistrationEligibility();
        reObj.eligibleExams = eligibleExams;
        reObj.isRegistrationOpen = isRegistrationOpen;
        reObj.isInProgram = isInProgram;
        reObj.isOtherRegistered = isFRMRegistered;
        reObj.isOtherPart1AwaitingResults = isFRMPart1AwaitingResults;
        reObj.isOtherPart2AwaitingResults = isFRMPart2AwaitingResults;
        reObj.isOtherOpenOrder = isFRMOpenOrder;               
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
    
    public override RegistrationEligibility getEligibileExams(String inContactID) {
        
        return getExamEligibility(inContactID);
        
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
        Boolean bhasErp12 = false;
        Boolean bErp1 = false;
        Boolean bErp2 = false;
        Boolean bPassErp1 = false;
        Boolean bhasFRM = false;
        Integer frmActive = 0;
        Integer frmDeferred = 0;

        
        List<Exam_Part__c> parts = [select Id, Name, Exam_Part_Number__c, Exam_Administration__c, Exam_Administration__r.Exam_Date__c, Exam_Administration__r.Exam_Start_Date__c
                                    from Exam_Part__c where Exam_Administration__r.Exam_Group__r.Active__c = True];
        MAP<String,Exam_Part__c> mapParts = new MAP<String,Exam_Part__c>();
        for(Exam_Part__c p :parts) {
            String key = p.Exam_Administration__c + ':' + p.Exam_Part_Number__c;
            mapParts.put(key,p);
        }
        
        System.debug('mapParts:' + mapParts);
        
        
        List<Exam_Attempt__c> examRegistrations = [
            SELECT Id, Defered__c, Member__c, Contract_End_Date__c, Opportunity_StageName__c, Exam_Date__c, Candidate_Commitment__r.RecordType.Name,
            Candidate_Commitment__r.Last_Exam_Registration_Date__c, Exam_Site__r.Exam__r.Exam_Group__r.Active__c, Exam_Site__r.Exam__r.Exam_Group__r.Loading_Exam_Results__c,
            Exam_Site__c, Exam_Site__r.Site__c, Section__c, Result__c, Candidate_Commitment__c, Candidate_Commitment__r.Status 
            FROM Exam_Attempt__c 
            WHERE 
            (Candidate_Commitment__r.Status LIKE '%Activated%' OR Candidate_Commitment__r.Status = : 'Completed') AND 
            Member__c = :contactId AND 
            Candidate_Commitment__r.RecordType.Name in ('FRM Program','ERP Program') AND 
            Opportunity_StageName__c = 'Closed' AND  
            Cancelled__c != TRUE 
            ORDER BY Exam_Date__c DESC
        ];

        for (Exam_Attempt__c objERPEA: examRegistrations){
            
            System.debug('objERPEA:' + objERPEA);

            if(objERPEA.Candidate_Commitment__r.RecordType.Name == 'FRM Program') {
                if(objERPEA.Defered__c == 'Pending') {
                    frmDeferred=frmDeferred+1;
                }
                
                if(objERPEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c) {
                    frmActive=frmActive+1;
                } 
                continue;
            }
            
            // Prevent exam registration for users who have an associated exam registration who's related exam group results are being loaded
            if(objERPEA.Exam_Site__r.Exam__r.Exam_Group__r.Loading_Exam_Results__c){
                return null;
            }
            
            // Check 4 year expiration window
            if (                
                objERPEA.Candidate_Commitment__r.Status == 'Activated' && 
                objERPEA.Candidate_Commitment__r.Last_Exam_Registration_Date__c != null &&
                objERPEA.Candidate_Commitment__r.Last_Exam_registration_Date__c.year()  <= ExamDate.year() &&
                objERPEA.Candidate_Commitment__r.Last_Exam_registration_Date__c.month() != ExamDate.month() &&
                objERPEA.Candidate_Commitment__r.Last_Exam_registration_Date__c.month() <= ExamDate.month()
            ){
                return null;
            }
            
            if (objERPEA.Candidate_Commitment__r.Status == 'Completed'){
                return null;
            }
            
            bhasRecords = true;
            
            if (dtExamDate == null){
                dtExamDate = objERPEA.Exam_Date__c;
            }
            
            if (objERPEA.Defered__c == 'Pending'){
                iDefferedCount += 1;
            }
            
            if (objERPEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c){
                iActiveEA += 1;
            }
            
            if (objERPEA.Section__c.indexOf('ERP Exam Part II') >= 0 && (objERPEA.Result__c == 'Pass' || objERPEA.Result__c == null|| objERPEA.Result__c == '')){
                
                eligibleExams.clear();
                
                bhasErp12 = true;
                bErp2 = true;
                break;
                
            }else if (objERPEA.Section__c == 'ERP' && !bErp1 && !bErp2){
                
                if (objERPEA.Result__c == 'Pass' || objERPEA.Result__c == ''|| objERPEA.Result__c == null) {
                    bhasErp12 = true;
                    break;
                } else if ((objERPEA.Result__c != null) && objERPEA.Result__c != 'Pass' || objERPEA.Result__c == 'No-Show') {
                    eligibleExams.clear();
                    eligibleExams.add('ERP Exam Part I');
                    eligibleExams.add('ERP Exam Part II');
                }
                
            }else if (objERPEA.Section__c.indexOf('ERP Exam Part I') >= 0){
                
                bErp1 = true;
                
                if (objERPEA.Result__c == null && !objERPEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c) {
                    eligibleExams.clear();
                } else if ((objERPEA.Result__c != null) && objERPEA.Result__c != 'Pass' || objERPEA.Result__c == 'No-Show') {
                    eligibleExams.clear();
                    if(bPassErp1==false){
                        eligibleExams.add('ERP Exam Part I');
                    }
                    eligibleExams.add('ERP Exam Part II');
                } else if ((objERPEA.Result__c == 'Pass' || objERPEA.Result__c == null)) {
                    bPassErp1=true;         
                    eligibleExams.clear();  
                    eligibleExams.add('ERP Exam Part II');  
                }
                
            }
            
        }

        System.debug('eligibleExams:' + eligibleExams);
        
        System.debug('frmActive:' + frmActive);
        System.debug('frmDeferred:' + frmDeferred);
        
        if(frmActive > 0 && frmActive > frmDeferred) {
            eligibleExams.clear();
        } else if(iDefferedCount == iActiveEA && iDefferedCount > 0){
            eligibleExams.clear();
        }else  if (bhasErp12 && (iDefferedCount != iActiveEA)){
            eligibleExams.clear();
        }else if(!bhasRecords) {
            eligibleExams.add('ERP Exam Part I');
            eligibleExams.add('ERP Exam Part II');
        }
        
        System.debug('eligibleExams final:' + eligibleExams);
        
        return eligibleExams;
        */
    }

    public override ExamSelectionOptions getExamSelectionOptions(){

        Set<String> examPartNames = new Set<String>{'ERP Exam Part I', 'ERP Exam Part II'};

        Map<Id, Exam_Sites__c> examSitesMap = super.getExamSitesMap(examPartNames);

        Set<Id> exams = new Set<Id>();
        for(Exam_Sites__c es: examSitesMap.values()){
            exams.add(es.Exam__c);
        }

        Map<Id, ExamSelectionOptions.ExamPricebookEntry> examPricebookEntries = super.getExamPricebookEntries(exams);
            
        ExamSelectionOptions eso = new ExamSelectionOptions(examSitesMap, examPricebookEntries);
        
        eso.createExamsArray();
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

        ExamSelectionOptions eso = new ExamSelectionOptions(examSitesMap, examPricebookEntries);

        eso.createExamsArray();
        eso.createOptionsArray();

        return eso;

    }

    public override Map<String, Item> getFeesMap(){
        
        Set<String> productCodes = new Set<String>{'PRFEE', 'MEMF', 'CDNTAX'};
        
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
            if(examName == 'ERP Exam Part I'){
                examPartNumbers.add(1);
            }else if(examName == 'ERP Exam Part II'){
                examPartNumbers.add(2);
            }
        }
        return examPartNumbers;

    }

    public override List<PricebookEntry> getStudyMaterials(Set<Integer> examPartNumbers){
                
        Set<String> productCodes = new Set<String>();
        
        for(Integer i: examPartNumbers){
            productCodes.add('ENC' + i + 'B');
            productCodes.add('ENC' + i + 'X');
            productCodes.add('ENCC' + i);
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
            RecordType.Name = 'ERP Program' AND
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
        
        examContract.RecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'ERP Program');
            
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
            Name = 'Pass ERP1',
            Exam__c = 'ERP Part I',
            Status__c = 'Initial',
            RecordTypeID = examRecordTypeID,
            Prerequisite__c = null
        );
        
        INSERT candidateExamPartIRequirement;
        
        Candidate_Requirement__c candidateExamPartIIRequirement = new Candidate_Requirement__c(
            Candidate_Commitment__c = contractId,
            Candidate_Email__c = email,
            Name = 'Pass ERP2',
            Exam__c = 'ERP Part II',
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
            WHERE Candidate_Commitment__c = :contractId AND Exam__c LIKE '%ERP%'
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
        
        //Add shipping to opportunity line items
        if(!registrationRequest.products.isEmpty()){
            
            Set<Id> pricebookEntryIds = new Set<Id>();
            for(Item item: registrationRequest.products.values()){
                pricebookEntryIds.add(item.pricebookEntry.Id);
            }

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

        List<OpportunityLineItem> studyMaterials = super.addStudyMaterials(registrationRequest.products);
        if(studyMaterials != null && !studyMaterials.isEmpty()){
            opportunityLineItems.addAll(studyMaterials);
        }
        
        List<OpportunityLineItem> taxesAndDuty = super.addTaxAndDuty(opportunityLineItems, registrationRequest.lead);
        if(taxesAndDuty != null && !taxesAndDuty.isEmpty()){
            opportunityLineItems.addAll(taxesAndDuty);
        }  
        
        List<OpportunityLineItem> enrollmentAndMembershipFees = super.addEnrollmentAndMembershipFee();
        if(enrollmentAndMembershipFees != null && !enrollmentAndMembershipFees.isEmpty()){
            opportunityLineItems.addAll(enrollmentAndMembershipFees);
        }
        
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
                    opportunityLineItems.add(oli); 
                }        
                System.debug('opportunityLineItems:' + opportunityLineItems);   
            }

        }
        
        List<OpportunityLineItem> processingFees = super.addProcessingFee(registrationRequest.lead);
        if(processingFees != null && !processingFees.isEmpty()){
            opportunityLineItems.addAll(processingFees);
        }
        
        List<OpportunityLineItem> scholarshipDiscounts = super.addScholarshipDiscounts(contactId, examGroupId, selectedExams);
        if(scholarshipDiscounts != null && !scholarshipDiscounts.isEmpty()){
            opportunityLineItems.addAll(scholarshipDiscounts);
        }
        
        return opportunityLineItems;

    }

    public ErpRegistrationForm() {
        super.registrationType = ExamRegistrationForm.RegistrationTypes.ERP;
    }

}