@isTest
public class scheduleBatchContentBuckets_test {

        Public static testMethod void MyUnitTest()
        {
        test.starttest();
        scheduleBatchContentBuckets s1= new scheduleBatchContentBuckets();
        system.schedule('Test Schedule','0 0 0 * * ?',s1);
        Test.stoptest();
        }

    
}