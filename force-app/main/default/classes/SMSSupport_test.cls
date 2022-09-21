@isTest 
public class SMSSupport_test {
    
    Static Account acct;
    Static Contact cont;
    Static SMS_Message__c smsmsg;
    Static Case c;
    
    public static void setup(){
                
        acct = new Account(Name='Account', Batch_Last_KPI__c=null, BillingStreet='25 Jackson\n\rApt 1C');
        insert acct;
        
        cont = new Contact(Email='a@a.com', AccountId=acct.Id, LastName = 'last');
        insert cont;

      	smsmsg = new SMS_Message__c(Enable_Automation__c = True);
        insert smsmsg;
        
       	c = new Case(Subject='Case',Last_SMS_Received_Date_Time__c=DateTime.now(),Contact=cont);
        insert c;
        
    }
    
    
    
    @isTest
    private static void testClasses(){
        
        setup();
        Test.startTest();    
                        
        SMSSupportAppController smsobj = new SMSSupportAppController();
        
        SMSSupportAppController.initClass();
            
        String smsobjS = JSON.serialize(smsobj);
        SMSSupportAppController.closeCase(smsobjS);
        SMSSupportAppController.refreshCaseData(smsobjS);
        SMSSupportAppController.smsLogin('123',smsobjS);
        SMSSupportAppController.selectCase(c.Id,smsobjS);
        SMSSupportAppController.checkForNewMSG(smsobjS);
        SMSSupportAppController.sendSMS('hi',smsobjS);
       
        SMSSupportAppController.findContact(smsobjS, 'AG');
        SMSSupportAppController.selectContact(cont.Id, smsobjS);
        
        
        List<SMS_Message__c> msgs = new List<SMS_Message__c>();
        SMSSupportAppController.publishNewSMSNotifications(msgs);
        
            
        //RESTSMSController.sendSMS('hi',smsobj.toString());
        //RESTSMSController.sendSMSFuture('9175867035', 'hi');
        
        RESTSMSController.processSMS(smsmsg.Id);
        
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();

        RestContext.request = request;
        RestContext.response = response;        
        
        RESTSMSController.postAuth();
        
        List<String> params1 = new List<String>();
        params1.add('sendSMS');
        params1.add('9175867035');
        params1.add('hi');
        List<List<String>> inputParams1 = new List<List<String>>();
        inputParams1.add(params1);
        
        RESTSMSController.smsMethods(inputParams1);

        params1 = new List<String>();
        params1.add('sendSMSFuture');
        params1.add('9175867035');
        params1.add('hi');
        inputParams1 = new List<List<String>>();
        
        inputParams1.add(params1);
        
        RESTSMSController.smsMethods(inputParams1);
        
        Test.stopTest();        
    }
    
}