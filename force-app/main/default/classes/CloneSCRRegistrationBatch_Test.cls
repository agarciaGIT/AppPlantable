@isTest
public class CloneSCRRegistrationBatch_Test {
	@testSetup
    public static void testSetup(){        
        Account Acc = new Account(Name = 'test');
        insert acc;
        
        Opportunity opp = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = acc.id,stageName = 'Closed',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opp;
        
        Contact contact = new Contact(lastname = 'Test',AccountId = acc.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        Contract c = new contract(Accountid = acc.id,Status = 'Draft',CurrencyIsoCode = 'USD',All_Requirements_Completed__c = False);
        insert c;
        c.Status = 'Activated';
        update c;
        
       	Site__c site = new Site__c(name = 'test',Display_Address__c = 'test',active__c = true,Non_selectable__c = false);
        insert site;
        
        Exam_Group__c objExamGrp = new Exam_Group__c();
        objExamGrp.Active__c = true; 
        objExamGrp.Exam_Date__c = system.today().addDays(30);
        objExamGrp.Registration_Start_Date__c = system.today().addDays(4);
        objExamGrp.Last_Date_For_Early_Registration__c = system.today().addDays(1);
        objExamGrp.Last_Date_For_Standard_Registration__c = system.today().addDays(9) ;
        objExamGrp.Last_Date_For_Late_Registration__c = system.today().addDays(10) ;
        insert objExamGrp;
        
        List<Exam__c> examList = new List<Exam__c>();
        Exam__c examSCR = new Exam__c();
        examSCR.Exam_Group__c = objExamGrp.id;
        examSCR.Exam_Date__c = system.today().addDays(30);
        examSCR.exam__c = 'SCR'; 
        examList.add(examSCR);
        insert examList;
        
        Exam_Administration__c examAdmin = new Exam_Administration__c();
        examAdmin.Exam_Group__c = objExamGrp.id;
        examAdmin.Exam_Date__c = system.today().addDays(30);
        insert examAdmin;
        
        List<Exam_Part__c> examPartList = new List<Exam_Part__c>();
        
        Exam_Part__c examPart = new Exam_Part__c();
        examPart.Exam__c = examSCR.id;
        examPart.Exam_Administration__c = examAdmin.id;
        examPart.Exam_Date__c = system.today().adddays(30);
        examPart.Delivery_Method__c = 'CBT';
        examPartList.add(examPart);
        insert examPartList;
        
        List<Exam_Sites__c> siteList = new List<Exam_Sites__c>();
        Exam_Sites__c exmSite = new Exam_Sites__c(Name = 'Test',Site__c = site.id,exam__c = examSCR.id,Exam_Part__c = examPart.id);
        siteList.add(exmSite);
        insert siteList;
        
        List<Exam_Attempt__c> examAttemptList = new List<Exam_Attempt__c>();
        Exam_Attempt__c attempt = new Exam_Attempt__c(Defered__c = 'Pending',Candidate_Commitment__c = c.id,Opportunity__c = opp.id,Exam_Administration__c = examAdmin.Id, Exam_Site__c = exmSite.id,Member__c = contact.id,cancelled__c = false );
        examAttemptList.add(attempt);
        insert examAttemptList;
    }
    
    @isTest
    public static void testSCRClone(){
        test.startTest();
        Id batchInstanceId = Database.executeBatch(new CloneSCRRegistrationBatch(),1);
        
        test.stopTest();
    }
}