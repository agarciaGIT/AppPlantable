/*
*   @Desciption     :   Class for creating test data 
*   @Create date    :   11-04-2022
*   @Author         :   Bhagwan S
_________________________________________________________________________________________________________________________________________________________
    @Test Class     :   Plant_TestDataFactory_Test
*/
public with sharing class Plant_TestDataFactory {
 
    // @ Default Constructor
    public Plant_TestDataFactory() {
    }
    
    // AG
    public static Plant_Payment_Method__c createPaymentMethod(Account acct){
      Plant_Payment_Method__c newPay = new Plant_Payment_Method__c(
          Plant_Account__c = acct.id,
            Plant_Card_Type__c = 'Visa',
            Plant_Card_Number__c = '4242424242424242'
        );
        return newPay;
    }
    
    public static Order creatOrderWithProduct(String acctId, String prodName) {
        
        // Insert Product
        Product2 p = new Product2();
        p.Name = prodName;
        p.Description='Test Product Entry 1';
        p.productCode = prodName;
        p.isActive = true;
        insert p;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        // Insert PricebookEntry
        
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = pricebookId;
        standardPrice.Product2Id = p.Id;
        standardPrice.UnitPrice = 1;
        standardPrice.IsActive = true;
        standardPrice.UseStandardPrice = false;
        insert standardPrice ;
        
        // Insert Order
        
        Order o = new Order();
        o.Name = 'Test Order ';
        o.Status = 'Draft';
        o.EffectiveDate = system.today();
        o.EndDate = system.today() + 4;
        o.AccountId = acctId;
        o.Pricebook2Id =  pricebookId ;
        
        insert o;
        
        // Insert Order Item
        
        OrderItem i = new OrderItem();
        i.OrderId = o.id;
        i.Quantity = 24;
        i.UnitPrice = 240;
        i.Product2id = p.id;
        i.PricebookEntryId=standardPrice.id;
        insert i;
        
        return o;
    }
    
    public static PricebookEntry creatProduct(String ProdCode) {
        Product2 prod = new Product2(Name = 'PRODZ',ProductCode = ProdCode);
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        Pricebook2 pricebook2 = new Pricebook2(Name='Plant_PIRCE', isActive=true);
        insert pricebook2;
        
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 250.00, IsActive = true);
        insert standardPrice;
        
        PricebookEntry Price = new PricebookEntry(Pricebook2Id = pricebook2.Id, Product2Id = prod.Id,UnitPrice = 250, IsActive = true);
        insert Price;
        
        return Price;
    }
    
    public static List<Plant_Meal_Selection_Meal__c> createMealSelMeals(List<Meal__c> meals, Plant_Meal_Selection__c Mealselection) {
        List<Plant_Meal_Selection_Meal__c> msms = new List<Plant_Meal_Selection_Meal__c>();
        for(Meal__c m :meals) {
            Plant_Meal_Selection_Meal__c newMs = new Plant_Meal_Selection_Meal__c(
                Plant_Quantity__c = 1,
                Plant_Meal_Selection__c = Mealselection.Id,
                Plant_Meal__c = m.id
            );
            msms.add(newMs);
        }
        return msms;
    }
    
    // @ Creating new meal list
    public static List<Meal__c> createMeal(Integer No_Of_Meals){
        List<Meal__c> Meals =new List<Meal__c>();
        for(integer i=0; i<=1;i++){
            Meal__c Meal = new Meal__c(Name = 'Test_Meal_'+i, Description__c ='For Testing',
             Type__c='Lunch', Cuisine__c='French', Calories_Per_Serving__c=523, Proteins__c='Beef', Image_URL__c='ABCD',
            Allergens__c='Milk', Menu_Name__c='for Body building',
             Inventory__c=9, Inventory_Sync__c=True, API_Enabled__c=True, Zipongo_Sampler__c=True, 
             Dairy_Free__c=True, Gluten_Free__c=True, Nut_Free__c=True, Inventory_Sync_Off_Call__c='under the label',
             Sort_Rank__c=12, Soy_Free__c=True, Favorites__c=True,
              Status__c='Active', Affiliate_Gift__c=True, Suggestic_ID__c='Label346776', Shopify_ID__c='shdfkjsh');
            Meals.add(Meal);
        }
        return Meals;
    }
    
    // @ Creating new Account List
    public static List<Account> createAccounts( Integer numberOfAccounts) {
        List<Account> accounts = new List<Account>();
        for ( Integer i = 0 ; i < numberOfAccounts ; i++ ) {
            
            Account account = new Account( name = 'Test Account'+i,
                                          first_name__c = 'Test_Account_' + i, last_name__c = 'Account',
                    Email__c = 'noreplay@email.com', Phone= '(415) 419-8873',   Reboot_Status__c='In Progress');
            accounts.add( account);
        }
        return accounts;
    }
    
    // @ Creating Meal Selection List
    public static List<Plant_Meal_Selection__c> createMealSelection( Integer numberOfMeal) {
        List<Plant_Meal_Selection__c> mealSelections = new List<Plant_Meal_Selection__c>();
        for ( Integer i = 0 ; i < numberOfMeal ; i++ ) {
            
            Plant_Meal_Selection__c mealSelection = new Plant_Meal_Selection__c( Plant_Description__c='In Progress');
            mealSelections.add( mealSelection);
        }
        return mealSelections;
    }
    
   //@ Creating Discount Code List
    public static List<Plant_Discount_Code__c> createDiscountCode( Integer numberOfDiscountCode, String s, String r) {
        List<Plant_Discount_Code__c> discountCodes = new List<Plant_Discount_Code__c>();
        for ( Integer i = 0 ; i < numberOfDiscountCode ; i++ ) {
            
            Plant_Discount_Code__c discountCode1 = new Plant_Discount_Code__c(Plant_Code__c=s+i, Name='Swiggy34',
                        Plant_New_Customer_Only__c=False, Plant_Type__c='Fixed Amount', Plant_Supported_Products__c = r,
                        Plant_Start_Date__c=System.now(), Plant_End_Date__c=System.now().addDays(7));
            discountCodes.add(discountCode1);
        }
        return discountCodes;
    }
    
    //@ Creating Order properties List
    public static List<Plant_Order_Properties__c> createOrderProperties( Integer numberOfOrderProperties) {
        List<Plant_Order_Properties__c> orderProperties = new List<Plant_Order_Properties__c>();
        for ( Integer i = 0 ; i < numberOfOrderProperties ; i++ ) {
            
            Plant_Order_Properties__c orderProperty = new Plant_Order_Properties__c(/*Name='OrderProperty'+i,*/ Plant_Status__c='Paid',
                RecordTypeId=Schema.SObjectType.Plant_Order_Properties__c.getRecordTypeInfosByName().get('Reboot').getRecordTypeId());
            orderProperties.add(orderProperty);
        }
        return orderProperties;
    }
    
    // @ Creating Shipping Address List
    public static List<Plant_Shipping_Address__c> createShippingAddress( Integer numberOfShippingAddress) {
        List<Plant_Shipping_Address__c> shippingAddressList = new List<Plant_Shipping_Address__c>();
        for ( Integer i = 0 ; i < numberOfShippingAddress ; i++ ) {
            
            Plant_Shipping_Address__c shippingAddress = new Plant_Shipping_Address__c(/*Name='Avengers Tower',*/
                        Plant_City__c='New York', Plant_Province_State__c='NY',
                        Plant_Country__c='USA', Plant_Postal_Code__c='12345');
            shippingAddressList.add(shippingAddress);
        }
        return shippingAddressList;
    }
    
    // @ Creating Delivery Schedule Lists
    public static List<Plant_Delivery_Schedule__c> createDeliverySchedule( Integer numberDeliverySchedule, Integer Duration) {
        List<Plant_Delivery_Schedule__c> DeliveryScheduleList = new List<Plant_Delivery_Schedule__c>();
        for ( Integer i = 0 ; i < numberDeliverySchedule ; i++ ) {
            
            Plant_Delivery_Schedule__c DeliverySchedule = new Plant_Delivery_Schedule__c(Plant_State_Code__c='NY', 
                                                                                         Plant_Zip_Code__c='12345', 
                                                                                         Plant_Shipping_Duration__c=Duration);
            DeliveryScheduleList.add(DeliverySchedule);
        }
        return DeliveryScheduleList;
    }
    
    
    // @ Creating Shipping Dates Lists
    public static List<Plant_Shipping_Date__c> createShippingDate( Integer numberShippingDates) {
        List<Plant_Shipping_Date__c> ShippingDates = new List<Plant_Shipping_Date__c>();
        for ( Integer i = 0 ; i < numberShippingDates ; i++ ) {
            
            Plant_Shipping_Date__c ShippingDate = new Plant_Shipping_Date__c(Name='Shiping'+i, 
              Plant_Shipping_Date__c=System.today()+2, Plant_Total_Orders__c=3);
            ShippingDates.add(ShippingDate);
        }
        return ShippingDates;
    }
    
    public static List<Dish__c> createDishes( Integer numberofDishes) {
        List<Dish__c> Dishes = new List<Dish__c>();
        for ( Integer i = 0 ; i < numberofDishes; i++ ) {
            
            Dish__c Dish = new Dish__c(A_la_carte_Available__c=true, 
              Vegan__c=true,    Vegetarian__c=true);
            Dishes.add(Dish);
        }
        return Dishes;
    }
}