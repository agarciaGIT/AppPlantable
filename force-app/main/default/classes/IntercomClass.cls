public class IntercomClass {


    public class responseSearchCustomerDataCustomAttributes {
        String LastMessageWasSMS;
        String LastSMSConversation;
        String wakeUpTime;
        String ageRange;
        String genderText;
        String primaryGoal;
        String alcoholConsumption;
        String mostChallengingChange;
        String energyLevel;
        String stressLevel;
        String selfEsteem;
        String sleepLevel;        
        String drinkOther;
        String hydration;
        String snacks;
        String lunch;
        String breakfastTime;
        String coffeeTeaTakeIt;
        String coffeeTea;
        String lbsAwayFromHappyWeight;
        String isHappyWeight;
        String weightText;
        String heightText;
      }
    
    public class responseSearchCustomerTagsData {
        Integer id;
    }
    
    public class responseSearchCustomerTags {
        String type;
        List<responseSearchCustomerTagsData> data;
    }
    
     public class responseSearchCustomerData {
         public String id;
         public String email;
         public String phone;
         public Decimal ios_last_seen_at;
         public Decimal android_last_seen_at;
         public Decimal last_replied_at;
         public responseSearchCustomerDataCustomAttributes custom_attributes;
         public responseSearchCustomerTags tags;
    }
    
    public class responseSearchCustomer {
        public String type;
        public List<responseSearchCustomerData> data;
    }
    
    
    public class responseCreateCustomer {
        public String type;
        public String id;
        public String email;
        public String name;
        public String rawRequest;
        public String respCode;
        public String rawResp;
    }
    
    public class responseSetCustomer {
        String type;
        String id;
    }
    
    public class requestSetCustomerCustomAttributes {
        Boolean LastMessageWasSMS;
    }
    
    public class requestSetCustomer {
        String type;
        String id;
        requestSetCustomerCustomAttributes custom_attributes;
    }

    
    public class responseCreateMessage {
        String type;
        String id;
        String conversation_id;
    }

    
    public class responseReplyConversation {
        String type;
        String id;
    }
    
    public class requestCreateMessageFrom {
        String type;
        String id;
    }
    
    public class requestCreateMessage {
        String body;
        requestCreateMessageFrom fromx;
    }

    public class sendCampaignSMSReturn {
        String message;
        public List<API_Request__c> lstAddAPIReq;
    }    
    
    public static HttpResponse sendRequest(String route, String method, String body) {
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = Label.IntercomURL + '/' + route;
        system.debug('endpoint:' + endpoint);

        request.setEndPoint(endpoint);
        request.setMethod(method);        
        
        String accessToken = Label.IntercomAccessToken;
        String authorizationHeader = 'Bearer ' + accessToken;
        request.setHeader('Authorization', authorizationHeader);     
        request.setHeader('Accept', 'application/json');     
        request.setHeader('Content-Type', 'application/json');    
        
        if(body != NULL) {
            request.setBody(body);
            system.debug('body:' + body);
        }
        
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
    
    public static responseCreateCustomer createCustomer(String AccountID, String email, String name) {
        responseCreateCustomer resp;
        
        String req = '{"role": "contact","external_id": "' + AccountID + '","email": "' + email +  '","name": "' + name + '" }';
        HttpResponse response = sendRequest('contacts', 'POST', req);
        if(response != NULL) {
            String respBody;
            if(!Test.isRunningTest()){
            	respBody = response.getBody();
            } else {
                respBody = '{"type":"list","data":[{"type":"contact","id":"605a1845c51c55f5b7429dd5","workspace_id":"mzgbihsm","external_id":null,"role":"user","email":"garcia.alberto.crespo@gmail.com","phone":"+19175867035","name":"Al Garcia","avatar":"https://img.fullcontact.com/static/83adffc3a7340794ad564e55cbe0faf7_82e2ec7fa74e12fece1fb9cb45ec052d3e8af05353b18cdb8603a103585dfe7a","owner_id":4417245,"social_profiles":{"type":"list","data":[{"type":"social_profile","name":"linkedin","url":"https://www.linkedin.com/in/alberto-garcia-5671a813"}]},"has_hard_bounced":false,"marked_email_as_spam":false,"unsubscribed_from_emails":false,"created_at":1616517189,"updated_at":1621417438,"signed_up_at":1616517189,"last_seen_at":1620839274,"last_replied_at":1621416850,"last_contacted_at":1621417438,"last_email_opened_at":1618690753,"last_email_clicked_at":null,"language_override":null,"browser":null,"browser_version":null,"browser_language":null,"os":null,"location":{"type":"location","country":"Spain","region":"Galicia","city":"A Coruña"},"android_app_name":null,"android_app_version":null,"android_device":null,"android_os_version":null,"android_sdk_version":null,"android_last_seen_at":null,"ios_app_name":"Plantable","ios_app_version":"1.2.0","ios_device":"iPhone XR","ios_os_version":"14.4.2","ios_sdk_version":null,"ios_last_seen_at":1620839274,"custom_attributes":{"job_title":"Vice President Tech Programs","genderText":"Male","primaryGoal":"Weight loss","alcoholConsumption":"I dont drink","mostChallengingChange":"No added sugar - includes honey, agave and sweeteners","energyLevel":"5","stressLevel":"6","selfEsteem":"5","sleepLevel":"6","salesforce_id":"0031I0000068HKBQA2","salesforce_object_type":"Contact","salesforce_owner_id":"0051I000000mpKjQAI","salesforce_owner_name":"Nadja Pinnavaia","salesforce_owner_email":"nadja@plantable.com","salesforce_owner_role":"CTO","salesforce_title":"wdwdwdwdwdrg","LastMessageWasSMS":"false","LastSMSConversation":null},"tags":{"type":"list","data":[],"url":"/contacts/605a1845c51c55f5b7429dd5/tags","total_count":0,"has_more":false},"notes":{"type":"list","data":[],"url":"/contacts/605a1845c51c55f5b7429dd5/notes","total_count":0,"has_more":false},"companies":{"type":"list","data":[{"id":"6091c4be1965b42eefb0dd51","type":"company","url":"/companies/6091c4be1965b42eefb0dd51"},{"id":"6078ca7f50bb84c4864ea607","type":"company","url":"/companies/6078ca7f50bb84c4864ea607"},{"id":"606ca982b5c22dc01cdec872","type":"company","url":"/companies/606ca982b5c22dc01cdec872"},{"id":"603974470077e00873fd0920","type":"company","url":"/companies/603974470077e00873fd0920"}],"url":"/contacts/605a1845c51c55f5b7429dd5/companies","total_count":4,"has_more":false}}],"total_count":1,"pages":{"type":"pages","page":1,"per_page":50,"total_pages":1}}';
            }
           	resp = (responseCreateCustomer)JSON.deserialize(respBody, responseCreateCustomer.class);       
            resp.rawRequest = req;
            resp.respCode = String.valueOf(response.getStatusCode());
            resp.rawResp = respBody;
            System.debug('resp:' + resp);            
        }
        if(!Test.isRunningTest()){
            return resp;
        } else {
            String respBody = '{"type":"list","data":[{"type":"contact","id":"605a1845c51c55f5b7429dd5","workspace_id":"mzgbihsm","external_id":null,"role":"user","email":"garcia.alberto.crespo@gmail.com","phone":"+19175867035","name":"Al Garcia","avatar":"https://img.fullcontact.com/static/83adffc3a7340794ad564e55cbe0faf7_82e2ec7fa74e12fece1fb9cb45ec052d3e8af05353b18cdb8603a103585dfe7a","owner_id":4417245,"social_profiles":{"type":"list","data":[{"type":"social_profile","name":"linkedin","url":"https://www.linkedin.com/in/alberto-garcia-5671a813"}]},"has_hard_bounced":false,"marked_email_as_spam":false,"unsubscribed_from_emails":false,"created_at":1616517189,"updated_at":1621417438,"signed_up_at":1616517189,"last_seen_at":1620839274,"last_replied_at":1621416850,"last_contacted_at":1621417438,"last_email_opened_at":1618690753,"last_email_clicked_at":null,"language_override":null,"browser":null,"browser_version":null,"browser_language":null,"os":null,"location":{"type":"location","country":"Spain","region":"Galicia","city":"A Coruña"},"android_app_name":null,"android_app_version":null,"android_device":null,"android_os_version":null,"android_sdk_version":null,"android_last_seen_at":null,"ios_app_name":"Plantable","ios_app_version":"1.2.0","ios_device":"iPhone XR","ios_os_version":"14.4.2","ios_sdk_version":null,"ios_last_seen_at":1620839274,"custom_attributes":{"job_title":"Vice President Tech Programs","genderText":"Male","primaryGoal":"Weight loss","alcoholConsumption":"I dont drink","mostChallengingChange":"No added sugar - includes honey, agave and sweeteners","energyLevel":"5","stressLevel":"6","selfEsteem":"5","sleepLevel":"6","salesforce_id":"0031I0000068HKBQA2","salesforce_object_type":"Contact","salesforce_owner_id":"0051I000000mpKjQAI","salesforce_owner_name":"Nadja Pinnavaia","salesforce_owner_email":"nadja@plantable.com","salesforce_owner_role":"CTO","salesforce_title":"wdwdwdwdwdrg","LastMessageWasSMS":"false","LastSMSConversation":null},"tags":{"type":"list","data":[],"url":"/contacts/605a1845c51c55f5b7429dd5/tags","total_count":0,"has_more":false},"notes":{"type":"list","data":[],"url":"/contacts/605a1845c51c55f5b7429dd5/notes","total_count":0,"has_more":false},"companies":{"type":"list","data":[{"id":"6091c4be1965b42eefb0dd51","type":"company","url":"/companies/6091c4be1965b42eefb0dd51"},{"id":"6078ca7f50bb84c4864ea607","type":"company","url":"/companies/6078ca7f50bb84c4864ea607"},{"id":"606ca982b5c22dc01cdec872","type":"company","url":"/companies/606ca982b5c22dc01cdec872"},{"id":"603974470077e00873fd0920","type":"company","url":"/companies/603974470077e00873fd0920"}],"url":"/contacts/605a1845c51c55f5b7429dd5/companies","total_count":4,"has_more":false}}],"total_count":1,"pages":{"type":"pages","page":1,"per_page":50,"total_pages":1}}';
            resp = (responseCreateCustomer)JSON.deserialize(respBody, responseCreateCustomer.class);
            resp.rawRequest = req;
            resp.respCode = '200';
            resp.rawResp = respBody;
            System.debug('resp:' + resp);            
            return resp;
        }        
        
    }

    public static responseSearchCustomer getCustomer(String email) {
        responseSearchCustomer rsc;
        
        HttpResponse response = sendRequest('contacts/search', 'POST', '{"query":{"field":"email","operator":"=","value":"' + email + '"}}');
        if(response != NULL && response.getStatusCode() == 200) {
            String respBody = response.getBody();
            rsc = (responseSearchCustomer)JSON.deserialize(respBody, responseSearchCustomer.class);
            System.debug('rsc:' + rsc);            
        }
        if(!Test.isRunningTest()){
            return rsc;
        } else {
            String respBody = '{"type":"list","data":[{"type":"contact","id":"605a1845c51c55f5b7429dd5","workspace_id":"mzgbihsm","external_id":null,"role":"user","email":"garcia.alberto.crespo@gmail.com","phone":"+19175867035","name":"Al Garcia","avatar":"https://img.fullcontact.com/static/83adffc3a7340794ad564e55cbe0faf7_82e2ec7fa74e12fece1fb9cb45ec052d3e8af05353b18cdb8603a103585dfe7a","owner_id":4417245,"social_profiles":{"type":"list","data":[{"type":"social_profile","name":"linkedin","url":"https://www.linkedin.com/in/alberto-garcia-5671a813"}]},"has_hard_bounced":false,"marked_email_as_spam":false,"unsubscribed_from_emails":false,"created_at":1616517189,"updated_at":1621417438,"signed_up_at":1616517189,"last_seen_at":1620839274,"last_replied_at":1621416850,"last_contacted_at":1621417438,"last_email_opened_at":1618690753,"last_email_clicked_at":null,"language_override":null,"browser":null,"browser_version":null,"browser_language":null,"os":null,"location":{"type":"location","country":"Spain","region":"Galicia","city":"A Coruña"},"android_app_name":null,"android_app_version":null,"android_device":null,"android_os_version":null,"android_sdk_version":null,"android_last_seen_at":null,"ios_app_name":"Plantable","ios_app_version":"1.2.0","ios_device":"iPhone XR","ios_os_version":"14.4.2","ios_sdk_version":null,"ios_last_seen_at":1620839274,"custom_attributes":{"job_title":"Vice President Tech Programs","genderText":"Male","primaryGoal":"Weight loss","alcoholConsumption":"I dont drink","mostChallengingChange":"No added sugar - includes honey, agave and sweeteners","energyLevel":"5","stressLevel":"6","selfEsteem":"5","sleepLevel":"6","salesforce_id":"0031I0000068HKBQA2","salesforce_object_type":"Contact","salesforce_owner_id":"0051I000000mpKjQAI","salesforce_owner_name":"Nadja Pinnavaia","salesforce_owner_email":"nadja@plantable.com","salesforce_owner_role":"CTO","salesforce_title":"wdwdwdwdwdrg","LastMessageWasSMS":"false","LastSMSConversation":null},"tags":{"type":"list","data":[],"url":"/contacts/605a1845c51c55f5b7429dd5/tags","total_count":0,"has_more":false},"notes":{"type":"list","data":[],"url":"/contacts/605a1845c51c55f5b7429dd5/notes","total_count":0,"has_more":false},"companies":{"type":"list","data":[{"id":"6091c4be1965b42eefb0dd51","type":"company","url":"/companies/6091c4be1965b42eefb0dd51"},{"id":"6078ca7f50bb84c4864ea607","type":"company","url":"/companies/6078ca7f50bb84c4864ea607"},{"id":"606ca982b5c22dc01cdec872","type":"company","url":"/companies/606ca982b5c22dc01cdec872"},{"id":"603974470077e00873fd0920","type":"company","url":"/companies/603974470077e00873fd0920"}],"url":"/contacts/605a1845c51c55f5b7429dd5/companies","total_count":4,"has_more":false}}],"total_count":1,"pages":{"type":"pages","page":1,"per_page":50,"total_pages":1}}';
            rsc = (responseSearchCustomer)JSON.deserialize(respBody, responseSearchCustomer.class);
            return rsc;
        }
    }
    
    public static responseSetCustomer setCustomerAttribute(String id, String attribName, String attribValue) {
        responseSetCustomer rsc;
        
        HttpResponse response = sendRequest('contacts/' + id, 'PUT', '{"custom_attributes":{"' + attribName + '":"' + attribValue + '"}}');
        if(response != NULL && response.getStatusCode() == 200) {
            String respBody = response.getBody();
            
            rsc = (responseSetCustomer)JSON.deserialize(respBody, responseSetCustomer.class);
            System.debug('rsc:' + rsc);            
        }
        if(!Test.isRunningTest()){
            return rsc;
        } else {
            String respBody = '{"type":"contact","id":"605a1845c51c55f5b7429dd5","workspace_id":"mzgbihsm","external_id":null,"role":"user","email":"garcia.alberto.crespo@gmail.com","phone":"+19175867035","name":"Al Garcia","avatar":"https://img.fullcontact.com/static/83adffc3a7340794ad564e55cbe0faf7_82e2ec7fa74e12fece1fb9cb45ec052d3e8af05353b18cdb8603a103585dfe7a","owner_id":4417245,"social_profiles":{"type":"list","data":[{"type":"social_profile","name":"foursquare","url":"https://foursquare.com/user/41648507"},{"type":"social_profile","name":"youtube","url":"https://youtube.com/user/googleTubeAG2008"},{"type":"social_profile","name":"github","url":"https://github.com/agarciagit"},{"type":"social_profile","name":"linkedin","url":"https://www.linkedin.com/in/alberto-garcia-5671a813"},{"type":"social_profile","name":"vimeo","url":"http://vimeo.com/user3192809"}]},"has_hard_bounced":false,"marked_email_as_spam":false,"unsubscribed_from_emails":false,"created_at":1616517189,"updated_at":1621417438,"signed_up_at":1616517189,"last_seen_at":1620839274,"last_replied_at":1621416850,"last_contacted_at":1621417438,"last_email_opened_at":1618690753,"last_email_clicked_at":null,"language_override":null,"browser":null,"browser_version":null,"browser_language":null,"os":null,"location":{"type":"location","country":"Spain","region":"Galicia","city":"A Coruña"},"android_app_name":null,"android_app_version":null,"android_device":null,"android_os_version":null,"android_sdk_version":null,"android_last_seen_at":null,"ios_app_name":"Plantable","ios_app_version":"1.2.0","ios_device":"iPhone XR","ios_os_version":"14.4.2","ios_sdk_version":null,"ios_last_seen_at":1620839274,"custom_attributes":{"LastMessageWasSMS":"false","LastSMSConversation":null,"alcoholConsumption":"I dont drink","energyLevel":"5","genderText":"Male","job_title":"Vice President Tech Programs","mostChallengingChange":"No added sugar - includes honey, agave and sweeteners","primaryGoal":"Weight loss","salesforce_id":"0031I0000068HKBQA2","salesforce_object_type":"Contact","salesforce_owner_email":"nadja@plantable.com","salesforce_owner_id":"0051I000000mpKjQAI","salesforce_owner_name":"Nadja Pinnavaia","salesforce_owner_role":"CTO","salesforce_title":"wdwdwdwdwdrg","selfEsteem":"5","sleepLevel":"6","stressLevel":"6"},"tags":{"type":"list","data":[],"url":"/contacts/605a1845c51c55f5b7429dd5/tags","total_count":0,"has_more":false},"notes":{"type":"list","data":[],"url":"/contacts/605a1845c51c55f5b7429dd5/notes","total_count":0,"has_more":false},"companies":{"type":"list","data":[{"id":"6091c4be1965b42eefb0dd51","type":"company","url":"/companies/6091c4be1965b42eefb0dd51"},{"id":"6078ca7f50bb84c4864ea607","type":"company","url":"/companies/6078ca7f50bb84c4864ea607"},{"id":"606ca982b5c22dc01cdec872","type":"company","url":"/companies/606ca982b5c22dc01cdec872"},{"id":"603974470077e00873fd0920","type":"company","url":"/companies/603974470077e00873fd0920"}],"url":"/contacts/605a1845c51c55f5b7429dd5/companies","total_count":4,"has_more":false}}';
            rsc = (responseSetCustomer)JSON.deserialize(respBody, responseSetCustomer.class);
            return rsc;
        }
    }
    
    public static responseCreateMessage createMessage(String id, String message) {
        responseCreateMessage rcm;
    
        message = message.replace('"', '\\"');
        
        HttpResponse response = sendRequest('conversations', 'POST', '{"body":"' + message + '","from":{"type":"user","id":"'  + id + '"}}');
        if(response != NULL && response.getStatusCode() == 200) {
            String respBody = response.getBody();
            
            rcm = (responseCreateMessage)JSON.deserialize(respBody, responseCreateMessage.class);
            System.debug('rcm:' + rcm);            
        }
        if(!Test.isRunningTest()){
            return rcm;
        } else {
            String respBody = '{"type":"user_message","id":"849235332","created_at":1621419575,"body":"New message from AG","message_type":"inapp","conversation_id":"183"}';
            rcm = (responseCreateMessage)JSON.deserialize(respBody, responseCreateMessage.class);
            return rcm;
        }        
    }
    
    public static responseCreateMessage createAdminConversation(String fromId, String toId, String message) {
        responseCreateMessage rcm;
        
    	message = message.replace('"', '\\"');
        
        HttpResponse response = sendRequest('conversations', 'POST', '{"message_type": "inapp","body": "' + message + '","from": {"type": "admin","id": "' + fromId + '"},"to": {"type": "user","id": "' + toId + '"}}');
        if(response != NULL && response.getStatusCode() == 200) {
            String respBody = response.getBody();
            
            rcm = (responseCreateMessage)JSON.deserialize(respBody, responseCreateMessage.class);
            System.debug('rcm:' + rcm);            
        }
        if(!Test.isRunningTest()){
            return rcm;
        } else {
            String respBody = '{"type":"admin_message","id":"879862532","created_at":1623761909,"body":"New message from AG Test 7","message_type":"inapp","owner":{"type":"admin","id":"4671651","name":"Nikki Stanton","email":"nikki@plantable.com","away_mode_enabled":false,"away_mode_reassign":false}}';
            rcm = (responseCreateMessage)JSON.deserialize(respBody, responseCreateMessage.class);
            return rcm;
        }        
    }

    public static responseReplyConversation replyAdminConversation(String convId, String adminID, String message) {
        responseReplyConversation rcm;
        
        message = message.replace('"', '\\"');
        
        HttpResponse response = sendRequest('conversations/' + convId + '/reply', 'POST', '{"body":"' + message + '","message_type":"comment","type":"admin","admin_id":"' + adminID + '"}');
        if(response != NULL && response.getStatusCode() == 200) {
            String respBody = response.getBody();
            
            rcm = (responseReplyConversation)JSON.deserialize(respBody, responseReplyConversation.class);
            System.debug('rcm:' + rcm);            
        }
        if(!Test.isRunningTest()){
            return rcm;
        } else {
            String respBody = '{"type":"conversation","id":"110","created_at":1617381344,"updated_at":1621419620,"waiting_since":1621419620,"snoozed_until":null,"source":{"type":"conversation","id":"800864091","delivered_as":"customer_initiated","subject":"","body":"<p>newnew AG</p>","author":{"type":"user","id":"605a1845c51c55f5b7429dd5","name":"Al Garcia","email":"garcia.alberto.crespo@gmail.com"},"attachments":[],"url":null,"redacted":false},"contacts":{"type":"contact.list","contacts":[{"type":"contact","id":"605a1845c51c55f5b7429dd5"}]},"first_contact_reply":{"created_at":1617381344,"type":"conversation","url":null},"admin_assignee_id":null,"team_assignee_id":null,"open":true,"state":"open","read":true,"tags":{"type":"tag.list","tags":[]},"priority":"not_priority","sla_applied":null,"statistics":{"type":"conversation_statistics","time_to_assignment":null,"time_to_admin_reply":null,"time_to_first_close":1566,"time_to_last_close":8310,"median_time_to_reply":null,"first_contact_reply_at":1617381344,"first_assignment_at":null,"first_admin_reply_at":null,"first_close_at":1617382910,"last_assignment_at":null,"last_assignment_admin_reply_at":null,"last_contact_reply_at":1621419620,"last_admin_reply_at":null,"last_close_at":1617389654,"last_closed_by_id":4672167,"count_reopens":2,"count_assignments":0,"count_conversation_parts":7},"conversation_rating":null,"teammates":{"type":"admin.list","admins":[]},"title":"","custom_attributes":{},"topics":{},"conversation_parts":{"type":"conversation_part.list","conversation_parts":[{"type":"conversation_part","id":"8579060454","part_type":"comment","body":"<p>Replt conv</p>","created_at":1617381698,"updated_at":1617381698,"notified_at":1617381698,"assigned_to":null,"author":{"id":"605a1845c51c55f5b7429dd5","type":"user","name":"Al Garcia","email":"garcia.alberto.crespo@gmail.com"},"attachments":[],"external_id":null,"redacted":false},{"type":"conversation_part","id":"8579062648","part_type":"comment","body":"<p>Reply conv</p>","created_at":1617381710,"updated_at":1617381710,"notified_at":1617381710,"assigned_to":null,"author":{"id":"605a1845c51c55f5b7429dd5","type":"user","name":"Al Garcia","email":"garcia.alberto.crespo@gmail.com"},"attachments":[],"external_id":null,"redacted":false},{"type":"conversation_part","id":"8579269635","part_type":"close","body":null,"created_at":1617382910,"updated_at":1617382910,"notified_at":1617382910,"assigned_to":null,"author":{"id":"4672167","type":"admin","name":"Alberto Garcia","email":"garcia.alberto.crespo@gmail.com"},"attachments":[],"external_id":null,"redacted":false},{"type":"conversation_part","id":"8579733543","part_type":"comment","body":"<p>Reply conv</p>","created_at":1617385699,"updated_at":1617385699,"notified_at":1617385699,"assigned_to":null,"author":{"id":"605a1845c51c55f5b7429dd5","type":"user","name":"Al Garcia","email":"garcia.alberto.crespo@gmail.com"},"attachments":[],"external_id":null,"redacted":false},{"type":"conversation_part","id":"8580348120","part_type":"close","body":null,"created_at":1617389654,"updated_at":1617389654,"notified_at":1617389654,"assigned_to":null,"author":{"id":"4672167","type":"admin","name":"Alberto Garcia","email":"garcia.alberto.crespo@gmail.com"},"attachments":[],"external_id":null,"redacted":false},{"type":"conversation_part","id":"9185814346","part_type":"comment","body":"<p>Reply conv</p>","created_at":1621419620,"updated_at":1621419620,"notified_at":1621419620,"assigned_to":null,"author":{"id":"605a1845c51c55f5b7429dd5","type":"user","name":"Al Garcia","email":"garcia.alberto.crespo@gmail.com"},"attachments":[],"external_id":null,"redacted":false}],"total_count":6}}';
            rcm = (responseReplyConversation)JSON.deserialize(respBody, responseReplyConversation.class);
            return rcm;
        }
    }
    
    
    public static responseReplyConversation replyConversation(String convId, String email, String message) {
        responseReplyConversation rcm;
        
        message = message.replace('"', '\\"');
        
        HttpResponse response = sendRequest('conversations/' + convId + '/reply', 'POST', '{"body":"' + message + '","message_type":"comment","type":"user","email":"' + email + '"}');
        if(response != NULL && response.getStatusCode() == 200) {
            String respBody = response.getBody();
            
            rcm = (responseReplyConversation)JSON.deserialize(respBody, responseReplyConversation.class);
            System.debug('rcm:' + rcm);            
        }
        if(!Test.isRunningTest()){
            return rcm;
        } else {
            String respBody = '{"type":"conversation","id":"110","created_at":1617381344,"updated_at":1621419620,"waiting_since":1621419620,"snoozed_until":null,"source":{"type":"conversation","id":"800864091","delivered_as":"customer_initiated","subject":"","body":"<p>newnew AG</p>","author":{"type":"user","id":"605a1845c51c55f5b7429dd5","name":"Al Garcia","email":"garcia.alberto.crespo@gmail.com"},"attachments":[],"url":null,"redacted":false},"contacts":{"type":"contact.list","contacts":[{"type":"contact","id":"605a1845c51c55f5b7429dd5"}]},"first_contact_reply":{"created_at":1617381344,"type":"conversation","url":null},"admin_assignee_id":null,"team_assignee_id":null,"open":true,"state":"open","read":true,"tags":{"type":"tag.list","tags":[]},"priority":"not_priority","sla_applied":null,"statistics":{"type":"conversation_statistics","time_to_assignment":null,"time_to_admin_reply":null,"time_to_first_close":1566,"time_to_last_close":8310,"median_time_to_reply":null,"first_contact_reply_at":1617381344,"first_assignment_at":null,"first_admin_reply_at":null,"first_close_at":1617382910,"last_assignment_at":null,"last_assignment_admin_reply_at":null,"last_contact_reply_at":1621419620,"last_admin_reply_at":null,"last_close_at":1617389654,"last_closed_by_id":4672167,"count_reopens":2,"count_assignments":0,"count_conversation_parts":7},"conversation_rating":null,"teammates":{"type":"admin.list","admins":[]},"title":"","custom_attributes":{},"topics":{},"conversation_parts":{"type":"conversation_part.list","conversation_parts":[{"type":"conversation_part","id":"8579060454","part_type":"comment","body":"<p>Replt conv</p>","created_at":1617381698,"updated_at":1617381698,"notified_at":1617381698,"assigned_to":null,"author":{"id":"605a1845c51c55f5b7429dd5","type":"user","name":"Al Garcia","email":"garcia.alberto.crespo@gmail.com"},"attachments":[],"external_id":null,"redacted":false},{"type":"conversation_part","id":"8579062648","part_type":"comment","body":"<p>Reply conv</p>","created_at":1617381710,"updated_at":1617381710,"notified_at":1617381710,"assigned_to":null,"author":{"id":"605a1845c51c55f5b7429dd5","type":"user","name":"Al Garcia","email":"garcia.alberto.crespo@gmail.com"},"attachments":[],"external_id":null,"redacted":false},{"type":"conversation_part","id":"8579269635","part_type":"close","body":null,"created_at":1617382910,"updated_at":1617382910,"notified_at":1617382910,"assigned_to":null,"author":{"id":"4672167","type":"admin","name":"Alberto Garcia","email":"garcia.alberto.crespo@gmail.com"},"attachments":[],"external_id":null,"redacted":false},{"type":"conversation_part","id":"8579733543","part_type":"comment","body":"<p>Reply conv</p>","created_at":1617385699,"updated_at":1617385699,"notified_at":1617385699,"assigned_to":null,"author":{"id":"605a1845c51c55f5b7429dd5","type":"user","name":"Al Garcia","email":"garcia.alberto.crespo@gmail.com"},"attachments":[],"external_id":null,"redacted":false},{"type":"conversation_part","id":"8580348120","part_type":"close","body":null,"created_at":1617389654,"updated_at":1617389654,"notified_at":1617389654,"assigned_to":null,"author":{"id":"4672167","type":"admin","name":"Alberto Garcia","email":"garcia.alberto.crespo@gmail.com"},"attachments":[],"external_id":null,"redacted":false},{"type":"conversation_part","id":"9185814346","part_type":"comment","body":"<p>Reply conv</p>","created_at":1621419620,"updated_at":1621419620,"notified_at":1621419620,"assigned_to":null,"author":{"id":"605a1845c51c55f5b7429dd5","type":"user","name":"Al Garcia","email":"garcia.alberto.crespo@gmail.com"},"attachments":[],"external_id":null,"redacted":false}],"total_count":6}}';
            rcm = (responseReplyConversation)JSON.deserialize(respBody, responseReplyConversation.class);
            return rcm;
        }
    }


    public static responseReplyConversation closeConversation(String convId) {
        responseReplyConversation rcm;
        String fromId = Label.IntercomDefaultUser;
        
        HttpResponse response = sendRequest('conversations/' + convId + '/parts', 'POST', '{"message_type":"close","type":"admin","admin_id":"' + fromId + '"}');
        if(response != NULL && response.getStatusCode() == 200) {
            String respBody = response.getBody();
            
            rcm = (responseReplyConversation)JSON.deserialize(respBody, responseReplyConversation.class);
            System.debug('rcm:' + rcm);            
        }
        if(!Test.isRunningTest()){
            return rcm;
        } else {
            String respBody = '{"type":"conversation","id":"110","created_at":1617381344,"updated_at":1621419620,"waiting_since":1621419620,"snoozed_until":null,"source":{"type":"conversation","id":"800864091","delivered_as":"customer_initiated","subject":"","body":"<p>newnew AG</p>","author":{"type":"user","id":"605a1845c51c55f5b7429dd5","name":"Al Garcia","email":"garcia.alberto.crespo@gmail.com"},"attachments":[],"url":null,"redacted":false},"contacts":{"type":"contact.list","contacts":[{"type":"contact","id":"605a1845c51c55f5b7429dd5"}]},"first_contact_reply":{"created_at":1617381344,"type":"conversation","url":null},"admin_assignee_id":null,"team_assignee_id":null,"open":true,"state":"open","read":true,"tags":{"type":"tag.list","tags":[]},"priority":"not_priority","sla_applied":null,"statistics":{"type":"conversation_statistics","time_to_assignment":null,"time_to_admin_reply":null,"time_to_first_close":1566,"time_to_last_close":8310,"median_time_to_reply":null,"first_contact_reply_at":1617381344,"first_assignment_at":null,"first_admin_reply_at":null,"first_close_at":1617382910,"last_assignment_at":null,"last_assignment_admin_reply_at":null,"last_contact_reply_at":1621419620,"last_admin_reply_at":null,"last_close_at":1617389654,"last_closed_by_id":4672167,"count_reopens":2,"count_assignments":0,"count_conversation_parts":7},"conversation_rating":null,"teammates":{"type":"admin.list","admins":[]},"title":"","custom_attributes":{},"topics":{},"conversation_parts":{"type":"conversation_part.list","conversation_parts":[{"type":"conversation_part","id":"8579060454","part_type":"comment","body":"<p>Replt conv</p>","created_at":1617381698,"updated_at":1617381698,"notified_at":1617381698,"assigned_to":null,"author":{"id":"605a1845c51c55f5b7429dd5","type":"user","name":"Al Garcia","email":"garcia.alberto.crespo@gmail.com"},"attachments":[],"external_id":null,"redacted":false},{"type":"conversation_part","id":"8579062648","part_type":"comment","body":"<p>Reply conv</p>","created_at":1617381710,"updated_at":1617381710,"notified_at":1617381710,"assigned_to":null,"author":{"id":"605a1845c51c55f5b7429dd5","type":"user","name":"Al Garcia","email":"garcia.alberto.crespo@gmail.com"},"attachments":[],"external_id":null,"redacted":false},{"type":"conversation_part","id":"8579269635","part_type":"close","body":null,"created_at":1617382910,"updated_at":1617382910,"notified_at":1617382910,"assigned_to":null,"author":{"id":"4672167","type":"admin","name":"Alberto Garcia","email":"garcia.alberto.crespo@gmail.com"},"attachments":[],"external_id":null,"redacted":false},{"type":"conversation_part","id":"8579733543","part_type":"comment","body":"<p>Reply conv</p>","created_at":1617385699,"updated_at":1617385699,"notified_at":1617385699,"assigned_to":null,"author":{"id":"605a1845c51c55f5b7429dd5","type":"user","name":"Al Garcia","email":"garcia.alberto.crespo@gmail.com"},"attachments":[],"external_id":null,"redacted":false},{"type":"conversation_part","id":"8580348120","part_type":"close","body":null,"created_at":1617389654,"updated_at":1617389654,"notified_at":1617389654,"assigned_to":null,"author":{"id":"4672167","type":"admin","name":"Alberto Garcia","email":"garcia.alberto.crespo@gmail.com"},"attachments":[],"external_id":null,"redacted":false},{"type":"conversation_part","id":"9185814346","part_type":"comment","body":"<p>Reply conv</p>","created_at":1621419620,"updated_at":1621419620,"notified_at":1621419620,"assigned_to":null,"author":{"id":"605a1845c51c55f5b7429dd5","type":"user","name":"Al Garcia","email":"garcia.alberto.crespo@gmail.com"},"attachments":[],"external_id":null,"redacted":false}],"total_count":6}}';
            rcm = (responseReplyConversation)JSON.deserialize(respBody, responseReplyConversation.class);
            return rcm;
        }
    }
    
    public static responseReplyConversation openConversation(String convId) {
        responseReplyConversation rcm;
        String fromId = Label.IntercomDefaultUser;
        
        HttpResponse response = sendRequest('conversations/' + convId + '/parts', 'POST', '{"message_type":"open","type":"admin","admin_id":"' + fromId + '"}');
        if(response != NULL && response.getStatusCode() == 200) {
            String respBody = response.getBody();
            
            rcm = (responseReplyConversation)JSON.deserialize(respBody, responseReplyConversation.class);
            System.debug('rcm:' + rcm);            
        }
        if(!Test.isRunningTest()){
            return rcm;
        } else {
            String respBody = '{"type":"conversation","id":"110","created_at":1617381344,"updated_at":1621419620,"waiting_since":1621419620,"snoozed_until":null,"source":{"type":"conversation","id":"800864091","delivered_as":"customer_initiated","subject":"","body":"<p>newnew AG</p>","author":{"type":"user","id":"605a1845c51c55f5b7429dd5","name":"Al Garcia","email":"garcia.alberto.crespo@gmail.com"},"attachments":[],"url":null,"redacted":false},"contacts":{"type":"contact.list","contacts":[{"type":"contact","id":"605a1845c51c55f5b7429dd5"}]},"first_contact_reply":{"created_at":1617381344,"type":"conversation","url":null},"admin_assignee_id":null,"team_assignee_id":null,"open":true,"state":"open","read":true,"tags":{"type":"tag.list","tags":[]},"priority":"not_priority","sla_applied":null,"statistics":{"type":"conversation_statistics","time_to_assignment":null,"time_to_admin_reply":null,"time_to_first_close":1566,"time_to_last_close":8310,"median_time_to_reply":null,"first_contact_reply_at":1617381344,"first_assignment_at":null,"first_admin_reply_at":null,"first_close_at":1617382910,"last_assignment_at":null,"last_assignment_admin_reply_at":null,"last_contact_reply_at":1621419620,"last_admin_reply_at":null,"last_close_at":1617389654,"last_closed_by_id":4672167,"count_reopens":2,"count_assignments":0,"count_conversation_parts":7},"conversation_rating":null,"teammates":{"type":"admin.list","admins":[]},"title":"","custom_attributes":{},"topics":{},"conversation_parts":{"type":"conversation_part.list","conversation_parts":[{"type":"conversation_part","id":"8579060454","part_type":"comment","body":"<p>Replt conv</p>","created_at":1617381698,"updated_at":1617381698,"notified_at":1617381698,"assigned_to":null,"author":{"id":"605a1845c51c55f5b7429dd5","type":"user","name":"Al Garcia","email":"garcia.alberto.crespo@gmail.com"},"attachments":[],"external_id":null,"redacted":false},{"type":"conversation_part","id":"8579062648","part_type":"comment","body":"<p>Reply conv</p>","created_at":1617381710,"updated_at":1617381710,"notified_at":1617381710,"assigned_to":null,"author":{"id":"605a1845c51c55f5b7429dd5","type":"user","name":"Al Garcia","email":"garcia.alberto.crespo@gmail.com"},"attachments":[],"external_id":null,"redacted":false},{"type":"conversation_part","id":"8579269635","part_type":"close","body":null,"created_at":1617382910,"updated_at":1617382910,"notified_at":1617382910,"assigned_to":null,"author":{"id":"4672167","type":"admin","name":"Alberto Garcia","email":"garcia.alberto.crespo@gmail.com"},"attachments":[],"external_id":null,"redacted":false},{"type":"conversation_part","id":"8579733543","part_type":"comment","body":"<p>Reply conv</p>","created_at":1617385699,"updated_at":1617385699,"notified_at":1617385699,"assigned_to":null,"author":{"id":"605a1845c51c55f5b7429dd5","type":"user","name":"Al Garcia","email":"garcia.alberto.crespo@gmail.com"},"attachments":[],"external_id":null,"redacted":false},{"type":"conversation_part","id":"8580348120","part_type":"close","body":null,"created_at":1617389654,"updated_at":1617389654,"notified_at":1617389654,"assigned_to":null,"author":{"id":"4672167","type":"admin","name":"Alberto Garcia","email":"garcia.alberto.crespo@gmail.com"},"attachments":[],"external_id":null,"redacted":false},{"type":"conversation_part","id":"9185814346","part_type":"comment","body":"<p>Reply conv</p>","created_at":1621419620,"updated_at":1621419620,"notified_at":1621419620,"assigned_to":null,"author":{"id":"605a1845c51c55f5b7429dd5","type":"user","name":"Al Garcia","email":"garcia.alberto.crespo@gmail.com"},"attachments":[],"external_id":null,"redacted":false}],"total_count":6}}';
            rcm = (responseReplyConversation)JSON.deserialize(respBody, responseReplyConversation.class);
            return rcm;
        }
    }

    
    public static sendCampaignSMSReturn sendCampaignMsg(String email, String message, Boolean isApp) {
        
        String fromId = Label.IntercomDefaultUser; // Get from custom settings
        sendCampaignSMSReturn ret = new sendCampaignSMSReturn();
        ret.lstAddAPIReq = new List<API_Request__c>();
        
        ret.message = message;
        
        responseSearchCustomer rsc = getCustomer(email);
        String intercomContactID;
        if(rsc != NULL && rsc.data != NULL && rsc.data.size() > 0 && rsc.data[0].id != NULL) {
            intercomContactID = rsc.data[0].id;
        } else {
            List<Account> lstAcct = [select Id, Name, First_Name__c, Last_Name__c  from Account where Email__c = :email];
            if(lstAcct != NULL && lstAcct.size() > 0) {
                responseCreateCustomer resp = createCustomer(lstAcct[0].Id, email, lstAcct[0].First_Name__c + ' ' + lstAcct[0].Last_Name__c);
                if(resp != NULL) {
                    if(resp.Id != NULL) {
                        intercomContactID = resp.Id;    
                    }
                    API_Request__c apiReq1 = new API_Request__c(Raw_Request__c=resp.rawRequest, Request_Type__c='Intercom Outbound',Account__c=lstAcct[0].Id, Response__c = resp.respCode + ':' + resp.rawResp);
                    ret.lstAddAPIReq.add(apiReq1);
                }
            }
        }
        System.debug('intercomContactID:' + intercomContactID);
                
        responseCreateMessage rcm;
        if(intercomContactID != NULL) {
            rcm = createAdminConversation(fromId, intercomContactID, message);
        }
        
        return ret;
    }


    @future(callout=true)
    public static void SMStoIntercomCustomerMsg(String email, String message, String caseId, String isNew) {

        List<Case> lstCases = [select Id, Intercom_Conversation_ID__c, ContactID, AccountID, Contact.Name from Case where id = :caseId];
        System.debug('lstCases:' + lstCases);
        API_Request__c apiReq;
        List<In_App_Message__c> lstNewInAppMsg = new List<In_App_Message__c>();
        
        if(lstCases != NULL && lstCases.size() > 0) {
            Case caseRec = lstCases[0];
        
            responseSearchCustomer rsc = getCustomer(email);
            String intercomContactID;
            if(rsc != NULL && rsc.data != NULL && rsc.data.size() > 0 && rsc.data[0].id != NULL) {
                intercomContactID = rsc.data[0].id;
            } else {
                responseCreateCustomer resp = createCustomer(caseRec.ContactID, email, caseRec.Contact.Name);
                if(resp != NULL && resp.Id != NULL) {
                    intercomContactID = resp.Id;
                }
                apiReq = new API_Request__c(Raw_Request__c=resp.rawRequest, Request_Type__c='Intercom Outbound',Account__c=lstCases[0].AccountID, Response__c = resp.respCode + ':' + resp.rawResp);
            }
            System.debug('intercomContactID:' + intercomContactID);

            // Check any Campaign Messages to find conversation
            List<In_App_Message__c> lstInAppMsg = [select Id, Name, Conversation_ID__c, Case__c from In_App_Message__c where Contact__c = :caseRec.ContactID AND Conversation_ID__c != NULL AND Case__c = NULL Order By CreatedDate];
            System.debug('lstInAppMsg:' + lstInAppMsg);
            
            if(lstInAppMsg != NULL && lstInAppMsg.size() > 0) {
                lstInAppMsg[0].Case__c = caseRec.id;                
                caseRec.Intercom_Conversation_ID__c = lstInAppMsg[0].Conversation_ID__c;
                //Open the conversation so it show in the Inbox
                openConversation(lstInAppMsg[0].Conversation_ID__c);
            }
            
            if(intercomContactID != NULL) {
                String convId;
                if(isNew == 'True' && caseRec.Intercom_Conversation_ID__c == NULL) {
                    responseCreateMessage rcm = createMessage(intercomContactID, message);
                    convId = rcm.conversation_id;
                    
                    In_App_Message__c inAppMsg = new In_App_Message__c(
                        Name = rcm.id,
                        Contact__c = caseRec.ContactId,
                        Message_ID__c = rcm.id,
                        Type__c = 'Customer Start Conversation',
                        Message__c = message,
                        Case__c = caseRec.Id
                    );                      
                    lstNewInAppMsg.add(inAppMsg);
                    
                } else {
                    responseReplyConversation rcm = replyConversation(caseRec.Intercom_Conversation_ID__c, email, message); 
                    if(rcm != NULL && rcm.id != NULL) {
                        convId = rcm.id;
                    }
                    In_App_Message__c inAppMsg = new In_App_Message__c(
                        Name = rcm.id,
                        Contact__c = caseRec.ContactId,
                        Message_ID__c = rcm.id,
                        Type__c = 'Customer Reply',
                        Message__c = message,
                        Conversation_ID__c = caseRec.Intercom_Conversation_ID__c,
                        Case__c = caseRec.Id
                    );                      
                    lstNewInAppMsg.add(inAppMsg);                    
                }
                System.debug('convId:' + convId);
                
                caseRec.Intercom_Conversation_ID__c = convId;
                update caseRec;
            }
            update lstInAppMsg;
            if(apiReq != NULL) {
                insert apiReq;
            }
            insert lstNewInAppMsg;
        }        
    }
    
    public static String IntercomAdminStart(String contactId, String email, String message, String convId, String subject) {
        String ret;
        
        // Update Profile
        responseSearchCustomer rsc = getCustomer(email);
        if(rsc.data != NULL && rsc.data.size() > 0) {
            
            List<Contact> lstCont = [select Id, AccountId from Contact where email = :email];
            
            // Update Cases
            if(lstCont != NULL && lstCont.size() > 0) { 
                List<Case> lstCases = [select Id, Status from Case where Intercom_Conversation_ID__c = :convId];
                System.debug('lstCases:' + lstCases);
                
                if(lstCases != NULL && lstCases.size() > 0) {
                    // Do not reopen case, leave closed
                } else {
                    if(message != NULL && message.length() > 255) {
                        message = message.substring(0,254);
                    }
                    String recordTypeId = RecordTypeHelper.GetRecordTypeId('Case', 'Customer');
                    
                    // Create Case closed so it can be reopend on reply
                    Case cs = new Case(Origin = 'In-App', 
                                       Intercom_Conversation_ID__c = convId, 
                                       Subject = message,
                                       Contact = lstCont[0],
                                       Accountid = lstCont[0].AccountId,
                                       ContactId = lstCont[0].Id,
                                       Status = 'Closed',
                                       RecordTypeId = recordTypeId );
                    insert cs;
                    ret = cs.Id;
                }    
            }
        }
        
        return ret;
    }


    public static String IntercomAdminMsg(String contactId, String email, String message, String convId, String subject) {
        String ret;
        
        System.debug('subject:' + subject);
        
        responseSearchCustomer rsc = getCustomer(email);
        if(rsc.data != NULL && rsc.data.size() > 0) {
                        
            // Update Cases
            // Intercom_Conversation_ID__c = :convId
            List<Case> lstCases = [select Id, Origin, Intercom_Conversation_ID__c from Case where ContactID = :contactId and Status <> 'Closed'];
            System.debug('lstCases:' + lstCases);
            
            if(lstCases != NULL && lstCases.size() > 0) {
                
                for(Case c: lstCases) {
                    System.debug('c:' + lstCases);
                    
                    ret = c.Id;
                    
                    // Send SMS If needed    
                    if(c.Origin == 'SMS' && c.Intercom_Conversation_ID__c == convId) {
                        message = message.replaceAll('\\<.*?\\>', '');
                        SMS_Message__c newSMS = new SMS_Message__c(Name='InAppAdminReply',
                                                    Message__c=message,
                                                    Enable_Automation__c=True,
                                                    Contact__c=contactId,
                                                    Case__c = c.Id
                                                   ); 
                        insert newSMS; 
                    } else if(c.Origin == 'Email' && subject != NULL) {
                        System.debug('c.Intercom_Conversation_ID__c:' + c.Intercom_Conversation_ID__c);
                        
                        ret = c.Id;
                        if(c.Intercom_Conversation_ID__c == NULL) {
                            c.Intercom_Conversation_ID__c = convId;
                            update c;
                        }
                    }               
                }
            }            
        }
        return ret;
    }
    
    
    // Return CaseId if conversation is related to a case
    public static String IntercomCustomerMsg(String contactId, String email, String message, String convId, String convMsgId) {
        String ret;
        
        // Update Profile
        responseSearchCustomer rsc = getCustomer(email);
        if(rsc.data != NULL && rsc.data.size() > 0) {
            
            List<Contact> lstCont = [select Id, AccountId from Contact where email = :email];
            
            List<Health_Survey__c> lstSurvey = [Select Id, Is_App__c, Age__c, Gender__c, Most_Challenging_Change__c, Alcohol_Consumption__c, Primary_Goal__c, 
                                                Energy__c, Stress__c, Self_Esteem__c, Sleep__c, Drink_Other__c, Hydration__c, Snacks__c, Lunch__c, 
                                                Breakfast_Time__c, Coffee_Tea_TakeIt__c, Coffee_Tea__c, Lbs_Away_From_Happy_Weight__c, Is_Happy_Weight__c,
                                                Weight_Text__c, Height_Text__c, Wake_Up_Time__c
                                                from Health_Survey__c where Account__r.Email__c = :email AND Is_App__c = True];

            if(lstSurvey != NULL && lstSurvey.size() > 0) {
                lstSurvey[0].Age__c = rsc.data[0].custom_attributes.ageRange;
                lstSurvey[0].Gender__c = rsc.data[0].custom_attributes.genderText;
                lstSurvey[0].Most_Challenging_Change__c = rsc.data[0].custom_attributes.mostChallengingChange;                
                lstSurvey[0].Alcohol_Consumption__c = rsc.data[0].custom_attributes.alcoholConsumption;                
                lstSurvey[0].Primary_Goal__c = rsc.data[0].custom_attributes.primaryGoal;   
                lstSurvey[0].Wake_Up_Time__c = rsc.data[0].custom_attributes.wakeUpTime;   
                lstSurvey[0].Drink_Other__c = rsc.data[0].custom_attributes.drinkOther;   
                lstSurvey[0].Hydration__c = rsc.data[0].custom_attributes.hydration;   
                lstSurvey[0].Snacks__c = rsc.data[0].custom_attributes.snacks;   
                lstSurvey[0].Lunch__c = rsc.data[0].custom_attributes.lunch;   
                lstSurvey[0].Breakfast_Time__c = rsc.data[0].custom_attributes.breakfastTime;   
                lstSurvey[0].Coffee_Tea_TakeIt__c = rsc.data[0].custom_attributes.coffeeTeaTakeIt;   
                lstSurvey[0].Coffee_Tea__c = rsc.data[0].custom_attributes.coffeeTea;   
                lstSurvey[0].Lbs_Away_From_Happy_Weight__c = rsc.data[0].custom_attributes.lbsAwayFromHappyWeight;   
                lstSurvey[0].Is_Happy_Weight__c = rsc.data[0].custom_attributes.isHappyWeight;  
                lstSurvey[0].Weight_Text__c = rsc.data[0].custom_attributes.weightText;
                lstSurvey[0].Height_Text__c = rsc.data[0].custom_attributes.heightText;   

                if(rsc.data[0].custom_attributes.energyLevel != NULL) {
                    String[] parts = rsc.data[0].custom_attributes.energyLevel.split(' ');
                    if(parts.size() > 0) {
                        lstSurvey[0].Energy__c = Decimal.valueOf(parts[0]);
                    }
                }
                
                if(rsc.data[0].custom_attributes.stressLevel != NULL) {
                    String[] parts = rsc.data[0].custom_attributes.stressLevel.split(' ');
                    if(parts.size() > 0) {
                        lstSurvey[0].Stress__c = Decimal.valueOf(parts[0]); 
                    }
                }
                
                if(rsc.data[0].custom_attributes.selfEsteem != NULL) {
                    String[] parts = rsc.data[0].custom_attributes.selfEsteem.split(' ');
                    if(parts.size() > 0) {
                        lstSurvey[0].Self_Esteem__c = Decimal.valueOf(parts[0]);
                    }
                }
                    
                
                if(rsc.data[0].custom_attributes.sleepLevel != NULL) {
                    String[] parts = rsc.data[0].custom_attributes.sleepLevel.split(' ');
                    if(parts.size() > 0) {
                        lstSurvey[0].Sleep__c = Decimal.valueOf(parts[0]);
                    }
                }
                
                System.debug('tags:' + rsc.data[0].tags);
                
                if(rsc.data[0].tags != NULL && rsc.data[0].tags.data != NULL  && rsc.data[0].tags.data.size() > 0) {
                    for(responseSearchCustomerTagsData rd :rsc.data[0].tags.data) {
                        
                        System.debug('rd:' + rd);
                        System.debug('Label.IntercomCompletedSurveyTagId:' + Label.IntercomCompletedSurveyTagId);
                        
                        if(rd.id == Integer.valueOf(Label.IntercomCompletedSurveyTagId)) {
                            lstSurvey[0].Completed_In_App__c = True;
                            System.debug('update survey:' + lstSurvey[0]);
                            
                            break;
                        }
                    }
                }
                
                Update lstSurvey;
            } else {
                
                if(lstCont != NULL && lstCont.size() > 0) {
                    
                    Health_Survey__c hs = new Health_Survey__c(
                        Account__c = lstCont[0].AccountId,
                        Is_App__c = True,
                        Gender__c = rsc.data[0].custom_attributes.genderText,
                        Most_Challenging_Change__c = rsc.data[0].custom_attributes.mostChallengingChange,
                        Alcohol_Consumption__c = rsc.data[0].custom_attributes.alcoholConsumption,
                        Primary_Goal__c = rsc.data[0].custom_attributes.primaryGoal
                    );
                    if(rsc.data[0].custom_attributes.energyLevel != NULL)
                        hs.Energy__c = Decimal.valueOf(rsc.data[0].custom_attributes.energyLevel);
                    
                    if(rsc.data[0].custom_attributes.energyLevel != NULL)
                        hs.Stress__c = Decimal.valueOf(rsc.data[0].custom_attributes.stressLevel); 
                    
                    if(rsc.data[0].custom_attributes.energyLevel != NULL)
                        hs.Self_Esteem__c = Decimal.valueOf(rsc.data[0].custom_attributes.selfEsteem);
                    
                    if(rsc.data[0].custom_attributes.energyLevel != NULL)
                        hs.Sleep__c = Decimal.valueOf(rsc.data[0].custom_attributes.sleepLevel);
                    
                    insert hs;
                }
            }
            
            // Update Cases
            if(lstCont != NULL && lstCont.size() > 0) { 
                List<Case> lstCases = [select Id, Status from Case where Intercom_Conversation_ID__c = :convId];
                System.debug('lstCases:' + lstCases);
                
                if(lstCases != NULL && lstCases.size() > 0) {
                    ret = lstCases[0].Id;
                    if(lstCases[0].Status == 'Closed') {
                        lstCases[0].Status = 'In Progress';
                        lstCases[0].Do_No_Fire__c = True;                        
                        update lstCases;
                    }
                } else {
                    if(message != NULL && message.length() > 255) {
                        message = message.substring(0,254);
                    }
                    String recordTypeId = RecordTypeHelper.GetRecordTypeId('Case', 'Customer');
                    Case cs = new Case(Origin = 'In-App', 
                                  Intercom_Conversation_ID__c = convId, 
                                  Subject = message,
                                  Contact = lstCont[0],
                                  Accountid = lstCont[0].AccountId,
                                  ContactId = lstCont[0].Id,
                                  RecordTypeId = recordTypeId );
                    insert cs;
                    ret = cs.Id;
                    
                    if(convMsgId != NULL) {
                        List<In_App_Message__c> lstMsg = [select Id, Name, Case__c from In_App_Message__c where Message_ID__c = :convMsgId];
                        System.debug('lstMsg:' + lstMsg);
                        for(In_App_Message__c iam :lstMsg) {
                            iam.Case__c = ret;
                        }
                        update lstMsg;
                    }
                 }    
            }

        }
        return ret;
    }

    public static Boolean IntercomConversationClosed(String userId, String conversationId) {
        Boolean ret=False;
        
        setCustomerAttribute(userId, 'LastSMSConversation', '');
        setCustomerAttribute(userId,'LastMessageWasSMS','false');            
        List<Case> lstCases = [select Id, Status from Case where Intercom_Conversation_ID__c = :conversationId AND Status != 'Closed'];
        if(lstCases != NULL && lstCases.size() > 0) {
            lstCases[0].Status = 'Closed';
            update lstCases;
        }
        return ret;
    }


    public static Boolean IntercomUpdateUserActivity(String email) {
        Boolean ret=False;
        
        responseSearchCustomer rsc = getCustomer(email);

        List<Account> lstAcct = [select Id, Suggestic_Last_Seen__c from Account where Email__c = :email];
        if(lstAcct != NULL && lstAcct.size() > 0) {
            Long epoch = Long.valueOf(String.ValueOf(rsc.data[0].ios_last_seen_at));
            lstAcct[0].Suggestic_Last_Seen__c = DateTime.newInstance(epoch * 1000);
            update lstAcct;
        }
        return ret;
    }



    @InvocableMethod(label='IntercomMethods' description='Operate Intercom Class Methods.')
    public static void IntercomMethods(List<List<String>> inputParams) {  
        
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
                
                if(method == 'SMStoIntercomCustomerMsg') {
                    SMStoIntercomCustomerMsg(param1, param2, param3, param4);
                }
                
            }
        }
   
    }            
}