@isTest
private class smartProsAPI_test{

	static Contact cont1;
    static Account acct1;
    static Opportunity opp1;    
    static void tesData() {

        acct1 = new Account(name = 'Test Account1',Profile_ID_Created_Date__c=system.today());
        insert acct1;
        
        cont1 = new Contact(FirstName='Test', LastName='Account', Company__c='GARP', Email='Test.Account@123.com', AccountID=acct1.Id, do_not_fire__c=true);
        insert cont1;
            
        opp1 = new Opportunity(Name='TestOpp', AccountID=acct1.Id, Amount=100.00, StageName='Closed', CloseDate=system.today());
    	insert opp1;
     }
  
      Private static testMethod void myUnitTest_1(){
        test.starttest();
        tesData();
        
		API_Transaction__c trans = smartProsAPI.UpdateUserStart(cont1.Id, cont1.Company__c, cont1.FirstName, cont1.LastName, cont1.Email);
        smartProsAPI.SendRequest(trans.Request__c, trans.Id);            

		trans = smartProsAPI.RecordPurchaseStart(cont1.Id, cont1.Company__c, cont1.FirstName, cont1.LastName, cont1.Email, opp1.Id);
        smartProsAPI.SendRequest(trans.Request__c, trans.Id);            

   		trans = smartProsAPI.cancelPurchaseStart(cont1.Id, opp1.Id);
        smartProsAPI.SendRequest(trans.Request__c, trans.Id);            

        test.stoptest();      
          
	}
}