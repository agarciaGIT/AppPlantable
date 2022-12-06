public class ScrExamRegistrationForm extends ExamRegistrationForm{

    
    public RegistrationEligibility getExamEligibility(String inContactId) {
        
        Set<String> eligibleExams = new Set<String>();
        
        Boolean isInProgram = False;        
        Boolean isOpenOrder = False;
        Boolean isPart1Passed = False;
        Boolean isPart1RegisteredInActiveAdmin = False;
        Boolean isPart1RegisteredAwaitingResults = False;
        Boolean isPart1Deferred = False;

        Boolean isRegistrationOpen = False;      
        Boolean isPaymentBlocked = False; 
        
        Exam_Attempt__c part1EA;
                
        List<Exam_Administration__c> lstAdmins = [select Id, Name, Registration_Start_Date__c, Registration_End_Date__c 
                                                  from Exam_Administration__c
                                                  where Exam_Type__c = 'SCR' AND Registration_Start_Date__c <= TODAY AND Registration_End_Date__c >= TODAY];
        // Exam Admins where reg is open
        Map<String,Exam_Administration__c> mapActiveExamAdmins = new Map<String,Exam_Administration__c>();
        if(!lstAdmins.isEmpty()) {
            isRegistrationOpen = true;
            for(Exam_Administration__c ea :lstAdmins) {
                mapActiveExamAdmins.put(ea.id, ea);
            }
            
        }
        
        //List<Exam_Group__c> lstExamGroup = [select Id, Name, Registration_Start_Date__c, Last_Date_For_Late_Registration__c from Exam_Group__c where SCR_Active__c = True];
        //if(lstExamGroup != NULL && lstExamGroup.size() > 0) {
        //    Exam_Group__c eg = lstExamGroup[0];
        //    Date tdy = Date.today();
        //    if(tdy >= eg.Registration_Start_Date__c && tdy <= eg.Last_Date_For_Late_Registration__c) {
        //        isRegistrationOpen = true;
        //    }
        //}
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
                }
            }
           
            System.debug('isInProgram:' + isInProgram);
            System.debug('isPart1Passed:' + isPart1Passed);
        
            //system.assert(false, 'BOOM!5'+ isPart2Passed);
            
            List<Account> lstAcct = [select Id, Block_Purchases_All_Types__c from Account where id = :this.validatedUser.user.AccountId];
            if(!lstAcct.isEmpty()) {
                isPaymentBlocked = lstAcct[0].Block_Purchases_All_Types__c;
            }
            
            List<Exam_Attempt__c> examRegistrations = [
                SELECT Id, Candidate_Commitment__r.EndDate, Candidate_Commitment__r.Last_Exam_Registration_Date__c, 
                Candidate_Commitment__r.RecordType.Name, Contract_End_Date__c, Defered__c, 
                Exam_Administration__c,
                Exam_Administration__r.Exam_Results_Loading__c,
                Exam_Site__r.Exam__r.Exam__c,
                Exam_Part__c, Exam_Part__r.Exam_Part_Number__c, Exam_Part__r.Exam_Date__c, Exam_Part__r.Exam_Start_Date__c,
                Opportunity_StageName__c, Member__c, Exam_Date__c, Exam_Site__c, Exam_Site__r.Exam__r.Exam_Group__r.SCR_Active__c,
                Exam_Site__r.Exam__r.Exam_Group__r.Loading_Exam_Results__c, Exam_Site__r.site__c, Section__c, Result__c, Candidate_Commitment__c, 
                Candidate_Commitment__r.Status, Member__r.Account.Block_Purchases_All_Types__c 
                FROM Exam_Attempt__c 
                WHERE 
                (Candidate_Commitment__r.Status LIKE '%Activated%' OR Candidate_Commitment__r.Status = : 'Completed' OR Candidate_Commitment__r.Status = : 'Draft') AND 
                Member__c = :contactId AND 
                (Opportunity_StageName__c = 'Closed' OR Opportunity_StageName__c = 'New Lead') AND 
                Candidate_Commitment__r.RecordType.Name in ('SCR Program') AND 
                Cancelled__c != true 
                ORDER BY Exam_Date__c DESC
            ];
    
            System.debug('examRegistrations:' + examRegistrations);
            
            Integer cntDeferred=0;
            Integer cntActive=0;
            
            for (Exam_Attempt__c objFRMEA: examRegistrations) {
                
                System.debug('objFRMEA:' + objFRMEA);
                
                if(objFRMEA.Candidate_Commitment__r.RecordType.Name == 'SCR Program') {
                    
                    if(objFRMEA.Candidate_Commitment__r.Status == 'Draft' || objFRMEA.Opportunity_StageName__c == 'New Lead')  {
                        isOpenOrder = True;
                        
                    } else if(objFRMEA.Candidate_Commitment__r.Status != 'Completed')  {
                        
                        if(part1EA==Null && objFRMEA.Exam_Site__r.Exam__r.Exam__c == 'SCR') {
                            //if(objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.SCR_Active__c == True) {
                            if(mapActiveExamAdmins.get(objFRMEA.Exam_Administration__c) != NULL) {
                                isPart1RegisteredInActiveAdmin = True;
                                isPart1RegisteredAwaitingResults = False;
                                part1EA = objFRMEA;
                            }
                            if(objFRMEA.Defered__c == 'Pending') {
                                isPart1Deferred = True;
                                part1EA = objFRMEA;
                            }                            
                        }
                        
                        if(part1EA==Null && objFRMEA.Exam_Site__r.Exam__r.Exam__c == 'SCR' && mapActiveExamAdmins.get(objFRMEA.Exam_Administration__c) == NULL && 
                           (objFRMEA.Defered__c == NULL || objFRMEA.Defered__c != 'Pending') &&
                           (objFRMEA.Result__c == null || objFRMEA.Result__c == '' || objFRMEA.Exam_Administration__r.Exam_Results_Loading__c == True)) {
                               //System.debug('Rammi If Condition - Awaiting');
                               isPart1RegisteredAwaitingResults = True;
                               part1EA = objFRMEA;
                           }
                    }
                }
            }   
            
            System.debug('isPart1RegisteredInActiveAdmin:' + isPart1RegisteredInActiveAdmin);
            System.debug('isPart1RegisteredAwaitingResults:' + isPart1RegisteredAwaitingResults);
            
    
            System.debug('isPart1Deferred:' + isPart1Deferred);
            
            if(!isOpenOrder && !isPaymentBlocked) {            
                if(!isPart1Passed && !isPart1RegisteredInActiveAdmin && !isPart1RegisteredAwaitingResults && !isPart1Deferred) {
                    eligibleExams.add('SCR');
                }   
            }
        }
        System.debug('eligibleExams:' + eligibleExams);
        
        RegistrationEligibility reObj = new RegistrationEligibility();
        reObj.eligibleExams = eligibleExams;
        reObj.isRegistrationOpen = isRegistrationOpen;
        reObj.isPaymentBlocked = isPaymentBlocked;
        reObj.isInProgram = isInProgram;
        reObj.isOpenOrder = isOpenOrder;
                
        reObj.isPart1Passed = isPart1Passed;
        reObj.isPart1RegisteredInActiveAdmin = isPart1RegisteredInActiveAdmin;
        reObj.isPart1RegisteredAwaitingResults = isPart1RegisteredAwaitingResults;
        reObj.isPart1Deferred = isPart1Deferred;
                            
        return reObj;
        
    } 

    
    
    
    public override RegistrationEligibility getEligibileExams(String inContactID) {
        
        return getExamEligibility(inContactID);
        
        /*
        FINAL Id contactId = super.validatedUser.user.ContactId;

        Set<String> eligibleExams = new Set<String>();
        
        Date dtExamDate = null;
        Date examDate = super.getExamDate();
        
        Integer iDefferedCount = 0;
        Integer iActiveEA = 0;
        
        Boolean bhasRecords = false;
        Boolean bhasErp12 = false;
        Boolean bPassErp1 = false;
        
        List<Exam_Attempt__c> examRegistrations = [
            SELECT Id, Defered__c, Member__c, Contract_End_Date__c, Opportunity_StageName__c, Exam_Date__c, Candidate_Commitment__r.Last_Exam_Registration_Date__c, Exam_Site__r.Exam__r.Exam_Group__r.Active__c, Exam_Site__r.Exam__r.Exam_Group__r.Loading_Exam_Results__c,
            Exam_Site__c, Exam_Site__r.Site__c, Section__c, Result__c, Candidate_Commitment__c, Candidate_Commitment__r.Status 
            FROM Exam_Attempt__c 
            WHERE 
            (Candidate_Commitment__r.Status LIKE '%Activated%' OR Candidate_Commitment__r.Status = : 'Completed') AND 
            Member__c = :contactId AND 
            Candidate_Commitment__r.RecordType.Name = 'SCR Program' AND 
            Opportunity_StageName__c = 'Closed' AND  
            Cancelled__c != TRUE 
            ORDER BY Exam_Date__c DESC
        ];

        for (Exam_Attempt__c objERPEA: examRegistrations){
            
            // Prevent exam registration for users who have an associated exam registration who's related exam group results are being loaded
            if(objERPEA.Exam_Site__r.Exam__r.Exam_Group__r.Loading_Exam_Results__c){
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
            
            if (objERPEA.Section__c.indexOf('SCR') >= 0 && (objERPEA.Result__c == 'Pass' || objERPEA.Result__c == null|| objERPEA.Result__c == '')){
                
                eligibleExams.clear();                
                bhasErp12 = true;
                break;
                
            }else if (objERPEA.Section__c == 'SCR'){
                
                if (objERPEA.Result__c == 'Pass' || objERPEA.Result__c == ''|| objERPEA.Result__c == null) {
                    bhasErp12 = true;
                    break;
                } else if ((objERPEA.Result__c != null) && objERPEA.Result__c != 'Pass' || objERPEA.Result__c == 'No-Show') {
                    eligibleExams.clear();
                    eligibleExams.add('SCR');
                }
                
            }            
        }
        
        if(iDefferedCount == iActiveEA && iDefferedCount > 0){
            eligibleExams.clear();
        }else  if (bhasErp12 && (iDefferedCount != iActiveEA)){
            eligibleExams.clear();
        }else if(!bhasRecords) {
            eligibleExams.add('SCR');
        }
        
        RegistrationEligibility reObj = new RegistrationEligibility();
        reObj.eligibleExams = eligibleExams;
        
        return reObj;
        */
    }

    public override ExamSelectionOptions getExamSelectionOptions(){

        Set<String> examPartNames = new Set<String>{'SCR'};

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

        System.debug('User:' + this.ValidatedUser); 
            
        Map<Id, ExamSelectionOptions.ExamPricebookEntry> examPricebookEntries = super.getExamPricebookEntries(exams);

        ExamSelectionOptions eso = new ExamSelectionOptions(examSitesMap, examPricebookEntries);

        eso.createExamsArray();
        eso.createOptionsArray();

        return eso;

    }

    public override Map<String, Item> getFeesMap(){
        
        Set<String> productCodes = new Set<String>{'PRFEE', 'CDNTAX', 'MEMI'};
        
        Map<Id, PricebookEntry> pricebookEntries = new Map<Id, PricebookEntry>();
        for(String productCode: productCodes){
            if(super.pricebookEntries.pricebookEntryByProductCode.containsKey(productCode)){
                PricebookEntry pbe = super.pricebookEntries.pricebookEntryByProductCode.get(productCode);
                pricebookEntries.put(pbe.Id, pbe);
            }
        }
      
        //The unit price of these fees/discounts are dynamically computed
        //PricebookEntry enrollmentFee = super.getEnrollmentFee();
        //if(enrollmentFee != null){
        //    pricebookEntries.put(enrollmentFee.Id, enrollmentFee);
        //}  
                
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

        Set<String> productCodes = new Set<String>{'PRFEE', 'MEMI', 'CDNTAX'};
        if(super.validatedUser.isCertified) {
            productCodes.add('MEMC');
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
        System.Debug('getScholarshipDiscount:' + scholarshipDiscount);
        
        
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
        
        return examPartNumbers;

    }

    public override List<PricebookEntry> getStudyMaterials(Set<Integer> examPartNumbers){
                
        Set<String> productCodes = new Set<String>();
        
        productCodes.add('SCRH');
        productCodes.add('SCRX');
        productCodes.add('SCRCN');
        // AG: 11/2/2022 - Add BenchPrep
        productCodes.add('SCRBP');
        
        
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
            RecordType.Name = 'SCR Program' AND
            (Status LIKE 'Activated%' OR Status = 'Completed')
            LIMIT 1
        ];
              
        Contract contract = (contracts.isEmpty()) ? null : contracts[0];
        
        return contract;
        
    }

    public override Contract createExamContract(Id accountId, Id contactId, Id opportunityId, List<Selection> selections){
        
        
        Contact cont = [select Id, Name, Email, FirstName,LastName, Phone, MailingAddress, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet from Contact where Id = :contactId];
        Account acct = [select Id, Name, BillingCity, BillingCountry, BillingState, BillingStreet, BillingPostalCode  from Account where id = :accountId];
        
        Contract examContract = new Contract(
            AccountId = accountId,
            Opportunity__c = opportunityId,
            CustomerSignedId = contactId,
            StartDate = System.Today(),
            ContractTerm = 48,
            Member_Email__c = cont.Email,
            Pearson_Member_First_Name__c = cont.FirstName,
            Pearson_Member_Last_Name__c = cont.LastName,
            Pearson_Phone_No__c = cont.Phone,
            BillingStreet = acct.BillingStreet,
            BillingCity = acct.BillingCity,
            BillingCountry = acct.BillingCountry,
            BillingState = acct.BillingState,
            BillingPostalCode = acct.BillingPostalCode 
        );
        
        if(selections != NULL && selections.size() > 0 && selections[0].examPart != NULL && selections[0].examPart.examPart != NULL) {
            Exam_Part__c ep = selections[0].examPart.examPart;
            if(ep.Exam_Start_Date__c != NULL) {
                examContract.SCR_Start_Date__c = ep.Exam_Start_Date__c;
                examContract.SCR_End_Date__c = ep.Exam_End_Date__c;
            } else {
                examContract.SCR_Start_Date__c = ep.Exam_Date__c;
                examContract.SCR_End_Date__c = ep.Exam_Date__c;
            }
        }
        
        examContract.RecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'SCR Program');
            
        INSERT examContract;
        
        return examContract;      
        
    }

    public override Map<String, Candidate_Requirement__c> createExamContractRequirementsByExamMap(Id contractId, String email) {
        
        //Id examRecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Exam');
        //Id jobExperienceRecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Job Experience');
        
        Map<String, Candidate_Requirement__c> candidateRequirementsByExamMap = new Map<String, Candidate_Requirement__c>();
        
        /*
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
        */
        
        return candidateRequirementsByExamMap;
        
    }

    public override Map<String, Candidate_Requirement__c> getExamContractRequirementsByExamMap(Id contractId){
                
        Map<String, Candidate_Requirement__c> candidateRequirementsByExamMap = new Map<String, Candidate_Requirement__c>();
        
        return candidateRequirementsByExamMap;
        
    }

    public override List<OpportunityLineItem> stageOpportunityLineItems(RegistrationRequest registrationRequest){

        FINAL Id contactId = super.validatedUser.user.ContactId;
        FINAL Id examGroupId = super.examGroup.Id;
        Decimal shippingFee=0;
        
        List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();
        
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
                        shippingFee+=shippingOli.UnitPrice;
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
                        shippingFee+=shippingOli.UnitPrice;
                    }
                    system.debug('opportunityLineItems:' + opportunityLineItems);
                }
            }
            
        }
        
        List<ExamSelectionOptions.Exam> selectedExams = new List<ExamSelectionOptions.Exam>();
        Set<ID> examIds = new Set<ID>();
        for(Selection selection: registrationRequest.selections){
            selectedExams.add(selection.exam);
            examIds.add(selection.exam.id);
        }

        List<OpportunityLineItem> studyMaterials = super.addStudyMaterials(registrationRequest.products);
        if(studyMaterials != null && !studyMaterials.isEmpty()){
            opportunityLineItems.addAll(studyMaterials);
        }
        
        List<OpportunityLineItem> taxesAndDuty = super.addTaxAndDuty(opportunityLineItems, registrationRequest.lead, shippingFee);
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
        
        // Check if bought membership - if so use Member or Certified Rates
        Boolean boughtMembership = false;
        for(String pc :registrationRequest.products.keySet()) {
            if(pc == 'MEMI' || pc == 'MEMC') {
                boughtMembership = true;
            }
        }
        
        System.debug('boughtMembership:' + boughtMembership);
        
        List<Exam_Rate__c> lstExamRates = [
            SELECT Id, Name, Exam__c, Rate_Type__c, Exam__r.Exam__c, Exam__r.Name, Exam__r.Administration_Time_of_Day__c, Product__c, Product__r.Name, Product__r.ProductCode
            FROM Exam_Rate__c 
            WHERE 
            Exam__c IN :examIds AND
            Exam_Registration_Window__r.Exam_Group__r.RecordType.Name in ('SCR') AND
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
            mapExamRates.put(er.Rate_Type__c,er);
        }

        System.debug('mapExamRates:' + mapExamRates);
        
        Map<String, Team_Registration_Products__c> mapCustTeamProds = Team_Registration_Products__c.getAll();
        Map<String, Team_Registration_Products__c> mapTeamProds = new Map<String, Team_Registration_Products__c>();
        if(teamRegistration != NULL && mapCustTeamProds != NULL) {
            for(Team_Registration_Products__c trp :mapCustTeamProds.values()) {
                mapTeamProds.put(trp.Product_Code__c + '~' + trp.GL_Code__c, trp);
            }
        }
        System.debug('mapTeamProds:' + mapTeamProds);
        
        Exam_Rate__c selRate = mapExamRates.get('Non-Member');
                
        if(super.validatedUser != NULL && super.validatedUser.isCertified) {
            selRate = mapExamRates.get('Certified');
        } else if(boughtMembership || super.validatedUser.isMember || (teamRegistration != null && teamRegistration.Free_Membership__c)) {
            selRate = mapExamRates.get('Member');
        }
        
        // Get Programs to Compute Retake
        List<Contract> lstCont = [SELECT Id, Name, RecordTypeId, RecordType.Name,
                                  Eligible_For_Scr_Discount__c, Eligible_For_Scr_Discount_Date__c
                FROM Contract 
                WHERE 
                AccountId = :this.validatedUser.AccountId AND 
                RecordType.Name = 'SCR Program' AND
                Status = 'Expired' order By StartDate DESC
                ];
        if(lstCont != NULL && lstCont.size() > 0) {
            Contract objCon = lstCont[0];
            if(objCon.Eligible_For_Scr_Discount__c && objCon.Eligible_For_Scr_Discount_Date__c!=null && system.today()<=objCon.Eligible_For_Scr_Discount_Date__c) {
                selRate = mapExamRates.get('Retake');
            }
        }        
        
        
        System.debug('selRate:' + selRate);
        
        PricebookEntry pbe = PricebookEntries.pricebookEntryByProductId.get(selRate.Product__c);
        
        System.debug('pbe:' + pbe);
        
        // super.validatedUser.isMember
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
                
                System.debug('Replace team reg products:' + teamRegistration);                
                
                oli.Product2Id = fndTeamProd.Replacement_Product_Id__c;
                oli.PricebookEntryId = fndTeamProd.Replacement_Product_Price_Id__c;
                
                System.debug('oli:' + oli);
            }
            
            opportunityLineItems.add(oli); 
            
            // AG 5/27/2022 - Add team discount
            if(fndTeamProd != NULL && (teamRegistration.Discounted_Price__c != NULL || teamRegistration.Is_Scholarship__c)) {
                
                
                System.debug('Discount team reg products:' + teamRegistration);          
                
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
            
            // Free membership
            if(teamRegistration != null && teamRegistration.Free_Membership__c) {
                oli = super.getTeamRegMembershipLineItem();
                if(oli != NULL) {
                    opportunityLineItems.add(oli); 
                }
            }
            
        }        
        
        System.debug('stageOpportunityLineItems opportunityLineItems:' + opportunityLineItems);
        
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

    public ScrExamRegistrationForm() {
        System.Debug('*** Contruct ScrExamRegistrationForm');
    
        super.registrationType = ExamRegistrationForm.RegistrationTypes.SCR;
        super.examGroup = super.fetchExamGroup();
        
        System.Debug('*** super.registrationType:' + super.registrationType);
        System.Debug('*** super.examGroup :' + super.examGroup );        
    }

}