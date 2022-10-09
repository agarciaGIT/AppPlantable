@isTest
public class batchJobActivateStudyContacts_test {

    static Study__c study;
    static Study_Contact__c studyContact;
   
    Static void testData()
     {
        study = new Study__c(Name = 'Study',Disclosure_Protocol__c = 'text');
        insert study;
        
        studyContact = new Study_Contact__c(Name = 'Study Contact', Study_Contact_Email__c='xyz@abc.com', Study__c = study.Id, Status__c = 'Active');
        insert studyContact;
         

     }
     
     static testMethod void UnitTest_1()
     {
         testData();
         test.startTest();

         batchJobActivateStudyContacts  b = new batchJobActivateStudyContacts (NULL, study.id, studyContact.Id);
         database.executeBatch(b);
         
         batchJobActivateStudyContacts  b1 = new batchJobActivateStudyContacts (NULL, study.id, NULL);
         database.executeBatch(b1);

         batchJobActivateStudyContacts  b2 = new batchJobActivateStudyContacts ('all', null, null);
         database.executeBatch(b2);

         test.stopTest();
     }
}