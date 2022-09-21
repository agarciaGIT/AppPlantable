/*
*   @Desciption     :   Plantable Order API class
*   @Create date    :   22-04-2022
*   @Author         :   Bhagwan S
_________________________________________________________________________________________________________________________________________________________
@Test class     :   
*/

@RestResource(urlMapping='/v1/orders/*')
global class Plant_RESTOrders {
    
    // @ Constructor
    global Plant_RESTOrders() {
        
    }
    
    // get:
    // Get payment detail of cart
    @HttpGet
    global static void getCartDetails(){
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;  
        res.addHeader('Content-Type', 'application/json');
        String param_cartId = '';
        
        
        System.debug('#### check uri => '+req.requestURI.lastIndexOf('/')+1);
        System.debug('### URI value=> '+req.requestURI.substring(req.requestURI.lastIndexOf('/')+1));
        param_cartId = req.params.get('cartId');
        
        System.debug('@@@@# param_cartId : '+param_cartId);
        /*
        if(param_cartId!='' && req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('PaymentDetails')){
            // CALL DISPLAY PAYMENT METHOD 
            Plant_Utility.responseWrapper preOrderWrapResult =  Plant_Orders_SC.getPaymentDetail(param_cartId);
            if(preOrderWrapResult.statusCode=='200'){
                res.statusCode = Integer.valueOf(preOrderWrapResult.statusCode);
                System.debug('@@@@## success PM display');
            }
            else{
                res.statusCode = Integer.valueOf(preOrderWrapResult.statusCode);
                System.debug('@@@@## error PM display');
            }   
            
            String jsonRespBody = JSON.serialize(preOrderWrapResult); 
            res.responseBody = Blob.valueOf(jsonRespBody); 
        }
        
        else 
		*/
        
		if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('list')){
            String param_Authentication = req.params.get('authenticationToken');
            if(!String.isBlank(param_Authentication)){
                Plant_Utility.responseWrapper resultToken = Plant_Orders_SC.getOrder_SC(param_Authentication);
                if(resultToken.statusCode=='200'){
                    res.statusCode = Integer.valueOf(resultToken.statusCode);
                    System.debug('@@@@## success dd');
                }
                else{
                    res.statusCode = Integer.valueOf(resultToken.statusCode);
                    System.debug('@@@@## error dd');
                } 
                String jsonRespBody = JSON.serialize(resultToken); 
                res.responseBody = Blob.valueOf(jsonRespBody); 
            }    
            
        }
        else if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('details')){
                
            String param_Authentication = req.params.get('authenticationToken');
            String param_OrderNo = req.params.get('orderNumber');
            if(!String.isBlank(param_Authentication) && !String.isBlank(param_OrderNo)){
                Plant_Utility.responseWrapper resultToken = Plant_Orders_SC.getOrderDetail_SC(param_Authentication, param_OrderNo);
                if(resultToken.statusCode=='200'){
                    res.statusCode = Integer.valueOf(resultToken.statusCode);
                    System.debug('@@@@## success dd');
                }
                else{
                    res.statusCode = Integer.valueOf(resultToken.statusCode);
                    System.debug('@@@@## error dd');
                } 
                String jsonRespBody = JSON.serialize(resultToken); 
                res.responseBody = Blob.valueOf(jsonRespBody); 

            }
        }
        
        
        
        else {
            Plant_Utility.responseWrapper respWrapErr = new Plant_Utility.responseWrapper('error','500','Service not found! Invalid endpoint',new Plant_Utility.responseListWrapper(new List<String>()));
            res.statusCode = 500;
            String jsonErrRespBody = JSON.serialize(respWrapErr); 
            res.responseBody = Blob.valueOf(jsonErrRespBody);
        }
    }
    
    // set: 1 : Post
    // PRE-PROCESS ORDER
    // SET-PAYMENT-DETAILS
    /*
    @HttpPost
    global static void setPreOrder(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        
            String jsonBody = req.RequestBody.toString();
            Plant_Orders_BC.opReqWrapper reqWrap = new Plant_Orders_BC.opReqWrapper().parse(jsonBody);
            Plant_Utility.responseWrapper preOrderWrapResult = Plant_Orders_SC.setPreProcessOrders(reqWrap);
            if(preOrderWrapResult.statusCode=='200'){
                res.statusCode = Integer.valueOf(preOrderWrapResult.statusCode);
                System.debug('@@@@## success pO');
            }
            else{
                res.statusCode = Integer.valueOf(preOrderWrapResult.statusCode);
                System.debug('@@@@## error pO');
            }   
            
            String jsonRespBody = JSON.serialize(preOrderWrapResult); 
            res.responseBody = Blob.valueOf(jsonRespBody); 
    }
    */
    
    // set: 2: Put
    // PROCESS ORDER & PAYMENT
    @HttpPut
    global static void setProcessOrder(){
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        
        System.debug('#### check=> '+req.requestURI.lastIndexOf('/')+1);
        System.debug('#### check substring => '+req.requestURI.substring(req.requestURI.lastIndexOf('/')+1));
        /*
        if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('ProcessOrder')){
            System.debug('####@@ process Order called 1');
            // PROCESS ORDER**
            String jsonBody = req.RequestBody.toString();
            
            Plant_Orders_BC.processOdr_Wrapper reqWrap = new Plant_Orders_BC.processOdr_Wrapper().parse(jsonBody);
            Plant_Utility.responseWrapper processWrapResult = Plant_Orders_SC.processOrders(reqWrap);
            if(processWrapResult.statusCode=='200'){
                res.statusCode = Integer.valueOf(processWrapResult.statusCode);
                System.debug('@@@@## success processO');
            }
            else{
                res.statusCode = Integer.valueOf(processWrapResult.statusCode);
                System.debug('@@@@## error processO');
            }   
            
            String jsonRespBody = JSON.serialize(processWrapResult); 
            res.responseBody = Blob.valueOf(jsonRespBody); 
            
        }
        else if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('setPaymentDetails')){
            String jsonBody = req.RequestBody.toString();
            jsonBody=jsonBody.replace('{', '{"isCustomer": false,');
            Plant_Orders_BC.paymtUpdateWrap reqWrap = new Plant_Orders_BC.paymtUpdateWrap().parse(jsonBody);
            Plant_Utility.responseWrapper preOrderWrapResult = Plant_Orders_SC.setPaymentDetail(reqWrap);
            if(preOrderWrapResult.statusCode=='200'){
                res.statusCode = Integer.valueOf(preOrderWrapResult.statusCode);
                System.debug('@@@@## success pO');
            }
            else{
                res.statusCode = Integer.valueOf(preOrderWrapResult.statusCode);
                System.debug('@@@@## error pO');
            }   
            
            String jsonRespBody = JSON.serialize(preOrderWrapResult); 
            res.responseBody = Blob.valueOf(jsonRespBody); 
        }
        else if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('ProcessTransaction')){
            
            // PROCESS TRANSACTION**
            System.debug('####@@@ process transaction 2');
            String jsonBody = req.RequestBody.toString();
                
                System.debug('####@@@ process transaction 2 : session');
                Plant_Orders_BC.TransactionReqWrap reqWrap = new Plant_Orders_BC.TransactionReqWrap().parse(jsonBody);
                Plant_Utility.responseWrapper processWrapResult = Plant_Orders_SC.authorizePayment(reqWrap);
                if(processWrapResult.statusCode=='200'){
                    res.statusCode = Integer.valueOf(processWrapResult.statusCode);
                    System.debug('@@@@## success auth payment');
                }
                else{
                    res.statusCode = Integer.valueOf(processWrapResult.statusCode);
                    System.debug('@@@@## error auth prpayment');
                }   
                
                String jsonRespBody = JSON.serialize(processWrapResult); 
                res.responseBody = Blob.valueOf(jsonRespBody); 

        }
        else if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('ProcessPayment') ){
            // PROCESS TRANSACTION**
            System.debug('####@@@ process Payment 3');
            String jsonBody = req.RequestBody.toString();
            
            Plant_Orders_BC.processPayment_Wrap reqWrap = new Plant_Orders_BC.processPayment_Wrap().parse(jsonBody);
            Plant_Utility.responseWrapper processWrapResult = Plant_Orders_SC.processPayment(reqWrap);
            if(processWrapResult.statusCode=='200'){
                res.statusCode = Integer.valueOf(processWrapResult.statusCode);
                System.debug('@@@@## success payment');
            }
            else{
                res.statusCode = Integer.valueOf(processWrapResult.statusCode);
                System.debug('@@@@## error prpayment');
            }   
            
            String jsonRespBody = JSON.serialize(processWrapResult); 
            res.responseBody = Blob.valueOf(jsonRespBody); 
            
        }
        else 
		*/
        // AG - do we need this, or does GetOrderDetails do this?
		if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('getmeals')){
            //Get Order Meal Details
            
            String jsonBody = req.RequestBody.toString(); 
            
            Plant_Orders_BC.wrapOrder_MealReq meal_wrap = new Plant_Orders_BC.wrapOrder_MealReq().parse(jsonBody);
            
            Plant_Utility.responseWrapper preOrderWrapResult =  Plant_Orders_SC.getOrder_MealDetail(meal_wrap);
            if(preOrderWrapResult.statusCode=='200'){
                res.statusCode = Integer.valueOf(preOrderWrapResult.statusCode);
                System.debug('@@@@## success PM display');
            }
            else{
                res.statusCode = Integer.valueOf(preOrderWrapResult.statusCode);
                System.debug('@@@@## error PM display');
            }   
            
            String jsonRespBody = JSON.serialize(preOrderWrapResult); 
            res.responseBody = Blob.valueOf(jsonRespBody); 
        }
        
        else if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('updatemeals')){
            
            String jsonBody = req.RequestBody.toString(); 
            
            Plant_Orders_BC.CustomerMeal_UpdateReq_Wrapper meal_wrap = new Plant_Orders_BC.CustomerMeal_UpdateReq_Wrapper().parse(jsonBody);
            
            Plant_Utility.responseWrapper preOrderWrapResult =  Plant_Orders_SC.updateOrder_MealsList(meal_wrap);
            if(preOrderWrapResult.statusCode=='200'){
                res.statusCode = Integer.valueOf(preOrderWrapResult.statusCode);
                System.debug('@@@@## success PM display');
            }
            else{
                res.statusCode = Integer.valueOf(preOrderWrapResult.statusCode);
                System.debug('@@@@## error PM display');
            }   
            
            String jsonRespBody = JSON.serialize(preOrderWrapResult); 
            res.responseBody = Blob.valueOf(jsonRespBody); 
        }

        else if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('cancel')){
            String jsonBody = req.RequestBody.toString();
            Plant_Orders_BC.wrapOrder_MealReq reqWrap = new Plant_Orders_BC.wrapOrder_MealReq().parse(jsonBody);
            Plant_Utility.responseWrapper preOrderWrapResult = Plant_Orders_SC.cancelOrder_method_SC(reqWrap);
            if(preOrderWrapResult.statusCode=='200'){
                res.statusCode = Integer.valueOf(preOrderWrapResult.statusCode);
                System.debug('@@@@## success pO');
            }
            else{
                res.statusCode = Integer.valueOf(preOrderWrapResult.statusCode);
                System.debug('@@@@## error pO');
            }   
            
            String jsonRespBody = JSON.serialize(preOrderWrapResult); 
            res.responseBody = Blob.valueOf(jsonRespBody); 
        }
		// AG - what is this for??
        // else if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('getCardAuthenticationResult')){
        //     String jsonBody = req.RequestBody.toString();
        //     Plant_Orders_BC.getCardStatus reqWrap = new Plant_Orders_BC.getCardStatus().parse(jsonBody);
        //     Plant_Utility.responseWrapper preOrderWrapResult = Plant_Orders_SC.getCardAuthenticationResult_SC(reqWrap);
        //     if(preOrderWrapResult.statusCode=='200'){
        //         res.statusCode = Integer.valueOf(preOrderWrapResult.statusCode);
        //         System.debug('@@@@## success pO');
        //     }
        //     else{
        //         res.statusCode = Integer.valueOf(preOrderWrapResult.statusCode);
        //         System.debug('@@@@## error pO');
        //     }   
            
        //     String jsonRespBody = JSON.serialize(preOrderWrapResult); 
        //     res.responseBody = Blob.valueOf(jsonRespBody); 
        // }
        else if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('updatedeliverydate')){
            //Get Order Meal Details
            
            String jsonBody = req.RequestBody.toString(); 
            
            Plant_Orders_BC.OrderDeliveryDate_Wrap dDate_wrap = new Plant_Orders_BC.OrderDeliveryDate_Wrap().parse(jsonBody);
            
            Plant_Utility.responseWrapper preOrderWrapResult =  Plant_Orders_SC.changeOrderDeliveryDate_SC(dDate_wrap);
            if(preOrderWrapResult.statusCode=='200'){
                res.statusCode = Integer.valueOf(preOrderWrapResult.statusCode);
                System.debug('@@@@## success PM display');
            }
            else{
                res.statusCode = Integer.valueOf(preOrderWrapResult.statusCode);
                System.debug('@@@@## error PM display');
            }   
            
            String jsonRespBody = JSON.serialize(preOrderWrapResult); 
            res.responseBody = Blob.valueOf(jsonRespBody); 
        }
        else if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('updateshippingaddress')){
            String jsonBody = req.RequestBody.toString(); 
            Plant_Orders_BC.manageShipAddress jsonWrapper = new Plant_Orders_BC.manageShipAddress().parse(jsonBody);
            Plant_Utility.responseWrapper resultToken = Plant_Orders_SC.CustomerShippingAddress_SC(jsonWrapper);
            if(resultToken.statusCode=='200'){
                res.statusCode = Integer.valueOf(resultToken.statusCode);
                System.debug('@@@@## success dd');
            }
            else{
                res.statusCode = Integer.valueOf(resultToken.statusCode);
                System.debug('@@@@## error dd');
            } 
            String jsonRespBody = JSON.serialize(resultToken); 
            res.responseBody = Blob.valueOf(jsonRespBody); 
        }
        else{
            // RETURN ERROR
            String status='error';
            String statusCode='501';
            String msg='Not Implemented';
            
            List<String> response_List = new List<String>();
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(response_List));
            String jsonResponse =  JSON.serialize(responseWrap);
            res.responseBody = Blob.valueOf(jsonResponse);
        }       
    }
    
}