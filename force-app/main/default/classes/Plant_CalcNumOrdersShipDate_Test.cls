@isTest
public class Plant_CalcNumOrdersShipDate_Test {
    
    
    private static List<Plant_Shipping_Date__c> makeDates(){
        List<Plant_Shipping_Date__c> dates = new List<Plant_Shipping_Date__c>();
        dates.add(new Plant_Shipping_Date__c(Name='Today', Plant_Shipping_Date__c = Date.Today()));
        dates.add(new Plant_Shipping_Date__c(Name='Today+5', Plant_Shipping_Date__c = Date.Today() + 5));
        insert dates;
        return dates;
    }
    private static List<Plant_Order_Properties__c> makeOrders(List<Plant_Shipping_Date__c> dates){
        List<Plant_Order_Properties__c> orders = new List<Plant_Order_Properties__c>();
        Account testAccount = new Account(Name='Test');
        testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        insert testAccount;
        for(Integer i = 0; i < 200; i++){
            Id recordType = Schema.SObjectType.Plant_Order_Properties__c.getRecordTypeInfosByName().get('A-la-carte').getRecordTypeId();
            Plant_Order_Properties__c order = new Plant_Order_Properties__c(RecordTypeId = recordType);
            order.Plant_Recurrence__c = 'Once';
            order.Plant_Status__c = 'Paid';
            order.Plant_Shipping_Date__c = dates[0].Id;
            order.Plant_Account__c = testAccount.Id;
            orders.add(order);
        }
        insert orders;
        return orders;
    }
    //test insertion of new order properties record with shipping date
    @isTest static void insertOrderPropertiesTest(){ 
        Test.startTest();
        List<Plant_Shipping_Date__c> dates = makeDates();
        List<Plant_Order_Properties__c> orders = makeOrders(dates);
        Test.stopTest();
        System.assertEquals(200, [SELECT Id, Plant_Total_Orders__c FROM Plant_Shipping_Date__c WHERE Id = :dates[0].Id].Plant_Total_Orders__c);
    }
    
    //test updating order properties record to new date
    @isTest static void updateOrderPropertiesTest(){
        Test.startTest();
        List<Plant_Shipping_Date__c> dates = makeDates();
        List<Plant_Order_Properties__c> orders = makeOrders(dates);
        for(Plant_Order_Properties__c order : orders) order.Plant_Shipping_Date__c = dates[1].Id;
        update orders;
        Test.stopTest();

        System.assertEquals(0, [SELECT Id, Plant_Total_Orders__c FROM Plant_Shipping_Date__c WHERE Id = :dates[0].Id].Plant_Total_Orders__c);
        System.assertEquals(200, [SELECT Id, Plant_Total_Orders__c FROM Plant_Shipping_Date__c WHERE Id = :dates[1].Id].Plant_Total_Orders__c);
    }

    //test deleting order properties record
    @isTest static void deleteOrderPropertiesTest(){
        Test.startTest();
        List<Plant_Shipping_Date__c> dates = makeDates();
        List<Plant_Order_Properties__c> orders = makeOrders(dates);
        Database.delete(orders);
        Test.stopTest();

        System.assertEquals(0, [SELECT Id, Plant_Total_Orders__c FROM Plant_Shipping_Date__c WHERE Id = :dates[0].Id].Plant_Total_Orders__c);
        System.assertEquals(0, [SELECT Id, Plant_Total_Orders__c FROM Plant_Shipping_Date__c WHERE Id = :dates[1].Id].Plant_Total_Orders__c);
    }
}