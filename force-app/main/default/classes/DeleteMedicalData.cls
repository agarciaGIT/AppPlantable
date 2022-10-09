public class DeleteMedicalData implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) { 
        Date CDate = Date.newInstance(Date.Today().year()-2, Date.Today().month(), Date.Today().Day());
        String query = 'Select id,Additional_Accommodations__c From Exam_Attempt__c where Registered_On__c >= :'+'CDate AND hasAccommodations__c = TRUE';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc,List<Exam_Attempt__c> scope) {
        List<Exam_Attempt__c> updateExamAttempt = new List<Exam_Attempt__c>();
        for (Exam_Attempt__c e : scope) {
            if(e.Additional_Accommodations__c != NuLL){
                e.Additional_Accommodations__c = NULL;
            }
            updateExamAttempt.add(e);
        }
        system.debug('updateExamAttempt=====>'+updateExamAttempt);
        update updateExamAttempt;
    }
    public void finish(Database.BatchableContext bc){ }
}