public class ExamRegistrationFormHelper {
        
    public static Response.Detail getExamRegistrationFormData(ExamRegistrationForm form, String teamRegistrationCode){

        Response.Detail res = new Response.Detail();
                    
        ExamRegistrationForm.ViewModel vm = new ExamRegistrationForm.ViewModel(form);

        vm.token = Utilities.getFormSessionToken();

        FINAL String FORM_KEY = vm.formKey;
       
        if(teamRegistrationCode != NULL) {
            vm.teamRegistration = form.getTeamRegistration(teamRegistrationCode);
            form.teamRegistration = vm.teamRegistration;
            if(teamRegistrationCode != NULL && vm.teamRegistration == NULL) {
                res.status = 500;
                res.message = vm.registrationType + ' Exam Registration Form not available for this team registration code.';
                res.data = vm;            
                return res;
            }
        }
        
        if(form.validatedUser.isAuthenticated){

            Id contactId = form.validatedUser.user.ContactId;
            Id accountId = form.validatedUser.user.AccountId;

            vm.isAuthenticated = true;

            ExamRegistrationForm.RegistrationEligibility ee = form.getEligibileExams(NULL);
            
            Set<String> examPartNames = ee.eligibleExams;

            String debugMsg='';
            
            vm.examEligibility = ee;
            if(!examPartNames.isEmpty()){
                vm.examSelectionOptions = form.getExamSelectionOptions(examPartNames);
                vm.availableBooks = form.createMap(form.getStudyMaterials(form.getExamPartNumbers(vm.examSelectionOptions.exams)), accountId);
                vm.images = form.getCdriveImages(vm.availableBooks);  
                vm.feesByProductCode.putAll(form.getFeesMapAuthenticated(vm.examSelectionOptions.options));
            }
            
            Contact contact = [
                SELECT Id, Name, FirstName, LastName, MailingAddress, MailingStreet, MailingCity, MailingState, MailingCountry, MailingPostalCode,
                       Email, ID_Type__c, ID_Number__c, Name_As_it_Appears_On_ID__c, ID_Expiration_Date__c, 
                       Full_Name_in_Chinese__c, Birthdate, Gender__c, Phone, OtherPhone, Currently_Working_Status__c,  
                       Company__c, Currently_in_School_Status__c, KPI_Membership_Auto_Renew_Status__c, School_Name__c, 
                       Degree_Program_Name__c, Membership_Type__c, KPI_Membership_Payment_Status__c
                FROM Contact
                WHERE Id = :contactId
            ];

            Account account = [
                SELECT Id, Name, BillingAddress, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode, 
                	   Phone, Block_Purchases_All_Types__c ,Block_Purchases_Except_Wire__c
                FROM Account
                WHERE Id = :accountId
            ];

            vm.lead = new Lead();
            vm.contact = contact;
            
            //Auto-populate form fields
            vm.lead.LeadSource = FORM_KEY;
            vm.lead.FirstName = contact.FirstName;
            vm.lead.LastName = contact.LastName;
            vm.lead.Email = contact.Email;
            //vm.lead.ID_Type__c = contact.ID_Type__c;
            
            if(contact.ID_Type__c != NULL) {
                if(contact.ID_Type__c.indexOf('Driver') > -1) {
                    vm.lead.ID_Type__c = 'Driver\'s License';
                } else {
                    vm.lead.ID_Type__c = contact.ID_Type__c;    
                }                    
            }            
            
            vm.lead.ID_Number__c = contact.ID_Number__c;
            vm.lead.ID_Expiration_Date__c = contact.ID_Expiration_Date__c;
            vm.lead.Name_as_it_Appears_on_ID__c = contact.Name_As_it_Appears_On_ID__c;
            vm.lead.Full_Name_in_Chinese__c = contact.Full_Name_in_Chinese__c;
            vm.lead.Gender__c = contact.Gender__c;
            vm.lead.Date_of_Birth__c = contact.Birthdate;
            vm.lead.Student_Status__c = contact.Currently_in_School_Status__c;
            vm.lead.Work_Status__c = contact.Currently_Working_Status__c;
            vm.lead.School_Name__c = contact.School_Name__c;
            vm.lead.Degree_Name__c = contact.Degree_Program_Name__c;
            vm.lead.Company__c = contact.Company__c;

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
            
            // AG 2/28/2022 - Block Purchase
            vm.isPaymentBlocked = account.Block_Purchases_All_Types__c;
            vm.isPaymentRestricted = account.Block_Purchases_Except_Wire__c;
            
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
            
            vm.isAuthenticated = false;

            if(vm.registrationType != 'ERP') {
                
                vm.examSelectionOptions = form.getExamSelectionOptions();
                
                system.debug('vm.examSelectionOptions:' + vm.examSelectionOptions);
    
                vm.availableBooks = form.createMap(form.getStudyMaterials(form.getExamPartNumbers(vm.examSelectionOptions.exams)));
                
                system.debug('vm.availableBooks:' + vm.availableBooks);
                
                vm.images = form.getCdriveImages(vm.availableBooks);  
                
                system.debug('vm.images:' + vm.images);
                
                vm.feesByProductCode.putAll(form.getFeesMap());
                
                system.debug('vm.feesByProductCode:' + vm.feesByProductCode);
            
            }
        }
                    
        res.status = 200;
        res.message = vm.registrationType + ' Exam Registration Form view model data retrieved successfully.';
        res.data = vm;
        
        return res;

    }

    public static Response.Detail createExamRegistrationOrder(ExamRegistrationForm form, ExamRegistrationForm.RegistrationRequest registrationRequest){
    
        ExamRegistrationForm.ViewModel vm = new ExamRegistrationForm.ViewModel(form);

        FINAL String FORM_KEY = vm.formKey;
                            
        Response.Detail res = new Response.Detail();

        if(registrationRequest.teamRegistrationInfo != NULL && registrationRequest.teamRegistrationInfo.teamRegistrationId != NULL) {
            vm.teamRegistration = form.getTeamRegistration(ID.ValueOf(registrationRequest.teamRegistrationInfo.teamRegistrationId));
            form.teamRegistration = vm.teamRegistration;
        }
        
        registrationRequest.examGroup = form.examGroup;
        //Prevent Commmunity User creation during Lead Conversion
        registrationRequest.lead.DO_NOT_FIRE__c = true;

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

        List<OpportunityLineItem> stagedOpportunityLineItems = form.stageOpportunityLineItems(registrationRequest);
        system.debug(stagedOpportunityLineItems);
        form.savepoint = Database.setSavepoint();

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

        if(form.validatedUser.isAuthenticated){  

            /**
             * If the user is logged in 
             * set the Account ID and Contact ID accordingly
             */

            convertLead.setAccountId(form.validatedUser.user.AccountId);
            convertLead.setContactId(form.validatedUser.user.ContactId);     

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

            System.debug(contacts);

            if(!contacts.isEmpty()){
                
                Id userId = [SELECT Id, Name, Record_Id__c FROM UpdateIds__c WHERE Name = 'User'].Record_Id__c;
                
                Contact businessRelationshipContact = contacts[0];
                
                Id rollbackOwnerId = businessRelationshipContact.OwnerId;
                Id rollbackAccountId = businessRelationshipContact.AccountId;

                //Create Individual Account
                Account account = new Account(
                    Name = registrationRequest.lead.LastName + ', ' + registrationRequest.lead.FirstName,
                    RecordTypeID = RecordTypeHelper.GetRecordTypeIdFromSchema('Account', 'Individual'),
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
                businessRelationshipContact.RecordTypeId = RecordTypeHelper.GetRecordTypeIdFromSchema('Contact', 'Member');
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
                SELECT Id, Name, ConvertedAccountId, ConvertedContactId, ConvertedContact.GARP_ID_New__c, ID_Number__c, Exam_Prep_Provider_Outreach__c, ConvertedDate, ConvertedOpportunityId, Billing_Company__c, Billing_Address_1__c, Billing_Address_2__c, Billing_Address_3__c, Billing_City__c, Billing_State__c, Billing_Postal_Code__c, Billing_Country__c, Billing_Country_ISO_Code__c, Billing_Phone_Number__c, Shipping_Company__c, Shipping_Address_1__c, Shipping_Address_2__c, Shipping_Address_3__c, Shipping_City__c, Shipping_State__c, Shipping_Postal_Code__c, Shipping_Country__c, Shipping_Country_ISO_Code__c, Shipping_Phone_Number__c, Date_of_Birth__c, ID_Expiration_Date__c, Company__c, Phone, FirstName, LastName, Email, Payment_Type__c
                FROM Lead 
                WHERE Id = :registrationRequest.lead.Id
            ];
            
            Id contactId        = convertedLead.ConvertedContactId;
            Id accountId        = convertedLead.ConvertedAccountId;
            Id opportunityId    = convertedLead.ConvertedOpportunityId;       
                          
            //Manually setting the GARP ID to ensure that the GARP ID is mirrored from the Contact and set on the Account.
            UPDATE new Account(Id = accountId, GARP_ID__c = convertedLead.ConvertedContact.GARP_ID_New__c);
            
            // Manually set the Exam Prep Provider Opt In
            // AG 12/14/2021 -- Update OSTA ID info
            if(form.validatedUser.isAuthenticated){  
                if(convertedLead.ID_Number__c != NULL && convertedLead.ID_Number__c.length() > 5) {
                    UPDATE new Contact(OSTA_Full_ID__c = convertedLead.ID_Number__c,ID_Number__c = convertedLead.ID_Number__c.Right(5), Id = contactId, Exam_Prep_Provider_Outreach__c = convertedLead.Exam_Prep_Provider_Outreach__c);                    
                } else {
                    UPDATE new Contact(Id = contactId, Exam_Prep_Provider_Outreach__c = convertedLead.Exam_Prep_Provider_Outreach__c);    
                }
            } else if(convertedLead.ID_Number__c != NULL && convertedLead.ID_Number__c.length() > 5) {
                UPDATE new Contact(OSTA_Full_ID__c = convertedLead.ID_Number__c,ID_Number__c = convertedLead.ID_Number__c.Right(5), Id = contactId, Exam_Prep_Provider_Outreach__c = convertedLead.Exam_Prep_Provider_Outreach__c);                                    
            }
            
            
            for(OpportunityLineItem oli: stagedOpportunityLineItems){
                oli.OpportunityId = opportunityId;
            }
            
            INSERT stagedOpportunityLineItems;
            
            System.debug(stagedOpportunityLineItems);
            
            List<OpportunityLineItem> opportunityLineItems = [
                SELECT Id, Name, OpportunityId, PricebookEntryId, Product2Id, Product2.Family, Product2.Weight__c, Product2.Taxable__c, UnitPrice, Quantity, Is_Registration_Fee__c, ProductCode 
                FROM OpportunityLineItem
                WHERE OpportunityId = :opportunityId
            ];
            
            System.debug('***opportunityLineItems: ' + opportunityLineItems);
            
            Opportunity opportunity = new Opportunity(Id = opportunityId);
            
            if(registrationRequest.teamRegistrationInfo != NULL &&
               registrationRequest.teamRegistrationInfo.teamRegistrationId != NULL) {
                   opportunity.Team_Registration__c = registrationRequest.teamRegistrationInfo.teamRegistrationId;
            }
            
            //Ensure Membership Contract is created and activated when Opportunity is closed.
            opportunity.RecordTypeId = RecordTypeHelper.GetRecordTypeIdFromSchema('Opportunity', 'Automated');
            opportunity.Eligible_for_Membership_Extension__c = true;

            //Manually map fields and set required values.
            opportunity.Name                            = 'Exam Registration';
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
                system.debug(oli);
                if(oli.Product2.Family == 'Books' && oli.Product2.Weight__c > 0){
                    opportunity.Has_Books__c = true;    
                }
            }

            if(vm.teamRegistration != NULL) {
                opportunity.StageName = 'Closed';
            }
            
            System.debug('SOQL queries: ' + Limits.getQueries() + '/' + Limits.getLimitQueries());

            UPDATE opportunity;

            System.debug('SOQL queries: ' + Limits.getQueries() + '/' + Limits.getLimitQueries());

            List<OpportunityLineItem> examOpportunityLineItems = new List<OpportunityLineItem>();
            for(OpportunityLineItem oli: opportunityLineItems){
                if(oli.Is_Registration_Fee__c){
                    examOpportunityLineItems.add(oli);
                }
            }
            
            System.debug('***examOpportunityLineItems: ' + examOpportunityLineItems);
                        
            List<OpportunityLineItem> enrollmentAndMembershipFees = form.addEnrollmentAndMembershipFee();
            for(OpportunityLineItem oli: enrollmentAndMembershipFees){
                oli.OpportunityId = opportunityId;
            }
                                                                                                                                                                                                                                                                                                                                                                                                                          
            if(form.validatedUser.isAuthenticated){   

                Contract examContract = form.getExamContract(form.validatedUser.user.AccountId);               

                Map<String, Candidate_Requirement__c> candidateRequirementsByExamMap = null;

                if(examContract != null && examContract.Status != 'Completed'){

                    candidateRequirementsByExamMap = form.getExamContractRequirementsByExamMap(examContract.Id);

                }else{

                    examContract = form.createExamContract(accountId, contactId, opportunityId, registrationRequest.selections);

                    candidateRequirementsByExamMap = form.createExamContractRequirementsByExamMap(examContract.Id, registrationRequest.lead.Email);

                }
               
                List<Exam_Attempt__c> examRegistrations = form.createExamRegistrations(
                    examOpportunityLineItems, 
                    examContract,
                    candidateRequirementsByExamMap,
                    contactId,
                    registrationRequest
                );

            }else{

                // [DL:05/12/2020] Delegating program creation to opportunityTriggerUtils.updateRenewContracts(Set<Id> setOpps,Set<Id> setAccountIds,Map<Id,Set<String>> mapProdCodesWithAccount,opportunity opp) 
                Contract membershipContract = form.createIndividualMembershipContract(
                    accountId, 
                    contactId, 
                    opportunityId, 
                    enrollmentAndMembershipFees
                );

                Contract examContract = form.createExamContract(
                    accountId, 
                    contactId, 
                    opportunityId,
                    registrationRequest.selections
                );
                                  
                Map<String, Candidate_Requirement__c> candidateRequirementsByExamMap = form.createExamContractRequirementsByExamMap(examContract.Id, registrationRequest.lead.Email);

                List<Exam_Attempt__c> examRegistrations = form.createExamRegistrations(
                    examOpportunityLineItems, 
                    examContract,
                    candidateRequirementsByExamMap,
                    contactId,
                    registrationRequest
                );

            }  

            ExamRegistrationForm.RegistrationResponse registrationResponse = new ExamRegistrationForm.RegistrationResponse();
            
            registrationResponse.lead = convertedLead;
            registrationResponse.opportunity = [
                SELECT Id, Name, Display_Invoice_Number__c, Company__c, Amount, StageName,
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

            throw new Response.ResponseException('Lead conversion failed.', 400, leadConvertResult.getErrors());

        }
        
        return res;

    }

    public static Response.Detail payExamRegistrationOrder(ExamRegistrationForm form, ExamRegistrationForm.ChargeRequest chargeRequest){

        System.debug('Start payExamRegistrationOrder SOQL queries: ' + Limits.getQueries() + '/' + Limits.getLimitQueries());

        form.savepoint = (form.disableCreditCardProcessing) ? Database.setSavepoint() : null ;
        
        Utilities.runCaptcha(chargeRequest.token);

        Id leadId          = chargeRequest.lead.Id;
        Id accountId       = chargeRequest.lead.ConvertedAccountId;
        Id contactId       = chargeRequest.lead.ConvertedContactId;
        Id opportunityId   = chargeRequest.lead.ConvertedOpportunityId;

        List<Lead> leads = [
            SELECT Id, LeadSource, Billing_Company__c, Billing_Address_1__c, Billing_Address_2__c, Billing_Address_3__c, Billing_City__c, Billing_State__c, Billing_Postal_Code__c, Billing_Country__c, Billing_Country_ISO_Code__c, Billing_Phone_Number__c, Shipping_Company__c, Shipping_Address_1__c, Shipping_Address_2__c, Shipping_Address_3__c, Shipping_City__c, Shipping_State__c, Shipping_Postal_Code__c, Shipping_Country__c, Shipping_Country_ISO_Code__c, Shipping_Phone_Number__c, Date_of_Birth__c, ID_Expiration_Date__c, ID_Type__c, ID_Number__c, Name_as_it_Appears_on_ID__c, Full_Name_in_Chinese__c, Gender__c, Work_Status__c, Student_Status__c, School_Name__c, Degree_Name__c, Company__c, Phone, FirstName, LastName, Email
            FROM Lead 
            WHERE Id = :leadId
        ];

        List<Account> accounts = [
            SELECT Id, RecordType.Name
            FROM Account 
            WHERE Id = :accountId
        ];

        List<Contact> contacts = new List<Contact>();
            
        if(form.validatedUser.isAuthenticated){
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

        form.lead = leads[0];

        if(accounts.isEmpty()){
            throw new Response.ResponseException(
                'Unable to locate Account with ID ' + accountId + '.', 
                400, 
                new List<Object>{'Unable to locate Account with ID ' + accountId + '.'}
            );
        }

        form.account = accounts[0];

        if(contacts.isEmpty()){
            throw new Response.ResponseException(
                'Unable to locate Contact with ID ' + contactId + '.', 
                400, 
                new List<Object>{'Unable to locate Contact with ID ' + contactId + '.'}
            );
        }

        form.contact = contacts[0];

        if(opportunities.isEmpty()){
            throw new Response.ResponseException(
                'Unable to locate Opportunity with ID ' + opportunityId + '.', 
                400, 
                new List<Object>{'Unable to locate Opportunity with ID ' + opportunityId + '.'}
            );
        }
            
        form.opportunity = opportunities[0];

        List<Contract> programs = [
            SELECT Id, Opportunity__c 
            FROM Contract
            WHERE Opportunity__c IN :opportunities
        ];

        form.programs = programs;
        
        ExamRegistrationForm.ChargeResponse chargeResponse = new ExamRegistrationForm.ChargeResponse();

        if(chargeRequest.lead.Payment_Type__c == 'Credit Card' && !form.disableCreditCardProcessing){

            Payment payment = new Payment(
                chargeRequest.card.cardNumber, 
                chargeRequest.card.securityCode, 
                chargeRequest.card.expirationMonth, 
                chargeRequest.card.expirationYear                    
            );
                        
            chargeResponse.chargentResult = payment.charge(opportunityId);
                        
            if(!chargeResponse.chargentResult.Message.contains('Approved')){
                throw new Response.ResponseException(chargeResponse.chargentResult.Message, 400, new List<Object>{chargeResponse.chargentResult.Message});
            }
            
        }

        if(!form.disableCreditCardProcessing){
            //If credit card processing is disabled, setSavepoint in beginning of method execution.
            form.savepoint = Database.setSavepoint();
        }

        if(chargeRequest.lead.Payment_Type__c != 'Credit Card'){

            Contract membershipContract = null;

            if(form.validatedUser.isAuthenticated){
                membershipContract = form.getMembershipContract(form.validatedUser.user.AccountId);
            }                               

            if(membershipContract == null){
                form.createAffiliateContractAndOrder();
            }                               

        }

        System.debug('Start after contract creation SOQL queries: ' + Limits.getQueries() + '/' + Limits.getLimitQueries());

        //Set Account Billing Address to Lead Shipping Address fields
        form.account.BillingStreet       = '';
        form.account.BillingStreet       += (form.lead.Billing_Address_1__c != null) ? form.lead.Billing_Address_1__c : '';
        form.account.BillingStreet       += (form.lead.Billing_Address_2__c != null) ? ', ' + form.lead.Billing_Address_2__c : '';
        form.account.BillingStreet       += (form.lead.Billing_Address_3__c != null) ? ', ' + form.lead.Billing_Address_3__c : '';
        form.account.BillingCity         = form.lead.Billing_City__c;
        form.account.BillingState        = form.lead.Billing_State__c;
        form.account.BillingCountry      = form.lead.Billing_Country__c;
        form.account.BillingPostalCode   = form.lead.Billing_Postal_Code__c;
        form.account.Phone               = form.lead.Billing_Phone_Number__c;

        //Set Account Owner and Record Type
        form.account.OwnerId = [SELECT Id, Record_id__c FROM updateids__c WHERE name = 'User' LIMIT 1].Record_id__c;
        form.account.RecordTypeId = RecordTypeHelper.GetRecordTypeIdFromSchema('Account', 'Individual');

        UPDATE form.account;

        //Set Contact Mailing Address to Lead Shipping Address fields
        form.contact.MailingStreet       = '';
        form.contact.MailingStreet       += (form.lead.Shipping_Address_1__c != null) ? form.lead.Shipping_Address_1__c : '';
        form.contact.MailingStreet       += (form.lead.Shipping_Address_2__c != null) ? ', ' + form.lead.Shipping_Address_2__c : '';
        form.contact.MailingStreet       += (form.lead.Shipping_Address_3__c != null) ? ', ' + form.lead.Shipping_Address_3__c : '';
        form.contact.MailingCity         = form.lead.Shipping_City__c;
        form.contact.MailingState        = form.lead.Shipping_State__c;
        form.contact.MailingCountry      = form.lead.Shipping_Country__c;
        form.contact.MailingPostalCode   = form.lead.Shipping_Postal_Code__c;
        form.contact.OtherPhone          = form.lead.Shipping_Phone_Number__c;
        form.contact.Phone               = form.lead.Phone;     
        form.contact.HomePhone               = form.lead.Phone;     

        //Need to map Lead.Date_of_Birth__c to Contact.Birthdate field manually, as it cannot be done via mapping rules.
        if(form.lead.ID_Type__c != NULL) {
            if(form.lead.ID_Type__c.indexOf('Driver') > -1) {
                form.contact.ID_Type__c = 'Driver\'s License';
            } else {
                form.contact.ID_Type__c = form.lead.ID_Type__c;    
            }
        }        
        
        //form.contact.ID_Type__c = form.lead.ID_Type__c;
        
        if(String.isNotBlank(form.lead.ID_Number__c) && form.lead.ID_Number__c.length() > 5) {
            form.contact.ID_Number__c = form.lead.ID_Number__c.Right(5);
            form.contact.OSTA_Full_ID__c = form.lead.ID_Number__c;
            form.contact.OSTA_Consent__c = DateTime.now();
        } else {
            form.contact.ID_Number__c = form.lead.ID_Number__c;    
        }
        form.contact.ID_Expiration_Date__c = form.lead.ID_Expiration_Date__c;
        form.contact.Name_as_it_Appears_on_ID__c = form.lead.Name_as_it_Appears_on_ID__c;
        form.contact.Full_Name_in_Chinese__c = form.lead.Full_Name_in_Chinese__c;
        form.contact.Gender__c = form.lead.Gender__c;
        form.contact.Birthdate = form.lead.Date_of_Birth__c;
        form.contact.Currently_in_School_Status__c = form.lead.Student_Status__c;
        form.contact.Currently_Working_Status__c = form.lead.Work_Status__c;
        form.contact.School_Name__c = form.lead.School_Name__c;
        form.contact.Degree_Program_Name__c = form.lead.Degree_Name__c;
        form.contact.Company__c = form.lead.Company__c;

        //Enable Community User creation on UPDATE
        form.contact.DO_NOT_FIRE__c = false;
        form.contact.RecordTypeId = RecordTypeHelper.GetRecordTypeIdFromSchema('Contact', 'Member');

        //Set Recursion Flag to FALSE to allow member creation 
        CommunityUtils.bIsRecusrsive = false;

        System.debug('form.contact: ' + form.contact);
        UPDATE form.contact;
        //system.assert(false, 'BOOM!'+ form.contact);
        
        Utilities.migrateLeadFormDataToContact(form.lead.Id, form.contact.Id, form.lead.LeadSource, null); 

        Response.Detail res = new Response.Detail();

        chargeResponse.contact = form.contact;
        chargeResponse.opportunity = form.opportunity;

        res.data = chargeResponse;
        res.status = 200;

        return res;

    }

    //FRM, SCR
    public static Response.Detail fetchExamRegistrationInfoData(ExamRegistrationForm form, Id contactId){

        Response.Detail res = new Response.Detail();
                        
        ExamRegistrationForm.ViewModel vm = new ExamRegistrationForm.ViewModel(form);                  
        
        if(!String.isBlank(contactId)){

            vm.contact = [
                SELECT Id, Name,
                Professional_Designation_Other__c,
                Professional_Designation_CA__c,
                Professional_Designation_CMA__c,
                Professional_Designation_ACCA__c,
                Professional_Designation_PMP__c,
                Professional_Designation_CPA__c,
                Professional_Designation_CFA__c,
                Professional_Designation_CAIA__c,
                Professional_Designation_CFP__c,
                Professional_Designation_CIA__c,
                Professional_Designation_CMT__c,
                Professional_Designation_CQF__c,
                Other_Qualifications__c,
                Years_of_Experience__c,
                Job_Function__c,
                Risk_Management_Working_Year__c,
                Risk_Specialty__c,
                Corporate_Title__c,
                Company__c,
                Area_of_Concentration__c,
                Industry_Working_Year__c,
                Currently_Working_Status__c,
                Degree_Program_Name__c,
                School_Name__c,
                Currently_in_School_Status__c,
                Expected_Graduation_Date__c
                FROM Contact
                WHERE Id = :contactId
            ]; 
                        
            Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap();

            vm.picklistValuesByFieldName = new Map<String, List<Schema.PicklistEntry>>();

            vm.picklistValuesByFieldName.put('How_Did_You_Hear_About_Us__c', fieldMap.get('How_Did_You_Hear_About_Us__c').getDescribe().getPicklistValues());
            vm.picklistValuesByFieldName.put('Area_of_Concentration__c', fieldMap.get('Area_of_Concentration__c').getDescribe().getPicklistValues());
            vm.picklistValuesByFieldName.put('Corporate_Title__c', fieldMap.get('Corporate_Title__c').getDescribe().getPicklistValues());
            vm.picklistValuesByFieldName.put('Job_Function__c', fieldMap.get('Job_Function__c').getDescribe().getPicklistValues());       
            vm.picklistValuesByFieldName.put('Risk_Specialty__c', fieldMap.get('Risk_Specialty__c').getDescribe().getPicklistValues());       
            
            
            vm.dynamicPicklistValuesByFieldName = new Map<String, List<String>>();
            Integer currentYear = System.Today().year();

            List<String> industryWorkingYearList = new List<String>();
            for(Integer i=currentYear-20; i <= currentYear; i++){
                industryWorkingYearList.add(String.valueOf(i));
            }
            vm.dynamicPicklistValuesByFieldName.put('Industry_Working_Year__c', industryWorkingYearList);    

            List<String> riskManagementWorkingYearList = new List<String>();
            for(Integer i=currentYear-15; i <= currentYear+6; i++){
                riskManagementWorkingYearList.add(String.valueOf(i));
            }
            vm.dynamicPicklistValuesByFieldName.put('Risk_Management_Working_Year__c', riskManagementWorkingYearList);
            
            List<String> yearOfGraduationList = new List<String>();
            for(Integer i=currentYear-15; i <= currentYear+6; i++){
                yearOfGraduationList.add(String.valueOf(i));
            }
            vm.dynamicPicklistValuesByFieldName.put('Expected_Graduation_Date__c', yearOfGraduationList);
            
            
            res.status = 200;
            res.message = form.registrationType + ' Exam Registration Information view model retrieved successfully.';
            res.data = vm;
            
        }else{ 

            throw new Response.ResponseException(
                form.registrationType + ' Exam Registration Information view model retrieved unsuccessfully (ContactId not provided).', 400,
                new List<String>{form.registrationType + ' Exam Registration Information view model retrieved unsuccessfully (ContactId not provided).'}
            );  
            
        }
        
        return res;

    }  
    
    //FBR, ICBRR, Individual Membersip
    public static Response.Detail fetchExamRegistrationInfoData(string registrationType, Id contactId){
        
        ExamRegistrationForm.InfoViewModel vm = new ExamRegistrationForm.InfoViewModel();

        Response.Detail res = new Response.Detail();
        
        if(!String.isBlank(contactId)){

            vm.contact = [
                SELECT Id, Name,
                Professional_Designation_Other__c,
                Professional_Designation_CA__c,
                Professional_Designation_CMA__c,
                Professional_Designation_ACCA__c,
                Professional_Designation_PMP__c,
                Professional_Designation_CPA__c,
                Professional_Designation_CFA__c,
                Professional_Designation_CAIA__c,
                Professional_Designation_CFP__c,
                Professional_Designation_CIA__c,
                Professional_Designation_CMT__c,
                Professional_Designation_CQF__c,
                Other_Qualifications__c,
                Years_of_Experience__c,
                Job_Function__c,
                Risk_Management_Working_Year__c,
                Risk_Specialty__c,
                Corporate_Title__c,
                Company__c,
                Area_of_Concentration__c,
                Industry_Working_Year__c,
                Currently_Working_Status__c,
                Degree_Program_Name__c,
                School_Name__c,
                Currently_in_School_Status__c,
                Expected_Graduation_Date__c
                FROM Contact
                WHERE Id = :contactId
            ]; 
                        
            Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap();

            vm.picklistValuesByFieldName = new Map<String, List<Schema.PicklistEntry>>();

            vm.picklistValuesByFieldName.put('How_Did_You_Hear_About_Us__c', fieldMap.get('How_Did_You_Hear_About_Us__c').getDescribe().getPicklistValues());
            vm.picklistValuesByFieldName.put('Area_of_Concentration__c', fieldMap.get('Area_of_Concentration__c').getDescribe().getPicklistValues());
            vm.picklistValuesByFieldName.put('Corporate_Title__c', fieldMap.get('Corporate_Title__c').getDescribe().getPicklistValues());
            vm.picklistValuesByFieldName.put('Job_Function__c', fieldMap.get('Job_Function__c').getDescribe().getPicklistValues());       
            vm.picklistValuesByFieldName.put('Risk_Specialty__c', fieldMap.get('Risk_Specialty__c').getDescribe().getPicklistValues());       
            
            
            vm.dynamicPicklistValuesByFieldName = new Map<String, List<String>>();
            Integer currentYear = System.Today().year();

            List<String> industryWorkingYearList = new List<String>();
            for(Integer i=currentYear-20; i <= currentYear; i++){
                industryWorkingYearList.add(String.valueOf(i));
            }
            vm.dynamicPicklistValuesByFieldName.put('Industry_Working_Year__c', industryWorkingYearList);    

            List<String> riskManagementWorkingYearList = new List<String>();
            for(Integer i=currentYear-15; i <= currentYear+6; i++){
                riskManagementWorkingYearList.add(String.valueOf(i));
            }
            vm.dynamicPicklistValuesByFieldName.put('Risk_Management_Working_Year__c', riskManagementWorkingYearList);
            
            List<String> yearOfGraduationList = new List<String>();
            for(Integer i=currentYear-15; i <= currentYear+6; i++){
                yearOfGraduationList.add(String.valueOf(i));
            }
            vm.dynamicPicklistValuesByFieldName.put('Expected_Graduation_Date__c', yearOfGraduationList);
            
            
            res.status = 200;
            res.message = registrationType + ' Exam Registration Information view model retrieved successfully.';
            res.data = vm;
            
        }else{ 

            throw new Response.ResponseException(
                registrationType + ' Exam Registration Information view model retrieved unsuccessfully (ContactId not provided).', 400,
                new List<String>{registrationType + ' Exam Registration Information view model retrieved unsuccessfully (ContactId not provided).'}
            );  
            
        }
        
        vm.companies = [Select Id, Institution_Name__c, Description__c, Alias__c, RecordType.Name from Institution__c where RecordType.Name = 'Organization'];
        vm.schools = [Select Id, Institution_Name__c, Description__c, Alias__c, RecordType.Name from Institution__c where RecordType.Name = 'Academic'];
        
        return res;

    } 

    // AG Rollback Survey
    /*
    public static Response.Detail updateExamRegistrationInfoData(ExamRegistrationForm erf, Contact contact){

        Response.Detail res = new Response.Detail();

        System.debug(contact);
        UPDATE contact;

        res.status = 200;
        res.message = 'Contact with ID ' + contact.Id + ' updated succesfully.';
        res.data = contact;
        
        return res;

    }*/
    
    public static Response.Detail updateExamRegistrationInfoData(ExamRegistrationForm erf, Contact contact){

        Response.Detail res = new Response.Detail();

        Set<String> fieldsAvailable = new Set<String>{'Id', 'Name', 'Company__c', 'Currently_Working_Status__c', 'Area_of_Concentration__c', 'Industry_Working_Year__c', 'Corporate_Title__c', 'Job_Function__c', 'Risk_Specialty__c', 'Risk_Management_Working_Year__c', 'Years_of_Experience__c', 'Professional_Designation_CA__c', 'Professional_Designation_CFA__c', 'Professional_Designation_CMA__c', 'Professional_Designation_CPA__c', 'Professional_Designation_PMP__c', 'Professional_Designation_ACCA__c', 'Professional_Designation_CAIA__c', 'Professional_Designation_CFP__c', 'Professional_Designation_CIA__c', 'Professional_Designation_CMT__c', 'Professional_Designation_CQF__c', 'Professional_Designation_Other__c', 'Other_Qualifications__c', 'Currently_in_School_Status__c', 'School_Name__c', 'Degree_Program_Name__c', 'Email_Information_Exchange__c', 'How_Did_You_Hear_About_Us__c', 'How_Did_You_Hear_About_Us_Other__c', 'ID_Type__c', 'ID_Number__c', 'Name_as_it_Appears_on_ID__c'};

        UPDATE contact;

        res.status = 200;
        res.message = 'Contact with ID ' + contact.Id + ' updated succesfully.';
        res.data = contact;
        
        return res;

    }

    public static Response.Detail fetchExamRegistrationCompletedData(ExamRegistrationForm erf){

        Response.Detail res = new Response.Detail();
    
        ExamRegistrationForm.ViewModel vm = new ExamRegistrationForm.ViewModel(erf);
                
        res.status = 200;
        res.message = 'Exam Registration Completed view model data retrieved successfully.';
        res.data = vm;
        
        return res;

    }  
    
}