@isTest
private class ContractTriggerTest { 
    
    public static Datetime yesterday;
    
    @TestSetup
    static void createTestData() {
        TestClassUtil.isForNewTrigger();
        Integer totalCount = 10;
        yesterday = Datetime.now().addDays(-1);
        
        List<Opportunity> OppResults =TestDataFactory.createOpportunity(totalCount);
        insert OppResults;
        
        List<Contact> ContactResults =TestDataFactory.createContacts(totalCount);
        for(Integer counter=0; counter < totalCount; counter++) {
            ContactResults[counter].AccountId = OppResults[counter].AccountId;
        }
        insert ContactResults;
        
        List<Contract> ContractResults = TestDataFactory.createContract(totalCount,OppResults,ContactResults);
        ContractResults[0].RecordTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract', 'Membership');
        ContractResults[1].RecordTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract', 'FRM_Program');
        ContractResults[0].Member_Email__c = 'testcontract@test.com';
        ContractResults[0].ContractTerm = totalCount - 1;
        ContractResults[0].Membership_type__C = 'Individual';
        ContractResults[0].KPI_Last_Updated__c = yesterday;
        insert ContractResults;
        ContractResults[0].Status = 'Completed';
        ContractResults[0].All_Requirements_Completed__c = true;
        ContractResults[1].All_Requirements_Completed__c = true;
        ContractResults[0].ContractTerm = totalCount;
        ContractResults[2].Status = 'Activated ( Auto-Renew )';
        ContractResults[2].All_Requirements_Completed__c = FALSE;
        ContractResults[2].KPI_Last_Updated__c = yesterday;
        ContractResults[2].Membership_type__C = 'Individual';
        ContractResults[3].RecordTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract', 'CPE');
        ContractResults[4].RecordTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract', 'ERP_Program');
        ContractResults[5].Status = 'Activated ( Auto-Renew )';
        ContractResults[5].RecordTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract', 'Membership');
        ContractResults[5].Membership_type__C = 'student';
        update ContractResults;
        
        List<Candidate_Requirement__c> CandidateRequirementResults = TestDataFactory.createCandidateCommitment(totalCount,OppResults,ContractResults);
        for(Candidate_Requirement__c cr : CandidateRequirementResults){
            cr.recordTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Candidate_Requirement__c','CPE');
        }
        insert CandidateRequirementResults;
    }
    
    @isTest static void testContractTriggerV1(){
        TestClassUtil.isForNewTrigger();
        Test.startTest();
        List<Contract> ContractResults = [Select id,Status,recordTypeId from Contract Where Status = 'Draft' Limit 10];
        ContractResults[0].Status = 'Completed';
        ContractResults[1].RecordTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract', 'CPE');
        ContractResults[1].All_Requirements_Completed__c = true;
        ContractResults[1].StartDate = date.newInstance(date.today().year()-1, 1, 1 );
        ContractResults[1].Status = 'Completed';
        for(Contract cont : ContractResults){
            if(cont.RecordTypeId == RecordTypeHelper.getRecordTypeIdFromSchema('Contract', 'SCR_Program')){
                cont.Status = 'Completed';
                break;
            }
        }
        update ContractResults;
        Test.stopTest();
    }
    
    @isTest static void testContractTriggerV2(){
        TestClassUtil.isForNewTrigger();
        test.startTest();
        List<Contract> ContractResults = [Select id,Status from Contract Where Status = 'Completed' Limit 10];
        ContractResults[0].RecordTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract', 'Membership');
        ContractResults[0].Status = 'Activated ( Auto-Renew )';
        ContractResults[0].KPI_Last_Updated__c = yesterday;
        ContractResults[0].All_Requirements_Completed__c = false;
        update ContractResults;
        test.stopTest();
    }
    
    @isTest static void testContractTriggerV3(){
        TestClassUtil.isForNewTrigger();
        test.startTest();
        List<Contract> ContractResults = [Select id,Status from Contract Where Status = 'Activated ( Auto-Renew )' Limit 10];
        ContractResults[0].RecordTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract', 'ERP_Program');
        ContractResults[0].Status = 'Completed';
        ContractResults[0].All_Requirements_Completed__c = true;
        update ContractResults;
        test.stopTest();
    }
    
    @isTest static void testContractTriggerV4(){
        TestClassUtil.isForNewTrigger();
        test.startTest();
        List<Contract> ContractResults = [Select id,Status from Contract Where Status = 'Activated ( Auto-Renew )' Limit 10];
        ContractResults[0].RecordTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract', 'ERP_Program');
        ContractResults[0].All_Requirements_Completed__c = true;
        ContractResults[0].StartDate = date.newInstance(date.today().year()-1, 1, 1 );
        update ContractResults;
        test.stopTest();
    }
    
    @isTest static void testContractTriggerV5(){
        TestClassUtil.isForNewTrigger();
        test.startTest();
        List<Contract> ContractResults = [Select id,Status from Contract Where Status = 'Activated ( Auto-Renew )' Limit 10];
        ContractResults[0].RecordTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract', 'CPE');
        ContractResults[0].All_Requirements_Completed__c = true;
        ContractResults[0].StartDate = date.newInstance(date.today().year()-1, 1, 1 );
        ContractResults[0].Status = 'Completed';
        update ContractResults;
        test.stopTest();
    }
    
    @isTest static void testContractTriggerV5_1(){
        TestClassUtil.isForNewTrigger();
        test.startTest();
        List<Contract> ContractResults = [Select id,Status from Contract Where Status = 'Activated ( Auto-Renew )' Limit 10];
        ContractResults[0].RecordTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract', 'SCR_Program');
        ContractResults[0].All_Requirements_Completed__c = true;
        ContractResults[0].StartDate = date.newInstance(date.today().year()-1, 1, 1 );
        ContractResults[0].Status = 'Activated';
        update ContractResults;
        test.stopTest();
    }
    
    @isTest static void testContractTriggerV6(){
        TestClassUtil.isForNewTrigger();
        test.startTest();
        List<Contract> ContractResults = [Select id,Status from Contract Where Status = 'Activated ( Auto-Renew )' Limit 10];
        ContractResults[0].RecordTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract', 'SCR_Program');
        ContractResults[0].All_Requirements_Completed__c = true;
        ContractResults[0].StartDate = date.newInstance(date.today().year()-1, 1, 1 );
        ContractResults[0].Status = 'Completed';
        update ContractResults;
        test.stopTest();
    } 
    
    @isTest static void testContractTriggerV7(){
        TestClassUtil.isForNewTrigger();
        test.startTest();
        List<Contract> ContractResults = [Select id,Status from Contract Where Status = 'Draft' Limit 10];
        ContractResults[0].RecordTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract', 'ERP_Program');
        ContractResults[0].Status = 'Activated';
        ContractResults[0].All_Requirements_Completed__c = true;
        update ContractResults;
        test.stopTest();
    } 
    
    @isTest static void testContractTriggerV8(){
        TestClassUtil.isForNewTrigger();
        test.startTest();
        List<Contract> ContractResults = [Select id,Status from Contract Where Status = 'Draft' Limit 10];
        Recordtype Recordtype = RecordTypeHelper.GetRecordType('Contract', 'ICBRR Program');
        RecordTypeHelper.GetRecordTypeName(Recordtype.id);        
        ContractResults[0].RecordTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract', 'ICBRR_Program');
        ContractResults[0].Status = 'Activated';
        ContractResults[0].All_Requirements_Completed__c = true;
        update ContractResults;
        test.stopTest();
    }
    
    @isTest static void test_StoppingChargentSFAPayment(){
        TestClassUtil.isForNewTrigger();
        test.startTest();
        List<Contract> ContractResults = [Select id,Status from Contract Where Status = 'Activated ( Auto-Renew )' AND Membership_type__C = 'student' Limit 10];
		system.debug('ContractResults::>>   '+ContractResults);
        ContractResults[0].All_Requirements_Completed__c = true;
        ContractResults[0].StartDate = date.newInstance(date.today().year()-1, 1, 1 );
        ContractResults[0].Status = 'Completed';
        update ContractResults;
        test.stopTest();
    }
    
}