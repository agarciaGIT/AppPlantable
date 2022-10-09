@isTest
public class cloneExamAdminPageContrlr_Test {
	static Exam_Group__c objExamGrp;
    static Exam__c exam;
    static Exam_Administration__c examAdmin;
        
    static void testData(){ 

        objExamGrp = new Exam_Group__c();
        objExamGrp.Active__c = true; 
        objExamGrp.Exam_Date__c = system.today().addDays(13);
        Date dt1 = system.today();
        objExamGrp.Registration_Start_Date__c = dt1.addDays(4);
        objExamGrp.Last_Date_For_Early_Registration__c = system.today().addDays(1);
        objExamGrp.Last_Date_For_Standard_Registration__c = system.today().addDays(9) ;
        objExamGrp.Last_Date_For_Late_Registration__c = system.today().addDays(10) ; 
        insert objExamGrp;
        
        exam = new Exam__c();
        exam.Exam_Group__c = objExamGrp.id;
        exam.Exam_Date__c = system.today() + 30;
        exam.exam__c = 'FRM Part 1'; 
        insert exam;
        
        examAdmin = new Exam_Administration__c();
        examAdmin.Exam_Group__c = objExamGrp.id;
        examAdmin.Exam_Date__c = system.today();
        insert examAdmin;
    }
    
    static testMethod void testPageRedirect(){
        testData();
        test.startTest();
		PageReference pageRef = Page.cloneExamAdminPage;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('newRecordId',examAdmin.id);
        ApexPages.StandardController stdcontroller = new ApexPages.StandardController(examAdmin);
        cloneExamAdminPageContrlr cntrlr = new cloneExamAdminPageContrlr(stdcontroller);
        cntrlr.redirectToExamAdmin();
        test.stopTest();
    }
}