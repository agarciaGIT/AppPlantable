trigger OppEmailLogPltEvtTrigger on Email_Log_ID_Carry__e (after Insert) {

 for(Email_Log_ID_Carry__e elid : Trigger.new){
        
         OppEmailLogFromPlatEve.callOppLog(elid.Oppid__c);
    }

}