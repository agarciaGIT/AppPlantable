global class batchCorrect2015ExamAttempts implements Database.Batchable<sObject>,Database.StateFul{

    public String mode;
    
    global batchCorrect2015ExamAttempts(String mode){
        this.mode = mode;
    }    
    
    global Database.QueryLocator start(Database.BatchableContext BC){

        String sYear = '2015';
        String sStage = 'New Lead';
        String sReason = 'Expired';
        
        if(mode == null) {
            return Database.getQueryLocator('select Id, Name, Member__c, Garp_Id__c, Exam_Date__c, Reg_Status__c, Canceled_Reason_Type__c, Opportunity_StageName__c, Section__c from Exam_Attempt__c where RPT_Exam_Year__c = :sYear order by Member__c, Exam_Date__c, CreatedDate');            
        } else {
            return Database.getQueryLocator('select Id, Name, Member__c, Garp_Id__c, Exam_Date__c, Reg_Status__c, Canceled_Reason_Type__c, Opportunity_StageName__c, Section__c from Exam_Attempt__c where Canceled_Reason_Type__c = :sReason and Opportunity__c != null');             
        }
        
    }
    
    global void execute(Database.BatchableContext BC, List<Exam_Attempt__c> lstEA){

        
        if(mode == null) {
            Exam_Attempt__c lastEA = null;
            String lastKey = null;
            Boolean anyEAReal = false;
            List<Exam_Attempt__c> updateEA = new List<Exam_Attempt__c>();
            
            for(Exam_Attempt__c ea :lstEA) {
                String key = String.valueOf(ea.Member__c) + '~' + String.valueOf(ea.Exam_Date__c) + ea.Section__c;
                if(lastKey != key) {
                    if(lastEA != null && anyEAReal == false) {
                        //Cancelled checbox & Cancelled Reason = 'Expired'
                        lastEA.Canceled_Reason_Type__c = 'Expired';
                        updateEA.add(lastEA);
                    }
                    anyEAReal = false;
                    lastKey = key;
                    lastEA = null;
                }
                if(ea.Reg_Status__c == 'Cancelled' && ea.Opportunity_StageName__c != 'Closed') {
                    lastEA = ea;
                } else {
                    if(ea.Reg_Status__c != 'Cancelled' || (ea.Reg_Status__c == 'Cancelled' && ea.Opportunity_StageName__c == 'Closed'))
                        anyEAReal = true; 
                }
            }
            system.debug('updateEA:' + updateEA);
            update updateEA;
        } else {
            for(Exam_Attempt__c ea :lstEA) {
                ea.Canceled_Reason_Type__c = null;
            }
            update lstEA;
        }
    }
    
     global void finish(Database.BatchableContext BC){
   
   }
    
}