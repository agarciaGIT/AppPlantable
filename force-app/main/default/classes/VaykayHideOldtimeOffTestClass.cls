@isTest
public class VaykayHideOldtimeOffTestClass {
    public static Profile profile;
    public static User u2;
    public static Vaykay__Time_Off_Balance__c testTimeoffBalance;
    public static Vaykay__Time_Off_Request__c testtimeOffRequest ;
    
    static void TestData() { 
        
         Profile p = [SELECT Id FROM Profile WHERE id = '00e40000000iraa' limit 1]; 
        system.debug('p======>'+p);
            User u2 = new User(Alias = 'newUser', Email='newuser@testorg.comgarp',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorg.comgarp');
           insert u2;
            
            testTimeoffBalance = new Vaykay__Time_Off_Balance__c (
                Name = u2.firstname,
                Vaykay__Employee_Name__c = u2.id,
                Vaykay__Time_Off_Units__c  = 'days' ,
                Vaykay__Balance_Start_Date__c = System.today() - 10 ,
                Vaykay__Balance_End_Date__c = System.today() + 10,
                Vaykay__Vacation_Days_Allotted__c = 15,
                Vaykay__Sick_Days_Allotted__c = 6
            );
            insert testTimeoffBalance;
        
        
        // creating time off requests
            testtimeOffRequest = new Vaykay__Time_Off_Request__c();
            testtimeOffRequest.Vaykay__Time_Off_Balance__c = testTimeoffBalance.id;
            testtimeOffRequest.Vaykay__Type__c = 'Vacation';
            testtimeOffRequest.Vaykay__First_Day_Off__c = Date.valueOf(Date.Today());
            testtimeOffRequest.Vaykay__Last_Day_Off__c  = Date.valueOf(Date.Today()) + 1;
        
        insert testtimeOffRequest;
    }
    
    @isTest
    public static void UpdateVaykayOwner() {
        TestData(); 
        Test.startTest();
        VaykayHideOldTimeOff.UpdateVaykayOwner();
        Test.stopTest();
    }
}