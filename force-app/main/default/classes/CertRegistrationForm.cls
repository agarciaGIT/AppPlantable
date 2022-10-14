public abstract class CertRegistrationForm {
   
    @TestVisible private static User runAsUser = null;

    @TestVisible public Boolean disableManualRollback { get; private set; }
    @TestVisible public Boolean disableCreditCardProcessing { get; private set; }

    // Properties
    public Savepoint savepoint { get; set; }
    public ValidatedUser validatedUser { get; set; }
    public PricebookEntries pricebookEntries { get; set; }
    public RegistrationTypes registrationType { get; set; }

    public Lead lead { get; set; }
    public Account account { get; set; }
    public Contact contact { get; set; }
    public Opportunity opportunity { get; set; }
    public List<Contract> programs { get; set; }

    abstract Response.Detail getCertRegistrationFormData();
    abstract Response.Detail getCertRegistrationInfoFormData(Id contactId);
    abstract Response.Detail getCertRegistrationCompletedFormData();
    abstract Response.Detail createCertRegistrationOrder(RegistrationRequest registrationRequest);
    abstract Response.Detail payCertRegistrationOrder(ChargeRequest chargeRequest);
    abstract Response.Detail updateCertRegistrationInfo(Contact contact);

    abstract Item getAvailableCertProduct();
    abstract item getAvailableCertProduct(Id contactId);
    abstract List<OpportunityLineItem> stageOpportunityLineItems(RegistrationRequest registrationRequest);

    // Inner Class Definitions
    public Enum RegistrationTypes { SCR }

    public class ValidatedUser{  
        public Boolean isAuthenticated  { get; set; }
        public User user                { get; set; }
        
        public ValidatedUser(Id userId){
            
            if(runAsUser != null){
                this.user = runAsUser;
            }else{
            	this.user = [SELECT Id, ContactId, AccountId FROM User WHERE Id = :userId LIMIT 1];
            }
            
            if(user.ContactId != null && user.AccountId != null){   
                this.isAuthenticated = true;
            }else{
                this.isAuthenticated = false;
            }
            
        }
    }
    
    public class PricebookEntries{
        public Map<Id, PricebookEntry> pricebookEntryById               { get; set; }
        public Map<String, PricebookEntry> pricebookEntryByProductCode  { get; set; }
        
        public PricebookEntries(){
            
            this.pricebookEntryById = new Map<Id, PricebookEntry>([
                SELECT 
                    Id, UnitPrice, ProductCode, 
                    Product2Id, Product2.ProductCode, Product2.Name, Product2.Family, Product2.Weight__c, Product2.Taxable__c, Product2.Product_ID__c, Pricebook2.IsActive, Product2.isActive
                FROM PricebookEntry 
                WHERE IsActive = TRUE AND Pricebook2.IsActive = TRUE AND Product2.IsActive = TRUE
            ]);

            this.pricebookEntryByProductCode = new Map<String, PricebookEntry>();
            for(PricebookEntry pbe: this.pricebookEntryById.values()){
                if(pbe.ProductCode != null){
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
    
    public class Item{
        public String id									{ get; set; }
        public String label									{ get; set; }
        public Boolean comped								{ get; set; }
        public Boolean selected     						{ get; set; }
        public Product2 product2     						{ get; set; }    
        public Boolean purchased							{ get; set; }
        public Datetime purchasedDate						{ get; set; }	
        public PricebookEntry pricebookEntry 				{ get; set; }
        
        public Item(){}
        
        public Item(PricebookEntry pricebookEntry){   
            System.debug(pricebookEntry);         
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

    public class RegistrationRequest{ 
        public String token													{ get; set; }
        public Lead lead                                                    { get; set; }
        public Item certProduct                                             { get; set; }
        public String registrationType                                      { get; set; }
        public Exam_Group__c examGroup                                      { get; set; }
        public Map<String, Item> products                                   { get; set; }
        public UpsXmlRatingServiceSelectionResponse.RatedShipment shipping  { get; set; }
    }

    public class RegistrationResponse{
        public Lead lead                                                    { get; set; }         
        public Opportunity opportunity                                      { get; set; }
    }

    public class ChargeRequest{      
        public String token													{ get; set; }
        public Lead lead                                                    { get; set; }
        public String registrationType                                      { get; set; }
        public Card card                                                    { get; set; }
    }

    public class ChargeResponse{
        public Contact contact                                                      { get; set; }
        public Opportunity opportunity                                              { get; set; }
        public ChargentSFA.TChargentOperations.TChargentResult chargentResult       { get; set; }
    }

    public class ViewModel{
        public String token															{ get; set; }
        public String formKey                                                       { get; set; }
        public String registrationType                                              { get; set; } 
        public Lead lead                                                            { get; set; }
        public Contact contact                                                      { get; set; }
        public List<Account> companies                                              { get; set; }
        public Exam_Group__c examGroup                                              { get; set; }
        public List<cdrive__Cloud_Files__c> images                                  { get; set; }
        public Item availableCertProduct                                            { get; set; }   
        public Map<String, Item> certProducts                                       { get; set; } 
        public Map<String, Item> availableBooks                                     { get; set; }
        public Map<String, Item> feesByProductCode                                  { get; set; }
        public Map<String, List<Schema.PicklistEntry>> picklistValuesByFieldName    { get; set; }
        public ViewModel(CertRegistrationForm crf){
            this.registrationType = crf.registrationType.name();
            this.formKey = 'cert-registration-' + this.registrationType.toLowerCase();
            this.token = Utilities.getFormSessionToken();
            this.companies = crf.fetchCompanies();
            this.examGroup = crf.fetchExamGroup();
            this.feesByProductCode = new Map<String, Item>();
            this.certProducts = new Map<String, Item>{
                'SCRNM' => new Item(crf.pricebookEntries.pricebookEntryByProductCode.get('SCRNM')),
                'SCRCM' => new Item(crf.pricebookEntries.pricebookEntryByProductCode.get('SCRCM')),
                'SCRM' => new Item(crf.pricebookEntries.pricebookEntryByProductCode.get('SCRM')),
                'SCR2A' => new Item(crf.pricebookEntries.pricebookEntryByProductCode.get('SCR2A'))
            };
        }
    }
    
    public List<Account> fetchCompanies(){
        
        List<Account> accounts = [
            SELECT Id, Name 
            FROM Account 
            WHERE Customer_Company_List__c = TRUE
        ];
        
        return accounts;
    }
    
    public Exam_Group__c fetchExamGroup(){
        
        Exam_Group__c examGroup = [
            SELECT Id, Exam_Date__c,
            (                          
                SELECT Id, Name, Exam_Registration_Window_Open__c, Exam_Registration_Window_Close__c, Exam_Results_Release_Timeframe__c, Exam_Results_Release_Date__c
                FROM Exam_Registration_Windows__r
                WHERE Exam_Registration_Window_Close__c > :Date.today() AND Exam_Registration_Window_Open__c < :Date.today().addYears(1)
                ORDER BY Exam_Registration_Window_Open__c ASC
            )
            FROM Exam_Group__c 
            WHERE RecordType.Name = :this.registrationType.name() LIMIT 1
        ];
        
        return examGroup;
    }

    public Map<String, Item> createMap(List<PricebookEntry> items){
        
        Map<String, Item> output = new Map<String, Item>();
        
        for(PricebookEntry pbe :items){
            
            Item item = new Item(pbe);

            output.put(pbe.Id, item);
            
        }
        
        return output;
        
    }

    public List<PricebookEntry> getStudyMaterials(){
        
        FINAL String baseProductCode = this.registrationType.name();
        
        Set<String> productCodes = new Set<String>{
            baseProductCode + 'H', 
            baseProductCode + 'X'
        };

        List<PricebookEntry> materials = [
            SELECT 
            Product2.Content__c, 
            Product2.Content__r.Story__c, 
            Product2.Content__r.Mobile_Story__c,
            Product2.Content__r.Name, 
            Product2.Content__r.Content_Name__c, 
            Product2.Content__r.Image__c, 
            Product2.Content__r.Start_Date__c,
            Product2.Content__r.Status__c,
            Product2.Content__r.Lead_Gen_URL__c,
            Product2.Id, 
            Product2.ProductCode, 
            Product2.Name, 
            Product2.Weight__c,
            Product2.Product_ID__c,
            Product2.Inventory__c,
            Product2.Taxable__c,
            Product2.Electronic_Delivery__c,
            Product2.Pre_Order_Date__c,
            Product2.Pre_Order_Shipping_Date__c,
            UnitPrice, 
            ProductCode
            FROM PricebookEntry 
            WHERE ProductCode IN :productCodes AND IsActive = TRUE AND Pricebook2.IsActive = TRUE AND Product2.IsActive = TRUE 
            ORDER BY Product2.ProductCode ASC
        ];        
        
        return materials;
        
    }

    /**
    @description creates and affiliate contract and order
    */ 
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

        // Setting recursive flags to ensure that the Affiliate Opportunity closing activates the Affiliate Contract.
        opportunityTriggerHelper.isFirstRun = true;
        opportunityTriggerUtils.bIsRecursiveForRenewOpps = false;

        UPDATE affiliateMembershipOpportunity;

    }

    /**
    @description retrieves an individual membership if one exists
    @return Contract returns a membership contract
    */ 
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

    /**
    @description gets all fees for a non-authenticated user
    @return Map<String, Item> a map of all items by ProductCode
    */ 
    public Map<String, Item> getFeesMap(){
        
        Set<String> productCodes = new Set<String>{'PRFEE', 'MEMI', 'CDNTAX'};

        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        for(String key: productCodes){
            pricebookEntries.add(this.pricebookEntries.pricebookEntryByProductCode.get(key));
        }
                
        //Create Item objects using the defined model
        Map<String, Item> availableFees = new Map<String, Item>();
        for(PricebookEntry pbe: pricebookEntries){            
            Item item = new Item(pbe);
            availableFees.put(item.id, item);       
        }
        
        return availableFees;
        
    }

    /**
    @description gets all fees the user is eligible for
    @param accountId AccountId of the user in context
    @return Map<String, Item> a map of all items by ProductCode
    */ 
    public Map<String, Item> getFeesMap(Id accountId){

        Set<String> productCodes = new Set<String>{'PRFEE', 'CDNTAX'};

        Set<Contract> memberContracts = new Set<Contract>();
        Set<Contract> certifiedContracts = new Set<Contract>();

        List<Contract> contracts = [
            SELECT Id, RecordType.Name, Status, Membership_Type__c
            FROM Contract 
            WHERE AccountId = :accountId AND (Status LIKE 'Activated%' OR Status LIKE 'Completed')
        ];

        // Data mine if the user in context has member or program contracts.
        for(Contract contract: contracts){
            switch on contract.RecordType.Name{
                when 'FRM Program', 'ERP Program'{
                    if(contract.Status == 'Completed'){
                        certifiedContracts.add(contract);
                    }
                }
                when 'Membership'{
                    if(contract.Membership_Type__c == 'Individual'){
                        memberContracts.add(contract);
                    }
                }
            }
        }

        // Get the correct membership product for the user.
        if(memberContracts.isEmpty() && certifiedContracts.isEmpty()){
            productCodes.add('MEMI');
        }else if(memberContracts.isEmpty() && !certifiedContracts.isEmpty()){
            productCodes.add('MEMC');
        }

        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        for(String key: productCodes){
            pricebookEntries.add(this.pricebookEntries.pricebookEntryByProductCode.get(key));
        }
                
        //Create Item objects using the defined model
        Map<String, Item> availableFees = new Map<String, Item>();
        for(PricebookEntry pbe: pricebookEntries){            
            Item item = new Item(pbe);
            availableFees.put(item.id, item);       
        }
        
        return availableFees;
        
    }

    /**
    @description gets the images needed for product contents
    @param availableBooks map of items
    @return List<cdrive__Cloud_Files__c> a list of images
    */    
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

    /**
    @description gets the Exam Contract associated with the Account
    @param accountId the AccountId of the users in context
    @return Contract returns the Activated Exam Contract
    */
    public Contract getExamContract(Id accountId){
        
        List<Contract> contracts = new List<Contract>();
        
        if (this.registrationType.name() == 'SCR') {
            
            contracts = [
                SELECT Id, Name, RecordTypeId, RecordType.Name
                FROM Contract 
                WHERE 
                AccountId = :accountId AND 
                RecordType.Name = 'SCR Program' AND
                Status LIKE 'Activated%'
                LIMIT 1
            ];
             
        }
        
        Contract contract = (contracts.isEmpty()) ? null : contracts[0];
        
        return contract;
        
    }

    /**
    @description creates a Certification Contract
    @param accountId the AccountId
    @param contactId the ContactId
    @param opportunityId the OpportunityId
    @return Contract returns a new contract
    */
    public Contract createExamContract(Id accountId, Id contactId, Id opportunityId, Lead lead){
        
        Contract examContract = new Contract(
            AccountId = accountId,
            Opportunity__c = opportunityId,
            CustomerSignedId = contactId,
            StartDate = System.Today(),
            ContractTerm = 12,
            Member_Email__c = lead.Email,
            BillingStreet = lead.Billing_Address_1__c + ', ' + lead.Billing_Address_2__c,
            BillingCity = lead.Billing_City__c,
            BillingCountry = lead.Billing_Country__c,
            BillingState = lead.Billing_State__c,
            BillingPostalCode = lead.Billing_Postal_Code__c,
            Pearson_Member_First_Name__c = lead.First_Name_as_it_Appears_on_ID__c,
            Pearson_Member_Middle_Name__c = lead.Middle_Name_as_it_Appears_on_ID__c,
            Pearson_Member_Last_Name__c = lead.Last_Name_as_it_Appears_on_ID__c,
            Pearson_Phone_No__c = lead.Billing_Phone_Number__c
        );
        
        if (this.registrationType.name() == 'SCR') {
            
            examContract.RecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'SCR Program');
            
        }
        
        INSERT examContract;
        
        return examContract;      
        
    }

    /**
    @description creates a single Certification Registration of type Exam_Attempt__c
    @param opportunityId the Opportunity Id
    @param contractId the Certification Program ID to associate the Exam_Attempt__c with
    @param contactId the ContactId for the user in context
    @return 
    @
    */
    public Exam_Attempt__c createCertRegistration(Id opportunityId, Id contractId, Id contactId, Lead lead){
        
        Id recordTypeId = RecordTypeHelper.GetRecordTypeId('Exam_Attempt__c', this.registrationType.name());

        // Fetch exam sites for the current Exam Group for the selected Site.
        List<Exam_Sites__c> examSites = [
            SELECT Id, Name, Site__c, Exam__c, Exam__r.Name, Exam__r.Exam__c, Exam__r.Exam_Group__c
            FROM Exam_Sites__c
            WHERE 
                Exam__r.Exam_Group__r.RecordType.Name = :this.registrationType.name() AND
                Country__c = :lead.Billing_Country__c
            LIMIT 1
        ];

        // Fallback in the event that the Exam Site could not be data mined, associate to the Global SCR Exam Site.
        if(examSites.isEmpty()){
            examSites = [
                SELECT Id, Name, Site__c, Exam__c, Exam__r.Name, Exam__r.Exam__c, Exam__r.Exam_Group__c
                FROM Exam_Sites__c
                WHERE 
                    Exam__r.Exam_Group__r.Name = :this.registrationType.name() AND 
                    Name = :this.registrationType.name()
                LIMIT 1
            ];
        }

        FINAL Id examSiteId = examSites[0].Id;
        FINAL Id examGroupId = examSites[0].Exam__r.Exam_Group__c;     
                
        Exam_Attempt__c examAttempt = new Exam_Attempt__c();
        
        examAttempt.RecordTypeId                = recordTypeId;
        examAttempt.Name                        = this.registrationType.name() + ' Registration';
        examAttempt.Member__c                   = contactId;
        examAttempt.Opportunity__c              = opportunityId;
        examAttempt.Exam_Site__c                = examSiteId;
        examAttempt.Candidate_Commitment__c     = contractId;

        INSERT examAttempt;

        Opportunity opportunity = [
            SELECT Id, Deferred_Exam_Registration__c
            FROM Opportunity
            WHERE Id = :opportunityId
        ];

        // Set Related Exam Registration for the SCR Accounting Reports 
        opportunity.Deferred_Exam_Registration__c = examAttempt.Id;
        
        UPDATE opportunity;

        return examAttempt;
        
    }

    /**
    @description adds NJ sales tax or Canadian Duty if necessary
    @param taxableProducts list of taxable items
    @param lead the lead associated with the order containing billing and shipping info
    @return List<OpportunityLineItem> returns a list of Opportunity Line Items
    */
    public List<OpportunityLineItem> addTaxAndDutyToOrder(List<OpportunityLineItem> taxableProducts, Lead lead){
                
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

    /**
    @description adds the membership product that was selected by the user
    @param membershipProduct the membership product selected by the user
    @return List<OpportunityLineItem> returns a list of Opportunity Line Items
    */
    public List<OpportunityLineItem> addMembershipToOrder(Map<String, Item> products){
        
        List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();
        
        PricebookEntry membershipPricebookEntry = null;
        if(products.containsKey('MEMI')){
            membershipPricebookEntry = this.pricebookEntries.pricebookEntryByProductCode.get('MEMI');
        }else if(products.containsKey('MEMC')){
            membershipPricebookEntry = this.pricebookEntries.pricebookEntryByProductCode.get('MEMC');
        }else{
            return null;
        }

        OpportunityLineItem membershipOli = new OpportunityLineItem(
            PricebookEntryId = membershipPricebookEntry.Id,
            Product2Id = membershipPricebookEntry.Product2Id,
            UnitPrice = membershipPricebookEntry.UnitPrice,
            Quantity = 1
        );
        
        opportunityLineItems.add(membershipOli);  
        
        return opportunityLineItems;
        
    }

    /**
    @description adds the processing fee if the user is paying by wire
    @param lead the lead wrapper that holds data about the order
    @return List<OpportunityLineItem> returns a list of Opportunity Line Items
    */
    public List<OpportunityLineItem> addProcessingFeeToOrder(Lead lead){
        
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

    /**
    @description adds the certification product associated with the order
    @param certProduct the item correlating to the certification being purchased
    @return List<OpportunityLineItem> returns a list of Opportunity Line Items
    */
    public List<OpportunityLineItem> addCertRegistrationToOrder(Item certProduct){        

        List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();

        OpportunityLineItem oli = new OpportunityLineItem(
            PricebookEntryId = certProduct.pricebookEntry.Id,
            Product2Id = certProduct.pricebookEntry.Product2Id,
            UnitPrice = certProduct.pricebookEntry.UnitPrice,
            Quantity = 1
        );
        
        opportunityLineItems.add(oli); 
        
        return opportunityLineItems;
        
    }

    /**
    @description creates an Individual Contract
    @param accountId the AccountId
    @param contactId the ContactId
    @param opportunityId the OpportunityId
    @return Contract returns a new contract
    */
    public Contract createIndividualMembershipContract(Id accountId, Id contactId, Id opportunityId, Map<String, Item> products){
        
        if(products.containsKey('MEMI') || products.containsKey('MEMC')){
            
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

    public void manualRollback(){

        Lead lead = this.lead;
        Contact contact = this.contact;
        Account account = this.account;
        Opportunity opportunity = this.opportunity;
        List<Contract> programs = this.programs;
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
            if(examRegistrations != null && !examRegistrations.isEmpty()) DELETE examRegistrations;
            
            // Deleting Lead as we cannot update an existing converted Lead unless we modify the permissions.
            DELETE lead; 
            DELETE account;
            
        }else if(!this.validatedUser.isAuthenticated){  
            
            if(programs != null && !programs.isEmpty()) DELETE programs;
            if(examRegistrations != null && !examRegistrations.isEmpty()) DELETE examRegistrations;
            
            // Deleting Lead as we cannot update an existing converted Lead unless we modify the permissions.
            DELETE lead;
            DELETE contact;
            DELETE account;
            
        }else if(this.validatedUser.isAuthenticated){

            if(programs != null && !programs.isEmpty()) DELETE programs;
            if(examRegistrations != null && !examRegistrations.isEmpty()) DELETE examRegistrations;

            // Deleting Lead as we cannot update an existing converted Lead unless we modify the permissions.
            DELETE lead;

        }
        
    }

    public CertRegistrationForm(){
        this.disableManualRollback = FALSE;
        this.disableCreditCardProcessing = FALSE;
        this.validatedUser = new ValidatedUser(UserInfo.getUserId());
        this.pricebookEntries = new PricebookEntries();
    }

}