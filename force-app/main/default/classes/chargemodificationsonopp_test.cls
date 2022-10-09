@isTest
private class chargemodificationsonopp_test{

   
    Static Account acc;
    Static Account acc1;
     
     static void testData()
     {
         List<Account> accList = new List<Account>();         
         acc1 = new Account(name = 'Test Account2', Calculated_Expire_Date__c = system.today(), Last_Contract_Exp_Calc__c = system.today());
         accList.add(acc1);
         acc = new Account(name = 'Test Account1', Calculated_Expire_Date__c = system.today(), Last_Contract_Exp_Calc__c = system.today());
         accList.add(acc);
         insert accList;
         
         Contact contact = new Contact(LEGACY_PK_PID__c  = '123',lastname = 'Test',AccountId = acc.id,email='test@test.com',KPI_Last_Updated_Date__c = system.today());
         insert contact; 
         
         List<Opportunity> oppList = new List<Opportunity>();
         Opportunity opp1 = new Opportunity(accountId = acc1.id,Auto_Renew__c = true,ChargentSFA__Payment_Status__c='Recurring',Company__c = 'GARP',ChargentSFA__Payment_Frequency__c='Once',name='Test Name',StageName='New',CloseDate=system.today(),ChargentSFA__Charge_Amount__c=95);
         oppList.add(opp1);
         Opportunity opp = new Opportunity(accountId = acc.id,Auto_Renew__c = true,ChargentSFA__Payment_Status__c='Recurring',Company__c = 'GARP',ChargentSFA__Payment_Frequency__c='Once',name='Test Name',StageName='New',CloseDate=system.today(),ChargentSFA__Charge_Amount__c=95);
         oppList.add(opp);
         insert oppList;
         
         string memRecordType = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
         string frmRecordType = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program');
         
         contract program = new contract (AccountID = acc.id, status = 'Draft', CurrencyIsoCode = 'USD',Name= 'Test Contract',startDate = system.today(),Membership_Type__c = 'Student',recordTypeId=memRecordType);
         insert program;
         
         Contract Contract4  = new Contract(recordtypeId = frmRecordType ,Opportunity__c = opp.id, AccountId = opp.AccountId ,ContractTerm = 12,StartDate = opp.CloseDate);
         insert contract4;
         contract4.Status = 'completed';
         update contract4;
         
       
       
         
     }
     
     static testMethod void UnitTest_1()
    {
        testData();
        test.startTest();
        chargemodificationsonopp  b = new chargemodificationsonopp();
        database.executeBatch(b);
        test.stopTest();
    }
}