@isTest
private class UserTriggerHelperTest {

    @isTest static void testCommunityUserChangeLocale() {
        String conEmail = 'apex_tester123@noemail.com';
        Contact con = TestingHelper.createContact(conEmail, true, true);
        
        User user = [SELECT Id, LocaleSidKey FROM User WHERE ContactId = :con.Id];
        
        Test.startTest();
        System.runAs(user) {
            try {
                user.LocaleSidKey = 'zh_CN';
                update user;
            }catch(Exception e) {
                System.debug(e);
                System.assert(e.getMessage().contains(Label.SiteUserLocaleMsg));
            }
        }
        Test.stopTest();
    }
    
}