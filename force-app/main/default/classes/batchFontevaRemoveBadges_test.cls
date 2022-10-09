@isTest
Public class batchFontevaRemoveBadges_test
{
    Public static testMethod void MyUnitTest()
    {
        
        OrderApi__Badge__c newBadge = new OrderApi__Badge__c(
                    OrderApi__Contact__c = NULL,
                    OrderApi__Account__c = NULL,
                    OrderApi__Badge_Type__c = NULL,
                    OrderApi__Is_Active__c = FALSE
                );
        insert newBadge;
        
        test.starttest();
        scheduleBatchFontevaRemoveBadges s1= new scheduleBatchFontevaRemoveBadges();
        system.schedule('Test Schedule','0 0 0 * * ?',s1);
        Test.stoptest();
    }
    
}