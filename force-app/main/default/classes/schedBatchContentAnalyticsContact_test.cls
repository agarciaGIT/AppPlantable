@isTest
public class schedBatchContentAnalyticsContact_test {

        Public static testMethod void MyUnitTest()
        {
        test.starttest();
        scheduleBatchContentAnalyticsContact s1= new scheduleBatchContentAnalyticsContact();
        system.schedule('Test Schedule','0 0 0 * * ?',s1);
        Test.stoptest();
        }

    
}