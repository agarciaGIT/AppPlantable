@isTest
public class batchDemographicsUpdate_test {
    
    public static testmethod void test() {
        
        Account acc = new Account(
            Name = 'TestAccount',
            RecordTypeId = RecordTypeHelper.GetRecordTypeId('Account','Individual'),
            CurrencyIsoCode  = 'USD'
        );
        insert acc;
        
		Contact cont = new Contact(FirstName='Cont', LastName='Last', Email='a@a.com',
                                   Corporate_Title__c='Entry Level',
                                   Job_Function__c='Consulting',
                                   How_Did_You_Hear_About_Us__c='advertisement',
                                   Area_of_Concentration__c='Education Services'
                                  );
        insert cont;
        
        Test.startTest();
        batchDemographicsUpdate c = new batchDemographicsUpdate('convert',null);
        Database.executeBatch(c);        
        
        Test.stopTest();
        
    }

}