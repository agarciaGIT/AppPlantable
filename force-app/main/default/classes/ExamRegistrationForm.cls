public abstract class ExamRegistrationForm {

    @TestVisible private static User runAsUser = null;

    @TestVisible public Boolean disableManualRollback { get; private set; }
    @TestVisible public Boolean disableCreditCardProcessing { get; private set; }

    // Properties
    public Savepoint savepoint { get; set; }
    public ValidatedUser validatedUser { get; set; }
    public PricebookEntries pricebookEntries { get; set; }
    public RegistrationTypes registrationType { get; set; }

    public Exam_Group__c examGroup { get; set; }
    public Lead lead { get; set; }
    public Account account { get; set; }
    public Contact contact { get; set; }
    public Opportunity opportunity { get; set; }
    public List<Contract> programs { get; set; }
    public Team_Registration__c teamRegistration { get; set; }
    
    public abstract RegistrationEligibility getEligibileExams(String contactID);
    
    public abstract ExamSelectionOptions getExamSelectionOptions();
    public abstract ExamSelectionOptions getExamSelectionOptions(Set<String> examPartNames);

    public abstract Map<String, Item> getFeesMap();
    public abstract Map<String, Item> getFeesMapAuthenticated(List<ExamSelectionOptions.Exam> availableExams);

    public abstract Set<Integer> getExamPartNumbers(List<ExamSelectionOptions.Exam> examPartNames);
    public abstract List<PricebookEntry> getStudyMaterials(Set<Integer> examPartNumbers);
    public abstract List<OpportunityLineItem> stageOpportunityLineItems(RegistrationRequest registrationRequest);

    public abstract Contract getExamContract(Id accountId);
    public abstract Contract createExamContract(Id accountId, Id contactId, Id opportunityId, List<Selection> selections);

    public abstract Map<String, Candidate_Requirement__c> getExamContractRequirementsByExamMap(Id contractId);
    public abstract Map<String, Candidate_Requirement__c> createExamContractRequirementsByExamMap(Id contractId, String email);
    
    // Inner Class Definitions
    public Enum RegistrationTypes { FRM, ERP, SCR }

    public class RegistrationEligibility {
        
        public Set<String> eligibleExams { get; set; }
            
        public Boolean isInProgram { get; set; }
        public Boolean isRegistrationOpen { get; set; }
        public Boolean isPaymentBlocked { get; set; }
        public Boolean isOtherRegistered { get; set; }
        public Boolean isOtherPart1AwaitingResults { get; set; }
        public Boolean isOtherPart2AwaitingResults { get; set; }
        public Boolean isOtherOpenOrder { get; set; }                
        public Boolean isOpenOrder { get; set; }
        
        public Boolean isPart1Passed { get; set; }
        public Boolean isPart1Offered { get; set; }
        public Boolean isPart1RegisteredInActiveAdmin { get; set; }
        public Boolean isPart1RegisteredAwaitingResults { get; set; }
        public Boolean isPart1Deferred { get; set; }
        
        public Boolean isPart2Passed { get; set; }
        public Boolean isPart2Offered { get; set; }
        public Boolean isPart2RegisteredInActiveAdmin { get; set; }
        public Boolean isPart2RegisteredAwaitingResults { get; set; }
        public Boolean isPart2Deferred { get; set; }       
    }
    
    public class ValidatedUser{  
        public Boolean isAuthenticated  { get; set; }
        public Boolean isMember         { get; set; }
        public Boolean isCertified      { get; set; }
        public String AccountId      { get; set; }
        public User user                { get; set; }
        
        public ValidatedUser(Id userId){
            
            if(runAsUser != null){
                this.user = runAsUser;
            }else{
                this.user = [SELECT Id, ContactId, AccountId, Contact.KPI_FRM_Certified__c, Contact.KPI_ERP_Certified__c, Contact.KPI_Member__c, Contact.Membership_Type__c, Contact.KPI_Membership_Payment_Status__c FROM User WHERE Id = :userId LIMIT 1];
            }
            
            this.isAuthenticated = false;
            this.isMember = false;
            this.isCertified = false;
            this.AccountId = null;
            
            if(user.ContactId != null && user.AccountId != null){   
                this.isAuthenticated = true;
                this.AccountId = user.AccountId;
                
                if(user.Contact.KPI_Member__c && user.Contact.Membership_Type__c == 'Individual' && user.Contact.KPI_Membership_Payment_Status__c != NULL && user.Contact.KPI_Membership_Payment_Status__c == 'In Good Standing') {
                    this.isMember = true;
                }
                
                if(user.Contact.KPI_FRM_Certified__c || user.Contact.KPI_ERP_Certified__c) {
                    this.isCertified = true;
                }
                
            }else{
                this.isAuthenticated = false;
            }
            
        }
    }
    
    public class PricebookEntries{
        public Map<Id, PricebookEntry> pricebookEntryById               { get; set; }
        public Map<String, PricebookEntry> pricebookEntryByProductCode  { get; set; }
        public Map<String, PricebookEntry> pricebookEntryByProductId  { get; set; }
        
        public PricebookEntries(){
            
            this.pricebookEntryById = new Map<Id, PricebookEntry>([ 
                SELECT 
                    Id, UnitPrice, ProductCode, Product2Id, Product2.ProductCode, Product2.GL_Code__c, Product2.Name, Product2.Family, Product2.Weight__c, Product2.Taxable__c, Product2.Product_ID__c, Pricebook2.IsActive, Product2.isActive, Product2.Is_Comped_Registration__c, Product2.Exam_Part__c
                FROM PricebookEntry 
                WHERE IsActive = TRUE AND Pricebook2.IsActive = TRUE AND Product2.IsActive = TRUE
            ]);

            this.pricebookEntryByProductCode = new Map<String, PricebookEntry>();
            this.pricebookEntryByProductId = new Map<String, PricebookEntry>();
            
            for(PricebookEntry pbe: this.pricebookEntryById.values()){
                if(pbe.Product2Id != NULL) {
                    this.pricebookEntryByProductId.put(pbe.Product2Id,pbe);                    
                }
                if(pbe.ProductCode != null){
                    // Exclude duplicate ProductCodes related to deferral products
                    if(pbe.ProductCode == 'ENC' && pbe.Product2.GL_Code__c == '4020'){
                        continue;
                    }else if(pbe.ProductCode == 'FRM1' && pbe.Product2.GL_Code__c == '4020'){
                        continue;
                    }
                    this.pricebookEntryByProductCode.put(pbe.ProductCode, pbe);
                }
            }
            
        }
    }

    public class Card{
        public String expirationMonth   { get; set; }
        public String expirationYear    { get; set; }
        public String fullName          { get; set; }
        public String cardNumber        { get; set; }
        public String securityCode      { get; set; }
    }
    
    public class Shipping{
        public String currencyCode              { get; set; }
        public String guaranteedDaysToDelivery  { get; set; }
        public String label                     { get; set; }
        public String monetaryValue             { get; set; }
        public String scheduledDeliveryTime     { get; set; }
        public String serviceCode               { get; set; }
    }       
    
    public class Selection{
        public ExamSelectionOptions.Exam exam           { get; set; }
        public ExamSelectionOptions.Site site           { get; set; }
        public ExamSelectionOptions.ExamPart examPart   { get; set; }
    }

    public class Item{
        
        public String id                                    { get; set; }
        public String label                                 { get; set; }
        public Boolean comped                               { get; set; }
        public Boolean selected                             { get; set; }
        public Product2 product2                            { get; set; }    
        public Boolean purchased                            { get; set; }
        public Datetime purchasedDate                       { get; set; }   
        public PricebookEntry pricebookEntry                { get; set; }
            
        public Item(){}
        
        public Item(PricebookEntry pricebookEntry){            
            this.id = pricebookEntry.ProductCode;
            this.label = pricebookEntry.Product2.Name;
            this.comped = false;
            this.selected = false;
            this.product2 = pricebookEntry.Product2;
            this.purchased = false;
            this.purchasedDate = null;
            this.pricebookEntry = pricebookEntry;
        }
        
    }
    
    public class RegistrationRequestTeamInfo { 
        public Id teamRegistrationId                                        { get; set; }
        public Boolean agreeToDiscloseResults                               { get; set; }      
    }
        
    public class RegistrationRequest{ 
        public String token                                                 { get; set; }
        public Lead lead                                                    { get; set; }
        public String registrationType                                      { get; set; }
        public Exam_Group__c examGroup                                      { get; set; }
        public List<Selection> selections                                   { get; set; }
        public Map<String, Item> products                                   { get; set; }
        public UpsXmlRatingServiceSelectionResponse.RatedShipment shipping  { get; set; }
        public Shipping_Charge__c shippingInfo                               { get; set; }
        public RegistrationRequestTeamInfo teamRegistrationInfo             { get; set; }
    }

    public class RegistrationResponse{
        public Lead lead                                    { get; set; }         
        public Opportunity opportunity                      { get; set; }
    }

    public class ChargeRequest{      
        public String token                                 { get; set; }
        public Lead lead                                    { get; set; }
        public String registrationType                      { get; set; }
        public Card card                                    { get; set; }
        public List<Selection> selections                   { get; set; }
    }

    public class ChargeResponse{
        public Contact contact                                                      { get; set; }
        public Opportunity opportunity                                              { get; set; }
        public ChargentSFA.TChargentOperations.TChargentResult chargentResult       { get; set; }
    }

    public class ViewModel{
        public String registrationType                                              { get; set; }
        public String formKey                                                       { get; set; }
        public String token                                                         { get; set; }
        public Boolean isAuthenticated                                              { get; set; }      
        public Boolean isMember                                                     { get; set; }      
        public Boolean isCertified                                                  { get; set; }      
        public Lead lead                                                            { get; set; }
        public Contact contact                                                      { get; set; }
        public List<Institution__c> companies                                       { get; set; }
        public List<Institution__c> schools                                         { get; set; }
        public Exam_Group__c examGroup                                              { get; set; }
        public List<cdrive__Cloud_Files__c> images                                  { get; set; }
        public ExamSelectionOptions examSelectionOptions                            { get; set; }
        public Map<String, Item> availableBooks                                     { get; set; }
        public Map<String, Item> feesByProductCode                                  { get; set; }
        public Map<String, List<Schema.PicklistEntry>> picklistValuesByFieldName    { get; set; }
        public Map<String, List<String>> dynamicPicklistValuesByFieldName           { get; set; }
        public RegistrationEligibility examEligibility                              { get; set; }
        public Team_Registration__c teamRegistration                                { get; set; }
        public Boolean isPaymentBlocked                                             { get; set; }
        public Boolean isPaymentRestricted                                          { get; set; }
        
        public ViewModel(ExamRegistrationForm form){
                
            this.registrationType = form.registrationType.name();
            this.formKey = 'exam-registration-' + this.registrationType.toLowerCase();
            this.companies = form.fetchInstitutions('Organization');
            this.schools = form.fetchInstitutions('Academic');
            this.examGroup = form.fetchExamGroup();
            this.feesByProductCode = new Map<String, Item>();
            this.isAuthenticated = form.validatedUser.isAuthenticated;
            this.isMember = form.validatedUser.isMember ;
            this.isCertified = form.validatedUser.isCertified;
        }
    }
    
    public class InfoViewModel{
        public Contact contact { get; set; }
        public Map<String, List<Schema.PicklistEntry>> picklistValuesByFieldName { get; set; }
        public Map<String, List<String>> dynamicPicklistValuesByFieldName { get; set; }
        public List<Institution__c> companies { get; set; }
        public List<Institution__c> schools { get; set; }
    }
       
    /**
    * @description fetches a map of Exam Sites based on the exams the user is eligible to register for.  If the user is eligible for part 1 and part 2, we must use the Exam Parts to determine if the exams can be sold as a bundle (Part 1 + Part 2) or sold individually per Exam Administration.
    * @param examPartNames the set of exam parts by name, i.e. 'FRM Part 1' or 'ERP Exam Part 1'
    * @return the map of all Exam Sites in context
    */
    public Map<Id, Exam_Sites__c> getExamSitesMap(Set<String> examPartNames){
        
        // AG - 10/17/2022 - Updated for Exams 2023
        Map<Id, Exam_Sites__c> siteMap = new Map<Id, Exam_Sites__c>([                
            SELECT 
                Id, 
                Name,
                Exam_Part__c,
                Exam_Part__r.Exam_Administration__c, 
                Exam_Part__r.Exam__r.Exam__c,
                Exam_Part__r.Exam_Part_Number__c,
                Exam_Part__r.Exam_Date__c,
                Exam_Part__r.Exam_Start_Date__c,
                Exam_Part__r.Exam_End_Date__c,
                Exam__c, 
                Exam__r.Name,
                Exam__r.Exam__c, 
                Exam__r.Display_Name__c, 
                Site__c, 
                Site__r.Name, 
                Site__r.Is_OSTA_Information_Required__c, 
                Site__r.Is_Gender_Required__c, 
                Site__r.AM_Exam_Capacity_Available__c, 
                Site__r.PM_Exam_Capacity_Available__c 
            FROM Exam_Sites__c
            WHERE 
                Exam_Part__r.Exam__r.Exam__c IN :examPartNames AND
                Site__r.Active__c = TRUE AND 
                Site__r.Non_Selectable__c = FALSE AND 
            	Exam_Part__r.Exam_Administration__r.Registration_Start_Date__c <= TODAY AND 
            	Exam_Part__r.Exam_Administration__r.Registration_End_Date__c >= TODAY
                AND Exam_Part__r.Exam_Administration__r.Exam_Type__c in ('FRM','SCR')            
            ORDER BY Exam_Part__r.Exam_Part_Number__c, Site__r.Name ASC 
        ]);        
        return siteMap;
    }

    public Map<String, Item> createMap(List<PricebookEntry> items){
        
        Map<String, Item> output = new Map<String, Item>();
        
        for(PricebookEntry pbe :items){
            
            Item item = new Item();
            
            item.id = pbe.Id;
            item.label = pbe.Product2.Name;
            item.selected = false;
            item.product2 = pbe.Product2;
            item.pricebookEntry = pbe;
            item.purchased = false;
            item.purchasedDate = null;
            item.comped = false;
            
            if(pbe.Product2.Is_Comped_Registration__c) {
                item.comped = true;
                item.selected = true;
                item.pricebookEntry.UnitPrice = 0;
            }
/*            
            switch on pbe.ProductCode{
                when 'FRM1X'{
                    item.comped = true;
                    item.selected = true;
                    item.pricebookEntry.UnitPrice = 0;
                }
                when 'SCRX'{
                    item.comped = true;
                    item.selected = true;
                    item.pricebookEntry.UnitPrice = 0;
                }
                when else{
                    item.comped = false;
                }
            }
*/            
            output.put(pbe.Id, item);
            
        }
        
        return output;
        
    }
    
    public Map<String, Item> createMap(List<PricebookEntry> items, Id accountId){
        
        Map<String, Item> output = new Map<String, Item>();
        
        //Fetch all eBooks
        List<OpportunityLineItem> opportunityLineItems = [
            SELECT Product_ID__c, Opportunity.Last_Transaction_Paid_Date__c
            FROM OpportunityLineItem
            WHERE 
            Opportunity.AccountId = :accountId AND 
            Opportunity.StageName = 'Closed' AND 
            Product2.Electronic_Delivery__c = TRUE
        ];
        
        //Create a map of owned eBook products by unqiue Product_ID__c
        Map<String, OpportunityLineItem> productIds = new Map<String, OpportunityLineItem>();
        for(OpportunityLineItem oli: opportunityLineItems){
            if(oli.Product_ID__c != null){
                productIds.put(oli.Product_ID__c, oli);
            }
        }
        
        for(PricebookEntry pbe :items){
            
            Item item = new Item();
            
            item.id = pbe.Id;
            item.label = pbe.Product2.Name;
            item.selected = false;
            item.product2 = pbe.Product2;
            item.pricebookEntry = pbe;

            if(productIds.containsKey(pbe.Product2.Product_ID__c)){

                item.comped = false;
                item.purchased = true;
                item.purchasedDate = productIds.get(pbe.Product2.Product_ID__c).Opportunity.Last_Transaction_Paid_Date__c;

            }else{
                
                if(pbe.Product2.Is_Comped_Registration__c) {
                    item.comped = true;
                    item.selected = true;
                    item.pricebookEntry.UnitPrice = 0;
                }
                /*
                switch on pbe.ProductCode{
                    when 'FRM1X'{
                        item.comped = true;
                        item.selected = true;
                        item.pricebookEntry.UnitPrice = 0;
                    }
                    when 'SCRX'{
                        item.comped = true;
                        item.selected = true;
                        item.pricebookEntry.UnitPrice = 0;
                    }
                    when else{
                        item.comped = false;
                    }
                }
                */
                
                item.purchased = false;
                item.purchasedDate = null;
                
            }
            
            output.put(pbe.Id, item);
            
        }
        
        return output;
        
    }

    public Team_Registration__c getTeamRegistration(ID teamRegistrationId) {
        return [select Id, Name, Account__c, Account__r.Name from Team_Registration__c where Id = :teamRegistrationId];
    }
    
    public Team_Registration__c getTeamRegistration(string teamRegistrationCode) {
        
        Date tdy = Date.today();
        String examType = registrationType.name();
        List<Team_Registration__c> teamRegs = [select Id, Name, Account__c, Account__r.Name, Attestation_Required__c
                                               from Team_Registration__c 
                                               where Access_Code__c = :teamRegistrationCode AND Payment_Status__c = 'Paid' AND
                                               Start_Date__c <= :tdy AND End_Date__c >= :tdy AND Exam_Type__c = :examType AND Seats_Balance__c > 0];
        
        if(!teamRegs.isEmpty()) {
            return teamRegs[0];
        } else {
            return null;    
        }
        
    }
    
    public Map<Id, ExamSelectionOptions.ExamPricebookEntry> getExamPricebookEntries(Set<Id> examIds) {
        
        Map<Id, ExamSelectionOptions.ExamPricebookEntry> examPricebookEntries = new Map<Id, ExamSelectionOptions.ExamPricebookEntry>();
            
        System.debug('getExamPricebookEntries examIds:' + examIds);
        
        
        // Rate Type is set on Exam Registration Windows' Exam Rates
        // If there are multiple rates for the same window based on user's status
        // Must set a Rate Type for each rate
        String userRateType = 'Non-Member';
        if(this.validatedUser != NULL) {
            if(this.validatedUser.isAuthenticated) {
                if(this.validatedUser.isCertified) {
                    userRateType = 'Certified';
                } else if(this.validatedUser.isMember) {
                    userRateType = 'Member';
                }
            }
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
                userRateType = 'Retake';
            }
        }
                
        List<Exam_Rate__c> lstExamRates = [
            SELECT Id, Name, Exam__c, Rate_Type__c, Exam_Administration__c, Exam_Part__c, Exam__r.Exam__c, Exam__r.Name, Exam__r.Administration_Time_of_Day__c, 
            Product__c, Product__r.Name, Product__r.ProductCode
            FROM Exam_Rate__c 
            WHERE 
                Exam__c IN :examIds AND
                Exam_Administration__r.Exam_Type__c in ('FRM','SCR') AND
                Exam_Registration_Window__r.Exam_Registration_Window_Open__c <= TODAY AND
                Exam_Registration_Window__r.Exam_Registration_Window_Close__c >= TODAY 
            ORDER BY Product__r.ProductCode ASC
        ];
        //AND (Rate_Type__c = NULL OR (Rate_Type__c = :userRateType))
        System.debug('lstExamRates:' + lstExamRates);
        
        MAP<String,String> mapRateTypes = new MAP<String,String>();
        MAP<String,Set<Exam_Rate__c>> otherRatesProdMap = new MAP<String,Set<Exam_Rate__c>>();
        List<Exam_Rate__c> examRates = new List<Exam_Rate__c>();
        Set<Id> product2Ids = new Set<Id>();
        
        for(Exam_Rate__c er:lstExamRates) {           
            
            if(er.Rate_Type__c != NULL) {                
                mapRateTypes.put(er.Product__c, er.Rate_Type__c);
                    
                if(er.Rate_Type__c == userRateType) {
                    examRates.add(er);
                    product2Ids.add(er.Product__c);
                } else {
                    Set<Exam_Rate__c> prs = otherRatesProdMap.get(er.Exam__r.Exam__c);                    
                    if(prs == null) {
                        Set<Exam_Rate__c> nl = new Set<Exam_Rate__c>();
                        nl.add(er);
                        otherRatesProdMap.put(er.Exam__r.Exam__c, nl);
                        product2Ids.add(er.Product__c);
                    } else {
                        prs.add(er);
                        otherRatesProdMap.put(er.Exam__r.Exam__c, prs);    
                        product2Ids.add(er.Product__c);
                    }
                }
            } else {
                examRates.add(er);
                product2Ids.add(er.Product__c);
            }
        }
        System.debug('examRates:' + examRates);
        System.debug('otherRatesProdMap:' + otherRatesProdMap);
        System.debug('product2Ids:' + product2Ids);
        
        if(!examRates.isEmpty()){
            
            if(this.validatedUser.isAuthenticated){

                List<Exam_Rate_Offering__c> examRateOfferings = [
                    SELECT Id, Exam_Rate__c, Exam_Rate__r.Exam__c, Contact__c, Start_Date__c, End_Date__c, Exam_Rate__r.Id, Exam_Rate__r.Name, Exam_Rate__r.Exam__r.Exam__c, Exam_Rate__r.Exam__r.Name, Exam_Rate__r.Exam__r.Administration_Time_of_Day__c, Exam_Rate__r.Product__c, Exam_Rate__r.Product__r.Name, Exam_Rate__r.Product__r.ProductCode
                    FROM Exam_Rate_Offering__c
                    WHERE 
                    Contact__c = :this.validatedUser.user.ContactId AND
                    Start_Date__c <= TODAY AND
                    End_Date__c >= TODAY
                ];

                if(!examRateOfferings.isEmpty()){

                    Map<Id, Exam_Rate_Offering__c> examRateOfferingByExamId = new Map<Id, Exam_Rate_Offering__c>();
                    for(Exam_Rate_Offering__c ero: examRateOfferings){
                        examRateOfferingByExamId.put(ero.Exam_Rate__r.Exam__c, ero);
                    }

                    // Override Exam Rate with datamined Exam Offering Rate
                    for(Integer i = 0; i < examRates.size(); i++){
                        Exam_Rate__c examRate = examRates[i];
                        if(examRateOfferingByExamId.containsKey(examRate.Exam__c)){
                            Exam_Rate__c specialRate = examRateOfferingByExamId.get(examRate.Exam__c).Exam_Rate__r;
                            examRates.set(i, specialRate);
                        }
                    }

                }
    
            }
            System.debug('examRates final:' + examRates);
            
            for(Exam_Rate__c er: examRates){
                product2Ids.add(er.Product__c);
            }

            System.debug('product2Ids:' + product2Ids);

            Map<Id, PriceBookEntry> pricebookEntryByProduct2Id = new Map<Id, PriceBookEntry>();
            for (PriceBookEntry PricebookEntryId: [
                SELECT Pricebook2.IsActive, UnitPrice, ProductCode, Product2Id, Product2.Name, Product2.Image__c, Product_ID__c
                FROM PriceBookEntry
                WHERE IsActive = TRUE AND Product2Id IN :product2Ids AND Pricebook2.IsActive = TRUE
                ORDER BY ProductCode ASC
            ]){
                pricebookEntryByProduct2Id.put(PricebookEntryId.Product2Id, PricebookEntryId);
            }
            
            for(Exam_Rate__c er: examRates){
                
                System.debug('ER:' + er);
                
                ExamSelectionOptions.ExamPricebookEntry examPricebookEntry = new ExamSelectionOptions.ExamPricebookEntry();
                
                examPricebookEntry.id                       = er.Id;
                examPricebookEntry.exam                     = er.Exam__r;
                examPricebookEntry.priceBookEntry           = pricebookEntryByProduct2Id.get(er.Product__c);
                examPricebookEntry.rateType                 =  mapRateTypes.get(er.Product__c);
                
                Set<Exam_Rate__c> otherProducts = otherRatesProdMap.get(er.Exam__r.Exam__c);
                System.debug('otherProducts:' + otherProducts);
                
                if(otherProducts != NULL) {
                    examPricebookEntry.otherRates = new List<ExamSelectionOptions.ExamPricebookEntry>();
                    for(Exam_Rate__c p :otherProducts)  {
                        
                        System.debug('p:' + p);
                        
                        PriceBookEntry pe = pricebookEntryByProduct2Id.get(p.Product__c);                        
                        System.debug('pe:' + pe);
                        
                        if(pe != NULL) {
                            ExamSelectionOptions.ExamPricebookEntry examPricebookEntryOther = new ExamSelectionOptions.ExamPricebookEntry();
                            examPricebookEntryOther.id = er.Id;
                            examPricebookEntryOther.exam = er.Exam__r;
                            examPricebookEntryOther.priceBookEntry = pe;
                            examPricebookEntryOther.rateType = p.Rate_Type__c;

                            examPricebookEntry.otherRates.add(examPricebookEntryOther);                            
                        }
                    }
                }
                // AG - 10/18/2022 - Updated for Exams 2023
                //examPricebookEntries.put(er.Exam__c,examPricebookEntry);
                examPricebookEntries.put(er.Exam_Part__c,examPricebookEntry);
            }
            
        }

        System.debug('**examPricebookEntries:' + examPricebookEntries);

        return examPricebookEntries;
        
    }

    public List<Account> fetchCompanies(){
        
        List<Account> accounts = [
            SELECT Id, Name 
            FROM Account 
            WHERE Customer_Company_List__c = TRUE
        ];
        
        return accounts;
    }
    
    public List<Institution__c> fetchInstitutions(string type){
        
        List<Institution__c> lstInstitutions = [Select Id, Institution_Name__c, Description__c, Alias__c, RecordType.Name from Institution__c where RecordType.Name = :type];
        
        return lstInstitutions;
    }
    
    public List<cdrive__Cloud_Files__c> getCdriveImages(Map<String, Item> availableBooks){
        
        Set<Id> contentIds = new Set<Id>();
        for(Item item: availableBooks.values()){
            contentIds.add(item.product2.Content__c);
        }
        
        List<cdrive__Cloud_Files__c> images = [
            SELECT
            cdrive__Access_Expires__c,
            cdrive__Cloud_Account__c,
            cdrive__Contact__c,
            cdrive__contextID__c,
            cdrive__ContextName__c,
            cdrive__File_Name__c,
            cdrive__File_Type__c,
            cdrive__Lead__c
            FROM cdrive__Cloud_Files__c
            WHERE cdrive__contextID__c IN :contentIds
        ];
        
        return images;
        
    }

    public Exam_Group__c fetchExamGroup(){
        
        Exam_Group__c examGroup = [
                SELECT Id, Exam_Date__c, Registration_Start_Date__c
                FROM Exam_Group__c 
                WHERE Active__c = TRUE AND RecordType.Name = 'FRM/ERP'
            ];
            
            
        if(this.registrationType != NULL && this.registrationType.name() == 'SCR') {
            examGroup = [
                SELECT Id, Exam_Date__c, Registration_Start_Date__c
                FROM Exam_Group__c 
                WHERE SCR_Active__c = TRUE
            ];
                    
        }
        
        return examGroup;
    }

    public Date getExamDate() {
        Date dt;     
        if(examGroup != null){
            dt = this.examGroup.Exam_Date__c;
        }
        return dt;
    }

    public PricebookEntry getEnrollmentFee() {
        
        FINAL String registrationType = this.registrationType.name();

        String productCode = null;
        
        if(registrationType == 'FRM'){
            productCode = 'FRM1';
        }else if(registrationType == 'ERP'){
            productCode = 'ENC';
        }else if(registrationType == 'SCR'){
            return null;
        }
        
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        if(this.pricebookEntries.pricebookEntryByProductCode.containsKey(productCode)){
            PricebookEntry pbe = this.pricebookEntries.pricebookEntryByProductCode.get(productCode);
            pricebookEntries.add(pbe);
        }

        if(this.validatedUser.isAuthenticated){
            
            Id contractRecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract', registrationType + ' Program');
            
            List<Contact> contacts = [
                SELECT Id, KPI_ERP_Enrollment_Date__c, AccountID, KPI_FRM_Enrollment_Date__c 
                FROM Contact 
                WHERE Id = :this.validatedUser.user.ContactId
            ];
            
            if(!contacts.isEmpty()){
                
                List<Contract> contracts = [
                    SELECT Id, RecordTypeId, StartDate, Enrollment_Paid_for_2009__c, Status  
                    FROM Contract 
                    WHERE 
                    AccountID =: contacts[0].AccountID AND 
                    (
                        Status LIKE '%Activated%' OR 
                        Status LIKE '%completed%'
                    )
                ];
                
                List<Product2> enrollments = new List<Product2>();
                
                Boolean paidIn2009          = false;
                Boolean hasPaidEnrollment   = false;
                
                for(Contract contract : contracts){
                    if(contract.status == 'Activated' || contract.status == 'Activated ( Auto-Renew )'){
                        if(contract.RecordTypeId == contractRecordTypeId){
                            hasPaidEnrollment = true;
                            if(contract.StartDate.Year() == 2009 && !contract.Enrollment_Paid_for_2009__c){
                                paidIn2009 = true;
                            }
                        }
                    }
                }
                
                if(hasPaidEnrollment && !paidIn2009){   
                    return null;         
                }else if(!hasPaidEnrollment){                    
                    if(!pricebookEntries.isEmpty()){
                        pricebookEntries[0].UnitPrice = 400.00;
                        return pricebookEntries[0];                                           
                    }
                }else if(paidIn2009){
                    if(!pricebookEntries.isEmpty()){
                        pricebookEntries[0].UnitPrice = 250.00;
                        return pricebookEntries[0]; 
                    }
                }else{
                    pricebookEntries[0].UnitPrice = 400.00;
                    return pricebookEntries[0];
                }
                
            }else{
                pricebookEntries[0].UnitPrice = 400.00;
                return pricebookEntries[0];
            }
            
        }else{            
            pricebookEntries[0].UnitPrice = 400.00;          
            return pricebookEntries[0];              
        }
        
        
        return null;       
        
    }
    
    public PricebookEntry getScholarshipDiscount(List<ExamSelectionOptions.Exam> exams){

        FINAL Id contactId = this.validatedUser.user.ContactId;
        FINAL Id examGroupId = this.examGroup.Id;

        List<Scholarship_Application__c> scholarshipApplications = [
            SELECT Id, Status__c, Exam_Type__c, Applicant__c, Exam_Group__c, Exam_Group__r.Next_Exam_Group__c
            FROM Scholarship_Application__c
            WHERE
            Status__c = 'Approved' AND
            Applicant__c = :contactId AND
            (
                Exam_Group__c = :examGroupId OR 
                Exam_Group__r.Next_Exam_Group__c = :examGroupId
            )
        ];
        
        if(!scholarshipApplications.isEmpty()){
            
            FINAL Scholarship_Application__c scholarshipApplication = scholarshipApplications[0];

            Set<String> scholarshipDiscountProductCodes = new Set<String>{'SAFRM1','SAFRM2','SAERP1','SAERP2','SASCR'};

            Map<String, PricebookEntry> scholarshipDiscountByProductCodeMap = new Map<String, PricebookEntry>();
            for(String productCode: scholarshipDiscountProductCodes){
                if(this.pricebookEntries.pricebookEntryByProductCode.containsKey(productCode)){
                    PricebookEntry pbe = this.pricebookEntries.pricebookEntryByProductCode.get(productCode);
                    scholarshipDiscountByProductCodeMap.put(productCode, pbe);
                }
            }
            
            PricebookEntry scholarshipPricebookEntry = null;

            for(ExamSelectionOptions.Exam e: exams){

                ExamSelectionOptions.ExamPricebookEntry epb = e.examPricebookEntry;                  
                Exam__c exam = epb.exam;
                PricebookEntry examPricebookEntry = epb.pricebookEntry;
                
                if(scholarshipApplication.Exam_Type__c == 'FRM'){
                    switch on exam.Exam__c{
                        when 'FRM Part 1'{
                            scholarshipPricebookEntry = scholarshipDiscountByProductCodeMap.get('SAFRM1');
                            scholarshipPricebookEntry.UnitPrice = examPricebookEntry.UnitPrice * -1;
                        }
                    }
                }else if(scholarshipApplication.Exam_Type__c == 'ERP'){
                    switch on exam.Exam__c{
                        when 'ERP Exam Part I'{
                            scholarshipPricebookEntry = scholarshipDiscountByProductCodeMap.get('SAERP1');
                            scholarshipPricebookEntry.UnitPrice = examPricebookEntry.UnitPrice * -1;
                        }
                    }
                }else if(scholarshipApplication.Exam_Type__c == 'SCR'){
                    switch on exam.Exam__c{
                        when 'SCR'{
                            scholarshipPricebookEntry = scholarshipDiscountByProductCodeMap.get('SASCR');
                            scholarshipPricebookEntry.UnitPrice = examPricebookEntry.UnitPrice * -1;
                        }
                    }
                }
                    
            }
            
            return scholarshipPricebookEntry;

        }else{
            
            return null;
            
        }
        
    }

    public List<OpportunityLineItem> addStudyMaterials(Map<String, Item> studyMaterials){
        
        List<OpportunityLineItem> olis = new List<OpportunityLineItem>();
        
        for(Item item: studyMaterials.values()){
            
            if(this.pricebookEntries.pricebookEntryById.containsKey(item.pricebookEntry.Id)){
                
                PricebookEntry pbe = this.pricebookEntries.pricebookEntryById.get(item.pricebookEntry.Id);
                
                OpportunityLineItem oli = new OpportunityLineItem();
                
                oli.PricebookEntryId = pbe.Id;
                oli.Product2Id = pbe.Product2Id;
                oli.Quantity = 1;
                
                // Define study materials that are always to be comped
                if(pbe.Product2.Is_Comped_Registration__c) {
                    oli.UnitPrice = 0;
                } else {
                    oli.UnitPrice = pbe.UnitPrice;
                }
                /*
                switch on pbe.ProductCode{
                    when 'FRM1X'{
                        oli.UnitPrice = 0;
                    }
                    when else{
                        oli.UnitPrice = pbe.UnitPrice;
                    }
                }
                */
                
                olis.add(oli);
                
            }
            
        }
        
        return olis;
        
    }
    
    public List<OpportunityLineItem> addTaxAndDuty(List<OpportunityLineItem> taxableProducts, Lead lead){
                
        decimal tax = 0;
        decimal weight = 0;
        
        FINAL decimal TAX_RATE = 0.06625;
        
        Set<Id> taxableProductIds = new Set<Id>();
        for(OpportunityLineItem oli: taxableProducts){
            taxableProductIds.add(oli.Product2Id);
        }  
        
        Map<Id, Product2> product2Map = new Map<Id, Product2>([
           SELECT Id, Name, Weight__c, Taxable__c
           FROM Product2
           WHERE Id IN :taxableProductIds
        ]);
        
        for(OpportunityLineItem oli: taxableProducts){
            if(product2Map.containsKey(oli.Product2Id) && product2Map.get(oli.Product2Id).Taxable__c){
                tax += oli.UnitPrice * TAX_RATE;
            }
        }
        
        for(OpportunityLineItem oli: taxableProducts){
            if(product2Map.containsKey(oli.Product2Id)){                
                Product2 product2 = product2Map.get(oli.Product2Id);
                if(product2.Weight__c != null && product2.Weight__c > 0){
                    weight += product2.Weight__c;
                }
            }
        }
        
        List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();
        
        FINAL PricebookEntry SLSTX = this.pricebookEntries.pricebookEntryByProductCode.get('SLSTX');
        FINAL PricebookEntry CDNTAX = this.pricebookEntries.pricebookEntryByProductCode.get('CDNTAX');
        
        if(lead.Shipping_Address_Same_as_Billing_Address__c && lead.Billing_State__c == 'NJ'){
            
            OpportunityLineItem oli = new OpportunityLineItem(
                PricebookEntryId = SLSTX.Id,
                Product2Id = SLSTX.Product2Id,
                UnitPrice = tax,
                Quantity = 1
            );
            
            opportunityLineItems.add(oli);
            
        }else if(!lead.Shipping_Address_Same_as_Billing_Address__c && lead.Shipping_State__c == 'NJ'){
            
            OpportunityLineItem oli = new OpportunityLineItem(
                PricebookEntryId = SLSTX.Id,
                Product2Id = SLSTX.Product2Id,
                UnitPrice = tax,
                Quantity = 1
            );
            
            opportunityLineItems.add(oli);        
            
        }else if(lead.Shipping_Address_Same_as_Billing_Address__c && lead.Billing_Country__c == 'Canada' && weight > 0){
            
            OpportunityLineItem oli = new OpportunityLineItem(
                PricebookEntryId = CDNTAX.Id,
                Product2Id = CDNTAX.Product2Id,
                UnitPrice = CDNTAX.UnitPrice,
                Quantity = 1
            );
            
            opportunityLineItems.add(oli); 
            
        }else if(!lead.Shipping_Address_Same_as_Billing_Address__c && lead.Shipping_Country__c == 'Canada' && weight > 0){
            
            OpportunityLineItem oli = new OpportunityLineItem(
                PricebookEntryId = CDNTAX.Id,
                Product2Id = CDNTAX.Product2Id,
                UnitPrice = CDNTAX.UnitPrice,
                Quantity = 1
            );
            
            opportunityLineItems.add(oli);        
            
        }
        
        return opportunityLineItems;
        
    }    
    
    public List<OpportunityLineItem> addEnrollmentAndMembershipFee(){
        
        FINAL String registrationType = this.registrationType.name();
        FINAL PricebookEntry MEMF = this.pricebookEntries.pricebookEntryByProductCode.get('MEMF');
        
        List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();
        
        PricebookEntry enrollmentFee = this.getEnrollmentFee();
        
        if(enrollmentFee != null){
            
            Item enrollmentFeeItem = new Item(enrollmentFee);
            
            OpportunityLineItem enrollmentFeeOli = new OpportunityLineItem(
                PricebookEntryId = enrollmentFeeItem.pricebookEntry.Id,
                Product2Id = enrollmentFeeItem.product2.Id,
                UnitPrice = enrollmentFeeItem.pricebookEntry.UnitPrice,
                Quantity = 1
            );
            
            opportunityLineItems.add(enrollmentFeeOli);
            
            OpportunityLineItem complimentaryMembershipOli = new OpportunityLineItem(
                PricebookEntryId = MEMF.Id,
                Product2Id = MEMF.Product2Id,
                UnitPrice = 0,
                Quantity = 1
            );
            
            opportunityLineItems.add(complimentaryMembershipOli);  
            
        }   
        
        return opportunityLineItems;
        
    }
    
    public List<OpportunityLineItem> addExamRegistrations(List<ExamSelectionOptions.Exam> exams){

        List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();
        
        for(ExamSelectionOptions.Exam exam :exams){
            
            ExamSelectionOptions.ExamPricebookEntry epe = exam.examPricebookEntry;

            OpportunityLineItem oli = new OpportunityLineItem(
                PricebookEntryId = epe.pricebookEntry.Id,
                Product2Id = epe.pricebookEntry.Product2Id,
                UnitPrice = epe.pricebookEntry.UnitPrice,
                Quantity = 1
            );
            
            opportunityLineItems.add(oli); 
            
        }
        
        return opportunityLineItems;
        
    }
        
    public List<OpportunityLineItem> addProcessingFee(Lead lead){
        
        FINAL PricebookEntry PRFEE = this.pricebookEntries.pricebookEntryByProductCode.get('PRFEE');   
        
        List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();    
        
        if(lead.Payment_Type__c == 'Wire Transfer' || lead.Payment_Type__c == 'Check'){
            
            OpportunityLineItem oli = new OpportunityLineItem(
                PricebookEntryId = PRFEE.Id,
                Product2Id = PRFEE.Product2Id,
                UnitPrice = PRFEE.UnitPrice,
                Quantity = 1
            );
            
            opportunityLineItems.add(oli);
            
        }
        
        return opportunityLineItems;
        
    }

    public List<OpportunityLineItem> addScholarshipDiscounts(Id contactId, Id examGroupId, List<ExamSelectionOptions.Exam> exams){
        
        List<Scholarship_Application__c> scholarshipApplications = [
            SELECT Id, Status__c, Exam_Type__c, Applicant__c, Exam_Group__c, Exam_Group__r.Next_Exam_Group__c
            FROM Scholarship_Application__c
            WHERE
            Status__c = 'Approved' AND
            Applicant__c = :contactId AND
            (
                Exam_Group__c = :examGroupId OR 
                Exam_Group__r.Next_Exam_Group__c = :examGroupId
            )
        ];
        
        if(!scholarshipApplications.isEmpty()){
            
            FINAL Scholarship_Application__c scholarshipApplication = scholarshipApplications[0];

            Set<String> scholarshipDiscountProductCodes = new Set<String>{'SAFRM1','SAFRM2','SAERP1','SAERP2','SASCR'};
            
            List<PricebookEntry> pricebookEntries = [
                SELECT Id, UnitPrice, ProductCode, Product2Id, Product2.Name, Product2.Description
                FROM PricebookEntry 
                WHERE 
                ProductCode IN :scholarshipDiscountProductCodes AND 
                IsActive = TRUE AND 
                Pricebook2.IsActive = TRUE AND 
                Product2.IsActive = TRUE 
            ]; 
            
            Map<String, PricebookEntry> scholarshipDiscountByProductCodeMap = new Map<String, PricebookEntry>();
            
            for(PricebookEntry pb: pricebookEntries){
                scholarshipDiscountByProductCodeMap.put(pb.ProductCode, pb);
            }
            
            List<OpportunityLineItem> scholarshipOpportunityLineItems = new List<OpportunityLineItem>();
            
            for(ExamSelectionOptions.Exam e: exams){
                
                ExamSelectionOptions.ExamPricebookEntry epb = e.examPricebookEntry;
                Exam__c exam = epb.exam;
                PricebookEntry examPricebookEntry = epb.pricebookEntry;
                
                if(scholarshipApplication.Exam_Type__c == 'FRM'){
                    
                    switch on exam.Exam__c{
                        when 'FRM Part 1'{
                            
                            PricebookEntry scholarshipPricebookEntry = scholarshipDiscountByProductCodeMap.get('SAFRM1');
                            
                            scholarshipPricebookEntry.UnitPrice = examPricebookEntry.UnitPrice * -1;
                            
                            OpportunityLineItem oli = new OpportunityLineItem(
                                PricebookEntryId = scholarshipPricebookEntry.Id,
                                Description = scholarshipPricebookEntry.Product2.Description,
                                Product2Id = scholarshipPricebookEntry.Product2Id,
                                UnitPrice = scholarshipPricebookEntry.UnitPrice,
                                Quantity = 1,
                                Scholarship_Application__c = scholarshipApplication.Id
                            );
                            
                            scholarshipOpportunityLineItems.add(oli);
      
                        }
                    }
                    
                } else if(scholarshipApplication.Exam_Type__c == 'ERP'){
                    
                    switch on exam.Exam__c{
                        when 'ERP Exam Part I'{
                            
                            PricebookEntry scholarshipPricebookEntry = scholarshipDiscountByProductCodeMap.get('SAERP1');
                            
                            scholarshipPricebookEntry.UnitPrice = examPricebookEntry.UnitPrice * -1;
                            
                            OpportunityLineItem oli = new OpportunityLineItem(
                                PricebookEntryId = scholarshipPricebookEntry.Id,
                                Description = scholarshipPricebookEntry.Product2.Description,
                                Product2Id = scholarshipPricebookEntry.Product2Id,
                                UnitPrice = scholarshipPricebookEntry.UnitPrice,
                                Quantity = 1,
                                Scholarship_Application__c = scholarshipApplication.Id
                            );
                            
                            scholarshipOpportunityLineItems.add(oli);
    
                        }
                    }  
                    
                } else if(scholarshipApplication.Exam_Type__c == 'SCR'){
                    
                    switch on exam.Exam__c{
                        when 'SCR'{
                            
                            PricebookEntry scholarshipPricebookEntry = scholarshipDiscountByProductCodeMap.get('SASCR');
                            
                            scholarshipPricebookEntry.UnitPrice = examPricebookEntry.UnitPrice * -1;
                            
                            OpportunityLineItem oli = new OpportunityLineItem(
                                PricebookEntryId = scholarshipPricebookEntry.Id,
                                Description = scholarshipPricebookEntry.Product2.Description,
                                Product2Id = scholarshipPricebookEntry.Product2Id,
                                UnitPrice = scholarshipPricebookEntry.UnitPrice,
                                Quantity = 1,
                                Scholarship_Application__c = scholarshipApplication.Id
                            );
                            
                            scholarshipOpportunityLineItems.add(oli);
    
                        }
                    }  
                    
                }
    
            }
            
            return scholarshipOpportunityLineItems;

        }else{
            
            return null;
            
        }
        
    }

    public Contract createIndividualMembershipContract(Id accountId, Id contactId, Id opportunityId, List<OpportunityLineItem> enrollmentAndMembershipFees){
        
        if(enrollmentAndMembershipFees != null && !enrollmentAndMembershipFees.isEmpty()){
            
            Contract membershipContract = new Contract(
                Name = 'Individual Membership',
                AccountId = accountId,
                Opportunity__c = opportunityId,
                CustomerSignedId = contactId,
                StartDate = System.Today(),
                ContractTerm = 12,
                Membership_Type__c = 'Individual',
                RecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract', 'Membership')
            );
            
            INSERT membershipContract;
            
            return membershipContract;
            
        }
        
        return null;              
        
    }

    public Contract getMembershipContract(Id accountId){

        Id recordTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'Membership');
        
        List<Contract> contracts = [
            SELECT Id, Name, RecordTypeId
            FROM Contract 
            WHERE AccountId = :accountId AND RecordTypeId = :recordTypeId LIMIT 1
        ]; 

        Contract contract = (contracts.isEmpty()) ? null : contracts[0];
        
        return contract;

    }

    public void createAffiliateContractAndOrder(){

        Opportunity affiliateMembershipOpportunity = new Opportunity(
            Name = 'Affiliate Membership',
            AccountId = this.account.Id,
            Eligible_for_Membership_Extension__c = TRUE,
            CloseDate = Date.today(),
            StageName = 'New Lead',
            RecordTypeID = RecordTypeHelper.GetRecordTypeId('Opportunity', 'Automated')
        );

        INSERT affiliateMembershipOpportunity;

        PricebookEntry pbe = this.pricebookEntries.pricebookEntryByProductCode.get('AFREE');

        OpportunityLineItem affiliateMembershipOpportunityOli = new OpportunityLineItem( 
            OpportunityId       = affiliateMembershipOpportunity.Id,                          
            PricebookEntryId    = pbe.Id,
            Product2Id          = pbe.Product2Id,
            UnitPrice           = 0,
            Quantity            = 1,
            Description         = 'Affiliate Membership'
        );

        INSERT affiliateMembershipOpportunityOli;
        
        Contract affiliateMembershipContract = new Contract(
             Name = 'Affiliate Membership',
             AccountId = this.account.Id,
             Opportunity__c = affiliateMembershipOpportunity.Id,
             CustomerSignedId = this.contact.Id,
             StartDate = System.Today(),
             ContractTerm = 12,
             Membership_Type__c = 'Affiliate',
             RecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract', 'Membership')
        );
        
        INSERT affiliateMembershipContract;
        
        affiliateMembershipOpportunity.StageName = 'Closed';

        UPDATE affiliateMembershipOpportunity;

    }

    public List<Exam_Attempt__c> createExamRegistrations(List<OpportunityLineItem> examProducts, Contract examContract, Map<String, Candidate_Requirement__c> candidateRequirementsByExamNameMap, Id contactId, RegistrationRequest registrationRequest){
                
        FINAL String registrationType = this.registrationType.name();
        FINAL Id recordTypeId = RecordTypeHelper.getRecordTypeID('Exam_Attempt__c', registrationType);
        List<Selection> selections = registrationRequest.selections;

        Set<Id> examSiteIds = new Set<Id>();
        List<Exam_Sites__c> examSites;
        //if(this.registrationType != ExamRegistrationForm.RegistrationTypes.SCR) {
            for(Selection selection: selections){
                examSiteIds.add(selection.site.examSite.Id);
            }
            System.Debug('examSiteIds:' + examSiteIds);
            
            //Fetch exam sites for the current Exam Group for the selected Site.
            examSites = [
                SELECT Id, Name, Site__c, Site__r.Name, Site__r.AM_Exam_Capacity_Available__c, Site__r.PM_Exam_Capacity_Available__c, Exam__c, Exam__r.Name, Exam__r.Exam__c, Exam__r.Exam_Group__c, Exam__r.Administration_Time_of_Day__c, Exam_Part__c, Exam_Part__r.Exam_Administration__c, Exam_Part__r.Exam_Date__c, Exam_Part__r.Exam_Start_Date__c
                FROM Exam_Sites__c
                WHERE Id IN :examSiteIds
            ];
            System.Debug('examSites:' + examSites);
            
                        
        //} else {
            //Fetch default exam site.
        //    examSites = [
        //        SELECT Id, Name, Site__c, Site__r.Name, Site__r.AM_Exam_Capacity_Available__c, Site__r.PM_Exam_Capacity_Available__c, Exam__c, Exam__r.Name, Exam__r.Exam__c, Exam__r.Exam_Group__c, Exam__r.Administration_Time_of_Day__c, Exam_Part__c, Exam_Part__r.Exam_Administration__c, Exam_Part__r.Exam_Administration__r.Exam_Date__c, Exam_Part__r.Exam_Administration__r.Exam_Start_Date__c
        //        FROM Exam_Sites__c
        //        WHERE Name = 'SCR'
        //    ];
        //    
        //}
        
        FINAL Id examGroupId = examSites[0].Exam__r.Exam_Group__c;
        
        List<Scholarship_Application__c> scholarshipApplications = [
            SELECT Id, Status__c, Applicant__c, Exam_Group__c, Exam_Group__r.Next_Exam_Group__c
            FROM Scholarship_Application__c
            WHERE
            Status__c = 'Approved' AND
            Applicant__c = :contactId AND
            (
                Exam_Group__c = :examGroupId OR 
                Exam_Group__r.Next_Exam_Group__c = :examGroupId
            )
        ];
        
        Map<String, Exam_Sites__c> examSiteByExamNameMap = new Map<String, Exam_Sites__c>();
        for(Exam_Sites__c examSite: examSites){
            examSiteByExamNameMap.put(examSite.Exam__r.Exam__c, examSite);
        }      
        System.Debug('examSiteByExamNameMap:' + examSiteByExamNameMap);
                
        List<Exam_Attempt__c> examRegistrations = new List<Exam_Attempt__c>();
        
        for(OpportunityLineItem oli: examProducts){
            
            String examName = null;
            
            if(oli.ProductCode.contains('FRM1')){
                examName = 'FRM Part 1';
            }else if(oli.ProductCode.contains('FRM2')){
                examName = 'FRM Part 2';
            }else if(oli.ProductCode.contains('ENC1')){
                examName = 'ERP Exam Part I';
            }else if(oli.ProductCode.contains('ENC2')){
                examName = 'ERP Exam Part II';
            }else if(oli.ProductCode.contains('SCR')){
                examName = 'SCR';
            }
            System.Debug('examName:' + examName);
            
            Exam_Sites__c examSite = examSiteByExamNameMap.get(examName);            
            //system.assert(false, 'BOOM!'+ examSite );
            
            // If the corresponding Test Site (Site__c) is at capacity, throw an exception
            if(examSite.Exam__r.Administration_Time_of_Day__c == 'AM' && !examSite.Site__r.AM_Exam_Capacity_Available__c){
                throw new Response.ResponseException(
                    'The AM session for the selected Exam Site (' + examSite.Site__r.Name + ') is full.', 400, 
                    new List<Object>{'The AM session for the selected Exam Site (' + examSite.Site__r.Name + ') is full.'}
                );  
            }else if(examSite.Exam__r.Administration_Time_of_Day__c == 'PM' && !examSite.Site__r.PM_Exam_Capacity_Available__c){
                throw new Response.ResponseException(
                    'The PM session for the selected Exam Site (' + examSite.Site__r.Name + ') is full.', 400, 
                    new List<Object>{'The PM session for the selected Exam Site (' + examSite.Site__r.Name + ') is full.'}
                );  
            }
            
            Exam_Attempt__c examAttempt = new Exam_Attempt__c();
            
            examAttempt.RecordTypeId                = recordTypeId;
            examAttempt.Member__c                   = contactId;
            examAttempt.Opportunity__c              = oli.OpportunityId;
            examAttempt.Exam_Site__c                = examSite.Id;
            examAttempt.Exam_Part__c                = examSite.Exam_Part__c;
            examAttempt.Exam_Administration__c      = examSite.Exam_Part__r.Exam_Administration__c;
            examAttempt.Original_Exam_Administration__c      = examSite.Exam_Part__r.Exam_Administration__c;
            
            // AG 3/18/2022 - Set Team Reg Results Release Consent on Exam Reg
            if(registrationRequest.teamRegistrationInfo != NULL && 
               registrationRequest.teamRegistrationInfo.agreeToDiscloseResults != NULL &&
               registrationRequest.teamRegistrationInfo.agreeToDiscloseResults == True) {
                examAttempt.Consent_Release_Exam_Results__c = DateTime.now();
            }

            // Get Contact Data for ATA
            List<Contact> lstContact = [select Id, Name, Name_as_it_Appears_on_ID__c, ID_Type__c, ID_Number__c, OSTA_Consent__c from Contact where Id = :contactId];
            if(lstContact != NULL && lstContact.size() > 0) {
                contact = lstContact[0];
                if(contact.Name_as_it_Appears_on_ID__c != NULL) {
                    examAttempt.ATA_Name_as_it_appears_on_ID__c = contact.Name_as_it_Appears_on_ID__c;
                }
                if(contact.ID_Type__c != NULL) {
                    if(contact.ID_Type__c.indexOf('Driver') > -1) {
                        examAttempt.ATA_Cert_Type__c = 'Driver\'s License';
                    } else {
                        examAttempt.ATA_Cert_Type__c = contact.ID_Type__c;    
                    }
                    
                }
                if(contact.ID_Number__c != NULL) {
                    examAttempt.ATA_Cert_id__c = contact.ID_Number__c;
                }
                
                examAttempt.OSTA_Consent__c = contact.OSTA_Consent__c;
            }
            
            
            String candidateRequirementExamName = null;

            if(this.registrationType != ExamRegistrationForm.RegistrationTypes.SCR) {
                
                if(oli.ProductCode.contains('FRM1')){
                    candidateRequirementExamName = 'FRM Part I';
                }else if(oli.ProductCode.contains('FRM2')){
                    candidateRequirementExamName = 'FRM Part II';
                }else if(oli.ProductCode.contains('ENC1')){
                    candidateRequirementExamName = 'ERP Part I';
                }else if(oli.ProductCode.contains('ENC2')){
                    candidateRequirementExamName = 'ERP Part II';
                }
    
                //examAttempt.RecordTypeId = recordTypeId;
                examAttempt.Candidate_Requirement__c    = candidateRequirementsByExamNameMap.get(candidateRequirementExamName).Id;
                examAttempt.Candidate_Commitment__c     = candidateRequirementsByExamNameMap.get(candidateRequirementExamName).Candidate_Commitment__c;

            } else {
                examAttempt.Candidate_Commitment__c = examContract.Id;
            }

            
            //Associate Scholarship Application with Exam Registration
            if(!scholarshipApplications.isEmpty()){
                
                Scholarship_Application__c scholarshipApplication = scholarshipApplications[0];

                if(oli.ProductCode.contains('FRM1')){
                    examAttempt.Scholarship_Application__c = scholarshipApplication.Id;
                }else if(oli.ProductCode.contains('ENC1')){
                    examAttempt.Scholarship_Application__c = scholarshipApplication.Id;
                }else if(oli.ProductCode.indexOf('SCR') > -1){
                    examAttempt.Scholarship_Application__c = scholarshipApplication.Id;
                }
            }

            examRegistrations.add(examAttempt);
            
        }
        
        INSERT examRegistrations;
        
        //Associate Exam Registrations
        Set<Id> examRegistrationIds = new Set<Id>();
        for(Exam_Attempt__c examAttempt: examRegistrations){
            examRegistrationIds.add(examAttempt.Id);
        }
        
        Map<String, Exam_Attempt__c> examRegistrationBySectionMap = new Map<String, Exam_Attempt__c>();
        
        /**
         * Get all Exam Registrations that were just inserted AND/OR all 
         * FRM/ERP Exam Part 1 Exam Registrations for the associated contact and
         * for the current active Exam Group so that the FRM/ERP Exam Part 2
         * can be associated with the correct FRM/ERP Exam Part 1.
         **/ 
        for(Exam_Attempt__c examAttempt: [
            SELECT Id, Section__c 
            FROM Exam_Attempt__c 
            WHERE 
            (
                Member__c = :contactId AND
                Exam_Site__r.Exam__r.Exam_Group__c = :examGroupId AND
                Cancelled__c = FALSE AND
                (
                    (Section__c = 'FRM Part 1' AND Opportunity__r.StageName = 'Closed') OR 
                    (Section__c = 'ERP Exam Part I' AND Opportunity__r.StageName = 'Closed')
                )
            ) OR Id IN :examRegistrationIds
        ]){
            examRegistrationBySectionMap.put(examAttempt.Section__c, examAttempt);
        }

        List<Exam_Attempt__c> examRegistrationsToUpdate = new List<Exam_Attempt__c>();
        for(Exam_Attempt__c examAttempt: examRegistrationBySectionMap.values()){ 
            if(examAttempt.Section__c == 'FRM Part 1'){
                if(examRegistrationBySectionMap.containsKey('FRM Part 2')){
                    examAttempt.Other_Exam_Registrations__c = examRegistrationBySectionMap.get('FRM Part 2').Id;
                    examRegistrationsToUpdate.add(examAttempt);
                }
            }else if(examAttempt.Section__c == 'FRM Part 2'){
                if(examRegistrationBySectionMap.containsKey('FRM Part 1')){
                    examAttempt.Other_Exam_Registrations__c = examRegistrationBySectionMap.get('FRM Part 1').Id;
                    examRegistrationsToUpdate.add(examAttempt);
                }
            }else if(examAttempt.Section__c == 'ERP Exam Part I'){
                if(examRegistrationBySectionMap.containsKey('ERP Exam Part II')){
                    examAttempt.Other_Exam_Registrations__c = examRegistrationBySectionMap.get('ERP Exam Part II').Id;
                    examRegistrationsToUpdate.add(examAttempt);
                }
            }else if(examAttempt.Section__c == 'ERP Exam Part II'){
                if(examRegistrationBySectionMap.containsKey('ERP Exam Part I')){
                    examAttempt.Other_Exam_Registrations__c = examRegistrationBySectionMap.get('ERP Exam Part I').Id;
                    examRegistrationsToUpdate.add(examAttempt);
                }
            } 
        }
        
        if(!examRegistrationsToUpdate.isEmpty()) UPDATE examRegistrationsToUpdate;

        Opportunity opportunity = [
            SELECT Id, Deferred_Exam_Registration__c
            FROM Opportunity
            WHERE Id = :examProducts[0].OpportunityId
        ];

        if(examRegistrations.size() == 1){
            opportunity.Deferred_Exam_Registration__c = examRegistrations[0].Id;
        }else if(examRegistrations.size() == 2){
            opportunity.Deferred_Exam_Registration__c = examRegistrations[1].Id;
        }

        UPDATE opportunity;

        return examRegistrations;
        
    }

    public void manualRollback(){

        Lead lead = this.lead;
        Contact contact = this.contact;
        Account account = this.account;
        Opportunity opportunity = this.opportunity;
        List<Contract> programs = this.programs;
        
        System.debug('programs:' + programs);
        System.debug('opportunity:' + opportunity);
        System.debug('account:' + account);
        System.debug('contact:' + contact);
        System.debug('lead:' + lead);
        
        List<Exam_Attempt__c> examRegistrations = opportunity.Exam_Registrations__r;

        if(!this.validatedUser.isAuthenticated){
            opportunity.AccountId = Label.Failed_Exam_Registrations_Account_ID;
        }

        opportunity.StageName = 'Closed Lost';
        
        UPDATE opportunity;
        
        if(!this.validatedUser.isAuthenticated && contact.Original_Business_Account_ID__c != null && contact.Original_Business_Contact_Owner_ID__c != null){      
                      
            /* *
            * Revert AccountId to original parent Account.
            * Revert OwnerId to original Owner.
            * Revert Record Type to 'Business Relationship'.
            * */
            contact.AccountId = contact.Original_Business_Account_ID__c;
            contact.OwnerId = contact.Original_Business_Contact_Owner_ID__c;
            contact.RecordTypeId = RecordTypeHelper.GetRecordTypeId('Contact', 'Business Relationship');

            /* *
            * Clear Original_Business_Account_ID__c as it no longer needs to be referenced.
            * Clear Original_Business_Contact_Owner_ID__c as it no longer needs to be referenced.
            * */      
            contact.Original_Business_Account_ID__c = null;
            contact.Original_Business_Contact_Owner_ID__c = null;
            
            UPDATE contact;

            if(programs != null && !programs.isEmpty()) DELETE programs;
            
            // find any programs
            //List<Contract> lstContract = [select Id, RecordType.Name from Contract where CustomerSignedId = :contact.Id OR AccountId = :account.Id];
            //System.debug('lstContract:' + lstContract);
            //if(lstContract != NULL && lstContract.size() > 0) {
            //    DELETE lstContract;
            //}
            
            if(examRegistrations != null && !examRegistrations.isEmpty()) DELETE examRegistrations;
            
            // Deleting Lead as we cannot update an existing converted Lead unless we modify the permissions.
            DELETE lead; 
            DELETE account;
            
        }else if(!this.validatedUser.isAuthenticated){  
            
            if(programs != null && !programs.isEmpty()) DELETE programs;
            
            // find any programs
            //List<Contract> lstContract = [select Id, RecordType.Name from Contract where CustomerSignedId = :contact.Id OR AccountId = :account.Id];
            //System.debug('lstContract:' + lstContract);
            //if(lstContract != NULL && lstContract.size() > 0) {
            //    DELETE lstContract;
            //}
            
            if(examRegistrations != null && !examRegistrations.isEmpty()) DELETE examRegistrations;
            
            // Deleting Lead as we cannot update an existing converted Lead unless we modify the permissions.
            DELETE lead;
            DELETE contact;
            DELETE account;
            
        }else if(this.validatedUser.isAuthenticated){

            if(programs != null && !programs.isEmpty()) DELETE programs;
            
            // find any programs
            //List<Contract> lstContract = [select Id, RecordType.Name from Contract where CustomerSignedId = :contact.Id OR AccountId = :account.Id];
            //System.debug('lstContract:' + lstContract);
            //if(lstContract != NULL && lstContract.size() > 0) {
            //    DELETE lstContract;
            //}
            
            if(examRegistrations != null && !examRegistrations.isEmpty()) DELETE examRegistrations;

            // Deleting Lead as we cannot update an existing converted Lead unless we modify the permissions.
            DELETE lead;

        }
        
    }

    public ExamRegistrationForm(){
    
        this.examGroup = this.fetchExamGroup();        
        this.disableManualRollback = FALSE;
        this.disableCreditCardProcessing = FALSE;
        this.validatedUser = new ValidatedUser(UserInfo.getUserId());
        this.pricebookEntries = new PricebookEntries();
    }

}