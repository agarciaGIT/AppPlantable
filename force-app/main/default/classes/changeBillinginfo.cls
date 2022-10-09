public without sharing class changeBillinginfo {

    public Opportunity contextRecord { get; set; }
    
    public List<SelectOption> selectOptions { get; set; }

        public Wrapper viewModel { get; set; }
    
    public class Wrapper{
        public String upsStage                  { get; set; }
        public String upsServiceCodeForXml      { get; set; }
        public String shippingStreet            { get; set; }
        public String shippingCity              { get; set; }
        public String shippingState             { get; set; }
        public String shippingPostalCode        { get; set; }
        public String shippingCountry           { get; set; }
        public String shippingFirstName         { get; set; }
        public String shippingLastName          { get; set; }
        public string TrackingNumber            { get; set; }
        public string countrycode               { get; set; }
        public String BillingStreet            { get; set; }
        public String BillingCity              { get; set; }
        public String BillingState             { get; set; }
        public String BillingPostalCode        { get; set; }
        public String BillingCountry           { get; set; }
        public String BillingFirstName         { get; set; }
        public String BillingLastName          { get; set; }
        public String BillingCompany          { get; set; }
        public String additionalInfo          { get; set; }
        
        
        public String BillingPhone              { get; set; }
        public String ShippingPhone             { get; set; }
        
    }
    
    public PageReference doSave(){
        if(contextRecord != null){
            
            contextRecord.Ups_Stage__c                                  = viewModel.upsStage;
            contextRecord.UPS_Service_Code_For_XML__c   = viewModel.upsServiceCodeForXml;
            contextRecord.Shipping_Street__c                    = viewModel.shippingStreet;
            contextRecord.Shipping_City__c                              = viewModel.shippingCity;
            contextRecord.Shipping_State__c                             = viewModel.shippingState;
            contextRecord.Shipping_Postal_Code__c               = viewModel.shippingPostalCode;
            contextRecord.Shipping_Country__c                   = viewModel.shippingCountry;
            contextRecord.Shipping_First_Name__c                = viewModel.shippingFirstName;
            contextRecord.Shipping_Last_Name__c                 = viewModel.shippingLastName;
            contextRecord.Tracking_Number__c                    = viewModel.TrackingNumber;
            contextRecord.Country_Code_for_UPS__c               = viewModel.countrycode;
            contextRecord.ChargentSFA__Billing_Address__c       = viewModel.BillingStreet;  
            contextRecord.ChargentSFA__Billing_City__c          = viewModel.BillingCity;
            contextRecord.ChargentSFA__Billing_State__c         = viewModel.BillingState;
            contextRecord.ChargentSFA__Billing_Zip__c           = viewModel.BillingPostalCode;
            contextRecord.ChargentSFA__Billing_Country__c       = viewModel.BillingCountry;
            contextRecord.ChargentSFA__Billing_First__c         = viewModel.BillingFirstName;
            contextRecord.ChargentSFA__Billing_Last__c          = viewModel.BillingLastName;
            contextRecord.ChargentSFA__Billing_Company__c       = viewModel.BillingCompany;
            contextRecord.Additional_Invoice_Information__c       = viewModel.additionalInfo;
            
            contextRecord.ChargentSFA__Billing_Phone__c                    = viewModel.BillingPhone;
            contextRecord.Shipping_Phone_No__c                             = viewModel.ShippingPhone;

                        UPDATE contextRecord;
 
            PageReference ref = new PageReference('/' + contextRecord.Id);
            
            ref.setRedirect(true);
            
            return ref;
            
        }else{
            
            return null;
            
        }
    }
        
    public changeBillinginfo(ApexPages.StandardController ctrl){
        
        selectOptions = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult = Opportunity.UPS_Stage__c.getDescribe();
        for(Schema.PicklistEntry f: fieldResult.getPicklistValues()){
            selectOptions.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        
        if(ApexPages.currentPage().getParameters().get('Id') != null){
            
            contextRecord = [
                SELECT Id, Name, Additional_Invoice_Information__c, Shipping_Phone_No__c, ChargentSFA__Billing_Phone__c, Shipping_First_Name__c,ChargentSFA__Billing_Zip__c,ChargentSFA__Billing_State__c,ChargentSFA__Billing_Country__c,ChargentSFA__Billing_City__c,ChargentSFA__Billing_Address__c, Country_Code_for_UPS__c,ChargentSFA__Billing_First__c,ChargentSFA__Billing_Last__c,ChargentSFA__Billing_Company__c, Shipping_Last_Name__c,Tracking_Number__c, UPS_Stage__c, UPS_Service_Code_For_XML__c, Shipping_Street__c, Shipping_City__c, Shipping_State__c, Shipping_Postal_Code__c, Shipping_Country__c
                FROM Opportunity
                WHERE Id = :ApexPages.currentPage().getParameters().get('Id')
                LIMIT 1
            ];
            
            Wrapper w = new Wrapper();
            
          
            w.shippingStreet            = contextRecord.Shipping_Street__c;
            w.shippingCity              = contextRecord.Shipping_City__c;
            w.shippingState             = contextRecord.Shipping_State__c;
            w.shippingPostalCode        = contextRecord.Shipping_Postal_Code__c;
            w.shippingCountry           = contextRecord.Shipping_Country__c;
            w.shippingFirstName         = contextRecord.Shipping_First_Name__c;
            w.shippingLastName          = contextRecord.Shipping_Last_Name__c;
            w.TrackingNumber            = contextRecord.Tracking_Number__c;
            w.countrycode               = contextRecord.Country_Code_for_UPS__c;
            w.BillingStreet             = contextRecord.ChargentSFA__Billing_Address__c;
            w.BillingCity               = contextRecord.ChargentSFA__Billing_City__c;
            w.BillingState              = contextRecord.ChargentSFA__Billing_State__c;
            w.BillingPostalCode         = contextRecord.ChargentSFA__Billing_Zip__c;
            w.BillingCountry            = contextRecord.ChargentSFA__Billing_Country__c;
            w.BillingFirstName          = contextRecord.ChargentSFA__Billing_First__c;
            w.BillingLastName           = contextRecord.ChargentSFA__Billing_Last__c;
            w.BillingCompany            = contextRecord.ChargentSFA__Billing_Company__c;
            w.additionalInfo            = contextRecord.Additional_Invoice_Information__c;
            
            w.BillingPhone            = contextRecord.ChargentSFA__Billing_Phone__c;
            w.ShippingPhone          = contextRecord.Shipping_Phone_No__c;
            
            viewModel = w;
            
        }else{
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'This Opportunity does not exist.'));
            
        }
        
    }

}