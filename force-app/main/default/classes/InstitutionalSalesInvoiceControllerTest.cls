@isTest
private class InstitutionalSalesInvoiceControllerTest {
    
    @isTest static void testConstructor() {
        Opportunity oppty = TestingHelper.createOppty('Apex Test Oppty', true);
        Product2 prodGRA = TestingHelper.createProduct('GRA', 'GRA Test', true);
        Product2 prodGARP = TestingHelper.createProduct('GARP', 'GARP Test', true);
        Product2 prodGARP2 = TestingHelper.createProduct('GARP', 'GARP Test 2', true);
        
        OpportunityLineItem oliGRA = TestingHelper.createOpptyProduct(oppty.Id, prodGRA.Id, true);
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', oppty.id);
		ApexPages.StandardController stdOpptyCtrl = new ApexPages.StandardController(oppty);
	    InstitutionalSalesInvoiceController ctrlExt  = new InstitutionalSalesInvoiceController(stdOpptyCtrl);
	    
	    delete oliGRA;
	    TestingHelper.createOpptyProduct(oppty.Id, prodGARP.Id, true);
	    TestingHelper.createOpptyProduct(oppty.Id, prodGARP2.Id, true);
	    ctrlExt  = new InstitutionalSalesInvoiceController(stdOpptyCtrl);
        Test.stopTest();
    }
    
    @isTest
    private static void testInvoiceData() {
        TestingHelper.setupInstSaleOppWithDisc('Test Inst Sale');
        
        List<Product2> prods = [SELECT Id FROM Product2 WHERE Name != 'Inst Sale Total Discount'];
        Integer c = 0;
        for(Product2 prod : prods) {
            prod.Inst_Sale_Sort_Order__c = c++;
        }
        update prods;
        
        Opportunity tstOpp = [SELECT Id FROM Opportunity WHERE Name = 'Test Inst Sale'];
        Product2 prod = [SELECT Id FROM Product2 WHERE Name = 'FRM Enrollment Fee'];
        
        TestingHelper.createOpptyProduct(tstOpp.Id, prod.Id, true);
        
        ApexPages.currentPage().getParameters().put('id', tstOpp.Id);
        
        Test.startTest();
        InstitutionalSalesInvoiceController instSaleInvCtrl = new InstitutionalSalesInvoiceController();
        Test.stopTest();
    }
    
}