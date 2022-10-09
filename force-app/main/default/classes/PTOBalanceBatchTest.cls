// Covers PTOBalanceBatch and PTOAnniversaryCtrl
@isTest
private class PTOBalanceBatchTest {
	
    @isTest
    private static void testBatch() {
        Integer targetYear = System.today().year() + 1;
        
        User u1 = TestingHelper.createUser('System Administrator', 'nosuchuser1@nomail.com', false);
        u1.Start_Date_with_Company__c = Date.newInstance(targetYear, 1, 1).addMonths(-12);
        
        User u2 = TestingHelper.createUser('System Administrator', 'nosuchuser2@nomail.com', false);
        u2.SVP_and_Above__c = true;
        u2.alias = 'tst9528';
        u2.Start_Date_with_Company__c = Date.newInstance(targetYear, 1, 1).addMonths(-12);
        
        User u3 = TestingHelper.createUser('System Administrator', 'nosuchuser3@nomail.com', false);
        u3.alias = 'tst9529';
        u3.Start_Date_with_Company__c = Date.newInstance(targetYear, 1, 1).addMonths(-49);
        
        User u4 = TestingHelper.createUser('System Administrator', 'nosuchuser4@nomail.com', false);
        u4.alias = 'tst9530';
        u4.SVP_and_Above__c = true;
        u4.Start_Date_with_Company__c = Date.newInstance(targetYear, 1, 1).addMonths(-49);
        
        List<User> employees = new List<User>{u1, u2, u3, u4};
        for(User u : employees) {
            u.Is_VayKay_User__c = true;
        }
        insert employees;
        
        Test.startTest();
        PTOBalanceBatch batchObj = new PTOBalanceBatch(50, true, null, false);
        Database.executeBatch(batchObj);
        Test.stopTest();
        
        Map<Id, User> userWithBalance = new Map<Id, User>([
            SELECT Id, Name, 
            (
                SELECT Id, Name, Vaykay__Balance_Start_Date__c, Vaykay__Balance_End_Date__c, Vaykay__Vacation_Days_Allotted__c 
                FROM Vaykay__Time_Off_Balances__r
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
    
    /*
    @isTest
    private static void testAnniversaryJob() {
        User u = TestingHelper.createUser('Marketing', 'nosuchuser2@nomail.com', false);
        u.SVP_and_Above__c = true;
        u.alias = 'tst9531';
        u.Start_Date_with_Company__c = Date.today().addMonths(-48);
        u.Is_VayKay_User__c = true;
        insert u;
        
        Test.startTest();
        System.schedule('Test PTO Balance Anniversary Check', '0 30 23 * * ?', new PTOBalanceBatch(1,false,null,false));
        Test.stopTest();
        
        u = [SELECT Id, Name,
             (SELECT Id, Name, Vaykay__Year__c, Vaykay__Vacation_Days_Allotted__c 
             FROM Vaykay__Time_Off_Balances__r) FROM User WHERE Id = :u.Id];
        
        //System.assertEquals(25, u.Vaykay__Time_Off_Balances__r[0].Vaykay__Vacation_Days_Allotted__c);
        //System.assertEquals(String.valueOf(System.today().year()), u.Vaykay__Time_Off_Balances__r[0].Vaykay__Year__c);
    }
*/
}