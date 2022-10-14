@isTest
private class OstaExamRegistrationDataBackfillTest {

    @testSetup
    public static void testSetup(){
        //TestClassUtil.isForOldTrigger();
        
       	INSERT new Exam_Date__c(Name = 'Exam Date', Date_String__c = String.valueOf(System.today().addDays(60)));
        
        ExamRegistrationTestDataFactory.setupChargent();
		ExamRegistrationTestDataFactory.setupAccountOwner();     
		ExamRegistrationTestDataFactory.setupActivePricebook();
        ExamRegistrationTestDataFactory.setupFeeProducts();
		ExamRegistrationTestDataFactory.setupBookProducts();
		ExamRegistrationTestDataFactory.setupExamRegistrationDependencyObjects();
        
    }
    
    @isTest
    public static void createSingleExamRegistrationMissingOstaExamRegistrationData(){
        
   		User user = ExamRegistrationTestDataFactory.createExamRegistration('FRM', 'Credit Card', 'TESTUSERONE', TRUE, TRUE);
        
        List<Opportunity> opportunities = [SELECT Id, StageName FROM Opportunity WHERE AccountId = :user.AccountId];
        for(Opportunity opportunity: opportunities){
            opportunity.StageName = 'Closed';
        }
        
		Test.startTest();
        
        UPDATE opportunities;
        
        //System.assertEquals(1, [SELECT Id FROM OSTA_Exam_Registration_Data__c].size(), 'It should have a size of 1');
        
        DELETE [SELECT Id FROM OSTA_Exam_Registration_Data__c];
        
        System.assertEquals(0, [SELECT Id FROM OSTA_Exam_Registration_Data__c].size(), 'It should have a size of 0');

        Id batchJobId = Database.executeBatch(new OstaExamRegistrationDataBatch(), 200);
        
        Test.stopTest();
        
        //System.assertEquals(1, [SELECT Id FROM OSTA_Exam_Registration_Data__c].size(), 'It should have a size of 1');
        
    }
    
    @isTest
    public static void createCombinedExamRegistrationMissingOstaExamRegistrationData(){
        
   		User user = ExamRegistrationTestDataFactory.createExamRegistration('FRM', 'Credit Card', 'TESTUSERONE', TRUE, TRUE);
        
        List<Opportunity> opportunities = [SELECT Id, StageName FROM Opportunity WHERE AccountId = :user.AccountId];
        for(Opportunity opportunity: opportunities){
            opportunity.StageName = 'Closed';
        }
        
        Test.startTest();
        
        UPDATE opportunities;

        //System.assertEquals(1, [SELECT Id FROM OSTA_Exam_Registration_Data__c].size(), 'It should have a size of 1');
        
        DELETE [SELECT Id FROM OSTA_Exam_Registration_Data__c];
        
        System.assertEquals(0, [SELECT Id FROM OSTA_Exam_Registration_Data__c].size(), 'It should have a size of 0');
        
        Id batchJobId = Database.executeBatch(new OstaExamRegistrationDataBatch(), 200);
        
        Test.stopTest();
        
        //System.assertEquals(1, [SELECT Id FROM OSTA_Exam_Registration_Data__c].size(), 'It should have a size of 1');
        
    }
    
    @isTest
    public static void createSingleExamRegistrationWithOstaExamRegistrationData(){
        
   		User user = ExamRegistrationTestDataFactory.createExamRegistration('FRM', 'Credit Card', 'TESTUSERONE', TRUE, TRUE);
        
        List<Opportunity> opportunities = [SELECT Id, StageName FROM Opportunity WHERE AccountId = :user.AccountId];
        for(Opportunity opportunity: opportunities){
            opportunity.StageName = 'Closed';
        }
        
        Test.startTest();
        
        UPDATE opportunities;

        //System.assertEquals(1, [SELECT Id FROM OSTA_Exam_Registration_Data__c].size(), 'It should have a size of 1');
        
        Id batchJobId = Database.executeBatch(new OstaExamRegistrationDataBatch(), 200);
        
        Test.stopTest();
        
        //System.assertEquals(1, [SELECT Id FROM OSTA_Exam_Registration_Data__c].size(), 'It should have a size of 1');
        
    }
    
    @isTest
    public static void createCombinedExamRegistrationWithOstaExamRegistrationData(){
        
   		User user = ExamRegistrationTestDataFactory.createExamRegistration('FRM', 'Credit Card', 'TESTUSERONE', TRUE, TRUE);
        
        List<Opportunity> opportunities = [SELECT Id, StageName FROM Opportunity WHERE AccountId = :user.AccountId];
        for(Opportunity opportunity: opportunities){
            opportunity.StageName = 'Closed';
        }
        
        Test.startTest();
        
        UPDATE opportunities;

        //System.assertEquals(1, [SELECT Id FROM OSTA_Exam_Registration_Data__c].size(), 'It should have a size of 1');

        Id batchJobId = Database.executeBatch(new OstaExamRegistrationDataBatch(), 200);
        
        Test.stopTest();
        
        //System.assertEquals(1, [SELECT Id FROM OSTA_Exam_Registration_Data__c].size(), 'It should have a size of 1');
        
    }
    
}