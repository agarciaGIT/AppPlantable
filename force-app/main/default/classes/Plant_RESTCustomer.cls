/*
*   @Desciption     :   Plantable Customer API class
*   @Create date    :   29-06-2022
*   @Author         :   Bhagwan S
_________________________________________________________________________________________________________________________________________________________
@Test class     :   
*/


@RestResource(urlMapping='/v1/customer/*')
global class Plant_RESTCustomer {
    
    //Default Constructor
    global Plant_RESTCustomer() {
        
    }	
   
    @HttpGet    //get request to get customer Info
    global static void customerInfo(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type','application/json');
        if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('profile')){
            String param_Authentication = req.params.get('authenticationToken');
            if(!String.isBlank(param_Authentication)){
                
                Plant_Utility.responseWrapper respWrap=Plant_Customer_SC.getCustomerInfo_SC(param_Authentication);
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
        else if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('paymentmethods')){
            //CALL DISPLAY PAYMENT METHOD OF AN ACCOUNT
            
            String param_Authentication = req.params.get('authenticationToken');
            if(param_Authentication!=null){
                Plant_Utility.responseWrapper preOrderWrapResult =  Plant_Customer_SC.getAccountPaymentDetail_SC(param_Authentication);
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
             
        }
        else if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('shippingaddresses')){
            String param_Authentication = req.params.get('authenticationToken');
            if(param_Authentication!=null){
                Plant_Utility.responseWrapper respWrap = Plant_Customer_SC.getShippingAddresstDetail_SC(param_Authentication);
                if(respWrap.statusCode=='200'){
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## Shipping Search ');
                }
                else{
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## error ingred');
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

    //Method to create Account
    @HttpPost
    global static void createAccount(){
        
        RestRequest req =  RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type','application/json');

        try{
            String requestJson = req.requestBody.toString();

            if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('addaccount')){
                Plant_Customer_BC.createAccount_wrap jsonWrapper = new Plant_Customer_BC.createAccount_wrap().parse(requestJson);
                Plant_Utility.responseWrapper respWrap = Plant_Customer_SC.createAccount_SC(jsonWrapper);
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
            else if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('addshippingaddress')){
                Plant_Customer_BC.addCustomerAddreeeWrap jsonWrapper = new Plant_Customer_BC.addCustomerAddreeeWrap().parse(requestJson);
                Plant_Utility.responseWrapper respWrap = Plant_Customer_SC.addCustomerAddress_SC(jsonWrapper);
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
            
            else if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('addpaymentmethod')){
                Plant_Customer_BC.addCustomerPaymentWrap jsonWrapper = new Plant_Customer_BC.addCustomerPaymentWrap().parse(requestJson);
                Plant_Utility.responseWrapper respWrap = Plant_Customer_SC.addCustomerPaymentMethod_SC(jsonWrapper);
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
    
    
    
    //Method to Update or get Account Related Details
    @HttpPut
    global static void updateCustomerDetails(){
        
        RestRequest req =  RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type','application/json');
        try{
            
            String requestJson = req.requestBody.toString();
            
            if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('profile')){
                
                Plant_Customer_BC.AccountInfo_Wrap jsonWrapper = new Plant_Customer_BC.AccountInfo_Wrap().parse(requestJson);
                Plant_Utility.responseWrapper resultToken = Plant_Customer_SC.updateAccount(jsonWrapper);
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
            else if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('shippingaddress')){
                System.debug('#### update shipping address ');
                //String requestJson = req.requestBody.toString();
                requestJson=requestJson.replace('}', ',"isCustomer": false}');
                Plant_Customer_BC.manageShipAddress_wrap jsonWrapper = new Plant_Customer_BC.manageShipAddress_wrap().parse(requestJson);
                System.debug('@@@@# update  REQUEST JSON BODY: '+requestJson);
                System.debug('@@@@# update REQUEST wrapper BODY: '+jsonWrapper);
                
                Plant_Utility.responseWrapper addrsUpdt_resultList = Plant_Customer_SC.updateShippingAddress_SC(jsonWrapper);
                if(addrsUpdt_resultList.statusCode=='200'){
                    res.statusCode = Integer.valueOf(addrsUpdt_resultList.statusCode);
                    System.debug('@@@@## success dd');
                }
                else{
                    res.statusCode = Integer.valueOf(addrsUpdt_resultList.statusCode);
                    System.debug('@@@@## error dd');
                }   
                
                String jsonRespBody = JSON.serialize(addrsUpdt_resultList); 
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

    // delete: 1
    @HttpDelete
    global static void deleteShippingAddress(){
        
        RestRequest req =  RestContext.request;
        RestResponse res = RestContext.response; 
        res.addHeader('Content-Type','application/json');
        try{

            if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('shippingaddress')){
                String addressJson = req.requestBody.toString();
                Plant_Customer_BC.wrapReq_class reqWrapper = new Plant_Customer_BC.wrapReq_class().parse(addressJson);
                // call service class method
                Plant_Utility.responseWrapper respWrap = Plant_Customer_SC.deleteShippingAddress_SC(reqWrapper);
                if(respWrap.statusCode=='200'){
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## success');
                }
                else{
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## error');
                }   
                
                String jsonRespBody = JSON.serialize(respWrap); 
                res.responseBody = Blob.valueOf(jsonRespBody);  
            }

            else if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('paymentmethod')){
                String addressJson = req.requestBody.toString();
                Plant_Customer_BC.delCustomerPaymentWrap reqWrapper = new Plant_Customer_BC.delCustomerPaymentWrap().parse(addressJson);
                // call service class method
                Plant_Utility.responseWrapper respWrap = Plant_Customer_SC.delCustomerPaymentMethod_SC(reqWrapper);
                if(respWrap.statusCode=='200'){
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## success : '+respWrap);
                }
                else{
                    System.debug('@@@@## error : '+respWrap);
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## error : '+respWrap);
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
            Plant_Utility.responseWrapper respWrapErr = new Plant_Utility.responseWrapper('error','500',ex.getMessage(),new Plant_Utility.responseListWrapper(new List<String>()));
            res.statusCode = 500;
            String jsonErrRespBody = JSON.serialize(respWrapErr); 
            res.responseBody = Blob.valueOf(jsonErrRespBody);
        } 
        
    }
    
}