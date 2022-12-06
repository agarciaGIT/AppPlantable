@isTest
public class manualEventRegistration_Test {
    static Account acc;
    static Opportunity opp;
    static Contract contract;
    static Event_Registration__c er;
    static Event__c ev ;
    static Product2 indv;
    static Product2 misc;
    static Event_Rate__c eventRate ;
    
    
    private static testmethod void setupData (){

        updateids__c uids = new updateids__c(Name = 'User', Record_id__c = userinfo.getuserId());
        insert uids;
        
        ChargentBase__Gateway__c chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        Acc = new Account(Name = 'test');
        insert acc;
        
        opp = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = acc.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()- 10);        
        insert opp;
        
        Event__c event = new Event__c();
        event.Status__c = 'Draft';
        event.Name = 'TEST EVENT NAME'; 
        event.Title__c = 'TEST EVENT TITLE';
        INSERT event;  
        
        Event_Rate__c evtR = new Event_Rate__c(Name ='Erly', Event__c=event.id);
        insert evtR; 
        
        er = new Event_Registration__c(Opportunity__c = opp.id, Status__c = 'Registered', Event__c = event.Id);
        insert er;
        
        Form__c form = new Form__c();
        form.Name = 'test-event-form';
        form.Form_Name__c = 'test-event-form';
        INSERT form;
        
        Content__c content = new Content__c();
        content.Name = 'test content';
        content.Form__c = form.Id;
        INSERT content;
        
        ev = new Event__c(Content__c = content.Id,Status__c = 'Draft', Name='2015 Convention', Title__c='2015 Convention', GL_Code__c='4060', Product_Code__c='CNY13', Start_Date__c = system.today() + 15, Grace_Period__c = 5, Event_Cancellation_Days__c = 3);
        insert ev;
        
        
        Event_Rate__c evtR1 = new Event_Rate__c(Name ='Erly', Event__c=ev.id);
        insert evtR1; 
        ev.Status__c = 'Active';
        update ev;
        
        indv = new Product2(Name ='Individual Membership', ProductCode ='MEMI', GL_Code__c = '4040', Company__c = 'GARP');
        insert indv;
        
        misc = new Product2(Name= 'Miscellaneous', ProductCode = 'MISC', GL_Code__c = '4999', Company__c = 'GARP');
        insert misc;
        
        eventRate = new Event_Rate__c(Name = 'Standard', Member_Rate__c = 1599, Non_Member_Rate__c = 1899, event__c = ev.id, Start_Date__c = date.today().adddays(-1), End_Date__c = date.today().addDays(2));
        insert eventRate;
        
    }
    private static testmethod void evRegistrationTest (){
        setupData ();
        test.startTest();
        manualEventRegistration evReg = new manualEventRegistration ();                
        evReg.eventObject.Event__c = ev.Id;
        evReg.firstName = 'test name';
        evReg.lastName = 'test';
        evReg.email = 'test@test.com';
        evReg.nickname = 'Test Sample';
        evReg.ccemail = 'test@test.com';
        evReg.action = 'sample action';
        evReg.actionId = 'sample action Id';
        evReg.manualEventRegistration();
        
        test.stopTest();
        
    }
    
    private static testmethod void evRegistrationTest2 (){
        setupData ();
        test.startTest();
        
        manualEventRegistration evRegmem = new manualEventRegistration ();
        evRegmem.eventObject.Event__c = ev.Id;
        evRegmem.firstName = 'test name';
        evRegmem.lastName = 'test';
        evRegmem.email = 'test@test.com';
        evRegmem.nickname = 'Test Sample';
        evRegmem.ccemail = 'test@test.com';
        evRegmem.action = 'sample action';
        evRegmem.actionId = 'sample action Id';
        evRegmem.membership = true;
        evRegmem.manualEventRegistration();
        test.stopTest();
        
    }
    
    private static testmethod void evRegistrationTest3 (){
        setupData ();
        test.startTest();
        
        manualEventRegistration evRegDisc = new manualEventRegistration ();
        evRegDisc.eventObject.Event__c = ev.Id;
        evRegDisc.firstName = 'test name';
        evRegDisc.lastName = 'test';
        evRegDisc.email = 'test@test.com';
        evRegDisc.nickname = 'Test Sample';
        evRegDisc.ccemail = 'test@test.com';
        evRegDisc.action = 'sample action';
        evRegDisc.actionId = 'sample action Id';
        evRegDisc.discount = '20';
        evRegDisc.description ='Team discount';
        evRegDisc.manualEventRegistration();
        test.stopTest();
        
    }

}