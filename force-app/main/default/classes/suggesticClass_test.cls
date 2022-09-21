@isTest 
public class suggesticClass_test {

    Static Account account;
    Static Account acct;
    Static Contact cont;
    Static Opportunity opp1;
    Static Opportunity opp2;
    static Meal__c m;
    static Meal__c m2;
    
     public static void setup(){
         acct = new Account(Name='Account', Batch_Last_KPI__c=null, BillingStreet='25 Jackson\n\rApt 1C');
         insert acct;
         
         cont = new Contact(Email='a@a.com', AccountId=acct.Id, LastName = 'last');
         insert cont;

         opp1 = new Opportunity(Name='Opp1', CloseDate=Date.newInstance(2016, 1, 1), StageName='Closed Won', Amount=100, AccountId=acct.Id, Is_Custom__c = True, Ship_Date__c=Date.newInstance(2019, 3, 4), Delivery_Date__c = Date.newInstance(2019, 3, 4), How_did_you_hear_Long__c = 'aaa');
         insert opp1;
         
         opp2 = new Opportunity(Name='Opp1', CloseDate=Date.newInstance(2017, 1, 1), StageName='Closed Won', Amount=100, AccountId=acct.Id, Is_Custom__c = False, Ship_Date__c=Date.newInstance(2019, 3, 4), Delivery_Date__c = Date.newInstance(2019, 3, 4), How_did_you_hear_Long__c = 'aaa');
         insert opp2;

         m = new Meal__c(Name='Meal',Description__c='Meal',Shopify_ID__c='2610863767616',Inventory__c=99,Type__c ='Lunch' );
         insert m;
         
         m2 = new Meal__c(Name='Meal2',Description__c='Meal2',Shopify_ID__c='2610863767617',Inventory__c=99);
         insert m2;
         
     }
    
     @isTest
    private static void testBatch(){
        setup();
        Test.startTest();    
        
        Meal_Line_Item__c mli = new Meal_Line_Item__c(Name='Meal',EOrder__c=opp1.Id,Meal__c=m.Id,Quantity__c=3);
        insert mli;

        Suggestic_Settings__c ss = new Suggestic_Settings__c();
        ss.AuthToken__c = '123';
        ss.Endpoint__c = 'https://sug.com';
        ss.GraphQL_Endpoint__c = 'https://staging.suggestic.com/graphql';
        ss.Name='settings';
        insert ss;
        
        
        //suggesticClass.setOrder('0030m00000ZxYTe','0060m00000Fh3jD');
        List<List<String>> ls1 = new List<List<String>>();
        List<String> ls2 = new List<String>();
        ls2.add('setOrder');
        ls2.add(acct.Id);
        ls2.add(opp1.Id);
        ls1.add(ls2);
        suggesticClass.suggesticMethods(ls1);       
        
        List<List<String>> ls3 = new List<List<String>>();
        List<String> ls4 = new List<String>();
        ls4.add('resetPasswordToken');
        ls4.add(acct.Id);
        ls3.add(ls4);
        suggesticClass.suggesticMethods(ls3); 
        
        List<List<String>> ls5 = new List<List<String>>();
        List<String> ls6 = new List<String>();
        ls6.add('deleteUser');
        ls6.add('123');
        ls5.add(ls6);
        suggesticClass.suggesticMethods(ls5); 

        List<List<String>> ls7 = new List<List<String>>();
        List<String> ls8 = new List<String>();
        ls8.add('updateSubscription');
        ls8.add('123');
        ls8.add('OTCM');
        ls7.add(ls8);
        suggesticClass.suggesticMethods(ls7); 
       
        suggesticClass.setPassword('123', 'abc');
        suggesticClass.hasSuggesticSubscription('a@a.co');
        
        List<API_Request__c> lstAddAPIReq = new List<API_Request__c>();  
        suggesticClass.setDeliveryDate('123', '2021-06-22', lstAddAPIReq);
        suggesticClass.swapMealPlan(userinfo.getUserId(),opp1.Id);
        suggesticClass.createMealPlan(userinfo.getUserId(),lstAddAPIReq);
                
        suggesticClass.setProgram('123', 'E28ZJ', lstAddAPIReq);
        
        Test.stopTest();
    }    
}