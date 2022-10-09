@isTest
global class OneWireLocationsMockHttpCallout implements HttpCalloutMock{
    
	global HttpResponse respond(HttpRequest req){
        
        String json = '[{"Id":69703,"Name":"Los Angeles","DisplayName":"Los Angeles, CA","StateId":0,"State":{"Id":4,"Name":"California","Abbreviation":"CA","CountryId":0,"Country":{"Id":1,"Name":"United States","IsoCountryCode":null,"IsoThreeCode":null}},"Population":null,"Latitude":0,"Longitude":0}';
        
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');
		res.setBody(json);
		res.setStatusCode(200);
		return res;
		 
	}	   
    
}