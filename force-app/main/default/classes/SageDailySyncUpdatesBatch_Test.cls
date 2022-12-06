@isTest
public class SageDailySyncUpdatesBatch_Test {
    
    @isTest
    Static void unitTest(){
        
        Account Acc = new Account(Name = 'test',GARP_ID__c ='12345');
        insert acc;
        
        Id manualRecId = RecordTypeHelper.GetRecordTypeId('Opportunity','Manual'); 
        Opportunity opp = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,
                                          company__c = 'Payment', accountId = acc.id,stageName = 'New Lead',
                                          Program__c = 'Print' ,closedate = system.today()+ 15, 
                                          ia_crm__Intacct_Sync_Status_1__c = 'OK',Display_Invoice_Number__c = 'W123',ia_crm__Intacct_Sync_Errors_1__c = 'OK',
                                          ChargentSFA__Invoice_Number__c  = 'W123',ChargentSFA__Payment_Method__c = 'Credit Card');        
                
        insert opp;
        
        Opportunity opp1 = new Opportunity(amount = 123,Name = 'Test1',Eligible_for_Membership_Extension__c = false,
                                          company__c = 'Payment', accountId = acc.id,stageName = 'New Lead',
                                          Program__c = 'Print' ,closedate = system.today()+ 15, 
                                          ia_crm__Intacct_Sync_Status_1__c = 'Error',Display_Invoice_Number__c = 'W1234',ia_crm__Intacct_Sync_Errors_1__c = 'Error',
                                          ChargentSFA__Invoice_Number__c  = 'W1234',ChargentSFA__Payment_Method__c = 'Credit Card');        
                
        insert opp1;
        
        Test.startTest();
        System.schedule('SageDailySyncUpdatesBatchScheduler Testing', '0 0 0 * * ?', new SageDailySyncUpdatesBatchScheduler());
        Test.stopTest();
    }

}