@isTest
public class EPPListDownload_Test {
    
    static Opportunity opp; 
    static Exam_Attempt__c examattempt;
    static Exam_Attempt__c examattempt1;
    static Exam_Attempt__c examattempt2;
    static Site__c testsite;
    static Exam_Sites__c examSite;
    static Exam__c exam;
    static Exam__c exam1;
    static Exam__c exam2;
    static EPP_Account__c EPPAccount;
    static EPP_Account__c EPPAccount1;
    static user user1;
    static Exam_Group__c objExamGrp;
     
    static testMethod void Unit_test(){
        
           
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Customer Community'];
        
        Account a2 = new Account(name = 'Test Account2');
        insert a2;
        
        Contact c1 = new contact(do_not_fire__c = true, GARP_Member_ID__c = '12345', lastname = 'Test Contact1', MailingCountry ='Cuba', AccountID = a2.ID, email = 'testcontact1@contact.com', KPI_Member__c = True, Exam_Prep_Provider_Outreach__c = true);
        insert c1;
        system.debug('###: ' + c1);
                
        User user1 = new user(TimeZoneSidKey = 'America/Denver' ,LocaleSidKey = 'en_US', ProfileId = p.Id, ContactId = c1.Id, Username = 'testcontact@garp.com', CommunityNickname = 'GARP SYSTEM',Alias = 'GSystem',CurrencyIsoCode = 'USD', EmailEncodingKey = 'ISO-8859-1',LanguageLocaleKey = 'en_US',LastName = 'System', Email = 'testcontact@garp.com');
        insert user1;
        System.debug(user1);
        
        Account acc = new Account(name = 'Test Account');
        insert acc;
        
        EPPAccount1 = new EPP_Account__c(Name = 'Test', Primary_EPP_Contact__c = c1.Id, EPP_FRM__c = true, EPP_ERP__c = true, EPP_Region_s__c = 'Americas', EPP_Registration_Status__c = 'Approved', Account__c = Acc.Id); 
        Insert EPPAccount1;
        system.debug('###: ' + EPPAccount1);
        
        c1 = [select Exam_Prep_Provider_Outreach__c, id, Region__c, EPP_Data_Manager__c, EPP_Data_Manager_Count__c from contact where Id = :c1.id];
        
        system.debug('###: ' + c1);
        
        opp = new Opportunity(amount = 123,Name = 'Test', company__c = 'Payment', accountId = acc.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15, LEGACY_Purchase_Date__c  = system.today());        
        insert opp;
        
        objExamGrp = new Exam_Group__c();
        objExamGrp.Active__c = true;
        Date dt1 = system.today();
        objExamGrp.Registration_Start_Date__c = dt1.addDays(4);
        objExamGrp.Last_Date_For_Early_Registration__c = system.today()+1;
        objExamGrp.Last_Date_For_Standard_Registration__c = system.today() +9 ;
        objExamGrp.Last_Date_For_Late_Registration__c = system.today() +10 ;    
        insert objExamGrp;
        
        exam = new Exam__c(Name='May 2015 ERP Exam', Exam__c='ERP', Exam_Code__c ='1111:2015~5');
        exam.Exam_Group__c = objExamGrp.id;
        exam.Exam_Date__c = system.today() + 13;
        insert exam;
        
        exam1 = new Exam__c(Name='May 2015 FRM Exam', Exam__c='FRM Part 1', Exam_Code__c ='1111:2015~5');
        exam1.Exam_Date__c = system.today() + 13;
        insert exam1;
        
        exam2 = new Exam__c(Name='May 2015 FRM Exam', Exam__c='FRM Part 2', Exam_Code__c ='1111:2015~5');
        exam2.Exam_Date__c = system.today() + 13;
        insert exam2;
        
        testsite = new Site__c(Name='USA, MA, BOSTON',Site_Code__c ='1800-11', Display_Address__c  ='Westborough, Boston , MA, USA');
        insert testsite;
        
        examSite = new Exam_Sites__c(Name='May 2015 ERP Exam USA, MA, Boston', CurrencyIsoCode = 'USD', Site__c=testsite.id);
        examSite.Exam__c = exam.id;
        insert examSite;
        
        examattempt = new Exam_Attempt__c(Name='John Doe', Member__c = c1.id, Cancelled__c = False, Defered__c = 'pending');
        examattempt.Exam_Site__c = examSite.id;
        insert examattempt;
        
        examattempt = [select reg_Status__c, EPP_Outreach__c, Cancelled__c, Member__r.Region__c, RPT_Exam_FRM_ERP__c,Exam_Site__r.Exam__r.Exam_Group__r.Active__c 
                       from exam_Attempt__c where id = :examattempt.id];
        
        system.debug(examattempt.member__r.Region__c);
        system.debug('$$$$: ' + examattempt);
        
        examattempt = [select EPP_Outreach__c, id from Exam_Attempt__c where Member__C = :c1.id and id = :examattempt.Id];
        
        examattempt1 = new Exam_Attempt__c(Name='John Doe', Seat_No__c='999', Member__c = c1.id, Cancelled__c = false);
        examattempt1.Exam_Site__c = examSite.id;
        insert examattempt1;
        
        examattempt2 = new Exam_Attempt__c(Name='John Doe', Seat_No__c='999', Member__c = c1.id, Cancelled__c = false);
        examattempt2.Exam_Site__c = examSite.id;
        insert examattempt2;
                
        system.runAs(user1)
        
        {
            system.debug('running user: ' + user1); 
            test.starttest();
                    
            EPPListDownload EPPList = new EPPListDownload();
            EPPList.getExamAttempts();
            EPPListDownload.wrapper e = new EPPListDownload.wrapper(); 
            e.garpId = '123';
            e.examName = 'FRM Part 1';
            e.email = 'test@ytesst.com';
            
            test.stopTest();
        } 
               
    }
}