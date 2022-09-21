@isTest 
public class RESTInventoryController_test {

    public static void setup(){        
        
        Inventory_Projection__c ip = new Inventory_Projection__c(Name='IP', Shipping_Date__c=Date.newInstance(2019, 3, 4), Order_Limit__c=250);
        insert ip;

    }
    
 	@isTest
    private static void test1(){
        setup();
        Test.startTest();    
                        
        RESTProductsController.processRequest('');
        
        RestRequest req = new RestRequest();
        
        //String jsonReq = '{"grant_type":"password","client_id":"123","client_secret":"ABC","username":"user","password":"password"}';

		RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        request.requestUri ='https://parcopy-euphebe.cs95.force.com/services/apexrest/inventory?date=March 4, 2019&product=Reboot';
        request.httpMethod = 'GET';
        
        request.addParameter('date','March 4, 2019');
        request.addParameter('product','Reboot');
        
        RestContext.request = request;
        RestContext.response = response;        
        
        RESTInventoryController.getIventory();
        
        //RESTInventoryController.respInventoryAvailableItem ri = RESTInventoryController.processGetDate('March 4, 2019','Reboot');
        //RESTInventoryController.respInventoryAvailableItem ri1 = RESTInventoryController.processGetDate('March 4, 2019','Quickstart');
        //RESTInventoryController.respInventoryAvailableItem ri2 = RESTInventoryController.processGetDate('March 4, 2019','Subscription');

        RESTInventoryController.parseShippingDate('January 1, 2019');
        RESTInventoryController.parseShippingDate('February 1, 2019');
        RESTInventoryController.parseShippingDate('April 1, 2019');
        RESTInventoryController.parseShippingDate('May 1, 2019');
        RESTInventoryController.parseShippingDate('June 1, 2019');
        RESTInventoryController.parseShippingDate('July 1, 2019');
        RESTInventoryController.parseShippingDate('August 1, 2019');
        RESTInventoryController.parseShippingDate('September 1, 2019');
        RESTInventoryController.parseShippingDate('October 1, 2019');
        RESTInventoryController.parseShippingDate('November 1, 2019');
        RESTInventoryController.parseShippingDate('December 1, 2019');
        
        
        Test.stopTest();        
    }    
    
}