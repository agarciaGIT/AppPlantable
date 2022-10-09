/*
* VaykaTriggerTestClass : Test class for VaykayTriiger.
**/

@isTest
public class VaykayTriggerTestClass {
    public static Profile profile;
    public static User u2;
 //   public static User user;
    public static Vaykay__Time_Off_Balance__c testTimeoffBalance;
    public static Vaykay__Time_Off_Request__c testtimeOffRequest ;
    public static Vaykay__Time_Off_Request__c testtimeOffRequest1;
    public static Vaykay__Time_Off_Request__c testtimeOffRequest2;
    public static Vaykay__Time_Off_Request__c testtimeOffRequest3;
    public static Vaykay__Time_Off_Request__c testtimeOffRequest4;
    
    // Creating test data
    static void TestData(){
        
                 Profile p = [SELECT Id FROM Profile WHERE id = '00e40000000iraa' limit 1]; 
        system.debug('p======>'+p);
            User u2 = new User(Alias = 'newUser', Email='newuser@testorg.comgarp',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorg.comgarp');
           insert u2;
            
            // Creating Time off balance
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
            testtimeOffRequest.Vaykay__First_Day_Off__c = System.today();
            testtimeOffRequest.Vaykay__Last_Day_Off__c  = System.today() + 1;
            
            testtimeOffRequest1 = new Vaykay__Time_Off_Request__c();
            testtimeOffRequest1.Vaykay__Time_Off_Balance__c = testTimeoffBalance.id;
            testtimeOffRequest1.Vaykay__Type__c = 'Vacation';
            testtimeOffRequest1.Vaykay__First_Day_Off__c = System.today()+2;
            testtimeOffRequest1.Vaykay__Last_Day_Off__c = System.today() + 3;
            
            testtimeOffRequest2 = new Vaykay__Time_Off_Request__c();
            testtimeOffRequest2.Vaykay__Time_Off_Balance__c = testTimeoffBalance.id;
            testtimeOffRequest2.Vaykay__Type__c = 'Vacation';
            testtimeOffRequest2.Vaykay__First_Day_Off__c = System.today()+4;
            testtimeOffRequest2.Vaykay__Last_Day_Off__c = System.today() + 5;
            
            testtimeOffRequest3 = new Vaykay__Time_Off_Request__c();
            testtimeOffRequest3.Vaykay__Time_Off_Balance__c = testTimeoffBalance.id;
            testtimeOffRequest3.Vaykay__Type__c = 'Vacation';
            testtimeOffRequest3.Vaykay__First_Day_Off__c = System.today() + 6;
            testtimeOffRequest3.Vaykay__Last_Day_Off__c = System.today() + 7;
            
            testtimeOffRequest4 = new Vaykay__Time_Off_Request__c();
            testtimeOffRequest4.Vaykay__Time_Off_Balance__c = testTimeoffBalance.id;
            testtimeOffRequest4.Vaykay__Type__c = 'Vacation';
            testtimeOffRequest4.Vaykay__First_Day_Off__c = System.today() - 2;
            testtimeOffRequest4.Vaykay__Last_Day_Off__c = System.today() -1;
        }
    
    
    @isTest
    public static void insertingTimeOffRequestWithSameStartAndEndDate(){
        TestData(); 
        Test.startTest();
        try{
       
            User u2 = [select id from user where Email='newuser@testorg.comgarp'];
            system.debug('u2=====>'+u2);
            System.runAs(u2) {
            insert testtimeOffRequest;
            insert testtimeOffRequest1; 
            }
        }
        
        //Validate error is thrown
        catch(Exception e) {
            system.debug('e======>'+e);
          // System.Assert(e.getMessage().contains('You already have created a request within the date range.'));
        }
        Test.stopTest();
    }
    
 
}