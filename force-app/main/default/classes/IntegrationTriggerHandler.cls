public class IntegrationTriggerHandler {
    public static void processIntegrations(List<Integration_Stream_Event__e> newEvents){
        List<Integration_Log__c> logList = new List<Integration_Log__c>();
        Map<String,Set<Id>> methodToRecordIDSet = new map<String,Set<Id>>();
        Integer recordCount = 0;
        for(Integration_Stream_Event__e evt : newEvents) {
            recordCount++;
            System.debug('Counter = '+ recordCount);    
            if (recordCount >=  15) {
                break;
            }
            else{
                if(String.isNotBlank(evt.Integration_Type__c)){
                    if(methodToRecordIDSet.containskey(evt.Integration_Type__c)){
                        Set<Id> recordIdSet = methodToRecordIDSet.get(evt.Integration_Type__c);
                        recordIdSet.add(evt.Record_Id__c);
                        methodToRecordIDSet.put(evt.Integration_Type__c,recordIdSet);
                    }else{
                        methodToRecordIDSet.put(evt.Integration_Type__c,new Set<Id>{evt.Record_Id__c});
                    }
                    
                    Integration_Log__c log = createLogRecord(evt,'Success');
                    logList.add(log);
                }
            }
            //platform event bus
            if(!Test.isRunningTest())
                EventBus.TriggerContext.currentContext().setResumeCheckpoint(evt.ReplayId);           
        }
        if(methodToRecordIDSet.containskey('ATA')){
            ATACallOutQueueable ataCallout = new ATACallOutQueueable(methodToRecordIDSet.get('ATA'));
            ID jobID = System.enqueueJob(ataCallout);
        }
        if(methodToRecordIDSet.containskey('PSI')){
            PSICallOutQueueable psiCallout = new PSICallOutQueueable(methodToRecordIDSet.get('PSI'));
            ID jobID = System.enqueueJob(psiCallout);
        }
        if(methodToRecordIDSet.containskey('RiskDotNet')){
            RiskDotNetQueueable riskDotNetContractCallout = new RiskDotNetQueueable(methodToRecordIDSet.get('RiskDotNet'));
            ID jobID = System.enqueueJob(riskDotNetContractCallout);
        }
        if(methodToRecordIDSet.containskey('PearsonVue')){
            PearsonVueCallOutQueueable pearsonSCRCallout = new PearsonVueCallOutQueueable(methodToRecordIDSet.get('PearsonVue'));
            ID jobID = System.enqueueJob(pearsonSCRCallout);
        }
        if(methodToRecordIDSet.containskey('provisionEvents')){
            provEventAndChptMtngs_Queueable evtMtngQueue = new provEventAndChptMtngs_Queueable('Events',methodToRecordIDSet.get('provisionEvents'));
            ID jobID = System.enqueueJob(evtMtngQueue);
        }
        if(methodToRecordIDSet.containskey('ChapterMeeting')){
            provEventAndChptMtngs_Queueable evtMtngQueue = new provEventAndChptMtngs_Queueable('ChapterMeetings',methodToRecordIDSet.get('ChapterMeeting'));
            ID jobID = System.enqueueJob(evtMtngQueue);
        }
        if(methodToRecordIDSet.containskey('FRM1EBook')){
            provisionEBooks_Queueable ebookQueue = new provisionEBooks_Queueable('FRM1',methodToRecordIDSet.get('FRM1EBook'),false,null);
            ID jobID = System.enqueueJob(ebookQueue);
        }
        if(methodToRecordIDSet.containskey('FRM2EBook')){
            provisionEBooks_Queueable ebookQueue = new provisionEBooks_Queueable('FRM2',methodToRecordIDSet.get('FRM2EBook'),false,null);
            ID jobID = System.enqueueJob(ebookQueue);
        }
        if(methodToRecordIDSet.containskey('SCREBook')){
            provisionEBooks_Queueable ebookQueue = new provisionEBooks_Queueable('SCR',methodToRecordIDSet.get('SCREBook'),false,null);
            ID jobID = System.enqueueJob(ebookQueue);
        }
        if(methodToRecordIDSet.containskey('ERP2EBook')){
            provisionEBooks_Queueable ebookQueue = new provisionEBooks_Queueable('ERP2',methodToRecordIDSet.get('ERP2EBook'),false,null);
            ID jobID = System.enqueueJob(ebookQueue);
        }
        if(methodToRecordIDSet.containskey('FRREBook')){
            provisionEBooks_Queueable ebookQueue = new provisionEBooks_Queueable('FRR',methodToRecordIDSet.get('FRREBook'),false,null);
            ID jobID = System.enqueueJob(ebookQueue);
        }
        if(methodToRecordIDSet.containskey('FRREBookANDYardStick')){
            provisionEBooks_Queueable ebookQueue = new provisionEBooks_Queueable('FRR',methodToRecordIDSet.get('FRREBookANDYardStick'),true,2737);
            ID jobID = System.enqueueJob(ebookQueue);
        }
        if(methodToRecordIDSet.containskey('FFREBook')){
            provisionEBooks_Queueable ebookQueue = new provisionEBooks_Queueable('FFR',methodToRecordIDSet.get('FFREBook'),true,2560);
            ID jobID = System.enqueueJob(ebookQueue);
        }
        
        if(!logList.isEmpty())
            insert logList;
    }
    
    public static Integration_Log__c createLogRecord(Integration_Stream_Event__e evt,string Status){
        Integration_Log__c log = new Integration_Log__c();
        log.Integration_Type__c = evt.Integration_Type__c;
        log.Event_Replay_Id__c = evt.ReplayId;
        log.Status__c = Status;
        log.Platform_Event_Type__c = 'Integration Stream Event';
        if(evt.Object_Name__c == 'Opportunity'){
            log.Opportunity__c = evt.Record_Id__c;
        }else if(evt.Object_Name__c == 'Contract'){
            if(evt.Integration_Type__c == 'PearsonVue'){
                log.Integration_Data__c = evt.Record_Id__c;
            }else{
                log.Program__c = evt.Record_Id__c;
            }
        }else if(evt.Object_Name__c == 'Exam_Attempt__c'){
            log.Integration_Data__c = evt.Record_Id__c;
        }
        
        return log;
    }
}