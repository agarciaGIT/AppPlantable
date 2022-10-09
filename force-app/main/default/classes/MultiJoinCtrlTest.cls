@isTest
private class MultiJoinCtrlTest {
	
    @isTest private static void testUtilMethods() {
        Account acct1 = new Account(Name = 'Test 1');
        Account acct2 = new Account(Name = 'Test 2');
        insert new Account[]{acct1, acct2};
            
        Contact cont1 = new Contact(FirstName = 'Apexia', LastName = 'Testo', Email = 'apexTest@test.com', AccountId = acct1.Id);
        insert cont1;
        
        // Start Test
        MultiJoinCtrl.loadUseSaveFeature();
        
        try {
            MultiJoinCtrl.loadRecentQuery();
        }catch(Exception e) {
            System.debug(e);
        }
        
        try {
            MultiJoinCtrl.loadObjectList('SELECT Id, Name FROM Account', true);
        }catch(Exception e) {
            System.debug(e);
        }
        
        List<MultiJoinCtrl.SubQuery> subList = new List<MultiJoinCtrl.SubQuery>();
        MultiJoinCtrl.SubQuery subQry = new MultiJoinCtrl.SubQuery();
        subQry.index = 'subQry1';
        subQry.lookup = 'AccountId';
        subQry.qry = 'SELECT Id, Name FROM Contact';
        subList.add(subQry);
        
        try {
            MultiJoinCtrl.saveAllQueries('SELECT Id, Name FROM Account', subList);
        }catch(Exception e) {
            System.debug(e);
        }

        MultiJoinCtrl.loadSubQueries(subList, new Id[]{acct1.Id, acct2.Id});
    }
    
}