global class deleteHistoricIdDataBatch implements Database.Batchable<sObject>, Database.Stateful{
    private String examType;
    private string examGroupId = System.Label.DeleteHistoricDataBatchExamGroupId;
    private string scrProgramRecTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('SCR_Program').getRecordTypeId();
    public deleteHistoricIdDataBatch(string examType){
        this.examType = examType;
    }
	global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = '';
        if(examType == 'SCR'){
            query = 'Select Id,GARP_Member_Id__c,First_Name_as_it_Appears_on_ID__c,Middle_Name_as_it_Appears_on_ID__c,Last_Name_as_it_Appears_on_ID__c,Id_Type__c,Id_Number__c from Contact where First_Name_as_it_Appears_on_ID__c != null or Middle_Name_as_it_Appears_on_ID__c != null or Last_Name_as_it_Appears_on_ID__c != null or Id_Type__c != null or Id_Number__c != null';
        }else{
        	query = 'Select Id,GARP_Member_Id__c,Name_As_It_Appears_On_Id__c,Id_Type__c,Id_Number__c from Contact where Name_As_It_Appears_On_Id__c != null or Id_Type__c != null or Id_Number__c != null';
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> scope){
       	Set<String> garpIdSet = new Set<String>();
        Set<String> garpIdswithActiveRegistrations = new Set<String>();
        List<Contact> contactsToUpdate = new List<Contact>();
        List<Contract> contractsToUpdate = new List<Contract>();
        List<Exam_Attempt__c> attemptsToUpdate = new List<Exam_Attempt__c>();
        for(Contact con : scope){
            garpIdSet.add(con.GARP_Member_Id__c);
        }
        
        if(examType == 'SCR'){
            List<Contract> programList = [Select Id,Garp_Id__c,Status,Pearson_Member_First_Name__c,Pearson_Member_Middle_Name__c,Pearson_Member_Last_Name__c from Contract where Garp_Id__c IN: garpIdSet AND RecordTypeId =: scrProgramRecTypeId];
            for(Contract program : programList){
                if(program.Status == 'Activated' || program.Status == 'Activated ( Auto-Renew )'){
                    garpIdswithActiveRegistrations.add(program.GARP_ID__c);
                }else{
                    program.Pearson_Member_First_Name__c = '';
                    program.Pearson_Member_Middle_Name__c = '';
                    program.Pearson_Member_Last_Name__c = '';
                    contractsToUpdate.add(program);
                }
            }
            
            for(Contact cont : scope){
                if(!garpIdswithActiveRegistrations.contains(cont.Garp_Member_Id__c)){
                    cont.First_Name_as_it_Appears_on_ID__c = '';
                    cont.Middle_Name_as_it_Appears_on_ID__c = '';
                    cont.Last_Name_as_it_Appears_on_ID__c = '';
                    cont.Id_Type__c = null;
                    cont.Id_Number__c = '';
                    contactsToUpdate.add(cont);
                }
            }
        }else{
            List<Exam_Attempt__c> examAttemptList = [Select Id,Garp_Id__c, Cancelled__c, Result__c,Exam_Administration__c,Exam_Administration__r.Exam_Group__c from Exam_Attempt__c where Garp_Id__c IN: garpIdSet];
            
            for(Exam_Attempt__c ea : examAttemptList){
                if(ea.Exam_Administration__r.Exam_Group__c == examGroupId && ea.Result__c == null){
                    garpIdswithActiveRegistrations.add(ea.Garp_Id__c);
                //}else if(ea.Exam_Administration__r.Exam_Group__c != examGroupId){
                }else{
                    ea.ATA_Name_as_it_appears_on_ID__c = '';
                    ea.ATA_Cert_id__c = '';
                    ea.ATA_Cert_Type__c = '';
                    attemptsToUpdate.add(ea);
                }
            }
            
            for(Contact cont : scope){
                if(!garpIdswithActiveRegistrations.contains(cont.Garp_Member_Id__c)){
                    cont.Name_As_It_Appears_On_Id__c = '';
                    cont.Id_Type__c = null;
                    cont.Id_Number__c = '';
                    contactsToUpdate.add(cont);
                }
            }
        }
        
        if(!attemptsToUpdate.isEmpty()){
            update attemptsToUpdate;
        }
        
        if(!contractsToUpdate.isEmpty()){
            update contractsToUpdate;
        }
        
        if(!contactsToUpdate.isEmpty()){
            update contactsToUpdate;
        }
    }
    global void finish(Database.BatchableContext BC){
        
    }
}