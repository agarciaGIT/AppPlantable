public class ScrRegistrationForm extends CertRegistrationForm {
    
    // Non-authenticated
    public Map<String, Item> setCompedProperties(Map<String, Item> items){
        
        for(Item item: items.values()){
            
            switch on item.product2.ProductCode{
                when 'SCRX'{
                    item.comped = true;
                    item.selected = true;
                    item.pricebookEntry.UnitPrice = 0;
                }
                when else{
                    item.comped = false;
                }
            }
            
        }
        
        return items;  
    }
    
    // Authenticated 
    public Map<String, Item> setCompedProperties(Map<String, Item>  items, Id accountId){
        
        //Fetch all eBooks
        List<OpportunityLineItem> opportunityLineItems = [
            SELECT Product_ID__c, Opportunity.Last_Transaction_Paid_Date__c
            FROM OpportunityLineItem
            WHERE Opportunity.AccountId = :accountId AND Opportunity.StageName = 'Closed' AND Product2.Electronic_Delivery__c = TRUE
        ];
        
        //Create a map of owned eBook products by unqiue Product_ID__c
        Map<String, OpportunityLineItem> productIds = new Map<String, OpportunityLineItem>();
        for(OpportunityLineItem oli: opportunityLineItems){
            if(oli.Product_ID__c != null){
                productIds.put(oli.Product_ID__c, oli);
            }
        }
        
        for(Item item: items.values()){

            if(productIds.containsKey(item.product2.Product_ID__c)){

                item.comped = false;
                item.purchased = true;
                item.purchasedDate = productIds.get(item.product2.Product_ID__c).Opportunity.Last_Transaction_Paid_Date__c;

            }else{
                
                switch on item.product2.ProductCode{
                    when 'SCRX'{
                        item.comped = true;
                        item.selected = true;
                        item.pricebookEntry.UnitPrice = 0;
                    }
                    when else{
                        item.comped = false;
                    }
                }
                
                item.purchased = false;
                item.purchasedDate = null;
                
            }
        
        }
        
        return items;
    }

    // Retrieve non-authenticated products
    public Item getAvailableCertProduct(){

        PricebookEntry availableCertPricebookEntry = super.pricebookEntries.pricebookEntryByProductCode.get('SCRNM');   

        Item availableCertProduct = new Item(availableCertPricebookEntry);

        return availableCertProduct;

    }

    // Retrieve authenticated products
    public Item getAvailableCertProduct(Id contactId){

        // Calling method to data mine available SCR products, then transforming List<wrapperUtils.wrapperProductDetails> into Item.
        List<wrapperUtils.wrapperProductDetails> wrapperProductDetails = FBRICBRUtils.getProductCodes();

        String productCode = null;
        for(wrapperUtils.wrapperProductDetails wrapperProductDetail: wrapperProductDetails){
            if(wrapperProductDetail.strProductCode.contains('SCR')){
                productCode = wrapperProductDetail.strProductCode;
                break;
            }
        }

        if(productCode == null){
            return null;
        }

        PricebookEntry availableCertPricebookEntry = super.pricebookEntries.pricebookEntryByProductCode.get(productCode);   

        Item availableCertProduct = new Item(availableCertPricebookEntry);

        return availableCertProduct;

    }

    /**
    @description get the data to drive the registration form
    @return Response.Detail returns the generic Response.Detail object
    */   
    public Response.Detail getCertRegistrationFormData(){
            
        Response.Detail res = new Response.Detail();
                     
        ViewModel vm = new ViewModel(this);

        FINAL String FORM_KEY = vm.formKey;

        if(super.validatedUser.isAuthenticated){

            Id contactId = super.validatedUser.user.ContactId;
            Id accountId = super.validatedUser.user.AccountId;

            vm.feesByProductCode.putAll(super.getFeesMap(accountId));

            vm.availableCertProduct = this.getAvailableCertProduct(contactId);

            vm.availableBooks = this.setCompedProperties(super.createMap(super.getStudyMaterials()), accountId);
            
            vm.images = super.getCdriveImages(vm.availableBooks);  
        
            Contact contact = [
                SELECT 
                    Id, 
                    Name, 
                    FirstName, 
                    LastName, 
                    First_Name_as_it_Appears_on_ID__c,
                    Middle_Name_as_it_Appears_on_ID__c,
                    Last_Name_as_it_Appears_on_ID__c,
                    MailingAddress, 
                    MailingStreet, 
                    MailingCity, 
                    MailingState, 
                    MailingCountry, 
                    MailingPostalCode,
                    Email, 
                    Phone, 
                    OtherPhone,
                    Membership_Type__c
                FROM Contact
                WHERE Id = :contactId
            ];

            Account account = [
                SELECT 
                    Id, 
                    Name, 
                    BillingAddress, 
                    BillingStreet, 
                    BillingCity, 
                    BillingState, 
                    BillingCountry, 
                    BillingPostalCode, 
                    Phone
                FROM Account
                WHERE Id = :accountId
            ];

            vm.lead = new Lead();

            vm.contact = contact;
            
            //Auto-populate form fields
            vm.lead.LeadSource = FORM_KEY;
            vm.lead.Email = contact.Email;
            vm.lead.LastName = contact.LastName;
            vm.lead.FirstName = contact.FirstName;
            vm.lead.First_Name_as_it_Appears_on_ID__c = contact.First_Name_as_it_Appears_on_ID__c;
            vm.lead.Middle_Name_as_it_Appears_on_ID__c = contact.Middle_Name_as_it_Appears_on_ID__c;
            vm.lead.Last_Name_as_it_Appears_on_ID__c = contact.Last_Name_as_it_Appears_on_ID__c;
            
            List<String> billingStreetLines = (account.BillingStreet != null) ? account.BillingStreet.split(',') : new List<String>();

            //Auto-populate Billing Address fields
            vm.lead.Billing_Address_1__c    = (billingStreetLines.size() > 0) ? billingStreetLines[0].trim() : null;
            vm.lead.Billing_Address_2__c    = (billingStreetLines.size() > 1) ? billingStreetLines[1].trim() : null;
            vm.lead.Billing_Address_3__c    = (billingStreetLines.size() > 2) ? billingStreetLines[2].trim() : null;
            vm.lead.Billing_City__c         = account.BillingCity;
            vm.lead.Billing_State__c        = account.BillingState;
            vm.lead.Billing_Country__c      = account.BillingCountry;
            vm.lead.Billing_Postal_Code__c  = account.BillingPostalCode;
            vm.lead.Billing_Phone_Number__c = account.Phone;
            
            List<String> mailingStreetLines = (contact.MailingStreet != null) ? contact.MailingStreet.split(',') : new List<String>();
            
            //Auto-populate Shipping Address fields
            vm.lead.Shipping_Address_1__c    = (mailingStreetLines.size() > 0) ? mailingStreetLines[0].trim() : null;
            vm.lead.Shipping_Address_2__c    = (mailingStreetLines.size() > 1) ? mailingStreetLines[1].trim() : null;
            vm.lead.Shipping_Address_3__c    = (mailingStreetLines.size() > 2) ? mailingStreetLines[2].trim() : null;
            vm.lead.Shipping_City__c         = contact.MailingCity;
            vm.lead.Shipping_State__c        = contact.MailingState;
            vm.lead.Shipping_Country__c      = contact.MailingCountry;
            vm.lead.Shipping_Postal_Code__c  = contact.MailingPostalCode;
            vm.lead.Shipping_Phone_Number__c = contact.OtherPhone;
            vm.lead.Phone                    = contact.Phone;

            //Set Lead Company
            vm.lead.Company = vm.lead.LastName + ', ' + vm.lead.FirstName;

            List<Lead> leads = [SELECT Id FROM Lead WHERE IsConverted = FALSE AND Email = :contact.Email];
            
            if(leads.isEmpty()){
                INSERT vm.lead;
            }else{
                vm.lead.Id = leads[0].Id;
            }             
            
            Form_Data__c formData = new Form_Data__c(
                Email__c = vm.lead.Email,
                First_Name__c = vm.lead.FirstName,
                Last_Name__c = vm.lead.LastName
            );
            
            Utilities.manageFormSubmission(formData, FORM_KEY);
                            
        }else{
            
            vm.feesByProductCode.putAll(super.getFeesMap());

            vm.availableCertProduct = this.getAvailableCertProduct();

            vm.availableBooks = this.setCompedProperties(super.createMap(super.getStudyMaterials()));

            vm.images = super.getCdriveImages(vm.availableBooks);  
                                 
        }
                 
        res.status = 200;
        res.message = this.registrationType.name() + ' Certification Registration Form view model data retrieved successfully.';
        res.data = vm;
        
        return res;

    }

    /**
    @description get contact information
    @param contactId the contactId of the logged in user or provided by a cookie
    @return Response.Detail returns the generic Response.Detail object
    */   
    public Response.Detail getCertRegistrationInfoFormData(Id contactId){

        Response.Detail res = new Response.Detail();
                     
        ViewModel vm = new ViewModel(this);

        if(super.validatedUser.isAuthenticated){    
            contactId = super.validatedUser.user.contactId;
        }                 
        
        if(!String.isBlank(contactId)){
            vm.contact = [
                SELECT 
                    Id, 
                    Name, 
                    Company__c, 
                    Currently_Working_Status__c, 
                    Area_of_Concentration__c, 
                    Corporate_Title__c, 
                    Job_Function__c, 
                    Risk_Specialty__c,
                    Years_of_Experience__c, 
                    Professional_Designation_CA__c, 
                    Professional_Designation_CFA__c,
                    Professional_Designation_CMA__c, 
                    Professional_Designation_CPA__c,
                    Professional_Designation_PMP__c, 
                    Professional_Designation_ACCA__c, 
                    Professional_Designation_Other__c,
                    Currently_in_School_Status__c, 
                    School_Name__c, 
                    Degree_Program_Name__c,
                    Email_Information_Exchange__c,
                    How_Did_You_Hear_About_Us__c,
                    How_Did_You_Hear_About_Us_Other__c,
                    ID_Type__c,
                    ID_Number__c,
                    Name_as_it_Appears_on_ID__c
                FROM Contact
                WHERE Id = :contactId
            ]; 
            
            vm.examGroup = super.fetchExamGroup();
            vm.companies = super.fetchCompanies();
            
            Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap();

            vm.picklistValuesByFieldName = new Map<String, List<Schema.PicklistEntry>>();

            vm.picklistValuesByFieldName.put('How_Did_You_Hear_About_Us__c', fieldMap.get('How_Did_You_Hear_About_Us__c').getDescribe().getPicklistValues());
            vm.picklistValuesByFieldName.put('Area_of_Concentration__c', fieldMap.get('Area_of_Concentration__c').getDescribe().getPicklistValues());
            vm.picklistValuesByFieldName.put('Corporate_Title__c', fieldMap.get('Corporate_Title__c').getDescribe().getPicklistValues());
            vm.picklistValuesByFieldName.put('Job_Function__c', fieldMap.get('Job_Function__c').getDescribe().getPicklistValues());       
            vm.picklistValuesByFieldName.put('Risk_Specialty__c', fieldMap.get('Risk_Specialty__c').getDescribe().getPicklistValues());       

            res.status = 200;
            res.message = registrationType + ' Cert Registration Information view model retrieved successfully.';
            res.data = vm;
            
        }else{ 

              throw new Response.ResponseException(
                registrationType + ' Cert Registration Information view model retrieved unsuccessfully (ContactId not provided).', 400,
                new List<String>{registrationType + ' Cert Registration Information view model retrieved unsuccessfully (ContactId not provided).'}
            );  
            
        }
        
        return res;

    }

    /**
    @description fetches the SCR exam group 
    @return Response.Detail returns the generic Response.Detail object
    */   
    public Response.Detail getCertRegistrationCompletedFormData(){

        Response.Detail res = new Response.Detail();
                     
        ViewModel vm = new ViewModel(this);

        vm.examGroup = super.fetchExamGroup();              

        res.status = 200;
        res.message = 'Cert Registration Completed view model data retrieved successfully.';
        res.data = vm;
        
        return res;

    }

    /**
    @description pays the open order and maps fields from lead to contact
    @param chargeRequest contains the order that should be charged against
    @return Response.Detail returns the generic Response.Detail object
    */    
    public Response.Detail payCertRegistrationOrder(ChargeRequest chargeRequest){

        super.savepoint = (super.disableCreditCardProcessing) ? Database.setSavepoint() : null;
        
        Utilities.runCaptcha(chargeRequest.token);

        Id leadId          = chargeRequest.lead.Id;
        Id accountId       = chargeRequest.lead.ConvertedAccountId;
        Id contactId       = chargeRequest.lead.ConvertedContactId;
        Id opportunityId   = chargeRequest.lead.ConvertedOpportunityId;

        List<Lead> leads = [
            SELECT 
                Id, 
                LeadSource,
                Billing_Company__c, 
                Billing_Address_1__c, 
                Billing_Address_2__c, 
                Billing_Address_3__c,
                Billing_City__c, 
                Billing_State__c,
                Billing_Postal_Code__c, 
                Billing_Country__c, 
                Billing_Country_ISO_Code__c, 
                Billing_Phone_Number__c, 
                Shipping_Company__c, 
                Shipping_Address_1__c, 
                Shipping_Address_2__c, 
                Shipping_Address_3__c, 
                Shipping_City__c, 
                Shipping_State__c, 
                Shipping_Postal_Code__c, 
                Shipping_Country__c, 
                Shipping_Country_ISO_Code__c,
                Shipping_Phone_Number__c, 
                Date_of_Birth__c,
                ID_Expiration_Date__c,
                ID_Type__c,
                ID_Number__c,
                Name_as_it_Appears_on_ID__c,
                Full_Name_in_Chinese__c,
                Gender__c,
                Work_Status__c,
                Student_Status__c,
                School_Name__c,
                Degree_Name__c,
                Company__c,
                Phone,
                FirstName,
                LastName,
                First_Name_as_it_Appears_on_ID__c,
                Middle_Name_as_it_Appears_on_ID__c,
                Last_Name_as_it_Appears_on_ID__c,
                Email
            FROM Lead 
            WHERE Id = :leadId
        ];

        List<Account> accounts = [
            SELECT Id, RecordType.Name
            FROM Account 
            WHERE Id = :accountId
        ];

        List<Contact> contacts = new List<Contact>();
            
        if(super.validatedUser.isAuthenticated){
            contacts = [
                SELECT Id, AccountId, RecordType.Name, GARP_ID_New__c, Original_Business_Account_ID__c, Original_Business_Contact_Owner_ID__c
                FROM Contact 
                WHERE Id = :contactId
            ];
        }else{
            contacts = [
                SELECT Id, AccountId, RecordType.Name, GARP_ID_New__c, Original_Business_Account_ID__c, Original_Business_Contact_Owner_ID__c,
                (SELECT Id, AccountId, ContactId, IsDirect FROM AccountContactRelations)
                FROM Contact 
                WHERE Id = :contactId
            ];  
        }

        List<Opportunity> opportunities = [
            SELECT Id, Name, Payment_Method__c, Display_Invoice_Number__c, Company__c, Amount,
            (
                SELECT Id, Name, OpportunityId, PricebookEntryId, Product2Id, Product2.Family, Product2.Weight__c, Product2.Taxable__c, UnitPrice, Quantity, Is_Registration_Fee__c, ProductCode 
                FROM OpportunityLineItems
            ),
            (
                SELECT Id FROM Exam_Registrations__r
            )
            FROM Opportunity
            WHERE Id = :opportunityId
        ];

        if(leads.isEmpty()){
            throw new Response.ResponseException(
                'Unable to locate Lead with ID ' + leadId + '.', 
                400, 
                new List<Object>{'Unable to locate Lead with ID ' + leadId + '.'}
            );
        }

        super.lead = leads[0];

        if(accounts.isEmpty()){
            throw new Response.ResponseException(
                'Unable to locate Account with ID ' + accountId + '.', 
                400, 
                new List<Object>{'Unable to locate Account with ID ' + accountId + '.'}
            );
        }

        super.account = accounts[0];

        if(contacts.isEmpty()){
            throw new Response.ResponseException(
                'Unable to locate Contact with ID ' + contactId + '.', 
                400, 
                new List<Object>{'Unable to locate Contact with ID ' + contactId + '.'}
            );
        }

        super.contact = contacts[0];

        if(opportunities.isEmpty()){
            throw new Response.ResponseException(
                'Unable to locate Opportunity with ID ' + opportunityId + '.', 
                400, 
                new List<Object>{'Unable to locate Opportunity with ID ' + opportunityId + '.'}
            );
        }
            
        super.opportunity = opportunities[0];

        super.programs = [
            SELECT Id, Opportunity__c 
            FROM Contract
            WHERE Opportunity__c IN :opportunities
        ];

        ChargeResponse chargeResponse = new ChargeResponse();

        if(chargeRequest.lead.Payment_Type__c == 'Credit Card' && !super.disableCreditCardProcessing){

            Payment payment = new Payment(
                chargeRequest.card.cardNumber, 
                chargeRequest.card.securityCode, 
                chargeRequest.card.expirationMonth, 
                chargeRequest.card.expirationYear                    
            );
            
            chargeResponse.chargentResult = payment.charge(opportunityId);
            
            System.debug(chargeResponse.chargentResult);
            
            if(!chargeResponse.chargentResult.Message.contains('Approved')){
                throw new Response.ResponseException(
                    chargeResponse.chargentResult.Message, 
                    400, 
                    new List<Object>{
                        chargeResponse.chargentResult.Message
                            }
                );
            }
            
        }

        if(!super.disableCreditCardProcessing){
            //If credit card processing is disabled, setSavepoint in beginning of method execution.
            savepoint = Database.setSavepoint();
        }

        Contract membershipContract = null;

        if(super.validatedUser.isAuthenticated){

            membershipContract = super.getMembershipContract(
                super.validatedUser.user.AccountId
            );

        }                               

        if(membershipContract == null){
            super.createAffiliateContractAndOrder();
        }                               

        //Set Account Billing Address to Lead Shipping Address fields
        account.BillingStreet       = '';
        account.BillingStreet       += (lead.Billing_Address_1__c != null) ? lead.Billing_Address_1__c : '';
        account.BillingStreet       += (lead.Billing_Address_2__c != null) ? ', ' + lead.Billing_Address_2__c : '';
        account.BillingStreet       += (lead.Billing_Address_3__c != null) ? ', ' + lead.Billing_Address_3__c : '';
        account.BillingCity         = lead.Billing_City__c;
        account.BillingState        = lead.Billing_State__c;
        account.BillingCountry      = lead.Billing_Country__c;
        account.BillingPostalCode   = lead.Billing_Postal_Code__c;
        account.Phone               = lead.Billing_Phone_Number__c;
        
        account.Member_First_Name__c    = lead.FirstName;
        account.Member_Last_Name__c     = lead.LastName;

        //Set Account Owner and Record Type
        account.OwnerId = [SELECT Id, Record_id__c FROM updateids__c WHERE name = 'User' LIMIT 1].Record_id__c;
        account.RecordTypeId = RecordTypeHelper.GetRecordTypeId('Account', 'Individual');

        UPDATE account;

        //Set Contact Mailing Address to Lead Shipping Address fields
        contact.MailingStreet       = '';
        contact.MailingStreet       += (lead.Shipping_Address_1__c != null) ? lead.Shipping_Address_1__c : '';
        contact.MailingStreet       += (lead.Shipping_Address_2__c != null) ? ', ' + lead.Shipping_Address_2__c : '';
        contact.MailingStreet       += (lead.Shipping_Address_3__c != null) ? ', ' + lead.Shipping_Address_3__c : '';
        contact.MailingCity         = lead.Shipping_City__c;
        contact.MailingState        = lead.Shipping_State__c;
        contact.MailingCountry      = lead.Shipping_Country__c;
        contact.MailingPostalCode   = lead.Shipping_Postal_Code__c;
        contact.OtherPhone          = lead.Shipping_Phone_Number__c;
        contact.Phone               = lead.Phone;     

        //Map name as it appears on ID fields
        contact.First_Name_as_it_Appears_on_ID__c   = lead.First_Name_as_it_Appears_on_ID__c;
        contact.Middle_Name_as_it_Appears_on_ID__c  = lead.Middle_Name_as_it_Appears_on_ID__c;
        contact.Last_Name_as_it_Appears_on_ID__c    = lead.Last_Name_as_it_Appears_on_ID__c;

        //Enable Community User creation on UPDATE
        contact.DO_NOT_FIRE__c = FALSE;
        contact.RecordTypeId = RecordTypeHelper.GetRecordTypeId('Contact', 'Member');


        UPDATE contact;
        
        Utilities.migrateLeadFormDataToContact(lead.Id, contact.Id, lead.LeadSource, null); 

        Response.Detail res = new Response.Detail();

        chargeResponse.contact = [
            SELECT Id, Name 
            FROM Contact 
            WHERE Id = :contact.Id
        ];
        
        chargeResponse.opportunity = opportunity;

        res.data = chargeResponse;
        res.status = 200;

        return res;

    }

    /**
    @description update the contact's info
    @param contact the contact record related to the user working on the form
    @return Response.Detail returns the generic Response.Detail object
    */     
    public Response.Detail updateCertRegistrationInfo(Contact contact){

        Response.Detail res = new Response.Detail();

        UPDATE contact;

        res.status = 200;
        res.message = 'Contact with ID ' + contact.Id + ' updated succesfully.';
        res.data = contact;
        
        return res;    
    
    }

    /**
    @description creates the order that will be returned to the client to be paid
    @param registrationRequest the registration order to be process, generated by the client
    @return Response.Detail returns the generic Response.Detail object
    */    
    public Response.Detail createCertRegistrationOrder(RegistrationRequest registrationRequest){
            
        FINAL String FORM_KEY = 'cert-registration-' + registrationRequest.registrationType.toLowerCase();
        FINAL Map<String, Item> FEES_MAP = new Map<String, Item>();
        Response.Detail res = new Response.Detail();
            
        // Retrieve eligible product for authenticated and non-authenticated users and add to the RegistrationRequest object
        if(super.validatedUser.isAuthenticated){
            registrationRequest.certProduct = this.getAvailableCertProduct(super.validatedUser.user.ContactId);
            FEES_MAP.putAll(super.getFeesMap(super.validatedUser.user.AccountId));
        }else{
            registrationRequest.certProduct = this.getAvailableCertProduct();
            FEES_MAP.putAll(super.getFeesMap());
        }
        
        // If no product is available, the user is not eligible or the exam is closed
        if(registrationRequest.certProduct == null){   
            throw new Response.ResponseException('You are ineligible to take this exam.', 400, new List<String>{'You are ineligible to take this exam.'});  
        }

        // Convert SCRNM to SCRM for non-members purchasing membership
        if(registrationRequest.products.containsKey('MEMI') && registrationRequest.certProduct.pricebookEntry.ProductCode == 'SCRNM'){

            // If the MEMI product is unavailable to user, the product passed to backend was manipulated.
            if(!FEES_MAP.containsKey('MEMI')){
                throw new Response.ResponseException('You are ineligible to purchase membership.', 400, new List<String>{'You are ineligible to purchase membership.'});  
            }

            // Set the SCRM product to align with membership.
            registrationRequest.certProduct = new Item(super.pricebookEntries.pricebookEntryByProductCode.get('SCRM'));

        }
        
        // Set the correct exam group
        registrationRequest.examGroup = super.fetchExamGroup();

        //Prevent Commmunity User creation during Lead Conversion
        registrationRequest.lead.DO_NOT_FIRE__c = TRUE;

        //Ensure Company field is set
        if(registrationRequest.lead.Company == null || registrationRequest.lead.Company == ''){
            registrationRequest.lead.Company = registrationRequest.lead.LastName + ', ' + registrationRequest.lead.FirstName;
        }

        if(registrationRequest.lead.Id == null){     
            throw new Response.ResponseException(
                'Lead ID is missing, unable to complete Exam Registration request.', 400,
                new List<String>{'Lead ID is missing, unable to complete Exam Registration request.'}
            );              
        }

        List<Lead> leads = [
            SELECT Id, IsConverted, IsDeleted, ConvertedAccountId, ConvertedContactId, ConvertedOpportunityId
            FROM Lead 
            WHERE Id = :registrationRequest.lead.Id AND IsDeleted = FALSE
        ];
        
        if(!leads.isEmpty() && leads[0].IsConverted){
            
            List<Opportunity> opportunities = [
                SELECT Id, Name, 
                (SELECT Id, ChargentSFA__Response_Status__c FROM ChargentSFA__Transactions__r WHERE ChargentSFA__Response_Status__c = 'Approved')
                FROM Opportunity
                WHERE Id = :registrationRequest.lead.ConvertedOpportunityId 
            ];

            if(opportunities.isEmpty()){
                throw new Response.ResponseException(
                    'Unable to fetch Opportunity with ID ' + leads[0].ConvertedOpportunityId + '.', 400, 
                    new List<Object>{'Unable to locate Opportunity with ID ' + leads[0].ConvertedOpportunityId + '.'}
                );
            }else if(!opportunities.isEmpty() && !opportunities[0].ChargentSFA__Transactions__r.isEmpty()){
                throw new Response.ResponseException(
                    'Opportunity with ID ' + leads[0].ConvertedOpportunityId + ' has already been paid.', 205, 
                    new List<Object>{'Opportunity with ID ' + leads[0].ConvertedOpportunityId + ' has already been paid.'}
                );
            }

        }
        
        if(!leads.isEmpty()){  
            // Re-use existing Lead to prevent duplicates from being created, by assigning existing ID to in-memory object.
            registrationRequest.lead.Id = leads[0].Id;             
        }
        
        if(leads.isEmpty()){
            // Remove Lead ID from in-memory object, as the ID no longer exists.
            registrationRequest.lead.Id = null;
        }

        List<OpportunityLineItem> stagedOpportunityLineItems = this.stageOpportunityLineItems(registrationRequest);

        super.savepoint = Database.setSavepoint();

        Utilities.updateFormSession(registrationRequest.token, registrationRequest.lead.Email);
        Utilities.runCaptcha(registrationRequest.token);            
        
        UPSERT registrationRequest.lead;
        
        Form_Data__c formData = new Form_Data__c(
            Email__c = registrationRequest.lead.Email,
            First_Name__c = registrationRequest.lead.FirstName,
            Last_Name__c = registrationRequest.lead.LastName
        );
        
        Utilities.manageFormSubmission(formData, FORM_KEY); 
        
        Database.LeadConvert convertLead = new Database.LeadConvert(); 

        convertLead.setLeadId(registrationRequest.lead.Id);

        if(super.validatedUser.isAuthenticated){  

            /**
             * If the user is logged in 
             * set the Account ID and Contact ID accordingly
             */

            convertLead.setAccountId(super.validatedUser.user.AccountId);
            convertLead.setContactId(super.validatedUser.user.ContactId);     

        }else{

            // Check for existing member contacts 
            List<Contact> existingMembers = [
                SELECT Id FROM Contact WHERE Email = :registrationRequest.lead.Email AND RecordType.Name = 'Member'
            ]; 
            
            // If contacts exist, this implies that the user's session has expired
            if(!existingMembers.isEmpty()){
                throw new Response.ResponseException(
                    'Your session has expired.  Please login to continue.', 403, 
                    new List<Object>{'Your session has expired.  Please login to continue.'}
                );   
            }

            /**
             * If a Business Relationship contact exists
             * set the Account ID and Contact ID accordingly
             */

            List<Contact> contacts = [
                SELECT Id, Name, Email, OwnerId, AccountId, RecordTypeId, RecordType.Id, RecordType.Name, GARP_ID_New__c, Original_Business_Account_ID__c, Original_Business_Contact_Owner_ID__c 
                FROM Contact 
                WHERE Email = :registrationRequest.lead.Email AND RecordType.Name = 'Business Relationship'
            ];

            if(!contacts.isEmpty()){
                
                Id userId = [SELECT Id, Name, Record_Id__c FROM UpdateIds__c WHERE Name = 'User'].Record_Id__c;
                
                Contact businessRelationshipContact = contacts[0];
                
                Id rollbackOwnerId = businessRelationshipContact.OwnerId;
                Id rollbackAccountId = businessRelationshipContact.AccountId;

                //Create Individual Account
                Account account = new Account(
                    Name = registrationRequest.lead.LastName + ', ' + registrationRequest.lead.FirstName,
                    RecordTypeID = RecordTypeHelper.GetRecordTypeId('Account', 'Individual'),
                    OwnerId = userId
                );
                
                INSERT account;
                
                /**
                * Convert Business Relationship Contact to Member
                * Associate with new Individual Account
                * Set Original Business Account ID for Manual Rollback
                * */
                businessRelationshipContact.LastName = registrationRequest.lead.LastName;
                businessRelationshipContact.FirstName = registrationRequest.lead.FirstName;
                businessRelationshipContact.OwnerId = userId;
                businessRelationshipContact.AccountId = account.Id;
                businessRelationshipContact.Original_Business_Account_ID__c = rollbackAccountId;
                businessRelationshipContact.Original_Business_Contact_Owner_ID__c = rollbackOwnerId;
                businessRelationshipContact.RecordTypeId = RecordTypeHelper.GetRecordTypeId('Contact', 'Member');
                businessRelationshipContact.do_not_fire__c = true;
                
                UPDATE businessRelationshipContact;
                
                convertLead.setAccountId(account.Id);
                convertLead.setContactId(businessRelationshipContact.Id);
                
            }

        }

        LeadStatus leadStatus = [
            SELECT Id, MasterLabel 
            FROM LeadStatus 
            WHERE IsConverted = TRUE LIMIT 1
        ];
        
        convertLead.setConvertedStatus(leadStatus.MasterLabel);
        
        Database.LeadConvertResult leadConvertResult = Database.convertLead(convertLead);
        
        if(leadConvertResult.isSuccess()){

            Lead convertedLead = [
                SELECT 
                    Id, 
                    Name, 
                    ConvertedAccountId, 
                    ConvertedContactId,
                    ConvertedContact.GARP_ID_New__c,
                    ConvertedDate,                  
                    ConvertedOpportunityId,
                    Billing_Company__c, 
                    Billing_Address_1__c, 
                    Billing_Address_2__c, 
                    Billing_Address_3__c,
                    Billing_City__c, 
                    Billing_State__c,
                    Billing_Postal_Code__c, 
                    Billing_Country__c, 
                    Billing_Country_ISO_Code__c, 
                    Billing_Phone_Number__c, 
                    Shipping_Company__c, 
                    Shipping_Address_1__c, 
                    Shipping_Address_2__c, 
                    Shipping_Address_3__c, 
                    Shipping_City__c, 
                    Shipping_State__c, 
                    Shipping_Postal_Code__c, 
                    Shipping_Country__c, 
                    Shipping_Country_ISO_Code__c,
                    Shipping_Phone_Number__c, 
                    Date_of_Birth__c,
                    ID_Expiration_Date__c,
                    Company__c,
                    Phone,
                    FirstName,
                    LastName,
                    First_Name_as_it_Appears_on_ID__c,
                    Middle_Name_as_it_Appears_on_ID__c,
                    Last_Name_as_it_Appears_on_ID__c,
                    Email,
                    Payment_Type__c
                FROM Lead 
                WHERE Id = :registrationRequest.lead.Id
            ];
            
            Id contactId        = convertedLead.ConvertedContactId;
            Id accountId        = convertedLead.ConvertedAccountId;
            Id opportunityId    = convertedLead.ConvertedOpportunityId;       
                        
            //Manually setting the GARP ID to ensure that the GARP ID is mirrored from the Contact and set on the Account.
            UPDATE new Account(Id = accountId, GARP_ID__c = convertedLead.ConvertedContact.GARP_ID_New__c);

            for(OpportunityLineItem oli: stagedOpportunityLineItems){
                oli.OpportunityId = opportunityId;
            }
            
            INSERT stagedOpportunityLineItems;
                            
            List<OpportunityLineItem> opportunityLineItems = [
                SELECT Id, Name, OpportunityId, PricebookEntryId, Product2Id, Product2.Family, Product2.Weight__c, Product2.Taxable__c, UnitPrice, Quantity, Is_Registration_Fee__c, ProductCode 
                FROM OpportunityLineItem
                WHERE OpportunityId = :opportunityId
            ];

            Opportunity opportunity = new Opportunity(Id = opportunityId);
            
            //Ensure Membership Contract is created and activated when Opportunity is closed.
            opportunity.RecordTypeId = RecordTypeHelper.GetRecordTypeId('Opportunity', 'Automated');
            opportunity.Eligible_for_Membership_Extension__c = true;

            //Manually map fields and set required values.
            opportunity.Name                            = 'SCR Registration';
            opportunity.Alternate_Method_of_Payment__c  = convertedLead.Payment_Type__c;
            opportunity.Shipping_Street__c              = '';
            opportunity.Shipping_Street__c              += (convertedLead.Shipping_Address_1__c != null) ? convertedLead.Shipping_Address_1__c : '';
            opportunity.Shipping_Street__c              += (convertedLead.Shipping_Address_2__c != null) ? ', ' + convertedLead.Shipping_Address_2__c : '';
            opportunity.Shipping_Street__c              += (convertedLead.Shipping_Address_3__c != null) ? ', ' + convertedLead.Shipping_Address_3__c : '';           
            opportunity.Shipping_State__c               = convertedLead.Shipping_State__c;
            opportunity.ChargentSFA__Shipping_State__c  = convertedLead.Shipping_State__c;
            opportunity.Shipping_Country__c             = convertedLead.Shipping_Country__c;
            opportunity.ChargentSFA__Shipping_Country__c= convertedLead.Shipping_Country__c;
            opportunity.ChargentSFA__Billing_Email__c   = convertedLead.Email;
            opportunity.Shipping_E_mail__c              = convertedLead.Email;
            opportunity.ChargentSFA__Billing_First__c   = convertedLead.FirstName;
            opportunity.ChargentSFA__Billing_Last__c    = convertedLead.LastName;
            opportunity.Shipping_First_Name__c          = convertedLead.FirstName;
            opportunity.Shipping_Last_Name__c           = convertedLead.LastName;

            opportunity.Has_Books__c = false;
            for(OpportunityLineItem oli: opportunityLineItems){
                if(oli.Product2.Family == 'Books' && oli.Product2.Weight__c > 0){
                    opportunity.Has_Books__c = true;    
                }
            }

            UPDATE opportunity;
                                                                                                                                                                                                                                                                                                                                                                                                                        
            if(super.validatedUser.isAuthenticated){   

                Contract existingContract = super.getExamContract(super.validatedUser.user.AccountId);          
                
                if(existingContract != null){
                    throw new Response.ResponseException(
                        'There is an existing SCR Contract.', 400,
                        new List<String>{'There is an existing SCR Contract.'}
                    );  
                }

                Contract certContract = createExamContract(
                    accountId, 
                    contactId, 
                    opportunityId,
                    convertedLead
                );
            
                Exam_Attempt__c examRegistration = createCertRegistration(
                    opportunityId, 
                    certContract.Id,
                    contactId,
                    convertedLead
                );

            }else{

                // [DL:05/12/2020] Delegating program creation to opportunityTriggerUtils.updateRenewContracts(Set<Id> setOpps,Set<Id> setAccountIds,Map<Id,Set<String>> mapProdCodesWithAccount,opportunity opp)
                Contract membershipContract = createIndividualMembershipContract(
                    accountId, 
                    contactId, 
                    opportunityId, 
                    registrationRequest.products
                );

                Contract certContract = createExamContract(
                    accountId, 
                    contactId, 
                    opportunityId,
                    convertedLead
                );

                Exam_Attempt__c examRegistration = createCertRegistration(
                    opportunityId, 
                    certContract.Id,
                    contactId,
                    convertedLead
                );

            }  

            RegistrationResponse registrationResponse = new RegistrationResponse();
            
            registrationResponse.lead = convertedLead;
            registrationResponse.opportunity = [
                SELECT Id, Name, Display_Invoice_Number__c, Company__c, Amount,
                (
                    SELECT Id, Name, OpportunityId, PricebookEntryId, Product2Id, Product2.Family, Product2.Weight__c, Product2.Taxable__c, UnitPrice, Quantity, Is_Registration_Fee__c, ProductCode 
                    FROM OpportunityLineItems
                )
                FROM Opportunity
                WHERE Id = :opportunityId
            ];

            res.status = 200;
            res.data = registrationResponse;

        }else{

            throw new Response.ResponseException(
                'Lead conversion failed.', 400,
                leadConvertResult.getErrors()
            );

        }
        
        return res;

    }

    /**
    @description adds study materials to the order
    @param studyMaterials list of study materials selected by the user
    @return List<OpportunityLineItem> returns a list of Opportunity Line Items
    */
    public List<OpportunityLineItem> addScrStudyMaterials(Map<String, Item> studyMaterials){
        
        List<OpportunityLineItem> olis = new List<OpportunityLineItem>();
        
        for(Item item: studyMaterials.values()){
            
            if(super.pricebookEntries.pricebookEntryById.containsKey(item.pricebookEntry.Id)){
                
                PricebookEntry pbe = super.pricebookEntries.pricebookEntryById.get(item.pricebookEntry.Id);

                // Only add study materials to order
                if(pbe.Product2.Family != 'Books'){
                    continue;
                }
                
                OpportunityLineItem oli = new OpportunityLineItem();
                
                oli.PricebookEntryId = pbe.Id;
                oli.Product2Id = pbe.Product2Id;
                oli.Quantity = 1;
                
                // Define study materials that are always to be comped
                switch on pbe.ProductCode{
                    when 'SCRX'{
                        oli.UnitPrice = 0;
                    }
                    when else{
                        oli.UnitPrice = pbe.UnitPrice;
                    }
                }
                
                olis.add(oli);
                
            }
            
        }
        
        return olis;
        
    }
    
    /**
    @description stages the order by adding user selected products and system specified fees
    @param registrationRequest the registration object that creates the order
    @return List<OpportunityLineItem> returns a list of Opportunity Line Items
    */
    public List<OpportunityLineItem> stageOpportunityLineItems(RegistrationRequest registrationRequest){
        
        FINAL Id contactId = super.validatedUser.user.contactId;
        FINAL Id examGroupId = registrationRequest.examGroup.Id;
        
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
        
        List<OpportunityLineItem> studyMaterials = addScrStudyMaterials(registrationRequest.products);
        if(studyMaterials != null && !studyMaterials.isEmpty()){
            opportunityLineItems.addAll(studyMaterials);
        }
        
        List<OpportunityLineItem> taxesAndDuty = super.addTaxAndDutyToOrder(opportunityLineItems, registrationRequest.lead);
        if(taxesAndDuty != null && !taxesAndDuty.isEmpty()){
            opportunityLineItems.addAll(taxesAndDuty);
        }  
        
        List<OpportunityLineItem> membership = super.addMembershipToOrder(registrationRequest.products);
        if(membership != null && !membership.isEmpty()){
            opportunityLineItems.addAll(membership);
        }
        
        List<OpportunityLineItem> processingFee = addProcessingFeeToOrder(registrationRequest.lead);
        if(processingFee != null && !processingFee.isEmpty()){
            opportunityLineItems.addAll(processingFee);
        }
    
        List<OpportunityLineItem> certRegistration = super.addCertRegistrationToOrder(registrationRequest.certProduct);
        if(certRegistration != null && !certRegistration.isEmpty()){
            opportunityLineItems.addAll(certRegistration);     
        }
        
        return opportunityLineItems;
        
    }

    public ScrRegistrationForm() {
        super.registrationType = CertRegistrationForm.RegistrationTypes.SCR;
    }

}