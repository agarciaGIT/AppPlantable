public class SFMC_integrationClass {
    public static string SFMCautheration(){ 
        String accessToken ;     
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://mc50vhgyl-pn1kqqp-ywmr256hy4.auth.marketingcloudapis.com//v2/token');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        // Set the body as a JSON object
        request.setBody('{"grant_type": "client_credentials","client_id": "un0bc570ugaal2th3ehhcgfv","client_secret": "39uOcnKIJVD2kbiP36HasWiI"}');
        HttpResponse response = http.send(request);
        system.debug(response.getStatusCode());
        // Parse the JSON response
        if (response.getStatusCode() != 201) {
            System.debug(response.getBody() + 'The status code returned was not expected: ' +  response.getStatusCode() + ' ' + response.getStatus());
            JSONParser parser = JSON.createParser(response.getBody());
            if(test.isRunningTest()){
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)) {
                    String fieldName = parser.getText();
                    parser.nextToken();
                    System.debug('fieldName'+fieldName);
                    if (fieldName == 'access_token') {
                        accessToken = parser.getText();
                    }
                }
            }
            }
        } else {
            System.debug(response.getBody());
        }
        
        return accessToken;
    }
    
    public static void UpdateSubscriber(){
        String accesstoken = SFMCautheration();
        String SubscriberKey ='00Q1W00001VVuztUAD';
        string EmailAddress='vvkathi@gmail.com';
        String body = '<?xml version="1.0" encoding="UTF-8"?>'+
            '<s:Envelope xmlns:s="http://www.w3.org/2003/05/soap-envelope" xmlns:a="http://schemas.xmlsoap.org/ws/2004/08/addressing" xmlns:u="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">'+
            '<s:Header>'+
            '<fueloauth xmlns="http://exacttarget.com">'+accesstoken+'</fueloauth>'+
            '</s:Header>'+
            '<s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  xmlns:xsd="http://www.w3.org/2001/XMLSchema">'+
            '<CreateRequest xmlns="http://exacttarget.com/wsdl/partnerAPI">'+
            '<Options>'+
            '<SaveOptions>'+
            '<SaveOption>'+
            '<PropertyName>*</PropertyName>'+
            '<SaveAction>UpdateAdd</SaveAction>'+
            '</SaveOption>'+
            '</SaveOptions>'+
            '</Options>'+
            '<Objects xsi:type="Subscriber">'+
            '<SubscriberKey>'+SubscriberKey +'</SubscriberKey>'+
            '<EmailAddress>'+ EmailAddress +'</EmailAddress>'+
            '</Objects> </CreateRequest></s:Body></s:Envelope>';
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://mc50vhgyl-pn1kqqp-ywmr256hy4.soap.marketingcloudapis.com/Service.asmx');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'text/xml');
        request.setHeader('SOAPAction','Create');
        // Set the body as a JSON object
        request.setBody(body);
        HttpResponse response = http.send(request);
        // Parse the JSON response
       System.debug(response.getBody());
        if (response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
    }
}