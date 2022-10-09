@istest
public class DeleteMedicalData_test {
	@isTest
    public static void DeleteMedicalData(){
        
        Account account = new Account();
        account.Name = 'TEST CO';
        INSERT account;
        
        Contact contact = new Contact();
        contact.Email = 'TEST@TEST.com';
        contact.FirstName = 'TEST';
        contact.LastName = 'TEST';
        contact.AccountId = account.Id;
        contact.First_Name_as_it_Appears_on_ID__c = 'Test';
        contact.Middle_Name_as_it_Appears_on_ID__c = 'T';
        contact.Last_Name_as_it_Appears_on_ID__c = 'Test';
        INSERT contact;
        
        Opportunity opportunity = new Opportunity();
        opportunity.Amount = 700.00;
        opportunity.Name = 'TEST';
        opportunity.StageName = 'Closed';
        opportunity.CloseDate = Date.today();
        Insert opportunity;
        
        Site__c testSiteNonChina = new Site__c();
        testSiteNonChina.Name = 'Canada, Surrey';
        testSiteNonChina.Active__c = true;
        testSiteNonChina.Display_Address__c = 'Canada, Surrey';
        testSiteNonChina.Is_OSTA_Information_Required__c = false;
        INSERT testSiteNonChina;
        
        Exam_Group__c nextExamGroup = new Exam_Group__c();
        nextExamGroup.Name = '21-Nov';
        nextExamGroup.Active__c = false;
        nextExamGroup.Registration_Start_Date__c = Date.today().addDays(20);
        nextExamGroup.Exam_Change_Start_Date_Time__c= DateTime.now().addDays(30);
        INSERT nextExamGroup;
 
        Exam_Group__c examGroup = new Exam_Group__c();
        examGroup.Name = '21-May';
        examGroup.Active__c = true;
        examGroup.Exam_Date__c = Date.today().addDays(-5);
        examGroup.Next_Exam_Group__c = nextExamGroup.id;
        examGroup.Exam_Ticket_Available_Date__c = Date.today().addDays(10);
        examGroup.Exam_Results_Available_Date__c = Date.today().addDays(10);
        examGroup.Exam_Change_Start_Date_Time__c= DateTime.now().addDays(15);
        INSERT examGroup;
        
        Exam__c frmPart2 = new Exam__c();
        frmPart2.Name = 'May 2018 FRM Exam Part II';
        frmPart2.Exam_Group__c = examGroup.Id;
        frmPart2.Exam__c = 'FRM Part 2';
        frmPart2.Exam_Date__c = Date.today().addDays(10);
        INSERT frmPart2;
        
        Exam_Sites__c examSiteNonChinaExamPart2 = new Exam_Sites__c();
        examSiteNonChinaExamPart2.Name = 'May 2018 FRM Exam Part II, Canada, Surrey';
        examSiteNonChinaExamPart2.Site__c = testSiteNonChina.Id;
        examSiteNonChinaExamPart2.Exam__c = frmPart2.Id;
        INSERT examSiteNonChinaExamPart2;
        
        Exam_Attempt__c examRegistration = new Exam_Attempt__c();
        examRegistration.Member__c = contact.Id;
        examRegistration.Opportunity__c = opportunity.Id;
        examRegistration.Exam_Site__c = examSiteNonChinaExamPart2.Id;
        examRegistration.Legacy_Unpaid_Registration_Date__c	= Date.newInstance(Date.Today().year()-2, Date.Today().month(), Date.Today().Day()+10);
        examRegistration.Additional_Accommodations__c = 'Test Data';
        INSERT examRegistration;
        
        Test.startTest();
            DeleteMedicalData obj = new DeleteMedicalData();
            DataBase.executeBatch(obj); 
        Test.stopTest();
        
    }
}