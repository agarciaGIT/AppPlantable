/*
*   @Desciption     :   Test Class of Plantable Meals Service class,
*   @Create date    :   12-04-2022
*   @Author         :   Bhagwan S
_________________________________________________________________________________________________________________________________________________________
    @Main class     :   Plant_Meals_SC, Plant_Meals_BC
*/
@isTest
public with sharing class Plant_Meals_SC_Test {
    
    // @ Default Constructor
    public Plant_Meals_SC_Test() {
        
    }
 
    // @ Method 1    
    static testMethod void plant_Meal_Test(){
        
        // @ Creating Records
        Meal__c meal=Plant_TestDataFactory.createMeal(1)[0];
        insert meal;
        
        Dish__c Dish=Plant_TestDataFactory.createDishes(1)[0];
        Dish.Meal__c=meal.id;
        insert Dish;
        
        Plant_Meal_Selection__c Mealselection=Plant_TestDataFactory.createMealSelection(1)[0];
        insert MealSelection;
        
        Account accounts = Plant_TestDataFactory.createAccounts(1)[0];
        insert accounts;
        
        Order order = new order(Accountid=accounts.id, EffectiveDate=System.today(), Status ='Draft');
        insert order;
        
        // JSON: { "mealSelectionId": "a1J3J0000007FRrUAM", "mealList": [{ "mealId": "a0A3J000000AYy7UAG", "quantity": "6", "mealSelectionMealId": "" }] }
        string jsonBody = '{ "mealSelectionId": "'+MealSelection.Id+'", "mealList": [{ "mealId": "'+meal.Id+'", "quantity": "6", "mealSelectionMealId": "" }] }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/meals/v1/*';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        // request.setBody(JSON.serialize(jsonBody));
        request.httpMethod='GET';
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Plant_RESTMeals.getActivMeals();
        Plant_Meals_SC pMealSC=new Plant_Meals_SC();
        
    }
     // @ Method 2 
    static testMethod void plant_Meal_Test1(){
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/meals/MealList';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        
        request.httpMethod='GET';
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Plant_RESTMeals.getActivMeals();
        Plant_Meals_SC pMealSC=new Plant_Meals_SC();
        
    }
    
    // @ Method 2    
    static testMethod void plant_Meal_Test2(){
        
        // @ Creating Records
        Meal__c meal=Plant_TestDataFactory.createMeal(1)[0];
        insert meal;
        
        Plant_Meal_Selection__c Mealselection=Plant_TestDataFactory.createMealSelection(1)[0];
        insert MealSelection;
        
        Account accounts = Plant_TestDataFactory.createAccounts(1)[0];
        insert accounts;
        
        Order order = new order(Accountid=accounts.id, EffectiveDate=System.today(), Status ='Draft');
        insert order;
        
        // JSON: { "mealSelectionId": "a1J3J0000007FRrUAM", "mealList": [{ "mealId": "a0A3J000000AYy7UAG", "quantity": "6", "mealSelectionMealId": "" }] }
        string jsonBody = '{ "mealSelectionId": "'+MealSelection.Id+'", "mealList": [{ "mealId": "'+meal.Id+'", "quantity": "6", "mealSelectionMealId": "" }] }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/meals/MealSelection';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTMeals prestMeal=new Plant_RESTMeals();

        Plant_RESTMeals.setMealSelection();
    }

    // @ Method 3    
    static testMethod void plant_Meal_Test3(){
        
        // @ Creating Records
        Meal__c meal=Plant_TestDataFactory.createMeal(1)[0];
        insert meal;
        
        Plant_Meal_Selection__c Mealselection=Plant_TestDataFactory.createMealSelection(1)[0];
        insert MealSelection;
        
        Account accounts = Plant_TestDataFactory.createAccounts(1)[0];
        insert accounts;
        
        Order order = new order(Accountid=accounts.id, EffectiveDate=System.today(), Status ='Draft');
        insert order;
        
        // JSON: { "mealSelectionId": "a1J3J0000007FRrUAM", "mealList": [{ "mealId": "a0A3J000000AYy7UAG", "quantity": "6", "mealSelectionMealId": "" }] }
        string jsonBody = '{ "mealSelectionId": "'+''+'", "mealList": [{ "mealId": "'+meal.Id+'", "quantity": "6", "mealSelectionMealId": "" }] }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/meals/MealSelection';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Plant_RESTMeals.setMealSelection();
    }

    // @ Method 4    
    static testMethod void plant_Meal_Test4(){
        Map<String,String> classDetail = Plant_Meals_BC.getClassDetail();
    }
 
    // @ Method 5
    static testMethod void plant_Meal_Test5(){
        
        // @ Creating Records
        
        string JSON = '{ "mealSelectionId": "a1J3J0000007FRrUAM", "mealList": [{ "mealId": "a0A3J000000AYy7UAG", "quantity": "6", "mealSelectionMealId": "" }] }';
        //string jsonBody = '{ "mealSelectionId": "'+MealSelection.Id+'", "mealList": [{ "mealId": "'+meal.Id+'", "quantity": "6", "mealSelectionMealId": "" }] }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/meals/MealDeletion';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(json);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTMeals prestMeal=new Plant_RESTMeals();

        Plant_RESTMeals.setMealSelection();
    }
    
    //@ Method 6
    static testMethod void plant_Meal_Test6(){
        
        // @ Creating Records
        
        Meal__c meal=Plant_TestDataFactory.createMeal(1)[0];
        insert meal;
        
        Plant_Meal_Selection__c Mealselection=Plant_TestDataFactory.createMealSelection(1)[0];
        insert MealSelection;
        
        Account accounts = Plant_TestDataFactory.createAccounts(1)[0];
    	accounts.Email__c ='xyz.ab@tmail.com';
    	accounts.plant_UserPasswaord__c='12345';
    	accounts.plant_Authentication_Token__c='abcdefghijklmnopqrstuvwxyz';
    	accounts.plant_AuthenticationToken__c='abcdefghijklmnopqrstuvwxyz';
        accounts.plant_TokenCreatedDateTime__c=System.now();
        insert accounts;
        
        Dish__c dish=Plant_TestDataFactory.createDishes(1)[0];
        dish.Meal__c=meal.id;
        insert dish;
        // JSON: { "mealSelectionId": "a1J3J0000007FRrUAM", "mealList": [{ "mealId": "a0A3J000000AYy7UAG", "quantity": "6", "mealSelectionMealId": "" }] }
        string jsonBody = '{ "mealId": "'+meal.id+'", "authenticationToken": "'+accounts.plant_Authentication_Token__c+'"}] }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/meals/Ingredients';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Plant_RESTMeals.setMealSelection();
    }
   
    static testMethod void plant_Meal_Test7(){
        
        // @ Creating Records
        
        Meal__c meal=Plant_TestDataFactory.createMeal(1)[0];
        insert meal;
        
        Plant_Meal_Selection__c Mealselection=Plant_TestDataFactory.createMealSelection(1)[0];
        insert MealSelection;
        
        Account accounts = Plant_TestDataFactory.createAccounts(1)[0];
    	accounts.Email__c ='xyz.ab@tmail.com';
    	accounts.plant_UserPasswaord__c='12345';
    	accounts.plant_Authentication_Token__c='abcdefghijklmnopqrstuvwxyz';
    	accounts.plant_AuthenticationToken__c='abcdefghijklmnopqrstuvwxyz';
        accounts.plant_TokenCreatedDateTime__c=System.now();
        insert accounts;
        
        Dish__c dish=Plant_TestDataFactory.createDishes(1)[0];
        dish.Meal__c=meal.id;
        insert dish;
        // JSON: { "mealSelectionId": "a1J3J0000007FRrUAM", "mealList": [{ "mealId": "a0A3J000000AYy7UAG", "quantity": "6", "mealSelectionMealId": "" }] }
        string jsonBody = '{ "mealId": "@3ssdp329863129", "authenticationToken": "672698129812912"}] }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/meals/Ingredients';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Plant_RESTMeals.setMealSelection();
    }

}