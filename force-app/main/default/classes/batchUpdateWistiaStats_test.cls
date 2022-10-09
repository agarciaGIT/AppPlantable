@isTest
public class  batchUpdateWistiaStats_test{

    static void testdata()
    {
        String vidRecType = recordtypehelper.getRecordtypeID('Content__c','Video');
        Content__c c = new Content__c(name='Video', View_Count__c=0, Share_Count__c=0, Content_Name__c='Video', Duration_in_Minutes__c=1, SKU__c='abc', External_ID__c='1234',Description__c='Video', Image__c=null, RecordTypeId=vidRecType);
        insert c;
    }
    
    static testMethod void UnitTest_1()
    {
        testdata();
        test.starttest();
        scheduleBatchUpdateWistiaStats s1= new scheduleBatchUpdateWistiaStats();
        system.schedule('Test Schedule','0 0 0 * * ?',s1);
        Test.stoptest();
    }

}