@isTest
public class InvalidRequest_test {

    @isTest
    public static void InvalidRequest(){
        
       Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' limit 1]; 
       
       User u2 = new User(Alias = 'newUser', Email='newuser@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId =p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorg.com.garp');
     insert u2;
     
       Vaykay__Time_Off_Balance__c balance = new Vaykay__Time_Off_Balance__c();
       
       balance.name ='test';
       balance.Vaykay__Employee_Name__c =u2.id;
       balance.Vaykay__Balance_Start_Date__c = system.today();
       balance.Vaykay__Balance_End_Date__c   = system.today();
       balance.Vaykay__Vacation_Days_Allotted__c =3.00;
       balance.Vaykay__Sick_Days_Allotted__c =5.00;
       balance.ownerid=u2.id;
       
       insert balance;
       
      Vaykay__Time_Off_Request__c timeoff = new Vaykay__Time_Off_Request__c();
        
        timeoff.Vaykay__Time_Off_Balance__c = balance.id;
        timeoff.Vaykay__Type__c = 'Vacation';
        timeoff.Vaykay__First_Day_Off__c = system.today();
        timeoff.Vaykay__Last_Day_Off__c = system.today();
        
        
        INSERT timeoff;
        
      
        
    }
    
}