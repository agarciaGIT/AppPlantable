public class Plant_ShipStation_BC {

    public class ss_shipment {
        public String shipmentId;
        public Long orderId;
        public String orderKey;
        public String userId;
        public String customerEmail;
        public String trackingNumber;
    }
    
    public class ss_shipments {
        public List<ss_shipment> shipments;
    }

    public class ss_fulfillment {
        String fulfillmentId;
        Long orderId;
        String orderNumber;
        String userId;
        String customerEmail;
        String trackingNumber;
        String createDate;
        String shipDate;
        String voidDate;
        String deliveryDate;
        String carrierCode;
        String sellerFillProviderId;
        String sellerFillProviderName;
        String fulfillmentProviderCode;
        String fulfillmentServiceCode;
        Decimal fulfillmentFee;
        String voidRequested;
        Boolean voided;
        Boolean marketplaceNotified;
        String notifyErrorMessage;
    }
    
    public class ss_fulfillments {
        public List<ss_fulfillment> fulfillments;
    }
    
    public class ss_dimensions {
        String units;
        Decimal length;
        Decimal width;
        Decimal height;
    }
        
    public class ss_weight {
        Decimal value;
        String units;
        Long WeightUnits;
    }

    public class ss_insuranceOptions {
        String provider;
        Boolean insureShipment;
        Decimal insuredValue;
    }
    
    public class ss_internationalOptions {
        String contents;
        String customsItems;
        String nonDelivery;
    }

    public class ss_mergedIds {
    }
    
    public class ss_advancedOptions {
        Long warehouseId;
        Boolean nonMachinable;
        Boolean saturdayDelivery;
        Boolean containsAlcohol;
        Boolean mergedOrSplit;
        //List<ss_mergedIds> mergedIds;
        String parentId;
        Long storeId;
        String customField1;
        String customField2;
        String customField3;
        String source;
        String billToParty;
        String billToAccount;
        String billToPostalCode;
        String billToCountryCode;
        Long billToMyOtherAccount;        
    }

    public class ss_options {
    }
    
    public class ss_item {
        //Long orderItemId;
        String lineItemKey;
        String sku;
        String name;
        String imageUrl;
        String weight;
        Long quantity;
        Decimal unitPrice;
        Decimal taxAmount;
        Decimal shippingAmount;
        String warehouseLocation;
        //List<ss_options> options;
        //Long productId;
        String fulfillmentSku;
        Boolean adjustment;
        String upc;
        //String createDate;
        //String modifyDate;
    }
    
    public class ss_address {
        string name;
        string company;
        string street1;
        string street2;
        string street3;
        string city;
        string state;
        string postalCode;
        string country;
        string phone;
        Boolean residential;
        string addressVerified;     
    }
    
    public class ss_order_send {
        string orderNumber;
        //string orderKey;      
        string orderDate;
        string paymentDate;
        string shipByDate;
        string orderStatus;
        //string customerId;
        string customerUsername;
        string customerEmail;
        ss_address billTo;
        ss_address shipTo;
        List<ss_item> items;
        Decimal orderTotal;
        Decimal amountPaid;
        Decimal taxAmount;
        Decimal shippingAmount;
        String customerNotes;
        String internalNotes;
        Boolean gift;
        String giftMessage;
        String paymentMethod;
        String requestedShippingService;
        String carrierCode;
        String serviceCode;
        String packageCode;
        String confirmation;
        String shipDate;
        String holdUntilDate;        
        ss_weight weight;
        ss_dimensions dimensions;
        ss_insuranceOptions insuranceOptions;
        ss_internationalOptions internationalOptions;
        ss_advancedOptions advancedOptions;
        List<string> tagIds;
        String userId;
        Boolean externallyFulfilled;
        String externallyFulfilledBy;
        String externallyFulfilledById;
        String externallyFulfilledByName;
        String labelMessages;
    }
    
    public class ss_order_resp {
        string orderNumber;
        string orderKey;      
        string orderDate;
        string paymentDate;
        string shipByDate;
        string orderStatus;
        string customerId;
        string customerUsername;
        string customerEmail;
        ss_address billTo;
        ss_address shipTo;
        List<ss_item> items;
        Decimal orderTotal;
        Decimal amountPaid;
        Decimal taxAmount;
        Decimal shippingAmount;
        String customerNotes;
        String internalNotes;
        Boolean gift;
        String giftMessage;
        String paymentMethod;
        String requestedShippingService;
        String carrierCode;
        String serviceCode;
        String packageCode;
        String confirmation;
        String shipDate;
        String holdUntilDate;        
        ss_weight weight;
        ss_dimensions dimensions;
        ss_insuranceOptions insuranceOptions;
        ss_internationalOptions internationalOptions;
        ss_advancedOptions advancedOptions;
        List<string> tagIds;
        String userId;
        Boolean externallyFulfilled;
        String externallyFulfilledBy;
        String externallyFulfilledById;
        String externallyFulfilledByName;
        String labelMessages;
    }    

    public class ss_orders {
        public List<ss_order_resp> orders;
    }
    
    public static ss_shipments getWebHookData(String endpoint) {
        System.debug('endpoint:' + endpoint);
        
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        //String endpoint = 'https://ssapi.shipstation.com/orders?orderNumber=' + orderNumber;
        system.debug('endpoint:' + endpoint);
        
        request.setEndPoint(endpoint);
        request.setMethod('GET');        
        String username = Label.ShipStationAPIKey;
        String password = Label.ShipStationAPISecret;
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);     
        request.setHeader('content-type', 'application/json');
        
        //String jsonBody = '{"product": {"id":' + shopifyMealId + ',"status":"' + status + '"}}';
        //request.setBody(jsonBody);
        
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
                body = '{"shipments":[{"shipmentId":53547634,"orderId":123181167,"orderKey":"0bb3facafbee4067a743a78ae594630c","userId":"2e1aa80f-9b60-408c-837e-dea5d906f756","customerEmail":"aomer1@nd.edu","orderNumber":"40071","createDate":"2022-09-01T08:25:55.1530000","shipDate":"2022-09-06","shipmentCost":14.18,"insuranceCost":0.0,"trackingNumber":"1Z30075A0399792139","isReturnLabel":false,"batchNumber":"100035","carrierCode":"ups","serviceCode":"ups_ground","packageCode":"package","confirmation":null,"warehouseId":332246,"voided":false,"voidDate":null,"marketplaceNotified":false,"notifyErrorMessage":null,"shipTo":{"name":"Atalia Omer","company":null,"street1":"824 PARK AVE","street2":"","street3":null,"city":"SOUTH BEND","state":"IN","postalCode":"46616-1338","country":"US","phone":"6172307188","residential":null,"addressVerified":null},"weight":{"value":256.00,"units":"ounces","WeightUnits":1},"dimensions":null,"insuranceOptions":{"provider":null,"insureShipment":false,"insuredValue":0.0},"advancedOptions":{"billToParty":null,"billToAccount":null,"billToPostalCode":null,"billToCountryCode":null,"storeId":392054},"shipmentItems":null,"labelData":null,"formData":null},{"shipmentId":53547635,"orderId":123181180,"orderKey":"d0b82c2e78374e2296ec43d7a31f60d2","userId":"2e1aa80f-9b60-408c-837e-dea5d906f756","customerEmail":"may97us@yahoo.com","orderNumber":"40070","createDate":"2022-09-01T08:25:55.1630000","shipDate":"2022-09-06","shipmentCost":13.20,"insuranceCost":0.0,"trackingNumber":"1Z30075A0396358926","isReturnLabel":false,"batchNumber":"100035","carrierCode":"ups","serviceCode":"ups_ground","packageCode":"package","confirmation":null,"warehouseId":332246,"voided":false,"voidDate":null,"marketplaceNotified":false,"notifyErrorMessage":null,"shipTo":{"name":"Renee Johnson","company":null,"street1":"301 BRIDLE TRL","street2":"","street3":null,"city":"VENETIA","state":"PA","postalCode":"15367-1187","country":"US","phone":"+15027189391","residential":null,"addressVerified":null},"weight":{"value":256.00,"units":"ounces","WeightUnits":1},"dimensions":null,"insuranceOptions":{"provider":null,"insureShipment":false,"insuredValue":0.0},"advancedOptions":{"billToParty":null,"billToAccount":null,"billToPostalCode":null,"billToCountryCode":null,"storeId":392054},"shipmentItems":null,"labelData":null,"formData":null}],"total":2,"page":1,"pages":1}}';
            }
            System.debug('body rep:' + body);
            ss_shipments shipments = (ss_shipments)JSON.deserialize(body, ss_shipments.class);
            System.debug('shipments:' + shipments);
            return shipments;
        }
        
        return null;
    }
    
    
    public static ss_orders getOrder(String orderNumber) {
        System.debug('orderNumber:' + orderNumber);
        
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://ssapi.shipstation.com/orders?orderNumber=' + orderNumber;
        system.debug('endpoint:' + endpoint);
        
        request.setEndPoint(endpoint);
        request.setMethod('GET');        
        String username = Label.ShipStationAPIKey;
        String password = Label.ShipStationAPISecret;
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);     
        request.setHeader('content-type', 'application/json');
        
        //String jsonBody = '{"product": {"id":' + shopifyMealId + ',"status":"' + status + '"}}';
        //request.setBody(jsonBody);
        
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
                body = '{"orders":[{"orderId":112490426,"orderNumber":"39469","orderKey":"39469","orderDate":"2022-07-30T22:24:54.1700000","createDate":"2022-07-30T22:24:54.2670000","modifyDate":"2022-08-04T09:02:25.0730000","paymentDate":null,"shipByDate":"2022-08-08T00:00:00.0000000","orderStatus":"awaiting_shipment","customerId":56976188,"customerUsername":"0038W00001k8cZNQAY","customerEmail":"catherine.hicks@gmail.com","billTo":{"name":"Catherine Hicks","company":null,"street1":null,"street2":"","street3":"","city":null,"state":null,"postalCode":null,"country":null,"phone":"4082305526","residential":null,"addressVerified":null},"shipTo":{"name":"Catherine Hicks","company":null,"street1":"2600 SAN LEANDRO BLVD APT 1712","street2":"","street3":"","city":"SAN LEANDRO","state":"CA","postalCode":"94578-5062","country":"US","phone":"4082305526","residential":true,"addressVerified":"Address validated successfully"},"items":[{"orderItemId":165139316,"lineItemKey":"LI-0749","sku":"E28ZJ","name":"E28 ReBoot New","imageUrl":null,"weight":null,"quantity":1,"unitPrice":175,"taxAmount":0,"shippingAmount":0,"warehouseLocation":null,"options":[],"productId":11271270,"fulfillmentSku":null,"adjustment":false,"upc":null,"createDate":"2022-07-30T22:24:54.17","modifyDate":"2022-07-30T22:24:54.17"},{"orderItemId":165139317,"lineItemKey":"LI-0751","sku":"EShip","name":"Shipping","imageUrl":null,"weight":null,"quantity":1,"unitPrice":0,"taxAmount":0,"shippingAmount":0,"warehouseLocation":null,"options":[],"productId":11069447,"fulfillmentSku":null,"adjustment":false,"upc":null,"createDate":"2022-07-30T22:24:54.17","modifyDate":"2022-07-30T22:24:54.17"}],"orderTotal":175,"amountPaid":0,"taxAmount":0,"shippingAmount":0,"customerNotes":null,"internalNotes":null,"gift":false,"giftMessage":null,"paymentMethod":null,"requestedShippingService":"2","carrierCode":"ups","serviceCode":"ups_2nd_day_air_am","packageCode":"package","confirmation":"none","shipDate":null,"holdUntilDate":null,"weight":{"value":0,"units":"ounces","WeightUnits":1},"dimensions":{"units":"inches","length":12,"width":12,"height":12},"insuranceOptions":{"provider":null,"insureShipment":false,"insuredValue":0},"internationalOptions":{"contents":null,"customsItems":null,"nonDelivery":null},"advancedOptions":{"warehouseId":332246,"nonMachinable":false,"saturdayDelivery":false,"containsAlcohol":false,"mergedOrSplit":false,"mergedIds":[],"parentId":null,"storeId":407069,"customField1":null,"customField2":null,"customField3":null,"source":null,"billToParty":"my_other_account","billToAccount":null,"billToPostalCode":null,"billToCountryCode":null,"billToMyOtherAccount":551255},"tagIds":null,"userId":null,"externallyFulfilled":false,"externallyFulfilledBy":null,"externallyFulfilledById":null,"externallyFulfilledByName":null,"labelMessages":null}],"total":1,"page":1,"pages":1}';
            }
            System.debug('body rep:' + body);
            ss_orders orders = (ss_orders)JSON.deserialize(body, ss_orders.class);
            System.debug('orders:' + orders);
            return orders;
        }
        
        return null;
    }
 
    public static ss_order_resp setOrder(ss_order_send ssOrder, String ssOrderId) {
        ss_order_resp ret;
        System.debug('ssOrder:' + ssOrder);

        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://ssapi.shipstation.com/orders/createorder';
        system.debug('endpoint:' + endpoint);
        
        request.setEndPoint(endpoint);
        request.setMethod('POST');        
        String username = Label.ShipStationAPIKey;
        String password = Label.ShipStationAPISecret;
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);     
        request.setHeader('content-type', 'application/json');
        
        String jsonBody = JSON.serialize(ssOrder);
        if(ssorderid != NULL) {
            ss_order_resp sendSSOrder = (ss_order_resp)JSON.deserialize(jsonBody, ss_order_resp.class);
            sendSSOrder.orderKey = ssOrderId;
            jsonBody = JSON.serialize(sendSSOrder);
        }
        System.debug('jsonBody:' + jsonBody);
        
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
        String respbody;
        if(statusCode == 200) {
            if(!Test.isRunningTest()){
                respbody = response.getBody();
                
            } else {
                respbody = '{"orders":[{"orderId":112490426,"orderNumber":"39469","orderKey":"39469","orderDate":"2022-07-30T22:24:54.1700000","createDate":"2022-07-30T22:24:54.2670000","modifyDate":"2022-08-04T09:02:25.0730000","paymentDate":null,"shipByDate":"2022-08-08T00:00:00.0000000","orderStatus":"awaiting_shipment","customerId":56976188,"customerUsername":"0038W00001k8cZNQAY","customerEmail":"catherine.hicks@gmail.com","billTo":{"name":"Catherine Hicks","company":null,"street1":null,"street2":"","street3":"","city":null,"state":null,"postalCode":null,"country":null,"phone":"4082305526","residential":null,"addressVerified":null},"shipTo":{"name":"Catherine Hicks","company":null,"street1":"2600 SAN LEANDRO BLVD APT 1712","street2":"","street3":"","city":"SAN LEANDRO","state":"CA","postalCode":"94578-5062","country":"US","phone":"4082305526","residential":true,"addressVerified":"Address validated successfully"},"items":[{"orderItemId":165139316,"lineItemKey":"LI-0749","sku":"E28ZJ","name":"E28 ReBoot New","imageUrl":null,"weight":null,"quantity":1,"unitPrice":175,"taxAmount":0,"shippingAmount":0,"warehouseLocation":null,"options":[],"productId":11271270,"fulfillmentSku":null,"adjustment":false,"upc":null,"createDate":"2022-07-30T22:24:54.17","modifyDate":"2022-07-30T22:24:54.17"},{"orderItemId":165139317,"lineItemKey":"LI-0751","sku":"EShip","name":"Shipping","imageUrl":null,"weight":null,"quantity":1,"unitPrice":0,"taxAmount":0,"shippingAmount":0,"warehouseLocation":null,"options":[],"productId":11069447,"fulfillmentSku":null,"adjustment":false,"upc":null,"createDate":"2022-07-30T22:24:54.17","modifyDate":"2022-07-30T22:24:54.17"}],"orderTotal":175,"amountPaid":0,"taxAmount":0,"shippingAmount":0,"customerNotes":null,"internalNotes":null,"gift":false,"giftMessage":null,"paymentMethod":null,"requestedShippingService":"2","carrierCode":"ups","serviceCode":"ups_2nd_day_air_am","packageCode":"package","confirmation":"none","shipDate":null,"holdUntilDate":null,"weight":{"value":0,"units":"ounces","WeightUnits":1},"dimensions":{"units":"inches","length":12,"width":12,"height":12},"insuranceOptions":{"provider":null,"insureShipment":false,"insuredValue":0},"internationalOptions":{"contents":null,"customsItems":null,"nonDelivery":null},"advancedOptions":{"warehouseId":332246,"nonMachinable":false,"saturdayDelivery":false,"containsAlcohol":false,"mergedOrSplit":false,"mergedIds":[],"parentId":null,"storeId":407069,"customField1":null,"customField2":null,"customField3":null,"source":null,"billToParty":"my_other_account","billToAccount":null,"billToPostalCode":null,"billToCountryCode":null,"billToMyOtherAccount":551255},"tagIds":null,"userId":null,"externallyFulfilled":false,"externallyFulfilledBy":null,"externallyFulfilledById":null,"externallyFulfilledByName":null,"labelMessages":null}],"total":1,"page":1,"pages":1}';
            }
            System.debug('body resp:' + respbody);
            ret = (ss_order_resp)JSON.deserialize(respbody, ss_order_resp.class);
            System.debug('ret:' + ret);
        }
        
        API_Request__c apir = new API_Request__c(
            Request_Type__c = 'ShipStation',
            Response__c = respbody,
            Raw_Request__c = jsonBody,
            Order_Number__c = ssOrder.orderNumber
        );
        insert apir;            
        
        return ret;
    }
    
    public static Integer voidLabelCall(String shipmentId) {
       
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://ssapi.shipstation.com/shipments/voidlabel';
        system.debug('endpoint:' + endpoint);
        
        request.setEndPoint(endpoint);
        request.setMethod('POST');        
        String username = Label.ShipStationAPIKey;
        String password = Label.ShipStationAPISecret;
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);     
        request.setHeader('content-type', 'application/json');
        
        String jsonBody = '{"shipmentId": ' + shipmentId + '}';
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
            System.debug('body rep:' + body);
        }
        
        return statusCode;
    }

    public static void processShipmentShipped(MAP<String,ss_shipment> mapShipments) {
        
        List<Order> lstShip = [select id, Plant_Tracking_Number__c, Plant_ShipStation_Order_ID__c, Plant_Fulfillment_Status__c from Order where Order.Plant_ShipStation_Order_ID__c in :mapShipments.keyset()];
        System.debug('lstShip:' + lstShip);

        if(!lstShip.isEmpty()) {
            
            List<Order> lstUpdateOrders = new List<Order>();
            for(Order ord :lstShip) {
                System.debug('ord:' + ord);
                ss_shipment fndSS = mapShipments.get(ord.Plant_ShipStation_Order_ID__c);
                if(fndSS != NULL) {
                    ord.Plant_Tracking_Number__c = fndSS.trackingNumber;
                    ord.Plant_Fulfillment_Status__c = 'Packed Order - Ready to Ship';
                    ord.Plant_ShipStation_Order_ID__c = fndSS.shipmentId;
                    lstUpdateOrders.add(ord);
                }
            }
            if(!lstUpdateOrders.isEmpty()) {
                update lstUpdateOrders;
            }
        }
    }
    
    public static void processFulfillmentShipped(ss_fulfillment fulfillment) {
        System.debug('fulfillment:' + fulfillment);
        
        if(fulfillment.orderNumber != NULL && fulfillment.orderNumber.length() > 0 && 
           fulfillment.trackingNumber != NULL && fulfillment.trackingNumber.length() > 0) {
               List<Shipment__c> lstShip = [select id, Tracking_Number__c from Shipment__c where Opportunity__r.External_Order_Number__c = :fulfillment.orderNumber];
               System.debug('lstShip:' + lstShip);
               if(!lstShip.isEmpty()) {
                   lstShip[0].Tracking_Number__c = fulfillment.trackingNumber;
                   update lstShip;
               }
           }
    }
    
    public static void voidLabel(String shipmentId) {
        if(shipmentId != NULL) {
        	voidLabelCall(shipmentId);            
        }
    }
    
    public static void setOrderToShip(String orderId) {
        List<Order> orders = [select Id, Type, Plant_Invoice_Number__c, Plant_ShipStation_Order_ID__c, ActivatedDate, 
                              Plant_Main_Product__c, 
                              Plant_Meal_Selection_Type__c,
                              TotalAmount, Plant_Sort_Rank_Slips__c,
                              Plant_Provider__c,
                              Plant_Order_Properties__r.Plant_Email__c, 
                              Plant_Order_Properties__r.Plant_First_Name__c, 
                              Plant_Order_Properties__r.Plant_Last_Name__c, 
                              Plant_Order_Properties__r.Plant_Phone__c,
                              Plant_Order_Properties__r.Plant_Meal_Selection__c,
                              Plant_Order_Properties__r.Shipping_Address__r.Plant_Street1__c,
                              Plant_Order_Properties__r.Shipping_Address__r.Plant_Street2__c,
                              Plant_Order_Properties__r.Shipping_Address__r.Plant_City__c,
                              Plant_Order_Properties__r.Shipping_Address__r.Plant_Province_State__c,
                              Plant_Order_Properties__r.Shipping_Address__r.Plant_Country__c,
                              Plant_Order_Properties__r.Shipping_Address__r.Plant_Postal_Code__c,
                              Plant_Order_Properties__r.Delivery_Schedule__r.Plant_Shipping_Duration__c,
                              Plant_Order_Properties__r.Delivery_Schedule__r.Shipping_Type__c,
                              Plant_Order_Properties__r.Plant_Shipping_Date__r.Plant_Shipping_Date__c
                              from Order where id = :orderId AND Status = 'Activated'];
        if(!orders.isEmpty()) {
            Order ord = orders[0];
            List<Plant_Meal_Selection_Meal__c> lstMSM = [select Id, Plant_Meal__r.Name, Plant_Quantity__c, Plant_Meal__r.Shopify_ID__c 
                                                         from Plant_Meal_Selection_Meal__c 
                                                         WHERE Plant_Meal_Selection__c = :ord.Plant_Order_Properties__r.Plant_Meal_Selection__c
                                                         Order by Plant_Meal__r.Sort_Rank_Calc__c ASC];
            
            if(!lstMSM.isEmpty()) {
                
                // Setup Data
                ss_order_send sso = new ss_order_send();
                
                sso.orderNumber = ord.Plant_Invoice_Number__c;
                
                DateTime clsDT = DateTime.newInstance(ord.ActivatedDate.year(), ord.ActivatedDate.month(), ord.ActivatedDate.day());
                System.debug('clsDT:' + clsDT);            
                sso.orderDate = clsDT.format('yyyy-MM-dd') + 'T09:00:00.0000000';
                sso.paymentDate = clsDT.format('yyyy-MM-dd') + 'T09:00:00.0000000';
                
                sso.orderStatus = 'awaiting_shipment';
                sso.customerUsername = ord.Plant_Order_Properties__r.Plant_Email__c;
                sso.customerEmail = ord.Plant_Order_Properties__r.Plant_Email__c;
                
                sso.billTo = new ss_address();
                sso.billTo.name = ord.Plant_Order_Properties__r.Plant_First_Name__c + ' ' + ord.Plant_Order_Properties__r.Plant_Last_Name__c;
                sso.billTo.phone = ord.Plant_Order_Properties__r.Plant_Phone__c;
                
                sso.shipTo = new ss_address();    
                sso.shipTo.street1 =  ord.Plant_Order_Properties__r.Shipping_Address__r.Plant_Street1__c;
                sso.shipTo.street2 =  ord.Plant_Order_Properties__r.Shipping_Address__r.Plant_Street2__c;
                sso.shipTo.name = sso.billTo.name;
                sso.shipTo.phone = ord.Plant_Order_Properties__r.Plant_Phone__c;
                sso.shipTo.city = ord.Plant_Order_Properties__r.Shipping_Address__r.Plant_City__c;
                sso.shipTo.state = ord.Plant_Order_Properties__r.Shipping_Address__r.Plant_Province_State__c;
                sso.shipTo.postalCode = ord.Plant_Order_Properties__r.Shipping_Address__r.Plant_Postal_Code__c;
                sso.shipTo.country = ord.Plant_Order_Properties__r.Shipping_Address__r.Plant_Country__c;
                sso.shipTo.residential = false;
                
                sso.items = new list<ss_item>();
                
                Integer mealCnt=97;   
                String firstMeal;
                if(ord.Type == 'New Customer' && ord.Plant_Main_Product__c == 'A-la-carte') {
                    firstMeal= '<b>New Customer Welcome Card</b>';
                    //} else if(Test.isRunningTest() || (ord.Type == 'New Customer' && opp.Main_Product_Code__c == '3DCLN')) {
                    //    firstMeal= '<b>3-Day Cleanse Welcome Card</b>';
                } else if(ord.Type == 'New Customer' && ord.Plant_Main_Product__c == 'Reboot') {
                    firstMeal= '<b>New Customer Program Welcome Booklet</b>';
                } else if(ord.Type == 'New Customer' && ord.Plant_Main_Product__c == 'ZPEALC') {
                    firstMeal = '<b>Zipongo Welcome Card</b>';
                }
                String myChar;
                if(firstMeal != NULL) {
                    ss_item i1 = new ss_item();
                    myChar = String.fromCharArray( new List<integer> { mealCnt } );
                    i1.sku = 'cardinsert123';
                    i1.name = myChar +')  _____  ' + firstMeal;
                    i1.quantity = 1;
                    i1.unitPrice = 0.00;
                    i1.taxAmount = 0.00;
                    i1.shippingAmount = 0.00;
                    i1.adjustment = false;
                    
                    System.debug('i1:' + i1);
                    sso.items.add(i1);
                    mealCnt++;                            
                }
                
                for(Plant_Meal_Selection_Meal__c mli :lstMSM) {
                    System.debug('mli:' + mli);
                    
                    ss_item i3 = new ss_item();
                    i3.sku = mli.Plant_Meal__r.Shopify_ID__c;
                    myChar = String.fromCharArray( new List<integer> { mealCnt } );
                    i3.name = myChar +')  _____  ' + String.valueOf(mli.Plant_Quantity__c) + '  ' + mli.Plant_Meal__r.Name;
                    i3.quantity = (Long)mli.Plant_Quantity__c;
                    i3.unitPrice = 0.00;
                    i3.taxAmount = 0.00;
                    i3.shippingAmount = 0.00;
                    i3.adjustment = false;
                    
                    System.debug('i3:' + i3);
                    
                    sso.items.add(i3);
                    mealCnt++;
                    
                    sso.orderTotal = 0.00;
                    
                    sso.amountPaid = ord.TotalAmount;
                    sso.taxAmount = 0.00;
                    sso.shippingAmount = 0.00;
                    sso.gift = false;
                    //sso.requestedShippingService = '2';
                    //sso.serviceCode = 'ups_2nd_day_air';
                    sso.taxAmount = 0.00;
                    sso.confirmation = 'none';
                    
                    sso.weight = new ss_weight();
                    sso.carrierCode = 'ups';
                    sso.packageCode = 'package';
                    
                    //System.debug('mainShipment.Shipping_Service_Type__c:' + mainShipment.Shipping_Service_Type__c +':');
                    
                    if(ord.Plant_Order_Properties__r.Delivery_Schedule__r.Shipping_Type__c == 'Air') {
                        sso.serviceCode = 'ups_2nd_day_air';
                        sso.weight.value = 256.00;
                    } else if(ord.Plant_Order_Properties__r.Delivery_Schedule__r.Plant_Shipping_Duration__c == 2 && ord.Plant_Order_Properties__r.Delivery_Schedule__r.Shipping_Type__c == 'Ground') {
                        sso.serviceCode = 'ups_ground';
                        sso.weight.value = 256.00;                    
                    } else {
                        sso.serviceCode = 'ups_ground';
                        sso.weight.value = 224.00;
                    }
                    sso.weight.WeightUnits = 1;
                    sso.weight.units = 'ounces';
                    sso.confirmation = 'none';
                    
                    System.debug('serviceCode:' + sso.serviceCode);
                    System.debug('weight:' + sso.weight.value);
                    
                    DateTime schDT = DateTime.newInstance(ord.Plant_Order_Properties__r.Plant_Shipping_Date__r.Plant_Shipping_Date__c.year(), ord.Plant_Order_Properties__r.Plant_Shipping_Date__r.Plant_Shipping_Date__c.month(), ord.Plant_Order_Properties__r.Plant_Shipping_Date__r.Plant_Shipping_Date__c.day());
                    System.debug('schDT:' + schDT);            
                    sso.shipDate = schDT.format('yyyy-MM-dd') + 'T09:00:00.0000000';
                    System.debug('shipByDate:' + sso.shipDate);
                    
                    sso.insuranceOptions = new ss_insuranceOptions();
                    sso.insuranceOptions.insureShipment = false;
                    sso.insuranceOptions.insuredValue = 0.0;
                    
                    sso.internationalOptions = new ss_internationalOptions();
                    sso.internationalOptions.contents = 'merchandise';  
                    sso.internationalOptions.nonDelivery = 'return_to_sender';
                    
                    sso.advancedOptions = new ss_advancedOptions();
                    sso.advancedOptions.warehouseId = 332246;
                    sso.advancedOptions.storeId = 392054;
                    sso.advancedOptions.source = ord.Plant_Sort_Rank_Slips__c;
                    
                    String prodName = '';
                    if(ord.Plant_Main_Product__c == 'Reboot') {
                        prodName = 'Reboot';
                    } else if(ord.Plant_Main_Product__c == 'A-la-carte') {
                        prodName = 'A La Carte';
                    } else if(ord.Plant_Main_Product__c == 'Quickstart') {
                        prodName = 'Quickstart';
                    } else if(ord.Plant_Main_Product__c == 'ZPEALC') {
                        prodName = 'Zipongo';
                    }
                    if(ord.Plant_Meal_Selection_Type__c == 'Custom') {
                        prodName = 'Custom ' + prodName;
                    } else {
                        prodName = 'Chef ' + prodName;
                    }
                    
                    sso.advancedOptions.customField1 = prodName;
                    if(ord.Plant_Provider__c == 'Study') {
                        sso.advancedOptions.customField2 = 'Study Order';                
                    }
                    sso.advancedOptions.customField3 = ord.Plant_Order_Properties__r.Delivery_Schedule__r.Plant_Shipping_Duration__c + ' day ' + ord.Plant_Order_Properties__r.Delivery_Schedule__r.Shipping_Type__c;
                    //sso.advancedOptions.mergedIds = new List<ss_mergedIds>();
                    sso.advancedOptions.nonMachinable = False;
                    sso.advancedOptions.saturdayDelivery = False;
                    sso.advancedOptions.containsAlcohol = False;
                    sso.advancedOptions.mergedOrSplit = False;
                    
                    sso.externallyFulfilled = false;
                    
                    ss_order_resp ret = setOrder(sso, ord.Plant_ShipStation_Order_ID__c);
                    System.debug('ret:' + ret);
                    
                }
                
            }
            
        }
    }
        
    @AuraEnabled
    public static void syncShipStationOrders(String shipDate, String mode) {
        
        System.debug('syncShipStationOrders:' + shipDate + ':' + mode);
        
        if(mode == 'syncAwaitingShipment') {
            Plant_BatchSyncShipStationOrders batch = new Plant_BatchSyncShipStationOrders('awaiting',shipDate,null);     
            Database.executeBatch(batch,1);  
        } else if(mode == 'syncAllOrdersNeedsPacking') {
            Plant_BatchSyncShipStationOrders batch = new Plant_BatchSyncShipStationOrders('all',shipDate,null);     
            Database.executeBatch(batch,1);  
        } else if(mode == 'syncCustomZipOrdersNeedsPacking') {
            Plant_BatchSyncShipStationOrders batch = new Plant_BatchSyncShipStationOrders('customzip',shipDate,null);     
            Database.executeBatch(batch,1);  
        }
		
    }

    @InvocableMethod(label='shipStationMethods' description='Operate ShipStation Class Methods.')
    public static void shipStationMethods(List<List<String>> inputParams) {  
        
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
                
                if(method == 'setOrderToShip') {
                    setOrderToShip(param1);
                } else if(method == 'syncAwaitingShipment') {
                    Plant_BatchSyncShipStationOrders batch = new Plant_BatchSyncShipStationOrders('awaiting',param1,null);     
                    Database.executeBatch(batch,1);  
                } else if(method == 'syncAllOrdersNeedsPacking') {
                    Plant_BatchSyncShipStationOrders batch = new Plant_BatchSyncShipStationOrders('all',param1,null);     
                    Database.executeBatch(batch,1);  
                } else if(method == 'syncCustomZipOrdersNeedsPacking') {
                    Plant_BatchSyncShipStationOrders batch = new Plant_BatchSyncShipStationOrders('customzip',param1,null);     
                    Database.executeBatch(batch,1);  
                } else if(method == 'voidLabel') {
                    voidLabel(param1);      
                }
            }
        }
   
    }        
    
}