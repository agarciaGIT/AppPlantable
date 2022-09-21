@isTest 
public class RESTSMSController_test {
    
    public static void setup(){
    }
    
    @isTest
    private static void test1(){
        setup();
        Test.startTest();    
        
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        RestContext.request = request;
        RestContext.response = response;
        
        RestContext.response.statusCode = 200; 
        
        RESTSMSController.sendSMS('9111231234','Hi!');
        RESTSMSController.sendSMSFuture('9111231234','Hi!');
        RESTSMSController.processSMS('www');
        RESTSMSController.postAuth();
        
        List<List<String>> ls1 = new List<List<String>>();
        List<String> ls2 = new List<String>();
        ls2.add('sendSMS');
        ls2.add('9111231234');
        ls2.add('Hi!');
        ls1.add(ls2);
        RESTSMSController.smsMethods(ls1);				
        
        Test.stopTest();        
    }
}