@isTest(SeeAllData=false)
public class TeckstTests {
  @testSetup static void setup() {
    Case cse = new Case();
    cse.Subject = 'Test Case';
    cse.SuppliedName = 'Teckst';
    cse.SuppliedPhone = '+13333333333';

    Contact contact = new Contact();
    contact.FirstName = 'Test';
    contact.LastName = 'User';
    contact.MobilePhone = '(123) 456-7891';
    insert(contact);
    cse.ContactId = contact.Id;

    insert(cse);

    Teckst_Settings__c setting = new Teckst_Settings__c();
    setting.Name = 'Teckst Settings';
    setting.Teckst_API_Token__c = 'token';
    setting.Teckst_Client_ID__c = 'teckst_client_id';
    setting.Teckst_Default_Number__c = '19082900890';
    insert setting;
  }

  public class RequestSucceedsMock implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
      // Create a fake response
      HttpResponse res = new HttpResponse();
      res.setHeader('Content-Type', 'application/json');
      res.setBody('{"mediaUrl":"[\'https://testurl.com\']"}');
      res.setStatusCode(200);
      return res;
    }
  }

  public static testMethod void testControllerCreation() {
    Case cse;
    cse = (Case)[SELECT Subject, Id, OwnerId, Status, CaseNumber, Contact.Name, Contact.Id, Contact.MobilePhone, Contact.FirstName, Contact.LastName, Is_Teckst_Case__c, SuppliedName, SuppliedPhone FROM Case WHERE Subject='Test Case' LIMIT 1];

    Test.startTest();
    ApexPages.StandardController stdCase = new ApexPages.StandardController(cse);
    TeckstController newTeckstController = new TeckstController(stdCase);
    Test.stopTest();
    System.assertEquals('(123) 456-7891', newTeckstController.ContactPhone);
  }

  public static testMethod void testChangeCaseStatus() {
    Case cse;
    cse = (Case)[SELECT Id, Status, Contact.Name, Contact.Id, Contact.MobilePhone, Contact.FirstName, Contact.LastName FROM Case WHERE Subject='Test Case' LIMIT 1];


    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new RequestSucceedsMock());
    Test.stopTest();
    TeckstController.changeCaseStatus(cse.Id, 'Closed');
  }

  public static testMethod void testCaseClosedTrigger() {
    Case cse;
    cse = (Case)[SELECT Id, Status, Contact.Name, Contact.Id, Contact.MobilePhone, Contact.FirstName, Contact.LastName FROM Case WHERE Subject='Test Case' LIMIT 1];

    //after update
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new RequestSucceedsMock());
    cse.Origin = 'Teckst';
    cse.Status = 'Closed';
    update(cse);
    System.assertEquals('Closed', cse.Status);

    //after delete
    Test.setMock(HttpCalloutMock.class, new RequestSucceedsMock());
    cse.Origin = 'Teckst';
    cse.Status = 'Closed';
    delete cse;
    Test.stopTest();
    System.assertEquals('Closed', cse.Status);
  }

  public static testMethod void testSendTeckstMessage() {
    TeckstController.TeckstMessageSender tms = new TeckstController.TeckstMessageSender();
    tms = tms.toTeckstMessageSender();
    List<TeckstController.TeckstMessageSender> ltms = new List<TeckstController.TeckstMessageSender>();

    Case cse;
    cse = (Case)[SELECT Id, Status, Contact.Name, Contact.Id, Contact.MobilePhone, Contact.FirstName, Contact.LastName FROM Case WHERE Subject='Test Case' LIMIT 1];
    tms.PBContactId = cse.Contact.Id;

    tms.PBMessageBody = 'Hello, how are you?';
    ltms.add(tms);
    Test.setMock(HttpCalloutMock.class, new RequestSucceedsMock());
    TeckstController.sendTeckstMessage(ltms);
    System.assertEquals('Hello, how are you?', tms.PBMessageBody);
  }

  public class emptyObject {
  }
}