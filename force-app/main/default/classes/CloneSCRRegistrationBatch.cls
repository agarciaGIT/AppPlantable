/* 
 * Exam Administration Id should be saved to ExamAdminIdForSCRCloneBatch custom label,
 * this will be saved in Exam_Administration__c field for cloned fields 
 * and also Exam Prts and Exam Sites are queried from this Exam Administration
 */
global class CloneSCRRegistrationBatch implements Database.Batchable<sObject>{
    private string examAdminId = System.Label.ExamAdminIdForSCRCloneBatch;
    private String recordId;
    public CloneSCRRegistrationBatch() {
        
    }
    public CloneSCRRegistrationBatch(string inputRecordId) {
        recordId = inputRecordId;
    }
	global Database.QueryLocator start(Database.BatchableContext BC){
        Set<String> rptExamType = new Set<String>{'SCR'};
        string intDataStatus = 'Paid Not Scheduled';
        string oppStageName = 'Closed';
        string candidateStatus = 'Activated';
        string deferredStatus = 'Pending';
        DescribeSObjectResult describeResult = Exam_Attempt__c.getSObjectType().getDescribe();  
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        
        String query = 'select Exam_Site__r.Name,' +String.join( fieldNames, ',' ) +' From Exam_Attempt__c where Defered__c =: deferredStatus AND Candidate_Commitment__r.status =: candidateStatus AND RPT_Exam_Program__c IN:rptExamType and Opportunity_StageName__c =: oppStageName and Cancelled__c != true';
        if(String.isNotBlank(recordId)) {
            query += ' AND Id=: recordId';
        }
        return Database.getQueryLocator(query); 
    }
    global void execute(Database.BatchableContext BC, List<Exam_Attempt__c> scope){
        List<Exam_Attempt__c> attemptsToUpdate = new List<Exam_Attempt__c>();
        List<Exam_Attempt__c> attemptsToInsert = new List<Exam_Attempt__c>();
        Set<String> examSiteNames = new Set<String>();
        for(Exam_Attempt__c ea : scope){
            ea.Cancelled__c = True;
            ea.Defered__c = 'Approved';
            ea.Deferral_Status__c ='Deferred Out';
            ea.Cancel_Reason__c ='Deferral';
            attemptsToUpdate.add(ea);
            examSiteNames.add(ea.Exam_Site__r.Name);
        }
        if(!attemptsToUpdate.isEmpty()){
            update attemptsToUpdate;
        }
        List<Exam_Part__c> examPartList = new List<Exam_Part__c>();
        if(!test.isRunningTest()){
        	examPartList = [Select Id,Exam_Administration__c, (Select Id,Name from Exam_Sites__r where Name IN:examSiteNames) from Exam_Part__c where Exam_Administration__c =: examAdminId];
        }else if(test.isRunningTest()){
            examPartList = [Select Id,Exam_Administration__c, (Select Id,Name from Exam_Sites__r where Name IN:examSiteNames) from Exam_Part__c Limit 1];
        }
        for(Exam_Attempt__c ea : scope){
            Exam_Attempt__c newAttempt = ea.clone(false,false,false,false);
            if(ea.Future_Free_Deferral__c){
                newAttempt.Free_Deferral__c = true;
            }else{
                newAttempt.Free_Deferral__c = false;
            }
            if(ea.Selected_To_Allow_Future_Deferral__c){
                newAttempt.Allow_Future_Deferral__c = true;
            }else{
                newAttempt.Allow_Future_Deferral__c = false;
            }
            newAttempt.Future_Free_Deferral__c = false;
            newAttempt.Selected_To_Allow_Future_Deferral__c = false;
            newAttempt.Cancelled__c = False;
            newAttempt.Defered__c = 'Approved';
            newAttempt.Deferral_Status__c = 'Deferred In';
            newAttempt.Exam_Administration__c = examAdminId;
            newAttempt.Exam_Part__c = examPartList[0].id;
            newAttempt.Exam_Site__c = examPartList[0].Exam_Sites__r[0].id;
            newAttempt.Cloned_From__c = ea.id;
            newAttempt.Other_Exam_Registrations__c = null;
            newAttempt.Seat_No__c = '';
            newAttempt.Room__c = null;
            newAttempt.Candidate_ID__c = null;
            newAttempt.Deferred_Exam_Administration__c = null;
            newAttempt.ATA_Cert_id__c = null;
            newAttempt.ATA_Cert_Type__c = null;
            newAttempt.ATA_Name_as_it_appears_on_ID__c = null;
            newAttempt.Updated_to_FRM_1__c = false;
            newAttempt.Name = '';
            newAttempt.Active_Integration_Data__c = null;
            newAttempt.Category_1__c = '';
            newAttempt.Category_2__c = ''; 
            newAttempt.Category_3__c = ''; 
            newAttempt.Category_4__c = ''; 
            newAttempt.Category_5__c = ''; 
            newAttempt.Category_6__c = ''; 
            newAttempt.Category_7__c = ''; 
            newAttempt.Category_8__c = ''; 
            newAttempt.Category_9__c = '';
            newAttempt.Quartile_1__c = null;
            newAttempt.Quartile_2__c = null;
            newAttempt.Quartile_3__c = null;
            newAttempt.Quartile_4__c = null;
            newAttempt.Quartile_5__c = null;
            newAttempt.Quartile_6__c = null;
            newAttempt.Quartile_7__c = null;
            newAttempt.Quartile_8__c = null;
            newAttempt.Quartile_8__c = null;
            attemptsToInsert.add(newAttempt);
         }
        if(!attemptsToInsert.isEmpty()){
            insert attemptsToInsert;
        }
    }
   	global void finish(Database.BatchableContext BC){
        
    }
}