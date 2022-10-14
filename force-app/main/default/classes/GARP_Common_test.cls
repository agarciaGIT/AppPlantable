@isTest
public class GARP_Common_test {
    public static Account account;
    public static Contact contact;
    
    public static void setup(){
        
        Product2 prod1 = GARP_TestFactory.createProduct('MEMI','MEMI','4040');
        insert prod1;
        PricebookEntry price = GARP_TestFactory.createPriceBook(prod1.Id, 100);
        insert price;
        
        Product2 prod2 = GARP_TestFactory.createProduct('MEMR','MEMR','4040');
        insert prod2;
        PricebookEntry price2 = GARP_TestFactory.createPriceBook(prod2.Id, 100);
        insert price2;
        
        Product2 prod3 = GARP_TestFactory.createProduct('PRFEE','PRFEE','4040');
        insert prod3;
        PricebookEntry price3 = GARP_TestFactory.createPriceBook(prod3.Id, 100);
        insert price3;
        
        GARP_TestFactory.createCountryCodes();
        contact = GARP_TestFactory.createMember('garpqamem@garpqa.com', True);
    }
    
    @isTest
    public static void testCommon1(){

        setup();
        test.startTest();
        
        GARP_Common.getExistingContactInfo(contact.Id);
        GARP_Common.CheckAuthentication();
        GARP_Common.CheckExistingContact('garpqamem@garpqa.com');
        GARP_Common.SetLead('garpqamem@garpqa.com', 'firstName', 'lastName', 'formName', null);
        GARP_Common.formatAddressTextArea('street1', 'street2', 'street3'); 
        
        // removeOrder
        // formatAddressTextArea
        test.stopTest();
    }
    
}