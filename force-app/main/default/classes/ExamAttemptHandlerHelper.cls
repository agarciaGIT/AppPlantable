public class ExamAttemptHandlerHelper {
    
    public static void updateCandidateRequirement(Map<Id,Exam_Attempt__c> mapEA,List<Exam_Attempt__c> newExamRegList,Map<Id,Exam_Attempt__c> oldMap){
        
        List<Candidate_Requirement__c>  CR_ToUpdate = new List<Candidate_Requirement__c>();
        Map < Id,Candidate_Requirement__c > CRMap = new Map < Id,Candidate_Requirement__c > ();
        List < Contract > contractToUpdate = new List < Contract > ();
        Set <String> contractIdList = new Set <String> ();
        Set <String> examPartIdList = new Set <String> ();
        
        Id FRM_Program_Contract_RTId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract','FRM_Program');
        Id ERP_Program_Contract_RTId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract','ERP_Program');
        Id ICBRR_Program_Contract_RTId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract','ICBRR_Program');
        Id SCR_Program_Contract_RTId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract','SCR_Program');
        
        for(Exam_Attempt__c sObj : newExamRegList){
              contractIdList.add(sObj.Candidate_Commitment__c);
              examPartIdList.add(sObj.Exam_Part__c);             
        }
        
        Map<ID, Contract> ContractMap = new Map<ID, Contract>([SELECT Id, AccountId, recordTypeId, recordType.Name, Status, Membership_Type__c, ContractTerm, EndDate, StartDate, All_Requirements_Completed__c, All_Requirements_Completed_Date__c FROM Contract WHERE Id IN: contractIdList LIMIT 50000]);
        Map<ID, Exam_Part__c> ExamPartMap = new Map<ID, Exam_Part__c>([SELECT Id, Exam_End_Date__c,Exam_Start_Date__c FROM Exam_Part__c WHERE Id IN: examPartIdList LIMIT 50000]);
        Map<ID, Candidate_Requirement__c> initialCRMap = new Map<ID, Candidate_Requirement__c>([SELECT id,Name,Date_of_Completion__c,Status__c,Certificate_Sent_Date__c,RecordTypeId,Candidate_Commitment__c,Exam__c FROM Candidate_Requirement__c WHERE Id in: mapEA.keySet() LIMIT 50000]);
        
        for(Candidate_Requirement__c objCR : initialCRMap.Values()){
            Exam_Attempt__c objEA = mapEA.get(objCR.Id);
            if(objEA != null){
                if(objEA.Result__c == 'Pass'){
                    objCR.Date_of_Completion__c = mapEA.get(objCR.Id).Exam_Date__c;
                    objCR.Status__c = 'Completed';
                }
                else{
                    objCR.Date_of_Completion__c = null;
                    objCR.Status__c = null; 
                }
                CR_ToUpdate.add(objCR); 
            }
        }
        
        if(!CR_ToUpdate.isEmpty()){
            update CR_ToUpdate;
        }
        if (contractIdList.size() > 0) {
            
            for(Exam_Attempt__c ExamAttempt : newExamRegList){
                Contract objContract = ContractMap.get(ExamAttempt.Candidate_Commitment__c);
                Boolean isContractChanged = False;
                
                if(ExamAttempt.Section__c != 'SCR' && ExamAttempt.Result__c != oldMap.get(ExamAttempt.Id).Result__c  && ExamAttempt.Result__c == 'Pass'){
                    
                    
                    if(objContract != null && examAttempt.Result__c == 'Pass') {
                        
                        if ((ExamAttempt.Section__c == 'ERP Part II'|| ExamAttempt.Section__c == 'ERP') || (ExamAttempt.Section__c == 'FRM Part 2' || ExamAttempt.Section__c == 'FRM Full')) {
                            Date dtCurrentDay = ExamAttempt.Exam_Date__c;
                            Date dtEndDate = objContract.StartDate;
                            Integer iDiffMnths =dtEndDate.monthsBetween(dtCurrentDay);
                            objContract.ContractTerm = iDiffMnths + 60;
                            objContract.Status = 'Activated';
                            isContractChanged = True;
                        }
                        
                        else if (ExamAttempt.Section__c == 'FRM Part 1' || ExamAttempt.Section__c == 'ERP Part I') {
                            Date dtCurrentDay = ExamAttempt.Exam_Date__c;
                            Date dtEndDate = objContract.StartDate;
                            Integer iDiffMnths =dtEndDate.monthsBetween(dtCurrentDay);
                            objContract.ContractTerm = iDiffMnths + 48;
                            objContract.Status = 'Activated';
                            isContractChanged = True;
                        }
                    }
                }
                
                else if(ExamAttempt.Section__c == 'SCR'){
                    //'Mark scr program as completed' of 'SCR Completion' Process Builder
                    if(ExamAttempt.Opportunity_StageName__c == 'Closed' && ExamAttempt.Cancelled__c == False && ExamAttempt.Result__c == 'Pass'){
                        objContract.All_Requirements_Completed_Date__c = System.Today();
                        objContract.All_Requirements_Completed__c = True;
                        objContract.Status = 'Completed';
                        isContractChanged = True;
                    }
                    
                    //'Mark Scr Program for Discount' of 'SCR Completion' Process Builder
                    if(ExamAttempt.Result__c != 'Pass' && ExamAttempt.Cancelled__c == False && ExamAttempt.Opportunity_StageName__c == 'Closed' && ExamAttempt.Result__c != oldMap.get(ExamAttempt.Id).Result__c){
                        objContract.Eligible_For_Scr_Discount_Date__c = System.Today().addMonths(12);
                        objContract.Eligible_For_Scr_Discount__c = True;
                        objContract.Status = 'Expired';
                        isContractChanged = True;
                    }
                    
                    
                    //'SCR Deferal' of 'SCR Completion' Process Builder
                    if(ExamAttempt.Cancelled__c == False && (String.isNotBlank(ExamAttempt.Defered__c) || ExamAttempt.Defered__c != oldMap.get(ExamAttempt.Id).Defered__c)){
                        if(objContract.RecordTypeId == SCR_Program_Contract_RTId && objContract.Status == 'Activated'){
                            objContract.SCR_Deferred_Status__c = String.ValueOf(ExamAttempt.Defered__c);
                            isContractChanged = True;
                        }
                    }
                    
                    //'Update Date  scr' of 'SCR Completion' Process Builder
                    /*if(ExamAttempt.Exam_Part__c != null && ExamAttempt.Cancelled__c == False && ExamAttempt.Opportunity_StageName__c == 'Closed'){
                        if(objContract.RecordTypeId == SCR_Program_Contract_RTId && objContract.Status == 'Activated'){
                            objContract.SCR_End_Date__c = ExamPartMap.get(ExamAttempt.Exam_Part__c).Exam_End_Date__c;
                            objContract.SCR_Start_Date__c = ExamPartMap.get(ExamAttempt.Exam_Part__c).Exam_Start_Date__c;
                            isContractChanged = True;
                        }
                    }*/
                }
                if(isContractChanged){                
                        contractToUpdate.add(objContract);
                }
            }
        }
        if(contractToUpdate.size() > 0){
                update contractToUpdate;
        }
    }
    
    public static void callExamRegistrationHandlerClass(List<Exam_Attempt__c> newList,Map<Id,Exam_Attempt__c> oldMap){
        try{
            Default_Settings__c atapsisetting = Default_Settings__c.getValues('Default');
            if(atapsisetting.ATA_PSI_Callout__c == true){
                
                system.debug('ATAPSIUtilClass.examRegistrationTriggerRecursion>>   '+ATAPSIUtilClass.examRegistrationTriggerRecursion);
                if(ATAPSIUtilClass.examRegistrationTriggerRecursion == false){
                    ExamRegistrationHandlerClass.ExamRegistration(newList,oldMap);
                }
            }
        }
        catch(Exception ex){} 
    }
        
}