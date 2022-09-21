/*
*   @Desciption     :   Class for creating test data 
*   @Create date    :   11-04-2022
*   @Author         :   Bhagwan S
_________________________________________________________________________________________________________________________________________________________
  	@Main Class		:	Plant_TestDataFactory
*/

@isTest
public class Plant_TestDataFactory_Test {

    // @ Default Constructor
    public Plant_TestDataFactory_Test() {

}
    
    // @ Method 1
    public testMethod static void TestDataFactory_Test(){
        Test.startTest();
        Plant_TestDataFactory TestFactory = new Plant_TestDataFactory();
        Plant_TestDataFactory pDataFactory = new Plant_TestDataFactory();
        Plant_TestDataFactory.createMeal(1);
        Plant_TestDataFactory.createAccounts(1);
        Plant_TestDataFactory.createMealSelection(1);
        Plant_TestDataFactory.createDiscountCode(1, 'Test', 'Reboot');
        Plant_TestDataFactory.createOrderProperties(1);
        Plant_TestDataFactory.createShippingAddress(1);
        Plant_TestDataFactory.createDeliverySchedule(1, 1);
        Plant_TestDataFactory.createShippingDate(1);
        Plant_TestDataFactory.createDishes(1);
        Test.stopTest();
    }
}