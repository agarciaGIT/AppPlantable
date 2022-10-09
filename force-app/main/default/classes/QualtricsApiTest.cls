@isTest
public class QualtricsApiTest {
    @testSetup
    private static void testSetup() {

        Study__c study = new Study__c();
        study.Qualtrics_Survey_ID__c = 'SV_b76TGKe2PrEZGG9';
        study.Qualtrics_Survey_Integration_Status__c = 'Enabled';
        study.Qualtrics_Survey_Sync_Study__c = TRUE;
        INSERT study;
        
        Study_Account__c studyAccount1 = new Study_Account__c();
        studyAccount1.Qualtrics_Survey_Integration_Status__c = 'Enabled';
        studyAccount1.Qualtrics_Survey_Sync_Study__c = TRUE;
        studyAccount1.Study__c = study.Id;
        INSERT studyAccount1;

        Study_Account__c studyAccount2 = new Study_Account__c();
        studyAccount2.Qualtrics_Survey_Integration_Status__c = 'Enabled';
        studyAccount2.Qualtrics_Survey_Sync_Study__c = TRUE;
        studyAccount2.Study__c = study.Id;
        INSERT studyAccount2;

    }

    @isTest
    private static void createQualtricsMailingListAndContactInMailingList (){

        List<Study_Account__c> studyAccounts = [
            SELECT Id, Study__r.Qualtrics_Survey_Integration_Status__c, Qualtrics_Survey_Integration_Status__c, Qualtrics_Survey_Sync_Study__c, Qualtrics_Mailing_List_ID__c, Qualtrics_Contact_ID__c
            FROM Study_Account__c
        ];

        Test.startTest();
        System.enqueueJob(new QualtricsApiQueueable(studyAccounts, 0));
        Test.stopTest();

        studyAccounts = [
            SELECT Id, Qualtrics_Survey_Integration_Status__c, Qualtrics_Survey_Sync_Study__c, Qualtrics_Mailing_List_ID__c, Qualtrics_Contact_ID__c, Qualtrics_Last_Distribution_Link_Expiry__c
            FROM Study_Account__c
        ];

        System.assertNotEquals(null, studyAccounts[0].Qualtrics_Contact_ID__c);
        System.assertNotEquals(null, studyAccounts[0].Qualtrics_Mailing_List_ID__c);
        
    }

    @isTest
    private static void generateDistributionLinks (){

        List<Study_Account__c> studyAccounts = [
            SELECT Id, Qualtrics_Survey_Integration_Status__c, Qualtrics_Survey_Sync_Study__c, Qualtrics_Mailing_List_ID__c, Qualtrics_Contact_ID__c
            FROM Study_Account__c
        ];
        
        studyAccounts[0].Qualtrics_Mailing_List_ID__c = 'CG_0SAbnbKkh6L2h7b';
        studyAccounts[0].Qualtrics_Contact_ID__c = 'CID_1js5Gg3UueFIEPb';

        UPDATE studyAccounts[0];

        Test.startTest();
        QualtricsApiController.getQualtricsDistributionLink(studyAccounts[0].Id);
        Test.stopTest();

        studyAccounts = [
            SELECT Id, Qualtrics_Survey_Integration_Status__c, Qualtrics_Survey_Sync_Study__c, Qualtrics_Mailing_List_ID__c, Qualtrics_Contact_ID__c, Qualtrics_Last_Distribution_ID__c, Qualtrics_Last_Distribution_Link__c, Qualtrics_Last_Distribution_Link_Expiry__c
            FROM Study_Account__c
        ];

        System.assertNotEquals(null, studyAccounts[0].Qualtrics_Last_Distribution_ID__c);
        System.assertNotEquals(null, studyAccounts[0].Qualtrics_Last_Distribution_Link__c);
        System.assertNotEquals(null, studyAccounts[0].Qualtrics_Last_Distribution_Link_Expiry__c);
        
    }

    @isTest
    private static void generateDistributionLinksWithAlreadyExistingLink (){

        List<Study_Account__c> studyAccounts = [
            SELECT Id, Qualtrics_Survey_Integration_Status__c, Qualtrics_Survey_Sync_Study__c, Qualtrics_Mailing_List_ID__c, Qualtrics_Contact_ID__c
            FROM Study_Account__c
        ];
        
        studyAccounts[0].Qualtrics_Mailing_List_ID__c = 'CG_0SAbnbKkh6L2h7b';
        studyAccounts[0].Qualtrics_Contact_ID__c = 'CID_1js5Gg3UueFIEPb';
        studyAccounts[0].Qualtrics_Last_Distribution_Link__c = 'www.test.com';

        UPDATE studyAccounts[0];

        Test.startTest();
        QualtricsApiController.getQualtricsDistributionLink(studyAccounts[0].Id);
        Test.stopTest();

        studyAccounts = [
            SELECT Id, Qualtrics_Survey_Integration_Status__c, Qualtrics_Survey_Sync_Study__c, Qualtrics_Mailing_List_ID__c, Qualtrics_Contact_ID__c, Qualtrics_Last_Distribution_ID__c, Qualtrics_Last_Distribution_Link__c, Qualtrics_Last_Distribution_Link_Expiry__c
            FROM Study_Account__c
            WHERE Id = :studyAccounts[0].Id
        ];

        System.assertNotEquals(null, studyAccounts[0].Qualtrics_Last_Distribution_Link__c);
        
    }

    @isTest
    private static void instigateStudyAccountTriggerOnInsertWhenStudyDisabled (){

        Study__c study = new Study__c();
        study.Qualtrics_Survey_ID__c = 'SV_b76TGKe2PrEZGG9';
        study.Qualtrics_Survey_Integration_Status__c = 'Disabled';
        study.Qualtrics_Survey_Sync_Study__c = FALSE;
        INSERT study;

        Test.startTest();
        Study_Account__c studyAccount = new Study_Account__c();
        studyAccount.Qualtrics_Survey_Integration_Status__c = 'Enabled';
        studyAccount.Qualtrics_Survey_Sync_Study__c = TRUE;
        studyAccount.Study__c = study.Id;
        INSERT studyAccount;
        Test.stopTest();

        studyAccount = [
            SELECT Id, Qualtrics_Survey_Integration_Status__c, Qualtrics_Survey_Sync_Study__c, Qualtrics_Mailing_List_ID__c, Qualtrics_Contact_ID__c, Qualtrics_Last_Distribution_Link_Expiry__c
            FROM Study_Account__c
            WHERE Id = :studyAccount.Id
            LIMIT 1
        ];

        System.assertEquals(null, studyAccount.Qualtrics_Contact_ID__c);
        System.assertEquals(null, studyAccount.Qualtrics_Mailing_List_ID__c);
        
    }

    @isTest
    private static void instigateStudyAccountTriggerOnInsertWhenStudyAccountDisabled (){

        Study__c study = new Study__c();
        study.Qualtrics_Survey_ID__c = 'SV_b76TGKe2PrEZGG9';
        study.Qualtrics_Survey_Integration_Status__c = 'Enabled';
        study.Qualtrics_Survey_Sync_Study__c = TRUE;
        INSERT study;

        Test.startTest();
        Study_Account__c studyAccount = new Study_Account__c();
        studyAccount.Qualtrics_Survey_Integration_Status__c = 'Disabled';
        studyAccount.Qualtrics_Survey_Sync_Study__c = FALSE;
        studyAccount.Study__c = study.Id;
        INSERT studyAccount;
        Test.stopTest();

        studyAccount = [
            SELECT Id, Qualtrics_Survey_Integration_Status__c, Qualtrics_Survey_Sync_Study__c, Qualtrics_Mailing_List_ID__c, Qualtrics_Contact_ID__c, Qualtrics_Last_Distribution_Link_Expiry__c
            FROM Study_Account__c
            WHERE Id = :studyAccount.Id
            LIMIT 1
        ];

        System.assertEquals(null, studyAccount.Qualtrics_Contact_ID__c);
        System.assertEquals(null, studyAccount.Qualtrics_Mailing_List_ID__c);
        
    }

    @isTest
    private static void instigateStudyAccountTriggerOnInsertWhenStudyAccountEnabled (){

        Study__c study = new Study__c();
        study.Qualtrics_Survey_ID__c = 'SV_b76TGKe2PrEZGG9';
        study.Qualtrics_Survey_Integration_Status__c = 'Enabled';
        study.Qualtrics_Survey_Sync_Study__c = TRUE;
        INSERT study;

        Test.startTest();
        Study_Account__c studyAccount = new Study_Account__c();
        studyAccount.Qualtrics_Survey_Integration_Status__c = 'Enabled';
        studyAccount.Qualtrics_Survey_Sync_Study__c = TRUE;
        studyAccount.Study__c = study.Id;
        INSERT studyAccount;
        Test.stopTest();

        studyAccount = [
            SELECT Id, Qualtrics_Survey_Integration_Status__c, Qualtrics_Survey_Sync_Study__c, Qualtrics_Mailing_List_ID__c, Qualtrics_Contact_ID__c, Qualtrics_Last_Distribution_Link_Expiry__c
            FROM Study_Account__c
            WHERE Id = :studyAccount.Id
            LIMIT 1
        ];

        System.assertNotEquals(null, studyAccount.Qualtrics_Contact_ID__c);
        System.assertNotEquals(null, studyAccount.Qualtrics_Mailing_List_ID__c);
        
    }

    @isTest
    private static void instigateStudyTriggerOnUpdateWhenStudyAccountDisabled (){

        Study__c study = new Study__c();
        study.Qualtrics_Survey_ID__c = 'SV_b76TGKe2PrEZGG9';
        study.Qualtrics_Survey_Integration_Status__c = 'Disabled';
        study.Qualtrics_Survey_Sync_Study__c = FALSE;
        INSERT study;

        Study_Account__c studyAccount = new Study_Account__c();
        studyAccount.Qualtrics_Survey_Integration_Status__c = 'Disabled';
        studyAccount.Qualtrics_Survey_Sync_Study__c = FALSE;
        studyAccount.Study__c = study.Id;
        INSERT studyAccount;

        Test.startTest();
        StudyTriggerHelper.firstExecution = TRUE;
        study.Qualtrics_Survey_Integration_Status__c = 'Enabled';
        study.Qualtrics_Survey_Sync_Study__c = TRUE;
        UPDATE study;
        Test.stopTest();

        studyAccount = [
            SELECT Id, Qualtrics_Survey_Integration_Status__c, Qualtrics_Survey_Sync_Study__c, Qualtrics_Mailing_List_ID__c, Qualtrics_Contact_ID__c, Qualtrics_Last_Distribution_Link_Expiry__c
            FROM Study_Account__c
            WHERE Id = :studyAccount.Id
            LIMIT 1
        ];

        System.assertEquals(null, studyAccount.Qualtrics_Contact_ID__c);
        System.assertEquals(null, studyAccount.Qualtrics_Mailing_List_ID__c);
        
    }

    @isTest
    private static void instigateStudyTriggerOnUpdateWhenStudyAccountEnabled (){

        Study__c study = new Study__c();
        study.Qualtrics_Survey_ID__c = 'SV_b76TGKe2PrEZGG9';
        study.Qualtrics_Survey_Integration_Status__c = 'Disabled';
        study.Qualtrics_Survey_Sync_Study__c = FALSE;
        INSERT study;

        Study_Account__c studyAccount = new Study_Account__c();
        studyAccount.Qualtrics_Survey_Integration_Status__c = 'Enabled';
        studyAccount.Qualtrics_Survey_Sync_Study__c = TRUE;
        studyAccount.Study__c = study.Id;
        INSERT studyAccount;

        Test.startTest();
        StudyTriggerHelper.firstExecution = TRUE;
        study.Qualtrics_Survey_Integration_Status__c = 'Enabled';
        study.Qualtrics_Survey_Sync_Study__c = TRUE;
        UPDATE study;
        Test.stopTest();

        studyAccount = [
            SELECT Id, Qualtrics_Survey_Integration_Status__c, Qualtrics_Survey_Sync_Study__c, Qualtrics_Mailing_List_ID__c, Qualtrics_Contact_ID__c, Qualtrics_Last_Distribution_Link_Expiry__c
            FROM Study_Account__c
            WHERE Id = :studyAccount.Id
            LIMIT 1
        ];

        System.assertNotEquals(null, studyAccount.Qualtrics_Contact_ID__c);
        System.assertNotEquals(null, studyAccount.Qualtrics_Mailing_List_ID__c);
        
    }

    @isTest
    private static void instigateStudyAccountTriggerOnUpdateWhenStudyDisabled (){

        Study__c study = new Study__c();
        study.Qualtrics_Survey_ID__c = 'SV_b76TGKe2PrEZGG9';
        study.Qualtrics_Survey_Integration_Status__c = 'Disabled';
        study.Qualtrics_Survey_Sync_Study__c = FALSE;
        INSERT study;

        Study_Account__c studyAccount = new Study_Account__c();
        studyAccount.Qualtrics_Survey_Integration_Status__c = 'Disabled';
        studyAccount.Qualtrics_Survey_Sync_Study__c = FALSE;
        studyAccount.Study__c = study.Id;
        INSERT studyAccount;

        Test.startTest();
        StudyAccountTriggerHelper.firstExecution = TRUE;
        studyAccount.Qualtrics_Survey_Integration_Status__c = 'Enabled';
        studyAccount.Qualtrics_Survey_Sync_Study__c = TRUE;
        UPDATE studyAccount;
        Test.stopTest();

        studyAccount = [
            SELECT Id, Qualtrics_Survey_Integration_Status__c, Qualtrics_Survey_Sync_Study__c, Qualtrics_Mailing_List_ID__c, Qualtrics_Contact_ID__c, Qualtrics_Last_Distribution_Link_Expiry__c
            FROM Study_Account__c
            WHERE Id = :studyAccount.Id
            LIMIT 1
        ];

        System.assertEquals(null, studyAccount.Qualtrics_Contact_ID__c);
        System.assertEquals(null, studyAccount.Qualtrics_Mailing_List_ID__c);
        
    }

    @isTest
    private static void instigateStudyAccountTriggerOnUpdateWhenStudyEnabled (){

        Study__c study = new Study__c();
        study.Qualtrics_Survey_ID__c = 'SV_b76TGKe2PrEZGG9';
        study.Qualtrics_Survey_Integration_Status__c = 'Enabled';
        study.Qualtrics_Survey_Sync_Study__c = TRUE;
        INSERT study;

        Study_Account__c studyAccount = new Study_Account__c();
        studyAccount.Qualtrics_Survey_Integration_Status__c = 'Disabled';
        studyAccount.Qualtrics_Survey_Sync_Study__c = FALSE;
        studyAccount.Study__c = study.Id;
        INSERT studyAccount;

        Test.startTest();
        StudyAccountTriggerHelper.firstExecution = TRUE;
        studyAccount.Qualtrics_Survey_Integration_Status__c = 'Enabled';
        studyAccount.Qualtrics_Survey_Sync_Study__c = TRUE;
        UPDATE studyAccount;
        Test.stopTest();

        studyAccount = [
            SELECT Id, Qualtrics_Survey_Integration_Status__c, Qualtrics_Survey_Sync_Study__c, Qualtrics_Mailing_List_ID__c, Qualtrics_Contact_ID__c, Qualtrics_Last_Distribution_Link_Expiry__c
            FROM Study_Account__c
            WHERE Id = :studyAccount.Id
            LIMIT 1
        ];

        System.assertNotEquals(null, studyAccount.Qualtrics_Contact_ID__c);
        System.assertNotEquals(null, studyAccount.Qualtrics_Mailing_List_ID__c);
        
    }

}