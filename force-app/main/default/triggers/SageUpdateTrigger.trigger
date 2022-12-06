trigger SageUpdateTrigger on Sage_Updates__e (after insert) {
	try{
        SageUpdateTriggerHandler.updateOpportunity(trigger.new);
    }catch (Exception e) {
        string replayId = '';
        for(Sage_Updates__e evt : trigger.new){
            replayId += ':'+evt.ReplayId;
        }
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String receipientList = system.label.Exception_Recipient_List;
        List<String> toAddresses = new list<string>();
        toAddresses.addall(receipientList.split(','));
        mail.setToAddresses(toAddresses);
        mail.setSubject('Sage Update Event Trigger Failed: '+system.now());
        mail.setPlainTextBody('Sage Update Event Trigger Failed with error: '+e.getMessage()+':'+e.getStackTraceString()+'For Ids'+replayId);
        if(!test.isRunningTest())
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}