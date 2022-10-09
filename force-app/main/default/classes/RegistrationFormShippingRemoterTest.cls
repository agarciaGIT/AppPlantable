@isTest
public class RegistrationFormShippingRemoterTest {

    @TestSetup
    private static void makeData(){
                
        Pricebook2 activePricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = TRUE
        );
        
        UPDATE activePricebook;
        
        Id pricebookId = activePricebook.Id;

        //BOOKS
        Product2 FRM1H = new Product2(Company__c = 'GARP', Weight__c = 1.0, Taxable__c = true, Name = 'Laptop X200', productCode = 'FRM1H', GL_Code__c = '4999', Family = 'Books', isActive = true);
        Product2 SHIP = new Product2(Company__c = 'GARP', Weight__c = 0, Taxable__c = true, Name = 'Laptop X200', productCode = 'SHIP', GL_Code__c = '4999', Family = 'Books', isActive = true);

        INSERT FRM1H;
        INSERT SHIP;
        
        PricebookEntry FRM1HPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = FRM1H.Id, UnitPrice = 10000, IsActive = true);    
        PricebookEntry SHIPPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = SHIP.Id, UnitPrice = 10000, IsActive = true);      
        
        INSERT FRM1HPBE;
        INSERT SHIPPBE;
        
    }

    private static Lead createGenericLead(Boolean shippingAddressSameAsBillingAddress){
        
        Lead lead = new Lead();

        lead.FirstName = 'TEST';
        lead.LastName = 'TEST';
        lead.Email = 'test@test.com';
        lead.Company = 'TEST CO';
        lead.Billing_Address_1__c = '123 SAMPLE STREET';
        lead.Billing_City__c = 'SAMPLE CITY';
        lead.Billing_State__c = 'NJ';
        lead.Billing_Company__c = 'TEST CO';
        lead.Billing_Phone_Number__c = '1234567890';
        lead.Billing_Country__c = 'United States';
        lead.Billing_Country_ISO_Code__c = 'US';
        lead.Billing_Postal_Code__c = '07310';
        lead.Shipping_Address_1__c = '123 SAMPLE STREET';
        lead.Shipping_City__c = 'SAMPLE CITY';
        lead.Shipping_State__c = 'NJ';
        lead.Shipping_Company__c = 'TEST CO';
        lead.Shipping_Phone_Number__c = '1234567890';
        lead.Shipping_Country__c = 'United States';
        lead.Shipping_Country_ISO_Code__c = 'US';
        lead.Shipping_Postal_Code__c = '07310';
        lead.Shipping_Address_Same_as_Billing_Address__c = shippingAddressSameAsBillingAddress;
        
        return lead;
        
    }

    @isTest
    public static void fetchShippingOptions(){
        
		Test.setMock(HttpCalloutMock.class, new UpsXmlRatingServiceSelectionRequestMock());
        
		Product2 FRM1H = [SELECT Id, ProductCode FROM Product2 WHERE ProductCode = 'FRM1H' LIMIT 1];
     
        Test.startTest();
        Response.Detail response = RegistrationFormShippingRemoter.fetchShippingOptions('US', '07310', new List<String>{FRM1H.Id});
        Test.stopTest();
        
    }
    
    @isTest
    public static void fetchShippingOptionsMissingCountryCode(){
        
		Test.setMock(HttpCalloutMock.class, new UpsXmlRatingServiceSelectionRequestMock());
        
		Product2 FRM1H = [SELECT Id, ProductCode FROM Product2 WHERE ProductCode = 'FRM1H' LIMIT 1];
     
        Test.startTest();
        Response.Detail response = RegistrationFormShippingRemoter.fetchShippingOptions(null, '07310', new List<String>{FRM1H.Id});
        Test.stopTest();
        
    }
    
    @isTest
    public static void fetchShippingOptionsForUsIsoCodeMissingPostalCode(){
        
		Test.setMock(HttpCalloutMock.class, new UpsXmlRatingServiceSelectionRequestMock());
        
		Product2 FRM1H = [SELECT Id, ProductCode FROM Product2 WHERE ProductCode = 'FRM1H' LIMIT 1];
     
        Test.startTest();
        Response.Detail res = RegistrationFormShippingRemoter.fetchShippingOptions('US', null, new List<String>{FRM1H.Id});
        System.assertEquals(400, res.status, 'It should block the request because all US shipping options need the postal code included to be computed.');
        Test.stopTest();
        
    }
    
    @isTest
    public static void fetchShippingOptionsForNonUsIsoCodeMissingPostalCode(){
        
		Test.setMock(HttpCalloutMock.class, new UpsXmlRatingServiceSelectionRequestMock());
        
		Product2 FRM1H = [SELECT Id, ProductCode FROM Product2 WHERE ProductCode = 'FRM1H' LIMIT 1];
     
        Test.startTest();
        Response.Detail res = RegistrationFormShippingRemoter.fetchShippingOptions('HK', null, new List<String>{FRM1H.Id});
        System.assertEquals(200, res.status, 'It should not block the request because all non-US shipping options do not need the postal code included to be computed.');
        Test.stopTest();
        
    }
    
    @isTest
    public static void fetchShippingOptionsMissingProducts(){
        
		Test.setMock(HttpCalloutMock.class, new UpsXmlRatingServiceSelectionRequestMock());
       
        Test.startTest();
        Response.Detail response = RegistrationFormShippingRemoter.fetchShippingOptions('US', '07310', new List<String>{});
        Test.stopTest();
        
    }
    
    @isTest
    public static void fetchShippingOptionsErrorCode111210(){
        
		Test.setMock(HttpCalloutMock.class, new UpsXmlRatingServiceSelectionRequestMock('111210'));
        
		Product2 FRM1H = [SELECT Id, ProductCode FROM Product2 WHERE ProductCode = 'FRM1H' LIMIT 1];
     
        Test.startTest();
        Response.Detail response = RegistrationFormShippingRemoter.fetchShippingOptions('US', '07310', new List<String>{FRM1H.Id});
        Test.stopTest();
        
    }
    
    @isTest
    public static void validateAddressBillingExactMatch(){
        
		Test.setMock(HttpCalloutMock.class, new UpsXmlAddressValidationRequestMock(FALSE));
             
        Test.startTest();
        Response.Detail response = RegistrationFormShippingRemoter.validateAddress(JSON.serialize(createGenericLead(TRUE)));
        Test.stopTest();
        
    }
    
    @isTest
    public static void validateAddressBillingNotExactMatch(){
        
		Test.setMock(HttpCalloutMock.class, new UpsXmlAddressValidationRequestMock(TRUE));
             
        Test.startTest();
        Response.Detail response = RegistrationFormShippingRemoter.validateAddress(JSON.serialize(createGenericLead(TRUE)));
        Test.stopTest();
        
    }
    
    @isTest
    public static void validateAddressShippingExactMatch(){
        
		Test.setMock(HttpCalloutMock.class, new UpsXmlAddressValidationRequestMock(FALSE));
             
        Test.startTest();
        Response.Detail response = RegistrationFormShippingRemoter.validateAddress(JSON.serialize(createGenericLead(FALSE)));
        Test.stopTest();
        
    }
    
    @isTest
    public static void validateAddressShippingNotExactMatch(){
        
		Test.setMock(HttpCalloutMock.class, new UpsXmlAddressValidationRequestMock(TRUE));
             
        Test.startTest();
        Response.Detail response = RegistrationFormShippingRemoter.validateAddress(JSON.serialize(createGenericLead(FALSE)));
        Test.stopTest();
        
    }

    @isTest
    public static void validateShippingSelectionForUsIncludingPostalCode(){

        UpsXmlRatingServiceSelectionResponse.RatedShipment shipping = new UpsXmlRatingServiceSelectionResponse.RatedShipment();

        shipping.currencyCode = 'USD';
        shipping.guaranteedDaysToDelivery =  '3';
        shipping.label = 'TEST';
        shipping.monetaryValue = '20.00';
        shipping.serviceCode = '59';//must be a real service code being returned from the mock
        shipping.scheduledDeliveryTime = '3';

        Lead lead = createGenericLead(TRUE);
        
        lead.Billing_Country_ISO_Code__c = 'US';
        lead.Shipping_Country_ISO_Code__c = 'US';
        
        PricebookEntry pbe = [SELECT Id FROM PricebookEntry LIMIT 1];

        Test.startTest();
        
        Response.Collection response = RegistrationFormShippingHelper.validateShippingSelection(shipping, lead, new Set<Id>{pbe.Id});
                
        OpportunityLineItem shippingOli = (OpportunityLineItem)response.data[0];
        
        System.assertEquals(200, response.status, 'It should be a successful request.');
        System.assertEquals(14.74, shippingOli.UnitPrice, shippingOli);
        
        Test.stopTest();

    }
    
    @isTest
    public static void validateShippingSelectionForUsMissingPostalCode(){

        UpsXmlRatingServiceSelectionResponse.RatedShipment shipping = new UpsXmlRatingServiceSelectionResponse.RatedShipment();

        shipping.currencyCode = 'USD';
        shipping.guaranteedDaysToDelivery =  '3';
        shipping.label = 'TEST';
        shipping.monetaryValue = '20.00';
        shipping.serviceCode = '59';//must be a real service code being returned from the mock
        shipping.scheduledDeliveryTime = '3';

        Lead lead = createGenericLead(TRUE);
        
        lead.Billing_Postal_Code__c = null; 
        lead.Billing_Country_ISO_Code__c = 'US';
        lead.Shipping_Postal_Code__c = null; 
        lead.Shipping_Country_ISO_Code__c = 'US';
        
        PricebookEntry pbe = [SELECT Id FROM PricebookEntry LIMIT 1];

        Test.startTest();
                
        Response.ResponseException actualResponse = null;
        try{
        	Response.Collection response = RegistrationFormShippingHelper.validateShippingSelection(shipping, lead, new Set<Id>{pbe.Id});
        }catch(Response.ResponseException e){
            actualResponse = e;
        }

        System.assertEquals(400, actualResponse.status, 'It should throw an exception since the Postal Code is missing for a US address.');
        
        Test.stopTest();

    }
    
	@isTest
    public static void validateShippingSelectionForNonUsIncludingPostalCode(){

        UpsXmlRatingServiceSelectionResponse.RatedShipment shipping = new UpsXmlRatingServiceSelectionResponse.RatedShipment();

        shipping.currencyCode = 'USD';
        shipping.guaranteedDaysToDelivery =  '3';
        shipping.label = 'TEST';
        shipping.monetaryValue = '20.00';
        shipping.serviceCode = '59';//must be a real service code being returned from the mock
        shipping.scheduledDeliveryTime = '3';

        Lead lead = createGenericLead(TRUE);
        
        lead.Billing_Country_ISO_Code__c = 'HK';
        lead.Shipping_Country_ISO_Code__c = 'HK';
        
        PricebookEntry pbe = [SELECT Id FROM PricebookEntry LIMIT 1];

        Test.startTest();
        
        Response.Collection response = RegistrationFormShippingHelper.validateShippingSelection(shipping, lead, new Set<Id>{pbe.Id});
                
        OpportunityLineItem shippingOli = (OpportunityLineItem)response.data[0];
        
        System.assertEquals(200, response.status, 'It should be a successful request.');
        System.assertEquals(14.00, shippingOli.UnitPrice, 'It should be USD 14.00 after the discount is applied.');
        
        Test.stopTest();

    }
    
    @isTest
    public static void validateShippingSelectionForNonUsMissingPostalCode(){

        UpsXmlRatingServiceSelectionResponse.RatedShipment shipping = new UpsXmlRatingServiceSelectionResponse.RatedShipment();

        shipping.currencyCode = 'USD';
        shipping.guaranteedDaysToDelivery =  '3';
        shipping.label = 'TEST';
        shipping.monetaryValue = '20.00';
        shipping.serviceCode = '59';//must be a real service code being returned from the mock
        shipping.scheduledDeliveryTime = '3';

        Lead lead = createGenericLead(TRUE);
        
        lead.Billing_Postal_Code__c = null; 
        lead.Billing_Country_ISO_Code__c = 'HK';
        lead.Shipping_Postal_Code__c = null; 
        lead.Shipping_Country_ISO_Code__c = 'HK';
        
        PricebookEntry pbe = [SELECT Id FROM PricebookEntry LIMIT 1];

        Test.startTest();
        
        Response.Collection response = RegistrationFormShippingHelper.validateShippingSelection(shipping, lead, new Set<Id>{pbe.Id});
                
        OpportunityLineItem shippingOli = (OpportunityLineItem)response.data[0];
        
        System.assertEquals(200, response.status, 'It should be a successful request.');
        System.assertEquals(14.00, shippingOli.UnitPrice, 'It should be USD 14.00 after the discount is applied.');
        
        Test.stopTest();

    }
}