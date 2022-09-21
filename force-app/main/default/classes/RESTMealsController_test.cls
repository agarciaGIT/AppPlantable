@isTest 
public class RESTMealsController_test {
    
    static Product2 p2;
    Static Account acct;
    Static Contact cont;
    Static Opportunity opp1;
    static Meal__c m;
    static Meal__c m2;
    static Meal_Line_Item__c mli;
    static Meal_Line_Item__c mli2;
    
    public static void setup(){

		acct = new Account(Name='Account', Batch_Last_KPI__c=null, BillingStreet='25 Jackson\n\rApt 1C');
        insert acct;
        
        cont = new Contact(Email='agarcia@a.com', AccountId=acct.Id, LastName = 'last');
        insert cont;        
        
        Product2 p1 = new Product2(Name='ZPEALC', ProductCode='ZPEALC',Available_to_External_Marketplace__c=True, Inventory__c=99);
        insert p1;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pe1 = new PricebookEntry(Unitprice=100.00, Product2Id=p1.Id, Pricebook2Id=pricebookId);
        insert pe1;


        p2 = new Product2(Name='SUG', ProductCode='SUG',Available_to_External_Marketplace__c=True, Inventory__c=99);
        insert p2;
                
        PricebookEntry pe2 = new PricebookEntry(Unitprice=100.00, Product2Id=p2.Id, Pricebook2Id=pricebookId);
        insert pe2;
       
        opp1 = new Opportunity(Name='Opp1', CloseDate=Date.today(), StageName='Closed Won', Amount=100, AccountId=acct.Id, Email_Address__c = 'agarcia@a.com', Ship_Date__c=Date.newInstance(2019, 3, 4), Main_Product__c = p2.Id);
        insert opp1;
        
        m = new Meal__c(Name='Meal',Description__c='Meal',Shopify_ID__c='2610863767616',Inventory__c=99);
        insert m;

        m2 = new Meal__c(Name='Meal2',Description__c='Meal2',Shopify_ID__c='2610863767617',Inventory__c=99);
        insert m2;
        
        mli = new Meal_Line_Item__c(Name='MLI',EOrder__c=opp1.Id, Meal__c=m.Id,Quantity__c=5);
        insert mli;
        
        mli2 = new Meal_Line_Item__c(Name='MLI',EOrder__c=opp1.Id, Meal__c=m.Id,Quantity__c=5);
        insert mli2;
    }
    
    @isTest
    private static void test1(){
    	setup();
        Test.startTest();    
        
       
		//RestRequest req = new RestRequest();
        //String jsonReq = '{"grant_type":"password","client_id":"123","client_secret":"ABC","username":"user","password":"password"}';

		RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        request.requestUri ='https://parcopy-euphebe.cs95.force.com/services/apexrest/meals/agarcia@a.com';
        request.httpMethod = 'GET';
		//request.requestBody = Blob.valueof(jsonReq);
        
        RestContext.request = request;
        RestContext.response = response;
        RESTMealsController.processGETRequest(request);        
        
        RESTMealsController.getMeals();
        
        Test.stopTest();        
    }
    

}