global class ATAIntegrationDataCheck_Batch implements Database.Batchable<sObject>, Database.Stateful {
    global String csvColumnHeader;
    global List<String> csvRowValues = new List<String>();
	global Database.QueryLocator start(Database.BatchableContext BC){
        String query;
        string examGroupId = 'a1c1W000004rkx2QAA';
        if(test.isRunningTest()){
            query = 'SELECT Id,ATA_region_code__c,ATA_region_name__c FROM Exam_Attempt__c LIMIT 1';
        } else {
            query = 'SELECT Id,ATA_region_code__c,ATA_region_name__c FROM Exam_Attempt__c where ATA_region_code__c != null AND ATA_region_name__c != null AND Exam_Administration__r.Exam_Group__c =: examGroupId';
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Exam_Attempt__c> scope){
        String ATACertType = '';
        String ATACertId = '';
        string Name ='';
        string IntDataId ='';
        string GarpId='';
        List<Integration_Data__c> intDataList = new List<Integration_Data__c>();
   		Set<Id> regIdSet = new Set<Id>();
        Map<String,Integration_Data__c> intDataToRegIdMap = new Map<String,Integration_Data__c>();
        String ataRecordTypeId = Schema.SObjectType.Integration_Data__c.getRecordTypeInfosByDeveloperName().get('ATA').getRecordTypeId();
        for(Exam_Attempt__c ea: scope){
            regIdSet.add(ea.id);
        }
        
        intDataList = [Select Id,Garp_Id__c,ATA_Cert_id__c,ATA_Cert_type__c,ATA_Name_as_it_appears_on_ID__c,Call_out_Type__c,Exam_Registrations__c
                      	from Integration_Data__c
                      	where Call_out_Type__c = 'Out-bound' AND Exam_Registrations__c IN: regIdSet AND RecordTypeId =: ataRecordTypeId
                      	Order By CreatedDate Desc];
        
        for(Integration_Data__c intd : intDataList){
            if(!intDataToRegIdMap.containskey(intd.Exam_Registrations__c)){
                IntDataId = intd.id;
                GarpId = intd.Garp_Id__c;
                Name = intd.ATA_Name_as_it_appears_on_ID__c.replace(',',' ');
                ATACertType = intd.ATA_Cert_type__c;
                ATACertId = intd.ATA_Cert_id__c;
                String rowStr = IntDataId+','+GarpId+','+Name +','+ATACertType+','+ATACertId;
                csvRowValues.add(rowStr);
                intDataToRegIdMap.put(intd.Exam_Registrations__c,intd);
            }
        }
    }
    global void finish(Database.BatchableContext BC){
        if(!csvRowValues.isEmpty()){
            csvColumnHeader = 'Integration Data Record Id,Garp Id,Name,ATA Cert Type,ATA Cert Id \n';
            String csvFile = csvColumnHeader + String.join(csvRowValues,'\n');
            system.debug(csvFile);  
            
            Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
            blob csvBlob = Blob.valueOf(csvFile);
            string csvname= 'ATACertDetails.csv';
            csvAttc.setFileName(csvname);
            csvAttc.setBody(csvBlob);
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
            String subject ='ATA Cert Details'+system.today();
            email.setSubject(subject);
            email.setToAddresses(new String[] { 'spuran.vaddiraju@garp.com','vivek.reddy@garp.com' } );
            email.setPlainTextBody('ATA Cert Details');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
            if(!test.isRunningTest()){
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            }
        }
    }
}