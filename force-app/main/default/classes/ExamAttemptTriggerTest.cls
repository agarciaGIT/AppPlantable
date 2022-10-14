@isTest
private class ExamAttemptTriggerTest {
    
    @TestSetup
    static void createTestData() {
        Integer totalCount = 6;
        TestClassUtil.isForNewTrigger();
        List<Contact> ContactResults=TestDataFactory.createContacts(totalCount);
        insert ContactResults;
        
        List<Opportunity> OppResults=TestDataFactory.createOpportunity(totalCount);
        OppResults[0].StageName = 'Closed';
        OppResults[1].StageName = 'Closed';
        OppResults[2].StageName = 'Closed';
        OppResults[3].StageName = 'Closed';
        insert OppResults;
        
        List<Contract> ContractResults=TestDataFactory.createContract(totalCount,OppResults,ContactResults);
        ContractResults[0].recordtypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract','Membership');
        insert ContractResults;
        ContractResults[0].Status = 'Activated';
        ContractResults[1].Status = 'Activated';
        ContractResults[2].Status = 'Activated';
        ContractResults[3].Status = 'Activated';
        update ContractResults;
        
        List<Candidate_Requirement__c> CandidateRequirementResults=TestDataFactory.createCandidateCommitment(totalCount,OppResults,ContractResults);
        insert CandidateRequirementResults;
        
        List<Exam_Attempt__c> ExamAttemptResults = TestDataFactory.createExamAttempt(totalCount,OppResults,contractResults);
        ExamAttemptResults[0].Result__c = 'Not Graded';
        ExamAttemptResults[0].Legacy_Unpaid_Registration_Date__c = null;
        ExamAttemptResults[1].Result__c = 'Not Graded';
        ExamAttemptResults[2].Result__c = 'Not Graded';
        ExamAttemptResults[3].Result__c = 'Not Graded';
        ExamAttemptResults[4].Result__c = '';
        ExamAttemptResults[5].Result__c = 'Not Graded';
        ExamAttemptResults[0].Member__c = ContactResults[0].Id;
        ExamAttemptResults[1].Member__c = ContactResults[1].Id;
        ExamAttemptResults[2].Member__c = ContactResults[2].Id;
        ExamAttemptResults[3].Member__c = ContactResults[3].Id;
        ExamAttemptResults[4].Candidate_Commitment__c = ContractResults[4].Id;
        ExamAttemptResults[5].Candidate_Commitment__c = ContractResults[5].Id;
        //ExamAttemptResults[4].Section__c = 'ICBRR';
        //ExamAttemptResults[5].Section__c = 'ICBRR';
        insert ExamAttemptResults;
        
    }
    
    @isTest static void testExamAttemptV1(){
        TestClassUtil.isForNewTrigger();
        test.startTest();
        List<Exam_Attempt__c> ExamAttemptList = [Select Id  from Exam_Attempt__c  LIMIT 2];
        List<Candidate_Requirement__c> CandidateRequirementList = [Select Id  from Candidate_Requirement__c  LIMIT 2];
        ExamAttemptList[0].Result__c = 'Pass';
        ExamAttemptList[1].Result__c = 'Fail';
        ExamAttemptList[0].Candidate_Requirement__c = CandidateRequirementList[0].Id;
        ExamAttemptList[1].Candidate_Requirement__c = CandidateRequirementList[0].Id;
        update ExamAttemptList;
        test.stopTest();
    }
    
    @isTest static void testExamAttemptV2(){
        TestClassUtil.isForNewTrigger();
        test.startTest();
        List<Exam_Attempt__c> ExamAttemptList = [Select Id  from Exam_Attempt__c  LIMIT 2];
        List<Candidate_Requirement__c> CandidateRequirementList = [Select Id  from Candidate_Requirement__c  LIMIT 2];
        ExamAttemptList[0].Result__c = 'Pass';
        ExamAttemptList[1].Result__c = 'Pass';
        ExamAttemptList[0].Candidate_Requirement__c = CandidateRequirementList[0].Id;
        ExamAttemptList[1].Candidate_Requirement__c = CandidateRequirementList[0].Id;
        update ExamAttemptList;
        test.stopTest();
    }
    
    @isTest static void testExamAttemptV3(){
        TestClassUtil.isForNewTrigger();
        test.startTest();
        List<Exam_Attempt__c> ExamAttemptList = [Select Id  from Exam_Attempt__c  LIMIT 2];
        List<Candidate_Requirement__c> CandidateRequirementList = [Select Id  from Candidate_Requirement__c  LIMIT 2];
        ExamAttemptList[0].Result__c = 'Fail';
        ExamAttemptList[1].Result__c = 'Fail';
        ExamAttemptList[0].Cancelled__c = False;
        ExamAttemptList[1].Cancelled__c = False;
        ExamAttemptList[0].Candidate_Requirement__c = CandidateRequirementList[0].Id;
        ExamAttemptList[1].Candidate_Requirement__c = CandidateRequirementList[1].Id;
        update ExamAttemptList;
        test.stopTest();
    }
    
    @isTest static void testExamAttemptV4(){
        TestClassUtil.isForNewTrigger();
        test.startTest();
        List<Exam_Attempt__c> ExamAttemptList = [Select Id  from Exam_Attempt__c  LIMIT 4];
        List<Candidate_Requirement__c> CandidateRequirementList = [Select Id  from Candidate_Requirement__c  LIMIT 4];
        ExamAttemptList[2].Result__c = 'Pass';
        ExamAttemptList[3].Result__c = 'Pass';
        ExamAttemptList[2].Cancelled__c = False;
        ExamAttemptList[3].Cancelled__c = False;
        ExamAttemptList[2].Candidate_Requirement__c = CandidateRequirementList[2].Id;
        ExamAttemptList[3].Candidate_Requirement__c = CandidateRequirementList[3].Id;
        update ExamAttemptList;
        test.stopTest();
    }
    
    @isTest 
    static void testExamAttemptV5(){
        TestClassUtil.isForNewTrigger();
        test.startTest();
        List<Exam_Attempt__c> recordList = new List<Exam_Attempt__c>();
        for(Exam_Attempt__c ea : [SELECT Id,Exam_Site__r.Exam__r.Exam__c FROM Exam_Attempt__c WHERE Candidate_Commitment__c != null AND Result__c = NULL]){
            ea.Result__c = 'Not Graded';
            recordList.add(ea);
        }
        
        update recordList;
        
        test.stopTest();
    }
    
    @isTest 
    static void testExamAttemptV6(){
        TestClassUtil.isForNewTrigger();
        Integer numRecords = 6;
        
        List<Contact> ContactResults=TestDataFactory.createContacts(numRecords);
        insert ContactResults;
        /*
        List<Opportunity> OppResults=TestDataFactory.createOpportunity(numRecords);
        OppResults[0].StageName = 'Closed';
        OppResults[1].StageName = 'Closed';
        OppResults[2].StageName = 'Closed';
        OppResults[3].StageName = 'Closed';
        insert OppResults;
        
        List<Contract> ContractResults=TestDataFactory.createContract(numRecords,OppResults,ContactResults);
        ContractResults[0].recordtypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract','Membership');
        insert ContractResults;
        ContractResults[0].Status = 'Activated';
        ContractResults[1].Status = 'Activated';
        ContractResults[2].Status = 'Activated';
        ContractResults[3].Status = 'Activated';
        update ContractResults;
        */
        List<Contract> ContractResults= [select id,CustomerSignedId from Contract limit 50];
        List<Opportunity> OppResults= [select id from Opportunity limit 50];
        
        List<Exam__c> ExamResults = new List<Exam__c>();
        for(Exam__c ex : [SELECT id,Exam__c,Exam_Group__c FROM Exam__c LIMIT 50]){
            ex.Exam__c = 'ICBRR';
            ExamResults.add(ex);
        }
        update ExamResults;
        
        List<Exam_Part__c> examPartResults = TestDataFactory.createExamPart(numRecords,ExamResults);
        insert examPartResults;
        List<Exam_Sites__c> examSiteResults = TestDataFactory.createExamSite(numRecords,examPartResults,ExamResults);
        insert examSiteResults;
        List<Exam_Attempt__c> results=new List<Exam_Attempt__c> ();
        String[] recordtype = new String[]{'ERP','FRM','ICBRR','SCR'};
            Integer flag=0;
        for(Integer counter=0 ; counter < numRecords ; counter ++) {
            Exam_Attempt__c record=new Exam_Attempt__c();
            record.Opportunity__c = OppResults[0].id; 
            record.Exam_Site__c = examSiteResults[counter].id;
            record.Member__c = contractResults[counter].CustomerSignedId;//contact id
            record.cancelled__c = false;
            record.Candidate_Commitment__c = contractResults[counter].id;
            record.ATA_Cert_id__c = 'Test'+counter;
            record.ATA_Cert_Type__c = 'TestType'+counter;
            record.ATA_Name_as_it_appears_on_ID__c = 'Test User';
            record.Exam_Administration__c = examPartResults[counter].Exam_Administration__c;
            record.Exam_Part__c = examPartResults[counter].id;
            record.Switch_Date__c = System.Today();
            //record.Result__c='Pass';
            record.Defered__c = 'Approved';
            record.Legacy_Unpaid_Registration_Date__c=system.today()+ 60;
            if(flag==4)
                flag=0;
            record.RecordTypeId = RecordTypeHelper.GetRecordTypeId('Exam_Attempt__c',recordtype[flag]);     
            flag++;
            System.debug('section'+counter+record.Section__c);
            System.debug('Opportunity_StageName__c'+counter+record.Opportunity_StageName__c);
            results.add(record);
            
        }
        insert results;
        
        test.startTest();
        List<Exam_Attempt__c> recordList = new List<Exam_Attempt__c>();
        for(Exam_Attempt__c ea : [SELECT Id,Exam_Site__r.Exam__r.Exam__c FROM Exam_Attempt__c WHERE Candidate_Commitment__c != null AND Result__c = NULL]){
            ea.Result__c = 'Not Graded';
            recordList.add(ea);
        }
        
        update recordList;
        
        test.stopTest();
    }
    
    @isTest static void testInsert(){
        TestClassUtil.isForNewTrigger();
        test.startTest();
        Exam_Attempt__c record = new Exam_Attempt__c();
        record.cancelled__c = false;
        record.ATA_Cert_id__c = 'Test';
        record.ATA_Cert_Type__c = 'TestType';
        record.ATA_Name_as_it_appears_on_ID__c = 'Test User';
        insert record;
        test.stopTest();
    }
}