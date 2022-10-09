/* Test Class for ConventionBadgeScanning
 * 
 **/
@isTest
public class ConventionBadgeScanningTestClass {

    @TestSetup
    private static void setup(){

        INSERT new Remote_Sites__c(
            Name = 'EventMobi', 
            Site_URL__c = 'http://test.com'
        );
        
        INSERT new EventMobi_Configuration__c(
            Name = 'X-API-KEY', 
            Value__c = 'asasdasdasd'
        );
        
        INSERT new EventMobi_Configuration__c(
            Name = 'EVENT-ID', 
            Value__c = 'test-event-id'
        );
    }

    // Test method to create test data 
    private static testMethod void test_fetchData(){

        EventMobiApiBatch.disableBatch = true;

        // create Account
        Account acc = new Account();
        acc.name = 'Test Account';
        insert acc;
        
        // create contact
        Contact con = new Contact(lastname = 'Test',AccountId = acc.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
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
        insert eventReg;
        
        // Create Event_Sessions__c
        Event_Sessions__c eventSessions = new Event_Sessions__c();
        eventSessions.Event__c = event.id;
        eventSessions.Name = 'Test Event Session';
        insert eventSessions;
        
        // Create Event_Session_Registration__c
        Event_Session_Registration__c eventSessionReg = new Event_Session_Registration__c();
        eventSessionReg.Event_Registration__c = eventReg.id;
        eventSessionReg.Event_Session__c = eventSessions.id;
         insert eventSessionReg;
    }
    
    // Test method to check event registration
    public static testMethod void TestEventRegistration(){
        test_fetchData();
        test.startTest();
        ConventionBadgeScanning BadgeClass = new ConventionBadgeScanning();
        BadgeClass.EventVerification();
        test.stopTest();
    }
    
    // Test method to check session navigation
     public static testMethod void TestSessionNavigation(){
        test_fetchData();
        test.startTest();
        ConventionBadgeScanning BadgeClass = new ConventionBadgeScanning();
        BadgeClass.SessionNavigation();
        test.stopTest();
     } 
    
    //  Test method to check the session verification
    public static testMethod void TestSessionVerification(){
        EventMobiApiBatch.disableBatch = true;
        test_fetchData();
        test.startTest();
        ConventionBadgeScanning BadgeClass = new ConventionBadgeScanning();
        BadgeClass.SessionVerification();
        test.stopTest();
    }
    
    // Test method to check the session verification without session Registration.
    public static testMethod void TestSessionVerificationWithoutSessionReg(){
        EventMobiApiBatch.disableBatch = true;
        test_fetchData();
        test.startTest();
        EventMobiApiBatch.disableBatch = true;
        Event_Session_Registration__c eventSessionReg = new Event_Session_Registration__c();
        eventSessionReg = [select id from Event_Session_Registration__c LIMIT 1];
        Delete eventSessionReg;
        test.stopTest();
        ConventionBadgeScanning BadgeClass = new ConventionBadgeScanning();
        BadgeClass.SessionVerification();
    }
    
    // Test method to check the cookie creating , checking and clear cookie
    public static testMethod void TestCookieVerification(){
        EventMobiApiBatch.disableBatch = true;
        test_fetchData();
        test.startTest();
        ConventionBadgeScanning BadgeClass = new ConventionBadgeScanning();
        BadgeClass.setCookies();
        BadgeClass.checkCookies();
        BadgeClass.clearCookies();
        test.stopTest();
    }
}