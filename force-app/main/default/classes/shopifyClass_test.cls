@isTest 
public class shopifyClass_test {
    
    Static API_Request__c ar;
    Static Account account;
    Static Shipment__c ship;
    Static Account acct;
    Static Contact cont;
    Static Opportunity opp1;
    Static Opportunity opp2;
    Static String APIRaw;
    Static Euphebe_Campaign__c ec1;
    Static Campaign_Account__c ca1;
    Static Campaign_Step__c cs;
    static Meal__c m;
    static Meal__c m2;
    Static API_Request__c ar2;
    Static API_Session__c as1;
    Static Health_Survey__c hs;    
    Static Health_Survey__c hs1;
    Static Product2 prod10; 
    
    public static void setup(){
        
        APIRaw = '{"id":114015109131,"email":"anya.estrov@gmail.com","closed_at":null,"created_at":"2017-12-31T09:06:13-05:00","updated_at":"2017-12-31T09:06:17-05:00","number":3074,"note":null,"token":"77a3658f6d66e73390557a93cffc3540","gateway":"shopify_payments","test":false,"total_price":"165.00","subtotal_price":"150.00","total_weight":454,"total_tax":"0.00","taxes_included":false,"currency":"USD","financial_status":"paid","confirmed":true,"total_discounts":"0.00","total_line_items_price":"150.00","cart_token":"3ca8ce77907ed41b56d61f91c4eaa157","buyer_accepts_marketing":false,"name":"#S4074","referring_site":"","landing_site":"toolsrecurringcustomer36502320e352343c859f63fsubscriptions","cancelled_at":null,"cancel_reason":null,"total_price_usd":"165.00","checkout_token":"f66e22f48d5dd2f388e3618835d599da","reference":null,"user_id":null,"location_id":null,"source_identifier":null,"source_url":null,"processed_at":"2017-12-31T09:06:13-05:00","device_id":null,"phone":null,"customer_locale":"en","app_id":580111,"browser_ip":"104.162.100.100","landing_site_ref":null,"order_number":4074,"discount_codes":[],"note_attributes":[],"payment_gateway_names":["shopify_payments"],"processing_method":"direct","checkout_id":266197139467,"source_name":"web","fulfillment_status":null,"tax_lines":[],"tags":"","contact_email":"anya.estrov@gmail.com","order_status_url":"https:www.euphebe.com16708417orders77a3658f6d66e73390557a93cffc3540authenticate?key=64d848967f02636e7c1c6221bc573f87","line_items":[{"id":203505074187,"variant_id":34461252939,"title":"A LA CARTE","quantity":1,"price":"150.00","sku":"","variant_title":"","vendor":" Euphebe","fulfillment_service":"manual","product_id":9466290251,"requires_shipping":true,"taxable":false,"gift_card":false,"name":"A LA CARTE","variant_inventory_management":null,"properties":[{"name":"Ship Date","value":"01082018"},{"name":"time","value":"31_11_2017_8_55_37"},{"name":"marthas-cuban-black-bean-soup-gf","value":"1"},{"name":"lunch-thyme-grain-bowl","value":"1"},{"name":"rachels-winter-pasticcio","value":"1"},{"name":"zia-lina-sugo-with-green-lentil-penne-gf","value":"1"},{"name":"rainbow-veggies-with-super-soba-peanut-sauce","value":"1"},{"name":"multi-mushroom-risotto","value":"1"},{"name":"pumpkin-faux-sotto","value":"1"},{"name":"butternut-squash-risotto","value":"1"},{"name":"marcella-inspired-bolognese-with-spelt-fusilli","value":"1"},{"name":"thai-red-curry-with-lemongrass-rice","value":"1"},{"name":"lunchtime-quesarita-with-green-salsa","value":"1"}],"product_exists":true,"fulfillable_quantity":1,"grams":454,"total_discount":"0.00","fulfillment_status":null,"tax_lines":[],"origin_location":{"id":2581205003,"country_code":"US","province_code":"NY","name":"Euphebe","address1":"85 Broad Street","address2":"29th Floor","city":"New York","zip":"10004"},"destination_location":{"id":151713153035,"country_code":"US","province_code":"NY","name":"Anya Estrov","address1":"111 8th Ave","address2":"Mailroom","city":"New York","zip":"10011"}}],"shipping_lines":[{"id":100071047179,"title":"Local NYC Courier (arrives before 5pm same day as ship date)","price":"15.00","code":"LOCAL_NYC_COURIER","source":"PI Bespoke Shipping","phone":null,"requested_fulfillment_service_id":null,"delivery_category":null,"carrier_identifier":"2eb5eb8105d77d0a56ca5c0e08aab1e3","discounted_price":"15.00","tax_lines":[]}],"billing_address":{"first_name":"Anya","address1":"152 5th Ave","phone":"(646) 325-8361","city":"Brooklyn","zip":"11217","province":"New York","country":"United States","last_name":"Estrov","address2":"4C","company":"","latitude":40.6781801,"longitude":-73.9794745,"name":"Anya Estrov","country_code":"US","province_code":"NY"},"shipping_address":{"first_name":"Anya","address1":"111 8th Ave","phone":"(646) 325-8361","city":"New York","zip":"10011","province":"New York","country":"United States","last_name":"Estrov","address2":"Mailroom","company":"GOOGLE","latitude":40.7409573,"longitude":-74.0021187,"name":"Anya Estrov","country_code":"US","province_code":"NY"},"fulfillments":[],"client_details":{"browser_ip":"104.162.100.100","accept_language":"en-US,en;q=0.9","user_agent":"Mozilla5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit537.36 (KHTML, like Gecko) Chrome63.0.3239.84 Safari537.36","session_hash":"6f12fadd131b39c7eaee671d621b8606","browser_width":1899,"browser_height":1033},"refunds":[],"payment_details":{"credit_card_bin":"371299","avs_result_code":"Y","cvv_result_code":"M","credit_card_number":"•••• •••• •••• 1009","credit_card_company":"American Express"},"customer":{"id":4391675211,"email":"anya.estrov@gmail.com","accepts_marketing":false,"created_at":"2017-05-25T22:46:16-04:00","updated_at":"2017-12-31T09:06:14-05:00","first_name":"Anya","last_name":"Estrov","orders_count":10,"state":"enabled","total_spent":"2107.50","last_order_id":114015109131,"note":null,"verified_email":true,"multipass_identifier":null,"tax_exempt":false,"phone":"+16463258361","tags":"Active Subscriber","last_order_name":"#S4074","default_address":{"id":201683009547,"customer_id":4391675211,"first_name":"Anya","last_name":"Estrov","company":"GOOGLE","address1":"111 8th Ave","address2":"Mailroom","city":"New York","province":"New York","country":"United States","zip":"10011","phone":"(646) 325-8361","name":"Anya Estrov","province_code":"NY","country_code":"US","country_name":"United States","default":true}}}';
        
        acct = new Account(Name='Account', Batch_Last_KPI__c=null, BillingStreet='25 Jackson\n\rApt 1C');
        insert acct;
        
        cont = new Contact(Email='a@a.com', AccountId=acct.Id, LastName = 'last');
        insert cont;
        
        hs = new Health_Survey__c(Account__c = acct.id);
        insert hs;

        hs1 = new Health_Survey__c(Account__c = acct.id, Is_Finisher_Survey__c = true);
        insert hs1;
        prod10= new Product2(Name='OTSEA', ProductCode='OTSEA', IsActive = True);
        insert prod10; 
        opp1 = new Opportunity(Name='Opp1',Main_Product__c=prod10.Id, CloseDate=Date.newInstance(2016, 1, 1),Shipment_Date__c=system.today(), StageName='Closed Won', Amount=100, AccountId=acct.Id, Is_Custom__c = True, Ship_Date__c=Date.newInstance(2019, 3, 4), How_did_you_hear_Long__c = 'aaa');
        insert opp1;

        opp2 = new Opportunity(Name='Opp1', CloseDate=Date.newInstance(2017, 1, 1), StageName='Closed Won', Amount=100, AccountId=acct.Id, Is_Custom__c = False, Ship_Date__c=Date.newInstance(2019, 3, 4), How_did_you_hear_Long__c = 'aaa');
        insert opp2;
        
        Product2 prod1 = new Product2(Name='Prod1', ProductCode='EALC');
        insert prod1;
        Product2 prod2 = new Product2(Name='Prod2', ProductCode='EHF');
        insert prod2;
        Product2 prod3 = new Product2(Name='Prod3', ProductCode='E28');
        insert prod3;
        Product2 prod4 = new Product2(Name='Prod4', ProductCode='E28 Finish Me');
        insert prod4;
        Product2 prod5 = new Product2(Name='Prod5', ProductCode='E28TM');
        insert prod5;
        Product2 prod6 = new Product2(Name='Prod6', ProductCode='ETWS');
        insert prod6;
        Product2 prod7 = new Product2(Name='Prod6', ProductCode='ETWB');
        insert prod7;
	
        Product2 prod8 = new Product2(Name='Prod6', ProductCode='E28ZJ', Shopify_Product_Id__c = '2610863767616', IsActive = True);
        insert prod8;

        Product2 prod9 = new Product2(Name='Prod6', ProductCode='QSZJ', Shopify_Product_Id__c = '2610861178944', IsActive = True);
        insert prod9;
        
        String standardPBId =  Test.getStandardPricebookId();        
        
        PricebookEntry pe1 = new PricebookEntry(Pricebook2Id = standardPBId, Product2Id = prod1.Id, UnitPrice = 100, IsActive = true, UseStandardPrice = false);
        insert pe1;

        OpportunityLineItem oppLine1 = new OpportunityLineItem(Product2Id=prod1.Id, Quantity=1, TotalPrice=100, OpportunityId=opp1.Id,PricebookEntryId=pe1.Id);            
        insert oppLine1;
        
        
        PricebookEntry pe2 = new PricebookEntry(Pricebook2Id=standardPBId,Product2Id=prod2.id,UnitPrice=100, IsActive = true, UseStandardPrice = false);
        insert pe2;

        OpportunityLineItem oppLine2 = new OpportunityLineItem(Product2Id=prod2.Id, Quantity=1, TotalPrice=100, OpportunityId=opp1.Id,PricebookEntryId=pe2.Id);
        insert oppLine2;
        
        PricebookEntry pe3 = new PricebookEntry(Pricebook2Id=standardPBId,Product2Id=prod3.id,UnitPrice=100, IsActive = true, UseStandardPrice = false);
        insert pe3;
        
        OpportunityLineItem oppLine3 = new OpportunityLineItem(Product2Id=prod3.Id, Quantity=1, TotalPrice=100, OpportunityId=opp1.Id,PricebookEntryId=pe3.Id);
        insert oppLine3;

        PricebookEntry pe4 = new PricebookEntry(Pricebook2Id=standardPBId,Product2Id=prod4.id,UnitPrice=100, IsActive = true, UseStandardPrice = false);
        insert pe4;

        OpportunityLineItem oppLine4 = new OpportunityLineItem(Product2Id=prod4.Id, Quantity=1, TotalPrice=100, OpportunityId=opp2.Id,PricebookEntryId=pe4.Id);
        insert oppLine4;

        PricebookEntry pe5 = new PricebookEntry(Pricebook2Id=standardPBId,Product2Id=prod5.id,UnitPrice=100, IsActive = true, UseStandardPrice = false);
        insert pe5;
        
        OpportunityLineItem oppLine5 = new OpportunityLineItem(Product2Id=prod5.Id, Quantity=1, TotalPrice=100, OpportunityId=opp2.Id,PricebookEntryId=pe5.Id);
        insert oppLine5;
        
        PricebookEntry pe6 = new PricebookEntry(Pricebook2Id=standardPBId,Product2Id=prod6.id,UnitPrice=100, IsActive = true, UseStandardPrice = false);
        insert pe6;

        OpportunityLineItem oppLine6 = new OpportunityLineItem(Product2Id=prod6.Id, Quantity=1, TotalPrice=100, OpportunityId=opp2.Id,PricebookEntryId=pe6.Id);
        insert oppLine6;


        PricebookEntry pe7 = new PricebookEntry(Pricebook2Id=standardPBId,Product2Id=prod7.id,UnitPrice=100, IsActive = true, UseStandardPrice = false);
        insert pe7;

        OpportunityLineItem oppLine7 = new OpportunityLineItem(Product2Id=prod7.Id, Quantity=1, TotalPrice=100, OpportunityId=opp2.Id,PricebookEntryId=pe7.Id);
        insert oppLine7;


        PricebookEntry pe8 = new PricebookEntry(Pricebook2Id=standardPBId,Product2Id=prod8.id,UnitPrice=100, IsActive = true, UseStandardPrice = false);
        insert pe8;

        OpportunityLineItem oppLine8 = new OpportunityLineItem(Product2Id=prod8.Id, Quantity=1, TotalPrice=100, OpportunityId=opp1.Id,PricebookEntryId=pe8.Id);
        insert oppLine8;

        opp1.Main_Product__c = prod8.id;
        update opp1;
        
        
        PricebookEntry pe9 = new PricebookEntry(Pricebook2Id=standardPBId,Product2Id=prod9.id,UnitPrice=100, IsActive = true, UseStandardPrice = false);
        insert pe9;

        OpportunityLineItem oppLine9 = new OpportunityLineItem(Product2Id=prod8.Id, Quantity=1, TotalPrice=100, OpportunityId=opp1.Id,PricebookEntryId=pe9.Id);
        insert oppLine9;


        
        ar = new API_Request__c(Batch__c = true, Created_At__c=DateTime.now());
        insert ar;
        ship = new Shipment__c(Name='Ship', Delivery_Date__c=Date.newInstance(2016, 1, 1), Scheduled_Date__c =system.today().adddays(2), Type__c = 'OnFleet', Status__c = 'Pending', Opportunity__c=opp1.Id, Shipping_Service_Type__c = '1 Day Air');
        insert ship;

        
        ec1 = new Euphebe_Campaign__c(Name='ec1', Status__c='Active', Type__c = 'Daily Drip');
        insert ec1;
		
		
        cs = new Campaign_Step__c(SFDC_Email_Template__c='t1', SMS_Template__c='t1', Step__c=1, Send_Hour__c=11, Euphebe_Campaign__c=ec1.Id, Days_Wait__c=1);
        insert cs;
        
        m = new Meal__c(Name='Meal',Description__c='Meal',Shopify_ID__c='2610863767616',Inventory__c=99);
        insert m;

        m2 = new Meal__c(Name='Meal2',Description__c='Meal2',Shopify_ID__c='2610863767617',Inventory__c=99);
        insert m2;
        
        Menu_Program__c mp = new Menu_Program__c(Name='MP', Number_of_Cycles__c=1, Start_Date__c=Date.newInstance(2016, 1, 1), Order_Cut_Off_Day__c='Friday', Order_Cut_Off_Time__c='06:00', Status__c = 'Active', Hour_Offset_GTM_to_Eastern__c = 4);
        insert mp;
                    
        Menu__c mu = new Menu__c(Name='Menu', Cycle__c=1, Menu_Program__c = mp.Id, Status__c = 'Active');
        insert mu;
                    
        Menu_Entry__c me = new Menu_Entry__c(Name='ME', Meal__c = m.Id, Menu__c = mu.Id);
        insert me;
     
        Case c = new Case(Status='Closed', Last_Email_Date_Sent__c=DateTime.newInstance(2019, 1, 1, 1, 0, 0), Last_Email_Date_Received__c=DateTime.now(), Reply__c=False);
        insert c;
        
        ar2 = new API_Request__c(Provider_Id__c = '12345', Study_ID__c = 'ABC', Batch__c = True);
        insert ar2;
        
        //select Id, Expire_Date_Time__c from API_Session__c Where Expire_Date_Time__c < :now
        as1 = new API_Session__c (Expire_Date_Time__c = DateTime.newInstance(2019, 1, 1, 1, 0, 0));
        insert as1;
    }
    
    
     @isTest
    private static void testBatch(){
        setup();
        Test.startTest();    

           
        DateTime now = DateTime.now();
        String CRON_EXP = '0 0 0 15 6 ? 2050';


        //scheduleBatchCompleteProviderOrders sched6 = new scheduleBatchCompleteProviderOrders();
        //String jobId = system.schedule('batchCompleteProviderOrders',CRON_EXP,sched6);          
        
        Database.executebatch(new batchCleanAPISessions(now,acct.Id));
        Database.executebatch(new batchCleanAPISessions(now,NULL));
        scheduleBatchCleanAPISessions sched7 = new scheduleBatchCleanAPISessions();
        String jobId = system.schedule('batchCleanAPISessions',CRON_EXP,sched7);         
        
        Test.stopTest();        

    }


    @isTest
    private static void testBatch1(){
        setup();
        Test.startTest();    
        
        DateTime now = DateTime.now();
        Database.executebatch(new batchCompleteProviderOrders(now,ar2.Id));
        Database.executebatch(new batchCompleteProviderOrders(now,NULL));
        Database.executebatch(new batchCompleteProviderOrders(now,'provider'));
        Database.executebatch(new batchCompleteProviderOrders(now,'study'));

        
        Test.stopTest();        

    }

    @isTest
    private static void testBatch2(){
        setup();
        Test.startTest();    

        shopifyClass.getShopifyOrderByNumber('S3454');
        shopifyClass.getShopifyOrders(1, '2017-01-01', '2017-10-01');
        shopifyClass.loadShopifyOrders('2017-01-01', '2017-10-01', NULL);

        Shipment__c ship = new Shipment__c(Status__c='Pending', Scheduled_Date__c = Date.today());
        
        DateTime now = DateTime.now();
        Database.executebatch(new batchUpdateShipmentStatus(now,'Set Status',NULL));
        Database.executebatch(new batchUpdateShipmentStatus(now,'Set Status',ship.id));
        
        String CRON_EXP = '0 0 0 15 6 ? 2050';
        scheduleBatchUpdateShipmentStatus sched= new scheduleBatchUpdateShipmentStatus();
        string jobId = system.schedule('batchUpdateShipmentStatusTEST',CRON_EXP,sched);        

        scheduleBatchUpdateShipmentStatusTouch schedt = new scheduleBatchUpdateShipmentStatusTouch();
        jobId = system.schedule('scheduleBatchUpdateShipmentStatusTouchTEST',CRON_EXP,schedt);        
        
        scheduleBatchUpdateShipmentDayBefore schedb = new scheduleBatchUpdateShipmentDayBefore();
        jobId = system.schedule('scheduleBatchUpdateShipmentDayBeforeTEST',CRON_EXP,schedb);        
        
        scheduleBatchUpdateShipmentCoach28Days sche1db = new scheduleBatchUpdateShipmentCoach28Days();
        jobId = system.schedule('scheduleBatchUpdateShipmentCoach28DaysTEST',CRON_EXP,sche1db);        
            
        Database.executebatch(new batchCalcOrderKPIs(now,acct.Id));
        Database.executebatch(new batchCalcOrderKPIs(now,NULL));

        scheduleBatchCalcOrderKPIs sched1 = new scheduleBatchCalcOrderKPIs();
        jobId = system.schedule('batchCalcOrderKPIsTEST',CRON_EXP,sched1);        
        
        
        Test.stopTest();        
    }

    @isTest
    private static void testBatch3(){
        setup();
        Test.startTest();    

        DateTime now = DateTime.now();
        String CRON_EXP = '0 0 0 15 6 ? 2050';
        
        Database.executebatch(new batchUpdateCampaignSteps(NULL));
        scheduleBatchUpdateCampaignSteps sched2 = new scheduleBatchUpdateCampaignSteps();
        string jobId = system.schedule('batchUpdateCampaignStepsTEST',CRON_EXP,sched2);        
        
        Database.executebatch(new batchFixReopenCases(now,acct.Id));
        Database.executebatch(new batchCalcOrderKPIs(now,NULL));

        scheduleBatchFixReopenCases sched5 = new scheduleBatchFixReopenCases();
        jobId = system.schedule('batchFixReopenCases',CRON_EXP,sched5);          
        
        
        Test.stopTest();        
    }
    
    @isTest
    private static void testClasses(){
        
        setup();
        Test.startTest();    
                
        
        shopifyClass.computeUpcomingMondays('xxx');
        
        shopifyClass.parseVariantDate('Monday, May 14, 2018');
        
        shopifyClass.getShopifyOrderByNumber('S3454');
        shopifyClass.getShopifyOrders(1, '2017-01-01', '2017-10-01');
        shopifyClass.loadShopifyOrders('2017-01-01', '2017-10-01', NULL);
        
        shopifyClass.getReChargeCharges(1, '2017-01-01');
        shopifyClass.getReChargeChargesById(1, '112233');
        shopifyClass.getReChargeCustomers(1);
        
        IntegrationDateTimes__c custSettings = new IntegrationDateTimes__c(Name= 'RechargeLastSkip', LastDateTime__c = DateTime.now());
        insert custSettings;
                                                 
        //shopifyClass.getReChargeSkippedCharges(true,null,null);
        //shopifyClass.getReChargeSkippedCharges(false,null,null);
        //shopifyClass.getReChargeSkippedCharges(true,'a@a.com','112233');
        shopifyClass.getReChargeCustomerAsync('','');
        
        API_Request__c apiReqIn = new API_Request__c();
        shopifyClass.shopifyCreateOrder sOrderIn = new shopifyClass.shopifyCreateOrder();
        
        shopifyClass.setSubscription(apiReqIn, '{"subscription":{"Id":"","address_id":""}}', false);
        //sOrderIn.order_number = 111;
        shopifyClass.returnItems ri = shopifyClass.setOrder(apiReqIn, '{"order_number":1111,"customer":{"first_name":"Bob"},"line_items":[{"price":10.00}]}', NULL);
        shopifyClass.defineOrderMap();
            
        API_Request__c ar = new API_Request__c();
        insert ar;
        ar.Enable_Trigger__c = false;
        ar.Request_Type__c = 'Create Order';
        ar.Raw_Request__c = '{}';
        update ar;
        
        // AG 10/22/2019 batchLoadOrders b = new batchLoadOrders();
        //database.executeBatch(b,1);
       // Database.executebatch(new batchLoadOrders(),1);
        
        onfleetClass.onfleetDestination dest = new onfleetClass.onfleetDestination();
        onfleetClass.createDestination(dest);
        
        List<String> ids = new List<String>();
        onfleetClass.onfleetFlow(ids);
        
        
        RestRequest req = new RestRequest();
        req.requestBody = Blob.valueOf('{}');
        RestContext.request = req;
        
        RestResponse response = new RestResponse();
        RestContext.response = response;
        
        RESTOrdersController.setOrder();
        RESTOrdersController.processAPIOrder('{}');
        RESTOrdersController.processOrderError(req, 'Error!');
        
            
        //RESTOrdersController.doGet();
        //RESTOrdersController.setShipment('');
        
        onFleetLabelsAsPDF ofpdf = new onFleetLabelsAsPDF();
        
        shopifyClass.shopifyCreateOrderCustomer sc = new shopifyClass.shopifyCreateOrderCustomer();
        String jsonSC = JSON.serialize(sc);
        
        RESTCustomersController.processRequest(jsonSC);
        RESTCustomersController.processError(req, 'Error!');
        RESTCustomersController.setCustomer();
        RESTCustomersController.getCustomer();
        
        String jsonCont = JSON.serialize(acct);
        String jsonAcct = JSON.serialize(cont);
        shopifyClass.setCustomerFuture(jsonAcct,jsonCont);
        shopifyClass.getShopifyCustomerAddress(acct,cont);
        shopifyClass.setShopifyCustomerAddress(acct,cont,123);
        
        shopifyClass.shopifyCreateOrderCustomer scoc = new shopifyClass.shopifyCreateOrderCustomer();
        //scoc.first_name = 'Bob';
        //scoc.last_name = 'Bob';
        API_Request__c arIn = new API_Request__c();
        jsonSC = JSON.serialize(scoc);
        shopifyClass.setCustomer(arIn, '{"first_name":"Bob","last_name":"Bob","default_address":{"first_name":"Bob","last_name":"Bob"},"phone":"23423423"}');
        
        shopifyClass.getReChargeCustomer('','');
        
        acct.Automated_Update__c=False;
        update acct;
        
        shopifyClass.loadShopifyOrder('1234');
        shopifyClass.loadShopifyOrderFuture('1234');
        
        opp1.Reload__c = True;
        update opp1;
        
       
        shopifyClass.getOtherCustNumber('name1',4);
        shopifyClass.splitName('first last');
        Set<String> keys = new Set<String>();
        keys.add('1~A');
        shopifyClass.findLineId('A',keys);
        
        //ri = shopifyClass.setOrder(apiReqIn,'{"order_number":1111,"email":"libby.wadle@jcrew.com","customer":{"first_name":"Bob"},"line_items":[{"title":"THE WEEKLY (Ships every 2 Weeks)","product_id":7992157899,"price":10.00,"quantity":2,"properties":[{"name":"E-mail Address1","value":"Libby.wadle@jcrew.com"},{"name":"E-mail Address2","value":"Davidh.potter@yahoo.com"},{"name":"Full Name1","value":"Libby Potter"},{"name":"Full Name2","value":"David Potter"}]}]}', NULL);
        //shopifyClass.processAPIRequest(ri, true);

        // Set Order New
       // ri = shopifyClass.setOrder(apiReqIn,'{"id":700264415296,"email":"garcia.alberto.crespo@gmail.com","closed_at":null,"created_at":"2019-01-25T11:14:11-05:00","updated_at":"2019-01-25T11:14:11-05:00","number":1,"note":null,"token":"f06247b16ee866fbc3e21250cfc13188","gateway":"","test":false,"total_price":"0.00","subtotal_price":"0.00","total_weight":0,"total_tax":"0.00","taxes_included":false,"currency":"USD","financial_status":"paid","confirmed":true,"total_discounts":"0.00","total_line_items_price":"0.00","cart_token":null,"buyer_accepts_marketing":false,"name":"#1001","referring_site":null,"landing_site":null,"cancelled_at":null,"cancel_reason":null,"total_price_usd":"0.00","checkout_token":null,"reference":null,"user_id":null,"location_id":null,"source_identifier":null,"source_url":null,"processed_at":"2019-01-25T11:14:11-05:00","device_id":null,"phone":null,"customer_locale":null,"app_id":294517,"browser_ip":null,"landing_site_ref":null,"order_number":1001,"discount_applications":[],"discount_codes":[],"note_attributes":[],"payment_gateway_names":[],"processing_method":"","checkout_id":null,"source_name":"294517","fulfillment_status":null,"tax_lines":[],"tags":"Subscription, Subscription First Order","contact_email":"garcia.alberto.crespo@gmail.com","order_status_url":"","presentment_currency":"USD","total_line_items_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_discounts_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_shipping_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"subtotal_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_tax_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_tip_received":"0.0","line_items":[{"id":1600549453888,"variant_id":24129978826816,"title":"Quickstart (Ships every 1 Weeks)","quantity":1,"price":"0.00","sku":"","variant_title":"","vendor":"Euphebe New","fulfillment_service":"manual","product_id":2610861178944,"requires_shipping":false,"taxable":true,"gift_card":false,"name":"Quickstart (Ships every 1 Weeks)","variant_inventory_management":null,"properties":[{"name":"hdyhau","value":"aaa"},{"name":"shipping_date","value":"February 11, 2019"},{"name":"shipping_interval_frequency","value":"1"},{"name":"shipping_interval_unit_type","value":"Weeks"}],"product_exists":true,"fulfillable_quantity":1,"grams":0,"total_discount":"0.00","fulfillment_status":null,"price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"discount_allocations":[],"tax_lines":[]}],"shipping_lines":[{"id":655205072960,"title":"2-day shipping; will arrive by 8pm 2 days after ship date","price":"0.00","code":"2-day shipping; will arrive by 8pm 2 days after ship date","source":"","phone":null,"requested_fulfillment_service_id":null,"delivery_category":null,"carrier_identifier":null,"discounted_price":"0.00","price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"discounted_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"discount_allocations":[],"tax_lines":[]}],"billing_address":{"first_name":"Alberto","address1":"25A Jackson Pl","phone":"7188327180","city":"Brooklyn","zip":"11215","province":"New York","country":"United States","last_name":"Garcia","address2":"","company":"","latitude":40.66226700000001,"longitude":-73.986283,"name":"Alberto Garcia","country_code":"US","province_code":"NY"},"shipping_address":{"first_name":"Alberto","address1":"25A Jackson Pl","phone":"7188327180","city":"Brooklyn","zip":"11215","province":"New York","country":"United States","last_name":"Garcia","address2":"","company":"","latitude":40.66226700000001,"longitude":-73.986283,"name":"Alberto Garcia","country_code":"US","province_code":"NY"},"fulfillments":[],"refunds":[],"customer":{"id":1229485277248,"email":"garcia.alberto.crespo@gmail.com","accepts_marketing":false,"created_at":"2019-01-25T11:14:10-05:00","updated_at":"2019-01-25T11:14:11-05:00","first_name":"Alberto","last_name":"Garcia","orders_count":1,"state":"enabled","total_spent":"0.00","last_order_id":700264415296,"note":null,"verified_email":true,"multipass_identifier":null,"tax_exempt":false,"phone":null,"tags":"","last_order_name":"#1001","currency":"USD","default_address":{"id":1362754863168,"customer_id":1229485277248,"first_name":"Alberto","last_name":"Garcia","company":"","address1":"25A Jackson Pl","address2":"","city":"Brooklyn","province":"New York","country":"United States","zip":"11215","phone":"7188327180","name":"Alberto Garcia","province_code":"NY","country_code":"US","country_name":"United States","default":true}}}', NULL);
		 // ri = shopifyClass.setOrder(apiReqIn,'{"id":700264415296,"email":"garcia.alberto.crespo@gmail.com","closed_at":null,"created_at":"2019-01-25T11:14:11-05:00","updated_at":"2019-01-25T11:14:11-05:00","number":1,"note":null,"token":"f06247b16ee866fbc3e21250cfc13188","gateway":"","test":false,"total_price":"0.00","subtotal_price":"0.00","total_weight":0,"total_tax":"0.00","taxes_included":false,"currency":"USD","financial_status":"paid","confirmed":true,"total_discounts":"0.00","total_line_items_price":"0.00","cart_token":null,"buyer_accepts_marketing":false,"name":"#1001","referring_site":null,"landing_site":null,"cancelled_at":null,"cancel_reason":null,"total_price_usd":"0.00","checkout_token":null,"reference":null,"user_id":null,"location_id":null,"source_identifier":null,"source_url":null,"processed_at":"2019-01-25T11:14:11-05:00","device_id":null,"phone":null,"customer_locale":null,"app_id":294517,"browser_ip":null,"landing_site_ref":null,"order_number":1001,"discount_applications":[],"discount_codes":[],"note_attributes":[],"payment_gateway_names":[],"processing_method":"","checkout_id":null,"source_name":"294517","fulfillment_status":null,"tax_lines":[],"tags":"Subscription, Subscription First Order","contact_email":"garcia.alberto.crespo@gmail.com","order_status_url":"","presentment_currency":"USD","total_line_items_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_discounts_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_shipping_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"subtotal_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_tax_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_tip_received":"0.0","line_items":[{"id":1600549453888,"variant_id":24129978826816,"title":"Quickstart (Ships every 1 Weeks)","quantity":1,"price":"0.00","sku":"","variant_title":"","vendor":"Euphebe New","fulfillment_service":"manual","product_id":2610861178944,"requires_shipping":false,"taxable":true,"gift_card":false,"name":"Quickstart (Ships every 1 Weeks)","variant_inventory_management":null,"properties":[{"name":"meal_list","value":"Custom Box - test - 1"},{"name":"hdyhau","value":"aaa"},{"name":"shipping_date","value":"February 11, 2019"},{"name":"shipping_interval_frequency","value":"1"},{"name":"shipping_interval_unit_type","value":"Weeks"}],"product_exists":true,"fulfillable_quantity":1,"grams":0,"total_discount":"0.00","fulfillment_status":null,"price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"discount_allocations":[],"tax_lines":[]}],"shipping_lines":[{"id":655205072960,"title":"2-day shipping; will arrive by 8pm 2 days after ship date","price":"0.00","code":"2-day shipping; will arrive by 8pm 2 days after ship date","source":"","phone":null,"requested_fulfillment_service_id":null,"delivery_category":null,"carrier_identifier":null,"discounted_price":"0.00","price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"discounted_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"discount_allocations":[],"tax_lines":[]}],"billing_address":{"first_name":"Alberto","address1":"25A Jackson Pl","phone":"7188327180","city":"Brooklyn","zip":"11215","province":"New York","country":"United States","last_name":"Garcia","address2":"","company":"","latitude":40.66226700000001,"longitude":-73.986283,"name":"Alberto Garcia","country_code":"US","province_code":"NY"},"shipping_address":{"first_name":"Alberto","address1":"25A Jackson Pl","phone":"7188327180","city":"Brooklyn","zip":"11215","province":"New York","country":"United States","last_name":"Garcia","address2":"","company":"","latitude":40.66226700000001,"longitude":-73.986283,"name":"Alberto Garcia","country_code":"US","province_code":"NY"},"fulfillments":[],"refunds":[],"customer":{"id":1229485277248,"email":"garcia.alberto.crespo@gmail.com","accepts_marketing":false,"created_at":"2019-01-25T11:14:10-05:00","updated_at":"2019-01-25T11:14:11-05:00","first_name":"Alberto","last_name":"Garcia","orders_count":1,"state":"enabled","total_spent":"0.00","last_order_id":700264415296,"note":null,"verified_email":true,"multipass_identifier":null,"tax_exempt":false,"phone":null,"tags":"","last_order_name":"#1001","currency":"USD","default_address":{"id":1362754863168,"customer_id":1229485277248,"first_name":"Alberto","last_name":"Garcia","company":"","address1":"25A Jackson Pl","address2":"","city":"Brooklyn","province":"New York","country":"United States","zip":"11215","phone":"7188327180","name":"Alberto Garcia","province_code":"NY","country_code":"US","country_name":"United States","default":true}}}', NULL);
  		  ri = shopifyClass.setOrder(apiReqIn,'{"id":700264415296,"email":"garcia.alberto.crespo@gmail.com","closed_at":null,"created_at":"2019-01-25T11:14:11-05:00","updated_at":"2019-01-25T11:14:11-05:00","number":1,"note":null,"token":"f06247b16ee866fbc3e21250cfc13188","gateway":"","test":false,"total_price":"0.00","subtotal_price":"0.00","total_weight":0,"total_tax":"0.00","taxes_included":false,"currency":"USD","refund_line_items":[{"quantity":"1"}],"financial_status":"paid","confirmed":true,"total_discounts":"0.00","total_line_items_price":"0.00","cart_token":null,"buyer_accepts_marketing":false,"name":"#1001","referring_site":null,"landing_site":null,"cancelled_at":null,"cancel_reason":null,"total_price_usd":"0.00","checkout_token":null,"reference":null,"user_id":null,"location_id":null,"source_identifier":null,"source_url":null,"processed_at":"2019-01-25T11:14:11-05:00","device_id":null,"phone":null,"customer_locale":null,"app_id":294517,"browser_ip":null,"landing_site_ref":null,"order_number":1001,"discount_applications":[],"discount_codes":[],"note_attributes":[],"payment_gateway_names":[],"processing_method":"","checkout_id":null,"source_name":"294517","fulfillment_status":null,"tax_lines":[],"tags":"Subscription, Subscription First Order","contact_email":"garcia.alberto.crespo@gmail.com","order_status_url":"","presentment_currency":"USD","total_line_items_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_discounts_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_shipping_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"subtotal_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_tax_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_tip_received":"0.0","line_items":[{"id":1600549453888,"variant_id":24129978826816,"title":"Quickstart (Ships every 1 Weeks)","quantity":1,"price":"0.00","sku":"","variant_title":"","vendor":"Euphebe New","fulfillment_service":"manual","product_id":2610861178944,"requires_shipping":false,"taxable":true,"gift_card":false,"name":"Quickstart (Ships every 1 Weeks)","variant_inventory_management":null,"properties":[{"name":"meal_list","value":"Custom Box - test - 1"},{"name":"hdyhau","value":"aaa"},{"name":"shipping_date","value":"February 11, 2019"},{"name":"shipping_interval_frequency","value":"1"},{"name":"shipping_interval_unit_type","value":"Weeks"}],"product_exists":true,"fulfillable_quantity":1,"grams":0,"total_discount":"0.00","fulfillment_status":null,"price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"discount_allocations":[],"tax_lines":[]}],"shipping_lines":[{"id":655205072960,"title":"2-day shipping; will arrive by 8pm 2 days after ship date","price":"0.00","code":"2-day shipping; will arrive by 8pm 2 days after ship date","source":"","phone":null,"requested_fulfillment_service_id":null,"delivery_category":null,"carrier_identifier":null,"discounted_price":"0.00","price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"discounted_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"discount_allocations":[],"tax_lines":[]}],"billing_address":{"first_name":"Alberto","address1":"25A Jackson Pl","phone":"7188327180","city":"Brooklyn","zip":"11215","province":"New York","country":"United States","last_name":"Garcia","address2":"","company":"","latitude":40.66226700000001,"longitude":-73.986283,"name":"Alberto Garcia","country_code":"US","province_code":"NY"},"shipping_address":{"first_name":"Alberto","address1":"25A Jackson Pl","phone":"7188327180","city":"Brooklyn","zip":"11215","province":"New York","country":"United States","last_name":"Garcia","address2":"","company":"","latitude":40.66226700000001,"longitude":-73.986283,"name":"Alberto Garcia","country_code":"US","province_code":"NY"},"fulfillments":[],"refunds":[],"customer":{"id":1229485277248,"email":"garcia.alberto.crespo@gmail.com","accepts_marketing":false,"created_at":"2019-01-25T11:14:10-05:00","updated_at":"2019-01-25T11:14:11-05:00","first_name":"Alberto","last_name":"Garcia","orders_count":1,"state":"enabled","total_spent":"0.00","last_order_id":700264415296,"note":null,"verified_email":true,"multipass_identifier":null,"tax_exempt":false,"phone":null,"tags":"","last_order_name":"#1001","currency":"USD","default_address":{"id":1362754863168,"customer_id":1229485277248,"first_name":"Alberto","last_name":"Garcia","company":"","address1":"25A Jackson Pl","address2":"","city":"Brooklyn","province":"New York","country":"United States","zip":"11215","phone":"7188327180","name":"Alberto Garcia","province_code":"NY","country_code":"US","country_name":"United States","default":true}}}', NULL);
 		 ri = shopifyClass.setOrder(apiReqIn,'{"id":700264415296,"email":"garcia.alberto.crespo@gmail.com","closed_at":null,"created_at":"2019-01-25T11:14:11-05:00","updated_at":"2019-01-25T11:14:11-05:00","number":1,"note":null,"token":"f06247b16ee866fbc3e21250cfc13188","gateway":"","test":false,"total_price":"0.00","subtotal_price":"0.00","total_weight":0,"total_tax":"0.00","taxes_included":false,"currency":"USD","refund_line_items":[{"quantity":"1","subtotal":"3","line_item":{"title":"test"}}],"refunds":[{"order_id":1001,"refund_line_items":[{"quantity":"1","subtotal":"3","line_item":{"title":"test"}}]}],"order_adjustments":[{"reason":"test","amount":"2","tax_amount":"2"}],"financial_status":"refunded","confirmed":true,"total_discounts":"0.00","total_line_items_price":"0.00","cart_token":null,"buyer_accepts_marketing":false,"name":"#1001","referring_site":null,"landing_site":null,"cancelled_at":null,"cancel_reason":null,"total_price_usd":"0.00","checkout_token":null,"reference":null,"user_id":null,"location_id":null,"source_identifier":null,"source_url":null,"processed_at":"2019-01-25T11:14:11-05:00","device_id":null,"phone":null,"customer_locale":null,"app_id":294517,"browser_ip":null,"landing_site_ref":null,"order_id":1001,"discount_applications":[],"discount_codes":[],"note_attributes":[],"payment_gateway_names":[],"processing_method":"","checkout_id":null,"source_name":"294517","fulfillment_status":null,"tax_lines":[],"tags":"Subscription, Subscription First Order","contact_email":"garcia.alberto.crespo@gmail.com","order_status_url":"","presentment_currency":"USD","total_line_items_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_discounts_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_shipping_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"subtotal_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_tax_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_tip_received":"0.0","line_items":[{"id":1600549453888,"variant_id":24129978826816,"title":"Quickstart (Ships every 1 Weeks)","quantity":1,"price":"0.00","sku":"","variant_title":"","vendor":"Euphebe New","fulfillment_service":"manual","product_id":2610861178944,"requires_shipping":false,"taxable":true,"gift_card":false,"name":"Quickstart (Ships every 1 Weeks)","variant_inventory_management":null,"properties":[{"name":"meal_list","value":"Custom Box - test - 1"},{"name":"hdyhau","value":"aaa"},{"name":"shipping_date","value":"February 11, 2019"},{"name":"shipping_interval_frequency","value":"1"},{"name":"shipping_interval_unit_type","value":"Weeks"}],"product_exists":true,"fulfillable_quantity":1,"grams":0,"total_discount":"0.00","fulfillment_status":null,"price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"discount_allocations":[],"tax_lines":[]}],"shipping_lines":[{"id":655205072960,"title":"2-day shipping; will arrive by 8pm 2 days after ship date","price":"0.00","code":"2-day shipping; will arrive by 8pm 2 days after ship date","source":"","phone":null,"requested_fulfillment_service_id":null,"delivery_category":null,"carrier_identifier":null,"discounted_price":"0.00","price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"discounted_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"discount_allocations":[],"tax_lines":[]}],"billing_address":{"first_name":"Alberto","address1":"25A Jackson Pl","phone":"7188327180","city":"Brooklyn","zip":"11215","province":"New York","country":"United States","last_name":"Garcia","address2":"","company":"","latitude":40.66226700000001,"longitude":-73.986283,"name":"Alberto Garcia","country_code":"US","province_code":"NY"},"shipping_address":{"first_name":"Alberto","address1":"25A Jackson Pl","phone":"7188327180","city":"Brooklyn","zip":"11215","province":"New York","country":"United States","last_name":"Garcia","address2":"","company":"","latitude":40.66226700000001,"longitude":-73.986283,"name":"Alberto Garcia","country_code":"US","province_code":"NY"},"fulfillments":[],"customer":{"id":1229485277248,"email":"garcia.alberto.crespo@gmail.com","accepts_marketing":false,"created_at":"2019-01-25T11:14:10-05:00","updated_at":"2019-01-25T11:14:11-05:00","first_name":"Alberto","last_name":"Garcia","orders_count":1,"state":"enabled","total_spent":"0.00","last_order_id":700264415296,"note":null,"verified_email":true,"multipass_identifier":null,"tax_exempt":false,"phone":null,"tags":"","last_order_name":"#1001","currency":"USD","default_address":{"id":1362754863168,"customer_id":1229485277248,"first_name":"Alberto","last_name":"Garcia","company":"","address1":"25A Jackson Pl","address2":"","city":"Brooklyn","province":"New York","country":"United States","zip":"11215","phone":"7188327180","name":"Alberto Garcia","province_code":"NY","country_code":"US","country_name":"United States","default":true}}}', NULL);
  
        // New Calls
        // updateOrderInventory() with strIsCustom = 'True', 'False' String orderId, String strIsCustom, String strDeliveryDate
        shopifyClass.updateInventory(opp1.Id,True);
        shopifyClass.updateInventory(opp1.Id,False);
        shopifyClass.linkOrderMeals(opp1.Id,'False','3/4/2019');
        
        ShipmentSummaryController ssc = new ShipmentSummaryController();
        Date dt = ShipmentSummaryController.getNextShippingDate();
        ShipmentSummaryController.initClass(null);
        ShipmentSummaryController.initClass('2018-03-12');

        UPSSummaryController usc = new UPSSummaryController();
        dt = UPSSummaryController.getNextShippingDate();
        UPSSummaryController.initClass(null);
        UPSSummaryController.initClass('2018-03-12');

        
        localCourierSummaryController lcs = new localCourierSummaryController();
        dt = localCourierSummaryController.getNextShippingDate();
        localCourierSummaryController.initClass(null);
        localCourierSummaryController.initClass('2018-03-12');

        SpendKPISummary sksc = new SpendKPISummary();
        SpendKPISummary.initClass(null);

        shopifyClass.sendCarriOrder(ar.Id,opp1.Id);
        
        //shopifyClass.orderWrapper[] ordersList = new List<shopifyClass.orderWrapper>();
        //shopifyClass.shopifyCreateOrder ord = new shopifyClass.shopifyCreateOrder();
        //ord.id = 123;
        //ord.order_id = 1234; 
        Date shippingDate = Date.newInstance(2019, 03, 04);
        Inventory_Projection__c lstInvProj = new Inventory_Projection__c(Name='ip', Chef_Order_Count__c=1, Custom_Order_Count__c=1,Shipping_Date__c=shippingDate);
        insert lstInvProj;
        shopifyClass.calcInventoryProjection('3/4/2019');
        Euphebe_Campaign__c ec2 = new Euphebe_Campaign__c(Name='New ZJ Coach 28 Days', Status__c='Active', Type__c = 'Daily Drip');
        insert ec2;
        Euphebe_Campaign__c ec3 = new Euphebe_Campaign__c(Name='Day of UPS', Status__c='Active', Type__c = 'Daily Drip');
        insert ec3;
        Euphebe_Campaign__c ec4 = new Euphebe_Campaign__c(Name='Day Before UPS', Status__c='Active', Type__c = 'Daily Drip');
        insert ec4;
        
        ca1 = new Campaign_Account__c(Name='ca1', Current_Step__c=0, Euphebe_Campaign__c=ec1.Id, Account__c=acct.Id);
        insert ca1;
        
        list<Campaign_Account__c> calist = new List<Campaign_Account__c>();
        Campaign_Account__c caaccount = new Campaign_Account__c(Name='ca1', Current_Step__c=0, Euphebe_Campaign__c=ec2.Id, Account__c=acct.Id,Start_Date__c = system.today());
        calist.add(caaccount); 
        Campaign_Account__c caaccount1 = new Campaign_Account__c(Name='ca1', Current_Step__c=0, Euphebe_Campaign__c=ec3.Id, Account__c=acct.Id,Start_Date__c = system.today());
        calist.add(caaccount1);
        Campaign_Account__c caaccount2 = new Campaign_Account__c(Name='ca1', Current_Step__c=0, Euphebe_Campaign__c=ec4.Id, Account__c=acct.Id,Start_Date__c = system.today()); 
        calist.add(caaccount2);
        insert calist;
        ship.Scheduled_Date__c = system.today().adddays(-2);
        update ship;
		shopifyClass.changeShipDate(ship.Id);
        ship.Scheduled_Date__c = system.today().adddays(2);
        update ship;
		shopifyClass.changeShipDate(ship.Id);
        calist = new List<Campaign_Account__c>();
        caaccount.Start_Date__c = system.today().adddays(2);
        calist.add(caaccount);
        caaccount1.Start_Date__c = system.today().adddays(2);
        calist.add(caaccount1);
        caaccount2.Start_Date__c = system.today().adddays(2);
        calist.add(caaccount2);
        update calist;
        opp1.Is_Custom__c = false; 
        opp1.Affiliate_Is_First_Order__c =true;
        opp1.Main_Product__c = prod10.id;
        update opp1;
        
        shopifyClass.changeShipDate(ship.Id);
       
        Meal_Line_Item__c mli = new Meal_Line_Item__c(Name='Meal',EOrder__c=opp1.Id,Meal__c=m.Id,Quantity__c=3);
        insert mli;
        
        mli.Meal__c=m2.id;
        mli.Enable_Inventory_Sync__c = True;
 
        update mli;
        List<List<String>> inputParams = new List<List<String>>{
            new List<String>{'linkMeals',opp1.Id,'false','12/27/2015'} 
        };
        
        shopifyClass.shopifyMethods(inputParams);
        shopifyClass.updateInventory(opp1.Id,false);
        shopifyClass.linkMeals(opp1.id,false);
        shopifyClass.linkMeals(opp1.id,true);
        shopifyClass.putMealsBackIntoInventory(opp1.id,'false'); 
        shopifyClass.computeSamplerMeals(true);
         shopifyClass.computeSamplerMeals(false);
        shopifyClass.computeSeasonalMeals(false);
        shopifyClass.shopifyCreateOrder ord = new shopifyClass.shopifyCreateOrder();
        shopifyClass.shopifyCreateOrder shopify =new shopifyClass.shopifyCreateOrder(); 
        shopifyClass.orderWrapper orw = new shopifyClass.orderWrapper(shopify); 
        API_Request__c arIn1 = new API_Request__c(Batch__c = true, Created_At__c=DateTime.now());
        insert arIn1;
         shopifyClass.createOrdersFuture(arIn1.Id);
        
        //IntegrationDateTimes__c = new IntegrationDateTimes__c(Name='MealLastUpdated');
        List<List<String>> inputParams1 = new List<List<String>>{
            new List<String>{'updateLastMealUpdatedDate'} 
        };
        shopifyClass.shopifyMethods(inputParams1);

        List<List<String>> inputParams2 = new List<List<String>>{
            new List<String>{'updateMealPlan'} 
        };
        shopifyClass.shopifyMethods(inputParams2);
        
        shopifyClass.updateShopifyInventoryNotFuture('ABC',1);
        shopifyClass.updateShopifyInventory('ABC',1);
        
        
        Test.stopTest();        
    }
    
    
}