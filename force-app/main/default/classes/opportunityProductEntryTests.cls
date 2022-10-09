@isTest
private class opportunityProductEntryTests {
    
    static Account acc ;
    static Opportunity opp; 
    
    
    static void testData(){ 
        
        Product2 prod = new Product2(Name = 'Laptop X200',productCode = 'AFREE',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod;
        
        Product2 prod1 = new Product2(Name = 'Laptop X200',productCode = 'AFREE',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod1;
        
        Product2 prod2 = new Product2(Name = 'Laptop X200',productCode = 'FRM1S',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod2; 
        
        Product2 prod3 = new Product2(Name = 'Laptop X200',productCode = 'FRM2S',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod3;
        
        Product2 prod4 = new Product2(Name = 'Laptop X200',productCode = 'FRM1',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod4;
        
        Product2 prod5 = new Product2(Name = 'Laptop X200',productCode = 'FCBR',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod5;
        
        Product2 prod6 = new Product2(Name = 'Laptop X200',productCode = 'FBRNM',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod6;
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod1.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice1;
        PricebookEntry standardPrice2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod2.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice2;
        PricebookEntry standardPrice3 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod3.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice3;
        PricebookEntry standardPrice4 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod4.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice4;
        PricebookEntry standardPrice5 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod5.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice5;
        PricebookEntry standardPrice6 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod6.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice6;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        PricebookEntry customPrice1 = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod1.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice1;
        
        insert new UpdateIds__c(Name='User', Record_Id__c='00540000001y7OX');        
        
        
       
        
        Acc = new Account(Name = 'test');
        insert acc;
        
        Id manualRecId = RecordTypeHelper.GetRecordTypeId('Opportunity','Manual'); 
        opp = new Opportunity(amount = 123,Name = 'Test',RecordTypeID = manualRecId,Inst_Sale_Service_End_Date__c=system.today()+ 15,Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = acc.id,stageName = 'New Lead',Program__c = 'Print',Inst_Sale_Code__c = 'Promocode',Institutional_Sale__c = TRUE,Institutional_Sale_Stage__c = 'Approved',closedate = system.today()+ 15);        
        insert opp;
        
        PricebookEntry customPrice2 = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod2.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice2;
        
        PricebookEntry customPrice3 = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod3.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice3;
        
        PricebookEntry customPrice4 = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod4.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice4;
        
        PricebookEntry customPrice5 = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod5.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice5;
        
        PricebookEntry customPrice6 = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod6.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice6;
        
        OpportunityLineItem oppli = new OpportunityLineItem();
        oppli.Quantity=2;
        oppli.OpportunityId=opp.Id; 
        oppli.TotalPrice=10;
        oppli.PriceBookEntryId = customPrice2.Id;
        insert oppli;
        
        OpportunityLineItem oppli1 = new OpportunityLineItem();
        oppli1.Quantity=2;
        oppli1.OpportunityId=opp.Id; 
        oppli1.TotalPrice=10;
        oppli1.PriceBookEntryId = customPrice3.Id;
        insert oppli1;
        
        OpportunityLineItem oppli2 = new OpportunityLineItem();
        oppli2.Quantity=2;
        oppli2.OpportunityId=opp.Id; 
        oppli2.TotalPrice=10;
        oppli2.PriceBookEntryId = customPrice4.Id;
        insert oppli2;
        }
        
    static testMethod void myUnitTest_1() {
        
            testData();
        
             test.startTest();
             Apexpages.StandardController std = new Apexpages.StandardController(opp);
             opportunityProductEntryExtension ope = new opportunityProductEntryExtension(std);
             ope.priceBookCheck();
             ope.changePricebook();
             ope.priceBookCheck();
             ope.updateAvailableList();
             ope.removeFromShoppingCart();
             ope.onSave();
             ope.onCancel();
             ope.addToShoppingCart();
             test.stopTest();  
 
 
        }
 
      }