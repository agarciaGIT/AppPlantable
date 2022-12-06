@isTest
public class SageRefundProcessQueueableTest {
    
    @isTest
    public static void unitTest(){
        
        Map<Id,Set<Id>> opptoProdMap = new  Map<Id,Set<Id>>();
        Map<String,ChargentSFA__Transaction__c> oppToTransactionMap = new Map<String,ChargentSFA__Transaction__c>();
        Map<Id,Id> switchTransMap = new Map<Id,Id>();
        Integer totalCountOpp = 1;
        
        Product2 p1 = new Product2(Name = ' Test Product1',Description='Test Product Entry1 For Product',
                                   productCode = 'FRM1',isActive = true,Is_Shippable__c = true,Family='IndividualMember',
                                   Customs_Cost__c = '5',GL_Code__c = '4999',Weight__c=5);
        insert p1;
        
         Product2 p2 = new Product2(Name = ' Test Product1',Description='Test Product Entry1 For Product',
                                   productCode = 'FRM2',isActive = true,Is_Shippable__c = true,Family='IndividualMember',
                                   Customs_Cost__c = '5',GL_Code__c = '4999',Weight__c=5);
        insert p2;
        
        // insert pricebook entry for the product
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(),
                                                          Product2Id = p1.Id,UnitPrice = 250,IsActive = true,
                                                          UseStandardPrice = false);
        insert standardPrice ;
        
        Account account = new Account();
        account.Name = 'TEST CO';
        INSERT account;
        
        List<Opportunity> OppResults = new List<Opportunity> ();
        OppResults = TestDataFactory.createOpportunity(totalCountOpp);
        OppResults[0].StageName = 'New Lead';
        insert OppResults;
        
        ChargentSFA__Transaction__c payment = new ChargentSFA__Transaction__c(ChargentSFA__Opportunity__c = OppResults[0].id,ChargentSFA__Type__c = 'Charge',
                                                                              ChargentSFA__Response_Status__c= 'Approved');
        insert payment;
        
        /*List<ChargentSFA__Transaction__c> TransactionResults = new  List<ChargentSFA__Transaction__c>();
        TransactionResults=TestDataFactory.createChargentSFATransaction(totalCountOpp,OppResults);
        TransactionResults[0].ChargentSFA__Response_Status__c = 'Approved';
        TransactionResults[0].ChargentSFA__Type__c = 'Refund';
        TransactionResults[0].ChargentSFA__Recurring__c = false;
        insert TransactionResults;*/
        
        // Add product and Pricebook to the particular opportunity using OpportunityLineItem 
        
        OpportunityLineItem oppLineItem = new OpportunityLineItem(OpportunityId = OppResults[0].Id,PricebookEntryId = standardPrice.Id,
                                                                  UnitPrice = 250,Product2Id = p1.Id,Quantity = 1,Product_company__c='GRA Test');
        insert oppLineItem;
        
		OpportunityLineItem oppLineItem1 = new OpportunityLineItem(OpportunityId = OppResults[0].Id,PricebookEntryId = standardPrice.Id,
                                                                  UnitPrice = 250,Product2Id = p2.Id,Quantity = 1,Product_company__c='GRA Test');
        insert oppLineItem1;
        
        Test.startTest();
        
        Set<id> SetProdID = new Set<id>();
        SetProdID.add((id)p1.id);
        SetProdID.add((id)p2.id);
        opptoProdMap.put((id)OppResults[0].id,SetProdID);
        oppToTransactionMap.put((String)OppResults[0].id,payment);  
        //switchTransMap.put(payment.Id,OppResults[0].id);
        
        System.enqueueJob(new SageRefundProcessQueueable(opptoProdMap,oppToTransactionMap,switchTransMap));
        
        Test.stopTest();
    }
}