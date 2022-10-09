@isTest

public class setCaseEmailBatchTest{
    
    static void testdata(){
       
        Case ca = new Case(
            recordtypeid ='012400000005iFW', status = 'closed'
            );
        INSERT ca; 
        
        EmailMessage emess = New EmailMessage(FromAddress ='abcgs@garp.com', ToAddress= 'testing@gmail.com', Status = '3',
                                              ParentId = ca.Id);
        Insert emess;
    }   
    
    public static testmethod void myunittest()
        {
        test.starttest();
        testdata();
        setCaseEmailBatch batch = new setCaseEmailBatch();
        Database.executeBatch(batch);
        Test.stopTest();
     
    }
       
}