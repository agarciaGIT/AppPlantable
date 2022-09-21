@isTest 
public class activeCustomerController_test {
    
    Static Account acct;
	Static Contact cont;
    Static Opportunity opp1;
    Static Opportunity opp2;
    
     public static void setup(){

        acct = new Account(Name='Account', Batch_Last_KPI__c=null, BillingStreet='25 Jackson\n\rApt 1C');
        insert acct;
        
        cont = new Contact(Email='a@a.com', AccountId=acct.Id, LastName = 'last');
        insert cont;
        
        opp1 = new Opportunity(Name='Opp1', CloseDate=Date.newInstance(2016, 1, 1), StageName='Closed Won', Amount=100, AccountId=acct.Id);
        insert opp1;

        opp2 = new Opportunity(Name='Opp1', CloseDate=Date.newInstance(2017, 1, 1), StageName='Closed Won', Amount=100, AccountId=acct.Id);
        insert opp2;

     }

    
    @isTest
    private static void testMethods(){
        
        setup();
        Test.startTest();   
        
        activeCustomerController ac = new activeCustomerController();
        
        Test.stopTest();
    }
}