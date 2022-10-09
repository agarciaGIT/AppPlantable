@isTest
public class WebcastPDFControllerTest {
    
    @testsetup
    Public static void createObjects(){
        
        
        
        Webcast__c testWeb = new Webcast__c(name = 'This is a test', title__c='CEO', Description__c = 'This is some Text', Start_Date__c = System.today(),
                                            End_Date__c = System.today().addDays(3), Prerecorded_Clips__c = 'Yes', Is_Auto_Registration_Required__c ='Yes',
                                            Start_Time__c = '10:00 am EST | 2:00 pm GMT|3:00pm London | 10:00 pm HKT', End_Time__c ='11:00 am EST | 3:00 pm GMT| 11:00 pm HKT');
        insert testWeb;
        
        Presenter__c Moderator = new Presenter__c(webcast__c = testWeb.id, Role__c = 'Moderator', name = 'Montogomery');
        
        insert Moderator;
        
        Presenter__c Presenter = new Presenter__c(webcast__c = testWeb.id, Role__c = 'Presenter', name = 'Kevin');
        insert presenter;
    }
    Public testMethod static void testAll(){
        
            Webcast__c thisWeb = [Select id from Webcast__c
                                  Where name = 'This is a test'];
            
        ApexPages.StandardController stdWeb = new ApexPages.StandardController(thisWeb);
        WebcastPDFController myWebcastPDFController = new WebcastPDFController(stdWeb);
    }
}