public class Plant_NewOrderCustomerController {
    @AuraEnabled
    public static String getMeals(){
        try {
            Plant_Meals_BC Plant_Meals_BC = new Plant_Meals_BC();
            Plant_Utility.responseWrapper mealList = Plant_Meals_BC.getAllActiveMeals();
            return JSON.serialize(mealList);
            //return [SELECT Id,Name,Type__c FROM Meal__c WHERE Status__c = 'Active'];
            
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
        
    }

    @AuraEnabled
    public static string createOrder(string createOrderJSON){
        try {
            system.debug('jsonn::'+createOrderJSON);
            Plant_Orders_BC.opReqWrapper wrapper = (Plant_Orders_BC.opReqWrapper) JSON.deserializeStrict(createOrderJSON, Plant_Orders_BC.opReqWrapper.class);
            system.debug('request wraperrr:'+ JSON.serializePretty(wrapper));
            Plant_Orders_BC Plant_Orders = new Plant_Orders_BC();
            Plant_Utility.responseWrapper responseWrapper =  Plant_Orders.preProcessOrder(wrapper);
            system.debug('response wraperrr:'+ JSON.serializePretty(responseWrapper));
            return JSON.serialize(responseWrapper);

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Account getAccount(string accountId){
        try {
            return [SELECT Id,plant_Authentication_Token__c,First_Name__c,Last_Name__c,Email__c,Phone FROM Account WHERE Id=:accountId limit 1];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string getShippingAddress(string authorizationTokenJson){
        try {
            Plant_Customer_BC Plant_Customer_BC = new Plant_Customer_BC();
            Plant_Utility.responseWrapper response = Plant_Customer_BC.getShippingAddresstDetailList(authorizationTokenJson);
            /*Plant_Shipping_BC.userAuth_ResponseWrap wrapper = (Plant_Shipping_BC.userAuth_ResponseWrap) JSON.deserializeStrict(authorizationTokenJson, Plant_Shipping_BC.userAuth_ResponseWrap.class);
            Plant_Shipping_BC Plant_Shipping = new Plant_Shipping_BC();
            Plant_Utility.responseWrapper shippingResponse = Plant_Shipping.getShippingAddresstDetailList(wrapper);
            return JSON.serialize(shippingResponse); */
            return JSON.serialize(response);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
       
    }

    @AuraEnabled
    public static string getPicklistValue(string ObjectApi_name , string Field_name){
        try {
            
            return JSON.serialize(Plant_GetPickListValue.getPicklistValues(ObjectApi_name, Field_name));
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}