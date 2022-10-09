@isTest
global class GrenadineMockErrorResponseGenerator implements HttpCalloutMock  {
    
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('UnAuthorized'); 
        res.setStatusCode(401);
        return res;
    }
    
}