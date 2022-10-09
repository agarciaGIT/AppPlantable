@isTest
private class EBookSyncBatchTest {
    
    @isTest
    static void testUtils() {
        Test.startTest();
        System.schedule('E-Book Sync Up Job', '0 30 23 * * ?', new EBookSyncBatch('TODAY', 5));
        Test.stopTest();
    }
    
    @isTest
    static void testBatch() {
        Opportunity oppty = TestingHelper.createOppty('Test Apex Oppty', false, true);
        oppty.Shipping_E_mail__c = 'auser.testo@nomail.com';
        oppty.Shipping_First_Name__c ='Auser'; 
        oppty.Shipping_Last_Name__c= 'Testo';
        oppty.CloseDate = System.today();
        oppty.StageName = 'Closed';
        insert oppty;
        
        Product2 prod = TestingHelper.createProduct('GARP', 'FRM Part I eBook', false);
        prod.ProductCode = 'FRM1X';
        insert prod;
        
        Product2 prod2 = TestingHelper.createProduct('GARP', 'FRM Part II eBook', false);
        prod2.ProductCode = 'FRM2X';
        insert prod2;

        Product2 prod3 = TestingHelper.createProduct('GARP', 'SCR eBook', false);
        prod3.ProductCode = 'SCRX';
        insert prod3;
        
        TestingHelper.createEntry(prod.Id); 
        TestingHelper.createEntry(prod2.Id); 
        TestingHelper.createEntry(prod3.Id); 
        
        TestingHelper.createOpptyProduct(oppty.Id, prod.Id, true);
        TestingHelper.createOpptyProduct(oppty.Id, prod2.Id, true);
        TestingHelper.createOpptyProduct(oppty.Id, prod3.Id, true);
        
        TestingHelper.createMobiusSettings(true);
                
        Test.startTest();        
        Database.executeBatch(new EBookSyncBatch('TODAY', 5), 5);
        Test.stopTest();
    }
    
}