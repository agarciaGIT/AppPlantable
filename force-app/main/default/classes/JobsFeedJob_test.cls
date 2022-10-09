@isTest
public class JobsFeedJob_test {

    static testMethod void unitTest_1(){
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        string CRON_EXP = '0 0 0 15 3 ? 2025';
        System.schedule('ScheduleApexClassTest',
                        CRON_EXP, 
                        new JobsFeedJob());
        test.stopTest();
    }
}