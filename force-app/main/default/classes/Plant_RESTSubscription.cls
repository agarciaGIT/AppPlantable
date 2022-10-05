/*
*   @Desciption     :   Plantable (Subscription Rest class)
*                       

*   @Create date    :   12-09-2022
*   @Author         :   Bhagwan S
_________________________________________________________________________________________________________________________________________________________
    @Test class     :   
*/

@RestResource(urlMapping='/v1/subscriptions/*')
global class Plant_RESTSubscription {
    public Plant_RESTSubscription() {

    }

    @HttpGet    //get subscription Details
    global static void subScriptionDetails(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type','application/json');
        
        if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('details')){
            String param_Authentication = req.params.get('authenticationToken');
            String param_SubscriptionId = req.params.get('subscriptionId');
            if(!String.isBlank(param_Authentication) && !String.isBlank(param_SubscriptionId)){
                
                Plant_Utility.responseWrapper respWrap=Plant_Subscriptions_sc.getSubscriptionDetails_SC(param_Authentication, param_SubscriptionId);
                if(respWrap.statusCode=='200'){
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## dd Success');
                }else{
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## dd error ');
                }   
                String jsonResBody = JSON.serialize(respWrap); 
                res.responseBody = Blob.valueOf(jsonResBody); 
            }
        }

        else if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('list')){
            String param_Authentication = req.params.get('authenticationToken');
            if(!String.isBlank(param_Authentication)){
                Plant_Utility.responseWrapper respWrap = Plant_Subscriptions_SC.getSubscriptionInfo_SC(param_Authentication);
                if(respWrap.statusCode=='200'){
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## dd Success');
                }
                else{
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## dd error ');
                }    
                String jsonRespBody = JSON.serialize(respWrap); 
                res.responseBody = Blob.valueOf(jsonRespBody); 
            }
            
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

    //Method to Update or get Account Related Details
    @HttpPut
    global static void subscriptionUpdate(){
        
        RestRequest req =  RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type','application/json');
        try{
            
            String requestJson = req.requestBody.toString();
            if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('deliverydate')){
                Plant_Subscriptions_BC.Ddate_UpdateWrap jsonWrapper = new Plant_Subscriptions_BC.Ddate_UpdateWrap().parse(requestJson);
                Plant_Utility.responseWrapper respWrap = Plant_Subscriptions_SC.customerDeliveryDate_SC(jsonWrapper);
                if(respWrap.statusCode=='200'){
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## delivery add ');
                }
                else{
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## dd error ');
                }    
                String jsonRespBody = JSON.serialize(respWrap); 
                res.responseBody = Blob.valueOf(jsonRespBody); 
            }
            
            else if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('paymentmethod')){
                Plant_Subscriptions_BC.subsption_PaymentUpdate_Wrap jsonWrapper = new Plant_Subscriptions_BC.subsption_PaymentUpdate_Wrap().parse(requestJson);
                Plant_Utility.responseWrapper respWrap = Plant_Subscriptions_SC.setSubscription_PaymentDetails_SC(jsonWrapper);
                if(respWrap.statusCode=='200'){
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## delivery add ');
                }
                else{
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## dd error ');
                }    
                String jsonRespBody = JSON.serialize(respWrap); 
                res.responseBody = Blob.valueOf(jsonRespBody); 
            }
            
            
            else if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('meals')){
                requestJson=requestJson.replace('}]', ',"mealSelectionMealId": ""}]');
                Plant_Subscriptions_BC.subsption_MealUpdate_Wrap jsonWrapper = new Plant_Subscriptions_BC.subsption_MealUpdate_Wrap().parse(requestJson);
                Plant_Utility.responseWrapper respWrap = Plant_Subscriptions_SC.setSubscription_Meals_SC(jsonWrapper);
                if(respWrap.statusCode=='200'){
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## delivery add ');
                }
                else{
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## dd error ');
                }    
                String jsonRespBody = JSON.serialize(respWrap); 
                res.responseBody = Blob.valueOf(jsonRespBody); 
            }
            else if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('shippingaddress')){
                
                Plant_Subscriptions_BC.subsption_AddressUpdate_Wrap jsonWrapper = new Plant_Subscriptions_BC.subsption_AddressUpdate_Wrap().parse(requestJson);
                Plant_Utility.responseWrapper respWrap = Plant_Subscriptions_SC.setSubscription_Address_SC(jsonWrapper);
                if(respWrap.statusCode=='200'){
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## delivery add ');
                }
                else{
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## dd error ');
                }    
                String jsonRespBody = JSON.serialize(respWrap); 
                res.responseBody = Blob.valueOf(jsonRespBody); 
            }
            else if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('status') ){
                // MODIFY SUBSN**
                System.debug('####@@@ modify Subscription');
                String jsonBody = req.RequestBody.toString();
                
                Plant_Subscriptions_BC.SubscrptionWrap reqWrap = new Plant_Subscriptions_BC.SubscrptionWrap().parse(jsonBody);
                Plant_Utility.responseWrapper processWrapResult = Plant_Subscriptions_SC.updateSubscription(reqWrap);
                if(processWrapResult.statusCode=='200'){
                    res.statusCode = Integer.valueOf(processWrapResult.statusCode);
                    System.debug('@@@@## success modified subs');
                }
                else{
                    res.statusCode = Integer.valueOf(processWrapResult.statusCode);
                    System.debug('@@@@## error  modified subs');
                }   
                
                String jsonRespBody = JSON.serialize(processWrapResult); 
                res.responseBody = Blob.valueOf(jsonRespBody); 
                
            }

            //Desc To void Transaction:
            else if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('voidtransaction')){
                
                Plant_Subscriptions_BC.voidTransaction_Wrap jsonWrapper = new Plant_Subscriptions_BC.voidTransaction_Wrap().parse(requestJson);
                Plant_Utility.responseWrapper resultToken = Plant_Subscriptions_SC.voidTransaction_SC(jsonWrapper);
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
            
            else if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('authorizecard')){
                
                Plant_Subscriptions_BC.CardAuthorize_ReqWrap jsonWrapper = new Plant_Subscriptions_BC.CardAuthorize_ReqWrap().parse(requestJson);
                Plant_Utility.responseWrapper resultToken = Plant_Subscriptions_SC.setSubscription_PaymentDetailsSetp2_SC(jsonWrapper);
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
            else if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('cancelsubscription')){
                
                Plant_Subscriptions_BC.cancelSubscrptionWrap jsonWrapper = new Plant_Subscriptions_BC.cancelSubscrptionWrap().parse(requestJson);
                Plant_Utility.responseWrapper respWrap = Plant_Subscriptions_SC.cancelSubscription_SC(jsonWrapper);
                if(respWrap.statusCode=='200'){
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## delivery add ');
                }
                else{
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## dd error ');
                }    
                String jsonRespBody = JSON.serialize(respWrap); 
                res.responseBody = Blob.valueOf(jsonRespBody); 
            }
            else if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('confirmcancelsubscription')){
                
                Plant_Subscriptions_BC.cancelSubscrptionWrap jsonWrapper = new Plant_Subscriptions_BC.cancelSubscrptionWrap().parse(requestJson);
                Plant_Utility.responseWrapper respWrap = Plant_Subscriptions_SC.confirmCancelSubscription_SC(jsonWrapper);
                if(respWrap.statusCode=='200'){
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## delivery add ');
                }
                else{
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## dd error ');
                }    
                String jsonRespBody = JSON.serialize(respWrap); 
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
        }catch(Exception ex){
            System.debug('@@@@@@ exception encounter => '+ex+' MSG: '+ex.getMessage()+' LINE: '+ex.getLineNumber()+' CAUSE: '+ex.getCause());
            Plant_Utility.responseWrapper respWrapErr = new Plant_Utility.responseWrapper('error','500',ex.getMessage()+' '+ex.getCause(),new Plant_Utility.responseListWrapper(new List<String>()));
            res.statusCode = 500;
            String jsonErrRespBody = JSON.serialize(respWrapErr); 
            res.responseBody = Blob.valueOf(jsonErrRespBody);
        } 
    }

}