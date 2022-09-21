@isTest 
public class RESTProductsController_test {
    
    static Meal__c m;
    static Product2 p2;
    
    public static void setup(){        
            
		m = new Meal__c(Name='Meal',Description__c='Meal',API_Enabled__c=True);
        insert m;
        
    	Menu_Program__c mp = new Menu_Program__c(Name='MP', Start_Date__c=Date.newInstance(2016, 1, 1), Order_Cut_Off_Day__c='Friday', Order_Cut_Off_Time__c='06:00', Status__c = 'Active');
        insert mp;
                    
        Menu__c mu = new Menu__c(Name='Menu', Cycle__c=1, Menu_Program__c = mp.Id, Status__c = 'Active');
    	insert mu;
                    
        Menu_Entry__c me = new Menu_Entry__c(Name='ME', Meal__c = m.Id, Menu__c = mu.Id);
        insert me;
          
        Dish__c d = new Dish__c(Name='Dish', Meal__c = m.Id);
        insert d;
        
        Ingredient_Item__c ii = new Ingredient_Item__c(Name='Ing', Is_Allergen__c=true, Protein__c=1.0, Dish__c = d.Id);
        insert ii;

        Ingredient_Item__c ii2 = new Ingredient_Item__c(Name='Ing', Is_Allergen__c=true, Protein__c=3.0, Dish__c = d.Id);
        insert ii2;

        Dish__c d2 = new Dish__c(Name='Dish2', Meal__c = m.Id);
        insert d2;
        
        Ingredient_Item__c iia = new Ingredient_Item__c(Name='Ing', Is_Allergen__c=true, Protein__c=1.0, Dish__c = d2.Id);
        insert iia;

        Ingredient_Item__c ii2a = new Ingredient_Item__c(Name='Ing', Is_Allergen__c=true, Protein__c=3.0, Dish__c = d2.Id);
        insert ii2a;
        
        
        
        Product2 p1 = new Product2(Name='ZPEALC', ProductCode='ZPEALC',Available_to_External_Marketplace__c=True, Inventory__c=99,Menu_Program__c = mp.Id);
        insert p1;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pe1 = new PricebookEntry(Unitprice=100.00, Product2Id=p1.Id, Pricebook2Id=pricebookId);
        insert pe1;


        p2 = new Product2(Name='ZPProd', ProductCode='ZPProd',Available_to_External_Marketplace__c=True, Inventory__c=99);
        insert p2;
                
        PricebookEntry pe2 = new PricebookEntry(Unitprice=100.00, Product2Id=p2.Id, Pricebook2Id=pricebookId);
        insert pe2;
        
    }
    
    @isTest
    private static void test1(){
        setup();
        Test.startTest();    
                        
        RESTProductsController.processRequest('');
        RESTProductsController.processRequest('sampler');
        
        
        RestRequest req = new RestRequest();
        
        //String jsonReq = '{"grant_type":"password","client_id":"123","client_secret":"ABC","username":"user","password":"password"}';

		RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        request.requestUri ='https://parcopy-euphebe.cs95.force.com/services/apexrest/products';
        request.httpMethod = 'GET';
		//request.requestBody = Blob.valueof(jsonReq);
        
        RestContext.request = request;
        RestContext.response = response;
        RESTProductsController.getProducts();
        
        Product_Meal__c pm = new Product_Meal__c(Inventory__c=99, Meal__c=m.Id, Product__c=p2.Id, Available_to_External_Marketplace__c = true);
        insert pm;

        RESTProductsController.getProducts();
        
        RESTProductsController.multiPickToListString('a;b');
        
        Test.stopTest();        
    }
    
}