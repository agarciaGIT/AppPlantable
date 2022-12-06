@isTest
private class updatewileyByRefunds_Test {
    
    @isTest static void testProductWiley(){
        Account account ;
        set<id> setAccounts= new set<id>();
        Opportunity opportunity1; 
        ChargentBase__Gateway__c chrgGtway;
        Product_Refunds__c refund1;
        ChargentSFA__Transaction__c payment1;
        OpportunityLineItem lineItem;
        contract contract;
        Product2 prod;
        Test.startTest();
        chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        account = new Account(Name = 'test');
        insert account;
        setAccounts.add(account.id);
        opportunity1 = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment',
                                       ChargentSFA__Payment_Frequency__c='Once',ChargentSFA__Payment_Status__c='Complete',
                                       accountId = account.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity1; 
        
        payment1 = new ChargentSFA__Transaction__c(ChargentSFA__Opportunity__c = opportunity1.id,ChargentSFA__Type__c = 'Charge', 
                                                   ChargentSFA__Response_Status__c= 'Approved');
        insert payment1;
        
        prod = new Product2(Name = 'Laptop X200',productCode = 'MEMI',GL_Code__c = '4999',Family = 'Hardware');
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(),IsActive = true);
        Update standardPricebook;
        
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = standardPricebook.Id,Product2Id = prod.Id,UnitPrice = 250,IsActive = true,UseStandardPrice = false);
        insert standardPrice1;
        
        id  memRecordType = RecordTypeHelper.GetRecordTypeId('Contract','Wiley Bookstore');  
        Contract  = new Contract(recordTypeId = memRecordType,Opportunity__c = opportunity1.id, 
                                 AccountId = opportunity1.accountId ,ContractTerm = 12,StartDate = opportunity1.CloseDate);
        insert Contract;
        contract.Status = 'Activated';
        update Contract;
        refund1 = new Product_Refunds__c (Status__c='Approved',Cancel_Wiley__c =true, Wiley_Quantity__c =15.00,
                                          Refund_amount__c =123,opportunity__c = opportunity1.id,product__c = prod.id);
        
        insert refund1;

        updatewileyByRefunds.updatewileyTerm(setAccounts,integer.valueof(refund1.Wiley_Quantity__c));
        contract.ContractTerm = 20;
        update contract;
        updatewileyByRefunds.updatewileyTerm(setAccounts,integer.valueof(refund1.Wiley_Quantity__c));
        Test.stopTest();
    }
   
}