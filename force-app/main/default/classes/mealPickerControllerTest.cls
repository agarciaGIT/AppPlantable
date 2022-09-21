@isTest 
public class mealPickerControllerTest {
    
    Static Account acct;
    Static Contact cont;
    Static Opportunity opp1;
    static Meal__c m;
    static Meal_Line_Item__c mli;

    public static void setup(){
        
        acct = new Account(Name='Account', Email__c='a@a.com', Batch_Last_KPI__c=null, BillingStreet='25 Jackson\n\rApt 1C');
        insert acct;
        
        cont = new Contact(Email='a@a.com', AccountId=acct.Id, LastName = 'last');
        insert cont;
        
        opp1 = new Opportunity(Name='Opp1', CloseDate=Date.Today().addDays(7), StageName='Closed Won', Amount=100, AccountId=acct.Id, Is_Custom__c = True, Ship_Date__c=Date.Today().addDays(7), How_did_you_hear_Long__c = 'aaa');
        insert opp1;

        m = new Meal__c(Name='Meal',Description__c='Meal',Shopify_ID__c='2610863767616',Inventory__c=99,API_Enabled__c=True);
        insert m;
        
        Dish__c d = new Dish__c(Name='Dish', Meal__c = m.Id);
        insert d;
        
        Ingredient_Item__c ii = new Ingredient_Item__c(Name='Ing', Is_Allergen__c=true, Protein__c=1.0, Dish__c = d.Id);
        insert ii;

        Ingredient_Item__c ii2 = new Ingredient_Item__c(Name='Ing', Is_Allergen__c=true, Protein__c=3.0, Dish__c = d.Id);
        insert ii2;

        mli = new Meal_Line_Item__c(Name='MLI',EOrder__c=opp1.Id, Meal__c=m.Id,Quantity__c=5);
        insert mli;
        
    }
    
    @isTest
    private static void testBatch(){
        setup();
        Test.startTest();    
        
        mealPickerController mpc = mealPickerController.initClass('', 'a@a.com', True);
        
        String sObj = JSON.serialize(mpc);
        mealPickerController.incrementCartItem(m.Id, sObj);
                
        mealPickerController.decrementCartItem(m.Id, sObj);
                
        mealPickerController.submitMeals(sObj);
        
        mealPickerController.removeBoxItems(sObj);

        //mpc.mapMealItems = new Map<String, Meal_Line_Item__c>();
        //String sObj1 = JSON.serialize(mpc);
        mealPickerController mpc1 = mealPickerController.removeCartItem(m.Id, sObj);
        String sObj1 = JSON.serialize(mpc1);
        mealPickerController.incrementCartItem(m.Id, sObj1);
        
    }
}