trigger IntegrationTrigger on Integration_Stream_Event__e (after insert) {
    try{
        IntegrationTriggerHandler.processIntegrations(trigger.new);
    }catch (Exception e) {
        string replayId = '';
        List<Integration_Log__c> logList = new List<Integration_Log__c>();
        for(Integration_Stream_Event__e evt : trigger.new){
            if(!test.isRunningTest()){
                Integration_Log__c log = IntegrationTriggerHandler.createLogRecord(evt,'Error');
                logList.add(log);
            }
            replayId += ':'+evt.ReplayId;
        }
        if(!logList.isEmpty())
            insert logList;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String receipientList = system.label.Exception_Recipient_List;
        List<String> toAddresses = new list<string>();
        toAddresses.addall(receipientList.split(','));
        mail.setToAddresses(toAddresses);
        mail.setSubject('Integration Stream Event Trigger Failed: '+system.now());
        mail.setPlainTextBody('Integration Stream Event Trigger Failed with Error: '+e.getMessage()+':'+e.getStackTraceString()+'For Ids'+replayId);
        if(!test.isRunningTest())
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}