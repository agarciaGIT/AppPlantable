@IsTest
global class IpDataApiControllerHttpMock implements HttpCalloutMock {
    
	global HttpResponse respond(HttpRequest req) {

        String jsonString = '{"country_name" : "United States", "message" : "success"}';
        
		HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
		res.setBody(jsonString);
		return res;
		 
	}	    
    
}