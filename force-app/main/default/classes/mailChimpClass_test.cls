@isTest 
public class mailChimpClass_test {
    
    Static Account account;
	Static Contact cont;
    Static EmailTemplate et;
    
     public static void setup(){
         
         et = new EmailTemplate(DeveloperName='bobxx', Body='Hi', Subject='Hi', Name='Bob', FolderId=UserInfo.getUserId(), TemplateType='custom');
         insert et;

         account = new Account(Name='Account', Batch_Last_KPI__c=null);
         insert account;
         
         cont = new Contact(Email='coach@euphebe.com', AccountId=account.Id, LastName = 'last');
         insert cont;
         

     }

    
    @isTest
    private static void testMethods(){
        
        System.runAs(new User(Id = UserInfo.getUserId())){
        setup();
        Test.startTest();   
        
        mailChimpClass.addContactToCampaign('1111', 'test@test.com', 'firstName', 'lastName');
        mailChimpClass.addContactToCampaignStep('1111','aaaa', 'test@test.com');
        mailChimpClass.getMailChimpLists();
        
        //EmailTemplate et =  new EmailTemplate(Name='test',Subject='test',Body='test');
        //insert et;
        mailChimpClass.sendSalesforceEmail('test', account.Id, 'test@test.com', null);
        
        List<String> params = new List<String>();
        params.add('addContactToCampaign');
        params.add('1111');
        params.add('test@test.com');
        params.add('firstName');
        params.add('lastName');
        List<List<String>> inputParams = new List<List<String>>();
        inputParams.add(params);
        
        mailChimpClass.campaignFlow(inputParams);


        List<String> params1 = new List<String>();
        params1.add('setAccountSurveyLinks');
        params1.add(account.Id);
        List<List<String>> inputParams1 = new List<List<String>>();
        inputParams1.add(params1);
        
        mailChimpClass.campaignFlow(inputParams1);
        


        List<String> params2 = new List<String>();
        params2.add('sendSMS');
        params2.add(account.Id);
        params2.add('coach@euphebe.com');
        List<List<String>> inputParams2 = new List<List<String>>();
        inputParams2.add(params2);
        
        mailChimpClass.campaignFlow(inputParams2);

    	mailChimpClass.sendBiltyAuthRequest();
        mailChimpClass.sendBiltyRequest('https://plantable.com', '123');
        mailChimpClass.getBiltyURL('https://plantable.com', '123');
        
        
            //mailChimpClass.sendEmail(et.id, account.Id, 'a@a.com', account.Id, '123');
            //mailChimpClass.sendCampaignComm(et.id, account.Id, 'a@a.com', account.Id, '123');
            //mailChimpClass.setAccountSurveyLinksBatch(account.Id);
        Test.stopTest();
        }        
    }
    }