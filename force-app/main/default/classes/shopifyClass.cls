public class shopifyClass {


    public class affiliatlyGetOrdersRespOrder{
        public String id_order;
        public String id_affiliate;
        public String is_paid;
    }


    public class affiliatlyGetOrdersResp {
        public List<affiliatlyGetOrdersRespOrder> result;
    }

    public class checkAffiliateOrderData {
        Boolean isNewAffiliateOrder;
        String affiliateID;
    }

    public class reChargeSubscription {
        reChargeSubscriptionDetails subscription;
    }
    
    public class reChargeSubscriptionDetails {
        String id;
        String address_id;
        String customer_id;
        String status;
        String order_interval_frequency;
    }

    public class reChargeCustomer {
        reChargeCustomerDetail customer;
    }

    public class reChargeCustomers {
        List<reChargeCustomerDetail> customers;
    }
    
    public class reChargeCustomerDetail {
        String id;
        String shopify_customer_id;
        String email;
    }

    public class reChargeCharge {
        LIST<reChargeChargeDetail> charges;
    }

    public class reChargeChargeDetail {
        String customer_id;
        String updated_at;
        String status;
        String scheduled_at;
    }
    
    public class shopifyExistingOrder
    {
        Long id;
        Long order_id;
        String financial_status;
        String notes;
        List<shopifyCreateOrderRefundLineItems> refund_line_items;
        List<shopifyOrderAdjustments> order_adjustments;
        List<shopifyOrderRefund> refunds;
    }

    public class shopifyOrder {
        shopifyCreateOrder order;
    }
    
    public class shopifyOrders {
        List<shopifyCreateOrder> orders;
    }

    public class shopifyCustomerAddresses
    {
        List<shopifyCreateOrderAddress> addresses;
    }

    public class shopifySetCustomerAddress 
    {
        shopifyCreateOrderAddress address;
    }
        
    public class shopifySetCustomer 
    {
        shopifyCreateOrderCustomer customer;
    }

    /*
    @TestVisible    
    public class shopifyCreateOrder
    {
        Long id;
        Long order_id;
        String token;
        String email;
        String created_at;
        String total_price;
        String total_tax;
        String name;
        Integer order_number;
        String phone;
        String financial_status;
        String total_discounts;
        shopifyCreateOrderShippingLines shippingLines;
        List<shopifyCreateOrderLineItemsProperties> note_attributes;
        List<shopifyCreateOrderLineItems> line_items;
        shopifyCreateOrderAddress billing_address;
        shopifyCreateOrderAddress shipping_address;
        shopifyCreateOrderCustomer customer;
        List<shopifyCreateOrderDiscountCodes> discount_codes;
        List<shopifyCreateOrderShippingLine> shipping_lines;
    }    
    */
    
    @TestVisible    
    public class shopifyCreateOrder
    {
        Long id;
        Long order_id;
        String token;
        String email;
        String created_at;
        String total_price;
        String total_tax;
        String name;
        Integer order_number;
        String order_status_url;
        String phone;
        String financial_status;
        String total_discounts;
        String tags;
        List<shopifyCreateOrderLineItemsProperties> note_attributes;
        List<shopifyCreateOrderLineItemsNew> line_items;
        shopifyCreateOrderAddress billing_address;
        shopifyCreateOrderAddress shipping_address;
        shopifyCreateOrderCustomer customer;
        List<shopifyCreateOrderDiscountCodes> discount_codes;
        List<shopifyCreateOrderShippingLine> shipping_lines;
    }    

    
    public class shopifyOrderRefund {
        Long id;
        Long order_id;
        List<shopifyCreateOrderRefundLineItems> refund_line_items;
        List<shopifyOrderAdjustments> order_adjustments;
    }
    
    public class shopifyOrderAdjustments {
        Long id;
        Long order_id;
        String amount;
        String tax_amount;
        String reason;
    }
    
    public class shopifyCreateOrderRefundLineItems {
        String id;
        String quantity;
        String subtotal;
        String total_tax;
        shopifyCreateOrderLineItems line_item;
    }

    public class shopifyCreateOrderDiscountCodes {
        String code;
        String amount;
        String type;
    }
    
    public class shopifyCreateOrderShippingLines {
        String code;
        String price;
    }

    public class shopifyCreateOrderLineItemsProperties {
        String name;
        String value;
    }
    
    public class shopifyCreateOrderLineItems {
        Long id;        
        String price;
        String product_id;
        String variant_title;
        String quantity;
        Boolean requires_shipping;
        String title;
        Boolean product_exists;
        String sku;
        List<shopifyCreateOrderLineItemsProperties> properties;
    }
    
    public class shopifyCreateOrderLineItemsNew {
        Long id;        
        String price;
        Long product_id;
        String variant_title;
        Long quantity;
        Boolean requires_shipping;
        String title;
        Boolean product_exists;
        String sku;
        List<shopifyCreateOrderLineItemsProperties> properties;
    }


    public Class shopifyCreateOrderShippingLine {
        String title;
        String price;
        String code;
        String phone;
    }
    
    public class shopifyCreateOrderAddress {
        Long id;
        String first_name;
        String address1;
        String address2;
        String city;
        String zip;
        String province;
        String country;
        String last_name;
        String company;
        String country_code;
        String province_code;
        String phone;        
        Boolean defaults;
    }
    
    @TestVisible
    public class shopifyCreateOrderCustomer {
        String id;
        String email;
        String first_name;     
        String last_name;
        String phone;
        String tags;
        shopifyCreateOrderAddress default_address;
    }
    
    public class relatedCustomer {
        public String email;
        public String fname;
        public String lname;
        public List<String> lineIds;
    }
    
    public class returnItems {
        public API_Request__c apiReq;
        public List<API_Request_Line_Item__c> apiLines;
        public MAP<Integer,API_Request__c> mapOtherCustomers;
        public MAP<String,relatedCustomer> relatedCustomers;
    }   
    
    
    public class shopifyInventoryLevels {
        List<shopifyInventoryItem> inventory_levels;
    }
    
    public class shopifyInventoryItem {
        public String inventory_item_id;
        public String location_id;
        public Integer available;
    }
        
    public class shopifyVariant {
        public String id;
        //public String product_id;
        public String inventory_item_id;
        public Integer inventory_quantity;
    }
    
    public class shopifyProduct {
        public String id;
        public String title;
        List<shopifyVariant> variants;
    }
    
    public class returnProducts {
        List<shopifyProduct> products;
    }

    public class returnProduct {
        shopifyProduct product;
    }
    
    public class updateVariant {
        shopifyVariant variant;
    }
    
    public class orderWrapper implements Comparable {
    
        public shopifyCreateOrder order;
    
        // Constructor
        public orderWrapper(shopifyCreateOrder ord) {
            order = ord;
        }
    
        // Compare opportunities based on the opportunity amount.
        public Integer compareTo(Object compareTo) {
            // Cast argument to OpportunityWrapper
            orderWrapper compareToOrders = (orderWrapper)compareTo;
    
            // The return value of 0 indicates that both elements are equal.
            Integer returnValue = 0;
            //String ordDT = order.created_at.replace('T', ' ');
            //String ordCompDT = compareToOrders.order.created_at.replace('T', ' ');
            //DateTime orderDateTime = DateTime.valueOf(ordDT);
            //DateTime orderCompDateTime = DateTime.valueOf(ordCompDT);
            
            DateTime orderDateTime = (datetime)json.deserialize('"' + order.created_at + '"', datetime.class);
            DateTime orderCompDateTime = (datetime)json.deserialize('"' + compareToOrders.order.created_at + '"', datetime.class);
            
            if (orderDateTime > orderCompDateTime) {
                returnValue = 1;
            } else if (orderDateTime < orderCompDateTime) {
                returnValue = -1;
            }
    
            return returnValue;       
        }
    }    
    

    public static String setStringLimit(String inStr, Integer strLimit) {
        
        inStr = inStr.replace('&apos;','\'');
        
        if(inStr.length() > strLimit) {
            return inStr.substring(0, strLimit);
        } else {
            return inStr;
        }
    }
    
    public static API_Request__c setCustomer(API_Request__c apiReqIn, String rawJson) {
        try {       
        
            returnItems ri = new returnItems();
            List<API_Request_Line_Item__c> apiLines = new List<API_Request_Line_Item__c>();
    
            shopifyCreateOrderCustomer sCust;
            //if(inCust != null)
            //    sCust = inCust;
            //else sCust = (shopifyCreateOrderCustomer)JSON.deserialize(rawJson, shopifyCreateOrderCustomer.class);
            sCust = (shopifyCreateOrderCustomer)JSON.deserialize(rawJson, shopifyCreateOrderCustomer.class);
            system.debug('sCust:' + sCust);
            apiReqIn.Request_Type__c = 'Customer Update';
            apiReqIn.Customer_Id__c = sCust.id;
            apiReqIn.Customer_Email__c = sCust.email;

            if(sCust.first_name != null && sCust.first_name.length() > 0)
                apiReqIn.First_Name__c = sCust.first_name;
            else if(sCust.default_address.first_name != null && sCust.default_address.first_name.length() > 0)
                apiReqIn.First_Name__c = sCust.default_address.first_name;

            if(sCust.last_name != null && sCust.last_name.length() > 0)
                apiReqIn.Last_Name__c = sCust.last_name;
            else if(sCust.default_address.last_name != null && sCust.default_address.last_name.length() > 0)
                apiReqIn.Last_Name__c = sCust.default_address.last_name;
            
            if(sCust.phone != null && sCust.phone.length() > 0)
                apiReqIn.Phone__c = sCust.phone;
            else if(sCust.default_address.phone != null && sCust.default_address.phone.length() > 0)
                apiReqIn.Phone__c = sCust.default_address.phone;
            
            apiReqIn.State__c = sCust.default_address.province;
            apiReqIn.Street1__c = sCust.default_address.address1;
            apiReqIn.Street2__c = sCust.default_address.address2;
            apiReqIn.Zip__c = sCust.default_address.zip;
            apiReqIn.City__c = sCust.default_address.city;
            apiReqIn.Company__c = sCust.default_address.company;
            apiReqIn.Country__c = sCust.default_address.country_code;
            
            apiReqIn.Billing_State__c = sCust.default_address.province;
            apiReqIn.Billing_Street1__c = sCust.default_address.address1;
            apiReqIn.Billing_Street2__c = sCust.default_address.address2;
            apiReqIn.Billing_Zip__c = sCust.default_address.zip;
            apiReqIn.Billing_City__c = sCust.default_address.city;
            apiReqIn.Billing_Company__c = sCust.default_address.company;
            apiReqIn.Billing_Country__c = sCust.default_address.country_code;
            apiReqIn.Billing_Phone__c = sCust.default_address.phone;
            
            
        }catch(exception e){
            system.debug('setCustomer exception:' + e);            
        }
        return apiReqIn;
    }
    
    
    @future(callout=true)
    public static void setCustomerFuture(String jsonAcct, String jsonCont) {
        Account acct = (Account)JSON.deserialize(jsonAcct, Account.class);
        Contact cont = (Contact)JSON.deserialize(jsonCont, Contact.class);
        setShopifyCustomer(acct, cont);
        String rawJson = getShopifyCustomerAddress(acct, cont);
        system.debug('rawJson: ' + rawJson);
        Long idval;
        Long lastIdVal;
        if(rawJson != NULL && rawJson.length() > 0) {
            
            JSONParser parser = JSON.createParser(rawJson);
            
            while (parser.nextToken() != null)
            {
                if (parser.getCurrentToken() == JSONToken.START_ARRAY)
                {
                    Boolean foundDefault = false;
                    String fieldName;
                    while (parser.nextToken() != null) 
                    {
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME))
                        {           
                            fieldName = parser.getText();
                            system.debug('fieldName:' + fieldName);
                            if(fieldName == 'default') {
                                foundDefault = true;
                            }
                        }
                        if (fieldName == 'id' && parser.getCurrentToken() == JSONToken.VALUE_NUMBER_INT) {
                            lastIdVal = parser.getLongValue();
                            system.debug('lastIdVal:' + lastIdVal);
                        }
                        
                        if ((foundDefault && parser.getCurrentToken() == JSONToken.VALUE_TRUE))
                        {           
                            idval = lastIdVal;
                            system.debug('idval:' + idval);
                        }
                    }
                }
            }
            
            //shopifyCustomerAddresses lstAdrresses = (shopifyCustomerAddresses)JSON.deserialize(rawJson, shopifyCustomerAddresses.class);
            //Long addrId;
            //for(shopifyCreateOrderAddress addr :lstAdrresses.addresses) {
            //    system.debug('addr: ' + addr);
            //    if(addr.id != NULL && addr.defaults != NULL) {
           //         addrId = addr.id;
            //    }
            //}
            if(idval != NULL) {
                setShopifyCustomerAddress(acct, cont, idval);
            }
            
        }
        
    }
    
    public static HttpResponse getAffiliateOrder(DateTime getDate) {
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        
        String sdt = getDate.format('yy-MM-dd');
        
        String endpoint = 'https://www.affiliatly.com/af-1026913/api/check_orders_by_date/' + sdt + '/' + sdt + '?hash=ed89751d5e06145f';
        system.debug('endpoint:' + endpoint);
        
        request.setEndPoint(endpoint);
        request.setMethod('GET');        
    
        HttpResponse response;
        if(!Test.isRunningTest()){
            response = httpProtocol.send(request);
        } else {
            response = new HttpResponse();
            response.setBody('{"result":[{"id_order":"S28896","id_affiliate":"35","is_paid":"1","price":"147.50","earnings":"14.75","two_tier_earnings":"0.00","date":"2021-06-25 14:24:35","affiliate_email":"affiliates+accounts@foodrevolution.org","landing_page":"plantable.com/?aff=35","referer":"https://foodrevolution.org/blog/plant-based-meal-delivery-kits/?utm_source=sfmc&utm_medium=email&utm_campaign=blo-2021&utm_content=meal-service-delivery"}],"success":true}');
            response.setStatusCode(200);
        }    
        return response;
    
    }
    
    public static API_Request__c checkAffiliateOrder(String rawJson, API_Request__c apiReqIn) {
        checkAffiliateOrderData caffd = new  checkAffiliateOrderData();
        caffd.isNewAffiliateOrder = False;
        API_Request__c apiReq = new API_Request__c();
        
        shopifyCreateOrder sOrder = (shopifyCreateOrder)JSON.deserialize(rawJson, shopifyCreateOrder.class);
        if(sOrder != NULL && sOrder.created_at != NULL && sOrder.order_number != NULL && sOrder.email != NULL) {
                
            DateTime Created_At = (datetime)json.deserialize('"' + sOrder.created_at + '"', datetime.class);
            // Get Affiliate Info
            HttpResponse response = shopifyClass.getAffiliateOrder(Created_At);
            System.debug('code:' + response.getStatusCode());
            System.debug('body:' + response.getBody());
            
            if(response.getStatusCode() == 200) {
                String bdy = response.getBody();
                affiliatlyGetOrdersResp gmpr = (affiliatlyGetOrdersResp)JSON.deserialize(bdy, affiliatlyGetOrdersResp.class);
                if(gmpr != NULL && gmpr.result != NULL && gmpr.result.size() > 0) {
                    for(affiliatlyGetOrdersRespOrder rd :gmpr.result) {
                        if(rd.id_order != NULL) {
                            String orderId = rd.id_order.replace('S', '');
                            if(orderId == String.valueOf(sOrder.order_number)) {
                                apiReqIn.Affiliate_Code__c = rd.id_affiliate;
                                List<Opportunity> lstOpp = [select Id from Opportunity where Affiliate_Code__c = :caffd.affiliateID AND StageName = 'Closed Won' AND Email_Address__c = :sOrder.email];
                                System.debug('lstOpp:' + lstOpp);
                                
                                if(lstOpp != NULL && lstOpp.size() > 0) {
                                    // found some
                                } else {
                                    apiReqIn.Affiliate_Is_First_Order__c = True;
                                }
                            }
                        }
                    }
                }
            }
        }
        return apiReqIn;
    }
    
    public static String getShopifyCustomerAddress(Account acct, Contact cont) {
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://euphebe-shop.myshopify.com/admin/customers/' + acct.Shopify_Customer_Id__c +  '/addresses.json';
        system.debug('endpoint:' + endpoint);
        
        request.setEndPoint(endpoint);
        request.setMethod('GET');        
        String username = Label.ShopifyAPIUserName;
        String password = Label.ShopifyAPIPassword;
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);     
        
        HttpResponse response;
        Integer statusCode;
        if(!Test.isRunningTest()){
            response = httpProtocol.send(request);
            statusCode = response.getStatusCode();
        } else {
            response = new HttpResponse();
            statusCode = 200;
        }
        system.debug('statusCode:' + String.valueOf(statusCode));
        String body='';
        if(statusCode == 200) {
            if(!Test.isRunningTest()){
                body = response.getBody();
            } else {
                body = '{}';
            }
            System.debug('body:' + body);
        }
        return body;        
    }        
    
        
    public static Integer setShopifyCustomerAddress(Account acct, Contact cont, Long addrId) {
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://euphebe-shop.myshopify.com/admin/customers/' + acct.Shopify_Customer_Id__c +  '/addresses/' + String.ValueOf(addrId) + '.json';
        system.debug('endpoint:' + endpoint);
        
        request.setEndPoint(endpoint);
        request.setMethod('PUT');        
        String username = Label.ShopifyAPIUserName;
        String password = Label.ShopifyAPIPassword;
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);     
        request.setHeader('content-type', 'application/json');
        
        system.debug('acct: ' + acct);
                
        shopifySetCustomerAddress setAddr = new shopifySetCustomerAddress();
        shopifyCreateOrderAddress soAddress = new shopifyCreateOrderAddress();
        setAddr.address = soAddress;

        setAddr.address.id = addrId;
        setAddr.address.province = acct.BillingState;

        if(acct.BillingStreet != NULL) {
            String[] addressLines = acct.BillingStreet.split('\r\n');
            if(addressLines.size() > 0) {
                setAddr.address.address1 = addressLines[0];
            }
            if(addressLines.size() > 1) {
                setAddr.address.address2 = addressLines[1];
            }
        }        
        setAddr.address.zip = acct.BillingPostalCode;
        setAddr.address.city = acct.BillingCity;
        //sCust.default_address.company = 
        setAddr.address.country_code = acct.BillingCountry;
        setAddr.address.defaults = true;
        
        system.debug('setAddr:' + setAddr);
        
        String jsonBody = JSON.serialize(setAddr); 
        jsonBody = jsonBody.replace('defaults', 'defuault');
        
        //onBody = '{"customer":{"id":"4608733195","first_name":"Alberto"}}';
        system.debug('jsonBody:' + jsonBody);
        
        request.setBody(jsonBody);
        
        HttpResponse response;
        Integer statusCode;
        if(!Test.isRunningTest()){
            response = httpProtocol.send(request);
            statusCode = response.getStatusCode();
        } else {
            response = new HttpResponse();
            statusCode = 200;
        }
        system.debug('statusCode:' + String.valueOf(statusCode));
        if(statusCode == 200) {
            String body;
            if(!Test.isRunningTest()){
                body = response.getBody();
            } else {
                body = '{}';
            }
            System.debug('body:' + body);
        }
        return statusCode;        
    }        
    
    public static Integer setShopifyCustomer(Account acct, Contact cont) {
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://euphebe-shop.myshopify.com/admin/customers/' + acct.Shopify_Customer_Id__c + '.json';
        system.debug('endpoint:' + endpoint);
        
        request.setEndPoint(endpoint);
        request.setMethod('PUT');        
        String username = Label.ShopifyAPIUserName;
        String password = Label.ShopifyAPIPassword;
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);     
        request.setHeader('content-type', 'application/json');
        
        system.debug('acct: ' + acct);
        
        shopifySetCustomer setCust = new shopifySetCustomer();
        shopifyCreateOrderCustomer sCust = new shopifyCreateOrderCustomer();
        setCust.customer = sCust;        
        shopifyCreateOrderAddress default_address = new shopifyCreateOrderAddress();
        sCust.default_address = default_address;

        sCust.id = acct.Shopify_Customer_Id__c;
        sCust.email = acct.Email__c;

        sCust.first_name = cont.FirstName;
        sCust.last_name = cont.LastName;
        
        sCust.phone = acct.Phone;
        sCust.default_address.province = acct.BillingState;
        
        if(acct.BillingStreet != NULL) {
            String[] addressLines = acct.BillingStreet.split('\r\n');
            if(addressLines.size() > 0) {
                sCust.default_address.address1 = addressLines[0];
            }
            if(addressLines.size() > 1) {
                sCust.default_address.address2 = addressLines[1];
            }
        }
        sCust.default_address.zip = acct.BillingPostalCode;
        sCust.default_address.city = acct.BillingCity;
        //sCust.default_address.company = 
        sCust.default_address.country_code = acct.BillingCountry;
        
        system.debug('setCust:' + setCust);
        
        String jsonBody = JSON.serialize(setCust);        
        //onBody = '{"customer":{"id":"4608733195","first_name":"Alberto"}}';
        system.debug('jsonBody:' + jsonBody);
        
        request.setBody(jsonBody);
        
        HttpResponse response;
        Integer statusCode;
        if(!Test.isRunningTest()){
            response = httpProtocol.send(request);
            statusCode = response.getStatusCode();
        } else {
            response = new HttpResponse();
            statusCode = 200;
        }
        system.debug('statusCode:' + String.valueOf(statusCode));
        if(statusCode == 200) {
            String body;
            if(!Test.isRunningTest()){
                body = response.getBody();
            } else {
                body = '{}';
            }
            System.debug('body:' + body);
        }
        return statusCode;        
    }    
    
    public static shopifyOrder getShopifyOrderByNumber(String orderNum) {
        shopifyOrder shopOrder;
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://euphebe-shop.myshopify.com/admin/orders/' + orderNum + '.json';
        request.setEndPoint(endpoint);
        request.setMethod('GET');        
        String username = Label.ShopifyAPIUserName;
        String password = Label.ShopifyAPIPassword;
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);        
        HttpResponse response;
        Integer statusCode;
        if(!Test.isRunningTest()){
            response = httpProtocol.send(request);
            statusCode = response.getStatusCode();
        } else {
            response = new HttpResponse();
            statusCode = 200;
        }
        system.debug('statusCode:' + String.valueOf(statusCode));
        if(statusCode == 200) {
            String body;
            if(!Test.isRunningTest()){
                body = response.getBody();
            } else {
                body = '{}';
            }
            System.debug('body:' + body);
            shopOrder = (shopifyOrder)JSON.deserialize(body, shopifyOrder.class);
            System.debug('shopOrder:' + shopOrder);
        }
        return shopOrder;        
    }

    
    public static shopifyOrders getShopifyOrders(Integer pageNum, String startDt, String endDt) {
        shopifyOrders shopOrders;

        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://euphebe-shop.myshopify.com/admin/orders.json?created_at_min='+startDt+'&created_at_max='+endDt+'&page=' + String.valueOf(pageNum);
        request.setEndPoint(endpoint);
        request.setMethod('GET');        
        String username = Label.ShopifyAPIUserName;
        String password = Label.ShopifyAPIPassword;
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);        

        HttpResponse response;
        Integer statusCode;
        if(!Test.isRunningTest()){
            response = httpProtocol.send(request);
            statusCode = response.getStatusCode();
        } else {
            response = new HttpResponse();
            statusCode = 200;
        }        
        system.debug('statusCode:' + String.valueOf(statusCode));
        if(statusCode == 200) {
            String body;
            if(!Test.isRunningTest()){
                body = response.getBody();
            } else { 
                body = '{}';
            }            
            System.debug('body:' + body);
            shopOrders = (shopifyOrders)JSON.deserialize(body, shopifyOrders.class);
            System.debug('shopOrders:' + shopOrders);
        }
        return shopOrders;        
    }
    
    @future(callout=true)
    public static void loadShopifyOrderFuture(String orderNumber) {
        loadShopifyOrder(orderNumber);
    }        
    
    public static void loadShopifyOrder(String orderNumber) {
        shopifyOrder getShopifyOrder = getShopifyOrderByNumber(orderNumber);
        
        if(getShopifyOrder != null && getShopifyOrder.order != null) {            
            API_Request__c apiReq = new API_Request__c();
            
            shopifyClass.returnItems ri = setOrder(apiReq, '', getShopifyOrder.order);
            system.debug('setOrder:' + ri);
            apiReq = ri.apiReq;
            apiReq.Enable_Automation__c = false;
            apiReq.Batch__c = true;
            apiReq.Raw_Request__c = JSON.serialize(getShopifyOrder);
            
            insert apiReq;
            
            if(ri.apiLines != null) {
                for(API_Request_Line_Item__c al :ri.apiLines) {
                    al.API_Request__c = apiReq.id;
                }
                insert ri.apiLines;
            }
        }
    }    

    public static void loadShopifyOrders(String startDt, String endDt, String orderNumber) {
        shopifyOrders shopOrders = new shopifyOrders();
        shopOrders.orders = new LIST<shopifyCreateOrder>();
        Boolean isData=true;
        Integer pageNum=1;
        orderWrapper[] ordersList = new List<orderWrapper>();
        MAP<String,String> orderMap = defineOrderMap();
        
        while(isData) {
            shopifyOrders getShopifyOrders;
            if(orderNumber == null)
                getShopifyOrders = getShopifyOrders(pageNum,startDt,endDt);
            
            if(getShopifyOrders != null && getShopifyOrders.orders != null && getShopifyOrders.orders.size() > 0) {
                for(shopifyCreateOrder ord :getShopifyOrders.orders) {
                    system.debug('load ord:' + ord.order_number + ':' + ord.created_at);                    
                    if(ord.order_number != null) {
                        String fndOrder = orderMap.get(String.valueOf(ord.order_number));
                        if(fndOrder!=null) {
                            DateTime dt = DateTime.valueOf(fndOrder);
                            ord.created_at = String.valueOf(dt);
                            system.debug('fix ord:' + ord.order_number + ':' + ord.created_at);                    
                        }
                    }
                    ordersList.add(new orderWrapper(ord));
                }
                system.debug('shopOrders Len:' + String.valueOf(shopOrders.orders.size()));
            } else {
                isData=False;
            }
            pageNum++;
        }
        //ordersList.sort();
        system.debug('ordersList:' + ordersList);
            
        for(orderWrapper ord :ordersList) {
            system.debug('ord:' + ord);
            
            API_Request__c apiReq = new API_Request__c();
            
            shopifyClass.returnItems ri = setOrder(apiReq, '', ord.order);
            system.debug('setOrder:' + ri);
            apiReq = ri.apiReq;
            apiReq.Enable_Automation__c = false;
            apiReq.Batch__c = true;
            
            insert apiReq;
            
            if(ri.apiLines != null) {
                for(API_Request_Line_Item__c al :ri.apiLines) {
                    al.API_Request__c = apiReq.id;
                }
                insert ri.apiLines;
            }
        }        
    }
    
    public static reChargeCharge getReChargeChargesById(Integer pageNum, String customerId) {
        reChargeCharge reChargeCharges;
            
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://api.rechargeapps.com/charges?status=SKIPPED&customer_id=' + customerId + '&page=' + String.valueOf(pageNum);
        request.setEndPoint(endpoint);
        request.setMethod('GET');        
        request.setHeader('X-Recharge-Access-Token', '48836ac015d148e88b6660ecb22f85b9');
        HttpResponse response;
        Integer statusCode;
        if(!Test.isRunningTest()){
            response = httpProtocol.send(request);
            statusCode = response.getStatusCode();
        } else {
            response = new HttpResponse();
            statusCode = 200;
        }        
        if(statusCode == 200) {
            String body;
            if(!Test.isRunningTest()){
                body = response.getBody();
            } else {
                body = '{}';
            }            
            System.debug('body:' + body);
            reChargeCharges = (reChargeCharge)JSON.deserialize(body, reChargeCharge.class);
            System.debug('reChargeCharges:' + reChargeCharges);
        }
        return reChargeCharges;
    }
        
    
    public static reChargeCharge getReChargeCharges(Integer pageNum, String minDate) {
        reChargeCharge reChargeCharges;
            
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://api.rechargeapps.com/charges?status=SKIPPED&minDate=' + minDate + '&page=' + String.valueOf(pageNum);
        request.setEndPoint(endpoint);
        request.setMethod('GET');        
        request.setHeader('X-Recharge-Access-Token', '48836ac015d148e88b6660ecb22f85b9');
        HttpResponse response;
        Integer statusCode;
        if(!Test.isRunningTest()){
            response = httpProtocol.send(request);
            statusCode = response.getStatusCode();
        } else {
            response = new HttpResponse();
            statusCode = 200;
        }        
        if(statusCode == 200) {
            String body;
            if(!Test.isRunningTest()){
                body = response.getBody();
            } else {
                body = '{}';
            }            
            System.debug('body:' + body);
            reChargeCharges = (reChargeCharge)JSON.deserialize(body, reChargeCharge.class);
            System.debug('reChargeCharges:' + reChargeCharges);
        }
        return reChargeCharges;
    }
    
    
    public static reChargeCustomers getReChargeCustomers(Integer pageNum) {
        reChargeCustomers reChargeCusts;
            
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://api.rechargeapps.com/customers?status=ACTIVE&page=' + String.valueOf(pageNum);
        request.setEndPoint(endpoint);
        request.setMethod('GET');        
        request.setHeader('X-Recharge-Access-Token', '48836ac015d148e88b6660ecb22f85b9');
        HttpResponse response;
        Integer statusCode;
        if(!Test.isRunningTest()){
            response = httpProtocol.send(request);
            statusCode = response.getStatusCode();
        } else {
            response = new HttpResponse();
            statusCode = 200;
        }        
        if(statusCode == 200) {
            String body;
            if(!Test.isRunningTest()){
                body = response.getBody();
            } else {
                body = '{}';
            }            
            System.debug('body:' + body);
            reChargeCusts = (reChargeCustomers)JSON.deserialize(body, reChargeCustomers.class);
            System.debug('reChargeCusts:' + reChargeCusts);
        }
        return reChargeCusts;
    }
    
    // //@future(callout=true)
    // public static void getReChargeSkippedCharges(Boolean updateData, String testEmail, String customerId) {
    //     MAP<String,String> mapRechargeCusts = new MAP<String,String>();
    //     reChargeCustomers reChargeCusts = new reChargeCustomers();
    //     reChargeCusts.customers = new LIST<reChargeCustomerDetail>();
    //     Boolean isData=true;
    //     Integer pageNum=1;
    //     String minDate='2016-01-01';
    //     DateTime lastSkip;
    //     DateTime lastestSkip;
        
    //     List<IntegrationDateTimes__c> custSettings = [Select Id, Name, LastDateTime__c from IntegrationDateTimes__c where Name = 'RechargeLastSkip'];
    //     System.debug('custSettings:' + custSettings);
    //     if(custSettings != NULL && custSettings.size() > 0 && custSettings[0].LastDateTime__c != NULL) {
    //         lastSkip = custSettings[0].LastDateTime__c;
    //         lastestSkip = custSettings[0].LastDateTime__c;
    //         System.debug('lastSkip:' + lastSkip);
    //         minDate = lastSkip.year() + '-' + String.valueOf(lastSkip.month()).leftPad(2, '0') + '-' + String.valueOf(lastSkip.day()).leftPad(2, '0');
    //         System.debug('minDate:' + minDate);
    //     }
                            
    //     while(isData) {
    //         reChargeCustomers getReChargeCusts = getReChargeCustomers(pageNum);
    //         if(getReChargeCusts != null && getReChargeCusts.customers != null && getReChargeCusts.customers.size() > 0) {
    //             reChargeCusts.customers.addall(getReChargeCusts.customers);
    //         } else {
    //             isData=False;
    //         }
    //         pageNum++;
    //     }
        
    //     if(reChargeCusts.customers.size() > 0) {
    //         System.debug('reChargeCusts:' + reChargeCusts);
            
    //         if(reChargeCusts.customers != NULL && reChargeCusts.customers.size() > 0) {
    //             for(reChargeCustomerDetail rec :reChargeCusts.customers) {
    //                 mapRechargeCusts.put(rec.id, rec.shopify_customer_id);
    //             }
    //         }            
    //         System.debug('mapRechargeCusts:' + mapRechargeCusts);
            
    //         reChargeCharge reCharges = new reChargeCharge();
    //         reCharges.charges = new LIST<reChargeChargeDetail>();
                
    //         isData=true;
    //         pageNum=1;
    //         while(isData) {
    //             reChargeCharge getReChargeCharges;
    //             if(testEmail != NULL) {
    //                 getReChargeCharges = getReChargeChargesById(pageNum, customerId);    
    //             } else {
    //               getReChargeCharges = getReChargeCharges(pageNum, minDate);    
    //             }
                    
                
    //             if(getReChargeCharges != null && getReChargeCharges.charges != null && getReChargeCharges.charges.size() > 0) {
    //                 reCharges.charges.addall(getReChargeCharges.charges);
    //             } else {
    //                 isData=False;
    //             }
    //             pageNum++;
    //         }
            
    //         if(reCharges.charges.size() > 0) {
    //             System.debug('reCharges:' + reCharges);
                
    //             if(reCharges.charges != NULL && reCharges.charges.size() > 0) {
    //                 MAP<String,String> mapSkip = new MAP<String,String>(); 
    //                 SET<String> customerIds = new SET<String>();
    //                 SET<Date> scheduledDates = new SET<Date>();
    //                 Set<String> oppIds = new Set<String>();
    //                 for(reChargeChargeDetail red :reCharges.charges) {
                        
    //                     system.debug('updated_at:' + red.updated_at);
    //                     //red.updated_at = red.updated_at.replace('T', ' ');
    //                     //DateTime dt = DateTime.valueOf(red.updated_at);
    //                     DateTime dt = (datetime)json.deserialize('"' + red.updated_at + '"', datetime.class);
    //                     system.debug('DateTime updated_at:' + dt);
                        
    //                     if(red.updated_at != NULL && red.scheduled_at != NULL && red.customer_id != NULL && red.status != NULL) {
    //                         if(dt > lastestSkip) {
    //                             lastestSkip = dt;
    //                             system.debug('updated lastestSkip:' + dt);
    //                         }
                                
    //                         system.debug('red.customer_id:' + red.customer_id);
    //                         String shopCustId = mapRechargeCusts.get(red.customer_id);
    //                         system.debug('Find shopCustId:' + shopCustId);
                            
    //                         if(shopCustId != NULL) {
    //                             customerIds.add(shopCustId);
                                
    //                             //red.scheduled_at = red.scheduled_at.replace('T', ' ');
    //                             //Date sdt = Date.valueOf(red.scheduled_at);
    //                             // Check this!! Seems to be behind 1 day
    //                             datetime ddt = (datetime)json.deserialize('" + red.scheduled_at + "', datetime.class);
    //                             Date sdt = date.newInstance(ddt.year(), ddt.month(), ddt.day());
    //                             scheduledDates.add(sdt);
                                
    //                             String key = shopCustId + '~' + red.scheduled_at;
    //                             mapSkip.put(key, red.status);    
    //                         }
    //                     }   
    //                 }
    //                 system.debug('mapSkip:' + mapSkip);
    //                 system.debug('scheduledDates:' + scheduledDates);
    //                 system.debug('customerIds:' + customerIds);
                    
    //                 Date lastSkipDate = Date.valueOf(lastSkip);
    //                 List<Opportunity> updateOpps;
                    
    //                 if(testEmail != null) {
    //                   updateOpps = [select Id, Name, StageName, CloseDate, Account.Shopify_Customer_Id__c from Opportunity where CloseDate in :scheduledDates AND Account.Shopify_Customer_Id__c in :customerIds AND StageName = 'Projected Renewal'];    
    //                 } else {
    //                     updateOpps = [select Id, Name, StageName, CloseDate, Account.Shopify_Customer_Id__c from Opportunity where CloseDate in :scheduledDates AND Account.Shopify_Customer_Id__c in :customerIds AND StageName = 'Projected Renewal' AND Account.Email__c = :testEmail];    
    //                 }
                    
    //                 system.debug('updateOpps:' + updateOpps);
    //                 for(Opportunity opp :updateOpps) {
    //                     system.debug('opp:' + opp);
                        
    //                     String key = opp.Account.Shopify_Customer_Id__c + '~' + opp.CloseDate;
    //                     String status = mapSkip.get(key);
    //                     system.debug('Find status:' + status);
                        
    //                     if(status != NULL) {
    //                         oppIds.add(opp.Id);
    //                     }
    //                 }
    //                 system.debug('oppIds:' + oppIds);
    //                 system.debug('lastestSkip:' + lastestSkip);
    //                 custSettings[0].LastDateTime__c = lastestSkip;
                    
    //                 if(updateData) {
    //                     List<Opportunity> opps = [select Id, Name, StageName from Opportunity where id in :oppIds];
    //                     if(opps != null && opps.size() > 0) {
    //                         for(Opportunity opp :opps)
    //                             opp.StageName = 'Closed Lost';
    //                     }
    //                     update opps;
    //                     update custSettings;
    //                     //update updateShips;                        
    //                 }
    //             }
    //         }
    //     }
    // }

    @future(callout=true)
    public static void getReChargeCustomerAsync(String apiId, String customerId) {
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://api.rechargeapps.com/customers/' + customerId;
        request.setEndPoint(endpoint);
        request.setMethod('GET');        
        request.setHeader('X-Recharge-Access-Token', '48836ac015d148e88b6660ecb22f85b9');
        HttpResponse response;
        Integer statusCode;
        if(!Test.isRunningTest()){
            response = httpProtocol.send(request);
            statusCode = response.getStatusCode();
        } else {
            response = new HttpResponse();
            statusCode = 200;
        }        
        if(statusCode == 200) {
            String body;
            if(!Test.isRunningTest()){
                body = response.getBody();
            } else {
                body = '{}';
            }            
            reChargeCustomer reCust = (reChargeCustomer)JSON.deserialize(body, reChargeCustomer.class);
            system.debug('reCust:' + reCust);
              
            List<API_Request__c> apiReqs = [select Id, Name, Customer_Id__c from API_Request__c where Id = :apiId];
            if(apiReqs != null && apiReqs.size() > 0) {
                API_Request__c apiReq = apiReqs[0];
                apiReq.Customer_Id__c = reCust.customer.shopify_customer_id;
                apiReq.Enable_Automation__c = true;
                update apiReq;
            }
        }
    }

        
    //@future(callout=true)
    public static String getReChargeCustomer(String apiId, String customerId) {
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://api.rechargeapps.com/customers/' + customerId;
        request.setEndPoint(endpoint);
        request.setMethod('GET');        
        request.setHeader('X-Recharge-Access-Token', '48836ac015d148e88b6660ecb22f85b9');
        HttpResponse response;
        Integer statusCode;
        if(!Test.isRunningTest()){
            response = httpProtocol.send(request);
            statusCode = response.getStatusCode();
        } else {
            response = new HttpResponse();
            statusCode = 200;
        }        
        if(statusCode == 200) {
            String body;
            if(!Test.isRunningTest()){
                body = response.getBody();
            } else {
                body = '{}';
            }            
            reChargeCustomer reCust = (reChargeCustomer)JSON.deserialize(body, reChargeCustomer.class);
            system.debug('reCust:' + reCust);
            if(reCust != null && reCust.customer != null && reCust.customer.shopify_customer_id != null)
              return reCust.customer.shopify_customer_id;              
            else return null;
        }
        return customerId;
    }
    
    public static returnItems setSubscription(API_Request__c apiReqIn, String rawJson, Boolean isTrigger) {
        
        try {       
        
            returnItems ri = new returnItems();
            List<API_Request_Line_Item__c> apiLines = new List<API_Request_Line_Item__c>();

            reChargeSubscription reSub = (reChargeSubscription)JSON.deserialize(rawJson, reChargeSubscription.class);
            system.debug('reSub:' + reSub);  
            apiReqIn.Request_Type__c = 'Subscription_Update';
            
            if(reSub.subscription != NULL) {
                apiReqIn.Customer_Id__c = reSub.subscription.customer_id;
                apiReqIn.Status__c = reSub.subscription.status;
                if(apiReqIn.Frequency__c != NULL)
                    apiReqIn.Frequency__c = Double.valueOf(reSub.subscription.order_interval_frequency);    
                
                //String reCustRaw = getReChargeCustomer(apiReqIn.Customer_Id__c);
                if(isTrigger) {
                    getReChargeCustomerAsync(apiReqIn.Id, apiReqIn.Customer_Id__c);
                    apiReqIn.Enable_Automation__c = false;            
                } else {
                    apiReqIn.Customer_Id__c = getReChargeCustomer(apiReqIn.Id, apiReqIn.Customer_Id__c);
                    apiReqIn.Enable_Automation__c = true;            
                }
            }
            system.debug('reSub Update:' + reSub); 
            ri.apiLines = null;
            ri.apiReq = null;
            return ri;

        } catch (Exception e) {
            returnItems ri = new returnItems();
            apiReqIn.Response__c = e.getMessage();
            ri.apiReq = apiReqIn;
            ri.apiLines = null;
            return ri;
        }            
    }
    
  // public static void processRESTError(RestRequest req, String expMsg) {
    //     API_Request__c apiReq = new API_Request__c();
    //     String rawJson = req.requestBody.toString();
    //     apiReq.Response__c = expMsg;
    //     if(rawJson != null)
    //         apiReq.Raw_Request__c = rawJson;
    //     insert apiReq;    
    // }

    // public static void processAPICharge(String rawJson) {
    //     API_Request__c apiReq = new API_Request__c();
    //     apiReq.Raw_Request__c = rawJson;
    //     insert apiReq;
    //     shopifyClass.returnItems ri = shopifyClass.setOrder(apiReq, rawJson, null);
    //     update ri.apiReq;
    //     system.debug('returnItems' + ri);   
    //     //shopifyClass.processAPIRequest(ri);            
    // }

    @future(callout=true)
    public static void createOrdersFuture(String apiReqId) {
        List<API_Request__c> lstAPIReq = [select Id, Enable_Automation__c from API_Request__c where id = :apiReqId];
        if(lstAPIReq != null && lstAPIReq.size() > 0) {
            API_Request__c apiReq = lstAPIReq[0];                
            apiReq.Enable_Automation__c = true;
            update apiReq;            
        }
    }

    public static void createOrders(String apiReqId) {
        List<API_Request__c> lstAPIReq = [select Id, Enable_Automation__c from API_Request__c where id = :apiReqId];
        if(lstAPIReq != null && lstAPIReq.size() > 0) {
            API_Request__c apiReq = lstAPIReq[0];                
            apiReq.Enable_Automation__c = true;
            update apiReq;            
        }
    }

    public static Integer findLineId(String lineId, Set<String> keys) {
        Integer cnt=0;
        for(String key :keys) {
            if(key.indexOf('~' + lineId) > -1)
                cnt++;
        }
        return cnt;
    }
    
    // Modify API Request if needed
    // Used for Muti-Customer Sales
    public static API_Request__c processAPIRequest(returnItems ri, boolean isTrigger) {
        API_Request__c apiReq = ri.apiReq;
        List<relatedCustomer> lstRelCusts = ri.relatedCustomers.values();
        List<relatedCustomer> lstOtherRelCusts = new List<relatedCustomer>();
        MAP<String,String> mapRelCustLineId = new MAP<String,String>();
        
        /*
        if(lstRelCusts.size() > 0) {
            // List of Orig API_Req to Clone, 1 for each distinct Other Customer
            List<API_Request__c> cloneOrigAPIReqs = new List<API_Request__c>();
            //List<SObject> cloneOrigObjs = new List<SObject>();
            for(relatedCustomer rc :lstRelCusts) {
        // Add Clone for each other cust
                if(rc.email != apiReq.Customer_Email__c) {
                    lstOtherRelCusts.add(rc);
                    
                    String jsonObj = JSON.serialize(apiReq);
                    API_Request__c cloneApiReq = (API_Request__c)JSON.deserialize(jsonObj, API_Request__c.class);
                  cloneOrigAPIReqs.add(cloneApiReq);
                }
                if(rc.lineIds.size() > 0) {
                    for(String lid :rc.lineIds) {
                        String key = rc.email + '~' + lid;
                        mapRelCustLineId.put(key,key);
                    }    
                }
            }
            system.debug('cloneOrigAPIReqs :' + cloneOrigAPIReqs);
            system.debug('mapRelCustLineId:' + mapRelCustLineId);
            
            // If other customers
            if(cloneOrigAPIReqs.size() > 0) {
                
                // Fix Main Cust Line Items
                if(ri.apiLines != null && ri.apiLines.size() > 0) {
                    relatedCustomer MainCust = ri.relatedCustomers.get(apiReq.Customer_Email__c);
                    List<API_Request_Line_Item__c > newLines = new List<API_Request_Line_Item__c >();    
                    for(API_Request_Line_Item__c line :ri.apiLines) {
                        system.debug('Main line:' + line);
                        String key = apiReq.Customer_Email__c + '~' + line.External_Id__c;
                        system.debug('key:' + key);
                        if(line.Type__c != 'Product') {
                            newLines.add(line);
                        } else if(line.Type__c == 'Product' && mapRelCustLineId.get(key) != NULL) {
                            
                            // If this Product Line is only used by one Customer, then assign all the quantity to them, else 1 each
                            Integer idCnt = findLineId(line.External_Id__c, mapRelCustLineId.keySet());
                            if(idCnt > 1) {
                                line.Quantity__c = 1;
                            }                            
                            newLines.add(line);
                        }
                    }
                    system.debug('Main newLines:' + newLines);
                    if(newLines.size() > 0) {
                        insert newLines;
                    }
                    if(!Test.isRunningTest())
                      createOrdersFuture(apiReq.id);
                }
                
                
                //List<sObject> sCloneObjects = RESTOrdersController.cloneObjects(cloneOrigObjs, apiReq.getsObjectType());
                //system.debug('clones' + sCloneObjects); 
                Integer cntOther = 0;
                for(API_Request__c nreq :cloneOrigAPIReqs) {
                    nreq.Id = null;
                    
                    // Get Other Cust Details
                    relatedCustomer otherCust = lstOtherRelCusts.get(cntOther);
                    cntOther++;
                    
                    // Set Closed APIReq data
                    nreq.OrderId__c = apiReq.OrderId__c + otherCust.email;
                    nreq.Name = apiReq.OrderId__c + otherCust.email;                                        
                    nreq.Customer_Email__c = otherCust.email;
                    nreq.First_Name__c = otherCust.fname;
                    nreq.Last_Name__c = otherCust.lname;      
                    nreq.Shipping_First_Name__c = otherCust.fname;
                    nreq.Shipping_Last_Name__c = otherCust.lname;
                    nreq.Request_Key__c = apiReq.Request_Type__c + '~' + nreq.OrderId__c;
                    insert nreq;
                    system.debug('nreq:' + nreq);
                    
                    if(ri.apiLines != null && ri.apiLines.size() > 0) {
                        //List<sObject> sCloneLines = RESTOrdersController.cloneObjects(sObjLines, ri.apiLines.get(0).getsObjectType());
                        List<API_Request_Line_Item__c> clonedLines = new List<API_Request_Line_Item__c>();
                        for(API_Request_Line_Item__c line :ri.apiLines) {
                            clonedLines.add(line);
                        }    
                        system.debug('clone lines' + clonedLines); 
                        List<API_Request_Line_Item__c> newLines = new List<API_Request_Line_Item__c>();
                        for(API_Request_Line_Item__c apiLine :clonedLines) {
                            apiLine.Id = null;
                            apiLine.API_Request__c = nreq.Id;
                            system.debug('Clone line:' + apiLine);
                            String key = nreq.Customer_Email__c + '~' + apiLine.External_Id__c;
                            system.debug('key:' + key);
                            
                            if(apiLine.Type__c == 'Product' && mapRelCustLineId.get(key) != NULL) {
                                
                                // If this Product Line is only used by one Customer, then assin all the quantity to them, else 1 each
                                Integer idCnt = findLineId(apiLine.External_Id__c, mapRelCustLineId.keySet());
                                if(idCnt > 1) {
                                    apiLine.Quantity__c = 1;
                                }                                                            
                                newLines.add(apiLine);
                            } else if(apiLine.Type__c == 'Shipping') {
                                apiLine.Amount__c = 0;
                                newLines.add(apiLine);
                            }
                        }
                        insert newLines;
                    }
                    if(!Test.isRunningTest())
                      createOrdersFuture(nreq.id);
                }            
            } else {
                // No Other Cust
                if(ri.apiLines != null)
                    insert ri.apiLines;
                if(isTrigger) {
                    //apiReq.Enable_Automation__c = true;
                    return apiReq;
                } else {
                    createOrders(apiReq.id);  
                    return null;
                }
            }      
        } else { */
            // No Other Cust
            if(ri.apiLines != null)
                insert ri.apiLines;
            if(isTrigger) {
                //apiReq.Enable_Automation__c = true;
                return apiReq;
            } else {
                createOrders(apiReq.id);  
                return null;
            }
        //}
        if(isTrigger) {
            return apiReq;
        } else {
            return null;
        }    
    }
    
    public static String safeSetString(String inStr, String strOpt) {
        if(inStr != null) {
            return inStr;
        } else if(strOpt != NULL) {
            return strOpt;
        }
        else return '';
    }
    
    public static List<String> splitName(String fullName) {
        String[] addressLines = fullName.split(' ');
        List<String> retNames = new List<String>();
        if(addressLines.size() > 0) {
            retNames.add(addressLines[0]);
        } else {
             retNames.add('FristName');
        }
        if(addressLines.size() > 1) {
            retNames.add(addressLines[1]);
        } else {
             retNames.add('LastName');
        }
        return retNames;
    }
    
    public static Integer getOtherCustNumber(String name, Integer strLen) {
        String OtherCustNum = '0';
        if(name.length() > strLen) {
            OtherCustNum = name.substring(strLen, name.length());
            System.debug('OtherCustNum:' + OtherCustNum);
        }
        return Integer.valueOf(OtherCustNum);
    }
    
    public static Date parseShippingDate(String sdate) {
        //String sdate = 'February 18, 2019';
        Date finalDate = null;
        sdate = sdate.replaceAll('\\n', '');
        sdate = sdate.replaceAll('\\s{2,}', '');
        sdate = sdate.replaceAll('bmob#', '');
        
        //system.assert(false, 'BOOM!setOrderNew:'+ sdate + ':');
        
        if(sdate != null) {
            String[] sParts = sdate.split(' ');
            
            //system.assert(false, 'BOOM!setOrderNew:'+ sParts + ':');
            
            if(sParts.size() > 1) {
                List<String> dateParts = new List<String>();
                for(String p :sParts) {
                    dateParts.add(p.replace(',',''));
                }
                system.debug('dateParts: ' + dateParts); 
                String sMonth = dateParts[0];
                Integer m;
                if(sMonth == 'January')
                    m=1;
                else if(sMonth == 'February')
                    m=2;
                else if(sMonth == 'March')
                    m=3;
                else if(sMonth == 'April')
                    m=4;
                else if(sMonth == 'May')
                    m=5;
                else if(sMonth == 'June')
                    m=6;
                else if(sMonth == 'July')
                    m=7;
                else if(sMonth == 'August')
                    m=8;
                else if(sMonth == 'September')
                    m=9;
                else if(sMonth == 'October')
                    m=10;
                else if(sMonth == 'November')
                    m=11;
                else if(sMonth == 'December')
                    m=12;
                system.debug('m: ' + m);
                
                finalDate = date.newInstance(Integer.valueOf(dateParts[2]), m, Integer.valueOf(dateParts[1]));
                system.debug('finalDate: ' + finalDate);
            }
        }
        //system.assert(false, 'BOOM!setOrderNew:'+ finalDate + ':');
        return finalDate;
        
    }
    
    
    public static Date parseVariantDate(String sdate) {
        //String sdate = 'Monday, May 14, 2018';
        Date finalDate = null;
        if(sdate != null) {
            String[] sParts = sdate.split(' ');
            if(sParts.size() > 2) {
                List<String> dateParts = new List<String>();
                for(String p :sParts) {
                    dateParts.add(p.replace(',',''));
                }
                system.debug('dateParts: ' + dateParts);
                String sMonth = dateParts[1];
                Integer m;
                if(sMonth == 'January')
                    m=1;
                else if(sMonth == 'February')
                    m=2;
                else if(sMonth == 'March')
                    m=3;
                else if(sMonth == 'April')
                    m=4;
                else if(sMonth == 'May')
                    m=5;
                else if(sMonth == 'June')
                    m=6;
                else if(sMonth == 'July')
                    m=7;
                else if(sMonth == 'August')
                    m=8;
                else if(sMonth == 'September')
                    m=9;
                else if(sMonth == 'October')
                    m=10;
                else if(sMonth == 'November')
                    m=11;
                else if(sMonth == 'December')
                    m=12;
                system.debug('m: ' + m);
                
                finalDate = date.newInstance(Integer.valueOf(dateParts[3]), m, Integer.valueOf(dateParts[2]));
                system.debug('finalDate: ' + finalDate);
            }
        }
        return finalDate;
        
    }
    /*
    public static returnItems setOrder(API_Request__c apiReqIn, String rawJson, shopifyCreateOrder sOrderIn) {
       
        //try {       
        //
        
        if(rawJson.indexOf('"name":"shipping_date"') > -1) {
            return setOrderNew(apiReqIn, rawJson, null);
        }
        
        returnItems ri = new returnItems();
        List<API_Request_Line_Item__c> apiLines = new List<API_Request_Line_Item__c>();
        ri.mapOtherCustomers = new MAP<Integer,API_Request__c>();   
        ri.relatedCustomers = new MAP<String,relatedCustomer>();
        
            shopifyCreateOrder sOrder;
            if(sOrderIn != null) {
                sOrder = sOrderIn;
            } else {
                try {
                    sOrder = (shopifyCreateOrder)JSON.deserialize(rawJson, shopifyCreateOrder.class);    
                } catch (Exception e) {
                    return setOrderNew(apiReqIn, rawJson, null);
                }
                
                apiReqIn.Raw_Request__c = rawJson;
            }
            system.debug('sOrder:' + sOrder);
        
            // Is Order
            if(sOrder.order_number != null && sOrder.order_id == null) {
            
                apiReqIn.Order_Number__c = String.valueOf(sOrder.order_number);
                apiReqIn.OrderId__c = String.ValueOf(sOrder.id);
                apiReqIn.Customer_Email__c = safeSetString(sOrder.email, 'unknow@unknow.com'); 
                apiReqIn.Customer_Email__c = apiReqIn.Customer_Email__c.toLowerCase();
                apiReqIn.Phone__c = safeSetString(sOrder.phone,NULL);
                apiReqIn.Financial_Status__c = safeSetString(sOrder.financial_status,NULL);
                
                if(sOrder.customer != NULL) {
                    apiReqIn.First_Name__c  = safeSetString(sOrder.customer.first_name,'FirstName');
                    apiReqIn.Last_Name__c = safeSetString(sOrder.customer.last_name,'LastName');
                    apiReqIn.Customer_Id__c = sOrder.customer.id;                    
                }
                
                //sOrder.created_at = sOrder.created_at.replace('T', ' ');
                //apiReqIn.Created_At__c = DateTime.valueOf(sOrder.created_at);
                if(sOrder.created_at != null) {
                    System.debug('sOrder.created_at:' + sOrder.created_at);
                    apiReqIn.Created_At__c = (datetime)json.deserialize('"' + sOrder.created_at + '"', datetime.class);
                    System.debug('apiReqIn.Created_At__c:' + apiReqIn.Created_At__c);
                }
                
                if(apiReqIn.Financial_Status__c == 'refunded') {
                    apiReqIn.Request_Type__c = 'Cancel Order';
                    apiReqIn.Enable_Automation__c = true;
                    ri.apiReq = apiReqIn;
                    ri.apiLines = null;
                } else {
                    
                    apiReqIn.Request_Type__c = 'Create Order';
                    System.debug('apiReqIn.Request_Type__c:' + apiReqIn.Request_Type__c);
                    
                    if(sOrder.discount_codes != NULL && sOrder.discount_codes.size() > 0) {
                        for(shopifyCreateOrderDiscountCodes dcs :sOrder.discount_codes) {
                            API_Request_Line_Item__c apiLi = new API_Request_Line_Item__c();
                            apiLi.Type__c = 'Discount';
                            apiLi.API_Request__c = apiReqIn.Id;
                            apiLi.Name = setStringLimit(dcs.code,80);
                            apiLi.Code__c = dcs.code;
                            apiLi.Amount__c =  Decimal.valueOf(dcs.amount);
                            if(apiLi.Amount__c == 0 && sOrder.total_discounts != NULL) {
                                apiLi.Amount__c =  Decimal.valueOf(sOrder.total_discounts);
                            }
                            apiLines.add(apiLi);
                        }
                    }
                    System.debug('apiLines1:' + apiLines);
                    
                    apiReqIn.How_did_you_hear_Long__c = '';
                    if(sOrder.note_attributes != NULL) {
                        for(shopifyCreateOrderLineItemsProperties li :sOrder.note_attributes) {
                            if(li.name == 'how-did-you-hear-about-us' && li.value.length() > 0 && li.value != 'Other')
                                apiReqIn.How_did_you_hear_Long__c = li.value;
                            else if(li.name == 'how-did-you-hear-about-us-other' && li.value.length() > 0)
                                apiReqIn.How_did_you_hear_Long__c = li.value;
                            
                            if(li.name == 'Delivery Details' && li.value.length() > 0) 
                                apiReqIn.Shipping_Instructions_Long__c = li.value;
                            
                            if(li.name == 'olark-conversation-url' && li.value.length() > 0) 
                              apiReqIn.Olark_Conversation_Url__c = setStringLimit(li.value,255);
                            
                            if(li.name == 'olark-operator' && li.value.length() > 0) 
                              apiReqIn.Olark_Operator__c = setStringLimit(li.value,255);
                        }
                    }
                    System.debug('apiReqIn Update:' + apiReqIn);
                    
                    apiReqIn.Product_Code__c = '';
                    String goodCode;
                    if(sOrder.line_items != null) {
                        
                        for(shopifyCreateOrderLineItems li :sOrder.line_items) {
                            System.debug('li:' + li);
                            
                            if(li.price != NULL) {
                                API_Request_Line_Item__c apiLi = new API_Request_Line_Item__c();
                                apiLi.Type__c = 'Product';
                                apiLi.API_Request__c = apiReqIn.Id;
                                apiLi.External_Id__c = String.valueOf(li.id);
                                
                                if(li.title == NULL) {
                                    apiLi.Name = 'Misc';
                                } else {
                                    apiLi.Name = setStringLimit(li.title, 80);
                                }
    
                                apiLi.Amount__c = Decimal.valueOf(li.price);
                                if(li.quantity == NULL) {
                                    apiLi.Quantity__c = 1;    
                                } else {
                                    apiLi.Quantity__c = Integer.valueOf(li.quantity);    
                                }
                                
                                if(li.variant_title != null) {
                                    apiReqIn.Ship_Date__c = parseVariantDate(li.variant_title); 
                                    apiLi.Ship_Date__c = parseVariantDate(li.variant_title);
                                }
                                
                                String pcode=null;
                                if(li.product_id != NULL) {
                                    pcode = li.product_id;
                                    goodCode = pcode;
                                } else if(li.sku != NULL) {
                                    pcode = li.sku;
                                } else {
                                    pcode = 'misc';
                                }
                                
                                System.debug('pcode:' + pcode);
                                
                                if(pcode != NULL) {
                                    apiLi.Code__c = pcode;
                                    apiReqIn.Product_Code__c = pcode;
                                    
                                    if(li.properties != null) {
                                        
                                        API_Request__c otherCustomer;
                                        Integer OtherCustNum=Null;
                                        ri.mapOtherCustomers = new MAP<Integer,API_Request__c>();  
                                        for(shopifyCreateOrderLineItemsProperties lip :li.properties) {
                                            
                                            System.debug('lip:' + lip);
                                            
                                            // A-la-carte Items
                                            if(pcode == '9466290251' && lip.name.indexOf('#') > -1) {
                                                
                                                String[] nameLines = lip.name.split('#');
                                                
                                                System.debug('Is A-la-carte:' + nameLines);
                                                
                                                if(nameLines.size() > 1 && nameLines[1].isNumeric()) {
                                                    
                                                    String mealName = nameLines[0];
                                                    String mealId = nameLines[1];
                                                        
                                                    API_Request_Line_Item__c apiLiMeal = new API_Request_Line_Item__c();
                                                    if(mealName.length() > 80)
                                                        apiLiMeal.Name = mealName.substring(0, 80); 
                                                    Else apiLiMeal.Name = mealName;
    
                                                    apiLiMeal.Type__c = 'Meal';
                                                    apiLiMeal.API_Request__c = apiReqIn.Id;
                                                    apiLiMeal.External_Id__c = mealId;
                                                    apiLiMeal.Quantity__c = Integer.valueOf(lip.value);
                                                    
                                                    System.debug('apiLiMeal:' + apiLiMeal);
                                                    
                                                    apiLines.add(apiLiMeal);
                                                }

                                            }
                                            
                                            

                                            if(lip.name != null && lip.name == 'Ship Date') {
                                                try {
                                                    apiReqIn.Ship_Date__c = date.parse(lip.value); 
                                                    apiLi.Ship_Date__c = date.parse(lip.value);
                                                }catch(exception e){
                                                    
                                                }
                                            } 
                                                
                                            if(lip.name != null && lip.name == 'shipping_interval_frequency') {
                                                try {
                                                    apiReqIn.Frequency__c = Integer.valueOf(lip.value);
                                                }catch(exception e){
                                                    
                                                }
                                            } 
                                            
                                            if(lip.name != null && lip.name.indexOf('Full Name') > -1) {
                                                OtherCustNum = getOtherCustNumber(lip.name, 9);
                                                if(apiLi.Quantity__c == 1 && OtherCustNum > 1) {
                                                    system.debug('SKIP!');                                                
                                                } else {
                                                    API_Request__c fndOtherCust = ri.mapOtherCustomers.get(OtherCustNum);
                                                    if(fndOtherCust == NULL) {
                                                        otherCustomer = new API_Request__c();
                                                    } else {
                                                        // Second Product with Alternate Name
                                                        if(fndOtherCust.First_Name__c != NULL) {
                                                            OtherCustNum++;
                                                            otherCustomer = new API_Request__c();
                                                        } else {
                                                            otherCustomer = fndOtherCust;
                                                        }
                                                    }
                                                    
                                                    List<String> names = splitName(lip.value);
                                                    otherCustomer.First_Name__c = names[0];
                                                    otherCustomer.Last_Name__c = names[1];
                                                    ri.mapOtherCustomers.put(OtherCustNum, otherCustomer);
                                                }
                                            } 
                                            
                                            if(lip.name != null && lip.name.indexOf('E-mail Address') > -1) {
                                                OtherCustNum = getOtherCustNumber(lip.name, 14);
                                                if(apiLi.Quantity__c == 1 && OtherCustNum > 1) {
                                                    system.debug('SKIP!');                                                
                                                } else {                                                
                                                    API_Request__c fndOtherCust = ri.mapOtherCustomers.get(OtherCustNum);
                                                    if(fndOtherCust == NULL) {
                                                        otherCustomer = new API_Request__c();
                                                    } else {
                                                        // Second Product with Alternate Name
                                                        if(fndOtherCust.Customer_Email__c != NULL) {
                                                            OtherCustNum++;
                                                            otherCustomer = new API_Request__c();
                                                        } else {
                                                            otherCustomer = fndOtherCust;    
                                                        }
                                                    }
                                                    otherCustomer.Customer_Email__c = lip.value.toLowerCase();
                                                    apiLi.Second_Email__c = lip.value.toLowerCase();
                                                    otherCustomer.Product_Code__c = pcode;
                                                    ri.mapOtherCustomers.put(OtherCustNum, otherCustomer);
                                                }
                                            }                                                
                                        }

                                        // Update relatedCustomers
                                        if(ri.mapOtherCustomers.values().size() > 0) {
                                            for(API_Request__c ar :ri.mapOtherCustomers.values()) {
                                                if(ar.Customer_Email__c != null) {
                                                    relatedCustomer fndRelCustomer = ri.relatedCustomers.get(ar.Customer_Email__c);
                                                    relatedCustomer rc;
                                                    if(fndRelCustomer == NULL) {
                                                        rc = new relatedCustomer();
                                                        rc.fname = ar.First_Name__c;
                                                        rc.lname = ar.Last_Name__c;
                                                        rc.email = ar.Customer_Email__c;
                                                        rc.lineIds = new List<String>();
                                                    } else {
                                                        rc = fndRelCustomer;
                                                    }
                                                    rc.lineIds.add(apiLi.External_Id__c);
                                                    ri.relatedCustomers.put(rc.email,rc);
                                                }                                                
                                            }
                                      } else {
                                          relatedCustomer fndRelCustomer = ri.relatedCustomers.get(apiReqIn.Customer_Email__c);
                                            if(fndRelCustomer == NULL) {
                                                relatedCustomer rc = new relatedCustomer();
                                                rc.fname = apiReqIn.First_Name__c;
                                                rc.lname = apiReqIn.Last_Name__c;
                                                rc.email = apiReqIn.Customer_Email__c;
                                                rc.lineIds = new List<String>();
                                                rc.lineIds.add(apiLi.External_Id__c);
                                                ri.relatedCustomers.put(rc.email,rc);
                                            } else {
                                                fndRelCustomer.lineIds.add(apiLi.External_Id__c);
                                                ri.relatedCustomers.put(apiReqIn.Customer_Email__c,fndRelCustomer);
                                            }
                                      }
                                        System.debug('ri.relatedCustomers:' + ri.relatedCustomers);
                                    }
                                    apiLines.add(apiLi);
                                    System.debug('apiLines add:' + apiLines);
                                }
                            }
                        }
                    }
                    if(goodCode != null) {
                        apiReqIn.Product_Code__c = goodCode;
                    }
                    System.debug('apiReqIn update:' + apiReqIn);
                    
                    if(sOrder.shipping_lines != NULL) {
                        
                        for(shopifyCreateOrderShippingLine li :sOrder.shipping_lines) {
                            
                            System.debug('ShippingLine li:' + li);
                            
                            API_Request_Line_Item__c apiLi = new API_Request_Line_Item__c();
                            apiLi.Type__c = 'Shipping';
                            apiLi.API_Request__c = apiReqIn.Id;
                            
                            if(li.title.length() > 80)
                                apiLi.Name = li.title.substring(0, 80); 
                            Else apiLi.Name = li.title;
                            
                            apiLi.Code__c = li.code;
                            apiLi.Phone__c = li.phone;
                            apiLi.Amount__c = Decimal.valueOf(li.price);
                            apiLines.add(apiLi);
                            System.debug('apiLi:' + apiLi);
                        }        
                    }
                    
                    // Fix Product Name
                    if(apiReqIn.Product_Code__c.indexOf('E28 REUP') > -1)
                        apiReqIn.Product_Code__c = 'E28 REUP';
                    
                    if(sOrder.total_price != NULL) {
                        apiReqIn.Amount__c = Decimal.valueOf(sOrder.total_price);    
                    } else {
                        apiReqIn.Amount__c = 0;
                    }
                    
                    // Addresses
                    if(sOrder.customer != NULL && sOrder.customer.default_address != NULL) {
                        apiReqIn.State__c = sOrder.customer.default_address.province;
                        apiReqIn.Street1__c = sOrder.customer.default_address.address1;
                        apiReqIn.Street2__c = sOrder.customer.default_address.address2;
                        apiReqIn.Zip__c = sOrder.customer.default_address.zip;
                        apiReqIn.City__c = sOrder.customer.default_address.city;
                        apiReqIn.Company__c = sOrder.customer.default_address.company;
                        apiReqIn.Country__c = sOrder.customer.default_address.country_code;
                    }
                
                    if(sOrder.billing_address != NULL) {

                        apiReqIn.Billing_First_Name__c  = sOrder.billing_address.first_name;
                        apiReqIn.Billing_Last_Name__c = sOrder.billing_address.last_name;
                        
                        if(apiReqIn.First_Name__c==NULL)
                            apiReqIn.First_Name__c=sOrder.billing_address.first_name;
                        if(apiReqIn.Last_Name__c==NULL)
                            apiReqIn.Last_Name__c=sOrder.billing_address.last_name;
                        
                        apiReqIn.Billing_State__c = sOrder.billing_address.province;
                        apiReqIn.Billing_Street1__c = sOrder.billing_address.address1;
                        apiReqIn.Billing_Street2__c = sOrder.billing_address.address2;
                        apiReqIn.Billing_Zip__c = sOrder.billing_address.zip;
                        apiReqIn.Billing_City__c = sOrder.billing_address.city;
                        apiReqIn.Billing_Company__c = sOrder.billing_address.company;
                        apiReqIn.Billing_Country__c = sOrder.billing_address.country_code;
                        apiReqIn.Billing_Phone__c = sOrder.billing_address.phone;
                        
                    }

                    if(sOrder.shipping_address != null) {
                        apiReqIn.Shipping_First_Name__c  = sOrder.shipping_address.first_name;
                        apiReqIn.Shipping_Last_Name__c = sOrder.shipping_address.last_name;
                        
                        if(apiReqIn.First_Name__c==NULL)
                            apiReqIn.First_Name__c=sOrder.shipping_address.first_name;
                        if(apiReqIn.Last_Name__c==NULL)
                            apiReqIn.Last_Name__c=sOrder.shipping_address.last_name;
                        
                        apiReqIn.Shipping_State__c = sOrder.shipping_address.province;
                        apiReqIn.Shipping_Street1__c = sOrder.shipping_address.address1;
                        apiReqIn.Shipping_Street2__c = sOrder.shipping_address.address2;
                        apiReqIn.Shipping_Zip__c = sOrder.shipping_address.zip;
                        apiReqIn.Shipping_City__c = sOrder.shipping_address.city;
                        apiReqIn.Shipping_Company__c = sOrder.shipping_address.company;
                        apiReqIn.Shipping_Country__c = sOrder.shipping_address.country_code;                
                        apiReqIn.Shipping_Phone__c = sOrder.shipping_address.phone;
                    }
                    
                    // Find Phone
                    System.debug('apiReqIn.Phone__c:' + apiReqIn.Phone__c);
                    
                    if(apiReqIn.Phone__c == NULL || apiReqIn.Phone__c.length() == 0) {
                        if(apiReqIn.Billing_Phone__c != null)
                            apiReqIn.Phone__c = apiReqIn.Billing_Phone__c;
                        else if(apiReqIn.Shipping_Phone__c != null)
                            apiReqIn.Phone__c = apiReqIn.Shipping_Phone__c;
                        else if(apiReqIn.Shipping_Phone__c != null)
                            apiReqIn.Phone__c = apiReqIn.Shipping_Phone__c;
                        else if(apiReqIn.Shipping_Phone__c != null)
                            apiReqIn.Phone__c = apiReqIn.Shipping_Phone__c;
                        
                        System.debug('Fix apiReqIn.Phone__c:' + apiReqIn.Phone__c);
                    }
                    
                    System.debug('apiReqIn.Phone__c.size():' + apiReqIn.Phone__c.length());
                    
                    //apiReqIn.Enable_Automation__c = true;
                    
                    
                    if(apiReqIn.Second_Contact_Email__c != NULL) {
                        MAP<String,String> mapProducts = new MAP<String,String>();
                        for(API_Request_Line_Item__c al :apiLines) {
                            if(al.Type__c == 'Shipping') {
                                al.Second_Email__c = apiReqIn.Second_Contact_Email__c;
                            }
                                
                        }
                    }
                    ri.apiReq = apiReqIn;
                    ri.apiLines = apiLines;
                    System.debug('ri:' + ri);
                    
                }
            
            } else {
                    
                // Action on Existinbg Order
                shopifyExistingOrder existingOrder = (shopifyExistingOrder)JSON.deserialize(rawJson, shopifyExistingOrder.class);
                system.debug('existingOrder:' + existingOrder);
             
                if(existingOrder.financial_status == 'voided')
                    apiReqIn.Request_Type__c = 'Cancel Order';                        
                else if(existingOrder.financial_status == 'refunded')
                    apiReqIn.Request_Type__c = 'Refund';
                else if(existingOrder.order_adjustments != NULL)
                    apiReqIn.Request_Type__c = 'Refund';
                
                 apiReqIn.OrderId__c = String.ValueOf(existingOrder.order_id);
                 apiReqIn.Notes__c = existingOrder.notes;
                 
                 Decimal totalAmount = 0;
                 if(existingOrder.refund_line_items != NULL && existingOrder.refund_line_items.size() > 0) {
                     for(shopifyCreateOrderRefundLineItems rli :existingOrder.refund_line_items) {
                        API_Request_Line_Item__c apiLi = new API_Request_Line_Item__c();
                        apiLi.Type__c = 'Refund';
                        apiLi.API_Request__c = apiReqIn.Id;
                        apiLi.Quantity__c =  Integer.valueOf(rli.quantity);
                        apiLi.Amount__c = Decimal.valueOf(rli.subtotal); 
                         totalAmount+=apiLi.Amount__c;
                         if(rli.line_item != null) {
                             apiLi.Name = rli.line_item.title;     
                             apiLi.Code__c = rli.line_item.product_id;
                         }
                        apiLines.add(apiLi);
                     }
                 }
                
                if(existingOrder.refunds != NULL && existingOrder.refunds.size() > 0) {
                    for(shopifyOrderRefund re :existingOrder.refunds) {
                         if(re.refund_line_items != null) {
                            for(shopifyCreateOrderRefundLineItems rli :re.refund_line_items) {
                                API_Request_Line_Item__c apiLi = new API_Request_Line_Item__c();
                                apiLi.Type__c = 'Refund';
                                apiLi.API_Request__c = apiReqIn.Id;
                                apiLi.Quantity__c =  Integer.valueOf(rli.quantity);
                                apiLi.Amount__c = Decimal.valueOf(rli.subtotal); 
                                totalAmount+=apiLi.Amount__c;
                                 if(rli.line_item != null) {
                                     if(rli.line_item.title != NULL) {
                                        if(rli.line_item.title.length() > 80)
                                          apiLi.Name = rli.line_item.title.substring(0, 80);                        
                                        else apiLi.Name = rli.line_item.title; 
                                                 
                                     }
                                     apiLi.Code__c = rli.line_item.product_id;
                                 }
                                apiLines.add(apiLi);
                             }   
                         }                            
                    }
                }
                
                if(existingOrder.order_adjustments != NULL && existingOrder.order_adjustments.size() > 0) {
                    for(shopifyOrderAdjustments adj :existingOrder.order_adjustments) {
                        API_Request_Line_Item__c apiLi = new API_Request_Line_Item__c();
                        if(adj.reason != NULL) {
                            if(adj.reason.length() > 80)
                              apiLi.Name = adj.reason.substring(0, 80);                        
                            else apiLi.Name = adj.reason; 
                        }
                        apiLi.Type__c = 'Refund';
                        apiLi.API_Request__c = apiReqIn.Id;
                        apiLi.Amount__c = Decimal.valueOf(adj.amount); 
                        if(adj.tax_amount != NULL) {
                            Decimal tax = Decimal.valueOf(adj.tax_amount);
                            apiLi.Amount__c += tax;
                        }                        
                        totalAmount+=apiLi.Amount__c;
                        apiLines.add(apiLi);
                    }
                }
                apiReqIn.Amount__c = totalAmount;
                 ri.apiReq = apiReqIn;
                 ri.apiLines = apiLines;      
            }
            return ri;
            
        //} catch (Exception e) {
        //    returnItems ri = new returnItems();
        //    apiReqIn.Response__c = e.getMessage();
            
        //    System.debug('error:' + apiReqIn.Response__c);
            
        //    ri.apiReq = apiReqIn;
        //    ri.apiLines = null;
        //    return ri;
        //}
    }
    */
    
    @future(callout=true)
    public static void sendCarriOrder(String apiReqId, String orderId) {    

        String start_date = '';
        String delivery_date;
        
        List<API_Request__c> apiReqs = [select Id, Name, OrderId__c, Customer_Email__c, Billing_Street1__c, Billing_Street2__c, Billing_City__c, Billing_Company__c, Billing_State__c, Billing_Country__c, Billing_Zip__c, Shipping_Street1__c, Shipping_Street2__c, Shipping_State__c, Shipping_Phone__c, Shipping_Last_Name__c, Shipping_First_Name__c, Shipping_Country__c, Shipping_City__c, Shipping_Zip__c from API_Request__c where Id = :apiReqId];
        System.debug('apiReqs: ' + apiReqs);
        
        if(apiReqs != null && apiReqs.size() > 0) {
            API_Request__c apiReq = apiReqs[0];   
            
            List<Opportunity> lstOpp = [select Id, Name from Opportunity where Id = :orderId];
            System.debug('lstOpp: ' + lstOpp);

            if(lstOpp != null && lstOpp.size() > 0) {
                Opportunity opp = lstOpp[0];   
                
                List<Shipment__c> lstShip = [select Id, Name, Product_Name__c, Scheduled_Date__c, Delivery_Date__c from Shipment__c where Opportunity__c = :orderId order by Delivery_Date__c ASC];
                System.debug('lstShip: ' + lstShip);
                
                if(lstShip != null && lstShip.size() > 0) {
                    Shipment__c ship = lstShip[0];   
                    
                    DateTime dt = DateTime.newInstance(ship.Scheduled_Date__c.Year(), ship.Scheduled_Date__c.Month(), ship.Scheduled_Date__c.Day());
                    start_date = dt.format('MM/dd/yyyy');
                    System.debug('start_date:' + start_date);

                    dt = DateTime.newInstance(ship.Delivery_Date__c.Year(), ship.Delivery_Date__c.Month(), ship.Delivery_Date__c.Day());
                    delivery_date = dt.format('MM/dd/yyyy');
                    System.debug('delivery_date:' + delivery_date);
                    
                    String jsonData = '{"type": "transaction","action": "create","data" :{ "id" : "' + safeSetString(apiReq.OrderId__c,NULL) + '","first_name":"' + safeSetString(apiReq.Shipping_First_Name__c,NULL) + '","last_name": "' + safeSetString(apiReq.Shipping_Last_Name__c,NULL) + '","email" : "' + safeSetString(apiReq.Customer_Email__c,NULL) + '", "start_date" : "' + start_date + '","billing_address" :  {"address_1" : "' + safeSetString(apiReq.Billing_Street1__c,NULL) + '","address_2" : "' + safeSetString(apiReq.Billing_Street1__c,NULL) + '","country":"' + safeSetString(apiReq.Billing_Country__c,NULL) + '","state":"' + safeSetString(apiReq.Billing_State__c,NULL) + '","city":"' + safeSetString(apiReq.Billing_City__c,NULL) + '","postal_code":"' + safeSetString(apiReq.Billing_Zip__c,NULL) + '"}, "shipping_address" : {"address_1" : "' + safeSetString(apiReq.Shipping_Street1__c,NULL) + '","address_2" : "' + safeSetString(apiReq.Shipping_Street2__c,NULL) + '","country":"' + safeSetString(apiReq.Shipping_Country__c,NULL) + '","state":"' + safeSetString(apiReq.Shipping_State__c,NULL) + '","city":"' + safeSetString(apiReq.Shipping_Country__c,NULL) + '","postal_code":"' + safeSetString(apiReq.Shipping_Zip__c,NULL) + '"},"product" : "' + safeSetString(ship.Product_Name__c,NULL) + '","address":"","delivery_date":"' + delivery_date + '","mobile":"' + safeSetString(apiReq.Shipping_Phone__c,NULL) + '" }}';
                    System.debug('jsonData: ' + jsonData);
                                
                    Http httpProtocol = new Http();
                    HttpRequest request = new HttpRequest();
                    String endpoint = 'https://app.euphebe.com/api/sync/';
                    system.debug('endpoint:' + endpoint);
                    
                    request.setEndPoint(endpoint);
                    request.setMethod('GET');        
                                
                    request.setHeader('content-type', 'application/json');
                    request.setHeader('authorization', 'Bearer e991e27f9963908b829997c18f795db01376a445');
                    request.setHeader('companyid', 'euphebe');
                    request.setHeader('cache-control', 'no-cache');
            
                    request.setBody(jsonData);
                    
                    HttpResponse response;
                    Integer statusCode;
                    
                    // Don't send for now
                    if(!Test.isRunningTest()){
                        response = httpProtocol.send(request);
                        system.debug('response:'+ response);
                        statusCode = response.getStatusCode();
                    } else {
                        response = new HttpResponse();
                        statusCode = 200;
                    }
                    system.debug('statusCode:'+ statusCode);
                }                
            }            
        }
    }
    
    public static returnItems setOrder(API_Request__c apiReqIn, String rawJson, shopifyCreateOrder sOrderIn) {
               
        returnItems ri = new returnItems();
        List<API_Request_Line_Item__c> apiLines = new List<API_Request_Line_Item__c>();
        ri.mapOtherCustomers = new MAP<Integer,API_Request__c>();   
        ri.relatedCustomers = new MAP<String,relatedCustomer>();
     
        try {
        // Get all existing Shopify Product IDs to check for custom meals
        List<Product2> lstProd = [select Id, Name, Shopify_Product_Id__c, ProductCode from Product2 where IsActive = true];
        MAP<String,String> mapProds = new MAP<String,String>();
        MAP<String,Product2> mapProdsByCode = new MAP<String,Product2>();
        
        for(Product2 p :lstProd) {
            mapProds.put(p.Shopify_Product_Id__c,p.Name);
            mapProdsByCode.put(p.ProductCode,p);
        }
        system.debug('mapProdsByCode:' + mapProdsByCode);
        
        shopifyCreateOrder sOrder;
        
        if(sOrderIn != null) {
            sOrder = sOrderIn;
        } else {
             
                //rawJson = rawJson.replace('{"name":"cart_attributes","value":{"0":{"Shipping date":"Testing"}}}','{"name":"Shipping date","value":"2/14/2019"}');
            
            sOrder = (shopifyCreateOrder)JSON.deserialize(rawJson, shopifyCreateOrder.class);
            apiReqIn.Raw_Request__c = rawJson;
        }
        system.debug('sOrder:' + sOrder);        
        
            // Is Order
            if(sOrder.order_number != null && sOrder.order_id == null) {
            
                apiReqIn.Order_Number__c = String.valueOf(sOrder.order_number);
                apiReqIn.OrderId__c = String.ValueOf(sOrder.id);
                apiReqIn.Customer_Email__c = safeSetString(sOrder.email, 'unknow@unknow.com'); 
                apiReqIn.Customer_Email__c = apiReqIn.Customer_Email__c.toLowerCase();
                                
                if(sOrder.shipping_address != NULL) {
                	apiReqIn.Phone__c = safeSetString(sOrder.shipping_address.phone,NULL);    
                } else if(sOrder.billing_address != NULL) {
                    apiReqIn.Phone__c = safeSetString(sOrder.billing_address.phone,NULL);
                }
                
                apiReqIn.Financial_Status__c = safeSetString(sOrder.financial_status,NULL);
                apiReqIn.Order_Status_URL__c = sOrder.order_status_url;
                
                // Is Recharge
                if(sOrder.tags != NULL && sOrder.tags.indexOf('Recurring Order') > -1) {
                    apiReqIn.Is_Recharge__c = True;
                }
                
                if(sOrder.customer != NULL) {
                    
                    if(sOrder.shipping_address != NULL) {
                        apiReqIn.First_Name__c  = safeSetString(sOrder.shipping_address.first_name,'FirstName');
                    } else if(sOrder.billing_address != NULL) {
                        apiReqIn.First_Name__c  = safeSetString(sOrder.billing_address.first_name,'FirstName');
                    }
                    
                    if(sOrder.shipping_address != NULL) {
                        apiReqIn.Last_Name__c = safeSetString(sOrder.shipping_address.last_name,'LastName');
                    } else if(sOrder.billing_address != NULL) {
                        apiReqIn.Last_Name__c = safeSetString(sOrder.billing_address.last_name,'LastName');
                    } 
                    
                    apiReqIn.Customer_Id__c = sOrder.customer.id;                    
                }
                
                //sOrder.created_at = sOrder.created_at.replace('T', ' ');
                //apiReqIn.Created_At__c = DateTime.valueOf(sOrder.created_at);
                if(sOrder.created_at != null) {
                    System.debug('sOrder.created_at:' + sOrder.created_at);
                    apiReqIn.Created_At__c = (datetime)json.deserialize('"' + sOrder.created_at + '"', datetime.class);
                    System.debug('apiReqIn.Created_At__c:' + apiReqIn.Created_At__c);
                }
                
                if(apiReqIn.Financial_Status__c == 'refunded') {
                    apiReqIn.Request_Type__c = 'Cancel Order';
                    apiReqIn.Enable_Automation__c = true;
                    ri.apiReq = apiReqIn;
                    ri.apiLines = null;
                } else {
                    
                    apiReqIn.Request_Type__c = 'Create Order';
                    System.debug('apiReqIn.Request_Type__c:' + apiReqIn.Request_Type__c);
                    
                    if(sOrder.discount_codes != NULL && sOrder.discount_codes.size() > 0) {
                        for(shopifyCreateOrderDiscountCodes dcs :sOrder.discount_codes) {
                            API_Request_Line_Item__c apiLi = new API_Request_Line_Item__c();
                            apiLi.Type__c = 'Discount';
                            apiLi.API_Request__c = apiReqIn.Id;
                            apiLi.Name = setStringLimit(dcs.code,80);
                            apiLi.Code__c = dcs.code;
                            apiLi.Amount__c =  Decimal.valueOf(dcs.amount);
                            if(apiLi.Amount__c == 0 && sOrder.total_discounts != NULL) {
                                apiLi.Amount__c =  Decimal.valueOf(sOrder.total_discounts);
                            }
                            apiLines.add(apiLi);
                        }
                    }
                    System.debug('apiLines1:' + apiLines);
                    
                    /*
                    apiReqIn.How_did_you_hear_Long__c = '';
                    if(sOrder.note_attributes != NULL) {
                        for(shopifyCreateOrderLineItemsProperties li :sOrder.note_attributes) {
                            if(li.name == 'how-did-you-hear-about-us' && li.value.length() > 0 && li.value != 'Other')
                                apiReqIn.How_did_you_hear_Long__c = li.value;
                            else if(li.name == 'how-did-you-hear-about-us-other' && li.value.length() > 0)
                                apiReqIn.How_did_you_hear_Long__c = li.value;
                            
                            if(li.name == 'Delivery Details' && li.value.length() > 0) 
                                apiReqIn.Shipping_Instructions_Long__c = li.value;
                            
                            if(li.name == 'olark-conversation-url' && li.value.length() > 0) 
                              apiReqIn.Olark_Conversation_Url__c = setStringLimit(li.value,255);
                            
                            if(li.name == 'olark-operator' && li.value.length() > 0) 
                              apiReqIn.Olark_Operator__c = setStringLimit(li.value,255);
                        }
                    }
                    System.debug('apiReqIn Update:' + apiReqIn);
                    */
                    
                    apiReqIn.Product_Code__c = '';
                    String goodCode;
                    if(sOrder.line_items != null) {
                        
                        for(shopifyCreateOrderLineItemsNew li :sOrder.line_items) {
                            System.debug('li:' + li);
                            
                            
                            if(li.price != NULL) {
                                API_Request_Line_Item__c apiLi = new API_Request_Line_Item__c();
                                apiLi.Type__c = 'Product';
                                apiLi.API_Request__c = apiReqIn.Id;
                                apiLi.External_Id__c = String.valueOf(li.id);
                                
                                if(li.title == NULL) {
                                    apiLi.Name = 'Misc';
                                } else {
                                    apiLi.Name = setStringLimit(li.title, 80);
                                }
    
                                apiLi.Amount__c = Decimal.valueOf(li.price);
                                if(li.quantity == NULL) {
                                    apiLi.Quantity__c = 1;    
                                } else {
                                    apiLi.Quantity__c = Integer.valueOf(li.quantity);    
                                }
                                                                
                                String pcode=null;
                                if(li.product_id != NULL) {
                                    pcode = String.valueOf(li.product_id);
                                    goodCode = pcode;
                                } else if(li.sku != NULL) {
                                    pcode = li.sku;
                                } else {
                                    pcode = 'misc';
                                }
                                
                                // Map Products ~ Custom Subscription, replace Subscription
                                if(pcode == '4370839765110') {
                                    pcode = '2568373076086';
                                    apiLi.Amount__c = 155;
                                }
                                
                                // Map Products ~ Custom Reboot, replace Reboot
                                if(pcode == '4613544640630') {
                                    pcode = '2568373141622';
                                    apiLi.Amount__c = 175;
                                }
                                
                                // Map Products ~ Custom Quickstart, place as Quickstart
                                if(pcode == '4409473368182') {
                                    pcode = '2568373207158';
                                    apiLi.Amount__c = 225;
                                }

                                System.debug('pcode:' + pcode);
                                
                                if(pcode != NULL) {
                                    
                                    // Get Shipdate
                                    if(li.properties != null) {
                                        
                                        for(shopifyCreateOrderLineItemsProperties lip :li.properties) {
                                            
                                            if(lip.name != null && lip.name == 'shipping_date') {
                                                
                                                try {
                                                    apiReqIn.Ship_Date__c = parseShippingDate(lip.value); 
                                                }catch(exception e){
                                                    
                                                }
                                                
                                            }   
                                        }
                                    }                                       
                                    
                                    String fndProd = mapProds.get(pcode);
                                    
                                    if(fndProd != NULL) {
                                                                                
                                        apiLi.Code__c = pcode;
                                        apiReqIn.Product_Code__c = pcode;
                                        
                                        if(li.properties != null) {
                                            
                                            API_Request__c otherCustomer;
                                            Integer OtherCustNum=Null;
                                            ri.mapOtherCustomers = new MAP<Integer,API_Request__c>();  
                                            for(shopifyCreateOrderLineItemsProperties lip :li.properties) {
                                                
                                                System.debug('lip:' + lip);
                                                
                                                // New Custom Meal List
                                                if(lip.name != null && lip.name == 'meal_list' && lip.value != NULL) {
                                                    
                                                    String[] lines = lip.value.split('\n');
                                                    for(String s :lines) {
                                                        System.debug('s:' + s);
                                                        if(s.indexOf('Custom Box ID') == -1) {
                                                            String[] parts = s.split(' - ');
                                                            if(parts.size() > 2) {
                                                                String mid = parts[0];
                                                                String name = parts[1];
                                                                String quantity = parts[2];
                                                                System.debug('item:' + mid + ':' + name + ':' + quantity);
                                                                
                                                                // Add Custom Meal
                                                                apiReqIn.Is_Custom__c = True;
                                                                API_Request_Line_Item__c apiLiMeal = new API_Request_Line_Item__c();
                                                                apiLiMeal.Name = name;
                                                                apiLiMeal.Type__c = 'Meal';
                                                                apiLiMeal.API_Request__c = apiReqIn.Id;
                                                                apiLiMeal.External_Id__c = mid;
                                                                apiLiMeal.Quantity__c = Integer.valueOf(quantity);                                                                
                                                                apiLiMeal.Ship_Date__c = apiReqIn.Ship_Date__c;
                                                                
                                                                apiLines.add(apiLiMeal);
                                                                System.debug('apiLiMeal:' + apiLiMeal);
                                                                
                                                            }
                                                        }
                                                    }
                                                    
                                                }
                                                
                                                if(lip.name != null && lip.name == 'shipping_date') {
                                                    
                                                    try {
                                                        apiReqIn.Ship_Date__c = parseShippingDate(lip.value); 
                                                        apiLi.Ship_Date__c = parseShippingDate(lip.value);
                                                                                                               
                                                    }catch(exception e){
                                                        
                                                    }
                                                    //system.assert(false, 'BOOM!setOrderNew'+ apiLi);
                                                    
                                                } 
                                                
                                                if(lip.name != null && lip.name == 'shipping_interval_frequency') {
                                                    
                                                    //system.assert(false, 'BOOM!setOrderNew'+ lip);
                                                    
                                                    try {
                                                        apiReqIn.Frequency__c = Integer.valueOf(lip.value);
                                                    }catch(exception e){
                                                        
                                                    }
                                                } 
                                                

                                                if(lip.name != null && lip.name == 'hdyhau') {
                                                    
                                                    //system.assert(false, 'BOOM!setOrderNew'+ lip);
                                                    
                                                    try {
                                                        apiReqIn.How_did_you_hear_Long__c = lip.value;
                                                    }catch(exception e){
                                                        
                                                    }
                                                } 
                                            }
                                            
                                        }
                                        apiLines.add(apiLi);
                                        System.debug('apiLines add:' + apiLines);
                                        
                                    } else {
                                        // Custom Meal
                                        apiReqIn.Is_Custom__c = True;
                                        API_Request_Line_Item__c apiLiMeal = new API_Request_Line_Item__c();
                                        apiLiMeal.Name = apiLi.Name;
                                        apiLiMeal.Type__c = 'Meal';
                                        apiLiMeal.API_Request__c = apiReqIn.Id;
                                        apiLiMeal.External_Id__c = pcode;
                                        apiLiMeal.Quantity__c = apiLi.Quantity__c;
                                        apiLiMeal.Ship_Date__c = apiReqIn.Ship_Date__c;
                                        
                                        apiLines.add(apiLiMeal);
                                        System.debug('apiLiMeal:' + apiLiMeal);                                        
                                    }
                                        
                                }
                            }
                        }                        
                    }
                    if(goodCode != null) {
                        apiReqIn.Product_Code__c = goodCode;
                    }
                    System.debug('apiReqIn update:' + apiReqIn);
                    
                    if(sOrder.shipping_lines != NULL) {
                        
                        for(shopifyCreateOrderShippingLine li :sOrder.shipping_lines) {
                            
                            System.debug('ShippingLine li:' + li);
                            
                            API_Request_Line_Item__c apiLi = new API_Request_Line_Item__c();
                            apiLi.Type__c = 'Shipping';
                            apiLi.API_Request__c = apiReqIn.Id;
                            
                            if(li.title.length() > 80)
                                apiLi.Name = li.title.substring(0, 80); 
                            Else apiLi.Name = li.title;
                            
                            apiLi.Code__c = li.code;
                            apiLi.Phone__c = li.phone;
                            apiLi.Amount__c = Decimal.valueOf(li.price);
                            apiLines.add(apiLi);
                            System.debug('apiLi:' + apiLi);
                        }        
                    }
                    
                    // Fix Product Name
                    //if(apiReqIn.Product_Code__c.indexOf('E28 REUP') > -1)
                    //    apiReqIn.Product_Code__c = 'E28 REUP';
                    
                    if(sOrder.total_price != NULL) {
                        apiReqIn.Amount__c = Decimal.valueOf(sOrder.total_price);    
                    } else {
                        apiReqIn.Amount__c = 0;
                    }
                    
                    // Addresses
                    // 9/1/2021 - Use Shipping Address
                    if(sOrder.shipping_address != null) {
                        apiReqIn.First_Name__c=sOrder.shipping_address.first_name;
                        apiReqIn.Last_Name__c=sOrder.shipping_address.last_name;

                        apiReqIn.State__c = sOrder.shipping_address.province;
                        apiReqIn.Street1__c = sOrder.shipping_address.address1;
                        apiReqIn.Street2__c = sOrder.shipping_address.address2;
                        apiReqIn.Zip__c = sOrder.shipping_address.zip;
                        apiReqIn.City__c = sOrder.shipping_address.city;
                        apiReqIn.Company__c = sOrder.shipping_address.company;
                        apiReqIn.Country__c = sOrder.shipping_address.country_code;
                    }
                
                    if(sOrder.billing_address != NULL) {

                        apiReqIn.Billing_First_Name__c  = sOrder.billing_address.first_name;
                        apiReqIn.Billing_Last_Name__c = sOrder.billing_address.last_name;
                        
                        if(apiReqIn.First_Name__c==NULL)
                            apiReqIn.First_Name__c=sOrder.billing_address.first_name;
                        if(apiReqIn.Last_Name__c==NULL)
                            apiReqIn.Last_Name__c=sOrder.billing_address.last_name;
                        
                        apiReqIn.Billing_State__c = sOrder.billing_address.province;
                        apiReqIn.Billing_Street1__c = sOrder.billing_address.address1;
                        apiReqIn.Billing_Street2__c = sOrder.billing_address.address2;
                        apiReqIn.Billing_Zip__c = sOrder.billing_address.zip;
                        apiReqIn.Billing_City__c = sOrder.billing_address.city;
                        apiReqIn.Billing_Company__c = sOrder.billing_address.company;
                        apiReqIn.Billing_Country__c = sOrder.billing_address.country_code;
                        apiReqIn.Billing_Phone__c = sOrder.billing_address.phone;
                        
                    }

                    if(sOrder.shipping_address != null) {
                        apiReqIn.Shipping_First_Name__c  = sOrder.shipping_address.first_name;
                        apiReqIn.Shipping_Last_Name__c = sOrder.shipping_address.last_name;
                        
                        if(apiReqIn.First_Name__c==NULL)
                            apiReqIn.First_Name__c=sOrder.shipping_address.first_name;
                        if(apiReqIn.Last_Name__c==NULL)
                            apiReqIn.Last_Name__c=sOrder.shipping_address.last_name;
                        
                        apiReqIn.Shipping_State__c = sOrder.shipping_address.province;
                        apiReqIn.Shipping_Street1__c = sOrder.shipping_address.address1;
                        apiReqIn.Shipping_Street2__c = sOrder.shipping_address.address2;
                        apiReqIn.Shipping_Zip__c = sOrder.shipping_address.zip;
                        apiReqIn.Shipping_City__c = sOrder.shipping_address.city;
                        apiReqIn.Shipping_Company__c = sOrder.shipping_address.company;
                        apiReqIn.Shipping_Country__c = sOrder.shipping_address.country_code;                
                        apiReqIn.Shipping_Phone__c = sOrder.shipping_address.phone;
                    }
                    
                    // Find Phone
                    System.debug('apiReqIn.Phone__c:' + apiReqIn.Phone__c);
                    
                    if(apiReqIn.Phone__c == NULL || apiReqIn.Phone__c.length() == 0) {
                        if(apiReqIn.Billing_Phone__c != null)
                            apiReqIn.Phone__c = apiReqIn.Billing_Phone__c;
                        else if(apiReqIn.Shipping_Phone__c != null)
                            apiReqIn.Phone__c = apiReqIn.Shipping_Phone__c;
                        else if(apiReqIn.Shipping_Phone__c != null)
                            apiReqIn.Phone__c = apiReqIn.Shipping_Phone__c;
                        else if(apiReqIn.Shipping_Phone__c != null)
                            apiReqIn.Phone__c = apiReqIn.Shipping_Phone__c;
                        
                        System.debug('Fix apiReqIn.Phone__c:' + apiReqIn.Phone__c);
                    }
                    
                    System.debug('apiReqIn.Phone__c.size():' + apiReqIn.Phone__c.length());
                    
                    //apiReqIn.Enable_Automation__c = true;
                    
                    /*
                    if(apiReqIn.Second_Contact_Email__c != NULL) {
                        MAP<String,String> mapProducts = new MAP<String,String>();
                        for(API_Request_Line_Item__c al :apiLines) {
                            if(al.Type__c == 'Shipping') {
                                al.Second_Email__c = apiReqIn.Second_Contact_Email__c;
                            }
                                
                        }
                    }
                    */
                    ri.apiReq = apiReqIn;
                    
                    //system.assert(false, 'BOOM!setOrderNew'+ apiLines);
                    
                    Boolean foundProduct = false;                    
                    Boolean foundShipping = false;                    
                    Boolean foundMeals = false;
                    Boolean foundDateInPastOrNUll = false;
                    
                    
                    // Get Shipping Dates
                    List<Alternate_Shipping_Days__c> altDays = Alternate_Shipping_Days__c.getall().values();
                    map<Date,Date> ampAltDays = new map<Date,Date>();
                    for(Alternate_Shipping_Days__c altd :altDays) {
                        ampAltDays.put(altd.Alt_Ship_Date__c, altd.Ship_Date__c);
                    }
                    
                    // Next Monday                    
                    date myDate = date.today();
                    date weekStart = myDate.toStartofWeek(); // Week starts on Sunday
                    
                    // If today is Sunday
                    if(myDate.daysBetween(weekStart) == 0) {
                        weekStart = weekStart.addDays(1);
                    } else {
                        weekStart = weekStart.addDays(8);      
                    }
                    
                    Date newShippingDate = weekStart;
                                       
                    // Do we need to adjust?
                    Date fndAlt = ampAltDays.get(newShippingDate);
                    if(fndAlt != NULL) {
                        newShippingDate = fndAlt;
                    }                    
                    
                    for(API_Request_Line_Item__c apiLine :apiLines) {
                        if(apiLine.Type__c == 'Product') {
                            foundProduct = true;
                            // If Shipdate in the past make it next monday
                            if(apiLine.Ship_Date__c == NULL || apiLine.Ship_Date__c <= Date.today()) {
                                apiLine.Ship_Date__c = newShippingDate;
                            }
                        }
                        if(apiLine.Type__c == 'Shipping') {
                            foundShipping = true;
                        }                        
                        if(apiLine.Type__c == 'Meal') {
                            foundMeals = true;
                        }                        
                    }
                                       
                    // If Shipdate in the past make it next monday
                    if(apiReqIn.Ship_Date__c == NULL || apiReqIn.Ship_Date__c <= Date.today()) {
                        apiReqIn.Ship_Date__c = newShippingDate;
                        foundDateInPastOrNUll = true;
                    }
                    
                    if(foundProduct == false && foundMeals == true) {
                        Product2 fndProd = mapProdsByCode.get('MOZJ');
                        if(fndProd != NULL) {     
                        
                            // Add Product                       
                            API_Request_Line_Item__c apiLiProd = new API_Request_Line_Item__c();
                            apiLiProd.Name = fndProd.Name;
                            apiLiProd.Type__c = 'Product';
                            apiLiProd.API_Request__c = apiReqIn.Id;
                            apiLiProd.Code__c = fndProd.Shopify_Product_Id__c;
                            apiLiProd.External_Id__c = fndProd.Shopify_Product_Id__c;
                            apiLiProd.Quantity__c = 1;    
                            apiLiProd.Amount__c = 155;
                               
                            // Calc Ship Date    
                            if(apiReqIn.Ship_Date__c != NULL) {
                                apiLiProd.Ship_Date__c = apiReqIn.Ship_Date__c;
                            } else {                   
                                apiLiProd.Ship_Date__c = newShippingDate;
                                apiReqIn.Ship_Date__c = newShippingDate;
                            }
                            //system.assert(false, 'BOOM!setOrderNew'+ apiLiProd);
                            apiLines.add(apiLiProd);
                        }                            
                    }  
                    
                    if(foundShipping == false && foundMeals == true) {
                        // Add Shipping
                        API_Request_Line_Item__c apiLiShip = new API_Request_Line_Item__c();
                        apiLiShip.Name = 'Shipping';
                        apiLiShip.Type__c = 'Shipping';
                        apiLiShip.API_Request__c = apiReqIn.Id;
                        apiLiShip.Code__c = 'Shipping';
                        apiLiShip.Amount__c = 0;    
                        apiLines.add(apiLiShip);                         
                    }                  
                                        
                    // Adjust for Next Next
                    if(foundMeals == true && foundDateInPastOrNUll == True && apiReqIn.Created_At__c != NULL) {
                        String dayOfWeek = apiReqIn.Created_At__c.format('E');
                        
                        if(dayOfWeek == 'Fri' || dayOfWeek == 'Sat' || dayOfWeek == 'Sun') {
                            
                            // Adjust Another week from Monday
                            apiReqIn.Ship_Date__c = weekStart + 7;

                            // Do we need to adjust?
                            fndAlt = ampAltDays.get(apiReqIn.Ship_Date__c);
                            if(fndAlt != NULL) {
                                apiReqIn.Ship_Date__c = fndAlt;
                            }                                
                            
                            //system.assert(false, 'BOOM!setOrderNew'+ apiReqIn.Ship_Date__c);
                                                
                            for(API_Request_Line_Item__c apiLine :apiLines) {
                                if(apiLine.Type__c == 'Product') {
                                    apiLine.Ship_Date__c = apiLine.Ship_Date__c + 7;
                                }
                            }
                        }
                    }
                    ri.apiLines = apiLines;
                    System.debug('ri:' + ri);
                    
                }
            
            } else {
                    
                // Action on Existinbg Order
                shopifyExistingOrder existingOrder = (shopifyExistingOrder)JSON.deserialize(rawJson, shopifyExistingOrder.class);
                system.debug('existingOrder:' + existingOrder);
             
                if(existingOrder.financial_status == 'voided')
                    apiReqIn.Request_Type__c = 'Cancel Order';                        
                else if(existingOrder.financial_status == 'refunded')
                    apiReqIn.Request_Type__c = 'Refund';
                else if(existingOrder.order_adjustments != NULL)
                    apiReqIn.Request_Type__c = 'Refund';
                
                 apiReqIn.OrderId__c = String.ValueOf(existingOrder.order_id);
                 apiReqIn.Notes__c = existingOrder.notes;
                 
                 Decimal totalAmount = 0;
                 if(existingOrder.refund_line_items != NULL && existingOrder.refund_line_items.size() > 0) {
                     for(shopifyCreateOrderRefundLineItems rli :existingOrder.refund_line_items) {
                        API_Request_Line_Item__c apiLi = new API_Request_Line_Item__c();
                        apiLi.Type__c = 'Refund';
                        apiLi.API_Request__c = apiReqIn.Id;
                        apiLi.Quantity__c =  Integer.valueOf(rli.quantity);
                        apiLi.Amount__c = Decimal.valueOf(rli.subtotal); 
                         totalAmount+=apiLi.Amount__c;
                         if(rli.line_item != null) {
                             apiLi.Name = rli.line_item.title;     
                             apiLi.Code__c = rli.line_item.product_id;
                         }
                        apiLines.add(apiLi);
                     }
                 }
                
                if(existingOrder.refunds != NULL && existingOrder.refunds.size() > 0) {
                    for(shopifyOrderRefund re :existingOrder.refunds) {
                         if(re.refund_line_items != null) {
                            for(shopifyCreateOrderRefundLineItems rli :re.refund_line_items) {
                                API_Request_Line_Item__c apiLi = new API_Request_Line_Item__c();
                                apiLi.Type__c = 'Refund';
                                apiLi.API_Request__c = apiReqIn.Id;
                                apiLi.Quantity__c =  Integer.valueOf(rli.quantity);
                                apiLi.Amount__c = Decimal.valueOf(rli.subtotal); 
                                totalAmount+=apiLi.Amount__c;
                                 if(rli.line_item != null) {
                                     if(rli.line_item.title != NULL) {
                                        if(rli.line_item.title.length() > 80)
                                          apiLi.Name = rli.line_item.title.substring(0, 80);                        
                                        else apiLi.Name = rli.line_item.title; 
                                                 
                                     }
                                     apiLi.Code__c = rli.line_item.product_id;
                                 }
                                apiLines.add(apiLi);
                             }   
                         }                            
                    }
                }
                
                if(existingOrder.order_adjustments != NULL && existingOrder.order_adjustments.size() > 0) {
                    for(shopifyOrderAdjustments adj :existingOrder.order_adjustments) {
                        API_Request_Line_Item__c apiLi = new API_Request_Line_Item__c();
                        if(adj.reason != NULL) {
                            if(adj.reason.length() > 80)
                              apiLi.Name = adj.reason.substring(0, 80);                        
                            else apiLi.Name = adj.reason; 
                        }
                        apiLi.Type__c = 'Refund';
                        apiLi.API_Request__c = apiReqIn.Id;
                        apiLi.Amount__c = Decimal.valueOf(adj.amount); 
                        if(adj.tax_amount != NULL) {
                            Decimal tax = Decimal.valueOf(adj.tax_amount);
                            apiLi.Amount__c += tax;
                        }                        
                        totalAmount+=apiLi.Amount__c;
                        apiLines.add(apiLi);
                    }
                }
                apiReqIn.Amount__c = totalAmount;
                 ri.apiReq = apiReqIn;
                 ri.apiLines = apiLines;      
            }
            
        }catch(exception e){
            system.debug('setCustomer exception:' + e); 
            
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] { 'garcia.alberto.crespo@gmail.com' };
            message.optOutPolicy = 'FILTER';
            message.subject = 'setOrder Exception';
            
            String msg='';
            if(apiReqIn != NULL) {
               msg = msg + apiReqIn + '\n\n';
            }
            if(rawJson!= NULL) {
                msg = msg + rawJson + '\n\n';
            }
            if(sOrderIn!= NULL) {
                msg = msg + sOrderIn + '\n\n';
            }
            
            message.plainTextBody = e.getMessage() + '\n' + e.getLineNumber() + '\n\n' + msg;
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);            
                       
        }            
        return ri;
        
    }    
    
    @future(callout=true)
    public static void updateShopifyInventory(String shopifyMealId, Integer inventoryCnt) {
        
        System.debug('shopifyMealId:' + shopifyMealId);
        System.debug('inventoryCnt:' + String.valueOf(inventoryCnt));
            
        
        String inventoryControl = Label.Inventory_Sync_Control;
        if(inventoryControl != NULL && inventoryControl == 'True') {
            List<Meal__c> lstMeals = [Select Id, Name, Inventory__c, Inventory_Sync__c, Inventory_Sync_Off_Call__c  from Meal__c where Status__c = 'Active' AND Shopify_ID__c = :shopifyMealId];
            if(lstMeals != NULL && lstMeals.size() > 0) {
                lstMeals[0].Inventory_Sync_Off_Call__c = String.valueOf(inventoryCnt);
                lstMeals[0].Inventory_Sync__c = False;
            }
            update lstMeals;
        } else {
            
            Http httpProtocol = new Http();
            HttpRequest request = new HttpRequest();
            //String endpoint = 'https://euphebe-shop.myshopify.com/admin/products.json';
            String endpoint = 'https://euphebe-shop.myshopify.com/admin/products/' + shopifyMealId + '.json';
            system.debug('endpoint:' + endpoint);
            
            request.setEndPoint(endpoint);
            request.setMethod('GET');        
            String username = Label.ShopifyAPIUserName;
            String password = Label.ShopifyAPIPassword;
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            request.setHeader('Authorization', authorizationHeader);     
            request.setHeader('content-type', 'application/json');
            
            HttpResponse response;
            Integer statusCode;
            if(!Test.isRunningTest()){
                response = httpProtocol.send(request);
                statusCode = response.getStatusCode();
            } else {
                response = new HttpResponse();
                statusCode = 200;
            }
            system.debug('statusCode:' + String.valueOf(statusCode));
            if(statusCode == 200) {
                String body;
                if(!Test.isRunningTest()){
                    body = response.getBody();
                    System.debug('body:' + body);
                    
                    // Find Product
                    returnProduct sProd = (returnProduct)JSON.deserialize(body, returnProduct.class);
                    system.debug('sProds:' + sProd);
                    if(sProd != NULL && sProd.product != NULL) {
                        shopifyProduct sp = sProd.product;
                        shopifyVariant sv = sp.variants[0];
                        shopifyInventoryItem UpdateInv = new shopifyInventoryItem();
                        
                        if(sv.inventory_item_id != NULL) {
                            
                            // Get Inventory Level
                            endpoint = 'https://euphebe-shop.myshopify.com/admin/inventory_levels.json?inventory_item_ids=' + sv.inventory_item_id;
                            system.debug('endpoint:' + endpoint);
                            
                            Http httpProtocol1 = new Http();
                            HttpRequest request1 = new HttpRequest();
                                                        
                            request1.setEndPoint(endpoint);
                            request1.setMethod('GET');        
                            request1.setHeader('Authorization', authorizationHeader);     
                            request1.setHeader('content-type', 'application/json');
                            
                            HttpResponse response1;
                            if(!Test.isRunningTest()){
                                response1 = httpProtocol1.send(request1);
                                statusCode = response1.getStatusCode();
                                body = response1.getBody();
                            } else {
                                response1 = new HttpResponse();
                                statusCode = 200;
                                body = '{"inventory_levels":[{"inventory_item_id":33529807929462,"location_id":11007307,"available":12,"updated_at":"2021-03-01T14:46:05-05:00","admin_graphql_api_id":"gid://shopify/InventoryLevel/1674123?inventory_item_id=33529807929462"}]}';
                            }
                            system.debug('statusCode:' + String.valueOf(statusCode)); 
                            System.debug('body:' + body);
                            
                            if(statusCode == 200) {
                                shopifyInventoryLevels sInvLevels = (shopifyInventoryLevels)JSON.deserialize(body, shopifyInventoryLevels.class);
                                if(sInvLevels != NULL && sInvLevels.inventory_levels != NULL && sInvLevels.inventory_levels.size() > 0 && sInvLevels.inventory_levels[0].location_id != NULL) {
                                    
                                    UpdateInv.inventory_item_id = sv.inventory_item_id;
                                    UpdateInv.location_id = sInvLevels.inventory_levels[0].location_id;
                                    UpdateInv.available = inventoryCnt;
                                    system.debug('UpdateInv:' + UpdateInv);
                                    
                                    // Update Inventory
                                    endpoint = 'https://euphebe-shop.myshopify.com/admin/inventory_levels/set.json';
                                    system.debug('endpoint:' + endpoint);
                                    
                                    Http httpProtocol2 = new Http();
                                    HttpRequest request2 = new HttpRequest();
                                    
                                    String jsonBody = JSON.serialize(UpdateInv); 
                                    system.debug('jsonBody:' + jsonBody);        
                                    request2.setBody(jsonBody);
                                    
                                    request2.setEndPoint(endpoint);
                                    request2.setMethod('POST');        
                                    request2.setHeader('Authorization', authorizationHeader);     
                                    request2.setHeader('content-type', 'application/json');
                                    
                                    HttpResponse response2;
                                    if(!Test.isRunningTest()){
                                        response2 = httpProtocol1.send(request2);
                                        statusCode = response1.getStatusCode();
                                    } else {
                                        response2 = new HttpResponse();
                                        statusCode = 200;
                                    }
                                    system.debug('statusCode:' + String.valueOf(statusCode));                                     
                                    
                                }                            
                            }
                               
                        }  
                    }
                } else {
                    body = '{}';
                }
            }         
        }
    }
    
    public static void updateShopifyInventoryNotFuture(String shopifyMealId, Integer inventoryCnt) {
        
        System.debug('shopifyMealId:' + shopifyMealId);
        System.debug('inventoryCnt:' + String.valueOf(inventoryCnt));
            
        
        String inventoryControl = Label.Inventory_Sync_Control;
        if(inventoryControl != NULL && inventoryControl == 'True') {
            List<Meal__c> lstMeals = [Select Id, Name, Inventory__c, Inventory_Sync__c, Inventory_Sync_Off_Call__c  from Meal__c where Status__c = 'Active' AND Shopify_ID__c = :shopifyMealId];
            if(lstMeals != NULL && lstMeals.size() > 0) {
                lstMeals[0].Inventory_Sync_Off_Call__c = String.valueOf(inventoryCnt);
                lstMeals[0].Inventory_Sync__c = False;
            }
            update lstMeals;
        } else {
            
            Http httpProtocol = new Http();
            HttpRequest request = new HttpRequest();
            //String endpoint = 'https://euphebe-shop.myshopify.com/admin/products.json';
            String endpoint = 'https://euphebe-shop.myshopify.com/admin/products/' + shopifyMealId + '.json';
            system.debug('endpoint:' + endpoint);
            
            request.setEndPoint(endpoint);
            request.setMethod('GET');        
            String username = Label.ShopifyAPIUserName;
            String password = Label.ShopifyAPIPassword;
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            request.setHeader('Authorization', authorizationHeader);     
            request.setHeader('content-type', 'application/json');
            
            HttpResponse response;
            Integer statusCode;
            if(!Test.isRunningTest()){
                response = httpProtocol.send(request);
                statusCode = response.getStatusCode();
            } else {
                response = new HttpResponse();
                statusCode = 200;
            }
            system.debug('statusCode:' + String.valueOf(statusCode));
            if(statusCode == 200) {
                String body;
                if(!Test.isRunningTest()){
                    body = response.getBody();
                    System.debug('body:' + body);
                    
                    // Find Product
                    returnProduct sProd = (returnProduct)JSON.deserialize(body, returnProduct.class);
                    system.debug('sProds:' + sProd);
                    if(sProd != NULL && sProd.product != NULL) {
                        shopifyProduct sp = sProd.product;
                        shopifyVariant sv = sp.variants[0];
                        shopifyInventoryItem UpdateInv = new shopifyInventoryItem();
                        
                        if(sv.inventory_item_id != NULL) {
                            
                            // Get Inventory Level
                            endpoint = 'https://euphebe-shop.myshopify.com/admin/inventory_levels.json?inventory_item_ids=' + sv.inventory_item_id;
                            system.debug('endpoint:' + endpoint);
                            
                            Http httpProtocol1 = new Http();
                            HttpRequest request1 = new HttpRequest();
                                                        
                            request1.setEndPoint(endpoint);
                            request1.setMethod('GET');        
                            request1.setHeader('Authorization', authorizationHeader);     
                            request1.setHeader('content-type', 'application/json');
                            
                            HttpResponse response1;
                            if(!Test.isRunningTest()){
                                response1 = httpProtocol1.send(request1);
                                statusCode = response1.getStatusCode();
                                body = response1.getBody();
                            } else {
                                response1 = new HttpResponse();
                                statusCode = 200;
                                body = '{"inventory_levels":[{"inventory_item_id":33529807929462,"location_id":11007307,"available":12,"updated_at":"2021-03-01T14:46:05-05:00","admin_graphql_api_id":"gid://shopify/InventoryLevel/1674123?inventory_item_id=33529807929462"}]}';
                            }
                            system.debug('statusCode:' + String.valueOf(statusCode)); 
                            System.debug('body:' + body);
                            
                            if(statusCode == 200) {
                                shopifyInventoryLevels sInvLevels = (shopifyInventoryLevels)JSON.deserialize(body, shopifyInventoryLevels.class);
                                if(sInvLevels != NULL && sInvLevels.inventory_levels != NULL && sInvLevels.inventory_levels.size() > 0 && sInvLevels.inventory_levels[0].location_id != NULL) {
                                    
                                    UpdateInv.inventory_item_id = sv.inventory_item_id;
                                    UpdateInv.location_id = sInvLevels.inventory_levels[0].location_id;
                                    UpdateInv.available = inventoryCnt;
                                    system.debug('UpdateInv:' + UpdateInv);
                                    
                                    // Update Inventory
                                    endpoint = 'https://euphebe-shop.myshopify.com/admin/inventory_levels/set.json';
                                    system.debug('endpoint:' + endpoint);
                                    
                                    Http httpProtocol2 = new Http();
                                    HttpRequest request2 = new HttpRequest();
                                    
                                    String jsonBody = JSON.serialize(UpdateInv); 
                                    system.debug('jsonBody:' + jsonBody);        
                                    request2.setBody(jsonBody);
                                    
                                    request2.setEndPoint(endpoint);
                                    request2.setMethod('POST');        
                                    request2.setHeader('Authorization', authorizationHeader);     
                                    request2.setHeader('content-type', 'application/json');
                                    
                                    HttpResponse response2;
                                    if(!Test.isRunningTest()){
                                        response2 = httpProtocol1.send(request2);
                                        statusCode = response1.getStatusCode();
                                    } else {
                                        response2 = new HttpResponse();
                                        statusCode = 200;
                                    }
                                    system.debug('statusCode:' + String.valueOf(statusCode));                                     
                                    
                                }                            
                            }
                        }
                    }
                } else {
                    body = '{}';
                }
            }         
        }
    }
    
    public static void replaceMealItems(String orderId, List<Meal_Line_Item__c> lstMealItems) {

        List<Meal_Line_Item__c> lstMealItemsRemove = [Select Id, Name, EOrder__c, Meal__c, Quantity__c, Meal_Name__c, Shopify_ID__c from Meal_Line_Item__c where EOrder__c = :orderId];
        System.debug('Remove Meals lstMealItemsRemove:' + lstMealItemsRemove);
            
        // Remove Meals From Order
        Map<String,Integer> mapMeals = new Map<String,Integer>();
        for(Meal_Line_Item__c mli :lstMealItemsRemove) {
            Integer getMeal = mapMeals.get(mli.Meal__c);
            Integer quant = Integer.ValueOf(mli.Quantity__c);
            if(getMeal != NULL) {
                System.debug('found getMeal:' + getMeal);
                getMeal = getMeal + quant;
                System.debug('update getMeal:' + getMeal);
                mapMeals.put(String.ValueOf(mli.Meal__c), getMeal);
            } else {
                mapMeals.put(String.ValueOf(mli.Meal__c),quant);
            }
        }
        System.debug('mapMeals:' + mapMeals);
        
        // Remove Items from Order
        delete lstMealItemsRemove;
        
        // Add Meals to Order
        for(Meal_Line_Item__c mli :lstMealItems) {
            // Blank out ID to insert
            mli.Id = null;
            Integer getMeal = mapMeals.get(mli.Meal__c);
            Integer quant = Integer.ValueOf(mli.Quantity__c);
            if(getMeal != NULL) {
                System.debug('found getMeal:' + getMeal);
                getMeal = getMeal - quant;
                System.debug('update getMeal:' + getMeal);
                mapMeals.put(String.ValueOf(mli.Meal__c), getMeal);
            } else {
                mapMeals.put(String.ValueOf(mli.Meal__c),(quant*-1));
            }
        }
        System.debug('mapMeals:' + mapMeals);
        
        updateMealInventory(mapMeals, 0, true);
        
        // Add meals to order
        insert lstMealItems;
    }

    
    // Change Ship Date based on Shipment's new Schedule Date
    public static void changeShipDate(String shipmentId) {
        try{
            string suggesticId = '';
            String deliveryDate;
            List<Shipment__c> lstShip = [select Id, Scheduled_Date__c, Shipping_Service_Type__c, Opportunity__c from Shipment__c where ID = :shipmentId];
            
            if(lstShip != NULL && lstShip.size() > 0) {
                Shipment__c ship = lstShip[0];
                List<Opportunity> lstOpp = [select Id, Ship_Date__c,AccountId,Shipment_Date__c, Delivery_Date__c, Is_Custom__c, Affiliate_Is_First_Order__c from Opportunity where Id = :ship.Opportunity__c];
                System.debug('lstOpp: ' + lstOpp);
                
                if(lstOpp != NULL && lstOpp.size() > 0) {
                    Opportunity opp = lstOpp[0];
                    //opp.Ship_Date__c = ship.Scheduled_Date__c;
                    Date OldShipDate =  opp.Shipment_Date__c;
                    opp.Shipment_Date__c = ship.Scheduled_Date__c;              
                    
                    if(ship.Shipping_Service_Type__c != NULL && ship.Shipping_Service_Type__c.length() > 0) {
                        String firstChar = ship.Shipping_Service_Type__c.left(1);
                        Integer delta = Integer.valueOf(firstChar);
                        System.debug('delta: ' + delta);
                        //opp.Delivery_Date__c = opp.Ship_Date__c.addDays(delta);
                       //ship.Delivery_Date__c = opp.Ship_Date__c.addDays(delta);
                        opp.Delivery_Date__c = ship.Scheduled_Date__c.addDays(delta);
                        ship.Delivery_Date__c = ship.Scheduled_Date__c.addDays(delta);
                        //Check campaign accounts 
                        Map<String,Campaign_Account__c> campaignobjMap = new Map<String,Campaign_Account__c>();
                        for(Campaign_Account__c ca : [select id,name,Euphebe_Campaign__c,Euphebe_Campaign__r.name,Start_Date__c,Account__c from Campaign_Account__c where Account__c =:opp.AccountId AND (Euphebe_Campaign__r.name='New ZJ Coach 28 Days' OR Euphebe_Campaign__r.name='Day of UPS' OR Euphebe_Campaign__r.name='Day Before UPS') and Start_Date__c !=null order by Start_Date__c desc]){
                            if(!campaignobjMap.containsKey(ca.Euphebe_Campaign__r.name)){
                                campaignobjMap.put(ca.Euphebe_Campaign__r.name,ca);
                            }
                        } 
                        List<Campaign_Account__c> caccList = new List<Campaign_Account__c>(); 
                        for(Euphebe_Campaign__c ec : [select id,name from Euphebe_Campaign__c where Name ='New ZJ Coach 28 Days' OR Name='Day of UPS' OR Name='Day Before UPS']){
                            Campaign_Account__c cacc = new Campaign_Account__c();
                            Date dt = system.today();
                            if(ec.Name == 'New ZJ Coach 28 Days'){
                                if(campaignobjMap.containsKey(ec.Name) && campaignobjMap.get(ec.Name).Start_Date__c > dt){
                                    cacc.id=campaignobjMap.get(ec.Name).id;
                                    cacc.Start_Date__c = opp.Delivery_Date__c;
                                    caccList.add(cacc);
                                }else if(ship.Scheduled_Date__c < OldShipDate){
                                    cacc.Name='New ZJ Coach 28 Days / '+Account.Name;
                                    cacc.Euphebe_Campaign__c = ec.id;
                                    cacc.Account__c = opp.AccountId;
                                    cacc.Recipient_Email_Address__c = opp.Account.Email__c;
                                    cacc.Start_Date__c = opp.Delivery_Date__c;
                                    caccList.add(cacc);                                 
                                }
                            }else if(ec.Name == 'Day of UPS'){
                                if(campaignobjMap.containsKey(ec.Name) && campaignobjMap.get(ec.Name).Start_Date__c > dt){
                                    cacc.id=campaignobjMap.get(ec.Name).id;
                                    cacc.Start_Date__c = ship.Scheduled_Date__c;
                                    caccList.add(cacc);
                                }else if(ship.Scheduled_Date__c < OldShipDate && ship.Scheduled_Date__c > dt){
                                    cacc.Name='Day of UPS / '+Account.Name;
                                    cacc.Euphebe_Campaign__c = ec.id;
                                    cacc.Account__c = opp.AccountId;
                                    cacc.Recipient_Email_Address__c = opp.Account.Email__c;
                                    cacc.Start_Date__c = ship.Scheduled_Date__c;
                                    caccList.add(cacc);
                                }   
                            }else if(ec.Name == 'Day Before UPS'){
                                if(campaignobjMap.containsKey(ec.Name) && campaignobjMap.get(ec.Name).Start_Date__c > dt){
                                    cacc.id=campaignobjMap.get(ec.Name).id;
                                    cacc.Start_Date__c = ship.Scheduled_Date__c.adddays(-1);
                                    caccList.add(cacc);
                                }else if(ship.Scheduled_Date__c > dt.adddays(1)){
                                    cacc.Name='Day Before / '+Account.Name;
                                    cacc.Euphebe_Campaign__c = ec.id;
                                    cacc.Account__c = opp.AccountId;
                                    cacc.Recipient_Email_Address__c = opp.Account.Email__c;
                                    cacc.Start_Date__c = ship.Scheduled_Date__c.adddays(-1); 
                                    caccList.add(cacc);
                                }
                            }
                            
                        }
                        if((opp.AccountId!=null && opp.Account.Suggestic_ID__c!=null && opp.Delivery_Date__c!=null) || Test.isRunningTest()){
                            suggesticId = opp.Account.Suggestic_ID__c;
                            if(opp.Delivery_Date__c != NULL) {
                                Datetime dts = DateTime.newInstance(opp.Delivery_Date__c.year(), opp.Delivery_Date__c.month(), opp.Delivery_Date__c.day());
                                deliveryDate = dts.format('yyyy-MM-dd');                                                    
                            }
                            List<API_Request__c> apiList = new List<API_Request__c>();
                            SuggesticClass.setDeliveryDate(suggesticId,deliveryDate,apiList);
                        }
                        if(caccList.size()>0){
                            upsert caccList;
                        }
                        
                        // Fix Meals if Chef Menu                    
                        if(opp.Is_Custom__c == False) {
                            List<Meal_Line_Item__c> lstMealItems = new List<Meal_Line_Item__c>();
                            List<Meal__c> lstMeals = computeChefMeals(opp.Delivery_Date__c, opp.Affiliate_Is_First_Order__c);
                            System.debug('computeChefMeals: ' + lstMeals);
                            
                            for(Meal__c m :lstMeals) {
                                Meal_Line_Item__c mli = new Meal_Line_Item__c();
                                mli.Name = m.Name;
                                mli.EOrder__c = opp.Id;
                                mli.Meal__c = m.Id;
                                mli.Quantity__c = 1;
                                mli.Shopify_ID__c = m.Shopify_ID__c;
                                
                                System.debug('Add mli: ' + mli);
                                lstMealItems.add(mli);
                            }
                            replaceMealItems(opp.Id, lstMealItems);
                        }
                        
                        System.debug('update opp: ' + opp);
                        update opp;
                        
                        System.debug('update ship: ' + ship);
                        update ship;
                        
                    }                
                }
            }
        }catch(exception e){
            system.debug(e.getmessage() +' Line No: '+e.getLineNumber()); 
        }
    }

    
    public static void updateMealInventory(MAP<String,Integer> mapMealItems, Integer tryCount, Boolean isFuture) {
    
    
        System.debug('updateMealInventory mapMealItems:' + mapMealItems); 
        System.debug('updateMealInventory tryCount:' + tryCount);        
    
        try {
            List<Meal__c> lstMeals = [select id, Shopify_ID__c, Inventory__c from Meal__c where id = :mapMealItems.keySet() for update];
            System.debug('lstMeals:' + lstMeals);
            
            for(Meal__c pm :lstMeals) {
                Integer fndMealCnt = mapMealItems.get(pm.Id);
                System.debug('fndMealCnt:' + fndMealCnt);
                System.debug('pm.Inventory__c:' + pm.Inventory__c);
                
                if(fndMealCnt != null && pm.Inventory__c != null) {
                                        
                    pm.Inventory__c += fndMealCnt;
                    System.debug('updateShopifyInventory:' + pm.Shopify_ID__c + '~' + pm.Inventory__c);
                    if(isFuture == True){
                        updateShopifyInventory(pm.Shopify_ID__c, Integer.valueOf(pm.Inventory__c));
                    } else{
                        updateShopifyInventoryNotFuture(pm.Shopify_ID__c, Integer.valueOf(pm.Inventory__c));
                    }
                }   
            }
            update lstMeals;
                
        }
        catch(DMLException ex) {
            if(ex.getMessage().contains('UNABLE_TO_LOCK_ROW') && tryCount < 3) {
                tryCount++;
                updateMealInventory(mapMealItems, tryCount, isFuture);
            }
        }
    }
        
    public static List<String> computeUpcomingMondays(string product) {
        
        system.debug('product : ' + product);
        
        // Get Alternate Shipping Date
        List<Alternate_Shipping_Days__c> altDays = Alternate_Shipping_Days__c.getall().values();
        map<Date,Date> ampAltDays = new map<Date,Date>();
        for(Alternate_Shipping_Days__c altd :altDays) {
            ampAltDays.put(altd.Alt_Ship_Date__c, altd.Ship_Date__c);
        }

        // Get Black Out Shipping Dates              
        List<Black_Out_API_Shipping_Dates__c> blackDays = Black_Out_API_Shipping_Dates__c.getall().values();
        map<Date,Date> mapBackDays = new map<Date,Date>();
        for(Black_Out_API_Shipping_Dates__c btd :blackDays) {
            mapBackDays.put(btd.Ship_Date__c, btd.Ship_Date__c);
        }

        // Get Menu Program for Cut Off Day and Time
        List<Menu_Program__c> lstMenuProgs = [select Id, Order_Cut_Off_Day__c, Order_Cut_Off_Time__c, Hour_Offset_GTM_to_Eastern__c from Menu_Program__c where Status__c = 'Active'];
        Integer CutoffDay = 6;
        Integer CutoffHour = 3;
        Integer hourOffset = 4;
        if(lstMenuProgs != NULL && lstMenuProgs.size() > 0 && lstMenuProgs[0].Order_Cut_Off_Day__c != NULL && lstMenuProgs[0].Order_Cut_Off_Time__c != NULL) {        
            Menu_Program__c prog = lstMenuProgs[0];
            if(prog.Order_Cut_Off_Day__c == 'Monday') {
                CutoffDay = 0;
            } else if(prog.Order_Cut_Off_Day__c == 'Tuesday') {
                CutoffDay = 1;
            } else if(prog.Order_Cut_Off_Day__c == 'Wednesday') {
                CutoffDay = 2;
            } else if(prog.Order_Cut_Off_Day__c == 'Thursday') {
                CutoffDay = 3;
            } else if(prog.Order_Cut_Off_Day__c == 'Friday') {
                CutoffDay = 4;
            } else if(prog.Order_Cut_Off_Day__c == 'Saturday') {
                CutoffDay = 5;
            } else if(prog.Order_Cut_Off_Day__c == 'Sunday') {
                CutoffDay = 6;
            }
            if(prog.Hour_Offset_GTM_to_Eastern__c != NULL) {
                hourOffset = Integer.ValueOf(prog.Hour_Offset_GTM_to_Eastern__c);    
            }
            String[] hourParts = prog.Order_Cut_Off_Time__c .split(':');
            if(hourParts.size() > 0) {
                CutoffHour = Integer.ValueOf(hourParts[0]);
            }
            
        }
        
        system.debug('CutoffDay : ' + CutoffDay );
        system.debug('CutoffHour : ' + CutoffHour  );
        system.debug('hourOffset : ' + hourOffset  );

        // Calc Ship Dates
        Date tdy = Date.today();
        DateTime now = DateTime.Now();
        Integer mondayCnt = 0;
        Date monday = Date.newInstance(1900, 1, 1);
        
        Integer dayOfWeek = Math.mod(monday.daysBetween(tdy), 7);
        Integer nowHour = now.Hour();
        nowHour = nowHour - hourOffset;        
        
        system.debug('dayOfWeek : ' + dayOfWeek );
        system.debug('nowHour : ' + nowHour );
        
        // If after cut off, Skip to next week
        Boolean skip = false;
        if(dayOfWeek > CutoffDay || (dayOfWeek == CutoffDay && nowHour >= CutOffHour)) {
            skip=true;
        }
        
        List<String> mondays = new List<String>();
        while(mondayCnt < 4) {        
        
            // Add a day
            tdy = tdy.addDays(1);
            
            // If a Monday
            if(Math.mod(monday.daysBetween(tdy), 7) == 0) {
                        
                // Check Black Out Dates for sampler
                Date fndBlk;
                if(product == 'sampler') {
                    fndBlk = mapBackDays.get(tdy);    
                }
                
                // If not Skiped due to cut off and not a black out date
                if(!skip && fndBlk == NULL) {
                
                    // Check Alternate Days for this Monday
                    Date fndAlt = ampAltDays.get(tdy);
                    if(fndAlt != NULL) {
                        tdy = fndAlt;
                    }
                    // Add to Mondays List                    
                    mondays.add(DateTime.newInstance(tdy.year(),tdy.month(),tdy.day()).format('MM/dd/yyyy'));
                    
                    mondayCnt++;                    
                } else {
                    skip=false;
                }
            }
        }
        system.debug('mondays : ' + mondays);
        return mondays;
    }
    
    
    public static List<Meal__c> computeSeasonalMeals(Boolean isAffiateGift) {        
        List<Product_Meal__c> lstProdMeals = [select Id, Name, Meal__c from Product_Meal__c where Product__r.ProductCode = 'OTSEA'];
        Set<String> mealIds = new Set<String>();
        for(Product_Meal__c pm :lstProdMeals) {
            mealIds.add(pm.Meal__c);
        }
        System.debug('computeSeasonalMeals mealIds:' + mealIds);
        
        List<Meal__c> lstMeals;
        if(isAffiateGift) {
            lstMeals = [select Id, Name, Shopify_ID__c, Allergens__c, Calories_Per_Serving__c, Cuisine__c, Description__c, Image_URL__c, Proteins__c, Type__c from Meal__c where Status__c = 'Active' AND (id in :mealIds OR Affiliate_Gift__c = True)];            
        } else {
            lstMeals = [select Id, Name, Shopify_ID__c, Allergens__c, Calories_Per_Serving__c, Cuisine__c, Description__c, Image_URL__c, Proteins__c, Type__c from Meal__c where Status__c = 'Active' AND id in :mealIds];    
        }
        
        System.debug('lstMeals:' + lstMeals);
        
        return lstMeals;
    }
    
    public static List<Meal__c> computeSamplerMeals(Boolean isAffiateGift) {                

        List<Meal__c> lstMeals;
        if(isAffiateGift) {
            lstMeals = [select Id, Name, Shopify_ID__c, Allergens__c, Calories_Per_Serving__c, Cuisine__c, Description__c, Image_URL__c, Proteins__c, Type__c from Meal__c where Status__c = 'Active' AND (Zipongo_Sampler__c = True OR Affiliate_Gift__c = True)];
        } else {
            lstMeals = [select Id, Name, Shopify_ID__c, Allergens__c, Calories_Per_Serving__c, Cuisine__c, Description__c, Image_URL__c, Proteins__c, Type__c from Meal__c where Status__c = 'Active' AND Zipongo_Sampler__c = True];
        }
        System.debug('computeSamplerMeals lstMeals:' + lstMeals);
        
        return lstMeals;
    }

    
    
    public static List<Meal__c> computeChefMeals(Date deliveryDate, Boolean isAffiateGift) {
        List<Meal__c> lstMeals = new List<Meal__c>();

        List< Menu_Program__c > lstMenuProg = [select Id, Name, Start_Date__c, Order_Cut_Off_Day__c, Order_Cut_Off_Time__c, Number_of_Cycles__c from Menu_Program__c where Status__c = 'Active'];
        System.debug('lstMenuProg:' + lstMenuProg);
        MAP<String, Menu_Program__c> mapMenuProg = new MAP<String, Menu_Program__c>();
        for(Menu_Program__c m :lstMenuProg) {
            mapMenuProg.put(m.Id, m);
        }
        
        List<Menu__c> lstMenu = [select Id, Name, Cycle__c, Menu_Program__c from Menu__c where Status__c = 'Active' AND Menu_Program__c  in :lstMenuProg];
        System.debug('lstMenu:' + lstMenu);
        MAP<String, Menu__c> mapMenu = new MAP<String, Menu__c>();
        for(Menu__c m :lstMenu) {
            mapMenu.put(m.Id, m);
        }
         
        List< Menu_Entry__c > lstMenuEntries = [select Id, Name, Meal__c , Menu__c from Menu_Entry__c where Menu__c in :lstMenu Order By Day_Count__c, Meal_Type__c];
        System.debug('lstMenuEntries:' + lstMenuEntries);
        MAP<String, Menu_Entry__c> MenuEntry = new MAP<String, Menu_Entry__c>();
        for(Menu_Entry__c m :lstMenuEntries) {
            MenuEntry.put(m.Id, m);
        }

        List<Meal__c> lstMeal = [select Id, Name, Shopify_ID__c, Allergens__c, Calories_Per_Serving__c, Cuisine__c, Description__c, Image_URL__c, Proteins__c, Type__c, Affiliate_Gift__c from Meal__c where Status__c = 'Active'];        
        System.debug('lstMeal:' + lstMeal);
        
        MAP<String, Meal__c> mapMeal = new MAP<String, Meal__c>();
        List<Meal__c> affMeals = new List<Meal__c>();
        for(Meal__c m :lstMeal) {
            mapMeal.put(m.Id, m);
            if(m.Affiliate_Gift__c) {
                affMeals.add(m);
            }
        }        
        
        if(lstMenuProg != NULL && lstMenuProg.size() > 0) {
            Menu_Program__c fndMenuProgram = lstMenuProg[0];
            
            // Find correct Menu based on delivery date            
            date tdy = deliveryDate;
            System.debug('Delivery Date:' + tdy);
            
            // Set Program Start to to drive correct cycle !!!
            integer weekNum = fndMenuProgram.Start_Date__c.daysBetween(tdy)/7;
            System.debug('Week num:' + weekNum);
            
            Integer numOfCycles = Integer.valueOf(fndMenuProgram.Number_of_Cycles__c);
            
            Integer boxNum = (MATH.mod(weekNum, numOfCycles)) + 1;
            System.debug('boxNum:' + boxNum);
            
            // For now make it 1 where I have data
            //boxNum = 1;
            
            for(Menu__c m :lstMenu) {
                
                System.debug('Menu Loop:' + m);                            
                
                if(m.Menu_Program__c == fndMenuProgram.Id && m.Cycle__c == boxNum) {
                    
                    System.debug('Found Menu:' + m);
                    
                    // Add details for each Menu Entry
                    for(Menu_Entry__c me :lstMenuEntries) {
                        
                        System.debug('Menu_Entry Loop:' + me);
                        
                        if(me.Menu__c == m.Id) {
                            
                            System.debug('Found Menu Entry:' + me);
                            
                            Meal__c fndMeal = mapMeal.get(me.Meal__c);
                            System.debug('fndMeal:' + fndMeal);
                            
                            if(fndMeal != NUll) {
                                lstMeals.add(fndMeal);
                            }
                        }
                    }
                }
            }
            if(isAffiateGift) {
                for(Meal__c m :affMeals) {
                    lstMeals.add(m);
                }
            }
        }
        
        return lstMeals;
    }
        
    public static void updateInventory(String orderId, Boolean isFuture) {

        list<Meal_Line_Item__c> mealItems = [select Id, Quantity__c, Meal__c, EOrder__c from Meal_Line_Item__c where EOrder__c = :orderId];
        System.debug('mealItems:' + mealItems);
        
        MAP<String,Integer> mapMealItems = new  MAP<String,Integer>();
        for(Meal_Line_Item__c mi :mealItems) {
            if(mi.Quantity__c != NULL) {
                Integer fndMealCnt = mapMealItems.get(mi.Meal__c);
                if(fndMealCnt != null) {
                    fndMealCnt -= Integer.valueOf(mi.Quantity__c);
                    mapMealItems.put(mi.Meal__c, fndMealCnt);
                } else {
                    mapMealItems.put(mi.Meal__c, Integer.valueOf(mi.Quantity__c*-1));
                }
            }
        }
        System.debug('mapMealItems:' + mapMealItems);
        
        
        // Use locking meal update
        updateMealInventory(mapMealItems, 0, isFuture);
                
        /*
        list<Meal__c> lstMeals = [select Id, Inventory__c, Shopify_ID__c from Meal__c where Id in :mapMealItems.keySet()];
        System.debug('lstMeals:' + lstMeals);
        
        
        for(Meal__c pm :lstMeals) {
            Integer fndMealCnt = mapMealItems.get(pm.Id);
            System.debug('fndMealCnt:' + fndMealCnt);
            System.debug('pm.Inventory__c:' + pm.Inventory__c);
            
            if(fndMealCnt != null) {
                
               pm.Inventory__c -= fndMealCnt;
               System.debug('updateShopifyInventory:' + pm.Shopify_ID__c + '~' + pm.Inventory__c);
               updateShopifyInventory(pm.Shopify_ID__c, Integer.valueOf(pm.Inventory__c));
            }   
        }
        update lstMeals;
        */
    }
        
    public static void linkMeals(String OppID, Boolean isAffiateGift) {
        LIST<Meal_Line_Item__c> mealItems = [select id, Shopify_ID__c, Meal__c from Meal_Line_Item__c where EOrder__c = :OppID];
        if(mealItems != null && mealItems.size() > 0) {
            LIST<Meal__c> meals = [select Id, Shopify_ID__c from Meal__c where Status__c = 'Active' AND Shopify_ID__c != null];
            if(meals != null && meals.size() > 0) {
                MAP<String,String> mapMeals = new MAP<String,String>();
                for(Meal__c m :meals) {
                    mapMeals.put(m.Shopify_ID__c,m.Id);
                }
                for(Meal_Line_Item__c m :mealItems) {
                    String mid = mapMeals.get(m.Shopify_ID__c);
                    if(mid != null) {
                        m.Meal__c = mid;
                    }
                }
                update mealItems;
            }
        }
    }
    
    public static void linkOrderMeals(String orderId, String strIsCustom, String strDeliveryDate) {
        
        Boolean isCustom = Boolean.valueOf(strIsCustom);
        Date deliveryDate = Date.parse(strDeliveryDate);
        
        System.debug('orderId:' + orderId);
        System.debug('isCustom:' + isCustom);
        System.debug('deliveryDate:' + deliveryDate);
        
        String computeChefMeals = Label.Compute_Chef_Meals;
        
        // Is Seasonal?
        Boolean isSeasonal=False;
        Boolean isSampler=False;
        Boolean isAffiateGift=False;
        List<Opportunity> lstOpp = [select Id, name, Main_Product_Code__c, Affiliate_Is_First_Order__c from Opportunity where Id = :orderId];
        System.debug('lstOpp :' + lstOpp );
        
        if(lstOpp != NULL && lstOpp.size() > 0 && lstOpp[0].Main_Product_Code__c == 'OTSEA') {
            isSeasonal=True;
        }
        if(lstOpp != NULL && lstOpp.size() > 0 && lstOpp[0].Main_Product_Code__c == 'ZPSAM') {
            isSampler=True;
        }
        if(lstOpp != NULL && lstOpp.size() > 0 && lstOpp[0].Affiliate_Is_First_Order__c == True) {
            isAffiateGift=True;
        }
        System.debug('isSeasonal:' + isSeasonal);
        System.debug('isSampler:' + isSampler);
        System.debug('isAffiateGift:' + isAffiateGift);
        
        if((!isCustom || isSeasonal || isSampler) && computeChefMeals != NULL && computeChefMeals == 'True') {
             
             // Add Chef Meal Items to Order
             LIST<Meal_Line_Item__c> mealItems = new LIST<Meal_Line_Item__c>();
             
             List<Meal__c> lstMeals;
             if(isSeasonal) {
                lstMeals = computeSeasonalMeals(isAffiateGift); 
             } else if(isSampler) {
                lstMeals = computeSamplerMeals(isAffiateGift); 
             } else {
                lstMeals = computeChefMeals(deliveryDate, isAffiateGift);    
             }
             
             System.debug('computeChefMeals:' + lstMeals);
            
             for(Meal__c m :lstMeals) {
                 Meal_Line_Item__c mi = new Meal_Line_Item__c();
                 mi.Name = m.Name;
                 mi.EOrder__c = orderId;
                 mi.Quantity__c = 1;
                 mi.Meal__c = m.Id;
                 mi.Shopify_ID__c = m.Shopify_ID__c;
                 mealItems.add(mi);
             }
             System.debug('mealItems:' + mealItems);
             insert mealItems;

        } else {
        //if(isCustom) {
            linkMeals(orderId, isAffiateGift);
        }
    }
    
    public static void putMealsBackIntoInventory(String orderId, String strIsCustom) {
        
        System.debug('orderId:' + orderId);
        Boolean isCustom = Boolean.valueOf(strIsCustom);
        
        String computeChefMeals = Label.Compute_Chef_Meals;
        
        if((computeChefMeals != NULL && computeChefMeals == 'True') || isCustom) {

            list<Meal_Line_Item__c> mealItems = [select Id, Quantity__c, Meal__c, EOrder__c from Meal_Line_Item__c where EOrder__c = :orderId];
            System.debug('mealItems:' + mealItems);
            
            MAP<String,Integer> mapMealItems = new  MAP<String,Integer>();
            for(Meal_Line_Item__c mi :mealItems) {
                if(mi.Quantity__c != NULL) {
                    Integer fndMealCnt = mapMealItems.get(mi.Meal__c);
                    if(fndMealCnt != null) {
                        fndMealCnt += Integer.valueOf(mi.Quantity__c);
                        mapMealItems.put(mi.Meal__c, fndMealCnt);
                    } else {
                        mapMealItems.put(mi.Meal__c, Integer.valueOf(mi.Quantity__c));
                    }
                }
            }
            System.debug('mapMealItems:' + mapMealItems);
            
            
            // Use locking meal update
            updateMealInventory(mapMealItems, 0, true);
            
            /*
            List<Meal__c> lstUpdateMeals = [Select Id, Name, Inventory__c, Inventory_Sync__c from Meal__c where Id in :mapMeals.keySet()];
            System.debug('lstUpdateMeals:' + lstUpdateMeals);
            
            // Remove meals from inventory
            for(Meal__c mo :lstUpdateMeals) {
                Decimal getQuantity = mapMeals.get(mo.Id);
                if(getQuantity != NULL && getQuantity != 0 && mo.Inventory__c != NULL) {
                    mo.Inventory__c += getQuantity;
                    mo.Inventory_Sync__c = True;
                }
            }
            System.debug('lstUpdateMeals after Update:' + lstUpdateMeals);
            update lstUpdateMeals;
            */
        }
    }

    
    public static void calcInventoryProjection(String strShippingDate) {
        Date shippingDate = Date.parse(strShippingDate);
        List<Opportunity> lstOpp = [select Id, Name, Is_Custom__c, Is_Replacement__c, Is_Recharge__c, Main_Product_Code__c from Opportunity where Ship_Date__c = :shippingDate and StageName = 'Closed Won' and Is_Test__c = False];
        List<Inventory_Projection__c> lstInvProj = [select Id, Name, Chef_Order_Count__c, Custom_Order_Count__c, Computed_Total__c from Inventory_Projection__c where Shipping_Date__c = :shippingDate];
        
        if(lstInvProj != null && lstInvProj.size() > 0) {
            lstInvProj[0].Custom_Order_Count__c=0;
            lstInvProj[0].Chef_Order_Count__c=0;
            lstInvProj[0].Recharge_Actual__c=0;
            
            lstInvProj[0].Reboot_Count__c=0;
            lstInvProj[0].QuickStart_Count__c=0;
            lstInvProj[0].Subscription_New_Count__c=0;
            lstInvProj[0].Custom_Replacement_Count__c=0;
            
            
            for(Opportunity opp :lstOpp) {
                
                if(opp.Is_Recharge__c == True) {
                    lstInvProj[0].Recharge_Actual__c++;
                } else {
                    if(opp.Is_Custom__c == True && opp.Is_Replacement__c == False) {
                        lstInvProj[0].Custom_Order_Count__c++;
                    } else if(opp.Is_Custom__c == True && opp.Is_Replacement__c == True) {
                        lstInvProj[0].Custom_Replacement_Count__c++;
                    } else if(opp.Is_Custom__c == False) {
                        lstInvProj[0].Chef_Order_Count__c++;
                        
                        if(opp.Main_Product_Code__c == 'E28ZJ') {
                            lstInvProj[0].Reboot_Count__c++;    
                        } else if(opp.Main_Product_Code__c == 'QSZJ') {
                            lstInvProj[0].QuickStart_Count__c++;    
                        } else if(opp.Main_Product_Code__c == 'MOZJ') {
                            lstInvProj[0].Subscription_New_Count__c++;  
                        }
                        
                        
                    }   
                }
            }
            update lstInvProj;
        }        
    }
    
    public static void updateMealPlan() {
        
        List<Meal__c> lstMeals = [select ID, Menu_Name__c from Meal__c];
        MAP<String,Meal__c> mapMeals = new MAP<String,Meal__c>();
        for(Meal__c m :lstMeals) {
            mapMeals.put(m.ID, m);
            m.Menu_Name__c = null;
        }
        
        LIST<Menu_Entry__c> lstMenuEntries = [select Id, Name, Meal__c, Menu__r.Name from Menu_Entry__c where Menu__c != NULL];
        for(Menu_Entry__c me :lstMenuEntries) {
            Meal__c fndMeal = mapMeals.get(me.Meal__c);
            if(fndMeal != NULL) {
                fndMeal.Menu_Name__c = me.Menu__r.Name;
            }
        }
        update lstMeals;
        
    }
    
    public static void updateLastMealUpdatedDate() {
        List<IntegrationDateTimes__c> lstCust = [select LastDateTime__c from IntegrationDateTimes__c where Name = 'MealLastUpdated'];
        system.debug('lstCust' + lstCust);     
        if(lstCust != NULL && lstCust.size() > 0) {
            lstCust[0].LastDateTime__c = DateTime.Now();    
            update lstCust;
        }
    }
    
    @InvocableMethod(label='shopifyMethods' description='Operate Shopify Class Methods.')
    public static void shopifyMethods(List<List<String>> inputParams) {  
        
        System.debug('inputParams:' + inputParams);
        
        String method;
        String param1;
        String param2;
        String param3;
        String param4;
        
        for(List<String> ids :inputParams) {
        
            //List<String> ids = inputParams[0];
            
            if(!ids.isEmpty()){
                Integer cnt=0;
                for(String idVal :ids) {
                    if(cnt==0)
                        method = idVal;
                    else if(cnt==1)
                        param1 = idVal;
                    else if(cnt==2)
                        param2 = idVal;
                    else if(cnt==3)
                        param3 = idVal;
                    else if(cnt==4)
                        param4 = idVal;
                    cnt++;
                }
                System.debug('method:' + method);
                System.debug('param1:' + param1);
                System.debug('param2:' + param2);
                System.debug('param3:' + param3);
                System.debug('param4:' + param4);
                
                if(method == 'sendCarriOrder') {
                    sendCarriOrder(param1, param2);
                } else if(method == 'updateShopifyInventory') {
                    updateShopifyInventory(param1, Integer.valueOf(param2));
                } else if(method == 'updateInventory') {
                    updateInventory(param1, true);
                } else if(method == 'calcInventoryProjection') {
                    calcInventoryProjection(param1);
                } else if(method == 'linkMeals') {
                    linkOrderMeals(param1, param2, param3);
                } else if(method == 'putMealsBackIntoInventory') {
                    putMealsBackIntoInventory(param1, param2);
                } else if(method == 'changeShipDate') {
                    changeShipDate(param1);
                } else if(method == 'updateLastMealUpdatedDate') {
                    updateLastMealUpdatedDate();
                } else if(method == 'updateMealPlan') {
                    updateMealPlan();
                }
                
            }
        }
   
    }        
        
    public static MAP<String,String> defineOrderMap() {
        MAP<String,String> mapOrders = new MAP<String,String>();
        return mapOrders;
    }
    
}