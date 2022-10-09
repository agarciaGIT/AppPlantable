@isTest
public class TeamRegistrationTriggerHandler_Test {
	@isTest
    static void testTriggerHandler(){
        test.startTest();
        Id teamregRecTypeid = RecordTypehelper.getRecordTypeIdFromSchema('Team_Registration__c', 'Team_Registration');
        Team_Registration__c reg = new Team_Registration__c();
        reg.Exam_Type__c = 'FRM';
        reg.Name = 'Test Team Reg';
        reg.RecordTypeId = teamregRecTypeid;
        insert reg;
        test.stopTest();
    }
    
}