@isTest
public class ContactAuditHistory_test {

  @TestSetup
  static void makeData(){

    Account account = new Account(Name = 'test');
    INSERT account;
    
    Id recordTypeId = RecordTypeHelper.GetRecordTypeId('Contact', 'Member');
    Contact contact = new Contact(
      RecordTypeId = recordTypeId,
      lastname = 'user',
      AccountId = account.id, 
      GARP_Member_ID__c ='123112456',
      Email = 'test.user@garpqa.com',
      KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17)
    ); 
    INSERT contact;
  }

  static testMethod void unitTest_1(){
    
    test.startTest();

    Map<Id, Contact> oldMap = new Map<Id, Contact> ();
    
    List<Contact> contacts = [
      SELECT Id, GARP_Directory_Invite_Opt_Out__c, Email, Email_Subscription_Change_Source__c, FirstName, SCR_Updates__c, LastName, Email_Daily_News__c,  Email_Chapter_Meetings__c, Exam_Prep_Provider_Outreach__c, Email_Information_Exchange__c, Email_Webcasts__c, Email_Events__c, Email_CorporateTeamBuilding__c, Email_InsightAnalysis__c, Email_GARP_Updates__c, Email_Member_Update__c, Email_Career_Center_Job_Board__c, Email_CPE_News__c, HasOptedOutOfEmail, Email_FRM__c, Email_ERP__c, LastModifiedById
      FROM Contact
      LIMIT 1
    ];

    contacts[0].Email = 'test@test.com';
    contacts[0].Email_Subscription_Change_Source__c = 'true';
    contacts[0].FirstName = 'GARP';
    contacts[0].LastName = 'qa';
    contacts[0].Email_Daily_News__c = true;
    contacts[0].Email_The_Week_in_Risk__c = true;
    contacts[0].Email_Chapter_Meetings__c = true;
    contacts[0].Exam_Prep_Provider_Outreach__c = true;
    contacts[0].Email_Webcasts__c = true;
    contacts[0].Email_Events__c = true;
    contacts[0].Email_CorporateTeamBuilding__c = true;
    contacts[0].Email_InsightAnalysis__c = true;
    contacts[0].Email_GARP_Updates__c = true;
    contacts[0].Email_Information_Exchange__c = true;
    contacts[0].Email_Member_Update__c = true;
    contacts[0].Email_Career_Center_Job_Board__c = true;
    contacts[0].Email_CPE_News__c = true;
    contacts[0].HasOptedOutOfEmail = true;
    contacts[0].Email_FRM__c = true;
    contacts[0].Email_ERP__c = true;
    contacts[0].SCR_Updates__c = true;
    contacts[0].GARP_Directory_Invite_Opt_Out__c = true;

    UPDATE contacts[0];
    
    oldMap.put(contacts[0].Id, contacts[0]);
    
    ContactAuditHistory.trackContactFields(contacts , oldMap);
      
    test.stopTest();
      
  }
    
}