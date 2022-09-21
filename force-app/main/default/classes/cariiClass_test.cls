@isTest 
public class cariiClass_test {
    
    Static API_Request__c ar;
    Static Account acct;
    Static Contact cont;
    Static Opportunity opp1;
    Static Shipment__c ship;

    public static void setup(){
        acct = new Account(Name='Account', Batch_Last_KPI__c=null, BillingStreet='25 Jackson\n\rApt 1C');
        insert acct;
        
        cont = new Contact(Email='a@a.com', AccountId=acct.Id, LastName = 'last');
        insert cont;
        
        opp1 = new Opportunity(Name='Opp1', CloseDate=Date.newInstance(2016, 1, 1), StageName='Closed Won', Amount=100, AccountId=acct.Id);
        insert opp1;
     
        ar = new API_Request__c(Batch__c = true);
        insert ar;
        
        ship = new Shipment__c(Name='Ship', Delivery_Date__c=Date.newInstance(2018, 8, 1),Scheduled_Date__c=Date.newInstance(2018, 8, 1), Type__c = 'OnFleet', Status__c = 'Pending', Opportunity__c=opp1.Id);
        insert ship;
        
    }
    
    @isTest
    private static void testMethods1(){
        setup();
        Test.startTest();    

        cariiClass.registerCarii();
        cariiClass.callCarii('https://app.euphebe.com/api/register','{}','123');
                        
        cariiClass.sendCarriOrder(ar.Id,opp1.Id);
        
		List<String> params = new List<String>();
        params.add('sendCarriOrder');
        params.add(ar.Id);
        params.add(opp1.Id);
        List<List<String>> inputParams = new List<List<String>>();
        inputParams.add(params);        
        cariiClass.cariiMethods(inputParams);
        
        cariiClass.loadSurvey('01/01/2018','Survey',null);
        cariiClass.loadSurvey('01/01/2018','Finisher',null);
        cariiClass.loadTracking('01/01/2018',null);
        cariiClass.loadChat('01/01/2018',null);
        
		String CRON_EXP = '0 0 0 15 6 ? 2050';
        
        scheduleLoadCariiSurvey sched= new scheduleLoadCariiSurvey();
        string jobId = system.schedule('batchUpdateShipmentStatusTEST1',CRON_EXP,sched);        

        scheduleLoadCariiFinisher sched1 = new scheduleLoadCariiFinisher();
        jobId = system.schedule('batchUpdateShipmentStatusTEST2',CRON_EXP,sched1);        

        scheduleLoadCariiTracking sched2 = new scheduleLoadCariiTracking();
        jobId = system.schedule('batchUpdateShipmentStatusTEST3',CRON_EXP,sched2);        

        scheduleLoadCariiChat sched3 = new scheduleLoadCariiChat();
        jobId = system.schedule('batchUpdateShipmentStatusTEST4',CRON_EXP,sched3);        
        
        Test.stopTest();        

    }        
}