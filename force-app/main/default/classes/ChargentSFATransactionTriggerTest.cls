@isTest
private class ChargentSFATransactionTriggerTest {
    
    @TestSetup
    static void createTestData() {
        Integer totalCount = 3;
        List<Opportunity> OppResults=TestDataFactory.createOpportunity(totalCount);
        OppResults[0].StageName = 'New Lead';
        OppResults[1].StageName = 'New Lead';
        insert OppResults;
        
        List<ChargentSFA__Transaction__c> TransactionResults = new  List<ChargentSFA__Transaction__c>();
        TransactionResults=TestDataFactory.createChargentSFATransaction(totalCount,OppResults);
        TransactionResults[0].ChargentSFA__Response_Status__c = 'Approved';
        TransactionResults[0].ChargentSFA__Type__c = 'Refund';
        TransactionResults[0].ChargentSFA__Recurring__c = false;
        TransactionResults[0].ChargentSFA__Opportunity__c = OppResults[0].Id;
        insert TransactionResults;
        
        List<Product2> Product2List = new List<Product2>();
        Product2 p1 = new Product2(Name = ' Test Product1',Description='Test Product Entry1 For Product',productCode = 'ENC2X',isActive = true,Is_Shippable__c = true,
                                   Customs_Cost__c = '5',Weight__c=5,GL_Code__c='4011');
        Product2List.add(p1);
        Product2 p2 = new Product2(Name = ' Test Product2',Description='Test Product Entry2 For Product',productCode = 'FRM1X',isActive = true,Is_Shippable__c = true,
                                   Customs_Cost__c = '6',Weight__c=6,GL_Code__c='4011');
        Product2List.add(p2);
		
		insert Product2List;
		
         List<Product_Refunds__c> ProductRefundsList = new List<Product_Refunds__c>();
        Product_Refunds__c refund1 = new Product_Refunds__c (Status__c='Completed', Reason__c = 'test', Cancel_E_book__c = True,Take_Membership__c = true,Refund_amount__c =123,
                                                             opportunity__c = OppResults[0].id,product__c = Product2List[0].id);
        ProductRefundsList.add(refund1);
        Product_Refunds__c refund2 = new Product_Refunds__c (Status__c='Completed', Cancel_ERP_Enrollment__c = True,Take_Membership__c = true,Refund_amount__c =123,
                                                             opportunity__c = OppResults[0].id,product__c = Product2List[1].id);
        ProductRefundsList.add(refund2);
      
		insert ProductRefundsList;
        
    }
    
    
    @isTest static void testChargentSFATransaction(){
        
        Test.startTest();
        List<ChargentSFA__Transaction__c> TransactionList = [Select Id,ChargentSFA__Opportunity__c  from ChargentSFA__Transaction__c  LIMIT 2];
        TransactionList[0].ChargentSFA__Type__c ='Void';
        update TransactionList;
        Test.stopTest();
        
    }
    
    @isTest static void unitTest_1(){
        
        //Opportunity opp = [Select Id,stagename from Opportunity LIMIT 1];
        //opp.stagename = 
        
        //ChargentSFA__Transaction__c Transaction1 = [Select Id,ChargentSFA__Opportunity__c  from ChargentSFA__Transaction__c  LIMIT 1];
        
        
  		Product_Refunds__c refund = [Select Status__c, Reason__c ,opportunity__c,product__c from   Product_Refunds__c Limit 1];
        
        refund.Status__c='Approved';
        refund.Reason__c = 'Switch';
        update refund;
            
        ChargentSFATransactionTriggerHandler chSFATri = new ChargentSFATransactionTriggerHandler(); 
        
        Test.startTest();
        
        chSFATri.beforeUpdate(new  ChargentSFA__Transaction__c(),new  ChargentSFA__Transaction__c());
        chSFATri.beforeDelete(new  ChargentSFA__Transaction__c());
        chSFATri.afterDelete(new  ChargentSFA__Transaction__c());
        
        Test.stopTest();
        
    }
}