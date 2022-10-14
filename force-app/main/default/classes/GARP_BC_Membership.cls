public class GARP_BC_Membership {

    public static GARP_MS_Membership.getMembershipRegistrationInfo GetMembershipRegistrationInfo() {
        GARP_MS_Membership.getMembershipRegistrationInfo regInfo = new GARP_MS_Membership.getMembershipRegistrationInfo();
        
        List<PricebookEntry> lstPricebookEntry = [
                    SELECT Product2.Id, Product2.Name, Product2.ProductCode, Product2.GL_Code__c, Product2.Description, Product2.Image__c, Product2.IsActive, Product2.Weight__c, Pricebook2.IsActive, UnitPrice, UseStandardPrice 
                    FROM PriceBookEntry 
                    WHERE Product2.ProductCode in ('MEMI','MEMR','PRFEE')
                ];
        System.debug('lstPricebookEntry:' + lstPricebookEntry);
        
        regInfo.Products = new List<GARP_Common.productInfo>();
        for(PricebookEntry pbe :lstPricebookEntry) {
            GARP_Common.productInfo prod = new GARP_Common.productInfo();
            prod.Amount = pbe.UnitPrice;
            prod.GLCode = pbe.Product2.GL_Code__c;
            prod.ProductCode = pbe.Product2.ProductCode;
            prod.ProductName = pbe.Product2.Name;
            regInfo.Products.add(prod);
        }
        System.debug('regInfo.Products:' + regInfo.Products);
        
        regInfo.ScreenInfo = new GARP_Common.screenInfo();
        regInfo.ScreenInfo.Locations = [select id, Country__c, LetterCode__c, (select id, name, code__c from Provinces__r Order by Name) from Country_Code__c Order By Country__c];

        GARP_Common.checkAuthentication checkAuth = GARP_Common.CheckAuthentication();
        regInfo.ScreenInfo.IsAuthenticated = checkAuth.isAuthenticated;
        
        System.debug('regInfo.ScreenInfo:' + regInfo.ScreenInfo);
        return regInfo;
    }
    
    public static GARP_MS_Membership.setMembershipOrderReturnInfo SetMembershipOrder(GARP_MS_Membership.setMembershipOrderInfo setMemberOrderInfo) {
        GARP_MS_Membership.setMembershipOrderReturnInfo regInfo = new GARP_MS_Membership.setMembershipOrderReturnInfo();
        
        
        // Validations
        if(setMemberOrderInfo.CustomerInfo == NULL || setMemberOrderInfo.CustomerInfo.Email == NULL ||
           setMemberOrderInfo.PaymentInfo == NULL || 
           setMemberOrderInfo.ProductsSelected == NULL || setMemberOrderInfo.ProductsSelected.isEmpty()) {
               regInfo.Message = 'Required Information Missing';
               regInfo.Status = 'Failed';
               return regInfo;
           }
        
        GARP_Common.checkExistingContact checkRet = GARP_Common.CheckExistingContact(setMemberOrderInfo.CustomerInfo.Email);
        Contact contact = checkRet.contact;
        
        GARP_Common.checkAuthentication checkAuth = GARP_Common.CheckAuthentication();
        Boolean isAuthenticated = checkAuth.isAuthenticated;
        
        if(!isAuthenticated && contact != NULL) {
            regInfo.Message = 'Contact exists, must login';
            regInfo.Status = 'Failed';
            return regInfo;
        }
        
        if(setMemberOrderInfo.CustomerInfo.LeadId == NULL && isAuthenticated == False) {
            regInfo.Message = 'LeadId Missing from Unauthenticated';
            regInfo.Status = 'Failed';
            return regInfo;
        }
        
        // Captcha
        if(setMemberOrderInfo.captchaInfo != NULL) {
            Boolean bValid = Utilities.verifyCaptcha(setMemberOrderInfo.captchaInfo.cap,setMemberOrderInfo.captchaInfo.capip);
            if(!bValid) {
                regInfo.Message = 'Captcha Failed';
                regInfo.Status = 'Failed';
                return regInfo;
            }            
            if(setMemberOrderInfo.captchaInfo.sessionToken != NULL) {
                Utilities.updateFormSession(setMemberOrderInfo.captchaInfo.sessionToken, setMemberOrderInfo.CustomerInfo.Email);
                Utilities.runCaptcha(setMemberOrderInfo.captchaInfo.sessionToken); 
            }
        }
        
        
        if(isAuthenticated && setMemberOrderInfo.PaymentInfo.ExistingOrderId != NULL) {
        	GARP_Common.removeOrder(setMemberOrderInfo.PaymentInfo.ExistingOrderId);
        }
        
        // Contact & Account
        String contactId;
        String accountId;
        String opportunityId;
        String invoiceNumber;
        
        if(!isAuthenticated) {
			Database.LeadConvert convertLead = new Database.LeadConvert();
            convertLead.setLeadId(setMemberOrderInfo.CustomerInfo.LeadId);
            LeadStatus ls = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
            convertLead.setConvertedStatus(ls.MasterLabel);
            Database.LeadConvertResult lcr = Database.convertLead(convertLead);
            if (lcr.isSuccess()) {
                Lead convertedLead = [SELECT ConvertedAccountId, ConvertedContactId, ConvertedDate, ConvertedOpportunityId, Marketing_Email_Creation__c, Email_Career_Center_Job_Board__c, Email_Chapter_Meetings__c, Email_CPE_News__c, Email_Daily_News__c, Email_GARP_Updates__c, Email_Information_Exchange__c, Email_Member_Update__c, Email_The_Week_in_Risk__c FROM Lead where id = : setMemberOrderInfo.CustomerInfo.LeadId];
                system.debug('convertedLead ==' + convertedLead);
                contactId = convertedLead.ConvertedContactId;
                accountId = convertedLead.ConvertedAccountId;
                opportunityId = convertedLead.ConvertedOpportunityId;
                Opportunity newOpp = [select Id, Display_Invoice_Number__c from Opportunity where Id = :OpportunityId];
                invoiceNumber = newOpp.Display_Invoice_Number__c;
                //if (objData.isFrmChecked != true && objData.isErpChecked != true && !objData.isIcbrChecked)
                   //updateOpportunityinfoForMembers(OpportunityId, objData);
                
            } else {
                regInfo.Message = 'Lead Conversion Failed';
                regInfo.Status = 'Failed';
                return regInfo;
            }
            
        } else {
            
            // Unauthenticated reg 
            if(!checkRet.isMember) {
                // Create Member Account
                Account newAccount = createMembershipAccount(checkAuth.user, contact, setMemberOrderInfo.CustomerInfo);
                insert newAccount;
                
                // Update Contact
                String memberRecordTypeId = RecordTypeHelper.GetRecordTypeId('Contact', 'Member');
                contact.AccountId = newAccount.Id;
                contact.RecordTypeId = memberRecordTypeId;
                update contact;
                
                // Create new Order
                Opportunity opp = createOpportunity('Membership Order',checkAuth.user, contact, newAccount, setMemberOrderInfo);
                insert opp;
                
                OpportunityContactRole contactRole = new OpportunityContactRole(OpportunityId=opp.id, ContactId=contact.Id, Role='Decision Maker');
                INSERT contactRole;
            }

        }       

        
        return regInfo;
    }
    
    public static Account createMembershipAccount(User user, Contact contact, GARP_MS_Membership.setMembershipOrderCustomerInfo CustomerInfo) {
        Id individualRecId = RecordTypeHelper.GetRecordTypeId('Account','Individual');
        
        Account newAcct = new Account(
            RecordTypeID = individualRecId,
            Name = CustomerInfo.FirstName + ' ' + CustomerInfo.LastName,
            GARP_ID__c = contact.GARP_ID_New__c,
            ownerid = user.Id
        );
        return newAcct;
    }
    
    public static Opportunity createOpportunity(String oppName, User user, Contact contact, Account account, GARP_MS_Membership.setMembershipOrderInfo setMemberOrderInfo) {
        Id recordTypeID = RecordTypeHelper.GetRecordTypeId('Opportunity', 'Automated');
        
        Opportunity newOpp = new Opportunity(
            Name = oppName,
            Accountid = account.Id,
            StageName = 'New Lead',
            CloseDate = system.today(),
            recordTypeID = recordTypeID,
            ChargentSFA__Billing_Email__c = setMemberOrderInfo.CustomerInfo.Email,
            ChargentSFA__Billing_First__c = setMemberOrderInfo.CustomerInfo.FirstName,
            ChargentSFA__Billing_Last__c = setMemberOrderInfo.CustomerInfo.LastName,
            ChargentSFA__Billing_Phone__c = setMemberOrderInfo.CustomerInfo.Phone,
            ChargentSFA__Billing_Company__c = setMemberOrderInfo.PaymentInfo.BillingCompany,
            ChargentSFA__Billing_Address__c = GARP_Common.formatAddressTextArea(setMemberOrderInfo.PaymentInfo.BillingStreet1, setMemberOrderInfo.PaymentInfo.BillingStreet2, null),
            ChargentSFA__Billing_City__c = setMemberOrderInfo.PaymentInfo.BillingCity,
            ChargentSFA__Billing_State__c = setMemberOrderInfo.PaymentInfo.BillingState,
            ChargentSFA__Billing_Zip__c  = setMemberOrderInfo.PaymentInfo.BillingPostalCode,
            ChargentSFA__Billing_Country__c = setMemberOrderInfo.PaymentInfo.BillingCountry,

            ownerid = user.Id
        );
        
        return newOpp;
    }
    
}