@isTest
public class SFMC_integrationTestClass {
	 @isTest
    public static void UpdateSubscriber() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Mock_SFMCIntegrationClass());
        SFMC_integrationClass sfmc = new SFMC_integrationClass();
        SFMC_integrationClass.UpdateSubscriber();
        Test.stopTest();
    }
}