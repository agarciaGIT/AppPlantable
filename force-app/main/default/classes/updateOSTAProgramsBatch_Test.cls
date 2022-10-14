@isTest
public class updateOSTAProgramsBatch_Test {
	Static Account acc;
    Static contract c;
    static Exam_Group__c objExamGrp;
    static Exam_Attempt__c attempt;
    static Exam__c exam;
    static Exam_Sites__c exmSite;
    static Site__c site;
    static Exam_Administration__c examAdmin;
    static Exam_Part__c examPart;
    static void testdata()
    {
        	
        string ostaRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('OSTA_Program').getRecordTypeId();	
        acc = new Account(name = 'Test Account1', CurrencyIsoCode = 'USD', Calculated_Expire_Date__c = system.today(), Last_Contract_Exp_Calc__c = system.today());
        insert acc;
        
        Account acct = new Account(name = 'Test Account1', Profile_ID__c = 'RP0000041014');
        insert acct;
        
        Contact cont = new contact(lastname = 'Test Contact1', AccountID = acct.ID, email = 'testcontact1@contact.com', KPI_Member__c = True);
        insert cont;
        
        ChargentBase__Gateway__c chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        opportunity opp = new Opportunity(ChargentSFA__Gateway__c = chrgGtway.id, amount = 123,Name = 'Test', CurrencyIsoCode = 'USD', Eligible_for_Membership_Extension__c = false,Company__c = 'GARP', accountId = acct.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15,Pay_By_Wire_Check__c=false);        
        insert opp;
        
        c = new contract(Accountid = acct.id,Status = 'Draft',CurrencyIsoCode = 'USD',All_Requirements_Completed__c = False,recordTypeID = ostaRecordTypeId);
        insert c;
        c.Status = 'Activated';
        update c;
        
        site = new Site__c(name = 'test',Display_Address__c = 'test',active__c = true,Non_selectable__c = false);
        insert site; 
        
        List<Exam_Group__c> examGrpList = new List<Exam_Group__c>();
        objExamGrp = new Exam_Group__c();
        objExamGrp.Active__c = true; 
        objExamGrp.Exam_Date__c = system.today().addDays(13);
        Date dt1 = system.today();
        objExamGrp.Registration_Start_Date__c = dt1.addDays(4);
        objExamGrp.Last_Date_For_Early_Registration__c = system.today().addDays(1);
        objExamGrp.Last_Date_For_Standard_Registration__c = system.today().addDays(9) ;
        objExamGrp.Last_Date_For_Late_Registration__c = system.today().addDays(10) ; 
        examGrpList.add(objExamGrp);
        
        insert examGrpList;
        
        List<Exam__c> examList = new List<Exam__c>();
        exam = new Exam__c();
        exam.Exam_Group__c = objExamGrp.id;
        exam.Exam_Date__c = system.today() + 30;
        exam.exam__c = 'FRM Part 1';
        examList.add(exam);
        insert examList;
        
        List<Exam_Administration__c> examAdminList = new List<Exam_Administration__c>();
        examAdmin = new Exam_Administration__c();
        examAdmin.Exam_Group__c = objExamGrp.id;
        examAdmin.Exam_Date__c = system.today();
        examAdminList.add(examAdmin);
        insert examAdminList;
        
        examPart = new Exam_Part__c();
        examPart.Exam__c = exam.id;
        examPart.Exam_Administration__c = examAdmin.id;
        examPart.Exam_Date__c = system.today();
        examPart.Delivery_Method__c = 'CBT';
        insert examPart;
        
        List<Exam_Sites__c> siteList = new List<Exam_Sites__c>();
        exmSite = new Exam_Sites__c(Site__c = site.id,exam__c = exam.id);
        siteList.add(exmSite);
        insert siteList;
        
        List<Exam_Attempt__c> examAttemptList = new List<Exam_Attempt__c>();
        attempt = new Exam_Attempt__c(Opportunity__c = opp.id,Exam_Administration__c = examAdmin.Id,Exam_Part__c = examPart.Id, Exam_Site__c = exmSite.id,Member__c = cont.id,cancelled__c = false);
        examAttemptList.add(attempt);
        insert examAttemptList;
	}
    
    static testMethod void dateUpload() {
		testData();
        test.startTest();
        Id batchInstanceId = Database.executeBatch(new updateOSTAProgramsBatch(examAdmin.id,'2020-12-20',true,false),1);
        test.stopTest();
    }
    
    static testMethod void registrationUpdate() {
		testData();
        test.startTest();
        Id batchInstanceId = Database.executeBatch(new updateOSTAProgramsBatch(examAdmin.id,null,false,true),1);
        test.stopTest();
    }
}