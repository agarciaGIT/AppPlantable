@isTest
public class batchContentBuckets_test {

    //select Id, Name, Bucket1__c, Bucket2__c, Trend__c  from Content__c where View_Count__c > 0
    //
    Static Content__c cont1;
    Static Content__c cont2;
    
     static void testData()
     {
        cont1 = new Content__c(name = 'Test Content1', Bucket1__c = 100, Bucket2__c=0, Trend__c=0, View_Count__c=100);
        insert cont1;
    
        cont2 = new Content__c(name = 'Test Content2', Bucket1__c = 100, Bucket2__c=200, Trend__c=1000, View_Count__c=200);
        insert cont2;

     }
     
    static testMethod void UnitTest_1()
    {
        testData();
        test.startTest();
        batchContentBuckets b = new batchContentBuckets(1,'swap',NULL);
        database.executeBatch(b);

        batchContentBuckets b1 = new batchContentBuckets(2,'swap',NULL);
        database.executeBatch(b1);

        batchContentBuckets b2 = new batchContentBuckets(1,'clear',NULL);
        database.executeBatch(b2);

        batchContentBuckets b3 = new batchContentBuckets(2,'clear',NULL);
        database.executeBatch(b3);

        batchContentBuckets b4 = new batchContentBuckets(1,'swap',cont1.Id);
        database.executeBatch(b4);
        
        test.stopTest();
    }  
    
}