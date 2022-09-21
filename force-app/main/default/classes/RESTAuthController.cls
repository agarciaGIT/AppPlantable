@RestResource(urlMapping='/auth/*')
global class RESTAuthController {
        
    @TestVisible
    public class reqAuth {
        String grant_type;
        String client_id;
        String client_secret;
        String username;
        String password;
    }

    @TestVisible
    public class respAuth {
        String access_token;
        Long expires;
    }
    
    public static string getBlankValue(String inStr) {
        if(inStr == null)
            return '';
        else return inStr;
    }
    
	public static String verifyRequest(RestRequest req) {
        Map<String, String> headers = req.headers;
        String token = headers.get('AuthorizationToken');
        System.debug('token: ' + token);
        
        if(token != null) {
            String clientId = RESTAuthController.verifyToken(token);
			System.debug('clientId: ' + clientId);
            return clientId;
        }
        return null;
    }    
    
    public static String verifyToken(String token) {
        DateTime now = System.now();
	    List<API_Session__c> lstSession = [select Id, Access_Token__c, Client_ID__c, Expire_Date_Time__c from API_Session__c where Access_Token__c = :token];
        if(lstSession != null && lstSession.size() > 0) {
            System.debug('lstSession: ' + lstSession);
            
            DateTime sesDateTime = lstSession[0].Expire_Date_Time__c;
            System.debug(now + '~' + sesDateTime);
            
            //Long nowEpoc = now.getTime();
            //Long sesEpoc = lstSession[0].Expire_Date_Time__c.getTime();
            //System.debug(nowEpoc + '~' + sesEpoc);
            
            if(now <= sesDateTime)
            	return lstSession[0].Client_ID__c;
            else return null;
        }
        return null;
    }
    
    public static String generateAccesToken() {
        String AccessToken='';
        Integer cnt=1;
        
        MAP<Integer, Boolean> mapInvalidChars = new MAP<Integer, Boolean>();
        mapInvalidChars.put(34,False);
        mapInvalidChars.put(38,False);
        mapInvalidChars.put(39,False);
        mapInvalidChars.put(39,False);
        mapInvalidChars.put(40,False);
        mapInvalidChars.put(41,False);
        mapInvalidChars.put(44,False);
        mapInvalidChars.put(45,False);
        mapInvalidChars.put(46,False);
        mapInvalidChars.put(47,False);
        mapInvalidChars.put(58,False);
        mapInvalidChars.put(59,False);
        mapInvalidChars.put(60,False);
        mapInvalidChars.put(61,False);
        mapInvalidChars.put(62,False);
        mapInvalidChars.put(63,False);
        mapInvalidChars.put(64,False);
        mapInvalidChars.put(91,False);
        mapInvalidChars.put(92,False);
        mapInvalidChars.put(93,False);
        mapInvalidChars.put(95,False);
        mapInvalidChars.put(96,False);
        
        While(cnt < 67) {
            Integer trys = 0;
            Boolean done=false;
            Double rnd;
            while(trys < 100 && done == False) {
            	rnd = Math.floor(Math.random() * ((122-35)+1) + 35);
               	done = mapInvalidChars.get(Integer.valueOf(rnd));
                trys++;
        	}
            String myChar = String.fromCharArray( new List<integer> { Integer.valueOf(rnd) } );
            AccessToken = AccessToken + myChar;
            cnt++;
        }
		return AccessToken;
    }
    
    public static respAuth processAPIAuth(String reqJson) {
        respAuth rspAuth = new respAuth();
        reqAuth ra = (reqAuth)JSON.deserialize(reqJson, reqAuth.class);
        
        if(ra != null && ra.client_id != null && ra.client_secret != null && ra.username != null && ra.password != null) {
        
            List<API_User__c> lstUsers = [select Id from API_User__c where 
                                                    Client_Id__c = :ra.client_id AND
                                                    Client_Secret__c = :ra.client_secret AND
                                                    Username__c = :ra.username AND
                                                    Password__c = :ra.password];
            
            if(lstUsers != NULL && lstUsers.size() > 0) {
                String AccessToken = generateAccesToken();
                if(AccessToken.length() > 0) {
                    
                    DateTime now = System.now();
                    now = now.addSeconds(300);

                    rspAuth.access_token = AccessToken;
                    rspAuth.expires = now.getTime();

                    // Update / Create Session
                    //List<API_Session__c> lstSession = [select Id, Access_Token__c, Client_ID__c, Expire_Date_Time__c from API_Session__c where Client_Id__c = :ra.client_id];
                    //if(lstSession != null && lstSession.size() > 0) {
                    //    lstSession[0].Access_Token__c = AccessToken;
                    //    lstSession[0].Expire_Date_Time__c = now;
                    //    update lstSession;
                    //}  else {
                        API_Session__c newSession = new API_Session__c();
                        newSession.Client_ID__c = ra.client_id;
                        newSession.Access_Token__c = AccessToken;
                        newSession.Expire_Date_Time__c = now;
                        insert newSession;
                    //}
                }
            }
    	}
        return rspAuth;
    }
    
    @HttpPost  
    global static Void postAuth() {      

		RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.statusCode = 401; 
        try {           
            String reqJson = req.requestBody.toString();
            respAuth rspAuth = processAPIAuth(reqJson);
            if(rspAuth != NULL && rspAuth.access_token != NULL && rspAuth.access_token.length() > 0) {
            	String respJson = JSON.serialize(rspAuth);    
                res.addHeader('Content-Type', 'application/json');
                res.responseBody = Blob.valueOf(respJson);
                res.statusCode = 200;
            }
        } catch (Exception e) {
            res.statusCode = 500;
        }  
        
            
    }        


}