@isTest
public class schedBatchContentAnalyticsBuckets_test {

        Public static testMethod void MyUnitTest()
        {
        test.starttest();
        scheduleBatchContentAnalyticsBuckets s1= new scheduleBatchContentAnalyticsBuckets();
        system.schedule('Test Schedule','0 0 0 * * ?',s1);
        Test.stoptest();
        }

    
}