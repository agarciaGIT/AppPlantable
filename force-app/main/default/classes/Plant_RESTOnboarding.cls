/*
*   @Desciption     :   Plantable Meals API class
*   @Create date    :   21-04-2022
*   @Author         :   Bhagwan S
_________________________________________________________________________________________________________________________________________________________
@Test class     :   
*/

@RestResource(urlMapping='/v1/onboarding/*')
global class Plant_RESTOnboarding {
    
    // @ constructor
    global Plant_RESTOnboarding() {
        
    }
    
    // # POST:1
    @HttpPost 
    global static void postOnBoarding() {  
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;  
        res.addHeader('Content-Type', 'application/json');
        
        try{
            String reqResource_endString = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            
            if(reqResource_endString.toLowerCase()=='getstatus'){
                String reqJson = req.requestBody.toString();
                System.debug('@@@@# REQUEST JSON BODY: '+reqJson);

                Plant_OnBoarding_BC.autorize_AccountReq reqWrapper = new Plant_OnBoarding_BC.autorize_AccountReq().parse(reqJson);
                System.debug('@@@@# REQUEST wrapper BODY: '+reqWrapper);
                
                
                List<CustomerChargeEvent__e> inkEvents = new List<CustomerChargeEvent__e>();
                inkEvents.add(new CustomerChargeEvent__e(RecordID__c='a1W3J0000009t57'));
                
                List<Database.SaveResult> results = EventBus.publish(inkEvents);                
                
                // call get meal service class method
                Plant_Utility.responseWrapper respWrap = Plant_OnBoarding_SC.getOnBoardingStatus(reqWrapper);
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
            } else 
            if(reqResource_endString.toLowerCase()=='getlearningitems'){
                String reqJson = req.requestBody.toString();
                System.debug('@@@@# REQUEST JSON BODY: '+reqJson);

                Plant_OnBoarding_BC.autorize_OnBoardingReq reqWrapper = new Plant_OnBoarding_BC.autorize_OnBoardingReq().parse(reqJson);
                System.debug('@@@@# REQUEST wrapper BODY: '+reqWrapper);

                // call get meal service class method
                Plant_Utility.responseWrapper respWrap = Plant_OnBoarding_SC.getLearningItems(reqWrapper);
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
            } else 
            if(reqResource_endString.toLowerCase()=='setlearningday'){
                String reqJson = req.requestBody.toString();
                System.debug('@@@@# REQUEST JSON BODY: '+reqJson);

                Plant_OnBoarding_BC.autorize_OnBoardingReq reqWrapper = new Plant_OnBoarding_BC.autorize_OnBoardingReq().parse(reqJson);
                System.debug('@@@@# REQUEST wrapper BODY: '+reqWrapper);

                // call get meal service class method
                Plant_Utility.responseWrapper respWrap = Plant_OnBoarding_SC.setOnBoardingLearningDay(reqWrapper);
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
            } else 
            if(reqResource_endString.toLowerCase()=='setstatus'){
                String reqJson = req.requestBody.toString();
                System.debug('@@@@# REQUEST JSON BODY: '+reqJson);

                Plant_OnBoarding_BC.autorize_OnBoardingReq reqWrapper = new Plant_OnBoarding_BC.autorize_OnBoardingReq().parse(reqJson);
                System.debug('@@@@# REQUEST wrapper BODY: '+reqWrapper);

                // call get meal service class method
                Plant_Utility.responseWrapper respWrap = Plant_OnBoarding_SC.setOnBoardingStatus(reqWrapper);
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
            } else 
            if(reqResource_endString.toLowerCase()=='getonBoardingcalls'){
                String reqJson = req.requestBody.toString();
                System.debug('>>># REQUEST JSON BODY: '+reqJson);

                Plant_OnBoarding_BC.autorize_AccountReq reqWrapper = new Plant_OnBoarding_BC.autorize_AccountReq().parse(reqJson);
                System.debug('>>># REQUEST wrapper BODY: '+reqWrapper);

                // call get meal service class method
                Plant_Utility.responseWrapper respWrap = Plant_OnBoarding_SC.getOnBoardingCalls(reqWrapper);
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
            } else 
            if(reqResource_endString.toLowerCase()=='setcalldatetime'){
                String reqJson = req.requestBody.toString();
                System.debug('>>># REQUEST JSON BODY: '+reqJson);

                Plant_OnBoarding_BC.autorize_OnBoardingReq reqWrapper = new Plant_OnBoarding_BC.autorize_OnBoardingReq().parse(reqJson);
                System.debug('>>># REQUEST wrapper BODY: '+reqWrapper);

                // call get meal service class method
                Plant_Utility.responseWrapper respWrap = Plant_OnBoarding_SC.setOnBoardingCallDateTime(reqWrapper);
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
            } else 
            if(reqResource_endString.toLowerCase()=='setquestion'){
                String reqJson = req.requestBody.toString();
                System.debug('@@@@# REQUEST JSON BODY: '+reqJson);

                Plant_OnBoarding_BC.autorize_OnBoardingReq reqWrapper = new Plant_OnBoarding_BC.autorize_OnBoardingReq().parse(reqJson);
                System.debug('@@@@# REQUEST wrapper BODY: '+reqWrapper);

                // call get meal service class method
                Plant_Utility.responseWrapper respWrap = Plant_OnBoarding_SC.setOnBoardingQuestion(reqWrapper);
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
            } else 
            if(reqResource_endString.toLowerCase()=='getquestions'){
                String reqJson = req.requestBody.toString();
                System.debug('@@@@# REQUEST JSON BODY: '+reqJson);

                Plant_OnBoarding_BC.autorize_OnBoardingReq reqWrapper = new Plant_OnBoarding_BC.autorize_OnBoardingReq().parse(reqJson);
                System.debug('@@@@# REQUEST wrapper BODY: '+reqWrapper);

                // call get meal service class method
                Plant_Utility.responseWrapper respWrap = Plant_OnBoarding_SC.getOnBoardingQuestions(reqWrapper);
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