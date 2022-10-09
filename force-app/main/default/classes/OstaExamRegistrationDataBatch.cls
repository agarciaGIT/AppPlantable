global class OstaExamRegistrationDataBatch implements Database.Batchable<SObject>, Database.Stateful {

    public Set<OSTA_Exam_Registration_Data__c> ostaExamRegistrationData = new Set<OSTA_Exam_Registration_Data__c>();
    
    global Database.QueryLocator start(Database.BatchableContext bc){

        List<Exam_Date__c > examDates = Exam_Date__c.getAll().values();
        
        Set<Date> examDatesSet = new Set<Date>();

		examDatesSet.add(Date.valueOf(examDates[0].Date_String__c));
        
        String query = '';
        
        query += 'SELECT Id, Exam_Date__c, Exam_Site_Name__c, Candidate_Commitment__c, Section__c, Exam_Site__r.Exam__r.Exam_Group__c, Member__c ';
        query += 'FROM Exam_Attempt__c ';
        query += 'WHERE ';
        query += '(Section__c = \'FRM Part 1\' OR (Section__c = \'FRM Part 2\' AND Other_Exam_Registrations__c = null)) AND '; 
        query += 'Exam_Date__c IN :examDatesSet AND '; 
        query += '(Cancelled__c = false OR (Cancelled__c = true AND Defered__c = \'Approved\' )) AND ';
        query += 'Exam_Site_Name__c LIKE \'%China%\' AND ';
        query += '(NOT Exam_Site_Name__c LIKE \'%Hong Kong%\') AND '; 
        query += 'Candidate_Commitment__c != null';
        
        
        return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext bc, List<Exam_Attempt__c> scope){
        
        ostaExamRegistrationData.addAll(OstaExamRegistrationDataBackfill.run(scope));
                
    }
    
    global void finish(Database.BatchableContext bc){
        
        List<Exam_Date__c > examDates = Exam_Date__c.getAll().values();
        
        String html = '';

        html += '<p>Exam Date: ' + examDates[0].Date_String__c + '</p>';
        html += '</ br>';
        html += '<p>OSTA Exam Registration Data records missing: ' + ostaExamRegistrationData.size() + '</p>';
        html += '</ br>';
        html += '<p>--- OSTA Exam Registration Data ---</p>';
        html += '<pre>' + JSON.serializePretty(ostaExamRegistrationData) + '</pre>';
        
        if(!Test.isRunningTest()){
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            msg.setToAddresses(new List<String>{'david.lappert@garp.com', 'vivek.reddy@garp.com'});
            msg.setSubject('OSTA Exam Registration Data Backfill: Job Completed');
            msg.setHtmlBody(html);
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ msg });
        }
        
    }
    
}