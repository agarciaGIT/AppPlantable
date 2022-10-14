global class CheckContactsBatch implements Database.Batchable<sObject>, Database.Stateful {
	global String csvColumnHeader;
    global List<String> csvRowValues = new List<String>();
	global String examType;
    global string JobRecordTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Candidate_Requirement__c', 'Job_Experience');
    public CheckContactsBatch(String inputExamType){
        examType = inputExamType;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = '';
        string recordTypeId;
        if(examType == 'FRM'){
            recordTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract','FRM_Program');
        }else if(examType == 'ERP'){
            recordTypeId = Recordtypehelper.getRecordTypeIdFromSchema('Contract', 'ERP_Program');
        }else if(examType == 'SCR'){
            recordTypeId = Recordtypehelper.getRecordTypeIdFromSchema('Contract', 'SCR_Program');
        }
        
        Set<String> statusSet = new Set<String>{'Completed'};
        if(test.isRunningTest()){
            query = 'SELECT Id,AccountId,Name,Status,All_Requirements_Completed__c,All_Requirements_Completed_Date__c, (Select Id,Status__c,Date_of_Completion__c,RecordTypeId from Candidate_Requirements__r where recordtypeid =: JobRecordTypeId) from Contract where Status IN: statusSet and RecordTypeId =: recordTypeId Limit 1';
        } else {
            query = 'SELECT Id,AccountId,Name,Status,All_Requirements_Completed__c,All_Requirements_Completed_Date__c, (Select Id,Status__c,Date_of_Completion__c,RecordTypeId from Candidate_Requirements__r where recordtypeid =: JobRecordTypeId) from Contract where Status IN: statusSet and RecordTypeId =: recordTypeId';
        }
        return Database.getQueryLocator(query);
    }
    
     global void execute(Database.BatchableContext BC, List<Contract> scope)
    { 
        String ContactId = '';
        String ProgramType = '';
        string GarpId ='';
        
        Map<Id,Date> accIdToCompletionDate = new Map<Id,Date>();
        for(Contract ct:scope){ 
            if(ct.All_Requirements_Completed_Date__c != null && ct.AccountId != null){
                if(examType == 'FRM' || examType == 'ERP'){
                    for(Candidate_Requirement__c cr : ct.Candidate_Requirements__r){
                        if(cr.RecordTypeId == JobRecordTypeId){
                            accIdToCompletionDate.put(ct.AccountId,cr.Date_of_Completion__c);
                        }
                    }
                
                }else if(examType == 'SCR'){
                	accIdToCompletionDate.put(ct.AccountId,ct.All_Requirements_Completed_Date__c);
                }
            }
        }
        
        List<Contact> contactList = [Select Id,GARP_Member_ID__c,AccountId,KPI_FRM_Certified_Date__c,KPI_ERP_Certified_Date__c,KPI_SCR_Completion_Date__c 
                                     from Contact 
                                     where GARP_Member_ID__c != null and AccountId IN: accIdToCompletionDate.keySet()];
        
        for(Contact con : contactList){
            if(examType == 'FRM'){
                if(con.KPI_FRM_Certified_Date__c != accIdToCompletionDate.get(con.AccountId)){
                    ContactId = con.Id; 
                    ProgramType = 'FRM';
                    GarpId = con.GARP_Member_ID__c;
                    String rowStr = ContactId +','+ProgramType+','+GarpId;  
                    csvRowValues.add(rowStr);
                }
            }else if(examType == 'ERP'){
                if(con.KPI_ERP_Certified_Date__c != accIdToCompletionDate.get(con.AccountId)){
                    ContactId = con.Id; 
                    ProgramType = 'ERP';
                    GarpId = con.GARP_Member_ID__c;
                    String rowStr = ContactId +','+ProgramType+','+GarpId;  
                    csvRowValues.add(rowStr);
                }
            }else if(examType == 'SCR'){
                if(con.KPI_SCR_Completion_Date__c != accIdToCompletionDate.get(con.AccountId)){
                    ContactId = con.Id; 
                    ProgramType = 'SCR';
                    GarpId = con.GARP_Member_ID__c;
                    String rowStr = ContactId +','+ProgramType+','+GarpId;  
                    csvRowValues.add(rowStr);
                }
            }
        }
    }
    
    global void finish(Database.BatchableContext BC)
    {
        if(!csvRowValues.isEmpty()){
            csvColumnHeader = 'ContactId,ProgramType,GarpId, \n';
            String csvFile = csvColumnHeader + String.join(csvRowValues,'\n');
            system.debug(csvFile);  
            
            Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
            blob csvBlob = Blob.valueOf(csvFile);
            string csvname= 'ContactDifferences.csv';
            csvAttc.setFileName(csvname);
            csvAttc.setBody(csvBlob);
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
            String receipientList = system.label.Exception_Recipient_List;
            List<String> toAddresses = new list<string>();
            toAddresses.addall(receipientList.split(','));
            String subject ='Contact Differences for '+examType;
            email.setSubject(subject);
            email.setToAddresses( toAddresses );
            email.setPlainTextBody('Contact Differences for '+examType);
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
            if(!test.isRunningTest()){
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            }
        }
    }
}