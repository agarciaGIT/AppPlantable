public class suggesticClass {

    public class createMealPlanData {
        Boolean success;
        List<API_Request__c> lstAddAPIReq;        
    }
    

    public class createMealPlanRespRecipeSuc {
        public Boolean success;
    }

    public class createMealPlanRespRecipe {
        public createMealPlanRespRecipeSuc generateSimpleMealPlan;
    }

    public class createMealPlanResp {
        public createMealPlanRespRecipe data;
    }

    
    public class swapMealPlanRet {
        Boolean success;
        List<API_Request__c> lstAddAPIReq;
    }

    public class swapMealPlanRespRecipeSuc {
        public Boolean success;
    }

    public class swapMealPlanRespRecipe {
        public swapMealPlanRespRecipeSuc swapMealPlanRecipe;
    }

    public class swapMealPlanResp {
        public swapMealPlanRespRecipe data;
    }


    
    public class getMealPlanRespDataMeal {
        string id;
        string meal;
    }

    public class getMealPlanRespDataMealPlan {
        public Integer day;
        public String dates;
        public List<getMealPlanRespDataMeal> meals;
    }

    public class getMealPlanRespData {
        public List<getMealPlanRespDataMealPlan> mealPlan;
    }
    
    public class getMealPlanResp {
        public  getMealPlanRespData data;
    }
    
    public class getMealPlanData {
        List<API_Request__c> lstAddAPIReq ;
        getMealPlanResp gmpd;
    }
    
    
    public class resetPasswordRespDataRP {
        public Boolean success;
        public String message;
    }
    
    public class resetPasswordRespData {
        public resetPasswordRespDataRP resetPassword;
    }
    
    public class resetPasswordResp {
        public  resetPasswordRespData data;
    }
    
    public class getPasswordTokenRespDataRRP {
        String success;
        String message;
        String resetPasswordCode;
    }
    
    public class getPasswordTokenRespData {
        getPasswordTokenRespDataRRP requestResetPassword;
    }
    
    public class getPasswordTokenResp {
        getPasswordTokenRespData data;
    }
    
    public class reqGraphQl {
        String query;
    }

    public class respGetUserSearchProfile {
        String id; 
        String userId; 
        String programName; 
    }
    
    public class respGetUserData {
        respGetUserSearchProfile searchProfile; 
    }
    
    public class respGetUser {
        respGetUserData data; 
    }
    
    public class reqAddUser {
        String name;
        String email;
        Boolean email_password_notification;
        //String restrictions;
        //String extra_data;
    }

    public class respAddUser {
        String name;
        String email;
        Boolean email_password_notification;
        String extra_data;
        String user_id;
    }
    
    public class reqMeals {
        String meal_id;
        Integer qantity;
    }
    
    public class reqSendOrder {
        String user_id;
        String date_time;
        List<reqMeals> meals;
    }
    
    public class getPasswordTokenData {
        List<API_Request__c> lstAddAPIReq ;
        String pwdToken;
    }
    
    
    public static HttpResponse sendRequest(String endpoint, String authToken, String jsonBody, String userId) {
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response;
        
        system.debug('authToken:' + authToken);
        system.debug('endpoint:' + endpoint);
        system.debug('jsonBody:' + jsonBody);
        system.debug('userId:' + userId);
        
        request.setEndPoint(endpoint);
        request.setMethod('POST');        
        request.setBody(jsonBody);
        
        String authorizationHeader = 'Token ' + authToken;
        
        request.setHeader('Authorization', authorizationHeader);     
        request.setHeader('Content-Type', 'application/json');     
        request.setHeader('Suggestic-Partner', 'plantable');     
        
        if(userId != NULL) {
            request.setHeader('sg-user', userId);     
        }
        
        Integer statusCode;
        if(!Test.isRunningTest()){
            response = httpProtocol.send(request);
            statusCode = response.getStatusCode();
        } else {
            response = new HttpResponse();
            statusCode = 200;
        }
        system.debug('statusCode:' + String.valueOf(statusCode));
        return response;        
    }        

    @future(callout=true)
    public static void deleteUser(String userId) {
        
        List<Suggestic_Settings__c> lstCust = Suggestic_Settings__c.getAll().values();
        system.debug('lstCust:' + lstCust);
        if(lstCust != NULL && lstCust.size() > 0) {
            Suggestic_Settings__c settings = lstCust[0];
            
            // Send 
            reqGraphQl rss = new reqGraphQl();
            rss.query = '{"query":"mutation { deleteMyProfile { success  } }"}';
            system.debug('deleteUser:' + rss);
            String jsonBody = JSON.serialize(rss); 
            
            API_Request__c apiReq1 = new API_Request__c(Raw_Request__c=jsonBody, Request_Type__c='Suggestic Outbound');
            apiReq1.Request_Headers__c = 'sg-user: ' + userId;
            HttpResponse resp = sendRequest(settings.GraphQL_Endpoint__c, settings.AuthToken__c, jsonBody, userId);
        }

    }
    
    
    public static createMealPlanData createMealPlan(String userId, List<API_Request__c> lstAddAPIReq) {
     
        createMealPlanData cmpd = new createMealPlanData();
        cmpd.lstAddAPIReq = lstAddAPIReq;
     
        Suggestic_Settings__c settings;
        List<Suggestic_Settings__c> lstCust = Suggestic_Settings__c.getAll().values();
        system.debug('lstCust:' + lstCust);
        
        if(lstCust != NUll && lstCust.size() > 0) {
            settings = lstCust[0];
        } else {
            return cmpd;
        }        
        
        // Send 
        reqGraphQl rss = new reqGraphQl();
        rss.query = 'mutation { generateSimpleMealPlan { success } }';
        system.debug('generateSimpleMealPlan:' + rss);
        String jsonBody = JSON.serialize(rss); 
        
        API_Request__c apiReq1 = new API_Request__c(Raw_Request__c=jsonBody, Request_Type__c='Suggestic Outbound');
        apiReq1.Request_Headers__c = 'sg-user: ' + userId;
        HttpResponse resp = sendRequest(settings.GraphQL_Endpoint__c, settings.AuthToken__c, jsonBody, userId);
        
        String body=NULL;
        Integer statusCode=NULL;
        if(!Test.isRunningTest()){
            statusCode = resp.getStatusCode();
            body = resp.getBody();
        } else {
            statusCode = 201;
            body = '{"data":{"generateSimpleMealPlan":{"success":true,"errors":[]}}}';
        }
        System.debug('body:' + body);
        apiReq1.Response__c = String.valueOf(statusCode) + ':' + body;
        cmpd.lstAddAPIReq.add(apiReq1);
        
        // Get Meal Plan Data
        createMealPlanResp cmpr = (createMealPlanResp)JSON.deserialize(body, createMealPlanResp.class);
        if(cmpr != NULL && cmpr.data != NULL && cmpr.data.generateSimpleMealPlan != NULL && cmpr.data.generateSimpleMealPlan.success != NULL) {
            cmpd.success = cmpr.data.generateSimpleMealPlan.success;
        }
        
        return cmpd;
    }        
    
    
    public static getMealPlanData getMealPlan(String userId, List<API_Request__c> lstAddAPIReq) {
     
        getMealPlanData gmpd = new getMealPlanData();
        gmpd.lstAddAPIReq = lstAddAPIReq;
     
        Suggestic_Settings__c settings;
        List<Suggestic_Settings__c> lstCust = Suggestic_Settings__c.getAll().values();
        system.debug('lstCust:' + lstCust);
        
        if(lstCust != NUll && lstCust.size() > 0) {
            settings = lstCust[0];
        } else {
            return gmpd;
        }        
        
        // Send 
        reqGraphQl rss = new reqGraphQl();
        rss.query = '{ mealPlan{ day date(useDatetime:false) calories meals{ id calories meal numOfServings recipe{ name numberOfServings nutrientsPerServing{ calories } } } } }';
        system.debug('mealPlan:' + rss);
        String jsonBody = JSON.serialize(rss); 
        
        API_Request__c apiReq1 = new API_Request__c(Raw_Request__c=jsonBody, Request_Type__c='Suggestic Outbound');
        apiReq1.Request_Headers__c = 'sg-user: ' + userId;
        HttpResponse resp = sendRequest(settings.GraphQL_Endpoint__c, settings.AuthToken__c, jsonBody, userId);
        
        String body=NULL;
        Integer statusCode=NULL;
        if(!Test.isRunningTest()){
            statusCode = resp.getStatusCode();
            body = resp.getBody();
        } else {
            statusCode = 201;
            body = '{"data": {"mealPlan": [{"day":1,"dates":"","meals":[{"meal":"Lunch"}]}]}}';
        }
        System.debug('body:' + body);
        apiReq1.Response__c = String.valueOf(statusCode) + ':' + body;
        gmpd.lstAddAPIReq.add(apiReq1);
        
        // Get Meal Plan Data
        getMealPlanResp gmpr = (getMealPlanResp)JSON.deserialize(body, getMealPlanResp.class);
        gmpd.gmpd = gmpr;
        
        return gmpd;
    }    
    
    
    public static swapMealPlanRet swapMealPlan(String userID, String setMeal, String curMeal, List<API_Request__c> lstAddAPIReq) {
     
        swapMealPlanRet smpr = new swapMealPlanRet();
        smpr.success = False;
        smpr.lstAddAPIReq = lstAddAPIReq;
     
        Suggestic_Settings__c settings;
        List<Suggestic_Settings__c> lstCust = Suggestic_Settings__c.getAll().values();
        system.debug('lstCust:' + lstCust);

        if(lstCust != NUll && lstCust.size() > 0) {
            settings = lstCust[0];
        } else {
            return smpr;
        }     
        
        // Send 
        reqGraphQl rss = new reqGraphQl();
        rss.query = 'mutation { swapMealPlanRecipe( recipeId:\"' + setMeal + '\" mealId:\"' + curMeal + '\"){ success } }';
        system.debug('swapMealPlanRecipe:' + rss);
        String jsonBody = JSON.serialize(rss);
        
        API_Request__c apiReq1 = new API_Request__c(Raw_Request__c=jsonBody, Request_Type__c='Suggestic Outbound');
        apiReq1.Request_Headers__c = 'sg-user: ' + userId;
        HttpResponse resp = sendRequest(settings.GraphQL_Endpoint__c, settings.AuthToken__c, jsonBody, userID);
        
        String body=NULL;
        Integer statusCode=NULL;
        if(!Test.isRunningTest()){
            statusCode = resp.getStatusCode();
            body = resp.getBody();
        } else {
            statusCode = 201;
            body = '{"data": {"swapMealPlanRecipe": {"success": false}}}';
        }
        System.debug('body:' + body);
        apiReq1.Response__c = String.valueOf(statusCode) + ':' + body;
        smpr.lstAddAPIReq.add(apiReq1);
        
        // Get Response
        swapMealPlanResp smpresp = (swapMealPlanResp)JSON.deserialize(body, swapMealPlanResp.class);
        if(smpresp != NULL && smpresp.data != NULL && smpresp.data.swapMealPlanRecipe != NULL && smpresp.data.swapMealPlanRecipe.success != NULL) {
            smpr.success = smpresp.data.swapMealPlanRecipe.success;
        }
        
        return smpr;
    }
    

    public static Boolean swapMealPlan(String userID, String OppId) {
        List<API_Request__c> lstAddAPIReq = new List<API_Request__c>();

        if(userID != NULL) {            
            List<Opportunity> lstOpp = [Select Id, Name, 
                                        (Select Id, Name, Shopify_ID__c, Meal__r.Suggestic_ID__c, Meal__r.Type__c, Quantity__c from Meal_Line_Items__r)
                                        from Opportunity where Id = :OppId];
            System.debug('lstOpp:' + lstOpp);
            
            if(lstOpp != NULL && lstOpp.size() > 0) {
                
                System.debug('lstOpp[0].Meal_Line_Items__r:' + lstOpp[0].Meal_Line_Items__r);
                
                if(lstOpp[0].Meal_Line_Items__r.size() > 0) {
                    
                    getMealPlanData gmpd = getMealPlan(userID, lstAddAPIReq);
                    System.debug('gmpd:' + gmpd);
                    
                    if(gmpd.gmpd != NULL && gmpd.gmpd.data != NULL && gmpd.gmpd.data.mealPlan != NULL) {
                    
                        // No Meal Plan
                        if(gmpd.gmpd.data.mealPlan.size() == 0) {
                            
                            // Create One
                            createMealPlanData cmpd = createMealPlan(userId, lstAddAPIReq);
                            System.debug('cmpd:' + cmpd);
                            
                            if(cmpd != NULL && cmpd.success) {
                                gmpd = getMealPlan(userID, lstAddAPIReq);
                                System.debug('gmpd:' + gmpd);
                            }
                        }
                        
                        if(gmpd.gmpd != NULL && gmpd.gmpd.data != NULL && gmpd.gmpd.data.mealPlan != NULL && gmpd.gmpd.data.mealPlan.size() > 0) {
                            
                            // Load Purchased Meals
                            MAP<STRING,LIST<Meal__c>> mapMeals = new MAP<STRING,LIST<Meal__c>>();
                            for(Meal_Line_Item__c mli : lstOpp[0].Meal_Line_Items__r) {
                                String mealType = mli.Meal__r.Type__c.toLowerCase();
                                LIST<Meal__c> fndList = mapMeals.get(mealType);
                                if(fndList == NULL) {
                                    fndList = new LIST<Meal__c>();
                                }
                                fndList.add(mli.Meal__r);
                                mapMeals.put(mealType,fndList);
                            }
                            System.debug('mapMeals:' + mapMeals);
                            
                            // Replace Meal Plan
                            for(getMealPlanRespDataMealPlan mp :gmpd.gmpd.data.mealPlan) {
                                
                                System.debug('mp:' + mp);
                                
                                if(mp.meals != NULL && mp.meals.size() > 0) {
                                    for(getMealPlanRespDataMeal m :mp.meals) {
                                        
                                        System.debug('m:' + m);
                                        
                                        String mealType = m.meal.toLowerCase();
                                        LIST<Meal__c> fndList = mapMeals.get(mealType);
                                        
                                        System.debug('fndList:' + fndList);
                                        
                                        if(fndList != NULL && fndList.size() > 0) {
                                            swapMealPlanRet smpr = swapMealPlan(userID, fndList[0].Suggestic_ID__c, m.id, lstAddAPIReq);
                                            System.debug('smpr:' + smpr);
                                            
                                            lstAddAPIReq = smpr.lstAddAPIReq;
                                            
                                            // Remove used meal
                                            LIST<Meal__c> mealList = new LIST<Meal__c>();
                                            Boolean skip=true;
                                            for(Meal__c nm :fndList) {
                                                if(!skip) {
                                                    mealList.add(nm);
                                                }
                                                skip=false;
                                            }
                                            System.debug('mealList:' + mealList);
                                            mapMeals.put(mealType,mealList);
                                        }
                                        
                                    }
                                }
                                
                            }
                            
                        }   
                        
                    }
                }
            }
        }        
        return true;
    }
    
    
    public static getPasswordTokenData getPasswordToken(String emailAddress, List<API_Request__c> lstAddAPIReq) {
     
        getPasswordTokenData gptd = new getPasswordTokenData();
        gptd.lstAddAPIReq = lstAddAPIReq;
     
        Suggestic_Settings__c settings;
        List<Suggestic_Settings__c> lstCust = Suggestic_Settings__c.getAll().values();
        system.debug('lstCust:' + lstCust);
        
        if(lstCust != NUll && lstCust.size() > 0) {
            settings = lstCust[0];
        } else {
            return gptd;
        }        
        
        // Send 
        reqGraphQl rss = new reqGraphQl();
        rss.query = 'mutation {requestResetPassword(email: \"' + emailAddress + '\") {success message resetPasswordCode}}';
        system.debug('requestResetPassword:' + rss);
        String jsonBody = JSON.serialize(rss);
        
        API_Request__c apiReq1 = new API_Request__c(Raw_Request__c=jsonBody, Request_Type__c='Suggestic Outbound');
        //apiReq1.Request_Headers__c = 'sg-user: ' + userId;
        HttpResponse resp = sendRequest(settings.GraphQL_Endpoint__c, settings.AuthToken__c, jsonBody, NULL);
        
        String body=NULL;
        Integer statusCode=NULL;
        if(!Test.isRunningTest()){
            statusCode = resp.getStatusCode();
            body = resp.getBody();
        } else {
            statusCode = 201;
            body = '{"data":{"createProfileCustomAttributes":{"success":true,"errors":[]}}}';
        }
        System.debug('body:' + body);
        apiReq1.Response__c = String.valueOf(statusCode) + ':' + body;
        gptd.lstAddAPIReq.add(apiReq1);
        
        // Get Token Value
        getPasswordTokenResp gptr = (getPasswordTokenResp)JSON.deserialize(body, getPasswordTokenResp.class);
        if(gptr != NULL && gptr.data != NULL && gptr.data.requestResetPassword != NULL && gptr.data.requestResetPassword.resetPasswordCode != NULL) {
            gptd.pwdToken = gptr.data.requestResetPassword.resetPasswordCode;    
        }
        
        return gptd;
    }

    public static resetPasswordResp setPassword(String pwdToken, String password) {
     
        List<API_Request__c> lstAddAPIReq = new List<API_Request__c>();
        resetPasswordResp rpr;
        
        Suggestic_Settings__c settings;
        List<Suggestic_Settings__c> lstCust = Suggestic_Settings__c.getAll().values();
        List<Account> lstAcct = [select Id, Last_Password_Reset_Date_Time__c from Account where Suggestic_Password_Token__c = :pwdToken];
        system.debug('lstCust:' + lstCust);
        system.debug('lstAcct:' + lstAcct);        
        
        if(lstCust != NUll && lstCust.size() > 0) {
            settings = lstCust[0];
        } else {
            return rpr;
        }        
        
        // Send 
        reqGraphQl rss = new reqGraphQl();
        rss.query = 'mutation {resetPassword(code: \"' + pwdToken + '\" newPassword: \"' + password + '\") {success message}}';
        system.debug('resetPassword:' + rss);
        String jsonBody = JSON.serialize(rss);
        
        String acctId;
        if(lstAcct != NULL && lstAcct.size() > 0) {
            acctId = lstAcct[0].Id;
            lstAcct[0].Last_Password_Reset_Date_Time__c = DateTime.Now();
        }
        API_Request__c apiReq1 = new API_Request__c(Raw_Request__c=jsonBody, Request_Type__c='Suggestic Outbound',Account__c=acctId);
        //apiReq1.Request_Headers__c = 'sg-user: ' + userId;
        HttpResponse resp = sendRequest(settings.GraphQL_Endpoint__c, settings.AuthToken__c, jsonBody, NULL);
        
        String body=NULL;
        
        Integer statusCode;
        if(!Test.isRunningTest()){
            statusCode = resp.getStatusCode();
            body = resp.getBody();
        } else {
            statusCode = 201;
            body = '{"data":{"createProfileCustomAttributes":{"success":true,"errors":[]}}}';
        }
        System.debug('body:' + body);
        apiReq1.Response__c = String.valueOf(statusCode) + ':' + body;
        lstAddAPIReq.add(apiReq1);
        
        insert lstAddAPIReq;
        if(lstAcct != NULL && lstAcct.size() > 0) {
            update lstAcct;
        }
        
        rpr = (resetPasswordResp)JSON.deserialize(body, resetPasswordResp.class);
        return rpr;
    }
    
    
    
    public static List<API_Request__c> setDeliveryDate(String userId, String deliveryDate, List<API_Request__c> lstAddAPIReq) {
     
        Suggestic_Settings__c settings;
        List<Suggestic_Settings__c> lstCust = Suggestic_Settings__c.getAll().values();
        system.debug('lstCust:' + lstCust);
        
        if(lstCust != NUll && lstCust.size() > 0) {
            settings = lstCust[0];
        } else {
            return lstAddAPIReq;
        }        
        
        // Send Delivery Date
        reqGraphQl rss = new reqGraphQl();
        rss.query = 'mutation {createProfileCustomAttributes(attributes: [{name: "estimatedStartJourneyDate", dataType: STRING, value: "' + deliveryDate + '"}]){success errors { field messages }}}';
        system.debug('createProfileCustomAttributes:' + rss);
        String jsonBody = JSON.serialize(rss);
        
        API_Request__c apiReq1 = new API_Request__c(Raw_Request__c=jsonBody, Request_Type__c='Suggestic Outbound');
        apiReq1.Request_Headers__c = 'sg-user: ' + userId;
        HttpResponse resp = sendRequest(settings.GraphQL_Endpoint__c, settings.AuthToken__c, jsonBody, userId);
        
        String body=NULL;
        Integer statusCode=NULL;
        if(!Test.isRunningTest()){
            statusCode = resp.getStatusCode();
            body = resp.getBody();
        } else {
            statusCode = 201;
            body = '{"data":{"createProfileCustomAttributes":{"success":true,"errors":[]}}}';
        }
        System.debug('body:' + body);
        apiReq1.Response__c = String.valueOf(statusCode) + ':' + body;
        lstAddAPIReq.add(apiReq1);
                
        return lstAddAPIReq;
    }

    public static List<API_Request__c> updateSubscription(String userId, String subLevel, List<API_Request__c> lstAddAPIReq) {
        
        Suggestic_Settings__c settings;
        List<Suggestic_Settings__c> lstCust = Suggestic_Settings__c.getAll().values();
        system.debug('lstCust:' + lstCust);
        
        if(lstCust != NUll && lstCust.size() > 0) {
            settings = lstCust[0];
        } else {
            return lstAddAPIReq;
        }        
        
        String subLevelCode = settings.Subscription_Platinum__c;
        if(subLevel == 'Platinum') {
            subLevelCode = settings.Subscription_Platinum__c;
        } else if(subLevel == 'Pro') {
            subLevelCode = settings.Subscription_Pro__c;
        } else if(subLevel == 'Free') {
            subLevelCode = settings.Subscription_Free__c;
        }
        
        // Send 
        reqGraphQl rss = new reqGraphQl();
        rss.query = 'mutation {updateSubscription(userId: \"' + userId + '\" subscriptionId: \"' + subLevelCode + '\"){success message}}';
        system.debug('updateSubscription:' + rss);
        String jsonBody = JSON.serialize(rss); 
        
        API_Request__c apiReq1 = new API_Request__c(Raw_Request__c=jsonBody, Request_Type__c='Suggestic Outbound');
        //apiReq1.Request_Headers__c = 'sg-user: ' + userId;
        HttpResponse resp = sendRequest(settings.GraphQL_Endpoint__c, settings.AuthToken__c, jsonBody, null);

        String body=NULL;
        Integer statusCode=NULL;
        if(!Test.isRunningTest()){
            statusCode = resp.getStatusCode();
            body = resp.getBody();
        } else {
            statusCode = 201;
            body = '{"data":{"createProfileCustomAttributes":{"success":true,"errors":[]}}}';
        }
        System.debug('body:' + body);
        apiReq1.Response__c = String.valueOf(statusCode) + ':' + body;
        lstAddAPIReq.add(apiReq1);
        
        return lstAddAPIReq;
    }

    
    public static List<API_Request__c> setProgram(String userId, String mainProductCode, List<API_Request__c> lstAddAPIReq) {
     
        Suggestic_Settings__c settings;
        List<Suggestic_Settings__c> lstCust = Suggestic_Settings__c.getAll().values();
        system.debug('lstCust:' + lstCust);
        
        if(lstCust != NUll && lstCust.size() > 0) {
            settings = lstCust[0];
        } else {
            return lstAddAPIReq;
        }        
        
        String productCode;
        if(mainProductCode == 'E28ZJ') {
            productCode = settings.Reboot__c;
        } else if(mainProductCode == 'QSZJ') {
            productCode = settings.Quickstart__c;        
        } else {
            return lstAddAPIReq;
        }
        
        // Send Delivery Date
        reqGraphQl rss = new reqGraphQl();
        rss.query = 'mutation {updateUserProgram(programId:\"' + productCode  + '\"){success errors { field messages }}}';
        system.debug('updateUserProgram:' + rss);
        String jsonBody = JSON.serialize(rss);
        
        API_Request__c apiReq1 = new API_Request__c(Raw_Request__c=jsonBody, Request_Type__c='Suggestic Outbound');
        apiReq1.Request_Headers__c = 'sg-user: ' + userId;
        HttpResponse resp = sendRequest(settings.GraphQL_Endpoint__c, settings.AuthToken__c, jsonBody, userId);
        
        String body=NULL;
        Integer statusCode=NULL;
        if(!Test.isRunningTest()){
            statusCode = resp.getStatusCode();
            body = resp.getBody();
        } else {
            statusCode = 201;
            body = '{"data":{"createProfileCustomAttributes":{"success":true,"errors":[]}}}';
        }
        System.debug('body:' + body);
        apiReq1.Response__c = String.valueOf(statusCode) + ':' + body;
        lstAddAPIReq.add(apiReq1);
                
        return lstAddAPIReq;
    }
    
    @future(callout=true)
    public static void resetPasswordToken(String AccountID) {
        
        List<API_Request__c> lstAddAPIReq = new List<API_Request__c>();
        Account acct = [select Id, Name, Email__c, Suggestic_ID__c, Suggestic_Delivery_Date__c, Suggestic_Password_Token__c, Suggestic_Send_Password__c from Account where id = :AccountID];
        getPasswordTokenData gptd = getPasswordToken(acct.Email__c, lstAddAPIReq);
        if(gptd.pwdToken != NULL) {
            lstAddAPIReq = gptd.lstAddAPIReq;
            acct.Suggestic_Password_Token__c  = gptd.pwdToken;
            
            // Send Delivery Date if needed
            if(acct.Suggestic_ID__c != NULL && acct.Suggestic_Delivery_Date__c != NULL) {
                Datetime dt = DateTime.newInstance(acct.Suggestic_Delivery_Date__c.year(), acct.Suggestic_Delivery_Date__c.month(), acct.Suggestic_Delivery_Date__c.day());
                String deliveryDateStr = dt.format('yyyy-MM-dd');                  
                List<API_Request__c> ars = setDeliveryDate(acct.Suggestic_ID__c, deliveryDateStr, lstAddAPIReq);
                lstAddAPIReq = ars;
            }
            update acct;            
        }    
        insert lstAddAPIReq;
        
    }
    
    @future(callout=true)
    public static void setOrder(String AccountId, String OppId, String startDate) {
        
        System.Debug('AccountId:' + AccountId);
        System.Debug('OppId:' + OppId);
        System.Debug('startDate:' + startDate);                
        
        Boolean userAdded = False;
        String userId = Null;
        
        Suggestic_Settings__c settings;
        List<Suggestic_Settings__c> lstCust = Suggestic_Settings__c.getAll().values();
        system.debug('lstCust:' + lstCust);
        
        if(lstCust != NUll && lstCust.size() > 0) {
            settings = lstCust[0];
        } else {
            return;
        }        
        
        List<API_Request__c> lstAddAPIReq = new List<API_Request__c>();        
        List<Account> lstAcct = [select Id, Name, First_Name__c, Last_Name__c, Email__c, Suggestic_ID__c, Suggestic_Password_Token__c from Account where id = :AccountId];
        
        if(lstAcct != NULL && lstAcct.size() > 0) {
            Account acct = lstAcct[0];
            
            if(acct.Suggestic_ID__c == NULL) {               
                reqAddUser addReq = new reqAddUser();
                addReq.name = acct.First_Name__c + ' ' + acct.Last_Name__c;
                addReq.email = acct.Email__c;
                addReq.email_password_notification = False;
                system.debug('addReq:' + addReq);
                
                String jsonBody = JSON.serialize(addReq);
                
                API_Request__c apiReq = new API_Request__c(Raw_Request__c=jsonBody, Request_Type__c='Suggestic Outbound');
                
                HttpResponse resp = sendRequest(settings.Endpoint__c + '/users', settings.AuthToken__c, jsonBody, NULL);
                
                String body;
                Integer statusCode;
                if(!Test.isRunningTest()){
                    statusCode = resp.getStatusCode();
                    body = resp.getBody();
                } else {
                    statusCode = 201;
                    body = '{"user_id":"123"}';
                }
                System.debug('body:' + body);
                apiReq.Response__c = String.valueOf(statusCode) + ':' + body;
                
                if(statusCode >= 200 && statusCode < 300) {
                    respAddUser addResp = (respAddUser)JSON.deserialize(body, respAddUser.class);   
                    System.debug('addResp:' + addResp);
                    
                    if(addResp != NULL && addResp.user_id != NULL) {
                        acct.Suggestic_ID__c = addResp.user_id;
                        userId = addResp.user_id;
                        userAdded = True;
                    }
                }
                lstAddAPIReq.add(apiReq);
                
                Opportunity opp;
                Shipment__c ship;
                String deliveryDateStr;
                String mainProductCode;
                if(userId != NULL && OppId != NULL) {
                    
                    // Set Delivery Date
                    if(OppId != NULL) {
                        List<Opportunity> lstOpp = [Select Id, Name, Delivery_Date__c, Main_Product_Code__c, Account_Suggestic_Password_Token__c from Opportunity where Id = :OppId];                
                        System.Debug('lstOpp:' + lstOpp );                
                        
                        if(lstOpp != NULL && lstOpp.size() > 0) {
                            opp = lstOpp[0];
                            if(opp.Delivery_Date__c != NULL) {
                                Datetime dt = DateTime.newInstance(opp.Delivery_Date__c.year(), opp.Delivery_Date__c.month(), opp.Delivery_Date__c.day());
                                deliveryDateStr = dt.format('yyyy-MM-dd');                                                    
                            }
                            
                            if(opp.Main_Product_Code__c != NULL) {
                                mainProductCode = opp.Main_Product_Code__c;
                            }
                            
                            List<Shipment__c> lstShip = [select Id, Account_Suggestic_Password_Token__c from Shipment__c where Opportunity__c = :opp.id];
                            if(lstShip != NULL && lstShip.size() > 0) {
                                ship = lstShip[0];
                            }
                        }                    
                    }
                    
                    if(startDate != NULL && startDate.length() > 0) {
                        deliveryDateStr = startDate;
                    }
                    
                    System.Debug('deliveryDateStr:' + deliveryDateStr);                
                    
                    if(deliveryDateStr != NULL) {
                        lstAddAPIReq = setDeliveryDate(userId, deliveryDateStr, lstAddAPIReq);    
                    }
                    
                    if(mainProductCode != NULL) {
                        lstAddAPIReq = setProgram(userId, mainProductCode, lstAddAPIReq);
                        lstAddAPIReq = updateSubscription(userId, NULL, lstAddAPIReq);
                        acct.Suggestic_App_Level__c = 'Platinum';
                    }
                    
                    // Get Password Token
                    getPasswordTokenData gptd = getPasswordToken(acct.Email__c, lstAddAPIReq);
                    if(gptd.pwdToken != NULL) {
                        lstAddAPIReq = gptd.lstAddAPIReq;
                        acct.Suggestic_Password_Token__c  = gptd.pwdToken;
                        if(opp != NULL) {
                            opp.Account_Suggestic_Password_Token__c = gptd.pwdToken;    
                        }
                        if(ship != NULL) {
                            ship.Account_Suggestic_Password_Token__c = gptd.pwdToken;    
                        }
                    }
                    
                    // Set Intercom Account
                    IntercomClass.responseSearchCustomer rsc = IntercomClass.getCustomer(acct.Email__c);
                    if(rsc != NULL && rsc.data != NULL && rsc.data.size() > 0 && rsc.data[0].id != NULL) {
                    } else {
                        IntercomClass.responseCreateCustomer respCC = IntercomClass.createCustomer(acct.Id, acct.Email__c, acct.First_Name__c + ' ' + acct.Last_Name__c);
                        if(respCC != NULL) {
                            API_Request__c apiReq1 = new API_Request__c(Raw_Request__c=respCC.rawRequest, Request_Type__c='Intercom Outbound',Account__c=acct.Id, Response__c = respCC.respCode + ':' + respCC.rawResp);
                            lstAddAPIReq.add(apiReq1);
                        }
                    }
                }
                
                // Send Meals
                if(userId != NULL) {
                    swapMealPlan(userID, OppId);
                }
                
                if(userAdded || acct.Suggestic_Password_Token__c != NULL) {
                    update acct;
                }
                
                if(opp != NULL) {
                    update opp;
                }

                if(ship != NULL) {
                    update ship;
                }


                insert lstAddAPIReq;
            }
        }
        
    }
    
    /*
    public static List<API_Request__c> sendPurchase(String userID, String OppId, List<API_Request__c> lstAddAPIReq) {
        
        if(userID != NULL) {            
            List<Opportunity> lstOpp = [Select Id, Name, 
                                        (Select Id, Name, Shopify_ID__c, Quantity__c from Meal_Line_Items__r)
                                        from Opportunity where Id = :OppId];
            if(lstOpp != NULL && lstOpp.size() > 0) {
                if(lstOpp[0].Meal_Line_Items__r.size() > 0) {
                    reqSendOrder rso = new reqSendOrder();
                    rso.user_id = userID;
                    rso.date_time = DateTime.now().format('MM/dd/YYYY HH:mm');
                    rso.meals = new List<reqMeals>();
                    
                    for(Meal_Line_Item__c mli : lstOpp[0].Meal_Line_Items__r) {
                        reqMeals rm = new reqMeals();
                        rm.meal_id = mli.Shopify_ID__c;
                        rm.qantity = Integer.valueOf(mli.Quantity__c);
                        rso.meals.add(rm);
                    }
                    system.debug('reqSendOrder:' + rso);
                    
                    String jsonBody = JSON.serialize(rso);
                    
                    API_Request__c apiReq = new API_Request__c(Raw_Request__c=jsonBody);
                    
                    HttpResponse resp = sendRequest('meals', jsonBody, NULL);
                    
                    Integer statusCode;
                    String body;
                    if(!Test.isRunningTest()){
                        statusCode = resp.getStatusCode();
                        body = resp.getBody();
                    } else {
                        statusCode = 201;
                        body = '{}';
                    }
                    System.debug('reqSendOrder body:' + body);
                    apiReq.Response__c = String.valueOf(statusCode) + ':' + body;                    
                    if(statusCode >= 200 && statusCode < 300) {
                        respAddUser addResp = (respAddUser)JSON.deserialize(body, respAddUser.class);   
                        System.debug('addResp:' + addResp);
                    }
                    lstAddAPIReq.add(apiReq);
                }
            }
        }
        return lstAddAPIReq;
    }
    */
    
    public static String hasSuggesticSubscription(String userEmail) {
    
        Date tdy = Date.today();
        Date yearAgo = Date.newInstance(tdy.year()-1, tdy.month(), tdy.day());
        String custID; 
    
        List<Opportunity> lstOpp = [select ID, AccountID from Opportunity where Email_Address__c = :userEmail AND StageName = 'Closed Won' and Main_Product_Code__c = 'SUG' and CloseDate > :yearAgo];
        if(lstOpp != NULL && lstOpp.size() > 0) {
            custID = lstOpp[0].AccountID;
        }
    
        return custID;
    }
 
    
@InvocableMethod(label='suggesticMethods' description='Operate Suggestic Class Methods.')
    public static void suggesticMethods(List<List<String>> inputParams) {  
        
        System.debug('inputParams:' + inputParams);
        
        String method;
        String param1;
        String param2;
        String param3;
        String param4;
        
        for(List<String> ids :inputParams) {
        
            //List<String> ids = inputParams[0];
            
            if(!ids.isEmpty()){
                Integer cnt=0;
                for(String idVal :ids) {
                    if(cnt==0)
                        method = idVal;
                    else if(cnt==1)
                        param1 = idVal;
                    else if(cnt==2)
                        param2 = idVal;
                    else if(cnt==3)
                        param3 = idVal;
                    else if(cnt==4)
                        param4 = idVal;
                    cnt++;
                }
                System.debug('method:' + method);
                System.debug('param1:' + param1);
                System.debug('param2:' + param2);
                System.debug('param3:' + param3);
                System.debug('param4:' + param4);
                
                if(method == 'setOrder') {
                    setOrder(param1, param2, param3);
                } else if(method == 'resetPasswordToken') {
                    resetPasswordToken(param1);
                } else if(method == 'deleteUser') {
                    deleteUser(param1);
                } else if(method == 'updateSubscription') {
                    List<API_Request__c> lstAddAPIReq = new List<API_Request__c>();
                    updateSubscription(param1, param2, lstAddAPIReq);
                }
                
            }
        }
   
    }            
}