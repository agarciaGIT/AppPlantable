@isTest
private class CaseOwnerChangeBatch_Test {
    private static testMethod void testCaseOwnerChange() {
        Case cas = new Case();
        cas.Status ='new';
        cas.recordtypeid='012400000005iFW';
        cas.Origin = 'Email';
        insert cas;
        
        cas.Status ='closed';
        cas.ownerid='00540000003QoNM';
       // cas.owner_check__c=true;
        update cas;
        // Setup test data
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.case.com');
        insert u;
        Test.startTest();
        cas.OwnerId= u.Id;
        update cas;
        CaseOwnerChangeBatch batchjob = new CaseOwnerChangeBatch ();
        Database.executeBatch(batchjob );
        Test.stopTest();
    }
}