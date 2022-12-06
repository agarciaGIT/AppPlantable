@isTest
public class graAppRemoter_test {
    
    static Account acc,acc1;
    static Contact contact,con;
    static Profile profile;
    static User user;
    static User user1;
    static User u;
    
    static FAQ_Category__c gbiFAQ;
    static FAQ_Section__c gbiFAQSection;
    static FAQ_Subsection__c gbiFAQSubSec;    
    static FAQ_Category__c studyFAQ;
    static FAQ_Section__c studyFAQSection;
    static FAQ_Subsection__c studyFAQSubSec;
    
    static Study__c study;
    static Study__c study2;
    static Disclosure_Protocol__c Dis_Pro;
    static Study_Disclose_Protocol_Submission__c dp;
    static Study_Contact__c sc;
    static Study_Account__c sa;
    static Study_Round__c sr;
    static Study_Vote__c sv;
    static Study_Vote_Question__c svq;
    static Study_Contact_Vote__c scv;
    static Study_Data_Submission__c sds;
    static Study_Document__c sd;
    static Study_Document__c sd1;
    static Study_Document__c sd2;
    
    static Study_Survey__c ss1;
    static Study_Survey__c ss2;
    static Study_Survey_Question__c sq1;
    static Study_Survey_Question__c sq2;
    static Study_Survey_Answer__c sa1;
    static Study_Survey_Choice__c sc1;
    
    static Attachment attach;
    
    static void testData() {
        
        Acc = new Account(Name = 'test', GBI_Region__c='North America'); 
        insert acc;
        
        //rd.gbiMetaData = [select Id, Name, G_SIB__c, Year__c, Account__c from GBI_Meta_Data__c];
        
        GBI_Meta_Data__c gmd = new GBI_Meta_Data__c(Name='Meta',G_SIB__c=True,Year__c='2018', Account__c=acc.Id);
        insert gmd;
        
        contact = new Contact(
            GBI_Participant__c = TRUE,
            KPI_ERP_Certified__c = TRUE,
            KPI_FRM_Certified__c = TRUE,
            GARP_Directory_Opt_In__c = TRUE,
            lastname = 'Test',
            AccountId = acc.id,
            email='test123123213124@test.com',
            KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17)
        );
        
        insert contact;
        
        profile = [SELECT Id FROM Profile WHERE id = '00e400000017dA8' limit 1]; 
        
        user = [select Id, Email from User where contactId = :contact.Id];
        
        //user1 = new User(Alias = 'newUser', Email='newuser@testorg.com', contactId = contact1.id,EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profile.Id, TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorg.com');
        //insert user1;
        
        
        acc1 = new Account(Name = 'Test');
        insert acc1;
        
        con = new Contact(KPI_ERP_Certified__c = true,KPI_FRM_Certified__c = true,
                          GARP_Directory_Opt_In__c = true,lastname = 'Testdhaskd',
                          AccountId = acc1.id,email='daghtest@test.com',
                          KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17),
                          Name_As_it_Appears_On_ID__c = 'testtest' ,
                          ID_Number__c = 'dasf123l',ID_Type__c = 'Passport');
        insert con;
        
        profile = [SELECT Id FROM Profile WHERE id = '00e400000017dA8' limit 1]; 
        
        //user u = [select Id, contactId,Email,AccountID from User where contactId = :con.Id];
        
        /*u = new User(Alias = 'newUser', Email='newuser@testorg.com', contactId = con.id,
EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
LocaleSidKey='en_US', ProfileId = profile.Id, parentid = user.id,TimeZoneSidKey='America/Los_Angeles',
UserName='newuser@testorg.com');*/
        
        u = new User(Alias = 'newUser', Email='newuser@testorg.com', 
                     contactId = con.id,EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                     LocaleSidKey='en_US', ProfileId = profile.Id, TimeZoneSidKey='America/Los_Angeles', 
                     UserName='newuser@testorg.com');
        insert u;
        
        studyFAQ = new FAQ_Category__c(Name='GBI');
        insert studyFAQ;
        
        studyFAQSection = new FAQ_Section__c(Name='GBI Sec', FAQ_Category__c=studyFAQ.Id);
        insert studyFAQSection;
        
        studyFAQSubSec = new FAQ_Subsection__c(Name='GBI SubSec', FAQ_Category__c=studyFAQ.Id, FAQ_Section__c=studyFAQSection.Id);
        insert studyFAQSubSec;
        
        gbiFAQ = new FAQ_Category__c(Name='GBI');
        insert gbiFAQ;
        
        gbiFAQSection = new FAQ_Section__c(Name='GBI Sec', FAQ_Category__c=gbiFAQ.Id);
        insert gbiFAQSection;
        
        gbiFAQSubSec = new FAQ_Subsection__c(Name='GBI SubSec', FAQ_Category__c=gbiFAQ.Id, FAQ_Section__c=gbiFAQSection.Id);
        insert gbiFAQSubSec;
        
        studyFAQ = new FAQ_Category__c(Name='GBI');
        insert studyFAQ;
        
        studyFAQSection = new FAQ_Section__c(Name='GBI Sec', FAQ_Category__c=studyFAQ.Id);
        insert studyFAQSection;
        
        studyFAQSubSec = new FAQ_Subsection__c(Name='GBI SubSec', FAQ_Category__c=studyFAQ.Id, FAQ_Section__c=studyFAQSection.Id);
        insert studyFAQSubSec;
        
        gbiFAQ = new FAQ_Category__c(Name='GBI');
        insert gbiFAQ;
        
        gbiFAQSection = new FAQ_Section__c(Name='GBI Sec', FAQ_Category__c=gbiFAQ.Id);
        insert gbiFAQSection;
        
        gbiFAQSubSec = new FAQ_Subsection__c(Name='GBI SubSec', FAQ_Category__c=gbiFAQ.Id, FAQ_Section__c=gbiFAQSection.Id);
        insert gbiFAQSubSec;
        
        study = new Study__c(Name='study1', FAQ_Category__c=studyFAQ.Id, Status__c='In Progress', Secure_File_Integration_Status__c = 'Enabled');
        insert study;
        
        study2 = new Study__c(Name='study2', FAQ_Category__c=studyFAQ.Id, Status__c='In Progress',
                              Secure_File_Integration_Status__c = 'Enabled',Study_Fee__c=100.0,Payment_Required__c = true);
        insert study2;
        
        Dis_Pro = new Disclosure_Protocol__c(Study__c = study.id,DP_Status__c = 'Active');
        insert Dis_Pro;
        
        sa = new Study_Account__c(Name='SA', Role__c='  Participant', Status__c='Active', Study__c=study.Id, Account__c=Acc.Id, Secure_File_Platform__c = 'ShareFile');
        insert sa;
        
        sc = new Study_Contact__c(Role__c='Voter', Status__c='Active', Study__c=study.Id, Contact__c=contact.Id, Study_Account__c=sa.Id);
        insert sc;
        
        dp = new Study_Disclose_Protocol_Submission__c(Name='dp', Study_Contact__c=sc.Id, Study__c=study.Id, Study_Account__c=sa.Id);
        insert dp; 
        
        sr = new Study_Round__c(Name='SR', Round__c='Version 1', Status__c='Data Collection', Study__c=study.Id);        
        insert sr;
        
        sv = new Study_Vote__c(Name='SV', Start_Date__c=system.today(), End_Date__c=system.today()+20, Status__c='Opened', Study__c=study.Id);
        insert sv;
        
        svq = new Study_Vote_Question__c(Name='SQv', Question__c='Why?', Answers__c='Yes\nNo', Study_Vote__c=sv.Id);
        insert svq;
        
        scv = new Study_Contact_Vote__c(Study_Contact__c=sc.Id, Study_Account__c=sa.Id, Study_Vote_Question__c=svq.Id, Vote__c='Yes', Vote_Made_Date_Time__c=system.now());
        insert scv;
        
        sds = new Study_Data_Submission__c(Study_Account__c=sa.Id, Submission_Date_Time__c=system.now(), Study_Round__c=sr.Id);
        insert sds;
        
        sd = new Study_Document__c(Name='SD', Study__c=study.Id, Date_Added__c=system.today());
        insert sd;
        
        sd1 = new Study_Document__c(Name='SD1', Study__c=study.Id, Account__c=acc.ID, Date_Added__c=system.today());        
        insert sd1;
        
        sd2 = new Study_Document__c(Name='SD2', Date_Added__c=system.today());
        insert sd2;
        
        
        ss1 = new Study_Survey__c(Name='SS1', Status__c='Active', Study__c=study.Id);
        insert ss1;
        
        sq1 = new Study_Survey_Question__c(Name='SQ1', Is_First_Question__c=True, Question__c='ABC?', Study_Survey__c=ss1.Id);
        insert sq1;
        
        sc1 = new Study_Survey_Choice__c(Name='SC1', Choice__c='123', Study_Survey_Question__c=sq1.Id);
        
        sa1 = new Study_Survey_Answer__c(Name='SA1', Study_Account__c=sa.Id, Study_Contact__c=sc.Id, Study_Survey_Question__c=sq1.Id);        
        
        
        attach = new Attachment(Name='Attach', ParentId=contact.Id, Body=Blob.valueOf('xyz'));
        insert attach;
        
    }
    
    static void setupShareFileConfig() {
        Sharefile_API_Config__c AuthEmail = new Sharefile_API_Config__c();
        AuthEmail.Name = 'AuthEmail';
        AuthEmail.Value__c = 'a@a.com';
        
        Sharefile_API_Config__c AuthPassword = new Sharefile_API_Config__c();
        AuthPassword.Name = 'AuthPassword';
        AuthPassword.Value__c = '12345';
        
        Sharefile_API_Config__c AuthClientId = new Sharefile_API_Config__c();
        AuthClientId.Name = 'AuthClientId';
        AuthClientId.Value__c = 'asdfafsadf';
        
        Sharefile_API_Config__c AuthClientSecret = new Sharefile_API_Config__c();
        AuthClientSecret.Name = 'AuthClientSecret';
        AuthClientSecret.Value__c = '1z223x2x';
        
        Sharefile_API_Config__c LoginEndPoint = new Sharefile_API_Config__c();
        LoginEndPoint.Name = 'LoginEndPoint';
        LoginEndPoint.Value__c = 'https://abc.com/api';
        
        Sharefile_API_Config__c BaseEndPoint = new Sharefile_API_Config__c();
        BaseEndPoint.Name = 'BaseEndPoint';
        BaseEndPoint.Value__c = 'https://abc.com/api';
        
        Sharefile_API_Config__c BaseFolderID = new Sharefile_API_Config__c();
        BaseFolderID.Name = 'BaseFolderID';
        BaseFolderID.Value__c = '43243243';
        
        Sharefile_API_Config__c ZoneId = new Sharefile_API_Config__c();
        ZoneId.Name = 'ZoneId';
        ZoneId.Value__c = '43243243';
        
        Sharefile_API_Config__c uploadLogin = new Sharefile_API_Config__c();
        uploadLogin.Name = 'Upload_RequireLogin';
        uploadLogin.Value__c = 'true';
        
        Sharefile_API_Config__c uploadInfo = new Sharefile_API_Config__c();
        uploadInfo.Name = 'Upload_RequireInfo';
        uploadInfo.Value__c = 'false';
        
        Sharefile_API_Config__c uploadExpire = new Sharefile_API_Config__c();
        uploadExpire.Name = 'Upload_ExpireMins';
        uploadExpire.Value__c = '25';
        
        insert new List<Sharefile_API_Config__c> {AuthEmail, AuthPassword, AuthClientId, AuthClientSecret, LoginEndPoint, BaseEndPoint, BaseFolderID, ZoneId, uploadLogin, uploadInfo, uploadExpire};
            }
    
    static testMethod void testService(){
        
        testData();
        test.startTest();
        system.runAs(user){
            gbiService.getStudiesWithDataPorcessing();
            
            GBI_Service_Config__c setting = new GBI_Service_Config__c();
            setting.Name = 'X-API-KEY';
            setting.Value__c = '32424234';
            insert setting;
            
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            
            req.addHeader('X-API-KEY', '123');
            
            RestContext.request = req;
            RestContext.response = res;
            
            gbiService.gbiService();
            gbiService.activityStatus as1 = new gbiService.activityStatus();
            
            gbiService.createDataSubmission(sr.Id, sa.Id, 'Customer Submission','Pass','123');
            gbiService.gbiService('activity','123',sr.Id, sa.Id, 'Customer Submission','Pass','123');
            
            gbiService.getDataPorcessingMetaData();
            
        }
        test.stopTest();
    }
    
    static void testData1() {
        
        Acc = new Account(Name = 'GARP');
        insert acc;
        
        contact = new Contact(KPI_ERP_Certified__c = true,KPI_FRM_Certified__c = true,
                              GARP_Directory_Opt_In__c = true,lastname = 'Test',GBI_Participant__c = True,
                              AccountId = acc.id,email='test123123213124@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        profile = [SELECT Id FROM Profile WHERE id = '00e400000017dA8' limit 1]; 
        
        user = [select Id, Email from User where contactId = :contact.Id];
        
        //user1 = new User(Alias = 'newUser', Email='newuser@testorg.com', contactId = contact1.id,EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profile.Id, TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorg.com');
        //insert user1;
        
        studyFAQ = new FAQ_Category__c(Name='GBI');
        insert studyFAQ;
        
        studyFAQSection = new FAQ_Section__c(Name='GBI Sec', FAQ_Category__c=studyFAQ.Id);
        insert studyFAQSection;
        
        studyFAQSubSec = new FAQ_Subsection__c(Name='GBI SubSec', FAQ_Category__c=studyFAQ.Id, FAQ_Section__c=studyFAQSection.Id);
        insert studyFAQSubSec;
        
        gbiFAQ = new FAQ_Category__c(Name='GBI');
        insert gbiFAQ;
        
        gbiFAQSection = new FAQ_Section__c(Name='GBI Sec', FAQ_Category__c=gbiFAQ.Id);
        insert gbiFAQSection;
        
        gbiFAQSubSec = new FAQ_Subsection__c(Name='GBI SubSec', FAQ_Category__c=gbiFAQ.Id, FAQ_Section__c=gbiFAQSection.Id);
        insert gbiFAQSubSec;
        
        study = new Study__c(Name='study1', FAQ_Category__c=studyFAQ.Id);
        insert study;
        
        sa = new Study_Account__c(Name='SA', Role__c='  Participant', Status__c='Active', Study__c=study.Id, Account__c=Acc.Id);
        insert sa;
        
        sc = new Study_Contact__c(Role__c='Voter', Status__c='Active', Study__c=study.Id, Contact__c=contact.Id, Study_Account__c=sa.Id);
        insert sc;
        
        dp = new Study_Disclose_Protocol_Submission__c(Name='dp', Study_Contact__c=sc.Id, Study__c=study.Id, Study_Account__c=sa.Id);
        insert dp; 
        
        sr = new Study_Round__c(Name='SR', Round__c='Version 1', Status__c='Active', Study__c=study.Id);        
        insert sr;
        
        sv = new Study_Vote__c(Name='SV', Start_Date__c=system.today(), End_Date__c=system.today()+20, Status__c='Opened', Study__c=study.Id);
        insert sv;
        
        svq = new Study_Vote_Question__c(Name='SQv', Question__c='Why?', Answers__c='Yes\nNo', Study_Vote__c=sv.Id);
        insert svq;
        
        scv = new Study_Contact_Vote__c(Study_Contact__c=sc.Id, Study_Account__c=sa.Id, Study_Vote_Question__c=svq.Id, Vote__c='Yes', Vote_Made_Date_Time__c=system.now());
        insert scv;
        
        sds = new Study_Data_Submission__c(Study_Account__c=sa.Id, Submission_Date_Time__c=system.now(), Study_Round__c=sr.Id);
        insert sds;
        
        sd = new Study_Document__c(Name='SD', Study__c=study.Id, Date_Added__c=system.today());
        insert sd;
        
        sd1 = new Study_Document__c(Name='SD1', Study__c=study.Id, Account__c=acc.ID, Date_Added__c=system.today());        
        insert sd1;
        
        sd2 = new Study_Document__c(Name='SD2', Date_Added__c=system.today());
        insert sd2;
        
        attach = new Attachment(Name='Attach', ParentId=contact.Id, Body=Blob.valueOf('xyz'));
        insert attach;
        
    }
    /*static testMethod void test1(){

testData();
test.startTest();
system.runAs(user){

graAppRemoter gra = new graAppRemoter();
gra.init();

graAppRemoter.fetchUserData();
graAppRemoter.submitVote(sv.Id, String.valueOf(svq.Id), 'Yes');
graAppRemoter.submitData(sr.Id);
graAppRemoter.submitDP(study.Id,'emailAddress435435rr4r4@garp.com',100.00);
graAppRemoter.submitCase('subject', 'Body');
// graAppRemoter.updateContactInfo('firstName', 'lastName', 'title', 'bio', 'phone');
//graAppRemoter.updateUserEmail('emailAddress435435rr4r4@garp.com');
graAppRemoter.uploadAttachment(attach.Id,'fileText','fileName'); 
graAppRemoter.uploadAttachment(null, 'Test File Body', 'TestFile.txt');

//graAppRemoter.getNetworkID();
graAppRemoter.fetchAllUpdates();
graAppRemoter.fetchGBIUpdate(null);
graAppRemoter.updateUserEmail('bob@bob.com');
graAppRemoter.setUserPhoto(null);

graAppRemoter.setLastLogin(contact.Id, '');
graAppRemoter.setLastLogin('', sc.Id);
graAppRemoter.getRelatedStudies(study.Id);
graAppRemoter.getNextSurveyQuestionData surveyData = new graAppRemoter.getNextSurveyQuestionData();
surveyData.lstAnswers = new List<Study_Survey_Answer__c>();
surveyData.lstAnswers.add(sa1);
graAppRemoter.getStudySurveyQuestion(study.Id, ss1.Id,sq1.id,surveyData);
graAppRemoter.submitStudySurveyAnswer(study.Id, ss1.Id,sq1.Id,'PFQ',surveyData);
graAppRemoter.commitSurveyData(study.Id, ss1.Id,surveyData);
graAppRemoter.getFirstStudySurveyQuestion(study.Id, ss1.Id);

graAppRemoter.removeUserPhoto();
graAppRemoter.getPillar3Menu();
graAppRemoter.getPillar3Notifications();
graAppRemoter.getPillar3Filters();

GARP_Profile__c gProf = new GARP_Profile__c(Title__c = 'Garp Profile', Bio__c = 'Garp Bio');
insert gProf;
update new Contact(Id = contact.Id, GARP_Profile__c = gProf.Id);
graAppRemoter.updateContactInfo('Firtest', 'Latest', 'Tester', 'Always Testing', '6465553489', 'dfghjasdasaskaskd@test.com');

}

test.stopTest();

}*/
    
    static testMethod void test1(){
        
        testData();
        test.startTest();
        
        system.runAs(user){
            
            graAppRemoter gra = new graAppRemoter();
            gra.init();
            
            Study__c study1 = [Select Name,Disclosure_Protocol__c, FAQ_Category__c, Status__c,
                               Secure_File_Integration_Status__c from Study__c limit 1];
            study1.Payment_Required__c = True;
            study1.Study_Fee__c = 100.0;
            update study1;
                        
            graAppRemoter.fetchUserData();
            graAppRemoter.submitVote(sv.Id, String.valueOf(svq.Id), 'Yes');
            graAppRemoter.submitData(sr.Id);
            //Version 1 Version 1
           // graAppRemoter.submitData('Version 1');
            graAppRemoter.submitDP(study1.Id,'emailAddress435435rr4r4@garp.com',100.00);
            graAppRemoter.submitCase('subject', 'Body');
            // graAppRemoter.updateContactInfo('firstName', 'lastName', 'title', 'bio', 'phone');
            //graAppRemoter.updateUserEmail('emailAddress435435rr4r4@garp.com');
            graAppRemoter.uploadAttachment(attach.Id,'fileText','fileName'); 
            graAppRemoter.uploadAttachment(null, 'Test File Body', 'TestFile.txt');
            
            //graAppRemoter.getNetworkID();
            graAppRemoter.fetchAllUpdates();
            graAppRemoter.fetchGBIUpdate(null);
            graAppRemoter.updateUserEmail('bob@bob.com');
            graAppRemoter.setUserPhoto(null);
            
            
            graAppRemoter.setLastLogin(contact.Id, '');
            graAppRemoter.setLastLogin('', sc.Id);
            graAppRemoter.getRelatedStudies(study.Id);
            graAppRemoter.getNextSurveyQuestionData surveyData = new graAppRemoter.getNextSurveyQuestionData();
            surveyData.lstAnswers = new List<Study_Survey_Answer__c>();
            surveyData.lstAnswers.add(sa1);
            graAppRemoter.getStudySurveyQuestion(study.Id, ss1.Id,sq1.id,surveyData);
            graAppRemoter.submitStudySurveyAnswer(study.Id, ss1.Id,sq1.Id,'PFQ',surveyData);
            
           /* Study_Survey_Submission__c sss = new Study_Survey_Submission__c(Status__c='Submitted',Study_Account__c = study.Id,
                                                                            Study_Survey__c = ss1.Id);
            insert sss;*/
            
            graAppRemoter.commitSurveyData(study.Id, ss1.Id,surveyData);
            ss2 = new Study_Survey__c(Name='SS2', Status__c='Active', Study__c=study2.Id);
            insert ss2;
            
            sq2 = new Study_Survey_Question__c(Name='SQ1', Is_First_Question__c=True, Question__c='ABC?', Study_Survey__c=ss2.Id);
            insert sq2;
            //graAppRemoter.getFirstStudySurveyQuestion(study2.Id, ss2.Id);

            graAppRemoter.removeUserPhoto();
            graAppRemoter.getPillar3Menu();
            graAppRemoter.getPillar3Notifications();
            graAppRemoter.getPillar3Filters();
            
            GARP_Profile__c gProf = new GARP_Profile__c(Title__c = 'Garp Profile', Bio__c = 'Garp Bio');
            insert gProf;
            update new Contact(Id = con.Id, GARP_Profile__c = gProf.Id);
            graAppRemoter.updateContactInfo('Firtest', 'Latest', 'Tester', 'Always Testing', '6465553489', 'dfghjasdasaskaskd@test.com');
            
        }
        
        test.stopTest();
        
    }
    
    @IsTest(SeeAllData=true)
    static void test2(){
        testData1();
        test.startTest();
        system.runAs(user){
            graAppRemoter.fetchUserData();
        }        
        test.stopTest();
    }
    
    @IsTest
    static void test3(){
        testData();
        test.startTest();
        system.runAs(user){
            
            graAppRemoter gra = new graAppRemoter();
            gra.init();
            graAppRemoter.setUserPhoto(attach.Id);
            graAppRemoter.getFirstStudySurveyQuestion(study.Id, ss1.Id);
            Study_Contact_Vote__c scv1 = [select id,Cancel_Vote__c from Study_Contact_Vote__c where Cancel_Vote__c = FALSE limit 1];
            scv1.Cancel_Vote__c = true;
            update scv1;
            graAppRemoter.submitVote(sv.Id, String.valueOf(svq.Id), 'Yes');
            graAppRemoter.sendEmail('Test Subject', 'Test Description',true);
            
        }
        
        test.stopTest();
        
    }
    
    @isTest
    private static void test_utils() {
        graAppRemoter.getUserReturnData data = new graAppRemoter.getUserReturnData();
        data.studyContactAccounts = new List<Account>();
        data.studyAccountContactRelation = new List<AccountContactRelation>();
        
        graAppRemoter.getNetworkID();
        
        Study__c pStudy = new Study__c(Name='Test Parent');
        insert pStudy;
        
        Study__c cStudy = new Study__c(Name='Test Child', Parent_Study__c = pStudy.Id);
        insert cStudy;
        
        graAppRemoter.getRelatedStudies(cStudy.Id);
    
        graAppRemoter.submitPillar3Attestation();
    }
    
    @isTest
    private static void test_uploadLink() {
        testData();
        setupShareFileConfig();
        
        Test.startTest();
        
        graAppRemoter.UploadLink link;
        
        System.runAs(user) {
            link = graAppRemoter.loadSFUploadLink(study.Id);
        }
        
        contact.GBI_Participant__c = false;
        update contact;
        
        System.runAs(user) {
            link = graAppRemoter.loadSFUploadLink(study.Id);
        }
        
        contact.GBI_Participant__c = true;
        update contact;
        sc.Role__c = 'Data Manager;Voter';
        update sc;
        
        System.runAs(user) {
            link = graAppRemoter.loadSFUploadLink(study.Id);
        }
        
        shareFileClass.ShareModel sm = new shareFileClass.ShareModel();
        sm.Id = 'someId';
        sm.Uri = 'abc.api.com/upload';
        sm.url = 'abc.api.com/share/someId';
        sm.AliasID = 'some';
        sm.CreationDate = System.now().format('yyyy-MM-dd');
        sm.ExpirationDate = System.now().addDays(1).format('yyyy-MM-dd');
        
        Test.stopTest();
    }
}