global class batchUpdateCampaignSteps implements Database.Batchable<sObject>, Database.AllowsCallouts{
     
    public String mode;  
    
    global batchUpdateCampaignSteps(String inMode){
        mode = inMode;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){  
        
        if(mode == 'maint') {
            return Database.getQueryLocator('select Id, Account__c, Euphebe_Campaign__c, Start_Date__c, Start_Step__c, Current_Step__c, Stop_Step__c, Last_Step_Date__c, Stop_Date__c, Recipient_Email_Address__c, Status__c, Euphebe_Campaign__r.Is_Coaching_Related__c, Euphebe_Campaign__r.Is_Shipment_Related__c, Euphebe_Campaign__r.Is_Survey_Related__c, Euphebe_Campaign__r.Is_Marketing_Email__c  from Campaign_Account__c Where Status__c != \'Paused\' AND Status__c != \'Cancelled\' AND Status__c != \'Completed\' AND Euphebe_Campaign__r.Status__c != \'Active\' AND Euphebe_Campaign__r.Type__c = \'Daily Drip\'');                                    
        } if(mode != NULL) {
            return Database.getQueryLocator('select Id, Account__c, Euphebe_Campaign__c, Start_Date__c, Start_Step__c, Current_Step__c, Stop_Step__c, Last_Step_Date__c, Stop_Date__c, Recipient_Email_Address__c, Status__c, Euphebe_Campaign__r.Is_Coaching_Related__c, Euphebe_Campaign__r.Is_Shipment_Related__c, Euphebe_Campaign__r.Is_Survey_Related__c, Euphebe_Campaign__r.Is_Marketing_Email__c  from Campaign_Account__c Where Status__c != \'Paused\' AND Status__c != \'Cancelled\' AND Status__c != \'Completed\' AND Euphebe_Campaign__r.Status__c = \'Active\' AND Euphebe_Campaign__r.Type__c = \'Daily Drip\' AND ID = :mode');                        
        } else {
            return Database.getQueryLocator('select Id, Account__c, Euphebe_Campaign__c, Start_Date__c, Start_Step__c, Current_Step__c, Stop_Step__c, Last_Step_Date__c, Stop_Date__c, Recipient_Email_Address__c, Status__c, Euphebe_Campaign__r.Is_Coaching_Related__c, Euphebe_Campaign__r.Is_Shipment_Related__c, Euphebe_Campaign__r.Is_Survey_Related__c, Euphebe_Campaign__r.Is_Marketing_Email__c  from Campaign_Account__c Where Status__c != \'Paused\' AND Status__c != \'Cancelled\' AND Status__c != \'Completed\' AND Euphebe_Campaign__r.Status__c = \'Active\' AND Euphebe_Campaign__r.Type__c = \'Daily Drip\'');            
        }
    }    
    
    global void execute(Database.BatchableContext BC, List<Campaign_Account__c> scope){
        
        Set<ID> campIds = new Set<ID>();
        Set<ID> acctIds = new Set<ID>();
        List<SMS_Message__c> addMsgs = new List<SMS_Message__c>();
        List<In_App_Message__c> addInAppMsgs = new List<In_App_Message__c>();
        mailChimpClass.sendSMSReturn ssr;
        
        for(Campaign_Account__c ca : scope) {
            campIds.add(ca.Euphebe_Campaign__c);
            acctIds.add(ca.Account__c);
        }
        system.debug('campIds:' + campIds);
        system.debug('acctIds:' + campIds);
        
        List<Contact> lstCont = [select Id, AccountID, HasOptedOutOfEmail, Email_Opt_Out_Coaching__c, Email_Opt_Out_Shipment__c, Email_Opt_Out_Survey__c from Contact where AccountID in :acctIds];
        system.debug('lstCont:' + lstCont);
        
        MAP<String,Contact> mapContact = new MAP<String,Contact>();
        for(Contact c :lstCont) {
            mapContact.put(c.AccountID, c);
        }
        system.debug('mapContact:' + mapContact);
        
        List<Campaign_Step__c> steps = [select Id, SFDC_Email_Template__c, SMS_Template__c, Step__c, Send_Hour__c, Euphebe_Campaign__c, Days_Wait__c from Campaign_Step__c where Euphebe_Campaign__c in :campIds];
        system.debug('steps:' + steps);
        
        MAP<String,Campaign_Step__c> mapStep = new MAP<String,Campaign_Step__c>();
        for(Campaign_Step__c step : steps) {
            String key = step.Euphebe_Campaign__c + '~' + step.Step__c;
            mapStep.put(key, step);
        }
        system.debug('mapStep:' + mapStep);
        
        //system.assert(false, 'BOOM!setOrderNew:'+ mapStep);
             
        Date tdy = Date.today();
        DateTime now = system.now();
        system.debug('now hour:' + now.hour());
        
        List<Campaign_Account__c> updateCA = new List<Campaign_Account__c>();
        for(Campaign_Account__c ca :scope) {
            
            system.debug('ca:' + ca);
            Contact ct = mapContact.get(ca.Account__c);
            
            // Check Opt Outs
            if(ct != NULL) {
                if(
                    (ca.Euphebe_Campaign__r.Is_Coaching_Related__c && ct.Email_Opt_Out_Coaching__c) ||
                    (ca.Euphebe_Campaign__r.Is_Shipment_Related__c && ct.Email_Opt_Out_Shipment__c) ||
                    (ca.Euphebe_Campaign__r.Is_Survey_Related__c && ct.Email_Opt_Out_Survey__c) ||
                    (ca.Euphebe_Campaign__r.Is_Marketing_Email__c && ct.HasOptedOutOfEmail)
                  ) {
                      system.debug('Skip:' + ct);
                    continue;
                }
            }
            
            
            if(ca.Stop_Date__c == NULL || tdy <= ca.Stop_Date__c) {
                
                Decimal nextStep=0;
                if(ca.Start_Date__c == NULL || tdy >= ca.Start_Date__c) {
                    if(ca.Current_Step__c == NULL && ca.Start_Step__c == NULL)
                        nextStep=1;                
                    else if(ca.Current_Step__c == NULL && ca.Start_Step__c != NULL)
                        nextStep=ca.Start_Step__c;
                    else if(ca.Stop_Step__c == NULL || ca.Current_Step__c < ca.Stop_Step__c)
                        nextStep = ca.Current_Step__c + 1;
                } 
                system.debug('nextStep:' + nextStep);
                
                if(nextStep > 0) {
                    
                    String key = ca.Euphebe_Campaign__c + '~' + integer.valueOf(nextStep);
                    system.debug('key:' + key);
                    
                    Campaign_Step__c fndStep = mapStep.get(key);
                    system.debug('fndStep:' + fndStep);
                    
                    if(fndStep == NULL) {
                        system.debug('Set Completed.');
                        ca.Status__c = 'Completed';
                        updateCA.add(ca);
                    } else if(mode != 'maint' && (Test.isRunningTest() || fndStep.Send_Hour__c == now.hour())) {
                        
                        system.debug('Yes time to send');
                        
                        // Has Days Wait??
                        if(fndStep.Days_Wait__c != null && ca.Last_Step_Date__c != null) {
                                                
                            Date nextDate = ca.Last_Step_Date__c;
                            nextDate = nextDate + Integer.valueOf(fndStep.Days_Wait__c);
                            
                            system.debug('nextDate:' + nextDate);
                            
                            //fndStep.Days_Wait__c
                            if(tdy >= nextDate) {
                                ca.Current_Step__c = nextStep;
                                ca.Last_Step_Date__c = tdy;
                                system.debug('updateStep:' + ca);
                                
                                if(fndStep.SMS_Template__c != NULL) {
                                    ssr = mailChimpClass.sendSMS(fndStep.SMS_Template__c, ca.Id, ca.Recipient_Email_Address__c);
                                    system.debug('ssr:' + ssr);
                                    
                                    if(ssr.message != NULL) {
                                        ca.Last_Message__c = ssr.message;
                                        if(ssr.SMSSent) {                                            
                                            SMS_Message__c msg = new SMS_Message__c(Name='New Msg',Contact__c=ct.Id,Message__c=ssr.message,Enable_Automation__c=False);
                                            addMsgs.add(msg);
                                        }
                                    }
                                }                            
                                updateCA.add(ca);
                            }
                        } else {
                            ca.Current_Step__c = nextStep;
                            ca.Last_Step_Date__c = tdy;
                            system.debug('updateStep:' + ca);
                            
                            if(fndStep.SMS_Template__c != NULL) {
                                ssr = mailChimpClass.sendSMS(fndStep.SMS_Template__c, ca.Id, ca.Recipient_Email_Address__c);
                                system.debug('ssr:' + ssr);
                                
                                if(ssr.message != NULL) {
                                    ca.Last_Message__c = ssr.message;           
                                    if(ssr.SMSSent) { 
                                        SMS_Message__c msg = new SMS_Message__c(Name='New Msg',Contact__c=ct.Id,Message__c=ssr.message,Enable_Automation__c=False);
                                        addMsgs.add(msg);
                                    }
                                }
                            }                            
                            updateCA.add(ca);
                        }
                    }
                }
            }
        }
        update updateCA;
        
        System.debug('addMsgs:' + addMsgs);
        insert addMsgs;
        
        System.Debug('addInAppMsgs:' + addInAppMsgs);
        insert addInAppMsgs;
        
        if(ssr != NULL && ssr.lstAddAPIReq != NULL) {
            System.Debug('ssr.lstAddAPIReq:' + ssr.lstAddAPIReq);
            insert ssr.lstAddAPIReq;
        }
    }
    
    global void finish(Database.BatchableContext BC){
    }
}