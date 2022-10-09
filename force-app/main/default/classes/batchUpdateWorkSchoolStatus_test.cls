@isTest
public class batchUpdateWorkSchoolStatus_test {

    Static Contact cont;
    Static Contact cont1;

    
    static void testData()
     {
         
         cont = new Contact(FirstName='Working',LastName='Working',do_not_fire__c=true,Currently_Working__c=true,Email='Working@garp.com',RecordTypeID='01240000000UdO3');
         insert cont;
         
         cont1 = new Contact(FirstName='School',LastName='School',do_not_fire__c=true,Currently_in_School__c=true,Email='School@garp.com',RecordTypeID='01240000000UdO3');
		insert cont1;
         
     }
     
     static testMethod void UnitTest_1()
     {
         testData();
         test.startTest();
         batchUpdateWorkSchoolStatus b = new batchUpdateWorkSchoolStatus(NULL);
         database.executeBatch(b);

         batchUpdateWorkSchoolStatus b1 = new batchUpdateWorkSchoolStatus(cont.Id);
         database.executeBatch(b1);

         test.stopTest();
     }
}