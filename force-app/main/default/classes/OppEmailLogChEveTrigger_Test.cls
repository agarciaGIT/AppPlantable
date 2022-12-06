@isTest
private class OppEmailLogChEveTrigger_Test {
    
    @isTest
    Private static void UnitTest(){
        
        // Enable all Change Data Capture entities for notifications.
        System.Test.enableChangeDataCapture();
        
        Account Acc = new Account(Name = 'test');
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.AccountID= acc.ID;
        opp.Name = 'Test';
        opp.stageName = 'Closed';
        opp.Payment_Method_New__c='Credit Card';
        opp.Billing_Address__c ='Address';
        opp.Billing_Address_Line_2__c='Address 2';
        opp.Billing_City__c='City';
        opp.Billing_Company__c='Company';
        opp.Billing_Country__c='USA';
        opp.Billing_Email__c='test123@gmail.com';
        opp.Billing_Fax__c='Fax';
        opp.Billing_First_Name__c='Name';
        opp.Billing_Last_Name__c='Last';
        opp.closedate = system.today();
        Insert opp;
                       
        opp.Billing_Email__c='test12@gmail.com';
        update opp;
        
        //Call deliver to fire the trigger for the update operation.
        System.Test.getEventBus().deliver();
        
        Test.StartTest();
        OppEmailLogFromPlatEve.callOppLog((String)opp.id);
        Test.StopTest();
    }
}