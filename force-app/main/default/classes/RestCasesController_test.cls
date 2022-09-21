@isTest 
public class RestCasesController_test {
    
    static Case case1;
    
    public static void setup(){
        
        Account a = new Account(Name='Acct');
        insert a;
        
        Contact c = new Contact(FirstName='name', LastName='last', email='email@gmail.com', AccountId=a.Id);
        insert c;
        
        case1 = new Case(Subject='Case1', Description='body', ContactId=c.Id, AccountId=a.Id);
        insert case1;
        case1 = [select id, casenumber from Case where id = : case1.id];
        
        CaseComment cc = new CaseComment(CommentBody='Body', ParentId=case1.id);
        insert cc;
        
        EmailMessage em = new EmailMessage(Subject='Subject', TextBody='Body', FromAddress='from@gmail.com', ToAddress='to@gmail.com', ParentId=case1.id);
        insert em;
    }
    
    @isTest
    private static void test1(){
        setup();
        Test.startTest();    
                        
		RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        request.requestUri ='https://parcopy-euphebe.cs95.force.com/services/apexrest/cases/' + case1.CaseNumber;
        system.debug('case1:' + case1);
        request.httpMethod = 'GET';
		//request.requestBody = Blob.valueof(jsonReq);
        
        RestContext.request = request;
        RestContext.response = response;
        RESTCasesController.getCases();
        
        
        request.httpMethod = 'PUT';
        String jsonReq = '{"case_status":"Blocked","comment" : {"body" : "Comment1"},"email" : {"subject" : "Subject1","body" : "body1","fromAddress" : "from@gmail.com","toAddress" : "cust@gmail.com"}} ';
        request.requestBody = Blob.valueof(jsonReq);
        RESTCasesController.updateCases();

        request.httpMethod = 'POST';
        jsonReq = '{"email_address": "jsmith@gmail.com","subject": "How do I?","body": "I need help"}';
        request.requestBody = Blob.valueof(jsonReq);
        RESTCasesController.setCases();

        
        Test.stopTest();        
    }
    
}