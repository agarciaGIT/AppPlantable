public class onfleetClass {

    Public class onfleetDestRet {
		String id;
  		Integer timeCreated;
  		Integer timeLastModified;
  		List<Integer> location;        
    }
    
    Public class onfleetDestination {
        onfleetAddress address;
        String notes;
    }
    
    Public class onfleetAddress {
        String apartment;
        String state;
        String postalCode;
        String country;
        String city;
        String street;
        String numberA;
    }
    
    public static onfleetDestRet createDestination(onfleetDestination dest) {
        onfleetDestRet ret;

        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://euphebe-shop.myshopify.com/admin/orders/';
        request.setEndPoint(endpoint);
        request.setMethod('GET');        
        String username = 'ccc7726248fa05de9a514a582702db61';
        String password = '';
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);        
        HttpResponse response;
        Integer statusCode;
        if(!Test.isRunningTest()){
            response = httpProtocol.send(request);
            statusCode = response.getStatusCode();
        } else {
            response = new HttpResponse();
            statusCode = 200;
        }        
        system.debug('statusCode:' + String.valueOf(statusCode));
        if(statusCode == 200) {
			String body;
            if(!Test.isRunningTest()){
            	body = response.getBody();
            } else {
                body = '{}';
            }            
            System.debug('body:' + body);
            ret = (onfleetDestRet)JSON.deserialize(body, onfleetDestRet.class);
            System.debug('onfleetDestRet:' + ret);
        }
        return ret;        
    }
    
    
    
    //public static void setShipment(String shipmentId) {  
    //}
    
	@InvocableMethod(label='onfleetFlow' description='Methods for onfleet.')
    public static void onfleetFlow(List<String> ids) {
    
        if(ids.size() > 1) {
            if(ids[0] == 'setShipment') {
                // ids[1] == Shipment Id
                //setShipment(ids[1]);
            }            
        }
   }
}