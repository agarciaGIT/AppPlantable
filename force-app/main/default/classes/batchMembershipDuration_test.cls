@isTest
public class batchMembershipDuration_test {
    
    Static Contact contact;
    Static Account account;
    Static Contract contract1;
    Static Contract contract2;
    Static Opportunity opp;
    
    
	public static void setup(){
        
        account = new Account(Name = 'test');
        insert account;
         
        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@garpautoqaqatesting.com',MailingCountry='China', Membership_Type__c = 'Individual');        
    	insert contact;
        
        opp = new Opportunity(Name='Mem', StageName='Closed',Member_Status__c='Individual New Comp', CloseDate=system.today());
        insert opp;
        
        String membershipContractId = recordtypehelper.getRecordtypeID('Contract','Membership');
        contract1 = new Contract(AccountId = account.id, Status='Draft', Membership_Type__c = 'Individual', Opportunity__c = opp.Id, RecordTypeId=membershipContractId, StartDate = Date.newInstance(2015, 1, 1), ContractTerm=12);
		insert contract1;     
		contract1.Status = 'Expired';
		update contract1;
                
        contract2 = new Contract(AccountId = account.id, Status='Draft', Membership_Type__c = 'Individual', Opportunity__c = opp.Id, RecordTypeId=membershipContractId, StartDate = Date.newInstance(2016, 1, 1), ContractTerm=12);
		insert contract2;     
		contract2.Status = 'Expired';
		update contract2;
        
    }
    
    @isTest
    private static void testBatch(){
        
        setup();
        Test.startTest();    
                
        batchMembershipDuration batch = new batchMembershipDuration(2017,null);
        Database.executeBatch(batch);

        Test.stopTest();        
    }

}