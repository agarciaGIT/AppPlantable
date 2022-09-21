@isTest
public class Plant_OnBoarding_test {

    
    // @ Creating new meal list
    public static OnBoarding__c createOnBoarding(String acctId){
        OnBoarding__c newOnb = new OnBoarding__c(
            Account__c = acctId
        );
        return newOnb;
    }
    
    public static OnBoarding__c createOnBoarding(String acctId, DateTime callDT){
        OnBoarding__c newOnb = new OnBoarding__c(
            Account__c = acctId,
            Call_Date_Time__c = callDT
        );
        return newOnb;
    }

    // @ Creating new meal listSurvey
    public static OnBoarding_Question__c createOnBoardingQuestion(integer questNum, String type){
        OnBoarding_Question__c newOnbQ = new OnBoarding_Question__c(
            Products__c = 'Reboot',
            Question__c = 'Question ' + questNum,
            Sort_Order__c = questNum,
            Type__c = type 
        );
        
        return newOnbQ;
    }

    // @ Creating new meal listSurvey
    public static OnBoarding_Question_Option__c createOnBoardingQuestionOption(String questId, integer optNum){
        OnBoarding_Question_Option__c newOnbQO = new OnBoarding_Question_Option__c(
            OnBoarding_Question__c = questId,
            Option_Text__c = 'Question Option ' + optNum,
            Sort_Order__c = optNum
        );
        
        return newOnbQO;
    }
    
    public static List<Plant_Learning_Item__c> createOnBoardingLearningItem(Integer numOfItems){
    
        List<Plant_Learning_Item__c> items = new List<Plant_Learning_Item__c>();
         for ( Integer i = 0 ; i < numOfItems; i++ ) {
             Plant_Learning_Item__c newItem = new Plant_Learning_Item__c(
                 Name = 'name' + String.ValueOf(i),
                 Plant_Title__c = 'title' + String.ValueOf(i),
                 Plant_Day_Number__c = i
             );
             items.add(newItem);
        }
        return items;
    }
    
    // @ Method 1    
    static testMethod void plant_GetOnBoardingLearningItems_Tests(){
    
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;    
    
        List<Plant_Learning_Item__c> items = createOnBoardingLearningItem(3);
        insert items;
        
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/onboarding/getlearningitems';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTOnboarding prestMeal=new Plant_RESTOnboarding();

        Plant_RESTOnboarding.postOnBoarding();
        
        
    }

    static testMethod void plant_SetOnBoardingLearningDay_Tests(){
    
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;    
    
        List<Plant_Learning_Item__c> items = createOnBoardingLearningItem(3);
        insert items;
        
        string jsonBody = '{ "accountId": "'+acct.Id+'", "day": 1 }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/onboarding/setlearningday';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTOnboarding prestMeal=new Plant_RESTOnboarding();

        Plant_RESTOnboarding.postOnBoarding();
        
        
    }
    
    // @ Method 1    
    static testMethod void plant_GetOnBoardingStatus_Tests(){
        
        // Create Onboard
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;
        
        OnBoarding__c onb = createOnBoarding(acct.Id);
        insert onb;
        
        //Plant_OnBoarding_SC.getOnBoardingStatus();
        
        string jsonBody = '{ "accountId": "'+acct.Id+'" }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/onboarding/GetStatus';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTOnboarding prestMeal=new Plant_RESTOnboarding();

        Plant_RESTOnboarding.postOnBoarding();
        
        Plant_OnBoarding_BC.getClassDetail();

    }

    // @ Method 1 Error 1
    static testMethod void plant_GetOnBoardingStatusE1_Tests(){
        
        // Create Onboard
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;
        
        //OnBoarding__c onb = createOnBoarding(acct.Id);
        //insert onb;
        
        //Plant_OnBoarding_SC.getOnBoardingStatus();
        
        string jsonBody = '{ "accountId": "'+acct.Id+'" }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/onboarding/GetStatus';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTOnboarding prestMeal=new Plant_RESTOnboarding();

        Plant_RESTOnboarding.postOnBoarding();
        
        Plant_OnBoarding_BC.getClassDetail();

    }

    // @ Method 1 Error 2
    static testMethod void plant_GetOnBoardingStatusE2_Tests(){
        
        // Create Onboard
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;
        
        OnBoarding__c onb = createOnBoarding(acct.Id);
        insert onb;
        
        //Plant_OnBoarding_SC.getOnBoardingStatus();
        
        string jsonBody = '{  }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/onboarding/GetStatus';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTOnboarding prestMeal=new Plant_RESTOnboarding();

        Plant_RESTOnboarding.postOnBoarding();
        
        Plant_OnBoarding_BC.getClassDetail();

    }
    
    // @ Method 2
    static testMethod void plant_SetOnBoardingStatus_Tests(){
        
        // Create Onboard
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;
        
        OnBoarding__c onb = createOnBoarding(acct.Id);
        insert onb;
        
        //Plant_OnBoarding_SC.getOnBoardingStatus();
        
        string jsonBody = '{ "onboardingId": "'+ onb.Id +'" ,"step": "Survey Completed" }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/onboarding/SetStatus';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTOnboarding prestMeal=new Plant_RESTOnboarding();

        Plant_RESTOnboarding.postOnBoarding();

    }
    
    // @ Method 2 Error 1
    static testMethod void plant_SetOnBoardingStatusE1_Tests(){
        
        // Create Onboard
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;
        
        OnBoarding__c onb = createOnBoarding(acct.Id);
        insert onb;
        
        //Plant_OnBoarding_SC.getOnBoardingStatus();
        
        string jsonBody = '{ "onboardingId": "'+ onb.Id +'" ,"step": "Survey Done" }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/onboarding/SetStatus';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTOnboarding prestMeal=new Plant_RESTOnboarding();

        Plant_RESTOnboarding.postOnBoarding();

    }    

    // @ Method 2 Error 2
    static testMethod void plant_SetOnBoardingStatusE2_Tests(){
        
        // Create Onboard
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;
        
        OnBoarding__c onb = createOnBoarding(acct.Id);
        insert onb;
        
        //Plant_OnBoarding_SC.getOnBoardingStatus();
        
        string jsonBody = '{ "onboardingId": "'+ acct.Id +'" ,"step": "Survey Done" }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/onboarding/SetStatus';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTOnboarding prestMeal=new Plant_RESTOnboarding();

        Plant_RESTOnboarding.postOnBoarding();

    }    

    // @ Method 2
    static testMethod void plant_GetOnBoardingCallDateTime_Tests(){
        
        // Create Onboard
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;
        
        DateTime dt = DateTime.Now();
        
        OnBoarding__c onb = createOnBoarding(acct.Id, dt);
        insert onb;
                
        OnBoarding__c onb1 = createOnBoarding(acct.Id, dt.addDays(1));
        insert onb1;


        string jsonBody = '{ "onboardingId": "'+ onb.Id +'" ,"callReqStartDate": "'+ dt.format('yyyy-MM-dd') +'", "callReqNumberDays": 7 }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/onboarding/GetOnBoardingCalls';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTOnboarding prestMeal=new Plant_RESTOnboarding();

        Plant_RESTOnboarding.postOnBoarding();

    }


    // @ Method 2
    static testMethod void plant_SetOnBoardingCallDateTime_Tests(){
        
        // Create Onboard
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;
        
        OnBoarding__c onb = createOnBoarding(acct.Id);
        insert onb;
        
        //Plant_OnBoarding_SC.getOnBoardingStatus();
        
        string jsonBody = '{ "onboardingId": "'+ onb.Id +'" ,"callDateTime": "2022-08-29T10:00:00Z" }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/onboarding/SetCallDateTime';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTOnboarding prestMeal=new Plant_RESTOnboarding();

        Plant_RESTOnboarding.postOnBoarding();

    }

    // @ Method 2
    // Time Already Taken
    static testMethod void plant_SetOnBoardingCallDateTimeE1_Tests(){
        
        // Create Onboard
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;
        
        DateTime dt = DateTime.NewInstance(2022,8,29,10,0,0);
        
        OnBoarding__c onb = createOnBoarding(acct.Id, dt);
        insert onb;
        
        String dts = dt.format('yyyy-MM-dd HH:mm:ss');
        System.debug('dt.format:' + dts);
        
        dts = dts.replace(' ','T');
        dts = dts + 'Z';
        
        string jsonBody = '{ "onboardingId": "'+ onb.Id +'" ,"callDateTime": "' + dts + '" }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/onboarding/SetCallDateTime';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTOnboarding prestMeal=new Plant_RESTOnboarding();

        Plant_RESTOnboarding.postOnBoarding();

    }

    // @ Method 2
    // Must be 9 - 5
    static testMethod void plant_SetOnBoardingCallDateTimeE2_Tests(){
        
        // Create Onboard
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;
        
        DateTime dt = DateTime.NewInstance(2022,8,28,3,0,0);
        
        OnBoarding__c onb = createOnBoarding(acct.Id, dt);
        insert onb;
        
        String dts = dt.format('yyyy-MM-dd HH:mm:ss');
        System.debug('dt.format:' + dts);
        
        dts = dts.replace(' ','T');
        dts = dts + 'Z';
        
        string jsonBody = '{ "onboardingId": "'+ onb.Id +'" ,"callDateTime": "' + dts + '" }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/onboarding/SetCallDateTime';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTOnboarding prestMeal=new Plant_RESTOnboarding();

        Plant_RESTOnboarding.postOnBoarding();

    }
    
    // @ Method 3 Error 1
    static testMethod void plant_SetOnBoardingQuestionsE1_Tests(){
        
        // Create Onboard
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;
        
        OnBoarding__c onb = createOnBoarding(acct.Id);
        insert onb;

        OnBoarding_Question__c onbq1 = createOnBoardingQuestion(1,'Multiple Choice - select one');
        insert onbq1;
        
        OnBoarding_Question_Option__c qo1 = createOnBoardingQuestionOption(onbq1.Id, 1);
        insert qo1;
        
        OnBoarding_Question__c onbq2 = createOnBoardingQuestion(2,'Multiple Choice - select many');
        insert onbq2;

        OnBoarding_Question_Option__c qo2 = createOnBoardingQuestionOption(onbq2.Id, 1);
        insert qo2;
        
        OnBoarding_Question_Option__c qo3 = createOnBoardingQuestionOption(onbq2.Id, 2);
        insert qo3;
        
        OnBoarding_Question__c onbq3 = createOnBoardingQuestion(3,'Date');
        insert onbq3;

        OnBoarding_Question__c onbq4 = createOnBoardingQuestion(4,'Short Text');
        insert onbq4;

        OnBoarding_Question__c onbq5 = createOnBoardingQuestion(5,'Long Text');
        insert onbq5;

        OnBoarding_Question__c onbq6 = createOnBoardingQuestion(6,'Scale 1 - 10');
        insert onbq6;
        
        OnBoarding_Question__c onbq7 = createOnBoardingQuestion(7,'Display Text');
        insert onbq7;
        
        string jsonBody = '{ "onboardingId": "'+ onb.Id +'" ,"questionId": "'+onbq1.Id+'" }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/onboarding/SetQuestion';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTOnboarding prestMeal=new Plant_RESTOnboarding();

        Plant_RESTOnboarding.postOnBoarding();

    }
    
    
    // @ Method 3A
    static testMethod void plant_SetOnBoardingQuestionsA_Tests(){
        
        // Create Onboard
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;
        
        OnBoarding__c onb = createOnBoarding(acct.Id);
        insert onb;

        OnBoarding_Question__c onbq1 = createOnBoardingQuestion(1,'Multiple Choice - select one');
        insert onbq1;
        
        OnBoarding_Question_Option__c qo1 = createOnBoardingQuestionOption(onbq1.Id, 1);
        insert qo1;
        
        OnBoarding_Question__c onbq2 = createOnBoardingQuestion(2,'Multiple Choice - select many');
        insert onbq2;

        OnBoarding_Question_Option__c qo2 = createOnBoardingQuestionOption(onbq2.Id, 1);
        insert qo2;
        
        OnBoarding_Question_Option__c qo3 = createOnBoardingQuestionOption(onbq2.Id, 2);
        insert qo3;
        
        OnBoarding_Question__c onbq3 = createOnBoardingQuestion(3,'Date');
        insert onbq3;

        OnBoarding_Question__c onbq4 = createOnBoardingQuestion(4,'Short Text');
        insert onbq4;

        OnBoarding_Question__c onbq5 = createOnBoardingQuestion(5,'Long Text');
        insert onbq5;

        OnBoarding_Question__c onbq6 = createOnBoardingQuestion(6,'Scale 1 - 10');
        insert onbq6;
        
        OnBoarding_Question__c onbq7 = createOnBoardingQuestion(7,'Display Text');
        insert onbq7;
        
        string jsonBody = '{ "onboardingId": "'+ onb.Id +'" ,"questionId": "'+onbq1.Id+'", "answerOptionIds": ["'+qo1.Id+'"] }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/onboarding/SetQuestion';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTOnboarding prestMeal=new Plant_RESTOnboarding();

        Plant_RESTOnboarding.postOnBoarding();

    }

    // @ Method 3A Error 0
    static testMethod void plant_SetOnBoardingQuestionsAE0_Tests(){
        
        // Create Onboard
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;
        
        OnBoarding__c onb = createOnBoarding(acct.Id);
        insert onb;

        OnBoarding_Question__c onbq1 = createOnBoardingQuestion(1,'Multiple Choice - select one');
        insert onbq1;
        
        //OnBoarding_Question_Option__c qo1 = createOnBoardingQuestionOption(onbq1.Id, 1);
        //insert qo1;
        
        OnBoarding_Question__c onbq2 = createOnBoardingQuestion(2,'Multiple Choice - select many');
        insert onbq2;

        OnBoarding_Question_Option__c qo2 = createOnBoardingQuestionOption(onbq2.Id, 1);
        insert qo2;
        
        OnBoarding_Question_Option__c qo3 = createOnBoardingQuestionOption(onbq2.Id, 2);
        insert qo3;
        
        OnBoarding_Question__c onbq3 = createOnBoardingQuestion(3,'Date');
        insert onbq3;

        OnBoarding_Question__c onbq4 = createOnBoardingQuestion(4,'Short Text');
        insert onbq4;

        OnBoarding_Question__c onbq5 = createOnBoardingQuestion(5,'Long Text');
        insert onbq5;

        OnBoarding_Question__c onbq6 = createOnBoardingQuestion(6,'Scale 1 - 10');
        insert onbq6;
        
        OnBoarding_Question__c onbq7 = createOnBoardingQuestion(7,'Display Text');
        insert onbq7;
        
        string jsonBody = '{ "onboardingId": "'+ onb.Id +'" ,"questionId": "'+onbq1.Id+'", "answerOptionIds": ["'+qo2.Id+'"] }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/onboarding/SetQuestion';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTOnboarding prestMeal=new Plant_RESTOnboarding();

        Plant_RESTOnboarding.postOnBoarding();

    }
    
    
    // @ Method 3A Error 1
    static testMethod void plant_SetOnBoardingQuestionsAE1_Tests(){
        
        // Create Onboard
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;
        
        OnBoarding__c onb = createOnBoarding(acct.Id);
        insert onb;

        OnBoarding_Question__c onbq1 = createOnBoardingQuestion(1,'Multiple Choice - select one');
        insert onbq1;
        
        OnBoarding_Question_Option__c qo1 = createOnBoardingQuestionOption(onbq1.Id, 1);
        insert qo1;
        
        OnBoarding_Question__c onbq2 = createOnBoardingQuestion(2,'Multiple Choice - select many');
        insert onbq2;

        OnBoarding_Question_Option__c qo2 = createOnBoardingQuestionOption(onbq2.Id, 1);
        insert qo2;
        
        OnBoarding_Question_Option__c qo3 = createOnBoardingQuestionOption(onbq2.Id, 2);
        insert qo3;
        
        OnBoarding_Question__c onbq3 = createOnBoardingQuestion(3,'Date');
        insert onbq3;

        OnBoarding_Question__c onbq4 = createOnBoardingQuestion(4,'Short Text');
        insert onbq4;

        OnBoarding_Question__c onbq5 = createOnBoardingQuestion(5,'Long Text');
        insert onbq5;

        OnBoarding_Question__c onbq6 = createOnBoardingQuestion(6,'Scale 1 - 10');
        insert onbq6;
        
        OnBoarding_Question__c onbq7 = createOnBoardingQuestion(7,'Display Text');
        insert onbq7;
        
        string jsonBody = '{ "onboardingId": "'+ onb.Id +'" ,"questionId": "'+onbq1.Id+'", "answerString": "hi" }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/onboarding/SetQuestion';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTOnboarding prestMeal=new Plant_RESTOnboarding();

        Plant_RESTOnboarding.postOnBoarding();

    }

    // @ Method 3A Error 2
    static testMethod void plant_SetOnBoardingQuestionsAE2_Tests(){
        
        // Create Onboard
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;
        
        OnBoarding__c onb = createOnBoarding(acct.Id);
        insert onb;

        OnBoarding_Question__c onbq1 = createOnBoardingQuestion(1,'Multiple Choice - select one');
        insert onbq1;
        
        OnBoarding_Question_Option__c qo1 = createOnBoardingQuestionOption(onbq1.Id, 1);
        insert qo1;
        
        OnBoarding_Question__c onbq2 = createOnBoardingQuestion(2,'Multiple Choice - select many');
        insert onbq2;

        OnBoarding_Question_Option__c qo2 = createOnBoardingQuestionOption(onbq2.Id, 1);
        insert qo2;
        
        OnBoarding_Question_Option__c qo3 = createOnBoardingQuestionOption(onbq2.Id, 2);
        insert qo3;
        
        OnBoarding_Question__c onbq3 = createOnBoardingQuestion(3,'Date');
        insert onbq3;

        OnBoarding_Question__c onbq4 = createOnBoardingQuestion(4,'Short Text');
        insert onbq4;

        OnBoarding_Question__c onbq5 = createOnBoardingQuestion(5,'Long Text');
        insert onbq5;

        OnBoarding_Question__c onbq6 = createOnBoardingQuestion(6,'Scale 1 - 10');
        insert onbq6;
        
        OnBoarding_Question__c onbq7 = createOnBoardingQuestion(7,'Display Text');
        insert onbq7;
        
        string jsonBody = '{ "onboardingId": "'+ onb.Id +'" ,"questionId": "'+onbq1.Id+'", "answerOptionIds": ["'+qo1.Id+'","'+qo2.Id+'"] }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/onboarding/SetQuestion';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTOnboarding prestMeal=new Plant_RESTOnboarding();

        Plant_RESTOnboarding.postOnBoarding();

    }

    // @ Method 3A Error 3
    static testMethod void plant_SetOnBoardingQuestionsAE3_Tests(){
        
        // Create Onboard
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;
        
        OnBoarding__c onb = createOnBoarding(acct.Id);
        insert onb;

        OnBoarding_Question__c onbq1 = createOnBoardingQuestion(1,'Multiple Choice - select one');
        insert onbq1;
        
        OnBoarding_Question_Option__c qo1 = createOnBoardingQuestionOption(onbq1.Id, 1);
        insert qo1;
        
        OnBoarding_Question__c onbq2 = createOnBoardingQuestion(2,'Multiple Choice - select many');
        insert onbq2;

        OnBoarding_Question_Option__c qo2 = createOnBoardingQuestionOption(onbq2.Id, 1);
        insert qo2;
        
        OnBoarding_Question_Option__c qo3 = createOnBoardingQuestionOption(onbq2.Id, 2);
        insert qo3;
        
        OnBoarding_Question__c onbq3 = createOnBoardingQuestion(3,'Date');
        insert onbq3;

        OnBoarding_Question__c onbq4 = createOnBoardingQuestion(4,'Short Text');
        insert onbq4;

        OnBoarding_Question__c onbq5 = createOnBoardingQuestion(5,'Long Text');
        insert onbq5;

        OnBoarding_Question__c onbq6 = createOnBoardingQuestion(6,'Scale 1 - 10');
        insert onbq6;
        
        OnBoarding_Question__c onbq7 = createOnBoardingQuestion(7,'Display Text');
        insert onbq7;
        
        string jsonBody = '{ "onboardingId": "'+ onb.Id +'" ,"questionId": "'+onbq1.Id+'", "answerOptionIds": ["'+qo2.Id+'"] }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/onboarding/SetQuestion';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTOnboarding prestMeal=new Plant_RESTOnboarding();

        Plant_RESTOnboarding.postOnBoarding();

    }

    // @ Method 3B
    static testMethod void plant_SetOnBoardingQuestionsB_Tests(){
        
        // Create Onboard
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;
        
        OnBoarding__c onb = createOnBoarding(acct.Id);
        insert onb;

        OnBoarding_Question__c onbq1 = createOnBoardingQuestion(1,'Multiple Choice - select one');
        insert onbq1;
        
        OnBoarding_Question_Option__c qo1 = createOnBoardingQuestionOption(onbq1.Id, 1);
        insert qo1;
        
        OnBoarding_Question__c onbq2 = createOnBoardingQuestion(2,'Multiple Choice - select many');
        insert onbq2;

        OnBoarding_Question_Option__c qo2 = createOnBoardingQuestionOption(onbq2.Id, 1);
        insert qo2;
        
        OnBoarding_Question_Option__c qo3 = createOnBoardingQuestionOption(onbq2.Id, 2);
        insert qo3;
        
        OnBoarding_Question__c onbq3 = createOnBoardingQuestion(3,'Date');
        insert onbq3;

        OnBoarding_Question__c onbq4 = createOnBoardingQuestion(4,'Short Text');
        insert onbq4;

        OnBoarding_Question__c onbq5 = createOnBoardingQuestion(5,'Long Text');
        insert onbq5;

        OnBoarding_Question__c onbq6 = createOnBoardingQuestion(6,'Scale 1 - 10');
        insert onbq6;
        
        OnBoarding_Question__c onbq7 = createOnBoardingQuestion(7,'Display Text');
        insert onbq7;
        
        string jsonBody = '{ "onboardingId": "'+ onb.Id +'" ,"questionId": "'+onbq2.Id+'", "answerOptionIds": ["'+qo2.Id+'"] }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/onboarding/SetQuestion';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTOnboarding prestMeal=new Plant_RESTOnboarding();

        Plant_RESTOnboarding.postOnBoarding();

    }


    // @ Method 3B Error 0
    static testMethod void plant_SetOnBoardingQuestionsBE0_Tests(){
        
        // Create Onboard
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;
        
        OnBoarding__c onb = createOnBoarding(acct.Id);
        insert onb;

        OnBoarding_Question__c onbq1 = createOnBoardingQuestion(1,'Multiple Choice - select one');
        insert onbq1;
        
        OnBoarding_Question_Option__c qo1 = createOnBoardingQuestionOption(onbq1.Id, 1);
        insert qo1;
        
        OnBoarding_Question__c onbq2 = createOnBoardingQuestion(2,'Multiple Choice - select many');
        insert onbq2;

        //OnBoarding_Question_Option__c qo2 = createOnBoardingQuestionOption(onbq2.Id, 1);
        //insert qo2;
        
        //OnBoarding_Question_Option__c qo3 = createOnBoardingQuestionOption(onbq2.Id, 2);
        //insert qo3;
        
        OnBoarding_Question__c onbq3 = createOnBoardingQuestion(3,'Date');
        insert onbq3;

        OnBoarding_Question__c onbq4 = createOnBoardingQuestion(4,'Short Text');
        insert onbq4;

        OnBoarding_Question__c onbq5 = createOnBoardingQuestion(5,'Long Text');
        insert onbq5;

        OnBoarding_Question__c onbq6 = createOnBoardingQuestion(6,'Scale 1 - 10');
        insert onbq6;
        
        OnBoarding_Question__c onbq7 = createOnBoardingQuestion(7,'Display Text');
        insert onbq7;
        
        string jsonBody = '{ "onboardingId": "'+ onb.Id +'" ,"questionId": "'+onbq2.Id+'", "answerString": "hi" }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/onboarding/SetQuestion';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTOnboarding prestMeal=new Plant_RESTOnboarding();

        Plant_RESTOnboarding.postOnBoarding();

    }
    
    // @ Method 3B Error 1
    static testMethod void plant_SetOnBoardingQuestionsBE1_Tests(){
        
        // Create Onboard
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;
        
        OnBoarding__c onb = createOnBoarding(acct.Id);
        insert onb;

        OnBoarding_Question__c onbq1 = createOnBoardingQuestion(1,'Multiple Choice - select one');
        insert onbq1;
        
        OnBoarding_Question_Option__c qo1 = createOnBoardingQuestionOption(onbq1.Id, 1);
        insert qo1;
        
        OnBoarding_Question__c onbq2 = createOnBoardingQuestion(2,'Multiple Choice - select many');
        insert onbq2;

        OnBoarding_Question_Option__c qo2 = createOnBoardingQuestionOption(onbq2.Id, 1);
        insert qo2;
        
        OnBoarding_Question_Option__c qo3 = createOnBoardingQuestionOption(onbq2.Id, 2);
        insert qo3;
        
        OnBoarding_Question__c onbq3 = createOnBoardingQuestion(3,'Date');
        insert onbq3;

        OnBoarding_Question__c onbq4 = createOnBoardingQuestion(4,'Short Text');
        insert onbq4;

        OnBoarding_Question__c onbq5 = createOnBoardingQuestion(5,'Long Text');
        insert onbq5;

        OnBoarding_Question__c onbq6 = createOnBoardingQuestion(6,'Scale 1 - 10');
        insert onbq6;
        
        OnBoarding_Question__c onbq7 = createOnBoardingQuestion(7,'Display Text');
        insert onbq7;
        
        string jsonBody = '{ "onboardingId": "'+ onb.Id +'" ,"questionId": "'+onbq2.Id+'", "answerString": "hi" }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/onboarding/SetQuestion';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTOnboarding prestMeal=new Plant_RESTOnboarding();

        Plant_RESTOnboarding.postOnBoarding();

    }
    
    // @ Method 3B Error 2
    static testMethod void plant_SetOnBoardingQuestionsBE2_Tests(){
        
        // Create Onboard
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;
        
        OnBoarding__c onb = createOnBoarding(acct.Id);
        insert onb;

        OnBoarding_Question__c onbq1 = createOnBoardingQuestion(1,'Multiple Choice - select one');
        insert onbq1;
        
        OnBoarding_Question_Option__c qo1 = createOnBoardingQuestionOption(onbq1.Id, 1);
        insert qo1;
        
        OnBoarding_Question__c onbq2 = createOnBoardingQuestion(2,'Multiple Choice - select many');
        insert onbq2;

        OnBoarding_Question_Option__c qo2 = createOnBoardingQuestionOption(onbq2.Id, 1);
        insert qo2;
        
        OnBoarding_Question_Option__c qo3 = createOnBoardingQuestionOption(onbq2.Id, 2);
        insert qo3;
        
        OnBoarding_Question__c onbq3 = createOnBoardingQuestion(3,'Date');
        insert onbq3;

        OnBoarding_Question__c onbq4 = createOnBoardingQuestion(4,'Short Text');
        insert onbq4;

        OnBoarding_Question__c onbq5 = createOnBoardingQuestion(5,'Long Text');
        insert onbq5;

        OnBoarding_Question__c onbq6 = createOnBoardingQuestion(6,'Scale 1 - 10');
        insert onbq6;
        
        OnBoarding_Question__c onbq7 = createOnBoardingQuestion(7,'Display Text');
        insert onbq7;
        
        string jsonBody = '{ "onboardingId": "'+ onb.Id +'" ,"questionId": "'+onbq2.Id+'", "answerOptionIds": ["'+qo1.Id+'"] }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/onboarding/SetQuestion';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTOnboarding prestMeal=new Plant_RESTOnboarding();

        Plant_RESTOnboarding.postOnBoarding();

    }
    
    // @ Method 3C
    static testMethod void plant_SetOnBoardingQuestionsC_Tests(){
        
        // Create Onboard
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;
        
        OnBoarding__c onb = createOnBoarding(acct.Id);
        insert onb;

        OnBoarding_Question__c onbq1 = createOnBoardingQuestion(1,'Multiple Choice - select one');
        insert onbq1;
        
        OnBoarding_Question_Option__c qo1 = createOnBoardingQuestionOption(onbq1.Id, 1);
        insert qo1;
        
        OnBoarding_Question__c onbq2 = createOnBoardingQuestion(2,'Multiple Choice - select many');
        insert onbq2;

        OnBoarding_Question_Option__c qo2 = createOnBoardingQuestionOption(onbq2.Id, 1);
        insert qo2;
        
        OnBoarding_Question_Option__c qo3 = createOnBoardingQuestionOption(onbq2.Id, 2);
        insert qo3;
        
        OnBoarding_Question__c onbq3 = createOnBoardingQuestion(3,'Date');
        insert onbq3;

        OnBoarding_Question__c onbq4 = createOnBoardingQuestion(4,'Short Text');
        insert onbq4;

        OnBoarding_Question__c onbq5 = createOnBoardingQuestion(5,'Long Text');
        insert onbq5;

        OnBoarding_Question__c onbq6 = createOnBoardingQuestion(6,'Scale 1 - 10');
        insert onbq6;
        
        OnBoarding_Question__c onbq7 = createOnBoardingQuestion(7,'Display Text');
        insert onbq7;
        
        string jsonBody = '{ "onboardingId": "'+ onb.Id +'" ,"questionId": "'+onbq3.Id+'", "answerDate": "2022-01-01" }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/onboarding/SetQuestion';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTOnboarding prestMeal=new Plant_RESTOnboarding();

        Plant_RESTOnboarding.postOnBoarding();

    }

    // @ Method 3C Error 1
    static testMethod void plant_SetOnBoardingQuestionsCE1_Tests(){
        
        // Create Onboard
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;
        
        OnBoarding__c onb = createOnBoarding(acct.Id);
        insert onb;

        OnBoarding_Question__c onbq1 = createOnBoardingQuestion(1,'Multiple Choice - select one');
        insert onbq1;
        
        OnBoarding_Question_Option__c qo1 = createOnBoardingQuestionOption(onbq1.Id, 1);
        insert qo1;
        
        OnBoarding_Question__c onbq2 = createOnBoardingQuestion(2,'Multiple Choice - select many');
        insert onbq2;

        OnBoarding_Question_Option__c qo2 = createOnBoardingQuestionOption(onbq2.Id, 1);
        insert qo2;
        
        OnBoarding_Question_Option__c qo3 = createOnBoardingQuestionOption(onbq2.Id, 2);
        insert qo3;
        
        OnBoarding_Question__c onbq3 = createOnBoardingQuestion(3,'Date');
        insert onbq3;

        OnBoarding_Question__c onbq4 = createOnBoardingQuestion(4,'Short Text');
        insert onbq4;

        OnBoarding_Question__c onbq5 = createOnBoardingQuestion(5,'Long Text');
        insert onbq5;

        OnBoarding_Question__c onbq6 = createOnBoardingQuestion(6,'Scale 1 - 10');
        insert onbq6;
        
        OnBoarding_Question__c onbq7 = createOnBoardingQuestion(7,'Display Text');
        insert onbq7;
        
        string jsonBody = '{ "onboardingId": "'+ onb.Id +'" ,"questionId": "'+onbq3.Id+'", "answerString": "2022-01-01" }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/onboarding/SetQuestion';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTOnboarding prestMeal=new Plant_RESTOnboarding();

        Plant_RESTOnboarding.postOnBoarding();

    }
    
    // @ Method 3D
    static testMethod void plant_SetOnBoardingQuestionsD_Tests(){
        
        // Create Onboard
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;
        
        OnBoarding__c onb = createOnBoarding(acct.Id);
        insert onb;

        OnBoarding_Question__c onbq1 = createOnBoardingQuestion(1,'Multiple Choice - select one');
        insert onbq1;
        
        OnBoarding_Question_Option__c qo1 = createOnBoardingQuestionOption(onbq1.Id, 1);
        insert qo1;
        
        OnBoarding_Question__c onbq2 = createOnBoardingQuestion(2,'Multiple Choice - select many');
        insert onbq2;

        OnBoarding_Question_Option__c qo2 = createOnBoardingQuestionOption(onbq2.Id, 1);
        insert qo2;
        
        OnBoarding_Question_Option__c qo3 = createOnBoardingQuestionOption(onbq2.Id, 2);
        insert qo3;
        
        OnBoarding_Question__c onbq3 = createOnBoardingQuestion(3,'Date');
        insert onbq3;

        OnBoarding_Question__c onbq4 = createOnBoardingQuestion(4,'Short Text');
        insert onbq4;

        OnBoarding_Question__c onbq5 = createOnBoardingQuestion(5,'Long Text');
        insert onbq5;

        OnBoarding_Question__c onbq6 = createOnBoardingQuestion(6,'Scale 1 - 10');
        insert onbq6;
        
        OnBoarding_Question__c onbq7 = createOnBoardingQuestion(7,'Display Text');
        insert onbq7;
        
        string jsonBody = '{ "onboardingId": "'+ onb.Id +'" ,"questionId": "'+onbq4.Id+'", "answerString": "Hello" }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/onboarding/SetQuestion';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTOnboarding prestMeal=new Plant_RESTOnboarding();

        Plant_RESTOnboarding.postOnBoarding();

    }

    // @ Method 3D Error 1
    static testMethod void plant_SetOnBoardingQuestionsDE1_Tests(){
        
        // Create Onboard
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;
        
        OnBoarding__c onb = createOnBoarding(acct.Id);
        insert onb;

        OnBoarding_Question__c onbq1 = createOnBoardingQuestion(1,'Multiple Choice - select one');
        insert onbq1;
        
        OnBoarding_Question_Option__c qo1 = createOnBoardingQuestionOption(onbq1.Id, 1);
        insert qo1;
        
        OnBoarding_Question__c onbq2 = createOnBoardingQuestion(2,'Multiple Choice - select many');
        insert onbq2;

        OnBoarding_Question_Option__c qo2 = createOnBoardingQuestionOption(onbq2.Id, 1);
        insert qo2;
        
        OnBoarding_Question_Option__c qo3 = createOnBoardingQuestionOption(onbq2.Id, 2);
        insert qo3;
        
        OnBoarding_Question__c onbq3 = createOnBoardingQuestion(3,'Date');
        insert onbq3;

        OnBoarding_Question__c onbq4 = createOnBoardingQuestion(4,'Short Text');
        insert onbq4;

        OnBoarding_Question__c onbq5 = createOnBoardingQuestion(5,'Long Text');
        insert onbq5;

        OnBoarding_Question__c onbq6 = createOnBoardingQuestion(6,'Scale 1 - 10');
        insert onbq6;
        
        OnBoarding_Question__c onbq7 = createOnBoardingQuestion(7,'Display Text');
        insert onbq7;
        
        string jsonBody = '{ "onboardingId": "'+ onb.Id +'" ,"questionId": "'+onbq4.Id+'", "answerDate": "2022-01-01" }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/onboarding/SetQuestion';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTOnboarding prestMeal=new Plant_RESTOnboarding();

        Plant_RESTOnboarding.postOnBoarding();

    }
    
    
    // @ Method 3E
    static testMethod void plant_SetOnBoardingQuestionsE_Tests(){
        
        // Create Onboard
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;
        
        OnBoarding__c onb = createOnBoarding(acct.Id);
        insert onb;

        OnBoarding_Question__c onbq1 = createOnBoardingQuestion(1,'Multiple Choice - select one');
        insert onbq1;
        
        OnBoarding_Question_Option__c qo1 = createOnBoardingQuestionOption(onbq1.Id, 1);
        insert qo1;
        
        OnBoarding_Question__c onbq2 = createOnBoardingQuestion(2,'Multiple Choice - select many');
        insert onbq2;

        OnBoarding_Question_Option__c qo2 = createOnBoardingQuestionOption(onbq2.Id, 1);
        insert qo2;
        
        OnBoarding_Question_Option__c qo3 = createOnBoardingQuestionOption(onbq2.Id, 2);
        insert qo3;
        
        OnBoarding_Question__c onbq3 = createOnBoardingQuestion(3,'Date');
        insert onbq3;

        OnBoarding_Question__c onbq4 = createOnBoardingQuestion(4,'Short Text');
        insert onbq4;

        OnBoarding_Question__c onbq5 = createOnBoardingQuestion(5,'Long Text');
        insert onbq5;

        OnBoarding_Question__c onbq6 = createOnBoardingQuestion(6,'Scale 1 - 10');
        insert onbq6;
        
        OnBoarding_Question__c onbq7 = createOnBoardingQuestion(7,'Display Text');
        insert onbq7;
        
        string jsonBody = '{ "onboardingId": "'+ onb.Id +'" ,"questionId": "'+onbq5.Id+'", "answerString": "Hello" }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/onboarding/SetQuestion';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTOnboarding prestMeal=new Plant_RESTOnboarding();

        Plant_RESTOnboarding.postOnBoarding();

    }
    
    // @ Method 3E Error 1
    static testMethod void plant_SetOnBoardingQuestionsEE1_Tests(){
        
        // Create Onboard
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;
        
        OnBoarding__c onb = createOnBoarding(acct.Id);
        insert onb;

        OnBoarding_Question__c onbq1 = createOnBoardingQuestion(1,'Multiple Choice - select one');
        insert onbq1;
        
        OnBoarding_Question_Option__c qo1 = createOnBoardingQuestionOption(onbq1.Id, 1);
        insert qo1;
        
        OnBoarding_Question__c onbq2 = createOnBoardingQuestion(2,'Multiple Choice - select many');
        insert onbq2;

        OnBoarding_Question_Option__c qo2 = createOnBoardingQuestionOption(onbq2.Id, 1);
        insert qo2;
        
        OnBoarding_Question_Option__c qo3 = createOnBoardingQuestionOption(onbq2.Id, 2);
        insert qo3;
        
        OnBoarding_Question__c onbq3 = createOnBoardingQuestion(3,'Date');
        insert onbq3;

        OnBoarding_Question__c onbq4 = createOnBoardingQuestion(4,'Short Text');
        insert onbq4;

        OnBoarding_Question__c onbq5 = createOnBoardingQuestion(5,'Long Text');
        insert onbq5;

        OnBoarding_Question__c onbq6 = createOnBoardingQuestion(6,'Scale 1 - 10');
        insert onbq6;
        
        OnBoarding_Question__c onbq7 = createOnBoardingQuestion(7,'Display Text');
        insert onbq7;
        
        string jsonBody = '{ "onboardingId": "'+ onb.Id +'" ,"questionId": "'+onbq5.Id+'", "answerDate": "2022-01-01" }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/onboarding/SetQuestion';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTOnboarding prestMeal=new Plant_RESTOnboarding();

        Plant_RESTOnboarding.postOnBoarding();

    }

    
    // @ Method 3F
    static testMethod void plant_SetOnBoardingQuestionsF_Tests(){
        
        // Create Onboard
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;
        
        OnBoarding__c onb = createOnBoarding(acct.Id);
        insert onb;

        OnBoarding_Question__c onbq1 = createOnBoardingQuestion(1,'Multiple Choice - select one');
        insert onbq1;
        
        OnBoarding_Question_Option__c qo1 = createOnBoardingQuestionOption(onbq1.Id, 1);
        insert qo1;
        
        OnBoarding_Question__c onbq2 = createOnBoardingQuestion(2,'Multiple Choice - select many');
        insert onbq2;

        OnBoarding_Question_Option__c qo2 = createOnBoardingQuestionOption(onbq2.Id, 1);
        insert qo2;
        
        OnBoarding_Question_Option__c qo3 = createOnBoardingQuestionOption(onbq2.Id, 2);
        insert qo3;
        
        OnBoarding_Question__c onbq3 = createOnBoardingQuestion(3,'Date');
        insert onbq3;

        OnBoarding_Question__c onbq4 = createOnBoardingQuestion(4,'Short Text');
        insert onbq4;

        OnBoarding_Question__c onbq5 = createOnBoardingQuestion(5,'Long Text');
        insert onbq5;

        OnBoarding_Question__c onbq6 = createOnBoardingQuestion(6,'Scale 1 - 10');
        insert onbq6;
        
        OnBoarding_Question__c onbq7 = createOnBoardingQuestion(7,'Display Text');
        insert onbq7;
        
        string jsonBody = '{ "onboardingId": "'+ onb.Id +'" ,"questionId": "'+onbq6.Id+'", "answerNumber": 5 }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/onboarding/SetQuestion';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTOnboarding prestMeal=new Plant_RESTOnboarding();

        Plant_RESTOnboarding.postOnBoarding();

    }
    
    // @ Method 3F Error 1
    static testMethod void plant_SetOnBoardingQuestionsFE1_Tests(){
        
        // Create Onboard
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;
        
        OnBoarding__c onb = createOnBoarding(acct.Id);
        insert onb;

        OnBoarding_Question__c onbq1 = createOnBoardingQuestion(1,'Multiple Choice - select one');
        insert onbq1;
        
        OnBoarding_Question_Option__c qo1 = createOnBoardingQuestionOption(onbq1.Id, 1);
        insert qo1;
        
        OnBoarding_Question__c onbq2 = createOnBoardingQuestion(2,'Multiple Choice - select many');
        insert onbq2;

        OnBoarding_Question_Option__c qo2 = createOnBoardingQuestionOption(onbq2.Id, 1);
        insert qo2;
        
        OnBoarding_Question_Option__c qo3 = createOnBoardingQuestionOption(onbq2.Id, 2);
        insert qo3;
        
        OnBoarding_Question__c onbq3 = createOnBoardingQuestion(3,'Date');
        insert onbq3;

        OnBoarding_Question__c onbq4 = createOnBoardingQuestion(4,'Short Text');
        insert onbq4;

        OnBoarding_Question__c onbq5 = createOnBoardingQuestion(5,'Long Text');
        insert onbq5;

        OnBoarding_Question__c onbq6 = createOnBoardingQuestion(6,'Scale 1 - 10');
        insert onbq6;
        
        OnBoarding_Question__c onbq7 = createOnBoardingQuestion(7,'Display Text');
        insert onbq7;
        
        string jsonBody = '{ "onboardingId": "'+ onb.Id +'" ,"questionId": "'+onbq6.Id+'", "answerDate": "2022-01-01" }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/onboarding/SetQuestion';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTOnboarding prestMeal=new Plant_RESTOnboarding();

        Plant_RESTOnboarding.postOnBoarding();

    }

    // @ Method 3G
    static testMethod void plant_SetOnBoardingQuestionsG_Tests(){
        
        // Create Onboard
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;
        
        OnBoarding__c onb = createOnBoarding(acct.Id);
        insert onb;

        OnBoarding_Question__c onbq1 = createOnBoardingQuestion(1,'Multiple Choice - select one');
        insert onbq1;
        
        OnBoarding_Question_Option__c qo1 = createOnBoardingQuestionOption(onbq1.Id, 1);
        insert qo1;
        
        OnBoarding_Question__c onbq2 = createOnBoardingQuestion(2,'Multiple Choice - select many');
        insert onbq2;

        OnBoarding_Question_Option__c qo2 = createOnBoardingQuestionOption(onbq2.Id, 1);
        insert qo2;
        
        OnBoarding_Question_Option__c qo3 = createOnBoardingQuestionOption(onbq2.Id, 2);
        insert qo3;
        
        OnBoarding_Question__c onbq3 = createOnBoardingQuestion(3,'Date');
        insert onbq3;

        OnBoarding_Question__c onbq4 = createOnBoardingQuestion(4,'Short Text');
        insert onbq4;

        OnBoarding_Question__c onbq5 = createOnBoardingQuestion(5,'Long Text');
        insert onbq5;

        OnBoarding_Question__c onbq6 = createOnBoardingQuestion(6,'Scale 1 - 10');
        insert onbq6;
        
        OnBoarding_Question__c onbq7 = createOnBoardingQuestion(7,'Display Text');
        insert onbq7;
        
        string jsonBody = '{ "onboardingId": "'+ onb.Id +'" ,"questionId": "'+onbq7.Id+'", "answerString": 5 }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/onboarding/SetQuestion';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTOnboarding prestMeal=new Plant_RESTOnboarding();

        Plant_RESTOnboarding.postOnBoarding();

    }

}