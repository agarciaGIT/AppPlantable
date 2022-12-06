@isTest
public class CheckContactsBatchTest {
	@TestSetup
    static void createTestData() {
        Integer totalCount = 5;
        
        List<Opportunity> OppResults =TestDataFactory.createOpportunity(totalCount);
        insert OppResults;
        
        List<Contact> ContactResults =TestDataFactory.createContacts(totalCount);
        for(Integer counter=0; counter < totalCount; counter++) {
            ContactResults[counter].AccountId = OppResults[counter].AccountId;
            ContactResults[counter].KPI_CPE_Participation__c = true;
        }
        insert ContactResults;
        
        List<Contract> ContractResults = TestDataFactory.createContract(totalCount,OppResults,ContactResults);
        ContractResults[0].RecordTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract', 'ERP_Program');
        ContractResults[1].RecordTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract', 'FRM_Program');
        ContractResults[0].Member_Email__c = 'testcontract@test.com';
        ContractResults[0].ContractTerm = totalCount - 1;
        ContractResults[0].Membership_type__C = 'Individual';
        insert ContractResults;
        ContractResults[0].Status = 'Completed';
        ContractResults[0].All_Requirements_Completed__c = true;
        ContractResults[1].Status = 'Completed';
        ContractResults[1].All_Requirements_Completed__c = true;
        ContractResults[0].ContractTerm = totalCount;
        ContractResults[2].Status = 'Activated ( Auto-Renew )';
        ContractResults[2].All_Requirements_Completed__c = FALSE;
        ContractResults[2].Membership_type__C = 'Individual';
        ContractResults[3].RecordTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract', 'CPE');
        ContractResults[4].RecordTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract', 'ERP_Program');
        update ContractResults;
        
        List<Candidate_Requirement__c> CandidateRequirementResults = TestDataFactory.createCandidateCommitment(totalCount,OppResults,ContractResults);
        for(Candidate_Requirement__c cr : CandidateRequirementResults){
            cr.recordTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Candidate_Requirement__c','Job_Experience');
            cr.Status__c = 'Completed';
            cr.Date_Of_Completion__c = system.today();
        }
        insert CandidateRequirementResults;
        
    }
    
    @isTest
    static void testBatch(){
        test.startTest();
        CheckContactsBatch batch = new CheckContactsBatch();
        database.executebatch(batch);
        test.stopTest();
    }
}