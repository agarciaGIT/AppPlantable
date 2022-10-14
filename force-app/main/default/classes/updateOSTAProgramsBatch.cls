global class updateOSTAProgramsBatch implements Database.Batchable<sObject>{
    private String examAdminId;
    private Date uploadDate;
    private boolean dateUpdate;
    private boolean registrationUpdate;
    private string ostaRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('OSTA_Program').getRecordTypeId();
    public updateOSTAProgramsBatch(String adminId,string uploadDateStr,Boolean inputDateUpdate,Boolean inputRegistrationUpdate) {
        examAdminId = adminId;
        //Input date shiuld be in format yyyy-mm-dd;
        if(String.isNotBlank(uploadDateStr))
            uploadDate = date.valueOf(uploadDateStr);
        dateUpdate = inputDateUpdate;
        registrationUpdate = inputRegistrationUpdate;
    }
    global Database.QueryLocator start(Database.BatchableContext bc){
       return Database.getQueryLocator([Select Id,OSTA_Export_Exam_Part_I_Registration__c,
                                               OSTA_Export_Exam_Part_II_Registration__c,GARP_ID__c
                                        from Contract 
                                        where Status in ('Activated ( Auto-Renew )','Activated') AND RecordTypeId =: ostaRecordTypeId]); 
        
    }
    
    global void execute(Database.BatchableContext bc, List<Contract> scope){
        List<Contract> ostaProgramsToUpdate = new List<Contract>();
        Set<String> garpIdSet = new Set<String>();
        
        List<Exam_Attempt__c> registrationsList = new List<Exam_Attempt__c>();
        Map<String,Exam_Attempt__c> memberToPart1RegistrationsMap = new Map<String,Exam_Attempt__c>();
        Map<String,Exam_Attempt__c> memberToPart2RegistrationsMap = new Map<String,Exam_Attempt__c>();

        Set<String> garpIdSetWithReg = new Set<String>();
        Map<String,Exam_Attempt__c> memberToPart1OtherRegistrationsMap = new Map<String,Exam_Attempt__c>();
        Map<String,Exam_Attempt__c> memberToPart2OtherRegistrationsMap = new Map<String,Exam_Attempt__c>();
        
        
        //Get Garp Id's from OSTA Programs
        for(Contract osta : scope){
            if(String.isNotBlank(osta.GARP_ID__c)){
                garpIdSet.add(osta.GARP_ID__c);
            }
        }

        //Query Exam Registrations of the GARP Id's related to Input Exam Administration
        registrationsList = [Select Id,Section__c,Member__c,Garp_Id__c 
                             from Exam_Attempt__c 
                             where Reg_Status__c in ('Normal','Deferred In') AND Section__c in ('FRM Part 1','FRM Part 2') AND Garp_Id__c IN: garpIdSet AND Exam_Administration__c =: examAdminId];

        for(Exam_Attempt__c ea : registrationsList){
            if(ea.Section__c == 'FRM Part 1'){
                memberToPart1RegistrationsMap.put(ea.Garp_Id__c,ea);
            } else {
                memberToPart2RegistrationsMap.put(ea.Garp_Id__c,ea);
            }
        }
        
     	// Get Exam Reg with Results for all GARP ID to find other regs
        List<Exam_Attempt__c> registrationsOtherList = [Select Id,Section__c,Member__c,Garp_Id__c 
                             from Exam_Attempt__c 
                             where Result__c != NULL AND Reg_Status__c in ('Normal','Deferred In') AND Section__c in ('FRM Part 1','FRM Part 2') AND Garp_Id__c IN: garpIdSet Order By Exam_Date__c Desc];
        
        for(Exam_Attempt__c ea : registrationsOtherList){
            if(ea.Section__c == 'FRM Part 1') {
                if(!memberToPart1OtherRegistrationsMap.containskey(ea.GARP_ID__c)) {
                    memberToPart1OtherRegistrationsMap.put(ea.Garp_Id__c,ea);
                    garpIdSetWithReg.add(ea.Garp_Id__c);
                }
            } else {
                if(!memberToPart2OtherRegistrationsMap.containskey(ea.GARP_ID__c)) {
                    memberToPart2OtherRegistrationsMap.put(ea.Garp_Id__c,ea);
                    garpIdSetWithReg.add(ea.Garp_Id__c);
                }
            }
        }
        
        //Update OSTA fields on Programs
        for(Contract osta : scope){
            //Update Registration Fields
            if(registrationUpdate){
                osta.OSTA_Export_Exam_Part_I_Registration__c = null;
                osta.OSTA_Export_Exam_Part_II_Registration__c = null;
                if(memberToPart1RegistrationsMap.containskey(osta.GARP_ID__c)){
                    osta.OSTA_Export_Exam_Part_I_Registration__c = memberToPart1RegistrationsMap.get(osta.GARP_ID__c).id;
                }
                if(memberToPart2RegistrationsMap.containskey(osta.GARP_ID__c)){
                    osta.OSTA_Export_Exam_Part_II_Registration__c = memberToPart2RegistrationsMap.get(osta.GARP_ID__c).id;
                }
                ostaProgramsToUpdate.add(osta);
            }
            //Update Last Upload Date fields
            if(dateUpdate && uploadDate != null){
                if(memberToPart1RegistrationsMap.containskey(osta.GARP_ID__c) || memberToPart2RegistrationsMap.containskey(osta.GARP_ID__c)){
                    osta.OSTA_Last_Upload_Date__c = uploadDate;
                }
                ostaProgramsToUpdate.add(osta);
            }
        }
        
        // Set Other empty Registration to the latest one with results
        for(String garpID : garpIdSetWithReg){
            if(!memberToPart1RegistrationsMap.containskey(garpID) || !memberToPart2RegistrationsMap.containskey(garpID)) {
                // Find other Part I reg
                if(!memberToPart1RegistrationsMap.containskey(garpID)) {
                    if(memberToPart1OtherRegistrationsMap.containskey(garpID)) {
                        memberToPart1RegistrationsMap.put(garpID,memberToPart1OtherRegistrationsMap.get(garpID));
                    }
                } else {
                    if(memberToPart2OtherRegistrationsMap.containskey(garpID)) {
                        memberToPart2RegistrationsMap.put(garpID,memberToPart2OtherRegistrationsMap.get(garpID));
                    }                    
                }
            }
        }
        
        if(!ostaProgramsToUpdate.isempty()){
            contractSyncUtil.skipSyncTrigger = true;
            update ostaProgramsToUpdate;
        }
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
}