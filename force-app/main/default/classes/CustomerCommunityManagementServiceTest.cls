@isTest
public class CustomerCommunityManagementServiceTest {
    
    @testSetup
    private static void setup(){
            
        Account a = new Account(name = 'TEST ACCOUNT');
        
        INSERT a;
        
        Id memberRecordTypeId = RecordTypeHelper.GetRecordTypeId('Contact', 'Member');
        
        Contact c = new Contact(
            AccountId = a.id, 
            lastname = 'lastname', 
            email = 'valid@user.com', 
            RecordTypeId = memberRecordTypeId
        );
        
        INSERT c;

        System.debug([SELECT Id, Username, Email, IsPortalEnabled, contactId FROM User WHERE contactId = :c.id LIMIT 1]);
        
    }
    
    @isTest
    private static void sendValidDelete(){
        
        String email = 'valid@user.com';
        
        Test.startTest();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/CustomerCommunityUser/';
        req.addParameter('email', email);//only way to pass a param in a test class
        req.httpMethod = 'DELETE';
              
        RestContext.request = req;
        RestContext.response = res;
       
        CustomerCommunityManagementService.resetPasswordByEmailAddress();
        
        System.debug(res);
        
        Test.stopTest();
        
    }
    
    @isTest
    private static void sendInvalidDelete(){
        
        String email = 'invalid@user.com';
        
        Test.startTest();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/CustomerCommunityUser/';
        req.addParameter('email', email);//only way to pass a param in a test class
        req.httpMethod = 'DELETE';
              
        RestContext.request = req;
        RestContext.response = res;
       
        CustomerCommunityManagementService.resetPasswordByEmailAddress();
        
        System.debug(res);
        
        Test.stopTest();
        
    }
    
}