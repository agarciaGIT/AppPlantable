@isTest
private class GARPPTOBalanceBatchTest {
  
    @isTest
    private static void testBatch() {
        Integer targetYear = System.today().year() + 1;
        
        User u1 = TestingHelper.createUser('GARP Marketing', 'nosuchuser1@nomail.com', false);
        u1.Start_Date_with_Company__c = Date.newInstance(targetYear, Date.today().month(), Date.today().day()).addMonths(-12);
        u1.PTO_Office__c = 'NJ';
        
        User u2 = TestingHelper.createUser('GARP Marketing', 'nosuchuser2@nomail.com', false);
        u2.SVP_and_Above__c = true;
        u2.alias = 'tst9528';
        u2.PTO_Office__c = 'NJ';
        u2.Start_Date_with_Company__c = Date.newInstance(targetYear, Date.today().month(), Date.today().day()).addMonths(-12);
        
        User u3 = TestingHelper.createUser('Accounting', 'nosuchuser3@nomail.com', false);
        u3.alias = 'tst9529';
        u3.PTO_Office__c = 'NJ';
        u3.Start_Date_with_Company__c = Date.newInstance(targetYear, 1, 1).addMonths(-49);
        
        User u4 = TestingHelper.createUser('Accounting', 'nosuchuser4@nomail.com', false);
        u4.alias = 'tst9530';
        u4.SVP_and_Above__c = true;
        u4.PTO_Office__c = 'NJ';
        u4.Start_Date_with_Company__c = Date.newInstance(targetYear, Date.today().month(), Date.today().day()).addMonths(-49);
        
        List<User> employees = new List<User>{u1, u2, u3, u4};
        insert employees;
        
        GARP_Time_Off_Balance__c gtob = new GARP_Time_Off_Balance__c(Employee__c = employees[0].Id, Vacation_Days_Allottment__c = 1, Start_Date__c = Date.newInstance(targetYear, 1, 1), End_Date__c = Date.newInstance(targetYear, 12, 31));
		insert gtob;
        
        Test.startTest();
        GARPTimeOffBalanceBatch batchObj = new GARPTimeOffBalanceBatch(50, true, null, false);
        Database.executeBatch(batchObj);

        GARPTimeOffBalanceBatch batchObj1 = new GARPTimeOffBalanceBatch(50, false, null, false);
        Database.executeBatch(batchObj1);


        Test.stopTest();
        
        Map<Id, User> userWithBalance = new Map<Id, User>([
            SELECT Id, Name, 
            (
                SELECT Id, Name, Start_Date__c, End_Date__c, Vacation_Days_Allottment__c 
                FROM GARP_Time_Off_Balances__r 
            ) 
            FROM User WHERE Id IN :employees
        ]);
        
    u1 = userWithBalance.get(u1.Id);
        //System.assertEquals(15, u1.Vaykay__Time_Off_Balances__r[0].Vaykay__Vacation_Days_Allotted__c);
        //System.assertEquals(Date.newInstance(targetYear, 1, 1), u1.Vaykay__Time_Off_Balances__r[0].Vaykay__Balance_Start_Date__c);
        //System.assertEquals(Date.newInstance(targetYear, 12, 31), u1.Vaykay__Time_Off_Balances__r[0].Vaykay__Balance_End_Date__c);
        //System.assertEquals(u1.Name + ': 1/1/' + targetYear + ' to 12/31/' + targetYear, u1.Vaykay__Time_Off_Balances__r[0].Name);
        
        u2 = userWithBalance.get(u2.Id);
        //System.assertEquals(20, u2.Vaykay__Time_Off_Balances__r[0].Vaykay__Vacation_Days_Allotted__c);
        
        u3 = userWithBalance.get(u3.Id);
        //System.assertEquals(20, u3.Vaykay__Time_Off_Balances__r[0].Vaykay__Vacation_Days_Allotted__c);
        
        u4 = userWithBalance.get(u4.Id);
        //System.assertEquals(25, u4.Vaykay__Time_Off_Balances__r[0].Vaykay__Vacation_Days_Allotted__c);
    }    
}