/*
*   @Desciption     :   Plantable Meals API class
*   @Create date    :   9-16-2022
*   @Author         :   Alberto Garcia
_________________________________________________________________________________________________________________________________________________________
@Test class     :   
*/

@RestResource(urlMapping='/v1/appanalytics/*')
global class Plant_RESTAppAnalytics {
    
    // @ constructor
    global Plant_RESTAppAnalytics() {
        
    }
    
    // # POST:1
    @HttpPost 
    global static void postAppAnalytics() {  
        
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;  
        res.addHeader('Content-Type', 'application/json');
        
        try{
            String reqResource_endString = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            
            if(reqResource_endString.toLowerCase()=='login'){
                String reqJson = req.requestBody.toString();
                System.debug('@@@@# REQUEST JSON BODY: '+reqJson);

                Plant_AppAnalytics_BC.autorize_AccountReq reqWrapper = new Plant_AppAnalytics_BC.autorize_AccountReq().parse(reqJson);
                System.debug('@@@@# REQUEST wrapper BODY: '+reqWrapper);
                
				// call get meal service class method
                Plant_Utility.responseWrapper respWrap = Plant_AppAnalytics_SC.setLastLogin(reqWrapper);
                if(respWrap.statusCode=='200'){
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## success');
                }
                else{
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## error:' + res.statusCode);
                }   
                
                String jsonRespBody = JSON.serialize(respWrap); 
                System.debug('@@@@## jsonRespBody:' + jsonRespBody);
                
                res.responseBody = Blob.valueOf(jsonRespBody);                 
            }
        } catch(Exception ex){
            System.debug('@@@@@@ exception encounter => '+ex+' MSG: '+ex.getMessage()+' LINE: '+ex.getLineNumber()+' CAUSE: '+ex.getCause());
            Plant_Utility.responseWrapper respWrapErr = new Plant_Utility.responseWrapper('error','500',ex.getMessage(),new Plant_Utility.responseListWrapper(new List<String>()));
            res.statusCode = 500;
            String jsonErrRespBody = JSON.serialize(respWrapErr); 
            res.responseBody = Blob.valueOf(jsonErrRespBody);
        }     
    }

}