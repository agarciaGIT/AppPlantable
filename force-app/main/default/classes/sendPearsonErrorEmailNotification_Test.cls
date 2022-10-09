@isTest
public class sendPearsonErrorEmailNotification_Test {
    static testMethod void PearsonErrorEmailNotificationBatch(){
         Account account = new Account(Name = 'test');
        insert account;
        Contact contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        Opportunity opportunity = new Opportunity(amount = 123,Name = 'Test',company__c = 'Payment', accountId = account.id,stageName = 'Closed Won',Eligible_for_Membership_Extension__c = true,Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity;
        Contract contract  = new Contract(ContractTerm =2,startDate = system.today()- 5,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','SCR Program'),Opportunity__c = opportunity.id,accountId = opportunity.AccountId); 
        insert contract;
        
        Integration_Data__c intdate = new Integration_Data__c();  
        intdate.Version_Number__c = 1;
        intdate.Contract__c = contract.Id;
        intdate.Name ='test';
        intdate.Is_Active__c =true;
        intdate.Garp_Id__c ='01404258';
        intdate.Exam_Type__c = 'SCR';
        intdate.Name = 'Test';
        intdate.Re_Run__c = true;
        intdate.Outbound_Event_Types__c ='CDD';
        intdate.Call_out_Status__c ='Error';
        intdate.Pearson_Vue_Appointment_ID__c = '210378726';
        insert intdate;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new PearsonRTIRequest_test());
        sendPearsonErrorEmailNotificationBatch batch = new sendPearsonErrorEmailNotificationBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        
    }
}