@isTest
public class UpdateUsersFederationIdBatch_Test {
    static testmethod void testUserUpdate(){
        Id memberRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Member').getRecordTypeId();
        Account Acc = new Account(Name = 'test');
        insert acc;
        
        Contact contact = new Contact(RecordTypeId = memberRecordTypeId,do_not_fire__c = true,KPI_ERP_Certified__c = true,KPI_FRM_Certified__c = true,GARP_Directory_Opt_In__c = true,lastname = 'Test',AccountId = acc.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;

		Profile profile = [SELECT Id FROM Profile WHERE id = '00e400000017dA8' limit 1]; 
        
        User user1 = new User(Alias = 'newUser', Email='test@test.com', contactId = contact.id,EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profile.Id, TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorg.com');
        insert user1;
        
        UpdateUsersFederationIdBatch batch = new UpdateUsersFederationIdBatch();
        batch.query = 'Select Id,FederationIdentifier,Contact.GARP_Member_ID__c,Contact.RecordTypeId from User where id = \''+user1.id+'\'';
        test.startTest();
        Id batchInstanceId = Database.executeBatch(batch,50);
        test.stopTest();
    }
}