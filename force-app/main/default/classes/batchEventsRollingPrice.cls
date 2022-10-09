global class batchEventsRollingPrice implements Database.Batchable<SObject>{

    public String mode;  

    global batchEventsRollingPrice(String mode){
        this.mode = mode;
    }    
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        system.debug('mode:' + mode);        
        if(mode != null) {
            return Database.getQueryLocator('select Id, Name, Days_Before_Window_Close_Warning__c, Grace_Period__c, Can_Pay_By_wire__c, Can_Register__c, Description__c, Cancellation_Policy__c, Event_Cancellation_Days__c, Program_Change__c, Events_Photography_Release__c, Last_Date_For_Registration__c, Last_Date_for_Wire_Check_Registration__c, Start_Date__c, End_Date__c, Address__c, VenueName__c, AddressMap_Image_URL__c, GL_Code__c, Product_Code__c from Event__c where Status__c = \'Active\' AND Can_Pay_By_wire__c = True AND ID = :mode');
        } else {
        	return Database.getQueryLocator('select Id, Name, Days_Before_Window_Close_Warning__c, Grace_Period__c, Can_Pay_By_wire__c, Can_Register__c, Description__c, Cancellation_Policy__c, Event_Cancellation_Days__c, Program_Change__c, Events_Photography_Release__c, Last_Date_For_Registration__c, Last_Date_for_Wire_Check_Registration__c, Start_Date__c, End_Date__c, Address__c, VenueName__c, AddressMap_Image_URL__c, GL_Code__c, Product_Code__c from Event__c where Status__c = \'Active\' AND Can_Pay_By_wire__c = True');
        }
        
        //return Database.getQueryLocator('select Id, Name, Days_Before_Window_Close_Warning__c, Grace_Period__c, Can_Pay_By_wire__c, Can_Register__c, Description__c, Cancellation_Policy__c, Event_Cancellation_Days__c, Program_Change__c, Events_Photography_Release__c, Last_Date_For_Registration__c, Last_Date_for_Wire_Check_Registration__c, Start_Date__c, End_Date__c, Address__c, VenueName__c, AddressMap_Image_URL__c, GL_Code__c, Product_Code__c from Event__c where Status__c = \'Active\' AND ID =:mode ');
    } 
    
    global void execute(Database.BatchableContext BC, List<Event__c> scope){
        List<Event__c> eventList = (List<Event__c>)scope;
        system.debug('eventList:' + eventList);
        
        List < Event_Rate__c > eventRateDetails  = new List<Event_Rate__c>();
        
        Map<Id,Event_Rate__c> mapMembRatetoEvent = new Map<Id,Event_Rate__c>();
        Map<Id,Decimal> mapNonMembRatetoEvent = new Map<Id,Decimal>();
        
        Map<Id,Event_Rate__c> mapMembRatetoEventWarning = new Map<Id,Event_Rate__c>();
        Map<Id,Decimal> mapNonMembRatetoEventWarning = new Map<Id,Decimal>();
        
        
        Map<Id,Event_Registration__c> mapMembOpptoReg = new Map<Id,Event_Registration__c>();
        Map<Id,Event_Registration__c> mapNonMembOpptoReg = new Map<Id,Event_Registration__c>();
        Map<Id,Id> mapOpptoEvent = new Map<Id,Id>();
        Map<Id,Decimal> mapOpptoEventRate = new Map<Id,Decimal>();
        Date currentDate = Date.today();
        Boolean isMember = false; 
        
        Map<ID,Event__c> mapEvent = new Map<ID,Event__c>();
        for(Event__c e :scope) {
            mapEvent.put(e.Id, e);
        }
        
        for(Event_Registration__c reg: [SELECT Id, Name, CreatedDate, Last_Date_Payment_Warning_Sent__c, Last_Date_For_Rate_Effectiveness__c, Last_Rate_Date__c, Contact__c, Event__c, Event__r.Name, Event__r.Event_Cancellation_Days__c, Event__r.Grace_Period__c, Event__r.Start_Date__c, Status__c, Opportunity__r.Id, Opportunity__r.stagename, Member_Email__c, Substitute_Attendant__c, Event_Paid_Date__c, RPT_Event_Date__c, RPT_Member__c, RPT_Membership_Type__c, RPT_Membership_Payment_Status__c FROM Event_Registration__c where Opportunity__r.stagename ='New Lead' and Event__r.id in :eventList])
        {
            if(reg.RPT_Member__c == true && reg.RPT_Membership_Payment_Status__c == 'In Good Standing') {
                isMember = true;
                mapMembOpptoReg.put(reg.Opportunity__c, reg);
                system.debug('isMemb:' + isMember);
                system.debug('isMembOpp:' + reg.Opportunity__c);
            } else {
                mapNonMembOpptoReg.put(reg.Opportunity__c, reg);  
            }
		}

		      
        for(Event_Rate__c rate: [select Id, Name, Event__c, Start_Date__c, End_Date__c, Event__r.Grace_Period__c, Member_Rate__c, Non_Member_Rate__c from Event_Rate__c where Event__r.id in :eventList Order By Start_Date__c])
        {
            
            system.debug('Rate:' + rate);
            
            Event__c fndEvt = mapEvent.get(rate.Event__c);
            if(fndEvt != NULL) {
                
                // Find Windows for Warnings
                if(fndEvt.Days_Before_Window_Close_Warning__c != NULL && currentDate + Integer.valueOf(fndEvt.Days_Before_Window_Close_Warning__c) == rate.End_Date__c) {
                    mapMembRatetoEventWarning.put(rate.Event__c, rate);
                    system.debug('Warning Rate:' + rate);
                }

                // Find Next Rate Windows
                if(rate.Start_Date__c != NULL && fndEvt.Grace_Period__c != NULL && currentDate > rate.Start_Date__c + Integer.valueOf(fndEvt.Grace_Period__c) && currentDate < rate.End_Date__c + Integer.valueOf(fndEvt.Grace_Period__c)) 
                {
                    eventRateDetails.add(rate);
                    mapMembRatetoEvent.put(rate.Event__c, rate);
                    system.debug('Next Rate:' + rate);
                }
            }
        }
        
        
        List<OpportunityLineItem> toUpdate = new List<OpportunityLineItem> ();
        List<Event_Registration__c> lstUpdateEventReg = new List<Event_Registration__c>();
        List<OpportunityLineItem> lstOppLines = [SELECT id,OpportunityId, Quantity, UnitPrice, TotalPrice, Opportunity.stagename, opportunity.Purchase_Date__c, opportunity.createddate, opportunity.amount, ProductCode FROM OpportunityLineItem where Opportunity.stagename ='New Lead' and OpportunityId in:mapMembOpptoReg.keyset() AND Product2.Family = 'Events' AND ProductCode != 'EVTDSC'];
        
        for(OpportunityLineItem oli :lstOppLines){
            
            system.debug('oli:' + oli);
            
            // Find Event
            Event_Registration__c fndReg = mapMembOpptoReg.get(oli.OpportunityId);
            if(fndReg != NULL) {
                
                system.debug('fndReg:' + fndReg);
                
                // Find Window for Warning
                Event_Rate__c fndRate = mapMembRatetoEventWarning.get(fndReg.Event__c);
                if(fndRate != NULL) {
                    fndReg.Last_Date_Payment_Warning_Sent__c = currentDate;
                    system.debug('Add fndReg Warning:' + fndReg);
                    lstUpdateEventReg.add(fndReg);
                }
               
                // Find Window to Roll To
                fndRate = mapMembRatetoEvent.get(fndReg.Event__c);
                
                // If fiund rate window and Event Reg was created before this wondow start date - move it
                if(fndRate != NULL && fndReg.CreatedDate < fndRate.Start_Date__c) {
                    oli.unitprice =  fndRate.Member_Rate__c;
                    toUpdate.add(oli);
                    system.debug('oli:' + oli);
                }
            }
        }
        
                
        for(OpportunityLineItem oli :lstOppLines){
           
            system.debug('oli:' + oli);
            
            // Find Event
            Event_Registration__c fndReg = mapNonMembOpptoReg.get(oli.OpportunityId);
            if(fndReg != NULL) {
                
                 system.debug('fndReg:' + fndReg);
                
                // Find Window for Warning
                Event_Rate__c fndRate = mapMembRatetoEventWarning.get(fndReg.Event__c);
                if(fndRate != NULL) {
                    fndReg.Last_Date_Payment_Warning_Sent__c = currentDate;
                    system.debug('Add fndReg Warning:' + fndReg);
                    lstUpdateEventReg.add(fndReg);
                }
               
                // Find Window to Roll To
                fndRate = mapMembRatetoEvent.get(fndReg.Event__c);
                
                // If fiund rate window and Event Reg was created before this wondow start date - move it
                if(fndRate != NULL && fndReg.CreatedDate < fndRate.Start_Date__c) {
                    oli.unitprice =  fndRate.Non_Member_Rate__c;
                    toUpdate.add(oli);
                    system.debug('oli:' + oli);
                }
            }
        } 
        
        system.debug('toUpdate:' + toUpdate);
        if(!toUpdate.isEmpty()){
            update toUpdate;    
        }

        system.debug('lstUpdateEventReg:' + lstUpdateEventReg);
        if(!lstUpdateEventReg.isEmpty()){
            update lstUpdateEventReg;    
        }
        
    } 
    
    global void finish(Database.BatchableContext BC){
        
    }
    
}