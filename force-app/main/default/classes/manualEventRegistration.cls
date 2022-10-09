public class manualEventRegistration {
    
    public PageReference manualEventRegistration(Apexpages.Standardcontroller std) {
        eventObject = (Event_Registration__c)std.getRecord();
        return null;
    }
    
    public manualEventRegistration (){
        eventObject = new Event_Registration__c ();
    }
    
    public Event_Registration__c eventObject {get;set;} //The purpose of this is to get the event from the Visualforce Page (Kyan Notes)
    public string firstName{get;set;}
    public string lastName{get;set;}
    public string email{get;set;}
    public string ccemail{get;set;}
    public string nickname{get;set;}
    public string jobTitle{get;set;}
    public string company{get;set;}
    public string promocode{get;set;}
    Public Id event{get;set;}
    Public String action {get; set;}
    Public String actionId {get; set;}
    public boolean membership {get;set;}
    public String discount {get;set;}
    Public String description {get;set;}
    Public string neededAccountId;
    
    public void manualEventRegistration(){
        Boolean doesContactExist = doesContactExist(email);
        event = eventObject.Event__c; // This is where the eventObject id is set to the event variable (Kyan Notes)
        
        if(doesContactExist == true){
            // create an Event Registration Portal User
            TempAccount objData = provisionTempAccountData(null, email, jobTitle, company, event, firstName, lastName, promocode, membership, discount, description);
            
            List<Event_Registration__c> checkOpportunity = [Select id from Event_Registration__c where Opportunity__r.stagename = 'Closed' and Opportunity__r.Invoice_Paid_status__c = 'Paid' and event__c = :event and Member_Email__c = :email limit 1];
            if(checkOpportunity.size() != 0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.warning, 'Paid Registration exists for this contact and event'));
                //addErrorMessage('A opportunity already exists');                
            }else{
                Registration.wrapperCreateOrder eventRegistration = sfdcAppRemoter.createOrderForPortalUsers(objData);
            }
            
        } else {
            
            // create an Event Registration Public User
            // Set Lead with the New Email.            
            Lead lead = new Lead(Email = email, FirstName = firstName, LastName = LastName, Company = 'UNKNOWN');
			INSERT lead;
            
            // create an Event Registration
            TempAccount objData = provisionTempAccountData(lead.Id, email, jobTitle, company, event, firstName, lastName, promocode, membership, discount, description);
            Registration.wrapperCreateOrder eventRegistration = sfdcAppRemoter.createOrder(objData);
            
        } 
    }
    
    public Boolean doesContactExist(String candidateEmail) {
        List < contact > contactByEmail = [SELECT Name, Id, Accountid FROM contact where Email =: candidateEmail];
        Integer size = contactByEmail.size();
        
        if(size > 0){
            neededAccountId = contactByEmail[0].name;
            return true;
        } else {
            return false; 
        } 
    }
    
    public TempAccount provisionTempAccountData(Id leadId, string email, string jobTitle, string company, Id event, string FirstName, string LastName, string promocode, boolean membership, String discount, String description){
        
        system.debug('promocode123');
        system.debug(promocode);
        Boolean hasPromocodeNOTBeenEntered = String.isBlank(promocode);
        
        system.debug('hasPromocodeNOTBeenEntered123');
        system.debug(hasPromocodeNOTBeenEntered);
        
        Date currentDate = Date.today();
        Boolean isContactGoodIndividualStudent = false;
        
        // Look up Contact ID by Email.
        List < contact > contactByEmail = [SELECT FirstName, LastName, title, Id, Email, Membership_Type__c, KPI_Membership_Payment_Status__c, KPI_ERP_Certified__c, KPI_FRM_Certified__c  FROM contact where Email =: email];
        
        for(contact retrivedContact: contactByEmail){
            if((retrivedContact.Membership_Type__c == 'Individual' || retrivedContact.Membership_Type__c == 'Student') && (retrivedContact.KPI_Membership_Payment_Status__c == 'In Good Standing')){
                isContactGoodIndividualStudent = true;
            }
        }
        
        List < Event__c > eventBeingRegistered = [SELECT Name, GL_Code__c, Product_Code__c FROM Event__c where Id =: event];
        List<Event_Rate__c> eventRatesOfEventsBeingPurchased = [select Id, Name, Event__r.Id, Start_Date__c, End_Date__c, Member_Rate__c, Non_Member_Rate__c, Product_Member_Code__r.ProductCode, Product_Non_Member_Code__r.ProductCode from Event_Rate__c where (Event__r.Id = :event and Start_Date__c <= :currentDate and End_Date__c >= :currentDate)];
        List<Event_Discount__c > eventDiscountsOfEventsBeingPurchased = [select Id, Name, Event__r.Id, Start_Date__c, End_Date__c, Discount_Code__c, Discount_To_Fixed_Price__c, Fixed_Amount_Discount__c, Fixed_Percentage_Discount__c, Registration_Type__c from Event_Discount__c where (Event__r.Id = :event and Start_Date__c <= :currentDate and End_Date__c >= :currentDate)];
        
        TempAccount.productDefinition newTempAccountProductDefinition = new TempAccount.productDefinition();
        
        /*This is the area where the membership will be looked for if needed*/
        TempAccount.productDefinition newTempAccountProductDefinitionMembership = null;
        TempAccount.productDefinition newTempAccountProductDefinitionDiscount = null;
        TempAccount.productDefinition newTempAccountProductDefinitionPromoDiscount = null;
        
        
        String registeringGLCode;
        String registeringProductCode;
        String registeringrelatedId;
        String registeringDescription;
        for(Event__c eventReg: eventBeingRegistered){
            registeringGLCode = eventReg.GL_Code__c;
            //registeringProductCode  = eventReg.Product_Code__c; 
            registeringrelatedId = eventReg.Id;
            registeringDescription = eventReg.Name;
        }
        
        String registeringPrice;
        for(Event_Rate__c eventRate: eventRatesOfEventsBeingPurchased){
            if(isContactGoodIndividualStudent){
                String memberRate = String.valueOf(eventRate.Member_Rate__c);
                registeringProductCode  = eventRate.Product_Member_Code__r.ProductCode;
                registeringPrice = memberRate;
            } else if(!isContactGoodIndividualStudent) {
                String nonmemberRate = String.valueOf(eventRate.Non_Member_Rate__c);
                registeringProductCode  = eventRate.Product_Non_Member_Code__r.ProductCode;
                registeringPrice = nonmemberRate;
            }
        }
        
        newTempAccountProductDefinition.GLCode = registeringGLCode;
        newTempAccountProductDefinition.ProductCode  = registeringProductCode;
        newTempAccountProductDefinition.price  = registeringPrice;
        newTempAccountProductDefinition.relatedId = registeringrelatedId;
        newTempAccountProductDefinition.description = registeringDescription;
        
        //This will be the area where the search for membership will occur.
            
        if(membership == true && contactByEmail.size() !=0 && (contactByEmail[0].KPI_ERP_Certified__c == true || contactByEmail[0].KPI_FRM_Certified__c == true)){
            Product2 thisMembership = [Select id, name,GL_Code__c, ProductCode from product2 where name = 'Individual Membership Certified' limit 1];
            newTempAccountProductDefinitionMembership = new TempAccount.productDefinition();
            newTempAccountProductDefinitionMembership.GLCode = thisMembership.GL_Code__c;
            newTempAccountProductDefinitionMembership.ProductCode = thisMembership.ProductCode;
            newTempAccountProductDefinitionMembership.price = '150';  
        }else if(membership == true){
            Product2 thisMembership = [Select id, name,GL_Code__c, ProductCode from product2 where name = 'Individual Membership' limit 1];
            newTempAccountProductDefinitionMembership = new TempAccount.productDefinition();
            newTempAccountProductDefinitionMembership.GLCode = thisMembership.GL_Code__c;
            newTempAccountProductDefinitionMembership.ProductCode = thisMembership.ProductCode;
            newTempAccountProductDefinitionMembership.price = '195';
        }
        
        
        if(discount != null && discount != '' ){
            // Get Percetages
            Integer eventPrice = Integer.valueOf(registeringPrice);
            decimal discountAmount = (Decimal.valueOf(discount) / 100);
            discountAmount = discountAmount * eventPrice;
            discountAmount = discountAmount.setScale(2);
            
            
            newTempAccountProductDefinitionDiscount = New TempAccount.productDefinition();
            Product2 thisMisc = [Select id, GL_Code__c, ProductCode from product2 where name = 'Miscellaneous' limit 1];
            newTempAccountProductDefinitionDiscount.GLCode = thisMisc.GL_Code__c;
            newTempAccountProductDefinitionDiscount.ProductCode = thisMisc.ProductCode;
            
            newTempAccountProductDefinitionDiscount.price = '-' + String.valueOf(discountAmount);
            newTempAccountProductDefinitionDiscount.description = description;
        }
        
        if(promocode != null && promocode !=''){
            Event_Discount__c thisDiscount =[Select id, name, Discount_To_Fixed_Price__c, Discount_Code__c,Fixed_Amount_Discount__c, Fixed_Percentage_Discount__c
                                             from Event_Discount__c where Discount_Code__c = :promocode];
            Product2 thisMisc = [Select id, GL_Code__c, ProductCode from product2 where name = 'Miscellaneous' limit 1];
            newTempAccountProductDefinitionPromoDiscount = New tempAccount.productDefinition();
            newTempAccountProductDefinitionPromoDiscount.GLCode = thisMisc.GL_Code__c;
            newTempAccountProductDefinitionPromoDiscount.ProductCode = thisMisc.ProductCode;
            if(thisDiscount.Discount_To_Fixed_Price__c != null){
                decimal promoAmount = Integer.valueof(registeringprice) - thisDiscount.Discount_To_Fixed_Price__c; 
                newTempAccountProductDefinitionPromoDiscount.price = '-' + string.valueof(promoAmount);
                newTempAccountProductDefinitionPromoDiscount.description = thisDiscount.name + ' discount';
                //newTempAccountProductDefinitionPromoDiscount.price
            }else if(thisDiscount.Fixed_Amount_Discount__c != null){
                newTempAccountProductDefinitionPromoDiscount.price = '-' + string.valueof(thisDiscount.Fixed_Amount_Discount__c);
                newTempAccountProductDefinitionPromoDiscount.description = thisDiscount.name + ' discount';
            }else if(thisDiscount.Fixed_Percentage_Discount__c != null){
                Integer eventPrice = Integer.valueOf(registeringPrice);
                decimal promoAmount = (thisDiscount.Fixed_Percentage_Discount__c / 100);
                promoAmount = promoAmount * eventPrice;
                promoAmount = promoAmount.setScale(2);
                newTempAccountProductDefinitionPromoDiscount.price = '-' + string.valueof(promoAmount);
                newTempAccountProductDefinitionPromoDiscount.description = thisDiscount.name + ' discount';
            }
        }
        
        TempAccount tempObjData = new TempAccount(); 
        if(membership == true && (discount != null && discount != '')){
            System.debug('Wrong Area');
            tempObjData.productcode1 = new TempAccount.productDefinition[]{newTempAccountProductDefinition, newTempAccountProductDefinitionMembership, newTempAccountProductDefinitionDiscount};
                }else if(membership == true && promocode != null && promocode != ''){
                    System.debug('Wrong Area');
                    tempObjData.productcode1 = new TempAccount.productDefinition[]{newTempAccountProductDefinition,newTempAccountProductDefinitionMembership,newTempAccountProductDefinitionPromoDiscount};
                        }else if(membership == true){
                            System.debug('Wrong Area');
                            tempObjData.productcode1 = new TempAccount.productDefinition[]{newTempAccountProductDefinition, newTempAccountProductDefinitionMembership};
                                }else if(discount != null && discount != '' ){
                                    System.debug('Wrong Area');
                                    tempObjData.productcode1 = new TempAccount.productDefinition[]{newTempAccountProductDefinition, newTempAccountProductDefinitionDiscount};
                                        }else if(promocode != null && promocode != ''){
                                            System.debug('Wrong Area');
                                            tempObjData.productcode1 = new TempAccount.productDefinition[]{newTempAccountProductDefinition,newTempAccountProductDefinitionPromoDiscount};
                                                }else{
                                                    System.debug('Correct Area');
                                                    tempObjData.productcode1 = new TempAccount.productDefinition[]{newTempAccountProductDefinition};    
                                                        }
        
        
        tempObjData.isFrmChecked = false;
        tempObjData.isErpChecked = false;
        tempObjData.isIcbrChecked = false;
        tempObjData.isFbrChecked = false;
        tempObjData.isFbraChecked = false;
        tempObjData.frmSwitch = false;
        tempObjData.erpSwitch = false;
        tempObjData.isEventChecked = true;
        if(contactByEmail != null && contactByEmail.size() > 0){
            for(contact retrivedContact: contactByEmail){
                tempObjData.Email = retrivedContact.Email;
                tempObjData.FirstName = retrivedContact.FirstName;
                tempObjData.LastName = retrivedContact.LastName;
                tempObjData.contactId = retrivedContact.Id;
                tempObjData.Id = retrivedContact.Id;
            }
        } else {
            tempObjData.Id = leadId;
            tempObjData.Email = email;
            tempObjData.FirstName = FirstName;
            tempObjData.LastName = LastName; 
            tempObjData.contactId = null;
        }
        tempObjData.jobtitle = jobTitle;
        tempObjData.company = company;
        tempObjData.eppHelp = false;
        tempObjData.chapterMeetingRegistrationId = NULL;
        System.debug('Before Promo Code');
        // Push this in, ONLY when a PromoCode is entered.
        if(!hasPromocodeNOTBeenEntered){
            System.debug('Inside Promo Code');
            List<String> allPromocodesUsed = new List<String>();
            allPromocodesUsed.add(promocode);
            tempObjData.promocodesUsed = allPromocodesUsed;
        } else {
            System.debug('Inside Promo Code else');
            List<String> allPromocodesUsed = new List<String>();
            tempObjData.promocodesUsed = allPromocodesUsed;
        }
        return tempObjData;
    }
}