/*
*   @Desciption     :   Plantable Shipping API class
*   @Create date    :   21-04-2022
*   @Author         :   Bhagwan S
_________________________________________________________________________________________________________________________________________________________
@Test class     :   
*/

@RestResource(urlMapping='/v1/shipping/*')
global class Plant_RESTShipping {
    
    // @ Constructor
    global Plant_RESTShipping() {
        
    }
    
    // put: 1
    @HttpPut
    global static void checkDeliveryDate(){
        
        RestRequest req =  RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type','application/json');
        
        System.debug('#### check=> '+req.requestURI.lastIndexOf('/')+1);
        System.debug('#### check substring => '+req.requestURI.substring(req.requestURI.lastIndexOf('/')+1));      
        
        try{
            if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('getdeliverydates')){
                String requestJson = req.requestBody.toString();
                Plant_Shipping_BC.deliveryDateWrapper jsonWrapper = new Plant_Shipping_BC.deliveryDateWrapper().parse(requestJson);
                System.debug('@@@@# REQUEST JSON BODY: '+requestJson);
                System.debug('@@@@# REQUEST wrapper BODY: '+jsonWrapper);
                
                Plant_Utility.responseWrapper dd_resultList = Plant_Shipping_SC.getDeliveryDate(jsonWrapper);
                if(dd_resultList.statusCode=='200'){
                    res.statusCode = Integer.valueOf(dd_resultList.statusCode);
                    System.debug('@@@@## success dd');
                }
                else{
                    res.statusCode = Integer.valueOf(dd_resultList.statusCode);
                    System.debug('@@@@## error dd');
                }   
                
                String jsonRespBody = JSON.serialize(dd_resultList); 
                res.responseBody = Blob.valueOf(jsonRespBody); 
            }
            else if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('getshippingstates')){
                
                Plant_Utility.responseWrapper dd_resultList = Plant_Shipping_SC.getAvailableShippingStates();
                if(dd_resultList.statusCode=='200'){
                    res.statusCode = Integer.valueOf(dd_resultList.statusCode);
                    System.debug('@@@@## success dd');
                }
                else{
                    res.statusCode = Integer.valueOf(dd_resultList.statusCode);
                    System.debug('@@@@## error dd');
                }   
                
                String jsonRespBody = JSON.serialize(dd_resultList); 
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
    
    // get: 1
    /*
    @HttpGet  
    global static void getShippingAddress() { 
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;  
        res.addHeader('Content-Type', 'application/json');
        String param_ShippingId='';
        
        param_ShippingId = req.params.get('Id');
        
        try{ 
            if(param_ShippingId!='' && req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('ShippingAddress')){
                Plant_Utility.responseWrapper respWrap = Plant_Shipping_Sc.getShippingAddress(param_ShippingId);
                if(respWrap.statusCode=='200'){
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## success Shipping Search ');
                }
                else{
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## error ingred');
                }    
                String jsonRespBody = JSON.serialize(respWrap); 
                res.responseBody = Blob.valueOf(jsonRespBody); 
            }
            
            else {
                Plant_Utility.responseWrapper respWrapErr = new Plant_Utility.responseWrapper('error','500','Service not found! Invalid endpoint',new Plant_Utility.responseListWrapper(new List<String>()));
                res.statusCode = 500;
                String jsonErrRespBody = JSON.serialize(respWrapErr); 
                res.responseBody = Blob.valueOf(jsonErrRespBody);
            }
        }
        catch(Exception ex){
            System.debug('@@@@@@ exception encounter => '+ex+' MSG: '+ex.getMessage()+' LINE: '+ex.getLineNumber()+' CAUSE: '+ex.getCause());
            Plant_Utility.responseWrapper respWrapErr = new Plant_Utility.responseWrapper('error','500',ex.getMessage(),new Plant_Utility.responseListWrapper(new List<String>()));
            res.statusCode = 500;
            String jsonErrRespBody = JSON.serialize(respWrapErr); 
            res.responseBody = Blob.valueOf(jsonErrRespBody);
        } 
        
    }
*/
}