@isTest
public class SearchEmailControllerTest {
    @isTest
    public static void searchEmailTest(){
        Account acct = new Account(Name='Account', Batch_Last_KPI__c=null, BillingStreet='25 Jackson\n\rApt 1C',Study_Access_Key__c='123');
        insert acct;
        
        Contact cont = new Contact(Email='a@a.com', AccountId=acct.Id, LastName = 'last');
        insert cont;
        
        Date shipDate = Date.newInstance(2020, 3, 2);
        
        Opportunity opp1 = new Opportunity(Email_Address__c ='testsearch@test.com',Name='Opp1', CloseDate=Date.newInstance(2016, 1, 1), StageName='Closed Won', Amount=100, AccountId=acct.Id, Is_Custom__c = True, Ship_Date__c=shipDate, How_did_you_hear_Long__c = 'aaa');
        insert opp1;
        Meal__c m = new Meal__c(API_Enabled__c = true,Name='Meal',Description__c='Meal',Shopify_ID__c='2610863767616',Inventory__c=99);
        insert m;
      
        Menu_Program__c mp = new Menu_Program__c(Name='MP', Start_Date__c=Date.newInstance(2016, 1, 1), Order_Cut_Off_Day__c='Friday', Order_Cut_Off_Time__c='06:00', Status__c = 'Active');
        insert mp;
        
        Menu__c mu = new Menu__c(Name='Menu', Cycle__c=1, Menu_Program__c = mp.Id, Status__c = 'Active');
        insert mu;
        
        Menu_Entry__c me = new Menu_Entry__c(Name='ME', Meal__c = m.Id, Menu__c = mu.Id);
        insert me;
        
        Dish__c d = new Dish__c(Name='Dish', Meal__c = m.Id);
        insert d;
          Meal_Line_Item__c mli = new Meal_Line_Item__c(Name='MLI',EOrder__c=opp1.Id, Meal__c=m.Id,Quantity__c=5);
        insert mli; 
        Ingredient_Item__c ii = new Ingredient_Item__c(Name='Ing', Is_Allergen__c=true, Protein__c=1.0, Dish__c = d.Id,Start_Date__c = system.today().addDays(-2),End_Date__c = system.today().addDays(2));
        insert ii;
         SearchEmailController.findByEmail(opp1.Email_Address__c);
    }
}