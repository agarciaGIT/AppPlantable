@isTest
public class ContactCases_Test {
    
    static Account account ;
    static Contact contact;
     static case cases;
    
    static void testData(){
         
        account = new Account(Name = 'test');
        insert account;
         
        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        cases = new case(Priority='Medium', ContactId =contact.id);
        insert cases;
        
        
        
    }
    
    static testMethod void unitTest_1(){
        testData();
        test.startTest();
        
        Apexpages.StandardController std = new Apexpages.StandardController(cases);
        ContactCases exams = new ContactCases(std);
       
        test.stopTest();
        
    }
    
}