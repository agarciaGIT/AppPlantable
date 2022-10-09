@isTest
public class batchCorrect2015ExamAttempts_test {

    //select Id, Name, Bucket1__c, Bucket2__c, Trend__c  from Content__c where View_Count__c > 0
    //
    Static Exam_Attempt__c ea1;
    Static Exam_Attempt__c ea2;
    Static Exam_Attempt__c ea11;
    Static Exam_Attempt__c ea21;

    Static Contact con1;
    Static Exam_Sites__c es1;
    Static Exam_Sites__c es11;

    Static Exam__c e1;
    Static Exam__c e11;
    
     static void testData()
     {
        con1 = new Contact(LastName = 'Last');
         

        e1 = new Exam__c(name = 'Exam', Exam_Date__c = Date.newInstance(2015, 11, 21), Exam__c = 'FRM Part 1');
        insert e1;
         
        e11 = new Exam__c(name = 'Exam', Exam_Date__c = Date.newInstance(2015, 11, 21), Exam__c = 'FRM Part 2');
        insert e11;
         
        es1 = new Exam_Sites__c(name = 'Exam Site1', Exam__c = e1.Id);
        insert es1;

        es11 = new Exam_Sites__c(name = 'Exam Site1', Exam__c = e11.Id);
        insert es11;
         
        ea1 = new Exam_Attempt__c(name = 'Test EA1', Member__c = con1.Id, Exam_Site__c = es1.Id, Cancelled__c = true);
        insert ea1;
    
        ea2 = new Exam_Attempt__c(name = 'Test EA2', Member__c = con1.Id, Exam_Site__c = es1.Id, Cancelled__c = true);
        insert ea2;

        ea11 = new Exam_Attempt__c(name = 'Test EA1', Member__c = con1.Id, Exam_Site__c = es11.Id, Cancelled__c = true);
        insert ea11;
    
        ea21 = new Exam_Attempt__c(name = 'Test EA2', Member__c = con1.Id, Exam_Site__c = es11.Id, Cancelled__c = false, Canceled_Reason_Type__c = 'Expired');
        insert ea21;

         
     }
     
    static testMethod void UnitTest_1()
    {
        testData();
        test.startTest();
        batchCorrect2015ExamAttempts b = new batchCorrect2015ExamAttempts(NULL);
        database.executeBatch(b);

        batchCorrect2015ExamAttempts b1 = new batchCorrect2015ExamAttempts('reset');
        database.executeBatch(b1);
        
        test.stopTest();
    }  
    
}