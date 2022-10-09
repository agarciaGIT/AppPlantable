/* ConventionBadgeSelectionController test class
 * 
 **/
@isTest
public class ConventionBadgeSelectionControllerTest {
    
    // Test method to create test data 
    private static testMethod void test_fetchData() {
        
        // create Account
        Account acc = new Account();
        acc.name = 'Test Account';
        insert acc;
        
        // create contact
        Contact con = new Contact(lastname = 'Test',AccountId = acc.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17),
                                  Corporate_Title__c='Test Title');
        insert con;
        
        // Create Event
        Event__c event = new Event__c();
        event.Name = 'Test Event';
        insert event;
        
        // Create Event Registration
        Event_Registration__c eventReg = new Event_Registration__c();
        eventReg.Contact__c = con.id;
        eventReg.Event__c = event.id;
        eventReg.Name = 'Test Event Registration';
        eventReg.Status__c = 'Registered';
        eventReg.Member_FRM_Certified__c = true;
        eventReg.Member_ERP_Certified__c = true;
        eventReg.Status__c  = 'Registered and Paid';
        insert eventReg;
    }
    
    // Test Method to Print Badges based on the selected country selected 
    public static testMethod void PrintEventRegistration() {
        test_fetchData();
        test.startTest();
        ConventionBadgeSelectionController PrintBadge = new ConventionBadgeSelectionController();
        PrintBadge.getCountriesOptions();
        PrintBadge.selectedCountry = 'NEW YORK';
        PrintBadge.print();
        PrintBadge.selectedCountry = 'LONDON';
        PrintBadge.print();
        Contact conn1 = [Select id from contact LIMIT 1];
        PrintBadge.ContactIdBadge = conn1.id;
        PrintBadge.PrintBadgeMethod();
        test.stopTest();
    }
}