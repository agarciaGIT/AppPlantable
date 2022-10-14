@isTest
public class GARP_Courses_test {
    
    public static Account account;
    public static Contact contact;
    
    public static void setup(){
        
        Product2 prod1 = GARP_TestFactory.createProduct('MEMI','MEMI','4040');
        insert prod1;
        PricebookEntry price = GARP_TestFactory.createPriceBook(prod1.Id, 100);
        insert price;
        
        Product2 prod2 = GARP_TestFactory.createProduct('MEMC','MEMC','4040');
        insert prod2;
        PricebookEntry price2 = GARP_TestFactory.createPriceBook(prod2.Id, 100);
        insert price2;

        Product2 prod3 = GARP_TestFactory.createProduct('CBRNM','CBRNM','4040');
        insert prod3;
        PricebookEntry price3 = GARP_TestFactory.createPriceBook(prod3.Id, 100);
        insert price3;

        Product2 prod4 = GARP_TestFactory.createProduct('CBR','CBR','4040');
        insert prod4;
        PricebookEntry price4 = GARP_TestFactory.createPriceBook(prod4.Id, 100);
        insert price4;

        Product2 prod5 = GARP_TestFactory.createProduct('CBRHB','CBRHB','4040');
        insert prod5;
        PricebookEntry price5 = GARP_TestFactory.createPriceBook(prod5.Id, 100);
        insert price5;

        Product2 prod6 = GARP_TestFactory.createProduct('SHIP','SHIP','4040');
        insert prod6;
        PricebookEntry price6 = GARP_TestFactory.createPriceBook(prod6.Id, 100);
        insert price6;
        
		GARP_TestFactory.createCountryCodes();
        GARP_TestFactory.createMember('garpqamem@garpqa.com', True);
    }
    
    @isTest
    public static void testFRR(){
        
        setup();
        test.startTest();
        
        GARP_BC_Courses.GetFRRRegistrationInfo();
        
        test.stopTest();
    }

    @isTest
    public static void testFFR(){
        
        setup();
        test.startTest();
        
        GARP_BC_Courses.GetFFRRegistrationInfo();
        
        test.stopTest();
    }

}