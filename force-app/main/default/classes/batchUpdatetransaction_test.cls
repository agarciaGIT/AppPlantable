@isTest

public class batchUpdatetransaction_test{

    static Account acc;
    static contact con;
    static Opportunity opp;
    static ChargentSFA__Transaction__c ct;
   
    
    static void testData(){
        Acc = new Account(Name = 'test', Member_Email__c='vvkat@g.com');
        insert acc;
         
        con = new contact(lastname='vv',email='vvkat@g.com',accountid=acc.id);
        insert con;
        con.email='vf1@f.com';
        update con;
        contactHistory hist=new contactHistory(Field='email',contactId =con.Id);
        insert hist;
        
        
        ChargentBase__Gateway__c chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
       
         
        opp = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = acc.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()- 100);        
        insert opp;
        
       ct = new ChargentSFA__Transaction__c(ChargentSFA__Opportunity__c=opp.id, ChargentSFA__Credit_Card_Number__c='123');

      
        
       
        
    }
    
    static testMethod void unitTest_1(){
    
       
        test.startTest();
        testData();
        batchUpdatetransaction transaction1 = new batchUpdatetransaction();
        Database.executebatch(transaction1);
        test.stopTest();
    }


}