public class plant_Edit_OrderController {

    @AuraEnabled(cacheable=true)
    public static string validateAccessToken(string token){
        try {
            return plant_AuthorizeController.validate_ByAccessToken(token);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string getOrderDetails(String authorisationToken , String OrderNo){
        System.debug('authorisationToken>>'+authorisationToken + ' OrderNo>' + OrderNo);
        Plant_Orders_BC Plant_Orders_BC = new Plant_Orders_BC();
        Plant_Utility.responseWrapper response = Plant_Orders_BC.getOrderDetails(authorisationToken , OrderNo);
        System.debug('response::'+JSON.serialize(response));
        return JSON.serialize(response);
    /*
        try {
            paymentDetailWrapper paymentDetailWrapperDetails = new paymentDetailWrapper(null,null,null,null);
            availableDeliveryDateWrapper availableDeliveryDatesWrapper = new availableDeliveryDateWrapper(null,null,null,null);
            shippingWrapper shippingDataWrapper = new shippingWrapper(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
            selectedMealWrapper selectedMealListWrapper = new selectedMealWrapper(null , null , null , null);

            Order orderData = [SELECT Id,OrderNumber,Plant_Order_Properties__c,Plant_Order_Properties__r.Plant_Payment_Method__c,Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Card_Type__c,Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Card_Last_4_Digits__c,Plant_Order_Properties__r.Plant_Delivery_Date__c,Plant_Order_Properties__r.Shipping_Address__c,Plant_Order_Properties__r.Shipping_Address__r.Name,
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_Street1__c,Plant_Order_Properties__r.Shipping_Address__r.Plant_Street2__c,
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_Street3__c,Plant_Order_Properties__r.Shipping_Address__r.Plant_City__c,
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_Province_State__c,Plant_Order_Properties__r.Shipping_Address__r.Plant_Country__c,
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_Postal_Code__c,Plant_Order_Properties__r.Shipping_Address__r.Plant_Phone__c,
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_Can_SMS__c   FROM Order WHERE Id =:orderId limit 1
                                ];
            map<string,string> paymentDetailObj = new map<string,string>();
            if(authorisationToken != null && authorisationToken != ''){
                try {
                    Plant_Orders_BC Plant_Orders_BC = new Plant_Orders_BC();
                    map<string,string> mapOfwrapOrder_MealReq = new map<string,string>();
                    mapOfwrapOrder_MealReq.put('orderNo', orderData.OrderNumber );
                    mapOfwrapOrder_MealReq.put('authenticationToken', authorisationToken );
                    Plant_Orders_BC.wrapOrder_MealReq getMealWrapper  = (Plant_Orders_BC.wrapOrder_MealReq) JSON.deserializeStrict(JSON.serialize(mapOfwrapOrder_MealReq), Plant_Orders_BC.wrapOrder_MealReq.class);
                    Plant_Utility.responseWrapper selectedMealList = Plant_Orders_BC.getOrder_MealDetails(getMealWrapper);
                    System.debug('selectedMealList::'+JSON.serializePretty(selectedMealList));
                    if(selectedMealList.statusCode != '200'){
                        if(selectedMealList.statusCode != null){
                            selectedMealListWrapper = new selectedMealWrapper(selectedMealList.statusCode , null , selectedMealList.msg , null);
                        }
                    }
                    else{
                        selectedMealListWrapper = new selectedMealWrapper(selectedMealList.statusCode , selectedMealList.msg , null , selectedMealList);
                    }

                    paymentDetailObj.put('authenticationToken', authorisationToken);
                    Plant_Orders_BC.customerInfoReq_wrap customerInfoReq_wrap = (Plant_Orders_BC.customerInfoReq_wrap) JSON.deserializeStrict(JSON.serialize(paymentDetailObj), Plant_Orders_BC.customerInfoReq_wrap.class);
                    Plant_Utility.responseWrapper paymentDetails = Plant_Orders_BC.getAccountPaymentDetails(customerInfoReq_wrap);
                    if(paymentDetails.statusCode != '200'){
                        if(paymentDetails.statusCode != null){
                            paymentDetailWrapperDetails = new paymentDetailWrapper(paymentDetails.statusCode , null , paymentDetails.msg , null);
                        }
                    }
                    else{
                        paymentDetailWrapperDetails = new paymentDetailWrapper(paymentDetails.statusCode , paymentDetails.msg , null , paymentDetails);
                    }
                    System.debug('paymentDetails Wrapper:::'+JSON.serializePretty(paymentDetails));
                } catch (Exception Ex) {
                    system.debug('customerInfoReq_wrap Error::'+Ex.getMessage());
                }
            }
            if(orderData != null){   
                map<string,string> deliverDateObj = new map<string,string>();
                deliverDateObj.put('street1', orderData.Plant_Order_Properties__r.Shipping_Address__r.Plant_Street1__c);
                deliverDateObj.put('street2', orderData.Plant_Order_Properties__r.Shipping_Address__r.Plant_Street2__c);
                deliverDateObj.put('street3', orderData.Plant_Order_Properties__r.Shipping_Address__r.Plant_Street3__c);
                deliverDateObj.put('city', orderData.Plant_Order_Properties__r.Shipping_Address__r.Plant_City__c);
                deliverDateObj.put('state', orderData.Plant_Order_Properties__r.Shipping_Address__r.Plant_Province_State__c);
                deliverDateObj.put('country', orderData.Plant_Order_Properties__r.Shipping_Address__r.Plant_Country__c);
                deliverDateObj.put('phone', orderData.Plant_Order_Properties__r.Shipping_Address__r.Plant_Phone__c);
                deliverDateObj.put('canSMS', String.valueOf(orderData.Plant_Order_Properties__r.Shipping_Address__r.Plant_Can_SMS__c));
                deliverDateObj.put('zip', orderData.Plant_Order_Properties__r.Shipping_Address__r.Plant_Postal_Code__c);
                deliverDateObj.put('shippingDate', null);

                Plant_Shipping_BC.deliveryDateWrapper deliveryDateWrapper = (Plant_Shipping_BC.deliveryDateWrapper) JSON.deserializeStrict(JSON.serialize(deliverDateObj), Plant_Shipping_BC.deliveryDateWrapper.class);
                Plant_Shipping_BC Plant_Shipping_BC = new Plant_Shipping_BC();
                Plant_Utility.responseWrapper availableDeliveryDates = Plant_Shipping_BC.getAvailableDeliveryDates(deliveryDateWrapper);

                deliverDateObj.put('deliveryDate', (orderData.Plant_Order_Properties__r.Plant_Delivery_Date__c != null ? String.valueOf(orderData.Plant_Order_Properties__r.Plant_Delivery_Date__c) : '' ));
                deliverDateObj.put('orderPropertyId', ( orderData.Plant_Order_Properties__c != null ? String.valueOf(orderData.Plant_Order_Properties__c) : ''));
                deliverDateObj.put('paymentMethodId', (orderData.Plant_Order_Properties__r.Plant_Payment_Method__c != null ? String.valueOf(orderData.Plant_Order_Properties__r.Plant_Payment_Method__c) : ''));
                deliverDateObj.put('paymentMethodName', (orderData.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Card_Last_4_Digits__c != null && orderData.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Card_Last_4_Digits__c != '' ? '...'+ orderData.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Card_Last_4_Digits__c + (orderData.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Card_Type__c != null && orderData.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Card_Type__c != '' ? '(' + orderData.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Card_Type__c + ')' : '')  : ''));
                deliverDateObj.put('shippingAddressId', ( orderData.Plant_Order_Properties__r.Shipping_Address__c != null ? String.valueOf(orderData.Plant_Order_Properties__r.Shipping_Address__c) : ''));
                shippingDataWrapper = (shippingWrapper) JSON.deserializeStrict(JSON.serialize(deliverDateObj), shippingWrapper.class);
                
                if(availableDeliveryDates.statusCode != '200'){
                    if(availableDeliveryDates.statusCode != null){
                        availableDeliveryDatesWrapper = new availableDeliveryDateWrapper(availableDeliveryDates.statusCode , availableDeliveryDates.msg ,null, null);
                    }
                }
                else{
                    availableDeliveryDatesWrapper = new availableDeliveryDateWrapper(availableDeliveryDates.statusCode , availableDeliveryDates.msg , null , availableDeliveryDates);
                }
                responseWrapper responseWrapperData = new responseWrapper(shippingDataWrapper,availableDeliveryDatesWrapper,paymentDetailWrapperDetails , selectedMealListWrapper);
                System.debug('responseWrapperData:::'+JSON.serializePretty(responseWrapperData));
                
                return JSON.serialize(responseWrapperData);
            }
            else{
                return null;
            }  
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }  */
    }

    @AuraEnabled
    public static string getOrderList(String authorisationToken ){
        try {
            Plant_Orders_BC Plant_Orders_BC = new Plant_Orders_BC();
            return JSON.serialize(Plant_Orders_BC.getOrders(authorisationToken , ''));
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string updateCustomerMealList(string mealList){
        try {   
            Plant_Orders_BC.CustomerMeal_UpdateReq_Wrapper mealListWrapper = (Plant_Orders_BC.CustomerMeal_UpdateReq_Wrapper) JSON.deserializeStrict(mealList, Plant_Orders_BC.CustomerMeal_UpdateReq_Wrapper.class);
            System.debug('mealListWrapper:::'+JSON.serializePretty(mealListWrapper));
            Plant_Orders_BC Plant_Orders_BC = new Plant_Orders_BC();
            Plant_Utility.responseWrapper responseData = Plant_Orders_BC.updateOrder_Meals(mealListWrapper);
            return JSON.serialize(responseData);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string updatePaymentDetails(string paymentDetailJSON){
        try {
            /*
            Plant_Orders_BC.customer_PaymtUpdateWrap paymentwrapper = (Plant_Orders_BC.customer_PaymtUpdateWrap) JSON.deserializeStrict(paymentDetailJSON, Plant_Orders_BC.customer_PaymtUpdateWrap.class);
            System.debug('paymentwrapper:::'+JSON.serializePretty(paymentwrapper));

            Plant_Orders_BC Plant_Orders_BC = new Plant_Orders_BC();
            Plant_Utility.responseWrapper responseWrapper = Plant_Orders_BC.setCustomer_PaymentDetails(paymentwrapper);
            return JSON.serialize(responseWrapper); */
            return 'Need To Work';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string updateShippingDetails(string shippingJSON){
        Plant_Orders_BC Plant_Orders_BC = new Plant_Orders_BC();
        Plant_Orders_BC.manageShipAddress shippingWrapper = (Plant_Orders_BC.manageShipAddress) JSON.deserializeStrict(shippingJSON, Plant_Orders_BC.manageShipAddress.class);
        System.debug('shippingWrapper:::'+JSON.serializePretty(shippingWrapper));
        Plant_Utility.responseWrapper responseWrapper = Plant_Orders_BC.update_CustomerOdr_ShipAddress(shippingWrapper);
        return JSON.serialize(responseWrapper);
        /*try {
            Plant_Customer_BC.manageShipAddress  shippingWrapper = (Plant_Customer_BC.manageShipAddress) JSON.deserializeStrict(shippingJSON, Plant_Customer_BC.manageShipAddress.class);
            System.debug('shippingWrapper:::'+JSON.serializePretty(shippingWrapper));
            Plant_Customer_BC Plant_Customer_BC = new Plant_Customer_BC();
            Plant_Utility.responseWrapper responseWrapper = Plant_Customer_BC.update_CustomerOdr_ShipAddress(shippingWrapper);
            return JSON.serialize(responseWrapper);

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        } */
    }

    @AuraEnabled
    public static Plant_Order_Properties__c  updateDeliveryDate(string updateOrderPropertyJSON){
        try {
            Plant_Order_Properties__c  orderProperty = (Plant_Order_Properties__c) JSON.deserializeStrict(updateOrderPropertyJSON, Plant_Order_Properties__c.class);
            System.debug('orderProperty:::'+orderProperty);
            update orderProperty;
            return orderProperty;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string getAvailableDeliveryDates(string addressJSON){
        try {
            Plant_Shipping_BC Plant_Shipping_BC = new Plant_Shipping_BC();
            Plant_Shipping_BC.deliveryDateWrapper deliveryDateWrapper = (Plant_Shipping_BC.deliveryDateWrapper) JSON.deserializeStrict(addressJSON, Plant_Shipping_BC.deliveryDateWrapper.class);
            System.debug('deliveryDateWrapper::'+JSON.serializePretty(deliveryDateWrapper));
            Plant_Utility.responseWrapper responseWrapper = Plant_Shipping_BC.getAvailableDeliveryDates(deliveryDateWrapper);
            return JSON.serialize(responseWrapper);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class responseWrapper{
        shippingWrapper shippingDetails{get;set;}
        availableDeliveryDateWrapper availableDeliveryDatesList{get;set;}
        paymentDetailWrapper paymentDetailList{get;set;}
        selectedMealWrapper selectedMealList{get;set;}
        public responseWrapper(shippingWrapper shippingDetails , availableDeliveryDateWrapper availableDeliveryDatesList,paymentDetailWrapper paymentDetailList , selectedMealWrapper selectedMealList){
            this.shippingDetails = shippingDetails;
            this.availableDeliveryDatesList = availableDeliveryDatesList;
            this.paymentDetailList = paymentDetailList;
            this.selectedMealList = selectedMealList;
        }
    }

    public class shippingWrapper{
        string statusCode{get;set;}
        string successMessage{get;set;}
        string errorMessage{get;set;}
        string street1{get;set;}
        string street2{get;set;}
        string street3{get;set;}
        string city{get;set;}
        string state{get;set;}
        string country{get;set;}
        string phone{get;set;}
        string canSMS{get;set;}
        string shippingDate{get;set;}
        string zip{get;set;}
        string deliveryDate{get;set;}
        string orderPropertyId{get;set;}
        string paymentMethodId{get;set;}
        string paymentMethodName{get;set;}
        string shippingAddressId{get;set;}

        public shippingWrapper(string statusCode,string successMessage ,string street1 ,string street2,string street3 ,string city,string state,string country,string phone,string canSMS , string shippingDate , string zip , string deliveryDate,string orderPropertyId, string paymentMethodId, string paymentMethodName, string shippingAddressId){
            this.statusCode = statusCode;
            this.successMessage = successMessage;
            this.street1 = street1;
            this.street2 = street2;
            this.street3 = street3;
            this.city = city;
            this.state = state;
            this.country = country;
            this.phone = phone;
            this.canSMS = canSMS;
            this.shippingDate = shippingDate;
            this.zip = zip;
            this.deliveryDate = deliveryDate;
            this.orderPropertyId = orderPropertyId;
            this.paymentMethodId = paymentMethodId;
            this.paymentMethodName = paymentMethodName;
            this.shippingAddressId = shippingAddressId;
        }
    }

    public class availableDeliveryDateWrapper{
        string statusCode{get;set;}
        string successMessage{get;set;}
        string errorMessage{get;set;}
        Plant_Utility.responseWrapper availableDates{get;set;}

        public availableDeliveryDateWrapper(string statusCode,string successMessage , string errorMessage ,Plant_Utility.responseWrapper availableDates){
            this.statusCode = statusCode;
            this.successMessage = successMessage;
            this.errorMessage = errorMessage;
            this.availableDates = availableDates;
        }
    }

    public class paymentDetailWrapper{
        string statusCode{get;set;}
        string successMessage{get;set;}
        string errorMessage{get;set;}
        Plant_Utility.responseWrapper paymentDetailList{get;set;}

        public paymentDetailWrapper(string statusCode,string successMessage , string errorMessage ,Plant_Utility.responseWrapper paymentDetailList){
            this.statusCode = statusCode;
            this.successMessage = successMessage;
            this.errorMessage = errorMessage;
            this.paymentDetailList = paymentDetailList;
        }
    }

    public class selectedMealWrapper{
        string statusCode{get;set;}
        string successMessage{get;set;}
        string errorMessage{get;set;}
        Plant_Utility.responseWrapper selectedMealList{get;set;}

        public selectedMealWrapper(string statusCode,string successMessage , string errorMessage , Plant_Utility.responseWrapper selectedMealList){
            this.statusCode = statusCode;
            this.successMessage = successMessage;
            this.errorMessage = errorMessage;
            this.selectedMealList = selectedMealList;
        }
    }
}