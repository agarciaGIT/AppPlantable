@RestResource(urlMapping='/sms/*')
global class RESTSMSController {

    public static String sendSMS(String mobileNumber, String msg) {
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://api.twilio.com/2010-04-01/Accounts/' + Label.TwilioRESTUsername + '/Messages.json';
        system.debug('endpoint:' + endpoint);
        
        request.setEndPoint(endpoint);
        request.setMethod('POST');        
        String username = Label.TwilioRESTUsername;
        String password = Label.TwilioRESTPassword;
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        system.debug('authorizationHeader:' + authorizationHeader);
        request.setHeader('Authorization', authorizationHeader); 
        
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        String payload = 'Body='+EncodingUtil.urlEncode(msg,'UTF-8')+'&From='+EncodingUtil.urlEncode(Label.TwilioRESTMobileNumber,'UTF-8')+'&To='+EncodingUtil.urlEncode(mobileNumber,'UTF-8');        
        system.debug('payload:' + payload);
        request.setBody(payload);
        
        HttpResponse response;
        Integer statusCode;
        if(!Test.isRunningTest()){
            response = httpProtocol.send(request);
            statusCode = response.getStatusCode();
            system.debug('getStatus:' + response.getStatus());
        } else {
            response = new HttpResponse();
            statusCode = 200;
        }
        system.debug('response:' + response);
        String body = '{}';
        if(!Test.isRunningTest()){
            body = response.getBody();
        }
        System.debug('body:' + body);

        return body;        
    }        
    
    @future(callout=true)
    public static void sendSMSFuture(String mobileNumber, String msg) {
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://api.twilio.com/2010-04-01/Accounts/' + Label.TwilioRESTUsername + '/Messages.json';
        system.debug('endpoint:' + endpoint);
        
        request.setEndPoint(endpoint);
        request.setMethod('POST');        
        String username = Label.TwilioRESTUsername;
        String password = Label.TwilioRESTPassword;
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        system.debug('authorizationHeader:' + authorizationHeader);
        request.setHeader('Authorization', authorizationHeader); 
        
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        String payload = 'Body='+EncodingUtil.urlEncode(msg,'UTF-8')+'&From='+EncodingUtil.urlEncode(Label.TwilioRESTMobileNumber,'UTF-8')+'&To='+EncodingUtil.urlEncode(mobileNumber,'UTF-8');        
        system.debug('payload:' + payload);
        request.setBody(payload);
        
        HttpResponse response;
        Integer statusCode;
        if(!Test.isRunningTest()){
            response = httpProtocol.send(request);
            statusCode = response.getStatusCode();
            system.debug('getStatus:' + response.getStatus());
            
        } else {
            response = new HttpResponse();
            statusCode = 200;
        }
        system.debug('response:' + response);
        String body = '{}';
        if(!Test.isRunningTest()){
            body = response.getBody();
        }
        System.debug('body:' + body);
    }        
    
    @future(callout=true)
    public static void processSMS(String sm) {
        List<SMS_Message__c> lstMSg = [select Id, Enable_Automation__c  from SMS_Message__c where Id = :sm];
        if(lstMSg  != NULL && lstMSg.size() > 0) {
            lstMSg[0].Enable_Automation__c = true;
            update lstMSg;
        }
    }
    
    @HttpPost  
    global static Void postAuth() {      
        
        RestRequest req = RestContext.request;
        System.debug('req:' + req);
        
        RestResponse res = RestContext.response;
        res.statusCode = 200; 
        res.addHeader('Content-Type', 'text/html');
        try {           
        
            API_Request__c apiR = new API_Request__c ();
            apiR.Request_Type__c = 'SMS Message';
            apiR.Raw_Request__c = String.ValueOf(req);
            insert apiR;


            MAP<String,String> reqParams = req.params;
            String sfrom = reqParams.get('From');
            System.debug('reqParams.from:' + sfrom );
            
            String sbody = reqParams.get('Body');
            System.debug('reqParams.Body:' + sbody );
            
            String smedia0 = reqParams.get('MediaUrl0');
            System.debug('reqParams.smedia0:' + smedia0 );
            
            if(smedia0 != NULL) {
                sbody += '<br><a href="' + smedia0 + '" target="_new">Media1</a>';
            }
            
            String smedia1 = reqParams.get('MediaUrl1');
            System.debug('reqParams.smedia1:' + smedia1 );
            
            if(smedia1 != NULL) {
                sbody += '<br><a href="' + smedia1 + '" target="_new">Media2</a>';
            }
                        
            SMS_Message__c sm = new SMS_Message__c();
            sm.Name = sfrom;
            sm.From__c = sfrom;
            sm.Message__c = sbody;
            sm.Enable_Automation__c = true;
            insert sm;
            
            //processSMS(sm.Id);
            
            //res.addHeader('Content-Type', 'application/json');
            //String respJson ='';
            //res.responseBody = Blob.valueOf(respJson);
            //res.statusCode = 200;
        } catch (Exception e) {
            res.statusCode = 500;
            
            system.debug('SMSRest exception:' + e); 
            
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] { 'garcia.alberto.crespo@gmail.com' };
                message.optOutPolicy = 'FILTER';
            message.subject = 'SMSRest Exception';
            
            String msg='';
            if(req != NULL) {
                msg = msg + req + '\n\n';
            }
            
            message.plainTextBody = e.getMessage() + '\n' + e.getLineNumber() + '\n\n' + msg;
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages); 
            
            system.debug('Send results:' + results); 
        }  
    }            
    
    @InvocableMethod(label='SMSMethods' description='RESTSMSController Methods.')
    public static void smsMethods(List<List<String>> inputParams) {  
        
        System.debug('inputParams:' + inputParams);
        
        String method;
        String param1;
        String param2;
        String param3;
        String param4;
        List<String> ids = inputParams[0];
        
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
            
            if(method == 'sendSMS') {
                sendSMS(param1, param2);
            } else if(method == 'sendSMSFuture') {
                sendSMSFuture(param1, param2);
            } 
            
        }
    }            
    
}