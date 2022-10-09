@isTest
private class LineItemDiscountTriggerHelperTest {
	
    @isTest
    private static void test_Create() {
        Opportunity tstOpp = TestingHelper.createInstSaleOppty('Test Oppty', 'GARP', true, true);
        List<Product2> prods = TestingHelper.createFRMProds();
        TestingHelper.createProduct(null, 'Inst Sale Total Discount', true);
        
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId=tstOpp.Id, Product2Id=prods[0].Id, UnitPrice=100, Quantity=1);
        insert oli;
        
        Test.startTest();
        Line_Item_Discount__c itemDisc = new Line_Item_Discount__c(Opportunity__c = tstOpp.Id, Product__c = prods[0].Id, Discount_Percent__c = 10);
        insert itemDisc;
        Test.stopTest();
        
		itemDisc = [SELECT Id, Discount_Amount__c, Line_Item_Id__c FROM Line_Item_Discount__c WHERE Id = :itemDisc.Id];
        System.assertEquals(10, itemDisc.Discount_Amount__c);
        System.assertEquals(oli.Id, itemDisc.Line_Item_Id__c);
        
		tstOpp = [SELECT Id, Amount FROM Opportunity WHERE Id = :tstOpp.Id];
        System.assertEquals(90, tstOpp.Amount);
    }
    
    @isTest
    private static void test_Update() {
        Line_Item_Discount__c itemDisc = TestingHelper.setupInstSaleOppWithDisc('Test Inst Sale Opp');
        
        Test.startTest();
        update new Line_Item_Discount__c(Id = itemDisc.Id, Discount_Percent__c = 15);
        Test.stopTest();
        
        itemDisc = [SELECT Id, Discount_Amount__c, Line_Item_Id__c FROM Line_Item_Discount__c WHERE Id = :itemDisc.Id];
        OpportunityLineItem oli = [SELECT Id FROM OpportunityLineItem WHERE Opportunity.Name = 'Test Inst Sale Opp' AND Product2.Name != 'Inst Sale Total Discount'];
        
        System.assertEquals(15, itemDisc.Discount_Amount__c);
        System.assertEquals(oli.Id, itemDisc.Line_Item_Id__c);
        
		Opportunity tstOpp = [SELECT Id, Amount FROM Opportunity WHERE Name = 'Test Inst Sale Opp'];
        System.assertEquals(85, tstOpp.Amount);
    }
    
    @isTest
    private static void test_Delete() {
        Line_Item_Discount__c itemDisc = TestingHelper.setupInstSaleOppWithDisc('Test Inst Sale Opp');
        
        Test.startTest();
        delete new Line_Item_Discount__c(Id = itemDisc.Id);
        Test.stopTest();
        
		Opportunity tstOpp = [SELECT Id, Amount FROM Opportunity WHERE Name = 'Test Inst Sale Opp'];
        System.assertEquals(100, tstOpp.Amount);
    }
    
}