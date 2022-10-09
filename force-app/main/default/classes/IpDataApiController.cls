public without sharing class IpDataApiController {

    public IpDataResponse ipDataResponse { get; set; }

    public class IpDataResponse {
        public string country_name { get; set; }
        public string message { get; set; }
        public string ipAddress { get; set; }
        public Boolean capOn { get; set; }
        public string capKey { get; set; }        
    }

    public IpDataApiController(sfdcAppRemoter ctrl) {

        // Retrieve the user's IP address
        
        try{
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            String ipAddress = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
            request.setEndPoint('https://api.ipdata.co/' + ipAddress + '?api-key=89c58a51ef360d55ea4969a38df3fe65fbe13c67086aed830a8ca6b4');
            request.setMethod('GET');
            request.setTimeout(2000);
            HttpResponse response = http.send(request);
            ipDataResponse = (IpDataResponse)JSON.deserialize(response.getBody(), IpDataResponse.class);
            ipDataResponse.country_name = ipDataResponse.country_name;
            ipDataResponse.message = ipDataResponse.message;
            ipDataResponse.ipAddress = ipAddress;
            ipDataResponse.capOn = False;
            
            CAPTCHA_Configuration__c capConfig = Utilities.getCaptchaConfiguration();
            if(capConfig != NULL && capConfig.Use_Real_Captcha__c != NULL && capConfig.Use_Real_Captcha__c == True &&
               capConfig.Site_Key__c != NULL) {
                ipDataResponse.capOn = True;
                ipDataResponse.capKey = capConfig.Site_Key__c;
            }
            
            //System.assert(false, 'BOOM!1' + capConfig);
            
        }catch(Exception e){
            ipDataResponse = new IpDataResponse();
            ipDataResponse.message = e.getMessage();
        }

    }

}