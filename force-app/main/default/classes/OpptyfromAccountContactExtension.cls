public with sharing class OpptyfromAccountContactExtension {
    public String shippingFirstName {get;set;}
    public String shippingLastName {get;set;}
    public String shippingEmail {get;set;}
    public String shippingPhone {get;set;}
    public String shippingCity {get;set;}
    public String shippingCountry {get;set;}
    public String shippingState {get;set;}
    public String shippingAddress1 {get;set;}
    public String shippingPostalCode {get;set;}
    private String parentId {get;set;}
    Private Contact objContact;
    
    public OpptyfromAccountContactExtension(ApexPages.StandardController controller) {
        parentId = controller.getId();
        if(parentId != null && parentId.startsWith('001')){
            List<Contact> conList = [Select id, AccountId, FirstName, LastName, Email, HomePhone, MailingCity, MailingCountry, MailingState, MailingStreet, MailingPostalCode from Contact where AccountID = :parentId ];  
            if(conList != null && conList.size()>0){
                objContact= conList[0];
            }
            else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'There is no Contact Attached to the Account record');
                ApexPages.addMessage(myMsg);
            }
        }
        else if(parentId != null && parentId.startsWith('003')){
            objContact= [Select id, AccountId, FirstName, LastName, Email, HomePhone, MailingCity, MailingCountry, MailingState, MailingStreet, MailingPostalCode from Contact where ID = :parentId ];
        }
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please navigate from either person or contact record');
            ApexPages.addMessage(myMsg);
        }
    }
    
    public PageReference createOpportunity(){
        Opportunity opp = new Opportunity();
        try
        {
            opp.Name = 'Shipping Address Correction';
            opp.Accountid = objContact.AccountId;
            opp.StageName = 'New Lead';
            opp.CloseDate = system.today();
            opp.ChargentSFA__Billing_First__c=objContact.FirstName;
            opp.ChargentSFA__Billing_Last__c=objContact.LastName;
            opp.ChargentSFA__Billing_Email__c=objContact.Email;
            opp.ChargentSFA__Billing_Phone__c=objContact.HomePhone;
            opp.ChargentSFA__Billing_City__c=objContact.MailingCity;
            opp.ChargentSFA__Billing_Country__c=objContact.MailingCountry; 
            opp.ChargentSFA__Billing_State__c=objContact.MailingState;
            opp.ChargentSFA__Billing_Address__c=objContact.MailingStreet; 
            opp.ChargentSFA__Billing_Zip__c=objContact.MailingPostalCode;
            opp.Shipping_First_Name__c=shippingFirstName;
            opp.Shipping_Last_Name__c=shippingLastName;
            opp.Shipping_E_mail__c=shippingEmail;
            opp.Shipping_Phone_No__c=shippingPhone;
            opp.Shipping_City__c=shippingCity;
            opp.Shipping_Country__c=shippingCountry; 
            opp.Shipping_State__c=shippingState;
            opp.Shipping_Address1__c=shippingAddress1; 
            opp.Shipping_Postal_Code__c=shippingPostalCode;
            insert opp;
            
            OpportunityContactRole contactRole = new OpportunityContactRole(OpportunityId=opp.id, ContactId=objContact.Id, Role='Decision Maker');
            insert contactRole;
            
            createOppLineItems(opp.id, 'MISC', objContact, '25');
             system.debug('* * * opp:'+ opp);
             PageReference pg = new PageReference('/'+opp.Id);
             return pg;
            
        }
        catch(exception ex)
        {
            return null;
        }
        return null;
       
    }
    
    
     public  void createOppLineItems(Id oppId, String strProdCode, Contact objContact, String price)
    {
        
        String strNameByProdcutCode  = '';
        PriceBookEntry PricebookEntryId = [select unitprice,productcode,Product2.GL_Code__c from PriceBookEntry where Pricebook2.IsActive = true and productcode =: strProdCode and isActive =: true];
        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = oppId;
        oppLineItem.PricebookEntryId = PricebookEntryId.Id;
        oppLineItem.Quantity = 1;
        oppLineItem.description = 'Ups Charges';
        oppLineItem.UnitPrice = PricebookEntryId.unitprice;
        if(price != null) {
            oppLineItem.UnitPrice = Decimal.valueOf(price);
        }
        
        system.debug('* * * oppLineItem:'+ oppLineItem);
        
        insert oppLineItem;
    }

}