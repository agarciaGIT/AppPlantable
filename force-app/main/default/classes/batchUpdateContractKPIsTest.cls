@isTest
public class batchUpdateContractKPIsTest {
    
    
    public static testmethod void test() {
        
        Account acc = new Account(
            Name = 'TestAccount',
            RecordTypeId = RecordTypeHelper.GetRecordTypeId('Account','Individual'),
            CurrencyIsoCode  = 'USD'
        );
        insert acc;
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Contract; 
        Map<String,Schema.RecordTypeInfo> ContractRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = ContractRecordTypeInfo .get('Membership').getRecordTypeId();
        Contract con = new Contract(AccountId = acc.id,recordTypeId = rtId,Membership_Type__c='Individual', StartDate = Date.newInstance(2017, 1, 1), ContractTerm = 12);
        insert con ;
        
        con.Status = 'Activated';
        update con;
        
        Test.startTest();
        batchUpdateContractKPIs c = new batchUpdateContractKPIs('inc');
        Database.executeBatch(c);
        
        batchUpdateContractKPIs c1 = new batchUpdateContractKPIs('all');
        Database.executeBatch(c1);
        
        scheduleBatchUpdateContractKPIs s1= new scheduleBatchUpdateContractKPIs();
        system.schedule('Test Schedule','0 0 0 * * ?',s1);
        
        
        Test.stopTest();
        
    }
}