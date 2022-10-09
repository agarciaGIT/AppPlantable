@isTest

public class expireScholarship_test{

    static Account acc;
    static Contact contact;
    static Exam_Group__c objExamGrp;
    static Exam_Group__c objExamGrp1;
    static Scholarship_Application__c sc;
    
    static void testData(){
        
        
        objExamGrp1 = new Exam_Group__c();
        
        Date dt2 = system.today();
        objExamGrp1.Registration_Start_Date__c = dt2.addDays(4);
        objExamGrp1.Last_Date_For_Early_Registration__c = system.today()-10;
        objExamGrp1.Last_Date_For_Standard_Registration__c = system.today() -9 ;
        objExamGrp1.Last_Date_For_Late_Registration__c = system.today() -8 ;    
        insert objExamGrp1;
        
        
        objExamGrp = new Exam_Group__c();
        objExamGrp.Active__c = true;
        Date dt1 = system.today();
        objExamGrp.Registration_Start_Date__c = dt1.addDays(4);
        objExamGrp.Last_Date_For_Early_Registration__c = system.today()+1;
        objExamGrp.Last_Date_For_Standard_Registration__c = system.today() +9 ;
        objExamGrp.Last_Date_For_Late_Registration__c = system.today() +10 ;   
         objExamGrp.Next_Exam_Group__c =  objExamGrp1.id;
        insert objExamGrp;
        
       
        
        Acc = new Account(Name = 'test');
        insert acc;
        
        contact = new Contact(lastname = 'Test',AccountId = acc.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        SC = new Scholarship_Application__c(Applicant__c =contact.id, Exam_Group__c =objExamGrp.id);
        
        insert sc;
         
      
        
      
    
        
    }
    
    static testMethod void unitTest_1(){
    
        testData();
        test.startTest();
        expireScholarship es = new expireScholarship();
        Database.executebatch(es,1);
        test.stopTest();
    }


}