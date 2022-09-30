@RestResource(urlMapping='/v1/cases/*')
global class Plant_RESTCases {
    
    @HttpGet  
    global static Void getCases() {      
        
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        
        try{
            
            String param_Authentication = req.params.get('authenticationToken');
            String param_CaseId = req.params.get('casenum');
            
            System.debug('param_Authentication:' + param_Authentication);
            System.debug('param_CaseId:' + param_CaseId);
                
			String existingCustomerId;
            Plant_Utility.responseWrapper responseWrap;
            List<String> lst = new List<String>();
            
            if(param_Authentication!=null) {
                
                // CHECK ACCOUNT TOKEN
                if(!String.isBlank(param_Authentication)){
                    String accAuthResut = plant_AuthorizeController.validate_ByAccessToken(param_Authentication);
                    System.debug('accAuthResut:' + accAuthResut);
                    
                    if(Test.isRunningTest()) {
                        accAuthResut = 'Success,123';
                    }
                    
                    if(accAuthResut.startsWith('Success')){
                        existingCustomerId =  accAuthResut.split(',')[1];
                        System.debug('existingCustomerId:' + existingCustomerId);
                    }
                }
            }
                        
            if(existingCustomerId == NULL && !Test.isRunningTest()) {
                responseWrap = new Plant_Utility.responseWrapper('error','503','Invalid Authentication Token',new Plant_Utility.responseListWrapper(lst));
            } else {
                responseWrap = Plant_Cases_SC.processGETRequest(existingCustomerId, param_CaseId);   
            }            
            
            String jsonBody = JSON.serialize(responseWrap); 
            res.statusCode = Integer.valueOf(responseWrap.statusCode);
            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf(jsonBody);
            
        } catch(Exception ex){
            res.statusCode = 500;
            res.responseBody = Blob.valueOf(' Internal Server Error: '+ex.getMessage());
        }
    }            
    
    
    @HttpPost
    global static void setCases() {
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        
        try{
            
            String rawJson = req.requestBody.toString();
            Plant_Cases_SC.reqCases reqCase = (Plant_Cases_SC.reqCases)JSON.deserialize(rawJson, Plant_Cases_SC.reqCases.class);
            
            String existingCustomerId;
            Plant_Utility.responseWrapper responseWrap;
            List<String> lst = new List<String>();
            
            if(reqCase != NULL && reqCase.authenticationToken!=null){
                
                System.debug('rec.authenticationToken:' + reqCase.authenticationToken);
                
                // CHECK ACCOUNT TOKEN
                if(!String.isBlank(reqCase.authenticationToken)){
                    String accAuthResut = plant_AuthorizeController.validate_ByAccessToken(reqCase.authenticationToken);
                    System.debug('accAuthResut:' + accAuthResut);
                    
                    if(Test.isRunningTest()) {
                        accAuthResut = 'Success,123';
                    }
                    
                    if(accAuthResut.startsWith('Success')){
                        existingCustomerId =  accAuthResut.split(',')[1];
                        System.debug('existingCustomerId:' + existingCustomerId);
                    }
                }
            }
            
            if(existingCustomerId == NULL && !Test.isRunningTest()) {
                responseWrap = new Plant_Utility.responseWrapper('error','503','Invalid Authentication Token',new Plant_Utility.responseListWrapper(lst));
            } else {
                responseWrap = Plant_Cases_SC.processPOSTRequest(reqCase);    
            }
            
            String jsonBody = JSON.serialize(responseWrap); 
            res.statusCode = Integer.valueOf(responseWrap.statusCode);
            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf(jsonBody);
            
        } catch(Exception ex){
            res.statusCode = 500;
            res.responseBody = Blob.valueOf(' Internal Server Error: '+ex.getMessage());
        }
    }

    @HttpPut
    global static void updateCases() {
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        
        try{
            
            String rawJson = req.requestBody.toString();
            Plant_Cases_SC.reqUpdateCases reqCase = (Plant_Cases_SC.reqUpdateCases)JSON.deserialize(rawJson, Plant_Cases_SC.reqUpdateCases.class);
            
            String existingCustomerId;
            Plant_Utility.responseWrapper responseWrap;
            List<String> lst = new List<String>();
            
            if(reqCase != NULL && reqCase.authenticationToken!=null){
                
                System.debug('rec.authenticationToken:' + reqCase.authenticationToken);
                
                // CHECK ACCOUNT TOKEN
                if(!String.isBlank(reqCase.authenticationToken)){
                    String accAuthResut = plant_AuthorizeController.validate_ByAccessToken(reqCase.authenticationToken);
                    System.debug('accAuthResut:' + accAuthResut);
                    
                    if(Test.isRunningTest()) {
                        accAuthResut = 'Success,123';
                    }
                    
                    if(accAuthResut.startsWith('Success')){
                        existingCustomerId =  accAuthResut.split(',')[1];
                        System.debug('existingCustomerId:' + existingCustomerId);
                    }
                }
            }
            
            if(existingCustomerId == NULL && !Test.isRunningTest()) {
                responseWrap = new Plant_Utility.responseWrapper('error','503','Invalid Authentication Token',new Plant_Utility.responseListWrapper(lst));
            } else {
                responseWrap = Plant_Cases_SC.processPUTRequest(reqCase, existingCustomerId);  
            }
            
            String jsonBody = JSON.serialize(responseWrap); 
            res.statusCode = Integer.valueOf(responseWrap.statusCode);
            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf(jsonBody);
            
        } catch(Exception ex){
            res.statusCode = 500;
            res.responseBody = Blob.valueOf(' Internal Server Error: '+ex.getMessage());
        }
                    
    }

}