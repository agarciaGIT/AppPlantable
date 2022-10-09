@isTest
public class ATAIntegrationDataCheckBatch_Test {
	@isTest
    static void testBatch(){
        Account account = new Account(Name = 'test');
        insert account;
        Contact contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        Site__c site = new Site__c(name = 'test',Display_Address__c = 'test',active__c = true,Non_selectable__c = false);
        insert site; 
        
        Exam_Group__c objExamGrp = new Exam_Group__c();
        objExamGrp.Active__c = true;
        Date dt1 = system.today();
        objExamGrp.Registration_Start_Date__c = dt1.addDays(4);
        objExamGrp.Last_Date_For_Early_Registration__c = system.today()+1;
        objExamGrp.Last_Date_For_Standard_Registration__c = system.today() +9 ;
        objExamGrp.Last_Date_For_Late_Registration__c = system.today() +10 ;    
        insert objExamGrp;
        
        Exam__c exam = new Exam__c();
        exam.Exam_Group__c = objExamGrp.id;
        exam.Exam_Date__c = system.today() + 30;
        exam.exam__c = 'FRM Part 1'; 
        insert exam;
        
        Exam_Sites__c exmSite = new Exam_Sites__c(Site__c = site.id,exam__c = exam.id);
        insert exmSite;
        
        Opportunity opportunity = new Opportunity(amount = 123,Name = 'Test',company__c = 'Payment', accountId = account.id,stageName = 'Closed Won',Eligible_for_Membership_Extension__c = true,Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity;
        
        Contract contract  = new Contract(ContractTerm =2,startDate = system.today()- 5,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','SCR Program'),Opportunity__c = opportunity.id,accountId = opportunity.AccountId,Pearson_Phone_No__c = '1234567891',Pearson_Member_First_Name__c = 'Test',Pearson_Member_Last_Name__c = 'test'); 
        insert contract;
        
        Exam_Attempt__c attempt = new Exam_Attempt__c(Opportunity__c = opportunity.id, Exam_Site__c = exmSite.id,Member__c = contact.id,cancelled__c = false,Candidate_Commitment__c = contract.id);
        insert attempt; 
        
        String ataRecordTypeId = Schema.SObjectType.Integration_Data__c.getRecordTypeInfosByDeveloperName().get('ATA').getRecordTypeId();
        Integration_Data__c intdata = new Integration_Data__c();
        intdata.Contract__c = contract.Id;
        intdata.Exam_Registrations__c = attempt.id;
        intdata.Version_Number__c = 1;
        intdata.Name ='test';
        intdata.Call_out_Type__c = 'Out-bound';
        intdata.ATA_Name_as_it_appears_on_ID__c = 'Test User';
        intdata.ATA_Cert_type__c = '1';
        intdata.ATA_Cert_id__c = 'Test';
        intdata.RecordTypeId = ataRecordTypeId;
        insert intdata;
        
        test.startTest();
        ATAIntegrationDataCheck_Batch batchable = new ATAIntegrationDataCheck_Batch();
        database.executeBatch(batchable);
        test.stopTest();
    }
}