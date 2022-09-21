/*
*   @Desciption     :   Plantable Authorization API class
*   @Create date    :   20-06-2022
*   @Author         :   Bhagwan S
_________________________________________________________________________________________________________________________________________________________
@Test class         :   
*/

@RestResource(urlMapping='/v1/authenticate/*')
global class plant_RESTAuthorizeController {
    
    // Default Constructor
    global plant_RESTAuthorizeController(){
        
    }
    
    @Httpput
    global static void getAuthorizationToken(){
        
        RestRequest req =  RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type','application/json');
        try{
            
            String requestJson = req.requestBody.toString();
            
            if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('getaccesstoken')){
                requestJson=requestJson.replace('}', ',"refreshReq": false}');
                plant_AuthorizeController.userInfoReqWrap jsonWrapper = new plant_AuthorizeController.userInfoReqWrap().parse(requestJson);
                System.debug('@@@@# REQUEST JSON BODY: '+requestJson);
                System.debug('@@@@# REQUEST wrapper BODY: '+jsonWrapper);
                
                Plant_Utility.responseWrapper resultToken = plant_AuthorizeController_SC.getAuthenticationTokenSC(jsonWrapper);
                System.debug('@@@@## resultToken: ' + resultToken );
                
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
            
            else if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('generateaccesstoken')){
                plant_AuthorizeController.accessTokenReqWrap jsonWrapper = new plant_AuthorizeController.accessTokenReqWrap().parse(requestJson);
                System.debug('@@@@# REQUEST JSON BODY: '+requestJson);
                System.debug('@@@@# REQUEST wrapper BODY: '+jsonWrapper);
                
                Plant_Utility.responseWrapper resultToken = plant_AuthorizeController_SC.generateAccessTokenSC(jsonWrapper);
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
            else if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('refreshaccesstoken')){
                requestJson=requestJson.replace('}', ',"refreshReq": true}');
                plant_AuthorizeController.userInfoReqWrap jsonWrapper = new plant_AuthorizeController.userInfoReqWrap().parse(requestJson);
                System.debug('@@@@# REQUEST JSON BODY: '+requestJson);
                System.debug('@@@@# REQUEST wrapper BODY: '+jsonWrapper);
                
                Plant_Utility.responseWrapper resultToken = plant_AuthorizeController_SC.getAuthenticationTokenSC(jsonWrapper);
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
            else if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('changepassword')){
                plant_AuthorizeController.changePassword_wrap jsonWrapper = new plant_AuthorizeController.changePassword_wrap().parse(requestJson);
                Plant_Utility.responseWrapper resultToken = plant_AuthorizeController_SC.changePassword_SC(jsonWrapper);
                if(resultToken.statusCode=='200'){
                    res.statusCode = Integer.valueOf(resultToken.statusCode);
                    
                }
                else{
                    res.statusCode = Integer.valueOf(resultToken.statusCode);
                    System.debug('@@@@## error dd');
                }  
                String jsonRespBody = JSON.serialize(resultToken); 
                res.responseBody = Blob.valueOf(jsonRespBody); 
            }

            else if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('expiretoken')){
                plant_AuthorizeController.ExpireToken_wrap jsonWrapper = new plant_AuthorizeController.ExpireToken_wrap().parse(requestJson);
                Plant_Utility.responseWrapper resultToken = plant_AuthorizeController_SC.expireAuthorizationToken_SC(jsonWrapper);
                if(resultToken.statusCode=='200'){
                    res.statusCode = Integer.valueOf(resultToken.statusCode);
                    
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
            
            
            
        }catch(Exception ex){
            System.debug('@@@@@@ exception encounter => '+ex+' MSG: '+ex.getMessage()+' LINE: '+ex.getLineNumber()+' CAUSE: '+ex.getCause());
            Plant_Utility.responseWrapper respWrapErr = new Plant_Utility.responseWrapper('error','500',ex.getMessage(),new Plant_Utility.responseListWrapper(new List<String>()));
            res.statusCode = 500;
            String jsonErrRespBody = JSON.serialize(respWrapErr); 
            res.responseBody = Blob.valueOf(jsonErrRespBody);
        } 
        
    }
}