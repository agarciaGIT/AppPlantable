@isTest 
public class Plant_Cases_test {

    static Case case1;
    
    public static void setup(){
        
        Account a = new Account(Name='Acct');
        insert a;
        
        Contact c = new Contact(FirstName='name', LastName='last', email='email@gmail.com', AccountId=a.Id);
        insert c;
        
        case1 = new Case(Subject='Case1', Description='body', ContactId=c.Id, AccountId=a.Id);
        insert case1;
        case1 = [select id, casenumber from Case where id = : case1.id];
        
        CaseComment cc = new CaseComment(CommentBody='Body', ParentId=case1.id, IsPublished = True);
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
        
        request.requestUri =URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/order/cases?authenticationToken=123';
        system.debug('case1:' + case1);
        request.addParameter('authenticationToken', '123');
        request.httpMethod = 'GET';
		//request.requestBody = Blob.valueof(jsonReq);
        
        RestContext.request = request;
        RestContext.response = response;
        Plant_RESTCases.getCases();
        
        request.requestUri =URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/order/cases?authenticationToken=123&casenum='+case1.CaseNumber;
        system.debug('case1:' + case1);
        request.addParameter('authenticationToken', '123');
        request.addParameter('casenum', case1.CaseNumber);
        request.httpMethod = 'GET';        
        RestContext.request = request;
        RestContext.response = response;
        Plant_RESTCases.getCases();
        
        request.httpMethod = 'PUT';
        String jsonReq = '{"authenticationToken":"123","case_number":"'+ case1.CaseNumber +'","case_status":"Blocked","comment" : {"body" : "Comment1"},"email" : {"subject" : "Subject1","body" : "body1","fromAddress" : "from@gmail.com","toAddress" : "cust@gmail.com"}} ';
        request.requestBody = Blob.valueof(jsonReq);
        RestContext.request = request;
        RestContext.response = response;
        Plant_RESTCases.updateCases();

        
        request.httpMethod = 'POST';
        jsonReq = '{"authenticationToken":"123","email_address": "jsmith@gmail.com","subject": "How do I?","body": "I need help"}';
        request.requestBody = Blob.valueof(jsonReq);
        RestContext.request = request;
        RestContext.response = response;        
        Plant_RESTCases.setCases();
        
        Test.stopTest();        
    }
    
    @isTest
    private static void test2(){
        setup();
        Test.startTest();    
                        
		RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        

        request.requestUri =URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/order/cases?authenticationToken=123&casenum='+case1.CaseNumber;
        system.debug('case1:' + case1);
        request.addParameter('authenticationToken', '123');
        request.addParameter('casenum', '123');
        request.httpMethod = 'GET';        
        RestContext.request = request;
        RestContext.response = response;
        Plant_RESTCases.getCases();

        request.httpMethod = 'PUT';
        String jsonReq = '{"authenticationToken":"123","case_number":"123","case_status":"Blocked","comment" : {"body" : "Comment1"},"email" : {"subject" : "Subject1","body" : "body1","fromAddress" : "from@gmail.com","toAddress" : "cust@gmail.com"}} ';
        request.requestBody = Blob.valueof(jsonReq);
        RestContext.request = request;
        RestContext.response = response;
        Plant_RESTCases.updateCases();
        
        request.httpMethod = 'PUT';
        jsonReq = '{"authenticationToken":"123","case_status":"Blocked","comment" : {"body" : "Comment1"},"email" : {"subject" : "Subject1","body" : "body1","fromAddress" : "from@gmail.com","toAddress" : "cust@gmail.com"}} ';
        request.requestBody = Blob.valueof(jsonReq);
        RestContext.request = request;
        RestContext.response = response;
        Plant_RESTCases.updateCases();
        
		request.httpMethod = 'POST';
        jsonReq = '{"authenticationToken":"123","body": "I need help"}';
        request.requestBody = Blob.valueof(jsonReq);
        RestContext.request = request;
        RestContext.response = response;        
        Plant_RESTCases.setCases();

        
        Test.stopTest();        
    }
}