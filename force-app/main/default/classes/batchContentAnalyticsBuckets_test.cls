@isTest
public class batchContentAnalyticsBuckets_test {

    //select Id, Name, Bucket1__c, Bucket2__c, Trend__c  from Content__c where View_Count__c > 0
    //
    Static Content_Analytic__c cont1;
    Static Content_Analytic__c cont2;
    
     static void testData()
     {
        cont1 = new Content_Analytic__c(name = 'Test Content1', Bucket1__c = 100, Bucket2__c=0, Trend__c=0, Count__c=100);
        insert cont1;
    
        cont2 = new Content_Analytic__c(name = 'Test Content2', Bucket1__c = 100, Bucket2__c=200, Trend__c=1000, Count__c=200);
        insert cont2;

     }
     
    static testMethod void UnitTest_1()
    {
        testData();
        test.startTest();
        batchContentAnalyticsBuckets b = new batchContentAnalyticsBuckets(1,'swap',NULL);
        database.executeBatch(b);

        batchContentAnalyticsBuckets b1 = new batchContentAnalyticsBuckets(2,'swap',NULL);
        database.executeBatch(b1);

        batchContentAnalyticsBuckets b2 = new batchContentAnalyticsBuckets(1,'clear',NULL);
        database.executeBatch(b2);

        batchContentAnalyticsBuckets b3 = new batchContentAnalyticsBuckets(2,'clear',NULL);
        database.executeBatch(b3);

        batchContentAnalyticsBuckets b4 = new batchContentAnalyticsBuckets(1,'swap',cont1.Id);
        database.executeBatch(b4);
        
        test.stopTest();
    }  
    
}