@isTest
public class updateExamSitesForFailedExamsBatch_Test {
@testSetup
    public static void testSetup(){
        String StrDefered = 'Approved';       
        String oppstatus = 'closed';
        
        SiteMappingCodes__c cs = new SiteMappingCodes__c();
        cs.Name = 'China';
        cs.Old_Site_Code__c = '100';
        cs.New_Site_Code__c = '999';
     	insert cs;
        
        Account Acc = new Account(Name = 'test');
        insert acc;
        
        Opportunity opp = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = acc.id,stageName = oppstatus,Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opp;
        
        Contact contact = new Contact(lastname = 'Test',AccountId = acc.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
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
        Exam__c examFRM1 = new Exam__c();
        examFRM1.Exam_Group__c = objExamGrp.id;
        examFRM1.Exam_Date__c = system.today().addDays(30);
        examFRM1.exam__c = 'FRM Part 1';
        examList.add(examFRM1);
        
        Exam__c examFRM2 = new Exam__c();
        examFRM2.Exam_Group__c = objExamGrp.id;
        examFRM2.Exam_Date__c = system.today().addDays(30);
        examFRM2.exam__c = 'FRM Part 2'; 
        examList.add(examFRM2);
        
        Exam__c examERP1 = new Exam__c();
        examERP1.Exam_Group__c = objExamGrp.id;
        examERP1.Exam_Date__c = system.today().addDays(30);
        examERP1.exam__c = 'ERP Exam Part I'; 
        examList.add(examERP1);
        
        Exam__c examERP2 = new Exam__c();
        examERP2.Exam_Group__c = objExamGrp.id;
        examERP2.Exam_Date__c = system.today().addDays(30);
        examERP2.exam__c = 'ERP Exam Part II'; 
        examList.add(examERP2);
        insert examList;
        
        Exam_Administration__c examAdmin = new Exam_Administration__c();
        examAdmin.Exam_Group__c = objExamGrp.id;
        examAdmin.Exam_Date__c = system.today().addDays(30);
        insert examAdmin;
        
        List<Exam_Part__c> examPartList = new List<Exam_Part__c>();
        Exam_Part__c examPart = new Exam_Part__c();
        examPart.Exam__c = examFRM1.id;
        examPart.Exam_Administration__c = examAdmin.id;
        examPart.Exam_Date__c = system.today().adddays(30);
        examPart.Delivery_Method__c = 'CBT';
        examPartList.add(examPart);
		
        Exam_Part__c examPart2 = new Exam_Part__c();
        examPart2.Exam__c = examFRM2.id;
        examPart2.Exam_Administration__c = examAdmin.id;
        examPart2.Exam_Date__c = system.today().adddays(30);
        examPart2.Delivery_Method__c = 'CBT';
        examPartList.add(examPart2);
        
        Exam_Part__c examPart4 = new Exam_Part__c();
        examPart4.Exam__c = examERP1.id;
        examPart4.Exam_Administration__c = examAdmin.id;
        examPart4.Exam_Date__c = system.today().adddays(30);
        examPart4.Delivery_Method__c = 'CBT';
        examPartList.add(examPart4);
        
        Exam_Part__c examPart5 = new Exam_Part__c();
        examPart5.Exam__c = examERP2.id;
        examPart5.Exam_Administration__c = examAdmin.id;
        examPart5.Exam_Date__c = system.today().adddays(30);
        examPart5.Delivery_Method__c = 'CBT';
        examPartList.add(examPart5);
        insert examPartList;
        
        List<Exam_Sites__c> siteList = new List<Exam_Sites__c>();
        Exam_Sites__c exmSite = new Exam_Sites__c(Site__c = site.id,exam__c = examFRM1.id);
        siteList.add(exmSite);
        Exam_Sites__c exmSite2 = new Exam_Sites__c(Site__c = site.id,exam__c = examFRM2.id);
        siteList.add(exmSite2);
        Exam_Sites__c exmSite4 = new Exam_Sites__c(Site__c = site.id,exam__c = examERP1.id);
        siteList.add(exmSite4);
        Exam_Sites__c exmSite5 = new Exam_Sites__c(Site__c = site.id,exam__c = examERP2.id);
        siteList.add(exmSite5);
        insert siteList;
        
        List<Exam_Attempt__c> examAttemptList = new List<Exam_Attempt__c>();
        Exam_Attempt__c attempt = new Exam_Attempt__c(Defered__c = StrDefered,Opportunity__c = opp.id,Exam_Site__c = exmSite.id,Member__c = contact.id,cancelled__c = false,Result__c = 'Fail' );
        examAttemptList.add(attempt);
        
        Exam_Attempt__c attempt2 = new Exam_Attempt__c(Defered__c = StrDefered,Opportunity__c = opp.id,Exam_Site__c = exmSite2.id,Member__c = contact.id,cancelled__c = false );
        examAttemptList.add(attempt2);
        
        Exam_Attempt__c attempt3 = new Exam_Attempt__c(Defered__c = StrDefered,Opportunity__c = opp.id,Exam_Administration__c = examAdmin.Id,Exam_Part__c = examPart4.Id, Exam_Site__c = exmSite4.id,Member__c = contact.id,cancelled__c = false,Result__c = 'Fail');
        examAttemptList.add(attempt3);
        
        Exam_Attempt__c attempt4 = new Exam_Attempt__c(Defered__c = StrDefered,Opportunity__c = opp.id,Exam_Administration__c = examAdmin.Id,Exam_Part__c = examPart5.Id, Exam_Site__c = exmSite5.id,Member__c = contact.id,cancelled__c = false );
        examAttemptList.add(attempt4);
        insert examAttemptList;
    }
    
    @isTest
    public static void testFRM1(){
        test.startTest();
        Id batchInstanceId = Database.executeBatch(new updateExamSitesForFailedExamsBatch('FRM Part 1',false),1);
        
        test.stopTest();
    }
    
    @isTest
    public static void testERP1(){
        test.startTest();
        
        Exam_Attempt__c ea = [Select Id,Exam_Site__c from Exam_Attempt__c where Exam_Site__r.Exam__r.Exam__c = 'ERP Exam Part I' AND Result__c = 'Fail'];
        Id batchInstanceId = Database.executeBatch(new updateExamSitesForFailedExamsBatch('ERP Exam Part I',true,ea.id),1);
        
        test.stopTest();
    }
}