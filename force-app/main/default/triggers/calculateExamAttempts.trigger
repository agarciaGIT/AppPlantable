trigger calculateExamAttempts on Exam_Attempt__c (before update, after insert,after update) {
    
    Object_Trigger_Switch__mdt metadataSwitch = Object_Trigger_Switch__mdt.getInstance('ExamAttemptMDT');
    System.debug('metadataSwitch::>>    '+metadataSwitch);
    Boolean runTrigger = False;
    if(metadataSwitch != null && !metadataSwitch.isActive__c && !Test.isRunningTest()){
        runTrigger = True;
    }
    
    if(Test.isRunningTest() && TestClassUtil.isOldTrigger == 'OLD' ){
        runTrigger = True;
    }
    
    if(runTrigger){
        
        
        List<Exam_Attempt__c> lstEAttempts = new List<Exam_Attempt__c>();
        Map<Id,Exam_Attempt__c> mapEA = new Map<Id,Exam_Attempt__c>();
        
        if(trigger.isUpdate)
        {
            for(Exam_Attempt__c obj : trigger.new)
            {
                if(trigger.oldMap.get(obj.Id).Result__c != obj.Result__c && obj.Result__c == 'Pass'&& obj.Result__c != '')
                    mapEA.put(obj.Candidate_Requirement__c,obj);
                else if(trigger.oldMap.get(obj.Id).Result__c != obj.Result__c && trigger.oldMap.get(obj.Id).Result__c == 'Pass')
                    mapEA.put(obj.Candidate_Requirement__c,obj);
            }
            
        }
        
        
        
        
        
        if(!mapEA.isEmpty())
        {
            
            List<Candidate_Requirement__c>  lstCR = new List<Candidate_Requirement__c>();
            for(Candidate_Requirement__c objCR : [select id,Name,Date_of_Completion__c,Status__c from Candidate_Requirement__c where id in: mapEA.keySet()])
            {
                Exam_Attempt__c objEA = mapEA.get(objCR.Id);
                if(objEA.Result__c == 'Pass')
                {
                    objCR.Date_of_Completion__c = mapEA.get(objCR.Id).Exam_Date__c;
                    objCR.Status__c = 'Completed';
                }
                else
                {
                    objCR.Date_of_Completion__c = null;
                    objCR.Status__c = null;
                }
                lstCR.add(objCR);
            }
            if(!lstCR.isEmpty())
                update lstCR;
        }
        try{
            Default_Settings__c atapsisetting = Default_Settings__c.getValues('Default');
            if(atapsisetting.ATA_PSI_Callout__c == true){
                
                system.debug('>>'+ATAPSIUtilClass.examRegistrationTriggerRecursion);
                if(ATAPSIUtilClass.examRegistrationTriggerRecursion == false){
                    if(trigger.isAfter && trigger.isInsert){
                        ExamRegistrationHandlerClass.ExamRegistration(trigger.new,null);
                    }
                    if(trigger.isAfter && trigger.isUpdate){
                        ExamRegistrationHandlerClass.ExamRegistration(trigger.new,trigger.oldMap);
                        
                    }
                    
                }
            }
        }catch(Exception ex){}
        if(ExamRegistrationHandlerClass.isCreateRateRecursive == false){
            if(trigger.isAfter && trigger.isUpdate){
                ExamRegistrationHandlerClass.createRateOffering(trigger.new,trigger.oldMap);
            }
        }
    }
}