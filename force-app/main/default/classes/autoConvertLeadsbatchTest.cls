@istest
public class autoConvertLeadsbatchTest {
    public static testmethod void testautoConvertLeadsbatch(){
       account acc = new account(Name ='test');
       insert acc;
        Default_Record_References__c dr = new Default_Record_References__c(Record_Reference_ID__c=acc.id,name ='UNMATCHED-BUSINESS-ACCOUNT', sObjectType__c='account');
        insert dr;
        Lead ld = new Lead();
        ld.LastName = 'Test Lead Data';
        ld.Company = 'Test Lead Company';
        ld.FirstName = 'Test First Name';
        ld.Status = 'Open - Not Contacted'; 
        ld.Email = 'testLead@test.com'; 
        insert ld;
        Form__c fromobj = new Form__c();
        fromobj.Name = 'Test Form Data';
        fromobj.Subscriptions__c = 'A';
        
        insert fromobj;
        
        Form_Data__c fd = new Form_Data__c();
        fd.Form__c = fromobj.id; 
        fd.Lead__c = ld.id; 
        fd.Subscription__c = 'Yes';
        fd.Last_Name__c = 'TestLname';
        fd.First_Name__c = 'TestLname';
        fd.Marketing_Cloud_Conversion__c = true;
        insert fd;
        Test.StartTest();
        String CRON_EXP = '0 0 0 15 3 ? *';
        String jobId = System.schedule('formDataScheduledBatchableTest',  CRON_EXP, new ScheduleAutoConvertLead());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        
        Test.stopTest();
    }
}