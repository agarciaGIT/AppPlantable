@isTest 
public class RESTOrdersController_test {
    
    static Opportunity opp1;
    static Shipment__c ship1;
    static Charge__c c;
    static Meal__c m;
    static Integer minMeals = 14;
    static Decimal totalPrice = 250;
    
    public static void setup(){
        
        Id pricebookId = Test.getStandardPricebookId();
        
        Product2 p1 = new Product2(Name='ZPEALC', ProductCode='ZPEALC', Shopify_Product_Id__c='9466290251', Number_of_Cycles__c=1, Description__c='Prod',Available_to_External_Marketplace__c=True, Inventory__c=99, IsActive=True);
        insert p1;
                
        PricebookEntry pe1 = new PricebookEntry(Unitprice=totalPrice, Product2Id=p1.Id, Pricebook2Id=pricebookId);
        insert pe1;

        Product2 p2 = new Product2(Name='MISC', ProductCode='EMisc', Shopify_Product_Id__c='MISC', Number_of_Cycles__c=1, Description__c='MISC',Available_to_External_Marketplace__c=True, Inventory__c=99, IsActive=True);
        insert p2;
                
        PricebookEntry pe2 = new PricebookEntry(Unitprice=100.00, Product2Id=p2.Id, Pricebook2Id=pricebookId);
        insert pe2;

        Product2 p3 = new Product2(Name='Ship', ProductCode='EShip', Shopify_Product_Id__c='Ship', Number_of_Cycles__c=1, Description__c='MISC',Available_to_External_Marketplace__c=True, Inventory__c=99, IsActive=True);
        insert p3;
                
        PricebookEntry pe3 = new PricebookEntry(Unitprice=100.00, Product2Id=p3.Id, Pricebook2Id=pricebookId);
        insert pe3;

        
        opp1 = new Opportunity(Name='Opp1', StageName='Closed Won',Amount=100.00,CloseDate=Date.today(),External_Order_Number__c='Z0001');
        insert opp1;
        
        
        ship1 = new Shipment__c(Name='Ship1', Status__c='Pending', Scheduled_Date__c=Date.today(), Delivery_Date__c=Date.today(), Opportunity__c = opp1.Id);
        insert ship1;
        
        // List<UPS_Zip_Codes__c> listCodes = [select id, Price__c, Zip__c, State__c, State_Code__c from UPS_Zip_Codes__c where Zip__c = :rpo.shipping_address.zip OR State__c = :rpo.shipping_address.state OR State_Code__c =:rpo.shipping_address.state];
         
        UPS_Zip_Codes__c ups1 = new UPS_Zip_Codes__c(Price__c=15.00,Zip__c='11215',State__c='New York',State_Code__c='NY');
        insert ups1;
        
        //List<Charge__c> lstCharge = [select Id, Name, Amount__c, Gateway_Token__c, Gateway_Date_Time__c, Opportunity__c, Source__c from Charge__c where Id = :chargeID];
		c = new Charge__c(Name='C', Amount__c=100.00, Gateway_Token__c='123',Gateway_Date_Time__c=Date.today(),Opportunity__c=opp1.Id, Source__c='visa');
		insert c;
        
		m = new Meal__c(Name='Meal',Description__c='Meal',Shopify_ID__c='2610863767616',API_Enabled__c = True,Inventory__c=99);
        insert m;
        
    }
    
    @isTest
    private static void test1(){
        setup();
        Test.startTest();    
                        
		RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        request.requestUri ='https://parcopy-euphebe.cs95.force.com/services/apexrest/orders/Z0001';
        request.httpMethod = 'GET';
		//request.requestBody = Blob.valueof(jsonReq);
        
        RestContext.request = request;
        RestContext.response = response;
        RESTOrdersController.getOrder();

        request.httpMethod = 'PUT';
        String jsonReq = '{"order_status": "cancelled"}';
        request.requestBody = Blob.valueof(jsonReq);
        RESTOrdersController.putOrder();
        
        Decimal price = totalPrice / minMeals;
        price = price.setScale(2);

        // PreProcess
        request.requestUri ='https://parcopy-euphebe.cs95.force.com/services/apexrest/orders/Z0001/preprocess';
        request.httpMethod = 'POST';
		jsonReq = '{"provider" : "zipongo", "order_number" : "ZP0002","first_name": "John","last_name": "Smith","email": "jsmith@gmail.com","phone": "1234567890","billing_address": {"company": "","address1": "25 Elm St.","address2": "Apt 2F","address3": "","city": "Brooklyn","state": "NY","zip": "11215"},"shipping_instructions": "Leave by door","shipping_address": {"company": "","address1": "25 Elm St.","address2": "Apt 2F","address3": "","city": "Brooklyn","state": "NY","zip": "11215"},"items": [{"type": "meal","name": "A-la-carte","code": "2610863767616","quantity": 14,"price": ' + price  + '},{"type": "shipping","name": "1 Day Ground","code": "1 Day Ground","quantity": 1,"price": 10.00},{"type": "tax","quantity": 1,"price": 0,"name": "Tax","code": "ETAX"}],"charge":{"gateway_token":"xyz","gateway_datetime":"1538323099","amount_charged":123.50,"source":"visa","charge_req":"...","charge_resp":".."}}';        
        request.requestBody = Blob.valueof(jsonReq);
        RESTOrdersController.setOrder();
        
        // POSTProcess
        request.requestUri ='https://parcopy-euphebe.cs95.force.com/services/apexrest/orders/Z0001';
        request.httpMethod = 'POST';
		jsonReq = '{"provider" : "zipongo", "order_number" : "ZP0002","first_name": "John","last_name": "Smith","email": "jsmith@gmail.com","phone": "1234567890","billing_address": {"company": "","address1": "25 Elm St.","address2": "Apt 2F","address3": "","city": "Brooklyn","state": "NY","zip": "11215"},"shipping_instructions": "Leave by door","shipping_address": {"company": "","address1": "25 Elm St.","address2": "Apt 2F","address3": "","city": "Brooklyn","state": "NY","zip": "11215"},"items": [{"type": "meal","name": "A-la-carte","code": "2610863767616","quantity": 14,"price": ' + price  + '},{"type": "shipping","name": "1 Day Ground","code": "1 Day Ground","quantity": 1,"price": 10.00},{"type": "tax","quantity": 1,"price": 0,"name": "Tax","code": "ETAX"}],"charge":{"gateway_token":"xyz","gateway_datetime":"1538323099","amount_charged":123.50,"source":"visa","charge_req":"...","charge_resp":".."}}';        
        request.requestBody = Blob.valueof(jsonReq);
        RESTOrdersController.setOrder();
        


        // Missing Info 1
        request.requestUri ='https://parcopy-euphebe.cs95.force.com/services/apexrest/orders/Z0001/preprocess';
        request.httpMethod = 'POST';
        jsonReq = '{"provider" : "zipongo", "order_number" : "ZP0002","first_name": "John","last_name": "Smith","email": "jsmith@gmail.com","phone": "1234567890","billing_address": {"company": "","address1": "25 Elm St.","address2": "Apt 2F","address3": "","city": "Brooklyn","state": "NY","zip": "11215"},"shipping_instructions": "Leave by door","shipping_address": {"company": "","address1": "25 Elm St.","address2": "Apt 2F","address3": "","city": "Brooklyn","state": "NY","zip": "11215"},"items": [{"type": "meal","name": "A-la-carte","code": "2610863767616","quantity": 14,"price": ' + price  + '},{"type": "shipping","name": "1 Day Ground","code": "1 Day Ground","quantity": 1,"price": 10.00}]}';        
        request.requestBody = Blob.valueof(jsonReq);
        RESTOrdersController.setOrder();
        
        // Missing Info 2
        request.requestUri ='https://parcopy-euphebe.cs95.force.com/services/apexrest/orders/Z0001/preprocess';
        request.httpMethod = 'POST';
        jsonReq = '{"provider" : "zipongo", "order_number" : "ZP0002","first_name": "John","last_name": "Smith","phone": "1234567890","billing_address": {"company": "","address1": "25 Elm St.","address2": "Apt 2F","address3": "","city": "Brooklyn","state": "NY","zip": "11215"},"shipping_instructions": "Leave by door","shipping_address": {"company": "","address1": "25 Elm St.","address2": "Apt 2F","address3": "","city": "Brooklyn","state": "NY","zip": "11215"},"items": [{"type": "meal","name": "A-la-carte","code": "2610863767616","quantity": 14,"price": ' + price  + '},{"type": "shipping","name": "1 Day Ground","code": "1 Day Ground","quantity": 1,"price": 10.00}],"charge":{"gateway_token":"xyz","gateway_datetime":"1538323099","amount_charged":123.50,"source":"visa","charge_req":"...","charge_resp":".."}}';
        request.requestBody = Blob.valueof(jsonReq);
        RESTOrdersController.setOrder();
        
        // Missing Info 3
        request.requestUri ='https://parcopy-euphebe.cs95.force.com/services/apexrest/orders/Z0001/preprocess';
        request.httpMethod = 'POST';
        jsonReq = '{"provider" : "zipongo", "order_number" : "ZP0002","first_name": "John","last_name": "Smith","email": "jsmith@gmail.com","phone": "1234567890","shipping_instructions": "Leave by door","items": [{"type": "meal","name": "A-la-carte","code": "2610863767616","quantity": 14,"price": ' + price  + '},{"type": "shipping","name": "1 Day Ground","code": "1 Day Ground","quantity": 1,"price": 15.00}],"charge":{"gateway_token":"xyz","gateway_datetime":"1538323099","amount_charged":123.50,"source":"visa","charge_req":"...","charge_resp":".."}}';
        request.requestBody = Blob.valueof(jsonReq);
        RESTOrdersController.setOrder();
        
        // Missing Info 4
        request.requestUri ='https://parcopy-euphebe.cs95.force.com/services/apexrest/orders/Z0001/preprocess';
        request.httpMethod = 'POST';
        jsonReq = '{"provider" : "zipongo", "order_number" : "ZP0002","first_name": "John","last_name": "Smith","email": "jsmith@gmail.com","phone": "1234567890","billing_address": {"company": "","address1": "25 Elm St.","address2": "Apt 2F","address3": "","city": "Brooklyn","state": "NY","zip": "11215"},"shipping_instructions": "Leave by door","shipping_address": {"company": "","address1": "25 Elm St.","address2": "Apt 2F","address3": "","city": "Brooklyn","state": "NY","zip": "11215"},"items": [{"type": "shipping","name": "1 Day Ground","code": "1 Day Ground","quantity": 1,"price": 15.00}],"charge":{"gateway_token":"xyz","gateway_datetime":"1538323099","amount_charged":123.50,"source":"visa","charge_req":"...","charge_resp":".."}}';
        request.requestBody = Blob.valueof(jsonReq);
        RESTOrdersController.setOrder();
        
        // Missing Info 5
        request.requestUri ='https://parcopy-euphebe.cs95.force.com/services/apexrest/orders/Z0001/preprocess';
        request.httpMethod = 'POST';
        jsonReq = '{"provider" : "zipongo", "order_number" : "ZP0002","first_name": "John","last_name": "Smith","email": "jsmith@gmail.com","phone": "1234567890","billing_address": {"company": "","address1": "25 Elm St.","address2": "Apt 2F","address3": "","city": "Brooklyn","state": "NY","zip": "11215"},"shipping_instructions": "Leave by door","shipping_address": {"company": "","address1": "25 Elm St.","address2": "Apt 2F","address3": "","city": "Brooklyn","state": "NY","zip": "11215"},"items": [{"type": "meal","name": "A-la-carte","code": "2610863767616","quantity": 14,"price": ' + price  + '}],"charge":{"gateway_token":"xyz","gateway_datetime":"1538323099","amount_charged":123.50,"source":"visa","charge_req":"...","charge_resp":".."}}';
        request.requestBody = Blob.valueof(jsonReq);
        RESTOrdersController.setOrder();
        
        
        // Missing Info 6
        request.requestUri ='https://parcopy-euphebe.cs95.force.com/services/apexrest/orders/Z0001';
        request.httpMethod = 'POST';
        jsonReq = '{"provider" : "zipongo", "order_number" : "ZP0002","last_name": "Smith","email": "jsmith@gmail.com","phone": "1234567890","billing_address": {"company": "","address1": "25 Elm St.","address2": "Apt 2F","address3": "","city": "Brooklyn","state": "NY","zip": "11215"},"shipping_instructions": "Leave by door","shipping_address": {"company": "","address1": "25 Elm St.","address2": "Apt 2F","address3": "","city": "Brooklyn","state": "NY","zip": "11215"},"items": [{"type": "meal","name": "A-la-carte","code": "2610863767616","quantity": 14,"price": ' + price  + '},{"type": "shipping","name": "1 Day Ground","code": "1 Day Ground","quantity": 1,"price": 15.00}],"charge":{"gateway_token":"xyz","gateway_datetime":"1538323099","amount_charged":123.50,"source":"visa","charge_req":"...","charge_resp":".."}}';
        request.requestBody = Blob.valueof(jsonReq);
        RESTOrdersController.setOrder();


        // Missing Info 7
        request.requestUri ='https://parcopy-euphebe.cs95.force.com/services/apexrest/orders/Z0001/preprocess';
        request.httpMethod = 'POST';
		jsonReq = '{"provider" : "zipongo", "order_number" : "ZP0002","first_name": "John","last_name": "Smith","email": "jsmith@gmail.com","phone": "1234567890","billing_address": {"company": "","address1": "25 Elm St.","address2": "Apt 2F","address3": "","city": "Brooklyn","state": "CA","zip": "11111"},"shipping_instructions": "Leave by door","shipping_address": {"company": "","address1": "25 Elm St.","address2": "Apt 2F","address3": "","city": "Brooklyn","state": "CA","zip": "11111"},"items": [{"type": "meal","name": "A-la-carte","code": "2610863767616","quantity": 14,"price": ' + price  + '},{"type": "shipping","name": "1 Day Ground","code": "1 Day Ground","quantity": 1,"price": 15.00},{"type": "tax","quantity": 1,"price": 0,"name": "Tax","code": "ETAX"}],"charge":{"gateway_token":"xyz","gateway_datetime":"1538323099","amount_charged":123.50,"source":"visa","charge_req":"...","charge_resp":".."}}';        
        request.requestBody = Blob.valueof(jsonReq);
        RESTOrdersController.setOrder();
        request.requestUri ='https://parcopy-euphebe.cs95.force.com/services/apexrest/orders/Z0001';
        RESTOrdersController.setOrder();


        // Missing Info 8
        // jsonReq = '{"provider" : "zipongo", "order_number" : "ZP0002","first_name": "John","last_name": "Smith","email": "jsmith@gmail.com","phone": "1234567890","billing_address": {"company": "","address1": "25 Elm St.","address2": "Apt 2F","address3": "","city": "Brooklyn","state": "NY","zip": "11215"},"shipping_instructions": "Leave by door","shipping_address": {"company": "","address1": "25 Elm St.","address2": "Apt 2F","address3": "","city": "Brooklyn","state": "NY","zip": "11215"},"items": [{"type": "meal","name": "A-la-carte","code": "2610863767616","quantity": 14,"price": ' + price  + '},{"type": "shipping","name": "1 Day Ground","code": "1 Day Ground","quantity": 1,"price": 15.00},{"type": "tax","quantity": 1,"price": 0,"name": "Tax","code": "ETAX"}],"charge":{"gateway_token":"xyz","gateway_datetime":"1538323099","amount_charged":123.50,"source":"visa","charge_req":"...","charge_resp":".."}}';        
        request.requestUri ='https://parcopy-euphebe.cs95.force.com/services/apexrest/orders/Z0001/preprocess';
        request.httpMethod = 'POST';
		jsonReq = '{"provider" : "zipongo", "order_number" : "ZP0002","first_name": "John","last_name": "Smith","email": "jsmith@gmail.com","phone": "1234567890","billing_address": {"company": "","address1": "25 Elm St.","address2": "Apt 2F","address3": "","city": "Brooklyn","state": "NY","zip": "11215"},"shipping_instructions": "Leave by door","shipping_address": {"company": "","address2": "Apt 2F","address3": "","city": "Brooklyn","state": "NY","zip": "11215"},"items": [{"type": "meal","name": "A-la-carte","code": "2610863767616","quantity": 14,"price": ' + price  + '},{"type": "shipping","name": "1 Day Ground","code": "1 Day Ground","quantity": 1,"price": 15.00},{"type": "tax","quantity": 1,"price": 0,"name": "Tax","code": "ETAX"}],"charge":{"gateway_token":"xyz","gateway_datetime":"1538323099","amount_charged":123.50,"source":"visa","charge_req":"...","charge_resp":".."}}';                request.requestBody = Blob.valueof(jsonReq);
        RESTOrdersController.setOrder();
        request.requestUri ='https://parcopy-euphebe.cs95.force.com/services/apexrest/orders/Z0001';
        RESTOrdersController.setOrder();

        // Missing Info 9
        // jsonReq = '{"provider" : "zipongo", "order_number" : "ZP0002","first_name": "John","last_name": "Smith","email": "jsmith@gmail.com","phone": "1234567890","billing_address": {"company": "","address1": "25 Elm St.","address2": "Apt 2F","address3": "","city": "Brooklyn","state": "NY","zip": "11215"},"shipping_instructions": "Leave by door","shipping_address": {"company": "","address1": "25 Elm St.","address2": "Apt 2F","address3": "","city": "Brooklyn","state": "NY","zip": "11215"},"items": [{"type": "meal","name": "A-la-carte","code": "2610863767616","quantity": 14,"price": ' + price  + '},{"type": "shipping","name": "1 Day Ground","code": "1 Day Ground","quantity": 1,"price": 15.00},{"type": "tax","quantity": 1,"price": 0,"name": "Tax","code": "ETAX"}],"charge":{"gateway_token":"xyz","gateway_datetime":"1538323099","amount_charged":123.50,"source":"visa","charge_req":"...","charge_resp":".."}}';        
        request.requestUri ='https://parcopy-euphebe.cs95.force.com/services/apexrest/orders/Z0001/preprocess';
        request.httpMethod = 'POST';
		jsonReq = '{"provider" : "zipongo", "order_number" : "ZP0002","first_name": "John","last_name": "Smith","email": "jsmith@gmail.com","phone": "1234567890","billing_address": {"company": "","address1": "25 Elm St.","address2": "Apt 2F","address3": "","city": "Brooklyn","state": "NY","zip": "11215"},"shipping_instructions": "Leave by door","shipping_address": {"company": "","address1": "25 Elm St.","address2": "Apt 2F","address3": "","city": "Brooklyn","state": "NY","zip": "11215"},"items": [{"type": "meal","name": "A-la-carte","code": "26108637676XX","quantity": 14,"price": ' + price  + '},{"type": "shipping","name": "1 Day Ground","code": "1 Day Ground","quantity": 1,"price": 15.00},{"type": "tax","quantity": 1,"price": 0,"name": "Tax","code": "ETAX"}],"charge":{"gateway_token":"xyz","gateway_datetime":"1538323099","amount_charged":123.50,"source":"visa","charge_req":"...","charge_resp":".."}}';                RESTOrdersController.setOrder();
        RESTOrdersController.setOrder();
        request.requestUri ='https://parcopy-euphebe.cs95.force.com/services/apexrest/orders/Z0001';
        RESTOrdersController.setOrder();

        
		//Other
		
        // Dupe Charge
        //List<API_Request__c> lstAPIReqCharge = [select Id, Name, Charge_Token__c from API_Request__c where Charge_Token__c = :ro.charge.gateway_token];
        API_Request__c a3 = new API_Request__c(Name='Dupe',Charge_Token__c='xyz');
        insert a3;
        
        request.requestUri ='https://parcopy-euphebe.cs95.force.com/services/apexrest/orders/Z0001';
        request.httpMethod = 'POST';
		jsonReq = '{"provider" : "zipongo", "order_number" : "ZP0002","first_name": "John","last_name": "Smith","email": "jsmith@gmail.com","phone": "1234567890","billing_address": {"company": "","address1": "25 Elm St.","address2": "Apt 2F","address3": "","city": "Brooklyn","state": "NY","zip": "11215"},"shipping_instructions": "Leave by door","shipping_address": {"company": "","address1": "25 Elm St.","address2": "Apt 2F","address3": "","city": "Brooklyn","state": "NY","zip": "11215"},"items": [{"type": "meal","name": "A-la-carte","code": "2610863767616","quantity": 14,"price": ' + price  + '},{"type": "shipping","name": "1 Day Ground","code": "1 Day Ground","quantity": 1,"price": 15.00},{"type": "tax","quantity": 1,"price": 0,"name": "Tax","code": "ETAX"}],"charge":{"gateway_token":"xyz","gateway_datetime":"1538323099","amount_charged":123.50,"source":"visa","charge_req":"...","charge_resp":".."}}';                
		//jsonReq = '{"provider" : "zipongo", "order_number" : "ZP0002","first_name": "John","last_name": "Smith","email": "jsmith@gmail.com","phone": "1234567890","billing_address": {"company": "","address1": "25 Elm St.","address2": "Apt 2F","address3": "","city": "Brooklyn","state": "NY","zip": "11215"},"shipping_instructions": "Leave by door","shipping_address": {"company": "","address1": "25 Elm St.","address2": "Apt 2F","address3": "","city": "Brooklyn","state": "NY","zip": "11215"},"items": [{"type": "product","name": "A-la-carte","code": "2610863767616","quantity": 1,"price": 50.00},{"type": "shipping","name": "1 Day Ground","code": "1 Day Ground","quantity": 1,"price": 15.00},{"type": "tax","quantity": 1,"price": 0,"name": "Tax","code": "ETAX"}]],"charge":{"gateway_token":"xyz","gateway_datetime":"1538323099","amount_charged":123.50,"source":"visa","charge_req":"...","charge_resp":".."}}';        
        request.requestBody = Blob.valueof(jsonReq);
        RESTOrdersController.setOrder();
        
        RESTOrdersController.processAPIOrder('{"id":454629228662,"email":"alexandre.pagliano@gmail.com","closed_at":null,"created_at":"2018-04-13T22:44:45-04:00","updated_at":"2018-04-13T22:44:52-04:00","number":4248,"note":null,"token":"f00316cf5c138f0add348b0aa319b0fb","gateway":"shopify_payments","test":false,"total_price":"165.00","subtotal_price":"150.00","total_weight":454,"total_tax":"0.00","taxes_included":false,"currency":"USD","financial_status":"paid","confirmed":true,"total_discounts":"0.00","total_line_items_price":"150.00","cart_token":"7bf43b13ab1f9cf30a71a681fdc937c6","buyer_accepts_marketing":true,"name":"#S5248","referring_site":"","landing_site":"/","cancelled_at":null,"cancel_reason":null,"total_price_usd":"165.00","checkout_token":"aed016555736cddfcbdf70cdb21b6045","reference":null,"user_id":null,"location_id":null,"source_identifier":null,"source_url":null,"processed_at":"2018-04-13T22:44:45-04:00","device_id":null,"phone":null,"customer_locale":"en","app_id":580111,"browser_ip":"72.227.236.19","landing_site_ref":null,"order_number":7248,"discount_codes":[],"note_attributes":[],"payment_gateway_names":["shopify_payments"],"processing_method":"direct","checkout_id":3847687274614,"source_name":"web","fulfillment_status":null,"tax_lines":[],"tags":"","contact_email":"alexandre.pagliano@gmail.com","order_status_url":"https://www.euphebe.com/16708417/orders/f00316cf5c138f0add348b0aa319b0fb/authenticate?key=dde0a69cc70d5e0772ae17dcbbd2c6f5","line_items":[{"id":1125608816758,"variant_id":34461252939,"title":"A LA CARTE","quantity":1,"price":"150.00","sku":"","variant_title":"","vendor":" Euphebe","fulfillment_service":"manual","product_id":9466290251,"requires_shipping":true,"taxable":false,"gift_card":false,"name":"A LA CARTE","variant_inventory_management":null,"properties":[{"name":"Ship Date","value":"04/16/2018"},{"name":"time","value":"13_3_2018_22_43_14"},{"name":"lunchtime-quesarita-with-green-salsa","value":"2"},{"name":"mexican-artichoke-flats","value":"2"},{"name":"eggplant-sugo-with-red-lentil-rotini","value":"2"},{"name":"willies-eggplant-wrap-with-tomato-sauce","value":"2"},{"name":"rachels-veggie-burger-with-sweet-potato-fries-ketchup","value":"3"}],"product_exists":true,"fulfillable_quantity":1,"grams":454,"total_discount":"0.00","fulfillment_status":null,"tax_lines":[],"origin_location":{"id":2581205003,"country_code":"US","province_code":"NY","name":"Euphebe","address1":"85 Broad Street","address2":"29th Floor","city":"New York","zip":"10004"}}],"shipping_lines":[{"id":380917317750,"title":"Local NYC Courier (arrives before 5pm same day as ship date)","price":"15.00","code":"LOCAL_NYC_COURIER","source":"PI Bespoke Shipping","phone":null,"requested_fulfillment_service_id":null,"delivery_category":null,"carrier_identifier":"2eb5eb8105d77d0a56ca5c0e08aab1e3","discounted_price":"15.00","tax_lines":[]}],"billing_address":{"first_name":"Alexandre","address1":"325 North End Avenue","phone":"(347) 387-4193","city":"New York","zip":"10282","province":"New York","country":"United States","last_name":"Pagliano","address2":"Apt 25A","company":"","latitude":40.7169963,"longitude":-74.0149991,"name":"Alexandre Pagliano","country_code":"US","province_code":"NY"},"shipping_address":{"first_name":"Alexandre","address1":"325 North End Avenue","phone":"(347) 387-4193","city":"New York","zip":"10282","province":"New York","country":"United States","last_name":"Pagliano","address2":"Apt 25A","company":"","latitude":40.7169963,"longitude":-74.0149991,"name":"Alexandre Pagliano","country_code":"US","province_code":"NY"},"fulfillments":[],"client_details":{"browser_ip":"72.227.236.19","accept_language":"en-us","user_agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.1 Safari/605.1.15","session_hash":"4d9dabd9a354ad6e2885001bdcb79e17","browser_width":1315,"browser_height":786},"refunds":[],"payment_details":{"credit_card_bin":"414720","avs_result_code":"Y","cvv_result_code":null,"credit_card_number":"•••• •••• •••• 6704","credit_card_company":"Visa"},"customer":{"id":4391673355,"email":"alexandre.pagliano@gmail.com","accepts_marketing":true,"created_at":"2017-05-25T22:46:01-04:00","updated_at":"2018-04-13T22:44:45-04:00","first_name":"Alexandre","last_name":"Pagliano","orders_count":20,"state":"enabled","total_spent":"8007.50","last_order_id":454629228662,"note":"","verified_email":true,"multipass_identifier":null,"tax_exempt":false,"phone":null,"tags":"","last_order_name":"#S5248","default_address":{"id":315847442443,"customer_id":4391673355,"first_name":"Alexandre","last_name":"Pagliano","company":"","address1":"325 North End Avenue","address2":"Apt 25A","city":"New York","province":"New York","country":"United States","zip":"10282","phone":"(347) 387-4193","name":"Alexandre Pagliano","province_code":"NY","country_code":"US","country_name":"United States","default":true}}}');

        RESTOrdersController.chargeStripe(c.Id);
        
        List<List<String>> ls1 = new List<List<String>>();
        List<String> ls2 = new List<String>();
        ls2.add('chargeStripe');
        ls2.add('1234');
        ls1.add(ls2);
        RESTOrdersController.orderMethods(ls1);				
        
        
        Test.stopTest();        
    }
    
}