@isTest
public class batchCPDParticipantsQuarterlyTest {
   
    Static Contact cont1;
    Static Contact cont2;
           
   static void testData() 
   {
       cont1 = new Contact(LastName='Test1', CPE_Current_Program_Requirement__c = 'Count1', KPI_CPE_Participation__c = true, KPI_CPE_Current_Cycle__c = '2015', CPD_Last_Quarterly_Sent__c = system.today(), do_not_fire__c=true);
       insert cont1;
       
       cont2 = new Contact(LastName='Test2', CPE_Current_Program_Requirement__c = 'Count2', KPI_CPE_Participation__c = true, KPI_CPE_Current_Cycle__c = '2016', CPD_Last_Quarterly_Sent__c = system.today(), do_not_fire__c=true);
       insert cont2;
       
   }
    
    static testMethod void UnitTest()
    {
        testData();
        
        test.startTest();
        
        batchCPDParticipantsQuarterly b = new batchCPDParticipantsQuarterly('2015/2016',NULL);
        database.executeBatch(b);

        batchCPDParticipantsQuarterly b1 = new batchCPDParticipantsQuarterly('2015',NULL);
        database.executeBatch(b1);

        batchCPDParticipantsQuarterly b2 = new batchCPDParticipantsQuarterly('2016',NULL);
        database.executeBatch(b2);
        
        batchCPDParticipantsQuarterly b3 = new batchCPDParticipantsQuarterly('2016/2017',NULL);
        database.executeBatch(b3);
              
        test.stopTest();
    }  
    
}