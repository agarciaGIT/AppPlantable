public class mailChimpClass {

    public class subscriber {
        String email_address;
    }
    
    public class mergeField {
        String FNAME;
        String LNAME;
    }
        
    public class listMember {
        String email_address;
        String status;
        mergeField merge_fields;
    }
    
    public class batchOperation {
        String method;
        String path;
        String params;
        String body;
        String operation_id;
    }
    
    public class bitlyRespData {
        String url;
    }

    public class bitlyResp {
        String link;
        String message;
        String description;
    }
    
    public class bitlyReturn {
        Integer status;
        String body;
        bitlyResp bitlyResp;
    }
    
    public class sendSMSReturn {
    	public String message;   
        public List<API_Request__c> lstAddAPIReq;
        public Boolean SMSSent;
    }
    
    public static HttpResponse sendBiltyAuthRequest() {
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://api-ssl.bitly.com/oauth/access_token';
        system.debug('endpoint:' + endpoint);

        request.setEndPoint(endpoint);
        request.setMethod('POST');        
        
        String username = Label.BitlyUSername;
        String password = Label.BitlyPassword;
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);     
        
        request.setHeader('Content-Length', '0');     
        
        HttpResponse response;
        Integer statusCode;
        if(!Test.isRunningTest()){
            response = httpProtocol.send(request);
            statusCode = response.getStatusCode();
        } else {
            response = new HttpResponse();
            statusCode = 200;
        }
        system.debug('response:' + response);
        String respBody='';
        if(statusCode == 200) {
            if(!Test.isRunningTest()){
                respBody = response.getBody();
            } else {
                respBody = '{}';
            }
            System.debug('respBody:' + respBody);
        }
        return response;        

    }    
    public static HttpResponse sendBiltyRequest(String longURL, String AuthToken) {
        //https://api-ssl.bitly.com/v3/shorten?access_token=351842e20d492ad141e19ae9bdc77dbe3440f7c3&longUrl=http%3A%2F%2Fgoogle.com%2F

        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://api-ssl.bitly.com/v4/shorten';        
        String authorizationHeader = 'Bearer ' + AuthToken;
        String contentType = 'application/json';
        String reqBody = '{"group_gui":"","domain":"bit.ly","long_url":"'+ longURL +'"}';
        String len = String.valueOf(reqBody.length());
        
        system.debug('endpoint:' + endpoint);        
        system.debug('Authorization:' + authorizationHeader);        
        system.debug('Content-Type:' + contentType);
        system.debug('content-length:' + len);
        system.debug('reqBody:' + reqBody);
        
        
        request.setEndPoint(endpoint);
        request.setMethod('POST');        
        request.setHeader('Authorization', authorizationHeader);     
        request.setHeader('Content-Type', contentType);     
        request.setHeader('content-length', '87');   
        request.setHeader('Accept', '*/*');   

        request.setBody(reqBody);
        
        HttpResponse response;
        Integer statusCode;
        if(!Test.isRunningTest()){
            response = httpProtocol.send(request);
            statusCode = response.getStatusCode();
        } else {
            response = new HttpResponse();
            statusCode = 200;
        }
        system.debug('response:' + response);
        String respBody='';
        if(statusCode == 200) {
            if(!Test.isRunningTest()){
                respBody = response.getBody();
            } else {
                respBody = '{}';
            }
            System.debug('respBody:' + respBody);
        }
        return response;        

    }
    
    public static HttpResponse sendMailChimpRequest(batchOperation bo) {
         
        String path = bo.path;
        String method = bo.method;
        String body = bo.body;
        
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://us12.api.mailchimp.com/3.0/' + path;
        system.debug('endpoint:' + endpoint);
        
        request.setEndPoint(endpoint);
        request.setMethod(method);        
         if(body != null) {
             system.debug('body:' + body);
             request.setBody(body);
         }
         
        String username = 'anystring';
        String password = 'e921d51e85a312e896469ca7232d1c37-us12';
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);     
        
        system.debug('headers:' + request.getHeader('Authorization'));
        
        HttpResponse response;
        Integer statusCode;
        if(!Test.isRunningTest()){
            response = httpProtocol.send(request);
            statusCode = response.getStatusCode();
        } else {
            response = new HttpResponse();
            statusCode = 200;
        }
        system.debug('response:' + response);
        String respBody='';
        if(statusCode == 200) {
            if(!Test.isRunningTest()){
                respBody = response.getBody();
            } else {
                respBody = '{}';
            }
            System.debug('respBody:' + respBody);
        }
        return response;        
    }        

    @future(callout=true)
    public static void addContactToCampaign(String listId, String emailAddress, String firstName, String lastName) {
        
        batchOperation bo = new batchOperation();
        bo.path = 'lists/' + listId + '/members';
        
        listMember lm = new listMember();
        lm.email_address = emailAddress;
        lm.status = 'subscribed';
        mergeField mf = new mergeField();
        mf.FNAME = firstName;
        mf.LNAME = lastName;
        lm.merge_fields = mf;
        
        System.debug('lm:' +  JSON.serialize(lm));
                
        bo.method = 'POST';
        bo.body = JSON.serialize(lm);
        bo.operation_id = 'addContactToCampaign' + '~' + listId + '~' + emailAddress;

        HttpResponse response = sendMailChimpRequest(bo);        
        //return bo;
    }
    
    @future(callout=true)
    public static void addContactToCampaignStep(String campaignId, String stepId, String emailAddress) {
        batchOperation bo = new batchOperation();
        bo.path = 'automations/' + campaignId + '/emails/' + stepId + '/queue';
        
        subscriber sub = new subscriber();
        sub.email_address = emailAddress;
        
        bo.method = 'POST';
        bo.body = JSON.serialize(sub);
        bo.operation_id = 'addContactToCampaignStep' + '~' + campaignId + '~' + stepId + '~' + emailAddress;
        
        HttpResponse response = sendMailChimpRequest(bo);
        //return bo;
    }
    
    public static Integer getMailChimpLists() {
        batchOperation bo = new batchOperation();
        bo.path = 'lists';
        bo.method = 'GET';
        HttpResponse response = sendMailChimpRequest(bo);
        return response.getStatusCode();
    }        
    
    
    public static void sendEmail(String templateId, String targetId, String replyTo, String whatObj, String ogrWideID) {

        system.debug('sendEmail');
        system.debug('templateId:' + templateId);
        system.debug('targetId:' + targetId);
        system.debug('replyTo:' + replyTo);
        system.debug('whatObj:' + whatObj);
        system.debug('ogrWideID:' + ogrWideID);

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTemplateId(templateId);
        mail.setSaveAsActivity(false);
        mail.setTargetObjectId(targetId);        
        mail.setReplyTo(replyTo);
        mail.setWhatId(whatObj);
        mail.setOrgWideEmailAddressId(ogrWideID);
        Messaging.SendEmailResult[] resultMail = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });        
    }
    
    public static void sendCampaignComm(String emailTemplate, String compAcctId, String emailAddress, String orgWideId, String smsEmailTemplate) {
        system.debug('emailTemplate:' + emailTemplate);
        system.debug('compAcctId:' + compAcctId);
        system.debug('emailAddress:' + emailAddress);
        system.debug('orgWideId:' + orgWideId);
        system.debug('smsEmailTemplate:' + smsEmailTemplate);
        
        List<Campaign_Account__c> lstCmpAccts = [Select id, Dont_Fire_SMS__c from Campaign_Account__c where Id = :compAcctId];
        if(lstCmpAccts != NULL && lstCmpAccts.size() > 0 && lstCmpAccts[0].Dont_Fire_SMS__c == True) {
            System.debug('Dont Send SMS');
        } else {
            if(smsEmailTemplate != NULL && smsEmailTemplate.length() > 0) {
                sendSMS(smsEmailTemplate, compAcctId, emailAddress);
            }
            
        }
        
        if(emailTemplate != NULL) {
            sendSalesforceEmail(emailTemplate, compAcctId, emailAddress, orgWideId);    
        }
        
    }
    
    public static void sendSalesforceEmail(String emailTemplate, String compAcctId, String emailAddress, String orgWideId) {

        system.debug('emailTemplate:' + emailTemplate);
        system.debug('compAcctId:' + compAcctId);
        system.debug('emailAddress:' + emailAddress);
        system.debug('orgWideId:' + orgWideId);

        List<Contact> lstCont = [SELECT Id, Email from Contact where Email = :emailAddress];
        List<EmailTemplate> lstEmailTemplates = [SELECT Id, Body, Subject from EmailTemplate where Name = :emailTemplate];
        List<OrgWideEmailAddress> lstOrgWide = [select Id, Address, DisplayName from OrgWideEmailAddress where Id = :orgWideId];
        
        system.debug('lstCont:' + lstCont);
        system.debug('lstEmailTemplates:' + lstEmailTemplates);
        system.debug('lstOrgWide:' + lstOrgWide);
        
        
        if(lstCont != null && lstCont.size() > 0 && lstEmailTemplates != null && lstEmailTemplates.size() > 0 && lstOrgWide != null && lstOrgWide.size() > 0) {
            
            sendEmail(lstEmailTemplates[0].Id, lstCont[0].Id, lstOrgWide[0].Address, compAcctId, orgWideId);
            
            // Send Copy
            //List<Contact> lstCont1 = [SELECT Id, Email from Contact where Email = 'euphebeit@gmail.com'];
            //if(lstCont1 != null && lstCont1.size() > 0) {
            //    sendEmail(lstEmailTemplates[0].Id, lstCont1[0].Id, lstOrgWide[0].Address, compAcctId, orgWideId);
            //}                
        }
    }
    
    public static sendSMSReturn sendSMS(String emailTemplate, String bindTemplateObjId, String emailAddress) {
        system.debug('emailTemplate:' + emailTemplate);
        system.debug('bindTemplateObjId:' + bindTemplateObjId);
        system.debug('emailAddress:' + emailAddress);

        String msg = '';
        sendSMSReturn ret = new sendSMSReturn();
        ret.SMSSent = False;
        
        
        List<Contact> lstCont = [SELECT Id, Email, Match_Mobile_Phone_WFR__c, Account.Suggestic_ID__c from Contact where Email = :emailAddress];
        List<EmailTemplate> lstEmailTemplates = [SELECT Id, Body, Subject from EmailTemplate where Name = :emailTemplate];
        
        system.debug('lstCont:' + lstCont);
        system.debug('lstEmailTemplates:' + lstEmailTemplates);
                
        if(lstCont != null && lstCont.size() > 0 && lstEmailTemplates != null && lstEmailTemplates.size() > 0) {

            List<String> bodies = new List<String>();
            bodies.add(lstEmailTemplates[0].Body);
            
            List<Messaging.RenderEmailTemplateBodyResult> resList = 
                    Messaging.renderEmailTemplate(lstEmailTemplates[0].Id, bindTemplateObjId, bodies);
            
            msg = resList[0].getMergedBody();
            
            system.debug('msg:' + msg);
                
            //sendEmail(lstEmailTemplates[0].Id, lstCont[0].Id, lstOrgWide[0].Address, compAcctId, orgWideId);
            String UseTwillio = Label.UseTwillio;
            String SendCampaignSMS = Label.SendCampaignSMS;
            
            if(SendCampaignSMS != NULL && SendCampaignSMS == 'True') {
                
                if(UseTwillio != NULL && UseTwillio == 'True') {
                    if(lstCont[0].Match_Mobile_Phone_WFR__c != NULL) {
                        // Send SMS if non-App user
                        if(lstCont[0].Account.Suggestic_ID__c == NULL) {
                            RESTSMSController.sendSMS(lstCont[0].Match_Mobile_Phone_WFR__c, msg);
                            ret.SMSSent = True;
                        }
                        // Send to Intercom
                        IntercomClass.sendCampaignSMSReturn scsr = IntercomClass.sendCampaignMsg(emailAddress, msg, (lstCont[0].Account.Suggestic_ID__c != NULL));
                        ret.message = msg;
                        ret.lstAddAPIReq = scsr.lstAddAPIReq;
                    }
                } else {
                    List<TeckstController.TeckstMessageSender> teckstMessageSenders = new List<TeckstController.TeckstMessageSender>();
                    TeckstController.TeckstMessageSender tms = new TeckstController.TeckstMessageSender();
                    teckstMessageSenders.add(tms);
                    tms.PBContactId = lstCont[0].Id;
                    tms.PBMessageBody = msg;
                    TeckstController.sendTeckstMessageNoFuture(teckstMessageSenders);                
                }
            }
            
        }        
        System.debug('MailchimpClass sendSMS ret:' + ret);
        return ret;
    }    
    
    public static bitlyReturn getBiltyURL(String url, String authToken) {
                
        HttpResponse resp = mailChimpClass.sendBiltyRequest(url,authToken);
        System.debug('resp:' + resp.getBody());
        
        bitlyReturn br = new bitlyReturn();
        br.status = resp.getStatusCode();
        br.body = resp.getBody();
        
        bitlyResp bitlyResp = new bitlyResp();
        String respStr = resp.getBody();
        if(respStr != NULL && respStr.length() > 0 && respStr.indexOf('url') > -1) {
            bitlyResp = (bitlyResp)JSON.deserialize(respStr, bitlyResp.class);
            br.bitlyResp = bitlyResp;

            System.debug('bitlyResp:' + bitlyResp);
        }
        return br;
    }
    
    public static List<Account> setAccountSurveyLinksInternal(String acctID) {
        bitlyReturn brFail=null;
        List<Account> lstAcct = [select Id, Starter_Survey_Short_URL__c , Finisher_Survey_Short_URL__c, Starter_Survey_Quickstart_Short_URL__c, Finisher_Survey_Quickstart_Short_URL__c from Account where id = :acctID];
        if(lstAcct != NULL && lstAcct.size() > 0) {
            lstAcct[0].Finisher_Survey_Short_URL__c = 'https://my.plantable.com/plink?i=' + acctID+ '~1';
            lstAcct[0].Starter_Survey_Short_URL__c = 'https://my.plantable.com/plink?i=' + acctID+ '~2';
            lstAcct[0].Finisher_Survey_Quickstart_Short_URL__c = 'https://my.plantable.com/plink?i=' + acctID+ '~3';
            lstAcct[0].Starter_Survey_Quickstart_Short_URL__c  = 'https://my.plantable.com/plink?i=' + acctID+ '~4';
            lstAcct[0].Login_QuickStart_Short_URL__c = 'https://my.plantable.com/plink?i=' + acctID+ '~5';
        }
/*
            HttpResponse respAuthToken = sendBiltyAuthRequest();
            String authToken = respAuthToken.getBody();
            
            // Finisher
            String url = 'https://my.plantable.com/emailTracker?campname=Reboot%20Completion%20SMS&acctid=' + acctID + '&meta1=Survey&url=https%3A%2F%2Fmy.plantable.com%2FsurveyFinisher%3Fid%3D' + acctID;
            bitlyReturn br = getBiltyURL(url, authToken);
            if(br != NULL && br.bitlyResp != NULL && br.bitlyResp.link != NULL) {
                lstAcct[0].Finisher_Survey_Short_URL__c = br.bitlyResp.link;
            } else {
                brFail = br;
            }
            
            // Starter
            url = 'https://my.plantable.com/emailTracker?campname=Reboot%20Delivery%20SMS&acctid=' + acctID + '&meta1=Survey&url=https%3A%2F%2Fmy.plantable.com%2FsurveyStarter%3Fid%3D' + acctID;
            bitlyReturn br1 = getBiltyURL(url, authToken);
            if(br1 != NULL && br1.bitlyResp != NULL && br1.bitlyResp.link != NULL) {
                lstAcct[0].Starter_Survey_Short_URL__c = br1.bitlyResp.link;
            } else {
                brFail = br1;
            }

            // Quickstart
            // Finisher
            url = 'https://my.plantable.com/emailTracker?campname=Quickstart%20Completion%20SMS&acctid=' + acctID + '&meta1=Survey&url=https%3A%2F%2Fmy.plantable.com%2FsurveyFinisher%3Fid%3D' + acctID;
            bitlyReturn br2 = getBiltyURL(url, authToken);
            if(br2 != NULL && br2.bitlyResp != NULL && br2.bitlyResp.link != NULL) {
                lstAcct[0].Finisher_Survey_Quickstart_Short_URL__c = br2.bitlyResp.link;
            } else {
                brFail = br2;
            }
            
            // Starter
            url = 'https://my.plantable.com/emailTracker?campname=Quickstart%20Delivery%20SMS&acctid=' + acctID + '&meta1=Survey&url=https%3A%2F%2Fmy.plantable.com%2FsurveyStarter%3Fid%3D' + acctID;
            bitlyReturn br3 = getBiltyURL(url, authToken);
            if(br3 != NULL && br3.bitlyResp != NULL && br3.bitlyResp.link != NULL) {
                lstAcct[0].Starter_Survey_Quickstart_Short_URL__c = br3.bitlyResp.link;
            } else {
                brFail = br3;
            }
            
            // Login
            url = 'https://my.plantable.com/emailTracker?campname=Quickstart%20Completion%20SMS&acctid=' + acctID + '&meta1=Login&url=https%3A%2F%2Fwww.plantable.com%2Faccount';
            bitlyReturn br4 = getBiltyURL(url, authToken);
            if(br4 != NULL && br4.bitlyResp != NULL && br4.bitlyResp.link != NULL) {
                lstAcct[0].Login_QuickStart_Short_URL__c = br4.bitlyResp.link;
            } else {
                brFail = br4;
            }
        }        
        if(brFail != NULL && !Test.isRunningTest()) {
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] { 'garcia.alberto.crespo@gmail.com' };
            message.optOutPolicy = 'FILTER';
            message.subject = 'Bitly Failed: ' + brFail.bitlyResp.message;
            message.plainTextBody = brFail.status + '\n<br>\n' + brFail.body  + '\n<br>\n' + brFail.bitlyResp.description + '\n<br>\n' + acctID;
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);            
        }
*/
        return lstAcct;
    }
    
    public static void setAccountSurveyLinksBatch(String acctID) {
        List<Account> lstAcct = setAccountSurveyLinksInternal(acctID);
        update lstAcct;
    }
    
    @future(callout=true)
    public static void setAccountSurveyLinks(String acctID) {
        List<Account> lstAcct = setAccountSurveyLinksInternal(acctID);    
        update lstAcct;
    }
    
    @InvocableMethod(label='campaignFlow' description='Operate Euphebe Campaigns.')
    public static void campaignFlow(List<List<String>> inputParams) {  
        
        System.debug('inputParams:' + inputParams);
        
        String method;
        String param1;
        String param2;
        String param3;
        String param4;
        String param5;
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
                else if(cnt==5)
                    param5 = idVal;
                cnt++;
            }
            System.debug('method:' + method);
            System.debug('param1:' + param1);
            System.debug('param2:' + param2);
            System.debug('param3:' + param3);
            System.debug('param4:' + param4);
            System.debug('param5:' + param5);
            
            if(method == 'addContactToCampaign') {
                addContactToCampaign(param1, param2, param3, param4);
            } else if(method == 'addContactToCampaignStep') {
                addContactToCampaignStep(param1, param2, param3);
            } else if(method == 'sendSalesforceEmail') {
                sendSalesforceEmail(param1, param2, param3, param4);
            } else if(method == 'sendSMS') {
                sendSMS(param1, param2, param3);
            } else if(method == 'setAccountSurveyLinks') {
                setAccountSurveyLinks(param1);
            } else if(method == 'setAccountSurveyLinksBatch') {
                setAccountSurveyLinksBatch(param1);
            } else if(method == 'sendCampaignComm') {
                sendCampaignComm(param1, param2, param3, param4, param5);
            }
        }
   
    }
    
    
}