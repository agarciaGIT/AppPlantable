public class pardotClass {
/*    
    public static HTTPResponse sendRequest(String url, String reqParams, Boolean isAuth) {
        
        String endpoint = 'https://pi.pardot.com/api/login/version/3';
        if(url != null)
            endpoint = url;
        
        System.debug('endpoint:' + endpoint);
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
            
        if(isAuth == true)
            request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        else request.setHeader('Content-Type', 'application/json');
        
        request.setMethod('POST');
        if(reqParams != null)
            request.setbody(reqParams);
        
        Http http = new Http();
        
        HTTPResponse response;       
        Integer statusCode;
        
        if(!Test.isRunningTest()){
            response = http.send(request);
            statusCode = response.getStatusCode();
        } else {
            response = new HttpResponse();
            statusCode = 200;
        }        
        
        System.debug('response:' + response.getStatusCode());
        System.debug('body:' + response.getBody());
        
        String body;
        if(statusCode == 200) {
            if(!Test.isRunningTest()){
                body = response.getBody();
            } else {
                body = '{}';
            }            
            if(body != NULL && body.indexOf('{') == -1) {
                body=body.remove('"');
                body=body.remove('\n');
                body = '{"status":1,"Error":"' + body + '"}';
            }
            System.debug('body:' + body);
        }
        
        return response;
    }
*/    
    @future(callout=true)
    public static void optInUser(String email) {

        /*
        Map<String,Pardot_API_Config__c> rSites = Pardot_API_Config__c.getall();
        String AuthEmail = rSites.get('AuthEmail').Value__c;
        String AuthPassword = rSites.get('AuthPassword').Value__c;
        String AuthUserKey = rSites.get('AuthUserKey').Value__c;
        String LoginEndPoint = rSites.get('LoginEndPoint').Value__c;
        String ProspectUpdateEndPoint = rSites.get('ProspectUpdateEndPoint').Value__c;
        
        HTTPResponse resp = sendRequest(LoginEndPoint,'email=' + AuthEmail + '&password=' + AuthPassword + '&user_key=' + AuthUserKey, True);
        
        dom.Document doc;
        if(!Test.isRunningTest()){
            doc = resp.getBodyDocument();
        } else {
            doc=new DOM.Document();
            String XMLString = '<?xml version="1.0" encoding="UTF-8"?><rsp stat="ok" version="1.0"><api_key>698d574eb6fc406f14315830d4e8d966</api_key></rsp>';
            doc.load(XMLString);
        }
        system.debug('doc == '+doc);
        
        Dom.XMLNode responseNode = doc.getRootElement();
        system.debug('responseNode == '+responseNode);

        List<Dom.xmlNode> channelNodes = responseNode.getChildElements();
        system.debug('channelNodes == '+channelNodes);
        
        Dom.xmlNode channelNode = channelNodes[0];
        system.debug('channelNode == '+channelNode);
        
        if(channelNode != null) {
            String secKey = channelNode.getText();
            system.debug('secKey == '+secKey);
            
            if(secKey != NULL && secKey.length() > 0) {

                String url = ProspectUpdateEndPoint + '/' + email + '?api_key=' + secKey + '&user_key=' + AuthUserKey + '&is_do_not_email=0&opted_out=0';
                HTTPResponse resp1 = sendRequest(url, null, False);
                system.debug('resp1 == '+resp1);
                
            }
            
        }
		*/
    }
    
}