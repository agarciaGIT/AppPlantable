@isTest
public class CommunityUtils_test {
    
    static Account account;
    static Contact contact;
    static Contact contact1;
    
    static void testData(){
        account = new Account(Name = 'test');
        insert account;
        Id memRedcordtype1 = RecordTypeHelper.GetRecordTypeId('Contact','Member');
        contact = new Contact(recordtypeId = memRedcordtype1,lastname = 'Test',AccountId = account.id, GARP_Member_ID__c ='123456',email='test4311124324234234234234234@gdsfatest.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;   
        
        Id busRedcordtype1 = RecordTypeHelper.GetRecordTypeId('Contact','Member');
        contact1 = new Contact(recordtypeId = busRedcordtype1,lastname = 'Test',AccountId = account.id, GARP_Member_ID__c ='12345',email='test4311124324234234234234234@gdsfatest.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact1; 
    } 
    
    static testMethod void unitTest_1(){
        testData();
        test.startTest();
        CommunityUtils.createCommunityUser(new contact[]{contact,contact1});
     
        CommunityUtils.generateNickName(contact);
        CommunityUtils.generateNickName(contact1);
        test.stopTest();
        
    }
    
    
}